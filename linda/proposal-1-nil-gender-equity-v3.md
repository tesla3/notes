# Proposal 1 (v3): The Football Gap — Descriptive Accounting, ML Prediction, and Causal Decomposition of Gender Disparities in College NIL Markets

## Summary

The NCAA NIL market has grown from $917M (2021–22) to a projected $2.75B (2025–26) (Opendorse, "NIL at 3," 2024). Football alone captures 49.9% of all NIL compensation dollars. Women receive less than 3.5% of collective NIL payments.

But here is the structural fact that reframes the entire debate: when football is removed from the denominator, the aggregate gender gap narrows dramatically — though **it does not disappear**. AP News (July 2022) reported: "Remove football and women flip it to 52.8% vs. 47.2% for men" in total compensation. Opendorse found women account for roughly 53% of all NIL *activities* (social media posts, brand engagements) when football is excluded. Yet Sportico (2023) reported that "even after subtracting football, [the funding figure] was still nearly 60%" male. And by 2025, Opendorse's own platform data showed women submitted only "32.2% of the 500K NIL deal applications" (Opendorse/The GIST, 2025).

**The observation that football drives the aggregate gap is already known.** What is *not* known is: (a) how large the residual within-sport gap is after controlling for observable athlete, team, and school characteristics; (b) how that gap varies by sport, quantile, and time; and (c) what share of the residual gap can be attributed to differences in observable endowments versus unexplained factors. This project provides that analysis.

We pursue three tracks, ordered by what they can credibly deliver:

1. **Primary: Descriptive accounting (Track 1).** The gender gap with and without football, within individual sports, by quantile, and over time. No causal assumptions required. Likely the highest-impact contribution.
2. **Secondary: Predictive ML (Track 2).** What observable features best predict an athlete's estimated NIL market value? XGBoost + SHAP explainability — framed as a study of On3's algorithm structure, not of actual compensation.
3. **Conditional: Causal decomposition (Track 3).** Within gender-comparable sports only, how much of the male–female NIL gap is explained by observables versus unexplained factors? Double Machine Learning (Chernozhukov et al. 2018). **This track proceeds only if matched-sample size exceeds N=500 total across pooled gender-comparable sports.** If not, it is replaced by a structured OLS decomposition with Cinelli & Hazlett (2020) sensitivity analysis.

We are explicit about what these methods can and cannot tell us. Prediction is not causation. Unexplained gaps are not proof of discrimination. Estimated valuations are not actual compensation. But rigorous descriptive and predictive analysis, layered with careful causal reasoning, can sharpen the policy conversation about where structural inequity does and does not operate.

---

## Why Anna

She was a D1 Women's Rower at Cornell who retired due to injury and became team manager. She lived the invisible-athlete experience — rowing is a non-revenue sport where NIL dollars barely exist. She watched the NIL revolution unfold during her four years (2020–2024). This isn't academic to her; it's autobiographical. That authenticity matters for presentation and publication.

Critically, Anna's experience illustrates the **sport-structure confound** at the heart of this paper: her invisibility was not because she was a woman, but because she was in a non-revenue sport. Men's rowing gets almost no NIL either. Separating "gender effect" from "sport-revenue effect" is the core intellectual challenge of this project.

---

## Theoretical Framework

### Why would we expect a gender gap in NIL?

**Demand-side explanations (market-based):**
- **Viewership differentials.** Men's football and basketball generate vastly more TV revenue and live attendance than women's sports. If NIL valuations reflect brand ROI, then athletes in higher-viewership sports command higher valuations. This is a market-efficiency argument: the gap reflects underlying consumer demand, not discrimination per se.
- **Advertiser preference.** Brands may preferentially target athletes in sports that reach their target demographics. Football reaches a different advertiser base than volleyball.

**Supply-side explanations (structural):**
- **Agent and representation asymmetry.** Male athletes in revenue sports are more likely to have professional NIL agents and brand managers. Female athletes in non-revenue sports often negotiate their own deals.
- **Collective structure.** Collectives are primarily funded by boosters of football and men's basketball. LeRoy (2025) found that "men's basketball players in major NCAA conferences were paid an average of $171,272 in 2024, compared to $16,222 for women" — and showed that schools coordinate with collectives to "monetize NIL donor access in favor of men" (LeRoy, "NCAA Women Athletes and NIL Pay Disparities," *U. Cincinnati Law Review*, 93(4), 979, 2025).
- **Media exposure feedback loop.** Less media coverage → fewer followers → lower NIL valuation → less media interest. Rogers (2023, Indiana University) found that "media exposure has a large impact on the NIL benefits afforded to athletes" and that "both male and female NIL frequency in collectives had a strong, positive correlation with media impact (0.6824, 0.6095)."

**Sociocultural explanations:**
- **Femininity and marketability.** Wanzer (2024) found that "high-earning women athletes were much more likely than male athletes to post 'attractive appearance' content" (cited in Sailofsky, "The privilege to do it all?", *International Review for the Sociology of Sport*, 2025). This suggests that women's NIL success may be conditional on performing femininity — a different mechanism than athletic performance.

**The key question is not "is there a gap?" — we know there is. The question is: what share is mechanical (football having no female equivalent), what share is explained by observable differences within comparable sports, and what share remains unexplained?**

---

## What We Measure vs. What We Claim

| What We Do | What It Tells Us | What It Does NOT Tell Us |
|---|---|---|
| Descriptive gap accounting ± football | How much football mechanically drives the aggregate gender gap | Anything causal — this is accounting |
| Quantile/time decomposition | Where and when the gap is largest | Why the gap is large at those points |
| Predict On3 NIL Valuation with XGBoost | Which features are most predictive of *estimated* market value | What *causes* an athlete to be valued more or less |
| SHAP values on the prediction model | Feature importance for On3's algorithm structure | Causal effects of any feature |
| Double ML decomposition within matched sports | How much of the within-sport gender gap is explained by observables vs. unexplained | Whether the unexplained gap is "discrimination" — it could be omitted variables |

---

## The Dependent Variable Problem

### What On3 NIL Valuation actually is

**On3's NIL Valuation is itself a proprietary ML algorithm.** On3 states: "The algorithm-driven On3 NIL Valuation comes from 27 years of data and science innovation in college sports publishing... developed with the assistance of multiple machine learning engineers" (On3, "About On3 NIL Valuation"). It combines social media followers, athletic performance, and exposure metrics into an estimated market value — **not actual deal compensation**.

