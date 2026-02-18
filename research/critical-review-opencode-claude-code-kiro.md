← [Coding Agents](../topics/coding-agents.md) · [Index](../README.md)

# Critical Review: OpenCode vs Claude Code vs Kiro CLI Analysis

*February 14, 2026 — A sharp second look*

---

## What I'm Reviewing

The previous session produced two major deliverables:

1. **A three-way tool comparison** (OpenCode vs Claude Code vs Kiro CLI) concluding that "the war is between the models, not the tools," with Claude Code recommended as primary, OpenCode as a sidecar, and Kiro CLI dismissed as weakest standalone.

2. **A spec-validation/SDD analysis** arguing that specs are a "transitional artifact" that will dissolve into a five-layer validation stack (deterministic guards → PBT → scenario holdouts → demonstration artifacts → formal verification).

This review stress-tests each major claim against the latest evidence (February 2026) and identifies what was right, what was wrong, and what was missing entirely.

---

## Part 1: The Tool Comparison — Claim by Claim

### Claim 1: "The war is between the models, not the tools"

**Verdict: Still directionally correct, but becoming less true faster than predicted.**

The original analysis argued the tools are thin orchestration layers and the model is what matters. Multiple independent sources confirm this at the base level — Andrea Grandi's head-to-head test showed OpenCode with Sonnet 4 produced "almost the same code" as Claude Code. Daniel Miessler's investigation concluded that "Claude Code's secret sauce isn't so secret after all."

**But the analysis underweighted three developments that are pulling tools apart:**

- **Agent Teams / Multi-Agent Orchestration**: Claude Code shipped experimental Agent Teams (Feb 2026) — team leads, teammates, shared task lists. This is not a thin wrapper feature; it's architectural. OpenCode has subagents but nothing at this orchestration level. Kiro has full autonomous agent with persistent cross-session learning. These are *tool-level* innovations that cannot be replicated by swapping the model.

- **Memory and Persistent Context**: Claude Code now automatically records and recalls memories as it works. Kiro's autonomous agent maintains context across repositories and sessions, learning from code review feedback. OpenCode has session persistence via workspaces but no cross-session learning. These create genuine lock-in and differentiation that is independent of model quality.

- **Ecosystem Integration Depth**: Kiro's GitHub integration (label an issue with `kiro`, agent picks it up), Jira/Confluence/Slack connections, and the autonomous agent creating PRs asynchronously — this is not something a "thin wrapper" does. Claude Code's VSCode remote sessions and session browsing from claude.ai are similarly sticky.

**The corrected framing**: The model still determines the ceiling of what any single turn can accomplish. But the *floor* — how reliably the agent maintains context, recovers from errors, coordinates across sessions and repos — is increasingly determined by tool architecture. The tools are differentiating upward, not converging.

---

### Claim 2: "Claude Code wins on output quality due to system prompt tuning"

**Verdict: Partially correct, but the gap is real and wider than acknowledged.**

The analysis attributed Claude Code's quality edge to system prompt optimization, implying it was a thin, copyable advantage. Fresh evidence says otherwise:

- Claude Opus 4.5 achieved **95% accuracy on CORE Bench Hard** when paired with Claude Code. Opus 4.6 now leads Terminal-Bench 2.0 for agentic coding. These are not just model benchmarks — they measure the model-tool co-optimization.

- The Infralovers comparison (Jan 2026) confirms that "extended reasoning tasks favor Claude" and that multi-turn performance degrades more with OpenCode than Claude Code after long conversations.

- The reformatting bug in OpenCode is *still present* (Feb 2026 releases are still fixing related issues). All three models Grandi tested with OpenCode reformatted existing code. This is a tool-level deficiency, not a model issue, and it matters in production.

- Claude Code's system prompts were recently improved to "more clearly guide the model toward using dedicated tools (Read, Edit, Glob, Grep) instead of bash equivalents" — a specific orchestration refinement that reduces incidental damage.

**The corrected framing**: The quality gap isn't just system prompt text. It's the full co-evolution: the model was *trained* with Claude Code's tool definitions in mind. Anthropic has a feedback loop between model training and tool behavior that no third party can replicate. This is a structural advantage, not a prompt engineering trick.

---

### Claim 3: "OpenCode wins on long-term investment due to provider independence"

**Verdict: The strongest claim, and it has gotten stronger — but with a new caveat.**

OpenCode's momentum is undeniable: 90k+ GitHub stars, 534+ contributors, desktop app, VSCode extension, ACP support for JetBrains/Zed/Neovim/Emacs, GitHub Actions integration (`/opencode` in issue comments). The ecosystem is maturing fast.

