// Professional proposal layout
#set document(
  title: "Decomposing the Gender Gap in College NIL",
  author: "Anna et al.",
)

#set page(
  paper: "us-letter",
  margin: (top: 0.75in, bottom: 0.7in, left: 0.85in, right: 0.85in),
  numbering: "1",
  number-align: center,
  header: context {
    if counter(page).get().first() > 1 [
      #set text(8pt, fill: luma(120))
      #h(1fr) Decomposing the Gender Gap in College NIL
    ]
  },
)

#set text(font: "Palatino", size: 10pt, lang: "en")
#set par(justify: true, leading: 0.58em)
#set block(spacing: 0.7em)

#show heading.where(level: 1): set text(13pt, weight: "bold")
#show heading.where(level: 2): set text(11pt, weight: "bold")
#show heading.where(level: 3): set text(10pt, weight: "bold", style: "italic")
#show heading.where(level: 1): it => { v(0.3em); it; v(0.1em) }
#show heading.where(level: 2): it => { v(0.25em); it; v(0.05em) }

#set table(
  stroke: none,
  inset: (x: 5pt, y: 3.5pt),
)
#show table: set text(9pt)

// Helper for compact horizontal rules within tables
#let hline = table.hline(stroke: 0.5pt)
#let hline-thick = table.hline(stroke: 0.8pt)

// ─── Title Block ───
#align(center)[
  #block(spacing: 0.4em)[
    #text(14.5pt, weight: "bold")[Decomposing the Gender Gap in College NIL:\ Descriptive Accounting and Algorithmic Analysis of On3 Valuations]
  ]
  #v(0.3em)
  #text(10pt, fill: luma(80))[Research Proposal · v6 · May 2025]
]

#v(0.4em)
#line(length: 100%, stroke: 0.5pt + luma(180))
#v(0.2em)

// ─── Summary ───
= Summary

The NCAA NIL market (\$1.67B projected for 2024–25) exhibits a stark gender gap: NIL collectives — 82% of total compensation — send less than 3.5% to women, while the commercial market tells a different story (women's basketball ranks \#2 in total brand compensation, ahead of men's basketball). The aggregate gap conflates governance decisions with market signals, but no study has systematically decomposed it.

We provide the first rigorous decomposition using On3's Total Player Value (TPV) — the industry-leading algorithmic valuation — merged with NCAA institutional data (EADA) and Opendorse market reports. The work proceeds in three tracks: *(1)* descriptive accounting of the gap across every meaningful cut — with/without football, by sport, quantile, conference, and a selection-rate denominator; *(2)* algorithmic decomposition via XGBoost + SHAP to reverse-engineer On3's algorithm and test whether gender shifts feature weights; *(3)* within-basketball gap estimation via OLS with sensitivity analysis. We study algorithmic valuations, not actual compensation; we describe and decompose, not identify causation or discrimination.

// ─── Research Questions ───
= Research Questions

+ *How large is the gender gap in On3 NIL Valuations, and what is its structure?*
  Football's mechanical role, within- vs. between-sport composition, distributional shape by quantile, superstar concentration, and the selection-rate denominator (what share of D1 athletes clear On3's \$100K recording threshold?).

+ *Does On3's algorithm treat gender as an interaction — weighting the same inputs differently for men and women?*
  Algorithmic decomposition: feature importance, gender × follower interactions, with and without sport as a feature to separate within-sport from total effects.

+ *Within basketball, how much of the gender gap is explained by observables?*
  The only sport with sufficient On3 coverage on both sides. OLS with two specifications (full controls vs. minimal) to isolate how much operates through the followers/media channel.

// ─── Data & Constraints ───
= Data & Constraints

#table(
  columns: (1.4fr, 2fr, 0.9fr),
  align: (left, left, left),
  hline-thick,
  table.header(
    [*Source*], [*Provides*], [*Access*],
  ),
  hline,
  [On3 NIL Rankings], [Per-athlete TPV; sport, school, conference, follower counts], [Public scrape (≥\$100K)],
  [NCAA EADA], [School-level revenues, expenses, participation counts], [Free CSV],
  [Opendorse Reports], [Aggregate compensation by sport/gender; collective vs. commercial], [Public PDFs],
  [Sports-Reference], [Team records, individual stats], [Public],
  hline-thick,
)

#v(0.15em)

