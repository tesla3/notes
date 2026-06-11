// Professional proposal layout
#set document(
  title: "Predicting Neighborhood Socioeconomic Upgrading",
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
      #h(1fr) Predicting Neighborhood Socioeconomic Upgrading
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

#let hline = table.hline(stroke: 0.5pt)
#let hline-thick = table.hline(stroke: 0.8pt)

// ─── Title Block ───
#align(center)[
  #block(spacing: 0.4em)[
    #text(14.5pt, weight: "bold")[Predicting Neighborhood Socioeconomic Upgrading:\ ML for Gentrification Early Warning]
  ]
  #v(0.3em)
  #text(10pt, fill: luma(80))[Research Proposal · May 2025]
]

#v(0.4em)
#line(length: 100%, stroke: 0.5pt + luma(180))
#v(0.2em)

// ─── 1. Problem ───
= 1. Problem

Gentrification — socioeconomic upgrading of previously low-income neighborhoods — is identified only _after_ Census data records the change. Policymakers need early warning. Can ML predict which census tracts will undergo upgrading _before_ it happens?

Two methodological problems undermine existing ML gentrification prediction:

+ *Circularity.* Prior studies construct the gentrification label from ACS variables (income, rent, home value, education), then use the _same variables_ at T1 as input features. Reported accuracy conflates genuine prediction with regression-to-the-mean detection.

+ *Definition dependence.* No consensus definition exists. "Variable selection had a significant impact on which, and how many, census tract areas were defined as neighbourhoods undergoing gentrification" (Galster & Peacock 1986). Studies report one accuracy number under one definition, obscuring how much is an artifact of label construction.

// ─── 2. Research Questions ───
= 2. Research Questions

*RQ1 — Circularity.* How much does reported accuracy come from feature-label overlap? What is the AUC gap between models with and without label-defining variables as features?

*RQ2 — Leading indicators.* Is T1 home value a genuine leading indicator of income-based gentrification (per Bunten et al. 2024's expectations theory), or a mechanical correlate? The feature-label separation design creates a clean test: home value is excluded under composite definitions (where it defines the label) but allowed under income-only definitions (where it does not).

*RQ3 — Definition sensitivity.* How do model performance and tract classification vary across five operationalizations? Where do definitions agree (consensus tracts) and disagree (contested tracts)?

*RQ4 — Spatial autocorrelation.* How much does ignoring spatial dependence inflate CV estimates? Does a spatial-proximity heuristic ("tracts adjacent to already-gentrified tracts will gentrify") outperform ML?

// ─── 3. Approach ───
= 3. Approach

== 3.1 Study Design

- *City:* Chicago (~800 census tracts). Single city chosen for data quality and statistical power.
- *Temporal structure:* T1 = ACS 2010–2014, T2 = ACS 2015–2019 (non-overlapping, both on 2010-vintage tract boundaries).
- *Task:* Binary classification — predict T2 gentrification label from T1 features.
- *Expected prevalence:* 10–15% (~80–120 positive cases).

== 3.2 Five Gentrification Definitions

All share an eligibility criterion (T1 income \< metro median) but differ in what constitutes "change." *D4 (Composite) is the primary specification; others are sensitivity analyses.*

#table(
  columns: (auto, 1.1fr, 2fr, 1.5fr),
  align: (center, left, left, left),
  hline-thick,
  table.header([*ID*], [*Name*], [*Change criteria*], [*Source*]),
  hline,
  [D1], [Freeman], [Education increase \> metro], [Freeman (2005)],
  [D2], [Ding-Hwang-Divringi], [Rent/value + education \> metro], [Ding et al. (2016)],
  [D3], [Income-only], [Income growth \> metro], [Simplified baseline],
  [D4], [Composite], [Income + rent/value + education \> metro], [Adapted from NCRC],
  [D5], [Expectations-based], [House-value pctile surpasses income pctile], [Bunten et al. (2024)],
  hline-thick,
)

== 3.3 Primary Contribution: Definition-Specific Feature-Label Separation

Rather than blanket-excluding all ACS variables, we exclude a variable from the feature set _if and only if it appears in that definition's label_. This creates a natural experiment:

- Under *D3* (income-only): home value, rent, and education are _allowed_ as features.
- Under *D4* (composite): all three are _excluded_.

