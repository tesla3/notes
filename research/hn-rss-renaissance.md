← [Index](../README.md)

## HN Thread Distillation: "The death of social media is the renaissance of RSS (2025)"

**Source:** [smartlab.at](https://www.smartlab.at/rss-revival-life-after-social-media/) | [HN thread](https://news.ycombinator.com/item?id=47304886) — 241 points, 168 comments, 132 unique authors

**Article summary:** A blog post arguing that AI-generated content is killing social media's authenticity, and RSS offers a way back to user-controlled, human-curated information consumption. It explains what RSS is, recommends the Feeder app, and frames RSS as a "survival tool in the age of AI content floods."

**Article assessment:** The article itself is the meta-irony that defines the thread. It reads like ChatGPT output — verbose, bolded emphasis phrases, repetitive thesis restatement, zero original data or personal anecdote. An article about AI slop destroying authenticity that *is* AI slop. Multiple commenters noticed: "if you're not writing your articles with LLMs, you should strongly consider changing your writing style" [vanillameow]; "This whole article reeks of AI slop" [nelsonfigueroa]; "read exactly like AI-slop. Became boring after the first paragraph" [abc123abc123]. The article bundles two distinct claims — (1) social media is dying from AI content floods, and (2) RSS is the answer — but provides evidence for neither beyond assertion.

### Dominant Sentiment: Nostalgic enthusiasm meets structural skepticism

The thread splits between RSS power users who genuinely love their setups and are happy to share them, and a smaller but sharper cohort pointing out that RSS has fundamental adoption barriers that enthusiasm won't fix. The mood is warm but self-aware — people know they're in a niche.

### Key Insights

**1. The naming problem is a symptom, not a cause**

[mnls] opens with the sharpest framing: "Every article I've read in the last 5 years about the RSS revival has a big section explaining what is RSS. And that's the answer about RSS renaissance." [bluebarbet] suggests it should have been called "Webfeed." But [8organicbits] cuts through: "You don't need to explain RSS any more than you need to explain SMTP or HTTP. A product that uses RSS could gain traction without the user ever knowing it uses RSS." This is the correct insight — RSS failed as a *brand* because no product successfully abstracted it away after Google Reader died. The name is a red herring; the missing layer is a compelling consumer product that happens to use RSS underneath. Podcasts prove this: most people consume RSS daily without knowing it. [sirl1on]: "Most non-tech people I know listen to podcasts through Spotify and some think Spotify invented them."

**2. The algorithm isn't the enemy — misaligned algorithms are**

[raghavbali] makes the thread's most underappreciated point: "most people using RSS-like technologies would typically subscribe to more sources than they can typically read through. Like it or not, *the algorithm* does serve the purpose in prioritizing and discovery." [kstrauser] refines this: "Algorithms other than FIFO are fine *when they serve you*" — citing a Bayesian mail classifier from the Gnus era. [ymolodtsov], who is *actively building an RSS reader with algorithmic ranking*, validates this from the builder's perspective: "I'm now building an RSS reader that is specifically designed around the algorithm that learns what sources you like the most... And I now use it far more than I ever used Reeder." The thread converges on a framework: the problem isn't algorithmic curation per se, it's *who the algorithm serves*. An on-device, user-serving algorithm over RSS feeds is the obvious synthesis that neither pure RSS nor social media provides today.

**3. The self-hosted RSS stack is mature but excludes 99% of people**

The thread is littered with impressive personal setups: FreshRSS + NetNewsWire [theshrike79], Miniflux + Elfeed + Read You + Instapaper + Karakeep [bergheim], RSS-to-email pipelines [stevekemp], feed hydrators that auto-expand teasers [mbirth], HN feed filters by comment count and keyword [theshrike79]. These are genuinely powerful — [theshrike79]'s setup auto-filters HN by engagement metrics and injects OpenGraph previews. But every one of these requires self-hosting knowledge, multiple integrations, and ongoing maintenance. The sophistication of these setups is both proof that RSS can work beautifully *and* proof that it can't go mainstream in this form.

**4. Discovery is RSS's actual unsolved problem**

[ptak_dev] nails the structural gap: "Google Reader died and took with it the social graph that made RSS useful. You didn't just subscribe to feeds; you saw what your network was reading and sharing. That discovery mechanism is what Twitter/X replaced, not the reading itself." RSS solves *delivery* but not *discovery*. Multiple commenters point to partial solutions — Kagi's SmallWeb [theshrike79], ooh.directory [benoliver999], blognerd.app [alastairr] — but these are curated lists, not dynamic discovery engines. The observation that LLMs could solve this ("a model that knows your reading history and surfaces relevant feeds") is interesting but hand-wavy.

**5. The "RSS would get enshittified too" argument is both right and wrong**

[ThoAppelsin]: "If RSS becomes popular, there will be discovery platforms with 'algorithm's. It will be the same thing, just the discovery and content separated." [bonoboTP] extends this to a gravity argument: algo feeds always win the engagement race, RSS gets backgrounded, platforms drop it. But [szszrk] has the strongest rebuttal: this already happened in the mid-2000s and RSS survived as a protocol. The key difference from social media is *separation of concerns* — RSS separates content from distribution from ranking. Even if a discovery layer gets enshittified, the underlying feed remains accessible. [cosmicgadget]: "Having a single platform own both the content and syndication is the model that got us in this sorry state." The protocol's resilience is its value, not its UI.

**6. "Social media is dying" is doing a lot of unsupported work**

[ymolodtsov] delivers the thread's most direct pushback on the article's premise: "They specifically prioritized the users as shown by the fact their userbase and engagement have only grown. Is this a good thing for the users? Hard to say... but the only 'hard' metric we have says they indeed prioritize users." This is uncomfortable but correct — the "death of social media" framing is wish-fulfillment from people who've already left. Total social media usage continues to grow globally. What's actually happening is a *bifurcation*: a small, technically literate cohort is opting out while the mainstream gets more entrenched.

**7. The LLM-as-scraper vision is seductive but adversarial**

[hombre_fatal] proposes the anti-RSS: forget the protocol, just have an LLM scrape any website and turn it into a feed. They've built this for themselves. [mmsc] pushes back: "LLMs are lossy compression. RSS feeds are accurate, predictable, and follow a pre-defined structure." The deeper problem: building your reading infrastructure on adversarial scraping means you're in an arms race with every website's anti-bot measures. RSS is a *cooperative* protocol — publishers opt in. That cooperation is what makes it reliable, and it's what scraping can never replicate at scale.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "If you have to explain it, it'll never be mainstream" | **Strong** | True of the *brand*, not the technology. Podcasts prove RSS can succeed invisibly. |
| "People actually crave algorithmic feeds" | **Strong** | Uncomfortable truth. Addiction framing [sznio, abraxas] doesn't change the revealed preference. |
| "RSS doesn't solve AI slop" | **Medium** | RSS makes slop your *choice* to unsubscribe from, but doesn't filter it within trusted sources that degrade. |
| "RSS is read-only, can't replace social interaction" | **Medium** | Correct but misframes — RSS replaces content *consumption*, not conversation. [smitty1e]: "RSS is a component, not the whole system." |
| "Paywalls make RSS useless" | **Weak** | Niche problem. Most blogs/independent sources are free. Paywall content was never free on social media either. |

### What the Thread Misses

- **Newsletter platforms already won this fight.** Substack, Beehiiv, Ghost — these are RSS-with-email-delivery that actually achieved mainstream adoption. The "RSS renaissance" already happened; it just wears an email costume. Nobody in the thread connects these dots.
- **The publisher incentive problem.** RSS gives publishers *zero analytics* by default. No open rates, no click tracking, no audience demographics. In a media economy built on proving reach to advertisers or sponsors, this is a structural dealbreaker for most professional content creators. The thread discusses reader-side tooling exhaustively but never asks why publishers would choose to support RSS.
- **Mobile OS gatekeeping.** Apple and Google control the two platforms where most content consumption happens. Neither has incentive to surface RSS — Apple has News+, Google killed Reader to push Google+. The thread mentions browser RSS support dying but doesn't follow the thread to its conclusion: platform owners are actively hostile to open syndication.
- **The demographics of who's actually in this thread.** 132 unique commenters, almost all describing personal RSS setups from the perspective of self-hosters and power users. This is a self-selected sample cosplaying as a movement. [justinator]'s blunt "Does your Mother use RSS daily? Does your kid?" goes essentially unanswered.

### Verdict

The thread demonstrates that RSS is an excellent *personal* tool with a mature ecosystem for technically inclined users — and simultaneously demonstrates why it will never be mainstream in its current form. The actual insight the thread circles but never states: **RSS doesn't need a renaissance, it needs to disappear into products.** Every successful use of RSS (podcasts, Substack, YouTube subscriptions) works precisely because users never see the protocol. The fantasy of "everyone uses an RSS reader" is the wrong goal. The right goal is "every product uses RSS underneath, and users benefit without knowing." That already happened — and it's the one version of the RSS story nobody here is willing to celebrate, because it doesn't involve Miniflux configs.
