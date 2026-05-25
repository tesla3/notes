# Estimating Effective β★ and γ from Datasets: A Practitioner's Guide

*Tutorial note. April 2026. Companion to critical-review-nse-hierarchical-multi-index-tabpfn-difficulty-control.md*

> **Critical scoping note.** β★ (the Noise Sensitivity Exponent) governs the
> statistical-to-computational gap **only for symmetric (even) activation
> functions** (those with Generative Exponent GE = 2). For non-symmetric
> activations (GE = 1), no such gap exists in the proportional regime n = Θ(d)
> regardless of β★ — first-order methods already suffice. The entire estimation
> pipeline below is therefore most informative when the link function is
> symmetric. For non-symmetric links, the pipeline correctly reports "GE = 1,
> β★ irrelevant" and the γ estimate alone characterizes difficulty.
>
> Furthermore, the NSE paper (Defilippis et al., arXiv 2603.17896, §2.2 and
> Appendix C) shows that **β★ ≤ 2 for virtually all practical functions**: all
> even polynomials of degree < 20 satisfy β★ ≤ 2, and functions with β★ ≥ 3 are
> "fine-tuned" and "unstable under perturbations." In practice, you are almost
> always distinguishing β★ = 1 from β★ = 2, never looking for β★ ≥ 3.

## Key definitions used throughout

- **NSE (β★)**: The Noise Sensitivity Exponent. Defined in Defilippis et al. (arXiv 2603.17896, Definition 2.1) as:
  β★(σ) ≔ min{ β ∈ ℕ : E_{z∼N(0,1)}[σ^β(z) · (z² − 1)] ≠ 0 }

- **IE**: The Information Exponent (Ben Arous et al., 2021). The index of the first nonzero Hermite coefficient: IE(g) = min{ k ∈ ℕ : E[g(z) · Heₖ(z)] ≠ 0 }. Fragile — can be bypassed by data reuse, loss modification, or mean shift (Cornacchia et al., COLT 2025, arXiv 2502.06443).

- **GE**: The Generative Exponent (Damian et al., 2024). Defined as GE(g) = inf_T IE(T ∘ g), i.e., the information exponent after optimal label preprocessing T(y). For generic functions: non-symmetric → GE = 1; even → GE = 2. GE > 2 is fine-tuned and unstable. The GE = 1 vs GE = 2 dichotomy is the fundamental symmetry-based classification of learning difficulty (Defilippis et al., §2.3).

- **γ**: The power-law exponent governing importance decay αₖ ∝ k^{−γ} in the hierarchical multi-index model.

## Roadmap

We want to take a dataset {(xᵢ, yᵢ)}ᵢ₌₁ⁿ and produce three numbers:

- **γ** — how steeply feature importance decays (higher = easier, signal concentrated in few directions)
- **β★** — how many rounds of nonlinear computation are needed to extract signal along the hardest important direction (higher = harder)
- **Δ** — the noise level, which determines the signal-to-noise ratio λ that scales the stat-comp gap

The estimation pipeline has three stages:

```
Stage 1: Find the important directions wₖ and their importance weights λₖ
         → γ comes from the power-law fit to λₖ

Stage 2: Recover the link function σₖ(z) = E[y | ⟨wₖ, x⟩ = z] along each direction

Stage 3: Compute the Hermite decomposition of each σₖ
         → β★ comes from the first power β where E[σₖ^β(z)·(z²−1)] ≠ 0
```

**The stat-comp gap depends on all three.** For the single-index case, the information-theoretic threshold is α_WR^IT = Θ(λ^{−1}) while the algorithmic threshold is α_WR^Alg = Θ(λ^{−β★}) (Theorem 3.2). The gap widens as noise increases (λ → 0). For the hierarchical model, the algorithmic threshold for the k-th feature is α_k^Alg = Θ(k^{2γβ★}) (Theorem 5.2). So (β★, γ, Δ) together determine difficulty.

Two separate cases to keep straight:

| Case | What you know | What's hard |
|------|---------------|-------------|
| **Synthetic** (you control the DGP) | Ground-truth wₖ, σₖ, weights | Nothing — compute β★ and γ analytically |
| **Black-box** (real or sampled dataset) | Only {(xᵢ, yᵢ)} | Everything — must estimate all three stages from data |

For validating TabPFNv2's prior, you mostly have the **synthetic** case (you generated the data). For diagnosing real datasets, you need the **black-box** case. I'll cover both.

---

## Stage 1: Finding Important Directions and Estimating γ

### The model we're fitting

The hierarchical multi-index model (Defilippis et al., Eq. 6) assumes:

```
y(x) = Σₖ₌₁ᵖ  k^{−γ} · σ(⟨wₖ*, x⟩)  +  √Δ · ξ,   ξ ∼ N(0,1)
```

> **Important:** In the NSE paper's model, **all directions share the same
> activation function σ**. β★ is a property of this shared σ, not of individual
> directions. The per-direction estimation pipeline below is a natural extension
> for real data (where different directions *could* have different link
> functions), but the theoretical results from Defilippis et al. strictly apply
> only to the shared-σ case. When estimating per-direction, be aware that the
> scaling law α_k^Alg = Θ(k^{2γβ★}) assumes a single β★ for the whole model.

We need to recover the directions wₖ* and the importance spectrum αₖ = k^{−γ}.

### Method: Sufficient Dimension Reduction (SDR)

SDR finds the low-dimensional subspace span{w₁*,...,wₚ*} that preserves all information about y|x. The key SDR methods:

| Method | Kernel | Detects | Misses |
|--------|--------|---------|--------|
| **SIR** (Sliced Inverse Regression, Li 1991) | Cov(E[x\|y]) | Directions where E[x\|y] varies — requires c₁(σ) ≠ 0 | **Even (symmetric) σ entirely** (eigenvalues = 0) |
| **SAVE** (Sliced Average Variance Estimation, Cook 2000) | E[(Var[x\|y] − I)²] | Directions where Var[x\|y] varies — works for even σ | Purely linear σ(z)=z (conditional variance constant) |
| **DR** (Directional Regression, Li & Wang 2007) | Combines SIR + SAVE kernels | Broad — inherits strengths of both | Extreme edge cases |
| **MAVE** (Minimum Average Variance Estimation) | Direct nonparametric | Most general; works for any link | Computationally expensive; needs more data |

> **Critical choice: SIR vs SAVE for γ estimation.**
>
> The NSE framework matters only when σ is even (GE = 2). For even σ, c₁(σ) = 0,
> so **SIR eigenvalues are identically zero for all directions** — SIR is
> completely blind. You **must** use SAVE or DR to estimate γ in the regime where
> β★ is relevant. Conversely, SIR works well for non-symmetric σ (GE = 1), but
> in that regime β★ is irrelevant anyway.
>
> **Recommendation:** Run **both** SIR and SAVE. If SIR eigenvalues are all near
> zero but SAVE eigenvalues show structure, your link is likely symmetric and β★
> estimation matters. If SIR eigenvalues show clear structure, the link is
> non-symmetric and GE = 1. Use DR (which combines both) as the default when
> available — the `dr` R package implements it; the Python `sliced` package
> (v0.1.0) implements SIR and SAVE but **not DR**.

### Step-by-step: Estimating directions and importance spectrum

