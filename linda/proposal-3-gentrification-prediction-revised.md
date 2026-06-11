# Proposal 3 (Revised): Predicting Neighborhood Socioeconomic Upgrading — Machine Learning for Gentrification Early Warning Using Census and Urban Data

## Summary

Gentrification — the socioeconomic upgrading of previously low-income neighborhoods — poses risks to incumbent residents in major US cities. Current identification methods are backward-looking: they detect gentrification only *after* Census data records the change. Can ML predict which census tracts will undergo socioeconomic upgrading *before* it happens, giving policymakers time to intervene?

We build a tract-level classification model using publicly available Census, housing, crime, transit, zoning, and amenity data for Chicago. The project makes **two primary contributions** that address known weaknesses in prior work:

1. **Definition-specific feature-label separation**: We strictly exclude label-defining ACS variables — and their mechanical correlates — from the input feature set, but we do so **per definition**, allowing variables that are excluded under one operationalization to serve as features under another. This design enables a clean test: does T1 home value improve prediction under income-only definitions (where it is not label-defining) by the same margin that prior work's circularity inflates accuracy under composite definitions (where it is)? This distinguishes legitimate leading indicators from mechanical artifacts.

2. **Definition sensitivity analysis**: We systematically test how model performance and tract classification vary across five operationalizations of gentrification, including the recent expectations-based measure of Bunten, Preis & Aron-Dine (2024), quantifying disagreement between definitions.

We additionally report spatial block cross-validation alongside standard CV to expose spatial autocorrelation inflation, and calibrate predicted probabilities for policy use.

### Important Framing Note

We predict *socioeconomic upgrading*, not *displacement*. The relationship between gentrification and displacement is empirically contested. Freeman (2005) found "little evidence that gentrification is associated with displacement on the aggregate metropolitan level." Desmond, An & Xiang (2023), analyzing eviction records across 72 US metros, found that "eviction rates were lower at the end of the period in gentrifying neighborhoods, and they fell more over time in such spaces." Brummet & Reed (2019), using linked Census microdata, showed that "incumbent residents are not displaced at elevated rates during gentrification," suggesting that tract-level income change partly reflects in-situ upgrading and new construction rather than population replacement. Conversely, ethnographic research consistently documents displacement as lived experience (Newman & Wyly 2006; Betancur 2011).

This project predicts neighborhood *change*, not resident-level *outcomes*. Tract-level averages can shift without any individual being displaced: new construction on vacant lots adds high-income units while existing residents remain. This is the ecological fallacy applied to neighborhood change. Our model operates entirely at the aggregate level and cannot distinguish between these mechanisms.

## Why Anna

Her Cornell research (Jan–Dec 2024) was census tract-level analysis of crime and demographics in Chicago and Baltimore using shapefiles and Census data. She already knows ACS variables, tract-level geography, and spatial joins. This project extends her existing competency into ML and adds a policy-relevant prediction angle. She does not need to learn the domain; she needs to learn the methods.

---

## Theoretical Framing

### Demand-Side and Supply-Side Predictors

Gentrification theory divides into two explanatory camps. **Demand-side** theories (Ley 1986, 1996) emphasize the preferences and movements of a new middle class — educated professionals who value urban amenities, walkability, transit access, and cultural diversity. **Supply-side** theories, principally Neil Smith's **rent gap theory** (Smith 1979), argue that gentrification occurs where the gap between current capitalized land rent and potential land rent is largest: "gentrification is an expected product of the relatively unhampered operation of the land and housing markets" (Smith, "Toward a Theory of Gentrification," *JAPA* 45: 538–548, 1979).

Both mechanisms operate simultaneously. Our feature set is structured to capture both:

- **Demand-side signals**: demographic composition, transit proximity, amenity access, school quality — who might move in and why
- **Supply-side signals**: vacancy rates, housing age, building permits, zoning classification — where reinvestment is structurally possible and where the rent gap is widest

### The Expectations Channel

Bunten, Preis & Aron-Dine (2024) introduce a third explanatory lens rooted in asset pricing theory: "Property values today incorporate market participants' expectations of the neighbourhood's future. We contrast this with present-oriented variables like demographics" (*Urban Studies* 61(1): 20–39). They operationalize this by comparing the percentile rank of a tract's house value to that of its income within its metro area. When house-value rank rises above income rank, the *market* expects gentrification before demographics register it.

This has a critical implication for our feature-label separation design. Bunten et al. show that the house-value/income percentile gap "predicts future income growth" with a 3-year lead and "a 5% faster increase in neighbourhood real income 10 years later." T1 home value is not just a mechanical correlate of the label — it is a **theoretically justified leading indicator** that encodes forward-looking market expectations. Whether it belongs in the feature set depends on whether it appears in the label definition — a distinction the original ML gentrification literature has not drawn.

---

## Data Sources (All Publicly Accessible)

| Source | What | Geography | Temporal Coverage | Access |
|--------|------|-----------|-------------------|--------|
| **ACS 5-Year Estimates** | Demographics, income, education, rent, housing value, poverty rate | Census tract | 2010–2014 (T1), 2015–2019 (T2) | Census API via `cenpy` or `census` Python package |
| **HUD Housing Choice Vouchers** | Subsidized housing counts by tract | Census tract | Annual | huduser.gov — free download |
| **City Open Data — Chicago** | Crime incidents, building permits, 311 complaints, business licenses (with SIC/NAICS codes and issue dates), zoning districts | Point/polygon data, geocoded to tract | 2001–present | data.cityofchicago.org — API |
| **TIGER/Line Shapefiles** | Census tract boundary files (2010 vintage) | Census tract | 2010 boundaries | census.gov/geographies — free download |
| **CTA GTFS Feeds** | Transit station locations (rail) | Point data | Historical archives | transitfeeds.com, CTA open data portal |
| **City park shapefiles** | Park boundaries | Polygon data | Current (stable over study period) | Chicago open data portal |
| **NCES / State Education Data** | School locations, quality ratings (test score percentiles) | Point data (school locations) | Annual | nces.ed.gov (ELSI), Illinois state report cards |