Comparing D3 vs. D4 separates the *definition effect* (different tasks) from the *feature-availability effect* (more/fewer features). If home value ranks high in SHAP importance under D3, it is a genuine leading indicator — not circularity — because it does not define D3's label.

== 3.4 Feature Set

~25 always-included features spanning demand-side signals (demographics, transit, schools, amenities) and supply-side signals (vacancy, housing age, permits, zoning). Up to 3 conditionally-included features depending on definition. All from public sources: ACS, Chicago open data, CTA GTFS, NCES, HUD. See Appendix C.

== 3.5 Models & Evaluation

#table(
  columns: (1.2fr, 2fr),
  align: (left, left),
  hline-thick,
  table.header([*Model*], [*Purpose*]),
  hline,
  [Spatial proximity heuristic], [Baseline: does ML beat spatial diffusion?],
  [L1 logistic regression], [Interpretable linear baseline],
  [Random Forest], [Non-linear, standard in literature],
  [XGBoost], [Typically strongest on tabular data],
  hline-thick,
)

*Evaluation:* 5-fold stratified CV and 5-fold spatial block CV reported side-by-side. Probability calibration (Platt scaling) on unweighted models. All metrics with 95% bootstrap CIs.

== 3.6 Four Experiments

#table(
  columns: (auto, 1.2fr, 2fr),
  align: (center, left, left),
  hline-thick,
  table.header([\#], [*Question*], [*Design*]),
  hline,
  [1], [Circularity quantification], [With/without label-defining features; report AUC gap],
  [2], [Leading indicator test], [Compare SHAP rankings for home value under D3 vs. D4],
  [3], [Racial composition ablation], [With/without racial features; test proxy effects],
  [4], [Supply vs. demand ablation], [Supply-only, demand-only, and combined feature sets],
  hline-thick,
)

// ─── 4. Contributions ───
= 4. Contributions

+ *Definition-specific feature-label separation* — no prior ML gentrification study implements this. Creates a clean test of circularity vs. genuine prediction.
+ *Definition sensitivity analysis* — systematic comparison across five operationalizations, extending the NCRC (2025) definition comparison from descriptive to predictive.
+ *Spatial CV + calibration* — exposes autocorrelation inflation and produces calibrated risk probabilities for policy use.

*Either outcome is publishable:* accuracy holds under separation → genuine early-warning signals exist; accuracy drops → prior work was inflated by circularity.

// ─── 5. Timeline ───
= 5. Timeline (10 Weeks)

#table(
  columns: (0.7fr, 2fr, 2fr),
  align: (center, left, left),
  hline-thick,
  table.header([*Week*], [*Focus*], [*Deliverable*]),
  hline,
  [1–2], [Definitions, literature, data audit, labels, agreement], [Label dataset, agreement matrix, EPV report],
  [3–4], [Data pipelines (ACS, city data, transit, schools) & features], [Merged analysis-ready dataset],
  [5–6], [Baselines, RF, XGBoost, spatial block CV, calibration], [Primary results (D4)],
  [7–8], [Four experiments, SHAP, sensitivity (D1–D3, D5), failure analysis], [Circularity & sensitivity tables],
  [9–10], [Maps, visualization, paper writing], [Draft manuscript],
  hline-thick,
)

// ─── 6. Key Risks ───
= 6. Key Risks

#table(
  columns: (1.2fr, 2.5fr),
  align: (left, left),
  hline-thick,
  table.header([*Risk*], [*Why it matters*]),
  hline,
  [*Low EPV (~3–5)*], [~80–120 positives with ~25 features. Mitigated by a priori feature count, stability analysis, Riley et al. sample size check.],
  [*Single temporal transition*], [No out-of-time validation. Great Recession recovery may masquerade as gentrification. Highest-priority future extension.],
  [*Upgrading ≠ displacement*], [Tract-level averages shift without any individual being displaced (ecological fallacy). Model cannot distinguish in-situ upgrading from population replacement.],
  [*Dual-use*], [Risk maps could be used by speculators. Framed around community protection; ethics discussion included.],
  hline-thick,
)

// ─── 7. Fit ───
= 7. Fit

