← [Index](../README.md)

## HN Thread Distillation: "My spicy take on vibe coding for PMs"

**Source:** [HN thread](https://news.ycombinator.com/item?id=47240736) (42 pts, 41 comments) · [Article](https://www.ddmckinnon.com/2026/02/11/my-%f0%9f%8c%b6-take-on-vibe-coding-for-pms/) · 2026-03-03

**Article summary:** A Meta PM argues that PMs shouldn't land production diffs at Meta-scale companies — it's low-leverage snacking that creates tech debt and games metrics. PMs *should* code for prototyping, understanding systems, running experiments, and fun. Separately links a more substantive piece on PMs writing GenAI evals as the real high-leverage contribution.

### Dominant Sentiment: PM role is dying, nobody's mourning

The thread rapidly abandons the article's narrow framing ("should PMs land prod diffs?") and converges on the bigger question: does the PM role survive at all? Notably, the author — a 10-year PM — agrees it probably doesn't.

### Key Insights

**1. The article's evidence undermines its own thesis**

The post bundles two claims: (a) PMs landing prod code at big companies is wasteful, and (b) PMs should still code for prototyping/empathy/fun. Claim (a) is well-argued and the thread validates it hard. But claim (b) is weaker than presented — if the dedicated PM role is merging into engineering (which the author concedes in comments), then "PMs should code for empathy" is a transitional platitude, not a durable strategy. The real message buried in the post is the linked evals article, which describes the *one* high-leverage PM activity that doesn't overlap with what engineers already do.

**2. Meta's PM-coding push is creating measurable organizational damage**

The top comment (anonymous, claiming large-company experience) describes the ground truth the article was written against: PMs landing diffs, engineers forced to code-review work they can't maintain, metrics gamed into "lines of code, commits, and tickets closed." The author confirms: "I work at Meta and posted a version of this internally in response to the bizarre pressure and support for PMs landing prod diffs." This isn't hypothetical — it's an active cultural fight inside Meta, and the article is a sanitized version of an internal pushback that apparently landed well. **purrcat259** proposes the cleanest fix: "only merge PRs from folks who are on the on-call rota." Simple, incentive-aligned, and cuts through the status games.

**3. The role convergence is directional — and PMs lose**

The thread's most substantive exchange is between **ef2k** ("the dedicated PM role is becoming optional") and **perrylaj**, who delivers the sharpest comment: "Coding was never the most valuable skill a software engineer contributed. Socially-capable engineers are going to be far more likely than PMs to 'shine' when agents can write code." The argument: PMs existed largely to provide *cover* (time) for engineers who were irreplaceable in the development process. When AI eliminates the coding bottleneck, engineers can engage directly with customers and stakeholders — doing the PM job better because they understand feasibility natively. The PM becomes the intermediary being disintermediated. The author agrees: "all PMs will need to get onto the engineering, design, or research ladder."

**4. Context-switching cost is the real constraint, not skill**

**cmdoptesc** provides the thread's best reality check: they've actually done the combined PM+eng role, conducting customer interviews, writing PRDs, iterating with design, *and* implementing features. "This would be fine if I was a founding engineer, but I'm not and wasn't being compensated enough for the extra workload." **coffeefirst** echoes: "I can do it all… but that's far too much work and context switching for one person." This challenges the "roles will merge" consensus — the separation of PM and eng may be less about skill boundaries and more about cognitive bandwidth. AI shrinks the coding portion but doesn't shrink the meetings, the stakeholder management, or the context switches.

**5. "Empathy not artifacts" is the framework the thread converges on**

**SurvivorForge** crystallizes it: "The most valuable thing a PM can get from vibe coding isn't the code — it's empathy for engineering constraints… The worst outcome is a PM who vibe-codes a prototype and then treats it as a production baseline." **munchbunny** adds the mechanism: "the models falter in the last mile, and the last mile is where you need the training and experience." The thread broadly agrees that PMs coding for understanding is good; PMs coding for production is organizational debt with a PM's salary as the interest rate.

**6. The startup/bigco split makes "PM" two different jobs**

**jackyli02** makes the cleanest distinction: "In startups anything goes. PMs and engs do whatever it takes to ship… In a place like Meta or Amazon, sudden productivity bumps or norm changes can drop overall productivity." The article's advice is explicitly scoped to Meta-scale but the title doesn't say that, which creates a thread full of people arguing past each other. **bg24** identifies the overlooked corollary: technical PMs are now in a great position to *start companies*, since AI lowers the coding barrier that previously blocked them. This is the real unlock — not PMs coding inside big companies, but PMs leaving them.

**7. The "fun" motte-and-bailey**

**Ronsenshi** makes a sharp observation: "AI evangelists really love to use the word 'fun' to describe anything they do with AI… it's always something absurdly trivial followed by 'and it's just fun!'" **slopinthebag** names the rhetorical move: "a common motte & bailey tactic — when your defence of the utility of something fails you can just say you do it for *fun!!!!!!!*." The author's article literally ends its "why PMs should code" list with "Fun!!!!!" — five exclamation marks. Ronsenshi's comparison to gambling ("vibe coding feels like playing slots") is the more honest frame for what's actually happening when non-engineers interact with AI code generation.

**8. "Intuition as evals" — domain expertise is the surviving skill**

**shay_ker** offers the thread's most forward-looking frame: "Whoever gets the business best (and in detail) will likely be the best builders. It's 'intuition as evals' that really matters." This connects to the author's linked evals article, which is genuinely more substantive than the main post. The evals piece argues that PMs should skip PRDs and write evaluation criteria directly — breaking problems into measurable atomic components and letting engineering hillclimb the metrics. This is a concrete, non-obvious workflow that actually leverages PM domain knowledge. The thread mostly ignores it (**ambicapter** is the lone commenter who notices), which is itself telling.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Engineers can absorb PM function entirely | Strong | perrylaj's argument that engineering cover was the PM's real value is well-reasoned |
| Context-switching makes merged roles impractical | Strong | cmdoptesc speaks from direct experience; the cognitive load argument survives AI automation |
| AI makes engineering skill obsolete, PMs win | Weak/Satirical | maplethorpe's take was probably sarcasm (thread split on whether it was); author's response was the most useful: "maybe shows you haven't built anything complicated" |
| The PM role is already dead | Medium | Multiple commenters assert this but none cite concrete org changes beyond anecdote |

### What the Thread Misses

- **The evals article is the actual contribution and nobody engages with it.** The main article is generic advice; the linked evals piece describes a genuinely novel PM workflow (write evals, not PRDs) that could redefine the PM function rather than eliminate it. Only one commenter noticed.
- **Nobody asks who owns the AI agents.** If coding is increasingly agent-mediated, the question isn't "should PMs code" but "who configures, evaluates, and manages the agents that code." This is a new role that maps to neither traditional PM nor traditional eng.
- **The compensation angle is invisible.** cmdoptesc briefly mentions not being paid enough for a merged role, but nobody explores the structural incentive: companies want to merge PM+eng to eliminate headcount, not to create better-paid hybrid roles. The "roles converge" narrative is suspiciously aligned with cost-cutting.
- **No discussion of what happens to the PM pipeline.** If PMs need to "get onto the engineering, design, or research ladder" (the author's own advice), the MBA-to-PM career path that feeds Meta, Google, etc. is broken. Nobody asks where the next generation of product thinkers comes from.

### Verdict

The thread circles a conclusion it never quite states: the PM role isn't dying because AI can code — it's dying because the *information asymmetry* that justified a dedicated translator between business and engineering is collapsing. When engineers can engage directly with customers and stakeholders (because AI handles the code), and when domain experts can write evals directly (because AI handles the implementation), the PM-as-middleman has no structural moat. The author seems to know this — a 10-year PM agreeing their role should vanish is either unusual self-awareness or a leading indicator. The irony is that the author's best work (the evals piece) points toward what could save the function: PMs as *evaluation architects* rather than *feature intermediaries*. But nobody in the thread — including the author — follows that thread to its conclusion.
