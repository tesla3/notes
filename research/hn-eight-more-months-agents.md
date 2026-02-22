← [Index](../README.md)

## HN Thread Distillation: "Eight more months of agents"

**Source:** [crawshaw.io/blog/eight-more-months-of-agents](https://crawshaw.io/blog/eight-more-months-of-agents) · [HN thread](https://news.ycombinator.com/item?id=46933223) (241 comments, 223 points, Feb 2026)

**Article summary:** David Crawshaw (Sketch/exe.dev founder) updates his agent-programming experience: models now write 90% of his code (up from 25% a year ago), IDEs are dead (he's back on neovim), only frontier models are worth using, built-in sandboxes are broken, and "the best software for an agent is whatever is best for a programmer." Plugs his product exe.dev twice.

### Dominant Sentiment: Skeptical pushback from the trenches

The thread splits sharply between builders who share Crawshaw's enthusiasm and working engineers who see the claims as detached from organizational reality. The skeptics are better-armed with specifics.

### Key Insights

**1. "Where are all the new houses?" — the process bottleneck nobody can agent away**

The thread's most devastating line comes from entropyneur: *"Where are all the new houses? Surely a 10x increase in the industry output would be noticeable to anyone?"* This gets reinforced with concrete evidence. gbuk2013: *"My last several tickets were HITL coding with AI for several hours and then waiting 1-2 days while the code worked its way through PR and CI/CD process."* And dent9 provides the thread's best anecdote: an LLM wrote the correct AWS CLI + GitHub Actions syntax in 1 minute, but the actual task — getting IAM permissions and S3 bucket policies adjusted — took 4.9 days out of a 5-day process. *"AI reduced this from a 5-day process to a 4.9-day process."*

The dynamic here: agent productivity gains are real but they're accelerating the part of the workflow that was already fast. The actual bottlenecks — approvals, organizational process, CI/CD, security review — are untouched. Crawshaw's 90% claim may be accurate for *his* startup where he controls the entire pipeline, but it's structurally non-transferable to most engineering orgs.

**2. The $170 taste gap**

amarble ran exactly the experiment Crawshaw's article implies should work: autonomous agentic coding (Claude Code / Opus 4.6) on a Google Docs clone, 8 hours, $170 in tokens. The result: *"Abstractly impressive, completely useless, and I see no pathway for it to become useful with more effort."* Scrolling is wrong. Tables can't be resized. Bullet points don't work. No account management.

The key insight from amarble's write-up: compilers and browsers have detailed behavioral specs, which is why the Anthropic/Cursor demos work. UX-driven products require *taste* — something no amount of spec-writing or prompt-engineering substitutes for. This directly undermines Crawshaw's "I implemented Stripe Sigma by typing three sentences" claim: querying your own data via SQLite is spec-tractable work. Building products people want to use is not.

**3. "You must use the tool that will replace you" — the psychological bind**

girvo names the dynamic most clearly: *"I'm baffled why people are surprised that senior+ engineers who are being told in one breath they will be replaced by this tool and also they MUST use this tool to make it better to replace them aren't happy about it."* And then: *"I'm forced to yes. It's tracked."*

This isn't anti-technology sentiment. It's a rational response to a genuine double bind. estimator7292: *"When the tag line is 'this will replace senior engineers and you, the senior engineer, must be forced to use it' — then yeah, it makes sense."* The thread reveals that "anti-LLM" engineers aren't Luddites — they're people correctly reading the incentive structure.

**4. Crawshaw's joy reads as tone-deafness**

overgard delivers the thread's sharpest structural argument via thought experiment: *"CEO has a team of 8 engineers... they discover engineers are 2x more effective. What does the CEO do? (a) 4-hour workdays, or (b) fire half the engineers?"* He notes Steve Yegge's *Vibe Coding* book naively assumes workers capture the productivity surplus — something no historical precedent supports.

webdevver puts a number on it: *"There is a step-change around the $500k mark where you reach 'orbital velocity'... basically everyone in tech is openly or quietly aiming to get there, and LLMs have made that trek ever more precarious."* ulagud draws the 18th-century parallel: *"Imagine the smugness of some 18th century 'CEO' telling an artisan, despite the fact that he'll be resigned to working in horrific conditions at a factory, to not worry and think of all the mass produced consumer goods."*

Crawshaw writing "I wish I could share this joy" from the position of a startup founder building the picks-and-shovels product is a structural blindspot, not a personal failing.

**5. The API-first future has adversarial dynamics baked in**

dmk identifies the buried thesis: *"If every user has an agent that can write code against your product, your API docs become your actual product."* anthuswilliams is enthusiastic — less dark-pattern scope, more consumer ownership.

But pjc50 lands the counter: *"There's less profit in it. This will make the market more adversarial, not less."* And 13pixels extends this to its logical endpoint: *"It's basically SEO all over again but worse, because the attack surface is the user's own decision-making proxy."* Prompt injection on e-commerce sites manipulating your agent's vendor selection. A trust layer between agents and services becomes necessary — but nobody's building it.

The thread identifies a real dynamic: the API-first world simultaneously empowers users and creates a new attack surface that's harder to defend than the current one.

**6. Tribal knowledge scales inversely with team size**

zerotolerance makes the thread's most underappreciated observation: agents *"are really great at bespoke personal flows that build up a TON of almost personal tribal knowledge... Doing this in larger theaters is much more difficult because tribal knowledge is death for larger teams."*

This explains why solo developers and tiny startups (like Crawshaw) report euphoria while larger organizations see modest gains. Agents accelerate the accumulation of implicit knowledge that makes codebases opaque. For one person, that's fine — it's all in your head anyway. For a 50-person team, it's a maintainability disaster. The agents are optimizing for the individual at the expense of the organization.

**7. The harness is where reliability lives, but everyone's looking at the model**

Crawshaw says harnesses "have not improved much" and it's "all about the model." The thread pushes back hard. tiny-automates: *"The harness being '9 lines of code' is deceptive in the same way a web server is 'just accept connections and serve files.' The real harness innovation is going to be in structured state checkpointing so the agent can backtrack to the last known-good state."* kevmo314 counters that the Claude Code harness *is* the differentiator: *"Prior to 4.6, the main reason Opus 4.5 felt like it improved over months was the harness."*

This is a classic attribution error: improvements in scaffolding get credited to the model because users can't distinguish the two.

**8. Bot accusations as trust erosion canary**

sarchertech accuses gip of being an OpenAI shill, then *uses ChatGPT 5.2 to generate the forensic analysis of why the comment reads like product placement*. The analysis is good — brand-name density, credential + astonishment combo, zero friction/downsides. gip insists they're human and offers a phone call.

The meta-irony is thick: AI discourse is now so polluted with AI-generated enthusiasm that genuine enthusiasm gets flagged as astroturf, and AI itself is used to make the accusation. loveparade estimates *"probably around 10% of comments on HN at this point"* are bots. Whether that's accurate doesn't matter — the perception is corrosive.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Coding speed was never the bottleneck | **Strong** | Multiple concrete examples (CI/CD waits, IAM tickets). Structural, not anecdotal. |
| Power tools analogy is bad | **Strong** | habinero: "Writing code has never been the limiting factor." Copyright, education, labor displacement have no carpentry analog. |
| Workers won't capture the surplus | **Strong** | No historical precedent for it. overgard's thought experiment is simple and unanswerable. |
| Anti-LLM seniors are Luddites | **Weak** | Thread reveals they're reading incentive structures correctly, not rejecting technology. |
| IDEs are dead | **Medium** | conartist6 (IDE author): "AI showed us current IDEs underserve needs, but it didn't solve the problem." piokoch: what IDE feature is actually obsolete? jFriedensreich notes the agent≠CLI framing is confused. |
| 95% of AI pilots fail (panny) | **Misapplied** | The MIT report is about enterprise AI broadly, not coding agents specifically. Different failure modes. |

### What the Thread Misses

- **The selection effect in testimonials.** Crawshaw is building and selling agent infrastructure (exe.dev, Sketch). Every person enthusiastically reporting 10x gains is, almost by definition, someone whose work was already spec-tractable and individually controlled. Nobody reports "agents saved my distributed team 3% on a legacy monolith migration" because that story doesn't go viral.

- **The cost curve question.** Crawshaw says "pay through the nose for Opus." amarble spent $170 on a single experiment that produced nothing usable. Nobody in the thread asks: what's the actual $/hour of agent-assisted development compared to a human developer, accounting for supervision, rework, and the cost of the frontier model? The economics are assumed, never examined.

- **Quality degradation at the population level.** Multiple commenters worry about vibe-coded slop, but nobody connects this to the *incentive* for agents to produce code that looks right to a non-expert reviewer. If 90% of code is model-generated and human-reviewed, the review becomes the bottleneck — and review quality degrades exactly when code volume spikes. This is the factory farming of software.

### Verdict

Crawshaw's article is a founder testimonial dressed as an industry assessment. His claims are probably accurate for his specific situation — solo/small-team, greenfield, spec-tractable work, own-your-own-pipeline. The thread systematically dismantles the generalizability of that experience. The most important signal isn't any single argument but the *shape* of the disagreement: people who control their entire workflow are ecstatic; people embedded in organizations see marginal gains eaten by unchanged process bottlenecks. The article never grapples with this because Crawshaw literally cannot see it from where he sits. The thread's deepest unspoken insight is that agents may be widening the gap between indie developers and organizational engineers — making the former more productive and the latter more replaceable.
