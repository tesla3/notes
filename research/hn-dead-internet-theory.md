← [Index](../README.md)

## HN Thread Distillation: "Dead Internet Theory"

**Source:** [kudmitry.com](https://kudmitry.com/articles/dead-internet-theory/) · [HN thread](https://news.ycombinator.com/item?id=46671731) (697 comments, 697 points)

**Article summary:** Personal essay by a longtime HN user who watched someone get accused of AI-generating both their open-source code and their HN comments. The linguistic tells cited — em-dashes, "you are absolutely right," offer-to-explore closings — trigger a broader reflection on Dead Internet Theory: that most online content and interaction is now machine-generated. The author concludes with nostalgia for the early-2000s internet and despair about the current trajectory.

### Dominant Sentiment: Nostalgic alarm tempered by fatalism

The thread oscillates between "yeah, it's over" and "it was always like this." Notably missing is panic — most commenters treat the dead internet as an ambient condition they've already priced in, not a crisis requiring action. The proposals for fixes are half-hearted; the energy goes into war stories and clever observations.

### Key Insights

**1. The em-dash witch hunt is a cultural regression, not a detection advance**

The article's central "tell" — that em-dashes signal AI — gets demolished by the thread itself. `dvt`: "I liked em dashes before they were cool — and I always copy-pasted them from Google." `celsius1414` explains Option-Shift-hyphen is muscle memory after decades on Mac. `Lammy` is "sick of the em-dash slander." `projektfu` traces the habit to *The Mac is not a Typewriter* by Robin Williams. `mmooss` correctly notes that `--` for em-dash predates computers entirely, going back to typewriters.

The dynamic here is corrosive: AI has made people *less* literate about language by giving them a heuristic that punishes good typography. The article's author is not detecting AI — they're detecting anyone who writes above a certain baseline of care.

**2. False positives do more damage than actual bots**

`DeathArrow`'s one-liner — "If you show signs of literacy, people will just assume you are a bot" — is the thread's sharpest observation, and `Imustaskforhelp` provides the painful lived proof: a teenager who got accused of being AI twice in 24 hours on HN, who writes long, earnest, messy comments that are obviously human, and who is now considering leaving the platform. The mechanism: accusation is cheap, defense is expensive, and the accused can never fully clear themselves. This is a chilling effect on authentic participation that *accelerates* the very dynamic the article laments. Every human driven off by false accusation is replaced by nothing — or by an actual bot that knows how to avoid the tells.

**3. Humans are converging toward bot-speak, not the other way around**

`BrtByte`: "What worries me most is not bots talking to bots, but humans adapting their voice to sound like bots because that's what works now." `celsius1414` confirms the vector: "I've definitely been reducing my day-to-day use of em-dashes the last year due to the negative AI association." This is a selection pressure on human expression. The optimization target for online writing is now "doesn't trigger AI suspicion," which produces flat, hedged, deliberately imperfect prose. The irony: this makes human writing *more* homogeneous, closing the gap that was supposed to distinguish it from AI.

**4. The PageRank analogy is the best framework anyone offers**

`shadowgovt` reframes the entire problem historically: before PageRank, the web was flooded with black-on-black keyword spam. PageRank was the "nuclear weapon" that swung things back. We're in an interregnum where auto-generated human-shaped content has outpaced filtering tools. This is cyclical, not terminal. "I'm giving it time, and until it happens I'm using a smaller list of curated sites I mostly trust."

This is the thread's most sober and useful take, and it's notably under-engaged. The thread *wants* despair; it doesn't want "we've been here before."

**5. Every proposed verification scheme fails on contact with the thread's own critique**

The solutions pile up and each gets immediately shot down: government ID verification (`big-and-small`: "fairly easy to farm real ID NFC data"), biometrics (`big-and-small` again: "AI is getting pretty good at generating face/video details"), Worldcoin-style orb scanning (`Gasp0de`: "Great, let's just require biometric identification before posting online, what could go wrong"), PGP web of trust (never scaled in 30 years), latency-based location verification per `jmyeet`'s interesting proposal (breaks for Starlink, high-latency networks, travel). The X/Twitter location feature experiment, which `jmyeet` cites, actually demonstrated the fragility in real-time: it exposed MAGA accounts based in Bangladesh and Nigeria, then got pulled within 48 hours after the DHS-in-Israel controversy.

The thread reaches an implicit consensus it never states: there is no authentication solution that simultaneously preserves anonymity, scales globally, resists state-level adversaries, and doesn't create worse problems than it solves.

**6. The economic engine is invisible in this discussion**

`DudeOpotomus` grazes it — "Advertising is a cancer. Adtech is the delivery mechanism" — but then goes off a cliff by proposing creators should *pay* platforms. `granitepail` gets closer: "To me, it's very obvious that the problem is social media. To social media, AI slop is peak efficiency." But nobody follows the thread to its logical conclusion. The attention economy *needs* bots. Platforms report "engagement" to advertisers. Bots engage. Cleaning up bots means reporting lower numbers. The incentive structure is self-reinforcing.

**7. Semantic search as an adversarial filter is the one concrete, working solution**

`MarginalGainz` provides the thread's only report from the front lines: "The 'Dead Internet' has effectively broken traditional keyword search (BM25/TF-IDF). Bad actors can now generate thousands of product descriptions that mathematically match a user's query perfectly but are semantically garbage. We had to pivot our entire discovery stack to Semantic Search (Vector Embeddings)... Semantic search is becoming the only firewall against the dead internet." This is the PageRank-equivalent `shadowgovt` is waiting for — matching on intent rather than tokens naturally filters synthetic noise.

**8. The nostalgia is real but historically selective**

`yason` writes a beautiful elegy for the old internet: "I remember when TV and magazines were full of slop of the day... The internet was a thousand times more interesting." `snickerer` pushes it further back to Eternal September 1994. But `renewiltord` punctures the balloon: "Hacker News is ground zero for outrage porn. When that guy made that obviously pretend story about delivery companies adding a desperation score the guys here lapped it up." The old internet had its own failure modes — they were just smaller-scale and human-generated. What changed isn't the presence of garbage but its unit economics.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Em-dashes are a real human convention" | **Strong** | Comprehensively demonstrated by multiple long-time users. The article's core tell is wrong. |
| "Dead internet has always been this way" | **Medium** | Historically valid (Eternal September, SEO spam) but understates the qualitative shift from AI-generated content at near-zero marginal cost. |
| "Verification/identity is the answer" | **Weak** | Every proposal gets demolished. Thread reaches implicit consensus that no scheme works without unacceptable trade-offs. |
| "It's just nostalgia" | **Medium** | Partially valid — old internet had spam, scams, and misinformation. But dismisses the real change in content generation economics. |
| "This is cyclical, like pre-PageRank spam" | **Strong** | `shadowgovt`'s analogy is historically grounded. The question is whether the next filtering breakthrough arrives before the damage compounds past recovery. |

### What the Thread Misses

- **Platform complicity.** Nobody names the core conflict of interest: platforms profit from engagement metrics that bots inflate. Cleaning up bots means reporting lower DAU/MAE to advertisers. No publicly traded social media company has an incentive to actually solve this.
- **HN's own moderation as a partial existence proof.** `dang` and the flagging system are mentioned nowhere. HN is *already* a partially working answer to dead internet — heavy human curation, aggressive flagging, culture of substance over engagement. The thread discusses HN's vulnerability without acknowledging its relative success.
- **The article's own anecdote is never resolved.** Was the accused open-source developer actually using AI? The thread takes the meta-narrative at face value and runs with the philosophical implications. Nobody asks the obvious empirical question.
- **Quality vs. authenticity is the wrong axis.** The thread obsesses over "is this human or bot?" when the useful question is "is this information accurate and valuable?" A well-written bot comment that is factually correct and insightful is more valuable than a human comment that is wrong. The fixation on provenance over quality is itself a symptom.

### Verdict

The thread circles but never names the actual mechanism: Dead Internet Theory is really Dead Incentive Theory. The internet isn't dead because bots killed it — it's dead because the advertising-funded attention economy rewards exactly the behaviors bots excel at: volume, engagement optimization, emotional triggering, and content that is good enough to click but not good enough to remember. Humans are now adapting their expression *downward* to avoid triggering AI suspicion, which closes the human-bot gap from the other direction. The fix isn't better detection of who's a bot — it's changing what gets rewarded. `shadowgovt`'s PageRank analogy points to the right shape of solution (a filtering revolution that changes the economics of slop), and `MarginalGainz`'s semantic search work may be an early example. But the thread's dominant mood of nostalgic fatalism ensures nobody builds toward that here.
