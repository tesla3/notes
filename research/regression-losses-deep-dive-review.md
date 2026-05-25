# Review Log: Regression Losses Deep Dive

Tracks review rounds and changes made to `regression-losses-deep-dive.md`.

---

## Review Round 1 (2026-04-10, self-review)

Identified 10 gaps. All integrated into main document during initial drafting.

| Gap | Status |
|---|---|
| CRPS scale invariance limitation + CRLS | Integrated |
| Loss × optimizer interaction | Integrated |
| Target preprocessing as complement | Integrated |
| CE aligns with MAE, not MSE | Integrated |
| MDN analysis | Integrated |
| Asymmetric losses / decision theory | Integrated |
| Semicontinuous / zero-inflated (Tweedie) | Integrated |
| Input tokenization × output loss | Integrated |
| Distribution shift robustness | Integrated |
| Second-order curvature properties | Integrated |

---

## Review Round 2 (2026-04-11, external critical review)

Identified 10 additional gaps, 3 factual corrections/overstatements, and structural improvements.

### New gaps integrated into v2

| Gap | What changed |
|---|---|
| A. Effective gradient dimensionality ~6-10, not m | Qualified mechanism #1: "~6-10 effective dimensions" with explanation of softmax saturation |
| B. Mean-of-multimodal pathology at inference time | New subsection under HL-Gauss. Connected to MDN advantage (per-mode predictions) |
| C. Direct CDF regression (monotonic CRPS) | New section: "Direct CDF Regression + Monotonic CRPS: The Missing Formulation." Added as 5th ablation family |
| D. Label noise × σ interaction | Integrated into "σ-temperature-noise connection" subsection under HL-Gauss |
| E. Initialization and warmup dynamics | New limitation #10 under HL-Gauss. Connected to curriculum learning section |
| F. Computational cost understated | Expanded limitation #5 with concrete N=200, m=101 analysis (20,200 output dims, memory impact, batch size reduction) |
| G. IEBins (Iterative Elastic Bins) missing | Added to limitation #4 adaptive bins list. Connected to curriculum/coarse-to-fine |
| H. Non-stationarity / bin staleness | Integrated into distribution shift section + quantile-bin caveat |
| I. Proper scoring rule nuance muddled | New subsection "Proper scoring rule nuance" under CRPS section — 4 clarifying points |
| J. Censored/truncated data | New section: "Censored and Truncated Targets" |

### Factual corrections

| Issue | What changed |
|---|---|
| "m-dimensional gradient per sample" overstatement | Qualified to "~6-10 effective dimensions" throughout |
| CRLS recommendation premature | Added "Practical caution" paragraph: no study has trained with CRLS at scale, numerical issues with log of near-zero bin probabilities. Downgraded from 4th ablation family to noted alternative |
| CE "locally scale invariant" conflates continuous log score with discretized version | Changed to "approximately locally scale invariant for uniform bins" throughout. Added Dawid & Musio citation on continuous log score. Noted approximation breaks for non-uniform bins |

### Structural improvements

- Added **decision flowchart** (8-step conditional routing) to "Choosing Between Loss Functions"
- Expanded hierarchy table with "Monotonic CDF + CRPS" row
- Updated ablation recommendation from 4 families to 5 (adding monotonic CDF + CRPS)
- Added copula-based approaches to multivariate section
- Connected IEBins to curriculum learning for coarse-to-fine bin refinement
- Added TabPFN v2 open-environment limitations citation (arXiv:2505.16226)

### Document metrics

| Metric | v1 | v2 |
|---|---|---|
| Lines | 933 | 1064 |
| Major sections (##) | 19 | 22 |
| New sections | — | Direct CDF Regression, Censored/Truncated Targets, Decision Flowchart |
| Loss families recommended | 4 | 5 |
