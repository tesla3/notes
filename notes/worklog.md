# Worklog

## 2026-03-01

- Source-level review of Rig (github.com/0xPlaygrounds/rig) — Rust AI agent framework
  - 98K LOC Rust, v0.31.0, 911 commits, 21 months, 169 contributors (89% from one person)
  - Core value: best provider abstraction in Rust (20+ providers, 10+ vector stores, WASM)
  - Strengths: clean trait hierarchy, streaming, hooks, OpenTelemetry, MIT license
  - Weaknesses: thin testing (436 tests for 54K LOC, zero mocked providers, needs live API keys), 156 panics in production paths, no memory/orchestration
  - Verdict: excellent completion client library, weak as "agent framework" — the agent is just model + preamble + tools
  - Full analysis: `research/rig-review.md`
- Installed and researched Kiro CLI (v1.26.2) — AWS's terminal coding agent
  - Compared with Pi and Claude Code across architecture, pricing, tools, extensibility, sessions, benchmarks
  - Key findings: Kiro fastest in benchmarks (168s), unique built-in LSP/web search/AWS tools, but locked to Claude models via AWS credit system
  - Pi most extensible (TypeScript extensions, 20+ providers, session branching); Claude Code most powerful (Opus 4.5, deep autonomy)
  - Full analysis: `research/kiro-cli-vs-pi-vs-claude-code.md`
- Built `serper-search` pi skill as Google fallback for when Brave misses niche docs
  - `search.js` with `--content`, `--site`, `--period` flags
  - Reuses same Readability/Turndown content extraction as brave-search
  - SKILL.md documents when to use Serper vs Brave
  - Needs `SERPER_API_KEY` env var (free 2,500 queries at serper.dev, no CC)
- Researched search API landscape: what experts/practitioners actually use
  - Brave = benchmark winner (AIMultiple: 14.89, fastest at 669ms)
  - Tavily = popular due to LangChain ecosystem inertia, not quality superiority
  - Serper = best value ($1/1K), Google's index best for niche technical docs
  - Exa = specialist for semantic/code search, not worth adding (5 QPS, complex pricing, index gaps)
  - Decision: keep Brave as primary, Serper as fallback, skip Tavily and Exa
- Deep accuracy review of brave-search goggle optimization (all claims validated against live API + official docs)
  - Verified API param behavior: `goggles_id` silently ignored on LLM Context (200 OK, no filtering); `goggles` works for both hosted + inline
  - Fixed rule counts in goggles-reference.md: tech_blogs 1,295→1,469, banana-boost 7,468→7,838, netsec 3,896→3,903, hacker_news 6,238→6,239 (previous counts only counted `$boost=` lines, missed URL patterns + $discard + $downrank)
  - Fixed misleading descriptions: hacker_news/tech_blogs are **allow-lists** (global `$discard`), not just boosts; banana-boost embeds 190 copycats_removal discard rules
  - Fixed research file: split `$lang`/`$inquery` attribution — only in awesome-goggles repo, NOT in official Brave quickstart (which only lists `$intitle`/`$indescription`/`$incontent`/`$inurl` as future)
  - Added flag-as-value guard to extractOpt in llm-context.js + search.js (refactored search.js to use shared extractOpt pattern)
  - Fixed SKILL.md hacker_news comment to say "allow-list" not "boost"

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
- CORRECTION: hosted goggles DO work with LLM Context API — earlier test used wrong param name
  - LLM Context API uses `goggles` param for BOTH inline rules and hosted URLs
  - Web Search API uses `goggles` for inline, `goggles_id` for hosted URLs
  - My earlier test used `goggles_id` on LLM Context (wrong), concluded hosted URLs broken
  - Verified with POST body, GET with delays, proper param name — all work
  - Reverted the error message, updated docs to reflect both tools support hosted goggles
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

## 2026-03-01
- Distilled HN thread 47212355: "If AI writes code, should the session be part of the commit?"
  - git-memento tool (git notes for AI sessions), 138 comments, 119 points
  - Key finding: overwhelming rejection of raw sessions, emerging consensus around structured intent capture (CIRs, spec files, plan docs)
  - Notable: dang's meta-comment about Show HN drowning in AI-generated submissions
  - Saved to `research/hn-ai-session-commits.md`, linked from `topics/coding-agents.md`

## 2026-03-02
- Deep verification pass on `research/clojure-ai-agent-coding.md` (v3)
  - Verified all major claims against primary sources: Mündler PLDI 2025, FPEval, ChopChop, Willig report, Nubank blogs
  - **New sources added:**
    - Felix Barbalet "Simple Made Inevitable" (Feb 19, 2026) — strongest pro-Clojure argument, token efficiency data from Rosetta Code
    - GitHub Blog "Why AI is pushing developers toward typed languages" (Jan 2026) — high-credibility pro-types evidence
    - Nubank Feb 2026 blog (Clojure South) — Marlon explicitly positions Clojure as orchestration layer
    - serefayar's Substack (Jan 2026) — agent engine from scratch in Clojure
    - State of Clojure 2025 Survey — notable: AI not mentioned as adoption driver
    - lobste.rs discussion of Barbalet piece — sharp counter-arguments
  - **Corrections:**
    - ChopChop: arxiv 2025 → POPL 2026 (stronger venue)
    - Mycelium date: Mar → Feb 25, 2026
    - Freshcode: Jan 2026 → Dec 31, 2025
    - Nubank: two separate blog posts conflated, now properly attributed
    - druchan explicitly places Clojure Spec in "far less" category
  - **New argument engaged:** brownfield barrier thesis (maintainability > generation quality). Compelling but unfalsifiable at present.
  - **Verdict slightly adjusted:** C→C+ practical readiness (MCP ecosystem growth), added third question about long-term maintainability
  - Key takeaway: dynamic typing remains the critical structural weakness. Best pro-Clojure argument now is about the future, not the present.

