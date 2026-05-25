# Does Physical Activity Buffer the Association Between Screen Time and Insufficient Sleep Among U.S. High School Students?

## Evidence from the Youth Risk Behavior Survey, 2015–2023

### Summer Research Camp — 4-Week Project for High School Students (Grades 10–11)

---

## 1. Background & Gap

The link between screen time and poor sleep in adolescents is established (r ≈ 0.25; five meta-analyses, 40+ studies). Only 23% of U.S. high school students get ≥8 hours of sleep (CDC, 2023). The open question is what *moderates* this association.

In October 2024, CDC published its first analysis of 2023 YRBS social media data (Young et al., MMWR 2024), finding frequent social media use was associated with sadness/hopelessness and suicide ideation. The authors explicitly identified what they did *not* examine:

> *"Future research exploring the pathways through which social media use might lead to poor mental health and suicide risk… also is needed."*
> — Young et al., MMWR Suppl. 2024;73(4):1–10

Notably absent from their analysis: **sleep as a pathway** and **physical activity as a protective factor**.

### Why moderation, not mediation?

Dai & Ouyang (2026) showed that PA **mediates** the screen time → mental health pathway (screen time reduces PA, which harms mental health). We ask the complementary question: **does being physically active *protect* you from the sleep-disrupting effects of screen time, even if screen time stays high?**

This distinction matters for intervention: mediation says "reduce screen time to increase PA"; moderation says "increase PA to buffer against screen time you can't or won't reduce."

Hoe et al. (2019) tested this with NHANES accelerometry data (N=542, ages 16–19). Males meeting both PA and screen time guidelines had 73% lower odds of poor sleep *quality* (OR=0.27), but PA was associated with *less* sufficient sleep *duration* (OR=0.50) — possibly due to early-morning practices. No study has tested this moderation in U.S. high school students across multiple YRBS waves.

---

## 2. Research Questions

| # | Question | Hypothesis |
|---|----------|------------|
| **RQ1** | How has the co-prevalence of high screen time (≥4 hrs/day) and insufficient sleep (<8 hrs) changed among U.S. high school students, 2015–2021? | Both have increased; co-prevalence has grown, with a COVID-era spike in 2021. |
| **RQ2** | Does PA moderate the association between screen time and insufficient sleep? (Pooled 2015–2021) | Among students meeting PA guidelines (≥5 days/week), the screen time–sleep association is weaker. The buffering effect may differ by sex. |
| **RQ3** | (2023 only) Does frequent social media use predict insufficient sleep, and does PA moderate this? | Frequent SM use predicts insufficient sleep; PA moderates this association. |

**Design:** Two-part study. RQ1–RQ2 use the screen time question (2015–2021). RQ3 uses the new 2023 SM frequency question. See Appendix A for variable details.

---

## 3. Conceptual Model

```
                    ┌───────────────────┐
                    │ Physical Activity  │
                    │    (Moderator)     │
                    │  0–1 / 2–4 / 5–7  │
                    │    days/week       │
                    └─────────┬─────────┘
                              │
                     Does PA weaken
                     this association?
                              │
                              ▼
┌────────────────┐                           ┌────────────────────┐
│  Screen Time   │        association        │  Insufficient      │
│  (IV)          │ ───────────────────────>   │  Sleep <8 hrs      │
│  <2 / 2–3 / 4+│   (cross-sectional;       │  (DV)              │
│  hrs/day       │    possibly bidirectional) │                    │
└────────────────┘                           └────────────────────┘

Covariates: Sex, Race/Ethnicity, Grade, Sexual Identity,
            Cyberbullying, BMI (sensitivity), Survey Year
Unmeasured: School start times, SES, Caffeine, Chronotype

RQ3 (2023 only): Replace Screen Time IV with
SM Frequency (≥ several times/day vs. less)
```

*No mediation arrows. Depression is reported as descriptive context in RQ1 trends only.*

---

## 4. Data Source

**CDC Youth Risk Behavior Survey (YRBS), 2015–2023** — nationally representative, ~13K–17K students per wave, freely downloadable. No IRB required (public, de-identified federal data).

