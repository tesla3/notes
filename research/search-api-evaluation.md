← [Developer Tools](../topics/dev-tools.md) · [Index](../INDEX.md)

# Search APIs for Coding Agents (Pi, OpenCode, etc.) — Critically Revised Evaluation

*Updated February 2026 — Self-audited for bias, pricing errors, benchmark methodology issues, and missing context*

---

## Self-Critique: What My First Evaluation Got Wrong

Before the revised analysis, here's an honest accounting of the problems in my initial response:

**1. I overstated Brave as a clear winner.** My first pass leaned too heavily on a single benchmark (AIMultiple) and underplayed serious issues: Brave's free tier was killed, its TOS historically prohibited AI inference on the free plan, it has rate-limiting problems at 1 QPS on the free tier that break multi-query coding agents, and its index is materially smaller than Google's — which matters for niche technical documentation lookups that coding agents rely on.

**2. I conflated "search API" and "coding agent search."** A coding agent searching for "how to use go-quartz library cron scheduling" or "pgvector cosine similarity operator" has very different needs than a general RAG chatbot. Most benchmarks test general factual queries, not obscure library documentation lookups. None of the benchmarks I cited test for this.

**3. I under-examined the benchmark methodology.** The AIMultiple benchmark used only 100 AI/LLM-related queries — a narrow domain. It used an LLM judge (not human raters). The confidence intervals for the top 4 APIs overlapped so much that calling any of them "best" is statistically unsupported. The benchmark itself acknowledges this.

**4. I didn't verify pricing firsthand.** Several costs I cited were secondhand and some were outdated. Serper's pricing is credit-based and starts at $1/1K (not $0.30 — that's only at 500K+ volume). Exa's pricing is complex and per-endpoint. Brave just launched a new LLM Context API with different pricing.

**5. I missed key alternatives.** Linkup, Perplexity's sub-400ms Sonar API, DuckDuckGo (free, no API key), and Jina were barely covered. For coding agents specifically, Phind's developer-focused search and Context7 (library docs MCP) are highly relevant and I didn't mention them.

**6. I didn't take Pi's philosophy seriously enough.** Pi's creator explicitly argues against heavyweight search integrations. Pi's design favors a simple `curl` call to any API via bash. The "best" search API for Pi isn't the one with the fanciest SDK — it's the one that returns the most useful result from a one-line shell command.

---

## How Search Actually Works in These Agents

### Pi (shittycodingagent.ai)

Pi ships with exactly four tools: `read`, `write`, `edit`, `bash`. No built-in search. No MCP. This is deliberate — Pi's creator argues that MCP servers dump thousands of tokens into context on every session (e.g., Playwright MCP: 21 tools, 13.7K tokens = 7-9% of your context window wasted). Pi's approach: write a CLI wrapper, give it a README, and the agent reads the README on-demand. Token cost: near zero until actually used.

**Implication for search API choice:** Pi needs an API you can call with `curl` or a tiny script. No SDK required. Clean JSON output matters more than LangChain integration. The agent will parse the result itself.

The **oh-my-pi** fork does add multi-provider search: Exa, Jina, Anthropic, Perplexity, Gemini, and Codex — suggesting the community found bare-bones Pi insufficient for real coding work that needs web lookups.

### OpenCode (opencode.ai)

OpenCode has a built-in `webfetch` tool and full MCP support. It also has a `general` subagent for complex searches. You can plug in any MCP-compatible search server (Brave, Tavily, Exa all have MCP servers). OpenCode's approach is more conventional — it assumes you want search and gives you infrastructure to add it.

### Claude Code

Built-in web search tool. No configuration needed. The quality depends on Anthropic's internal search infrastructure (likely Brave-based, given Brave's claim to power many top LLMs).

---

## The Search APIs — Revised, Warts-and-All Assessment

### Tier 1: Best Quality-to-Cost Ratio for Coding Agents

#### Brave Search API
- **Agent Score:** 14.89 (AIMultiple benchmark, Dec 2025)
- **Latency:** 669ms average (fastest tested)
- **Pricing:** $5/1K requests (Base AI), $9/1K (Pro AI)
- **Index:** Own independent index, 35B+ pages
- **Free tier:** ~$5/month credits (~1,000 queries), credit card required, AI usage allowed

**Strengths:**
- Fastest latency of any tested API — critical for coding agents making multiple sequential searches
- Independent index means no legal risk from Google TOS violations
- New LLM Context API (Feb 2026) returns "smart chunks" optimized for LLM consumption with <130ms overhead
- SOC 2 Type II certified, Zero Data Retention option
- SimpleQA benchmark: 94.1% F1-score with multi-search reasoning

