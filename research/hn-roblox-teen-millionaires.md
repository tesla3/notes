← [Index](../README.md)

## HN Thread Distillation: "Roblox is minting teen millionaires"

**Source:** [Bloomberg, March 2026](https://www.bloomberg.com/news/articles/2026-03-06/roblox-s-teen-millionaires-are-disrupting-the-gaming-industry) by Cecilia D'Anastasio · [HN thread](https://news.ycombinator.com/item?id=47293337) (108 pts, 117 comments, 85 authors)

**Article summary:** Bloomberg profiles Roblox creators like Nate Colley (19, $400K/month from *Fisch*) and others earning six-to-eight figures annually. Roblox paid $1.5B to creators last year, with top 1,000 averaging $1.3M each. The piece frames this against traditional gaming industry decline (EA/Ubisoft layoffs) and positions Roblox creators as a new model — teens who "chill" while collecting massive passive income.

### Dominant Sentiment: Skeptical admiration shadowed by exploitation anxiety

The thread splits cleanly: people who've built on Roblox defend the economics as workable; everyone else sees a company skimming 72-75% off children's labor while Bloomberg runs what amounts to a recruitment ad.

### Key Insights

**1. The revenue share debate is a proxy war over what "platform" means**

The thread's most heated exchange isn't really about percentages — it's about whether Roblox is a marketplace (where 72% is extortionate) or an infrastructure provider (where 33% after costs is normal). [Heliodex] makes the strongest defense, arguing the old 24.5% figure from YouTube exposés is calculated by "multiplying 3 arbitrarily chosen numbers together" and that the real post-cost developer share is ~67%. [Retric] fires back with Roblox's own language: "On average, 67% of all spending in experiences *supports OR goes to* developers" — where "supports" does not mean "paid to." The actual direct payout is 28%. [bhawks] tries to resolve this by pointing out Roblox provides free multiplayer hosting, SRE, cross-platform distribution — real costs that other indie devs pay out of pocket.

The thread never lands this plane. Both sides are correct within their framing. The real question nobody asks: **at what scale does the subsidy argument break down?** A game earning $400K/month doesn't need Roblox to absorb its hosting costs — that game is subsidizing thousands of dead games. The platform's redistributive model, where hits fund the infrastructure for failures, is a progressive tax that becomes regressive at the top.

**2. The Bloomberg piece is doing exactly what amiga386 says it's doing**

[amiga386]'s top comment — "Roblox's favourite thing is puff pieces talking about how people who make games for them strike it rich" — is essentially correct and the thread knows it. The afterschool Substack summary reveals the buried lede from the full article: the median Roblox creator earns approximately **50 Robux per year (~$0.19)**, per [nsingh2]'s data from Roblox's own 2022 report. Only 11,000 out of 7.5 million creators qualified for cash-out. This is a power-law distribution so steep it makes YouTube look egalitarian.

Bloomberg's framing — teens "disrupting the gaming industry" — inverts the actual story. The disruption isn't that teens are getting rich; it's that Roblox built a platform where millions of children produce content for free while a handful win the lottery.

**3. The child safety debate has calcified into a jurisdictional dodge**

[yieldcrv], who runs a Roblox studio, states plainly: "this is Discord's problem." The predation happens off-platform; Roblox already age-gates chat. [tadfisher] calls this "the actual excuse Roblox used when confronted with actual evidence of child sex trafficking" and notes Roblox only implemented restrictions after YouTube exposés pressured parents. Neither side is wrong on facts, but the thread reveals a structural blindspot: **when half of all American children under 16 are on your platform, "it happens off-platform" is a description of your funnel, not a defense.** [Aeolun] tries the volume argument ("that's a volume issue, not something inherent to the platform") which is technically true but misses that Roblox chose to be the platform where children are the product.

**4. The $40M FIRE number is more interesting than the thread realizes**

Colley wants to work 10 more years to hit $40M before "retiring" to make Roblox games as a hobby. The thread treats this as either anxiety or naiveté. [Swizec] does the math: you can FIRE in SF on $4M. [pear01] calls it "extreme greed or delusional." [Imustaskforhelp], an actual teenager, offers the sharpest take: "if you are online and you see people flexing their 1 million dollar watch, you are gonna add 12 more years of life on a project to get to that level."

But the thread misses the key context [himata4113] drops almost offhandedly: **"Roblox games have a shelf life of days."** Colley's $400K/month is not an annuity. [hooloovoo_zoo] notes his traffic has already declined 90% from peak. The $40M target isn't anxiety about cost of living — it's a rational response to extreme income volatility with zero career fallback. The kid understands his situation better than the commenters advising him.

**5. Roblox is the shopping mall of the 2020s — and that's not a compliment**

[2001zhaozhao] provides the clearest signal on Roblox's moat: a single Roblox Bedwars clone gets more concurrent players than the largest Minecraft server in the world. [Svoka] drops the jaw-dropper: "Grow a Garden reached 21.6 million concurrent players" versus Steam's all-time record of 3.2M (PUBG). Roblox's scale is not gaming-scale — it's social-media-scale.

[fc417fc802] makes the comparison explicit: "Consider how much money used to be spent by children in aggregate at suburban shopping malls." [ares623] completes it: "What used to go to local business... now goes to a single company on the other side of the world." This is the actual disruption Bloomberg should have written about — not teen millionaires, but the total capture of children's leisure spending by a single extractive intermediary.

**6. The Lua economy is quietly massive**

[joezydeco]'s throwaway joke — "The one place where Lua coders are valuable" — spawns a list (Factorio, WoW, Neovim, Redis, Wireshark) that reveals Lua is embedded in far more critical infrastructure than its reputation suggests. But the Roblox context adds something: **Lua is probably the most monetized scripting language per capita**, given that its largest active developer community is teenagers building on a platform that paid $1.5B last year.

**7. The RuneScape parallel is more instructive than the MySpace one**

[blakesterz] cites MySpace teen entrepreneurs, but [JumpCrisscross]'s RuneScape reference lands harder. [draftsman] reveals that RuneScape private server operators were pulling "mid six-figures annually" as teens, and that "the founders of online casino Stake and streaming platform Kick both started their 'careers' in RuneScape gambling." [Ameo] describes a clanmate running "a proper hedge fund" on the Grand Exchange who now does quantum computing at Google. The pattern: game economies as training grounds for financial intuition. Roblox is this at 1000x scale — an entire generation learning market dynamics, content economics, and platform dependency before they're old enough to drive.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "75% cut is exploitation" | Medium | Conflates gross take with net-of-costs; ignores hosting/distribution subsidies. But the subsidy argument weakens for top earners. |
| "It's Discord's problem, not Roblox's" | Weak | Technically accurate, structurally evasive. You built the funnel. |
| "The old exposé videos are debunked" | Strong | [Heliodex] provides specific, verifiable rebuttals. The 24.5% figure was methodologically flawed. Current rates are better. |
| "Parents should just parent" | Medium | [Aeolun]: "Those guardrails exist. They're called parents." True in theory; ignores that the platform is explicitly designed to be unsupervised. |
| "Loot boxes = slot machines for kids" | Medium | [jameson] is directionally right but [Aeolun] correctly notes "core gameplay loops work just fine without it." The problem is targeting, not mechanics. |

### What the Thread Misses

- **Labor law implications.** If a 15-year-old is earning $400K/month building content for a platform, in what jurisdiction is that not employment? The thread never asks whether Roblox's "creator" framing is a misclassification strategy identical to Uber's.
- **Brand advertising in children's games.** Colley gets royalties from Lego and Walmart ads on digital fishing rods. The thread ignores that this is advertising directly to children inside games, sidestepping regulations that would apply to TV.
- **Tax and financial literacy.** These teens are earning W-2-equivalent income through DevEx. Nobody asks whether a 16-year-old making $200K understands estimated quarterly taxes, or whether Roblox provides any financial guidance.
- **What happens when Roblox changes the rules.** The thread treats Roblox's current economics as stable. Every platform in history has reduced creator payouts once creators are locked in. The 2025 DevEx increase [Heliodex] cites could easily reverse.

### Verdict

The thread circles two things it never quite says. First: Roblox has achieved something unprecedented — a platform where children's play *is* the product, the labor, and the marketing, all simultaneously. The teen millionaires aren't disrupting gaming; they're the visible tip of a system that converts millions of hours of children's creative effort into $5B of revenue, returning 17-28 cents on each dollar. Second: the Bloomberg article is itself part of the machine. Every "teen millionaire" profile is a customer acquisition tool aimed at the next cohort of kids who'll build for free. The thread sees this clearly in [amiga386]'s top comment but never follows it to the conclusion: the article's existence is the strongest evidence for the critique.
