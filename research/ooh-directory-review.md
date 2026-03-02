← [Index](../README.md)

# ooh.directory — Critical Review

**Date:** 2026-03-01
**URL:** https://ooh.directory/
**Creator:** Phil Gyford (gyford.com)
**Launched:** November 2022
**Current size:** ~2,305 blogs across 12 top-level categories

---

## What It Is

ooh.directory is a human-curated blog directory — a throwback to the Yahoo/DMOZ era of web organization, applied specifically to blogs. It's a one-person hobby project by Phil Gyford, a veteran UK-based web developer with a decades-long track record of long-running personal web projects (most notably *The Diary of Samuel Pepys*, which he operated for 10+ years). The site catalogs blogs into a hierarchical category tree, fetches their RSS/Atom feeds, and surfaces recently-updated and recently-added blogs. Built with Django/Python, hosted at Mythic Beasts. Explicitly no AI involvement.

## What It Does Well

### 1. The Right Project at the Right Time

ooh.directory launched in late 2022 — exactly when the post-Twitter diaspora was driving renewed interest in blogs, RSS, and the "small web." This wasn't cynical timing; Gyford had been working on it quietly as `$new_project` in his weeknotes before it became fashionable. But the timing gave it cultural resonance. Endorsed by Daring Fireball, Warren Ellis, cited on Hacker News multiple times (reaching #1 on the front page in Feb 2026). The project taps into real, growing demand for human-curated discovery in the AI slop era.

As simonw put it on HN: "Given how worried everyone is about the AI slopocalypse where the internet is drowned in LLM-generated junk content maybe it's time for a resurgence of human curated directories like this one." That's the thesis, and ooh.directory is the strongest current embodiment of it.

### 2. Genuine Craft and Care

The site radiates thoughtfulness in small details:

- **Feed crawler with adaptive frequency** — polling hourly to daily depending on post cadence, with ⚠️ indicators when fetch fails (and Gyford personally contacts blog owners about broken feeds)
- **Blog birthday celebrations** on the homepage
- **"First post in over a year/two years"** sections that surface dormant blogs coming back to life
- **Country flags** on each listing
- **Per-blog pages** with posting frequency charts, first-post dates, recent posts
- **Random blog** feature for serendipitous discovery
- **OPML export per category** — respects the ecosystem
- **Category-level RSS feeds** for new additions
- **No ads, no tracking, no AI, no VC money.** Just a person who cares about blogs.

The Noto Emoji category icons give it a warm, distinctive personality. The pale pink/red aesthetic is charming without being cloying.

### 3. Topical Breadth Beyond Tech

The category distribution is genuinely diverse: Arts & Media (909), Computers/Internet/Tech (405), Personal blogs (373), Recreation (249), Humanities (169), Science (147), Countries/Places (129), Economics (72), Government/Politics (63), Society (54), Education (37), plus "Uncategorizable" (43) and "Completionist blogs" — a delightfully specific niche. This isn't just another tech blogroll.

That said, there's a persistent skew acknowledged by Gyford himself: Hacker News sends waves of tech blog submissions, and "90% of the Suggestions are currently tech-related." He actively tries to counter this by curating a topic mix in each batch.

### 4. Credible Operator

Phil Gyford is not some random. He's been making things on the web since the mid-1990s. His Pepys Diary project ran for a decade. He worked with BERG, the BBC, the Guardian, the British Museum, MoMA. He publishes weeknotes regularly. He's a known, respected figure in the IndieWeb/UK web community. This matters because a directory is only as trustworthy as its curator.

## Structural Weaknesses

### 1. The Single Curator Bottleneck

This is the existential problem. One person reviews every submission. As of mid-2023, there were 1,000+ unreviewed suggestions in the pool, with Gyford approving 20-30 per week. By Feb 2026, he writes: "I haven't yet added or deleted the hundreds of tech blogs by HN men that were suggested the first time the site appeared there, and now there are 250 or so more."

The math is brutal. At ~25/week, clearing 1,250+ backlogged suggestions takes a year. Meanwhile, new submissions arrive constantly. The backlog is growing faster than it's being cleared.

