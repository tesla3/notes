# Critical Review: "What's Left of the Dye-Free Premium?" Proposal (v4)

**Date:** June 7, 2026
**Target:** `From_Lab_to_Market_proposal_v4.md`
**Prior reviews:** v2 review (10 gaps), v3 review (12 gaps)
**Verdict:** v4 is a substantially mature proposal. Every one of the 12 gaps identified in the v3 review has been addressed — most of them well. The v1→v2→v3→v4 evolution is remarkable: from a sprawling "boil the ocean" original (6 product categories, 5 research questions, Reddit sentiment analysis, predictive modeling) to a tightly scoped, methodologically honest design with appropriate statistics for high school students, tiered deliverables, and a genuinely novel fallback. It is ready to execute. But **five new gaps remain** — none identified in prior reviews — that could compromise the study's **external validity**, **internal validity of the must-ship deliverable**, and **execution feasibility**. Two are high-severity. All are fixable without major redesign.

---

## What v4 Got Right — and What the v3→v4 Arc Demonstrates

The changelog maps every v3 gap to a specific fix. Let me verify the most consequential ones:

| v3 Gap | Fix Quality | Assessment |
|--------|------------|------------|
| Gap 1 (parity pricing / null result framework) | **Excellent.** Doritos NKD evidence added to overview. Full "Interpreting Null Results" section with 4 distinguishable interpretations and specific data patterns. "Does not assume a positive premium" added to scope. | This was the v3's biggest weakness. It's now a strength — the null-result framework is more sophisticated than most published food-economics papers. |
| Gap 2 (RQ3 endogeneity) | **Good.** "Sharpest test" → "most theoretically interesting comparison." New Limitation #6 (endogeneity). Brand tier and bundled claims added to data collection. Sensitivity check specified. | Honest about what RQ3 can and can't do. The sensitivity check (restricting to same-brand-tier) is the right mitigation. |
| Gap 3 (meta-analytic benchmarks) | **Excellent.** RQ1b eliminated as formal research question. Meta-analytic context moved to Discussion. Annotations added to references 5 and 6 specifying what they actually measured. Explicit: "No published study has isolated WTP specifically for 'dye-free'." | This was a category error in v3 (comparing apples to fruit baskets). Now properly framed. |
| Gap 4 (must-ship fallback novelty) | **Excellent.** Pledge-vs-reality gap analysis, dye-complexity scoring, state regulatory exposure mapping added. "Independently publishable regardless of pricing analysis outcomes" — correct assessment. | The strongest improvement. The must-ship is now genuinely novel (see Gap 3 below for a remaining issue). |
| Gap 5 (company dates) | **Good.** Dates updated per CSPI/PlainFoodSafe. General Mills corrected from "summer 2026" to "mid-2027." | Consequential fix — means cereals still provide within-brand pairs. |
| Gap 6 (regulatory label) | **Fixed.** "Voluntary target — no formal rulemaking as of June 2026." | Clean. |
| Gap 7 (third category) | **Fixed.** Beverages added with ~25 pairs. Kruskal-Wallis + pairwise Mann-Whitney with Bonferroni. | Good design. Three reformulation tiers now properly mapped. |
| Gaps 8, 9, 10, 11, 12 | **All fixed.** Review selection protocol, price collection protocol, Tirole competitive convergence, power acknowledgment, OFF spot-check. | Solid execution across the board. |

The proposal is now at the level where the remaining gaps are about **external validity and execution risk** — not fundamental design flaws.

---

## Gap 1 (HIGH): Walmart-Only Pricing Creates Systematic Bias Toward Null Results

This is the most consequential gap in v4 and was not identified in any prior review.

The proposal collects ALL price data from Walmart.com. The justification is implicit: Walmart is the largest US grocer, prices are publicly visible, no scraping required. These are reasonable operational constraints for a high school program. But Walmart is not a neutral measurement instrument for this study — **Walmart is an active party to the very transition being studied, with an explicit strategic commitment to parity pricing.**

The evidence:

