# Proposal 3: Predicting Neighborhood Socioeconomic Upgrading — Machine Learning for Gentrification Early Warning Using Census and Urban Data

## Summary

Gentrification — the socioeconomic upgrading of previously low-income neighborhoods — poses risks to incumbent residents in major US cities. Current identification methods are backward-looking: they detect gentrification only *after* Census data records the change. Can ML predict which census tracts will undergo socioeconomic upgrading *before* it happens, giving policymakers time to intervene?

We build a tract-level classification model using publicly available Census, housing, crime, transit, zoning, commuting, and business license data for Chicago and Baltimore. The project makes four methodological contributions that address known weaknesses in prior work:

1. **Feature-label separation**: we strictly exclude label-defining ACS variables — and their mechanical correlates — from the input feature set, eliminating the circularity that inflates reported accuracy in existing studies.
2. **Definition sensitivity analysis**: we systematically test how model performance and tract classification vary across four operationalizations of gentrification (Freeman 2005; Ding, Hwang & Divringi 2016; income-only; rent-only), quantifying disagreement between definitions.
3. **Spatial cross-validation**: we report performance under both standard k-fold and spatial block CV calibrated to the empirical spatial autocorrelation range, exposing the degree to which spatial autocorrelation inflates metrics.
4. **Probability calibration**: we calibrate predicted probabilities and report reliability diagrams, ensuring the risk maps are actionable for policymakers — not just rank-ordered but meaningfully scaled.

### Important Framing Note

We predict *socioeconomic upgrading*, not *displacement*. The relationship between gentrification and displacement is empirically contested. Freeman (2005) found "little evidence that gentrification is associated with displacement on the aggregate metropolitan level." Desmond, An & Xiang (2023), analyzing eviction records across 72 US metros, found that "eviction rates were lower at the end of the period in gentrifying neighborhoods, and they fell more over time in such spaces." Conversely, ethnographic research consistently documents displacement as lived experience (Newman & Wyly 2006; Betancur 2011). This project predicts neighborhood *change*, not resident-level *outcomes*. We state this limitation explicitly throughout.

This distinction is not merely rhetorical — it reflects a fundamental methodological constraint. Tract-level averages can shift without any individual being displaced: new construction on vacant lots adds high-income units while existing residents remain. This is the ecological fallacy applied to neighborhood change: aggregate-level trends cannot be decomposed into individual-level processes without individual-level data. As Brummet & Reed (2019) showed using linked Census microdata, "incumbent residents are not displaced at elevated rates during gentrification," suggesting that tract-level income change partly reflects in-situ upgrading and new construction rather than population replacement. Our model operates entirely at the aggregate level and cannot distinguish between these mechanisms.

## Why Anna

Her Cornell research (Jan–Dec 2024) was census tract-level analysis of crime and demographics in Chicago and Baltimore using shapefiles and Census data. She already knows ACS variables, tract-level geography, and spatial joins. This project extends her existing competency into ML and adds a policy-relevant prediction angle. She does not need to learn the domain; she needs to learn the methods.

---

## Theoretical Framing: Demand-Side and Supply-Side Predictors

Gentrification theory divides into two explanatory camps. **Demand-side** theories (Ley 1986, 1996) emphasize the preferences and movements of a new middle class — educated professionals who value urban amenities, walkability, transit access, and cultural diversity. **Supply-side** theories, principally Neil Smith's **rent gap theory** (Smith 1979), argue that gentrification occurs where the gap between current capitalized land rent and potential land rent is largest: "gentrification is an expected product of the relatively unhampered operation of the land and housing markets. The economic depreciation of capital invested in nineteenth century inner-city neighborhoods and the simultaneous rise in potential ground rent levels produces the possibility of profitable redevelopment" (Smith, "Toward a Theory of Gentrification: A Back to the City Movement by Capital, not People," *Journal of the American Planning Association* 45: 538–548, 1979).

Both mechanisms operate simultaneously. Our feature set is structured to capture both:

- **Demand-side signals**: demographic composition, transit proximity, amenity access, school quality, commuting patterns — who might move in and why
- **Supply-side signals**: vacancy rates, housing age, building permits, zoning classification — where reinvestment is structurally possible and where the rent gap is widest

Most ML gentrification studies draw features almost exclusively from demand-side indicators (demographics, income, education). By adding zoning classification, vacancy, and housing-age features as explicit supply-side proxies for the rent gap, we test whether supply-side conditions improve prediction beyond demographic composition alone.

---

## Data Sources (All Publicly Accessible)

| Source | What | Geography | Temporal Coverage | Access |
|--------|------|-----------|-------------------|--------|
| **ACS 5-Year Estimates** | Demographics, income, education, rent, housing value, poverty rate | Census tract | 2010–2014 (T1), 2015–2019 (T2) | Census API via `cenpy` or `census` Python package |
| **HUD Housing Choice Vouchers** | Subsidized housing counts by tract | Census tract | Annual | huduser.gov — free download |
| **LEHD LODES** | Origin-destination commuting flows, worker characteristics by tract | Census block (aggregable to tract) | 2002–2019 | lehd.ces.census.gov — free download |
| **City Open Data — Chicago** | Crime incidents, building permits, 311 complaints, **business licenses** (with SIC/NAICS codes and issue dates), **zoning districts** | Point/polygon data, geocoded to tract | 2001–present | data.cityofchicago.org — API |
| **City Open Data — Baltimore** | Crime, code violations, demolitions, vacant buildings, **business licenses**, **zoning** | Point/polygon data, geocoded to tract | Varies by dataset | data.baltimorecity.gov — API |
| **TIGER/Line Shapefiles** | Census tract boundary files (2010 vintage) | Census tract | 2010 boundaries | census.gov/geographies — free download |
| **CTA / MTA GTFS Feeds** | Transit station locations (rail, bus rapid transit) | Point data | Historical archives available | transitfeeds.com, CTA/MTA open data portals |
| **City park shapefiles** | Park boundaries and locations | Polygon data | Current (stable over study period) | Chicago / Baltimore open data portals |
| **NCES / State Education Data** | School locations, school quality ratings (test score percentiles) | Point data (school locations) | Annual | nces.ed.gov (ELSI), Illinois/Maryland state report cards |

### Data Sources Removed (with justification)

| Source | Why Removed |
|--------|-------------|
| **Zillow ZHVI** | Reported at ZIP code level. ZIP codes are mail delivery routes, not geographic areas: "ZIP Codes are actually not areas with defined boundaries, and there are no official USPS ZIP Code maps" (Frank Donnelly, "The Trouble with ZIP Codes," 2020). The HUD ZIP-to-tract crosswalk is many-to-many and introduces systematic measurement error. ACS already provides median home value at the tract level — adding a noisier version of the same variable through a lossy crosswalk degrades data quality. |
| **Yelp / Google Places API** | Yelp Fusion API returns only *current* business listings. Historical business composition (e.g., what existed in 2010–2014) cannot be retrieved. Using present-day data as T1 features would constitute textbook temporal leakage — the coffee shops visible today exist *because* gentrification already occurred. Chicago's open data portal provides **historical business licenses** with issue dates and SIC codes, which serves as a better archival substitute (see limitations in the Feature Engineering section). |
| **Google Street View / Satellite Imagery** | A growing body of work uses computer vision on Street View imagery to detect gentrification-related physical changes (Thackway et al. 2023, Siamese CNN on GSV in Sydney; Ilic et al. 2019, "Deep Mapping" in Ottawa achieving 95.6% accuracy on visual property upgrades; Alfaro et al. 2025, "Gentrification from the Sky" using satellite imagery in London). Physical changes to buildings are *leading indicators* that precede census-detectable demographic shifts. However, training and deploying a CNN on historical GSV imagery is infeasible within a 10-week scope and would shift the project from a methods contribution on feature separation and definition sensitivity to a computer vision project. We flag computer vision integration as the second-highest priority future extension (after temporal validation). |

### Why 2010–2014 → 2015–2019 (not 2013–2017 → 2018–2022)

The U.S. Census Bureau "strongly recommends against comparing estimates in overlapping 5-year periods since much of the data in each estimate are the same" (Census Bureau, "Period Estimates in the American Community Survey," 2022). Our selected periods (2010–2014 and 2015–2019) share zero overlapping years.

