# TabPFN Bar Distribution: How Regression Becomes Classification

Source: PriorLabs/TabPFN codebase (verified through v2.6), Hollmann et al. *Nature* 637 (2025) 319–326
Date: 2026-04-01

## The Core Idea

TabPFN doesn't predict a number. It predicts a **probability distribution** over the target space by outputting softmax logits over a fixed set of bins. The training loss is negative log density — the **log scoring rule** applied to a piecewise distribution, equivalent to cross-entropy with a bin-width correction. This gives full uncertainty quantification for free.

## The Bin Grid

A fixed set of borders is chosen **once before pre-training** and stored in the checkpoint. The actual values and count come from the checkpoint — they cannot be determined from the inference code alone (the code initializes dummy borders that are overwritten on load). The config field `num_buckets` (default −1) is set during training; `get_loss_criterion` creates throwaway borders that `load_state_dict` replaces.

The borders array defines three types of regions:

```
    (-∞, b₁]          [b₁, b₂]    ...    [b_{K-1}, b_K]          [b_K, +∞)
    ─────────┤         ├────────          ────────┤         ├──────────
    left edge          interior bins               right edge
    half-open          bounded                     half-open
```

**Interior bins** are bounded intervals with finite width. **Edge bins** are half-open intervals extending to ±∞. This is what `FullSupportBarDistribution` means — the distribution has support on all of ℝ.

The outermost borders (`borders[0]` and `borders[-1]`) are **not** the edges of the distribution. They are reference points that control the tail shape (explained below). The actual support is (−∞, +∞).

**Z-normalization is the bridge.** Every dataset's targets are standardized to mean=0, std=1 before the model sees them. A single fixed grid in z-space handles all datasets. At inference, the borders are affine-rescaled back to the original target space: `raw_borders = z_borders × std + mean`.

## Walkthrough: Bins, Density, and Loss

### Setup

```
Borders array: [-3, -1, 0, 1, 3]

              (-∞, -1]     [-1, 0]    [0, 1]     [1, +∞)
               ├──────┼──────┼─────┼──────┤
  Bin index:      0        1       2       3
  Type:       half-open  interior interior half-open
  Ref width:     2         1        1        2
```

Model outputs logits for 4 bins: `z = [1.0, 2.0, 3.0, 1.5]`

### Step 1 — Softmax: logits → probability mass per bin

```
p = softmax(z) = [0.0784, 0.2131, 0.5793, 0.1293]
```

Each p_k is the total probability mass in bin k's entire domain — including the infinite tail for edge bins. They sum to 1 by construction.

### Step 2 — Density: two regimes

**Interior bins** — piecewise-uniform. Density is constant within each bin:

```
density_k = p_k / w_k

bin 1: 0.2131 / 1 = 0.2131
bin 2: 0.5793 / 1 = 0.5793
```

The width correction (`/ w_k`) matters: a bin twice as wide needs twice the mass to reach the same density. This is why the loss is negative log **density**, not negative log probability.

**Edge bins** — half-normal. The density follows a half-normal anchored at the inner border, decaying toward ±∞:

```
density(y) = p₀ × HN(δ; σ)     where δ = distance from inner border into the tail
```

For the left edge at target y: δ = borders[1] − y. The half-normal peaks at δ = 0 (the inner border) and decays as y → −∞.

**Integral check:** Interior bin integral = p_k/w_k × w_k = p_k. Edge bin integral = p_k × ∫₀^∞ HN(δ) dδ = p_k × 1 = p_k. Total = Σ p_k = 1. ✓

### Step 3a — Interior bin loss (y = 0.7)

Bin assignment by lookup:
```
searchsorted(borders, 0.7) → bin 2 (the interval [0, 1])
```

Loss — negative log density:
```
NLL = −log(p₂ / w₂) = −log(0.5793 / 1) = 0.547
```

Position within the bin doesn't matter. y = 0.01 and y = 0.99 get the same loss — density is constant (piecewise-uniform).

The code (`compute_scaled_log_probs`):
```python
bucket_log_probs = log_softmax(logits, -1)         # log(p_k)
scaled = bucket_log_probs - log(bucket_widths)      # log(p_k / w_k) = log(density)
```

This formulation (`log_softmax − log`) is numerically more stable than computing `softmax / widths` and taking `log` afterwards.

