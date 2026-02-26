← [Index](../README.md)

## HN Thread Distillation: "Making MCP cheaper via CLI"

- **HN:** https://news.ycombinator.com/item?id=47157398
- **Article:** https://kanyilmaz.me/2026/02/23/cli-vs-mcp.html
- **Score:** 163 | **Comments:** 76 | **Date:** 2026-02-25

**Article summary:** The author built CLIHub, a tool that converts MCP servers into standalone CLI binaries. The pitch: MCP dumps all tool schemas into context upfront (~15,540 tokens for 84 tools), while CLI uses lazy discovery via `--help` (~300 tokens at session start, ~610 per tool discovered). Claims ~94% token savings overall, and 74-88% savings even versus Anthropic's Tool Search.

### Dominant Sentiment: MCP is the wrong abstraction layer

The thread broadly agrees that stuffing tool schemas into context is wasteful, but splits on whether CLI is the right fix or just one symptom of a larger convergence toward lazy discovery and composability.

### Key Insights

**1. The composability gap is the real advantage, not token counts**

The article leads with token savings, but the thread's sharpest comments identify a deeper structural issue. `_pdp_` nails it: "MCP tools are not composable. When I call the notion search tool I get a dump of whatever they decide to return which might be a lot. The model has no means to decide how much data to process." CLI tools are scriptable — agents pipe through `jq`, `head`, `grep` — because that's how they're trained. `martinald` extends this with a killer example: summing values from 150 order IDs requires 150 MCP tool calls (each round-tripping through the model), but one CLI `for` loop handles it in ~500 tokens. The token savings from lazy discovery are a one-time win; composability savings compound with task complexity.

**2. Five independent teams converged on the same idea in the same week**

CLIHub, mcpshim, mcporter, mcp-cli, CMCP — all MCP-to-CLI converters, all launched within days. `cmdtab` built mini-browser for the same reason. Cloudflare shipped Code Mode (search + execute over the full API in ~1,000 tokens). Anthropic shipped Tool Search. The convergence is the signal: "don't dump everything upfront" is now consensus. The debate is over *where* the lazy-loading happens — client-side (Tool Search), server-side (Code Mode), or at the protocol boundary (CLI).

**3. The article's framing is already outdated — but that doesn't kill the thesis**

`philfreo` correctly points out that Claude Code already does progressive tool loading via Skills and Tool Search, making the "MCP dumps everything" premise stale for best-in-class clients. `eongchen` echoes: "the issue isn't MCP vs CLI, it's that you've turned on everything without thinking." But `thellimist` (OP) counters that *most* MCP servers in the wild still dump — Cloudflare is the exception, not the rule. The gap between what's possible and what's deployed is the actual problem. The article solves for the ecosystem as it exists, not as it should be.

**4. The real token killer is per-turn context replay, not tool definitions**

`OsrsNeedsf2P` (building a Godot agent) reframes the entire debate: "The real killer is the input tokens on each step. If you have 100k tokens in the conversation, and the LLM calls an MCP tool, the output *and the existing* conversation is sent back." Ten tool calls on a 100k conversation means 1-5M input tokens — dwarfing any tool definition overhead. Cache hit rates can be as low as 40% in practice. CLI doesn't solve this. Neither does Tool Search. The article is optimizing a second-order cost while the first-order cost goes unaddressed. `martinald` agrees: "But this is just the nature of LLMs (so far)."

**5. CLIs unlock the KV cache in ways tool definitions don't**

`cmdtab` surfaces a non-obvious technical detail: "changing tools mid-conversation suffers from KV cache invalidation, vs CLI `--help` which only shows the manual for a specific command in append-only fashion." MCP tool definitions are injected at the beginning of the prompt, so adding or removing tools invalidates the cache for everything after. CLI discovery happens as append-only conversation turns, preserving the KV cache. This is a real, measurable advantage that the article doesn't mention and the thread mostly ignores.

**6. Smaller models benefit disproportionately**

`cmdtab` again: "Even the smallest models are RL trained to use shell commands perfectly. Gemini 3 Flash performs better with a CLI with 20 commands vs 20+ tools in my testing." This makes sense — shell command usage is massively overrepresented in training data compared to MCP tool-call JSON. The implication: CLI isn't just cheaper, it's more accurate for non-frontier models, which is where cost-sensitive production deployments actually live.

