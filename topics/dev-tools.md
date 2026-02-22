# Developer Tools

← [Index](../README.md)

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

---

## Browser Tools for Coding Agents

**Decision:** TBD — not yet installed, research complete.

**Recommendation:** agent-browser (Vercel Labs) as primary — CLI-first, snapshot+refs workflow, 93% token reduction, session state save/load for auth. Playwright CLI (Microsoft) as secondary once it matures past v0.1.0. Firecrawl CLI for anti-bot/heavy scraping.

**Key insight:** The space consolidated around CLI tools with snapshot-based workflows in early 2026. MCP-based browser tools (Playwright MCP) are being superseded by CLI alternatives that save output to files instead of injecting into context windows. Token efficiency is the differentiator.

→ [Full comparison](../research/browser-tools-for-coding-agents.md)