- Builds directly on Anna's existing census-tract research in Chicago (Cornell, 2024).
- All data publicly available — no API dependencies, no scraping.
- Targets _Environment and Planning B_, _CEUS_, _Housing Policy Debate_, _Urban Studies_.

// ─── Appendices ───
#text(13pt, weight: "bold")[Appendices]
#v(0.2em)

== A: Gentrification Definitions

=== The Measurement Problem

"No agreed-upon definition has become paradigmatic" (Desmond, An & Xiang 2023). The binary threshold approach is "criticized for the arbitrariness of the thresholds" (Li et al. 2019). Rather than evaluating definitions against ground truth (which does not exist), we test how model performance and tract classification vary across definitions.

#table(
  columns: (auto, 1.3fr, 2fr, 1.5fr),
  align: (center, left, left, left),
  hline-thick,
  table.header([*ID*], [*Eligibility*], [*Change Criteria*], [*Label-Defining Vars*]),
  hline,
  [D1], [Central city, income \< median, older housing], [Education increase \> metro], [Income, education],
  [D2], [Income \< median], [Rent OR value \> metro, AND education \> metro], [Income, rent, value, education],
  [D3], [Income \< median], [Income growth \> metro], [Income only],
  [D4], [Income \< median], [Income + rent/value + education \> metro], [All four],
  [D5], [Income \< median], [Value pctile surpasses income pctile by ≥25pp], [Income, home value],
  hline-thick,
)

*Agreement analysis:* For each pair, we report Cohen's κ, PABAK (Byrt et al. 1993) with 95% bootstrap CIs, and consensus vs. contested tracts. AUC under different definitions measures different tasks — we compare _within_-definition only.

=== The Expectations Channel (D5)

Bunten et al. (2024): "Property values today incorporate market participants' expectations of the neighbourhood's future." When a tract's house-value percentile rises above its income percentile, the _market_ expects gentrification before demographics register it. This gap "predicts future income growth" with a 3-year lead. T1 home value is therefore a *theoretically justified leading indicator* — whether it belongs in the feature set depends on whether it appears in the label.

== B: Feature-Label Separation Design

=== Variable Taxonomy

*1. Definitional proxies* — algebraic transforms of label-defining variables. Excluded under ALL definitions:
- Poverty rate (monotonic transform of income), % receiving public assistance (income-tested eligibility).

*2. Label-defining variables* — excluded only under definitions that use them:

#table(
  columns: (1.5fr, 1fr, 1fr),
  align: (left, left, left),
  hline-thick,
  table.header([*Variable*], [*Excluded under*], [*Allowed under*]),
  hline,
  [Median household income], [All (eligibility)], [None],
  [Median gross rent], [D2, D4], [D1, D3, D5],
  [Median home value], [D2, D4, D5], [D1, D3],
  [% bachelor's degree+], [D1, D2, D4], [D3, D5],
  hline-thick,
)

*3. Economic correlates* — correlated with income but structurally independent (% renter-occupied, vacancy rate, unemployment rate). Included with justification.

=== The Natural Experiment

Under D3 the feature set grows to 28 variables (25 + rent + home value + education); under D4 it stays at 25. If D3 performs substantially better _and_ home value ranks high in SHAP importance under D3, home value is a genuine leading indicator (per Bunten et al.) — not circularity.

*Mutual information audit:* Before modeling, compute MI between each candidate feature at T1 and (a) each label-defining variable at T1, and (b) the binary label. Permutation-based threshold (α=0.05). Flagged features investigated, not automatically excluded.

== C: Feature Set

=== Always-Included (~25 variables)

#table(
  columns: (1fr, 2fr, auto, 0.8fr),
  align: (left, left, center, left),
  hline-thick,
  table.header([*Category*], [*Features*], [*N*], [*Role*]),
  hline,
  [Demographics], [% White, Black, Hispanic, foreign-born, median age], [5], [Demand],
  [Housing (non-price)], [% renter, % vacant, housing age (% pre-1960), % moved in 5 yrs], [4], [Supply],
  [Employment], [% service occupations, mean commute time], [2], [Demand],
  [Subsidized housing], [HUD Housing Choice Voucher count], [1], [Policy],
  [Zoning], [Dominant class, max density], [2], [Supply],
  [Urban signals], [Crime rate, building permits, 311 complaints, business licenses], [4], [Mixed],
  [Transit], [Distance to nearest CTA L station, L stations within 800m], [2], [Demand],
  [School quality], [Mean K–12 test score percentile], [1], [Demand],
  [Amenity], [Distance to park, distance to university], [2], [Demand],
  [Spatial], [Distance to CBD, population density], [2], [Context],
  hline-thick,
)