The provider independence thesis is being validated in real time. OpenCode Zen (curated model gateway) now benchmarks specific provider/model combinations and exposes only verified configurations. Free models like GLM-4.7 are genuinely competitive for routine tasks. The ability to test GPT-5.1 Codex, Gemini, or local models with zero switching cost is a real asset.

**The new caveat** the previous analysis underweighted: **Anthropic's OAuth scope restriction** for third-party clients. The analysis mentioned this but didn't emphasize it enough. The Infralovers post (Jan 2026) describes an ongoing "cat and mouse game" where OpenCode's access to Claude Pro/Max subscriptions works intermittently. This is not a technical bug — it's a deliberate policy that could tighten at any time. For anyone planning to use OpenCode *primarily with Claude models*, this is a significant risk that undermines the provider independence argument.

**The corrected framing**: OpenCode's value proposition is strongest when you genuinely use it with non-Claude models or API keys. If your workflow is "OpenCode as a free Claude Code alternative using your Max subscription" — that's a fragile foundation.

---

### Claim 4: "Kiro CLI is weakest as standalone CLI"

**Verdict: This was true when written but is now materially outdated.**

Since the analysis was written, Kiro has shipped:

- **ACP support** (Feb 4, 2026) — Kiro CLI now works as a custom agent in JetBrains, Zed, Neovim, Emacs. This directly addresses the "only useful within Kiro ecosystem" critique.

- **Custom subagents with parallel execution** — configurable trusted agents, autonomous execution, live progress tracking. This is architecturally more advanced than OpenCode's subagent implementation.

- **Autonomous agent in preview** for individual developers — persistent cross-session context, multi-repo coordination, learns from code review feedback, up to 10 concurrent tasks. This is genuinely differentiated; neither Claude Code nor OpenCode has anything comparable in production.

- **Model selection with Opus 4.6, Opus 4.5, Sonnet 4.5** — Kiro now offers the same model quality as Claude Code for CLI users.

- **Kiro "Powers"** — specialized packages that enhance agents with prebuilt expertise (curated MCP servers, steering files, hooks loaded on demand).

**The corrected framing**: Kiro CLI was a rebranded Q Developer CLI with a subscription attached. It's now a legitimate multi-agent orchestration platform with unique capabilities (particularly the autonomous agent) that neither competitor offers. The dismissal was premature.

---

### Claim 5: "Don't get religious — the ranking could change in 6 months"

**Verdict: Ironically, this was the most correct claim, and it already changed in 2 weeks.**

The advice to not invest heavily in any single tool's idioms was prescient. All three tools have shipped major features in the ~2 weeks since the analysis. The relative ranking has already shifted: Kiro went from "weakest" to "most architecturally ambitious," Claude Code added Agent Teams and automatic memory, and OpenCode added desktop app and ACP support.

---

## Part 2: The Spec/SDD Analysis — Claim by Claim

### Claim: "Specs are a transitional artifact"

**Verdict: The thesis holds, but the tone was too dismissive — SDD is more useful than suggested for specific workflows.**

The Marmelab critique ("SDD: The Waterfall Strikes Back") validates the concern about markdown bloat. The Böckeler/Fowler analysis confirms that SDD feels like overkill for typical features. The arxiv paper (Piskala, Jan 2026) acknowledges three tiers (spec-first, spec-anchored, spec-as-source) with different applicability.

**But the analysis missed the nuance in the Thoughtworks and InfoQ pieces:** SDD is genuinely valuable when (a) multiple developers/agents will work on the same feature, (b) the codebase is large and context is expensive to reconstruct, and (c) you're working with a team that mixes AI-assisted and manual development. The Zencoder guide makes a fair case that in brownfield environments with compliance requirements, the upfront cost of specification pays for itself.

The five-layer validation architecture was intellectually interesting but impractical as stated. Nobody is going to implement all five layers for a typical feature. The more honest recommendation: use plan mode (which all three tools have) for complex work, use tests as validation, and only invest in formal specs when the cost of bugs exceeds the cost of specification.

### Claim: "Vericoding is at 82% in Dafny"

**Verdict: The number was correct but understated progress — it's now 96% for pure Dafny verification (per Tegmark's updated benchmark, POPL 2026).** 

