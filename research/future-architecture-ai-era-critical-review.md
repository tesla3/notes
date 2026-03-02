← [Index](../README.md)

# Critical Review: "What Software Architecture Wins in the AI Agent Era?"

Self-review of my brainstormed predictions, stress-tested against historical evidence, expert opinions, production track records, and current research (as of March 2026).

**Verdict on my original analysis:** Directionally interesting, but suffering from three systemic flaws: (1) treating academic "should" as industry "will," (2) ignoring the graveyard of identical predictions that failed for non-technical reasons, and (3) conflating "good for AI agents" with "good for software." Several predictions are validated by emerging practice; several are contradicted by decades of evidence; and the framing of "language-agnostic" was undermined by my own Rust-centric priors.

---

## 1. Spec-First, Implementation-Disposable

### What I Claimed
Code becomes disposable. Specs are the durable artifact. Implementations are regenerated as models improve. Like how nobody hand-writes assembly.

### What the Evidence Says

**Partially validated, but much thinner than I presented.**

The "Spec-Driven Development" (SDD) movement is real and growing:
- **Tessl** takes the most radical position: "spec-as-source," where code is regenerated from specs entirely.
- **Amazon Kiro** uses a Requirements → Design → Tasks workflow.
- **GitHub Spec-Kit** implements Constitution → Specify → Plan → Tasks.
- **RedMonk's 2025 developer survey** lists "Spec-Driven Development" as one of 10 things developers want from agentic IDEs.
- **Roy Lines (Dec 2025)** coined "Disposable Code" explicitly, drawing the Netflix Chaos Monkey analogy: "If you have never deleted your code and regenerated it from specifications, you do not know whether your specifications are sufficient."
- A Feb 2026 arxiv paper on "Codified Context" (game development case study) shows a 3-tier spec architecture (constitution → specialists → knowledge base) with ~26,000 lines of specifications driving agent-generated code.

**But the counter-evidence is significant:**

- **arxiv (Jan 2026, "Will It Survive?")**: Survival analysis of 201 open-source projects shows AI-generated code survives *significantly longer* than human code — 15.8% lower modification rate, 16% lower hazard of modification. This directly contradicts the "disposable code" thesis. Code isn't being regenerated; it's persisting. The most autonomous agent (Devin) shows *slightly higher* death rates, but copilot-style code (human-AI collaboration) survives longest of all.
- **The assembly analogy is misleading.** Assembly was replaced because compilers produce *deterministic, provably equivalent* output from a higher-level source. LLMs produce *stochastic, non-deterministic* output. Regenerating code from the same spec produces different code each time. This makes "regenerate from spec" fundamentally unlike "recompile from source." You can't diff your regenerated code against the previous version and expect the same behavior.
- **No one has demonstrated spec-to-production at scale.** Tessl is pre-revenue. Kiro is weeks old. The Codified Context paper is a solo game dev project. The largest validated spec-driven project I can find is still in the hundreds of files, not thousands.
- **The "spec is the source of truth" framing ignores the spec maintenance problem.** Your notes on context rot apply to specs too. As the arxiv Codified Context paper itself notes: "treat specifications as load-bearing, because agents trust documentation absolutely and out-of-date specs cause silent failures." Stale specs are worse than no specs — they're authoritative misinformation.

### Corrected Assessment
Spec-driven development is a genuine trend that will grow. But "disposable implementation" is aspirational, not validated. The more likely near-term reality: **specs as enhanced documentation that constrain agent behavior** (like CLAUDE.md, AGENTS.md), not specs as sole source of truth that replace code. The gap between spec and implementation remains unsolved — Amazon's TLA+ experience explicitly states the answer to "how do you go from spec to code?" is "Carefully." (Hillel Wayne, 2018).

---

## 2. Tree/Pipeline Over Graph

### What I Claimed
Agents are good at tree/pipeline data flow, bad at graph-shaped mutable state. Therefore tree/pipeline architectures dominate.

### What the Evidence Says

**The observation about agent capability is correct. The prediction is wrong.**

