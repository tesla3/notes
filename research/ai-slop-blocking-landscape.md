← [Index](../README.md)

# The AI Slop Blocking Landscape (Feb 2026)

How the web is fighting back against AI-generated content farms, and why most approaches are losing.

## Context: The Scale of the Problem

- "Slop" was Merriam-Webster's and the American Dialect Society's 2025 Word of the Year.
- AI-generated articles now make up **>50% of all English-language content on the web** (Graphite, SEO firm, 2025).
- Mentions of "AI slop" across the internet increased **9x from 2024 to 2025**, with negative sentiment peaking at 54% in October 2025 (Meltwater).
- YouTube removed **4.7 billion AI-content views** and banned 16 top AI channels in 2025–26 (CEO Neal Mohan's 2026 letter).
- ~5% of newly created English Wikipedia pages in a single month contained AI-generated text (Princeton, Oct 2024).

Sources: [Wikipedia – AI Slop](https://en.wikipedia.org/wiki/AI_slop), [Euronews](https://www.euronews.com/next/2025/12/28/2025-was-the-year-ai-slop-went-mainstream-is-the-internet-ready-to-grow-up-now), [CNN](https://www.cnn.com/2025/12/16/business/anti-ai-backlash-nightcap)

---

## Taxonomy of Approaches

The responses to AI slop cluster into five categories, from individual to systemic.

### 1. Domain-Level Blocklists (uBlock Origin / uBlacklist)

The most mature and widely-used client-side approach. These manually curated lists block entire domains or URL patterns from loading or appearing in search results.

| Project | Stars | Scope | Mechanism | Philosophy |
|---------|-------|-------|-----------|------------|
| **[laylavish/HUGE-AI-Blocklist](https://github.com/laylavish/uBlockOrigin-HUGE-AI-Blocklist)** | ~5.2k | 1000+ domains | uBlock Origin + uBlacklist + Pi-hole/AdGuard hosts file | Broad: blocks all sites hosting AI content, including ChatGPT, Midjourney |
| **[alvi-se/ai-ublock-blacklist](https://github.com/alvi-se/ai-ublock-blacklist)** | New | Smaller, growing | uBlock Origin `$doc` rules | Narrow: blocks only AI content *farms*, not legitimate AI tools |
| **[Stevoisiak/GenAI-Blocklist](https://github.com/Stevoisiak/Stevos-GenAI-Blocklist)** | Growing | UI elements | uBlock Origin cosmetic filters | Blocks AI *features* on sites you use (Google AI Overviews, GitHub Copilot buttons, Grok, Amazon Rufus, Reddit Answers) |
| **[wdmpa/content-farm-list](https://github.com/wdmpa/content-farm-list)** | Smaller | Content farms | uBlacklist | Generic content farm blocking |
| **[agsimmons/ai-content-blocklist](https://github.com/agsimmons/ai-content-blocklist)** | Smaller | AI news/answers | uBlacklist | Blocks AI-generated content but not *discussion of* AI |
| **[awesome-ublacklist](https://github.com/rjaus/awesome-ublacklist)** | Meta-list | N/A | uBlacklist subscriptions | Compilation of community blocklists across categories |

**Key distinctions:**
- **laylavish** = broadest reach, blocks everything AI-related from search. Most popular by far. Risk: legitimate tools blocked.
- **alvi-se** = focused on content farms only, but governance issues (see [HN distillation](hn-ai-ublock-blacklist.md)). AP News was accidentally added via bulk import.
- **Stevoisiak** = different problem entirely — removes AI UI widgets from *real* sites (Google, GitHub, Amazon), not blocking whole domains.

**Strengths:** Immediate, user-controlled, composable (stack multiple lists), works across browsers and even mobile (uBlacklist on iOS Safari). Auto-updates from GitHub.

**Weaknesses:**
- *Write-only*: no expiry, re-review, or removal process. Domains that change hands stay blocked forever.
- *Maintainer burnout*: single-person projects. The alvi-se list hasn't been updated in months; laylavish depends on one contributor.
- *False positives compound*: bulk imports from third-party sources introduce errors (AP News example).
- *Selection pressure*: forces content farms to become less detectable over time.
- *Geographic bias*: alvi-se skews Italian; others skew English-language.

**Verdict:** Effective palliative for power users. Won't scale to the general population. Follows the exact trajectory of email RBLs (SORBS, MAPS, Spamhaus) in the early 2000s — combative solo maintainers → professionalization → industry consolidation. Expect EasyList/AdGuard to absorb the best community lists within 1–2 years, or the lists to die.

---

### 2. Content-Level Detection Extensions

These don't block domains — they scan page content and try to identify AI-generated text in real time using pattern matching or heuristics.

| Tool | Approach | Platforms |
|------|----------|-----------|
| **[DeSlop](https://github.com/HxHippy/DeSlop)** | Three-tier weighted pattern matching (600+ patterns). Assigns "slop score" per post/article. Configurable sensitivity 1–5. | LinkedIn, Twitter/X, Medium, generic sites |
| **[AI Content Shield](https://addons.mozilla.org/en-US/firefox/addon/ai-content-shield/)** | Blocks AI-tagged content, AI voices (Pro), AI features across platforms. Freemium model. | YouTube, Google, X, Facebook, Instagram, Reddit, Pinterest, Amazon, eBay |
| **[BotBlock](https://botblock.ai/)** | Community-powered bot detection specifically for X/Twitter replies. | X/Twitter only |
| **[SkipSlop](http://skipslop.com/)** | AI slop detection across streaming and social platforms. Labels/skips content. | Multi-platform |
| **[tropes.fyi/aidr](https://tropes.fyi/aidr)** | Identifies AI writing tropes, reconstructs the probable prompt. More diagnostic than blocking. | Web text analysis |

**DeSlop is the most interesting technically.** Its detection tiers:
- **Tier 1 (always active):** Signature AI phrases — "delve into", "navigate the landscape", "tapestry of", em dash overuse, "In today's fast-paced world..."
- **Tier 2 (sensitivity 3+):** Corporate buzzwords — "synergy", "leverage", "thought leadership"
- **Tier 3 (sensitivity 4+):** Marketing spam — "guaranteed", "revolutionary", "mind-blowing"

Scoring: sensitivity 1 = 15-point threshold (only obvious AI); sensitivity 5 = 4-point threshold (nuclear).

Also includes a "Slop Machine" gamified learning tool and an interactive checker where you paste text to see what triggers.

**Strengths:** Works on content regardless of domain reputation. Catches AI text on otherwise-legitimate sites. DeSlop's open pattern system is extensible.

**Weaknesses:**
- *Pattern matching is fundamentally fragile.* 600 patterns sounds impressive but is trivially evaded once content farms learn the list. Same arms race problem as domain blocklists, but faster.
- *False positives on humans who write like AI.* Corporate communications, PR, marketing — much human writing is indistinguishable from AI slop by pattern matching. LinkedIn is already hard to distinguish.
- *No ML component.* None of these use actual AI detection models (which themselves have terrible accuracy — see Originality.ai's ~random performance on sophisticated text).
- *Freemium creep.* AI Content Shield already has a Pro tier. Extension economics push toward either abandonment or subscription.

**Verdict:** Fun toys, genuinely useful on LinkedIn. Not a serious solution. DeSlop's pattern list is more valuable as a *writing guide* ("don't use these phrases if you want to sound human") than as a detector.

---

### 3. Temporal Filtering

The bluntest instrument: filter by date.

**[Slop Evader](https://tegabrain.com/Slop-Evader)** (Chrome/Firefox) — Restricts Google searches to content published before November 30, 2022 (ChatGPT's release date). Created by Australian artist/tech critic Tega Brain. Got significant media coverage (404 Media, Fast Company, The Register, CNN, Digital Trends).

Technically trivial — just appends Google's `tbs=cdr:1,cd_max:MM/DD/YYYY` parameter. But conceptually sharp: it's a statement that the pre-GPT web was a fundamentally different (and better) information environment.

**Strengths:** Zero false positives for AI content. Simple, transparent mechanism. Makes a strong rhetorical point.

**Weaknesses:** Absurdly overbroad. Excludes all human-written content from the last 3+ years. Useless for current events, new software docs, recent research. More art project than practical tool.

**Verdict:** Useful as provocation, not as infrastructure. But the underlying insight — "date is the single most reliable signal for AI content" — is underappreciated. A more nuanced version (weight older content higher, flag post-2022 content from unknown domains) could be genuinely useful.

---

### 4. Platform-Side Responses

**Google** is the most important player here, since content farms exist to rank in Google.

- **March 2024 Core Update:** Targeted "scaled content abuse" (mass-produced content for rankings, whether AI or human), expired domain abuse, and site reputation abuse ("parasite SEO"). Google claimed the update would reduce unhelpful content by 40%. Manual penalties deindexed hundreds of sites overnight.
- **January 2025 Quality Rater Guidelines:** Raters can now assign the *lowest score* to "automated or AI-generated content." But these are manual reviews — millions of pages are generated daily.
- **2026 stance:** Google won't ban AI content per se (they're an AI company), but "lazy AI content is fatal to SEO." The winning formula is described as "AI Draft + Human Polish + Unique Insight" (industry consensus, not Google's official language).

**YouTube:**
- Mandatory AI disclosure labels ("synthetic content") for creators.
- 4.7B AI-content views removed, 16 top AI channels banned (Mohan, Jan 2026).
- Updated monetization rules: low-quality AI content ineligible for monetization.

**Wikipedia:**
- [WikiProject AI Cleanup](https://en.wikipedia.org/wiki/Wikipedia:WikiProject_AI_Cleanup) — volunteer editors flag and fix AI-generated articles.
- Princeton found ~5% of new English Wikipedia pages in one month contained AI text. But Wikipedia's volunteer-editor "immune system" catches most of it.
- Different language Wikipedias have different processes — some use AI detection tools, others rely on human review.

**Assessment:** Google's March 2024 update was real and hurt real content farms. But the cat-and-mouse game continues. The fundamental incentive problem remains: Google profits from ad-supported search, and content farms exist because Google's ranking algorithm can still be gamed. Manual quality ratings don't scale to millions of new AI pages per day.

---

### 5. Authenticity Certification ("Fingerprint the Real")

The newest and potentially most transformative approach: instead of detecting fakes, *prove what's real*.

**C2PA (Coalition for Content Provenance and Authenticity)**
- Open technical standard for tracking the origin and edit history of digital content.
- Members include Adobe, Microsoft, Intel, BBC, Sony, Nikon, Canon.
- Works via cryptographic signatures embedded in media files. Each edit preserves the provenance chain.
- Fully applicable under EU AI Act from August 2026.
- Content Authenticity Initiative (CAI) provides open-source tools.
- **Limitation:** Works for photos/video (EXIF data, camera signatures). Unclear how to "fingerprint" human-written text or audio.

**Instagram/Mosseri's "Fingerprint the Real" Proposal (Jan 2026)**
Adam Mosseri (Instagram CEO) posted on Threads: "It will be more practical to fingerprint real media than fake media." Proposes verifying authenticity markers — author history, posting patterns, EXIF data — rather than chasing AI watermarks.

**"Guaranteed Human" Marketing Movement**
- iHeartMedia: "guaranteed human" tagline, no AI-generated personalities or music. 90% of listeners want human-created media.
- The Tyee (Canadian news): formal no-AI editorial policy.
- Hollywood: "This show was made by humans" credits (Vince Gilligan's "Pluribus" on Apple TV).
- Predictions of "premium tiers for verified human content by late 2026."

**EU AI Act Requirements**
- Providers must mark AI-created/manipulated content in machine-readable format.
- Deepfakes and AI content in public interest require clear labeling.
- Draft practical code published Dec 2025, to be finalized mid-2026.
- California AB 2015 (2025): AI image/video labeling in election contexts.

**Assessment:** This is the correct long-term direction. Detecting AI content is a losing arms race; authenticating human content is a tractable problem (at least for media with physical-world provenance — cameras, microphones). The gap is *text*: there's no equivalent of EXIF data for human writing. Until that's solved, text-based slop will remain the hardest to address.

---

## What's Actually Working (and What Isn't)

### Working
1. **Google's manual penalties + ranking changes.** Deindexing sites overnight has real consequences. The March 2024 update measurably improved search quality.
2. **uBlock Origin domain lists** for power users who curate their own stack. The laylavish list with 5.2k stars indicates real demand and real usage.
3. **UI widget blockers** (Stevoisiak) — removing Google AI Overviews, GitHub Copilot buttons etc. is a clean, low-false-positive use case.
4. **Platform-level policy** (YouTube's monetization rules, Wikipedia's AI Cleanup project) — removing economic incentives works better than technical detection.

### Not Working
1. **AI text detection.** Both heuristic (DeSlop's patterns) and ML-based (Originality.ai et al.) approaches have accuracy problems that make them unreliable at scale. Sophisticated AI text is indistinguishable from polished human writing.
2. **Temporal filtering.** Slop Evader is art, not infrastructure.
3. **Solo-maintained blocklists without governance.** The alvi-se list demonstrated every failure mode within weeks of gaining attention.
4. **"Block everything AI-related" maximalism.** laylavish blocks ChatGPT, which is like blocking the telephone because telemarketers use it.

### Too Early to Tell
1. **C2PA / content provenance.** Technically sound, but adoption is fragmented. Needs browser-native support and a critical mass of publishers.
2. **"Guaranteed Human" premium branding.** iHeartMedia is a bellwether. If their listener numbers hold, expect imitation. If not, it's marketing fluff.
3. **EU AI Act enforcement.** Regulations exist on paper. Enforcement begins Aug 2026. Track record of EU tech enforcement is mixed.

---

## The Meta-Pattern

The AI slop blocking ecosystem in 2026 recapitulates three historical precedents:

1. **Email spam (late 1990s–2000s):** Solo-maintained RBLs (MAPS, SORBS, Spamhaus) → professionalization → ISP/platform absorption → near-complete server-side solution (Gmail spam filter). Timeline: ~15 years.

2. **Ad blocking (2010s):** Hobbyist filter lists (EasyList, Fanboy) → browser extension ecosystem (uBlock Origin, AdBlock Plus) → platform response (acceptable ads, anti-adblock) → ongoing arms race. Timeline: ongoing, ~12 years.

3. **SEO spam (2000s–2010s):** Keyword stuffing → Google penalties → content farms (Demand Media, eHow) → Panda update (2011) → brief improvement → new spam techniques. Timeline: cyclical.

The AI slop arms race will likely follow the email spam trajectory: client-side tools provide temporary relief, but the real solution comes when platforms (Google, social networks) internalize the filtering. The C2PA / authenticity direction suggests we might skip the worst of the arms race by changing the game from "detect fakes" to "verify originals."

**The uncomfortable truth:** None of the client-side tools — blocklists, pattern detectors, temporal filters — can keep pace with AI content generation. They exist because Google and social platforms have failed at their core job of quality curation. The tools are symptoms of institutional failure, not solutions to the underlying problem.

---

## Sources

- [laylavish/uBlockOrigin-HUGE-AI-Blocklist](https://github.com/laylavish/uBlockOrigin-HUGE-AI-Blocklist) (GitHub, 5.2k stars)
- [alvi-se/ai-ublock-blacklist](https://github.com/alvi-se/ai-ublock-blacklist) (GitHub)
- [Stevoisiak/Stevos-GenAI-Blocklist](https://github.com/Stevoisiak/Stevos-GenAI-Blocklist) (GitHub)
- [HxHippy/DeSlop](https://github.com/HxHippy/DeSlop) (GitHub)
- [Slop Evader](https://tegabrain.com/Slop-Evader) (Tega Brain)
- [AI Content Shield](https://addons.mozilla.org/en-US/firefox/addon/ai-content-shield/) (Firefox Add-ons)
- [awesome-ublacklist](https://github.com/rjaus/awesome-ublacklist) (GitHub)
- [C2PA Specification](https://c2pa.org/) / [Content Authenticity Initiative](https://contentauthenticity.org/)
- [Google March 2024 Core Update](https://developers.google.com/search/blog/2024/03/core-update-spam-policies) (Google)
- [AI Slop – Wikipedia](https://en.wikipedia.org/wiki/AI_slop)
- [CNN: Why 2026 could be the year of anti-AI marketing](https://www.cnn.com/2025/12/16/business/anti-ai-backlash-nightcap)
- [TechRadar: AI Slop won in 2025 — fingerprinting real content](https://www.techradar.com/ai-platforms-assistants/ai-slop-won-in-2025-fingerprinting-real-content-might-be-the-answer-in-2026)
- [Euronews: 2025 was the year AI slop went mainstream](https://www.euronews.com/next/2025/12/28/2025-was-the-year-ai-slop-went-mainstream-is-the-internet-ready-to-grow-up-now)
- [Wikipedia vs. AI Slop (Rest of World)](https://restofworld.org/2026/wikipedia-ai-training-regional-languages/)
- [Animalz: Google's March 2024 Search Update](https://www.animalz.co/blog/google-march-2024-update-ai-generated-content)
- [SkipSlop](http://skipslop.com/)
- [BotBlock](https://botblock.ai/)
