# HN Thread Distillation: "How I write software with LLMs"

Source: https://news.ycombinator.com/item?id=47394022
Article: https://www.stavros.io/posts/how-i-write-software-with-llms/
Date: 2026-03-16 | 299 points, 243 comments, 159 unique authors

**Article summary:** Stavros describes a multi-agent workflow for LLM-assisted development: an architect (Opus 4.6) for planning via extended back-and-forth, a developer (Sonnet 4.6) for implementation, and 1-3 reviewers (Codex, Gemini, Opus) for cross-model code review. The key claim is that this produces low-defect code at tens of thousands of SLoC *without the author reading most of the code*, as long as he's architecturally familiar with the domain. Includes a full annotated session adding email support to his personal assistant bot.

### Dominant Sentiment: Impressed but deeply uneasy

The thread splits cleanly into two camps — practitioners sharing refinements on similar workflows, and skeptics who see a profession sleepwalking into deskilling. Neither camp engages seriously with the other's strongest point.

### Key Insights

**1. The multi-model review insight is real, but undertheorized**

The article's most actionable claim — that cross-model review catches bugs that same-model review misses — resonates with practitioners but nobody in the thread offers evidence beyond vibes. Stavros frames it as "a second set of eyes," but the mechanism is more specific: different training data and RLHF produce different failure modes. Codex is "nitpicky and pedantic" (good for review, bad for flow), Gemini Flash "comes up with solutions other models didn't see." This is the thread's most valuable practical pattern, and it's barely interrogated.

**2. The "split on side effects, not task complexity" framework**

felixsells offers the thread's sharpest architectural insight: *"split on domain of side effects, not on task complexity. a 'researcher' agent that only reads and a 'writer' agent that only publishes can share context freely because only one of them has irreversible actions."* This reframes the multi-agent question from "more agents = more quality" to a capabilities-isolation problem. Stavros agrees, noting he separates capabilities (read-only planner vs. write-access developer), but the thread doesn't develop this into a general principle.

**3. The "knowing the system without reading the code" paradox is unresolved**

plastic041 identifies the article's central contradiction: *"I wanted to know how to make softwares with LLM 'without losing the benefit of knowing how the entire system works'... while 'have never even read most of their code'. Because obviously, you can't."* Stavros's implicit answer — that architectural-level understanding suffices because the code is deterministic output of a well-constrained plan — is never stated explicitly. The article's own evidence undermines it: the email session includes multiple bugs (missing owner identity seeding, hardcoded channel list) that only surfaced during manual QA, not from the review agents. The architecture was correct; the implementation had integration gaps that only a human touching the running system caught.

**4. The brownfield blind spot**

rednafi delivers the thread's most cutting critique: *"everyone yapping about how great AI is isn't actually showing the tools' capabilities in building greenfield stuff. In reality, we have to do a lot more brownfield work that's super boring, and AI isn't as effective there."* Every project in the article (Stavrobot, Middle, Pine Town, Sleight of Hand) is greenfield, solo, and hobby-scale. The workflow's reliability claims are untested against the things that make professional software hard: legacy code, multi-team coordination, production incidents, regulatory constraints. Nobody in the thread has a counterexample.

**5. The deskilling anxiety is real but misdirected**

The "then what is our use?" subthread (silisili → borski → mattmanser) generates heat but no light. borski claims *"Most of a great engineer's work isn't writing code, but interrogating what people think their problems are"*, and mattmanser correctly fires back: *"You're claiming a part of the job that was secondary, and not required, is now the whole job."* The actual deskilling risk isn't that engineers stop writing code — it's that they stop *reading* code, which is the mechanism by which they build the architectural judgment that makes the workflow function. Stavros's own experience confirms this: domains where he lacks understanding produce "a mess of bad choices." The workflow works precisely because he has years of accumulated judgment — judgment that was built by reading and writing code.

**6. The plan-file convergence**

Multiple commenters independently arrived at the same practice: writing plans/specs to markdown files rather than relying on conversation context. jumploops: *"it 'anchors' decisions into timestamped files, rather than just loose back-and-forth specs in the context window."* aix1 describes a full hierarchy (requirements → design docs → code+tests), each level ~5x smaller than the one below. This is the thread's strongest emergent consensus — that durable artifacts between sessions matter more than sophisticated agent orchestration within a session.

**7. The hobby-project existential crisis**

gehsty captures something the productivity-focused comments miss entirely: *"When I use Claude code to work on a hobby project it feels like doom scrolling… I can't get my head around if the hobby is the making or the having."* Levitating agrees: *"I code for fun. But I am not sure if I still find it fun if the LLM just makes what I want."* This is a different category of concern from economic displacement — it's about the loss of craft satisfaction even when the tool works perfectly. The thread treats this as a minor aside, but it may be the most important long-term signal about how LLM coding reshapes the profession's culture.

**8. The "1000x shaman" challenge remains unanswered**

codeflo asks the obvious question nobody can answer: *"if the productivity claims were even half true, those '1000x' LLM shamans would have toppled the economy by now. Where are the slop-coded billion dollar IPOs?"* zingar's response — that finding problems worth solving is harder than writing code — is correct but proves too much: if the bottleneck was never code production, then 1000x code production improvements are largely irrelevant to outcomes. The thread can't resolve this because acknowledging it undermines the entire premise.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "You can't know the system without reading the code" | Strong | Article's own QA session demonstrates integration bugs that review agents missed |
| "This only works for greenfield hobby projects" | Strong | No counterexample in thread; every cited project is solo/greenfield |
| "Multi-agent with same model is just wearing different hats" | Medium | Stavros agrees — the value is cross-model, not multi-agent per se |
| "Productivity gains should show up in the economy" | Strong | Thread has no convincing response beyond "give it time" |
| "This is just vibe coding with extra steps" | Weak | The annotated session shows genuine architectural engagement, not prompt-and-pray |
| "LLMs will eventually architect too, then what?" | Misapplied | Extrapolation from code-writing to judgment is a category error the thread doesn't examine |

### What the Thread Misses

- **Testing as the real load-bearing wall.** The article mentions "421 tests passing" repeatedly but never discusses who writes the tests or how test quality is assured. If the LLM writes both the code and the tests, you have a system validating itself — the same problem as same-model review. Nobody asks about this.
- **The economics of the workflow.** Running Opus for planning, Sonnet for implementation, and Codex+Gemini+Opus for review on every feature is expensive. At scale, this is a significant cost center. Nobody does the math on whether this is cheaper than a human developer for anything beyond hobby projects.
- **Context window as architectural constraint.** The plan-file convergence hints at this but nobody says it: the reason plans need to be written to files is that context windows are unreliable memory. The entire multi-agent architecture is partly a workaround for context limitations, not just a quality mechanism.
- **Selection bias in the annotated session.** The email feature session is a good demo, but it's an additive feature to an existing well-understood codebase. The hard case — refactoring coupled components, debugging a production issue across services, or working in an unfamiliar codebase — is never shown.

### Verdict

The article documents a real, functional workflow that produces working software — the annotated session is genuine and the architectural engagement is substantive. But the thread circles without ever stating the core tension: **this workflow works because Stavros is an experienced engineer directing the system, and the workflow itself does not produce experienced engineers.** Every successful pattern described — the extended planning phase, the cross-model review, the domain-knowledge gating — relies on judgment that was built by doing the exact work the LLM now replaces. The thread's practitioners are spending down accumulated human capital; the thread's skeptics sense this but can't articulate it beyond "but what happens next." The plan-file convergence is the most practically useful takeaway: treat LLM sessions as stateless workers and keep truth in version-controlled artifacts, not conversation history.
