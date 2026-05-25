# Proposal 1 (v5): Two Markets, One Gap — Descriptive Accounting and Algorithmic Decomposition of Gender Disparities in College NIL

## Summary

The NCAA NIL market has grown from $917M (2021–22) to a projected $1.67B (2024–25), with potential to exceed $2.5B in the first revenue-sharing year (Opendorse, "NIL at 3," 2024). Football alone captures 49.9% of all NIL compensation. NIL collectives — which account for 81.6% of all NIL compensation — send less than 3.5% of their dollars to women (Opendorse, "NIL at 3," 2024; NIL Certifications, 2024).

But the headline number hides a structural fact: **the NIL market is two markets with opposite gender dynamics, aggregated into a single misleading figure.**

- **The collective market (~82% of total NIL compensation):** Booster-funded organizations that allocate money based on sport and donor preference. Men receive over 96% of collective dollars. This is not a market outcome; it is a governance choice. LeRoy (2025) showed that schools coordinate with collectives to "monetize NIL donor access in favor of men" ("NCAA Women Athletes and NIL Pay Disparities," *U. Cincinnati Law Review*, 93(4), 979, 2025).

- **The commercial market (~18% of total NIL compensation):** Brand deals and sponsorships where companies optimize for ROI. Here, "Women's Basketball is in the number two spot for total compensation, second only behind Football" — ahead of men's basketball (Opendorse, "NIL at 3," 2024). At the per-athlete level, however, the picture differs: Opendorse estimates top-25 expected annual earnings at "$349K in men's basketball" vs. "$88,975 in women's basketball" (Opendorse, "NIL at 3," 2024, summarized by The Student-Athlete Advisors). Women's basketball leads in total sport-level commercial volume — likely because more women do commercial deals — but men's basketball leads in per-athlete compensation.

This two-market structure matters because the aggregate "gender gap" conflates governance decisions (collective allocations) with market signals (brand demand). Policy implications differ radically: if the gap is primarily collective-driven, the response is Title IX enforcement and collective governance reform. If it is also market-driven, the response involves media investment, platform design, and athlete education.

**In December 2024, On3 restructured its NIL Valuation algorithm to reflect this distinction.** On3 CEO Shannon Terry announced the shift from the old "Performance, Influence, and Exposure" algorithm to a "Total Player Value" (TPV) model that "splits valuations into two distinct categories: Roster Value (collective-driven compensation similar to a salary) and NIL Value (traditional marketing and brand endorsements)" (Wikipedia, "On3.com," 2025; Terry, "On3 NIL Valuation Inputs Change: Introducing Total Player Value," On3, December 10, 2024).

**However, a critical data-access constraint limits how we can exploit this split.** On3 states: "NIL Valuations and Roster Values that exceed $1.5 million are available for public viewing. Valuations below $1.5 million require an On3+ subscription to access. Additionally, any NIL Valuation or Roster Value under $100,000 per athlete is not recorded or displayed" (On3, "About On3 NIL Valuation and Roster Value"). This means:
- The Roster Value / NIL Value split is only publicly scrapable for elite athletes (>$1.5M), who are overwhelmingly male.
- Athletes below $100K — where most women in non-revenue sports fall — are not in On3's database at all.
- Full access to the split for mid-tier athletes ($100K–$1.5M) requires an On3+ subscription.

**The project is therefore designed to work under three data scenarios**, each yielding a publishable paper:

| Scenario | Data Available | Project Scope |
|---|---|---|
| **A (Best case):** On3+ access or data partnership | TPV with Roster Value / NIL Value split for all athletes ≥$100K | Full descriptive decomposition + algorithmic decomposition + within-sport gap estimation |
| **B (Likely case):** Public scraping only | TPV total for most athletes; Roster/NIL split only for >$1.5M | Descriptive accounting using TPV total as primary DV. Roster/NIL split analyzed for elite subsample only. Collective vs. commercial distinction drawn from Opendorse aggregate data instead. |
| **C (Fallback):** On3 scraping fails | EADA institutional data + Opendorse aggregate reports | School-level institutional analysis of the gender investment gap, connected to NIL patterns via Opendorse |

**The project's core analytical contribution does not depend on the split.** Track 1 (descriptive accounting) and the content labor ratio analysis work with any data scenario. The Roster Value / NIL Value decomposition is an enhancement — the strongest framing if Scenario A materializes — but the project survives without it.

We pursue two tracks, with a conditional extension:

1. **Primary: Descriptive Accounting (Track 1).** The gender gap in On3 NIL Valuations — with and without football, within individual sports, by quantile, by conference tier. The activities-vs.-compensation divergence ("content labor ratio"). The selection-rate denominator analysis. If the Roster Value / NIL Value split is available, all descriptive analyses are run separately for each component. No causal assumptions required.

2. **Secondary: Algorithmic Decomposition via Predictive ML (Track 2).** What features best predict On3 valuations, and does gender shift those predictions? XGBoost + SHAP — framed as reverse-engineering On3's algorithm, not as a market study. If the split is available, separate models for each component.

3. **Conditional: Within-Sport Gap Estimation (Track 3).** Within gender-comparable sports, how much of the NIL valuation gap is explained by observables? OLS with sensitivity analysis as the planned method; DML only if N>500.

**What this project is and is not.** We study On3's algorithmic valuations — not actual compensation. We describe distributions and reverse-engineer an algorithm — we do not identify discrimination. We cannot observe actual deal values, negotiation behavior, or athlete effort. We document the NIL market during a period of structural transition (post-settlement, post-algorithm-change). We are explicit about these boundaries throughout.

---

## Why Anna

She was a D1 Women's Rower at Cornell who retired due to injury and became team manager. She lived the invisible-athlete experience — rowing is a non-revenue sport where NIL dollars barely exist. She watched the NIL revolution unfold during her four years (2020–2024). This isn't academic to her; it's autobiographical.

Critically, Anna's experience illustrates the **sport-structure confound** at the heart of this paper: her invisibility was not because she was a woman, but because she was in a non-revenue sport. Men's rowing gets almost no NIL either. Separating "gender effect" from "sport-revenue effect" is the core intellectual challenge of this project.

---

## What Is Already Known (Prior Work)

**Aggregate gap and football's role:**
- AP News (July 2022): "Remove football and women flip it to 52.8% vs. 47.2% for men" in total compensation.
- Sportico (2023): "Data from Opendorse, a national NIL marketing platform, found that over 77% of all NIL funding went to male athletes. Even after subtracting football, that figure was still nearly 60%."
- Opendorse "NIL at 3" (2024): Collectives account for 81.6% of total NIL compensation. "<3.5% of all Collective compensation goes to females." But in the commercial segment, "Women's Basketball is in the number two spot for total compensation, second only behind Football."
- Rogers (2023, Indiana University): "Out of the 1,748 student-athletes benefiting from [38 NIL] collectives, 73.21% of the NIL deals were made with males and 26.79% with females." "Both male and female NIL frequency in collectives had a strong, positive correlation with media impact (0.6824, 0.6095)."

**Gender and race in athlete expectations:**
- MacKeigan (2023, SSRN, University of Michigan): surveyed 330 athletes across 46 conferences and 23 sports. "Women's sport competitors expect, and will opt out of a deal, at half the compensation rate that men's sport competitors will." Also: "a similar trend between white and BIPOC athletes: white athletes will expect 60% lower and opt-out at 54% lower compensation rates." Crucially: "the total following that an athlete in women's sports has been significantly influential in their compensation estimations, while it is not influential for athletes in men's sports" (SSRN 4554235, 2023).

**On3 Top 100 demographics:**
- University at Buffalo School of Law (2024): Of the On3 Top 100, "twenty-five (25) of them are collegiate basketball players, four (4) of which are women and twenty-one (21) men." "Almost ten percent of the On3 Top 100 athletes are directly related to a former or current professional athlete. All nine such athletes are men."

