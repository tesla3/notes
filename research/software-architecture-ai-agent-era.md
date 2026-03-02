← [Software Design Patterns](software-design-patterns-by-problem-domain.md) · [Software Factory](../topics/software-factory.md) · [Index](../README.md)

# Software Architecture in the AI/Agent Era

*March 1, 2026*

*What architectural patterns become dominant when LLMs and autonomous agents are first-class participants in software systems — not just tools bolted onto existing designs? This isn't speculation — it's inference from convergent evidence across practitioner reports, architectural experiments, and emerging production systems.*

---

## The Core Thesis

The transition isn't "existing architecture + AI features." It's a structural inversion of what software architecture optimizes for.

**Traditional architecture optimizes for:** human comprehension, human coordination, human debugging, deterministic behavior.

**AI-era architecture optimizes for:** machine navigability, automated verification, graceful probabilistic failure, progressive discovery, and audit/replay of non-deterministic actions.

These aren't opposed — but when they conflict, the second set wins more often going forward. The analogy: the shift from hand-crafted manufacturing to automated production didn't just add robots to existing factory floors. It redesigned factories around what robots need (consistent inputs, sensor-rich environments, modular stations) while keeping what humans still do (exception handling, design, policy).

---

## I. Verified-by-Construction Architecture

### The pattern

Every component in the system is wrapped in machine-readable specifications that enable automated verification. Architecture is designed testability-first, not as an afterthought. The "specification sandwich" — types at the boundary, contracts at the semantic layer, property-based tests at the behavioral layer — becomes the standard layering.

### Evidence

- **Harness engineering consensus:** LangChain gained +13.7 points by adding automated verification. Stripe merges 1000+ agent-generated PRs/week because their verification harness catches errors *during* agent sessions, not after. Every serious harness engineering source ([harness engineering insights](harness-engineering-insights-and-practices.md)) ranks verification as the #1 leverage point, above model choice.
- **Dark factory thesis:** The [dark factory review](dark-software-factory-review.md) concluded that SDD (Spec-Driven Development), initially dismissed as overkill for interactive developers, becomes *the control system* for autonomous production. Machine-readable intent (specs) is required to verify machine-generated output (code). Without it, you're reviewing every line manually, which is the bottleneck that defeats the entire system.
- **StrongDM's proprietary moat:** They open-sourced the execution engine but kept the verification layer proprietary — DTU, scenario holdouts, satisfaction scoring, LLM-as-judge. The verification layer is where the value lives.
- **Convergence with AI training:** Frontier labs independently discovered the same 3-part architecture for verifying AI output (simulation environments, holdout evaluation criteria, outcome-based scoring) that software factory verification uses. The [verification-alignment convergence](../topics/software-factory.md) is structural, not coincidental.

### What this means architecturally

- **Contracts become load-bearing.** Today, contracts (pre/post conditions, invariants) are optional documentation. In agent-produced systems, they're the verification surface. Architecture must expose contracts at every interface boundary — between modules, between services, between agents. Without them, there's no automated way to know if agent output is correct.
- **"Tighten as confidence grows" replaces "design up front."** Start with loose contracts, let agents generate code, tighten contracts as behavior stabilizes. This is the contract gradient pattern — new to this era.
- **Architectural fitness functions graduate from aspiration to necessity.** The 20-line `test_no_backward_imports()` pytest that enforces layered dependencies isn't a nice-to-have — it's the agent guardrail that prevents architectural erosion across thousands of autonomous changes. Evolutionary architecture (Thoughtworks, 2017) proposed fitness functions as an idea; autonomous agents make them mandatory.

---

## II. Orchestration-as-Architecture

### The pattern

The orchestration layer — how work gets decomposed, delegated, coordinated, and verified — is no longer infrastructure. It IS the architecture. The model is a commodity input; the orchestration graph is the product.

### Evidence

- **Kiro Autonomous Agent:** Decomposes objectives into subtasks, assigns to specialized sub-agents (research, implementation, verification), runs 10 concurrent tasks, maintains cross-session context, learns from code review feedback. This is a task graph, not a tool. ([dark factory review](dark-software-factory-review.md))
- **Carlini compiler experiment:** 16 agents collaborating on a shared codebase for 2 weeks. The human role shifted entirely to designing test harnesses and orchestration policy — not writing or even reviewing code. The architecture was the orchestration, not the code it produced.
- **Crawshaw's attribution error:** Crawshaw claims "it's all about the model" and harnesses "have not improved much." The thread pushes back hard. The Claude Code harness is the differentiator — improvements in scaffolding get credited to the model because users can't distinguish the two. ([eight more months](hn-eight-more-months-agents.md))
- **Durable execution landscape:** Temporal, Inngest, Restate, DBOS, Absurd — all converging on the same problem: reliable multi-step workflows with checkpointing, compensation, and replay. Agent workflows need exactly this. ([durable execution research](absurd-durable-execution-landscape.md))

