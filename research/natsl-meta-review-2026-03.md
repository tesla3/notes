# Meta-Review: Auditing Our NAtS-L Analysis

**Date:** 2026-03-27  
**Scope:** Cross-checking `natsl-review-2026-03.md` (consolidated review) and `nats-l-explainer.md` (FlashAttention gradient deep-dive) against source code (`~/gh_repo/NeuralAttentionSearchLinear/`), arXiv:2602.03681v1, and current literature.

---

## 1. Factual Error: The Gradient Mechanism Uses a Straight-Through Estimator

**Both documents claim there is no STE. The code proves otherwise.**

The review (§2.2) states:

> "no REINFORCE estimator, no straight-through heuristics"

The explainer repeats this:

> "no separate routing loss, no REINFORCE estimator, no straight-through heuristics"

This is **factually wrong**. The routing discretization uses `hard_softmax` (line 47, `natsl_attn_gdn.py`):

```python
def hard_softmax(logits, dim=-1):
    y_soft = logits.softmax(dim)
    index = y_soft.max(dim, keepdim=True)[1]
    y_hard = torch.zeros_like(logits).scatter_(dim, index, 1.0)
    ret = y_hard - y_soft.detach() + y_soft
    return ret
```

The pattern `y_hard - y_soft.detach() + y_soft` is the **textbook straight-through estimator**: forward pass uses `y_hard` (discrete one-hot), backward pass gets the gradient of `y_soft` (continuous softmax). The code even has `gumbel_softmax(hard=True)` as an alternative (`nats_sample_strategy == 'gumble'` [sic]).

The actual gradient pathway is:

```
loss → kernel backward (computes dnats per chunk) → STE backward (softmax Jacobian) → nats_layer weights
```

Where `dnats` is computed within the attention/GDN Triton kernels as a useful by-product (see §2 below), then propagated through the STE to the routing logits. The STE is the bridge between discrete routing decisions and continuous optimization.

**What the paper actually contributes** is not the absence of STE, but the computation of a *meaningful routing gradient signal* (`dnats`) within the existing FlashAttention/GDN backward kernels. The STE then propagates this signal back to the logits. This is still genuinely useful — the `dnats` gradient tells the model how much each chunk's assignment contributed to the loss — but it's not the "no STE" story our documents tell.

**Correction needed in both documents**: Replace claims of "no STE" with accurate description: "uses a straight-through estimator where the routing gradient signal is computed as a by-product of the existing attention/GDN backward kernels."

---

## 2. Both Branches Always Execute — Understated Training Cost Implication

Neither document makes this sufficiently clear: **in every NAtS-L layer, both the full softmax attention and the full GDN chunkwise operation execute on every forward pass**. Verified in `NAtSMixedAttentionGDN.forward()` (line ~498-520) and `NAtSMixedAttentionGDN.forward()` → `nats_mixed_attn_gdn()`:

- `parallel_attn_nats_fwd()` — runs FlashAttention over all attention-assigned KV blocks
- `chunk_gated_delta_rule_nats_fwd()` — runs GDN over all GDN-assigned chunks

The routing determines *which chunks' KV pairs participate in each operation's mask*, not *which operation runs*. Both Triton kernels launch every time. This is fundamentally different from MoE routing where only the selected expert executes.

The review (§3.4) notes "the dual-branch forward pass is inherently more expensive" but doesn't make explicit that this means every NAtS-L layer is roughly **attention + GDN cost**, not **max(attention, GDN) cost**. For a 6-layer NAtS-L Hybrid (15 GDN + 6 NAtS-L), each NAtS-L layer pays for two full attention mechanisms.

The CUDA stream parallelism in the recurrent inference mode (`stream_softmax_attn` and `stream_lattn` in `nats_mixed_attn_gdn_recurrent`) does overlap the two branches — so inference latency is closer to max(attn, GDN) — but training runs both sequentially through the autograd graph, and both consume memory for activations.

**Training cost gap is more serious than stated.** The review's §3.4 identifies this as a weakness but frames it too gently.

---

## 3. The Routing Gradient Is Partial — Neither Document Discusses This

The configs (`natsl_340M.json`, `natsl_760M.json`) both set:

```json
"compute_dnats_for_invalid_blocks_linear_att": false,
"compute_dnats_for_invalid_blocks_att": false
```

Tracing this through the code: when `compute_dnats_for_invalid_blocks=False`, the GDN backward kernel (`chunk_bwd_kernel_dkwg` in `chunk_o.py`, line ~464) **skips computing the routing gradient for chunks not assigned to GDN**. Similarly, the attention backward skips non-attention chunks.

This means the routing gradient for each operation type is computed **only for chunks that are already assigned to that operation**. The model learns "how valuable was this chunk's current assignment" but NOT "how valuable would this chunk have been under the alternative operation." This is analogous to the well-known problem in discrete routing (MoE, etc.) where partial gradients lead to suboptimal exploration.