### Study City: Chicago Only (with justification)

The original design included Baltimore (~200 tracts) for cross-city generalization. We restrict to Chicago (~800 tracts) for two reasons:

1. **Statistical**: With ~200 tracts and an expected gentrification prevalence of 10–15%, Baltimore yields ~20–30 positive cases. Per-fold test sets under 5-fold CV would contain ~4–6 positives — far too few for reliable metric estimation. Any reported performance difference between cities would be indistinguishable from sampling noise.

2. **Practical**: Chicago's open data portal (crime, permits, 311, business licenses with SIC codes, zoning) is substantially more complete and better-documented than Baltimore's. Eliminating a second city's data pipeline saves ~1.5 weeks of engineering time that can be redirected to the methodological analysis.

Baltimore is flagged as a future extension for validation once the methodology is established.

### Data Sources Removed (with justification)

| Source | Why Removed |
|--------|-------------|
| **Zillow ZHVI** | Reported at ZIP code level. ZIP codes are mail delivery routes, not geographic areas. The HUD ZIP-to-tract crosswalk is many-to-many and introduces systematic measurement error. ACS already provides median home value at tract level. |
| **Yelp / Google Places API** | Yelp Fusion API returns only *current* business listings. Historical business composition cannot be retrieved. Using present-day data as T1 features would constitute temporal leakage — the coffee shops visible today exist *because* gentrification already occurred. |
| **Google Street View / Satellite Imagery** | Property-level visual changes are leading indicators that precede census-detectable demographic shifts (Thackway et al. 2023; Ilic et al. 2019; Alfaro et al. 2025). However, training a CNN on historical GSV imagery is infeasible within 10 weeks. Flagged as the highest-priority future extension after temporal validation. |
| **LEHD LODES** | Commuting network features (Gardiner & Dong 2021) add a complex data pipeline — download, aggregate from block to tract, compute network metrics (betweenness centrality, entropy). With ~25 features already and EPV constraints (see below), the marginal features cannot be reliably estimated. Additionally, commuting flows correlate with income, risking reintroduction of excluded information. Flagged as a future extension. |

### Why 2010–2014 → 2015–2019 (not overlapping periods)

The U.S. Census Bureau "strongly recommends against comparing estimates in overlapping 5-year periods since much of the data in each estimate are the same" (Census Bureau, "Period Estimates in the American Community Survey," 2022). Our two periods share zero overlapping years and both use **2010-vintage census tract boundaries**, avoiding the need for NHGIS boundary harmonization crosswalks required by the 2020 ACS's switch to 2020-vintage boundaries.

### The Great Recession Confound

Our T1 baseline (2010–2014) captures the aftermath of the worst U.S. recession since the 1930s. Income growth from 2010–2014 to 2015–2019 partly measures **recession recovery**, not gentrification. Tracts hit hardest by the recession (high foreclosure, high unemployment) will mechanically show the most income recovery — which looks exactly like gentrification under all definitions.

**Compounding macroeconomic context:** The study period saw historically low interest rates (federal funds rate near zero through 2015, rising to ~2.4% by end of 2019). Low mortgage rates reduced the cost of buying into lower-income neighborhoods, potentially accelerating capital inflows into rent-gap neighborhoods. This macro-credit channel is unobservable at the tract level.

**Mitigation:** We cannot fully resolve this. We can:
- Acknowledge it explicitly as a temporal confound
- Examine whether mispredicted tracts cluster in areas of known high foreclosure distress
- Note that all definitions compare tract growth to *metro-level* growth, partially (but not fully) controlling for economy-wide recovery
- Flag a second temporal period (2000 → 2006–2010) as the highest-priority future extension for out-of-time validation

### Inflation Adjustment

ACS reports income, rent, and home value in nominal dollars. CPI-U increased ~7% between 2012 and 2017 (midpoints of our ACS windows). All five definitions compare tract-level growth to metro-level growth over the same period. Since both are in nominal dollars over the same span, inflation cancels in the relative comparison. We make this assumption explicit and report all growth rates in nominal terms alongside the CPI adjustment factor.

---

## Gentrification Definitions (Five Operationalizations)

### The Problem

There is no consensus definition. "No agreed-upon definition has become paradigmatic, and it is rare for a study to replicate a previously employed definition" (Desmond, An & Xiang 2023). Galster and Peacock (1986) showed that "variable selection had a significant impact on which, and how many, census tract areas were defined as neighbourhoods undergoing gentrification" (cited in Easton et al. 2020, *Urban Studies*). The binary threshold approach is "criticized for the arbitrariness of the thresholds" (Li et al. 2019, *Cities*). Recent work proposes continuous measures — structural equation modeling to treat gentrification "as a latent variable, comprised of several observed indicators" (*Social Problems*, 2024).

Most critically, the NCRC and University of Michigan recently published an empirical comparison of definitions using ROC analysis, concluding that "the answer depends on how it is measured" and that "the NCRC and Ding methods have a slightly greater validity" (NCRC, "Does gentrification push people out?", *Journal of Urban Affairs*, 2025). Our approach is complementary: rather than evaluating definitions against ground truth (which does not exist), we test how model performance and tract classification vary across definitions.

### Five Definitions, Compared

| ID | Name | Eligibility | Change Criteria | Label-Defining Variables | Source |
|----|------|-------------|-----------------|--------------------------|--------|
| **D1** | Freeman (2005) | Central city, income < metro median, housing stock older than metro median | Education attainment increase > metro increase | Income (eligibility), education (change) | Freeman (2005), *Urban Affairs Review* 40(4): 463–491 |
| **D2** | Ding-Hwang-Divringi (2016) | Income < metro median | Rent OR home value increase > metro, AND college-educated share increase > metro | Income (eligibility), rent, home value, education (change) | Ding, Hwang & Divringi (2016), FRB Philadelphia WP 16-14 |
| **D3** | Income-only | Income < metro median | Income growth > metro income growth | Income only | Simplified baseline |
| **D4** | Composite | Income < metro median | Income growth > metro, AND rent or home value growth > metro, AND education increase > metro | Income, rent, home value, education (all four) | Adapted from Rucks-Ahidiana (2021), NCRC (2020) |
| **D5** | Expectations-based (Bunten et al.) | Income < metro median | House-value percentile rises above income percentile by ≥ 25 percentile points | Income, home value (as percentile gap) | Bunten, Preis & Aron-Dine (2024), *Urban Studies* 61(1): 20–39 |

