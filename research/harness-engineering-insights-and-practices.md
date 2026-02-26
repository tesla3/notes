← [Coding Agents](../topics/coding-agents.md) · [Software Factory](../topics/software-factory.md) · [Index](../README.md)

# Harness Engineering: Insights and Operational Best Practices

**Compiled:** February 25, 2026. **Reviewed:** February 25, 2026 (self-review against latest evidence).
**Sources:** 30+ primary sources cross-referenced against internal research corpus (insight inventory, verification analysis, critical review v3, maximum-leverage brainstorm). New sources include LangChain Terminal Bench experiments, ETH Zurich AGENTS.md evaluation, Pappas convergence analysis (APEX-Agents, Vercel, Manus), Demmel's feedback loop hierarchy, Böckeler's independent analysis, can1357's hashline benchmark, pi-reflect behavioral loop, JUXT Allium spec-first case study, O'Reilly multi-agent memory analysis (Cemri et al. MAST taxonomy), HN thread on AGENTS.md evaluation (47034087), and practitioner reports from New Stack, Arize, EQ Engineered, r/ExperiencedDevs.

---

## What This Document Is

An opinionated synthesis of harness engineering insights and operational best practices, grounded in evidence. Not a summary of what people *claim* works — a first-principles analysis of *why* certain practices work, validated against the best available data, with honest assessments of what remains unproven.

The audience is an experienced developer who wants to build effective agent harnesses without drinking the Kool-Aid.

---

## I. The Core Insight: Why Harness > Model

**The harness is the actual product. The model is a replaceable component.**

This is no longer just a thesis — it's now empirically demonstrated across independent experiments:

| Evidence | What Changed | Result |
|----------|-------------|--------|
| LangChain deepagents-cli | Harness only (model fixed at GPT-5.2-Codex) | 52.8% → 66.5% on Terminal Bench 2.0 (+13.7 points) |
| can1357 / oh-my-pi hashline | Edit tool only (15 models tested) | +8% avg success rate, Grok Code Fast 6.7% → 68.3% (10×) |
| Vercel d0 agent | Removed 80% of tools (15 → 2) | 80% → 100% accuracy, 3.5× faster, 37% fewer tokens |

The LangChain result is the most rigorous: same model, same benchmark, same tasks. The only variables were system prompt, tool design, and middleware hooks. A +13.7 point improvement from harness changes alone exceeds what most model upgrades deliver.

The can1357 result is the most visceral: a single tool change (the edit interface) improved *15 different models simultaneously*. The weakest models gained the most because their coding ability was completely hidden behind mechanical edit failures. As can1357 puts it: "You're blaming the pilot for the landing gear."

The Vercel result is the most counterintuitive: *removing* capabilities improved performance. Fewer tools = smaller decision space = less misrouting = fewer tokens wasted choosing. **⚠️ Critical caveat:** Vercel's benchmark was 5 queries. The direction is striking, but n=5 is anecdotal, not statistical evidence. The 80%→100% framing (4/5→5/5) sounds dramatic but is one additional correct answer. Treat as a suggestive signal, not proof. The mechanism (fewer tools reduces decision space) is sound and independently confirmed by Manus's iterative simplification and the broader Bitter Lesson pattern, but the specific Vercel numbers shouldn't be cited as rigorous evidence.

**First-principles explanation:** Agent failure modes are predominantly orchestration failures, not reasoning failures. The APEX-Agents benchmark (Mercor, Jan 2026) tested frontier models on real professional tasks — banking, consulting, law. Best pass@1: 24%. The models had the knowledge; they got lost, looped, forgot objectives. These are harness problems: context management, error recovery, state persistence. Above a model capability floor, improving the harness yields better marginal returns than swapping the model.

**The qualification:** Below the capability floor, no harness compensates. You can't harness-engineer GPT-3.5 into solving complex multi-step tasks. The harness amplifies capability; it doesn't create it.

**The temporal counter-argument (taken seriously):** A strict reading of Sutton's Bitter Lesson predicts that harness engineering will be obsoleted by sufficiently capable models. Manus rebuilt their harness four times as models evolved — each rebuild *removed* complexity. This is evidence that model improvements erode harness value. Pappas's honest assessment: "My position is that multi-step execution tasks have irreducible coordination requirements — context management, state persistence, error recovery — that are not reasoning problems for the model to solve but infrastructure problems for the system to handle." But this distinction may not hold. If a model can learn to checkpoint its own state, manage its own context, and recover from its own errors, the harness becomes overhead. The practical implication: **build for deletion. Every piece of harness logic should have an expiration date.** If the next model handles something without your scaffolding, delete the scaffolding. The practices that survive model improvement are the ones that would be good engineering regardless of AI (linting, testing, architecture enforcement, observability). The model-specific guardrails (doom loop detection, forced verification, reasoning budget management) should be explicitly flagged as temporal.

