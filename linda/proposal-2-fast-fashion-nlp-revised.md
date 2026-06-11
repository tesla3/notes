# Proposal 2 (Revised): Scrolling Toward Sustainability? Cross-Community Identity and the Attitude-Behavior Gap in Reddit Fashion Discourse

## Summary

Fast fashion's CO₂ emissions "surpass the combined outputs of France, Germany, and the UK" (Soboleva & Sánchez, arXiv 2407.18814, 2024). Shein was valued at ~$66B in 2023 and shipped 2.7B+ packages in 2022. Meanwhile, sustainability rhetoric floods social media. But decades of consumer research document a persistent "attitude-behavior gap" — "65% of consumers stated they would purchase brands that are sustainable, yet only 26% actually did" (White, Hardisty, & Habib 2019).

This project uses NLP to study whether users' community affiliations across Reddit fashion communities reveal the attitude-behavior gap at the discourse level. We frame this as a **descriptive and correlational** study, not a causal one — the data cannot establish that discourse changes behavior.

The project's **primary novel contribution** is a **cross-posting analysis** that tests whether the same users participate in both pro-sustainability and fast-fashion communities — and, if so, whether their language shifts between contexts in ways consistent with cognitive dissonance theory. No existing published work examines this cross-community identity signal in fashion discourse. Supporting analyses — topic modeling and sentiment trajectories — extend recent work by Aydin & Ogunleye (2026) with a three-method sentiment comparison and temporal evolution analysis not present in that study.

**Scope discipline:** This proposal contains three research questions, not four. The time-series / Granger causality analysis present in the prior draft has been eliminated entirely (see §Changes From Previous Draft for rationale). The information cascades framework has been dropped. The project focuses on what it can do well within 10 weeks: cross-community discourse analysis grounded in cognitive dissonance theory.

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

### The Moral Licensing Replication Crisis — A Necessary Reckoning

Our prior draft's Prediction 2 relied on moral self-licensing (Monin & Miller 2001) as established theory. **It is not.** The moral licensing literature is in crisis, and this proposal must engage honestly with that fact:

- **Kuper & Bott (2019, *Meta-Psychology*):** Found strong evidence of publication bias inflating moral licensing effect sizes. Using PET-PEESE and a three-parameter selection model, adjusted effect sizes dropped to **d = −0.05 (p = .64)** and **d = 0.18 (p = .002)** — down from the meta-analytic d = 0.31 reported by Blanken et al. (2015). They concluded: "It is concluded that both the evidence for and the size of moral licensing effects has likely been inflated by publication bias" (Kuper & Bott 2019).

- **Rotella & Barclay (2020, *Personality and Individual Differences*):** Failed to replicate moral licensing and cleansing effects in an online experiment. They concluded: "we posit that moral licensing and cleansing effects are unlikely to be elicited online" (Rotella & Barclay 2020).

- **Most critically: "Observation Moderates the Moral Licensing Effect: A Meta-Analytic Review" (*Personality and Social Psychology Bulletin*, 2025, DOI: 10.1177/01461672251345512).** This multi-level meta-analysis of 115 experiments (N = 21,770) found: "moral licensing was stronger when participants were observed (g = 0.65) than unobserved (g = 0.13). After accounting for publication bias with robust Bayesian meta-analysis, there was moderate evidence for licensing when participants were observed (g = 0.51; BF₁₀ = 9.14), but moderate evidence against licensing when unobserved (Hedge's g = −0.01; BF₁₀ = 0.11)." The authors conclude: "These findings suggest that moral licensing is elicited through interpersonal motives" — not intrapsychic dissonance.

**Implications for this project:** Reddit is pseudonymous. Users are neither fully observed (no one sees their face) nor fully unobserved (post history is public). If licensing requires social observation and does not operate through intrapsychic mechanisms, a unidirectional licensing prediction (sustainability posting → Shein posting) is unsupported. Our revised Prediction 2 (§Theoretical Foundation) therefore tests both licensing and consistency as competing hypotheses, with the null being random posting. See §Theoretical Foundation for the revised formulation.

### Other Related Work

- **"Consumer Awareness of Fashion Greenwashing: Insights from Social Media Discussions" (Sustainability, 2025):** Uses LDA on 446 Reddit comments about fashion greenwashing with cognitive dissonance as theoretical framework. Small corpus, no cross-community analysis, no temporal dimension. Demonstrates that cognitive dissonance framing is accepted in this literature.
- **"Emotional Analysis of Fashion Trends Using Social Media and AI" (arXiv 2505.00050, 2025):** Multi-platform sentiment analysis of fashion. Found that the sustainability theme had only 1,337 tweets, with 81.3% neutral — a cautionary example about sentiment tool performance in this domain. Reddit showed "generally critical discourse" relative to visual platforms.
- **Celik & Ekici (2024), "'I Crossed My Own Line, But Here is What I do': The Moral Transgressions of Sustainable Fashion Consumers," *Journal of Business Ethics*, 196, 917–936:** Qualitative study of 20 sustainable fashion consumers finding that "inconsistent behaviours of individuals within a moral framework, such as ethical consumption, give rise to psychological unease and, thereafter, a motivation to seek cognitive consonance" (citing Festinger, 1957, 1962). Documents specific dissonance-reducing strategies in fashion. Our cross-posting analysis operationalizes this at scale.
- **"Secondhand fashion consumers exhibit fast fashion behaviors despite sustainability awareness" (PMC 12504660, 2025):** Found that among secondhand fashion consumers, "greater sustainability knowledge was only weakly or negatively correlated with sustainable purchasing and disposal practices. Despite increased awareness, many respondents continued to purchase and discard clothing at high rates. This supports the idea of moral licensing, whereby prior ethical actions (e.g., buying used clothing) serve to justify less sustainable choices thereafter." Directly relevant to our r/ThriftStoreHauls cross-posting analysis.
- **"Moving Beyond LDA: A Comparison of Unsupervised Topic Modelling Techniques for Qualitative Data Analysis of Online Communities" (arXiv 2412.14486, December 2024):** Tested LDA, BERTopic, and NMF on 12 Reddit datasets **including r/SustainableFashion directly**. Results on r/SustainableFashion: LDA coherence 0.386, NMF 0.573, BERTopic 0.685. NMF consistently outperformed LDA across all 12 subreddits (mean coherence: NMF 0.684 vs. LDA 0.500). See §Topic Modeling for why we include NMF.
- **"Can Language capture Cognitive Dissonance?" (arXiv 2502.13326, 2025):** Demonstrated that experimentally-evoked cognitive styles can be captured by language features with AUC ~0.8, but only when cognitive state was experimentally measured. The authors argue for "incorporating direct behavioral measurements into linguistic analyses, moving beyond traditional annotation-based methods." This underscores a fundamental limitation of our observational approach: we cannot establish that linguistic markers in Reddit posts reflect genuine cognitive dissonance rather than performative audience management. See §Conceptual Risks.
- **"I Don't Buy It! A Critical Review of the Research on Factors Influencing Sustainable Fashion" (Sustainability, 2025):** Systematic review of green apparel buying behavior (GABB) research noting that "all surveys rely on self-reported data to measure GABB and related factors... A significant limitation of self-report measures in the context of GABB is that they do not constitute actual behavioral measures." This reinforces our explicit framing: Reddit discourse captures discourse, not purchasing behavior.

## Why Anna

Fashion Studies minor at Cornell. This isn't a bolted-on interest — she formally studied it. Combined with her Economics training (econometrics, causal reasoning) and Anthropology minor (cultural behavior lens), she's unusually well-positioned to bridge quantitative NLP methods with fashion/consumer theory. Pure CS/DS researchers lack this domain credibility. Anna's unique contribution is precisely the theoretical lens needed to interpret NLP outputs in a domain where naive sentiment ≠ purchase intent.

## Core Research Questions