Equally important: both periods use **2010-vintage census tract boundaries**. The 2020 ACS (2018–2022) switches to 2020-vintage boundaries, where tracts are split, merged, and renumbered. A naive FIPS-code join across boundary vintages silently drops or mismatches tracts, producing corrupt labels. By keeping both periods within the 2010 decennial, we avoid the need for NHGIS boundary harmonization crosswalks or LTDB areal interpolation — a process that can consume 1–2 weeks and introduces its own errors.

### The Great Recession Confound

Our T1 baseline (2010–2014) is not a neutral starting point. It captures the aftermath of the worst U.S. recession since the 1930s. The NLIHC reported that "between 2000 and the 2010-2014 ACS period, 2,151 additional neighborhoods met the definition of an extremely poor neighborhood" (NLIHC, 2018). Research on Chicago gentrification from this period notes: "The 2006/2010 period included both the last year of the early 21st-century boom and the low point of the Great Recession, while the 2011/2015 period was generally one of recovery from that low point" (Hertz, *Liberal Landscape*, 2017).

Income growth from 2010–2014 to 2015–2019 partly measures **recession recovery**, not gentrification. Tracts hit hardest by the recession (high foreclosure, high unemployment) will mechanically show the most income recovery — which looks exactly like gentrification under all four definitions. The model may learn "features correlated with recession vulnerability" rather than "features correlated with gentrification susceptibility."

**Compounding macroeconomic context:** The study period saw historically low interest rates (federal funds rate near zero through 2015, rising gradually to ~2.4% by end of 2019). Low mortgage rates reduced the cost of buying into lower-income neighborhoods, potentially accelerating capital inflows into rent-gap neighborhoods. This macro-credit channel is unobservable at the tract level and applies uniformly to all tracts, but its interaction with local conditions (e.g., vacancy, zoning capacity) is not uniform.

**Mitigation.** We cannot fully resolve this with available data. We can:
- Acknowledge it explicitly in the paper's limitations as a temporal confound
- Examine whether mispredicted tracts cluster in areas of known high foreclosure distress
- Compare our feature importance rankings against the literature from non-recessionary periods to check for anomalies
- Note that the comparison to *metro-level* growth in all four definitions partially (but not fully) controls for economy-wide recovery, since the metro also recovered

**Ideal but infeasible within 10 weeks:** Adding a second temporal period (2000 → 2006–2010 using decennial census + early ACS) would allow out-of-time validation and disentangle recession recovery from gentrification. We flag this as the highest-priority extension for future work.

### Inflation Adjustment

ACS reports median income, rent, and home value in nominal (current-year) dollars. CPI-U increased approximately 7% between 2012 and 2017 (the midpoints of our two ACS windows), from ~229.6 to ~245.1 (Bureau of Labor Statistics, CPI-U Annual Averages). A tract whose nominal median income grew 7% experienced zero real growth.

All four gentrification definitions compare tract-level growth to metro-level growth over the same period. Since both numerator and denominator are in nominal dollars and cover the same time span, inflation cancels in the relative comparison. However, we make this assumption explicit: **our definitions measure relative upgrading (tract growth vs. metro growth), not absolute real income change.** We report all growth rates in nominal terms alongside the CPI adjustment factor so readers can verify.

---

## Gentrification Definition (Operationalization)

### The Problem

There is no consensus definition. "No agreed-upon definition has become paradigmatic, and it is rare for a study to replicate a previously employed definition. This makes it difficult to assess whether findings of a given study reflect how gentrification was operationalized" (Desmond, An & Xiang 2023, analyzing eviction-gentrification links across 72 metros). Galster and Peacock (1986) showed that "variable selection had a significant impact on which, and how many, census tract areas were defined as neighbourhoods undergoing gentrification" (cited in Easton et al. 2020, *Urban Studies*).

The binary threshold approach is further "criticized for the arbitrariness of the thresholds" (Li et al. 2019, *Cities*). Recent work proposes continuous measures: "I use structural equation modeling to create a continuous measure of gentrification and incorporate it into regression models. I view gentrification itself as a latent variable, comprised of several observed indicators" (*Social Problems*, 2024). The UC Berkeley Urban Displacement Project (UDP) has developed a widely adopted neighborhood change typology used by policymakers in the Bay Area and replicated in multiple US metros (Chapple & Zuk 2016; Gardiner & Dong 2021 use UDP labels for their NYC prediction study). Our approach is complementary: rather than adopting UDP's specific typology, we test four definitions and measure where they agree.

### Our Approach: Four Definitions, Compared

Rather than choosing one definition and hoping reviewers agree, we run the full pipeline under **four** operationalizations and report where they agree and disagree. This is itself a contribution — most studies use a single definition.

| ID | Name | Criteria | Source |
|----|------|----------|--------|
| **D1** | Freeman (2005) | Tract is (a) in central city (defined as Census-designated principal city of the CBSA), (b) median income < metro median at T1, (c) proportion of housing built in prior 20 years is below metro median at T1 (disinvestment proxy), (d) increase in educational attainment > metro increase T1→T2 | Freeman (2005), "Displacement or Succession?" *Urban Affairs Review* 40(4): 463–491. |
| **D2** | Ding-Hwang-Divringi (2016) | Tract median income < metro median at T1, AND increase above metro median increase in *either* median gross rent *or* median home value, AND increase in college-educated share > metro increase | Ding, Hwang & Divringi (2016), Federal Reserve Bank of Philadelphia Working Paper 16-14. |
| **D3** | Income-only | Tract median income < metro median at T1, AND tract income growth > metro income growth T1→T2 | Simplified baseline |
| **D4** | Composite (income + rent + education) | All of: (a) tract median income < metro median at T1, (b) income growth > metro growth, (c) rent or home value growth > metro growth, (d) education share increase > metro increase | Adapted from Rucks-Ahidiana (2021), NCRC (2020). |

**Primary specification:** D4 (Composite) serves as the primary definition for the main results. D1–D3 are reported in the sensitivity analysis. This avoids drowning the paper in a 4×4×2 results matrix while still demonstrating definition sensitivity.

**Clarification on D1 "central city":** Freeman's original definition restricts eligible tracts to the "central city." We operationalize this as the Census Bureau's principal city designation within the CBSA — for Chicago-Naperville-Elgin, this is the City of Chicago municipal boundary; for Baltimore-Columbia-Towson, the City of Baltimore boundary. This excludes inner-ring suburban tracts (e.g., Evanston, Cicero) that may be experiencing gentrification-like upgrading. We report how many eligible tracts D1 excludes relative to D2–D4 and whether the spatial pattern of D1-classified tracts differs qualitatively from the other definitions.

For each definition, we report:
- Number of tracts classified as gentrifying (prevalence)
- Agreement between all definition pairs using both **Cohen's kappa** and **prevalence-adjusted bias-adjusted kappa (PABAK)** (Byrt, Bishop & Carlin 1993). Standard kappa is sensitive to prevalence — two definitions can show low kappa simply because one classifies 5% and the other 25% of tracts. PABAK corrects for this. We report **95% bootstrap CIs (n=1000) on kappa and PABAK** to quantify uncertainty.
- How model performance (AUC, F1) changes across definitions
- Which tracts are classified as gentrifying under *all* definitions vs. only some (consensus vs. contested tracts)

**Eligibility threshold sensitivity:** All four definitions use "income < metro median" as the eligibility criterion. This is a knife-edge threshold: a tract at the 49th percentile is eligible; at the 51st percentile, it is not. We test sensitivity to this threshold by recomputing prevalence and model performance at the 40th, 45th, 50th, and 55th percentiles. If prevalence and classification change substantially with small threshold shifts, this demonstrates the fragility of binary definitions — a finding that supports the call for continuous measures in the literature.

**Comparability caveat:** AUC and F1 computed under different definitions are measuring different classification tasks, not the same task with different models. A model scoring 0.80 AUC on D1 (5% prevalence) is not directly comparable to 0.75 AUC on D3 (25% prevalence). We compare *within*-definition performance across models, and report the *direction* of performance changes across definitions, but do not rank definitions by AUC.

---