- The capability gap is real: agents demonstrably struggle with shared mutable state, complex object graphs, and cyclic dependencies. Your own Rust evaluation documents this extensively — even human Rust developers fight the borrow checker on graph-shaped data.
- React's unidirectional data flow validates the pattern for UI specifically.
- Google's 8 multi-agent design patterns (Jan 2026) are ALL pipeline/tree-shaped: sequential pipeline, coordinator/dispatcher, parallel fan-out/gather, hierarchical decomposition, generator/critic, iterative refinement, human-in-the-loop, composite.

**But the prediction that these architectures "dominate" ignores why graph architectures exist:**

- **Databases are graphs.** Relational databases are fundamentally graph-shaped (foreign key relationships). NoSQL document stores denormalize to avoid this, but at the cost of update anomalies. The entire data layer of most applications is graph-shaped, and no amount of agent architecture preference changes that.
- **Business domains are graphs.** An order references a customer who has multiple addresses linked to payment methods associated with subscriptions managed by organizations. DDD's tactical patterns (Aggregate, Entity, Value Object) exist precisely because real business domains form interconnected graphs.
- **Operating systems, network stacks, and GUIs are inherently graph-shaped.** These aren't going away. The Rust GUI problem isn't solved by "agents prefer trees" — it's an inherent domain constraint.
- **The "force everything into trees" approach has been tried and failed.** XML (hierarchical) lost to JSON (still hierarchical) for data interchange, but relational databases (graph-shaped) continue to dominate storage because hierarchical storage creates update anomalies and duplication.

### Corrected Assessment
More accurate prediction: **the interface between human-specified architecture and agent-generated implementation will increasingly be tree/pipeline-shaped** (task decomposition, module boundaries, API contracts). But the implementations behind those interfaces will still be graph-shaped when the domain requires it. The tree wins as an *organizational* pattern for work decomposition, not as a universal architectural pattern. This is already visible in Google's multi-agent patterns — they're workflow orchestration patterns, not data architecture patterns.

---

## 3. Message-Passing / Actor Model Over Shared Memory

### What I Claimed
The Erlang/Elixir actor model becomes dominant because it maps to agent architectures naturally.

### What the Evidence Says

**Strongest prediction, but oversimplified.**

The convergence is real and documented:
- **George Guimarães (Feb 2026)**: "Your Agent Framework Is Just a Bad Clone of Elixir" — Python/JS agent frameworks are reinventing what BEAM solved in 1986. Langroid's README explicitly says their multi-agent paradigm is "inspired by the Actor Framework." AutoGen 0.4 independently arrived at an "event-driven actor framework."
- **The mapping is direct:** isolated agent state = Erlang process; agent communication = message passing; workflow orchestration = supervisor trees; error recovery = "let it crash"; agent registry = :global process registry.
- **WhatsApp (900M users, 50 engineers, Erlang) and Discord (Elixir) are production validations.**

**But the actor model has known, documented weaknesses:**

- **Composability problem.** Paul Chiusano: "the fundamental signature of an Actor is `A => Unit`. You send it a message and... something happens." You can't compose actors the way you compose functions. Eric Torreborre: "I've had to look at applications built with actors and found the overall behavior of the system pretty hard to reason about." The `A => Unit` signature means refactoring has unintended consequences — you can't trace data flow by reading the code.
- **Akka's trajectory is cautionary.** Akka on the JVM was the most serious actor model implementation outside BEAM. It ended up building Akka Streams *on top of* actors because actors alone were too unstructured. Then Lightbend changed Akka's license to BSL (not open source). The community response was to fork it as Apache Pekko. The lesson: even the most committed actor model proponents found that pure actors needed to be constrained with stream/pipeline abstractions.
- **Untyped messages are a liability.** Erlang's actor messages are untyped. This is fine for Erlang's culture but terrible for agent-generated code where type safety is the primary feedback mechanism. Typed actors (Akka Typed, session types) partially address this but add complexity.
- **BEAM's advantages are runtime-level, not architectural.** Preemptive scheduling, per-process GC, hot code loading, and fault isolation are BEAM VM features, not actor model features. You can't bolt these onto Python or TypeScript. Guimarães admits: "you can get about 70% there with enough engineering. The remaining 30% requires runtime-level support."
- **The "let it crash" philosophy has limits for AI agents.** An LLM agent that crashes and restarts loses its conversation context. Unlike a stateless telecom switch handler, AI agents accumulate state (conversation history, tool results, reasoning chains) that is expensive to reconstruct. Crash-and-restart means paying for all those LLM tokens again.

