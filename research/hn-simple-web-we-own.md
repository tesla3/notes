← [Index](../README.md)

## HN Thread Distillation: "A simple web we own"

**Article summary:** R. S. Doiel, a long-time software engineer, argues we can reclaim the web from Big Co through three pillars: owning cheap hardware (Raspberry Pi), using simpler authoring (Markdown → HTML), and forming network cooperatives. He draws an analogy to labor movements — when enough individuals own hardware, collective power shifts. He built "Antenna App," a Markdown-driven CMS/RSS aggregator he runs on a Pi on his home LAN, with public access via GitHub Pages. The essay is long, earnest, historically-grounded, and not mobile-responsive.

### Dominant Sentiment: Sympathetic but structurally skeptical

The thread broadly shares the author's values but is unconvinced his prescription addresses the actual disease. Sympathy runs high; optimism about this specific path runs low.

### Key Insights

**1. The article solves the wrong bottleneck — authoring was never the constraint**

The core thesis — that Markdown democratizes web publishing the way HTML couldn't — is a solution to a 1995 problem. Multiple commenters converge on the real barrier being discovery and attention, not content creation. cousin_it puts it cleanly: "Until you can design a platform that gives top creators as much money+attention as commercial platforms, you'll see a drain." zerotolerance sharpens this further: "We do not have a supply side issue. We have a worsening discovery and discoverability issue." The article spends thousands of words on how cheap Raspberry Pis are, never once addressing why anyone would find your Markdown blog.

**2. The photography parable — human connection, not CMS**

munificent's extended comment is the thread's star contribution. He built "objectively a really nice" self-hosted photography site with his own domain and VPS. Nobody came. "Uploading photos to my site was about as rewarding as printing them out and throwing them in the trash." The insight isn't that self-hosting is hard — it's that *unreciprocated creation is psychologically unsustainable*. A CMS won't fix the absence of a thumbs-up button clicked by someone you care about. This reframes the problem entirely: platforms don't win on ease of publishing; they win on ease of *mattering*.

**3. The ISP chokepoint is structural, not incidental**

beders (top comment, 1d veteran of the BBS era) lays out the infrastructure reality: ISPs throttle upload, enforce 24h disconnects, prohibit sharing connections in their ToS, and control the physical layer. The "democratization ends at your router." nine_k adds the IPv4/IPv6 mess — most home connections don't even get a globally routable address. Several commenters mention mesh networks (Freifunk, Guifi, NYCMesh) as alternatives, but embedding-shape's own descriptions reveal these remain hobbyist-scale and line-of-sight dependent. The structural point stands: you can own the endpoint but not the pipe, and the pipe is where control lives.

**4. The GitHub Pages irony reveals a genuine tension**

