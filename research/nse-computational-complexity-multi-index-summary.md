# The Noise Sensitivity Exponent: Computational Complexity in Multi-Index Model Learning

*Synthesis note. April 2026. Distills findings from personal research notes on hardness measures for gradient-based learning.*

---

## The Core Question

What is the right complexity measure for how hard it is to learn a multi-index model f(x) = g(W*ᵀx) from data using gradient-based methods? The answer has evolved rapidly over 2021–2026, converging on the **Noise Sensitivity Exponent (NSE)**, denoted **β★**.

## The Progression of Hardness Measures

### Information Exponent (IE) — Ben Arous et al., 2021

The first formal measure. IE(g) = min{ k ∈ ℕ : E[g(z)·Heₖ(z)] ≠ 0 } — the index of the first nonzero Hermite coefficient of the link function. Governs the sample complexity of one-pass SGD on single-index models under isotropic Gaussian inputs: n = Θ(d^{IE}).

**Fatal flaw:** The IE is fragile. Cornacchia, Mikulincer & Mossel (COLT 2025, arXiv 2502.06443) showed that a small random perturbation to the data distribution's mean drops the IE to 1 for *any* nonlinear function. The mechanism: zero Hermite coefficients under isotropic Gaussians are a **coincidence of symmetries**, not an intrinsic computational barrier. A non-constant analytic function (which F₁(μ) = E_{z∼N(μ,1)}[f'(z)] always is) has only isolated zeros, so random μ avoids them with high probability.

### Generative Exponent (GE) — Damian, Lee, Bruna, 2024

GE(g) = inf_T IE(T ∘ g) — the information exponent after optimal label preprocessing T(y). Accounts for the fact that algorithms can transform labels before correlating with inputs. Key dichotomy: non-symmetric σ → GE = 1 (no gap); even σ → GE = 2. GE > 2 is fine-tuned and unstable under perturbation.

**Improvement over IE:** Robust to label transformations. **Remaining gap:** Doesn't capture the full computational picture with noise — the stat-comp gap depends on noise level, not just function symmetry.

### Noise Sensitivity Exponent (β★) — Defilippis, Krzakala, Loureiro, Maillard, March 2026

arXiv 2603.17896. The current best candidate.

**Definition:** β★(σ) ≔ min{ β ∈ ℕ : E_{z∼N(0,1)}[σ^β(z) · (z² − 1)] ≠ 0 }

**What it controls across three settings:**

| Setting | Info-theoretic threshold | Computational threshold | Gap |
|---------|------------------------|------------------------|-----|
| Single-index + noise (SNR = λ) | n/d = Θ(1/λ) | n/d = Θ(1/λ^β★) | λ^{β★−1} |
| Separable multi-index | — | Specialization transition | Controlled by β★ |
| Hierarchical multi-index (γ decay) | — | k-th feature at n/d = Θ(k^{2γβ★}) | Multiplicative amplification |

**Why it's better:** Survives perturbation, data reuse, loss modification, and large learning rates — the operations that killed the IE. It measures a genuine computational barrier, not a symmetry coincidence.

**Practical bound:** β★ ≤ 2 for virtually all practical functions. All even polynomials of degree < 20 have β★ ≤ 2. Functions with β★ ≥ 3 are "fine-tuned" and unstable. In practice the key distinction is β★ = 1 vs β★ = 2.

## Key Connections

### NSE → Positive Distribution Shift (PDS)

Medvedev, Cornacchia, Srebro et al. (arXiv 2602.08907, Feb 2026) formalized the insight that training on a deliberately shifted distribution D' can make computationally hard problems tractable. PDS reshapes the Fourier landscape to create staircase structure that SGD can climb. The benefit is **computational, not statistical** — the problem was always information-theoretically solvable; PDS provides gradient signal where the isotropic landscape is flat.

Connection: PDS is one escape route from high IE/β★ — instead of needing Θ(d^{β★}) samples, engineer D' so the effective IE drops to 1. NSE tells you the barrier height; PDS tells you how to lower it via data design.

### NSE → Learning Rate Phase Transitions

Tsiolis, Mousavi-Hosseini, Erdogdu (NeurIPS 2025, arXiv 2510.21020). A complementary escape route: instead of shifting the data, increase the step size. Phase transition between IE regime (small LR) and GE regime (large LR). Two-timescale layer-wise training achieves GE complexity without data manipulation.

Connection: Both PDS and large-LR escape the IE barrier. NSE β★ is the residual barrier that persists even after these tricks.

### NSE → Multi-Index Near-Optimal Solutions

