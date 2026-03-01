← [Search API Comparison](search-api-comparison-brave-kagi-google.md) · [Index](../README.md)

# Kagi Search: Deep Evaluation

**Date:** 2026-03-01
**Sources:** Kagi blog posts, Wikipedia, Ars Technica, The Verge, Nieman Lab, HN threads, Reddit (r/privacy, r/ukraine, r/degoogle, r/SearchKagi), user reviews (cyprien.io, oli.fyi, khevans.com), TWiT interview, Momor market data, nanovms container security research.

---

## Executive Summary

Kagi is the best consumer search engine available today for quality-of-results, and its incentive alignment (user-funded, no ads) is structurally superior to every competitor. It is also a company with ~65,000 subscribers, ~50 employees, razor-thin margins, existential dependency on indexes it doesn't own, a CEO who handles controversy poorly, and a product expansion strategy (browser, translate, news, AI assistant) that looks like scope creep for a company its size. The product deserves the enthusiast praise it gets. The business deserves more scrutiny than it gets.

---

## 1. Company & History

- **Founded:** 2018 by Vladimir Prelovac (Serbian-born, Palo Alto-based)
- **Public launch:** June 2022
- **Legal structure:** Public Benefit Corporation (since 2024)
- **Funding:** Bootstrapped. ~$3M self-investment by Prelovac, two equity rounds sold to Kagi users directly. No VC money.
- **Employees:** ~50 (as of late 2025)
- **Subscribers:** ~50,000 as of June 2025, ~65,000 as of mid-2026 estimate (Momor data). Growth from 25,000 in Jan 2024 → 50,000 in June 2025 → ~65,000 by early 2026.
- **Daily searches:** ~845,000 (June 2025), approaching 1M by late 2025
- **Profitability:** Claimed profitable as of mid-2024. TWiT (late 2025) describes them as "breaking even." The gap between these two statements is telling — they likely oscillate around breakeven as they hire and expand.
- **Key people:** Vladimir Prelovac (CEO), Raghu Murthi (co-author of key blog posts), Dr. Norman Winarsky (advisor)

### Vlad Prelovac: The Founder Factor

Prelovac is the company. His personal vision drives everything — the ad-free model, the PBC charter, the refusal to take VC, the Yandex stance. He's articulate about the mission and clearly technically competent (ex-WordPress ecosystem, built Arc the Lisp dialect... no wait, that's PG). He's a product visionary in the mold of DHH or Pieter Levels — opinionated, independent, willing to sacrifice growth for principles.

The downside: he handles public controversy badly. The Yandex incident (see §5) showed a pattern of dismissiveness toward user concerns, framing ethical objections as "geopolitical issues" he doesn't "discriminate" on. This alienated vocal privacy-focused users — exactly his core demographic. He later scrubbed the search sources page rather than addressing the concern transparently. The word "combative" appears in multiple independent accounts of his HN and Discord interactions on sensitive topics.

**Assessment:** Founder-driven companies live and die by the founder's judgment. Prelovac's product judgment is excellent. His political and communications judgment is mediocre. For a privacy-focused product, that gap matters.

---

## 2. Product: What It Actually Is

### Core Search

Kagi is a **metasearch engine** — it aggregates results from multiple indexes and re-ranks them. Sources include:

| Source | Type | Status |
|--------|------|--------|
| Google | SERP results via third-party APIs (not direct license) | Active, indirect |
| Brave Search | Direct license | Active |
| Mojeek | Direct license | Active |
| Yandex | Direct license | Active (controversial) |
| Wikipedia | Direct license | Active |
| Apple | Direct license | Active |
| Wolfram Alpha | Direct license | Active |
| Yelp, TripAdvisor | Direct license | Active |
| Teclis (own crawler) | Proprietary, small-web focused | Active, limited scope |
| TinyGem (own news index) | Proprietary | Active |

**Critical fact:** Kagi does NOT have direct access to Google or Bing indexes. Google offers no public search API on FRAND terms. Bing retired its Search APIs in August 2025. Kagi accesses Google results through third-party SERP API providers (the same ones used by Nvidia, Stanford, Adobe). Google sued SerpApi in December 2025 for scraping. If Google succeeds in shutting down these providers, Kagi loses access to the most comprehensive search index in the world.