---

## II. The Three Layers of Harness Engineering

Demmel's hierarchy (confirmed by convergent independent evidence) provides the right mental model:

1. **Prompt engineering** — how you phrase requests. Diminishing returns as models improve.
2. **Context engineering** — what the model knows: AGENTS.md, documentation, file selection.
3. **Feedback loop engineering** — infrastructure that lets agents verify their own work.

Each layer is a 10× multiplier on the one below it. Most people stop at layer 1 or 2. Layer 3 is where the real leverage lives.

### Why Layer 3 Dominates

LangChain's trace analysis revealed the most common failure pattern: "the agent wrote a solution, re-read its own code, confirmed it looks ok, and stopped." Models are biased toward their first plausible solution. Without external verification signals, they declare victory prematurely.

The fix isn't prompting ("please check your work"). It's infrastructure: linters that reject violations immediately, test suites that report failures, type checkers that catch shape errors, browser automation that verifies UI renders. The agent needs *evidence*, not encouragement.

This maps directly to insight #9 from the corpus (agents game their own tests): re-reading code is self-verification without external signal. The harness must provide the external signal.

---

## III. Operational Best Practices — What Actually Works

Organized by implementation cost (cheapest first) and evidence strength.

### A. The Feedback Gauntlet (High Evidence, Low Cost)

**Principle:** Force every code change through a deterministic verification pipeline before the agent proceeds.

Stripe's Minions implementation is the gold standard: git operations → linting/formatting → type checking → testing. Each stage provides structured error output the agent can consume and correct. This is a closed-loop control system where the development environment provides the error signal.

**Operational implementation:**

```
# In AGENTS.md or equivalent:
After modifying any source file:
1. Run `ruff check --output-format=json src/` — fix all errors before proceeding
2. Run `pyright --outputjson src/` — zero type errors required  
3. Run `pytest tests/ -x --tb=short` — all tests must pass
4. Do NOT skip steps or proceed with failures
```

For tighter integration (Claude Code hooks, Pi hooks, or equivalent):
```json
{
  "PostToolUse": [{
    "matcher": {"tool_name": "write_file", "file_pattern": "src/**/*.py"},
    "command": "ruff check $FILE && pyright $FILE"
  }]
}
```

The inline-with-every-write pattern is significantly tighter than end-of-task verification. The agent sees errors immediately, within the same context window, before the poisoned context compounds.

**Key insight from OpenAI:** Custom linter error messages that double as remediation instructions. When the agent violates a constraint, the error message tells it *how to fix it*. The tooling teaches the agent while it works. This is the single best concrete tip in the entire harness engineering literature — immediately implementable, zero ongoing cost.

### B. AGENTS.md: Less Is More (High Evidence, Counterintuitive)

The ETH Zurich study (Gloaguen et al., Feb 2026, arXiv:2602.11988) is the first rigorous empirical evaluation of AGENTS.md files. The findings are devastating for conventional wisdom:

- **LLM-generated context files reduced success rates by ~3%** and increased cost by 20%+
- **Developer-written files improved success by ~4%** but still increased cost by up to 19%
- Stronger models don't produce better context files
- When documentation was removed from repos, LLM-generated files *became* helpful — they were caching redundant information

**The operational principle:** AGENTS.md should contain *only* two types of information:

1. **Ambiguity resolution** — decisions that can't be inferred from code. "Use SerializerV2 for new features. V1 is deprecated." "Run `make generate` after modifying `schemas/`."
2. **Expensive inference caching** — facts that cost many tokens to discover. Canonical patterns, migration boundaries, build entry points, authoritative examples.

Everything else is overhead. The agent can read your README, test config, and existing docs on its own.

**⚠️ ETH Zurich study limitations (important nuance):** The study tested on SWE-bench tasks — focused, well-defined bug fixes in popular, well-documented repos. HN practitioners pushed back forcefully: "In large projects, having a specific AGENTS.md makes the difference between the agent spending half of its context window searching for the right commands, navigating the repo, understanding what is what, etc." (47046571). The study's own finding — that removing documentation made context files helpful — implies the value of AGENTS.md is inversely proportional to how well-documented the repo already is. Most real-world repos are *not* as well-documented as popular open-source projects. The 4% improvement from developer-written files may be much larger in messy, enterprise codebases. The study measured SWE-bench task completion; it didn't measure token efficiency across sessions, developer time saved from reduced exploration, or the value of preventing known recurring mistakes. The "start empty, build from friction" recommendation holds, but the ETH Zurich numbers should not be over-generalized to all repository contexts.

