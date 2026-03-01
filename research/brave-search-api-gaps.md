← [Search API Comparison](search-api-comparison-brave-kagi-google.md) · [Index](../README.md)

# Brave Search API: What We're Not Using

**Date:** 2026-02-28
**Context:** Audit of Brave Search API capabilities vs what our `brave-search` pi skill implements. All endpoints tested and confirmed working with current API key.

## Current Skill Coverage

| Endpoint | Status | Tool |
|----------|--------|------|
| Web Search (`/web/search`) | ✅ Implemented | `search.js` |
| LLM Context (`/llm/context`) | ✅ Just added | `llm-context.js` |
| Content extraction | ✅ Implemented | `content.js` (Readability, not Brave API) |
| News Search (`/news/search`) | ❌ Not implemented | — |
| Goggles (custom re-ranking) | ✅ Implemented | `llm-context.js --goggles` |
| Extra snippets | ✅ Implemented | `search.js` (always on) |
| Pagination (offset) | ❌ Not implemented | — |
| Image Search (`/images/search`) | ❌ Not implemented | — |
| Video Search (`/videos/search`) | ❌ Not implemented | — |
| Answers (`/chat/completions`) | ❌ Not implemented | — |
| Summarizer API | ❌ Not implemented | — |
| Local POIs | ❌ Not implemented | — |
| Rich Data (weather/stocks/sports) | ❌ Not implemented | — |
| Suggest/Spellcheck | ❌ Not implemented | — |

## Worth Adding

### 1. Goggles Support in `llm-context.js` — HIGH VALUE

**What:** Inline domain filtering/boosting via the `goggles` parameter. Already supported by the LLM Context endpoint.

**Why it matters:** When researching a technical topic, you often want to focus on authoritative sources and exclude SEO spam. Goggles lets you do this server-side in one call.

**Example use cases:**
```bash
# Focus on official docs only
llm-context.js "python asyncio" --goggles '$discard\n$boost=5,site=docs.python.org\n$boost=3,site=realpython.com'

# Exclude SEO spam farms
llm-context.js "react hooks" --goggles '$discard,site=w3schools.com\n$discard,site=geeksforgeeks.org'

# Research-focused: academic + HN + Reddit
llm-context.js "transformer attention" --goggles '$boost=5,site=arxiv.org\n$boost=3,site=news.ycombinator.com'
```

**Effort:** Trivial — just pass the `goggles` parameter through. Already confirmed working with the API.

**Syntax reference:**
- `$boost=N,site=domain.com` — boost results from domain (N=1-10)
- `$downrank=N,site=domain.com` — lower ranking
- `$discard,site=domain.com` — completely remove
- `$discard` on its own line — discard everything not explicitly boosted
- Can combine: `/path/$boost=3,site=github.com`

### 2. News Search — MEDIUM VALUE

**What:** Dedicated `/res/v1/news/search` endpoint. Returns news articles with freshness filtering, publication dates, source metadata.

**Why it matters:** When researching current events or recent developments, news search gives much better results than web search with `--freshness`. It surfaces articles from news publishers specifically, not random blog posts.

**Tested and working.** Returns title, URL, age, description, source domain.

**Effort:** ~30 lines — same pattern as `search.js` but hitting a different endpoint. Could be a `--news` flag on `search.js` or standalone `news.js`.

### 3. Extra Snippets in `search.js` — LOW EFFORT, MEDIUM VALUE

**What:** Adding `extra_snippets=true` to web search requests returns up to 5 additional text excerpts per result.

**Why it matters:** When using `search.js` (without `--content`), you currently get one snippet per result. Extra snippets give 3-5× more context without the overhead of fetching pages. Good for quick scans where you don't need full content but want more than a one-liner.

**Effort:** One-line change to `search.js` — add parameter and display extra snippets.

### 4. Pagination — LOW VALUE FOR AGENT USE

**What:** `offset` parameter + `more_results_available` field for paging through results.

**Why:** Occasionally useful if first page doesn't have what you need. But for agent use, if the first 20 results don't have it, you usually need a better query, not page 2.

**Effort:** Trivial (add `--offset` flag).

## Not Worth Adding (for agent use)

| Endpoint | Why Skip |
|----------|----------|
| **Answers** (`/chat/completions`) | We already have Claude. Paying for a second LLM answer adds cost without value. Different pricing plan ($4/1k + $5/1M tokens). |
| **Summarizer API** | Multi-step flow (search → get key → fetch summary). Superseded by LLM Context + Claude for our use case. |
| **Image Search** | Agent doesn't process images. Would only return URLs. Niche at best. |
| **Video Search** | Returns YouTube links with minimal metadata (no duration/views in my tests). YouTube transcript skill covers this better. |
| **Local POIs** | Ephemeral IDs (expire in ~8h), two-step flow. Personal use only, not agent research. |
| **Rich Data** | Weather/stocks/sports — not relevant to research agent use. |
| **Suggest/Spellcheck** | Useful for search UIs, not for agent queries. |

## Brave's Official Skills Repo

Brave published official agent skills at [github.com/brave/brave-search-skills](https://github.com/brave/brave-search-skills). Compatible with Claude Code, Cursor, Codex, etc. via the Agent Skills standard.

Their skills are curl-instruction-based (tell the agent the curl commands). Our approach is better for pi — executable scripts with parsed output are more reliable than asking the LLM to construct curl commands.

Worth monitoring for new endpoints/features they document.

## Competitive Note: Tavily

Mentioned in reviews as a competitor for agent-native search. Similar pre-processed content approach. Reportedly cheaper for complex multi-step chains. Not investigated in depth — Brave's independent index is a stronger differentiator for our use case than marginal cost savings.

## GitHub Landscape: Brave Search Agent Skills (Feb 2026)

Surveyed all brave-search skills published on GitHub. Every third-party skill is a fork/copy of `badlogic/pi-skills` (pi's author). None have LLM Context support.

| Repo | Type | LLM Context | Notes |
|------|------|-------------|-------|
| `badlogic/pi-skills` | Script-based (upstream) | ❌ | Still references dead free tier. Our fork's parent. |
| `brave/brave-search-skills` | Instruction-based (curl docs) | ✅ Documented | Official. 10 separate skills for 10 endpoints. No scripts. |
| `steipete/agent-scripts` | Script-based | ❌ | Exact copy of badlogic's |
| `moltbot/skills` (OpenClaw) | Script-based | ❌ | Republished steipete's copy |
| `openclaw/skills` | Script-based | ❌ | Same steipete copy |
| `JunSuzuki1973/openclaw-skill-brave-search` | Instruction-based | ❌ | Has `search_lang` param |
| `erik-balfe/brave-search` | npm SDK wrapper | ❌ | TypeScript library, not a skill |
| `asoraruf/brave_shim` | Proxy | ❌ | DDG→Brave format shim. Irrelevant. |

**Our `my-pi-skills/brave-search` is now the only script-based skill with `llm-context.js` on GitHub.** The only more complete coverage is Brave's official repo, which is instruction-based (tells agents to construct curl commands — less reliable than executable scripts).

## Recommendation

**Priority 1:** ~~Add `--goggles` to `llm-context.js`~~ ✅ Done (2026-02-28)
**Priority 2:** Add news search — useful for current-events research
**Priority 3:** ~~Add `extra_snippets` to `search.js`~~ ✅ Done (2026-02-28)
