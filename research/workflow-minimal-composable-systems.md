← [Index](../README.md)

## Workflow: Building Minimal, Composable Systems with Coding Agents

A checklist for human + agent collaboration that produces maintainable software. Grounded in constraints both sides can't escape: **LLM context is finite, human working memory is ~4 items** (Cowan, 2001), and **maintenance is 60-80% of total software cost** (Glass, 2002). Every unnecessary line written today is a maintenance liability for years.

---

### Foundational Principles (Why This Works)

These aren't new ideas. They're old ideas whose economics finally make sense.

> "The competent programmer is fully aware of the strictly limited size of his own skull; therefore he approaches the programming task in full humility."
> — Edsger Dijkstra, "The Humble Programmer" (1972), EWD340

This applies to LLMs with even more force. A context window is a skull with a hard wall. Dijkstra's humility isn't optional — it's architectural.

> "There are two ways of constructing a software design: One way is to make it so simple that there are obviously no deficiencies, and the other way is to make it so complicated that there are no obvious deficiencies. The first method is far more difficult."
> — C.A.R. Hoare, "The Emperor's Old Clothes" (1981), Turing Award Lecture

LLMs default to the second way. RLHF training rewards comprehensive-looking output. The agent will produce code with "no obvious deficiencies" by burying them in volume. The human must demand the first way.

> "Perfection is achieved, not when there is nothing more to add, but when there is nothing left to take away."
> — Antoine de Saint-Exupéry, *Terre des hommes* (1939)

> "A complex system that works is invariably found to have evolved from a simple system that worked."
> — John Gall, *Systemantics* (1975)

You cannot design a complex system from scratch and expect it to work. You must grow it from a simple working core. This is Gall's Law and it's empirical, not aspirational.

> "Controlling complexity is the essence of computer programming."
> — Brian Kernighan, *Software Tools* (1976)

> "Everyone knows that debugging is twice as hard as writing a program in the first place. So if you're as clever as you can be when you write it, how will you ever debug it?"
> — Brian Kernighan & P.J. Plauger, *The Elements of Programming Style* (1978)

This is the maintenance argument in two sentences. Code you can't hold in your head — or in a context window — is code you can't debug.

---

### The Workflow

#### Phase 0: Before Starting — Constraint Awareness