**OpenAI's progressive disclosure model is the right architecture:**
- AGENTS.md ≈ 100 lines, a table of contents
- Points to structured `docs/` directory with design docs, architecture maps, execution plans
- Background agent scans for stale docs, opens fix-up PRs

Böckeler's independent analysis confirms: "Give Codex a map, not a 1,000-page instruction manual." A monolithic instruction file crowds out actual task context, causes agents to pattern-match locally, rots instantly, and is hard to verify mechanically.

**Start empty, build incrementally.** Let the agent work without a context file first. Watch where it stumbles. Add rules *only* for recurring friction. This is Hashimoto's principle operationalized: "Anytime you find an agent makes a mistake, you take the time to engineer a solution such that the agent never makes that mistake again."

### C. Self-Verification Loops (High Evidence, Medium Cost)

LangChain's biggest improvement came from forcing agents into a build-verify cycle:

1. **Planning & Discovery** — read task, scan codebase, build plan including how to verify
2. **Build** — implement with verification in mind, build tests if they don't exist
3. **Verify** — run tests, read full output, compare against *original spec* (not own code)
4. **Fix** — analyze errors, revisit original spec, fix

The critical detail: a `PreCompletionChecklistMiddleware` intercepts the agent *before it exits* and forces a verification pass against the task spec. This is the "Ralph Wiggum Loop" pattern — a hook that forces the agent to continue executing on attempted exit, specifically for verification.

**Why this works (first principles):** Models are pattern completers. Their natural tendency is to generate → confirm → stop. They need *external pressure* to enter the test → fail → iterate loop. Without it, they satisfice on the first plausible solution.

**Operational implementation:**
```
# In system prompt or AGENTS.md:
Before declaring any task complete:
1. Re-read the original task description
2. Run ALL tests, not just the ones you wrote
3. Compare output against task requirements point by point
4. If any requirement is unmet, fix and re-verify
5. Never mark a task complete based on reading your own code
```

### D. Doom Loop Detection (Medium Evidence, Low Cost)

Agents can be myopic once committed to an approach, making small variations to the same broken strategy 10+ times in sequence.

LangChain's `LoopDetectionMiddleware` tracks per-file edit counts. After N edits to the same file, it injects: "You've edited this file N times. Consider reconsidering your approach."

**Operational implementation:**
- Track edit counts per file per session
- After 3-5 edits to the same file without passing tests: inject "step back and reconsider"
- After 8-10: force the agent to explain its current approach and compare to alternatives
- After 15+: escalate to human or abort

**Caveat:** This is a heuristic for current model limitations. As models improve, the threshold should increase. Build for deletion — if the next model doesn't doom-loop, remove the guardrail.

### E. Architectural Constraints as Mechanical Enforcement (High Evidence, High Cost)

OpenAI's layered architecture: Types → Config → Repo → Service → Runtime → UI. Dependencies validated directionally. Cross-cutting concerns through a single interface (Providers). All enforced via custom linters and structural tests, not documentation.

**Why mechanical enforcement > documentation:** Documentation is advisory. An agent that's deep in implementation and running low on context will skip or misremember a rule from AGENTS.md. A linter that rejects the code *cannot be skipped*. The constraint exists in the verification loop, not in the instruction buffer.

**The deeper insight (from your corpus, Broken Abstraction Contract):** LLMs violate all four properties of abstraction (deterministic, documented, stable, testable). Mechanical constraints *create the contract the LLM itself can't provide*. The harness IS the abstraction layer; the LLM is an implementation detail.

**Operational implementation for a new project:**
```python
# tests/test_architecture.py
import ast, pathlib

LAYER_ORDER = ["types", "config", "repo", "service", "runtime", "ui"]

def test_no_backward_imports():
    """Enforce layered architecture: no backward dependency."""
    for i, layer in enumerate(LAYER_ORDER):
        layer_dir = pathlib.Path(f"src/{layer}")
        if not layer_dir.exists():
            continue
        for py_file in layer_dir.rglob("*.py"):
            tree = ast.parse(py_file.read_text())
            for node in ast.walk(tree):
                if isinstance(node, (ast.Import, ast.ImportFrom)):
                    module = getattr(node, 'module', '') or ''
                    for forbidden in LAYER_ORDER[i+1:]:
                        assert f"src.{forbidden}" not in module, \
                            f"{py_file}: {layer} cannot import from {forbidden}"
```

