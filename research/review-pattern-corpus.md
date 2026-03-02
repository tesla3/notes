← [Software Design Patterns by Problem Domain](software-design-patterns-by-problem-domain.md) · [Design Patterns Agent Future](design-patterns-agent-future.md) · [Index](../README.md)

# Critical Review: The Two-Document Pattern Corpus

Both documents are strong individually. Read together, they form something more interesting — and more flawed — than either alone. Below is the honest assessment: what holds, what doesn't, what's missing, and what emerges when you read between the lines.

---

## Document 1: The Classical Catalog

**What's genuinely good:**

The problem-domain framing is the right call. Organizing by "what problem are you solving" rather than GoF's "what structural role does this play" makes the patterns actionable. A developer debugging a cascading failure reaches for §4 (Resilience), not "Behavioral Patterns." This alone makes it more useful than most pattern catalogs.

The critical takes are the best part. "CQRS without Event Sourcing is simple and high-value; Event Sourcing without CQRS is pain" — that's correct and saves people from a mistake that takes months to discover. "State machines are criminally underused" — correct, and pays off massively when Doc 2 explains *why* agents make this unavoidable. The critical takes carry opinions that are earned, not performative.

The Pattern Interaction Map is underrated infrastructure. Pattern literature almost never shows compositions. The six listed compositions (Saga + Compensating Transaction + Idempotency + Outbox, etc.) are the actual architectures people build, not individual patterns.

**What's weak or wrong:**

**1. The "GoF patterns dissolve into language features" dismissal is overstated.** Strategy-as-function-parameter works for simple dispatch. But Strategy with configuration, lifecycle, multiple methods, and runtime swapping doesn't dissolve — it just moves from a class to a closure-over-state, which is isomorphic. The document half-acknowledges this ("patterns above the language level persist") but the framing still gives too much ground. The real issue: GoF patterns solve *different scale problems* than the 14 domains listed. They're not irrelevant, they're orthogonal.

**2. The "same idea, different diagrams" claim about Hexagonal/Clean/Onion is reductive.** They share the dependency-inversion core, but Clean Architecture has specific opinions about use cases as a layer, entities vs. enterprise business rules, and interface adapters as a distinct ring. Hexagonal doesn't prescribe any of that. Saying they're "the same" is like saying TCP and HTTP are the same because they both move data. The convergent insight matters; the architectural guidance differs.

**3. Uneven domain coverage reveals selection bias.** Caching gets six patterns and three eviction strategies. Business Rules & State gets four patterns. Where are Decision Tables, Truth Tables, or the Policy pattern? The document's implicit model is "backend distributed systems architecture" — which is fine, but should be stated. There are zero security-domain patterns (AuthZ, zero-trust, capability-based access), zero data transformation/ETL patterns beyond passing mentions, and zero real-time streaming patterns beyond Pipes and Filters. These are problem domains that exist "regardless of language choice" by the document's own criteria.

**4. The boundary between "pattern" and "technique" is inconsistent.** CDC is an infrastructure capability, not a design pattern. Feature Flags are an operational technique. The document's own criterion says "more than just a language feature" but doesn't enforce "more than just an infrastructure capability." If CDC qualifies, so do database indexing strategies and load balancing algorithms. Either tighten the criteria or acknowledge the boundary is fuzzy.

**5. Structured Concurrency deserves more than "sleeper hit" status.** It's called the most transformative concurrency pattern since structured programming eliminated goto — then gets one paragraph. The implications for agent systems (preventing orphaned agent tasks, leaked tool calls, fire-and-forget hazards) are enormous and completely unmentioned in Doc 2.

---

## Document 2: The Agent-Future Analysis

**What's genuinely good:**

The three-property framework (nondeterminism, NL interfaces, autonomous decision-making) is sharp and generative. Every pattern consequence in the document can be traced back to one of these three properties. That's the sign of a good abstraction.

The tripartite structure (load-bearing, adapted, genuinely new) is the right taxonomy. It prevents the common failure mode of agent-pattern literature, which is either "everything is new!" or "everything is just existing patterns renamed."

The analogies are excellent. Context Engineering = memory management for OSes. Memory Hierarchy = CPU cache hierarchy for cognition. These aren't just pedagogically useful — they're *structurally accurate*, which means the solutions from the analog domain (eviction policies, cache coherence protocols, page replacement algorithms) are likely transferable.

Asymmetric Verification is the sharpest insight in either document. The observation that generation is expensive but verification is often cheap (run the tests, check the schema, diff the output) is the single most actionable principle for anyone building agent systems today. It cuts through the "LLM-as-judge" hype by noting that deterministic checks are infinitely more reliable and should run first.

