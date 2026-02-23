← [Index](../README.md)

## HN Thread Distillation: "Coding agents have replaced every framework I used"

**Source:** [HN thread](https://news.ycombinator.com/item?id=46923543) (375 pts, 594 comments) · [Article](https://blog.alaindichiappari.dev/p/software-engineering-is-back) · Feb 2026

**Article summary:** A solo developer argues that AI coding agents have made frameworks obsolete. Frameworks, he claims, solved three problems — "simplification" (actually intellectual surrender), automation (boilerplate), and labor cost (replaceable cogs) — and agents now handle all three better. He advocates building everything from scratch with Bash, Makefiles, and frontier models, calling this the return of "true software engineering." Evidence: his own greenfield project, built solo, over ~2 months since December 2025.

### Dominant Sentiment: Pushback with grudging partial agreement

The thread overwhelmingly rejects the article's central thesis while conceding the underlying observation. Most commenters agree agents change the economics of custom code; nearly all disagree that this makes frameworks obsolete. The ratio runs roughly 3:1 against the author, but the quality of the pro-framework arguments varies wildly — some are genuine insights, others are just "frameworks good because I said so."

### Key Insights

**1. The article's central irony undermines its own thesis**

The author rails against "intellectual surrender" — using frameworks designed by others rather than thinking for yourself — while advocating that you outsource the actual code to an AI. Multiple commenters spotted this immediately. `prophesi`: *"'Software engineers are scared of designing things themselves.' So the answer is to let AI agents design it for you, trained on the data of the giants of software engineering. Got it!"* `nova22033` pushes harder: *"How is it not 'intellectual surrender' to let the AI do the work for you?"*

The article never resolves this contradiction because it can't. The author treats "designing the architecture" and "writing the code" as cleanly separable, but decades of engineering experience say otherwise — understanding emerges from the act of building. `Ronsenshi` states it plainly: *"Anyone who writes and reviews code regularly knows very well that reading code doesn't lead to the same deep intuitive understanding of the codebase as writing same code."*

**2. The LISP Curse returns, wearing a Claude hoodie**

The sharpest structural critique comes from `panny`, who identifies this as a recurrence of the LISP Curse — the tendency for powerful tools to encourage everyone to build their own incompatible version of the same thing:

*"When everyone uses an identical API, but in different situations, you find lots of different problems that way. Your framework and its users become a sort of BORG. When one of the framework users discovers a problem, it's fixed and propagated out before it can even be a problem for the rest... You will repeat all the problems that all the other custom bespoke frameworks encountered."*

This is the strongest argument in the thread because it identifies a *mechanism*, not just a preference. Shared frameworks create network effects for bug discovery. Bespoke agent-generated code fragments that network into millions of unique snowflakes, each carrying the same latent bugs that framework communities spent years fixing.

**3. Agents are trained on frameworks — the snake eating its own tail**

Several commenters (`tayo42`, `aschla`, `falloutx`, `nickstaggs`) converge on a point the article entirely ignores: LLMs are trained predominantly on framework-using code. When you ask an agent to "build from scratch," it's reconstructing a worse version of the framework it learned from. `aschla`: *"The models are trained on code which predominantly uses frameworks, so it'll probably trend toward the average anyway and produce a variant of what already exists in frameworks."*

`zeroq` extends this into a tragedy-of-the-commons argument: if everyone stops using frameworks and the ecosystem atrophies, the training data degrades, and the agents get worse. *"If we play with the idea that the revolution is actually going to happen... then the innovation will stop as there will be no one left to add to the pool."* Self-fulfilling prophecy dynamics.

**4. The real divide is greenfield solo vs. maintained team code**

`m0llusk` names the elephant: *"This is about greenfield development which is relatively rare. Much of the time the starting point is a bunch of code using React or maybe just a lump of PHP."* The author's evidence is a single solo project built from scratch. The vast majority of professional software work is maintaining, extending, and debugging existing systems in teams. `pmontra` raises onboarding; `SCdF` raises consistency; `theonething` raises shared frame of reference. These are all the same structural argument: frameworks are coordination tools for humans working together over time.

`KronisLV` draws the practical boundary: *"The moment when someone tries to write a web server from scratch in a collaborative environment... I'm peacing the fuck out of there."*

**5. The inversion thesis: agents make frameworks MORE valuable, not less**

`notatoad` offers the most interesting counter-framing: *"The thing that an agent is really really good at is overcoming the initial load of using a new framework or library... letting the AI go from scratch invariably produces code that I don't want to work with myself."* This is the exact opposite of the article's thesis, and it's well-argued. The friction cost of adopting a framework was always the ramp-up; agents eliminate that friction, making frameworks strictly more attractive.

`phendrenad2` adds a crucial nuance: the article's real complaint is about JavaScript's framework ecosystem specifically, which provides much less than Rails or Django. *"Next.JS is the pinnacle of JavaScript-on-the-backend frameworks, and it's kind of pathetic compared to what Rails or Django give you."* The author may have generalized a JavaScript-specific frustration into a universal claim.

**6. The correctness gap nobody can hand-wave away**

`dathinab` identifies what the article's three-problems taxonomy misses entirely: **correctness**. *"When it comes to programming most things are far more complicated in subtle annoying ways than they seem to be... a lot of the data [AI is] trained on is code which does many of these 'typical' issues wrong."* Frameworks accumulate security fixes, edge-case handling, and battle-tested correctness over years. Agent-generated code starts from zero each time. `deadbabe` drives this to absurdity: *"AI rolled cryptographic libraries now make it feasible to just roll your own crypto"* — a comment that reads as satire but lands as warning.

**7. The economics argument has legs, even if the article botches it**

`keeda` makes the strongest pro-article case by reframing it economically: *"Frameworks primarily exist to minimize boilerplate, but AI is very good at boilerplate, so the value of frameworks is diminished."* This is supported by GitClear's [2025 research](https://www.gitclear.com/ai_assistant_code_quality_2025_research) showing 4x growth in code clones and copy/paste exceeding moved code for the first time — exactly what you'd expect if code reuse (frameworks) is being replaced by regeneration (agents). Whether this is sustainable or an accumulating disaster is genuinely unknown. `keeda` is honest about this: *"I'm not claiming to say this will work out well long term."*

**8. Behavioral lock-in transfers, it doesn't disappear**

`kristopolous` brings the most intellectually interesting frame via the [einstellung effect](https://en.wikipedia.org/wiki/Einstellung_effect): the same cognitive patterns that made developers over-rely on frameworks will make them over-rely on agents. His [unfinished blog post](https://blog.day50.dev/intro/vibedrift/) argues this is a meta-dynamic of tool use, not specific to either technology. *"After solving many problems which had the same solution, subjects applied the same solution to later problems even though a simpler solution existed."* The agent becomes the new framework — the thing you reach for habitually instead of thinking.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Frameworks encode decades of battle-tested correctness | **Strong** | The article ignores this entirely; it's the hardest to counter |
| This only works for greenfield solo projects | **Strong** | Author's evidence is literally one solo project |
| LLMs are trained on framework code; you get worse frameworks | **Strong** | Structural argument the article can't address |
| "Intellectual surrender" charge applies equally to AI | **Strong** | The article's central irony |
| Frameworks are coordination/onboarding tools for teams | **Medium** | True but somewhat addressed by agent-as-documentation |
| "Just use a lightweight framework like Svelte" | **Medium** | Reasonable middle ground, dodges the core question |
| The compiler analogy (AI = higher abstraction) | **Weak** | `joe_the_user` and `13415` dismantle this — determinism matters |
| "This is just hype / AI slop" | **Misapplied** | Dismissive; the underlying economics shift is real |

### What the Thread Misses

- **The training data commons problem at scale.** Individual comments mention it, but nobody connects the dots: if the industry shifts away from shared frameworks toward bespoke generated code, the open-source ecosystem that produces training data atrophies. This is a slow-moving tragedy of the commons that won't be visible for years.

- **Team dynamics with all-agent workflows.** `pmontra` asks the right question — *"does anybody mind to share first hand experiences of projects in which every developer is using agents?"* — and gets zero answers. Nobody in the thread has actually done this at team scale. The entire debate is theoretical.

- **The security surface expansion.** `pipejosh` mentions prompt injection once, buried at the bottom. A world where every project has its own bespoke HTTP handling, auth flow, and input sanitization — instead of shared, audited framework code — is a security researcher's nightmare. Nobody in the thread engages with this seriously.

- **Who benefits from this narrative?** AI companies selling API tokens benefit enormously from developers abandoning free frameworks and regenerating equivalent functionality via paid API calls. `mbgerring` almost gets there: *"A future where you have to pay an AI hyperscaler thousands of dollars a month for access to their closed-source black box... is actually worse than this."* The thread doesn't notice the irony: the article argues for independence from Google/Meta/Vercel while advocating dependence on Anthropic/OpenAI — a lateral transfer of sovereignty, not a reclamation of it.

### Verdict

The article correctly identifies that the cost of writing custom code has collapsed. It then makes the classic blunder of confusing a change in relative cost with the elimination of all prior trade-offs. Frameworks don't just save typing — they accumulate correctness, enable team coordination, and provide the composition substrate that all bespoke code runs on top of. The "framework-free" thesis has it backwards: as AI generates more bespoke glue code, shared libraries become MORE valuable because they're the only layer where expert-validated correctness concentrates. The dependency deepens as it becomes invisible. See [LISP Curse and Bedrock](../insights.md#lisp-curse-and-bedrock).

The deeper tell is in the author's own framing: "twenty years of laying bricks" is what makes him effective at directing agents. He's spending down accumulated human capital to operate a system that, if his thesis succeeds at scale, would prevent the next generation from accumulating that same capital. The article is a retirement announcement disguised as a manifesto. See [Apprenticeship Doom Loop](../insights.md#apprenticeship-doom-loop).
