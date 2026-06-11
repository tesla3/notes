# Proposal 2 (Final): Scrolling Toward Sustainability? Cross-Community Identity and the Attitude-Behavior Gap in Reddit Fashion Discourse

## Summary

Fast fashion's CO₂ emissions "surpass the combined outputs of France, Germany, and the UK" (Soboleva & Sánchez, arXiv 2407.18814, 2024). Shein was valued at ~$66B in 2023 and shipped 2.7B+ packages in 2022. Meanwhile, sustainability rhetoric floods social media. But decades of consumer research document a persistent "attitude-behavior gap" — "an estimated 30% of consumers indicate concern about environmental issues, yet only 5% translate this concern into action" (Young et al. 2010, cited in Belz & Peattie 2009).

This project uses NLP to study whether users' community affiliations across Reddit fashion communities reveal the attitude-behavior gap at the individual level. We frame this as a **descriptive and correlational** study, not a causal one — the data cannot establish that discourse changes behavior.

The project's **primary novel contribution** is a **cross-posting analysis** that tests whether the same users participate in both pro-sustainability and fast-fashion communities — and, if so, whether their language shifts between contexts in ways consistent with cognitive dissonance theory. No existing published work examines this cross-community identity signal in fashion discourse. Supporting analyses — topic modeling and sentiment trajectories — extend recent work by Aydin & Ogunleye (2026) with a three-method sentiment comparison and temporal evolution analysis not present in that study.

## Relationship to Prior Work

### Aydin & Ogunleye (2026) — Direct Predecessor

**This proposal must be positioned explicitly against Aydin & Ogunleye (2026), "What consumers really think about sustainable fashion: A computational analysis of online discussions," *Journal of Global Fashion Marketing*, published April 2026.** That paper analyzes "more than 116,000 posts and 283,000 comments from 20 Reddit communities focused on fashion and sustainability" using "advanced natural language processing techniques, including topic modelling and sentiment analysis" (abstract). They identify "six key themes in consumer perceptions: product lifecycle management, material sourcing, size standardization, quality vs. price considerations, social responsibility, and consumer influence" and find that "overall sentiment is predominantly positive" while "waste management and material sourcing evoke the least positive reactions" (abstract).

Aydin & Ogunleye (2026) explicitly state: "to the best of our knowledge, this is the first study to use Reddit dataset to understand fashion sustainability perceptions."

**What they do that overlaps with our RQ1 and RQ2:** Topic modeling (both LDA and BERTopic) of Reddit fashion/sustainability discourse; lexicon-based sentiment analysis across communities.

**What they do NOT do, and what constitutes our novel contribution:**

1. **Cross-community user-level analysis (our RQ3):** They analyze communities as aggregates. They do not track individual users across subreddits, compute cross-posting overlap, or compare how the same user writes in different community contexts. This is the core of our study.
2. **Temporal evolution analysis (our RQ1):** Their study is cross-sectional. They do not analyze how topics and sentiment evolve over time around events (COVID, Shein exposés).
3. **Multi-method sentiment comparison (our RQ2):** They use only lexicon-based sentiment. We compare VADER, RoBERTa, and LLM-based zero-shot classification against 500 human-annotated posts.
4. **Theoretical grounding in cognitive dissonance (our RQ3):** They do not connect their findings to the attitude-behavior gap literature or test individual-level predictions from cognitive dissonance theory.

### Other Related Work

- **"Consumer Awareness of Fashion Greenwashing: Insights from Social Media Discussions" (Sustainability, 2025):** Uses LDA on 446 Reddit comments about fashion greenwashing with cognitive dissonance as theoretical framework. Small corpus, no cross-community analysis, no temporal dimension. Demonstrates that cognitive dissonance framing is accepted in this literature.
- **"Emotional Analysis of Fashion Trends Using Social Media and AI" (arXiv 2505.00050, 2025):** Multi-platform sentiment analysis of fashion. Found that the sustainability theme had only 1,337 tweets, with 81.3% neutral — a cautionary example about sentiment tool performance in this domain. Reddit showed "generally critical discourse" relative to visual platforms.
- **Celik & Ekici (2024), "'I Crossed My Own Line, But Here is What I do': The Moral Transgressions of Sustainable Fashion Consumers," *Journal of Business Ethics*, 196, 917–936:** Qualitative study of 20 sustainable fashion consumers finding that "inconsistent behaviours of individuals within a moral framework, such as ethical consumption, give rise to psychological unease and, thereafter, a motivation to seek cognitive consonance" (citing Festinger, 1957, 1962). Documents specific dissonance-reducing strategies in fashion. Our cross-posting analysis operationalizes this at scale.

## Why Anna

Fashion Studies minor at Cornell. This isn't a bolted-on interest — she formally studied it. Combined with her Economics training (econometrics, causal reasoning) and Anthropology minor (cultural behavior lens), she's unusually well-positioned to bridge quantitative NLP methods with fashion/consumer theory. Pure CS/DS researchers lack this domain credibility. Anna's unique contribution is precisely the theoretical lens needed to interpret NLP outputs in a domain where naive sentiment ≠ purchase intent.

## Core Research Questions