**7. Cloudflare's Code Mode is the most radical approach and the thread undervalues it**

Two tools — `search()` and `execute()` — covering 2,500+ API endpoints in ~1,000 tokens. The agent writes JavaScript against a typed OpenAPI spec, runs it in a V8 sandbox, and only relevant results enter context. This is fundamentally different from both MCP (pre-loaded schemas) and CLI (lazy discovery via `--help`). It's closer to giving the agent a *programming environment* rather than a *tool catalog*. `aceelric` built CMCP inspired by this, but the thread doesn't engage with the deeper implication: if server-side code execution works, the entire tool-definition paradigm is a dead end.

**8. MCP won as the universal source format, even for its critics**

The meta-irony: every project in this thread — CLIHub, mcpshim, mcporter, CMCP — takes MCP servers as *input*. Nobody is writing CLI tools from scratch; they're converting MCP. `paulddraper` puts it plainly: "MCP is just JSON-RPC plus dynamic OAuth plus some lifecycle things. It's a convention. That everyone follows." MCP's value isn't as a runtime protocol — it's as a catalog standard that CLI converters, Code Mode, and Tool Search all consume. The "MCP vs CLI" framing is wrong; it's "MCP as source of truth, CLI/Code Mode as execution surface."

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Models are trained on CLI, not MCP JSON" | Strong | Training data distribution genuinely favors shell usage; measurable accuracy gains on smaller models |
| "Tool Search already solves this" | Medium | True for Claude, but Anthropic-only and still loads full JSON Schema per tool; doesn't help Gemini/GPT users |
| "The real cost is context replay, not definitions" | Strong | Correct reframe, but doesn't invalidate CLI benefits — just shows they're smaller than advertised |
| "CLI has a broader attack surface than sandboxed MCP" | Medium | Cloudflare flags this explicitly; real concern for deployed agents, less so for human-in-the-loop coding assistants |
| "Just don't load 84 tools at once" | Weak-to-Medium | Correct in theory, but ignores that most MCP clients still do exactly this |

### What the Thread Misses

- **Auth is the buried lede.** `martinald` mentions it in passing, but nobody explores it: every CLI has a different auth mechanism (env vars, config files, OAuth flows, API keys). MCP's standardized OAuth is its strongest remaining value proposition. CLIHub supports multiple auth patterns, but "each CLI authenticates differently" is a real operational burden at scale that the token-savings pitch glosses over.
- **Nobody discusses failure modes.** What happens when `--help` output is poorly formatted, or a CLI returns unexpected output? MCP's typed schemas provide a contract; CLI discovery is best-effort. The thread assumes CLIs are well-behaved because `gh` and `aws` are. Most won't be.
- **The "semantic primitives" angle (`eggplantiny`) got dismissed too quickly.** Normalizing operations above the tool level (search, read, create, update) is what Cloudflare's Code Mode actually achieves with search() + execute(). `TeMPOraL` correctly notes that shell already provides these primitives (`cat`, `grep`, pipes), but the thread doesn't connect these dots.
- **No one asks whether this matters at all in 6 months.** Context windows are getting longer and cheaper fast. `2001zhaozhao` hints at this — permanently cached system prompts with deep discounts could make all of this optimization irrelevant. The thread is optimizing for today's constraints.

### Verdict

The thread reveals that "MCP vs CLI" is a false dichotomy — MCP is becoming the catalog layer while execution surfaces diversify (CLI, Code Mode, Tool Search). The real convergence is on lazy discovery and composability, not on any particular protocol. But the thread circles without stating the deeper tension: **MCP's value is inversely proportional to how much of it you actually load into context**. The less MCP you use at runtime, the better MCP works as an ecosystem. That's either a sign of a maturing protocol finding its right abstraction level, or a sign that the runtime protocol is dead and only the registry survives. The answer probably depends on whether Cloudflare's Code Mode pattern — where the agent writes code instead of calling tools — becomes the norm. If it does, tool definitions as a concept are obsolete, and MCP becomes just an OpenAPI catalog with better OAuth.
