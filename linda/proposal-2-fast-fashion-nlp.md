# Proposal 2: Scrolling Toward Sustainability? NLP Analysis of Fast Fashion Discourse on Reddit

## Summary

Fast fashion's CO₂ emissions "surpass the combined outputs of France, Germany, and the UK" (Soboleva & Sánchez, arXiv 2407.18814, 2024). Shein was valued at ~$66B in 2023 and shipped 2.7B+ packages in 2022. Meanwhile, sustainability rhetoric floods social media. But decades of consumer research document a persistent "attitude-behavior gap" — "an estimated 30% of consumers indicate concern about environmental issues, yet only 5% translate this concern into action" (Young et al. 2010, cited in Belz & Peattie 2009).

This project uses NLP to study **how** sustainability narratives evolve in fast fashion communities on Reddit, whether distinct communities exhibit measurably different discourse patterns, and whether narrative shifts correlate with observable market signals. We frame this as a **descriptive and correlational** study, not a causal one — the data cannot establish that discourse changes behavior.

## Why Anna

Fashion Studies minor at Cornell. This isn't a bolted-on interest — she formally studied it. Combined with her Economics training (econometrics, causal reasoning) and Anthropology minor (cultural behavior lens), she's unusually well-positioned to bridge quantitative NLP methods with fashion/consumer theory. Pure CS/DS researchers lack this domain credibility. Anna's unique contribution is precisely the theoretical lens needed to interpret NLP outputs in a domain where naive sentiment ≠ purchase intent.

## Core Research Questions