1. **Descriptive** *(Extending Aydin & Ogunleye 2026)*: How do sustainability narratives on Reddit fashion communities evolve from 2019–2024 (spanning pre/post COVID, Shein's rise, and factory exposé events)? *Prior work provides a cross-sectional snapshot; we add the temporal dimension.*
2. **Comparative** *(Extending Aydin & Ogunleye 2026)*: Do sentiment trajectories and topic distributions differ systematically across sustainability-oriented communities (r/ethicalfashion, r/SustainableFashion), general fashion communities where Shein is debated (r/femalefashionadvice filtered for Shein/fast-fashion mentions), and secondhand communities (r/ThriftStoreHauls)? *Prior work uses lexicon-based sentiment only; we compare three methods against human annotations.*
3. **Cross-Community Identity** *(Primary novel contribution)*: Do users who post in sustainability-oriented communities also post about Shein in general fashion communities? If so, does their language differ between contexts in ways predicted by cognitive dissonance theory — more tentative language, justification, and topic compartmentalization than single-community users? Cross-posting overlap as a discourse-level behavioral trace of the attitude-behavior gap.

### What This Project Does NOT Claim

We do not claim that Reddit sentiment *causes* changes in consumer purchasing behavior. The attitude-behavior gap literature is clear: stated attitudes do not reliably predict purchasing. A recent systematic review confirms: "self-report measures... do not constitute actual behavioral measures. Whereas behavioral measures reflect observable actions—such as frequency or duration—self-reports capture individuals' perceptions of their own behavior" ("I Don't Buy It!", Sustainability 2025). Our study documents discourse patterns and tests for statistical associations. Interpreting these associations requires caution discussed explicitly in the Limitations section.

We do not claim that cross-posting constitutes *revealed preference* in the economic sense (Samuelson 1938). Posting in a subreddit is not purchasing. Cross-posting measures **community affiliation** — a behavioral trace weaker than purchase data. Cross-posting's advantage is that it is unprompted and naturalistic; its disadvantage is that it captures discourse behavior, not consumption behavior.

We do not claim that linguistic markers of hedging or justification in Reddit posts demonstrate *genuine cognitive dissonance*. Such markers could equally reflect community norm compliance, audience management, or individual communication style (see §Conceptual Risks for full discussion). We test for patterns *consistent with* cognitive dissonance theory and discuss alternative explanations alongside every finding.

### Changes From Previous Draft (with rationale)

| Change | Rationale |
|--------|-----------|
| **RQ4 (time-series / Granger causality) eliminated entirely** | The prior draft acknowledged that 60–72 monthly observations is below the ≥150 threshold for credible Granger causality (Ashley & Tsang); that 72 individual correlations require Bonferroni correction to α = 0.0007 leaving effectively no power; that COVID confounds all 2020–2021 correlations; and that a reviewer rejected a paper for using Granger causality with 33 observations. Despite these admissions, the prior draft allocated a full student's time (Weeks 7–10) to this analysis and included it as a "supplementary" section. Including known-weak analysis in a paper gives reviewers an easy target and reduces credibility. **Killed, not demoted.** Student A's time reallocated to RQ3 robustness checks. |
| **Google Trends, GDELT, SEC filings removed as data sources** | These served only RQ4. Without the time-series analysis, they have no methodological role. Google Trends may be referenced in the discussion as descriptive context (e.g., "search interest for 'Shein' rose during this period") but is not a formal data source. |
| **Information cascades framework (Banerjee 1992) dropped** | The prior draft correctly admitted that Reddit violates all of the framework's assumptions: "information cascade models assume sequential, observable decisions by rational agents. Reddit discourse is neither sequential nor individually rational in the Bayesian sense." The framework generated no testable predictions not already covered by cognitive dissonance. Dead weight. |
| **Moral self-licensing prediction (P2) reframed as bidirectional test** | The moral licensing literature has serious replication problems. Kuper & Bott (2019) found publication bias inflating the effect size. A 2025 meta-analysis (PSPB, N = 21,770) found licensing is moderated by observation (g = 0.65 observed vs. g = −0.01 unobserved) and "is elicited through interpersonal motives." Rotella & Barclay (2020) failed to replicate licensing online. Reddit is pseudonymous — the observation channel is ambiguous. A unidirectional licensing prediction is not empirically supported. We now test both licensing and consistency as competing hypotheses. See §Theoretical Foundation. |
| **Hedging measurement operationalized with LIWC + annotation** | The prior draft assigned "hedging-language lexicon construction" to one student in Weeks 5–7 with no validated methodology. Existing hedging detection achieves only 57.6% precision on informal text (Islam et al. 2020, LREC). Building a validated domain-specific lexicon from scratch is a multi-month research project. We now use LIWC's validated Tentativeness dictionary as the primary measure, supplemented by manual hedge annotation on the 500-post evaluation set and LLM-based classification as validation. See §Hedging and Justification Measurement. |
| **NMF added as topic modeling method** | A December 2024 paper (arXiv 2412.14486) tested LDA, BERTopic, and NMF on 12 Reddit datasets including r/SustainableFashion. NMF coherence (0.573) outperformed LDA (0.386) on that exact subreddit. NMF consistently outperformed LDA across all subreddits tested (mean: 0.684 vs. 0.500). NMF produces no outlier bin — the exact problem the prior draft spent paragraphs mitigating for BERTopic. The prior draft used LDA as the fallback; NMF is a better fallback. |
| **Bot/spam filtering added to data validation** | Fashion subreddits, especially r/Shein, are targets for promotional spam and astroturfing. Undetected promotional accounts in the cross-posting analysis could inflate or deflate overlap rates and skew sentiment. The prior draft discussed alt-accounts and data gaps but never mentioned bot contamination. |
| **Power analysis expanded for smaller effect sizes** | The prior draft assumed d = 0.5 (medium effect). If hedging differences are subtle — as cognitive dissonance theory would predict for people who successfully compartmentalize — d = 0.2–0.3 is more realistic. At d = 0.3, n ≥ 175 dual-community users are needed. The go/no-go threshold table is expanded. |
| **Community norm compliance confound added to conceptual risks** | Hedging in Reddit posts could reflect community norms (you *must* hedge about non-sustainable purchases in r/ethicalfashion) rather than internal cognitive dissonance. A control comparison is added: do dual-community users also show more tentative language than single-community users in *unrelated* subreddits? If so, it's communication style, not dissonance. |
| **Pre-camp workload estimate corrected** | The prior draft estimated 12–16 hours. Downloading Arctic Shift Parquet for 7 subreddits × 6 years, filtering r/femalefashionadvice, running the full data validation protocol, drafting an annotation guide, and setting up a local LLM (Llama 3 8B requires ≥16GB VRAM and quantization) is 40–60 hours. |
| **Secondhand rebound literature added** | A 2025 study found that "secondhand fashion consumers exhibit fast fashion behaviors despite sustainability awareness" and invoked moral licensing specifically. Directly relevant to r/ThriftStoreHauls cross-posting analysis. Not cited in prior draft. |

All changes from the original draft's change table (r/Shein removal as primary corpus, r/SustainableFashion addition, study window narrowing, LLM sentiment addition, RoBERTa model update, revealed preference reframing, cognitive dissonance replacing Narrative Economics as primary frame, BERTopic user-within-thread aggregation, Aydin & Ogunleye positioning, power analysis requirement, demographic proxy controls) are retained and incorporated.

## Theoretical Foundation

This project draws on two primary frameworks and one supplementary framework.

### Primary: Cognitive Dissonance and the Attitude-Behavior Gap in Sustainable Fashion

A large body of work documents that "consumers increasingly express ethical and environmental concerns regarding fashion consumption, yet consumer demand for sustainable fashion brands remains limited" (Jacobs et al. 2018; Carrigan & Attalla 2001; Lundblad et al. 2015; Niinimäki 2010). The gap is substantial: "65% of consumers stated they would purchase brands that are sustainable, yet only 26% actually did" (White, Hardisty, & Habib 2019).

Cognitive dissonance theory (Festinger 1957) provides the mechanism: when individuals hold simultaneously a belief ("fast fashion is environmentally destructive") and a behavior ("I shop at Shein"), they experience psychological discomfort and are motivated to reduce it. Celik & Ekici (2024, *Journal of Business Ethics*) demonstrate this specifically in sustainable fashion: "inconsistent behaviours of individuals within a moral framework, such as ethical consumption, give rise to psychological unease and, thereafter, a motivation to seek cognitive consonance in a variety of ways" (citing Festinger, 1957, 1962). Their qualitative study of 20 sustainable fashion consumers documents specific dissonance-reducing strategies: moral self-licensing ("My overall good behaviour makes up for this" — Klockars 1974, cited in Celik & Ekici 2024), neutralization ("I know Shein is bad but I can't afford alternatives"), and what they term "alternating moral practices."

Key barriers to closing the gap include price (Chang 2011), convenience and availability (Carrigan et al. 2001; Johnstone et al. 2015), perceived quality (Newman, Gorlin, & Dhar 2014), and social visibility — a 2024 Psychology & Marketing study (6 experiments, US consumers) found that sustainable purchasing is driven by observation, and the effect "completely disappears" when shopping privately at home.

**Cognitive dissonance generates specific predictions for our cross-posting analysis (RQ3). We state these predictions, their operationalization, and the alternative explanations each must be tested against:**

- **Prediction 1 (linguistic register shifting):** Dual-community users should show greater linguistic variation between community contexts than single-community users. Specifically, their LIWC Tentativeness scores (the validated measure of hedging; see §Hedging and Justification Measurement) should be higher when posting in sustainability-oriented communities *about fast fashion purchases* than when posting in fashion communities *about price/convenience*. This is a context-dependent shift, not a global trait difference.
  - **Operationalization:** Compare LIWC Tentativeness scores of dual-community users' posts in sustainability vs. fashion contexts (within-user comparison). Compare dual-community users' context-specific scores against single-community users' scores in the same community (between-group comparison using Mann-Whitney U test).
  - **Alternative explanation (community norm compliance):** Hedging may reflect community norms rather than internal dissonance. If r/ethicalfashion *requires* hedging about any non-sustainable purchase, then all users who mention fast fashion there will hedge, regardless of whether they feel dissonance. **Control test:** Compute LIWC Tentativeness scores for dual-community users in *unrelated* subreddits they participate in (subreddits not in our target set). If dual-community users show globally higher tentativeness than single-community users across all contexts, the signal reflects communication style, not dissonance.
  - **Alternative explanation (selection effects):** More verbose or socially skilled users may post in more communities. **Control test:** Compare total post counts and average word counts between dual-community and single-community users. Include as covariates.

- **Prediction 2 (temporal sequence — bidirectional test):** The prior draft predicted a unidirectional moral self-licensing effect: sustainability posts → Shein posts. Given the replication crisis in moral licensing (see §Relationship to Prior Work), we test both directions as competing hypotheses:
  - **Hypothesis A (licensing):** Among dual-community users, posts in sustainability communities are followed by posts in fast-fashion communities within 7/14/30 days at above-chance rates. This would be consistent with "moral credit" accumulation (Monin & Miller 2001) — the idea that engaging in sustainability discourse provides psychological license for subsequent fast-fashion engagement.
  - **Hypothesis B (consistency):** Among dual-community users, posts in sustainability communities are followed by *more* sustainability posts at above-chance rates. This would be consistent with self-perception theory (Bem 1972) and the consistency effects documented in the moral licensing literature: "a meta-analysis examining when moral licensing versus consistency occurs found that people show more consistency when thinking abstractly about their initial behavior and values, but show more licensing when thinking concretely about what they have accomplished" (Wikipedia, "Self-licensing," citing Cornelissen et al. 2013).
  - **Null model:** For each dual-community user, permute their posting timestamps (preserving which posts go to which subreddits but randomizing temporal order) 1,000 times to establish the expected transition rate under random posting. Compare observed transition rates against this null distribution.
  - **Critical caveat:** Even if we observe a licensing-like pattern (sustainability → Shein), the 2025 meta-analysis finding that licensing is driven by interpersonal motives (observation), not intrapsychic dissonance, means we cannot attribute it to cognitive dissonance. The pseudonymous, semi-public nature of Reddit makes it ambiguous whether posting constitutes "observed" behavior. We report the temporal pattern and discuss both intrapsychic and interpersonal interpretations.

- **Prediction 3 (topic compartmentalization):** The same dual-community user should emphasize different topics depending on which community they address — environmental impact in sustainability forums, price/quality/sizing in fashion forums — reflecting what Festinger (1957) described as minimizing the importance of the dissonant element in each context.
  - **Operationalization:** For dual-community users with ≥5 posts per context, compute topic distributions from BERTopic/NMF output. Compare within-user cross-context topic distributions using Jensen-Shannon divergence. Test whether within-user JS divergence (same user, different contexts) exceeds between-user JS divergence (different users, same context) — which would indicate that users are genuinely shifting their discourse, not merely reflecting community-wide topic distributions.
  - **Alternative explanation:** Topic compartmentalization could simply reflect different *prompts* in different communities (sustainability subs discuss environment; fashion subs discuss clothing). The control test (comparing within-user divergence to between-user divergence) addresses this: if dual-community users shift topics *more* than the community baseline predicts, something beyond community membership is driving the shift.

### Primary: Social Identity and Fashion as Performance

Fashion consumption is identity performance (Goffman 1959; Entwistle 2000). Online communities function as identity spaces where users signal group membership through discourse. Participation in r/ethicalfashion signals a sustainability-oriented identity; participation in Shein-discussing communities signals a price-conscious, trend-oriented identity. When the same user participates in both, they are managing competing identity commitments — what identity theorists call "role conflict" (Stryker & Burke 2000).

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

### Data Sources Removed (with rationale)

| Removed | Why |
|---------|-----|
| **r/Shein as a primary discourse corpus** | r/Shein content is overwhelmingly shopping logistics (sizing, promo codes, haul reviews), not sustainability discourse. Comparing sentiment about "does this 4X fit like a US 20?" with sentiment about "fast fashion is destroying the planet" conflates unrelated constructs. r/Shein is retained only for cross-posting user-overlap analysis. |
| **r/fashionreps** | This subreddit (2.2M members) is about **counterfeit/replica luxury goods** — people buying fake Jordans and knockoff Balenciaga. Fundamentally different from fast fashion. |
| **Google Trends, GDELT, News API** | Served only RQ4 (time-series / Granger), which has been eliminated entirely. |
| **SEC filings / Quarterly earnings** | Served only RQ4. |
| **UN Comtrade** | Textile trade data operates at a national/annual level completely disconnected from subreddit-level sentiment. |
| **Good On You ratings** | Scraped brand ratings add marginal value for a discourse-analysis study and introduce ToS compliance risk. |

### Data Validation Protocol (Critical — Run Before Any Analysis)

The following checks must be completed in **Week 1** before any analysis proceeds:

1. **Post-volume cliff-edge test**: Plot monthly post counts per subreddit from 2019 through latest available date. Arctic Shift data derives from PushShift, which experienced disruptions when Reddit locked down API access in June 2023. However, the Arctic Shift maintainer has confirmed that "aside from the specific months of April-June in 2023, there is no statistically significant change in the data collected before and after the API changes" (u/Watchful1, r/pushshift, May 2025). If any target subreddit shows a >50% drop in monthly post volume during April-June 2023, **exclude those months** and note the gap.

2. **User-deletion audit (critical for cross-posting analysis)**: A key technical difference between PushShift and Arctic Shift data affects user-level analysis: "Pushshift updated entries after ~a month (`retrieved_utc`), while arctic_shift does it after 36h... user deletion: if the user was `[deleted]` between ingestion and reingestion, pushshift would overwrite the username, while arctic_shift does not. In bulk, 23% of pushshift submissions are by `[deleted]` (24% in its last year), while for arctic_shift it is 2%" (u/joaopn, r/pushshift, May 2025). This means: (a) pre-2023 PushShift data has significantly more `[deleted]` authors, making cross-posting analysis less complete for earlier periods; (b) Arctic Shift preserves original usernames better, giving more complete cross-posting data for post-2023 periods. **Report user-deletion rates per time period and note the asymmetry in all cross-posting results.**

3. **Deleted-content audit**: Count the proportion of posts where author = `[deleted]` and body = `[removed]` per subreddit per year. Report alongside all results.

4. **r/femalefashionadvice keyword filter yield**: Count the number of posts matching the Shein/fast-fashion keyword filter by month. If yield is < 50 posts/month for most of 2019–2024, the keyword-filtered corpus is too sparse for monthly sentiment time-series. Fallback: expand keyword list or add r/fashion as an additional source subreddit.

5. **r/ThriftStoreHauls text content check**: Compute the distribution of text length (word count) per post. If >70% of posts have <30 words of text (photo captions), the subreddit is not suitable for NLP analysis. Retain for cross-posting overlap only.

6. **Bot and promotional spam filtering (NEW)**: Fashion subreddits — especially r/Shein — are targets for promotional spam and astroturfing (fake reviews, promo code bots, brand-affiliated accounts). Apply the following filters before analysis:
   - Remove accounts where >50% of posts contain affiliate links, referral codes, or promo codes (regex pattern matching).
   - Remove accounts with karma below subreddit-specific thresholds (e.g., < 10 comment karma).
   - Remove accounts created within 7 days of their first post in a target subreddit.
   - Remove accounts whose posting history consists exclusively of one brand mention.
   - Report the number and percentage of accounts removed per subreddit. If >10% of accounts in any subreddit are flagged, investigate manually before proceeding.
   - **Why this matters for RQ3:** A promotional account active in both r/Shein and r/femalefashionadvice would appear as a "dual-community user" but carry no signal about cognitive dissonance or the attitude-behavior gap.

7. **Cross-posting user count and power analysis (critical for RQ3)**: Count the number of users active in both sustainability-oriented subreddits (r/ethicalfashion, r/SustainableFashion) and fast-fashion-adjacent contexts (r/Shein, Shein-mentioning posts in r/femalefashionadvice). See §Power Analysis for minimum-n thresholds. **If dual-community user count falls below the threshold, the dual-community linguistic analysis (RQ3 Predictions 1–3) is infeasible and should be replaced with community-level overlap statistics only.**

## ML Methods (Teachable in 10 Weeks)

### Pre-Camp Preparation (Mentor/TA responsibility)

To protect the 10-week timeline from data-engineering delays:

- **Pre-download** Arctic Shift Parquet shards for all target subreddits (r/ethicalfashion, r/SustainableFashion, r/sustainability, r/femalefashionadvice, r/Shein, r/ThriftStoreHauls, r/Anticonsumption) for 2019–2025.
- **Pre-filter** r/femalefashionadvice for Shein/fast-fashion keyword matches.
- **Pre-run** the Data Validation Protocol (§above) including bot/spam filtering and document results so students begin Week 1 with a known-clean corpus.
- **Pre-install** Python environment with all dependencies (transformers, bertopic, statsmodels, pandas, LIWC-22 or empath, etc.).
- **Pre-set up** the local LLM for Method 3 sentiment. Llama 3 8B requires ≥16GB VRAM or 4-bit quantization (GGUF via llama.cpp). Test that inference runs on the available hardware. If GPU is unavailable, switch to a smaller model (Phi-3-mini 3.8B) or use a quantized Qwen2.5-7B via Ollama.
- **Pre-draft annotation guide** (Anna drafts before Week 1): Define sentiment categories AND hedging categories with domain-specific examples. Include edge cases: irony ("Shein haul! Got 47 pieces for $12, definitely saving the planet 🌍"), hedging ("I know Shein is bad but..."), and subreddit-specific jargon.

**Estimated pre-camp effort: ~40–60 hours** of compute, scripting, annotation guide drafting, and LLM setup. This is substantially more than the prior draft's 12–16 hour estimate. Budget accordingly — ideally split across mentor + TA over 2 weeks before camp.

### Week 1–2: Corpus Assembly, EDA & Cross-Posting Census

- **Start from pre-downloaded data.** Students clean, deduplicate, and structure the corpus into analysis-ready DataFrames (one row per post/comment, columns: subreddit, author, timestamp, text, score).
- **EDA**: Post volume over time per subreddit (this also completes cliff-edge validation). Word-frequency distributions. Subreddit subscriber-count vs. post-count comparison.
- **Cross-posting user census (critical path for RQ3)**:
  - Extract unique usernames from all 7 target subreddits.
  - Build a user × subreddit participation matrix.
  - Count dual-community users (sustainability-oriented + fast-fashion-adjacent).
  - **Run the power analysis** (see §Power Analysis). If dual-community users < minimum-n threshold, convene with mentor to decide whether to (a) expand subreddit list, (b) relax the "active in both" threshold, or (c) narrow RQ3 to community-level overlap statistics only.
- **Pilot annotation**: Using Anna's pre-drafted guide, team pilot-annotates 20 posts for both sentiment (3 classes: positive/negative/neutral) and hedging (binary: present/absent) to calibrate. Revise guide based on disagreements.
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

**Method 3 — LLM zero-shot classification (New)**:
- Use a locally-run open-weight model (Llama 3 8B or Qwen2.5 7B) with a structured prompt for three-class sentiment classification.
- Rationale: Zero-shot GPT-3.5 "outperformed VADER on four out of five datasets" on social media sentiment (He et al., PMC 2025). LLMs handle exactly the failure modes VADER and RoBERTa struggle with: irony, domain-specific slang, context-dependent expressions.
- A local model avoids API costs and data-privacy concerns of sending Reddit content to commercial APIs.
- **Known limitation**: "Fine-tuned 'small' LLMs (still) significantly outperform zero-shot prompted larger models" when training data exists (Burnham et al., arXiv 2406.08660, 2024). Our LLM is used as one of three methods, not as a replacement for fine-tuned models.

**Manual annotation** (CRITICAL):
- Manually label **500 Reddit posts** (stratified: ~70 per target subreddit for 7 subreddits) for **two dimensions**:
  - **Sentiment** (3 classes: positive/negative/neutral toward sustainability and/or fast fashion)
  - **Hedging/justification** (binary: does this post contain hedging, justification, or qualification language? See §Hedging and Justification Measurement)
- This enables: (a) measuring all three sentiment models' accuracy on our specific domain, (b) reporting inter-annotator agreement (Cohen's kappa ≥ 0.70 target for sentiment, ≥ 0.60 for hedging), (c) validating LIWC Tentativeness scores against manual hedge labels, (d) identifying systematic failure modes per model.
- **Annotation allocation**: Each of the 4 team members annotates ~125 posts. 100 posts are annotated by two team members to compute inter-annotator agreement.
- **Separation of evaluation and augmentation sets**: The 500 human-annotated posts constitute the **evaluation set** and must remain exclusively human-labeled. If LLM silver labels are used to augment models, they must be drawn from a **separate pool** of unannotated posts. The LLM cannot be independently assessed against labels it helped produce.
- **Contingency plan**: If all three methods score < 0.65 accuracy against human annotations, we (a) report this as a substantive finding about the inadequacy of off-the-shelf sentiment tools for fashion discourse, (b) use the LLM to generate aspect-based annotations (extracting stance toward specific topics: "sustainability", "price", "quality") rather than document-level polarity, and (c) proceed with topic modeling (which does not depend on sentiment labels) as the primary analytical method.