When `compute_dnats_for_invalid_blocks=True`, the code DOES compute a "virtual" gradient: what the GDN update gradient would be IF the chunk were assigned to GDN (line ~476-492 in `chunk_o.py`). But this is disabled in the released configs. This design choice is unexplored in the paper and could affect routing quality.

**Gap in both documents**: Neither identifies this partial-gradient issue, which is a genuine limitation of the routing optimization.

---

## 4. Verified: RoPE Confound Is Real

The config confirms:

```json
"attn_apply_pos_encoding": false
```

For NAtS-L Hybrid, the softmax attention within NAtS-L layers operates **without positional encoding**. The code (line ~174) only initializes `self.rotary` when `attn_apply_pos_encoding=True`.

This means the softmax branch acts as global, position-invariant attention over its selected KV blocks. At extrapolation lengths, it doesn't suffer from RoPE frequency miscalibration. Our review's §3.1 identification of this confound is confirmed and, if anything, **understated** — the absence of RoPE doesn't just help extrapolation; it fundamentally changes what the softmax branch computes (content-only similarity vs. position-modulated similarity).

The fair test we recommended (GDN Hybrid without RoPE on its softmax layers) remains the single most critical missing control.

---

## 5. Architectural Detail the Explainer Gets Wrong: Head Dimensionality

The explainer states:

> "Both operations share the same Q, K, V projections — no extra parameters for separate attention heads."

This is correct about parameter sharing but elides a critical detail. From the config:

```json
"num_heads": 6,         # GDN heads
"num_attn_heads": 18,   # Softmax attention heads
"head_dim": 192         # Per-head dim for GDN
```

The same 1152-dim (`6 × 192`) QKV projection is **reshaped differently** for each branch:

- **GDN**: 6 heads × 192-dim keys → large, high-capacity heads
- **Softmax attention**: 18 heads × 64-dim keys → small, fine-grained heads

This is a GQA-style grouping: `attn_groups = 18/6 = 3` softmax heads per GDN head. Each GDN head's routing decision (per-chunk) applies to 3 softmax attention heads simultaneously.

The review's §4.2 ("GQA-style head grouping") mentions this but neither document discusses the **asymmetry**: softmax attention gets many small heads (fine-grained pattern matching with 64-dim dot products) while GDN gets few large heads (high-capacity associative memory with 192-dim states). This asymmetry is likely not an accident — it aligns with each mechanism's computational profile — but it's not discussed or ablated.

---

## 6. The "Column-Wise Sum" Gradient Claim Needs Nuance

The review (§2.2) characterizes the routing gradient as:

> "column-wise sums of the attention mask gradients"

From the Triton kernel `parallel_attn_bwd_kernel_dkdv` (attns.py, line ~875):

```python
b_dattn += tl.sum(tl.where(m_k[:, None], b_ds, 0))
```

where `b_ds = b_p * (b_dp - b_delta)` — the gradient of loss w.r.t. attention logits S. And `b_dattn` sums this over all query positions that attend to keys in this chunk. This IS a sum over the attention gradient matrix, so "column-wise sum" is approximately right for the attention branch.

For the GDN branch (`chunk_bwd_kernel_dkwg` in `chunk_o.py`, line ~443):

```python
b_nats_opt += tl.sum((b_k * b_dk) * exp(-b_g + b_g_last))
```

This is NOT a column-wise sum of any attention matrix. It's the decay-weighted dot product of keys with their gradient — measuring how much the hidden state update at this chunk affects downstream predictions. The "column-wise sum" framing doesn't generalize to the GDN branch at all.

**Both documents should clarify**: the attention branch gradient IS integrated into the existing FlashAttention backward (as an accumulator within the tiled computation), which is genuinely elegant. The GDN branch gradient is similarly integrated into the existing GDN backward. But characterizing both as "column-wise sums of attention mask gradients" conflates two different gradient signals.

---

## 7. The Last-Chunk Forcing Trick

In training (`natsl_attn_gdn.py`, line ~498):

```python
nats_op_types[:, -1] = 1  # Force last chunk to have both ops active
```

Every training sample forces the final chunk to be assigned to BOTH operations. This ensures both branches receive gradient signal from the boundary of the sequence, preventing either from starving. Neither document mentions this. It's a minor but informative implementation choice — it reveals that the authors found gradient starvation to be a practical concern with the routing.

---

## 8. Missing Related Work: Updated Assessment

### Confirmed gaps in the review:

1. **Based** (Arora et al., ICLR 2024) — correctly identified as the most important missing baseline. NAtS-L's chunk-level routing and Based's sliding-window approach represent two different strategies for the same recall-throughput tradeoff. Based at 1.3B/100B tokens would be the natural comparison point.

