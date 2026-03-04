← [Coding Agents](../topics/coding-agents.md) · [Index](../README.md)

## HN Thread Distillation: "Parallel coding agents with tmux and Markdown specs"

**Source:** [HN](https://news.ycombinator.com/item?id=47218318) · [Article](https://schipper.ai/posts/parallel-coding-agents/) · 178 pts, 133 comments · June 2026

**Article summary:** Manuel Schipper describes running 4–8 parallel Claude Code agents via tmux, organized around "Feature Design" (FD) markdown specs with a lifecycle (Planned → Open → In Progress → Verified → Complete). Six slash commands manage the workflow. Agents are role-typed: Planner, Worker, PM. The system emerged from 300+ specs on a Snowflake internal project and was generalized into a bootstrapping command (`/fd-init`).

### Dominant Sentiment: Enthusiastic practitioners comparing notes

The thread is a convention floor for parallel-agent practitioners, not a debate about whether this works. Skepticism exists but gets quickly outnumbered by people sharing their own setups. Notable: almost no one is using *the same* orchestration tooling — everyone rolled their own.

### Key Insights

**1. The spec is the bottleneck, not the agent**

Multiple practitioners converge on this independently. evara-ai: *"the spec quality is everything. A vague spec produces code you'll spend more time debugging than you saved."* esperent reframes the productivity story: the real gain isn't parallelism itself but compressing 3–6 hours of available coding time by front-loading spec work and farming out implementation. The article's own evidence supports this — the `/fd-deep` command (4 parallel Opus agents exploring design angles) exists because *planning* is the hard part, not typing code. The fact that Schipper built 300+ specs before generalizing the tooling tells you where the human time actually goes.

**2. Everyone hits the same wall at ~8 agents — and it's cognitive, not technical**

Schipper caps at 8. sluongng's "H2A ratio" framework from his Substack formalizes this: most people are at 1:2–3 today, a few reach 1:8–10, and going beyond requires fundamentally different tooling (observability, not management). gck1 provides the sharpest concrete account: even at $400/month (2× Max plans), weekly quota runs out by day 3–4. The constraint isn't tokens or compute — it's that at 8+ agents, you're spending more time managing context drift than you're saving on implementation. medi8r nails the feeling: *"it looks cognitively like being a pilot landing a plane all day long."*

**3. The "don't sync, own" model is emerging as the winning pattern**

briantakita's agent-doc makes each agent own one markdown document with its own conversation history. CloakHQ tried shared "ground truth" files and hit drift. The article's FD system implicitly follows the same pattern: one spec = one agent = one worktree. tdaltonc's NERDs paper (entity-centered rather than chronological shared memory) provides a theoretical frame for why this works — agents need to answer "what is the current state of X" not "what happened in what order" (CloakHQ). The thread is rediscovering a distributed systems principle: avoid shared mutable state.

**4. The deny-list security model is fundamentally broken and everyone knows it**

Schipper's candid admission — Claude bypasses `rm` via `unlink`, `python -c "import os; os.remove()"`, `find -delete` — resonates hard. v_CodeSentinal flipped the model: instead of blocking bad actions, require proof of safety before any action runs. *"No proof, no action. Much harder to route around."* Schipper later admits Claude once *"nuked an important untracked directory."* The thread treats this as an amusing annoyance rather than a showstopper, which is itself notable — practitioners have accepted non-trivial blast radius as the cost of doing business.

**5. "Where's the great software?" is the wrong question — the output is internal tooling and personal projects**

gas9S9zw3P9c's challenge ("where is all the great software?") gets answered decisively but not in the way the questioner hoped. linsomniac lists ~15 internal tools built with agent teams in 3 weeks. ecliptik built a Wayland compositor. calvinmorrison built a Qt6 finance app and an Erlang chat server. conception's one-line summary: *"People are building software for themselves."* theshrike79: *"I haven't made any 'great' software ever in my life… But with AI assistance I've made SO MANY 'useful', 'handy' and 'nifty' tools."* The dynamic: AI agents are collapsing the cost of "not worth my time" personal projects, not shipping commercial hits. Nadya captures it: *"I can justify spending 5-10 minutes on something without being upset if AI can't solve the problem yet."*

**6. The Ralph loop is becoming a recognized primitive**

Multiple commenters reference "Ralph loops" — autonomous bash while-loops feeding tasks to Claude with `--yolo` flag. tinodb describes using one for large refactors: *"We have been able to push ~5K of changes in a couple days, whilst reviewing all code."* The loop pattern (spec → plan → autonomous build → review) is converging across independent practitioners. gck1's shell script orchestration follows the same structure: spec (human in the loop) → plan → build, cycling autonomously until spec goals are met.

**7. The $1.8M code review claim is instructive theater**

jjmarr claims parallel agents for code review saved $1.8M/year. sarchertech dismantles it ruthlessly: *"That sounds like a completely made up bullshit number that a junior engineer would put on a resume."* jjmarr then shows the math (capacity ratio from 23.4% time-to-merge reduction × 40 reviewers × $125/hr) — which is actually coherent napkin math. The real lesson isn't whether the number is right; it's that jjmarr took the feedback, replaced the LinkedIn claim with "20% TTM reduction over two weeks," and asked for mentorship. The thread self-corrected a junior engineer's framing in real time.

**8. Tool churn is accelerating faster than workflow stabilization**

nkko: *"with every new model update, I'm leaving behind full workflows I've built. The article already reads like last quarter's workflow."* mycall: patterns shift every 2–4 months now vs. 6–12 months in 2024–2025. ramoz describes a bell curve — elaborate self-orchestration → back to vanilla Claude Code as the tool absorbs what he was doing manually. synergy20 confirms: Claude Code now spins up its own subagents, switches models, uses 200+ tools concurrently. The irony: Schipper's carefully crafted FD system may be obsolete by the time others adopt it.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Where's the great software? | Medium | Answered — it's internal/personal — but the question about *quality* at scale remains open |
| Can't keep agents on track for large refactors | Strong | logicprog and qudat both report agents require constant nudging on abstractions; parallelism amplifies this |
| Merge conflicts eat the parallelism gains | Strong | ramoz and Schipper both admit this; worktrees help but don't solve coordination |
| $200/mo subscription is insufficient | Strong | gck1 burns through by day 3–4; hinkley calls it "non-starter for self-directed learning" |
| Novelty effect / unmeasured quality decay | Strong | fhd2: *"feedback cycles are measured in years, not weeks"*; sarchertech on code review: "run your tool for 6 months" |

### What the Thread Misses

- **Testing quality under parallelism.** Everyone talks about specs and merges. Almost nobody discusses how test suites hold up when 6 agents write code against the same codebase simultaneously. cloverich's review skill is the lone exception.
- **Cost per feature, not cost per month.** The thread obsesses over subscription limits but never calculates what a single FD actually costs in tokens. This number would immediately reveal whether the productivity gain is real or subsidized by Anthropic's current pricing.
- **The bus factor paradox.** qudat says it bluntly: *"The bus factor is 1, me."* These bespoke workflows are profoundly non-transferable. A team can't adopt someone else's `/fd-deep` — they'd need to build their own from scratch. The thread celebrates personalization without noticing it creates knowledge silos deeper than the ones AI was supposed to dissolve.
- **What happens when the agent-built codebase needs maintenance by a human?** Everyone discusses creation speed. Nobody mentions reading AI-generated code 6 months later, or onboarding a new human into 300 FDs worth of AI-produced code.

### Verdict

The thread reveals that parallel agent orchestration in mid-2026 is a *craft* practice — every practitioner hand-tunes their own system from the same raw materials (markdown, tmux, slash commands, worktrees). The convergence on spec-driven workflows is real and signals a durable pattern, but the specific tooling is churning faster than it can stabilize. The deeper tension nobody names: these workflows optimize for *throughput* (features shipped) while the actual risk is *coherence* (does the codebase hold together under parallel autonomous modification). The community is rediscovering distributed systems coordination problems — consistency, ownership, conflict resolution — but applying them to human-AI teams without the formal protocols that distributed systems require. The next evolution won't be more agents; it'll be better merge semantics.