1. **Descriptive** *(Extending Aydin & Ogunleye 2026)*: How do sustainability narratives on Reddit fashion communities evolve from 2019–2024 (spanning pre/post COVID, Shein's rise, and factory exposé events)? *Prior work provides a cross-sectional snapshot; we add the temporal dimension.*
2. **Comparative** *(Extending Aydin & Ogunleye 2026)*: Do sentiment trajectories and topic distributions differ systematically across sustainability-oriented communities (r/ethicalfashion, r/SustainableFashion), general fashion communities where Shein is debated (r/femalefashionadvice filtered for Shein/fast-fashion mentions), and secondhand communities (r/ThriftStoreHauls)? *Prior work uses lexicon-based sentiment only; we compare three methods against human annotations.*
3. **Cross-Community Identity** *(Primary novel contribution)*: Do users who post in sustainability-oriented communities also post about Shein in general fashion communities? If so, does their language differ between contexts in ways predicted by cognitive dissonance theory — more hedging, justification, and guilt-related language than single-community users? Cross-posting overlap as a discourse-level behavioral trace of the attitude-behavior gap.
4. **Exploratory-correlational** *(Supplementary)*: Do Reddit sentiment time-series and Google Trends search volumes for fast fashion brands exhibit lead-lag relationships at monthly frequency?

### What This Project Does NOT Claim

We do not claim that Reddit sentiment *causes* changes in consumer purchasing behavior. The attitude-behavior gap literature is clear: "perhaps the most consistent finding within this burgeoning literature has been inconsistency between what people say (or express via attitudes, values etc.) and what they actually do" (Belz & Peattie 2009, cited in Carrington et al. 2014). Our study documents discourse patterns and tests for statistical associations at the aggregate level. Interpreting these associations requires caution that we discuss explicitly in the Limitations section.

We do not claim that cross-posting constitutes *revealed preference* in the economic sense (Samuelson 1938). Posting in a subreddit is not purchasing. Cross-posting measures **community affiliation** — a behavioral trace weaker than purchase data. We do **not** claim it is stronger than survey self-report: surveys capture stated purchasing intentions while cross-posting captures community affiliation, and these measure fundamentally different constructs. Cross-posting's advantage is that it is unprompted and naturalistic; its disadvantage is that it captures discourse behavior, not consumption behavior.

### Changes From Previous Draft (with rationale)

| Change | Rationale |
|--------|-----------|
| **r/Shein removed as a primary discourse corpus** | r/Shein (~69.5K subscribers as of May 2026) is overwhelmingly a shopping-help community: sizing questions, promo code sharing, haul reviews, and logistics queries. It contains near-zero sustainability discourse. Treating it as the "fast fashion pole" of a discourse spectrum conflates product-support sentiment with sustainability attitudes. See §Data Sources for replacement strategy. |
| **Replaced with keyword-filtered Shein mentions across r/femalefashionadvice** | r/femalefashionadvice (~2.5M members) contains substantial, contested, discursive debate about Shein and fast fashion ethics. Filtering for Shein/fast-fashion keywords yields discourse directly comparable to r/ethicalfashion. |
| **Added r/SustainableFashion as primary sustainability corpus** | r/sustainability (~500K+) discusses climate policy, energy, food systems, and transportation — fashion is a small fraction of its content. r/SustainableFashion (~88K subscribers) is dedicated specifically to sustainable fashion discourse and contains active discussions about Shein, greenwashing, thrifting, and the attitude-behavior gap. It is more topically aligned than the general r/sustainability subreddit. r/sustainability is retained as a secondary corpus. |
| **Study window narrowed to 2019–2024** | Arctic Shift data derives from PushShift, which experienced ingestion disruptions after Reddit's June 2023 API lockdown. Post-2023 data must be validated before inclusion (see §Data Validation Protocol). The window may extend to mid-2025 only if monthly post volumes show no cliff-edge drops. |
| **Added LLM-based sentiment as third method** | In 2025–2026, omitting LLM-based classification from a sentiment analysis study is a methodological gap. Zero-shot GPT-3.5 "outperformed VADER on four out of five datasets" (He et al., PMC 2025). LLMs handle irony, slang, and domain-specific language — the exact failure modes this proposal identifies for VADER and RoBERTa. |
| **Updated RoBERTa model to latest version** | The original proposal cited `cardiffnlp/twitter-roberta-base-sentiment` (trained on ~58M tweets). The updated `twitter-roberta-base-sentiment-latest` was "trained on ~124M tweets from January 2018 to December 2021" (HuggingFace model card). We use the latest version. |
| **Reframed "revealed preference" as "discourse-level behavioral trace"** | Revealed preference (Samuelson 1938) refers specifically to inferring utility from actual purchasing decisions. Posting in a subreddit is not purchasing. The cross-posting signal is weaker than purchase data and measures a different construct than survey self-report. |
| **Replaced Narrative Economics (Shiller 2017) with Cognitive Dissonance (Festinger 1957) as primary theoretical frame** | Shiller's framework addresses macroeconomic fluctuations — recessions, asset prices, aggregate demand. His examples involve "spending and investing" as "basic actions" that respond to "contagious stories" (Shiller 2017, AER 107(4), p. 967). Fast fashion purchasing is driven by micro-level, hedonic, often impulsive decisions at $5–$30 price points — mechanisms the framework was not designed for. Cognitive dissonance theory generates sharper, testable predictions about dual-community users' language: the *direction* of hedging should differ by community context. Shiller is retained as supplementary context only. |
| **RQ4 demoted to supplementary/exploratory** | The cross-posting analysis (RQ3) is the novel contribution. Time-series correlation (RQ4) is exploratory and depends on data completeness that cannot be guaranteed. Centering the project on RQ3 protects the paper's contribution even if the time-series analysis proves inconclusive. |
| **BERTopic applied to user-within-thread aggregates** | Individual Reddit comments average 50–80 words. BERTopic users report "50–60% of records consistently flagged as outliers" on short text (r/LanguageTechnology, 2025). However, concatenating ALL comments under a post into one document (as previously proposed) mixes multiple authors' contradictory perspectives into a single "document," violating topic modeling's assumption of coherent topic distributions. Instead, we aggregate by **user-within-thread**: all comments by a single user in a single thread form one document, preserving authorial coherence while producing longer text units (~100–300 words). |
| **Added explicit positioning against Aydin & Ogunleye (2026)** | This April 2026 paper analyzes "more than 116,000 posts and 283,000 comments from 20 Reddit communities" using LDA, BERTopic, and lexicon sentiment. RQ1 and RQ2 must be framed as extensions of their work, not as novel. See §Relationship to Prior Work. |
| **Added power analysis requirement for RQ3** | The cross-posting overlap may yield too few dual-community users for linguistic comparison. A minimum-n threshold must be established in Week 1. See §Power Analysis. |
| **Added demographic proxy controls** | Waller & Anderson (2021) provide subreddit-level demographic embeddings (age, gender, affluence) from co-participation patterns. Without demographic controls, all cross-community comparisons are potentially confounded by user-base differences. |

## Theoretical Foundation

This project draws on three frameworks — two primary and one supplementary:

### Primary: Cognitive Dissonance and the Attitude-Behavior Gap in Sustainable Fashion

A large body of work documents that "consumers increasingly express ethical and environmental concerns regarding fashion consumption, yet consumer demand for sustainable fashion brands remains limited" (Jacobs et al. 2018; Carrigan & Attalla 2001; Lundblad et al. 2015; Niinimäki 2010). The gap is substantial: "65% of consumers stated they would purchase brands that are sustainable, yet only 26% actually did" (White, Hardisty, & Habib 2019).

Cognitive dissonance theory (Festinger 1957) provides the mechanism: when individuals hold simultaneously a belief ("fast fashion is environmentally destructive") and a behavior ("I shop at Shein"), they experience psychological discomfort and are motivated to reduce it. Celik & Ekici (2024, *Journal of Business Ethics*) demonstrate this specifically in sustainable fashion: "inconsistent behaviours of individuals within a moral framework, such as ethical consumption, give rise to psychological unease and, thereafter, a motivation to seek cognitive consonance in a variety of ways" (citing Festinger, 1957, 1962). Their qualitative study of 20 sustainable fashion consumers documents specific dissonance-reducing strategies: moral self-licensing ("My overall good behaviour makes up for this" — Klockars 1974, cited in Celik & Ekici 2024), neutralization ("I know Shein is bad but I can't afford alternatives"), and what they term "alternating moral practices" — practice-level behavioral changes that allow consumers to maintain an ethical self-concept despite transgressions.

Key barriers to closing the gap include price (Chang 2011), convenience and availability (Carrigan et al. 2001; Johnstone et al. 2015), perceived quality (Newman, Gorlin, & Dhar 2014), and social visibility — a 2024 Psychology & Marketing study (6 experiments, US consumers) found that sustainable purchasing is driven by observation, and the effect "completely disappears" when shopping privately at home.

**Cognitive dissonance generates specific, directional predictions for our cross-posting analysis (RQ3):**

- **Prediction 1 (hedging asymmetry):** Dual-community users should employ more hedging, justification, and qualification language than single-community users *in both contexts*, but the *direction* should differ: pro-sustainability justification when posting in r/ethicalfashion or r/SustainableFashion ("I know I should buy less, but..."), and pro-price/pro-convenience justification when posting in Shein-adjacent discussions ("I know it's bad, but I can't afford...").
- **Prediction 2 (moral self-licensing):** Dual-community users who recently posted in sustainability communities should be more likely to post in Shein-adjacent communities shortly afterward — the temporal signature of "moral credit" accumulation (Monin & Miller 2001, cited in Celik & Ekici 2024).
- **Prediction 3 (topic compartmentalization):** The same dual-community user should emphasize different topics depending on which community they address — environmental impact in sustainability forums, price/quality/sizing in fashion forums — reflecting what Festinger (1957) described as minimizing the importance of the dissonant element in each context.

These predictions are more specific and falsifiable than the prior draft's social identity predictions, which only predicted "more hedging" without directional specificity.

### Primary: Social Identity and Fashion as Performance

Fashion consumption is identity performance (Goffman 1959; Entwistle 2000). Online communities function as identity spaces where users signal group membership through discourse. Participation in r/ethicalfashion signals a sustainability-oriented identity; participation in Shein-discussing communities signals a price-conscious, trend-oriented identity. When the same user participates in both, they are managing competing identity commitments — what identity theorists call "role conflict" (Stryker & Burke 2000).

### Supplementary: Information Cascades (Banerjee 1992; Bikhchandani, Hirshleifer & Welch 1992)

Information cascade theory models how individuals rationally ignore their private information and imitate predecessors' observable actions. Banerjee (1992, *Quarterly Journal of Economics*, 107, 797–817) demonstrated that "it is optimal for agents to ignore their own preferences and imitate the decisions of all those who have entered ahead of them" when private signals are noisy and predecessors' actions are visible.

In online fashion communities, this framework predicts that sustainability narratives should spread in cascade-like patterns: once a threshold of sustainability discourse is established in a community, new users adopt the community's dominant framing regardless of their private beliefs about fashion consumption. This is consistent with the attitude-behavior gap — discourse adoption is cheap (mimicking the community norm), while behavioral change (actually stopping Shein purchases) is costly. We use this framework as supplementary motivation for tracking topic prevalence over time (RQ1): if narratives spread via cascades, we should observe sharp adoption inflection points around catalyzing events (Shein factory exposés, Earth Day) rather than gradual diffusion.

**Limitation:** Information cascade models assume sequential, observable decisions by rational agents (Banerjee 1992). Reddit discourse is neither sequential nor individually rational in the Bayesian sense. We apply the framework loosely as a lens for interpreting temporal patterns, not as a formal model we test.

### Supplementary: Narrative Economics (Shiller 2017)

Economic narratives — "contagious stories that spread through word of mouth and social media" — shape economic outcomes (Shiller 2017, AER 107(4), p. 967). Shiller's framework was developed for macroeconomic fluctuations: recessions, financial crises, asset price bubbles. He explicitly discusses "spending and investing" as the "basic actions" influenced by narratives.

**We do not extend this framework to fast fashion purchasing.** Consumer purchasing at $5–$30 price points operates through hedonic, impulsive, and socially mediated mechanisms (Bläse et al. 2023: "FOMO drives purchase intentions in fast fashion") that differ fundamentally from the aggregate demand shifts Shiller models. We retain Shiller's framework only as conceptual motivation for studying narrative evolution over time — not as a causal theory of consumer behavior.

**Limitations of this framework for our domain:** Critics note that Shiller's approach "reduce[s] narrative to a vocabulary word search that ignores the importance of such factors as context, genre, and tone" (Skwire, Econlib 2020). Our topic modeling approach inherits this limitation.

### Supplementary: Agent-Based Modeling of Fast Fashion Choices

Soboleva & Sánchez (arXiv 2407.18814, 2024) model how peer pressure, social media, and government interventions shift fast fashion purchasing probability using survey data from Spain (n=650). Key finding: "government interventions are pivotal, with the state's campaigns setting the overall tone for progress, although its success is conditioned by social media and polarization levels of the population." Our NLP analysis complements this by measuring the *actual* social media discourse that their model treats as a theoretical parameter.

## Data Sources

| Source | What | Role in Analysis | Access |
|--------|------|------------------|--------|
| **Reddit — r/ethicalfashion** (~117K subscribers) | Posts and comments | Primary sustainability-discourse corpus | Arctic Shift via HuggingFace |
| **Reddit — r/SustainableFashion** (~88K subscribers) | Posts and comments | Primary sustainability-discourse corpus. Dedicated sustainable fashion community — more topically focused than the general r/sustainability. Active discussions about Shein, greenwashing, thrifting, and the attitude-behavior gap. | Arctic Shift via HuggingFace |
| **Reddit — r/sustainability** (~500K+ subscribers) | Posts and comments | Secondary general-sustainability corpus. Fashion is a minority topic. Included for cross-posting overlap breadth. | Arctic Shift via HuggingFace |
| **Reddit — r/femalefashionadvice** (~2.5M subscribers), keyword-filtered | Posts/comments mentioning "shein", "fast fashion", "h&m", "zara", "primark", "cheap clothes" | Primary fast-fashion discourse corpus — captures debated, contested Shein discussion | Arctic Shift via HuggingFace + keyword filter |
| **Reddit — r/Shein** (~69.5K subscribers) | Posts and comments | Supplementary shopping-community corpus. Used for cross-posting overlap only, NOT for sentiment trajectory comparison. Content is predominantly sizing, promo codes, and logistics — not sustainability discourse. | Arctic Shift via HuggingFace |
| **Reddit — r/ThriftStoreHauls** (~4.1M subscribers) | Posts and comments | Secondhand community corpus. **Note:** Primarily a photo-sharing subreddit ("Look what I found!"). Text per post is minimal. Used for cross-posting overlap; sentiment/topic analysis limited to posts with ≥30 words of text. | Arctic Shift via HuggingFace |
| **Reddit — r/Anticonsumption** (~500K+ subscribers) | Posts and comments | Supplementary anti-consumption corpus. Contains substantial fast-fashion critique. Used for cross-posting overlap breadth. | Arctic Shift via HuggingFace |
| **Google Trends** | Relative search volume for "Shein", "sustainable fashion", "thrift", "fast fashion" | Monthly time-series for cross-correlation with sentiment (RQ4, supplementary) | trends.google.com — direct download with stability validation |
| **News API / GDELT** | Monthly mention counts for "Shein" in news media | Media-coverage control variable for RQ4 | GDELT API (free) or NewsAPI |
| **SEC filings / Quarterly earnings** | Revenue for H&M, Inditex/Zara, ThredUp | Supplementary context plots (NOT regression targets) | EDGAR / Yahoo Finance API |

### Data Sources Removed (with rationale)

| Removed | Why |
|---------|-----|
| **r/Shein as a primary discourse corpus** | r/Shein content is overwhelmingly shopping logistics (sizing, promo codes, haul reviews), not sustainability discourse. Comparing sentiment about "does this 4X fit like a US 20?" with sentiment about "fast fashion is destroying the planet" conflates unrelated constructs. r/Shein is retained only for cross-posting user-overlap analysis. |
| **r/fashionreps** | This subreddit (2.2M members) is about **counterfeit/replica luxury goods** — people buying fake Jordans and knockoff Balenciaga. Fundamentally different from fast fashion. Including it would conflate luxury-aspirational counterfeiting with cheap disposable fashion — two entirely different consumer motivations, price points, and ethical considerations. |
| **UN Comtrade** | Textile trade data operates at a national/annual level completely disconnected from subreddit-level sentiment. No methodological role was specified. |
| **SEC quarterly revenue as regression target** | 2019–2024 yields ~20 quarterly observations. The econometrics literature is unambiguous: "Credible Granger-causality analysis... is usually infeasible with samples of modest length — e.g., T ≤ 150" (Ashley & Tsang). Revenue is retained for contextual visualization only. |
| **Good On You ratings** | Scraped brand ratings add marginal value for a discourse-analysis study and introduce ToS compliance risk. Dropped entirely; brand categorization (ethical vs. fast-fashion) is done using the subreddit of origin rather than an external rating. |

### Data Validation Protocol (Critical — Run Before Any Analysis)

The following checks must be completed in **Week 1** before any analysis proceeds:

1. **Post-volume cliff-edge test**: Plot monthly post counts per subreddit from 2019 through latest available date. Arctic Shift data derives from PushShift, which experienced disruptions when Reddit locked down API access in June 2023. However, the Arctic Shift maintainer has confirmed that "aside from the specific months of April-June in 2023, there is no statistically significant change in the data collected before and after the API changes" (u/Watchful1, r/pushshift, May 2025). If any target subreddit shows a >50% drop in monthly post volume during April-June 2023, **exclude those months** and note the gap.

2. **User-deletion audit (critical for cross-posting analysis)**: A key technical difference between PushShift and Arctic Shift data affects user-level analysis: "Pushshift updated entries after ~a month (`retrieved_utc`), while arctic_shift does it after 36h... user deletion: if the user was `[deleted]` between ingestion and reingestion, pushshift would overwrite the username, while arctic_shift does not. In bulk, 23% of pushshift submissions are by `[deleted]` (24% in its last year), while for arctic_shift it is 2%" (u/joaopn, r/pushshift, May 2025). This means: (a) pre-2023 PushShift data has significantly more `[deleted]` authors, making cross-posting analysis less complete for earlier periods; (b) Arctic Shift preserves original usernames better, giving more complete cross-posting data for post-2023 periods. **Report user-deletion rates per time period and note the asymmetry in all cross-posting results.**

3. **Deleted-content audit**: Count the proportion of posts where author = `[deleted]` and body = `[removed]` per subreddit per year. Report alongside all results. Users are increasingly using automated overwrite tools: "Prevents Reddit search from exposing my private post history, limits scraping and bulk data sales" (r/RedditSafety user, 2025). If privacy-conscious users disproportionately delete sustainability-related posts, the archive under-represents a specific population.

4. **r/femalefashionadvice keyword filter yield**: Count the number of posts matching the Shein/fast-fashion keyword filter by month. If yield is < 50 posts/month for most of 2019–2024, the keyword-filtered corpus is too sparse for monthly sentiment time-series. Fallback: expand keyword list or add r/fashion as an additional source subreddit.

5. **r/ThriftStoreHauls text content check**: Compute the distribution of text length (word count) per post. If >70% of posts have <30 words of text (photo captions), the subreddit is not suitable for NLP analysis. Retain for cross-posting overlap only.

6. **Google Trends stability**: Download each query 3× on different days; compute coefficient of variation (CV%). "Irregularities in the random sampling and aggregation algorithms compromise the reliability of the relative search volume (RSV)" (ScienceDirect 2024). Discard any series with CV% > 5%.

7. **Cross-posting user count and power analysis (critical for RQ3)**: Count the number of users active in both sustainability-oriented subreddits (r/ethicalfashion, r/SustainableFashion) and fast-fashion-adjacent contexts (r/Shein, Shein-mentioning posts in r/femalefashionadvice). See §Power Analysis for minimum-n thresholds. **If dual-community user count falls below the threshold, the dual-community linguistic analysis (RQ3 Predictions 1–3) is infeasible and should be replaced with community-level overlap statistics only.**

### Key Context for Framing

- Shein valued at ~$66B (2023), shipped 2.7B+ packages in 2022.
- "FOMO drives purchase intentions in fast fashion" even among sustainability-aware consumers (Bläse et al. 2023, n=650).
- Agent-based modeling shows government interventions are pivotal but "social media bias can dominate" in shifting public opinion on fast fashion (Soboleva & Sánchez, arXiv 2407.18814, 2024).
- The attitude-behavior gap in sustainable fashion is extensively documented: "consumers with an ethical mindset hold a sense of responsibility towards the environment and society, and wish to express their values and beliefs through their purchasing behavior" yet "consumer demand for sustainable fashion brands remains limited" (Jacobs et al. 2018; Carrigan & Attalla 2001; Bocti et al. 2021).
- A 2024 Psychology & Marketing study (6 experiments, US consumers) found that sustainable purchasing is driven by social visibility — consumers buy sustainably when observed, but the effect "completely disappears" when shopping privately at home.

## ML Methods (Teachable in 10 Weeks)

### Pre-Camp Preparation (Mentor/TA responsibility)

To protect the 10-week timeline from data-engineering delays:

- **Pre-download** Arctic Shift Parquet shards for all target subreddits (r/ethicalfashion, r/SustainableFashion, r/sustainability, r/femalefashionadvice, r/Shein, r/ThriftStoreHauls, r/Anticonsumption) for 2019–2025.
- **Pre-filter** r/femalefashionadvice for Shein/fast-fashion keyword matches.
- **Pre-run** the Data Validation Protocol (§above) and document results so students begin Week 1 with a known-clean corpus.
- **Pre-install** Python environment with all dependencies (transformers, bertopic, statsmodels, pandas, etc.).
- **Pre-draft annotation guide** (Anna drafts before Week 1): Define sentiment categories with domain-specific examples. Include edge cases: irony ("Shein haul! Got 47 pieces for $12, definitely saving the planet 🌍"), hedging ("I know Shein is bad but..."), and subreddit-specific jargon. This is moved to pre-camp because annotation guide design for fashion discourse requires domain expertise and typically takes a week of iteration.

Estimated pre-camp effort: ~12–16 hours of compute + scripting + annotation guide drafting.

### Week 1–2: Corpus Assembly, EDA & Cross-Posting Census

- **Start from pre-downloaded data.** Students clean, deduplicate, and structure the corpus into analysis-ready DataFrames (one row per post/comment, columns: subreddit, author, timestamp, text, score).
- **EDA**: Post volume over time per subreddit (this also completes cliff-edge validation). Word-frequency distributions. Subreddit subscriber-count vs. post-count comparison.
- **Cross-posting user census (critical path for RQ3)**:
  - Extract unique usernames from all 7 target subreddits.
  - Build a user × subreddit participation matrix.
  - Count dual-community users (sustainability-oriented + fast-fashion-adjacent).
  - **Run the power analysis** (see §Power Analysis). If dual-community users < minimum-n threshold, convene with mentor to decide whether to (a) expand subreddit list, (b) relax the "active in both" threshold, or (c) narrow RQ3 to community-level overlap statistics only.
- **Pilot annotation**: Using Anna's pre-drafted guide, team pilot-annotates 20 posts to calibrate. Revise guide based on disagreements.
- **Demographic proxy computation**: Apply Waller & Anderson (2021) subreddit co-participation method (see §Demographic Controls) to estimate age, gender, and affluence distributions per subreddit user base.
- **Target corpus size**: 50K–100K posts/comments across all subreddits, 2019–2024.

### Week 3–4: Sentiment Analysis — Three Methods + Annotation

We apply three sentiment methods of increasing sophistication to the same corpus, reporting agreement rates as a robustness check:

**Method 1 — VADER (Lexicon baseline)**:
- Used as a **floor**, not a primary model.
- Known limitations: VADER achieves F1 ≈ 0.70 on fashion-related content (fashion-nova reviews benchmark) and "struggles with sarcasm and context-dependent expressions" (arXiv 2504.15448, 2025). "The predefined lexicon in VADER may not fully capture the sentiment of domain-specific terms or new slang" (VADER Comprehensive Overview, 2024).

**Method 2 — RoBERTa (Transformer baseline)**:
- HuggingFace `cardiffnlp/twitter-roberta-base-sentiment-latest` — "trained on ~124M tweets from January 2018 to December 2021, and finetuned for sentiment analysis with the TweetEval benchmark" (HuggingFace model card, cardiffnlp).
- **Critical domain-shift warning**: The model documentation explicitly states: "Domain shift outside Twitter. While this model was trained on tweets, its performance on other social platforms, customer reviews, news comments, or non-social text is not documented. Applying it to Reddit comments, Facebook posts, or product reviews likely produces degraded results compared to models trained on those specific domains" (aimodels.fyi, twitter-roberta-base-sentiment-latest documentation, 2025).
- **Training cutoff is December 2021**: The model has never seen post-2021 slang, Shein-specific discourse, or post-COVID language shifts. Our study extends to 2024 — 3 years of linguistic drift.
- One practitioner reported "accuracy at around 67%" on non-Twitter data (r/LanguageTechnology, 2024).

**Method 3 — LLM zero-shot classification (New)**:
- Use a locally-run open-weight model (Llama 3 8B or Qwen2.5 7B) with a structured prompt for three-class sentiment classification.
- Rationale: Zero-shot GPT-3.5 "outperformed VADER on four out of five datasets" on social media sentiment (He et al., PMC 2025). LLMs handle exactly the failure modes VADER and RoBERTa struggle with: irony, domain-specific slang, context-dependent expressions.
- A local model avoids API costs and data-privacy concerns of sending Reddit content to commercial APIs.
- **Known limitation**: "Fine-tuned 'small' LLMs (still) significantly outperform zero-shot prompted larger models" when training data exists (Burnham et al., arXiv 2406.08660, 2024). Our LLM is used as one of three methods, not as a replacement for fine-tuned models.

**Manual annotation** (CRITICAL):
- Manually label **500 Reddit posts** (stratified: ~70 per target subreddit for 7 subreddits) for sentiment ground truth.
- This enables: (a) measuring all three models' accuracy on our specific domain, (b) reporting inter-annotator agreement (Cohen's kappa ≥ 0.70 target), (c) identifying systematic failure modes per model.
- **Annotation allocation**: Each of the 4 team members annotates ~125 posts. 100 posts are annotated by two team members to compute inter-annotator agreement.
- **Separation of evaluation and augmentation sets**: The 500 human-annotated posts constitute the **evaluation set** and must remain exclusively human-labeled. If LLM silver labels are used to fine-tune or augment models, they must be drawn from a **separate pool** of unannotated posts. Using the LLM as both a classification method (Method 3) and a generator of validation labels would create circular evaluation — the LLM cannot be independently assessed against labels it helped produce.
- **Contingency plan**: If all three methods score < 0.65 accuracy against human annotations, we (a) report this as a substantive finding about the inadequacy of off-the-shelf sentiment tools for fashion discourse, (b) use the LLM to generate aspect-based annotations (extracting stance toward specific topics: "sustainability", "price", "quality") rather than document-level polarity, which may recover domain-specific nuance, and (c) proceed with topic modeling (which does not depend on sentiment labels) as the primary analytical method.

