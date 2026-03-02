← [Dev Tools](../topics/dev-tools.md) · [Coding Agents](../topics/coding-agents.md) · [Index](../README.md)

# Pi as a Stateful Actor with A2A

**Date:** 2026-03-02
**Sources:** [Pi A2A integration analysis](pi-a2a-integration-analysis.md), [Durable Objects & Rivet Actors](durable-objects-rivet-actors.md), [Software Architecture AI Era](software-architecture-ai-agent-era.md), [Design Patterns Agent Future](design-patterns-agent-future.md), [HN Elixir Agent Frameworks](hn-elixir-agent-frameworks.md), [Durable Execution Landscape](absurd-durable-execution-landscape.md), A2A RC v1.0 spec, ActorCore/RivetKit docs, Google ADK/Interactions API, AgentMaster paper, Spring AI A2A patterns, [AI Coding Agents Feb 2026 Assessment](ai-coding-agents-feb-2026-deep-assessment.md).

---

## The Core Idea

**What if every Pi coding agent instance were a Rivet Actor / Durable Object — a globally addressable, persistent, single-threaded stateful actor — and spoke A2A as its network protocol?**

```
┌─────────────────────────────────────────────────────────────┐
│  The Internet / Enterprise Network                          │
│                                                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │ A2A      │  │ A2A      │  │ Human    │  │ CI/CD    │   │
│  │ Client   │  │ Agent    │  │ (Editor) │  │ Pipeline │   │
│  │ Agent    │  │ (Kiro)   │  │ (ACP)    │  │          │   │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘   │
│       │              │             │              │         │
│       └──────────────┴─────────────┴──────────────┘         │
│                          │                                  │
│                    A2A / ACP / HTTP                          │
│                          │                                  │
│  ┌───────────────────────┴────────────────────────────┐     │
│  │  Actor Runtime (Rivet / Cloudflare / ActorCore)    │     │
│  │                                                    │     │
│  │  ┌─────────────┐  ┌─────────────┐  ┌───────────┐  │     │
│  │  │ Pi Actor    │  │ Pi Actor    │  │ Pi Actor  │  │     │
│  │  │ agent-42    │  │ agent-99    │  │ agent-7   │  │     │
│  │  │ ┌─────────┐ │  │ ┌─────────┐ │  │ ┌───────┐ │  │     │
│  │  │ │Session  │ │  │ │Session  │ │  │ │Session│ │  │     │
│  │  │ │+ SQLite │ │  │ │+ SQLite │ │  │ │+SQLite│ │  │     │
│  │  │ │+ Tools  │ │  │ │+ Tools  │ │  │ │+Tools │ │  │     │
│  │  │ │+ Skills │ │  │ │+ Skills │ │  │ │+Skills│ │  │     │
│  │  │ └─────────┘ │  │ └─────────┘ │  │ └───────┘ │  │     │
│  │  └─────────────┘  └─────────────┘  └───────────┘  │     │
│  │     hibernates       working        hibernating    │     │
│  └────────────────────────────────────────────────────┘     │
└─────────────────────────────────────────────────────────────┘
```

Each Pi instance is a single actor with a globally unique ID, co-located persistent state (SQLite), single-threaded execution, hibernation when idle, an A2A Agent Card for discovery, and the full Pi toolkit (tools, skills, extensions) isolated per actor.

**Upfront honesty:** This is a well-sourced architectural exploration, not an engineering plan. The abstractions fit elegantly, but the market timing is wrong, the infrastructure is immature, and the most important problem (verification) isn't addressed. The value of this document is in mapping the possibility space and identifying the right abstractions for *when* — not *if* — multi-agent coding becomes a real production pattern.

---

## The Session-Actor Isomorphism

Pi sessions and stateful actors are structurally identical abstractions viewed from different traditions:

| Pi Session | Stateful Actor |
|------------|----------------|
| Unique session ID | Globally unique actor ID |
| JSONL history file | Co-located persistent storage |
| One active prompt at a time | Single-threaded message processing |
| `session.prompt()` | Actor receives message, processes, responds |
| `session.fork()` | Actor spawns child actor |
| `session.subscribe(events)` | Actor broadcasts events to subscribers |
| Extensions register tools/UI | Actor exposes actions |

Pi already *is* a stateful actor — it converged on the actor model because a coding agent is fundamentally a stateful, sequential, message-processing entity. The JSONL session files are co-located storage. The single-prompt-at-a-time constraint is single-threaded processing. The session tree (new/fork/switch) is actor lifecycle management.

**Caveats the mapping elides:**