**What's weak or wrong:**

**1. At least four of ten "genuinely new" patterns aren't genuinely new.** The document's own text admits this in several cases:

- **Sandboxed Execution Envelope** — The document literally says "the pattern is not new, but the application to AI agents is." That's an *application*, not a new pattern.
- **Prompt-as-Contract** — This is configuration management + infrastructure-as-code applied to prompts. Version control, regression testing, progressive rollout — all exist. The novelty is the domain (prompts), not the pattern.
- **Guardian/Sentinel** — Separation of duties + validation chain. Every security-reviewed system has this. Using an LLM as the judge is a new *implementation*, not a new pattern structure.
- **Human-in-the-Loop Gate** — Approval workflows and risk-tiered authorization have existed for decades in financial systems, nuclear systems, medical devices. The pattern is "mandatory approval for high-risk operations." New for AI; not new as a pattern.

Only **Context Engineering**, **Nondeterminism Envelope**, **Memory Hierarchy**, and **Capability Card** feel genuinely novel as pattern-level abstractions. The others are important *applications* of known patterns to a new domain. That's still valuable — but mislabeling them weakens the document's credibility.

**2. The MCP = Ports & Adapters claim has a directional problem.** In Hexagonal Architecture, the *core* defines the port interfaces and adapters implement them. In MCP, the *server* defines tool schemas and the agent consumes them. The dependency direction is inverted: the agent adapts to external tool definitions, not the other way around. MCP is closer to a standardized service interface protocol than to Ports & Adapters. The connection is real but the "literally" overstates it.

**3. Agents are treated as monolithic.** There's a massive spectrum from a RAG chatbot to a fully autonomous multi-agent system with long-horizon planning. A simple tool-using LLM wrapper doesn't need Hierarchical Delegation, Capability Cards, or Memory Hierarchy. They need Context Engineering, an ACL on LLM output, and maybe a state machine. The document would be stronger with a complexity gradient: "at this scale you need X; at this scale you need Y." Without it, teams building simple agent features will over-engineer, and teams building complex systems won't know which patterns are foundational vs. optional.

**4. The "Patterns That Decline" section is a strawman.** Singleton, GoF Creational patterns, Active Record, and 2PC were already in decline (Doc 1 explicitly omits most of them). The more interesting and harder question: which of Doc 1's 14 domains lose relevance or change character in agent systems? Does Layered Architecture decline because agents can't reason about layer boundaries? Does the Repository pattern change so fundamentally (semantic retrieval replaces key-based lookup) that it's a different pattern entirely? This section should challenge Doc 1's catalog, not beat up on already-dead patterns.

**5. The Saga adaptation understates the difficulty.** "Agent sagas have a unique property: the agent itself decides the steps at runtime." This deserves far more analysis. Classical sagas have known compensation paths because the steps are known in advance. Agent sagas have *unknown* compensation paths because the steps are emergent. How do you compensate for a step you didn't predict? The document gestures at this ("agents may not even remember what they did") but doesn't propose a solution. This might be an open problem, not a pattern adaptation — and should be listed as such.

---

## Cross-Document Insights

Reading the two documents as a unit reveals patterns neither makes explicit.

### 1. The State Machine Paradox

Doc 1: "State machines are criminally underused" in traditional systems.
Doc 2: "The single most important pattern for agent systems."

This is the deepest connection. The pattern humans avoided because it felt like over-engineering is *structurally essential* when the actor is nondeterministic. Why? Because human programmers hold state transitions in their heads. Agents can't. The state machine externalizes constraints that humans enforce implicitly. This reveals a general principle: **patterns that encode constraints become more important as actors become less reliable.** Types, contracts, state machines, schemas — all constraint-encoding mechanisms — should be expected to amplify in importance.

### 2. The Nondeterminism Tax

The overarching insight from reading both documents is that introducing a nondeterministic actor into a deterministic system imposes a "tax" on *every* pattern. Every pattern boundary needs a validation/correction wrapper. This isn't just added complexity — it's a paradigm shift.

Classical design assumes **correctness by construction**: types prevent invalid states, contracts prevent invalid calls, transactions prevent inconsistent data. Agent design assumes **incorrectness is inevitable** and correctness emerges from verification loops.

This is exactly analogous to the shift from single-process to distributed systems. Pre-distribution, you assumed function calls succeed. Post-distribution, you assumed network calls can fail. Pre-agents, you assumed code follows its logic. Post-agents, you assume the actor might not follow instructions. Both shifts add a tax to every interface boundary.

