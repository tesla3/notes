# NAtS-L: Consolidated Critical Review

**Paper:** Deng, Winje, Fehring & Lindauer. "Towards Adaptive Token-Level Hybrid Attention Models." arXiv:2602.03681v1, Feb 2026. University of Freiburg / Leibniz University Hannover (AutoML group).  
**Code:** github.com/automl/NeuralAttentionSearchLinear  
**Verified against:** source code (local clone), configs `natsl_340M.json` / `natsl_760M.json`, Triton kernels in `attns.py` and `chunk_o.py`.  
**Model sizes:** configs named 340M/760M (non-embedding params); paper reports ~380M/~800M (total params including embeddings).  
**Date:** 2026-03-27 (consolidated from five review passes)

---

## 1. The Problem

Existing hybrid architectures (Qwen3-Next, Jamba, GDN Hybrid) interleave linear and softmax attention at the **layer level** — a fixed pattern like "3 GDN → 1 softmax → repeat." This is coarse. Every token in a softmax layer pays for O(L²) attention regardless of whether it needs retrieval; every token in a linear layer gets compressed regardless of whether it carries information that must be preserved.

A systematic analysis of hybrid linear attention (arxiv 2507.06457, Jul 2025) established that:

> *"While language modeling remains stable across linear-to-full attention ratios, recall significantly improves with increased full attention layers, particularly below a 3:1 ratio."*

NAtS-L's insight: the need for softmax is **data-dependent and varies within a sequence**. Route chunks to the appropriate attention type, not layers.

---

## 2. How It Works

### Routing

The input sequence (length L) is split into non-overlapping chunks of C=64 tokens. Each chunk is scored by a lightweight **Attention Score Layer** — mean-pooling over the chunk's hidden states, then a linear projection producing one score per attention type per head:

```
score = W_score · MeanPool(X_chunk)     # shape: [n_heads, n_ops]
```

Negligible parameter overhead: one pooling + one linear layer per NAtS-L module.

The highest-scoring operation wins, partitioning the sequence into softmax-assigned and GDN-assigned chunks. Importantly, the routing granularity is **per-chunk** (not per-token). The paper title hedges with "Towards Adaptive Token-Level," but the body text states *"automatically determines whether a token can be handled by a linear attention model"* — overstating the actual chunk-level granularity.

### Dual-Branch Execution

Both GDN and softmax attention operate **in the same layer**, on complementary subsets of KV pairs:

- **Softmax attention** computes over only KV pairs from softmax-assigned chunks. The Triton kernel (`parallel_nats_attn_fwd_kernel`) iterates only over attention-assigned blocks — it never loads KV from non-attention blocks. Verified in the inner loop (attns.py, ~line 182):

  ```python
  for i_iter in tl.range(0, b_n_iters):       # b_n_iters = count of attn-assigned blocks
      b_o_nats_block = tl.load(nats_block_indices + i_iter * stride_block_types_t)
      i_s0 = b_o_nats_block * NAtS_BLOCK_SIZE  # jump to assigned block position
  ```

- **GDN** updates its recurrent hidden state from GDN-assigned chunks. For softmax-assigned chunks, the state is still **decayed** (`decay_for_non_gdn_blocks: true` in both configs), pushing linear attention toward recency.

- **All queries** (from every position) receive outputs from **both** branches. The routing partitions the KV pairs, not the queries.

**Key implication: each branch has a sparse view of history.** The softmax branch only sees KV from other softmax-assigned chunks — not from GDN-assigned chunks. Conversely, the GDN branch only updates its state from GDN-assigned chunks (decaying through softmax-assigned ones). If a critical fact (a name, date, or identifier) falls in a chunk routed to GDN, it enters only the compressed recurrent state and is recoverable only to the extent GDN's finite state preserves it. The softmax branch cannot access it. This creates a **premature commitment** problem: the router decides chunk assignments based on mean-pooled pre-attention hidden states — before the model knows which tokens downstream queries will need. A chunk containing rare but critical information could look "ordinary" by mean-pooling and get routed to GDN, where it's compressed and potentially lost.

**Boundary exception.** Both configs set `ops_for_incomplete_chunks: 'all'`, meaning chunks shorter than 64 tokens (sequence tail) are processed by both branches regardless of routing. Combined with last-chunk forcing (§3), the final ~128 tokens always get dual-branch processing. This mitigates the sparse-view problem at sequence boundaries but may inflate benchmark scores for tasks where the answer is near the sequence end.

### Shared Projections, Different Head Geometry

Both branches share the **same Q, K, V linear projections** but reshape them differently. From the 760M config:

```json
"num_heads": 6,          // GDN heads
"num_attn_heads": 18,    // Softmax attention heads
"head_dim": 192          // Per-head dim for GDN
```