Industry reporting provides approximate weight ranges: "Social media presence accounts for approximately 30-40% of the calculation, measuring follower counts across Instagram, Twitter, and TikTok, along with engagement rates and content quality. Athletic performance contributes another 25-35%, incorporating statistics, rankings, awards, and projected professional potential. Team success and media exposure add 15-20%" (Bitget/On3 Guide, 2025).

Industry observers are blunt: the Substack "NIL Illusion" warned that On3 creates "a system where NIL values are based more on perception than reality" and that "platforms often rely on" incomplete data, creating a situation where "NIL values are based more on perception than reality" (Rodriguez, "The NIL Illusion," *CTRL.FORM Substack*, April 2025).

### The circularity problem

**We are predicting one ML model's output with another ML model.** If On3's algorithm is 30-40% social media followers, and we use social media followers as a predictor, we will achieve high R² and large SHAP values for followers — but we have partly rediscovered On3's engineering decisions, not market economics.

**What this means for each track:**

- **Track 1 (Descriptive):** Unaffected. We describe the distribution of On3 valuations as they are. The circularity does not bias descriptive statistics.
- **Track 2 (Predictive ML):** We are analyzing **the structure of On3's estimated market valuations** — what On3's algorithm weights, how those weights differ by gender, and whether gender systematically shifts predicted valuations. This is a study of how On3 *perceives* athlete value, not of how the market actually compensates athletes. We state this framing in the paper title, abstract, and throughout.
- **Track 3 (DML):** The circularity is more serious here. If controls X include variables that are *inputs* to the On3 algorithm (followers, performance, school brand), we are partialing out the DV's own construction. The remaining "gender effect" is the residual that On3 chose *not* to encode through those inputs. We address this by running specifications with and without On3-input variables and clearly labeling what each estimates.

### Cross-validation with non-algorithmic data

We use two non-algorithmic data sources to check whether On3-based findings hold:
- **EADA institutional data** (actual revenues and expenses by sport and gender, reported by schools to the Department of Education)
- **Opendorse aggregate transaction statistics** based on "$250 million in real NIL transactions" from "150,000+ anonymized transactions from 125,000+ student-athletes" (Opendorse, "NIL at 3," 2024)

Neither provides individual-level actual deal values. But if the descriptive patterns from On3 match the aggregate patterns from Opendorse, our findings are not artifacts of On3's algorithm.

### NIL Go: Potential future data source (low probability for this project)

The House v. NCAA settlement, approved June 6, 2025, established **NIL Go** — a clearinghouse run by Deloitte. "Athletes are now mandated to report any third-party NIL deals exceeding $600 to NIL Go" (ForwardPathway, 2025). "All NIL transactions with a total value of $600 or more must be reported by student-athletes and member institutions" (Ropes & Gray, June 2025).