### What this means architecturally

- **The Saga pattern becomes the default execution model.** Agent workflows are inherently multi-step with partial failure. Compensating transactions (undo semantics) move from "advanced distributed systems pattern" to "the way everything works." The difference: traditional sagas coordinate services; agent sagas coordinate agents + services + human approvals.
- **State machines for workflow control.** LangGraph is literally a graph/state machine for agent workflows. This isn't a coincidence — state machines are the natural representation of "do A, then conditionally B or C, checkpoint, wait for human approval, then D." Expect state-machine-based orchestration to become as common as REST routing is today.
- **Decomposition shifts from "by business capability" (microservices) to "by verifiable task."** The unit of work isn't a service — it's a task that can be independently specified, executed, and verified. This is a more granular and more flexible decomposition than microservices, and it doesn't require network boundaries.

---

## III. Progressive Discovery Architecture

### The pattern

Systems don't pre-load schemas, capabilities, or context. They discover what they need on demand, loading just enough to act. This is the architectural equivalent of lazy evaluation applied to the entire system surface.

### Evidence

- **MCP → CLI convergence:** Five independent teams (CLIHub, mcpshim, mcporter, mcp-cli, CMCP) built MCP-to-CLI converters in the same week. Cloudflare shipped Code Mode (2 tools covering 2,500+ endpoints in ~1,000 tokens). Anthropic shipped Tool Search. All converged on the same principle: don't dump everything upfront. ([MCP cheaper via CLI](hn-mcp-cheaper-via-cli.md))
- **The KV cache insight:** CLI discovery happens as append-only conversation turns, preserving the KV cache. MCP tool definitions injected at prompt start invalidate the cache when they change. Progressive discovery is not just cheaper — it's architecturally compatible with how LLMs actually work.
- **Smaller models benefit disproportionately:** "Even the smallest models are RL-trained to use shell commands perfectly. Gemini 3 Flash performs better with a CLI of 20 commands vs 20+ MCP tools." Progressive discovery widens the pool of viable models.

### What this means architecturally

- **Catalog vs. runtime separation.** MCP won as the catalog standard even among its critics — every CLI converter takes MCP as input. The emerging pattern: a universal capability registry (MCP-like) with multiple execution surfaces (CLI, Code Mode, direct API). This is analogous to DNS — a universal naming layer that doesn't prescribe the transport protocol.
- **Service discovery becomes semantic discovery.** Traditional service discovery (Consul, etcd, DNS) resolves names to addresses. Agent service discovery resolves *intents* to *capabilities*. "I need to send an email" resolves to a specific tool + auth context + invocation pattern, discovered at runtime. This is qualitatively different from anything in the microservices playbook.
- **APIs design for progressive disclosure.** Root endpoint → capability categories → specific tool schema → invocation. Each layer adds tokens only when needed. APIs that dump their full schema in one response will be penalized by cost and by context pollution. This is the opposite of GraphQL's "ask for everything you need in one query" — it's "ask for the minimum, drill deeper only when necessary."

---

## IV. Memory-as-Architecture

### The pattern

Explicit, tiered memory systems become a first-class architectural concern — as fundamental as databases were to the previous era. Not just "caching" but structured knowledge persistence across sessions, projects, and organizations.

### Evidence

- **The trust reset problem:** "With your real junior dev you build trust over time. With the agent I start over at a low trust level again and again." ([beyond agentic coding](hn-beyond-agentic-coding.md)) Current agents are memoryless strangers every session. This means review burden never decreases — it's permanently high unless the architecture solves memory.
- **Kiro's structural lead:** Persistent cross-session context, learns from code review feedback, applies patterns to subsequent work. This is the beginning of *institutional memory* — the factory remembering how to build your product. ([dark factory review](dark-software-factory-review.md))
- **Tribal knowledge scales inversely with team size:** "Agents are really great at bespoke personal flows that build up a TON of tribal knowledge. Doing this in larger theaters is much more difficult because tribal knowledge is death for larger teams." ([eight more months](hn-eight-more-months-agents.md))

### What this means architecturally

