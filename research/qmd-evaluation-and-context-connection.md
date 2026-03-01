← [Coding Agents](../topics/coding-agents.md) · [Dev Tools](../topics/dev-tools.md) · [Index](../README.md)

# QMD: Critical Evaluation & Strategic Context

*February 28, 2026 · Source code review, changelog analysis, competitor research, connected to prior research on context engineering, harness leverage, CLI vs MCP, and search APIs.*

---

## I. What QMD Is

QMD (Query Markup Documents) is an on-device hybrid search engine for markdown files, built by **Tobi Lütke** — CEO of Shopify. It indexes local markdown collections (notes, meeting transcripts, docs, knowledge bases) and provides three search modes:

1. **BM25 full-text search** — SQLite FTS5, fast keyword matching
2. **Vector semantic search** — embeddinggemma-300M via node-llama-cpp, cosine similarity via sqlite-vec
3. **Hybrid query** — query expansion (fine-tuned Qwen3-1.7B) → parallel BM25+vector → Reciprocal Rank Fusion → LLM reranking (Qwen3-reranker-0.6B) → position-aware blending

~9,700 lines of TypeScript. SQLite as the sole data store. Three GGUF models (~2GB total) auto-downloaded and run locally via node-llama-cpp. MCP server (stdio + HTTP daemon). CLI with multiple output formats (JSON, CSV, XML, Markdown, files list) designed for agent consumption.

**First commit:** December 7, 2025. **Current version:** 1.1.0 (Feb 20, 2026). **295 commits in ~12 weeks.** Active development, rapid iteration, ~20 external contributors (igrigorik, sh54, dgilperez, freeman-jiang, Tritlo, vincentkoc, galligan, pcasaretto, openclaw, etc.).

---

## II. What QMD Is Not

QMD is **not** a RAG pipeline for LLMs. It doesn't generate answers. It doesn't chunk-and-stuff context into prompts. It's a *retrieval* tool — it finds documents and returns them. The agent (or human) decides what to do with the results.

This is a crucial distinction. Most "AI search" tools are RAG systems that own the full loop: chunk → embed → retrieve → generate. QMD stops at retrieval and gives the caller structured results. The caller is expected to be an LLM agent that can decide which results to `qmd get` for full content.

---

## III. Architecture Assessment

### What's Genuinely Good

**1. The hybrid pipeline is state-of-the-art for on-device retrieval.**

The three-stage pipeline (query expansion → dual retrieval → RRF fusion → LLM reranking) is the architecture that information retrieval research has converged on. QMD implements it cleanly:

- **Query expansion** via a *fine-tuned* small model (not prompted, not off-the-shelf). Lütke trained a Qwen3-1.7B with SFT on ~2,290 examples, scoring 92% on evaluation with 30/30 "excellent" rated queries. The model produces typed expansions (`lex:`, `vec:`, `hyde:`) that route to different backends — not just paraphrases. The HyDE (Hypothetical Document Embedding) technique is genuinely effective for semantic search and rarely implemented in personal tools.
- **RRF fusion** with position-aware blending. The blending weights (75/25 for top-3, 60/40 for 4-10, 40/60 for 11+) are a thoughtful compromise: trust the retriever for high-confidence results, trust the reranker for ambiguous ones. Top-rank bonuses (+0.05 for #1, +0.02 for #2-3) prevent exact matches from being washed out by expanded queries.
- **Reranking** via Qwen3-reranker-0.6B with parallel contexts, flash attention, right-sized context windows (2048 instead of default 40960 — 17× less memory). Real engineering, not naive model loading.

**2. Smart chunking is better than most.**

The break-point scoring algorithm with squared distance decay is a genuine innovation over naive fixed-size chunking. Code fence protection prevents splitting inside code blocks. The approach is documented, tested, and the math is transparent. Most tools do `text.split('\n\n')` or fixed-token windows with naive overlap. QMD's approach preserves semantic units.

**3. The query document format is novel and well-designed.**

v1.1.0 introduced structured multi-line queries with typed sub-queries:

```
lex: rate limiter algorithm
vec: how does rate limiting work in the API
hyde: The API implements rate limiting using a token bucket algorithm...
```

This gives sophisticated users (and agents) explicit control over which search backends to use. The `expand:` shortcut preserves simplicity for casual use. Lex syntax supports quoted phrases and negation (`"exact phrase" -excluded`). This is a genuine language design contribution to the "how should agents talk to search tools" question.

**4. Context system is the sleeper feature.**

The hierarchical context system (`qmd context add qmd://notes "Personal notes"`) attaches descriptive metadata to collections and paths. Contexts inherit from parent to child (global → collection root → subfolder). When search returns results, the context travels with them — so the LLM gets not just a snippet but a description of *what kind of content this is*.

This directly addresses the "context as precious resource" problem: rather than dumping entire documents into the agent's context window, QMD returns *annotated pointers* — score + title + context + snippet + docid. The agent then selectively retrieves full content via `qmd get #docid`. This is the **lazy discovery pattern** applied to personal knowledge bases.

**5. The MCP HTTP daemon is a real performance win.**

The daemon (`qmd mcp --http --daemon`) keeps models loaded in VRAM across requests. Cold start (model loading) is ~16s; warm queries are ~10s. Contexts auto-dispose after 5 min idle, models stay resident. This is proper resource lifecycle management — not just "start a server."

### What's Weak or Concerning

**1. Model download UX is a cold-start cliff.**

First use downloads ~2GB of GGUF models. No progress indication during download (node-llama-cpp's `resolveModelFile` handles it opaquely). On slow connections, users wait minutes with no feedback. The `qmd embed` step also requires significant time for large collections. This creates a terrible first-5-minutes experience for new users.

**2. Node.js ≥ 22 requirement limits reach.**

Many systems still run Node 18 or 20 LTS. The requirement for 22+ (for native module compatibility with node-llama-cpp and better-sqlite3) excludes users who can't easily upgrade. The Bun alternative helps but adds another decision point.

**3. sqlite-vec is alpha-quality.**

The dependency on `sqlite-vec@0.1.7-alpha.2` means the vector search foundation is explicitly pre-release software. The changelog shows multiple bugs related to sqlite-vec (hanging queries, extension loading failures, macOS compatibility). This is the most fragile part of the stack.

**4. The fine-tuning pipeline is impressive but creates maintenance burden.**

The custom query expansion model (`qmd-query-expansion-1.7B`) is trained and hosted by Lütke on HuggingFace. This means:
- A single person controls the most critical ML component
- The model can't be improved by users without ML expertise
- If the HuggingFace repo goes down, new installations break
- The reward function is rule-based (no LLM judge) — good for reproducibility, but limits quality ceiling

**5. No incremental embedding.**

When documents change, `qmd embed` currently requires re-embedding from scratch or manual `qmd embed -f`. There's no file-watcher or git-hook-triggered incremental update. For large collections, this means manual intervention to keep vectors current.

---

## IV. Competitive Landscape: QMD's "Friends"

QMD occupies a specific niche: **on-device hybrid search over markdown files, optimized for agent consumption**. The competitive landscape splits into several categories:

### A. Direct Competitors (Local Knowledge Base Search)

| Tool | Language | Approach | Agent-Oriented? | On-Device LLM? |
|------|----------|----------|-----------------|-----------------|
| **QMD** | TypeScript | BM25 + Vector + Reranker (GGUF) | Yes (CLI + MCP) | Yes |
| **Khoj** | Python | RAG chatbot, vector search, web search | Partially (API) | Optional (Ollama) |
| **Obsidian Copilot** | TypeScript | Obsidian plugin, vector search | No (app-locked) | No (API-only) |
| **Marksman** | Rust | BM25 only, fast grep | No | No |
| **ripgrep + fzf** | Rust/Go | Regex search | No | No |
| **Kiro Knowledge Bases** | Proprietary | Semantic index, per-agent | Yes | No (cloud models) |

**Khoj** (github.com/khoj-ai/khoj, ~20K stars) is QMD's closest competitor. It's a full RAG pipeline that indexes multiple file types (markdown, org, PDF, images), supports web search, and generates answers. Key differences:
- Khoj is a **chatbot** (generates answers). QMD is a **search engine** (returns results).
- Khoj uses cloud APIs (OpenAI, Anthropic) or Ollama. QMD uses fully local GGUF models via node-llama-cpp.
- Khoj has a web UI and mobile app. QMD is CLI + MCP only.
- Khoj is heavier (Python, multiple services). QMD is a single binary equivalent (one SQLite file, one process).

**QMD's advantage over Khoj for coding agents:** QMD is designed to be *called by* an agent, not to *be* an agent. This is the right abstraction. A coding agent doesn't want another chatbot answering questions about your notes — it wants a search tool that returns ranked results it can incorporate into its own reasoning. QMD's structured output formats (JSON, files, XML) and CLI interface fit the [CLI > MCP pattern](../research/agent-skills-emerging-winners.md) that's converging across the industry.

**Kiro's Knowledge Bases** are the enterprise equivalent — semantic indexes scoped to custom agents, supporting millions of tokens, with auto-update. But they're cloud-only, Kiro-locked, and behind an experimental flag. QMD runs locally, works with any agent, and is production-ready today.

### B. Adjacent Tools (Components QMD Bundles)

| Component | Standalone Alternative | QMD's Approach |
|-----------|----------------------|----------------|
| Full-text search | Typesense, Meilisearch, tantivy | SQLite FTS5 (embedded, zero infra) |
| Vector search | Chroma, LanceDB, Qdrant | sqlite-vec (embedded, alpha) |
| Embeddings | Ollama, llamafile, vLLM | node-llama-cpp (embedded) |
| Reranking | Cohere API, Jina Reranker | node-llama-cpp + Qwen3-reranker (local) |

The key architectural decision is **embedding everything into one process**. No Docker, no servers, no API keys, no network calls. This is simultaneously QMD's biggest strength (zero-infra setup) and its constraint (limited to what runs on your hardware, bound by sqlite-vec's alpha quality).

### C. The "Just Use grep" Baseline

For small collections (<100 files), `rg "query" ~/notes` + `fzf` is faster, simpler, and more reliable than QMD. No model downloads, no embedding, no SQLite. This is the floor QMD must demonstrably beat.

QMD's value over grep emerges at scale and with semantic queries:
- "How to deploy" finds docs about "deployment," "shipping," "releasing" — synonyms grep misses
- Cross-collection search with context annotation
- Score-based relevance ranking (grep returns all matches, equally weighted)
- Structured output for agent consumption

The breakeven point is probably ~200+ markdown files with enough semantic diversity that keyword matching fails regularly.

---

## V. Connection to Prior Research

### 1. Context as Precious Resource

Your research on [context engineering](context-engineering-kiro-cli-v2.md) and the [harness leverage review](harness-leverage-critical-review-feb28-2026.md) establishes the core principle: **context window space is the scarcest resource in agent workflows**. Every token spent on irrelevant content is a token not available for reasoning.

QMD directly implements this principle through **lazy, scored retrieval**:
- `qmd search` returns ~5 results with title + context + snippet + score (~100-300 tokens)
- Agent reads results, decides which to retrieve in full
- `qmd get #docid` retrieves one document at a time
- Total token cost: ~300 tokens for discovery + N × document_size for selected retrievals

Compare this to the naive approach (dump all notes into context): a 500-document knowledge base at ~2,000 tokens/doc = 1M tokens = impossible even in a 1M-token context window without massive quality degradation.

**QMD is the knowledge-base-specific implementation of the CLI lazy discovery pattern** your [MCP-vs-CLI research](hn-mcp-cheaper-via-cli.md) identified: "The less you load upfront, the better." The MCP daemon adds a `--files` output format that returns just `docid,score,filepath,context` — the absolute minimum for an agent to decide what to read next. This is analogous to `--help` in the CLI-vs-MCP framing: metadata first, content on demand.

### 2. The Harness Engineering Connection

Your [harness engineering playbook](harness-engineering-playbook.md) identifies the hierarchy of leverage: feedback loops > context engineering > tool access > model choice. QMD occupies the **context engineering** layer — it's a tool that improves what the agent sees, not what the agent does.

The [harness leverage review](harness-leverage-critical-review-feb28-2026.md) identifies a key tension: "If writing code was never the bottleneck, then making code generation faster is optimizing a non-bottleneck." This applies to QMD too: **if the agent's bottleneck is validation/verification, then better search over notes is optimizing a non-bottleneck.** QMD is most valuable when the agent's bottleneck is *knowledge retrieval* — finding the right meeting note, the right design doc, the right prior decision. For coding agents working on well-documented projects, this is a real bottleneck. For agents writing new greenfield code, it may not be.

**QMD fits the "Tiered Context" pattern** your research identified as converging across Codex, Kiro, and OpenClaw. OpenClaw specifically uses QMD in its tiered memory architecture: session transcripts → daily logs → MEMORY.md → **QMD hybrid search**. This is noted in your [coding agents topic page](../topics/coding-agents.md). QMD is the cold-storage retrieval layer in a multi-tier memory system.

### 3. CLI > MCP — QMD Does Both, But CLI Wins

Your [agent skills research](agent-skills-emerging-winners.md) documents the convergence toward CLI + Skills over MCP:
- CLI: 4-35× less context consumption
- CLI: composable with pipes, grep, jq
- CLI: models trained on shell commands

QMD supports both CLI and MCP. The CLI path is clearly superior for coding agents:

```bash
# CLI: ~200 tokens to discover, ~50 tokens per result
qmd search "auth config" --json -n 5

# CLI: agent can pipe, filter, compose
qmd search "auth" --files --min-score 0.5 | head -3

# MCP: full schema injection + structured response = more tokens
# but MCP is useful for Claude Desktop, non-terminal agents
```

The MCP server is a smart hedge — it captures agents that don't have shell access (Claude Desktop, Cursor). But the CLI is where QMD's design shines: `--files` output, `--min-score` filtering, `--json` for structured parsing, pipe-friendliness. This aligns perfectly with the CLI lazy discovery pattern.

**The HTTP daemon bridges the gap intelligently.** By keeping models warm in VRAM and serving stateless queries, the daemon gives MCP clients CLI-like latency without the per-invocation model-loading penalty. This is a practical engineering solution to MCP's main disadvantage (cold-start overhead per tool invocation).

### 4. Search API Comparison

Your [search API evaluation](search-api-evaluation.md) assessed external search APIs for coding agents. QMD is the **local complement** to those external APIs:

| Need | External API | QMD |
|------|-------------|-----|
| Web documentation | Brave, Serper, Tavily | ✗ |
| Your personal notes | ✗ | ✓ |
| Meeting transcripts | ✗ | ✓ |
| Private project docs | ✗ | ✓ |
| Zero-cost queries | Limited free tiers | Unlimited (local compute) |
| Latency | 300-1000ms (network) | ~100ms BM25, ~10s hybrid (local) |
| Privacy | Data leaves device | Everything stays local |

QMD fills the exact gap your search API research identified: "For coding agents specifically, obscure library documentation, niche framework APIs, or very recent package releases" — and extends it to private knowledge. External APIs search the public web. QMD searches your private markdown corpus. Together, they cover the full spectrum.

### 5. RTK / Output Trimming Connection

Your research on CLI output management touches on a related problem: how to prevent tool output from overwhelming the context window. QMD's output design directly addresses this:

- **`--files` format**: `docid,score,filepath,context` — minimal footprint for discovery
- **`--min-score` filtering**: agent controls how much comes back
- **`-n` limit**: explicit result count cap
- **`-l` line limit on `qmd get`**: truncate long documents
- **`--max-bytes` on `multi-get`**: skip files larger than threshold
- **Snippet extraction**: returns context around the match, not the full document
- **Score-based color coding** (>70% green, >40% yellow, dim otherwise): visual signal even in raw terminal output

This is **output trimming built into the tool itself** — the tool respects the caller's context budget instead of dumping everything. This is the right design for agent-oriented tools. Compare with a naive `grep -r` that returns every match regardless of relevance or volume.

---

## VI. The Tobi Lütke Factor

The author matters. Tobi Lütke is:
- CEO of Shopify (a $100B+ company)
- One of the most prominent public advocates for AI coding agents
- The person who coined "reflexive competence" and pushed Shopify to mandate AI fluency
- Running this as a personal project, not a Shopify product

This means:
- **High credibility** — Lütke is a sophisticated engineer who actually uses what he builds
- **Community gravity** — OpenClaw (180K+ stars) already integrates QMD as its memory layer
- **But also: bus factor = 1** for the fine-tuned model, architecture decisions, and direction
- **No company backing** — if Lütke loses interest, the project stalls (though external contributors are growing)

The changelog shows Ilya Grigorik (former Google performance engineer, now at Shopify) as a significant contributor (#149 — MCP HTTP transport, type-routed expansion, pipeline unification). This is not a casual hobby project.

---

## VII. Strategic Assessment

### Where QMD Wins Decisively

1. **Personal knowledge bases for coding agents** — nothing else combines hybrid search + local LLMs + CLI + MCP + agent-oriented output formats in a single zero-infra package.
2. **Privacy-sensitive workflows** — everything stays on-device. No API keys, no data exfiltration, no vendor lock-in for the search layer.
3. **OpenClaw/Pi ecosystem** — QMD is the canonical memory layer for the most popular open-source agent. Network effects compound.
4. **The query document format** — gives agents explicit control over search strategy. No other personal search tool has this.

### Where QMD Is Vulnerable

1. **Model-harness co-training** — if Claude Code or Codex build their own knowledge base search (trained into the model), QMD's independent-tool approach loses the co-optimization advantage. Kiro's Knowledge Bases are the early signal here.
2. **Apple Intelligence integration** — if Apple builds semantic search over Notes/Files into macOS (likely, given Apple Intelligence trajectory), the "search your local markdown" use case gets a system-level competitor with zero setup cost.
3. **sqlite-vec instability** — the alpha-quality vector extension is a single point of failure. If it doesn't mature, QMD's vector search is on shaky ground.
4. **Cold start UX** — 2GB model download + embedding time makes first use painful. Most users who try QMD will evaluate it during this painful first 10 minutes.
5. **Scale ceiling** — node-llama-cpp on consumer hardware limits concurrent operations. A user with 10,000+ documents and frequent queries may hit performance walls.

### What QMD Should Be Watched For

1. **Incremental embedding** (file-watcher or git-hook triggered) — would remove the biggest operational friction
2. **Smaller/faster models** — the LFM2-1.2B experiment in the finetune directory suggests Lütke is exploring alternatives
3. **Structured extraction** — currently markdown-only; PDF/org-mode support would expand the addressable knowledge
4. **Cross-agent adoption** — if Kiro, Codex, or Gemini CLI add QMD integration beyond OpenClaw, it becomes infrastructure

---

## VIII. Verdict

**QMD is the best on-device knowledge retrieval tool for AI coding agents as of February 2026.** Not because it's perfect — sqlite-vec is alpha, cold start is painful, and the bus factor is concerning — but because nothing else combines:

- Hybrid search (BM25 + vector + reranker) running *entirely locally*
- A fine-tuned query expansion model producing typed sub-queries
- CLI + MCP dual interface with agent-optimized output formats
- Hierarchical context annotations that travel with search results
- Smart chunking that respects markdown structure

It fills a **specific, validated gap** in the agent tooling stack: private knowledge retrieval with minimal context window cost. Your prior research on [context engineering](context-engineering-kiro-cli-v2.md), [CLI vs MCP](hn-mcp-cheaper-via-cli.md), and [harness leverage](harness-leverage-critical-review-feb28-2026.md) all point to exactly the kind of tool QMD is — lazy discovery, scored retrieval, structured output, caller-controlled context budget.

The most interesting long-term question is whether **QMD's query document format** becomes a standard. The `lex:/vec:/hyde:` typed sub-query pattern is the first serious attempt at giving agents a *search language* rather than just a search box. If this pattern spreads beyond QMD, Lütke will have contributed something more lasting than the tool itself.

**For your setup (Pi + terminal-native workflow):** QMD is the natural knowledge layer. Install it, index your notes, add it as a Pi skill. The CLI interface fits Pi's bash-first philosophy. The token efficiency aligns with your context-as-precious-resource principle. The zero-infrastructure design matches Pi's "build it yourself" ethos.

---

## Sources

| Source | Type | Key Contribution |
|--------|------|-----------------|
| [QMD GitHub](https://github.com/tobi/qmd) | Primary (source code) | Architecture, implementation, changelog |
| [QMD npm](https://www.npmjs.com/package/@tobilu/qmd) | Primary | Version history, download stats |
| [Khoj](https://github.com/khoj-ai/khoj) | Competitor | RAG chatbot comparison |
| [HyDE paper](https://arxiv.org/abs/2212.10496) | Academic | Hypothetical document embedding technique |
| [node-llama-cpp](https://node-llama-cpp.withcat.ai/) | Dependency | GGUF model runtime, lifecycle management |
| [sqlite-vec](https://github.com/asg017/sqlite-vec) | Dependency | Vector similarity search extension |
| Prior research: [Context Engineering](context-engineering-kiro-cli-v2.md) | Own | Context window management framework |
| Prior research: [Harness Leverage](harness-leverage-critical-review-feb28-2026.md) | Own | Harness engineering thesis, productivity evidence |
| Prior research: [CLI vs MCP](hn-mcp-cheaper-via-cli.md) | Own | Lazy discovery, token efficiency |
| Prior research: [Search APIs](search-api-evaluation.md) | Own | External search API landscape |
| Prior research: [Agent Skills](agent-skills-emerging-winners.md) | Own | CLI + Skills convergence pattern |