### Corrected Assessment
Message-passing as an inter-agent communication pattern is almost certain to dominate — it's already the default in every multi-agent framework. The full actor model with supervision trees is a strong fit for agent orchestration specifically. But "actor model over shared memory" as a general architectural prescription is too broad. Most code *within* an agent is sequential, pure-functional, or pipeline-shaped. Actors sit at the orchestration layer, not at every level of the stack. Your existing patterns document captures this correctly: "Actors scale to distributed systems naturally; CSP is easier to reason about locally."

---

## 4. Capability-Based Security as Architecture

### What I Claimed
Object capabilities become the default security architecture because every piece of code is untrusted.

### What the Evidence Says

**Theoretically correct. Historically a graveyard.**

Capability-based security has a 60-year history of being right and failing to achieve adoption:

- **Dennis & Van Horn (1966)**: First capability system.
- **KeyKOS, EROS, CapROS, Coyotos**: Research OS lineage spanning decades. All remained research projects.
- **seL4**: Formally verified capability-based microkernel. Production deployments exist (NIO vehicles, drones). But these are embedded/safety-critical niches, not mainstream.
- **Fuchsia (Google)**: Capability-based component framework. Powers all Nest Hub devices. The closest thing to mainstream ocap deployment. But Fuchsia itself is a niche OS.
- **AS/400**: The only commercial success of a true capability system. 99.99%-99.999% uptime. Never had a significant security compromise. But it's a legacy platform.
- **Capsicum (FreeBSD)**: Capability mode for Unix processes. Real and useful. But a narrow Unix extension, not a fundamental architecture shift.
- **CHERI (Cambridge)**: Hardware capability extensions. Impressive research. Nowhere near mainstream CPUs.
- **Mark S. Miller's E language and Caja (Google)**: JavaScript sandboxing via ocaps. Caja was deprecated.
- **POSIX "capabilities"**: Not real capabilities at all. Named to cause confusion.

**Why capabilities keep failing despite being correct:**

1. **Ecosystem lock-in to ACLs.** As the HN commenter (btilly) puts it: "The world went with ACLs. That's baked into Windows and POSIX. All consumer software expects ACLs. To get them to run on a pure capability system, you have to create a POSIX subsystem. At which point, you've just thrown away the whole reason to use capabilities."
2. **Revocation complexity.** Fine-grained revocation ("revoke Alice's access but not Bob's, and revoke everything Alice delegated") requires proxy patterns that add indirection and complexity. Solved in research; rarely implemented cleanly in practice.
3. **Bootstrap problem.** A capability system is most useful when *everything* uses capabilities. A single ambient-authority component (a shell, a file system, a library that reads environment variables) breaks the entire model.
4. **Developers don't want to think about security at this granularity.** The principle of least authority (POLA) requires explicitly threading capabilities through every function call. This is the moral equivalent of Rust's borrow checker for security — correct but exhausting.

**The agent era *might* finally tip the scales**, but not for the reason I stated:

- OAuth 2.1 in the MCP spec is a capability-like pattern (scoped, revocable tokens).
- a16z's "secret broker" concept (agents request capabilities, broker grants them just-in-time with audit) is object-capability thinking without the academic vocabulary.
- The real mechanism: **agents don't have muscle memory.** Developers resist POLA because they're used to ambient authority. Agents have no such habits. If the framework defaults to capability-passing, agents will use it without complaint.

### Corrected Assessment
Capability *patterns* (scoped tokens, revocable access, least-privilege by default) will become more common in agent frameworks — this is already happening via MCP OAuth and secret brokers. But a full architectural shift to the object-capability model? History says no. The 60-year track record of "theoretically superior, practically unadopted" should create extreme skepticism. The more likely outcome: capability-inspired patterns embedded in existing frameworks (OAuth tokens, scoped API keys, sandboxed environments), not a paradigm shift. Pragmatic hybrid, not purist revolution.

---

## 5. Reversible-by-Default / Event Sourcing

### What I Claimed
Event sourcing over CRUD. Append-only logs as source of truth. Immutable infrastructure. Everything reversible.

### What the Evidence Says