This is cheap to write, runs in CI, and catches every violation across every agent session. The agent never sees the constraint as prose; it sees it as a failed test.

### F. Garbage Collection / Entropy Prevention (Medium Evidence, High Cost)

OpenAI's early approach: spending every Friday (20% of the week) manually cleaning "AI slop." This collapsed.

Their solution: encode "golden principles" as mechanical rules. Run recurring background tasks that scan for deviations, update quality grades, and open targeted refactoring PRs. Most reviewable in under a minute, auto-merged.

**Why this matters (first principles):** Agent-generated code replicates whatever patterns exist, including inconsistent ones. Without active drift correction, entropy accumulates faster than with human-written code because the agent doesn't have the theory behind the patterns it's copying. This connects to Naur's Nightmare: the code isn't an expression of understanding, so each replication dilutes coherence.

**Operational implementation:**
- Define "golden examples" — one reference implementation per pattern
- Write structural tests that verify new code follows the golden patterns
- Schedule weekly automated scans (an agent task) that flag deviations
- Track a quality grade per module (A/B/C/D, with specific criteria)
- Make quality grade visible to coding agents so they know which modules to trust as examples

### G. Environment Observability (Medium Evidence, High Cost)

Beyond tests and linters, agents benefit from the same observability humans use:

- **Browser DevTools via CLI** — DOM snapshots, screenshots, navigation, console errors
- **Log access** — tailing logs, crash tracebacks, runtime errors  
- **Database queries** — verify migrations, data shape, query optimization
- **OpenTelemetry traces** — follow requests across services
- **Metrics queries** — LogQL/PromQL for performance validation

OpenAI made their app bootable per git worktree with a local ephemeral observability stack. Prompts like "startup under 800ms" became testable acceptance criteria, not vibes.

**The operational principle:** If the agent can't measure it, it can't improve it. If it can't reproduce it, it can't fix it. Every tool you'd use to debug a production issue should be available to the agent as a CLI.

### H. Reasoning Budget Management (Emerging Evidence, Low Cost)

LangChain discovered a "reasoning sandwich" — high reasoning for planning, lower for implementation, high again for verification. Running at maximum reasoning throughout caused timeouts (scored 53.9% vs 63.6% at balanced reasoning).

**Operational principle:** Not every sub-task needs maximum compute. Planning and verification benefit from deep reasoning; mechanical implementation often doesn't. If your agent supports reasoning budget controls, allocate them asymmetrically.

---

## IV. What the Evidence Says Doesn't Work (or Works Less Than Claimed)

### Comprehensive AGENTS.md Files Generated by /init

The ETH Zurich study is clear: -3% success rate, +20% cost. The generated files cache information the agent would discover on its own. For well-documented repos, they're pure overhead. The one exception: repos with poor documentation, where context files fill an actual information gap.

### More Tools = More Capability

Vercel's 15→2 tool reduction improved every metric. The mechanism: each specialized tool increases the decision space. The model spends more tokens *choosing* than *doing*. General-purpose tools (bash, file access) map to training distribution — models know how to use them without schema overhead.

**The sweet spot isn't zero tools.** It's the minimum set that covers the task space. Bash + file read/write + search covers most coding tasks. Add specialized tools only when they provide verification signal the agent can't get from bash (e.g., structured test output, type checker JSON).

### Complex Multi-Agent Orchestration (For Most Teams)

Anthropic's own guidance: start with simple patterns (augmented LLM, prompt chaining) before reaching for agent frameworks. The three most production-tested harnesses (Codex, Claude Code, Manus) all simplified over time. Manus rebuilt four times; each rebuild removed complexity.

The Bitter Lesson applied: if every model upgrade makes you add more routing/pipeline logic, you're swimming against the current. Build for deletion.

### Overnight Unattended Agent Runs (Without Mature Verification)

The harness engineering playbook distinguishes attended (3-5 parallel, human checking in) from unattended (post in Slack, review PR next day). Unattended requires *mature verification*: strong CI, comprehensive testing, high trust. Stripe can do it because of Toolshed, pre-warmed devboxes, and tight CI integration. Most teams can't.

**The risk gradient:** attended with tight feedback loops → attended with loose monitoring → unattended with strong CI → unattended with weak CI. Each step requires significantly more harness investment. Don't skip levels.

---

## V. The Honest Assessment: What Remains Unproven

