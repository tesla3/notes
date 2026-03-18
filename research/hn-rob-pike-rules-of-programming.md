← [Index](../README.md)

# HN Thread Distillation: "Rob Pike's Rules of Programming (1989)"

**Source:** [HN thread](https://news.ycombinator.com/item?id=47423647) · 554 points · 306 comments · 2026-03-18
**Article:** A bare-bones HTML page hosting Pike's 5 rules — performance-centric maxims about measuring before optimizing, preferring simple algorithms, and letting data structures drive design. The page attributes Rules 1–2 to Hoare's "premature optimization" maxim (misattribution — it's Knuth), Rules 3–4 to KISS/brute-force, and Rule 5 to Fred Brooks.

### Dominant Sentiment: Fierce agreement on Rule 5, trench warfare on Rules 1–2

The thread is a referendum on one question: has "premature optimization is the root of all evil" done more harm than good? Most commenters agree on the answer (yes, misuse has been catastrophic) while disagreeing about the mechanism. Meanwhile, Rule 5 ("data dominates") is treated as gospel by virtually everyone, with experience level correlating perfectly with enthusiasm for it.

### Key Insights

**1. The thread's real debate is about Rules 1–2, and both sides are making the same error**

The "premature optimization has destroyed software" camp (led by `anymouse123456`'s top-voted screed about Google nightmares) and the "the quote is fine, people are just lazy" camp (`globular-toast`: "I don't think you can blame this phrase if people are going to drop an entire word out of an eight word sentence") are arguing past each other. Both assume the quote *drives* behavior. It doesn't. As `BoneShard` nails it: "Software is slow or bloated because of budget, deadlines, and skill levels — not because of a quote." And `pjc50`: "Slow code is more of a project management problem. Features are important and visible on the roadmap. Performance usually isn't." The quote is post-hoc rationalization for decisions already made by project economics. Nobody at a standup says "Knuth told me to ship this O(n²) loop."

**2. Rule 5 is the thread's consensus masterclass — and the one most undermined by LLMs**

Near-universal agreement that data structures are the foundation: `TYPE_FASTER` ("If I have learned one thing in my 30-40 years spent writing code, it is this"), `vishnugupta` (used DB schema reviews as due diligence shortcut for acquisitions), `BTAQA` ("Once the schema was right the queries became obvious"). But the sharpest observation comes from `ta20211004_1`: "Claude is much more likely to suggest or expand complex control flow logic on small data types than it is to recognize and implement an opportunity to encapsulate ideas in composable chunks." Reinforced by `bfivyvysj`: "The data structures [from AI] are incredibly naive... no amount of context management will help you, it is fighting against the literal mean." And `jerf` observing that you have to *explicitly ask* AI for data-structure-first design — its defaults are mediocre because the training data is mediocre. This is the thread's most important insight for 2026: Rule 5 is the rule AI is worst at, precisely because it requires domain judgment that can't be pattern-matched from GitHub.

**3. "Premature abstraction" may be the real villain, not premature optimization**

`ryguz` (top comment): "In practice what I see fail most often is not premature optimization but premature abstraction. People build elaborate indirection layers for flexibility they never need." This reframing gets strong support. `sph` proposes applying DRY only on the third occurrence. `tikhonj` pushes back with a more nuanced frame: deduplication should follow *conceptual identity*, not textual similarity — "If two instances of the same logic represent the same concept, they should be shared. If 10 instances of the same logic represent unrelated concepts, they should be duplicated." This is the thread's sharpest engineering insight and it transcends both the DRY zealots and the WET advocates.

**4. Pike's rules are really one rule with four corollaries**

`ryguz` again: "If you genuinely accept that you cannot predict where the bottleneck is [Rule 1], then writing straightforward code and measuring becomes the only rational strategy." The thread recognizes the rules are deeply overlapping. `dasil003` suggests inverting the order — put Rule 5 first because it's the most timeless. `dkarl` argues Pike's formulations are *better* than the famous quotes they reference because they preserve context the aphorisms lost. The meta-observation: Pike compressed an engineering philosophy into five statements; the internet has spent decades arguing about the decompressed fragments in isolation.

**5. The Knuth attribution correction is now a genre unto itself**

`DaleBiagio` and `kleiba` both flag that the "premature optimization" quote is Knuth's (1974, "Structured Programming with go to Statements"), not Hoare's. Knuth later attributed it to Hoare; Hoare denied it and suggested Dijkstra. `YesThatTom2`: "If Dijkstra blamed Knuth it would have been the best recursive joke ever." The thread correctly notes the full quote includes "Yet we should not pass up our opportunities in that critical 3%," which is almost always omitted. `Someone` even catches that Knuth was writing about PL/I-style pseudocode, not C as `anymouse123456` claimed.

**6. Rule 3 has a dangerous failure mode nobody in the thread fully resolves**

`fl0ki`: "They use an algorithm that's indeed faster for small n, which doesn't matter because anything was going to be fast enough for small n, meanwhile their algorithm is so slow for large n that it ends up becoming a production crisis." `GuB-42` takes this further: "If you can't tell in advance what is performance critical, then consider everything to be performance critical" — the exact opposite conclusion from the same premise. The thread circles this tension without resolving it. The answer (which `koliber` gets closest to) is that Rule 3 is about *implementation tactics*, not *design choices*: pick data structures that scale (Rule 5), but don't hand-tune algorithm constants until you measure (Rule 2).

**7. The AI angle is revealing: people are adding Pike's rules to their AGENTS.md**

`tobwen`: "Added to AGENTS.md :)" — `andxor` (sarcastically): "Great gonna add these to my CLAUDE.md /s". `andsoitis` notes Pike is "deeply hostile to generative AI," citing the Christmas 2025 incident and his "nuclear waste" label for GenAI. The irony is thick: the thread discussing 1989 programming wisdom is bookended by people hoping to upload it into the very systems Pike considers antithetical to his philosophy. `sph` on using AI for data structure design: "AI is terrible for this. My recommendation is to truly learn a functional language."

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Rules 1–2 only apply to novel systems; experienced devs know bottlenecks" (`CharlieDigital`) | Medium | True for CRUD-in-a-domain-you-know; fails for genuinely new systems. `pydry` counters hard: "The number 1 issue I've experienced with poor programmers is a belief that they're special snowflakes who can anticipate the future." |
| "Rule 3 is dangerous — n eventually gets big" (`fl0ki`, `GuB-42`) | Strong | Legitimate failure mode. The rule needs the qualifier "for implementation, not architecture." |
| "Profiling never made it into the core dev loop" (`twoodfin`) | Strong | Undermines Rule 2's practicality. If teams don't profile, "measure first" is aspirational, not operational. |
| "antirez: there are no rules, only taste" | Medium | True at the top of the skill curve; dangerous advice for the median developer who is the target audience for rules. |

### What the Thread Misses

- **The economic incentive structure.** Nobody asks *who pays for optimization*. In most orgs, shipping features is rewarded; performance work is invisible until crisis. The quote isn't the cause of bloat — the incentive gradient is. Pike's rules assume a craftsperson with agency; most developers are operating under product management that treats performance as a cost center.
- **Rule 5 applied to distributed systems.** The thread treats "data dominates" as a single-process insight. In microservices architectures, the *shape of data at service boundaries* (schemas, contracts, event formats) dominates even more — and is even harder to get right because it requires cross-team coordination. `zer00eyz` gestures at this but nobody develops it.
- **The measurement tooling gap.** `twoodfin` flags that profiling isn't in CI/CD pipelines, but nobody asks why. The answer is that profiling is context-dependent, noisy, and hard to automate meaningfully — which means Rule 2 has an infrastructure prerequisite that most teams haven't met.

### Verdict

The thread performs a familiar HN ritual: relitigating a famous quote while actually agreeing on the substance. The real signal is the convergence on Rule 5 as the only rule that matters at every level — and the emergent recognition that LLMs are systematically bad at exactly this rule. Pike's rules were written for humans who over-engineer; the 2026 addendum should be that AI under-engineers data structures by default, producing code that is simple in the way Pike never intended — structurally naive, not structurally elegant. The thread circles this but never states it plainly: the era of "data dominates" is becoming the era of "data dominates and your AI assistant doesn't care."