**What all three methods will miss**: Fashion-specific irony ("Shein haul! Got 47 pieces for $12, definitely saving the planet 🌍"), subculture jargon ("fire", "heat", "drip" as positive valence), Gen Z register ("no cap", "slay", "ate and left no crumbs"). The 500-post annotation will quantify how often each method fails on each category.

### Week 3–4 (parallel): Google Trends & GDELT Setup

- **Google Trends**: Direct CSV download from trends.google.com (NOT `pytrends`). Stability validation per protocol above. *Moved from Week 1–2 to reduce first-sprint overload. RQ4 is supplementary and does not block RQ3.*
- **News media control**: Download monthly "Shein" mention counts from GDELT or NewsAPI for use as a control variable in RQ4.

### Week 5–7: Topic Modeling & Cross-Posting Analysis

**Topic Modeling with BERTopic (on user-within-thread aggregates)**:

- **Document unit**: For each thread, aggregate all comments by a **single user** into one document, prepended by the post title. This produces documents of ~100–300 words while preserving authorial coherence.
- **Why not thread-level aggregation**: Concatenating ALL comments under a post (as previously proposed) mixes multiple authors' contradictory perspectives into a single document. A thread about Shein may contain pro-Shein comments ("great deals for my budget"), anti-Shein comments ("slave labor"), neutral logistics comments ("when does shipping take"), and meta-comments ("can we stop arguing about this"). Topic modeling assumes documents have coherent latent topic distributions; a document with contradictory signals produces a centroid that represents no one's actual position. User-within-thread aggregation maintains coherent authorial perspective.
- **Fallback for very short documents**: If user-within-thread aggregation still produces documents too short for BERTopic (median <50 words), aggregate all comments by a single user *within a single subreddit within a single month*. This produces user-period documents suited for tracking individual-level topic evolution.
- BERTopic uses sentence-transformer embeddings → UMAP dimensionality reduction → HDBSCAN clustering → c-TF-IDF topic representation. Students use it as a **high-level API** (`BERTopic().fit_transform(docs)`) — they do not need to understand UMAP/HDBSCAN internals.
- Set `min_topic_size=30` to prevent micro-topics.
- **LDA as primary baseline for comparison**: LDA is actually more stable on shorter documents and does not produce outlier bins. If BERTopic's outlier rate exceeds 40% even after user-within-thread aggregation, LDA becomes the primary method and BERTopic supplementary.
- **Known issue**: "When used with HDBSCAN, BERTopic creates a bin for topic outliers, which can sometimes contain over 74% of the dataset" (Grljević et al., arXiv 2402.03067, 2024). Mitigation: use `reduce_outliers()` with c-TF-IDF strategy; report outlier percentage before and after reduction.
- Expected topics: "labor exploitation", "environmental guilt", "price justification", "thrifting as identity", "greenwashing skepticism", "sizing/logistics" (Shein-specific).
- Track topic prevalence over time — do narratives shift around events (Shein factory exposés, Earth Day, COVID lockdowns)?
- Visualize topic evolution with BERTopic's built-in `visualize_topics_over_time()`.