- **Three-tier memory model.** Session memory (context window), project memory (AGENTS.md, specs, architectural decisions), institutional memory (learned patterns across projects, code review preferences, team conventions). Each tier has different persistence, sharing, and eviction strategies. This parallels CPU cache hierarchies — L1/L2/L3 — and will require similar architectural thinking.
- **Memory becomes the moat.** The factory that remembers "last time I refactored this service, the team asked me to preserve the logging format" outperforms the factory that treats every task as greenfield. Institutional memory is extremely hard to replicate — it's the accumulated judgment of a specific organization. This is why Kiro's cross-session learning gives it a structural lead.
- **Vector stores + knowledge graphs as standard infrastructure.** Pure vector search has limits (retrieval recall degrades with corpus size, semantic similarity ≠ relevance). The emerging stack is hybrid: vector for fuzzy recall, graph for structured relationships, relational for exact lookup. Every major database vendor adding vector capabilities (pgvector, MongoDB Atlas Vector Search) is evidence that this is becoming baseline infrastructure, not a specialty.

---

## V. Reviewability-First Architecture

### The pattern

Architecture is designed to minimize the cognitive cost of human review, not the cost of initial implementation. This is a direct inversion of current priorities.

### Evidence

- **Amdahl's Law for dev workflows:** Agentic coding parallelizes only the generation step. Review, comprehension, and team synchronization remain sequential and become the dominant bottleneck. ([beyond agentic coding](hn-beyond-agentic-coding.md))
- **Mental model desynchronization:** "No matter how fast the models get, it takes a fixed amount of time for me to catch up and understand what they've done." Speed doesn't solve this. ([beyond agentic coding](hn-beyond-agentic-coding.md))
- **The coherence ceiling:** "Past the coherence ceiling, gains must come from improving shared artifacts (clearer commits, smaller diffs, stronger invariants) rather than raw output." The architecture that wins is the one that makes agent output *understandable*, not just *correct*.
- **Agent code lacks breadcrumbs:** Agent-written code lacks the "breadcrumbs of thinking" (commit messages, PR descriptions, stylistic tells) that human code leaves behind, making review actively harder than reviewing human code.

### What this means architecturally

- **Semantic project navigation replaces file-tree navigation.** Gabriel439's facet navigator prototype — browsing code by semantic clusters instead of file paths — generated genuine excitement because it addresses the real problem: navigating agent-generated code is harder than navigating human-written code. ([beyond agentic coding](hn-beyond-agentic-coding.md)) Expect codebase architecture to be designed for semantic navigation, not just module boundaries.
- **Architectural Decision Records (ADRs) become machine-written and machine-enforced.** Every agent action that changes architecture gets an automated ADR. These aren't optional documentation — they're the audit trail that makes review possible at scale. The pattern exists today; agent-era architecture makes it mandatory.
- **Small, independently verifiable changes over large coherent ones.** The auto-splitting PR pattern (stacked PRs from big diffs, structure vs. behavior separation) becomes an architectural principle. Systems designed so that every change is small enough for a human to review in one sitting, with automated verification for the rest.
- **Observable architecture.** Not just observability (metrics, logs, traces) but *architectural observability*: can a human quickly understand what the system does, why it's structured this way, and what changed since last review? This drives toward explicit module boundaries, enforced dependency directions, and generated architecture diagrams that stay in sync with code.

---

## VI. Adversarial-by-Default Interface Design

### The pattern

Every API and interface assumes its consumers are autonomous agents with misaligned incentives. Trust is not assumed; it's negotiated per-request.

### Evidence

- **"SEO all over again but worse":** "It's basically SEO all over again but worse, because the attack surface is the user's own decision-making proxy. Prompt injection on e-commerce sites manipulating your agent's vendor selection." ([eight more months](hn-eight-more-months-agents.md))
- **No trust layer exists:** "A trust layer between agents and services becomes necessary — but nobody's building it." The gap between the need and the solution is the architectural opportunity.
- **Agent security landscape:** The entire [agent security research corpus](agent-security-landscape-what-people-do.md) confirms that current agent interfaces have no meaningful trust model. MCP servers are trusted implicitly. CLI tools run with full user permissions.

### What this means architecturally

