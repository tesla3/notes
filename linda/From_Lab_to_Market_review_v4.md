# Critical Review: "What's Left of the Dye-Free Premium?" Proposal (v3)

**Date:** June 7, 2026  
**Target:** `From_Lab_to_Market_proposal_v3.md`  
**Verdict:** v3 is a strong, well-scoped proposal that addresses nearly every issue from prior reviews. The v1→v2→v3 arc is impressive — from a "boil the ocean" original to a tightly focused, methodologically honest design. It is appropriate for a high school summer research program and better than most undergraduate proposals in this space. But **four high-severity gaps remain**, plus several medium-priority issues. All are fixable. None are fatal.

---

## What v3 Got Right

Credit where due. The v3 proposal fixed every major issue from prior reviews:

- **Temporal claim eliminated.** The title honestly says "What's Left of..." not "Disappearing Premiums." Cross-sectional design acknowledged throughout. This was the v2's fatal flaw — now resolved.
- **Cost confound acknowledged.** Limitation #1 explicitly states that observed premiums include both WTP and cost pass-through. The three-group product classification (A/B/C) separates natural-colorant products from truly colorant-free ones.
- **February 2026 labeling change integrated.** The coding scheme accounts for the FDA's enforcement discretion policy. Multiple authoritative sources cited.
- **Regulatory timeline corrected.** October 2027 compliance target, voluntary status clearly stated.
- **Statistics appropriate for high schoolers.** Paired Wilcoxon, Mann-Whitney U, Cohen's κ — all within reach. No hedonic regression required.
- **Tiered deliverables with fallback.** The "must ship" / "should ship" / "stretch" structure with a feasibility gate is well-designed.
- **RQ3 (claim vs. no-claim) is genuinely clever.** Comparing dye-free products WITH vs. WITHOUT the label claim is a better test than the v2 review's verified-vs-unverified comparison. It avoids the USDA Organic confound.
- **Honest limitations section.** Five specific limitations, each with the right caveats.
- **Explicit "What This Proposal Does NOT Do" section.** Smart — preempts common reviewer objections.

The proposal is publishable. The question is whether remaining gaps weaken the interpretation or create execution risk.

---

## Gap 1 (HIGH): The Parity-Pricing Problem — What If There Is No Premium?

This is the most consequential gap v3 does not address.

The proposal predicts a ≥5% dye-free premium (RQ1). But emerging market evidence suggests major brands are pricing reformulated products **at parity with their dyed counterparts** — not at a premium.

The most concrete case: **Doritos Simply NKD** (launched December 2025, dye-free reformulation) is priced **identically** to regular Doritos at Walmart:

> *"The new versions are currently for sale in Walmart stores throughout the US and **priced at the same level** as the regular versions, or about $4."* — Daily Mail, February 2026

> *"Early SKU innovations seem to signal these shifts aren't leading to price increases, as **Walmart retails Doritos Spicy Nacho and Nacho Cheese NKD offerings the same.**"* — Food Institute, February 2026

Walmart's own reformulation of its entire private-brand line (Great Value, Marketside, etc.) has been announced as preserving "affordability" — suggesting parity pricing:

> *"Our customers have told us they want products made with simpler, more familiar ingredients... By eliminating synthetic dyes and other ingredients, we're reinforcing our promise to **deliver affordable food** that families can feel good about."* — John Furner, Walmart President/CEO, October 2025

If the dominant market strategy is parity pricing — reformulate but don't raise prices — then **RQ1 may find no significant premium at all.** This isn't a methodological flaw; it's a substantive finding. But the proposal doesn't prepare for it.

### Why This Matters

The proposal's entire interpretive framework assumes a positive premium that is eroding. If the premium is zero, the framing collapses. The "Challenged If" column for RQ1 says "Premium < 5% or not significant" would suggest "the market has already absorbed the transition with minimal price impact" — but this interpretation is too thin. A null result could mean:

1. **The transition is too advanced.** Dye-free is already the expected baseline; no one can charge for it.
2. **Competitive dynamics prevent premiums.** When all competitors reformulate simultaneously, no individual firm can charge extra.
3. **Brands absorb costs.** Natural colorants cost more, but firms eat the margin to maintain market share during the transition.
4. **The premium never existed as a dye-specific attribute.** Historical "premiums" were always about organic/natural brand positioning, not dye-free status per se.

