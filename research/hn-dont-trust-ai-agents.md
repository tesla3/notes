← [Index](../README.md)

## HN Thread Distillation: "Don't trust AI agents"

**Article summary:** NanoClaw's creator argues AI agents should be treated as untrusted by default. The article contrasts NanoClaw's architecture (per-agent containers, ~3k LOC, skill-based extensions) against OpenClaw's (~400k+ LOC, shared container, monolithic). The pitch: security comes from isolation and auditability, not permission checks. It's a product comparison dressed as a security manifesto.

### Dominant Sentiment: Skeptical agreement laced with fatalism

The thread broadly agrees agents can't be trusted, but fractures on whether that's a solvable engineering problem or a fundamental limitation that should prevent adoption entirely. A notable undercurrent of resignation: the incentives reward shipping insecure agent frameworks, and the market doesn't punish it.

### Key Insights

**1. The LoC discourse reveals an industry losing its epistemics**

The thread's highest-signal discussion isn't about agents at all — it's about how the AI hype cycle has rehabilitated lines-of-code as a productivity metric, something every competent engineer knew was wrong for decades. `badsectoracula` opens with the core observation, but `gyomu` lands the punch: Paul Graham is tweeting "an experienced programmer told me he's now using AI to generate a thousand lines of code an hour" — the same PG who would have laughed someone out of YC office hours for saying that pre-2023. The thread treats this as a canary: if even the field's taste-makers have abandoned basic engineering epistemics to sell the narrative, quality gatekeeping is collapsing from the top.

`ninkendo` pushes back with a detailed rebuttal — he vibe-coded a password manager in Rust, reviewed every line, and it works. He even published the repo when challenged. But the counterargument is revealing: his 10x speed-up is really "reviewing code is faster than writing it," which is a genuine but bounded productivity gain, not the paradigm shift being sold. And `FEELmyAGI` correctly notes that every vibe-coded project showcased is a clone of something with abundant training data.

**2. NanoClaw's "auditable LOC" claim is self-undermining**

The article's central thesis — that 3k LOC is reviewable where 400k isn't — gets demolished by `drujensen` and `MarkSweep`. NanoClaw's "skills" are markdown instructions that tell Claude Code to generate and merge code *on the fly*. Every installation is custom AI-written code. The LOC count only stays low *before* you add features. After you install Discord, Telegram, and WhatsApp skills, you have thousands of lines of AI-generated, un-reviewed, non-deterministic code — precisely the problem the article claims to solve.

`solfox`: "You want every user asks the AI to implement the same feature?" `sanex`: "They still have code examples in them so it's not like it somehow doesn't count. Plus if you run the skill good luck bringing in changes from master later." The fork-divergence problem is real: `dannymi` confirms upstream updates cause constant merge conflicts.

The author (`jimminyx`) responds that skills now use `git merge` with reference implementations, and you're supposed to review everything. Fair enough — but that makes NanoClaw a framework for building bespoke agents, not a product. The security claim dissolves into "trust your own code review," which is the same position OpenClaw occupies, just with less code to review at any given moment.

**3. Container isolation is necessary but radically insufficient**

The thread converges on a crucial distinction: the threat model for AI agents isn't container escape — it's credential and data exfiltration *through legitimate channels*. `xienze`: "The best container security in the world isn't going to help you when the agent has credentials to third party services. Frankly, I don't think bad actors care that much about exploiting agents to rm -rf /. It's much more valuable to have your Google tokens or AWS credentials."

`eyberg` provides hard data: 16 container escapes in 2025, 8 at the runtime layer, zero kernel-related. Containers aren't the hard boundary people assume. But even if they were perfect, `fnord77` reports OpenClaw found his browser cookies inside a VM. The attack surface isn't the sandbox walls — it's everything you voluntarily mount inside.

Simon Willison's "lethal trifecta" framework (cited by `medi8r`) crystallizes the real problem: private data access + untrusted content exposure + external communication capability = trivially exploitable data theft. Every useful agent needs at least two of these three. Most need all three.

**4. The "read-only agent" pattern fails on inspection**

`Doublon` proposes a reasonable-sounding middle ground: agents with read-only tools that can only draft actions into a task queue for human review. But `swid` and `zahlman` immediately identify the flaw: "There is no real such thing as a read-only GET request." Query parameters can exfiltrate secrets via server logs. A "read-only" agent with access to your email and a browser can still leak everything through URL parameters. The distinction between read and write access is a UI abstraction, not a security boundary.

**5. The only credible defense is kernel-level, not application-level**