> *"Our customers have told us they want products made with simpler, more familiar ingredients... By eliminating synthetic dyes and other ingredients, we're reinforcing our promise to **deliver affordable food** that families can feel good about."* — John Furner, Walmart President/CEO, October 2025

> *"Walmart U.S. private brand foods like bettergoods, Freshness Guaranteed, Marketside and Great Value are available in Walmart stores and online... **as reformulated products roll out**"* — Walmart Corporate, October 2025

> *"customers can monitor package labels to see which products have been updated — and **expect consistent pricing**, according to Walmart's public statements."* — Florida Chamber of Commerce, October 2025

Walmart's entire brand identity is built on Everyday Low Price (EDLP) — a strategy where the retailer sets persistently low prices and absorbs cost increases rather than passing them through. This is documented extensively:

> *"Everyday Low Price (EDLP) is a pricing policy or strategy whereby a low price is initially set for an item and maintained, regardless of sales promotion activities."* — LitCommerce/Walmart Pricing Strategy analysis, 2025

The problem is structural. Walmart actively compresses price variation across its assortment. Products that might carry a 15% premium at Whole Foods, a 10% premium at Kroger, or a 7% premium at Target may show a 0-2% premium at Walmart — because Walmart's pricing algorithm and buyer negotiations specifically prevent large within-category price spreads for comparable products.

### Why This Isn't Just a Limitation — It's a Confound

The proposal's Doritos NKD parity-pricing evidence — the motivating observation for the entire null-result framework — comes FROM Walmart:

> *"The new versions are currently for sale in **Walmart stores** throughout the US and **priced at the same level** as the regular versions, or about $4."* — Daily Mail, February 2026

This is presented as evidence that "the premium may have already collapsed." But an alternative interpretation is simpler: **Walmart doesn't allow premiums.** The premium might exist at every other retailer. We can't tell.

This creates a scenario where:
- If the study finds no premium → it could be Walmart's EDLP strategy, not market-wide premium collapse
- If the study finds a premium → it's likely real (since it survived Walmart's price compression)
- **The finding is asymmetrically informative**: a positive premium at Walmart is strong evidence; a null premium at Walmart is ambiguous

### Why a Single Retailer Also Raises External Validity Concerns

Walmart's customer base skews lower-income and more price-sensitive than the national average. Health-claim premiums are well-documented to vary by retail channel (Griffith & Nesheim 2013 found organic milk premiums ranging from 0% at Asda — the UK equivalent of Walmart — to 30% at Waitrose, the premium retailer). Measuring the dye-free premium exclusively at Walmart is like measuring electric vehicle premiums exclusively at used-car lots.

### Fix

**Option A (best, if feasible):** Add Target.com as a second pricing source for a subsample of ≥20 matched pairs. Target's pricing strategy is different (uses Hi-Lo promotional pricing, positions as "affordable premium"), and Target has its own reformulation commitments. If the premium is 0% at Walmart and 8% at Target for the same products, that's a finding about retail channel effects — itself interesting and publishable.

**Option B (minimal):** Acknowledge this limitation explicitly and reframe findings as "premiums at Walmart" not "premiums in the US retail market." Add a sentence: *"Walmart's EDLP pricing strategy may compress premiums relative to other retail channels. Findings should be interpreted as Walmart-specific, not market-wide. A positive premium at Walmart would be strong evidence of real consumer WTP; a null premium may reflect Walmart's pricing strategy rather than absence of consumer valuation."*

**Option C (interpretive):** Use the asymmetric-informativeness framing in the Discussion: a positive finding at Walmart is a conservative lower bound on the true market premium. A null finding is inconclusive between "no premium exists" and "Walmart's pricing strategy suppresses the premium."

At minimum, Option B is required. The current proposal treats Walmart as if it were a transparent window on the market. It is not. It is a retailer with the most explicit anti-premium pricing strategy in American retail.

---

## Gap 2 (HIGH): Within-Brand vs. Cross-Brand Pairs Are Not Distinguished — But They Measure Different Things