### Step 3b — Edge bin loss (y = −2.5)

Bin assignment:
```
searchsorted(borders, -2.5) → bin 0 (the interval (-∞, -1])
```

Any y ≤ borders[1] lands here. Values far below borders[0] still land in bin 0 — `clamp_(0, num_bars-1)` ensures this.

Delta — distance from inner border into the tail:
```
δ = borders[1] − y = −1 − (−2.5) = 1.5
```

Half-normal density at δ (using σ = 2.965, derived below):
```
HN(1.5; 2.965) = √(2/π) / 2.965 × exp(−1.5² / (2 × 2.965²))
               = 0.2691 × 0.8800
               = 0.2368
```

**The replacement trick.** The code starts with the uniform log-density (computed for all bins), then adds a correction for edge bins:

```python
log_prob  = log(p₀) − log(w₀)                          # uniform (from compute_scaled_log_probs)
log_prob += half_normal.log_prob(δ) + log(w₀)           # correction (in forward())
```

The reference width cancels:
```
log_prob = log(p₀) − log(w₀) + HN.log_prob(δ) + log(w₀)
                      ^^^^^^^^                    ^^^^^^^^
                       cancel

         = log(p₀) + HN.log_prob(δ)
         = log(p₀ × HN_pdf(δ))
```

Final density: `p₀ × HN_pdf(δ) = 0.0784 × 0.2368 = 0.0186`

```
NLL = −log(0.0186) = 3.987
```

Compare: uniform would give −log(0.0784/2) = 3.240. The half-normal penalizes more because at δ = 1.5, HN density (0.237) < uniform density (1/w₀ = 0.5).

## The Half-Normal Scale: Where σ Comes From

### The half-normal distribution

Take N(0, σ²), fold the left half onto the right, double the height:

$$\text{HN}(x;\,\sigma) = \frac{\sqrt{2}}{\sigma\sqrt{\pi}}\,\exp\!\left(-\frac{x^2}{2\sigma^2}\right), \quad x \geq 0$$

CDF: $F(x;\,\sigma) = \text{erf}\!\left(\frac{x}{\sigma\sqrt{2}}\right)$

One parameter: σ (the scale). Larger σ → heavier/wider tail.

### How σ is determined

The code imposes: **the median of HalfNormal(σ) shall equal the reference width w₀.**

The median of HalfNormal(σ=1) is 0.6745. By the scaling property, the median of HalfNormal(σ) is σ × 0.6745. Setting this equal to w₀:

```
σ × 0.6745 = w₀
σ = w₀ / 0.6745
```

Where 0.6745 comes from solving erf(m/√2) = 0.5 → m = √2 × erf⁻¹(0.5) ≈ 0.6745.

The code:
```python
s = range_max / HalfNormal(1.0).icdf(0.5)     # HalfNormal(1.0).icdf(0.5) = 0.6745
```

`HalfNormal(1.0)` is the unit half-normal (σ=1), used purely as a lookup to get 0.6745.

### What this means geometrically

At the reference width w₀, exactly 50% of the half-normal's mass is inside, 50% extends beyond toward ±∞. The 50% split (`p=0.5` in the code) is a design choice — the method accepts any `p` but hardcodes 0.5.

### The causality

```
Grid design:  borders[0] and borders[1] chosen     ← arbitrary configuration
                          ↓
              w₀ = borders[1] − borders[0]          ← reference width (NOT a bin width)
                          ↓
              σ = w₀ / 0.6745                       ← half-normal scale derived
                          ↓
              HN(δ; σ) at any δ ≥ 0                 ← density at any target point
```

σ is **not data-dependent**. It's determined entirely by the border grid geometry, which is fixed before pre-training. The same σ is used for all ~100M synthetic datasets during training and all real datasets during inference.

`borders[0]` is not a boundary, not a data statistic, not a median of anything. It is an arbitrary reference point whose distance from `borders[1]` controls tail heaviness.

## The Density Picture

