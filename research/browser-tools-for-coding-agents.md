← [Developer Tools](../topics/dev-tools.md) · [Index](../README.md)

# Browser-Based Web Tools for Coding Agents

**Purpose:** Compare tools that let a CLI coding agent (like Pi) interact with real web pages — including JavaScript-heavy sites and pages behind authentication. Researched Feb 2026.

---

## The Problem

Pi's brave-search skill handles basic search and content extraction, but fails on:
- **JavaScript-rendered pages** — SPAs, dynamic content, client-side routing
- **Authenticated pages** — dashboards, admin panels, anything behind login
- **Multi-step interactions** — pagination, form fills, clicking through flows
- **Anti-bot protected sites** — Cloudflare, CAPTCHAs, fingerprint checks

A real browser is needed. The question is which tool gives a CLI-first coding agent the best interface to one.

---

## Tool Landscape (Feb 2026)

### Tier 1: CLI-First Tools Designed for Coding Agents

These are purpose-built for the exact use case — an AI agent calling shell commands to control a browser.

#### 1. agent-browser (Vercel Labs)

- **GitHub:** github.com/vercel-labs/agent-browser — 14K+ stars
- **Architecture:** Rust CLI → Node.js daemon → Playwright/Chromium
- **Install:** `npm install -g agent-browser && agent-browser install`
- **Skill:** Official SKILL.md available for Claude Code; works with any skill-aware agent
- **Key innovation:** Snapshot + Refs workflow — accessibility tree snapshots return compact refs like `@e1`, `@e2` for deterministic element targeting
- **Token efficiency:** Claims 93% context reduction vs Playwright MCP
- **Auth support:** `state save auth.json` / `state load auth.json` for session persistence; `--header` for HTTP auth headers scoped to origins
- **Modes:** Headless (default) + headed for debugging
- **Commands:** 60+ covering navigation, interaction, forms, screenshots, tabs, cookies, network interception, device emulation, video recording
- **Session isolation:** Named sessions with independent state

**Strengths:**
- Zero config — install and go
- Rust performance layer for fast startup
- Snapshot-based workflow is extremely token-efficient
- Semantic locators (ARIA role, text, label, placeholder, test ID)
- Smart snapshot filtering (interactive-only, compact, depth-limited, CSS-scoped)
- Session state save/load solves the auth problem cleanly

**Weaknesses:**
- Relatively new (Jan 2026)
- Chromium only
- The Rust native binary is optional — falls back to Node.js

#### 2. Playwright CLI (`@playwright/cli` — Microsoft)

- **Publisher:** Microsoft (same team as Playwright MCP)
- **Install:** `npm install -g @playwright/cli@latest`
- **Launch:** Early 2026 as companion to Playwright MCP
- **Skill:** `playwright-cli install --skills` copies SKILL.md to workspace
- **Key innovation:** File-based output — snapshots saved as YAML files on disk, screenshots as PNGs. Agent reads them only when needed.
- **Token efficiency:** ~4x reduction vs Playwright MCP (~27K vs ~114K tokens on benchmark tasks)
- **Auth support:** Can use existing Chrome install (picks up your profiles/cookies); standard Playwright auth patterns
- **Modes:** Headless (default) + `--headed`
- **Browser support:** Chromium, Firefox, WebKit

**Strengths:**
- Backed by Microsoft / Playwright team — will be well-maintained
- Multi-browser support
- File-based approach is elegant — agent decides what to read
- Can reuse system Chrome with existing sessions/cookies
- Familiar Playwright patterns for anyone who knows the ecosystem

**Weaknesses:**
- Very new (early 2026, v0.1.0)
- Less documented than agent-browser so far
- Snapshot format (YAML) may be more verbose than agent-browser's compact refs

#### 3. Dev Browser (SawyerHood)

- **GitHub:** github.com/SawyerHood/dev-browser
- **Type:** Claude Code skill/plugin (works via Playwright under the hood)
- **Install:** `/plugin marketplace add sawyerhood/dev-browser` in Claude Code; manual install for other agents
- **Key innovation:** Persistent browser sessions + incremental scripting. Agent writes small tsx scripts that run against a live browser server — no restart from scratch.
- **Auth support:** Extension Mode connects to user's existing Chrome browser with existing logins. This is the killer feature for auth.
- **Two modes:**
  - **Standalone:** Launches fresh Chromium
  - **Extension:** Connects to user's real Chrome via relay server — agent operates in the user's authenticated browser session

**Strengths:**
- Extension mode is unique — uses your actual logged-in browser
- Persistent sessions between commands (no cold start per script)
- ARIA snapshot + ref system (similar to agent-browser)
- Small incremental scripts match how coding agents naturally work
- 14% faster, 39% cheaper than Playwright MCP in author's eval

**Weaknesses:**
- Claude Code-specific plugin system (would need adaptation for Pi)
- Extension mode requires user to install Chrome extension
- Smaller project, single maintainer
- Requires manual `cd skills/dev-browser && npx tsx` invocations

#### 4. Firecrawl CLI + Browser Sandbox

- **GitHub:** github.com/mendableai/firecrawl — 82K+ stars
- **Install:** `npx -y firecrawl-cli@latest init --all --browser`
- **Type:** Hybrid — scraping API + managed browser sandbox
- **Auth:** `firecrawl login --browser` opens browser for auth; token-based auth for subsequent requests
- **Skill:** Official skill available via `npx skills` protocol
- **Key innovation:** Combines static scraping (for simple pages) with remote browser sandbox (for interactive flows) in one tool