The proposal requires ≥85 matched pairs with the instruction: *"same brand where possible; same subcategory, comparable size."* This is the right priority order, but the analysis treats all pairs identically regardless of match quality. This is a problem because within-brand and cross-brand pairs measure fundamentally different things.

### Within-Brand Pairs (e.g., Doritos vs. Doritos NKD)

- Same brand equity, same target market, same marketing investment
- Price difference reflects: reformulation cost pass-through + within-brand marketing signal
- **This is the clean comparison.** But these pairs are vanishing as companies complete reformulation. And for brands that have fully transitioned (reformulated AND discontinued the old version), no within-brand pair exists at all.

### Cross-Brand Pairs (e.g., M&M's vs. Unreal Dark Chocolate Gems)

- Different brand equity, different ingredient quality (Unreal uses organic ingredients beyond just dye removal), different target market (parents at Whole Foods vs. impulse buyers at checkout), different marketing budget
- Price difference reflects: dye status + brand tier + ingredient quality + marketing positioning + target demographic + retail placement
- **This comparison is deeply confounded.** A 40% price difference between M&M's and Unreal tells us almost nothing about the value of "dye-free."

### Why This Matters for the Analysis

If 80% of the 85 pairs are cross-brand, then the RQ1 "premium" estimate is dominated by brand-equity confounds and will systematically overestimate the dye-free premium. If 80% are within-brand, the estimate is cleaner but may be biased toward zero (within-brand pairs exist primarily for brands that maintain both versions simultaneously, which they do at parity pricing — see Doritos NKD).

The proposal records "brand tier" for RQ3 but does NOT record or report the type of match (within-brand vs. cross-brand) for RQ1/RQ2 pairs. This is a significant omission.

### Fix

1. **Record match type** for every pair: within-brand (same manufacturer, same product line, different formulation) vs. cross-brand (different manufacturer, same subcategory).
2. **Report results separately** for within-brand and cross-brand pairs. If within-brand premium ≈ 0% but cross-brand "premium" ≈ 15%, the interpretation is clear: the dye-free attribute per se carries no premium; the 15% reflects brand positioning.
3. **Pre-camp: estimate** the likely proportion of within-brand vs. cross-brand pairs. If <15 within-brand pairs exist across all 3 categories (plausible), acknowledge this and focus the premium interpretation on within-brand pairs, with cross-brand pairs reported as descriptive context only.
4. **Set a minimum:** require ≥15 within-brand pairs for the premium analysis to proceed. If <15 exist, the pricing analysis should be reported with the caveat that cross-brand comparisons are poorly identified.

This is not a radical redesign. It's adding one field to the data collection spreadsheet and one stratification to the analysis. But it fundamentally changes the interpretability of the results.

---

## Gap 3 (MEDIUM-HIGH): Open Food Facts Database Lag May Inflate the Pledge-vs-Reality Gap

The pledge-vs-reality gap analysis is the proposal's strongest component and its "must ship" deliverable. The analysis cross-references company-level pledges (from FDA/CSPI trackers) with product-level ingredient data (from Open Food Facts) to ask: *"Have companies that pledged reformulation by mid-2026 actually removed dyes from their products?"*

This is genuinely novel. No existing tracker does this cross-reference. But the analysis has a critical dependency: **OFF ingredient data must be current.** And OFF is crowdsourced — updated when a volunteer scans the new packaging and uploads the updated ingredient list.

### The Lag Problem

When a company reformulates a product (say, General Mills removes Red 40 from Trix in Q1 2026), the OFF database does NOT automatically update. Someone — a volunteer — must:
1. Purchase the reformulated product
2. Scan the barcode
3. Photograph the new ingredient list
4. Upload to OFF

This could take weeks, months, or never happen for low-visibility products. Meanwhile, OFF still shows the old ingredient list with Red 40.

This means the pledge-vs-reality gap analysis will systematically **overstate the gap** — making companies look like they haven't reformulated when they actually have. OFF's own documentation acknowledges this:

> *"Data in the Open Food Facts database is provided voluntarily by users who want to support the program. As a result, there are **no assurances that the data is accurate, complete, or reliable.**"* — Open Food Facts API documentation