**Step 1.1: Standardize the features.**

```python
import numpy as np
import math
from sklearn.preprocessing import StandardScaler

scaler = StandardScaler()
X_std = scaler.fit_transform(X)  # n × d, zero mean, unit variance per feature
```

This is required because SIR/SAVE/DR assume E[x] = 0 and Cov[x] = I. Real data violates this, so we whiten first.

**Step 1.2: Run SDR to get eigenvalues and eigenvectors.**

Using the `sliced` Python package (scikit-learn compatible):

```python
from sliced import SlicedInverseRegression, SlicedAverageVarianceEstimation

# SIR — detects non-symmetric links (c₁ ≠ 0)
sir = SlicedInverseRegression(n_directions='auto', n_slices=20)
sir.fit(X_std, y)
sir_eigenvalues = sir.eigenvalues_      # λ₁ ≥ λ₂ ≥ ... ≥ λ_d
sir_directions = sir.directions_         # d × K matrix of directions

# SAVE — detects symmetric links (c₂ ≠ 0); ALSO works for non-symmetric
save = SlicedAverageVarianceEstimation(n_directions='auto', n_slices=20)
save.fit(X_std, y)
save_eigenvalues = save.eigenvalues_
save_directions = save.directions_

# Decision: which eigenvalues to use for γ estimation?
sir_total = sir_eigenvalues.sum()
save_total = save_eigenvalues.sum()

if sir_total > 0.01:
    # SIR found structure → link is non-symmetric → use SIR eigenvalues for γ
    # (β★ will be irrelevant in this case, but γ still matters)
    eigenvalues, directions = sir_eigenvalues, sir_directions
    sdr_method = 'SIR'
else:
    # SIR found nothing → link is likely symmetric → use SAVE eigenvalues for γ
    # (β★ estimation is now the key question)
    eigenvalues, directions = save_eigenvalues, save_directions
    sdr_method = 'SAVE'
```

If `sliced` isn't available, you can implement SIR and SAVE from scratch:

```python
def sir_manual(X, y, n_slices=20, n_dirs=None):
    """
    SIR: Sliced Inverse Regression (Li, 1991).
    X: (n, d) standardized features
    y: (n,) response

    SIR kernel: Γ_SIR = Cov(E[x|y])
    Detects directions where E[x|y] varies across y-slices.
    Requires c₁(σ) ≠ 0; returns zero eigenvalues for even σ.
    """
    n, d = X.shape
    Sigma = X.T @ X / n

    slices = np.array_split(np.argsort(y), n_slices)

    slice_means = np.zeros((n_slices, d))
    slice_counts = np.zeros(n_slices)
    for h, idx in enumerate(slices):
        slice_means[h] = X[idx].mean(axis=0)
        slice_counts[h] = len(idx)

    weights = slice_counts / n
    Gamma = np.zeros((d, d))
    for h in range(n_slices):
        m = slice_means[h].reshape(-1, 1)
        Gamma += weights[h] * (m @ m.T)

    eigenvalues, eigenvectors = np.linalg.eigh(Gamma)

    idx = np.argsort(eigenvalues)[::-1]
    eigenvalues = eigenvalues[idx]
    eigenvectors = eigenvectors[:, idx]

    if n_dirs is None:
        n_dirs = d
    return eigenvalues[:n_dirs], eigenvectors[:, :n_dirs]


def save_manual(X, y, n_slices=20, n_dirs=None):
    """
    SAVE: Sliced Average Variance Estimation (Cook, 2000).
    X: (n, d) standardized features
    y: (n,) response

    SAVE kernel: Γ_SAVE = E[(Cov(x|y) - I)²]
    Detects directions where Var[x|y] varies across y-slices.
    Works for even/symmetric σ (where SIR fails).
    """
    n, d = X.shape
    I_d = np.eye(d)

    slices = np.array_split(np.argsort(y), n_slices)

    Gamma = np.zeros((d, d))
    for h, idx in enumerate(slices):
        n_h = len(idx)
        if n_h < 2:
            continue
        X_h = X[idx]
        Sigma_h = X_h.T @ X_h / n_h  # Within-slice covariance
        diff = Sigma_h - I_d
        Gamma += (n_h / n) * (diff @ diff)

    eigenvalues, eigenvectors = np.linalg.eigh(Gamma)

    idx = np.argsort(eigenvalues)[::-1]
    eigenvalues = eigenvalues[idx]
    eigenvectors = eigenvectors[:, idx]

    if n_dirs is None:
        n_dirs = d
    return eigenvalues[:n_dirs], eigenvectors[:, :n_dirs]
```

**Step 1.3: Determine the number of significant directions K.**

Plot the eigenvalues on a log scale. Look for a gap (elbow):

```python
import matplotlib.pyplot as plt

plt.figure(figsize=(8, 4))
plt.subplot(1, 2, 1)
plt.plot(range(1, len(eigenvalues)+1), eigenvalues, 'o-')
plt.xlabel('Direction k')
plt.ylabel('Eigenvalue λ_k')
plt.title(f'Eigenvalue spectrum ({sdr_method})')

plt.subplot(1, 2, 2)
pos = eigenvalues > 0
plt.plot(np.arange(1, len(eigenvalues)+1)[pos],
         eigenvalues[pos], 'o-')
plt.yscale('log')
plt.xscale('log')
plt.xlabel('Direction k (log)')
plt.ylabel('Eigenvalue λ_k (log)')
plt.title('Log-log spectrum')
plt.tight_layout()
```

**Formal test for the number of directions:** Use Li's sequential χ² test (Li, 1991, §4) or the sequential permutation test from the `ICtest` R package (Nordhausen et al., 2017). For Python, a practical approach:

```python
def permutation_test_K(X, y, n_slices=20, n_perms=200, alpha=0.05,
                       sdr_func=sir_manual):
    """
    Sequential permutation test for the number of significant SDR directions.
    Tests H₀: the k-th eigenvalue is noise, by permuting y.

    Reference: Bura & Yang (2011), "Dimension estimation in sufficient
    dimension reduction: A unifying approach." JMVA 102(1):130-142.
    """
    n = X.shape[0]
    true_evals, _ = sdr_func(X, y, n_slices=n_slices)

    null_max_evals = np.zeros(n_perms)
    for p in range(n_perms):
        y_perm = y[np.random.permutation(n)]
        null_evals, _ = sdr_func(X, y_perm, n_slices=n_slices)
        null_max_evals[p] = null_evals[0]  # largest null eigenvalue

    # Threshold: 95th percentile of null's largest eigenvalue
    threshold = np.percentile(null_max_evals, 100 * (1 - alpha))

    K = 0
    for k in range(len(true_evals)):
        if true_evals[k] > threshold:
            K = k + 1
        else:
            break

    return K, threshold, true_evals
```

> **Note on the wrong heuristic.** A previous version of this note suggested
> "λₖ > 2/n" as a Tracy-Widom threshold. This is incorrect — it doesn't
> correspond to any standard result. The Tracy-Widom edge for the largest
> eigenvalue of a Wishart(n,d) matrix is at (1 + √(d/n))², which is O(1) not
> O(1/n). For SIR, the null distribution depends on (n, d, n_slices) and is
> best estimated by the permutation test above. Use the permutation test or
> Li's sequential χ² test (implemented in the R `dr` package).

