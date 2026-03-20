← [Index](../README.md)

# Exchange Funds: Tax-Deferred Diversification from Concentrated Stock

**Date:** 2026-03-19
**Context:** Migrating highly-appreciated RSUs into diversified index exposure without triggering capital gains.

---

## Your Problem

You hold concentrated company stock (RSUs that have appreciated significantly). You want to move into broad index funds for the long term. If you sell and re-buy:

- Capital gains tax at 23.8% federal (20% LTCG + 3.8% NIIT) + state tax
- On a $1M position with $200K cost basis: ~$190K+ in taxes immediately
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
| 4. **Redeem** | After the 7-year minimum holding period, you redeem your units and receive a **basket of diversified stocks** (not cash, not your original stock) | **No tax.** Distribution of partnership property is generally non-taxable under IRC §731 |
| 5. **Sell (eventually)** | When you eventually sell the stocks received, you owe capital gains on the difference between sale price and your **original carried-over basis** | **Tax owed** — but deferred potentially decades; or eliminated entirely via step-up at death |

([Ramp.com, "Exchange Funds & How They Work"](https://ramp.com/blog/using-exchange-funds-to-diversify-tech-employee-equity-holdings); [3040 Wealth, "Exchange Funds: Diversification Not Taxation"](https://www.3040wealth.com/academy/exchange-funds-diversification-not-taxation); [Financial Planning Association, "Tax-Efficient Ways to Diversify"](https://www.financialplanningassociation.org/learning/publications/journal/OCT24-tax-efficient-ways-diversify-concentrated-stock-positions-OPEN))

**Key point: This is tax DEFERRAL, not elimination.** Your original low cost basis carries over. But deferral is extremely valuable because:
1. The full un-taxed amount compounds for decades
2. If you hold until death → step-up in basis under IRC §1014 → tax is eliminated permanently

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
| **Eaton Vance** (Morgan Stanley) | Belrose, Belair, Belcrest, Belvedere, etc. | ~$1M stock | ~1% | Largest platform, $60B+. The "king" of exchange funds. |
| **Goldman Sachs** | GS Exchange Fund | ~$1M–$5M | ~1% | ~$20B AUM. More selective. |
| **Morgan Stanley** | Various | ~$1M | 0.40–0.85% | Confirmed by r/fatFIRE users |
| **Cache Financials** | Cache Exchange Fund | $100K–$250K | 0.40%–0.95% | Newer entrant. Tracks S&P 500. Exits into single ETF (via §351). Lower minimums. |
| **Bessemer Trust** | Various | $1M+ | ~1% | |
| **J.P. Morgan** | Various | $1M+ | ~1% | |

### Merrill Lynch

**Confirmed:** Merrill Lynch has historically offered exchange funds under the name **"Montvale Fund"**, described as leaning "more toward the mid-cap market."

> "Several financial firms offer exchange funds, including Eaton Vance, Goldman Sachs, Merrill Lynch and J.P. Morgan... Merrill Lynch's Montvale Fund lean[s] more toward the mid-cap market." — [Financial Advisor Magazine, "Understanding Exchange Funds" (2004)](https://www.fa-mag.com/news/article-992.html)

> Merrill Lynch is also confirmed as an operator in the 2002 NYT investigation of exchange funds. — [NYT, "A Tax Break for the Rich Who Can Keep a Secret" (2002)](https://www.nytimes.com/2002/09/10/business/a-tax-break-for-the-rich-who-can-keep-a-secret.html)

**⚠️ Current status caveat:** I could not find a current (2025–2026) public listing confirming Merrill Lynch is still actively accepting new contributions to exchange funds. These are private placements — they cannot advertise. The offering details are confidential (investors sign NDAs). You need to **ask your Merrill advisor directly** whether the Montvale fund or successor funds are currently open and accepting your specific stock.

---

## Eligibility Requirements

- **Qualified Purchaser status:** Generally requires $5M+ in investable assets (SEC definition). Some funds accept "accredited investors" ($200K income or $1M net worth excluding primary residence).
- **Minimum contribution:** Typically $1M in stock. Cache is a notable exception at $100K–$250K.
- **Stock must be acceptable:** The fund manager decides which stocks to accept. Popular mega-caps (AAPL, NVDA, GOOG, META, AMZN) are often **oversubscribed** — "the issue is not the fee, it's do they have room to accept your stocks" (top-voted r/fatFIRE comment). Less common stocks may be easier to place.
- **Company policy check:** If you're still employed at the company, your equity plan may have trading restrictions, blackout windows, or "no hedging/no pledging" policies that could affect eligibility.

---

## Pros

1. **Immediate diversification, zero immediate tax** — the entire value of your position starts working in a diversified portfolio
2. **Simple mechanism** — cleaner than derivatives (collars, forwards) or long/short overlay strategies
3. **Estate planning synergy** — hold the diversified position until death → step-up in basis → tax eliminated permanently
4. **Fidelity example from their whitepaper:** Contributing $5M to an exchange fund defers >$1M in taxes immediately; after 7 years at 7% growth, this results in ~$2M more wealth vs. selling and reinvesting after-tax proceeds

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
