# Critical Review: TabICLv2 vs TabPFN-2.5 — The Tabular Foundation Model Race

Source: [TabICLv2](https://arxiv.org/html/2602.11139v1) (Feb 2026, INRIA/Soda), [TabPFN-2.5](https://arxiv.org/html/2511.08667v2) (Nov 2025, Prior Labs)
Date: 2026-03-06

---

## What These Papers Are

Both papers advance **tabular foundation models (TFMs)** — transformers pretrained on synthetic tabular data that perform classification/regression via in-context learning (ICL) in a single forward pass. No gradient updates at inference. The paradigm: learn a Bayesian-like inference algorithm during pretraining, then apply it to any new dataset at test time.

TabPFN-2.5 is the commercial incumbent (Prior Labs, the original TabPFN team). TabICLv2 is the open-source challenger from INRIA's Soda team, building on their earlier TabICL.

---

## TabICLv2 — The Open Challenger

### Architecture: Compression-Then-ICL with Smart Tweaks

TabICLv2 retains the three-stage pipeline from TabICL: column-wise embedding → row-wise compression → dataset-wise ICL. This gives **O(n² + nm²)** complexity vs TabPFN's O(n²m + nm²) — a meaningful advantage because m (features) is typically much smaller than n (samples), so the n²m term in TabPFN is the expensive one.

**Key innovations:**

1. **Repeated feature grouping.** Each feature appears in multiple groups via circular shifts (offsets 0, 1, 3 mod m). Breaks representation collapse from features with similar distributions, without losing per-feature granularity. Clever — it's essentially a structured data augmentation at the embedding level. The (0,1,3) shift ensures no pair appears together twice for m ≥ 7, borrowing from combinatorial design theory. Elegant, but the ablation shows it provides only a modest improvement — one of the smaller contributors.

2. **Target-aware embedding.** Injects label information by *adding* target embeddings to all feature tokens for training samples — not appending as an extra column (TabPFNv2's approach). This is the right instinct: early target injection lets the model learn target-conditioned feature representations from the start. The ablation confirms this is one of the top-3 contributors (~100 Elo).

3. **QASSMax (Query-Aware Scalable Softmax).** The standout contribution. Standard softmax attention fades as context length grows — the denominator grows linearly with n, flattening the distribution. SSMax (Nakanishi 2025) counters with s·log(n) scaling. QASSMax extends this with (a) an MLP-based base scaling from log(n) — more expressive than a scalar, and (b) query-dependent gating bounded in (0,2) that modulates per-element. The needle-in-haystack experiment is convincing: QASSMax maintains 100% accuracy and low entropy at 15K negatives where vanilla attention collapses. This is what enables TabICLv2 to generalize to million-scale datasets without retrieval or distillation hacks.

4. **Mixed-radix ensembling for many-class classification.** Decomposes C > 10 classes into balanced mixed-radix digits, runs TF_col once per digit, averages. Handles arbitrary class counts natively without the ECOC wrapper. Slightly worse than ECOC but 3× faster — a good tradeoff.

5. **Quantile regression (999 quantiles with pinball loss).** Instead of MSE or binning, predicts the full quantile function. Smart choice — it naturally gives both point estimates (average the quantiles) and uncertainty quantification. Avoids bin-width sensitivity and is computationally clean. The claim that it outperforms both MSE and binning is backed only by "preliminary experiments" though — no formal ablation is shown.

### Pretraining: Efficient and Principled

- **Muon optimizer** instead of AdamW — one of the top-3 contributors in the ablation (~100 Elo). Interesting signal that optimizer choice matters this much for TFMs.
- **24.5 H100-GPU-days total** — substantially cheaper than TabICL (60 A100-days). Uses fewer datasets (~35M vs 83M) but with smaller batch size (64), so more gradient steps per dataset.
- **Three-stage curriculum** from small to large datasets — standard but effective.

### Synthetic Data Prior: The Real Secret Sauce

The ablation is crystal clear: **the new prior is the single largest contributor to performance**. Pretraining TabICLv2's architecture with TabICL's prior fails — performance degrades in the second half of training. The architecture *requires* the richer prior to generalize. Conversely, TabICL's architecture can't exploit the richer prior. This is the key insight of the paper: **architecture and prior diversity must scale together.**

The prior itself is a directed acyclic graph of random functions (8 types: MLP, tree ensemble, GP, linear, quadratic, EM, discretize, product). Novel additions: random Cauchy graph topology (not just trees), correlated hyperparameter sampling, ExtraTrees-based data filtering. The filtering removes ~35% of classification datasets and ~25% of regression datasets — aggressive but effective.

Critically, the prior development is done *without* experimental feedback — "guided by general design principles" and "maximizing dataset diversity." This is honest and refreshing. Most prior work implicitly overfits priors to validation sets.

### Results

- **SOTA on both TabArena (51 datasets) and TALENT (300 datasets)** without any tuning, surpassing RealTabPFN-2.5 (which is tuned + ensembled + fine-tuned on real data).
- **10.6× faster than TabPFN-2.5 on H100 at 50K samples**, 11.8× on CPU at 10K.
- Handles **1M samples × 500 features in 450 seconds** with <24GB CPU / 50GB GPU via disk offloading.
- Maintains top rankings across all dataset sizes from 10³ to 10⁵.
- Strong on many-class classification (>10 classes).

---

## TabPFN-2.5 — The Commercial Incumbent

### Architecture: Deeper, Wider, But Same Bones

TabPFN-2.5 is fundamentally TabPFNv2 with more depth (18 layers for regression, 24 for classification vs 12), larger feature groups (3 vs 2), and 64 learned "thinking rows" — essentially attention sinks that give the model extra compute budget. The dual row/column attention design is unchanged.

The architectural changes are incremental. The thinking rows are borrowed directly from LLM literature (pause tokens, register tokens). No novel attention mechanisms, no new ways to handle scale. The model scales to 50K rows and 2K features through brute force (deeper network, FlashAttention-3, multi-GPU parallelism) rather than algorithmic efficiency.

### Data and Training

"Improved our prior data generation substantially" — but details are thin. No ablation of prior components. No quantification of what changed. The prior remains closed-source, which is a significant limitation for the field.

**Real-TabPFN-2.5** adds continued pretraining on 43 real-world datasets (deduplicated against benchmarks). This consistently improves performance, especially on classification. But it raises a question: how much of the claimed improvement is from the model vs from seeing real data distributions? The paper doesn't cleanly separate these contributions.

### Hyperparameter Tuning

The "TabPFN-tunes-TabPFN" approach — using TabPFNv2 as a surrogate to optimize TabPFN-2.5's ~50 hyperparameters from ~100 training runs — is cute but the circularity should give pause. If the surrogate is biased, the exploration is biased. With 50 hyperparameters and 100 data points, the surrogate is operating in an extremely underdetermined regime. They acknowledge this but hand-wave it away.

### Distillation Engine

**TabPFN-as-MLP and TabPFN-as-TreeEns** — distilling the foundation model into lightweight dataset-specific models for production. This is commercially clever and practically important. The performance gap is small, and inference latency drops by orders of magnitude. But it's proprietary and not reproducible.

### Causal Inference

TabPFN-2.5 as a T-Learner dominates the RealCause benchmark for CATE estimation. This is genuinely impressive and points to TFMs as a powerful primitive for causal inference. The claim that "improvements in base model predictive performance transfer to causal inference" is well-supported.

### Results

- SOTA on TabArena (up to 100K rows, 2K features) in a forward pass.
- 100% win rate vs default XGBoost on small/medium classification.
- Matches AutoGluon 1.4 (4-hour tuned ensemble) without tuning.
- Strong internal benchmark results (100+ proprietary datasets).

---

## Head-to-Head Comparison

| Dimension | TabICLv2 | TabPFN-2.5 |
|---|---|---|
| **Performance** | SOTA on TabArena + TALENT, beats RealTabPFN-2.5 | SOTA on TabArena at time of publication |
| **Scalability** | 1M samples natively (disk offloading) | 50K recommended, ~160K with hacks |
| **Speed** | 10-12× faster at scale | Slower but improving |
| **Complexity** | O(n² + nm²) | O(n²m + nm²) |
| **Openness** | Fully open (code, weights, prior, pretraining) | Restricted license; prior closed-source |
| **Real data** | Pure synthetic pretraining | Optional real-data fine-tuning |
| **Regression** | 999-quantile regression (principled) | Discretized bins + cross-entropy |
| **Deployment** | Research-focused | Distillation engine for production |
| **Training cost** | ~24.5 H100-days | Not disclosed |
| **Ablations** | Comprehensive, reproducible | Minimal |
| **Causal inference** | Not explored | Strong T-Learner results |

---

## Critical Assessment

### What TabICLv2 Gets Right

1. **Openness is the real contribution.** The prior is open-sourced. The pretraining code will follow. This is transformative for the field — TabPFN's closed prior has been the single biggest obstacle to reproducible research in TFMs. TabICLv2 breaks this barrier.

2. **The ablation study is exemplary.** Every component is cleanly isolated. The architecture × prior interaction finding (each needs the other to work) is a genuine scientific insight, not just an engineering result.

3. **QASSMax is a real contribution** that solves a real problem (attention fading at scale). It's well-motivated theoretically, validated empirically, and applicable beyond tabular models. The needle-in-haystack experiment is clean and convincing.

4. **The efficiency advantage is structural**, not just engineering. O(n² + nm²) vs O(n²m + nm²) means TabICLv2 will always be faster for wide tables with many samples.

### What TabICLv2 Gets Wrong (or Leaves Unaddressed)

1. **No text/semantic features.** Both papers share this limitation, but TabICLv2 doesn't even discuss integration paths. Column names carry information. Ignoring them is leaving performance on the table.

2. **The quantile regression claims are undersupported.** "Preliminary experiments" is not an ablation. For a paper with such thorough ablations elsewhere, this omission is conspicuous.

3. **Missing value handling is naive** (mean imputation). In production tabular data, missingness patterns are often informative. This is acknowledged but not addressed.

4. **No fine-tuning or real-data pretraining explored.** The paper frames this as principled ("out-of-the-box performance"), but Real-TabPFN consistently outperforms pure-synthetic models. Ignoring this avenue is a choice, not a virtue.

### What TabPFN-2.5 Gets Right

1. **Production readiness.** Distillation to MLP/TreeEns, cloud API, multi-GPU support, extensive deployment documentation. This is what makes a model actually useful.

2. **Ecosystem effects.** 400 citations, 2M downloads, 100+ published applications. The paper demonstrates that TabPFN is a genuine platform, not just a benchmark entry.

3. **Causal inference integration** is a compelling direction that validates TFMs as general-purpose statistical primitives.

4. **Real-data fine-tuning** (Real-TabPFN-2.5) is pragmatic and effective. The deduplication against benchmarks is done properly.

### What TabPFN-2.5 Gets Wrong

1. **The closed prior is indefensible at this point.** TabICLv2's ablation proves the prior is the most important component. Keeping it closed while claiming scientific contribution is having it both ways. This is a product report dressed as a research paper.

2. **The architectural innovations are thin.** Deeper network, bigger groups, thinking rows — these are all incremental. No new attention mechanism, no efficiency improvement, no principled scaling strategy. The 50K row limit exists because they haven't solved the attention fading problem.

3. **Ablations are essentially absent.** For a paper claiming SOTA, there's no systematic decomposition of what matters. The hyperparameter tuning section reveals they have ~50 hyperparameters but doesn't tell us which ones matter. Compare this to TabICLv2's Figure 10 and it's night and day.

4. **The license is restrictive.** "Permissive for research" but prohibits commercial use. For a system claiming to be a "foundation model," this limits its actual foundation-model utility. You can evaluate but not deploy without paying.

5. **The paper is partly a sales document.** The ecosystem section (100 use cases, Discord community, PyPI downloads) and the deployment sections read more like a product brief than a research contribution. The internal benchmark on proprietary data cannot be verified.

---

## The Deeper Story

### The Architecture-Prior Coupling is the Key Insight

TabICLv2's most important finding is buried in the ablation: **architecture and prior diversity must co-scale.** TabICLv2's architecture with TabICL's prior fails. TabICL's architecture with TabICLv2's prior merely matches the old baseline. You need *both* the more expressive architecture and the richer prior to get the gains.

This has profound implications. It means you can't just scale one axis. It means prior design is as important as architecture design — arguably more so, since the prior is the larger contributor. And it means the community needs open priors to make progress, which is exactly what TabICLv2 provides and TabPFN-2.5 doesn't.

### The Efficiency vs Scale Tradeoff

TabICLv2's compression-then-ICL approach is fundamentally more efficient than TabPFN's cell-level dual attention. The former compresses features into fixed-dimension row embeddings before doing ICL; the latter maintains per-cell representations throughout. This is why TabICLv2 can handle 1M samples while TabPFN-2.5 caps at ~50K.

But there's a cost: the compression step is lossy. Fine-grained feature interactions that survive in TabPFN's cell-level attention may be lost in TabICLv2's row embedding. The papers don't directly compare on tasks where feature interactions are paramount. On the benchmarks used, TabICLv2 wins — but benchmark diversity remains a concern.

### The Synthetic-Only vs Real-Data Question

TabICLv2 is purely synthetic. TabPFN-2.5's best variant (RealTabPFN-2.5) uses real-data continued pretraining. The fact that TabICLv2 beats RealTabPFN-2.5 *without* any real data is remarkable and suggests their synthetic prior is genuinely better. But the question remains: what would TabICLv2 + real-data fine-tuning look like? The paper explicitly defers this. My guess: it would push the frontier further, and it's a low-hanging fruit for follow-up work.

### Scalable Softmax is Underappreciated

QASSMax solves a problem that will matter increasingly as TFMs scale. The log(n) scaling insight (backed by theory from Chen et al. 2025) combined with query-aware gating is the kind of contribution that transfers beyond tabular models. The fact that it yields ~100 Elo improvement with zero additional parameters at inference is remarkable. I expect this technique to be adopted in other ICL settings.

---

## Verdict

**TabICLv2 is the more important paper.** It's faster, more scalable, more open, and better ablated. It advances the science of TFMs more than TabPFN-2.5. The architecture-prior coupling insight alone justifies the paper.

**TabPFN-2.5 is the more useful product.** Distillation engine, cloud API, causal inference, production deployment — these matter for real-world impact. But as a research contribution, it's thin.

**The field needs TabICLv2's openness.** The closed-prior era needs to end. TabICLv2 demonstrates that fully open TFMs can match or beat closed ones. This should be the standard going forward.

**Neither paper addresses the elephant in the room:** text and metadata. Real tabular data has column names like "patient_age_at_diagnosis" and "FICO_score_v2." Ignoring this semantic information is an increasingly untenable limitation as TFMs compete with LLM-based approaches that naturally leverage it.

**Watch for:** TabICLv2 + real-data fine-tuning, QASSMax adoption in non-tabular ICL, and whether Prior Labs opens their prior in response to this competitive pressure.
