← [Coding Agents](../topics/coding-agents.md) · [Index](../README.md)

# Semantic Search for LLM Coding Agents: Practitioner Playbook

**Date**: 2026-02-28
**Source**: Distilled from [semantic-search-llm-token-savings-research.md](./semantic-search-llm-token-savings-research.md), validated against latest data (Feb 2026).

---

## The One-Paragraph Summary

Semantic search is a **quality lever, not primarily a cost lever** — but cost efficiency also matters because it extends session budgets and rate-limit windows. The strongest evidence (Cursor A/B: +12.5% accuracy; Augment Code: +30% marginal improvement over Cursor's existing retrieval) shows it helps agents write correct code faster — which *indirectly* reduces tokens by eliminating retry loops and subagent spawning. Don't chase the "97% token reduction" headlines; chase fewer failed attempts. But be realistic: a 12.5% accuracy improvement on agent task completion doesn't automatically translate to 12.5% developer productivity — macro data (DX: 93% adoption, ~10% aggregate productivity gain; METR: self-assessed gains structurally unreliable) shows the end-to-end picture is murkier. The optimal stack is hybrid: agentic search (grep/ls/read) as backbone, semantic search for concept queries on large repos, structural search (AST/LSP) for symbol navigation, output compression for CLI noise, and prompt caching for cost. But before reaching for tools, **write better project documentation** — a targeted AGENTS.md (ambiguity resolution + expensive inference caching, not prose) is the highest-ROI context optimization, and the "do nothing" baseline improves faster than most practitioners realize.

---

## Decision Framework: Do You Need Semantic Search?

Answer these three questions:

| Question | If YES → | If NO → |
|----------|----------|---------|
| **Is your codebase large (roughly >1000 files)?** | Signal strengthens with codebase size. Cursor data shows clearest benefit above ~1000 files (2.6% code retention lift vs 0.3% baseline) — but this is one data point, not a validated threshold. The mechanism is sound: larger repos → more exploration → more room for shortcutting. | Agentic search (grep) is sufficient; skip the complexity |
| **Do you frequently ask concept queries?** ("where is auth handled?", "how does caching work here?") | Semantic search excels — these can't be grepped | If your queries are keyword-precise ("find function `parseConfig`"), grep wins |
| **Are you using Claude Code / API and paying per token?** | The indirect savings (fewer retries) are real; worth the setup | On flat-rate plans (Max $100–200/mo), the cost math matters less — focus on quality |

**If you answered NO to all three: stop here.** You don't need semantic search. Use grep, invest in good `AGENTS.md` files, and move on.

---

## The Practitioner Stack (Ranked by Impact-to-Effort)

### Tier 1: Do These First (High Impact, Low Effort)

#### 0. Write a Good AGENTS.md / Project Documentation
- **What**: A structured file at the repo root giving the agent "map knowledge" so it doesn't have to discover structure through expensive exploration. But **not** a monolithic instruction manual — the ETH Zurich study (Gloaguen et al., Feb 2026) found LLM-generated context files *reduced* success by ~3%, and even developer-written files increased cost by up to 19% when they duplicated information the agent could infer from code.
- **What to include (only two things)**: (1) **Ambiguity resolution** — decisions not inferable from code ("Use SerializerV2 for new features; V1 is deprecated", "Run `make generate` after modifying `schemas/`"). (2) **Expensive inference caching** — facts that cost many tool calls to discover (canonical patterns, migration boundaries, build entry points, authoritative examples).
- **What to exclude**: Everything the agent can discover by reading your README, test config, and existing docs. Every redundant line is overhead that dilutes attention.
- **Process**: Start empty. Let the agent work without a context file first. Watch where it stumbles. Add rules *only* for recurring friction. Aim for ~100 lines as a table of contents pointing to structured `docs/`, not 500 lines of prose. This is Hashimoto's principle: "Anytime you find an agent makes a mistake, take the time to engineer a solution such that the agent never makes that mistake again."
- **Impact**: Front-loads the context that agentic search would otherwise spend dozens of tool calls discovering. Zero infrastructure, zero staleness (versioned with code), helps human onboarding too. For most small-to-medium codebases, this single file may eliminate the need for any retrieval tooling.
- **Effort**: Start with 15 minutes. Grow incrementally over sessions. Update when architecture changes.
- **Why first**: This is the only optimization that costs zero tokens, requires zero tools, and improves *every* agent interaction — regardless of which agent, model, or retrieval stack you use.
- **ETH Zurich caveat**: Their study tested SWE-bench tasks on well-documented OSS repos. Most real-world repos are *not* that well-documented — the value of AGENTS.md is inversely proportional to existing documentation quality. The "start empty, build from friction" approach sidesteps the risk of over-documentation.

#### 1. Enable Prompt Caching
- **What**: Anthropic and OpenAI cache repeated system prompts at 90% discount (cache reads = $0.50/M vs $5/M on Opus 4.6).
- **How**: Happens automatically on Anthropic for prompts >1024 tokens that share a prefix. For API users, structure prompts with static content first.
- **Impact**: This is the single biggest cost lever. GrepAI's benchmark showed cache reads dominated cost structure — $4.92 total with 7.7M cache read tokens at $0.50/M.
- **Effort**: Zero. It's automatic on Claude Code / Cursor.

#### 2. CLI Output Compression (RTK or Equivalent)
- **What**: Filter noisy CLI output (test results, git log, build output) before it re-enters the LLM context window as tool-result input tokens.
- **Tool**: [RTK](https://github.com/rtk-ai/rtk) — Rust CLI proxy. Wrap commands: `rtk cargo test` instead of `cargo test`.
- **Impact**: 60–90% input token reduction on tool results. Real-world: 10.2M tokens saved over 2 weeks (89.2% reduction). `cargo test`: 155 lines → 3 lines (-98%). **Caveat**: These numbers are from Rust/Cargo workflows, which are unusually verbose. Python/Go projects will see lower savings.
- **Effort**: Low. `brew install rtk-ai/tap/rtk`, prefix commands. Claude Code can be configured to use it via hooks or AGENTS.md instructions.
- **Why it matters (quality, then cost)**: The primary benefit is **quality** — less noise means the LLM allocates attention to signal, not verbose test output or `npm install` progress bars. This directly addresses context rot. The cost benefit is real but secondary: tool results are input tokens ($5/M on Opus 4.6, or $0.50/M if cache-read), not LLM output tokens ($25/M). Don't confuse RTK's "output" column (compressed CLI output) with LLM output token pricing — both sides of RTK's compression become input tokens to the model.
- **Proportionality note**: RTK compresses individual tool results (saving ~10-150K tokens per command). But in long sessions, **per-turn context replay** dwarfs tool result size — ten tool calls on a 100K conversation means 1-5M input tokens replayed. RTK doesn't address this first-order cost. The quality argument (less noise = better attention) is more durable than the cost argument.

#### 3. MCP Tool Search (If Using Multiple MCP Servers)
- **What**: Claude Code 2.1.7+ lazy-loads MCP tool definitions instead of stuffing all into context upfront.
- **Impact**: 95% reduction in MCP overhead. One user went from 39.8K tokens (19.9% of context) → ~5K tokens (2.5%). Available context jumped from 92K to 195K tokens.
- **Effort**: Zero — automatic when MCP tools exceed 10% of context window. Ensure your MCP servers have good `serverInstructions` for accurate tool discovery.
- **Why it matters**: If you're running 5+ MCP servers, this alone reclaims 30–50% of your usable context window.
- **KV cache note**: MCP tool definitions are injected at the beginning of the prompt — adding or removing tools invalidates the KV cache for everything after. CLI-style tool discovery (`--help`) happens as append-only conversation turns, preserving the cache. This is a structural advantage of CLI-based tooling over MCP that doesn't show up in token counts but affects cost via cache miss rates.

#### 4. Use `/compact` Proactively
- **What**: Claude Code's built-in context compression. Summarizes conversation history.
- **When**: After 10–15 messages, or when `/cost` shows >5M tokens.
- **Impact**: Prevents context rot — the empirically proven degradation in LLM performance as context grows. The evidence is stronger than often appreciated: UIUC/Amazon (Oct 2025) showed that even with **100% perfect retrieval**, performance degrades 13.9–85% as input length increases — even with whitespace replacing irrelevant tokens. Opus 4.6 drops from 93% accuracy at 256K to 76% at 1M (a 17-point hit just from context length). Adobe's NoLiMa: 11/12 models dropped below 50% baseline at just 32K tokens. Anthropic showed context editing reduced token consumption by 84% in 100-turn evaluations. **Context length alone hurts — this is the central architectural constraint, not a nice-to-know.**
- **Effort**: One command. Build the habit.

### Tier 2: Add When Needed (High Impact, Moderate Effort)

#### 5. Structural/AST Search (Serena MCP or tree-sitter MCP)
- **What**: LSP-powered or AST-powered symbol navigation. Find definitions, references, call graphs, type hierarchies — without embeddings.
- **Tools**:
  - [Serena](https://github.com/serena-ai/serena) — LSP-based, 20+ languages. Best for statically-typed codebases.
  - [ast-grep MCP](https://github.com/ast-grep/ast-grep-mcp) — structural pattern matching via tree-sitter.
  - [Code Pathfinder](https://codepathfinder.dev/mcp) — Python-focused code graph.
- **Impact**: Avoids the staleness problem entirely (reads live code, no index). Perfect for "find all callers of X", "show the type hierarchy", "what implements this interface?" — queries where grep is imprecise and semantic search is overkill.
- **Effort**: Install MCP server, configure in `.claude.json`. No indexing step.
- **When to add**: If you work in statically-typed languages (TypeScript, Go, Rust, Java) and frequently navigate cross-file relationships.
- **Honesty note**: Structural search is architecturally promising but **undervalidated** — no rigorous benchmarks exist. Anecdotal claims of "70% token savings" (one blog post) and "50% reduction" (serena-slim marketing) lack controlled methodology. The mechanism is sound (precise symbol navigation without indexing overhead or staleness), but don't expect transformation based on current evidence. Worth trying if grep is clearly insufficient for your navigation patterns.

#### 6. Semantic Search via MCP (For Large/Unfamiliar Codebases)
- **What**: Embedding-based code search that understands concepts, not just keywords.
- **Tools (pick one based on your constraints)**:

| Tool | Embedding | Privacy | Setup | Best For |
|------|-----------|---------|-------|----------|
| **[Augment Code Context Engine](https://docs.augmentcode.com/context-services/mcp/overview)** | Proprietary (trained on code) | Remote (code sent to Augment) | 2 min, MCP | Strongest vendor benchmarks (30–80% on Elasticsearch PRs — see caveat below). 1000 free requests/mo. **Current best option if privacy allows.** |
| **[claude-context (Zilliz)](https://github.com/zilliztech/claude-context)** | Generic + hybrid (BM25+dense) | Remote (Milvus Cloud) or local | Moderate | Agent-agnostic, AST-aware chunking. Good if you already use Milvus. |
| **[GrepAI](https://github.com/yoan-bernabeu/grepai)** | Local via Ollama | Fully local | `grepai index`, then use | Privacy-first. Good for solo devs. Generic embeddings = lower quality than Augment/Cursor. |
| **[CodeGrok](https://github.com/rdondeti/CodeGrok_mcp)** | Local (AST + vectors) | Fully local | Moderate | AST-aware chunking + local embeddings. Newer, less battle-tested. |
| **[QMD](https://github.com/tobi/qmd)** | Local (embeddinggemma-300M + BM25 + reranker) | Fully local | `qmd index`, then use | **Not code-specific** — designed for markdown/docs/notes. But implements the full hybrid pipeline (query expansion → BM25+vector → RRF fusion → LLM reranking) locally. Best-in-class architecture for knowledge base search. CLI-native, works with any agent via bash. |

- **When to add**:
  - Codebase >1000 files (Cursor data: this is where semantic search measurably improves quality)
  - Onboarding to unfamiliar repos
  - Cross-cutting concept queries that grep can't handle
  - Multi-repo work (Augment's remote mode shines here)

- **When NOT to add**:
  - Small codebases (<50 files) — agentic search is sufficient
  - Rapidly changing code with frequent conflicts — index staleness will hurt you
  - Single-session exploratory work — index setup cost exceeds savings

- **Augment benchmark caveat**: The 30-80% improvement was measured on 300 Elasticsearch PRs (one large Java/Kotlin repo) using Augment's own composite scoring. The 80% figure is Claude Code + Opus 4.5, which may reflect Claude Code's weak default retrieval on unfamiliar Java monorepos as much as Augment's strength. The 30% on Cursor (which already has semantic search) is the more honest *marginal* number. Still impressive, but single-repo vendor benchmarks deserve the usual skepticism. Note: as model-harness co-training improves (§ Cost Reality Check), Augment's marginal value over native retrieval may shrink.

- **Critical quality note**: Generic embeddings (GrepAI, most open-source tools) have a "similarity ≠ relevance" problem. A test file for authentication is semantically similar to the auth implementation — but you probably want the implementation. This is a specific instance of a deeper structural limitation: retrieval systems return **facts** (similar chunks by embedding distance) but the task requires **judgment** (which chunks are relevant to *this* task's intent, context, and history). Purpose-trained embeddings (Augment, Cursor) partially bridge this by learning what "relevant to a coding task" means from session traces. Generic embeddings can't. Kim et al. (Feb 2026) identified "Knowledge Integration Decay" — as reasoning chains grow, models increasingly treat retrieved evidence as subordinate to their existing reasoning rather than as an objective anchor. This means even good retrieval degrades as the session gets longer. If using generic embeddings, combine with keyword filters to improve precision.

### Tier 3: Strategic / Org-Level (High Impact, High Effort)

#### 7. Self-Route Hybrid Retrieval
- **What**: Let the LLM decide whether a semantic search result is sufficient, or whether it needs full agentic exploration. Based on Li et al. (EMNLP 2024) "Self-Route" approach.
- **Academic result**: 39–65% cost reduction while maintaining full-context accuracy on hard queries — but this used a *trained confidence classifier*, not a system prompt instruction.
- **How to approximate today (rough)**: In your AGENTS.md, instruct the agent to try semantic search first for concept queries, fall back to grep/read for precise queries, and escalate to full exploration only when initial retrieval is insufficient. **Caveat**: this is an ad-hoc prompt engineering approximation, not the actual Self-Route architecture. There's no evidence this achieves the paper's cost reduction. It's a reasonable heuristic, not a validated technique.
- **Structural limitation**: Self-Route asks the LLM to *self-assess* retrieval sufficiency — but this is a judgment call, not a verifiable fact. Unlike "did the tests pass?" (deterministic), "was this retrieval sufficient?" has no external verification signal. The LLM may confidently declare a retrieved snippet sufficient when it's semantically similar but irrelevant. The academic paper used a *trained* confidence classifier, not LLM self-assessment; the gap matters.
- **Where the field is heading**: Cursor already does this implicitly (their agent uses both grep and semantic search). Explicit routing will likely become a standard agent architecture pattern, but today's approximations are crude.

#### 8. Team Index Sharing (Cursor-Specific)
- **What**: Cursor's secure indexing shares embeddings across team members via Merkle tree diffs (92% codebase similarity across clones).
- **Impact**: Amortizes indexing cost. New team member gets instant semantic search without cold-start.
- **Limitation**: Only in Cursor. Not available for Claude Code or other agents.

---

## What NOT to Do

1. **Don't replace grep with semantic search.** Every credible source (Cursor, Anthropic, SmartScope) agrees: hybrid wins. Grep is faster, has zero latency, and is more accurate for keyword-precise queries.

2. **Don't trust the "97% token reduction" claim at face value.** That's input tokens only. Total cost savings in the GrepAI benchmark was 27.5%. And that's on a benchmark designed to favor semantic search (concept queries on a large TypeScript repo).

3. **Don't index everything.** Smaller, curated indices beat giant all-inclusive ones. Exclude `node_modules`, generated code, test fixtures, vendored dependencies. Quality in → quality out.

4. **Don't ignore staleness.** If you add semantic search, re-index after significant changes. GrepAI requires manual `grepai index`. Augment and Cursor handle this automatically. Stale indices are worse than no index — they return confidently wrong results.

5. **Don't optimize tokens when you should be optimizing quality.** A wrong answer costs 3–5× more tokens than a right one (retry loops, debugging, subagent spawning). The research overwhelmingly shows: **get the first attempt right > use fewer tokens per attempt**.

6. **Don't forget the skill atrophy cost.** If the agent short-circuits codebase exploration via semantic search, the developer builds less understanding of the code. Anthropic's own research (Feb 2026) found developers using AI assistance scored **17% lower on comprehension tests** when learning new libraries. Over time, the developer's ability to write good specifications and judge agent output may degrade. This doesn't invalidate semantic search, but it means the "quality lever" has a hidden long-term cost: the human's capacity to *evaluate* quality degrades if exploration is fully automated. Consider keeping some manual exploration in your workflow, especially when onboarding to new codebases.

---

## Cost Reality Check (Feb 2026 Pricing)

For practitioners doing mental math on whether optimization is worth it:

| Model | Input | Cache Read | Output | Cache Write (5min) |
|-------|-------|------------|--------|-------------------|
| Claude Opus 4.6 | $5/M | $0.50/M | $25/M | $6.25/M |
| Claude Opus 4.6 (1M, >200K) | $10/M | $1.00/M | $37.50/M | $12.50/M |
| Claude Sonnet 4.6 | $3/M | $0.30/M | $15/M | $3.75/M |
| Claude Haiku 4 | $1/M | $0.10/M | $5/M | $1.25/M |

**Key insight**: Output tokens cost 5× input tokens. This means LLM-generated text is the most expensive token category — but it's also the one you have least direct control over (it's what the model writes). What you *can* control:
- **Input selection** (semantic search, grep): determines which tokens enter the context at $5/M (or $0.50/M cached)
- **Tool result compression** (RTK): reduces re-ingested CLI output, also at input pricing ($5/M or $0.50/M cached) — **not** at output pricing, despite RTK's column labels
- **Context window efficiency**: less noise → better attention allocation → fewer retry loops → fewer total output tokens generated across a session

The real cost lever RTK provides is *indirect*: by reducing noise, the model makes fewer mistakes, which reduces the expensive output tokens spent on wrong answers and retries.

**For Max plan users** ($100–200/mo flat rate): Token optimization matters less for unit cost, but there are still rate-limit windows (5-hour usage caps). Token efficiency extends how long you can work before being throttled. Context rot is pricing-independent.

**Model selection as cost lever**: Dropping from Opus 4.6 ($5/$25) to Sonnet 4.6 ($3/$15) for routine exploration saves 40% immediately — more than any tool in this playbook. Consider model routing: Sonnet for exploration/search, Opus for complex reasoning/generation. This is orthogonal to retrieval strategy but often higher-ROI. **Avoid the 1M context trap**: Opus 4.6's 1M window costs 2× ($10/$37.50) and degrades reasoning (93% at 256K → 76% at 1M). The cheaper and better approach is curated context at 200K, not raw stuffing at 1M.

**Falling prices trajectory**: Opus went from $15/$75 (4.0) → $5/$25 (4.5/4.6 standard) — a 67% drop. If this continues, the cost argument for semantic search weakens further. The quality argument is durable — but even the quality argument faces erosion from improving model baselines (see "do nothing" below).

**The "do nothing" baseline is improving faster than this playbook assumes**: Models get better at agentic search every generation. Context windows are growing. Claude Code's search heuristics are being actively improved. More importantly, **model-harness co-training is dissolving the tool/model boundary**: OpenAI confirmed (Gabriel Chua, Feb 2026) that Codex models are trained *in the presence of* the harness — "tool use, execution loops, compaction, and iterative verification aren't bolted on behaviors, they're part of how the model learns to operate." If retrieval capabilities get absorbed into model training, bolted-on MCP tools compete against native model capabilities. The five-team convergence on lazy discovery (CLIHub, mcpshim, mcporter, mcp-cli, CMCP — all in the same week, Feb 2026) confirms the pattern is being absorbed into infrastructure, not remaining a practitioner add-on. **Most Tier 2-3 items in this playbook are temporal bets with 6-12 month shelf lives, not durable investments.** Only Tier 1 items 0-2 (AGENTS.md, prompt caching, output compression) are likely to remain valuable regardless of model generation. Don't over-invest in infrastructure for a problem that's shrinking.

---

## Implementation Priority by Persona

### Solo Developer on Claude Code (API)
1. Good AGENTS.md files → give the agent map knowledge instead of exploration (Tier 0)
2. RTK output compression → immediate savings
3. `/compact` habit → prevent context rot
4. Add Serena MCP if in typed language → structural navigation
5. Add GrepAI or Augment MCP only if working on large/unfamiliar codebases

### Solo Developer on Claude Code Max ($100–200/mo)
1. `/compact` habit → quality, not cost
2. MCP Tool Search → reclaim context window if using many MCPs
3. Good AGENTS.md → fewer wrong turns
4. Serena MCP → structural search
5. Skip semantic search unless repo is genuinely large or concept-heavy

### Team on Cursor
1. Enable codebase indexing (already built in) → the 12.5% accuracy improvement is free
2. Use team index sharing → instant onboarding
3. RTK for CLI noise → applies even within Cursor terminal
4. Trust the hybrid — Cursor's agent already combines grep + semantic search

### Pi / Minimal Harness User
1. Good AGENTS.md → the single highest-leverage move; Pi's minimal system prompt leaves maximum room for project context
2. RTK-equivalent output filtering → Pi uses bash directly; configure via skills or AGENTS.md instructions to prefer compact output
3. Model routing → Pi supports mid-session model switching; use Sonnet for exploration, Opus for generation
4. Serena or ast-grep MCP → if Pi supports MCP, structural search transfers directly; if not, equivalent LSP queries via bash
5. Semantic search → GrepAI (local, CLI-based) integrates with any agent that can run shell commands; QMD for markdown/docs knowledge bases (same hybrid pipeline, CLI-native); Augment MCP requires MCP support

**Transferability note**: Tier 1 items 0-2 (AGENTS.md, prompt caching, output compression) are agent-agnostic. Items 3-4 (`/compact`, MCP Tool Search) are Claude Code-specific — Pi's session trees and compact system prompt address similar problems differently. Tier 2-3 tools work with any agent that supports MCP or shell commands.

### Team Using API Directly (Custom Agent)
1. Prompt caching architecture → structure prompts for maximum cache hits
2. Self-Route pattern → semantic search first, agentic fallback
3. Augment Context Engine MCP → best standalone quality (30–80% improvement in their benchmarks)
4. RTK or custom output filtering → compress before injecting into context
5. Context editing / summarization between turns → prevent rot in long sessions

---

## Forward-Looking Bets (6–18 Months)

1. **Augment-style "context as infrastructure" will become a category.** Standalone semantic context engines sold as MCP services, not embedded in IDEs. Watch for competition here — Zilliz, Augment, and likely others.

2. **MCP Tool Search pattern will generalize** to MCP *resource* search — not just tool definitions but also context/retrieval results will be lazy-loaded and routed.

3. **Code-specific embedding models will go open-source.** Cursor has a proprietary one; open alternatives (CodeSage, StarEncoder) are emerging. When a good open code embedding model drops, the quality gap between Augment/Cursor and open-source tools closes significantly.

4. **Late interaction models (ColBERT-style) will improve code search quality** by capturing token-level similarity instead of single-vector cosine. This directly addresses the "similarity ≠ relevance" problem. Watch Jina AI's late chunking work and Weaviate's productization.

5. **Context windows will keep growing, but context rot means you still shouldn't fill them.** The discipline is "less is more" — curate aggressively, don't dump. Anthropic's attention budget concept will become standard developer knowledge.

6. **The real winner will be adaptive retrieval** — agents that dynamically choose between grep, semantic search, AST navigation, and full file reads based on query type and codebase size. This is Cursor's current approach; it will become the norm.

7. **Model-harness co-training will absorb many retrieval capabilities into the model itself.** OpenAI is already doing this with Codex; Anthropic likely is too. This means bolted-on retrieval tools (Tier 2-3 in this playbook) may become redundant as models natively learn when and how to search. The tools that survive will be those providing *data* the model can't access natively (private indices, team knowledge), not those providing *strategies* the model could learn (when to grep vs. read vs. search).

---

## Sources & Confidence Levels

| Source | Type | Confidence | Conflict of Interest |
|--------|------|------------|---------------------|
| Cursor semantic search evaluation (Nov 2025) | A/B test, production users | **High** | Invested in semantic search infra |
| Augment Code Context Engine benchmarks (Feb 2026) | Controlled eval, 300 PRs × 3 prompts | **Medium-High** | Sells the product |
| Boris Cherny / Anthropic (Feb 2026) | Product leader testimony | **High** | Sells tokens (prefers high-token approaches) |
| GrepAI benchmark (Jan 2026) | Controlled benchmark, 1 repo, 5 queries | **Medium** | Tool maintainer ran the benchmark |
| Li et al. EMNLP 2024 | Peer-reviewed academic | **High** | None (Google DeepMind) |
| Chroma context rot (Jul 2025) | Technical report | **High** | Sells vector DB |
| RTK savings claims (Feb 2026) | Self-reported, detailed logs | **Medium** | Tool author |

The convergence of Cursor (invested in semantic search) and Anthropic (abandoned it as primary) agreeing that **hybrid is best** is the highest-confidence signal — their opposing commercial incentives make their agreement especially trustworthy. A third convergence point reinforces this: five independent teams (CLIHub, mcpshim, mcporter, mcp-cli, CMCP) plus Cloudflare's Code Mode all converged on lazy discovery / selective retrieval in the same week (Feb 2026) — confirming "don't dump everything upfront, route to the right retrieval method per query" is now ecosystem-wide consensus.