### 1. Nobody Has Measured the Total Cost

The Hidden Denominator (insight #18 from your corpus) remains the elephant in the room. OpenAI: 5 months building the harness. Steinberger: "significant chunk of time on meta-work." Tane: 3-6 annotation cycles per feature. LangChain: built a Trace Analyzer Skill, ran multiple benchmark iterations, spent ~$300 on benchmarking alone.

None of this is counted against claimed productivity gains. The "compounding returns" argument needs both sides of the ledger, and nobody is tracking the cost side.

### 2. All Success Stories Are Greenfield

OpenAI: empty repo. Steinberger: new projects. Stripe: Minions built as greenfield infrastructure. LangChain: benchmark tasks.

Böckeler's critique remains unanswered: "Applying these techniques to a ten-year-old codebase with no architectural constraints, inconsistent testing, and patchy documentation is a much more complex problem... like running a static analysis tool on a codebase that's never had one — you'd drown in alerts."

The METR RCT tested brownfield (experienced devs on their own mature repos) and found *slowdowns*. This may not be coincidence.

### 3. The Verification Gap Is Structural — But the Specification Approach Has New Evidence

Your corpus (verification-alignment-software-factory) identifies the core problem: agent writes code + agent writes tests = closed loop, no external verification. OpenAI's agent-to-agent review makes this *worse* (same distributional biases). The harness provides *syntactic and structural* verification (types, linters, architectural constraints). It doesn't verify *semantic correctness* (does this code do what the user actually intended?).

The specification sandwich (from your maximum-leverage brainstorm) was the best *theoretical* answer: human writes specifications, agent implements against them. **It's no longer just theoretical.** The JUXT Allium case study (Feb 2026) demonstrated it at serious scale: 3,000 lines of behavioral specification in a formal-ish language (between TLA+ and structured prose), fed to Claude Code, produced a distributed system with Byzantine fault tolerance, strong consistency, and crash recovery — 5,500 lines of production Kotlin + 5,000 lines of tests. The system sustained 10,000+ RPS with sub-100ms p99 latency and survived all four crash-recovery scenarios.

The critical lessons from JUXT that weren't in the theoretical framing:
- **Specs aren't written upfront and frozen.** They evolved through 64 commits as load tests and resilience tests exposed gaps. "When crash testing revealed that a recovering instance needed to account for the gap between what it had persisted and what its peers had published, we revised the recovery spec before changing the code."
- **Specs catch integration gaps that code can't.** Each component spec was faithfully implemented, but federation wiring — "where and when TCP connections get established" — fell through because it wasn't any single component's responsibility. This is Brooks' essential complexity concentrating at boundaries, and the spec is where you catch it.
- **The specification IS the theory.** This directly addresses Naur's Nightmare: the spec is the domain understanding that survives the implementation. Anyone can read 3,000 lines of Allium and understand the system's intended behavior. They can't do that with 5,500 lines of generated Kotlin.
- **The investment ratio:** ~2 lines of working code per line of spec. The spec work IS the engineering; the code generation is the implementation detail.

The tension remains: this requires the human to invest in specifications. But the JUXT case reframes the cost: specification isn't overhead on top of coding — it's the engineering *instead of* coding. The question isn't "does specification cost time?" but "is it faster to specify and verify than to write and debug?"

### 4. Long-Term Maintenance: Zero Data

Willison: "I've found myself getting lost in my own projects." Steinberger's ~300K LOC TypeScript. OpenAI's million-line internal beta. What happens in 2-3 years when these need maintenance? Nobody knows. It's the time bomb under the entire discourse.

### 5. The Self-Improving Harness Has Chicken-and-Egg Problems

pi-reflect (auto-updating AGENTS.md from session frustration data) shows correction rate declining from 0.45 to 0.07 — then spiking when facing a new domain (Rust project: 0.52-1.07). The harness learns, but only for the domain it's been exposed to. Each new domain resets the learning.

LangChain's trace analysis approach (boosting-like iteration on failure modes) is more systematic but faces the same generalization problem: changes that improve one task class can regress others.

### 6. Multi-Agent Harnesses Have a Shared Memory Problem Nobody Has Solved

Cemri et al.'s MAST taxonomy (O'Reilly, Feb 2026), built from 1,600+ annotated execution traces across AutoGen, CrewAI, and LangGraph, found that **interagent misalignment accounts for 36.9% of all multi-agent failures**. Agents don't fail because they can't reason — they fail because they operate on inconsistent views of shared state. The harness engineering literature is almost entirely about single-agent loops. As teams move toward multi-agent patterns (Claude Agent Teams, Codex parallel agents), the harness must solve state synchronization — and nobody has a good answer yet. Manus's filesystem-as-memory is the most battle-tested approach, but it's fundamentally single-agent.

