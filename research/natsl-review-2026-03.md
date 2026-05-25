# Critical Review: NAtS-L (Neural Attention Search Linear)

**Paper:** "Towards Adaptive Token-Level Hybrid Attention Models" — Deng et al., arXiv 2602.03681v1, Feb 2026  
**Affiliation:** University of Freiburg / Leibniz University Hannover (AutoML group)

---

## 1. Summary

NAtS-L proposes **intra-layer, chunk-level routing** between softmax and linear (Gated DeltaNet) attention. A lightweight scoring function (mean-pool + linear layer) assigns each chunk of tokens to one attention type; both branches share Q, K, V projections; outputs are RMS-normalized per branch and combined via learned query-dependent weights. The gradient signal for routing is derived as column-wise sums of attention mask gradients and integrated directly into the FlashAttention backward pass — meaning the routing is learned jointly with the model at negligible additional cost.

Two configurations are evaluated:
- **NAtS-L**: all 21 layers are NAtS-L layers (with RoPE on softmax operations)
- **NAtS-L Hybrid**: 6 NAtS-L layers + 15 pure GDN layers (no RoPE on the softmax operations within NAtS-L layers)

Experiments are at 380M/15B and 800M/50B tokens on FineWeb-Edu, with evaluation on commonsense reasoning, retrieval (RULER, real-world IR tasks), LongBench, and length extrapolation up to 65k tokens.

---

## 2. Strengths

### 2.1 The Core Idea Is Well-Motivated and Genuinely Novel

The hybrid attention literature has converged on **layer-level interleaving**: Kimi-Linear uses a fixed 3:1 KDA:MLA ratio; GDN Hybrid uses 3:1 GDN:Transformer; Jamba interleaves Mamba with attention layers. All of these are static and coarse — the same attention type applies to every token within a layer, regardless of content.

NAtS-L's insight — that the need for softmax attention is **data-dependent** and varies *within a sequence*, not just across layers — is a principled extension. The systematic analysis of hybrid linear attention (arxiv 2507.06457) found:

> *"While language modeling remains stable across linear-to-full attention ratios, recall significantly improves with increased full attention layers, particularly below a 3:1 ratio."*

This directly motivates dynamic allocation: why spend softmax compute on chunks that don't need it? Route it to where recall matters. Moving from layer-level to chunk-level granularity is the natural next step, and NAtS-L is — to my knowledge — the first to implement and evaluate this cleanly.

### 2.2 Elegant Engineering of Gradient Integration

The score gradients (Equations 14–16) decompose as column-wise sums of the attention mask gradients, mapping cleanly onto FlashAttention's tiled forward/backward structure. This means the routing signal piggy-backs on computations FlashAttention already performs — no separate routing loss, no REINFORCE estimator, no straight-through heuristics. The routing is optimized end-to-end by the language modeling objective alone. This is technically non-trivial and practically important: it means NAtS-L can be implemented as a modification to existing FlashAttention kernels without a separate routing infrastructure.

### 2.3 Strong Length Extrapolation — The Paper's Best Result

Models trained on 4096 tokens are evaluated at up to 65,536. From Figure 4:

- **GDN Hybrid** (layer-level hybrid): perplexity collapses beyond training length
- **Transformer**: collapses
- **NAtS-L and NAtS-L Hybrid**: maintain perplexity, with NAtS-L Hybrid achieving the lowest values

This is consistent across both model scales (380M, 800M) and all three test datasets (PG19, CodeParrot, NarrativeQA). The separation is large — not a marginal improvement. On RULER at 16k (4× training length), NAtS-L Hybrid scores 0.21 while every other model scores 0.00–0.05. This is the paper's most compelling empirical contribution.

However, there is a confound I discuss in §3.1.

### 2.4 Informative Routing Distribution Analysis

The distribution analysis (Figure 6, Appendix Figure 9) yields two actionable findings:

1. **Shallow layers prefer linear attention; deeper layers use more softmax.** This suggests that optimal hybrid architectures should place softmax layers deeper rather than distributing them uniformly — a concrete design recommendation for the community.

2. **No head is purely softmax.** The paper explicitly states: *"although some heads only contain linear attention operations, no head contains pure softmax attention operations."* This empirically demonstrates that full softmax over the entire sequence is not optimal for any head — a finding that supports the hybrid attention thesis broadly.

3. **Distributions shift across domains.** PG19 and NarrativeQA (natural language) show similar patterns, while CodeParrot (code) differs notably. This confirms that routing is content-sensitive, not just a fixed pattern.

### 2.5 Practical Inference Speedup

At 128k context length, NAtS-L Hybrid achieves 5.4× prefill speedup over Transformer and is only 1.66× slower than pure GDN. Decoding is 2.3× faster than Transformer at 128k. These numbers — combined with the quality improvements on retrieval tasks — represent a favorable Pareto point.

