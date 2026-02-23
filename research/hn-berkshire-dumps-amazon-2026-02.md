← [Index](../README.md)

## HN Thread Distillation: "Warren Buffett dumps $1.7B of Amazon stock"

**Source:** [HN #47063950](https://news.ycombinator.com/item?id=47063950) (172 points, 181 comments) · [Finbold article](https://finbold.com/warren-buffett-dumps-1-7-billion-of-amazon-stock/) · Feb 2026

**Article summary:** Berkshire Hathaway's Q4 2025 13-F filing reveals a 77% reduction in its Amazon position (~$1.7B sold), alongside continued Apple trimming, a new NYT position ($352M), and expanded Chubb/Chevron stakes — signaling a rotation from big tech into classic value plays.

**Article critique:** The Finbold piece is SEO-optimized financial news — heavy on links to its own stock guides, light on analysis. It frames the sell-off as "returning to classic Buffett investments" without noting the capex context. It also conflates Buffett with Berkshire uncritically. Most tellingly, the article notes Berkshire built a $5.6B Google position while dumping Amazon — which directly contradicts the "retreating from tech" narrative Finbold pushes. It doesn't address this.

### Dominant Sentiment: A tech site talking like disappointed customers

nfRfqX5n makes the sharpest meta-observation in the thread: *"Interesting how most people here (a hardcore tech site) are commenting on their experience with Amazon retail."* On a story about a 13-F filing, ~70% of the energy is consumer grievance. A smaller financial camp argues the real signal is AI capex overshoot. Neither camp engages the other much. The consumer complaints are better-evidenced than they first appear; the financial thesis is more contested than its proponents admit.

### Key Insights

**1. Amazon's ad business is quietly becoming the load-bearing pillar — and nobody follows the implication**

coredog64 nails the structural point most commenters miss: *"[Retail is] now a marketplace where they use their name recognition and (alleged) consumer friendliness to collect fees from sellers. It costs to list, it costs to do FBA, and it costs to run ads so that your products appear in search results. Amazon ads is incredibly profitable."* malfist adds that 80% of search result placements are paid ads, and only 4-5 are marked "sponsored." The thread identifies these pieces but never assembles them: if retail exists primarily to generate traffic for the ad platform, then retail quality only matters insofar as it maintains traffic volume. The real question isn't "is Amazon retail getting worse?" — it's "at what point does retail degradation reduce ad impressions?" Amazon can tolerate a lot of KUFLPOW garbage before shoppers actually leave. Nobody asks where that line is.

**2. The capex story is the strongest financial thesis — but it's more contested than it looks**

whatever1 delivers the alarming framing: *"Amazon spent last year 100B in Capex. They announced they will spend 200B this year. These numbers are INSANE... They literally don't have the cash to do it."* sleepyguy reinforces: unlike Microsoft and Google, Amazon can't fund this AI infrastructure build internally. aetherson connects it to the stock: *"This is the market making a (reasonable!) judgment that it lacks confidence that Amazon's capital expenditures will pay off."*

But pgwhalen pushes back directly — Amazon is profitable at tens of billions per quarter, and asks the right question: what's the *marginal* spend? Is $200B all incremental, or does much of it replace existing capex? whatever1 concedes that previous peak capex was ~$60B (2021, supply chain doubling), putting the marginal AI spend at maybe $70-80% of the total. That's still enormous, but the "they can't afford it" framing overstates the case. The honest read: the capex is unprecedented for Amazon and the returns are uncertain, but "they literally don't have the cash" is contested in the thread itself.

**3. The seller ecosystem is in structured revolt**

ilamont provides the thread's most substantive comment — a detailed insider account of Amazon's seller-side platforms (Brand Registry, Vendor Central, Seller Central) suffering from *"crippling levels of technical debt,"* made worse by Jassy's AI-everything directive. The PPC ad platform is described as *"completely predatory, loaded with dark patterns and hidden defaults that add billions to top-line revenue while strip-mining the accounts of sellers."*

lavezzi's case study makes the structural problem concrete: a $5K fraud case where Amazon auto-approved a return after its own A-Z claim system denied the same buyer for fraud, accepted a visibly different returned item with documented serial number discrepancies, refused to participate in second-round chargeback disputes, and then stopped answering communications. *"Every dispute stage required rebuilding the fraud case from scratch. Zero continuity."* This describes a platform optimized to extract fees while externalizing all risk to sellers. bespokedevelopr pushes back on blaming AI specifically — the decline predates generative AI — but doesn't dispute the trajectory.

**4. "American AliExpress" is becoming consensus, backed by real evidence**

drstewart, amatecha, password54321, and rdtsc all converge on the same observation: Amazon's marketplace is dominated by ephemeral Chinese-all-caps brands selling commodity goods. rdtsc describes the pattern: *"Get bad reviews? Generate a new CAC name and start over. Rinse and repeat. Same product made by one factory in China sold by 100s of CAC Amazon entities."* Nicook, who worked on Brand Registry, confirms: *"The complete failure of the brand initiative cannot be overstated."*

The NBC faucet investigation provides hard evidence: Moen commissioned testing of 19 top-selling cheap foreign-made faucets on Amazon. 17 of 19 failed national drinking water standards — 11 for lead, 15 for organic compounds including carcinogens. Moen found 41 counterfeit SKUs for every 1 genuine product. CPSC issued recalls. Amazon didn't comment.

nikcub provides personal purchasing data: 215 orders in 2023, down to 27 in 2025. Anecdotal, but the 87% decline curve is striking. The counter-evidence exists though — guywithahat notes shipping speed and returns are still unmatched, lysace finds Amazon useful for specific cheap electronics, and phil21 reports generally good experiences. The picture isn't unanimous, but the weight tilts negative.

**5. AWS faces a concrete competitive mechanism the thread underexplores**

mfrye0 drops a data point that deserves more attention: *"GCP is giving out a ton of cloud credits to startups. On average $100k in comparison to $10k-20k from AWS."* Combined with: *"Before Claude Code, a full cloud migration could easily be a couple months. We migrated our whole stack to GCP in about a week."* If AI coding tools have reduced cloud migration from months to days, and GCP is 5-10x more generous on credits, that's a concrete mechanism for AWS to bleed startup market share. The thread doesn't engage with this at all, despite it being directly relevant to Amazon's financial outlook.

**6. Platform lock-in is structural, not just convenient**

JMKH42 argues modern payment integrations make buying direct nearly as seamless as Amazon. But PaulDavisThe1st pushes back: *"More and more of the specialized bits and pieces I need or want are only sold online via Amazon. Extremely depressing."* phil21 explains the mechanism — many "direct" purchases quietly route through Fulfilled by Amazon anyway, because small vendors can't match shipping costs or handle returns logistics. *"A lot of smaller shops simply don't want to deal with logistics and customer service... I absolutely understand why a small speciality manufacturer with a few dozen low volume SKUs would prefer to just use FBA and be done with it."*

The dynamic: Amazon has made itself infrastructurally essential to sellers even as it degrades the selling experience. Sellers are locked in by logistics, not by choice. This is why the "just buy direct" solution doesn't scale — the alternative infrastructure doesn't exist for most products.

**7. The loss-leader-to-monetization pipeline is Amazon's operating pattern**

xvxvx's rant about Echo becoming *"an ad machine and one bad day away from going in the trash"* spawns a subthread about whether any public company can sustain a non-degrading consumer device. evmaki frames it structurally: the cloud infrastructure burden creates a need for subscription or data collection revenue. vablings argues loss-leader devices *"should always be illegal"* because the end product is inevitably an update that degrades the experience. nozzlegear points to Apple's HomePods as counter-evidence (no ads, no subscriptions), which complicates the "structurally impossible" claim.

The pattern — sell cheap, gain adoption, monetize through degradation — recurs across Amazon's business. But the thread doesn't test how far the pattern can stretch before it breaks. genghisjahn literally threw his Echo in the trash rather than fight the recurring ad settings. At some point, enough people do that.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Berkshire, not Buffett" | Strong | True, though Q4 2025 trades fall under Buffett's final quarter as CEO |
| Retail margins are normal — 3% is industry standard | Strong | Correct, but doesn't explain why Amazon trades at 2x Walmart's market cap |
| Amazon has $123B in cash and is profitable per quarter | Strong | Genuine counterweight to the "can't afford $200B capex" framing |
| Amazon only has 8% of total US retail, room to grow | Medium | True numerically, but physical retail expansion (Fresh) has failed |
| Quality complaints are overblown — service is still good | Medium | Multiple commenters report good experiences; the thread skews negative but not unanimously |
| Amazon's ad business justifies the valuation | Medium | Plausible, but nobody quantifies whether ads can carry $200B capex |

### What the Thread Misses

- **Temu/Shein as validation, not just threat.** The thread mentions Chinese competitors but doesn't notice the paradox: if Amazon has become AliExpress, then Temu competing with Amazon means Amazon successfully moved downmarket. The real risk isn't that Temu steals customers — it's that Temu normalizes even lower quality expectations, making it structurally harder for Amazon to ever move back upmarket.

- **International divergence.** never_inline (India) describes Amazon as excellent and indispensable; Maro (UAE) reports rising return rates and defensive purchasing; European commenters note AliExpress now delivers in 10 days. The marketplace quality problem may be US-specific, tied to the particular dynamics of Chinese-to-US seller abuse. The thread treats Amazon as a monolith.

- **What Berkshire bought, not just what it sold.** The filing shows new positions in NYT and expanded Chubb/Chevron/Google. Buying Google while selling Amazon is a specific statement about which tech bets Berkshire believes in. The thread barely touches this.

- **The HN website tangent tells on HN.** A quarter of the visible thread is nostalgic amusement about Berkshire's 1990s-era HTML website. On a story about a $1.7B portfolio move, the most popular subthread is about web design. This says more about HN's priorities than about Berkshire's.

### Verdict

Two readings of this thread are possible and the distillation shouldn't pretend one is settled. The financial read: Berkshire is selling because $200B in AI capex with uncertain returns is the anti-Buffett thesis, and Amazon is the weakest-positioned of the hyperscalers to finance this race. The consumer read: Amazon's marketplace has degraded to the point where the brand is eroding — and brand erosion in a platform whose real business is advertising is an existential risk on a longer timeline than Wall Street prices in.

The thread circles both but states neither cleanly. What it really reveals is that Amazon is running a specific play — using retail as a traffic funnel for an ad business while burning cash on AI infrastructure — and the question isn't whether any single piece is failing, but whether the whole machine can keep spinning fast enough that no individual failure becomes critical. Berkshire's answer, with a 77% position cut, appears to be: probably not.