*Critical constraint:* On3's TPV combines Roster Value (collective-driven) and NIL Value (brand-driven) into one number. The component split is publicly visible only for athletes >\$1.5M — an overwhelmingly male elite.

*Sample reality:* On3's \$100K floor excludes most women in non-revenue sports. Expected: ~500–1,000 football, ~200–400 men's basketball, ~50–150 women's basketball, \<40 each other women's sports. Track 3 is basketball-only by necessity.

// ─── Approach ───
= Approach

== Track 1 — Descriptive Accounting #h(0.5em) #text(weight: "regular", style: "italic", size: 9pt)[(primary, non-negotiable)]

No causal assumptions. Seven analyses:
#set enum(numbering: "(a)")
+ Aggregate gap ± football
+ Within-sport gaps in basketball, soccer, volleyball, swimming
+ Distributional analysis by quantile with overlapping density plots
+ Superstar sensitivity — rerun dropping top-5 women's basketball athletes
+ Gap by conference tier (Power 4 / Group of 5 / other)
+ Selection-rate denominator — % of D1 athletes with On3 valuation ≥\$100K, by gender and sport
+ Content labor ratio from Opendorse — within-sport where data permits, aggregate with Simpson's Paradox caveat where not

== Track 2 — Algorithmic Decomposition #h(0.5em) #text(weight: "regular", style: "italic", size: 9pt)[(secondary)]

Reverse-engineer On3's black-box algorithm from published outputs. XGBoost with 5-fold CV (stratified by sport and gender), evaluated on held-out test set. SHAP for feature importance and gender interaction analysis. Key design: run _with_ and _without_ sport as feature — sport absorbs most gender signal, so both models separate within-sport from total effects.

== Track 3 — Within-Basketball Gap Estimation #h(0.5em) #text(weight: "regular", style: "italic", size: 9pt)[(conditional)]

Basketball only. Go/no-go at Week 3 based on sample size (N≥300 → OLS + sensemakr; 100–300 → exploratory; \<100 → descriptive only). Two specifications:
- *Spec A (full controls):* log(followers), team win%, conference, school revenue, recruit ranking, class year
- *Spec B (minimal):* class year, conference only

Difference (B − A) reveals how much operates through the followers/media channel. At N=250, MDE ≈ d=0.25 (~25–30% difference). Null results reported as "underpowered," not "no gap."

*Scoping rule:* Track 1 ships no matter what. If Track 2 runs long, Track 3 is cut. Track 1 + Track 2 is publishable.

// ─── Pre-Registered Hypotheses ───
= Pre-Registered Hypotheses (OSF)

#table(
  columns: (auto, 2.2fr, 2fr),
  align: (center, left, left),
  hline-thick,
  table.header([\#], [*Hypothesis*], [*Would challenge framing if…*]),
  hline,
  [H1], [Excl. football reduces male TPV share to 55–65% (from ~80%+)], [Change \<15pp → gap pervasive, not football-driven],
  [H2], [Men's mean TPV > women's within basketball by 2:1–5:1], [>8:1 → within-sport gap as large as cross-sport],
  [H3], [Women's aggregate content labor ratio >1.0], [≈1.0 → no differential labor burden],
  [H4], [Smaller % female D1 athletes have On3 ≥\$100K, even excl. football], [Female ≥ male → gap entirely football-driven],
  [H5], [Removing top-5 WBB athletes reduces WBB mean TPV by ≥30%], [\<10% → distribution broad, not superstar-driven],
  hline-thick,
)

// ─── Timeline ───
= Timeline (12 Weeks)

#table(
  columns: (0.7fr, 2.5fr, 1.5fr),
  align: (center, left, left),
  hline-thick,
  table.header([*Week*], [*Task*], [*Gate*]),
  hline,
  [0], [Data probe: On3 coverage by sport × gender, scraping feasibility], [Confirm viability],
  [1–3], [Data acquisition, cleaning, On3 + EADA merge, basketball sample], [Wk 3: basketball N → Track 3 go/no-go],
  [3–6], [*Track 1: Descriptive accounting*], [Core deliverable],
  [5–8], [*Track 2: Algorithmic decomposition*], [],
  [7–9], [*Track 3: Within-basketball estimation* (if viable)], [],
  [9–12], [Integration, writing, SSRN submission], [],
  hline-thick,
)

// ─── Scope Boundaries ───
= Scope Boundaries

#table(
  columns: (1fr, 1fr),
  align: (left, left),
  hline-thick,
  table.header([*What we do*], [*What we do not*]),
  hline,
  [Study On3 algorithmic valuations (TPV)], [Observe actual deal values or compensation],
  [Describe distributions, reverse-engineer algorithm], [Identify discrimination or establish causation],
  [Document a transitional snapshot], [Claim steady-state findings],
  [Report unexplained gaps as _upper bound_ on bias], [Assert the unexplained gap _is_ bias],
  [Use Opendorse to contextualize collective vs. commercial], [Directly decompose On3 TPV into components],
  hline-thick,
)