**Primary specification:** D4 (Composite) serves as the primary definition for the main results. D1–D3 and D5 are reported in the sensitivity analysis.

**Why D5 is important:** Bunten et al. show that their expectations-based signal detects gentrification "in earlier years and with more parsimonious data" than existing approaches. Including it tests whether a market-expectations definition identifies different tracts than demographic-change definitions — and whether the model's predictive features differ across theoretically distinct operationalizations.

**Clarification on D1 "central city":** We operationalize this as the Census Bureau's principal city designation within the Chicago-Naperville-Elgin CBSA — the City of Chicago municipal boundary. We report how many eligible tracts D1 excludes relative to D2–D5.

**Agreement analysis:** For each definition pair, we report:
- Number of tracts classified as gentrifying (prevalence)
- Cohen's kappa and prevalence-adjusted bias-adjusted kappa (PABAK; Byrt, Bishop & Carlin 1993) with 95% bootstrap CIs (n=1000)
- Which tracts are classified under *all* definitions vs. only some (consensus vs. contested tracts)

**Eligibility threshold sensitivity:** All definitions use "income < metro median" as the eligibility criterion — a knife-edge threshold. We test sensitivity at the 40th, 45th, 50th, and 55th percentiles.

**Comparability caveat:** AUC computed under different definitions measures different classification tasks. We compare *within*-definition performance across models and report the *direction* of performance changes across definitions, but do not rank definitions by AUC.

---

## The Feature-Label Separation Problem (Primary Contribution)

### The Circularity in Existing Work

In prior studies (Census Bureau WP 2023; SSRN 3911354), the gentrification label is constructed from ACS variables (income, rent, home value, education), and the *same variables* at T1 are used as input features. The model then learns: "given income/rent/education at T1, predict whether income/rent/education will change faster than average by T2." This is partly regression-to-the-mean detection — low-income tracts mechanically satisfy the eligibility criterion, and the model exploits the coupling between T1 levels and T1→T2 changes.

### Our Solution: Definition-Specific Feature Pools

