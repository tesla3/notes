# Decomposing the Gender Gap in College NIL: Descriptive Accounting and Algorithmic Analysis of On3 Valuations

## Summary

The NCAA NIL market ($1.67B projected for 2024–25) exhibits a stark gender gap: NIL collectives — 82% of total compensation — send less than 3.5% to women, while the commercial market tells a different story (women's basketball ranks #2 in total brand compensation, ahead of men's basketball). The aggregate gap conflates governance decisions with market signals, but no study has systematically decomposed it.

We provide the first rigorous decomposition using On3's Total Player Value (TPV) — the industry-leading algorithmic valuation — merged with NCAA institutional data (EADA) and Opendorse market reports. The work proceeds in three tracks: (1) descriptive accounting of the gap across every meaningful cut — with/without football, by sport, quantile, conference, and a selection-rate denominator that asks what fraction of D1 athletes even appear in On3's database; (2) algorithmic decomposition via XGBoost + SHAP to reverse-engineer On3's algorithm and test whether gender shifts feature weights; (3) within-basketball gap estimation — the only sport with sufficient male/female coverage — via OLS with sensitivity analysis. We study algorithmic valuations, not actual compensation; we describe and decompose, not identify causation or discrimination.

## Research Questions

1. **How large is the gender gap in On3 NIL Valuations, and what is its structure?**
   Football's mechanical role, within-sport vs. between-sport composition, distributional shape by quantile, superstar concentration effects, and the selection-rate denominator (what share of D1 athletes even clear On3's $100K recording threshold?).

2. **Does On3's algorithm treat gender as an interaction — weighting the same observable inputs differently for men and women?**
   Algorithmic decomposition: feature importance, gender × follower interactions, with and without sport as a feature to separate within-sport from total effects.

3. **Within basketball, how much of the gender gap is explained by observables?**
   The only sport with sufficient On3 coverage on both sides. OLS with two specifications (full controls vs. minimal) to isolate how much operates through the followers/media channel. Sensitivity analysis for unobserved confounders.

## Data & Constraints

| Source | Provides | Access |
|---|---|---|
| **On3 NIL Rankings** | Per-athlete TPV; sport, school, conference, follower counts | Public scraping (≥$100K floor) |
| **NCAA EADA** | School-level revenues, expenses, participation counts by sport/gender | Free CSV |
| **Opendorse Reports** | Aggregate compensation by sport/gender; collective vs. commercial split; activity counts | Public PDFs |
| **Sports-Reference** | Team records, individual stats | Public |

**Critical constraint:** On3's TPV combines Roster Value (collective-driven) and NIL Value (brand-driven) into one number. The component split is publicly visible only for athletes >$1.5M — an overwhelmingly male elite. We analyze TPV total as the primary DV and draw the collective/commercial distinction from Opendorse aggregate data, not On3 component data.

**Sample reality:** On3's $100K floor excludes most women in non-revenue sports. Expected: ~500–1,000 football, ~200–400 men's basketball, ~50–150 women's basketball, ~20–50 women's gymnastics, <40 each for other women's sports. Track 3 is basketball-only by necessity.

## Approach

**Track 1 — Descriptive Accounting** *(primary, non-negotiable)*

No causal assumptions. Seven analyses: (a) aggregate gap ± football; (b) within-sport gaps in basketball, soccer, volleyball, swimming; (c) distributional analysis by quantile with overlapping density plots; (d) superstar sensitivity — rerun dropping top-5 women's basketball athletes; (e) gap by conference tier (Power 4 / Group of 5 / other); (f) selection-rate denominator — % of D1 athletes with On3 valuation ≥$100K, by gender and sport, with and without football in the male denominator; (g) content labor ratio from Opendorse — within-sport where data permits, aggregate with Simpson's Paradox caveat where not. See *Appendix C* for detail.

**Track 2 — Algorithmic Decomposition** *(secondary)*

Reverse-engineer On3's black-box algorithm from published outputs. Not an "audit" — we lack paired testing and training-data access. XGBoost with 5-fold CV (stratified by sport and gender), evaluated on held-out test set. SHAP for feature importance and gender interaction analysis. Key design choice: run with and without sport as feature — sport absorbs most gender signal, so both models are needed to separate within-sport from total effects. See *Appendix C* for features and caveats.

