# Regression Losses Deep Dive: From Huber to Discretized Cross-Entropy (v2)

Source: Research discussion, 2026-04-10. Revised 2026-04-11.
Context: Critical review of FEAT (arXiv:2603.16513v2) led to deep dive on loss functions for continuous prediction in tabular foundation models. v2 consolidates original analysis with two rounds of critical review: corrections to overstatements, ten additional gaps identified, and a decision flowchart.

---

## The Loss Function Hierarchy

From least to most expressive, for predicting continuous values:

| Loss | Model outputs | Assumes | Gradient behavior |
|---|---|---|---|
| MSE (L2) | μ | Gaussian, fixed σ | Unbounded, proportional to error |
| Huber / Smooth L1 | μ | Nothing explicit (heuristic) | Capped at ±δ for large errors |
| Gaussian NLL | μ, σ | Gaussian, variable σ | Weighted by predicted variance |
| Student-t NLL | μ, σ, ν | Heavy tails, variable σ | Logarithmic for large errors |
| Tweedie NLL | μ, φ, p | Semicontinuous (zero-inflated) | Weighted by power variance function |
| Evidential (NIG) | μ, ν, α, β | Normal-Inverse-Gamma prior | Bounded; separates aleatoric/epistemic |
| Quantile / Pinball | Quantile values q_τ | Nothing (non-parametric) | Bounded in {-(1-τ), τ}, proper scoring |
| **IQN / NQ-Network** | Continuous quantile function Q(τ) | Nothing (non-parametric) | Bounded, quantile Huber; monotonic by construction |
| Mixture Density NLL | {μ_k, σ_k, π_k} | Mixture of Gaussians | Per-component; mode collapse risk |
| Normalizing Flow | Full invertible transform | Almost nothing | Via Jacobian determinant |
| **Diffusion (CARD)** | Iterative denoising | Almost nothing | Score-based; multi-step inference |
| **Discretized CE (HL-Gauss)** | Softmax over m bins | Nothing (but bounded range) | **Bounded in [-1, 1] by construction** |
| **CRPS-on-bins** | Softmax over m bins | Nothing (but bounded range) | **Bounded, ordinal-aware via CDF** |
| **Monotonic CDF + CRPS** | Cumulative sigmoid over m bins | Nothing (but bounded range) | **Bounded, ordinal-aware, unimodal by construction** |