HN commenter throwaway150 nailed it: "The problem with ooh.directory is that nobody can tell what gets added and what doesn't. Submissions go through an opaque review process and a lot of good submissions don't make it."

Gyford's response is honest: it's a hobby, he has limited time, he prioritizes topic diversity. All understandable. But the practical consequence is that the directory is increasingly a snapshot of what one person found interesting from 2022-2024, with diminishing marginal additions.

### 2. Scale Ceiling

2,305 blogs. For context, there are estimated to be 600+ million blogs worldwide. Even restricting to English-language, RSS-enabled, recently-active, genuinely interesting blogs — the addressable pool is easily 50,000+. At 2,300, ooh.directory covers a tiny fraction.

This creates a discoverability irony: the directory exists to help people discover blogs, but if you search for any specific well-known blogger, there's a high chance they're not listed. "9 out of 10 times they'll be missing" per the HN critique.

The charts data reveals the addition rate has slowed dramatically:
- Blogs started 2007-2013: ~120-146/year being added
- Blogs started 2023: 24 added
- Blogs started 2024: 14 added
- Blogs started 2025: 9 added

These are "started in year" not "added in year," but the trend is clear: the directory is increasingly archival rather than current.

### 3. Geographic and Linguistic Monoculture

The country distribution is heavily Anglosphere:
- 🇺🇸 US: 1,017 (44%)
- 🇬🇧 UK: 653 (28%)
- 🇨🇦 Canada: 82
- 🇦🇺 Australia: 63
- Then Germany (44), NZ (17), Netherlands (17), Japan (16), Italy (15), Ireland (14)

72% US+UK. English-only is an explicit policy. This is understandable for a solo curator, but it means the directory primarily reflects the English-language Anglosphere blogosphere, with a strong British tilt (Gyford is UK-based). The blogosphere in French, German, Japanese, Spanish, Portuguese — invisible here.

### 4. Category Taxonomy Quirks

The category tree has some odd choices:
- **"BBC"** is a subcategory of "Economics and business" — more accurately belongs under "Media" or doesn't warrant its own subcategory
- **"Death & graves"** under Society — charming but very niche for a top-level subcategory
- **"Psychogeography"** likewise
- **"Completionist blogs"** under Uncategorizable — delightful but symptomatic of a personal taxonomy rather than a systematic one
- **"Countries, states, towns, etc."** as a top-level category is fundamentally different from topical categories — it's a geographic axis, not a subject axis. This creates taxonomic confusion: is a blog about London politics in "Countries > London" or "Government > Politics"?

Some subcategories are very thin (VR/AR: 3 blogs; Cryptocurrencies: 5). Others are massive (Development: 247 out of 405 in the tech parent). The tree doesn't scale well.

### 5. Limited Freshness Enforcement

From the charts: 2,026 blogs posted in the past year, but only 1,358 in the past month, 979 in the past week, 274 in the past day. That means ~280 blogs (~12%) haven't posted in over a year. Some listings show "Updated 2 years ago" or "Updated 3 years ago." The FAQ says blogs must be "updated within the past couple of months" to be *added*, but there's no pruning mechanism for stale blogs already in the directory.

This creates a slowly-growing layer of dead wood. A "#algopop" blog last updated 3 years ago with a 1-word post isn't serving anyone.

### 6. No Community Layer

No ratings, no reviews, no comments on blog listings, no voting, no user-generated categorization. This is deliberate (it's one person's curated view), but it means there's no feedback loop. Users can't signal which blogs are good, which are stale, which are miscategorized. The only community mechanism is "email Phil."

### 7. Opacity of Selection Criteria

The FAQ lists inclusion criteria, but some are subjective: "Every blog must have an RSS or Atom feed" (objective), "No blogs promoting hate speech, denial of climate change, anti-vax ideas" (reasonable but subjective boundary), and implicitly "Phil finds it interesting" (entirely subjective). The rejection reasons are never communicated to submitters. You suggest a blog and it either appears eventually or it doesn't. No feedback, no explanation.

## Technical Assessment