Each interpretation has different theoretical implications. The proposal should develop all four and specify which data patterns would distinguish them.

### Fix

Add a section on **interpreting null/near-zero results.** Specifically:

- If premium ≈ 0% across both categories → supports interpretation #1 or #2 (parity pricing as competitive outcome)
- If premium ≈ 0% in high-reformulation categories but >0% in low-reformulation categories → supports interpretation #1 (transition-stage effect)
- If premium ≈ 0% but RQ3 claim premium is positive → supports interpretation #4 (the premium is about marketing, not composition)

Also: add the Doritos NKD pricing data as a motivating example in the Project Overview. It makes the research question sharper: *"PepsiCo prices its dye-free Doritos the same as regular Doritos. Is this an anomaly or the new normal?"*

---

## Gap 2 (HIGH): RQ3's "Sharpest Test" Claim Is Overstated

The proposal calls RQ3 "the sharpest test in this proposal" and claims:

> *"Both products are dye-free; only one says so on the label. Any price difference is pure signal value."*

This overclaims. The design **does not** isolate "pure signal value" because brands that choose to put "no artificial colors" on the front of the package are **not randomly assigned.** They are systematically different:

- **Brand positioning.** Brands that claim "no artificial colors" tend to be premium/natural-positioned brands (Annie's, Simple Mills, Nature's Path) that are more expensive across the board.
- **Bundled claims.** Products with "no artificial colors" frequently also carry "non-GMO," "organic," "whole grain," or "clean label" claims. The price difference reflects the bundle, not the individual claim.
- **Marketing investment.** Front-of-pack health claims signal marketing sophistication and higher marketing spend, which correlates with higher prices.
- **Target demographic.** Claimed-dye-free products target higher-income, health-conscious shoppers — a segment with lower price sensitivity.

A product-level example: Annie's Bunny Grahams (claims "no artificial colors") vs. store-brand animal crackers (dye-free but no claim). The price difference reflects Annie's brand equity, organic sourcing, marketing, and target demographic — not the act of printing "no artificial colors" on the box.

### What Would Truly Isolate the Claim Effect

The **only** clean test would be **within-brand, within-product-line** comparisons where one SKU carries the claim and another doesn't, with identical composition. This is rare but not impossible — a brand might add a "no artificial colors" burst to its packaging for some SKUs but not others, or in some retailers but not others. Finding ≥20 such pairs is likely infeasible.

### Fix

Don't call it "the sharpest test." Call it "the most theoretically interesting comparison, with acknowledged limitations." Add brand tier (premium vs. value vs. store brand) and the presence of other health claims (organic, non-GMO) as confounding variables that students should record during data collection. Report whether the claim premium persists after restricting to same-brand-tier comparisons.

Also, reframe the prediction more modestly:

> **Current:** "Claim premium ≥ 3% over unclaimed dye-free products."  
> **Better:** "Among compositionally similar dye-free products, those with front-of-pack 'no artificial colors' claims are associated with higher unit prices. This association may reflect the signaling value of the claim, brand-level positioning, or both."

---

## Gap 3 (HIGH): The Meta-Analytic Benchmarks Compare Wrong Claim Types

RQ1b compares the observed dye-free premium to ~30% baselines from Li & Kallas (2021) and Alsubhi et al. (2023). The proposal acknowledges these are stated-preference vs. observed-price, and different methods. But there's a deeper problem: **they're measuring different attributes.**

**Li & Kallas (2021)** meta-analyzed WTP for "sustainable food products" across 80 studies. The 29.5% average is across **organic, fair trade, local, environmentally friendly, animal welfare, and other sustainability attributes** — not "dye-free" specifically. From their paper:

> *"The overall WTP premium for sustainability (in percentage terms) is **29.5% on average**"* — Li & Kallas 2021, Appetite, 104195

The organic attribute alone had a higher WTP; local was 21.1%. "Dye-free" was not a category they studied.

