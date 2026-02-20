← [Index](../README.md)

## HN Thread Distillation: "The only moat left is money?"

**Source:** [elliotbonneville.com](https://elliotbonneville.com/the-only-moat-left-is-money/) · [HN thread](https://news.ycombinator.com/item?id=47062521) (276 pts, 381 comments, Feb 2026)

**Article summary:** AI has collapsed the creation barrier, making attention—not skill—the scarce resource. The author argues that reach and capital are now the only differentiators, citing Josh Pigford's lament that building new things has never felt harder, the drowning of Show HN in AI-generated projects, and his own launch of Kith (a paid, invite-only human-only social network) that got 14 signups. The piece ends with a Kith plug.

### Dominant Sentiment: Sympathetic premise, demolished example

The thread broadly agrees that distribution is harder than ever and that AI has flooded channels with noise. But the author's own evidence—a paid invite-only social network with no content—is so poorly chosen that it undermines his thesis. The thread spends as much energy dissecting Kith's failure as engaging with the macro argument.

### Key Insights

**1. The Kith example proves nothing about AI — it proves social networks are hard**

Multiple commenters independently reach the same conclusion: a paid, invite-only social network with no existing content would have failed identically in 2005. **nickelpro**: "This seems like an incredibly niche product that only a handful of people are interested in." **sd9**: "Bootstrapping the content for a *free* social network is incredibly hard. But a paid social network where the only differentiating factor is that users are humans?" **rfw300** reduces it further: "It also strikes me as being in competition with, you know, a group chat." The author is pattern-matching his product failure onto a macro trend and getting the causation backwards.

**2. The Show HN data is real and striking**

**francisofascii** links to [actual data](https://petegoldsmith.com/2026/01/26/2026-01-26-show-hn-trends/): Show HN posts went from 3.5% to 15.3% of total HN submissions between Jan 2025 and Jan 2026 — a 125% increase in absolute volume. This is the hardest evidence in the entire thread that the noise floor has risen dramatically. Even **sebstefan**, who initially challenged the claim ("you would not be able to pinpoint when AI starts on the graph"), conceded: "Woah I stand corrected." The signal-to-noise problem isn't hypothetical.

**3. "Building was already not the bottleneck" — the thread's consensus position**

**arbuge** states it cleanly: "Building was already not the main obstacle before AI. Distribution was, and remains so — more than ever." **vadepaysa** adds the feedback loop: low engagement → less visibility → reinforced belief nothing interesting exists. **e10jc** (who sold a social network to AOL) locates the actual barrier at existing audience and relationships, not code. The article frames AI as a phase change; the experienced builders in the thread frame it as acceleration of a pre-existing dynamic.

**4. The "creativity is the moat" vs. "creativity gets cloned" debate**

Two camps talk past each other. **atomicnumber3** makes the strongest creativity-as-moat case: "The value of *unoriginal* thinking has gone down... The value of true, original human thinking has gone up." Cites Stripe's taste in developer ergonomics. **AstroBen** counters: "You know that if anything you build gets traction, it'll be cloned by 100 people, right?" **prmph** lands the best rebuttal: "So where are the AI clones of MS Office, JetBrains IDEs, Whatsapp, Obsidian, Sublime Text, Claude Code, etc. so far?" The resolution is that both are right at different layers — creativity gives first-mover advantage, but sustaining that advantage requires compounding network effects or deep domain knowledge that cloners can't replicate from the surface.

**5. ctoth's star comment: the thread is looking at ProductHunt, not the world**

The thread's best comment, by a wide margin. **ctoth** argues the entire framing is broken because it defines "software" as "web app with a landing page and MRR." Then lists a dozen underserved domains where software barely exists: agricultural control systems, CAM software ("where word processors were in 1985"), scientific instruments maintained by grad students in unmaintained Python, prosthetics, formal verification of bridges and medical devices, knowledge preservation of craft traditions. He's not theorizing — he's personally rebuilding Klatt's 1980 speech synthesis work and building open-source prosthetics software. The kill shot: "You are skipping the noticing and going straight to the building, then wondering why nobody cares." And: "Go talk to a nurse, a farmer, a building inspector, a food bank logistics coordinator. Ask them what's broken. I promise the answer isn't 'nothing' and I promise nobody on ProductHunt is solving it."

**6. Taleb's non-scalable advice attracts the strongest sub-thread**

**scoofy** opens with Taleb: do something non-scalable so you only compete locally. This generates a rich sub-debate. **laffOr** points out tailoring was already automated by the industrial revolution — the "non-scalable" version is a post-scaling remnant. **amelius** notes that even non-scalable businesses (restaurants, hotels) get captured by platforms (Uber Eats, Booking.com) that extract their margins. **thegrim33** asks the uncomfortable question: why would AI that replaces knowledge work not also operate welding robots? The sub-thread exposes a tension in the "retreat to atoms" advice — it only works if you assume automation stops at a conveniently arbitrary boundary.

**7. jppope's cleaner framing: novel things got more valuable, slop got worthless**

"Hard novel things are still hard and valuable, easy things are now super easy and really aren't valuable anymore." Distinguishes between a meal planning app (a series of prompts now) and decreasing the cost of titanium production (real science that LLMs can't handle). This is a more precise version of the article's thesis that actually holds up — it's not that money is the moat, it's that the *difficulty floor* has collapsed, and everything below it is commoditized.

**8. The article itself shows AI writing tells**

**thornewolf** catches the author silently editing a quote to remove its rhetorical structure, then notes "this article contains multiple GPT-isms." **dudewhocodes**: "To me this article reads not fully human." **kledru**: "even this one turns to AI-sh style in the end." The meta-irony is thick — an article lamenting AI slop flooding channels and devaluing human thinking appears to have been at least partially AI-written. The author doesn't deny it.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Paid social network would have failed pre-AI too | **Strong** | Thread's most unified point; author has no counter |
| Creativity/taste is the real moat | **Medium** | True for some products; ignores that most software value is mundane |
| Money isn't a moat — you can raise money (debt/equity) | **Weak** | **charcircuit** is technically right but misses that access to capital is itself unequally distributed |
| If money were the only moat, governments would dominate | **Strong** | **thoughtpeddler** invokes Coase's Theory of the Firm; empirically sound |
| "Just do non-scalable things" | **Medium** | Reasonable until you realize the automation frontier keeps advancing |

### What the Thread Misses

- **Trust, not attention, is the actual scarce resource.** The thread uses "attention" as the bottleneck, but people have plenty of attention — they spend hours scrolling. What they lack is *trust* in new things from unknown sources. Trust is intermediated by institutions, brands, and personal relationships. This reframes the problem: it's not that nobody sees your product, it's that nobody believes your product. Money buys reach but not trust; that distinction matters.

- **The slop flood may be self-correcting.** Everyone treats the current noise level as permanent or worsening. But users develop filters, platforms adjust ranking, curation tools emerge. Early web search was garbage too until PageRank. The current state is likely transient — the interesting question is what the *post-filter* landscape looks like, and who builds the filters.

- **Platform monopoly is the actual moat, not money per se.** Distribution channels (Google, Apple App Store, social media algorithms) are the real gatekeepers. Money is a proxy for access to these platforms. Nobody in the thread connects "distribution is the problem" to "a small number of companies control all distribution."

### Verdict

The article bundles two claims: (1) AI has made creation trivially easy, flooding all channels with noise, and (2) money is the only remaining moat. The thread validates the first and demolishes the second. What the thread circles but never quite states: the real crisis isn't that building is cheap — it's that the *discovery infrastructure* of the internet was never designed for abundance. Search, social feeds, app stores, and even HN were built for a world with far fewer entrants. The 125% increase in Show HN posts is a symptom of infrastructure failing to adapt, not evidence that money is king. The builders who will thrive are those who either build discovery infrastructure itself, or who — as ctoth argues — look away from the screen entirely and go find problems in the physical world that nobody on ProductHunt is solving.
