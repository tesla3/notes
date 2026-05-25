# Critical Review: NSE Computational Complexity in Multi-Index Model Learning — Gap Analysis

*Deep review. April 2026. Critically examines the summary note and six companion notes on NSE, IE fragility, hierarchical multi-index, and TabPFN applications.*

**Reviewed notes:**
- `nse-computational-complexity-multi-index-summary.md` (primary)
- `information-exponent-fragility-and-follow-ups.md`
- `nse-hierarchical-models-and-amortized-learning.md`
- `nse-tabpfn-difficulty-control-revised-assessment.md`
- `hierarchical-multi-index-tabpfn-difficulty-control-review.md`
- `critical-review-nse-hierarchical-multi-index-tabpfn-difficulty-control.md`
- `chatterjee-sudijono-nn-low-complexity-review.md`

---

## Executive Assessment

The note collection is **the strongest personal synthesis I've seen** of the IE → GE → NSE progression. The research lineage is accurately traced, the connections are genuine, and the self-corrections (the revised assessment note) show intellectual honesty. The companion notes on TabPFN applications are creative and well-reasoned.

However, the collection has **seven substantive gaps** — some factual, some structural, some emerging from results the notes didn't catch. Three of these gaps directly threaten the central narrative. Below I document each gap, explain why it matters, and cite sources verbatim where possible.

---

## Part I: What the Notes Get Right (Insights & Techniques Worth Preserving)

### 1. The IE → GE → NSE Narrative Is Accurate and Well-Structured

The progression from fragile (IE) to robust (NSE) hardness measures is the central story of 2021–2026 learning theory. The summary note captures this correctly. The key insight — that IE measured a "coincidence of symmetries" killed by mean shift — is sourced directly from Cornacchia, Mikulincer & Mossel (COLT 2025, arXiv 2502.06443), who showed:

> "A non-constant analytic function (which F₁(μ) = E_{z∼N(μ,1)}[f'(z)] always is) has only isolated zeros, so random μ avoids them with high probability."

The notes correctly identify this as a smoothed-analysis argument, and correctly trace the follow-up PDS framework (Medvedev et al., arXiv 2602.08907).

### 2. The Troiani et al. Duality Is the Most Important Connection

The notes correctly identify Troiani, Cui, Dandi, Krzakala, Zdeborová (ICML 2025, arXiv 2502.00901) as establishing a formal mapping between deep attention networks and sequence multi-index models:

> "We first establish a mapping of such models to sequence multi-index models, a generalization of the widely studied multi-index model to sequential covariates, for which we establish a number of general results." — arXiv 2502.00901

This is the single most important connection in the entire note collection. It means multi-index theory is not merely an analogy for attention-based learning — it IS the theory. The companion notes on TabPFN applications correctly build on this duality.

### 3. The Self-Correction on CSQ Bounds Is Honest and Mostly Right

The revised assessment note correctly identifies that the Nishikawa et al. (ICML 2025) result — softmax transformers surpassing CSQ bounds — invalidates the claim that "training on β★ > 1 tasks is training on unsolvable instances." The NSE computational threshold is proven tight for AMP/first-order methods, not for all polynomial-time algorithms. The revised assessment note states:

> "The class of algorithms where the NSE computational threshold is proven to bind (CSQ, first-order) is **strictly weaker** than what a softmax transformer implements."

This is correct. But it's also where the gaps begin.

### 4. The (β★, γ) Parameterization for Difficulty Is Genuinely Novel

Using β★ (algorithmic depth) and γ (feature importance decay) as orthogonal difficulty knobs for synthetic data generation has no prior in the tabular meta-learning literature. The critical review note correctly identifies this as "the cleanest connection between statistical physics theory and practical meta-learning design." This parameterization is independently valuable regardless of whether the TabPFN application works.

### 5. The Chatterjee-Sudijono Connection Is Underexploited but Real

The review of Chatterjee & Sudijono (arXiv 2409.12446) correctly identifies the deep insight: the structure of a program maps onto the structure of a deep network, and for-loop compression maps onto repeated-layer compression. The connection to NSE is unexplored in the notes but is thematically resonant: both are about how structural properties of the target (program length / activation symmetry) determine learning difficulty. The Chatterjee paper's distinction between descriptive complexity (Kolmogorov) and algorithmic complexity (how hard to learn) maps directly to the NSE vs. K-complexity distinction the other notes wrestle with.

