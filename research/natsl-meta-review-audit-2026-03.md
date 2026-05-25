# Audit of the NAtS-L Meta-Review

**Date:** 2026-03-27  
**Scope:** Critical review of `natsl-meta-review-2026-03.md`, cross-checked against source code (`~/gh_repo/NeuralAttentionSearchLinear/`), `nats-l-explainer.md`, and current literature.

---

## Verdict

The meta-review is **strong overall** — it catches a genuine factual error (the STE), identifies real gaps (partial gradient, RoPE confound), and correctly reads the Triton kernels. But it contains one significant analytical error (§2, training cost), misses several relevant concurrent papers, and leaves a few code-level details unexamined.

---

## 1. Confirmed: STE Is Real (§1 of meta-review) ✓

The meta-review correctly identifies `hard_softmax` as textbook STE. Verified in source:

```python
# natsl_attn_gdn.py, line ~47
def hard_softmax(logits, dim=-1):
    y_soft = logits.softmax(dim)
    index = y_soft.max(dim, keepdim=True)[1]
    y_hard = torch.zeros_like(logits).scatter_(dim, index, 1.0)
    ret = y_hard - y_soft.detach() + y_soft   # ← STE pattern
    return ret
```

Forward: discrete `y_hard`. Backward: continuous `y_soft` Jacobian. The `nats_sample_func` defaults to `hard_softmax` unless `nats_sample_strategy == 'gumble'` (sic), in which case it uses `gumbel_softmax(hard=True)` — also an STE variant.

The gradient flow is:

```
loss → kernel backward (computes dnats per chunk) → STE backward (softmax Jacobian) → nats_layer weights
```

Both the explainer and review claiming "no STE" are wrong. The meta-review's correction is accurate. What the paper actually contributes is the *integration of the routing gradient signal into existing backward kernels*, not the absence of STE.

**No correction needed to meta-review §1.**

---

## 2. WRONG: Training Cost Analysis Is Overstated (§2 of meta-review) ✗

This is the meta-review's most significant error.

### What the meta-review claims

> "in every NAtS-L layer, both the full softmax attention and the full GDN chunkwise operation execute on every forward pass"
>
> "every NAtS-L layer is roughly **attention + GDN cost**, not **max(attention, GDN) cost**"
>
> "Training cost gap is more serious than stated."

### What the code actually does

The attention Triton kernel (`parallel_nats_attn_fwd_kernel`) iterates only over **softmax-assigned KV blocks**, not the full sequence. The critical inner loop (attns.py, ~line 182):

```python
for i_iter in tl.range(0, b_n_iters):           # b_n_iters = number of attn-assigned NAtS blocks
    b_o_nats_block = tl.load(nats_block_indices + i_iter * stride_block_types_t)
    i_s0 = b_o_nats_block * NAtS_BLOCK_SIZE      # jump to the assigned block's KV position
    for i_iter_nats in range(0, N_CHUNK_PER_NAtS_BLOCK):
        i_s = i_s0 + i_iter_nats * BS
        # ... load K, V at position i_s, compute attention scores with Q
```

`b_n_iters` is precomputed by `compute_attn_n_iters_per_block()` — it counts the number of attention-assigned NAtS blocks visible to each query tile. The kernel **skips** non-attention blocks entirely; it doesn't mask them to zero — it never loads their K/V at all.

Similarly, the GDN kernel processes all positions but at O(L) cost (recurrent state maintenance), not O(L²).

### Corrected cost analysis

Per NAtS-L layer, where *f* is the fraction of chunks routed to softmax:

| Component | Cost | Notes |
|-----------|------|-------|
| Softmax attention | O(*f* · L²) | All queries attend to *f*·L KV pairs (causal ≈ *f*·L²/2) |
| GDN state update | O(L) | Linear-time recurrent, processes all positions |
| GDN state decay for non-GDN chunks | O(L) | Applies `decay_for_non_gdn_blocks` |
| Routing scoring | O(L) | Mean-pool + linear per NAtS block (negligible) |
| **Total per NAtS-L layer** | **O(*f* · L²) + O(L)** | |

Compare this to the GDN Hybrid (3:1) it replaces:

| Layer type | Cost | Count | Total |
|-----------|------|-------|-------|
| GDN layer | O(L) | 15 | 15·O(L) |
| Full softmax layer | O(L²) | 6 | 6·O(L²) |
| **GDN Hybrid total** | | | **6·L² + 15·L** |

For NAtS-L Hybrid:

