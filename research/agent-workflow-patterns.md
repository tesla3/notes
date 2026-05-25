# Agent Workflow Patterns

*Practitioner workflows, tooling, and process patterns specific to agentic coding. Snapshot-level — patterns here change with model capabilities and tooling. Durable structural insights belong in [insights.md](../insights.md); this file collects the operational practices that implement or work around those insights.*

*Started: March 2026*

---

## Review Gate Taxonomy

Review gates in agent workflows exist at four layers. Almost all current practice sits at layers 1-2. Layer 4 has been attempted twice; one shipped, one caused a production database outage.

### Layer 1: Inherited infrastructure — universal, accidental

GitHub branch protection, CI status checks, and merge rules designed for human-to-human workflows accidentally gate agents. A GitHub community discussion (Feb 2026) revealed it's structurally impossible to exempt Copilot: it cannot sign commits, cannot approve PRs, and ruleset exemptions don't override these requirements. The user concluded they'd have to "completely relax the commit signing requirement... which effectively makes that ruleset useless."

Every team using protected branches has agent review gates by default — not because anyone designed them for agents, but because the infrastructure was already there.

### Layer 2: Process conventions — common among serious practitioners

- **incident.io** (shared_ptr, HN): 4-5 parallel Claude Code agents via git worktrees, treated as "a distributed team of junior developers." Human reviews and merges. Plan Mode used for confidence, not access control. Nothing *prevents* the agent from committing.
- **dev.to "wf-03"** (danielbutlerirl): "The agent never commits. The human reviews and commits." One task per session, commit-sized changes to keep the reviewer in "verification mode instead of plausibility mode."
- **Simon Willison's anti-patterns** (Mar 2026): "Don't file PRs with code you haven't reviewed yourself." Social norm aimed at humans, not a mechanism that stops agents.

### Layer 3: Automated quality gates — growing, vendor-driven

Qodo, pr-agent, CodeQL-on-every-PR, and Nx's self-healing CI add automated review as a merge prerequisite. These block merges if scans fail or coverage drops — real architectural gates, but they validate code quality mechanically, not human understanding. The agent equivalent of linters: useful, but don't force a human to understand the change.

The HuggingFace "2026 Agentic Coding Trends" guide describes the idealized version: a state machine (INTENT → SPEC → PLAN → IMPLEMENT → VERIFY → REVIEW → RELEASE) where "agents may advance states only when deterministic gates pass and policy allows." Aspirational, not a shipped tool.

### Layer 4: Harness-enforced human approval — extremely rare

**hsaliak's std::slop mail-model** ([github](https://github.com/hsaliak/std_slop/blob/main/docs/mail_model.md)). Linux kernel-style patch → review → merge built into the agent harness. Key mechanisms:

- `write_file` prohibited on protected branches via system prompt + skill constraints
- All work on staging branches, atomic commits with mandatory rationale blocks
- Agent presents patch series via `git format-patch` with cover letter
- Human reviews in editor, drops inline `R:` comments under patch headers
- Agent maps comments to correct commit, applies fixup + rebase
- **Series walk**: build/test at every commit in the series (bisect safety)
- `/review mail approve` required before `git_finalize_series` — approval is a hash signature that's invalidated by any subsequent change
- Agent literally cannot merge without verified human approval matching current HEAD

**Yegge's Gas Town "Refinery"** — attempted agent-managed merge queue. **Failed.** "One user described it as 'riding a wild stallion' after it autonomously merged PRs despite failing integration tests. His production database went down for two days when an agent erased passwords." Counter-evidence: the one other attempt at agent-level merge control produced a disaster.

### Assessment

No mainstream agent tool (Claude Code, Cursor, Codex, Aider) has built-in review gating. All assume external git workflow management. No CI/CD platform has agent-specific merge policies. The mail-model's transferable ideas — bisect-safe series walks, rationale blocks per commit, hash-verified approval — could be extracted from the kernel-style ceremony and applied to lighter workflows.

The mail-model becomes load-bearing when: (a) agents run autonomously overnight, (b) multiple agents share a codebase, or (c) the organization needs auditability beyond "someone approved the PR." These conditions are emerging but not yet widespread.