### 3. The Anti-Corruption Layer's Dual Life

In Doc 1: ACL protects new systems from legacy systems' domain models during migration.
In Doc 2: ACL protects your system from LLM hallucinations at the output boundary.

Structurally identical. Both defend against an external source that has its own "model" which doesn't match yours and can't be fully trusted. The LLM is, architecturally, a legacy system — it has its own world model, speaks its own language, and you need a translation/validation boundary.

This connection suggests that *all* migration/integration patterns from Doc 1 §10 (Strangler Fig, Branch by Abstraction) may have agent-system analogs. Strangler Fig for gradually replacing deterministic logic with agent-driven logic. Branch by Abstraction for swapping between LLM providers behind a stable interface. Doc 2 doesn't explore this.

### 4. The Unconnected Bridge: Event Sourcing → Agent Memory

Doc 1's Event Sourcing: "persist state as an append-only event sequence; reproject later for new views."
Doc 2's Memory Hierarchy: "working memory → session memory → long-term memory with promotion rules."

These should be connected. Agent sessions *should be event-sourced*: every LLM call, tool invocation, and decision is an event. This enables the killer feature Doc 1 identifies — **reprojection**: build new summaries of historical sessions when summarization strategies improve. An agent could re-derive its long-term memory from raw session events with a better compression algorithm. Neither document makes this connection.

### 5. Specification Pattern → Guardian Policies

Doc 1's Specification pattern: "composable boolean business rules as reusable objects."
Doc 2's Guardian/Sentinel: "evaluate output against policies."

The Specification pattern is exactly what you'd want for defining composable guardian policies: `AllowedAction AND NotHarmful AND WithinBudget AND SchemaCompliant`. The pattern exists; the application to agent guardrails is obvious; neither document connects them.

### 6. The Observability Inflection

Doc 1 treats observability as domain 14 of 14 — important but not central. Doc 2 moves it to "mandatory" and adds a new dimension (decision traces). This reordering reveals a bias in Doc 1: it's organized by the problem domain of the *software being built*, not of *understanding what the software did*. In agent systems, understanding-what-happened moves from operational concern to primary architectural driver. You can't improve an agent you can't observe.

### 7. Caching Strategies as Context Management Strategies

Doc 1's caching domain (LRU, LFU, TTL, request coalescing, thundering herd) maps directly to context window management. LRU → most-recently-relevant context stays. LFU → frequently-referenced knowledge stays. TTL → old conversation history expires. Thundering herd → multiple agent requests hitting the same retrieval simultaneously. The solutions likely transfer. Neither document explores this.

---

## The Biggest Gap

Neither document addresses the **meta-pattern**: how do you decide which patterns to apply?

Doc 1 gives 14 domains and 70+ patterns with "when you need it" columns. Doc 2 gives load-bearing vs. adapted vs. new categories. But there's no decision framework for: "I'm building X, at scale Y, with constraints Z — which subset of these patterns do I actually need?"

This matters because over-patterning is as dangerous as under-patterning. A three-person team building a simple agent chatbot doesn't need Hierarchical Delegation, Saga orchestration, or a full Memory Hierarchy. They need Context Engineering, an ACL on LLM output, and maybe a state machine. A complexity-appropriate pattern selection guide would make both documents significantly more useful.

---

## Verdict

Doc 1 is a solid, opinionated reference catalog. Its problem-domain framing is the right structural choice. Its main weakness is inconsistent inclusion criteria and some reductive critical takes. **B+** — genuinely useful, needs tighter editorial discipline.

Doc 2 is more ambitious and more uneven. Its best insights (Asymmetric Verification, Context Engineering as memory management, the three-property framework) are genuinely excellent. Its main weakness is inflating the "genuinely new" count by including well-known patterns applied to a new domain. **B+** — the analytical framework is strong, the pattern classification needs honesty editing.

Together, they're better than the sum of parts. The cross-document connections (State Machine paradox, ACL's dual life, Event Sourcing → Agent Memory, Specification → Guardian) reveal insights neither document reaches alone. The biggest missed opportunity is that Doc 2 doesn't systematically walk Doc 1's 14 domains and show how each transforms — it cherry-picks the ones that amplify and ignores the rest. A systematic treatment would be a significant contribution.

---

## Addendum: Second-Pass Corrections and Additions

Re-reading all three documents surfaced things the first review missed or got wrong.

### Corrections to the First Review

