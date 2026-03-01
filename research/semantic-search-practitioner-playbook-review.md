← [Coding Agents](../topics/coding-agents.md) · [Index](../README.md)

# Critical Review: Semantic Search Practitioner Playbook

**Date**: 2026-02-28
**Reviewing**: [semantic-search-practitioner-playbook.md](./semantic-search-practitioner-playbook.md)

---

## Verdict

The playbook has one factual error that undermines a core recommendation, several overconfident framings that flatten noisy evidence into clean narratives, and a structural bias toward action that underweights the "do nothing" baseline. The ranking is roughly right — Tier 1 before Tier 2 is correct — but the confidence gradient is steeper than the evidence supports. After Tier 1, you're mostly making bets.

---

## 1. Factual Error: RTK Saves Input Tokens, Not Output Tokens

**The claim**: "Output tokens are expensive ($25/M on Opus 4.5). This targets the most expensive token category."

**The problem**: This is wrong. RTK compresses CLI command output *before* it re-enters the LLM as a tool result. Tool results are **input tokens** ($5/M on Opus 4.5), or more likely **cache read tokens** ($0.50/M) in subsequent turns. RTK does not and cannot reduce LLM-generated output tokens — those are what Claude writes, not what bash returns.

RTK's own reporting labels its columns "Input tokens" (raw CLI output) and "Output tokens" (compressed result sent to LLM). Both become input tokens from the LLM's billing perspective.

**Impact on the recommendation**: The "5× dollar impact per token saved vs. semantic search" claim is wrong. RTK saves input tokens at the same rate as semantic search. The cost math example ($1.25 → $0.125) is overstated by 5×. At input pricing ($5/M), 50K tokens cost $0.25, compressed to 5K = $0.025 — a saving of $0.225, not $1.125.

**What's still true**: RTK is a good Tier 1 recommendation because (a) it's zero-quality-risk — you lose no signal the LLM needs, (b) it prevents context window bloat which causes context rot, and (c) the percentage savings are genuinely large (60-90%). The *quality* argument for RTK (less noise = better attention allocation) is actually stronger than the cost argument. The playbook should lead with the quality case.

**Severity**: High. This is the kind of error that erodes trust in the rest of the analysis. Must be corrected.

---

## 2. Augment's 30-80% Is Vendor Benchmark on a Single Repo

**The claim**: "Best quality — 30–80% improvement on PR benchmarks."

**What I should have interrogated harder**:
- 300 Elasticsearch PRs × 3 prompts = 900 attempts. On *one codebase* (Elasticsearch). Elasticsearch is a large, mature Java/Kotlin monorepo — exactly the kind of unfamiliar, sprawling codebase where semantic search should shine most. Generalizing this to "30-80% improvement" without that caveat is misleading.
- The improvement metric is Augment's own composite score across 5 dimensions (correctness, completeness, best practices, code reuse, documentation). We don't know the weighting. A tool that adds more docstrings could score high on "documentation" without meaningful quality improvement.
- The 80% figure is Claude Code + Opus 4.5 specifically. Claude Code's *default* context gathering (grep/read loops) may be particularly weak on unfamiliar Java repos compared to, say, a TypeScript repo where file naming conventions make grep more effective. The 80% may measure "how bad Claude Code is without help on Elasticsearch" as much as "how good Augment is."
- The 30% figure (Cursor + Composer-1) is more conservative and probably more representative, since Cursor already has its own semantic search. The Augment MCP is adding on top of Cursor's existing retrieval — so the marginal gain there is 30%, not 80%.

**What I'd change**: Reframe as "30-80% on Augment's own benchmark (Elasticsearch PRs). The 30% on Cursor (which already has semantic search) is the more honest marginal number. The 80% on Claude Code reflects Claude Code's weak default retrieval on unfamiliar large repos as much as Augment's strength."

**Severity**: Medium. The recommendation to try Augment is still reasonable, but the confidence framing is too strong.

---

## 3. The "1000 Files" Threshold Is Cleaner Than the Data

**The claim**: "Is your codebase >1000 files?" as a clean decision gate, citing Cursor's 2.6% retention improvement.

**The problem**: 2.6% is a tiny effect size. Cursor's blog doesn't publish confidence intervals or p-values for this number. The jump from 0.3% (all codebases) to 2.6% (large codebases) could be noisy — we're talking about "code retention" (code the agent writes that stays in the codebase), which is an indirect proxy for quality that's confounded by codebase complexity (on large repos, more code gets rewritten regardless).

The 1000-file threshold is Cursor's internal categorization, not a validated breakpoint. The actual relationship between codebase size and semantic search benefit is probably continuous and noisy, not a step function at 1000 files.