#pagebreak()

// ─── Appendices ───
#text(13pt, weight: "bold")[Appendices]
#v(0.2em)

== A: PI Background

Anna was a D1 Women's Rower at Cornell (2020–2024), retired due to injury. Her experience illustrates the sport-structure confound at the paper's heart: her invisibility was not because she was a woman, but because rowing is a non-revenue sport. Men's rowing gets almost no NIL either. Separating "gender effect" from "sport-revenue effect" is the core intellectual challenge.

== B: Prior Work & Contribution

=== What is known

*Aggregate gap:* 77%+ of NIL funding goes to men (Sportico 2023). Excluding football, women briefly led Year 1 (52.8%, AP News 2022) but men reclaimed ~60% by Year 2. Collectives (82% of total) send \<3.5% to women; commercial market more balanced — women's basketball \#2 behind football (Opendorse 2024).

*Per-athlete vs. total:* Women's basketball leads men's in total commercial volume but trails per-athlete (\$89K vs. \$349K in top-25). Total ≠ per-capita.

*Expectations:* Women expect and opt out at half the compensation rate of men (MacKeigan 2023). Social media following matters for women's compensation but not men's.

*Structural:* Schools coordinate with collectives to channel money to men (LeRoy 2025). Collective arrangements disproportionately benefit men (Sailofsky 2025).

*Clark effect:* 2024 women's championship drew 18.9M viewers. Top-25 earnings up 85% YoY. Estimated impact: \$875M–\$1B (Brewer via NBC News 2025).

=== What we add

#table(
  columns: (1fr, 1fr),
  align: (left, left),
  hline-thick,
  table.header([*Known*], [*We add*]),
  hline,
  [Football drives aggregate gap], [Precisely how much in On3 valuations, by quantile],
  [Women get \<3.5% of collective money], [Whether this maps onto On3 TPV distributions],
  [WBB leads commercially (sport-total)], [Whether On3's algorithm reflects or contradicts this],
  [Women do ~53% of activities, get \<40% of compensation], [Within-sport content labor ratio (Simpson's Paradox test)],
  [On3 Top 100 demographics documented], [The denominator: what % of D1 athletes clear \$100K?],
  [Clark effect reshaping WBB], [How superstar concentration distorts distribution],
  hline-thick,
)

== C: Detailed Methodology

=== Track 1 — Descriptive Accounting

*(1a)* Mean, median, ratio of means for TPV by gender; recompute excluding football.
*(1b)* Within-sport gender gap (basketball primary; soccer, volleyball, swimming if coverage exists).
*(1c)* Gender gap by quantile (top 50, 100, 500, 1000); overlapping density plots of log(TPV).
*(1d)* Superstar sensitivity: rerun dropping top-5 WBB athletes.
*(1e)* Gap by Power 4, Group of 5, other D1.
*(1f)* Selection-rate denominator from EADA (~110K female, ~105K male D1 athletes).
*(1g)* Content labor ratio from Opendorse with Simpson's Paradox caveat.

=== Track 2 — Algorithmic Decomposition

*Features:* sport, position, class year, Instagram/TikTok/X followers, recruit rating, engagement; team win%, conference, ranking, postseason; EADA revenue, conference tier, media market; gender (binary).

*Models:* OLS baseline → XGBoost (5-fold CV, 80/20 split) → R², MAE, RMSE on held-out set.

*Explainability:* SHAP values for global importance. SHAP dependence plots for gender × followers, gender × sport. Key diagnostic: does SHAP contribution of followers differ by gender?

*Sport-gender collinearity:* Two runs — _with sport_ (within-sport effect) and _without sport_ (total effect including composition).

*Caveats:* SHAP ≠ causation. SHAP misattributes with correlated features. High R² expected due to circularity; value is in gender interaction.

=== Track 3 — Within-Basketball Estimation

*Specification:* $ log("TPV"_i) = alpha + theta dot "Female"_i + bold(X)' beta + epsilon_i $

- *Spec A:* full controls (log followers, win%, conference, school revenue, recruit ranking, class year)
- *Spec B:* minimal controls (class year, conference only)

Sensitivity via sensemakr (Cinelli & Hazlett 2020) with Diegert, Masten & Poirier (2024) sign-change breakdown.

== D: Analytical Considerations

=== The Dependent Variable: On3 TPV

On3 overhauled its methodology in December 2024 to Total Player Value, combining Roster Value ("collective marketplace") and NIL Value ("licensing and sponsorship"). Under our access, we observe TPV total for athletes ≥\$100K; the Roster/NIL split is visible only for >\$1.5M.

=== Causal Structure (DAG)

#align(center)[
#block(width: 85%, inset: 8pt, stroke: 0.4pt + luma(180), radius: 3pt)[
  #set text(8.5pt)
  #align(left)[
  Gender → {Sport Selection, Media Coverage, Expectation Asymmetry}\
  Sport Selection → Sport Revenue → Booster/Collective Allocation → *TPV*\
  Media Coverage → Social Media Followers → Brand Demand → *TPV*\
  Expectation Asymmetry → Realized Deals (Unobserved)

  _Key:_ Two pathways collapse into one observable. Sport is a mediator. Followers are mediator _and_ feedback variable.
  ]
]
]