Rather than a blanket exclusion of all four label-defining variables from all models, we implement **definition-specific separation**. A variable is excluded from the feature set *if and only if it appears in the label definition for that model run*. This is both stricter (no variable can appear on both sides) and more informative (it reveals which "excluded" variables are legitimate leading indicators under definitions that don't use them).

**Taxonomy of variable roles** (three categories, not two):

1. **Definitional proxies** — variables that are algebraic transforms of label-defining variables. These are excluded under ALL definitions regardless of whether the label uses them, because they reconstruct excluded information:
   - **Poverty rate**: "calculated by comparing the value of FTOTINC to the family's poverty threshold" (IPUMS USA). A direct monotonic transform of income.
   - **% receiving public assistance**: eligibility is income-tested; mechanically inversely correlated with income.

2. **Label-defining variables** — excluded only under definitions that use them in the label:
   - Median household income: excluded from features under ALL definitions (used for eligibility in all five)
   - Median gross rent: excluded under D2, D4 (used in change criteria); **allowed as feature** under D1, D3, D5
   - Median home value: excluded under D2, D4, D5 (used in change criteria); **allowed as feature** under D1, D3
   - % bachelor's degree+: excluded under D1, D2, D4 (used in change criteria); **allowed as feature** under D3, D5

3. **Economic correlates** — variables correlated with income that contain independent structural information. These are *included* with justification:
   - % renter-occupied: correlates with income but captures housing tenure structure — an independent dimension of neighborhood character
   - Vacancy rate: correlates with income but directly measures housing stock availability — a supply-side predictor of reinvestment potential
   - Unemployment rate: correlates with income but captures labor market dynamics

The distinction between category 1 (always exclude) and category 3 (include with audit) is conceptually important. Poverty rate is income *measured on a different scale*. Vacancy rate is *correlated with* income but measures something structurally different — the physical availability of housing stock for reinvestment.

### This Design Creates a Natural Experiment

Under D3 (income-only), median home value, median rent, and % bachelor's+ are all available as features. Under D4 (composite), none of them are. Comparing model performance between D3 and D4 separates two effects:

- **Definition effect**: D3 and D4 classify different tracts as "gentrifying" (different tasks)
- **Feature-availability effect**: D3 has access to home value and rent as features; D4 does not

If D3 performs substantially better *and* home value ranks high in SHAP importance under D3, this demonstrates that home value is a genuine leading indicator — not circularity — because it is not used in D3's label. This is a cleaner test than the original design's blanket exclusion.

### Mutual Information Audit

Before modeling, we compute mutual information (MI) between each candidate feature at T1 and (a) each label-defining variable at T1, and (b) the binary gentrification label. Any feature with MI exceeding a permutation-based threshold (α=0.05) is flagged and discussed. MI calculations are computed on both the full sample and the eligible subsample (low-income tracts only), since the restricted income range in the eligible subsample may compress MI estimates.

This audit is empirical verification, not a decision rule. Flagged features are not automatically excluded — they are investigated. A feature with high MI against the label but low MI against T1 label-defining variables is potentially a genuine predictive signal.

---

## Feature Set (~25 variables, definition-dependent)

### Always-included features (all definitions)

| Category | Features | Count | Source | Theoretical Role |
|----------|----------|-------|--------|-----------------|
| **Demographics** | % White, % Black, % Hispanic, % foreign-born, median age | 5 | ACS | Demand-side: who lives there |
| **Housing (non-price)** | % renter-occupied, % vacant units, housing age (% built before 1960), % moved in last 5 years | 4 | ACS | Supply-side: housing stock condition, rent gap proxy |
| **Employment** | % in service occupations, mean commute time | 2 | ACS | Demand-side: labor market composition |
| **Subsidized housing** | HUD Housing Choice Voucher count per tract | 1 | HUD | Policy constraint on displacement |
| **Zoning** | Dominant zoning class (residential vs. mixed-use vs. commercial), max allowed density | 2 | City data | Supply-side: what *can* be built |
| **Urban signals** | Crime rate, building permit count, 311 complaint count, business license count | 4 | City data | Mixed: urban activity, disinvestment |
| **Transit proximity** | Distance to nearest CTA L station, count of L stations within 800m | 2 | GTFS | Demand-side: accessibility premium |
| **School quality** | Mean school quality rating (test score percentile) of K–12 schools within tract | 1 | NCES | Demand-side: residential choice |
| **Amenity** | Distance to nearest park, distance to nearest university | 2 | City data, IPEDS | Demand-side: amenity valuation |
| **Spatial** | Distance to CBD, population density | 2 | Computed | Spatial context |
| | **Subtotal** | **25** | | |

### Conditionally-included features (definition-dependent)

| Feature | Excluded under | Allowed as feature under |
|---------|---------------|------------------------|
| Median gross rent (T1) | D2, D4 | D1, D3, D5 |
| Median home value (T1) | D2, D4, D5 | D1, D3 |
| % bachelor's degree+ (T1) | D1, D2, D4 | D3, D5 |

Under D3 (income-only), the feature set grows to **28 variables** (25 + rent + home value + education). Under D4 (composite), it stays at **25 variables**. This range is deliberate — it tests whether the conditionally-allowed variables contain genuine predictive signal.

### Feature justifications from the literature

**Transit proximity:** Kahn (2007), examining census tracts near urban rail transit stations in 14 U.S. metropolitan areas, found that "communities receiving increased access to new 'Walk and Ride' stations experience greater gentrification." Bardaka et al. (2019) confirmed transit-induced gentrification along a light rail corridor in Denver.

**School quality:** Yao et al. (2023) found that "the urban network built from tracts and nearby schools shows the most impressive prediction performance," ranking schools among the strongest predictors (arXiv 2312.15646). Most ML gentrification studies omit this feature.

**Spatial lag note:** Any spatial lag features (mean of adjacent tract values) must be computed on *allowed* features only — not on income or rent. We compute spatial lag on vacancy rate and crime rate only, adding 2 features to the always-included set if spatial lag is used.

### Business license SIC code limitations

Business licenses are a better temporal proxy than Yelp but have weaknesses: a license renewal may be indistinguishable from a new license; SIC codes at the 2-digit level do not distinguish between a diner and a farm-to-table restaurant (both SIC 5812); license issuance date ≠ business opening date. We aggregate to total count per tract rather than attempting fine-grained business-type classification.

---

## Sample Size and Statistical Power

### The Events-Per-Variable Problem — Beyond the Rule of Thumb

The widely cited guideline of 10 events per predictor variable (EPV; Peduzzi et al. 1996) has been shown to rest on weak evidence. Van Smeden et al. (2016) demonstrated that "the evidence underlying the EPV = 10 rule as a minimal sample size criterion for binary logistic regression analysis is weak" and that "problems associated with low EPV depend on other factors such as the total sample size" (*BMC Medical Research Methodology* 16: 163). Riley et al. (2019) proposed more principled criteria, requiring that minimum sample size be computed to achieve: "(i) small optimism in predictor effect estimates as defined by a global shrinkage factor of ≥ 0.9, (ii) small absolute difference of ≤ 0.05 in the model's apparent and adjusted Nagelkerke's R², and (iii) precise estimation of the overall risk in the population" (*Statistics in Medicine* 38(7): 1276–1296). They conclude: "rules of thumb (eg, 10 EPP) should be avoided."

### Our Situation

With ~800 Chicago tracts and gentrification prevalence of 10–15%, we expect ~80–120 positive cases. With 25 always-included features (up to 28 under D3), the naïve EPV ratio is **3.2–4.8** under the primary specification. Under D1 (Freeman, which restricts eligibility to central city + older housing stock), positive cases may drop to 40–60, yielding EPV ≈ 1.6–2.4.

This is below any reasonable threshold, including van Smeden et al.'s more permissive findings. Implications:

- Feature importance rankings will be **unstable**. SHAP values on an overfit model are not reliable policy signals.
- Tree-based models (RF, XGBoost) have implicit complexity parameters that interact with sample size. Default hyperparameters will overfit.
- Even L1 regularization, which reduces effective feature count, does not reduce the *search space* — the initial count determines how many spurious associations can be found.

### Mitigations

1. **A priori feature reduction to ~25**: We set the feature count *before* seeing data, not through data-driven selection. The always-included set of 25 features was chosen by theoretical justification and data availability, not by screening. Under the primary specification (D4, 25 features, ~100 positives), EPV ≈ 4 — marginal but workable with regularization. Under definitions yielding fewer than 30 positive cases, we report descriptive statistics only and do not train models.

2. **Compute Riley et al. (2019) minimum sample size** at the outset, using an anticipated Cox-Snell R² estimated from the prior literature's reported AUC values (converting via Nagelkerke's R² approximation). Report whether our sample meets the criterion. If not, state this explicitly as a power limitation.

3. **Standard 5-fold spatial block CV** for performance estimation. We do NOT use nested CV — with ~20 positives per test fold, an inner cross-validation loop for hyperparameter tuning would be fitting to noise. Instead, we use **fixed, conservative hyperparameters** informed by the literature on small-sample tree models (e.g., high `min_samples_leaf`, low `max_depth`, moderate `n_estimators`), or we tune hyperparameters via standard (non-spatial) 3-fold CV on the full training set and report spatial CV performance for the selected model. This is less elegant than nested CV but more honest about what the sample size supports.

4. **Stability analysis**: Run the best model 50 times with different random seeds. Report Spearman rank correlation of SHAP importance rankings across runs. If ρ < 0.7, state this explicitly. Report stability both per-feature and per-correlated-cluster.

