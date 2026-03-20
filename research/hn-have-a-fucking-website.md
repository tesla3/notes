## HN Thread Distillation: "Have a fucking website"

**Article summary:** A short, profanity-laden rant arguing that businesses and creators should have their own websites instead of relying solely on social media platforms. The author cites platform risk (rule changes, account bans), lack of content ownership, and the hostility of walled gardens that block non-logged-in users. Advocates for websites + mailing lists as the path back to an open internet.

### Dominant Sentiment: Agreement in theory, skepticism in practice

The thread overwhelmingly agrees with the *principle* but spends most of its energy explaining why the advice is inadequate, elitist, or structurally impossible for the people it's directed at. More fundamentally, the thread's own evidence — when followed honestly — undermines the premise that these businesses *should* have websites at all.

### Key Insights

**1. The competence chasm is the actual barrier, not cost or tools**

The most upvoted comment (Arainach) systematically dismantles the LLM-will-fix-it assumption: a restaurant owner working 14-hour days doesn't know what a VPS is, doesn't know the *words* for what they want, and even if an LLM generates HTML, they have no idea where to put it. This isn't a tooling gap — it's a knowledge prerequisite stack that each "simple" solution quietly assumes. Every commenter who posted a "just do X" recipe (get a VPS, set up nginx, use certbot) was immediately and correctly called out: "You probably already lost 90% of normies" (emaro). The xkcd #2501 link was posted *three separate times* — a rare thread consensus marker.

BTAQA, building software for merchants in the GCC, nails the dynamic: "The barrier isn't technical ability or even cost. It's that every solution requires context they don't have and time they don't have."

**2. The article undermines its own thesis with its own platform dependencies**

blacklight delivers the sharpest counter: the author runs a WordPress blog and has a Mastodon account on mastodon.social. "Those who really believe in decentralization run their own stuff, or code their own blogging platform like I did." This exposes a sliding scale of purity that the rant ignores — the author is just one rung above the people they're yelling at, which makes the moral superiority ring hollow. The article treats platform dependence as binary when it's actually a spectrum everyone is on.

**3. Google Maps has quietly become the "website" for local businesses — and it works**

Multiple commenters (raincole, dazc, slifin, Gigachad, freetime2) converge on the same observation: for restaurants, salons, and tradespeople, a well-maintained Google Maps listing with reviews, photos, hours, and a phone number is functionally superior to a standalone website. dazc recounts advising a local business owner to just get on Google Maps and collect reviews — she didn't even do *that*. The real competitor to "have a website" isn't Instagram; it's Google's local search infrastructure, which the article never mentions.

**4. LLM scraping has created a new anti-website argument the old "own your content" framing can't answer**

A striking thread within the thread: _verandaguy, rkachowski, and Peritract argue that publishing anything on the open web now feeds LLM training corpora, making you a "digital sharecropper" regardless of whether you own the domain. _verandaguy has retreated to self-hosted services on a private VPN with single-digit users. This is a genuinely new structural force that inverts the original indie-web argument: owning your content used to mean controlling it, but now publishing it openly means losing control of it to scrapers. The article's 2015-era framing completely misses this.

**5. The economics of small websites are broken in a specific way: the middle is missing**

nicbou, who *lives off* his websites, reports 60%+ traffic decline from AI overviews and LLMs, while costs rise from bot mitigation. Meanwhile, Squarespace charges ~$20/month for what costs pennies to host. cucumber3732842 identifies the structural gap: "There's no accepted standard for the minimum website worth making. Website people don't want to sell you a five page static site." The market has bifurcated into free-but-complex (GitHub Pages, Cloudflare) and simple-but-expensive (Squarespace, Wix), with nothing in the middle that's both cheap, simple, and doesn't require git. lleu built exactly this (lleu.site) for local businesses — and reports "barely any takers."

**6. The "should" is imagined — revealed preference says the ROI isn't there**

