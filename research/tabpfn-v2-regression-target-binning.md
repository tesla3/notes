# TabPFN v2: Regression Target Generation and Bar Distribution Binning

Source: Hollmann et al., "Accurate predictions on small data with a tabular foundation model", Nature 2024 (s41586-024-08328-6)
Code: PriorLabs/TabPFN (GitHub), PFNs4BO training framework
Date: 2026-04-01
Reviewed: 2026-04-01 — cross-referenced against PriorLabs/TabPFN codebase (all versions through v2.6), Nature paper, Distribution Transformer paper (arXiv:2502.02463), and "A Closer Look at TabPFN v2" (arXiv:2502.17361)

**Provenance convention**: claims marked [code] are verified against the inference codebase; [paper] are from the Nature paper or supplements only (training code is not public); [inferred] are the author's analysis.

## 1. Regression Target Generation (SCM Prior) [paper]

TabPFN is pre-trained on ~100M synthetically generated datasets, each produced by a random Structural Causal Model (SCM). The training code is not part of the public TabPFN inference repo — all details below are from the Nature paper and supplementary materials.

**Pipeline per dataset:**
1. Sample hyperparameters — dataset size, number of features, difficulty level
2. Sample a DAG — growing network with redirection method (preferential attachment → scale-free graphs)
3. Generate initialization noise — random vectors ε ∈ ℝ^d at root nodes (Normal, Uniform, or Mixed)
4. Propagate through the computational graph — at each edge, apply one of:
   - Small random neural networks (Xavier-initialized weights, random activations: sine, sigmoid, ReLU, step, modulo, abs, tanh, log, rank, square, power, smooth ReLU)
   - Categorical discretization (nearest-neighbor to random prototype vectors)
   - Decision trees (random splits/thresholds)
   - Gaussian noise injection N(0, σ²I)
5. Extract features and target — random nodes designated as feature (F) and target (T) nodes; extract intermediate vector representations
6. Post-process — Kumaraswamy warping, quantization, missing value injection

The regression target is the continuous scalar extracted from the target node. No discretization at data generation time.

## 2. The Bar Distribution — Converting Regression to Classification

Instead of predicting a scalar ŷ, TabPFN predicts a **piecewise-constant probability distribution** over the target space. The paper calls it a "piece-wise constant output distribution"; the code calls it `BarDistribution` / `FullSupportBarDistribution`.

### 2.1 Borders Are Static, Set Once Before Pre-training [code]

**Key finding: borders are NOT computed per-dataset. They are fixed once, offline, and stored in the checkpoint.**

Evidence:
- In PFNs training code (`PFNs4BO/train.py`), `criterion` (containing the BarDistribution with its borders) is passed as a single argument to `train()` and reused for every batch across all ~100M synthetic datasets
- The checkpoint stores one fixed set of borders in `criterion.borders` state_dict
- At inference, `fit()` never recomputes borders — only does an affine rescale
- `get_bucket_limits()` has zero call sites in the inference codebase (confirmed by rg search — only the definition exists)

**How borders are loaded** [code]: `model_loading.py` creates dummy borders (`arange(num_buckets+1) * 30000`) via `get_loss_criterion`, then immediately overwrites them with the checkpoint's state_dict:
```python
criterion_state = {k.replace("criterion.", ""): full_state[k] for k in criterion_state_keys}
loss_criterion.load_state_dict(criterion_state)
```
The actual border values and count (`num_buckets`) are entirely determined by the checkpoint. They cannot be verified without loading the checkpoint file.

**What `get_bucket_limits` supports** [code]: The function has two modes:
1. **Equal-width** (when `full_range` is given): `class_width = (full_range[1] - full_range[0]) / num_outputs`
2. **Quantile-based adaptive** (when `ys` is given): sorts ys, places borders at midpoints between quantile boundaries

The v1 training script used `--num_buckets` (default 100), `--min_y`, `--max_y` as CLI args, suggesting equal-width bins for v1. Whether v2 pre-training used equal-width or quantile-based borders is unknown [inferred] — the quantile-based infrastructure exists but the training code is not public. The note's Section 6 limitation about "equal-width bins wasting resolution" should be read with the caveat that the codebase already supports quantile-based bins; the constraint (if it applies) is a pre-training choice, not an architectural one.

### 2.2 Z-normalization Is the Bridge [code]

The mechanism that makes fixed borders work across all datasets:

- **During pre-training**: synthetic dataset targets are z-normalized (mean=0, std=1) before being fed to the model [inferred from inference-time symmetry — training code is not public]
- **During inference**: user's targets are z-normalized the same way
- A single fixed grid in z-space handles all datasets

**Target z-normalization** is code-verified in `regressor.py` `fit()`:
```python
self.y_train_std_ = std.item() + 1e-20
self.y_train_mean_ = mean.item()
y = (y - self.y_train_mean_) / self.y_train_std_
self.raw_space_bardist_ = FullSupportBarDistribution(
    self.znorm_space_bardist_.borders * self.y_train_std_ + self.y_train_mean_,
)
```