1. **Descriptive**: How do sustainability narratives on Reddit fashion communities evolve from 2019–2025 (spanning pre/post COVID, Shein's rise, and factory exposé events)?
2. **Comparative**: Do sentiment trajectories and topic distributions differ systematically across pro-sustainability (r/ethicalfashion, r/sustainability), fast-fashion-adjacent (r/Shein), and secondhand (r/thriftstorehauls) communities?
3. **Behavioral (within-Reddit)**: Do users who post in r/ethicalfashion also post in r/Shein? Cross-posting overlap as a revealed-preference measure of the attitude-behavior gap.
4. **Correlational**: Do Reddit sentiment time-series and Google Trends search volumes for fast fashion brands exhibit lead-lag relationships at monthly frequency?

### What This Project Does NOT Claim

We do not claim that Reddit sentiment *causes* changes in consumer purchasing behavior. The attitude-behavior gap literature is clear: "perhaps the most consistent finding within this burgeoning literature has been inconsistency between what people say (or express via attitudes, values etc.) and what they actually do" (Belz & Peattie 2009, cited in Carrington et al. 2014). Our study documents discourse patterns and tests for statistical associations at the aggregate level. Interpreting these associations requires caution that we discuss explicitly in the Limitations section.

## Data Sources

| Source | What | Role in Analysis | Access |
|--------|------|------------------|--------|
| **Reddit** (r/sustainability, r/ethicalfashion, r/Shein, r/thriftstorehauls) | User posts and comments | Primary corpus for NLP; cross-posting analysis | Arctic Shift data dumps on HuggingFace (~261 GB Parquet, through 2026-02) |
| **Google Trends** | Relative search volume for "Shein", "sustainable fashion", "thrift", "fast fashion" | Monthly time-series for cross-correlation with sentiment | trends.google.com — direct download with stability validation |
| **SEC filings / Quarterly earnings** | Revenue for H&M, Inditex/Zara, Gap, Lululemon, ThredUp | Supplementary context plots (NOT regression targets) | EDGAR / Yahoo Finance API |
| **Good On You** | Brand sustainability ratings (1–5 scale) | Static cross-sectional variable for brand categorization only | goodonyou.eco |

### Data Sources Removed From Original Proposal (with rationale)

| Removed | Why |
|---------|-----|
| **r/fashionreps** | This subreddit (2.2M members) is about **counterfeit/replica luxury goods** — people buying fake Jordans and knockoff Balenciaga. This is fundamentally different from fast fashion (Shein, H&M, Zara). Including it would conflate luxury-aspirational counterfeiting with cheap disposable fashion — two entirely different consumer motivations, price points, and ethical considerations. |
| **UN Comtrade** | Textile trade data operates at a national/annual level completely disconnected from subreddit-level sentiment. No methodological role was specified in the original proposal. |
| **SEC quarterly revenue as regression target** | 2019–2025 yields ~24 quarterly observations. The econometrics literature is unambiguous: "Credible Granger-causality analysis... is usually infeasible with samples of modest length — e.g., T ≤ 150" (Ashley & Tsang). With 24 data points, adding even basic controls (seasonality, CPI) guarantees overfitting. Revenue is retained for contextual visualization only. |

### Key Context for Framing

- Shein valued at ~$66B (2023), shipped 2.7B+ packages in 2022
- "FOMO drives purchase intentions in fast fashion" even among sustainability-aware consumers (Bläse et al. 2023, n=650)
- Agent-based modeling shows government interventions are pivotal but "social media bias can dominate" in shifting public opinion on fast fashion (Soboleva & Sánchez, arXiv 2407.18814, 2024)
- The attitude-behavior gap in sustainable fashion is extensively documented: "consumers with an ethical mindset hold a sense of responsibility towards the environment and society, and wish to express their values and beliefs through their purchasing behavior" yet "consumer demand for sustainable fashion brands remains limited" (Jacobs et al. 2018; Carrigan & Attalla 2001; Bocti et al. 2021)
- A 2024 Psychology & Marketing study (6 experiments, US consumers) found that sustainable purchasing is driven by social visibility — consumers buy sustainably when observed, but the effect "completely disappears" when shopping privately at home

## ML Methods (Teachable in 10 Weeks)

### Week 1–3: Data Collection & Cleaning

- **Reddit data**: Arctic Shift dumps via HuggingFace (successor to Pushshift; "2.5B-item Reddit archive through 2026-02, ~261 GB Parquet" — OpenData StackExchange 2025). Download tool at arctic-shift.photon-reddit.com for subreddit-specific JSONL exports. No API rate limits. Confirmed working as of 2025.
- **Google Trends**: Direct CSV download from trends.google.com (NOT `pytrends`). Rationale: `pytrends` returns sampled, unstable data. "Irregularities in the random sampling and aggregation algorithms compromise the reliability of the relative search volume (RSV)" (ScienceDirect 2024). Stability must be validated: download the same query 3× on different days and compute coefficient of variation (CV%). Discard any series with CV% > 5.
- **Financial data**: `yfinance` for quarterly revenue — used for contextual time-series plots only, NOT as regression targets.
- **Target**: 100K+ Reddit posts spanning 2019–2025 across 4 subreddits.
- **Cross-posting dataset**: Extract unique usernames from all 4 subreddits; compute user overlap matrix (Jaccard similarity). This is methodologically established — see "Investigating Human Values in Online Communities" (arXiv 2402.14177, 2024), which defines user similarity as the overlap coefficient between subreddit user sets.

### Week 3–5: NLP Pipeline — Sentiment Analysis

- **Baseline**: VADER sentiment — used as a **floor**, not as the primary model. Known limitations in this domain: VADER achieves F1 ≈ 0.70 on fashion-related content (fashion-nova reviews benchmark), and "struggles with sarcasm and context-dependent expressions" (arXiv 2504.15448, 2025). "The predefined lexicon in VADER may not fully capture the sentiment of domain-specific terms or new slang" (VADER Comprehensive Overview, 2024).
- **Primary model**: HuggingFace `cardiffnlp/twitter-roberta-base-sentiment` — a RoBERTa model fine-tuned on ~58M tweets. Better at contextual inference than VADER but trained on Twitter, not Reddit. We report VADER vs. RoBERTa agreement rates as a robustness check.
- **Annotation budget** (CRITICAL — missing from original): Manually label 500 Reddit posts (125 per subreddit) for sentiment ground truth. This enables: (a) measuring model accuracy on our specific domain, (b) reporting inter-annotator agreement (Cohen's kappa), (c) identifying systematic failure modes (irony, Gen Z slang, fashion jargon). Split across team: ~125 labels per person in Week 3.
- Compute weekly/monthly sentiment scores per subreddit.
- **What VADER/RoBERTa will miss**: Fashion-specific irony ("Shein haul! Got 47 pieces for $12, definitely saving the planet 🌍"), subculture jargon ("fire", "heat", "drip" as positive valence), Gen Z register ("no cap", "slay", "ate and left no crumbs"). The 500-post annotation will quantify how often this occurs.

### Week 5–7: Topic Modeling & Cross-Posting Analysis

**Topic Modeling with BERTopic**:
- BERTopic uses sentence-transformer embeddings → UMAP dimensionality reduction → HDBSCAN clustering → c-TF-IDF topic representation. Students use it as a **high-level API** (`BERTopic().fit_transform(docs)`) — they do not need to understand UMAP/HDBSCAN internals.
- LDA as a simpler baseline for comparison.
- Expected topics: "labor exploitation", "environmental guilt", "price justification", "thrifting as identity", "greenwashing skepticism".
- Track topic prevalence over time — do narratives shift around events (Shein factory exposés, Earth Day, COVID lockdowns)?
- **Known issue**: "When used with HDBSCAN, BERTopic creates a bin for topic outliers, which can sometimes contain over 74% of the dataset" (Grljević et al., arXiv 2402.03067, 2024). Mitigation: use `reduce_outliers()` with c-TF-IDF strategy; report outlier percentage.
- Visualize topic evolution with BERTopic's built-in `visualize_topics_over_time()`.

**Cross-Posting Analysis** (Novel Contribution):
- For each user who posted in any of the 4 subreddits, check whether they also posted in other target subreddits.
- Compute pairwise user-overlap matrix using Jaccard similarity.
- **Key test**: What fraction of r/ethicalfashion users also post in r/Shein? High overlap = direct evidence of the attitude-behavior gap at the individual level. Low overlap = distinct communities with no behavioral contradiction.
- Compare sentiment of dual-community users (those posting in both r/ethicalfashion and r/Shein) vs. single-community users. Do dual-community users express more guilt, ambivalence, or price-justification topics?
- This approach is methodologically grounded: "Cross-Subreddit Behavior as Open-Source Indicators of Coordinated Influence" (arXiv 2507.16857, 2025) uses exactly this method — "topic modeling and sentiment analysis are applied to all posts and comments authored by dual-subreddit users to construct a user–topic sentiment matrix."

### Week 7–9: Time-Series Correlation Analysis

**Monthly sentiment ↔ Google Trends cross-correlation** (NOT Granger causality on quarterly revenue):
- Align monthly Reddit sentiment scores with monthly Google Trends RSV for matching search terms.
- 2019–2025 = ~72 monthly observations — sufficient for cross-correlation and exploratory Granger tests (guideline: ≥50 observations per variable).
- **Stationarity first**: Run ADF and KPSS tests on all series. If non-stationary, first-difference before any correlation analysis. "Time-series data often contains unit-root and the correlation between such series often results in high coefficient value and t-statistics... it can increase the likelihood of obtaining spurious correlations" (Ono et al., BMC Medical Research Methodology, 2021).
- **Cross-correlation**: Compute lagged Pearson correlation (lags 0–6 months) between sentiment and search volume. Report with confidence bands.
- **Exploratory Granger test**: Monthly sentiment → monthly Google Trends, with lag selection via AIC/BIC. Frame as "predictive association": "Variable y₁ is said to Granger cause variable y₂ if the past values of y₁ have predictive power for the current values of y₂, conditional on the past values of y₂" (standard VAR formulation). Explicitly disclaim causal interpretation.
- **Controls**: Monthly Consumer Confidence Index from FRED; monthly CPI. Maximum 3–4 variables in the VAR to preserve degrees of freedom with 72 observations.
- **Supplementary visualization only**: Overlay quarterly revenue time-series for H&M, Inditex, ThredUp against sentiment trends. Present as visual context, not statistical test.

### Week 9–10: Paper Writing & Visualization

- Time-series plots: sentiment trajectories per subreddit with event annotations (COVID, Shein exposés, Earth Day)
- BERTopic topic evolution heatmaps
- Cross-posting Jaccard similarity matrix / network diagram
- Cross-correlation plots with confidence bands
- Write-up: ~20–25 pages

## Team Task Allocation

| Team Member | Weeks 1–3 | Weeks 3–5 | Weeks 5–7 | Weeks 7–10 |
|-------------|-----------|-----------|-----------|------------|
| **Student A** | Reddit data download, cleaning, deduplication | Manual annotation (125 posts) | Cross-posting user overlap computation | Cross-correlation computation |
| **Student B** | Google Trends download + stability validation; `yfinance` revenue data | Manual annotation (125 posts) | BERTopic topic modeling | Time-series visualization |
| **Student C** | EDA: post volume trends, word clouds, subreddit statistics | Manual annotation (125 posts); VADER + RoBERTa pipeline | Sentiment comparison: VADER vs. RoBERTa; agreement analysis | Figures and tables for paper |
| **Anna** | Research design; literature review (attitude-behavior gap, narrative economics) | Manual annotation (125 posts); annotation guide design; inter-annotator agreement | Cross-posting sentiment analysis of dual-community users | Econometric testing (stationarity, Granger); paper writing |

## Publication Targets

| Venue | Fit | Realistic? |
|-------|-----|------------|
| **Fashion and Textiles** (Springer) | Directly relevant; accepts mixed-methods | ✅ Strong fit |
| **Sustainable Production and Consumption** | Sustainability + consumer behavior | ✅ Good fit |
| **SSRN / arXiv preprint** | Immediate visibility | ✅ Do this first |
| **ACM Conference on Web Science** | If cross-posting analysis is foregrounded as computational contribution | ⚠️ Needs stronger methods novelty |
| **Sustainability** (MDPI, IF ~3.9) | Open access, accepts NLP + sustainability | ✅ Good fallback |
| ~~*Journal of Cleaner Production*~~ | Expects rigorous causal identification (IV, DiD, RCT), not correlations | ❌ Removed — would likely desk-reject |
| ~~*Journal of Consumer Research*~~ | Requires survey/experimental data, not observational NLP | ❌ Removed — wrong methodology for venue |

## Risks, Unknowns, and Open Questions

### Data Risks

| Risk | Severity | Mitigation | Residual Uncertainty |
|------|----------|------------|---------------------|
| **Arctic Shift data completeness** | Medium | Arctic Shift is the successor to Pushshift and is "a representative source for the Reddit dumps" (confirmed by multiple academic users on r/pushshift, 2025). However, no formal completeness guarantee exists. One user asks: "do you know if the Arctic Shift Project has full access to Reddit's API and is accurate and complete regarding its data collection?" — no definitive answer was found. | Unknown what percentage of posts/comments are captured, especially post-2023. Report total post counts and compare to subreddit subscriber numbers as a sanity check. |
| **Google Trends instability** | Medium | "Subregional datasets can be highly unstable (e.g., CV% = 10)" (ScienceDirect 2024). Download each query 3× on different days; compute CV%; discard unstable series. Use direct CSV download, not `pytrends`. | Even with validation, RSV is relative (not absolute volume), and Google's normalization algorithm is undocumented. |
| **r/Shein may be small or inactive** | Medium | Check subreddit size during data collection. If < 5K posts in 2019–2025, replace with r/SustainableFashion or analyze Shein-mentioning posts across all subreddits using keyword search. | Subreddit viability unknown until data is downloaded. |
| **Good On You scraping legality** | Low | Use ratings for static brand categorization only (ethical vs. not), not time-series. If scraping is blocked by Cloudflare or ToS, manually record ratings for the ~10 brands in our analysis. | Terms of service not publicly documented for academic use. |

### Methodological Risks

| Risk | Severity | Mitigation | Residual Uncertainty |
|------|----------|------------|---------------------|
| **Sentiment models fail on fashion discourse** | High | The 500-post manual annotation (125 per subreddit) will quantify failure rate. VADER's known weaknesses: "over-predict neutral in domain-specific app text... struggle with sarcasm, litotes (e.g., 'not bad'), and negation scope" (arXiv 2509.20953, 2025). If accuracy < 0.65 on our domain, we report this as a finding and discuss implications. | No fashion-specific sentiment model exists. Even RoBERTa was trained on Twitter, not Reddit. We cannot know accuracy until we annotate. |
| **BERTopic outlier problem** | Medium | "BERTopic creates a bin for topic outliers, which can sometimes contain over 74% of the dataset" (arXiv 2402.03067, 2024). Use `reduce_outliers()` function. Report outlier % before and after reduction. | Topic quality depends on corpus characteristics. Short Reddit posts may produce noisier embeddings than longer documents. |
| **Cross-correlation ≠ causation** | High | Frame all results as "predictive association." "Granger causality... should be interpreted qualitatively rather than quantitatively" in settings where temporal calibration is uncertain (Soboleva & Sánchez 2024). | Even with proper framing, reviewers may push back on the value of purely correlational findings. The cross-posting analysis (RQ3) provides a stronger, individual-level contribution. |
| **Multiple comparisons** | Medium | With 4 subreddits × multiple lags × multiple search terms, risk of false positives is real. "The potential candidate keywords listed in the earlier GT-based... studies are not always reliably usable as true predictive measures" (Ono et al. 2021). Apply Bonferroni correction; pre-register primary hypotheses. | Exploratory analysis will generate many tests. Distinguish confirmatory from exploratory findings. |

### Conceptual Risks

| Risk | Severity | Discussion |
|------|----------|------------|
| **Reddit ≠ fashion consumers** | High | Reddit's demographics have shifted — "in the UK and the US, Reddit's surging user base is now more than 50% women" and "high-growth areas have been fashion, beauty, TV fandom" (Reddit VP, Vogue 2025). However, Reddit users who post in fashion subreddits are still a self-selected, text-literate minority. The proposal opens with TikTok but collects zero TikTok data — because TikTok is video-first and far harder to analyze with NLP. We acknowledge this platform mismatch explicitly. Reddit captures discourse *about* fast fashion; it does not capture the primary *driver* of fast fashion purchasing (TikTok haul videos, Instagram ads). |
| **Attitude-behavior gap may render sentiment irrelevant** | High | The core finding of this literature is that pro-sustainability sentiment does NOT predict sustainable purchasing: "65% of consumers stated they would purchase brands that are sustainable, yet only 26% actually did" (White, Hardisty, & Habib 2019). If Reddit sentiment is disconnected from behavior, then correlations with Google Trends or revenue are uninformative. This is why RQ3 (cross-posting overlap) is the most important question — it tests the gap directly within Reddit rather than requiring external behavioral data. |
| **Confounders in any sentiment ↔ market signal relationship** | High | COVID lockdowns (2020–2021) drove massive shifts in both online discourse and retail revenue simultaneously. Any correlation between sentiment and market outcomes during this period is likely confounded by the pandemic. Currency effects (H&M reports in SEK, Inditex in EUR) affect USD-denominated comparisons. Shein's competitive displacement of H&M/Zara reflects market dynamics, not sentiment shifts. We cannot control for these with 72 observations. |

## Theoretical Foundation

This project draws on two distinct literatures:

**1. Narrative Economics (Shiller 2017)**: Economic narratives — "contagious stories that spread through word of mouth and social media" — shape economic outcomes. Shiller's framework was developed for financial markets, not consumer goods. We extend it to fast fashion discourse with the explicit caveat that consumer purchasing operates through different mechanisms than asset pricing.

**2. The Attitude-Behavior Gap in Sustainable Fashion**: A large body of work documents that "consumers increasingly express ethical and environmental concerns regarding fashion consumption, yet consumer demand for sustainable fashion brands remains limited" (Jacobs et al. 2018; Carrigan & Attalla 2001; Lundblad et al. 2015; Niinimäki 2010). Key barriers include price (Chang 2011), convenience and availability (Carrigan et al. 2001; Johnstone et al. 2015), and perceived quality (Newman, Gorlin, & Dhar 2014). Our cross-posting analysis (RQ3) directly operationalizes this gap: if users simultaneously participate in r/ethicalfashion and r/Shein, they are expressing the gap in revealed behavior.

**3. Agent-Based Modeling of Fast Fashion Choices** (Soboleva & Sánchez, arXiv 2407.18814, 2024): This paper models how peer pressure, social media, and government interventions shift fast fashion purchasing probability using survey data from Spain (n=650). Key finding: "government interventions are pivotal, with the state's campaigns setting the overall tone for progress, although its success is conditioned by social media and polarization levels of the population." Our NLP analysis complements this by measuring the *actual* social media discourse that their model treats as a theoretical parameter.

## Key References

- Soboleva, D. & Sánchez, A. (2024). "Agent-Based Insight into Eco-Choices: Simulating the Fast Fashion Shift." arXiv 2407.18814.
- Bläse, R. et al. (2023). "Non-sustainable buying behavior: FOMO drives purchase intentions in fast fashion." Wiley.
- Carrigan, M. & Attalla, A. (2001). "The myth of the ethical consumer — do ethics matter in purchase behaviour?" *Journal of Consumer Marketing*, 18(7), 560–578.
- Carrington, M.J., Neville, B.A., & Whitwell, G.J. (2014). "Lost in translation: Exploring the ethical consumer intention–behavior gap." *Journal of Business Research*, 67(1), 2759–2767.
- White, K., Hardisty, D.J., & Habib, R. (2019). "The elusive green consumer." *Harvard Business Review*.
- Shiller, R. (2017). *Narrative Economics*. American Economic Review, 107(4), 967–1004.
- "Can LLMs Learn Macroeconomic Narratives from Social Media?" (arXiv 2406.12109, 2024) — methodological template for social media NLP + economics.
- "Emotional Analysis of Fashion Trends Using Social Media and AI" (arXiv 2505.00050, 2025) — related work, but NOTE: their sustainability theme had only 1,337 tweets, 81.3% neutral, and the validated trend was "Slightly Falling." Their hashtag analysis also surfaced data-quality issues (irrelevant content in keyword-based collection). We cite this as a cautionary example, not a validation.
- Grljević, O. et al. (2024). "Multilingual transformer and BERTopic for short text topic modeling." arXiv 2402.03067.
- Ono, T. et al. (2021). "Need of care in interpreting Google Trends-based COVID-19 infodemiological results." *BMC Medical Research Methodology*.
- "Addressing Google Trends inconsistencies" (ScienceDirect 2024) — methodological guide for RSV stability validation.
- Pilaud, M. & McCulloh, I. (2025). "Cross-Subreddit Behavior as Open-Source Indicators of Coordinated Influence." arXiv 2507.16857 — methodological precedent for cross-posting analysis.
- "New Fashion Products Performance Forecasting: A Survey" (arXiv 2501.10324, 2025).

## Why This Project Succeeds

- **Novel contribution**: The cross-posting analysis (RQ3) is genuinely new — using revealed within-Reddit behavior to test the attitude-behavior gap in fashion. No existing paper does this.
- **Domain credibility**: Anna's Fashion Studies minor provides the theoretical grounding that pure CS/NLP papers in this space lack.
- **Honest scope**: By reframing from "does sentiment cause behavior change?" to "how do narratives evolve and do communities' users overlap?", we make claims the data can actually support.
- **Rich skill development**: Students learn real NLP (transformers, topic modeling), data engineering (bulk data processing), and time-series analysis — all highly transferable.
- **Engaging topic**: The students use Shein, they see sustainability content online — this is their world.
- **Beautiful outputs**: BERTopic topic evolution visualizations, cross-posting network diagrams, annotated time-series plots.
- **Multiple viable venues**: Fashion and Textiles (Springer), Sustainable Production and Consumption, and SSRN preprint are all realistic targets.

## What Would Make This Stronger (Beyond 10-Week Scope)

These are documented for future extension, not proposed for the summer camp:

1. **TikTok data**: The platform actually driving fast fashion purchasing. TikTok Research API exists for academics but requires institutional approval and returns video metadata, not transcripts — would need whisper-based transcription.
2. **Survey validation**: Pair Reddit NLP findings with a small survey (n=200) of Reddit users about their actual purchasing behavior. Would directly test whether sentiment predicts self-reported behavior.
3. **Causal identification**: An event study design around specific Shein exposés (e.g., Channel 4 documentary) could provide quasi-causal evidence if the exposé timing is exogenous to sentiment trends.
4. **Larger temporal window**: Extending back to 2015 would give ~120 monthly observations, making Granger causality tests far more credible.