---

## Part II: The Seven Gaps

### Gap 1: The Low-Degree Framework Underpinning NSE Is Cracking — The Notes Don't Know This

**Severity: High. Directly threatens the central claim that NSE measures "genuine computational barriers."**

The notes repeatedly characterize NSE as measuring a "genuine" or "robust" computational barrier, contrasting it with the "fragile" IE. The evidence for this is that NSE's computational thresholds are:
- Proven tight for AMP
- Supported by CSQ lower bounds
- Supported by low-degree polynomial lower bounds

But the low-degree polynomial framework — the primary tool for conjecturing that these bounds hold against ALL polynomial-time algorithms — has suffered two serious blows the notes don't mention:

**1a. Buhai, Hsieh, Jain, Kothari — "The Quasi-Polynomial Low-Degree Conjecture is False" (arXiv 2505.17360, May 2025):**

> "There is a growing body of work on proving hardness results for average-case estimation problems by bounding the low-degree advantage (LDA) — a quantitative estimate of the closeness of low-degree moments — between a null distribution and a related planted distribution." — arXiv 2505.17360

They construct an explicit counterexample to the quasi-polynomial version of the low-degree conjecture. This means the low-degree method's predictions about computational hardness can be quantitatively wrong in certain regimes. The polynomial-time version of the conjecture survives, but the counterexample weakens the inductive evidence that low-degree predictions are universally reliable.

**1b. arXiv 2603.02594 — "Low-Degree Method Fails to Predict Robust Subspace Recovery" (March 2026):**

> "The low-degree polynomial framework has been highly successful in predicting computational versus statistical gaps for high-dimensional problems in average-case analysis and machine learning. This success has led to the low-degree conjecture, which posits that this method captures the power and limitations of efficient algorithms for a wide class of high-dimensional statistical problems." — arXiv 2603.02594

The paper then shows this conjecture fails for robust subspace recovery — a problem closely related to multi-index learning. They identify "failure of low-degree polynomials in capturing anti-concentration" and compare to Non-Gaussian Component Analysis (NGCA), which is structurally similar to single-index learning.

**Why this matters for the notes:** The summary note's claim that NSE survives "perturbation, data reuse, loss modification, and large learning rates" is about NSE's robustness as a *measure*. But the claim that the computational threshold n/d = Θ(1/λ^{β★}) represents a genuine barrier (not just a limitation of AMP) rests on the low-degree conjecture. If the low-degree method can fail to predict the right computational threshold even for subspace recovery problems, the "NSE measures a genuine barrier" narrative is more conjectural than the notes acknowledge.

**What to add:** A caveat that the computational lower bound is proven only for AMP and supported (but not proven) for general poly-time by the low-degree framework, which has known failure modes. The "genuine barrier" characterization should be explicitly flagged as conjectural.

---

### Gap 2: The Fine-Grained Information Exponent Analysis Is Missing

**Severity: Medium-High. Shows the scalar-summary (one exponent) approach loses critical multi-index structure.**

The notes cite Damian et al.'s generative leap exponent k* (arXiv 2506.05500) and Defilippis et al.'s NSE β★ (arXiv 2603.17896). Both reduce the difficulty of a multi-index model to a single scalar. But:

**Bietti, Bruna, Pillaud-Vivien (arXiv 2410.09678, "Learning Orthogonal Multi-Index Models: A Fine-Grained Information Exponent Analysis"):**

> "In this work, we demonstrate that, for multi-index models, focusing solely on the lowest degree can miss key structural details of the model and result in suboptimal rates." — arXiv 2410.09678

This is directly relevant. The NSE definition β★(σ) = min{β ∈ ℕ : E[σ^β(z)·(z²−1)] ≠ 0} — a single scalar — discards the full structure of the Hermite spectrum. For multi-index models with multiple link functions having different β★ values, the learning dynamics depend on the *full vector* of per-component exponents and their interactions, not just the worst case.

The fine-grained analysis shows that the optimal algorithm uses *different* spectral statistics for different components — something a single β★ cannot capture. For a meta-learner (TabPFN), this means the difficulty of a task is not a single number but a profile.

