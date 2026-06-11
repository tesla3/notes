// Professional proposal layout
#set document(
  title: "From Lab to Market: What's Left of the Dye-Free Premium?",
  author: "OPALS Summer Research Program",
)

#set page(
  paper: "us-letter",
  margin: (top: 0.75in, bottom: 0.7in, left: 0.85in, right: 0.85in),
  numbering: "1",
  number-align: center,
  header: context {
    if counter(page).get().first() > 1 [
      #set text(8pt, fill: luma(120))
      #h(1fr) From Lab to Market: Dye-Free Premium
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

// Tight list spacing
#show list: set block(spacing: 0.45em)
#show list: set par(leading: 0.5em)
#show enum: set block(spacing: 0.45em)
#show enum: set par(leading: 0.5em)

#set table(
  stroke: none,
  inset: (x: 5pt, y: 3.5pt),
)
#show table: set text(9pt)

#let hline = table.hline(stroke: 0.5pt)
#let hline-thick = table.hline(stroke: 0.8pt)

// ─── Title Block ───
#align(center)[
  #block(spacing: 0.4em)[
    #text(14.5pt, weight: "bold")[From Lab to Market: What's Left of the Dye-Free Premium?]
    #v(0.1em)
    #text(11pt, weight: "regular")[Price Signals in the Middle of America's Food-Color Transition]
  ]
  #v(0.3em)
  #text(10pt, fill: luma(80))[OPALS Summer Research Proposal · June 2026]
]

#v(0.4em)
#line(length: 100%, stroke: 0.5pt + luma(180))
#v(0.2em)

// ─── Overview ───
= Overview

In April 2025, HHS and the FDA announced the largest food-additive phase-out in American history: voluntary elimination of all six remaining petroleum-based synthetic dyes (Red 40, Yellow 5, Yellow 6, Blue 1, Blue 2, Green 3), with a voluntary compliance target of October 2027. Red No.~3 was formally revoked in January 2025 (enforcement: January 2027). As of June 2026, most major manufacturers have pledged reformulation, though the majority are still "In Progress" (FDA Industry Tracker, May 2026).

Before this shift, products marketed as "dye-free" or "no artificial colors" commanded price premiums. Meta-analyses estimated average WTP premiums of ~30% for health and sustainability claims broadly (Li & Kallas 2021; Alsubhi et al. 2023) — but no published study has isolated the premium for "dye-free" specifically. As dye-free transitions from differentiator to expected baseline, the central question:

#align(center)[
  #block(inset: (x: 20pt, y: 6pt), fill: luma(245), radius: 3pt)[
    #text(10pt, weight: "bold")[What remains of the dye-free price premium during this regulatory transition — and does claiming "no artificial colors" generate value independent of composition?]
  ]
]

Early evidence suggests: very little. PepsiCo's Doritos Simply NKD retails at the same price as regular Doritos at Walmart (Food Institute, Feb 2026). Walmart's private-brand reformulation promises parity pricing (Walmart Corporate, Oct 2025). This makes mid-2026 a uniquely revealing measurement window.

*OPALS Bridge.* #h(3pt) OPALS students in the food dye toxicity track study cellular effects of synthetic dyes — the same compounds the FDA is phasing out. This project traces the downstream impact: *Lab Finding #sym.arrow.r Regulatory Action #sym.arrow.r Industry Reformulation #sym.arrow.r Consumer Market Response* (Wang et al. 2025).

// ─── Novel Angle ───
= Novel Angle

Most WTP studies use stated-preference methods during stable regulatory periods. This study measures *observed retail prices* during an active voluntary phase-out — a regulatory situation without precedent in US food policy. The novelty is *situational*, not methodological.

No published study has isolated WTP for "dye-free" as a standalone attribute. This provides the first observed-price estimate for this specific attribute during the transition. We also test whether the *act of claiming* "no artificial colors" — independent of compositional difference — is associated with higher prices.

// ─── Theoretical Framework ───
= Theoretical Framework

*1. Signaling Theory (Spence 1973).* #h(3pt) "No artificial dyes" is a voluntary quality signal. As adoption spreads, the signal's informational value decreases. _Prediction:_ premiums lower where most competitors have adopted.

