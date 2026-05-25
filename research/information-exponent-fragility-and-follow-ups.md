# Information Exponent Fragility and the Post-Isotropic Learning Landscape

*Paper review and follow-up research map. April 2026.*

**Anchor paper:** Cornacchia, Mikulincer, Mossel — "Low-dimensional functions are efficiently learnable under randomly biased distributions" (COLT 2025, arxiv 2502.06443v2)

## Core Claim

The information exponent — the complexity measure governing gradient-based learning of single-index models — is fragile. A small random perturbation to the data distribution's mean renders any Gaussian single-index model as easy to learn as a linear function. Same for sparse Boolean functions (Juntas) and their leap complexity.

## Why It Works

One equation: by Stein's lemma, the first Hermite coefficient of the shifted function is

$$F_1(\mu) = \mathbb{E}_{z \sim \mathcal{N}(\mu,1)}[f'(z)]$$

The expected derivative of f under a shifted Gaussian. Zero Hermite coefficients under isotropic Gaussians are a **coincidence of symmetries** — the function's symmetry perfectly aligns with the distribution's symmetry to produce exact cancellation.

The mechanism:
1. f is nonlinear → f'' ≠ 0 somewhere
2. F₁(μ) is a non-constant analytic function of μ (convolution with Gaussian extends to entire function on ℂ)
3. Non-constant analytic functions have isolated zeros
4. Random μ avoids the zeros with high (quantifiable) probability
5. Anti-concentration bound: P(|F₁(μ)| ≤ λ) ≤ exp(-c·log(1/λ)^{2/3}) — super-polynomial, essentially optimal at this generality

The information exponent drops to 1. The hardness was never intrinsic — it was an artifact of perfect distributional symmetry.

## Technical Results

- **Parametric** (f known): Õ(d) samples — nearly optimal, matching linear functions
- **Semi-parametric** (f unknown, ReLU net): Õ(d²) for direction recovery, O(d³) for function approximation
- **Boolean sparse** (k-sparse Juntas): Linear sample complexity, independent of target
- **Proof technique:** Extend F₁ to entire function on ℂ, apply small-ball estimates (Brudnyi, Nazarov-Sodin-Volberg for Gaussian; Carbery-Wright for Boolean), combined with Gaussian isoperimetry

## Critique

**Strengths:**
- Beautiful conceptual insight connecting smoothed analysis to information exponents
- Uniformity of the bound across function classes (function-independent anti-concentration)
- Technical elegance of the complex-analytic proof approach

**Weaknesses:**
- Algorithmic gap: the shift μ = ⟨w*, α⟩ depends on the unknown signal w*. Two-stage algorithms require query access or pre-shifted samples — contrived.
- Success probability caps at 1/2 - λ (hemisphere constraint from sphere initialization). No boosting discussed.
- Semi-parametric complexity still super-linear (d² not d). The "as easy as linear" narrative only holds when f is known.
- Boolean constants scale as η^{-(k+1)} — exponential in sparsity k.
- Multi-index left entirely open (acknowledged honestly). Single-index is a toy model.
- Experiments perfunctory: one Boolean function, d ≤ 175, no Gaussian experiments.

**Key insight:** The information exponent / leap complexity framework measures fragility of distributional symmetry, not intrinsic computational hardness. Worst-case results built on isotropic Gaussian assumptions may not be predictive of practical difficulty.

## Follow-Up Research (through Apr 2026)

### Direct Successor: Positive Distribution Shift Framework

**[arxiv 2602.08907]** Medvedev, Attias, **Cornacchia**, Misiakiewicz, Vardi, Srebro (Feb 2026)

Cornacchia co-authored. Generalizes the "shift helps" insight into a formal framework called *Positive Distribution Shift* (PDS). Key arguments:
- Distribution shift can be *beneficial* — train on a deliberately different distribution D'(x) to make computationally hard problems tractable
- The benefit is **computational, not statistical** — the problem was always information-theoretically solvable
- Connects PDS to membership query learning — PDS is the "realistic" version of choosing your inputs
- Reframes data augmentation, curriculum learning, synthetic data, pre-training as PDS instances

### New Hardness Measure: Noise Sensitivity Exponent

**[arxiv 2603.17896]** Defilippis, Krzakala, Loureiro, Maillard (Mar 2026)

Arguably the most important follow-up. Proposes the **Noise Sensitivity Exponent (NSE)** — a quantity determined by the activation function that governs statistical-to-computational gaps. Unlike the information exponent (fragile under perturbation):
- Controls computational hardness in single-index models with noise
- Controls specialization transition in separable multi-index models
- Controls sequential learning rate in hierarchical multi-index models
- Candidate for the perturbation-robust complexity measure the field needed

### Learning Rate Phase Transitions

**[arxiv 2510.21020]** Tsiolis, Mousavi-Hosseini, Erdogdu (NeurIPS 2025)

Phase transition between information exponent regime (small learning rate) and generative exponent regime (large learning rate). Complementary escape route: instead of shifting the data, increase the step size. Also introduces two-timescale layer-wise training that achieves generative exponent complexity without sample reuse.

### Multi-Index Models Solved (Near-Optimally)

**[arxiv 2511.15120]** Zhang, Wang, Fu, Lee (ICLR 2026)
— Generic multi-index models learnable at Õ(d) samples, Õ(d²) time. Layer-wise GD implicitly performs power iteration. Under "non-degenerate" assumptions (similar spirit: most functions are easy). Addresses the multi-index gap Cornacchia left open.

**[arxiv 2506.05500]** Damian, Lee, Bruna (Jun 2025)
— Sharp multi-index complexity via "generative leap exponent" k*: n = Θ(d^{1 ∨ k*/2}) is both necessary and sufficient. Spectral U-statistics over Hermite tensors.

### Smoothed Analysis Extended to Correlated Inputs

**[arxiv 2506.00764]** Chandrasekaran, Klivans (Jun 2025)
— Learning Juntas under Markov Random Fields in smoothed analysis framework. Extends from product distributions to correlated inputs. Only external field perturbed. First connection between graphical model structure learning and supervised learning.

### Anisotropic Data

**[arxiv 2503.23642]** Braun, Quang, Imaizumi (AISTATS 2025)
— Single-index from anisotropic Gaussian inputs. Vanilla SGD automatically adapts to covariance. Effective dimension replaces ambient dimension. Covariance shift helps too, not just mean shift.

### Other

- **[arxiv 2603.22664]** (Mar 2026) — Anti-concentration of polynomials: technical follow-up extending the Carbery-Wright tools
- **[arxiv 2504.05426]** Bruna, Hsu (Apr 2025) — Survey on algorithms for multi-index models. Good landscape overview.

## Research Lineage

```
Cornacchia et al. (COLT 2025)
│ "Information exponent is fragile under mean shift"
│
├──→ Positive Distribution Shift (Feb 2026)
│    Cornacchia + Srebro: shift as feature, not bug.
│    Framework for curriculum learning, data augmentation, query learning.
│
├──→ Noise Sensitivity Exponent (Mar 2026)
│    Krzakala group: better hardness measure that survives noise.
│    Single + multi-index. Candidate replacement for info exponent.
│
├──→ Learning Rate Phase Transitions (NeurIPS 2025)
│    Erdogdu group: escape info exponent via large LR, not data shift.
│    Complementary mechanism.
│
├──→ Multi-Index Near-Optimal (ICLR 2026)
│    Lee group: generic multi-index at Õ(d). "Generic" ≈ "most functions easy."
│    No shift needed under non-degeneracy.
│
├──→ Generative Leap (Jun 2025)
│    Bruna + Lee: sharp multi-index = Θ(d^{k*/2}). Right exponent identified.
│
├──→ Juntas under MRFs (Jun 2025)
│    Klivans: smoothed analysis survives correlated inputs.
│
└──→ Anisotropic SIM (AISTATS 2025)
     Covariance shift helps too. SGD adapts automatically.
```

## Open Questions (as of Apr 2026)

1. **Is NSE the right measure?** Brand new (Mar 2026). Does it predict practical difficulty? Does it survive other perturbation types?
2. **PDS in practice.** Can you automatically construct good training distributions D' without knowing the target? Or does the learner need external help?
3. **Non-Gaussian inputs.** Almost everything is Gaussian. Anisotropic (Braun) and MRF (Chandrasekaran-Klivans) are steps; general picture unclear.
4. **Depth > 2.** All results for two-layer networks. How does depth interact with these exponents?
5. **The algorithmic gap persists.** Even with PDS formalized, finding a good training distribution automatically remains open.

## Assessment

The Cornacchia paper was a catalyst. It showed the information exponent measures an artifact, not a barrier. In the year since, the field has:
- Built a framework (PDS) around the insight
- Proposed better hardness measures (NSE)
- Solved multi-index near-optimally under genericity (Zhang et al.)
- Extended smoothed analysis beyond independence (Chandrasekaran-Klivans)

The lasting contribution is the meta-lesson: **worst-case hardness results built on distributional knife-edges are not predictive of practical difficulty.** The field is now searching for complexity measures that are robust to perturbation — measuring real computational barriers, not symmetry coincidences.
