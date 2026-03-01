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

---

## Local Knowledge Search (QMD)

**Decision:** QMD is the best on-device knowledge retrieval tool for AI coding agents (Feb 2026).

Tobi Lütke's hybrid search engine: BM25 + vector + LLM reranker, all running locally via GGUF models. CLI + MCP dual interface. Agent-optimized output (lazy discovery, scored retrieval, structured formats). Zero infrastructure — one SQLite file, one process.

**Why it matters:** Fills the private knowledge gap that external search APIs (Brave, Serper) can't reach. Implements the CLI lazy discovery pattern for knowledge bases. Used as OpenClaw's memory layer.

**Caveats:** sqlite-vec is alpha, 2GB model download on first use, bus factor = 1 (Lütke).

→ [Full evaluation](../research/qmd-evaluation-and-context-connection.md)

---

## Web Browsers (macOS)

**Decision:** Safari as daily driver, Firefox kept for specific use cases.

On 8 GB M1, Safari wins decisively: 20-40% less RAM than Chrome, 2-3x more power-efficient (WebKit vs Chromium/Gecko per powermetrics), seamless macOS integration (Keychain, Handoff, Touch ID, Spotlight). uBlock Origin Lite available on Safari since Aug 2025.

Firefox stays installed for Multi-Account Containers (unique killer feature — cookie isolation between contexts), full uBlock Origin, and web dev. Chrome has no role on Apple hardware — heaviest RAM, worst battery, Google's data collection, and MV3 crippled ad blockers.

→ [Full comparison](../research/browser-comparison-macos.md)