swiftcoder notes the irony; the defenses are interesting. nicbou argues hosting on GitHub is "merely a convenience; they can up and leave anytime." sagaro distinguishes data portability (Markdown files you own) from platform lock-in (Facebook's proprietary export dumps). This is the thread's most productive disagreement. The portability argument has real merit — but swiftcoder's counter-example of [solar.lowtechmagazine.com](https://solar.lowtechmagazine.com) (a solar-powered, self-hosted site that actually practices what it preaches) exposes a gap between manifesto and practice. graypegg lands the honest read: "the author made a mistake framing his idea as something bigger than it is. Just saying people should homelab more is totally cromulent."

**5. The missing platform — "Google building Android" scale**

ineptech writes the comment the article needed to be. Imagine an OS that installs on a Pi "as easy as Windows," auto-configures NAT, gives you one-click Wordpress/Minecraft, auto-updates, sandboxes services, and is "crack-proof enough to store your bitcoins on." If that existed, "we wouldn't have to write essays about freedom." The problem: it would take a massive coordinated effort to build, "possibly 'Google building Android' sized," and current open-source efforts lack traction due to the chicken-and-egg problem. This is the thread's sharpest structural observation — the "simple web" isn't simple because nobody has invested the enormous upfront complexity-absorption that Apple/Google did for phones.

**6. Email is where ownership already died**

pyrolistical identifies the real lost cause that nobody in the article addresses: "You can't run your own email server. All other large email providers will consider your self hosted emails as spam by default." This is a concrete, present-tense example of the exact dynamic the article worries about — and it happened despite email being an open, federated protocol from the start. npodbielski pushes back with Mailcow/Docker experience, but the exchange itself proves the point: maintaining self-hosted email requires exactly the technical depth the article claims shouldn't be necessary.

**7. The regulation ratchet nobody sees coming**

wkrsz raises a threat the rest of the thread ignores: when small-web publishing gets popular enough to matter, incumbents will lobby for compliance requirements (content moderation, media registration, accessibility mandates) that are trivially cheap at scale but crushing for individuals. He cites the Netherlands, where influencers with 100K+ followers must register with media authorities and pay supervision fees. Florida proposed blogger registration laws. The "simple web" movement has no organizational capacity to fight this — which means success would trigger the very regulatory capture that kills it.

**8. AI makes the identity problem worse, not better**

sowbug offers an intriguing half-thought: AI agents are destroying identity as a content-moderation signal, which might force the internet to evaluate *content quality* rather than *who posted it*. caconym_ immediately spots the flaw: "I would rather just read the thought as it was originally expressed by a human... rather than a version of it that's been laundered through AI and deployed according to the separate, hidden intent of the AI's operator." The dynamic here matters — if AI floods the open web with synthetic content, the platforms with identity verification and curation *gain* relative value, making the escape to the "simple web" harder, not easier.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Democratization ends at your router" | **Strong** | Structural, not just inconvenience — ISPs control the pipe |
| "Discovery, not publishing, is the problem" | **Strong** | Thread's consensus insight; article never addresses it |
| "This is a social problem, not technical" | **Strong** | podgorniy, malklera, AuthAuth all converge |
| "You don't own a VPS either" | **Medium** | True but muddies useful ownership gradients |
| "This is learned helplessness" (talkingtab) | **Weak** | Dismisses real structural barriers as attitude problems |
| "IPv6/mesh will fix connectivity" | **Weak** | Decades of promises; remains hobbyist-scale |
| "Yet you participate in society" defense of GitHub hosting | **Misapplied** | Self-hosting *is* feasible here; this isn't healthcare |

### What the Thread Misses

- **The labor analogy is backwards.** Unions won because they controlled a *scarce input* — labor — that employers couldn't replace. Owning a Raspberry Pi gives you no bargaining leverage over platforms. They don't need your server; they need your attention and data, which you give voluntarily because the platform has your friends on it. Individual hardware ownership without collective *withholding* of something platforms need is just hobby electronics.

- **AI is about to make the supply side worthless.** The thread debates hosting and authoring while ignoring that generative AI is collapsing the cost of content creation to zero. If anyone can produce infinite blog posts, the scarce resource becomes *trusted identity and curation* — which is exactly what platforms provide and the "simple web" cannot.

- **The cash-free future is the real sovereignty threat.** zerotolerance alone gestures at this: "Right now we're about to lose the war that requires digital connectivity to live... We're going to lose cash payments." If you need a platform account to transact, own property, or access government services, hosting your own blog is decorative resistance.

- **The article's own site isn't mobile-responsive.** Multiple commenters note this. A manifesto for "a simple web" that's unreadable on the device most humans use to access the web is an own goal that undermines the entire thesis about simplicity.

### Verdict

The article confuses *authoring sovereignty* with *distribution sovereignty*, and the thread mostly catches the error. The real dynamic the thread circles but never names: network effects are a one-way ratchet. Each person who joins a platform makes it costlier for everyone else to leave, and no amount of cheap hardware reverses this. The author's labor movement analogy actually contains the answer he doesn't see — unions didn't win by each worker buying their own factory; they won by *collectively withholding something employers couldn't replace*. The "simple web" movement has not identified what it can withhold from platforms, because the honest answer right now is: nothing. Platforms already have the content, the audience, and the payment rails. The path forward isn't simpler publishing tools — it's building the social infrastructure for collective withdrawal, which is a political project, not a technical one.