The same 1152-dim projection (6 × 192) is reshaped as:
- **GDN**: 6 heads × 192-dim — large, high-capacity heads for associative memory
- **Softmax**: 18 heads × 64-dim — many small heads for fine-grained pattern matching

This is GQA-style: `attn_groups = 18/6 = 3` softmax heads per GDN head. Each GDN head's routing decision applies to 3 softmax heads simultaneously.

Across model sizes, the softmax head dimension is fixed at 64 (340M: 768/12 = 64; 760M: 1152/18 = 64), while GDN head dimension scales (128 → 192). Scaling preferentially increases GDN capacity — an implicit assumption that the recurrent state bottleneck is the binding constraint. Both models use `expand_v: 2`, so the value dimension per GDN head is 2× the key dimension (256 for 340M, 384 for 760M), giving a total `value_dim = 6 × 384 = 2304` for 760M.

Both configs set `attn_with_short_conv: true`, meaning both branches receive **identical** post-convolution representations (kernel_size=4 ShortConvolution applied before the reshape). The routing decision is made on **pre-projection, pre-convolution** hidden states (the layer input after LayerNorm).

**Different Q,K normalization per branch.** Despite sharing projections, the two branches apply different normalization to Q and K before use:
- **Softmax branch**: RMSNorm with learned per-dimension scale (`attn_qk_norm: true`) — preserves relative magnitudes, adds learnable parameters
- **GDN branch**: L2 normalization in the Triton kernel (`lattn_use_qk_l2norm_in_kernel=True`, verified in `mixed_attn_gdn.py` lines 115-117) — projects to unit vectors, no learnable parameters

The "shared projections" are therefore not truly shared in effect: each branch transforms them into semantically different representations before computing attention or state updates.

**Routing granularity constraint.** The routing produces per-GDN-head decisions (`num_nats_head = num_heads = 6`). Each decision is imposed on `attn_groups` (= 3 for 760M) softmax heads simultaneously. Different softmax heads within the same group might benefit from attending to different KV subsets, but are forced to share the same sparsity pattern. The Q-derived output weights can partially compensate by down-weighting a branch per-softmax-head, but the underlying KV visibility is locked at the coarser GDN-head level.

### Output Combination

The two branch outputs are combined via `FusedMultiInputRMSNormGated`:

1. **Separate RMS normalization** with **separate learned per-dimension affine transforms** (`weight1`, `weight2`) per branch
2. **Q-derived scalar weights** (`o_weights`, softmax over the 2 ops per position per attention head), applied after normalization
3. **SiLU gating** from a separate gate projection (`g_proj`)

In full (verified against test code in `fused_norm_gate.py`):
```
o = SiLU(g_proj(x)) * (w₀ · (γ₁ ⊙ RMSNorm(o_gdn)) + w₁ · (γ₂ ⊙ RMSNorm(o_attn)))
```
Where `γ₁, γ₂` are learned per-dimension affine parameters (128-dim vectors for 760M), `w₀, w₁` are Q-derived **per-head per-position** scalar weights (shape `[B, T, num_attn_heads, 2]`, softmax-normalized over the 2 ops), and `⊙` is elementwise multiplication. The per-head granularity allows different attention heads to weight the two branches differently at each position — enabling head-level specialization in the combination step.

**Normalization dimension subtlety.** The `FusedMultiInputRMSNormGated` is initialized with `head_attn_v_dim` (= `value_dim / num_attn_heads` = 128 for 760M), not the GDN head's value dimension (384). Before normalization, the GDN output is reshaped from `[B, T, 6, 384]` to `[B, T, 18, 128]` via `o_gated_delta.view(o_attn.shape)`. Each GDN head's 384-dim output is subdivided into 3 normalization groups of 128 dims — the RMS statistics are computed independently over each 128-dim slice, at a finer granularity than the GDN head's natural 384-dim boundary. The learned affine transforms (`weight1`, `weight2`) are 128-dimensional vectors shared across all 18 groups, meaning every sub-group of every GDN head receives the same per-dimension scaling — the normalization can't capture statistics that span a full GDN head. Whether this creates artifacts or acts as beneficial regularization is untested. The same reinterpretation applies to the `g_proj` gate: produced at `[B, T, 6, 384]` (GDN geometry), it is consumed by the Triton kernel as `[B*T*18, 128]` through raw pointer arithmetic. Since SiLU gating is elementwise, this changes nothing for the gate itself, but it means the normalization and affine transforms operate at 128-dim granularity while the gate was designed at 384-dim granularity — an implicit coupling that is nowhere documented.

The ablation (Table 4) shows both normalization and Q-derived weights are critical: removing normalization drops retrieval from 33.5 → 29.6 avg; deriving weights from X instead of Q drops it to 27.6.

### Architecture Variants