**What all three methods will miss**: Fashion-specific irony ("Shein haul! Got 47 pieces for $12, definitely saving the planet 🌍"), subculture jargon ("fire", "heat", "drip" as positive valence), Gen Z register ("no cap", "slay", "ate and left no crumbs"). The 500-post annotation will quantify how often each method fails on each category.

### Hedging and Justification Measurement (NEW — Operationalization for RQ3)

The prior draft left hedging measurement entirely unspecified, assigning "hedging-language lexicon construction" to one student. The hedging detection literature reveals this is not a solvable problem in 3 weeks:

- Islam et al. (2020, LREC) built a hedging lexicon for informal text and achieved only **precision 57.6%, recall 64.9%** — on texts far more structured than Reddit fashion discourse.
- A 2024 study (arXiv 2408.03319) on hedge detection in spontaneous narratives found that **"fine-tuning BERT significantly outperforms state-of-the-art LLMs in few-shot and zero-shot settings"** for this specific task. Zero-shot LLMs — which this project uses for sentiment — are the *weakest* approach for hedge detection.
- Hedging markers are highly domain-dependent and polysemous. "Might" is a hedge 78.5% of the time in academic text (Hyland 1998) but has entirely different frequencies in casual online discourse.

**Our approach uses three layers, from most validated to most exploratory:**