**Track 3 — Within-Basketball Gap Estimation** *(conditional)*

Basketball only. Go/no-go at Week 3 based on sample size: N≥300 → OLS + sensemakr; 100–300 → exploratory; <100 → descriptive only. Two specs: full controls (followers, win%, conference, school revenue, recruit ranking, class year) vs. minimal (class year, conference). The difference reveals how much operates through the followers/media channel. At N=250, MDE ≈ d=0.25 (~25–30% difference). Null results reported as "underpowered," not "no gap." See *Appendix C* for specification and power analysis.

**Scoping rule:** Track 1 ships no matter what. If Track 2 runs long, Track 3 is cut. Track 1 + Track 2 is publishable.

## Pre-Registered Hypotheses (OSF, before analysis)

| # | Hypothesis | Would challenge our framing if… |
|---|---|---|
| H1 | Excluding football reduces male share of total TPV to 55–65% (from ~80%+) | Change <15pp → gap is pervasive, not football-driven |
| H2 | Men's mean TPV exceeds women's within basketball by 2:1 to 5:1 | >8:1 → within-sport gap as large as cross-sport; <1.5:1 → algorithm values women comparably |
| H3 | Women's aggregate content labor ratio >1.0 (more activities per dollar) | ≈1.0 → no differential labor burden |
| H4 | Smaller % of female D1 athletes have On3 valuations ≥$100K than males, even excluding football | Female rate ≥ male rate → gap is entirely football-driven |
| H5 | Removing top-5 women's basketball athletes reduces women's basketball mean TPV by ≥30% | <10% → distribution is broad, not superstar-driven |

## Timeline (12 Weeks)

| Week | Task | Gate |
|---|---|---|
| 0 | Data probe: On3 coverage by sport × gender, scraping feasibility | Confirm viability |
| 1–3 | Data acquisition, cleaning, On3 + EADA merge, basketball sample | Wk 3: basketball N → Track 3 go/no-go |
| 3–6 | **Track 1: Descriptive accounting** | Core deliverable |
| 5–8 | **Track 2: Algorithmic decomposition** | |
| 7–9 | **Track 3: Within-basketball estimation** (if viable) | |
| 9–12 | Integration, writing, SSRN submission | |

## Scope Boundaries

| What we do | What we do not |
|---|---|
| Study On3 algorithmic valuations (TPV) | Observe actual deal values or compensation |
| Describe distributions, reverse-engineer an algorithm | Identify discrimination or establish causation |
| Document a transitional snapshot (post-House, mid-Clark-era, post-algorithm-change) | Claim steady-state findings |
| Report unexplained gaps as *upper bound* on bias | Assert the unexplained gap *is* bias |
| Use Opendorse aggregates to contextualize collective vs. commercial dynamics | Directly decompose On3 TPV into collective and commercial components |

---

## Appendix A: PI Background

Anna was a D1 Women's Rower at Cornell (2020–2024), retired due to injury. She lived the invisible-athlete experience in a non-revenue sport where NIL dollars barely exist. Her experience illustrates the sport-structure confound at the paper's heart: her invisibility was not because she was a woman, but because rowing is a non-revenue sport. Men's rowing gets almost no NIL either. Separating "gender effect" from "sport-revenue effect" is the core intellectual challenge.

## Appendix B: Prior Work & Contribution

### What is known

**Aggregate gap:** 77%+ of NIL funding goes to men (Sportico, 2023). Excluding football, women briefly led in Year 1 (52.8%, AP News 2022) but men reclaimed ~60% by Year 2. Collectives (82% of total) send <3.5% to women; commercial market is more balanced — women's basketball #2 behind football at sport-total level (Opendorse, 2024).

**Per-athlete vs. total:** Women's basketball leads men's in total commercial volume (more athletes doing deals) but trails per-athlete ($89K vs. $349K in top-25; Opendorse, 2024). This distinction is critical: total ≠ per-capita.

**Expectations and behavior:** Women expect and opt out at half the compensation rate of men (MacKeigan, 2023). Social media following matters for women's compensation but not men's. BIPOC athletes have 1.7× higher expectations.

