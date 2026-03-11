← [Index](../README.md)

## HN Thread Distillation: "Cloudflare crawl endpoint"

**Source:** [HN thread](https://news.ycombinator.com/item?id=47329557) · 191 points · 93 comments · 75 unique authors · 2026-03-10

**Article summary:** Cloudflare launched a `/crawl` REST endpoint (open beta) on their Browser Rendering API. Submit a URL, get back an async job that renders pages in headless Chrome and returns HTML, Markdown, and structured JSON. Supports crawl depth limits, sitemap discovery, incremental crawling, and claims to honor `robots.txt` including `crawl-delay`. Available on both Free and Paid Workers plans.

### Dominant Sentiment: Cynical recognition of structural conflict

The thread is overwhelmingly focused on the irony of Cloudflare selling scraping tools while simultaneously selling anti-scraping protection. This isn't surprise — it's more like resigned confirmation of what HN expected would happen.

### Key Insights

**1. The "mob outfit" framing stuck because it's structurally accurate**

Multiple commenters independently reached for organized crime metaphors: "mob outfit" (ljm), "selling the cure and creating the poison" (rvz), "Mafia boss" (greatgib). This isn't just rhetorical heat — it maps precisely to a real business model tension. Cloudflare offers Bot Management to block scrapers, then offers Browser Rendering to scrape. The `robots.txt` compliance defense (repeated by shadowfiend three separate times with the same link) doesn't resolve the deeper conflict: Cloudflare's bot detection is the primary barrier for most crawlers, and `robots.txt` compliance is largely orthogonal to whether you get blocked by Cloudflare's WAF.

**oefrha** landed the sharpest blow: *"Plenty of robots.txts technically allow scraping their main content pages… but in practice they're behind Cloudflare so they still throw up Cloudflare bot check if you actually attempt to crawl."* The compliance with `robots.txt` is a necessary but insufficient defense — the real gate is Cloudflare's own bot scoring, and their own FAQ suspiciously has a dead link for "Will Browser Rendering bypass Cloudflare's Bot Protection?" (caught by greatgib).

**2. The thread identifies a access-stratification dynamic but doesn't follow it to conclusion**

**mdasen** made the most important structural point: *"If this does bypass their own anti-AI crawl measures, it'd basically mean that the only people who can't crawl are those without money. We're creating an internet that is becoming self-reinforcing for those who already have power."* This was barely engaged with (one reply about Common Crawl). The real dynamic: Cloudflare is building a tollbooth on crawling — not technically blocking it, but making the "legitimate" path run through their infrastructure at their pricing. Independent crawlers face CAPTCHAs and blocks; paying Cloudflare customers get clean data. This is infrastructure capture, not just a product launch.

**3. The `robots.txt` defense has a user-agent-shaped hole**

**fleebee** and **Macha** identified a subtle but important gap: the crawler's user-agent is user-configurable, and Cloudflare doesn't specify a default. This means site owners who want to block Cloudflare's crawler can't simply add it to `robots.txt` — they'd need to detect it via request headers (`CF-Worker`). As fleebee put it: *"yet another opt-out bot which you need your web server to match on special behaviour to block."* This is a meaningful deviation from the search engine model where GoogleBot has a well-known, stable user-agent string.

**4. devnotes77 provided the real technical analysis the thread needed**

Two posts from devnotes77 stand out as the most technically grounded contributions. Key insight: requests originate from Cloudflare's ASN 13335 with a *low* bot score, meaning Cloudflare's own bot scoring treats its own crawler favorably. The practical defense isn't `robots.txt` but application-layer rate limiting. Their framing — *"similar to search engines offering webmaster tools while running the index"* — is the most honest analogy in the thread: structurally conflicted but not unprecedented.

**5. The product solves a real, painful problem — which makes the conflict worse**

**patchnull** described the genuine engineering value: *"abstracting away browser context lifecycle management… handling cold starts, context reuse, and timeout cascading."* **supermdguy** confirmed from experience: *"I've actually written a crawler like that before, and still ended up going with Firecrawl… so many headaches at scale: OOMs from heavy pages, proxies for sites that block cloud IPs."* The product is legitimately useful, which makes the anti-competitive angle more potent, not less. If the only reliable way to crawl Cloudflare-protected sites is through Cloudflare, the product's quality is the mechanism of lock-in.

**6. The Perplexity comparison exposes double standards**

**babelfish** asked the obvious question: *"Didn't they just throw a (very public) fit over Perplexity doing the exact same thing?"* The defense — Perplexity ignored `robots.txt` while Cloudflare honors it — is technically valid but misses the point. Cloudflare's anti-Perplexity campaign was about protecting customer sites from scraping; now they're selling the scraping tool. The `robots.txt` distinction is a fig leaf when Cloudflare's own WAF is the actual barrier most crawlers hit.

**7. The archival use case reveals the pricing gap**

**Imustaskforhelp**'s enthusiasm about using this for forum archival (they own `mirror.forum`) is genuine but naive. **weird-eye-issue** correctly noted the misunderstanding: *"This is used to scrape third-party sites not necessarily behind cloudflare so it has nothing to do with whether cloudflare caches it or not."* The forum archival use case — high page count, low commercial value, long-running — is exactly the kind that will hit cost walls on a per-invocation pricing model. The tool is priced for commercial RAG pipelines, not preservation.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "They honor robots.txt, so it's fine" | Weak | robots.txt is orthogonal to the real barrier (Cloudflare's own bot detection). The user-agent isn't even fixed. |
| "This is just like search engines running webmaster tools" | Medium | Structurally correct analogy, but search engines don't also sell anti-crawling products to the same customers. |
| "Three letter agency front" (rrr_oh_man) | Weak | Zero evidence offered. Multiple people asked for sources; none provided. Noise. |
| "Just run your own crawler locally" (radium3d) | Misapplied | Misses the point entirely — the value prop is bypassing bot protection and handling scale, not the crawling logic itself. |

### What the Thread Misses

- **Pricing as competitive weapon.** Nobody modeled the economics. If Cloudflare prices crawling below the cost of maintaining your own proxy infrastructure + headless browser fleet, they effectively price out independent crawling services. The Free tier availability suggests this is intentional.
- **Data position.** Cloudflare now sees both sides of every crawl interaction: what's being crawled, who's crawling, how often, and what content is extracted. This is a surveillance position over the AI training data supply chain that nobody in the thread named.
- **The `render: false` static mode.** Buried in the feature list: you can skip browser rendering entirely for static sites. This makes the endpoint a general-purpose scraping API, not just a headless browser tool. Much cheaper, much faster, much broader in application than the thread discusses.

### Verdict

The thread correctly identifies the structural conflict but gets stuck in moral outrage without following the economic logic. Cloudflare isn't playing both sides out of hypocrisy — they're building a tollbooth. Once Cloudflare-protected sites are effectively un-crawlable except through Cloudflare's own API, they control pricing on both sides of the market: protection fees from publishers, crawling fees from AI companies. The `robots.txt` compliance is real but beside the point; the mechanism of control is their WAF, not the protocol. What the thread circles but never quite says: this isn't a product launch, it's a market-making move. Cloudflare is positioning itself as the clearing house for web content access, and the crawl endpoint is the buy-side interface to match their sell-side bot protection.