**Alsubhi et al. (2023)** meta-analyzed WTP for "healthier food products" including reduced fat, sugar, salt, added fiber, and functional ingredients. The 30.74% mean was across experiments on reformulated products with specific nutritional improvements — not "absence of a dye." From PMC:

> *"The overall WTP analysis shows that in most of the experiments (88.5%), consumers showed a preference for healthier food in comparison to conventional food, demonstrated by WTP a price premium ranging from 5.6% to 91% **(mean 30.74%)**"* — Alsubhi et al. 2023, Obesity Reviews

Neither meta-analysis includes "dye-free" or "no artificial colors" as a studied attribute. The 30% figure is an average across **much larger attribute bundles** (organic certification, nutritional improvement) that carry substantially more consumer-perceived value than mere dye absence.

### Why This Matters

Comparing the observed dye-free premium to a 30% benchmark for organic/healthy food broadly is like comparing a compact car's price to the average price across all car types — and concluding the compact is "discounted" because it's below average. The dye-free attribute may **never have commanded** a 30% premium, even pre-transition. Without a dye-specific baseline, you can't measure erosion.

### Fix

Three options, in order of strength:

1. **Search for dye-specific WTP studies.** I found none in my searches — which itself is a finding. State this explicitly: *"No published study has isolated WTP specifically for 'dye-free' or 'no artificial colors' as a standalone attribute, making direct benchmark comparison impossible."*

2. **Reframe RQ1b as indicative context, not a test.** Currently the "Challenged If" says "Observed premium ≥ 30% — would suggest the transition has not eroded the signal." This implies 30% is the expected pre-transition baseline for dye-free. It isn't. Reframe: *"We contextualize our findings against published WTP estimates for broader health claims (~30%), recognizing that dye-free status is a narrower attribute and would be expected to command a smaller premium even absent any regulatory transition."*

3. **Drop RQ1b as a formal research question and retain it as discussion context.** This is the most honest approach. The benchmark comparison belongs in the Discussion section, not in the research question table.

---

## Gap 4 (HIGH): The "Must Ship" Fallback May Not Be Novel

The proposal's minimum viable deliverable is:

> *"Reformulation landscape map (dye prevalence by category/brand, from OFF + FDA tracker) + poster + presentation"*

But this data already exists in the public domain:

- **PlainFoodSafe** (plainfoodsafe.com) publishes a dye-by-dye product tracker using the same data source (Open Food Facts). Their tracker shows product counts per dye: Red 40 in 21,595 products, Yellow 5 in 18,987, Blue 1 in 16,643, etc. (PlainFoodSafe Dye Tracker, June 2026).
- **CSPI's Synthetic Dyes Corporate Commitment Tracker** (updated April 2026) categorizes the top US food manufacturers into four commitment tiers and adds critical analysis the FDA tracker lacks. CSPI explicitly notes the FDA tracker *"includes limited and vague commitments and omits companies that have made no commitment at all."*
- **FDA's own Industry Tracker** maps company-level pledges.

If the pricing analysis fails and the project reduces to "which products contain dyes by category," it's replicating what PlainFoodSafe already publishes. That's not a conference-worthy contribution.

### Fix

Strengthen the fallback by adding analytical value beyond what existing trackers provide:

1. **Pledge-vs-reality gap analysis.** Cross-reference FDA/CSPI company-level pledges with OFF product-level data. *Has General Mills actually removed dyes from its cereals by mid-2026, as pledged?* If OFF shows General Mills cereals still containing Red 40, that's a pledge-vs-reality gap. This is novel and would genuinely interest the MAHA/food policy community.

2. **"Dye complexity" scoring.** Products with 3+ synthetic dyes (e.g., Froot Loops with Red 40 + Yellow 6 + Blue 1) face higher reformulation costs and complexity than products with 1 dye. Map the distribution of dye complexity by category.

3. **State regulatory exposure.** Cross-reference products still containing dyes with the state ban landscape. California already banned Red No. 3 (AB 418). West Virginia banned all seven dyes in school meals (Phase 1, August 2025). Which products in the OFF database face multi-state regulatory exposure?

These three angles make the reformulation landscape study independently publishable.

---

## Gap 5 (MEDIUM): Company Reformulation Dates Are Partially Inaccurate

