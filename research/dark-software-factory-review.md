← [Software Factory](../topics/software-factory.md) · [Index](../README.md)

# Dark Software Factory Review

*The previous analysis evaluated the wrong thing entirely.*

---

## The Frame Shift

The term "dark factory" comes from manufacturing: a factory that runs lights-off, with no humans on the floor. Robots build, inspect, package, and ship. Humans design the product, set policy, and intervene on exceptions.

The previous analysis reviewed OpenCode, Claude Code, and Kiro CLI as **developer productivity tools** — which one helps *you* write code faster? That frame is already obsolete. The question that matters is:

**Which of these tools — or what combination, or what thing that doesn't exist yet — can serve as a component in a software production system that runs autonomously, at scale, with humans only at the policy and exception layer?**

Anthropic's own 2026 Agentic Coding Trends Report documents this transition in real time. Developers already use AI in 60% of their work. Agents now complete 20 autonomous actions before needing human input — double six months ago. Rakuten's Claude Code ran for 7 hours autonomously on a 12.5M-line codebase with 99.9% accuracy. Yegge claims nearly a million lines of code in a year. Cursor says agents built a browser in a week. The trajectory is unmistakable.

The previous analysis compared paint brushes. The real question is about the paint factory.

---

## Re-evaluating Through the Dark Factory Lens

A dark software factory needs five capabilities. Let's see how each tool stacks up — not as a developer aid, but as factory infrastructure.

### 1. Orchestration: Can it decompose, delegate, and coordinate?

A dark factory doesn't run one agent on one task. It runs dozens or hundreds of agents across repos, with task decomposition, parallel execution, dependency management, and result synthesis.

**Kiro Autonomous Agent: The only one actually built for this.** It decomposes objectives into subtasks, assigns them to specialized sub-agents (research, implementation, verification), runs up to 10 concurrent tasks, maintains context across sessions and repositories, learns from code review feedback, and creates PRs autonomously. It integrates with GitHub issues (label `kiro` → agent starts working), Jira, Confluence, Slack. Each task runs in its own isolated sandbox. This is not a CLI — it's a headless production system with a chat interface bolted on.

**Claude Code Agent Teams: Moving in this direction, but experimental.** The research preview lets you create team leads and teammates working in parallel via tmux. It's "token-intensive" (Anthropic's own warning), aimed at "read-heavy tasks such as codebase reviews," and requires an experimental flag. This is a prototype of factory capability, not the real thing yet. But the underlying machinery (Agent SDK, hooks, subagent permissions, memory) is being assembled.

**OpenCode: Not designed for this at all.** It has subagents (a general-purpose one for multi-step tasks), and the client/server architecture theoretically supports remote orchestration. But there is no task queue, no persistent cross-session state, no autonomous background execution, no issue tracker integration, no PR creation pipeline. OpenCode is a superb *interactive* tool. It is not factory infrastructure. The oh-my-opencode fork adds some orchestration, but it's a community hack, not a product.

**Previous analysis verdict:** "The war is between the models, not the tools."
**Dark factory verdict:** Orchestration is everything. The model is a commodity input. The factory is the orchestration layer, the memory system, the task graph, and the governance framework. Kiro is the only one that understood this from the start.

### 2. Persistence and Memory: Can it maintain state across time?

A dark factory doesn't start fresh every session. It accumulates knowledge about the codebase, the team's preferences, the architectural decisions, the patterns that worked, the patterns that failed.

**Kiro Autonomous Agent:** Persistent cross-session context. Learns from code review feedback and applies those patterns to subsequent work. Maintains awareness across multiple repositories. This is the beginning of institutional memory — the factory remembering how to build *your* product.

**Claude Code:** Now automatically records and recalls memories as it works. CLAUDE.md and project-level config provide static context. The 1M token context window (beta) on Opus 4.6 means an agent can hold an enormous codebase in working memory for a single session. But the memory system is per-session, per-user. It doesn't accumulate the way Kiro's feedback learning does.

**OpenCode:** Session persistence via workspaces, SQLite database for conversation history. But no cross-session learning, no feedback loop, no institutional memory. Each session starts from AGENTS.md + repo state. This is adequate for interactive use but useless for a factory.