**Real problems I initially underplayed:**
- **Free tier gutted.** Previously 5,000 queries/month free; now ~1,000 with active billing. Credit cards once promised to "never be charged" are now billing instruments. This eroded developer trust.
- **Rate limiting at 1 QPS on free tier.** Coding agents often fire 3-5 searches in rapid succession. At 1 QPS, this causes 429 errors. Multiple open-webui users reported this breaking their workflows. Paid tier (20 QPS) fixes it.
- **Index is smaller than Google's.** For obscure library documentation, niche framework APIs, or very recent package releases, Brave's index may simply not have the page. Google-scraping APIs (Serper) won't have this problem.
- **TOS confusion.** The free "Data for Search" plan historically prohibited AI inference. The "Base AI" plan ($5/1K) explicitly allows it. This confused early adopters who thought they were violating TOS.
- **Brave does NOT return full page content.** It returns structured snippets. If your coding agent needs the full text of a documentation page, you need a separate fetch/scrape step. Exa, Tavily, and Firecrawl all include content extraction.

**Verdict:** Still the best general-purpose choice on paper, but the "no content extraction" limitation is significant for coding agents that need full docs. Must be on a paid plan.

#### Serper
- **Agent Score:** Not in AIMultiple benchmark
- **Latency:** ~300ms (among the fastest)
- **Pricing:** $1/1K at entry ($50 for 50K credits), down to $0.30/1K at 500K+ volume
- **Index:** Google (scraped)
- **Free tier:** 2,500 queries, no credit card required

**Strengths:**
- **Cheapest option at any volume.** 3-15x cheaper than alternatives.
- **Uses Google's index.** For coding queries, this matters enormously — Google has the most comprehensive coverage of documentation sites, Stack Overflow, GitHub issues, and niche library docs.
- Generous free tier with no credit card requirement. Best for prototyping.
- 300 QPS rate limit — no agent will ever hit this.

**Real problems:**
- **Returns raw SERP JSON, not content.** You get titles, snippets, and URLs. Your agent still needs to fetch and parse the actual page. This adds latency and complexity.
- **Legal risk.** Google has sued SerpAPI (a competitor) for TOS violations. Serper scrapes Google — the same legal exposure applies. The service could theoretically be shut down.
- **No semantic understanding.** Pure keyword matching. "Explain React hooks lifecycle" won't be understood semantically; it just matches keywords.
- **Documentation is poor.** serper.dev/docs reportedly doesn't exist; integration is primarily through LangChain partnerships.
- **Token inefficiency.** Raw SERP data consumes ~40% more tokens than AI-optimized output, per one practitioner's measurement. At scale with expensive LLM calls, this hidden cost adds up.

**Verdict:** Best pure value for coding agents IF you're willing to add a page-fetching step (Jina Reader, your own scraper, or an agent `webfetch` tool). The Google index advantage for technical queries is real and underappreciated.

### Tier 2: Best for Specific Coding Agent Workflows

#### Tavily
- **Agent Score:** 13.67 (AIMultiple)
- **Latency:** ~998ms
- **Pricing:** Free 1,000 credits/month; $0.005-$0.008/credit; $30/month for 4,000 credits
- **Index:** Own AI-optimized index

**Strengths:**
- **Returns LLM-ready content with citations.** No post-processing needed. Your agent gets clean, summarized, source-attributed text it can immediately use.
- Best LangChain/LlamaIndex integration ecosystem. Most tutorials and frameworks default to Tavily.
- Auto-parameters feature validates and fixes malformed tool calls — useful for agents that sometimes construct bad queries.
- Search + Extract + Crawl in one API suite.

**Real problems:**
- **Dead links / 404s.** Multiple developers report Tavily returning cached URLs that no longer exist. For coding agents looking up current documentation, stale links are actively harmful.
- **Lower quality than Brave/Exa on benchmarks.** The ~1 point gap vs Brave was the only statistically significant difference in the AIMultiple benchmark — and Tavily was on the losing side.
- **Small index compared to Google.** Same niche-documentation problem as Brave but potentially worse.
- **Credit-based pricing is confusing.** "Advanced" search costs 2 credits. Extract and Crawl are billed separately. Real cost per useful result is higher than headline pricing suggests.

**Verdict:** Best plug-and-play option for OpenCode/MCP-based agents where you want zero post-processing. Probably the most popular choice in the ecosystem due to framework defaults, but not the highest quality.

#### Exa
- **Agent Score:** 14.39 (AIMultiple)
- **Latency:** ~1,200ms (Auto), ~350ms (Fast), ~3,500ms (Deep)
- **Pricing:** $5/1K searches (neural, 1-25 results), separate content charges; Starter $49/mo, Pro $449/mo
- **Index:** Own neural/semantic index, "tens of billions" of pages

