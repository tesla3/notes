← [Index](../README.md)

## HN Thread Distillation: "Debian decides not to decide on AI-generated contributions"

**Source:** [LWN article](https://lwn.net/SubscriberLink/1061544/125f911834966dd0/) · [HN thread](https://news.ycombinator.com/item?id=47324087) (315 pts, 240 comments, 150 unique authors)  
**Date:** 2026-03-10

**Article summary:** Debian's Lucas Nussbaum proposed a general resolution on AI-assisted contributions in Feb 2026, requiring disclosure, accountability, and labeling. After civil debate, the project punted — no GR was formally submitted. Developers couldn't even agree on terminology ("AI" vs "LLM"), let alone policy. The status quo (case-by-case, existing policies) holds.

### Dominant Sentiment: Exhausted pragmatism masking deep fractures

The thread is remarkably split but the dominant mode is fatigue — people have been having this argument for two years and most comments are variations on positions staked out in 2024. The energy has shifted from "should we ban AI?" to "how do we survive the flood?" — a defensive posture that tells you more than any specific argument.

### Key Insights

**1. The real problem isn't AI quality — it's asymmetric review cost**

The thread converges on this but never names it crisply: the core crisis is that AI makes *submitting* code nearly free while *reviewing* code remains expensive human labor. This is a classic tragedy of the commons. [bigfishrunning]: "Whether the quality of the code is the responsibility of the submitter or not is kind of irrelevant though, because the cost of verifying that quality still falls on the maintainer." The article's Simon Richter makes the same point about onboarding: accepting AI drive-by contributions is a missed opportunity that burns reviewer time without producing a lasting contributor. The "just review harder" crowd never addresses who pays the review tax.

**2. "No AI" rules are performative — but that doesn't make them pointless**

[hombre_fatal] argues that "no AI" is unenforceable because skilled users will ignore it and bad actors never cared. This gets significant pushback. [fwip]: "High-value contributors follow the rules and social mores of the community they are contributing to. If they intentionally deceive others, they are not high-value." [BoredPositron]: "An inability to discern the truth doesn't nullify the principle the rule was built on." The hombre_fatal position has a fatal gap: it treats rules purely as enforcement mechanisms, ignoring their function as social contracts that define community norms. The speed limit analogy works — most people go 5 over, but the limit still shapes behavior.

**3. The reputation system is the missing infrastructure**

Multiple commenters independently converge on reputation as the actual solution. [theptip]: "The world where anyone can submit a patch and get human eyes on it is a thing of the past." [datsci_est_2015] proposes a "DKP" system (borrowing from MMORPGs) where contribution rights are earned. [pessimizer] goes furthest, arguing Debian should build a contributor social network with portable reputation. [jillesvangurp] suggests combining AI triage bots with Git-signed reputation scores. This is the thread's most important convergence — the real gap isn't policy, it's infrastructure for trust scaling. Nobody has built it yet, and nobody in the thread asks why not (answer: it's a coordination problem harder than the AI problem itself).

**4. The copyright argument is weakening but won't die**

[coldpie] pushes the derivative-work theory — LLM output inherits training data licenses, so accepting AI code is a copyright violation. [graemep] notes this logic condemns most proprietary software too. [pessimizer] points out Debian is actually *best* positioned here because copyleft code trained on copyleft code is fine. The legal argument is fading as a practical concern (no court has ruled LLM output is derivative), but it persists as an ethical/identity marker for the libre software wing. It's becoming a proxy for "I don't like this" rather than a genuine legal risk assessment.

**5. The experience gap is real and widening**

[pjerem] and [cruffle_duffle] report routinely one-shotting working applications with Claude Code/OpenCode. [bigstrat2003] says AI "can't even generate a few hundred line script that runs on the first try" and claims AI has "already stagnated." These aren't lying to each other — they're using fundamentally different toolchains and workflows. The gap between agentic coding (Claude Code, Cursor, Cline) and chat-based prompting is now so large that people in the same thread are describing different realities. [pjerem]: "If I use Claude Sonnet on duck.ai I will have hard time generating something interesting. The same model in OpenCode does all my programming work." This divergence will only grow.