**Cross-Posting Analysis** *(Primary novel contribution)*:

- For each user who posted in any of the 7 target subreddits, check whether they also posted in other target subreddits.
- Compute pairwise user-overlap matrices using **two metrics**:
  - **Jaccard similarity**: |A ∩ B| / |A ∪ B|. Standard but sensitive to size asymmetry.
  - **Szymkiewicz–Simpson coefficient (overlap coefficient)**: |A ∩ B| / min(|A|, |B|). Normalizes by the smaller community, preventing large subreddits (r/ThriftStoreHauls at 4.1M members) from dominating the denominator. Methodological precedent: "Investigating Human Values in Online Communities" (arXiv 2402.14177, 2024) defines user similarity as the overlap coefficient between subreddit user sets.
- **Key tests**:
  - What fraction of r/ethicalfashion users also post about Shein in r/femalefashionadvice or r/Shein? High overlap = discourse-level evidence of co-occurring community affiliations. Low overlap = distinct, non-overlapping communities.
  - What fraction of r/ThriftStoreHauls users also discuss fast fashion in other subreddits?
  - What fraction of r/SustainableFashion users overlap with r/Anticonsumption vs. r/Shein?
- **Dual-community user analysis** (the core novelty):
  - Identify users active in both sustainability-oriented (r/ethicalfashion, r/SustainableFashion) and fast-fashion-adjacent (r/Shein, Shein-mentioning posts in r/femalefashionadvice) communities.
  - Test the three cognitive dissonance predictions (§Theoretical Foundation):
    - **Prediction 1 (hedging asymmetry)**: Compare hedging/justification language rates between dual-community and single-community users, and between the same dual-community user's posts in different community contexts.
    - **Prediction 2 (moral self-licensing temporal sequence)**: Among dual-community users, test whether posts in sustainability communities are followed (within 7/14/30 days) by posts in fast-fashion communities at above-chance rates.
    - **Prediction 3 (topic compartmentalization)**: Compare topic distributions of dual-community users' posts across contexts.
  - This approach is methodologically grounded: "Cross-Subreddit Behavior as Open-Source Indicators of Coordinated Influence" (Pilaud & McCulloh, arXiv 2507.16857, 2025) uses exactly this method — "topic modeling and sentiment analysis are applied to all posts and comments authored by dual-subreddit users to construct a user–topic sentiment matrix." That study found **63 dual-subreddit users** between r/Sino and r/China.

