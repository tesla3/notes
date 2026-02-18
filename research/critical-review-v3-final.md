← [Coding Agents](../topics/coding-agents.md) · [Index](../README.md)

# Critical Review v3: Zechner & Steinberger Tips — Corroborated, Contested, and Complicated

**Reviewed:** February 16, 2026
**Cross-referenced against:** Armin Ronacher, Simon Willison, Mitchell Hashimoto, Addy Osmani, Steve Yegge, Anthropic official docs & 2026 Trends Report, the METR RCT (July 2025), LinearB/GitClear/Opsera telemetry, and HN/Lobsters discussion.

---

## Before We Begin: We're All Working From Vibes

The original tips document rests on self-reported experience from two practitioners. So does every other blog post in this space. The uncomfortable truth is that we have almost no rigorous evidence about what works in agentic coding.

The one RCT we have — the **METR study (July 2025)** — found experienced developers were 19% slower with AI tools while believing they were 20% faster. That's a 39-point perception gap. But this study has real limitations that I overweighted in my previous draft: it used early-2025 tools (Cursor + Claude 3.5/3.7 Sonnet, not agentic CLIs), only 16 participants, and tested on mature high-standard repos where the developers already had 5+ years and 1,500+ commits of familiarity — exactly the setting where AI help matters least.

The METR study doesn't prove agents are useless. But it proves something just as important: **developers cannot reliably self-assess whether AI is helping them.** This means the productivity claims in the original document, in my review, and in every practitioner blog post should be held with appropriate skepticism. Mario Zechner himself acknowledges this: "Emphasis on *feels*. Because that's all we have, vibes."

Supporting telemetry is mixed: LinearB data shows 67.3% AI-generated PR rejection rates. Stack Overflow's December 2025 survey recorded the first-ever decline in AI tool sentiment. But Anthropic's 2026 Trends Report cites enterprise organizations reporting 30-79% faster development cycles, and Rakuten compressed 24-day feature cycles to 5 days. The Opsera 2026 benchmark found senior engineers realize nearly 5x the productivity gains of juniors — suggesting the gains are real but skill-dependent.

In short: nobody has clean data. Proceed with eyes open.

---

## Claim-by-Claim Assessment

### "GPT-5.2 + Codex is the new default"

**Verdict: Already stale. But the model-war framing is the deeper problem.**

Since December 2025: Opus 4.6 shipped (1M context, agent teams), GPT-5.3-Codex is out, Codex has a macOS app with Skills and Automations. The specific recommendation has rotted in 8 weeks.

The other practitioners:
- **Armin Ronacher:** Uses Claude Code with Sonnet (the *cheaper* model), $100/month Max plan. Never switched to Codex as primary. Prefers Sonnet over Opus. Ships at comparable speed to Steipete.
- **Mitchell Hashimoto:** Claude Code primarily. Runs ensemble comparisons — multiple agents on the same task, takes the best parts. "Usually no one agent wins. One captures the main idea. Another remembers an edge case."
- **Simon Willison:** Uses both. Ported JustHTML with Codex/GPT-5.2 in 4.5 hours. Never centers advice on model choice.

The durable insight *underneath* Steipete's advocacy: Codex reads code for 10-15 minutes before writing, increasing first-shot correctness. That's a *behavior pattern* worth knowing about — and it's a pattern that newer Claude models have started mimicking. The specific model isn't the point; the read-first behavior is.

**What transfers:** Pick your agent based on (a) can you observe its reasoning, (b) is the context window adequate for your codebase, (c) are feedback loops fast. Everything else is perishable.

---

### "Ship code you don't read"

**Verdict: An outlier position most top practitioners explicitly reject — but the original document also undersells what Steipete actually does right.**

I need to be fairer here than in my previous draft. Steipete ships real products with real users. That's evidence. His approach works *for him*, and dismissing it because it contradicts the consensus would be intellectually lazy.

But the consensus against it is broad and principled:

- **Willison (Dec 2025):** "Submitting untested AI slop in pull requests is a dereliction of duty." Your new job is delivering *proven* code.
- **Hashimoto (Feb 2026):** Discards agent code he can't understand or replicate. Enforces AI disclosure on Ghostty PRs. Did all his work *twice* (manually then with agents) for weeks to calibrate judgment.
- **Armin (Feb 2026, "The Final Bottleneck"):** Human accountability doesn't scale with inference speed. "I too am the bottleneck. I was the bottleneck all along."
- **Osmani (Dec 2025):** Treats every AI output as if it came from a junior developer.
- **The Yegge cautionary tale:** Gas Town merged 44k+ lines from 50 contributors in 12 days. Yegge says he's "never looked at" his 225k-line codebase. Result: his production database went down for two days when an agent erased passwords. An HN commenter observed: "I'm watching multiple people both publicly and privately clearly breaking down mentally because of the 'power' AI is bestowing on them. Their wires are completely crossed when it comes to the value of outputs vs outcomes."

The deeper issue: **Steipete can ship without reading because he has 20+ years of systems taste functioning as a background filter.** When he glances at the stream of code going by, he *is* reviewing — just not line-by-line. His pattern-matching is so trained that he catches structural problems at a glance. This isn't "not reading" — it's expert reading at a different resolution. The danger is that less experienced developers hear "ship without reading" and take it literally, without the background taste that makes it work.

**What the original document should say:** "Steipete's workflow requires decades of systems taste as a prerequisite. For most developers, Hashimoto's approach (understand everything you ship, discard what you can't replicate) is safer and more generalizable."

---

### "MCP is mostly overkill — prefer CLIs"

**Verdict: Broadly corroborated. The strongest consensus in the document.**

The evidence here is genuinely strong:

- **Mario's benchmark:** Playwright MCP = 13.7k tokens. His equivalent CLI tools = 225 tokens. 60x savings.
- **Armin (Jun 2025 talk):** "For coding agents, I encourage not to use MCP. Too much MCP causes faster context rot."
- **Armin (Nov 2025):** Built a Claude Skill from Mario's browser CLI tools. Endorsed the approach.
- **Hashimoto:** Uses `gh` CLI for GitHub interactions. No MCP.
- **Anthropic's own docs:** Show that preprocessing hooks can reduce a 10,000-line log file to just the ERROR lines — hundreds of tokens instead of tens of thousands.

**The nuance the document misses:** Armin's **"Skills vs Dynamic MCP Loadouts" (Dec 2025)** represents the actual evolved position. He moved all MCPs to Skills — loaded on-demand instead of injected into every prompt. This gives you persistent awareness (MCP's real advantage) without the context tax. The hierarchy is: CLIs (default) → Skills (when you need persistent awareness) → MCP (only for deep integrations that truly justify it).

**One specific golden technique from Anthropic's docs:** Use hooks to preprocess tool output. Instead of letting the agent read a 10,000-line log, have a hook `grep` for ERROR and return only matching lines. This is exactly Mario's philosophy (token efficiency) implemented at the infrastructure level.

---

### "Prompts are code / serialize state to disk"

**Verdict: The most durable insight in the document. But I should be tougher on the evidence for it.**

Mario's framework has aged very well and is independently corroborated:

- Hashimoto saves plans to markdown, references across sessions.
- Armin iterates on markdown "handoff documents" instead of plan mode.
- Armin built "Absurd" (durable execution on Postgres) for complex workflows.
- Anthropic's November 2025 paper on effective harnesses for long-running agents describes the same pattern of tracking tasks in structured JSON outside agent memory.
- Even Yegge's Gas Town tracks atomic tasks in structured JSON outside agent context.

**Where I should push back on Mario:** His full framework (JSON + jq for surgical updates + deterministic loops + human checkpoints) is elegant *in theory*. But I don't have evidence that it produces measurably better outcomes than Hashimoto's lighter-weight version (plan in markdown, refer back to it). Mario's "pi" agent scored well on Terminal-Bench, but (a) that's a benchmark, and I just argued benchmarks can overstate real-world performance, and (b) we don't have controlled comparisons against less formal approaches.

The risk with "prompts are code": taken too literally, you end up over-engineering the *meta-workflow* instead of building the *thing*. Hashimoto's lighter version — plan in markdown, come back to it — achieves most of the benefit without the ceremony.

**The core principle that IS universally validated:** State belongs on disk, not in context. Context is ephemeral; compaction destroys it; sessions crash. Anything you need to survive across sessions should be in a file.

