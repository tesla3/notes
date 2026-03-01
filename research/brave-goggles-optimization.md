← [Search API Comparison](search-api-comparison-brave-kagi-google.md) · [Brave Search API Gaps](brave-search-api-gaps.md) · [Index](../README.md)

# Brave Goggles: Deep Research for Agent Optimization

**Date:** 2026-02-28
**Context:** Optimizing the `--goggles` instructions in our brave-search SKILL.md so the agent (LLM) composes effective goggles automatically. Based on official Brave docs, HN threads, Reddit discussions, community-curated spam lists, and Kagi domain insights.

## Key Findings

### 1. The Syntax Is Richer Than We Documented

Our SKILL.md only covers `site=` targeting. The full DSL includes:

| Feature | Syntax | Example |
|---------|--------|---------|
| Site targeting | `$boost=5,site=example.com` | Boost a domain |
| URL pattern | `/blog/$boost=3` | Boost URLs containing `/blog/` |
| Wildcard | `/docs/*/api$boost=3` | Match URL patterns with `*` (max 2) |
| Left anchor | `\|https://docs.$boost=3` | URLs starting with `https://docs.` |
| Right anchor | `.pdf\|$boost=2` | URLs ending with `.pdf` |
| Both anchors | `\|https://example.com\|$boost=3` | Exact domain match |
| Caret (separator) | `/api^$boost=3` | Match `/api` followed by separator or end (max 2) |

**Unimplemented / future features** (listed in quickstart as "we will add... in the future", commented out, zero goggles use them):
- `$intitle`, `$indescription`, `$incontent`/`$intext`, `$inurl`, `$lang`, `$inquery`
- The awesome-goggles repo (rjaus) lists these as available, but the official quickstart explicitly marks them as future. No official or community goggle uses any of them.

**Source:** Brave's official goggles-quickstart repo (quickstart.goggle, getting-started.md).

### 2. The `$discard` + `$boost=1` Pattern Is Critical

A Brave engineer (pythux) on HN explained this key pattern:

> In this case \[`$boost=1`\] is needed because there is a generic `$discard` rule in the Goggle (which means: discard any result that does not match any other instruction from the Goggle). Using a `$boost=1` allows you to keep some sites, that you don't necessarily want to boost more than their "natural ranking".

This means:
- `$discard` alone = discard everything not matched by another rule
- `$boost=1,site=example.com` = keep this site at natural ranking (don't boost, but don't discard)
- `$boost=5,site=example.com` = keep AND boost this site

**This is the most powerful pattern for agent use.** It creates an allow-list: discard all the noise, keep only authoritative sources.

### 3. Precedence Rules

When multiple rules match the same URL, Brave uses this precedence:

1. **`$discard`** wins over everything
2. **`$boost`** wins over `$downrank`
3. More specific rules (longer patterns) win over less specific ones

If one rule says `$downrank=3,site=example.com` and another says `$boost=2,site=example.com`, the boost wins. But `$discard,site=example.com` always wins.

### 4. URL Length Limits Are Real

Brave docs explicitly warn: "For complex Goggles with many rules, use hosted files instead of inline specifications. URL length limits can restrict the number of rules you can include inline."

For agent use with `--goggles`, we're passing inline rules. Practical limit is ~15-20 rules before URL encoding pushes past browser/HTTP limits. This means the agent should:
- Keep inline goggles focused (5-15 rules)
- Use `$discard` strategically rather than listing every spam domain
- For broad filtering, combine `$discard` with a few `$boost` rules

### 5. Hosted Goggles URLs Work via API

The API accepts both inline rules AND URLs to hosted `.goggle` files. Our implementation currently only supports inline rules. Could reference pre-built hosted goggles for complex filters:

- `https://raw.githubusercontent.com/brave/goggles-quickstart/main/goggles/copycats_removal.goggle` — 189 StackOverflow/GitHub copycat domains
- `https://raw.githubusercontent.com/brave/goggles-quickstart/main/goggles/hacker_news.goggle` — 6,238 domains popular on HN (boosted)
- `https://raw.githubusercontent.com/brave/goggles-quickstart/main/goggles/no_pinterest.goggle` — all Pinterest domains