### Power Analysis for RQ3 (Critical — Determines Feasibility)

The Pilaud & McCulloh (2025) precedent found 63 dual-subreddit users between ideologically opposed communities. Fashion communities may have lower overlap (less polarized) or higher (more people interested in both fashion and sustainability). We cannot predict in advance.

**Minimum thresholds for RQ3 predictions:**

| Analysis | Minimum dual-community users needed | Rationale |
|----------|-------------------------------------|-----------|
| Community-level overlap statistics (Jaccard, overlap coefficient) | Any number ≥ 1 | Descriptive; no statistical test |
| Prediction 1: hedging comparison (Mann-Whitney U, dual vs. single) | n ≥ 50 dual-community users | Medium effect size (d=0.5), α=0.05, power=0.80 |
| Prediction 2: temporal sequence test (permutation test) | n ≥ 30 dual-community users with ≥3 posts in each context | Need sufficient within-user temporal variation |
| Prediction 3: topic distribution comparison (KL divergence) | n ≥ 50 dual-community users with ≥5 posts per context | Need stable per-user topic estimates |

**If dual-community user count falls below 50:** The linguistic predictions (P1–P3) become infeasible. The paper pivots to: (a) community-level overlap statistics as the primary RQ3 result, supplemented by (b) qualitative close-reading of all available dual-community users' posts. This is still publishable — it documents whether the communities are genuinely segmented — but the theoretical contribution narrows. See §Risks for why a null result in overlap is uninterpretable without additional controls.

### Demographic Controls via Subreddit Co-Participation Proxies

Without demographic controls, differences in sentiment or topic distribution between subreddits may reflect *who uses each community* rather than *how sustainability is discussed*. For example, r/femalefashionadvice skews female; r/ethicalfashion likely skews higher-income and higher-education; r/ThriftStoreHauls may skew lower-income.

We apply the method of Waller & Anderson (2021), which "assign[s] a score for different demographic axes (such as age, gender, and affluence) and social axes (political leaning) to each subreddit" based on subreddit co-participation embeddings (described in arXiv 2302.07598, 2023). Users are scored by the weighted average of their subreddit participation scores: "A user's z-score for an attribute is the weighted average of the subreddit z-scores, weighted by the number of comments the user posted in each subreddit" (arXiv 2502.05049, 2025).

**Implementation**: For each user in our cross-posting analysis, compute age, gender, and affluence proxy scores from their full subreddit participation history (not limited to our 7 target subreddits). Include these as control variables when comparing dual-community vs. single-community users. If dual-community users are systematically younger or more affluent than single-community users, the hedging/justification differences may reflect demographics rather than cognitive dissonance.

**Limitation**: Waller & Anderson's method relies on "arbitrarily defined poles for each attribute, which have not been rigorously tested or validated" and "the use of a neural embedding-based model (Word2Vec) introduces additional challenges, as it renders the model a black box" (arXiv 2502.05049, 2025). The proxies are crude. We use them as controls to flag confounds, not as precise demographic measurements.

**Subreddit size asymmetry — must be reported and addressed**:

| Subreddit | Approximate subscribers (May 2026) | Content type |
|-----------|------------------------------------|--------------|
| r/ThriftStoreHauls | ~4.1M | Primarily photo-sharing; minimal text |
| r/femalefashionadvice | ~2.5M | Discussion-heavy; Shein is debated |
| r/sustainability | ~500K+ | General sustainability discussion |
| r/Anticonsumption | ~500K+ | Anti-consumption; fast-fashion critique |
| r/ethicalfashion | ~117K | Discussion-heavy; brand recommendations |
| r/SustainableFashion | ~88K | Sustainable fashion discussion |
| r/Shein | ~69.5K | Shopping logistics: sizing, promo codes |

These size differences create incomparable populations for Jaccard similarity. A small absolute overlap with r/ThriftStoreHauls's 4.1M users will appear negligible even if meaningful relative to r/ethicalfashion's 117K. The Szymkiewicz–Simpson coefficient addresses this. All cross-posting results must be reported with both metrics and with raw overlap counts, not just percentages.

### Week 7–9: Time-Series Correlation Analysis (Supplementary — RQ4)

**This section is exploratory. Results from RQ4 are presented as supplementary analysis. The paper's contribution does not depend on significant time-series findings.**