## The Feature-Label Separation Problem (Key Methodological Contribution)

### The Circularity in Existing Work

In prior studies (Census Bureau 2023; SSRN 3911354), the gentrification label is constructed from ACS variables (income, rent, home value, education), and the *same variables* at T1 are used as input features. The model then learns: "given income/rent/education at T1, predict whether income/rent/education will change faster than average by T2." This is partly regression-to-the-mean detection — low-income tracts mechanically satisfy the eligibility criterion, and the model exploits the mechanical coupling between T1 levels and T1→T2 changes.

### Our Solution: Strict Feature Pools With Information-Theoretic Audit

We partition variables into two mutually exclusive sets:

**Label-defining variables** (used ONLY to construct the gentrification label, never as input features):
- Median household income
- Median gross rent
- Median home value
- % adults with bachelor's degree or higher

**Income-proximate variables** (excluded from both labels and features due to mechanical correlation with label-defining variables):
- **Poverty rate** — defined by the Census Bureau as family income relative to the poverty threshold (Census Bureau, "How the Census Bureau Measures Poverty," 2023). It is a direct monotonic transform of income: "POVERTY is calculated by comparing the value of FTOTINC to the family's poverty threshold" (IPUMS USA, variable description for POVERTY). Including poverty rate while excluding income would allow the model to reconstruct the excluded information.
- **% receiving public assistance** — eligibility for public assistance programs (TANF, SNAP) is income-tested. Tract-level public assistance rates are mechanically inversely correlated with tract-level income.
- **Unemployment rate** — strongly correlated with tract-level income and poverty at the aggregate level, though the relationship is not definitional.

This is a critical correction to the naive feature-label separation approach. Excluding median income from features but including poverty rate — which is income measured on a different scale — would launder the excluded variable back into the model under a different name.

### Dual Mutual Information Audit

Before modeling, we compute mutual information (MI) in two ways:

1. **MI(feature at T1, label-defining variable at T1):** This catches mechanical proxies — features that reconstruct the excluded income/rent/education information under a different name. Any feature with MI exceeding a threshold (calibrated by permutation testing at α=0.05) is flagged, and its inclusion is tested in ablation. This provides an empirical audit of the separation rather than relying solely on domain judgment about which variables are "too close" to income.

2. **MI(feature at T1, binary gentrification label):** This catches features that are suspiciously predictive of the outcome itself. A feature with high MI against the label but low MI against the label-defining variables at T1 may be exploiting an unmeasured channel (e.g., a proxy for T1→T2 *change* rather than T1 *levels*). Features flagged by this second audit are not automatically excluded — they may be legitimately predictive — but they are investigated and discussed. The distinction matters because the first audit catches proxies for the eligibility criterion (low T1 income), while the second catches proxies for the outcome conditional on eligibility.

**Note on restricted range:** MI calculations under audit (1) are computed on the eligible-to-gentrify subsample (low-income tracts only). The restricted income range in this subsample may compress MI estimates for income proxies, making them harder to detect. We mitigate this by computing MI both on the full sample and on the eligible subsample and flagging features that show divergent behavior.

**Predictive features** (used ONLY as model inputs, never in label construction):

| Category | Features | Source | Theoretical Role |
|----------|----------|--------|-----------------|
| **Demographics** | % White, % Black, % Hispanic, % foreign-born, median age, population change, household size | ACS | Demand-side: who lives there |
| **Housing (non-price)** | % renter-occupied, % vacant units, housing age (% built before 1960), % moved in last 5 years (residential turnover) | ACS | Supply-side: housing stock condition, rent gap proxy |
| **Employment** | % in service occupations, mean commute time | ACS | Demand-side: labor market composition |
| **Subsidized housing** | HUD Housing Choice Voucher count per tract | HUD | Supply-side: policy constraint on displacement |
| **Zoning** | Dominant zoning class (residential-only vs. mixed-use vs. commercial), maximum allowed density (FAR or units/acre where available) | City open data (Chicago, Baltimore) | Supply-side: structural constraint on what *can* be built. A tract zoned single-family-only cannot densify through new multifamily construction — one of the primary mechanisms of socioeconomic upgrading. |
| **Urban signals** | Crime rate, building permit count, 311 complaint count, business license count | City open data (Chicago, Baltimore) | Mixed: urban activity, disinvestment indicators |
| **Business composition** | Count of food/drink establishments, personal services, retail (from historical business license SIC codes; see limitations below) | City open data (historical, with issue dates) | Demand-side: amenity shifts |
| **Transit proximity** | Distance to nearest CTA L station / Baltimore Metro station, number of transit stops within 800m | CTA / MTA GTFS feeds | Demand-side: accessibility premium |
| **School quality** | Mean school quality rating (test score percentile) of K–12 schools within tract boundary | NCES ELSI + IL/MD state report cards | Demand-side: residential choice for families |
| **Amenity proximity** | Distance to nearest park, distance to nearest university (IPEDS locations) | City open data, IPEDS | Demand-side: amenity valuation |
| **Commuting network** | In-commuting flow from high-income tracts, out-commuting destination diversity (entropy), betweenness centrality in commuting network | LEHD LODES (aggregated to tract) | Demand-side: functional connectivity, capital/idea exchange. Gardiner & Dong (2021) showed "considering network features alongside socio-economic features leads to a significant improvement in prediction performance." |
| **Spatial** | Distance to CBD, mean values of adjacent tracts (spatial lag — computed on allowed features only, not on income), tract area, population density | Computed from ACS + shapefiles | Spatial context, diffusion |

**Why transit proximity is included:** The literature consistently identifies transit access as one of the strongest predictors of gentrification. Kahn (2007), examining census tracts near urban rail transit stations in 14 U.S. metropolitan areas between 1970 and 2000, found that "communities receiving increased access to new 'Walk and Ride' stations experience greater gentrification than communities that are now close to new 'Park and Ride' stations." Bardaka et al. (2019) confirmed transit-induced gentrification along a light rail corridor in Denver. CTA station locations are freely available through the GTFS feed; Baltimore Metro station locations are available from MTA Maryland.

**Why school quality is included:** Yao et al. (2023), in their graph-based gentrification prediction framework using Chicago, NYC, and LA, found that "the urban network built from tracts and nearby schools shows the most impressive prediction performance," ranking schools among the strongest predictors. School quality is a primary driver of residential choice for families and is freely available from state education department report cards and NCES ELSI. Most ML gentrification studies omit this feature.

**Why commuting network features are included:** Gardiner & Dong (2021), using the Taxi & Limousine Commission Trip Record Data in New York City, demonstrated that mobility network features — specifically measures of functional connectivity between neighborhoods — significantly improved gentrification prediction when added to standard socioeconomic features. LEHD LODES (Longitudinal Employer-Household Dynamics Origin-Destination Employment Statistics) provides census-tract-level commuting flows for both Chicago and Baltimore across the study period. LODES data is free, publicly available from lehd.ces.census.gov, and has been aggregated to the tract level by the Urban Institute. A low-income tract whose residents commute to high-income employment centers is structurally positioned for gentrification differently than one whose residents work locally — LODES captures this spatial interaction.

**Business license SIC code limitations:** Business licenses are a better temporal proxy than Yelp but have their own weaknesses:
- A license **renewal** may be indistinguishable from a **new** license in some municipal datasets
- SIC codes at the 2-digit level do not distinguish between a diner and a farm-to-table restaurant — both are SIC 5812 (Eating Places)
- License *issuance date* ≠ *business opening date* (licenses may be pre-applied for or delayed)
- Chicago's data quality and historical depth is excellent; Baltimore's may be sparser or lack SIC codes

We use business license features as supplementary signals, not primary predictors, and note these limitations in the paper.

**Spatial lag note:** The spatial lag features (mean of adjacent tract values) must be computed on *allowed* features only — not on median income or rent. Computing a spatial lag on income would reintroduce the excluded variable. We compute spatial lag on demographic composition (% foreign-born, % renter), vacancy rate, and crime rate.

This separation means the model cannot exploit label-defining information directly or through mechanical proxies. Any predictive power must come from genuine early-warning signals — demographic composition, transit access, zoning capacity, commuting patterns, urban activity, spatial context — not from mechanically correlated baseline values of the outcome variables.

