← [Software Factory](../topics/software-factory.md) · [Index](../README.md)

# Absurd and the Durable Execution Landscape

**Subject:** Absurd vs Temporal vs DBOS vs Inngest vs Restate vs Hatchet — durable execution for agents and workflows
**Date:** February 2026
**Sources:** GitHub repos, Armin Ronacher's blog, HN thread (Nov 2025), DBOS comparison blog, leblancfg.com test writeup, Kai Waehner overview

---

## What Absurd Is

A durable execution system by **Armin Ronacher** (Flask, Jinja, Rye) built at his new company **Earendil** (PBC, Vienna, co-founded with Colin, Jan 2026). The entire system is a single SQL file (`absurd.sql`) applied to any Postgres database + thin client SDKs (TypeScript published, Python unpublished). Apache-2.0 licensed.

**Core thesis:** "Durable workflows are absurdly simple, but have been overcomplicated in recent years." No separate service, no compiler plugin, no runtime integration. Just Postgres.

**How it works:**
- Tasks dispatch onto queues via `SELECT ... FOR UPDATE SKIP LOCKED`
- Tasks decompose into sequential steps; each step is checkpointed in Postgres
- On crash/failure, the task retries from the last checkpoint — no re-executing completed steps
- Tasks can sleep (timers) or suspend for events (race-free cached events)
- Pull-based: workers poll Postgres for available work; no push coordinator
- Claims with timeout: worker claims a task for a duration, extended on each checkpoint; unclaimed tasks get reassigned

**Agent support:** Explicitly designed for LLM agent loops. The step auto-numbering (`iteration`, `iteration#2`, etc.) lets an agent iterate in a while loop with each LLM call checkpointed. If the process dies on step 5, steps 1-4 load from Postgres instantly. No duplicate API calls.

**Status:** Experimental. README says "should not be used in production." ~87 stars/week growth at launch (Nov 2025). SDKs: TypeScript, Python (unpublished). Built with significant AI assistance (Claude Code + Codex).

**Tooling:** `absurdctl` (Python CLI for queue management, task spawning, cleanup) and `habitat` (Go web UI for inspecting task state). Has `absurdctl agent-help` that outputs context for AGENTS.md/CLAUDE.md files.

---

## The Landscape: Absurd's "Friends"

### Temporal — The Incumbent

- **Architecture:** External orchestration. Separate Temporal server cluster + workers + your app. Workers communicate via gRPC. Multi-service deployment.
- **State store:** Cassandra, MySQL, Postgres, or SQLite. Not Postgres-only.
- **SDKs:** Go, Java, Python, TypeScript, .NET, PHP. Most mature ecosystem.
- **Model:** Replay-based determinism. Workflows must be deterministic; the system replays event history to reconstruct state. This imposes constraints — no random I/O in workflow code, side effects only in Activities.
- **Strengths:** Battle-tested at Uber, Stripe, Netflix. Signals, queries, updates on running workflows (actor-like). Workflow versioning. Temporal Cloud managed offering.
- **Weaknesses:** Heavy. Self-hosting means running a multi-service cluster. Rearchitecting your app: split into Temporal worker + API server + Temporal server. DBOS measured >100 lines of code changes for a 110-line app. Determinism constraints are a cognitive tax. Overkill for simple use cases.
- **License:** MIT (SDKs), server has its own license (core is open, some features require commercial).
- **Agent fit:** Works, but the determinism constraints and operational complexity make it a poor fit for small teams building agents.

### DBOS — The Other Postgres Purist