`blakec` describes the most technically rigorous approach in the thread: 84 Claude Code hooks with a macOS Seatbelt (sandbox-exec) profile that denies access to ~/.ssh, ~/.gnupg, ~/.aws, and credential files at the kernel level. ~2ms overhead, applies to the entire process tree, can't be bypassed by subprocess spawning or pipe tricks. He ran it in dry-run mode for a week before enforcing, with 31 tests.

This is the right mental model: security properties the agent *physically cannot violate*, regardless of prompt injection. But it's also a setup that requires deep systems knowledge and ongoing maintenance — exactly the kind of thing the average *Claw user will never do. The gap between "what would make agents safe" and "what people will actually configure" is the real problem.

**6. "Do you even need this?" is the question nobody wants to ask**

`aerhardt` drops the thread's most uncomfortable question: "Does your life have so much friction that you need a digital agent to act on your behalf?" He works in business automation and finds his private life frictionless. `wolvesechoes` responds with the sharpest line in the thread: "Do not underestimate modern marketing and its capability to create needs that didn't exist before. It is not about removing friction, it is about convincing that friction existed in the first place."

The most enthusiastic use cases cited — checking into flights, managing dog feeding schedules, organizing band listings from a festival — are either trivially manual or outright dangerous (email triage). `rubslopes` describes the strongest case: cross-referencing git history with Jira tickets and meeting transcripts. That's genuinely useful and hard to do manually. But it also requires connecting the agent to GitHub, Jira, Fireflies, and Obsidian — the lethal trifecta on steroids.

**7. The employee trust analogy collapses under scrutiny**

`TeeWEE` tries the standard defense: "Do you trust your employees? AI is similar." The thread demolishes this from multiple angles. `arnvald`: employees face legal consequences, contracts, courts. `alexhans`: who is accountable and liable when the AI causes damage? `ramoz`: AI reasons through probabilistic methods with no memory or rational thinking — fundamentally different failure modes. `adam12` with the one-liner: "Can you sue an AI agent?"

The analogy fails because employment is a *trust framework* — legal accountability, professional reputation, human judgment, corrective feedback. Agents have none of these. The better analogy is running untrusted code from a stranger, which is why sandboxing discussions dominate.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Containers aren't a security boundary" | Strong | 16 escapes in 2025 per eyberg's data; but the bigger issue is legitimate-channel exfiltration, not escape |
| "NanoClaw's LOC claim is dishonest" | Strong | Skills generate unbounded AI-written code post-install; the count is snapshot-dependent |
| "Just don't use agents" | Misapplied | Correct on security merits, ignores that adoption is driven by incentives, not safety analysis |
| "Brook's Law is obsolete" | Medium | `smikhanov` makes a fair point about accidental complexity creating parallelizable work, but `dasil003` correctly notes this doesn't invalidate the coordination overhead for *design* work |
| "Read-only agents are safe" | Weak | GET requests exfiltrate via query params; read access to email is read access to password reset tokens |

### What the Thread Misses

- **The supply chain attack vector nobody mentions.** NanoClaw's skills pull reference implementations via `git merge`. If the upstream skill repo is compromised, every user who runs that skill gets malicious code merged into their fork — and they're told to trust the diff because "it's only a few thousand lines." This is a software supply chain problem wearing a trenchcoat.

- **The economic incentive structure is backwards.** `tabs_or_spaces` gets closest: OpenClaw became the fastest-growing GitHub project by being insecure and feature-rich. There's no market penalty for poor agent security — users blame themselves when things go wrong. Until there's a high-profile, attributable breach, security-first frameworks like NanoClaw are fighting the market, not competitors.

- **Prompt injection and non-determinism are conflated.** `msdz` correctly separates these: non-determinism (agent does something you didn't intend) vs. prompt injection (adversary manipulates the agent). Most guardrail discussions in the thread address the former but hand-wave the latter, even though prompt injection is the existential threat. The Google DeepMind CaMeL paper is cited once but never discussed.

- **Nobody asks who's insuring this.** As agents take actions with financial and legal consequences (sending emails, managing accounts, accessing credentials), the liability question is unanswered. No insurer is going to underwrite "an LLM managed my client's email."

### Verdict

The thread circles a truth it never quite states: the agent security problem is not an engineering problem — it's a *market design* problem. Every technical mitigation discussed (containers, proxies, kernel sandboxing, read-only tools) is either insufficient against prompt injection or too complex for the target user. The real question is whether the market will develop accountability structures (liability, insurance, certification) before a catastrophic breach forces it to. Right now, the incentives point toward "ship fast, blame the user," and NanoClaw — for all its architectural good taste — is competing in a market that doesn't price security. The article's title is correct: don't trust AI agents. The thread's implicit conclusion is darker: nobody will listen.