Features grounded in two explanatory camps: *demand-side* (Ley 1986: preferences of a new middle class) and *supply-side* (Smith 1979: rent gap theory — where the gap between current and potential land rent is largest).

=== Conditionally-Included

Median gross rent (allowed under D1, D3, D5), median home value (allowed under D1, D3), % bachelor's degree+ (allowed under D3, D5).

=== Data Sources Excluded

Zillow ZHVI (ZIP-level only), Yelp/Google Places (no historical data → temporal leakage), Google Street View/satellite (infeasible in 10 weeks), LEHD LODES (complex pipeline, EPV constraints). All flagged as future extensions.

== D: Sample Size & Statistical Power

*EPV:* ~80–120 positives with 25 features → EPV ≈ 3.2–4.8. Under D1 (restrictive eligibility), positives may drop to 40–60 (EPV ≈ 1.6–2.4). The classic EPV ≥ 10 rule rests on weak evidence (van Smeden et al. 2016). We compute Riley et al. (2019) minimum sample size at the outset.

*Implications:* Feature importance rankings will be unstable; tree defaults will overfit; L1 reduces effective count but not search space.

*Mitigations:* (1) A priori feature count of ~25. (2) Riley et al. computation reported explicitly. (3) Conservative hyperparameters (high `min_samples_leaf`, low `max_depth`); no nested CV. (4) Stability analysis: 50 seeds, report Spearman ρ of SHAP rankings (if ρ \< 0.7, state explicitly). (5) Bootstrap CIs (n=1000); if AUC CI \> 0.15, note insufficient sample. (6) Definitions yielding \< 30 positives → descriptive only.

*Why Chicago only:* Baltimore (~200 tracts, ~20–30 positives) would yield ~4–6 positives per fold. Chicago's open data is substantially more complete.

== E: ML Methods & Experiments

*Cross-validation:* Stratified 5-fold and spatial block CV (block size exceeds Moran's I autocorrelation range) reported side-by-side. Literature shows spatial CV inflation up to 28% (Karasiak et al. 2022).

*Class imbalance:* No SMOTE. Two model versions: (a) unweighted (for calibration/risk maps), (b) `class_weight='balanced'` (for discrimination metrics).

*Calibration:* Platt scaling on unweighted model only. Per Phelps et al. (2024), Platt scaling after reweighting produces biased calibration.

*Metrics:* AUC-ROC, AUC-PR, precision, recall, F1 (weighted model). Brier score, reliability diagram (unweighted + calibrated). All with 95% bootstrap CIs.

*SHAP analysis:* Pairwise Pearson |r| \> 0.7 → cluster features. Report SHAP per-feature and per-cluster (summing |SHAP|). Expected clusters: \{renter, housing age, vacancy\}; \{foreign-born, Hispanic\}; \{crime, 311\}; \{transit, CBD distance\}. SHAP reported only for definitions with EPV ≥ 3.

*Failure analysis:* Mispredicted tracts examined for clustering in high-foreclosure areas (Great Recession confound).

== F: Temporal & Data Considerations

*Why 2010–2014 → 2015–2019:* Non-overlapping 5-year periods on 2010-vintage boundaries, avoiding NHGIS harmonization. Census Bureau "strongly recommends against comparing estimates in overlapping 5-year periods."

*Great Recession confound:* T1 captures post-recession aftermath. Income growth to T2 partly measures _recovery_, not gentrification. Compounded by historically low interest rates (near zero through 2015). Mitigations: acknowledge explicitly; examine misprediction clustering; note all definitions compare to metro-level growth; flag second temporal period as future extension.

*ACS margins of error:* MOE columns downloaded; tracts where MOE \> 30% of estimate for label-defining variables are flagged.

== G: Ethical Considerations

*Dual-use:* Risk maps could be used by speculators to front-run neighborhood change (Weber 2019: "predictions become self-fulfilling prophecies"). Frame around community protection; avoid publishing interactive tract-level maps without access controls.

*Prediction ≠ prescription:* SHAP shows feature _importance_, not causal mechanisms. "Building permits predict gentrification" ≠ permits _cause_ gentrification.

*Racial features:* If racial composition is a top predictor, it may proxy for structural disadvantage (redlining, disinvestment). Experiment 3 tests this directly.

*Ecological fallacy:* A "gentrifying" tract may reflect new construction, in-situ income growth, or population replacement. We predict _socioeconomic upgrading_, not _displacement_. The relationship between the two is empirically contested (Freeman 2005; Desmond et al. 2023; Brummet & Reed 2019 vs. Newman & Wyly 2006; Betancur 2011).

== H: Prior Work & Positioning

#table(
  columns: (1.2fr, 0.8fr, 1.2fr, 1.5fr),
  align: (left, left, left, left),
  hline-thick,
  table.header([*Study*], [*Method*], [*Result*], [*How we differ*]),
  hline,
  [Census Bureau WP 2023], [RF, D.C.], [83% accuracy], [No feature-label separation],
  [SSRN 3911354], [ACS+Zillow+HUD], [74% accuracy], [ZIP-level, single def., no spatial CV],
  [Yao et al. (2023)], [GNN+satellite], [0.9 AUC], [More complex; we add cleaner separation],
  [Thackway et al. (2023)], [RF+SHAP+CNN], [74.7% bal. acc.], [Single definition, no spatial CV],
  [Bunten et al. (2024)], [Expectations], [Value/income gap predicts growth], [We incorporate as D5],
  [NCRC & UMich (2025)], [ROC of defs.], ["Depends on measurement"], [We test how defs affect _prediction_],
  hline-thick,
)

