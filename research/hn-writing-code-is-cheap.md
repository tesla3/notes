← [Index](../README.md)

## HN Thread Distillation: "Writing code is cheap now"

**Source:** [Simon Willison](https://simonwillison.net/guides/agentic-engineering-patterns/code-is-cheap/) — first chapter of an in-progress guide on "agentic engineering patterns." Core thesis: coding agents have made the act of writing code nearly free, disrupting decades of habits built around code being expensive. But "good code" remains costly. We need new personal and organizational habits.

**Thread:** [HN](https://news.ycombinator.com/item?id=47125374) · 137 comments · 99 points · Feb 23, 2026

**Article assessment:** The article makes two bundled claims: (1) writing code is now cheap, and (2) this cheapness requires new habits. Claim 1 is defensible but narrower than it sounds — what got cheaper is *typing code into an editor*, which Willison himself acknowledges was never the hard part. The article then tries to pivot to claim 2, but the "new habits" section is essentially empty: "fire off a prompt anyway" is the entire prescription. The article's own evidence (the long checklist of what makes code "good") actually undermines its headline by showing how little of the total cost was ever in the typing.

### Dominant Sentiment: Skeptical exhaustion with the premise

The thread is overwhelmingly pushback. Not hostile — just tired of the framing. The dominant response is "we've seen this movie before" (outsourcing, bootcamps, low-code). Simon engages actively and respectfully in the thread, which prevents it from becoming a pile-on, but he's clearly outnumbered.

### Key Insights

**1. The outsourcing parallel is the thread's sharpest knife — and nobody twists it far enough**

Multiple commenters (danesparza, sjaiisba, coldtea) independently reach the same analogy: cheap code generation is structurally identical to outsourcing. Writing code was *always* cheap if you dropped quality standards. What was expensive was getting it right. sjaiisba nails it: *"it's odd watching the outsourcing debate play out again. The results are gonna be the same."*

But nobody extends this to its logical conclusion: outsourcing didn't fail because the code was bad. It failed because the *communication overhead* of specifying what you wanted precisely enough for someone without domain context to execute it correctly cost more than the labor savings. LLM agents have the same problem — you're still paying the specification cost, just to a different receiver. The question isn't whether the code is cheap; it's whether the specification tax is lower with an LLM than with a human. For trivial tasks, yes. For complex domain work, the jury is very much out.

**2. "Code is liability" has become an article of faith — and it's being tested**

malfist, lkey, toprerules, and others invoke the "code is liability" frame. malfist's elaboration is the strongest: *"Even if I understand all my code, when I go to make changes, if it's 100k lines of code vs 2k lines of code, it's going to take more time and be more error prone."* Five escalating "even if I understand" clauses, each adding a real cost dimension.

mehagar pushes back: *"I would normally agree, but I think the 'code is a liability' quote assumes that humans are reading and modifying the code. If AI tools are also reading and modifying their own code, is that still true?"* This is the most interesting open question in the thread. If AI can maintain AI-written code indefinitely, the liability model inverts. But OptionOfT deflates this: AI doesn't abstract — it pattern-matches across flat codespace, so a change request can cascade unpredictably. The liability doesn't vanish; it becomes *opaque* liability, which is worse.

**3. Ronacher's "Final Bottleneck" piece is the real counterpart — not this article**

the_mitsuhiko (Armin Ronacher) links his own essay, which is substantially more interesting than the article under discussion. His frame: when one pipeline stage gets dramatically faster, the bottleneck shifts downstream. Code review, accountability, and understanding become the constraints. His OpenClaw example (2,500 open PRs) is concrete evidence of what happens when generation outpaces review capacity. His conclusion — *"I too am the bottleneck now. But two years ago, I too was the bottleneck. I was the bottleneck all along"* — is more honest and precise than Willison's "we need new habits."

The key mechanism Ronacher identifies: this isn't a habits problem, it's a *systems* problem. *"I don't think it's the habits that need to change, it's everything. From how accountability works, to how code needs to be structured, to how languages should work."*

**4. The productivity paradox is the elephant in the room**

dw_arthur asks the question nobody wants to answer: *"it's funny that so many people are using AI and still hasn't really shown up in productivity numbers or product quality yet."* crystal_revenge's response is revealing — they describe *potential* projects, *theoretical* revenue, future agencies that *could* work. Every verb is conditional. The most concrete example Simon offers is OpenClaw's timeline to Super Bowl ad, and when fmbb pushes on whether it's *good* software, Simon explicitly says quality is "beside the point." That's a remarkable concession from someone whose article's second section is titled "Good code still has a cost."

fragmede makes a meta-observation worth noting: *"we as an industry have yet to agree on anything approaching a scientific measure of productivity."* The productivity debate is unfalsifiable because there's no agreed metric. ShowHN frequency is offered semi-seriously as the best available proxy.

**5. The "typing was never hard" camp is right — but Simon's counter-move is underappreciated**

stackghost states the standard objection: *"The act of actually typing the code into an editor was never the hard or valuable part of software engineering."* Simon's reply is precise: *"It wasn't the hard or valuable part of software engineering, but it was a very time-consuming part."* This distinction matters — something can be easy but slow, and making it fast changes economics even if it was never intellectually hard. rhubarbtree adds the practitioner's perspective: *"often see cope from managers along the line of 'writing the code was never the bottleneck'. Well, sure felt like it."*

The thread doesn't resolve this because both sides are partly right. The typing was time-consuming, and making it fast does change *some* economics. But the hard-part camp is correct that the savings ceiling is lower than the hype implies, because typing was maybe 20-30% of total effort, not 80%.

**6. The AI art parallel is the thread's best analogy**

torginus: *"generating pictures has gotten ridiculously easy and simple, yet producing art that is meaningful or wanted by anyone has gotten only mildly easier. Despite the explosion of AI art, the amount of meaningful art in the world is increased only by a tiny amount."* This maps precisely: the supply of code has exploded, but the supply of *good software that solves real problems* has not proportionally increased. mentalgear extends this into consumer goods: code is becoming like fast fashion — *"cheap but not quality; all made for quick turn-overs to rake in more profit and generate more waste but none made to last long."*

**7. TacticalCoder drops the Cloudflare data point and nobody picks it up**

*"If we look at a company like Cloudflare who basically didn't have any serious outage for five years then had five serious outages in six months since they drank the AI kool-aid, we kinda have a first data point on how amazing AI is from a maintenance point of view."* Whether this is causal or coincidental, it's the closest thing to empirical evidence in the entire thread, and nobody interrogates it. If true, it's a devastating counter-example. If false, it should be debunked. The thread just scrolls past.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Typing was never the bottleneck" | Strong | Correct but incomplete — Simon's "time-consuming ≠ hard" distinction has merit |
| "This is just outsourcing again" | Strong | Structurally sound analogy; communication overhead is the underexplored mechanism |
| "Code is liability, not asset" | Strong | Well-argued by malfist; the open question is whether AI-maintained code changes the calculus |
| "Where are the productivity numbers?" | Strong | Nobody has a convincing answer; crystal_revenge's response is all conditionals |
| "Claude Cowork was built in 2 weeks" | Weak | sjaiisba: *"the humans I know that have used it are all aware of how buggy it is. It feels like it was made in 2 weeks"* |
| "VC raises prove value" | Weak | toomuchtodo demolishes this: *"A raise is random noise, not signal"* with citations |

### What the Thread Misses

- **The specification cost displacement.** Everyone debates whether *writing* code is cheaper. Nobody rigorously examines whether the total cost of *specifying intent precisely enough to get correct output* is actually lower with LLMs than traditional methods for non-trivial work. The prompt engineering tax is real and unmeasured.

- **Selection effects in testimonials.** The people loudest about AI productivity gains are disproportionately building AI-adjacent tools, writing about AI, or selling AI services. crystal_revenge's "two person agency" and SignalStackDev's agent infrastructure are both AI-meta-products. bwestergard asks for examples and gets... Claude Code's ARR and a list of AI startups. *"If we were on the verge of rapid economic growth, I would expect HN commenters to be able to rattle these off by the dozen."* Where are the testimonials from people using AI to build, say, better accounting software?

- **The junior developer pipeline.** alex-nt raises this obliquely — if AI handles the trial-and-error learning that used to build domain knowledge, how do juniors develop expertise? Ronsenshi asks where CS grads will work. But nobody connects these: if you eliminate the apprenticeship path while the senior engineers who can review AI output age out, you create a competence cliff in 5-10 years.

### Verdict

The thread circles a truth it never quite articulates: "writing code is cheap" is a *category error* masquerading as an insight. Code was never a product — it was always an intermediate artifact in the production of *working software*. Saying code is cheap is like saying lumber is cheap when you're trying to build a house that passes inspection. The lumber was never the expensive part; the architecture, plumbing, electrical, and inspection were. What's actually happened is that one input cost dropped while all the surrounding costs — review, testing, specification, maintenance, understanding — stayed the same or increased. The net effect is real but much smaller than the headline implies, and the thread instinctively knows this even as it struggles to articulate exactly why.