**The most overconfident prediction. Event sourcing has a brutal track record in production.**

The problems are extensively documented:

- **GDPR/data deletion.** Event sourcing's "append-only, immutable" model directly conflicts with "the right to be forgotten." Deleting a user's data from an append-only event stream without corrupting the audit trail is an unsolved problem at scale. Reddit commenter (Weary-Hotel-9739): "3 months later you get the GDPR request to remove all data from a single user within a week, and only the new junior developer has any time to implement this feature."
- **Event versioning.** When your domain model changes (it always does), you have events in the old schema that need to work with the new code. Version 5 of an event has properties that Version 1 didn't have. Dennis Doomen (production ES experience): "The more versions you have of an event, the more of this knowledge dissipates into history."
- **Projection complexity.** Projections depend on other projections. Projections assume event ordering that changes. Projections have hidden dependencies. Doomen found: producers reading from projections that were at a different point in the event stream, causing silently wrong data.
- **Replay is not free.** "500M event stream and a 6 hour replay window that makes every migration a scheduled outage" (HN commenter, fleahunter).
- **Eventual consistency is genuinely hard.** "CQRS sounds good, until you just want to read a value that you know has been written" (HN, zknill).
- **SQL Server identity column ordering bug.** Doomen: inserts can complete out of order, causing the projector to process event 2 before event 1. Took months to discover under production load. Required exclusive locks to fix.
- **LLMs can't generate correct CQRS code.** "Luckily for us, LLMs basically never output correct CQRS code, because they're trained on the millions of failed projects of that architecture" (Reddit, Weary-Hotel-9739). This directly undermines the thesis that agents will drive adoption of event sourcing.

**Where event sourcing is validated:**
- Financial systems with regulatory audit requirements (the Doomen article, the FinTech case study)
- Systems where temporal queries ("what was state at time T?") are a core requirement
- Systems where reprojection (building new views of historical data) creates genuine business value

**Where it fails:**
- General CRUD applications (it's a "complexity bomb with a 12-18 month fuse")
- Domains that aren't well-understood yet (schema evolution is painful)
- Anywhere GDPR or data deletion requirements exist
- Any domain where eventual consistency creates user-visible problems

### Corrected Assessment
"Reversible-by-default" is a good principle. Event sourcing is one implementation, and it's the wrong default for most systems. Your existing patterns catalog already nails this: "CQRS without Event Sourcing is simple and high-value. Event Sourcing without CQRS is pain." The better prediction: **audit logging, PITR (point-in-time recovery), and git-like versioning for data** — these achieve reversibility without the full event sourcing commitment. The agent era creates more need for undo/audit (agents make mistakes at machine speed), but the implementation should be pragmatic (change data capture, audit tables, PITR snapshots), not dogmatic (full event sourcing).

---

## 6. Verification-Heavy, Implementation-Light ("Fat Spec, Thin Code")

### What I Claimed
Formal methods go mainstream. Humans write properties and contracts. Agents generate everything else. Specs become larger than implementations.

### What the Evidence Says

**TLA+ at Amazon is the strongest validation. But "mainstream" is a massive leap from where we are.**

Validated:
- **Amazon DynamoDB, S3, EBS**: TLA+ found bugs in replication protocols that passed "extensive design reviews, code reviews, and testing." One bug had a 35-step error trace — "the improbability of such compound events is not a defense." This is the canonical success story.
- **Microsoft Cosmos DB**: TLA+ formally verified five consistency levels and conflict resolution protocols.
- **Hillel Wayne**: Reports TLA+ "cut a month off the timeline and saved another month on post-deployment maintenance" on a vendor integration. The system ran 3+ years with zero production issues.
- **Multiple Amazon teams** adopted TLA+ after seeing results: DynamoDB, S3, EBS, and internal lock manager.

Not validated:
- **Adoption remains tiny.** Wayne himself: "There aren't yet any large-scale studies on the effectiveness of formal specifications." The TLA+ community is "very small" and there's a documented gap between "trivial toy examples" and "complex industrial algorithms."
- **The spec-to-code gap is unsolved.** Wayne (2018): "How do you go from a spec to code? Carefully. Verifying that code matches a spec, aka refinement, is a really hard problem!" Amazon doesn't auto-generate code from TLA+ specs. They use specs to validate *designs*, then implement manually.
- **SYSMOBENCH (arxiv, Oct 2025)**: Attempted to evaluate AI-generated TLA+ specs. Finding: "Writing a system model remains a highly challenging expert task that requires months to years of effort." AI-generated specs couldn't be reliably evaluated because there are no good metrics for spec quality beyond "does TLC run without errors" (which doesn't mean the spec is correct).
- **bvrmn (HN, Jan 2025)**: "Basic, high level specification gains nothing. You have to spend at least 100 hours trying to model real live distributed protocols with full liveness support to be at somewhat formal verification beginner level."
- **constantcrying (HN, Jan 2025)**: "Most software projects and design philosophies are simply incompatible with formal methods. In software, development and design can often fall together, but that means it is uniquely ill suited for formal methods."