---

### "Plan mode is a hack for weaker models"

**Verdict: The framing is wrong. The *button* had UX problems. The *concept* is universal.**

Nobody is actually skipping planning:
- Steipete describes starting conversations, exploring, building plans together, then saying "build." That's planning.
- Armin (Dec 2025) examined what plan mode actually does. His conclusion: the button was annoying (broke YOLO permissions), so he independently developed markdown handoffs. Same outcome.
- Hashimoto plans first, saves to markdown, then executes. Every time.
- Osmani brainstorms a spec before any code, compiles into `spec.md`.

Calling planning "a hack" will cause readers to skip it. That'll make their results worse. The honest version: "The plan mode *button* had problems. Planning itself is non-negotiable."

---

### "Context engineering is the real skill"

**Verdict: Unanimous agreement, but the original document is too vague about what this means in practice.**

The best specific articulation: Armin's **"When you need to /compact you lost."** This means design workflows that complete within a single session. If you routinely rely on compaction, you're operating in a degraded mode.

Note that Steipete's December 2025 workflow directly contradicts this — he describes multi-hour sessions across compactions, finding it "works well enough." This is model-specific (GPT-5.2's compaction endpoint) and conflicts with the "state on disk" principle from Mario that the same document advocates. You can't simultaneously advocate for disk-based state (because context is unreliable) and multi-compaction sessions (which assume context is reliable enough). The document should acknowledge this tension.

**Specific techniques that are actually worth gold:**

| Technique | Source | What it does |
|---|---|---|
| Preprocessing hooks that `grep` logs for errors before passing to agent | Anthropic docs | Reduces 10k-line log to ~50 lines. Saves thousands of tokens. |
| `tool_output_token_limit` set to 25k (default too low) | Steipete | Prevents truncated tool output that confuses agents |
| `/clear` between unrelated tasks | Armin, Anthropic | Prevents context bleed between tasks |
| Sub-agents for isolated investigations | Armin | Keeps main context clean while exploring rabbit holes |
| docs/ folder per project, updated organically | Steipete, Armin | Persistent context that survives session resets |
| Short CLAUDE.md (<500 lines) | Armin ("too long is not helpful") | Prevents context bloat from instruction files |
| Skills over MCP for persistent tool awareness | Armin (Dec 2025) | On-demand loading vs. always-injected tools |
| Cross-reference sibling projects: `../other-project` | Steipete | Pattern reuse without copy-paste |
| Commit hooks for type checking/linting (not LSP) | Mario | Catches errors without filling context with diagnostics |

---

## What the Original Document Misses

### Testing: The Dog That Didn't Bark

The biggest omission. The original document mentions commit hooks for linting and almost nothing else about verification.

Meanwhile, testing is the closest thing to a consensus "most important practice" in the broader community:

- **Willison (Dec 2025):** Your new job is delivering code you've *proven* works.
- **Hashimoto:** "If you give an agent a way to verify its work, it more often than not fixes its own mistakes and prevents regressions." He calls this the single biggest unlock.
- **Armin:** Chose Go partly because `go test` is simple and incremental. Notes that test caching is "surprisingly crucial for efficient agentic loops."
- **Anthropic best practices:** Recommend TDD-style workflows with agents.

**But I need to be honest about the limits of this consensus.** When I look closely at what these practitioners actually *do* vs. what they *say*, the picture is muddier:

- Armin doesn't describe rigorous TDD. He uses test suites and commit hooks.
- Hashimoto gives agents "verification tools" — which sometimes means running the program and checking output, not formal test suites.
- Steipete barely mentions testing at all, yet ships working products.
- Mario talks about type checking and linting, not test coverage.

So the real consensus isn't "do TDD" — it's more like: **give the agent a way to check its own work, whatever form that takes.** For CLI tools, that might be running them. For web apps, that might be screenshots. For libraries, that's a test suite. The form varies; the principle (close the feedback loop) is universal.

**The most specific, actionable version:** If you do nothing else, make sure your agent can run your tests and iterate on failures without human intervention. Armin's observation about Go is key here: languages where the test runner is simple, incremental, and fast (Go, Python with pytest) create much tighter agent feedback loops than languages where testing is slow or configuration-heavy.