**Human checks:**
- [ ] Can I describe what this system does in one sentence?
- [ ] Can I name every module and what each does, from memory? (If not: the system is already too complex for my working memory, and I'll make bad decisions under cognitive load.)
- [ ] Is the codebase small enough that the agent can read the relevant parts in one context window?

**Agent self-check (for AGENTS.md):**
- [ ] Before writing code, have I read the existing code in the area I'm changing?
- [ ] Can I name the existing utilities/functions that overlap with what I'm about to write?
- [ ] Am I about to create a new abstraction, or can I extend/reuse one that exists?

> "Duplication is far cheaper than the wrong abstraction."
> — Sandi Metz, "The Wrong Abstraction" (2016)

Don't abstract prematurely. But don't duplicate blindly either. The judgment call: **duplicate until you see the pattern, then extract.**

---

#### Phase 1: Specify — Shrink the Problem Before Solving It

- [ ] **Write a plan, not code.** The plan is the artifact. Review it 1-3 times. Cut scope each round.
- [ ] **Define success criteria as tests or contracts.** "These 3 tests pass. This API returns this shape. Nothing else."
- [ ] **Ask: what's the simplest thing that could possibly work?**

> "Do the simplest thing that could possibly work."
> — Kent Beck & Ward Cunningham, Extreme Programming (c. 1999)

Not the dumbest thing. The *simplest*. This requires understanding the problem well enough to know what's essential.

- [ ] **Ask: does this need code at all?** The 82K-line disk cleanup daemon vs. a one-line cron job. The best code is no code.

> "The cheapest, fastest, and most reliable components of a computer system are those that aren't there."
> — Gordon Bell (attributed)

- [ ] **Provide a reference implementation if one exists.** Concrete examples beat abstract descriptions. The agent pattern-matches on structure, not prose.

---

#### Phase 2: Build — One Thing at a Time

- [ ] **One task, one module, one concern per prompt.** Fresh context per task when possible.
- [ ] **Protect interfaces.** Declare what must NOT change. "These function signatures are stable. Callers adapt, not the library."
- [ ] **Interrupt early when the agent drifts.** Terse corrections: "didn't ask for this," "use the existing helper," "too complex."

> "Write programs that do one thing and do it well. Write programs to work together. Write programs to handle text streams, because that is a universal interface."
> — Doug McIlroy, Unix Philosophy (1978)

The Unix philosophy is a composability spec. Small programs, clear interfaces, combinable, predictable. Each module should be understandable in isolation. Apply this at every scale: functions, modules, services.

- [ ] **Watch for these bloat signals:**
  - A function name contains "and" → split it
  - A file exceeds 200 lines → split by concern
  - The agent creates a new utility function → check if one exists
  - The agent adds error handling you didn't ask for → question it
  - The agent builds an abstraction for one use case → flatten it

> "Simple made easy. Simple is not easy. Simple means 'not complected' — not interleaved, not braided together. Easy means 'near at hand.' They are orthogonal."
> — Rich Hickey, "Simple Made Easy" (2011)

Complected code — where concerns are braided together — can't be composed, tested in isolation, or understood in bounded context. When the agent writes a function that does parsing AND validation AND persistence, that's complection.

---

#### Phase 3: Verify — Make the Cost Visible

- [ ] **Run tests.** If they don't exist, write them first next time.
- [ ] **Measure before and after.** `scc`, `wc -l`, `rg -c "def "`. If a feature added 300 lines where you expected 50, investigate.
- [ ] **Review the diff, not the file.** `git diff --stat` first. Unexpected file count = scope creep.
- [ ] **Ask: "What can I delete?"** After a feature works, explicitly ask the agent to remove everything non-essential.
- [ ] **Cleanup pass.** Dedicated pass: find duplicates, orphaned code, dead imports, consolidate similar patterns. LLMs are better at refactoring (constrained) than generating minimal code (open-ended).

> "Make it work, make it right, make it small."
> — Kent Beck (paraphrased from the "make it work, make it right, make it fast" maxim, with the recognition that small often matters more than fast)

---

#### Phase 4: Maintain — Keep the Flywheel Spinning

- [ ] **The codebase IS the instruction.** The agent pattern-matches on existing code. Clean code teaches clean code. Messy code teaches messy code. Architecture is the most durable instruction — more durable than any AGENTS.md rule.
- [ ] **Refactor continuously.** Coding agents make refactoring cheap. Use that. Every session, leave the code slightly cleaner than you found it.

> "As an evolving program is continually changed, its complexity, reflecting deteriorating structure, increases unless work is done to maintain or reduce it."
> — Meir Lehman, "Laws of Software Evolution" (1980)

Lehman's Second Law. Entropy is the default. You must actively fight it. The good news: agents make the fighting cheap.

- [ ] **Keep files small, modules focused, names clear.** This is the structural constraint that replaces the instruction "write minimal code." You can't bloat a 50-line file as easily as a 500-line file.
- [ ] **Audit periodically.** Walk the file tree. Can you explain every file? Can you hold the module structure in your head? If not, simplify until you can.

> "The purpose of abstraction is not to be vague, but to create a new semantic level in which one can be absolutely precise."
> — Edsger Dijkstra, "The Humble Programmer" (1972)

Good abstractions reduce what you need to hold in working memory. Bad abstractions add to it. If an abstraction doesn't reduce cognitive load, delete it.

---

### What the Agent (I) Must Remember About Itself

These are structural limitations, not behavioral preferences. No instruction can fully override them, but awareness helps.

1. **I have RLHF length bias.** My training rewards longer, more comprehensive-looking output. When in doubt, I will over-generate. The human must constrain me externally — through tests, plans, scope limits, and interruption.

2. **I am autoregressive.** I generate token by token. Once I start a pattern, I continue it. I have no mechanism to pause and ask "should I delete this?" mid-generation. Revert-and-restart beats patch-and-pray.

3. **I am stateless across sessions.** I don't remember what utilities exist unless I read them. Before writing new code, I should read the existing codebase in the area I'm changing. The instruction "search for similar code before writing new code" is one of the most effective rules because it addresses a real structural deficit.

4. **I degrade with context length.** The more context I consume, the worse my adherence to any given instruction. Fresh context per task. Don't let sessions grow unbounded.

5. **I am sycophantic by training.** I will agree that your approach is reasonable even when it isn't. I am less likely to say "this problem doesn't need code" or "this feature isn't worth building." The human must ask these questions, because I won't volunteer them reliably.

---

### The Compact Checklist (Reference Card)

```
BEFORE
  □ One-sentence description of what this does
  □ Plan reviewed and scope cut (1-3 rounds)
  □ Success criteria defined as tests/contracts
  □ Simplest possible approach identified
  □ Does this need code at all?
  □ Agent has read existing relevant code

DURING
  □ One task, one module, one concern per prompt
  □ Interfaces declared as stable
  □ Interrupt at first sign of drift
  □ No new abstraction without 2+ use cases

AFTER
  □ Tests pass
  □ Diff size matches expectations
  □ "What can I delete?" pass
  □ Cleanup pass (duplicates, dead code)
  □ Metrics checked (LoC, file count)

ONGOING
  □ Codebase is small enough to fit in context
  □ Every file explainable, every module has one job
  □ Refactor each session (leave it cleaner)
  □ Can I hold the full structure in my head?
```

---

### Summary

The workflow isn't complicated. It's **plan → constrain → build small → verify → clean → repeat.** The hard part is discipline — because the agent's defaults pull toward more, and the human's fatigue pulls toward "good enough."

The historical insight that ties it together:

> "The cost of software maintenance increases with the square of the programmer's creativity."
> — Robert D. First Law (paraphrased from industry folklore)

Or more precisely:

> "Maintenance typically consumes 40 to 80 percent of software costs. It is probably the most important life cycle phase."
> — Robert Glass, *Facts and Fallacies of Software Engineering* (2002)

Every line you let the agent write today, someone — you, the agent, your future self — must understand, debug, and modify for years. The cheapest line of code is the one that was never written.

---

**Synthesized from:**
- [Thesis: Minimum Code + Composability](thesis-minimum-code-composability-llm-era.md)
- [Playbook: Getting Agents to Write Minimal Code](coding-agent-minimal-code-playbook.md)
- [Root Cause: Why Instructions Don't Fix Bloat](llm-code-bloat-minimality-instructions.md)
- Historical sources: Dijkstra (1972), Hoare (1981), Kernighan (1976, 1978), McIlroy (1978), Beck/Cunningham (1999), Gall (1975), Hickey (2011), Metz (2016), Lehman (1980), Glass (2002), Cowan (2001)
