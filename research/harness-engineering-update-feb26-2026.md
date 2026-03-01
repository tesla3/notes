← [Coding Agents](../topics/coding-agents.md) · [Software Factory](../topics/software-factory.md) · [Harness Engineering](harness-engineering-insights-and-practices.md) · [Index](../README.md)

# Agent Harness Engineering: New Research & Field Intelligence (Feb 26, 2026)

**Compiled:** February 26, 2026.
**Scope:** New findings, academic papers, practitioner reports, and anecdotes discovered since the [main harness engineering synthesis](harness-engineering-insights-and-practices.md) (Feb 25) and [critical review](harness-engineering-critical-review.md).

---

## I. Major New Evidence

### 1. METR Updates Their RCT — Selection Effects Now Dominate (Feb 24, 2026)

**Source:** [metr.org/blog/2026-02-24-uplift-update](https://metr.org/blog/2026-02-24-uplift-update/)

METR's original 2025 RCT found experienced devs 19% *slower* with AI. Their late-2025 follow-up attempted replication with 57 devs, 800+ tasks — but the study design broke:

- **Developers now refuse to work without AI.** Recruitment became significantly harder. Devs said: *"my head's going to explode if I try to do too much the old fashioned way because it's like trying to get across the city walking when all of a sudden I was more used to taking an Uber."*
- **Task selection bias:** 30-50% of developers admitted choosing not to submit tasks they didn't want to do without AI. The study systematically misses high-uplift tasks.
- **Concurrency breaks measurement:** Some devs run multiple agents simultaneously — how do you measure "time spent" when you're supervising 3 parallel sessions?

Raw results now show *speedup* (−18% time for returning devs, −4% for new devs), but METR explicitly says they can't trust these numbers due to selection effects. They're redesigning the study.

**Key insight for harness engineering:** The fact that developers now *refuse* to work without AI is itself a data point. The original 19% slowdown result may have been real for early-2025 tooling, but the landscape has shifted enough that the measurement apparatus itself is breaking. The harness matters here — agentic tools with feedback loops (Claude Code, Codex) appear to be the ones devs refuse to abandon.

### 2. METR Transcript Analysis — 1.5x to 13x Time Savings (Feb 17, 2026)

**Source:** [metr.org/notes/2026-02-17-exploratory-transcript-analysis](https://metr.org/notes/2026-02-17-exploratory-transcript-analysis-for-estimating-time-savings-from-coding-agents/)

METR tried a different measurement approach: analyze 5,305 Claude Code transcripts from 7 internal technical staff, use an LLM judge to estimate how long a human would have taken without AI.

- **Time savings factor: ~1.5x to ~13x** across individuals on Claude Code-assisted tasks.
- The highest time savings correlates with **agent concurrency** — the person averaging 2.3+ main agents simultaneously had 13x.
- **Critical caveat (METR's own):** This is a *soft upper bound*, not a productivity multiplier. Reasons:
  - **Task substitution:** ~27-47% of AI-assisted work wouldn't have been done otherwise ("Cadillac tasks" — nice-to-have but not essential).
  - **Task selection:** People only use AI on tasks where they expect it to help.
  - **The LLM judge overestimates:** In validation against 34 human estimates, the judge consistently predicted longer times than humans.

**Harness implication:** The concurrency finding is important. The highest-performing user wasn't just better at prompting — they built a workflow around *parallel agent supervision*. This is a harness design pattern: multi-session orchestration with structured handoffs.

### 3. Lulla et al. — AGENTS.md Makes Agents 29% Faster (Jan 2026)

**Source:** [arxiv 2601.20404](https://arxiv.org/abs/2601.20404) (Lulla et al., SMU/Heidelberg/Queensland)

This is a *different study* from the ETH Zurich evaluation already in our notes. Key distinction: Lulla et al. measured **efficiency** (runtime, tokens), not task completion success rate.

| Metric | Without AGENTS.md | With AGENTS.md | Improvement |
|--------|-------------------|----------------|-------------|
| Median Runtime | 98.57s | 70.34s | **−28.64%** |
| Mean Runtime | 162.94s | 129.91s | −20.27% |
| Median Output Tokens | 2,925 | 2,440 | **−16.58%** |

Study design: 10 repos, 124 PRs, GPT-5.2-Codex, paired with/without, Docker isolation. Wilcoxon signed-rank p < 0.05.

**Why it works:** Agents spend less time on *exploratory navigation*. AGENTS.md is passive context — always loaded, no decision required — reducing the planning iterations needed to understand project structure.

**Reconciliation with ETH Zurich:** These studies aren't contradictory. ETH Zurich found LLM-*generated* context files hurt success rate (−3%). Lulla et al. used developer-written files and measured efficiency. The synthesis: **well-written AGENTS.md files make agents faster and cheaper, but auto-generated ones make them dumber.** Quality of context matters more than presence of context.

### 4. "Codified Context" Paper — Three-Tier Architecture at Scale (Feb 23, 2026)

**Source:** [arxiv 2602.20478](https://arxiv.org/abs/2602.20478) (Vasiliades)

A chemistry researcher (not a software engineer) built a 108,000-line C# distributed system over 70 days using Claude Code, with a three-tier codified context infrastructure:

| Tier | Type | Size | Loading |
|------|------|------|---------|
| 1 | Constitution (hot memory) | ~660 lines | Always loaded |
| 2 | 19 specialist agents | ~9,300 lines | Invoked per task via trigger tables |
| 3 | 34 knowledge base docs (cold memory) | ~16,250 lines | On-demand via MCP retrieval |

**Key quantitative findings** from 283 sessions, 2,801 human prompts, 16,522 agent turns:
- Knowledge-to-code ratio: **24.2%** (~26K lines of context infrastructure for 108K lines of code)
- Meta-infrastructure overhead: **4.3%** of prompts went to building the context system itself
- Maintenance: ~1-2 hours/week (spec updates in-session + biweekly review pass)
- 87% ad-hoc sessions, 13% structured plan-execute-review sessions
- Most-referenced spec: save-system.md — used across 74 sessions over 4 weeks with zero save-related bugs

**Practitioner guidelines that emerged:**
- **G4: "If you explained it twice, write it down."** Repeated explanation across sessions signals a missing specification.
- **G5: "When in doubt, create an agent and restart."** Building a specialist with embedded domain knowledge often resolves problems faster than continuing an unguided session.
- **G6: "Stale specs mislead efforts."** Agents trust documentation absolutely; out-of-date specs cause *silent* failures caught only at testing.

**New concept — brevity bias** (from Zhang et al. 2026, cited in paper): Iterative prompt optimization tends to collapse toward short, generic prompts, losing domain-specific knowledge. The paper found that specialist agents needed substantial embedded domain knowledge (>50% of their specification content) to perform reliably. Short prompts weren't enough.

**Critical assessment:** Single-developer, single-project, no controlled experiment. The author is a domain expert, not an SWE — the architecture may overcompensate for gaps that experienced engineers wouldn't need. But the quantitative interaction data (283 sessions, MCP retrieval patterns) is genuinely novel — nobody else has published this level of detail on how context infrastructure gets *used* in practice.

### 5. Configuration Landscape Study — 2,926 Repos Analyzed (Feb 2026)

**Source:** [arxiv 2602.14690](https://arxiv.org/html/2602.14690v1) (Mohsenimofidi et al.)

First cross-tool empirical study of configuration mechanisms across 5 agentic coding tools and 2,926 GitHub repositories.

**Eight configuration mechanisms identified:** Context Files, Skills, Subagents, Commands, Rules, Settings, Hooks, MCP servers.

**Key findings:**
- **Context Files dominate.** They're the only mechanism present in most repos.
- **AGENTS.md is converging as the standard.** CLAUDE.md appears first (legacy), then AGENTS.md gets added. AGENTS.md receives 368 incoming references — far more than any other file. CLAUDE.md most frequently points to AGENTS.md (311 cases).
- **Claude Code users have the broadest configuration footprint.** Cursor users emphasize Rules.
- **Skills and Subagents are underused.** Median = 2 per repo. 83.3% of Skills have no additional resources (no scripts, no references). Skills function primarily as *structured text*, not executable workflows.
- **No repos use Subagent persistent memory.** Claude Code offers persistent memory directories for subagents — zero adoption found.
- **TypeScript dominates** agentic coding repos (31.5%), followed by Python (18.7%) and Go (18.2%).

**Implication:** The ecosystem is still at the "Context Files only" stage. Advanced configuration mechanisms exist but aren't adopted. This is a maturity signal — most teams haven't gone beyond writing a markdown file.

---

## II. New Paradigm: Code-as-Action (CodeAct)

**Sources:** Agile Lab synthesis, Cloudflare Code Mode, Smolagents, Monty (Pydantic)

A significant architectural shift emerging in harness design: **instead of JSON tool calls, have agents write executable code.**

| Evidence | Result |
|----------|--------|
| CodeAct paper (Wang et al.) | Up to 20% higher success rates across 17 models |
| Cloudflare Code Mode | 32% fewer tokens (simple tasks), **81% fewer tokens (complex tasks)** |
| Anthropic Programmatic Tool Calling | Same direction, announced Nov 2025, available Jan 2026 |

**Why it works (first principles):**
- LLMs are trained on vast code corpora but have sparse training on tool-calling JSON schemas.
- Code allows arbitrary control flow: loops, conditionals, retry logic, composition of multiple tools in a single action step.
- Traditional tool calling forces sequential ping-pong: one call → one result → back to model. Code composes multiple calls, and the model sees only the aggregated result.

**Samuel Colvin's Monty:** A minimal, secure Python interpreter written in Rust, designed to execute LLM-generated code safely. Targets the Python subset relevant to agent code. Sub-microsecond execution for simple operations. Self-correction loop: unsupported features return errors the model can use to rewrite.

**Harness implication:** This may be the next major harness improvement after the feedback loop gauntlet. If code-as-action reduces tokens by 30-80% while improving success rates, it's strictly better than JSON tool calling for most use cases. **Watch for this to become standard harness infrastructure by mid-2026.**

---

## III. New Academic Research

### Constitutional Spec-Driven Development (CSDD)

**Source:** [arxiv 2602.02584](https://arxiv.org/abs/2602.02584) (Marri)

Embeds non-negotiable security constraints into the specification layer. A "Constitution" is a versioned, machine-readable document encoding security constraints derived from CWE/MITRE Top 25 vulnerabilities.

- **73% reduction in security defects** vs. unconstrained AI generation
- Full traceability from constitutional principles to code locations
- Case study: banking microservices (customer management, accounts, transactions)

This extends our specification-sandwich insight: not just functional specs, but **security specs as first-class constitutional constraints**. The harness enforces them before code is even reviewed.

### Agentic Context Engineering (ACE) — Brevity Bias Discovery

**Source:** [arxiv 2510.04618](https://arxiv.org/abs/2510.04618) (Zhang et al.)

Treats contexts as "evolving playbooks" refined through generate-reflect-curate cycles. Discovered two failure modes:
- **Brevity bias:** Iterative optimization collapses prompts toward short, generic forms, dropping domain insights.
- **Context collapse:** Iterative rewriting erodes important details over time.

**Harness implication:** Self-improving context systems (like pi-reflect) need guards against brevity bias. The natural tendency of optimization is to *remove* information, but some of that information is load-bearing. The Codified Context paper's finding — that specialist agents need >50% domain knowledge content — is independent confirmation.

### "Speed at the Cost of Quality" — Cursor Study

**Source:** Referenced in Configuration Landscape study (He et al. 2026)

Title tells the story: Cursor AI increases short-term velocity but increases long-term complexity in open-source projects. Not yet analyzed in detail — flagged for follow-up.

---

## IV. Practitioner Intelligence & Anecdotes

### Brownfield Development — First Real Playbook

**Source:** [thegeneralpartnership.substack.com](https://thegeneralpartnership.substack.com/p/a-practical-guide-to-brownfield-ai)

First serious practitioner report on agent-assisted brownfield work (previously a complete evidence gap in our corpus):

- Django monolith refactoring: agent produced "clean, confident patches that quietly broke integrations with external services." Team shelved the experiment.
- The fix: **build structure incrementally**. Start with heavy oversight, increase agent autonomy as the system becomes more legible.
- **Tests as migration specification:** 120+ Playwright tests written by Claude against a vanilla JS application *before* React migration. Agent inspected HTML/JS, identified structural markers. Tests became the functional spec to migrate against.
- **Explicit compromise hierarchy for agents:** "Security = non-negotiable. Don't break existing functionality. Ugly patterns are fine temporarily."
- **Metric: "agent autonomy ratio"** — turns-to-human-prompts. Ranges from 60% to 95% across projects. Gap comes from how well you communicate intent and how much context the agent can access.
- React migration that would have taken a week by hand: **completed in a day** with the brownfield methodology.

**Key quote:** *"Legacy codebases carry tacit knowledge that agents can't reach on their own. Miss the right moment to inject it and you get a 4000-line change full of subtle bugs. The work is more like managing a fast-moving team than running a script."*

### The 100% Autonomy Wall

**Source:** [codemanship.wordpress.com](https://codemanship.wordpress.com/2026/02/18/100-autonomous-agentic-coding-is-a-fools-errand/) (Jason Gorman, Feb 18, 2026)

Gorman ran controlled experiments: set up Claude Code in read-only planning mode, then let it run with no human intervention, measuring progress with pre-baked acceptance tests.

**Result:** "No set-up has produced 100% autonomous completion, or anything close."

His key arguments:
- Out-of-distribution problems are an **unfixable property** of generative transformers. The model has no way to recognize when a problem falls outside its training distribution.
- A swarm of agents creates a *coordination* problem: "No matter how many lanes in your motorway, ultimately every change has to go through the same garden gate of integration."
- The attempt to fully automate quality gates requires *precisely and completely describing* what quality means — and software quality concepts (coupling, cohesion, "responsibility") are fundamentally woolly.
- **The successful practitioners** have stopped searching for full autonomy. They run "the firehose in short, controlled bursts and check the results thoroughly after every one."

**Harness implication:** This reinforces the "attended with tight feedback loops" position. Harness engineering isn't a path to removing humans — it's a path to making the human-agent collaboration maximally efficient. The asymptote is real.

### NVIDIA's Sandboxing Guidance

**Source:** [NVIDIA Developer Blog](https://developer.nvidia.com/blog/practical-security-guidance-for-sandboxing-agentic-workflows-and-managing-execution-risk/)

NVIDIA Red Team recommendations for agent sandboxing:
- **Require fresh manual approval for every action** that violates default-deny isolation. Allow-once / run-many is NOT adequate.
- **Secret injection:** Prevent secrets from being shared with the agent. Scope credentials to minimum required for each specific task.
- **Lifecycle management:** Prevent accumulation of code, IP, or secrets in sandbox environments over time.

**Practical trade-off reported:** Cursor's built-in sandboxing with these controls reduces interruptions by ~40%, which compounds across a workweek. Agents can complete build-test-lint cycles autonomously, escalating only when network or permission boundaries are hit.

### Agent Sprawl at Enterprise Scale

**Source:** [dev.to/htekdev](https://dev.to/htekdev/agent-harnesses-why-2026-isnt-about-more-agents-its-about-controlling-them-1f24)

- Average enterprise now deploys **12 AI agents**, projected to hit 20 by 2027.
- Only **27% are connected** to the rest of the stack (Salesforce 2026 Connectivity Benchmark).
- 73% are "shadow agents" — unmonitored, ungoverned, accumulating technical debt.
- CNCF's Four Pillars of Platform Control mapped to agent management: Golden Paths, Guardrails, Safety Nets, Manual Review.

**Analogy that works:** Microservices sprawl → service mesh. Agent sprawl → agent harness. The same organizational pattern is recurring.

---

## V. Synthesis: What's Genuinely New Since Our Last Analysis

### 1. The AGENTS.md Picture Is Now Clearer (Three Studies Converge)

| Study | Measured | Finding |
|-------|----------|---------|
| ETH Zurich (Gloaguen) | Task completion success | LLM-generated: −3%. Developer-written: +4%. Both cost more tokens. |
| Lulla et al. (SMU) | Runtime + token efficiency | Developer-written: −29% runtime, −17% tokens. |
| Configuration Landscape | Adoption patterns | AGENTS.md converging as cross-tool standard. Most repos stop here. |

**Synthesis:** Developer-written AGENTS.md files make agents both *faster* and *somewhat more accurate*. LLM-generated ones make agents slower and dumber. The value is in *efficiency* (reduced exploration) more than *accuracy* (better solutions). This means AGENTS.md is more valuable for **token-expensive** and **time-sensitive** workflows than for correctness-critical ones.

### 2. Tiered Context Architecture Is Emerging as a Pattern

Single-file AGENTS.md doesn't scale. Three independent approaches to the same problem:
- **OpenAI:** AGENTS.md as table of contents → points to design docs, architecture maps, quality grades
- **Google Conductor (Gemini CLI):** Persistent Markdown + structured spec-plan-implement workflow
- **Codified Context paper:** Hot constitution → specialist agents → cold knowledge base with MCP retrieval

All three independently discovered the need for a **loading strategy** — not all context is always-loaded. The hot/cold distinction is the architectural pattern.

### 3. Code-as-Action May Be the Next Major Harness Improvement

The token savings (32-81%) and accuracy improvements (up to 20%) from CodeAct/Code Mode are large enough to reshape harness design. If agents write Python instead of JSON tool calls, harnesses need sandboxed code execution instead of tool dispatch.

### 4. The Productivity Debate Has Moved Past "Does AI Help?"

METR's study is literally breaking because developers *won't work without AI*. The question isn't whether AI helps — it's *how much* and *for what tasks*. The measurement challenge has shifted from "is there an effect?" to "the effect is real but we can't isolate it cleanly." This is progress, even if the numbers remain uncertain.

### 5. Brownfield Is No Longer an Evidence Vacuum

We now have at least one serious practitioner report on brownfield agent-assisted development. The key insight: **structure enables autonomy**. Build tests first, document tacit knowledge, establish a compromise hierarchy, and increase agent autonomy incrementally as the codebase becomes more legible. This directly maps to the harness engineering playbook — the harness *is* the structure that enables agent autonomy.

### 6. Full Autonomy Is (Probably) an Asymptote

Multiple independent sources converge: Gorman's experiments, Manus's four rebuilds, the 100% wall. The ROI is in the 80-95% autonomy range with human oversight at decision points. Harness engineering should optimize for *efficient human-agent collaboration*, not for removing humans entirely.

---

## VI. Updated Hierarchy of Leverage

Incorporating new evidence, adjustments to the [original hierarchy](harness-engineering-insights-and-practices.md#vi-the-hierarchy-of-leverage):

| Rank | Practice | Change | New Evidence |
|------|----------|--------|-------------|
| 1 | Close the feedback loop | ⬆ Confirmed | METR transcript analysis: highest-performing user combines tight loops + concurrency |
| 2 | Enforce architecture mechanically | Stable | — |
| **NEW** | **Code-as-action (CodeAct/Code Mode)** | 🆕 | 20% accuracy + 32-81% token reduction. May leapfrog tool simplification. |
| 3 | Simplify tools | May be subsumed by Code-as-Action | If agents write code, the tool decision space shrinks naturally |
| 4 | Write specifications | ⬆ Strengthened | CSDD: 73% fewer security defects. Codified Context: specs as cross-session coordination. |
| 5 | Tiered context (not just AGENTS.md) | ⬆ Upgraded from "start empty" | Three independent architectures converge on hot/cold/specialist pattern |
| 6 | Force self-verification | Stable | — |
| 7 | Build observability | Stable | — |
| 8 | Detect doom loops | Stable | Gorman confirms: unfixable at the model level, harness must handle |
| **NEW** | **Brownfield methodology** | 🆕 | Tests-first, doc tacit knowledge, explicit compromise hierarchy, incremental autonomy |

---

## VII. Open Questions Updated

1. **Does Code-as-Action compose with the feedback gauntlet?** If agents write Python to call tools, do linter/test feedback loops need to change? Early signals say they compose well (Monty returns errors agents can self-correct from), but no integrated evidence yet.

2. **Does tiered context scale to teams?** The Codified Context paper is single-developer. The paper itself speculates it may help teams by keeping agents aware of recent cross-codebase changes. Untested.

3. **What's the right knowledge-to-code ratio?** The Codified Context paper found 24.2%. Is this stable? Does it differ by domain? Does it grow or shrink as the codebase matures?

4. **Can brevity bias be solved?** Self-improving context systems naturally collapse toward brevity. No known solution beyond manual curation and domain-expert-written specialists.

5. **When does harness engineering hit diminishing returns?** Manus rebuilt 4 times, each time removing complexity. At what point does adding more harness infrastructure become overhead rather than leverage?

---

## Sources

| Source | Type | Independence | Key Contribution |
|--------|------|-------------|-----------------|
| [METR Uplift Update (Feb 24)](https://metr.org/blog/2026-02-24-uplift-update/) | Primary | **High** | Study redesign; selection effects; raw speedup data |
| [METR Transcript Analysis (Feb 17)](https://metr.org/notes/2026-02-17-exploratory-transcript-analysis-for-estimating-time-savings-from-coding-agents/) | Primary | **High** | 1.5x-13x time savings; concurrency correlation |
| [Lulla et al., arxiv 2601.20404](https://arxiv.org/abs/2601.20404) | Academic | **High** | AGENTS.md: −29% runtime, −17% tokens |
| [Vasiliades, arxiv 2602.20478](https://arxiv.org/abs/2602.20478) | Academic | **High** | Codified Context: 3-tier architecture, 283 sessions, 108K LOC |
| [Mohsenimofidi et al., arxiv 2602.14690](https://arxiv.org/abs/2602.14690) | Academic | **High** | Configuration landscape: 2,926 repos, 8 mechanisms |
| [Marri, arxiv 2602.02584](https://arxiv.org/abs/2602.02584) | Academic | **High** | CSDD: 73% security defect reduction |
| [Zhang et al., arxiv 2510.04618](https://arxiv.org/abs/2510.04618) | Academic | **High** | ACE: brevity bias, context collapse |
| [Ingargiola, "Rise of the Agent Harness"](https://agilelab.substack.com/p/the-rise-of-the-agent-harness) | Independent analysis | **High** | CodeAct synthesis, harness taxonomy, Claude Code history |
| [Gorman, "100% Autonomy Is A Fool's Errand"](https://codemanship.wordpress.com/2026/02/18/100-autonomous-agentic-coding-is-a-fools-errand/) | Independent analysis | **High** | Autonomy wall experiments, doom loop permanence |
| [General Partnership, Brownfield Guide](https://thegeneralpartnership.substack.com/p/a-practical-guide-to-brownfield-ai) | Practitioner | **High** | First serious brownfield playbook |
| [NVIDIA Sandboxing Guidance](https://developer.nvidia.com/blog/practical-security-guidance-for-sandboxing-agentic-workflows-and-managing-execution-risk/) | Vendor/research | Moderate | Enterprise sandbox controls |
| [htekdev, Agent Harness Library](https://dev.to/htekdev/agent-harnesses-why-2026-isnt-about-more-agents-its-about-controlling-them-1f24) | Practitioner | **High** | Enterprise sprawl data, CNCF four pillars mapping |
| [Pappas, "Agent Harness Is the Architecture"](https://dev.to/epappas/the-agent-harness-is-the-architecture-and-your-model-is-not-the-bottleneck-3bjd) | Independent analysis | **High** | Updated convergence analysis |
| [Context Studios, AGENTS.md Guide](https://www.contextstudios.ai/blog/agentsmd-the-research-backed-guide-to-making-ai-agents-29-faster) | Practitioner | Moderate | Practical AGENTS.md structure recommendations |
| [Augment Code, SDD Guide](https://www.augmentcode.com/guides/what-is-spec-driven-development) | Vendor | ⚠️ Sells tool | SDD patterns taxonomy, enterprise adoption framing |
| [XB Software, SDD Practitioner](https://xbsoftware.com/blog/spec-driven-development-ai-assisted-software-engineering) | Practitioner | **High** | Real-world SDD workflow with BMAD/Spec Kit |