### 7. Documentation-Based Rules Are Structurally Unreliable — Mechanical Enforcement Is Not Optional

The HN thread on the AGENTS.md evaluation (47034087) provided the strongest practitioner confirmation of a key claim in this document. A developer reported: "I have a line [in AGENTS.md] that says Codex should never use Node APIs where Bun APIs exist for the same thing. Routinely, Claude Code and now Codex would ignore this. I just replaced that rule with a TypeScript-compiler-powered AST-based deterministic rule. Now the agent can attempt to commit code with banned Node API usage and the pre-commit script will fail." Multiple practitioners independently reported migrating AGENTS.md rules to mechanical checks. The pattern is clear: **every rule that CAN be a linter/test SHOULD be a linter/test.** AGENTS.md is for what can't be mechanically enforced — team decisions, migration boundaries, architectural intent. This upgrades practice E (architectural constraints) from "high evidence" to "consensus" — the gap between documented rules and mechanical enforcement is now widely observed and independently confirmed.

---

## VI. The Hierarchy of Leverage

Based on the evidence, ranked by marginal return on investment:

| Rank | Practice | Why | Evidence | Shelf Life |
|------|----------|-----|----------|-----------|
| 1 | **Close the feedback loop** — linters, type checkers, test runners inline with every write | Provides external verification signal; prevents premature completion | LangChain +13.7pts, Stripe 1000+ merged PRs/week, universal practitioner consensus | **Durable** |
| 2 | **Enforce architecture mechanically** — linters + structural tests, not documentation | Creates the contract the LLM can't provide; prevents drift at scale. Every rule that CAN be a test SHOULD be a test. | OpenAI million-line product, Böckeler, HN practitioner migration from AGENTS.md→AST checks | **Durable** |
| 3 | **Simplify tools** — fewer, general-purpose (bash + files) over many specialized | Reduces decision space, saves tokens, maps to training distribution | can1357 10× on weakest models, Manus 4 rebuilds toward simplicity, Vercel directional (⚠️ n=5) | **Durable** |
| 4 | **Write specifications, not just instructions** — formal-ish behavioral specs as ground truth | Spec IS the engineering; code is implementation detail. Catches integration gaps. Preserves theory. | JUXT Allium (3K spec → 5.5K Kotlin, distributed BFT system), maximum-leverage brainstorm | **Unknown** (may be permanent equilibrium) |
| 5 | **Start AGENTS.md empty, build from friction** — only ambiguity resolution + expensive inference caching | Avoids context bloat penalty. Value inversely proportional to repo documentation quality. | ETH Zurich -3% from generated files (⚠️ SWE-bench only); OpenAI progressive disclosure; HN practitioner consensus | **Unknown** |
| 6 | **Force self-verification before completion** — checklist middleware / pre-exit hooks | Counters models' bias toward first plausible solution | LangChain build-verify loop, Anthropic harness guide | **Temporal** (models improving) |
| 7 | **Build observability access** — browser CLI, logs, DB, traces, metrics | "If you can't measure it, you can't improve it" applies to agents | OpenAI DevTools integration, Demmel's practitioner report | **Durable** |
| 8 | **Detect and break doom loops** — edit count tracking, forced reconsideration | Prevents 10+ iteration waste on broken approaches | LangChain LoopDetectionMiddleware, consistent failure mode in traces | **Temporal** (models improving) |
| 9 | **Run garbage collection** — background agents scanning for drift from golden patterns | Prevents entropy accumulation that compounds faster with agent code | OpenAI Friday cleanup → automated scans | **Unknown** |

### The One-Sentence Version

Build the tightest possible feedback loop between the agent's output and mechanical verification, write specifications that encode your intent in a form both agents and tests can check, and classify every piece of harness logic as durable or temporal so you know what to delete when models improve.

---

## VII. The Meta-Insight: Harness Engineering Is Not New

Strip away the AI framing and harness engineering is: strict linting, fast CI, enforced architecture, good documentation, mechanical verification, observable systems. These were best practices before anyone prompted a language model.

Demmel says it directly: "If the AI bubble pops next month, you're left with easy-to-test codebases that you can pick up again yourself."

