# Semantic Search + LLM to Save Tokens: Evidence, Counter-Evidence, and Critical Evaluation

**Date**: 2026-02-28

---

## 0. The Claim Under Examination

"Using semantic search (embeddings + vector DB) to retrieve relevant code/context for an LLM, instead of letting the LLM brute-force explore via grep/read, dramatically reduces token consumption."

This is a specific, testable claim that sits at the intersection of three active debates: RAG vs long context, agentic search vs indexed retrieval, and context engineering as a discipline.

**Key thesis (TL;DR)**: The strongest evidence for semantic search is about **quality, not cost**. The headline token-savings numbers (97% reduction!) are cherry-picked metrics that don't reflect total cost. Cursor's A/B-tested 12.5% accuracy improvement is the most important finding. The optimal architecture is hybrid — agentic search as backbone, semantic search as supplement for concept queries on large repos. The real savings come indirectly: better first-pass retrieval → fewer retry loops → shorter task completion paths.

---

## 1. The Evidence FOR Semantic Search Saving Tokens

### 1.1 GrepAI Benchmark (Yoan Bernabeu, Jan 2026) — The Strongest Quantitative Claim

**Source**: Controlled benchmark on Excalidraw codebase (155K lines TypeScript), 5 identical developer questions, published methodology. Benchmark used **Claude Opus 4.5 pricing** ($5/M input, $6.25/M cache creation, $0.50/M cache read, $25/M output).

| Metric | Baseline (grep) | GrepAI (semantic) | Change |
|--------|-----------------|-------------------|--------|
| Input tokens | 51,147 | 1,326 | **-97%** |
| Cache creation tokens | 563,883 | 162,289 | -71% |
| Cache read tokens | 5,973,161 | 7,775,888 | +30% |
| Total API cost | $6.78 | $4.92 | **-27.5%** |
| Tool calls | 139 | 62 | -55% |
| Subagents spawned | 5 | 0 | -100% |

**Critical evaluation**:
- The 97% input token reduction is real but misleading in isolation. The actual *cost* savings was only 27.5% because cache reads (cheap at $0.50/M) increased 30%. The headline "97% token reduction" describes only one token category. **Note**: these cost ratios are specific to Opus 4.5's pricing tiers — on models with different cache pricing structures, the cost savings percentage would differ.
- **The benchmark was conducted by the tool's maintainer**. He discloses this honestly, but it's still a conflict of interest. No independent replication exists.
- 5 questions on 1 codebase is a thin sample. The questions were specifically *semantic* queries ("find the algorithm for smoothing freedraw lines") — exactly where semantic search excels. Keyword-precise queries ("find the function `simplifyPath`") would likely show less advantage.
- The biggest cost driver was **subagent elimination** ($2.51 of the $1.86 savings came from avoiding cache creation for subagent contexts). This is a real insight: semantic search's main token win isn't fewer input tokens per se, but *shorter exploration chains* that avoid spawning expensive subagents.

**Verdict**: Directionally valid. The mechanism (shorter search chains → fewer subagents → less cache creation) is sound. The magnitude is overstated by the headline metric.

### 1.2 Cursor's Semantic Search Evaluation (Nov 2025) — The Most Credible Evidence

**Source**: Cursor team blog post, based on internal benchmark ("Cursor Context Bench") and online A/B test across production users.

**Results**:
- **12.5% higher accuracy** on average (6.5%–23.5% depending on model) when semantic search is available
- **0.3% improvement in code retention** (code written by agent stays in codebase); rises to **2.6% on large codebases (1000+ files)**
- **2.2% reduction in dissatisfied user follow-up requests** when semantic search is available

**Critical evaluation**:
- This is **the most credible evidence** in the entire landscape. Cursor has millions of users, runs actual A/B tests, and trained a custom embedding model using agent session traces as training data.
- Crucially, **Cursor frames this as accuracy improvement, not primarily token savings**. Their key finding is "semantic search is currently necessary to achieve the best results, especially in large codebases." They don't headline token savings because that's secondary to the quality improvement.
- The 12.5% accuracy improvement is an average across all models tested, on their internal benchmark. This is a meaningful effect size for a single tool addition. However, the **range is wide (6.5%–23.5%)** — suggesting the benefit is model-dependent. If the weakest models benefit most (needing more retrieval help), that's a different story than if the strongest benefit most (semantic search providing a quality floor). Cursor's blog does not fully decompose which models land where in the range.
- However, Cursor's model combines grep *and* semantic search: "Our agent makes heavy use of grep as well as semantic search, and the combination of these two leads to the best outcomes." This is a **hybrid approach**, not pure semantic search replacing grep.