- **Architecture:** Embedded library. Annotate your existing code with decorators; DBOS handles checkpointing to Postgres. No separate orchestrator service.
- **SDKs:** Python, TypeScript, Java.
- **Model:** Annotation-based. Add `@DBOS.workflow()` and `@DBOS.step()` decorators. 7 lines of code to integrate into a 110-line app (their benchmark).
- **Strengths:** Lightest integration of any competitor. Postgres-only like Absurd. Built-in queues, crons, scheduling. Claims Fortune 500 production users. Active development.
- **Weaknesses:** Armin tried it and bounced — "excessive dependencies," global state in Python client, async passthrough issues, Flask dependency in the Python SDK. He found it "felt early." DBOS CEO actively engages on HN to counter this. SDK quality was improving as of late 2025.
- **License:** MIT.
- **Agent fit:** Good in theory — lightweight, Postgres-backed. In practice, SDK maturity was a blocker for Armin, who has high standards.

### Inngest — The Event-Driven SaaS

- **Architecture:** Event-driven workflow platform. Your code runs as HTTP endpoints; Inngest invokes them via secure HTTP calls, managing orchestration as a service.
- **Self-hosting:** Available since 1.0 (Sep 2024), fair-source-inspired license.
- **Model:** Everything is triggered by events. Step functions for checkpointing. Serverless-first.
- **Strengths:** Zero infrastructure for cloud users. Good DX. Handles concurrency, retries, rate limiting automatically. Self-hostable.
- **Weaknesses:** HTTP-based invocation adds latency. Fair-source license may concern some. If self-hosted, you're running their server (not just Postgres). Less control over queue mechanics. Vendor lock-in risk in cloud mode.
- **Agent fit:** Decent for serverless agent deployments. The HTTP model adds overhead vs. direct Postgres polling.

### Restate — The Distributed Systems PhD

- **Architecture:** Lightweight runtime (Rust) that turns functions into durable processes. Functions register as HTTP endpoints; Restate proxies calls and handles state.
- **SDKs:** TypeScript, Java, Kotlin, Go, Python, Rust.
- **Model:** Virtual objects (stateful entities addressed by key), durable promises, sagas. Low-latency bi-directional streaming.
- **Strengths:** Sub-millisecond overhead claims. Sophisticated distributed primitives. Virtual objects are actor-like. Runtime is Rust → efficient. BSL license (permissive, Amazon defense clause).
- **Weaknesses:** Requires running the Restate runtime (another service). More complex mental model than Absurd or DBOS. HN commenter: "Restate was built for agents before agents were cool. Surprisingly hasn't taken off yet." Possibly too sophisticated for its own adoption.
- **Agent fit:** Architecturally excellent for agents (virtual objects = agent sessions, durable promises = tool call results). But operational complexity is higher than Postgres-only solutions.

### Hatchet — The Background Task Runner

- **Architecture:** Distributed task queue with durable execution. Hatchet engine + workers. Postgres-backed.
- **SDKs:** Python, TypeScript, Go.
- **Model:** DAG-based workflows. Tasks logged durably to Postgres. Resume from specific steps on failure.
- **Strengths:** DAG workflows (not just sequential steps). Good for background task orchestration. Self-hostable (only need Hatchet engine).
- **Weaknesses:** Narrower than Temporal. Durable execution features seem "fairly recent" per Reddit user feedback. Less battle-tested. Evolving fast = API instability risk.
- **Agent fit:** Reasonable for agent task orchestration, but less agent-specific design than Absurd.

### `use workflow` (Vercel) — The Compiler Magic

- **Architecture:** Vercel-specific. SWC compiler plugin rewrites TypeScript code during build to add durability.
- **Model:** Magic directive (`"use workflow"`) transforms async functions into durable ones. Serverless deployment on Vercel.
- **Strengths:** Zero-boilerplate DX if you're on Vercel.
- **Weaknesses:** Vercel lock-in. Compiler magic = opaque. HN backlash over "magic strings." Not self-hostable. Not a general solution.
- **Agent fit:** Only if your agent lives on Vercel. Not relevant for self-hosted agent infrastructure.

---

## Comparison Matrix