**Structural:** Schools coordinate with collectives to channel money to men (LeRoy, 2025). Collective arrangements — least labor-intensive NIL labor — disproportionately benefit men (Sailofsky, 2025). Media impact correlates strongly with collective NIL frequency (Rogers, 2023).

**The Clark effect:** 2024 women's championship drew 18.9M viewers. Women's basketball top-25 earnings up 85% YoY. Clark's economic impact estimated at $875M–$1B (Brewer via NBC News, 2025). This is reshaping the market *during our study period*.

### What we add

| Known | We add |
|---|---|
| Football drives aggregate gap | Precisely how much in On3 algorithmic valuations, by quantile |
| Women get <3.5% of collective money | Whether this maps onto On3 TPV distributions |
| Women's basketball leads commercially (sport-total) | Whether On3's algorithm reflects or contradicts this |
| Women do ~53% of activities, get <40% of compensation | Whether the content labor ratio holds within sport (Simpson's Paradox test) |
| On3 Top 100 demographics documented | The denominator: what % of D1 athletes clear On3's $100K floor? |
| Clark effect reshaping women's basketball | How superstar concentration distorts the women's distribution |

## Appendix C: Detailed Methodology

### Track 1 — Descriptive Accounting

*1a. Aggregate gap ± football:* Mean, median, ratio of means for TPV by gender. Recompute excluding football — how much does removal close the gap?

*1b. Within-sport:* Gender gap within each sport with both genders in On3 (basketball primary; soccer, volleyball, swimming if coverage exists). Basketball deep-dive: does On3 reflect the commercial market's revealed preference for women's basketball?

*1c. Distributional analysis:* Gender gap by quantile (top 50, 100, 500, 1000). Overlapping density plots of log(TPV) by gender within basketball.

*1d. Superstar sensitivity:* Rerun quantile analysis dropping top-5 women's basketball athletes. If removing 5 athletes dramatically changes the women's distribution, the "women's basketball story" is a superstar story.

*1e. Conference tiers:* Gap by Power 4, Group of 5, other D1.

*1f. Selection-rate denominator:* EADA participation counts provide the universe (~110K female, ~105K male D1 athletes). Compute % with On3 valuation ≥$100K by gender and sport. Repeat excluding football from male denominator. This measures On3's algorithmic coverage, not market participation — athletes below $100K may have NIL activity elsewhere.

*1g. Content labor ratio:* (Women's share of NIL activities) ÷ (women's share of NIL compensation), from Opendorse. Within-sport where breakdowns exist (AP News 2022 provides some sport-level activity data). Aggregate with prominent Simpson's Paradox caveat where not — see Appendix D for detail.

### Track 2 — Algorithmic Decomposition

**Features:**
- *Athlete:* sport (categorical), position, class year, Instagram/TikTok/X followers, recruit rating, engagement (if available from On3 profiles)
- *Team:* win%, conference, national ranking, postseason appearance
- *School:* EADA total athletic revenue, conference tier, media market
- *Treatment:* gender (binary)

**Models:** OLS baseline → XGBoost (5-fold CV stratified by sport and gender, 80/20 train/test split) → R², MAE, RMSE on held-out set.

**Explainability:** SHAP values for global feature importance. SHAP dependence plots for gender × followers, gender × sport. Key diagnostic: SHAP gender interaction values — does the SHAP contribution of followers differ by gender?

**Sport-gender collinearity:** Sport is near-perfect proxy for gender. Two model runs:
- *With sport:* Gender SHAP = within-sport algorithmic effect (small by construction)
- *Without sport:* Gender SHAP = total effect including composition (large, uninformative about within-sport)

**Caveats:** SHAP ≠ causation (arXiv:2506.10179). SHAP misattributes with correlated features (arXiv:2305.02012v3). Circularity: we predict On3 outputs using likely On3 inputs; high R² is expected. Value is in the gender interaction, not overall fit.

### Track 3 — Within-Basketball Gap Estimation

**Go/no-go (end of Week 3):**

| Basketball N | Scope |
|---|---|
| ≥300 (≥100 per gender) | OLS + sensemakr sensitivity analysis |
| 100–300 | OLS + sensemakr; report as exploratory with wide CIs |
| <100 | Descriptive only (extend Track 1) |

**Specification:**
```
log(TPV_i) = α + θ·Female_i + X'β + ε_i
```

- **Spec A (full controls):** log(followers), team win%, conference, school EADA revenue, recruit ranking, class year, engagement (if available). Estimates residual gap after On3's known inputs.
- **Spec B (minimal controls):** class year, conference only. Estimates total within-basketball gap.

Difference (B − A) reveals how much operates through the followers/media channel.

**Sensitivity:** sensemakr robustness values (Cinelli & Hazlett, 2020). Benchmarks: partial R² of observable controls. Diegert, Masten & Poirier (2024) sign-change breakdown.

**Power:** At N=250, MDE ≈ d=0.25. At N=150, MDE ≈ d=0.35. If true within-basketball gap is 15–20%, study is underpowered. Null reported as "cannot detect effects smaller than X%."

## Appendix D: Analytical Considerations

### The Dependent Variable: On3 TPV

On3 overhauled its methodology in December 2024 from "Performance, Influence, and Exposure" to Total Player Value, combining Roster Value ("determined mainly by collected deal data within the college marketplace") and NIL Value ("measures an athlete's market value in terms of licensing and sponsorship"). Under our data access, we observe TPV total for athletes ≥$100K. The Roster/NIL split is visible only for >$1.5M.

**Opendorse ↔ On3 mapping assumption:** On3's Roster Value likely reflects collective compensation; NIL Value likely reflects commercial. This parallel is conceptually motivated but empirically unvalidated. We state it as an assumption and note when findings are consistent or inconsistent with it.

**Circularity:** We reverse-engineer On3's algorithm using features that are likely its inputs. High R² is expected and uninformative about the market. The analytical value lies in gender interactions, not overall model performance.

### Content Labor Ratio & Simpson's Paradox

The ratio (women's share of activities ÷ women's share of compensation) is vulnerable to composition effects. If women are concentrated in lower-paying sports with high activity volume but low deal value, the aggregate ratio shows "more work per dollar" even if within every sport the ratio is 1:1. A softball player doing 20 posts for $500 (40 activities/$1K) vs. a football player doing 2 posts for $50K (0.04/$1K) drives the aggregate without any within-sport disparity. Within-sport ratios are the meaningful quantity; aggregate is reported with this caveat.

### Selection Bias

On3's $100K floor creates hard left-censoring — truncation on the DV. This is gendered: most women in non-revenue sports fall below $100K. Any measured gap is a **lower bound** on the true gap among all D1 athletes. No credible Heckman correction (no valid exclusion restriction). We acknowledge this and report the selection-rate denominator prominently.

### Causal Structure (DAG)

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
    ┌──────────────────────────────┐
    │     On3 Total Player Value   │
    │           (TPV)              │
    └──────────────────────────────┘
```

**Key implications:**
1. **Two pathways collapse into one observable.** TPV conflates governance (collective) and market (brand) channels. We cannot separate them with On3 data alone.
2. **Sport selection is a mediator.** Gender → sport → revenue → NIL. Controlling for sport blocks this pathway intentionally; Track 3 labels this a within-sport estimate.
3. **Social media followers are mediator and feedback variable.** Higher TPV → visibility → followers → higher TPV. Within-sport estimates conditional on followers are "residual-after-mediator-control," not clean causal effects.
4. **Realized deals are unobservable.** The most actionable policy lever (negotiation/expectation asymmetry per MacKeigan 2023) is untestable with this data.
5. **Engagement rates are missing.** Women likely have higher engagement per follower. Omitting engagement biases the gender coefficient downward (makes measured gap appear smaller).

### Theoretical Framework

**Why expect a gap?** Three channels: (1) *Demand-side:* men's football/basketball generate vastly more revenue; if NIL reflects ROI, differential pricing may be efficient factor-market pricing of a sport-revenue gap that correlates with gender. (2) *Supply-side:* collective governance channels money through booster preferences (LeRoy, 2025); agent asymmetry favors men; media exposure feedback loop transmits historical under-investment. (3) *Sociocultural:* women's NIL success often conditional on performing femininity — more labor-intensive path (Sailofsky, 2025).

**The efficiency null hypothesis.** Four complications: (1) Collectives (~82%) aren't markets — donor-preference allocation, not competitive bidding. (2) Women's basketball leads commercial volume but trails per-athlete value — consistent with either efficient pricing or more work for less return. (3) Media exposure is endogenous — the Clark effect shows comparable coverage yields comparable viewership. (4) Expectation gaps (MacKeigan 2023: women expect half) reflect information asymmetry, not efficient pricing.

**Our position:** We decompose; we do not adjudicate.

### Omitted Variable Bias

| Omitted Variable | Bias direction on gender coefficient |
|---|---|
| Actual deal values (On3 ≠ real compensation) | Unknown |
| Agent/representation quality | Upward (true gap may be smaller) |
| TV viewership/ratings | Upward |
| Engagement rates | Downward (measured gap appears smaller) |
| Race/ethnicity (individual-level) | Complex — Black males overrepresented in revenue sports |
| Negotiation expectations | Upward (gap includes learned under-valuation) |

Any unexplained gap is an **upper bound** on algorithmic or market bias.

### Race × Gender

Black male athletes are overrepresented in football and men's basketball. Any "gender gap" confounds gender with racial demographics. We cannot ethically code individual race from public profiles. We use aggregate NCAA demographics data by sport and discuss the intersection in limitations.

### Temporal Context

| Date | Event |
|---|---|
| July 2021 | NIL legalized |
| 2022–2023 | Collective boom (82% via collectives; women <3.5%) |
| 2023–2024 | Caitlin Clark effect |
| December 2024 | On3 TPV algorithm overhaul |
| June 2025 | House settlement / revenue sharing |
| **Summer 2025** | **Our data collection** |

We capture a transitional snapshot. Pre- and post-December 2024 are separate series; we do not claim continuity across the algorithm break.

## Appendix E: Operations

### Team

| Role | Responsibility |
|---|---|
| Student A | Web scraping, data pipeline |
| Student B | EADA processing, Track 1 analysis |
| Student C | Track 2 ML modeling (XGBoost, SHAP) |
| Anna | Research design, Track 3 regression, paper writing, QC |

**Need before Week 1:** Faculty advisor with applied econometrics / ML experience.

### Publication Targets

| Target | Fit |
|---|---|
| SSRN preprint | Submit Week 12 |
| MIT Sloan Sports Analytics Conference | Strong (submission ~October) |
| Journal of Quantitative Analysis in Sports | Welcomes ML |
| Big Data & Society | Algorithmic-systems angle |
| Applied Economics Letters | Condensed Track 1 |

### Risks

| Risk | Severity | Mitigation |
|---|---|---|
| On3 blocks scraping | HIGH | Rate limiting; EADA-only fallback possible but changes the paper |
| $100K floor excludes most women | HIGH (certain) | Selection-rate analysis quantifies; measured gap = lower bound |
| Basketball N too small for Track 3 | MEDIUM | Go/no-go gate; power analysis; null = "underpowered" |
| SHAP recovers On3 engineering (circularity) | MEDIUM | Frame as decomposition; value is gender interaction |
| On3 ≠ market reality | HIGH (certain) | Stated throughout: "algorithmic valuations, not compensation" |

## Appendix F: References

**NIL Market:** AP News (2022); Sportico (2023); Opendorse "NIL at 3" (2024); MacKeigan (2023, SSRN 4554235); LeRoy (2025, *U. Cincinnati Law Review* 93(4)); Rogers (2023); Sailofsky (2025, *IRSS*); Shuler & Steinfeldt (2025, *J. Sports and Games* 7(2)); Rodriguez (2025, *CTRL.FORM*).

**Clark Effect:** NBC News (2025); WSC Sports (2025); Nielsen (2024).

**On3 Methodology:** Terry (2024, On3); On3 "About NIL Valuation"; Wikipedia "On3.com" (2025); Bitget (2025).

**Methods:** Cinelli & Hazlett (2020, *JRSS-B*); Diegert, Masten & Poirier (2024); arXiv:2506.10179 (2025); arXiv:2305.02012v3.
