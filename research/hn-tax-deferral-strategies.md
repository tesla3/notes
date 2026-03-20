← [Index](../README.md)

# Tax Deferral & Reduction Strategies from HN Thread #47442699

**Source:** [How to defer US taxes](https://news.ycombinator.com/item?id=47442699) — taylor.town article + 104 HN comments
**Date:** 2026-03-19
**Scope:** US-focused. Every strategy below is sourced from the article or a specific HN commenter. Cross-validated against authoritative sources (IRS publications, IRC sections, Yale Budget Lab, CPA references). Corrections noted where the thread was imprecise or wrong.

---

## 1. Reinvest Taxable Income as Business Expenses

Defer taxes by reinvesting surplus revenue into legitimate business expenses rather than taking profit.

> "Defer US taxes by reinvesting your taxable income into the economy as business expenses, depreciating assets, etc." — **Article** (taylor.town)

> "From the point of view of a company, as the tax year comes to an end you hopefully have extra money left in the bank, now you can either use it to buy things that the company needs and thus grow the company, or you can hold onto it where if you're a C-corp the government will take 21% of the year-on-year delta" — **crdrost**

**✅ Validated.** IRC §162 allows deductions for "ordinary and necessary" expenses of carrying on a trade or business. This is the foundational provision for business expense deductions. ([IRS Taxpayer Advocate, Trade or Business Expenses Under IRC §162](https://www.taxpayeradvocate.irs.gov/wp-content/uploads/2020/08/ARC19_Volume1_MLI_01_TradeorBusinessExpenses.pdf))

**⚠️ Caveats — all confirmed:**

- **Hobby rule (IRC §183):** If your business doesn't show profit in 3 of 5 years (2 of 7 for horse activities), the IRS can presume "not for profit" status, limiting deductions to hobby income only. The safe harbor shifts the burden of proof to the IRS; without it, the taxpayer bears the burden. ([The Tax Adviser, "Avoiding the Hobby Loss Trap After the TCJA"](https://www.thetaxadviser.com/issues/2018/nov/avoiding-hobby-loss-trap-after-tcja/); [Wikipedia, IRC §183](https://en.wikipedia.org/wiki/Internal_Revenue_Code_section_183); IRS Audit Guide IRC §183)
  - **Correction to thread:** **kg** said "risk of being audited apparently goes up" after a few years without profit. More precisely: the IRS tests the 3-of-5-year safe harbor. An IRS revenue agent on Reddit confirmed they "usually wait for 5 years of tax returns to seriously consider examining it." The 9-factor test under Reg. §1.183-2 is subjective and evaluated case by case.
  - **TCJA note:** For tax years 2018–2025, hobby expenses were completely non-deductible due to TCJA's suspension of miscellaneous itemized deductions under §67(g). Starting 2026, limited hobby deductions may return if TCJA provisions expire.

- **Capital expenditures aren't immediately deductible** — they must be capitalized and depreciated. **SilasX** is correct. (IRC §263, §167, §168)

- **Can't reclassify all expenses.** **fogzen** and **jeffreyrogers** are correct. Expenses must be "ordinary and necessary" under §162, and capital expenditures must be capitalized, not expensed. The IRS distinguishes between current expenses and capital investments.

- **Must pay yourself a salary (S-Corp owners).** **anon291** said "if you provide labor to the business, you have to pay yourself a salary." **Partially correct, but imprecise.** This requirement applies specifically to **S-Corporation officer-shareholders**, not all business owners. The IRS requires S-Corp officers performing services to receive "reasonable compensation" as W-2 wages subject to employment taxes. ([IRS Fact Sheet 2008-25, Wage Compensation for S Corporation Officers](https://www.irs.gov/pub/irs-news/fs-08-25.pdf); IRC §1366, §3121). Sole proprietors report net self-employment income on Schedule SE instead; they don't technically "pay themselves a salary." **bluGill's** follow-up about "making minimum wage" to minimize salary is the exact pattern the IRS scrutinizes — courts have consistently ruled against unreasonably low S-Corp officer compensation.

---

## 2. Depreciation (Including Accelerated Depreciation)

Spread or front-load business expenses over time to minimize taxable income each year.

> "Good accountants will massage depreciation schedules to match unexpected profits/losses." — **Article**

### 2a. Standard Depreciation Scheduling

**⚠️ Correction:** The article's claim that you can freely choose *when* to recognize depreciation is **misleading**. Under IRC §168 (MACRS), depreciation schedules are determined by asset class and recovery period. You don't get to arbitrarily move depreciation between years. What you *can* choose:

- **§179 expensing:** Elect to immediately expense qualifying assets up to an annual limit ($1,250,000 for 2025, indexed for inflation) instead of depreciating them over time. (IRC §179)
- **Bonus depreciation (§168(k)):** 100% first-year depreciation was available 2017–2022; it phases down 20% per year through 2026 (40% for 2025, 20% for 2026, 0% for 2027+) unless Congress extends it.
- **Depreciation method choice:** Straight-line vs. declining balance, but once elected, you can't freely switch year to year.

The article's lawnmower example suggesting you can shift $100 of depreciation entirely into Year 1 or spread it as $0/$11/$11... is only correct if you're using §179 expensing for the front-loaded version. The "massage depreciation schedules" framing oversimplifies what are actually constrained elections made at the time assets are placed in service.

### 2b. Cost Segregation Studies

Reclassify components of a building into shorter depreciation categories to accelerate deductions.

> "Instead of depreciating a building over 27.5 or 39 years, a cost segregation study could reclassify components (carpeting, fixtures, landscaping, certain electrical) into 5, 7, or 15-year assets. A $2M property could accrue $200K–$300K in depreciation deductions its first year." — **Article**

**✅ Validated.** Cost segregation reclassifies building components from §1250 property (27.5/39-year straight-line) to §1245 property (5, 7, or 15-year accelerated). The $200K–$300K first-year figure on a $2M property is within industry norms. ([KBKG, Understanding Depreciation Recapture](https://www.kbkg.com/cost-segregation/understanding-depreciation-recapture-what-real-estate-owners-need-to-know))

**⚠️ Caveat — Depreciation Recapture (confirmed and clarified):**

- **§1245 recapture** (personal property, cost-seg'd components): ALL depreciation taken is recaptured as **ordinary income** (up to your marginal rate, potentially 37%) upon sale. ([SuperFastCPA, Section 1245 and 1250 Recapture](https://www.superfastcpa.com/tcp-cpa-exam-calculate-section-1245-and-1250-depreciation-recapture/))
- **§1250 recapture / Unrecaptured §1250 gain** (buildings): Depreciation on real property is taxed at a **maximum 25% rate** ("unrecaptured §1250 gain"), not ordinary income rates, because straight-line depreciation is used (no "excess" depreciation to recapture at ordinary rates).
- **PopAlongKid's correction** in the thread was accurate: standard real property IS depreciated over 27.5 or 39 years straight-line; "rapid depreciation" of real estate requires cost segregation to reclassify components.
- **jeffreyrogers** was correct that cost seg + sale = unexpected tax bills. KBKG's worked example: cost seg on a $2M property that later sells for $3M results in $425K total tax vs. $275K without cost seg — you got bigger deductions earlier but owe more recapture tax at sale.

---

## 3. Rental Property Depreciation (Special Case)

> "For *rental properties* you can go for decades with no profits (because of depreciation)." — **bombcar**

**✅ Validated, but with important nuance.** Rental activities are indeed exempt from the IRC §183 hobby loss rule — they're governed instead by the **passive activity loss rules under IRC §469**. However, the ability to *use* those paper losses varies significantly:

- **Default rule:** Rental losses are **passive losses** and can only offset **passive income** — NOT wages or active business income. (IRC §469(c)(2))
- **$25,000 exception:** Active participants with MAGI under $100,000 can deduct up to $25,000 of rental losses against non-passive income. Phases out between $100K–$150K MAGI. (IRC §469(i))
- **Real Estate Professional Status (REPS):** If you spend >750 hours/year AND >50% of your personal services in real property trades/businesses, rental losses become non-passive and fully deductible against any income. (IRC §469(c)(7)) ([The Tax Adviser, "Navigating the Real Estate Professional Rules"](https://www.thetaxadviser.com/issues/2017/mar/navigating-real-estate-professional-rules/); [The Real Estate CPA, Guide to REPS](https://www.therealestatecpa.com/guide-to-qualifying-as-a-real-estate-professional/))

**Correction to thread:** **bombcar** implied rental property losses are freely usable "for decades." In reality, for most people (W-2 earners with >$150K income), rental paper losses are **suspended** — they pile up and are only deductible when you sell the property or generate passive income. The losses don't vanish, but they don't reduce your current tax bill either unless you qualify for the exceptions above.

---

## 4. Borrow Against Appreciated Assets (Loans Are Not Taxable Income)

> "Loaned money isn't taxable income, so you can save/spend it without affecting your tax rate." — **Article**

**✅ Validated.** Loan proceeds are not taxable income under longstanding federal tax principles because borrowing creates an offsetting liability — there's no accession to wealth. This is a well-established principle confirmed by the Yale Budget Lab: "Loan proceeds are traditionally nontaxable, as they represent a temporary transfer of cash that will be repaid, not income per se." ([Yale Budget Lab, "Buy-Borrow-Die: Options for Reforming the Tax Treatment of Borrowing Against Appreciated Assets"](https://budgetlab.yale.edu/research/buy-borrow-die-options-reforming-tax-treatment-borrowing-against-appreciated-assets))

Specific loan types mentioned in the thread:

- **Margin loans / securities-based lending (SBLOCs):** **anon291** correctly notes margin loans typically require only interest payments. Lenders typically advance 50–70% of portfolio value. ✅
- **Home equity loans:** **twoodfin** correctly notes homes get step-up basis on inheritance and home equity loans are common. ✅
- **Borrowing against 401(k):** **twoodfin** mentioned this. **✅ But limited:** 401(k) loans are capped at the lesser of $50,000 or 50% of vested balance. Must be repaid within 5 years (longer for home purchase). If you leave your job, the loan may become due immediately. Not the same as borrowing against a brokerage account. (IRC §72(p))
- **Interest-only loans with balloon payments:** **jeffreyrogers** correctly describes a common commercial lending structure. ✅

---

## 5. Refinancing to Extract Cash Tax-Free

> "For your leveraged investments, pay yourself in refinanced cash when your investments appreciate and/or credit rates drop." — **Article**

**✅ Validated.** Cash-out refinancing replaces an existing loan with a larger one; the difference is loan proceeds, not income. This is standard practice in real estate and is confirmed by multiple tax authorities. The Instead.com article on buy-borrow-die notes: "Rather than selling a rental property and facing recapture taxes and capital gains, a property owner can refinance to extract equity tax-free." ([Instead.com, Buy Borrow Die Strategy Explained for 2026](https://www.instead.com/resources/blog/buy-borrow-die-strategy-explained-for-2026))

**No corrections needed.** Thread comments were accurate.

---

## 6. Buy, Borrow, Die (The Complete Strategy)

> "They *are* kicking the can down the road, but the magic happens at the die step." — **claythearc**

**✅ Validated as a well-documented, legal tax planning strategy.** Confirmed by Yale Budget Lab, multiple CPA firms, and tax law scholarship.

Mechanics (all confirmed):
1. **Buy** appreciating assets — not a taxable event ✅
2. **Hold** — unrealized appreciation is not taxed (realization doctrine) ✅
3. **Borrow** against them — loan proceeds not income ✅ (see §4 above)
4. **Roll debt** — "You repay with another loan. Repeat." (**nout**) ✅
5. **Die** — cost basis steps up under **IRC §1014**, erasing all unrealized capital gains ✅

**Key authoritative source:** Yale Budget Lab estimates "the current-law tax rate on borrowing is about 12 percentage points lower than the tax rate on selling" and that reforms to close this could raise $102B–$147B over ten years. They note that while buy-borrow-die is well-documented, "borrowing (of any kind) represents only 1% of the income of the top 0.1% by net worth" per Liscow and Fox (2025). ([Yale Budget Lab](https://budgetlab.yale.edu/research/buy-borrow-die-options-reforming-tax-treatment-borrowing-against-appreciated-assets))

**Caveats — all confirmed:**

- **Estate taxes still apply.** For 2025, the federal estate tax exemption is $13.99M per person ($27.98M married). Amounts above this are taxed up to 40%. **trollbridge** is correct that this matters at "multimillion levels." ✅
- **Market downturns force liquidation.** **claythearc's** point about margin calls is accurate — if collateral value drops, lenders can force asset sales at the worst time (triggering capital gains). ✅
- **Best terms require ultra-wealth.** **dminor** is correct. Bespoke lending terms (lower rates, flexible repayment) require substantial portfolios. Standard securities-based lending programs typically require a minimum of $100K–$250K. ([Instead.com](https://www.instead.com/resources/blog/buy-borrow-die-strategy-explained-for-2026))

**Correction:** **claythearc** said heirs "inherit your stocks, with their cost basis reset to the current price. They can then sell the shares, to pay the loans." **jeffreyrogers** correctly corrected: the step-up happens at death, the *estate* pays off creditors first, then distributes to heirs. The net result is the same, but technically the estate (not heirs directly) is the entity selling and paying debts.

---

## 7. Step-Up in Basis at Death (IRC §1014)

> "Death is a popular escape from deferred taxes." — **Article**

**✅ Validated.** IRC §1014(a) provides: "the basis of property in the hands of a person acquiring the property from a decedent... shall... be the fair market value of the property at the date of the decedent's death." This applies to stocks, real estate, business interests, collectibles, and most other capital assets. ([District Capital Management, "Stepped-Up Basis Loophole"](https://districtcapitalmanagement.com/stepped-up-basis/); [415 Group, "Understanding the Step-Up in Basis"](https://www.415group.com/blog/understanding-the-step-up-in-basis-when-inheriting-assets))

**toast0's worked example — verified with corrections:**

toast0 calculated 100K shares AMZN at $4.47 → sold at ~$213–$214 in March 2026. The math checks out directionally: ~$20.9M in capital gains. toast0 assumed a uniform 20% cap gains rate — the actual rate would be 23.8% (20% + 3.8% NIIT) for income above $250K, making the tax difference even larger than stated. The example correctly demonstrates the core point.

**⚠️ Important exceptions to step-up (validated):**

- **Traditional IRA/401(k):** Do NOT receive step-up basis. These are "Income in Respect of a Decedent" (IRD) under IRC §691 — taxed as ordinary income when withdrawn by heirs. **PopAlongKid** was correct. Under the SECURE Act (2019), most non-spouse beneficiaries must empty inherited IRAs within 10 years. ([LegalClarity, "Do Inherited IRAs Get a Step Up in Basis?"](https://legalclarity.org/do-inherited-iras-get-a-step-up-in-basis/); [Hurwitz Fine, SECURE Act](https://www.hurwitzfine.com/blog/secure-act-limits-stretch-ira-estate-planning-opportunities))
- **Gifts made during life:** Retain carryover basis (donor's original basis), NOT step-up. (IRC §1015)
- **Assets in irrevocable trusts** not included in the taxable estate: typically do NOT qualify.
- **Community property states:** Surviving spouse may get a full step-up on both halves of jointly held community property (not just the decedent's half).

---

## 8. Tax-Deferred Retirement Accounts (401(k), IRA)

> "If you are not rich, just put it in the 401k (or eq)." — **yonixw**

**✅ Validated.** Traditional 401(k) and IRA contributions reduce current taxable income. Taxes are deferred until withdrawal. For 2025: 401(k) contribution limit is $23,500 ($31,000 if age 50+); Traditional IRA limit is $7,000 ($8,000 if age 50+). This is standard tax deferral, not avoidance.

**Important nuance not in the thread:** Roth 401(k)/IRA contributions are made with after-tax dollars but grow and are withdrawn **completely tax-free** (including gains). This is a permanent tax reduction, not just deferral, particularly valuable if you expect higher tax rates in the future.

---

## 9. Income Timing (Lumpy Income Strategy)

> "Sometimes it also makes sense if your income is lumpy and you e.g. expect to have years where your income will fall into a lower tax band." — **vidarh**

**✅ Validated.** Progressive tax brackets mean the marginal rate on additional income varies. Shifting income recognition between years (where legally possible) to fill lower brackets is a standard tax planning technique. Common mechanisms: timing of invoice/payment for cash-basis businesses, choosing when to exercise stock options, timing Roth conversions in low-income years, accelerating or deferring deductions.

**No correction needed.** Thread comment was accurate, if brief.

---

## 10. Home Sale Exclusion ($250K/$500K)

> "If you live in the house for 2 years and then sell it, you can exclude $250K-$500K in gains." — **singron**

**✅ Validated.** IRC §121 (Taxpayer Relief Act of 1997) allows exclusion of up to $250,000 ($500,000 married filing jointly) of capital gains on sale of a principal residence. Requirements: owned AND used as principal residence for at least 2 of the 5 years before sale. Can be used every 2 years. ([Nolo, "The $250,000/$500,000 Capital Gains Tax Exclusion for Homeowners"](https://www.nolo.com/legal-encyclopedia/the-250000500000-home-sale-tax-exclusion.html); [CBIZ, "Why the $250,000/$500,000 Home Sale Exclusion Threatens Your Gains"](https://www.cbiz.com/insights/article/why-the-250000-500000-home-sale-exclusion-threatens-your-gains); IRS Publication 523)

**Minor addition:** singron also correctly noted this "has nothing to do with inheritance" — the §121 exclusion is independent of the step-up in basis.

**Nuance not in thread:** If the home was previously used as a rental (after 2008), the exclusion is reduced proportionally for "nonqualifying use" periods. Also, any depreciation claimed on the property after May 6, 1997 is NOT excluded and must be recaptured.

---

## 11. Tax-Exempt Charitable Donations

> "You can make tax-exempt donations, or start your own non-profit organization." — **surprisetalk**

**✅ Validated.** IRC §170 allows deductions for charitable contributions to qualified 501(c)(3) organizations, subject to AGI limits:

- **Cash to public charities:** Up to 60% of AGI (made permanent by the One Big Beautiful Bill starting 2026)
- **Appreciated property to public charities:** Up to 30% of AGI (deducted at fair market value, bypassing capital gains entirely)
- **Private foundations:** 30% (cash) / 20% (property)
- **Carryover:** Excess deductions carry forward up to 5 years.

([IRS Publication 526; IRC §170](https://eqvista.com/documents/irc-170/); [LegalClarity, "Are Donations Tax Exempt?"](https://legalclarity.org/are-donations-tax-exempt-what-you-can-deduct/))

**Important strategy not elaborated in thread:** Donating **appreciated stock** (held >1 year) to a public charity lets you deduct the full fair market value AND avoid capital gains tax on the appreciation. This is one of the most tax-efficient giving strategies available.

**⚠️ Note on "start your own non-profit":** While legal, this is heavily scrutinized. The organization must operate exclusively for exempt purposes under §501(c)(3), and private foundations face excise taxes and minimum distribution requirements. It's not a DIY tax shelter.

---

## 12. Tax Penalties as Low-Interest Loans

> "Tax penalties are low interest loans, so you can invest the money and pay the IRS the penalties at the end of the year." — **tonymet**

**❌ Misleading — the rate is NOT "low interest" in the current environment.**

The IRS underpayment penalty rate under IRC §6654 is the federal short-term rate + 3 percentage points. For Q1 2026, this is **8% annualized**, compounded daily. ([NationalTaxTools, Estimated Tax Penalty Calculator 2026](https://nationaltaxtools.com/calculators/estimated-tax-penalty-calculator/))

This is **not** a "low interest loan" — it's above most mortgage rates and comparable to credit card teaser rates. The strategy may have been more compelling when rates were near zero (2020–2021, when the penalty rate was ~3%), but at 8% it's expensive.

Additional problems:
- The penalty is **not deductible** (it's a penalty, not interest).
- Deliberate, repeated underpayment can trigger IRS scrutiny.
- If the IRS determines fraud (willful underpayment), penalties jump to 75% of the underpayment (IRC §6663), and criminal penalties are possible.
- **Safe harbor avoidance:** You must pay at least 90% of current-year tax OR 100% of prior-year tax (110% if AGI >$150K) to avoid the penalty entirely.

**Verdict:** Thread comment was **inaccurate as stated in 2026**. At current rates, this is an expensive and risky strategy, not a "low interest loan."

---

## 13. Perpetual Traveler / No Tax Residency

> "Don't live anywhere. Every other country taxes based on residency rather than citizenship." — **3rodents**

**⚠️ Theoretically possible for non-US citizens but practically very difficult and increasingly risky.** fer's pushback was largely correct.

**What's true:**
- Most countries (unlike the US) tax based on residency, not citizenship. ✅
- The common threshold is ~183 days for tax residency, though this varies. ✅
- The US taxes citizens on worldwide income regardless of where they live. ✅ (US citizens cannot use this strategy without renouncing citizenship.)

**What's wrong or oversimplified:**

- **CRS (Common Reporting Standard):** As of 2025, ~120 countries participate in automatic exchange of financial information. Banks must ask for your tax residence and TIN. "Banks do not want clients who are bouncing all over the world... CRS elevates their suspicion to a whole new level." ([Nomad Capitalist, "7 Non-CRS Countries for Banking Privacy"](https://nomadcapitalist.com/finance/non-crs-countries-banking/); [TaxHackers, "CRS Explained"](https://taxhackers.io/blog/en-banking-en-common-reporting-standard))
- **"Nowhere" is not a valid answer:** "Banks never accepted 'nowhere' as an answer. If you cannot provide [a tax residence], the bank might report the information to the jurisdiction where you are a citizen." ([TaxHackers CRS FAQ](https://taxhackers.io/blog/en-banking-en-common-reporting-standard))
- **fer's Italy example is accurate:** Italy requires AIRE registration to deregister from municipality; AIRE requires proof of residence abroad. Many countries have "center of vital interests" or domicile tests beyond the 183-day rule (Australia has 4 separate tests). ([Nomad Capitalist, "The Nomad Tax Trap"](https://nomadcapitalist.com/global-citizen/nomad-tax-trap-living-nowhere-harder/))
- **Enforcement is tightening:** "As more people have made the jump to a nomadic lifestyle, governments have paid more attention... [people] are now hearing from them. Because they never met all of the requirements to become a tax non-resident in their home country, they now owe thousands in back taxes." ([Nomad Capitalist](https://nomadcapitalist.com/global-citizen/nomad-tax-trap-living-nowhere-harder/))

**Verdict:** **3rodents** overstated the ease and safety of this approach. **fer** was largely correct that it's a "house of cards." The practical approach, as multiple experts note, is to establish *actual* tax residency in a low-tax or territorial-tax jurisdiction, not to be a resident of nowhere.

---

## 14. Tax Incentives / Credits (General)

> "A politician attracts investments into their constituency via tax incentives." — **Article**

**✅ Valid as a general category.** Examples include:
- Education credits (American Opportunity Credit, Lifetime Learning Credit)
- Energy efficiency credits (§25C, §25D)
- Opportunity Zone deferrals (IRC §1400Z-2)
- R&D tax credits (IRC §41)
- Low-Income Housing Tax Credits

Thread mention: **BeetleB** warned the IRS can be aggressive about documentation for education credits — his anecdote about the IRS requiring progressively more proof is consistent with known IRS verification practices.

**No correction needed.** The category is real; specific credit eligibility varies widely.

---

## Validation Summary

| # | Strategy | Thread Accuracy | Key Correction |
|---|----------|----------------|----------------|
| 1 | Reinvest as business expenses | ✅ Accurate | Salary req. is S-Corp specific, not all businesses |
| 2 | Depreciation / Cost seg | ⚠️ Partially accurate | Article overstates flexibility to "choose" schedules; constrained by §168/§179/§168(k) elections |
| 3 | Rental property depreciation | ⚠️ Partially accurate | Losses are passive by default; most taxpayers can't use them against ordinary income without REPS or <$150K MAGI |
| 4 | Borrow against assets | ✅ Accurate | 401(k) loans are capped at $50K |
| 5 | Refinancing | ✅ Accurate | No corrections needed |
| 6 | Buy, Borrow, Die | ✅ Accurate | Step-up happens at death for estate, not directly for heirs (technical correction) |
| 7 | Step-up in basis | ✅ Accurate | Thread correctly noted IRA/401(k) exclusion; add gifts and irrevocable trusts as exceptions |
| 8 | 401(k) / IRA | ✅ Accurate | Thread omitted Roth option (permanent reduction, not just deferral) |
| 9 | Income timing | ✅ Accurate | No corrections needed |
| 10 | Home sale exclusion | ✅ Accurate | Thread omitted nonqualifying use reduction and depreciation recapture |
| 11 | Charitable donations | ✅ Accurate | Thread omitted AGI limits (60%/30%/20%) and appreciated stock strategy |
| 12 | Tax penalties as loans | ❌ Misleading | 8% penalty rate in 2026 is NOT "low interest"; non-deductible; potential fraud penalties |
| 13 | Perpetual traveler | ❌ Overstated | CRS, banking barriers, domicile tests make this impractical for most; fer's rebuttal was largely correct |
| 14 | Tax incentives/credits | ✅ Accurate | No corrections needed |

---

## Cross-Validation Sources

| Source | Type | Strategies Validated |
|--------|------|---------------------|
| [Yale Budget Lab — Buy-Borrow-Die Reform](https://budgetlab.yale.edu/research/buy-borrow-die-options-reforming-tax-treatment-borrowing-against-appreciated-assets) | Academic/Policy | #4, #5, #6, #7 |
| [IRS Taxpayer Advocate — IRC §162](https://www.taxpayeradvocate.irs.gov/wp-content/uploads/2020/08/ARC19_Volume1_MLI_01_TradeorBusinessExpenses.pdf) | IRS Official | #1 |
| [IRS Fact Sheet 2008-25 — S-Corp Officer Wages](https://www.irs.gov/pub/irs-news/fs-08-25.pdf) | IRS Official | #1 (salary caveat) |
| [The Tax Adviser — Hobby Loss Trap](https://www.thetaxadviser.com/issues/2018/nov/avoiding-hobby-loss-trap-after-tcja/) | CPA/Professional | #1 (hobby rule) |
| [The Tax Adviser — RE Professional Rules](https://www.thetaxadviser.com/issues/2017/mar/navigating-real-estate-professional-rules/) | CPA/Professional | #3 |
| [KBKG — Depreciation Recapture](https://www.kbkg.com/cost-segregation/understanding-depreciation-recapture-what-real-estate-owners-need-to-know) | Industry/CPA | #2 |
| [Nolo — Home Sale Exclusion](https://www.nolo.com/legal-encyclopedia/the-250000500000-home-sale-tax-exclusion.html) | Legal Reference | #10 |
| [District Capital Mgmt — Stepped-Up Basis](https://districtcapitalmanagement.com/stepped-up-basis/) | Financial Advisory | #7 |
| [Hurwitz Fine — SECURE Act](https://www.hurwitzfine.com/blog/secure-act-limits-stretch-ira-estate-planning-opportunities) | Legal/Estate | #7, #8 |
| [NationalTaxTools — Penalty Calculator](https://nationaltaxtools.com/calculators/estimated-tax-penalty-calculator/) | Tax Reference | #12 |
| [Nomad Capitalist — CRS / Nomad Tax Trap](https://nomadcapitalist.com/finance/non-crs-countries-banking/) | Practitioner | #13 |
| [TaxHackers — CRS Explained](https://taxhackers.io/blog/en-banking-en-common-reporting-standard) | Practitioner | #13 |
| IRC §§ 121, 162, 167, 168, 170, 183, 469, 1014, 1245, 1250, 6654 | Primary Law | All |