| Variant | Structure | NAtS-L layers | RoPE on softmax? |
|---------|-----------|---------------|-------------------|
| **NAtS-L** | All 21 layers are NAtS-L | 21 | Yes |
| **NAtS-L Hybrid** | Replaces softmax layers in 3:1 GDN Hybrid | 6 (layers 3,7,11,15,19,20) | **No** |

The Hybrid variant is better-performing and is the paper's primary model.

---

## 3. The Gradient Mechanism

### The Routing Uses a Straight-Through Estimator

The routing discretization uses `hard_softmax` (natsl_attn_gdn.py, line ~47):

```python
def hard_softmax(logits, dim=-1):
    y_soft = logits.softmax(dim)
    index = y_soft.max(dim, keepdim=True)[1]
    y_hard = torch.zeros_like(logits).scatter_(dim, index, 1.0)
    ret = y_hard - y_soft.detach() + y_soft
    return ret
```

The pattern `y_hard - y_soft.detach() + y_soft` is the **textbook straight-through estimator** (Bengio et al., 2013): forward pass uses discrete `y_hard`, backward pass gets the gradient of continuous `y_soft`. An alternative Gumbel-Softmax STE is also available (`nats_sample_strategy == 'gumble'` [sic] → `gumbel_softmax(hard=True)`).

**Defensive rounding.** After `hard_softmax` produces one-hot routing vectors, the forward pass applies an additional `torch.round()` (mixed_attn_gdn.py, line 81):
```python
nats_block_types = torch.round(nats_block_types)  # TODO  we need to investigate this further...
```
This should be a no-op on exact one-hot outputs from the STE. Its presence — with the author's "investigate further" comment — is a red flag for numerical instability in the routing discretization, possibly from the `y_hard - y_soft.detach() + y_soft` arithmetic accumulating floating-point error.

The paper's actual contribution is **not** the absence of STE, but the computation of a meaningful routing gradient signal (`dnats`) **within** the existing attention/GDN backward kernels. The full gradient pathway:

```
loss → kernel backward (computes dnats) → STE backward (softmax Jacobian) → nats_layer weights
```

### Two Different Gradient Signals

The `dnats` signal is computed differently per branch:

**Attention branch** (attns.py, ~line 875) — sum of attention-logit gradients over query positions:
```python
b_ds = b_p * (b_dp - b_delta)                          # ∂loss/∂S (attention logits)
b_dattn += tl.sum(tl.where(m_k[:, None], b_ds, 0))     # aggregate over queries
```
This accumulates within FlashAttention's tiled backward — genuinely elegant engineering that adds the routing signal at near-zero marginal cost.

**GDN branch** (chunk_o.py, ~line 440) — decay-weighted inner product of keys with their gradient:
```python
b_nats_opt += tl.sum((b_k * b_dk) * tl.where(m_t, tl.exp(-b_g + b_g_last), 0)[:, None])
```
This measures how much each key's contribution to the recurrent state update affects downstream loss — a fundamentally different signal from the attention branch.

Both signals are concatenated and propagated through the STE to the routing logits:
```python
dnats = torch.cat([dnats_attn.unsqueeze(-1), dnats_gated_delta.unsqueeze(-1)], dim=-1)
```

### The Routing Gradient Is Partial

Both released configs disable counterfactual gradients:
```json
"compute_dnats_for_invalid_blocks_linear_att": false,
"compute_dnats_for_invalid_blocks_att": false
```

When `False`, the GDN backward kernel **skips** computing the routing gradient for chunks not assigned to GDN (chunk_o.py, ~line 464). The model learns "how valuable was this chunk's current assignment" but **not** "how valuable would it have been under the alternative."

This is the well-known **partial gradient problem** in discrete routing — early assignments become self-reinforcing. The code *does implement* the counterfactual (line ~476-489, `COMPUTE_DNATS_FOR_INCOMPLETE_SCORES = True`), but it's deliberately disabled. The authors likely tested it and found it unhelpful or destabilizing.

**However, two bugs make the counterfactual feature non-functional in practice:**

1. **JSON config key typo.** Both configs use `"compute_dnats_for_invalid_blocks_att"` (no trailing 'n'), but the Python config constructor expects `compute_dnats_for_invalid_blocks_attn`. The mismatch means HuggingFace's `PretrainedConfig` stores the JSON value as a stray kwarg attribute (`self.compute_dnats_for_invalid_blocks_att`), while the named parameter `self.compute_dnats_for_invalid_blocks_attn` keeps its default (`False`). The attention-branch counterfactual flag is not controllable from JSON config.