## 2026-03-04
- Assessed QMD feasibility on this machine (i3-1000NG4, 8GB RAM, Intel Iris Plus)
  - BM25 mode would work fine; hybrid pipeline (3 GGUF models on CPU, no Metal) would be 30-60s+ per query — borderline unusable
- Researched and compiled comprehensive modern CLI tools tally
  - 100+ tools across 16 categories, community consensus tiers, Yazelix terminal IDE pattern
  - Sources: GitHub awesome lists, Reddit r/rust polls, curated blogs, dotfiles repos (2024-2026)
  - Saved to `research/modern-cli-tools-tally.md`, linked from `topics/dev-tools.md`
- Installed agent-useful tools: `tokei`, `scc`, `ast-grep` (code metrics + structural search)
- Installed human-UX tools: `bat`, `eza`, `git-delta`, `dust`
  - delta was already configured in `.gitconfig` (side-by-side, navigate, line-numbers)
  - Updated `.zshrc`: `cat→bat`, `ls→eza`, `ll→eza -la`, `tree→eza --tree`, `treed→eza -TD`

## 2026-03-03
- **Critical review of `research/distributed-systems-parallel-agents.md`**
  - Verified claims against primary sources (Dria mem-agent blog, USL literature, CAP theorem critiques, saga pattern definitions)
  - **5 issues found and corrected:**
    1. NERDs "paper" doesn't exist — it's tdaltonc's HN comment concept, not a published paper. Fixed in both this file and the source HN distillation.
    2. mem-agent claim ("outperforms GPT-5 and Claude Opus") was misleading — added caveats about self-benchmarking, Qwen3 prompt optimization, Claude Opus 4.1 scaffold incompatibility.
    3. CAP theorem analog was presented as direct mapping — added Kleppmann critique, voluntary vs involuntary isolation distinction, PACELC suggestion.
    4. Saga pattern was overapplied — qualified that FD lifecycle is a state machine, not a saga (no distributed transactions, no compensating rollbacks).
    5. USL applied to human cognition was presented as literal — reframed as metaphorical, noted Miller's Law as better explanation.
  - **Strengths confirmed:** Section 7 (event sourcing/state taxonomy) is genuinely insightful and original. Sections 1, 5, 8 are well-grounded.
- Optimized global AGENTS.md `## CLI Tool Use` section against three research files:
  - `cli-tools-context-efficiency.md`, `agent-tool-use-self-review.md`, `expert-cli-tricks-for-context-saving.md`
  - Added: explicit motivation (trajectory snowball, early-turn cost multiplier), decision ladder (don't read → minimum → fully), operation-oriented structure with sub-decisions (extract section: pattern → `rg -A N`, line numbers → `sed -n`, exploring → `read`), `rg -n` vs `rg -l` guidance, output discipline (head for discovery, `2>&1 | tail` for errors, git shortcuts), quoting safety
  - Kept: all existing patterns (comm, jq -e, awk, rg -F, --, stat, ls -t)
  - Removed: nothing — restructured flat list into 4 logical subsections (motivation, ladder, operations, output, safety)

## 2026-03-06

- Distilled HN thread "LLMs work best when the user defines their acceptance criteria first" (106pts, 83 comments)
  - Article: 20,171× slower SQLite rewrite (576K LoC Rust), 82K-line disk daemon that should be a cron one-liner
  - Key thread insight: pornel's compounding-code dynamic (LLMs add code, never delete), "skill issue" defense is unfalsifiable tautology
  - Saved: `research/hn-llm-plausible-code.md`
- Deep research: why "write minimal code" instructions don't fix LLM code bloat
  - People DO try (r/ClaudeAI thread, 33 upvotes, KISS/YAGNI in CLAUDE.md)
  - Five structural reasons it can't fully work: RLHF length bias in weights, no stop-and-think mechanism, curse of instructions, statelessness, "minimal" requires domain judgment
  - What works: plan-then-execute, TDD, post-hoc cleanup, architectural constraints, active interruption
  - Saved: `research/llm-code-bloat-minimality-instructions.md`
- Critical review of `workflow-minimal-composable-systems.md` — section-by-section agent comprehension audit
  - Added `(HUMAN)` reading instruction: agent should prompt human on these items, not skip silently
  - Resolved duplication tension: Metz "tolerate duplication" (Build) vs "cleanup duplicates" (Verify) — clarified as temporal (tolerate early, consolidate at 2+ use cases)
  - Withdrew suggestions: strip quotes (they're structural constraints via pattern-matching, not decoration), add thresholds (task-relative judgment from quotes + periodic `wc -l`), separate cognitive load for human vs agent (converges on same recommendations)
  - Key insight: quotes induce minimality behavior structurally; "structural constraint beats behavioral instruction" applies to the document itself
- Reviewed workflow against playbook, identified 4 gaps:
  1. Created `research/workflow-anti-patterns.md` — 8 categories of what doesn't work (vague rules, instruction overload, fighting weights, patching forward, assuming agent knowledge, expecting agent judgment, unbounded sessions, verification without taste). Referenced from workflow footer.
  2. Added "revert, don't patch" to Build — when approach fails, discard and restart with narrower scope
  3. Added TDD loop to Build — TDD for production code, implement-run-fix for exploratory/research/glue
  4. Strengthened codebase research in Plan — check if research note exists or is stale, write findings to file before implementing