Kagi's own index (Teclis) is small-web focused — personal blogs, forums, niche sites. It is not a general web index. The company explicitly acknowledges this: "Building a comparable [index] from scratch is like building a parallel national railroad."

### Key Features

1. **Domain blocking/boosting** — The killer feature. Block Pinterest, boost Stack Overflow, pin GitHub. Persists across searches. Community stats show most-blocked/most-raised domains publicly.
2. **Lenses** — Pre-built or custom search filters. Academic, Programming, Discussions, Small Web, News360. Genuinely useful for focused research.
3. **No ads, ever** — Not just "ad-free by default" like Brave. Structurally impossible because the business model doesn't allow it.
4. **Quick Answer AI** — Opt-in AI summary at the top of results. Click to expand, not forced. Well-cited with footnotes. Uses multiple LLM providers anonymously.
5. **Universal Summarizer** — Paste any URL, get a summary. Works on PDFs, videos.
6. **Bangs** — DDG-style shortcuts (!g for Google, !yt for YouTube).
7. **Privacy Pass** — Implemented in 2025. Cryptographic protocol that lets you authenticate as a paying user without being identifiable. Also available via Tor.
8. **Lightweight pages** — ~150KB vs Google's ~1.5MB. Fast even without JavaScript.

### Adjacent Products

- **Orion Browser** — WebKit-based macOS/iOS browser supporting both Chrome and Firefox extensions. Still in beta. Buggy per user reports. Linux development started March 2025.
- **Kagi Translate** — Free, no account needed. Aims to beat Google Translate/DeepL. Too early to evaluate quality at scale.
- **Kagi News** — AI-powered daily news summary from open-source RSS feeds. Free, no account needed. Launched September 2025.
- **Kagi Assistant** — Multi-model AI chatbot (Claude, ChatGPT, etc.) available to all users since April 2025. $25/mo tier gets premium models. Usage capped at $25 worth of AI per month.
- **Kagi Maps** — Based on Mapbox + OpenStreetMap. Privacy-respecting alternative to Google Maps.

### Pricing

| Plan | Cost | Searches | AI Access |
|------|------|----------|-----------|
| Trial | Free | 100 total | Limited |
| Starter | $5/mo | 300/mo | Standard models |
| Professional | $10/mo | Unlimited | Standard models |
| Ultimate | $25/mo | Unlimited | Premium models (Claude, GPT-4o) |

**Unit economics back-of-envelope:** 65,000 subscribers × ~$12 average (mix of tiers) = ~$780K/mo = ~$9.4M ARR. 50 employees at ~$120K average fully loaded = ~$6M/yr. Leaves ~$3.4M for infrastructure, API costs, and everything else. This is tight. Very tight. One bad quarter of churn or an API cost increase could flip them to cash-negative.

---

## 3. Search Quality: The Honest Assessment

### Where Kagi Wins

- **Technical/programming queries:** Consistently surfaces developer docs, Stack Overflow, quality blog posts over SEO farms. Multiple reviewers cite this as the single biggest improvement over Google.
- **Product research/shopping:** No ads means no sponsored results polluting comparisons. Listicles are grouped to reduce noise. HouseFresh (independent air purifier review site killed by Google's SEO) ranks #1 on Kagi for relevant queries where it's buried on page 7 of Google.
- **Privacy:** Zero telemetry, Privacy Pass protocol, Tor support. Not just "we promise not to track" — structurally designed for it.
- **Customization:** Domain blocking eliminates entire categories of noise permanently. The user who blocks Pinterest, Quora, Medium, and Forbes gets a structurally different (better) search experience.
- **Speed:** Results in 0.2-0.8 seconds. Pages are light.

### Where Kagi Loses

- **Local/maps:** Google is unbeatable. Kagi Maps is embryonic by comparison.
- **Non-English/non-US queries:** Multiple users (Brazil, France, Eastern Europe) report significantly worse results for local-language searches. Kagi's index sources are Western-centric.
- **Esoteric/deep web:** Google's index is simply larger. That one email address that only appears on one archived blog post — Google finds it, Kagi doesn't.
- **Reddit results:** Google has an exclusive indexing deal with Reddit. Kagi routes through sources that can access Reddit indirectly, but the depth is not equivalent.
- **Mobile integration:** iOS requires installing a Safari extension to use Kagi as default search. This is Apple's fault, not Kagi's, but it's a real friction point. No native Android integration either.

### Where It's a Wash

- **General information queries:** "Who played X in Y," factual lookups, Wikipedia-adjacent stuff. Both Google and Kagi get these right. Kagi just does it without the visual noise.
- **News:** Comparable. Kagi's dedicated news tab and podcast tab are nice touches.

### The Honest Verdict on Quality

Kagi is not better than Google at *finding things*. It is better than Google at *showing you what it finds*. The difference is entirely in presentation, ranking, and absence of commercial interference. For 90%+ of daily searches, this is enough to feel dramatically better. For the remaining edge cases — local, multilingual, deep archival — you'll still !g to Google.

Dan Luu's comparative analysis (the most rigorous I've found) found Kagi competitive with Google and ahead of Bing, Marginalia, and Mwmbl for most query types, with neither being clearly dominant across all categories.

