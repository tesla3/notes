# Proposal 1 (v4): Roster Value vs. Brand Value — Descriptive Accounting and Algorithmic Audit of Gender Disparities in College NIL Markets

## Summary

The NCAA NIL market has grown from $917M (2021–22) to a projected $1.67B (2024–25), with potential to exceed $2.5B in the first revenue-sharing year (Opendorse, "NIL at 3," 2024). Football alone captures 49.9% of all NIL compensation. NIL collectives — which account for 81.6% of all NIL compensation — send less than 3.5% of their dollars to women (Opendorse, "NIL at 3," 2024; NIL Certifications, 2024).

But two facts complicate the headline narrative:

**First, the aggregate gap is mechanically driven by football.** AP News (July 2022) reported: "Remove football and women flip it to 52.8% vs. 47.2% for men" in total compensation. This is already known. What is less well understood is that the gap *reopened* by 2023: Sportico reported that "even after subtracting football, [the funding figure] was still nearly 60%" male (Sportico, "Women's College Sports Are Breaking Records. Do NIL Collectives Care?", 2023). The gap's trajectory over time — not just its existence — is an open empirical question.

**Second, the collective market and the commercial market tell opposite stories.** In the commercial segment (brand deals, sponsorships — roughly 18% of the market), "Women's Basketball is in the number two spot for total compensation, second only behind Football" — ahead of men's basketball (Opendorse, "NIL at 3," 2024). Meanwhile, in the collective segment (booster-funded, ~82% of the market), women receive less than 3.5% of dollars. The gender gap is not one gap — it is two markets with opposite gender dynamics, aggregated into a misleading single number.

**In December 2024, On3 restructured its NIL Valuation to reflect exactly this distinction.** On3 CEO Shannon Terry announced the shift from the old "Performance, Influence, and Exposure" algorithm to a "Total Player Value" (TPV) model that splits valuations into two categories: **Roster Value** (collective-driven compensation, similar to a salary) and **NIL Value** (traditional marketing and brand endorsements) (Terry, "On3 NIL Valuation Inputs Change: Introducing Total Player Value," On3, December 10, 2024; Wikipedia, "On3.com," 2025). On3 states: "Roster Value is the primary factor influencing most athletes' NIL Valuation. It is determined mainly by collected deal data within the college marketplace and represents the compensation athletes receive from schools and collectives for competing" (On3, "About On3 NIL Valuation and Roster Value"). NIL Value, by contrast, "measures an athlete's market value in terms of licensing and sponsorship... influenced by on-field performance, media exposure, and social media presence" (ibid.).

**This split is our analytical opportunity.** Instead of studying one blended number, we decompose the gender gap into its two structural components — the collective-driven Roster Value gap and the brand-driven NIL Value gap — and ask different questions about each:

- **Roster Value gap:** Largely a function of booster/collective allocation decisions, sport structure, and institutional governance. The gender gap here is expected to be enormous and is primarily a **governance and policy question** — not a market question.
- **NIL Value gap:** A function of social media following, media exposure, athletic performance, and brand demand. The gender gap here — if it exists after controlling for observables — would indicate either algorithmic bias, differential brand demand, or unexplained market frictions.

We pursue two tracks, with a conditional extension:

1. **Primary: Descriptive Accounting (Track 1).** The gender gap in total On3 NIL Valuation, Roster Value, and NIL Value — with and without football, within individual sports, by quantile, by conference tier, and over time. The activities-vs.-compensation divergence. The selection-rate denominator analysis. No causal assumptions required.

2. **Secondary: Algorithmic Audit via Predictive ML (Track 2).** What features does On3's algorithm weight in constructing Roster Value and NIL Value, and does gender shift those weights? XGBoost + SHAP explainability — explicitly framed as an audit of On3's algorithmic structure, not of actual market compensation.

3. **Conditional Extension: Within-Sport Gap Estimation (Track 3).** Within gender-comparable sports (basketball, soccer, volleyball, swimming, track & field), how much of the NIL Value gap is explained by observables? OLS with sport fixed effects, Cinelli & Hazlett (2020) sensitivity analysis, and — only if N>500 in the matched sample — Double Machine Learning (Chernozhukov et al. 2018). This track's primary purpose is to estimate bounds on the unexplained within-sport gap, not to claim causal identification of discrimination.

**What this project is and is not.** We study On3's algorithmic valuations — not actual compensation. We describe distributions and audit an algorithm — we do not identify discrimination. We document the pre-/early-settlement NIL market during a period of structural transition. We are explicit about these boundaries throughout.

---

## Why Anna

She was a D1 Women's Rower at Cornell who retired due to injury and became team manager. She lived the invisible-athlete experience — rowing is a non-revenue sport where NIL dollars barely exist. She watched the NIL revolution unfold during her four years (2020–2024). This isn't academic to her; it's autobiographical. That authenticity matters for presentation and publication.

Critically, Anna's experience illustrates the **sport-structure confound** at the heart of this paper: her invisibility was not because she was a woman, but because she was in a non-revenue sport. Men's rowing gets almost no NIL either. Separating "gender effect" from "sport-revenue effect" is the core intellectual challenge of this project.

---

## What Is Already Known (Prior Work)

This project does not start from scratch. Several studies and data reports have established baseline findings about gender in the NIL market. We engage each directly and state what we add.

**Aggregate gap and football's role:**
- AP News (July 2022) established the basic accounting: "Remove football and women flip it to 52.8% vs. 47.2% for men." This was based on Opendorse's Year 1 platform data.
- Sportico (2023) showed the gap reopened by Year 2: "Data from Opendorse, a national NIL marketing platform, found that over 77% of all NIL funding went to male athletes. Even after subtracting football, that figure was still nearly 60%."
- Opendorse's "NIL at 3" report (2024) documented that collectives account for 81.6% of total NIL compensation and send "<3.5% of all Collective compensation" to women.
- Rogers (2023, Indiana University) found that "out of the 1,748 student-athletes benefiting from [38 NIL] collectives, 73.21% of the NIL deals were made with males and 26.79% with females" and that "both male and female NIL frequency in collectives had a strong, positive correlation with media impact (0.6824, 0.6095)."

**Gender and race in athlete expectations:**
- MacKeigan (2023, SSRN, University of Michigan) surveyed 330 athletes across 46 conferences and 23 sports and found that "women's sport competitors expect, and will opt out of a deal, at half the compensation rate that men's sport competitors will." She also found "a similar trend between white and BIPOC athletes: white athletes will expect 60% lower and opt-out at 54% lower compensation rates." Crucially, MacKeigan found that "the total following that an athlete in women's sports has been significantly influential in their compensation estimations, while it is not influential for athletes in men's sports" (MacKeigan, "An Equity Analysis on the Collegiate Name, Image, and Likeness Market," SSRN 4554235, 2023). Her sample was survey-based expectations, not observed valuations.

**On3 Top 100 demographics:**
- The University at Buffalo School of Law (2024) documented that of the On3 Top 100 athletes, "twenty-five (25) of them are collegiate basketball players, four (4) of which are women and twenty-one (21) men" and that "almost ten percent of the On3 Top 100 athletes are directly related to a former or current professional athlete. All nine such athletes are men" ("Data and Demographics Driving NIL Deals," 2024).

**Content and marketability:**
- Henneman (2025, Elon University) content-analyzed 622 Instagram and TikTok posts from 15 On3 Top 100 football players, classifying content by Wanzer's (2024) MABI framework (Athletic Performance, Attractive Appearance, Marketable Lifestyle).
- Sailofsky (2025) found that "NIL collective arrangements — the least labour-intensive type of NIL labour — also disproportionately benefit men's athletes" and that women's NIL success is often conditional on performing femininity ("The privilege to do it all?", *International Review for the Sociology of Sport*, 2025).

**Legal and structural analysis:**
- LeRoy (2025) showed that "men's basketball players in major NCAA conferences were paid an average of $171,272 in 2024, compared to $16,222 for women" and demonstrated that schools coordinate with collectives to "monetize NIL donor access in favor of men" ("NCAA Women Athletes and NIL Pay Disparities," *U. Cincinnati Law Review*, 93(4), 979, 2025).
- Shuler & Steinfeldt (2025) argued that "without intentional structural reforms in college sport, NIL could further exacerbate existing gender disparities instead of addressing and potentially correcting them" ("If You Build It," *Journal of Sports and Games*, 7(2), 6–16, 2025).