=== Selection Bias

On3's \$100K floor creates hard left-censoring — gendered truncation on the DV. Most women in non-revenue sports fall below \$100K. Any measured gap is a *lower bound* on the true gap. No credible Heckman correction (no valid exclusion restriction).

=== Omitted Variable Bias

#table(
  columns: (1.5fr, 1fr),
  align: (left, left),
  hline-thick,
  table.header([*Omitted Variable*], [*Bias Direction*]),
  hline,
  [Actual deal values], [Unknown],
  [Agent/representation quality], [Upward (true gap smaller)],
  [TV viewership/ratings], [Upward],
  [Engagement rates], [Downward (gap appears smaller)],
  [Race/ethnicity (individual)], [Complex],
  [Negotiation expectations], [Upward],
  hline-thick,
)

Any unexplained gap is an *upper bound* on algorithmic or market bias.

=== Race × Gender

Black male athletes are overrepresented in football and men's basketball. Any "gender gap" confounds gender with racial demographics. We use aggregate NCAA demographics by sport and discuss the intersection in limitations.

=== Temporal Context

We capture a transitional snapshot: post-NIL legalization (July 2021), post-collective boom (2022–23), post-Clark effect (2023–24), post-On3 algorithm overhaul (Dec 2024), pre/post House settlement (June 2025). Pre- and post-December 2024 are separate series.

== E: Operations

*Team:* Student A (scraping, pipeline), Student B (EADA, Track 1), Student C (Track 2 ML), Anna (research design, Track 3, paper writing, QC). Need faculty advisor with applied econometrics/ML experience.

*Publication targets:* SSRN preprint (Week 12), MIT Sloan Sports Analytics Conference (~October), JQAS, Big Data & Society, Applied Economics Letters.

*Key risks:* On3 blocks scraping (HIGH — rate limiting; EADA-only fallback); \$100K floor excludes most women (HIGH — selection-rate analysis quantifies); basketball N too small (MEDIUM — go/no-go gate); SHAP circularity (MEDIUM — frame as decomposition); On3 ≠ market reality (HIGH — stated throughout).

== F: References

#set text(8.5pt)

*NIL Market:* AP News (2022); Sportico (2023); Opendorse "NIL at 3" (2024); MacKeigan (2023, SSRN 4554235); LeRoy (2025, _U. Cincinnati Law Review_ 93(4)); Rogers (2023); Sailofsky (2025, _IRSS_); Shuler & Steinfeldt (2025); Rodriguez (2025, _CTRL.FORM_).

*Clark Effect:* NBC News (2025); WSC Sports (2025); Nielsen (2024).

*On3 Methodology:* Terry (2024, On3); On3 "About NIL Valuation"; Wikipedia "On3.com" (2025); Bitget (2025).

*Methods:* Cinelli & Hazlett (2020, _JRSS-B_); Diegert, Masten & Poirier (2024); arXiv:2506.10179 (2025); arXiv:2305.02012v3.