The proposal's "Industry Reformulation Status" table (based on "FDA Tracker, May 2026") contains dates that conflict with more current sources:

| Company | Proposal Says | PlainFoodSafe Tracker (June 2026) | CSPI Tracker (April 2026) |
|---------|-------------|-----------------------------------|--------------------------|
| General Mills | "cereals by summer 2026" | Target: **2027-06-30** | Check CSPI |
| Hershey | "2027 target" | Target: **2026-12-31** | Check CSPI |
| Kraft Heinz | "2027 target" | Target: **2026-12-31** | Check CSPI |
| Nestlé | "mid-2026" | Target: **2027-06-30** | Check CSPI |

The General Mills date is the most consequential: if General Mills cereals aren't reformulated until mid-2027 (not summer 2026), then **cereals may still provide within-brand matched pairs** in summer 2026. This is good for the study's feasibility but bad for the proposal's RQ2 classification of cereals as "high-reformulation."

### Fix

Before pre-camp prep, verify all dates against: (1) the FDA tracker (fda.gov, updated May 12, 2026), (2) PlainFoodSafe's dye tracker, and (3) CSPI's corporate commitment tracker. Use the most conservative (latest) dates. Add CSPI as a data source — it's more analytically rigorous than the FDA tracker.

---

## Gap 6 (MEDIUM): October 2027 "Mandatory (anticipated)" Overstates Legal Status

The proposal's regulatory timeline table labels October 2027 as "Mandatory (anticipated)." This is misleading. No formal rulemaking has established this date as mandatory. The evidence:

> *"The FDA's announcement does not include changes to underlying federal statutes, nor does it include the immediate revocation of all of the FDA's regulations authorizing the impacted color additives... There is also **no formal agreement between the FDA and the industry.**"* — Haynes Boone, April 2025

> *"As of March 2026, Red 40 remains a **lawfully authorized color additive.** The FDA has signaled that regulatory action will follow if voluntary compliance is insufficient, but no specific rulemaking timeline has been announced."* — PolicyCanary, March 2026

> *"The FDA's measures amount to a **voluntary 'understanding' between certain food companies and the FDA** — and it's clear that not everyone is on board."* — CSPI, April 2026

The proposal itself acknowledges this in Limitation #5 and the Theoretical Framework (§2). But the table format in the Regulatory Context section presents "Mandatory (anticipated)" as if it's quasi-official. In the Limitation section it says: "The FDA dye phase-out is guidance-based, not a legal mandate as of June 2026."

### Fix

Change the table label from "Mandatory (anticipated)" to "Voluntary target (no formal rulemaking)." Keep the "anticipated" framing in the theoretical discussion where context makes its meaning clear.

---

## Gap 7 (MEDIUM): Only Two Categories Limits RQ2's Interpretive Power

RQ2 compares premiums between two categories:
- Candy/confections (low reformulation)
- Cereals/baked goods (high reformulation)

With n=2 categories, any observed difference could be driven by **inherent category effects** (candy and cereal have fundamentally different price structures, brand landscapes, and consumer demographics) rather than reformulation rates. You need at least 3 categories to begin separating category-specific effects from reformulation-rate effects.

### Fix

Add a **third category: beverages.** Kraft Heinz (Kool-Aid, Crystal Light, Jell-O) targets end of 2026–2027. Coca-Cola has pledged by 2027. Sports drinks and flavored waters are moving faster. This gives:

| Category | Reformulation Rate | Key Brands Still With Dyes |
|----------|-------------------|---------------------------|
| Cereals/baked goods | Medium-high | WK Kellogg (end 2027), Post |
| Beverages | Medium | Kraft Heinz, Coca-Cola |
| Candy/confections | Low | Mars, Hershey, McKee Foods |

Three categories with three reformulation rates. Mann-Whitney between all three pairs, plus a Kruskal-Wallis test across all three. Stronger interpretation.

The pre-camp work increases modestly (~15-20 additional matched pairs from beverages), but the analytical payoff is substantial.

---

## Gap 8 (MEDIUM): Review Selection Protocol Unspecified

Phase 4 calls for students to read "10 Amazon or Walmart reviews per product (300–400 total reviews)." But which 10? A product like Cheetos has thousands of reviews. Selection bias could drive the results.