2. **Copy-paste bug in model wiring** (modeling_natsl_attn_gdn.py, line 101):
   ```python
   compute_dnats_for_invalid_blocks_attn=config.compute_dnats_for_invalid_blocks_attn,
   compute_dnats_for_invalid_blocks_linear_att=config.compute_dnats_for_invalid_blocks_attn,  # BUG
   ```
   The second line reads `config.compute_dnats_for_invalid_blocks_attn` instead of `config.compute_dnats_for_invalid_blocks_linear_att`. Both flags are hardwired to the attention branch's value. The linear attention counterfactual flag is independently uncontrollable.

**Net effect.** The bugs form a chain: (a) the JSON can't set the attention flag due to key typo, (b) even if it could, the linear attention flag ignores its own config and mirrors the attention flag. The counterfactual gradient feature is doubly broken. All defaults happen to be `False`, so this has no effect on released models — but it means the feature was likely never successfully tested. This is directly relevant to the partial gradient concern: the code path that could address it exists but is unreachable.

**Author-acknowledged incompleteness.** The function signature in `mixed_attn_gdn.py` confirms the feature was never finished:
```python
compute_dnats_for_invalid_blocks_attn: bool = False,  # TODO this is not activated yet, we need to fix that!
```

**Broken design intent.** The function defaults reveal the intended asymmetry: `compute_dnats_for_invalid_blocks_attn=False` (attention counterfactual off) but `compute_dnats_for_invalid_blocks_linear_att=True` (linear counterfactual **on**). This makes architectural sense — the GDN branch is at greater risk of gradient starvation since softmax attention naturally generates richer gradients. Bug #2 defeats this by forcing the linear flag to mirror the attention flag, accidentally disabling a feature that was architecturally intended to be on.

The sparse backward update problem is well-studied in MoE. Pham et al. ("Dense Backpropagation Improves Training for Sparse MoE," arxiv 2504.12463, Apr 2025) found: *"MoEs only receive a sparse backward update, leading to training instability and suboptimal performance"* and proposed sending gradients through all experts. This is the direct analogue of NAtS-L's disabled counterfactual flags.

### Last-Chunk Forcing

In training (natsl_attn_gdn.py, ~line 498):
```python
nats_op_types[:, -1] = 1   # Force last chunk: both ops active for all heads
```
Both branches process the final chunk regardless of routing, ensuring gradient signal flows to both. This reveals that gradient starvation was a practical concern.

---

## 4. Key Results (760M config / ~800M total, 50B tokens, FineWeb-Edu, context 4096)

### Retrieval Tasks

| Model | SWDE | SQD | FDA | TQA | NQ | DROP | **Avg** |
|-------|------|-----|-----|-----|-----|------|---------|
| GDN | 34.5 | 35.1 | 22.7 | 56.9 | 17.1 | 21.1 | 31.2 |
| Mamba2 | 32.9 | 35.8 | 17.7 | 56.0 | 17.6 | 19.7 | 29.9 |
| Transformer | 58.4 | 3.3 | 43.5 | 56.7 | 18.3 | 21.9 | 33.7 |
| GDN Hybrid (3:1) | 54.6 | 39.5 | 31.1 | 57.1 | 19.6 | 21.8 | 37.3 |
| NAtS-L | 53.0 | 37.9 | 51.5 | 55.8 | 17.4 | 22.9 | 39.8 |
| **NAtS-L Hybrid** | **62.4** | **40.0** | **67.7** | **57.6** | **21.9** | 20.8 | **45.1** |

NAtS-L Hybrid beats GDN Hybrid by **+7.8 points average**. Best on 5/6 benchmarks. The FDA result is dramatic: 67.7 vs 31.1 (GDN Hybrid) and 43.5 (Transformer). No NAtS-L variant catastrophically fails on any task.

### Length Extrapolation (RULER)

| Model | 4k | 8k | 16k |
|-------|------|------|------|
| Transformer | 0.45 | 0.00 | 0.00 |
| GDN Hybrid | 0.47 | 0.02 | 0.00 |
| **NAtS-L Hybrid** | **0.49** | **0.32** | **0.21** |

At 16k (4× training length), everything else collapses. NAtS-L Hybrid retains 0.21.

### Inference Speed (128k context)

- **Prefill:** 5.4× faster than Transformer; 1.66× slower than pure GDN
- **Decode:** 2.3× faster than Transformer

CUDA stream parallelism overlaps the two branches during **decode-time** recurrent inference (`nats_mixed_attn_gdn_recurrent`). Training and prefill run the attention and GDN kernels **sequentially** — no stream parallelism.

### Routing Distribution (Figure 6)

1. **No head uses pure softmax.** The paper states: *"although some heads only contain linear attention operations, no head contains pure softmax attention operations."*
2. **Some heads are pure linear.**
3. **Distributions are dataset-dependent** (PG19 ≈ NarrativeQA ≠ CodeParrot) and **head-specific.**
4. **Shallow layers prefer linear; deeper layers use more softmax.** NAtS-L layers (3,7,11,15,19,20) have a depth-biased distribution — layers 19 and 20 are both NAtS-L.