A Hacker News commenter with food-industry experience flagged the fundamental issue with crowdsourced food data:

> *"The information... is pretty much useless (is open and known by anyone) when it gets interesting is when we analyze the formulations and effects of those."* — HN user, June 2022

### Why This Matters

If the analysis reports "General Mills pledged mid-2027 reformulation, but 85% of their cereals in OFF still contain Red 40" — is that because General Mills hasn't reformulated, or because no volunteer has scanned the new box yet? The proposal cannot distinguish these.

This risk is particularly acute for the "must ship" deliverable because:
- Companies reformulating in 2025-2026 may already have updated products on shelves
- But OFF may still show the old formulation
- The "gap" is partially an artifact of database staleness, not corporate non-compliance

### Fix

1. **Add a staleness check to pre-camp validation.** For the 30 products in the OFF spot-check (already planned), record the `last_modified_t` timestamp from OFF. Report the distribution: what % were last updated in 2026? In 2025? In 2024 or earlier? If >50% of relevant products haven't been updated since 2024, OFF staleness is a critical concern.

2. **Validate a subsample of "gaps" manually.** If the analysis finds that Company X pledged reformulation but OFF still shows dyes → verify 10 such products by checking the current ingredient list on Walmart.com or the manufacturer's website. Report the "confirmed gap" rate vs. the "OFF staleness" rate.

3. **Reframe the deliverable.** Don't call it "pledge-vs-reality gap analysis" without qualification. Call it: *"Pledge-vs-OFF-data gap analysis, with the caveat that gaps may reflect database lag rather than actual non-compliance. A subsample of N products was manually verified."*

4. **Consider USDA FoodData Central as a supplementary source.** USDA's Branded Food Products Database is more systematically maintained than OFF for US products. It may have more current ingredient data for major brands.

This fix adds ~3 hours of manual verification to the pre-camp prep and ~2 hours during camp for student verification. It's essential for the must-ship deliverable's credibility.

---

## Gap 4 (MEDIUM): Geographic Selection Bias — California Is a Regulatory Outlier

All prices are collected from Walmart.com using zip code 92093 (UCSD campus, La Jolla, San Diego, California). This is a natural choice for an OPALS project. But California is not a neutral location for studying food dye premiums:

- **California enacted AB 418 in October 2023** — the first US state to ban Red No. 3 (effective January 1, 2025, later superseded by the federal revocation). California consumers have had ~2.5 years of heightened awareness about food dyes.
- **California's consumer base is among the most health-conscious in the US.** Organic food sales per capita are significantly higher in California than the national average.
- **California's competitive retail landscape** includes a higher density of natural/organic retailers (Whole Foods, Trader Joe's, Sprouts) than most US markets. This competition may drive different pricing behavior even at Walmart.
- **State-level price variation exists on Walmart.com.** Walmart.com prices can vary by zip code due to local market conditions, distribution costs, and competitive dynamics.

### Why This Matters

If the study finds a 0% dye-free premium in La Jolla, California, the interpretation might be: "California consumers are so far ahead of the transition that the premium has already collapsed here, while it might persist in markets with less regulatory exposure." Conversely, if a premium exists in California (where awareness is highest), it would be an even stronger finding — suggesting robust consumer valuation.

The direction of the bias is uncertain, but its existence is not. California is the MOST regulated US state for food dyes and among the most health-conscious consumer markets. Findings may not generalize.

### Fix

**Option A (minimal, recommended):** Add this as Limitation #8: *"All prices were collected from Walmart.com using a California zip code. California enacted AB 418 banning Red No. 3 in 2023 — the first US state to restrict food dyes — and has a more health-conscious consumer base than the national average. Premium estimates may not generalize to less-regulated states."*

**Option B (better, if feasible):** Collect prices for a subsample of 20 pairs using a second zip code in a state with no food dye legislation (e.g., 77001 — Houston, TX; or 43215 — Columbus, OH). Report whether premiums differ by geography. This is a 2-hour addition during Week 1 and would substantially strengthen external validity.

