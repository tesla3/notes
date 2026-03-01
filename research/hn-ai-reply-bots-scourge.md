← [Index](../README.md)

# HN Thread Distillation: "AI-generated replies are a scourge these days"

- **Source:** [HN thread](https://news.ycombinator.com/item?id=47134946) (127 comments, 70 authors) — [Simon Willison tweet](https://xcancel.com/simonw/status/2025909963445707171)
- **Date:** 2025-02-23

**Article summary:** Simon Willison tweets that AI-generated reply bots are a "scourge" on Twitter, asking whether they come from packaged SaaS products or custom-built bots. He follows up noting the industry literally calls them "reply guy" tools — leaning into a pejorative term for unsolicited male commenters.

## Dominant Sentiment: Resigned fatalism with scattered defiance

The thread has the energy of people watching a flood rise and debating the merits of different sandbag configurations. Near-universal agreement the problem is real and worsening, but deep disagreement on whether any solution exists or even matters.

## Key Insights

**1. X's API restriction is security theater — the bots already moved past the API**

X quickly restricted programmatic replies to only work when the poster @mentions the bot account. dewey flagged this as responsive action, but fooker immediately deflated it: "most bots don't use the API directly. They look like normal users to the server for the most part. Google has spent billions trying to distinguish bots from users. And has been largely unsuccessful." The Twitter replies themselves confirm the mechanism: chrome extensions, browser automation, scraped session tokens. The API restriction is a policy patch on a browser-automation problem. Russian troll factories, as theshrike79 notes, "have used browser automation for years already — and they pay the $ whatever for the blue checkmark."

**2. The detection arms race is already in its terminal phase**

The most revealing moment: ossa-ma built tropes.fyi, an AI writing detector — and vidarh ran vidarh's own (human-written) comment through it, which it flagged as AI-assisted. "That says it all about the trouble with these detectors." vidarh's deeper point is that AI writes this way *because RLHF rewards patterns humans already associate with quality writing*. The tropes aren't alien artifacts — they're amplified high-school essay conventions. The Wikipedia "[Signs of AI Writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing)" page, linked by Aeglaecia, confirms this: AI regresses to the mean of its training data, producing text that's simultaneously generic and professional-sounding. mr_mitm names the consequent problem: "Not only is fake content falsely labeled as real, real content is increasingly falsely labeled as fake." The false-positive epidemic may be more corrosive than the bots themselves.

**3. "Dead internet theory is just a SaaS product now"**

The sharpest line comes from the Twitter thread itself, not HN. But the HN thread develops it: zipy124 identifies the mechanism — "trust on most sites is attributed to account history, which is cheaper than ever with these reply-guy services." simonw outlines the pipeline: bots reply to high-follower accounts → gain followers/credibility → build account history → sell accounts on secondary markets. This isn't vandalism. It's inventory manufacturing. The dead internet isn't an emergent phenomenon — it's a business model with unit economics.

**4. Every proposed solution is a different kind of poison**

The thread cycles through solutions and demolishes each in turn. Identity verification? "I can think of a bunch of governments who would love that. Most are considered totalitarian" (nottorp). Invite-only like Lobsters? Scales down, not up. Staking money? "Fails to define how low-quality undeclared slop can accurately even be classified" (OutOfHere). CAPTCHAs? "AI have increasingly become better than humans at solving the tasks we throw at them" (ben_w). Watermarking? "That ship has sailed" (A_D_E_P_T). Shared blocklists? Only treats symptoms. The thread exhausts the solution space without finding anything that works at scale without dystopian tradeoffs.

**5. The shovel seller complaining about holes in the ground**

bakugo's one-liner — "'All these random holes on the ground are a scourge' says top shovel salesman" — is the thread's sharpest critique, and benterix independently lands on it: "At first I thought why is this truism on HN, and then I realized this comment is from a prominent LLM influencer." simonw has built significant tooling and influence around LLM usage. The tension is real: the people with the deepest understanding of the problem are the ones whose work exacerbates it. simonw doesn't address this.

**6. The incentive structure is self-reinforcing and platform-endorsed**

A commenter in the Twitter thread nails the LinkedIn parallel: "they encourage you to comment on 15 posts in the 30 minutes prior to posting your own... no one wants to read 15 ai slop posts, so bot does it." The algorithm *demands* engagement volume to grant visibility. Reply-guy tools aren't exploiting the system — they're the rational response to its incentive design. As the Twitter commenter puts it: "i absolutely loath reply guy automation. but the problem is it seemingly works for growth. So people... people are the problem."

**7. The "who cares" argument is stronger than the thread wants to admit**

matwood quietly drops the most uncomfortable question: "if I was never going to meet the person on the other side of a comment it's hard to get worked up about it." somenameforme extends it: the real outcome is "a devaluing of open online chatter as a whole, which I definitely don't see as a bad thing." vidarh applies this directly: "If I get value out of a conversation, I will continue. If I don't, I'll stop responding. Whether or not the other side is an AI is only relevant if I think I'm building some kind of rapport." This camp is making a point the thread mostly refuses to engage with — that the value of anonymous online conversation was always partially illusory.

**8. The retreat to meatspace is happening but won't save discourse**

sva_ reports spending "a lot more time with people in real life" and sensing causation. oblio and others predict a push back to physical spaces. pjc50 articulates the structural problem: democracy may split into a "control plane" (media ecosystem where everything could be fake) and a "ground plane" (in-person, hard to fake, but limited information access). The retreat to meatspace solves the authenticity problem while destroying the information-access advantage that made online discourse valuable in the first place.

## Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| simonw is a hypocrite / "shovel salesman" | Medium | Valid tension, but ad hominem doesn't invalidate the observation |
| Just leave Twitter | Weak | Shifts the problem, doesn't solve it; HN and Reddit have the same dynamics |
| AI training data will collapse from this | Weak | simonw correctly notes AI labs are very selective about training data now |
| Make AI slop a crime | Weak | iberator's proposal (5 years jail for AI university cheating) reveals the desperation, not a viable path |

## What the Thread Misses

- **Platform incentive alignment**: Nobody asks the obvious question — does X/Twitter actually *want* to eliminate bot engagement? Bot replies inflate engagement metrics. Engagement metrics drive ad revenue and investor narrative. The entity with the most power to solve this problem profits from not solving it. X's API restriction is precisely calibrated to look like action while leaving the browser-automation vector untouched.

- **The quality floor problem**: LZ_Khan briefly touches this — "the blatant AI generated replies... are just the obvious ones" — but nobody develops it. The visible slop is *not* the real threat. The real threat is competent AI usage by people who know how to prompt properly, which is undetectable and growing. Everything the thread discusses (em-dashes, tropes, watermarks) only addresses the low end.

- **The submitter's own subtext**: da_grift_shift makes a pointed dig — "AI-generated replies from bots really are the scourge of HN these days" — suggesting HN itself has this problem. The thread mostly ignores this mirror.

## Verdict

The thread correctly diagnoses a symptom but can't name the disease. The real dynamic isn't "bots are hard to detect" — it's that engagement-maximizing platforms have created an economic environment where bot participation is the rational strategy for visibility, and the platforms themselves benefit from the resulting volume inflation. Every technical countermeasure fails because the system isn't broken — it's working exactly as its incentives dictate. The thread circles closest to this when discussing LinkedIn's "comment on 15 posts" rule, but never generalizes it. The uncomfortable truth nobody states plainly: the reply-guy bot industry exists because social media platforms designed reward structures that make human participation economically irrational at scale.