- Pi's `session.fork()` creates a divergent conversation branch with *shared history*. Actor spawning creates an independent entity with *no shared state*. Different semantics.
- Pi's event subscription serves UI rendering (text deltas, tool progress). Actor broadcast serves state change notification. Overlapping but not identical purposes.
- Pi's "one prompt at a time" is a UX constraint (don't confuse the user). Actor single-threading is a consistency guarantee (no concurrent state mutations). Same behavior, different motivations, different relaxation paths.

The mapping holds at the level of "stateful message processors." It's almost tautological — most interactive stateful systems converge on actor-like patterns. That makes it *correct* rather than *deep*. But it's the right foundation: knowing that Pi is already an actor tells you the adaptation cost is lower than building from scratch.

---

## Why This Combination Is Compelling

### 1. Multi-Tenancy via Actor Isolation

The [A2A integration analysis](pi-a2a-integration-analysis.md) identified multi-tenancy as the hardest problem: Pi is single-user, single-project. A2A implies multiple clients. The stateful actor model dissolves this by design:

- One actor per user/project/session → physical isolation, not logical
- Each actor has its own SQLite → no shared state, no RLS nightmares
- Actors hibernate when idle → cost-efficient even with millions
- No shared `cwd` problem → each actor has its own filesystem context

The prior analysis struggled with these problems inside Pi's single-process architecture. Pushing them to the runtime layer is the right abstraction move.

### 2. A2A as Actor Message Protocol

A2A's task lifecycle maps naturally to actor message exchange:

| A2A Concept | Actor Equivalent |
|-------------|-----------------|
| Agent Card | Capability advertisement |
| contextId | Actor instance / session scope |
| taskId | Message correlation ID |
| message/send | Send message, await response |
| message/stream | Send message, subscribe to event stream |
| Task states | Actor processing lifecycle |
| Artifact | Actor output |

**Tension:** A2A treats agents as opaque black boxes. Coding agents *need* transparency — seeing tool execution, intervening mid-process, reviewing action traces. A2A's SSE streaming partially addresses this, but its data model lacks native concepts for "the agent is about to run `rm -rf /` — approve?" The INPUT_REQUIRED state handles "I need information," not "please review this dangerous action." Mapping Pi's rich interactive model to A2A's opaque delegation model is lossy compression. This is a fundamental protocol-level friction, not just an implementation gap.

### 3. ACP and A2A as Additive Transports

In the actor model, both protocols are just different message types arriving at the same actor:

```
A2A message → Actor → handleA2ATask()
ACP message → Actor → handleACPCommand()
Human input → Actor → handleInteractivePrompt()
```

This resolves the false dichotomy from the A2A analysis ("ACP first, A2A second"). An actor can serve an editor via ACP *and* other agents via A2A *and* a CI pipeline via HTTP — the runtime handles connections, the actor processes one message at a time. ACP and A2A are additive, not competing.

### 4. Multi-Agent Orchestration

Pi actors calling other Pi actors via A2A:

```
User → "Architect Agent" (Pi Actor)
         │
         ├── A2A → "Backend Agent" (writes API code, runs tests)
         ├── A2A → "Frontend Agent" (writes components, runs Playwright)
         └── A2A → "Review Agent" (read-only, reviews diffs from both)
```

Each Pi actor has real tool execution (bash, filesystem), persistent memory, physical isolation. Agents are heterogeneous — different skills, models, trust levels. The A2A protocol means agents can be replaced without breaking orchestration.

**What this isn't:** toy demos. This pattern is validated by the major vendors independently converging on it: Claude Code Agent Teams (Feb 2026, peer-to-peer messaging, specialized roles), OpenAI Codex (parallel threads with worktrees), Kiro (sub-agents with specialized roles). The industry evidence should give confidence in the *pattern* — even as it raises hard questions about whether an open-source version can compete.

---

## Three-Layer Architecture

### Layer 1: Actor Runtime (Infrastructure)

Rivet Engine / Cloudflare Workers / ActorCore — manages lifecycle, scheduling, persistence, networking.

**Critical constraint:** Pi needs bash/filesystem access. This eliminates Cloudflare DOs (128MB memory, no filesystem, no process spawning) and requires container-based actor runtimes. Rivet's container support is the most viable option, but **Rivet is not production infrastructure yet** — RivetKit latest is 2.0.42-rc.1 (not GA), the project has rebranded twice in a year (Rivet → Rivet Actors → ActorCore/RivetKit), ~5K GitHub stars with no evidence of large-scale production deployments. Building on this is a bet on a startup's pre-GA product.

### Layer 2: Pi Agent Core (Application Logic)

