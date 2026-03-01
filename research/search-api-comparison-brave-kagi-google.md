← [Index](../README.md)

# Search APIs for Agent Use: Brave vs Kagi vs Google

**Date:** 2026-02-28
**Context:** Evaluating search options for (a) agent/programmatic use in pi skills, and (b) personal search quality. Currently using Brave Search API via `brave-search` pi skill.

## Executive Summary

**Brave is the right choice for agent use and you should keep it.** But your current skill is leaving significant value on the table — Brave now has an LLM Context endpoint that returns pre-extracted, relevance-scored content optimized for LLM consumption. Your skill does `web search → fetch URL → Readability extraction`, when it could do a single `LLM Context` call that does all three in one shot, with better quality. Google's Custom Search API is dead (closed to new customers, sunset Jan 2027). Kagi's API is invite-only, beta, and 5× more expensive.

For personal search (browser), Kagi at $10/mo is the consensus best-in-class and worth trying.

---

## 1. Are Brave/Kagi Better Than Google?

### For Personal Search (Browser)

| | Google | Brave Search | Kagi |
|---|---|---|---|
| **Result quality** | Still best for local/maps, Reddit (exclusive deal). Declining for general queries — SEO spam, AI overviews clutter. | Good free option. Own index (30B+ pages). Weaker on local results and non-English. | Best overall per strong HN/community consensus. Blends multiple indexes. Site blocking/boosting. |
| **Privacy** | None | Good | Best (zero telemetry) |
| **Ads** | Yes, increasingly dominant | Yes (opt-out available) | None |
| **Cost** | Free | Free | $5-25/mo |
| **Reddit results** | Yes (exclusive indexing deal) | Limited (can't index Reddit directly) | Yes (routes through sources that can) |

**Verdict:** For general search quality, Kagi > Google > Brave > DDG. Google still wins on local/maps and Reddit indexing depth. Brave is a solid free option. DDG is just Bing in a duck hat — most users who try it end up `!g`-ing 15-80% of queries (massive signal from HN thread).

### For Agent/Programmatic Use (APIs)

| | Brave Search API | Kagi Search API | Google Custom Search | Exa |
|---|---|---|---|---|
| **Status** | ✅ Active, production | ⚠️ Invite-only, v0 beta | ❌ Closed to new customers, sunset Jan 2027 | ✅ Active |
| **Cost** | $5/1k queries ($5 free credits/mo) | $25/1k queries (2.5¢ each) | $5/1k queries (was) | $7/1k searches |
| **Free tier** | ~1,000 queries/mo (with attribution) | None | N/A | 1,000 requests/mo |
| **Own index** | Yes (30B+ pages, only independent Western index at scale) | Partial (Teclis for small web; aggregates Brave, Mojeek, others) | Yes (Google's full index, but via limited API) | Yes (neural/semantic index) |
| **LLM-optimized endpoint** | ✅ LLM Context API (pre-extracted content chunks) | ❌ Returns standard search results | ❌ Standard JSON results | ✅ (content extraction built in) |
| **Rate limit** | 50 QPS (Search), 2 QPS (Answers) | Unknown | 10k/day | Varies |

**Verdict:** Brave is the only viable option for agent use. Google is dead. Kagi is beta/invite/expensive. Exa is interesting for semantic search but more expensive and less proven for general web search.

---

## 2. Your Current Brave Setup: What's Suboptimal

### Current Architecture

```
search.js → Brave Web Search API → URLs + snippets
content.js → fetch URL → JSDOM + Readability → markdown (truncated to 5KB)
```

### What You're Missing

**Brave launched the LLM Context API** — a single endpoint that:
- Searches the web
- Extracts actual page content (text, tables, code blocks)
- Scores by relevance
- Returns pre-chunked content optimized for LLM token budgets
- Configurable: token limits (1K-32K), URL limits, relevance thresholds

Your current key already supports it (tested — works).

### Endpoint

```
GET https://api.search.brave.com/res/v1/llm/context?q=<query>
```

Key parameters:
- `maximum_number_of_tokens` (default 8192, max 32768)
- `maximum_number_of_urls` (default 20, max 50)
- `context_threshold_mode` (`strict`, `balanced`, `lenient`, `disabled`)
- `count` (number of search results to consider, max 50)

### What This Means

| | Current (`search.js` + `content.js`) | LLM Context endpoint |
|---|---|---|
| API calls per search-with-content | 1 (search) + N (content fetches) | 1 |
| Content quality | Readability extraction, 5KB truncation | Purpose-built extraction, token-budget aware |
| Latency | Sequential: search → parallel fetches → parse | Single call, server-side extraction |
| Content scope | Fetches only URLs you explicitly request | Extracts from top results automatically |
| Cost | 1 search query + fetch overhead | 1 search query (same $5/1k rate) |
| Anti-bot issues | `content.js` can hit Cloudflare/bot walls | Brave extracts server-side during crawl, bypasses most |

**The LLM Context endpoint is strictly better for agent use.** Same price, better content extraction, fewer API calls, lower latency.

### Recommendation

Add an `llm-context.js` to the brave-search skill (or replace `search.js --content` mode):

```bash
# Proposed usage
llm-context.js "query"                          # Default: 8K tokens, 20 URLs
llm-context.js "query" --tokens 4096            # Smaller context
llm-context.js "query" --tokens 16384 --urls 30 # Deep research
```

Keep `search.js` (without `--content`) for when you just need URLs/snippets. Keep `content.js` for fetching specific known URLs.

---

## 3. Should You Add Kagi?

### For Agent Use: No

- **Invite-only** — the Search API requires an invite, not publicly available
- **5× more expensive** — $25/1k queries vs Brave's $5/1k
- **Beta** — v0, breaking changes expected
- **Kagi uses Brave as a source** — you're already getting part of Kagi's value through Brave directly
- **FastGPT API** is public but that's an LLM answer, not search results

### For Personal Search: Worth Trying

- $10/mo Professional plan = unlimited searches
- Fair pricing: months you don't use it, you get a credit
- Site blocking/boosting is genuinely unique and useful
- The enthusiast consensus is overwhelming and specific (not just vibes)

### Kagi's Structural Risk

Nobody in the enthusiast community discusses:
- **Sustainability**: Kagi's core value (multi-index aggregation) depends on licensing indexes from Brave, Mojeek, and indirect access to Google results. Any of these could cut them off.
- **Google offering an ad-free tier**: Would eliminate Kagi's core differentiator overnight.
- **Scale economics**: Paid search is inherently a niche product. Kagi needs enough subscribers to sustain engineering velocity without the kind of revenue that ad-supported search generates.

---

## 4. The Landscape (Feb 2026)

Key structural facts:

1. **Microsoft killed the Bing Search API** (Aug 2025). Brave is now the only independent Western search index with a public API. This is a monopoly-level fact that changes the calculus — there is no realistic alternative for agent builders.

2. **Google Custom Search JSON API is closed** to new customers, sunset Jan 1, 2027.

3. **Reddit has an exclusive indexing deal with Google.** No other search engine can crawl Reddit. This is why DDG/Brave are weaker on user-generated-content queries. Kagi gets around this by routing through sources that can access Google results indirectly.

4. **The SEO arms race is structural.** A Google engineer (in the HN thread) points out that the people gaming search outnumber and outspend the people defending it by orders of magnitude. Every search engine converges toward the same failure mode at scale.

5. **LLMs are making traditional search less relevant** for the queries that matter most. The agent use case is shifting from "search → read results" to "give LLM grounded context → let it reason." This is exactly what Brave's LLM Context API is designed for.

---

## Action Items

1. **Keep Brave** as agent search API — it's optimal (cheapest, only independent index, LLM-optimized endpoint)
2. **Add LLM Context endpoint** to brave-search skill — biggest practical improvement available
3. **Consider Kagi $10/mo** for personal browser search — consensus says it's worth it
4. **No action on Google** — API is dead for new customers
5. **Monitor Exa** — interesting for semantic/people search but not a Brave replacement for general web search