1. **Primary measure — LIWC Tentativeness dictionary**: LIWC-22 (Pennebaker et al.) provides a validated, extensively tested dictionary of tentative language markers (e.g., "maybe", "perhaps", "guess", "might", "somewhat", "possibly", "probably", "kind of", "sort of"). This is the most reproducible measure and serves as the primary comparison variable for Prediction 1. We also compute LIWC's Certainty category; the Tentativeness-to-Certainty ratio provides a scalar hedge-vs-assertion index per post. **Cost: LIWC-22 academic license is ~$100.**
   - **Alternative if LIWC is unavailable**: Use the freely available `empath` library (Fast et al. 2016, CHI) which includes a "tentative" category, or extract the LIWC word lists from published supplementary materials (Pennebaker et al. 2015).

2. **Validation measure — Manual hedge annotation on the 500-post evaluation set**: Annotators label each post as containing or not containing hedging/justification language (binary). This adds approximately 10 seconds per post to the existing sentiment annotation. The 500 labels allow us to compute: (a) agreement between LIWC Tentativeness scores and human judgments (ROC-AUC), (b) false positive/negative patterns for LIWC in fashion discourse.

3. **Exploratory supplementary measure — Domain-specific justification phrases**: During annotation, annotators also flag *specific phrases* that function as justification but are not in LIWC's dictionary (e.g., "guilty pleasure", "I know I shouldn't but", "treat yourself", "on a budget"). These are compiled into a short supplementary list (~20–30 phrases) and reported descriptively. This list is NOT used as the primary measure because it is not validated; it is reported as exploratory.

**What LIWC will miss**: Fashion-specific hedging patterns like "I know Shein is problematic but for my budget..." are partially captured by LIWC's tentative markers ("I know... but") but the domain-specific shame/guilt component is not. This is an acknowledged limitation. We do NOT claim to measure cognitive dissonance directly — we measure *linguistic tentativeness*, which is *consistent with* but not proof of dissonance.

### Week 5–8: Topic Modeling & Cross-Posting Analysis

**Topic Modeling with BERTopic and NMF (on user-within-thread aggregates)**:

- **Document unit**: For each thread, aggregate all comments by a **single user** into one document, prepended by the post title. This produces documents of ~100–300 words while preserving authorial coherence.
- **Why not thread-level aggregation**: Concatenating ALL comments under a post mixes multiple authors' contradictory perspectives into a single document. A thread about Shein may contain pro-Shein, anti-Shein, neutral, and meta-comments. Topic modeling assumes documents have coherent latent topic distributions; a document with contradictory signals produces a centroid that represents no one's actual position.
- **Fallback for very short documents**: If user-within-thread aggregation still produces documents too short for BERTopic (median <50 words), aggregate all comments by a single user *within a single subreddit within a single month*.

**BERTopic configuration:**
- Sentence-transformer embeddings → UMAP dimensionality reduction → HDBSCAN clustering → c-TF-IDF topic representation. Students use it as a **high-level API** (`BERTopic().fit_transform(docs)`) — they do not need to understand UMAP/HDBSCAN internals.
- Set `min_topic_size=30` to prevent micro-topics.
- **Known issue**: "When used with HDBSCAN, BERTopic creates a bin for topic outliers, which can sometimes contain over 74% of the dataset" (Grljević et al., arXiv 2402.03067, 2024). Mitigation: use `reduce_outliers()` with c-TF-IDF strategy; report outlier percentage before and after reduction.
- Track topic prevalence over time with `visualize_topics_over_time()`.

**NMF as a robust alternative (NEW):**
- NMF (Non-negative Matrix Factorization) is included based on empirical evidence from the exact subreddit we study. The December 2024 comparison paper (arXiv 2412.14486) tested on r/SustainableFashion:

  | Method | Topic Coherence (r/SustainableFashion) | Mean Coherence (12 subreddits) |
  |--------|---------------------------------------|-------------------------------|
  | LDA    | 0.386                                 | 0.500                         |
  | NMF    | 0.573                                 | 0.684                         |
  | BERTopic | 0.685                               | 0.647                         |

- NMF is deterministic (no random initialization issues), produces no outlier bin, and is computationally cheap (scikit-learn `NMF` class). It serves as the primary fallback if BERTopic's outlier rate exceeds 40%. If BERTopic succeeds, NMF serves as a robustness check — consistent topic structures across methods strengthen the finding.
- **LDA is retained as a tertiary comparison** but is no longer the primary fallback given its consistently lower coherence scores.

**Expected topics**: "labor exploitation", "environmental guilt", "price justification", "thrifting as identity", "greenwashing skepticism", "sizing/logistics" (Shein-specific).

**Cross-Posting Analysis** *(Primary novel contribution)*:

- For each user who posted in any of the 7 target subreddits, check whether they also posted in other target subreddits.
- Compute pairwise user-overlap matrices using **two metrics**:
  - **Jaccard similarity**: |A ∩ B| / |A ∪ B|. Standard but sensitive to size asymmetry.
  - **Szymkiewicz–Simpson coefficient (overlap coefficient)**: |A ∩ B| / min(|A|, |B|). Normalizes by the smaller community, preventing large subreddits (r/ThriftStoreHauls at 4.1M members) from dominating the denominator. Methodological precedent: "Investigating Human Values in Online Communities" (arXiv 2402.14177, 2024) defines user similarity as the overlap coefficient between subreddit user sets.
- **Key tests**:
  - What fraction of r/ethicalfashion users also post about Shein in r/femalefashionadvice or r/Shein?
  - What fraction of r/ThriftStoreHauls users also discuss fast fashion in other subreddits?
  - What fraction of r/SustainableFashion users overlap with r/Anticonsumption vs. r/Shein?

- **Dual-community user analysis** (the core novelty):
  - Identify users active in both sustainability-oriented (r/ethicalfashion, r/SustainableFashion) and fast-fashion-adjacent (r/Shein, Shein-mentioning posts in r/femalefashionadvice) communities.
  - Test the three predictions (§Theoretical Foundation) with the specified operationalizations and control tests.
  - This approach is methodologically grounded: "Cross-Subreddit Behavior as Open-Source Indicators of Coordinated Influence" (Pilaud & McCulloh, arXiv 2507.16857, 2025) uses exactly this method — "topic modeling and sentiment analysis are applied to all posts and comments authored by dual-subreddit users to construct a user–topic sentiment matrix." That study found **63 dual-subreddit users** between r/Sino and r/China.

- **Verbosity/style control test (NEW):** For dual-community users, compute LIWC Tentativeness scores in *all other subreddits they participate in* (outside our 7 target subs). Compare against single-community users' scores in those same subreddits. If dual-community users are globally more tentative, the RQ3 results reflect personality/style differences, not context-dependent cognitive dissonance. This test requires accessing users' broader posting history beyond our target subreddits — which Arctic Shift provides.

### Power Analysis for RQ3 (Critical — Determines Feasibility)

The Pilaud & McCulloh (2025) precedent found 63 dual-subreddit users between ideologically opposed communities. Fashion communities may have lower overlap (less polarized) or higher (more people interested in both fashion and sustainability). We cannot predict in advance.

**Minimum thresholds for RQ3 predictions — expanded for realistic effect sizes:**

| Analysis | Minimum dual-community users needed | Effect size assumed | Rationale |
|----------|-------------------------------------|---------------------|-----------|
| Community-level overlap statistics (Jaccard, overlap coefficient) | Any number ≥ 1 | N/A | Descriptive; no statistical test |
| Prediction 1: LIWC Tentativeness comparison (Mann-Whitney U, dual vs. single) at d = 0.5 (optimistic) | n ≥ 50 | d = 0.5 | α = 0.05, power = 0.80 |
| Prediction 1: LIWC Tentativeness comparison at d = 0.3 (realistic) | **n ≥ 175** | d = 0.3 | α = 0.05, power = 0.80. If hedging differences are subtle — as cognitive dissonance theory predicts for people who successfully compartmentalize — d = 0.3 is more realistic. |
| Prediction 1: LIWC Tentativeness comparison at d = 0.2 (conservative) | **n ≥ 400** | d = 0.2 | α = 0.05, power = 0.80. If the signal is weak, this threshold applies. |
| Prediction 2: Temporal sequence test (permutation test) | n ≥ 30 dual-community users with ≥3 posts in each context | N/A | Non-parametric; need sufficient within-user temporal variation |
| Prediction 3: Topic distribution comparison (JS divergence) | n ≥ 50 dual-community users with ≥5 posts per context | N/A | Need stable per-user topic estimates |

**Go/no-go decision tree (Week 1–2):**

| Dual-community users found | Action |
|---------------------------|--------|
| **n ≥ 175** | Full linguistic analysis (P1–P3) with adequate power for realistic effect sizes |
| **50 ≤ n < 175** | Proceed with P1–P3 but report as exploratory. State that only large effects (d ≥ 0.5) would be detectable. If results are null, explicitly note insufficient power as a possible explanation. |
| **30 ≤ n < 50** | P1 and P3 are underpowered. Conduct P2 (temporal sequence, which requires fewer users with more posts). Report P1/P3 as descriptive with individual dual-user case studies. |
| **n < 30** | Linguistic predictions infeasible. Paper pivots to community-level overlap statistics + qualitative close-reading of all available dual-community users' posts. This is still publishable — it documents whether the communities are genuinely segmented — but the theoretical contribution narrows. |

### Demographic Controls via Subreddit Co-Participation Proxies

Without demographic controls, differences in sentiment or topic distribution between subreddits may reflect *who uses each community* rather than *how sustainability is discussed*.

We apply the method of Waller & Anderson (2021), which "assign[s] a score for different demographic axes (such as age, gender, and affluence) and social axes (political leaning) to each subreddit" based on subreddit co-participation embeddings (described in arXiv 2302.07598, 2023). Users are scored by the weighted average of their subreddit participation scores: "A user's z-score for an attribute is the weighted average of the subreddit z-scores, weighted by the number of comments the user posted in each subreddit" (arXiv 2502.05049, 2025).

**Implementation**: For each user in our cross-posting analysis, compute age, gender, and affluence proxy scores from their full subreddit participation history (not limited to our 7 target subreddits). Include these as control variables when comparing dual-community vs. single-community users.

**Limitation — this method is weaker than the prior draft acknowledged**: A 2025 evaluation (arXiv 2502.05049) found that Waller & Anderson's method has "several notable limitations. As a fully unsupervised method, it lacks systematic evaluation to assess its reliability. Moreover, the approach relies on arbitrarily defined poles for each attribute, which have not been rigorously tested or validated. The use of a neural embedding-based model (Word2Vec) introduces additional challenges, as it renders the model a black box." The same study found that simple Naive Bayes trained on self-declared labels outperformed the WA embeddings, achieving ROC AUC above 0.7 — implying WA's accuracy is *below* 0.7 for some attributes. We use these proxies as coarse controls to flag demographic confounds, not as precise demographic measurements. If a finding reverses direction after including demographic controls, we flag it and do not over-interpret.

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