| Layer type | Cost | Count | Total |
|-----------|------|-------|-------|
| GDN layer | O(L) | 15 | 15·O(L) |
| NAtS-L layer | O(*f*·L²) + O(L) | 6 | 6·*f*·L² + 6·L |
| **NAtS-L Hybrid total** | | | **6·*f*·L² + 21·L** |

**If *f* < 1 (which the paper's Figure 6 shows it always is — no head uses pure softmax), NAtS-L Hybrid is CHEAPER in FLOPs than the GDN Hybrid it's compared to.** The paper reports mean softmax fractions around 0.25–0.40 depending on dataset and head. At *f*=0.3, NAtS-L Hybrid costs roughly 1.8·L² versus 6·L², or **3.3× fewer attention FLOPs**.

### What IS true about overhead

The overhead is real but comes from different sources than the meta-review claims:

1. **Two kernel launches per layer** — startup overhead, not proportional to L²
2. **Memory for two output tensors** per NAtS-L layer (o_gated_delta, o_attn)
3. **Routing scoring** — mean-pool + linear + hard_softmax per NAtS block
4. **FusedMultiInputRMSNormGated** combination step — additional Triton kernel
5. **Both backward kernels** — same story as forward: attention backward only processes attention-assigned blocks

The meta-review's conclusion should be **inverted**: NAtS-L's training cost is likely **lower** than GDN Hybrid per step (fewer attention FLOPs), at the expense of some kernel overhead and memory for dual outputs. The paper's silence on wall-clock training time may simply reflect that the comparison isn't unfavorable.

**Required correction:** §2 should be rewritten. Replace "Training cost gap is more serious than stated" with an accurate FLOP analysis showing NAtS-L layers are cheaper than full softmax layers.

---

## 3. Confirmed: Partial Gradient Issue (§3 of meta-review) ✓

Both configs set:
```json
"compute_dnats_for_invalid_blocks_linear_att": false,
"compute_dnats_for_invalid_blocks_att": false
```

Verified in the GDN backward kernel (`chunk_o.py`, ~line 444 vs ~line 464):

- **When chunk IS assigned to GDN** (`chunk_is_delta = True`):
  ```python
  b_nats_opt += tl.sum((b_k * b_dk) * tl.where(m_t, tl.exp(-b_g + b_g_last), 0)[:, None])
  ```
  Computes the actual gradient: decay-weighted dot product of keys with their gradients.

- **When chunk is NOT assigned to GDN** (`chunk_is_delta = False`):
  - If `COMPUTE_DNATS_FOR_INCOMPLETE_SCORES = True`: computes a *virtual* gradient `b_dk_virtual` — what the gradient would have been if this chunk were GDN-assigned (line ~476-489).
  - If `COMPUTE_DNATS_FOR_INCOMPLETE_SCORES = False` (the default): **skips entirely** — `b_nats_opt` stays 0 for this chunk.

This is the well-known **partial gradient problem** in discrete routing: the model only learns how good the current assignment is, never how good the alternative would be. In MoE literature, this leads to "rich get richer" dynamics where early assignments become self-reinforcing.

The meta-review correctly identifies this as a genuine limitation. Neither the explainer nor the review discusses it.

However, a nuance the meta-review doesn't mention: the authors clearly *implemented* the counterfactual gradient (`COMPUTE_DNATS_FOR_INCOMPLETE_SCORES = True`) but *disabled* it in released configs. This suggests they tested it and found it unhelpful or destabilizing — potentially because the virtual gradient introduces noise (it's computing "what would have happened" without the actual routing decision, which may not accurately reflect the true counterfactual).

**No correction needed, but add the nuance about deliberate disabling.**

---

## 4. Confirmed: RoPE Confound (§4 of meta-review) ✓

Both configs: `"attn_apply_pos_encoding": false`. The `rotary` embedding is only initialized when `attn_apply_pos_encoding=True` (natsl_attn_gdn.py, ~line 174):

```python
if self.attn_apply_pos_encoding:
    self.rotary = RotaryEmbedding(dim=self.head_attn_k_dim, base=self.attn_rope_theta)
else:
    self.rotary = None
```

The softmax branch computes **position-invariant content similarity**. At extrapolation lengths, it doesn't suffer from RoPE frequency miscalibration — making the extrapolation comparison with GDN Hybrid (which uses RoPE in its full softmax layers) unfair.

The meta-review's recommendation for a control experiment (GDN Hybrid without RoPE on its softmax layers) remains the single most important missing experiment for interpreting the extrapolation results.