---

## Gap 5 (MEDIUM): Pre-Camp Prep Estimate (14–18 Hours) Is Likely 1.5–2x Too Low

The proposal specifies 6 pre-camp tasks for the mentor. Let me estimate realistic time requirements:

| Task | Proposal Implies | Realistic Estimate | Why |
|------|-----------------|--------------------|-----|
| OFF download + filter to US + additive coverage | ~2 hrs | 2-3 hrs | Straightforward if mentor has Python/data skills. Add 1 hr if not. |
| Spot-check 30 products (OFF vs actual ingredient list) | ~2 hrs | 3-4 hrs | Each product: find on Walmart.com → read ingredient list → compare to OFF additive tags → record discrepancy. At 6-8 min/product → 3-4 hrs. |
| Coverage cross-reference with PlainFoodSafe | ~1 hr | 1-2 hrs | Depends on PlainFoodSafe's data accessibility. |
| Identify ≥85 matched pairs across 3 categories with matching rationale | ~6 hrs | 10-15 hrs | This is the bottleneck. For each pair: find a dyed product → find a comparable dye-free product → verify both are on Walmart.com → check sizes are comparable → document rationale. At 8-12 min/pair for 85 pairs → 11-17 hrs. Many candidates will fail (product not on Walmart.com, sizes not comparable, product recently reformulated). |
| Identify ≥60 RQ3 products with claims and brand tier data | ~2 hrs | 3-5 hrs | 60 products × 3-5 min each (check front-of-pack on Walmart.com, record claims, classify brand tier). |
| Feasibility gate assessment | ~1 hr | 1 hr | Quick if above is done. |

**Realistic total: 20-30 hours**, not 14-18.

### Why This Matters

The mentor's pre-camp prep is the **critical path for the entire project.** If it's not done thoroughly, students arrive on Day 1 with:
- No validated matched pairs → Week 1 days 3-5 (price collection) have nothing to collect
- No RQ3 product list → RQ3 analysis can't proceed
- No OFF quality assessment → reformulation landscape may be unreliable

The go/no-go gate at end of Week 1 is well-designed, but if pre-camp prep fails, Week 1 is consumed by prep work that leaves no time for price collection, and the go/no-go gate becomes moot.

### Fix

1. **Revise estimate to 25-30 hours.** Be honest about the time commitment so the mentor plans accordingly.
2. **Prioritize pre-camp tasks.** If time is constrained, the priority order should be:
   - (1) Matched-pair identification (essential for pricing analysis)
   - (2) OFF spot-check (essential for must-ship deliverable credibility)
   - (3) RQ3 products (can be partially done during Week 1 if necessary)
   - (4) OFF coverage assessment (can be done quickly)
3. **Create a template spreadsheet** with pre-defined columns and 10 example rows pre-filled. This reduces Week 1 cognitive load and ensures data consistency. The mentor should build this during pre-camp prep.
4. **Add a "pre-camp progress check"** at 50% completion (around 2 weeks before camp). If <40 matched pairs identified by this point, trigger the feasibility gate early and consider pivoting to the reformulation-landscape-only study.

---

## Additional Observations (Not Gaps, But Worth Noting)

### A. Unit Price Normalization Is Under-Specified

The proposal records "unit price (per oz or per serving)" but doesn't specify which. This matters:
- **Per serving** depends on manufacturer-defined serving size, which varies across brands (a serving of Doritos is 28g; a serving of a premium brand might be 30g or 40g)
- **Per ounce** is more standardized but doesn't account for product form (liquid vs solid) or density
- **Package size effect:** Small packages have higher unit prices (quantity discount). If dye-free versions tend to come in smaller packages (premium brands often do), per-oz price will appear higher even without a real premium

**Fix:** Standardize on **per ounce** for solids and **per fluid ounce** for liquids. Record package size (total oz) separately. In analysis, check whether package-size differences between pairs systematically bias the premium estimate. If they do, restrict analysis to pairs with comparable sizes (within ±20% of each other).