*2. Anticipated-Mandate Expectations.* #h(3pt) The phase-out is legally voluntary as of June 2026 — no formal rulemaking has revoked Red 40's authorization (PolicyCanary 2026; Haynes Boone 2025). But market participants price in the anticipated mandate. Firms reformulate pre-emptively; consumers discount the signal.

*3. Competitive Price Convergence (Tirole 1988).* #h(3pt) Simultaneous industry reformulation prevents any firm from sustaining a premium — consumers substitute to identically-positioned competitors. PepsiCo's parity pricing for Doritos NKD illustrates this.

*4. Cost Pass-Through.* #h(3pt) Observed price differentials reflect BOTH supply-side cost increases (natural colorants cost 2–10#sym.times more; per-SKU reformulation costs \$50K–\$200K per Haskell 2026) and demand-side WTP. We cannot fully disentangle these with observational data, but design specific comparisons to bound each component (RQ3).

The three demand-side mechanisms are *complementary, not competing* — all predict premium compression. The null-result framework (below) partially distinguishes them via data patterns.

// ─── Research Questions ───
= Research Questions

#table(
  columns: (auto, 1fr, 1fr, 1fr),
  align: (center, left, left, left),
  hline-thick,
  table.header(
    [*\#*], [*Question*], [*Prediction*], [*Challenged If*],
  ),
  hline,
  [*RQ1*],
  [Do dye-free products command a measurable price premium over comparable dyed products in mid-2026?],
  [Premium ≥ 5% in paired comparisons],
  [Premium < 5% or non-significant. A null result is substantively meaningful — see _Interpreting Null Results._],

  [*RQ2*],
  [Is the premium smaller where reformulation is more advanced?],
  [Premium in high-reformulation categories ≤ half of low-reformulation],
  [Premiums uniform across categories — would suggest cost/brand effects, not signal value. _Exploratory:_ ~25–30 pairs/category limits power.],

  [*RQ3*],
  [Among compositionally similar dye-free products, are those with "no artificial colors" claims priced higher?],
  [Claimed > unclaimed],
  [No difference — consumers respond to ingredients, not marketing. _Note:_ association, not causal test (see Limitations).],
  hline-thick,
)

#v(0.15em)
#text(9pt, fill: luma(60))[*Meta-analytic context (Discussion only):* We compare findings against published WTP for broader health claims: 29.5% for sustainable food (Li & Kallas 2021) and 30.7% for healthier food (Alsubhi et al. 2023). These aggregate across organic, fair trade, reduced-fat — not "dye-free" specifically.]

// ─── Regulatory Context ───
= Regulatory Context (June 2026)

#table(
  columns: (auto, 1fr, auto),
  align: (left, left, left),
  hline-thick,
  table.header([*Date*], [*Event*], [*Legal Status*]),
  hline,
  [Jan 2025], [FDA revokes Red No. 3], [Formal revocation (Delaney Clause)],
  [Apr 2025], [HHS/FDA announce phase-out of remaining 6 dyes], [Voluntary guidance (MAHA)],
  [May 2025], [FDA approves 3 new natural color additives], [Formal approval],
  [Feb 2026], [FDA changes "no artificial colors" labeling — allows claim if no petroleum-based dyes, even with natural colorants], [Enforcement discretion],
  [Jan 2027], [Red No. 3 enforcement date], [Mandatory],
  [Oct 2027], [Compliance target for remaining 5 dyes], [Voluntary — no formal rulemaking],
  hline-thick,
)

#block(inset: (left: 12pt), stroke: (left: 2pt + luma(180)))[
  #text(9pt, style: "italic")[
    "The FDA's announcement does not include changes to underlying federal statutes, nor does it include the immediate revocation of all of the FDA's regulations authorizing the impacted color additives." — Haynes Boone, Apr 2025
  ]
]

== Industry Reformulation Status

#text(9pt, fill: luma(60))[Sources: FDA Industry Tracker (May 2026), CSPI Corporate Commitment Tracker (Apr 2026), PlainFoodSafe (Jun 2026).]