| Waves | Purpose | N (approx) |
|-------|---------|------------|
| 2015, 2017, 2019, 2021 | RQ1–RQ2 (screen time) | ~56,000 pooled |
| 2023 | RQ3 (SM frequency) | ~17,000 |

**⚠️ Day 1 blocking task:** The general screen time question was likely dropped in 2023 (replaced by SM frequency). Download raw 2023 data and verify. If absent, RQ1–RQ2 use 2015–2021 only; RQ3 uses 2023 SM frequency as planned.

See Appendix A for key variables, covariates, and known data limitations.

---

## 5. Analysis Plan

All analyses use R's `survey` package for complex survey design (weights, strata, PSUs). Pooled weights = original weight ÷ number of years combined (per CDC guidance).

| RQ | Method | Key Output |
|----|--------|------------|
| **RQ1** | Weighted prevalence of high screen time, insufficient sleep, and co-occurrence by year × sex. Log-linear model testing whether co-prevalence grew beyond marginal trends. | Figure 1 (trend lines) + Table 1 |
| **RQ2** | Weighted logistic regression: insufficient sleep ~ screen time × PA + covariates (pooled 2015–2021). Stratified AORs by PA level if interaction is significant. Three-way interaction (× sex) is exploratory. | Tables 2–3 + Figure 2 (interaction plot) |
| **RQ3** | Weighted logistic regression: insufficient sleep ~ SM frequency × PA + covariates (2023 only). | Table 4 + Figure 3 |

**Sensitivity analyses:** (1) Exclude 2021 (COVID break), (2) Sleep as ordinal vs. binary, (3) Restrict to identical-wording years, (4) Models with/without BMI (potential collider). See Appendix B for details.

**Pre-registration:** Register on OSF *before* downloading data. See Appendix F for template.

---

## 6. Four-Week Timeline

| Week | Focus | Key Milestones |
|------|-------|----------------|
| **1** | Foundation | Pre-register on OSF (Mon). Download data, **verify screen time variable availability** (Tue — blocking). Clean data, compare question wording across years, literature review. |
| **2** | Analysis | RQ1 trends (Mon). RQ2 moderation + sensitivity analyses (Tue–Wed). RQ3 SM frequency (Thu). Mid-project review with mentor (Fri). |
| **3** | Writing | Methods (Mon), Results (Tue), Introduction (Wed), Discussion (Thu), Assemble draft + Abstract (Fri). |
| **4** | Revision & Submit | Peer review (Mon), Revise (Tue), Format for journal (Wed), Final proofread (Thu), **Submit + upload preprint to OSF** (Fri 🎉). |

---

## 7. Team Roles (~4 students + mentor)

| Role | Focus | Writes |
|------|-------|--------|
| **Data Lead** | Download raw CDC data, verify variables, clean, maintain R scripts/GitHub | Methods — Data Source |
| **Analysis Lead** | Run regressions, survey design, sensitivity analyses | Methods — Stats + Results |
| **Literature Lead** | Coordinate reading, Zotero references, annotated bibliography | Introduction + Discussion |
| **Visualization Lead** | Figures, manuscript formatting, supplementary tables | Figures/Tables + Abstract |
| **Mentor** | Verify survey weights Day 1, review stats Week 2, review draft Week 4 | Final review + cover letter |

---

## 8. Expected Contributions

### Scientific

- Tests PA as **moderator** (buffer) vs. Dai & Ouyang's mediator finding
- Extends Hoe et al. (2019) from NHANES (N=542, one cross-section) to YRBS (N~56K, 4 waves)
- Responds directly to CDC's MMWR 2024 gap statement
- Early analysis of 2023 YRBS SM-specific items in the context of sleep and PA

### Practical

- **If PA buffers:** Schools can promote PA as a concrete response — "exercise more" is more actionable than "use your phone less"
- **If PA doesn't buffer:** Challenges the assumption that exercise compensates for screen time — implies screen time reduction is necessary
- **If sex differences exist:** Interventions may need tailoring (Hoe et al. found PA buffered for boys but not girls on sleep quality)

### For Students

