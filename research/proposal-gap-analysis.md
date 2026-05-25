# Gap Analysis: Social Media–Sleep–Mood Proposal

## Critical review of `/Users/hua/agent/social-media-sleep-mood-proposal.md`

---

## Summary: 13 gaps found — 4 are serious enough to sink the paper if unaddressed

| Severity | Count | Description |
|----------|-------|-------------|
| 🔴 **Fatal if unaddressed** | 4 | Novelty claim false, competitor already published, methodology outdated, scope too large |
| 🟡 **Weakens paper significantly** | 5 | Question wording changes, COVID break, missing confounders, survey weights, no pre-registration |
| 🟢 **Minor / easy fix** | 4 | SM item is thin, package verification needed, power analysis, conceptual model integration |

---

## 🔴 GAP 1: The "PA as moderator is novel" claim is FALSE

### What the proposal claims
> "Nearly every study controls for PA statistically but no one has tested: does PA actually protect teens from the negative sleep effects of screen time?"

### What the literature actually shows

**Dai & Ouyang (2026)** — Published January 2026 in *Humanities and Social Sciences Communications* (Nature portfolio):
- Tested PA as a **mediator** (not moderator) of screen time → mental health
- Used NSCH 2020-2021, N=50,231 US children ages 6-17
- Found **PA was the strongest mediator**, explaining **30.9%–38.9%** of the screen time–mental health association
- Also tested sleep duration and bedtime regularity as parallel mediators
- Used SEM + exact natural effect models — more sophisticated than anything in our proposal

**Hoe et al. (2019)** — Published in *International Journal of Environmental Research and Public Health*:
- Used NHANES with **objectively measured** PA (accelerometer) in US adolescents
- Tested the **combined effect** of meeting PA + screen time recommendations on sleep quality
- Found meeting both recommendations was associated with better sleep quality in males
- First to test the PA × screen time interaction on sleep in a nationally representative US sample

**HBSC 12-country study (2019)** — Published in *International Journal of Environmental Research and Public Health*:
- N=49,403 adolescents, 12 European countries
- Tested sleep as a **mediator** of screen time → psychological symptoms
- PA was included as a separate predictor with its own mediated pathway

### The fix
The distinction between **moderator** (does PA *buffer* the effect?) vs **mediator** (does screen time *reduce* PA, which then harms sleep?) is real and important. But the proposal must:
1. Cite Dai & Ouyang (2026) and Hoe et al. (2019) explicitly
2. Explain why **moderation** (buffering) is a different and complementary question to **mediation** (pathway)
3. Reframe: "Dai & Ouyang showed PA mediates the pathway; we test whether PA *moderates* it — i.e., does being active protect you even if you have high screen time?"
4. Drop the "first study" language and use "extends" or "complements"

---

## 🔴 GAP 2: CDC already published the 2023 social media analysis — RQ7 is partially scooped

### What happened
CDC published a dedicated MMWR supplement report in **October 2024**:

> **"Frequent Social Media Use and Experiences with Bullying Victimization, Persistent Feelings of Sadness or Hopelessness, and Suicide Risk Among High School Students — Youth Risk Behavior Survey, United States, 2023"**

Key findings:
- ~75% of students used SM at least several times a day
- Frequent SM use was associated with bullying, sadness/hopelessness, considering suicide, and making a suicide plan
- **No association** with attempted suicide
- Stratified by sex and sexual identity

### What the CDC explicitly identified as the gap (this is GOOD NEWS)
> *"Analyses did not describe indirect pathways (e.g., through online victimization or **reduced sleep quality**) through which frequent social media use might influence mental health and suicide risk, or **protective factors** (e.g., connectedness to others) that might **buffer** the negative impacts of frequent social media use."*

The CDC literally called out **sleep as an unexplored pathway** and **buffering protective factors** as a gap. This is exactly the proposed project's angle.

### The fix
1. **Cite the CDC MMWR report** and quote the gap statement directly
2. Reframe RQ7 from "Is SM a stronger predictor than screen time?" to **"Does sleep mediate the SM–depression pathway, and does PA buffer it?"** — this is the gap CDC identified
3. The proposal should position itself as a **direct response to the CDC's call** for research on indirect pathways and protective factors

