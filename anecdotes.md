← [Index](README.md)

# AI Coding Agent Anecdotes

First-hand reports from practitioners. Raw quotes, light editing for readability. Updated as new threads are processed.

Each anecdote has a short name and cross-references to [insights](insights.md) it evidences.

---

## Autonomous agent workflows

### Sentry Guess-and-Check

bblcla (article author), [HN #46618042](https://news.ycombinator.com/item?id=46618042), Jan 2026

> I was trying to attach Sentry to our system. Sentry is a wonderful service that creates nice traces of when parts of your code run. This makes it easy to figure out why it's running slower than you expect.
>
> It's usually very easy to set up, but on this day it wasn't working. And there were no good debug logs, so the only way to figure out what was going on was to guess-and-check. I had to send a test message on our frontend, then look into the Sentry logs to see if we successfully set it up, then randomly try another approach based on the docs. It was frustrating and tedious.
>
> So I had Claude write a little testing script with Playwright that logged into our website and sent a chat. Then I had it connect to Sentry by MCP, and look for the exact codepath I was trying to debug. Finally, I gave it the Sentry docs and told it to keep plugging away until it figured it out.
>
> It took about an hour and a half, but Claude finally got it. This was pretty cool! The core loop of performance engineering is straightforward: make a code change, test, check tracing logs, repeat. With this tooling, Claude could do that work for us.
>
> The problem, if you're interested, was that Sentry automatically sets up transactions for FastAPI endpoints *but not for ones that return StreamingResponses*. The solution was to write that in manually.

Stack: Claude Code + Playwright + Sentry MCP. ~90 min autonomous. Estimated savings: ~1.5 days.

↳ [Activation Energy](insights.md#activation-energy) (tedious task below effort threshold), [Fixed-Point Workflow](insights.md#fixed-point-workflow) (guess-check loop = plan→execute→observe→revise)

---

### Datadog Bug Hoover

frde_me, [HN #46618042](https://news.ycombinator.com/item?id=46618042), Jan 2026

> I'm shipping a vast majority of my code nowadays with Opus 4.5 (and this isn't throwaway personal code, it's real products making real money for a real company). It only fails on certain types of tasks (which by now I kind of have a sense of).
>
> I still determine the architecture in a broad manner, and guide it towards how I want to organize the codebase, but it definitely solves most problems faster and better than I would expect for even a good junior.
>
> Something I've started doing is feeding it errors we see in datadog and having it generate PRs. That alone has fixed a bunch of bugs we wouldn't have had time to address / that were low volume. The quality of the product is most probably net better right now than it would have been without AI. And velocity / latency of changes is much better than it was a year ago (working at the same company, with the same people)

↳ [Activation Energy](insights.md#activation-energy) (low-volume bugs below effort threshold)

---

### Cache Discovery

ako, [HN #46618042](https://news.ycombinator.com/item?id=46618042), Jan 2026

> Yesterday I asked it why some functionality was slow, it did some research, and then came back with all the right performance numbers, how often certain code was called, and opportunities to cache results to speed up execution. It refactored the code, ran performance tests, and reported the performance improvements.

↳ [Activation Energy](insights.md#activation-energy) (profiling task that wouldn't have been prioritized)

---

## One-shot infrastructure tasks

### ECS One-Shot

bblcla (article author), [HN #46618042](https://news.ycombinator.com/item?id=46618042), Jan 2026

> I've used Modal happily for a year. It has the *best* UI for spinning up containers in the cloud on-demand. But last week we hit its limits, so I had to migrate us onto AWS.
>
> I wanted to set up an autoscaling, containerized workflow on Amazon's Elastic Container Service, since I knew this was the 'right' thing to do. I've set up plenty of Linux servers by hand, so I knew what to do. But I've never before touched Kubernetes or ECS. The pain of learning AWS's terminology always put me off.
>
> This time, I asked Claude to do it. I gave it Terraform and access to the `aws` command line tool. It one-shotted creating Dockerfiles for our code. Then it pushed them to AWS's container registry, and set up the correct permissions using the cli, and set up the necessary AWS ECS configs in Terraform.
>
> And it all worked on the first try! Amazing!

Stack: Claude Code + Terraform + `aws` CLI. First try, ~3 hours. Author had never used ECS/Kubernetes. Estimated savings: 1-2 days.

↳ [Activation Energy](insights.md#activation-energy) (put off by learning curve), [Steering ∝ Theory](insights.md#steering-theory) (theory-sparse infra work — well-documented APIs, standard patterns)

---

## Specific failure modes

### Lazy Copy

michalsustr (minfx.ai), [HN #46618042](https://news.ycombinator.com/item?id=46618042), Jan 2026

> At minfx.ai (a Neptune/wandb alternative), we cache time series that can contain millions of floats for fast access. Any engineer worth their title would never make a copy of these and would pass around pointers for access. Opus, when stuck in a place where passing the pointer was a bit more difficult (due to async and Rust lifetimes), would just make the copy, rather than rearchitect or at least stop and notify user. Many such examples of 'lazy' and thus bad design.

↳ [Naur's Nightmare](insights.md#naurs-nightmare) (no theory → path of least resistance), [Diagnostic Pain](insights.md#diagnostic-pain) (Rust lifetime difficulty was signaling a design issue the agent ignored)

---

### Stubborn Anti-Patterns

bblcla, [HN #46618042](https://news.ycombinator.com/item?id=46618042), Jan 2026

> Some other footguns I keep seeing in Python and constantly have to fix despite CLAUDE.md instructions are:
>
> - writing lots of nested if clauses instead of writing simple functions by returning early
> - putting imports in functions instead of at the top-level
> - swallowing exceptions instead of raising (constantly a huge problem)
>
> These are small, but I think it's informative of what the models can do that even Opus 4.5 still fails at these simple tasks.

chapel corroborates across model generations:

> Those Python issues are things I had to deal with earlier last year with Claude Sonnet 3.7, 4.0, and to a lesser extent Opus 4.0 when it was available in Claude Code.
>
> In the Python projects I've been using Opus 4.5 with, it hasn't been showing those issues as often, but then again the projects are throwaway and I cared more about the output than the code itself.

↳ [Broken Abstraction Contract](insights.md#broken-abstraction-contract) (CLAUDE.md instructions are not a contract the LLM reliably honors)

---

### Version Drift

0x457, [HN #46618042](https://news.ycombinator.com/item?id=46618042), Jan 2026

> My experience with Claude (and other agents, but mostly Claude) is such a mixed bag. Sometimes it takes a minimal prompt and 20 minutes later produce a neat PR and all is good, sometimes it doesn't.
>
> For me, most of the failure cases are where Claude couldn't figure something out due to conflicting information in context and instead of just stopping and telling me that it tries to solve in entirely wrong way. Doesn't help that it often makes the same assumptions as I would, so when I read the plan it looks fine.
>
> Level of effort also hard to gauge because it can finish things that would take me a week in an hour or take an hour to do something I can in 20 minutes.
>
> It's almost like you have to enforce two level of compliance: does the code do what business demands and is the code align with codebase. First one is relatively easy, but just doing that will produce odd results where claude generated +1KLOC because it didn't look at some_file.{your favorite language extension} during exploration.
>
> Or it creates 5 versions of legacy code on the same feature branch. My brother in Christ, what are you trying to stay compatible with? A commit that about to be squashed and forgotten? Then it's going to do a compaction, forget which one of these 5 versions is "live" and update the wrong one.
>
> It might do a good junior dev work, but it must be reviewed as if it's from junior dev that got hired today and this is his first PR.

↳ [Naur's Nightmare](insights.md#naurs-nightmare) (no coherent model of branch state or codebase intent)

---

### Domain Knowledge Gate

bblcla, [HN #46618042](https://news.ycombinator.com/item?id=46618042), Jan 2026

> When I started having it write React, Claude produced incredibly buggy spaghetti code. I had to spend 3 weeks learning the fundamentals of React (how to use hooks, providers, stores, etc.) before I knew how to prompt it to write better code. Now that I've done that, it's great. But it's meaningful that someone who doesn't know how to write well-abstracted React code can't get Claude to produce it on their own.

michalsustr adds:

> I also believe that overall repository code quality is important for AI agents — the more "beautiful" it is, the more the agent can mimic the "beauty".

↳ [Steering ∝ Theory](insights.md#steering-theory) (you need theory to steer effectively)

---

### Hand-Holding Tax

joduplessis, [HN #46618042](https://news.ycombinator.com/item?id=46618042), Jan 2026

> Recently I've put Claude/others to use in some agentic workflows with easy menial/repetitive tasks. I just don't understand how people are using these agents in production. The automation is absolutely great, but it requires an insane amount of hand-holding and cleanup.

↳ [Hidden Denominator](insights.md#hidden-denominator) (hand-holding cost not counted against productivity claims)

---

### Plough-Ahead Problem

Scrapemist, [HN #46618042](https://news.ycombinator.com/item?id=46618042), Jan 2026

> Eventually you can show Claude how you solve problems, and explain the thought process behind it. It can apply these learnings but it will encounter new challenges in doing so. It would be nice if Claude could instigate a conversation to go over the issues in depth. Now it wants quick confirmation to plough ahead.

↳ [Inverted Principal-Agent](insights.md#inverted-principal-agent) (aligned but incompetent — wants to help, doesn't know when to stop and ask)

---

## Practitioner techniques

### Context Hygiene

chapel, [HN #46618042](https://news.ycombinator.com/item?id=46618042), Jan 2026

> The biggest unlock for me with these tools is not letting the context get bloated, not using compaction, and focusing on small chunks of work and clearing the context before working on something else.

↳ [Fixed-Point Workflow](insights.md#fixed-point-workflow) (the plan→scope→review cycle requires fresh context)

---

### Linting as Guardrail

bblcla + chapel, [HN #46618042](https://news.ycombinator.com/item?id=46618042), Jan 2026

chapel:
> The nice thing about these agentic tools is that if you setup feedback loops for them, they tend to fix issues that are brought up. So much of what you bring up can be caught by linting.

bblcla:
> Arguably linting is a kind of abstraction block!

↳ [Verification Gate](insights.md#verification-gate) (linting is cheap verification that gates output quality)

---

### Sub-Agent Review

ekidd, [HN #46618042](https://news.ycombinator.com/item?id=46618042), Jan 2026

> If you want code review, start by writing a code review "skill". Have that skill ask Opus to fork off several subagents to review different aspects, and then synthesize the reports, with issues broken down by Critical, Major and Minor. Have the skill describe all the things *you* want from a review.

↳ [Verification Gate](insights.md#verification-gate) (structured verification as part of the agent loop)

---

### Minimal-Edit Default

simonw, [HN #46618042](https://news.ycombinator.com/item?id=46618042), Jan 2026

> My guess is that Claude is trained to bias towards making minimal edits to solve problems. This is a desirable property, because six months ago a common complaint about LLMs is that you'd ask for a small change and they would rewrite dozens of additional lines of code.
>
> I expect that adding a CLAUDE.md rule saying "always look for more efficient implementations that might involve larger changes and propose those to the user for their confirmation if appropriate" might solve the author's complaint here.

iamleppert:

> It's very good at doing the least amount of work to just make something work by default, but that's not always what you want. Sometimes it is. I'd much rather prefer that as the default mode of operation than something that makes a project out of every little change.

↳ [Diagnostic Pain](insights.md#diagnostic-pain) (minimal edit preserves the status quo, which may be the wrong abstraction)

---

## Process bottleneck evidence

### The 4.9-Day S3

dent9, [HN #46933223](https://news.ycombinator.com/item?id=46933223), Feb 2026

> I wanted to make a tiny update to our CI/CD to upload copies of some artifacts to S3. It took 1min for the LLM to remind me of the correct syntax in aws cli to do the upload and the syntax to plug it into our GitHub Actions. It then took me the next 3 hours to figure out which IAMs needed to be updated in order to allow the upload before it was revealed that Actually uploading to the S3 requires the company IT to adjust bucket policies and this requires filing a ticket with IT and waiting 1-5 business days for a response then potentially having a call with them to discuss the change and justify why we need it. So now it's four days later and I still can't push to S3.
>
> AI reduced this from a 5-day process to a 4.9-day process

↳ [Brooks-Naur Vindication](insights.md#brooks-naur-vindication) (Amdahl's Law — coding speed was never the bottleneck)

---

### PR Queue Wall

gbuk2013, [HN #46933223](https://news.ycombinator.com/item?id=46933223), Feb 2026

> My last several tickets were HITL coding with AI for several hours and then waiting 1-2 days while the code worked its way through PR and CI/CD process.
>
> Coding speed was never really a bottleneck anywhere I have worked - it's all the processes around it that take the most time and AI doesn't help that much there.

↳ [Brooks-Naur Vindication](insights.md#brooks-naur-vindication) (same Amdahl dynamic as The 4.9-Day S3, stated as recurring pattern)

---

## Autonomous agent limits

### The $170 Clone

amarble, [HN #46933223](https://news.ycombinator.com/item?id=46933223) + [full write-up](https://www.marble.onl/posts/this_cost_170.html), Feb 2026

> The result is OK. It has all the features I asked for, and includes document sharing, collaborative editing in real time, support for fonts and line spacing, etc. I could not have paid a developer $170 and got this. The problem, of course, is that, while abstractly impressive, this is completely useless, and I see no pathway for it to become useful with more effort.
>
> There are lots of bugs or poor choices depending on how you want to frame them. The whole web page scrolls instead of just the writing area. The table and image functionality are poor. Bullet points don't really work. I wanted document editor style margin control and got bulk indent. It added collaboration but no account management or authorization.
>
> Browsers and compilers have a lot in common from a vibe coding perspective in that both have detailed existing behavioral specifications. This makes thorough testing comparatively easy because someone has told us exactly how the software should behave. [...] With a UX-driven tool like a document editor, there's no hiding in spec compliance, it's easy to see if the product is crap or not.

Setup: Claude Code / Opus 4.6, autonomous loop for 8 hours with minimal intervention, 233M input tokens. [Repo public](https://github.com/rbitr/altdocs).

Why this matters: it's the control experiment the AI companies don't run. Anthropic demos a C compiler ($20K). Cursor demos a browser (1M+ LOC). Both are spec-tractable — detailed behavioral specs make verification easy and taste irrelevant. amarble tried a taste-requiring product (document editor) and got spec-compliance without usability. The "no pathway" claim is the strongest part — not "it didn't work this time" but "more money, better prompts, and specialized agents wouldn't fix this." The only public, cost-accounted experiment of autonomous agentic coding on a real product.

↳ [Steering ∝ Theory](insights.md#steering-theory) (unsteered agent on medium-theory work → average/obvious output), [Naur's Nightmare](insights.md#naurs-nightmare) (no taste/theory in the artifact)

---

### The $20K Semantic Transpiler

Nicholas Carlini (Anthropic), [blog post](https://www.anthropic.com/engineering/building-c-compiler) + [repo](https://github.com/anthropics/claudes-c-compiler), Feb 2026. Lattner analysis: [review](../research/lattner-ccc-review.md). Rastogi analysis: [agent scaling laws](https://vizops.ai/blog/agent-scaling-laws/).

16 parallel Claude Opus 4.6 agents, ~2,000 sessions over 14 days, $20K in API costs. Produced a 100K-line Rust C compiler that can build Linux 6.9 on x86, ARM, and RISC-V, passes 99% of GCC torture tests, compiles Doom, SQLite, Redis, FFmpeg, postgres.

The limitations reveal more than the achievements:

> The compiler successfully builds many projects, but not all. It's not yet a drop-in replacement for a real compiler. The generated code is not very efficient. Even with all optimizations enabled, it outputs less efficient code than GCC with all optimizations *disabled*. — Carlini

The code generator reparses assembly text instead of using an IR. The parser hard-codes system header information rather than actually parsing headers — it can't handle real-world system headers, so it fakes what it needs for its test suite. Error recovery is poor. The architecture is LLVM-derived down to specific constructs (`getelementptr`, block terminators, `Mem2Reg`) that appear in no other compiler IR. As Lattner (creator of LLVM) observes: CCC "optimizes toward passing tests rather than building general abstractions."

Rastogi's independent analysis concludes CCC is best understood as a "semantic transpiler" — given a 205-line prompt and a test suite, it converts existing compiler knowledge from training data into Rust. The test suite is what turned a weekend hack into a Linux-compiling compiler: "building that test infrastructure required deep domain expertise that the agents themselves do not have — at least not yet."

Why this matters alongside The $170 Clone: CCC is the *success case* that proves the same point. Compilers are a maximally spec-tractable domain — deterministic feedback, layered abstractions, decades of well-documented consensus. The LLM output looks competent precisely because the training distribution mean IS the established best practice (Lattner's "distribution follower" insight). Switch to a domain without that consensus (The $170 Clone's document editor) and the same architecture produces mediocrity. **The quality ceiling isn't model capability — it's the consensus quality of the training domain.**

↳ [Verification Gate](insights.md#verification-gate) (test suites gated quality; GCC oracle created verifiable sub-tasks), [Verification Scales Parallelism](insights.md#verification-scales-parallelism) (16 agents stuck on same kernel bug until tasks were decomposed), [Naur's Nightmare](insights.md#naurs-nightmare) (hard-coded headers = code faking understanding it doesn't have), [Steering ∝ Theory](insights.md#steering-theory) (compiler = consensus-rich domain; mean of training data ≈ correct)

---

## Capability counter-examples

### Just Say Review

IanCal, [HN #46936920](https://news.ycombinator.com/item?id=46936920), Feb 2026

In response to a Latent Space article arguing LLMs lack world models and can't reason about adversarial social dynamics. The article's centerpiece: ChatGPT drafts a Slack message ("no rush, whenever works") that an expert coworker would reject because Priya's triage heuristics will bury it. IanCal fed the same message back to ChatGPT with one word added: "review."

> This is a very polite and respectful start, which is great since you are new. However, from a professional standpoint, it is a little too passive and vague. In a busy work environment, saying "no rush at all" or "whenever" often leads to your request being buried at the bottom of a to-do list. Additionally, you haven't told Priya exactly what she is looking at or where to find it.

The model identified every failure the article attributed to expert-only reasoning, produced three alternative drafts graded by scenario, and added a practical checklist the article's expert *didn't* think of (file permissions, scratchpad cleanup). Without being told Priya was overloaded.

Devastating to the article's ontological claim ("LLMs have word models, not world models") — the world model is present but dormant, activated by a one-word mode switch from generation to evaluation. Less devastating to the structural argument: "review" requires a human who already knows the situation is strategic, and doesn't help autonomous agents with no one to say it.

[Full breakdown](research/hn-iancal-just-say-review.md)

↳ [Steering ∝ Theory](insights.md#steering-theory) (the steering word is trivial but required — the model won't apply its own knowledge unprompted)

---

## Skill atrophy / dependency

### LLM-Dependent Mid

fastasucan, [HN #46618042](https://news.ycombinator.com/item?id=46618042), Jan 2026

> One guy I work with has little formal training (and mid level experience), but do a lot with LLM's. But in every situation he has to do anything without an LLM he heavily struggles/are not able to anything (say a basic sql query). There is no way someone with his experience and position would still be at that level.
>
> I guess people differ in thinking that is a good or a bad thing. I think it makes up for a huge risk, as he cant really judge good from bad code (or architecture), but his supervisors have put him in a position where he should.

↳ [Apprenticeship Doom Loop](insights.md#apprenticeship-doom-loop) (AI impairs conceptual understanding — Shen & Tamkin confirmed this experimentally)

---

## Quality / reliability evidence

### Cloudflare Post-AI Outage Cluster

TacticalCoder, [HN #47125374](https://news.ycombinator.com/item?id=47125374), Feb 2026

> If we look at a company like Cloudflare who basically didn't have any serious outage for five years then had five serious outages in six months since they drank the AI kool-aid, we kinda have a first data point on how amazing AI is from a maintenance point of view.
>
> We all *know* we're generating more lines of underperforming, insecure, probably buggy, code than ever before. We're in for a wild ride.

**Caveat:** Unverified claim — correlation/causation not established. But specific, named, and falsifiable. Nobody in the thread challenged or confirmed it.

↳ [Volume-Value Divergence](insights.md#volume-value-divergence) (more AI code ≠ more value), [Culture Amplifier](insights.md#culture-amplifier) (if true, evidence of AI degrading a previously strong-practice org)

---

### Claude Cowork "Feels Like Two Weeks"

sjaiisba, [HN #47125374](https://news.ycombinator.com/item?id=47125374), Feb 2026

Context: Simon Willison cited Claude Cowork as evidence of AI velocity — *"apparently built in less than two weeks using Claude Code, and appears to be getting significant usage already."*

> Only a personal anecdote, but the humans I know that have used it are all aware of how buggy it is. It feels like it was made in 2 weeks.
>
> Which gets back to the outsourcing argument: it's always been cheap to make buggy code. If we were able to solve this, outsourcing would have been ubiquitous. Maybe LLMs change the calculus here too?

Parallels [The $170 Clone](#the-170-clone) — but for a first-party Anthropic product presented as a success story. The speed IS the quality signal, just not in the direction intended.

↳ [Volume-Value Divergence](insights.md#volume-value-divergence) (fast production ≠ good production), [Broken Abstraction Contract](insights.md#broken-abstraction-contract) (quality can't be contracted away by speed)

---

## Review burden

### Zero-Sum Review Transfer

sjaiisba, [HN #47125374](https://news.ycombinator.com/item?id=47125374), Feb 2026

> AI has been a lifesaver for my low performing coworkers. They're still heavily reliant on reviews, but their output is up. One of the lowest output guys I ever worked with is a massive LinkedIn LLM promoter.
>
> Not sure how long it'll last though. With the time I spend on reviews I could have done it myself, so if they don't start learning…

Individual output up, team output flat — the productivity gain is an accounting illusion that moves work from generation to review. The senior engineer absorbs the cost the LLM supposedly eliminated.

↳ [Hidden Denominator](insights.md#hidden-denominator) (review time not counted against productivity claims), [Apprenticeship Doom Loop](insights.md#apprenticeship-doom-loop) (reliance without learning → no skill development)
