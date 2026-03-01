← [Index](../README.md)

# Durable Objects & Rivet Actors: The Stateful Serverless Primitive

**Source:** [HN thread](https://news.ycombinator.com/item?id=47197003) — Show HN: SQLite for Rivet Actors (Feb 2026)

---

## The Core Idea

Traditional serverless (Lambda, Workers) is **stateless** — every invocation starts from scratch, reads state from a database, does work, writes state back. This creates a fundamental tension: serverless gives you effortless scaling, but the database becomes the bottleneck and single point of failure.

**Durable Objects** (Cloudflare, 2020) and **Rivet Actors** (open-source alternative) solve this by fusing compute and state into a single addressable unit. Each object/actor:

1. Has a **globally unique ID** — you can route requests to a specific instance from anywhere
2. Has **co-located persistent storage** — reads are local memory access, not network round-trips
3. Is **single-threaded** — no concurrency bugs, no locks, no distributed transactions
4. **Hibernates when idle, wakes on demand** — serverless economics with stateful semantics
5. **Scales horizontally** — millions of instances, each independent

This is the **actor model** — a concept from 1973 (Carl Hewitt) that Erlang/OTP made practical in the 1980s. What's new is packaging it as a serverless primitive for mainstream languages (TypeScript/JS).

---

## How Durable Objects Work (Cloudflare)

```
Client → Cloudflare Worker (edge) → routes to specific Durable Object by ID
                                          ↓
                                   [Single-threaded JS runtime]
                                   [In-memory state (cache)]
                                   [Co-located SQLite or KV storage]
                                   [WebSocket connections]
                                   [Alarms/scheduling]
```

**Key properties:**

- **Globally unique addressing**: `env.MY_DO.idFromName("chat-room-42")` always routes to the same instance, wherever it lives on Cloudflare's network.
- **Strong consistency**: Single-writer model. Only one instance of a given ID exists at any time. No stale reads, no conflicts.
- **Automatic placement**: Provisioned near first request. Can provide location hints.
- **Storage**: Up to 10GB per object. SQLite API (newer) or legacy KV API. Storage is transactional and strongly consistent.
- **Hibernation**: Stays alive while handling requests, hibernates after idle period. WebSocket connections survive hibernation (the runtime wakes on incoming messages).
- **Limits**: 128MB memory, 30s CPU time per request (wall clock can be longer), 10GB storage.

**What makes it click:** The single-writer guarantee eliminates an entire class of distributed systems problems. You don't need distributed locks, optimistic concurrency, CRDTs, or two-phase commits within an object's scope. The object *is* the coordination point.

**Typical patterns:**
- One DO per chat room (all messages route through it)
- One DO per document (collaborative editing coordination)
- One DO per user session (auth state, preferences)
- One DO per game match (game state, player connections)
- Control plane / data plane split (one DO manages metadata, millions of DOs hold actual data)

---

## How Rivet Actors Work

Rivet Actors are an **open-source (Apache 2.0), self-hostable** implementation of essentially the same primitive.

```typescript
import { actor } from "rivetkit";

export const chatRoom = actor({
  state: { messages: [] },      // In-memory, auto-persisted
  actions: {
    sendMessage: (c, user, text) => {
      c.state.messages.push({ user, text });
      c.broadcast("newMessage", { user, text });  // WebSocket broadcast
    },
  },
});
```

**Architecture:**

| Component | Role |
|-----------|------|
| **Rivet Engine** | Rust orchestration binary |
| **Pegboard** | Actor orchestrator & networking |
| **Gasoline** | Durable execution engine |
| **Guard** | Traffic routing proxy |
| **Epoxy** | Multi-region KV store (EPaxos) |

**Storage backends:** FoundationDB or Postgres for persistence. SQLite runs in-process with each actor via a custom VFS that persists writes to the HA backend.

**Deployment options:**
- Self-host: single Docker container (`docker run -p 6420:6420 rivetkit/engine`)
- Rivet Cloud: managed service
- Works with Vercel, Railway, AWS — not locked to one provider

**Where Rivet differs from Durable Objects:**

| Dimension | Durable Objects | Rivet Actors |
|-----------|----------------|--------------|
| Source | Closed-source | Apache 2.0 |
| Hosting | Cloudflare only | Self-host anywhere |
| Runtime | V8 isolates (Workers) | Node.js / containers |
| Storage | SQLite or KV (built-in) | SQLite via custom VFS → FDB/Postgres |
| Workflows | Separate product (Workflows) | Built into actors |
| Queues | Separate product (Queues) | Built into actors |
| Scheduling | Alarms API | Built-in cron + timers |
| Edge network | Cloudflare's 300+ PoPs | Depends on deployment |

---

## The SQLite-Per-Entity Model

This is the key architectural insight both systems converge on. Instead of one big database with row-level security (RLS) for multi-tenancy, you get **one SQLite database per actor**.

**Why this matters at scale:**

Traditional sharded databases (Cassandra, DynamoDB, Vitess) use partition keys to distribute data. This works, but you're stuck with rigid schemas, painful migrations, and no cross-partition transactions.

SQLite-per-entity gives you:

- **Full SQL within each partition** — joins, indexes, FTS, complex queries, all local
- **ACID transactions within each entity** — no distributed transaction headaches
- **Independent schema per entity** — each tenant/agent can have different tables
- **Lazy migrations** — run on next wake-up, not a global migration event
- **Noisy neighbor isolation** — a bad query affects only one actor's DB
- **No RLS security nightmares** — physical isolation, not logical

**The trade-off:** Cross-entity queries are hard. You can't `SELECT * FROM all_users WHERE ...` across millions of SQLite databases. The Rivet team says this is rarer than people think in practice (Linear, Slack, ChatGPT all naturally partition by workspace/thread), and they're exploring DuckDB integration for analytics across databases.

---

## The Erlang Elephant in the Room

As the HN thread notes (malkosta): *"It's crazy how pretty much every tool people post to support AI systems is already in Erlang/OTP."*

This is true. Erlang has had:
- Lightweight processes (actors) since the 1980s
- Per-process state with message passing
- Supervision trees for fault tolerance
- Hot code loading
- The BEAM VM runs millions of processes per node

**What Rivet/DOs add that Erlang doesn't natively have:**
- **Serverless economics** — scale to zero, pay per use, no always-on cluster
- **Durable persistence** — Erlang processes lose state on crash (you need Mnesia or external DB); DOs/Actors auto-persist
- **Global addressing** — route to a specific actor from anywhere without knowing which node it's on
- **Hibernation** — actors sleep to disk and wake on demand
- **TypeScript/JS ecosystem** — the pragmatic reality of where most web developers are

The Rivet founder (NathanFlurry) acknowledges this directly: *"Everyone seems to be reinventing the actor model from first principles right now."* Their bet is on being the best actor primitive for mainstream languages rather than convincing everyone to learn Erlang.

**The open question** (raised by malkosta): preemptive scheduling. Erlang's BEAM preemptively schedules processes — a runaway process can't starve others. Node.js is cooperatively scheduled. How does Rivet handle fairness? This is a real concern for multi-tenant deployments and remains unanswered in the thread.

---

## When to Use This Pattern

**Good fit:**
- AI agents (per-agent persistent state, conversation history, embeddings)
- Multi-tenant SaaS (per-tenant isolation without RLS complexity)
- Real-time collaboration (per-document state + WebSockets)
- Chat systems (per-room/channel)
- IoT (per-device state)
- Game servers (per-match/session)

**Bad fit:**
- Analytics / reporting across all data (need a separate data warehouse)
- Applications with heavy cross-entity joins
- Simple CRUD apps where Postgres does fine
- Batch processing pipelines

---

## Verdict

The Durable Object / Rivet Actor pattern is a genuine architectural shift, not just marketing. It eliminates the most painful parts of distributed stateful systems (coordination, consistency, sharding) by making each entity self-contained. The SQLite-per-entity model takes it further by giving each actor a real relational database instead of just a KV store.

Rivet's value proposition is clear: it's the open-source, portable version of what Cloudflare built. The early user signal is positive (fastball on HN: migrated from DOs to Rivet for better AWS/Vercel interop, happy with it). The cross-entity query story is the biggest gap — acknowledging it exists and pointing at DuckDB is honest but not yet a solution.

The deeper trend: **the industry is converging on the actor model as the right primitive for the AI agent era**, where you need millions of independent stateful entities (agents, sessions, tenants) that each need compute, storage, and real-time communication. Whether through Erlang, Durable Objects, Rivet, or the next thing — this architectural pattern is here to stay.