- **Capability-based security for agent interfaces.** Instead of "this agent has access to everything," each tool invocation gets a scoped capability token. The agent can read this file but not that one; can query this API but not mutate it; can spend up to $X but not more. This is object-capability security (ocap) — a 50-year-old idea that finally has a killer use case.
- **Attestation and provenance as first-class concerns.** Who generated this code? What model? What prompt? What verification was run? Provenance metadata becomes as important as the code itself. This parallels supply-chain security (SBOMs, Sigstore) but applied to AI-generated artifacts.
- **Rate limiting becomes semantic, not volumetric.** Traditional rate limiting: 100 requests/minute. Agent-era rate limiting: "this agent has made 5 architecture-altering changes today, require human approval for the 6th." The throttle is on *impact*, not *volume*.

---

## VII. Event-Sourced Agent Actions

### The pattern

All agent actions are recorded as an append-only event stream. The current state is a projection of that stream. This enables replay, audit, rollback, and reprojection — capabilities that are optional luxuries in deterministic systems but essential infrastructure in non-deterministic ones.

### Evidence

- **The reprojection argument:** Event Sourcing's real benefit isn't audit trails (a log table does that) — it's the ability to reproject: build new views of historical data when understanding changes retroactively. ([design patterns research](software-design-patterns-by-problem-domain.md)) When an agent does something subtly wrong that's discovered a week later, reprojection lets you understand the full causal chain.
- **Durable execution convergence:** Temporal, Inngest, Restate all provide event-sourced workflow execution with checkpointing and replay. Agent workflows need exactly this — especially long-running autonomous operations that may need to be rolled back.
- **Verification requires replay:** If you want to verify agent behavior post-hoc (not just the output, but the *process*), you need a complete record of every action, every tool call, every decision point. This is event sourcing by necessity.

### What this means architecturally

- **Agent action logs become a core data store.** Not application logs — structured event streams of every agent decision, tool call, result, and state transition. This is the basis for debugging, auditing, billing, and training.
- **Compensation over rollback.** In agent systems, "undo" often means "do the opposite" (send a correction email, revert a deploy, close the PR), not "restore previous state." This is the compensating transaction pattern from distributed systems, applied ubiquitously.
- **Temporal queries become standard.** "What was the state of the system at 3pm Tuesday?" "Show me all changes this agent made between commit X and commit Y." "Replay the agent's decision process for this specific PR." These are not debugging tools — they're routine operational queries.

---

## VIII. The Collapsing Middle: Thin Wrappers and Deep Primitives

### The pattern

The traditional application stack (framework → business logic → database) collapses. Frameworks become less valuable (agents regenerate boilerplate cheaper than learning a framework). The value concentrates at two extremes: **deep primitives** (databases, compilers, protocols, verification engines) and **thin orchestration layers** (agent harnesses, workflow engines, tool registries).

### Evidence

- **The LISP Curse returns:** Shared frameworks create network effects for bug discovery. Bespoke agent-generated code fragments that network into millions of unique snowflakes, each carrying the same latent bugs that framework communities spent years fixing. ([coding agents replaced frameworks](hn-coding-agents-replaced-frameworks.md))
- **But the economics are real:** Frameworks primarily exist to minimize boilerplate, and AI is very good at boilerplate. GitClear 2025 research shows 4x growth in code clones and copy/paste exceeding moved code for the first time. The middle layer (frameworks) is being compressed.
- **Training data commons problem:** If the industry shifts from shared frameworks to bespoke generated code, the open-source ecosystem that produces training data atrophies. This is a slow-moving tragedy of the commons. The snake eats its tail: agents are trained on framework code, so "building from scratch" reconstructs a worse version of the framework.
- **Deep primitives gain value:** DuckDB, SQLite, TigerBeetle, PostgreSQL — these become *more* important because agents need reliable, well-specified primitives to compose into solutions. The database doesn't go away; the ORM does.

### What this means architecturally

- **Compose primitives, don't build frameworks.** The winning architecture provides agents with powerful, well-documented primitives and lets them compose solutions. This favors Unix philosophy (small tools, clear interfaces, composable) over monolithic framework philosophy.
- **The "specification layer" replaces the "framework layer."** Instead of frameworks encoding best practices as library code, specs encode best practices as verifiable constraints. The agent generates implementation; the spec ensures it meets the constraints. This is the structural replacement: from "use Rails" to "satisfy these architectural fitness functions."
- **Libraries that survive are the ones agents can't regenerate.** Cryptography, database engines, consensus protocols, compilers — anything where correctness requires deep domain expertise and adversarial hardening. Application-level libraries (HTTP routing, form validation, date formatting) are the most vulnerable.

---

## IX. Human-in-the-Loop as Architectural Control Flow

### The pattern