**Monthly sentiment ↔ Google Trends cross-correlation**:
- Align monthly Reddit sentiment scores (from the best-performing sentiment method per the annotation validation) with monthly Google Trends RSV for matching search terms.
- Study window yields ~60–72 monthly observations depending on post-2023 data availability.
- **Pre-specified hypothesized mechanism and direction**: We hypothesize that Reddit sustainability discussion leads Google search interest for "Shein" and "fast fashion" (Reddit surfaces awareness → people Google it). An alternative mechanism — that external events (media coverage, TikTok trends) drive both simultaneously with different lag structures — is the null hypothesis we must rule out using the news-media control variable.
- **Stationarity first**: Run ADF and KPSS tests on all series. If non-stationary, first-difference before any correlation analysis. "Time-series data often contains unit-root and the correlation between such series often results in high coefficient value and t-statistics... it can increase the likelihood of obtaining spurious correlations" (Ono et al., BMC Medical Research Methodology, 2021).
- **Media-coverage confound**: Include monthly Shein news-mention counts (from GDELT) as a control variable. Ono et al. (2021) demonstrated this exact problem: "both the Granger-causality of the keywords 'loss of smell' and 'sense of smell' to the weekly COVID-19 positivity trend became non-significant when adjusted with their media coverage by partial Granger-causality analysis (p = 0.257 and p = 0.384, respectively)." If our Reddit→Google correlation disappears when controlling for news media, this is an important negative finding — it means Reddit discourse does not independently predict search behavior.
- **Cross-correlation**: Compute lagged Pearson correlation (lags 0–6 months) between sentiment and search volume. Report with confidence bands.
- **Exploratory Granger test**: Monthly sentiment → monthly Google Trends, with lag selection via AIC/BIC. Frame as "predictive association." Maximum 3–4 variables in the VAR (sentiment, Google Trends, news mentions, Consumer Confidence Index) to preserve degrees of freedom.
- **Multiple comparisons**: With 3 subreddit sentiment series × 4 Google Trends keywords × 6 lag periods = 72 individual correlations. Bonferroni correction reduces α to 0.0007. Given ~60–72 observations, statistical power at this α is low. We report this constraint explicitly and distinguish pre-registered primary tests (3 keyword pairs specified in advance) from exploratory tests.
- **Supplementary visualization only**: Overlay quarterly revenue time-series for H&M, Inditex, ThredUp against sentiment trends. Present as visual context, not statistical test.

**Why 72 observations is marginal for Granger analysis**:
A reviewer on ResearchGate, responding to a question about Granger causality with 27 yearly observations, stated: "Granger causality test is very sensitive and it varies a lot with sample sizes. With only 27 observations, it is doubtful that granger causality test will give reliable result. One of my paper[s] rejected by a reviewer because I used granger causality test for 33 yearly data" (Meerza, ResearchGate 2014). Our 60–72 monthly observations is better but still below the ≥150 threshold cited by Ashley & Tsang for credible results. We frame all Granger results as "suggestive" and "exploratory."

### Week 9–10: Paper Writing & Visualization

- **Primary figures** (RQ3): Cross-posting overlap matrix (heatmap with both Jaccard and Szymkiewicz–Simpson); dual-community user sentiment comparison (violin plots); hedging-language frequency comparison; topic-distribution shift for dual- vs. single-community users; temporal sequence analysis (if n permits).
- **Supporting figures** (RQ1, RQ2): Time-series plots — sentiment trajectories per subreddit with event annotations (COVID, Shein exposés, Earth Day); BERTopic topic evolution heatmaps.
- **Supplementary figures** (RQ4): Cross-correlation plots with confidence bands; revenue overlay (context only).
- **Methodological figures**: Three-way sentiment model agreement matrix; annotation inter-rater agreement; BERTopic outlier rates; demographic proxy distributions per subreddit.
- Write-up: ~20–25 pages.

## Team Task Allocation

| Team Member | Weeks 1–2 | Weeks 3–4 | Weeks 5–7 | Weeks 7–10 |
|-------------|-----------|-----------|-----------|------------|
| **Student A** | Corpus assembly from pre-downloaded data; deduplication; DataFrame construction | Manual annotation (125 posts); LLM sentiment pipeline (local model setup + inference) | Cross-posting user-overlap computation (both metrics); power analysis | Supplementary time-series analysis (RQ4) |
| **Student B** | Cross-posting user census; user × subreddit matrix; demographic proxy computation (Waller & Anderson) | Manual annotation (125 posts); VADER sentiment pipeline; Google Trends + GDELT download | BERTopic topic modeling (user-within-thread aggregation) | Topic evolution figures; BERTopic diagnostics |
| **Student C** | EDA: post volume trends, text-length distributions, subreddit statistics, cliff-edge validation, user-deletion audit | Manual annotation (125 posts); RoBERTa sentiment pipeline | Three-way sentiment agreement analysis (VADER vs. RoBERTa vs. LLM); hedging-language lexicon construction | All figures and tables for paper |
| **Anna** | Research design; annotation guide refinement (from pre-camp draft); literature review finalization (attitude-behavior gap, cognitive dissonance, social identity) | Manual annotation (125 posts); inter-annotator agreement computation | Dual-community user analysis: cognitive dissonance predictions (P1–P3); sentiment + topic comparison with demographic controls | Paper writing; framing; econometric testing (stationarity, Granger) |

## Publication Targets

| Venue | Fit | Realistic? |
|-------|-----|------------|
| **Fashion and Textiles** (Springer) | Directly relevant; accepts mixed-methods. Position against Aydin & Ogunleye (2026) in same domain. | ✅ Strong fit |
| **Sustainable Production and Consumption** | Sustainability + consumer behavior | ✅ Good fit |
| **SSRN / arXiv preprint** | Immediate visibility | ✅ Do this first |
| **Sustainability** (MDPI, IF ~3.9) | Open access; accepts NLP + sustainability. Note: the Fashion Greenwashing paper (2025) was published here. | ✅ Good fallback |
| **ACM Conference on Web Science** | Cross-posting analysis + cognitive dissonance framing is a strong computational social science contribution | ⚠️ Possible if methods are foregrounded |
| ~~*Journal of Cleaner Production*~~ | Expects rigorous causal identification (IV, DiD, RCT), not correlations | ❌ Removed — would likely desk-reject |
| ~~*Journal of Consumer Research*~~ | Requires survey/experimental data, not observational NLP | ❌ Removed — wrong methodology for venue |

## Risks, Unknowns, and Open Questions

### Data Risks

| Risk | Severity | Mitigation | Residual Uncertainty |
|------|----------|------------|---------------------|
| **Arctic Shift post-2023 data gaps** | Medium (downgraded) | The Arctic Shift maintainer has confirmed data completeness: "aside from the specific months of April-June in 2023, there is no statistically significant change in the data collected before and after the API changes" (u/Watchful1, r/pushshift, May 2025). **Validation**: Plot monthly post counts per subreddit. Exclude April-June 2023 if volumes drop. | Score/attention data has a known issue: "Until 11/2023 arctic_shift didn't update entries, meaning between 07-10/2023 score is ~zero" (u/joaopn, r/pushshift, May 2025). Do not use post scores from July-October 2023 period. |
| **User-deletion asymmetry between PushShift and Arctic Shift eras** | High (for cross-posting) | PushShift overwrote `[deleted]` authors (23% of submissions in its last year), while Arctic Shift preserves them (only 2%). This means cross-posting analysis is systematically less complete for pre-2023 data — users who deleted accounts are invisible in the earlier period but visible in the later period. **Report user-deletion rates per period and note the asymmetry.** | This creates a temporal confound: apparent increases in cross-posting over time may partially reflect better data preservation rather than genuine behavioral changes. |
| **Deleted/overwritten content biases the archive** | Medium | Count proportion of `[deleted]`/`[removed]` posts per subreddit per year. Report alongside all results. | If privacy-conscious users disproportionately delete sustainability-related posts (e.g., to avoid brand association), the archive under-represents a specific population. We cannot detect or correct for this. |
| **r/femalefashionadvice keyword filter yield unknown** | Medium | Validate in Week 1. If < 50 Shein-mentioning posts/month, expand keyword list or add r/fashion, r/PlusSize, r/PlusSizeFashion as additional source subreddits. | Keyword filtering introduces its own bias: it captures explicit mentions of "Shein" but misses coded/indirect references. |
| **Google Trends instability** | Medium | "Subregional datasets can be highly unstable (e.g., CV% = 10)" (ScienceDirect 2024). Download each query 3× on different days; compute CV%; discard any series with CV% > 5%. Use direct CSV download, not `pytrends`. | Even with validation, RSV is relative (not absolute volume), and Google's normalization algorithm is undocumented. |

### Methodological Risks