Note: the paper's statement "These values are subjected to z-normalization using the mean and standard deviation for each feature separately across the whole training set" refers to **feature** normalization, not target normalization. Target z-normalization is solely code-verified.

### 2.3 Why Every Target Maps to a Bin [code]

Guaranteed by construction:
1. `searchsorted` on sorted borders deterministically assigns every value to a bin
2. `FullSupportBarDistribution` **clamps** out-of-range targets: `target_sample.clamp_(0, self.num_bars - 1)`
3. Edge bins have half-normal tails giving nonzero density beyond the border range

This is deterministic lookup, not prediction. The edge bins are catch-all buckets.

## 3. Loss Function [code]

### Interior bins (the base case)

```
L = -log(softmax(logit_k)) + log(w_k)
```

Equivalently: `L = -log(p_k / w_k)` — negative log **density** (not probability). The `/ w_k` converts probability mass to density so narrow bins need less mass than wide bins.

Code (`compute_scaled_log_probs`):
```python
bucket_log_probs = torch.log_softmax(logits, -1)
return bucket_log_probs - torch.log(self.bucket_widths)
```

### Edge bins (FullSupportBarDistribution override)

The two outermost bins are special — their uniform-within-bin density is **replaced** by a half-normal density:

```python
log_probs[target_sample == 0] += side_normals[0].log_prob(
    (self.borders[1] - y[target_sample == 0]).clamp(min=1e-8),
) + torch.log(self.bucket_widths[0])
```

The `+ log(w_k)` undoes the `/ w_k` from `compute_scaled_log_probs`, so the half-normal replaces (not compounds with) the uniform assumption. Algebraically: final density for edge bin = `p_k * half_normal_pdf(delta)`, where `p_k` is the softmax probability mass in the bin and `delta` is the distance into the tail. The half-normal scale is set so 50% of its mass falls within the edge bin width:
```python
s = range_max / HalfNormal(1.0).icdf(0.5)
```

This gives smooth tail decay rather than a hard cutoff at the borders.

### ⚠️ Half-normal is NOT used consistently across all methods [code]

`FullSupportBarDistribution` overrides these methods to use half-normal edge bins:
- `forward` (loss computation) ✓
- `mean` (edge bin centers replaced with half-normal means) ✓
- `mean_of_square` / `variance` ✓
- `pi`, `ei` (acquisition functions for Bayesian optimization) ✓

But it does **NOT** override these — they inherit `BarDistribution`'s uniform-within-bin assumption:
- **`cdf`** — treats edge bins as uniform rectangles
- **`icdf`** — same (used by `median` and `quantile`)
- **`median`** — calls `icdf(logits, 0.5)`, so edge bins are uniform
- **`mode`** — uses `density = softmax / bucket_widths`, no half-normal
- **`quantile`** — calls `icdf`, so edge bins are uniform

**Consequence**: the `mean` prediction accounts for half-normal tails but `median` and `quantile` predictions do not. These are mathematically inconsistent views of the same distribution. The `translate_probs_across_borders` function (used for ensemble coordination, Section 4.2) also calls a `_cdf` that assumes uniform within-bin, so cross-border probability redistribution ignores tail shape.

In practice the impact is likely small — few predictions land in edge bins of z-normalized data — but it's a real design inconsistency between training signal and inference output.

## 4. Inference Pipeline (Three Coordinate Systems)

**Scope note**: This section fully applies to **v2 and v2.5**. In **v2.6**, `REGRESSION_Y_PREPROCESS_TRANSFORMS=("none",)` by default, meaning the target transform is an identity function. The entire three-coordinate-system machinery collapses to the trivial case — borders pass through unchanged, no NaN repair needed, no descending border handling. See Section 4.4.

### 4.1 Per-estimator transformed space (v2/v2.5)

Each ensemble member can have a different `target_transform` (power transform, quantile transform, etc.). Default for v2/v2.5: `REGRESSION_Y_PREPROCESS_TRANSFORMS=(None, "safepower")` — half the estimators use no transform, half use a safe power transform.

The z-normalized borders are inverse-transformed through that estimator's transform:

```python
logit_cancel_mask, descending_borders, borders_t = transform_borders_one(
    std_borders, target_transform=config.target_transform, ...
)
```

Borders can become NaN, reversed, or extreme — hence repair logic (`_repair_borders`, `_cancel_nan_borders`).

### 4.2 Translation to common z-normalized space

Each estimator's logits (probabilities over its own warped borders) are translated to the common `znorm_space_bardist_` borders via CDF-based probability mass redistribution:

```python
translate_probs_across_borders(
    logits, frm=torch.as_tensor(borders_t), to=self.znorm_space_bardist_.borders,
)
```