---

## 5. Critical Analysis

### 5.1 The RoPE Confound — Most Important Interpretive Issue

NAtS-L Hybrid operates **without positional encoding** on its softmax attention. From the config:
```json
"attn_apply_pos_encoding": false
```

The rotary embedding is only initialized when this is `true` (natsl_attn_gdn.py, ~line 174):
```python
if self.attn_apply_pos_encoding:
    self.rotary = RotaryEmbedding(dim=self.head_attn_k_dim, base=self.attn_rope_theta)
else:
    self.rotary = None
```

The softmax branch computes **position-invariant content similarity**. At extrapolation lengths, it doesn't suffer from RoPE frequency miscalibration. The GDN Hybrid baseline uses RoPE in its full softmax layers, making the extrapolation comparison unfair.

The absence of RoPE doesn't just help extrapolation — it fundamentally changes what the softmax branch computes: content-only similarity rather than position-modulated similarity. This confound is the single most important factor when interpreting the RULER results. The QK normalization (`attn_qk_norm: true`) interacts with this: it ensures attention logits stay well-conditioned from raw content embeddings alone, making the "no RoPE" design more stable than it would otherwise be. Without QK norm, position-free content similarity could suffer from scale miscalibration.

Supporting literature: Kazemnejad et al. (arxiv 2404.12224, 2024) found that *"although NoPE can extend to longer sequences than the commonly used explicit position encodings, it still has a limited context length."* Separately, Sun et al. (arxiv 2509.12635, 2025) confirmed: *"RoPE, as originally designed, is not able to extrapolate to context lengths that were not seen during pretraining, even with extensive continual pretraining at the extended lengths."*

**Required control:** GDN Hybrid with RoPE-free softmax layers (same layer ratio, no routing) — or NAtS-L Hybrid with RoPE applied to its softmax operations.

**Double confound.** The extrapolation advantage is compounded: NAtS-L Hybrid's softmax branch avoids RoPE frequency miscalibration, **and** its GDN branch uses decay-based positional bias (`g = -A_log.exp() * softplus(...)`) that is inherently length-invariant — no position-frequency interactions to break. The baseline GDN Hybrid shares the GDN advantage for its linear layers but **not** for its softmax layers (which use RoPE). Both the routing mechanism and the position encoding differ simultaneously, making it impossible to attribute the RULER gains to either factor alone.

### 5.2 Training Cost — Actually an Advantage, Not a Weakness

Per NAtS-L layer, where *f* is the fraction of chunks routed to softmax:

| Component | Cost |
|-----------|------|
| Softmax attention | O(*f* · L²) — kernel only iterates over softmax-assigned KV blocks |
| GDN (all positions) | O(L) |
| Routing scoring | O(L) — negligible |
| **Total** | **O(*f* · L²) + O(L)** |

Comparing NAtS-L Hybrid (15 GDN + 6 NAtS-L) to GDN Hybrid (15 GDN + 6 full softmax):

| Architecture | Attention FLOPs |
|-------------|----------------|
| GDN Hybrid (3:1) | 6 · L² |
| NAtS-L Hybrid | 6 · *f* · L² |

The paper's Figure 6 shows *f* ≈ 0.25–0.40. At *f* = 0.3: **3.3× fewer attention FLOPs** than GDN Hybrid. NAtS-L layers are cheaper than the full softmax layers they replace.

Real overhead exists but is secondary: two sequential kernel launches per layer during training (no stream parallelism — see §4), memory for dual outputs, the `FusedMultiInputRMSNormGated` combination kernel. The paper's silence on wall-clock training time likely reflects that the comparison isn't unfavorable, but the kernel launch overhead from running two smaller kernels per layer (where a softmax-only layer runs one) could erode the theoretical FLOP savings at short sequence lengths where kernel launch latency dominates.

**State memory cost.** With `expand_v = 2`, the GDN recurrent state per layer is `num_heads × head_dim × head_v_dim` = 6 × 192 × 384 ≈ 442K elements for 760M. Across all 21 layers: ~9.3M elements ≈ 18.6 MB in bf16. For context: the KV cache this replaces would be ~397 MB at 4k tokens or ~12.5 GB at 128k — the recurrent state is 21–670× smaller. The fixed cost is negligible at the long contexts NAtS-L targets, but should still appear in end-to-end memory accounting since it persists even at batch size 1 with zero sequence length.

### 5.3 The Static Depth Schedule Ablation Is Missing

The routing correlates with layer depth (§4 above). A cheap ablation — statically assigning softmax to deeper layers at the average observed ratios — would directly test whether learned routing outperforms a fixed heuristic. The within-layer, head-specific, dataset-dependent variation in Figure 6 suggests it does, but this argument needs the experiment.