However, the analysis overstated its near-term relevance. The AlgoVeri benchmark (Feb 2026) shows that frontier models still struggle with complex algorithms requiring global property reasoning (e.g., Red-Black Tree insertion). Vericoding works for algorithmic primitives, not for real-world software with messy dependencies. Its timeline to practical relevance for working developers is years, not months.

### Claim: "Anthropic PBT agent found real bugs without specs"

**Verdict: Correctly cited, but this hasn't materialized as a practical tool anyone can use.** The analysis treated it as evidence that specs are unnecessary, but it's really evidence that research-grade property inference works in controlled settings. It doesn't help a developer today.

---

## Part 3: What the Analysis Missed Entirely

### 1. The Cost Structure Revolution

The analysis barely mentioned that Claude Code now bundles with Max subscription at rates dramatically cheaper than API pricing for heavy users. Meanwhile, OpenCode's Zen gateway offers free models. The economics have diverged sharply: Claude Code is optimized for subscription users; OpenCode is optimized for API/BYOK users. This is the primary selection criterion for many developers, and it was underweighted.

### 2. The IDE vs CLI Convergence

All three tools are rapidly becoming IDE-agnostic through ACP. Kiro CLI works in JetBrains. OpenCode works in VSCode/Cursor/Zed/Neovim. Claude Code has VSCode extension with remote session support. The "terminal-native" framing of the comparison is becoming less relevant — the question is shifting from "which CLI" to "which agent backend."

### 3. The Autonomous Agent as Category Shift

Kiro's autonomous agent is not an incremental improvement — it's a different category of tool. Assigning a GitHub issue with a label and having an agent create a tested PR asynchronously, while maintaining cross-session memory, is fundamentally different from interactive CLI coding. Claude Code's Agent Teams is moving in this direction but is experimental and "token-intensive." The analysis compared these tools as if they were all doing the same thing. They're diverging.

### 4. The Security/Sandbox Dimension

Claude Code has invested heavily in sandboxing (sandbox mode, excluded commands, write prevention for .claude/skills). OpenCode is more permissive by default. Kiro's autonomous agent runs in isolated sandbox environments with configurable network access. For anyone working in a regulated environment or with sensitive codebases, this matters and was not discussed.

---

## Revised Recommendations

For an experienced ML/DL Python developer in February 2026:

### Primary Tool: Claude Code (unchanged, but for different reasons)

The recommendation stands, but the reasoning has shifted. It's not just about system prompt quality — it's about:
- **Opus 4.6 co-optimization** with 1M token context window (beta) and top Terminal-Bench scores
- **Automatic memory** reducing context reconstruction overhead for ongoing projects  
- **Agent Teams** (experimental) for parallelizing work across ML pipeline components
- **Fast mode** for routine tasks, full reasoning for architecture decisions

### Secondary Tool: OpenCode (upgraded from "sidecar" to "strategic parallel")

OpenCode's maturation makes it worth investing in more seriously than previously suggested:
- Use it as your **experimentation platform** — test if Gemini 2.5 Pro, GLM-4.7, or local models can handle your specific ML tasks at lower cost
- Use the **desktop app** for remote/mobile monitoring of long-running agent sessions
- Use **ACP integration** if your team uses JetBrains (PyCharm for ML work)
- Keep it ready as **insurance** against Anthropic pricing/throttling changes

### Watch Closely: Kiro Autonomous Agent (upgraded from "dismiss" to "evaluate actively")

The autonomous agent is genuinely novel for ML workflows:
- **Multi-repo dependency updates** — keeping ML pipeline deps, serving infra, and monitoring in sync
- **Asynchronous experimentation** — assign "try hyperparameter sweep X and PR the results" and go do other work
- **Code review learning** — the agent interns on your style, which matters for consistent ML codebases
- **Caveat**: Still in preview, weekly usage limits, pricing TBD. Don't build your workflow around it yet.

### Drop from consideration: Spec-Driven Development (as a formal methodology)

SDD remains overkill for ML/DL work specifically. Research code is exploratory by nature. The overhead of formal specs would destroy your iteration speed. Instead:
- Use **plan mode** (available in all three tools) before complex refactors
- Invest in **property-based testing** (Hypothesis for Python) for data pipeline invariants
- Use **AGENTS.md / CLAUDE.md** for project-level context — this gives you 80% of SDD's value at 5% of the cost

---

## The One-Sentence Summary

The previous analysis was right about the big picture (model matters most, tools are converging, don't get religious) but wrong about the trajectory — the tools are *diverging* into different categories (interactive CLI, multi-agent orchestration, autonomous background work), and the winning move is not to pick one but to use the right category for the right task.
