← [Coding Agents](../topics/coding-agents.md) · [Index](../README.md)

# Semantic Search for LLM Coding Agents: Practitioner Playbook

**Date**: 2026-02-28
**Source**: Distilled from [semantic-search-llm-token-savings-research.md](./semantic-search-llm-token-savings-research.md), validated against latest data (Feb 2026).

---

## The One-Paragraph Summary

Semantic search is a **quality lever, not primarily a cost lever**. The strongest evidence (Cursor A/B: +12.5% accuracy; Augment Code: +30–80% on PR quality benchmarks) shows it helps agents write correct code faster — which *indirectly* reduces tokens by eliminating retry loops and subagent spawning. Don't chase the "97% token reduction" headlines; chase fewer failed attempts. The optimal stack is hybrid: agentic search (grep/ls/read) as backbone, semantic search for concept queries on large repos, structural search (AST/LSP) for symbol navigation, output compression for CLI noise, and prompt caching for cost. Set up only the layers that match your actual pain points.

---

## Decision Framework: Do You Need Semantic Search?

Answer these three questions:

| Question | If YES → | If NO → |
|----------|----------|---------|
| **Is your codebase >1000 files?** | Semantic search has proven value (Cursor: 2.6% code retention lift on large repos vs 0.3% baseline) | Agentic search (grep) is sufficient; skip the complexity |
| **Do you frequently ask concept queries?** ("where is auth handled?", "how does caching work here?") | Semantic search excels — these can't be grepped | If your queries are keyword-precise ("find function `parseConfig`"), grep wins |
| **Are you using Claude Code / API and paying per token?** | The indirect savings (fewer retries) are real; worth the setup | On flat-rate plans (Max $100–200/mo), the cost math matters less — focus on quality |

**If you answered NO to all three: stop here.** You don't need semantic search. Use grep, invest in good `AGENTS.md` files, and move on.

---

## The Practitioner Stack (Ranked by Impact-to-Effort)

### Tier 1: Do These First (High Impact, Low Effort)

#### 1. Enable Prompt Caching
- **What**: Anthropic and OpenAI cache repeated system prompts at 90% discount (cache reads = $0.50/M vs $5/M on Opus 4.5).
- **How**: Happens automatically on Anthropic for prompts >1024 tokens that share a prefix. For API users, structure prompts with static content first.
- **Impact**: This is the single biggest cost lever. GrepAI's benchmark showed cache reads dominated cost structure — $4.92 total with 7.7M cache read tokens at $0.50/M.
- **Effort**: Zero. It's automatic on Claude Code / Cursor.