2. **State Rank Dynamics in Linear Attention LLMs** (arxiv 2602.02195) — concurrent work finding *"State Rank Stratification: a distinct spectral bifurcation among linear attention heads"* in Qwen3-Next. This is directly relevant: NAtS-L's finding that some heads are pure-linear while others use significant softmax may reflect the same phenomenon — low-rank heads don't need softmax because they're doing compression (aggregation), while high-rank heads need softmax for precise retrieval. This connection would strengthen both papers.

### New gaps identified:

3. **A Provable Expressiveness Hierarchy in Hybrid Linear-Full Attention** (arxiv 2602.01763, Feb 2026) — concurrent theoretical work proving *"the first provable separation between hybrid attention and standard full attention."* NAtS-L's empirical finding that no head uses pure softmax, and that the hybrid mix outperforms both pure types, is consistent with this theoretical result. Should be cited.

4. **RAttention: Towards the Minimal Sliding Window Size in Local-Global Attention Models** (arxiv 2506.15545) — finds that a sliding window of just 512 tokens matches full attention at 3B and 12B scale. This asks a complementary question to NAtS-L: instead of "which chunks need softmax?" (NAtS-L), "how small can the local window be?" (RAttention). Both explore the minimal softmax budget needed.

5. **Alleviating Forgetfulness of Linear Attention by Hybrid Sparse Attention** (arxiv 2510.20787) — directly addresses linear attention's forgetfulness with a different hybrid strategy. Relevant context for NAtS-L's softmax branch serving as the "anti-forgetting" mechanism.

---

## 9. What the Review Gets Right

Several claims are **confirmed and well-supported** by code:

1. **The RoPE confound** (§3.1): Confirmed by config. This remains the most important interpretive issue.

2. **Static depth schedule ablation** (§3.3): Still the most important missing experiment. The code's `gdn_layers` config shows that layers 3, 7, 11, 15, 19, 20 are NAtS-L — a roughly uniform distribution with a bias toward deeper layers (layer 19 and 20 are both NAtS-L). This is consistent with the paper's Figure 6 finding that deeper layers use more softmax.

3. **Length extrapolation** (§2.3): The strongest empirical result, though confounded by RoPE. The code's inference paths (chunk mode, recurrent mode) are well-implemented for variable-length inference.

4. **Decay for non-GDN blocks** (§2, explainer): Confirmed by `decay_for_non_gdn_blocks: true`. The GDN hidden state is decayed even through softmax-assigned chunks, forcing the linear branch toward recency.

5. **Scale limitation** (§3.2): Configs confirm 340M and 760M models (the paper reports these as 380M and 800M, likely including embedding parameters). The GDN backbone was validated at 1.3B/100B tokens — a reachable scale.

6. **Shared QKV projections** (§3.7): Confirmed. Same linear layers, different reshaping per branch.

---

## 10. Synthesis: What We Missed

The biggest gap in our analysis is the **failure to read the source code for the gradient mechanism**. The STE error propagated through both documents because we took the paper's description at face value. Source code is the ground truth.

The second gap is the **partial gradient issue** — the released configs disable gradient computation for non-assigned chunks, which limits the routing optimizer's ability to explore alternative assignments. Combined with the STE, this means the routing gradient is: (1) computed only for the current assignment, (2) propagated through a softmax relaxation, (3) used to update a linear scoring function. This is a reasonable engineering choice but has known limitations in discrete optimization, and it's worth discussing whether the routing converges to a good optimum or merely a stable one.

The third gap is **training cost concreteness**. Both documents flag this as a weakness but don't quantify it. A back-of-the-envelope calculation: each NAtS-L layer runs FlashAttention over ~softmax_fraction × L² and GDN over L, plus scoring overhead. A GDN Hybrid layer runs just one of these. With 6 NAtS-L layers out of 21, the overhead is bounded but nontrivial — and the paper's silence on wall-clock training time is more concerning than our review conveys.

---

## Summary of Required Corrections

| Issue | Severity | Document(s) |
|-------|----------|-------------|
| STE is used; "no STE" claim is false | **High** | Both |
| GDN routing gradient is not "column-wise sum of attention mask" | Medium | Review §2.2, Explainer |
| Both branches always execute (not MoE-style) | Medium | Both (understated) |
| Partial gradient from disabled `compute_dnats_for_invalid_blocks` | Medium | Neither (gap) |
| Head dimensionality asymmetry (64-dim attn vs 192-dim GDN) | Low | Explainer (omission) |
| Last-chunk forcing trick | Low | Neither (omission) |
| New related work (provable hierarchy, RAttention, state rank) | Low | Review §5 |

---

*Cross-referenced against: arXiv:2602.03681v1, source code commit at github.com/automl/NeuralAttentionSearchLinear (local clone), configs natsl_340M.json and natsl_760M.json, and web search results as of 2026-03-27.*