### 6. The SEO Spam Landscape (Community Consensus)

Cross-referencing Kagi's most-blocked domains, Bobby Hiltz's "16 Companies" research, Brave's copycats_removal goggle, and the Super SEO Spam Suppressor project, there are clear tiers:

#### Tier 1: Programming SEO Spam

Two distinct categories that get conflated:

**Actual SO/GitHub translation scrapers** (targeted by Brave's copycats_removal.goggle — 189 domains): These are sites that machine-translate or scrape StackOverflow/GitHub content verbatim. Examples: newbedev.com, stackoom.com, githubmemory.com, githubplus.com, giters.com, bleepcoder.com, awesomeopensource.com, opensourcelibs.com, reposhub.com, codeflow.site, code-examples.net. The full list is in the copycats_removal.goggle.

**SEO tutorial farms** (NOT in copycats_removal — these produce original but low-quality content): w3schools.com, geeksforgeeks.org, tutorialspoint.com, javatpoint.com, programiz.com, educba.com, programcreek.com. These are not "copycats" per Brave's definition — they have original (if shallow) content. Still worth discarding/downranking for serious programming queries.

**General tech spam:** blog.csdn.net, kknews.cc, lightrun.com, solveforum.com, otosection.com, drivereasy.com, 9to5answer.com, appsloveworld.com, codegrepper.com

#### Tier 2: Media Conglomerates (SEO-optimized listicles)

Bobby Hiltz identified 16 parent companies behind 562 brands that dominate Google results. Key domains an agent should know to downrank for product/review queries:

- **Dotdash Meredith (IAC):** investopedia.com, thespruce.com, lifewire.com, verywellhealth.com, simplyrecipes.com, treehugger.com, tripsavvy.com, byrdie.com, thebalancemoney.com
- **Fandom/GameSpot:** fandom.com, gamespot.com, metacritic.com, tvguide.com
- **Ziff Davis:** pcmag.com, mashable.com, lifehacker.com, offers.com, techbargains.com, speedtest.net, ign.com, zdnet.com
- **Gamer Network:** eurogamer.net, rockpapershotgun.com, vg247.com, dicebreaker.com
- **Hearst:** esquire.com, cosmopolitan.com, goodhousekeeping.com, popularmechanics.com
- **Condé Nast:** wired.com, newyorker.com, pitchfork.com, gq.com, teenvogue.com, self.com

These aren't always bad — but they dominate search results disproportionately due to domain authority, often with thin/auto-generated content.

#### Tier 3: General Noise (Kagi most-blocked)

pinterest.com, quora.com, medium.com, linkedin.com, facebook.com, twitter.com/x.com, tiktok.com, amazon.com, wikihow.com, webmd.com, healthline.com, forbes.com

These are legitimate sites but frequently pollute results when searching for technical/research content.

### 7. High-Value Authoritative Domains

From Brave's hacker_news.goggle (6,238 domains popular on HN), the narwhalizer tool (Reddit-signal-based goggle generator), and general community consensus:

**Programming:** docs.python.org, docs.rust-lang.org, doc.rust-lang.org, docs.rs, developer.mozilla.org, stackoverflow.com, github.com, realpython.com, docs.djangoproject.com, nodejs.org, typescriptlang.org, go.dev

**Research/Academic:** arxiv.org, dl.acm.org, biorxiv.org, scholar.google.com, papers.ssrn.com, eprint.iacr.org, usenix.org

**Quality Tech Content:** lwn.net, arstechnica.com, lobste.rs, news.ycombinator.com, simonwillison.net, jvns.ca, danluu.com, rachelbythebay.com, blog.codinghorror.com, joelonsoftware.com, martinfowler.com

**Discussion/Signal:** news.ycombinator.com, reddit.com (subreddit-specific), lobste.rs

### 8. HN Community Signals

From the main Goggles launch thread (494 points, 264 comments, item 31837986):

- **Strongest signal:** "No Pinterest" was the most celebrated use case. Users desperate to filter content farms
- **Key insight from Brave engineer (pythux):** Goggles operate on the "expanded recall set" (tens of thousands of URLs), not the full index. This means rules have real impact but can't surface content that isn't already in the recall set for a query
- **Multiple goggles:** Can't combine multiple goggles yet (as of Brave's last statement). For agent use, we compose one combined inline goggle
- **Narwhalizer tool:** Generates goggles from subreddit submission domains — use subreddit popularity as a quality signal. HN user alxjsn built this specifically because "applying rules client-side doesn't work well on a small search result set"
- **`$boost` is multiplicative:** `$boost=2` makes a result "two times more important", `$boost=1` is neutral (no change from natural ranking)
- **The copycats_removal goggle was immediately popular** — StackOverflow/GitHub scrapers are the most hated category

