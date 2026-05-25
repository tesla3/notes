# Proposal 1 (Revised): The Football Gap — ML Prediction and Causal Decomposition of Gender Disparities in College NIL Markets

## Summary

The NCAA NIL market has grown from $917M (2021–22) to a projected $2.75B (2025–26) (Opendorse, "NIL at 3," 2024). Collectives account for ~82% of all NIL compensation, and football alone captures 49.9% of all NIL dollars. Women receive <3.5% of collective NIL payments — but when football is excluded, women account for **~53% of all NIL activities** (Opendorse, 2024).

That last statistic is the buried lede. Is the "gender gap" in NIL actually a gender gap — or is it a football gap? This project disentangles the two.

We pursue two distinct, clearly scoped analyses:

1. **Predictive analysis:** What observable features best predict an athlete's estimated NIL market value? (ML prediction + SHAP explainability)
2. **Causal decomposition:** Within gender-comparable sports, how much of the male–female NIL gap is explained by observable characteristics (performance, social media, school brand) versus unexplained factors? (Double Machine Learning, Chernozhukov et al. 2018)

We are explicit about what these methods can and cannot tell us. Prediction is not causation. Unexplained gaps are not proof of discrimination. But rigorous decomposition, layered with descriptive ML, can sharpen the policy conversation about where structural inequity does and does not operate.

---

## Why Anna

She was a D1 Women's Rower at Cornell who retired due to injury and became team manager. She lived the invisible-athlete experience — rowing is a non-revenue sport where NIL dollars barely exist. She watched the NIL revolution unfold during her 4 years (2020–2024). This isn't academic to her; it's autobiographical. That authenticity matters for presentation and publication.

Critically, Anna's experience illustrates the **sport-structure confound** at the heart of this paper: her invisibility was not because she was a woman, but because she was in a non-revenue sport. Men's rowing gets almost no NIL either. Separating "gender effect" from "sport-revenue effect" is the core intellectual challenge of this project.

---

## Theoretical Framework

The original proposal had none. This is what killed its publication chances. We need a framework to interpret whatever gap we find.

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

**The key question is not "is there a gap?" — we know there is. The question is: what share of the gap is explained by sport structure (football having no female equivalent), what share by observable differences within comparable sports, and what share remains unexplained?**

---

## What We Measure vs. What We Claim

This section exists because the original proposal conflated several things. We state our epistemic commitments upfront.

| What We Do | What It Tells Us | What It Does NOT Tell Us |
|---|---|---|
| Predict On3 NIL Valuation with XGBoost | Which features are most predictive of *estimated* market value | What *causes* an athlete to be valued more or less |
| SHAP values on the prediction model | Feature importance for prediction | Causal effects of any feature |
| Double ML decomposition within matched sports | How much of the within-sport gender gap is explained by observables vs. unexplained | Whether the unexplained gap is "discrimination" — it could be omitted variables |
| Descriptive statistics with/without football | How much football skews the aggregate gender gap | Nothing causal — this is accounting |

### The Dependent Variable Problem

**On3's NIL Valuation is itself a proprietary ML algorithm.** On3 states: "The algorithm-driven On3 NIL Valuation comes from 27 years of data and science innovation in college sports publishing... developed with the assistance of multiple machine learning engineers" (On3, "About On3 NIL Valuation"). It combines social media followers, athletic performance, and exposure metrics into an estimated market value — **not actual deal compensation**.

Industry observers are blunt: "None of it is rooted in fact. It's just an algorithm they made up" (GopherHole forum). A D1 basketball data intern noted: "The hardest part is finding reliable data on player compensation since it's not publicly available" (r/sportsanalytics, Feb 2025). The Substack "NIL Illusion" warned that On3 creates "a system where NIL values are based more on perception than reality."

**We are therefore predicting one ML model's output with another ML model.** We acknowledge this explicitly and frame the contribution correctly:

- **Prediction track:** We analyze the *structure of estimated market valuations* — what On3's algorithm weights and whether gender systematically shifts those weights. This is a study of how the market *perceives* athlete value, not how it actually compensates them.
- **Causal track:** We use EADA institutional data (actual revenues/expenses) + aggregate Opendorse transaction statistics (based on "$250 million in real NIL transactions" from "150,000+ anonymized transactions from 125,000+ student-athletes," Opendorse "NIL at 3," 2024) as cross-validation.

### New Data Opportunity: NIL Go Mandatory Reporting

The House v. NCAA settlement, approved June 6, 2025, established **NIL Go** — a clearinghouse run by Deloitte. "Athletes are now mandated to report any third-party NIL deals exceeding $600 to NIL Go" (ForwardPathway, 2025). "All NIL transactions with a total value of $600 or more must be reported by student-athletes and member institutions" (Ropes & Gray, June 2025).

This mandatory reporting began June 7, 2025. If any of this data becomes publicly available or requestable (FOIA for public universities, or aggregate reports from the College Sports Commission), it would provide **actual deal values** — solving the dependent variable problem entirely. We flag this as a potential data upgrade and monitor throughout the project.

---

## Data Sources

| Source | What It Provides | Access | Limitations |
|---|---|---|---|
| **On3 NIL Rankings** | Per-athlete *estimated* NIL valuation, sport, school, conference, social media follower counts | on3.com — scraping (see Risks) | Estimated values, not actual deals. Proprietary algorithm. Anti-scraping measures. |
| **NCAA EADA Data** | School-level athletic revenues, expenses, participation counts, coaching salaries — by sport and gender | ope.ed.gov/athletics — free CSV download, 2003–2024 | School-level, not athlete-level. Cannot be directly merged with individual NIL valuations without ecological inference. |
| **Opendorse Annual Reports** | Aggregate NIL transaction statistics by sport, gender, conference. Based on actual disclosed deals. | Public PDFs ("NIL at 3," "NIL at 4") | Aggregate only — no individual-level microdata available publicly. Opendorse partnership may unlock more (unknown). |
| **Sports-Reference** | Team win/loss records, conference standings, individual player statistics for some sports | sports-reference.com — scraping | Coverage varies by sport. Women's non-revenue sports have sparse data. |
| **Social media (Instagram, TikTok)** | Follower counts and engagement | Public profiles | **Hard to scrape at scale.** Both platforms aggressively block automated access. Instagram requires login; TikTok API is restrictive. Plan B: use On3's embedded follower counts (which they scrape themselves). |
| **NIL Go / College Sports Commission** | Actual deal values for deals >$600 | Unknown — mandatory reporting began June 2025 | **Availability for researchers is entirely unknown.** May require FOIA for public universities. Flag as potential future data source. |

### Sample Construction

**Primary sample (prediction track):** On3 athletes with published NIL valuations. We target the top 1,000–2,000 athletes across all sports, not just the top 100. On3 tracks "10,000+ D1 athletes" — but depth of coverage thins rapidly outside revenue sports.

**Matched sample (causal track):** Athletes in **gender-comparable sports only** — basketball (M vs. W), soccer (M vs. W), swimming (M vs. W), track & field (M vs. W). Football and women's gymnastics/softball are excluded from the causal analysis because they have no cross-gender counterpart.

**Institutional sample:** All D1 schools reporting EADA data (~350 schools). Merged with On3 school-level aggregates.

---

## Methodology

### Track 1: Predictive ML (Weeks 1–7)

**Goal:** What features best predict On3 NIL Valuation?

**Features:**
- *Athlete-level:* sport, position, class year, Instagram followers, TikTok followers, Twitter/X followers, 247Sports recruit rating (if available)
- *Team-level:* win%, conference, national ranking, postseason appearance
- *School-level:* EADA total athletic revenue, EADA sport-specific revenue, conference tier, enrollment, media market DMA rank
- *Demographic:* gender, race/ethnicity (if reliably codable from public profiles — see Ethics)
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