This evaluates the CDF at the target borders and differentiates to get probability mass per new bin. Note: this CDF uses uniform-within-bin assumption (see Section 3 caveat).

### 4.3 Averaging and output

**Softmax temperature** (default 0.9) is applied to raw model logits before any bar distribution processing:
```python
if self.softmax_temperature != 1:
    output = output / self.softmax_temperature
```
Temperature < 1 sharpens the predicted distribution (more peaked). This affects all output types.

Translated probabilities are then averaged across estimators. The averaging mode matters:
- **`average_before_softmax=False`** (default): average probabilities directly. Preserves multimodality — if estimator A predicts peak at x=2 and estimator B predicts peak at x=5, the average shows both peaks.
- **`average_before_softmax=True`**: average in log-probability space (geometric mean of probabilities, re-normalized). Tends toward consensus — a single compromised peak. Better calibration when estimators agree; loses multimodal signal when they disagree.

Final predictions use `raw_space_bardist_` (affine-rescaled borders):

```python
logit_to_output = partial(_logits_to_output, logits=logits, criterion=self.raw_space_bardist_, ...)
```

Output options:
- **Mean**: ŷ = Σ_k p_k · c_k (weighted sum of bin centers; edge bins use half-normal means)
- **Median**: inverse CDF at 0.5 (⚠️ uses uniform-within-bin, not half-normal — see Section 3)
- **Mode**: bin with highest density p_k / w_k (⚠️ same caveat)
- **Quantiles**: inverse CDF at arbitrary quantile levels (⚠️ same caveat)
- **Full distribution**: the entire piecewise-constant density (can represent multimodal distributions)

### 4.4 v2.6 Changes [code]

v2.6 makes several default changes that simplify the regression pipeline:
- **`REGRESSION_Y_PREPROCESS_TRANSFORMS=("none",)`** — no per-estimator target transforms. Sections 4.1's border warping/repair machinery becomes inactive.
- **`POLYNOMIAL_FEATURES=10`** — adds up to 10 pairwise polynomial feature interactions by default (v2/v2.5 had `"no"`). This enriches the feature space the model sees, potentially allowing simpler bar distributions to capture more complex target patterns.
- **`OUTLIER_REMOVAL_STD=None`** explicitly (v2/v2.5 used `"auto"` which resolved to `None` for regression anyway — no behavioral change, just explicit).

## 5. Key Design Insights

| Aspect | Detail |
|---|---|
| Border lifetime | Set once before pre-training, stored in checkpoint, never recomputed |
| Border structure | Checkpoint-determined; likely equal-width in z-space based on v1 defaults, but unverified for v2 |
| Dataset adaptation | z-normalization maps every dataset to the same scale; affine rescale maps borders back to original space |
| Out-of-range handling | Clamping + half-normal tails on edge bins (loss and mean only; CDF/iCDF use uniform) |
| Loss function | NLL of piecewise-constant density (interior) + half-normal density (edges) |
| Softmax temperature | Default 0.9 sharpens predicted distributions; applied before bar distribution processing |
| Output | Full probability distribution, not just a point estimate |
| Multimodal support | Yes — bar distribution naturally represents arbitrary shapes; probability averaging (default) preserves multimodality across ensemble members |
| Ensemble coordination | v2/v2.5: per-estimator target transforms → CDF-based probability redistribution → averaging. v2.6: no target transforms, direct averaging |

## 6. Strengths and Limitations of the Approach

**Strengths:**
- Converts regression to classification cleanly — reuses softmax/cross-entropy machinery
- Full uncertainty quantification for free (no separate quantile models needed)
- Can represent arbitrary distributions including multimodal
- Simple, differentiable, no special loss engineering

**Limitations:**

*Internal design inconsistency* [code, original analysis]:
- Half-normal tail treatment is inconsistent: used in loss and mean but not in CDF/iCDF/median/quantile/mode. Median and quantile predictions assume uniform edge bins while the training loss shapes half-normal tails. Practical impact is small (few z-normalized values land in edge bins) but theoretically unsatisfying.

*Fixed-resolution discretization* [original analysis, contextualized by Distribution Transformer paper (arXiv:2502.02463)]:
- Fixed borders in z-space = fixed resolution. Very heavy-tailed or wide-range posteriors may lose resolution. The Distribution Transformer paper (Whittle et al., 2025) demonstrates that GMM-based output representations outperform PFN-style "Riemannian histograms" for posterior approximation, finding that "all methods utilising GMMs surpass those based on Riemannian histogram." TabPFN v2's bar distribution is this histogram.
- Half-normal tail scale is derived from the edge bin width, not per-observation — a single tail shape for all predictions. Can fail for posteriors with unusual tail behavior.
- Equal-width bins in z-space (if that's what v2 uses) waste resolution in low-density regions. The codebase already supports quantile-based adaptive binning (`get_bucket_limits` with `ys` argument), so this is a pre-training choice, not an architectural limitation.