The reason harness engineering *matters more now* is that agents amplify whatever they find (DORA 2025's culture amplifier). A codebase with strong verification catches agent mistakes the way it catches human mistakes. A codebase without verification has a new, faster way to accumulate debt.

The harness engineering revolution isn't a revolution. It's the industry belatedly realizing that the engineering practices it skipped for decades are now load-bearing.

An HN commenter (47046959) crystallized this perfectly: "My pet peeve with AI is that it tends to work better in codebase where humans do well and for the same reason. Large orchestration package without any tests that relies on a bunch of microservices to work? Claude Code will be as confused as our SDEs. This in turn leads to broader effort to refactor our antiquated packages in the name of 'making it compatible with AI' which actually means compatible with humans."

This is the DORA culture amplifier made concrete: the codebases where harness engineering works are the ones that were already well-engineered. For the median codebase — patchy tests, unclear boundaries, accumulated entropy — harness engineering is a prescription to fix existing dysfunction first. The prescription is correct; the implied claim that AI makes it easy is not.

### The Temporal Structure of Harness Practices

Not all harness practices have the same shelf life. Cross-checking against the Bitter Lesson and Manus's four rebuilds reveals a useful classification:

**Durable (good engineering regardless of AI):**
- Linting, type checking, CI/CD
- Enforced architecture (structural tests, dependency validation)
- Observability (logs, metrics, traces accessible via CLI)
- Test infrastructure (fast, incremental, composable)
- Documentation as code (versioned, co-located, mechanically checked for freshness)

**Temporal (compensating for current model limitations, build for deletion):**
- Doom loop detection (models will get better at recognizing futile approaches)
- Forced pre-completion verification checklists (models will learn to self-verify)
- Reasoning budget sandwiches (adaptive reasoning is already emerging)
- Context compaction heuristics (context windows keep growing)
- Negative instruction avoidance (models may learn to handle negation reliably)

**Unknown shelf life:**
- AGENTS.md / progressive disclosure architecture (may become unnecessary as models internalize repo conventions, or may become MORE important as codebases grow)
- Garbage collection agents (may be solved by models that maintain coherence natively, or may remain necessary forever because entropy is a property of the codebase, not the model)
- Specification-first development (may be superseded by models that can extract intent from examples, or may be the permanent equilibrium because specification IS the engineering)

---

## VIII. Self-Critique: What This Document Gets Wrong or Oversells

**1. The "harness > model" framing is partially a category error.** The LangChain and can1357 experiments show that harness improvements yield large gains. But they don't show that harness improvements yield *larger* gains than model improvements on the same tasks. A proper comparison would fix the harness and vary the model, then fix the model and vary the harness, measuring both deltas. Nobody has done this controlled comparison. The strongest version of "harness > model" would be: "past a capability floor, the *marginal* return on harness investment exceeds the marginal return on model switching." This is plausible but unproven.

**2. The evidence base is dominated by benchmarks, not production.** LangChain used Terminal Bench. can1357 used React mutation fixtures. Vercel used a 5-query benchmark. APEX-Agents used simulated professional tasks. The ETH Zurich study used SWE-bench. These are all useful proxies, but none measures what actually matters: sustained developer productivity over weeks/months on real production codebases. The OpenAI and Stripe examples are production-scale but vendor-reported without independent verification.

**3. The document underweights the "harness engineering as labor" problem.** The r/ExperiencedDevs thread raised a crucial point: "The issue was never the quality of the tools, it was leadership decisions on how hard to push them." Harness engineering requires sustained engineering investment. In most organizations, nobody is staffed to build custom linters, structural tests, and garbage collection agents. The practices described here are most accessible to small, high-agency teams — exactly the teams that were already well-engineered.

**4. The LangChain evidence has a vendor conflict.** LangChain sells LangSmith, which is their observability/tracing product. Their harness engineering blog post concludes by recommending traces (stored in LangSmith) as the primary improvement mechanism. The +13.7 point result is real, but the methodology recommendation ("use our product to improve your agent") is marketing. I should have flagged this more prominently in v1.

**5. The "specification-first" recommendation from the JUXT case may not generalize.** The JUXT case involved a single expert with deep distributed systems knowledge writing formal specs in a custom language. This is the expert-with-AI pattern, not a generalizable methodology. Most developers can't write 3,000 lines of behavioral specification for a distributed system. The question is whether a lighter-weight version (types + contracts + property tests, per the maximum-leverage brainstorm) captures enough of the benefit at lower skill cost. No data exists on this.

---

## Sources

| Source | Type | Independence | Used for |
|--------|------|-------------|----------|
| [LangChain deepagents harness engineering](https://blog.langchain.com/improving-deep-agents-with-harness-engineering/) | Primary, vendor | ⚠️ Sells LangSmith | Terminal Bench improvement data, trace analysis methodology |
| [ETH Zurich / LogicStar AGENTS.md evaluation](https://arxiv.org/abs/2602.11988) | Academic | **High** | Only rigorous empirical study of context file effectiveness |
| [Pappas, "The Agent Harness Is the Architecture"](https://dev.to/epappas/the-agent-harness-is-the-architecture-and-your-model-is-not-the-bottleneck-3bjd) | Independent analysis | **High** | Convergence analysis across Codex, Claude Code, Manus; APEX-Agents data |
| [can1357, "I Improved 15 LLMs"](https://blog.can.ac/2026/02/12/the-harness-problem/) | Primary, practitioner | **High** | Hashline edit tool benchmark across 15 models |
| [Böckeler on martinfowler.com](https://martinfowler.com/articles/exploring-gen-ai/harness-engineering.html) | Independent analysis | **High** | Most critical independent review; brownfield critique |
| [Demmel, "Feedback loop engineering"](https://www.danieldemmel.me/blog/feedback-loop-engineering) | Independent analysis | **High** | Three-layer hierarchy, Unix connection |
| [New Stack, "Coding agents are only as good as the signals"](https://thenewstack.io/coding-agents-feedback-signals/) | Journalism | Moderate | Stripe Minions verification gauntlet detail |
| [Arize, "Closing the Loop"](https://arize.com/blog/closing-the-loop-coding-agents-telemetry-and-the-path-to-self-improving-software/) | Primary, vendor | ⚠️ Sells observability | Telemetry as harness component |
| [EQ Engineered, "Harness Engineering and Continuous AI"](https://www.eqengineered.com/insights/https/harness-engineering-and-continuous-ai-key-takeaways) | Independent analysis | **High** | Harness-as-service-template thesis, brownfield considerations |
| [pi-reflect](https://github.com/jo-inc/pi-reflect) | Open source tool | **High** | Self-improving AGENTS.md from frustration data |
| [Upsun, "Your AGENTS.md is probably too long"](https://devcenter.upsun.com/posts/agents-md-less-is-more/) | Practitioner + academic | **High** | ETH Zurich study interpretation, incremental-build recommendation |
| [Dortort, "Don't Ditch AGENTS.md — Fix What's In It"](https://dev.to/dortort/dont-ditch-agentsmd-fix-whats-in-it-24ph) | Independent analysis | **High** | Ambiguity resolution + cost caching framework |
| [APEX-Agents benchmark](https://arxiv.org/abs/2601.14242) | Academic | **High** | Real professional task performance data (24% pass@1) |
| [Vercel, "We removed 80% of our agent's tools"](https://vercel.com/blog/we-removed-80-percent-of-our-agents-tools) | Primary, vendor | Moderate | Fewer tools = better results data |
| [OpenAI, "Harness Engineering"](https://openai.com/index/harness-engineering/) | Primary, vendor | ⚠️ Sells Codex | Architectural constraints, progressive disclosure, garbage collection |
| [Anthropic, "Effective Harnesses for Long-Running Agents"](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents) | Primary, vendor | ⚠️ Sells tokens | Two-agent pattern, JSON > markdown for state |
| [JUXT, "From specification to stress test"](https://www.juxt.pro/blog/from-specification-to-stress-test/) | Primary, practitioner | **High** | Specification-first development with Allium + Claude Code; distributed system case study |
| [O'Reilly, "Why Multi-Agent Systems Need Memory Engineering"](https://www.oreilly.com/radar/why-multi-agent-systems-need-memory-engineering/) | Independent analysis | **High** | Cemri et al. MAST taxonomy; 36.9% interagent misalignment failure rate |
| [HN thread: Evaluating AGENTS.md](https://news.ycombinator.com/item?id=47034087) | Community | **High** | Practitioner counter-evidence to ETH Zurich conclusions; mechanical enforcement migration pattern |
| [Mtrajan, "Harness Engineering Is Not Context Engineering"](https://mtrajan.substack.com/p/harness-engineering-is-not-context) | Independent analysis | **High** | Context vs. harness distinction; constraint/feedback/observability framing |
| [Sonnet 4.6 benchmarks](https://venturebeat.com/technology/anthropics-sonnet-4-6-matches-flagship-ai-performance-at-one-fifth-the-cost) | Journalism | Moderate | SWE-bench 79.6%, Terminal-Bench ~59% — model capability context |
| Internal corpus | Own analysis | Own analysis | Insight inventory, verification analysis, critical reviews |