**What remains unknown and what this project adds:**

| Known | Unknown (Our Contribution) |
|---|---|
| Football drives the aggregate gap | Precisely how much, tracked over 4 years (2021–2025), with quantile breakdowns |
| Women get <3.5% of collective money | Whether the gap in On3's **NIL Value** (brand component) is also large, or whether it narrows or reverses for women in high-visibility sports |
| Women do ~53% of NIL activities but get <40% of compensation | The **content labor ratio** — how many activities per dollar, by sport and gender — quantified from Opendorse data |
| On3 valuations exist and are widely cited | How On3's **post-December-2024 TPV algorithm** weights features differently for Roster Value vs. NIL Value, and whether gender shifts those weights (algorithmic audit) |
| MacKeigan found women expect half the compensation | Whether On3's **observed algorithmic valuations** (not expectations) show the same pattern, and whether the gap varies by sport, conference tier, and quantile |
| UB Law documented On3 Top 100 demographics | What the **denominator** looks like: of all D1 female athletes (EADA), what % appear in On3's database at all? This selection rate may be the most important number in the paper |

---

## Theoretical Framework

### Why would we expect a gender gap in NIL?

**Demand-side explanations (market-efficiency):**
- **Viewership differentials.** Men's football and basketball generate vastly more TV revenue and live attendance than women's sports. If NIL valuations reflect brand ROI, athletes in higher-viewership sports command higher valuations. This is a market-efficiency argument: the gap reflects underlying consumer demand, not discrimination.
- **Advertiser preference.** Brands target athletes in sports that reach their target demographics. Football reaches a different advertiser base than volleyball.
- **Consumer willingness-to-pay.** If consumers demonstrably spend more on men's sports products and content, differential NIL pricing may reflect efficient factor-market pricing — not inequity.

**Supply-side explanations (structural):**
- **Agent and representation asymmetry.** Male athletes in revenue sports are more likely to have professional NIL agents. MacKeigan (2023) found that women expect half the compensation, suggesting internalized market signals or information asymmetry.
- **Collective governance.** Collectives are funded by boosters of football and men's basketball. Their allocation decisions are governance choices, not market outcomes. LeRoy (2025) showed schools actively coordinate with collectives to channel money to men.
- **Media exposure feedback loop.** Less media coverage → fewer followers → lower NIL valuation → less media interest. Rogers (2023) found strong positive correlation between media impact and NIL collective frequency (r = 0.68 male, 0.61 female).

**Sociocultural explanations:**
- **Femininity and marketability.** Sailofsky (2025) found women's NIL success is often conditional on performing femininity. Wanzer (2024) found that high-earning women athletes were more likely to post "attractive appearance" content. This suggests a qualitatively different path to NIL value for women.

### The efficiency question: When is a gap not inequitable?

A rigorous study must engage with the null hypothesis that the NIL gender gap is efficient.

**The argument for efficiency:** If men's football generates $45M+ in annual revenue at a top program and women's rowing generates near-zero, differential NIL pricing for athletes in those sports may reflect underlying economic fundamentals — not discrimination. An investor paying $500K for a football quarterback's endorsement may receive more measurable ROI than paying the same for a rower. Under standard labor economics, workers whose marginal revenue product differs will be compensated differently. A gender "gap" driven entirely by sport-revenue differences is not a gender gap — it is a sport-revenue gap that correlates with gender because football has no female equivalent.

**The argument against pure efficiency:** Four responses challenge the efficiency claim:

1. **Collective payments are not market transactions.** Collectives are donor-funded organizations that allocate money based on booster preferences, not competitive bidding or ROI optimization. When LeRoy (2025) shows schools "monetize NIL donor access in favor of men," this is a governance decision, not a market price.

2. **The commercial market partially contradicts the efficiency story.** In the commercial segment, women's basketball outperforms men's basketball for total compensation (Opendorse, "NIL at 3," 2024). If brands — who do optimize for ROI — value women's basketball more than men's basketball, the aggregate gap is not purely demand-driven.

3. **Media exposure is endogenous.** Women's sports receive less media coverage not because of lower demand but because of decades of institutional under-investment in broadcasting (Rogers, 2023). The media-coverage → followers → NIL pathway transmits historical structural disadvantage, not current consumer preferences.

4. **Expectation gaps.** MacKeigan (2023) found women expect half the compensation even within the same sport. If athletes are "sole managers of their NIL opportunities" (MacKeigan, 2023) and women systematically undervalue themselves, the resulting gap reflects information asymmetry, not efficient pricing.

**Our position:** We do not adjudicate this debate. We provide the empirical decomposition — how much of the gap is between-sport (the football effect), how much is within-sport but explained by observables (followers, performance, school brand), and how much is unexplained. Readers who believe the market is efficient will interpret unexplained gaps as omitted variables. Readers who believe structural inequity operates will interpret them as evidence of discrimination. We provide the numbers; the interpretation is separable.

---

## The Dependent Variable: On3's Total Player Value (TPV)

### What On3 NIL Valuation actually is (post-December 2024)

**On3's NIL Valuation is itself a proprietary algorithm that changed significantly in December 2024.** On3 CEO Shannon Terry announced the shift: "On3 NIL Valuation Inputs Change: Introducing Total Player Value" (Terry, On3, December 10, 2024). Wikipedia summarizes: the methodology was "overhauled in December 2024 to a 'Total Player Value' (TPV) model. This updated model splits valuations into two distinct categories: Roster Value (collective-driven compensation similar to a salary) and NIL Value (traditional marketing and brand endorsements)" (Wikipedia, "On3.com," 2025).

On3 explains the components:

- **Roster Value:** "the primary factor influencing most athletes' NIL Valuation. It is determined mainly by collected deal data within the college marketplace and represents the compensation athletes receive from schools and collectives for competing, similar to contracts and salaries for professional athletes" (On3, "About On3 NIL Valuation and Roster Value").
- **NIL Value:** "measures an athlete's market value in terms of licensing and sponsorship. This value is influenced by on-field performance, media exposure, and social media presence. Typically, only elite national athletes or those with a strong social media following generate significant revenue from brand marketing compared to their Roster Value" (ibid.).
- **Total Player Value:** "The On3 NIL Valuation is the leading index in the industry that determines the projected annual value (PAV) of college and high school athletes by combining Roster Value and NIL Value" (ibid.).

Before the December 2024 overhaul, the algorithm was based on "Performance, Influence, and Exposure" with approximate weights described by industry observers as: "Social media presence accounts for approximately 30-40% of the calculation... Athletic performance contributes another 25-35%... Team success and media exposure add 15-20%" (Bitget, "How to Track NIL Values on On3 in Real-Time," 2025). **These weights describe the old methodology and may not apply to the current TPV model.**

### Why the Roster Value / NIL Value split matters for gender analysis

The split is analytically powerful because it separates two different economic mechanisms:

| Component | Economic Mechanism | Gender Dynamics | Policy Lever |
|---|---|---|---|
| **Roster Value** | Collective/booster allocation decisions | Men dominate (~96.5% of collective $) | Governance: Title IX enforcement, collective reform |
| **NIL Value** | Brand demand, social media, marketability | Women's basketball > men's basketball commercially | Market: media investment, platform design |
| **Total Player Value** | Sum of both | Men dominate in aggregate | Misleading to analyze as single number |

**Analyzing TPV as a single number conflates two opposite stories.** A football player might have a $2M Roster Value and a $200K NIL Value. A women's basketball star might have a $50K Roster Value and a $300K NIL Value. Their TPV gap ($2.2M vs. $350K) is 6:1. But their NIL Value gap ($200K vs. $300K) is 1:1.5 in the *woman's* favor. Analyzing only TPV would attribute a 6:1 "gender gap" that is actually a collective-funding gap masquerading as a gender effect.

### The circularity problem (updated for TPV)

**We are auditing an algorithm, not measuring a market.** If On3's Roster Value is calibrated to collective deal data, and we use collective-related features (conference, sport, school brand) to predict it, we will partly rediscover On3's calibration — not market economics. Similarly, if NIL Value weights social media at 30-40%, predicting it with follower counts will achieve high R² by recovering On3's engineering choices.

**What this means for each track:**

