← [Software Design Patterns by Problem Domain](software-design-patterns-by-problem-domain.md) · [Index](../README.md)

# Design Patterns in an Agent-Everywhere Future

What shifts, what amplifies, and what must be invented when LLM-based agents become primary actors in software systems.

## The Fundamental Shift

Classical design patterns assume **deterministic, human-directed** actors. A Strategy pattern executes the same way every time. A Repository returns the same data for the same query. A Circuit Breaker trips on measurable failure.

Agents introduce three properties that break these assumptions:

1. **Nondeterminism** — The same input produces different outputs. Always. The "function" is probabilistic.
2. **Natural language as interface** — The boundary between components is no longer typed function signatures but unstructured text + schemas.
3. **Autonomous decision-making** — The agent decides which tools to use, what order, when to stop. Control flow is emergent, not prescribed.

This changes the pattern landscape in three ways: some existing patterns become load-bearing infrastructure, some need significant adaptation, and some genuinely new patterns are emerging.

---

## Part 1: Existing Patterns That Become Load-Bearing

These patterns already exist but shift from "nice to have" to "structurally essential."

### State Machine → Agent Orchestration Backbone

**Why it amplifies:** The single most important pattern for agent systems. LangGraph (the leading agent framework) is literally a state machine — nodes are LLM calls or tool invocations, edges are permissible transitions. Google ADK, AutoGen, and every serious production agent framework converges on graph-based orchestration.

The reason is simple: unbounded LLM reasoning loops are dangerous. Agents that "decide what to do next" in free-form dialogue drift into unproductive loops, exhaust tokens, or take unsafe actions. Explicit state machines constrain the agent to valid transitions while letting the LLM handle local reasoning within each state.

**What changes:** Classical state machines have deterministic transitions. Agent state machines have *probabilistic* transitions where the LLM chooses the next state from a set of valid options. The pattern needs:
- **Guard nodes** — validation checks before allowing transition
- **Approval states** — human-in-the-loop gates for irreversible transitions
- **Cycle budgets** — maximum iterations before forced termination
- **Typed state updates** — each node reads/writes to a shared state object with schema enforcement

**Verdict:** If you're building agents and not using explicit state machines, you're building a footgun.

### Circuit Breaker + Bulkhead + Timeout → Agent Resilience Stack

**Why it amplifies:** Agents make *more* external calls than traditional services — every tool invocation, every LLM API call, every retrieval query. LLM APIs have notoriously variable latency (2s to 60s+), rate limits, and availability issues. An agent that hangs waiting on a slow LLM call while consuming an expensive compute context is worse than a service that hangs — it's burning money per second.

**What changes:**
- Timeout becomes **per-step timeout** within an agent loop, not just per-request
- Circuit Breaker needs to cover **model provider failover** (Claude down → fall back to GPT)
- Bulkhead isolates **agent sessions** from each other so one runaway agent doesn't exhaust API quotas for all users

### Saga + Compensating Transaction → Multi-Step Agent Workflows

**Why it amplifies:** Agents perform multi-step operations: "Research this topic, write a draft, send it for review, publish." Each step may be irreversible (sent an email, committed code, called an external API). The Saga pattern is the natural fit — and compensating transactions become critical because LLM agents make mistakes that need undoing.

**What changes:** Agent sagas have a unique property: the agent itself decides the steps at runtime rather than following a predetermined sequence. This is closer to Saga Choreography than Orchestration, but with a single actor. The compensation challenge is harder because agents may not even *remember* what they did without explicit logging.

### Idempotency → Non-Negotiable Infrastructure

**Why it amplifies:** Agents retry aggressively. LLM calls timeout and get retried. Tool calls fail and get retried. The same agent loop may re-execute a step because the LLM "decided" to try again. Without idempotent operations, agents create duplicate records, send duplicate emails, and double-charge payments at a rate far exceeding human-driven systems.

**Verdict:** Every tool exposed to an agent must be idempotent by design. This is not optional.

### Pipes and Filters → Agent Pipelines

