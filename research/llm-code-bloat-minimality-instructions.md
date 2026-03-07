← [Index](../README.md)

## Why "Write Minimal Code" Instructions Don't Fix LLM Code Bloat

**Question:** Why don't people just instruct coding agents to write minimal code? Have they tried? Does it work?

**Short answer:** People do try. It partially works. But it can't solve the root problem because verbosity is baked into the model weights via RLHF training, not just a behavioral choice the model makes per-prompt.

---

### 1. People absolutely try this

A Reddit thread titled **"Stop claude code from writing too much code"** (r/ClaudeAI, Jan 2026, 33 upvotes, 59 comments) shows this is a well-recognized problem. Common approaches people report:

- Adding `KISS`, `YAGNI`, `SOLID`, `DRY` principles to CLAUDE.md / .cursorrules
- Explicit instructions like "do not overengineer", "keep it simple", "implement only what is asked"
- Setting line limits: "Keep functions under 30 lines", "Keep the solution under 50 lines of code"
- Asking for refactoring passes after initial generation

The most upvoted reply (26 points, u/werewolf100): *"i have noticed CC is writing 'less' code when telling him to follow KISS and SOLID principles."* Another user (u/MassiveBuilding3630): *"I have a huge set of instructions about KISS and SOLID principles, and I explicitly tell Claude not to overthink and not overengineer the solution."*

**Verdict: it helps at the margin.** But every thread discussing this also contains people saying the instructions get ignored, especially on longer sessions or complex tasks.

### 2. Why instructions alone can't fix it: five structural reasons

#### 2a. RLHF length bias is in the weights, not the prompt

This is the most important finding. Multiple 2025-2026 papers establish that **reward models systematically favor longer outputs**, and this bias is trained into the model weights during RLHF:

- **"Mitigating Length Bias in RLHF through a Causal Lens"** (Kim et al., 2026): *"Human raters tend to disproportionately favor longer outputs — a tendency that reward models can exploit, thereby causing length bias."* They show the bias is **non-linear** — strongly linear for short responses, sublinear for medium, stochastic for long.

- **"Bias Fitting to Mitigate Length Bias of Reward Model in RLHF"** (2025, NeurIPS-adjacent): *"Length bias... where reward models favor longer outputs over shorter ones. This bias not only distorts the reward model's preference modeling but also leads to excessively verbose generations."*

- **Emergent Mind survey on "Verbosity Compensation Behavior"** (2026) identifies four mechanisms driving verbosity:
  1. **Uncertainty-induced elaboration** — high perplexity → more content
  2. **Reward/model bias** — RLHF preference labels skew toward longer completions
  3. **Algorithmic exploitation** — DPO's sequence-level KL scales with output length, giving longer generations excessive gradient updates
  4. **Trace construction from SFT** — models SFT-ed on long traces overgenerate when they lack signal to stop

A prompt saying "keep it concise" is fighting against gradient-level optimization that says "longer = higher reward." The prompt can nudge behavior, but it's a surface-level instruction competing with deep weight-level priors.

#### 2b. Token prediction has no "stop and think about whether you should write this" mechanism

Autoregressive models generate token by token. Each token makes the *next* token more likely to continue the pattern. There's no architectural mechanism for the model to pause mid-generation and ask "should I delete what I just wrote?" or "does a utility function for this already exist in the codebase?"

As u/krackers noted in the HN thread on the plausible-code article: *"There's a very strong prior to 'just keep generating more tokens' as opposed to deleting code that needs to be overcome."*

#### 2c. The "curse of instructions" — more rules = less compliance per rule

Research cited by Addy Osmani (Jan 2026, "How to write a good spec for AI agents") confirms: *"As you pile on more instructions or data into the prompt, the model's performance in adhering to each one drops significantly. One study dubbed this the 'curse of instructions', showing that even GPT-4 and Claude struggle when asked to satisfy many requirements simultaneously."*

A best-practices blog on CLAUDE.md files (Mar 2026) quantifies: *"Research on LLM instruction following shows diminishing returns after roughly 150-200 discrete instructions. Claude Code's system prompt uses about 50 of those slots, leaving you around 150 effective instructions."*

"Write minimal code" competes with every other instruction. In a complex CLAUDE.md with 100+ rules, it becomes noise.

#### 2d. Statelessness — models don't know what already exists

u/Funny-Anything-791 (r/ClaudeAI): *"The problem is that the LLM is stateless and unaware of the existing solutions in the code."*

u/mysportsact: *"It's almost impossible to let CC fully loose and think it will consider the suite of utility functions already implemented."*

The model can't write minimal code if it doesn't know what code already exists. It reinvents rather than reuses — not because it ignores your "KISS" instruction, but because it literally hasn't read the relevant files. This is a context window problem, not an instruction-following problem.

#### 2e. "Minimal" requires domain judgment the model doesn't have

The original article's 82K-line disk cleanup daemon illustrates this perfectly. The "minimal" solution was a one-line cron job — but knowing that requires understanding that the problem doesn't need a sophisticated solution at all. "Write minimal code" is itself a judgment call that presupposes the expertise to know what minimal looks like.

As u/marginalia_nu wrote: *"A decent programmer would and should push back on that."* The model doesn't push back because it's optimizing for agreement, not for questioning premises (sycophancy).

