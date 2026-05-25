# Scrolling Toward Sustainability? Cross-Community Identity and the Attitude-Behavior Gap in Reddit Fashion Discourse

## 1. Motivation

Fast fashion's CO₂ emissions surpass the combined outputs of France, Germany, and the UK. Shein shipped 2.7B+ packages in 2022. Meanwhile, 65% of consumers say they'd buy sustainable — only 26% do (White, Hardisty, & Habib 2019). This attitude-behavior gap is well-documented in surveys but has never been studied at the individual user level in naturalistic online discourse. We use NLP on Reddit fashion communities to detect discourse-level traces of this gap.

## 2. Research Questions

| RQ | Type | Question | What's New vs. Prior Work |
|----|------|----------|---------------------------|
| **RQ1** | Descriptive | How do sustainability narratives in Reddit fashion communities evolve from 2019–2024 (spanning COVID, Shein's rise, factory exposés)? | Aydin & Ogunleye (2026) provide a cross-sectional snapshot; we add the **temporal dimension**. |
| **RQ2** | Comparative | Do sentiment and topic distributions differ systematically across sustainability-oriented, general-fashion, and secondhand communities? | Prior work uses lexicon-based sentiment only; we compare **three methods** (VADER, RoBERTa, LLM) against **500 human-annotated posts**. |
| **RQ3** | Novel | Do users who post in sustainability communities *also* post about Shein/fast-fashion elsewhere — and if so, does their language shift between contexts in ways predicted by cognitive dissonance theory? | **No existing work examines cross-community identity signals in fashion discourse.** This is the primary contribution. |

### What We Do NOT Claim

- Reddit discourse ≠ purchasing behavior. We document how people *talk*, not how they *act*.
- Cross-posting ≠ revealed preference. It captures community affiliation, not consumption.
- Linguistic hedging ≠ proof of cognitive dissonance. We test for patterns *consistent with* the theory and discuss alternatives alongside every finding.

## 3. Theoretical Framework

**Primary — Cognitive Dissonance (Festinger 1957):** When users hold a belief ("fast fashion is destructive") and a behavior ("I shop at Shein"), they experience discomfort and are motivated to reduce it. Celik & Ekici (2024, *J. Business Ethics*) document specific dissonance-reducing strategies in sustainable fashion consumers. This generates three testable predictions for dual-community users (see §4).

**Primary — Social Identity & Fashion as Performance (Goffman 1959; Entwistle 2000):** Participating in r/ethicalfashion and r/Shein simultaneously means managing competing identity commitments — classic role conflict (Stryker & Burke 2000).

**Supplementary — Narrative Economics (Shiller 2017):** Used only as conceptual motivation for studying narrative evolution over time, not as a causal theory of consumer behavior. (See Appendix A for scope limitations.)

## 4. Predictions (RQ3) and Controls

| Prediction | Operationalization | Alternative Explanation | Control Test |
|------------|-------------------|------------------------|-------------|
| **P1: Linguistic register shifting** — Dual-community users show higher LIWC Tentativeness when posting about fast fashion in sustainability subs than in fashion subs. | Within-user LIWC Tentativeness comparison (paired); between-group Mann-Whitney U (dual vs. single-community users). | Community norm compliance — r/ethicalfashion *requires* hedging, so everyone hedges there regardless of dissonance. | Compute dual-community users' Tentativeness in **unrelated** subreddits. If globally higher → it's communication style, not dissonance. |
| **P2: Temporal sequence (bidirectional)** — Test *both* licensing (sustainability → Shein posting) and consistency (sustainability → more sustainability) against a null model. | Permutation test: shuffle each user's posting timestamps 1,000×, preserving subreddit assignments. Compare observed transition rates to null distribution. | Moral licensing has serious replication problems (see Appendix B). A null result is more consistent with the current evidence base than a positive finding. | N/A — the bidirectional framing itself addresses the concern. |
| **P3: Topic compartmentalization** — Same user emphasizes environmental impact in sustainability subs, price/quality in fashion subs, more than community baselines predict. | Jensen-Shannon divergence on per-user topic distributions across contexts. Compare within-user JS divergence (same user, different contexts) to between-user JS divergence (different users, same context). | Community-level topic differences — sustainability subs naturally discuss environment; fashion subs discuss clothing. | If within-user divergence ≤ between-user divergence → users are simply reflecting community norms, not actively compartmentalizing. |

## 5. Data

Seven subreddits via Arctic Shift (HuggingFace), 2019–2024. Target corpus: 50K–100K posts/comments.

| Subreddit | Subscribers | Role |
|-----------|-------------|------|
| r/ethicalfashion | ~117K | Primary sustainability corpus |
| r/SustainableFashion | ~88K | Primary sustainability corpus |
| r/sustainability | ~500K+ | Secondary sustainability (fashion is a minority topic) |
| r/femalefashionadvice | ~2.5M | Fast-fashion discourse (keyword-filtered for Shein/fast-fashion) |
| r/Shein | ~69.5K | Cross-posting overlap only (content is mostly sizing/promo codes) |
| r/ThriftStoreHauls | ~4.1M | Secondhand community; cross-posting overlap + text analysis where ≥30 words |
| r/Anticonsumption | ~500K+ | Anti-consumption corpus; cross-posting breadth |

## 6. Methods

### 6.1 Sentiment Analysis — Three Methods + Human Validation

| Method | Purpose | Known Limitation |
|--------|---------|-----------------|
| **VADER** (lexicon) | Floor / baseline | F1 ≈ 0.70 on fashion; fails on sarcasm |
| **RoBERTa** (`cardiffnlp/twitter-roberta-base-sentiment-latest`) | Transformer baseline | Trained on tweets through Dec 2021; domain shift to Reddit undocumented |
| **LLM zero-shot** (Llama 3 8B or Qwen2.5 7B, local) | Handles irony, slang, context | Zero-shot underperforms fine-tuned models |
| **500 human-annotated posts** | Ground truth for all three methods | 70 posts/subreddit, stratified; 100 double-annotated (target κ ≥ 0.70) |

**Contingency:** If all three methods score <0.65 accuracy → report as a finding about tool inadequacy; pivot to aspect-based LLM annotations + topic modeling as primary method.

### 6.2 Topic Modeling — BERTopic + NMF

- **Document unit:** User-within-thread aggregation (all comments by one user in one thread, prepended by post title). Preserves authorial coherence, avoids mixing contradictory voices.
- **BERTopic:** Sentence-transformer → UMAP → HDBSCAN → c-TF-IDF. Known outlier problem mitigated by `reduce_outliers()` and `min_topic_size=30`.
- **NMF:** Deterministic, no outlier bin, empirically validated on r/SustainableFashion (coherence 0.573 vs. LDA's 0.386; arXiv 2412.14486). Primary fallback if BERTopic outlier rate >40%.

### 6.3 Cross-Posting Analysis (Core Novelty)

1. Build user × subreddit participation matrix across all 7 subreddits.
2. Compute pairwise overlap using **Jaccard** and **Szymkiewicz-Simpson** (overlap coefficient — normalizes by smaller community).
3. Identify **dual-community users** (active in both sustainability-oriented and fast-fashion-adjacent subs).
4. Test Predictions P1–P3 with specified controls.
5. **Demographic controls:** Waller & Anderson (2021) subreddit co-participation proxies for age, gender, affluence. Used as coarse controls, not precise measurements (see Appendix E for limitations).

### 6.4 Hedging Measurement

| Layer | Measure | Role |
|-------|---------|------|
| **Primary** | LIWC-22 Tentativeness dictionary (validated) | Main comparison variable for P1 |
| **Validation** | Manual hedge annotation on 500-post set (binary) | Validates LIWC against human judgment (report ROC-AUC) |
| **Exploratory** | Domain-specific justification phrases compiled during annotation (~20–30 phrases) | Reported descriptively; not used as primary measure |

## 7. Power Analysis & Go/No-Go (RQ3)

| Dual-community users found | Action |
|---------------------------|--------|
| **n ≥ 175** | Full P1–P3 analysis with adequate power (d = 0.3, α = 0.05, power = 0.80) |
| **50 ≤ n < 175** | Proceed as exploratory; only large effects (d ≥ 0.5) detectable |
| **30 ≤ n < 50** | P2 only (temporal sequence); P1/P3 as descriptive case studies |
| **n < 30** | Pivot to community-level overlap statistics + qualitative close-reading |

Precedent: Pilaud & McCulloh (2025) found 63 dual-subreddit users between r/Sino and r/China using the same method.

## 8. Timeline (10 Weeks)

| Phase | Weeks | Deliverables |
|-------|-------|-------------|
| **Corpus + EDA** | 1–2 | Clean DataFrames; cross-posting census; power analysis go/no-go; pilot annotation (20 posts) |
| **Sentiment** | 3–4 | Three-method sentiment scores on full corpus; 500-post annotation complete; inter-annotator agreement |
| **Topics + Cross-Posting** | 5–8 | BERTopic/NMF topic models; cross-posting overlap matrices; P1–P3 tests with controls; LIWC computation |
| **Robustness + Writing** | 8–10 | Verbosity/style control test; community norm baseline; alt-account sensitivity analysis; paper (~20–25 pages) |

**Pre-camp (mentor/TA, ~40–60 hrs):** Pre-download Arctic Shift data, pre-filter r/femalefashionadvice, run data validation protocol, set up LLM inference, draft annotation guide.

## 9. Top Risks

| Risk | Severity | Core Mitigation |
|------|----------|----------------|
| **Alt-account selection paradox** | Very High | Users who *feel* the gap most are most likely to use alts, making them invisible. Cross-posting is a lower bound. State explicitly; sensitivity analysis for 2–10% alt rates. |
| **Community norms ≠ dissonance** | Very High | Hedging may be audience management, not internal conflict. Control: LIWC in unrelated subs; community norm baseline comparison. |
| **Insufficient dual-community users** | High | Go/no-go decision in Week 1–2 per power table above. |
| **Sentiment tools fail on fashion discourse** | High | 500-post human annotation quantifies failure. Contingency: aspect-based LLM + topic modeling. |
| **Novelty depends on RQ3** | Medium | If RQ3 is infeasible, remaining contribution = "Aydin & Ogunleye replication with more methods" — publishable but thin. |

## 10. Publication Targets

| Venue | Fit |
|-------|-----|
| **Fashion and Textiles** (Springer) | Strong — position against Aydin & Ogunleye (2026) |
| **Sustainable Production and Consumption** | Good — sustainability + consumer behavior |
| **SSRN / arXiv preprint** | First — immediate visibility |
| **Sustainability** (MDPI) | Fallback — open access, accepts NLP + sustainability |

---

## Appendices

### Appendix A: Detailed Literature Review

#### A.1 Aydin & Ogunleye (2026) — Direct Predecessor

Aydin & Ogunleye (2026), "What consumers really think about sustainable fashion," *Journal of Global Fashion Marketing*, analyzed 116K+ posts and 283K comments from 20 Reddit communities using LDA, BERTopic, and lexicon-based sentiment. They identified six themes (product lifecycle, material sourcing, size standardization, quality vs. price, social responsibility, consumer influence) and found predominantly positive sentiment with waste management and material sourcing evoking the least positive reactions.

They explicitly state: "to the best of our knowledge, this is the first study to use Reddit dataset to understand fashion sustainability perceptions."

**What they do NOT do:**
1. Cross-community user-level analysis (our RQ3)
2. Temporal evolution analysis (our RQ1)
3. Multi-method sentiment comparison with human validation (our RQ2)
4. Theoretical grounding in cognitive dissonance (our RQ3)

#### A.2 Other Related Work

- **"Consumer Awareness of Fashion Greenwashing" (Sustainability, 2025):** LDA on 446 Reddit comments with cognitive dissonance framework. Small corpus, no cross-community analysis. Establishes that cognitive dissonance framing is accepted in this literature.
- **"Emotional Analysis of Fashion Trends Using Social Media and AI" (arXiv 2505.00050, 2025):** Multi-platform sentiment; sustainability theme had only 1,337 tweets, 81.3% neutral. Cautionary example about sentiment tool performance.
- **Celik & Ekici (2024, *J. Business Ethics*):** Qualitative study of 20 sustainable fashion consumers documenting dissonance-reducing strategies: moral self-licensing, neutralization, "alternating moral practices." Our cross-posting analysis operationalizes this at scale.
- **"Secondhand fashion consumers exhibit fast fashion behaviors" (PMC 12504660, 2025):** Greater sustainability knowledge was only weakly/negatively correlated with sustainable purchasing. Invokes moral licensing. Directly relevant to r/ThriftStoreHauls analysis.
- **"Moving Beyond LDA" (arXiv 2412.14486, 2024):** Tested LDA, BERTopic, NMF on 12 Reddit datasets including r/SustainableFashion. NMF coherence 0.573 > LDA 0.386 on that subreddit.
- **"Can Language capture Cognitive Dissonance?" (arXiv 2502.13326, 2025):** AUC ~0.8 for experimentally-evoked cognitive styles via language, but only with experimental measurement. Underscores that observational data cannot establish genuine dissonance.
- **"I Don't Buy It!" (Sustainability, 2025):** Systematic review confirming self-report measures "do not constitute actual behavioral measures."
- **Pilaud & McCulloh (2025, arXiv 2507.16857):** Cross-subreddit behavior analysis with topic modeling and sentiment on dual-subreddit users. Found 63 dual-subreddit users between r/Sino and r/China. Methodological precedent for our approach.

#### A.3 Narrative Economics Scope Limitations

Shiller's framework was developed for macroeconomic fluctuations (recessions, financial crises, asset bubbles). Consumer purchasing at $5–$30 price points operates through hedonic, impulsive, and socially mediated mechanisms that differ fundamentally from aggregate demand shifts. We retain the framework only as conceptual motivation for studying narrative evolution, not as a causal theory. Critics note Shiller's approach "reduce[s] narrative to a vocabulary word search that ignores context, genre, and tone" (Skwire, Econlib 2020).

### Appendix B: Moral Licensing Replication Crisis

A naïve design might predict unidirectional moral self-licensing (sustainability posting → Shein posting). The literature does not support this:

- **Kuper & Bott (2019, *Meta-Psychology*):** Publication bias inflating effect sizes. PET-PEESE adjusted: d = −0.05 (p = .64) to d = 0.18 (p = .002), down from meta-analytic d = 0.31 (Blanken et al. 2015).
- **Rotella & Barclay (2020, *PAID*):** Failed to replicate licensing online. "Licensing and cleansing effects are unlikely to be elicited online."
- **2025 PSPB Meta-Analysis (N = 21,770, 115 experiments):** Licensing moderated by observation: g = 0.65 observed vs. g = −0.01 unobserved. "Elicited through interpersonal motives," not intrapsychic dissonance.

**Implication:** Reddit is pseudonymous — the observation channel is ambiguous. A unidirectional licensing prediction is unsupported. P2 therefore tests both licensing and consistency as competing hypotheses, with a permutation-based null model.

### Appendix C: Data Validation Protocol

Must complete in **Week 1** before any analysis:

1. **Post-volume cliff-edge test:** Plot monthly counts per subreddit. Arctic Shift maintainer confirmed completeness post-June 2023 aside from April–June 2023. Exclude those months if >50% volume drop. Do not use post scores from July–October 2023 (known Arctic Shift ingestion issue).
2. **User-deletion audit:** PushShift overwrote `[deleted]` authors (23% of submissions in last year); Arctic Shift preserves originals (only 2%). Report rates per period — apparent cross-posting increases over time may reflect better data preservation.
3. **Deleted-content audit:** Count `[deleted]`/`[removed]` posts per subreddit per year.
4. **r/femalefashionadvice keyword filter yield:** If <50 Shein-mentioning posts/month, expand keywords or add r/fashion.
5. **r/ThriftStoreHauls text check:** If >70% posts have <30 words, retain for cross-posting only.
6. **Bot/spam filtering:** Remove accounts with >50% affiliate links, low karma, brand-only posting history, or created within 7 days of first post. Report removal rates.
7. **Cross-posting user count + power analysis:** Run the go/no-go decision per §7.

### Appendix D: Hedging Measurement Details

The hedging detection literature shows this is harder than it appears:
- Islam et al. (2020, LREC): Precision 57.6%, recall 64.9% on informal text.
- arXiv 2408.03319 (2024): Fine-tuned BERT outperforms zero-shot LLMs for hedge detection.
- Hedging markers are polysemous ("might" = hedge 78.5% in academic text; different in casual discourse).

**Our three-layer approach:**
1. **LIWC-22 Tentativeness dictionary** — validated, reproducible. Also compute Certainty; the Tentativeness-to-Certainty ratio gives a scalar hedge-vs-assertion index. Academic license ~$100. Alternative: `empath` library (free).
2. **500-post manual hedge annotation** — binary (present/absent), ~10 sec/post additional to sentiment annotation. Compute ROC-AUC of LIWC vs. human labels.
3. **Domain-specific justification phrases** — compiled during annotation ("guilty pleasure," "I know I shouldn't but," "treat yourself"). Reported descriptively only; not validated as a primary measure.

### Appendix E: Demographic Controls — Limitations

Waller & Anderson (2021) subreddit co-participation embeddings assign age, gender, affluence scores. A 2025 evaluation (arXiv 2502.05049) found: "relies on arbitrarily defined poles... which have not been rigorously tested or validated." Simple Naive Bayes with self-declared labels outperformed WA embeddings (ROC AUC >0.7, implying WA's is lower). We use these as coarse confound flags, not precise demographic measurements. If a finding reverses after including controls, we flag it and do not over-interpret.

### Appendix F: Conceptual Risks — Full Discussion

#### F.1 Alt-Account Selection Paradox (Very High Severity)

The analysis can only detect users who post in both sustainability and fast-fashion communities **under the same username**. This creates a paradox:
- Users who don't feel dissonance have no reason to separate identities — they are the *least* interesting cases.
- Users who *do* feel the gap are most likely to use alts, making them *systematically invisible*.

High overlap could mean "many people feel comfortable in both spaces" (weak gap). Low overlap could mean "people hide the gap with alts" (strong gap, but invisible). Both outcomes are consistent with both hypotheses.

**Mitigations:** (1) State explicitly. (2) Sensitivity analysis for 2–10% alt rates. (3) Frame cross-posting as a lower bound. (4) Flag stylometric detection as future work (raises additional ethics concerns).

#### F.2 Community Norm Compliance vs. Genuine Dissonance (Very High Severity)

In r/ethicalfashion, mentioning any fast-fashion purchase without hedging invites criticism. All users hedge there — audience management, not necessarily dissonance. arXiv 2502.13326 (2025) argues that linguistic markers of dissonance are only reliable with experimental measurement.

**Mitigations:** (1) Verbosity/style control test in unrelated subs. (2) Community norm baseline: compare dual-community users against all users in the same community. (3) Frame all findings as "consistent with" dissonance theory, never as evidence *of* dissonance.

#### F.3 Other Conceptual Risks

- **Reddit ≠ fashion consumers:** Reddit users who post in fashion subs are self-selected, text-literate. Reddit captures discourse *about* fast fashion; TikTok/Instagram drive actual purchasing.
- **Cross-posting ≠ purchasing:** A user in both r/ethicalfashion and r/Shein could be a critic, a gift-buyer, or a regretful one-time customer.
- **Attitude-behavior gap may make all discourse analysis irrelevant:** If discourse is systematically disconnected from behavior, our study describes discourse patterns with no demonstrated link to purchasing. We frame as descriptive.

### Appendix G: Team Allocation

| Member | Weeks 1–2 | Weeks 3–4 | Weeks 5–8 | Weeks 8–10 |
|--------|-----------|-----------|-----------|------------|
| **Student A** | Corpus assembly, deduplication, DataFrames | Annotation (125 posts); LLM sentiment pipeline | Cross-posting computation; power analysis; dual-community user ID | Robustness: verbosity/style control; alt-account sensitivity |
| **Student B** | Cross-posting census; user × subreddit matrix; demographic proxies | Annotation (125 posts); VADER pipeline | BERTopic + NMF topic modeling | Topic evolution figures; community norm baseline test |
| **Student C** | EDA, validation checks, bot/spam filtering | Annotation (125 posts); RoBERTa pipeline | Sentiment agreement analysis; LIWC computation + validation | All figures and tables |
| **Anna** | Research design; annotation guide; lit review | Annotation (125 posts); inter-annotator agreement | Dual-community analysis: P1–P3 with controls; temporal permutation test | Paper writing; framing; interpretation |

### Appendix H: Design Decisions and Excluded Alternatives

| Decision | Rationale |
|----------|-----------|
| No time-series / Granger causality analysis | 60–72 monthly observations is below the ≥150 threshold for credible Granger causality; no power after Bonferroni correction; COVID confounds all 2020–2021 correlations. |
| No Google Trends, GDELT, or SEC filings as data sources | These would only serve a time-series analysis, which is excluded (see above). |
| No information cascades framework (Banerjee 1992) | Reddit violates the framework's assumptions (sequential, observable decisions by rational agents). Generated no testable predictions beyond cognitive dissonance. |
| Bidirectional temporal test (P2), not unidirectional licensing | Moral licensing replication crisis (Appendix B). |
| LIWC Tentativeness as primary hedging measure | Building a validated domain-specific hedging lexicon from scratch is a multi-month project; LIWC provides a reproducible, validated baseline. |
| NMF included alongside BERTopic | Empirical evidence from r/SustainableFashion shows NMF coherence (0.573) > LDA (0.386) on this exact subreddit (arXiv 2412.14486). |
| Bot/spam filtering in data validation | Fashion subs are targets for astroturfing; unfiltered promotional accounts would corrupt cross-posting statistics. |
| Power analysis covers d = 0.2–0.3, not just d = 0.5 | If hedging differences are subtle — as cognitive dissonance theory predicts for people who successfully compartmentalize — d = 0.5 is optimistic. |

### Appendix I: Future Extensions (Beyond 10-Week Scope)

1. **TikTok data** — the platform actually driving fast-fashion purchasing.
2. **Survey validation** (n=200) — pair NLP findings with self-reported purchasing behavior.
3. **Stylometric alt-account detection** — estimate true alt-account rate; requires IRB review.
4. **Fine-tuned hedge detection model** — use 500 annotations to fine-tune BERT for fashion hedging.
5. **Causal identification** — event study around specific Shein exposés.
6. **Fine-tuned fashion sentiment model** — use annotations + LLM silver labels to fine-tune RoBERTa.
7. **Experimental validation** — pair observational data with controlled tasks per arXiv 2502.13326.

### Appendix J: Key References

**Direct Predecessors:** Aydin & Ogunleye (2026), *J. Global Fashion Marketing*. | "Consumer Awareness of Fashion Greenwashing" (2025), *Sustainability*.

**Cognitive Dissonance & Attitude-Behavior Gap:** Festinger (1957). | Celik & Ekici (2024), *J. Business Ethics*. | Carrigan & Attalla (2001). | White, Hardisty, & Habib (2019), *HBR*. | Carrington, Neville, & Whitwell (2014). | Bläse et al. (2023).

**Moral Licensing Replication Crisis:** Kuper & Bott (2019), *Meta-Psychology*. | Rotella & Barclay (2020), *PAID*. | "Observation Moderates Moral Licensing" (2025), *PSPB*. | Blanken, van de Ven, & Zeelenberg (2015), *PSPB*.

**Dissonance Measurement:** "Can Language capture Cognitive Dissonance?" (arXiv 2502.13326, 2025). | "I Don't Buy It!" (Sustainability, 2025).

**Topic Modeling:** "Moving Beyond LDA" (arXiv 2412.14486, 2024). | Grljević et al. (2024, arXiv 2402.03067).

**Cross-Posting Methodology:** Pilaud & McCulloh (2025, arXiv 2507.16857). | arXiv 2402.14177 (2024).

**Sentiment & NLP:** He et al. (2025), PMC. | Burnham et al. (2024, arXiv 2406.08660). | Islam et al. (2020), LREC. | arXiv 2408.03319 (2024).

**Demographic Inference:** Waller & Anderson (2021), AAAI ICWSM. | arXiv 2502.05049 (2025).

**Social Identity:** Goffman (1959). | Entwistle (2000). | Stryker & Burke (2000).

**Narrative Economics:** Shiller (2017), *AER*. | Soboleva & Sánchez (2024, arXiv 2407.18814).

**Reddit Data & Ethics:** Fiesler et al. (2024), ACM CSCW. | PMC 9463657 (2022). | arXiv 2501.17430 (2025).

**Secondhand Rebound:** PMC 12504660 (2025).
