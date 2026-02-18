# Developer Tools

← [Index](../INDEX.md)

---

## Markdown Renderers

**Decision:** Glow v2.1.1 (`brew install glow`, alias `glow='glow -w 0 -p'`)

No tool is simultaneously correct, pretty, fast, interactive, and maintained. Glow wins on the balance of convenience, aesthetics, ecosystem adoption, and active maintenance — despite Glamour engine having real bugs on complex Markdown (lists, blockquotes, code blocks with 4+ year old issues).

Runners-up: mdcat (best correctness, but archived/dead Jan 2025), MD-TUI (best navigation, but AGPL + custom parser — was installed, then removed).

→ [Full evaluation](../research/terminal-markdown-renderers.md)

---

## Search APIs

**Decision:** TBD — not yet committed to a provider.

**Recommendations from research:**
- **Budget/Pi-native:** Serper ($1/1K) + Jina Reader for content extraction. Google's index is best for niche technical docs. Fits Pi's bash-first philosophy.
- **Best quality:** Brave LLM Context API ($5/1K) — fastest latency, independent index, new smart chunks. But no full page content — needs separate fetch step.
- **Zero cost:** DuckDuckGo via `duckduckgo-search` Python package. Mediocre quality, zero friction.
- **Plug-and-play (OpenCode/MCP):** Tavily — best framework integration, returns LLM-ready content.

**Key insight:** The search API matters less than the model's ability to use results well. Good model + cheap API often beats mediocre model + expensive API.

→ [Full evaluation](../research/search-api-evaluation.md)