The key insight: discretized CE and CRPS-on-bins achieve normalizing-flow-level expressiveness (arbitrary output shapes) with classification-level simplicity and superior optimization properties — including implicit second-order curvature information and synergistic interaction with Adam-family optimizers. CRPS-on-bins adds theoretical properness and ordinal awareness to the same softmax-over-bins architecture, but lacks local scale invariance (see [CRPS limitations](#limitation-crps-is-not-locally-scale-invariant)). The newer monotonic CDF + CRPS formulation adds unimodality guarantees. All discretized approaches come with tradeoffs the hierarchy table doesn't show — see [Limitations of Discretized CE](#limitations-of-discretized-ce), [CRPS-on-Bins](#crps-on-bins--the-theoretically-principled-alternative), and [Direct CDF Regression](#direct-cdf-regression--monotonic-crps-the-missing-formulation) below.

Implicit Quantile Networks (IQN) and non-crossing quantile networks deserve special attention: they achieve continuous, unbounded, non-parametric distributional output without bins, avoiding the bounded-range and resolution-range tradeoffs of discretized methods entirely. See [Implicit Quantile Networks](#implicit-quantile-networks-iqn--nq-networks) below.

Critically, loss function choice does not exist in isolation — it interacts with target preprocessing, optimizer choice, input tokenization, loss aggregation strategy, label noise levels, and downstream decision costs. See the cross-cutting sections on [Target Preprocessing](#target-preprocessing-the-elephant-in-the-room), [Asymmetric Losses](#asymmetric-losses-and-decision-theoretic-framing), and [Input Tokenization](#input-tokenization-×-output-loss-interaction) below.

---

## Huber Loss

### What it is
Piecewise hybrid: L2 for small errors (|e| ≤ δ), L1 for large errors (|e| > δ).

```
L_δ(e) = 1⁄2e²              if |e| ≤ δ
          δ|e| - 1⁄2δ²       if |e| > δ
```

### Why it exists
- MSE: gradient proportional to error magnitude → one outlier dominates batch
- MAE: gradient always ±1 → doesn't accelerate near optimum, non-differentiable at 0
- Huber: quadratic near zero (efficient convergence), linear far away (capped gradient at ±δ)

### Historical context
Peter Huber, 1964, "Robust Estimation of a Location Parameter" (Annals of Mathematical Statistics). The **minimax optimal** estimator — minimizes maximum possible asymptotic variance over distributions ε-close to Gaussian. Not a hack; provably best without knowing exact noise model.

### Limitations
- Same δ for all samples — can't express per-sample uncertainty
- Fixed threshold — doesn't adapt to per-feature scale
- Point estimate only — no uncertainty signal for downstream use
- δ is a hyperparameter with no principled auto-selection

---

## Probabilistic Losses

### Core shift
Instead of predicting a point estimate and penalizing distance, predict **distribution parameters** and penalize how unlikely truth is under predicted distribution.

```
L = -log p(y | θ̂)    (negative log-likelihood)
```

### Gaussian NLL (heteroscedastic)
```
L = 1⁄2 log(σ̂²) + (y - μ̂)² / (2σ̂²)
```
Two competing terms: reconstruction error inversely weighted by predicted variance + regularizer penalizing infinite uncertainty. When σ̂ is fixed → reduces to MSE. So MSE = special case assuming constant variance.

### Student-t NLL
For heavy-tailed data. The tail parameter ν controls heaviness:
- ν → ∞: Gaussian
- ν = 1: Cauchy (extremely heavy)
- ν ≈ 3-5: commonly cited heuristic for tabular data, though heavy-tailedness varies widely across domains (no single reference — treat as empirical folklore, not established fact)

Key behavior: for large errors, loss is **logarithmic** (log|e|) rather than quadratic. Huber-like robustness emerges naturally from a distributional assumption, not ad-hoc piecewise construction. Bonus: ν can be learned from data.

### Evidential Deep Learning (NIG Regression)
A parametric approach that estimates **both** aleatoric and epistemic uncertainty in a single forward pass by placing a Normal-Inverse-Gamma (NIG) prior over the Gaussian likelihood parameters.

The model outputs four parameters (μ, ν, α, β) representing a NIG distribution:
- Predictive mean: μ
- Aleatoric uncertainty: β / (α - 1)
- Epistemic uncertainty: β / (ν(α - 1))

> "Evidential Deep Learning is a paradigm that parameterizes distributions over outcomes, quantifying both data (aleatoric) and model (epistemic) uncertainty in one forward pass. It leverages subjective logic and belief theory by using Dirichlet distributions for classification and Normal-Inverse-Gamma for regression to represent evidence." — [EmergentMind EDL topic](https://www.emergentmind.com/topics/evidential-deep-learning)

Key properties:
- **Epistemic uncertainty without ensembles.** Standard heteroscedastic NLL gives aleatoric uncertainty only. EDL separates aleatoric from epistemic via the NIG posterior — distinguishing "the data is noisy" from "I haven't seen data like this." No ensembles, no MC dropout, no multiple forward passes.
- **Evidence-based reasoning.** The parameter ν encodes the amount of "evidence" supporting the prediction — low ν means the model has little basis for its estimate, regardless of aleatoric noise.
- **Same output complexity as Student-t NLL.** Four parameters vs. three — minimal overhead.

Limitations:
- **Calibration pathologies.** Documented across multiple studies. Bengs et al. ("Pitfalls of Epistemic Uncertainty Quantification through Loss Minimisation," AISTATS 2023) show fundamental issues with the NIG parameterization for regression specifically. Deng et al. (arXiv:2602.01477, 2025) further confirm: "Evidential Deep Learning (EDL) is a popular framework for uncertainty-aware classification that models predictive uncertainty via Dirichlet distributions parameterized by neural networks. Despite its popularity, its theoretical foundations and behavior under distributional shift remain poorly understood." The NIG regression variant shares these concerns.
- **Not non-parametric.** Still assumes a specific distributional family (Normal-Inverse-Gamma). Cannot represent multimodal or arbitrary shapes.
- **Untested for tabular FMs.** No tabular foundation model has used EDL as a pre-training loss.

EDL sits between Gaussian NLL and Quantile Regression in the hierarchy: it extends parametric NLL with epistemic uncertainty separation but doesn't achieve the non-parametric expressiveness of quantile or discretized approaches.

### Quantile Regression / Pinball Loss
A non-parametric distributional approach that predicts specific quantiles of the conditional distribution rather than moments.

```
L_τ(e) = τ · max(e, 0) + (1 - τ) · max(-e, 0)    (pinball loss for quantile τ)
```

Key properties:
- **Non-parametric**: no distributional assumption at all. Each quantile is a separate optimization target.
- **Bounded gradients**: gradient is always in {-(1-τ), τ} — bounded like Huber, but without a δ to tune.
- **Proper scoring rule**: the pinball loss is strictly proper — uniquely minimized when the predicted value equals the true τ-quantile. This is a theoretical guarantee that HL-Gauss (as a categorical CE over bins of a continuous target) does not have in the strict sense.
- **Standard in forecasting**: the dominant method in probabilistic forecasting, financial risk (VaR/CVaR), and weather prediction since Koenker & Bassett (1978).
- **CRPS connection**: the Continuous Ranked Probability Score (CRPS), the standard proper scoring rule for full distributional regression, equals the integral of pinball losses over all quantiles τ ∈ [0, 1]. Landsgesell & Knoll (arXiv:2603.08206, Feb 2026) show that "different proper scoring rules induce different model rankings and different inductive biases during training" — CRPS is the theoretically principled choice for evaluating (and training) distributional regressors, including tabular foundation models.

Limitations:
- Predicting K quantiles requires K forward passes or K output heads. **Implicit Quantile Networks (IQN)** solve this by taking τ as a continuous input — see [IQN section](#implicit-quantile-networks-iqn--nq-networks) below.
- Quantile crossing (q_0.9 < q_0.5) possible without monotonicity constraints. **Non-crossing quantile networks** enforce monotonicity architecturally via non-negative activation functions (arXiv:2504.08215, Apr 2025): "By leveraging non-negative activation functions, the NQ network ensures that the learned distributions remain monotonic, effectively addressing the issue of quantile crossing." A production PyTorch framework exists (arXiv:2510.22419).
- No closed-form density (only CDF samples)
- Less natural for multi-modal distributions than discretized approaches

### Why probabilistic > Huber
1. Per-sample uncertainty — model expresses "I'm uncertain here"
2. Learned tail behavior — discovers how heavy tails are from data
3. Calibrated uncertainty — enables downstream decision-making
4. Heteroscedastic handling — adapts per-feature noise profile

### Where probabilistic losses fall short
- More output parameters (roughly doubling head size)
- Harder optimization — specifically, **loss attenuation**: the model can inflate σ̂ to reduce loss without improving the mean estimate. Seitzer et al. (ICLR 2022, arXiv:2203.09168) showed this is a fundamental pathology of NLL training: "we present a synthetic example illustrating how this approach can lead to very poor but stable parameter estimates. We identify the culprit to be the log-likelihood loss." Their fix, **β-NLL**, weights each sample's contribution by σ̂^(2β), with β ∈ [0.5, 1] mitigating attenuation while preserving heteroscedastic modeling. Stirn et al. (arXiv:2306.16717, 2023) show the problem is a **fundamental bifurcation** even deeper than loss attenuation: "At one extreme, these models fit all training data perfectly, eliminating residual noise entirely; at the other, they overfit the residual noise while predicting a constant, uninformative mean." This bifurcation strengthens the case for discretized approaches, which avoid predicting variance entirely.
- Calibration not guaranteed without post-hoc correction
- Computational cost for mixtures/flows

---

## Normalizing Flows

### Core idea
Start with simple known distribution (standard Gaussian). Apply learned invertible, differentiable transforms to warp into arbitrarily complex shape.

```
z ~ N(0, I) → x = f(z)
```

### The math
Change of variables formula:
```
log p_x(x) = log p_z(f⁻¹(x)) + log |det J_{f⁻¹}(x)|
```
Jacobian determinant measures how much f stretches/compresses local volume.

### Why invertibility is non-negotiable
Need to: (1) sample via forward pass, (2) evaluate density via inverse, (3) compute Jacobian for volume correction.

### Key architectures
- **Coupling layers (RealNVP, Glow)**: split input, transform one half conditioned on other. Triangular Jacobian → O(d) determinant. Both directions parallel.
- **Autoregressive (MAF/IAF)**: each output depends on previous inputs. Triangular Jacobian. Fast density eval OR fast sampling, not both.
- **Neural Spline Flows**: monotonic rational-quadratic splines per dimension. Much more expressive per layer than affine coupling.
- **Continuous (FFJORD)**: ODE-based. Trace instead of determinant. Flexible but slow (needs ODE solver).

### Limitations
- Invertibility constrains architecture
- Topological constraints (can't disconnect connected regions)
- Training instability from Jacobian computation
- Displaced by diffusion models for *sample quality in image generation* specifically, but remain strong for likelihood-based density estimation and probabilistic inference where exact log-likelihoods are needed
- Historically SOTA for conditional density estimation on tabular data (Neural Spline Flows, ~2020-2021); the landscape has since shifted with diffusion-based tabular models (TabDiff, CDTD) and the claim needs re-benchmarking
- **Comeback in distributional RL**: "Flow Models for Unbounded and Geometry-Aware Distributional Reinforcement Learning" (arXiv:2505.04310, May 2025) positions flow-based distributional RL as solving categorical RL's fundamental weakness: "enables flexible, unbounded support for return distributions, in contrast to categorical approaches like C51 that rely on fixed or bounded representations." The follow-up (OpenReview, Mar 2026) adds: "Categorical methods (e.g., C51) rely on fixed supports where parameter counts scale linearly with resolution, while quantile methods approximate distributions as discrete mixtures whose piecewise-constant densities can be wasteful when modeling complex multi-modal or heavy-tailed returns." This directly addresses the bounded-range limitation of HL-Gauss/C51-style discretization and shows the tradeoff is active, not settled.

---

## Mixture Density Networks (MDNs)

Source: Bishop, "Mixture Density Networks" (1994). The original neural approach to multimodal conditional density estimation.

### Core idea
Output parameters of a Gaussian mixture model: K components, each with mean μ_k, variance σ²_k, and mixture weight π_k. Total outputs: 3K per target.

```
p(y|x) = Σ_k π_k(x) · N(y; μ_k(x), σ²_k(x))
L = -log p(y|x)
```

### Why MDNs matter

> "Mixture-Density Networks are neural architectures that output parameters for Gaussian mixtures to model complex, multimodal conditional densities. They use specialized output heads to predict mixture weights, means, and covariances with constraints ensuring valid and interpretable probabilistic estimates." — [EmergentMind MDN topic](https://www.emergentmind.com/topics/mixture-density-networks-mdns-b0b77a5b-4021-4894-aaff-c87e92e58c60)

1. **Intentional multimodality.** HL-Gauss's unconstrained softmax can *accidentally* produce bimodal predictions (see [unimodality caveat](#discretized-cross-entropy-hl-gauss--the-dark-horse)). MDNs produce them *intentionally and interpretably* — each component has explicit parameters, and multimodality is a feature, not a bug.

2. **Interpretable uncertainty decomposition.** Wide mixture = high aleatoric uncertainty. Spread-out component means = multimodal conditional. The parametric structure is directly readable, unlike a 101-bin histogram.

3. **Compact representation.** With K=5 components: 15 outputs per feature (5μ + 5σ + 5π). Comparable to 101-bin HL-Gauss in complexity but providing an explicit parametric mixture instead of a non-parametric histogram.

4. **Single-pass inference.** Unlike diffusion (multi-step) or IQN (multiple τ queries for full distribution), MDNs produce the complete distributional parameterization in one forward pass. Recent work validates MDN heads on transformer architectures: "Liquid Networks with Mixture Density Heads" (arXiv:2603.27058, Mar 2026) demonstrates MDN policy heads competitive with diffusion policies on robotics benchmarks.

5. **Mode-specific point predictions.** For multimodal conditionals, MDNs provide interpretable per-mode point predictions (each μ_k). This avoids the mean-of-multimodal pathology that affects all bin-based and quantile methods — see [Mean-of-Multimodal Pathology](#mean-of-multimodal-pathology-at-inference-time) below.

### The classic failure: mode collapse

The historical barrier to MDN adoption is mode collapse during NLL training:

> "Standard training procedures involve maximum likelihood estimation using the negative log-likelihood (nll) objective, which suffers from slow convergence and mode collapse." — [arXiv:2602.10602](https://arxiv.org/html/2602.10602v1) (Feb 2026)

Mode collapse occurs when one component captures most of the data while others converge to zero mixture weight or degenerate variance. The NLL loss landscape has saddle points and flat regions that standard optimizers (Adam, SGD) struggle with.

**Recent fix: natural gradient EM.** "Learning Mixture Density via Natural Gradient Expectation Maximization" (arXiv:2602.10602, Feb 2026) addresses this: "we interpret mixture density networks as deep latent-variable models and analyze them through an expectation maximization framework, which reveals surprising theoretical connections to natural gradient descent. We exploit such connections to derive the natural gradient expectation maximization (nGEM) objective." This decouples mixture weight updates from component parameter updates using the Fisher information geometry, eliminating the mode collapse failure mode that made MDNs unreliable in earlier practice.

### Limitations
- **Parametric assumption.** Still assumes Gaussian components. Cannot represent arbitrary shapes without many components (K ≥ 10-20), at which point the 101-bin histogram is simpler and more expressive.
- **Component count K is a hyperparameter.** Too few = underfitting; too many = mode collapse risk and overfitting. No principled auto-selection (unlike bins where 101 is a robust default).
- **Not a proper scoring rule.** NLL training is proper for the assumed parametric family, but if the true conditional is not a Gaussian mixture, NLL does not guarantee calibration.
- **Gradient pathology near degenerate components.** When σ_k → 0, the NLL gradient explodes (singularity at a point mass). Requires variance clamping or regularization.
- **Untested for tabular FM pre-training.** No tabular FM uses MDN reconstruction heads. The per-feature multimodality question is empirical: most tabular features, after normalization, have unimodal conditionals where MDN's complexity is wasted.

### Where MDNs fit in the hierarchy
Between Probabilistic NLL and Normalizing Flows: MDNs achieve multimodal distributional output with single-pass inference and no invertibility constraints, but within a parametric (Gaussian mixture) family. For features with genuinely multimodal conditionals, MDNs are more principled than HL-Gauss (intentional vs. accidental multimodality) and cheaper than flows or diffusion. For unimodal features (the majority), they add unnecessary complexity.

**Practical recommendation:** Consider MDN heads specifically for features known to have multimodal conditionals (e.g., categorical-like ordinals, bimodal distributions). For general-purpose tabular FM reconstruction, discretized approaches (CE/CRPS-on-bins) or quantile methods (IQN/NQ) are more robust defaults.

---

## Implicit Quantile Networks (IQN) & NQ-Networks

Source: Dabney et al., "Implicit Quantile Networks for Distributional Reinforcement Learning" (ICML 2018, arXiv:1806.06923)

### Core idea
Instead of predicting a fixed set of quantiles (K output heads) or a fixed set of bins (m logits), IQN represents the **full quantile function** Q(τ) continuously by taking the quantile level τ ∈ [0,1] as an *input* to the network:

```
Q(τ | x) = f_θ(x, τ)    — single network, any τ
```

The quantile level τ is embedded via cosine features and fused with the input representation. Training uses the quantile Huber loss (pinball + Huber smoothing at zero).

> "Implicit Quantile Networks (IQN) is a neural framework for estimating the full conditional quantile function, allowing nonparametric modeling of distributions. IQN employs specialized quantile embeddings and the quantile Huber loss to ensure smooth, stable training and enforce monotonicity in quantile predictions." — [EmergentMind IQN topic](https://www.emergentmind.com/topics/implicit-quantile-networks-iqn)

### Why IQN matters for this hierarchy

1. **Solves quantile regression's scaling problem.** One network handles arbitrary τ in a single forward pass — no K heads, no K passes. TabICLv2's 999-quantile approach is essentially a discretized IQN; a continuous IQN would eliminate the 999 output heads.

2. **Unbounded support.** No bins, no [z_min, z_max] range. The quantile function maps [0,1] → ℝ, naturally handling long tails, domain shift, and non-stationarity — the exact failure modes of discretized CE/CRPS-on-bins (limitation #1).

3. **Non-parametric distributional output.** Like discretized approaches, IQN assumes nothing about the target distribution shape. Unlike them, the output is continuous rather than piecewise-constant over bins.

4. **CRPS training is natural.** Since CRPS = ∫ pinball losses over all τ, an IQN trained with sampled τ values and pinball loss is implicitly minimizing a Monte Carlo estimate of CRPS. This gives proper scoring without discretization.

5. **Bounded gradients.** The quantile Huber loss has bounded gradients by construction (bounded in {-(1-τ), τ} like pinball, smoothed at zero like Huber).

### Non-Crossing Quantile Networks (NQ-Networks)

The key architectural improvement over vanilla IQN: enforce monotonicity of Q(τ) by construction.

> "In this paper, we introduce a non-crossing quantile (NQ) network for conditional distribution learning. By leveraging non-negative activation functions, the NQ network ensures that the learned distributions remain monotonic, effectively addressing the issue of quantile crossing." — [arXiv:2504.08215](https://arxiv.org/abs/2504.08215) (Apr 2025)

A production PyTorch framework for scalable non-crossing quantile regression:

> "Quantile regression is fundamental to distributional modeling, yet independent estimation of multiple quantiles frequently produces crossing — where estimated quantile functions violate monotonicity, implying impossible negative probability densities." — [arXiv:2510.22419](https://arxiv.org/html/2510.22419v2)

NQ-networks achieve **monotonic CDF by construction** via cumulative softplus or similar non-negative constraints. This eliminates both quantile crossing AND the unimodality problem that plagues HL-Gauss's unconstrained softmax — a single architectural constraint replaces two separate ad-hoc fixes.

The predecessor **Fully Parameterized Quantile Function (FQF)** (Yang et al., AAAI 2019, arXiv:1911.02140) goes further: it learns the quantile fractions τ themselves (where to place the quantile knots), concentrating resolution where the distribution is complex. FQF predates NQ-networks and established the idea of adaptive quantile placement that NQ-networks later combined with monotonicity enforcement.

### Limitations of IQN / NQ-Networks
- **Representation quality untested.** The "Stop Regressing" linear probing results are specific to cross-entropy on bins. Whether IQN/NQ produce equally rich penultimate representations is an open empirical question.
- **Multi-step inference for full distribution.** Extracting the full distributional shape requires multiple forward passes with different τ values (though point prediction needs only τ=0.5 for median).
- **No log-likelihood.** Like CRPS-on-bins, IQN provides no natural log-likelihood for model comparison or Bayesian inference.
- **Less established for pre-training.** No tabular FM has used IQN as its pre-training loss. TabICLv2's 999-quantile pinball loss is the closest precedent.
- **Architecture is not a drop-in replacement.** Unlike CE-on-bins or CRPS-on-bins (which only change the loss computation on the same softmax output), IQN requires fusing τ embeddings into the network representation — a non-trivial architectural change, especially for multi-feature reconstruction.
- **Multi-output scaling.** In RL, IQN predicts Q(τ) for a single scalar return. For tabular FM reconstruction with N features, this becomes N independent quantile functions, each requiring τ-embedding fusion. TabICLv2's 999-quantile approach works because it predicts a single target; extending this to simultaneous feature reconstruction multiplies complexity by N.
- **Why TabICLv2 discretized.** TabICLv2 uses 999 fixed quantile heads rather than continuous IQN precisely because the discrete version is simpler to implement, parallelize, and scale. This is empirical evidence that IQN's theoretical elegance faces practical engineering barriers at scale.

### Where IQN/NQ-Networks sit in the hierarchy
Between Quantile/Pinball and Normalizing Flows: they achieve continuous non-parametric distributional output without invertibility constraints, bounded range, or discretization artifacts. They are the only approach that is simultaneously unbounded, non-parametric, and proper-scoring with a single network — though these theoretical advantages come with practical engineering costs (non-trivial architecture changes, multi-output scaling) that have prevented adoption in tabular FMs so far.

---

## Diffusion Models for Conditional Regression

Source: Han et al., "CARD: Classification and Regression Diffusion Models" (arXiv:2206.07275, 2022)

### Core idea
Model the full conditional distribution p(y|x) by learning to iteratively denoise samples. Start from Gaussian noise, condition on input x, and reverse a diffusion process to produce samples from p(y|x).

> "In this paper, we introduce classification and regression diffusion (CARD) models, which combine a denoising diffusion-based conditional generative model and a pre-trained conditional mean estimator, to accurately predict the distribution of y given x." — [arXiv:2206.07275](https://arxiv.org/abs/2206.07275)

### Why diffusion matters
- **Expressiveness without constraints.** Like flows, diffusion models represent arbitrary distributions with unbounded support. Unlike flows, no invertibility constraint on the architecture — any neural network can serve as the denoiser.
- **Tabular data success.** Diffusion models have shown competitive results on tabular conditional density estimation. TabDiff (arXiv:2410.20626) and CDTD (arXiv:2312.10431) demonstrate joint continuous-categorical tabular generation.
- **No discretization.** Unbounded, continuous output. No bins, no range, no resolution tradeoff.

> "In the domain of tabular data, diffusion models have begun to showcase similar advantages over GANs and VAEs, achieving significant performance breakthroughs and demonstrating their potential for addressing unique challenges in tabular data modeling." — [arXiv:2502.17119](https://arxiv.org/html/2502.17119)

### Why diffusion is NOT in the practical recommendation for tabular FMs
- **Multi-step inference.** Generating one sample requires T denoising steps (typically 50-1000). For a tabular FM serving predictions at scale, this is 50-1000× slower than a single softmax forward pass.
- **Point prediction overhead.** Extracting E[y|x] requires generating multiple samples and averaging. Discretized CE gives E[y|x] = Σ p̂ᵢ · zᵢ in one pass.
- **Training complexity.** Noise schedule, denoising steps, EMA, and a separate pre-trained mean estimator (for CARD) add substantial engineering overhead.
- **No representation learning evidence.** No study has compared penultimate representations from diffusion-based regression vs. CE-on-bins.

### Where diffusion sits in the hierarchy
Between Normalizing Flows and Discretized CE on expressiveness (arbitrary distributions, unbounded support, no invertibility constraints). Below Discretized CE on practicality for serving. The right choice when you need the full generative distribution and can afford multi-step inference — e.g., synthetic data generation, imputation, or offline distributional analysis.

---

## Discretized Cross-Entropy (HL-Gauss) — The Dark Horse

Source: "Stop Regressing: Training Value Functions via Classification for Scalable Deep RL" (Farebrother et al., 2024, arXiv:2403.03950)

Prior art: Imani & White, "Improving Regression Performance with Distributional Losses" (ICML 2018). Already showed that discretizing continuous targets and training with cross-entropy improves regression accuracy over MSE, and that "it significantly improves prediction accuracy" via "improved representations" — not just regularization. Farebrother et al.'s contribution is the HL-Gauss encoding, the RL-at-scale demonstration, and the gradient geometry analysis.

Deep analysis: Imani, Luedemann, Scholnick-Hughes, Elelimy, & White, "Investigating the Histogram Loss in Regression" (arXiv:2402.13425v2, 2024). A 52-page theoretical and empirical study that provides the formal foundations for most claims made informally by Farebrother et al. Key results cited below under gradient bounds (Proposition 1), discretization bias (Proposition 2), and the KL direction analysis (connection to maximum entropy RL). This is the definitive reference for understanding *why* histogram loss works.

### Mechanism
1. Chop output range into m evenly-spaced bins
2. Model outputs softmax over bins (categorical distribution)
3. Target encoded as Gaussian-smoothed histogram centered at true value
4. Loss = cross-entropy between predicted and target distributions
5. Inference prediction = expected value of predicted distribution: ŷ = Σ p̂ᵢ · zᵢ

### Three encoding schemes

**One-Hot**: snap to nearest bin. Lossy.

**Two-Hot**: linear interpolation between bracketing bins. Lossless for representing the target, but only 2 bins receive gradient per sample — far sparser than HL-Gauss's ~6. Used by MuZero. The sparse gradient means most bins receive zero learning signal per sample, relying on batch aggregation across many steps to shape the full distribution. MuZero's success with Two-Hot suggests the dense gradient of HL-Gauss is not always necessary — the critical factor may be the CE loss itself (bounded gradients + multi-logit output) rather than the specific target encoding density. However, Farebrother et al.'s ablation shows HL-Gauss consistently outperforms Two-Hot, confirming that denser gradient spread helps when available.

**HL-Gauss** (the winner): center Gaussian (σ = 0.75 bin widths) at target, integrate over each bin. Mass spreads to ~6 neighboring bins. Exploits ordinal structure.

```
p_i = Φ((z_i + ς/2 - y) / σ) - Φ((z_i - ς/2 - y) / σ)
```

### Why it dominates — five reinforcing mechanisms

**1. Bounded and informative gradients (formally proven).**
∂L/∂logit_i = p̂_i - p_i, always in [-1, 1]. No outlier can produce unbounded gradient. Huber-like robustness for free, no δ parameter.

Imani et al. (arXiv:2402.13425v2, 2024) prove this rigorously as Proposition 1: the gradient norm of HL-Gaussian is bounded by (l + ‖φ_θ(x)‖) · Σ|c_i - h_i(x)|, where the sum Σ|c_i - h_i(x)| is "guaranteed to be less than 1, but generally is likely to be even smaller, especially if h_i(x) reasonably accurately predicts c_i." Compare to L2 whose gradient norm is proportional to |f(x) - y|, which "can be much larger, even if y is normalized between [0,1], and can vary considerably more." This connects to generalization via Hardt et al. (2016): tighter gradient norm bounds imply better generalization for SGD.

Imani et al. also demonstrate empirically that HL-Gaussian is **offset-invariant**: L2's convergence deteriorates as target offset increases (shifting sin(αx) by β=10 drastically slows L2), while "the behavior of HL-Gaussian is not affected." For tabular FMs with heterogeneous feature scales, this offset invariance is directly relevant.

**Gradient informativeness, not just bounding.** Gradient bounding is necessary but not sufficient to explain HL-Gauss's superiority — Huber loss also bounds gradients yet performs far worse. The distinguishing factor is **gradient dimensionality**: CE-on-bins sends gradient signal to multiple logits simultaneously (∂L/∂logit_i = p̂_i - p_i for every bin i), while Huber sends signal to a single scalar.

**Critical qualification: effective gradient dimensionality is ~6-10, not m.** With HL-Gauss σ = 0.75 bin widths, the target distribution has meaningful mass in ~6 bins. For bins far from both the target *and* the predicted distribution, ∂L/∂logit_i = p̂_i - p_i ≈ 0 - 0 = 0. The effective gradient rank per sample is closer to **6-10 dimensions**, not the full m=101. Furthermore, as training progresses and the predicted distribution sharpens (p̂ concentrates on a few bins), gradients to peripheral bins vanish exponentially — analogous to dead ReLU neurons. The Fisher information matrix diag(p̂) - p̂p̂ᵀ also loses rank as p̂ sharpens, meaning the beneficial curvature information vanishes in the periphery as training converges.

This is still substantially richer than MSE's 1-dimensional signal (6-10× more gradient information per sample), and the Two-Hot vs. HL-Gauss comparison isolates this clearly: both use CE with bounded gradients, but HL-Gauss's denser ~6-bin signal consistently outperforms Two-Hot's 2-bin signal. The gradient informativeness advantage is real but more modest than the "m-dimensional gradient per sample" framing suggests.

**Second-order curvature: implicit natural gradient.** Beyond first-order gradient properties, CE over softmax provides second-order (curvature) information that scalar losses lack entirely. The Hessian of CE w.r.t. logits is ∂²L/∂logit_i∂logit_j = diag(p̂) - p̂p̂ᵀ — the Fisher information matrix of the categorical distribution. This curvature is *data-dependent*: when predictions are uncertain (uniform p̂), curvature is high (fast learning); when confident (peaked p̂), curvature is low (careful updates). This is effectively **natural gradient** behavior built into the loss function itself — the optimizer implicitly receives second-order signal without computing the Hessian explicitly.

By contrast, MSE has constant Hessian (∂²L/∂ŷ² = 1) — a featureless quadratic bowl providing zero curvature information. The optimizer learns nothing about local geometry from the loss landscape.

"Newton Losses" (Petersen et al., NeurIPS 2024) validates that exploiting second-order information in loss functions improves training: "Newton Losses, a method for improving the performance of existing hard to optimize losses by exploiting their second-order information via their empirical Fisher and Hessian matrices." CE-on-bins achieves a version of this for free.

Giryes et al. ("The Central Role of the Loss Function in Reinforcement Learning," arXiv:2409.12799, 2025) prove the theoretical consequence: "distributional algorithms using the maximum likelihood loss achieve second-order bounds scaling with the policy variance and are even sharper than first-order bounds. This in particular proves the benefits of distributional RL." The log-likelihood (CE) loss achieves *variance-dependent* convergence rates that MSE's constant curvature cannot match.

**2. Richer representations.**
Outputting m-way distribution forces penultimate features to encode more information than a scalar projection. Paper shows empirically via linear probing: cross-entropy representations are consistently better for downstream tasks. (Note: this is an empirical finding from RL probing experiments — Atari and robotics — not a formal proof, and not validated on tabular regression. Whether this transfers to tabular FM pre-training with heterogeneous features is an open question.)

**Neural collapse caveat.** Recent work reveals a subtlety: "Neural Collapse in Cumulative Link Models for Ordinal Regression" (NeurIPS 2025, arXiv:2506.05801) shows that ordinal classification features collapse to a **one-dimensional arrangement** of class means: "Neural collapse in ordinal regression is a geometric phenomenon where within-class features collapse to their mean and align with a single classifier direction" (EmergentMind summary). If HL-Gauss induces similar 1D collapse, representations become highly informative along the target-prediction axis but lose information orthogonal to it. This could explain the tension between "richer representations" (Stop Regressing, probing for the same task) and "geometric distortion" (Geometric Alignment Tax, transfer to different tasks): enrichment along the prediction axis, collapse along others. Practical implication: representation quality measured by linear probing on the *same* task may not generalize to transfer learning or feature reconstruction, where orthogonal information matters.

**3. Implicit multi-modal capability.**
Categorical distribution can represent arbitrary shapes — bimodal, skewed, truncated — like a normalizing flow but with zero architectural complexity.

**Caveat — the unimodality problem.** Unconstrained softmax over ordered bins does *not* guarantee unimodal predictions. Albuquerque et al. (arXiv:2410.15658, Oct 2024) show that "the expectation that softmax probabilities should exhibit unimodal distribution is not met with cross-entropy." For regression tasks where the true conditional is unimodal (most tabular regression), the model can spread mass across non-contiguous bins, producing physically nonsensical bimodal predictions. HL-Gauss's Gaussian target encoding partially mitigates this, but the *predicted* distribution has no structural unimodality guarantee. The ordinal regression literature (CORAL: Cao et al. 2020; CORN: Shi et al. 2021, arXiv:2111.08851) addresses this with rank-consistency constraints. More recently, **UNICORNN** (OpenReview, Feb 2025) jointly enforces unimodality AND calibration for ordinal regression: "Ordinal regression is a supervised machine learning technique aimed at predicting the value of a discrete dependent variable with an ordered set of possible outcomes" — it provides a direct architectural fix for HL-Gauss's unimodality problem that older CORAL/CORN approaches handle less elegantly. Non-crossing quantile networks (see [IQN section](#implicit-quantile-networks-iqn--nq-networks)) solve this more fundamentally by enforcing monotonic CDF by construction. See also [Direct CDF Regression](#direct-cdf-regression--monotonic-crps-the-missing-formulation) for a bin-based approach that guarantees unimodality.

**4. Ordinal structure exploitation — but only on the target side.**
Gaussian smoothing encodes "nearby values are more similar" in the *target distribution*. Gradient signal from all neighboring bins, not just exact target. Far more informative than MSE's scalar error.

**Critical caveat: CE is ordinal-blind on the prediction side.** The cross-entropy loss itself treats all bin mismatches identically — it penalizes placing probability in the wrong bin regardless of how far that bin is from the truth. Landsgesell & Knoll (arXiv:2603.08206v4, Feb 2026) state this explicitly: "cross-entropy...ignores the ordinal structure of the output space: predicting y=100 when the truth is y=10 should be penalized more heavily than predicting y=11, yet cross-entropy treats both errors identically if they fall into different wrong bins." HL-Gauss's ordinal awareness comes entirely from the Gaussian target encoding, not from the loss geometry. CRPS, by contrast, is inherently ordinal-aware through its CDF-based formulation (see [CRPS-on-Bins](#crps-on-bins--the-theoretically-principled-alternative) below).

Recent work addresses this directly: "Ordinal Cross-Entropy for Probabilistic Time Series Forecasting" (OCE-TS, arXiv:2511.10200, Nov 2025) modifies CE itself to be ordinal-aware, "preserving prediction order while quantifying uncertainty through probability output." More generally, the ordinal CE literature (arXiv:2412.01246, Dec 2024) proposes "distance-weighting, unimodal constraints, and soft encoding to align outputs with ordinal relationships" — direct fixes for standard CE's ordinal blindness that HL-Gauss could adopt.

**5. Scaling behavior — via loss × optimizer interaction.**
MSE performance plateaus or degrades with larger models. Cross-entropy continues improving. Critical for foundation models that want to be large.

**The optimizer interaction.** The scaling advantage is not purely a loss function property — it's a **loss × optimizer** interaction that the loss enables. With Adam (the dominant optimizer for large models):

- **MSE + Adam:** Gradient magnitude is proportional to error. Adam divides by the running RMS of gradients. Outliers with huge gradients inflate the denominator, temporarily suppressing the effective learning rate for all parameters. The first moment (momentum) also gets corrupted. Result: the effective learning rate oscillates as outlier frequency varies across training. Large models with more parameters have more opportunities for this instability to cascade.

- **CE-on-bins + Adam:** Gradients are bounded in [-1, 1]. Adam's running RMS stays near-constant regardless of target value outliers. The effective learning rate is stable across training. Bounded gradient inputs to Adam's normalizer produce stable normalized outputs — a synergy between loss and optimizer that neither achieves alone.

This gradient stability under Adam likely explains a significant fraction of the scaling advantage. Large models + Adam + MSE = unstable effective learning rates as gradient statistics shift. Large models + Adam + CE = stable effective learning rates throughout training. The second-order curvature analysis above explains *why* CE provides better signal; the optimizer interaction explains *how* that signal translates to better training dynamics at scale.

### Empirical results from the paper
- Single-task Atari: HL-Gauss consistently beats MSE, Two-Hot, and even C51 (distributional RL)
- Multi-task Atari with ResNets: 1.8-2.1× performance
- Chess without search: 70% improvement, nearly matches AlphaZero with 400 MCTS simulations
- Robotic manipulation: 67% better peak performance, much more sample-efficient
- Wordle language agent: 40% better performance

### Key finding: it's the loss, not the parameterization
Paper ablation (Section 5.1.1): softmax output + MSE loss does NOT improve over plain MSE. The cross-entropy loss itself is the critical ingredient.

### Key finding: it's not just label smoothing
Optimal σ is independent of bin count (Section 5.1.2), which is consistent with HL-Gauss leveraging ordinal regression structure rather than just reduced overfitting. (This is an ablation result consistent with that interpretation, not a proven causal claim.) Imani et al. (arXiv:2402.13425v2, 2024) provide a more nuanced view: σ controls a bias-variance tradeoff where larger σ reduces discretization bias but increases smoothing bias. The "independence from bin count" finding may reflect a sweet spot in that tradeoff rather than a deep structural insight about ordinal exploitation. Note: Farebrother et al. use σ = 0.75 × bin_spacing; Imani et al. use σ = bin_width. Both report robustness, but these are different conventions validated in different domains (RL vs. tabular regression).

**The σ-temperature-noise connection.** HL-Gauss's Gaussian target with width σ is functionally equivalent to soft labels with a temperature proportional to σ². Larger σ → smoother targets → higher effective temperature → more regularized, less overconfident predictions. This connects HL-Gauss to the calibration-via-temperature-scaling literature (Guo et al., "On Calibration of Modern Neural Networks," ICML 2017).

σ also acts as an **implicit label noise model**: it spreads the target distribution, effectively assuming the true value could plausibly be within ~2σ of the recorded label. This means:
- **σ << actual label noise:** The model overfits to noisy labels. The target distribution is too sharp.
- **σ >> actual label noise:** The model underfits. Useful precision is discarded by excessive smoothing.
- **σ ≈ label noise:** The target distribution approximately matches the true posterior given a noisy observation.

For tabular data where measurement noise is ubiquitous and varies per feature, this reframes σ selection from a loss-function hyperparameter to a **noise estimation problem**. Optimal σ differs per feature (different measurement noise levels). An extension: **per-sample adaptive σ**, where a small auxiliary head predicts σ(x) and the HL-Gauss target uses that prediction, restoring heteroscedastic noise modeling within the CE-on-bins framework.

Implication: σ should be tuned not just for gradient spread or bias-variance, but also for **calibration quality** and **label noise adaptation**.

### Growing evidence across domains
- RL (this paper, 2024): 30-70% improvements
- Time series (2025): "discretizing continuous target space into bins...benefit from stable training, robust uncertainty modeling" (arXiv:2505.24595)
- Tabular (Mar 2026): "basic tokenization unlocks the power of attention on tabular features, outperforms tuned gradient boosting when combined with Gaussian smoothing" (arXiv:2603.07448)

### Counter-evidence: the geometric alignment tax
- Scientific FMs (Apr 2026): "The Geometric Alignment Tax" (arXiv:2604.04155) finds **the opposite direction** — "replacing cross-entropy with a continuous head on an identical encoder reduces geometric distortion by up to 8.5x, while learned codebooks exhibit a non-monotonic double bind where finer quantization worsens geometry despite improving reconstruction." This means discretization can *degrade* the latent manifold structure. For tasks where latent geometry matters (feature reconstruction, transfer learning, anomaly detection), continuous losses may preserve structure that discretized CE destroys.

**Mechanism: neural collapse.** The Geometric Alignment Tax observes the symptom (distorted geometry); the Neural Collapse in ordinal regression literature (arXiv:2506.05801, NeurIPS 2025) suggests a mechanism. Discretized classification objectives drive features toward low-dimensional arrangements aligned with the output class structure. For ordinal/regression bins, this means collapse toward approximately 1D — the value axis. Finer quantization worsens this because more bins create stronger pull toward the ordinal axis while still constraining features to a 1D manifold. This explains the paper's "non-monotonic double bind where finer quantization worsens geometry despite improving reconstruction" — finer bins improve reconstruction accuracy (more precise value prediction) while simultaneously compressing the latent space more aggressively toward 1D.

### Limitations of Discretized CE

The advantages are real but the tradeoffs are significant:

1. **Hard-bounded output range.** ŷ = Σ p̂ᵢ · zᵢ is bounded to [z_min, z_max] by construction. Cannot extrapolate. Long tails, domain shift, and non-stationarity are failure modes that MSE/Huber handle naturally.

2. **Not a proper scoring rule for continuous targets.** Cross-entropy on discretized bins is proper for the *categorical* distribution over bins, but not for the underlying continuous distribution. The discretization introduces an irreducible mismatch. Moreover, CE is ordinal-blind — it does not penalize predictions proportionally to their distance from truth (see mechanism #4 caveat above). **Important nuance:** CE on bins IS proper for the discretized output space the model actually produces. The issue isn't propriety per se — it's that the output space (categorical over bins) is an approximation of the target space (continuous reals). This is a discretization concern, not a scoring rule concern. See [Proper Scoring Rule Nuance](#proper-scoring-rule-nuance) below.

3. **Unimodality not guaranteed.** Unconstrained softmax can (and empirically does) produce non-unimodal predictions even when the true conditional is unimodal. See unimodality caveat above.

4. **Resolution-range tradeoff with a provable bias bound.** Fixed bin count means wider range = coarser resolution. With m=101 bins over [-5, 5], each bin spans ~0.1 units. Imani et al. (arXiv:2402.13425v2, 2024) prove in Proposition 2 that the discretization bias |Bias(h*, p)| ≤ w/2 (half the bin width) when using Gaussian targets with negligible truncation. For the example above, max bias ≈ 0.05. For high-precision tasks (e.g., financial pricing), this discretization error may dominate.

   **Mitigation: non-uniform (quantile-based) binning.** Placing bins at empirical quantiles of the training distribution achieves uniform probability mass per bin rather than uniform width. High-density regions get fine resolution; tails get coarse but adequate coverage. This converts the bias bound from uniform w/2 everywhere to inhomogeneous — tight where data is dense, loose where data is sparse and errors matter less. For rank/quantile-normalized features, quantile bins are approximately uniform anyway; for unnormalized features or mixed-distribution reconstruction, non-uniform binning substantially reduces the tradeoff. **Caveat for non-stationarity:** non-uniform bins are optimized for the training distribution and become maximally misaligned under distribution shift; uniform bins degrade more gracefully (see [Loss behavior under distribution shift](#loss-behavior-under-distribution-shift)).

   **Beyond static binning: learned adaptive bins.** The depth estimation community has developed end-to-end learned bin placement:
   - **AdaBins** (Bhat et al., CVPR 2021): "a transformer-based architecture block that divides the depth range into bins whose center value is estimated adaptively per image. The final depth values are estimated as linear combinations of the bin centers." Input-dependent bin placement, concentrating resolution where each sample needs it.
   - **BinsFormer** (Li et al., IEEE TIP 2024): "a novel framework tailored for the classification-regression-based depth estimation. It mainly focuses on: 1) proper generation of adaptive bins; and 2) sufficient interaction between probability distribution and bins predictions." Adds learned interaction between bin selection and prediction.
   - **IEBins** (Shao et al., NeurIPS 2023, arXiv:2309.14137): "The proposed IEBins aims to search for high-quality depth by progressively optimizing the search range, which involves multiple stages and each stage performs a finer-grained depth search in the target bin on top of its previous stage." Iterative coarse-to-fine refinement that solves the resolution-range tradeoff *at inference time*. In a transformer architecture, each layer could perform one refinement step, progressively narrowing the bin range — converting m=101 bins from covering [-5, 5] at 0.1 resolution to covering a 1-unit range at 0.01 resolution. This is architecturally the most relevant to tabular FMs because it uses the same iterative refinement paradigm that transformers naturally support.
   - **Spacing-Increasing Discretization (SID)** (Fu et al., CVPR 2018): log-spaced bins instead of uniform — "a spacing-increasing discretization strategy to discretize depth and recast depth network learning as an ordinal regression problem." For features with exponential or power-law distributions (counts, monetary values, durations in tabular data), log-spacing directly reduces discretization error where it matters most.

   For tabular FMs, per-feature learned bins are architecturally feasible (bin centers become trainable parameters per feature head). This converts the resolution-range tradeoff from a fixed design choice to a learned one, though it adds parameters and complicates the training loop.

5. **O(m) memory and compute scaling — significant at multi-feature scale.** Each output head produces m logits instead of 1. For a tabular FM reconstructing N=200 features with m=101 bins: output projection goes from [d, 200] to [d, 20,200] — a **101× increase** in the largest weight matrix. Memory for output logits: 20.7M floats per batch of 1024 vs. 204K. Additionally: 200 independent 101-way softmax operations per sample, 200 HL-Gauss target encodings (each requiring Gaussian CDF integration over 101 bins). At scale, this memory amplification can force **reduced batch sizes**, which affects training dynamics (smaller batches → noisier gradients → different optima). This is not "manageable but not free" — it is the dominant cost change when upgrading from scalar to distributional output.

6. **Geometric distortion of latent space.** The geometric alignment tax (arXiv:2604.04155) shows discretization can degrade learned representations' manifold structure. This specifically matters for reconstruction/self-supervised objectives.

7. **σ is another hyperparameter — with a label noise interpretation.** Farebrother et al. use σ = 0.75 × bin_spacing (validated in RL). Imani et al. use σ = bin_width (validated on four tabular regression datasets). Both report robustness, but neither covers the tabular FM pre-training regime with massive heterogeneous datasets. The search space is σ × m × range — not zero. The label noise interpretation (see [σ-temperature-noise connection](#the-σ-temperature-noise-connection) above) adds per-feature noise level as a further consideration.

8. **KL direction is mode-covering, not mode-seeking.** HL minimizes D_KL(target ‖ predicted), the "forward" or "inclusive" KL. Imani et al. (arXiv:2402.13425v2, 2024, Section 3.2) show this is equivalent to the maximum entropy RL objective with Gaussian reward and τ = σ². Mode-covering means the predicted distribution must cover all regions where the target has mass, but may spread probability where the target is zero — favoring broader, smoother predictions. For unimodal regression (most tabular tasks), this can wastefully spread mass and connects to the unimodality problem above. For multimodal tasks, mode-covering is desirable. NLL-based losses minimize D_KL(predicted ‖ target) (mode-seeking), favoring sharper concentrations.

9. **CE loss surface singularities.** "Complex Singularities That Limit Safe Step Sizes in Cross-Entropy" (arXiv:2603.13552, Mar 2026) identifies fundamental singularity issues in CE training dynamics. HL-Gauss's Gaussian smoothing partially mitigates this (no target probability is exactly 0), but the issue remains relevant for bins far from the target center where target mass approaches zero.

10. **Initialization and warmup overhead.** From random initialization, the softmax output is approximately uniform over all bins. Against peaked HL-Gauss targets (σ = 0.75 bin widths), the initial loss is approximately -log(1/m) = log(m) ≈ 4.6 for m=101. For MSE with normalized targets, initial loss is ~O(1). This creates a **two-phase learning dynamic**: Phase 1 — learn to concentrate mass near the target (coarse localization); Phase 2 — learn the distributional shape (calibration, tails). MSE has no such phase transition. For fine-tuning scenarios where fast adaptation matters, this overhead is non-trivial. Furthermore, **warm-starting from a pre-trained scalar head** is not straightforward: switching from [d, 1] to [d, m] requires reinitializing the output projection. A principled warm-start would initialize logits such that ŷ = Σ softmax(logits)ᵢ · zᵢ matches the original scalar output, but no standard procedure exists.

### Mean-of-multimodal pathology at inference time

For truly multimodal distributions, the standard point prediction formula ŷ = Σ p̂ᵢ · zᵢ (expected value) can produce a value with **near-zero predicted probability**. Consider a bimodal predicted distribution with modes at 2 and 8: the expected value is ~5 — a value the model itself considers virtually impossible. The model predicts a value it gives near-zero probability to.

This pathology affects all bin-based and quantile methods equivalently:
- **CE/CRPS-on-bins:** ŷ = Σ p̂ᵢ · zᵢ falls between modes
- **IQN/NQ-networks:** the median Q(0.5) falls between modes for bimodal distributions too
- **MDNs:** unique advantage — provide interpretable per-mode predictions (each μ_k)

Fixes: use the **mode** (argmax bin center) or **median** (CDF crossing 0.5) instead of the mean, with awareness that these also fail between modes of a bimodal distribution. For genuinely multimodal conditionals, the right inference strategy is to return the full distribution or mode-specific point predictions (MDNs), not a single summary statistic.

---

## CRPS-on-Bins — The Theoretically Principled Alternative

The same softmax-over-bins output head used by HL-Gauss can be trained with CRPS instead of cross-entropy. This is not a different architecture — it's the same m-dimensional softmax output, with a different loss function applied to it.

### Mechanism
Given the predicted PMF p̂ over m bins with centers zᵢ, compute the predicted CDF F̂(zᵢ) = Σ_{j≤i} p̂_j, then:

```
CRPS(F̂, y) ≈ Σ_i (F̂(z_i) - 𝟙{z_i ≥ y})² · Δz_i
```

Landsgesell & Knoll (arXiv:2603.08206v4, Feb 2026) provide this exact formulation: "For a discretized output space, the CRPS (equivalent to the β=1 energy score) is: CRPS(F,y) ≈ Σ_i (F(x_i) - 𝟙{x_i≥y})² Δx_i, where F(x_i) is the predicted CDF (e.g., obtained via cumulative summation of the softmax output over the binned support)." (Convention note: 𝟙{z_i ≥ y} is the Heaviside step at y going from 0 to 1 — the standard CRPS convention where the observation's CDF is a unit step at y.)

### Why CRPS-on-bins may be superior to CE-on-bins

1. **Strictly proper for continuous distributions.** CE is only proper for the categorical distribution over bins. CRPS is proper for the underlying continuous distribution (see [Proper Scoring Rule Nuance](#proper-scoring-rule-nuance) for a more careful treatment of this distinction).

2. **Inherently ordinal-aware.** CRPS penalizes through the CDF, so placing probability mass far from the truth incurs proportionally greater loss. CE treats all wrong bins identically.

3. **Bounded gradients.** CRPS gradients are bounded, like CE. Landsgesell & Knoll: "CRPS...resulting in a bounded gradient that weights all quantile levels equally. This ensures that outliers or 'tail' realizations do not dominate the training signal as they do with the logarithmic score."

4. **No Gaussian smoothing hyperparameter needed.** CRPS operates directly on the PMF → CDF without requiring a σ parameter to encode ordinal structure (the CDF already does this). One less hyperparameter.

5. **EMD/Wasserstein-1 and Cramér distance connection.** For discrete distributions over ordered bins, the L1 distance between CDFs equals the Earth Mover's Distance (Wasserstein-1). Note: CRPS-on-bins as formulated above uses **squared** CDF difference (Σ(F̂ - 𝟙)²), which is the **Cramér distance** when generalized to comparing two predicted distributions. For a single observation y (where the true CDF is a step function), CRPS and the Cramér distance are identical — the distinction only matters in distributional RL. Rowland et al. ("An Analysis of Categorical Distributional Reinforcement Learning," AAAI 2018) showed the Cramér distance has superior gradient properties to Wasserstein-1 for distributional RL, specifically that it is a valid loss for stochastic gradient descent while Wasserstein-1 is not (biased gradients). For regression, the fundamental reason to prefer CRPS over Wasserstein-1 is simpler: CRPS is a proper scoring rule; Wasserstein-1 is a distance metric, not a score, and lacks the properness guarantee.

### Evidence from tabular FMs

TabICLv2 (arXiv:2602.11139, Feb 2026) — the current co-SOTA alongside TabPFN-2.5 — uses quantile regression (999 quantiles with pinball loss), which is closely related to CRPS (CRPS = integral of pinball losses over all quantiles). They explicitly found this superior: "In preliminary experiments using RMSE evaluation, we found that quantile regression outperforms MSE and the bin-based approach of TabPFNv2."

Landsgesell & Knoll (2026) show that fine-tuning TabPFN-2.5 with CRPS (not seen during pretraining) yields improvements, and that "different proper scoring rules induce different model rankings and different inductive biases during training, even though each rule is individually minimized by the true distribution." They explicitly note that "CRPS was adopted in TabICLv2 training in February 2026."

**Related recent work:**
- **Joint Optimization of Neural Autoregressors via Scoring Rules** (arXiv:2601.05683, Jan 2026) provides the theoretical basis for using proper scoring rules as *training* losses (not just evaluation metrics) for tabular FMs: "Non-parametric distributional regression has achieved significant milestones in recent years. Among these, the Tabular Prior-Data Fitted Network (TabPFN) has demonstrated state-of-the-art performance on various benchmarks."
- **ScoringBench** (arXiv:2603.29928, Mar 2026) introduces a benchmark that evaluates tabular FMs with a full suite of proper scoring rules: "We introduce ScoringBench, an open benchmark that computes a comprehensive suite of proper scoring rules like CRPS, CRLS, Interval Score, Energy Score, weighted CRPS and Brier Score alongside standard point metrics, providing a richer picture of probabilistic forecast quality."

### Tradeoff: what CE-on-bins still does better

- **Representation learning.** CE's cross-entropy gradient may produce richer penultimate representations than CRPS — the "Stop Regressing" linear probing results are specific to CE, not CRPS. Whether CRPS-on-bins produces equally rich representations is an open empirical question.
- **Log-likelihood interpretation.** CE provides a natural log-likelihood, useful for model comparison and Bayesian inference. CRPS does not.
- **Established infrastructure.** CE is standard in every deep learning framework. CRPS-on-bins requires custom loss implementation (straightforward but not built-in).
- **Local scale invariance (approximately).** The continuous log score is the *only* local strictly proper scoring rule — CRPS is not. CE-on-bins approximates this property for uniform bins. See [CRPS scale invariance limitation](#limitation-crps-is-not-locally-scale-invariant) and [Proper Scoring Rule Nuance](#proper-scoring-rule-nuance) below.

### Limitation: CRPS is not locally scale invariant

A critical limitation the CRPS-superiority narrative often omits. Bolin & Wallin (arXiv:1912.05642, 2022) prove:

> "some of the most popular proper scoring rules, such as the continuous ranked probability score (CRPS), give more importance to observations with large uncertainty which can lead to unintuitive rankings."

**Local scale invariance** is the property that a scoring rule gives equal weight to forecast quality regardless of the local uncertainty level. CRPS lacks it: a feature with large uncertainty contributes disproportionately to the total CRPS loss, while a feature with tight, well-predicted distributions contributes almost nothing — even if its predictions are qualitatively poor.

Bjerregård et al. (arXiv:2306.15088, 2023) extend this analysis: "Locally scale invariant scoring rules give equal importance to the forecasts at different locations regardless of differences in the prediction uncertainty."

Bernardi ("Beyond Strictly Proper Scoring Rules," ResearchGate, 2021) makes the strongest claim: "The only local strictly proper scoring rules, the logarithmic score, has direct interpretations in terms of probabilities and bits of information. The nonlocal strictly proper scoring rules, on the other hand, lack meaningful direct interpretation for decision support." The log score *is* CE.

**Why this matters for tabular FMs:** When reconstructing N heterogeneous features with wildly different scales and uncertainty levels, CRPS's scale sensitivity creates a gradient imbalance. High-uncertainty features dominate the loss; low-uncertainty features are effectively invisible. CE's logarithmic scoring produces *better-balanced* gradients across features, despite CRPS's other theoretical advantages.

**The CRLS alternative.** The Continuous Ranked Logarithmic Scoring Rule (CRLS) — included in ScoringBench (arXiv:2603.29928) alongside CRPS — is a locally scale-invariant proper scoring rule that addresses this exact limitation. Landsgesell & Knoll (arXiv:2603.08206v4) include CRLS in their evaluation suite. For tabular FM pre-training with multi-feature reconstruction, CRLS may offer properness + ordinal awareness + scale invariance. **Practical caution:** CRLS requires computing log-densities from the predicted PMF, which introduces numerical issues (log of near-zero probabilities in tail bins). No published study has successfully trained a neural network with CRLS at scale — it appears in ScoringBench as an *evaluation* metric, not a training loss. Its theoretical appeal is strong but empirically unvalidated for training.

### Proper scoring rule nuance

The document's recurring contrast — "CE is not proper for continuous targets; CRPS is" — deserves a more careful treatment:

1. **CE on bins IS proper for the discretized distribution.** The output space is a categorical distribution over m bins. CE is the canonical proper scoring rule for categorical distributions. The issue isn't propriety — it's that the *output space itself* approximates the continuous target space. This is a discretization concern, not a scoring rule concern.

2. **CRPS's properness is also approximate when discretized.** CRPS on bins uses a Riemann sum approximation of the continuous CRPS integral. With m=101 bins, the approximation is good but not exact. Both CE-on-bins and CRPS-on-bins are discretized approximations of proper scoring rules for different output spaces.

3. **CE's "local scale invariance" is approximate for bins.** The continuous log score S(x; q) = -log q(x) is locally scale invariant because it depends on the *density* at the observed point. CE on bins depends on the probability *mass* in the observed bin. For uniform bins, mass ≈ density × bin_width, and the bin_width is constant, so the approximation is tight. For non-uniform bins (which this document recommends via quantile-based binning), mass and density diverge, and the scale invariance approximation weakens.

> "The most celebrated proper scoring rule is the logarithmic score, S(x; q) = -log q(x): this is the only proper scoring rule that is local, in the sense of depending on the density function q only through its value at the observed value x." — Dawid & Musio, *Theory and applications of proper scoring rules*, Springer, 2014

4. **Properness matters less than inductive bias in practice.** Landsgesell & Knoll's own finding undermines the properness argument: "different proper scoring rules induce different model rankings and different inductive biases during training, even though each rule is individually minimized by the true distribution." If all proper scoring rules agree on the theoretical optimum but disagree on which model is better *in practice*, then properness is not the differentiating factor — the inductive bias is. And CE's inductive bias (locally scale invariant, bounded gradients with rich curvature) may be more beneficial than CRPS's inductive bias (ordinal-aware but scale-sensitive) for multi-feature tabular FM training.

---

## Direct CDF Regression + Monotonic CRPS: The Missing Formulation

The preceding sections discuss softmax → PMF → CDF pipelines where monotonicity of the CDF is not guaranteed by construction (the softmax produces arbitrary PMFs). A cleaner formulation exists: **directly regress the CDF with architectural monotonicity constraints**, then train with CRPS.

### Mechanism
Instead of softmax(logits) → PMF p̂ → cumsum → CDF F̂, enforce monotonicity directly:

```python
# cumulative sigmoid: each output is a conditional probability of exceeding each bin
raw = network(x)  # m raw logits
F̂ = torch.sigmoid(raw).cumsum(dim=-1).clamp(0, 1)  # monotonic CDF by construction
# Or: use ordinal regression's cumulative link approach
F̂_i = σ(logit_i)  with logit_1 ≤ logit_2 ≤ ... ≤ logit_m  (via cumulative sum of non-negative values)

loss = crps(F̂, y, bins)  # Σ(F̂(z_i) - 𝟙{z_i ≥ y})² · Δz_i
```

### Why this formulation matters

1. **Unimodal by construction.** A monotonic CDF implies a non-negative PMF (its derivative). The implied density is non-negative everywhere — no nonsensical negative probability regions from quantile crossing. For regression tasks where the true conditional is unimodal (most tabular data), this structural guarantee eliminates the unimodality problem that plagues unconstrained softmax.

2. **CRPS loss: proper and ordinal-aware.** Same theoretical advantages as CRPS-on-softmax, but the monotonic CDF avoids wasting model capacity on learning that CDFs must be monotone.

3. **No softmax.** Eliminates the softmax bottleneck entirely. The output is a direct parameterization of the CDF, not an indirect one through the PMF.

4. **Same bin architecture.** Drop-in replacement for softmax-based approaches — same m output dimensions, same bin centers, same CRPS loss computation. The only change is the activation function (cumulative sigmoid/softplus instead of softmax + cumsum).

5. **Connection to ordinal regression.** This is essentially CORAL (Cao et al., 2020) or CORN (Shi et al., arXiv:2111.08851, 2021) with CRPS loss instead of binary CE at each threshold. The ordinal regression literature provides the architectural primitives; CRPS provides the loss. Together they address simultaneously the unimodality problem, the properness requirement, and the ordinal awareness requirement.

### Limitations
- **Cannot represent multimodal conditionals.** The enforced monotonic CDF implies a unimodal distribution. For features with genuinely multimodal conditionals, unconstrained softmax (HL-Gauss) or MDNs are needed.
- **Representation learning untested.** Like CRPS-on-softmax, no evidence on whether this produces representations comparable to CE's.
- **Less expressive per-bin.** Monotonicity constrains the model's output space, which may reduce flexibility for complex unimodal shapes (though NQ-networks achieve high expressiveness with monotonicity).

### Where it fits
Between CRPS-on-softmax-bins and NQ-networks: it combines bins (bounded range, fixed resolution) with monotonicity (unimodal guarantee) and CRPS (proper, ordinal-aware). It is the bin-based counterpart to NQ-networks' quantile-based monotonicity — addressing the same problem (non-unimodality) with the same principle (architectural monotonicity) in the bin output space rather than the quantile output space. This should be a **fifth ablation candidate** alongside CE-on-bins, CRPS-on-bins, CRLS, and NQ-networks.

---

## Conformal Prediction — Orthogonal Calibration Regardless of Loss

Loss choice and calibration are often conflated. Proper scoring rules (CRPS, pinball) guarantee calibration *in expectation at infinite sample*. **Conformal prediction** provides *finite-sample marginal coverage guarantees* regardless of the training loss:

> "Conformal Prediction (CP) offers a robust post-hoc calibration framework, providing distribution-free statistical coverage guarantees for prediction sets by leveraging held-out datasets." — [arXiv:2501.14544](https://arxiv.org/html/2501.14544)

> "A key challenge in probabilistic regression is ensuring that predictive distributions accurately reflect true empirical uncertainty. Minimizing overall prediction error often encourages models to prioritize informativeness over calibration, producing narrow but overconfident predictions." — [arXiv:2602.13362](https://arxiv.org/html/2602.13362v1)

### Why this matters for loss function choice

Conformal prediction **decouples two concerns**:
1. **Training loss** → optimize for gradient geometry, representation quality, optimization dynamics
2. **Post-hoc conformal calibration** → guarantee valid coverage regardless of training loss

This means you can choose HL-Gauss CE for its representation learning advantages and still get calibrated prediction intervals via conformal wrapping — without needing a proper scoring rule during training.

For tabular FMs specifically: conformal prediction is already being explored with TabPFN (arXiv:2603.27385, Mar 2026), where "tabular foundation models such as TabPFN provide calibrated probabilistic predictions via in-context learning."

### Limitation
Conformal guarantees are **marginal** (averaged over the test distribution), not conditional (per-instance). For conditional coverage, conformal methods require additional structure or lose their distribution-free property.

### Loss behavior under distribution shift

Conformal prediction partially addresses calibration under shift, but the deeper question is how different *training losses* degrade when the test distribution shifts — a critical concern for deployed tabular FMs.

- **Bounded-range losses (HL-Gauss, CRPS-on-bins):** When shifted data falls outside [z_min, z_max], predictions are *silently clamped* to the boundary. The model produces maximally confident wrong predictions at the edge of its range — the worst possible failure mode. There is no "I don't know" signal; the output distribution peaks at the boundary bin.

- **Unbounded losses (MSE, Huber, IQN/NQ):** Predictions can extrapolate, though quality degrades gracefully. Under fine-tuning, large errors produce large gradients (for MSE/Huber) or naturally weighted quantile signals (for IQN), enabling fast adaptation.

- **Properness guarantees are vacuous under shift.** CRPS's guarantee of being "uniquely minimized by the true conditional distribution" holds only under the i.i.d. assumption. Under covariate shift, there is no theoretical basis for preferring a model trained with a proper scoring rule over one trained with CE or MSE.

- **Bin placement staleness under non-stationarity.** Beyond the bounded-range problem, the bin placement itself becomes stale as distributions shift. If bins are set based on training data quantiles, they become misaligned as deployment distributions drift. Non-uniform (quantile) bins make this *worse*, not better — they are maximally optimized for the training distribution and maximally misaligned for shifted distributions. Uniform bins degrade more gracefully (resolution decreases proportionally). The practical mitigation is **periodic re-binning** with re-training — engineering overhead that scalar losses and IQN/NQ-networks do not require.

- **Practical implication for tabular FMs.** If deployment involves non-stationarity or domain shift, the bounded-range problem and bin staleness are dominant concerns. Mitigation options: (a) very wide bin ranges (sacrificing resolution), (b) IQN/NQ-networks (unbounded by design), (c) monitoring for boundary-saturation in predicted distributions as an OOD signal, (d) hybrid: CE-on-bins for the body of the distribution with a fallback continuous head for detected OOD inputs.

---

## Multivariate Considerations: Energy Score and Joint Calibration

The entire discussion above treats regression as **univariate** — predicting one continuous target. But tabular FMs like FEAT reconstruct *multiple features simultaneously*. When predicting N continuous features, the **correlation structure between outputs** matters.

### The problem
Applying CRPS or CE-on-bins to each feature independently produces individually-calibrated but potentially **jointly-incoherent** predictions. Reconstructed features may violate correlations that exist in the training data (e.g., height and weight being positively correlated).

### Energy Score: multivariate CRPS
The **Energy Score** is the proper scoring rule for multivariate distributional predictions (Gneiting & Raftery, 2007). Landsgesell & Knoll (arXiv:2603.08206v4) note CRPS is "equivalent to the β=1 energy score" in the univariate case; the Energy Score generalizes this to d dimensions.

ScoringBench (arXiv:2603.29928, Mar 2026) explicitly includes the Energy Score alongside CRPS: "We introduce ScoringBench, an open benchmark that computes a comprehensive suite of proper scoring rules like CRPS, CRLS, Interval Score, **Energy Score**, weighted CRPS and Brier Score alongside standard point metrics."

### Copula-based approaches
Neural copulas (arXiv:2411.03014v2) decompose the problem: "Copulas are a popular tool for modelling multivariate densities by decomposing the estimation procedure into two steps: first, learning the marginal density of each variable; and second, stitching those marginals together through a copula model." This maps naturally onto the tabular FM setup: per-feature distributional heads (HL-Gauss/CRPS/NQ) for marginals, with a learned copula for dependence.

### Practical implications for tabular FMs
- **Prediction heads** (single target): univariate CRPS or CE-on-bins is sufficient.
- **Reconstruction heads** (multiple features): per-feature independent losses ignore joint structure. The Energy Score or copula-based approaches may be needed. However, the computational cost scales with the number of features × number of bins.
- **Current practice**: all SOTA tabular FMs (TabPFN, TabICLv2, FEAT) use per-feature independent losses for reconstruction. Whether joint modeling improves downstream performance is an open empirical question.

---

## Imbalanced and Long-Tailed Targets

Real tabular data is often **massively skewed** — income distributions, event counts, claim amounts, duration data — and reconstruction targets in tabular FMs inherit this skewness.

### The problem
When the target distribution is long-tailed, the majority of training signal comes from the mode. Rare target values receive sparse gradient signal regardless of the loss function:
- **MSE/Huber**: dominated by the dense mode. Rare values in tails are underweighted.
- **HL-Gauss with uniform bins**: sparse tail regions get the same bin density as the mode, but vastly fewer training samples fall in tail bins — data starvation at the bin level.
- **CRPS-on-bins**: partially mitigated because tail errors accumulate through the entire CDF, but bin resolution in the tails still matters.
- **IQN/Quantile regression**: inherently more robust since quantile levels τ sample uniformly from the CDF, not the PDF. Extreme quantiles (τ near 0 or 1) get equal weight in training. But training data for extreme quantiles is still sparse.

### Source evidence

Ren et al., "Balanced MSE for Imbalanced Visual Regression" (CVPR 2022, arXiv:2203.16427): "we identify that the widely used Mean Square Error (MSE) loss function can be ineffective in imbalanced regression. We revisit MSE from a statistical view and propose a novel loss function, Balanced MSE, to accommodate the imbalanced training label distribution." They derive a Bayesian-reweighted loss: L_BMSE = MSE × p_balanced(y) / p_train(y).

Yang et al., "Balanced Sharpness-Aware Minimization for Imbalanced Regression" (arXiv:2508.16973, 2025): "we reframe imbalanced regression as an imbalanced generalization problem. To tackle that, we look into the loss sharpness property for measuring the generalization ability of regression models in the observation space." Connects to the SAM/loss-landscape-flatness literature.

Gong et al., "Leveraging Group Classification with Descending Soft Labeling for Deep Imbalanced Regression" (arXiv:2412.12327, Dec 2024): "Deep imbalanced regression (DIR), where the target values have a highly skewed distribution and are also continuous, is an intriguing yet under-explored problem in machine learning." They convert regression to classification with soft labels — directly connecting to HL-Gauss's approach.

### Practical mitigations per loss family

| Loss family | Mitigation | Mechanism |
|---|---|---|
| HL-Gauss CE | Inverse-density bin weighting; non-uniform (quantile) bins | Rebalances gradient signal across target range |
| CRPS-on-bins | Weighted CRPS (wCRPS) — already in ScoringBench | Upweights tail quantiles in the CDF integral |
| IQN/Quantile | Oversample extreme τ values during training | Increases gradient signal for tail behavior |
| Any loss | Balanced MSE-style reweighting (p_balanced / p_train) | Loss-agnostic inverse-density sample weighting |
| Any loss | Label-distribution-aware data augmentation (SMOGN, LDAS) | Augments sparse regions directly |

For tabular FMs reconstructing heterogeneous features, the imbalanced target problem is **per-feature**: each feature has its own skewness. A universal fix (e.g., global sample reweighting) is insufficient — feature-level rebalancing or per-feature adaptive bins are needed.

---

## Loss Aggregation: Focal Weighting, Tilted Risk, and Curriculum

**How you aggregate per-sample losses matters as much as the per-sample loss itself.** Loss aggregation strategies are orthogonal to and composable with any loss in the hierarchy.

### Focal weighting
Focal loss (Lin et al., ICCV 2017) downweights easy examples and upweights hard ones: L_focal = (1 - p_t)^γ · L_base. Originally for classification, **Focal Regression (FocalR)** extends this to continuous targets: "a family of loss functions that dynamically adjusts weightings based on sample difficulty, emphasizing hard and informative examples" (EmergentMind topic summary). Composable with any base loss.

### Tilted Empirical Risk Minimization (TERM)
Li et al. (ICLR 2021, arXiv:2007.01162): "We show that tilted empirical risk minimization (TERM) can be used for enforcing fairness between subgroups, mitigating the effect of outliers, and handling class imbalance, all in a unified framework."

```
L_TERM(t) = (1/t) · log( (1/n) · Σ exp(t · l_i) )
```
- t → 0: standard ERM (arithmetic mean)
- t > 0: emphasizes worst-case samples (like focal loss / minimax)
- t < 0: suppresses outlier influence (like Huber, but on the aggregation level)

TERM generalizes both focal loss and robust aggregation with a single continuous parameter. It operates on the **aggregation** of per-sample losses, not the per-sample loss computation itself, so it composes cleanly with any loss function.

### Curriculum and staged loss schedules
For tabular FM pre-training, staged schedules may help:
- Start with MSE/Huber (fast convergence, simple gradients) → switch to CE-on-bins or CRPS (richer representations, calibrated uncertainty) after the model has rough estimates. This also mitigates the [initialization overhead](#initialization-and-warmup-overhead) of distributional losses.
- Anneal bin count (coarse → fine) during training: coarse bins for fast early learning, fine bins for precision in later stages. IEBins (arXiv:2309.14137) provides a principled framework for this coarse-to-fine approach.
- Anneal σ in HL-Gauss: larger σ (more smoothing) early → smaller σ (sharper targets) later.

None of these are validated for tabular FMs specifically, but all have precedent in vision (depth estimation, detection) and RL.

### Connection to imbalanced targets
Focal weighting and TERM directly address imbalanced regression: focal upweights hard (tail) samples, TERM with t > 0 emphasizes worst-case subgroups. These compose with the per-feature mitigations in the [Imbalanced Targets](#imbalanced-and-long-tailed-targets) section above.

---

## Target Preprocessing: The Elephant in the Room

The choice of **target transform** interacts with the loss function at least as strongly as the loss function choice itself. Much of what robust or distributional losses achieve can be approximated — or amplified — by transforming targets before applying any loss.

### Key transforms

**Rank / quantile normalization.** Maps targets to a uniform distribution on [0,1] by replacing each value with its rank divided by N. After quantile normalization:
- All features have identical scale and distribution shape (uniform)
- MSE on quantile-normalized targets is *implicitly* training the model to predict the CDF — it's doing what CRPS does explicitly, without the CRPS machinery
- Outlier influence is eliminated (ranks are bounded) — achieving Huber-like robustness without a δ parameter
- Bin ranges for HL-Gauss become trivial: [0, 1] for all features, uniform spacing

**Box-Cox / Yeo-Johnson transforms.** Parametric power transforms that make targets more Gaussian.

> "The Box-Cox and Yeo-Johnson transformations are well-known tools for this. However, the standard maximum likelihood estimator of their transformation parameter is highly sensitive to outliers, and will often try to move outliers inward at the expense of the normality of the central part of the data." — [Springer, 2021](https://link.springer.com/article/10.1007/s10994-021-05960-5)

After a well-chosen power transform, MSE and Gaussian NLL become *appropriate* — the Gaussian assumption holds approximately. A well-chosen transform + MSE can outperform raw targets + HL-Gauss when the latter is poorly configured (wrong bin range, wrong σ).

**Log transform for positive/multiplicative data.** Revenue, durations, counts — many tabular targets are positive and right-skewed. Log-transforming before loss computation changes the implicit loss from L2-on-originals to L2-on-log-scale, which optimizes for the *geometric mean* rather than the arithmetic mean.

> "The critical insight: back-transformed estimates are NOT the same as estimates on the original scale." — [statstest.com](https://www.statstest.com/transformations-log-sqrt-box-cox-help-mislead)

This means the choice of transform implicitly changes what the model optimizes for — it's not just a preprocessing step, it's a loss function modification in disguise.

### The interaction matrix

The practical design space is not a 1D hierarchy of losses — it's a multi-dimensional space:

```
{target transform} × {loss function} × {optimizer} × {aggregation strategy}
    ↑                     ↑                 ↑              ↑
    raw / quantile /      MSE / CE /        SGD / Adam /   mean / focal /
    log / Box-Cox         CRPS / IQN        AdamW          TERM / curriculum
```

Interaction effects:
- **Quantile-normalized targets + uniform bins = approximately optimal** for HL-Gauss (uniform distribution → uniform bin utilization → no resolution waste)
- **Quantile-normalized targets + MSE ≈ implicit CRPS training** (MSE on CDF values)
- **Log-transformed targets + MSE = robust to right-skewed outliers** without needing Huber or distributional losses
- **Raw targets + HL-Gauss = requires careful bin range and σ tuning** per feature

For tabular FMs with heterogeneous features, the strongest practical pattern is: **per-feature quantile normalization as standard preprocessing, then ablate loss functions on the normalized scale.** This decouples the distribution-shape problem (handled by the transform) from the gradient-geometry problem (handled by the loss).

---

## Semicontinuous and Zero-Inflated Targets (Tweedie)

Many real tabular regression targets are **semicontinuous**: a point mass at zero plus a continuous positive distribution. Insurance claims, ad click revenue, purchase amounts, time-to-first-event — common in production tabular data.

### The problem
None of the general-purpose losses handle the zero spike natively:
- **MSE/Huber:** The zero spike dominates the loss; the model learns to predict near-zero for everything.
- **HL-Gauss with a bin at zero:** Can place mass on the zero bin, but Gaussian encoding spreads mass to neighboring non-zero bins, blurring the boundary.
- **CRPS-on-bins:** Better — the CDF step at zero is sharp — but still relies on binning to approximate the point mass.
- **IQN/Quantile:** Quantiles near τ=0 can capture the spike, but the zero-to-positive transition is discontinuous.

### The Tweedie family

> "The Tweedie exponential dispersion family is a popular choice to model insurance losses that consist of zero-inflated semi continuous data." — [arXiv:2410.01008v5](https://arxiv.org/html/2410.01008v5)

Tweedie distributions parameterize the zero probability and positive-value distribution jointly through a power parameter p ∈ (1,2):
- p = 1: Poisson (pure counts)
- 1 < p < 2: compound Poisson-gamma (zero-inflated continuous)
- p = 2: Gamma (strictly positive)

LightGBM and XGBoost both support Tweedie loss natively. For deep learning: Tweedie NLL is differentiable and can serve as a drop-in replacement for MSE/Huber on semicontinuous features.

### Practical implication for tabular FMs
For tabular FMs reconstructing heterogeneous features, some features will be semicontinuous. A universal loss (CE-on-bins, CRPS) applied after quantile normalization partially handles this (the quantile transform maps the zero spike to a plateau in rank space). But if zero-inflation is severe (>50% zeros), a **per-feature loss routing** strategy may help: Tweedie NLL or hurdle model for semicontinuous features, CE/CRPS for continuous features, CE for categorical features.

---

## Censored and Truncated Targets

Tabular regression targets are frequently **censored** (e.g., "at least 30 days" for time-to-event, "above $10,000" for capped values) or **truncated** (e.g., only customers who purchased are observed). This is distinct from semicontinuous/Tweedie (zero-inflation) and from distribution shift.

### The problem
None of the losses in the hierarchy handle censoring natively. With right-censored observations (the true value is ≥ the observed value), standard losses treat the censored value as the truth, systematically biasing predictions downward.

### Approaches
- **Survival analysis losses**: Cox partial likelihood, parametric AFT (Accelerated Failure Time) losses, and DRSA (Deep Recurrent Survival Analysis) handle censoring by design.
- **CE-on-bins with censoring-aware encoding**: spread the target mass uniformly (or according to a survival function) above the censoring threshold instead of placing it at a single value. This is a natural extension of the HL-Gauss encoding but requires custom implementation.
- **CRPS with censored observations**: the survival analysis community has developed censored CRPS variants that account for right-censoring in the scoring rule itself.
- **Quantile regression**: inherently handles censoring at specific quantile levels — for right-censored data at value c, any quantile τ such that Q(τ) < c is still observed and informative.

### Practical implication for tabular FMs
If reconstruction targets include censored features (common in healthcare, finance, insurance), per-feature loss routing is needed: survival losses for censored features, standard distributional losses for uncensored features. Quantile regression / IQN offers partial censoring robustness without special-casing.

---

## Asymmetric Losses and Decision-Theoretic Framing

Every loss in the hierarchy is symmetric — overestimation and underestimation incur equal cost. This assumption is rarely correct in practice.

### The asymmetry problem

> "The default loss function used in most analyses is squared error loss. This assumes equal loss for the same size of overestimation and underestimation. The need for asymmetric loss arises because the aforementioned costs could be uneven." — [arXiv:2410.09673](https://arxiv.org/html/2410.09673v1) (2025)

Examples: revenue forecasting (underestimation → missed targets), inventory (underestimation → lost sales, often 3-10× more costly than excess stock), insurance claims (underestimation → reserve shortfall), predictive maintenance (overestimation of RUL → unexpected failure).

### Connections to losses in the hierarchy

**Quantile regression already supports asymmetry.** The pinball loss L_τ(e) = τ·max(e,0) + (1-τ)·max(-e,0) is inherently asymmetric: τ > 0.5 penalizes underestimation more, τ < 0.5 penalizes overestimation more. At τ = 0.5, it reduces to symmetric MAE.

**Distributional outputs enable asymmetric *inference-time* decisions without retraining.** This is a major practical advantage of distributional losses (HL-Gauss, CRPS-on-bins, IQN) that the hierarchy table alone doesn't capture. Once the model outputs a predicted distribution:
- Extract Q(0.9) for conservative predictions (penalize underestimation)
- Extract Q(0.1) for aggressive predictions (penalize overestimation)
- Compute the cost-weighted optimal action by integrating over the predicted distribution with the decision cost function

No retraining needed — the same pre-trained model serves different downstream decision costs by varying the extraction quantile. This decoupling of *distributional learning* (training) from *decision-making* (inference) is arguably the strongest practical argument for distributional losses over point-prediction losses.

**Weighted CRPS (wCRPS) for tail-sensitive training.** ScoringBench includes wCRPS, which weights different quantile regions during training. This enables asymmetric *training* when the downstream decision cost is known in advance.

### Decision-theoretic framing
The deeper point: the "right" loss function depends on the downstream *decision*, not just statistical properties of the prediction. The hierarchy in this note operates at the statistical level. For production tabular FMs that serve specific business applications, the decision-theoretic level — what actions will be taken based on predictions, and what are the costs of errors — should drive the final loss function choice or, better, the choice of which quantile/moment to extract from a distributional prediction.

---

## Input Tokenization × Output Loss Interaction

Bins for *output* losses and numerical feature *input* tokenization are deeply related design choices.

Gorishniy et al. ("On Embeddings for Numerical Features in Tabular Deep Learning," arXiv:2203.05556, NeurIPS 2022) show that piecewise-linear embeddings for input features dramatically improve tabular deep learning. "Enhancing Deep Tabular Models with GBDT-Guided Piecewise-Linear Embeddings" (OpenReview, Feb 2026) extends this:

> "piecewise-linear functions are well suited to modeling the irregular and high-frequency patterns often found in tabular data, provided that breakpoints are carefully chosen."

**The connection:** If inputs are already piecewise-linear-embedded (discretized into learned bins on the input side), the model is "thinking discretely" about numbers from the start. Matching this with a discretized output (HL-Gauss, CRPS-on-bins) creates **input-output discretization symmetry** — discrete in, discrete out — that may improve optimization because the model's internal representation doesn't need to bridge a discrete-to-continuous asymmetry.

TabPFN and FEAT both use feature tokenization on the input side. When those architectures also use discretized output losses (as TabPFN does with bins + CE), there is an implicit architectural coherence. This input-output discretization interaction is an unexplored design dimension.

**Practical implication:** When the input tokenization scheme is fixed, the output loss choice should consider the input representation. Discretized inputs → discretized outputs = natural match. Raw scalars / continuous embeddings → continuous outputs (MSE, IQN) may be more appropriate.

---

## Choosing Between Loss Functions for Tabular FMs

The right loss depends on the objective:

| Priority | Best loss | Why |
|---|---|---|
| Point accuracy (RMSE) | HL-Gauss CE or CRPS-on-bins | Bounded gradients, rich representations |
| Point accuracy (MAE) | IQN/NQ (median via Q(0.5)) or CE-on-bins | CE dynamics align with MAE; IQN outputs median directly |
| Calibrated uncertainty | CRPS-on-bins or IQN/NQ + conformal | Proper scoring + distribution-free coverage |
| Representation quality | HL-Gauss CE | Empirically demonstrated richer features (RL domain; tabular FM evidence pending) |
| Balanced gradients across features | HL-Gauss CE (≈ log score) | Approximately locally scale invariant for uniform bins; CRPS over-weights high-uncertainty features |
| Unimodal guarantee | Monotonic CDF + CRPS, or NQ-networks | Architectural monotonicity eliminates spurious multimodality |
| Latent geometry preservation | MSE / Gaussian NLL | Geometric alignment tax (arXiv:2604.04155) |
| Extrapolation / unbounded targets | IQN/NQ-Network or MSE/Huber | No bounded range constraint; IQN adds distributional output |
| Multi-modal conditionals | MDN (intentional) or HL-Gauss CE | MDN: interpretable per-mode predictions; bins: arbitrary shapes but mean-of-multimodal pathology |
| Multivariate joint calibration | Energy Score | Proper scoring for multi-output predictions |
| Imbalanced / long-tailed targets | IQN/Quantile + wCRPS; focal aggregation | Quantile methods weight tails equally; focal upweights hard samples |
| Asymmetric decision costs | Quantile regression (τ ≠ 0.5) or distributional + quantile extraction | Distributional outputs enable inference-time asymmetry without retraining |
| Semicontinuous / zero-inflated | Tweedie NLL or hurdle model | Native zero-spike handling |
| Censored / truncated | Survival losses or censoring-aware CRPS | Native censoring handling |
| Epistemic uncertainty (OOD) | Evidential (NIG) or ensemble | Single-pass epistemic signal; ensemble is gold standard |

### Decision flowchart

For practitioners facing the loss function choice:

```
1. Are targets censored/truncated?
   → Yes: Survival losses (Cox, AFT) or censoring-aware CRPS for those features
   → No: continue

2. Are targets semicontinuous (zero-inflated, >50% zeros)?
   → Yes: Tweedie or hurdle model for those features
   → No: continue

3. Apply per-feature quantile normalization. Now:

4. Is extrapolation beyond training range required at deployment?
   → Yes: IQN/NQ-network (unbounded) or MSE/Huber as fallback
   → No: bins are safe, continue

5. Do specific features have genuinely multimodal conditionals?
   → Yes, and interpretability matters: MDN heads for those features
   → Yes, don't care about interpretability: unconstrained softmax (HL-Gauss)
   → No/unknown: monotonic CDF + CRPS (unimodal by construction)

6. Is latent geometry preservation critical (transfer learning, anomaly detection)?
   → Yes: MSE/Gaussian NLL — geometric alignment tax is a concern
   → No: continue

7. Default: ablate across five families:
   a. HL-Gauss CE — best optimization dynamics, ~locally scale invariant
   b. CRPS-on-softmax-bins — proper, ordinal-aware, no σ parameter
   c. Monotonic CDF + CRPS — proper, ordinal-aware, unimodal by construction
   d. NQ-network/IQN-style — unbounded, continuous, no bins
   e. (Optional) MDN heads for features flagged in step 5

8. Post-hoc: apply conformal calibration regardless of training loss
```

### The strongest practical recommendation

**Ablate across five families on the same architecture:**
1. **HL-Gauss CE** — best-established gradient geometry, second-order curvature, representation evidence. Approximately locally scale invariant for uniform bins (balanced gradients across features). Training dynamics align with MAE, not MSE (arXiv:2510.00885).
2. **CRPS-on-bins (softmax)** — theoretically principled, ordinal-aware, one fewer hyperparameter (σ). Not locally scale invariant — high-uncertainty features dominate. Representation learning advantage vs CE untested.
3. **Monotonic CDF + CRPS** — same bin architecture as #2 but with architectural monotonicity → unimodal by construction. Proper, ordinal-aware, no σ parameter, no spurious multimodality.
4. **NQ-network/IQN-style continuous quantile** — unbounded, continuous, no bins. Closest to TabICLv2's winning approach. Requires architectural changes (τ-embedding fusion).
5. **(For multimodal features) MDN heads** — interpretable per-mode predictions, single-pass inference. Natural gradient EM (arXiv:2602.10602) addresses mode collapse.

CE, CRPS-on-softmax, and monotonic CDF + CRPS share the same m-dimensional output architecture and differ in activation function and loss computation. NQ-networks require a different output architecture. MDN heads are a third architecture. This means families 1-3 can be ablated by changing only the loss function code — zero architectural changes.

**Critical preprocessing step:** Apply per-feature quantile normalization *before* loss function ablation. This decouples the distribution-shape problem from the gradient-geometry problem.

Apply **conformal calibration post-hoc** regardless of training loss to guarantee coverage.

### Downstream metric alignment: training loss ≠ evaluation metric

The table above optimizes for properties of the *training* loss, but the evaluation metric at test time often differs:

- **RMSE evaluation**: the optimal point prediction is the conditional mean E[y|x]. HL-Gauss CE and CRPS-on-bins produce ŷ = Σ p̂ᵢ · zᵢ (expected value), which targets the mean — seemingly well-aligned. **However**, "Rectifying Regression in Reinforcement Learning" (arXiv:2510.00885, Oct 2025) finds: "different loss functions are better aligned with these different regression objectives: binary and categorical cross-entropy losses with the mean absolute error and squared loss with the mean squared error." CE's bounded, constant-magnitude gradients treat all errors with similar weight regardless of magnitude — the same property that makes MAE robust to outliers. This means CE's representations are shaped by MAE-like dynamics during training, even though the inference-time formula computes a mean. The mismatch appears tolerable in practice (TabICLv2 trains with quantile/CRPS-adjacent loss but evaluates on RMSE and wins), but is a subtle misalignment.

- **MAE evaluation**: the optimal point prediction is the conditional median. CE-on-bins is *naturally aligned* with MAE through its gradient dynamics. IQN/NQ-networks output the median directly via Q(0.5). For skewed distributions, extracting the predicted distribution's median (CDF crossing 0.5) is more appropriate than the expected value formula.

- **Quantile-based evaluation** (prediction intervals at 90% coverage): rewards calibrated tails. CRPS and quantile losses directly optimize this; CE-on-bins does not.

Landsgesell & Knoll (arXiv:2603.08206v4) demonstrate empirically: "different proper scoring rules induce different model rankings and different inductive biases during training, even though each rule is individually minimized by the true distribution." Which loss produces the best representations for downstream fine-tuning on a specific metric is an **empirical question** that theoretical analysis cannot fully answer.

---

## Application to FEAT and Tabular Foundation Models

### What FEAT currently does
- Classification head: cross-entropy (already categorical — fine)
- Regression head: Huber loss on scalar output (Eq. 18, 22)
- Feature reconstruction: Huber loss on scalar output (Eq. 19, 22)

### What should change
Replace regression and reconstruction heads with distributional output. The architectural change is surgical regardless of which loss is used:

```python
# Current: scalar output + Huber
ŷ = W2(GELU(LayerNorm(W1 · z)))    # 1-dim
loss = huber(ŷ, y)

# Option A: HL-Gauss CE
logits = W2(GELU(LayerNorm(W1 · z)))  # m-dim (one per bin)
p̂ = softmax(logits)
p_target = hl_gauss(y, bins, σ)
loss = cross_entropy(p̂, p_target)

# Option B: CRPS-on-bins (no σ needed)
logits = W2(GELU(LayerNorm(W1 · z)))  # m-dim
p̂ = softmax(logits)
F_hat = cumsum(p̂)                     # predicted CDF
loss = crps(F_hat, y, bins)            # squared CDF difference

# Option C: Monotonic CDF + CRPS (unimodal by construction)
logits = W2(GELU(LayerNorm(W1 · z)))  # m-dim
F_hat = cumulative_sigmoid(logits)     # monotonic CDF directly
loss = crps(F_hat, y, bins)

# Option D: NQ-Network / IQN-style (no bins needed)
τ = uniform(0, 1, K)                   # sample K quantile levels
Q_hat = nq_network(z, τ)               # monotonic quantile function
loss = pinball(Q_hat, y, τ)            # quantile Huber loss

ŷ = Σ p̂ᵢ · zᵢ                       # Options A/B/C: expected value
ŷ = Q_hat(0.5)                         # Option D: median
```

### Multi-task loss balancing: the hidden integration challenge

FEAT's total loss (Eq. 22) is a weighted combination of classification loss, regression loss, and reconstruction loss. Substituting Huber with a distributional loss changes the **gradient magnitude and dimensionality** of two of three loss terms:
- Huber regression head: scalar gradient, magnitude bounded by δ
- CE-on-bins regression head: m-dimensional gradient, each component in [-1, 1]
- CRPS-on-bins regression head: m-dimensional gradient via CDF, different scale from CE

Naïvely swapping losses while keeping the same λ weights will almost certainly degrade performance initially. The gradient scale mismatch between a 101-dimensional CE reconstruction loss and a scalar classification loss requires explicit rebalancing.

Relevant approaches:
- **Uncertainty-based weighting** (Kendall et al., CVPR 2018): learn a homoscedastic task uncertainty σ_task per loss term. L_total = (1/2σ²_cls) · L_cls + (1/2σ²_reg) · L_reg + (1/2σ²_recon) · L_recon + log(σ_cls · σ_reg · σ_recon).
- **GradNorm** (Chen et al., ICML 2018): dynamically balance gradient norms across tasks during training.
- **Manual rescaling**: scale each distributional loss by 1/m to match Huber's per-sample gradient magnitude as a starting point.

The practical engineering challenge is not implementing `crps(F_hat, y, bins)` — it's balancing a 101-dimensional CE reconstruction loss across N heterogeneous features against a scalar classification loss. This deserves as much ablation attention as the choice of loss function itself.

### Design decisions for tabular FMs
- **Bin range**: normalize features first (rank/quantile transform), then bin [-3, 3] or [-5, 5]. **Critical constraint**: predictions are hard-bounded to [z_min, z_max]. Cannot extrapolate.
- **Uniform vs. non-uniform bins**: uniform spacing is the default. Quantile-based bins concentrate resolution where data is dense but become stale under distribution shift (see [distribution shift](#loss-behavior-under-distribution-shift)).
- **Number of bins**: 101 is safe default (~0.06 bin width after normalization). Paper shows robustness across 21-201.
- **σ/ς ratio**: 0.75 (paper's recommendation, spreads mass over ~6 bins). Also functions as a calibration temperature and implicit label noise model — see [σ-temperature-noise connection](#the-σ-temperature-noise-connection) above.
- **Per-feature configuration**: features in tabular data are wildly heterogeneous. A single bin configuration for all features after shared normalization is the pragmatic starting point; per-feature adaptive configuration is a refinement. IQN/NQ-networks sidestep this entirely (no bins).
- **Input-output discretization coherence**: FEAT uses feature tokenization on the input side. Matching this with discretized outputs creates architectural symmetry — see [Input Tokenization × Output Loss](#input-tokenization-×-output-loss-interaction).
- **Computational budget**: upgrading N=200 features from scalar to m=101 bins multiplies the output head by 101×. Budget for memory, batch size reduction, and longer training — see [limitation #5](#limitations-of-discretized-ce).

### Why this could narrow FEAT's accuracy gap
FEAT currently falls 2-5% below SOTA (TabPFN 2.5, TabICL v2) on most benchmarks. The accuracy gap exists specifically in regression tasks where Huber is used. Switching to a distributional output head is the lowest-cost, highest-confidence improvement available.

**Important context — SOTA tabular FMs are split on the loss function:**
- **TabPFN v2/2.5** uses discretized distributional regression (bins + cross-entropy). From PriorLabs docs: "Instead of a single point estimate, the regressor predicts an output distribution."
- **TabICLv2** (arXiv:2602.11139, Feb 2026) explicitly chose quantile regression over bins: "In preliminary experiments using RMSE evaluation, we found that quantile regression outperforms MSE and the bin-based approach of TabPFNv2." It predicts 999 quantiles with pinball loss.
- **Landsgesell & Knoll** (arXiv:2603.08206v4, Feb 2026) show fine-tuning TabPFN-2.5 with CRPS yields consistent improvements.
- **TabPFN v2 in open environments** shows limitations: "Empirical results demonstrate that TabPFN v2 shows significant limitations in open environments but is suitable for small-scale, covariate-shifted, and class-balanced tasks" (arXiv:2505.16226). This reinforces the distribution shift concern for all bin-based approaches.

**Caveat for reconstruction heads**: the geometric alignment tax (arXiv:2604.04155) suggests that discretized CE may *hurt* feature reconstruction quality by distorting latent geometry. The regression prediction head is a clearer win; the reconstruction head deserves separate ablation.

### Discretized distributional losses vs. flows, diffusion, and IQN for tabular FMs
Discretized approaches (CE-on-bins or CRPS-on-bins) are the pragmatic winners for serving:
- No invertibility constraints on architecture
- No Jacobian computation
- Training is standard (well-understood optimization)
- Can represent multi-modal outputs
- Single-pass inference for point prediction

Flows and diffusion are still superior when you need exact density evaluation (anomaly detection, Bayesian inference) or unbounded support with full generative sampling. Diffusion avoids flows' invertibility constraints but requires multi-step inference (50-1000× slower).

**IQN/NQ-networks are the strongest alternative to discretized approaches**: unbounded support, continuous non-parametric output, proper scoring via quantile Huber loss, no bin hyperparameters. The tradeoff is: (a) less established representation learning evidence vs. CE, (b) extracting full distributional shape requires multiple τ queries, (c) multi-output scaling for reconstruction, and (d) no tabular FM has yet used IQN as its pre-training loss (TabICLv2's 999-quantile pinball is the closest precedent).

---

## Meta-Insight

The hierarchy of losses is really a hierarchy of **what the model is forced to learn about the target distribution**:

```
MSE:              "learn the mean"
Huber:            "learn the mean, but don't freak out about outliers"
Gaussian NLL:     "learn the mean AND the spread"
Student-t NLL:    "learn the mean, spread, AND tail behavior"
Tweedie NLL:      "learn the mean, handling the zero spike natively"
Evidential (NIG): "learn the mean, spread, AND how much evidence I have" (epistemic)
Quantile:         "learn arbitrary percentiles of the shape" (proper scoring)
IQN/NQ-Network:   "learn the entire quantile function continuously" (proper, unbounded)
MDN:              "learn an interpretable mixture of Gaussians" (intentional multimodality)
Monotonic CDF:    "learn the entire shape, unimodal by construction" (proper, ordinal-aware)
Discretized CE:   "learn the entire shape" (bounded gradients, ordinal target encoding)
CRPS-on-bins:     "learn the entire shape" (bounded gradients, ordinal-aware loss)
Diffusion:        "learn the entire shape generatively" (multi-step inference)
Flow:             "learn the entire shape with exact density"
```

Each step forces richer internal representations. The "Stop Regressing" paper's key contribution is showing that discretized approaches have almost zero additional cost but dramatically better optimization properties than continuous alternatives. The gradient geometry — bounded, **informative** (~6-10 effective dimensions of gradient signal per sample, not just magnitude control), with **implicit second-order curvature** (Fisher information matrix as Hessian, enabling natural-gradient-like updates) — is well matched to how neural networks learn with Adam-family optimizers.

But loss function choice does not exist in a vacuum. The effective design space is:

```
{target transform} × {loss function} × {optimizer} × {aggregation strategy}
```

...where interactions between dimensions matter as much as individual choices. Target preprocessing (quantile normalization, log/Box-Cox transforms) can simplify the loss function's job dramatically; optimizer choice (Adam vs SGD) interacts synergistically with bounded vs unbounded gradients; aggregation (focal, TERM, curriculum) addresses imbalanced and heterogeneous data.

The nuances that matter for choosing within this space:

- **Discretized CE** wins on optimization dynamics (bounded gradients + implicit second-order curvature + stable Adam interaction) and representation richness (empirically demonstrated in RL; tabular FM evidence pending). Its ordinal structure comes from the Gaussian target encoding, not the CE loss itself (which is ordinal-blind). Approximately locally scale invariant for uniform bins — balanced gradients across heterogeneous features. Mode-covering via D_KL(target ‖ predicted). σ doubles as a calibration temperature and implicit label noise model. Training dynamics align with MAE, not MSE (arXiv:2510.00885). Effective gradient dimensionality is ~6-10 per sample, not the full m — still rich but more modest than the "m-dimensional gradient" framing suggests.
- **CRPS-on-bins** wins on theoretical properness, ordinal awareness (inherent in the CDF-based formulation), and has one fewer hyperparameter (σ). Adopted by TabICLv2 (via pinball/quantile, the per-quantile decomposition of CRPS). Connected to Cramér distance (squared CDF), which has proven gradient advantages over Wasserstein-1 (Rowland et al., 2018). **Not locally scale invariant** — high-uncertainty features dominate the loss, creating gradient imbalance across heterogeneous features (Bolin & Wallin, arXiv:1912.05642). Representation learning advantage vs CE is an open question.
- **Monotonic CDF + CRPS** combines the properness and ordinal awareness of CRPS with architectural unimodality guarantee. Same bin architecture as CRPS-on-softmax — only the activation changes. The cleanest formulation for unimodal regression, but cannot represent multimodal conditionals.
- **CRLS-on-bins** offers properness + ordinal awareness + local scale invariance. Included in ScoringBench (arXiv:2603.29928) as an *evaluation* metric. **Caution:** no published study has trained a neural network with CRLS at scale. Numerical issues (log of near-zero bin probabilities) are a practical barrier. Theoretically appealing but empirically unvalidated for training.
- **IQN/NQ-networks** win on unbounded support, continuous non-parametric output, and zero bin hyperparameters. The only approach that is simultaneously unbounded, non-parametric, proper-scoring, and single-network — though practical engineering costs (architecture changes, multi-output scaling) have prevented tabular FM adoption. TabICLv2's 999-quantile pinball loss is the closest empirical validation. Representation quality vs CE is untested.
- **MDNs** win on intentional, interpretable multimodality with single-pass inference. Recent natural gradient EM training (arXiv:2602.10602) addresses the classic mode collapse failure. Best suited for features with genuinely multimodal conditionals. Unique advantage: per-mode point predictions, avoiding the mean-of-multimodal pathology.
- **Continuous losses** (MSE, NLL) win on latent geometry preservation (geometric alignment tax) and unbounded extrapolation. Under distribution shift, they degrade gracefully rather than silently clamping at bin boundaries.
- **Evidential (NIG)** uniquely separates aleatoric from epistemic uncertainty in a single pass, but has calibration concerns (Bengs et al., AISTATS 2023) and no tabular FM validation.
- **Conformal prediction** provides distribution-free calibration guarantees post-hoc, decoupling training loss choice from coverage requirements. But guarantees are marginal, not conditional, and vacuous under distribution shift.

Cross-cutting concerns that interact with every loss choice: **target preprocessing** (quantile normalization can make simple losses competitive with complex ones), **loss × optimizer interaction** (CE's bounded gradients + Adam = stable effective learning rates at scale), **label noise** (σ acts as implicit noise model for HL-Gauss; mismatch between σ and true noise causes over/underfitting), **imbalanced/long-tailed targets** (inverse-density weighting, weighted CRPS, quantile oversampling), **loss aggregation** (focal weighting, tilted risk, curriculum schedules), **multi-task balancing** (gradient scale mismatch when combining distributional and scalar losses), **downstream metric alignment** (CE dynamics align with MAE; MSE dynamics align with RMSE), **asymmetric decision costs** (distributional outputs enable inference-time cost-aware decisions without retraining), **semicontinuous data** (Tweedie for zero-inflated features), **censored/truncated data** (survival losses or censoring-aware CRPS), **input-output discretization coherence** (matching input tokenization with output representation), **distribution shift robustness** (bounded-range losses fail silently on OOD data; bin placement becomes stale under non-stationarity), **initialization overhead** (distributional losses require warmup from uniform softmax; warm-starting from scalar heads is non-trivial), and **computational cost** (m=101 bins × N features = significant memory and compute scaling for reconstruction heads).

The right loss depends on what you're optimizing for: point accuracy, calibrated uncertainty, representation quality, joint multivariate calibration, extrapolation capability, or downstream decision cost. For tabular FMs, the strongest evidence points to **ablating across five families** — CE-on-bins, CRPS-on-softmax-bins, monotonic CDF + CRPS, NQ-network/IQN-style continuous quantile, and MDN heads for multimodal features — after per-feature quantile normalization, rather than treating any single approach as the settled answer. Apply conformal calibration post-hoc regardless.