**Content and marketability:**
- Sailofsky (2025): "NIL collective arrangements — the least labour-intensive type of NIL labour — also disproportionately benefit men's athletes" (*International Review for the Sociology of Sport*, 2025).
- Henneman (2025, Elon University): Content-analyzed 622 Instagram/TikTok posts from 15 On3 Top 100 football players using Wanzer's (2024) MABI framework.

**Legal and structural analysis:**
- LeRoy (2025): "men's basketball players in major NCAA conferences were paid an average of $171,272 in 2024, compared to $16,222 for women" (*U. Cincinnati Law Review*, 93(4), 979, 2025).
- Shuler & Steinfeldt (2025): "Without intentional structural reforms in college sport, NIL could further exacerbate existing gender disparities" (*Journal of Sports and Games*, 7(2), 6–16, 2025).

**The Caitlin Clark effect:**
- In 2024, the "Caitlin Clark effect" drove the WNBA's most-watched regular season in 24 years. Indiana University's Ryan Brewer estimated Clark was "responsible for a staggering 26.5% of all WNBA economic activity last season" and valued her 2025 economic impact at potentially "$875 [million]... I could easily see that eclipsing a billion dollars" (NBC News, May 2025).
- The 2024 NCAA Women's Championship drew record-breaking 18.9 million viewers (Nielsen, 2024).
- Opendorse reported women's basketball annual expected earnings for top-25 athletes up 85% year-over-year (Opendorse, "NIL at 3," 2024).
- This boom is occurring *during* our study period. It creates both an opportunity (the commercial market for women's basketball is demonstrably growing) and a temporal confound (a summer 2025 snapshot captures a market in the midst of a structural shift driven by a small number of superstar athletes).

**What remains unknown and what this project adds:**

| Known | Unknown (Our Contribution) |
|---|---|
| Football drives the aggregate gap | Precisely how much in On3 *algorithmic* valuations, by quantile, over time |
| Women get <3.5% of collective money | Whether On3's Roster Value vs. NIL Value decomposition reflects this collective/commercial split (if we access the data) |
| Women's basketball outperforms men's commercially at the sport-total level (Opendorse) | Whether this holds at the per-athlete level, and whether On3's algorithm reflects or contradicts the commercial-market signal |
| Women do ~53% of NIL activities but get <40% of compensation | The **content labor ratio** within sport — is the aggregate ratio driven by between-sport composition (Simpson's Paradox) or does it persist within each sport? |
| MacKeigan found women expect half the compensation (survey data) | Whether On3's observed algorithmic valuations show the same pattern — extending from expectations to platform-published estimates |
| On3 Top 100 demographics are documented | The **denominator**: of all D1 athletes, what % have On3 valuations at or above the $100K recording floor? This selection rate, by gender and sport, has not been published. |
| The Clark/Reese effect is reshaping women's basketball | How superstar concentration distorts the women's basketball distribution — does the within-basketball gap narrow only at the top 5–10 athletes? |

---

## Theoretical Framework

### Why would we expect a gender gap in NIL?

**Demand-side explanations (market-efficiency):**
- **Viewership differentials.** Men's football and basketball generate vastly more TV revenue. If NIL valuations reflect brand ROI, athletes in higher-viewership sports command higher valuations. A gender "gap" driven entirely by sport-revenue differences is a sport-revenue gap that correlates with gender because football has no female equivalent.
- **Consumer willingness-to-pay.** If consumers spend more on men's sports products and content, differential NIL pricing may reflect efficient factor-market pricing.

**Supply-side explanations (structural):**
- **Collective governance.** Collectives are funded by boosters of football and men's basketball. LeRoy (2025) showed schools actively coordinate with collectives to channel money to men. These are governance choices, not market prices.
- **Agent and representation asymmetry.** Male athletes in revenue sports are more likely to have professional NIL agents. MacKeigan (2023) found women expect half the compensation, suggesting internalized market signals or information asymmetry.
- **Media exposure feedback loop.** Less media coverage → fewer followers → lower NIL valuation → less media interest. Rogers (2023) found strong positive correlation between media impact and NIL collective frequency (r = 0.68 male, 0.61 female).

**Sociocultural explanations:**
- **Femininity and marketability.** Sailofsky (2025) found women's NIL success is often conditional on performing femininity. This suggests a qualitatively different — and more labor-intensive — path to NIL value for women.

### The efficiency question: When is a gap not inequitable?

A rigorous study must engage with the null hypothesis that the NIL gender gap is efficient.

**The argument for efficiency:** If men's football generates $45M+ in annual revenue at a top program and women's rowing generates near-zero, differential NIL pricing for athletes in those sports may reflect underlying economic fundamentals. Under standard labor economics, workers whose marginal revenue product differs will be compensated differently. A gender "gap" driven entirely by sport-revenue differences is not a gender gap — it is a sport-revenue gap that correlates with gender.

**Four responses that complicate the efficiency claim:**

1. **Collective payments are not market transactions.** Collectives are donor-funded organizations that allocate money based on booster preferences, not competitive bidding or ROI optimization. When LeRoy (2025) shows schools "monetize NIL donor access in favor of men," this is a governance decision, not a market price. The collective market (~82% of total NIL compensation) cannot be efficient by construction — it is not a market.

2. **The commercial market is more complex than the headline suggests.** Women's basketball leads men's basketball in *total sport-level* commercial compensation (Opendorse, "NIL at 3," 2024). But Opendorse's per-athlete top-25 figures tell a different story: "$349K in men's basketball" vs. "$88,975 in women's basketball" (Opendorse, "NIL at 3," 2024). Women's basketball leads on total volume (more athletes doing more deals) but trails on per-athlete value (each deal is smaller). This is consistent with either (a) efficient pricing given differential viewership, or (b) women doing more work for less return — the content labor channel that Sailofsky (2025) theorizes. The data do not disambiguate these interpretations.

3. **Media exposure is endogenous.** Women's sports historically received less coverage not because of lower demand but because of institutional under-investment in broadcasting. The Clark effect (2024–2025) shows that when women's basketball receives comparable media exposure, viewership can rival or exceed men's: "Fever games averaged 1.18 million viewers, compared to 394,000 for all other games" (WSC Sports, 2025). The media → followers → NIL pathway transmits historical structural disadvantage, not necessarily current consumer preferences.

4. **Expectation gaps depress realized compensation.** MacKeigan (2023) found women expect half the compensation even within the same sport. If athletes are "sole managers of their NIL opportunities" (MacKeigan, 2023) and women systematically undervalue themselves, the resulting gap reflects information asymmetry and learned under-valuation, not efficient pricing.

**Our position:** We do not adjudicate this debate. We provide the empirical decomposition — how much is between-sport, how much is within-sport but explained by observables, and how much is unexplained. The interpretation is separable from the numbers.

---

## The Dependent Variable: On3's Total Player Value (TPV)

### What On3 NIL Valuation actually is (post-December 2024)

On3's NIL Valuation changed significantly in December 2024. The methodology was "overhauled in December 2024 to a 'Total Player Value' (TPV) model" (Wikipedia, "On3.com," 2025).

On3 explains the two components:

- **Roster Value:** "the primary factor influencing most athletes' NIL Valuation. It is determined mainly by collected deal data within the college marketplace and represents the compensation athletes receive from schools and collectives for competing, similar to contracts and salaries for professional athletes" (On3, "About On3 NIL Valuation and Roster Value").
- **NIL Value:** "measures an athlete's market value in terms of licensing and sponsorship. This value is influenced by on-field performance, media exposure, and social media presence. Typically, only elite national athletes or those with a strong social media following generate significant revenue from brand marketing compared to their Roster Value" (ibid.).
- **Total Player Value:** "The On3 NIL Valuation is the leading index in the industry that determines the projected annual value (PAV) of college and high school athletes by combining Roster Value and NIL Value" (ibid.).

Before the overhaul, approximate input weights were described as: "Social media presence accounts for approximately 30-40% of the calculation... Athletic performance contributes another 25-35%... Team success and media exposure add 15-20%" (Bitget, "How to Track NIL Values on On3 in Real-Time," 2025). **These weights describe the old methodology and may not apply to the current TPV model.**

### Data access constraints: The $1.5M paywall and the $100K floor

On3's own documentation creates two hard constraints on data availability:

1. **The $1.5M paywall.** "NIL Valuations and Roster Values that exceed $1.5 million are available for public viewing. Valuations below $1.5 million require an On3+ subscription to access" (On3, "About On3 NIL Valuation and Roster Value"). This means the Roster Value / NIL Value split is only freely scrapable for the ~50–100 most elite athletes — overwhelmingly male, overwhelmingly football and men's basketball. Studying a gender gap with a 95%+ male sample is not viable.

2. **The $100K recording floor.** "Any NIL Valuation or Roster Value under $100,000 per athlete is not recorded or displayed" (ibid.). This is not soft selection bias (On3 choosing not to cover someone); it is a **hard censoring floor** built into the algorithm. Most women in non-revenue sports will fall below this threshold. The selection-rate analysis (Track 1f) measures "% of D1 athletes with On3 valuation ≥ $100K," not "% of D1 athletes with any NIL activity." We state this distinction explicitly.

**Implications for project design:**

- Under Scenario A (On3+ access or data partnership), we obtain the Roster Value / NIL Value split for all athletes ≥$100K. This enables the full TPV decomposition.
- Under Scenario B (public scraping only), we obtain total TPV for athletes ≥$100K, but the split only for athletes >$1.5M. We analyze TPV total as the primary DV and use the Roster/NIL split only for the elite subsample. The collective/commercial distinction is drawn instead from Opendorse aggregate data.
- Under Scenario C (scraping fails), we use EADA and Opendorse only (see Fallback Design).

**We pursue Scenario A actively.** Before Week 1, the team sends a data partnership request to On3 and investigates On3+ subscription costs and research-use terms. The cost of an On3+ subscription is likely <$300/year — modest relative to the analytical value. If neither partnership nor subscription materializes, the project proceeds under Scenario B, which remains publishable.

### The mapping between On3 components and Opendorse market segments

The proposal's two-market thesis draws a parallel between On3's Roster Value / NIL Value split and Opendorse's collective / commercial split. This mapping is **conceptually motivated but empirically unvalidated.** We treat it as an assumption and state it explicitly:

**Assumption (Collective-Roster / Commercial-NIL mapping):** On3's Roster Value, which is "determined mainly by collected deal data within the college marketplace" (On3), primarily reflects collective-driven compensation. On3's NIL Value, which "measures an athlete's market value in terms of licensing and sponsorship" (On3), primarily reflects commercial brand-driven compensation. If Roster Value also captures some commercial deal data, or NIL Value is influenced by collective spending patterns, the clean two-market separation dissolves.

We test this assumption indirectly: if the Roster Value gender gap is consistent with Opendorse's collective gender gap (>96% male), and the NIL Value gender gap is consistent with Opendorse's commercial gender gap (smaller, possibly reversing in basketball), the mapping holds. If the gaps diverge, the mapping fails — and that divergence is itself a finding about how On3's algorithm works.

### The circularity problem

**We are reverse-engineering an algorithm, not measuring a market.** If On3's Roster Value is calibrated to collective deal data, and we use collective-related features (conference, sport, school brand) to predict it, we partly rediscover On3's calibration. Similarly, if NIL Value weights social media heavily, predicting it with follower counts recovers On3's engineering choices.

**What this means for each track:**
- **Track 1 (Descriptive):** Unaffected. We describe the distribution of On3 valuations as they are.
- **Track 2 (Algorithmic Decomposition):** We are analyzing the structure of On3's algorithm. The value lies in detecting **differential treatment by gender** — whether the algorithm weights the same inputs differently for men and women — not in discovering what inputs matter (which On3 has disclosed).
- **Track 3 (Within-Sport Gap):** The remaining "gender effect" is the residual that On3 chose not to encode through its declared inputs. We cannot determine whether this residual reflects market reality or algorithmic idiosyncrasy.

---

## Distinguishing Activities from Compensation: The Content Labor Ratio

| Metric | Source | What It Measures | Who Leads |
|---|---|---|---|
| **NIL activities** (social media posts, brand mentions) | Opendorse | Volume of brand-related content athletes produce | Women ~53% (excl. football, Year 1) |
| **NIL compensation** (dollars received) | Opendorse | Actual money paid to athletes | Men ~60%+ even excl. football (Sportico, 2023) |
| **NIL deal applications** | Opendorse | Athlete-initiated deal-seeking | Women 32.2% of 500K applications (Opendorse/The GIST, 2025) |
| **On3 Total Player Value** (estimated market value) | On3 | Algorithmic estimate | Men dominate (all top-20 are male) |
| **Collective payments** | Opendorse | Money from booster collectives | Women <3.5% |
| **Commercial compensation** | Opendorse | Money from brand deals/sponsorships | Women's basketball #2 behind football at sport-total level; men lead at per-athlete level |

We define the **content labor ratio** as: (share of NIL activities) ÷ (share of NIL compensation), by sport and gender. If women perform 53% of activities but receive 40% of compensation, their content labor ratio is 53/40 = 1.33 — they perform 33% more activities per dollar.

**Simpson's Paradox warning.** The aggregate content labor ratio is vulnerable to composition effects. If women are concentrated in lower-paying sports where deal volume is high but deal value is low, the aggregate ratio could show women doing "more work per dollar" even if within every sport the ratio is 1:1. Specifically: a softball player might do 20 posts for a $500 deal (40 activities per $1K). A football player might do 2 posts for a $50K deal (0.04 activities per $1K). Aggregate these across sports and women appear to have a massive content labor premium — but it is entirely a between-sport composition effect.

**Our approach:** We compute the content labor ratio both at the aggregate level and within sport, using sport-level breakdowns from Opendorse reports where available. The within-sport ratio is the scientifically meaningful quantity. If Opendorse reports do not provide sufficient sport-level activity-by-gender breakdowns, we compute only the aggregate ratio and prominently caveat the Simpson's Paradox vulnerability: "The aggregate content labor ratio is confounded by between-sport composition. Women are concentrated in sports with higher activity-to-compensation ratios. The aggregate ratio cannot be interpreted as within-sport differential pricing without sport-level data."

---

## What We Measure vs. What We Claim

| What We Do | What It Tells Us | What It Does NOT Tell Us |
|---|---|---|
| Descriptive gap accounting ± football, and (if available) Roster Value vs. NIL Value separately | How much football and collective structure mechanically drive the aggregate gender gap | Anything causal — this is accounting |
| Quantile decomposition, with superstar sensitivity analysis | Where the gap is largest, and how much top-5 women's basketball superstars distort the women's distribution | Why the gap is large at those points |
| Selection-rate denominator (% of D1 athletes with On3 valuation ≥ $100K) | On3's coverage pattern by gender and sport, given its $100K recording floor | Whether uncovered athletes have zero NIL activity (they might have deals below $100K or on other platforms) |
| Content labor ratio (aggregate and within-sport where available) | Whether women perform more NIL activities per dollar of compensation | Whether differential content labor reflects effort, pricing, deal structure, or sport composition (aggregate ratio only) |
| XGBoost + SHAP on On3 valuations | How On3's algorithm weights features, and whether gender shifts those weights | What *causes* valuation differences — SHAP ≠ causation |
| Within-sport OLS on NIL valuation | How much of the within-sport gap is explained by observables vs. unexplained | Whether the unexplained gap is discrimination — it could be omitted variables. Any unexplained gap is an *upper bound* on bias. |

---

## Causal Structure: The DAG

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
    ┌────────────┐    ┌────────────┐          ┌────────────────┐
    │  Booster / │    │  Brand     │          │  Realized Deals│
    │  Collective│    │  Demand    │          │  (Unobserved)  │
    │  Allocation│    │            │          └────────────────┘
    └────┬───────┘    └────┬───────┘
         │                 │
         ▼                 ▼
    ┌──────────┐      ┌──────────┐
    │  On3     │      │  On3     │
    │  Roster  │      │  NIL     │
    │  Value   │      │  Value   │
    └──────────┘      └──────────┘
```

**Key implications:**

1. **Two distinct outcome pathways.** Roster Value flows through Sport → Revenue → Booster Allocation — a governance chain. NIL Value flows through Media → Social Media → Brand Demand — a market chain. Aggregating them into TPV conflates different mechanisms.

2. **Sport selection is a mediator, not a confounder.** Gender causes sport selection (women cannot play football); sport selection causes revenue differences; revenue causes NIL valuation. Controlling for sport blocks this pathway. We do this intentionally in Track 3 and label it as a within-sport estimate.

3. **Social media followers are both a mediator and a feedback variable.** Gender → less media coverage → fewer followers → lower NIL Value. But also: higher NIL Value → more visibility → more followers. This feedback loop violates the DAG's acyclicity. We acknowledge that within-sport estimates conditional on followers are "residual-after-mediator-control" — not clean causal effects.

4. **Realized Deals are the most policy-relevant outcome — but unobservable.** The Expectation/Negotiation Asymmetry pathway (MacKeigan, 2023: women expect half the compensation) feeds into actual deal acceptance — the one outcome we cannot study. This is the most actionable policy lever: NIL education, rate benchmarking, and negotiation training could directly target this channel. But testing whether this channel operates requires individual-level deal data (offers, counteroffers, acceptance decisions) that no currently available source provides. We state this limitation explicitly and note that On3's Roster Value, which is "determined mainly by collected deal data" (On3), may have MacKeigan's expectation gap already baked in through its calibration.

5. **Engagement rates are a missing mediator.** On3's pre-TPV algorithm weighted "engagement rates and content quality" alongside follower counts (Bitget, 2025). Women's social media accounts generally show higher engagement rates per follower. If On3 incorporates engagement, controlling for raw follower counts in Track 3 understates women's social media capital. A woman with 50K followers and 5% engagement generates more brand value than a man with 50K followers and 2% engagement. We check whether engagement data is available from On3 profiles. If unavailable, we note the direction of omitted-variable bias: failing to control for engagement likely biases the gender coefficient downward (makes the gap appear smaller).

---

## Data Sources

| Source | What It Provides | Access | Key Limitations |
|---|---|---|---|
| **On3 NIL Rankings** | Per-athlete TPV; Roster Value / NIL Value split (behind $1.5M paywall or On3+ subscription); sport, school, conference, follower counts | on3.com — scraping or On3+ subscription | Algorithmic estimates, not actual deals. $100K recording floor. Anti-scraping measures. Coverage thins rapidly outside revenue sports. |
| **NCAA EADA Data** | School-level athletic revenues, expenses, participation counts, coaching salaries — by sport and gender | ope.ed.gov/athletics — free CSV, 2003–2024 | School-level only. Cannot be directly merged with individual NIL valuations. |
| **Opendorse Annual Reports** | Aggregate NIL transaction stats: compensation by sport/gender, activity counts, collective vs. commercial split | Public PDFs ("NIL at 3," 2024) | Aggregate only — no individual-level data. One platform; doesn't capture all deals. |
| **Sports-Reference** | Team win/loss records, individual player statistics | sports-reference.com — scraping | Coverage varies by sport; sparse for women's non-revenue sports. |
| **NCAA Demographics Reports** | Aggregate racial/ethnic composition by sport | NCAA.org — public | Aggregate by sport, not individual-level. |

### Sample Construction and Realistic Size Estimates

**On3's $100K floor fundamentally constrains the sample.** Athletes below $100K are not recorded. Given that Opendorse estimates top-25 women's volleyball expected annual earnings at "$5,868" and top-25 softball at "$8,545" (Opendorse, "NIL at 3," 2024), the overwhelming majority of women in these sports will fall below On3's $100K threshold. On3 coverage of women outside basketball, gymnastics, and volleyball is likely in single digits or zero.

**Revised sample-size estimates (based on $100K floor + known coverage):**
- Football: 500–1,000 athletes (male only)
- Men's basketball: 200–400
- Women's basketball: 50–150 (only athletes with sufficient social media presence or collective value)
- Women's gymnastics: 20–50 (Livvy Dunne effect — a few superstars distort the sport)
- Women's volleyball, softball: 10–40 each
- Men's soccer, men's swimming, men's volleyball, men's track: likely <20 each — On3 has minimal economic incentive to build profiles for non-revenue men's sports
- Women's soccer, women's swimming, women's track: likely <10 each

**Matched-sample estimate for Track 3:** Basketball is the only gender-comparable sport with plausible On3 coverage on both sides. Realistic matched-sample: 200–350 basketball athletes total (100–200 men, 50–150 women), with negligible contributions from other matched sports. Track 3 is effectively a basketball-only analysis. We state this honestly rather than presenting it as a multi-sport matched design.

---

## Methodology

### Week 0: Pre-Proposal Data Probe (BEFORE project begins)

**Before committing to any track, the team conducts a 2-hour feasibility probe:**

1. Visit On3's public NIL rankings pages. Navigate to women's basketball, women's volleyball, women's soccer, women's swimming. Count: how many athletes have published valuations?
2. Check whether the Roster Value / NIL Value split is visible on public athlete profile pages (it may only appear for athletes >$1.5M).
3. Investigate On3+ subscription: cost, whether it exposes the split for all athletes ≥$100K, terms of research use.
4. Send a data partnership inquiry to On3 (contact: media@on3.com or Shannon Terry directly).

**This probe takes half a day and determines which data scenario (A, B, or C) the project operates under.** The proposal should not be finalized until this probe is complete.

### Track 1: Descriptive Accounting (PRIMARY — Weeks 3–6)

**Goal:** Quantify the gender gap in On3 NIL Valuations across every meaningful cut.

**Analyses:**

*1a. Aggregate gap decomposition:*
- Full-sample gender gap in TPV: raw mean, median, ratio of means.
- If Scenario A: gender gap in Roster Value vs. NIL Value separately.
- Gender gap in TPV excluding football: how much does football removal close the gap?

*1b. Within-sport analysis:*
- Gender gap within each sport with both genders represented in On3: basketball (primary), soccer, volleyball, swimming, track (if any coverage exists).
- If Scenario A: within-sport gap in Roster Value vs. NIL Value.
- **Basketball deep-dive:** men's vs. women's basketball is the cleanest and largest comparison. Does On3's valuation reflect the commercial market's revealed preference for women's basketball (Opendorse, 2024)?

*1c. Distributional analysis with superstar sensitivity:*
- Gender gap by quantile (top 50, top 100, top 500, top 1,000): does the gap widen or narrow at the top?
- **Superstar sensitivity analysis:** Run the quantile analysis with and without the top 5 women's basketball athletes (Clark-level superstars). If removing 5 athletes dramatically changes the women's distribution, the "within-basketball gap" is driven by a handful of outliers, not by the sport's overall gender dynamics. Report both versions.
- Visualization: overlapping density plots of log(TPV) by gender, within basketball.

*1d. Conference and institutional analysis:*
- Gender gap by conference tier (Power 4, Group of 5, other D1).

*1e. Selection-rate denominator analysis:*
- EADA data provides the universe of D1 male and female athletes by school.
- We compute: "Of all D1 female athletes, what percentage have an On3 valuation at or above the $100K recording floor?" vs. the same for males.
- We also compute: "Of all D1 female athletes excluding football rosters from the male denominator, what percentage have an On3 valuation?" — to test whether On3's coverage gap is entirely a football artifact (H5).
- **This is a measure of On3's algorithmic coverage, not of market participation.** Athletes below $100K may have NIL activity on other platforms. We state this distinction explicitly.

*1f. Content labor ratio:*
- Using Opendorse aggregate data: compute (women's share of NIL activities) ÷ (women's share of NIL compensation).
- **Primary analysis:** Compute within-sport ratios using sport-level breakdowns from Opendorse if available (AP News, July 2022 provides some sport-level activity data: "When it comes to total NIL activities, Opendorse says football (29.3%) is the leader, then baseball (8%), men's basketball (7.6%), women's track and field (5.6%) and women's volleyball (5.5%)").
- **If within-sport data is insufficient:** Compute aggregate ratio only with prominent Simpson's Paradox caveat.
- Present the ratio over time (Year 1, 2, 3) where Opendorse provides year-by-year breakdowns.

*1g. Time trends (if feasible):*
- On3's December 2024 algorithm change creates a structural break. Pre- and post-December-2024 data are separate series, clearly labeled. We do not claim continuity across the break.

### Track 2: Algorithmic Decomposition via Predictive ML (SECONDARY — Weeks 5–8)

**Goal:** Reverse-engineer what features On3's algorithm weights, and whether gender shifts predictions.

**Framing clarification (changed from v4).** v4 called this an "algorithmic audit" and cited Bartlett et al. (2022) and Raghavan et al. (2020). Those studies meet standards this project cannot: paired testing with synthetic profiles, access to training data, or sufficient common support for matched comparisons. What we actually do is **reverse-engineer a black-box algorithm from its published outputs** — a legitimate ML exercise, but not an "audit" in the fairness-literature sense. We call it an **algorithmic decomposition** and cite the model-interpretation literature rather than the audit/fairness literature.

The specific question this track can answer: **does On3's algorithm produce systematically different valuations for men and women with similar observable characteristics?** Since sport is a near-perfect proxy for gender (football = male, gymnastics = female), any SHAP analysis that includes sport as a feature will absorb most of the gender signal through sport, making the residual gender SHAP value artificially small. But removing sport creates omitted-variable bias. We address this by running the model **with and without sport** and interpreting both:

- **Model with sport:** Gender SHAP value measures the *within-sport algorithmic gender effect.* Expected to be small because sport captures most of the between-group variation.
- **Model without sport:** Gender SHAP value measures the *total algorithmic gender effect including sport composition.* Expected to be large and uninformative about within-sport dynamics.

If Scenario A (Roster/NIL split available): run separate models for Roster Value and NIL Value. If Scenario B: run one model on TPV total.

**Features:**
- *Athlete-level:* sport (categorical), position, class year, Instagram followers, TikTok followers, Twitter/X followers, recruit rating (if available), engagement metrics (if available from On3 profiles)
- *Team-level:* win%, conference, national ranking, postseason appearance
- *School-level:* EADA total athletic revenue, conference tier, media market
- *Treatment:* gender (binary)

**Models:**
- Baseline: OLS linear regression
- Primary: XGBoost with 5-fold cross-validation, stratified by sport and gender
- Evaluation: R², MAE, RMSE on held-out test set (80/20 split)

**Explainability:**
- SHAP values for global feature importance
- SHAP dependence plots for gender × followers, gender × sport
- **Key diagnostic:** SHAP gender interaction values. Does the SHAP value for followers differ by gender? If a woman with 100K followers gets a different SHAP contribution than a man with 100K followers, On3's algorithm treats gender as an interaction — whether intentionally or through proxy features.

**Caveats (stated prominently):**

*SHAP ≠ causation.* "High feature importance or SHAP values reflect predictive power rather than mechanistic influence" (arXiv:2506.10179, 2025).

*SHAP and correlated features.* "The Shapley method suffers from inclusion of unrealistic data instances when features are correlated" (arXiv:2305.02012v3). Sport, gender, and followers are correlated — SHAP may misattribute importance.

*Circularity.* We are predicting On3's algorithm output using features that are likely On3's algorithm inputs. High R² is expected and uninformative about the market. The value lies in the gender interaction analysis, not in overall model fit.

### Track 3: Within-Sport Gap Estimation (CONDITIONAL — Weeks 7–10)

#### Honest Expectations

Track 3 is effectively a **basketball-only** analysis. Based on our revised sample-size estimates, basketball is the only gender-comparable sport with plausible On3 coverage on both sides (100–200 men, 50–150 women). Other matched sports (soccer, swimming, volleyball, track) likely contribute <20 athletes each — too few for meaningful analysis.

If Scenario A: analyze NIL Value (brand component) within basketball. If Scenario B: analyze TPV total within basketball.

#### Go/No-Go Decision (End of Week 3)

| Basketball Sample Size | Track 3 Scope |
|---|---|
| N ≥ 300 (≥100 per gender) | OLS + sensemakr sensitivity analysis. DML only if total matched sample across all sports > 500. |
| 100 ≤ N < 300 | OLS + sensemakr. Report as exploratory with wide confidence intervals. |
| N < 100 | Descriptive basketball comparisons only. No regression. Report as extension of Track 1. |

#### Power Analysis

At N=250 (100 women, 150 men), with OLS and 6 controls, a standard power calculation (α=0.05, β=0.80) can detect a standardized coefficient of approximately d=0.25 — equivalent to a ~25–30% difference in log(valuation). If the true within-basketball gender gap in NIL Value is 15–20% (plausible if the commercial market partially favors women), the study is underpowered to detect it. A null result at N=250 is not evidence of no gap — it is evidence of insufficient power.

At N=500 (the DML threshold), the minimum detectable effect drops to ~d=0.18 (~20% difference). Still potentially underpowered for a small-to-moderate true effect.

**We state the minimum detectable effect size in the paper.** A null Track 3 result is reported as "we cannot detect effects smaller than X% at this sample size" — not as "there is no gender gap."

#### OLS Specification

```
log(NIL_Valuation_i) = α + θ·Female_i + X_i'β + ε_i
```

within basketball only (no sport fixed effects needed). Two specifications:

- **Specification A (residual after observable controls):** Controls = log(followers), team win%, conference tier, school EADA revenue, recruit ranking, class year, engagement metrics (if available). Estimates the gap not explained by On3's known inputs.
- **Specification B (total within-basketball effect):** Controls = class year, conference tier only. Estimates the full within-basketball gap.

The difference (Spec B – Spec A) reveals how much of the gap operates through the followers/media channel.

**Sensitivity analysis:** `sensemakr` (Cinelli & Hazlett, 2020) for robustness values. Diegert, Masten, & Poirier (2024) sign-change breakdown point. We use as benchmarks the partial R² of observable controls (e.g., how much variation do followers explain?) to assess whether plausible unobserved confounders could be strong enough to overturn the result.

#### DML Upside (if matched-sport N ≥ 500)

If total matched-sport sample (basketball + any other viable sport) exceeds N=500: DML via `DoubleML` (Bach et al., *Journal of Statistical Software*, 108, 2024) with short-stacking (Ahrens et al. 2025). Report alongside OLS for comparison. DML caveats per the finite-sample literature: "Recommend G-computation for n<100, DML for n>500" (arXiv:2403.14385); "In low-overlap designs, coverage collapses to 39.8% at n=2000" (arXiv:2512.07083).

---

## Addressing Selection Bias

On3's $100K floor creates **hard left-censoring.** Athletes below $100K are not missing at random — they are missing because their algorithmic valuation is low. This is truncation on the dependent variable.

**Consequences:**
- Any measured gender gap in On3 data is a **lower bound** on the true gap among all D1 athletes.
- Regression on this truncated sample produces biased coefficients (Heckman, 1979).
- The truncation is gendered: most women in non-revenue sports fall below $100K while most men in football/basketball exceed it.

**Our approach:**
1. **Acknowledge explicitly** that we study athletes with On3 valuations ≥ $100K — a subset of all D1 athletes, truncated by an algorithmic threshold.
2. **Report the denominator.** EADA participation counts provide the universe. We compute: "Of ~110,000 D1 female athletes and ~105,000 D1 male athletes (approximate EADA totals), what % appear in On3's database?" This selection rate is the paper's most-cited number. It captures both On3's editorial coverage choices and the $100K floor.
3. **No Heckman correction.** A credible exclusion restriction (a variable predicting selection into On3 but not affecting valuation conditional on selection) does not exist. We are honest about this limitation.

---

## Race × Gender: A Critical Confound We Cannot Fully Resolve

Black male athletes are overrepresented in football and men's basketball. Any "gender gap" confounds gender with racial demographics of revenue vs. non-revenue sports.

MacKeigan (2023): "BIPOC athletes have 1.7 times higher compensation expectations" but "may be less likely to be involved with more than one deal."

We cannot ethically code individual race from public profiles. We use aggregate racial/ethnic composition data by sport from NCAA demographics reports and discuss the race × gender × sport intersection in limitations.

---

## Missing Variables (Omitted Variable Bias)

| Omitted Variable | Why It Matters | Expected Bias Direction on Gender Coefficient |
|---|---|---|
| **Actual deal values** | On3 estimates ≠ real compensation | Unknown |
| **Agent/representation quality** | Professional agents negotiate larger deals | Upward (men more likely to have agents → true gap may be smaller) |
| **TV viewership/ratings** | Drives brand ROI | Upward (men's revenue sports have higher viewership) |
| **Engagement rates** | Higher engagement = more brand value per follower | Downward (women likely have higher engagement → controlling for followers alone understates women's social capital → measured gap appears smaller) |
| **Race/ethnicity** (individual) | Gender × race confounded with sport | Complex |
| **Individual performance stats** | Beyond team win% | Toward zero if within-sport performance is similar |
| **Negotiation expectations** | MacKeigan: women expect half the compensation | Upward (lower expectations → lower realized deals → On3 calibration → measured gap includes negotiation asymmetry) |
| **Athlete effort in NIL marketing** | Some athletes actively pursue deals | Unknown |

**Bottom line:** Any unexplained gap is an *upper bound* on algorithmic or market bias. We state this explicitly.

---

## Temporal Validity: Studying a Market in Transition

| Date | Event | Implication |
|---|---|---|
| July 2021 | NIL legalized | Market begins |
| 2022–2023 | Collective boom | 82% via collectives; women <3.5% |
| 2023–2024 | Caitlin Clark effect | Women's basketball viewership/commercial value surges |
| December 2024 | On3 TPV overhaul | Algorithm structural break |
| June 2025 | House settlement approved | Revenue sharing begins; NIL Go launched |
| Summer 2025 | **Our data collection window** | Post-algorithm-change, post-settlement, mid-Clark-era |

We capture a **transitional snapshot** — not a steady state. The Clark effect is actively reshaping women's basketball visibility during our study period. Revenue sharing may restructure collective allocations. We document this moment precisely because it is about to change.

---

## Pre-Registration: Quantitative Hypotheses

We pre-register on OSF before analysis. Each hypothesis specifies magnitude ranges.

**H1 (Football mechanical effect):** Excluding football reduces the male share of total On3 NIL Valuation to between 55% and 65% (from ~80%+ with football). Based on: AP News 2022 (52.8:47.2 in Year 1), Sportico 2023 ("still nearly 60%" male in Year 2). We predict the 2025 gap reopens relative to Year 1 but does not reach Year-2 levels due to the Clark effect.
- *Would challenge framing if:* Football exclusion changes the male share by <15 pp. This would mean the gap is pervasive, not primarily a football story.

**H2 (Roster Value / NIL Value divergence, if Scenario A):** The Roster Value gender gap (male:female ratio of means) is ≥3× the NIL Value gender gap. Based on: collectives send <3.5% to women; commercial market is more balanced.
- *Would challenge framing if:* Gaps are similar in magnitude. The two-market thesis would be wrong.

**H3 (Within-basketball magnitude):** Men's mean On3 valuation exceeds women's in basketball, but by a ratio between 2:1 and 5:1 for total TPV, and — if the split is available — between 1:1 and 3:1 for NIL Value only.
- *Would challenge framing if:* Women's basketball NIL Value exceeds men's — meaning the algorithm undervalues women despite brands valuing them more. Or if the TPV ratio exceeds 8:1 — meaning the within-basketball gap is as large as the cross-sport gap.

**H4 (Content labor ratio):** Women's aggregate content labor ratio > 1.0 (more activities per dollar). Within basketball, if data permits: women's ratio ≥ 1.2.
- *Would challenge framing if:* Aggregate ratio ≈ 1.0, or within-basketball ratio < 1.0.

**H5 (Selection rate disparity):** A smaller % of D1 female athletes have On3 valuations ≥$100K than male athletes, even after excluding football rosters.
- *Would challenge framing if:* Female selection rates equal or exceed male rates after football exclusion.

**H6 (Superstar concentration):** Removing the top 5 women's basketball athletes reduces the women's basketball mean valuation by ≥30%.
- *Would challenge framing if:* Removing top-5 changes the mean by <10% — meaning the distribution is not superstar-driven.

---

## Timeline (12 Weeks)

| Week | Task | Owner | Deliverable | Gate |
|---|---|---|---|---|
| **0 (pre-start)** | **Data probe.** Check On3 public pages for women's sport coverage. Investigate On3+ subscription cost and terms. Send data partnership request. | Anna + Student A | Feasibility memo: data scenario (A, B, or C) | **Before Week 1:** Confirm data scenario. If C → immediate pivot to Fallback Design. |
| 1–2 | **Data acquisition.** Download EADA CSVs. Begin On3 scraping (or On3+ data download). Count: how many athletes by sport × gender? Is the Roster/NIL split visible? Download Opendorse PDFs. | Students A + B | Raw data; sample-size table by sport × gender | **Week 2 gate:** Confirm Scenario A or B. If On3 scraping fails and no On3+ → Fallback. |
| 2–3 | **Data cleaning and merging.** Merge On3 with EADA by school name. Construct basketball matched sample. | Student B | Merged dataset; basketball matched-sample N | **Week 3 gate:** Report basketball N. Determine Track 3 scope. |
| 3–6 | **Track 1: Descriptive analysis.** All analyses in 1a–1g. This is the non-negotiable deliverable. | Student B + Anna | Complete descriptive results, all figures/tables | |
| 5–8 | **Track 2: Algorithmic decomposition.** XGBoost models (with/without sport). SHAP. Gender interaction analysis. | Student C + Anna | SHAP plots, model tables, decomposition narrative | |
| 7–9 | **Track 3: Within-basketball gap estimation.** OLS + sensemakr. DML only if total matched N>500. | Anna + Student C | Coefficient estimates, robustness values, power statement | |
| 9–10 | **Integration.** Connect all tracks. Reconcile contradictions. Policy discussion. | Anna + all | Results narrative | |
| 10–12 | **Paper writing.** Target: 20–30 pages. | Anna (primary) | Complete manuscript | |

**Scoping discipline:** Track 1 is the non-negotiable deliverable. If Track 2 takes longer than expected, Track 3 is cut first. Track 3 is effectively basketball-only and adds limited marginal value given N constraints. A paper with rigorous Track 1 + solid Track 2 is publishable at Sloan, JQAS, or as an SSRN preprint.

**Mentorship need:** The team needs access to someone with applied econometrics / ML experience. If Anna does not have this background, the project should identify a faculty advisor before Week 1.

---

## Fallback Design (If On3 Scraping Fails — Scenario C)

**Research question:** At the school level, what predicts the gender gap in athletic investment — and how does this institutional structure map onto known NIL inequality?

**Data:** EADA 2003–2024 (~350 D1 schools × 21 years) + Opendorse aggregate reports.

**Method:**
- Descriptive: gender gap in revenues, expenses, coaching salaries by sport and conference, with time trends
- Predictive: XGBoost on school-level features predicting revenue gap, with SHAP
- Connect to NIL: show that institutional revenue gaps (EADA) mirror NIL compensation gaps (Opendorse)

Publishable at JQAS or International Journal of Sport Finance.

---

## Team Allocation

- **Student A:** Web scraping / On3+ data extraction, caching, documentation
- **Student B:** EADA processing, data merging, Track 1 descriptive analysis and visualization
- **Student C:** Track 2 ML modeling (XGBoost, SHAP), model evaluation
- **Anna:** Research design, theoretical framing, Track 3 regression (OLS + sensemakr), paper writing, quality control

---

## Publication Targets

| Target | Fit | Realistic? |
|---|---|---|
| **SSRN / arXiv preprint** | Immediate visibility | ✅ Submit Week 12 |
| **MIT Sloan Sports Analytics Conference** | Perfect for descriptive + ML sports analysis | ✅ Strong fit — submission ~October |
| **Journal of Quantitative Analysis in Sports** | Welcomes ML, shorter turnaround | ✅ Realistic |
| **International Journal of Sport Finance** | Economics angle | ✅ Realistic |
| **Applied Economics Letters** | Short-format, fast turnaround | ✅ Condense Track 1 |
| **Journal of Sports Economics** | Top field journal, wants causal ID | ⚠️ Stretch — OLS+sensemakr at N≤300 is below JSE's identification standards |
| **Big Data & Society** or **New Media & Society** | Algorithmic decomposition framing | ✅ Novel — On3 as algorithmic system to study |

---

## Risks, Unknowns, and Honest Limitations

### Technical Risks

| Risk | Severity | Likelihood | Mitigation |
|---|---|---|---|
| **On3 blocks scraping** | HIGH | MEDIUM-HIGH | Rate limiting. On3+ subscription (~$300/yr). Data partnership request. EADA fallback. |
| **Roster Value / NIL Value split not accessible** | HIGH | HIGH (unless On3+ or partnership) | Week 0 probe. Design works under Scenario B (TPV total as DV, Opendorse for collective/commercial distinction). |
| **$100K floor excludes most women athletes** | HIGH | CERTAIN | Acknowledged. Selection-rate analysis (Track 1e) quantifies the exclusion. Lower bound on true gap. |
| **Basketball matched-sample N too small for regression** | MEDIUM | MEDIUM | Go/no-go gate. Power analysis reported. Null results interpreted as "underpowered," not "no gap." |
| **EADA → On3 merge imprecise** | MEDIUM | CERTAIN | Merge by school name. Use school-level variables as controls, not primary features. Acknowledge ecological inference. |
| **On3 algorithm changes mid-project** | LOW | LOW | Cache all data with timestamps. |

### Methodological Risks

| Risk | Impact | Mitigation |
|---|---|---|
| **DV circularity** | SHAP partly recovers On3 engineering | Frame as algorithmic decomposition, not market study. Value is gender interaction, not overall feature importance. |
| **Content labor ratio Simpson's Paradox** | Aggregate ratio confounded by sport composition | Compute within-sport where Opendorse data permits. Prominent caveat on aggregate ratio. |
| **Sport as proxy for gender in SHAP** | Including sport absorbs gender signal; excluding it creates OVB | Run both, interpret both, label clearly. |
| **Small-sample regression bias (Track 3)** | Wide CIs, unreliable points | sensemakr robustness values. Power analysis. Report MDE. |
| **Common support violations** | Men's and women's basketball are economically distinct | Plot propensity scores. Report overlap. If poor, report as finding. |

### Risks We Cannot Mitigate

| Risk | Why Unavoidable |
|---|---|
| **On3 data ≠ market reality** | "NIL values are based more on perception than reality" (Rodriguez, "The NIL Illusion," *CTRL.FORM Substack*, April 2025). No individual-level actual deal data exists. |
| **Truncation on DV ($100K floor)** | No credible Heckman correction. Measured gap is a lower bound. |
| **Temporal instability** | Market restructuring underway (House settlement, Clark effect, revenue sharing). Snapshot, not steady state. |
| **Cannot identify discrimination** | No observational study with this data can distinguish bias from omitted variables. Unexplained gap is upper bound on bias. |
| **Most actionable policy channel (negotiation/expectation asymmetry) is unobservable** | Testing MacKeigan's (2023) mechanism requires individual deal data we cannot access. |
| **Opendorse ↔ On3 component mapping is an assumption** | The collective/Roster Value and commercial/NIL Value parallel is conceptually motivated but empirically unvalidated. |

---

## Key References

### NIL Market and Gender Equity
- AP News. "One year of NIL: How much have athletes made?" July 2022. "Remove football and women flip it to 52.8% vs. 47.2% for men." "When it comes to total NIL activities, Opendorse says football (29.3%) is the leader, then baseball (8%), men's basketball (7.6%), women's track and field (5.6%) and women's volleyball (5.5%)."
- Sportico. "Women's College Sports Are Breaking Records. Do NIL Collectives Care?" 2023. "Data from Opendorse, a national NIL marketing platform, found that over 77% of all NIL funding went to male athletes. Even after subtracting football, that figure was still nearly 60%."
- Opendorse. "NIL at 3: The Annual Opendorse Report." 2024. "$250 million in real NIL transactions" from "150,000+ athlete users." "NIL collectives continue to shape over 80% of the total NIL market." "In the commercial segment, Women's Basketball is in the number two spot for total compensation, second only behind Football." "<3.5% of all Collective compensation goes to females." Per-athlete top-25 expected annual earnings: "$349K in men's basketball, $294K in football, $88,975 in women's basketball, $47,710 in baseball, $8,545 in softball, and $5,868 in women's volleyball" (summarized by The Student-Athlete Advisors, 2024). "Annual expected earnings for... Women's Basketball (+85%) are all on the rise YoY."
- Opendorse / The GIST. 2025. "Women athletes submitted 32.2% of the 500K NIL deal applications."
- MacKeigan, L. SSRN 4554235, 2023. "Women's sport competitors expect, and will opt out of a deal, at half the compensation rate that men's sport competitors will." "The total following that an athlete in women's sports has been significantly influential in their compensation estimations, while it is not influential for athletes in men's sports." "BIPOC athletes have 1.7 times higher compensation expectations and 1.8 times higher opt-out thresholds than white athletes."
- LeRoy, M. H. *U. Cincinnati Law Review*, 93(4), 979, 2025. "Men's basketball players in major NCAA conferences were paid an average of $171,272 in 2024, compared to $16,222 for women."
- Rogers, M. Indiana University CARI Blog, 2023. "73.21% of the NIL deals were made with males and 26.79% with females." "Both male and female NIL frequency in collectives had a strong, positive correlation with media impact (0.6824, 0.6095)."
- Shuler, K. & Steinfeldt, J. A. *Journal of Sports and Games*, 7(2), 6–16, 2025. "Without intentional structural reforms in college sport, NIL could further exacerbate existing gender disparities."
- Sailofsky, D. *International Review for the Sociology of Sport*, 2025. "NIL collective arrangements — the least labour-intensive type of NIL labour — also disproportionately benefit men's athletes."
- Rodriguez, D. *CTRL.FORM Substack*, April 2025. "NIL values are based more on perception than reality."
- "Data and Demographics Driving NIL Deals." University at Buffalo School of Law, 2024. "Twenty-five (25) of [the On3 Top 100] are collegiate basketball players, four (4) of which are women and twenty-one (21) men."

### Caitlin Clark Effect and Women's Sports Viewership
- NBC News. "Caitlin Clark's impact on the WNBA could eclipse 'a billion dollars.'" May 2025. Ryan Brewer (Indiana University): "responsible for a staggering 26.5% of all WNBA economic activity last season." "If things just go as they were... I'm looking at $875 [million]... I could easily see that eclipsing a billion dollars."
- WSC Sports. "Beyond the Caitlin Clark Effect." 2025. "Fever games averaged 1.18 million viewers, compared to 394,000 for all other games."
- Nielsen, 2024. Women's championship drew record-breaking 18.9 million viewers.

### On3 NIL Valuation Methodology
- Terry, S. "On3 NIL Valuation Inputs Change: Introducing Total Player Value." On3, December 10, 2024.
- On3. "About On3 NIL Valuation and Roster Value." On3.com. "Roster Value is the primary factor influencing most athletes' NIL Valuation. It is determined mainly by collected deal data within the college marketplace." "NIL Value... measures an athlete's market value in terms of licensing and sponsorship." "NIL Valuations and Roster Values that exceed $1.5 million are available for public viewing. Valuations below $1.5 million require an On3+ subscription to access. Additionally, any NIL Valuation or Roster Value under $100,000 per athlete is not recorded or displayed."
- Wikipedia. "On3.com." 2025. "Originally based on a 'Performance, Influence, and Exposure' algorithm, the methodology was overhauled in December 2024 to a 'Total Player Value' (TPV) model."
- Bitget. "How to Track NIL Values on On3 in Real-Time." 2025. "Social media presence accounts for approximately 30-40%... Athletic performance contributes another 25-35%... Team success and media exposure add 15-20%." (Note: may describe pre-December 2024 methodology.)
- On3NIL FAQ (OnFocus News, 2023). "The On3 NIL Valuation is publicly available. Performance, Influence, and Exposure ratings along with the athlete's personal Brand Value Index and Roster Value Index are available only to the athlete in the 'Athlete Verified' private dashboard."

### House Settlement and Data Access
- Ropes & Gray. June 2025. "All NIL transactions with a total value of $600 or more must be reported."
- Yahoo Sports / Sports Business Journal. May 2025. CSC CEO Bryan Seeley stated the clearinghouse was "struggling."
- Georgetown Law Tech Review. 2024. "Absent a federal mandate, colleges would likely resist transparency."

### Causal Methodology
- Chernozhukov, V. et al. *The Econometrics Journal*, 21(1), C1–C68, 2018.
- Bach, P. et al. *Journal of Statistical Software*, 108, 2024.
- Ahrens, A. et al. *Journal of Applied Econometrics*, 2025; arXiv:2401.01645. "DDML with stacking is more robust to partially unknown functional forms."

### Sensitivity Analysis
- Cinelli, C. & Hazlett, C. *JRSS-B*, 82(1), 39–67, 2020. "The robustness value describes the minimum strength that unobserved confounders need to have to overturn a research conclusion."
- Diegert, P. et al. arXiv:2208.00552v4, 2024. "Any time [Oster's delta] is large... a much smaller value reverses the sign."

### SHAP and ML Explainability
- arXiv:2506.10179, 2025. "High feature importance or SHAP values reflect predictive power rather than mechanistic influence."
- arXiv:2305.02012v3. "The Shapley method suffers from inclusion of unrealistic data instances when features are correlated."

### DML Finite-Sample Performance
- arXiv:2403.14385. "Recommend G-computation for n<100, DML for n>500."
- arXiv:2512.07083. "In low-overlap designs, coverage collapses to 39.8% at n=2000."

---

## What Changed from v4 and Why

| v4 | v5 | Reason |
|---|---|---|
| Assumed Roster Value / NIL Value split was scrapable | Documented the $1.5M paywall and $100K recording floor from On3's own documentation. Designed three data scenarios (A, B, C) so the project survives any access outcome. | On3 states: "Valuations below $1.5 million require an On3+ subscription." The core analytical innovation must survive data access failure. |
| Called Track 2 an "algorithmic audit," cited Bartlett et al. (2022) and Raghavan et al. (2020) | Reframed as "algorithmic decomposition." Dropped audit-literature citations because we cannot meet their methodological standards (paired testing, training-data access, sufficient common support). | True algorithmic audits require testing conditions we cannot create. Calling this an "audit" overstates the methodology. |
| Content labor ratio computed from aggregate data, with limitation noted | Added explicit Simpson's Paradox analysis. Primary analysis is within-sport (using Opendorse sport-level data where available); aggregate ratio carries prominent composition caveat. | A reviewer will immediately flag that between-sport composition can drive the aggregate ratio even if within-sport ratios are equal. |
| No mention of Caitlin Clark or superstar effects | Added Clark effect to prior work, temporal validity, and pre-registration (H6). Added superstar sensitivity analysis: quantile decomposition with and without top-5 women's basketball athletes. | Clark's economic impact is estimated at up to $1B (Brewer, 2025). A handful of superstars may dominate the women's distribution, making "within-basketball gap" misleading without sensitivity analysis. |
| No power analysis for Track 3 | Added power analysis: at N=250, MDE ≈ d=0.25 (~25-30% difference). Null results reported as "underpowered," not "no gap." | Without power analysis, a null result is uninterpretable. Reviewers will require this. |
| Efficiency counter-argument #2 cited women's basketball total commercial compensation | Corrected: women's basketball leads on total sport-level volume but trails on per-athlete value ($349K men's vs. $89K women's). Both numbers now reported. | Total vs. per-capita is an important distinction. The efficiency counter-argument is weaker at the per-capita level and stronger at the total level. Must present both honestly. |
| Engagement rates not discussed | Added engagement rates as missing mediator in DAG discussion. Check availability from On3. If missing, noted bias direction: omitting engagement likely biases gender coefficient downward. | On3's algorithm incorporates engagement. Women likely have higher engagement per follower. Omitting it understates women's social capital. |
| "Realized Deals (Unobserved)" in DAG but not discussed | Added explicit paragraph: the negotiation/expectation channel is the most actionable policy lever but is unobservable with this data. On3's Roster Value may already bake in MacKeigan's expectation gap. | The DAG honestly shows the most important outcome is one we can't study. The paper should say so. |
| Sample sizes estimated at 50–150 for non-revenue sports | Revised downward based on $100K floor: women's volleyball 10–40, softball 10–40, women's soccer/swimming/track likely <10. Track 3 framed as basketball-only. | Opendorse top-25 estimates: $5,868 for women's volleyball, $8,545 for softball. Athletes in these sports are overwhelmingly below On3's $100K recording threshold. |
| Opendorse ↔ On3 mapping assumed without caveat | Stated explicitly as an assumption. Added indirect validation: compare Roster Value and NIL Value gaps to Opendorse collective and commercial gaps. If they diverge, the mapping fails — which is itself a finding. | The conceptual parallel is appealing but empirically untested. It must be an explicit assumption, not a silent one. |
| Selection-rate analysis described as "% appearing in On3's database" | Redefined as "% with On3 valuation ≥ $100K recording floor." Acknowledged this measures algorithmic coverage, not market participation. | Athletes below $100K might have NIL activity on other platforms. On3's selection is partly an artifact of its own reporting threshold. |
| Week 0 data probe not included | Added mandatory pre-proposal data probe: check On3 coverage, investigate On3+ subscription, send partnership request. Takes half a day. Determines Scenario A/B/C before committing. | The proposal should not be finalized without knowing what data is actually available. A 2-hour probe prevents 12 weeks of wasted effort. |
