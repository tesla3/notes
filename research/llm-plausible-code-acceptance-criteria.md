← [Index](../README.md)

## HN Thread Distillation: "LLMs work best when the user defines their acceptance criteria first"

**Thread:** https://news.ycombinator.com/item?id=47283337 (163 points, 129 comments)
**Article:** https://blog.katanaquant.com/p/your-llm-doesnt-write-correct-code
**Date:** 2026-03-07

**Article summary:** An LLM-generated Rust reimplementation of SQLite is 20,171x slower on primary key lookups because the query planner sends every `WHERE id = N` through a full table scan instead of a B-tree seek — a 4-line function (`is_rowid_ref()`) misses the `INTEGER PRIMARY KEY` case. A second case study: an 82,000-line Rust disk cleanup daemon that replaces a one-line cron job. The author argues LLMs optimize for plausibility over correctness, cites METR (19% slower with AI), GitClear (copy-paste up, refactoring down), and DORA (AI adoption → delivery instability), and concludes LLMs only work when users define measurable acceptance criteria before generation.

### Source Critique

The article bundles two claims that deserve separate evaluation. **Claim 1:** LLMs produce plausible-but-incorrect code. The SQLite case study demonstrates this compellingly — the `is_ipk` bug is a perfect specimen of the failure mode. **Claim 2:** Defining acceptance criteria first solves this. This is the title's promise but the article barely argues it. It just asserts that "an experienced database engineer would have caught the bug" — which is true but tautological. The article also contradicts itself: it says "the failure patterns are produced by the tools, not the author" but concludes by placing responsibility on the user. Both can be partly true, but the article doesn't resolve the tension.

The 82,000-line disk daemon case study is actually more revealing than the SQLite one — it shows LLMs solving the *prompt* ("build a sophisticated disk management system") rather than the *problem* (delete old build artifacts). But the thread barely touches it.

### Dominant Sentiment: Polarized but constructively so

Two camps in genuine tension, neither dismissing the other entirely. The thread is doing real work — the "skill issue" camp is forced to get specific about techniques, and the "fundamental limitation" camp is forced to acknowledge that the SQLite rewrite *did* produce a working database.

### Key Insights

**1. pornel names the compounding failure mode that everyone recognizes**

The top comment describes the dynamic, not just the state: LLMs dig deeper when they should step back. Each workaround generates more code, each fix generates more tests, each unification generates more abstraction. pornel: *"If you ask to unify the duplication, it'll say 'No problem, here's a brand new metamock abstract adapter framework that has a superset of all feature sets.'"* This resonates because it's the exact mechanism by which plausible code becomes unmanageable code — it's not that any individual step is wrong, it's that the direction never reverses. LLMs have no concept of "we should throw this away and start over." The article's SQLite example is a static snapshot of this dynamic after 576,000 lines.

**2. The "skill issue" camp can't produce a guide — and structurally cannot**

mmaunder argues aggressively that AI critics are "lazy people making lazy assumptions" and that the secret is to "approach agentic coding with a sense of love, excitement, optimism." When 2god3 directly challenges: *"why can't you and others put together a proper guide?"*, mmaunder's answer is revealing: *"the folks who are great at agentic coding are coding their asses off 16 to 20 hours a day and don't have a minute they want to spend on writing guides because of the opportunity cost."*

This isn't a time-management problem. Four independent structural mechanisms explain why the guide can't exist:

First, **the "skill" is domain expertise, not prompting technique** ([Steering ∝ Theory](../insights.md#steering-theory)). Every concrete tip in the thread — "use planning mode," "define acceptance criteria," "don't tell it the code is slow, ask it to benchmark" — reduces to: *provide better steering.* But steering quality is proportional to domain theory. mmaunder's "Don't change anything. Just tell me" works for him because he knows what to look for in the plan. A junior following the same ritual sees a plan, lacks the theory to evaluate it, approves it, and gets the 20,171x-slower query planner. A guide to "how to steer an LLM" is isomorphic to a guide to "how to be a good software engineer" — that guide exists; it's called a CS degree plus ten years of production experience.

Second, **the people claiming the highest gains have the largest uncounted investment** ([Hidden Denominator](../insights.md#hidden-denominator)). mmaunder codes 16-20 hours a day. METR's 13x time-savings outlier runs 10+ concurrent terminals with git worktrees, pre-written plans, and autonomous agent loops. Boris Cherny (who *built* Claude Code) runs 10-15 concurrent sessions with custom hooks and updates his CLAUDE.md multiple times per week. These are infrastructure projects, not tool usage. The "guide" would need to include the denominator — decades of domain expertise plus months of personal tooling — and at that point it's not a guide, it's a career.

Third, **the effective workflow is personal, experiential, and ephemeral** ([Workflow as Tribal Knowledge](../insights.md#workflow-as-tribal-knowledge)). The actionable knowledge lives in thousands of micro-corrections — what failed, what the model gets wrong in *your* codebase, which workarounds you discovered — not in transferable principles. That's why the thread's concrete advice is so thin. wmeredith links an "AI-ready software developer" article series from codemanship, but it reduces to: keep scopes small, ship, refactor, optimize, write tests. That's not an AI guide. That's what people have been teaching since Kent Beck.

Fourth, **the Kolmogorov bound makes it mathematically inescapable** ([Context-Task Crossover](../insights.md#context-task-crossover)). For a prompt to fully specify its output, its information content must match the code's. The same bound applies to a guide: for a guide to fully specify effective AI use, its information content must approach the domain knowledge required. Any guide shorter than that is insufficiently specified; any guide that long is just a software engineering textbook.

**3. The thread's two camps are making the same error in opposite directions**

The "skill issue" camp (Implicated, mmaunder, oofbey) treats LLM coding as a skill that just needs practice — but their descriptions all involve an expert human doing the hard design work and using the LLM for execution. They're not describing LLM coding; they're describing *delegation with detailed specifications*. The "fundamental limitation" camp (jqpabc123, D-Machine, tartoran) treats LLMs as pure stochastic parrots that can never produce correct code — but the SQLite rewrite *did* produce a working B-tree, a correct parser, a functional VDBE engine. Both camps share a blind spot: they can't articulate the boundary between what LLMs do well and what they don't, because that boundary shifts with every model release.

**4. cat_plus_plus reframes the 20,000x as a starting point, not a verdict**

The sharpest contrarian point: *"Your LLM actually wrote a correct code for a full relational database on the first try... How many humans can do this without a week of debugging? I would suggest you install some profiling tools and ask it to find and address hotspots."* This inverts the article's framing — the SQLite rewrite isn't evidence that LLMs fail, it's evidence that LLMs produce a first draft that needs profiling and iteration, just like human code. The article's implicit comparison isn't "LLM vs. human writing a database from scratch" but "LLM vs. 26 years of SQLite optimization" — a comparison the article acknowledges but doesn't adjust for.

**5. The review bottleneck is the actual unsolved problem**

Multiple commenters converge here without naming it directly. marginalia_nu: *"the code generation is fast, but then you always need to spend several hours making sure the implementation is appropriate."* LPisGood adds the mechanism: *"it's slower to review because you didn't do the hard part of understanding the code as it was being written."* ehnto: *"when you write it manually you are doing the review and sanity checking in real time. For some tasks... the sanity checking is actually the whole task."* This is the thread's most important emergent insight: LLMs move the bottleneck from *writing* to *reviewing*, but reviewing code you didn't write is harder and slower than reviewing code you did write. The net productivity gain depends entirely on whether the review cost is less than the writing cost — and for complex domains, it may not be.

**6. The training-data distribution boundary explains divergent experiences**

ehnto and ozozozd identify why people have such different experiences: *"Using Claude in industries full of proprietary code is a totally different experience to writing some React components... it's shockingly good at the latter, but as you get into proprietary frameworks or newer problem domains it feels like AI in 2023 again."* D-Machine states it most precisely: LLMs *"write code that is semantically similar to code clusters seen in its training data."* This means the "skill issue" camp and the "fundamental limitation" camp are likely working in different domains — one in well-represented territory (web frameworks, CRUD, standard patterns), the other at the distribution edges.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Skill issue — use planning mode" (Implicated, mmaunder) | Technically correct, structurally misleading | The skill is real — it's software engineering competence. Unfalsifiable as stated because the "skill" is never specified concretely; when pressed, it decomposes into domain expertise + infrastructure investment + tribal workflow knowledge, none of which compresses into a guide |
| "Humans write plausible code too" (lukeify, codethief, riffraff) | Weak | True but irrelevant — humans self-correct through debugging; the article's point is that LLMs don't self-correct without external feedback |
| "The benchmark wasn't in the prompt" (flerchin) | Medium | Fair procedural point, but g947o's rebuttal is stronger: the list of "hidden requirements" that LLMs miss is unbounded |
| "Just ask it to optimize after" (cat_plus_plus, skybrian) | Medium | Works for local perf bugs; doesn't work for architectural choices (full-scan vs. B-tree seek) baked into the design |
| "20,000x slow but it works" (cat_plus_plus, snoob2021) | Strong | Genuinely reframes the result — a working database from scratch is nontrivial regardless of performance |

### What the Thread Misses

- **The 82,000-line daemon is the stronger case study and nobody discusses it.** The SQLite rewrite has performance bugs that could theoretically be fixed. The disk daemon is solving the wrong problem entirely — that's a fundamentally different failure mode (prompt fulfillment vs. problem solving) and it's the one LLMs can't self-correct for, because the specification *is* the problem.

- **The article's research citations don't support its thesis as strongly as presented.** METR tested experienced OSS devs on *existing* codebases (maintenance, not greenfield). GitClear measured code churn metrics without establishing causal direction. DORA's correlation between AI adoption and instability decline could be confounded by teams adopting AI *because* they're already struggling. The article presents these as converging evidence when they're measuring different things.

- **Nobody asks the industrial organization question.** If LLMs require an expert to define acceptance criteria and review output, and the expert could have written the code themselves, what's the actual productivity model? The answer is probably parallelism — one expert directing multiple LLM agents simultaneously — but nobody explores this explicitly.

- **The Apprenticeship Doom Loop is the elephant in the room.** If the "skill" that makes AI coding work is domain expertise accumulated over years of building systems, then AI is consuming the resource it depends on. The seniors who make AI work got their expertise pre-AI. The juniors who would become those seniors are being hired less (LeadDev 2025: 54% of engineering leaders plan fewer junior hires) and learning less (Shen & Tamkin 2026 RCT: 17% lower conceptual understanding with AI). The "skill issue" camp is drawing down a stockpile it can't replenish — and nobody in the thread notices.

- **The Frankensqlite project was apparently already flagged on HN days earlier** (comex links it). The thread doesn't grapple with whether picking an already-controversial project as a case study introduces selection bias.

### Verdict

The article is correct that LLMs produce plausible-over-correct code, and the SQLite case study is a genuine exemplar. But the thread reveals that the article's prescription ("define acceptance criteria first") is just restating "be a competent engineer" — which was always the requirement.

The real dynamic the thread circles without naming: **"skill issue" is true, but it's the wrong frame.** It's like saying car racing is a "driving skill issue" — technically correct, but the "skill" is everything you learned in years of driving, mechanical intuition, track knowledge, and thousands of hours of practice. A guide to "how to drive fast" is either uselessly vague ("brake before turns") or a full racing curriculum. There's no middle ground because the skill IS the domain expertise, not a technique layered on top of it. Four independent mechanisms ([Steering ∝ Theory](../insights.md#steering-theory), [Hidden Denominator](../insights.md#hidden-denominator), [Workflow as Tribal Knowledge](../insights.md#workflow-as-tribal-knowledge), [Context-Task Crossover](../insights.md#context-task-crossover)) structurally guarantee this — it's not a gap that better documentation or more practice closes.

LLMs have inverted the cost structure of software. Writing is now cheap; understanding is still expensive. Every commenter who says "just review it" or "just benchmark it" or "just use planning mode" is describing the same thing: the human's job has shifted from *production* to *verification*. The uncomfortable terminal question is whether verification without production builds the expertise needed to verify ([Apprenticeship Doom Loop](../insights.md#apprenticeship-doom-loop)). AI simultaneously *requires* deep domain expertise to use effectively, *hides* that requirement behind the "skill issue" frame, and *degrades* the pipeline that produces domain expertise. The article's expert database engineer who'd catch the `is_ipk` bug only exists because someone spent years *writing* query planners — not reviewing LLM-generated ones. The system that produces that engineer is what's breaking.
