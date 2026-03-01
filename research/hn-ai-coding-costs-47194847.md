← [Index](../README.md)

## HN Thread Distillation: "What AI coding costs you"

**Source:** [tomwojcik.com](https://tomwojcik.com/posts/2026-02-15/finding-the-right-amount-of-ai/) · [HN thread](https://news.ycombinator.com/item?id=47194847) · 297 points · 177 comments · Feb 2026

**Article summary:** Developer Tom Wojcik argues there's a hidden cost curve to AI coding: cognitive debt (losing the mental model of your own systems), seniority pipeline collapse (juniors skip the struggle that builds judgment), and "dark flow" (feeling productive while skills atrophy). He cites the Shen-Tamkin 2026 study (17% lower conceptual understanding in AI-assisted devs), Margaret-Anne Storey's cognitive debt framing, and Simon Willison's admission of lost mental models on prompted projects. The piece stakes out a "right amount" thesis: three good AI interaction patterns (explanations, conceptual questions, independent coding with AI clarification) vs. three bad ones (full delegation, progressive reliance, outsourcing debugging).

### Article Critique

The article is well-sourced for the genre, linking primary research instead of just vibing. But it has a structural weakness: it bundles two very different claims. **Claim 1** — skills atrophy when you stop practicing them — is neuroplasticity 101 and basically unfalsifiable. **Claim 2** — AI coding *specifically* accelerates this atrophy faster than prior abstraction shifts (assembler→FORTRAN, manual→IDE) — is the interesting claim, and the evidence is thin. The Shen-Tamkin study measures skill *formation* in novices learning a new library, not skill *decay* in experienced engineers. The article elides this distinction. Storey's cognitive debt concept is a useful frame but has zero longitudinal data. The strongest evidence is actually Simon Willison's self-report, and it's an n=1 anecdote from someone running dozens of simultaneous projects.

The article also never reckons with the implied counterfactual: pre-AI, most developers already didn't hold deep mental models of codebases they didn't write. The "before" state is romanticized.

### Dominant Sentiment: Worried agreement with caveats

The thread broadly validates the article's anxiety but splinters on whether the cost is novel or just the latest turn of an old crank. No one is sanguine about "just let AI do everything," but there's a meaningful split between those who think this is an unprecedented cognitive threat and those who see it as the normal pain of abstraction shifts.

### Key Insights

**1. The review paradox is felt but unsolved**

The thread's central anxiety: reviewing AI code requires the same depth as writing it, but reviewing doesn't build that depth. `agentultra` sharpens this with Tony Hoare's distinction: *"There are two ways to write software: either it obviously has no errors or there are no obvious errors in it. LLMs tend to generate the latter."* Multiple commenters confirm they're already in this trap — `Vexs` describes integrating two APIs via Claude and ending up with a good thin wrapper *that they have zero mental model of*: "It doesn't matter if I get it to explain it, that's just information that washes off when I move onto the next thing. The reflexive memory isn't built." This is the most honest testimony in the thread and names the mechanism precisely: declarative knowledge (explanation) doesn't substitute for procedural knowledge (doing).

**2. The Shen-Tamkin study is being misread — and the correction matters**

`logicprog` delivers the thread's sharpest analytical comment, pointing out the study measures skill *formation*, not skill *decay*: "The entire task of that study was specifically to learn a brand new asynchronous library that they hadn't had experience with before." More importantly, they surface that *within* the AI group, those who asked the AI for explanations and summaries after code generation scored among the highest — sometimes above the non-AI group. The differentiator isn't AI/no-AI, it's passive delegation vs. active interrogation. This nuance is systematically dropped in every article and comment that cites the study for "AI makes you dumber."

**3. The engineering manager squeeze is the real story**

`9dev` gives the thread's most revealing managerial confession: *"I just cannot ignore AI as a development tool. There is no good justification I can give the rest of the company for why we would not incorporate AI tools."* They're applying "gentle pressure" while worrying about junior development, and the best they can articulate is hoping for a local maximum between "company survival" and "team happiness." `throwaway346434` responds with the genuinely clever counter-frame: calculate staff replacement costs from burnout/attrition, then argue that *not* pushing AI to 10 is a 50% efficiency gain in the HR funnel. This reframes the problem in language management actually understands — but it's the kind of argument that only works if someone does the math, and nobody does the math.

**4. The abstraction-shift analogy keeps being deployed and keeps failing**

`googamooga` offers the classic "I coded PDP-11 opcodes, then FORTRAN, didn't miss the opcodes" argument. `bwestergard` and `ip26` demolish it from different angles: (a) reasoning about opcodes built cognitive capacity that transferred to FORTRAN — the question is whether prompting builds transferable capacity, and (b) every prior transition moved between *formal* languages with deterministic semantics, while AI coding moves from formal to natural language, which is categorically different. The thread never resolves this, but the quality of the pushback is high. The abstraction-shift camp can't explain why *this* particular shift wouldn't degrade systems reasoning, because the natural-language-to-code compilation step introduces a fundamentally new source of non-determinism.

**5. "Cognitive debt" is the concept the industry needed — and will ignore**

Storey's framing (technical debt lives in code, cognitive debt lives in heads) gives the thread a shared vocabulary. `october8140` extends it: *"Technical debt is contained in a project, but cognitive debt is contained in a person. I think we will see good developers pile up so much cognitive debt they will nuke their own careers."* The asymmetry matters: you can pay down technical debt with refactoring sprints. Cognitive debt is personal, invisible, and has no dashboard. It's the kind of risk that organizations are structurally incapable of managing because it manifests as individual performance decline years later, long after the decision-maker has moved on.

**6. The joy problem is underweighted**

Multiple comments circle this but `ksenzee` names it most precisely: there are two kinds of developers — those who love seeing the finished product (they'll be fine with AI) and those who love the process of solving (AI robs them of the thing that keeps them engaged). The second group are *also the ones who debug production incidents*. If they retrain as electricians, the industry has a problem. `xantronix` speaks for this camp with real feeling: *"The callouses matter. The tedium matters."* `iaaan`: *"Makes me sad to see all the people allowing corporations to slowly rob them of all the little joys this field has to offer."* This isn't nostalgia — it's a retention signal that no one is measuring.

**7. The embedded/systems world reveals the limits**

`jmux` from embedded software provides a useful boundary condition: *"AI simply can't debug the symptom when the reasons for the bug aren't in code, and a stack trace may not exist."* Hard bugs in embedded require connecting observations across hardware, timing, and codebase — exactly the kind of systems reasoning that atrophies under delegation. But even jmux credits AI for harnesses, tooling, and git archaeology. The emerging pattern: AI is excellent for *support* tasks and dangerous for *core reasoning* tasks, and the problem is that organizations can't tell the difference.

**8. The StrongDM "Software Factory" is the thread's ghost at the banquet**

`MattRix` links StrongDM's factory model (no human code writing, no human code review, $1000/day in tokens per engineer, validation via "digital twin universe") and says "I don't like that the industry is heading this way, but the more I consider that approach, the more I'm convinced it is inevitable." The thread mostly ignores this, which is itself revealing — it's too uncomfortable to engage with. StrongDM's approach bypasses the entire review paradox by replacing human review with adversarial scenario testing. Whether it actually works at scale is unproven, but it's the only concrete alternative architecture for AI development in the thread. Everyone else is arguing about how much humans should review; StrongDM is arguing humans shouldn't review at all.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "It's just like assembly→FORTRAN" | Medium | Analogy breaks on formal→natural language shift. Prior transitions preserved deterministic reasoning; this one doesn't. |
| "Reading/reviewing code builds skills too" (`onion2k`) | Medium | True for active review, but conflates "read and understand deeply" with "click accept." The empirical question is which mode dominates in practice. |
| "Skills bounce back quickly" (`rafaelmn`) | Weak | Muscle memory ≠ cognitive skill. Cited neuroscience on neural pathway atrophy contradicts the optimism. |
| "We don't have enough data yet" (`adampunk`, `phendrenad2`) | Strong | Genuinely true. Most claims are extrapolations from one study on novices + anecdotes. The caution is warranted but functionally useless — you can't wait for longitudinal data when adoption is happening now. |
| "Just use AI for boring stuff, code the fun stuff yourself" | Medium | Sensible heuristic, impossible to enforce organizationally. The boring/fun boundary shifts under velocity pressure. |

### What the Thread Misses

- **Nobody models the feedback loop quantitatively.** If cognitive debt compounds (skills decay → worse review → more bugs → more reliance on AI → more decay), what's the half-life? Is it 6 months? 3 years? The difference matters enormously for policy, and nobody even frames it as an empirical question.

- **The open-source implications are absent.** If professional developers stop building deep expertise, who maintains critical infrastructure libraries? AI can't maintain what it doesn't understand, and understanding is exactly what's being lost.

- **No one discusses the selection effect.** Developers who thrive with AI and those who don't may be different populations. The thread treats "developers" as uniform, but `ksenzee`'s two-types framing hints at a deeper split that could reshape who stays in the industry.

- **The article's own existence is evidence.** Several commenters (`dddgghhbbfblk`, `happycube`, `alvabuddha`) suspect the article is partially AI-written. A 3000-word piece about cognitive costs of AI that may itself be AI-assisted is a meta-irony nobody fully unpacks.

### Verdict

The thread circles a dynamic it never quite names: **the misalignment between the timescale of AI's benefits (immediate, measurable) and the timescale of its costs (delayed, invisible)**. Quarterly velocity gains are real and dashboardable. Cognitive atrophy, seniority pipeline collapse, and joy erosion operate on 2-5 year horizons that no organization is structured to track. This is not a technology problem — it's a principal-agent problem where the agent (the developer) has better information about their own skill trajectory than the principal (the org), but the agent is incentivized by the same short-term velocity gains to ignore it. The developers who are most worried are the ones who can still feel the atrophy. The ones who can't feel it anymore are the ones who should be most worried.