5. **Bootstrap CIs (n=1000)**: Report 95% CIs on all metrics. If AUC CI spans > 0.15, interpret as evidence that the sample is insufficient — itself a useful finding.

---

## ML Methods

### Week 1–2: Research Design, Literature Review & Data Audit

- Define all five gentrification operationalizations
- Literature review: focus on Eshtiyagh et al. (2024) meta-synthesis (*CEUS*), Easton et al. (2020) *Urban Studies* measurement review, Bunten et al. (2024) expectations-based measure, NCRC (2025) definition comparison
- Data audit: download ACS 2010–2014 and 2015–2019, verify tract boundary consistency (2010 vintage), confirm variable availability
- Compute gentrification labels under all five definitions; compute agreement matrix (kappa + PABAK with 95% bootstrap CIs)
- Compute EPV ratio and Riley et al. (2019) minimum sample size under each definition
- Eligibility threshold sensitivity (40th, 45th, 50th, 55th percentiles)
- Mutual information audit between all candidate features and label-defining variables

### Week 3–4: Data Collection & Feature Engineering

**Census data pipeline:**
- Pull ACS 5-year estimates for both periods via Census API
- Construct definition-specific feature sets (25 always-included + conditionally-allowed variables per definition)
- Download MOE columns; flag tracts where MOE > 30% of estimate for label-defining variables

**City open data pipeline:**
- Crime incidents (geocoded), building permits, 311 complaints, business licenses with SIC codes (aggregate to count per tract for T1 period, 2010–2014)
- Zoning district boundaries: overlay with tract boundaries via `geopandas`; compute dominant zoning class and max allowable density per tract

**Transit, school, and amenity pipeline:**
- CTA L station locations from GTFS feed; compute distance and count within 800m per tract centroid
- K–12 school locations and quality ratings from NCES ELSI + Illinois state report cards
- Park boundary shapefiles; university locations from IPEDS
- Distance features from each tract centroid

**Geospatial pipeline:**
- Spatial join point data to 2010-vintage TIGER/Line tract boundaries
- Compute spatial lag features on allowed features only (vacancy, crime) using `libpysal`
- Compute distance to CBD for each tract centroid

### Week 5–7: Classification Models

**Models (simplest to most complex):**

| Model | Purpose |
|-------|---------|
| **Spatial proximity heuristic** | "Tracts adjacent to already-gentrified tracts will gentrify." If this baseline performs well, ML adds limited value. |
| **Logistic regression (L1-regularized)** | Interpretable linear baseline; L1 for automatic feature selection. |
| **Random Forest** | Non-linear, handles interactions, standard in the literature |
| **XGBoost** | Gradient boosted trees; typically the strongest tabular classifier |

**Primary specification:** D4 (Composite) + XGBoost + spatial block CV + Chicago. All other combinations are sensitivity analyses.