### 3. What actually works better

Evidence from practitioners who've moved past the "add KISS to CLAUDE.md" phase:

**Plan-then-execute separation.** Boris Tane's workflow (Feb 2026, "How I Use Claude Code"): *"Never let Claude write code until you've reviewed and approved a written plan."* He does 1-6 annotation cycles on a plan.md before any implementation. Key: he actively cuts scope — *"remove the download feature from the plan, I don't want to implement this now."*

**Post-hoc cleanup passes.** u/mysportsact: *"My best experience has let it bloat then do follow up passes with cleaning test function runs, finding duplicate function runs, and finding orphaned code runs."* Accept the bloat, then use the LLM's strength (refactoring existing code) rather than fighting its weakness (generating minimal code from scratch).

**Code-simplifier sub-agent.** A documented pattern from the Claude Code community: a dedicated sub-agent that refactors code after each feature implementation, applying DRY, extracting common patterns, removing dead code. This works because simplification is a *constrained* task (the code exists, the tests pass, now make it smaller) — much easier for LLMs than open-ended minimalist generation.

**TDD loops.** Write tests first, let the agent iterate until they pass. Tests naturally constrain scope — you can't bloat a solution that's bounded by "make these 3 tests pass and nothing else." Matt Pocock's PRD approach: a JSON task list where Claude picks ONE task, completes it, marks done, moves on.

**Active interruption.** u/JMpickles (12 upvotes): *"Pay attention to the code it writes and the second it starts doing too much you spank it."* u/Input-X: *"Watch every move. Stop if u see it writing something u didn't ask for."* This is the most labor-intensive but most reliable approach — it works because you're providing the judgment the model lacks.

**Fresh context per task.** Addy Osmani: *"Start fresh: begin new sessions to clear context when switching between major features."* Bloat compounds across long sessions as the model loses track of its own output.

**Reference implementations.** Boris Tane: *"I'll share that code as a reference alongside the plan request... Claude works dramatically better when it has a concrete reference implementation to work from rather than designing from scratch."*

### 4. The meta-insight

The Marmelab "Agent Experience" guide (Jan 2026) frames this from the architecture side: *"LLMs have limited context, and the contributions of coding agents decrease in quality as the context fills up. To maximize useful context, reduce verbosity in the codebase."* Their recommendation: split large files, refactor large functions, remove dead code, avoid obvious comments.

This inverts the problem. Instead of asking the LLM to write minimal code, you **structure the codebase so the LLM has no choice but to work minimally** — small files, focused modules, clear patterns to follow. The constraint is architectural, not instructional.

Addy Osmani's "80% Problem" piece (Jan 2026) captures the dynamic precisely: *"Given free rein, agents can overcomplicate relentlessly. They'll scaffold 1,000 lines where 100 would suffice, creating elaborate class hierarchies where a function would do. You have to actively push back: 'Couldn't you just...?' The response is always 'Of course!' followed by immediate simplification."*

The model *can* write minimal code. It just won't *default* to it, because its training optimized for a different objective (comprehensive-looking output that earns human preference). You have to provide the constraint externally — through plans, tests, architecture, active review, or cleanup passes. The instruction alone is necessary but far from sufficient.

### 5. Bottom line

| Approach | Effectiveness | Why |
|----------|--------------|-----|
| "Write minimal code" in system prompt | Low-moderate | Fights weight-level length bias; degrades with context length |
| KISS/YAGNI/SOLID in CLAUDE.md | Moderate | Helps at margin; diminishing returns with instruction count |
| Plan-then-execute with human review | High | Human provides the judgment; model provides the typing |
| TDD (tests-first) | High | Tests naturally bound scope; no open-ended generation |
| Post-hoc cleanup passes | Moderate-high | Leverages LLM strength (refactoring) not weakness (restraint) |
| Code-simplifier sub-agent | Moderate-high | Constrained task; easier than open-ended minimalism |
| Architectural constraints (small files, focused modules) | High | Removes the opportunity for bloat; structural, not instructional |
| Active interruption during generation | Highest | Real-time human judgment; most labor-intensive |

The pattern: **every effective approach either constrains the output space externally or injects human judgment at the point where minimality decisions are made.** No purely instructional approach reliably produces minimal code, because "minimal" is a judgment call that requires the domain expertise the instruction is trying to substitute for.

---

**Sources:**
- Kim et al., "Mitigating Length Bias in RLHF through a Causal Lens" (2026)
- "Bias Fitting to Mitigate Length Bias of Reward Model in RLHF" (2025)
- Emergent Mind, "Verbosity Compensation Behavior" (2026)
- Addy Osmani, "The 80% Problem in Agentic Coding" (Jan 2026)
- Addy Osmani, "How to write a good spec for AI agents" (Jan 2026)
- Marmelab, "Agent Experience: Best Practices for Coding Agent Productivity" (Jan 2026)
- Boris Tane, "How I Use Claude Code" (Feb 2026)
- r/ClaudeAI, "Stop claude code from writing too much code" (Jan 2026)
- humanlayer.dev, "Writing a good CLAUDE.md" (Nov 2025)
- heyuan110, "CLAUDE.md Best Practices" (Mar 2026)
- HN thread on "LLMs write plausible code" (Mar 2026)