The thread's most uncomfortable evidence is lleu's story: someone built the exact cheap, simple website product the thread kept asking for, marketed it aggressively (cold emails, mailers, newspaper ads, online ads), and got "barely any takers." That's not a tooling failure or a knowledge gap — that's the market saying the demand doesn't exist. deadbabe puts it bluntly: "If running a little website meant you'd actually get an audience, people would do it. But it doesn't happen, we can see the traffic stats." askmike and even the HN submitter asukachikaru acknowledge the uncomfortable truth: customers are on Instagram and Google Maps, not browsing independent websites. mdp's coffee shop "has done amazingly well on just Instagram... I doubt that a website would have any impact on their business."

The article's two core arguments — platform risk and reach — don't survive contact with the actual economics. Platform risk is overstated for local businesses: a hair salon's value is in the chairs, the skills, the location, the regulars. If Instagram vanished, they'd be on the next platform in a week. And the "excluded non-platform users" the author worries about are a rounding error — the author is essentially describing *themselves*, a self-selected privacy-conscious minority. The business is rationally optimizing for where the customers actually are.

**7. The 12-year-old lawn-mowing website hustle reveals the actual solution — but for whom?**

oflannabhra describes a kid using LLMs to proactively build websites for lawn care businesses, cold-calling them, and closing $200 deals. ToucanLoucan does local IT services and is growing. The thread keeps rediscovering that *agency* (someone else doing it for you) is the only model that converts non-technical owners. But this raises an unasked question: if you have to cold-call businesses and sell them on having a website they didn't want, is the product serving the business or the seller's assumption about what the business needs?

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "It's too hard for normies" | Strong | Backed by extensive firsthand accounts, not just speculation |
| "Google Maps is enough" | Strong | Functional substitute for the exact use cases the article cites |
| "LLM scraping makes open publishing counterproductive" | Medium | Real concern but applies equally to social media posts and HN comments |
| "The profanity is off-putting / performative" | Weak-to-Misapplied | Sparked a delightful sub-thread (zjp vs. millennials) but doesn't engage the substance |
| "Wix/Squarespace already solve this" | Medium | They exist but the cost and lock-in complaints show they haven't actually solved it at scale |

### What the Thread Misses

- **The Google Business Profile as the de facto open web for local commerce.** The thread keeps circling Google Maps but nobody connects it to the article's thesis: Google has effectively built the "simple public business page" layer that the open web never did. The irony — depending on Google is the same platform risk the article warns about — goes unexamined.

- **Email as the real battlefield.** The article's aside about mailing lists gets one comment (capncleaver) and then disappears. For a business that wants platform independence, an email list is 10x more valuable than a website, and far simpler to set up. This is the actually actionable advice buried in the rant.

- **The accessibility angle barely surfaces.** dec0dedab0de mentions it once. If the argument is "people can't access your info behind platform walls," the disability/accessibility framing (screen readers can't navigate Instagram) is far more compelling than "I deleted Facebook."

- **Nobody asks whether the "should" is founded or imagined.** The thread debates *how* to get businesses online but never seriously questions *whether* the ROI exists. carlosjobim asserts "tens of thousands of dollars in sales" but provides no evidence. The one person who actually tested the hypothesis (lleu) got barely any takers. The entire conversation assumes a business case that may simply not exist for local service businesses.

- **Nobody asks who this article is actually *for*.** It's not for the restaurant owner (they won't read it). It's not for HN (we already agree). It's a consumer preference ("I want to see your info without logging into Instagram") dressed as business advice. The rant is the author projecting their browsing habits onto other people's business strategy.

### Verdict

The thread's own evidence, followed honestly, undermines the article's premise. The "should" in "have a fucking website" is not a business case — it's an ideology. The open web advocates imagine that a website would help a hair salon, but the salon's actual customers find it through Instagram, Google Maps, and word of mouth. The one person who built the exact product the thread kept wishing for got barely any takers. nicbou, who *does* live off websites, reports the economics actively worsening. The businesses without websites aren't making a mistake — they're making the correct ROI calculation, and the article is a consumer complaint ("I want to see your hours without logging into Instagram") masquerading as business advice. Where websites genuinely pencil out — e-commerce, professional services selling to non-local audiences, content creators who monetize directly — people mostly already have them. The gap the article identifies is real but correctly unfilled. The uncomfortable implication for open-web advocates: for local commerce, the open web didn't lose to platforms through manipulation — it lost on merit.