- **Track 1 (Descriptive):** Unaffected. We describe the distribution of On3 valuations as they are. We are explicit that these are algorithmic estimates, not actual compensation.
- **Track 2 (Algorithmic Audit):** We are analyzing **the structure of On3's TPV algorithm** — what On3 weights, how those weights differ for Roster Value vs. NIL Value, and whether gender shifts predicted valuations. This is an audit of algorithmic fairness, analogous to audit studies of hiring algorithms or credit-scoring models. We claim nothing about the actual market.
- **Track 3 (Within-Sport Gap Estimation):** We analyze only the NIL Value component (brand-driven), not Roster Value, because Roster Value is mechanically determined by collective governance and offers no within-sport gender variation to exploit. Even for NIL Value, the remaining "gender effect" is the residual that On3 chose not to encode through other inputs. We state this clearly.

### Cross-validation with non-algorithmic data

Two non-algorithmic data sources provide reality checks:
- **EADA institutional data** (actual revenues and expenses by sport and gender, reported by schools to the Department of Education).
- **Opendorse aggregate transaction statistics** based on "$250 million in real NIL transactions" from "150,000+ athlete users" (Opendorse, "NIL at 3," 2024).

Neither provides individual-level actual deal values. But if the descriptive patterns in On3's NIL Value component diverge dramatically from Opendorse's commercial compensation data, that divergence is itself a finding about On3's algorithm.

### NIL Go: Not a viable data source for this project

The House v. NCAA settlement (approved June 2025) established NIL Go — a clearinghouse run by Deloitte. "All NIL transactions with a total value of $600 or more must be reported by student-athletes and member institutions" (Ropes & Gray, June 2025). However, CSC CEO Bryan Seeley stated the clearinghouse was "struggling" (Yahoo Sports/Sports Business Journal, May 2025). When ESPN requested NIL disclosure from 23 schools, "colleges still released few to no records," citing FERPA (Georgetown Law Tech Review, 2024). We do not build any analysis around NIL Go data. If aggregate reports become available during the project, we use them as validation.

---

## Distinguishing Activities from Compensation: The Content Labor Premium

A critical distinction that prior reporting has noted but not quantified at the sport level:

| Metric | Source | What It Measures | Who Leads |
|---|---|---|---|
| **NIL activities** (social media posts, brand mentions) | Opendorse | Volume of brand-related content athletes produce | Women ~53% (excl. football, Year 1) |
| **NIL compensation** (dollars received) | Opendorse | Actual money paid to athletes | Men ~60%+ even excl. football (Sportico, 2023) |
| **NIL deal applications** | Opendorse | Athlete-initiated deal-seeking | Women 32.2% of 500K applications (Opendorse/The GIST, 2025) |
| **On3 Total Player Value** (estimated market value) | On3 | Algorithmic estimate combining Roster Value + NIL Value | Men dominate (all top-20 are male) |
| **Collective payments** | Opendorse | Money from booster collectives | Women <3.5% |
| **Commercial compensation** | Opendorse | Money from brand deals/sponsorships | Women's basketball #2 behind football (2024) |

**The gap between activities and compensation is itself a primary finding.** Women do more NIL content work but receive less money. We define the **content labor ratio** as: (share of NIL activities) ÷ (share of NIL compensation), by sport and gender. If women perform 53% of activities but receive 40% of compensation, their content labor ratio is 53/40 = 1.33 — they perform 33% more activities per dollar than men. If men receive 60% of compensation from 47% of activities, their ratio is 47/60 = 0.78.

This ratio, computed by sport and over time using Opendorse aggregate data, is a simple and policy-relevant metric that has not been published. It operationalizes Sailofsky's (2025) argument that women perform more NIL labor for lower returns.

**Limitation:** This analysis uses aggregate Opendorse data, not individual-level activity-compensation pairs. We cannot compute the ratio for individual athletes. We state this clearly and note that individual-level analysis requires data access we do not have.

---

## What We Measure vs. What We Claim

| What We Do | What It Tells Us | What It Does NOT Tell Us |
|---|---|---|
| Descriptive gap accounting ± football, Roster Value vs. NIL Value | How much football and collective structure mechanically drive the aggregate gender gap | Anything causal — this is accounting |
| Quantile/time decomposition | Where and when the gap is largest, and whether it is narrowing or widening | Why the gap is large at those points |
| Selection-rate denominator analysis | What fraction of D1 female vs. male athletes On3 covers at all | Whether uncovered athletes have zero NIL activity (they might have deals not tracked by On3) |
| Content labor ratio | How many activities per dollar women vs. men perform | Whether the ratio reflects differential effort, differential pricing, or both |
| XGBoost + SHAP on Roster Value and NIL Value separately | Which features On3's algorithm weights for each component, and whether gender shifts those weights | What *causes* an athlete to be valued more or less — SHAP ≠ causation |
| Within-sport OLS/DML on NIL Value | How much of the within-sport brand-value gap is explained by observables vs. unexplained | Whether the unexplained gap is "discrimination" — it could be omitted variables |

---

## Causal Structure: The DAG

Any claim about "unexplained gaps" requires clarity about what pathways are controlled vs. uncontrolled. We propose the following structure:

```
                      ┌──────────────┐
                      │  Gender (D)  │
                      └──────┬───────┘
                             │
          ┌──────────────────┼──────────────────────┐
          │                  │                      │
          ▼                  ▼                      ▼
    ┌──────────┐      ┌──────────┐          ┌──────────────┐
    │  Sport   │      │  Media   │          │  Expectation │
    │ Selection│      │ Coverage │          │  & Negotiation│
    └────┬─────┘      │(Instit.) │          │  Asymmetry   │
         │            └────┬─────┘          └──────┬───────┘
         ▼                 ▼                       │
    ┌──────────┐      ┌──────────┐                 │
    │  Sport   │      │  Social  │                 │
    │ Revenue  │      │  Media   │                 │
    │          │      │ Followers│                 │
    └────┬─────┘      └────┬─────┘                 │
         │                 │                       │
         ▼                 ▼                       ▼
    ┌────────────┐    ┌────────────┐          ┌────────────┐
    │  Booster / │    │  Brand     │          │  Deal      │
    │  Collective│    │  Demand    │          │  Acceptance│
    │  Allocation│    │            │          │  Threshold │
    └────┬───────┘    └────┬───────┘          └────┬───────┘
         │                 │                       │
         ▼                 ▼                       ▼
    ┌──────────┐      ┌──────────┐          ┌──────────────┐
    │  Roster  │      │   NIL    │          │  Realized    │
    │  Value   │      │  Value   │          │  Deals       │
    └──────────┘      └──────────┘          │  (Unobserved)│
                                            └──────────────┘
```

**Key implications:**

1. **Two distinct outcome pathways.** Roster Value and NIL Value have different causal pathways. Roster Value flows through Sport → Sport Revenue → Booster Allocation — a governance chain. NIL Value flows through Media Coverage → Social Media → Brand Demand — a market chain. Aggregating them into TPV conflates these mechanisms.

2. **Sport selection is a mediator, not a confounder.** Gender → sport selection (women cannot play football) → sport revenue → collective allocation → Roster Value. Controlling for sport blocks this pathway and estimates only the within-sport effect. We do this intentionally in Track 3 and label it as such.

3. **Social media followers are both a mediator and a feedback variable.** Gender → less media coverage → fewer followers → lower NIL Value. But also: higher NIL Value → more visibility → more followers. The DAG's acyclicity assumption is violated by this feedback loop. We acknowledge this: the within-sport estimate conditional on followers is not a clean "direct effect" — it is a "residual-after-mediator-control" that combines direct effects with feedback effects. We do not claim causal interpretation beyond "the gap not explained by these observables."