**Why it amplifies:** Google ADK's SequentialAgent, LangChain's chains, every "Agent A → Agent B → Agent C" pattern is Pipes and Filters. The pattern maps perfectly to multi-agent workflows where each agent specializes in one transformation: parse → extract → validate → summarize.

**What's new:** The "filters" are nondeterministic. Each agent-filter may produce different output each time. The pipeline needs evaluation gates between stages (see new patterns below).

### Publish-Subscribe → Agent Event Bus

**Why it amplifies:** Multi-agent systems need decoupled communication. Agent A discovers something; Agents B, C, D need to react. The event-driven model is natural because agents are inherently asynchronous — they take variable time and produce variable results. The research on AgentOrchestra (2025-2026) shows event-driven choreography outperforming centralized orchestration for complex multi-agent tasks.

### Observability Patterns (Distributed Tracing, Correlation ID, Wire Tap) → Mandatory

**Why they amplify:** You cannot debug agents without full observability. Every LLM call, every tool invocation, every decision point needs to be logged with:
- The full context window content (what the agent "saw")
- The reasoning/CoT output
- The action taken
- The result

Correlation IDs across agent-to-agent calls are essential. The "three pillars of observability" (logs, metrics, traces) plus a fourth: **decision traces** — why the agent chose action X over action Y.

### Hexagonal / Ports & Adapters → Agent-Tool Architecture

**Why it amplifies:** The emerging architecture for agent systems is explicitly a Ports & Adapters pattern: the agent's reasoning core (the "hexagon") defines what capabilities it needs via tool schemas (the "ports"), and MCP servers / API wrappers implement them (the "adapters"). Swapping LLM providers or tool implementations doesn't change the agent's logic.

MCP (Model Context Protocol) is literally Ports & Adapters for agents: standardized port definitions (tool schemas) with pluggable adapter implementations (MCP servers).

---

## Part 2: Existing Patterns That Need Adaptation

### CQRS → Split Context Assembly from Action Execution

Classical CQRS separates read models from write models. In agent systems, the equivalent split is:
- **Read side (Context):** Retrieve, rank, compress, and assemble information for the agent's context window
- **Write side (Action):** Execute tool calls, mutate state, produce output

These have completely different optimization profiles. The read side is about **relevance** (what information helps the agent reason?), the write side is about **safety** (is this action permitted? reversible? idempotent?).

### Repository → Retrieval as a First-Class Architectural Concern

RAG (Retrieval-Augmented Generation) is the Repository pattern for agents — but with a crucial difference. A classical Repository returns exact data for exact queries. Agent retrieval is **semantic** — the agent needs "information relevant to this situation" not "record with ID 42." This means:
- Embedding-based retrieval replaces key-based lookup
- Relevance scoring replaces exact matching
- Retrieval quality directly determines output quality (garbage context → garbage output)

### Anti-Corruption Layer → LLM Output Boundary

The ACL pattern — translating between two systems with different models — maps directly to the agent-system boundary. LLM output is unstructured text. Your system needs typed, validated data. The ACL:
- Parses structured output (JSON) from LLM text
- Validates against schemas
- Handles parsing failures with retry/fallback
- Prevents "model hallucination corruption" from propagating into your system

This is not optional. Every LLM integration needs an ACL at the output boundary.

### Feature Flags → Capability Flags for Agents

Feature flags evolve into **capability governance**: which tools is this agent allowed to use? Which actions can it take autonomously vs. requiring approval? This becomes a runtime policy engine, not just a boolean toggle.

---

## Part 3: Genuinely New Patterns

These patterns have no direct classical ancestor. They arise from problems unique to LLM-agent systems.

### 1. Context Engineering (Token Budget Management)

**Problem:** An agent's context window is finite (8K–200K tokens) and *everything the agent knows* must fit in it. Unlike databases (disk is cheap), context is precious and directly determines quality.

**Pattern:** Decompose context into typed layers — instruction, knowledge, state, task — each with a token budget. Score items by relevance. Fill greedily by priority. Track what was excluded (manifest) for debugging.