All cross-posting results must be reported with both Jaccard and Szymkiewicz-Simpson metrics, plus raw overlap counts and percentages relative to both communities.

### Week 8–10: Robustness Checks, Paper Writing & Visualization

**Weeks 8–9: Robustness and control analyses (reallocated from former RQ4):**
- Run the verbosity/style control test: LIWC Tentativeness of dual-community users in non-target subreddits vs. single-community users in the same subreddits.
- Run the community norm baseline test: compute the "expected" tentativeness for each community based on all users (not just dual-community), then test whether dual-community users deviate from this community-specific baseline.
- Sensitivity analysis for alt-account rates: "If X% of r/ethicalfashion users maintain separate alt-accounts for fast-fashion activity, how would this change the observed overlap rate?" Show the overlap range for plausible alt-account rates (2%–10%).
- Compile all results tables and statistical tests. Apply Bonferroni correction for multiple comparisons within each prediction.

**Weeks 9–10: Paper writing:**
- **Primary figures** (RQ3): Cross-posting overlap matrix (heatmap with both Jaccard and Szymkiewicz-Simpson); dual-community user LIWC Tentativeness comparison (violin plots); topic-distribution shift for dual- vs. single-community users (JS divergence); temporal sequence analysis (if n permits).
- **Supporting figures** (RQ1, RQ2): Time-series plots — sentiment trajectories per subreddit with event annotations (COVID, Shein exposés, Earth Day); topic evolution heatmaps (BERTopic and NMF).
- **Methodological figures**: Three-way sentiment model agreement matrix; annotation inter-rater agreement; BERTopic outlier rates; NMF vs. BERTopic topic comparison; demographic proxy distributions per subreddit; LIWC Tentativeness validation against manual hedge annotations.
- Write-up: ~20–25 pages.

## Team Task Allocation

| Team Member | Weeks 1–2 | Weeks 3–4 | Weeks 5–8 | Weeks 8–10 |
|-------------|-----------|-----------|-----------|------------|
| **Student A** | Corpus assembly from pre-downloaded data; deduplication; DataFrame construction | Manual annotation (125 posts, sentiment + hedging); LLM sentiment pipeline (local model inference) | Cross-posting user-overlap computation (both metrics); power analysis; dual-community user identification | **Robustness checks: verbosity/style control test; alt-account sensitivity analysis** (reallocated from former RQ4) |
| **Student B** | Cross-posting user census; user × subreddit matrix; demographic proxy computation (Waller & Anderson) | Manual annotation (125 posts); VADER sentiment pipeline | BERTopic topic modeling (user-within-thread aggregation); NMF comparison | Topic evolution figures; BERTopic/NMF diagnostics; community norm baseline test |
| **Student C** | EDA: post volume trends, text-length distributions, subreddit statistics, cliff-edge validation, user-deletion audit, bot/spam filtering | Manual annotation (125 posts); RoBERTa sentiment pipeline | Three-way sentiment agreement analysis; LIWC Tentativeness computation on full corpus; LIWC validation against manual hedge annotations | All figures and tables for paper |
| **Anna** | Research design; annotation guide refinement (from pre-camp draft); literature review finalization (attitude-behavior gap, cognitive dissonance, moral licensing replication crisis) | Manual annotation (125 posts); inter-annotator agreement computation | Dual-community user analysis: cognitive dissonance predictions (P1–P3) with demographic controls; temporal sequence permutation test | Paper writing; framing; interpretation of control test results |

## Publication Targets

| Venue | Fit | Realistic? |
|-------|-----|------------|
| **Fashion and Textiles** (Springer) | Directly relevant; accepts mixed-methods. Position against Aydin & Ogunleye (2026) in same domain. | ✅ Strong fit |
| **Sustainable Production and Consumption** | Sustainability + consumer behavior | ✅ Good fit |
| **SSRN / arXiv preprint** | Immediate visibility | ✅ Do this first |
| **Sustainability** (MDPI, IF ~3.9) | Open access; accepts NLP + sustainability. Note: the Fashion Greenwashing paper (2025) was published here. | ✅ Good fallback |
| **ACM Conference on Web Science** | Cross-posting analysis + cognitive dissonance framing is a strong computational social science contribution | ⚠️ Possible if methods are foregrounded |
| ~~*Journal of Cleaner Production*~~ | Expects rigorous causal identification (IV, DiD, RCT), not correlations | ❌ Would likely desk-reject |
| ~~*Journal of Consumer Research*~~ | Requires survey/experimental data, not observational NLP | ❌ Wrong methodology for venue |

## Risks, Unknowns, and Open Questions

### Data Risks

| Risk | Severity | Mitigation | Residual Uncertainty |
|------|----------|------------|---------------------|
| **Arctic Shift post-2023 data gaps** | Medium (downgraded) | The Arctic Shift maintainer confirmed data completeness post-June 2023. **Validation**: Plot monthly post counts per subreddit. Exclude April-June 2023 if volumes drop. | Score/attention data has a known issue: "Until 11/2023 arctic_shift didn't update entries, meaning between 07-10/2023 score is ~zero" (u/joaopn, r/pushshift, May 2025). Do not use post scores from July-October 2023. |
| **User-deletion asymmetry between PushShift and Arctic Shift eras** | High (for cross-posting) | PushShift overwrote `[deleted]` authors (23% of submissions in its last year), while Arctic Shift preserves them (only 2%). **Report user-deletion rates per period.** | Apparent increases in cross-posting over time may partially reflect better data preservation rather than genuine behavioral changes. This temporal confound is irreducible. |
| **Bot and promotional spam contamination (NEW)** | Medium | Bot-filtering heuristics applied in Week 1 (see §Data Validation). Report removal rates per subreddit. | Sophisticated promotional accounts that mimic genuine users will pass filters. The rate of undetected promotional accounts in r/Shein is unknown. If dual-community "users" include brand-affiliated accounts, cross-posting statistics are inflated. |
| **r/femalefashionadvice keyword filter yield unknown** | Medium | Validate in Week 1. If < 50 Shein-mentioning posts/month, expand keyword list or add r/fashion, r/PlusSize, r/PlusSizeFashion. | Keyword filtering misses coded/indirect references. |
| **Deleted/overwritten content biases the archive** | Medium | Count proportion of `[deleted]`/`[removed]` posts per subreddit per year. Report alongside all results. | If privacy-conscious users disproportionately delete sustainability-related posts, the archive under-represents a specific population. |

### Methodological Risks

| Risk | Severity | Mitigation | Residual Uncertainty |
|------|----------|------------|---------------------|
| **All three sentiment models fail on fashion discourse** | High | The 500-post manual annotation quantifies failure rate. **Contingency**: If all methods score < 0.65 accuracy, switch to aspect-based analysis via LLM. | No fashion-specific sentiment model exists. VADER was built in 2014. RoBERTa's training ended in 2021. |
| **LIWC Tentativeness may not capture fashion-specific hedging (NEW)** | Medium | The 500-post manual hedge annotation validates LIWC against human judgments. Report ROC-AUC. If LIWC-human agreement is below 0.6 AUC, report the discrepancy as a finding about the inadequacy of general-purpose hedging tools for fashion discourse. | LIWC's dictionary was built from general English. Fashion-specific hedging patterns ("I know Shein is problematic but...") may use tentative markers in combination with domain-specific language that LIWC captures partially. The domain-specific justification phrase list addresses this gap but is not validated. |
| **BERTopic outlier problem on Reddit text** | Medium | User-within-thread aggregation preserves coherence. Set `min_topic_size=30`. Use `reduce_outliers()`. **NMF as robust fallback** — no outlier bin, coherence 0.573 on r/SustainableFashion (arXiv 2412.14486). If BERTopic outlier rate > 40%, NMF becomes primary. | BERTopic can assign "over 74% of the dataset" to outlier bin (Grljević et al. 2024). Even with mitigations, 20–40% outlier rates are common on short text. |
| **Cross-posting overlap may be negligibly small** | High | Power analysis in Week 1 determines feasibility. If < 50 dual-community users, pivot to community-level overlap + qualitative close-reading. | A null result in overlap is NOT straightforwardly interpretable (see alt-account selection paradox). |
| **Power analysis assumes wrong effect size (NEW)** | High | We report thresholds for d = 0.5, d = 0.3, and d = 0.2. The go/no-go decision tree specifies actions for each user-count range. | We cannot know the true effect size before running the study. If we find n = 80 dual-community users (enough for d = 0.5 but not d = 0.3), we proceed but report that only large effects would be detectable and that null findings are uninterpretable with respect to power. |

