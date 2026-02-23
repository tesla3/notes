← [Index](../README.md)

# HN Thread Distillation: "Is Show HN dead? No, but it's drowning"

**Source:** [HN thread](https://news.ycombinator.com/item?id=47045804) (518 points, 423 comments) · [Article](https://www.arthurcnops.blog/death-of-show-hn/) · Feb 2026

**Article summary:** Arthur Cnops analyzes Show HN data from Feb 2023 to Jan 2026, showing post volume ~3x'd, 1-point "graveyard" posts hit 37% (vs 26% for regular HN), page-1 dwell time collapsed to ~3 hours, and average comments dropped to 3.1. His own "useless little internet experience" (Clawntown, a crustacean island sim) disappeared instantly. He frames this through Johan Halse's "[Sideprocalypse](https://johan.hal.se/wrote/2026/02/03/the-sideprocalypse/)": the indie dev dream is dead because every idea gets vibecoded, SEO'd, and shipped before you finish your weekend.

## Dominant Sentiment: Nostalgic grief masking structural confusion

The thread is overwhelmingly sympathetic to the thesis but split on whether this is a *problem to solve* or a *phase transition to accept*. The grief is real — dozens of people sharing personal stories of posts that vanished — but almost nobody interrogates whether Show HN was ever good at what they think it was good at.

## Key Insights

**1. The "Proof of Work" collapse is really a trust collapse**

The article's framing — less effort per project means more noise — understates what's actually breaking. anonymous908213 nails the deeper issue: "The worst part of the death of Show HN is that most of these people are so allergic to putting any effort in that they can't even *write the description* themselves. The repo's readme, the ShowHN post, and often even their comments will all be fully LLM-generated." password4321 adds the sting: people are "coming here asking for human feedback... then dumping it into the slop generator pretending it is even slightly appreciated." The signal loss isn't just volume — it's that the traditional markers of human investment (a thoughtful description, engaged replies) are now trivially faked. When you can't distinguish a person who cares from a bot that doesn't, the entire social contract of "I show you mine, you give me feedback" collapses.

**2. The children's book subthread demolishes the "hidden gem" narrative**

The most revealing exchange: a poster complains their AI children's book generator got 7 points and zero free-book redemptions despite offering free printed books. Then johnfn delivers a devastating product critique: AI quality is lower than real children's books, $20 is overpriced for AI slop, and the "personalized for your kid" value prop doesn't overcome the negatives. lelanthran adds that picture-heavy books actually *slow reading acquisition*. This is the thread's quiet refutation of its own thesis: some projects that "drowned" weren't hidden gems — they were mediocre products that got accurately assessed by a small audience. The flood narrative provides comfortable cover for the harder truth.

**3. bambax's contrarian read: the graveyard IS the filter working**

"The fact that the volume is exploding but the graveyard is also exploding, is a sign that the system is working, not that it's broken." bambax (who's had Show HNs at 306, 126, *and* 2 points) argues the #1 criterion is intelligibility — can someone understand your project in 10 seconds? — and notes that the article's own "hidden gem" examples fail this test. This is the thread's best stress-test of the premise, and it largely survives: yes, filtering works for the top, but the *middle tier* — projects good enough to deserve discussion but not immediately legible — is what's actually dying.

**4. The Sideprocalypse thesis has a domain-knowledge escape hatch**

overgard pushes back on the linked Sideprocalypse essay: "Where the vibe coders with their slop cannons aren't present though is in things that require *hard won domain knowledge*." conartist6 agrees: "you could drive a star destroyer through the gaps in what software has been built so far. It's only that you can't claim any of the top shelf prizes by vibe coding." The Sideprocalypse essay is persuasive as polemic but structurally wrong — it conflates commodity CRUD apps with all software. The indie dream isn't dead; it's being forced upmarket. The question is whether Show HN's audience can evaluate upmarket work.

**5. The 1983 video game crash parallel is underexplored but apt**

drcxd draws the comparison: "Because video games of poor quality are too many, consumers simply refuse to spend time identifying the high-quality ones from the enormous poor-quality ones." This isn't just an analogy — it's a prediction of mechanism. The crash wasn't caused by bad games existing; it was caused by the *discovery cost* exceeding the *expected value* of trying a random product. Show HN is approaching this threshold. The recovery after 1983 required a quality seal (Nintendo's "Seal of Quality"). Nobody in the thread proposes an HN equivalent that doesn't immediately fall to Goodhart's Law.

**6. dang's quiet intervention reveals the actual mechanism**

Buried at the bottom: "I thought the OP's Show HN looked pretty good so I put it in the SCP" (second-chance pool). This is the most information-dense comment — it reveals that HN *already has* a manual curation mechanism for exactly this problem, and the moderator is personally intervening. The SCP is doing curator-level work at volunteer scale. The thread's many proposals (AI filters, star-count minimums, time-worked-on badges) are reinventing something that already exists but can't scale.

**7. The "vibe coding" identity crisis**

dgellow raises an underappreciated tension: "If I spent a year iterating on a design and implementation using Claude Code, in a domain I'm an expert in, will that still be considered vibe coded?" The term has become a shibboleth that conflates "used AI tooling" with "low effort." Retr0id observes that even pre-LLM, projects were judged by READMEs and demos, not code quality — so the disconnect between presentation and substance isn't new, just amplified. The community hasn't built vocabulary to distinguish "AI-assisted expert work" from "prompt-and-pray weekend project," and this category collapse hurts the former more than the latter.

## Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "The filter is working — graveyard growth means slop is being caught" (bambax) | Strong | True for top/bottom; fails for the middle tier that actually needs discussion |
| "It's always been random — same link, different day, different results" (rmast) | Medium | Randomness existed before, but the baseline probability of surfacing has materially declined per the data |
| "Programming democratization is good, actually" (wewewedxfgdf) | Misapplied | Conflates access to tools with value of output; programming was already democratized pre-LLM (nkrisc's rebuttal) |
| "Just write a compelling story and make front page of new" (chris_armstrong) | Weak | Survivorship bias; ignores that time-on-page-1 data shows even good posts get less exposure |
| "Use GitHub stars as a filter" (arrsingh) | Weak | Self-admittedly wouldn't pass his own filter; stars are trivially gameable |

## What the Thread Misses

- **Nobody questions whether Show HN was ever good at discovery.** Pre-2024, it was just *smaller* — the "golden age" was low volume masquerading as high curation. The data starts in 2023; the baseline may already have been mediocre.
- **Selection bias dominates the anecdotes.** Every personal story is from someone whose post failed. The people whose vibe-coded projects got 300 points aren't complaining. This creates an asymmetric sample that inflates the perceived problem.
- **The real bottleneck may be HN's ranking algorithm, not volume.** If page-1 slots are fixed and volume 3x'd, dwell time mechanically drops by ~3x — which is almost exactly what the data shows. This isn't "drowning"; it's fixed-supply economics. The question is whether HN should expand its showcase surface area, not whether submitters should submit less.
- **The Sideprocalypse essay and the thread share the same blind spot:** treating discoverability as a property of the project rather than the platform. No amount of "proof of work" signaling fixes a discovery surface that hasn't scaled with supply.

## Verdict

The thread circles a platform-design problem but frames it as a cultural decline. The data is real — Show HN's signal-to-noise ratio has materially worsened — but the community's instinct is to blame submitters (for vibecoding, for AI slop, for not writing their own descriptions) rather than recognize that HN's showcase mechanism was designed for a world where building and shipping software was hard enough to be its own filter. That world is gone. The meta-irony is thick: the article's own charts were vibe-coded, its author's project was self-described as "useless," and the most actionable response came not from the 400+ comments but from a single moderator quietly adding the post to a second-chance pool. Show HN doesn't need less slop — it needs a discovery architecture that doesn't depend on scarcity of effort as its quality signal.
