# GSD-2: Critical Review

**Repo:** [gsd-build/gsd-2](https://github.com/gsd-build/gsd-2)  
**Creator:** Lex Christopherson ([@glittercowboy](https://github.com/glittercowboy), aka TÂCHES)  
**License:** MIT  
**Reviewed:** 2026-03-18  
**Sources:** Local clone analysis (`git log`, `find`, `wc`, `rg`), GitHub repo, npm registry, Reddit, Brave Search.

---

## What It Is

GSD-2 is an autonomous coding agent CLI. You describe a project or feature, and it researches, plans, executes, commits, and verifies — in a loop, for hours, without human intervention. It's built as a [Pi SDK](https://github.com/badlogic/pi-mono) application (Mario Zechner's open-source agent toolkit, 24.6K stars, MIT-licensed).

The predecessor, GSD v1, was a collection of markdown prompt files for Claude Code's slash command system — a pure prompt-engineering framework. It went viral (32.2K stars). GSD-2 is a **fundamentally different product**: a standalone TypeScript application that programmatically controls the agent session rather than injecting prompts into someone else's tool.

The core innovation is a **disk-based state machine** (`.gsd/` files) that drives a fresh LLM session per unit of work. Each task gets exactly the context it needs injected at dispatch time, the context window is cleared between tasks, and the system reads disk state to determine the next step. This directly solves *context rot* — the quality degradation that plagues long-running LLM sessions.

```
npm install -g gsd-pi && gsd
```

---

## Architecture

### How it works

GSD wraps the Pi SDK's `createAgentSession()` to implement a loop:

1. **Read disk state** (`.gsd/` milestones, slices, tasks, summaries)
2. **Derive next unit** (research, plan slice, execute task, complete slice, reassess)
3. **Create fresh session** with focused prompt + inlined context from prior stages
4. **Execute** — the LLM does the work with standard coding tools (read, bash, edit, write)
5. **Close out unit** — write results to disk, commit, verify, advance state
6. **Repeat** until milestone complete or budget/timeout hit

Key subsystems: crash recovery (lock files + session forensics), worktree isolation (per-milestone git worktrees with squash merge), cost tracking (per-unit token/cost ledger), stuck detection (dispatch counting with lifetime caps), parallel orchestration (multi-worker milestone execution), and automated verification (user-defined commands with auto-fix retries).

Source: `auto.ts` (1,892 lines — the state machine core), plus ~25 focused modules split from it (`auto-stuck-detection.ts`, `auto-budget.ts`, `auto-recovery.ts`, `auto-worktree-sync.ts`, etc.).

### Code composition

| Component | Lines (TS) | Role |
|---|---|---|
| GSD extensions | ~84,000 | The product — autonomous loop, state machine, git, cost tracking, UI |
| GSD host code | ~4,000 | CLI loader, headless mode, onboarding wizard |
| GSD tests | ~60,500 | 202 test files (unit, integration, smoke, fixture, live) |
| Pi SDK (vendored) | ~91,000 | Agent session, LLM providers, TUI, tool execution |

GSD initially consumed Pi as a standard npm dependency (`@mariozechner/pi-coding-agent: ^0.57.1`). Two days after the public launch, the Pi source was vendored into `packages/` (commit `7d1e2cd2`) and rebranded `@gsd/*` to enable direct modifications. Since then, 205 files have been modified with ~25K lines of changes — this is an actively diverging fork, not a passive copy.

The vendoring is a **legitimate and common engineering choice** when you need to modify a dependency's internals. The trade-off is maintenance burden: Pi upstream is now at v0.59.0 while GSD is on v0.57.1 with growing divergence. See [Risks §3](#3-vendoring-drift).

Sources: `find ../gsd-2/{src,packages} -name '*.ts' -exec cat {} + | wc -l`, `git show 3bd2f8cb:package.json`, `git show 7d1e2cd2`, `git diff 7d1e2cd2..HEAD --stat -- packages/`.

---

## Code Quality

### Strengths

**Well-decomposed architecture.** The autonomous loop is split into ~25 focused modules instead of a monolith. Modules have clear responsibilities: `auto-stuck-detection.ts` handles dispatch counting and loop recovery; `auto-budget.ts` tracks spend and enforces ceilings; `crash-recovery.ts` manages lock files and PID liveness. The largest file (`auto.ts`, 1,892 lines) is the state machine core — large but justified by what it coordinates.

**Substantive tests.** 202 test files, ~60,500 lines. The test-to-code ratio for GSD extensions is 0.72:1, which is healthy for an open-source project. CI enforces coverage floors (50% statement, 20% branch — these are minimums, not targets). Test types span unit, integration, smoke, fixture recording, and live tests. The parser tests I examined test real markdown structures with edge cases and boundary conditions — not generated boilerplate.

**Clean codebase.** Only 6 TODO/FIXME/HACK markers across the entire GSD extension layer. Conventional commit messages throughout (91% of commits). Well-typed TypeScript with explicit interfaces (`StuckResult`, `CloseoutOptions`, `AutoSession`, `GSDState`).

**Genuine features solving real problems.** The feature list isn't vapor:
- **Crash recovery:** Lock files with PID liveness detection. On crash, the next session reads surviving session files and synthesizes a recovery briefing from every tool call that reached disk.
- **Stuck detection:** Per-unit dispatch counting with configurable lifetime caps. Attempts artifact recovery before stopping. Returns structured `StuckResult` objects (`proceed`, `recovered`, `stop`) rather than boolean flags.
- **Cost management:** Per-unit token/cost ledger, budget ceiling with enforcement, per-model cost breakdown.
- **Worktree isolation:** Each milestone gets a git worktree; sequential commits within; squash merge to main on completion.
- **Parallel orchestration:** Multi-worker milestone execution with NDJSON monitoring and per-worker budget enforcement.

Source: Direct code examination of `auto.ts`, `auto-stuck-detection.ts`, `crash-recovery.ts`, `session-lock.ts`, `parallel-orchestrator.ts`.

### Weaknesses

**14 files exceed 500 lines** in the extension layer. Some are justified (the state machine, the command registry). Others — `export-html.ts` (1,357 lines), `visualizer-views.ts` (1,117 lines) — appear to embed template/markup that could be externalized.

**Rapid release cadence limits soak time.** The CHANGELOG shows 66 versioned releases since the public repo's creation on March 10. Some single days saw 7–8 releases. While each release is tagged and changelogged, features inevitably ship with less production testing than weekly or biweekly cadences allow. The v2.27.0 release alone lists 20+ fixes — evidence that bugs are being found and fixed quickly, but also that they shipped in the first place.

**CI coverage thresholds are low for the domain.** 20% branch coverage as a CI gate is thin for a tool that autonomously manages git operations, spawns subprocesses, and controls LLM sessions. The raw test volume is good; the enforcement floor should be higher.

Sources: `find + wc -l` analysis, `CHANGELOG.md`, `package.json` test scripts.

---

## Competitive Landscape

GSD-2 occupies a specific niche: **autonomous, long-running coding agent sessions with programmatic control, running locally, at API cost.** Here's how it compares:

| Tool | Autonomy | Local/Cloud | Cost | Crash Recovery | Context Control |
|---|---|---|---|---|---|
| **GSD-2** | Full (hours-long loops) | Local | API cost (~$1-10/milestone) | Yes (lock files, session forensics) | Fresh session per task |
| **Devin** | Full | Cloud | $500/mo + ACUs | Yes (cloud-managed) | Proprietary |
| **Claude Code** | Semi (agent teams, Feb 2026) | Local | $20-200/mo | No | Manual compaction |
| **Aider** | Task-level | Local | API cost | No | Git-native diffs |
| **Cursor Agent** | Task-level | Local + Cloud | $20/mo+ | No | IDE-managed |
| **SWE-agent** | Full (research) | Local | API cost | No | Repository-level |

GSD-2's differentiation is **sustained autonomous execution with crash recovery and cost control, at API pricing**. Devin offers comparable autonomy at 25-50x the cost in a cloud-only model. Claude Code's agent teams (shipped February 2026) add multi-agent coordination but lack GSD's disk-based state persistence, fresh-session-per-task context management, and worktree isolation.

**The gap GSD fills is real.** Before GSD-2, running a coding agent for hours on a complex feature required either Devin's price tag or manually supervising Claude Code / Cursor sessions. GSD-2 offers a middle path: autonomous operation with programmatic guardrails, at commodity API cost.

Sources: [morphllm.com agent comparison](https://www.morphllm.com/ai-coding-agent) (March 2026), GSD-2 README feature matrix, Devin pricing page.

---

## Attribution and Licensing

GSD-2 credits the Pi SDK in multiple places:

- **README:** Two mentions with direct links to `github.com/badlogic/pi-mono`. The first paragraph of the architecture section: *"GSD is now a standalone CLI built on the Pi SDK."*
- **Reddit launch post:** *"Built on top of Mario Zechner's amazing Pi"* — attribution by name.
- **Vendored package metadata:** Each vendored package.json contains `"(vendored from pi-mono)"` in its description field.
- **Vendoring commit:** `7d1e2cd2` explicitly names *"pi-mono v0.57.1"* and documents the full vendoring rationale.

**One compliance gap exists.** Pi-mono has LICENSE files in individual package directories (confirmed via GitHub). These were not copied into GSD's `packages/` directories during vendoring. The root LICENSE claims sole copyright to Lex Christopherson. Under MIT terms, the original copyright notice should be preserved in all copies or substantial portions. This appears to be an oversight rather than intentional — the vendored package descriptions preserve provenance, and the creator openly credits Pi elsewhere. It should be fixed.

Sources: `rg -i 'mario|badlogic|pi-mono' ../gsd-2/README.md`, `cat LICENSE`, `cat packages/pi-ai/package.json`, Reddit post, GitHub browser inspection of `pi-mono/packages/coding-agent/` showing `LICENSE` file.

---

## Development Patterns

### Timeline

The public repository was created on 2026-03-10. The initial commit contained **41,602 lines across 137 files** — including 85 GSD extension files (17,892 lines) and a 2,032-line `auto.ts`. This was a pre-built codebase from private development; the actual development start date is unknown.

Since the public launch: 1,317 additional commits, 66 releases (v0.1.0 through v2.28.0), 321K lines added / 17K removed. The package version jumped from 0.3.3 to 2.3.5 on March 11 to align with the "GSD 2" product name — a common convention (cf. React 0.14 → 15.0, Angular 2.0).

### AI assistance

590 of 1,318 commits (45%) carry `Co-Authored-By` headers, predominantly Claude Opus 4.6. An additional 25 commits are from GitHub Copilot bots. The creator has been open about AI-assisted development: *"I don't write code — Claude Code does"* (GSD v1 README). The code quality evidence (see above) indicates this workflow produces well-structured, well-tested output.

### Community

41 contributors, 172 forks, ~2K stars in the first week. Beyond the primary maintainer (Lex Christopherson / TÂCHES, 797 commits / 60%), four contributors have substantial commit counts: Tom Boucher (119), Jeremy McSpadden (114 + 70 as "Flux Labs"), deseltrus (36), Facu_Viñas (21). 693 commits reference PR numbers, indicating active PR-based collaboration.

Sources: `git show 3bd2f8cb --stat`, `git log` analysis, `git shortlog -sn`, `rg '^\#\# \[' CHANGELOG.md`.

---

## Risks

### 1. Single primary maintainer

One person accounts for 60% of commits. While community contributions are growing, the project's direction, architecture, and release cadence depend on one maintainer. This is standard bus-factor risk for any young open-source project — not unique to GSD-2, but present.

### 2. Release cadence vs. stability

66 releases in 8 days of public history. The rapid cadence delivers features and fixes quickly but limits production soak time between releases. Users adopting GSD-2 today should expect frequent updates and occasional regressions — typical of early-stage, fast-moving projects.

### 3. Vendoring drift

Pi upstream is at v0.59.0; GSD vendored v0.57.1 and has modified 205 files (+25K/-2K lines). As both projects evolve, the divergence grows. GSD must either: (a) periodically rebase on upstream Pi releases (expensive, gets harder over time), (b) maintain a permanent fork (ongoing burden), or (c) eventually contribute changes upstream and return to consuming Pi as a dependency. This is the classic vendoring trade-off and the most significant long-term structural risk.

### 4. ToS ambiguity

A Reddit commenter raised whether GSD's use of OAuth flows (e.g., Claude Max subscriptions) to power autonomous agent loops may conflict with provider terms of service. GSD supports 20+ LLM providers and API key auth, so this is a provider-specific concern rather than a fundamental limitation — but users should verify their provider's terms.

Sources: `git shortlog -sn`, `git diff 7d1e2cd2..HEAD --stat -- packages/`, Reddit thread.

---

## v1 → v2: Same Name, Different Product

GSD v1 (32.2K stars) was a lightweight prompt collection: `npx get-shit-done-cc` installed markdown files into `~/.claude/commands/`. Zero dependencies. Worked immediately inside Claude Code. Its appeal was simplicity.

GSD v2 is a full TypeScript application (~240K lines including vendored Pi). It replaces Claude Code as the runtime. Requires `npm install -g`. Has its own onboarding wizard, configuration system, extension layer, and TUI.

A migration command exists (`/gsd migrate`) that converts `.planning` directories to `.gsd` format. But the user experience is fundamentally different — v2 is a new tool, not an upgrade. The shared name carries v1's reputation into v2's launch, which gives it early traction but also sets expectations it has to earn independently.

---

## Token Efficiency

GSD's most frequent criticism is token consumption. Detailed architectural analysis in [User Experiences: Token Efficiency](gsd-2-user-experiences.md#token-efficiency-architectural-analysis).

**Summary of findings:**

The token burn is **structural, not a design flaw.** GSD automates a multi-session workflow that experienced developers already perform manually — breaking work into tasks, starting fresh sessions, re-injecting context, verifying output. The token cost is equivalent; GSD makes it visible.

The multi-session approach is the correct trade-off given current LLM context window limitations. Long-running sessions degrade; fresh sessions with re-injected context don't. The cost is repeated context injection per session.

The deeper variable is **codebase modularity**: GSD's token cost scales with coupling, not just project size. Well-modularized projects with clear interfaces give each executor exactly the context it needs. Tightly coupled codebases balloon context requirements and trigger re-planning cycles. This directly explains why GSD succeeds on greenfield and fails on brownfield — greenfield projects can be designed for the modularity that makes task-level isolation efficient, while brownfield codebases often lack it.

GSD-2 includes token optimization (v2.17): budget/balanced/quality profiles providing 40–60% / 10–20% / 0% reduction through phase skipping, context compression, and complexity-based model routing.

---

## Verdict

**GSD-2 is architecturally sound, genuinely differentiated, and early-stage.**

It identifies a real problem — long-running LLM sessions degrade without programmatic context control — and solves it with a well-designed disk-based state machine. The fresh-session-per-task architecture pays a visible token cost in exchange for clean, focused context on every unit of work. This is the same trade-off any experienced developer makes when manually restarting sessions — GSD systematizes it.

The extension layer (~84K lines) is original, well-decomposed, and substantively tested (~60K lines of tests). The feature set (crash recovery, cost tracking, stuck detection, worktree isolation, parallel orchestration) addresses pain points that no other tool at this price point currently solves.

The most underappreciated design property: **GSD's effectiveness is proportional to codebase modularity.** Projects with clear separation of concerns, well-defined interfaces, and minimal cross-cutting dependencies give GSD's executors exactly the context they need — making it both cheaper and more reliable. Tightly coupled codebases make every task expensive and error-prone. GSD makes poor architecture immediately and visibly costly, which may be a feature rather than a limitation.

The primary risks are structural, not qualitative: vendoring drift from Pi upstream, dependence on one primary maintainer, and a release cadence that trades soak time for speed. These are normal early-stage risks that can be managed as the project matures.

**For users considering adoption:** GSD-2 offers real autonomous capabilities at API cost. Best fit: large greenfield projects with well-specified requirements. Poor fit: brownfield codebases with tight coupling, small tasks, or budget-constrained use. Token profiles (`budget`/`balanced`/`quality`) allow tuning cost vs. thoroughness. Expect a fast-moving project with frequent releases — pin your version if stability matters.

**For the ecosystem:** GSD-2 validates the Pi SDK's extensibility thesis — that a well-designed agent toolkit enables third parties to build differentiated products on top. Whether GSD ultimately stays vendored or returns to consuming Pi as a dependency will be an interesting signal about the SDK's boundaries.