**Training and evaluation:**
- Use T1 features (definition-specific set) to predict T2 gentrification label
- **Two CV strategies reported side-by-side:**
  - Stratified 5-fold CV (standard, treats tracts as i.i.d.)
  - Spatial block CV: block size set to exceed the empirical spatial autocorrelation range (Moran's I correlogram on top features by L1 coefficient magnitude). Research shows "neglecting spatial autocorrelation during cross-validation leads to an optimistic model performance assessment" with overestimation "by up to 28%" (Karasiak, Dejoux, Monteil & Sheeren 2022, *Machine Learning* 111: 2715–2740).
- Hyperparameters: fixed conservative values (high `min_samples_leaf`, moderate `max_depth`) for the primary analysis. Sensitivity to hyperparameter choice reported via standard 3-fold CV on training data.

**Class imbalance handling:**

We do NOT use SMOTE. "For most data sets, we observe that applying no rebalancing strategy is competitive in terms of predictive performances, with tuned random forests, logistic regression or LightGBM" (Olive, Gadat & Maillard 2024, arXiv 2402.03819).

We train **two versions** of each model:
- (a) **Without class weights**: raw probabilities preserve the true prevalence. Used for probability calibration and risk maps.
- (b) **With `class_weight='balanced'`**: reweighted probabilities. Used for discrimination metrics (AUC-PR, F1).

This separation addresses a subtle interaction: Phelps, Lizotte & Woolford (2024) show that "Platt's scaling should not be used for calibration after undersampling without critical thought" because "the base model's predictions are severely biased" by the reweighting (arXiv 2410.18144). By training a separate unweighted model for calibration, we avoid this pitfall.

**Probability calibration (on the unweighted model only):**
- **Platt scaling** (sigmoid calibration) via `CalibratedClassifierCV(method='sigmoid', cv=3)`. Platt scaling fits only 2 parameters and is appropriate for small calibration sets.
- Report **reliability diagrams** for uncalibrated and calibrated models
- Report **Brier score** (proper scoring rule measuring both discrimination and calibration)

**Metrics:**
- AUC-ROC, AUC-PR, precision, recall, F1 (from weighted model)
- Brier score, reliability diagram (from unweighted + calibrated model)
- All metrics with 95% bootstrap CIs (n=1000)
- Full precision-recall curve (not a single threshold)

### Week 7–8: Feature Separation Experiment & Explainability

This is the core analytical contribution.

**Experiment 1 — Circularity quantification:**
Run models (a) with strict definition-specific separation and (b) with all label-defining variables included as features. The AUC difference quantifies how much prior work's accuracy is inflated by circularity.

**Experiment 2 — Leading indicator test:**
Compare model performance under D3 (income-only, where home value and rent are allowed as features) to D4 (composite, where they are excluded). If home value ranks high in SHAP importance under D3 and D3 outperforms D4 partly due to this feature, then home value is a genuine leading indicator per Bunten et al.'s theory — not circularity.

**Experiment 3 — Racial composition ablation:**
Run with and without racial features (% White, % Black, % Hispanic). If performance drops substantially, the model may be using racial composition as a proxy for the eligibility criterion (low-income tracts in Chicago are disproportionately Black). Report the AUC difference and discuss in the ethics section.

**Experiment 4 — Supply-side vs. demand-side ablation:**
Run with (a) supply-side features only (zoning, vacancy, housing age, building permits), (b) demand-side features only (demographics, transit, schools), and (c) both. This tests whether Smith's (1979) rent gap framework adds predictive value beyond demographics.

**SHAP analysis (with collinearity audit):**
- Compute pairwise Pearson correlation matrix. Group features with |r| > 0.7 into correlated clusters.
- Report SHAP importance both per-feature and per-cluster (summing absolute SHAP values within each cluster). This addresses the known "first-mover bias" in gradient boosting where "gradient boosting creates a self-reinforcing advantage for whichever feature is selected first" among correlated candidates (arXiv 2603.22346).
- Expected correlated clusters: {% renter, housing age, vacancy}; {% foreign-born, % Hispanic}; {crime, 311 complaints}; {transit proximity, distance to CBD}.
- SHAP reported only for definitions with EPV ≥ 3. For others, labeled as exploratory.

**Failure analysis:**
Which tracts are systematically mispredicted across all models and definitions? Do they cluster in high-foreclosure areas (Great Recession confound)? This reveals the limits of prediction from census data.

### Week 8–9: Spatial Analysis & Visualization

- Map predicted gentrification risk using calibrated probabilities (`folium` or `plotly`)
- Map consensus tracts (flagged under all 5 definitions) vs. contested tracts
- Overlay with racial composition to show which communities are most at risk
- Compare spatial CV vs. standard CV predictions — where do they diverge?
- Partial dependence plots for key features (vacancy, transit proximity, home value under D3)

### Week 9–10: Paper Writing

- ~15–20 pages with maps, SHAP plots, model comparison tables, definition agreement matrix
- Primary specification results in main text; sensitivity analyses in appendix
- Structured around two findings: (1) circularity quantification, (2) definition sensitivity
- Explicit limitations section
- Ethics discussion (see below)

---

## Team Task Allocation

| Person | Responsibility |
|--------|---------------|
| **Student A** | Census API data extraction, ACS MOE analysis, mutual information audit, definition-specific feature set construction. Weeks 3–4: transit/amenity/school pipeline (GTFS, parks, universities, NCES). |
| **Student B** | City open data pipeline (crime, permits, 311, business licenses, zoning) — geocoding, temporal filtering, tract-level aggregation via spatial join. |
| **Student C** | ML modeling: spatial block CV, model comparison, SHAP with collinearity audit, probability calibration, ablation experiments, map visualization. |
| **Anna** | Research design, gentrification definition comparison, literature framing, agreement analysis, paper writing, ethics section. Feature-label separation taxonomy. |

---

## Risks, Unknowns & Open Problems

### Known Risks

| Risk | Severity | Mitigation |
|------|----------|-----------|
| **Gentrification definition is contested — no ground truth exists** | High | We do not resolve this. We make it the subject of analysis: testing five definitions and reporting where they agree. |
| **Feature-label separation may substantially reduce accuracy** | High | This is the point. If accuracy drops sharply, prior work was inflated. If it holds, genuine signals exist. Either result is the primary finding. |
| **Sample size is small (~800 tracts, ~80–120 positive cases)** | High | EPV ≈ 3–5 is marginal. Mitigated by a priori feature count of ~25, Riley et al. minimum sample size computation, conservative hyperparameters, stability analysis. If performance is poor or unstable, this is a finding about the limits of tract-level ML. |
| **Single temporal transition — no out-of-time validation** | High | We have one time step (2010–2014 → 2015–2019). The model may learn recession-recovery features, not gentrification features. Flagged as the most important limitation and highest-priority extension. |
| **Great Recession confound in T1 baseline** | High | Income growth partly reflects recovery. Definitions comparing to metro growth partially control for this. Failure analysis examines clustering in high-foreclosure areas. |
| **No physical/visual change data** | High | A growing literature shows property-level visual changes precede census-detectable shifts (Thackway et al. 2023; Alfaro et al. 2025). Acknowledged as scope limitation. |
| **Spatial autocorrelation inflates standard CV** | Medium | Report both standard and spatial block CV. If the gap is large, this warns the field. |
| **ACS margins of error are large at tract level** | Medium | Download and report MOEs. Flag and optionally exclude high-MOE tracts. |
| **SHAP unreliable under multicollinearity** | Medium | Report per-cluster SHAP (grouped by \|r\| > 0.7) alongside per-feature. Stability analysis across 50 seeds. |
| **MAUP — tracts ≠ lived neighborhoods** | Medium | Census boundaries are arbitrary. We cannot resolve this but acknowledge it. Block-group sensitivity check if time permits. |
| **Spatial proximity baseline may outperform ML** | Medium | If gentrification is primarily spatial diffusion (Hwang & Sampson 2014), ML adds limited value. This would be a genuine negative result. |
| **Single city limits generalizability** | Medium | Chicago is post-industrial, highly segregated, population-stagnant. Results may not transfer to Sunbelt or West Coast cities. Baltimore flagged as first extension. |

### Unknown Factors

| Unknown | Implication |
|---------|-------------|
| **How much accuracy comes from circularity?** | We don't know until we run the feature-separation experiment. The gap is itself the primary research finding. |
| **What is the base rate under each definition?** | Prevalence determines class imbalance, EPV, and all metrics. Must be computed before modeling. |
| **Do genuine early-warning signals exist in census data?** | If the spatial proximity baseline outperforms ML, gentrification is a diffusion process, not predictable from demographic features. |
| **Is home value a genuine leading indicator or a mechanical correlate?** | The D3 vs. D4 comparison is designed to answer this. If home value ranks high under D3 (where it's allowed), Bunten et al.'s expectations theory is supported. |
| **Does the rent gap framework add predictive value?** | The supply-side vs. demand-side ablation tests this. If zoning and vacancy add nothing, Smith's (1979) theory doesn't manifest at this scale — or our proxies are too crude. |
| **Are SHAP rankings stable?** | 50-seed stability analysis answers this. If Spearman ρ < 0.7, SHAP plots should not guide policy. |
| **How large is the spatial CV inflation?** | Literature suggests up to 28% (Karasiak et al. 2022). Actual magnitude depends on our data's spatial structure. |
| **Can the model distinguish gentrification from recession recovery?** | Probably not without a second temporal period. This is the most fundamental inferential limitation. |

---

## Ethical Considerations

### Dual-Use Risk

Rachel Weber (University of Illinois–Chicago) warned at the 2019 Urban Displacement Project symposium that "in some cases, predictions become self-fulfilling prophecies." A gentrification risk map could be used by real estate speculators to identify and front-run neighborhood change — *accelerating* the very process the model claims to predict.

We can:
- Frame the paper explicitly around community protection
- Discuss dual-use risk in the ethics section
- Avoid publishing tract-level interactive prediction maps without access controls
- Recommend the model be used with community input, not as a standalone tool

### Prediction ≠ Prescription

SHAP values show feature *importance*, not causal mechanisms. "Building permit density predicts gentrification" does not mean permits *cause* gentrification. Policymakers should not use this model to restrict permits.

### Racial Features

If racial composition is a top predictor, it must be interpreted with care. Racial composition at T1 may proxy for structural disadvantage (redlining, disinvestment) that creates conditions for gentrification, not a causal mechanism. The racial ablation analysis (Experiment 3) tests this directly.

### Ecological Fallacy

All findings are tract-level. We cannot infer who moves, who stays, who benefits, who is harmed. A tract that "gentrifies" may have experienced new construction on vacant land, in-situ income growth, or population replacement — our data cannot distinguish these.

---

## Prior Work & Positioning

| Study | Method | Key Result | How We Differ |
|-------|--------|------------|---------------|
| Census Bureau WP 2023 | RF, Washington D.C. | 83% accuracy | Uses AHS unit-level data; no feature-label separation. We test whether accuracy holds under strict separation. |
| SSRN 3911354 (2021) | ACS + Zillow + HUD, tree models | 74% accuracy | Uses Zillow ZIP-level data (noisy crosswalk). Single definition. No spatial CV. |
| Yao et al. (2023) | GNN + satellite + socioeconomic | 0.9 AUC | More complex model; found schools among strongest predictors. We incorporate school quality with cleaner feature separation. |
| Gardiner & Dong (2021) | RF + mobility networks, NYC | Significant improvement from network features | Uses taxi data. We flag LODES as future extension rather than adding underspecified network features at low EPV. |
| Thackway et al. (2023) | RF + SHAP + Siamese CNN, Sydney | 74.7% balanced accuracy | Single city, single definition, no spatial CV. We add definition sensitivity and spatial CV but lack visual features. |
| Bunten, Preis & Aron-Dine (2024) | Expectations-based measure | House-value/income gap predicts income growth | We incorporate their measure as D5 and test home value as a leading indicator under income-only definitions. |
| NCRC & Univ. of Michigan (2025) | ROC analysis of definitions | "NCRC and Ding methods have slightly greater validity" | They compare definitions against observable changes. We compare how definitions affect *prediction model* performance — complementary approaches. |
| Eshtiyagh et al. (2024) | Meta-synthesis, *CEUS* | Identified data quality and black-box challenges | Our feature separation and definition sensitivity directly address their identified gaps. |

### Our Contribution (What's New)

No prior study we identified implements **definition-specific feature-label separation** — allowing a variable to serve as feature under one definition while being excluded under another, thereby testing whether it is a genuine leading indicator or a mechanical artifact. This design, combined with the Bunten et al. (2024) expectations framework, yields a clean test of the circularity problem that blanket exclusion cannot provide.

Our definition sensitivity analysis extends the NCRC (2025) comparison by asking not just "which definition is most valid?" but "does the model learn different features under different definitions?" — connecting measurement choices to predictive mechanisms.

---

## Publication Targets

| Journal | Fit | Notes |
|---------|-----|-------|
| *Environment and Planning B* | ⭐⭐⭐⭐⭐ | Urban analytics + ML + policy |
| *Computers, Environment and Urban Systems* | ⭐⭐⭐⭐⭐ | Published 2024 meta-synthesis on this topic |
| *Housing Policy Debate* | ⭐⭐⭐⭐ | Definition sensitivity and ethics angle |
| *Urban Studies* | ⭐⭐⭐⭐ | Published Bunten et al. (2024) and Easton et al. (2020) |
| arXiv pre-print | ⭐⭐⭐⭐⭐ | Immediate visibility |

---

## Week-by-Week Schedule

| Week | Activities | Deliverable |
|------|-----------|-------------|
| 1 | Literature review (Smith 1979, Bunten et al. 2024, NCRC 2025, Eshtiyagh et al. 2024). Define five operationalizations. Data availability audit. | Annotated bibliography, variable taxonomy document |
| 2 | ACS download (both periods), boundary verification. Compute labels under all 5 definitions. Agreement matrix (kappa + PABAK + CIs). EPV + Riley et al. sample size under each definition. MI audit. Eligibility threshold sensitivity. | Label dataset, agreement table, EPV/Riley report, MI audit |
| 3 | City open data download (crime, permits, 311, business licenses, zoning). Geocode to tracts. Temporal filter to T1. | City features dataset |
| 4 | Transit/school/amenity pipeline (GTFS, NCES, parks, IPEDS). Feature engineering: spatial lag (allowed features only), distance features. Merge all datasets. Handle missing data. Flag high-MOE tracts. | Merged analysis-ready dataset (~25–28 features) |
| 5 | Spatial proximity baseline + L1 logistic regression. Moran's I correlogram for block CV size. Feature correlation matrix. | Baseline performance, autocorrelation range, correlation matrix |
| 6 | RF + XGBoost with 5-fold spatial block CV + 5-fold standard CV. Conservative hyperparameters. Probability calibration (Platt scaling on unweighted model). Primary specification (D4 + Chicago) first. | Primary results table, reliability diagram, Brier scores |
| 7 | Feature separation experiment (with vs. without label-defining variables). D3 vs. D4 leading-indicator comparison. Supply/demand ablation. Racial ablation. SHAP with collinearity clustering + 50-seed stability. | Circularity analysis figure, ablation tables, SHAP summary |
| 8 | Sensitivity: D1, D2, D3, D5 results. Failure analysis of mispredicted tracts. Great Recession clustering check. | Sensitivity tables, misprediction analysis |
| 9 | Maps: calibrated risk, consensus vs. contested tracts, demographic overlay, spatial CV divergence. Partial dependence plots. | Folium/plotly maps |
| 10 | Paper writing: introduction, methods, results (primary + appendix), limitations, ethics. | Draft manuscript (~15–20 pages + appendix) |

---

## Key References

- Alfaro, Šćepanović, Law & Quercia (2025). "Gentrification from the Sky." In: *Digital-Era Urban Transformations*. Springer, pp. 199–225.
- Bardaka, Herring & Kaza (2019). "A Tale of Two Light Rail Transit Lines." *Transport Policy* 80: 122–134.
- Brummet & Reed (2019). "The Effects of Gentrification on the Well-Being and Opportunity of Original Resident Adults and Children." FRB Philadelphia WP 19-30.
- Bunten, Preis & Aron-Dine (2024). "Re-measuring gentrification." *Urban Studies* 61(1): 20–39.
- Byrt, Bishop & Carlin (1993). "Bias, prevalence and kappa." *J Clinical Epidemiology* 46(5): 423–429.
- Census Bureau WP SEHSD-WP-2023-15 (2023). "Identifying gentrification using machine learning."
- Desmond, An & Xiang (2023). "Beyond Gentrification: Housing Loss, Poverty, and the Geography of Eviction." *Social Problems*.
- Ding, Hwang & Divringi (2016). "Gentrification and Residential Mobility in Philadelphia." FRB Philadelphia WP 16-14.
- Easton, Lees, Hubbard & Tate (2020). "Measuring and mapping displacement." *Urban Studies* 57(2): 286–306.
- Eshtiyagh et al. (2024). "Application of machine learning in understanding urban neighborhood gentrification." *CEUS*.
- Freeman (2005). "Displacement or Succession?" *Urban Affairs Review* 40(4): 463–491.
- Gardiner & Dong (2021). "Mobility Networks for Predicting Gentrification." *Complex Networks & Their Applications IX*. Springer.
- Hwang & Sampson (2014). "Divergent Pathways of Gentrification." *American Sociological Review* 79(4): 726–751.
- Ilic, Sawada & Zarzelli (2019). "Deep mapping gentrification." *PLOS ONE* 14(3): e0212814.
- Kahn (2007). "Gentrification Trends in New Transit-Oriented Communities." *Real Estate Economics* 35(2): 155–182.
- Karasiak, Dejoux, Monteil & Sheeren (2022). "Spatial dependence between training and test sets." *Machine Learning* 111: 2715–2740.
- Ley (1986). "Alternative Explanations for Inner-City Gentrification." *Annals of the AAG* 76(4): 521–535.
- Li et al. (2019). "A comparison of the approaches for gentrification identification." *Cities* 95.
- NCRC & University of Michigan (2025). "Does gentrification push people out? The answer depends on how it is measured." *Journal of Urban Affairs*.
- Newman & Wyly (2006). "The Right to Stay Put, Revisited." *Urban Studies* 43(1): 23–57.
- Olive, Gadat & Maillard (2024). "Do we need rebalancing strategies?" arXiv 2402.03819.
- Peduzzi, Concato, Kemper, Holford & Feinstein (1996). "A simulation study of the number of events per variable." *J Clinical Epidemiology* 49(12): 1373–1379.
- Phelps, Lizotte & Woolford (2024). "Using Platt's scaling for calibration after undersampling — limitations and how to address them." arXiv 2410.18144.
- Riley, Snell, Ensor, Burke, Harrell, Moons & Collins (2019). "Minimum sample size for developing a multivariable prediction model." *Statistics in Medicine* 38(7): 1276–1296.
- Rucks-Ahidiana (2021). "Theorizing Gentrification as a Process of Racial Capitalism." *City & Community* 21(3): 173–192.
- Smith (1979). "Toward a Theory of Gentrification." *JAPA* 45: 538–548.
- Thackway, Ng, Lee & Pettit (2023). "Gentrification Prediction Using Machine Learning." *Cities* 138: 104344.
- Van Smeden, de Groot, Moons, Collins, Altman, Robroek, Groenwold & Reitsma (2016). "No rationale for 1 variable per 10 events criterion for binary logistic prediction models." *BMC Medical Research Methodology* 16: 163.
- Weber (2019). Comments at UDP Symposium on predictive models as "self-fulfilling prophecies."
- Yao, Hua, Xie, Qian & Wei (2023). "A graph-based multimodal framework to predict gentrification." arXiv 2312.15646.

---

## Why This Project Wins

- **Directly builds on Anna's existing research** — census tract-level data in Chicago, using tools she already knows
- **Focused contribution**: definition-specific feature-label separation is a clean, novel methodological idea that no prior study implements
- **Theoretically grounded**: integrates demand-side (Ley 1986), supply-side (Smith 1979), and expectations-based (Bunten et al. 2024) frameworks — not atheoretical variable selection
- **Either result is publishable**: if accuracy holds under separation → genuine early-warning signals exist; if it drops → prior work was inflated by circularity. The D3 vs. D4 comparison isolates whether home value is a leading indicator or a mechanical artifact.
- **Feasible in 10 weeks**: one city, ~25 features, four experiments, one paper. Not seven contributions done partially.
- **Methodologically honest**: EPV computed via Riley et al. (2019) criteria, spatial CV calibrated to autocorrelation range, calibration done on unweighted model per Phelps et al. (2024), SHAP reported with collinearity audit and stability check
- **All data is public and free**: Census API, city open data portals, NCES, GTFS — no scraping, no API-dependent features
- **Limitations stated openly**: single temporal transition, Great Recession confound, ecological fallacy, MAUP, EPV constraints, no visual data, single city
