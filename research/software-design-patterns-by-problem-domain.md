← [Index](../README.md)

# Software Design Patterns by Problem Domain

Language-agnostic patterns organized by the problem they solve, not by implementation mechanism or programming paradigm.

## Why This Framing

The Gang of Four (GoF) organized 23 patterns by *structural role* (creational, structural, behavioral) — a taxonomy tied to OOP mechanics. Functional programming has its own pattern vocabulary (monads, functors, lenses) tied to type theory. Both are useful within their paradigms, but neither organizes around what actually matters: **the problem you're trying to solve**.

This document catalogs patterns by **problem domain**. A pattern appears here if it:
1. Solves a recurring problem that arises regardless of language choice
2. Has proven value across multiple tech stacks
3. Is more than just a language feature (closures aren't a pattern; the problems closures solve may involve patterns)

The GoF observation that "patterns are language workarounds" has truth in it — Strategy is a first-class function, Observer is pub-sub, Iterator is a lazy sequence. But patterns above the language level persist because they address *domain complexity*, not language limitations.

---

## 1. Managing Business Complexity

**Problem:** Business rules are intricate, spread across code, and hard to reason about. The gap between what domain experts say and what code does grows over time.

| Pattern | What It Does | When You Need It |
|---------|-------------|-----------------|
| **Bounded Context** | Draws explicit boundaries around a coherent domain model with its own language | Multiple teams, ambiguous terms ("account" means different things to billing vs. auth) |
| **Ubiquitous Language** | Shared vocabulary between domain experts and code, enforced within a bounded context | Always — but especially when misunderstandings between business and engineering cause bugs |
| **Aggregate** | Cluster of domain objects treated as a single unit for data changes, with one root entity enforcing invariants | Whenever you need transactional consistency boundaries smaller than "the whole database" |
| **Entity** | Object defined by identity, not attributes (a customer is the same customer even after name change) | Anything with a lifecycle: users, orders, accounts |
| **Value Object** | Object defined by its attributes, immutable, no identity (an address, a money amount) | Replacing primitive types with domain concepts; equality by value, not reference |
| **Domain Event** | Record of something significant that happened in the domain ("OrderPlaced", "PaymentFailed") | Decoupling bounded contexts; audit trails; triggering downstream processes |
| **Domain Service** | Logic that doesn't belong to a single entity — operations spanning multiple aggregates | Transfer between accounts (neither account "owns" the transfer logic) |
| **Specification** | Encapsulates a boolean business rule as a composable, reusable object | Complex filtering, validation, or selection criteria that recur in different contexts |

**Critical take:** DDD tactical patterns (Aggregate, Entity, Value Object) are genuinely language-agnostic and remain the best toolkit for modeling complex domains. The strategic patterns (Bounded Context, Ubiquitous Language) are where the real leverage is — most teams skip these and wonder why their Aggregates don't help.

---

## 2. Separating Read & Write Concerns

**Problem:** Read-optimized data structures differ from write-optimized ones. Trying to serve both through a single model creates a compromise that's bad at both.

| Pattern | What It Does | When You Need It |
|---------|-------------|-----------------|
| **CQRS** (Command Query Responsibility Segregation) | Separate models for reading and writing; commands mutate state, queries read projections | Read/write patterns diverge significantly; need different scaling, optimization, or consistency guarantees per side |
| **Event Sourcing** | Persist state as an append-only sequence of events rather than current state | Audit/compliance requirements; need temporal queries ("what was state at time T?"); complex domain where replaying history enables new projections |
| **Materialized View** | Pre-computed, denormalized read model kept in sync with source data | High-read, low-write workloads; expensive joins or aggregations needed at query time |
| **Change Data Capture (CDC)** | Stream database changes as events to downstream consumers | Sync operational DB to analytics; build materialized views without coupling to write path |

**Critical take:** CQRS and Event Sourcing are frequently mentioned together but are independent patterns. CQRS without Event Sourcing is simple and high-value. Event Sourcing without CQRS is pain — you need read projections to make event-sourced data queryable, which is just CQRS by another name. Event Sourcing's real benefit isn't "audit trail" (a log table does that) — it's the ability to **reproject**: build new views of historical data when business rules change retroactively.

---

## 3. Coordinating Distributed Operations

**Problem:** Operations spanning multiple services or data stores can't use a single ACID transaction. Partial completion leaves the system in an inconsistent state.

| Pattern | What It Does | When You Need It |
|---------|-------------|-----------------|
| **Saga** (Orchestration) | Central coordinator directs a sequence of local transactions; issues compensating actions on failure | Multi-step business process across services; you need clear visibility into process state |
| **Saga** (Choreography) | Each service reacts to events and publishes its own; no central coordinator | Simpler workflows; teams own their services independently; lower coupling tolerance |
| **Compensating Transaction** | Undo operation that semantically reverses a completed step (refund ≠ delete; it's a new transaction) | Any distributed workflow where "rollback" isn't DELETE but a domain-meaningful reversal |
| **Transactional Outbox** | Write domain events to an outbox table in the same transaction as the state change; a separate process publishes them | Guaranteeing at-least-once event delivery without distributed transactions |
| **Idempotency** | Design operations so repeating them produces the same result as executing once | Any distributed system — networks are unreliable, messages get retried, exactly-once delivery is a myth |
| **Two-Phase Commit (2PC)** | Coordinator asks all participants to prepare, then commit or abort atomically | Rarely — only when you control all participants and can tolerate blocking. Mostly superseded by sagas in modern systems |

**Critical take:** Compensating transactions are the hardest part of sagas and consistently underestimated. "Undo sending an email" is impossible — you send a correction email. Idempotency is less a pattern than a **design discipline** — if your system isn't idempotent by default, every other distributed pattern becomes fragile.

---

## 4. Handling Failure & Resilience

**Problem:** In distributed systems, partial failure is the normal state. A downstream service being slow or unavailable shouldn't cascade into total system failure.

| Pattern | What It Does | When You Need It |
|---------|-------------|-----------------|
| **Circuit Breaker** | Monitors call failures; after threshold, "opens" to fail-fast instead of waiting on a dead service; periodically tests recovery | Any remote call that can hang or fail repeatedly |
| **Bulkhead** | Isolates resources (threads, connections, memory) per dependency so one failing dependency can't exhaust shared resources | Multiple downstream dependencies with different reliability profiles |
| **Retry with Exponential Backoff** | Retries failed operations with increasing delays to avoid overwhelming a recovering service | Transient failures (network blips, temporary overload) |
| **Fallback** | Returns a degraded-but-useful response when the primary path fails | User-facing features where "something" is better than an error (show cached recommendations, default content) |
| **Timeout** | Sets an upper bound on how long to wait for a response | Every remote call — unbounded waits are the number-one cause of cascading failures |
| **Health Endpoint Monitoring** | Exposes health status endpoints for load balancers and orchestrators to probe | Any service behind a load balancer or orchestrator |
| **Backpressure** | Signals upstream producers to slow down when a consumer can't keep up | Streaming/pipeline architectures; message queues approaching capacity |

**Critical take:** Circuit Breaker gets all the attention, but **Timeout is the foundational pattern**. Without timeouts, circuit breakers can't even detect failure. Bulkhead + Circuit Breaker together are more powerful than either alone — Bulkhead limits blast radius, Circuit Breaker stops futile retries. Netflix's Hystrix popularized these; Resilience4j is the modern standard.

---

## 5. Message Routing & Integration

**Problem:** Systems need to exchange data, but direct coupling creates brittleness. Message-based integration decouples sender from receiver, but introduces routing, transformation, and ordering challenges.

| Pattern | What It Does | When You Need It |
|---------|-------------|-----------------|
| **Publish-Subscribe** | Producer publishes to a topic; any number of consumers subscribe independently | Distributing events to multiple unrelated consumers |
| **Pipes and Filters** | Decompose processing into independent sequential stages connected by channels | Data pipelines; ETL; any multi-step transformation where stages should be independently deployable |
| **Content-Based Router** | Inspects message content and routes to appropriate channel | Different message types need different processing paths |
| **Splitter / Aggregator** | Splitter breaks composite message into parts; Aggregator reassembles related parts | Batch processing; fan-out/fan-in workflows |
| **Scatter-Gather** | Broadcast request to multiple recipients; aggregate responses | Price comparison; parallel enrichment; multi-agent queries |
| **Dead Letter Channel** | Route unprocessable messages to a separate channel for inspection/retry | Any message-driven system — you need a place for poison messages |
| **Idempotent Receiver** | Consumer deduplicates messages it has already processed | At-least-once delivery systems (i.e., all of them) |
| **Routing Slip** | Attach a list of processing steps to each message; each processor executes its step and forwards | Dynamic, per-message processing pipelines |

**Critical take:** Enterprise Integration Patterns (Hohpe & Woolf, 2003) is the definitive catalog and has aged remarkably well. The patterns haven't changed — what changed is the substrate (ESBs → Kafka → event streaming platforms). Pipes and Filters is the most underrated pattern on this list: it's the architecture of every streaming data pipeline, every Unix command chain, and every CI/CD pipeline.

---

## 6. Managing Concurrency

**Problem:** Multiple computations need to happen simultaneously, sharing or coordinating over resources without corruption, deadlock, or starvation.

| Pattern | What It Does | When You Need It |
|---------|-------------|-----------------|
| **Actor Model** | Isolated actors communicate via async message-passing; each actor processes one message at a time; no shared state | Highly concurrent systems; distributed systems; when you want to eliminate shared-memory bugs (Erlang, Akka) |
| **Communicating Sequential Processes (CSP)** | Anonymous processes communicate via typed, synchronous channels | Pipeline-style concurrency; Go's goroutines+channels |
| **Structured Concurrency** | Concurrent tasks are scoped to a parent; parent doesn't complete until all children complete or cancel | Any concurrent code — prevents orphaned tasks, leaked goroutines, fire-and-forget hazards |
| **Event Loop / Reactor** | Single-threaded loop dispatches I/O events to registered handlers | High-connection-count servers where most work is I/O-bound (Node.js, nginx, Redis) |
| **Fork-Join** | Split work into parallel subtasks; wait for all to complete; combine results | Data parallelism; embarrassingly parallel computation (Rayon, OpenMP, ForkJoinPool) |
| **Optimistic Concurrency Control** | Allow concurrent access; detect conflicts at commit time; retry on conflict | Read-heavy workloads where conflicts are rare (version fields, ETags, CAS) |
| **Pessimistic Concurrency Control** | Lock resources before access; prevent conflicts by exclusion | Write-heavy workloads; when conflict retry cost is high |
| **Leader Election** | Distributed nodes agree on a single leader to coordinate work | Consensus-requiring tasks: partition assignment, cron scheduling, master-slave failover |

**Critical take:** Actor vs CSP is less about choosing sides than understanding the trade-off: actors are **asynchronous** (send-and-forget to a mailbox), CSP is **synchronous** (sender blocks until receiver reads from channel). Actors scale to distributed systems naturally; CSP is easier to reason about locally. Structured concurrency is the sleeper hit — it's to concurrent programming what structured programming was to goto: obvious in retrospect, transformative in practice. Java's virtual threads, Kotlin's coroutine scopes, and Python's trio all implement it.

---

## 7. Structuring Application Architecture

**Problem:** How do you organize code so that business logic doesn't become entangled with infrastructure concerns, and the system remains testable and changeable?

| Pattern | What It Does | When You Need It |
|---------|-------------|-----------------|
| **Hexagonal / Ports & Adapters** | Core business logic defines interfaces (ports); infrastructure implements them (adapters); dependencies point inward | Any application that needs to be testable without databases, HTTP, or file systems |
| **Clean Architecture** | Concentric layers with dependency rule: inner layers define abstractions, outer layers implement them (Entities → Use Cases → Interface Adapters → Frameworks) | Same goal as Hexagonal with more prescribed layering |
| **Vertical Slice** | Organize by feature/use-case rather than by technical layer; each slice contains its own handler, model, validation | When layered architecture creates coupling between features that should be independent; CQRS-friendly |
| **Layered Architecture** | Separate presentation, business logic, and data access into layers with one-way dependency | Simple CRUD applications; teams familiar with the pattern; when separation of concerns is enough |

**Critical take:** Hexagonal, Clean, and Onion architecture are the same idea with different diagrams and terminology. The core insight is **dependency inversion**: business logic defines what it needs; infrastructure plugs in. Vertical Slice is the counter-movement — it argues that coupling *within* a feature is less harmful than coupling *across* features via shared layers. Both are right, at different scales: Hexagonal for the overall structure, Vertical Slice for organizing features within it.

---

## 8. Managing Data Access & Persistence

**Problem:** Domain objects and relational storage have different structures. Bridging this gap without corrupting domain logic or creating unmaintainable mapping code.

| Pattern | What It Does | When You Need It |
|---------|-------------|-----------------|
| **Repository** | Collection-like interface for accessing domain objects; hides persistence details | Anywhere domain logic shouldn't know about SQL/NoSQL/files |
| **Unit of Work** | Tracks all changes during a business transaction; commits them atomically | ORM-backed systems; ensures related changes succeed or fail together |
| **Data Mapper** | Separate mapper object translates between domain objects and database rows; neither knows about the other | Complex domains where object structure diverges from table structure |
| **Active Record** | Domain object wraps a database row; knows how to save/load itself | Simple CRUD; small projects; when mapping complexity is low |
| **Identity Map** | Cache of loaded objects keyed by ID; ensures each database row maps to exactly one in-memory object per transaction | Preventing inconsistency from loading the same entity twice in a single operation |

**Critical take:** Active Record vs Data Mapper is the foundational fork. Active Record is faster to start but couples domain to persistence — fine for CRUD apps, toxic for complex domains. Repository pattern is nearly universal and appears in every DDD implementation. Unit of Work and Identity Map are typically handled by ORMs (Hibernate, SQLAlchemy, Entity Framework) rather than hand-rolled — know they exist, don't reinvent them.

---

## 9. Caching

**Problem:** Repeatedly fetching or computing the same data is wasteful. But caching introduces stale data, invalidation complexity, and failure modes.

| Pattern | What It Does | When You Need It |
|---------|-------------|-----------------|
| **Cache-Aside** (Lazy Loading) | Application checks cache first; on miss, fetches from DB and populates cache | General purpose; most control; the default choice |
| **Read-Through** | Cache itself fetches from DB on miss; application always reads from cache | Simplify application code; read-heavy workloads |
| **Write-Through** | Writes go to cache and DB synchronously | Strong consistency requirements (financial data) |
| **Write-Behind** (Write-Back) | Writes go to cache; DB updated asynchronously later | Write-heavy workloads; acceptable risk of data loss on cache failure |
| **Write-Around** | Writes bypass cache, go directly to DB | Write-once data (logs, audit records) that pollutes cache if stored |
| **Cache Invalidation** | Remove/update stale cache entries when underlying data changes | Any cached mutable data — "the two hardest problems in CS" |

**Eviction strategies:** LRU (most common, good default), LFU (stable access patterns), TTL (time-based expiry, essential even with other strategies), FIFO (simplest, least effective).

**Critical take:** Cache-Aside is the right starting point for 90% of cases. The thundering herd problem (popular key expires, 1000 requests hit DB simultaneously) is the non-obvious failure mode — solved by request coalescing or probabilistic early expiration. Write-Behind at Netflix records viewing history: cache failure loses a few seconds of watch data, which is acceptable. The real lesson: **choose your caching strategy based on your tolerance for staleness and data loss, not based on what sounds clever**.

---

## 10. Evolving & Migrating Systems

**Problem:** You need to modernize or replace a system without a big-bang rewrite, which has a catastrophic failure rate.

| Pattern | What It Does | When You Need It |
|---------|-------------|-----------------|
| **Strangler Fig** | Incrementally replace parts of a legacy system by routing traffic through a proxy; new functionality goes to new service, legacy handles the rest, shrinks over time | Any legacy modernization — this is the only safe approach for large systems |
| **Anti-Corruption Layer (ACL)** | Translation layer between two systems with different models; prevents the new system's domain model from being "corrupted" by the old system's concepts | During migration when old and new systems coexist; integrating with external systems whose model you don't control |
| **Branch by Abstraction** | Introduce an abstraction layer over a component you want to replace; swap implementations behind the abstraction | Replacing internal components (switching ORMs, message brokers) without feature branches |
| **Feature Flags** | Toggle features on/off via configuration without deployment; enable progressive rollout and A/B testing | Decoupling deployment from release; testing in production; gradual migration |

**Critical take:** Strangler Fig is the single most important pattern for organizations with legacy systems. The ACL is its essential companion — without it, the new system becomes a mirror of the old system's mistakes. Feature Flags have become infrastructure (LaunchDarkly, Unleash, Flipt) because they solve the deployment ≠ release problem that every team over ~5 engineers eventually hits.

---

## 11. Deploying Safely

**Problem:** Shipping new code to production risks breaking things. How do you minimize blast radius and enable fast rollback?

| Pattern | What It Does | When You Need It |
|---------|-------------|-----------------|
| **Blue-Green Deployment** | Maintain two identical environments; deploy to idle one; switch traffic atomically | Need instant rollback capability; can afford double infrastructure |
| **Canary Deployment** | Route small percentage of traffic to new version; monitor metrics; gradually increase | Need to validate with real traffic before full rollout |
| **Rolling Deployment** | Replace instances one-at-a-time with new version | Default for orchestrated systems (Kubernetes); balance between speed and safety |
| **Shadow Deployment** | Route production traffic copy to new version without returning its responses to users | Validate new code with real workloads, zero user impact |
| **Progressive Delivery** | Umbrella term: combine canary + feature flags + automated analysis to gradually expose changes | Mature CI/CD pipelines; when you want automated rollback based on metrics |

**Critical take:** These aren't mutually exclusive — they compose. Blue-Green + Canary: deploy to green, shift 5% traffic, monitor, then cut over. The under-appreciated pattern is Shadow Deployment for validating data pipeline changes or ML model updates where you need to compare outputs without affecting users. All of these are operational patterns, not code patterns — they require infrastructure support (load balancer routing, health checks, observability) to work.

---

## 12. Managing Business Rules & State

**Problem:** Complex business logic needs to be externalizable, testable, and changeable without code deployment. Systems have states and transitions that must be enforced.

| Pattern | What It Does | When You Need It |
|---------|-------------|-----------------|
| **State Machine** | Model system as finite states with explicit transitions; enforce that only valid transitions occur | Order lifecycle, payment processing, approval workflows — anywhere illegal state transitions are costly |
| **Rules Engine** | Externalize business rules from application code; evaluate rules against data at runtime | Frequently changing rules; non-developers need to modify rules; complex eligibility/pricing logic |
| **Interpreter** | Define a grammar for a domain-specific language and an interpreter to evaluate it | User-defined queries, search filters, configuration expressions, formula evaluation |
| **Workflow Engine** | Orchestrate multi-step processes with branching, parallel paths, timeouts, and human tasks | Approval processes, onboarding flows, complex business processes that span time |

**Critical take:** State machines are criminally underused. Most bugs in order processing, payment flows, and approval systems stem from ad-hoc state management — a series of if/else chains instead of an explicit state machine. The pattern itself is trivial to implement; the discipline is in exhaustively enumerating states and transitions. Rules engines are powerful but dangerous — they become an unmaintainable "second codebase" if rules aren't versioned, tested, and governed like code.

---

## 13. API & Service Boundary Patterns

**Problem:** How do services expose their capabilities and communicate without creating tight coupling or performance bottlenecks?

| Pattern | What It Does | When You Need It |
|---------|-------------|-----------------|
| **API Gateway** | Single entry point for all clients; handles routing, authentication, rate limiting, protocol translation | Multiple client types (web, mobile, internal); cross-cutting concerns need centralization |
| **Backend-for-Frontend (BFF)** | Dedicated backend per client type, tailored to that client's needs | Mobile needs different data shapes/volumes than web; shared API becomes a compromise |
| **Sidecar** | Deploy supporting functionality (logging, monitoring, security, networking) as a co-located but separate process | Cross-cutting concerns across heterogeneous services; service mesh infrastructure |
| **Service Mesh** | Infrastructure layer handling service-to-service communication (routing, observability, security) via sidecar proxies | Large microservice deployments needing consistent security/observability without per-service implementation |

**Critical take:** API Gateway is almost universally needed once you have >2 services. BFF is the correct answer to "our mobile app is slow because it has to call 7 endpoints and stitch data together" — yet teams resist it because it feels like "extra work." Sidecar and Service Mesh (Istio, Linkerd) solve real problems but add operational complexity that small teams should avoid. The pattern to watch: **direct service-to-service communication via event streaming** (Kafka) replacing both RPC and service mesh for many use cases.

---

## 14. Observability & Debugging

**Problem:** In distributed systems, understanding what happened, where it failed, and why is non-trivial. You can't debug by attaching a debugger to a microservice.

| Pattern | What It Does | When You Need It |
|---------|-------------|-----------------|
| **Distributed Tracing** | Propagate a trace ID across service boundaries; reconstruct the full request path | Any distributed system; essential for debugging latency and failures |
| **Correlation ID** | Attach a unique ID to every request that follows it through all systems | Minimum viable observability; enables log correlation across services |
| **Log Aggregation** | Collect logs from all services into a central searchable system | Any multi-service system; without it, debugging requires SSH-ing into individual machines |
| **Wire Tap** | Inspect messages flowing through a channel without modifying them | Debugging message-based systems; monitoring integration flows |

**Critical take:** Correlation ID is the single cheapest, highest-ROI observability pattern. It's one line of code per service (propagate a header) and transforms debugging from "impossible" to "searchable." Distributed tracing (OpenTelemetry, Jaeger) is the mature version. These patterns aren't optional in production distributed systems — they're prerequisites.

---

## What's Not Here (and Why)

**GoF patterns** (Strategy, Observer, Factory, etc.): These are *implementation* patterns — they solve code-organization problems within a single process. Many dissolve into language features (Strategy = function parameter; Observer = event/callback; Iterator = for-each). They're useful vocabulary but don't address the problem domains above.

**FP type patterns** (Monad, Functor, Applicative, Lens): These are *computational abstractions* expressed as patterns in typed FP languages. The problems they solve (composing effects, error propagation, immutable data access) exist everywhere, but the patterns themselves are deeply tied to type systems with generics/higher-kinded types. The language-agnostic versions are: Railway-Oriented Programming (chained error handling), Optional/Maybe (null avoidance), and Pipeline/Composition (chaining transformations).

**Data structure patterns** (B-tree, LSM-tree, bloom filter): These are algorithms/data structures, not design patterns. Important, but a different category.

---

## Pattern Interaction Map

Patterns don't exist in isolation. Common compositions:

```
Event Sourcing + CQRS + Materialized View
  → Full write/read separation with temporal queries

Saga + Compensating Transaction + Idempotency + Outbox
  → Reliable distributed workflow

Circuit Breaker + Bulkhead + Timeout + Retry + Fallback
  → Complete resilience stack

Strangler Fig + Anti-Corruption Layer + Feature Flags
  → Safe legacy migration

Publish-Subscribe + Pipes and Filters + Dead Letter Channel
  → Resilient event processing pipeline

Blue-Green + Canary + Feature Flags + Health Monitoring
  → Progressive delivery
```

---

## Sources & References

- Hohpe & Woolf, *Enterprise Integration Patterns* (2003) — messaging patterns; aged remarkably well
- Evans, *Domain-Driven Design* (2003) — tactical and strategic patterns
- Fowler, *Patterns of Enterprise Application Architecture* (2002) — data access patterns, Unit of Work, Identity Map
- Nygard, *Release It!* (2007, 2nd ed. 2018) — resilience patterns (Circuit Breaker, Bulkhead, Timeout)
- Vernon, *Implementing Domain-Driven Design* (2013) — practical DDD + CQRS + Event Sourcing
- Cockburn, "Hexagonal Architecture" (2005) — Ports and Adapters
- Martin, "Clean Architecture" (2012 blog post, 2017 book)
- Microsoft Azure Architecture Center — canonical pattern catalog with decision trees
- AWS Prescriptive Guidance — Strangler Fig, ACL, Saga implementations
- Hewitt (1973) Actor Model; Hoare (1978) CSP — original concurrency models
- Richardson, *Microservices Patterns* (2018) — Saga, CQRS, Transactional Outbox, API Gateway
