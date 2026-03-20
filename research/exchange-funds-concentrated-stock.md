← [Index](../README.md)

# Exchange Funds: Tax-Deferred Diversification from Concentrated Stock

**Date:** 2026-03-19
**Context:** Migrating highly-appreciated RSUs into diversified index exposure without triggering capital gains.

---

## Your Problem

You hold concentrated company stock (RSUs that have appreciated significantly). You want to move into broad index funds for the long term. If you sell and re-buy:

- Capital gains tax at up to 23.8% federal (20% LTCG + 3.8% Net Investment Income Tax under IRC §1411) + state tax. The 3.8% NIIT applies when MAGI exceeds $200K single / $250K MFJ — thresholds are NOT inflation-adjusted. ([IRC §1411](https://taxspecialty.com/net-investment-income-tax-2026/))
- On a $1M position with $200K cost basis at the 23.8% combined rate: $800K × 23.8% = ~$190K in federal taxes alone, plus state
- That's money that can never compound for you again

This is the "golden handcuffs" problem. Exchange funds are the primary solution.

---

## What Is an Exchange Fund?

An exchange fund (also called a "swap fund") is a **private partnership** where multiple investors each contribute their own concentrated stock positions. The fund pools them all together, creating a diversified portfolio. You contribute your single stock and receive partnership units representing a share of the entire diversified pool.

**The tax magic:** Under **IRC §721(a)**, contributing property to a partnership in exchange for a partnership interest is a **non-recognition event** — no capital gains tax is triggered. Your original cost basis carries over into the fund.

**Legal basis:** IRC §721(a) — "No gain or loss shall be recognized to a partnership or to any of its partners in the case of a contribution of property to the partnership in exchange for an interest in the partnership."

([Freeman Law, "Transfers of Stock or Securities to Investment Partnerships"](https://freemanlaw.com/transfers-of-stock-or-securities-to-investment-partnerships-a-dangerous-exception-lurking-for-the-unwary/); [Alpha Architect, "Portfolio Tax Strategies: Section 351 vs. Exchange Funds"](https://alphaarchitect.com/portfolio-tax-strategies-section-351-vs-exchange-funds-vs-long-short-tax-loss-harvesting/))

---

## How It Works Step by Step

| Step | What Happens | Tax Consequence |
|------|-------------|-----------------|
| 1. **Contribute** | You transfer your concentrated stock (e.g., $1M of Company X RSUs) into the exchange fund | **No tax.** Non-recognition under IRC §721(a) |
| 2. **Pool** | Your shares join a pool of many investors' concentrated positions, creating a diversified portfolio | N/A |
| 3. **Hold (7 years)** | You hold partnership units representing your pro-rata share of the diversified pool | N/A — you own LP units, not individual stocks |
| 4. **Redeem** | After the 7-year minimum holding period, you redeem your units and receive a **basket of diversified stocks** (not cash, not your original stock) | **No tax — but this is the legally complex step.** See "Back-End Tax Treatment" section below. |
| 5. **Sell (eventually)** | When you eventually sell the stocks received, you owe capital gains on the difference between sale price and your **original carried-over basis** | **Tax owed** — but deferred potentially decades; or eliminated entirely via step-up at death |

([Ramp.com, "Exchange Funds & How They Work"](https://ramp.com/blog/using-exchange-funds-to-diversify-tech-employee-equity-holdings); [3040 Wealth, "Exchange Funds: Diversification Not Taxation"](https://www.3040wealth.com/academy/exchange-funds-diversification-not-taxation); [Financial Planning Association, "Tax-Efficient Ways to Diversify"](https://www.financialplanningassociation.org/learning/publications/journal/OCT24-tax-efficient-ways-diversify-concentrated-stock-positions-OPEN))

**Key point: This is tax DEFERRAL, not elimination.** Your original low cost basis carries over. But deferral is extremely valuable because:
1. The full un-taxed amount compounds for decades
2. If you hold until death → step-up in basis under IRC §1014 → tax is eliminated permanently

---

## Back-End Tax Treatment (The Complex Part)

The front end (contributing stock to the fund) is well-settled law under §721(a). The **back end** (redeeming your units for diversified stocks after 7 years) is more legally complex than most exchange fund marketing materials suggest.

**The problem:** IRC §731(c) generally treats distributions of **marketable securities** from a partnership as **cash**. If you receive $800K of diversified stocks and your outside basis is only $10K, that looks like a $790K taxable gain under §731(a)(1).

**Why it (usually) works anyway:** §731(c)(3)(B) provides a "built-in gain reduction" — the amount treated as cash is reduced by your share of the partnership's built-in gain in the distributed securities. Treasury Regulation §1.731-2(b) aggregates ALL marketable securities for this calculation, which — critically — includes the pre-contribution gain on your original concentrated stock. Because that pre-contribution gain is large relative to your total share, it effectively shields the entire distribution from tax when you **completely liquidate** your interest.

> "Ann would be treated as receiving a cash distribution of her original $10,000 basis... she should ultimately have no taxable gain under section 731 as a result of her distribution." — Berkeley Law Professors Mark Gergen & Adam Nguyen, [Tax Notes, "Exchange Funds at the Back End" (2025)](https://www.taxnotes.com/featured-analysis/exchange-funds-back-end/2025/04/07/7rvj6)

**⚠️ Critical limitations:**

1. **Must completely liquidate your interest.** If you do a partial redemption, your pre-contribution gain stays allocated to your remaining partnership interest and cannot shield the distribution. Partial redemptions can trigger significant tax. (Gergen & Nguyen, Tax Notes 2025)

2. **Fund must still hold your original contributed stock.** If the fund distributed your contributed shares to OTHER partners before you exit, the shield shrinks proportionally. (Tax Notes 2025)

3. **If your contributed stock declined in value,** the protection may be incomplete depending on the partnership's allocation method (traditional vs. remedial). (Tax Notes 2025)

4. **This area of law is contested.** Gergen and Nguyen argue Treasury should close this gap: "We believe Treasury should clarify that a partnership structured to avoid section 721(b) cannot qualify as an investment partnership under section 731(c)... These changes would reduce but not eliminate the attractiveness of exchange funds." The current treatment benefits from Treasury's aggregation rule, which could be changed by regulation without new legislation.

**Why the 7-year minimum is mandatory (legal, not just structural):**

The 7-year holding period is dictated by IRC, not just fund policy:
- **IRC §704(c)(1)(B):** If the fund distributes your contributed stock to another partner within 7 years, YOU recognize the built-in gain.
- **IRC §737:** If you receive a distribution of OTHER property from the fund within 7 years, you recognize gain up to your net pre-contribution gain.
- **IRC §707(a)(2)(B):** Presumption of "disguised sale" for distributions within 2 years.

([Cummings Law, "Tax Implications of Withdrawing Pre-Contribution Gains"](https://www.cummings.law/tax-implications-of-withdrawing-pre-contribution-gains-in-a-partnership/); [26 USC §737](https://www.law.cornell.edu/uscode/text/26/737); [The Tax Adviser, "Partnership Distributions: Rules and Exceptions" (2024)](https://www.thetaxadviser.com/issues/2024/aug/partnership-distributions-rules-and-exceptions/))

---

## The 20% Illiquid Asset Requirement

Here's the critical legal wrinkle. IRC §721(b) says the non-recognition rule does NOT apply to contributions to an "investment company" that result in diversification. An exchange fund — where multiple people contribute different stocks to get a diversified pool — would normally trigger this exception and be TAXABLE.

**The workaround:** The fund must hold **at least 20% of its assets in illiquid, non-marketable investments** (typically real estate partnerships / REIT operating units). This ensures the fund doesn't meet the "investment company" definition (which requires >80% marketable securities).

> "Exchange funds avoid being classified as an investment company partnership under section 721(b) by ensuring that at least 20 percent of their assets are not listed investment assets." — [Tax Notes, "Exchange Funds at the Back End" (2025)](https://www.taxnotes.com/featured-analysis/exchange-funds-back-end/2025/04/07/7rvj6)

This means your exchange fund returns will include ~20% real estate exposure, which acts as a drag or diversifier depending on market conditions.

---

## Who Offers Exchange Funds

### Major Providers (confirmed)

| Provider | Fund Names | Min Investment | Annual Fee | Notes |
|----------|-----------|---------------|------------|-------|
| **Eaton Vance** (now Morgan Stanley subsidiary, acquired 2021) | Belrose, Belair, Belcrest, Belvedere, etc. | ~$500K–$1M stock | ~1% | Largest exchange fund platform. Fund names confirmed by [NYT 2002](https://www.nytimes.com/2002/09/10/business/a-tax-break-for-the-rich-who-can-keep-a-secret.html). AUM widely cited as $60B+ in practitioner community (r/fatFIRE) but no official public figure available — these are private placements. |
| **Goldman Sachs** | GS Exchange Fund | ~$1M–$5M | ~1% | AUM widely cited as ~$20B in practitioner community (r/fatFIRE); NYT 2002 reported Eaton Vance + Goldman had "at least $18 billion" combined at that time. More selective; fills quickly. ([r/CFP](https://www.reddit.com/r/CFP/comments/1e45tpz/exchange_fund/): "we had to have the paperwork all ready to go so we could submit it within minutes") |
| **Cache Financials** | Cache Exchange Fund | **$100K–$250K** | 0.40%–0.95% | Newer entrant. Tracks S&P 500. Aims to exit into single ETF via §351 exchange. Accepts accredited investors, not just qualified purchasers. Confirmed by [Advisor Perspectives (2025)](https://www.advisorperspectives.com/articles/2025/12/15/tax-efficient-ways-diversify-concentrated-positions) and [Tax Notes (2025)](https://www.taxnotes.com/featured-analysis/exchange-funds-back-end/2025/04/07/7rvj6). |
| **Bessemer Trust** | Various | $1M+ | ~1% | Confirmed by [NYT 2002](https://www.nytimes.com/2002/09/10/business/a-tax-break-for-the-rich-who-can-keep-a-secret.html), [r/fatFIRE](https://www.reddit.com/r/fatFIRE/comments/1orrmq0/thoughts_on_exchange_funds/) |
| **J.P. Morgan** | Various | $1M+ | ~1% | Confirmed by [FA Magazine 2004](https://www.fa-mag.com/news/article-992.html) |

**Note on Morgan Stanley:** Morgan Stanley acquired Eaton Vance in 2021. When r/fatFIRE users cite "Morgan Stanley" exchange funds, they are likely referring to Eaton Vance products distributed through Morgan Stanley's wealth management platform. They are not a separate provider with different funds.

### Merrill Lynch

**Confirmed:** Merrill Lynch has historically offered exchange funds under the name **"Montvale Fund"**, described as leaning "more toward the mid-cap market."

> "Several financial firms offer exchange funds, including Eaton Vance, Goldman Sachs, Merrill Lynch and J.P. Morgan... Merrill Lynch's Montvale Fund lean[s] more toward the mid-cap market." — [Financial Advisor Magazine, "Understanding Exchange Funds" (2004)](https://www.fa-mag.com/news/article-992.html)

> Merrill Lynch is also confirmed as an operator in the 2002 NYT investigation of exchange funds. — [NYT, "A Tax Break for the Rich Who Can Keep a Secret" (2002)](https://www.nytimes.com/2002/09/10/business/a-tax-break-for-the-rich-who-can-keep-a-secret.html)

**⚠️ Current status caveat:** I could not find a current (2025–2026) public listing confirming Merrill Lynch is still actively accepting new contributions to exchange funds. These are private placements — they cannot advertise. The offering details are confidential (investors sign NDAs). You need to **ask your Merrill advisor directly** whether the Montvale fund or successor funds are currently open and accepting your specific stock.

---

## Eligibility Requirements

- **Traditional exchange funds (Eaton Vance, Goldman, Bessemer, J.P. Morgan):** Require **Qualified Purchaser** status — $5M+ in investable assets per Investment Company Act of 1940, §2(a)(51). Minimum contribution typically $1M in stock. ([Cache FAQ](https://usecache.com/companion/accredited-investor-vs-qualified-purchaser); [Wikipedia, Accredited Investor](https://en.wikipedia.org/wiki/Accredited_investor); [NYT 2002](https://www.nytimes.com/2002/09/10/business/a-tax-break-for-the-rich-who-can-keep-a-secret.html): "only open to 'qualified investors' with a liquid net worth of at least $5 million")
- **Cache Financials:** Lower bar — accepts **Accredited Investors** ($200K income for past 2 years, or $1M+ net worth excluding primary residence, per SEC Rule 501 of Regulation D). Minimum contribution $100K–$250K. This is the innovation that prompted the Berkeley Law Tax Notes article: "Cache is making exchange funds available to people who aren't particularly wealthy but have a large nest egg concentrated in one company." ([Tax Notes 2025](https://www.taxnotes.com/featured-analysis/exchange-funds-back-end/2025/04/07/7rvj6))
- **Stock must be acceptable:** The fund manager decides which stocks to accept based on sector balance, market cap, and existing concentrations. Popular mega-caps (AAPL, NVDA, GOOG, META, AMZN) are often **oversubscribed** — "the issue is not the fee, it's do they have room to accept your stocks" (top-voted r/fatFIRE comment). Multiple r/fatFIRE users reported being turned away or waitlisted.
- **Company policy check:** If you're still employed at the company, your equity plan may have trading restrictions, blackout windows, or "no hedging/no pledging" policies that could affect eligibility. Multiple r/fatFIRE users flagged this: "A lot of [company stock policies] have a 'no short' policy that will not let you enter into a negative position on the stock (shorts, buying puts, selling calls, swaps, futures, 'insurance', or other derivatives, etc.)."

---

## Pros

1. **Immediate diversification, zero immediate tax** — the entire value of your position starts working in a diversified portfolio
2. **Simple mechanism** — cleaner than derivatives (collars, forwards) or long/short overlay strategies
3. **Estate planning synergy** — hold the diversified position until death → step-up in basis → tax eliminated permanently
4. **Fidelity institutional whitepaper example:** Contributing $5M to an exchange fund defers >$1M in taxes immediately; after 7 years at 7% assumed growth, this results in ~$2M more wealth vs. selling and reinvesting after-tax proceeds. ([Fidelity Institutional, Exchange Fund PDF](https://institutional.fidelity.com/app/proxy/content?literatureURL=%2F9904554.PDF) — exact quote from search snippet: "an investor who put $5 million into an exchange fund would immediately defer over $1 million in tax liability... After 7 years, this could result in approximately $2 million in additional return." Note: this is an illustrative example with assumed returns; actual results vary.)

---

## Cons & Risks

1. **7-year lockup:** Your capital is illiquid for at least 7 years. You cannot access it. If your stock craters during this period, you've already contributed it.
2. **~20% real estate exposure:** Required for the §721(b) workaround. This is a drag if equities outperform RE, and a tracking error source.
3. **Fees:** 0.40%–1.0% annually. Over 7 years at 0.85%, that's ~6% of your assets in fees.
4. **You get a basket of stocks back, not cash or an index fund:** After 7 years, you receive ~25–30 individual stocks (your pro-rata share of the pool). You then need to manage or further consolidate these. (Cache's newer model addresses this by exiting into a single ETF via §351.)
5. **Fund may not accept your stock:** Oversubscription is a real problem for popular tech stocks.
6. **Carryover basis:** Your original low basis follows you. The tax is deferred, not eliminated (unless you die holding the position).
7. **Tax complexity:** K-1 partnership reporting, potential for allocations of real estate income/loss, etc.

---

## Alternatives to Exchange Funds

| Strategy | How It Works | Timeline | Tax | Downsides |
|----------|-------------|----------|-----|-----------|
| **Sell and re-buy** | Sell stock, pay tax, buy index fund | Immediate | Full tax hit now | Lose 20-25%+ to taxes immediately |
| **Staged selling** | Sell in tranches over 2-3 years | 2-3 years | Spread tax across years/brackets | Still pay full tax, just spread out |
| **Section 351 ETF exchange** | Contribute diversified basket of stocks into a new ETF at launch | Immediate (if you qualify) | Tax-deferred | **Requires already-diversified portfolio** (25/50 test). Cannot use for a single concentrated stock alone. |
| **Direct indexing + tax-loss harvesting** | Buy individual index stocks, harvest losses to offset gains from selling concentrated position | 3-9 years to fully exit | Gradual offset | Slow; long-only harvests ~40-50% of losses |
| **Long/short overlay (AQR, Quantinno)** | Use concentrated stock as collateral for long/short strategy that generates tax losses | 7-9 years | Gradual offset | Expensive (~0.50%+); margin risk; complex |
| **Charitable donation** | Donate appreciated stock to charity | Immediate | Avoid all cap gains + get deduction | Money goes to charity, not you |
| **Donor-Advised Fund (DAF)** | Contribute stock to DAF, get immediate deduction, grant to charities over time | Immediate deduction | Avoid all cap gains | Irrevocable — cannot get money back |
| **Hold until death** | Do nothing. Step-up in basis erases gains. | Lifetime | Eliminated at death | Concentration risk for your entire life |

---

## Section 351 ETF Exchange — Important Distinction

The thread and some sources conflate exchange funds (§721) with §351 ETF exchanges. They are **different**:

| | Exchange Fund (§721) | §351 ETF Exchange |
|---|---|---|
| **Structure** | Limited partnership | Corporation (ETF/RIC) |
| **Concentrated stock OK?** | **Yes** — this is what it's designed for | **No** — must pass 25/50 diversification test before contributing |
| **Diversification test** | Avoids investment company status via 20% illiquid assets | Must be already diversified: no single stock >25%, top 5 <50% |
| **Lockup** | 7 years minimum | None (ETF shares are liquid immediately) |
| **What you get back** | Basket of individual stocks | ETF shares |
| **Best for** | Single concentrated position | Already-diversified portfolio of individual stocks you want in ETF wrapper |

([Kitces.com, "Using Section 351 Exchanges"](https://www.kitces.com/blog/section-351-exchanges-tax-efficient-reallocate-portfolio-us-equity-markets-etf/); [Alpha Architect](https://alphaarchitect.com/portfolio-tax-strategies-section-351-vs-exchange-funds-vs-long-short-tax-loss-harvesting/))

**For your situation (concentrated RSUs in one stock → index fund):** an exchange fund (§721) is the correct vehicle, NOT a standalone §351 exchange. However, Cache Financials combines both: §721 exchange fund → exits into §351 ETF, giving you a single diversified ETF at the end instead of a random basket of stocks.

---

## What to Do Next

1. **Check your company equity plan** — look for hedging/pledging restrictions that might block exchange fund participation
2. **Call your Merrill advisor** — ask specifically about exchange fund availability for your stock. Ask about the Montvale Fund or current equivalents. Ask about Cache Financials if Merrill's own funds are oversubscribed.
3. **Get the minimum and fee schedule in writing** — these are private placements, terms vary
4. **Understand the 7-year lockup** — make sure you don't need this capital in that window
5. **Talk to a tax CPA** — specifically one experienced with §721 partnership contributions and concentrated stock strategies. K-1 reporting is complex.

---

## Sources

| Source | Type | What It Confirms |
|--------|------|------------------|
| IRC §721(a), §721(b) | Primary law | Non-recognition for partnership contributions; investment company exception |
| IRC §351(e), Treas. Reg. §1.351-1(c) | Primary law | Investment company definition, diversification tests |
| [Tax Notes, "Exchange Funds at the Back End" (2025)](https://www.taxnotes.com/featured-analysis/exchange-funds-back-end/2025/04/07/7rvj6) | Academic/legal | 20% illiquid requirement, §721(b) mechanics |
| [Freeman Law, "Transfers to Investment Partnerships"](https://freemanlaw.com/transfers-of-stock-or-securities-to-investment-partnerships-a-dangerous-exception-lurking-for-the-unwary/) | Law firm | §721(b) analysis, diversification test details |
| [Kitces.com, "Section 351 Exchanges"](https://www.kitces.com/blog/section-351-exchanges-tax-efficient-reallocate-portfolio-us-equity-markets-etf/) | Financial planning (authoritative) | §351 vs §721 distinction |
| [Alpha Architect, "Portfolio Tax Strategies"](https://alphaarchitect.com/portfolio-tax-strategies-section-351-vs-exchange-funds-vs-long-short-tax-loss-harvesting/) | Asset manager | §351 vs exchange fund comparison |
| [NYT, "A Tax Break for the Rich" (2002)](https://www.nytimes.com/2002/09/10/business/a-tax-break-for-the-rich-who-can-keep-a-secret.html) | Investigative journalism | Confirms Merrill Lynch, Goldman, Eaton Vance as operators |
| [FA Magazine, "Understanding Exchange Funds" (2004)](https://www.fa-mag.com/news/article-992.html) | Industry | Merrill Lynch "Montvale Fund" confirmed; mechanics |
| [Advisor Perspectives, "New Tax-Efficient Ways" (2025)](https://www.advisorperspectives.com/articles/2025/12/15/tax-efficient-ways-diversify-concentrated-positions) | Industry | Cache + Alpha Architect §721→§351 combo |
| [Fidelity, Exchange Fund Whitepaper](https://institutional.fidelity.com/app/proxy/content?literatureURL=%2F9904554.PDF) | Asset manager | $5M example, deferral math |
| [r/fatFIRE, "Thoughts on exchange funds?"](https://www.reddit.com/r/fatFIRE/comments/1orrmq0/thoughts_on_exchange_funds/) | Practitioner community | Real-world experience, oversubscription issues, provider comparison |
| [Withum CPA, "Contributions to an Investment Company"](https://www.withum.com/resources/considering-a-contribution-of-assets-to-an-investment-company-heres-what-you-need-to-know/) | CPA firm | §721(b) and §351(e) mechanics |
| [26 USC §737](https://www.law.cornell.edu/uscode/text/26/737) | Primary law | 7-year pre-contribution gain rule |
| [Cummings Law, "Pre-Contribution Gains in a Partnership"](https://www.cummings.law/tax-implications-of-withdrawing-pre-contribution-gains-in-a-partnership/) | Law firm | §704(c)(1)(B) and §737 seven-year rules |
| [The Tax Adviser, "Partnership Distributions" (2024)](https://www.thetaxadviser.com/issues/2024/aug/partnership-distributions-rules-and-exceptions/) | CPA/Professional | §704(c)(1)(B) distribution rules |
| [IRS Publication 541, Partnerships](https://www.irs.gov/publications/p541) | IRS Official | §721(a) contribution non-recognition |
| [Cache FAQ — Accredited vs Qualified Purchaser](https://usecache.com/companion/accredited-investor-vs-qualified-purchaser) | Provider | Eligibility definitions |
| IRC §1411, [Tax Specialty, NIIT 2026](https://taxspecialty.com/net-investment-income-tax-2026/) | Primary law + reference | 3.8% NIIT rates and thresholds |

---

## Validation Summary

| Claim | Status | Correction |
|-------|--------|------------|
| IRC §721(a) non-recognition for partnership contributions | ✅ Confirmed | IRS Publication 541; Freeman Law |
| 20% illiquid asset requirement to avoid §721(b) | ✅ Confirmed | Tax Notes 2025 (Berkeley Law); Withum CPA |
| 7-year minimum holding period | ✅ Confirmed, but **why** was missing | Mandated by IRC §§704(c)(1)(B), 737, 707 — not just fund policy. Added explanation. |
| Back-end distribution is tax-free under §731 | ⚠️ **Oversimplified** | §731(c) treats marketable securities as cash; non-taxable outcome depends on §731(c)(3)(B) built-in gain reduction + Treasury aggregation rule. Only works for **complete** liquidation. Partial redemptions can trigger tax. Added full "Back-End Tax Treatment" section per Tax Notes 2025 analysis. |
| Merrill Lynch offers exchange funds (Montvale Fund) | ✅ Historically confirmed | FA Magazine 2004, NYT 2002. Current (2026) availability unverifiable from public sources — private placement, must ask advisor. |
| Eaton Vance $60B+ AUM | ⚠️ **Unverified official source** | Widely cited in r/fatFIRE; sourced to practitioner community, not official filings. Flagged as such. |
| Goldman Sachs ~$20B AUM | ⚠️ **Unverified official source** | Same as above. NYT 2002 reported $18B combined for EV+GS at that time. |
| Cache minimums $100K–$250K, fees 0.40%–0.95% | ✅ Confirmed | Advisor Perspectives 2025 (quoting Cache CEO); Tax Notes 2025 |
| Cache accepts accredited investors (not just qualified purchasers) | ✅ Confirmed | Cache's own FAQ page; Tax Notes 2025 |
| Morgan Stanley listed as separate provider | ❌ **Corrected** | MS acquired Eaton Vance in 2021. Not a separate exchange fund provider. Removed duplicate row, added clarifying note. |
| §351 ETF exchange cannot be used for single concentrated stock | ✅ Confirmed | Kitces.com; Alpha Architect; §368(a)(2)(F) 25/50 diversification test |
| Qualified Purchaser = $5M+ investable assets | ✅ Confirmed | Investment Company Act of 1940, §2(a)(51); Wikipedia; Cache FAQ |
| Accredited Investor = $200K income or $1M net worth | ✅ Confirmed | SEC Rule 501, Regulation D; Wikipedia |
| 23.8% combined LTCG rate (20% + 3.8% NIIT) | ✅ Confirmed | IRC §1411; NIIT thresholds $200K/$250K, not inflation-adjusted |
| Tax math: $1M position, $200K basis → ~$190K tax | ✅ Confirmed | $800K × 23.8% = $190,400 |
| Fidelity $5M → ~$2M additional return after 7 years at 7% | ✅ Confirmed | Fidelity institutional whitepaper (search snippet verified) |
| Back-end tax treatment is settled law | ❌ **Corrected** | Berkeley Law professors explicitly argue Treasury should change the aggregation rule. This area is legally contested. Added full analysis. |