The coding agent itself — LLM loop, tools, sessions, extensions, skills. Largely unchanged from today, but with the persistence layer adapted from JSONL files to actor state, and filesystem access scoped to the actor's container.

**Underestimated adaptation cost:** AgentSession has deep assumptions about local filesystem, JSONL persistence, and interactive prompts. "Wrapping" it in an actor means either rewriting the persistence layer or building a compatibility shim that's itself complex. Pi wasn't designed for this operating mode.

### Layer 3: A2A Protocol Adapter (Network Interface)

Translation between A2A HTTP/JSON-RPC and the actor's internal protocol:

- Agent Card serving (`GET /.well-known/agent-card.json`)
- JSON-RPC 2.0 dispatch (`message/send`, `message/stream`, `tasks/get`, etc.)
- Content model translation (A2A Parts ↔ Pi messages)
- SSE streaming (Pi events → A2A events)
- Task lifecycle state machine — including the **hardest part**: the INPUT_REQUIRED ↔ extension UI bridge, where Pi's bidirectional extension protocol must be mapped to A2A's task state machine
- Auth (API keys, OAuth, mTLS)

---

## Patterns That Emerge

### Agent Specialization via Actor Templates

Specialized actor configurations — code reviewer (read-only tools), test writer (write access, test skills), architect (cross-project read-only, frontier model). Each advertises capabilities via its Agent Card. Orchestrators delegate by matching intent to capability.

### Agent Swarms via Actor Spawning

Orchestrator spawns parallel Pi actors for decomposed tasks (e.g., implementation + tests concurrently). Each child actor hibernates after completion.

**Reality check on parallel coding:** See [Hard Problems §2](#2-git-worktree-isolation-is-harder-than-it-looks) — merge conflicts, build dependencies between parallel changes, and worktree overhead are significant unsolved engineering problems, not just configuration.

### Institutional Memory as a Shared Actor

A non-coding memory actor storing learned patterns, team preferences, failure records, and architectural decisions. Coding actors query it at session start and write back at session end.

**Reality check:** "Semantic search" in a useful sense requires more than embedding + cosine similarity. Real institutional memory — pattern extraction, relevance decay, conflict resolution between competing patterns, cross-project generalization — is an open research problem, not a component you ship in a few weeks.

### Durable Multi-Step Workflows

Actor state persistence enables workflows that survive crashes — read codebase → plan → implement → test → fix → submit PR, with checkpoints between steps.

**Reality check:** LLM context windows aren't checkpointable the way database transactions are. When a crashed workflow resumes at step 5, the LLM doesn't have the reasoning context from steps 1-4. You either: (a) replay the full conversation history (paying for input tokens again — which is what Pi already does with JSONL), (b) store a summary and accept lossy resumption, or (c) accept that "checkpointing" for LLM agents mostly means "we saved the conversation and re-send it." The Absurd/Temporal model of skipping completed steps doesn't cleanly apply when "completed steps" are LLM reasoning turns that shaped subsequent decisions. You can skip *tool calls* (don't re-execute bash commands), but you can't skip the *reasoning* without degrading decision quality. The Elixir thread's "semantic supervision tree" insight applies: agent crash recovery is fundamentally harder than service crash recovery.

---

## Hard Problems

### 1. The Verification Gap (Biggest Issue)

The [architecture research](software-architecture-ai-agent-era.md) identifies verification as the #1 leverage point for agent systems. Stripe merges 1000+ agent-generated PRs/week because their verification harness catches errors *during* sessions. StrongDM kept the verification layer proprietary as their moat.

This brainstorm is all orchestration and memory, **zero verification**. How do you verify the Backend Agent produced correct code? That the Review Agent caught the bugs? That the Architect Agent decomposed the task correctly?

A fleet of unverified agents producing code in parallel isn't a productivity multiplier — it's a defect multiplier. The coding agents assessment says directly: *"AI generates code faster but with more defects. As agents produce more code in parallel, the review bottleneck gets worse, not better."*

**The orchestration architecture is useless without a verification layer.** And verification — automated tests after every edit, architectural fitness functions, LLM-as-judge quality gates — is higher-leverage work than any amount of distributed systems architecture. The architecture research: *"the verification harness, orchestration harness, and memory harness together constitute the system's real design."* Two of three pillars are addressed here. The most important one is missing.

### 2. Git Worktree Isolation Is Harder Than It Looks

Git worktrees are the right instinct for parallel agent filesystem isolation (Codex already uses them). But the brainstorm hand-waves the hard parts:

- **Merge conflicts.** Two agents editing overlapping files produce conflicts. Resolution requires understanding *both* changesets in context — either a human job or a third agent with both contexts loaded, which defeats the context-window argument for multi-agent decomposition.
- **Build dependencies.** Agent A edits `auth.ts` in worktree A. Agent B writes tests for `auth.ts` in worktree B against the *old* version. When merged, the tests are wrong. This is the classic parallel development coordination problem, solved in human teams by communication, not architecture.
- **Worktree overhead.** Full checkout per worktree. For large monorepos (100K+ files), non-trivial in time and storage. Actors are supposed to be lightweight; attaching a full repo checkout makes them heavy.
- **State divergence.** After worktree creation, the main branch moves on as other agents merge. The worktree becomes increasingly stale during long-running tasks. No sync mechanism described.

None are unsolvable, but each is a significant engineering problem.

### 3. Cost Reality

The original estimate was:
> 1000 actors × 50K tokens/task = ~$90/fleet operation

This assumes a single prompt/response cycle per task. Realistic coding sessions involve 5-20 LLM turns, each replaying growing conversation history, plus codebase reading and tool results:

**Corrected:** 1000 actors × 500K-2M avg total tokens/task × $3/M input = **$1,500-$6,000 for input alone**. Plus output tokens, plus Rivet compute. **Realistic fleet operation cost: $3,000-$10,000**, not $90. Retries multiply this.

The claim that "multi-agent can be cheaper (smaller specialist context windows)" is theoretically possible but empirically unvalidated. Decomposition overhead (orchestrator tokens, delegation messages, artifact transfer, merge resolution) may exceed window-size savings. Nobody has measured this in production.

### 4. Latency vs. Throughput Trade-off

A2A adds HTTP round-trips between agents. An orchestrator delegating to 3 specialists means 3 HTTP connections, 3 separate LLM inference sequences, 3 result transfers back, plus the orchestrator's own LLM calls to interpret results.

A single-agent approach processes everything in one LLM loop with local tool calls (sub-second latency for read/edit/bash). Multi-agent via A2A trades latency for parallelism.

For interactive coding (developer waiting), latency matters more than throughput. Multi-agent pays off only for tasks large enough that parallelism overcomes the coordination overhead — and only when the developer isn't waiting synchronously.

### 5. Error Cascading in Multi-Agent Systems

What happens when:
- The Backend Agent produces code that doesn't compile?
- The Review Agent incorrectly rejects valid code?
- The Architect Agent creates circular dependencies between agents?
- Two agents produce a merge conflict neither can resolve?
- The orchestrator runs out of context window coordinating 5 failed agents?

Multi-agent systems fail in combinatorial ways single-agent systems don't. Error handling isn't a "Phase 5" — it's the core problem. The Elixir thread's insight: you need *semantic* error recovery, not just retry.

### 6. Actor Granularity: Per-Task vs. Per-Agent

The conceptual code shows persistent state (sessionHistory, memory) suggesting per-*agent* actors, but the workflow diagrams show task-scoped actors spawned and destroyed. These are different architectures:

- **Per-task actors:** cheap parallelism, clean lifecycle (task done → destroy), no state growth. But no persistent memory, no cross-task learning.
- **Per-agent actors:** persistent memory, cross-session context. But harder lifecycle (when destroy? how to manage unbounded state growth?).

The right answer may be both — persistent agent actors for long-lived project context, ephemeral task actors for parallel work units. But this doubles the system's complexity and needs explicit design, not implicit conflation.

---

## The Competitive Reality

### Claude Code Agent Teams (Anthropic, Feb 2026)

Literally the same architecture — specialized agents with roles, peer-to-peer messaging, shared task coordination, worktree isolation. Built natively into Claude Code. Backed by the company that makes the model.

### OpenAI Codex Parallel Agents (Feb 2026)

Multiple agents in parallel threads, built-in worktrees, organized by projects. First-party product from the model provider.

### Kiro Sub-Agents (Amazon)

Specialized sub-agents with different roles, cross-session context persistence. Backed by AWS infrastructure.

**The hard question this brainstorm never asks:** Why build Pi-on-Rivet-with-A2A when Anthropic, OpenAI, and Amazon are shipping the same thing natively?

**Possible answers:**
- Open-source, self-hostable, vendor-neutral — avoids lock-in to one model provider
- A2A enables heterogeneous agents (Claude actor + GPT actor + open-source actor in one workflow)
- Extension/skill ecosystem allows customization the first-party products don't

These are real advantages. But they're advantages for a customer segment (platform builders who need vendor-neutral multi-agent coding infrastructure) that barely exists today. The first-party products will define the patterns; open-source implementations will follow once patterns stabilize.

---

## Realistic Effort Estimate

