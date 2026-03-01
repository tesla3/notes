# Worklog

## 2026-02-28

- Added `--goggles` to brave-search `llm-context.js` — passes Brave Goggles re-ranking rules to API
- Added `extra_snippets=true` to `search.js` — 3-5× more context per result, always on
- Deep research on Brave Goggles optimization → `research/brave-goggles-optimization.md`
  - Analyzed official Brave docs, HN threads (31837986, 32599269, 39013497), Reddit discussions
  - Cross-referenced Kagi most-blocked domains, Bobby Hiltz "16 Companies" SEO list, Super-SEO-Spam-Suppressor, Brave's copycats_removal.goggle
  - Key findings: `$discard` + `$boost=1` allow-list pattern, advanced syntax (wildcards, anchors, caret), URL length limits for inline goggles, comprehensive SEO spam domain list
- Accuracy review of goggles research + SKILL.md — verified all hosted goggle URLs (7/7 live), counted actual rules vs claimed:
  - Fixed: tech_blogs 1,465→1,295, banana-boost 7,835→7,468, hacker_news ~3,000→6,238
  - Removed `$intitle`/`$inurl`/`$incontent`/`$lang` from docs — all unimplemented (official quickstart says "future", zero goggles use them)
  - Fixed domain categorization: w3schools/geeksforgeeks/etc are NOT in copycats_removal.goggle (which targets translation scrapers), relabeled as "SEO tutorial farms"
- Discovered hosted goggle URLs silently ignored by LLM Context API (`goggles_id` only works on web search API)
  - All hosted goggle examples in SKILL.md were non-functional — agent thought filtering was applied but it wasn't
- Added `--preset` flag to `llm-context.js`: `code`, `research`, `docs` — inline rules baked into code
  - Tested all 3: code removes SEO farms, research boosts arxiv, docs allow-lists official sources only
- Added `--goggles` to `search.js` with proper `goggles_id` for hosted URLs + inline `goggles` for rules
- llm-context.js now errors on hosted URLs instead of silently ignoring
- Rewrote SKILL.md: 250→90 lines, decision-tree structure, presets front and center
- Moved goggles syntax, hosted goggle catalog, domain lists → `goggles-reference.md`
- Rewrote SKILL.md goggles section: full syntax reference, task-specific recipes, known spam domain lists, decision guidance for when to apply goggles
- Distilled HN thread "Leaving Google has actively improved my life" (47184288) → `research/hn-leaving-google-improved-life.md`
- Researched Brave vs Kagi vs Google search APIs for agent and personal use → `research/search-api-comparison-brave-kagi-google.md`
  - Key finding: Brave is optimal for agent use (only independent Western index with public API after Bing API died Aug 2025)
  - Google Custom Search API closed to new customers, sunset Jan 2027
  - Kagi API invite-only, beta, 5× more expensive
  - Current brave-search skill was missing the LLM Context endpoint
- Built `llm-context.js` for brave-search skill — single API call for search + pre-extracted LLM-optimized content
  - Replaces the `search.js --content` + `content.js` multi-step pattern for agent use
  - Same price ($5/1k), better extraction, fewer calls, no bot-wall issues
- Updated brave-search SKILL.md with LLM Context docs, corrected pricing/setup info