---

## 4. Structural Risks

### Risk 1: Index Dependency (Critical)

Kagi's entire value proposition depends on aggregating indexes it doesn't own. The two that matter most:

- **Google:** Accessed through third-party SERP providers, not a direct license. Google sued SerpApi in Dec 2025. If Google successfully shuts down SERP providers, Kagi loses its best source.
- **Bing:** Already dead. Microsoft retired Bing Search APIs in Aug 2025.

The DOJ antitrust remedy (Sept 2025) theoretically requires Google to offer index syndication to "Qualified Competitors" on FRAND terms. Kagi is betting heavily on this — their Jan 2026 blog post "Waiting for Dawn in Search" is essentially a public letter to the court. But:

- Google will appeal and delay. Final enforceable terms are years away.
- Even if mandated, Google controls the quality and timeliness of syndicated data.
- The remedy has a 6-year duration. Google can wait it out.

**If the DOJ remedy fails or is watered down, Kagi has no plan B.** Their own index (Teclis) is small-web only. They cannot build a full web index — Microsoft spent $100B on Bing and still has single-digit share.

### Risk 2: Scale Economics (High)

65,000 subscribers is impressive for a bootstrapped search engine. It's also approximately 0.0007% of Google's user base. At $10/mo average:

- Revenue is ~$9M ARR
- 50 employees cost ~$6M+
- API costs (Google SERP access, LLM providers for AI features) eat a significant portion of the remainder
- Infrastructure for indexing, crawling, serving searches adds more

They claimed profitability in mid-2024, but by late 2025 TWiT described them as "breaking even." The likely truth: they're profitable at current headcount when they don't invest in growth, and cash-negative when they do. This is the classic bootstrapped company tightrope.

Growth from 25K → 50K → 65K over 2 years is ~30% annual growth. Healthy, but they need this to sustain. Any of the following could break it:
- Google offering an ad-free search tier (eliminates core differentiator)
- API cost increases from upstream providers
- A security breach or privacy incident
- Prelovac doing something controversial enough to trigger mass cancellations

### Risk 3: Scope Creep (Medium)

For a 50-person company, Kagi is running: a search engine, a browser (Orion, still in beta after years), a translation service, a news product, an AI assistant, and maps. This is what Google does with 180,000 employees. Every product beyond core search dilutes engineering focus.

The AI Assistant is particularly questionable from a strategic standpoint. It puts Kagi in direct competition with OpenAI, Anthropic, and Google on AI — companies with 100-1000× their resources. The $25/mo Ultimate tier's value proposition is "access to all LLMs in one place," which is a thin moat that any aggregator can replicate.

### Risk 4: Yandex (Reputational)

See §5. The damage is already done. Every time Kagi gets mainstream press coverage, the Yandex issue resurfaces in comments. It's a permanent drag on adoption among the privacy-conscious users who are Kagi's core market.

---

## 5. The Yandex Controversy

**Timeline:**
1. Kagi has used Yandex as a search source since early days. This was documented on their search sources page.
2. In late 2024, users discovered/rediscovered that subscription revenue partially flows to Yandex, directly funding a Russian company with government ties, during Russia's invasion of Ukraine.
3. Users raised concerns on Discord, Reddit, HN, and Kagi's feedback forum.
4. Vlad Prelovac responded: "We do not discriminate based on current geopolitical issues." Described it as ~2% of total costs.
5. DuckDuckGo had already halted its Yandex partnership. Kagi refused to follow.
6. Kagi subsequently **scrubbed the search sources page** from their documentation, removing transparency about which indexes they use. (Confirmed by Wikipedia citations comparing archived vs current pages.)
7. The controversy resurfaced with every media appearance and HN thread throughout 2025-2026.