### B. Week 1 Cognitive Load for High School Students Is Front-Loaded

Days 1-2 require students to learn:
- OFF database structure and how to read it
- FD&C color additive naming conventions vs E-numbers vs common names
- The February 2026 FDA labeling change and what it means
- The A/B/C product classification system
- How to read and parse ingredient lists

Days 3-5 require students to:
- Look up prices for 85+ product pairs on Walmart.com
- Record 10+ fields per product (name, brand, category, dye status, dye count, claims, brand tier, price, size, unit price)
- Follow the inter-collector reliability protocol for overlap subsamples

This is a lot. The OPALS "demo-do-debrief" cycle (Wang et al. 2025) is well-suited to this, but the proposal doesn't specify what the "demo" looks like. In lab-based tracks (DNA damage, calcium signaling), the demo is a physical procedure. Here it's data literacy — a different modality.

**Suggestion (not a fix — a teaching design recommendation):** Build a 45-minute "ingredient detective" exercise for Day 1 where students classify 10 familiar products (Froot Loops, Goldfish, Gatorade, etc.) into Groups A/B/C using actual ingredient lists from Walmart.com. This makes the classification concrete before scaling to the full dataset. Follow with a 30-minute "price pair" exercise where students look up and compare 3 pre-selected pairs, record all fields, and discuss discrepancies. This is the "demo" before the "do" (full dataset collection on Days 3-5).

### C. The Theoretical Framework Is Solid but Slightly Over-Determined

The proposal now has THREE theoretical mechanisms predicting premium erosion: (1) signaling theory → signal becomes non-differentiating, (2) anticipated-mandate expectations → consumers expect universal adoption, (3) competitive convergence → firms can't sustain premiums when competitors match. All three predict the same outcome (premium compression toward zero), which makes the theoretical framework somewhat unfalsifiable — any outcome can be explained by emphasizing one mechanism over another.

This isn't a flaw per se (multiple mechanisms can operate simultaneously), but the proposal should be explicit that the three mechanisms are **complementary, not competing** — and that the data patterns in the null-result framework can partially distinguish them (which it does in the excellent "Interpreting Null Results" table).

### D. The OPALS Bridge Is Well-Executed

The chain **Lab Finding → Regulatory Action → Industry Reformulation → Consumer Market Response** is clean and concrete. The IEM News quote ("Students did research across 19 tracks, from DNA damage and **artificial food dye toxicity** to lithium-ion battery systems") directly connects to this project. This is one of the strongest OPALS bridge justifications I've seen — it doesn't feel forced.

---

## Summary of Gaps

| # | Gap | Severity | Prior Review? | Fix Complexity |
|---|-----|----------|--------------|----------------|
| 1 | Walmart-only pricing creates systematic bias toward null results (EDLP strategy, Walmart is a party to the transition) | **High** | Not identified in any prior review | Low (Option B: add limitation + reframe) to Medium (Option A: add second retailer) |
| 2 | Within-brand vs. cross-brand pairs not distinguished — measure different things | **High** | Not identified in any prior review | Low — add one field to data collection, stratify analysis |
| 3 | OFF database lag may inflate pledge-vs-reality gap in must-ship deliverable | **Medium-High** | Not identified in any prior review | Medium — add staleness check + manual verification of gap subsample |
| 4 | Geographic selection bias: California is a regulatory outlier for food dyes | **Medium** | Not identified in any prior review | Low — add limitation statement; medium if second zip code added |
| 5 | Pre-camp prep time estimate (14-18 hrs) is ~1.5-2x too low | **Medium** | Mentioned in v3 review but not the specifics | Low — revise estimate, add progress check |

---

## Proposed Specific Text Changes

### 1. Add to Data Sources section (after Walmart.com row)

> **Note on retailer selection:** Walmart.com is used for price consistency and public accessibility. However, Walmart's Everyday Low Price (EDLP) strategy and its own commitment to dye-free reformulation at parity pricing (Walmart Corporate, October 2025) may compress premiums relative to other retail channels. Findings should be interpreted as Walmart-specific. A positive premium at Walmart is a conservative lower bound on the market premium; a null premium at Walmart does not rule out premiums at other retailers.