### Fix

Specify: **"10 most recent reviews as of the data collection date, excluding reviews shorter than 2 sentences."** Most-recent avoids selectivity bias; the 2-sentence minimum filters one-word ratings ("Great!" / "Terrible!") that provide no codeable content. Students should record the date range of reviewed reviews for each product.

---

## Gap 9 (MEDIUM): Price Collection Protocol Needs Standardization

Manual Walmart.com price lookup is the right approach (no scraping, no ToS issues). But prices on Walmart.com vary by:
- **Zip code** (shipping/delivery costs differ by location)
- **Date** (prices change weekly; Walmart uses dynamic/rollback pricing)
- **Promotional status** (current sale vs. regular price)
- **Walmart+ membership** (members may see different prices)

### Fix

Add a **Data Collection Protocol** subsection:

1. All prices collected from the same zip code (use 92093 — UCSD campus — for consistency)
2. All prices collected within a 3-day window during Week 1
3. Record the **regular shelf price** (not sale/rollback price). If a product is on sale, record both sale and regular price; use regular price for analysis.
4. Record date of collection for each product
5. Screenshot every 10th product as a spot-check audit trail
6. Two students independently look up prices for a 10% overlap subsample; report concordance rate

---

## Gap 10 (LOW): Competitive Dynamics Missing from Theoretical Framework

The proposal uses signaling theory (Spence 1973) to predict premium erosion: "the signal becomes less differentiating" as more firms adopt it. This is correct but incomplete. There's a second, distinct mechanism:

**Competitive price convergence.** When all competitors reformulate simultaneously (as in a coordinated industry transition), no individual firm can sustain a price premium because consumers can substitute to an equally dye-free competitor. The premium disappears not because consumers devalue the signal, but because **firms compete away the rents.**

This is standard industrial organization theory, not signaling theory. The Doritos NKD parity-pricing case illustrates it: PepsiCo prices dye-free Doritos the same as regular not because "no artificial colors" is a weak signal, but because if they charged more, consumers would buy competitor chips that are also dye-free and equally priced.

### Why It Matters for Interpretation

If the observed premium is zero, signaling theory would say "consumers don't value the signal anymore." But competitive dynamics would say "firms can't charge for it regardless of consumer valuation." These have different policy implications.

### Fix

Add a brief paragraph in the Theoretical Framework:

> *In addition to signal erosion on the demand side, simultaneous industry reformulation creates competitive convergence on the supply side. When multiple firms adopt the same attribute concurrently, no individual firm can sustain a premium because consumers can substitute to identically-positioned competitors (Tirole 1988). This predicts premium compression independent of changes in consumer valuation.*

---

## Gap 11 (LOW): Statistical Power Unaddressed

The proposal specifies ≥60 pairs for RQ1/RQ2 and ≥20 per group for RQ3. No power analysis justifies these numbers.

For a paired Wilcoxon test with 60 pairs and a 5% premium against ~15% within-pair standard deviation (a plausible estimate for matched food products), power is approximately 0.70–0.80 at α=0.05. This is adequate but tight.

For RQ3 with 20 per group using Mann-Whitney U, power drops to ~0.50 for a 3% effect — essentially a coin flip. This means **RQ3 is likely underpowered for the predicted effect size.**

### Fix

Acknowledge power limitations for RQ3 explicitly. Consider increasing the RQ3 target from 20 to 30 per group if feasible during pre-camp prep. Alternatively, state: *"RQ3 is exploratory. Failure to detect a significant claim premium with 20 pairs per group may reflect insufficient power rather than absence of effect."*

---

## Gap 12 (LOW): Open Food Facts Data Quality Beyond Coverage

The proposal addresses OFF's US coverage concern (Limitation #3) and requires pre-camp validation. Good. But there's a deeper data quality issue: **ingredient parsing accuracy.**

US food labels don't use E-numbers (E129 for Red 40, E102 for Yellow 5). They list "Red 40" or "FD&C Red No. 40" or "Allura Red AC." OFF's additive tagging depends on mapping these varied label representations to standardized E-numbers. The mapping quality is unknown and likely inconsistent across the crowdsourced database.

### Fix