Human approval, review, and judgment become explicit nodes in the system's control flow graph — not afterthoughts or external processes. Architecture must model where humans intervene, what information they need at each point, and what happens when they reject or redirect.

### Evidence

- **The $170 taste gap:** Autonomous agentic coding on a Google Docs clone, 8 hours, $170 in tokens. "Abstractly impressive, completely useless." Scrolling wrong, tables can't be resized, no account management. UX-driven products require *taste*. ([eight more months](hn-eight-more-months-agents.md))
- **The 4.9-day process:** LLM wrote correct AWS CLI + GitHub Actions in 1 minute. Getting IAM permissions and S3 bucket policies took 4.9 days out of 5. The actual bottleneck is organizational, not technical.
- **Every serious agent deployment has HITL:** Kiro's human-review gates, Stripe's PR review process, StrongDM's exception layer. Nobody ships fully autonomous agent output in production without checkpoints.

### What this means architecturally

- **Approval gates as first-class architectural components.** Not "add a Slack notification" — structured approval workflows with context presentation, diff views, impact assessment, and escalation paths. The architecture must know which changes are high-risk (schema migrations, security changes, public API modifications) and route them to appropriate human reviewers.
- **Impact-proportional autonomy.** Low-impact changes (formatting, test additions, documentation) get auto-approved. Medium-impact changes (new features within existing patterns) get lightweight review. High-impact changes (architectural modifications, security-sensitive code) require deep human review. The architecture encodes these tiers.
- **The human is a service with SLAs.** Uncomfortable but architecturally necessary: if the orchestration system needs human input, it must handle the "human is slow" problem the same way it handles a slow API — timeout, fallback, queue management, priority routing.

---

## X. Cost-Aware Architecture

### The pattern

LLM inference cost and latency become first-class architectural constraints — as fundamental as database query cost was in the LAMP era. Architecture must minimize token consumption the way previous generations minimized database queries.

### Evidence

- **The per-turn context replay problem:** 10 tool calls on a 100K conversation means 1-5M input tokens. Cache hit rates can be as low as 40% in practice. This dwarfs tool definition overhead. ([MCP cheaper via CLI](hn-mcp-cheaper-via-cli.md))
- **Model routing is already real:** "Cheap model for easy tasks, expensive for hard" — this is the architectural pattern, not just a cost optimization. Frontier models for architectural decisions, small models for boilerplate generation, no model at all for deterministic checks.
- **Semantic caching:** Cache based on meaning, not exact match. If the same question was asked differently last session, return the cached answer. This is a new caching layer that didn't exist in traditional architecture.

### What this means architecturally

- **Token budgets per task.** Just as you'd set a query budget for a database-heavy page load, agent workflows get token budgets. Exceeding the budget triggers escalation or simplification, not unbounded spending.
- **Deterministic-first, LLM-last.** If a task can be solved with a regex, a SQL query, or a rule engine, don't use an LLM. LLMs handle the ambiguous/creative/judgment-heavy parts. This reverses the current trend of "throw an LLM at everything" and creates a design principle: minimize the surface area where non-determinism is introduced.
- **The model router becomes standard infrastructure.** Like a load balancer but for model selection: route classification tasks to a small model, code generation to a medium model, architectural reasoning to a frontier model. The router itself may be an LLM, creating a recursive architecture.

---

## Synthesis: What Traditional Patterns Survive, Transform, or Die

### Reinforced (become more important)

| Pattern | Why |
|---------|-----|
| **Event Sourcing** | Audit, replay, reprojection of non-deterministic agent actions |
| **Saga / Compensating Transaction** | Agent workflows are inherently multi-step with partial failure |
| **Circuit Breaker** | LLM calls fail differently (hallucination, refusal, cost overrun) than RPC |
| **Idempotency** | Agents retry aggressively; operations must be safe to repeat |
| **Specification Pattern** | Machine-readable intent becomes the verification surface |
| **CQRS** | Read-optimized views for human review; write-optimized paths for agent generation |
| **Strangler Fig** | Incremental migration of human-written systems to agent-maintained systems |

### Transformed (same name, different meaning)

| Pattern | Transformation |
|---------|----------------|
| **Service Discovery** | Name→address becomes intent→capability (semantic, not syntactic) |
| **API Gateway** | Becomes agent gateway: model routing, cost tracking, capability scoping, semantic rate limiting |
| **Service Mesh** | Becomes agent mesh: managing agent-to-agent communication, trust propagation, context sharing |
| **Load Balancer** | Becomes model router: task classification → model selection |
| **Feature Flags** | Become autonomy flags: controls whether agents operate autonomously or require human approval per feature area |