**Structure:**
```
Context Window (budget: N tokens)
├── Instruction layer (15%) — system prompt, persona, constraints
├── Knowledge layer (25%) — docs, API refs, domain knowledge
├── State layer (40%) — diffs, current files, conversation history
└── Task layer (20%) — current request, decomposed subtasks
```

**Key decisions:**
- Static content (instruction, docs) forms a cacheable prefix
- Dynamic content (state, task) changes per turn
- Older conversation history gets summarized/compressed, not dropped
- Different task types get different budget allocations (skill-based routing)

**This is to agents what memory management is to operating systems.** The most sophisticated coding agents (Claude Code, Cursor, Copilot) spend enormous engineering effort here. Andrej Karpathy and Shopify's Tobi Lütke both called this out in 2025: "context engineering over prompt engineering."

**Sources:** Karpathy (2025), SitePoint context engineering tutorial (Feb 2026), Henry Vu context engineering guide (Feb 2026)

### 2. Guardian / Sentinel Pattern (LLM-as-Judge)

**Problem:** Agent output is nondeterministic and can be wrong, harmful, or policy-violating. You can't unit-test every possible output.

**Pattern:** Deploy a separate "judge" agent (often a different, cheaper model) that evaluates the primary agent's output before it reaches the user or executes an action. The judge scores quality, checks policy compliance, and flags issues.

**Variants:**
- **Input Sentinel:** Validates/sanitizes inputs before they reach the agent (prompt injection defense)
- **Output Auditor:** Evaluates agent responses on quality, safety, relevance
- **Self-Refine Loop:** Generate → evaluate → retry with feedback → repeat until quality threshold met
- **Cross-Model Judging:** Use a different model for judging to avoid narcissistic bias (generate with Claude, judge with GPT)

**Key insight:** The judge must be cheaper and faster than the generator, otherwise you've doubled your cost. Deterministic checks (schema validation, regex, keyword filters) should run first; LLM-based judging only for what deterministic checks can't catch.

**This is the software equivalent of "separation of duties" from security — the entity that creates should not be the entity that approves.**

**Sources:** TRiSM framework (2026), Spring AI SelfRefineEvaluationAdvisor, Patronus AI guardrails, OWASP Agentic AI guidelines

### 3. Human-in-the-Loop Gate

**Problem:** Agents can take irreversible actions (send emails, delete databases, commit code, make purchases). Blind autonomy is unacceptable for high-stakes operations.

**Pattern:** Define a **risk taxonomy** for agent actions. Low-risk actions (search, read) execute autonomously. High-risk actions (delete, send, purchase) pause execution and require human approval. The gate is a first-class state in the agent's state machine.

**Implementation:** LangChain's `HumanInTheLoopMiddleware` with `interrupt_on` per tool. The agent's state is checkpointed so it can resume after approval.

**Design tension:** Too many gates → humans become bottlenecks and agents provide no value. Too few → agents cause damage. The right calibration is: **gate irreversible actions, auto-approve read-only operations, and have an audit trail for everything.**

### 4. Capability Card / Agent Registry

**Problem:** In multi-agent systems, how does Agent A discover that Agent B can handle tax questions while Agent C handles code review?

**Pattern:** Each agent publishes a **Capability Card** — a machine-readable description of what it can do, what inputs it accepts, what outputs it produces, and what permissions it requires. An Agent Registry indexes these cards for discovery.

**Implementations:**
- Google A2A: Agent Cards retrieved via HTTP
- MCP: Tool manifests with JSON schemas
- TEA Protocol: Hierarchical tool/agent/environment registration with embedding-based retrieval

**This is service discovery for agents.** DNS + service mesh, but for AI actors. The card format is converging on: name, description, input/output schemas, authentication requirements, and capability constraints.

**Sources:** Google A2A spec (2025), AgentOrchestra TEA Protocol (2026), survey of agent interoperability protocols (arxiv, 2025)

### 5. Nondeterminism Envelope

