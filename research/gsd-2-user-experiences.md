← [GSD-2 Review](gsd-2-review.md) · [Index](../README.md)

# GSD-2: User Experiences & Community Feedback

**Date:** 2026-03-18  
**Coverage:** Reddit (r/ClaudeCode, r/vibecoding, r/ClaudeAI, r/google_antigravity), Hacker News, X/Twitter, Medium, dev.to, GitHub Issues, Discord  
**Note:** GSD-2 launched publicly on 2026-03-10, making it **8 days old** at time of research. Most substantive user feedback is for GSD v1 (the prompt framework) or the GSD methodology in general. GSD-2–specific field reports are limited but growing.

---

## Summary

Real users exist and are using GSD. Feedback is **polarized**: satisfied users report impressive results on complex greenfield projects; dissatisfied users report token waste, slowness, and overkill. The pattern is consistent: **GSD works well for large, well-specified greenfield projects and poorly for brownfield, small tasks, or budget-constrained use.** GSD-2 specifically has very early positive signals but also inherits all of v1's philosophical criticisms, plus new concerns around ToS compliance and API cost.

---

## GSD-2 Specific Feedback (8 days of data)

### Positive

**Data scientist/engineer (10+ years), r/vibecoding, 51-upvote thread:**
> "I am a data scientist/engineer with over 10 years of experience, and gsd has opened doors to the world of full stack development for me. Been using Gsd 1 for several projects and just tried out gsd 2 mid milestone for one of them. Did the migration command and just went with /Gsd auto, and literally walked away for 1 hour. Came back to a finished milestone, then I ran e2e testing with playwright, a couple of issues that were discovered, gave it back to gsd 2 and then it fixed it. Works like magic."
> — u/oa95gg6 ([source](https://www.reddit.com/r/vibecoding/comments/1rqy8ie/comment/oa95gg6/))

**User running on local models:**
> "I have been running (and learning) gsd-2 for a day now with some back and forth asking/answering and fully local. I made a vibecoded bpm key detector at bpm.songtag.xyz using custom open ai to connect it to lm studio with unsloth qwen3.5 30b a3b gguf. I used tmux too, so i can make a SSH session with connectbot app on android to ubuntu pc. Crazy how I can vibecode from the couch with my mobile phone in my hand while watching series."
> — u/renczzz ([source](https://www.reddit.com/r/vibecoding/comments/1rqy8ie/comment/oar7h0e/))

**User with screenshot of running session:**
> "been running it all afternoon on auto, and still going =P love it"
> — u/Strange-Candle-5344 (with screenshot, [source](https://www.reddit.com/r/vibecoding/comments/1rqy8ie/comment/oair32x/))

**Creator's own dog-fooding (X/Twitter):**
> "GSD 2.0 has been working for 6h 57m autonomously building me an AI-native music plugin (VST/AU/CLAP) dev framework. All I did was feed it a document of my vision last night and it's been going ever since."
> — @official_taches ([source](https://x.com/official_taches/status/2031028319915774116))

**Demo to engineering team:**
> "You rock. We demoed GSD to a packed house of over 100 engineers today. Good vibes."
> — u/txgsync ([source](https://www.reddit.com/r/vibecoding/comments/1rqy8ie/comment/o9zwl1y/))

### Negative / Cautious

**HN user, concrete cost data:**
> "Yup yup yup. I burned literally a weeks worth of the $20 claude subscription and then $20 worth of API credits on gsdv2. To get like 500 LOC. And that was AFTER literally burning a weeks worth of codex and Claude $20 plans and $50 API credits and getting completely bumfucked — AI was faking out tests etc. I had better experiences just guiding the thing myself."
> — HN commenter ([source](https://news.ycombinator.com/item?id=47417804))

**User confused about v1 → v2 transition:**
> "Wondering what does it mean to my utilization: do I need to swap from CC to Pi-mono? Or is it just the same but GSD spawn agents thanks to Pi?"
> — u/CptNico ([source](https://www.reddit.com/r/vibecoding/comments/1rqy8ie/comment/o9xqbd5/))

**Previous v1 user, lukewarm:**
> "Can't wait to try it! I'll be honest last time i felt like I was just not feeling like it got a lot done :("
> — u/fredagainbutagain ([source](https://www.reddit.com/r/vibecoding/comments/1rqy8ie/comment/o9w7buy/))

### Unresolved: ToS Concerns (recurring, unanswered)

Multiple users in the r/vibecoding launch thread asked about Terms of Service:

> "This is awesome! Since it's separate from Claude Code, are there any ToS issues with using the OAuth login from CC with GSD 2.0?"
> — u/kexxty

> "I would also like the answer to this one. I guess OAuth will break ToS now?"
> — u/icloudbug

> "From what I can see, the Pi framework is the same one that OpenClaw is built on, so Im guessing that this WILL break ToS"
> — u/kexxty

> "So to clarify this breaks the OAuth TOS? Meaning you can only use api with GSD 2?"
> — u/Old_Actuator_8598

**The creator did not respond to any ToS questions in the thread.** GSD-2's own README now includes a warning: *"⚠️ Important: Using OAuth tokens from subscription plans outside their native applications may violate the provider's Terms of Service."* This is a disclosure, not a resolution — the question of whether Claude Max OAuth usage in Pi-based tools violates Anthropic ToS remains open.

([source](https://www.reddit.com/r/vibecoding/comments/1rqy8ie/))

---

## GSD v1 Feedback (extensive, informs v2 expectations)

GSD v1 (32.2K stars) has months of user feedback. These patterns are relevant because v2 inherits the same methodology.

### Strong Positive

**3-month power user, launched SaaS product (HN, today):**
> "I've been using GSD extensively over the past 3 months. I previously used speckit, which I found lacking. GSD consistently gets me 95% of the way there on complex tasks. That's amazing. The last 5% is mostly 'manual' testing. We've used GSD to build and launch a SaaS product including an agent-first CMS (whiteboar.it)."
> — HN user ([source](https://news.ycombinator.com/item?id=47417804))

**macOS app built with GSD (HN, today):**
> "Have had great results with it. I got sick of paying FreshBooks monthly for basic income/expense tracking for Schedule C reporting and used GSD to build a macOS Swift app with Codex 5.4 and Opus 4.6. It's working great and I am considering releasing it on the App Store."
> — HN user ([source](https://news.ycombinator.com/item?id=47417804))

**Senior software developer (Reddit):**
> "Just follow GSD, Open Spec or the BMAD Method. They are good enough approximations of a real-world software development life cycle. Planning, breaking the plan into tasks, executing one by one, reviewing — this is pretty much how we work and these systems recreate this process well."
> — r/ClaudeCode ([source](https://www.reddit.com/r/ClaudeCode/comments/1qh24np/))

**GSD with Antigravity (172 upvotes):**
> "GSD changed the game. I'm thinking about getting 2 x $200 subs to work in parallel."
> — r/google_antigravity ([source](https://www.reddit.com/r/google_antigravity/comments/1qg7gwg/))

### Strong Negative

**Brownfield project failure (r/ClaudeCode, 260-upvote thread):**
> "Tried it today on a relatively simple 'brownfield' project that I had already been having great success building piece meal with built in Claude Plan mode. Was initially impressed with GSD asking some thoughtful questions and generating some nice docs, but after a couple hours I decided to give up on it and revert back to before using it."
> — r/ClaudeCode ([source](https://www.reddit.com/r/ClaudeCode/comments/1qf6vcc/))

**Token consumption concerns:**
> "I just started using GSD yesterday. I haven't even made it through phase 1 research with 3 x 5 hour cycles in the Claude pro plan. I mean I know it's the small plan but that's simply insane. I only have 3k of token bloat from skills/mcp servers. What gives? It literally goes from 0% usage to 100% usage during the 4 agent parallel research."
> — u/nnennahacks ([source](https://www.reddit.com/r/ClaudeCode/comments/1qnh2db/))

**Hackathon failure (HN, today):**
> "I used this for a team hackathon and it took way too much time to build understanding of the codebase, wrote too many agent transcripts and spent way too much token during generation. It also failed multiple times when either generating agent transcript or extracting things from agent transcript — once citing 'The agent transcripts are too complex to extract from' — quite confounding considering it's the transcript you created. For what we were trying to build — few small sets of features — using gsd was an overkill. Learning for me: don't overcomplicate — write better specs, use claude plan mode, iterate."
> — HN user ([source](https://news.ycombinator.com/item?id=47417804))

**"Overengineered" criticism (HN, today):**
> "I've used both. From my experience, gsd is a highly overengineered piece of software that unfortunately does not get shit done, burns limits and takes ages while doing so. Quick mode does not really help because it kills the point of gsd, you can't build full software on ad-hocs."
> — HN user ([source](https://news.ycombinator.com/item?id=47417804))

### Cost / Token Concerns (consistent pattern)

> "Running full GSD burn my Max 200 in no time."
> — r/ClaudeCode

> "At first attempts reached Claude Pro plan limits very quickly using GSD framework. Then I paired Claude Code with GLM 4.7: Opus is superb at carving out clean, composable tasks and detecting subtle pitfalls — GLM is surprisingly good at following those tasks deterministically."
> — r/ClaudeCode ([source](https://www.reddit.com/r/ClaudeCode/comments/1qg615b/))

> "If you're not on a 200/m plan I recommend you run /gsd:settings to turn to 'budget' model profile, and turn off research before planning, checking after planning and verification after executing."
> — Creator's own recommendation ([source](https://www.reddit.com/r/ClaudeCode/comments/1qk3f46/))

---

## Hacker News Discussion (47417804, today, ~40 comments)

The most substantive technical discussion. Key themes:

### 1. "Do you even need this?"
Several experienced developers argue these meta-frameworks are unnecessary:

> "There are so many of these 'meta' frameworks going around. I have yet to see one that proves in any meaningful way they improve anything. I have a hard time believing they accomplish anything other than burn tokens and poison the context window with too much information."

> "Both are dramatically over-engineered. & That's okay. I find them to be products of an industry reconciling how to really work with AI."

> "It's basically .vimrc/.emacs.d of the current age. These meta-frameworks are useful for the one who set them up but for another person they seem like complete garbage."

### 2. "Agent harness matters"
A counter-argument that resonated:

> "I think this shows that the model alone isn't the complete story and that these 'harnesses' shape a lot of the experienced behavior of these tools."

> "I have the same experience with Antigravity and Gemini CLI, both using Gemini 3 Pro. CLI works on the problem with more effort and time. Meanwhile, antigravity writes shitty python scripts for a few seconds and calls it a day. The agent harness matters a lot."

### 3. Spec-Driven Development debate
A vigorous argument about whether natural-language specs are the right approach:

**Against:** "Spec-Driven systems are doomed to fail. There's nothing that couples the english language specs you've written with the actual code and behaviour of the system. This has been solved already — automated testing."

**For:** "Automated tests are already the output of these specs, and specs cover way more than what you cover with code."

**Nuanced:** "You can go spec → test → implementation and establish the test loop. Bit like the v model of old, actually."

### 4. GSD vs Plan Mode comparison (concrete)

> "Just tried GSD and Plan Mode on the same exact task (prompt in an MD file). Plan Mode had a plan and then base implementation in twenty minutes. GSD ran for hours to achieve the same thing. I reviewed the code from both and the GSD code was definitely written with the rest of the project and possibilities in mind, while the Claude Plan was just enough for the MVP. I can see both having their pros and cons depending on your workflow and size of the task."

### 5. "Temporary hack" prediction

> "I think they're going to be a temporary thing — a hack that boosts utility for a few model releases until there's sufficient successful use cases in the training data that models can just do this sort of thing really well without all the extra prompting."

---

## GitHub Issues (GSD-2)

The issues page shows active bug reports from multiple users as of March 17:

- **Module resolution errors** when using external Pi ecosystem packages (`@mariozechner/*` → `@gsd/*` aliasing issues, #161)
- **Bun compatibility** — extension load errors with `sharp` and `picomatch` modules (#473)
- Multiple open issues from different users (kassieclaire, rangoc, jacoblewisau, vp275, mkschulze) — indicating real adoption with real friction
- Active issue triage and fixing by maintainers

Sources: [GitHub Issues](https://github.com/gsd-build/gsd-2/issues)

---

## Community Scale

| Platform | Metric | Source |
|---|---|---|
| GitHub (v1) | 32.5K stars, 2.7K forks | github.com/gsd-build/get-shit-done |
| GitHub (v2) | ~2K stars, 172 forks (8 days) | github.com/gsd-build/gsd-2 |
| Discord | 3,202 members | discord.com/invite/gsd |
| X/Twitter (creator) | 3,236 followers | @official_taches |
| npm (v1) | 15,000+ installs (as of Jan 2026) | Creator's post |
| Medium article | Published, non-metered link available | @sajith_k |
| YouTube | "GSD Is the Missing Piece" (1 day old) | youtube.com |
| dev.to | Complete beginner's guide (18 hours old) | @alikazmidev |
| HN front page | Today, ~40 comments | news.ycombinator.com/item?id=47417804 |

---

## Token Efficiency: Architectural Analysis

The most frequent criticism of GSD is token consumption. This section analyzes whether the token burn is a design flaw or a structural consequence of the problem being solved. Conclusions are based on direct code examination of `auto-dispatch.ts`, `auto-prompts.ts`, `context-budget.ts`, `prompt-compressor.ts`, and the full dispatch pipeline.

### What GSD Actually Does Per Slice

For each slice of work, GSD dispatches up to **7 separate LLM sessions**, each starting from a fresh context window:

| Unit | Purpose | Skippable? |
|---|---|---|
| `research-milestone` | Domain research for the milestone | Yes (budget/balanced) |
| `plan-milestone` | Create roadmap with slices | No |
| `research-slice` | Slice-specific research | Yes (balanced/budget) |
| `plan-slice` | Decompose slice into tasks | No |
| `execute-task` | Write code (runs **per task**) | No |
| `complete-slice` | Summarize, verify completeness | No |
| `reassess-roadmap` | Re-evaluate remaining slices | Yes (budget) |

Plus optional units: `validate-milestone`, `run-uat`, `rewrite-docs`, `replan-slice`.

A moderate milestone (3 slices × 4 tasks each) generates **~29 LLM sessions minimum** on balanced profile, or **~40+** on quality profile. Each session injects context from prior stages (roadmap, decisions, prior summaries, task plans) because every session starts with zero state.

Source: `auto-dispatch.ts` dispatch rules (ordered match table), `auto-prompts.ts` prompt builders (`buildExecuteTaskPrompt`, `buildPlanSlicePrompt`, etc.).

### Context Re-injection: The Cost of Statelessness

Every fresh session receives inlined context. Looking at `buildExecuteTaskPrompt` — the most frequently called unit:

- Task plan + slice plan
- Prior task summaries (compressed to 40% of context budget)
- Decisions register, requirements, knowledge base
- Continue file (if resuming interrupted work)
- Active overrides, dependency summaries from prior slices

On quality profile, `buildPlanSlicePrompt` additionally inlines: full milestone roadmap, slice research, task plan template, slice plan template, executor context constraints.

The same roadmap, decisions register, and requirements are sent to the LLM in **every session**. This looks redundant but is the direct consequence of stateless session design — same reason HTTP sends auth headers with every request. Stateless protocols pay per-request overhead for reliability. This is a well-understood trade-off, not a design flaw.

Source: `auto-prompts.ts` lines 550–830, the `inlined[]` arrays in each prompt builder. Budget allocation computed in `context-budget.ts` via `computeBudgets()`.

### Rough Token Estimate

For a moderate milestone (1 milestone, 3 slices, 4 tasks each) on balanced profile:

| Phase | Sessions | Est. tokens/session | Subtotal |
|---|---|---|---|
| Research milestone | 1 | 50–100K | ~75K |
| Plan milestone | 1 | 30–60K | ~45K |
| Plan slice × 3 | 3 | 30–50K | ~120K |
| Execute task × 12 | 12 | 20–80K | ~600K |
| Complete slice × 3 | 3 | 20–40K | ~90K |
| Reassess × 3 | 3 | 20–40K | ~90K |
| **Total** | **23** | | **~1.0M tokens** |

At Anthropic API rates (~$3/1M input, ~$15/1M output for Sonnet), roughly **$5–15 per milestone**. For Opus planning + Sonnet execution on quality profile: **$20–50**. The HN report of "$20 for 500 LOC" is entirely consistent with this math.

### GSD-2's Mitigations

GSD-2 added a coordinated token optimization system (v2.17) with three levels:

| Profile | Savings | Mechanism |
|---|---|---|
| `budget` | 40–60% | Skips research + reassess, minimal inlining, routes simple tasks to Haiku |
| `balanced` | 10–20% | Skips slice research, standard inlining (default) |
| `quality` | 0% | Full pipeline, all context inlined |

Additional: `prompt-compressor.ts` shrinks inlined artifacts to target budgets. `summary-distiller.ts` condenses prior task summaries. `semantic-chunker.ts` sends only relevant portions of large context files. Complexity-based routing dispatches simple tasks to cheaper models.

Source: `docs/token-optimization.md`, `preferences.ts` profile resolution, `prompt-compressor.ts`, `summary-distiller.ts`.

### The Real Question: Is This Wasteful?

**No. People already do this manually.**

An experienced Claude Code user's actual workflow today:

1. Write a spec or plan
2. Start a session, paste context, do one focused task
3. Session gets polluted → start fresh, re-paste context
4. Verify the output
5. Repeat

GSD automates exactly this loop. The token cost is equivalent — GSD just makes it visible and legible. When someone says "I burned through my $200 plan in a day with GSD," the fair comparison is not GSD vs. a single session — it's GSD vs. the same multi-session workflow done manually, which consumes the same tokens but slower and less systematically.

The "$20 for 500 LOC" HN complaint is not evidence of waste. It may be evidence the task required that much LLM work regardless, and GSD made the cost visible for the first time.

### The Fundamental Constraint: Context Windows, Not GSD

Current LLMs cannot maintain reliable state across 200K+ tokens of accumulated conversation. Past message 40–50, models start forgetting early instructions, hallucinating file contents, and contradicting their own plans. This is well-documented and universally experienced.

Given this constraint, any serious autonomous coding tool must choose:

1. **Long sessions** — accumulate context, accept degradation (Claude Code Plan Mode, Cursor)
2. **Fresh sessions** — clean context per task, pay re-injection cost (GSD's approach)

GSD chose (2). The token burn is the explicit cost. Approach (1) has its own cost — it shows up as degraded output quality, hallucinated file contents, and contradicted plans in late-session work rather than as dollars on an invoice. Both approaches pay; they pay differently.

**If context windows were infinite and reliable, GSD's multi-session architecture would be pointless overhead.** But they're not, and it's not.

### The Deeper Variable: Codebase Modularity

The most important insight the token complaints obscure: **GSD's token cost scales with the coupling of the target codebase, not just its size.**

Consider what `buildExecuteTaskPrompt` inlines for each task. If the project has good modularity and separation of concerns:

- Each task touches 2–3 files with clear interfaces
- Inlined context is small — task plan + module boundary suffices
- Prior task summaries are short (each task had narrow scope)
- Token cost per task: **low**

If the project is a tightly coupled monolith:

- Every task needs awareness of half the codebase
- Inlined context balloons because everything depends on everything
- The executor still can't see all dependencies, so it makes errors → triggers re-planning → burns more tokens
- Token cost per task: **high, with worse results**

This explains every user feedback pattern:

| Pattern | Why |
|---|---|
| **Greenfield succeeds** | You design for modularity from the start. GSD's task decomposition maps cleanly to module boundaries. The planning phase itself *creates* the separation of concerns. |
| **Brownfield fails** | Existing codebases often have tight coupling. No amount of task decomposition makes a tightly coupled change fit in a single focused session. |
| **Small tasks feel "overengineered"** | A well-scoped change in clean code fits in one session with room to spare. The pipeline adds overhead with no benefit. |
| **Large greenfield projects shine** | The roadmap → slices → tasks decomposition naturally produces modules with clear boundaries. This is where GSD's architecture earns its cost. |
| **Hackathon failure** | Few features in an existing codebase — worst case: high coupling + small scope = pipeline overhead exceeds task complexity. |

**GSD isn't burning tokens because it's badly designed. It's paying the cost of separation of concerns.** Same reason a well-organized codebase has more files, more interfaces, and more tests than a monolithic script — the overhead *is* the structure. The structure enables scaling.

This also means **GSD's token efficiency improves with project quality.** A codebase with clear module boundaries, well-defined interfaces, and minimal cross-cutting concerns gives GSD's executors exactly what they need in minimal context. The token tax is proportional to architectural debt — which may be GSD's most underappreciated feature: it makes poor architecture immediately expensive.

---

## Emerging Patterns

### Where GSD works well
1. **Greenfield projects** with clear specs — users who know what they want and can describe it thoroughly
2. **Large, multi-session projects** where context rot is a real problem (the core use case)
3. **Non-engineer builders** (data scientists, designers) doing full-stack development for the first time
4. **Users on $200/mo plans** or API keys with budget — GSD is token-hungry by design
5. **Large brownfield projects with good structure** — explicit interfaces, test coverage, discoverable architecture (see [Scalability analysis](gsd-2-review.md#scalability-can-gsd-2-handle-large-complex-codebases))

### Where GSD fails
1. **Tightly coupled brownfield projects** — not just "existing codebases" but specifically those with deep coupling, implicit contracts, runtime-only dependency resolution, and shared mutable state. GSD's single-session researcher can't map interaction patterns that grep can't find.
2. **Small tasks** — the overhead of research → plan → execute → verify exceeds the task itself
3. **Budget-constrained users** — $20/mo plans hit rate limits during GSD's parallel research phase
4. **Hackathons / time pressure** — GSD trades speed for thoroughness; Plan Mode is faster for MVPs
5. **Users who prefer steering** — experienced devs who want to guide the agent find GSD's autonomy counterproductive

### GSD-2 specific gaps (too early to be patterns)
1. **ToS ambiguity** around OAuth usage — unanswered in every thread where it's raised
2. **v1 → v2 confusion** — users unclear on whether this replaces Claude Code or complements it
3. **Module compatibility** — external Pi packages don't resolve `@gsd/*` imports (GitHub issue #161)
4. **API cost** — at least one user reports $20 in API credits for 500 LOC on v2 specifically

---

## Credibility Assessment

**High-credibility positive signals:**
- The 10-year data scientist who migrated a mid-milestone project successfully — specific, detailed, describes failure-then-fix workflow
- The SaaS launch user (3 months, named product whiteboar.it) — verifiable, long-term
- The FreshBooks replacement (macOS Swift app, considering App Store release) — concrete, non-trivial project
- The engineering demo (100+ engineers) — institutional adoption signal

**Low-credibility signals (both directions):**
- One-line "works like magic" / "this is the most awesome thing ever" comments — no substance
- The creator's own "6h 57m autonomous" tweet — self-promotional, unverifiable
- The $GSD crypto token promotion on X (DegenCapitalLLC) — conflated financial and technical interest
- Grok AI's endorsement tweet — literal AI-generated hype

**High-credibility negative signals:**
- The HN hackathon failure — specific failure mode (transcript complexity), concrete conclusion
- The brownfield project revert — specific scenario, honest about initial impressions being good
- The "$20 for 500 LOC" report — concrete cost data
- The "overengineered" critique from users who tried both GSD and alternatives — comparative, not dismissive

---

## Verdict on Community Reception

**GSD (the methodology) has genuine adoption and genuine critics.** The 32K stars on v1 aren't hollow — real products have been built with it, and experienced developers both praise and criticize it with specificity.

**GSD-2 (the Pi-based CLI) is too new for meaningful assessment.** Eight days of data yields ~5 substantive positive reports and ~2 substantive negative reports. The migration from v1 users is happening but with confusion about what changed. The ToS question is the biggest unresolved blocker for Claude Max users considering adoption.

**The most predictive signal:** GSD works when your project matches its design assumptions (large, greenfield, well-specified, budget-tolerant). It fails when your project doesn't. GSD-2 addresses some of v1's technical limitations (context rot, crash recovery, cost tracking) but doesn't change this fundamental fit question. Whether GSD-2's programmatic context management delivers meaningfully better results than v1's prompt-based approach is **the question that doesn't have enough data to answer yet.**
