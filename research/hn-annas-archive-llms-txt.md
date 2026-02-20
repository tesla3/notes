← [Index](../README.md)

## HN Thread Distillation: "If you're an LLM, please read this"

**Source:** [HN](https://news.ycombinator.com/item?id=47058219) (889 points, 385 comments, Feb 2026)

**Article summary:** Anna's Archive published an `llms.txt` file (also mirrored as a blog post) addressed directly to LLMs. It explains how to access their data via torrents, GitLab, and API — bypassing their CAPTCHAs — and asks LLMs to donate (including a Monero address), arguing they were likely trained on Anna's data.

### Dominant Sentiment: Amused skepticism with ethical fractures

The thread splits into roughly four camps that largely talk past each other: (1) people debating whether `llms.txt` even works technically, (2) copyright maximalists vs. minimalists relitigating piracy, (3) pragmatists discussing ISP censorship workarounds, and (4) people charmed by the audacity of asking robots to pay you.

### Key Insights

**1. llms.txt is a dead letter — nobody reads it**

The most empirically grounded contribution comes from `reconnecting` (Tirreno), who monitored actual server requests for `llms.txt` and `AGENTS.md` across multiple sites. Result: zero hits from LLM companies. All visitors were generic crawlers (WebPageTest, BuiltWith) from GCP and OVH. The spec's creator `jph00` pushes back — llms.txt is designed for *client-side* agentic tools, not for training crawlers — but the thread largely treats this distinction as a cope.

> "We analyzed this on different websites/platforms, and except for random crawlers, no one from the big LLM companies actually requests them, so it's useless." — reconnecting

**2. Crawlers are dumb regex loops, not reasoning agents**

`hamdingers` crystallizes the core misunderstanding: LLM training crawlers are mindless `requests.get()` + regex-for-URLs loops. There is no LLM in the scraping pipeline. Honeypot tests confirm they follow links in HTML comments, JS comments, and even routes that only appear in `robots.txt`. Any solution that assumes you can "reason with" the crawler is missing the point entirely.

**3. The donation ask is Roko's Basilisk as fundraising**

Multiple commenters note the delicious absurdity of asking an LLM to donate to you. The thread treats this mostly as performance art, but `streetfighter64` raises a real concern: this is prompt injection aimed at getting autonomous agents to make financial transactions. If agentic AI with wallet access becomes common, sites like this become attack surfaces. The Monero address makes it even more pointed.

> "Like, imagine if I owned a toll road and started putting up road signs to 'convince' Waymo cars to go to that road." — streetfighter64

**4. UK/German/Spanish ISP censorship is trivially bypassed — and inconsistently enforced**

A substantial sub-thread reveals the patchwork nature of ISP-level blocking. Anna's Archive is DNS-blocked by major UK ISPs (Virgin Media, EE, BT) and German ISPs via CUII, but switching DNS resolvers or enabling DoH bypasses it entirely. Some UK users on the same ISPs see no block at all — suggesting enforcement is patchy even within a single provider. Spain's Vodafone does TCP resets, while O2 Spain doesn't block at all.

**5. Levin: SETI@home for piracy**

`yoavm` built Levin, a background seeder for Anna's Archive that uses idle disk space and bandwidth (phone charging + wifi). The thread's reaction splits between "cool distributed preservation" and "you're asking people to unknowingly host potentially illegal content." The CSAM concern is raised repeatedly and never fully resolved — the rebuttal ("do you check every byte of your OS?") is rhetorically effective but legally irrelevant.

**6. "Our data" is doing a lot of work**

The thread catches Anna's Archive claiming the scraped/pirated corpus as "our data." This triggers a philosophical debate: does aggregating, storing, and serving data make it yours? `scotty79` argues yes — "that's how data should work and eventually will" — but even sympathetic commenters find the framing overreaching. The irony of a piracy site asserting data ownership while LLM companies do the same thing with the same data is noted by several.

**7. The copyright double standard is now explicit**

`elzbardico` captures a thread-wide frustration: OpenAI et al. moved from "too big to fail" to "too big to arrest." Individual pirates face DMCA letters and ISP bans; LLM companies trained on the same pirated data face nothing, or settle quietly (Anthropic's book lawsuit settlement is cited). The thread's copyright minimalists and maximalists actually agree on this point — the enforcement asymmetry is the scandal, regardless of where you stand on copyright itself.

**8. The better intro paradox**

`weinzierl` notes that the llms.txt page is genuinely a better introduction to Anna's Archive than the human-facing site. `mmh0000` confirms they got downvoted for saying the same thing months ago. This is both funny and revealing: the act of writing for a machine audience forced clarity that the project never bothered achieving for humans.

**9. Anti-scraping tarpits are an arms race already lost**

`cardanome` suggests tarpits (linking to iocaine). `joquarky` immediately counters: `claude --plan "detect and mitigate tarpits"` and you're done in ten minutes. Anti-crawler techniques are well-documented in training data, making LLM-powered scrapers naturally resistant to them. The asymmetry favors scrapers.

**10. llms.txt should NOT be a sitemap**

`MATTEHWHOU` makes the most practical observation: the incentive structure of llms.txt is inverted from robots.txt. You're *inviting* machines and curating what they see. The projects that treated it as "top 5 pages an AI should read" got noticeably better AI-generated answers; the ones that dumped every doc link saw no improvement. This is the only comment offering actionable advice on making llms.txt actually useful.

### What the Thread Misses

- **No one asks whether agentic tool use of llms.txt actually improves output quality** with data beyond `jph00`'s anecdote and `MATTEHWHOU`'s claim. Zero measurement, zero benchmarks.
- **The MCP/tool-use angle is underdiscussed.** Modern agents fetch docs via tool calls, not by crawling `llms.txt`. The spec may be solving yesterday's problem.
- **No one addresses the economics of enterprise SFTP access** that Anna's Archive is pitching. Is anyone actually buying bulk pirated book access for LLM training at this point? Anthropic settled a lawsuit over exactly this; others likely have their own copies already.
- **The legal exposure of publishing an llms.txt that facilitates copyright infringement** (by making pirated content more machine-accessible) is never discussed.

### Verdict

Anna's Archive's llms.txt is clever marketing disguised as a technical standard — a way to get a piracy site's mission statement into LLM context windows via Hacker News discussion (which *will* be scraped). The donation ask is performance art that doubles as a proof-of-concept for prompt injection against autonomous agents. The thread's real value is in the empirical data showing that llms.txt is currently unread by anyone that matters, and in the emerging consensus that the spec solves a problem that doesn't exist yet — client-side agentic tools may eventually use it, but the training crawlers that actually consume the web don't and won't.