### 9. What We're Missing vs Kagi

Kagi's domain insights (kagi.com/stats) show community-voted domain preferences. Their most-blocked list correlates strongly with what we should `$discard`. Their most-promoted list correlates with what we should `$boost`. We can't access these programmatically, but the flamedfury combined list captures both.

## Recommendations for SKILL.md

### 1. Restructure Goggles Recipes by Use Case

Instead of generic examples, give the agent task-specific recipes:

- **Programming search** — discard copycats, boost official docs
- **Research/academic** — boost arxiv/papers, discard SEO
- **Current events** — boost news sources, discard social media noise
- **Product reviews** — discard media conglomerate listicles

### 2. Document Advanced Syntax

Add `/path/` patterns, wildcards, anchors, and the caret separator. These let the agent write more precise goggles. Example: `/docs/$boost=3` boosts any URL with `/docs/` in the path — works across all documentation sites without listing each one. Note: `$intitle`, `$incontent`, etc. are listed in some community docs but remain unimplemented per official Brave sources.

### 3. Explain the `$discard` + `$boost=1` Allow-List Pattern

This is the most powerful pattern and must be front and center.

### 4. Keep Inline Goggles Focused

Warn the agent to use 5-15 rules max inline. For the most common use case (programming search), a compact set of rules is more reliable than an exhaustive spam list.

### 5. Consider Adding Hosted Goggle URL Support

Our `llm-context.js` could accept a URL to a hosted `.goggle` file instead of inline rules. This would let us reference Brave's copycats_removal.goggle or custom-hosted goggles with hundreds of rules. Low priority but worth noting.

### 6. Don't Over-Filter

Key lesson from the HN thread: `$discard` is aggressive. Overuse narrows results too much. For most searches, `$downrank` for noise + `$boost` for quality is better than mass `$discard`. Reserve `$discard` for:
- Known copycat/scraper sites
- Pinterest (universally hated in search)
- Sites that never produce useful content for the query type

## Sources

- Brave Goggles API docs: api-dashboard.search.brave.com/documentation/resources/goggles
- brave/goggles-quickstart repo: github.com/brave/goggles-quickstart
- HN thread 31837986: "Brave Search Goggles" (494 pts, 264 comments)
- HN thread 32599269: narwhalizer / subreddit-based goggles
- HN thread 39013497: "Is Google Getting Worse?" (276 pts, 274 comments)
- rjaus/awesome-goggles: github.com/rjaus/awesome-goggles
- Bobby Hiltz "16 Companies": bobbyhiltz.com/posts/2024/02/seoshenanigans/ + codeberg.org/bbbhltz/16CompaniesFilters
- NotaInutilis/Super-SEO-Spam-Suppressor: github.com/NotaInutilis/Super-SEO-Spam-Suppressor
- flamedfury Kagi block list: paste.flamedfury.com/flamedfury-kagi-block-list
- Kagi domain stats: kagi.com/stats (66k members as of Feb 2026)
- forcesunseen/narwhalizer: github.com/forcesunseen/narwhalizer