#table(
  columns: (auto, 1fr),
  align: (left, left),
  hline-thick,
  table.header([*Status*], [*Companies*]),
  hline,
  [*Complete*], [Sam's Club (Member's Mark), In-N-Out, Tyson, PepsiCo (NKD line)],
  [*In Progress — 2026*], [Hershey, Kraft Heinz, Danone, Grupo Bimbo, Campbell's],
  [*In Progress — 2027*], [General Mills, Nestlé, Mars, WK Kellogg, Conagra, McCormick, Mondelez, PepsiCo full line, Walmart private brands, Coca-Cola, Post],
  [*No commitment*], [National Confectioners Association members (Ferrara/Ferrero, HARIBO, Tootsie Roll) — "will follow regulatory guidance" (CSPI)],
  hline-thick,
)

*Key:* The National Confectioners Association has NOT pledged voluntary removal — confirming candy/confections as the right low-reformulation category for RQ2.

// ─── Product Classification ───
= Product Classification

Based on composition and the February 2026 FDA labeling policy:

#table(
  columns: (auto, 1fr, auto),
  align: (left, left, left),
  hline-thick,
  table.header([*Group*], [*Description*], [*Example*]),
  hline,
  [*A — Synthetic*], [Contains ≥1 FD&C petroleum-based colorant], [Froot Loops (Red 40, Yellow 6, Blue 1)],
  [*B — Natural*], [No synthetic dyes; contains natural colorants. Can claim "no artificial colors" under Feb 2026 policy.], [Annie's Bunny Grahams (beet juice)],
  [*C — None*], [No added colorants of any kind], [Plain Cheerios],
  hline-thick,
)

// ─── Data Sources ───
= Data Sources

#table(
  columns: (auto, 1fr, 1fr),
  align: (left, left, left),
  hline-thick,
  table.header([*Source*], [*Provides*], [*Validation*]),
  hline,
  [*USDA FDC — Branded Foods*], [Ingredient lists for >400K branded US products. Manufacturer-submitted, updated monthly. Search directly for "Red 40" etc.], [Pre-camp: query for dye names, spot-check 30 products against Walmart.com, assess category coverage.],
  [*Open Food Facts*], [Supplementary ingredients + front-of-pack claims. European-origin, crowdsourced.], [Spot-check additive tag accuracy. Record `last_modified_t`. If >10% discrepancy or >50% pre-2025 → FDC primary, OFF claims only.],
  [*PlainFoodSafe.com*], [US product ingredient index (OFF data); dye product counts.], [Verify usability. Counts may include non-US products.],
  [*Walmart.com*], [Current retail prices for matched pairs (manual lookup).], [Pre-identify ≥85 candidate pairs. See Price Collection Protocol.],
  [*FDA + CSPI Trackers*], [Company-level reformulation pledges.], [Cross-reference both. CSPI is more rigorous than FDA tracker.],
  hline-thick,
)

#v(0.15em)
#block(inset: (x: 8pt, y: 5pt), fill: luma(248), radius: 2pt)[
  #text(9pt)[*Retailer note:* Walmart's EDLP strategy compresses price variation, and Walmart itself pledges parity pricing (Walmart Corporate, Oct 2025). Griffith & Nesheim (2013): organic premiums 0% at discount retailers to 30% at premium retailers. *A positive premium at Walmart is a conservative lower bound; a null premium is ambiguous.* Findings are Walmart-specific, not market-wide. No scraping — manual lookup of publicly displayed prices only.]
]

// ─── Methodology ───
= Methodology

== Pre-Camp Preparation (Mentor, 25–30 hours)