**Step 1.4: Fit the power-law decay to get γ.**

The hierarchical model predicts αₖ ∝ k^{−γ}. The relationship between SDR eigenvalues and αₖ depends on which method was used:

- **SIR eigenvalues** ∝ αₖ² · [c₁(σ)]². Since all directions share the same σ (in the paper's model), [c₁(σ)]² is a constant and the *slope* of the log-log fit gives −2γ. But if σ is even, c₁(σ) = 0 and all SIR eigenvalues are zero — **SIR cannot estimate γ for symmetric functions.**

- **SAVE eigenvalues** ∝ αₖ² · f(σ), where f(σ) involves higher-order Hermite coefficients. Again, the slope of the log-log fit gives −2γ when σ is shared.

- **For general multi-index** (different σₖ per direction), eigenvalues are αₖ² · g(σₖ), which confounds the γ estimate unless all σₖ produce similar g values. The power-law fit is a *proxy* for γ, not an exact measurement.

```python
K = ...  # number of significant directions from Step 1.3

if K >= 4:
    # Fit middle range (exclude first and last eigenvalues — they deviate
    # from the power law; the first captures disproportionate variance,
    # the tail is noisy)
    k_fit = np.arange(2, K)  # indices 2 to K-1 (1-indexed: k=2 to K-1)
    log_k = np.log(k_fit)
    log_lambda = np.log(eigenvalues[1:K-1] + 1e-20)  # offset by 1 for 0-indexing

    slope, intercept = np.polyfit(log_k, log_lambda, 1)
    gamma_hat = -slope / 2

    # Goodness-of-fit check
    predicted = slope * log_k + intercept
    r_squared = 1 - np.sum((log_lambda - predicted)**2) / np.sum((log_lambda - log_lambda.mean())**2)
    if r_squared < 0.8:
        print(f"Warning: poor power-law fit (R²={r_squared:.2f}). "
              f"γ estimate may be unreliable.")
elif K >= 2:
    # Too few points for reliable fit — use ratio of first two
    gamma_hat = -np.log(eigenvalues[1] / eigenvalues[0]) / (2 * np.log(2))
    print(f"Warning: only {K} directions — γ estimate is rough.")
else:
    gamma_hat = np.inf  # only 1 direction → very steep decay

print(f"Estimated γ = {gamma_hat:.3f}")
print(f"  γ > 1.5: easy (signal in few directions)")
print(f"  γ ≈ 1.0: moderate")
print(f"  γ < 0.7: hard (many directions carry signal)")
```

**Interpretation of γ:**

| γ | Interpretation | For meta-learner |
|---|---------------|-----------------|
| γ > 1.5 | Very steep decay — first 2-3 features capture most signal | Easy: simple model suffices |
| γ ≈ 1.0 | Moderate decay — 10+ features matter | Moderate: needs multi-feature extraction |
| γ ∈ (0.5, 0.7) | Flat decay — many features carry comparable signal | Hard: needs to learn many directions from context |

**Pitfalls:**

- **SIR is blind to symmetric links — this is structural, not a minor concern.** For even σ (the case where β★ matters), SIR eigenvalues are identically zero because E[x|y] doesn't vary. You MUST use SAVE or DR for γ estimation when the link is symmetric. Run both SIR and SAVE and compare: if SIR finds nothing but SAVE finds structure, the link is symmetric and β★ estimation is relevant.
- If n/d < 10, SDR becomes unreliable. Need n >> d for stable estimates. Minimum: n/d > 10 for SIR, n/d > 20 for SAVE (Cook, 2000).
- The eigenvalues from SIR/SAVE are proportional to αₖ² · [Hermite coefficient of σ]², not exactly αₖ². The power-law exponent from SDR eigenvalues is a *proxy* for γ valid when all directions share the same σ.
- Power-law fit is fragile at the tails. Fit to the middle range (k = 2 to K−1) and exclude the extremes, as the code above does.

### Shortcut for synthetic data (TabPFNv2 prior sampling)

If you generated the dataset from a known DGP (BNN, SCM, etc.), you can estimate γ more directly:

```python
# For BNN-generated data:
# 1. Extract the first layer weights W₁ of the BNN
# 2. SVD of W₁ gives the "important directions"
# 3. Singular values σₖ(W₁) are proxies for importance weights

U, S, Vt = np.linalg.svd(W1, full_matrices=False)
# S = singular values, sorted descending
slope, _ = np.polyfit(np.log(np.arange(1, len(S)+1)), np.log(S), 1)
gamma_hat_bnn = -slope  # Note: not /2 here because S are already amplitudes not variances
```

For SCM-generated data: the structural equations define the link functions directly. Trace the causal graph to determine how many independent "information channels" feed into y, and their relative strengths.

---

## Stage 2: Recovering Link Functions

Once you have directions ŵₖ from Stage 1, you need the link function σₖ along each direction.

### Step 2.1: Project data onto recovered directions

```python
# ŵₖ from SDR (columns of eigenvector matrix)
# Project each sample onto the k-th direction
z_k = X_std @ w_hat_k  # (n,) projections onto direction k
```

### Step 2.2: Standardize the projection

The NSE theory assumes z ~ N(0,1). Make the projection approximately standard normal:

```python
z_k = (z_k - z_k.mean()) / z_k.std()
```

Check Gaussianity with a quick test:

```python
from scipy import stats
_, p_value = stats.normaltest(z_k)
if p_value < 0.01:
    print(f"Warning: projection is non-Gaussian (p={p_value:.4f})")
    print("NSE estimates may be unreliable for this direction")
    print("Consider using Gauss-Hermite quadrature (Step 3.2) instead of sample averages")
```

If the projection is strongly non-Gaussian (e.g., the data is categorical-dominated), the NSE framework doesn't apply directly. Flag this and treat β★ as undefined.

### Step 2.3: Nonparametric regression of y on z

Estimate σ̂ₖ(z) = E[y | ⟨ŵₖ, x⟩ = z]:

```python
from scipy.interpolate import UnivariateSpline

# Option A: Kernel regression (most general, bandwidth matters)
def nadaraya_watson(z, y, z_eval, bandwidth=None):
    """
    Nadaraya-Watson kernel regression.

    If bandwidth is None, uses Silverman's rule of thumb:
    h = 1.06 * σ_z * n^{-1/5}.
    Reference: Silverman (1986), "Density Estimation for Statistics
    and Data Analysis", §3.4.2.
    """
    if bandwidth is None:
        bandwidth = 1.06 * np.std(z) * len(z) ** (-0.2)
    K = np.exp(-0.5 * ((z_eval[:, None] - z[None, :]) / bandwidth) ** 2)
    K_sum = K.sum(axis=1, keepdims=True)
    K_sum[K_sum == 0] = 1  # avoid division by zero
    return (K * y[None, :]).sum(axis=1) / K_sum.squeeze()

z_eval = np.linspace(z_k.min(), z_k.max(), 200)
sigma_hat = nadaraya_watson(z_k, y, z_eval)  # auto-bandwidth via Silverman

# Option B: Smoothing spline (good for smooth σ)
sort_idx = np.argsort(z_k)
spl = UnivariateSpline(z_k[sort_idx], y[sort_idx], s=len(z_k)*0.1)
sigma_hat = spl(z_eval)

# Option C: Binned means (simplest, most robust)
n_bins = 30
bins = np.linspace(z_k.min(), z_k.max(), n_bins + 1)
bin_centers = 0.5 * (bins[:-1] + bins[1:])
bin_means = np.zeros(n_bins)
for b in range(n_bins):
    mask = (z_k >= bins[b]) & (z_k < bins[b+1])
    if mask.sum() > 0:
        bin_means[b] = y[mask].mean()
    else:
        bin_means[b] = np.nan
```

**Recommendation:** Use kernel regression with Silverman's rule bandwidth as a starting point. For higher precision, select bandwidth by leave-one-out cross-validation. For quick-and-dirty estimates, binned means with 20-30 bins work fine.

**Bandwidth matters for β★.** Oversmoothing (bandwidth too large) attenuates high-frequency components of σ̂, biasing higher-order Hermite coefficients toward zero. This can make β★ appear larger than it truly is. Undersmoothing introduces noise. When in doubt, try multiple bandwidths and check that the β★ estimate is stable.

### Step 2.4: Diagnostic — is the link symmetric?

This is the first-order diagnostic. If σₖ is non-symmetric (any nonzero odd Hermite coefficient), GE = 1 and the NSE gap is irrelevant — the task is "easy" along this direction regardless of β★.

> **Recall GE definition:** GE(g) = inf_T IE(T ∘ g) — the information exponent
> minimized over all label transformations T(y). Non-symmetric g generically has
> GE = 1; even g generically has GE = 2. (Damian et al., 2024; Defilippis et
> al., §2.3.)

```python
def test_symmetry(z, y, n_bins=30):
    """
    Test whether E[y|z] is approximately symmetric (even function).

    Compares binned means at +z and −z.
    Naming convention: left_means = means for z < 0, right_means = means for z > 0.
    For an even function: E[y|z] = E[y|−z], so left and right are mirror images.
    """
    bins = np.linspace(0, 3, n_bins // 2 + 1)  # positive-z bins only
    left_means = []    # E[y] in the mirror-negative bin
    right_means = []   # E[y] in the positive bin

    for b in range(len(bins) - 1):
        z_lo, z_hi = bins[b], bins[b+1]

        mask_right = (z >= z_lo) & (z < z_hi)     # positive z
        mask_left = (z >= -z_hi) & (z < -z_lo)    # mirror-negative z

        if mask_right.sum() > 5 and mask_left.sum() > 5:
            right_means.append(y[mask_right].mean())
            left_means.append(y[mask_left].mean())

    left_means = np.array(left_means)
    right_means = np.array(right_means)

    if len(left_means) == 0:
        return {'is_even': False, 'is_odd': False, 'is_general': True,
                'even_residual': np.inf, 'odd_residual': np.inf}

    # For even σ: E[y|z] = E[y|−z] → left ≈ right
    # For odd σ: E[y|z] = −E[y|−z] → left ≈ −right (after centering)
    even_residual = np.mean((right_means - left_means)**2)
    odd_residual = np.mean((right_means + left_means)**2)
    total_var = np.var(np.concatenate([left_means, right_means]))

    is_even = even_residual / (total_var + 1e-10) < 0.1
    is_odd = odd_residual / (total_var + 1e-10) < 0.1

    return {
        'is_even': is_even,       # symmetric → β★ matters
        'is_odd': is_odd,         # anti-symmetric → GE=1, β★ irrelevant
        'is_general': not (is_even or is_odd),  # GE=1, β★ irrelevant
        'even_residual': even_residual,
        'odd_residual': odd_residual,
    }
```

**Decision logic:**

```
If σ is NOT symmetric (not even):
  → GE = 1, no stat-comp gap, β★ is irrelevant for this direction
  → This direction is "easy" (first-order methods suffice)

If σ IS symmetric (even function):
  → Need to estimate β★ (proceed to Stage 3)
  → This is where the gap lives
```

Most BNN/SCM-generated functions will be non-symmetric (ReLU, GELU, SiLU are all non-symmetric). This is itself evidence that the prior is biased toward easy tasks.

---

## Stage 3: Estimating β★

This is the hard part. β★ is defined as (Defilippis et al., Definition 2.1):

```
β★(σ) = min{ β ∈ ℕ : E[σ^β(z) · (z² − 1)] ≠ 0 },   z ~ N(0,1)
```

We need to compute E[σ^β(z) · He₂(z)] for β = 1, 2, 3, ... and find the first nonzero one.

> **β★ is only relevant for symmetric (even) σ with GE = 2.** For non-symmetric
> σ, the definition still applies mathematically, but the result doesn't govern
> computational hardness. Example: σ(z) = z (linear) has β★ = 2 because
> E[z·(z²−1)] = E[z³]−E[z] = 0, but E[z²·(z²−1)] = E[z⁴]−E[z²] = 2 ≠ 0.
> Yet learning the linear model is trivially easy (GE = 1). The β★ value is
> meaningless here because the non-symmetry allows direct first-order recovery.

### Understanding what we're computing

He₂(z) = z² − 1 is the second (probabilist's) Hermite polynomial.

For each power β of the link function:
- Compute σ^β(z) = [σ(z)]^β
- Project it onto He₂: compute E_z[σ(z)^β · (z² − 1)] where z ~ N(0,1)

**Why He₂?** The NSE paper proves (Theorem 3.2) that the optimal AMP algorithm's computational threshold scales as α_WR^Alg = Θ(λ^{−β★}). The proof (sketched in §6.1) works through the state evolution of AMP (Mondelli & Montanari, 2019; Maillard et al., 2020a), which is optimal among first-order iterative methods (Celentano et al., 2020). The He₂ projection determines whether the AMP iterate gains correlation with the signal at each step: the effective observation after β iterations has its useful signal component proportional to the He₂ coefficient of σ^β.

**Why powers of σ?** Each AMP iteration effectively raises the effective channel function to the next power. After β iterations, the effective observation is proportional to σ^β (plus lower-order terms). The first power whose He₂ projection is nonzero is when the algorithm starts making progress.

### Step 3.1: Estimate the Hermite projection for each power β

```python
def estimate_beta_star(z, y, sigma_hat_func, max_beta=5, n_bootstrap=200):
    """
    Estimate β★ from data.

    z: (n,) standardized projections ⟨ŵ, x⟩, should be ≈ N(0,1)
    y: (n,) response
    sigma_hat_func: callable, estimated link function σ̂(z)

    Returns: estimated β★ and confidence diagnostics
    """
    n = len(z)
    He2 = z**2 - 1  # Second Hermite polynomial

    # Evaluate estimated link function at data points
    sigma_vals = sigma_hat_func(z)

    results = {}
    for beta in range(1, max_beta + 1):
        # Compute σ^β(z) · He₂(z)
        sigma_power = sigma_vals ** beta

        # The estimator: sample average approximates E[σ^β(z)·He₂(z)]
        # This works because z ≈ N(0,1) by construction (Step 2.2)
        C_beta = np.mean(sigma_power * He2)

        # Paired bootstrap confidence interval
        # CRITICAL: must use the SAME index for both arrays to preserve pairing
        boot_vals = np.zeros(n_bootstrap)
        for b in range(n_bootstrap):
            idx = np.random.choice(n, size=n, replace=True)
            boot_vals[b] = np.mean(sigma_power[idx] * He2[idx])

        ci_lo = np.percentile(boot_vals, 2.5)
        ci_hi = np.percentile(boot_vals, 97.5)
        se = np.std(boot_vals)

        results[beta] = {
            'C_beta': C_beta,
            'se': se,
            'ci': (ci_lo, ci_hi),
            'significant': (ci_lo > 0) or (ci_hi < 0),  # CI excludes zero
            'z_score': abs(C_beta) / (se + 1e-10),
        }

    # β★ = first β where C_β is significantly nonzero
    beta_star = None
    for beta in range(1, max_beta + 1):
        if results[beta]['significant'] and results[beta]['z_score'] > 2.0:
            beta_star = beta
            break

    if beta_star is None:
        beta_star = max_beta  # couldn't detect — very hard or link is ~zero

    return beta_star, results
```

### Step 3.2: Alternative — direct Hermite decomposition (cleaner, avoids powers)

Instead of computing powers of σ and checking He₂ projection, we can decompose σ itself into Hermite coefficients. This gives complementary information:

```python
def hermite_decomposition(z, sigma_vals, max_order=8):
    """
    Estimate Hermite coefficients of σ using sample averages.

    If z ~ N(0,1), then c_j = E[σ(z) · He_j(z)] / j!
    The sample average estimates this.

    z: (n,) ≈ N(0,1) samples
    sigma_vals: (n,) σ̂(zᵢ) values
    """
    from numpy.polynomial.hermite_e import hermeval

    coeffs = {}
    for j in range(max_order + 1):
        # Construct He_j(z): probabilist's Hermite polynomial
        # He_j coefficients: [0, ..., 0, 1] with 1 at position j
        c = np.zeros(j + 1)
        c[j] = 1.0
        He_j_vals = hermeval(z, c)

        # c_j = E[σ(z) · He_j(z)]   (unnormalized)
        # The Hermite polynomials satisfy E[He_j · He_k] = j! · δ_{jk}
        # So the normalized coefficient is E[σ · He_j] / j!
        raw = np.mean(sigma_vals * He_j_vals)
        normalized = raw / math.factorial(j)

        coeffs[j] = {
            'raw': raw,           # E[σ · He_j]
            'normalized': normalized,  # coefficient in Hermite expansion
        }

    return coeffs


def hermite_decomposition_quadrature(sigma_func, max_order=8, n_quad=100):
    """
    Estimate Hermite coefficients via Gauss-Hermite quadrature.

    This is MORE ROBUST than sample averages because it doesn't depend on
    the empirical distribution of z being Gaussian. It evaluates σ̂ on a
    fixed quadrature grid weighted by the Gaussian measure.

    Use this when projections fail the Gaussianity test (Step 2.2).

    Reference: Numerical Recipes, §4.6; numpy.polynomial.hermite_e.hermegauss.
    """
    from numpy.polynomial.hermite_e import hermegauss, hermeval

    # Gauss-Hermite quadrature nodes and weights (probabilist's convention)
    # ∫ f(x) exp(-x²/2) dx ≈ Σ wᵢ f(xᵢ)
    nodes, weights = hermegauss(n_quad)
    # Normalize: we want E_z[f(z)] = ∫ f(z) φ(z) dz where φ is std normal pdf
    # hermegauss gives weights for exp(-x²/2), so divide by √(2π)
    weights = weights / np.sqrt(2 * np.pi)

    sigma_at_nodes = sigma_func(nodes)

    coeffs = {}
    for j in range(max_order + 1):
        c = np.zeros(j + 1)
        c[j] = 1.0
        He_j_at_nodes = hermeval(nodes, c)

        raw = np.sum(weights * sigma_at_nodes * He_j_at_nodes)
        normalized = raw / math.factorial(j)

        coeffs[j] = {'raw': raw, 'normalized': normalized}

    return coeffs
```

**Interpreting the Hermite coefficients:**

```
c₀ = E[σ(z)]           — the mean of the link (constant term)
c₁ = E[σ(z)·z]         — linear correlation with z
c₂ = E[σ(z)·(z²−1)]   — projection onto He₂ (THIS IS what drives β★=1)
c₃ = E[σ(z)·(z³−3z)]  — cubic component
c₄ = E[σ(z)·He₄(z)]   — quartic component
```

**Decision rules from Hermite coefficients:**

```
c₁ ≠ 0  →  σ is non-symmetric  →  GE = 1  →  NO gap  →  β★ irrelevant
           (This is the common case for ReLU, GELU, SiLU, tanh)

c₁ = 0, c₂ ≠ 0  →  σ is symmetric, IE = 2, β★ = 1
                      (e.g., z²−1, |z|, cos(z))
                      Gap: α_WR^Alg = Θ(λ⁻¹) — same as info-theoretic

c₁ = 0, c₂ = 0, c₃ ≠ 0  →  σ has odd component with IE = 3
                              Still need to check β★ via the powers test
                              (IE and β★ can differ — see below)

c₁ = 0, c₂ = 0  →  Must go to the powers-of-σ test (Step 3.1)
                     to determine β★
```

### Step 3.3: Putting it all together — the complete β★ estimator

```python
def estimate_nse(z, y, sigma_hat_func, max_beta=4, n_bootstrap=500):
    """
    Complete NSE estimation for one direction.

    Returns: dict with beta_star, GE, hermite_coeffs, diagnostics
    """
    sigma_vals = sigma_hat_func(z)
    n = len(z)

    # 1. Hermite decomposition
    hc = hermite_decomposition(z, sigma_vals, max_order=6)

    # 2. Check symmetry via c₁
    c1_significant = abs(hc[1]['raw']) > 2 * np.std(sigma_vals * z) / np.sqrt(n)

    if c1_significant:
        return {
            'beta_star': None,  # β★ is irrelevant
            'GE': 1,
            'diagnosis': 'Non-symmetric link → GE=1, no stat-comp gap',
            'hermite_coeffs': hc,
            'difficulty': 'easy (for this direction)',
        }

    # 3. σ is approximately symmetric → check c₂ (He₂ projection of σ itself)
    He2 = z**2 - 1
    C1 = np.mean(sigma_vals * He2)  # This is the β=1 test

    # Paired bootstrap test for C₁
    # CRITICAL: must use SAME indices for sigma_vals and He2
    boot_C1 = np.zeros(n_bootstrap)
    for b in range(n_bootstrap):
        idx = np.random.choice(n, size=n, replace=True)
        boot_C1[b] = np.mean(sigma_vals[idx] * He2[idx])

    if abs(C1) > 2 * np.std(boot_C1):
        return {
            'beta_star': 1,
            'GE': 2,  # symmetric, IE=2
            'diagnosis': 'Symmetric link with nonzero He₂ coeff → β★=1',
            'hermite_coeffs': hc,
            'C_values': {1: C1},
            'difficulty': 'moderate (stat-comp gap exists but minimal)',
        }

    # 4. C₁ ≈ 0 → check higher powers
    beta_star, power_results = estimate_beta_star(
        z, y, sigma_hat_func, max_beta=max_beta, n_bootstrap=n_bootstrap
    )

    return {
        'beta_star': beta_star,
        'GE': 2,
        'diagnosis': f'Symmetric link, β★={beta_star} → '
                     f'gap amplified by λ^{{-{beta_star}}}',
        'hermite_coeffs': hc,
        'C_values': {b: r['C_beta'] for b, r in power_results.items()},
        'difficulty': 'hard' if beta_star >= 2 else 'moderate',
    }
```

### Why powers of σ, not just Hermite coefficients of σ?

This is the subtle point. β★ and the information exponent (IE) are **different quantities** despite both involving Hermite analysis.

- **IE** = index of the first nonzero Hermite coefficient of σ itself
- **β★** = first power β such that σ^β has a nonzero He₂ coefficient

They differ because raising σ to a power mixes Hermite coefficients via the Hermite linearization formula. Example:

```
σ(z) = He₄(z) = z⁴ − 6z² + 3
  → c₂(σ) = E[He₄(z) · He₂(z)] / 2! = 0   (orthogonality)
  → IE = 4

But σ²(z) = He₄(z)²
  → Using the linearization He_m · He_n = Σₛ C(m,s)C(n,s)s! He_{m+n−2s},
     He₄² has a He₂ term with coefficient C(4,3)²·3! = 16·6 = 96
  → c₂(σ²) = 96 · E[He₂²] = 96 · 2! = 192 ≠ 0
  → β★ = 2
```

So **IE = 4 but β★ = 2** for He₄.

**What the NSE paper actually shows about β★ values (Defilippis et al., §2.2 and Appendix C):**

| β★ | Condition | Prevalence |
|----|-----------|------------|
| β★ = 1 | Equivalent to IE = 2 (nonzero He₂ coefficient) | Common (e.g., z²−1, \|z\|, cos(z)) |
| β★ = 2 | "Captures the majority of functions with zero second Hermite coefficient," including all He_{2k} for k > 1. **All even polynomials of degree < 20 satisfy β★ ≤ 2.** | The generic case when β★ > 1 |
| β★ ≥ 3 | "Usually fine-tuned." Paper constructs examples with β★ ∈ {3, 4} in Appendix C. | Rare, unstable under perturbation |
| β★ = ∞ | "Corresponds to extremely fine-tuned models with GE > 2." Unlearnable in proportional regime. | Pathological |

**Practical consequence:** You MUST compute the powers test, not just the Hermite decomposition of σ. The Hermite decomposition tells you the IE. Only the powers test gives you β★. But given that β★ ≤ 2 for virtually all practical even functions, **testing up to β = 3 is sufficient** — if β★ > 3, the function is likely pathologically fine-tuned.

---

## Complete Pipeline: Estimating (β★, γ, Δ) for a Dataset

```python
def estimate_noise_level(X, y, n_neighbors=10):
    """
    Estimate noise variance Δ using k-nearest-neighbors residuals.

    For each point, predict y using the mean of its k nearest neighbors'
    y-values. The mean squared residual estimates Var[y|x] ≈ Δ.

    Reference: simple nonparametric noise estimation; see also
    Meinshausen & Bühlmann (2006) for regression-based approaches.
    """
    from sklearn.neighbors import NearestNeighbors

    nn = NearestNeighbors(n_neighbors=n_neighbors)
    nn.fit(X)
    _, indices = nn.kneighbors(X)

    y_pred = np.mean(y[indices[:, 1:]], axis=1)  # exclude self
    residuals = y - y_pred
    delta_hat = np.var(residuals) / 2  # factor of 2: each residual has noise from both y and y_pred

    return delta_hat


def estimate_difficulty(X, y, n_directions=10, n_slices=20):
    """
    Full pipeline: estimate γ, per-direction β★, and noise level Δ for a dataset.

    X: (n, d) feature matrix
    y: (n,) response

    Returns: γ estimate, per-direction β★ estimates, noise level, diagnostics

    NOTE: In the NSE paper's hierarchical model, all directions share one σ,
    so there is one β★ for the whole model. This pipeline estimates per-direction
    β★ as a practical extension for real data where link functions may differ.
    The theoretical scaling law α_k^Alg = Θ(k^{2γβ★}) strictly applies only
    to the shared-σ case (Defilippis et al., Theorem 5.2).
    """
    from sklearn.preprocessing import StandardScaler
    import functools

    n, d = X.shape

    # ── Noise estimation ──
    delta_hat = estimate_noise_level(X, y)

    # ── Stage 1: SDR — run BOTH SIR and SAVE ──
    scaler = StandardScaler()
    X_std = scaler.fit_transform(X)

    sir_evals, sir_evecs = sir_manual(X_std, y, n_slices=n_slices)
    save_evals, save_evecs = save_manual(X_std, y, n_slices=n_slices)

    # Decide which SDR to use based on which found structure
    sir_signal = sir_evals[0] if len(sir_evals) > 0 else 0
    save_signal = save_evals[0] if len(save_evals) > 0 else 0

    if sir_signal > 0.01:
        evals, evecs = sir_evals, sir_evecs
        sdr_method = 'SIR'
        likely_symmetric = False
    else:
        evals, evecs = save_evals, save_evecs
        sdr_method = 'SAVE'
        likely_symmetric = True

    # Determine significant directions via permutation test
    K_detected, threshold, _ = permutation_test_K(
        X_std, y, n_slices=n_slices,
        sdr_func=sir_manual if sdr_method == 'SIR' else save_manual
    )
    K = min(n_directions, max(K_detected, 1))

    # Estimate γ from eigenvalue decay (middle range)
    if K >= 4:
        k_fit = np.arange(2, K)
        log_k = np.log(k_fit)
        log_lambda = np.log(evals[1:K-1] + 1e-20)
        slope, _ = np.polyfit(log_k, log_lambda, 1)
        gamma_hat = -slope / 2
    elif K >= 2:
        gamma_hat = -np.log(evals[1] / (evals[0] + 1e-20)) / (2 * np.log(2))
    else:
        gamma_hat = np.inf

    # ── Stage 2 & 3: Per-direction link recovery and β★ ──
    direction_results = []
    for k in range(K):
        w_k = evecs[:, k]
        z_k = X_std @ w_k
        z_k = (z_k - z_k.mean()) / (z_k.std() + 1e-10)

        # Kernel regression for link function (Silverman bandwidth)
        bw = 1.06 * np.std(z_k) * len(z_k) ** (-0.2)
        # Use functools.partial to avoid lambda closure issues in loops
        sigma_func = functools.partial(nadaraya_watson, z_k, y, bandwidth=bw)

        # Estimate NSE
        result = estimate_nse(z_k, y, sigma_func)
        result['direction_index'] = k + 1
        result['eigenvalue'] = evals[k]
        result['sdr_method'] = sdr_method
        direction_results.append(result)

    # ── Summary statistics ──
    beta_stars = [r['beta_star'] for r in direction_results if r['beta_star'] is not None]
    n_easy = sum(1 for r in direction_results if r['GE'] == 1)
    n_moderate = sum(1 for r in direction_results if r.get('beta_star') == 1)
    n_hard = sum(1 for r in direction_results if r.get('beta_star', 0) and r.get('beta_star', 0) >= 2)

    # Effective β★: the max across directions with significant eigenvalues.
    # NOTE: This is a heuristic summary — the NSE paper defines β★ as a
    # property of the shared activation, not of the dataset. For real data
    # with potentially different link functions per direction, the max is a
    # reasonable proxy for the hardest component.
    effective_beta_star = max(beta_stars) if beta_stars else 1

    # Effective SNR for the strongest direction
    signal_var = np.var(y) - delta_hat
    effective_snr = signal_var / (delta_hat + 1e-10)

    return {
        'gamma': gamma_hat,
        'effective_beta_star': effective_beta_star,
        'noise_level_delta': delta_hat,
        'effective_snr': effective_snr,
        'n_directions': K,
        'n_easy_directions': n_easy,
        'n_moderate_directions': n_moderate,
        'n_hard_directions': n_hard,
        'sdr_method': sdr_method,
        'likely_symmetric': likely_symmetric,
        'direction_details': direction_results,
        'summary': (
            f"γ={gamma_hat:.2f}, effective β★={effective_beta_star}, "
            f"Δ={delta_hat:.3f}, SNR={effective_snr:.1f}, "
            f"K={K} directions ({n_easy} easy, {n_moderate} moderate, {n_hard} hard) "
            f"[via {sdr_method}]"
        ),
    }
```

---

## Interpretation Guide

### Reading the (β★, γ, SNR) triple

The stat-comp gap depends on **all three**: β★ controls the exponent, γ controls the per-feature cost, and SNR controls the magnitude.

| γ \ β★ | β★ irrelevant (GE=1) | β★ = 1 | β★ = 2 |
|--------|----------------------|--------|--------|
| **γ > 1.5** | Trivial | Easy | Moderate |
| **γ ≈ 1.0** | Easy | Moderate | Hard |
| **γ < 0.7** | Moderate | Hard | Very hard |

**SNR modulates severity:** At high SNR (λ >> 1), even β★ = 2 tasks are feasible — the gap λ^{−β★} vs λ^{−1} is small when λ is large. At low SNR (λ → 0), the gap explodes. A β★ = 2 task with high SNR can be easier than a β★ = 1 task with very low SNR.

> **β★ ≥ 3 is omitted from the table** because the NSE paper shows it requires
> "fine-tuned" functions that are "unstable under perturbations" (§2.2). In
> practice, if you estimate β★ ≥ 3, first suspect estimation error, then suspect
> an unusual/synthetic activation.

The *expected prediction for TabPFNv2's prior*: most datasets will land in the top-left cell (GE=1, high γ) because BNNs with ReLU/GELU produce non-symmetric functions and random SCMs with simplicity preference produce steep decay. If this prediction is confirmed, the "too easy" hypothesis is validated.

### What β★ means for a meta-learner

- **β★ = 1:** The He₂ coefficient of σ is nonzero — equivalent to IE = 2 (Defilippis et al., §2.2). Linear statistics (sample covariance Xᵀy) detect the signal after a single step. AMP is already optimal. Easy for TabPFN.
- **β★ = 2:** The generic case for symmetric functions with zero He₂ coefficient (Defilippis et al., §2.2: "captures the majority of functions with zero second Hermite coefficient"). Need to compute σ²(z) and project onto He₂. This requires *nonlinear label transformation* — exactly what softmax attention enables (Nishikawa, Song, Oko, Wu & Suzuki, ICML 2025, proceedings.mlr.press/v267/nishikawa25a: "the inference-time sample complexity surpasses the Correlational Statistical Query (CSQ) lower bound, owing to nonlinear label transformations naturally induced by the Softmax self-attention mechanism"). Two rounds of attention needed. TabPFN needs this in its training distribution.
- **β★ ≥ 3:** Rare in practice. Challenging even for deep transformers.

---

## Validation: Testing on Known Ground Truth

Before running on real data, validate the pipeline on synthetic data with known parameters:

```python
def generate_hierarchical_multi_index(n, d, p, gamma, beta_star_target,
                                       noise_std=0.1, seed=None):
    """
    Generate a dataset with known (γ, β★) for validation.

    NOTE: Uses random Gaussian directions (not QR-orthogonalized), matching
    the NSE paper's setup where w*_k ~ iid N(0, I_d/d) (Defilippis et al.,
    §2.1). These are approximately orthogonal in high d but not exactly.
    """
    rng = np.random.default_rng(seed)

    # Random Gaussian directions, normalized to unit norm (matching paper)
    W = rng.standard_normal((d, p))
    W = W / np.linalg.norm(W, axis=0, keepdims=True)  # each column has ||w|| = 1

    # Feature matrix
    X = rng.standard_normal((n, d))

    # Choose link function based on target β★
    # All directions share the SAME σ, matching the paper's model.
    if beta_star_target == 'easy':
        # Non-symmetric → GE=1, β★ irrelevant
        sigma = lambda z: np.maximum(z, 0)  # ReLU
    elif beta_star_target == 1:
        # Symmetric, β★=1 (He₂ has nonzero He₂ coefficient trivially)
        sigma = lambda z: z**2 - 1          # He₂
    elif beta_star_target == 2:
        # Symmetric, β★=2  (He₄ has IE=4, β★=2; verified in Appendix C)
        sigma = lambda z: z**4 - 6*z**2 + 3  # He₄
    else:
        raise ValueError(f"β★={beta_star_target} requires fine-tuned construction. "
                         f"See Defilippis et al. Appendix C for β★ ∈ {{3,4}} examples.")

    # Power-law importance weights
    alphas = np.arange(1, p + 1, dtype=float) ** (-gamma)

    # Generate y = Σ_k α_k σ(⟨w_k, x⟩) + √Δ · ξ  (matching Eq. 6)
    projections = X @ W  # (n, p)
    y = np.zeros(n)
    for k in range(p):
        y += alphas[k] * sigma(projections[:, k])
    y += noise_std * rng.standard_normal(n)

    return X, y, {'W': W, 'alphas': alphas, 'gamma': gamma,
                  'beta_star': beta_star_target, 'noise_std': noise_std}

# Validate:
for true_gamma in [0.7, 1.0, 1.5]:
    for true_beta in ['easy', 1, 2]:
        X, y, truth = generate_hierarchical_multi_index(
            n=2000, d=50, p=10, gamma=true_gamma,
            beta_star_target=true_beta, noise_std=0.3, seed=42
        )
        result = estimate_difficulty(X, y)
        print(f"True γ={true_gamma}, β★={true_beta} → "
              f"Est γ={result['gamma']:.2f}, β★={result['effective_beta_star']}, "
              f"Δ={result['noise_level_delta']:.3f} "
              f"(SDR: {result['sdr_method']}, symmetric: {result['likely_symmetric']})")
```

This validation step is essential. If the estimator can't recover known (β★, γ) from synthetic data, it won't work on real data either. Expect:
- γ recovery is usually good (±0.2) when n/d > 10
- β★ recovery is noisy when n < 1000 or d < 20
- The symmetry test (Step 2.4) is the most reliable signal
- **For β★ = 1 vs β★ = 2 tasks:** SAVE should detect directions (not SIR, since these are symmetric links). If the pipeline falls back to SIR and finds nothing, the SDR routing is wrong — check that SAVE eigenvalues show structure.

---

## Known Limitations and Failure Modes

1. **Categorical features break the Gaussian assumption.** If X has many categoricals, the projections ⟨w, x⟩ won't be Gaussian. The Hermite analysis becomes unreliable. Workaround: estimate β★ only on the continuous features; treat categoricals as a separate difficulty axis. Use the Gauss-Hermite quadrature estimator (`hermite_decomposition_quadrature`) instead of sample averages.

2. **Small n/d ratio.** SDR requires n >> d for stable direction estimates. At n/d < 5, the estimated directions are unreliable and everything downstream is garbage. Minimum: n/d > 10 for SIR, n/d > 20 for SAVE.

3. **The link function might not be single-index along each direction.** If the true model has *interactions* between directions (y = σ(⟨w₁,x⟩ · ⟨w₂,x⟩)), the multi-index decomposition doesn't capture this. The β★ estimate would be misleading. Diagnostic: check if the multi-index model's explained variance (sum of per-direction R²) is much lower than total R².

4. **Nonparametric regression quality.** The β★ estimate is sensitive to the link function estimate. Oversmoothing kills high-frequency Hermite components, biasing β★ upward. Undersmoothing introduces noise. Cross-validate the bandwidth, or at minimum try 2-3 values and check stability.

5. **Per-direction β★ vs shared β★.** The NSE paper assumes all directions share the same σ, giving one β★ for the whole model. The pipeline estimates per-direction β★, which is a practical extension without direct theoretical backing. The "effective β★ = max over directions" summary is a heuristic — no theorem guarantees this governs the overall difficulty.

6. **Bootstrap tests have limited power at small n.** With n < 500, the bootstrap CI for C_β is wide. You might not be able to distinguish β★ = 1 from β★ = 2. Accept the uncertainty — report the CI, not just the point estimate.

7. **Noise level estimation is approximate.** The k-NN residual method provides a rough Δ estimate. It overestimates noise when the true function is complex (high effective dimension) and the k-NN predictor is poor. For synthetic data where you control Δ, skip the estimation and use the known value.

8. **SIR is blind to symmetric links — by design, not as a minor pitfall.** When the link is even (the case where β★ matters), SIR eigenvalues are identically zero. The pipeline addresses this by running both SIR and SAVE, but if only SIR is available, the pipeline cannot estimate γ for symmetric links at all.

9. **β★ = ∞ (GE > 2) is undetectable.** If the link has GE > 2 (extremely fine-tuned, unlearnable in proportional regime), the powers test will find no significant C_β for any β. The pipeline reports β★ = max_beta, which is indistinguishable from β★ being large but finite. In practice, GE > 2 is pathological.

---

## Tools and Software

| Tool | Language | What it does |
|------|----------|-------------|
| `sliced` (joshloyal/sliced) | Python | SIR, SAVE — sklearn-compatible SDR. **Does NOT implement DR.** |
| `dr` package | R | SIR, SAVE, DR, pHd — the most complete SDR toolkit. **Only R source for DR.** |
| `ICtest` | R | Formal tests for number of significant SIR/SAVE directions |
| `numpy.polynomial.hermite_e` | Python | **Probabilist's** Hermite polynomials He_n — use this for NSE |
| `scipy.special.eval_hermite` | Python | **Physicist's** Hermite polynomials H_n — different normalization! |

**Warning on Hermite polynomial conventions:** NumPy's `hermite_e` module uses *probabilist's* Hermite polynomials (He_n), which is what the NSE theory uses. SciPy's `eval_hermite` uses *physicist's* Hermite polynomials (H_n), which differ by scaling:

```
H_n(x) = 2^{n/2} He_n(x√2)     (physicist's in terms of probabilist's)
He_n(x) = 2^{-n/2} H_n(x/√2)   (probabilist's in terms of physicist's)
```

The orthogonality relations also differ:
- Probabilist's: E_{z∼N(0,1)}[He_m(z) · He_n(z)] = n! · δ_{mn}
- Physicist's: ∫ H_m(x) H_n(x) e^{−x²} dx = √π · 2^n · n! · δ_{mn}

**Use `numpy.polynomial.hermite_e` (`hermeval`) for consistency with the NSE definition.** If you accidentally use physicist's polynomials, the Hermite coefficients will be wrong by factors of 2^{n/2} and the β★ test will give incorrect results.

---

## References

- Li, K.C. (1991). "Sliced Inverse Regression for Dimension Reduction." JASA 86(414):316-327. — Original SIR paper; §4 gives the sequential χ² test for number of directions.
- Cook, R.D. & Weisberg, S. (1991). "Sliced Inverse Regression for Dimension Reduction: Comment." JASA 86(414):328-332.
- Cook, R.D. (2000). "SAVE: a method for dimension reduction and graphics in regression." Commun. Statist.-Theory Meth. 29:2109-2121. — SAVE paper.
- Li, B. & Wang, S. (2007). "On directional regression for dimension reduction." JASA 102(479):997-1008. — Directional Regression (recommended default).
- Bura, E. & Yang, J. (2011). "Dimension estimation in sufficient dimension reduction: A unifying approach." JMVA 102(1):130-142. — Proper tests for SDR dimension.
- Nordhausen, K., Oja, H. & Tyler, D.E. (2017). "Asymptotic and bootstrap tests for subspace dimension." JSPI 188:20-30. — Basis for ICtest R package.
- Ben Arous, G., Gheissari, R. & Jagannath, A. (2021). "Online stochastic gradient descent on non-convex losses from high-dimensional inference." JMLR 22(106):1-51. — Information Exponent definition.
- Damian, A., Lee, J.D. & Soltanolkotabi, M. (2024). "Smoothing the landscape of the information exponent via label preprocessing." — Generative Exponent (GE) definition.
- Cornacchia, E., Misiakiewicz, T. & Vardi, G. (2025). "On the fragility of the information exponent." COLT 2025, arXiv 2502.06443. — IE fragility; bypassed by data reuse, loss modification, mean shift.
- Mondelli, M. & Montanari, A. (2019). "Optimal combination of linear and spectral estimators for generalized linear models." FoCM. — AMP state evolution for single-index.
- Maillard, A., Loureiro, B., Krzakala, F. & Zdeborová, L. (2020). "Phase retrieval in high dimensions: Statistical and computational phase transitions." NeurIPS. — AMP analysis.
- Celentano, M., Montanari, A. & Wu, Y. (2020). "The estimation error of general first order methods." COLT. — AMP optimality among first-order methods.
- Defilippis, L., Krzakala, F., Loureiro, B. & Maillard, A. (2026). "A Noise Sensitivity Exponent Controls Large Statistical-to-Computational Gaps in Single- and Multi-Index Models." arXiv 2603.17896. — **Primary source**: NSE definition (Def. 2.1), β★ categorization (§2.2), single-index gap (Thm. 3.2), committee machine specialization (Thm. 4.2), hierarchical scaling (Thm. 5.2).
- Nishikawa, S., Song, Y., Oko, K., Wu, D. & Suzuki, T. (2025). "Nonlinear transformers can perform inference-time feature learning." ICML 2025. proceedings.mlr.press/v267/nishikawa25a. — Softmax transformers surpass CSQ bounds.
- Silverman, B.W. (1986). "Density Estimation for Statistics and Data Analysis." Chapman & Hall, §3.4.2. — Bandwidth selection rule of thumb.
- Efron, B. & Tibshirani, R.J. (1993). "An Introduction to the Bootstrap." Chapman & Hall, Ch. 8. — Paired bootstrap methodology.