---

## 3. Weaknesses

### 3.1 A Confound in the Extrapolation Results (The RoPE Issue)

The paper's strongest result (§2.3) has an uncontrolled variable. NAtS-L Hybrid **does not use RoPE** for its softmax attention operations, while the NAtS-L variant (all-NAtS-L layers) and the Transformer baseline **do use RoPE**. RoPE is well-known to degrade beyond training context length because the rotary frequencies are not calibrated for unseen positions.

This means the excellent extrapolation of NAtS-L Hybrid may stem significantly from **position-encoding-free softmax attention** (which acts as global, position-independent attention) rather than from the chunk-level routing mechanism itself. To disentangle these effects, the paper would need:
- A GDN Hybrid baseline with RoPE-free softmax layers (same layer ratio, no routing)
- Or: NAtS-L Hybrid with RoPE applied to its softmax operations

Without this control, the attribution of extrapolation benefits to routing vs. positional encoding is ambiguous.

### 3.2 Scale Is a Significant Limitation

The experiments use 380M/15B and 800M/50B tokens. For context, GatedDeltaNet (the paper's own backbone, ICLR 2025) was validated at 1.3B/100B — a modest but meaningful step up. The paper could have matched this scale on 4–8 H100s.

To be clear: 800M-scale experiments are standard in the academic efficient attention literature (Based, DeltaNet, many NAS papers). And the NAS literature's foundational methodology — search at small scale, transfer to large — supports validating architectural ideas at reduced compute. The paper's results are also consistent across both 380M and 800M, which increases confidence in robustness. This is not a disqualifying flaw.

That said, NAtS-L introduces a **learned routing mechanism** whose behavior under scaling is genuinely unknown. The routing decisions might become more or less useful as models grow. Matching the 1.3B/100B scale of the backbone paper — feasible for this group — would meaningfully strengthen the claims.

### 3.3 The Static Depth Schedule Ablation Is Missing

The paper's own distribution analysis (§2.4) shows that routing correlates with layer depth: shallow layers are mostly linear, deep layers use more softmax. This raises a critical question: **how much of NAtS-L's benefit comes from learned routing vs. the simpler heuristic of placing softmax layers deeper?**

A cheap ablation — statically assigning linear attention to early layers and softmax to later layers (matching the average ratios observed in Figure 6/9) — would directly test the core hypothesis. If the static schedule matches NAtS-L's performance, the routing adds complexity without benefit. If NAtS-L wins, the within-layer data-dependent variation is doing real work.

The within-layer variation in Figures 6 and 9 (different heads in the same layer with very different softmax fractions, distributions shifting across datasets) suggests the learned routing does contribute beyond just depth. But this argument needs the ablation to be convincing.

This is the single most important missing experiment.

### 3.4 Training Cost Is Never Reported

The paper reports inference latency (Figure 5) but omits training cost entirely. NAtS-L requires:
1. Running both attention branches (softmax FlashAttention + GDN chunkwise) per layer
2. Score gradient computation within FlashAttention backward
3. Output normalization and weighting for both branches

The linear attention hidden state is always updated (with decay, Equation 19) even for softmax-assigned chunks. The paper states the score gradients fold into FlashAttention — but the dual-branch forward pass is inherently more expensive than a single-branch layer.

For practitioners deciding whether to adopt NAtS-L over a simpler GDN Hybrid, the **training FLOP overhead** and **wall-clock time comparison** are essential. Their absence makes it impossible to evaluate the full efficiency-quality tradeoff.

### 3.5 Comparison to Based Is Missing

Based (Arora et al., 2024) explicitly studied the recall-throughput Pareto frontier using sliding window attention + linear attention, finding:

> *"By varying Based window size and linear attention feature dimension, we can dial the state size and traverse the pareto frontier of the recall-memory tradeoff curve."*

This is the closest prior work to NAtS-L's goal of dynamically allocating softmax-like attention to tokens that need it. Based operates at comparable scale, is open-source, and uses a fundamentally different strategy (fixed window + linear) to navigate the same tradeoff. Its absence from the baselines is a meaningful gap.

The other baselines (GDN, Mamba2, Transformer, GDN Hybrid) are appropriate and well-chosen for the core comparisons.

### 3.6 Efficiency Guarantee Absent — But Empirical Evidence Partially Addresses This

The complexity is O(L_nla · L + L_la). The paper states:

> *"we do not assign any constraints to the softmax attention-linear attention ratio. The distributions for the softmax attention and linear attention will only be determined by the language modeling loss."*

In principle, this means no worst-case efficiency guarantee — the model could learn to assign most chunks to softmax, degenerating toward O(L²).

In practice, the paper provides evidence that this doesn't happen: Figures 6 and 9 show that many heads are entirely linear, and no head is purely softmax. The routing is not collapsing to all-softmax. However, this analysis is qualitative. The paper would benefit from:
- Reporting the **aggregate softmax fraction** (single number per model/dataset)
- Analyzing how this fraction changes with **sequence length** (critical: does the model request more softmax as context grows?)
- Discussion of whether an auxiliary loss on the ratio would improve the efficiency-quality tradeoff, as suggested in the paper's own future work section

### 3.7 Shared Q, K, V Across Attention Types — Worth Investigating

Both attention types share Q, K, V projections. Softmax attention and delta-rule linear attention have different representational preferences — softmax benefits from sharp, high-variance dot products for selective attention, while the delta rule's associative memory update benefits from well-separated keys for slot addressing. The paper partially addresses this with different normalizations (L2 for linear, RMS for softmax), and the projections include short convolutions and SiLU activations that add nonlinear capacity.

The paper's empirical results — outperforming single-type baselines — demonstrate that shared projections work in practice at this scale. And neural networks routinely share representations across tasks with different "ideal" inputs (multi-task learning, MoE). Still, the question of whether separate projections would yield further gains (at the cost of more parameters) is worth investigating. The paper explicitly chose shared projections for fair comparison — a reasonable experimental decision.

---

## 4. Minor Issues

1. **"Token-level" framing.** The mechanism routes per-chunk, not per-token (Equation 8 pools over X_[t]). The title's "Towards" appropriately signals aspiration rather than achievement, and chunk-level is genuinely finer-grained than the layer-level status quo. But the abstract's phrasing — *"automatically determines whether a token can be handled by a linear attention model"* — overstates the granularity. A clarification that routing is per-chunk would improve precision.

2. **GQA-style head grouping.** Multiple softmax heads share a single routing mask per GDN head. The paper doesn't explore whether this coupling constrains head specialization or whether per-head routing would be beneficial.

3. **The Context Parallel connection.** The paper notes *"NAtS-L could also be considered as a special case for Context Parallel with heterogeneous operations"* — a potentially interesting connection to distributed training that is mentioned but never developed.

---

## 5. Missing Related Work

1. **Based** (Arora et al., 2024) — sliding window + linear attention; directly studies the recall-throughput Pareto frontier NAtS-L navigates. The most important missing baseline/reference.

2. **State Rank Dynamics in Linear Attention LLMs** (arxiv 2602.02195) — concurrent work analyzing how linear attention's compressed state evolves. Relevant to understanding what the linear branch in NAtS-L captures and when it loses information.

3. **Scaling Linear Attention with Sparse State Expansion** (arxiv 2507.16577) — addresses linear attention's recall failure by expanding the state rather than routing to softmax. An alternative strategy for the same problem.

---

## 6. Recommendations for Revision

Ranked by importance:

1. **Control the RoPE confound.** Run NAtS-L Hybrid with RoPE on softmax operations, and/or run GDN Hybrid without RoPE on its softmax layers. This disentangles routing benefits from positional encoding effects in the extrapolation results.

2. **Add the static depth schedule ablation.** Assign linear/softmax attention by layer depth (matching the average observed ratios). Cheap to run; directly tests whether learned routing outperforms a fixed heuristic.

3. **Report training FLOPs and wall-clock time** vs. GDN Hybrid.

4. **Compare against Based** at 800M scale.

5. **Quantify the softmax fraction** as a single aggregate number per dataset/model, and analyze its dependence on sequence length.

6. **Scale to 1.3B/100B** if compute permits — matching the backbone paper's scale.

---

## 7. Summary Assessment

| Dimension | Rating | Notes |
|-----------|--------|-------|
| Novelty | **Medium-High** | First clean implementation of intra-layer chunk-level routing between fundamentally different attention types |
| Technical Soundness | **Medium-High** | Gradient derivation is correct and non-trivial; RoPE confound in extrapolation is uncontrolled |
| Experimental Rigor | **Medium** | Consistent results across two scales; comprehensive benchmarks; but missing key ablation (static schedule), key baseline (Based), and training cost |
| Clarity | **High** | Well-written; method is easy to follow and reproduce |
| Significance | **Medium** | Compelling extrapolation results (pending confound resolution); actionable design insights from routing analysis; unknown whether benefits persist at larger scale |
| Reproducibility | **High** | Code released; clear hyperparameter tables; builds on open-source flash-linear-attention library |

**Overall:** NAtS-L identifies a real limitation in current hybrid attention architectures (static layer-level interleaving) and proposes a principled, well-engineered solution (learned chunk-level routing). The strongest results are in length extrapolation (though confounded by positional encoding choices) and the empirical finding that no head prefers pure softmax — both meaningful contributions to the hybrid attention literature. The main gaps are a missing ablation against static depth-dependent scheduling, absent training cost analysis, and scale limited to 800M. With the RoPE confound controlled and the static schedule ablation added, this is a solid contribution to a top ML venue.