**What to add:** Cite arXiv 2410.09678 and note that β★ is a coarse summary. The full difficulty profile requires per-component Hermite analysis. For the TabPFN application, this suggests the DGP should vary β★ per component, not just globally — which the hierarchical model y(x) = Σ k^{−γ} σ(wₖ·x) already does if different σ are used per component, but the notes always use a single shared σ.

---

### Gap 3: Non-Separable Link Functions Are the Elephant in the Room

**Severity: High. The entire framework assumes separable structure that real functions don't have.**

Every model in the notes is separable: f(x) = Σ gₖ(wₖ·x) or f(x) = g(W^T x) where g = Σ gₖ(zₖ). Real multi-index functions have **cross-terms**: f(x) = g(w₁·x, w₂·x) where g(z₁, z₂) ≠ g₁(z₁) + g₂(z₂). Examples: XOR-like decision boundaries, multiplicative interactions, polynomial interactions between projections.

**Troiani, Dandi, Krzakala, Zdeborová (AISTATS 2025, proceedings.mlr.press/v258/troiani25a.html)** — from the same group as the NSE paper — study the general (non-separable) case:

> "Multi-index models — functions which only depend on the covariates through a non-linear transformation of their projection on a subspace — are a useful benchmark for investigating feature learning with neural networks."

Their computational limits paper (arXiv 2405.15480) handles general link functions g(z₁,...,zₚ), where the Hermite decomposition involves cross-terms (e.g., z₁z₂). The computational threshold depends on the **full Hermite tensor** of g, not just diagonal (per-component) entries.

The NSE, as defined in arXiv 2603.17896, applies to single-index models and separable multi-index models. For non-separable g, the relevant quantity is the full degree-profile of the Hermite expansion of g as a multivariate function. β★ doesn't capture this.

**Why this matters:** Real tabular targets have feature interactions. A model f(x) = sin(w₁·x) · cos(w₂·x) has a multiplicative cross-term that changes the Hermite structure qualitatively. The hierarchical multi-index DGP proposed for TabPFN is purely additive/separable — it cannot generate cross-interaction difficulty. This is a structural limitation of using β★ as the sole difficulty knob.

**What to add:** Acknowledge that the separable assumption is a genuine limitation, cite Troiani et al. (AISTATS 2025) for the non-separable analysis, and note that a complete difficulty characterization requires the multivariate Hermite tensor, not just per-component β★.

---

### Gap 4: NSE's Own Symmetry Dependence Creates a Self-Defeating Narrative

**Severity: Medium. The "meta-lesson" the notes draw applies to NSE itself.**

The summary note concludes with a meta-lesson:

> "The lasting insight from this research trajectory: **worst-case hardness results built on distributional knife-edges are not predictive of practical difficulty.** The IE measured a symmetry coincidence."

But β★ itself is a symmetry-dependent measure. From the notes' own analysis:

- β★ only matters when σ is **even** (symmetric). For non-symmetric activations, GE = 1, no gap, β★ is irrelevant.
- β★ ≤ 2 for "virtually all practical functions." β★ ≥ 3 is "fine-tuned and unstable."
- The practical distinction reduces to β★ = 1 vs β★ = 2 — i.e., whether a particular Hermite projection is zero.

So NSE measures whether E[σ^β(z)·(z²−1)] happens to be zero for β < β★. This is... another coincidence of symmetries, just a different one. The fact that it's more robust to perturbation than IE (survives mean shift, data reuse, etc.) means it's a *better* symmetry-based measure, but it's still fundamentally a symmetry-based measure. The fragility of β★ ≥ 3 (acknowledged as "fine-tuned and unstable") is the same type of knife-edge the notes criticize IE for having.

**The notes almost see this.** Open question 1 asks "Is β★ the final answer?" and question 4 notes "β★ irrelevance for GE = 1." But the meta-lesson is stated without this qualification. The correct meta-lesson is: **scalar symmetry-based hardness measures that depend on exact cancellations in the Hermite spectrum are unreliable outside the specific symmetry class they measure. IE, GE, and NSE all share this fundamental limitation — each is more robust than the last, but none escapes it.**

---

### Gap 5: The Depth > 2 Question Has More Structure Than "Unknown"

**Severity: Medium. The notes correctly flag this as open but underexplore available results.**

The summary note lists "Depth > 2. All results for two-layer networks. How network depth interacts with β★ is unknown" as an open question. This is technically true for NSE specifically, but the depth question has substantial structure from adjacent work:

**Abbe, Boix-Adsera, Misiakiewicz — "The merged-staircase property" (COLT 2022, arXiv 2202.08658):**

> "It is currently known how to characterize functions that neural networks can learn with SGD for two extremal parameterizations: neural networks in the linear regime, and neural networks with no structural constraints." — arXiv 2202.08658

The merged-staircase property explicitly characterizes how hierarchical Fourier structure enables sequential learning via saddle-to-saddle dynamics. Depth helps because each "staircase step" can be learned by a different layer.

**Abbe, Boix-Adsera, Misiakiewicz — "SGD learning on neural networks" (arXiv 2302.11055, COLT 2023):**

> "We put forward a complexity measure — the leap — which measures how 'hierarchical' target functions are." — arXiv 2302.11055

The leap complexity explicitly measures how depth helps: a function with leap L requires depth ≥ L to learn efficiently via SGD. For multi-index models, this means depth can reduce the effective sample complexity by allowing sequential feature extraction across layers, each layer "leaping" one step up the Hermite hierarchy.

**The connection to NSE:** If β★ = 2 means you need second-order nonlinear processing, a deeper network can potentially decompose this into two first-order steps (if the target has a staircase structure). Depth interacts with β★ by potentially reducing the effective per-layer difficulty — but only for targets with the right hierarchical structure. This is not "unknown" — it's partially characterized by leap complexity and should be integrated.

**What to add:** The leap/staircase framework provides partial answers to how depth interacts with hardness measures. Cite Abbe et al. (COLT 2022, 2023) and note that depth can reduce effective β★ for hierarchically structured targets.

---

### Gap 6: Robust/Adversarial Multi-Index Learning Is a Parallel Complexity Theory the Notes Ignore

**Severity: Medium. A whole dimension of computational complexity is absent.**

The notes focus entirely on the "clean" setting: Gaussian inputs, additive Gaussian noise. But a parallel thread of results studies multi-index learning under adversarial corruptions:

**"Robust Feature Learning for Multi-Index Models in High Dimensions" (arXiv 2410.16449v2):**

> "Prior works have shown that in high dimensions, the majority of the compute and data resources are spent on recovering the low-dimensional projection; once this subspace is recovered, the remainder of the target can be learned independently of the ambient dimension." — arXiv 2410.16449

**"Algorithms and SQ Lower Bounds for Robustly Learning Real-valued Multi-Index Models" (OpenReview, NeurIPS 2025):**

> "We study the complexity of learning real-valued Multi-Index Models (MIMs) under the Gaussian distribution." — OpenReview cD4whTwm6G

These results show that adversarial corruption introduces *additional* computational complexity beyond what NSE captures. Under ε-corruption, SQ lower bounds change, and the achievable sample complexity depends on the interplay between β★, the corruption fraction ε, and the dimension. This is directly relevant for practical applications where real data has outliers, label noise, and distributional contamination — exactly the conditions the critical review note flags as "NSE does NOT capture."

**What to add:** Cite the robust multi-index learning thread and note that β★ characterizes clean-setting difficulty only. Under corruptions, additional complexity arises that requires different measures.

---

### Gap 7: Mean-Field Langevin Dynamics Offer a Different Algorithm Class That May Escape NSE Bounds

**Severity: Medium-Low. An alternative algorithmic approach not discussed.**

**Mousavi-Hosseini, Park, Girotti, Mitliagkas, Erdogdu (arXiv 2408.07254):**

> "We study the problem of learning multi-index models in high-dimensions using a two-layer neural network trained with the mean-field Langevin algorithm. [...] Motivated by improving computational complexity, we take the first steps towards polynomial time convergence of the mean-field Langevin algorithm by investigating a setting where the weights are constrained to be on a compact manifold with positive Ricci curvature, such as the hypersphere." — arXiv 2408.07254

The mean-field Langevin algorithm is neither first-order SGD nor AMP. It optimizes over the space of distributions on weights, which gives it fundamentally different properties from the algorithm classes against which NSE is proven tight. The notes discuss two "escape routes" from NSE — PDS and large learning rates. Mean-field Langevin is a third potential escape route that should be mentioned.

---

## Part III: The Deepest Structural Problem — The Scalar Fallacy