---

## 🔴 GAP 3: The mediation methodology is outdated and inappropriate

### What the proposal recommends
> "Baron & Kenny steps + Sobel test, OR structural equation modeling (SEM) via `lavaan`"

### The problems

1. **Baron & Kenny (1986) is considered obsolete.** The method has been criticized extensively (see Hayes, 2009; Zhao et al., 2010; Rucker et al., 2011). Most journals will flag this.

2. **Sobel test assumes normal distribution of the indirect effect** — inappropriate for binary mediators/outcomes, which is exactly what YRBS gives us (insufficient sleep = binary, depression = binary).

3. **Cross-sectional mediation is inherently weak.** You cannot establish temporal ordering (did screen time → poor sleep → depression, or did depression → poor sleep → more screen time?). Many methodologists argue cross-sectional mediation should not be done at all (Maxwell & Cole, 2007).

4. **Binary mediator + binary outcome** requires specialized approaches: causal mediation analysis via the `mediation` package (Imai et al., 2010), counterfactual framework, or generalized SEM.

### The fix
1. Replace Baron & Kenny with the **causal mediation framework** using the `mediation` R package (Tingley et al., 2014)
2. Use **bootstrap confidence intervals** for indirect effects (the proposal mentions this but doesn't connect it to the right method)
3. Add a **prominent limitations paragraph** acknowledging that cross-sectional mediation cannot establish causality and the temporal ordering is assumed
4. Consider keeping sleep as a **continuous** variable (hours) rather than binary for the mediation model — more statistical power and avoids the binary-binary problem
5. Or simply **drop mediation** and focus on moderation (which is the core contribution anyway). This reduces scope, which helps with Gap 8.

---

## 🔴 GAP 4: The project scope is too large for 4 weeks with high schoolers

### What the proposal includes
- 4 primary RQs + 3 exploratory RQs = **7 research questions**
- Trend analysis across 5 waves (RQ1)
- Logistic regression with covariates (RQ2)
- Moderation analysis with interaction terms (RQ3)
- Mediation/SEM analysis (RQ4)
- Subgroup analyses by sex AND race/ethnicity (RQ5-RQ6)
- 2023 SM-specific deep-dive (RQ7)

### Why this is too much
- Each of these is a **separate paper** for experienced researchers
- Week 2 has students doing logistic regression Monday, moderation Tuesday, stratified analyses Wednesday, mediation/SEM Thursday, and subgroup analyses Friday. That's 5 different statistical techniques in 5 days.
- High school 10th-11th graders, even with stats background, have likely never used R, never handled survey weights, never run logistic regression
- The mentor is a **college graduate** (not a PhD student or professor), which limits the depth of methodological guidance available
- Writing a full manuscript in 5 days (Week 4) while also doing peer review and formatting is unrealistic

### The fix: Cut to 3 RQs maximum

**Keep:**
- RQ1 (descriptive trends — foundational, easy, teaches data handling)
- RQ3 (PA moderation — this is the core novel contribution)
- RQ7 reframed (2023 SM → sleep → depression, with PA as buffer — responds to CDC gap)

**Drop or move to "future work":**
- RQ2 (main effect of screen time on sleep — this is already established by dozens of studies, adds nothing)
- RQ4 (mediation — methodologically problematic with cross-sectional data, high schoolers can't do SEM properly in 4 weeks)
- RQ5-RQ6 (subgroup analyses — interesting but doubles the number of models; save for a follow-up paper)

**Revised timeline:**
- Week 1: Setup + data + lit review (same)
- Week 2: Descriptive trends + PA moderation analysis (2 techniques, not 5)
- Week 3: 2023 SM deep-dive + writing begins
- Week 4: Writing + revision + submission

---

## 🟡 GAP 5: YRBS screen time question wording changed across years

### The problem
The 2015 YRBS screen time question lists: *"Xbox, PlayStation, an iPod, an iPad or other tablet, a smartphone, texting, YouTube, Instagram, Facebook, or other social media"*

By 2023, the iPod was discontinued, TikTok became dominant, and the platform landscape shifted. If CDC updated the example platforms in the question text, the measure may not be strictly comparable across years.

Additionally, in 2023 the survey switched from **paper-and-pencil booklets to tablet-based electronic survey**. Mode effects on self-reported behavior are well-documented.

### The fix
1. Download the actual questionnaire PDFs for each year (2015, 2017, 2019, 2021, 2023) and compare the exact wording
2. Document any changes in a **supplementary table**
3. If wording changed, include a **sensitivity analysis** limiting trend analysis to the years with identical wording
4. Acknowledge mode change (paper → tablet in 2023) as a limitation

---

## 🟡 GAP 6: The 2021 YRBS has a COVID-19 structural break

### The problem
- 2021 YRBS was administered in **fall (Sept-Dec)** instead of the usual spring (Jan-June) due to COVID
- Sleep patterns, screen time, and depression were all dramatically affected by COVID disruptions
- This creates a non-comparable data point in the trend analysis
- The proposal treats all 5 waves as equivalent

### The fix
1. Add a **COVID indicator variable** (2021 = 1, others = 0) as a covariate
2. Conduct a **sensitivity analysis** excluding 2021
3. Discuss the fall vs. spring administration difference as a limitation
4. Consider visual markers on trend charts showing the COVID disruption

---

## 🟡 GAP 7: Critical confounders are missing from the model

### Currently controlled for
Sex, race/ethnicity, grade, survey year

### Missing but available in YRBS
| Confounder | Why it matters | YRBS variable |
|-----------|---------------|---------------|
| **Sexual identity (LGBTQ+)** | LGBTQ+ youth have significantly worse sleep and mental health; they also use SM differently | Sexual identity question (2015+) |
| **Bullying/cyberbullying** | CDC's own 2023 analysis showed SM → bullying → mental health pathway | Q24-Q25 |
| **BMI/weight status** | Obesity is associated with both screen time and sleep disturbance | Calculated from height/weight |
| **Academic grades** | Proxy for SES; associated with sleep and screen time | Available in some years |
| **Substance use (alcohol/marijuana)** | Confounds the sleep-depression relationship | Multiple questions |

### The fix
Add at minimum: **sexual identity, cyberbullying victimization, and BMI** as covariates. These are available in YRBS and would be flagged immediately by reviewers if omitted.

---

## 🟡 GAP 8: Survey weight handling for pooled analysis is not specified

### The problem
The proposal says "use survey weights throughout" but doesn't specify HOW to pool weights across years. The CDC's "Combining YRBS Data Across Years and Sites" guide has specific rules:
- Divide each year's weight by the number of years combined
- Pooled PSU and stratum variables may need adjustment
- Getting this wrong invalidates every single estimate

### The fix
1. Read and follow the CDC guide (already in the reading list — but should be in the Methods section, not just the reading list)
2. Add explicit weight adjustment formula: `pooled_weight = original_weight / n_years`
3. Update the starter R code to include this step
4. Have the mentor verify the survey design specification before any analysis begins

---

## 🟡 GAP 9: No pre-registration

### The problem
For secondary data analysis of publicly available data, pre-registration is increasingly expected. It signals to reviewers that the analysis was planned, not p-hacked from 70K observations.

### The fix
1. Pre-register on **OSF** (Open Science Framework) or **AsPredicted** before any analysis begins
2. Takes 30 minutes on Day 1
3. Significantly strengthens publication chances
4. Teaches students about open science practices

---

## 🟢 GAP 10: The 2023 SM item is a single, crude measure

### The problem
The 2023 YRBS social media question is:
> "How often do you use social media?"
> Response options: I do not use / A few times a month / About once a week / A few times a week / About once a day / Several times a day / About once an hour / More than once an hour

This measures **frequency** only — not:
- Timing (bedtime use, which is the strongest predictor of poor sleep)
- Platform (TikTok vs Instagram)
- Content type (passive scrolling vs active posting)
- Duration (hours per day)

### The fix
1. Acknowledge this limitation explicitly
2. The variable is still useful — the CDC already used this exact dichotomization (several times a day = "frequent") and found significant associations
3. Frame the SM analysis as "frequency-based" and note that future research needs more granular SM measures

---

## 🟢 GAP 11: The `dissertationData` R package may not include survey design variables

### The problem
The package is focused on suicide research and provides "cleaned" data. It's unclear whether it preserved the PSU, stratum, and weight variables needed for the `survey` package. The starter code assumes `~PSU`, `~stratum`, `~weight` exist without verification.

### The fix
1. **Verify on Day 1**: Install the package, load the data, and check if these variables exist
2. Have a **backup plan**: Download raw data directly from CDC and use the SAS/SPSS conversion programs
3. Update the starter code with the ACTUAL variable names after verification
4. The `survey` R package includes a small YRBS example dataset with known variable names (`psu`, `weight`, `stratum`) — this can be used for practice

---

## 🟢 GAP 12: No power analysis for subgroup interactions

### The problem
With 70K+ total observations, main effects will have ample power. But if subgroup analyses are retained (RQ5-6), three-way interactions (screen time × PA × sex × race) create cells with potentially very small sample sizes. For example: Black female students with 0-1 days PA and 5+ hours screen time — this cell might have N < 50.

### The fix
1. If subgroups are retained: calculate expected cell sizes before running models
2. Collapse categories if cells are too small (e.g., combine "Other" race categories)
3. This is less critical if subgroup analyses are dropped per Gap 4

---

## 🟢 GAP 13: Moderated mediation model is improperly specified

### The problem
The conceptual model shows PA moderating the screen time → sleep path AND sleep mediating the screen time → depression path. This is a **moderated mediation** model. But the proposal treats moderation (RQ3) and mediation (RQ4) as **separate analyses** with separate steps. This loses the integrated test.

### The fix
If mediation is retained (I recommend dropping it per Gap 3-4):
1. Use **Hayes PROCESS Model 7** (moderated mediation: moderator on the a-path)
2. Or use the `mediation` package with interaction terms
3. Report the **index of moderated mediation** — does the indirect effect of screen time → sleep → depression differ across PA levels?

But again: **dropping mediation entirely** and focusing on the PA moderation of screen time → sleep is simpler, more defensible, and sufficient for a novel contribution.

---

## Revised Proposal Structure (incorporating all fixes)

### New title
**"Does Physical Activity Buffer the Association Between Screen Time and Insufficient Sleep Among U.S. High School Students? Evidence from the Youth Risk Behavior Survey, 2015–2023"**

*(Drop "Depression Pathway" — keep the focus tight on sleep)*

### Reduced to 3 RQs

| # | Research Question | Method |
|---|-------------------|--------|
| RQ1 | How has the prevalence of high screen time (≥4 hrs) and insufficient sleep (<8 hrs) changed from 2015 to 2023? | Weighted prevalence by year, stratified by sex. Trend charts. |
| RQ2 | Does physical activity moderate the association between screen time and insufficient sleep? | Logistic regression with screen time × PA interaction. Stratified AORs. Interaction plots. |
| RQ3 | (2023 only) Does frequent social media use (≥several times/day) predict insufficient sleep after controlling for general screen time and PA? | Logistic regression adding SM frequency to existing model. Tests incremental predictive value. |

### Covariates
Sex, race/ethnicity, grade, sexual identity, cyberbullying victimization, BMI, survey year

### Methods
- Complex survey design with properly pooled weights
- Pre-registered on OSF
- COVID sensitivity analysis (exclude 2021)
- Question wording comparability check

### Timeline (same 4 weeks, reduced scope)
- **Week 1**: Setup, data, lit review, pre-registration, verify survey weights
- **Week 2**: RQ1 (trends) + RQ2 (moderation) — just two analyses
- **Week 3**: RQ3 (2023 SM) + begin manuscript
- **Week 4**: Complete manuscript + submit

### Target journals (unchanged)
Cureus or Journal of Student Research

---

## The single most important thing to get right

**The framing.** The paper should position itself as a **direct response to the CDC's 2023 MMWR gap statement**: the CDC analyzed SM use and mental health but explicitly called for research on (1) indirect pathways through sleep and (2) protective factors that buffer the negative effects. That's exactly what this project does. Frame it that way and the novelty argument writes itself.

---

*Gap analysis completed: 2026-05-23*
