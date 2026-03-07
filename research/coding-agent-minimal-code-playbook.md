← [Index](../README.md)

## Getting Coding Agents to Write Minimal, Composable Code

Every line is a future liability. These techniques reduce the lines that get written.

---

### Before Code Exists

**Plan first, code never until approved.** Write a plan.md. Annotate it. Cut scope aggressively. "Remove the download feature from the plan, I don't want this now." Repeat 1-6 times. The explicit guard "don't implement yet" is essential — without it, agents start coding the moment they think the plan is good enough. It isn't good enough until you say it is. *(Boris Tane)*

**Give success criteria, not instructions.** "Here are the tests that must pass. Here's the API contract. Figure out how." Declarative beats imperative. Agents iterate relentlessly against clear criteria. They fail when criteria are vague. *(Osmani)*

**Write tests first.** Tests naturally bound scope. You can't bloat a solution constrained by "make these 3 tests pass and nothing else." TDD loop: write failing test → implement minimal code → run tests → refactor → repeat. *(Multiple practitioners)*

**Show, don't describe.** Share a reference implementation from a repo that does it well. "This is how they do sortable IDs — write a plan for how we adopt a similar approach." Agents produce dramatically better output from concrete examples than from abstract descriptions. *(Boris Tane)*

**Research the codebase first.** Before any implementation, have the agent read relevant code deeply and write findings to a file. "Read this folder in depth, write a detailed report of your learnings in research.md." This prevents reinventing utilities that already exist — a primary source of bloat. *(Boris Tane, multiple r/ClaudeAI users)*

### While Code Is Being Written

**One task, one module, one concern.** Keep each prompt focused on a single bounded problem. Fresh context per task. Don't let the agent work across many files in one pass — that's where bloat, dead code, and unasked-for features appear. *(Marmelab, Osmani)*

**Interrupt early.** Watch the code as it's written. The moment it starts doing something you didn't ask for — stop it. Terse corrections: "didn't ask for this." "too complex, just use Promise.all." "use the existing auth helper, don't write a new one." *(Multiple practitioners)*

**Protect interfaces.** Set hard constraints on what shouldn't change. "The signatures of these three functions should not change. The caller should adapt, not the library." Prevents the agent from "improving" stable code. *(Boris Tane)*

**Revert, don't patch.** When something goes wrong, don't try to fix it incrementally. Discard, narrow scope, restart. "I reverted everything. Now all I want is to make the list view more minimal — nothing else." Narrowing scope after a revert almost always beats patching a bad approach. *(Boris Tane, general best practice)*

### After Code Exists

**Cleanup passes.** Let it bloat on the first pass if needed, then run dedicated passes: find duplicate functions, find orphaned code, find dead imports, consolidate similar patterns. LLMs are better at refactoring (constrained task) than at generating minimal code (open-ended task). *(r/ClaudeAI practitioners)*

**Ask "what can I delete?"** After a feature works, explicitly ask: "What code in this changeset is not strictly necessary? Remove it." Then: "Are there any utility functions in the codebase that duplicate what was just written? Consolidate." *(Derived from pornel's insight on compounding code)*

**Verify with metrics.** Run `scc` or equivalent before and after. Track LoC, complexity, file count. If a feature added more lines than you expected, investigate. Make the cost visible.

### In the Rules File (CLAUDE.md / AGENTS.md)

Keep rules few, specific, and testable. Vague rules waste context and get ignored.

**Rules that work:**
- "Prefer modifying existing functions over creating new ones. Search for similar code before writing new code."
- "No file should exceed 200 lines. If it does, split by concern."
- "One function, one responsibility. If a function name contains 'and', split it."
- "NEVER add features not explicitly requested."
- "Run tests before committing."

**Rules that don't work:**
- "Write clean, maintainable code" — too vague, already default behavior
- "Follow best practices" — means nothing specific
- "Keep it simple" — slightly better than nothing, but unenforceable

**The structural rule that matters most:** Keep the codebase itself small and well-organized. Small files, focused modules, clear naming. The agent will pattern-match on what already exists. A clean codebase teaches the agent to write clean code. A messy codebase teaches it to write messy code. Architecture is the most durable instruction.

---

**Sources:** Boris Tane "How I Use Claude Code" (2026) · Osmani "80% Problem" + "Good Spec for AI Agents" (2026) · Marmelab "Agent Experience" (2026) · r/ClaudeAI "Stop claude code from writing too much code" (2026) · humanlayer.dev "Writing a good CLAUDE.md" (2025) · HN thread "Plausible Code" (2026)