```
density
  0.58 │                ┌─────┐
       │                │     │
       │         ┌──────┤     │
  0.21 │         │      │     │
       │         │      │     │
       │         │      │     ├──────┐
  0.06 │         │      │     │      │
       │╲        │      │     │      │     ╱
  0.03 │  ╲──────┤      │     │      ├───╱
       │    ╲    │      │     │      │  ╱
       ├─────╲───┼──────┼─────┼──────┼╱────
     -5   -3   -1      0     1      3     5

       ←─ half-normal ─→              ←─ half-normal ─→
          decays to 0                    decays to 0
        (extends to -∞)               (extends to +∞)
                   interior bins
                   (flat/uniform)
```

- Interior bins: flat rectangles, height = p_k / w_k
- Edge bins: half-normal curves, peak at inner border, decaying outward to ±∞
- Density jumps at every border (including edge/interior junctions) — this is inherent to piecewise distributions

## Reading Predictions from the Distribution

`FullSupportBarDistribution` overrides: `forward`, `mean`, `mean_of_square`, `pi`, `ei`.
Everything else — `cdf`, `icdf`, `median`, `mode`, `quantile`, `sample`, `plot` — is inherited from the base `BarDistribution`, which assumes uniform density in all bins.

The override pattern reveals a priority: the developers built HN-aware methods for the **training loss** (`forward`) and **Bayesian optimization acquisition functions** (`pi`, `ei`) — their critical-path use cases. Posterior-inspection methods (`cdf`, `icdf`, `median`, `mode`, `quantile`) were left with uniform assumptions.

| Output | Method | HN-aware? | Notes |
|---|---|:-:|---|
| **Loss** (`forward`) | log(p_k × HN_pdf(δ)) for edge bins | ✅ | Training signal; source of truth for the distribution |
| **pdf** | exp(−forward(logits, y)) | ✅ | Correct everywhere (delegates to `forward`) |
| **Mean** | Σ p_k × center_k; edge centers use HN mean | ✅ | |
| **Variance** | E[x²] − E[x]²; inherits but calls overridden `mean`, `mean_of_square` | ✅ | Correct via dynamic dispatch |
| **PI** | P(Y > best_f); uses HN CDF for edge bins | ✅ | Bayesian optimization |
| **EI** | E[max(Y − best_f, 0)]; uses HN moments for edge bins | ✅ | Bayesian optimization |
| **Median** | Invert CDF at 0.5, linear interpolation within bin | ❌ | See below |
| **Mode** | argmax of p_k / w_k, return bin midpoint | ❌ | See below |
| **Quantiles** | Invert CDF at arbitrary levels | ❌ | |
| **CDF** | Cumulative sum + linear interpolation within bin | ❌ | See below |
| **Sample** | Uniform random → icdf | ❌ | Hard-clipped to `[borders[0], borders[-1]]` |
| **Plot** | p_k / w_k bar chart | ❌ | Shows uniform density for edge bins, not HN shape |

### The CDF/icdf inconsistency (full scope)

The base class `cdf` and `icdf` are wrong for edge bins in **four** regimes:

| Region | Base CDF behavior | Correct behavior |
|---|---|---|
| y < borders[0] | Returns 0.0 | Should return > 0 (HN tail mass) |
| borders[0] ≤ y ≤ borders[1] | Linear: `(y−b₀)/w₀ × p₀` | HN CDF anchored at borders[1] |
| borders[-2] ≤ y ≤ borders[-1] | Linear interpolation | HN CDF anchored at borders[-2] |
| y > borders[-1] | Returns 1.0 | Should return < 1.0 |

**Blast radius:**
- **Median** is biased when it falls in or near an edge bin.
- **Quantiles** (5th, 95th percentile) are systematically wrong when in the tails.
- **Sampling** via `sample()` is hard-clipped: `icdf` returns values in `[borders[idx], borders[idx+1]]` via linear interpolation, so it can **never** return a value outside `[borders[0], borders[-1]]`. The model defines a distribution with support on all of ℝ; `sample()` truncates it to a finite interval.
- **Ensemble rebasing** uses a standalone `_cdf()` with the same flaw (see below).
- **Class-level rebasing** via `get_probs_for_different_borders()` also calls the base `cdf()` (since `FullSupportBarDistribution` does not override it), so it has the same edge-bin flaw.

**The core inconsistency:** The loss (`forward`) trains the model to produce half-normal tails. The CDF, icdf, median, mode, quantile, and sample methods pretend the tails are uniform or don't exist. The model learns one distribution; downstream methods read a different one.