### Conceptual Risks

| Risk | Severity | Discussion |
|------|----------|------------|
| **Alt-account selection paradox (CRITICAL for RQ3)** | **Very High** | The cross-posting analysis can only detect users who post in both sustainability and fast-fashion communities **under the same username**. This creates a paradox: (a) Users who DON'T feel cognitive dissonance have no reason to separate identities — they are the *least* interesting cases. (b) Users who DO feel the gap — guilt, shame, identity conflict — are precisely the users most likely to use separate accounts, making them *systematically invisible*. **The analysis selects for the wrong population.** High cross-posting overlap could mean "many people feel comfortable in both spaces" (weak gap). Low overlap could mean "people feel the gap so strongly they use alts" (strong gap, but invisible). Both outcomes are consistent with both hypotheses. **Mitigations**: (1) State the paradox explicitly. (2) Sensitivity analysis: show overlap range for plausible alt-account rates (2%–10%). (3) Acknowledge cross-posting signal is a **lower bound** on true overlap. (4) Flag stylometric analysis as future work (beyond 10-week scope; raises additional ethics concerns). |
| **Community norm compliance vs. genuine cognitive dissonance (NEW — CRITICAL)** | **Very High** | Hedging and justification language in Reddit posts could reflect **community norms** rather than **internal dissonance**. In r/ethicalfashion, the social norm is that you *must* acknowledge sustainability concerns. Mentioning any fast-fashion purchase without hedging would invite criticism. So all users hedge about fast fashion there — not because of internal dissonance, but because of audience management. A recent paper on computational detection of cognitive dissonance (arXiv 2502.13326, 2025) argues that "experimentally-evoked cognitive styles can indeed be captured by language," but only when cognitive state was "measured via experiments." The authors recommend "incorporating direct behavioral measurements into linguistic analyses, moving beyond traditional annotation-based methods." **We cannot establish that linguistic markers in observational Reddit data reflect genuine cognitive dissonance.** **Mitigation**: (1) The verbosity/style control test (LIWC Tentativeness in non-target subreddits) distinguishes global communication style from context-dependent shifting. (2) The community norm baseline test compares dual-community users against all users in the same community, isolating deviation from the community-wide hedging rate. (3) All findings are framed as "patterns consistent with cognitive dissonance theory" — not as evidence *of* dissonance. |
| **Moral licensing prediction rests on disputed empirical ground (NEW)** | **High** | The 2025 PSPB meta-analysis found "moderate evidence against licensing when unobserved (Hedge's g = −0.01; BF₁₀ = 0.11)." Rotella & Barclay (2020) concluded licensing effects are "unlikely to be elicited online." Our temporal sequence test (P2) may find no licensing pattern — and this null result is more consistent with the current evidence base than a positive finding. **We present P2 as a bidirectional test of competing hypotheses (licensing vs. consistency), not as a prediction of licensing.** |
| **Reddit ≠ fashion consumers** | High | Reddit's demographics have shifted — "in the UK and the US, Reddit's surging user base is now more than 50% women" and "high-growth areas have been fashion, beauty, TV fandom" (Reddit VP, Vogue 2025). However, Reddit users who post in fashion subreddits are still a self-selected, text-literate minority. Reddit captures discourse *about* fast fashion; it does not capture the primary *driver* of fast fashion purchasing (TikTok haul videos, Instagram ads). |
| **Cross-posting ≠ purchasing** | High | Posting in r/Shein does not mean purchasing from Shein. A user active in both r/ethicalfashion and r/Shein could be: (a) a critic monitoring the brand, (b) someone asking about sizing for a gift, (c) someone who bought once, regretted it, and posts warnings, or (d) genuinely expressing the attitude-behavior gap. We cannot distinguish these cases without reading every post. The LIWC-based predictions partially address this — users expressing more tentativeness are more likely to be cases (c) or (d). But the ambiguity is irreducible. |
| **Attitude-behavior gap may render all discourse analysis irrelevant** | High | The core finding of this literature is that pro-sustainability sentiment does NOT predict sustainable purchasing. If discourse is systematically disconnected from behavior, then our entire analysis describes a phenomenon (discourse patterns) with no demonstrated link to the phenomenon of interest (purchasing behavior). We address this by framing our contribution as descriptive — we document how people *talk* about fast fashion, not how they *act* — and by acknowledging the gap explicitly. |
| **Pseudonymity and alt-accounts** | High | Throwaway account prevalence is estimated at 2.6%–3.8% among active commenters (shaggorama, r/TheoryOfReddit, 2012), while "a rather small percentage of users in our dataset used throwaway accounts (1,209 users; 4.46%)" in health communities (ScienceDirect 2024). The rate of *persistent alt-accounts* (not throwaways) is unknown and likely higher. See alt-account selection paradox. |
| **Demographic confounds** | Medium | Waller & Anderson (2021) proxies provide crude controls. Without them, all cross-community comparisons are potentially confounded by user-base differences. Even with them, the proxies are noisy (ROC AUC below 0.7 for some attributes per arXiv 2502.05049). |
| **Novelty erosion from Aydin & Ogunleye (2026)** | Medium | RQ1 and RQ2 are no longer novel in isolation. The paper's contribution depends critically on RQ3 (cross-posting). If RQ3 produces insufficient data, the remaining contribution reduces to "replication of Aydin & Ogunleye with more methods" — publishable but thin. |

### Ethics

- **IRB**: The research protocol should be reviewed by the supervising institution's IRB. All data is publicly available, but: "research has shown that users often have differing understandings of what it means for [their data to be public]" (Fiesler et al., ACM CSCW 2024). Reddit users posting about personal fashion choices may not expect their posts to be analyzed in an academic study.
- **Data handling**: All usernames replaced with anonymized identifiers after cross-posting matrix construction. Raw username data stored securely and deleted after analysis. "All collected data is securely stored, with access restricted to the research team. After identifying [relevant] accounts, all account names were replaced with unidentifiable labels" (arXiv 2501.17430, USEC 2025).
- **No individual-level reporting**: Results reported at the aggregate level only. No individual user's posting history is reproduced in the paper. Direct quotes from Reddit posts paraphrased or anonymized. A 2022 study on research ethics found that of 19 papers attempting to disguise Reddit quotes by rewording, 50% had at least one quote that could be located via search (Disguising Reddit sources, PMC 9463657, 2022). **We paraphrase aggressively and do not disclose specific thread URLs.**
- **Stylometric analysis ethics note**: If stylometric alt-account detection is explored (even as a pilot), this raises additional privacy concerns. Any stylometric analysis should be discussed with the IRB. We do NOT conduct stylometric analysis in this study; it is flagged as a future direction only.

## Key References

### Prior Work — Direct Predecessors
- **Aydin, G. & Ogunleye, B. (2026).** "What consumers really think about sustainable fashion: A computational analysis of online discussions." *Journal of Global Fashion Marketing*. DOI: 10.1080/20932685.2026.2646924.
- **"Consumer Awareness of Fashion Greenwashing: Insights from Social Media Discussions" (2025).** *Sustainability*, 17(7), 2982.

### Topic Modeling Methodology
- **"Moving Beyond LDA: A Comparison of Unsupervised Topic Modelling Techniques for Qualitative Data Analysis of Online Communities" (arXiv 2412.14486, December 2024).** [Tested LDA, BERTopic, NMF on 12 Reddit datasets including r/SustainableFashion. NMF coherence 0.573 > LDA 0.386 on r/SustainableFashion.]

### Primary Literature (Cognitive Dissonance and Attitude-Behavior Gap)
- Festinger, L. (1957). *A Theory of Cognitive Dissonance*. Stanford University Press.
- Celik, H. & Ekici, A. (2024). *Journal of Business Ethics*, 196, 917–936.
- Carrigan, M. & Attalla, A. (2001). *Journal of Consumer Marketing*, 18(7), 560–578.
- Carrington, M.J., Neville, B.A., & Whitwell, G.J. (2014). *Journal of Business Research*, 67(1), 2759–2767.
- White, K., Hardisty, D.J., & Habib, R. (2019). "The elusive green consumer." *Harvard Business Review*.
- Monin, B. & Miller, D.T. (2001). *Journal of Personality and Social Psychology*, 81(1), 33–43.
- Bläse, R. et al. (2023). "Non-sustainable buying behavior: FOMO drives purchase intentions in fast fashion." Wiley.