| Component | Optimistic LOC | Realistic LOC | Notes |
|-----------|---------------|---------------|-------|
| Pi Actor Adapter | 800 | 2,000-4,000 | AgentSession re-plumbing is the hidden cost |
| A2A Protocol Handler | 1,200 | 1,500-2,500 | Prior analysis was 1,500-2,200 standalone |
| Agent Card Generator | 200 | 200-400 | Mechanical |
| Task Lifecycle Manager | 300 | 600-1,200 | INPUT_REQUIRED ↔ extension UI bridge is hard |
| Container Template | 100 | 100-300 | Fair |
| Orchestrator Patterns | 500 | 1,500-3,000 | Error handling, retries, conflict resolution |
| Memory Actor | 400 | 1,000-2,000 | Semantic search is an open research problem |
| Tests + Docs + Ops | 0 | 3,000-6,000 | Not optional for infrastructure |
| **Total** | **3,500** | **10,000-18,000** | **3-5× original estimate** |

**Timeline:** 6-12 months for a team of 1-2 engineers, not 12-18 weeks. And that's assuming Rivet/ActorCore is stable enough to build on (currently pre-GA).

---

## What the Actor Runtime Actually Gives You

This table survives critique — it's the genuine value proposition:

| Feature | Without Actor Runtime | With Actor Runtime |
|---------|----------------------|-------------------|
| Session persistence | JSONL files in `~/.pi/sessions/` | Auto-persisted actor state (SQLite) |
| Multi-session management | Manual session tree, file I/O | One actor per session, lifecycle managed |
| Hibernation | Process dies, state lost | Actor hibernates, wakes on message |
| Scale-to-zero | Keep process running or lose state | Automatic, zero-cost idle |
| Concurrent agents | Spawn N processes manually | Runtime schedules millions |
| Working directory isolation | One cwd per process | One cwd per actor instance |
| Durability across deploys | State lost on redeploy | State persists through deploys |
| Multi-tenant isolation | Not supported | Physical isolation per actor |

Even if multi-agent coding never materializes, the actor model gives Pi better hosting semantics: zero-cost hibernation, persistent state, multi-tenant isolation, and lifecycle management. These are valuable for single-agent Pi-as-a-service.

---

## Verdict

### What's real

The architectural convergence is genuine. Pi sessions ≈ actors. A2A ≈ actor messages. Rivet targets AI agents as primary use case. The major vendors (Anthropic, OpenAI, Amazon) are independently converging on multi-agent coding with specialized roles and worktree isolation. The actor model is the right abstraction for coding agents.

The multi-tenancy solution (one actor per session) is clean and correct. The ACP/A2A additive framing resolves a real false dichotomy. The actor runtime provides genuine hosting benefits even for single-agent use.

### What's premature

- **Single-agent coding reliability is unsolved.** Building multi-agent orchestration on top of unreliable single agents multiplies defects, not productivity.
- **The verification layer is missing** — and it's the #1 leverage point per the architecture research. Without verification, the entire system is orchestrated defect generation.
- **Rivet is pre-GA.** Building production infrastructure on a rebranded startup framework that hasn't proven at scale is a bet, not a foundation.
- **A2A is Release Candidate.** Spec changes will break implementations.
- **The customer doesn't clearly exist** outside first-party vendor products.

### What to do now

1. **Invest in verification first.** A Pi extension that runs tests after every edit, enforces fitness functions, gates PR submission on quality checks. This is higher leverage than any distributed systems work. It's also a prerequisite — multi-agent orchestration is only useful if you can verify the output.
2. **Build a minimal PoC** — one Pi instance in a Docker container with a hardcoded A2A Agent Card and `message/send` only. Validates the AgentSession-in-container assumption at ~200 LOC. No Rivet dependency. No multi-agent.
3. **Watch and extract patterns** from Agent Teams, Codex parallel agents, and Kiro sub-agents. Let them spend the R&D budget defining which multi-agent patterns work in practice. Extract the patterns that survive contact with reality.
4. **Revisit in late 2026** when: (a) multi-agent coding has production data, (b) Rivet/ActorCore reaches GA, (c) A2A stabilizes past RC, (d) you have a verification layer to build on.

### What not to do now

- Build the full 5-phase system
- Commit to Rivet/ActorCore integration pre-GA
- Build the "coding service mesh" or "institutional memory actor"
- Treat the LOC estimates or timelines in this document as reliable

**Bottom line:** Beautiful architecture. The abstractions are right and will age well. But the market timing is 12-18 months early, the infrastructure is immature, and the highest-leverage work (verification) is orthogonal to everything proposed here. This document maps the destination correctly. The road there goes through verification first, not orchestration.
