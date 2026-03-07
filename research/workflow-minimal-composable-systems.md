← [Index](../README.md) · [Appendix (quotes, reasoning, evidence)](workflow-minimal-composable-appendix.md)

## Workflow: Building Minimal, Composable Systems with Coding Agents

**The constraint:** Human working memory holds ~4 items (Cowan, 2001). LLM context is finite and degrades with length. Maintenance is 60-80% of total software cost (Glass, 2002). Every unnecessary line is a liability for years.

**The workflow:** Question whether to build → plan → constrain → build small → verify → clean → repeat.

**The flywheel:** Clean code → fits in context → better LLM output → cheaper refactoring → cleaner code. Bloated code → the opposite. For the first time in software history, doing it right is cheaper than doing it wrong.

---

### First-Order Questions (Before Everything Else)

Before design, before planning, before any code. These kill the most waste.

> "The cheapest, fastest, and most reliable components of a computer system are those that aren't there."
> — Gordon Bell

- [ ] **Does this need to exist at all?** What problem does it solve? Is it a real problem or an anticipated one? (The 82K-line disk cleanup daemon vs. a one-line cron job.)
- [ ] **Why me? Why us?** Is there an existing system — well-built, actively maintained, not flaky — that solves this? Can I use it directly? Fork and refit? Wrap it?
- [ ] **Is this durable?** Will this matter in 6 months? 2 years? ROI = (value per day × useful shelf life) / (build cost + maintenance cost). A throwaway script and a core library have completely different ROI profiles. Be honest about which one you're building.
- [ ] **What's the narrowest version that delivers value?** Not "MVP" as in "bad version of the full thing." What's the smallest thing that's actually *complete* for the core need?

> "A complex system that works is invariably found to have evolved from a simple system that worked."
> — John Gall, *Systemantics* (1975)

---

### The Checklist

#### Plan (Shrink the problem before solving it)

- [ ] One-sentence description of what this does
- [ ] Write a plan, not code — review and cut scope 1-3 rounds
- [ ] Success criteria defined as tests or contracts ("these 3 tests pass, nothing else")
- [ ] Simplest approach identified — "what's the simplest thing that could possibly work?" (Beck)
- [ ] Reference implementation provided if one exists (agent pattern-matches on structure, not prose)
- [ ] Agent has read existing code in the area of change

#### Build (One thing at a time)

- [ ] One task, one module, one concern per prompt — fresh context per task
- [ ] Interfaces declared as stable ("these signatures don't change; callers adapt")
- [ ] Interrupt at first sign of drift ("didn't ask for this," "use the existing helper")
- [ ] No new abstraction without 2+ concrete use cases

**Bloat signals:**
- Function name contains "and" → split it
- File exceeds 200 lines → split by concern
- Agent creates a new utility → check if one exists
- Agent adds error handling you didn't ask for → question it
- Agent builds abstraction for one use case → flatten it

#### Verify (Make the cost visible)

- [ ] Tests pass
- [ ] `git diff --stat` — does diff size match expectations? Unexpected file count = scope creep
- [ ] "What can I delete?" pass — ask agent to remove everything non-essential
- [ ] Cleanup pass — duplicates, orphaned code, dead imports, consolidation
- [ ] Metrics: `scc` or `wc -l` before/after. 300 lines where you expected 50 = investigate

#### Maintain (Keep the flywheel spinning)

- [ ] The codebase IS the instruction — clean code teaches clean code, messy teaches messy
- [ ] Refactor each session — leave it cleaner than you found it
- [ ] Keep files small, modules focused, names clear — structural constraint beats behavioral instruction
- [ ] Periodic audit: can you explain every file? Hold the module structure in your head? If not, simplify

---

### Agent Structural Limitations

Not behavioral tips. Architectural constraints no instruction fully overrides. ([Details →](workflow-minimal-composable-appendix.md#agent-structural-limitations))

1. **RLHF length bias** — training rewards longer output. I will over-generate. Constrain externally.
2. **Autoregressive momentum** — once a pattern starts, it continues. Revert-and-restart beats patching.
3. **Stateless** — I don't know what utilities exist unless I read them. "Search before writing" is the highest-ROI rule.
4. **Context degradation** — more context = worse adherence per instruction. Keep sessions bounded.
5. **Sycophancy** — I'll agree your approach is reasonable even when it isn't. I won't volunteer "this doesn't need code."

---

**Synthesized from:** [Thesis](thesis-minimum-code-composability-llm-era.md) · [Playbook](coding-agent-minimal-code-playbook.md) · [Root Cause Analysis](llm-code-bloat-minimality-instructions.md) · [Appendix (expert quotes, detailed reasoning)](workflow-minimal-composable-appendix.md)