**Problem:** LLM calls are not functions. Same input → different output. This breaks every assumption in traditional error handling, caching, and testing.

**Pattern:** Wrap every LLM call in an envelope that handles:
- **Retry with evaluation** — retry if output fails quality check (not just on HTTP error)
- **Temperature management** — deterministic for classification (temp=0), creative for generation
- **Output validation** — schema check, type coercion, constraint verification
- **Fallback chain** — try Model A → if bad output, try Model B → if still bad, return graceful degradation
- **Caching with semantic keys** — cache not by exact input but by semantic similarity of the request

**This is the Circuit Breaker pattern generalized for probabilistic systems.** Classical Circuit Breaker trips on failure/timeout. Nondeterminism Envelope trips on *quality* — the call succeeded but the output is bad.

### 6. Memory Hierarchy

**Problem:** Agents need memory at multiple timescales, but context windows are finite. A human remembers millions of experiences; an agent forgets everything between sessions unless you build memory infrastructure.

**Pattern:** Three-tier memory architecture:
- **Working Memory** (context window) — current conversation, active task, recent tool results. Managed by Context Engineering pattern.
- **Session Memory** (persistent per session) — rolling summary of conversation, extracted decisions, accumulated context. Compression and summarization maintain quality as conversation grows.
- **Long-Term Memory** (cross-session) — user preferences, learned patterns, factual knowledge extracted from past sessions. Stored in vector DB or structured store. Retrieved via RAG when relevant.

**Key design decision:** When and how to promote from one tier to another. Microsoft Foundry's Memory service (Dec 2025) automates extraction and consolidation. Most systems still do this manually.

**This is the CPU cache hierarchy (L1/L2/L3/DRAM) mapped to agent cognition.** Same trade-offs: faster access = smaller capacity = more expensive.

### 7. Prompt-as-Contract (Constitution Pattern)

**Problem:** The system prompt is the agent's "API." But it's free-form text, unversioned, untested, and fragile. A one-word change can completely alter agent behavior.

**Pattern:** Treat system prompts as versioned, tested, deployed artifacts:
- **Version control** — prompts in git, diff-reviewable, with PR-like approval
- **Schema sections** — XML/markdown-tagged sections (identity, boundaries, tools, examples) for modularity
- **Regression testing** — automated test suites that verify behavior across prompt versions
- **Progressive rollout** — deploy prompt changes via feature flags (canary prompt → monitor metrics → full rollout)

**The name "Constitution"** comes from Anthropic's Constitutional AI, but the pattern is broader: the prompt is the social contract between the system designers and the agent's behavior. It must be governed like infrastructure code, not treated like a comment.

**Sources:** OpenAI GPT-4.1 prompting guide (3 sentences that improved SWE-bench by 20%), Anthropic prompt engineering docs, Spotify engineering blog (static versioned prompts outperform dynamic ones for autonomous agents)

### 8. Hierarchical Delegation

**Problem:** Complex tasks require decomposition, but a single agent with many tools becomes confused and slow. The Saga pattern assumes predetermined steps; agent tasks aren't predetermined.

**Pattern:** Three-tier agent hierarchy:
- **Planning Agent** — decomposes task, creates subtask list, assigns to specialists, monitors progress, adapts plan on failure
- **Specialist Agents** — domain-specific (code agent, research agent, data agent), each with narrow tool set and focused system prompt
- **Tool Layer** — deterministic executors (file I/O, API calls, database queries) with no LLM reasoning

**Key property:** Planning agents don't touch tools directly. Specialist agents don't do high-level planning. Tools don't reason. Each tier has clear responsibilities.

**This is the Command pattern + Chain of Responsibility, but with autonomous actors at each level.** The critical difference from classical delegation: the planning agent must handle *dynamic replanning* when a specialist fails or discovers new requirements mid-execution.

**Sources:** AgentOrchestra (2026), Google ADK multi-agent patterns, OpenAI Swarm, LangGraph hierarchical agents

### 9. Sandboxed Execution Envelope

