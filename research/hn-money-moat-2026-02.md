← [Index](../README.md)

## HN Thread Distillation: "The only moat left is money?"

**Source:** [HN thread](https://news.ycombinator.com/item?id=47062521) (276 points, 381 comments) | [Article](https://elliotbonneville.com/the-only-moat-left-is-money/) by elliotbnvl | Feb 2026

**Article summary:** Author argues that AI has collapsed the cost of creation to near-zero, making attention the new scarce resource. Since reach requires money or years of accumulated audience, money is now "the only moat left." He launched Kith, a paid invite-only human-verified social network, got 14 signups, and extrapolated this into an existential crisis for all new builders. The post ends with a waitlist link for Kith.

### Dominant Sentiment: Sympathetic to the symptom, hostile to the diagnosis

The thread broadly accepts that supply-side flooding is real — Show HN submissions doubled YoY (+125%, per petegoldsmith's data) and attention is fragmenting. But the claim that "money is the only moat" gets demolished from multiple angles. The article's weak evidence (a paid invite-only social network failing to gain traction) and detectable AI-isms undercut the author's credibility as a voice on this exact topic.

### Key Insights

**1. The article's evidence undermines its own thesis**

The author's concrete example — Kith, a paid, invite-only social network with no content visible without joining — would have struggled in any era. Multiple commenters (sd9, charcircuit, nickelpro) independently reached this conclusion. As sd9 put it: "This would not have worked 20 years ago either. Bootstrapping the content for a *free* social network is incredibly hard. But a paid social network where the only differentiating factor is that users are humans, and there is no activity in the network?" rfw300 added the shiv: "It also strikes me as being in competition with, you know, a group chat." The article bundles a product-market-fit failure with a macro-trend observation and treats the former as evidence for the latter.

**2. "Money is a moat" is definitionally wrong, and the thread knows its Porter**

yodon gave the sharpest correction: money isn't a moat because you can always acquire it — debt, equity, reinvested profits. If the only barrier to competition is capital, competitors will calculate the payback period and enter. derf_ offered the classic test: "If someone gave you a billion dollars, could you go compete with that business and have a reasonable chance of winning?" If yes, no moat. charcircuit reinforced: "Money is not a moat since you can buy money (debt) or sell equity for money." thoughtpeddler brought in Coase's Theory of the Firm: if money alone were decisive, governments would control all economic activity. The author conflated *money as a resource* (true, useful) with *money as a structural barrier* (wrong, by business strategy 101).

**3. Taleb's "do non-scalable things" emerged as the thread's dominant framework**

The top comment (scoofy) channeled Taleb's *Incerto*: "If you are going to do something for a living, make sure it is NOT scalable." The logic: non-scalable work constrains your competition to your local market, not the global pool of well-funded geniuses. This generated the most productive sub-thread. Interesting pushbacks: laffOr noted tailoring *was* scaled (the industrial revolution), so any "non-scalable" label is temporal; iamgopal flagged welding automation advancing fast; amelius pointed to Uber Eats commoditizing restaurants. The framework held up surprisingly well to stress-testing, though the thread underexplored how AI specifically threatens the non-scalable boundary (nerdsniper's xTool laser welders being a rare concrete example).

**4. The real debate: is creativity durable or instantly clonable?**

Two camps talked past each other. atomicnumber3 argued passionately that *original* thinking is going up in value — citing Stripe's developer ergonomics as taste-wins-markets. AstroBen kept replying: "You know that if anything you build gets traction, it'll be cloned by 100 people, right?" prmph offered the strongest counterpoint to the cloning fear: "So where are the AI clones of MS Office, JetBrains IDEs, Whatsapp, Obsidian, Sublime Text, Claude Code, etc. so far?" — which went unanswered. The shared fallacy: both camps treat "creativity" as monolithic. Creativity-as-feature (a novel UI twist) is trivially clonable. Creativity-as-sustained-judgment (accumulated taste across thousands of decisions in a complex system) is not. Neither camp articulated this distinction.

**5. The attention flood is real and quantified**

francisofascii linked petegoldsmith's Show HN analysis: submissions went from ~1,727 in Jan 2025 to ~3,886 in Jan 2026 — a 125% increase, with Show HN rising from 7% to 15% of all submissions. vadepaysa described the resulting dynamic: "People are flooded by new projects and assume (rightly) that most are low-signal, so they don't engage. Because there's low engagement, new projects get even less visibility. That reinforces the belief that nothing interesting can be built anymore." This is a classic lemon-market dynamic — quality signal degrades when noise increases, causing good actors to exit or underinvest, further degrading quality. The thread identified the symptom but not the mechanism.

**6. ctoth's comment is the star — and the thread's conscience**

One comment stood vastly above the rest. ctoth rejected the entire frame by listing domains where software is desperately needed but nobody's building: agricultural control systems, CAM software ("where word processors were in 1985"), scientific instruments maintained by grad students in unmaintained Python, prosthetics with enormous software gaps, governance tools, formal verification for critical infrastructure. The key line: "You are skipping the noticing and going straight to the building, then wondering why nobody cares." This reframes the problem entirely — it's not that there's nothing left to build, it's that the builder demographic is staring at ProductHunt instead of talking to nurses, farmers, and building inspectors. PG's own essays ("Make something people want") get cited against his own community's behavior.

**7. The meta-irony the thread partially caught**

Multiple commenters (dudewhocodes, kledru, thornewolf) noted the article reads as partly AI-generated. thornewolf caught the author silently rewording a quote to remove its rhetorical structure. elliotbnvl acknowledged and fixed it. boxedemp offered the nuanced read: people are absorbing LLM prose patterns from constant exposure. Either way — an article lamenting that AI has destroyed the value of creation, which itself shows signs of AI-assisted creation, is the kind of self-undermining the author should have caught.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Money isn't a moat by any standard definition (Porter, Coase) | **Strong** | Multiple independently argued, author conflates resource with structural barrier |
| Kith would have failed in any era — bad product-market fit | **Strong** | Paid invite-only social network with no visible content is not an AI-era problem |
| Creativity/taste is the real moat | **Medium** | True for sustained judgment, weak for individual features that get cloned |
| "Just do hard things" — the bar rose, it didn't disappear | **Medium** | jppope's framing (novel things gained value, slop lost it) is clean but underestimates distribution barriers |
| This is just the latest boom cycle, same as web 1.0/crypto | **Weak-Medium** | Directionally right but dismisses the 125% Show HN increase and pace of change |
| Heavy taxation is the fix | **Weak** | SilverElfin, amelius — structurally irrelevant to the builder's immediate problem |

### What the Thread Misses

- **Agent-to-agent commerce.** xyzsparetimexyz and maccam912 briefly touched on AI agents as consumers/advertisers, but nobody developed this. If AI agents start doing procurement, the entire "human eyeballs are scarce" framework inverts — you'd optimize for machine-readable value signals, not human attention. Centigonal's observation about enterprise vendors already tailoring docs for AI recommendations is the leading edge of this.

- **The lemon-market mechanism.** The thread describes the attention flood but doesn't name the economic dynamic: Akerlof's market for lemons. When buyers (users) can't distinguish quality from noise, they discount everything. Good producers exit. Average quality drops further. The fix is credible signaling — but nobody asked what a credible signal looks like in a post-AI market (certifications? audited codebases? human-verified provenance?).

- **Distribution as infrastructure, not marketing.** Everyone treats distribution as a post-build problem. Nobody discussed building distribution *into* the product — products that are inherently viral, that create data others depend on, that integrate into existing workflows so deeply they become load-bearing. The thread's framing is "build then market" vs. the more interesting question of "what products are their own distribution?"

- **The author's actual position.** elliotbnvl is a novelist and software engineer (~12 years in). He admitted in comments that novel-writing feels pointless now too, that he's "AI hysterical," and that he gave up on a previous SaaS after 3 weeks. soulchild37's response — "took me about 6 years of showing up every day to have a job-replacing income" — exposes a calibration gap the thread circled but was too polite to name directly.

### Verdict

The article diagnosed a real symptom (attention scarcity accelerating) and prescribed the wrong cause (money as moat). The thread corrected the diagnosis but mostly stopped at "creativity" or "hard things" as the alternative moat without examining whether those hold up under AI-accelerated cloning at scale. What the thread circles but never states: the actual moat is *problem selection* — the ability to notice what's broken in domains you have access to, which requires physical presence, domain relationships, and the patience to do unglamorous work in unglamorous industries. ctoth said it explicitly but the thread treated it as an inspiring rant rather than the operative answer. The deepest irony is that a community founded on "make something people want" spent 381 comments debating moats in the abstract while the concrete answer — go talk to a farmer, a nurse, a building inspector — sat right there in the thread, largely unengaged.