### 2. Add to Week 1 data collection fields

> - **Match type:** Within-brand (same manufacturer, same product line, different formulation) or cross-brand (different manufacturer, same subcategory)

### 3. Add to Week 2 statistical analysis (after RQ1 primary analysis)

> **Stratified analysis by match type:** Report premium estimates separately for within-brand and cross-brand pairs. If within-brand premium ≈ 0% but cross-brand "premium" is significantly positive, interpret the latter as reflecting brand positioning rather than dye-free attribute value.

### 4. Add to Pre-Camp Preparation, item 1

> Record the `last_modified_t` timestamp (or equivalent last-update date) for each product in the OFF spot-check. Report the distribution of last-update dates. If >50% of dye-tagged products were last updated before 2025, OFF staleness is a material concern for the pledge-vs-reality gap analysis.

### 5. Add to Week 3, Phase 3 (Pledge-vs-reality gap analysis)

> **Staleness validation:** For any product where the gap analysis identifies a "pledge but still shows dyes in OFF" result, students manually verify a subsample of ≥10 such products by checking the current ingredient list on Walmart.com or the manufacturer's website. Report the proportion of confirmed gaps (product actually still contains dyes) vs. database lag (product has been reformulated but OFF hasn't been updated).

### 6. Add Limitation #8

> **8. Single-retailer and single-geography design.** All prices were collected from Walmart.com using a California zip code (92093). Walmart's EDLP strategy actively compresses within-category price variation and may suppress premiums relative to other retail channels. California enacted AB 418 banning Red No. 3 in 2023 — the first US state to restrict food dyes — and has a more health-conscious consumer base than the national average. Premium estimates may not generalize to other retailers or less-regulated states. Griffith & Nesheim (2013) found organic premiums ranging from 0% at discount retailers to 30% at premium retailers for the same product category — suggesting retailer choice is not a neutral measurement decision.

### 7. Revise Pre-Camp Preparation time estimate

> **Pre-Camp Preparation (Mentor, 25–30 hours)**

### 8. Add to Pre-Camp Preparation

> **Progress check (2 weeks before camp):** If <40 matched pairs identified by this point, trigger feasibility gate early. If <25 matched pairs: plan to execute reformulation-landscape-only study (must-ship deliverable).

### 9. Add to Week 1, Day 3-5 data collection fields

> Record **package size (total oz)** for all products. Standardize unit price as **price per ounce** for solids and **price per fluid ounce** for liquids. In analysis, verify that package-size differences between pairs do not systematically bias premium estimates; if they do, restrict analysis to pairs within ±20% size of each other.

---

## Bottom Line

v4 is a strong, honest, well-designed proposal. The v1→v4 evolution — from a sprawling, methodologically naive original to a tightly scoped study with proper statistics, tiered deliverables, a genuinely novel fallback, and an unusually sophisticated null-result framework — is the kind of iterative improvement that actual research undergoes. The proposal is publishable as a poster and likely as a conference abstract.

The remaining gaps are about **measurement context** (Walmart's EDLP confound, California's regulatory environment), **analytical precision** (within-brand vs. cross-brand pair stratification), **data source credibility** (OFF staleness), and **execution planning** (pre-camp time estimate). None are fatal. All are addressable with the proposed fixes.

The most important fix is **Gap 2** (recording match type and stratifying the analysis). It's 10 minutes of data-collection-design change and 30 minutes of additional analysis, but it transforms the interpretability of RQ1.

The second most important is **Gap 1** (acknowledging Walmart-specific findings). At minimum, Option B (limitation statement + reframing) costs nothing and prevents over-generalization.

**Confidence:** High that the project produces a publishable poster. High that the reformulation landscape with pledge-vs-reality gap analysis (with staleness validation) is a genuine contribution. Medium-high that the pricing analysis yields interpretable results — conditional on having ≥15 within-brand pairs.