**Practical magnitude:** Under z-normalization (mean=0, std=1), the edge bins are the tails beyond ~±3σ. Over 99.7% of z-normalized targets fall in interior bins where all methods are correct. The error matters for:
- Extreme quantiles (1st, 99th percentile) when they land in edge bins
- Sampling (always clipped regardless of how little tail mass there is)
- Prediction intervals at high coverage levels (e.g., 99%)

For point predictions (mean, median, mode) on typical data, the practical impact is negligible.

### Mode: two specific failures

1. **Wrong density for comparison.** Compares `p_k / w_k` for all bins. For edge bins, the actual peak density is `p_k × √(2/π)/σ`. Since `1/w₀ ≈ 1.86 × √(2/π)/σ` (for the median-matching σ), the mode function overestimates edge-bin peak density by ~1.86×.
2. **Wrong location.** Returns bin midpoint `(borders[0] + borders[1])/2` instead of the inner border `borders[1]` where the HN density actually peaks.

In practice the mode is rarely in edge bins, so this is a correctness issue rather than a practical one.

## Temperature Scaling

All model versions use softmax temperature **0.9**, applied at inference time:

```python
# In regressor.forward(), per estimator, before any averaging:
output = output / self.softmax_temperature   # divide logits by 0.9
```

Temperature < 1 **sharpens** the distribution — concentrating probability mass around the mode. Dividing by 0.9 is equivalent to raising all probabilities to the power 1/0.9 ≈ 1.11, then renormalizing. This is a post-training calibration choice, not part of the pre-training loss.

## Ensemble Averaging

TabPFN's regressor runs multiple estimators (each with different preprocessing), averages their outputs, then extracts predictions. The pipeline has three stages: **temperature → rebasing → averaging**.

### Stage 1 — Temperature

Each estimator's raw logits are divided by 0.9 (see above). This happens inside the per-estimator loop, so each distribution is sharpened individually.

### Stage 2 — Rebasing onto a common border grid

Each estimator may operate on a different border grid. With target transforms (v2/v2.5 `safepower`), the z-space borders are inverse-transformed into a warped space. Different transforms produce different grids.

To average, all outputs must be on the same grid. `translate_probs_across_borders()` in `utils.py` handles this:

```python
# For each estimator:
probs_on_common_grid = translate_probs_across_borders(
    logits,
    frm=estimator_borders,      # possibly warped
    to=znorm_space_borders,     # the fixed z-space grid
)
```

Internally, this evaluates the estimator's CDF at the common-grid border positions via a standalone `_cdf()` function, then takes differences to get per-bin probabilities. The output is a **probability tensor** (despite the misleading variable name `transformed_logits` in the code).

**Important:** This rebasing uses `_cdf()` in `utils.py` — a standalone reimplementation of the base `BarDistribution.cdf`, with the same uniform-interpolation flaw. Edge-bin probability mass is redistributed as if uniform, not half-normal. When estimators have different border grids (v2/v2.5 with safepower), this introduces systematic error in the tails.

A separate code path exists in the `BarDistribution` class itself: `get_probs_for_different_borders()` calls `self.cdf()`. Since `FullSupportBarDistribution` does not override `cdf`, this has the same edge-bin flaw. The regressor uses the `utils.py` path, not the class method.

### Stage 3 — Averaging and output

```python
# Default: average_before_softmax = False
stacked = torch.stack(rebased_probs, dim=0)    # [N_est, N_samples, N_bins]
avg_probs = stacked.mean(dim=0)                # probability-space averaging
logits = avg_probs.log()                       # convert to log-probs for downstream
```

**Probability-space averaging** (default) preserves multimodality: if one estimator predicts mode at 2 and another at 8, the average is bimodal.

The alternative (`average_before_softmax=True`) averages log-probabilities then renormalizes: `probs.log().mean(dim=0).softmax(dim=-1)`. This is a renormalized geometric mean of probabilities — it tends to produce sharper, unimodal distributions because the geometric mean penalizes near-zero bins.

### Border warping (v2/v2.5 only)

When `target_transform` (e.g. `safepower`) is active:

```
z-space borders ──→ inverse_transform() ──→ warped borders (possibly with NaN/∞)
                                                    ↓
                                            NaN repair: detect broken borders,
                                            mask corresponding logit positions to −∞,
                                            interpolate replacements
```