**1. The MCP / Ports & Adapters critique was too strong.** On reflection, the agent *does* define what capabilities it needs — through its system prompt, its tool-calling expectations, its reasoning about available tools. MCP servers implement those capabilities. The dependency direction isn't purely server→agent; it's more bidirectional. The agent expects certain capability shapes, MCP provides them. "Literally" is still overstated, but the structural analogy is more valid than the first review credited.

**2. Guardian/Sentinel has more novelty than initially argued.** While separation of duties exists in security, using a *probabilistic* judge to evaluate *probabilistic* output creates problems with no classical precedent: narcissistic bias (models rate their own style highly), correlated failure modes (both generator and judge hallucinate the same "fact"), and the meta-problem of evaluating the evaluator. The topology "LLM judges LLM" is structurally different from "deterministic validator checks deterministic output." The *principle* isn't new; the *problem structure* is. This deserves its spot in Part 3, but should be framed as "old principle, new problem structure" rather than pure novelty.

**3. Doc 2's CQRS adaptation deserved more credit.** The reframing of "read/write" as "context assembly / action execution" is architecturally generative. It implies different infrastructure, different optimization targets, potentially different teams for the context pipeline (latency, relevance, compression) vs. the action pipeline (safety, idempotency, reversibility). That's a non-obvious insight with real design consequences.

### Missing Cross-Document Connections

**8. Backpressure → Agent Token/Rate Limiting**

Doc 1's Backpressure pattern: "signal upstream producers to slow down when a consumer can't keep up." Agent systems have severe backpressure problems: context windows overflow, token budgets exhaust, API rate limits hit. When an agent's context is full, it needs to signal "stop adding information" — that's backpressure. When API quotas are near capacity, the orchestrator needs to throttle agent spawning — that's backpressure. Doc 2's Context Engineering partially addresses this but never connects it to the existing pattern vocabulary.

**9. Dead Letter Channel → Failed Agent Task Queue**

When an agent task exhausts all retries (Nondeterminism Envelope fails, Guardian rejects, Asymmetric Verification can't confirm), where does it go? It needs a Dead Letter Channel: a queue of failed agent tasks awaiting human review. This is *distinct* from Human-in-the-Loop Gate (proactive approval before action) — it's *reactive* failure routing after all automated recovery is exhausted. Doc 1 has the pattern. Doc 2 never applies it.

**10. Scatter-Gather → Multi-Agent Queries**

Doc 1's Scatter-Gather: "broadcast request to multiple recipients; aggregate responses." Doc 1 even notes "multi-agent queries" in the "When You Need It" column. Yet Doc 2 discusses multi-agent coordination at length without once mentioning Scatter-Gather. It's the exact pattern for "ask Research Agent, Code Agent, and Security Agent about this problem; aggregate their responses."

**11. Routing Slip → Dynamic Agent Plans**

Doc 1's Routing Slip: "attach a list of processing steps to each message; each processor executes its step and forwards." This maps more accurately to agent task execution than the Saga analogy. An agent's plan *is* a routing slip — a list of steps attached to the task, modified as the agent progresses. The Routing Slip already handles dynamic, per-message pipelines. Doc 2's Hierarchical Delegation pattern reinvents this without citing it.

**12. Workflow Engine → The Missing Production Pattern**

Doc 1 §12 lists Workflow Engine. Doc 2 discusses state machines and sagas for agent orchestration but never mentions workflow engines (Temporal, Prefect, Inngest). In production, LangGraph + Temporal is a real pattern: LangGraph handles agent-level state, Temporal handles durable execution across failures and restarts. The Workflow Engine is arguably *more* relevant to production agent systems than pure state machines, because it handles the persistence, retry, and resumption that agents need across long-running tasks. This is a significant gap in Doc 2.

### Missing Domain in Both Documents

**Testing patterns are absent from both.** Doc 1 mentions testability in passing (Hexagonal enables it). Doc 2 mentions eval suites in the summary table. But testing is a full problem domain: property-based testing, contract testing, mutation testing, chaos engineering. For agents specifically, eval suites *are* a form of property-based testing (assert properties over nondeterministic output), and chaos engineering maps to adversarial prompt injection testing. Neither document treats testing as a first-class domain.

### One Naming Problem in Doc 2

The "Constitution" label in Prompt-as-Contract creates a false connection. Anthropic's Constitutional AI is about *training-time* principles baked into model weights. Runtime prompt versioning and testing is a completely different concern. The pattern is real and important. The name borrows prestige from an unrelated technique and will confuse readers who know the original meaning.
