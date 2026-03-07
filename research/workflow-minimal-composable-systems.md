← [Index](../README.md)

## Workflow: Building Minimal, Composable Systems with Coding Agents

> "The competent programmer is fully aware of the strictly limited size of his own skull; therefore he approaches the programming task in full humility."
> — Edsger Dijkstra, EWD340 (1972)

This applies to both sides. Human working memory holds ~4 items (Cowan, 2001). LLM context is finite and degrades with length. Maintenance is 60-80% of total software cost (Glass, 2002). Every unnecessary line is a liability for years.

**The workflow:** Question whether to build → plan → constrain → build small → verify → clean → repeat.

**The flywheel:** Clean code → fits in context → better LLM output → cheaper refactoring → cleaner code. Bloated code → the opposite. For the first time in software history, doing it right is cheaper than doing it wrong.

**Agent limitations** shape this workflow — see [why the agent over-generates and can't self-correct](workflow-agent-structural-limitations.md).

---

### First-Order Questions (Before Everything Else)

Before design, before planning, before any code. These kill the most waste.

> "The cheapest, fastest, and most reliable components of a computer system are those that aren't there."
> — Gordon Bell

- [ ] **Does this need to exist at all?** What problem does it solve? Is it a real problem or an anticipated one? (The 82K-line disk cleanup daemon vs. a one-line cron job.)
- [ ] **Why me? Why us?** Is there an existing system — well-built, actively maintained, not flaky — that solves this? Can I use it directly? Fork and refit? Wrap it?
- [ ] **Is this durable?** Will this matter in 6 months? 2 years? ROI = (value per day × useful shelf life) / (build cost + maintenance cost). Be honest about which one you're building.
- [ ] **What's the narrowest version that delivers value?** Not "MVP" as in "bad version of the full thing." The smallest thing that's actually *complete* for the core need.

> "A complex system that works is invariably found to have evolved from a simple system that worked."
> — John Gall, *Systemantics* (1975)

---

### Plan (Shrink the problem before solving it)

> "There are two ways of constructing a software design: One way is to make it so simple that there are obviously no deficiencies, and the other way is to make it so complicated that there are no obvious deficiencies. The first method is far more difficult."
> — C.A.R. Hoare, Turing Award Lecture (1981)

- [ ] One-sentence description of what this does
- [ ] Write a plan, not code — review and cut scope 1-3 rounds
- [ ] Success criteria defined as tests or contracts ("these 3 tests pass, nothing else")
- [ ] Reference implementation provided if one exists (agent pattern-matches on structure, not prose)
- [ ] Agent has read existing code in the area of change

> "Do the simplest thing that could possibly work."
> — Kent Beck & Ward Cunningham, Extreme Programming (c. 1999)

Not the dumbest thing. The *simplest*. This requires understanding the problem well enough to know what's essential.

---

### Build (One thing at a time)

> "Write programs that do one thing and do it well. Write programs to work together."
> — Doug McIlroy, Unix Philosophy (1978)

- [ ] One task, one module, one concern per prompt — fresh context per task
- [ ] Interfaces declared as stable ("these signatures don't change; callers adapt")
- [ ] Interrupt at first sign of drift ("didn't ask for this," "use the existing helper")
- [ ] No new abstraction without 2+ concrete use cases

> "Duplication is far cheaper than the wrong abstraction."
> — Sandi Metz, "The Wrong Abstraction" (2016)

**Bloat signals:**
- Function name contains "and" → split it
- File exceeds 200 lines → split by concern
- Agent creates a new utility → check if one exists
- Agent adds error handling you didn't ask for → question it
- Agent builds abstraction for one use case → flatten it

> "Simple is not easy. Simple means 'not complected' — not interleaved, not braided together."
> — Rich Hickey, "Simple Made Easy" (2011)

When the agent writes a function that does parsing AND validation AND persistence, that's complection. Split it.

---

### Verify (Make the cost visible)

> "Everyone knows that debugging is twice as hard as writing a program in the first place. So if you're as clever as you can be when you write it, how will you ever debug it?"
> — Brian Kernighan & P.J. Plauger, *The Elements of Programming Style* (1978)

- [ ] Tests pass
- [ ] `git diff --stat` — does diff size match expectations? Unexpected file count = scope creep
- [ ] "What can I delete?" pass — ask agent to remove everything non-essential
- [ ] Cleanup pass — duplicates, orphaned code, dead imports, consolidation
- [ ] Metrics: `scc` or `wc -l` before/after. 300 lines where you expected 50 = investigate

> "Perfection is achieved, not when there is nothing more to add, but when there is nothing left to take away."
> — Antoine de Saint-Exupéry, *Terre des hommes* (1939)

---

### Maintain (Keep the flywheel spinning)

> "As an evolving program is continually changed, its complexity, reflecting deteriorating structure, increases unless work is done to maintain or reduce it."
> — Meir Lehman, "Laws of Software Evolution" (1980)

Entropy is the default. Agents make fighting it cheap. Use that.

- [ ] The codebase IS the instruction — clean code teaches clean code, messy teaches messy
- [ ] Refactor each session — leave it cleaner than you found it
- [ ] Keep files small, modules focused, names clear — structural constraint beats behavioral instruction
- [ ] Periodic audit: can you explain every file? Hold the module structure in your head? If not, simplify

> "The purpose of abstraction is not to be vague, but to create a new semantic level in which one can be absolutely precise."
> — Edsger Dijkstra, EWD340 (1972)

If an abstraction doesn't reduce cognitive load, delete it.

---

**Synthesized from:** [Thesis](thesis-minimum-code-composability-llm-era.md) · [Playbook](coding-agent-minimal-code-playbook.md) · [Root Cause Analysis](llm-code-bloat-minimality-instructions.md) · [Agent Limitations](workflow-agent-structural-limitations.md)

**Historical sources:** Dijkstra (1972) · Hoare (1981) · Kernighan (1976, 1978) · McIlroy (1978) · Beck & Cunningham (1999) · Gall (1975) · Hickey (2011) · Metz (2016) · Lehman (1980) · Glass (2002) · Cowan (2001) · Saint-Exupéry (1939)