Publishable research at scale, pre-registration and open science, R programming, survey data analysis, academic writing — foundation for college applications and research careers.

---

## Appendix A: Variables & Data Details

### Key Variables

| Construct | YRBS Item | Operationalization |
|-----------|-----------|-------------------|
| **Screen time (IV)** — RQ1–RQ2 | "On an average school day, how many hours do you play video or computer games or use a computer for something that is not school work?" | Low (<2 hrs), Moderate (2–3 hrs), High (≥4 hrs) |
| **Sleep duration (DV)** | "On an average school night, how many hours of sleep do you get?" | Binary: Insufficient (<8 hrs) vs. Sufficient (≥8 hrs), per AASM ages 13–18. Also ordinal in sensitivity analysis. |
| **Physical activity (Moderator)** | "During the past 7 days, on how many days were you physically active for a total of at least 60 minutes per day?" | Low (0–1 day), Moderate (2–4 days), High (5–7 days) |
| **SM frequency (IV)** — RQ3 only | "How often do you use social media?" | Binary: Frequent (≥ several times/day) vs. Infrequent, per CDC MMWR dichotomization |
| **Depressive symptoms** | "…did you ever feel so sad or hopeless almost every day for two weeks or more…?" | Binary. Descriptive context in RQ1 only; not modeled as outcome. |

### Covariates

| Covariate | Justification |
|-----------|---------------|
| Sex | Females report worse sleep and more SM use |
| Race/ethnicity | Black students report less sleep; disparities documented |
| Grade | Older students report less sleep |
| Sexual identity | LGBTQ+ youth have worse sleep/mental health; harmonize coding across waves |
| Cyberbullying | CDC's 2023 analysis identified bullying as key pathway |
| BMI | Associated with both screen time and sleep; **potential collider** — run with and without |
| Survey year | Controls for secular trends when pooling |

### Unmeasured Confounders (Limitations)

| Confounder | Why It Matters |
|-----------|----------------|
| School start times | Strongest structural determinant of adolescent sleep duration |
| SES | Associated with screen time patterns and sleep environment; no income/education variable in YRBS |
| Caffeine | Associated with evening screen use and sleep disruption |
| Chronotype | Biological variation confounds both PA and screen time associations |

### Screen Time Question Availability

| Years | Status |
|-------|--------|
| 2015, 2017, 2019 | ✅ Available (wording may vary in platform examples) |
| 2021 | ⚠️ Verify — may have combined TV + digital device use |
| 2023 | ❌ Likely dropped; replaced by SM frequency question |

### Known Measure Limitations