**Strengths:**
- **Highest accuracy on code-specific benchmarks.** Exa's code search mode is specifically trained for code documentation, with a separate model optimized for high-accuracy code referencing.
- **Semantic search is genuinely different.** For a query like "Python library for converting PDFs to structured data," Exa understands intent, not just keywords. This matters for exploratory coding queries.
- **"Find Similar" is unique.** Feed it one good Stack Overflow answer, get 20 related results. No competitor offers this.
- **Category-based search** (tweet, financial report, personal site, company, code) — the `code` category is specifically relevant for coding agents.
- Rich MCP server with specialized tools for code context retrieval.

**Real problems:**
- **Expensive and complex pricing.** Neural search + content retrieval + summaries = multiple cost layers. Enterprise-scale operations see costs escalate quickly.
- **Smaller index for recent content.** "Crawl date" is when Exa discovered a link, not when it was published. Very new documentation may not be indexed yet.
- **Limited filter support in some categories.** People and company categories don't support date filters, include/exclude text, or domain exclusion — 400 errors if you try.
- **Overkill for simple lookups.** If your agent just needs "what's the syntax for Go's time.NewTicker," Exa's semantic search adds cost and latency without benefit over a simple Google scrape.

**Verdict:** Best choice if your coding agent does research-heavy work — exploring unfamiliar libraries, finding similar code patterns, or synthesizing information across multiple sources. Overkill for simple documentation lookups.

#### Firecrawl
- **Agent Score:** 14.58 (AIMultiple) — second highest
- **Latency:** ~1,335ms
- **Pricing:** Free 500 pages; Hobby €14/mo (3K pages); Standard €71/mo (100K pages)
- **Type:** Crawl + Extract, not a traditional search engine

**Strengths:**
- **Highest relevance score in benchmarks.** When it finds something, it's almost always the right thing.
- **Returns full, clean page content as Markdown.** Perfect for feeding entire documentation pages into an LLM context window.
- Handles JavaScript-rendered pages at no extra cost.
- Open-source option available.

**Real problems:**
- **Not a search engine per se.** Firecrawl discovers URLs and extracts content. For pure "find me information about X" queries, it's less suited than Brave or Exa. Better as a complement: use Serper/Brave to find URLs, then Firecrawl to extract content.
- **Pricing is page-based, not query-based.** A single search might consume multiple page credits. Cost model is fundamentally different and harder to predict.

**Verdict:** Best used in combination with another search API, not standalone. Excellent for coding agents that need to ingest full documentation pages.

### Tier 3: Situational / Niche

#### Perplexity Sonar API
- **Agent Score:** 12.96 (AIMultiple)
- **Latency:** Published claims of 358ms median; benchmark showed 11,000ms+ average
- **Pricing:** $5/1K requests (Search), different for Sonar Pro
- Decent quality but the massive latency discrepancy between Perplexity's own claims and independent benchmarks is a red flag. May work well for async/batch workflows.

#### DuckDuckGo (via DDGS library)
- **Price:** Free. No API key. No rate limits published.
- **Quality:** Basic. No AI optimization.
- **Best for:** Pi agents on zero budget. `pip install duckduckgo-search` + a bash one-liner gives you web search with no signup whatsoever. Quality is mediocre but the price is right.

#### Jina Reader API
- **Price:** Free tier available
- **Best for:** URL-to-Markdown conversion. Not a search engine — but when your agent has a URL and needs the content in clean Markdown, Jina is the standard. Often used alongside Serper or Brave.

#### Context7 MCP / Phind
- **Specifically for coding agents:** Context7 is an MCP server that resolves library names to their documentation and returns version-specific content. Phind is optimized for developer/technical queries. Both are worth investigating if your primary use case is "look up how to use library X."

---

## Revised Benchmark Critique

### AIMultiple Benchmark (Dec 2025) — The Most Cited

**What it does well:**
- 100 queries, 4,000 results, LLM-judged (not human — a limitation)
- Agent Score metric (Relevance × Quality) captures both precision and usefulness
- Statistical methodology with bootstrap confidence intervals is rigorous
- Transparent about overlapping CIs and that top-4 differences are noise