**We report performance both ways**: (a) with strict separation (our main result), and (b) with label-defining variables included (replication of prior methods). The difference quantifies how much prior work's accuracy is inflated by circularity.

**Feature count after separation:** With income-proximate variables removed and new feature categories added (zoning, school quality, LODES commuting), the feature set contains approximately **35–40 variables** (exact count depends on business license data availability for Baltimore and LODES variable selection). This is a deliberate balance between theoretical coverage and the events-per-variable ratio constraint (see Sample Size section below).

---

## Sample Size and Statistical Power

### The Events-Per-Variable Problem

Peduzzi et al. (1996) established a widely-used guideline: logistic regression requires at least 10 events (positive cases) per predictor variable (EPV) for stable coefficient estimates. With ~1,000 tracts, gentrification prevalence of 10–15% yields ~100–150 positive cases. With our feature set of ~35–40 variables, the EPV ratio is approximately **2.5–4** — well below the recommended minimum of 10.

Implications for this project:
- **Feature importance rankings will be unstable.** SHAP values computed on an overfitted model are not interpretable as genuine predictive signals. Different random seeds or minor data cleaning choices could substantially shuffle feature rankings.
- **L1 regularization helps but does not solve the problem.** L1 reduces the effective number of features, but the *initial* feature count still determines the search space. With EPV < 5, even regularized models risk fitting noise.
- **Tree-based models (RF, XGBoost) have implicit complexity parameters** that interact with sample size. Default hyperparameters will overfit at this scale.

### Mitigations

1. **Feature reduction before modeling:** If D1 (Freeman) yields only ~40 positive cases, we further reduce to ≤ 10 features for that definition via L1 pre-screening. If any definition yields fewer than 30 positive cases, we report descriptive statistics only and do not train ML models for that definition.
2. **Nested cross-validation** for hyperparameter tuning. Standard (non-nested) CV uses the same folds for both tuning and evaluation, producing biased performance estimates. Nested CV uses an inner loop for hyperparameter selection and an outer loop for unbiased evaluation — "endorsed as the gold standard for algorithm selection and performance estimation, especially in high-dimensional, small-sample, or model selection–intensive regimes" (Varoquaux et al. 2016; Yazici et al. 2023). We implement 5-fold outer × 3-fold inner nested CV.
3. **EPV reporting:** We compute and report the EPV ratio under each gentrification definition. If any definition produces EPV < 3, we note that SHAP analysis under that definition is exploratory and should not be used for policy inference.
4. **Stability analysis:** We run the best model 100 times with different random seeds and report the standard deviation of feature importance rankings (Spearman rank correlation across runs). If rankings are unstable (ρ < 0.7), we state this explicitly rather than reporting a single misleading ranking.
5. **Confidence intervals via bootstrap (n=1000):** We report 95% CIs on all metrics. If CIs are wide (e.g., AUC 95% CI spanning 0.15+), we interpret this as evidence that the sample is insufficient for reliable prediction, which is itself a publishable finding about the limits of tract-level ML.

---

## ML Methods (Teachable in 10 Weeks)

### Week 1–2: Research Design, Literature Review & Data Audit

- Define all four gentrification operationalizations using ACS variables
- Literature review: focus on the *Computers, Environment and Urban Systems* (2024) meta-synthesis of ML gentrification methods, the Easton et al. (2020) *Urban Studies* review of measurement, and Bardaka et al. (2023) *Transport Reviews* meta-analysis of transit-induced gentrification
- **Data audit**: download ACS 2010–2014 and 2015–2019, verify tract boundary consistency (2010 vintage), confirm variable availability, compute margins of error
- **Dual mutual information audit**: compute MI between all candidate features and (a) label-defining variables at T1, and (b) the binary gentrification label; flag and document any high-MI pairs
- Select study cities: Chicago (~800 tracts) and Baltimore (~200 tracts)

### Week 2–4: Data Collection & Feature Engineering