**Problem:** Agents execute code, modify files, call APIs. A hallucinated `rm -rf /` is one tool call away.

**Pattern:** Every agent action executes in an isolated sandbox with:
- **Filesystem isolation** — agent sees only its workspace, not the host
- **Network policy** — allowlist of permitted endpoints
- **Resource limits** — CPU, memory, time caps
- **Permission model** — least-privilege tool access; agent can read files but needs elevation to write; can search but needs approval to send
- **Audit logging** — every action recorded with full context

**Implementations:** Docker containers (OpenHands, AgentOrchestra), Firecracker micro-VMs (Gondolin), dedicated OS users (lightweight alternative), WASM sandboxes (emerging).

**This is the container/VM security model applied to agent actions.** The pattern is not new, but the application to AI agents is, and the threat model is different: you're defending against your own agent's mistakes, not external attackers.

**Sources:** [Gondolin vs Matchlock comparison](gondolin-vs-matchlock.md), [Agent as separate macOS user](agent-separate-macos-user.md), OWASP Top 10 for LLM Applications

### 10. Asymmetric Verification

**Problem:** Generating correct output is hard (expensive model, many tokens, high latency). Verifying output is often cheap (run the code, check the schema, diff against expected, execute the test suite).

**Pattern:** Exploit the asymmetry: use expensive/capable models for generation, then verify with cheap/fast methods:
- Generated code → run tests (deterministic verification)
- Generated SQL → execute against test DB and check results
- Generated analysis → check factual claims against source documents
- Generated plan → simulate execution in lightweight environment

**Key insight:** Verification doesn't need to be LLM-based. Deterministic checks (type checking, test execution, schema validation) are infinitely more reliable than LLM-based judging. Use LLM judges only for subjective quality.

**This is dual to the Guardian pattern but emphasizes using the *cheapest possible verification*, not necessarily another LLM.**

**Sources:** [LLM Capability vs Pseudo-Capability](llm-capability-vs-pseudo-capability.md), [Post-Nov 2025 Model Failure Antidotes](post-nov-2025-model-failure-antidotes.md)

---

## Pattern Interaction Map for Agent Systems

Common compositions in production agent architectures:

```
State Machine + Hierarchical Delegation + Human-in-the-Loop Gate
  → Safe multi-agent workflow with approval checkpoints

Context Engineering + Memory Hierarchy + Retrieval (RAG)
  → Full knowledge management stack for agent cognition

Nondeterminism Envelope + Guardian/Sentinel + Asymmetric Verification
  → Complete output quality assurance pipeline

Capability Card + Agent Registry + A2A Protocol
  → Multi-agent discovery and coordination infrastructure

Sandboxed Execution + Audit Logging + Permission Model
  → Agent security stack

Prompt-as-Contract + Feature Flags + Progressive Delivery
  → Safe prompt deployment pipeline

Circuit Breaker + Model Fallback + Token Budget Management
  → Agent resilience against provider failures
```

---

## Patterns That Decline in Importance

Not everything gets amplified. Some patterns become less relevant:

- **Singleton** — Already mostly an anti-pattern; agents don't need global state
- **GoF Creational patterns** (Factory, Builder, Prototype) — Agents generate code that uses these, but system architects don't think in these terms when designing agent systems
- **Active Record** — The tight coupling between domain and persistence is toxic in agent systems where the "domain" is fluid and LLM-driven
- **Two-Phase Commit** — Already rare; even less applicable when one "participant" is a nondeterministic LLM

---

## What's Still Missing (Open Problems, Not Yet Patterns)

1. **Agent Identity and Trust** — How does Agent A verify that Agent B is who it claims to be, running the code it claims to run? DIDs (Decentralized Identifiers) are proposed but not battle-tested. We don't have a TLS-equivalent for agent-to-agent trust.

2. **Cost-Aware Routing** — Agents should dynamically choose between models based on task complexity vs. cost. Simple classification → cheap model. Complex reasoning → expensive model. No standard pattern exists; everyone builds ad-hoc routing.