Across all seven gaps, one pattern recurs: **the attempt to reduce multi-dimensional computational difficulty to a single scalar.** The IE was one number. The GE was one number. The NSE is one number. But:

- Multi-index learning has per-component difficulty profiles (Gap 2)
- Non-separable interactions add another dimension (Gap 3)
- Adversarial robustness adds yet another (Gap 6)
- Network depth interacts with all of these (Gap 5)
- The theoretical foundation for the "barrier" interpretation is conjectural (Gap 1)

The progression IE → GE → NSE is a search for the *right* scalar. But the right answer might not be a scalar at all. The Bruna-Hsu survey (arXiv 2504.05426) — which the notes cite but underutilize — reviews:

> "The primary focus is on computationally efficient (polynomial-time) algorithms in Gaussian space, the assumptions under which consistency is guaranteed by these methods, and their sample complexity." — arXiv 2504.05426v2

The survey reveals that sample complexity depends on the *full Hermite degree profile* of the link function(s), the subspace dimension p, the noise level, and the algorithm class. Any scalar summary is necessarily lossy. The field may eventually converge on a multi-dimensional complexity profile rather than a single exponent.

---

## Part IV: Useful Techniques the Notes Surface

Despite the gaps, the notes identify several techniques of lasting value:

### 1. PDS as a Design Principle for Meta-Learning Priors

The Medvedev et al. (arXiv 2602.08907) formalization of Positive Distribution Shift — "data augmentation, curriculum learning, synthetic data, pre-training as PDS instances" — provides theoretical license for engineering training distributions. This is the correct framing for any synthetic-data-based meta-learning approach, and the notes apply it well.

### 2. The (β★, γ) Grid for Systematic Difficulty Control

Even if β★ has limitations as a theoretical measure, it's practically useful as a *controllable knob* for synthetic data generation. The idea of generating hierarchical multi-index datasets with varying β★ ∈ {1, 2} and γ ∈ {0.5, 1.0, 1.5} to systematically explore difficulty is sound experimental design.

### 3. The Task Diversity Threshold for ICL

The Raventos et al. (NeurIPS 2023, arXiv 2306.15063) finding — that there's a sharp threshold below which transformers can't solve unseen tasks — is correctly identified as the mechanistic foundation for why prior diversity matters. The notes' application of this to TabPFN is creative and well-motivated.

### 4. The Hybrid Attention Architecture Rationale

The argument that linear attention implements AMP-like computation while softmax enables CSQ-escaping transforms is theoretically clean. The notes correctly identify the provable expressiveness separation (arXiv 2602.01763) and the practical hybrid attention literature (arXiv 2507.06457). This is the most actionable architectural idea in the collection.

### 5. Continued Pretraining as De-Risking

The suggestion to start from TabPFNv2 and continue pretraining with the multi-index DGP (rather than training from scratch) is pragmatically sound and directly supported by the TabPFN-Wide precedent.

---

## Part V: What I'd Change in the Summary Note

### 1. Weaken the "genuine computational barrier" claim

Change: *"It measures a genuine computational barrier, not a symmetry coincidence."*
To: *"It measures a computational barrier that is provably tight for AMP/first-order methods and conjecturally tight for all poly-time algorithms. The conjecture rests on the low-degree framework, which has known failure modes (arXiv 2505.17360, arXiv 2603.02594). NSE is more robust than IE but still fundamentally symmetry-dependent — it only bites for even activations."*

### 2. Add the fine-grained information exponent to the lineage

Insert between Damian et al. (2024) and Defilippis et al. (2026):

> Bietti, Bruna, Pillaud-Vivien (arXiv 2410.09678, 2024/2025): Fine-grained IE analysis for orthogonal multi-index models. Shows that per-component Hermite structure matters, not just the global minimum exponent.

### 3. Add a "Limitations of the Scalar Approach" section

Explicitly flag that β★ (like IE and GE) is a scalar summary of multi-dimensional difficulty. For non-separable multi-index models, per-component analysis, and robust settings, a single exponent is insufficient.

### 4. Expand "Depth > 2" from "unknown" to "partially characterized"

Cite leap complexity (Abbe et al., COLT 2022/2023) and note that depth can reduce effective per-layer difficulty for hierarchically structured targets.

### 5. Add the low-degree conjecture cracks to Open Questions

