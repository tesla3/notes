← [Index](../README.md)

## HN Thread Distillation: "OpenAI resets spending expectations, from $1.4T to $600B"

**Source:** [CNBC, Feb 2026](https://www.cnbc.com/2026/02/20/openai-resets-spend-expectations-targets-around-600-billion-by-2030.html) · [HN thread](https://news.ycombinator.com/item?id=47140623) (166 comments, 193 points)

**Article summary:** OpenAI is telling investors it now targets ~$600B total compute spend by 2030, down from the $1.4T figure Altman touted in late 2025. The company projects $280B revenue by 2030, roughly equal consumer/enterprise split. A $100B+ funding round is in progress (Nvidia ~$30B, SoftBank, Amazon), pre-money valuation $730B. 2025 actual revenue was $13.1B (beat $10B target), burn $8B (beat $9B target). ChatGPT at 900M weekly actives, Codex at 1.5M (though free until March).

### Dominant Sentiment: Incredulity masking genuine uncertainty

The thread is overwhelmingly skeptical, but the skepticism splits into two camps that don't quite realize they're making different arguments: one says the numbers are fiction (bubble/Ponzi framing), the other says the technology is real but the business model can't capture the value. The second camp is more interesting and gets less airtime.

### Key Insights

**1. The timeline confusion is doing real work for OpenAI**

Saig6 quietly corrects that the $1.4T figure was over 8 years (by 2034), not 4. So $600B by 2030 is roughly on-track for the first half of the original projection, not a 57% cut. The CNBC headline frames it as a retreat; the math doesn't clearly support that. chasd00 initially panics about broken commitments, then edits to acknowledge this. This matters because the "they're backing down" narrative is the main thread through the article and the HN discussion — but it may be mostly a framing artifact. OpenAI benefits either way: if spun as prudence, it calms spooked investors; if spun as ambition, the original $1.4T still stands.

**2. The circular economy is the thread's strongest structural insight**

Betelbuddy names it, AtheistOfFail crystallizes it: *"Nvidia gives money to OpenAI so they can buy GPUs that don't exist yet with memory that doesn't exist yet so they can plug them into their datacenters that don't exist yet powered by infrastructure that doesn't exist yet so they can all make profit that is mathematically impossible at this point."* The Bloomberg circular deals graphic (cited but paywalled) apparently maps these flows. Nvidia investing $30B into OpenAI, which then buys Nvidia hardware, is a closed loop that inflates revenue figures for both companies without net new economic activity entering the system. This is the dynamic that actually matters — not whether the number is $600B or $1.4T.

**3. The anecdote-data gap on AI productivity is now measurable — and enormous**

tibbar shares a compelling Cursor story: typed a feature request into Slack, agent implemented it correctly, ready to merge. But nemooperans counters with METR's randomized controlled trial (July 2025): experienced open-source developers were 19% *slower* with AI assistance, yet self-reported being 24% *faster* — a ~40 point perception gap. The METR study used frontier models (Claude 3.5/3.7 Sonnet via Cursor Pro) on real issues in repos developers had years of experience with. The study carefully notes it doesn't prove AI is universally bad, but the perception-reality gap is the finding that should terrify anyone building revenue projections on productivity gains. tibbar's response — accusing nemooperans of being AI-generated — is an ironic dodge that sidesteps the data entirely.

**4. The "who buys the stuff" paradox has no answer**

ryandvm poses the cleanest version of the consumption problem: if AI wipes out 2/3 of jobs, who's the customer? The responses split into (a) handwavy post-scarcity philosophy (famouswaffles: "if you had a genie that could grant every wish, what would you need money for?"), (b) UBI as cope (kylehotchkiss: "UBI is a convenient trick to suppress the part of our conscious that tells us wiping out 2/3 of jobs is Bad"), and (c) flat denial that it'll happen. oceanplexian lands the sharpest counter: *"The things a magic AI Genie will never be able to give you: Land, Energy, Precious Metals, Political and Social Capital."* Nobody engages with the most obvious resolution: AI probably won't eliminate 2/3 of jobs, and the companies claiming it will are doing so to justify their valuations. The prophecy exists to sell the product.

**5. The moat question is settled — and that's the real problem for $280B revenue**

ralusek traces the arc cleanly: GPT-3.5/4 dominance → Claude/Gemini catch-up → DeepSeek moment → competitive commodity market. Key insight: *"Because the interface for all of these models is just plain language, the cost of switching models is basically non-existent."* anizan supports this with OpenRouter data showing ChatGPT 5.2 at #16 by usage, though MeetingsBrowser rightly pushes back that OpenRouter traffic isn't representative (ChatGPT has 100x more Google Trends interest). Still, the commoditization trajectory is clear. btown names the residual moat accurately: *"nobody ever got fired for buying IBM."* Enterprise inertia is real but doesn't justify $280B.

**6. The profitability question remains deliberately unanswerable**

JohnMakin and tibbar have the thread's most substantive exchange. JohnMakin: they're projecting $600B spend on $13B revenue, QED. tibbar: if they stopped research and just monetized current models, they'd be profitable. zippothrowaway cuts through: *"The only 'all indications' are that they say so. Compare against how much it actually costs to rent a rack of B200s from Microsoft."* The thread correctly identifies that OpenAI has structured itself so that research costs and inference costs are permanently blurred — a feature, not a bug, for fundraising purposes.

**7. Energy costs are already socializing AI's externalities**

0cf8612b2e1e drops a concrete data point: energy capacity pricing has jumped from $28/MWh/day to $300/MWh/day. carefree-bob connects this to local government capture: jurisdictions want data center tax revenue and will "screw over their constituents." This is the most under-discussed dynamic in the entire AI infrastructure debate — the costs are being distributed while the profits are being concentrated.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "$280B revenue is fantasy math" | Strong | paxys: would make OpenAI top-4 tech company by revenue on 1300% growth from $20B |
| "It's a circular economy / Ponzi" | Medium | Structurally correct about Nvidia↔OpenAI flows, but "Ponzi" is imprecise — it's more like capex inflation |
| "No moat, commodity market" | Strong | ralusek's analysis is well-argued and supported by market data |
| "The METR study proves AI doesn't help" | Misapplied | Study is specifically about experienced devs on familiar codebases; real value may be in unfamiliar code or junior devs |
| "Bubble, same as South Sea Company" | Weak | Historical analogies are unfalsifiable vibes; the actual infrastructure being built is real, the question is utilization |

### What the Thread Misses

- **The customer concentration risk.** If 900M ChatGPT users are mostly free-tier, and Codex's 1.5M users are on a free preview, OpenAI's actual paying customer count is probably shockingly small. Nobody does this math.
- **The API pricing death spiral.** As models commoditize, API prices collapse (already happening). OpenAI's revenue growth has to come from volume outpacing price compression — but they're simultaneously pitching "AI agents that do everything," which means fewer, larger, more price-sensitive enterprise customers, not more consumer subscriptions.
- **Microsoft's option value.** Nobody discusses that Microsoft has the ability to walk away or renegotiate at any point. Azure's AI revenue is real regardless of OpenAI's fate. Microsoft is the adult in the room who benefits whether OpenAI succeeds or fails.
- **The METR study's real implication.** If the perception-reality gap holds broadly, then the entire "3x productivity" narrative driving enterprise adoption is built on vibes. Enterprise buyers will eventually measure, and that's when the churn starts.

### Verdict

The thread circles around the right question — are these numbers real? — but never quite states the mechanism that makes them not-real. It's not that AI is fake, or that the technology doesn't work. It's that OpenAI is pricing itself as though it will be a monopoly extracting rents from a transformed economy, while simultaneously existing in a market with zero switching costs, falling prices, and open-source competitors that keep closing the gap within months. The $600B number isn't a spending plan; it's a valuation narrative. The revision from $1.4T isn't a retreat — it's a recalibration of exactly how much fiction the market will still absorb. The real tell is buried in the article: Nvidia investing $30B into OpenAI, which will spend much of that buying Nvidia hardware. That's not an economy; that's a balance sheet performance.
