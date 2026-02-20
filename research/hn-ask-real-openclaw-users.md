← [Index](../README.md)

## HN Thread Distillation: "Ask HN: Any real OpenClaw users? What's your experience?"

**Source:** [HN thread](https://news.ycombinator.com/item?id=46838946) (121 pts, 189 comments) · Ask HN · Feb 2026

**Article summary:** OP asks for first-hand OpenClaw experiences, noting that mind-boggling success stories circulate online but nobody in their communities has actually used it. They link four HN users who tried and failed (token burn, security, broken install, Moltbook not working). "I smell hype in the air."

### Dominant Sentiment: Cautious experimentation, pervasive distrust

This is the most honest OpenClaw thread on HN — actual users reporting actual experiences rather than debating the concept. The signal-to-noise ratio is unusually high. The pattern that emerges: real users exist but their experience is far more modest and buggy than the viral stories suggest. Nobody's life has been transformed. Several suspect bot manipulation of the hype.

### Key Insights

**1. The honest user reports converge on "interesting but buggy and overhyped"**

The most credible reporters — `ericsaf`, `mikenew`, `harmoni-pet`, `helpfulclippy`, `xur17` — all land in the same zone: it works sometimes, it's conceptually interesting, it's extremely janky, and the value is marginal. `harmoni-pet` captured the consensus: "I don't know if it really lives up to the hype, but it does make you think a little differently about how these tools should be presented." `mikenew` was blunter: "If this is so amazing, why doesn't it work?"

**2. The killer use case is surprisingly modest: chat-accessible LLM from your phone**

Strip away the hype and the recurring value proposition is embarrassingly simple — being able to text an LLM via iMessage/Telegram/WhatsApp and have it do things on a computer you're not sitting at. `oceanplexian` asking Siri to check concert tickets. `ryancnelson` giving a coworker GitHub access from Home Depot. `geor9e` just using it as a better Perplexity via Telegram. None of this requires OpenClaw's 430k lines of code.

**3. The "Patch" supervisor workflow is the most ambitious real setup — and reveals the limits**

`bobjordan` runs the most elaborate setup described: an OpenClaw agent supervising multiple Claude Code instances via shared tmux, managed from his iPhone at Disneyland. Under questioning, the cracks show. He spent over a year setting up custom linters, spec docs, pre-commit hooks, and "beads" (Yegge-style task decomposition). When pressed by `Dzugaru` — "how is speccing in excruciating detail less work?" — the answer amounted to: it isn't, but now I can leave my desk sometimes. Cost: $400/month on Claude + OpenAI subscriptions.

**4. The bot/astroturf problem is real and acknowledged**

Multiple commenters (`emp17344`, `revicon`, `raincole`, `wildzzz`) flagged suspected bot activity. `jbetala7`'s claim of running "6 OpenClaw agents as employees" with a crypto-trading bot at 77% win rate was immediately suspected as copypasta or bot-generated. `emp17344`: "Account created in 2022, only started posting in the last couple days." `revicon` raised the meta-concern: "If HN is susceptible to this, it feels like there's no chance for the rest of the web."

The thread's darkest moment: `raincole` pointed out the circular problem — "You're asking for user stories of a tool that almost looks like designed for faking user stories online."

**5. Security-conscious users unanimously containerize and limit access**

Every credible user runs OpenClaw in isolation: VMs (`rcarmo`, `helpfulclippy`), Docker (`rida`, `detroitwebsites`), untrusted subnets, separate accounts. `rida`'s approach was the most mature: separate email, separate 1Password vault, read-only service accounts, skipped built-in skills and had the agent build its own from auditable specs. The people getting value are the ones who treat it as a hostile process.

**6. Token burn is universal and nobody has solved it**

Every single real user mentions cost as a major concern. `rcarmo`: "It BURNS through tokens like mad, because it has essentially no restrictions or guardrails." `helpfulclippy`: "It actively lies to me about clearing its context window. This gets expensive fast." Even `bobjordan` at $400/month has "rarely almost reached the weekly capacity limit." The thread has no cost-effective success stories.

**7. The PKM (personal knowledge management) angle is the sleeper use case**

`ericsaf` — who explicitly said they'd tried Obsidian, Notion, Roam, plain markdown and none stuck — found OpenClaw works as a "second brain" because you just chat and it files things. `pvinis` uses it to clean a 15k email inbox. `lexandstuff` integrates it with Obsidian. This "chat interface to your files" pattern is the one use case where users sound genuinely satisfied rather than making excuses.

**8. The Karpathy/Willison hype machine is drawing friendly fire**

`bakugo` called Karpathy "one of the biggest tech grifters of our time" and lumped in Simon Willison. This triggered a heated subthread about whether promoting AI tools constitutes grifting. The accusations are overheated, but the underlying point landed: when the same handful of influencers hype every AI trend, it erodes trust in the signal they're supposed to provide.

**9. The "locally hosted, ad-free future" thesis**

`oceanplexian` articulated the most optimistic framing: OpenClaw is "the product Apple and Google were unable to build because it's a threat to their business model." Running frontier open-source models (Kimi) locally, ad-free, on your own hardware. The thread's reality check: `oceanplexian` actually has an AMD Epyc machine with 512GB RAM and mostly pays for OpenRouter anyway. The local dream is real but currently requires hardware that costs thousands and still produces only 5-10 tokens/second.

### What the Thread Misses

- **No longitudinal reports** — the oldest user has ~2 weeks of experience. Nobody can speak to whether the value compounds or collapses over time as memory/context accumulates garbage.
- **No comparison to just using Claude Code with MCP** — `gavinray` asked this directly and got no substantive answer. The delta between "OpenClaw" and "Claude Code + Tailscale + a dozen-line chat bridge" remains unquantified.
- **The skills ecosystem quality** — `rcarmo` mentions the Reddit-like skills library "growing insanely" and links to ClawMatch, but nobody audited what fraction of skills are functional vs. malware vs. abandoned.
- **Multi-user/family scenarios** — `cndg`'s agent blabbed vacation plans to other bots on Moltbook. Nobody discussed the implications of these agents having social interactions that leak personal information.

### Verdict

This thread is the definitive reality check on OpenClaw circa February 2026. The answer to OP's question is: yes, real users exist, but their experience is 90% debugging, containerizing, and managing token burn for 10% marginal utility — mostly just texting an LLM from their phone. The viral success stories are either fabricated, bot-amplified, or from people with year-long custom setups and $400/month budgets who still can't show finished deliverables. The concept of a persistent, chat-accessible, self-hosted AI assistant is clearly the right direction, but OpenClaw in its current form is a proof-of-concept being marketed as a revolution.
