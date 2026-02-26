← [Index](../README.md)

# HN Thread Distillation: "New accounts on HN more likely to use em-dashes"

**Source:** [marginalia.nu](https://www.marginalia.nu/weird-ai-crap/hn/) · [HN thread](https://news.ycombinator.com/item?id=47152085) (637 points, 522 comments) · 2026-02-25

**Article summary:** Viktor Lofgren (marginalia_nu) scraped HN's `/newcomments` and `/noobcomments` feeds (~700 each) and found new accounts are ~10x more likely to use em-dashes (17.47% vs 1.83%, p=7e-20) and moderately more likely to mention AI/LLMs (18.67% vs 11.8%, p=0.0018). He also found glitching accounts posting gibberish. A follow-up word-frequency analysis showed noob accounts disproportionately using "built," "tools," "agent," "api," "building" — the lexicon of AI startup marketing.

### Dominant Sentiment: Grief, defiance, and creeping resignation

The thread is less a debate than a wake. People who care about HN's signal quality are mourning it in real time, while simultaneously engaging in a collective coping ritual of gallows humor about em-dashes. The minority pushing back ("I'm a typography nerd!") are fighting a rearguard action they know they've lost.

### Key Insights

**1. The word-frequency data is more damning than the em-dash finding**

The em-dash stat is the headline, but marginalia_nu's follow-up word-frequency table is the real payload. New accounts disproportionately use "built" (10.93% vs 2.11%), "tools" (7.6% vs 2.67%), "agent/agents" (~14% combined vs ~5%), "api" (6.53% vs 1.12%). This isn't a writing-style artifact — it's the vocabulary of AI product marketing. As `overfeed` put it: "I bet every single AI-startup dude who does it thinks they've stumbled on a brilliant, original, gold-mine of an idea to use AI to shill their product/service on internet forums." The word distribution fingerprints a specific motivation: astroturfing for AI developer tools.

**2. The em-dash signal is already obsolete — and that's the point**

Multiple commenters noted that filtering em-dashes from LLM output is trivial. `atleastoptimal`: "It would be trivial to make a HN comment agent that avoids all the usual hallmarks of AI writing. Mere estimations of bot activity based on character frequency would likely underestimate their presence." `pessimizer` sharpens this: "those accounts that are causing 10x as many em-dashes are the *dumb* AI accounts. The smart ones are at the least filtering obvious tells from the output. They might even outnumber the dumb ones." The em-dash finding is useful precisely because it measures the floor, not the ceiling, of bot activity.

**3. The real bot strategy is account aging, not commenting**

Several experienced users converged on this: the bots aren't primarily commenting for engagement — they're farming accounts. `im3w1l`: "The goal is likely to be able to astroturf with aged accounts down the line." `giraffe_lady` described the established market for "accounts with authentic but anodyne histories" on Reddit, now automatable with LLMs. `garganzol` caught a specific case: user `snowhale` had 160 karma from only 4 bland comments — suggesting vote-ring amplification. The current bot wave may be the *planting season* for influence operations that haven't started yet.

**4. HN's karma system creates a perverse threshold problem**

`rcarmo`: "some of them already have enough karma to downvote you if you call them out." Once a bot account crosses the downvote threshold, it can actively suppress the humans trying to identify it. The thread surfaced a genuine adversarial dynamic: bot networks don't just add noise, they gain governance powers within the platform. `co_king_6` claimed their old account was banned for "opposing AI" — true or not, the perception that bots have structural advantages is corroding trust.

**5. Humans are degrading their own writing as camouflage — and this is itself a form of damage**

This is the thread's most poignant and original theme. `mrandish` (11-year account) stopped using em-dashes he'd typed via custom AHK bindings for years. `pvtmert`: "I started making deliberate grammar and spelling mistakes in professional context." `solomonb`: "I've largely stopped correcting any spelling or grammar mistakes in my communications as a way to assert I am a human." `anotherlab`: "I used to use em-dashes and en-dashes in my work emails and other writings, but stopped using them when they became AI markers." `pronik` delivered the thread's best systemic critique: "The same things that would have made you fail a written essay in school are somehow becoming a requirement... people who have paid attention in school have to bow to people who are somehow convinced that perfect spelling is a sign that someone cheated." LLMs haven't just polluted the information commons — they've inverted the social reward for literate writing.

**6. The "I'm a typography nerd" defense has a real confound — but the data survives it**

The most common pushback: iOS autocorrects `--` to em-dashes, Mac makes them easy (`alt+shift+-`), and some humans genuinely love proper typography. `marginalia_nu` parried cleanly: "Are you saying new accounts are 10x more likely to be using macs? That would be quite a thesis." The 10x differential is too large for platform demographics to explain. However, `cookiengineer` raised a legitimate point about non-native speakers using AI revision tools — `blahgeek` confirmed this is a real use case. The data likely captures a mix of full bots and humans laundering their writing through LLMs, and the thread never clearly separated these populations.

**7. The incentive question has a clear answer the thread kept re-asking**

At least five separate sub-threads asked "why would anyone bot HN?" despite the answer being obvious and stated repeatedly: HN influences tech media, VC sentiment, and developer adoption. `fzeroracer`: "It's 2026 and not 2016; HN is a much larger platform than people seem to think it is." `elzbardico`: "Lots of tech journalists in mainstream media use it to get a pulse on what the SV/VC/Startup crowd are talking about." `marginalia_nu`: "If you control a bunch of established accounts, you can use them to either shill for products, or upvote certain topics." The repeated re-asking is itself evidence that HN's self-image as a small nerdy forum hasn't updated to match its actual influence.

**8. `rob`'s bot-catching method outclasses stylometric detection**

User `rob` identified live bots not by writing style but by *timing*: two detailed comments posted <30 seconds apart from the same account. This is a fundamentally harder signal to fake — you'd need to deliberately throttle your bot, which most operators haven't bothered to do. He named three specific accounts (`aplomb1026`, `dirtytoken7`, `fdefitte`) as active bots. Behavioral signals (posting velocity, response patterns, activity hours) are more durable than stylometric ones because they're harder to optimize away without reducing throughput.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "iOS/Mac autocorrects to em-dashes" | Weak | Doesn't explain 10x differential for *new* accounts specifically |
| "Non-native speakers use AI to polish writing" | Medium | Real confound, but blurs into "humans using LLMs to comment" which is *also* a problem |
| "Proper typography is a human right" | Irrelevant | Nobody disputes this; the finding is statistical, not individual |
| "Sample size is small" | Weak | n≈700 per group; p-values are vanishingly small; effect sizes are enormous |
| "Just teach bots to avoid em-dashes" | Correct but misdirected | Strengthens the conclusion — measured bots are the dumb ones |

### What the Thread Misses

- **The word-frequency data points to a specific actor profile** — likely AI dev-tool startups astroturfing Show HN / AI threads — but nobody tried to map the bot accounts to specific product mentions or submission patterns. The data is right there in marginalia_nu's SQLite dump.
- **No one asked whether HN's front-page algorithm is already compromised.** If bot networks can upvote, the ranking system is gamed, and everything downstream (what gets discussed, what gets traction) is tainted. The thread treats commenting as the battlefield while ignoring voting.
- **The "humans degrading their writing" phenomenon has a name in other contexts: chilling effect.** The analogy to surveillance causing self-censorship is exact, but nobody drew it. People aren't just dropping em-dashes — they're pre-filtering their expression through "will this look like AI?" which is a form of cognitive overhead that degrades discourse quality independently of any bot.
- **`dang` appeared in the thread but offered no indication of systemic countermeasures** beyond his personal em-dash defiance and a link to a prior thread. For a 637-point post about platform integrity, the official response was conspicuously casual.

### Verdict

The thread demonstrates a community that has correctly diagnosed the disease but can't agree on treatment because it hasn't accepted the prognosis. The em-dash finding is a thermometer reading, not the fever — and the real temperature is in the word-frequency table, which maps almost perfectly to AI startup marketing vocabulary. HN isn't primarily being botted for fun or political manipulation; it's being botted as a growth-hacking channel for AI developer tools, which gives the astroturfing a grim recursive quality: AI products using AI bots to manufacture consensus about AI on the forum most likely to influence AI adoption. The community's response — humans voluntarily degrading their writing to avoid false accusation — is the AI equivalent of TSA security theater: it imposes real costs on legitimate participants while being trivially circumvented by adversaries.