**Verdict**: Semantic search improves agent quality and likely reduces token waste from exploration loops, but Cursor's evidence positions it as a quality lever, not primarily a cost lever. The strongest signal is on large codebases.

### 1.3 Zilliz/Claude Context MCP (2025-2026) — Infrastructure Play

**Source**: Zilliz (Milvus vector DB company) open-sourced `claude-context`, an MCP plugin providing semantic code search via embeddings + Milvus.

**Claims**: "Instead of loading entire directories into Claude for every request, which can be very expensive, Claude Context efficiently stores your codebase in a vector database and only uses related code in context."

**Critical evaluation**:
- No published benchmarks from Zilliz themselves — the claims are architectural, not empirical.
- Zilliz has an obvious commercial interest (they sell vector DB hosting).
- The tool uses AST-aware chunking and hybrid search (semantic + keyword), which is technically sound.
- Compatible with Claude Code, Cursor, Gemini CLI, OpenCode, Qwen Code — shows the MCP approach is agent-agnostic.

**Verdict**: Plausible architecture, no hard evidence on token savings. The business model (free vector DB hosting → cloud upgrades) creates incentive to promote this approach regardless of efficacy.

### 1.4 Academic Evidence: RAG vs Long Context (Li et al., EMNLP 2024)

**Source**: Li, Zhuowan et al. (Google DeepMind), "Retrieval Augmented Generation or Long-Context LLMs? A Comprehensive Study and Hybrid Approach," EMNLP 2024 Industry Track. [arXiv:2407.16833](https://arxiv.org/abs/2407.16833)

**Key findings**:
- **LC consistently outperforms RAG in average accuracy** when resources are sufficient
- **RAG's significantly lower cost remains a distinct advantage** — RAG reduces input length (and thus cost) substantially
- For 60%+ of queries, RAG and LC produce identical answers — for those queries, RAG saves cost without quality loss
- Their hybrid "Self-Route" method reduces cost by 65% (Gemini-1.5-Pro) / 39% (GPT-4) while maintaining LC-comparable performance

**Critical evaluation**:
- This is rigorous academic work (EMNLP 2024, peer-reviewed), but tests general QA tasks, not code search specifically.
- The finding that LC outperforms RAG is important context: when you can afford to stuff everything into context, the LLM does better. RAG wins on *cost*, not *quality*. This is also evidence *against* semantic search as a quality optimization — placing this in the "FOR" section reflects only the cost dimension.
- The Self-Route approach is elegant: use the LLM itself to decide whether RAG's retrieval was sufficient, or whether full context is needed. This is the strongest academic support for the hybrid consensus.

**Verdict**: Strong evidence that RAG saves tokens/cost, but at a quality penalty for the hardest queries. The hybrid routing approach is likely the optimal strategy. The paper is ultimately evidence for the **hybrid** synthesis (§3), not for semantic search per se.

---

## 2. The Evidence AGAINST Semantic Search (or Complicating It)

### 2.1 Boris Cherny / Anthropic: "We Dropped RAG for Agentic Search" (Feb 2026)

**Source**: Boris Cherny, **Head of Claude Code** at Anthropic (and described in multiple sources as its founder/creator), [X post](https://x.com/bcherny/status/2017824286489383315). Further context from his Feb 2026 appearance on Lenny's Podcast.

> "Early versions of Claude Code used RAG + a local vector db, but we found pretty quickly that agentic search generally works better. It is also simpler and doesn't have the same issues around security, privacy, staleness, and reliability."

**Critical evaluation**:
- This is **the most authoritative counter-evidence**. The product leader who built Claude Code *tried* semantic search and *abandoned* it. They have millions of users and deep telemetry on what works. (Note: Boris is not a random engineer — he heads the product and reportedly hasn't manually edited code since Nov 2025, shipping 10-30 PRs/day via Claude Code itself.)
- The reasons are pragmatic, not theoretical:
  1. **Staleness**: Code changes constantly. Indexes go stale between edits. Re-indexing is expensive and complex.
  2. **Security/Privacy**: Embeddings must be computed somewhere. Local = slow; cloud = data leaves machine.
  3. **Reliability**: Chunking/embedding quality varies. Bad chunks → bad retrieval → worse than grep.
  4. **Simplicity**: Agentic search (grep/ls/read loops) requires zero setup, zero infrastructure.
- **Key nuance**: Boris said "generally works better" — not "always." SmartScope's analysis notes that RAG still wins for concept search, huge repos, and cross-cutting exploration.
- **Important context on incentives** (applies symmetrically across all sources): Anthropic sells tokens, so they may prefer higher-token approaches. Cursor invested heavily in building semantic search infrastructure, so they're motivated to show it works. GrepAI's maintainer benchmarked his own tool. Every major source has a conflict of interest. The strongest guard against this is convergent evidence from parties with *opposing* incentives — which is why the Cursor + Anthropic convergence on "hybrid is best" is particularly credible, since their commercial incentives pull in opposite directions.

**Verdict**: Highly credible. Agentic search is the pragmatically superior default for most coding workflows. But this doesn't invalidate semantic search as a supplemental tool — it invalidates it as the *primary* retrieval mechanism for code agents.

### 2.2 Context Rot (Chroma Research, Jul 2025; Anthropic, Sep 2025)

**Sources** (three distinct documents, published in close succession):
1. Chroma's ["Context Rot"](https://research.trychroma.com/context-rot) technical report (Hong, Troynikov, Huber — Jul 2025)
2. Anthropic's ["Effective Context Engineering for AI Agents"](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) (Sep 29, 2025) — the conceptual framework
3. Anthropic's ["Managing context on the Claude Developer Platform"](https://www.anthropic.com/news/context-management) (Sep 29, 2025) — the product announcement with benchmarks

**Key findings**:
- Even on simple tasks, LLM performance degrades as input length increases, "often in surprising and non-uniform ways" (Chroma)
- Needle-in-a-haystack tests show near-perfect scores, but semantic retrieval, disambiguation, and real-world tasks degrade significantly (Chroma)
- "Context must be treated as a finite resource with diminishing marginal returns. LLMs have an 'attention budget' that they draw on when parsing large volumes of context." (Anthropic, Effective Context Engineering)
- Combined approach (memory tool + context editing) improved performance by **39% over baseline**; in a 100-turn web search evaluation, context editing reduced token consumption by **84%** (Anthropic, Managing Context — distinct from the Effective Context Engineering post)

**Critical evaluation**:
- This evidence *supports* some form of context compression (whether via semantic search, output filtering like RTK, or context editing) — but it's agnostic about *which* compression method.
- The attention budget concept means that *even if you can fit everything in the context window*, you probably shouldn't. Less is more.
- This validates both RTK (output compression) and semantic search (input selection) as strategies, but doesn't specifically prove semantic search is the best approach.

**Verdict**: Strong evidence that context curation matters. Neutral on whether semantic search specifically is the right curation method vs alternatives like output filtering, context editing, or smarter agent behavior.

### 2.3 The Staleness Problem Is Real

Multiple sources converge on this:
- **RAGFlow year-end review (Dec 2025)**: "Code changes daily. Indexes are always going stale. Running this correctly requires diff updates, re-chunking, re-embedding, permission boundaries, encryption, auditing."
- **Cursor's response**: They built a Merkle tree system with incremental re-indexing, team index sharing (92% similarity across clones), and async background processing. This is a massive engineering investment — proving the problem is serious enough that a $300M ARR company invested heavily in solving it.
- **GrepAI**: Uses Ollama local embeddings, which means re-indexing happens on your machine. Practical for small-medium codebases, but the cost grows linearly with codebase size.

**Verdict**: Staleness is the primary practical obstacle. It's solvable (Cursor proved it) but the engineering cost is non-trivial. For open-source tools targeting individual developers, this remains a significant barrier.

### 2.4 The "Lost in the Middle" Effect Is Improving

**Source**: Liu et al. 2023 (original paper), plus 2025-2026 model evaluations.

- The original "Lost in the Middle" paper showed LLMs perform worst when relevant info is in the middle of long contexts.
- **But models are improving**: Gemini 2.5 Flash shows near-perfect needle-in-haystack regardless of position. Claude 4.x and GPT-4.1 show similar improvements.
- Chroma's "Context Rot" research shows the simple NIAH task is largely solved, but more complex retrieval still degrades.

**Verdict**: The case for semantic search as a hedge against "lost in the middle" is weakening as models improve, but context rot on complex tasks remains real. The argument is shifting from "models can't handle long context" to "models handle long context less *efficiently* (in attention budget terms)."

### 2.5 The Latency Dimension

A practical factor absent from most comparisons: semantic search adds **wall-clock latency** to every retrieval step.

- **grep**: Essentially instant on local filesystems. Zero setup, zero network round-trips.
- **Semantic search (local, e.g., GrepAI + Ollama)**: Embedding computation for the query + HNSW vector similarity scan. Typically 200-800ms per query depending on index size and hardware.
- **Semantic search (remote, e.g., Cursor, Zilliz Cloud)**: Network round-trip added. Cursor mitigates this with background indexing and cached embeddings, but cold-start on new codebases can take minutes to hours.

For interactive coding sessions where a developer is waiting, even 500ms of added latency per search step compounds across a multi-tool exploration chain. This is one pragmatic reason agentic search (grep) feels snappier despite using more tokens.

**Verdict**: Latency is an underappreciated practical cost of semantic search that doesn't show up in token or dollar metrics but directly affects user experience.

### 2.6 The "Similarity ≠ Relevance" Critique

**Source**: TigerData (Timescale), "Why Cursor is About to Ditch Vector Search (and You Should Too)" (Jul 2025)

**Core argument**: Embedding-based semantic similarity does not equal *relevance* for a code task. A function about "user authentication" is semantically similar to a test for "user authentication," but the developer probably wants the implementation, not the test. Vector cosine similarity can't distinguish intent.

**Critical evaluation**:
- TigerData/Timescale sells structured databases (not vector DBs), so they have a commercial incentive to argue against vector search.
- However, the core point is technically valid. Cursor mitigates this by training a *custom* embedding model on agent session traces — essentially teaching the model what "relevant" means in a coding context, not just "similar." Generic embedding models (like those used by GrepAI/Zilliz) don't have this advantage.
- The prediction that Cursor will "ditch" vector search has not materialized — Cursor doubled down with their Jan 2026 secure indexing infrastructure. The prediction appears wrong, but the underlying critique about similarity ≠ relevance remains important for anyone using off-the-shelf embeddings.

**Verdict**: A valid technical concern for generic embedding models. Less applicable to purpose-trained models like Cursor's. But most open-source semantic search tools use generic embeddings, making this a real quality risk for the ecosystem.

---

## 3. The Synthesis: What Actually Works

### 3.1 The 2026 Consensus: Hybrid + Context Engineering

The SmartScope analysis captures the emerging consensus well:

> "The 2026 practical answer isn't either/or — it's **Agentic as the backbone, with semantic index only where needed, plus context engineering**."

This maps to a layered strategy:

| Layer | Mechanism | When It Wins | Token Impact |
|-------|-----------|-------------|--------------|
| **Agentic search** | grep/ls/read loops | Known patterns, keyword-precise queries, small-medium codebases | Higher tokens, higher accuracy |
| **Semantic search** | Embeddings + vector DB | Concept queries ("where is auth handled?"), huge repos (>100K LOC), cross-cutting concerns | Lower tokens, accuracy depends on index quality |
| **Structural search** | AST/symbol navigation (e.g., Serena MCP, tree-sitter) | Type/function/call-graph queries, cross-file refactoring, statically-typed codebases | Lower tokens, avoids staleness and chunking problems |
| **Output compression** | RTK-style filtering | All CLI output (tests, git, build) | 60-90% output token reduction |
| **Context editing** | Prune stale tool results | Long sessions (>50 turns) | Prevents context rot |
| **Prompt caching** | Anthropic/OpenAI native | Repeated system prompts | 90% cost reduction on cached content |

**Emerging entrant — Augment Code's Context Engine** (Feb 2026): Augment Code released their semantic coding capability as a standalone product for any AI agent (SiliconANGLE, Feb 6 2026). This is a different commercial model from Cursor's integrated approach — a dedicated "semantic understanding" layer that plugs into existing agents. The fact that a well-funded startup is building this as infrastructure (not just an IDE feature) validates the market demand for semantic code search beyond any single IDE.

### 3.2 The Real Question Is: "Tokens Saved" vs "Dollars Saved" vs "Quality Improved"

The three metrics don't correlate as simply as most tools imply:

1. **Input token reduction ≠ cost reduction**: GrepAI showed 97% input token reduction but only 27.5% cost savings, because cache economics dominate.
2. **Token reduction ≠ quality improvement**: Li et al. showed LC (more tokens) outperforms RAG (fewer tokens) on accuracy. Cursor showed semantic search improves accuracy by 12.5% — but they use it *alongside* grep, not instead of.
3. **Quality improvement → indirect token savings**: Better first-pass results mean fewer retry loops, fewer subagents, fewer wasted exploration chains. This is the *real* mechanism by which semantic search saves tokens — not through the direct retrieval step, but through *shorter task completion paths*.

### 3.3 Who Benefits Most from Semantic Search

Based on the evidence, semantic search provides the most token savings when:

| Condition | Why | Evidence |
|-----------|-----|----------|
| **Large codebases (>1000 files)** | Agentic search spawns many subagents; semantic search shortcircuits exploration | Cursor A/B test: 2.6% code retention improvement on large repos vs 0.3% on all |
| **Concept queries** | "Where is auth handled?" can't be grepped for | GrepAI benchmark questions were all semantic |
| **Unfamiliar codebases** | Developer/agent doesn't know file structure | Cursor: onboarding, exploration workflows |
| **Repeated patterns across sessions** | Index amortizes its cost across queries | Cursor: team index sharing, 92% codebase similarity |

And provides minimal benefit when:

| Condition | Why | Evidence |
|-----------|-----|----------|
| **Small codebases (<50 files)** | Agentic search is fast and sufficient | Cursor: effect size near zero on small repos |
| **Keyword-precise queries** | grep is faster and more accurate for exact matches | SmartScope analysis; grep remains in Cursor's agent |
| **Rapidly changing code** | Index staleness introduces wrong results | Boris Cherny's primary objection |
| **Single-session work** | Index setup cost exceeds session savings | GrepAI requires `grepai index` before use |

---

## 4. Forward-Looking Assessment

### 4.1 Short-Term (3-6 months): Hybrid Approaches Win

The winning stack in 2026 is increasingly clear:
- **Agentic search as backbone** (Claude Code's approach)
- **Semantic search as supplement** via MCP (claude-context, GrepAI)
- **Output compression** (RTK-style) for CLI noise reduction
- **Context editing** (Anthropic's built-in) for long sessions

No single approach is sufficient. The tools that compose well with others will win.

### 4.2 Medium-Term (6-18 months): Built-In Semantic Search

- **Cursor already ships it**. Claude Code doesn't yet — though MCP-based tools (claude-context, GrepAI) already provide this in the ecosystem.
- Anthropic's stated position (Boris Cherny) is that agentic search is "generally better" — but this may evolve as models improve at leveraging pre-retrieved context.
- **Prediction**: Anthropic will officially endorse or integrate an MCP-based semantic search tool, rather than building it into the core agent. This lets users opt in without imposing staleness/privacy costs on everyone. The MCP ecosystem already provides this; the question is whether Anthropic curates or recommends a default.

### 4.3 The Token Pricing Trajectory Complicates the Cost Argument

API costs have been **falling consistently** — Anthropic, OpenAI, and Google have all reduced prices multiple times across 2024-2026. If per-token costs continue declining:
- The **economic** argument for semantic search weakens (cheaper tokens → less incentive to optimize consumption)
- The **quality** argument remains stable or strengthens (quality improvements are independent of cost)
- The **latency** argument may strengthen (if tokens are cheap, spending more tokens for faster/simpler agentic search becomes even more attractive)

This reinforces the reframe: **semantic search's lasting value is quality improvement, not cost reduction**. Any analysis anchored to current pricing will age poorly.

### 4.4 Long-Term (18+ months): Context Engineering as a Discipline

- Context windows will continue growing (10M+ tokens), but **context rot means bigger isn't always better**.
- The discipline of "what tokens to put in the window" becomes more important than "how big is the window."
- Semantic search becomes one tool in a broader context engineering toolkit, alongside:
  - Adaptive retrieval (agent decides when to search vs read)
  - Dynamic compression (compress more aggressively as context fills)
  - Memory systems (persistent cross-session knowledge)
  - Speculative retrieval (pre-fetch likely-needed context)

### 4.5 Retrieval Techniques Are Improving

Embedding and retrieval architectures are advancing in ways that could change the quality equation:
- **Late Chunking** (Jina AI, 2024-2025): Contextual chunk embeddings that preserve cross-chunk context, addressing the "over-compression" problem in naive chunking. [arXiv:2409.04701](https://arxiv.org/abs/2409.04701)
- **ColBERT/ColPali-style late interaction models**: Token-level similarity scoring that captures finer semantic granularity than single-vector embeddings. Weaviate and others are productizing this. ([Weaviate overview](https://weaviate.io/blog/late-interaction-overview))
- **Code-specific embeddings**: Cursor's custom model trained on agent session traces is the leading example, but open-source alternatives are emerging (CodeSage, StarEncoder). Most open-source semantic search tools still use generic embeddings — a quality gap that will likely narrow.
- **Hybrid retrieval (BM25 + dense + reranking)**: Combining keyword search, dense embeddings, and cross-encoder reranking is becoming standard in production RAG systems. This is what Zilliz's claude-context and Cursor both do.

These advances mean the quality gap between embedding-based semantic search and brute-force agentic search may narrow over time, making the hybrid approach even more compelling.

### 4.6 The Underappreciated Angle: Quality > Cost

The most important insight from this research is that **the strongest evidence for semantic search is about quality, not cost**.

Cursor's 12.5% accuracy improvement is a bigger deal than GrepAI's 27.5% cost savings. In a world where:
- Claude Code sessions frequently fail and retry (wasting far more tokens than any compression saves)
- The cost of a wrong answer is 3-5x the cost of getting it right the first time
- Developer time is worth far more than API costs

...the right frame is: **"Does semantic search help the agent solve the problem faster and more correctly?"** The answer from Cursor's data is: **yes, measurably, especially on large codebases.**

Token savings are a second-order effect of this quality improvement. When the agent finds the right code on the first try, it doesn't need 5 subagents to explore the wrong files.

---

## 5. Summary Verdict

| Claim | Verdict | Confidence | Key Evidence |
|-------|---------|------------|--------------|
| "Semantic search reduces input tokens by 97%" | **Technically true, practically misleading** | Medium | GrepAI benchmark — true for input tokens only, not total cost |
| "Semantic search saves 27% on API costs" | **Plausible for specific workloads** | Medium | GrepAI benchmark on 155K LOC TypeScript repo, 5 semantic queries |
| "Semantic search improves agent accuracy by 12.5%" | **Credible** | High | Cursor A/B test across production users + benchmark |
| "Semantic search should replace grep" | **No** | High | Cursor uses both; Boris Cherny abandoned pure RAG |
| "Semantic search matters most on large codebases" | **Yes** | High | Cursor: 2.6% retention improvement on 1000+ file repos vs 0.3% baseline |
| "Agentic search is the better default" | **Yes, for code exploration** | High | Boris Cherny (Anthropic), Claude Code production experience |
| "The optimal approach is hybrid" | **Yes** | High | All credible sources converge: Li et al., Cursor, SmartScope, RAGFlow |
| "Context curation matters more than context size" | **Yes** | Very High | Anthropic's context engineering guidance, Chroma context rot research |

**Bottom line**: Semantic search is a validated quality improvement for LLM coding agents — not primarily a token-saving trick. The strongest evidence comes from Cursor (12.5% accuracy boost, A/B tested, range 6.5%–23.5% by model). The token savings are real but secondary, and the headline numbers (97% reduction!) are cherry-picked metrics that don't reflect total cost. As API prices continue falling, the cost argument weakens further while the quality argument persists. The optimal strategy is hybrid: agentic search as backbone + semantic search for concept queries on large repos + structural/AST search for symbol navigation + output compression for CLI noise. The convergent agreement between Cursor (who invested in semantic search) and Anthropic (who abandoned it as primary) that *hybrid is best* is the most credible signal — their opposing commercial incentives make their agreement especially trustworthy. Anyone selling semantic search as a standalone solution to token costs is overpromising; anyone dismissing it entirely is ignoring Cursor's production data.
