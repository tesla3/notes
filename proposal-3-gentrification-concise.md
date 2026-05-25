# Predicting Neighborhood Socioeconomic Upgrading: ML for Gentrification Early Warning

## 1. Problem

Gentrification — socioeconomic upgrading of previously low-income neighborhoods — is identified only *after* Census data records the change. Policymakers need early warning. Can ML predict which census tracts will undergo upgrading *before* it happens?

Two methodological problems undermine existing ML gentrification prediction:

1. **Circularity.** Prior studies (Census Bureau WP 2023; SSRN 3911354) construct the gentrification label from ACS variables (income, rent, home value, education), then use the *same variables* at T1 as input features. Reported accuracy conflates genuine prediction with regression-to-the-mean detection.

2. **Definition dependence.** No consensus definition exists. "Variable selection had a significant impact on which, and how many, census tract areas were defined as neighbourhoods undergoing gentrification" (Galster & Peacock 1986). Studies use one definition and report one accuracy number, obscuring how much of what they find is an artifact of how they define the outcome.

## 2. Research Questions

**RQ1 — Circularity.** How much does reported accuracy in ML gentrification prediction come from feature-label overlap? What is the AUC gap between models with and without label-defining variables as features?

**RQ2 — Leading indicators.** Is T1 home value a genuine leading indicator of income-based gentrification (per Bunten et al. 2024's expectations theory), or a mechanical correlate? The feature-label separation design creates a clean test: home value is excluded under composite definitions (where it defines the label) but allowed under income-only definitions (where it does not).

**RQ3 — Definition sensitivity.** How do model performance and tract classification vary across five operationalizations of gentrification? Where do definitions agree (consensus tracts) and disagree (contested tracts)?

**RQ4 — Spatial autocorrelation.** How much does ignoring spatial dependence inflate cross-validation estimates? Does a simple spatial-proximity heuristic ("tracts adjacent to already-gentrified tracts will gentrify") outperform ML?

## 3. Approach

### 3.1 Study Design

- **City:** Chicago (~800 census tracts). Single city chosen for data quality and statistical power (see Appendix D).
- **Temporal structure:** T1 = ACS 2010–2014, T2 = ACS 2015–2019 (non-overlapping, both on 2010-vintage tract boundaries).
- **Task:** Binary classification — predict T2 gentrification label from T1 features.
- **Expected prevalence:** 10–15% (~80–120 positive cases).

### 3.2 Five Gentrification Definitions

We test five operationalizations spanning demographic-change, composite, and expectations-based approaches. All share an eligibility criterion (T1 income < metro median) but differ in what constitutes "change." See Appendix A for full specification.

| ID | Name | Change criteria (summary) | Source |
|----|------|--------------------------|--------|
| D1 | Freeman | Education increase > metro | Freeman (2005) |
| D2 | Ding-Hwang-Divringi | Rent/value + education increase > metro | Ding et al. (2016) |
| D3 | Income-only | Income growth > metro | Simplified baseline |
| D4 | Composite | Income + rent/value + education > metro | Adapted from NCRC |
| D5 | Expectations-based | House-value percentile surpasses income percentile | Bunten et al. (2024) |

**D4 (Composite)** is the primary specification. Others are sensitivity analyses.

### 3.3 Primary Contribution: Definition-Specific Feature-Label Separation

Rather than blanket-excluding all ACS variables, we exclude a variable from the feature set *if and only if it appears in that definition's label*. This creates a natural experiment:

- Under **D3** (income-only): home value, rent, and education are *allowed* as features.
- Under **D4** (composite): all three are *excluded*.

Comparing D3 vs. D4 separates the **definition effect** (different tasks) from the **feature-availability effect** (more/fewer features). If home value ranks high in SHAP importance under D3, it is a genuine leading indicator — not circularity — because it does not define D3's label. See Appendix B for the full variable taxonomy (definitional proxies, label-defining variables, economic correlates).

### 3.4 Feature Set

~25 always-included features spanning demand-side signals (demographics, transit, schools, amenities) and supply-side signals (vacancy, housing age, permits, zoning). Up to 3 conditionally-included features depending on definition. All from public sources: ACS, Chicago open data, CTA GTFS, NCES, HUD. See Appendix C.

### 3.5 Models & Evaluation

| Model | Purpose |
|-------|---------|
| Spatial proximity heuristic | Baseline: does ML beat spatial diffusion? |
| L1 logistic regression | Interpretable linear baseline |
| Random Forest | Non-linear, standard in literature |
| XGBoost | Typically strongest on tabular data |

**Evaluation:** 5-fold stratified CV and 5-fold spatial block CV reported side-by-side. Probability calibration (Platt scaling) on unweighted models. All metrics with 95% bootstrap CIs.

### 3.6 Four Experiments

| # | Question | Design |
|---|----------|--------|
| 1 | Circularity quantification | Run with/without label-defining features; report AUC gap |
| 2 | Leading indicator test | Compare SHAP rankings for home value under D3 vs. D4 |
| 3 | Racial composition ablation | Run with/without racial features; test proxy effects |
| 4 | Supply vs. demand ablation | Run supply-only, demand-only, and combined feature sets |

See Appendix E for full experimental protocol.

## 4. Contributions

1. **Definition-specific feature-label separation** — no prior ML gentrification study implements this. Creates a clean test of circularity vs. genuine prediction.
2. **Definition sensitivity analysis** — systematic comparison across five operationalizations, extending the NCRC (2025) definition comparison from descriptive to predictive.
3. **Spatial CV + calibration** — exposes autocorrelation inflation and produces calibrated risk probabilities for policy use.

**Either outcome is publishable:** accuracy holds under separation → genuine early-warning signals exist; accuracy drops → prior work was inflated by circularity. The D3 vs. D4 comparison isolates whether home value is a leading indicator or an artifact.

## 5. Timeline (10 Weeks)

| Week | Focus | Deliverable |
|------|-------|-------------|
| 1–2 | Definitions, literature review, data audit, labels, agreement analysis | Label dataset, agreement matrix, EPV/power report |
| 3–4 | Data pipelines (ACS, city data, transit, schools) & feature engineering | Merged analysis-ready dataset |
| 5–6 | Baselines, RF, XGBoost, spatial block CV, calibration | Primary results (D4) |
| 7–8 | Four experiments, SHAP analysis, sensitivity (D1–D3, D5), failure analysis | Circularity & sensitivity tables |
| 9–10 | Maps, visualization, paper writing | Draft manuscript |

## 6. Key Risks

| Risk | Why it matters |
|------|---------------|
| **Low EPV (~3–5)** | ~80–120 positives with ~25 features. Feature importance may be unstable. Mitigated by a priori feature count, stability analysis, Riley et al. sample size check. |
| **Single temporal transition** | No out-of-time validation. Great Recession recovery may masquerade as gentrification. Highest-priority future extension. |
| **Predicting upgrading ≠ predicting displacement** | Tract-level averages shift without any individual being displaced (ecological fallacy). Model cannot distinguish in-situ upgrading from population replacement. |
| **Dual-use** | Risk maps could be used by speculators to front-run neighborhood change. Framed around community protection; ethics discussion included. |

## 7. Fit

- Builds directly on Anna's existing census-tract research in Chicago (Cornell, 2024).
- All data publicly available — no API dependencies, no scraping.
- Targets *Environment and Planning B*, *CEUS*, *Housing Policy Debate*, *Urban Studies*.

---

## Appendix A: Gentrification Definitions (Five Operationalizations)

### The Measurement Problem

There is no consensus definition. "No agreed-upon definition has become paradigmatic, and it is rare for a study to replicate a previously employed definition" (Desmond, An & Xiang 2023). The binary threshold approach is "criticized for the arbitrariness of the thresholds" (Li et al. 2019). The NCRC and University of Michigan (2025) concluded that "the answer depends on how it is measured."

Our approach is complementary: rather than evaluating definitions against ground truth (which does not exist), we test how model performance and tract classification vary across definitions.

### Definition Details

| ID | Eligibility | Change Criteria | Label-Defining Variables |
|----|-------------|-----------------|--------------------------|
| **D1** (Freeman 2005) | Central city, income < metro median, housing stock older than metro median | Education attainment increase > metro increase | Income (eligibility), education (change) |
| **D2** (Ding-Hwang-Divringi 2016) | Income < metro median | Rent OR home value increase > metro, AND college-educated share increase > metro | Income (eligibility), rent, home value, education (change) |
| **D3** (Income-only) | Income < metro median | Income growth > metro income growth | Income only |
| **D4** (Composite) | Income < metro median | Income growth > metro, AND rent or home value growth > metro, AND education increase > metro | Income, rent, home value, education (all four) |
| **D5** (Expectations-based, Bunten et al. 2024) | Income < metro median | House-value percentile rises above income percentile by ≥ 25 percentile points | Income, home value (as percentile gap) |

**"Central city" operationalization for D1:** Census Bureau's principal city designation — the City of Chicago municipal boundary within the Chicago-Naperville-Elgin CBSA.

**Eligibility threshold sensitivity:** Tested at the 40th, 45th, 50th, and 55th percentiles.

### Agreement Analysis

For each definition pair, we report:
- Number of tracts classified as gentrifying (prevalence)
- Cohen's kappa and prevalence-adjusted bias-adjusted kappa (PABAK; Byrt, Bishop & Carlin 1993) with 95% bootstrap CIs (n=1000)
- Consensus tracts (flagged under all definitions) vs. contested tracts

**AUC comparability caveat:** AUC under different definitions measures different tasks. We compare *within*-definition performance across models but do not rank definitions by AUC.

### The Expectations Channel (D5)

Bunten, Preis & Aron-Dine (2024) operationalize gentrification through asset pricing theory: "Property values today incorporate market participants' expectations of the neighbourhood's future." When a tract's house-value percentile rank rises above its income percentile rank, the *market* expects gentrification before demographics register it. They show this gap "predicts future income growth" with a 3-year lead and "a 5% faster increase in neighbourhood real income 10 years later."

This has a critical implication: T1 home value is not just a mechanical correlate — it is a **theoretically justified leading indicator** encoding forward-looking market expectations. Whether it belongs in the feature set depends on whether it appears in the label definition.

---

## Appendix B: Feature-Label Separation Design

### The Circularity Problem

In prior work, the gentrification label is constructed from ACS variables (income, rent, home value, education), and the *same variables* at T1 serve as input features. The model learns: "given income/rent/education at T1, predict whether income/rent/education will change faster than average by T2." This is partly regression-to-the-mean detection.

### Variable Taxonomy (Three Categories)

**1. Definitional proxies** — algebraic transforms of label-defining variables. Excluded under ALL definitions:
- **Poverty rate:** "calculated by comparing the value of FTOTINC to the family's poverty threshold" (IPUMS USA). A direct monotonic transform of income.
- **% receiving public assistance:** eligibility is income-tested; mechanically inversely correlated with income.

**2. Label-defining variables** — excluded only under definitions that use them:

| Variable | Excluded under | Allowed under |
|----------|---------------|---------------|
| Median household income | All (eligibility) | None |
| Median gross rent | D2, D4 | D1, D3, D5 |
| Median home value | D2, D4, D5 | D1, D3 |
| % bachelor's degree+ | D1, D2, D4 | D3, D5 |

**3. Economic correlates** — correlated with income but capturing independent structural information. Included with justification:
- % renter-occupied: housing tenure structure
- Vacancy rate: housing stock availability (supply-side predictor)
- Unemployment rate: labor market dynamics

The distinction between categories 1 and 3 matters: poverty rate is income *measured on a different scale*; vacancy rate is *correlated with* income but measures something structurally different.

### The Natural Experiment

Under D3 (income-only), the feature set grows to 28 variables (25 + rent + home value + education). Under D4 (composite), it stays at 25. Comparing performance separates:
- **Definition effect:** D3 and D4 classify different tracts (different tasks)
- **Feature-availability effect:** D3 has access to home value and rent; D4 does not

If D3 performs substantially better *and* home value ranks high in SHAP importance under D3, home value is a genuine leading indicator (per Bunten et al.) — not circularity.

### Mutual Information Audit

Before modeling, we compute mutual information between each candidate feature at T1 and (a) each label-defining variable at T1, and (b) the binary gentrification label. Permutation-based threshold (α=0.05). Computed on both the full sample and the eligible subsample. Flagged features are investigated, not automatically excluded.

---

## Appendix C: Feature Set

### Always-Included Features (~25 variables)

| Category | Features | Count | Source | Theoretical Role |
|----------|----------|-------|--------|-----------------|
| Demographics | % White, % Black, % Hispanic, % foreign-born, median age | 5 | ACS | Demand-side |
| Housing (non-price) | % renter-occupied, % vacant, housing age (% pre-1960), % moved in last 5 yrs | 4 | ACS | Supply-side (rent gap proxy) |
| Employment | % service occupations, mean commute time | 2 | ACS | Demand-side |
| Subsidized housing | HUD Housing Choice Voucher count | 1 | HUD | Policy constraint |
| Zoning | Dominant zoning class, max allowed density | 2 | City data | Supply-side |
| Urban signals | Crime rate, building permits, 311 complaints, business licenses | 4 | City data | Mixed |
| Transit | Distance to nearest CTA L station, L stations within 800m | 2 | GTFS | Demand-side |
| School quality | Mean K–12 test score percentile | 1 | NCES | Demand-side |
| Amenity | Distance to nearest park, distance to nearest university | 2 | City data | Demand-side |
| Spatial | Distance to CBD, population density | 2 | Computed | Context |

### Conditionally-Included (definition-dependent)

| Feature | Excluded under | Allowed under |
|---------|---------------|---------------|
| Median gross rent | D2, D4 | D1, D3, D5 |
| Median home value | D2, D4, D5 | D1, D3 |
| % bachelor's degree+ | D1, D2, D4 | D3, D5 |

### Theoretical Grounding

Features are structured around two explanatory camps:
- **Demand-side** (Ley 1986): preferences of a new middle class — transit access, walkability, amenities, school quality.
- **Supply-side** (Smith 1979, rent gap theory): where the gap between current and potential land rent is largest — vacancy, housing age, zoning, permits.

**Key literature support:**
- Transit proximity: Kahn (2007) found communities near new "Walk and Ride" stations experience greater gentrification. Bardaka et al. (2019) confirmed transit-induced gentrification in Denver.
- School quality: Yao et al. (2023) ranked schools among the strongest predictors in their GNN model. Most ML gentrification studies omit this.

### Data Sources Excluded (with justification)

| Source | Why excluded |
|--------|-------------|
| Zillow ZHVI | ZIP-level only; many-to-many crosswalk introduces systematic error. ACS already provides tract-level home value. |
| Yelp / Google Places | Only current listings available; historical data would constitute temporal leakage. |
| Google Street View / satellite imagery | Infeasible within 10 weeks. Highest-priority future extension. |
| LEHD LODES | Complex pipeline, EPV constraints, and commuting flows correlate with income. Future extension. |

### Business License Limitations

SIC codes at the 2-digit level do not distinguish a diner from a farm-to-table restaurant (both SIC 5812). License renewal may be indistinguishable from a new license. We aggregate to total count per tract.

---

## Appendix D: Sample Size & Statistical Power

### Events-Per-Variable (EPV)

With ~800 Chicago tracts and 10–15% prevalence, we expect ~80–120 positive cases. With 25 always-included features (up to 28 under D3), EPV ≈ 3.2–4.8. Under D1 (restrictive eligibility), positives may drop to 40–60 (EPV ≈ 1.6–2.4).

The classic EPV ≥ 10 rule rests on weak evidence (van Smeden et al. 2016). Riley et al. (2019) proposed principled criteria requiring: (i) global shrinkage factor ≥ 0.9, (ii) |apparent − adjusted Nagelkerke R²| ≤ 0.05, (iii) precise population risk estimation. We compute Riley et al. minimum sample size at the outset and report whether our sample meets it.

### Implications

- Feature importance rankings will be **unstable**. SHAP on an overfit model is not reliable.
- Tree-based default hyperparameters will overfit.
- L1 regularization reduces effective feature count but not the search space.

### Mitigations

1. **A priori feature count of ~25** (set before seeing data, not data-driven).
2. **Riley et al. (2019) sample size computation** reported explicitly.
3. **Conservative hyperparameters** (high `min_samples_leaf`, low `max_depth`). No nested CV — inner loop would fit to noise with ~20 positives per fold.
4. **Stability analysis:** 50 runs with different seeds. Report Spearman ρ of SHAP rankings. If ρ < 0.7, state explicitly.
5. **Bootstrap CIs (n=1000):** If AUC CI > 0.15, interpret as evidence of insufficient sample.
6. **Minimum positive-case threshold:** definitions yielding < 30 positives get descriptive statistics only.

### Why Chicago Only

Baltimore (~200 tracts, ~20–30 positives) would yield ~4–6 positives per CV fold — too few for reliable metrics. Chicago's open data is substantially more complete. Baltimore is flagged as a future extension.

---

## Appendix E: ML Methods & Experiments

### Cross-Validation Strategy

Two strategies reported side-by-side:
- **Stratified 5-fold CV** (standard, treats tracts as i.i.d.)
- **Spatial block CV:** block size exceeds empirical spatial autocorrelation range (Moran's I correlogram). Literature shows spatial CV inflation up to 28% (Karasiak et al. 2022).

### Class Imbalance

We do NOT use SMOTE. "For most data sets, we observe that applying no rebalancing strategy is competitive" (Olive, Gadat & Maillard 2024).

Two model versions:
- **(a) Unweighted:** raw probabilities preserving true prevalence. Used for calibration and risk maps.
- **(b) `class_weight='balanced'`:** used for discrimination metrics (AUC-PR, F1).

### Probability Calibration

Platt scaling (sigmoid, 2 parameters) on the unweighted model only. Per Phelps et al. (2024), Platt scaling after reweighting produces biased calibration. Reliability diagrams and Brier scores reported.

### Metrics

AUC-ROC, AUC-PR, precision, recall, F1 (weighted model). Brier score, reliability diagram (unweighted + calibrated). Full precision-recall curve. All with 95% bootstrap CIs (n=1000).

### Four Experiments

**Experiment 1 — Circularity quantification:** Models with strict definition-specific separation vs. all label-defining variables included. AUC gap = circularity inflation.

**Experiment 2 — Leading indicator test:** D3 (home value allowed) vs. D4 (home value excluded). If home value ranks high in SHAP under D3, it is a genuine leading indicator per Bunten et al.

**Experiment 3 — Racial composition ablation:** With/without % White, % Black, % Hispanic. Tests whether the model uses race as a proxy for the eligibility criterion (low-income tracts in Chicago are disproportionately Black).

**Experiment 4 — Supply vs. demand ablation:** Supply-only features (zoning, vacancy, housing age, permits) vs. demand-only (demographics, transit, schools) vs. both. Tests whether Smith's (1979) rent gap theory manifests at tract level.

### SHAP Analysis (with collinearity audit)

- Pairwise Pearson correlation; group features with |r| > 0.7 into clusters.
- Report SHAP per-feature and per-cluster (summing |SHAP| within cluster). Addresses gradient boosting's "first-mover bias" among correlated features.
- Expected clusters: {renter, housing age, vacancy}; {foreign-born, Hispanic}; {crime, 311}; {transit, CBD distance}.
- SHAP reported only for definitions with EPV ≥ 3.

### Failure Analysis

Systematically mispredicted tracts examined for clustering in high-foreclosure areas (Great Recession confound).

---

## Appendix F: Temporal & Data Considerations

### Why 2010–2014 → 2015–2019

The Census Bureau "strongly recommends against comparing estimates in overlapping 5-year periods since much of the data in each estimate are the same." Our periods share zero overlapping years and both use 2010-vintage tract boundaries, avoiding NHGIS boundary harmonization.

### The Great Recession Confound

T1 (2010–2014) captures post-recession aftermath. Income growth to T2 partly measures **recovery**, not gentrification. Tracts hit hardest by the recession mechanically show the most recovery — which looks exactly like gentrification.

**Compounding factor:** Historically low interest rates (near zero through 2015, ~2.4% by end 2019) reduced the cost of buying into lower-income neighborhoods.

**Mitigations:** Acknowledge explicitly; examine misprediction clustering in high-foreclosure areas; note that all definitions compare to metro-level growth (partial control); flag a second temporal period (2000 → 2006–2010) as highest-priority future extension.

### Inflation Adjustment

All definitions compare tract-to-metro growth over the same span in nominal dollars. Inflation cancels in the relative comparison. Stated explicitly; CPI adjustment factor reported alongside.

### ACS Margins of Error

MOE columns downloaded for all variables. Tracts where MOE > 30% of estimate for label-defining variables are flagged.

---

## Appendix G: Ethical Considerations

### Dual-Use Risk

Rachel Weber (2019) warned that "predictions become self-fulfilling prophecies." A risk map could be used by speculators to front-run neighborhood change, *accelerating* the process. Mitigations: frame around community protection; discuss dual-use explicitly; avoid publishing interactive tract-level maps without access controls; recommend use with community input.

### Prediction ≠ Prescription

SHAP values show feature *importance*, not causal mechanisms. "Building permit density predicts gentrification" ≠ permits *cause* gentrification. Policymakers should not restrict permits based on this model.

### Racial Features

If racial composition is a top predictor, it may proxy for structural disadvantage (redlining, disinvestment), not a causal mechanism. Experiment 3 tests this directly.

### Ecological Fallacy

All findings are tract-level. A "gentrifying" tract may reflect new construction on vacant land, in-situ income growth, or population replacement. The model cannot distinguish these mechanisms. We predict *socioeconomic upgrading*, not *displacement*.

### Upgrading ≠ Displacement

The relationship is empirically contested. Freeman (2005): "little evidence that gentrification is associated with displacement." Desmond, An & Xiang (2023): "eviction rates were lower at the end of the period in gentrifying neighborhoods." Brummet & Reed (2019): "incumbent residents are not displaced at elevated rates during gentrification." Conversely, ethnographic research consistently documents displacement as lived experience (Newman & Wyly 2006; Betancur 2011).

---

## Appendix H: Prior Work & Positioning

| Study | Method | Key Result | How We Differ |
|-------|--------|------------|---------------|
| Census Bureau WP 2023 | RF, Washington D.C. | 83% accuracy | No feature-label separation |
| SSRN 3911354 (2021) | ACS + Zillow + HUD | 74% accuracy | ZIP-level Zillow, single definition, no spatial CV |
| Yao et al. (2023) | GNN + satellite | 0.9 AUC | More complex; we add cleaner feature separation |
| Gardiner & Dong (2021) | RF + mobility, NYC | Network features help | We flag LODES as future extension |
| Thackway et al. (2023) | RF + SHAP + CNN, Sydney | 74.7% balanced accuracy | Single definition, no spatial CV |
| Bunten et al. (2024) | Expectations-based measure | Value/income gap predicts growth | We incorporate as D5 |
| NCRC & UMich (2025) | ROC analysis of definitions | "Depends on measurement" | We test how definitions affect *prediction* — complementary |
| Eshtiyagh et al. (2024) | Meta-synthesis, *CEUS* | Data quality + black-box gaps | Our separation design addresses their gaps |

---

## Appendix I: Team & Publication

### Task Allocation

| Person | Responsibility |
|--------|---------------|
| Student A | Census API, ACS MOE analysis, MI audit, definition-specific feature sets, transit/amenity/school pipeline |
| Student B | City open data pipeline (crime, permits, 311, licenses, zoning) — geocoding, temporal filtering, tract aggregation |
| Student C | ML modeling: spatial block CV, model comparison, SHAP, calibration, ablation experiments, maps |
| Anna | Research design, definition comparison, literature framing, agreement analysis, paper writing, ethics |

### Publication Targets

| Journal | Fit |
|---------|-----|
| *Environment and Planning B* | ⭐⭐⭐⭐⭐ |
| *Computers, Environment and Urban Systems* | ⭐⭐⭐⭐⭐ |
| *Housing Policy Debate* | ⭐⭐⭐⭐ |
| *Urban Studies* | ⭐⭐⭐⭐ |

---

## Appendix J: References

- Alfaro, Šćepanović, Law & Quercia (2025). "Gentrification from the Sky." *Digital-Era Urban Transformations*. Springer.
- Bardaka, Herring & Kaza (2019). "A Tale of Two Light Rail Transit Lines." *Transport Policy* 80: 122–134.
- Brummet & Reed (2019). "The Effects of Gentrification on Original Residents." FRB Philadelphia WP 19-30.
- Bunten, Preis & Aron-Dine (2024). "Re-measuring gentrification." *Urban Studies* 61(1): 20–39.
- Byrt, Bishop & Carlin (1993). "Bias, prevalence and kappa." *J Clinical Epidemiology* 46(5): 423–429.
- Census Bureau WP SEHSD-WP-2023-15 (2023). "Identifying gentrification using machine learning."
- Desmond, An & Xiang (2023). "Beyond Gentrification." *Social Problems*.
- Ding, Hwang & Divringi (2016). "Gentrification and Residential Mobility in Philadelphia." FRB Philadelphia WP 16-14.
- Easton, Lees, Hubbard & Tate (2020). "Measuring and mapping displacement." *Urban Studies* 57(2): 286–306.
- Eshtiyagh et al. (2024). "ML in understanding urban neighborhood gentrification." *CEUS*.
- Freeman (2005). "Displacement or Succession?" *Urban Affairs Review* 40(4): 463–491.
- Gardiner & Dong (2021). "Mobility Networks for Predicting Gentrification." *Complex Networks IX*. Springer.
- Hwang & Sampson (2014). "Divergent Pathways of Gentrification." *ASR* 79(4): 726–751.
- Kahn (2007). "Gentrification Trends in New Transit-Oriented Communities." *Real Estate Economics* 35(2): 155–182.
- Karasiak et al. (2022). "Spatial dependence between training and test sets." *Machine Learning* 111: 2715–2740.
- Ley (1986). "Alternative Explanations for Inner-City Gentrification." *Annals of the AAG* 76(4): 521–535.
- Li et al. (2019). "A comparison of approaches for gentrification identification." *Cities* 95.
- NCRC & UMich (2025). "Does gentrification push people out?" *Journal of Urban Affairs*.
- Newman & Wyly (2006). "The Right to Stay Put, Revisited." *Urban Studies* 43(1): 23–57.
- Olive, Gadat & Maillard (2024). "Do we need rebalancing strategies?" arXiv 2402.03819.
- Peduzzi et al. (1996). "Events per variable in logistic regression." *J Clinical Epidemiology* 49(12): 1373–1379.
- Phelps, Lizotte & Woolford (2024). "Platt's scaling after undersampling." arXiv 2410.18144.
- Riley et al. (2019). "Minimum sample size for prediction models." *Statistics in Medicine* 38(7): 1276–1296.
- Rucks-Ahidiana (2021). "Gentrification as Racial Capitalism." *City & Community* 21(3): 173–192.
- Smith (1979). "Toward a Theory of Gentrification." *JAPA* 45: 538–548.
- Thackway et al. (2023). "Gentrification Prediction Using ML." *Cities* 138: 104344.
- van Smeden et al. (2016). "No rationale for 1 variable per 10 events." *BMC Med Res Methodology* 16: 163.
- Weber (2019). UDP Symposium comments on "self-fulfilling prophecies."
- Yao et al. (2023). "Graph-based multimodal framework for gentrification." arXiv 2312.15646.