### Corrected Assessment
Formal methods for *distributed systems design* (TLA+ for consensus protocols, replication, concurrency) will continue growing — the Amazon evidence is too strong to ignore. But "formal methods go mainstream" for general software development? No. The tools are too hard, the spec-to-code gap is unsolved, and most software doesn't have the correctness requirements that justify the investment. The more realistic prediction: **AI agents will make lightweight formal methods more accessible** (property-based testing is already popular; contract-based programming is growing), but TLA+-level specification will remain a specialist tool for distributed systems and safety-critical domains.

---

## 7. Micro-Contracts Over Microservices

### What I Claimed
Decomposition by verification boundaries instead of team boundaries. Modules small enough for an agent to regenerate from scratch.

### What the Evidence Says

**Interesting but untested.** This prediction is my most speculative and has the least evidence.

- **Conway's Law still applies.** The organizational structure determines the system architecture. Agents don't eliminate this — they change who the "team" is. If an agent owns a module, the module boundary is shaped by the agent's context window, just as it was shaped by a team's cognitive capacity.
- **The "small enough to regenerate" heuristic is reasonable.** The Codified Context paper shows exactly this pattern: specifications scoped to individual subsystems, each small enough that an agent can implement from the spec alone. But the spec maintenance burden grows with the number of modules.
- **Google's multi-agent patterns (Jan 2026)** support the direction: specialized agents with clear interfaces is the explicit recommendation. "Reliability comes from decentralization and specialization."
- **No one has demonstrated this working beyond toy projects or solo developer workflows.**

### Corrected Assessment
This is a hypothesis, not a prediction. It's internally consistent and directionally plausible, but there's no production evidence. The most I can say: module sizing by "what fits in an agent's context" is a reasonable heuristic that will probably emerge naturally, similar to how microservice sizing evolved from "what a team can own" to "what fits a bounded context."

---

## Systemic Flaws in My Original Analysis

### Flaw 1: Survivor Bias for Academic Ideas
I presented capability-based security, event sourcing, actor model, and formal methods as "what academics have advocated for decades" and predicted the AI era would finally adopt them. But these ideas have been "about to go mainstream" for decades. The barriers to adoption are social, economic, and ecosystem-related — not just "human laziness." Agents don't remove those barriers.

### Flaw 2: Conflating Agent Preferences with User Preferences
"Agents prefer tree-shaped data flow" doesn't mean tree-shaped architectures win. Users don't care what agents prefer. Business domains don't reshape themselves for AI convenience. The architecture that wins is the one that solves the business problem, not the one that's easiest for agents to generate.

### Flaw 3: Ignoring the Hybrid Reality
Real systems are hybrids. The arxiv survey on agentic AI (Oct 2025) explicitly categorizes production deployments by dominant paradigm: healthcare uses symbolic (deterministic), finance uses neural (orchestration) with symbolic guardrails, robotics uses hybrid, education uses neural. **There is no single architecture that wins.** The domain constraints dictate the paradigm. My analysis presented a unified vision; reality is domain-specific and pluralistic.

### Flaw 4: Underweighting Inertia
POSIX, SQL, HTTP, REST, Docker, Kubernetes, PostgreSQL, Python — these aren't going away because agents prefer something else. The installed base of existing software, developer skills, tooling, and infrastructure represents trillions of dollars of investment. New architectures must compose with existing ones, not replace them. Every "revolutionary" architecture I predicted has a compatibility requirement I ignored.