3. **Graceful Capability Degradation** — When the best model is unavailable, how does the agent degrade? Not just Circuit Breaker failover (which returns errors), but *reduced-capability mode* where the agent acknowledges its limitations and adjusts behavior.

4. **Long-Horizon Consistency** — Agents working on tasks over hours or days need to maintain consistent reasoning as their context window slides. There's no good pattern for "was my decision at step 47 consistent with my reasoning at step 3?"

5. **Multi-Agent Conflict Resolution** — When Agent A says "deploy" and Agent B says "don't deploy," who wins? Voting? Hierarchy? Consensus? This is unsolved in practice — most systems avoid it by having strict hierarchies.

6. **Adversarial Robustness as Architecture** — Prompt injection, tool-use manipulation, and social engineering of agents are ongoing threats. Current defenses are ad-hoc (input filtering, output validation). A principled architectural pattern — something like "zero-trust for agent cognition" — doesn't exist yet.

---

## Summary: The Pattern Landscape Shift

| Category | Classical World | Agent World |
|----------|---------------|-------------|
| **Control flow** | Deterministic, programmer-defined | Probabilistic, LLM-chosen within constraints |
| **Interfaces** | Typed function signatures | Natural language + schemas |
| **Error handling** | Exception → retry → fail | Bad output → evaluate → retry with feedback → fallback model |
| **State management** | Database + cache | Context window + memory hierarchy + persistent store |
| **Testing** | Unit/integration tests | Eval suites + LLM-as-judge + deterministic verification |
| **Security** | AuthN/AuthZ + network policy | All of the above + prompt injection defense + sandboxing + capability scoping |
| **Deployment** | Blue-green, canary | All of the above + prompt versioning + model version pinning |
| **Observability** | Logs + metrics + traces | All of the above + decision traces + context manifests |

The most important meta-pattern: **every classical pattern needs a "nondeterminism wrapper"** when applied to agent systems. The agent might not follow the state machine. The tool call might return nonsense. The output might violate the schema. Design for probabilistic behavior at every boundary.

---

## Sources

- AgentOrchestra: Hierarchical Multi-Agent Framework (arxiv, Jun 2025) — TEA Protocol, agent design principles
- Google ADK Multi-Agent Patterns (developers.googleblog.com, Dec 2025) — Sequential, Coordinator, Parallel, Loop patterns
- TRiSM for Agentic AI (arxiv, Jun 2025) — Trust, Risk, Security Management framework
- Survey of Agent Interoperability Protocols (arxiv, May 2025) — MCP, ACP, A2A, ANP comparison
- Context Engineering: The New Prompt Engineering (SitePoint, Feb 2026) — Token budgeting, context payload schema
- What Fills the Context Window (henryvu.blog, Feb 2026) — Seven components, real token budget breakdown
- LLM-as-Judge with Spring AI Recursive Advisors (spring.io, Nov 2025) — Self-refine evaluation pattern
- Microsoft Foundry December 2025 release — A2A Tool, Memory service, MCP Server
- Agentic AI and Cybersecurity Survey (arxiv, Jan 2026) — Security benchmarks, threat taxonomy
- Policy-as-Prompt: Automated Guardrail Synthesis (arxiv, Sep 2025) — Input/output classification, least-privilege enforcement
- HADA: Human-AI Agent Decision Alignment (arxiv, Jun 2025) — Tools Pattern, layered architecture
- Architecting Agentic MLOps with A2A and MCP (InfoQ, Feb 2026) — Practical orchestration/specialist/tool separation
- Agentic AI: Architectures and Taxonomies (arxiv, Jan 2026) — Graph-based orchestration, flow engineering
- Prior research in this repo: [LLM Capability vs Pseudo-Capability](llm-capability-vs-pseudo-capability.md), [Post-Nov 2025 Model Failure Antidotes](post-nov-2025-model-failure-antidotes.md), [Gondolin vs Matchlock](gondolin-vs-matchlock.md), [Agent Security Landscape](agent-security-landscape-what-people-do.md)