**Previous analysis:** Barely mentioned memory. Focused on context window size.
**Dark factory verdict:** Memory is the moat. The factory that learns from its own output — that remembers "last time I refactored this service, the team asked me to preserve the logging format" — will outperform the factory that treats every task as greenfield. This is where Kiro has a structural lead that is extremely hard to replicate.

### 3. Verification and Governance: Can it prove its work is correct?

A dark factory cannot ship code that requires human review of every line. It needs automated verification at scale: tests, security scans, architectural conformance checks, performance regression detection. The human role shifts to setting policy and reviewing exceptions.

**This is where the previous analysis's SDD/spec-validation section becomes newly relevant — and its dismissal was wrong.**

In the interactive-developer frame, SDD was overkill ("specs are a transitional artifact"). In the dark factory frame, SDD is *the control system*. You need machine-readable intent (what should this code do?) to verify machine-generated output (what does this code actually do?). The question isn't whether developers want to write specs. The question is whether the factory needs them. And it does.

The InfoQ analysis of SDD as executable architecture nails this: "Architecture transitions from a design-time assertion into a runtime invariant, actively maintained by the system itself." In a dark factory, specs aren't documents for humans to read — they're constraints for agents to satisfy and validators to enforce.

Kiro's spec-driven workflow, previously dismissed as "bureaucratic," is actually the governance layer a factory requires. Requirements → design → tasks → implementation → validation. The spec is the work order. The acceptance criteria are the quality gates. The steering files are the factory floor procedures.

The vericoding trajectory is more relevant than previously acknowledged. Dafny verification went from 68% → 96% in one year. The AlgoVeri benchmark shows frontier models developing self-correction as an "emergent capability." For a dark factory producing mission-critical code, formal verification of critical paths isn't academic — it's the difference between shipping and not shipping.

**Previous analysis:** Dismissed SDD, proposed a five-layer validation stack that nobody would implement.
**Dark factory verdict:** The five-layer stack IS what a dark factory implements — not as a developer discipline but as factory infrastructure. Linting is the deterministic layer. Tests are the property layer. SDD acceptance criteria are the scenario layer. CI/CD dashboards are the demonstration layer. Formal verification covers critical paths. The factory implements all five because the factory doesn't get tired of running them.

### 4. Sandboxing and Security: Can it fail safely?

A dark factory running dozens of agents concurrently must isolate failures. One agent crashing shouldn't corrupt another agent's work. A malicious input shouldn't propagate through the system. Every action must be auditable.

**Kiro Autonomous Agent:** Each task runs in its own isolated sandbox with configurable network access, environment variables, and development environment settings. Never merges automatically — creates PRs for review. This is the right architecture for a factory.

**Claude Code:** Has sandbox mode with per-command permissions, excluded commands, write prevention for sensitive directories. The hooks system can intercept tool invocations. But it's designed as a safety net for interactive use, not as factory-grade isolation.

**OpenCode:** More permissive by default. The agent configuration allows restricting tools per agent, but there's no sandboxing infrastructure comparable to Kiro's isolated environments.

**Previous analysis:** Didn't discuss security/sandboxing at all.
**Dark factory verdict:** This is a hard requirement, not a feature. The Trevolution/CIO piece describes the reality: "If MCP allows undesirable actions — deleting code, modifying the repository — you can be sure they will eventually happen." Yegge's own database went down for two days when an agent erased passwords. At factory scale, isolation and minimum-permission design is existential.

### 5. Economics: Can it run cost-effectively at scale?

A dark factory running 50-100 agent tasks per day across a codebase is a fundamentally different economic proposition than one developer using a CLI.

**Claude Code:** $100/month Max subscription gives generous usage for a single human. But factory-scale usage (multiple agents, parallel execution, long-running tasks) will blow through any subscription tier. API pricing at Opus 4.6 rates ($10/M input, $37.50/M output in 1M context mode) can make a single 7-hour task cost hundreds of dollars. The Anthropic report itself notes the need for "FinOps for agents" — treating agent cost as a first-class architectural concern.

**OpenCode:** Zero tool cost + BYOK. The factory can route cheap tasks to GLM-4.7 (free via Zen), medium tasks to Sonnet, and only hard tasks to Opus. The plan-and-execute pattern (expensive model plans, cheap model executes) can cut costs 90%. This economic flexibility is *the* killer feature for factory-scale operation.

