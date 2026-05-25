# NSE, Hierarchical Multi-Index Models, and Amortized Learning

*Analysis note. April 2026. Companion to information-exponent-fragility-and-follow-ups.md*

**Sources:** Defilippis, Krzakala, Loureiro, Maillard — "A Noise Sensitivity Exponent Controls Large Statistical-to-Computational Gaps in Single- and Multi-Index Models" (arxiv 2603.17896, Mar 2026). Cross-referenced with Cornacchia et al. (arxiv 2502.06443, COLT 2025).

## The Landscape: Three Hardness Measures

| Measure | What it captures | Fragile? | Status |
|---------|-----------------|----------|--------|
| Information exponent (IE) | Hermite rank of link function | Yes — killed by mean shift, data reuse, large LR | Artifact, not a real barrier |
| Generative exponent (GE) | IE after optimal label preprocessing | Mostly — GE > 2 cases are fine-tuned and unstable | Useful dichotomy: GE=1 (non-symmetric) vs GE=2 (symmetric) |
| Noise sensitivity exponent (NSE/β★) | How noise amplifies symmetry-induced hardness | **No** — survives perturbation, reuse, loss changes | Candidate for real computational barrier |

The field's trajectory: IE → GE → NSE. Each refinement strips away artifacts and gets closer to genuine computational hardness.

## The Noise Sensitivity Exponent

### Definition

For activation σ: ℝ → ℝ:

```
β★(σ) = min{ β ∈ ℕ : E[σ^β(z) · (z² − 1)] ≠ 0 },  z ~ N(0,1)
```

Compute powers of σ, project onto the second Hermite polynomial He₂(z) = z²−1, find the first nonzero projection. The (z²−1) factor appears because for even functions, the second Hermite coefficient drives weak recovery (the first is zero by symmetry).

### Why It Matters

In a noisy single-index model y = √λ · σ(w*·x) + noise:

- **Info-theoretic threshold**: n/d = Θ(1/λ) — noise hurts linearly
- **Computational threshold** (optimal first-order method): n/d = Θ(1/λ^β★)
- **Gap**: λ^{−β★} vs λ^{−1} — widens as noise increases

The mechanism: the AMP algorithm extracts signal via E[z²−1 | y]. Taylor-expanding the posterior around λ=0, the first β★−1 powers of σ have zero projection onto z²−1. The signal only "leaks through" at order β★. Hence λ^{−β★} scaling.

### Concrete Values

| β★ | Functions | Prevalence |
|----|-----------|-----------|
| 1 | Any even σ with nonzero He₂ coefficient: z²−1, \|z\|, cos(z) | Generic — most even functions |
| 2 | Higher Hermite polynomials He₂ₖ (k>1); functions with zeroed He₂ | Natural but less common |
| 3+ | Fine-tuned constructions | Rare |
| ∞ | GE > 2 functions — unlearnable in proportional regime | Extremely rare, fragile |

Key insight: β★ = 1 is equivalent to IE = 2 (the function has a nonzero He₂ coefficient). β★ only matters for even/symmetric activations — non-symmetric functions have GE = 1 and no gap at all.

### Numerical Example

d = 10,000, SNR λ = 0.01:

| | β★ = 1 (z²−1) | β★ = 2 (He₄) |
|--|---|---|
| Info-theoretic n/d | 100 | 100 |
| Algorithmic n/d | 100 | 10,000 |
| Samples needed (IT) | 1M | 1M |
| Samples needed (Alg) | 1M | 100M |

With β★ = 2: the algorithm needs 100× more data than information theory requires.

## Hierarchical Multi-Index Models

### The Model

```
y(x) = Σₖ k^{−γ} σ(⟨wₖ*, x⟩) + √Δ · noise
```

A sum of p single-index components with **power-law decaying importance**. γ > 1/2 controls decay steepness. Introduced by Ren et al. (2025) to explain neural scaling laws from first principles.

### Why It's the Right Abstraction

Real learning tasks decompose into sub-tasks of decreasing importance:
- Images: edges → textures → parts → objects
- Language: frequency → syntax → semantics → long-range structure
- Any PCA-like decomposition: first components carry most signal

The hierarchical model captures exactly this: a target with power-law structure over independently important directions.

### Sequential Learning and Scaling Laws

Features are learned one at a time, in order. To learn feature k computationally:

```
n/d = Θ(k^{2γβ★})
```

The unlearned features act as effective noise for the feature you're trying to learn. Feature k has signal strength k^{−γ}, so it's equivalent to a noisy single-index problem with SNR ∝ k^{−2γ}.

**MSE scaling laws** (aggregate error as function of data α = n/d):

| | Optimal (info-theoretic) | Algorithmic (first-order) |
|--|---|---|
| MSE exponent | −(1 − 1/(2γ)) | −(1/β★)(1 − 1/(2γ)) |

