← [Index](../README.md)

## HN Thread Distillation: "Nasdaq's Shame"

**Source:** [keubiko.substack.com](https://keubiko.substack.com/p/nasdaqs-shame) | [HN thread](https://news.ycombinator.com/item?id=47392550) (349 pts, 116 comments, 78 authors)

**Article summary:** Nasdaq is proposing rule changes to the Nasdaq-100 index — a "Fast Entry" exemption (15-day inclusion for mega-cap IPOs, bypassing seasoning/liquidity requirements) and a 5x multiplier for low-float stocks — transparently timed to win SpaceX's ~$1.75T IPO listing. The author argues this creates a mechanical wealth transfer: passive funds get forced to buy at squeeze prices with constrained supply, then insiders dump when lock-ups expire at a conveniently timed quarterly rebalance. SpaceX is targeting a mid-June IPO to hit the December 2026 rebalance window.

### Dominant Sentiment: Alarmed but arguing about blast radius

The thread mostly accepts the article's core thesis — that the Nasdaq-100 rule changes are tailored for SpaceX and structurally harmful — but splits hard on *who actually gets hurt* and *how much it matters* beyond QQQ holders.

### Key Insights

**1. The best explanation of the mechanism outranks the article itself**

[Veserv]'s top comment reframes the whole scheme as a short squeeze without shorts: in a toy model where passive funds own 20% of the index and a new company enters with only 5% float, the funds are contractually obligated to buy more shares than exist on the open market — a "financial divide by zero." [super256] pushes back on two fronts: under the actual Nasdaq proposal the weighting would be 25% of market cap (5% float × 5x multiplier), not Veserv's simplified 20%; and funds can use derivatives or tracking error rather than buying every physical share. [Galanwe] counters that prospectuses limit synthetic replication — "good" ETFs are ~98% physical. The tension between contractual obligation and practical flexibility is the central unresolved question the thread never settles.

**2. The QQQ-containment debate is the thread's real fault line**

[exmadscientist] argues this is narrowly a Nasdaq-100 problem: "Indexing to the Nasdaq 100 is pretty uncommon, outside of QQQ, so most people will not care." [bagacrap] repeatedly hammers this — "no sane investor holds QQQ," it has no academic basis, it's just return-chasing with marketing dollars baked in.

[nighthawk454] pushes back hard: the Nasdaq-100 shares 79 of 100 stocks with the S&P 500. Rebalancing that sells those stocks to buy SpaceX will mechanically depress prices of MAG7 constituents held everywhere. [maest] adds weight to this side: "There's more than $1T tracking Nasdaq 100, so that's an ignorant statement." The directional argument is right — you can't sell MAG7 stocks to buy SpaceX without *some* price propagation — but the magnitude is uncertain. QQQ's ~$400B AUM is large in absolute terms, yet the selling pressure on individual names like AAPL ($3T+ market cap, massive daily volume) from a single rebalance may be modest as a fraction of those markets.

**3. All three major index providers are bending rules simultaneously**

[nighthawk454] drops a crucial link: S&P Dow Jones Indices is *also* considering rule changes to fast-track SpaceX into the S&P 500. [mpercival531] adds that "FTSE Russell is proposing changes similar to Nasdaq, with the consultation ending 18 March." Neither point received meaningful engagement despite being the most consequential data in the thread. If Nasdaq, S&P, *and* FTSE Russell all bend their rules for the same IPO, the "just don't hold QQQ" defense weakens considerably — though the specific mechanisms and severity differ by index, and we don't yet know the details of S&P's or FTSE's proposals.

**4. The Nortel precedent is the thread's sharpest historical analogy**

[kmeisthax] draws a direct line to Nortel Networks and the TSE: index inclusion → forced buying → price inflation → more index weight → more forced buying, until Nortel was so dominant it made the TSE too homogeneous to legally index. Canada changed the rules to accommodate it. Then Nortel crashed and took Canadian retirement savings with it. The parallel to MAG7 concentration + SpaceX insertion is uncomfortable and underexplored.

**5. VTI/CRSP investors are probably fine — the float-adjustment mechanism works as designed**

[cholmon] and [stockresearcher] provide the most actionable information: CRSP (which underlies Vanguard's VTI) adds IPOs within 5 days but uses free-float weighting. A 5% float SpaceX at $1.75T would enter as a ~$87.5B position — large but not distortionary, and proportional to actual tradeable supply. This is what honest index design looks like, and it's the implicit control case that makes Nasdaq's 5x multiplier look even more egregious.

**6. The real play is the lock-up expiry, not Day 15**

The article's most underappreciated point, which the thread mostly misses: the initial squeeze is just setup. The kill shot is timing lock-up expiration to coincide with a quarterly rebalance where the float jumps above 20%, the 5x multiplier drops, and full 100% weighting kicks in — forcing *another* massive wave of passive buying exactly when insiders can sell. [bagacrap] is one of the few who gets this, warning that "ceasing to invest in it will not save you. The rebalancing discussed in the article happens internally with your already invested dollars." But most of the thread focuses on the Day 15 inclusion and ignores the second, larger forced-buying event at lock-up expiry.

**7. The "just short it" crowd gets correctly shut down**

[dweez] tongue-in-cheek suggests shorting post-rebalancing. [bagacrap] points out shorting requires leverage and is extremely advanced. [cmcaleer] provides the real answer: "Tesla has been [a short candidate] for a long time... the road is littered with dead Tesla bears. Efficient markets hypothesis breaks down with Musk companies." The mechanism described in the article is specifically designed to create conditions where shorting is suicidal — you're betting against a wall of price-insensitive forced buying.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Only affects QQQ, which is niche" | Medium | Over $1T tracks the Nasdaq-100 ([maest]), so "niche" undersells it. S&P and FTSE are proposing similar changes. Cross-index price effects propagate, though magnitude is uncertain |
| "Funds can use derivatives/synthetic replication" | Medium | Technically true, but [Galanwe] notes prospectuses limit non-physical replication; "good" ETFs are ~98% physical |
| "Just sell QQQ and buy something else" | Weak | Ignores tax lock-in for taxable accounts, 401k plan limitations, and cross-index contagion |
| "Funds aren't *really* contractually obligated to exact replication" | Medium | Tracking error exists, but the competitive pressure to minimize it means most of the forced buying still happens |
| "The outrage is misplaced — indexing isn't sacrosanct" | Medium | [yieldcrv]: "This is only controversial because you're too married to indexing." Challenges the premise rather than the mechanics. Fair point that index inclusion was never meant to be a merit badge, but doesn't address the forced-buying harm to existing holders |

### What the Thread Misses

- **Regulatory capture is the elephant in the room.** The article gestures at the SEC doing nothing. [SilverElfin] notes "all this rule making happens so quickly for friends and family members and donors of the Trump administration," but nobody goes deeper — connecting Musk's political position to the specific question of whether the SEC would (or could) block these rule changes. The probability of regulatory intervention in the current environment is near zero, and that structural fact matters more than the mechanics.

- **Index governance as systemic risk.** [vmbm] comes closest: "moving forward it is probably worth thinking about index governance as well." But nobody asks the structural question: *who governs the governors?* Nasdaq, S&P, and FTSE Russell are all private companies with profit motives. The entire passive investing revolution rests on trusting these companies to maintain honest indices, and per [nighthawk454] and [mpercival531], all three are simultaneously considering rule changes for the same IPO.

- **The article's author has a position.** [bryanlarsen] is the only person who hints at this: "The OP knows this and wants a window to profit from this squeeze." A Substack author writing about a guaranteed mechanical squeeze is either warning you or front-running you (or both). Nobody interrogates the author's incentives.

- **What happens to price discovery when the three largest index providers all compete to accommodate a single company?** The article describes a Nasdaq problem. The thread reveals it's an industry-wide capitulation to the same pressure. That's a qualitatively different — and much scarier — phenomenon.

### Verdict

The article's thesis is substantially correct on mechanics. The thread usefully widens the lens: the problem isn't one index but the competitive dynamics between index providers (Nasdaq, S&P, FTSE Russell all proposing parallel changes), each afraid of losing relevance if they don't include the hottest IPO fast enough. The "just avoid QQQ" defense — the thread's most popular out — is weaker than its proponents think (over $1T tracks the Nasdaq-100, and cross-index selling propagates) but stronger than zero (the magnitude of price impact on individual MAG7 names from a single rebalance is genuinely uncertain). The Nortel analogy from [kmeisthax] is the right historical frame. The deeper issue the thread circles but never states clearly: the passive investing revolution outsourced governance to private index providers and assumed they'd stay honest. That assumption is now being stress-tested by the largest IPO in history, at a moment when the regulatory backstop is politically disabled.