**Kiro:** Tiered subscriptions (Pro, Pro+, Power) with the autonomous agent in preview (free during preview, pricing TBD). The "Auto" router already does heterogeneous model selection. But AWS pricing opacity is a real risk — when they announce production pricing for the autonomous agent, it could be anywhere.

**Previous analysis:** Mentioned economics briefly. Focused on individual developer subscription value.
**Dark factory verdict:** OpenCode's model-agnostic economics become the decisive advantage at factory scale. The ability to say "use the $0 model for test generation, the $2/M model for implementation, and the $15/M model only for architecture decisions" is how you run a factory profitably. Claude Code's model lock-in becomes a liability, not an advantage, when you're paying for 100x the compute.

---

## The Revised Ranking

### For a dark software factory, the ranking inverts.

**Previous analysis ranking (developer productivity):**
1. Claude Code (best output quality)
2. OpenCode (provider independence)
3. Kiro CLI (weakest standalone)

**Dark factory ranking (autonomous production infrastructure):**

1. **Kiro Autonomous Agent** — the only tool that is actually a factory. Persistent memory, multi-repo orchestration, sub-agent coordination, isolated sandboxes, spec-driven governance, GitHub/Jira integration, learns from feedback. The missing pieces are: unproven at scale, pricing unknown, AWS dependency risk, and the "Auto" router is a black box.

2. **OpenCode** — the factory's *cost optimizer and flexibility layer*. Model-agnostic economics make the plan-and-execute pattern viable. The client/server architecture supports remote/headless operation. ACP support means it can be embedded in any IDE or orchestration system. But it needs a factory wrapper — something like the Hugging Face implementation guide's "agent-platform" architecture — built around it.

3. **Claude Code** — the factory's *high-capability specialist*. When you need the absolute best reasoning for an architecture decision, a complex debugging session, or a security review, you route to Opus 4.6 via Claude Code. Agent Teams and the Agent SDK are the seeds of factory capability. But it's the most expensive option per compute unit and the most locked-in. In a dark factory, it's the specialist surgeon, not the assembly line.

---

## What Doesn't Exist Yet (And Needs To)

The honest answer is that none of these tools is a dark software factory. They are components that could be assembled into one. What's missing:

**The Control Plane.** A system that receives objectives (from a product backlog, a Jira board, a business metric), decomposes them into agent-executable tasks, routes tasks to the right agent+model combination based on complexity/cost/urgency, monitors execution, handles failures, and reports results. The Hugging Face implementation guide sketches this architecture but nobody ships it as a product. Kiro's autonomous agent is closest.

**The Verification Pipeline.** A factory-grade CI/CD system that doesn't just run tests but actively generates them, runs property-based testing, performs security scanning, checks architectural conformance, and uses AI reviewers to catch the things that automated tools miss. The Anthropic report calls this "Agentic Quality Control" — using AI agents to review AI-generated output. This is the factory's quality inspector.

**The Feedback Loop.** A system that tracks what the factory produces, how it performs in production, what bugs escape, what patterns succeed, and feeds all of this back into the factory's decision-making. This is where vericoding and formal verification become practical — not as a developer discipline but as a factory capability for critical paths.

**The Cost Controller.** FinOps for agents. A system that monitors per-task token consumption, routes to cheaper models when possible, kills runaway loops, and enforces budget constraints per objective. The implementation guide's `max_model_cost_usd: 25` constraint per job is exactly right.

---

## The One-Paragraph Summary

The previous analysis asked "which CLI helps me code faster?" — the wrong question for a world moving toward autonomous software production. In the dark factory frame, the ranking inverts: Kiro's autonomous agent (persistent memory, multi-repo orchestration, sandbox isolation, spec governance) is the closest thing to actual factory infrastructure; OpenCode's model-agnostic economics become the decisive advantage at 100x scale; and Claude Code becomes a high-cost specialist called in for hard problems. But the real insight is that the dark factory doesn't exist yet as a product — it's an architecture that needs to be assembled from these components plus a control plane, a verification pipeline, a feedback loop, and a cost controller. The organizations that build this assembly first will have a structural advantage that no amount of individual developer productivity can match. The Mike Mason synthesis captures the current reality perfectly: "quantity without quality supervision leads to technical debt accumulation" — the dark factory works only when the governance layer is as automated and relentless as the production layer. That is the hard problem, and it is mostly unsolved.