**Assessment:** Prelovac's position is intellectually defensible (Yandex provides unique results, especially for certain queries) but politically tone-deaf for a company whose brand is built on ethics and transparency. The scrubbing of the sources page is the worst part — it replaced transparency with opacity, exactly the behavior Kagi criticizes Google for. Multiple users on r/privacy, r/ukraine, and r/degoogle canceled subscriptions specifically over this. The HN thread on this was flagged but got 59 points before that.

The Ars Technica review (the most mainstream positive Kagi review) notes in its comment section that the Yandex situation is complicated — Yandex NV spun off Russian assets and became Nebius Group in 2024, so it's unclear whether Kagi's current deal is with Russian-controlled Yandex LLC or international Nebius. Kagi has not clarified this, which is itself a problem.

---

## 6. What the Enthusiast Consensus Gets Wrong

The HN/tech enthusiast consensus on Kagi is overwhelmingly positive, bordering on evangelical. This consensus has blind spots:

### "Kagi is independent"
It's not. It depends on Google results accessed through third-party SERP providers. If those go away, Kagi's quality drops dramatically. The Teclis small-web index cannot substitute.

### "Paying for search aligns incentives perfectly"
Mostly true, but the alignment is imperfect. Kagi's cost-per-search model means every search costs them money — creating an incentive to encourage *fewer* searches, not better ones. The $5/300 searches tier explicitly caps usage. The unlimited $10 tier is a blended bet that most users won't search heavily. Power users are subsidized by light users. This works until it doesn't.

### "50,000+ subscribers proves the model works"
It proves demand exists at small scale. It does not prove sustainability. At ~$9M ARR with 50 employees, they're not building reserves. One upstream disruption (Google SERP access loss, LLM cost spike) could be existential. The paid search market is inherently niche — there is a ceiling on how many people will pay $10/mo for search when free alternatives exist.

### "Kagi is private"
More private than Google, certainly. But: Kagi knows your billing information, and until Privacy Pass (2025), they could associate searches with accounts. Privacy Pass is a genuine improvement, but it's new and hasn't been extensively audited. And as HN skeptics note: if you click through Kagi results to sites with Google Analytics, you're still tracked. Kagi protects the search, not the browsing.

### "The $10/mo is cheap compared to what Google earns from you"
Kagi estimates Google earns $277/year per user. So $120/year for Kagi seems like a bargain. But this comparison is misleading — Google's $277 includes all services (Gmail, Maps, YouTube, Drive, Photos), not just search. The search-only comparison would be much lower. And most people don't *experience* paying Google, so the psychological barrier to paying Kagi is real regardless of the math.

---

## 7. Competitive Landscape (Feb 2026)

| Engine | Model | Index | Quality | Privacy | Price |
|--------|-------|-------|---------|---------|-------|
| **Google** | Ad-funded | Own (largest) | Best raw index, worst UX (ads, AI overviews) | None | Free |
| **Kagi** | Subscription | Aggregated (Google via SERP, Brave, Mojeek, Yandex, own small-web) | Best UX, comparable depth for 90% of queries | Strong (Privacy Pass, Tor) | $5-25/mo |
| **Brave Search** | Ad-funded (opt-out ads) | Own (30B+ pages, only independent Western index) | Good, weaker on local/non-English | Good | Free |
| **DuckDuckGo** | Ad-funded | Bing (just Bing in a duck hat) | Mediocre, users !g 15-80% of queries | Good (no tracking) | Free |
| **SearXNG** | Self-hosted | Meta (aggregates others) | Variable, depends on instances | Best (self-hosted) | Free |
| **Perplexity** | Subscription + ads | AI-first, sources from web | Different paradigm (answers, not links) | Poor (data collection) | $20/mo |
| **Startpage** | Ad-syndication from Google | Google results with privacy | Google quality, Google's ranking | Good (no tracking) | Free |

**Kagi's actual competitive position:** It's the best search experience available for people who will pay for it. That "who will pay for it" qualifier is the entire business risk. The addressable market for paid search is probably 1-5M users globally (tech-savvy, privacy-conscious, high-income, English-speaking). At 65K users, Kagi has captured ~1-6% of its addressable market. Growth is real but slow.

---

## 8. The DOJ Ruling: Kagi's Lifeline