**What I'd change**: Present as "signal strengthens with codebase size, with clearest benefits above ~1000 files per Cursor's data — but this is one data point, not a validated threshold. The mechanism is sound (larger codebases → more exploration → more room for shortcutting), even if the exact threshold is uncertain."

**Severity**: Low-Medium. The directional advice is correct; the threshold is presented with false precision.

---

## 4. "Quality Lever Not Cost Lever" May Overrotate

**The framing**: The playbook's thesis is "semantic search is about quality, not cost."

**The blind spot**: For API users spending $20-100/day, cost *is* quality. When you hit a budget ceiling or context window limit, your session terminates or degrades. Cost optimization isn't just about unit economics — it's about **session sustainability**. A user who can run 3 full sessions per day instead of 2 (because each session is 30% cheaper) gets more total work done.

The playbook also ignores that on Max plans ($100-200/mo), there are still *rate limits* — you hit a 5-hour usage window cap. Token efficiency extends how long you can work within that window before being throttled. The flat-rate framing ("cost doesn't matter on Max") misses this.

**What I'd change**: Acknowledge the dual role: "For API users, cost savings extend session budgets. For Max users, token efficiency extends rate-limit windows. Quality is the durable argument, but cost efficiency has immediate practical value that shouldn't be dismissed."

**Severity**: Medium. The core thesis (quality > cost) is supported by the evidence, but the binary framing ("quality, not cost") is too clean.

---

## 5. Structural Search (Serena) Recommended Without Hard Evidence

**The claim**: "This is the **most underutilized layer** in the stack."

**The problem**: I cite no benchmark, no A/B test, no controlled comparison for Serena or any AST-based MCP. The evidence is:
- Anecdotal claims ("Serena can save tokens up to about 70%!" — one blog post)
- serena-slim's claim of "50.3% token reduction" — from the tool's own marketing
- Architectural reasoning (LSP gives precise symbol navigation, avoids staleness)

The architectural argument is sound. But "most underutilized" is a strong claim with weak evidence. It could equally be "most underutilized because it doesn't work well in practice" — LSP servers crash, don't support all languages equally, and add MCP overhead that may offset gains.

**What I'd change**: Demote from "most underutilized" to "architecturally promising but undervalidated. No rigorous benchmarks exist. The mechanism (precise symbol navigation without indexing) is sound for statically-typed languages. Worth trying if you're already hitting limits with grep, but don't expect it to be transformative based on current evidence."

**Severity**: Medium. The recommendation direction is defensible; the confidence level is overstated.

---

## 6. The Playbook Has a Structural Action Bias

**The meta-problem**: The playbook is organized around "what to add to your stack." It underweights three alternatives that may have higher ROI:

### a) The "Do Nothing" Baseline Is Improving
Models are getting better at agentic search every generation. Context windows are growing. Claude Code's search heuristics are being actively improved. The value proposition of *any* optimization tool degrades over time as the baseline improves. What's worth adding today may be redundant in 6 months.

The research document notes this in §4.3 (falling token prices) but the playbook doesn't internalize it. A practitioner reading the playbook gets "here are 8 things to add" — no one is saying "here's why you might not need any of them next quarter."