> **Is the low-degree foundation sound?** The quasi-polynomial low-degree conjecture is false (Buhai et al., arXiv 2505.17360, May 2025). The low-degree method fails for robust subspace recovery (arXiv 2603.02594, Mar 2026). Whether NSE's computational thresholds hold beyond AMP for multi-index learning specifically is open.

### 6. Cite robust multi-index learning

Add to the research lineage: robust feature learning (arXiv 2410.16449) and SQ lower bounds for robust MIMs (OpenReview, NeurIPS 2025). Note that corruption adds complexity orthogonal to NSE.

---

## Part VI: The Bottom Line

### What the notes do well:
- **Lineage tracing**: 5/5 — the IE → GE → NSE progression is accurately and completely documented
- **Cross-connection**: 5/5 — PDS, transformer CSQ escape, hierarchical scaling laws, TabPFN application are all genuine connections
- **Intellectual honesty**: 5/5 — the self-correction notes are exemplary
- **Practical synthesis**: 4/5 — the TabPFN application is creative and well-motivated

### What the notes miss:
- **Foundation cracks**: The low-degree conjecture is under stress, and the notes don't know it
- **Scalar fallacy**: β★ is one number summarizing multi-dimensional difficulty; this limitation is under-acknowledged
- **Non-separable structure**: The entire framework assumes additive/separable models; real functions have interactions
- **Alternative algorithm classes**: Mean-field Langevin, robust algorithms, and depth > 2 provide escape routes the notes underexplore
- **Meta-lesson self-application**: The criticism of IE ("symmetry coincidence") applies to NSE itself, just less severely

### Net assessment:

The note collection is a **high-quality synthesis with blind spots that come from being too close to one research group's narrative** (the Krzakala/Zdeborová statistical physics school). The Defilippis et al. NSE paper, the Troiani et al. attention-multi-index duality, and the Cagnetta et al. scaling laws all come from the same lab. The notes tell the story this group is telling, and it's a good story — but the gaps are exactly where the narrative hits results from other groups (Buhai-Kothari complexity theory, Bietti-Bruna-Pillaud-Vivien fine-grained analysis, Diakonikolas-Kane-Ren robust learning) or where the theory's own assumptions break (non-separability, non-Gaussian, depth).

The most important follow-up action is to read arXiv 2505.17360 (quasi-polynomial low-degree conjecture is false) and assess its implications for the NSE barrier claim. If the low-degree framework's predictive power is weaker than assumed, the "genuine barrier" characterization of NSE needs significant hedging.

---

## Key Sources (New to This Review)

| Paper | Gap Addressed | Key Quote |
|---|---|---|
| Buhai, Hsieh, Jain, Kothari (arXiv 2505.17360, May 2025) | Gap 1 | "proving hardness results for average-case estimation problems by bounding the low-degree advantage (LDA)" — conjecture shown false |
| arXiv 2603.02594 (Mar 2026) | Gap 1 | "Low-degree polynomial framework... This success has led to the low-degree conjecture... [which] fails to predict robust subspace recovery" |
| Bietti, Bruna, Pillaud-Vivien (arXiv 2410.09678) | Gap 2 | "for multi-index models, focusing solely on the lowest degree can miss key structural details of the model and result in suboptimal rates" |
| Troiani et al. (AISTATS 2025, proceedings.mlr.press/v258/troiani25a) | Gap 3 | General (non-separable) multi-index computational limits |
| Abbe, Boix-Adsera, Misiakiewicz (COLT 2022, arXiv 2202.08658) | Gap 5 | "The merged-staircase property: a necessary and nearly sufficient condition for SGD learning" |
| Abbe, Boix-Adsera, Misiakiewicz (COLT 2023, arXiv 2302.11055) | Gap 5 | "the leap — which measures how 'hierarchical' target functions are" |
| arXiv 2410.16449 | Gap 6 | Robust feature learning for multi-index models |
| OpenReview cD4whTwm6G (NeurIPS 2025) | Gap 6 | "Algorithms and SQ Lower Bounds for Robustly Learning Real-valued Multi-Index Models" |
| Mousavi-Hosseini et al. (arXiv 2408.07254) | Gap 7 | Mean-field Langevin dynamics for multi-index on compact manifolds |
| Bruna, Hsu (arXiv 2504.05426v2) | Scalar fallacy | Survey covering full multi-index algorithm landscape |