**This is the single most important missing experiment.**

### 5.4 Scale Is Unknown

Tested at 340M/15B and 760M/50B only (config naming; ~380M/~800M total params). GatedDeltaNet (the backbone) was validated at 1.3B/100B (arxiv 2406.06484: *"We train a 1.3B model for 100B tokens and find that it outperforms recent linear-time baselines such as Mamba and GLA"*). Qwen3-Next validates the 3:1 layer-level hybrid at 80B parameters. NAtS-L introduces a learned routing mechanism whose scaling behavior is genuinely unknown — the routing decisions, the softmax fraction, and the partial gradient dynamics could all change at scale.

### 5.5 Component Collapse Risk

Wang et al. ("Paying Attention to Hybrid Attention," arxiv 2510.05901, ICLR 2026) found:

> *"We identify a critical flaw: existing hybrid methods inadvertently bypass the linear component, relying almost entirely on SWA."*

In converted hybrids, the linear attention component becomes dead weight. NAtS-L faces the inverse risk: routing could converge to one-branch dominance. The paper's Figure 6 shows this doesn't happen at 800M, but the partial gradient issue (§3) — compounded by the broken counterfactual gradient pipeline — creates "rich get richer" dynamics that could manifest at scale. NAtS-L's only defenses are the last-chunk forcing trick and the Q-derived output weights (which provide some gradient flow to both branches regardless of routing). There is no auxiliary balance loss.

The code tracks the softmax fraction during training:
```python
self.attn_fraction = (n_nats_blocks.float()[..., 0] / nats_op_types.shape[1]).mean(0).detach()
```
But whether this metric stabilizes, oscillates, or drifts during training is unreported.

### 5.6 Efficiency Guarantee Absent

The complexity is O(f·L² + L) where f is learned. No constraint prevents f → 1 (all-softmax, defeating efficiency). The paper shows this doesn't happen empirically, but there's no formal guarantee. How *f* changes with sequence length is unreported and critical for long-context deployment.

### 5.7 Only Two Operations, Fixed at Training Time

The search space is {softmax, GDN}. Expanding to multiple linear attention variants could help — the paper cites work showing interleaving different linear types improves performance. Once trained, routing is fixed for a given input. No mechanism adjusts routing at test time based on task demands (e.g., forcing more softmax for retrieval-heavy tasks).

### 5.8 Premature Commitment in the Router

The routing decision is made on mean-pooled pre-attention hidden states — the rawest representation in the layer, before projection, convolution, or inter-token interaction. This is architecturally necessary (the route must be chosen before executing either branch), but it means the decision is based on the least-informed features available. The model cannot know at routing time whether a chunk contains a token that a future query will need verbatim. The `decay_for_non_gdn_blocks: true` partially mitigates one direction (GDN state decays through softmax-assigned gaps, pushing it toward recency), but there is no converse mitigation: the softmax branch has zero access to information in GDN-assigned chunks.

**Partial correction via output weights.** The Q-derived output weights (`nats_out_weights_layer`) operate on post-projection, post-convolution Q features — strictly more informed than the pre-projection hidden states the router uses. This creates an asymmetry where the combiner can partially correct bad routing decisions by down-weighting the poorly-matched branch. The −5.9 point drop when deriving weights from X instead of Q (Table 4) confirms that this correction mechanism is load-bearing.

---

## 6. Missing Related Work