Connects to: [Bottleneck Migration](../insights.md#bottleneck-migration) (review is the downstream bottleneck after generation cost collapses), [Naur's Nightmare](../insights.md#naurs-nightmare) (rationale blocks are synthetic breadcrumbs — partial theory externalization), [Liability Acceleration](../insights.md#liability-acceleration) (bisect-safe commits make agent code more auditable/reversible).

---

## Parallel Agent Execution

### Git worktrees as isolation primitive

**incident.io** (Dec 2025 blog post): Team runs 4-5 Claude Code instances concurrently, each in its own git worktree. Built a bash function `w` that creates worktrees, manages branches, and launches Claude Code in one command (`w myproject feature-name claude`). Worktrees share a single `.git` directory — no duplication overhead. Each agent conversation stays completely isolated.

**Yegge's Gas Town** (Jan-Feb 2026): 20-30 parallel agents using worktrees as "propulsion mechanism." Each worktree has persistent state surviving agent restarts. "Molecules" — chains of sequenced atomic tasks — are persistent across crashes because they're backed by git. Scale: 44,000+ lines merged from 50 contributors in 12 days. But "extremely alpha" — reliability issues documented above.

### One task per session

**dev.to "wf-03"**: Agent reads one `task-N.md`, executes checklist, verifies gates, records discoveries, stops. Human reviews and commits. Loop repeats. "The loop ends when all gates in `gates.md` are satisfied. Not when 'all tasks are complete.' Tasks are scaffolding. Gates define the contract."

**METR Staff A** (Feb 2026 transcript analysis): 10+ concurrent terminal sessions, git worktrees for parallel PRs, pre-written detailed plans and verification instructions, "Ralph Wiggum" loops (agents running autonomously 1-3+ hours). The 13x time savings outlier. See [Hidden Denominator](../insights.md#hidden-denominator) for why this investment is rarely counted.

---

## Test-Driven Agent Workflows

### Red/green TDD (Willison)

Write failing test → agent implements → verify test passes. The practical floor for agentic verification. Makes cheating less likely but not structurally impossible. See [distillation](hn-agentic-engineering-patterns-2026-03.md) insight #1 for the tautological test problem and why this is necessary but not sufficient.

### Lint-test sandwich (Juminuvi, HN Mar 2026)

Test fail → implement → linter → test pass. Adding a lint step between implementation and test verification fails faster on mechanical errors before burning test-execution time.

### Playwright checkpoints (tr888, HN Mar 2026)

For web apps: ask the agent to build sensible checkpoints and validate at each using Playwright. "Prevents the agent from straying off course and struggling to find its way back." Plan mode first, review plan for checkpoint evidence.

### Mutation testing as adversarial verification

Thread convergence (Mar 2026): `alkonaut` proposes forcing minimal code changes to break individual tests. `ndriscoll` names the formal dual (mutation testing). `lbreakjai` points to existing frameworks. If a test still passes after the code is mutated, the test is useless. Not yet integrated into any agent harness as a standard step.

---

## Codebase Comprehension Patterns

### Structured codebase onboarding (nishantjani10, HN Mar 2026)

Prompt: "Deeply understand this codebase, clearly noting async/sync nature, entry points and external integration. Once understood prepare for follow up questions from me in a rapid fire pattern, your goal is to keep responses concise and always cite code snippets to ensure responses are factual and not hallucinated. With every response ask me if this particular piece of knowledge should be persistent into codebase.md"

Progressive Q&A builds understanding with citation-grounded answers. The "persist to codebase.md" step externalizes the agent's codebase model into a durable artifact. `onionisafruit` (HN) tried a variation and confirmed: "Quick, correct answers instead of waiting for it to do exploration for each answer."

### "Brain dump" variant (cmer, GitHub gist, ~Aug 2025)

[Multi-phase prompt](https://gist.github.com/cmer/2a9b78d2145204eedf1029e9305e3e50) that has the agent explore the codebase systematically, produce a `CODEBASE_KNOWLEDGE.md`, and maintain a `STATE BLOCK` for continuity across sessions. Much more elaborate: chunking strategies (`CHUNK_ID = PATH#START-END#HASH8`), import/call maps, Mermaid diagrams, prioritized file classification, and structured phases. The output is designed explicitly so "another LLM can use it to onboard." The most complete implementation of agent-discovered knowledge persistence found.

### AGENTS.md / CLAUDE.md as declarative counterpart

The broader ecosystem has converged on standardized instruction files — AGENTS.md described as "a README for agents." OpenAI's own repo uses 88 nested AGENTS.md files. Tens of thousands of repos adopt the format. This is the *declarative* variant: humans write the knowledge document upfront to instruct the agent. nishantjani10 and cmer are the *exploratory* variant: agent discovers, human curates, result persists. cmer's brain dump bridges the two: agent explores → produces structured doc → doc serves as future agent context.

### Structural risk: documentation rot

These documents rot. If the agent discovers something and persists it to codebase.md, but the code changes next week, the persisted knowledge is wrong. Who maintains the knowledge doc as the code evolves? This is [Liability Acceleration](../insights.md#liability-acceleration) applied to documentation. The smallbit.dev AGENTS.md guide acknowledges: "One-off tasks stay in the prompt. Instruction files remain focused on persistent, reusable knowledge." But the boundary between "persistent" and "stale" is fuzzy and nobody has a maintenance strategy beyond manual curation.

### Numbered tree walkthrough (winwang, HN Mar 2026)

Ask agents for a numbered tree of the codebase. Control tree size to specify granularity. Numbering enables simple reference in follow-up discussion ("expand node 3.2"). Simon Willison's "linear walkthroughs" pattern is the guided version.

---

## Agent Steering Patterns

### Strict typing + hook-based tool denial (winwang, HN Mar 2026)

- Very strict typing/static analysis as agent guardrails
- Deny tool usage with a hook that tells the agent *why* it was denied and *what* it should do instead (vs. simple denial or dangerous accept-all)
- Use different models for code review vs. generation

### Observability before sophistication (bhekanik, HN Mar 2026)

"If I can't explain why an agent made a decision from logs alone, it's not production-ready yet." Rule of thumb: single-agent flow with strict tool contracts, replayable traces, and a small regression suite beats a multi-agent architecture you can't reason about.

**Why people aren't doing it despite it being "obvious":** The tooling barely exists. Claude Code, Cursor, Codex — the mainstream tools — emit no structured traces. You get terminal output and nothing else. LangGraph has time-travel debugging. Yegge's Gas Town added OpenTelemetry in v0.8.0 (Feb 2026). But the agent observability space is brand new — Arize published "Best AI Observability Tools for Autonomous Agents" 5 days ago; dev.to's "What Is Agent Observability?" is 3 days old. Databricks found tool-calling accuracy swings 10% just from changing temperature — and most teams don't know this.

**Will it pass like MCP?** Unlikely. MCP is a protocol (specific, substitutable). Agent observability is a category (structural), like "monitoring" for web services. Specific tools will churn, but "understand what your agent decided and why" is as durable as "monitor your production services." It's the agent equivalent of the 2010s observability movement (Honeycomb, Datadog) — took years to become standard despite being obvious.

**Assessment:** The principle is durable but currently trivial to state and hard to implement. A corollary of the [architecture doc](software-architecture-ai-agent-era.md)'s reviewability-first pattern and InfoWorld/Charity Majors' insight that observability replaces authorship. Becomes interesting when tooling catches up.

### Subagent calibration — not "raising" (noisy_boy, HN Mar 2026; multiple independent sources)

`noisy_boy`: "If I'm seeing a subagent doing weird stuff across many executions, I can't build much in terms of layers on top of it." One-step-at-a-time: get each agent reliable, then orchestrate.

**Independently convergent.** The eesel.ai Claude Code multi-agent guide: "Start with one or two specialized agents and add others only when you have clear use cases. Limit yourself to three or four subagents maximum. More than that decreases productivity." agenticengineer.com: "You don't start with 30 agents, you start with 1, then 2, then 3." Shipyard best practices: "List the agent's weaknesses in its system prompt." Claude Code subagents (v1.0.60+) literally force this pattern — you define one subagent at a time via a markdown file.

**The "raising" metaphor is appealing but misleading.** It implies the subagent *improves over time* — learns from corrections, builds trust. That's not what happens. Current subagents are stateless between sessions. You're not raising a child; you're writing a better job description through iteration. The right abstraction is **calibration**: run the subagent on representative tasks, observe failure modes, tighten the system prompt and tool permissions, repeat until the error rate is acceptable for unsupervised operation. Same process as calibrating any automated system.

**What doing it right looks like (synthesized):**

1. Start with one subagent solving one well-defined problem
2. Run it on 10-20 representative tasks, review every output
3. Document failure modes in the system prompt itself ("you struggle with X, don't attempt it")
4. Restrict tools to minimum necessary (don't give a code reviewer write access)
5. Only add a second subagent when the first is reliable across diverse inputs
6. Max 3-4 subagents — beyond that, orchestration overhead exceeds value (multiple independent sources converge on this number)

**Durability:** The specific mechanism (markdown YAML frontmatter) is ephemeral. The principle — calibrate automated components individually before composing them — is basic systems engineering applied to a new domain.

---

## Edge Cases and Domain-Specific Findings

### Edge/embedded devices (krasikra, HN Mar 2026)

"Test coverage on x86 means nothing when your agent hits OOM on a Xavier at 3AM because someone let the LLM generate unbounded batch sizes." ARM-specific bugs, thermal constraints, and memory limits don't surface in standard CI. Agent-generated code for Jetson-based systems requires target-hardware testing. No existing notes cover embedded/edge agentic coding.

### WASM via Zig (Thews, HN Mar 2026)

Moved to [agent-era-tooling.md](agent-era-tooling.md).

---

## Sources

| Pattern | Source | Date | Evidence quality |
|---------|--------|------|-----------------|
| Review gate taxonomy | Web research + HN thread 47243272 | Mar 2026 | Multi-source synthesis |
| Mail-model | [hsaliak/std_slop](https://github.com/hsaliak/std_slop/blob/main/docs/mail_model.md) | Mar 2026 | Shipped tool, single author |
| Gas Town failure | [mikemason.ca](https://mikemason.ca/writing/ai-coding-agents-jan-2026/) | Jan 2026 | Reported by third party |
| incident.io worktrees | [incident.io blog](https://incident.io/blog/shipping-faster-with-claude-code-and-git-worktrees) | Dec 2025 | Team blog, detailed |
| One task per session | [dev.to/danielbutlerirl](https://dev.to/danielbutlerirl/designing-agentic-workflows-the-core-loop-166d) | Feb 2026 | Individual practitioner |
| METR Staff A | [METR transcript analysis](https://metr.org/notes/2026-02-17-exploratory-transcript-analysis-for-estimating-time-savings-from-coding-agents/) | Feb 2026 | Research org, n=7 |
| Red/green TDD | [Willison guide](https://simonwillison.net/guides/agentic-engineering-patterns/red-green-tdd/) | Feb 2026 | High-credibility practitioner |
| Subagent calibration | [eesel.ai guide](https://www.eesel.ai/blog/claude-code-multiple-agent-systems-complete-2026-guide), [agenticengineer.com](https://agenticengineer.com/top-2-percent-agentic-engineering), noisy_boy HN | Jan-Mar 2026 | Multiple independent convergence |
| Codebase brain dump | [cmer gist](https://gist.github.com/cmer/2a9b78d2145204eedf1029e9305e3e50), nishantjani10 HN | Aug 2025, Mar 2026 | Individual practitioners, confirmed by onionisafruit |
| AGENTS.md ecosystem | [aruniyer.github.io](https://aruniyer.github.io/blog/agents-md-instruction-files.html), [smallbit.dev](https://blog.smallbit.dev/2025/11/27/agents-md-how-to-guide-your-coding-agents/) | Nov 2025-Mar 2026 | Tens of thousands of repos, broad adoption |
| Agent observability | [dev.to](https://dev.to/mostafa_ibrahim_774fe947b/what-is-agent-observability-traces-loop-rate-tool-errors-and-cost-per-successful-task-bl5), [arize.com](https://arize.com/blog/best-ai-observability-tools-for-autonomous-agents-in-2026/) | Mar 2026 | Emerging field, tooling nascent |
| Edge device failures | krasikra, HN 47243272 | Mar 2026 | Single anecdote |