During pre-camp validation, spot-check 30 products: manually verify that OFF's additive tags match the actual ingredient list. If discrepancy rate exceeds 10%, add manual ingredient-list review as a supplementary classification step.

---

## Summary of Gaps

| # | Gap | Severity | Fix Complexity |
|---|-----|----------|----------------|
| 1 | Parity-pricing evidence suggests zero premium possible; no framework for null result | **High** | Medium — add interpretive framework for null/near-zero findings |
| 2 | RQ3 "sharpest test" overclaims — endogeneity persists | **High** | Low — temper language, add confounders to data collection |
| 3 | Meta-analytic benchmarks compare wrong attribute type | **High** | Low — reframe RQ1b as discussion context, not formal test |
| 4 | "Must ship" fallback replicates existing public data | **High** | Medium — add pledge-vs-reality gap analysis |
| 5 | Company reformulation dates partially inaccurate | **Medium** | Low — verify against CSPI/PlainFoodSafe trackers |
| 6 | "Mandatory (anticipated)" overstates legal status | **Medium** | Low — change table label |
| 7 | Only 2 categories for RQ2 limits interpretation | **Medium** | Medium — add beverages as third category |
| 8 | Review selection protocol unspecified | **Medium** | Low — specify "10 most recent, ≥2 sentences" |
| 9 | Price collection needs standardization | **Medium** | Low — add protocol (zip, date, sale status) |
| 10 | Competitive dynamics missing from theory | **Low** | Low — add paragraph |
| 11 | Statistical power for RQ3 unaddressed | **Low** | Low — acknowledge; increase N if possible |
| 12 | OFF data quality: ingredient parsing accuracy | **Low** | Low — add spot-check to pre-camp validation |

---

## Additional Data Source: CSPI Corporate Commitment Tracker

The proposal should add CSPI's tracker as a data source. It is more comprehensive and analytically rigorous than the FDA tracker:

> *"CSPI's tracker examines the **top US food and beverage manufacturers by 2020 sales** and categorizes their responses to synthetic dyes into four groups — from commitments to remove dyes from all products to no plan — highlighting which companies are taking meaningful steps to eliminate synthetic dyes, **which have pledged in the past and failed to deliver on their promises**, and which have yet to promise action."* — CSPI, April 2026

Key finding from CSPI: the National Confectioners Association **refused to pledge** voluntary removal, stating its members will "follow regulatory guidance" (i.e., wait for a formal ban). This confirms candy as the right low-reformulation category for RQ2 and adds analytical nuance the FDA tracker doesn't provide.

**Source:** CSPI Synthetic Dyes Corporate Commitment Tracker, https://www.cspi.org/page/synthetic-dyes-corporate-commitment-tracker (last updated April 17, 2026).

---

## Proposed Revisions (Specific Text Changes)

### 1. Add to Project Overview (after the current research question)

> PepsiCo's Doritos Simply NKD — a dye-free reformulation launched December 2025 — retails at the same price as regular Doritos at Walmart (Food Institute, February 2026). This raises the possibility that the premium has already collapsed to zero in categories undergoing rapid reformulation, making the mid-2026 measurement window potentially our last chance to observe it.

### 2. Replace RQ1b row in the Research Questions table

> | **RQ1b** | How does the observed premium compare to published WTP estimates for broader health/sustainability claims (~30%)? | Observed premium substantially below 30%, consistent with dye-free being a narrower attribute and/or signal erosion. | *Note: The 30% baseline is for organic/sustainability claims broadly (Li & Kallas 2021; Alsubhi et al. 2023), not dye-free specifically. No published study isolates the dye-free premium. This comparison provides indicative context, not a formal benchmark test.* |

### 3. Temper RQ3 language

> **Current:** "RQ3 is the sharpest test in this proposal."  
> **Revised:** "RQ3 is the most theoretically interesting comparison in this proposal, though it carries important caveats (see Limitations)."

### 4. Add to RQ3 data collection requirements

> Record for each product: brand tier (premium/natural, mainstream, value/store brand), presence of other health claims (USDA Organic, Non-GMO Project Verified, "clean ingredients"), and package design cues (matte/kraft packaging vs. glossy/bright). Report whether the claim premium persists when restricting to same-brand-tier comparisons.