v2.6 dropped `safepower` (`REGRESSION_Y_PREPROCESS_TRANSFORMS = ("none",)`). The string `"none"` maps to `FunctionTransformer()` (identity), so `inverse_transform` is a no-op and all estimators produce identical borders. The rebasing code still runs (`translate_probs_across_borders` with `frm ≈ to`), but the result is a near-identity transform. This eliminates both the NaN repair complexity and the CDF-flaw-in-rebasing issue.

Note: `"none"` (the string, producing an identity `FunctionTransformer`) differs from `None` (the Python object, used in v2/v2.5's `(None, "safepower")` to skip the transform entirely). Both produce the same borders, but they follow different code paths: `None` short-circuits to `borders_t = std_borders.copy()`; `"none"` goes through `transform_borders_one()` with identity inverse_transform.

## The Loss as a Scoring Rule

The training loss is negative log density of the bar distribution evaluated at the true y. In scoring rule theory, this is the **log scoring rule** — a *proper* scoring rule (the unique optimum is the true conditional distribution).

The log scoring rule is **local**: the gradient depends only on the probability/density assigned to the bin containing y, not on how mass is distributed elsewhere. If the true y is in bin 5, putting all remaining mass in bin 6 or bin 500 yields identical loss. There is no "geometric awareness" — no penalty for distance between prediction and truth.

**Consequences:**

- **Strength:** The model is incentivized to learn the full shape of the predictive distribution, including multimodality. This is why TabPFN can output bimodal predictions and provide calibrated uncertainty.
- **Limitation:** For derived point predictions (mean, median), the model wasn't directly optimizing MSE or MAE — it was optimizing log-likelihood. These are different objectives.

### The CRPS alternative

CRPS (Continuous Ranked Probability Score) injects distance awareness — it penalizes not just whether the prediction assigns mass to the right bin, but how far the predicted CDF is from the truth.

**In the TabPFN codebase:** CRPS is available as a fine-tuning loss since PR #711 (Jaeger, Landsgesell, Knoll; merged Jan 2026). The implementation in `finetuned_regressor.py` computes a discrete CRPS: `Σ_k w_k (CDF(k) − y_k)²`, where `CDF(k)` is `cumsum(softmax(logits))` and `y_k` is a step-function target at the target's bin. This uses the same piecewise-uniform CDF (cumsum of softmax bins), **not** the HN-corrected continuous CDF. The CRPS fine-tuning loss therefore has the same tail inconsistency as the base `cdf` method: it treats edge bins as uniform, while the pre-training NLL loss treats them as half-normal.

**In the literature:** Landsgesell & Knoll (arXiv 2603.08206, Mar 2026) benchmark TabPFN v2.5 and TabICLv2 on proper scoring rules (CRPS, CRLS, interval score) across 20 regression datasets. They show that fine-tuning with a scoring rule different from the pre-training objective (e.g., β=1.8 energy score instead of log-loss) yields consistent improvements on the corresponding metric — confirming that the training loss shapes the model beyond what propriety alone guarantees. They argue for (i) reporting distributional metrics in tabular regression benchmarks and (ii) making the training objective adaptable to the downstream scoring rule.

**TabICLv2 takes a different approach entirely.** Qu et al. (2026) sidestep the bar distribution by outputting **999 quantile predictions** directly (a quantile-function architecture), trained with CRPS (which decomposes into pinball losses over quantiles). This avoids the discretization issues cataloged here — no bins, no edge-bin CDF inconsistency, no piecewise-uniform assumption. The shift from bin distributions to quantile-native architectures is a parallel trend.

## Version Differences

| | v2 / v2.5 | v2.6 |
|---|---|---|
| Target transforms | `(None, "safepower")` — half the estimators use SafePowerTransformer (numerically-guarded Yeo-Johnson) | `("none",)` — identity only |
| Border warping | Active: inverse-transform creates warped borders, needs NaN repair; CDF-based rebasing introduces tail error | Effectively inactive: all estimators share z-space grid; rebasing code runs but is a near-identity |
| Polynomial features | None | Up to 10 pairwise interactions (regression and binary classification; disabled for multiclass) |
| Softmax temperature | 0.9 | 0.9 |
| Ensemble averaging | Probability-space by default | Same |