**Census data pipeline:**
- Pull ACS 5-year estimates for both periods via Census API
- Compute gentrification labels under all four definitions
- Compute label agreement matrix (Cohen's kappa and PABAK between all pairs, with 95% bootstrap CIs)
- Compute EPV ratio under each definition
- Run eligibility threshold sensitivity (40th, 45th, 50th, 55th percentile)

**City open data pipeline:**
- Chicago: crime incidents (geocoded), building permits, 311 complaints, **business licenses with SIC codes and issue dates**, **zoning district boundaries** — aggregate to tract level for the T1 period (2010–2014)
- Baltimore: crime, code violations, demolitions, vacant buildings, **zoning** — aggregate to tract level for T1

**Commuting network pipeline (LODES):**
- Download LEHD LODES origin-destination files for Illinois and Maryland (2014 or nearest available year)
- Aggregate from block to tract level
- Compute per-tract features: in-commuting flow from tracts with median income above metro median, out-commuting destination entropy, betweenness centrality in the tract-level commuting graph

**Transit, school, and amenity pipeline:**
- Download CTA L station locations from GTFS feed; compute distance from each tract centroid to nearest station and count of stations within 800m
- Download Baltimore Metro/Light Rail station locations from MTA Maryland
- Download K–12 school locations and quality ratings from NCES ELSI and Illinois/Maryland state report cards; compute mean quality rating for schools within each tract
- Download park boundary shapefiles; compute distance to nearest park
- Download university locations from IPEDS; compute distance to nearest university

**Geospatial pipeline:**
- Spatial join point data to 2010-vintage TIGER/Line tract boundaries using `geopandas`
- Overlay zoning district polygons with tract boundaries; compute dominant zoning class and maximum allowable density per tract
- Compute spatial lag features (mean of adjacent tract values for allowed features only) using `libpysal` or `PySAL`
- Compute distance to CBD for each tract centroid

**ACS margin of error handling:**
- Download MOE columns alongside point estimates
- Flag tracts where MOE exceeds 30% of the estimate for label-defining variables
- Report sensitivity: does excluding high-MOE tracts change model performance?

### Week 5–7: Classification Models

**Baselines and models (from simplest to most complex):**

| Model | Purpose |
|-------|---------|
| **Spatial proximity heuristic** | "Tracts adjacent to already-gentrified tracts will gentrify." If this baseline performs well, ML adds limited value. Spatial diffusion of gentrification is well-established theoretically (O'Sullivan 2005; Hwang & Sampson 2014), but this simple operationalization as a predictive baseline is rarely tested explicitly in the ML gentrification literature. |
| **Logistic regression (L1-regularized)** | Interpretable linear baseline; L1 for automatic feature selection. Serves double duty: the features surviving L1 form the reduced set for EPV-constrained definitions. |
| **Random Forest** | Non-linear, handles interactions, standard in the literature |
| **XGBoost** | Gradient boosted trees; typically the strongest tabular classifier |

**Primary specification:** D4 (Composite definition) + XGBoost + spatial block CV + Chicago. All other combinations (D1–D3, other models, standard CV, Baltimore) are reported as sensitivity analyses in an appendix. The paper's argument is built around the primary specification.

**Training and evaluation:**
- Use T1 features to predict T2 gentrification label
- **Nested cross-validation**: outer 5-fold (spatial block) for performance estimation, inner 3-fold for hyperparameter tuning. This prevents information leakage from test folds into model selection.
- **Two CV strategies reported side-by-side:**
  - Stratified 5-fold CV (standard, treats tracts as i.i.d.)
  - Spatial block CV: partition the city into geographic blocks calibrated to the empirical spatial autocorrelation range. We compute Moran's I correlogram on the **top 5 features by L1 coefficient magnitude** and set block size to exceed the **maximum autocorrelation range** across these features (conservative — avoids leakage through the most spatially structured variable). This prevents adjacent tracts from appearing in both train and test sets, which would inflate metrics. Research demonstrates that "neglecting spatial autocorrelation during cross-validation leads to an optimistic model performance assessment" with overestimation "by up to 28%" (Karasiak, Dejoux, Monteil & Sheeren 2022, *Machine Learning* 111: 2715–2740).
- **Cross-city generalization**: train on Chicago (~800 tracts), test on Baltimore (~200 tracts), and vice versa.

**Class imbalance handling:**

We do NOT use SMOTE. Recent theoretical work proves that "SMOTE (with default parameter) tends to copy the original minority samples asymptotically" and that "for most data sets, we observe that applying no rebalancing strategy is competitive in terms of predictive performances, with tuned random forests, logistic regression or LightGBM" (Olive, Gadat & Maillard 2024, arXiv 2402.03819).

Instead, we use:
- `class_weight='balanced'` in scikit-learn (inversely proportional to class frequency)
- Report the **full precision-recall curve** rather than optimizing a single decision threshold. With ~100 positive cases, a held-out calibration set would contain only ~20 positives — far too few for reliable threshold optimization. We report F1 at the default 0.5 threshold and at the precision=recall crossing point, but emphasize the curve shape over any single operating point.
- Report AUC-PR (more informative than AUC-ROC for imbalanced data)

**Probability calibration:**

For the risk maps to be actionable, predicted probabilities must be **calibrated** — a tract predicted at P=0.30 should gentrify approximately 30% of the time. XGBoost and Random Forest produce poorly calibrated probabilities out of the box, and `class_weight='balanced'` actively distorts the decision boundary and raw probability outputs.

We apply **Platt scaling** (sigmoid calibration) via scikit-learn's `CalibratedClassifierCV(method='sigmoid', cv=3)` to the best model. Platt scaling fits only 2 parameters (slope and intercept of a logistic function mapping raw scores to calibrated probabilities) and is appropriate for our small sample size. Isotonic regression (the alternative) is non-parametric and requires substantially more calibration data — with ~20 positives per fold, it would overfit.

We report:
- **Reliability diagrams** (calibration curves) for both the uncalibrated and calibrated models
- **Brier score** (mean squared error of predicted probabilities vs. actual outcomes) — a proper scoring rule that jointly measures discrimination and calibration
- Whether calibration improves or degrades after applying class weights

Without calibration analysis, the risk maps are rank-ordered but not meaningfully scaled, rendering them unsuitable for policy thresholds (e.g., "intervene when predicted risk exceeds 30%").

**Metrics:**
- AUC-ROC, AUC-PR, precision, recall, F1 at default and PR-crossing thresholds
- **Brier score** (calibration quality)
- All metrics reported with **95% confidence intervals** via bootstrap (n=1000)
- Compare across all four gentrification definitions (within-definition model comparison; see comparability caveat above)

### Week 7–8: Explainability & Feature Importance

- **SHAP values**: which features are the strongest early warning signs? Reported only for models with EPV ≥ 3 under the given definition. For definitions with EPV < 3, SHAP analysis is labeled as exploratory.

- **Multicollinearity audit for SHAP reliability:** Before interpreting SHAP values, we compute the pairwise Pearson correlation and mutual information matrix across all features. Features with |r| > 0.7 are grouped into correlated clusters. We report SHAP importance both per-feature and per-cluster (summing absolute SHAP values within each cluster). This addresses the known limitation that "SHAP does not inherently account for correlations between input features" and that "the marginal contribution of one feature depends on whether the correlated feature is already included in the subset being evaluated" (see also: arXiv 2603.22346 on "first-mover bias" in gradient boosting, where "gradient boosting creates a self-reinforcing advantage for whichever feature is selected first" among correlated candidates, "concentrating SHAP importance on an arbitrary feature rather than distributing it across the correlated group"). Expected correlated clusters in our data include: {% renter-occupied, housing age, vacancy rate}; {% foreign-born, % Hispanic}; {crime rate, 311 complaints, vacancy}; {transit proximity, distance to CBD}.

- **Feature stability analysis**: run 100 iterations with different random seeds; report Spearman rank correlation of SHAP importance rankings across runs. If ρ < 0.7, note instability explicitly. Report stability both at the individual feature level and at the cluster level.

- **Feature separation analysis**: run models (a) with strict feature-label separation and (b) with label-defining variables included. Report the AUC difference. This quantifies how much prior work's accuracy comes from circularity.

- **Racial composition ablation**: run the primary specification with and without racial composition features (% White, % Black, % Hispanic). If performance drops substantially without racial features, the model may be relying on racial composition as a proxy for the eligibility criterion (low-income tracts in Chicago are disproportionately Black) rather than as a genuine early-warning signal. Report the AUC difference and discuss in both the methods and ethics sections.

- **Supply-side vs. demand-side ablation**: run the primary specification with (a) supply-side features only (zoning, vacancy, housing age, building permits), (b) demand-side features only (demographics, transit, schools, commuting), and (c) both. This tests whether the rent gap framework adds predictive value beyond demographics.

- **Partial dependence plots**: how does predicted upgrading probability change with vacancy rate? With transit proximity? With building permit density? With zoning class?

- **Failure analysis**: which tracts are systematically mispredicted across all models and definitions? What do they have in common? Do they cluster in areas of known high foreclosure distress (Great Recession confound)? This reveals the *limits* of prediction from census data — which is as interesting as the predictions themselves.

### Week 8–9: Spatial Analysis & Visualization

- Map predicted gentrification risk by tract using `folium` or `plotly`, using **calibrated probabilities**
- Overlay with racial composition data to show which communities are most at risk
- Map "consensus gentrified" tracts (flagged under all 4 definitions) vs. "contested" tracts (flagged under some but not all)
- Compare Chicago vs. Baltimore spatial patterns — do the same features generalize?
- Compare spatial CV vs. standard CV predictions — where do they diverge?

### Week 9–10: Paper Writing

- ~20–25 pages with maps, SHAP plots, model comparison tables, definition agreement matrix
- Primary specification results in the main text; sensitivity analyses in appendix
- Explicit limitations section covering: ecological fallacy, Great Recession confound, single temporal transition, MAUP, EPV constraints, business license data quality, no visual/physical change data, macroeconomic credit conditions
- Ethics discussion (see below)

---

## Team Task Allocation (Rebalanced)

| Person | Responsibility |
|--------|---------------|
| **Student A** | Census API data extraction + feature engineering for demographics, housing. ACS margin-of-error analysis. Dual mutual information audit of feature-label separation. **Weeks 3–4: transit/amenity/school pipeline** (GTFS stations, parks, universities, NCES school data) — shifted here after Census work completes. |
| **Student B** | City open data (crime, permits, 311, business licenses, zoning) — geocoding, temporal filtering to T1 period, aggregation to tracts via spatial join. **LODES commuting network pipeline** — download, aggregate to tract, compute network features. |
| **Student C** | ML modeling (nested CV, model comparison, SHAP with collinearity audit, probability calibration, spatial block CV implementation, stability analysis) + map visualization. |
| **Anna** | Research design, gentrification definition comparison, literature framing, spatial analysis guidance, paper writing, ethics section. Eligibility threshold sensitivity analysis. |

**Rationale for rebalancing:** The original allocation overloaded Student B with city data, transit, parks, and universities. Moving the transit/amenity pipeline to Student A (after Census work completes in week 2) and assigning LODES to Student B (in place of transit/amenity) distributes workload more evenly. Student B's city-data work (geocoding ~7 million Chicago crime incidents, cleaning business license SIC codes, overlaying zoning polygons) is already substantial.

---

## Risks, Unknowns & Open Problems

### Known Risks

| Risk | Severity | Mitigation |
|------|----------|-----------|
| **Gentrification definition is contested — no ground truth exists** | High | We do not resolve this. Instead, we make it the subject of analysis: testing four definitions and reporting where they agree. "This makes it difficult to assess whether findings of a given study reflect how gentrification was operationalized" (Desmond, An & Xiang 2023). |
| **Feature-label separation may substantially reduce accuracy** | High | This is expected and is the point. If accuracy drops sharply, it demonstrates that prior work's reported performance was inflated. If accuracy holds, it validates the existence of genuine predictive signals. Either result is publishable. |
| **Sample size is small for ML (~1,000 tracts, ~100–150 positive cases)** | High | EPV ratio of ~2.5–4 is below the Peduzzi et al. (1996) recommended minimum of 10. Mitigations: (a) feature reduction via L1 for low-prevalence definitions, (b) nested CV for unbiased evaluation, (c) stability analysis across 100 random seeds, (d) explicit EPV reporting per definition. If performance is poor or unstable, this itself is a finding about the limits of tract-level ML prediction with available data. |
| **Single temporal transition — no out-of-time validation** | High | We have exactly one time step (2010–2014 → 2015–2019). Cross-city validation tests spatial generalization, not temporal generalization. The model may learn features specific to the post-Great-Recession recovery period rather than features of gentrification in general. We cannot resolve this without adding a second temporal period (e.g., 2000 → 2006–2010), which requires LTDB/NHGIS boundary harmonization and is infeasible in 10 weeks. We flag this as the single most important limitation and the highest-priority future extension. |
| **Great Recession confound in T1 baseline** | High | The 2010–2014 baseline captures recession-trough conditions. Income growth into 2015–2019 partly reflects recovery, not gentrification. Definitions comparing tract growth to metro growth partially control for this (the metro also recovered), but tracts hit disproportionately hard may show mechanical "catch-up" growth. Discussed in Limitations section; failure analysis examines whether mispredictions cluster in high-foreclosure areas. |
| **No physical/visual change data — census-only feature set** | High | A growing literature shows property-level visual changes (GSV imagery, satellite imagery) are leading indicators of gentrification that precede census-detectable demographic shifts by years. Our census-only approach may miss the earliest signals. Acknowledged as a scope limitation; flagged as the second-highest priority future extension. |
| **Spatial autocorrelation inflates standard CV metrics** | Medium | Report both standard and spatial block CV, with block size calibrated to the maximum empirical autocorrelation range across top features. If spatial CV drops AUC significantly, this demonstrates the inflation and warns future researchers. Research shows overestimation "by up to 28%" when spatial autocorrelation is ignored (Karasiak et al. 2022). |
| **ACS 5-year estimates have large margins of error at tract level** | Medium | Download and report MOEs. Flag and optionally exclude tracts where MOE > 30% of estimate. "Using 5-year ACS estimates as known explanatory variables, as is typically done, ignores the uncertainty in the time-period estimates which can impact inference" (Janicki et al. 2023, PMC10389670). |
| **SHAP values unreliable under multicollinearity** | Medium | With 35–40 features, many are correlated. TreeSHAP distributes importance across correlated features arbitrarily depending on tree structure, creating "first-mover bias" (arXiv 2603.22346). Mitigated by reporting per-cluster SHAP importance (grouped by |r| > 0.7) alongside per-feature importance, and by stability analysis across seeds. |
| **Census tract boundaries do not correspond to lived neighborhoods (MAUP)** | Medium | The Modifiable Areal Unit Problem means that spatial lag features and all tract-level aggregates are partly artifacts of where the Census Bureau drew boundary lines. "The areal units (zonal objects) used in many geographical studies are arbitrary, modifiable, and subject to the whims and fancies of whoever is doing, or did, the aggregating" (Openshaw 1984). **Sensitivity check:** if time permits, re-run the primary specification at the block group level for ACS variables and compare feature importance and performance. If results change substantially, they are MAUP-dependent. |
| **Cross-city generalization may fail due to structural similarity of study cities** | Medium | Chicago and Baltimore are both post-industrial, highly segregated (top 10 US by dissimilarity index), population-stagnant, and in the Midwest/Mid-Atlantic. A model that transfers between them may still fail in Sunbelt growth cities (Atlanta, Denver, Houston) or West Coast tech-driven markets (San Francisco, Seattle) with fundamentally different gentrification dynamics. We cannot test this without additional cities. Report this as a scope limitation: our generalization test is between two structurally similar cities, not across diverse urban typologies. |
| **Racial composition features create soft endogeneity** | Medium | In Chicago and Baltimore, gentrification is deeply racialized (Hwang & Sampson 2014). Racial composition at T1 may proxy for the eligibility criterion (low-income tracts are disproportionately Black) or for unmeasured gentrification preconditions. Racial composition *change* is arguably an *outcome* of gentrification, not a cause. Mitigated by running the racial features ablation (with vs. without) and discussing results in the ethics section. |
| **Baltimore has limited business license history** | Low-Medium | Chicago's business license portal is well-documented with historical records. Baltimore's data may be sparser or lack SIC codes. Fallback: use only Chicago for business-composition features, test whether they add predictive value, and note Baltimore limitation. |
| **Uncalibrated probabilities render risk maps misleading** | Medium | XGBoost/RF probabilities are poorly calibrated, especially with class weighting. Mitigated by Platt scaling + reliability diagrams + Brier score reporting. |

### Unknown Factors (Acknowledged Unknowns)

| Unknown | Implication |
|---------|-------------|
| **How much accuracy comes from circularity in prior work?** | We don't know until we run the feature-separation experiment. Prior reported accuracies (83%, 74%) may be upper bounds inflated by label-feature coupling. Our separated-feature results will likely be lower. The size of the gap is itself a research finding. |
| **What is the base rate of gentrification under each definition?** | Prevalence determines class imbalance, EPV ratio, and affects all metrics. Literature suggests 10–15%, but this depends heavily on definition and city. If D1 (Freeman) yields 5% and D3 (income-only) yields 25%, the "same model" will produce very different-looking results. We must compute this before choosing modeling strategy. |
| **Do genuine early-warning signals exist in census data at all?** | It is possible that census-derived features (excluding label-defining variables and their mechanical correlates) have weak predictive power for socioeconomic upgrading. If the spatial proximity baseline outperforms ML models, the conclusion is that gentrification is primarily a spatial diffusion process, not one predictable from demographic/economic features. This would be a genuine and useful negative result. |
| **Can the model distinguish gentrification from natural economic recovery?** | A low-income tract whose income grows above the metro median may be "recovering" from a recession, not gentrifying. The model cannot distinguish between organic economic improvement and externally driven upgrading without additional data (e.g., in-migration records, real estate investment flows) that we do not have. This is the most fundamental inferential limitation of the study design. |
| **Does the rent gap (supply-side) framework add predictive value beyond demographics?** | We do not know until we run the supply-side vs. demand-side ablation. If zoning, vacancy, and housing age features add no predictive value after controlling for demographics, the supply-side theory (Smith 1979) does not manifest in tractable features at this scale — or our proxies are too crude. |
| **Are SHAP rankings stable at this sample size?** | We do not know until we run the stability analysis. If feature importance rankings shuffle substantially across random seeds (Spearman ρ < 0.7), the SHAP plots are unreliable and should not be used for policy recommendations. We report stability explicitly and adjust our claims accordingly. |
| **How large is the spatial autocorrelation inflation?** | We do not know the gap between standard CV and spatial CV performance until we run both. The literature suggests inflation of up to 28% (Karasiak et al. 2022), but the magnitude depends on the spatial structure of our specific data. |
| **Do commuting network features improve prediction?** | Gardiner & Dong (2021) found "a significant improvement" in NYC. Whether LODES-derived features replicate this improvement in Chicago/Baltimore with a different gentrification definition and different feature set is unknown. The signal may not survive feature-label separation if commuting flows correlate strongly with income. |

---

## Ethical Considerations

### Dual-Use Risk

Rachel Weber (University of Illinois–Chicago) warned at the 2019 Urban Displacement Project symposium that "in some cases, predictions become self-fulfilling prophecies." A publicly released gentrification risk map could be used by real estate speculators to identify and front-run neighborhood change — *accelerating* the very process the model claims to predict. This is not hypothetical: real estate technology firms already use similar data for investment targeting.

### Who Benefits?

If the model works, it could serve two very different users:
1. **Policymakers and community organizations**: to target tenant protections, affordable housing investment, and anti-displacement programs at at-risk tracts
2. **Real estate investors**: to identify undervalued neighborhoods before prices rise

We cannot control downstream use. We can:
- Frame the paper explicitly around community protection
- Discuss dual-use risk in the paper's ethics section
- Avoid publishing tract-level prediction maps as interactive web tools without access controls
- Recommend that the model be used *in conjunction with* community input, not as a standalone decision tool

### Prediction ≠ Prescription

SHAP values show feature *importance*, not causal mechanisms. A finding that "building permit density predicts gentrification" does not mean building permits *cause* gentrification. Policymakers should not use this model to restrict building permits. The model identifies correlates, not levers.

### Racial Features Warrant Extra Caution

If SHAP analysis reveals racial composition as a top predictor, this must be interpreted with extreme care. Racial composition at T1 may proxy for structural disadvantage (decades of redlining, disinvestment) that creates the conditions for gentrification, rather than representing a causal mechanism. Reporting "tracts with high % Black population are predicted to gentrify" without contextualizing the structural history would be irresponsible. We conduct the racial ablation analysis (see Week 7–8) and discuss results in the ethics section regardless of outcome.

### Ecological Fallacy

All findings are at the tract level. We cannot infer individual-level outcomes (who moves, who stays, who benefits, who is harmed) from aggregate-level patterns. A tract that "gentrifies" under our definitions may have experienced new construction on vacant land, in-situ income growth of existing residents, or population replacement — our data cannot distinguish between these mechanisms. Policy recommendations based on this model should be paired with individual-level or qualitative evidence.

---

## Prior Work & Positioning

### Directly Relevant

| Study | Method | Cities | Result | How We Differ |
|-------|--------|--------|--------|---------------|
| Census Bureau WP SEHSD-WP-2023-15 (2023) | Random Forest | Washington D.C. | 83% accuracy | Uses AHS data (unit-level); does not separate label-defining variables from features. We test whether accuracy holds under strict separation. |
| SSRN 3911354 (2021) | ACS + Zillow + HUD, tree models | 8 CBSAs | 74% accuracy, beat rules-based baseline | Uses Zillow ZIP-level data (noisy crosswalk). Single gentrification definition. No spatial CV. We address all three. |
| Yao et al. (2023), arXiv 2312.15646 | GNN + satellite + socioeconomic | Chicago, NYC, LA | 0.9 AUC | Graph-based model leveraging facility networks; found schools among strongest predictors. More complex than our scope. We add school quality, commuting networks, and more methodological rigor on definition sensitivity and feature separation. |
| Gardiner & Dong (2021) | RF + mobility networks | New York City | Significant improvement from network features | Uses NYC Taxi & Limousine Commission trip data + Urban Displacement Project labels. We incorporate LODES commuting flows (more comprehensive than taxi data) as an analogous network feature. |
| Reades, De Souza & Hubbard (2019) | Decision trees, RF | London | Predicted "uplift" and "decline" | UK data, different definitions, no feature separation analysis. |
| Thackway et al. (2023) | RF + SHAP + Siamese CNN on GSV | Sydney | 74.7% balanced accuracy | Combines socioeconomic and visual features. Single city, single definition, no spatial CV. We add definition sensitivity and spatial CV but lack visual features. |
| Eshtiyagh et al. (2024), ScienceDirect | Meta-synthesis of ML gentrification | Literature review | Identified "challenges of data imbalance and quality" and "black box" concerns | Our definition sensitivity analysis directly addresses their identified gaps. |
| Kahn (2007) | Panel regression | 14 US metros | Transit "Walk and Ride" stations predict gentrification | Establishes transit proximity as a key predictor — a feature our model includes and most ML gentrification studies omit. |
| Ilic et al. (2019) | Siamese CNN on GSV | Ottawa | 95.6% accuracy on visual property upgrades | Demonstrates property-level visual detection of gentrification. Our approach does not include visual data but benefits from the finding that physical changes are leading indicators. |
| Alfaro et al. (2025) | Satellite imagery + ML | London | 77% balanced accuracy, +8% over census-only | Shows satellite imagery improves gentrification detection beyond census features. Motivates our visual-data limitation discussion and future extension. |
| UC Berkeley Urban Displacement Project (Chapple & Zuk 2016) | Typology-based classification | Bay Area, replicated nationally | Widely adopted policy tool | Provides a neighborhood change typology used by policymakers. Our approach is complementary — we test multiple definitions rather than adopting a single typology. |

### Our Contribution (What's New)

Existing work overwhelmingly (a) uses a single gentrification definition, (b) includes label-defining variables as features without auditing for mechanical correlates, (c) evaluates with standard CV that ignores spatial structure, and (d) does not calibrate predicted probabilities for policy use. No prior study we identified simultaneously addresses all four. Our contribution is **methodological rigor applied to an established prediction task**, not a novel algorithm.

Specifically:
- Our **dual MI audit** goes beyond the simple "exclude the four label variables" approach by also identifying and excluding mechanical proxies (poverty rate, public assistance rate) that reintroduce the circularity under different variable names, and by checking MI against the binary label itself, not just against T1 levels.
- Our **supply-side features** (zoning, vacancy as rent-gap proxy) connect the ML feature set to the most influential economic theory of gentrification (Smith 1979), which most ML studies ignore.
- Our **commuting network features** (LODES) incorporate the signal that Gardiner & Dong (2021) demonstrated improves prediction, using publicly available census data rather than proprietary taxi records.
- Our **probability calibration** addresses a gap in every prior ML gentrification study we reviewed: none report reliability diagrams or Brier scores, yet all claim policy relevance for their risk predictions.

The *Computers, Environment and Urban Systems* (2024) meta-synthesis identified key challenges: "the requirement for a large amount of processing power, the challenge of fine-tuning parameters, and the 'black box' nature of machine learning models, which makes it challenging to comprehend and interpret decision-making processes." Our emphasis on SHAP explainability (with collinearity audit), feature separation, definition sensitivity, and calibration directly addresses these concerns with an accessible, reproducible methodology.

---

## Publication Targets

| Journal | Fit | Notes |
|---------|-----|-------|
| *Environment and Planning B: Urban Analytics and City Science* | ⭐⭐⭐⭐⭐ | Best match: urban analytics + ML + policy |
| *Computers, Environment and Urban Systems* | ⭐⭐⭐⭐⭐ | Published 2024 meta-synthesis on this exact topic |
| *Housing Policy Debate* | ⭐⭐⭐⭐ | Strong fit for the definition-sensitivity and ethics angle |
| *Urban Studies* | ⭐⭐⭐⭐ | Published Easton et al. (2020) on measurement of displacement |
| *Journal of Urban Economics* | ⭐⭐⭐ | More theoretical; better if supply-side ablation produces strong results |
| SSRN or arXiv pre-print | ⭐⭐⭐⭐⭐ | Immediate visibility; precedes journal submission |

---

## Week-by-Week Schedule (Revised)

| Week | Activities | Deliverable |
|------|-----------|-------------|
| 1 | Literature review (including Smith 1979 rent gap theory, UDP typology), define four gentrification operationalizations, data availability audit | Annotated bibliography, variable selection document with demand/supply classification |
| 2 | ACS data download (both periods), boundary verification, compute labels under all four definitions, label agreement matrix (kappa + PABAK + 95% CIs), compute EPV per definition, dual MI audit, eligibility threshold sensitivity | Label dataset, agreement table, EPV table, MI audit report, threshold sensitivity table |
| 3 | City open data download (Chicago: crime, permits, 311, business licenses, zoning; Baltimore: crime, violations, vacants, zoning) + LODES commuting data download and tract-level aggregation, geocode point data to tracts | City features dataset (T1 period), LODES features, zoning overlay |
| 4 | Transit/school/amenity pipeline (GTFS stations, NCES school data, parks, universities — Student A); feature engineering: spatial lag (allowed features only), distance features, commuting network metrics; merge all datasets; handle missing data; flag high-MOE tracts | Merged analysis-ready dataset (~35–40 features) |
| 5 | Implement baselines: spatial proximity heuristic, logistic regression (L1); compute Moran's I correlogram on top L1 features for block CV calibration; compute feature correlation matrix for collinearity audit | Baseline performance table, autocorrelation range estimate, correlation matrix |
| 6 | Random Forest + XGBoost with nested CV (5-fold outer spatial block × 3-fold inner); class weights; probability calibration (Platt scaling); primary specification (D4 + Chicago) first, then sensitivity | Primary results table with calibrated probabilities, reliability diagram, Brier scores |
| 7 | Feature separation experiment (with vs. without label-defining variables); racial features ablation; supply-side vs. demand-side ablation; SHAP analysis with collinearity-aware clustering and stability check (100 seeds); partial dependence plots | Circularity analysis figure, ablation tables, SHAP summary (per-feature + per-cluster, with stability report) |
| 8 | Cross-city generalization test (train Chicago → test Baltimore, and reverse); failure analysis of mispredicted tracts; check for Great Recession clustering | Generalization table, misprediction analysis |
| 9 | Mapping: calibrated risk maps, consensus vs. contested tracts, demographic overlays, spatial CV vs. standard CV divergence, zoning overlay | Folium/plotly maps |
| 10 | Paper writing: introduction, methods, results (primary + appendix), limitations (ecological fallacy, recession confound, single transition, MAUP, EPV, no visual data, macro credit conditions), ethics, references | Draft manuscript (~20–25 pages + appendix) |

---

## Key References

- Alfaro, Šćepanović, Law & Quercia (2025). "Gentrification from the Sky: Using Remote Sensing and Machine Learning for Urban Change Detection." In: *Digital-Era Urban Transformations*. Springer, pp. 199–225.
- Bardaka, Herring & Kaza (2019). "A Tale of Two Light Rail Transit Lines: Measuring Gentrification, Displacement, and TOD Exposure along the Blue Line and the Red/Orange Lines in Denver." *Transport Policy* 80: 122–134.
- Bardaka, Heider & Engel (2023). "Transit-induced gentrification and displacement: The state of the evidence." *Transport Reviews* 44(1): 29–55.
- Brummet & Reed (2019). "The Effects of Gentrification on the Well-Being and Opportunity of Original Resident Adults and Children." Federal Reserve Bank of Philadelphia Working Paper 19-30.
- Byrt, Bishop & Carlin (1993). "Bias, prevalence and kappa." *Journal of Clinical Epidemiology* 46(5): 423–429.
- Census Bureau Working Paper SEHSD-WP-2023-15 (2023). "Identifying gentrification using machine learning." Random Forest, 83% accuracy, Washington D.C.
- Chapple & Zuk (2016). "Forewarned: The Use of Neighborhood Early Warning Systems for Gentrification and Displacement." *Cityscape* 18(3): 109–130.
- Desmond, An & Xiang (2023). "Beyond Gentrification: Housing Loss, Poverty, and the Geography of Eviction." *Social Problems*. Eviction analysis across 72 US metros.
- Ding, Hwang & Divringi (2016). "Gentrification and Residential Mobility in Philadelphia." Federal Reserve Bank of Philadelphia Working Paper 16-14.
- Easton, Lees, Hubbard & Tate (2020). "Measuring and mapping displacement: The problem of quantification in the battle against gentrification." *Urban Studies* 57(2): 286–306.
- Eshtiyagh et al. (2024). "Application of machine learning in understanding urban neighborhood gentrification." *Computers, Environment and Urban Systems* (meta-synthesis, 217 articles screened).
- Freeman (2005). "Displacement or Succession? Residential Mobility in Gentrifying Neighborhoods." *Urban Affairs Review* 40(4): 463–491.
- Gardiner & Dong (2021). "Mobility Networks for Predicting Gentrification." In: Benito et al. (eds) *Complex Networks & Their Applications IX*. Studies in Computational Intelligence, vol 944. Springer, pp. 181–192. Case study: New York City, 2010–2018.
- Hwang & Sampson (2014). "Divergent Pathways of Gentrification: Racial Inequality and the Social Order of Renewal in Chicago Neighborhoods." *American Sociological Review* 79(4): 726–751.
- Ilic, Sawada & Zarzelli (2019). "Deep mapping gentrification in a large Canadian city using deep learning and Google Street View." *PLOS ONE* 14(3): e0212814.
- Janicki, Quick, Bennette & Bradley (2023). "A Spatio-temporal Hierarchical Model to Account for Temporal Changes of Support in the ACS." *Spatial Statistics*. PMC10389670.
- Kahn (2007). "Gentrification Trends in New Transit-Oriented Communities: Evidence from 14 Cities That Expanded and Built Rail Transit Systems." *Real Estate Economics* 35(2): 155–182.
- Karasiak, Dejoux, Monteil & Sheeren (2022). "Spatial dependence between training and test sets: another pitfall of classification accuracy assessment in remote sensing." *Machine Learning* 111: 2715–2740.
- Ley (1986). "Alternative Explanations for Inner-City Gentrification: A Canadian Assessment." *Annals of the Association of American Geographers* 76(4): 521–535.
- Li et al. (2019). "A comparison of the approaches for gentrification identification." *Cities* 95.
- Newman & Wyly (2006). "The Right to Stay Put, Revisited: Gentrification and Resistance to Displacement in New York City." *Urban Studies* 43(1): 23–57.
- Olive, Gadat & Maillard (2024). "Do we need rebalancing strategies? A theoretical and empirical study with SMOTE, random forests and LightGBM." arXiv 2402.03819.
- Openshaw (1984). "The Modifiable Areal Unit Problem." *Concepts and Techniques in Modern Geography* 38. Norwich: Geo Books.
- O'Sullivan (2005). "Neighborhood Change and the Spatial Organization of Real Estate." Chapter in *Handbook of Regional Science*. Springer.
- Peduzzi, Concato, Kemper, Holford & Feinstein (1996). "A simulation study of the number of events per variable in logistic regression analysis." *Journal of Clinical Epidemiology* 49(12): 1373–1379.
- Reades, De Souza & Hubbard (2019). "Understanding urban gentrification through machine learning." *Urban Studies* 56(5): 922–942.
- Rucks-Ahidiana (2021). "Theorizing Gentrification as a Process of Racial Capitalism." *City & Community* 21(3): 173–192.
- Smith (1979). "Toward a Theory of Gentrification: A Back to the City Movement by Capital, not People." *Journal of the American Planning Association* 45: 538–548.
- Thackway, Ng, Lee & Pettit (2023). "Gentrification Prediction Using Machine Learning." *Cities* 138: 104344.
- U.S. Census Bureau (2022). "Period Estimates in the American Community Survey." Random Samplings blog.
- Varoquaux, Raamana, Engemann, Hoyos-Idrobo, Schwartz & Thirion (2016). "Assessing and tuning brain decoders: Cross-validation, caveats, and guidelines." *NeuroImage* 145: 166–179.
- Weber (2019). Comments at the Urban Displacement Project Symposium on predictive models as "self-fulfilling prophecies."
- Yao, Hua, Xie, Qian & Wei (2023). "A graph-based multimodal framework to predict gentrification." arXiv 2312.15646.
- Yazici, Shafiq & Shin (2023). "A systematic survey of model selection in machine learning." *SN Computer Science* 4: 757.

---

## Why This Project Wins

- **Directly builds on Anna's existing research** — census tract-level data in Chicago and Baltimore, using tools she already knows
- **Policy-relevant**: cities and community organizations want gentrification early warning systems
- **Theoretically grounded**: features structured around both demand-side (Ley 1986) and supply-side (Smith 1979 rent gap) theories, not just atheoretical variable selection
- **Methodologically honest**: the feature-separation experiment (with dual MI audit of mechanical correlates and suspicious predictors), definition-sensitivity analysis, spatial CV, and probability calibration address real weaknesses in prior work, not just replicate them
- **Either result is publishable**: if accuracy holds under strict feature separation → genuine early warning signals exist; if accuracy drops → prior work was inflated by circularity, and the field needs to know. If SHAP rankings are unstable → the sample size is insufficient for reliable feature importance, and the field needs to know that too. If supply-side features don't help → the rent gap is not tractable at this scale, or our proxies are too crude.
- **Cleanest data pipeline**: all data is CSV/API download from Census, LODES, city open data portals, NCES, and GTFS feeds — no scraping, no API-dependent features
- **Reproducible**: all data is public, all code can be open-sourced, all definitions are clearly specified
- **Standard but effective ML**: Random Forest + XGBoost + SHAP is well-understood, reproducible, and accessible to a 10-week team
- **Limitations stated honestly**: single temporal transition, Great Recession confound, ecological fallacy, MAUP, EPV constraints, no visual/physical change data, macroeconomic credit conditions, city selection bias — all acknowledged upfront rather than buried or ignored
- **Built-in contribution**: no prior study simultaneously addresses label circularity (with proxy audit), definition sensitivity, spatial CV, and probability calibration — this is the paper's distinctive angle