| | Absurd | Temporal | DBOS | Inngest | Restate | Hatchet |
|---|---|---|---|---|---|---|
| **Infra needed** | Postgres only | Temporal cluster + DB | Postgres only | Inngest server or cloud | Restate runtime | Hatchet engine + Postgres |
| **Complexity** | Minimal | High | Low | Medium | Medium-High | Medium |
| **State store** | Postgres | Cassandra/MySQL/PG/SQLite | Postgres | Internal | Internal | Postgres |
| **SDK maturity** | Early (TS ok, Python unpublished) | Very mature | Improving | Mature | Mature | Improving |
| **License** | Apache-2.0 | MIT (SDKs) | MIT | Fair-source | BSL | MIT |
| **Agent-specific features** | Step auto-numbering, agent-help CLI | Signals/queries (general) | Decorators | Event-driven | Virtual objects | DAG workflows |
| **Self-host difficulty** | Trivial (just Postgres) | Hard | Trivial | Medium | Medium | Medium |
| **Production-ready** | No (experimental) | Yes | Yes (Fortune 500) | Yes | Yes | Emerging |
| **Code changes to integrate** | ~20 lines | >100 lines | ~7 lines | ~30 lines | ~30 lines | ~30 lines |

---

## The Agent Use Case — Why This Matters Now

Armin on HN: "Even back in the Cadence days I thought it was the hottest shit ever, but it was just too complex to run for a small company... And now, due to the problems that agents pose, we're all in need of that."

The agent problem is specific: LLM calls are expensive ($$), slow (2-60s), and unreliable (rate limits, timeouts). A 20-step agent loop where step 18 fails shouldn't re-execute steps 1-17. Traditional task queues (Celery, BullMQ) restart from scratch. Durable execution systems checkpoint each step.

leblancfg's test of Absurd with AI workloads (Dec 2025) validated the core value prop: "If you're building anything that makes LLM API calls, you know the pain... Absurd resumes from checkpoint three. You don't re-run (and re-pay for) work you've already done."

What leblancfg wanted to see: observability (no built-in metrics/tracing), dead letter handling (unclear poison message story).

---

## Honest Assessment

**Absurd's real advantage:** Not features — philosophy. It's the only system where you can go from "I have Postgres" to "I have durable execution" by applying one SQL file. No new services. No new infrastructure. No new deployment concerns. For self-hostable software (Armin's stated goal for Earendil products), this is a genuine differentiator — asking users to run Temporal is a big ask; asking them to have Postgres isn't.

**Absurd's real risk:** It's an experiment by one person (with AI assistance) at an early-stage company. No production users. No observability. No dead letter queue. Python SDK unpublished. If Armin's attention shifts to other Earendil priorities, this stalls. DBOS is attacking the same niche (Postgres-only, lightweight) with more funding, more SDKs, and claimed Fortune 500 production use.

**The DBOS rivalry is the interesting one.** Both want to be "durable execution on just Postgres." Armin tried DBOS and bounced on SDK quality. DBOS is improving fast. If DBOS gets its Python SDK right, Absurd's window narrows. But Absurd's "complexity lives in SQL, not the client" architecture is genuinely different from DBOS's "annotate your app code" approach. Absurd keeps the SDK thin; DBOS keeps the SQL thin. Different tradeoffs, same dependency (Postgres).

**For agent builders specifically:** If you're already on Postgres and want checkpoint-based durability without new infra, both Absurd and DBOS are worth evaluating. Absurd is simpler and more opinionated. DBOS is more feature-complete but heavier in the client. If you need production guarantees today, DBOS. If you want minimal complexity and can tolerate "experimental," Absurd. If you're at scale with complex orchestration needs, Temporal remains the default despite its weight. Restate is the dark horse — architecturally best-suited for agents but hasn't found mass adoption.

**Bottom line:** The durable execution space is converging on agents as the killer use case. Absurd is the most radically simple entry. Whether "radically simple" wins against "feature-complete" depends on whether Armin's thesis is right that this stuff has been overcomplicated. Given his track record (Flask proved the same thesis for web frameworks), I wouldn't bet against him.
