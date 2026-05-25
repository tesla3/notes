# Kiro Search & Fetch Tools — Deep Review

*Research date: March 2, 2026*

---

## Overview

Kiro (AWS's spec-driven agentic IDE) has **two built-in web tools** — `web_search` and `web_fetch` — that are **first-party, native tools** baked directly into both the Kiro IDE (since v0.8, Dec 2025) and the Kiro CLI (since v1.21.0, Nov 2025). These are **not MCP servers**. They are proprietary tools built into the agent runtime.

| Tool | Description |
|------|-------------|
| `web_search` | Searches the web, returns ~10 results with titles/URLs/snippets |
| `web_fetch` | Fetches content from a specific URL with smart extraction modes |

---

## How `web_search` Works

The agent decides autonomously when to invoke `web_search` — typically when asked about something newer than the model's training data.

**Example flow from official docs:**
```
> What is the latest on EC2 instances?

Searching the web for: AWS EC2 instances latest 2025 (using tool: web_search)
 ✓ Found 10 search results
 - Completed in 2.12s
```

Returns structured results (titles, URLs, snippets) which the agent synthesizes into an answer with references. Response times: **~1-2 seconds**.

### What Search Engine Is Behind It?

**This is the biggest black box.** AWS/Kiro documentation **never discloses the underlying search provider.**

A Reddit user asked directly: *"I wonder if the web tool is using the sonnet api fetching or is it a local 'curl' wrapper"* — no official answer.

**Evidence points to an AWS-hosted backend service** (not a local curl wrapper):
- Enterprise admins can disable it server-side from the AWS console
- Requires authentication (bearer tokens — users report "bearer invalid" errors)
- Inherits from Amazon Q Developer CLI, which had similar web capabilities
- No mention of Brave, Google, Serper, Bing, or any third-party search API anywhere in docs or source
- Content filtering restrictions ("should not reproduce meaningful chunks of text") suggest server-side processing

**Best guess:** AWS likely runs its own search proxy/aggregation layer, but this is unconfirmed and deliberately undisclosed.

### No Search Customization

You cannot configure:
- Freshness/recency filters
- Region or language
- Domain filtering
- Result count
- Ranking preferences

Compare this to Brave (goggles, freshness, country codes) or Perplexity (search depth). Kiro's search is a black box you cannot tune.

---

## How `web_fetch` Works

The more technically interesting tool. Three smart extraction modes:

| Mode | Behavior | Use Case |
|------|----------|----------|
| **Selective** (default) | Returns 10 sentences around search term matches; 20 if no matches | Targeted extraction — saves context window |
| **Truncated** | First 8,000 characters | Quick preview of a page |
| **Full** | Complete content up to 10MB | Comprehensive analysis |

### Auto Mode Selection

The agent chooses mode based on prompt:
- Vague request ("get me this page") → **truncated** (safe default, ~8KB)
- Specific question ("get installation info from this page") → **selective** with auto-generated search terms
- Explicit request for everything → **full**

### Example — Selective Mode (from docs)
```
> https://kiro.dev/blog/introducing-kiro-cli/ --> Can you get installation info?

Fetching content from: https://kiro.dev/blog/introducing-kiro-cli/
(searching for: installation install getting started) [mode: selective]
 ✓ Fetched 7909 bytes (selective) from URL
 - Completed in 0.434s
```

### Example — Truncated Mode (from docs)
```
> https://kiro.dev/blog/introducing-kiro-cli/ --> Can you get some of this page?

Fetching content from: https://kiro.dev/blog/introducing-kiro-cli/ [mode: truncated]
 ✓ Fetched 8051 bytes (truncated content) from URL
 - Completed in 0.521s
```

### URL Permission Controls

Enterprise-grade configurability:
```json
{
  "toolsSettings": {
    "web_fetch": {
      "trusted": [".*docs\\.aws\\.amazon\\.com.*", ".*github\\.com.*"],
      "blocked": [".*pastebin\\.com.*"]
    }
  }
}
```
- Blocked patterns take precedence over trusted
- URLs not matching trusted patterns prompt for approval
- Enterprise admins can disable both tools organization-wide

### Content Restrictions
- Won't reproduce meaningful chunks of copyrighted text
- Can't access paywalled/authenticated content
- Binary content, pages >10MB, too many redirects → fetch fails

---

## The Three Layers of Web Access in Kiro

Kiro has three separate mechanisms for web access — a source of confusion:

### 1. Built-in `web_search` / `web_fetch` (First-party)
- Native tools in the agent runtime
- No config needed — works out of the box
- Opaque AWS backend
- Cannot be customized

### 2. Default `mcp-server-fetch` (MCP, disabled by default)
- Ships in the default MCP config as disabled
- Open-source generic HTTP fetcher (`uvx mcp-server-fetch`)
- Toggle `disabled: false` to activate
- A completely separate thing from the built-in `web_fetch`

### 3. User-added MCP Servers (BYOK)
- Add Brave Search, Bright Data, or any search MCP
- Example from official docs:
```json
{
  "mcpServers": {
    "web-search": {
      "command": "uvx",
      "args": ["mcp-server-brave-search"],
      "env": { "BRAVE_API_KEY": "your-api-key-here" },
      "disabled": false,
      "autoApprove": ["search"]
    }
  }
}
```
- Full control over provider, API key, configuration

---

## Review: The Good, The Concerning, The Missing

### ✅ What's Good

1. **Zero-config convenience.** Unlike Cursor or Claude Code, no API key or MCP setup needed for web search. It just works.

2. **Smart context management.** The selective/truncated/full modes for `web_fetch` are genuinely clever. They solve the real problem of context window bloat. Auto-detection of mode based on prompt specificity is a nice touch.

3. **Enterprise governance.** Admins can disable web tools org-wide. Granular URL allow/block lists. Production-appropriate controls most competitors lack.

4. **Integrated workflow.** Search and fetch happen inline in agentic chat without browser context-switching. Results feed directly into agent reasoning.

5. **Decent speed.** ~2s for search, ~0.5-0.8s for fetch. Acceptable for interactive coding.

### ⚠️ What's Concerning

1. **Total opacity on search provider.** Biggest red flag. You have zero visibility into what index you're searching, what ranking algorithm applies, what content is filtered, or whether results are biased toward AWS properties. No other major search API operates this opaquely. Brave says it's their index. Serper says it's Google. Perplexity says it's multi-source. Kiro says... nothing.

2. **No way to evaluate search quality.** Can't benchmark, compare, or make informed decisions about when to trust results vs. use an alternative.

3. **Content filtering is lossy.** The "no meaningful chunks" restriction means potentially incomplete information from web pages. Functionally limiting vs Brave's LLM Context API or Firecrawl that give full markdown extraction.

4. **No search customization.** Can't specify freshness, region, language, domain filtering, result count. A black box you cannot tune.

5. **Enterprise admin disable is client-side only.** From the official docs: *"This restriction is enforced on the client side. Be aware that your end users could circumvent it."* Notable security gap for an AWS product touting enterprise governance.

6. **Consumes credits.** Web tool usage counts toward interaction credits ($20/mo for 1,000 interactions, $39/mo for 3,000). Every search/fetch eats into your budget alongside code generation.

7. **Built on Amazon Q infrastructure.** Kiro CLI literally replaced Amazon Q Developer CLI (`q update` upgrades you). Web tools inherited from Q. If AWS changes Q's search infra, Kiro search changes with no notice or control.

### ❌ What's Missing

- **No raw result access** — can't get structured search results as data; agent always synthesizes
- **No caching or history** — can't review what was searched/fetched in previous sessions
- **No multi-search/deep research mode** — one search at a time, no iterative research workflows
- **No source transparency** — unlike Perplexity (always cites) or Brave Answers (provides grounding), Kiro's grounding is inconsistent
- **No search depth control** — can't choose between quick vs deep search

---

## Verdict

Kiro's web tools are **a convenient default that prioritizes zero-friction over power and transparency.** They're perfectly adequate for quick lookups like "what's the latest version of React" or "what does this AWS API do." For a coding IDE, that's often all you need.

But if you need **serious research, reliable search quality, or transparency into results**, add a proper search MCP (Brave, Serper, etc.) and use that instead. The built-in tools are a black box bolted onto AWS infrastructure with no way to evaluate, customize, or compare their search quality.

The `web_fetch` tool is the stronger of the two — its selective extraction mode is genuinely useful and well-designed. The `web_search` tool is the weaker link: opaque, unconfigurable, and impossible to benchmark.

**For a company (AWS) that could easily partner with or build a world-class search API, the choice to ship an undisclosed, unconfigurable search backend is a deliberate product decision — one that prioritizes simplicity and lock-in over developer empowerment.**

---

## Kiro Context (for reference)

- **Launched:** July 14, 2025 (preview), GA November 17, 2025
- **Built by:** AWS (Amazon)
- **Based on:** VS Code (Code OSS fork), powered by Anthropic's Claude (Sonnet 4.0, 4.5, 4.6)
- **CLI:** Replaced Amazon Q Developer CLI
- **Pricing:** Free (50 interactions/mo), $20/mo (1,000), $39/mo (3,000)
- **Core differentiator:** Spec-driven development (requirements.md → design.md → tasks.md)
- **Other key features:** Agent hooks, steering files, MCP integration, subagents, autopilot mode
- **Web tools added:** IDE v0.8 (Dec 2025), CLI v1.21.0 (Nov 2025)