== I: Team & Publication

*Team:* Student A (Census API, ACS MOE, MI audit, transit/amenity/school pipeline), Student B (city open data — crime, permits, 311, licenses, zoning), Student C (ML modeling, spatial CV, SHAP, calibration, maps), Anna (research design, definition comparison, literature, agreement analysis, paper writing, ethics).

*Targets:* _Environment and Planning B_ ★★★★★, _CEUS_ ★★★★★, _Housing Policy Debate_ ★★★★, _Urban Studies_ ★★★★.

== J: References

#set text(8.5pt)

Alfaro et al. (2025), _Digital-Era Urban Transformations_, Springer. Bardaka et al. (2019), _Transport Policy_ 80. Brummet & Reed (2019), FRB Philadelphia WP 19-30. Bunten, Preis & Aron-Dine (2024), _Urban Studies_ 61(1). Byrt, Bishop & Carlin (1993), _J Clin Epi_ 46(5). Census Bureau WP SEHSD-WP-2023-15 (2023). Desmond, An & Xiang (2023), _Social Problems_. Ding, Hwang & Divringi (2016), FRB Philadelphia WP 16-14. Easton et al. (2020), _Urban Studies_ 57(2). Eshtiyagh et al. (2024), _CEUS_. Freeman (2005), _Urban Affairs Review_ 40(4). Gardiner & Dong (2021), _Complex Networks IX_, Springer. Hwang & Sampson (2014), _ASR_ 79(4). Kahn (2007), _Real Estate Economics_ 35(2). Karasiak et al. (2022), _Machine Learning_ 111. Ley (1986), _Annals AAG_ 76(4). Li et al. (2019), _Cities_ 95. NCRC & UMich (2025), _J Urban Affairs_. Newman & Wyly (2006), _Urban Studies_ 43(1). Olive, Gadat & Maillard (2024), arXiv 2402.03819. Peduzzi et al. (1996), _J Clin Epi_ 49(12). Phelps et al. (2024), arXiv 2410.18144. Riley et al. (2019), _Stat Med_ 38(7). Rucks-Ahidiana (2021), _City & Community_ 21(3). Smith (1979), _JAPA_ 45. Thackway et al. (2023), _Cities_ 138. van Smeden et al. (2016), _BMC Med Res Meth_ 16. Weber (2019), UDP Symposium. Yao et al. (2023), arXiv 2312.15646.
