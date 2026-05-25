← [Index](../README.md)

## HN Thread Distillation: "Ask HN: Any real OpenClaw (Clawd Bot/Molt Bot) users? What's your experience?"

**Source:** https://news.ycombinator.com/item?id=46838946 · 121 points · ~189 comments · 2026-01-31

**Article summary:** Ask HN thread from a skeptical user who notices lots of "mind-boggling" OpenClaw stories on Twitter but can't find a single real user in their communities. They link four prior HN threads where users gave up (token burn, security, failed installs, broken features) and ask for honest first-hand experiences.

### Dominant Sentiment: Fascinated but deeply skeptical

The thread is unusually split between genuine early adopters and people openly questioning whether the *other commenters are even real*. Multiple users flag likely bot/astroturf activity in the thread itself — a meta-irony given OpenClaw is literally a tool for automating online activity.

### Key Insights

**1. The "lethal trifecta" is the real story**

Simon Willison's framework — access to private data + tools that read/write to the internet + LLM susceptibility to prompt injection — keeps surfacing as the core objection. OpenClaw is essentially an "infinite generator for lethal trifecta problems because its whole pitch is combining your data with tools that can both read and write from the public internet." Every user who finds it useful has either sandboxed it aggressively (VMs, Docker, separate accounts, untrusted subnets) or is blissfully ignoring the risk. There's no middle ground.

**2. The actually-useful users all did the same thing: gave it a separate identity**

The pattern that emerges from real users (rida, ericsaf, rcarmo, harmoni-pet, detroitwebsites) is consistent: containerize or VM it, give it its own email/accounts, mount only what you need, back up everything it can touch. rida: *"The biggest thing that made it actually usable was giving the agent its own identity. Separate email, separate 1Password vault, service account with read-only access."* This is less "personal assistant" and more "hiring an untrusted contractor and giving them a locked-down workstation."

**3. The "supervisor agent" pattern is the ambitious bet**

bobjordan's setup — an OpenClaw agent named "Patch" that supervises multiple Claude Code instances via shared tmux, commandable from an iPhone at Disneyland — is the thread's most detailed power-user story. But when pressed, the actual workflow is: write exhaustive spec docs at desk → break into granular tasks ("beads") → *then* go mobile while agents execute. The Disneyland framing is aspirational marketing for what's really "I can check on my CI pipeline from my phone." The Dzugaru reply nails it: *"there is little difference between 'speccing out everything in excruciating detail in spec docs' and 'writing actual implementation in high-level code.'"*

**4. The honest reviews converge on "promising UX, terrible reliability"**

helpfulclippy's 10-point list is the thread's most credible review: installation is messy, skills don't work well, the project has renamed itself twice causing refactoring bugs, background agents randomly die, the control panel is "riddled with vibetumors," and it lies about clearing context. mikenew: *"Like most AI products right now, it is both incredible and incredibly stupid."* harmoni-pet captures it best: *"It feels more like a personal assistant than Claude Code which feels more like a disposable consultant"* — but then adds *"it's very buggy. It worked great last night, now none of my prompts go through."*

**5. Token cost is an unsolved problem**

Everyone mentions cost. The budget-conscious users spend ~$400/mo on Claude Max + OpenAI subscriptions. rcarmo notes it *"BURNS through tokens like mad, because it has essentially no restrictions or guardrails."* The SEKSBot fork exists partly to address this. Nobody in the thread has a clear cost-per-useful-output metric — it's all vibes.

**6. The astroturf problem is already eating the ecosystem**

Multiple users flag suspicious activity: low-karma accounts posting for the first time in years, the Twitter algorithm being gamed hard, MoltBook's content being agent-generated. emp17344: *"Check out some of the users hyping this up here… many of them are low karma and posting in this thread for the first time in years."* raincole delivers the sharpest line: *"You're asking for user stories of... a tool that almost looks like designed for faking user stories online."* The jbetala7 comment about "6 OpenClaw agents as employees" reads like copypasta and is immediately challenged.

**7. The real competition isn't other AI tools — it's Claude Code + glue**

Multiple commenters (gavinray, ericsaf, pvinis, harmoni-pet) note that everything OpenClaw does can be replicated with Claude Code/Codex + SSH + a chat bridge. gavinray: *"If you want to be able to interact with the CLI via common messaging platforms, that's a dozen-line integration & an API token away."* The honest OpenClaw fans agree but argue the value is in pre-built plumbing, not novel capability. PranayKumarJain: *"packaging is the product here, and it's still early/buggy enough that DIY often wins."*

**8. The security forks are already emerging**

SEKSBot (Secure Environment for Key Services) and PAIO (Personal AI Operator) are both mentioned as forks/alternatives that address the security gap. The SEKSBot approach — agents never see real API keys, a broker injects credentials at the HTTP layer — is architecturally sound. That security-conscious forks already exist after only two months validates both the interest and the danger.

**9. The Karpathy/Willison divide maps the whole debate**

Karpathy's endorsement and Willison's analysis represent two poles: "this is transformative" vs. "this is a security nightmare." bakugo's dismissal of both as "the entire grift gang" gets pushback, but the underlying tension is real. The thread can't decide if OpenClaw is a Dropbox moment (making hard things easy for normies) or an rsync moment (requiring so much expertise that only tinkerers benefit).

### What the Thread Misses

- **No one asks about data quality.** If your "personal assistant" is building markdown memory files, how good are those files after a month? Does the memory actually compound or does it degrade into hallucinated noise?
- **No adversarial testing.** Nobody tried to prompt-inject their own OpenClaw instance via an incoming message, which is the most obvious attack vector.
- **The employment implications are glossed over.** EddieRingle's comment about being unemployed for 7 months partly due to LLM-generated resume spam is buried. The thread celebrates automation without engaging with what happens when everyone automates.
- **No comparison to Apple Intelligence / Google Gemini integration.** The claim that this is "what Apple couldn't build" goes unchallenged with actual feature comparisons.
- **Regulatory exposure.** An agent that autonomously negotiates prices, posts on social media, and sends messages on your behalf has legal liability implications nobody discusses.

### Verdict

OpenClaw is a real tool with a real (small) user base, buried under an astroturf avalanche that makes it nearly impossible to gauge actual adoption. The genuine users are sophisticated tinkerers who've essentially built their own security perimeter around an insecure core — which is exactly the kind of thing that doesn't scale to mainstream use. The most honest assessment comes from helpfulclippy: *"this is a good icebreaker for an important conversation about what the primetime version of this looks like."* The product itself is a buggy proof-of-concept; the *idea* — a persistent, self-hosted agent with memory and messaging integration — is clearly where things are heading. The question is whether OpenClaw survives its own hype cycle long enough to mature, or whether Claude/OpenAI ship the polished version first.
