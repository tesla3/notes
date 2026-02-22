← [Index](../README.md)

## HN Thread Distillation: "How I use Claude Code: Separation of planning and execution"

**Source:** [HN thread](https://news.ycombinator.com/item?id=47106686) (262 pts, 154 comments) | [Article](https://boristane.com/blog/how-i-use-claude-code/) by Boris Tane | 2026-02-21

**Article summary:** Boris Tane describes a 9-month-refined Claude Code workflow built on one principle: never let the LLM write code until you've reviewed and approved a written plan. The pipeline is Research → Plan → Annotate (repeat 1-6x) → Todo List → Implement. The key mechanism is an "annotation cycle" where the human edits inline notes directly into a plan.md file, sends Claude back to address them, and repeats until satisfied. Implementation becomes "boring" mechanical execution of a locked-down spec. He advocates single long sessions, emphatic language ("deeply", "intricacies") to prevent skimming, and persistent markdown artifacts over Claude's built-in plan mode.

### Dominant Sentiment: Convergent validation with mild fatigue

The thread is overwhelmingly supportive but carries a distinct undertone of "we all arrived here independently." Multiple experienced users describe near-identical workflows, and the mild irritation isn't at the advice—it's at the framing as novel. The real energy is in two subthreads: (1) whether this overhead is justified vs. just coding, and (2) whether emphatic prompting is engineering or astrology.

### Key Insights

**1. Independent convergence reveals a phase transition in AI-assisted development methodology**

The most striking pattern isn't any single comment—it's how many people independently arrived at the same workflow. `brandall10` has a more elaborate version with specs/plans/working-memory files and separate planner/implementer skills. `zitrusfrucht` uses ticket-based variants. `deevus` uses superpowers with Socratic brainstorming. `skybrian` is "up to about 40 design docs" on one project. `RHSeeger` assumed everyone already does this. The convergence is so strong that `bluegatty` calls it "conventional CC use" and `dnautics` says it's "literally reinventing claude's planning mode, but with more steps."

This isn't groupthink. These are people with different tools (Claude Code, Codex, Cursor, OpenCode, ChatGPT web), different models, and different project types, all landing on the same core loop: plan in a persistent document → human annotates → iterate → execute. When independent practitioners converge on a pattern without coordinating, the pattern is likely load-bearing.

**2. The "just code it yourself" objection reveals a productivity measurement gap, not a skill gap**

`jamesmcq` fires the sharpest dissent: *"for anyone with even a moderate amount of experience as a developer all this planning and checking and prompting and orchestrating is far more work than just writing the code yourself."* This spawns the thread's most heated exchange.

`shepherdjerred` counters with a concrete case: audit logging feature, 5-10 min planning + 20-30 min Claude execution vs. 1-2 days manually, while running 4-5 other tasks in parallel. `jamesmcq` pushes back on quality: *"The code might 'work', but it's not good for anything more than trivial."* This exchange never resolves because the two sides are measuring different things—wall-clock throughput vs. architectural correctness—and neither acknowledges the other's metric.

The interesting move is `skydhash`'s: *"I think those two days would have been filled with research, comparing alternatives, questions like 'can we extract this feature from framework X?'... Jumping on coding was done before LLMs, but it usually hurts the long term viability of the project."* This reframes the debate: the plan-then-execute workflow may be faster at producing code but it compresses (or eliminates) the exploratory thinking that prevents architectural debt. Nobody engages with this.

**3. "Maintainable for whom?" is the thread's most underexplored question**

`cowlby` drops the thread's most provocative idea: *"the aha moment for me was what's maintainable by AI vs by me by hand are on different realms. So maintainable has to evolve from good human design patterns to good AI patterns."* When `girvo` pushes back—"How do you square that with the idea that all the code still has to be reviewed by humans?"—`cowlby` doubles down with a semiconductor analogy: *"maybe it's that we won't be reviewing by hand anymore? I.e. it's LLMs all the way down."*

This is the thread's most important tension and it gets almost zero engagement. The entire planning workflow described in the article assumes a human architect reviewing everything. If "AI-maintainable" code diverges from "human-readable" code, the annotation cycle becomes a translation bottleneck rather than a quality gate. `cowlby` is the only person willing to follow this logic to its conclusion, and the conclusion is uncomfortable: the planning-first workflow may be a transitional pattern, not an endpoint.

**4. Emphatic prompting: superstition or steering mechanism?**

`haolez` triggers a rich subthread by questioning why words like "deeply" would affect LLM output. The explanations fracture:

- **Attention-steering** (`nostrademons`): emphatic words pull toward the part of the training corpus where experts corrected others with deep analysis. *"You want the model to use the code in the correction, not the one in the original StackOverflow question."*
- **Latent-space navigation** (`hashmap`): *"leaning on language that places that ball deep in a region that you want to be makes it less likely that those distortions will kick it out of the basin"*
- **Tool-use triggering** (`ChadNauseam`): "deeply" prompts the model to actually call the `read` tool more times, generating more thinking tokens.
- **Pure superstition** (`FuckButtons`): *"no better than claiming that sacrificing your first born will please the sun god... you could actually prove it, it's an optimization problem, but no one has been terribly forthcoming with that"*

`scuff3d` goes further: *"This is becoming the engineering equivalent of astrology."* `FuckButtons` makes the strongest methodological point—this is empirically testable and nobody has published rigorous results. The practitioners don't seem to care; they've pattern-matched enough positive outcomes to keep doing it. The field is currently in a pre-scientific phase where folklore outpaces measurement.

**5. The token economics are creating workflow stratification**

`imron` provides the most candid cost narrative: bounced off AI tools a year ago, upgraded from base plan → 5x → 20x ($200/month), and only at the 20x tier did the workflow become viable for real work. *"Spending more has forced me to figure out how to use more."* He now runs 5-6 projects in parallel with planning workflows, each implementing while he plans the next.

`brandall10` tells the opposite story: dropped $100/month Claude Code, moved to $20 Codex + $20 Gemini, gets better results with leaner context management. *"Roughly 4/5 PRs are without issue, which is flipped against what I experienced with CC."*

The dynamic: planning-heavy workflows are token-expensive (research.md, plan.md, annotation cycles, long sessions). Users are stratifying into (a) high-spend/high-autonomy on premium tiers and (b) context-optimization/model-shopping on budget tiers. Both claim superior results. The actual differentiator is probably codebase complexity and user skill, not the model.

**6. "This is just how senior engineers already work"—and that's the real insight**

`turingsroot` makes the thread's clearest meta-observation: *"this isn't a new workflow invented for AI—it's how good senior engineers already work. You read the code deeply, write a design doc, get buy-in, then implement. The AI just makes the implementation phase dramatically faster."* The corollary: *"people who struggle most with AI coding tools are often junior devs who never developed the habit of planning before coding."*

This reframes the entire article. The "separation of planning and execution" isn't an AI technique—it's the design-doc discipline that distinguishes senior from junior engineers, now made legible because the execution step is automated. The annotation cycle is just code review on a spec instead of code review on a PR. The AI didn't create a new workflow; it made the old one's value proposition undeniable.

**7. Persistent artifacts beat conversation for a structural reason**

The article's insistence on markdown files over Claude's built-in plan mode gets broad agreement but for a reason the article undersells. `renewiltord` names it: *"The plan document and todo are an artifact of context size limits. I use them too because it allows using /reset and then continuing."* The plan survives context compaction; chat history doesn't.

`cadamsdotcom` extends this with the best practical advice in the thread: write scripts that enforce invariants, put them in pre-commit hooks, and *"your agent won't be able to commit without all your scripts succeeding."* This is strictly better than the article's approach of manually watching for violations. The plan-as-document pattern is valuable, but the article stops one step short of making it machine-enforced rather than human-policed.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "More work than just coding" (`jamesmcq`) | Medium | Valid for small/well-understood changes; ignores parallelism and the long tail of complex features |
| "This is just built-in plan mode" (`bluegatty`, `dnautics`) | Weak-Medium | Misses inline annotation capability; `dack` correctly notes you can't annotate inline in plan mode |
| "Emphatic prompting is superstition" (`FuckButtons`, `scuff3d`) | Strong | Methodologically correct that nobody has published rigorous benchmarks; pragmatically irrelevant to practitioners |
| "No mention of tests" (`zmmmmm`) | Strong | Genuine gap in the article; several commenters note tests should be integral to the plan, not afterthought |
| "Big-bang implementation is risky" (`zmmmmm`) | Medium | Fair concern; `girvo` independently arrived at phased implementation to avoid this |

### Spam/Astroturf

`ramoz` posted the same Plannotator link 4 times in the thread. `CGamesPlay` called it out: *"4 times in one thread, please stop spamming this link."* `alexmorgan26`'s comment promoting dozy.site reads as AI-generated product placement; `dimgl` and `rob` flagged it immediately.

### What the Thread Misses

- **The annotation cycle's scaling limit.** The workflow assumes one human annotator. What happens when this is a team of 5? The article's markdown-file approach has no merge semantics, no access control, no structured disagreement resolution. `dennisjoseph` gestures at this but plugs a product rather than analyzing it.
- **Selection bias in success stories.** Every commenter describing success is working on their own projects or small teams. Nobody describes making this work in a large org with existing review processes, CI/CD pipelines, and compliance requirements. The workflow may be a solo/small-team pattern that doesn't survive organizational friction.
- **The plan quality depends entirely on the human's architecture skill.** The workflow offloads execution but concentrates all architectural judgment in the annotator. If the annotator makes bad calls, the plan locks in those bad calls with high confidence. The annotation cycle amplifies both good and bad judgment equally.
- **Compounding technical debt from "boring" implementation.** The article celebrates implementation being "mechanical, not creative." But mechanical execution of a plan that didn't anticipate an edge case produces confident, well-structured code that is confidently wrong. The absence of implementation-time creativity means fewer "wait, this doesn't feel right" moments that experienced developers rely on.

### Verdict

The thread validates planning-first AI development as a convergent, load-bearing pattern—not because any individual's workflow is novel, but because so many practitioners arrived at it independently across different tools and contexts. The deeper story the thread circles but never states: **this workflow is the formalization of tacit senior-engineering knowledge, and the AI's role is less "revolutionary tool" than "forcing function that makes design discipline economically obvious."** The engineers who already planned before coding gained a 5-10x execution multiplier overnight. The ones who didn't are now learning to plan—not because AI taught them, but because AI made the cost of not planning unbearable. The uncomfortable question `cowlby` raises—whether human-readable code even remains the goal—is the one that would actually change the workflow, and nobody wants to engage with it yet.