**No correction needed.**

---

## 5. Confirmed with Nuance: Head Dimensionality (§5 of meta-review) ✓

760M config: `num_heads: 6`, `num_attn_heads: 18`, `head_dim: 192`:
- GDN: 6 heads × 192-dim = 1152-dim QKV
- Softmax: 18 heads × 64-dim = 1152-dim QKV (same projection, different reshaping)
- `attn_groups = 18/6 = 3` softmax heads per GDN head (GQA-style)

340M config: `num_heads: 6`, `num_attn_heads: 12`, `head_dim: 128`:
- GDN: 6 heads × 128-dim = 768-dim QKV
- Softmax: 12 heads × 64-dim = 768-dim QKV
- `attn_groups = 12/6 = 2`

The meta-review correctly identifies the asymmetry. **Additional observation**: the softmax head dimension is fixed at 64 across both model sizes (768/12 = 64; 1152/18 = 64), while GDN head dimension scales with model size (128 → 192). This means scaling up preferentially increases GDN capacity, not softmax granularity — an implicit assumption that the GDN state bottleneck is the binding constraint at scale.

**No correction needed, but the scaling asymmetry is worth noting.**

---

## 6. Confirmed: Gradient Signal Nuance (§6 of meta-review) ✓

Attention branch gradient (attns.py, ~line 875):
```python
b_ds = b_p * (b_dp - b_delta)    # gradient of loss w.r.t. attention logits S
b_dattn += tl.sum(tl.where(m_k[:, None], b_ds, 0))   # sum over query positions
```