| Risk | Severity | Mitigation | Residual Uncertainty |
|------|----------|------------|---------------------|
| **All three sentiment models fail on fashion discourse** | High | The 500-post manual annotation quantifies failure rate for each method. **Contingency**: If all methods score < 0.65 accuracy, switch to aspect-based analysis via LLM. | No fashion-specific sentiment model exists. VADER was built in 2014. RoBERTa's training ended in 2021. Even the LLM approach has known limitations. |
| **BERTopic outlier problem on Reddit text** | Medium | User-within-thread aggregation preserves authorial coherence while producing longer documents (~100–300 words). Set `min_topic_size=30`. Use `reduce_outliers()` with c-TF-IDF strategy. Report outlier % before and after reduction. If outlier rate > 40% after all mitigations, promote LDA to primary method. | "BERTopic creates a bin for topic outliers, which can sometimes contain over 74% of the dataset" (Grljević et al., arXiv 2402.03067, 2024). |
| **Cross-posting overlap may be negligibly small** | High | Power analysis in Week 1 determines feasibility. If < 50 dual-community users, pivot to community-level overlap statistics + qualitative close-reading. **This is still publishable** but the theoretical contribution narrows. | **A null result in overlap is NOT straightforwardly interpretable** (see §Conceptual Risks, "Alt-account selection paradox"). |
| **Multiple comparisons in time-series analysis** | Medium | 72 individual correlations. Bonferroni correction reduces α to 0.0007. Pre-register 3 primary keyword pairs. Distinguish confirmatory from exploratory findings. | Even with correction, the risk of garden-of-forking-paths reasoning is real. |
| **Granger causality unreliable at this sample size** | High | 60–72 monthly observations is below the ≥150 threshold cited by Ashley & Tsang. All Granger results labeled "suggestive" and "exploratory." **RQ4 is supplementary** — the paper's contribution does not depend on these results. | Even with proper disclaimers, reviewers may view Granger tests with 60–72 observations as methodologically insufficient. |

### Conceptual Risks

| Risk | Severity | Discussion |
|------|----------|------------|
| **Alt-account selection paradox (CRITICAL for RQ3)** | **Very High** | The cross-posting analysis can only detect users who post in both sustainability and fast-fashion communities **under the same username**. This creates a paradox: (a) Users who DON'T feel cognitive dissonance about participating in both communities have no reason to separate identities — they are the *least* interesting cases of the attitude-behavior gap. (b) Users who DO feel the gap — guilt, shame, identity conflict — are precisely the users most likely to use separate accounts, making them *systematically invisible*. **The analysis selects for the wrong population.** High cross-posting overlap could mean "many people feel comfortable in both spaces" (weak gap). Low overlap could mean "people feel the gap so strongly they use alts to separate identities" (strong gap, but invisible). Both outcomes are consistent with both hypotheses. **Mitigation strategies**: (1) Report the finding with this paradox stated explicitly. (2) Compute a **sensitivity analysis**: "If X% of r/ethicalfashion users maintain separate alt-accounts for fast-fashion activity, how would this change the observed overlap rate?" Show the overlap range for plausible alt-account rates (2%–10%). (3) If sufficient data, explore **stylometric analysis** as a pilot: writing-style similarity between anonymous accounts has been demonstrated to achieve ~90% accuracy in identifying alternate accounts (stylometry.net, HN analysis, 2022). This is beyond the 10-week scope but should be flagged as a future direction. (4) Acknowledge that the cross-posting signal is a **lower bound** on the true overlap. |
| **Reddit ≠ fashion consumers** | High | Reddit's demographics have shifted — "in the UK and the US, Reddit's surging user base is now more than 50% women" and "high-growth areas have been fashion, beauty, TV fandom" (Reddit VP, Vogue 2025). However, Reddit users who post in fashion subreddits are still a self-selected, text-literate minority. Reddit captures discourse *about* fast fashion; it does not capture the primary *driver* of fast fashion purchasing (TikTok haul videos, Instagram ads). |
| **Cross-posting ≠ purchasing** | High | Posting in r/Shein does not mean purchasing from Shein. A user active in both r/ethicalfashion and r/Shein could be: (a) a critic monitoring the brand, (b) someone asking about sizing for a gift, (c) someone who bought once, regretted it, and posts warnings, or (d) genuinely expressing the attitude-behavior gap. We cannot distinguish these cases without reading every post. The cognitive dissonance linguistic predictions (P1–P3) partially address this — users expressing guilt or justification are more likely to be case (d). But the ambiguity is irreducible. |
| **Attitude-behavior gap may render all discourse analysis irrelevant** | High | The core finding of this literature is that pro-sustainability sentiment does NOT predict sustainable purchasing: "65% of consumers stated they would purchase brands that are sustainable, yet only 26% actually did" (White, Hardisty, & Habib 2019). If discourse is systematically disconnected from behavior, then our entire analysis describes a phenomenon (discourse patterns) with no demonstrated link to the phenomenon of interest (purchasing behavior). We address this by framing our contribution as descriptive — we document how people *talk* about fast fashion, not how they *act* — and by acknowledging the gap explicitly. |
| **Confounders in any sentiment ↔ market signal relationship** | High | COVID lockdowns (2020–2021) drove massive simultaneous shifts in online discourse and retail revenue. Any correlation during this period is likely confounded. Currency effects (H&M reports in SEK, Inditex in EUR) affect comparisons. Shein's competitive displacement of H&M/Zara reflects market dynamics, not sentiment shifts. Even the news-media control variable cannot account for all confounders. |
| **Pseudonymity and alt-accounts** | High (upgraded) | Reddit users commonly maintain multiple accounts. Throwaway account prevalence is estimated at 2.6%–3.8% among active commenters in general (shaggorama, r/TheoryOfReddit, 2012), but "a rather small percentage of users in our dataset used throwaway accounts (1,209 users; 4.46%)" in mental health communities (cited in Sciencedirect 2024 participant behavior study). Fashion/sustainability communities may have intermediate rates. The rate of *persistent alt-accounts* (not throwaways) is unknown and likely higher. **Impact on RQ3**: Cross-posting analysis systematically underestimates overlap. See alt-account selection paradox above. |
| **Demographic confounds in cross-community comparisons** | Medium | Subreddit user bases differ in age, gender, income, and geography. The Waller & Anderson (2021) demographic proxies provide crude but useful controls. Without them, all sentiment/topic differences between subreddits could be demographic artifacts. Even with them, the proxies are noisy. |
| **Novelty erosion from Aydin & Ogunleye (2026)** | Medium | RQ1 and RQ2 are no longer novel in isolation. The paper's contribution depends critically on RQ3 (cross-posting) and the cognitive dissonance framing. If RQ3 produces insufficient data (low dual-community user count), the remaining contribution reduces to "replication of Aydin & Ogunleye with more methods" — publishable but thin. |

### Ethics

- **IRB**: The research protocol should be reviewed by the supervising institution's IRB. All data is publicly available, but: "research has shown that users often have differing understandings of what it means for [their data to be public]" (Fiesler et al., ACM CSCW 2024). Reddit users posting about personal fashion choices may not expect their posts to be analyzed in an academic study.
- **Data handling**: All usernames replaced with anonymized identifiers after cross-posting matrix construction. Raw username data stored securely and deleted after analysis. "All collected data is securely stored, with access restricted to the research team. After identifying [relevant] accounts, all account names were replaced with unidentifiable labels" (arXiv 2501.17430, USEC 2025).
- **Stylometric analysis ethics note**: If stylometric alt-account detection is explored (even as a pilot), this raises additional privacy concerns. Stylometric methods have been demonstrated to identify users across accounts with ~90% accuracy (stylometry.net, 2022). Using such methods to link accounts a user deliberately separated raises ethical questions about respecting pseudonymity. Any stylometric analysis should be discussed with the IRB and results reported only in aggregate (e.g., "estimated alt-account rate") without identifying specific users.
- **No individual-level reporting**: Results reported at the aggregate level only. No individual user's posting history is reproduced in the paper. Direct quotes from Reddit posts paraphrased or anonymized.

## Key References

### Prior Work — Direct Predecessors
- **Aydin, G. & Ogunleye, B. (2026).** "What consumers really think about sustainable fashion: A computational analysis of online discussions." *Journal of Global Fashion Marketing*. DOI: 10.1080/20932685.2026.2646924. [116K posts + 283K comments from 20 Reddit communities; LDA + BERTopic + lexicon sentiment. Direct predecessor to our RQ1/RQ2.]
- **"Consumer Awareness of Fashion Greenwashing: Insights from Social Media Discussions" (2025).** *Sustainability*, 17(7), 2982. [LDA on Reddit greenwashing; cognitive dissonance as framework. 446 comments, 12 posts.]