4. **Expectation and negotiation asymmetry** is a distinct pathway documented by MacKeigan (2023). Women expecting half the compensation may accept lower deals, reducing their realized compensation (and potentially On3's deal-data calibration for Roster Value). This pathway is unobservable in On3 data but is included in the DAG to acknowledge its theoretical role.

5. **Booster/collective allocation** is a distinct node from brand demand. Boosters fund collectives based on personal sport identification and institutional loyalty, not ROI optimization. This is why the commercial market shows different gender dynamics than the collective market.

**What each track estimates relative to this DAG:**

| Track | What It Estimates | Pathways Included |
|---|---|---|
| Track 1 (Descriptive) | Total gap in Roster Value and NIL Value separately | All pathways (raw comparisons) |
| Track 2 (Algorithmic Audit) | How On3's algorithm weights features for each component | All — this is about algorithmic structure, not causal pathways |
| Track 3 (Within-Sport, NIL Value only) | The within-sport NIL Value gap not explained by followers, performance, school brand | Residual of Expectation/Negotiation pathway + any unmodeled mechanisms + omitted variable bias |

---

## Data Sources

| Source | What It Provides | Access | Key Limitations |
|---|---|---|---|
| **On3 NIL Rankings** | Per-athlete Total Player Value (TPV) split into Roster Value + NIL Value, sport, school, conference, social media follower counts | on3.com — scraping required (see Risks) | Algorithmic estimates, not actual deals. Proprietary. Anti-scraping measures. Coverage thins rapidly outside revenue sports. |
| **NCAA EADA Data** | School-level athletic revenues, expenses, participation counts, coaching salaries — by sport and gender | ope.ed.gov/athletics — free CSV download, 2003–2024 | School-level only, not athlete-level. Ecological inference limitation. |
| **Opendorse Annual Reports** | Aggregate NIL transaction statistics: compensation by sport/gender, activity counts, collective vs. commercial split. Based on "$250 million in real NIL transactions" from "150,000+ athlete users." | Public PDFs ("NIL at 3," 2024; "NIL at 4," expected 2025) | Aggregate only — no individual-level microdata. Opendorse is one platform; does not capture all deals. |
| **Sports-Reference** | Team win/loss records, conference standings, individual player statistics for some sports | sports-reference.com — scraping | Coverage varies by sport. Women's non-revenue sports have sparse data. |
| **NCAA Demographics Reports** | Aggregate racial/ethnic composition data by sport | NCAA.org — public | Aggregate by sport, not individual-level. |

### Sample Construction

**Full sample (Tracks 1–2):** All On3 athletes with published NIL valuations that include the Roster Value / NIL Value split. We target the broadest available coverage, not just top lists. On3 states it tracks "10,000+ D1 athletes" — but the UB Law School (2024) analysis of the On3 Top 100 found only 4 women's basketball players in the top 100. Coverage of women in non-revenue sports is likely very sparse.

**Realistic sample-size expectation:** Based on On3's known coverage patterns and the UB Law School demographics analysis, we estimate:
- Football: 500–1,000 athletes with valuations (male only)
- Men's basketball: 200–400
- Women's basketball: 100–200
- Other sports (volleyball, softball, soccer, swimming, track, baseball, gymnastics): 50–150 each, with much thinner coverage for non-revenue men's sports

**Matched sample (Track 3, NIL Value only):** Athletes in gender-comparable sports — basketball (M vs. W), soccer (M vs. W), volleyball (M vs. W where both exist), swimming (M vs. W), track & field (M vs. W). Football and women-only sports (gymnastics, softball) are excluded.

**Critical feasibility concern:** Getting N>500 in the matched sample requires substantial On3 coverage of non-revenue men's sports (men's soccer, men's swimming, men's volleyball, men's track). On3's coverage of these sports is unknown and likely thin. **We budget the first two weeks to assess this before committing to Track 3's scope.** Our realistic expectation is that basketball will dominate the matched sample (possibly N=200–400), with other sports contributing small supplements. If total matched N<200, Track 3 reduces to basketball-only descriptive comparisons with no regression.

---

## Methodology

### Track 1: Descriptive Accounting (PRIMARY — Weeks 3–6)

**Goal:** Quantify the gender gap in On3 NIL Valuations across every meaningful cut, with the Roster Value / NIL Value decomposition as the core analytical innovation.

**Analyses:**

*1a. Aggregate gap decomposition:*
- Full-sample gender gap in TPV: raw mean, median, ratio of means
- Gender gap in **Roster Value** vs. **NIL Value** separately — the core contribution
- Gender gap in TPV **excluding football**: how much does football removal close the gap?
- Gender gap in NIL Value excluding football: does the commercial-side gap persist?

*1b. Within-sport analysis:*
- Gender gap within each sport that has both genders: basketball, soccer, volleyball, swimming, track
- For each sport: gap in Roster Value (collective-driven) vs. gap in NIL Value (brand-driven)
- Basketball deep-dive: men's vs. women's basketball is the cleanest comparison. Opendorse data shows women's basketball outperforms men's commercially — does On3's NIL Value reflect this?

*1c. Distributional analysis:*
- Gender gap by **quantile** (top 50, top 100, top 500, top 1,000): does the gap widen or narrow at the top?
- Separate quantile analysis for Roster Value and NIL Value
- Visualization: overlapping density plots of log(NIL Value) by gender, within basketball

*1d. Conference and institutional analysis:*
- Gender gap by **conference tier** (Power 4, Group of 5, other D1)
- Do Power 4 schools show larger or smaller within-sport gaps?

*1e. Time trend (if feasible):*
- Has the gender gap changed from 2021–2025? This requires either (a) Wayback Machine snapshots of On3 rankings, or (b) comparison of our 2025 scrape with published historical rankings. **Feasibility is uncertain** — On3's December 2024 algorithm change makes pre/post comparisons structurally different (old algorithm vs. TPV). We flag this limitation and, if we proceed, present pre-December-2024 and post-December-2024 data as separate series.

*1f. Selection-rate denominator analysis:*
- EADA data tells us how many male vs. female athletes exist at each D1 school.
- We compute: "Of all D1 female athletes, what percentage appear in On3's database with any valuation?" vs. the same for males. This measures On3's **coverage bias**, not market participation — but coverage bias itself reflects and reinforces visibility disparities.
- **This may be the paper's most-cited number.** If 30% of D1 male athletes appear in On3 but only 5% of D1 female athletes do, that ratio is a concrete, memorable finding.

*1g. Content labor ratio:*
- Using Opendorse aggregate data: compute (women's share of NIL activities) ÷ (women's share of NIL compensation), overall and by sport where data permits.
- Present the ratio over time (Year 1, Year 2, Year 3) if Opendorse reports provide year-by-year breakdowns.
- Discuss divergence between activity share and compensation share as evidence of differential returns to content labor (Sailofsky, 2025).
- **Limitation:** This is computed from aggregate percentages, not individual-level data. We cannot control for activity type, quality, or engagement. We state this clearly.

**Why Track 1 is the primary contribution:** This work requires no causal assumptions, no ML caveats, no SHAP interpretation debates. The Roster Value / NIL Value decomposition is analytically novel (On3 only split these in December 2024 — no published research has analyzed them separately). The selection-rate denominator and content labor ratio are simple, memorable, and policy-relevant. This track is publishable on its own.

### Track 2: Algorithmic Audit via Predictive ML (SECONDARY — Weeks 5–8)

**Goal:** Audit On3's TPV algorithm — what features does it weight for Roster Value vs. NIL Value, and does gender shift those weights?

**Framing:** This is an **algorithmic audit**, not a market study. We are asking: "Given the features On3 uses, does the algorithm produce systematically different valuations for men and women with similar observable characteristics?" This is analogous to audit studies of credit-scoring algorithms (e.g., Bartlett et al. 2022) or hiring algorithms (e.g., Raghavan et al. 2020), where the question is whether the algorithm exhibits disparate impact — regardless of whether that impact reflects "true" market differences.

**Two separate models, one for each TPV component:**

*Model A: Predicting Roster Value*
- Features: sport, conference, school EADA revenue, team win%, class year, recruit rating, gender
- Expected result: sport and conference will dominate. Gender will have high importance mostly as a proxy for sport (football has no women). This model's SHAP analysis will show that Roster Value is primarily a sport-revenue allocation mechanism.

*Model B: Predicting NIL Value*
- Features: Instagram followers, TikTok followers, Twitter/X followers, sport, conference, school EADA revenue, team win%, class year, recruit rating, gender
- Expected result: social media followers will dominate (this partly recovers On3's known weighting). The gender SHAP value *after controlling for followers* is the interesting quantity: does On3's algorithm value a woman with 100K Instagram followers differently than a man with 100K followers?

**Models:**
- Baseline: OLS linear regression (for comparability with existing literature)
- Primary: XGBoost with 5-fold cross-validation, stratified by sport and gender
- Evaluation: R², MAE, RMSE on held-out test set (80/20 split)

**Explainability:**
- SHAP values for global feature importance, separately for Roster Value and NIL Value models
- SHAP dependence plots for gender × followers, gender × sport, gender × school revenue
- Compare SHAP gender values across Models A and B: is gender more predictive for Roster Value (expected) or NIL Value?

**Critical caveats (stated prominently in paper):**

*SHAP ≠ causation.* "High feature importance or SHAP values reflect predictive power rather than mechanistic influence" (arXiv:2506.10179, 2025). A high SHAP value for gender means gender helps predict On3 valuations — it does not mean gender *causes* differential valuations in the market.

*SHAP and correlated features.* "The Shapley method suffers from inclusion of unrealistic data instances when features are correlated" (arXiv:2305.02012v3). Social media followers, school brand, and sport are all correlated — SHAP may misattribute importance among correlated features.

*Circularity.* Because On3's NIL Value component weights social media presence heavily, our SHAP analysis will partly recover On3's engineering weights. We state: "Track 2 audits the structure of On3's algorithmic valuations. Where SHAP values align with On3's known input categories, we cannot distinguish market signal from algorithm construction. The audit value lies in detecting **differential treatment by gender** — whether the algorithm weights the same inputs differently for men and women — not in discovering what inputs matter (which On3 has already disclosed)."

### Track 3: Within-Sport Gap Estimation (CONDITIONAL — Weeks 7–10)

#### Scope and Honest Expectations

Track 3 analyzes only the **NIL Value** component (brand-driven) within gender-comparable sports. Roster Value is excluded because it is mechanically determined by collective governance and does not permit meaningful within-sport gender comparison (collectives allocate to sports, not to individual athletes based on observable performance).

**We expect this track to be constrained by small sample sizes.** Based on On3's known coverage patterns, the matched sample (basketball + soccer + volleyball + swimming + track, both genders) is unlikely to exceed N=500. Basketball will likely dominate. Our realistic plan is OLS regression with sensitivity analysis; DML is an upside contingency.

#### Go/No-Go Decision (End of Week 4)

| Matched Sample Size | Track 3 Scope |
|---|---|
| N ≥ 500 across ≥2 sports with ≥100/gender | Full specification: OLS + DML + sensitivity analysis |
| 200 ≤ N < 500 | OLS + Cinelli & Hazlett (2020) sensitivity analysis only. No DML. |
| N < 200 | Descriptive within-sport comparisons only. No regression. Report as extension of Track 1. |

#### Primary Method: OLS with Sensitivity Analysis

```
log(NIL_Value_i) = α + θ·Female_i + X_i'β + γ_sport + ε_i
```

within the matched-sport sample, with sport fixed effects. Two specifications per the DAG:

- **Specification A (residual after observable controls):** Controls = social media followers (log), team win%, conference tier, school EADA revenue, recruit ranking, class year. This estimates the NIL Value gap holding followers and performance constant — the portion not explained by On3's known inputs.
- **Specification B (total within-sport effect):** Controls = class year, conference tier only. This estimates the full within-sport gap, allowing the media → followers → NIL Value pathway to operate.

The difference (Spec B – Spec A) reveals how much of the within-sport gap is explained by the media/followers pathway. This is an informal mediation analysis, not a formal causal decomposition — we use it to generate hypotheses about mechanisms, not to make causal claims.

**Sensitivity analysis:** We use the `sensemakr` package (Cinelli & Hazlett, 2020) to compute the **robustness value (RV)** — "the minimum strength that unobserved confounders need to have to overturn a research conclusion" (Cinelli, Ferwerda, & Hazlett, 2020). The RV is expressed in partial R² terms: "unobserved confounders that explain more than [RV]% of the residual variance of both the treatment and the outcome are strong enough to bring the point estimate to 0." We also compute the sign-change breakdown point from Diegert, Masten, & Poirier (2024), who showed that Oster's (2019) delta can be misleading: "any time this measure is large — suggesting that omitted variables may be unimportant — a much smaller value reverses the sign of the parameter of interest" (Diegert et al., arXiv:2208.00552v4, 2024).

#### DML Upside (if N ≥ 500)

If the matched sample exceeds N=500, we additionally run Double Machine Learning (Chernozhukov et al. 2018) via the `DoubleML` Python package (Bach et al., *Journal of Statistical Software*, 108, 2024). DML procedure:
1. Split data into K=5 folds
2. For each fold: train ML models (XGBoost) to predict (a) NIL Value from controls X, and (b) gender indicator from controls X
3. Compute residuals for both
4. Regress outcome residuals on treatment residuals to obtain the gender-effect estimate

"DML relies on two steps to obtain causal effect estimates. First, it estimates a model for both the outcome and the treatment... the final estimator is robust to minor mistakes in the estimation of either of these models" (Bach et al., 2024).

We pair DML with **short-stacking** across XGBoost, Random Forest, and LASSO per Ahrens et al. (2025): "DDML with stacking is more robust to partially unknown functional forms than common alternative approaches based on single pre-selected learners" (Ahrens et al., "Model Averaging and Double Machine Learning," *Journal of Applied Econometrics*, 2025; arXiv:2401.01645).

**DML caveats we will state:**
- The literature recommends "G-computation for n<100, DML for n>500" (arXiv:2403.14385). At N=500 we are at the boundary.
- "In low-overlap designs, coverage collapses to 39.8% at n=2000, with a large negative bias" (arXiv:2512.07083). Even within basketball, men's and women's programs are economically distinct.
- Ahrens et al. (2025): "DDML with conventional stacking exhibits relatively large bias with n=200."

**Common support:** We plot propensity-score distributions P(Male | X) within the matched sample. If distributions show poor overlap (>30% of observations trimmed at α=0.05), we report this as a finding and limit Track 3 to OLS+sensemakr.

---

## Addressing Selection Bias

On3 only tracks athletes who already have some NIL presence or relevance. Women athletes with **zero** NIL activity are invisible in this dataset. This is classic **truncation on the dependent variable**.

**Consequences:**
- Any measured gender gap in On3 data is a **lower bound** on the true gap among all D1 athletes, because the women who get nothing aren't in the sample.
- Regression on this truncated sample will produce biased coefficients (Heckman, 1979).

**Our approach:**
1. **Acknowledge explicitly** that we study the *conditional* distribution of NIL valuation given appearing in On3's database — not the population of all D1 athletes.
2. **Report the denominator.** EADA participation counts provide the universe of D1 male and female athletes. We compute selection rates (% appearing in On3) as a primary Track 1 finding.
3. **No Heckman correction.** A Heckman selection model requires an exclusion restriction — a variable that predicts selection into On3 but does not affect valuation conditional on selection. We have no credible candidate. Anything that makes an athlete visible to On3 (media market, school prestige, social media presence) also affects their valuation. Identification through distributional assumptions alone (normality of the error term) is widely regarded as unreliable. We are honest about this limitation rather than applying a technically available but substantively unjustified correction.

---

## Race × Gender: A Critical Confound We Cannot Fully Resolve

The gender gap in NIL is inextricable from racial composition. Black male athletes are overrepresented in football (the highest-NIL sport) and men's basketball. Any "gender gap" confounds gender with the racial demographics of revenue vs. non-revenue sports.

MacKeigan (2023) provided initial evidence: "BIPOC athletes have 1.7 times higher compensation expectations and 1.8 times higher opt-out thresholds than white athletes" and "Despite the NIL participation rate being higher for BIPOC athletes than white athletes, BIPOC athletes may be less likely to be involved with more than one deal."

We cannot ethically code individual athletes' race from public profiles. Visual racial classification is unreliable and ethically problematic.

**What we do instead:**
- Use aggregate racial/ethnic composition data by sport from the NCAA's annual demographics reports (publicly available).
- Include sport-level racial composition as a contextual variable in the discussion: "how much of the gender gap in NIL is mechanically attributable to the concentration of Black male athletes in the two highest-NIL sports?"
- Discuss the race × gender × sport intersection explicitly in the paper's limitations and policy implications.
- Cite the UB Law School finding that "almost ten percent of the On3 Top 100 athletes are directly related to a former or current professional athlete. All nine such athletes are men" ("Data and Demographics Driving NIL Deals," 2024).

**What we acknowledge we cannot do:** Individual-level decomposition of gender and race effects simultaneously. This is a clear limitation, flagged as a priority for future research with NIL Go demographic data.

---

## Missing Variables We Cannot Observe (Omitted Variable Bias)

| Omitted Variable | Why It Matters | Expected Direction of Bias on Gender Coefficient |
|---|---|---|
| **Actual deal values** | On3 estimates ≠ real compensation | Unknown — On3 may systematically over- or under-estimate women's value relative to actual deals |
| **Agent/representation quality** | Athletes with professional NIL agents negotiate larger deals | Upward bias (men in revenue sports more likely to have agents) — meaning the true within-sport gap may be smaller |
| **TV viewership/ratings** | Drives brand ROI, which drives NIL | Upward bias (men's revenue sports have higher viewership) |
| **Athlete effort in NIL marketing** | Some athletes actively pursue deals; others don't | Unknown direction |
| **Race/ethnicity** (individual-level) | Gender × race interaction is confounded with sport structure | Complex — see section above |
| **Individual performance statistics** | Player-level stats (points, yards, etc.) beyond team win% | Bias toward zero if performance is similar within sport |
| **Attractiveness / appearance** | Documented factor in women's NIL (Wanzer, 2024; Sailofsky, 2025) | Could reduce "unexplained" gap if measured — women who invest in appearance-based content may have higher NIL Value |
| **Negotiation expectations** | MacKeigan (2023) found women expect half the compensation | Upward bias — lower expectations may depress realized deals and On3's calibration |

**Bottom line:** Any unexplained gap we find is an *upper bound* on the portion attributable to algorithmic or market bias, because it includes all omitted-variable effects correlated with both gender and NIL valuation. We state this explicitly.

---

## Temporal Validity: Studying a Market in Transition

The NIL market is changing structurally. Our data captures a specific historical moment — not a steady state.

| Date | Market State | Key Feature |
|---|---|---|
| July 2021 | NIL legalized | Unregulated; early adopters |
| 2022–2023 | Collective boom | 82% of compensation via collectives; women get <3.5% of collective money |
| December 2024 | On3 algorithm overhaul | Switch from "Performance, Influence, Exposure" to TPV (Roster Value + NIL Value) |
| June 2025 | House settlement approved | Revenue sharing begins; NIL Go launched |
| Summer 2025 | Our data collection window | Post-algorithm-change, post-settlement, mid-NIL-Go-implementation |

**What this means for our study:**

1. **We are studying a transitional market.** Our data is collected after On3's December 2024 TPV overhaul and after the June 2025 House settlement. It is neither a clean pre-settlement baseline nor a post-settlement equilibrium. We must state this temporal scope clearly.

2. **The On3 algorithm change creates a structural break.** Any time-series comparison across the December 2024 boundary is comparing two different algorithms. We do not claim continuity. If we present time trends, pre-December-2024 and post-December-2024 data are separate series with a clear label.

3. **The value as a transitional snapshot.** Documenting the NIL market's structure during the settlement transition is valuable precisely because the market is about to change. Revenue sharing may narrow the gender gap (by formalizing payments that were previously channeled through male-dominated collectives) or widen it (by legitimizing sport-revenue-based compensation differentials). Our snapshot provides the baseline against which future changes can be measured.

---

## Pre-Registration: Quantitative Hypotheses with Effect Sizes

We pre-register the following on OSF or SSRN before analysis begins. Each hypothesis specifies a direction *and* a magnitude range, so that confirmation is not trivially guaranteed.

**H1 (Football mechanical effect):** Excluding football from the denominator reduces the gender gap in total On3 NIL Valuation by at least 40 percentage points (e.g., from 80:20 male:female to within 60:40).
- *Based on:* AP News (2022) reported the ratio flipped to 52.8:47.2 in Year 1. Sportico (2023) reported it was "still nearly 60%" male by Year 2. We predict the 2025 data will show football exclusion reduces the gap substantially but not to parity — between 55:45 and 65:35 male:female.
- *Would challenge our framing if:* Football exclusion changes the ratio by less than 20 percentage points. This would mean the gap is pervasive across sports, not primarily a football story.

**H2 (Roster Value vs. NIL Value divergence):** The gender gap in Roster Value (ratio of male mean to female mean) is at least 3× larger than the gender gap in NIL Value.
- *Based on:* Collectives send <3.5% to women (Opendorse, 2024), while women's basketball outperforms men's basketball commercially. Roster Value, which is "determined mainly by collected deal data" from collectives (On3), should embed this collective-funding disparity.
- *Would challenge our framing if:* The Roster Value and NIL Value gaps are similar in magnitude. This would mean the collective vs. commercial distinction does not structure the gender gap — a finding that would undermine the TPV-decomposition approach.

**H3 (Within-basketball gap direction and magnitude):** Men's mean On3 NIL Value exceeds women's mean On3 NIL Value in basketball, but by a ratio no greater than 3:1.
- *Based on:* Women's basketball outperforms men's commercially (Opendorse, 2024), but men's basketball has higher viewership and more top-100 representation (UB Law, 2024). We predict the NIL Value gap in basketball is smaller than the Roster Value gap but still favors men.
- *Would challenge our framing if:* Women's basketball NIL Value exceeds men's. This would be a strong finding — the algorithm undervalues women commercially despite brands valuing them more.
- *Would also challenge framing if:* The ratio exceeds 5:1. This would suggest the NIL Value algorithm is not reflecting the commercial market's revealed preference for women's basketball.

**H4 (Content labor ratio):** Women perform more NIL activities per dollar of compensation than men (content labor ratio > 1.0 for women, < 1.0 for men), using Opendorse aggregate data.
- *Based on:* Women do ~53% of activities (excl. football) but receive <40% of compensation (Sportico, 2023; Opendorse data).
- *Would challenge our framing if:* The ratio is approximately 1.0 for both genders. This would mean activity levels and compensation are proportional — no differential content labor.

**H5 (Selection rate disparity):** A smaller percentage of D1 female athletes appear in On3's database than D1 male athletes, even after excluding football rosters from the male denominator.
- *Based on:* On3's coverage is known to be concentrated in revenue sports.
- *Would challenge our framing if:* Female selection rates equal or exceed male selection rates after football exclusion. This would mean On3's coverage bias is entirely a football artifact.

---

## Timeline (12 Weeks — Realistic Scoping)

| Week | Task | Owner | Deliverable | Gate |
|---|---|---|---|---|
| 1–2 | **Data acquisition and feasibility.** Download EADA CSVs. Begin On3 scraping (with rate limiting, caching). Assess: Does On3 provide Roster Value / NIL Value split for all athletes? How many women athletes are covered? How many matched-sport athletes exist? Download Opendorse PDFs. | Students A + B | Raw data; **feasibility memo**: On3 coverage by sport × gender, confirmed Roster/NIL Value availability | **Week 2 gate:** If On3 scraping fails → execute Fallback Design. If Roster/NIL split is not available for most athletes → analyze TPV as single DV with caveat. |
| 2–3 | **Data cleaning and merging.** Clean On3 data. Merge with EADA school-level data (by school name). Construct matched sample. Count sample sizes by sport × gender. | Student B | Merged dataset; sample-size table by sport × gender × TPV component | **Week 3 gate:** Report matched-sample N. Determine Track 3 scope per go/no-go table. |
| 3–6 | **Descriptive analysis (Track 1).** All analyses in 1a–1g above. This is the primary output. | Student B + Anna | Complete descriptive results, all figures and tables | |
| 5–8 | **Algorithmic Audit (Track 2).** XGBoost models for Roster Value and NIL Value separately. SHAP analysis. Gender × feature interactions. | Student C + Anna | Model performance tables, SHAP plots, algorithmic audit narrative | |
| 7–9 | **Within-Sport Gap Estimation (Track 3).** OLS + sensemakr (all scenarios). DML only if N>500. | Anna (primary) + Student C | Coefficient estimates, robustness values, sensitivity plots | |
| 9–10 | **Integration and interpretation.** Connect all tracks. Reconcile Track 1 patterns with Track 2 SHAP findings and Track 3 estimates. Identify contradictions. Policy implications. | Anna + all students | Results narrative | |
| 10–12 | **Paper writing.** Introduction, prior work, data, methods, results, discussion, conclusion. Target: 20–30 pages. | Anna (primary), students contribute data/methods sections | Complete manuscript | |

**Realistic scoping note:** This timeline is tight for a team that may be learning XGBoost and SHAP for the first time. If Track 2 modeling takes longer than expected, Track 3 is the first to be cut — it adds the least marginal value given the sample-size constraints. Track 1 (descriptive accounting) is the non-negotiable deliverable.

---

## Fallback Design (If On3 Scraping Fails)

If On3 blocks scraping and no data partnership materializes by Week 2, the project pivots to an **EADA-only institutional analysis**:

**Research question (fallback):** At the school level, what predicts the gender gap in athletic investment (revenues, expenses, coaching salaries) — and how does this institutional structure map onto known patterns of NIL inequality?

**Data:** EADA 2003–2024 (free, reliable, comprehensive). ~350 D1 schools × 21 years = ~7,350 school-year observations.

**Method:**
- Descriptive: gender gap in revenues, expenses, and coaching salaries by sport and conference, with time trends
- Predictive: XGBoost on school-level features predicting revenue gap, with SHAP
- Connect to NIL: use Opendorse aggregate data to show that the institutional revenue gap (EADA) mirrors the NIL compensation gap (Opendorse) — same sports, same conferences, same direction

This fallback sacrifices the athlete-level analysis but retains the theoretical framework, the ML toolkit, and the policy relevance. It is publishable at JQAS or International Journal of Sport Finance.

---

## Team Task Allocation

- **Student A:** Web scraping (On3 athlete profiles), data pipeline documentation, rate-limiting and caching infrastructure
- **Student B:** EADA data download and processing, data merging, all Track 1 descriptive analysis and visualization
- **Student C:** Track 2 ML modeling (XGBoost), SHAP analysis, model evaluation
- **Anna:** Research design, theoretical framing, Track 3 regression analysis (OLS + sensemakr), paper writing, quality control, integration across tracks

**Mentorship need:** The team needs access to someone with applied econometrics / ML experience to advise on SHAP interpretation, DML implementation (if triggered), and sensitivity analysis. If Anna does not have this background, the project should identify a faculty advisor or mentor with relevant expertise before Week 1.

---

## Publication Targets (Realistic Assessment)

| Target | Fit | Realistic? |
|---|---|---|
| **SSRN / arXiv preprint** | Immediate visibility, establishes priority | ✅ Yes — submit Week 12 |
| **MIT Sloan Sports Analytics Conference** (research paper track) | Perfect venue for descriptive + ML sports analysis. Values rigorous description. | ✅ Strong fit — submission typically ~October |
| **Journal of Quantitative Analysis in Sports** | Welcomes ML methods, shorter turnaround | ✅ Realistic with revisions |
| **International Journal of Sport Finance** | Good fit for the economics angle | ✅ Realistic |
| **Applied Economics Letters** | Short-format, fast turnaround | ✅ Condense Track 1 to 3,000 words |
| **Journal of Sports Economics** | Top field journal, wants causal identification | ⚠️ Stretch — Track 3 OLS+sensemakr is not the level of identification JSE expects. Would need DML with large N and credible common support. |
| **Big Data & Society** or **New Media & Society** | Algorithmic audit framing fits their scope | ✅ Novel angle — framing On3 as an algorithm to audit, not a market to study |

---

## Risks, Unknowns, and Honest Limitations

### Technical Risks

| Risk | Severity | Likelihood | Mitigation |
|---|---|---|---|
| **On3 blocks scraping** | HIGH | MEDIUM-HIGH | Respectful rate limiting (3–5s delays). Cache aggressively. **Fallback:** data partnership request. **Final fallback:** EADA-only design. |
| **On3 does not expose Roster Value / NIL Value split for all athletes** | MEDIUM | UNKNOWN | Week 1 feasibility check. If split unavailable, analyze TPV as single DV with caveat about aggregation. Core contribution (Track 1 descriptive) still works. |
| **Matched-sample N too small for any regression** | HIGH | HIGH | Go/no-go gate at Week 3. If N<200, Track 3 becomes descriptive within-sport comparisons only. The paper loses one track but gains honesty. |
| **EADA → On3 merge is imprecise** | MEDIUM | CERTAIN | EADA is school-level; On3 is athlete-level. No common athlete identifier. We merge by school name and use school-level variables as controls, not features of primary interest. We acknowledge the ecological inference limitation. |
| **On3 algorithm changes again during project** | LOW | LOW | Cache all scraped data with timestamps. Note algorithm version in documentation. |

### Methodological Risks

| Risk | Impact | Mitigation |
|---|---|---|
| **DV circularity (auditing On3 with On3's known inputs)** | SHAP values partly recover On3's engineering weights, not market economics | Frame Track 2 explicitly as algorithmic audit. The value is detecting **differential treatment by gender** — whether same inputs produce different outputs for men vs. women — not discovering what inputs matter. |
| **Small-sample bias in regression (Track 3)** | Wide confidence intervals, unreliable point estimates | Use sensemakr robustness values instead of relying on point estimates. Report bootstrap CIs. If N<500, do not run DML (per DML literature: "Recommend G-computation for n<100, DML for n>500," arXiv:2403.14385). |
| **Common support violations within matched sports** | Even within basketball, men's and women's programs are economically distinct (Duke men's ~$45M revenue vs. women's ~$5M) | Plot propensity scores. Report overlap diagnostics. If overlap is poor, report this as a finding rather than forcing estimation through trimming. |
| **Mediator vs. control confusion** | Controlling for followers blocks the media-coverage pathway; not controlling increases OVB | Run both Spec A (with followers) and Spec B (without). Label clearly. Do not claim either is "the" causal effect — Spec A is "residual-after-controls," Spec B is "total within-sport." |

### Risks We Cannot Mitigate

| Risk | Why It Is Unavoidable |
|---|---|
| **On3 data ≠ market reality** | On3's valuations are algorithmic estimates. The "NIL Illusion" critique applies: "platforms often rely on" incomplete data, creating a situation where "NIL values are based more on perception than reality" (Rodriguez, "The NIL Illusion," *CTRL.FORM Substack*, April 2025). We have no individual-level actual deal data and no prospect of obtaining it during this project. |
| **Selection bias (truncation on DV)** | We study athletes On3 chooses to cover, not all D1 athletes. No credible Heckman correction. The measured gap is a lower bound on the true gap. |
| **Temporal instability** | The market is being restructured by the House settlement. Our snapshot captures a transitional moment, not a steady state. Findings may not generalize to the post-settlement market. |
| **We cannot identify discrimination** | No observational study with this data can distinguish algorithmic/market bias from omitted variables. We can bound the unexplained gap, but not attribute it. |

---

## Key References

### NIL Market and Gender Equity
- AP News. "One year of NIL: How much have athletes made?" July 2022. "Remove football and women flip it to 52.8% vs. 47.2% for men."
- Sportico. "Women's College Sports Are Breaking Records. Do NIL Collectives Care?" 2023. "Data from Opendorse, a national NIL marketing platform, found that over 77% of all NIL funding went to male athletes. Even after subtracting football, that figure was still nearly 60%."
- Opendorse. "NIL at 3: The Annual Opendorse Report." 2024. Reports based on "$250 million in real NIL transactions" from "150,000+ athlete users." "NIL collectives continue to shape over 80% of the total NIL market." "In the commercial segment, Women's Basketball is in the number two spot for total compensation, second only behind Football." "<3.5% of all Collective compensation goes to females."
- Opendorse / The GIST. "NIL deal platform Opendorse shares key insights on today's women college athletes." 2025. "Women athletes submitted 32.2% of the 500K NIL deal applications."
- MacKeigan, L. "An Equity Analysis on the Collegiate Name, Image, and Likeness (NIL) Market." SSRN 4554235, 2023. "Women's sport competitors expect, and will opt out of a deal, at half the compensation rate that men's sport competitors will." "The total following that an athlete in women's sports has been significantly influential in their compensation estimations, while it is not influential for athletes in men's sports."
- LeRoy, M. H. "NCAA Women Athletes and NIL Pay Disparities: Are They Students Under Title IX, Employees Under Title VII, or Both?" *U. Cincinnati Law Review*, 93(4), 979, 2025. "Men's basketball players in major NCAA conferences were paid an average of $171,272 in 2024, compared to $16,222 for women."
- Rogers, M. "Does NIL Diminish Gender Equity in Sports?" Indiana University CARI Blog, 2023. "Out of the 1,748 student-athletes benefiting from these collectives, 73.21% of the NIL deals were made with males and 26.79% with females." "Both male and female NIL frequency in collectives had a strong, positive correlation with media impact (0.6824, 0.6095)."
- Shuler, K. & Steinfeldt, J. A. "If You Build It: A Structural Analysis of the NIL Impact on Women's College Sports." *Journal of Sports and Games*, 7(2), 6–16, 2025. "Without intentional structural reforms in college sport, NIL could further exacerbate existing gender disparities instead of addressing and potentially correcting them."
- Sailofsky, D. "The privilege to do it all? Exploring the contradictions of name, image and likeness (NIL) rights for women athletes and women's sports." *International Review for the Sociology of Sport*, 2025. "NIL collective arrangements — the least labour-intensive type of NIL labour — also disproportionately benefit men's athletes."
- Rodriguez, D. "The NIL Illusion: How Artificial Market Values Are Impacting College Athlete's Decisions." *CTRL.FORM Substack*, April 2025. "NIL values are based more on perception than reality."
- "Data and Demographics Driving NIL Deals." University at Buffalo School of Law, 2024. "Twenty-five (25) of [the On3 Top 100] are collegiate basketball players, four (4) of which are women and twenty-one (21) men." "Almost ten percent of the On3 Top 100 athletes are directly related to a former or current professional athlete. All nine such athletes are men."
- Henneman, C. "Spring 2025." Elon University Journal, 2025. Content analysis of 622 posts from 15 On3 Top 100 football players using Wanzer's MABI framework.

### On3 NIL Valuation Methodology
- Terry, S. "On3 NIL Valuation Inputs Change: Introducing Total Player Value." On3, December 10, 2024.
- On3. "About On3 NIL Valuation and Roster Value." On3.com. "The On3 NIL Valuation is the leading index in the industry that determines the projected annual value (PAV) of college and high school athletes by combining Roster Value and NIL Value." "Roster Value is the primary factor influencing most athletes' NIL Valuation. It is determined mainly by collected deal data within the college marketplace." "NIL Value... measures an athlete's market value in terms of licensing and sponsorship."
- Wikipedia. "On3.com." 2025. "Originally based on a 'Performance, Influence, and Exposure' algorithm, the methodology was overhauled in December 2024 to a 'Total Player Value' (TPV) model."
- Bitget. "How to Track NIL Values on On3 in Real-Time." 2025. "Social media presence accounts for approximately 30-40% of the calculation... Athletic performance contributes another 25-35%... Team success and media exposure add 15-20%." (Note: these weights may describe the pre-December 2024 methodology.)

### House Settlement, NIL Go, and Data Access
- Ropes & Gray. "House v. NCAA Settlement Approved." June 2025. "All NIL transactions with a total value of $600 or more must be reported."
- Yahoo Sports / Sports Business Journal. May 2025. CSC CEO Bryan Seeley stated the clearinghouse was "struggling."
- Georgetown Law Tech Review. "NIL and Data Transparency." 2024. "Absent a federal mandate, colleges would likely resist transparency."

### Causal Methodology
- Chernozhukov, V. et al. "Double/debiased machine learning for treatment and structural parameters." *The Econometrics Journal*, 21(1), C1–C68, 2018.
- Bach, P. et al. "DoubleML — An Object-Oriented Implementation of Double Machine Learning." *Journal of Statistical Software*, 108, 2024.
- Ahrens, A. et al. "Model Averaging and Double Machine Learning." *Journal of Applied Econometrics*, 2025; arXiv:2401.01645. "DDML with stacking is more robust to partially unknown functional forms."
- Flachaire, E. et al. "Decomposing Inequalities using Machine Learning." arXiv:2511.13433, 2025.

### Sensitivity Analysis
- Cinelli, C. & Hazlett, C. "Making Sense of Sensitivity: Extending Omitted Variable Bias." *Journal of the Royal Statistical Society, Series B*, 82(1), 39–67, 2020.
- Cinelli, C., Ferwerda, J., & Hazlett, C. "sensemakr: Sensitivity Analysis Tools for OLS." 2020. "The robustness value describes the minimum strength that unobserved confounders need to have to overturn a research conclusion."
- Diegert, P., Masten, M. A., & Poirier, A. "The Effect of Omitted Variables on the Sign of Regression Coefficients." arXiv:2208.00552v4, 2024. "Any time [Oster's explain-away delta] is large... a much smaller value reverses the sign of the parameter of interest."

### SHAP and ML Explainability
- "High feature importance or SHAP values reflect predictive power rather than mechanistic influence." (arXiv:2506.10179, 2025)
- "The Shapley method suffers from inclusion of unrealistic data instances when features are correlated." (arXiv:2305.02012v3)

### DML Finite-Sample Performance
- "DML improves with sample size. Recommend G-computation for n<100, DML for n>500." (arXiv:2403.14385)
- "In low-overlap designs, coverage collapses to 39.8% at n=2000, with a large negative bias." (arXiv:2512.07083)
- Ahrens et al. (2025): "DDML with conventional stacking exhibits relatively large bias with n=200."

### Gender Pay Gap Methodology (General)
- Lechner, M. & Strittmatter, A. "Labor market sorting and the gender pay gap revisited." *PMC*, 2024. Systematic analysis of common support violations across sample sizes from 10,000 to 1M+ observations. Demonstrates that "the share of the total raw gap attributable to lack of support is considerably larger" in smaller samples.

---

## What Changed from v3 and Why

| v3 | v4 | Reason |
|---|---|---|
| On3's algorithm described using pre-December 2024 weights (30-40% social media, etc.) | Updated for December 2024 TPV overhaul; Roster Value / NIL Value split is now the core analytical framework | On3 CEO Shannon Terry announced the change December 10, 2024. The old weights may not apply. The split is analytically powerful — it separates collective-driven and brand-driven gaps. |
| Track 2 framed as "study of On3's valuation structure" | Reframed as **algorithmic audit** with separate models for Roster Value and NIL Value | "Algorithmic audit" is a recognized methodology with its own literature. Separate models for each component allow cleaner interpretation. |
| DML presented as a real possibility with OLS as fallback | OLS+sensemakr is the **planned method** for Track 3; DML is an **upside contingency** if N>500 | Honest assessment: matched-sample N is very unlikely to reach 500. Planning around DML wastes weeks 7-10 when it will almost certainly fall back to OLS. |
| MacKeigan (2023) not cited | Full engagement with MacKeigan and other prior work; explicit "What Is Already Known" section | MacKeigan's SSRN paper directly addresses the same research question with survey data. Failing to engage it signals insufficient literature review. |
| No discussion of whether the gap *should* be equal | Explicit "efficiency question" section with four counter-arguments | A *Journal of Sports Economics* reviewer will immediately ask this. The paper must engage with the null hypothesis that the gap is efficient. |
| Content labor ratio mentioned as bullet point | Promoted to a named metric with its own analysis section | This is the most novel and memorable empirical contribution. It operationalizes Sailofsky's (2025) theory. |
| DAG included "Direct Discrimination (?)" as a node | Removed. Replaced with observable mechanisms (Expectation Asymmetry, Booster Allocation, Brand Demand) | "Discrimination" is not a DAG node — it is the residual after conditioning. DAGs represent causal mechanisms, not residual categories. |
| Pre-registered hypotheses were directional only (e.g., "H1: gap narrows by 50%+") | Quantitative hypotheses with specific magnitude ranges and explicit conditions that would challenge the framing | Directional pre-registration of already-known findings is theater. Magnitude ranges create genuine falsification risk. |
| 12-week timeline presented as feasible for all three tracks | Explicit scoping note: Track 1 is the non-negotiable deliverable; Track 3 is first to be cut if time runs short. Mentorship need flagged. | A team of undergrads + a former rower cannot reliably deliver DML, XGBoost, and a 30-page paper in 12 weeks without experienced methodological mentorship. |
| No acknowledgment of On3's December 2024 algorithm change for time-series analysis | Time trends flagged as structurally broken across the December 2024 boundary; pre- and post- presented as separate series | Comparing pre-TPV and post-TPV valuations is comparing two different algorithms. Presenting them as a continuous trend would be misleading. |
| Opendorse finding that women's basketball outperforms men's commercially was not mentioned | Highlighted as central evidence that the collective vs. commercial distinction structures the gender gap | This Opendorse finding directly supports the Roster Value / NIL Value decomposition. It shows the gender gap reverses in the commercial market. |
| Publication targets included JSE as "stretch" | JSE assessed as unlikely given OLS+sensemakr Track 3; added *Big Data & Society* for algorithmic audit angle | Honest venue assessment. The algorithmic audit framing opens a different publication pathway. |