**Critical weaknesses:**
- **All 100 queries are AI/LLM-related.** Zero coding queries, zero library documentation lookups, zero error message searches. This benchmark tells you nothing about how these APIs perform for the actual queries a coding agent makes.
- **Single time point (Dec 2025).** APIs change rapidly. Brave and Exa both shipped major updates since.
- **LLM judge, not human.** LLM judges have known biases toward verbose, well-structured responses. An API returning a clean, authoritative 3-line answer might score lower than one returning a wordy but comprehensive paragraph.
- **5 results per query.** Coding agents often need only the top 1-2 results. Performance at k=1 may differ from k=5.
- **No latency-adjusted score.** Brave wins on both quality AND latency, but the benchmark presents them separately. In a coding agent loop, a 669ms API that's 5% better than a 13,600ms API isn't "similar" — it's categorically superior.

### HumAI Production Benchmark (May-Dec 2025)

**What it adds:**
- 10,000+ production queries across real client projects
- Tests accuracy on SimpleQA benchmark
- Reports that Exa Research Pro achieved 94.9% accuracy (highest)
- Notes that marketing claims and reality diverge — one API with "enterprise-grade accuracy" claims was wrong 18% of the time

**Critical weaknesses:**
- Single author with undisclosed methodology
- SimpleQA tests factual QA, not coding documentation retrieval
- Explicit recommendation to "use Serper for volume, Tavily for quality" doesn't test whether Serper+fetch outperforms Tavily on actual coding tasks

### What's Missing: A Coding-Agent-Specific Benchmark

No public benchmark tests queries like:
- "go-quartz library cron scheduling example"
- "pgvector cosine similarity operator <=> syntax"  
- "React 19 useOptimistic hook migration from useTransition"
- "error: cannot find module '@prisma/client' after upgrade"

These are the queries coding agents actually make. Until someone runs this benchmark, all "best for coding agents" claims (including mine) are extrapolations.

---

## Revised Bottom Line

### For Pi Users

**Cheapest functional option:** DuckDuckGo via `duckduckgo-search` Python package + a bash wrapper. Free, no signup, no API key. Quality is mediocre but it's zero-friction.

**Best value:** Serper ($50 for 50K queries) + `curl` or `jq` for JSON parsing + `webfetch` or Jina Reader for full page content. You get Google's index (best for niche technical queries) at the lowest cost. Pi's bash-first philosophy aligns perfectly with this approach.

**Best quality (if budget allows):** Brave LLM Context API ($5/1K) for search + snippets, or Exa with code category for semantic code search. Requires a paid plan.

### For OpenCode Users

**Recommended default:** Tavily MCP server. It's the path of least resistance — best framework integration, returns LLM-ready content, free tier for testing. Accept that quality is ~7% below Brave in benchmarks, but the zero-post-processing advantage is real.

**Power setup:** Brave for fast lookups + Exa for semantic code research + Firecrawl for full doc extraction. Three MCP servers, different strengths, higher total quality. More complex to configure.

### For Claude Code Users

Use the built-in search. It's already there. If you need more, add Exa MCP for code-specific semantic search.

### If You Can Only Pick One

**Brave Search API (Base AI, $5/1K)** remains the best single-API choice — fastest, among the highest quality, independent index, LLM-optimized output with the new Context API. But go in with eyes open: the index has gaps for niche documentation, you don't get full page content, and the free tier is barely functional for real agent workflows.

**The honest truth nobody says:** For coding agents specifically, *the search API matters less than the model's ability to use search results well.* A great model with Serper at $0.30/1K will often outperform a mediocre model with Exa at $15/1K. Invest in good prompts and agent tooling before optimizing your search API choice.

---

## Pricing Summary (Verified Feb 2026)

| API | Cost/1K Queries | Free Tier | Returns Content | Own Index | Latency |
|-----|----------------|-----------|-----------------|-----------|---------|
| **Serper** | $1.00 (entry), $0.30 (500K+) | 2,500 queries, no CC | Snippets only | Google (scraped) | ~300ms |
| **Brave Search** | $5.00 (Base AI) | ~1K queries/mo, CC required | Snippets + smart chunks (new) | Yes (35B+ pages) | ~669ms |
| **Tavily** | ~$5-8 effective | 1,000 credits/mo | Yes, LLM-ready | Yes (AI-native) | ~998ms |
| **Exa** | $5-15 (varies by mode) | ~$20 free credits | Yes, full pages | Yes (semantic) | 350ms-3.5s |
| **Firecrawl** | ~€0.71/1K pages | 500 pages | Yes, full Markdown | Crawl-based | ~1,335ms |
| **Perplexity** | $5.00 | 100 queries/day | Synthesized answers | Own | 358ms-11s (disputed) |
| **DuckDuckGo** | Free | Unlimited | Snippets only | Own | Varies |
| **SerpAPI** | $10.00 | 250/month | Snippets only | Google (scraped) | ~2,400ms |

*Note: Pricing changes frequently. Always verify on provider websites before committing.*