The September 2025 DOJ remedy and December 2025 Judge Mehta memorandum are the most important external events for Kagi's future:

- **Mandatory syndication:** Google must offer query-based search syndication to "Qualified Competitors" on FRAND terms
- **No ad bundling:** Competitors can monetize via their own methods, not forced to show Google Ads
- **Index data access:** URLs, crawl metadata, spam scores at marginal cost
- **Duration:** 6 years, with 5-year syndication license terms

If implemented as written, this transforms Kagi from a company scraping Google through gray-market intermediaries to a company with legitimate, paid, stable access to Google's index. This would:
1. Eliminate the existential supply-chain risk
2. Reduce costs (direct licensing should be cheaper than SERP API providers)
3. Enable better integration (actual index data vs scraped SERP pages)
4. Provide legal certainty

**But:** Google is appealing. The DOJ and 35 states are counter-appealing to push for stronger remedies (DOJ originally wanted Chrome divestiture, which was rejected). This will take years. Kagi's Jan 2026 blog post reads as equal parts legal brief and prayer.

---

## 9. For Agent/API Use

Already covered in [search-api-comparison-brave-kagi-google.md](search-api-comparison-brave-kagi-google.md). Summary:

- **Search API:** Invite-only, v0 beta, $25/1k queries (5× Brave's price)
- **FastGPT API:** Public, but returns AI answers not search results
- **Universal Summarizer API:** Public, useful for content extraction
- **Web/News Enrichment API:** Public, exposes Teclis/TinyGem (small-web only)

**Verdict for agent use: No.** Brave's API is cheaper, more mature, publicly available, has the LLM Context endpoint, and owns its own full index. Kagi's API is a sidecar product, not a core offering.

---

## 10. Overall Verdict

**Product quality: 9/10.** The best search UX available. Domain customization, ad-free results, and clean design make it genuinely better for daily use. The praise is earned.

**Business sustainability: 5/10.** Razor-thin margins, existential dependency on upstream indexes, niche addressable market, founder risk. Profitable only in the sense that a tightrope walker is "on the rope." Everything depends on the DOJ ruling holding and Google not finding ways to undercut them.

**Trust: 6/10.** Privacy Pass is a real innovation. But the Yandex opacity, the scrubbed sources page, and Prelovac's dismissive handling of user concerns create a gap between Kagi's stated values and its practiced transparency.

**Strategic coherence: 5/10.** A 50-person company running search, a browser, translation, news, AI assistant, and maps is spreading too thin. Core search needs to be unassailable before expanding. Orion has been in beta for years. The AI assistant competes with giants.

**Recommendation:**
- **For personal search:** Worth the $10/mo if you search frequently, value privacy, and are tech-savvy enough to configure it. The first month will feel like time-traveling to 2010 Google. Set it as your default, use !g for edge cases.
- **For API/agent use:** No. Use Brave.
- **For long-term bet:** Uncertain. If DOJ remedies stick, Kagi has a stable future as a premium niche product. If Google successfully defends its index monopoly, Kagi is one SerpApi lawsuit away from an existential crisis.

---

## Sources

- Kagi Blog: "Waiting for Dawn in Search" (Jan 2026) — Prelovac & Murthi
- Kagi Blog: "What's Next for Kagi" (mid-2024) — profitability claim
- Wikipedia: Kagi (search engine) — factual baseline
- The Verge: "The future of search isn't Google" (Mar 2025) — David Pierce review
- Ars Technica: "Dumping Google's enshittified search" (Aug 2025) — Lee Hutchinson review
- Nieman Lab: "Testing Kagi, a premium search engine" (Apr 2025) — Neel Dhanesha
- TWiT: Vlad Prelovac interview (Aug 2025) — "breaking even with ~53,000 users and 50 employees"
- Momor: "Best Search Engines 2026" — subscriber growth estimate
- Reddit r/ukraine: Yandex funding controversy (Dec 2024)
- Reddit r/privacy: "Are there any alternatives to Kagi?" (Jul 2025)
- Reddit r/degoogle: User experience reports (Jan 2026)
- khevans.com: "Ethics of Kagi" (Aug 2025)
- cyprien.io: "My 6 months review of Kagi" (Jul 2025)
- HN threads: multiple (50K milestone, Yandex controversy, search comparison)
- Dan Luu: "How bad are search results?" — comparative analysis