**Critical caveat (stated in paper):** SHAP values measure predictive importance, not causal effects. As Heskes et al. (2020) established and multiple subsequent papers confirm: "high feature importance or SHAP values reflect predictive power rather than mechanistic influence" (Correlation vs. Causation in Alzheimer's Disease, arXiv:2506.10179, 2025). A high SHAP value for "gender" means gender helps the model *predict* the dependent variable — it says nothing about whether gender *causes* lower valuation.

Additionally, SHAP has known limitations with correlated features: "the Shapley method suffers from inclusion of unrealistic data instances when features are correlated. To simulate that a feature value is missing from a coalition, it is marginalized and missing values are obtained by sampling from the feature's marginal distribution. However, this makes sense only if features are uncorrelated" (A Perspective on Explainable AI Methods: SHAP and LIME, arXiv:2305.02012v3). Social media followers, school brand, and sport are all correlated — SHAP may misattribute importance among them.

### Track 2: Causal Decomposition (Weeks 7–9)

**Goal:** Within gender-comparable sports, how much of the male–female NIL gap is explained by observable characteristics vs. unexplained?

**Why not traditional Oaxaca-Blinder?** Three reasons:
1. Traditional O-B assumes a linear model. NIL valuations are highly non-linear (long right tail, interaction effects). "It is demonstrated that linear methods such as the Oaxaca-Blinder decomposition may not be appropriate in the presence of substantial nonlinearities" (Schwiebert, "A detailed decomposition for nonlinear econometric models," *Journal of Economic Inequality*, 13, 53–67, 2014).
2. Traditional O-B "is particularly sensitive to the inclusion of irrelevant explanatory variables" (Flachaire et al., "Decomposing Inequalities using Machine Learning," arXiv:2511.13433, 2025).
3. The "unexplained" component in O-B is not identified as discrimination — it includes all omitted variables.

**Method: Double Machine Learning (Chernozhukov et al., 2018)**

We use the DML framework via the `DoubleML` Python/R package (Bach et al., "DoubleML — An Object-Oriented Implementation of Double Machine Learning," *Journal of Statistical Software*, 108, 2024; arXiv:2103.09603).

DML procedure for the partially linear model:
1. Split data into K=5 folds
2. For each fold: train ML models (XGBoost) to predict (a) NIL valuation from controls X, and (b) gender indicator from controls X
3. Compute residuals for both outcome and treatment
4. Regress outcome residuals on treatment residuals to obtain the causal estimate of gender effect

"DML relies on two steps to obtain causal effect estimates. First, it estimates a model for both the outcome and the treatment. As a consequence, the final estimator is robust to minor mistakes in the estimation of either of these models... The estimator is consistent, as long as one of the two models is correctly specified" (Bach et al., 2024).

**Sample restriction for causal track:** Gender-comparable sports only (basketball, soccer, swimming, track & field). This addresses the **common support problem** that makes full-sample decomposition invalid. As Flachaire et al. (2025) warn: "The complete absence of alter egos in the reference group for a subgroup simultaneously undermines both strategies." Football athletes have no female counterparts; any full-sample decomposition is fundamentally misleading.

**Controls (X):** social media followers (lagged — see below), team win%, conference tier, school EADA revenue, recruit ranking, class year, media market DMA rank.

**Endogeneity mitigation for social media followers:** Followers are both cause and effect of NIL deals (simultaneity). An athlete who gets a big NIL deal gets more visibility → more followers → higher On3 valuation. We address this by:
- Using **beginning-of-season follower counts** (pre-NIL deal activity) where possible
- Running specifications **with and without** social media features and comparing results — if the gender coefficient changes substantially, it signals that follower counts absorb gender-correlated variation (media exposure differential)
- Discussing this limitation honestly in the paper

### Track 3: Descriptive Accounting (Throughout)

The simplest and possibly most impactful contribution:
- Full-sample gender gap in On3 NIL Valuation: raw mean difference
- Gender gap **excluding football**: how much does football removal close the gap?
- Gender gap **within basketball only**: the cleanest comparison
- Gender gap by quantile (top 100, top 500, top 1000): does the gap widen at the top?
- Time trend: has the gender gap changed since 2021?

This descriptive work requires no causal assumptions and may carry the most policy punch.

---

## Addressing Selection Bias

The original proposal ignored this entirely.

On3 only tracks athletes who already have some NIL presence. Women athletes with **zero** NIL activity are invisible in this dataset. This is classic **truncation on the dependent variable** — the sample is selected on the outcome.

Consequences:
- Any measured gender gap is a **lower bound** on the true gap. The women who get nothing aren't in the sample.
- Regression on this truncated sample will produce biased coefficients (Heckman, 1979).

Our approach:
1. **Acknowledge explicitly** that we study the *conditional* distribution of NIL valuation given appearing in On3's database — not the unconditional population of all D1 athletes.
2. **Report the denominator.** EADA data tells us how many male vs. female athletes exist at each school. We compute: "of all D1 female athletes, what % appear in On3's NIL rankings?" vs. the same for males. This selection rate is itself a finding.
3. **If feasible:** Estimate a Heckman selection model (probit for appearing in On3 as first stage, valuation as second stage). This corrects for selection on observables but not unobservables.

---

## Missing Variables We Cannot Observe (Omitted Variable Bias)

We list these honestly, because any "unexplained gender gap" could be partially or fully explained by them:

| Omitted Variable | Why It Matters | Direction of Bias |
|---|---|---|
| **Actual deal values** | On3 estimates ≠ real compensation | Unknown — On3 may systematically over- or under-estimate women's value |
| **Agent/representation quality** | Athletes with professional NIL agents negotiate larger deals | Likely biases gap upward (men in revenue sports more likely to have agents) |
| **TV viewership/ratings** of specific sport | Drives brand ROI, which drives NIL | Biases gap upward (men's revenue sports have higher viewership) |
| **Athlete effort in NIL marketing** | Some athletes actively pursue deals; others don't | Direction unknown |
| **Race/ethnicity** | Black athletes are overrepresented in football/basketball (high NIL). Gender × race interaction is unexamined. | Could go either direction |
| **Individual performance statistics** | Player-level stats (points, yards, etc.) beyond team win% | Biases toward zero if performance is similar within sport |
| **Attractiveness / appearance** | Documented factor in women's NIL (Wanzer, 2024) | Could reduce "unexplained" gap if measured |

**Bottom line:** Any unexplained gap we find is an *upper bound* on discrimination, because it includes omitted variable bias. We say this in the paper.

---

## Timeline (12 Weeks, Not 10)

The original 10-week timeline was unrealistic, especially with high school students. We add 2 weeks and cut scope.

| Week | Task | Owner | Deliverable |
|---|---|---|---|
| 1–2 | **Data acquisition.** Download EADA CSVs. Scrape On3 top 2,000 athletes (with rate limiting, caching). Extract embedded follower counts from On3 profiles (avoid separate social media scraping). Download Opendorse public PDFs. | Students A + B | Clean CSVs: athlete-level, school-level |
| 3 | **Data cleaning and merging.** Merge athlete-level On3 data with school-level EADA data. Construct matched sample for causal track (gender-comparable sports). | Student B + Anna | Merged analysis dataset |
| 4–5 | **EDA and descriptive analysis (Track 3).** Gender gap calculations with/without football. Distributions, quantile analysis, time trends. Visualization. | Student B | Descriptive results + figures |
| 5–7 | **Predictive modeling (Track 1).** OLS baseline, XGBoost, Random Forest. Cross-validation. SHAP analysis. | Student C + Anna | Model comparison table, SHAP plots |
| 7–9 | **Causal decomposition (Track 2).** DML on matched sample. Sensitivity checks (with/without social media features). Selection rate analysis. | Anna (primary) + Student C | DML coefficient estimates, robustness tables |
| 9–10 | **Integration and interpretation.** Connect descriptive, predictive, and causal results. Reconcile any contradictions. Develop policy implications. | Anna + all students | Results narrative |
| 10–12 | **Paper writing.** Introduction, literature review, data, methods, results, discussion (including all caveats), conclusion. Target: 25–35 pages. | Anna (primary), students contribute sections | Complete manuscript |

**Key change from original:** Anna leads the causal track (DML) because this requires econometric training that high school students don't have. Students focus on data collection, EDA, and the prediction track — all of which are learnable in 12 weeks.

---

## Team Task Allocation

- **Student A:** Web scraping (On3 athlete profiles), data cleaning, documentation of scraping pipeline
- **Student B:** EADA data download and processing, data merging, all descriptive/EDA analysis and visualization
- **Student C:** ML modeling (XGBoost, Random Forest), SHAP analysis, model evaluation
- **Anna:** Research design, theoretical framing, causal analysis (DML), paper writing, quality control, mentorship

---

## Publication Targets (Realistic)

The original proposal targeted *Journal of Sports Economics* and *ASSA Annual Meeting*. These are unrealistic for a summer project with high school co-authors.

| Target | Why | Realistic? |
|---|---|---|
| **SSRN / arXiv preprint** | Immediate visibility, establishes priority | ✅ Yes — submit Week 12 |
| **MIT Sloan Sports Analytics Conference** (research paper track) | Perfect venue for ML + sports | ✅ Yes — submission typically ~October |
| **Journal of Quantitative Analysis in Sports** | Welcomes ML methods, shorter turnaround | ✅ Realistic with revisions |
| **International Journal of Sport Finance** | Good fit for the economics angle | ✅ Realistic |
| **Journal of Sports Economics** | Top field journal, wants causal identification | ⚠️ Stretch — DML track may satisfy, but requires strong robustness |
| **Applied Economics Letters** | Short-format, fast turnaround | ✅ Yes — condense to 3,000 words |
| **ASSA Annual Meeting student sessions** | Competitive, usually grad students | ⚠️ Stretch — but compelling topic |
| **NCSA / NCAA research grants** | May fund extension of this work | ✅ Worth exploring |

---

## Risks, Unknowns, and Honest Limitations

### Technical Risks

| Risk | Severity | Mitigation |
|---|---|---|
| **On3 blocks scraping** | HIGH. On3 has premium tiers and likely anti-bot measures. Terms of service may prohibit scraping. | Use respectful delays (2–5s between requests). Cache aggressively. Explore Wayback Machine snapshots. **Plan B:** Use only the publicly visible top ~500 athletes (no login required) and supplement with EADA aggregate data. **Plan C:** Reach out to On3 for a research data partnership. |
| **Social media scraping fails** | HIGH. Instagram requires login; TikTok API is highly restrictive. | **Do not attempt separate social media scraping.** Use follower counts already embedded in On3 athlete profiles. This is sufficient for our purposes and avoids a major technical risk. |
| **Sample too small for DML in matched sports** | MEDIUM. Within basketball M vs. W, the overlap may be thin. Swimming, soccer, track may have very few athletes with On3 profiles. | Report sample sizes transparently. If N < 100 per group in any sport, report results but flag as underpowered. Consider pooling all matched sports with sport fixed effects. |
| **EADA → On3 merge is imprecise** | MEDIUM. EADA is school-level; On3 is athlete-level. Merging assigns school-level financial data to all athletes at that school. | Acknowledge ecological inference limitation. Use school as a *control variable*, not a feature of primary interest. |

### Methodological Unknowns

| Unknown | Impact | What We'll Do |
|---|---|---|
| **What is On3's actual algorithm?** | We're predicting a black-box ML model's output with another ML model. If On3's algorithm directly encodes gender (e.g., sport-based weights that correlate with gender), our SHAP analysis will just rediscover On3's weights. | Acknowledge explicitly. Frame Track 1 as "analyzing the structure of *estimated* market valuations" — not actual compensation. |
| **Does the "unexplained" gap represent discrimination or omitted variables?** | Central interpretive challenge. Any unmeasured variable correlated with gender and NIL value (agent quality, TV viewership, effort, attractiveness) would be absorbed into the "unexplained" component. | State clearly: "the unexplained gap is an upper bound on discrimination." Run sensitivity analysis: how large would an omitted variable need to be to fully explain the gap? (Oster 2019 bounds or similar.) |
| **Will NIL Go data become available?** | Would transform this paper from "analyzing estimated valuations" to "analyzing actual deal values." | Monitor College Sports Commission announcements. FOIA public university reports. If data becomes available mid-project, pivot. |
| **Does the matched-sport design eliminate or just reduce the football confound?** | Even within basketball, men's basketball generates far more revenue than women's basketball. The sports are "comparable" in name but not in market structure. | Control for sport-specific EADA revenue. Discuss residual confounding honestly. |

### Ethical Considerations

| Issue | Approach |
|---|---|
| **Coding race/ethnicity from public profiles** | Fraught. Visual racial classification is unreliable and ethically problematic. We either (a) omit race and acknowledge it as an omitted variable, or (b) use aggregate demographic data by sport from NCAA reports (not individual-level). We prefer (b). |
| **Scraping Terms of Service** | Review On3's ToS before scraping. If prohibited, seek data partnership or use only publicly accessible, non-login-required pages. |
| **Potential to harm athletes** | We report only aggregate and anonymized results. No individual athlete is identified with a "predicted valuation" or "counterfactual gap." |

---

## Key References

### NIL Market and Gender Equity
- Opendorse. "NIL at 3: The Annual Opendorse Report." 2024. "Since July 1, 2021, the total projected NIL market has exploded from $917 million in 2021-22 to an expected $1.67 billion in 2024-25."
- LeRoy, M. H. "NCAA Women Athletes and NIL Pay Disparities: Are They Students Under Title IX, Employees Under Title VII, or Both?" *University of Cincinnati Law Review*, 93(4), 979, 2025. "Men's basketball players in major NCAA conferences were paid an average of $171,272 in 2024, compared to $16,222 for women."
- Shuler, K. & Steinfeldt, J. A. "If You Build It: A Structural Analysis of the NIL Impact on Women's College Sports." *Journal of Sports and Games*, 7(2), 6–16, 2025. "Without intentional structural reforms in college sport, NIL could further exacerbate existing gender disparities instead of addressing and potentially correcting them."
- Sailofsky, D. "The privilege to do it all? Exploring the contradictions of name, image and likeness (NIL) rights for women athletes and women's sports." *International Review for the Sociology of Sport*, 2025. "NIL collective arrangements — the least labour-intensive type of NIL labour — also disproportionately benefit men's athletes."
- Rogers, M. "Does NIL Diminish Gender Equity in Sports?" Indiana University CARI Blog, 2023. "Out of the 1,748 student-athletes benefiting from these collectives, 73.21% of the NIL deals were made with males and 26.79% with females."

### NIL Economics
- Owens, Rennhoff & Roach. "The impact of NIL contracts on student-athlete college choice." *Applied Economics*, 57(22), 2822–2838, 2024.
- "Does Personalized Pricing Increase Competition? Evidence from NIL..." *Management Science*, 2024. (Uses 247Sports data with causal inference methods.)
- Cherullo (2023). Effects of NIL deals on athletic departments' sponsorship revenue.

### House Settlement and NIL Go
- Ropes & Gray. "House v. NCAA Settlement Approved: Era of Direct Payments to College Athletes Begins." June 2025. "All NIL transactions with a total value of $600 or more must be reported by student-athletes and member institutions to the Commission."
- ForwardPathway. "House v. NCAA Settlement." 2025. "Athletes are now mandated to report any third-party NIL deals exceeding $600 to NIL Go."

### Methodology
- Chernozhukov, V. et al. "Double/debiased machine learning for treatment and structural parameters." *The Econometrics Journal*, 21(1), C1–C68, 2018.
- Bach, P. et al. "DoubleML — An Object-Oriented Implementation of Double Machine Learning." *Journal of Statistical Software*, 108, 2024. "The double machine learning framework consists of three key ingredients: Neyman orthogonality, high-quality machine learning estimation and sample splitting."
- Flachaire, E. et al. "Decomposing Inequalities using Machine Learning and Overcoming Limitations of Kitagawa-Oaxaca-Blinder." arXiv:2511.13433, 2025. "The decomposition based on the Neumark reference outcome is particularly sensitive to the inclusion of irrelevant explanatory variables."
- Schwiebert, J. "A detailed decomposition for nonlinear econometric models." *Journal of Economic Inequality*, 13, 53–67, 2014. "It is demonstrated that linear methods such as the Oaxaca-Blinder decomposition may not be appropriate in the presence of substantial nonlinearities."
- Heskes, T. et al. "Causal Shapley Values: Exploiting Causal Knowledge to Explain Individual Predictions of Complex Models." *NeurIPS*, 2020.

### SHAP Limitations (for honest framing)
- "High feature importance or SHAP values reflect predictive power rather than mechanistic influence." (arXiv:2506.10179, 2025)
- "SHAP... disregards causal relationships among model inputs. This limitation arises from its assumption of feature independence, which can lead to misattributed feature importance." (Causal SHAP, arXiv:2509.00846, 2025)
- "The Shapley method suffers from inclusion of unrealistic data instances when features are correlated." (arXiv:2305.02012v3)

---

## Why This Wins (Revised)

- **Hot topic + perfect timing.** House settlement approved June 2025. NIL Go mandatory reporting just began. Revenue sharing launching. Gender equity debate is front-page.
- **Personal story.** Former D1 female athlete in a non-revenue sport — authenticity that journal reviewers and conference audiences respond to.
- **The "football gap" reframing is novel.** Most NIL gender papers report the raw gap. We show that the gap largely collapses when football is excluded — and then decompose the *residual* within-sport gap using modern causal ML. This is a genuinely new contribution.
- **Methodologically honest.** We don't overclaim. We separate prediction from causation, acknowledge the DV limitation, list omitted variables, and bound our "unexplained gap" interpretation. This is what gets papers accepted at serious journals — not fancy models, but intellectual honesty about what the models can and cannot say.
- **Teachable.** Students learn real ML (XGBoost, SHAP) and real data work (scraping, merging, EDA). Anna handles the causal econometrics. Everyone contributes to a genuine research output.
- **Extensible.** If NIL Go data becomes available, this paper becomes the baseline for a follow-up with actual deal values — potentially a much stronger second paper.

---

## What Changed from v1 and Why

| Original | Revised | Reason |
|---|---|---|
| No theoretical framework | Demand-side, supply-side, sociocultural theory sections | Econ journals desk-reject without theory |
| On3 valuations treated as ground truth | Explicitly acknowledged as ML estimates; DV problem discussed in detail | On3 is a proprietary algorithm, not actual compensation |
| Oaxaca-Blinder + XGBoost + SHAP franken-stitched | Two separate tracks: predictive ML and causal DML | Prediction ≠ causation; O-B is incompatible with non-linear ML |
| Full-sample gender decomposition | Within-sport matched sample for causal track | Football has no female counterpart — common support violated |
| Social media scraping (Instagram, TikTok) | Use On3's embedded follower counts; no separate scraping | Instagram/TikTok aggressively block scraping; high failure risk |
| SHAP = "what drives valuation" | SHAP = predictive importance only, with explicit caveats | SHAP ≠ causation (well-established in literature) |
| "Unexplained gap = structural inequity" | "Unexplained gap = upper bound on discrimination" | Omitted variable bias makes this interpretation invalid without bounds |
| 10-week timeline | 12-week timeline | Original was unrealistic for high school students |
| JSE, ASSA as primary targets | Sloan Sports Analytics, JQAS as primary; JSE as stretch | More realistic for methodology and author profiles |
| No selection bias discussion | Explicit treatment: truncation on DV, Heckman correction considered | On3 only tracks athletes with NIL presence |
| No race/ethnicity | Acknowledged as critical omitted variable; aggregate sport-level demographics used | Individual racial coding is ethically fraught; aggregate data from NCAA available |
| No mention of NIL Go | Flagged as potential data upgrade (mandatory reporting began June 2025) | Could solve the DV problem entirely if data becomes accessible |