**We assess the probability of researcher access as LOW during this project.** Evidence:
- The College Sports Commission (CSC) CEO Bryan Seeley stated the clearinghouse was "struggling" and that "I don't think the system was designed with this amount of associated deals in mind" (Yahoo Sports/Sports Business Journal, May 2025).
- Deloitte shared that "70% of past deals from booster collectives would have been denied" (Sports Business Journal, May 2025) — but this data was shared with coaches and ADs, not researchers.
- When ESPN requested NIL disclosure from 23 schools, "colleges still released few to no records," citing FERPA (Georgetown Law Tech Review, 2024). UCLA invoked FERPA to withhold business names, "saying that information could be reverse-engineered to ID students" (FOIAball, 2025).
- The Georgetown Law Tech Review found that "absent a federal mandate, colleges would likely resist transparency, citing FERPA and state laws that prohibit the disclosure of student records" (2024).
- FOIAball, a dedicated FOIA-for-sports journalism outlet, has obtained some school-level data from public universities (e.g., UCLA's 952 NIL deals from April 2022 to May 2024), but this required persistent FOIA requests and produced partial, inconsistent data.

**Action:** We monitor CSC announcements and, if aggregate reports become available, use them as validation. We do not build the project timeline around this data source.

---

## Distinguishing Activities from Compensation

A critical distinction the prior version conflated:

| Metric | Source | What It Measures | Who Leads |
|---|---|---|---|
| **NIL activities** (social media posts, brand mentions) | Opendorse | Volume of brand-related content athletes produce | Women ~53% (excl. football, 2022) |
| **NIL compensation** (dollars received) | Opendorse | Actual money paid to athletes | Men ~60%+ even excl. football (Sportico, 2023) |
| **NIL deal applications** | Opendorse | Athlete-initiated deal-seeking | Women 32.2% (2025) |
| **On3 NIL Valuation** (estimated market value) | On3 | Algorithmic estimate of what an athlete *could* earn | Men dominate (all top-20 are male, per Cottongim) |
| **Collective payments** | Opendorse | Money from booster collectives | Women <3.5% |

**The gap between activities and compensation is itself a finding.** Women do more NIL work (posts, brand mentions) but receive less money. This is consistent with the "femininity and marketability" channel (Sailofsky 2025): women perform more content labor for lower returns. We report all five metrics and discuss the divergence.

---

## Causal Structure: The DAG

Any causal claim requires an explicit directed acyclic graph (DAG). We propose the following:

```
                    ┌──────────────┐
                    │  Gender (D)  │
                    └──────┬───────┘
                           │
              ┌────────────┼────────────────┐
              │            │                │
              ▼            ▼                ▼
        ┌──────────┐ ┌──────────┐    ┌──────────────┐
        │  Sport   │ │  Media   │    │   Direct     │
        │ Selection│ │ Coverage │    │Discrimination│
        └────┬─────┘ └────┬─────┘    │   (?)        │
             │            │          └──────┬───────┘
             ▼            ▼                 │
        ┌──────────┐ ┌──────────┐           │
        │  Sport   │ │  Social  │           │
        │ Revenue  │ │  Media   │           │
        │          │ │ Followers│           │
        └────┬─────┘ └────┬─────┘           │
             │            │                 │
             └─────┬──────┘                 │
                   │                        │
                   ▼                        ▼
              ┌────────────────────────────────┐
              │      NIL Valuation (Y)         │
              └────────────────────────────────┘
```

**Key implications of this DAG:**

1. **Sport Selection and Sport Revenue are mediators, not confounders.** Gender causes sport selection (women cannot play football); sport selection causes revenue differences; revenue causes NIL valuation. Controlling for sport or revenue *blocks* this pathway and estimates only the direct effect of gender within sport — not the total effect including the structural pathway.

2. **Media Coverage and Social Media Followers are mediators.** Gender → less media coverage for women's sports → fewer followers → lower NIL valuation. Controlling for followers blocks this pathway. The resulting estimate captures only the direct discrimination channel — whether, conditional on equal followers and performance, women are valued less.

3. **The total effect vs. direct effect distinction is policy-critical.** If the entire gender gap operates through the sport-revenue and media-coverage pathways (and there is no direct discrimination), the policy response is structural: increase investment in women's sports media. If there is a direct effect even after conditioning on observables, the policy response targets platform algorithms, collective governance, or advertiser behavior.

**What each track estimates:**

| Track | What It Estimates | Controls Included |
|---|---|---|
| Track 1 (Descriptive) | Total gap, football-adjusted gap, within-sport gap | None (raw comparisons) |
| Track 2 (ML + SHAP) | Predictive importance of gender and other features for On3 valuation | All available features |
| Track 3a (DML, full controls) | **Direct effect** of gender on NIL valuation, within matched sports, holding followers/performance/school constant | Followers, performance, school revenue, conference |
| Track 3b (DML, no mediators) | **Total within-sport effect** of gender, conditioning only on pre-treatment variables | Class year, recruit rating, conference (no followers, no performance) |

**We report both Track 3a and 3b** and compare them. The difference between the two estimates reveals how much of the within-sport gap operates through the media-coverage/followers pathway. This is a form of implicit mediation analysis (Imai, Keele, & Tingley, 2010).

---

## Data Sources

| Source | What It Provides | Access | Limitations |
|---|---|---|---|
| **On3 NIL Rankings** | Per-athlete *estimated* NIL valuation, sport, school, conference, social media follower counts | on3.com — scraping (see Risks) | Estimated values, not actual deals. Proprietary algorithm. Anti-scraping measures. |
| **NCAA EADA Data** | School-level athletic revenues, expenses, participation counts, coaching salaries — by sport and gender | ope.ed.gov/athletics — free CSV download, 2003–2024 | School-level, not athlete-level. Cannot be directly merged with individual NIL valuations without ecological inference. |
| **Opendorse Annual Reports** | Aggregate NIL transaction statistics by sport, gender, conference. Based on actual disclosed deals. | Public PDFs ("NIL at 3," "NIL at 4") | Aggregate only — no individual-level microdata. |
| **Sports-Reference** | Team win/loss records, conference standings, individual player statistics for some sports | sports-reference.com — scraping | Coverage varies by sport. Women's non-revenue sports have sparse data. |
| **Social media** | Follower counts and engagement | Via On3 profile embeds only | We do NOT scrape Instagram/TikTok directly. Both platforms aggressively block automated access. On3's embedded counts are sufficient. |

### Sample Construction

**Full sample (Tracks 1–2):** On3 athletes with published NIL valuations. We target the top 1,000–2,000 athletes across all sports, not just the top 100. On3 tracks "10,000+ D1 athletes" — but depth of coverage thins rapidly outside revenue sports.

**Matched sample (Track 3):** Athletes in **gender-comparable sports only** — basketball (M vs. W), soccer (M vs. W), swimming (M vs. W), track & field (M vs. W), volleyball (M vs. W where both exist). Football and women-only sports (gymnastics, softball) are excluded because they have no cross-gender counterpart. **Track 3 proceeds only if the matched sample exceeds N=500 total (across all pooled sports).**

**Institutional sample:** All D1 schools reporting EADA data (~350 schools). Merged with On3 school-level aggregates.

---

## Methodology

### Track 1: Descriptive Accounting (PRIMARY — Weeks 4–6)

**Goal:** Quantify the gender gap in On3 NIL Valuations across every meaningful cut.

**Analyses:**
- Full-sample gender gap: raw mean and median difference, ratio of means
- Gender gap **excluding football**: how much does football removal close the gap?
- Gender gap **within each sport**: basketball, soccer, volleyball, swimming, track, softball, baseball
- Gender gap by **quantile** (top 50, top 100, top 500, top 1,000): does the gap widen at the top?
- Gender gap by **conference tier** (Power 4, Group of 5, other D1)
- **Time trend**: has the gender gap changed from 2021–2025? (Using Wayback Machine snapshots of On3 rankings if available; otherwise, compare our scrape to published historical rankings.)
- **Selection rate analysis**: Of all D1 female athletes (EADA denominator), what percentage appear in On3's NIL rankings? Compare to males. This denominator analysis may be one of the paper's most cited findings.
- **Activities vs. compensation divergence**: Using Opendorse aggregate data, document the gap between women's share of NIL activities (high) and women's share of NIL compensation (low). Quantify the "content labor premium" — how many more activities per dollar do women perform?

**Why this is the primary contribution:** This work requires no causal assumptions, no ML caveats, no SHAP interpretation debates. It is clean, replicable, and policy-relevant. The Sloan Sports Analytics Conference values this kind of rigorous descriptive work. Any audience — academic, media, policy — can engage with these numbers.

### Track 2: Predictive ML (SECONDARY — Weeks 5–8)

**Goal:** What features best predict On3 NIL Valuation, and does gender shift those predictions?

**Features:**
- *Athlete-level:* sport, position, class year, Instagram followers, TikTok followers, Twitter/X followers, 247Sports recruit rating (if available)
- *Team-level:* win%, conference, national ranking, postseason appearance
- *School-level:* EADA total athletic revenue, EADA sport-specific revenue, conference tier, enrollment, media market DMA rank
- *Demographic:* gender
- *Engineered:* followers-per-sport-median, school-revenue-rank, conference-tier indicator, revenue-vs-non-revenue sport binary

**Models:**
- Baseline: OLS linear regression (for comparability with existing literature)
- Primary: XGBoost with 5-fold cross-validation
- Secondary: Random Forest
- Evaluation: R², MAE, RMSE on held-out test set (80/20 split, stratified by sport and gender)

**Explainability:**
- SHAP values for global and local feature importance
- Partial dependence plots for gender, followers, school revenue
- SHAP interaction values for gender × sport, gender × followers

**Critical caveats (stated in paper):**

*SHAP ≠ causation.* "High feature importance or SHAP values reflect predictive power rather than mechanistic influence" (arXiv:2506.10179, 2025). A high SHAP value for "gender" means gender helps the model predict On3 valuation — it says nothing about whether gender *causes* lower valuation.

*SHAP and correlated features.* "The Shapley method suffers from inclusion of unrealistic data instances when features are correlated. To simulate that a feature value is missing from a coalition, it is marginalized and missing values are obtained by sampling from the feature's marginal distribution. However, this makes sense only if features are uncorrelated" (arXiv:2305.02012v3). Social media followers, school brand, and sport are all correlated — SHAP may misattribute importance among them.

*Circularity.* Because On3's algorithm weights social media at 30-40%, our SHAP analysis will partly recover On3's engineering weights. We state: "Track 2 analyzes the structure of On3's estimated market valuations. Where SHAP values align with On3's known input categories, we cannot distinguish market signal from algorithm construction."

### Track 3: Causal Decomposition (CONDITIONAL — Weeks 7–10)

#### Go/No-Go Decision (End of Week 6)

**Track 3 proceeds only if ALL of the following hold:**
1. Matched-sample N ≥ 500 total across pooled gender-comparable sports
2. At least two sports contribute N ≥ 100 per gender
3. Propensity score distributions for men vs. women within the pooled sample show meaningful overlap (defined as: fewer than 30% of observations trimmed at α=0.05)

**If these conditions are not met**, Track 3 is replaced by: OLS regression of log(NIL Valuation) on gender + controls, within matched sports, with Cinelli & Hazlett (2020) sensitivity analysis via `sensemakr`. This provides less precise estimates but is valid at smaller sample sizes (Chernozhukov et al.'s DML is designed for large samples; the finite-sample literature recommends "G-computation for n<100, DML for n>500" — arXiv:2403.14385).

#### DML Method (if go)

**Why not traditional Oaxaca-Blinder?** Three reasons:
1. Traditional O-B assumes a linear model. NIL valuations are highly non-linear (long right tail, interaction effects). "It is demonstrated that linear methods such as the Oaxaca-Blinder decomposition may not be appropriate in the presence of substantial nonlinearities" (Schwiebert, "A detailed decomposition for nonlinear econometric models," *Journal of Economic Inequality*, 13, 53–67, 2014).
2. Traditional O-B "is particularly sensitive to the inclusion of irrelevant explanatory variables" (Flachaire et al., "Decomposing Inequalities using Machine Learning," arXiv:2511.13433, 2025).
3. The "unexplained" component in O-B is not identified as discrimination — it includes all omitted variables.

**Method: Double Machine Learning (Chernozhukov et al., 2018)**

We use the DML framework via the `DoubleML` Python package (Bach et al., "DoubleML — An Object-Oriented Implementation of Double Machine Learning," *Journal of Statistical Software*, 108, 2024; arXiv:2103.09603).

DML procedure for the partially linear model:
1. Split data into K=5 folds
2. For each fold: train ML models (XGBoost) to predict (a) NIL valuation from controls X, and (b) gender indicator from controls X
3. Compute residuals for both
4. Regress outcome residuals on treatment residuals to obtain the gender-effect estimate

"DML relies on two steps to obtain causal effect estimates. First, it estimates a model for both the outcome and the treatment. As a consequence, the final estimator is robust to minor mistakes in the estimation of either of these models... The estimator is consistent, as long as one of the two models is correctly specified" (Bach et al., 2024).

Following Ahrens et al. (2025), we pair DML with **short-stacking** across multiple candidate learners (XGBoost, Random Forest, LASSO) to increase robustness. "DDML with stacking is more robust to partially unknown functional forms than common alternative approaches based on single pre-selected learners" (Ahrens et al., "Model Averaging and Double Machine Learning," *Journal of Applied Econometrics*, 2025; arXiv:2401.01645).

**Two specifications per the DAG:**
- **Specification A (direct effect):** Controls = social media followers, team win%, conference tier, school EADA revenue, recruit ranking, class year, media market DMA rank. This estimates the gender effect *holding equal followers and observable performance constant*.
- **Specification B (total within-sport effect):** Controls = class year, recruit ranking, conference tier only. This estimates the total gender effect within sport, *allowing* the media-coverage → followers → valuation pathway to operate.

The difference (Spec B – Spec A) reveals how much of the within-sport gap operates through the social-media/media-coverage channel. This is an informal mediation decomposition. If Spec A shows a much smaller gender effect than Spec B, the gap is primarily driven by differential media exposure — a structural problem, not direct discrimination.

**Common support testing.** We compute propensity scores P(Gender=Male | X) within the matched sample and plot the distributions. As Flachaire et al. (2025) warn: "The complete absence of alter egos in the reference group for a subgroup simultaneously undermines both strategies." Even within basketball, men's and women's basketball are economically different markets — Duke men's basketball generates ~$45M in revenue vs. ~$5M for women's. If propensity score distributions show poor overlap, we report this as a finding and apply the Flachaire et al. (2025) Neumark reference-outcome estimator, which "does not require the imposition of the common support hypothesis."

#### OLS Fallback Method (if no-go)

If Track 3 conditions are not met, we run:

```
log(NIL_Valuation_i) = α + θ·Female_i + X_i'β + γ_sport + ε_i
```

within the matched-sport sample, with sport fixed effects. We then use the `sensemakr` package (Cinelli & Hazlett, 2020) to compute the **robustness value** — "the minimum strength that unobserved confounders need to have to overturn a research conclusion" (Cinelli, Ferwerda, & Hazlett, "sensemakr: Sensitivity Analysis Tools for OLS," 2020). The robustness value is expressed in partial R² terms, making it interpretable: "unobserved confounders that explain more than [RV]% of the residual variance of both the treatment and the outcome are strong enough to bring the point estimate to 0."

We also compute the **sign-change breakdown point** from Diegert, Masten, & Poirier (2024), who showed that Oster's (2019) standard "explain-away" delta can be misleading: "any time this measure is large — suggesting that omitted variables may be unimportant — a much smaller value reverses the sign of the parameter of interest" (Diegert, Masten, & Poirier, "The Effect of Omitted Variables on the Sign of Regression Coefficients," arXiv:2208.00552v4, 2024). We report the sign-change breakdown point alongside the explain-away point.

---

## Addressing Selection Bias

On3 only tracks athletes who already have some NIL presence. Women athletes with **zero** NIL activity are invisible in this dataset. This is classic **truncation on the dependent variable** — the sample is selected on the outcome.

Consequences:
- Any measured gender gap in On3 data is a **lower bound** on the true gap among all D1 athletes. The women who get nothing aren't in the sample.
- Regression on this truncated sample will produce biased coefficients (Heckman, 1979).

Our approach:
1. **Acknowledge explicitly** that we study the *conditional* distribution of NIL valuation given appearing in On3's database — not the unconditional population of all D1 athletes.
2. **Report the denominator.** EADA data tells us how many male vs. female athletes exist at each school. We compute: "of all D1 female athletes, what % appear in On3's NIL rankings?" vs. the same for males. This selection rate is itself a finding — possibly the most important one.
3. **No Heckman correction.** A Heckman selection model requires an exclusion restriction — a variable that predicts selection into On3 but does not affect valuation conditional on selection. We have no credible candidate for such a variable. Anything that makes an athlete visible to On3 (media market, school prestige, social media presence) also affects their valuation. Identification through distributional assumptions alone (normality of the error term) is widely regarded as unreliable. We are honest about this limitation rather than applying a technically available but substantively unjustified correction.

---

## Race × Gender: A Critical Confound We Cannot Fully Resolve

The gender gap in NIL is inextricable from racial composition. Black male athletes are overrepresented in football (the highest-NIL sport) and men's basketball. Any "gender gap" confounds gender with the racial demographics of revenue vs. non-revenue sports.

We cannot ethically code individual athletes' race from public profiles. Visual racial classification is unreliable and ethically problematic.

**What we do instead:**
- Use aggregate racial/ethnic composition data by sport from the NCAA's annual demographics reports (publicly available). For example: NCAA reports that 47.4% of D1 men's basketball players are Black vs. a lower percentage in most women's sports.
- Include sport-level racial composition as a contextual variable in the discussion. We can compute: "how much of the gender gap in NIL is mechanically attributable to the concentration of Black male athletes in the two highest-NIL sports?"
- Discuss the race × gender × sport intersection explicitly in the paper's limitations and policy implications. We cite the UB Law School analysis: "As of September 19, 2023 NIL valuation update, almost ten percent of the On3 Top 100 athletes are directly related to a former or current professional athlete. All nine such athletes are men" (Data and Demographics Driving NIL Deals, University at Buffalo School of Law, 2024).

**What we acknowledge we cannot do:** Individual-level decomposition of gender and race effects simultaneously would require individual race data and a much larger sample. This is a limitation we state clearly and flag as an avenue for future research, ideally with NIL Go data that includes demographic information.

---

## Missing Variables We Cannot Observe (Omitted Variable Bias)

| Omitted Variable | Why It Matters | Expected Direction of Bias on Gender Effect |
|---|---|---|
| **Actual deal values** | On3 estimates ≠ real compensation | Unknown — On3 may systematically over- or under-estimate women's value |
| **Agent/representation quality** | Athletes with professional NIL agents negotiate larger deals | Upward (men in revenue sports more likely to have agents) — meaning the true gender gap is smaller |
| **TV viewership/ratings** of specific sport | Drives brand ROI, which drives NIL | Upward (men's revenue sports have higher viewership) |
| **Athlete effort in NIL marketing** | Some athletes actively pursue deals; others don't | Unknown |
| **Race/ethnicity** (individual-level) | Gender × race interaction is confounded with sport structure | Complex — see section above |
| **Individual performance statistics** | Player-level stats (points, yards, etc.) beyond team win% | Toward zero if performance is similar within sport |
| **Attractiveness / appearance** | Documented factor in women's NIL (Wanzer, 2024) | Could reduce "unexplained" gap if measured |

**Bottom line:** Any unexplained gap we find is an *upper bound* on discrimination, because it includes all omitted variable effects that are correlated with both gender and NIL valuation. We say this explicitly in the paper.

---

## Temporal Validity

The NIL market is changing rapidly. Observations from one year may not generalize to the next.

| Date | Market State | Key Feature |
|---|---|---|
| July 2021 | NIL legalized | Unregulated; early adopters |
| 2022–2023 | Collective boom | 82% of compensation via collectives; women get <3.5% of collective money |
| June 2025 | House settlement approved | Revenue sharing begins; NIL Go launched; collectives likely to shrink |
| 2025–2026 | Post-settlement | Deloitte reported "70% of past collective deals would have been denied"; market restructuring underway |

The Sports Business Journal reported that NIL Go data suggests "the clearinghouse threatens to significantly curtail the millions of dollars that collectives are distributing to athletes" (May 2025). Since collectives disproportionately fund men's sports, the post-settlement market could *narrow* the gender gap by reducing collective payments to men — without increasing payments to women.

**Implication for our study:** Our data captures the **pre-settlement or early-settlement** NIL market. We must state this temporal scope clearly. Our findings describe the 2024–2025 market structure, which is already being disrupted. This is a feature, not a bug: documenting the pre-settlement baseline is itself valuable, as it provides the counterfactual for evaluating whether the House settlement improves gender equity.

---

## Pre-Registration and Falsifiable Predictions

Good research design specifies what results would contradict the thesis. We pre-register the following:

**Core hypotheses:**
1. **H1:** The aggregate gender gap in On3 NIL Valuation narrows by at least 50% when football is excluded.
2. **H2:** Within basketball (the cleanest gender-comparable sport), men's mean On3 NIL Valuation exceeds women's.
3. **H3:** Social media followers are the single most predictive feature in the XGBoost model (SHAP rank #1 or #2).
4. **H4 (if Track 3 proceeds):** The DML gender coefficient (Spec A, controlling for followers) is smaller in magnitude than the DML coefficient (Spec B, without followers), indicating that the media-coverage/followers pathway explains part of the within-sport gap.

**What would challenge our framing:**
- If excluding football does NOT substantially close the aggregate gap, the "football gap" thesis is wrong — the gap is pervasive across sports.
- If the within-sport DML gap (Spec B) is near zero, there is no meaningful gender effect even without controlling for mediators — the entire gap is between-sport.
- If SHAP shows gender has near-zero predictive importance even without sport in the model, then gender adds no information beyond what observable features already capture — a form of "explained gap."

We register hypotheses H1–H4 on OSF or SSRN before analysis begins.

---

## Data Sources

| Source | What It Provides | Access | Limitations |
|---|---|---|---|
| **On3 NIL Rankings** | Per-athlete *estimated* NIL valuation, sport, school, conference, social media follower counts | on3.com — scraping (see Risks) | Estimated values, not actual deals. Proprietary algorithm. Anti-scraping measures. |
| **NCAA EADA Data** | School-level athletic revenues, expenses, participation counts, coaching salaries — by sport and gender | ope.ed.gov/athletics — free CSV download, 2003–2024 | School-level, not athlete-level. |
| **Opendorse Annual Reports** | Aggregate NIL transaction statistics by sport, gender, conference. Based on actual disclosed deals. | Public PDFs ("NIL at 3," "NIL at 4") | Aggregate only — no individual-level microdata. |
| **Sports-Reference** | Team win/loss records, conference standings | sports-reference.com — scraping | Coverage varies by sport. |

---

## Timeline (12 Weeks)

| Week | Task | Owner | Deliverable | Gate |
|---|---|---|---|---|
| 1–3 | **Data acquisition.** Download EADA CSVs. Scrape On3 top 2,000 athletes (with rate limiting, caching). Extract embedded follower counts. Download Opendorse PDFs. | Students A + B | Clean CSVs: athlete-level, school-level | **Week 3 gate:** If On3 scraping fails → execute Fallback Design (see below) |
| 3–4 | **Data cleaning and merging.** Merge On3 with EADA. Construct matched sample. Count sample sizes by sport × gender. | Student B + Anna | Merged dataset; sample-size table | **Week 4 gate:** Report matched-sample N. If N<500 → Track 3 falls back to OLS+sensemakr |
| 4–6 | **Descriptive analysis (Track 1).** Gender gap ± football. Quantile analysis. Time trends. Selection rate analysis. Activities vs. compensation divergence. | Student B | Descriptive results + all figures | |
| 5–8 | **Predictive modeling (Track 2).** OLS baseline, XGBoost, RF. Cross-validation. SHAP. | Student C + Anna | Model table, SHAP plots | |
| 7–10 | **Causal decomposition (Track 3).** DML or OLS+sensemakr (per Week 4 gate). Specs A and B. Common support plots. Sensitivity analysis. | Anna (primary) + Student C | Coefficient estimates, robustness tables | |
| 9–10 | **Integration and interpretation.** Connect all three tracks. Reconcile contradictions. Policy implications. | Anna + all students | Results narrative | |
| 10–12 | **Paper writing.** Introduction, lit review, data, methods, results, discussion, conclusion. Target: 25–35 pages. | Anna (primary), students contribute sections | Complete manuscript | |

---

## Fallback Design (If On3 Scraping Fails)

If On3 blocks scraping and no data partnership materializes by Week 3, the project pivots to an **EADA-only institutional analysis**:

**Research question (fallback):** At the school level, what predicts the gender gap in athletic investment (revenues, expenses, coaching salaries) — and how does this institutional structure map onto known patterns of NIL inequality?

**Data:** EADA 2003–2024 (free, reliable, comprehensive). ~350 D1 schools × 21 years = ~7,350 school-year observations.

**Method:**
- Descriptive: gender gap in revenues, expenses, and coaching salaries by sport and conference, with time trends
- Predictive: XGBoost on school-level features predicting revenue gap, with SHAP
- Causal: DML estimation of the "effect" of institutional characteristics (conference affiliation, enrollment, media market) on gender investment gap

This fallback sacrifices the athlete-level analysis but retains the theoretical framework, the ML toolkit, and the policy relevance. It is publishable at JQAS or International Journal of Sport Finance.

---

## Team Task Allocation

- **Student A:** Web scraping (On3 athlete profiles), data cleaning, documentation of scraping pipeline
- **Student B:** EADA data download and processing, data merging, all descriptive/EDA analysis and visualization
- **Student C:** ML modeling (XGBoost, Random Forest), SHAP analysis, model evaluation
- **Anna:** Research design, theoretical framing, causal analysis (DML or OLS+sensemakr), paper writing, quality control, mentorship

---

## Publication Targets (Realistic)

| Target | Why | Realistic? |
|---|---|---|
| **SSRN / arXiv preprint** | Immediate visibility, establishes priority | ✅ Yes — submit Week 12 |
| **MIT Sloan Sports Analytics Conference** (research paper track) | Perfect venue for descriptive + ML sports analysis | ✅ Yes — submission typically ~October |
| **Journal of Quantitative Analysis in Sports** | Welcomes ML methods, shorter turnaround | ✅ Realistic with revisions |
| **International Journal of Sport Finance** | Good fit for the economics angle | ✅ Realistic |
| **Applied Economics Letters** | Short-format, fast turnaround | ✅ Yes — condense to 3,000 words |
| **Journal of Sports Economics** | Top field journal, wants causal identification | ⚠️ Stretch — requires Track 3 to clear the go/no-go gate and produce credible DML results |
| **ASSA Annual Meeting student sessions** | Competitive, usually grad students | ⚠️ Stretch — but compelling topic |

---

## Risks, Unknowns, and Honest Limitations

### Technical Risks

| Risk | Severity | Mitigation |
|---|---|---|
| **On3 blocks scraping** | HIGH | Respectful delays (2–5s). Cache aggressively. Wayback Machine snapshots. **Plan B:** Top ~500 public-facing athletes only. **Plan C:** Data partnership request to On3. **Plan D:** Fallback Design (EADA-only). |
| **Matched-sample N too small for DML** | HIGH | Go/no-go gate at Week 4. If N<500, fall back to OLS + sensemakr. If N<200, report descriptive within-sport gaps only (no regression). |
| **EADA → On3 merge is imprecise** | MEDIUM | EADA is school-level; On3 is athlete-level. Acknowledge ecological inference limitation. Use school as a control variable, not a feature of primary interest. |
| **On3 algorithm changes mid-project** | LOW | Cache all scraped data with timestamps. Note algorithm version in data documentation. |

### Methodological Risks

| Risk | Impact | Mitigation |
|---|---|---|
| **DV circularity (predicting On3 with On3's inputs)** | Inflated R², SHAP values reflect algorithm weights not market economics | Frame Track 2 explicitly as "analysis of On3's valuation structure." Cross-validate with Opendorse aggregates. |
| **DML finite-sample bias** | Literature shows DML can be biased for N<500. "DML improves with sample size. Recommend G-computation for n<100, DML for n>500" (arXiv:2403.14385) | Go/no-go gate. Use short-stacking (Ahrens et al. 2025). Report bootstrap confidence intervals alongside asymptotic ones. |
| **DML low-overlap bias** | If propensity scores are extreme, DML coverage collapses. "In low-overlap designs, coverage collapses to 39.8% at n=2000, with a large negative bias" (arXiv:2512.07083) | Plot propensity scores. Trim if needed. Report common-support diagnostics. Use Flachaire et al. (2025) Neumark estimator if overlap is poor. |
| **Mediator vs. confounder confusion** | Including mediators (followers) as controls blocks causal pathways; excluding them increases OVB | Run both Spec A (with mediators) and Spec B (without). Report both. Label clearly: "Spec A = direct effect; Spec B = total within-sport effect." |
| **Oster bounds sign-change problem** | Standard Oster (2019) delta can be misleading: "any time this measure is large... a much smaller value reverses the sign" (Diegert et al. 2024) | Use Cinelli & Hazlett (2020) robustness values via `sensemakr`. Also compute Diegert et al. (2024) sign-change breakdown point. |

### Ethical Risks

| Issue | Approach |
|---|---|
| **Coding race/ethnicity from public profiles** | We do NOT do this. We use aggregate sport-level demographic data from NCAA reports. |
| **Scraping Terms of Service** | Review On3's ToS before scraping. If prohibited, seek data partnership or use only publicly accessible, non-login-required pages. |
| **Potential to harm athletes** | We report only aggregate and anonymized results. No individual athlete is identified with a "predicted valuation" or "counterfactual gap." |

---

## Key References

### NIL Market and Gender Equity
- Opendorse. "NIL at 3: The Annual Opendorse Report." 2024. "Since July 1, 2021, the total projected NIL market has exploded from $917 million in 2021-22 to an expected $1.67 billion in 2024-25."
- AP News. "One year of NIL: How much have athletes made?" July 2022. "Remove football and women flip it to 52.8% vs. 47.2% for men."
- Sportico. "Women's College Sports Are Breaking Records. Do NIL Collectives Care?" 2023. "Even after subtracting football, [the NIL funding figure] was still nearly 60% [male]."
- Opendorse / The GIST. "NIL deal platform Opendorse shares key insights on today's women college athletes." 2025. "Women athletes submitted 32.2% of the 500K NIL deal applications."
- LeRoy, M. H. "NCAA Women Athletes and NIL Pay Disparities: Are They Students Under Title IX, Employees Under Title VII, or Both?" *U. Cincinnati Law Review*, 93(4), 979, 2025. "Men's basketball players in major NCAA conferences were paid an average of $171,272 in 2024, compared to $16,222 for women."
- Shuler, K. & Steinfeldt, J. A. "If You Build It: A Structural Analysis of the NIL Impact on Women's College Sports." *Journal of Sports and Games*, 7(2), 6–16, 2025. "Without intentional structural reforms in college sport, NIL could further exacerbate existing gender disparities instead of addressing and potentially correcting them."
- Sailofsky, D. "The privilege to do it all? Exploring the contradictions of name, image and likeness (NIL) rights for women athletes and women's sports." *International Review for the Sociology of Sport*, 2025. "NIL collective arrangements — the least labour-intensive type of NIL labour — also disproportionately benefit men's athletes."
- Rogers, M. "Does NIL Diminish Gender Equity in Sports?" Indiana University CARI Blog, 2023. "Out of the 1,748 student-athletes benefiting from these collectives, 73.21% of the NIL deals were made with males and 26.79% with females."
- Rodriguez, D. "The NIL Illusion: How Artificial Market Values Are Impacting College Athlete's Decisions." *CTRL.FORM Substack*, April 2025.
- "Data and Demographics Driving NIL Deals." University at Buffalo School of Law, 2024. "Almost ten percent of the On3 Top 100 athletes are directly related to a former or current professional athlete. All nine such athletes are men."

### NIL Economics
- Owens, Rennhoff & Roach. "The impact of NIL contracts on student-athlete college choice." *Applied Economics*, 57(22), 2822–2838, 2024.
- "Does Personalized Pricing Increase Competition? Evidence from NIL..." *Management Science*, 2024.

### House Settlement, NIL Go, and Data Access
- Ropes & Gray. "House v. NCAA Settlement Approved: Era of Direct Payments to College Athletes Begins." June 2025. "All NIL transactions with a total value of $600 or more must be reported by student-athletes and member institutions to the Commission."
- ForwardPathway. "House v. NCAA Settlement." 2025. "Athletes are now mandated to report any third-party NIL deals exceeding $600 to NIL Go."
- Yahoo Sports / Sports Business Journal. May 2025. CSC CEO Bryan Seeley stated the clearinghouse was "struggling" and that "70% of past deals from booster collectives would have been denied."
- Georgetown Law Tech Review. "NIL and Data Transparency: Implications for Student-Athletes." 2024. "Absent a federal mandate, colleges would likely resist transparency."
- FOIAball. 2025. Obtained partial NIL deal data from UCLA via FOIA; UCLA invoked FERPA to withhold business names.
- Bradley Law. "Enforcing After House." January 2026. CSC "empowered to monitor post-settlement activity."

### Causal Methodology
- Chernozhukov, V. et al. "Double/debiased machine learning for treatment and structural parameters." *The Econometrics Journal*, 21(1), C1–C68, 2018.
- Bach, P. et al. "DoubleML — An Object-Oriented Implementation of Double Machine Learning." *Journal of Statistical Software*, 108, 2024.
- Ahrens, A. et al. "Model Averaging and Double Machine Learning." *Journal of Applied Econometrics*, 2025; arXiv:2401.01645. "DDML with stacking is more robust to partially unknown functional forms than common alternative approaches."
- Flachaire, E. et al. "Decomposing Inequalities using Machine Learning and Overcoming Limitations of Kitagawa-Oaxaca-Blinder." arXiv:2511.13433, 2025.
- Schwiebert, J. "A detailed decomposition for nonlinear econometric models." *Journal of Economic Inequality*, 13, 53–67, 2014.
- Imai, K., Keele, L., & Tingley, D. "A General Approach to Causal Mediation Analysis." *Psychological Methods*, 15(4), 309–334, 2010.

### Sensitivity Analysis
- Cinelli, C. & Hazlett, C. "Making Sense of Sensitivity: Extending Omitted Variable Bias." *Journal of the Royal Statistical Society, Series B*, 82(1), 39–67, 2020.
- Cinelli, C., Ferwerda, J., & Hazlett, C. "sensemakr: Sensitivity Analysis Tools for OLS in R and Stata." 2020. "The robustness value describes the minimum strength that unobserved confounders need to have to overturn a research conclusion."
- Diegert, P., Masten, M. A., & Poirier, A. "The Effect of Omitted Variables on the Sign of Regression Coefficients." arXiv:2208.00552v4, 2024. "Any time [Oster's explain-away delta] is large — suggesting that omitted variables may be unimportant — a much smaller value reverses the sign of the parameter of interest."
- Oster, E. "Unobservable Selection and Coefficient Stability: Theory and Evidence." *Journal of Business & Economic Statistics*, 37(2), 187–204, 2019.

### SHAP and ML Explainability
- Heskes, T. et al. "Causal Shapley Values: Exploiting Causal Knowledge to Explain Individual Predictions of Complex Models." *NeurIPS*, 2020.
- "High feature importance or SHAP values reflect predictive power rather than mechanistic influence." (arXiv:2506.10179, 2025)
- "SHAP... disregards causal relationships among model inputs." (Causal SHAP, arXiv:2509.00846, 2025)
- "The Shapley method suffers from inclusion of unrealistic data instances when features are correlated." (arXiv:2305.02012v3)

### DML Finite-Sample Performance
- "DML improves with sample size. Recommend G-computation for n<100, DML for n>500." (arXiv:2403.14385, "Estimating Causal Effects with Double Machine Learning — A Method Evaluation")
- "In low-overlap designs, coverage collapses to 39.8% at n=2000, with a large negative bias of about −0.10." (arXiv:2512.07083, "Finite-Sample Failures and Condition-Number Diagnostics in Double Machine Learning")
- Ahrens et al. (2025): "DDML with conventional stacking exhibits relatively large bias with n=200."

---

## Why This Wins (Revised)

- **Timing.** House settlement approved June 2025. NIL Go launched. Revenue sharing beginning. This is the last window to document the pre-settlement baseline.
- **Personal story.** Former D1 female athlete in a non-revenue sport — authenticity that journal reviewers and conference audiences respond to.
- **The contribution is descriptive precision, not a novel observation.** Everyone knows football drives the gap. Nobody has quantified *exactly how much*, across quantiles, over time, with selection-rate denominators, and with the activities-vs-compensation divergence laid out. We provide the definitive descriptive accounting.
- **Methodologically honest.** We separate description from prediction from (conditional) causation. We draw a DAG. We pre-register hypotheses. We use go/no-go gates rather than forcing underpowered methods. We acknowledge the DV circularity, selection bias, omitted variables, and temporal limitations. This is what gets papers accepted — not fancy models, but intellectual honesty about what the models can and cannot say.
- **Teachable.** Students learn real ML (XGBoost, SHAP) and real data work (scraping, merging, EDA). Anna handles the causal econometrics. Everyone contributes to a genuine research output.
- **Extensible.** If NIL Go data becomes available, this paper becomes the baseline for a follow-up with actual deal values — the natural second paper.

---

## What Changed from v2 and Why

| v2 | v3 | Reason |
|---|---|---|
| "~53% of activities" presented as a "buried lede" implying novelty | Distinguished activities from compensation; acknowledged the observation is already known | AP News, CNBC, Sportico all reported the football-exclusion point by 2023. Activities ≠ compensation — Sportico showed men still get 60%+ of *funding* even without football. |
| Track 2 (ML) was primary; Track 3 (descriptive) was secondary | Track 1 (descriptive) is now primary; ML is secondary; DML is conditional | Descriptive work requires no causal assumptions, no caveats, and may be the most-cited output. |
| DML assumed sufficient sample size | Go/no-go gate at Week 4; OLS+sensemakr fallback | DML literature shows unreliable results for N<500 (arXiv:2403.14385). |
| No DAG | Explicit DAG with mediator/confounder distinction | Without a DAG, the DML coefficient is uninterpretable — you don't know if you're estimating a total or direct effect. |
| No power analysis or go/no-go criteria | Three explicit conditions for Track 3 to proceed | Prevents publishing underpowered causal claims. |
| Heckman selection model proposed "if feasible" | Heckman explicitly dropped — no credible exclusion restriction | Identifying through distributional assumptions alone is unreliable. Honesty > technique. |
| "Oster 2019 bounds or similar" for sensitivity | Cinelli & Hazlett (2020) `sensemakr` + Diegert et al. (2024) sign-change breakdown point | Oster's explain-away delta is misleading for sign robustness (proven by Diegert et al. 2024). |
| Race acknowledged as omitted variable, no action | Aggregate sport-level demographics from NCAA; explicit race × gender × sport discussion | The confound is too important to wave away. Aggregate data is ethically obtainable and substantively informative. |
| No temporal validity discussion | Explicit framing as "pre-settlement baseline" | The market is being restructured by House settlement. Our data captures a specific historical moment. |
| No fallback design if scraping fails | Complete EADA-only fallback design | Scraping is HIGH risk. The project must survive data-acquisition failure. |
| No pre-registration / falsifiable predictions | Four pre-registered hypotheses + conditions that would challenge the thesis | Good research specifies what would change your mind. |
| No distinction between total and direct causal effects | Two DML specs: with mediators (direct) and without (total within-sport) | The policy implications differ radically depending on which effect you estimate. |
| Single DML learner (XGBoost) | Short-stacking across XGBoost, RF, LASSO per Ahrens et al. (2025) | Stacking is more robust to unknown functional forms. |
| Common support assumed within matched sports | Explicit propensity-score overlap testing + Flachaire et al. (2025) Neumark estimator if overlap is poor | Even within basketball, M and W markets are economically distinct. Cannot assume common support. |
