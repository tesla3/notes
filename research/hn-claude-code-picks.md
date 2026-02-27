← [Index](../README.md)

## HN Thread Distillation: "What Claude Code chooses"

**Source:** [amplifying.ai](https://amplifying.ai/research/claude-code-picks) · [HN thread](https://news.ycombinator.com/item?id=47169757) (361 pts, 144 comments) · Feb 26, 2026

**Article summary:** Amplifying.ai ran 2,430 open-ended prompts against Claude Code (Sonnet 4.5, Opus 4.5, Opus 4.6) across 4 real repos and 20 tool categories. Key findings: Claude defaults to building custom/DIY solutions in 12/20 categories; when it does pick tools, it converges hard (GitHub Actions 94%, Stripe 91%, shadcn/ui 90%); newer models shift toward newer tools (Prisma→Drizzle, Celery→FastAPI BackgroundTasks, Redis→custom); deployment is stack-determined (Vercel for JS, Railway for Python; AWS/GCP/Azure get zero primary picks).

### Dominant Sentiment: Alarmed fascination at invisible kingmaking

The thread treats the findings as confirmation of something people felt but hadn't quantified: LLMs are now the world's most powerful distribution channel for developer tools, and nobody opted into this. The mood splits between people who see this as an inevitable new reality to be gamed and people who see it as a dangerous narrowing of technical choice.

### Key Insights

**1. The LLM-as-shelf-space model is already here, and the advertising layer is next**

The thread's most developed argument, led by `wrs`: "This is where LLM advertising will inevitably end up: completely invisible. It's the ultimate influencer." Multiple commenters independently converge on the same Walmart/Amazon analogy — the model provider controls shelf placement and will eventually monetize it. `awad` (who discloses working in the space) names the competing terms: AEO (Answer Engine Optimization) and GEO (Generative Engine Optimization). `alexsmirnov` outlines a concrete poisoning playbook — fake repos, clone sites, synthetic social media posts — and links to [Anthropic's own research](https://www.anthropic.com/research/small-samples-poison) showing how little data it takes. `NiloCK` links a 2023 article that predicted exactly this "Copilot SEO war." The thread treats the advertising scenario as when, not if.

**2. Tailwind's dominance is structural, not just popularity**

`CSSer` delivers the thread's strongest technical argument: Tailwind wins in LLMs because its architecture — co-located styling tokens with low surface API complexity — produces a dramatically higher signal-to-noise ratio in training data than traditional CSS. "You're going to get much fewer tokens that have random styles in it and require several fewer thought loops to get working styles." `btown` adds a token-economics angle: Tailwind minimizes characters typed, which aligns with subscription-model agents minimizing generated tokens. This is the rare insight that's falsifiable and has design implications beyond the thread: **data formats that co-locate related information are structurally advantaged in LLM recommendations**, regardless of technical merit.

**3. AGENTS.md files are a linter config, not a README — and even then they fail 20% of the time**

`matheus-rr` gives the thread's most practical advice: descriptive statements like "We use PostgreSQL" get treated as soft preferences that the model reasons past. Imperative prohibitions with reasoning — "NEVER create accounts for external databases. All persistence uses the existing PostgreSQL instance." — actually stick, roughly 80% of the time. `toraway` points out this directly contradicts years of prompting folk wisdom about never using negative instructions. `matheus-rr` concedes the contradiction honestly: "They raise the floor but don't guarantee anything." The 80% figure is the real number worth remembering.

**4. The "build vs. buy" instinct reveals a deeper architectural failure mode**

`dvt` delivers the thread's most experienced critique of agent decision-making: "agents *consistently* make awful architectural decisions... they leak the most obvious 'midwit senior engineer' decisions... they over-engineer, they are overly-focused on versioning and legacy support." `drc500free` identifies the specific mechanism: the model "assumes that there was intent behind the current choices... which is a good assumption on their training data where a human wrote it, and a terrible assumption when it's code that they themselves just spit out and forgot was their own idea." This is the sharpest observation in the thread — LLMs treat their own output with the same deference they'd give human-authored code, creating a ratchet of unnecessary complexity.

**5. The recency gradient is probably RL, not just training data**

`Clueed` argues the sharp inter-model shifts (Prisma 79%→Drizzle 100%, Celery 100%→0%) point to library-level reinforcement learning, not just updated training data. `nikcub` corroborates: "Anthropic are now hiring a lot of experts... who are writing content used to post-train models to make these decisions." If true, the tool recommendations aren't emergent — they're curated. This reframes the entire report: what looks like "what Claude discovers" may actually be "what Anthropic's team decided."

**6. The single-user app explosion is real and under-discussed**

`empath75`: "I had Claude knock out a Trello clone for me in 30 minutes because I was irritated at Atlassian." Not to share, not to productize — just for personal use. `fragmede` and `yokuze` confirm they've done the same thing independently. This is a meaningful shift: the cost of building dropped below the cost of evaluating existing tools. SaaS companies aren't just competing with each other anymore — they're competing with the 30-minute bespoke alternative.

**7. The vibecoder audience changes the equation**

`furyofantares` and `skywhopper` make the point that matters for interpreting the study: "the primary and future audience of Claude et al don't know the tools they want, or even that a choice exists." The report's methodology (no tool names in prompts) isn't a researcher's constraint — it's the actual user behavior of the fastest-growing segment. `godtoldmetodoit` (small dev agency) is already positioning to catch the doctor who vibecoded her app and now needs professional help deploying it.

**8. Redux maintainer shows up, confirms the damage is real**

`acemarke` (primary Redux maintainer, creator of Redux Toolkit) enters the thread to confirm: yes, Redux Toolkit and Zustand require similar lines of code; yes, people who chose Zustand often rebuild RTK features; yes, the "boilerplate" reputation from 2015-era Redux stuck despite 6 years of RTK being the default. "We were never in this for 'market share'" reads as dignified resignation. When the tool's own maintainer shows up and doesn't contest the findings, that's signal.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Just specify your tools in CLAUDE.md" | Medium | Works for experts, irrelevant for the vibecoder segment that's the actual growth vector |
| "This is web-centric, people use it for C/Rust/Go too" | Strong | `nineteen999` is right that the report's 4 repos are all web — real limitation |
| "The study methodology is sloppy" | Medium | `sixhobbits` and `umairnadeem123` note missing controls; `jamessb` catches TanStack Query vs FastAPI being compared as "API Layer" alternatives — genuinely bad categorization |
| "Just use multiple models to cross-check" | Medium | `ghm2199`'s workflow of pitting Opus against Codex is clever but doesn't scale to non-expert users |

### What the Thread Misses

- **Supply-side market power.** Everyone discusses LLMs recommending tools, but nobody asks what happens when Anthropic *negotiates* with tool vendors. If Anthropic is already curating recommendations via expert post-training (per `nikcub`), the step from curation to commercial partnership is tiny. The thread's "advertising" framing undersells the leverage — this is closer to app store economics than SEO.

- **The Tailwind paradox in reverse.** Tailwind's creators reportedly had to cut staff despite LLM-driven adoption explosion. The thread notes this but doesn't name the mechanism: LLMs recommend the tool but eliminate the *user relationship* that monetizes it. This pattern will repeat for every tool that wins in LLM recommendations but charges for human-facing features (docs, support, templates).

- **Regulatory surface.** `layer8` briefly mentions advertising law but the thread doesn't engage. The EU AI Act's transparency requirements for AI-generated recommendations are directly applicable here. If Claude's tool picks are RL-curated, they may legally constitute recommendations requiring disclosure.

- **The report itself as artifact.** `deaux` (in one of the thread's sharpest late comments) points out the irony that the amplifying.ai website is itself archetypical Opus 4.6 output — JetBrains Mono, specific color scheme, rounded borders. "Describe the content of the homepage to Opus 4.6 without telling it about the styling, it will 90% match this website." The research instrument is its own exhibit.

### Verdict

The thread circles but never quite states the core dynamic: **LLM tool recommendations are a new form of platform power that combines the invisibility of default settings with the persuasiveness of expert advice, directed at an audience that increasingly can't evaluate the recommendation.** The vibecoders don't know they're being steered; the expert developers can override it but resent the friction; and the tool vendors are caught in a trap where LLM adoption drives usage but destroys the relationship that pays the bills. The closest historical analogy isn't SEO — it's the browser wars, where the default won not because it was best but because evaluating alternatives required expertise the marginal user didn't have. Except this time, the "browser" makes a different default choice every model generation, and nobody publishes a changelog.
