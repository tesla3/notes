# Hybrid Linear-Softmax Attention with Adaptive Gating: Evidence Assessment

**Date:** 2026-03-27
**Claim under examination:** Hybrid architectures combining linear attention (or SSM/gated variants) with softmax attention, using gating to adaptively switch between them, can achieve optimal performance across all signal strength (ν) levels — softmax for high-ν retrieval, linear for low-ν aggregation, gating to select the regime per-input.

**Origin:** Inference from Duranthon et al. (2026) Insights 1–3 in my softmax attention note (#ce952c). Not a claim made by any paper.

**Verdict: Partially supported with important caveats. The hybrid architecture is empirically validated and converging on production consensus. But "optimal across all ν" overstates what the evidence shows. The hybrid is *efficient and effective*, not *optimal*.**

---

## I. Evidence FOR the Hybrid Claim

### 1. The Recall Gap Is Real, Specific, and Well-Characterized

**Strength: Strong. Multiple independent confirmations, both empirical and theoretical.**

- **Zoology** (Arora et al., ICLR 2024): A 70M-parameter attention model outperforms a 1.4B-parameter gated-convolution model on associative recall. 82% of the perplexity gap between efficient architectures and Transformers is explained by recall ability. The gap scales with sequence length — gated-convolutions need more dimensionality (FLOPs) for longer sequences, attention does not.
  - *Source: https://hazyresearch.stanford.edu/blog/2023-12-11-zoology1-analysis*

- **NVIDIA Empirical Study** (June 2024): Pure Mamba and Mamba-2 "lag behind Transformer models on tasks which require strong copying or in-context learning abilities (e.g., five-shot MMLU, Phonebook Lookup) or long-context reasoning."
  - *Source: https://research.nvidia.com/publication/2024-06_empirical-study-mamba-based-language-models*

- **Duranthon et al.** (2026): Theoretical proof that softmax achieves the Bayes risk for single-location retrieval (SLR), while linear attention fundamentally falls short. The gap: softmax error ~ (L−1)e^{−ν}, linear error ~ (L−1)/ν — exponential vs. polynomial decay.
  - *Source: arXiv:2509.21936v2*

- **Retrieval SNR Framework** (May 2025): Introduces retrieval SNR to quantify memory capacity of attention mechanisms. Kernel perspective mathematically reveals why softmax is effective — it produces sharp, high-SNR retrievals.
  - *Source: https://arxiv.org/html/2505.19488v1*

- **Associative Memory Unifying Framework** (Jan 2025): "Clarifies how linear attention fails to capture inter-token correlations and offers a mathematical justification for the empirical effectiveness of query-key normalization in softmax attention."
  - *Source: https://arxiv.org/abs/2501.12352*

**What this establishes:** Softmax attention has a categorical advantage for retrieval/recall tasks (high-ν regime). This is both empirically large (20× parameter efficiency) and theoretically grounded (Bayes optimality). Linear attention is fundamentally limited here — not a training issue, a structural one.

### 2. Hybrid Architectures Match or Beat Pure Approaches at Scale

**Strength: Strong. Multiple production-scale validations with consistent architecture patterns.**

- **Jamba** (AI21 Labs, March 2024): Hybrid Transformer-Mamba MoE. Matches Transformer quality on standard benchmarks, 3× throughput, 256K context. Runs on a single 80GB GPU.
  - *Source: https://arxiv.org/abs/2403.19887*

- **Qwen3-Next** (Alibaba, Sept 2025): 80B total / 3B active. Layout: `12 × (3 × GatedDeltaNet → 1 × GatedAttention → MoE)`. 75% linear layers, 25% full attention. 262K context. Competitive with attention-only models.
  - *Source: https://huggingface.co/Qwen/Qwen3-Coder-Next*

- **Qwen3.5** (Feb 2026): Continues the 3:1 GatedDeltaNet:full-attention lineage. "The big architectural bet."
  - *Source: https://huggingface.co/blog/mlabonne/qwen35*

- **Jet-Nemotron** (NVIDIA, 2025): Hybrid architecture via post-training NAS. "Matches or exceeds the accuracy of leading full-attention models while significantly improving generation throughput."
  - *Source: https://arxiv.org/html/2508.15884v1*

- **Distillation result** (Aug 2024): A hybrid model with only 25% attention layers "achieves performance comparable to the original Transformer in chat benchmarks and outperforms open-source hybrid Mamba models trained from scratch with trillions of tokens."
  - *Source: https://arxiv.org/html/2408.15237v2*

**What this establishes:** The 3:1 linear-to-full ratio has converged as an industry consensus. Hybrid architectures achieve Transformer-level quality with substantially better throughput. This is no longer speculative — it's the production architecture for frontier models (Qwen3-Next, Qwen3.5, Jet-Nemotron).

### 3. The 3:1 Ratio Has Systematic Justification

**Strength: Strong. Controlled ablation study.**

- **Systematic Analysis of Hybrid Linear Attention** (July 2025): Ablates linear-to-full ratios systematically. Key findings:
  - Language modeling perplexity is **stable** across ratios — the linear layers handle this fine.
  - Recall **significantly improves** with more full-attention layers, especially below a 3:1 ratio.
  - Recommends HGRN-2 or GatedDeltaNet with **3:1 to 6:1** linear-to-full ratio.
  - Identifies three critical ingredients: **selective gating**, **hierarchical recurrence**, **controlled forgetting**.
  - *Source: https://arxiv.org/html/2507.06457v1*

**What this establishes:** The hybrid split maps to task type — linear layers handle the bulk of language modeling (aggregation), full-attention layers handle recall (retrieval). The ratio is not arbitrary; it's where the quality-efficiency Pareto frontier bends.

### 4. Gating Mechanisms Are Closing the Linear-Attention Recall Gap

**Strength: Moderate. Promising results but gating alone doesn't fully close the gap.**

- **GatedDeltaNet** (2025–2026): Unifies Mamba-2's data-dependent decay gate with DeltaNet's delta rule. The delta rule is equivalent to SGD on an associative recall objective — it can *overwrite* outdated memories, not just accumulate. "Rivals Transformers in retrieval but runs at the speed of an RNN."
  - *Source: https://kingsleykim.dev/blog/gated-deltanet/*
  - *Source: https://pub.towardsai.net/gated-deltanet-the-surgical-eraser-solving-linear-attentions-memory-problem-1e50ca3e42ab*

- **NAtS-L** (Feb 2026): Token-level adaptive routing within the same layer. Automatically determines per-token whether linear attention suffices (short-term impact, encodable in fixed-size state) or softmax is required (long-term retrieval, must be preserved). This is the most direct implementation of the "gating selects regime" idea.
  - *Source: https://arxiv.org/html/2602.03681v1*

- **SLA — Slot-Level Attention** (Feb 2026): Lifts softmax from token-level to head-level. Attention heads become "coarse semantic slots" with competitive gating for dynamic subspace selection. Reintroduces "winner-take-all" dynamics for precise retrieval.
  - *Source: https://arxiv.org/html/2602.01744v1*

**What this establishes:** Gating is evolving from coarse (layer-level interleaving) to fine-grained (token-level and head-level routing). The trajectory points toward learned, input-dependent decisions about when to use expensive softmax. But note: even GatedDeltaNet-heavy architectures (Qwen3-Next) still need 25% full-attention layers.

### 5. Complementarity, Not Redundancy

**Strength: Moderate. Counter-intuitive finding supports functional specialization.**

- **SWAX** (Sept 2025): Hybrid sliding-window attention + xLSTM. Counter-intuitive finding: **shorter** windows improve long-context performance. Short windows force the recurrent component to develop better long-term memory by not relying on attention for long-range retrieval. The components *specialize* rather than redundantly processing.
  - *Source: https://arxiv.org/html/2509.24552v2*

**What this establishes:** The hybrid components co-adapt during training. Reducing the attention component's range doesn't hurt — it forces the linear/recurrent component to compensate, yielding a better overall system. This is indirect evidence that the two mechanisms serve genuinely complementary roles.

---

## II. Counter-Evidence AGAINST the Hybrid Claim

### 1. Provable Expressiveness Gap: Hybrid < Full Attention

**Strength: Strong. This directly contradicts "optimal."**

- **Provable Expressiveness Hierarchy** (Feb 2026): First formal proof that hybrid linear-full attention is **strictly less expressive** than standard full attention. There exist functions computable by full attention that no hybrid architecture can represent, regardless of depth or gating.
  - *Source: https://arxiv.org/abs/2602.01763*

**What this means:** "Optimal across all ν" is **provably false** as a theoretical statement. There exist high-ν tasks where the hybrid cannot match full attention, period. The question is whether those tasks matter in practice.

### 2. Pure Mamba Wins on Reasoning (No Attention Needed)

**Strength: Moderate. Challenges the necessity of softmax for all high-complexity tasks.**

- **PromptCoT-Mamba-7B** (May 2025): A pure attention-free Mamba model outperforms all Transformer AND hybrid baselines of similar or larger scale on AIME 24, AIME 25, and Livecodebench. Competitive on other math/code reasoning benchmarks.
  - *Source: https://arxiv.org/html/2505.22425v1*

- **M1** (Jan 2025): Mamba reasoning model matches DeepSeek R1 distilled at same scale. 3× faster generation than Transformers via vLLM.
  - *Source: https://arxiv.org/html/2504.10449v1*

**What this means:** Reasoning ≠ retrieval. Long chains of thought may be primarily aggregation (building up a computation step-by-step) rather than retrieval (looking up a specific past token). If so, these results are *consistent* with the ν framework — reasoning is low-ν, and pure Mamba handles low-ν fine. But they challenge the implicit assumption that "hard tasks need softmax." The hardest benchmarks (AIME, competitive coding) don't need it.

**Important caveat:** These models still lag on copying, phonebook lookup, and other pure-recall tasks (per NVIDIA empirical study). The advantage is task-specific.

### 3. Training Instability of Recurrent Components

**Strength: Moderate-to-Strong. Practical concern that undermines reliability.**

- **"When recalling in-context, Transformers are not SSMs"** (Aug 2025): Learning rate plays a critical role in recurrent model performance. "An issue that can severely affect reported performance in previous works."
  - *Source: https://arxiv.org/html/2508.19029v1*

- **"Revisiting Associative Recall in Modern Recurrent Models"** (NeurIPS 2025): "While Transformers are robust to optimization hyperparameters, the performance of modern recurrent models suffers from critical instabilities: success is confined to an **extremely narrow window of learning rates**, outside of which accuracy drastically drops."
  - *Source: https://openreview.net/forum?id=sJxBWDc8SM*

**What this means:** The linear/SSM components in hybrids are fragile. Reported benchmark results may overstate their reliable performance. A hybrid architecture's linear layers may silently underperform in production if the training recipe isn't precisely tuned. This is a *practical* challenge to the hybrid thesis that pure theoretical analysis misses.

### 4. Neither Architecture Suits Very Long Contexts

**Strength: Weak-to-Moderate. Challenges the framing, not the specific claim.**

- **"Scaling Context Requires Rethinking Attention"** (May 2025): "We argue that neither transformers nor sub-quadratic architectures are well suited to training at long sequence lengths: the cost of processing the context is too expensive in the former, too inexpensive in the latter."
  - *Source: https://arxiv.org/html/2507.04239v1*

**What this means:** The hybrid may be a compromise between two flawed approaches rather than a synergy of two complementary strengths. The "too inexpensive" criticism of sub-quadratic models suggests they under-attend to context — a problem gating can't fix if the underlying representation is lossy.

---

## III. Synthesis: What Can Actually Be Claimed?

### Supported with high confidence:

1. **Softmax attention is necessary for high-fidelity recall.** Theoretical (Bayes optimality) and empirical (20× parameter gap) evidence is overwhelming. No linear variant fully closes this gap, though GatedDeltaNet narrows it.

2. **Linear/SSM layers are sufficient for the majority of language modeling.** Perplexity is stable across linear-to-full ratios. Most tokens don't require sharp retrieval.

3. **The 3:1 linear-to-full ratio is a robust engineering sweet spot.** Independently converged upon by Qwen (production), systematic ablation studies (research), and distillation experiments. It's a Pareto-optimal point on the recall-efficiency curve.

4. **Hybrid architectures achieve Transformer-level quality with substantially better throughput.** Demonstrated at production scale (Qwen3-Next 80B, Jamba, Jet-Nemotron).

### Supported with moderate confidence:

5. **Gating mechanisms can adaptively route between attention types based on input characteristics.** NAtS-L demonstrates this at token granularity. But the evidence is recent (Feb 2026) and not yet validated at scale.

6. **The retrieval-aggregation split maps loosely onto signal strength ν.** This is the inference chain from Duranthon → Zoology → hybrid evidence. The mapping is suggestive but indirect — Duranthon's ν is a specific mathematical quantity in a narrow model; real-world "signal strength" is a metaphor.

### NOT supported:

7. **"Optimal" across all ν.** Provably false (expressiveness hierarchy). The hybrid trades expressiveness for efficiency. On tasks requiring simultaneous multi-location retrieval or complex inter-token correlation, it is strictly weaker than full attention.

8. **Gating alone bridges the gap.** Even the best gated linear attention (GatedDeltaNet) still needs ~25% full-attention layers. The gating narrows the gap but doesn't eliminate the structural limitation of fixed-size state.

9. **Training robustness.** The linear/SSM components are fragile to hyperparameters (especially learning rate). Hybrid architectures inherit this fragility in their linear layers.

---

## IV. The Refined Claim

**What I should have said:**

> Hybrid architectures with ~75% gated linear attention and ~25% full softmax attention achieve near-Transformer quality at substantially lower cost. The linear layers handle the bulk of sequence processing (aggregation), while sparse softmax layers provide high-fidelity recall for the minority of tokens that need it. Adaptive gating (token-level or head-level) is an active research direction that may further improve this split by making the routing input-dependent rather than positionally fixed. However, the hybrid is provably less expressive than full attention, the linear components are training-fragile, and "optimal across all signal regimes" overstates what the evidence supports.

The ν-framework from Duranthon is a useful *mental model* for why the split works, but the real-world evidence is about task type (recall vs. everything else), not signal strength per se.

---

## V. Open Questions

1. **Does NAtS-L-style token-level routing scale?** If it works at 80B+, it would be the strongest evidence for adaptive gating. Currently only shown at research scale.

2. **What tasks fall in the expressiveness gap?** The provable hierarchy shows hybrid < full attention, but doesn't characterize which practical tasks require the full attention's extra expressiveness.

3. **Can training instability be solved?** If the narrow-LR-window problem for recurrent components is a fundamental issue (not just a recipe problem), it caps the reliability of any hybrid.

4. **Does the SWAX complementarity result generalize?** If shorter attention windows reliably force better recurrent learning, then the hybrid components may be more synergistic than additive.

---

*Sources consulted: 25+ papers/blog posts (2024–2026). No single source supports the full claim; the synthesis is my inference across the evidence base.*