| Paper | Why It Matters |
|-------|---------------|
| **STILL** (arxiv 2602.02180, Feb 2026) | *"Selecting Tokens for Intra-Layer Hybrid Attention to Linearize LLMs... introduces a Self-Saliency Score with strong local–global consistency, enabling accurate token selection using sliding-window computation, and retains salient tokens for sparse softmax attention while summarizing the remaining context via linear attention."* **Most important missing comparator.** STILL does the same intra-layer routing between softmax and linear attention but at **token** (not chunk) level, using saliency-based (not learned) routing, and targets post-training conversion (not from-scratch training). The comparison — does NAtS-L's learned chunk-level routing outperform STILL's saliency-based token-level routing? — is the key open question. |
| **NSA** (arxiv 2502.11089, Feb 2025; DeepSeek) | *"NSA employs a dynamic hierarchical sparse strategy, combining coarse-grained token compression with fine-grained token selection to preserve both global context awareness and local precision."* Uses learned chunk-level routing to select which KV chunks receive full attention — the same architectural primitive as NAtS-L's routing, applied within full softmax attention rather than between softmax and linear. Demonstrates that learned chunk-level attention routing works at production scale (deployed in DeepSeek models), partially addressing NAtS-L's scaling unknown. NSA's compression branch also provides a dense gradient path analogous to NAtS-L's GDN branch. |
| **Based** (Arora et al., ICML 2024; arxiv 2402.18668) | Sliding window + linear attention; explicitly studies the recall-throughput Pareto frontier. Important missing baseline. *"By varying BASED window size and linear attention feature dimension, we can dial the state size and traverse the Pareto frontier of the recall-memory tradeoff curve."* |
| **Dense Backpropagation for Sparse MoE** (Pham et al., arxiv 2504.12463, Apr 2025) | *"MoEs only receive a sparse backward update, leading to training instability and suboptimal performance."* Proposes full backward pass through all experts — the direct analogue of NAtS-L's disabled counterfactual gradient flags (§3). Provides empirical evidence that enabling such signals improves training. |
| **SLA with Learnable Routing** (arxiv 2602.12675, Feb 2026) | *"SLA relies on a heuristic split that assigns computations to the sparse or linear branch based on attention-weight magnitude, which can be suboptimal."* Proposes learnable routing for sparse-linear attention in diffusion models — same routing idea, different domain. Shows the broader trend toward learned operation routing. |
| **State Rank Dynamics in Linear Attention LLMs** (arxiv 2602.02195, Feb 2026) | Finds *"State Rank Stratification: a distinct spectral bifurcation among linear attention heads"* in Qwen3-Next. NAtS-L's finding that some heads are pure-linear may reflect the same phenomenon — low-rank heads do compression, high-rank heads need softmax for retrieval. |
| **A Provable Expressiveness Hierarchy in Hybrid Linear-Full Attention** (arxiv 2602.01763, Feb 2026) | *"The first provable separation between hybrid attention and standard full attention."* NAtS-L's empirical finding that no head is pure-softmax is consistent with this theoretical result. |
| **RAttention** (arxiv 2506.15545; Apple, Jun 2025) | *"RAttention with a window size of just 512 consistently matches the performance of full-attention models across diverse settings."* Complementary question to NAtS-L: "how small can the local window be?" vs "which chunks need softmax?" |
| **Alleviating Forgetfulness of Linear Attention** (arxiv 2510.20787, Oct 2025) | *"Linear-attention models that compress the entire input sequence into a fixed-size recurrent state offer an efficient alternative to Transformers, but their finite memory induces forgetfulness."* Different hybrid strategy for the same forgetfulness problem NAtS-L's softmax branch solves. |
| **Untangling Component Imbalance** (arxiv 2510.05901, ICLR 2026) | Finds hybrid models bypass their linear component. Component collapse risk (§5.5). |
| **SALA** (arxiv 2602.11761, Feb 2026) | 9B hybrid: sparse attention (InfLLM-V2) + linear attention (Lightning Attention). Demonstrates the hybrid idea at much larger scale with sparse (not full) softmax — a different cost tradeoff. |
| **LoLA** (arxiv 2505.23666, May 2025) | Three-memory partition: *"(i) recent pairs in a local sliding window cache; (ii) difficult-to-memorize pairs in a sparse, global cache; (iii) generic pairs in the recurrent hidden state."* Inference-time analogue of NAtS-L's training-time routing. |
| **KL-Guided Layer Selection** (arxiv 2512.20569, Dec 2025) | Uses KL-divergence to decide which layers keep full attention — static, layer-level analogue of NAtS-L's dynamic chunk-level routing. |
| **Mamba-3** (Dao & Gu, arxiv 2603.15569, Mar 2026) | Complex-valued SSM with MIMO formulation: *"outperforming Mamba-2 and strong Transformer baselines on standard language modeling benchmarks"* with 50% smaller state and up to 7× faster at long sequences. If pure-recurrent quality is sufficient, the case for NAtS-L's routing complexity weakens. |
| **Native Hybrid Attention** (arxiv 2510.07019, Oct 2025) | *"A single softmax attention operation is then applied over all keys and values, enabling per-token and per-head context-dependent weighting without requiring additional fusion parameters."* Intra-layer hybrid with a different fusion strategy — no routing, single unified attention over combined KV. |
| **RAT** (arxiv 2507.04416, Jul 2025) | *"RAT partitions the input into chunks, applies recurrence within each chunk for local dependencies, and softmax-based attention across chunks for long-range interactions."* Inverts NAtS-L's design: recurrence within chunks, attention between chunks, vs. NAtS-L's routing of chunks to different mechanisms. |

---

## 7. Ablation Insights (Table 4, 340M config / ~380M total params)

| Ablation | Avg Retrieval | Δ |
|----------|:---:|:---:|
| **NAtS-L Hybrid (full)** | **33.5** | — |
| SAttn Out (inner-chunk = softmax only) | 30.9 | −2.6 |
| GDN Out (inner-chunk = GDN only) | 27.0 | **−6.5** |
| w/o LAttn Decay | 32.2 | −1.3 |
| w/o Attn Norm | 29.6 | **−3.9** |
| w/o Attn Weights | 32.3 | −1.2 |
| Weights from X (not Q) | 27.6 | **−5.9** |