### Moral Licensing Replication Crisis (NEW)
- **Kuper, N. & Bott, A. (2019).** "Has the evidence for moral licensing been inflated by publication bias?" *Meta-Psychology*. [PET-PEESE adjusted effect: d = −0.05 to d = 0.18, down from meta-analytic d = 0.31.]
- **"Observation Moderates the Moral Licensing Effect: A Meta-Analytic Review" (2025).** *Personality and Social Psychology Bulletin*. DOI: 10.1177/01461672251345512. [115 experiments, N = 21,770. Licensing g = 0.65 observed vs. g = −0.01 unobserved. "Elicited through interpersonal motives."]
- **Rotella, A. & Barclay, P. (2020).** "Failure to replicate moral licensing and moral cleansing in an online experiment." *Personality and Individual Differences*. ["Licensing and cleansing effects are unlikely to be elicited online."]
- **Blanken, I., van de Ven, N., & Zeelenberg, M. (2015).** "A Meta-Analytic Review of Moral Licensing." *Personality and Social Psychology Bulletin*. [91 studies, 7,397 participants. Cohen's d = 0.31. "Published studies tend to have larger moral licensing effects than unpublished studies."]

### Cognitive Dissonance Computational Detection (NEW)
- **"Can Language capture Cognitive Dissonance?" (arXiv 2502.13326, 2025).** [AUC ~0.8 for detecting experimentally-evoked cognitive styles via language. Argues controlled experiments needed, not observational annotation.]

### Secondhand Rebound (NEW)
- **"Secondhand fashion consumers exhibit fast fashion behaviors despite sustainability awareness" (PMC 12504660, 2025).** ["This supports the idea of moral licensing, whereby prior ethical actions (e.g., buying used clothing) serve to justify less sustainable choices thereafter."]

### Attitude-Behavior Gap Reviews (NEW)
- **"I Don't Buy It! A Critical Review of the Research on Factors Influencing Sustainable Fashion" (Sustainability, 2025).** ["All surveys rely on self-reported data... A significant limitation of self-report measures in the context of GABB is that they do not constitute actual behavioral measures."]

### Social Identity and Performance
- Goffman, E. (1959). *The Presentation of Self in Everyday Life*. Doubleday.
- Entwistle, J. (2000). *The Fashioned Body*. Polity Press.
- Stryker, S. & Burke, P.J. (2000). *Social Psychology Quarterly*, 63(4), 284–297.

### NLP Methods and Sentiment Analysis
- He, Y. et al. (2025). "Using Large Language Models for sentiment analysis of health-related social media data." *PMC*.
- Burnham, M. et al. (2024). arXiv 2406.08660.
- cardiffnlp (2022). "twitter-roberta-base-sentiment-latest." HuggingFace model card.
- Grljević, O. et al. (2024). arXiv 2402.03067.

### Hedging Detection (NEW)
- **Islam, J., Xiao, L., & Mercer, R.E. (2020).** "A Lexicon-Based Approach for Detecting Hedges in Informal Text." *LREC 2020*. [Precision 57.6%, recall 64.9% on informal text.]
- **"Training LLMs to Recognize Hedges in Spontaneous Narratives" (arXiv 2408.03319, 2024).** ["Fine-tuning BERT significantly outperforms state-of-the-art LLMs in few-shot and zero-shot settings" for hedge detection.]
- **Pennebaker, J.W. et al. (2015).** LIWC documentation. [Tentativeness and Certainty dictionaries.]

### Fast Fashion and Sustainability
- Soboleva, D. & Sánchez, A. (2024). arXiv 2407.18814.
- "Emotional Analysis of Fashion Trends Using Social Media and AI" (arXiv 2505.00050, 2025).

### Cross-Posting Methodology
- Pilaud, M. & McCulloh, I. (2025). arXiv 2507.16857. [63 dual-subreddit users between r/Sino and r/China.]
- arXiv 2402.14177 (2024). "Investigating Human Values in Online Communities."

### Demographic Inference
- Waller, I. & Anderson, A. (2021). *Proceedings of the International AAAI Conference on Web and Social Media*.
- **arXiv 2502.05049 (2025).** "On the Inference of Sociodemographics on Reddit." [WA method: "relies on arbitrarily defined poles... which have not been rigorously tested or validated." Naive Bayes outperforms WA with supervised labels.]

### Narrative Economics (Supplementary)
- Shiller, R. (2017). *American Economic Review*, 107(4), 967–1004.
- Skwire, S. (2020). "Sick of Metaphors: Reading Shiller's Narrative Economics." *Econlib*.

### Reddit Data, Ethics, and Alt-Accounts
- open-index/arctic (2025). "Arctic Shift Reddit Archive." HuggingFace.
- Fiesler, C. et al. (2024). "Reddit data and research ethics." *ACM CSCW*.
- arXiv 2501.17430 (2025). "Throwaway Accounts and Moderation on Reddit." USEC 2025.
- **"Disguising Reddit sources and the efficacy of ethical research" (PMC 9463657, 2022).** [50% of papers attempting to disguise Reddit quotes had locatable quotes.]

## Why This Project Succeeds

- **Genuinely novel contribution**: The cross-posting analysis with cognitive dissonance predictions (RQ3) is new. No existing paper — including Aydin & Ogunleye (2026) — examines within-Reddit community-affiliation behavior to test the attitude-behavior gap in fashion at the individual user level.
- **Honest theoretical positioning**: By citing the moral licensing replication crisis and testing bidirectional predictions (licensing vs. consistency), the proposal avoids building on a disputed empirical foundation. Reviewers in psychology will see that the authors know the literature.
- **Operationalized measurements**: Unlike the prior draft, every prediction has a specified measurement (LIWC Tentativeness, permutation-based temporal tests, Jensen-Shannon divergence), an alternative explanation, and a control test. Nothing is hand-waved.
- **Honest positioning against prior art**: By citing Aydin & Ogunleye (2026) and framing RQ1/RQ2 as extensions rather than novel contributions, the proposal avoids the most likely desk-reject scenario.
- **Domain credibility**: Anna's Fashion Studies minor provides the theoretical grounding that pure CS/NLP papers in this space lack.
- **Methodologically current**: Three sentiment methods (lexicon, transformer, LLM) with human-annotated validation. NMF included based on empirical evidence from the exact subreddit under study.
- **Tighter scope**: Three RQs, not four. No time-series analysis that the prior draft itself admitted was unreliable. No dead-weight theoretical frameworks. Every component serves the central contribution.
- **Pre-specified power analysis with realistic effect sizes**: The go/no-go threshold for RQ3 includes d = 0.3 and d = 0.2, preventing the team from proceeding with an underpowered study.
- **Robust to negative results — with caveats**: If cross-posting overlap is negligibly small, that is publishable as evidence of community segmentation — with the alt-account selection paradox explicitly acknowledged. If sentiment models fail on fashion discourse, that is a finding about tool limitations. If temporal sequence shows consistency rather than licensing, that is *more consistent with the current evidence base* and itself a contribution.

## What Would Make This Stronger (Beyond 10-Week Scope)

These are documented for future extension, not proposed for the summer camp:

1. **TikTok data**: The platform actually driving fast fashion purchasing. TikTok Research API exists for academics but requires institutional approval and returns video metadata, not transcripts — would need Whisper-based transcription.
2. **Survey validation**: Pair Reddit NLP findings with a small survey (n=200) of Reddit users about their actual purchasing behavior. Would directly test whether cross-posting predicts self-reported purchasing.
3. **Stylometric alt-account detection**: Use writing-style analysis to estimate the true rate of alt-account usage across fashion communities. Would directly address the alt-account selection paradox. Achieves ~90% accuracy (stylometry.net, 2022). Requires careful IRB review.
4. **Fine-tuned hedge detection model**: Use the 500 manual hedge annotations to fine-tune a small BERT model for fashion-specific hedge detection. A 2024 study found "fine-tuning BERT significantly outperforms state-of-the-art LLMs in few-shot and zero-shot settings" for hedging (arXiv 2408.03319). This would improve on LIWC's general-purpose dictionary.
5. **Causal identification**: An event study design around specific Shein exposés (e.g., Channel 4 documentary) could provide quasi-causal evidence if the exposé timing is exogenous to sentiment trends.
6. **Fine-tuned fashion-domain sentiment model**: Use the 500 manual sentiment annotations + LLM silver labels to fine-tune a small RoBERTa model for fashion discourse. "Fine-tuned 'small' LLMs (still) significantly outperform zero-shot generative AI models" (Burnham et al., arXiv 2406.08660, 2024).
7. **Experimental validation of cognitive dissonance predictions**: Following the framework of arXiv 2502.13326 (2025), pair observational Reddit data with controlled experimental tasks to establish that the linguistic patterns we detect correspond to measured cognitive dissonance, not performative hedging.