#table(
  columns: (auto, auto, 1fr),
  align: (center, left, left),
  hline-thick,
  table.header([*\#*], [*Task*], [*Details*]),
  hline,
  [1], [*FDC data pull*], [Query Branded Foods API for products with synthetic dye names. Filter to target categories.],
  [2], [*OFF data pull*], [Download CSV, filter to US. Quantify additive-tagged products (E129/E102/E110/E133/E132/E143).],
  [3], [*Spot-check*], [30 FDC + 30 OFF products verified against Walmart.com. Record discrepancy rate. For OFF: record `last_modified_t` distribution.],
  [4], [*Matched pairs*], [≥85 candidates across 3 categories: (a) candy/confections ~30 (low reform.), (b) cereals/baked goods ~30 (med-high), (c) beverages ~25 (medium). Document match type (within-brand / cross-brand), size (±25%). Target ≥15 within-brand.],
  [5], [*RQ3 products*], [≥30 dye-free WITH "no artificial colors" claim + ≥30 WITHOUT. Same category, comparable brand tier.],
  [6], [*Geographic pilot*], [5 products at zip 92093 vs. 77001. If identical → reduce geo check to 10 pairs.],
  [7], [*Templates*], [Google Sheets with validation rules + 10 examples. JASP template with one example pair.],
  [8], [*Feasibility gate*], [#sym.lt 50 valid pairs → pivot to landscape-only study.],
  [9], [*Progress check*], [2 weeks pre-camp: #sym.lt 40 pairs → early gate. #sym.lt 25 pairs → landscape only.],
  hline-thick,
)

== Software

#table(
  columns: (auto, 1fr),
  align: (left, left),
  hline-thick,
  table.header([*Function*], [*Tool*]),
  hline,
  [Data collection], [Google Sheets (collaborative)],
  [Statistical analysis], [JASP (free, GUI; jasp-stats.org) — supports all required tests],
  [Visualization], [JASP + Google Sheets charts],
  [Poster], [Google Slides or PowerPoint],
  hline-thick,
)

== Price Collection Protocol

+ All prices from *Walmart.com*, primary zip *92093* (UCSD)
+ *Geographic check:* 10–20 pairs at zip *77001* (Houston, TX) per pilot results
+ Collected within a *3-day window* (Week 1, Days 3–5)
+ Record *regular shelf price:*
  - No badge/strikethrough → displayed price is regular
  - "Rollback" WITH strikethrough → record both; use strikethrough for primary analysis
  - "Rollback" WITHOUT strikethrough → displayed price (permanent rollback)
  - "Was \$X.XX" → record both; use "Was" as regular
  - Do NOT use Walmart+ member pricing
+ Record *date of collection* per product
+ *Screenshot every 10th product* as audit trail
+ *Inter-collector reliability:* 10% overlap subsample by two students. Discrepancy >5% → reconcile

== Week 1: Data Assembly & Familiarization (5 days)

*Days 1–2 — Learning:*
- "Ingredient detective" exercise: classify 10 familiar products into Groups A/B/C
- FD&C naming conventions, E-numbers, natural colorant names
- Regulatory timeline and February 2026 labeling change
- "Price pair" demo: look up 3 pre-selected pairs, record all fields, discuss

*Days 3–5 — Data collection.* Record per product: name, brand, category, dye status (A/B/C), dye count, front-of-pack claims, brand tier (premium/mainstream/value), price, package size (total oz), unit price (price/oz solids, price/fl oz liquids), match type (within-brand / cross-brand).

*End of Week 1 go/no-go:*
- ≥60 valid pairs across ≥2 categories → proceed to RQ1/RQ2
- ≥15 within-brand pairs → within-brand premium is primary estimate
- #sym.lt 15 within-brand → proceed with caveat (cross-brand carries brand-equity confounds)
- #sym.lt 60 valid pairs → drop pricing; focus on reformulation landscape

== Week 2: Statistical Analysis (5 days)

*RQ1 — Primary.* Paired Wilcoxon signed-rank test. Report median premium %, IQR, _p_-value. *Stratify by match type:* within-brand pairs are the clean comparison — if within-brand ≈ 0% but cross-brand > 0%, interpret the latter as brand positioning. Package-size check: sensitivity analysis restricted to pairs within ±25%.

*RQ2 — Exploratory.* Kruskal-Wallis across three categories; pairwise Mann-Whitney U with Bonferroni (3 comparisons). ~25–30 pairs per category. Report effect sizes (rank-biserial _r_) alongside _p_-values.

*RQ3 — Exploratory.* Mann-Whitney U: claimed vs. unclaimed dye-free unit prices within category. Sensitivity: restrict to same-brand-tier. 30 per group; power ~0.50–0.60 for small effects.

== Week 3: Reformulation Landscape + Review Coding (5 days)

=== Phase 3 — Reformulation Landscape (all students, primary deliverable)

Using FDC + OFF + FDA Tracker + CSPI Tracker:

- *Dye prevalence:* % of products per category still containing synthetic dyes; which dyes most prevalent
- *Dye complexity:* distribution of distinct dyes per product by category (3+ dyes = higher reformulation cost)
- *Pledge-vs-product-data gap analysis:* cross-reference company pledges (FDA/CSPI) with product-level data (FDC primary). Have companies that pledged by mid-2026 actually removed dyes?
- *Staleness validation:* manually verify ≥10 apparent gaps against Walmart.com. Report confirmed gaps vs. database lag.
- *State regulatory exposure:* which products with dyes are sold in states with bans? CA (AB 418, 2023); WV (school meals, 2025); >70 bills, >15 enacted (EWG, Mar 2026)
- *Visualize:* stacked bars by category; compliance timeline; dye heat map; pledge-vs-reality chart

#block(inset: (x: 8pt, y: 5pt), fill: luma(248), radius: 2pt)[
  #text(9pt)[*This analysis is independently publishable regardless of pricing outcomes.* No existing tracker cross-references company pledges with product-level ingredient data.]
]

=== Phase 4 — Review Content Analysis (stretch goal)

30–40 products + 5–10 neutral controls. 10 most recent reviews per product, ≥2 sentences (manual reading only). Code: dye/health mentions, taste, switching behavior, price sensitivity. Inter-coder reliability: 20% overlap, Cohen's κ ≥ 0.6.

== Week 4: Synthesis & Communication (5 days)

- Integrate: landscape × premium estimates × review themes
- IMRAD-format poster + oral presentations
- *Stretch:* 2-page conference abstract

// ─── Interpreting Null Results ───
= Interpreting Null or Near-Zero Premium Results

If observed premium < 5% or non-significant:

#table(
  columns: (auto, 1fr, 1fr),
  align: (left, left, left),
  hline-thick,
  table.header([*Interpretation*], [*Mechanism*], [*Supporting Data Pattern*]),
  hline,
  [Transition completion], [Market has priced in the baseline shift], [Premium ≈ 0% in high-reform. categories, > 0% in low-reform.],
  [Competitive convergence], [Simultaneous reformulation prevents any firm sustaining a premium], [Premium ≈ 0% uniformly across all categories],
  [Cost absorption], [Firms absorb higher costs to maintain share], [Premium ≈ 0% for major brands, > 0% for small brands],
  [Attribute non-salience], [Dye-free was never independently valued], [Premium ≈ 0% overall, but RQ3 claim association positive],
  [Attribute inversion], [Dye-free is mainstream; dyed products are niche/legacy], [Negative premium, driven by cross-brand; within-brand ≈ 0%],
  hline-thick,
)

