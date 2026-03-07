← [Workflow](workflow-minimal-composable-systems.md) · [Index](../README.md)

## Anti-Patterns: What Doesn't Work

Things that feel productive but waste effort, context, or both. Grouped by why they fail.

---

### Vague Rules

Rules that sound right but aren't testable. They burn an instruction slot without changing behavior.

- "Write clean, maintainable code" — too vague, already default behavior
- "Follow best practices" — means nothing specific
- "Keep it simple" — slightly better than nothing, but unenforceable
- "Be careful with error handling" — careful how?

**The test:** Can you check compliance mechanically? "No file over 200 lines" → yes. "Write clean code" → no. If you can't test it, it won't stick.

### Instruction Overload

More rules ≠ better output. The opposite.

> "As you pile on more instructions, the model's performance in adhering to each one drops significantly."
> — Osmani, citing "curse of instructions" research

~150 effective instruction slots after system prompt overhead. Every vague rule crowds out a specific one. A 100+ rule AGENTS.md is noise — the agent complies with whichever rules happen to get attention weight, not the ones you care about most.

**Fix:** Few rules, high specificity. Cut any rule that isn't earning its slot.

### Fighting the Weights

RLHF trained the model to favor longer, more comprehensive output. A prompt saying "be concise" fights gradient-level optimization. The prompt nudges; it can't override weights.

- "Write minimal code" in system prompt → low-moderate effectiveness
- KISS/YAGNI/SOLID in AGENTS.md → helps at margin, degrades with instruction count
- "Don't overengineer" → the agent doesn't know it's overengineering

**What works instead:** External constraints — tests that bound scope, plans reviewed before coding, architectural constraints (small files, focused modules), active interruption. Structure the environment so bloat can't happen, rather than asking the agent not to bloat.

### Patching Forward

When the agent goes down a wrong path, the instinct is to fix incrementally. This almost always makes it worse — autoregressive momentum means each correction adds more code on top of a flawed foundation.

> "There's a very strong prior to 'just keep generating more tokens' as opposed to deleting code."
> — krackers, HN

- Asking "fix this bug" on a bad approach → more code, same bad structure
- "Add error handling for this edge case" on overengineered code → deeper hole
- Multiple correction rounds in one session → context fills with failed attempts

**What works instead:** Revert, narrow scope, restart with fresh context.

### Assuming Agent Knowledge

The agent doesn't know what code already exists unless it reads it. It reinvents utilities, duplicates helpers, and creates parallel implementations — not from ignoring instructions, but from genuine ignorance.

> "It's almost impossible to let CC fully loose and think it will consider the suite of utility functions already implemented."
> — u/mysportsact, r/ClaudeAI

- Expecting reuse without explicit "read this first" → duplication
- Expecting awareness of project conventions without examples → inconsistency
- Expecting knowledge of what changed in prior sessions → stale assumptions

**What works instead:** "Read this folder, write findings to a file." "Search for existing utilities before creating new ones." Make the agent prove it knows the codebase before it writes.

### Expecting Agent Judgment

The agent optimizes for agreement, not for challenging premises. RLHF rewards helpfulness over pushback.

- Expecting the agent to say "this doesn't need code" → it won't volunteer this
- Expecting "this feature isn't worth building" → it will build whatever you ask
- Expecting it to choose the right abstraction level → it will match whatever patterns it sees

> "A decent programmer would and should push back on that."
> — marginalia_nu, HN

**What works instead:** The human provides judgment. First-Order Questions are human questions because the agent can't answer them reliably. Taste, scope decisions, and "should this exist?" are human responsibilities.

### Unbounded Sessions

Bloat compounds across long sessions. The agent loses track of its own output, instruction adherence degrades, and context fills with noise from prior attempts.

- Marathon sessions on complex features → quality degrades progressively
- Carrying failed approaches in context → poisons subsequent attempts
- "Just keep going" without fresh starts → diminishing returns

**What works instead:** Fresh context per task. One bounded problem per session. When switching concerns, start clean.

### Verification Without Taste

Automated checks (tests, linters, benchmarks) are necessary but insufficient. They verify correctness, not quality. A system can pass every test and be catastrophically wrong in ways tests don't measure.

> The 576K-line SQLite rewrite passed every automated check. It was 20,171× slower on primary key lookups.

- Green CI ≠ good code
- "All tests pass" ≠ right decomposition
- Low complexity metrics ≠ right abstraction

**What works instead:** Human taste + automated verification. The human asks "is this the right approach?" The tests ask "does this approach work?" You need both.

---

**Synthesized from:** [Playbook](coding-agent-minimal-code-playbook.md) · [Root Cause Analysis](llm-code-bloat-minimality-instructions.md) · [Agent Limitations](workflow-agent-structural-limitations.md) · [Thesis](thesis-minimum-code-composability-llm-era.md)
