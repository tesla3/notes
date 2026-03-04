← [Coding Agents](../topics/coding-agents.md) · [Index](../README.md)

# Distributed Systems Lessons for Parallel Agent Coordination

**Origin:** Analysis of [HN parallel coding agents thread](hn-parallel-coding-agents-tmux-47218318.md) (June 2026), extended with NERDs paper framing (tdaltonc, HN), Dria mem-agent paper (HuggingFace, Oct 2025), and first-principles reasoning.

**Core claim:** Parallel agent orchestration is rediscovering distributed systems coordination problems — consistency, ownership, conflict resolution — without the vocabulary or formal protocols that 40 years of distributed systems theory already provides. The vocabulary gap matters: knowing to search for "optimistic concurrency control" or "saga pattern" connects you to decades of literature on the tradeoffs.

---

## The Eight Parallels

### 1. Shared Mutable State — The Original Sin

In distributed systems, concurrent writers to shared state is *the* hard problem. Multiple agents modifying the same codebase is concurrent writes to a shared data store. CloakHQ's observation — "agents that 'know' different versions of reality by the second hour" — is literally **split-brain**: two nodes that diverge because they can't see each other's writes.

The thread's convergent solution ("don't sync, own") is **data partitioning/sharding**. briantakita's agent-doc, Schipper's one-spec-one-agent, worktrees — all partition the write space so agents never contend on the same files. This is the same reason databases shard: eliminate write conflicts by ensuring only one writer owns each partition.

### 2. CAP Theorem Analog

The CAP theorem says you can't simultaneously have Consistency, Availability, and Partition tolerance. The parallel agent version:

- **Consistency** = codebase coherence (no contradictory changes)
- **Availability** = agents can always make progress (aren't blocked waiting)
- **Partition tolerance** = agents work independently (no shared state)

Schipper chose AP (available + partition tolerant): agents work independently on worktrees, consistency deferred to merge time. This is **eventual consistency**. The cost: merge hell. ramoz explicitly abandoned this tradeoff and went back to a single agent (choosing CP — consistent + partition tolerant, sacrificing availability/parallelism).

### 3. Consensus Protocols and the Spec as a Raft Log

The FD spec file functions as a **consensus artifact** — like a committed entry in a Raft or Paxos log. Everyone (human + agents) agrees on the spec *before* work begins. This is **leader-based consensus**: the human is the leader, the spec is the committed log entry, agents are followers who execute but don't modify the agreed state.

gck1 makes this explicit: *"spec (human in the loop) → plan → build. Spec can't be changed by agents."* The `/fd-deep` command (4 Opus agents exploring design angles) is essentially a **consensus round** — multiple nodes propose, the leader (human) decides.

### 4. Coordination Cost and Universal Scalability Law

Neil Gunther's Universal Scalability Law says throughput doesn't scale linearly with workers because of two penalties: **contention** (waiting for shared resources) and **coherence** (keeping everyone synchronized). At some point, adding workers *decreases* throughput.

The ~8 agent ceiling is exactly this. With 2-3 agents, coordination cost is low. At 8, the human spends more time managing context drift than agents save on implementation. Past 8, Schipper says quality *decreases*. This is the coherence penalty dominating. sluongng's H2A ratio framework is groping toward the same math.

### 5. Optimistic vs Pessimistic Concurrency Control

- **Pessimistic**: lock resources before writing (prevent conflicts). In agent terms: strict ownership, deny-lists, one agent per module.
- **Optimistic**: let everyone write, detect and resolve conflicts after. In agent terms: worktrees, parallel implementation, merge later.

The thread overwhelmingly uses optimistic concurrency — and pays the merge conflict tax. aceelric's supervisor agent that handles merging and cherry-picking is a **conflict resolution layer**, like a database's merge/rollback mechanism.

### 6. Saga Pattern and Compensating Transactions

The FD lifecycle (Planned → Design → Open → In Progress → Pending Verification → Complete) is a **saga** — a sequence of local transactions where each step can fail and trigger compensating actions. `/fd-verify` catching bugs is a compensating transaction. The Deferred and Closed states are saga abort paths. Sagas are how distributed systems handle long-running operations that can't be wrapped in a single atomic transaction.

### 7. Event Sourcing vs Current-State (The Deep Problem)

tdaltonc's NERDs paper (entity-centered memory) vs chronological context windows maps to **state-based replication vs event sourcing**:

- **Event sourcing**: store the sequence of events (chronological context window, conversation history). Reconstruct current state by replaying.
- **State-based**: store current state directly (NERDs: "what is X right now?"). No replay needed.

CloakHQ: *"agents care about 'what is the current state of X' not 'what happened in what order'."* Event replay is O(n) in history length and hits context window limits. State-based is O(1) per query. This is why compaction (lossy event log compression) keeps failing — it's solving a problem the wrong data model created.

#### What Is "State" in a Codebase?

A codebase isn't a database. In a distributed database, "state" is well-defined: rows in tables, values at keys. Git does this for files — but files are *syntactic* state. The raw bytes.

Agents don't need syntactic state. They need to know: What does the auth module *do*? What contract does this API expose? What invariants must hold after my change? That's **semantic state** — and nothing in the standard toolkit captures it.

**Three levels of state in a codebase:**

| Level | What it captures | Who tracks it | Queryable? |
|-------|-----------------|---------------|------------|
| **Syntactic** | File contents, line diffs | Git | Yes (git diff, grep) |
| **Semantic** | What entities do, their contracts, dependencies | Nobody — lives in developers' heads | No |
| **Process** | What's being worked on, decided, planned | Spec files, issue trackers | Partially |

Current parallel agent setups only handle level 1 (git/worktrees) and level 3 (FD specs, markdown plans). Level 2 — the semantic layer — is the missing piece.

#### How NERDs Approaches It

tdaltonc describes NERDs as *"Wikipedia-style docs that consolidate all info about a code entity (its state, relationships, recent changes) into a single navigable document, cross-linked with other documents."* Each entity document answers: **what IS this thing right now?** An agent can read `auth-module.md` and know the current contracts without parsing 50 source files.

The Dria mem-agent paper (HuggingFace, Oct 2025) implements a strikingly similar pattern: `user.md` + `entities/*.md` with Obsidian-style cross-links. A 4B parameter model trained with this scaffold outperforms GPT-5 and Claude Opus on memory retrieval tasks. The entity structure is doing heavy lifting.

#### Why Entity Documents Are Necessary But Insufficient

**Entity granularity problem.** For personal memory, entities are natural (people, organizations). For codebases, entity boundaries are fuzzy. Is "auth" an entity? Or is it "JWT validation," "OAuth2 flow," and "session management"? Too coarse → useless. Too fine → recreated the source files.

**Documentation rot, squared.** Entity documents are a *secondary representation* of the primary artifact (the code). Secondary representations rot. If agents maintain the entity docs, you've created a second-order coordination problem. If humans maintain them, it doesn't scale. The mem-agent paper sidesteps this because their entities ARE primary data. In a codebase, the source of truth is always the code.

**Stale reads.** Reading an entity document is reading a **materialized view**. If Agent A modifies the auth module but doesn't update `auth-module.md`, Agent B reads stale contracts with high confidence. This is *worse* than no entity doc — the agent now has confident wrong information.

**The relational gap.** "State" in a codebase includes things that live *between* entities: contracts ("this function accepts a JWT and returns a user ID"), invariants ("payment flow must never proceed without auth"), and intent ("migrating from REST to gRPC but old endpoints must keep working"). Cross-links between entity docs don't capture *what constraint* connects them.

#### Where This Points

The entity-centered approach is a real advance over chronological context. But for codebases, the right abstraction might not be prose entity documents but something more like a **type system for coordination** — a formal description of contracts and invariants that's machine-checkable, not just agent-readable.

Types, interfaces, test assertions — these are already mechanical descriptions of semantic state. They don't rot because they ARE the code, not a secondary representation. The gap is that nobody's wired them into agent coordination as a first-class primitive.

**The state description and the state enforcement should be the same artifact.** This is where the NERDs insight (entity-centered > chronological) meets the verification insight ([Verification Scales Parallelism](../insights.md#verification-scales-parallelism)): the code's own type system and test suite should serve as the queryable semantic state layer.

### 8. Back-Pressure

A system without back-pressure accepts work faster than it can process it, leading to cascading failure. gck1 burning through $400/month of tokens by day 3-4 is a system without back-pressure. The human cognitive ceiling at ~8 agents IS biological back-pressure.

No one in the thread has built mechanical back-pressure: an agent that slows down or pauses when the human review queue grows too long, or when merge conflict rate exceeds a threshold. This is table stakes in production distributed systems (circuit breakers, rate limiters, queue depth monitoring) and completely absent from agent orchestration.

---

## The Meta-Lesson

These practitioners are building distributed systems from first principles, without the 40 years of theory that already solved many of these problems. The vocabulary gap matters — if you know to search for "optimistic concurrency control" or "saga pattern," you find decades of literature on the tradeoffs. Without the vocabulary, you're left with "merge conflicts eat my parallelism gains" and no systematic framework for deciding when to partition, when to lock, and when to accept eventual consistency.

The deepest structural gap: everyone optimizes for *throughput* (features shipped) while the actual risk is *coherence* (does the codebase hold together under parallel autonomous modification). The next evolution won't be more agents — it'll be better merge semantics and queryable semantic state.

---

## Connections

- [Naur's Nightmare](../insights.md#naurs-nightmare) — semantic state IS theory; the missing layer is exactly what Naur described
- [Workflow as Tribal Knowledge](../insights.md#workflow-as-tribal-knowledge) — process state is tribal; agent-agent coordination is the third ephemeral layer
- [Verification Gate](../insights.md#verification-gate) — verification gates quality; here it also gates coordination
- [Verification Scales Parallelism](../insights.md#verification-scales-parallelism) — independent verifiable tasks, not agent count, drive progress
- [Liability Acceleration](../insights.md#liability-acceleration) — orphaned code persists because semantic state is unknown
- [HN: Parallel Coding Agents Thread](hn-parallel-coding-agents-tmux-47218318.md) — source thread