### Primary Literature (Cognitive Dissonance and Attitude-Behavior Gap)
- Festinger, L. (1957). *A Theory of Cognitive Dissonance*. Stanford University Press.
- Celik, H. & Ekici, A. (2024). "'I Crossed My Own Line, But Here is What I do': The Moral Transgressions of Sustainable Fashion Consumers and Their Use of Alternating Moral Practices as a Cognitive-Dissonance-Reducing Strategy." *Journal of Business Ethics*, 196, 917–936.
- Carrigan, M. & Attalla, A. (2001). "The myth of the ethical consumer — do ethics matter in purchase behaviour?" *Journal of Consumer Marketing*, 18(7), 560–578.
- Carrington, M.J., Neville, B.A., & Whitwell, G.J. (2014). "Lost in translation: Exploring the ethical consumer intention–behavior gap." *Journal of Business Research*, 67(1), 2759–2767.
- White, K., Hardisty, D.J., & Habib, R. (2019). "The elusive green consumer." *Harvard Business Review*.
- Jacobs, K. et al. (2018). Sustainable fashion consumption.
- Monin, B. & Miller, D.T. (2001). "Moral credentials and the expression of prejudice." *Journal of Personality and Social Psychology*, 81(1), 33–43. [Moral self-licensing framework used by Celik & Ekici 2024.]
- Bläse, R. et al. (2023). "Non-sustainable buying behavior: FOMO drives purchase intentions in fast fashion." Wiley.

### Social Identity and Performance
- Goffman, E. (1959). *The Presentation of Self in Everyday Life*. Doubleday.
- Entwistle, J. (2000). *The Fashioned Body: Fashion, Dress and Modern Social Theory*. Polity Press.
- Stryker, S. & Burke, P.J. (2000). "The past, present, and future of an identity theory." *Social Psychology Quarterly*, 63(4), 284–297.

### Information Cascades
- Banerjee, A. (1992). "A simple model of herd behavior." *Quarterly Journal of Economics*, 107(3), 797–817.
- Bikhchandani, S., Hirshleifer, D., & Welch, I. (1992). "A theory of fads, fashion, custom, and cultural change as informational cascades." *Journal of Political Economy*, 100(5), 992–1026.

### NLP Methods and Sentiment Analysis
- He, Y. et al. (2025). "Using Large Language Models for sentiment analysis of health-related social media data." *PMC*. [Zero-shot LLM vs. VADER comparison.]
- Burnham, M. et al. (2024). "Fine-Tuned 'Small' LLMs (Still) Significantly Outperform Zero-Shot Generative AI Models in Text Classification." arXiv 2406.08660.
- cardiffnlp (2022). "twitter-roberta-base-sentiment-latest." HuggingFace model card.
- Grljević, O. et al. (2024). "Multilingual transformer and BERTopic for short text topic modeling." arXiv 2402.03067.
- arXiv 2504.15448 (2025). VADER limitations on domain-specific text.
- arXiv 2508.07959 (2025). "Large Language Models for Subjective Language Understanding: A Survey."

### Time-Series and Google Trends
- Ono, T. et al. (2021). "Need of care in interpreting Google Trends-based COVID-19 infodemiological results." *BMC Medical Research Methodology*.
- ScienceDirect (2024). "Addressing Google Trends inconsistencies."
- Ashley, R. & Tsang, K.P. Granger causality and sample size requirements.

### Fast Fashion and Sustainability
- Soboleva, D. & Sánchez, A. (2024). "Agent-Based Insight into Eco-Choices: Simulating the Fast Fashion Shift." arXiv 2407.18814.
- "Emotional Analysis of Fashion Trends Using Social Media and AI" (arXiv 2505.00050, 2025).

### Cross-Posting Methodology
- Pilaud, M. & McCulloh, I. (2025). "Cross-Subreddit Behavior as Open-Source Indicators of Coordinated Influence." arXiv 2507.16857.
- arXiv 2402.14177 (2024). "Investigating Human Values in Online Communities."

### Demographic Inference
- Waller, I. & Anderson, A. (2021). "Quantifying social organization and political polarization in online platforms." Proceedings of the International AAAI Conference on Web and Social Media.
- arXiv 2502.05049 (2025). "On the Inference of Sociodemographics on Reddit."

### Narrative Economics (Supplementary)
- Shiller, R. (2017). "Narrative Economics." *American Economic Review*, 107(4), 967–1004.
- Skwire, S. (2020). "Sick of Metaphors: Reading Shiller's Narrative Economics." *Econlib*.

### Reddit Data, Ethics, and Alt-Accounts
- open-index/arctic (2025). "Arctic Shift Reddit Archive." HuggingFace dataset card.
- Fiesler, C. et al. (2024). "Reddit data and research ethics." *ACM CSCW*.
- arXiv 2501.17430 (2025). "Throwaway Accounts and Moderation on Reddit." USEC 2025.
- stylometry.net (2022). "Using Stylometry to find HN Users with Alternate Accounts." [Demonstrated ~90% accuracy in alt-account identification via writing-style analysis.]

## Why This Project Succeeds

- **Genuinely novel contribution**: The cross-posting analysis with cognitive dissonance predictions (RQ3) is new. No existing paper — including Aydin & Ogunleye (2026) — examines within-Reddit community-affiliation behavior to test the attitude-behavior gap in fashion at the individual user level.
- **Sharper theoretical predictions**: Cognitive dissonance theory generates *directional* predictions (hedging asymmetry, moral self-licensing temporal sequences, topic compartmentalization) that are more specific and falsifiable than generic "more hedging" predictions. The Celik & Ekici (2024, *Journal of Business Ethics*) paper validates this theoretical framework specifically for sustainable fashion consumers.
- **Honest positioning against prior art**: By citing Aydin & Ogunleye (2026) and framing RQ1/RQ2 as extensions rather than novel contributions, the proposal avoids the most likely desk-reject scenario.
- **Domain credibility**: Anna's Fashion Studies minor provides the theoretical grounding that pure CS/NLP papers in this space lack.
- **Methodologically current**: Three sentiment methods (lexicon, transformer, LLM) with human-annotated validation positions the paper in 2026, not 2022.
- **Demographic controls**: Waller & Anderson (2021) proxies protect against the most obvious confound (demographic differences between subreddit user bases).
- **Pre-specified power analysis**: The go/no-go threshold for RQ3 prevents the team from investing 7 weeks in an analysis that lacks statistical power, enabling an early pivot if needed.
- **Robust to negative results — with caveats**: If cross-posting overlap is negligibly small, that is publishable as evidence of community segmentation — *but only if reported alongside the alt-account selection paradox*, which renders the null result ambiguous. If sentiment models fail on fashion discourse, that is a finding about tool limitations. If time-series correlations are non-significant, the paper's contribution is unaffected because RQ4 is supplementary.
- **Rich skill development**: Students learn NLP (transformers, LLM inference, topic modeling), data engineering (bulk data processing), time-series analysis, demographic proxy computation, and research ethics — all highly transferable.
- **Beautiful outputs**: BERTopic topic evolution visualizations, cross-posting network diagrams, annotated time-series plots, three-way sentiment agreement matrices, hedging-language analysis.

## What Would Make This Stronger (Beyond 10-Week Scope)

These are documented for future extension, not proposed for the summer camp:

1. **TikTok data**: The platform actually driving fast fashion purchasing. TikTok Research API exists for academics but requires institutional approval and returns video metadata, not transcripts — would need Whisper-based transcription.
2. **Survey validation**: Pair Reddit NLP findings with a small survey (n=200) of Reddit users about their actual purchasing behavior. Would directly test whether cross-posting predicts self-reported purchasing — converting the discourse trace into a genuine behavioral measure.
3. **Stylometric alt-account detection**: Use writing-style analysis to estimate the true rate of alt-account usage across fashion communities. This would directly address the alt-account selection paradox (our most serious conceptual limitation). Stylometric methods have achieved ~90% accuracy in identifying alternate accounts on similar platforms (stylometry.net, 2022). However, this raises significant ethical concerns about de-anonymizing users and would require careful IRB review.
4. **Causal identification**: An event study design around specific Shein exposés (e.g., Channel 4 documentary) could provide quasi-causal evidence if the exposé timing is exogenous to sentiment trends.
5. **Larger temporal window**: Extending back to 2015 would give ~108–120 monthly observations, making Granger causality tests more credible (though still below the ≥150 threshold).
6. **Fine-tuned fashion-domain sentiment model**: Use the 500 manual annotations + LLM silver labels (from the separate augmentation pool, NOT the evaluation set) to fine-tune a small RoBERTa model specifically for fashion discourse. "Fine-tuned 'small' LLMs (still) significantly outperform zero-shot generative AI models" (Burnham et al., arXiv 2406.08660, 2024). This would be a reusable methodological contribution to the field.