### Dying or Declining

| Pattern | Why |
|---------|-----|
| **Traditional MVC / MVVM** | UI generation becomes dynamic; rigid view layers lose purpose when agents generate interfaces |
| **ORM** | Agents compose SQL directly against well-documented schemas; the abstraction layer adds cost without value |
| **Template-based code generation** | Agents generate code directly; scaffolding/templates become unnecessary indirection |
| **Centralized style guides (as human-readable docs)** | Replaced by linter rules, architectural tests, and AGENTS.md — machine-enforceable, not human-memorized |
| **Manual dependency injection** | Agents discover and compose dependencies at runtime via progressive discovery |

---

## The Uncomfortable Predictions

1. **Most "AI-native" architectures today are just traditional architectures with an LLM API call bolted on.** The real transition hasn't started for most teams. It requires rethinking the entire verification surface, orchestration model, and memory architecture — not just adding a `/chat` endpoint.

2. **Natural language as an inter-service protocol will mostly fail.** It's inherently lossy. Agent-to-agent communication will converge on structured formats (tool calls, typed events) with natural language reserved for human interfaces. The "agents just talk to each other in English" vision is the distributed systems equivalent of "just use strings for everything."

3. **The architecture that wins is boring.** Event sourcing, sagas, capability-based security, specification-driven development — none of these are new ideas. They're ideas that were "too complex" for most teams when humans wrote all the code. Agent-generated systems need the rigor, so the rigor becomes standard. The novelty isn't in any single pattern — it's in the combination becoming mandatory rather than optional.

4. **Architecture itself becomes partially generated.** Agents will propose architectural decisions, generate ADRs, create fitness functions, and evolve system structure. Humans set constraints and review proposals. This is the meta-level of the dark factory thesis: not just generating code within an architecture, but generating the architecture itself under human policy supervision.

5. **The biggest winner is the humble test suite.** In a world where code generation is cheap and fast, the constraint that matters is verification. The team with the best test suite — the most comprehensive specification of "what correct looks like" — can regenerate any implementation at will. Tests become the actual source code; implementation becomes disposable. This inverts the traditional relationship between tests and code.

---

## How This Connects to Existing Research

- **Dark factory thesis** → confirmed and extended. The orchestration layer, verification layer, and memory layer are the three pillars. This document adds progressive discovery, cost-awareness, and adversarial interface design as equally structural concerns.
- **Design patterns by problem domain** → the problem domains remain; the pattern choices shift. Distributed coordination patterns (sagas, compensation, idempotency) move from "advanced" to "default." Business complexity patterns (DDD) gain value because agents need clear domain models to generate correct code.
- **Harness engineering** → the harness IS the architecture. Not a wrapper around the architecture; the verification harness, orchestration harness, and memory harness together constitute the system's real design.
- **MCP/CLI convergence** → reveals the progressive discovery principle. The specific protocol matters less than the lazy-loading pattern, which generalizes to all system interfaces.
- **Frameworks debate** → resolves toward "deep primitives + thin orchestration." Frameworks don't disappear, but the value shifts to the verification layer (fitness functions, contracts, specs) and the primitive layer (databases, protocols, crypto). The middle — application frameworks — gets compressed.
- **Training data commons** → the architecture must account for this. Systems that depend on community-maintained libraries and frameworks face a slow degradation of that commons. Self-contained verification (property-based testing, formal specs) becomes insurance against training data rot.

---

## What's Missing / Open Questions

1. **Empirical evidence is thin.** Most of the above is inference from convergent signals, not measured outcomes from production systems. Kiro and StrongDM are the closest to real evidence; everything else is early-stage or theoretical.
2. **The team coordination problem is unsolved.** Individual agent productivity is improving fast. Team-level coordination with agents is barely explored. The architecture patterns above address technical coordination but not organizational coordination.
3. **Security is handwaved everywhere.** Capability-based security and adversarial design are described at the pattern level. Actual implementations that work against determined attackers don't exist yet for agent systems. The [gondolin/matchlock research](gondolin-vs-matchlock.md) shows how hard this is.
4. **Cost models are moving targets.** Every architectural decision about token budgets and model routing assumes today's pricing. A 10x cost reduction (plausible within 18 months) changes which patterns are worth the complexity.
5. **The "agents generate architecture" prediction is untested.** If it works, it's transformative. If it doesn't — if architecture requires the kind of holistic judgment that LLMs can't reliably provide — then human architects become *more* important, not less.