| Limitation | Mitigation |
|-----------|------------|
| Screen time bundles SM with gaming (pre-2023) | RQ3 uses 2023 SM-specific question |
| SM frequency is a single crude item | Follow CDC's validated dichotomization; note as future research direction |
| Question wording evolved across years | Document exact wording (Appendix D); sensitivity analysis on identical-wording years |
| 2023 shifted from paper to tablet-based survey | CDC studies found mode did not affect prevalence estimates |
| Self-report bias | Inherent to all YRBS research; good test-retest reliability documented |
| Reverse causation (can't sleep → pick up phone) | Cannot resolve with cross-sectional data; discuss prominently |

---

## Appendix B: Sensitivity Analyses & Statistical Notes

### Sensitivity Analyses (RQ2)

1. **Exclude 2021** (COVID structural break — fall vs. spring administration)
2. **Sleep as ordinal** (hours) rather than binary — ordinal/linear regression with survey weights
3. **Restrict to identical-wording years** (likely 2015–2019)
4. **Models with and without BMI** — BMI may be a collider (screen time → reduced PA → higher BMI → worse sleep); report both, note discrepancies

### Three-Way Interaction Protocol

Before running Screen time × PA × Sex: tabulate cell sizes. If any cell has unweighted N < 50, collapse categories (e.g., binary PA). Three-way results are explicitly exploratory.

### Multiple Comparisons

No formal corrections (e.g., Bonferroni) applied to exploratory interaction tests, following conventions in observational epidemiology. Borderline interactions (0.01 < p < 0.05) interpreted with caution; emphasis on effect sizes and confidence intervals.

### Statistical Power

Pooled N~56K (RQ2) and ~17K (RQ3) provide strong power for main effects. Interaction effects require 4–16× sample size of main effects (Aguinis, 1995). Sample is adequate for two-way interactions of moderate effect size but may be underpowered for the three-way interaction.

---

## Appendix C: Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Screen time question absent from 2023 | High | High | Blocking Day 1 verification. If absent: RQ1–2 use 2015–2021; RQ3 uses 2023 SM frequency. |
| Screen time wording changed in 2021 | Medium | High | Download questionnaire PDF Day 1. If changed: sensitivity analysis excluding 2021. |
| PA × screen time interaction is null | Medium | Medium | Null is publishable: "PA does not buffer" is informative and challenges assumptions. |
| PA associated with *worse* sleep duration | Medium | Medium | Consistent with Hoe et al. (early-morning practices). If replicated, discuss mechanisms. |
| COVID structural break biases 2021 | High | Medium | Flag 2021 on charts. Report models with and without 2021. |
| BMI as collider | Medium | Medium | Report models with and without BMI. |
| YRBS data access instability | Medium | Medium | Download and archive all raw data locally Day 1. `dissertationData` R package as backup. |
| `dissertationData` lacks survey design vars | Medium | High | Use raw CDC data as primary source; package is backup only. |
| Reverse causation | High | Medium | Discuss prominently in limitations. Cannot resolve with cross-sectional data. |
| Competitor publishes similar analysis | Low | High | Pre-register on OSF to timestamp priority. Our specific combination is unique. |
| Three-way interaction cell sizes too small | Medium | Medium | Tabulate before modeling. Collapse PA to binary or report two-way stratified by sex. |
| R learning curve for high schoolers | Medium | Medium | Mentor provides starter code. Analysis Lead works in R; others focus on writing/visualization. |
| Manuscript rejected by first journal | Medium | Low | Preprint on OSF for immediate visibility. Submit to backup journals. |

---

## Appendix D: Question Wording Comparability Checklist

Download questionnaire PDFs from CDC and complete this table. **Blocking task — results determine the study design.**

| Year | Screen Time Question Text (exact) | Example Platforms | Response Options | Survey Mode | Identical to 2019? | Variable Present? |
|------|----------------------------------|-------------------|------------------|-------------|---------------------|-------------------|
| 2015 | | | | Paper | | ✅ Verify |
| 2017 | | | | Paper | | ✅ Verify |
| 2019 | | | | Paper | Baseline | ✅ Verify |
| 2021 | | | | Paper (fall) | | ⚠️ May differ |
| 2023 | | | | Tablet | | ❌ Likely absent |

Also check: CDC YRBS Questionnaire Content 1991–2023 document. Include completed table as Supplementary Table S1.

---

## Appendix E: Publication Venues

| Journal | Fit | Review | APC | Notes |
|---------|-----|--------|-----|-------|
| **Cureus** | ✅ Best | 2–4 wks | Free | Open access; publishes student work; PubMed indexed |
| **Journal of Student Research** | ✅ Excellent | 4–6 wks | Free | For student-authored research |
| **IJHSR** | ✅ Good | 4–8 wks | Free | For high school researchers |
| **PLOS ONE** | 🟡 Stretch | 8–12 wks | ~$2K | Broad scope; rigorous methodology required |
| **Frontiers in Public Health** | 🟡 Stretch | 8–12 wks | ~$3K | Open access; accepts observational studies |

**Strategy:** Submit to Cureus first. Upload preprint to OSF simultaneously. If rejected, revise for JSR or IJHSR.

---

## Appendix F: Pre-Registration Template (OSF)

**Submit Day 1, Monday — BEFORE downloading data.**

```
Title: Does Physical Activity Buffer the Association Between Screen Time
       and Insufficient Sleep Among U.S. High School Students?

Authors: [Student names], [Mentor name]

Data source: CDC YRBS 2015–2023 (public, de-identified)
  - RQ1–RQ2: 2015–2021 pooled (screen time variable)
  - RQ3: 2023 only (social media frequency variable)
  Note: If Day 1 verification reveals screen time variable exists in
  2023, RQ1–RQ2 will expand to 2015–2023.

Research Questions:
  RQ1: Trend in co-prevalence of high screen time and insufficient
       sleep (2015–2021), with formal test of co-prevalence growth
  RQ2: PA × screen time interaction on insufficient sleep (pooled
       2015–2021)
  RQ3: (2023) SM frequency predicts insufficient sleep; PA moderates

Primary outcome: Insufficient sleep (<8 hrs on school nights), binary
Primary predictor: Screen time (categorical: <2, 2–3, ≥4 hrs/day)
  for RQ1–RQ2; SM frequency (binary) for RQ3
Moderator: Physical activity (categorical: 0–1, 2–4, 5–7 days/week)
Covariates: Sex, race/ethnicity, grade, sexual identity, cyberbullying,
            BMI, survey year (RQ1–RQ2 only)

Analysis: Weighted logistic regression with interaction term using
          survey package in R. Stratified AORs if interaction p < 0.05.
          Three-way interaction (× sex) is exploratory.

Sensitivity analyses:
  1. Exclude 2021 (COVID structural break)
  2. Sleep as ordinal (hours) vs. binary
  3. Restrict to years with identical question wording
  4. Models with and without BMI (collider check)

Limitations acknowledged a priori:
  - Cross-sectional design; reverse causation possible
  - Unmeasured confounders: school start times, SES, caffeine, chronotype
  - Multiple models without formal correction; interpret borderline
    interactions with caution
  - Hoe et al. (2019) found PA may reduce sleep duration even as it
    improves quality; a null or adverse finding for duration is plausible

This study was pre-registered BEFORE any data were accessed.
```

---

## Appendix G: Essential Reading List

### Must-Read (assign across team)

| # | Citation | Relevance |
|---|----------|-----------|
| 1 | **Young et al. (2024)** — MMWR Suppl. 73(4):1–10. CDC's 2023 SM analysis. | Contains the gap statement we respond to. Must cite and quote. |
| 2 | **Dai & Ouyang (2026)** — *Humanities & Social Sciences Communications* 13, 256. | Most direct competitor. PA as mediator (NSCH, ages 6–17). We test moderator (YRBS, high school). |
| 3 | **Hoe et al. (2019)** — *Int J Environ Res Public Health* 16, 1524. | PA × screen time on sleep quality (not duration) via NHANES (N=542). We extend with YRBS (N~56K). |
| 4 | **CDC YRBS Data Summary & Trends (2025)** — Dietary, PA, Sleep: 2013–2023. | Baseline trend data. Only 23% meet sleep guidelines. |
| 5 | **PMC12652926 (2024)** — Excessive Screen Time Among U.S. High School Students. | Similar methodology (YRBS 2019). Documents 2023 dropped general screen time question. |

### Methods References

| # | Citation | Purpose |
|---|----------|---------|
| 6 | CDC "Combining YRBS Data Across Years and Sites" | Required for pooling survey weights |
| 7 | CDC "Software for Analysis of YRBS Data" | Survey weight handling in R |
| 8 | CDC 2023 YRBS Data User's Guide | Codebook, variable definitions |
| 9 | CDC YRBS Questionnaire Content 1991–2023 (PDF) | Which questions in which years |

### Background (skim)

| # | Citation | Purpose |
|---|----------|---------|
| 10 | Chen et al. (2024) — Meta-analysis, 40 studies | SM → sleep landscape |
| 11 | Khan et al. (2024) — HBSC, 212K, 40 countries | SM → sleep in adolescents |
| 12 | Scoping review of reviews (2025) — PMC12840076 | 11 reviews reviewed |
| 13 | Maxwell & Cole (2007) — Bias in cross-sectional mediation | Why we dropped mediation |

---

## Appendix H: Starter R Code

```r
# ============================================================
# STEP 1: Download raw CDC data (PRIMARY SOURCE)
# ============================================================
# https://www.cdc.gov/yrbs/data/national-yrbs-datasets-documentation.html
library(survey)
data(yrbs)  # small example bundled with survey package
names(yrbs) # → "weight" "stratum" "psu" "qn8" ...

# ============================================================
# STEP 2: BLOCKING VERIFICATION (Day 1)
# ============================================================
# After loading each year's data:
# (a) Confirm survey design variables exist
survey_vars <- c("weight", "stratum", "psu")
# all(survey_vars %in% tolower(names(yrbs_2023)))

# (b) Check if screen time variable exists in 2023
# Look for Q79, Q80, Q81 or similar
# If NOT found → confirm two-part study design

# (c) Check 2021 screen time question wording vs. 2019

# ============================================================
# STEP 3: SURVEY DESIGN SETUP
# ============================================================
library(survey); library(dplyr); library(ggplot2)
options(survey.lonely.psu = "adjust")

n_years <- 4  # 2015, 2017, 2019, 2021
yrbs_pooled <- yrbs_combined %>%
  filter(year %in% c(2015, 2017, 2019, 2021)) %>%
  mutate(pooled_weight = weight / n_years)

yrbs_design <- svydesign(
  ids = ~psu, strata = ~stratum,
  weights = ~pooled_weight, data = yrbs_pooled, nest = TRUE
)

# ============================================================
# RQ1: DESCRIPTIVE TRENDS
# ============================================================
yrbs_design <- update(yrbs_design,
  insuff_sleep = as.numeric(sleep_hours < 8),
  high_screen  = as.numeric(screen_time_hrs >= 4)
)
trend_sleep <- svyby(~insuff_sleep, ~year, yrbs_design, svymean, na.rm=TRUE)

# ============================================================
# RQ2: MODERATION (PA × Screen Time → Sleep)
# ============================================================
yrbs_design <- update(yrbs_design,
  pa_cat = cut(pa_days, breaks = c(-1, 1, 4, 7),
               labels = c("Low (0-1)", "Moderate (2-4)", "High (5-7)"))
)

model_mod <- svyglm(
  insuff_sleep ~ screen_cat * pa_cat + sex + race_eth + grade +
    sexual_identity + cyberbullying + bmi_cat + factor(year),
  design = yrbs_design, family = quasibinomial()
)

# Sensitivity: without BMI (collider check)
model_no_bmi <- svyglm(
  insuff_sleep ~ screen_cat * pa_cat + sex + race_eth + grade +
    sexual_identity + cyberbullying + factor(year),
  design = yrbs_design, family = quasibinomial()
)

# Test interaction significance
library(car)
linearHypothesis(model_mod, grep("screen_cat.*pa_cat",
  names(coef(model_mod)), value = TRUE))

# Stratified AORs by PA level
for (pa in levels(yrbs_design$variables$pa_cat)) {
  sub <- subset(yrbs_design, pa_cat == pa)
  m <- svyglm(insuff_sleep ~ screen_cat + sex + race_eth + grade +
    sexual_identity + cyberbullying + bmi_cat + factor(year),
    design = sub, family = quasibinomial())
  cat("\n--- PA Level:", pa, "---\n")
  print(exp(cbind(AOR = coef(m), confint(m))))
}

# ============================================================
# RQ3: SM FREQUENCY (2023 only)
# ============================================================
yrbs_2023_design <- svydesign(
  ids = ~psu, strata = ~stratum, weights = ~weight,
  data = yrbs_2023, nest = TRUE
)
model_sm <- svyglm(
  insuff_sleep ~ sm_frequent * pa_cat + sex + race_eth + grade +
    sexual_identity + cyberbullying + bmi_cat,
  design = yrbs_2023_design, family = quasibinomial()
)
```

---

## Appendix I: Ethical Considerations

- **No IRB required.** Secondary analysis of publicly available, de-identified federal data.
- **No identifiable data.** No names, school identifiers, or sub-state geographic identifiers.
- **Responsible reporting.** Associations framed as associations, never causation. Reverse causation acknowledged. Avoid deficit framing of racial/ethnic groups. Null findings reported honestly.
- **Pre-registration.** Analysis plan registered before data access to prevent p-hacking.
