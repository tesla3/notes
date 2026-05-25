# HN Thread Distillation: "Nobody Gets Promoted for Simplicity"

Source: https://news.ycombinator.com/item?id=47246110 (394 comments, 671 points)
Article: https://terriblesoftware.org/2026/03/03/nobody-gets-promoted-for-simplicity/
Date: 2026-03-04

**Article summary:** Argues that engineering incentive structures — interviews, design reviews, promotions — systematically reward complexity over simplicity. Engineer B who builds a pub/sub system gets a Staff+ promotion packet; Engineer A who ships 50 clean lines gets "Implemented feature X." Offers advice for engineers (make simplicity visible, document what you *didn't* build) and leaders (put the burden of proof on complexity, celebrate code deletion).

### Dominant Sentiment: Cathartic agreement, with experienced dissent

The thread overwhelmingly validates the thesis — this is a "finally someone said it" post. But the most interesting signal comes from the minority who push back, because they reveal the conditions under which simplicity *does* get rewarded: smaller companies, business-facing roles, and teams where the manager actually ships alongside the engineers.

### Key Insights

**1. The FAANG smoking gun: impact doesn't matter, complexity does**

The thread's star comment, from `__turbobrew__`: spent 3 weeks optimizing a core service and reduced 2x the opex costs of a 20-engineer, 3-year infrastructure migration. Manager acknowledged the impact but said he needed to "solve more complex problems" to reach Staff. This isn't a hypothetical — it's the thesis proven in a single anecdote. The promotion system explicitly selected against a 100x-more-efficient outcome because it wasn't *hard enough*.

**2. Simplicity bears the burden of proof; complexity doesn't**

`fer` nails the structural asymmetry: "The simple solution is generally the one with the most tradeoffs to explain: why no HA, why no queuing, why no horizontally scalable..." The complex solution just exists and looks thorough by default. Defending simplicity means surviving an interrogation about everything you *chose not to build*, while the overengineered version faces no equivalent scrutiny. This is the mechanism that makes the problem self-perpetuating — it's not just that complexity is rewarded, it's that simplicity is penalized with cross-examination.

**3. Switch from evaluating output to evaluating input**

`klabb3` offers the thread's most actionable reframe: "If we want to reward simplicity we have to switch reference frame from output (the solution) to input (the problem)." To a bystander, a complex solution is proof of a complex problem. A simple solution looks like the problem was easy. The fix isn't better narrative-writing — it's changing *what* gets evaluated. Judge the difficulty of the problem, not the impressiveness of the artifact. This is the structural intervention the article gestures at but never names.

**4. The hiring pipeline creates a complexity ratchet**

`SurvivorForge` identifies a second-order feedback loop the article misses entirely: teams with simple stacks have fewer "impressive" resume bullet points, making it harder to recruit senior engineers who want "interesting" technology. So complexity is self-reinforcing through talent acquisition — management rewards it, and the hiring funnel selects for engineers who want to produce more of it. This is a genuine trap, not just a cultural preference.

**5. "Deleted lines" culture exists but is exceedingly rare**

`bluemario`: "Simplicity accrues value slowly and diffusely, while complexity delivers visible credit immediately." The orgs where this works had explicit "deleted lines" culture where removing code was celebrated as loudly as shipping features. `kolja005` reports refactoring microservices into a monolith — possible only because the pain was visible to everyone. The pattern: simplicity gets rewarded only when the cost of complexity has already been felt, never preemptively.

**6. The "simplicity" that's actually coupling in disguise**

`mrkeen` delivers the sharpest counterargument: "$100 says the 'clean, simple' approach is the one which directly couples the frontend to the backend to the database." When "simple" means no test harnesses, no interfaces, no separation — you get code that's easy to write once and impossible to change. This is a real failure mode. The thread's simplicity advocates rarely distinguish between *essential simplicity* (solving the right problem with minimal mechanism) and *lazy simplicity* (skipping architecture because YAGNI feels good). `mrkeen` is right that the article provides zero code samples or concrete criteria, making "simplicity" as vague as the "impact" metrics it criticizes.

**7. The survivorship bias of firefighting**

`aristofun` names it cleanly: "problem prevented is ignored, while problem solved is appreciated regardless of who and why caused it." `strickjb9` links a 2013 blog post about two teams — one constantly huddling and firefighting, one quiet and leaving on time. Guess which looks more impressive from the outside. The dynamic hasn't changed in 13 years. `nopurpose` extends this to PR reviews: suggesting simpler approaches causes friction because the complex work is already done and tested. The simplicity advocate pays a social cost with zero credit.

**8. The experienced contrarians reveal the boundary conditions**

`d--b`: "People don't give a shit about complexity or simplicity. They care about: does it work, how soon can you ship." `misja111`: "In an environment driven by business stakeholders, the engineer who ships quickly will be greatly appreciated." `phito`: "I keep reading this online but never encounter it in real life." `andoando`: "Your job is to deliver value." These aren't wrong — they're describing a *different environment*. The pattern is consistent: the simplicity penalty is strongest where engineering is separated from business outcomes by layers of middle management. In small companies, startups, and business-facing roles, output speed is visible enough that simplicity rewards itself. The article universalizes a specifically big-company pathology.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Simple" often means tightly-coupled, untestable code | **Strong** | mrkeen's point — article provides no criteria for distinguishing good simplicity from lazy simplicity |
| Simplicity wins at smaller companies / business-facing roles | **Strong** | Multiple commenters report the opposite experience; the thesis is org-size-dependent |
| Engineers who ship fast can just stack more bullet points | **Medium** | jppope's point — 3-4 simple wins vs 1 complex one. But saulpw correctly notes simple solutions often take *longer* to design |
| Just write better promo narratives | **Weak** | The article's own advice. Doesn't fix the structural asymmetry fer describes |
| AI will make this worse / better | **Speculative** | flashybaby says AI-driven simplification threatens headcount; dzonga says AI produces complex code. Both plausible, neither tested |

### What the Thread Misses

- **The manager's own incentive structure is never examined.** Managers get promoted for leading large, complex projects with big teams. A manager whose reports keep things simple has a smaller empire and fewer impressive narratives of their own. The problem isn't just that managers fail to reward simplicity — they're *structurally disincentivized* from doing so. Several commenters (`gip`, `anarticle`) brush against this but nobody follows it to its conclusion.

- **No one asks why "simplicity" advice is so popular yet nothing changes.** This exact article gets written every 6 months and hits the HN front page every time. The thread itself links to a 2013 blog post making the same point and a 1985 parable. If the diagnosis were actionable, 40 years of repeating it would have moved the needle. The persistence suggests the incentive structure is *load-bearing* — complexity isn't a bug in the promotion system, it's a feature that serves organizational legibility and manager career paths.

- **The testing question is dodged.** `mrkeen`'s challenge — that "future-proofing" often means "making things testable" — gets no serious engagement. The thread treats all abstraction as premature, but the line between unnecessary complexity and necessary architecture is exactly where the real engineering judgment lives.

### Verdict

The thread confirms a real phenomenon but misdiagnoses its cause. This isn't primarily a narrative problem (engineers not writing good promo packets) or a cultural problem (managers not celebrating simplicity). It's a *legibility* problem: organizations can only reward what they can see and measure, and complexity is inherently more legible than its absence. `__turbobrew__`'s anecdote is the proof — even when the *impact* was measured and acknowledged, it wasn't enough because the *work* didn't look sufficiently impressive. The real lesson isn't "make simplicity visible" — it's that in organizations above a certain size, the evaluation system *cannot* see simplicity, and no amount of narrative reframing will fix a structural blindness. The 40-year recurrence of this exact essay is itself the strongest evidence that the advice doesn't work.