#### 2. Output Compression (RTK or Equivalent)
- **What**: Filter noisy CLI output (test results, git log, build output) before it enters the LLM context window.
- **Tool**: [RTK](https://github.com/rtk-ai/rtk) — Rust CLI proxy. Wrap commands: `rtk cargo test` instead of `cargo test`.
- **Impact**: 60–90% output token reduction. Real-world: 10.2M tokens saved over 2 weeks (89.2% reduction). `cargo test`: 155 lines → 3 lines (-98%).
- **Effort**: Low. `cargo install rtk`, prefix commands. Claude Code can be configured to use it via AGENTS.md instructions or custom tool aliases.
- **Why first**: Output tokens are expensive ($25/M on Opus 4.5). This targets the most expensive token category with zero retrieval quality risk.

#### 3. MCP Tool Search (If Using Multiple MCP Servers)
- **What**: Claude Code 2.1.7+ lazy-loads MCP tool definitions instead of stuffing all into context upfront.
- **Impact**: 95% reduction in MCP overhead. One user went from 39.8K tokens (19.9% of context) → ~5K tokens (2.5%). Available context jumped from 92K to 195K tokens.
- **Effort**: Zero — automatic when MCP tools exceed 10% of context window. Ensure your MCP servers have good `serverInstructions` for accurate tool discovery.
- **Why it matters**: If you're running 5+ MCP servers, this alone reclaims 30–50% of your usable context window.

#### 4. Use `/compact` Proactively
- **What**: Claude Code's built-in context compression. Summarizes conversation history.
- **When**: After 10–15 messages, or when `/cost` shows >5M tokens.
- **Impact**: Prevents context rot — the empirically proven degradation in LLM performance as context grows (Chroma research, Jul 2025). Anthropic showed context editing reduced token consumption by 84% in 100-turn evaluations.
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
- **When to add**: If you work in statically-typed languages (TypeScript, Go, Rust, Java) and frequently navigate cross-file relationships. This is the **most underutilized layer** in the stack.

#### 6. Semantic Search via MCP (For Large/Unfamiliar Codebases)
- **What**: Embedding-based code search that understands concepts, not just keywords.
- **Tools (pick one based on your constraints)**:

| Tool | Embedding | Privacy | Setup | Best For |
|------|-----------|---------|-------|----------|
| **[Augment Code Context Engine](https://docs.augmentcode.com/context-services/mcp/overview)** | Proprietary (trained on code) | Remote (code sent to Augment) | 2 min, MCP | Best quality — 30–80% improvement on PR benchmarks. 1000 free requests/mo. **Current best option if privacy allows.** |
| **[claude-context (Zilliz)](https://github.com/zilliztech/claude-context)** | Generic + hybrid (BM25+dense) | Remote (Milvus Cloud) or local | Moderate | Agent-agnostic, AST-aware chunking. Good if you already use Milvus. |
| **[GrepAI](https://github.com/yoan-bernabeu/grepai)** | Local via Ollama | Fully local | `grepai index`, then use | Privacy-first. Good for solo devs. Generic embeddings = lower quality than Augment/Cursor. |
| **[CodeGrok](https://github.com/rdondeti/CodeGrok_mcp)** | Local (AST + vectors) | Fully local | Moderate | AST-aware chunking + local embeddings. Newer, less battle-tested. |

- **When to add**:
  - Codebase >1000 files (Cursor data: this is where semantic search measurably improves quality)
  - Onboarding to unfamiliar repos
  - Cross-cutting concept queries that grep can't handle
  - Multi-repo work (Augment's remote mode shines here)

- **When NOT to add**:
  - Small codebases (<50 files) — agentic search is sufficient
  - Rapidly changing code with frequent conflicts — index staleness will hurt you
  - Single-session exploratory work — index setup cost exceeds savings

- **Critical quality note**: Generic embeddings (GrepAI, most open-source tools) have a "similarity ≠ relevance" problem. A test file for authentication is semantically similar to the auth implementation — but you probably want the implementation. Purpose-trained embeddings (Augment, Cursor) handle this better. If using generic embeddings, combine with keyword filters to improve precision.

### Tier 3: Strategic / Org-Level (High Impact, High Effort)

#### 7. Self-Route Hybrid Retrieval
- **What**: Let the LLM decide whether a semantic search result is sufficient, or whether it needs full agentic exploration. Based on Li et al. (EMNLP 2024) "Self-Route" approach.
- **Impact**: 39–65% cost reduction while maintaining full-context accuracy on hard queries.
- **How to approximate today**: In your AGENTS.md or system prompt, instruct the agent to try semantic search first for concept queries, fall back to grep/read for precise queries, and escalate to full exploration only when initial retrieval is insufficient.
- **This is where the field is heading**: Cursor already does this implicitly (their agent uses both grep and semantic search). The explicit routing layer will likely become a standard agent architecture pattern in 2026.

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

---

## Cost Reality Check (Feb 2026 Pricing)

For practitioners doing mental math on whether optimization is worth it:

| Model | Input | Cache Read | Output | Cache Write (5min) |
|-------|-------|------------|--------|-------------------|
| Claude Opus 4.5 | $5/M | $0.50/M | $25/M | $6.25/M |
| Claude Sonnet 4.5 | $3/M | $0.30/M | $15/M | $3.75/M |
| Claude Haiku 4 | $1/M | $0.10/M | $5/M | $1.25/M |

**Key insight**: Output tokens cost 5× input tokens. This means:
- Output compression (RTK) has 5× the dollar impact per token saved vs. input compression (semantic search)
- A single verbose test output (say 50K tokens) costs $1.25 on Opus 4.5 output pricing
- That same 50K through RTK → 5K tokens = $0.125. Savings: $1.125 from one command

**For Max plan users** ($100–200/mo flat rate): Token optimization matters less for cost, but context window efficiency still matters for quality. Context rot is pricing-independent.

**Falling prices trajectory**: Opus went from $15/$75 (4.0) → $5/$25 (4.5) — a 67% drop. If this continues, the cost argument for semantic search weakens further. The quality argument is durable.

---

## Implementation Priority by Persona

### Solo Developer on Claude Code (API)
1. RTK output compression → immediate savings
2. `/compact` habit → prevent context rot
3. Good AGENTS.md files → give the agent map knowledge instead of exploration
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

The convergence of Cursor (invested in semantic search) and Anthropic (abandoned it as primary) agreeing that **hybrid is best** is the highest-confidence signal — their opposing commercial incentives make their agreement especially trustworthy.