**Strengths:**
- Most mature scraping infrastructure (>80% coverage on benchmarks)
- Handles JS rendering, anti-bot, complex page structures
- Browser Sandbox is fully managed — no local Chromium, no CPU spikes
- Parallel sessions at scale
- `scrape` for simple pages, `browser` for interactive flows — right tool for the job
- `search` endpoint combines web search + scraping in one call

**Weaknesses:**
- **Paid service** — free tier exists but limited
- Requires API key and network connectivity
- Remote browser adds latency vs local
- Less control than local Playwright — you're working through their API
- Can't connect to your own authenticated browser sessions

---

### Tier 2: SDKs/Frameworks (Not CLI-First, But Relevant)

These require writing code to use. A coding agent could write and execute scripts, but they're not designed for the snapshot→click→snapshot CLI loop.

#### 5. Stagehand (Browserbase)

- **GitHub:** 21K+ stars
- **Type:** TypeScript SDK for AI-driven browser automation
- **Key feature:** Natural language commands — `page.act("Click the login button")`, `page.extract({instruction: "..."})`
- **Tight integration with Browserbase cloud browsers**
- **Best for:** TypeScript developers building custom agent workflows
- **Auth:** Through Browserbase's managed sessions with session persistence

**Verdict:** Powerful but SDK-shaped, not CLI-shaped. An agent could write Stagehand scripts, but the overhead is higher than snapshot+ref CLIs.

#### 6. Browser Use (Python)

- **GitHub:** 78K+ stars
- **Type:** Python framework for building browser-controlling agents
- **Key feature:** Most composable option — designed for agent systems
- **Best for:** Python developers building custom agents

**Verdict:** Wrong language for Pi's Node.js/bash ecosystem. Interesting architecture but not a fit.

---

### Tier 3: Infrastructure (Browser-as-a-Service)

#### 7. Browserbase

- **Type:** Cloud browser platform ($40M funding, 50M+ sessions in 2025)
- **Usage-based pricing**
- **Provides the browsers that Stagehand and others connect to**
- Not a direct tool for coding agents — it's infrastructure underneath other tools

#### 8. Bright Data Scraping Browser

- **Type:** Proxy + browser infrastructure with 150M+ residential IPs
- **Best for:** Scale scraping with anti-bot bypass
- **Not relevant for coding agent CLI use**

---

## Comparison Matrix

| Feature | agent-browser | Playwright CLI | Dev Browser | Firecrawl CLI |
|---|---|---|---|---|
| **Install complexity** | npm + install | npm + install | plugin + extension | npm + API key |
| **Auth: saved sessions** | ✅ state save/load | ✅ via Chrome profiles | ✅ extension mode (best) | ⚠️ token-based |
| **Auth: use your browser** | ❌ | ⚠️ can use system Chrome | ✅ extension connects to Chrome | ❌ |
| **JS rendering** | ✅ full Chromium | ✅ Chromium/FF/WebKit | ✅ full Chromium | ✅ remote Chromium |
| **Token efficiency** | ★★★★★ (93% reduction) | ★★★★ (4x reduction) | ★★★★ (39% cheaper) | ★★★ (file-based but API overhead) |
| **Anti-bot bypass** | ❌ basic | ❌ basic | ❌ basic | ✅ built-in |
| **CLI-native** | ✅ designed for it | ✅ designed for it | ⚠️ script-based | ✅ designed for it |
| **Cost** | Free | Free | Free | Freemium (paid for real use) |
| **Maturity** | New (Jan 2026) | Very new (early 2026) | Small project | Mature (82K stars) |
| **Multi-browser** | ❌ Chromium only | ✅ Chromium/FF/WebKit | ❌ Chromium only | N/A (remote) |
| **Pi compatibility** | ✅ bash commands | ✅ bash commands | ⚠️ needs adaptation | ✅ bash commands |
| **Offline/local** | ✅ | ✅ | ✅ | ❌ requires API |

---

## Recommendation for Pi

**Primary: agent-browser** — Best overall fit.
- Pure CLI, zero config, designed exactly for this use case
- Snapshot + refs workflow is the most token-efficient approach
- Session state save/load handles auth cleanly
- Already has a SKILL.md pattern that maps directly to Pi's skill system
- Vercel Labs backing suggests decent maintenance trajectory

**Secondary: Playwright CLI** — Watch closely.
- Microsoft backing = long-term maintenance guarantee
- Multi-browser support is unique
- File-based output approach is clever
- Still very early (v0.1.0) — let it mature a release or two

**For authenticated sites specifically: Dev Browser's extension approach** is the most elegant solution (connects to your actual logged-in Chrome), but it's Claude Code-specific and would need adaptation for Pi. Worth watching if the project grows.

**For heavy scraping / anti-bot: Firecrawl CLI** fills a different niche — when you need to scrape at scale or bypass protections. The Browser Sandbox is new (Feb 2026) and interesting. But the paid API dependency makes it a complement, not a primary tool.

**Skip:** Stagehand, Browser Use, Browserbase directly — these are SDK/infrastructure plays, not CLI tools for a coding agent.

---

## Implementation Path for Pi

1. **Install agent-browser** as a Pi skill (adapt their SKILL.md)
2. **Workflow:** `open URL → snapshot -i → click @ref → fill @ref "value" → screenshot`
3. **Auth pattern:** Log in once with `--headed`, `state save auth.json`, then `state load auth.json` for subsequent headless sessions
4. **Fallback:** Firecrawl CLI for pages that need anti-bot bypass or when local browser is impractical

---

*Sources: Brave Search results, official project documentation, Firecrawl blog, Reddit r/ClaudeCode, Medium posts, Pulumi blog, NxCode comparison. Feb 2026.*