**6. The humanist objection has emotional force but no policy lever**

[lpcvoid] calls LLM output "stolen code condensed into the greatest heist of the 21st century." [sigbottle]: "Human society exists because we value humans, full stop." [bigstrat2003] agrees, citing someone proposing to "fix loneliness by removing the human need for socializing." This camp has genuine moral clarity — they see AI adoption as an existential values question, not a tooling question. But they can't translate it into workable policy because Debian's social contract is about software freedom, not human flourishing. The emotional weight is real; the governance hook is missing.

**7. The "fight AI with AI" proposal is inevitable but ironic**

[jillesvangurp] proposes using AI bots to triage and pre-screen PRs, filter low-quality submissions, and enforce standards. [xiphias2] immediately responds with the core problem: "Whenever I tried to develop using guardrails with LLMs, I found out that they are much better at cheating than a human: getting around the guardrails by creating the ugliest hacks around them." This is the AI moderation arms race in miniature — the same dynamic that killed spam filters, content moderation, and every other automated gatekeeping system. Using AI to filter AI slop creates a co-evolutionary loop where both sides get better at gaming each other.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "If it passes review, who cares how it was made?" | Medium | Ignores that review cost is the bottleneck, not review capability |
| "AI has already stagnated" | Weak | Confuses chat-based prompting ceiling with agentic tooling ceiling |
| "All LLM output is stolen slop" | Weak | Conflates training ethics (debatable) with output quality (measurable) |
| "Ban AI to protect onboarding pipeline" | Strong | Richter's argument from the article is the strongest anti-AI case nobody in the HN thread seriously engages |
| "Reputation systems will solve this" | Medium | Correct diagnosis, but hand-waves the coordination problem of actually building one |
| "Critical infra shouldn't use AI" | Strong | [PinkMilkshake] distinguishes web apps from kernels/compilers — the only commenter to make domain-specific risk distinctions |

### What the Thread Misses

- **The Hacktoberfest parallel is underexplored.** [Yhippa] mentions it once and nobody picks it up. Hacktoberfest's solution was to make maintainers opt-in rather than opt-out. That's directly applicable — Debian packages could declare their AI policy individually rather than project-wide.
- **Nobody discusses the asymmetry between closed and open models.** [est31] touches it but the thread ignores the structural issue: if the best models are closed (proprietary), then AI-enhanced FOSS development depends on proprietary infrastructure. This is the BitKeeper parallel Nussbaum raised in the mailing list but the HN thread doesn't engage.
- **The "preferred form of modification" question is devastating and unaddressed.** Bdale Garbee asked on-list: if code is generated by prompts, is the prompt the source? The GPL's "preferred form of modification" clause could mean AI-generated code without committed prompts is technically non-free. This is a legal time bomb nobody in the HN thread even mentions.
- **No one models the economics.** If AI makes code submission 100x cheaper but review stays constant, the equilibrium is either (a) massively more reviewers, (b) automated triage, or (c) closed contribution models. Option (a) isn't happening. Option (b) has the arms race problem. Option (c) — restricting who can submit — is where this actually ends up, but nobody wants to say it because it violates FOSS's egalitarian self-image.

### Verdict

Debian "decided not to decide" and HN mostly agrees that's wise, but for the wrong reason. The thread treats this as a hard question that needs more time. It's actually an *impossible* question under current governance structures: FOSS projects are built on the assumption that contribution is cheap to offer and review is the bottleneck, but the ratio was manageable. AI has broken that ratio. The real decision Debian is deferring isn't "should we allow AI?" — it's "should we move from open contribution to curated contribution?" That's a fundamental governance change that no GR can address, and the thread circles this realization without ever landing on it.
