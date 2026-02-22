← [Index](../README.md)

## HN Thread Distillation: "Nvidia and OpenAI abandon unfinished $100B deal in favour of $30B investment"

**Source:** [HN](https://news.ycombinator.com/item?id=47086980) (290 points, 322 comments, 192 unique authors) · [FT article](https://www.ft.com/content/dea24046-0a73-40b2-8246-5ac7b7a54323) (paywalled) · Feb 19, 2026

**Article summary:** Nvidia is finalizing a $30B equity investment in OpenAI, replacing a complex $100B long-term framework deal agreed last year that the WSJ reported was "on ice" in January. The simpler equity cheque is part of a larger funding round raising >$100B, valuing the ChatGPT maker at $730B pre-money. The original deal's collapse and replacement with a smaller, more conventional structure signals a significant retreat from the initial scale of commitment.

### Dominant Sentiment: Gleeful bubble-watch with portfolio anxiety

The thread reads like a wake where nobody liked the deceased but everyone's worried about the estate's debts hitting their 401k. Near-universal skepticism about OpenAI's viability, with disagreement only on timing and collateral damage.

### Key Insights

**1. The Nvidia-OpenAI deal is a circular money machine, and the thread knows it**

The most common reaction is to name what the FT article politely avoids: Nvidia invests $30B in OpenAI, which promptly spends it on Nvidia hardware, inflating Nvidia's revenue, which inflates Nvidia's stock price, which funds further investments. danielovichdk puts it bluntly: *"OpenAi gets 30b, buys chips from nvidia for 30b. How is that an investment?"* vaxman goes further, arguing that *"nVidia will get into a lot of trouble for doing this kind of deal that undermines confidence in the entire stock market."* The shift from a $100B long-term commitment to a $30B equity cheque is arguably Nvidia converting a complex bet on OpenAI's future GPU purchases into a simpler financial position that looks better on their balance sheet — pure equity, not contingent on execution. The deal shrinking by 70% gets called "investment" rather than "retreat."

**2. The 2008 analogy is more apt than the thread realizes**

micik delivers the thread's star comment — a long, deliberately stylized retelling of the Lehman → money-market-fund → AIG → TARP cascade, arguing the AI capex web has the same interconnected fragility. The key insight isn't the historical parallel but the *mechanism*: in 2008, individually rational institutions were so entangled that one failure cascaded; in 2026, Nvidia, OpenAI, Oracle, Microsoft, and the DRAM suppliers are deliberately entangling themselves through cross-investments and take-or-pay contracts. micik's punchline: *"When you're 30k in debt and insolvent, it's your problem. 30mil in debt, the bank's problem. 30B? Not a problem at all, certainly nothing the Fed couldn't solve."* Oracle's $300B data center commitment to OpenAI — funded partly by debt — is the specific node that multiple commenters flag as the most fragile link.

**3. Google's victory is the thread's consensus framework — and its blind spot**

A striking number of commenters converge on the same thesis: Google wins by default because it has TPUs, cash, ad revenue, and can treat AI as an R&D cost indefinitely. surgical_fire captures the vibe: *"I really dislike Google, but it is painfully obvious they won this... they can know even more data about users to feed their ad business with. You tell LLMs things that they would never know otherwise."* stego-tech and martinald flesh out the infrastructure advantage. But the thread barely interrogates this thesis. Google's TPU cost advantage is assumed, not proven — martinald alone pushes back on the "Google makes chips in-house" narrative, noting *"in reality they're just doing more design work... there's still a lot of margin 'leaking' through Broadcom, memory suppliers and TSMC."* And the thread ignores Google's catastrophic track record of killing products, fumbling consumer software, and losing enterprise customers to companies with better go-to-market. Winning a war of attrition isn't the same as winning the market.

**4. The Anthropic cult on HN is real and nobody can explain it**

deanmoriarty names it directly: *"Really hard for me to understand why the average HN commenter has an almost cultish behavior towards Anthropic... It's a very consistent pattern."* recitedropper's reply — *"Starts with 'astro' and ends with 'turfing'"* — gets to the mechanism: Anthropic's primary market is professional developers, and HN is the highest-value forum for reaching them. The thread demonstrates this bias in real time: multiple commenters grant Anthropic a pass on the same cost-structure and moat problems they use to condemn OpenAI. tinyhouse: *"Anthropic on the other hand is very capable... the hottest tech company rn, like Google were back in the day."* The one commenter who pushes back (co_king_5: *"Anthropic and Dario Amodei are undoubtedly bigger scammers"*) gets downvoted. Whether it's astroturfing or genuine product affinity, the effect is the same: HN threads consistently undercount Anthropic's risks.

**5. RAM hoarding is the article-beneath-the-article**

The DRAM angle gets less airtime than it deserves. kasabali links to [Moore's Law Is Dead](https://www.mooreslawisdead.com/post/sam-altman-s-dirty-dram-deal), which details OpenAI's simultaneous deals with Samsung and SK Hynix for ~40% of global DRAM supply — not even finished modules, but raw wafers stockpiled in warehouses. DDR5 prices up 156%, DDR3 tripled, 13-month lead times quoted. 34679 articulates the thesis: *"I can't shake the feeling that the RAM shortage was intentionally created to serve as a sort of artificial moat by slowing or outright preventing the adoption of open weight models."* The $100B→$30B deal shift maps onto this: Nvidia's original commitment was presumably tied to infrastructure build-out that would consume those wafers. With the deal restructured, OpenAI is sitting on hoarded materials it may not have the capacity to use — but its competitors can't use them either.

**6. The retirement-account subthread reveals genuine fear**

criddell's casual question — *"Have you moved your retirement account money out of stocks?"* — spawned the thread's most candid subthread. marcyb5st: moved to sovereign debt, Roche, Novartis, CHF-denominated assets. baggachipz: shifted from 100% S&P to gold ETF and SCHD. sethops1: went from ~100% VOO down to 25%. This isn't normal HN discourse. These are people making real financial decisions based on the belief that the AI capex bubble is the single-point-of-failure for the broader market. The counterpoint from kronks — *"This is the ONE thing you aren't supposed to do as a passive investor"* — is technically correct, but the number of people ignoring standard advice signals something beyond normal market jitters.

**7. The coding tools debate has quietly shifted to "good enough"**

The thread has a secondary conversation about Gemini vs Claude Code vs Codex that's more interesting for its framing than its conclusions. dudeinhawaii's detailed account of using multiple models in sequence — Gemini for diagnosis, Codex for implementation — captures the emergent pattern: model commoditization at the product level. The sharpest comment comes from parliament32: *"Every time I've tried to use agentic coding tools it's failed so hard I'm convinced the entire concept is a bamboozle to get customers to spend more tokens."* Meanwhile, arthurcolle describes a quorum voting system across three cheap Chinese models that he claims outperforms Opus 4.6 at a fraction of the cost. If true, this is exactly the kind of commoditization dynamic that destroys premium pricing power.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Google will win by default via infrastructure + cash" | Medium | Overstates TPU cost advantage, ignores Google's product graveyard. Correct on sustainability, wrong on inevitability. |
| "OpenAI's IPO will be WeWork 2.0" | Medium | Structurally different — OpenAI has real technology, real revenue (~$5B+), and a brand. WeWork had none. The failure mode is different: not fraud but unsustainable cost structure. |
| "Open models make moats impossible" | Strong | Most credible long-term argument. GLM-5, Kimi K2.5, quorum approaches demonstrate the dynamic is real and accelerating. |
| "Government will bail out OpenAI" | Weak | burnte's rebuttal is decisive: 4,000 employees, alternatives exist, no systemic economic risk. The AI capex web ≠ the financial system. |
| "Nvidia is Enron 2.0" | Weak | Nvidia sells real products at real margins. The better comp, as tim33 notes, is Cisco — massive revenue dependent on infrastructure buildout that may not sustain. |

### What the Thread Misses

- **The deal structure shift is more revealing than the dollar amount.** A $100B long-term commitment implies Nvidia believed in sustained, growing demand from OpenAI. Replacing it with a $30B equity cheque implies Nvidia now wants upside exposure without operational entanglement. That's a risk signal disguised as a simplification.
- **Nobody asks who's funding the rest of the >$100B round.** If Nvidia's portion is $30B out of >$100B, who's writing the other $70B+ cheques and why? The round's composition would reveal whether this is strategic investment or financial engineering.
- **The DRAM hoarding and the deal restructuring may be directly connected.** If OpenAI hoarded 40% of DRAM supply but the infrastructure buildout to use it (the original $100B deal) has collapsed, OpenAI is now a speculator sitting on raw materials it can't deploy — while the broader market suffers the shortage.
- **The Harper's article linked by OP (zerosizedweasle) is itself a signal.** It's a major literary magazine running a long-form piece about the vacuousness of AI startup culture. When Harper's is writing about Cluely and sperm racing, the cultural narrative has shifted from awe to autopsy.

### Verdict

The thread correctly identifies the circular dynamics and fragility of the AI capex web but can't decide whether this is a controlled deflation or a prelude to crisis. The $100B→$30B shift is doing double duty: Nvidia gets to claim continued bullishness while dramatically reducing exposure, and OpenAI gets to claim a $730B valuation while its most important hardware partner just cut commitment by 70%. What nobody in the thread states outright: the deal restructuring is evidence that Nvidia's internal models for AI infrastructure demand have changed — and if Nvidia's models have changed, the entire capex thesis that undergirds every AI company's valuation has a crack in it. The question isn't whether the bubble pops, but whether the air leaks slowly enough for the incumbents to find real revenue before the pressure equalizes.
