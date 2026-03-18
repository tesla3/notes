← [Index](../README.md)

## Cloudflare Crawl Endpoint: Antitrust Analysis

**Context:** Cloudflare launched a `/crawl` API (March 2026) that scrapes and renders websites via headless Chrome, returning HTML/Markdown/JSON. This sits alongside their existing Bot Management, WAF, and Turnstile products that block bots — including scrapers. See [thread distillation](cloudflare-crawl-endpoint-hn.md) for the HN reaction.

**Question:** Does Cloudflare's simultaneous operation of bot-blocking and bot-selling constitute an antitrust violation?

---

### 1. Market Position

The numbers make this worth taking seriously:

- **~80% of the reverse proxy / CDN market** (W3Techs, mid-2025). This is the relevant tying-product market — not "all websites" but "websites using a CDN/reverse proxy."
- **~20% of all websites** sit behind Cloudflare.
- **~40% CDN market share** by a different methodology (6sense, late 2025).

By any measure, Cloudflare has dominant or near-dominant market power in the reverse proxy / CDN space. The "sufficient economic power" threshold for a tying claim is clearly met.

### 2. The Tying Theory

Classical tying requires:
1. **Two distinct products** — the tying product and the tied product.
2. **Coercion** — buyer must take the tied product to get the tying product.
3. **Market power** in the tying product.
4. **Substantial commerce** affected in the tied product market.

**Does Cloudflare's setup fit?**

Not cleanly. The crawl endpoint isn't tied to CDN service — it's available independently to anyone with a Workers account. And Cloudflare doesn't force CDN customers to use the crawl endpoint. The classic tying framing doesn't work because there's no coercion in either direction.

**Verdict on tying: Weak.** No forced bundling. Both products are independently purchasable.

### 3. The Self-Preferencing / Leveraging Theory

This is the stronger frame. The pattern:

- Cloudflare sells bot protection to publishers (Bot Management, WAF, Turnstile)
- Cloudflare's bot protection blocks third-party crawlers, even those that obey `robots.txt`
- Cloudflare then sells a crawling service that gets favorable treatment from its own bot detection (low bot score on ASN 13335, per devnotes77's technical analysis)

This maps to the **Google Shopping** precedent in EU law. The General Court found that Google abused its dominant position by:
- Operating a platform with a "universal vocation" (search ↔ CDN/reverse proxy)
- Self-preferencing its own vertical service (Google Shopping ↔ Cloudflare Crawl)
- Demoting competitors' equivalent services (comparison shopping ↔ third-party crawlers)

The parallels are real but imperfect:

| Element | Google Shopping | Cloudflare Crawl |
|---------|----------------|------------------|
| Dominant position | ~92% general search | ~80% reverse proxy CDN |
| Gateway role | Gateway to the internet for users | Gateway to websites for bots |
| Self-preferencing | Promoted own shopping, demoted rivals | Own crawler gets low bot scores, rivals get blocked |
| Competitor foreclosure | Competing comparison services lost traffic | Competing crawlers (Firecrawl, custom) get blocked by WAF |
| Separate products | General search vs. shopping comparison | CDN/bot protection vs. scraping-as-a-service |

**Key difference:** Google Shopping was about *ranking manipulation* within a platform Google controlled. Cloudflare's situation is about *access control* to infrastructure that sits between the internet and the website. The CDN is closer to essential infrastructure than a search engine ranking — which arguably makes the case *stronger*, not weaker.

### 4. The Essential Facility Doctrine

Under EU law (*Bronner* and progeny), an essential facility claim requires:
- The facility is **indispensable** — no realistic alternative exists
- Refusal to grant access **eliminates all competition** in an adjacent market
- No **objective justification** for the refusal

**Is Cloudflare's network indispensable for crawling?**

Not in the traditional sense. You can crawl sites not behind Cloudflare. But for the 20% of the web behind Cloudflare — which includes a disproportionate share of high-value sites — Cloudflare is literally the only path. You cannot reach these sites without going through Cloudflare's network, and Cloudflare's bot detection sits on that path.

The recent CJEU *Android Auto* ruling (2024) loosened the indispensability test for platforms designed to host third-party content. The court held that *Bronner*'s strict indispensability requirement doesn't apply when infrastructure was built "with a view to enabling third-party undertakings to use it." A CDN is definitionally built to serve third-party content to the public — it's not infrastructure reserved for Cloudflare's own use.

**Assessment: Moderate.** Not a slam-dunk essential facility, but the *Android Auto* expansion of the doctrine opens a plausible path, especially in EU law.

### 5. The Strongest Frame: Constructive Refusal + Discrimination

The most legally viable theory combines:

1. **Cloudflare occupies a dominant position** in the reverse proxy market (~80%). ✓ Clear.

2. **Cloudflare operates in dual roles:** infrastructure provider to publishers AND competitor to crawling services. This is the Amazon Marketplace / Google Shopping structure — intermediary AND direct competitor.

3. **Cloudflare's bot detection creates a constructive refusal to deal.** Third-party crawlers that obey `robots.txt` still get blocked by Cloudflare's WAF/bot scoring. The blocking isn't technically a "refusal" since Cloudflare is acting on behalf of publishers, but the effect is the same: competitors can't reach Cloudflare-protected sites.

4. **Cloudflare's own crawling service receives preferential treatment.** Requests from ASN 13335 get low bot scores. The FAQ entry "Will Browser Rendering bypass Cloudflare's Bot Protection?" has a dead link (flagged in the HN thread). The documented behavior is that publishers need to create WAF skip rules for Cloudflare's crawler — suggesting it *does* trigger bot protection by default, but the workaround is trivial for a Cloudflare product and non-existent for third parties.

5. **The user-agent is configurable**, meaning Cloudflare's crawler can impersonate any bot. Third-party crawlers that identify themselves honestly get blocked; Cloudflare's crawler can choose whatever identity it wants. This creates an inherent asymmetry.

### 6. Why It Probably Won't Be Prosecuted (Yet)

Despite the structural parallels, several factors make enforcement unlikely in the near term:

**a. No formal complaint.** Firecrawl, ScrapingBee, Apify, etc. haven't filed complaints. The crawling-as-a-service market is young and fragmented. Nobody has standing and resources to fight Cloudflare.

**b. The `robots.txt` defense is technically true.** Cloudflare can point to documented `robots.txt` compliance and say "we don't bypass bot protection." The gap between `robots.txt` compliance and WAF/bot-score self-preferencing is subtle and technical — not the kind of thing regulators grasp quickly.

**c. Cloudflare isn't a DMA-designated gatekeeper.** The EU Digital Markets Act applies to "core platform services" — search engines, app stores, social networks, etc. CDNs aren't on the list. Cloudflare hasn't been designated. This means the DMA's self-preferencing prohibition (Article 6(5)) doesn't directly apply, and any action would need to go through the slower Article 102 TFEU route.

**d. Market definition is contested.** Cloudflare would argue the relevant market is "web scraping services" (where they're a minor player) not "access to web content through reverse proxies" (where they're dominant). Market definition fights take years.

**e. Current US antitrust posture.** The 2025-2026 FTC/DOJ are focused on Big Tech (Google, Apple, Amazon, Meta). Cloudflare is not on anyone's radar. The political salience isn't there.

### 7. When It Could Become Prosecutable

The trigger conditions:

- **Cloudflare blocks a major crawler** that strictly obeys `robots.txt`, and the crawler can document that Cloudflare's own endpoint accesses the same content. This creates a clean discrimination case.
- **Pay Per Crawl scales.** Cloudflare's July 2025 marketplace (where publishers charge AI companies for access) combined with this crawl endpoint creates a fully integrated tollbooth. If Cloudflare takes a cut of both sides — charging publishers for protection AND charging crawlers for access — the antitrust case sharpens considerably.
- **An EU investigation opens.** The EU is more aggressive on self-preferencing and has shown willingness to expand its theories. If Cloudflare's market share in CDN gets explicitly measured by competition authorities, the numbers alone could trigger scrutiny.
- **CDN gets added to DMA scope.** The DMA has a mechanism for adding new "core platform services." If CDN/reverse proxy gets added, Cloudflare would likely be designated immediately and the self-preferencing prohibition would apply.

### 8. Verdict

**The structural conflict is real and maps to established antitrust theories, particularly EU self-preferencing doctrine.** Cloudflare is doing with web crawling what Google did with shopping comparison: operating the dominant platform that mediates access, then launching a competing service that inherently benefits from that platform position.

**But the case is currently unprosecutable** because: (a) no complainant, (b) the market is young, (c) CDN isn't in regulatory scope, and (d) the technical self-preferencing is subtle.

**The trajectory matters more than the snapshot.** Cloudflare's July 2025 Pay Per Crawl marketplace + this March 2026 crawl endpoint + their existing bot protection creates a three-sided market where Cloudflare is the intermediary on every transaction. If they continue on this path — and the market share numbers hold — an antitrust case becomes not just possible but probable. The question is whether it'll be a formal investigation or whether the market will adapt first (e.g., major sites diversifying off Cloudflare, or competitors building alternative crawling infrastructure).

The closest historical analogy isn't Google Shopping — it's **AT&T before the 1982 breakup**: a company that controlled the infrastructure (local lines / CDN), used that control to foreclose competition in an adjacent market (long-distance / crawling), and extracted monopoly rents from both sides. The Cloudflare story is earlier in its arc, but the structural dynamics are the same.