**Positives:**
- Django + Python stack — mature, maintainable, good choice for a solo dev
- Adaptive feed polling (1hr to 24hr) — resource-efficient
- OPML export — ecosystem-friendly
- Self-hosted at Mythic Beasts (UK indie hosting) — no big cloud dependency
- Proper structured data (JSON-LD)
- RSS feeds for everything (eat your own dogfood)

**Concerns:**
- The crawler uses Chrome-emulating User-Agent as fallback for 403s — this is ethically borderline and a cat-and-mouse game with CDNs
- Django Q2 for task queue — decent but not battle-tested at scale
- The site returned 404 for several URL patterns I tried (category URLs, blog post URLs) — suggests either non-obvious URL structure or some fragility

## Competitive Landscape

| Directory | Model | Size | Active? |
|-----------|-------|------|---------|
| ooh.directory | Solo curator | ~2,300 | Yes, slowly |
| Blogroll.org | Community-submitted | Unknown | Semi-active |
| Feedle | Automated search engine | Large | Yes |
| DMOZ/Curlie | Volunteer editors | 3.9M+ sites | Legacy/static |
| Blogroll (by Ray) | Solo curator | Small | Semi-active |
| Search My Site | IndieWeb search | Medium | Yes |

ooh.directory occupies a sweet spot: more curated than automated tools, more comprehensive than personal blogrolls, more alive than DMOZ's corpse. But it's inherently limited by the solo-curator model.

## Sustainability Questions

1. **Bus factor = 1.** If Phil Gyford loses interest, gets ill, or dies, the site dies. There's no succession plan, no organization, no community governance. His weeknotes already reveal periods where life gets in the way of additions.

2. **Financial model: none.** No ads, no sponsorships, no donations page visible. Hosting costs are presumably modest (Mythic Beasts), but there's zero revenue. This is either sustainable because costs are low, or fragile because there's no incentive beyond personal satisfaction.

3. **Backlog anxiety.** Gyford's own writing reveals increasing overwhelm: "I naively thought that having a form for suggesting blogs would result in loads of undiscovered, quirky, niche treasures" (instead: waves of tech blogs from HN). The growing gap between submissions and approvals creates invisible pressure.

## Verdict

ooh.directory is a **genuinely lovely project** — warm, thoughtful, well-crafted, principled. It's the kind of thing the web needs more of. Phil Gyford is the right person to have made it: patient, detail-oriented, with the credibility and taste to curate well.

But it's also **structurally limited by its own virtues.** The single-curator model that ensures quality and consistency is the same model that creates an ever-growing backlog, geographic bias, and a bus factor of one. At 2,300 blogs after 3+ years of operation, it's not really a directory of the blogosphere — it's a very large, very good personal blogroll with a directory UI.

The project's real value may be **cultural rather than practical.** It demonstrates that blogging is alive, that human curation matters, that the web can still be warm and handmade. As a discovery tool for your next favorite blog, it works *if* the blog you'd like happens to be in it — which, at 2,300 entries, is a coin flip at best.

**Rating: 7/10** — Beautiful execution of an inherently unscalable idea. The right project for the moment, but one whose impact will plateau unless the model evolves.

## What Would Make It Better

1. **Trusted co-curators** — even 2-3 additional reviewers would 3-4x throughput
2. **Transparent rejection/pending status** — let submitters know where they stand
3. **Automated pruning** — remove blogs inactive for 12+ months, or clearly flag them
4. **Category reform** — separate geographic and topical axes; collapse thin subcategories
5. **Community signals** — even simple "I read this" or bookmark counts would add a feedback loop
6. **A donations/sponsorship model** — not to monetize, but to signal longevity and fund hosting

---

**Sources:**
- Direct site browsing (2026-03-01)
- Phil Gyford's personal site (gyford.com) — launch post, weeknotes
- Hacker News threads (item 47014449, item 36458877)
- IndieWeb wiki (indieweb.org/ooh.directory)
- Daring Fireball endorsement (2022-12-01)
- Warren Ellis endorsement (2023-01-05)
- imjustcreative.com review (2022-11-28)
- Feedgrab blog mention
- Phil Gyford interview at manuelmoreale.com
- SimilarWeb data (global rank ~3.5M)