- Zhang, Wang, Fu, Lee (ICLR 2026, arXiv 2511.15120): Generic multi-index models learnable at Õ(d) samples, Õ(d²) time. Layer-wise GD implicitly performs power iteration. Under "non-degenerate" assumptions (i.e., most functions are easy).
- Damian, Lee, Bruna (Jun 2025, arXiv 2506.05500): Sharp multi-index complexity via "generative leap exponent" k*: n = Θ(d^{1 ∨ k*/2}) is both necessary and sufficient. Spectral U-statistics over Hermite tensors.

Connection: These results characterize the *achievable* complexity for multi-index models. NSE characterizes the *barrier* — the gap between what information theory allows and what first-order methods achieve.

### NSE → Transformer ICL and Tabular Learning

Nishikawa et al. (ICML 2025) proved softmax transformers can **surpass CSQ lower bounds** for single-index models. Softmax self-attention induces nonlinear label transformations that CSQ algorithms cannot perform. This means transformers can potentially escape the β★ barrier that constrains first-order/AMP methods — the algorithmic class where NSE lower bounds are proved is strictly weaker than transformer computation.

### NSE → Hierarchical Scaling Laws

Cagnetta, Petrini, Wyart, Zdeborová (ICML 2025) showed neural scaling laws arise from power-law distributed task components. In the hierarchical multi-index model y = Σₖ k^{−γ} σ(⟨wₖ*, x⟩) + noise, the exponent γ controls importance decay while β★ controls per-feature extraction difficulty. The two parameters (γ, β★) together determine the full computational difficulty profile.

## Research Lineage

```
Ben Arous et al. (2021): Information Exponent (IE)
│
├─ Abbe et al. (COLT 2022–23): Staircase/leap complexity
│
├─ Cornacchia et al. (COLT 2025): IE is fragile under mean shift
│   │
│   ├──→ PDS framework (Medvedev+Cornacchia+Srebro, Feb 2026)
│   │    Data shift as computational lever
│   │
│   └──→ Smoothed analysis extensions (Chandrasekaran+Klivans, Jun 2025)
│        Juntas under MRFs
│
├─ Damian et al. (2024): Generative Exponent (GE)
│   │
│   └──→ Damian+Bruna+Lee (Jun 2025): Sharp multi-index via k*
│
├─ Tsiolis et al. (NeurIPS 2025): LR phase transitions (IE → GE escape)
│
├─ Defilippis et al. (Mar 2026): Noise Sensitivity Exponent (β★) ← THE MEASURE
│
├─ Zhang+Lee (ICLR 2026): Multi-index near-optimal under genericity
│
└─ Braun et al. (AISTATS 2025): Anisotropic single-index (covariance shift)
```

## Open Questions (as of April 2026)

1. **Is β★ the final answer?** Brand new, not yet stress-tested. Could have its own fragilities under distribution types not yet examined.
2. **Non-Gaussian inputs.** Nearly all theory is Gaussian. Real data is mixed-type, categorical, correlated. Only modest extensions exist (anisotropic Gaussian, MRFs).
3. **Depth > 2.** All results for two-layer networks. How network depth interacts with β★ is unknown.
4. **β★ irrelevance for GE = 1.** Non-symmetric activations have no stat-comp gap regardless of β★. The measure matters only when σ is even — the regime that matters is narrower than it first appears.
5. **Can transformers escape β★?** Softmax provably escapes CSQ bounds (single-index). Whether this extends to hierarchical multi-index is plausible but unproven.

## Meta-Lesson

The lasting insight from this research trajectory: **worst-case hardness results built on distributional knife-edges are not predictive of practical difficulty.** The IE measured a symmetry coincidence. The field's progression IE → GE → β★ is a search for complexity measures that reflect genuine computational barriers — measuring what algorithms actually cannot do, not what happens to be hard under one perfectly symmetric setup.

---

## Sources

- Ben Arous, Gheissari, Jagannath (2021). Online SGD on high-dimensional single-index models.
- Cornacchia, Mikulincer, Mossel (COLT 2025). arXiv 2502.06443.
- Damian, Lee, Bruna (2024). Generative exponent.
- Damian, Lee, Bruna (Jun 2025). arXiv 2506.05500.
- Defilippis, Krzakala, Loureiro, Maillard (Mar 2026). arXiv 2603.17896.
- Medvedev, Attias, Cornacchia, Misiakiewicz, Vardi, Srebro (Feb 2026). arXiv 2602.08907.
- Tsiolis, Mousavi-Hosseini, Erdogdu (NeurIPS 2025). arXiv 2510.21020.
- Zhang, Wang, Fu, Lee (ICLR 2026). arXiv 2511.15120.
- Cagnetta, Petrini, Wyart, Zdeborová (ICML 2025).
- Nishikawa, Song, Oko, Wu, Suzuki (ICML 2025).
- Abbe, Adsera, Misiakiewicz (COLT 2022, 2023).
- Braun, Quang, Imaizumi (AISTATS 2025). arXiv 2503.23642.
- Chandrasekaran, Klivans (Jun 2025). arXiv 2506.00764.
