← [Index](../README.md)

## HN Thread Distillation: "What AI coding costs you"

**Source:** [tomwojcik.com](https://tomwojcik.com/posts/2026-02-15/finding-the-right-amount-of-ai/) · [HN thread](https://news.ycombinator.com/item?id=47194847) (299 pts, 178 comments, Feb 2026)

**Article summary:** A long, well-sourced essay arguing that AI coding tools impose hidden cognitive costs — skill atrophy, "cognitive debt," seniority pipeline collapse, loss of creative flow — that don't show up in velocity dashboards. Anchors on the Shen-Tamkin 2026 study (17% lower conceptual understanding in AI-assisted devs) and Margaret-Anne Storey's "cognitive debt" framework. Position: AI is valuable but the right amount is far from maximum; developers who stop writing code lose the ability to review it.

### Dominant Sentiment: Anxious agreement, fatalistic undertone

The thread is overwhelmingly sympathetic to the thesis. What's notable is not the agreement but the *resignation*: most commenters who validate the concerns also concede they'll keep using the tools anyway. The handful of dissenters fall into two camps — "this is the assembly→FORTRAN transition" optimists and "we don't have enough data" skeptics — and both get pushed back on hard.

### Key Insights

**1. The review paradox is felt, not just theorized**

Multiple commenters report firsthand what the article describes abstractly. `Vexs`, working at an "AI-forward" company, gives the thread's sharpest testimony: *"I have no idea how these APIs feel, their models, etc. If I want to interact with them, I ask Claude how I do a thing with the library it made. ... It doesn't matter if I get it to explain it, that's just information that washes off when I move onto the next thing. The reflexive memory isn't built."* This is the most honest description of the mechanism — it's not that you can't read the AI's output, it's that passive comprehension doesn't encode the same way active construction does. `jmux` from embedded systems corroborates: the hardest bugs require connecting patterns across the codebase, and that connective tissue only forms through hands-on work.

**2. The Shen-Tamkin study is being over-cited — and the most important finding is being ignored**

`logicprog` delivers the thread's most substantive intellectual contribution by actually reading the study carefully: the task was *learning a new library*, not maintaining existing skills — it measures "skill formation, not skill practice, maintenance, or deterioration." More critically, within the AI group, developers who asked the AI to *explain* its code and *answer conceptual questions* scored among the highest overall. The differentiator wasn't AI use vs. non-use — it was passive delegation vs. active interrogation. The article acknowledges this in its conclusion but buries it under six sections of alarm. The thread mostly ignores `logicprog`'s correction, which tells you the anxiety is doing more motivational work than the evidence.

**3. The "FORTRAN transition" analogy keeps failing**

`googamooga` offers the thread's most forceful optimist argument: learning LSI-11 opcodes → FORTRAN → modern languages involved letting old skills atrophy, and nobody regrets it. `bwestergard` dismantles this cleanly: each transition was between *formal languages* where you can logically verify that a change produces the intended outcome. The shift to natural-language prompting breaks that chain — you can't prove your English prompt will compile to the behavior you want. `ip26` adds: *"All programming languages, whether machine code or python, have always been a precise language for describing the desired computation. Working with an AI agent means specifying what you want in English, which is not precise."* The FORTRAN analogy would work if LLMs were deterministic compilers. They aren't.

**4. Management is creating a compliance theater doom loop**

`9dev`, an engineering lead, gives a remarkably candid window into the manager's dilemma: *"I just cannot ignore AI as a development tool. There is no good justification I can give the rest of the company for why we would not incorporate AI tools."* But the responses expose the trap. `throwaway346434` reframes retention costs as the real ROI calculation — forced AI adoption burns out devs, replacement cycles eat the productivity gains. `wrs` names the deeper pattern: this is the same logic leaders have always used to eliminate learning time, mentoring, and exploration — *"These developers are all going to work somewhere else in a few years, so why should we invest in growing their skills?"* — just turbocharged. `ksenzee` identifies the demographic split: devs who love seeing products emerge are fine; devs who love the *process* of solving are watching their job become something they never signed up for. Managers who can't distinguish these two populations will lose the latter to trades and competing industries.

**5. The addiction dynamic is under-discussed**

The article's author admits *"I'm addicted to prompting, I get high from it"* — and `mold_aid` correctly calls this out as the essay's most revealing and under-examined line. `YesBox` quotes `daxfohl`'s earlier HN comment on AI "complacency": the gravitational pull of the model's latent space makes it easier to accept its direction than fight for yours, producing something *"very akin to doom scrolling. Doom tabbing?"* This maps precisely to the article's own "dark flow" concept from Rachel Thomas — the slot-machine trance of low-effort, high-output work. Several commenters describe the same feedback loop: velocity feels good → you stop fighting the AI's decisions → you lose ownership → you feel hollow → but you can't stop because the velocity is addictive. `pindab0ter`: *"It's addictive. You're fast, efficient, you feel like you're in control. All while you're slowly losing grip."*

**6. Testing philosophy is the unspoken fault line**

`teeray` surfaces something nobody else threads together: *"If your code is hard to test, you need to change the abstraction or the interface. Tests are the first reuse of your code."* When AI writes both code and tests, this feedback signal — where test difficulty reveals design problems — goes silent. `wreath` adds that most test code in AI training data is trash, so AI-generated tests provide a false sense of reliability. `logicprog` counter-argues that AI coding *incentivizes* better testing infrastructure (more tests, better CI, typed languages). Both are right: the question is whether organizations will invest in the testing discipline or skip it because "the tests pass."

**7. The "just review it" camp is split on whether review is even possible**

`onion2k` pushes back on the article: juniors have always learned by *reading* senior code in reviews, so reviewing AI output should strengthen skills, not weaken them. `empath75` drops a two-word rebuttal: *"Replace this with 'writing assembly'"* — implying the abstraction level has shifted too far for review to be meaningful learning. `heartbreak` argues that since most of their career has been reading code they didn't write, AI changes nothing fundamental. `kccqzy` counters with direct experience: *"I've witnessed at Google plenty of L6 and L7 software engineers atrophy. They stop writing code, start reviewing code, until they find that their code reviews catch fewer issues than a junior engineer's reviews."* The pre-AI evidence already shows that review-only work degrades judgment.

**8. The upstream bottleneck nobody planned for**

`Yokohiii` makes the thread's most underrated structural observation: developer productivity was never the only bottleneck. Product owners already struggled to prepare enough work for sprint cycles. If coding speed 2-4x's but product definition, communication, and prioritization don't — and they won't, because those are fundamentally human-bandwidth-limited — you get a flood of poorly specified features. `monkeydust` confirms this from the other direction: with near-zero marginal cost of building features, you get *indulgent* about adding them, and `linkjuice4all` extends this downstream — sales, marketing, and support can't absorb the output either. The constraint was never typing speed.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "This is just the assembly→FORTRAN transition" | Weak | Breaks down because LLMs aren't deterministic compilers; the precision guarantee is gone |
| "Review builds skills the same as writing" | Medium | True for *active* review with interrogation; false for approve-and-move-on, which is what velocity pressure incentivizes |
| "We don't have enough data to panic" | Strong | `adampunk` correctly notes the evidence base is thin — one small study, anecdotes, and vibes. But framing caution as "panic" is a dodge |
| "Skills atrophy doesn't matter if you never need them again" | Misapplied | Assumes AGI is around the corner; if it isn't, you've disarmed the people responsible for maintaining the systems |
| "Use it or lose it isn't even physically true" | Weak | `rafaelmn` cites muscle memory regain; `throwaway346434` provides neuroscience citations showing neural pathway atrophy is real |

### What the Thread Misses

- **No one asks who benefits from the "cognitive debt" framing being ignored.** AI lab CEOs make timeline predictions that slip, face zero accountability, and the incentive to push maximum adoption is entirely on the vendor side. The thread notes this but doesn't connect it to the asymmetry: vendors externalize cognitive costs onto individual developers while capturing the productivity gains at the organizational level.

- **The open-source angle is absent.** If professional coding shifts to AI-first, open-source projects — which depend on deep individual understanding and intrinsic motivation — may contract into smaller, tighter communities. `FridgeSeal` gestures at this but nobody explores the systemic implications for software infrastructure that most companies depend on.

- **Nobody discusses what happens to incident response.** The article's 3am pager scenario gets no thread engagement, yet it's where cognitive debt materializes most violently: you need to triage under time pressure, from memory, without an agent that may not have the context. This is the falsifiable prediction the debate needs.

- **The article itself may be partially AI-written** — `dddggghbbfblk` and `happycube` flag this — which is a meta-irony nobody explores: an essay about cognitive costs of AI delegation that may have been delegated to AI.

### Verdict

The thread converges on something it never quite articulates: the problem isn't AI coding tools, it's that *there is no institutional mechanism to manage the transition*. Companies optimize for quarterly velocity. Developers optimize for dopamine and career safety. AI vendors optimize for adoption. Nobody optimizes for the 18-month cognitive health of the engineering workforce, because that cost is diffuse, delayed, and unmeasured. The Shen-Tamkin study's real finding — that *how* you use AI matters more than *whether* you use it — gets drowned out by binary "use it" vs. "resist it" framing, which is itself a symptom of the missing institutional layer. The thread's most honest participants (`Vexs`, `9dev`, the author himself) all describe the same experience: knowing the cost, paying it anyway, and hoping someone will eventually build the guardrails they can't build alone.
