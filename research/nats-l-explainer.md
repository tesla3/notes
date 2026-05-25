# NAtS-L: Neural Attention Search Linear

**Source:** Deng, Winje, Fehring & Lindauer. "Neural Attention Search Linear: Towards Adaptive Token-Level Hybrid Attention Models." arXiv:2602.03681, Feb 2026. Leibniz University Hannover (AutoML group).
**Code:** https://github.com/automl/NeuralAttentionSearchLinear

---

## The Problem It Solves

Existing hybrid architectures (Qwen3-Next, Jamba, etc.) interleave linear and softmax attention at the **layer level** — a fixed pattern like "3 GDN layers → 1 softmax layer → repeat." This is blunt. Every token in a softmax layer gets expensive full attention regardless of whether it needs it; every token in a linear layer gets cheap compressed attention regardless of whether it needs retrieval.

NAtS-L's insight: **the right attention type should be chosen per-token (actually per-chunk), not per-layer.** Some tokens in a sequence have only short-term impact and can be safely compressed into a fixed-size state. Other tokens carry information needed for long-term retrieval and must be preserved for future queries. This distinction varies by position, by dataset, and by head — it shouldn't be hardcoded into the architecture.

---

## How It Works

### Step 1: Chunk the sequence

The input sequence of length L is split into non-overlapping chunks of C tokens each. The chunk is the granularity of routing (not individual tokens, despite the paper's "token-level" framing).

### Step 2: Score each chunk

Each chunk is scored by an **Attention Score Layer**: a mean-pooling over the chunk's hidden states followed by a linear projection. This produces a score for each attention type (softmax vs. linear) per chunk:

> `score_t = W^score · Mean(X_[t])`

Negligible parameter overhead — just one pooling + one linear layer per attention module.

### Step 3: Route chunks to attention types

The attention type with the highest score wins. This partitions the sequence into two sets:
- **t_la** = chunks assigned to linear attention (GatedDeltaNet)
- **t_nla** = chunks assigned to softmax attention

### Step 4: Apply both attention types simultaneously

This is the clever part. Both GDN and softmax attention operate in the **same layer**, but on complementary subsets of the KV pairs:

- **Softmax attention** computes over only the KV pairs from softmax-assigned chunks (via a learned column-wise mask M^nla). These tokens are preserved in full — their KV values are available for future queries.
- **Linear attention (GDN)** updates its recurrent hidden state S only from linear-assigned chunks. These tokens are compressed into fixed-size state.

Both operations share the **same Q, K, V projections** — no extra parameters for separate attention heads.

### Step 5: Combine outputs

The two attention outputs have different scales (softmax normalizes weights to sum to 1; linear attention's output scale depends on QK norms). So they are:
1. RMS-normalized independently
2. Combined via a learned weighted sum, where the weights are derived from Q:

> `O_t = w_t^nla · Norm(O_t^nla) + w_t^la · Norm(O_t^la)`

### Step 6: Hidden state management for non-selected chunks

Critical design choice: even when a chunk is assigned to softmax attention (not linear), the GDN hidden state still gets **decayed** through that chunk:

> `S_[t+1] = ∏(α_i) · S_[t]   if t ∉ t_la`

This means the linear attention's memory is always being pushed toward recency — it forgets tokens it didn't explicitly process. The softmax pathway is the one that preserves long-range information.

---

## Architecture Variants Tested

| Variant | Structure | Layers |
|---------|-----------|--------|
| **NAtS-L** | All layers are NAtS-L (every layer routes chunks) | 21 NAtS-L layers |
| **NAtS-L Hybrid** | NAtS-L replaces the softmax layers in a 3:1 GDN Hybrid | 15 GDN + 6 NAtS-L layers |

The key difference: NAtS-L Hybrid uses NAtS-L only where the original architecture had full softmax layers, keeping pure GDN for the rest. This is the better-performing variant.

---

## Results (800M params, 50B tokens, FineWeb-Edu, context 4096)

### Commonsense reasoning (short-context)
All architectures roughly tied (~51% avg). The attention type doesn't matter much for tasks that fit in short context. NAtS-L Hybrid and GDN Hybrid are marginally best.

### Retrieval tasks (key finding)

| Model | SWDE | SQD | FDA | TQA | NQ | DROP | **Avg** |
|-------|------|-----|-----|-----|-----|------|---------|
| GDN | 34.5 | 35.1 | 22.7 | 56.9 | 17.1 | 21.1 | 31.2 |
| Mamba2 | 32.9 | 35.8 | 17.7 | 56.0 | 17.6 | 19.7 | 29.9 |
| Transformer | 58.4 | 3.3 | 43.5 | 56.7 | 18.3 | 21.9 | 33.7 |
| GDN Hybrid (3:1) | 54.6 | 39.5 | 31.1 | 57.1 | 19.6 | 21.8 | 37.3 |
| NAtS-L | 53.0 | 37.9 | 51.5 | 55.8 | 17.4 | 22.9 | 39.8 |
| **NAtS-L Hybrid** | **62.4** | **40.0** | **67.7** | **57.6** | **21.9** | 20.8 | **45.1** |

NAtS-L Hybrid beats GDN Hybrid by **+7.8 points** average. It's best on 5/6 benchmarks. The FDA result is dramatic: 67.7 vs 31.1 for GDN Hybrid and 43.5 for pure Transformer.

Note: pure GDN and Mamba2 completely fail on FDA (22.7 and 17.7). Pure Transformer fails on SQD (3.3). NAtS-L variants don't catastrophically fail on any task — the adaptive routing provides robustness.

### RULER benchmark (extrapolation beyond training length)

| Model | 4k | 8k | 16k |
|-------|------|------|------|
| Transformer | 0.45 | 0.00 | 0.00 |
| GDN Hybrid | 0.47 | 0.02 | 0.00 |
| **NAtS-L Hybrid** | **0.49** | **0.32** | **0.21** |

This is the most striking result. At 16k (4× training length), everything else collapses to ~0. NAtS-L Hybrid retains 0.21 — comparable to what linear-only models achieve *at* 4k. The token-level mixing of softmax and linear attention within every NAtS-L layer enables length extrapolation that layer-level hybrids cannot match.

### Inference speed

At 128k context:
- **Prefill:** NAtS-L Hybrid is 5.4× faster than Transformer, only 1.66× slower than pure GDN
- **Decode:** NAtS-L Hybrid is 2.3× faster than Transformer

The actual speedup depends on how many chunks get routed to softmax — if the model learns to be sparse with softmax, it's closer to linear attention speed.

---

## What the Token Distribution Analysis Reveals (Figure 6)

The paper visualizes what fraction of tokens each head routes to softmax attention, across datasets:

1. **No head uses pure softmax.** Every head routes at least some tokens through linear attention. This directly says: applying softmax to the entire sequence is *never* the optimal strategy, even in heads that heavily use softmax.

2. **Some heads are pure linear.** They never need softmax at all.

3. **Distribution is dataset-dependent.** PG19 (books) and NarrativeQA (stories) have similar softmax distributions. CodeParrot (code) is different — e.g., head 6, layer 4 is heavily used for softmax on text but not code.

4. **Distribution is head-specific.** Different heads specialize: some are retrieval-heavy (more softmax), some are aggregation-only (all linear).

This is empirical evidence that the retrieval/aggregation split exists at the head level and varies by input — exactly the kind of adaptive behavior the hybrid thesis predicts.

---

## Key Design Insights from Ablation (Table 4)

| Ablation | Avg retrieval score |
|----------|-------------------|
| **NAtS-L Hybrid (full)** | **33.5** |
| SAttn Out (inner-chunk = softmax only) | 30.9 |
| GDN Out (inner-chunk = GDN only) | 27.0 |
| w/o LAttn Decay | 32.2 |
| w/o Attn Norm | 29.6 |
| w/o Attn Weights | 32.3 |
| Weights from X (not Q) | 27.6 |

Key takeaways:
- **Both inner-chunk operations matter.** Removing either softmax or GDN for inner-chunk computation hurts. Removing GDN hurts more (27.0 vs 30.9).
- **RMS normalization before combination is critical** (29.6 without). The two attention types operate at different scales; naive addition fails.
- **Deriving combination weights from Q (not from X) is critical** (27.6 without). The query determines which attention type's output is more relevant — this is a form of query-dependent gating.
- **Hidden state decay during softmax chunks matters modestly** (32.2 without). Forces the linear pathway to stay focused on recency.

---

## Limitations (My Assessment, Not the Paper's)

1. **Scale.** Only tested at 380M and 800M parameters, 50B tokens. The 3:1 layer-level hybrid (Qwen3-Next) is validated at 80B. Whether NAtS-L's routing generalizes to that scale is completely unknown.

2. **Training context.** Only 4096 tokens. The extrapolation results (to 16k, 65k) are impressive, but pre-training at long context is a different regime. It's unclear if the routing decisions learned at 4k transfer to 128k+ training.

3. **Chunk-level, not truly token-level.** The "token-level" framing is aspirational. Routing is per-chunk (C tokens), where C must be ≥ GDN's chunk size for hardware efficiency. Individual tokens within a chunk can't be split.

4. **No auxiliary loss.** The softmax/linear ratio is determined purely by LM loss. There's no constraint preventing the model from routing everything to softmax (defeating the efficiency purpose). The paper shows this doesn't happen empirically, but there's no guarantee at larger scales or different data distributions.

5. **Only two operations.** The search space is {softmax, GDN}. The paper acknowledges that expanding to multiple linear attention variants could be beneficial (citing work showing that interleaving different linear attention types helps).

6. **Fixed routing at inference.** Once training determines the scoring function, routing is fixed for a given input. There's no mechanism to adjust routing at test time based on task demands (e.g., force more softmax for retrieval-heavy tasks).

---

## Why It Matters for the Hybrid Attention Story

NAtS-L is the most concrete implementation of adaptive gating in the hybrid attention literature. It takes the conceptual idea ("use softmax where you need retrieval, linear where you don't") and makes it learnable and differentiable. Specifically:

- It provides **empirical evidence** that the retrieval/aggregation split is real, head-specific, dataset-dependent, and learnable.
- It shows **layer-level interleaving is suboptimal** — at 16k context, GDN Hybrid (3:1 layer-level) scores 0.00 on RULER while NAtS-L Hybrid scores 0.21.
- It demonstrates that **mixing within a layer enables length extrapolation** that between-layer mixing does not.
- It opens the path toward **query-dependent routing** via the Q-derived combination weights, though this is nascent.

The open question is whether this approach scales. If it does, the 3:1 layer ratio may be a transitional architecture — a stepping stone toward fully adaptive, input-dependent attention routing.

---

*All tables, equations, and claims verified against arXiv:2602.03681v1 (accessed 2026-03-27).*