---

## What Actually Wins (Revised)

| Prediction | Original Confidence | Revised Confidence | Key Revision |
|---|---|---|---|
| Spec-driven development | High | **Medium** | Specs as enhanced documentation, not as sole source of truth. The spec-to-code gap is unsolved. |
| Tree/pipeline architectures dominate | High | **Low-Medium** | Wins for workflow orchestration; irrelevant for data modeling and domain architecture. |
| Actor/message-passing for agents | High | **Medium-High** | Message-passing between agents is near-certain. Full actor model with supervision is strong for orchestration, but not universal. |
| Capability-based security | High | **Low** | 60 years of failure to adopt. Capability *patterns* (OAuth, scoped tokens) will grow; the full model won't. |
| Event sourcing / reversible-by-default | High | **Low-Medium** | Reversibility is good; event sourcing is the wrong default. Audit logs + PITR + CDC are pragmatic alternatives. |
| Formal methods go mainstream | High | **Low** | Remains specialist. AI may lower the barrier for lightweight verification (property-based testing, contracts). |
| Micro-contracts / verification boundaries | Medium | **Low** | Hypothesis only. No production evidence. |

### What I'd Add That Was Missing

1. **Heterogeneous model architectures** (validated, Gartner + Google ADK): Plan-and-execute with tiered models (expensive for reasoning, cheap for execution) is the actual emerging pattern. Cost optimization as a first-class architectural concern.

2. **The orchestration layer is the architecture** (validated, Google 8 patterns): The patterns that actually matter are workflow patterns: sequential, fan-out/gather, hierarchical decomposition, generator/critic loops. These are language-agnostic, domain-agnostic, and already production-tested.

3. **Existing patterns + agents > new patterns** (your existing catalog): Saga + compensating transaction + idempotency + outbox is how you make agent operations reversible — not event sourcing. Circuit breaker + retry + fallback is how you handle agent failures — not supervision trees. State machine is how you enforce valid agent state transitions — not actor mailboxes. The existing pattern catalog applies directly; new patterns may not be needed.

---

## Sources

- Google, "Eight Essential Multi-Agent Design Patterns" (Jan 2026), InfoQ coverage
- Agentic AI Survey, arxiv 2510.25445 (Oct 2025) — dual-paradigm taxonomy
- Roy Lines, "Disposable Code: Chaos Monkey for AI-Native Development" (Dec 2025)
- arxiv 2601.16809, "Will It Survive? Deciphering the Fate of AI-Generated Code" (Jan 2026)
- arxiv 2602.20478, "Codified Context: Infrastructure for AI Agents" (Feb 2026)
- Dennis Doomen, "The Ugly of Event Sourcing — Real-world Production Issues" (2017, LinkedIn)
- HN thread on Event Sourcing in Go (2026), 51 comments
- Reddit r/programming ES/CQRS thread (2026)
- InfoQ, "Day Two Problems When Using CQRS and Event Sourcing" (2019)
- Amazon, "How Amazon Web Services Uses Formal Methods" (2015) — TLA+ at DynamoDB, S3, EBS
- Hillel Wayne, "Formal Specification Languages" (2023), "Designing Distributed Systems with TLA+" (2018)
- HN thread "Formal Methods: Just Good Engineering Practice?" (Jan 2025), 133 comments
- SYSMOBENCH, arxiv 2509.23130 (Oct 2025) — AI-generated TLA+ spec evaluation
- George Guimarães, "Your Agent Framework Is Just a Bad Clone of Elixir" (Feb 2026)
- Eric Torreborre, "Turning Actors Inside-Out" (2025)
- Mark S. Miller, "Robust Composition" (PhD thesis, 2006) — object-capability model
- HN thread "CapROS: Capability-Based Reliable Operating System" (2026), 59 comments
- HN thread "Capability Based Security" (2015), 35 comments
- Wikipedia, Object-capability model — implementations list
- a16z, "Emerging Developer Patterns for the AI Era" (May 2025) — secret broker concept
- RedMonk, "10 Things Developers Want from Agentic IDEs" (Dec 2025) — spec-driven development
- Chapter 5: Spec-Driven Development with Claude Code (Panaversity, Mar 2026) — SDD tools landscape