### 5. Add Limitation #6

> **6. Endogeneity in RQ3.** Brands that make "no artificial colors" claims are not randomly assigned. They tend to be premium-positioned brands with higher prices across their product lines. The RQ3 comparison controls for composition (both groups are dye-free) but not for brand positioning, other health claims, or marketing investment. Any observed claim premium may reflect brand equity rather than the signaling value of the specific claim. We mitigate this by recording brand tier and other claims, but cannot fully resolve the confound without within-brand comparisons (which are likely too rare to achieve adequate sample size).

### 6. Add interpretive framework for null results (new section after Expected Results)

> ### Interpreting Null or Near-Zero Premium Results
>
> If the observed premium is <5% or not statistically significant, four interpretations are possible:
>
> 1. **Transition completion.** The market has already priced in the expected baseline shift; dye-free no longer differentiates.
> 2. **Competitive convergence.** Simultaneous industry reformulation prevents any single firm from sustaining a premium — consumers substitute to equally dye-free competitors.
> 3. **Cost absorption.** Firms absorb higher natural-colorant costs rather than pass them through, to maintain market share during the transition.
> 4. **Attribute non-salience.** Dye-free status was never independently valued by consumers; historical "premiums" reflected organic/natural brand positioning, not dye absence per se.
>
> These interpretations can be partially distinguished:
> - If premium ≈ 0% uniformly across categories → interpretations #1 or #2
> - If premium ≈ 0% in high-reformulation categories but >0% in low-reformulation categories → interpretation #1 (transition-stage effect)
> - If premium ≈ 0% overall but RQ3 claim premium is positive → interpretation #4 (marketing signal, not compositional value)

### 7. Strengthen the "must ship" fallback

> **Must ship** | Reformulation landscape analysis: dye prevalence by category/brand (OFF) cross-referenced with company-level pledges (FDA tracker + CSPI tracker). **Key deliverable: pledge-vs-reality gap analysis** — do products from companies that have pledged reformulation by 2026 actually show dye removal in OFF ingredient lists? Includes dye-complexity scoring (number of distinct synthetic dyes per product) and state regulatory exposure mapping. + poster + presentation

### 8. Regulatory table fix

> Change "Mandatory (anticipated)" to "Voluntary target (no formal rulemaking as of June 2026)"

### 9. Add to Data Sources table

> | **CSPI Corporate Commitment Tracker** | Company-level commitment categorization (4 tiers); identifies companies that have pledged and failed before; more analytical than FDA tracker | Pre-camp: review for category classification. CSPI criticizes FDA tracker as "limited and vague." |

### 10. Add Data Collection Protocol (new subsection under Methodology)

> #### Price Collection Protocol
> - All prices from Walmart.com using zip code 92093 (UCSD campus)
> - All prices collected within a 3-day window during Week 1
> - Record regular shelf price (not sale/rollback); if on sale, record both and use regular for analysis
> - Record collection date per product
> - Screenshot every 10th product for audit trail
> - Two students independently collect prices for 10% overlap subsample; report concordance rate
>
> #### Review Selection Protocol
> - 10 most recent reviews per product as of data collection date
> - Exclude reviews shorter than 2 sentences
> - Record date range of sampled reviews per product

---

## Bottom Line

v3 is a genuinely strong proposal — better than most undergraduate research designs in this space. The remaining gaps don't threaten the project's viability; they threaten the **precision of interpretation.** The biggest risk is not that the study fails to execute, but that a null result (no premium found) gets interpreted as "uninteresting" when it's actually the most revealing finding possible during this specific market moment.

The fixes above total perhaps 2–3 hours of revision. The pre-camp preparation remains the critical path: verifying OFF coverage, confirming matched-pair availability, and checking company reformulation dates against CSPI/PlainFoodSafe/FDA trackers. If the mentor's 12–16 hours of pre-camp prep is actually allocated and competently executed, this project will ship.

**Confidence:** High that the project produces a publishable poster. Medium-high that it produces a conference-quality abstract. The reformulation landscape analysis with pledge-vs-reality gap analysis is the most reliably novel contribution regardless of pricing results.