- **Both branches matter.** Removing GDN hurts more than removing softmax (−6.5 vs −2.6).
- **Normalization is critical** (−3.9). The branches operate at different scales; naive addition fails.
- **Q-derived weights are critical** (−5.9 when deriving from X instead of Q). The query determines which branch's output matters — a form of query-dependent gating.
- **Decay matters modestly** (−1.3). Forces linear attention toward recency.

---

## 8. Recommended Experiments (Ranked)

1. **Control the RoPE confound.** GDN Hybrid without RoPE on softmax layers, or NAtS-L Hybrid with RoPE. Disentangles routing from positional encoding in extrapolation.
2. **Static depth schedule ablation.** Assign softmax to deeper layers at observed average ratios. Tests whether learned routing beats a fixed heuristic.
3. **Compare against STILL** (arxiv 2602.02180). Token-level saliency routing vs chunk-level learned routing — directly tests NAtS-L's routing quality.
4. **Report training wall-clock time** vs GDN Hybrid. (Likely favorable for NAtS-L, per §5.2.)
5. **Compare against Based** at 800M.
6. **Fix and test counterfactual gradients.** Repair the two bugs (§3), enable counterfactual gradients (especially the linear-branch counterfactual that was intended to be on by default), and measure whether they improve routing quality or destabilize training.
7. **Quantify softmax fraction** as aggregate number per dataset/model; analyze dependence on sequence length.
8. **Scale to 1.3B/100B** — matching the backbone's validated scale.

---

## 9. Verdict

| Dimension | Rating |
|-----------|--------|
| Novelty | **Medium** — first clean intra-layer chunk-level routing between fundamentally different attention types; however, concurrent work STILL (arxiv 2602.02180) independently proposes intra-layer routing with finer token-level granularity |
| Technical Soundness | **Medium** — gradient integration is non-trivial and correct; STE is standard but effective; RoPE confound in extrapolation is uncontrolled; counterfactual gradient code path is broken by two bugs with an additional author-acknowledged TODO |
| Experimental Rigor | **Medium** — consistent across two scales, comprehensive benchmarks, but missing the static-schedule ablation, STILL/Based baselines, and RoPE control |
| Significance | **Medium** — strong extrapolation (pending confound), actionable routing insights, unknown scaling |
| Reproducibility | **High** — code released, clear configs, builds on open-source FLA library |

NAtS-L identifies a real limitation in current hybrid architectures (static layer-level interleaving) and proposes a well-engineered solution (learned chunk-level routing with kernel-integrated gradients). The training cost profile is actually favorable — NAtS-L layers are cheaper than the full softmax layers they replace. The strongest empirical results are in length extrapolation (confounded by RoPE) and the finding that no head prefers pure softmax — both meaningful contributions. The critical unknowns are: whether the RoPE confound explains most of the extrapolation gain, whether the routing generalizes past 1B scale, whether learned routing outperforms a static depth-dependent schedule, and how NAtS-L compares to STILL's token-level saliency routing. The code reveals two bugs in the counterfactual gradient pipeline (§3) — compounded by author-acknowledged incompleteness and a broken design intent that accidentally disables the linear-branch counterfactual — plus architectural decisions (premature commitment in routing, sub-head normalization granularity, L2 vs RMSNorm asymmetry on shared Q,K projections, per-GDN-head routing forced on grouped softmax heads) whose consequences are untested. With the RoPE control, STILL comparison, and static ablation added, this would be a solid contribution to the hybrid attention literature.

---

*All code quotations verified against local clone of github.com/automl/NeuralAttentionSearchLinear. External paper claims verified via web search, 2026-03-27. Audit pass 2026-03-27: fixed bug count (2 not 3), added author TODO corroboration and broken design-intent analysis, corrected normalization boundary phrasing, added per-head output weight precision, added NSA to related work, strengthened RoPE double-confound analysis, noted defensive `torch.round()` red flag. Deep audit 2026-03-27: corrected state memory cost framing (18.6MB vs 12.5GB KV cache — negligible, not competing), added L2 vs RMSNorm asymmetry on shared Q,K projections, clarified CUDA stream parallelism is decode-only (training is sequential), added per-GDN-head routing constraint as limitation, added gate tensor memory reinterpretation, added `ops_for_incomplete_chunks='all'` boundary behavior, added Q-derived weights as partial correction mechanism for premature commitment, added training kernel launch overhead, added Mamba-3/Native Hybrid Attention/RAT to related work. This note supersedes: `nats-l-explainer.md`, `natsl-review-2026-03.md`, `natsl-meta-review-2026-03.md`, `natsl-meta-review-audit-2026-03.md`.*