A null result is not a failed study. Documenting the absence of a premium during this regulatory moment establishes an observed-price baseline and tests theoretical predictions about premium erosion during industry transitions.

// ─── Deliverable Tiers ───
= Deliverable Tiers

#table(
  columns: (auto, 1fr, auto),
  align: (left, left, left),
  hline-thick,
  table.header([*Tier*], [*Deliverable*], [*Depends On*]),
  hline,
  [*Must ship*], [Reformulation landscape: dye prevalence, pledge-vs-product-data gap analysis with staleness validation, dye-complexity scoring, state exposure. + poster + presentation], [FDC/OFF data only],
  [*Should ship*], [Matched-pair premium estimates for ≥60 pairs across 3 categories (RQ1, RQ2)], [Price collection succeeds],
  [*Should ship*], [Claim-vs-no-claim comparison (RQ3) with brand-tier sensitivity], [≥30 products per group],
  [*Stretch*], [Review content analysis with inter-coder reliability], [Time and capacity],
  [*Stretch*], [Conference abstract with meta-analytic context], [Statistical sophistication],
  hline-thick,
)

// ─── Scope Boundaries ───
= Scope Boundaries

- Takes a *cross-sectional snapshot.* No longitudinal claims.
- Reports *descriptive/correlational* premiums. No causal identification.
- Treats RQ3 as an *association*, not a causal test.
- Reports *Walmart-specific* findings, not market-wide estimates.
- Does not study PFAS, Reddit, or use scraping/API-based price collection.
- Does not assume a positive premium. Null and negative findings are substantively meaningful.

// ─── Limitations ───
= Limitations