---

### The Cost Dimension

Nobody in the original document talks about money. The actual economics:

- **Claude Code average:** ~$6/developer/day on API, <$12 for 90% of users (Anthropic's own docs)
- **Subscription alternative:** $100/month Max plan (Armin's approach, Sonnet-only)
- **Hashimoto's Ghostty feature:** $15.98 across 16 agentic sessions
- **Armin's Claude Code on Sonnet:** ~$100/month Max plan, explicitly optimizes for token efficiency
- **Yegge's Gas Town:** "Expensive as hell. You won't like Gas Town if you ever have to think, even for a moment, about where money comes from."
- **Enterprise range:** $100-200/developer/month on Sonnet 4.5 (Anthropic docs), with high variance depending on parallel instances and automation

This matters because it creates a hidden selection bias in the discourse. The practitioners writing blog posts are (a) on high-income solo developer workflows where $100-200/month is trivial, or (b) on enterprise plans. For a freelancer or small startup, running 3-8 parallel agents (Steipete's recommendation) on Opus pricing could cost $500+/month. The original document's tips are implicitly priced for affluent solo developers.

**Token efficiency isn't just about context quality — it's about cost.** Mario's 225-token CLI tools vs. 13.7k-token MCP servers isn't just a context engineering win. At Sonnet pricing ($3/MTok input), that's the difference between fractions of a cent and real money per invocation, multiplied across hundreds of daily tool calls.

---

### The Team Dimension

Every tip in the original document is for solo developers. Most software is built by teams. The document doesn't acknowledge this, and several tips actively break at team scale:

- **"Commit directly to main, never worktrees"** — Steipete's recommendation. Fine solo; destructive on teams. Armin uses worktrees. Anthropic recommends them.
- **"No issue tracker needed"** — Fine for personal projects; unworkable with collaborators.
- **"Ship without reading"** — On a team, this is what Willison calls "a dereliction of duty." Armin's "Final Bottleneck" post explicitly argues that PR review is the constraint that doesn't scale.

The LinearB data tells the story at team scale: 67.3% AI-generated PR rejection rate means teams are spending *more* time on review, not less. The bottleneck shifted from writing to reviewing. AWS warned that "AI coding assistants will overwhelm your delivery pipeline."

Hashimoto offers the most relevant team advice: he uses agents for issue/PR triage on Ghostty (an open source project with many contributors), explicitly does NOT let agents respond to issues — only generates reports for human review the next morning. This is agent leverage applied to the review bottleneck, not just the generation side.

---

### Greenfield vs. Brownfield

Almost all practitioner advice is about building new things. The maintenance story is different and barely discussed.

Willison has hinted at the problem: "I've found myself getting lost in my own projects. I no longer have a firm mental model of what they can do and how they work, which means each additional feature becomes harder to reason about."

The METR study specifically tested experienced developers on *their own mature repos* — the brownfield case — and found slowdowns. This is probably not a coincidence. Agents seem most useful for greenfield work (new features, new projects, porting) and least useful for maintenance on complex existing codebases with many implicit rules.

Steipete's ~300k LOC TypeScript codebase, Yegge's 225k lines of unread Go — what happens in 2-3 years when these need maintenance? Nobody has data on this yet. It's the time bomb ticking under the entire discourse.

---

### Skill Atrophy and Mental Health

Both topics the original authors wrote about explicitly, but the tips document only extracted the productivity advice.

**Skill atrophy:** Hashimoto explicitly warns: "Delegating tasks means you don't build skills in those areas." MIT Technology Review (Jan 2026) profiled a developer who struggled on a side project without AI tools: "Things that used to be instinct became manual." Hashimoto's answer: deliberately choose which skills to maintain. Use agents for the tedious stuff you don't want to practice; do the interesting stuff manually.

**Mental health:** Steipete wrote "Just One More Prompt" about agent addiction. Armin wrote "Agent Psychosis" about the reality check when you interact with humans after days of building. An HN commenter on Gas Town: "People's obvious mental health issues are appearing as 'hyper productivity.'" A tips document that says "refactor when tired" without noting the addictive quality of agent-assisted flow states is leaving out something important.

---

## What Actually Holds Up

I'm deliberately not organizing this into neat tiers. The evidence is too messy for clean categories.

**Close the feedback loop.** Whatever form this takes — test suites, running the CLI, screenshots, type checking — the agent needs a way to verify its own work. Without this, you're generating code in the dark. Armin's observation: Go's simple incremental test runner creates much tighter agent loops than languages with slow or complex test setups. Hashimoto identifies this as the single biggest unlock in his adoption journey.

**State belongs on disk, not in context.** Mario's core insight. Independently corroborated by Armin (Absurd), Hashimoto (markdown plans), Anthropic (harness paper), Yegge (JSON task tracking). Context is ephemeral. Compaction destroys information. Anything important goes in a file.

**Plan before executing.** Everyone does this. The mechanism differs (plan mode button, markdown handoffs, conversational exploration), but the principle is universal. Hashimoto: "Even before AI, we knew planning saves you headaches. That's even more important now since the agent uses it for context."

**Default to CLIs, then Skills, then MCP last.** 60x token savings on Mario's benchmark. The model already knows how to use shell tools. Save structured tool registration for deep integrations that truly justify the cost.

**Small, verifiable changes over large rewrites.** "Many small bombs over Fat Man." Multiple practitioners converged independently. Sebastian Wallkötter's formulation: "AI coding's bottleneck is code review, not code generation. Small mistakes compound when AI re-ingests its own errors as context."

**Design workflows to finish before compaction.** Armin's "when you need to /compact you lost." If a task requires multiple compactions, you've either scoped it too broadly or you need to serialize intermediate state to disk.

**Hashimoto's "do the work twice" calibration.** The most counterintuitive and possibly most valuable advice in the entire ecosystem. Do a task manually, then redo it with agents (without showing your manual solution). "Excruciating" but reveals exactly what agents are good at, what they're bad at, and what prompting patterns work for your codebase. Nobody else recommends this, and it's probably the fastest path to real competence.

**Hashimoto's "fill-in-the-blanks" technique.** Provide function signatures, parameter types, and TODO comments, then ask the agent to implement. This constrains the agent's design space while leveraging its code generation strength. Armin's "I give tooling that guidance where it's like, 'I want you to achieve this end goal, but using this shape'" is the same pattern.

**Hashimoto's "end-of-day agents."** Block the last 30 minutes of the day to kick off agent tasks. Not for overnight runs — just for generating work that gives you a "warm start" the next morning. Specific tasks that work well: deep research surveys, parallel exploration of vague ideas, issue/PR triage (reports only — don't let agents respond). Pairs with Steipete's "refactor when tired" but with Hashimoto's important constraint: only assign tasks where you can quickly evaluate results.

**Hashimoto's ensemble pattern.** Run multiple agents on the same problem, take the best parts. "Usually no one agent wins. One captures the main idea. Another remembers an edge case." This costs more compute but produces better results than trusting any single agent. It also hedges against the model-war question — if you're comparing outputs across models, you don't need to pick a winner.

**Screenshots for UI iteration.** Steipete reports ~50% of prompts use screenshots when doing UI work. This is specific but genuinely useful — a screenshot conveys more UI context than paragraphs of text description.

**Cross-reference sibling projects.** Point agents at `../other-project` to reuse patterns. Simple, unique, and underappreciated.

**Choose languages with fast, simple feedback loops.** Armin (Jun 2025 and Feb 2026): Go's simple type system, structural interfaces, incremental testing, fast compilation, and low ecosystem churn make it unusually agent-friendly. His February 2026 post extends this into a broader thesis about designing languages *for* agents. Steipete's picks (TypeScript, Go, Swift) converge with this.

**Token efficiency is both a context AND cost optimization.** Mario's 225-token CLI tools vs. 13.7k-token MCP servers saves context AND money. Armin runs Sonnet instead of Opus. Anthropic's preprocessing hooks (`grep` for errors) is the infrastructure-level version of the same principle. At $100-200/month per developer, these savings compound.

---

## Things People Recommend but Can't Prove Work

**Parallel agents (3-8 simultaneously).** Steipete and Hashimoto both do this. It *feels* productive. But given the METR finding that AI-assisted coding involves more idle time and distraction, running multiple parallel agents may create more context-switching overhead than throughput gain. Nobody has measured this.

**Shorter prompts with better models.** Steipete reports prompts got shorter with GPT-5.2. This may be genuine model improvement or it may be the confidence trap the METR study identified: things *feel* easier, so you invest less, and you can't tell if results degraded.

**"Refactoring when tired" without constraints.** Fine if you can evaluate the results. Dangerous if you can't. Hashimoto's version (specific bounded tasks, evaluate next morning) is safer.

**Conversational planning as a replacement for written plans.** Steipete advocates conversational exploration over written specs. This works if you have strong architectural intuition. For others, Osmani's approach (brainstorm into `spec.md` before any code) provides a persistent artifact the agent can refer back to — and that survives compaction.

---

## The Hardest Truths

**Survivorship bias pervades everything.** The people writing blog posts are the people for whom agents work. We don't hear from developers who tried for months and went back to manual coding, or teams whose agent-built codebases became unmaintainable. The Opsera finding — seniors get 5x the gains of juniors — means this entire tips ecosystem is written by and for the people who need the tips least.

**The model-war framing is a distraction.** Every 6-8 weeks the leaderboard shifts. Steipete's Codex advocacy is already partially stale. The practitioners who age best (Armin, Hashimoto, Willison) focus on *process* — testing, planning, context management — not on which model they use. Build your workflow around principles that transfer across models.

**Nobody has data on long-term maintenance.** All the productivity gains are in *creation*. What happens when you need to debug production issues in 300k lines of code nobody fully understands? Willison already reports losing mental models of his own projects. This is the unpriced risk in the entire "ship fast with agents" approach.

**The review bottleneck is real and unsolved.** Armin's "Final Bottleneck" thesis: code generation was never the constraint. Human accountability is. AI makes writing faster but doesn't help you understand, review, or take responsibility for what was written. For solo developers, this manifests as lost mental models. For teams, it manifests as overwhelmed PR reviewers and 67% rejection rates. No current tooling solves this.

**Cost scales non-obviously.** The original document's tips are implicitly priced for affluent solo developers on Max plans ($100-200/month). Running 3-8 parallel Opus agents, as Steipete recommends, can cost significantly more on API pricing. Token efficiency isn't just elegant engineering — at scale, it's the difference between viable and not.

---

## Final Assessment

**The original document's best contributions:**
1. Mario's "prompts are code / state on disk" framework — durable, well-corroborated, genuinely explanatory
2. The MCP vs CLI analysis with actual token measurements — specific, actionable, independently validated
3. Steipete's tactical tips (CLI-first, screenshots for UI, cross-project references, many small changes) — practical regardless of one's philosophical stance on trust

**The original document's biggest error:** Presenting "ship code I don't read" as a legitimate general workflow rather than an extreme position that requires Steipete's specific 20+ years of systems taste to execute safely. Most top practitioners explicitly reject this. The evidence (METR perception gap, LinearB rejection rates, Yegge's production incidents) suggests it's riskier than it appears.

**The original document's most important gap:** The near-total absence of testing/verification as the central practice. The consensus position — from Willison, Hashimoto, Armin, Osmani, and Anthropic — is that closing the feedback loop (giving agents a way to verify their own work) is the single biggest productivity unlock. The document's emphasis on prompting, model choice, and context engineering is fine, but misses the foundation everything else rests on.

**Read the original document for:** context engineering specifics, the MCP/CLI analysis, the "prompts are code" framework, and Steipete's tactical tips.

**Read alongside:**
- **Willison, "Your job is to deliver code you have proven to work" (Dec 2025)** — the accountability framing
- **Hashimoto, "My AI adoption journey" (Feb 2026)** — the calibration methodology and ensemble approach
- **Ronacher, "The Final Bottleneck" (Feb 2026)** — why review capacity is the real constraint
- **The METR RCT (Jul 2025)** — the only rigorous evidence we have, including its limitations
- **Ronacher, "Agentic Coding Recommendations" (Jun 2025)** — the most complete single-author workflow description, still largely current

Together, these six sources give a genuinely balanced picture of agentic coding as it stands in February 2026 — powerful, fast-moving, poorly understood, and operating almost entirely on vibes.