This IS a sum over the attention gradient matrix — "column-wise sum" is approximately right (it sums along the query dimension for each key position, then sums again over all visible query tiles across the kernel's loop iterations).

GDN branch gradient (chunk_o.py, ~line 440):
```python
b_nats_opt += tl.sum((b_k * b_dk) * tl.where(m_t, tl.exp(-b_g + b_g_last), 0)[:, None])
```

This is a **decay-weighted inner product of keys with their loss gradient** — measuring how much each key's contribution to the recurrent state update affects downstream loss. It is NOT a column-wise sum of any attention matrix.

The meta-review correctly identifies this distinction.

**No correction needed.**

---

## 7. Confirmed: Last-Chunk Forcing (§7 of meta-review) ✓

Training mode (natsl_attn_gdn.py, ~line 498):
```python
if mode == 'chunk' and self.training:
    nats_op_types[:, -1] = 1    # shape: [batch, TNAtS, num_nats_head, n_ops]
```

All heads, both op types set to 1 for the final chunk. Both branches process it, ensuring gradient signal flows to both. Also present in chunk inference mode (line ~510):
```python
nats_op_types[:, -1] = 1
```
with the original assignment saved to `op_type_last_chunk` for post-inference correction.

The meta-review's inference about gradient starvation is plausible — this is a common issue in discrete routing (see MoE load-balancing losses), and the forcing trick is a lightweight alternative.

**No correction needed.**

---

## 8. Missing Related Work: Additional Gaps Found

The meta-review identifies five related work gaps. All are real. I found four more:

### 8a. Untangling Component Imbalance (arxiv 2510.05901, ICLR 2026)

> "We identify a critical flaw: existing hybrid methods inadvertently bypass the linear component, relying almost entirely on SWA."

This paper (Wang et al., "Paying Attention to Hybrid Attention") finds that in *converted* hybrid models (Transformer → hybrid), the linear attention component is often bypassed. The model routes information almost entirely through sliding-window attention, rendering the linear component dead weight.

**Direct relevance to NAtS-L:** If hybrid models can degenerate to single-component dependence, NAtS-L faces the same risk in the opposite direction — the routing could converge to a state where one branch dominates. The paper's Figure 6 suggests this doesn't happen (both branches are used), but this prior provides theoretical motivation for why monitoring the softmax fraction is important, and why auxiliary balance losses (which NAtS-L deliberately avoids) might become necessary at scale.

### 8b. SALA: Sparse Attention and Linear Attention (arxiv 2602.11761)

A 9B-parameter hybrid combining InfLLM-V2 (sparse attention) with Lightning Attention (linear attention). Relevant because:
- It operates at a significantly larger scale than NAtS-L (9B vs 800M)
- It uses **sparse** attention (not full softmax) as the retrieval mechanism — a fundamentally different cost tradeoff
- It demonstrates that the linear+retrieval hybrid idea works at scale, but with a different architecture

NAtS-L's softmax branch is full (not sparse) within its assigned chunks, so its cost scales quadratically with the number of attention-assigned KV pairs. SALA uses sparse attention to avoid this.

### 8c. LoLA: Low-Rank Linear Attention with Sparse Caching (arxiv 2505.23666)

> "LoLA distributes past key-value pairs from context into three memory systems: (i) recent pairs in a local sliding window cache; (ii) difficult-to-memorize pairs in a sparse, global cache; (iii) generic pairs in the recurrent hidden state of linear attention."

LoLA's three-way partition is conceptually similar to NAtS-L's two-way routing: both separate KV pairs into "needs full attention" vs "can be compressed." LoLA does this at inference time based on memorization difficulty; NAtS-L does it at training time based on learned scores. LoLA adds a critical third category: "recent" (sliding window), which NAtS-L handles implicitly through GDN's recency bias via `decay_for_non_gdn_blocks`.

### 8d. KL-Guided Layer Selection for Hybrid Distillation (arxiv 2512.20569)

> "This paper describes a simple and efficient recipe for layer selection that uses layer importance scores derived from a small amount of training on generic text data."

Uses KL-divergence between the full-attention output and the linear-attention output to decide which layers should keep full attention. This is a static, post-hoc version of NAtS-L's dynamic routing — it answers "which layers need softmax?" rather than "which chunks within a layer need softmax?" Relevant as the layer-level analogue of NAtS-L's chunk-level approach.

---

## 9. Observations the Meta-Review Misses

### 9a. `attn_with_short_conv: true` — Shared Convolutions

Both configs set `attn_with_short_conv: true`. The code (natsl_attn_gdn.py, ~line 340-360) shows that when this is true:

```python
if self.attn_with_short_conv:
    q, conv_state_q = self.q_conv1d(x=self.q_proj(hidden_states), ...)
    k, conv_state_k = self.k_conv1d(x=self.k_proj(hidden_states), ...)
    v, conv_state_v = self.v_conv1d(x=self.v_proj(hidden_states), ...)
    q_attn = q      # same as GDN q
    k_attn = k      # same as GDN k
    v_attn = v      # same as GDN v
```

Both branches receive **identical** post-convolution representations. The short convolution applies local smoothing (kernel_size=4) before the QKV are reshaped into different head configurations. This means:
- The **same** convolved features are seen at 64-dim (attention) and 192-dim (GDN) granularity
- The routing decision is made on **pre-convolution** hidden states (the routing uses `hidden_states` directly, not the convolved version)
- Local context (from the conv) is baked into both branches equally

When `attn_with_short_conv: false` (the alternative path in the code), the attention branch gets raw QKV projections (no convolution), while the GDN branch gets convolved QKV. The configs choose to share, which is the less-explored option.

### 9b. `ops_for_incomplete_chunks: "all"` — Incomplete Chunks Get Both Operations

Both configs set `"ops_for_incomplete_chunks": "all"`. When the sequence length isn't a multiple of `nats_block_size` (64), the final incomplete chunk gets **both** softmax and GDN applied, regardless of the routing decision. This is separate from the last-chunk forcing trick (which forces the last *complete* chunk to have both ops).

This means: for non-multiples of 64, up to 63 tokens always get dual processing. A minor but relevant implementation detail for benchmarking.

### 9c. The `@torch.compile` on `torch.autograd.Function`

```python
@torch.compile
class NAtSMixedAttentionGDN(torch.autograd.Function):
```

Applying `torch.compile` to an `autograd.Function` subclass is unconventional. In standard PyTorch, `autograd.Function` uses `.apply()` as the entry point, which goes through the autograd dispatcher, not the standard `__call__` mechanism that `torch.compile` wraps. This likely has no effect or minimal effect — the actual heavy lifting happens in hand-written Triton kernels inside the forward/backward methods. But it signals that the code may have been refactored without removing obsolete decorators.

### 9d. Output Combination Is More Sophisticated Than Described

The `FusedMultiInputRMSNormGated` module applies:
1. **Separate** RMS normalization with **separate** learned affine transforms (`weight1`, `weight2`) to each branch output
2. Q-derived weights (`o_weights`, shape `[batch, T, num_attn_heads, 2]`, softmax over the op dimension) applied **after** normalization
3. A **SiLU gating** mechanism using the gate projection (`g_proj`)

The combination is:
```
o = SiLU(g) * (w_attn * RMSNorm₁(o_attn) + w_gdn * RMSNorm₂(o_gdn))
```

Neither document captures the full combination pipeline. The separate affine transforms per branch (`weight1` ≠ `weight2`) mean the model can learn different scale/shift patterns for each branch's output — a degree of freedom beyond simple "weighted sum after normalization."

### 9e. Softmax Fraction Monitoring

The code tracks the softmax fraction during training:
```python
self.attn_fraction = (n_nats_blocks.float()[..., 0] / nats_op_types.shape[1]).mean(0).detach()
```

This is stored per-layer and could be logged, but neither document discusses whether/how the softmax fraction evolves during training, or whether it stabilizes, oscillates, or drifts. Given the partial gradient issue (§3) and the component collapse risk from the "Untangling Component Imbalance" paper, tracking this metric is important.

---

## 10. Summary of Required Corrections to the Meta-Review

| Issue | Section | Severity | Action |
|-------|---------|----------|--------|
| Training cost analysis is wrong — NAtS-L layers are *cheaper* than full softmax layers | §2 | **High** | Rewrite with correct FLOP analysis |
| Missing: "Untangling Component Imbalance" (component collapse risk) | §8 | Medium | Add as related work + discuss implications |
| Missing: SALA (9B hybrid, sparse+linear) | §8 | Medium | Add as scale-relevant comparison |
| Missing: LoLA (three-memory partition, inference-time routing) | §8 | Low | Add as conceptual parallel |
| Missing: KL-guided layer selection (static analogue of NAtS-L routing) | §8 | Low | Add as related approach |
| Missing: Shared short convolutions affect branch representations | §5 area | Low | Add detail about `attn_with_short_conv` |
| Missing: Output combination includes separate affine transforms + SiLU gate | §5 area | Low | Clarify combination pipeline |
| Missing: `ops_for_incomplete_chunks: "all"` | §7 area | Low | Minor implementation detail |
| Partial gradient §3: add nuance about deliberate disabling | §3 | Low | Authors implemented then disabled — likely tested |

---

## 11. What the Meta-Review Gets Right

These findings are **confirmed and well-supported**:

1. **STE identification** (§1): `hard_softmax` is textbook STE. "No STE" claims in both docs are wrong. ✓
2. **Partial gradient** (§3): `compute_dnats_for_invalid_blocks=False` limits routing exploration. ✓
3. **RoPE confound** (§4): `attn_apply_pos_encoding: false`. Most important interpretive issue. ✓
4. **Head dimensionality asymmetry** (§5): 18×64 attn vs 6×192 GDN, GQA-style grouping. ✓
5. **Gradient signal distinction** (§6): Attention grad = sum over attention logit gradients. GDN grad = decay-weighted key-gradient dot product. Different signals. ✓
6. **Last-chunk forcing** (§7): `nats_op_types[:, -1] = 1` prevents gradient starvation. ✓
7. **Related work gaps** (§8): Based, State Rank Dynamics, provable hierarchy, RAttention, forgetfulness paper — all correctly identified as missing. ✓
8. **Source-code-first methodology** (§10): The meta-review's core lesson — "source code is the ground truth" — is validated by its own STE finding. ✓

---

## 12. Revised Assessment of NAtS-L

After correcting the training cost analysis, NAtS-L looks **stronger** than the meta-review concluded:

- **Training cost**: Not a weakness. NAtS-L layers are cheaper than the full softmax layers they replace, while achieving better retrieval and extrapolation.
- **Inference cost**: Already noted as favorable (5.4× faster than Transformer at 128k, CUDA stream parallelism overlaps both branches).
- **Routing quality**: The partial gradient issue is real, but the forcing trick + STE + Q-derived combination weights provide multiple mechanisms for maintaining healthy routing dynamics.
- **Extrapolation**: Still confounded by RoPE, but the mechanism is sound — position-invariant softmax over selected KV pairs provides a form of content-addressable memory that doesn't degrade with sequence length.

The **remaining critical unknowns** are:
1. Whether routing behavior generalizes to >1B scale
2. Whether the no-RoPE softmax explains most of the extrapolation gain (the RoPE confound)
3. Whether the routing converges to a good optimum (partial gradient + potential collapse) or merely a stable one

---

*Cross-referenced against: arXiv:2602.03681v1, source code at `~/gh_repo/NeuralAttentionSearchLinear/`, configs `natsl_340M.json` and `natsl_760M.json`, Triton kernels in `attns.py` and `chunk_o.py`, and web search results as of 2026-03-27.*