The NSE divides the scaling exponent by β★. With β★ = 2, your scaling law is half as steep — you need the square of the data for the same error reduction.

### Numerical Example

d = 10,000, γ = 1, p = 100 features:

**β★ = 1 (z²−1):**
| Feature k | Threshold n/d = k² | Samples |
|-----------|--------------------|---------| 
| 1 | 1 | 10K |
| 10 | 100 | 1M |
| 100 | 10,000 | 100M |

**β★ = 2 (He₄):**
| Feature k | Threshold n/d = k⁴ | Samples |
|-----------|--------------------|---------| 
| 1 | 1 | 10K |
| 10 | 10,000 | 100M |
| 50 | 6.25M | 62.5B |

With β★ = 2, feature 10 costs 100× more data. Feature 50 is essentially unreachable.

## Amortized Learning: Can TabPFN-Style Models Close the Gap?

### The Idea

Pre-train a transformer on synthetic hierarchical multi-index tasks. At inference, feed in-context examples (x₁,y₁),...,(xₙ,yₙ) → get near-Bayes-optimal predictions in one forward pass. Does this bypass the computational threshold?

### Two Types of Hardness, Two Answers

**Fragile hardness (IE/leap complexity) — YES, amortization helps:**

The information exponent hardness comes from SGD-specific limitations (equator escape, cold start). A pre-trained transformer:
- Never runs SGD at inference — no equator problem
- Has seen shifted distributions during pre-training — implicitly exploits Cornacchia mechanism
- Has learned the right computation for each problem shape
- Amortizes algorithm *design*, which is exactly what's needed

**Robust hardness (NSE gap) — NO, amortization cannot close it:**

The NSE gap holds against ALL polynomial-time algorithms, not just first-order methods:
- The transformer at inference is a fixed-depth, fixed-width polynomial-size circuit
- AMP lower bounds aren't about convergence speed — they're sharp thresholds that don't improve with more iterations
- Low-degree polynomial and SQ lower bounds corroborate the gap for broader algorithm classes
- Pre-training amortizes algorithm *design*, not algorithm *power* — per-instance computation is still bounded

### The Practical Middle Ground

The theoretical gap is asymptotic (d → ∞). For finite d, a TabPFN-style model can:

1. **Beat SGD/AMP by large constant factors** — avoids cold start, implements near-optimal algorithm, efficient context usage
2. **Leverage the prior massively** — if pre-training distribution matches test structure (right γ, activation, noise), acts as powerful regularizer
3. **Match optimal rates for β★ = 1** (no gap) — genuinely Bayes-optimal for the most common case
4. **Interpolate between thresholds for finite d** — can approach info-theoretic limit when the gap is modest at practical problem sizes

### Summary Table

| Hardness type | Source | Amortization closes it? | Why |
|---|---|---|---|
| IE/leap (fragile) | Algorithm choice | **Yes** | Transformer learns right computation; never faces equator problem |
| NSE gap (robust) | Computational limit | **No** | Poly-time is poly-time, whether pre-trained or not |
| Practical finite-d | Mixed | **Partially** | Constants matter; prior is powerful; gap may be modest |

### Design Implications

If building a TabPFN-style model for structured/scientific data:

- **Pre-training prior should include**: varying γ, multiple activations (symmetric and non-symmetric), range of noise levels, hierarchical structure
- **Context window is the binding constraint**: need n/d = Θ(k^{2γβ★}) for feature k, so thousands of context examples for moderate d
- **Activation-aware priors**: including both symmetric (β★ matters) and non-symmetric (β★ irrelevant) activations trains the model to handle both regimes
- **Expected wins**: near-optimal for β★ = 1 (most common), large constant-factor gains for all regimes, zero per-task tuning

## Key Takeaways for ML Practice

1. **Asymmetric activations (ReLU, GELU, SiLU) dodge the entire NSE issue.** GE = 1, no symmetry-induced gap, no NSE relevance. This is one theoretical reason they dominate practice.

2. **If using symmetric features** (squared attention, cosine similarity, polynomial kernels, even transformations), β★ controls your noise sensitivity. Prefer components with β★ = 1.

3. **Scaling law slopes are activation-dependent.** NSE divides the exponent. Choosing β★ = 1 activations gives steepest scaling. Testable prediction.

4. **"More data doesn't help" has a precise diagnosis:** either γ is large (hierarchy decays fast — easy features exhausted) or β★ is large (architecture can't extract remaining features even though information is present).

5. **Amortized inference (TabPFN-style) is optimal strategy for fragile hardness** — which is the common case in practice. For robust hardness, nothing poly-time works, so you're not leaving anything on the table.

6. **The lasting insight from this line of work:** worst-case hardness built on distributional symmetry (Cornacchia) is not predictive. Noise-amplified hardness from activation symmetry (NSE) is real. The field now has both a negative result (many barriers are artifacts) and a positive result (here's what genuine barriers look like).