### b) AGENTS.md / Project Documentation
The research mentions "good AGENTS.md files" but buries it as item 3-4 in persona lists. For many practitioners, writing a thorough AGENTS.md (project structure, key files, conventions, architecture) is the **highest-ROI context optimization** — it front-loads the knowledge that agentic search would otherwise have to discover through expensive exploration. Zero infrastructure, zero staleness (it's versioned with the code), and it helps human onboarding too.

The playbook should probably lead with this before any tooling recommendations.

### c) Model Selection
Dropping from Opus 4.5 ($5/$25) to Sonnet 4.5 ($3/$15) for routine tasks saves 40% immediately — more than any tool in the playbook. Model routing (use Sonnet for exploration, Opus for complex reasoning) is a first-order cost lever that the playbook ignores entirely.

**Severity**: Medium-High. The playbook is a good tool-focused guide but presents tooling solutions to problems that may have simpler answers.

---

## 7. RTK Numbers Are From Rust/Cargo Projects

The 89% and 83.7% figures come from heavy `cargo test` and `cargo build` users. Cargo is notoriously verbose. The generalizability to other stacks:

- **Python/pytest**: Already fairly concise output. RTK savings would be lower.
- **JavaScript/npm**: `npm install` is verbose; test output varies by framework. Moderate savings likely.
- **Go**: Compiler output is minimal. Test output is terse by default. Low savings likely.

Presenting "60-90% savings" without this caveat makes RTK look universally transformative when it's stack-dependent.

**Severity**: Low-Medium. The recommendation to try RTK is fine; the expected magnitude is overstated for non-Rust workflows.

---

## 8. Self-Route Is Aspirational, Not Implementable

**The claim**: "How to approximate today: In your AGENTS.md or system prompt, instruct the agent to try semantic search first..."

**The problem**: The Li et al. Self-Route architecture uses a trained confidence classifier to decide when RAG retrieval is sufficient. "Write it in your AGENTS.md" is not Self-Route — it's a system prompt instruction that the LLM may or may not follow. There's no evidence that AGENTS.md-level routing instructions produce the Self-Route paper's 39-65% cost reduction. This conflates an academic architecture with an ad-hoc prompt engineering hack.

**Severity**: Medium. Tier 3 items are explicitly marked as strategic/aspirational, so the expectation-setting is somewhat appropriate. But claiming "39-65% cost reduction" next to "write it in your AGENTS.md" is misleading.

---

## 9. Pi-Specific Blind Spot

The user is on Pi, not Claude Code. Several Tier 1 recommendations are Claude Code-specific:
- MCP Tool Search: Claude Code feature (Pi doesn't have MCP tool loading overhead the same way)
- `/compact`: Claude Code command (Pi has session trees and model-switching instead)
- RTK integration via Claude Code hooks: Pi would need different configuration

The persona sections address Claude Code and Cursor users but not Pi users. Given the user's actual setup, the playbook should acknowledge which recommendations transfer to Pi and which are agent-specific.

**Severity**: Low-Medium. The underlying principles transfer (compress context, use structural search). The specific tool recommendations need adaptation.

---

## 10. Forward-Looking Bets Are Reasonable But Unfalsifiable

All six predictions are directionally plausible and unfalsifiable within the document's shelf life. "Context as infrastructure will become a category" — maybe, but when? "Open-source code embeddings will close the gap" — maybe, but CodeSage and StarEncoder have existed for over a year without closing it. "Adaptive retrieval will become the norm" — this is describing what Cursor already does, so it's more observation than prediction.

The predictions are fine as orientation but shouldn't be mistaken for actionable intelligence. Nothing in this section changes what a practitioner should do today.

**Severity**: Low. Standard futurism caveat.

---

## What the Playbook Gets Right

To be fair — the core structure is sound:

1. **The hybrid consensus is well-established.** Cursor + Anthropic convergence from opposing incentives is the strongest signal in this entire space. The playbook correctly centers this.

2. **Tiering by impact-to-effort is the right organization.** Prompt caching before semantic search is obviously correct. The ordering within tiers is reasonable.

3. **The "What NOT to Do" section is the most valuable part.** "Don't replace grep," "don't trust 97%," "don't optimize tokens when you should optimize quality" — these prevent real mistakes practitioners would otherwise make.

4. **The decision framework (3 questions) is genuinely useful** even if the thresholds are imprecise. "Do you need this at all?" is the right first question.

5. **Source credibility and conflict-of-interest tracking** is unusually transparent for a playbook. Most guides just list tools without noting that every vendor benchmarked their own product.

---

## Recommended Corrections

| # | Issue | Fix | Priority |
|---|-------|-----|----------|
| 1 | RTK framed as saving output tokens | Correct to input tokens; lead with quality argument (less noise = better attention), demote cost math | **Must fix** |
| 2 | Augment 30-80% presented as general quality improvement | Add caveat: single-repo benchmark, 30% marginal over Cursor is the honest number | Should fix |
| 3 | Structural search called "most underutilized" without evidence | Soften to "architecturally promising, undervalidated" | Should fix |
| 4 | Missing: AGENTS.md as highest-ROI context optimization | Add as Tier 1 item 0, before any tooling | Should fix |
| 5 | Missing: model selection as cost lever | Add note in cost section | Should fix |
| 6 | "Quality not cost" framing too binary | Acknowledge cost = session sustainability | Nice to fix |
| 7 | 1000-file threshold too precise | Soften language | Nice to fix |
| 8 | RTK savings not flagged as stack-dependent | Add caveat about Rust-heavy benchmarks | Nice to fix |
| 9 | Self-Route conflated with AGENTS.md hack | Separate the concept from the approximation | Nice to fix |
| 10 | Pi-specific gaps | Add Pi persona or note transferability | Nice to fix |

---

## Bottom Line

The playbook is a **B+**. Good structure, correct overall direction, genuinely useful decision framework and anti-patterns. But it has one outright error (RTK/output tokens), several overconfident claims (Augment 80%, Serena "most underutilized," 1000-file threshold), and a structural bias toward adding tools when the highest-ROI move for many practitioners is writing better project documentation and using cheaper models for routine work. The corrections above would make it an A-.