+ *Cost pass-through confound.* Observed differentials include manufacturer cost increases (natural colorants 2–10× more; Haskell 2026). Cannot fully disentangle supply and demand. RQ3 partially addresses.
+ *Selection bias.* Within-brand pairs exist disproportionately for brands not yet reformulated — a non-random sample.
+ *Ingredient data coverage.* FDC is more systematic than OFF for US products but may not cover all items. Landscape findings describe products in the database, not all US products.
+ *Single time point.* Cannot measure change over time. Meta-analytic comparisons are suggestive context, not formal benchmarks.
+ *Voluntary transition.* Red 40 remains lawfully authorized. We study an anticipated-mandate, not post-mandate environment.
+ *RQ3 endogeneity.* Claiming brands are systematically premium-positioned. Controls for composition, not brand positioning or bundled claims.
+ *RQ3 power.* 30/group; power ~0.50–0.60 for small effects. Exploratory; non-significance may reflect power.
+ *Single retailer, single geography.* Walmart EDLP compresses variation; California is the most regulated state for food dyes. Geographic check partially addresses. Griffith & Nesheim (2013): 0–30% organic premium range across retailer types.
+ *Database staleness.* Even FDC has update lags. Staleness validation (≥10 manual checks) partially addresses.

// ─── References ───
= References

#set text(8.5pt)
#set par(hanging-indent: 1.5em)

1. Rosen S. Hedonic Prices and Implicit Markets. _J Political Economy._ 1974;82(1):34–55.

2. Spence M. Job Market Signaling. _QJE._ 1973;87(3):355–374.

3. Darby MR, Karni E. Free Competition and the Optimal Amount of Fraud. _J Law Econ._ 1973;16(1):67–88.

4. Tirole J. _The Theory of Industrial Organization._ MIT Press; 1988.

5. Li S, Kallas Z. Meta-analysis of consumers' WTP for sustainable food products. _Appetite._ 2021;161:104195.

6. Alsubhi M et al. Consumer WTP for healthier food: systematic review. _Obesity Reviews._ 2023;24(1):e13525.

7. Griffith R, Nesheim L. Hedonic methods for baskets of goods. _Econ Letters._ 2013;120(2):284–287.

8. Delmas MA, Burbano VC. Drivers of Greenwashing. _California Management Review._ 2011;54(1):64–87.

9. Wang Z et al. UCSD OPALS Program's Impact on HS Students in STEM. _Biomedical Eng Education._ 2025;6:227–233.

10. U.S. FDA. HHS, FDA to Phase Out Petroleum-Based Synthetic Dyes. Press Release, Apr 22, 2025.

11. U.S. FDA. Tracking Food Industry Pledges. Updated May 12, 2026.

12. U.S. FDA. Letter re: "no artificial colors" labeling claims. Feb 5, 2026.

13. CSPI. Synthetic Dyes Corporate Commitment Tracker. Updated Apr 17, 2026.

14. PlainFoodSafe. FDA Food Dye Ban: What's Being Removed. Jun 2026.

15. PolicyCanary. Red 40 FDA Status 2026. Mar 2026.

16. Haynes Boone. FDA Announces Plan to Phase Out Petroleum-Based Food Dyes. Apr 2025.

17. Haskell. Real Cost of Moving from Artificial to Natural Flavors and Colors. Mar 2026.

18. Elchemy. True Cost of Natural Food Dyes. Sep 2025.

19. NewFoodMagazine. Natural Colors vs. Synthetic Dyes: Cost Comparison. Oct 2025.

20. Food Institute. Latest in the War on Food Dyes. Feb 2026.

21. Daily Mail. Cheetos and Doritos dye-free makeover. Feb 2026.

22. PepsiCo Newsroom. Cheetos and Doritos Are Getting Naked. Nov 2025.

23. EWG. State Food Dye Legislation Tracker. Mar 2026.

24. Walmart Corporate. Walmart Moves to Eliminate Synthetic Dyes. Oct 1, 2025.

25. Fast Company. Walmart says goodbye to synthetic dyes. Oct 1, 2025.

26. BIPC Law. FDA New Enforcement Policy on "No Artificial Colors" Labeling. Feb 2026.

27. Barley.com. FDA Signals Shift Away from Synthetic Food Dyes. Feb 2026.

28. USDA FoodData Central. Branded Foods data type. fdc.nal.usda.gov.
