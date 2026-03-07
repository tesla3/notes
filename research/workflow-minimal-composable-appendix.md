← [Workflow](workflow-minimal-composable-systems.md) · [Index](../README.md)

## Appendix: Expert Quotes, Detailed Reasoning, Evidence

Supporting material for the [Workflow: Minimal Composable Systems](workflow-minimal-composable-systems.md). Read when you want the *why* behind a checklist item, or when the quotes would help anchor agent reasoning on a specific problem.

---

### The Core Constraint

> "The competent programmer is fully aware of the strictly limited size of his own skull; therefore he approaches the programming task in full humility."
> — Edsger Dijkstra, "The Humble Programmer" (1972), EWD340

Applies to LLMs with more force. A context window is a skull with a hard wall. Dijkstra's humility isn't optional — it's architectural.

> "Everyone knows that debugging is twice as hard as writing a program in the first place. So if you're as clever as you can be when you write it, how will you ever debug it?"
> — Brian Kernighan & P.J. Plauger, *The Elements of Programming Style* (1978)

The maintenance argument in two sentences. Code you can't hold in your head — or in a context window — is code you can't debug.

> "Maintenance typically consumes 40 to 80 percent of software costs. It is probably the most important life cycle phase."
> — Robert Glass, *Facts and Fallacies of Software Engineering* (2002)

---

### On Simplicity vs. Complexity

> "There are two ways of constructing a software design: One way is to make it so simple that there are obviously no deficiencies, and the other way is to make it so complicated that there are no obvious deficiencies. The first method is far more difficult."
> — C.A.R. Hoare, "The Emperor's Old Clothes" (1981), Turing Award Lecture

LLMs default to the second way. RLHF training rewards comprehensive-looking output — code with "no obvious deficiencies" achieved by burying them in volume.

> "Perfection is achieved, not when there is nothing more to add, but when there is nothing left to take away."
> — Antoine de Saint-Exupéry, *Terre des hommes* (1939)

> "Controlling complexity is the essence of computer programming."
> — Brian Kernighan, *Software Tools* (1976)

> "Simple made easy. Simple is not easy. Simple means 'not complected' — not interleaved, not braided together. Easy means 'near at hand.' They are orthogonal."
> — Rich Hickey, "Simple Made Easy" (2011)

Complected code — where concerns are braided together — can't be composed, tested in isolation, or understood in bounded context. When the agent writes a function that does parsing AND validation AND persistence, that's complection. Split it.

---

### On Composability

> "Write programs that do one thing and do it well. Write programs to work together."
> — Doug McIlroy, Unix Philosophy (1978)

A composability spec at every scale: functions, modules, services. Each unit should be understandable in isolation.

> "The purpose of abstraction is not to be vague, but to create a new semantic level in which one can be absolutely precise."
> — Edsger Dijkstra, "The Humble Programmer" (1972)

Good abstractions reduce what you need to hold in working memory. Bad abstractions add to it. If an abstraction doesn't reduce cognitive load, delete it.

> "Duplication is far cheaper than the wrong abstraction."
> — Sandi Metz, "The Wrong Abstraction" (2016)

Duplicate until you see the pattern, then extract. Not before.

---

### On Growing Systems

> "A complex system that works is invariably found to have evolved from a simple system that worked."
> — John Gall, *Systemantics* (1975)

You cannot design a complex system from scratch and expect it to work. Grow it from a simple working core. This is empirical, not aspirational.

> "Do the simplest thing that could possibly work."
> — Kent Beck & Ward Cunningham, Extreme Programming (c. 1999)

Not the dumbest thing. The *simplest*. This requires understanding the problem well enough to know what's essential.

> "Make it work, make it right, make it small."
> — Kent Beck (adapted — "small" often matters more than "fast" for maintainability)

---

### On Entropy

> "As an evolving program is continually changed, its complexity, reflecting deteriorating structure, increases unless work is done to maintain or reduce it."
> — Meir Lehman, "Laws of Software Evolution" (1980)

Lehman's Second Law. Entropy is the default. You must actively fight it. Agents make the fighting cheap — use that.

---

### Agent Structural Limitations

These are structural, not behavioral. No instruction fully overrides them, but awareness helps the human constrain effectively.

**1. RLHF length bias.** Multiple 2025-2026 papers establish that reward models systematically favor longer outputs (Kim et al. 2026; "Bias Fitting" 2025 NeurIPS-adjacent). A prompt saying "keep it concise" fights gradient-level optimization that says "longer = higher reward." The prompt can nudge; it can't override weights.

**2. Autoregressive momentum.** Token-by-token generation means each token makes the next more likely to continue the pattern. There's no architectural mechanism to pause mid-generation and ask "should I delete what I just wrote?" (krackers, HN: "There's a very strong prior to 'just keep generating more tokens' as opposed to deleting code.")

**3. Statelessness.** The agent can't write minimal code if it doesn't know what code already exists. It reinvents rather than reuses — not because it ignores instructions, but because it hasn't read the relevant files. This is a context window problem, not an instruction-following problem. (Funny-Anything-791, r/ClaudeAI: "The problem is that the LLM is stateless and unaware of the existing solutions in the code.")

**4. Context degradation.** Research confirms diminishing instruction adherence with prompt length. "As you pile on more instructions, the model's performance in adhering to each one drops significantly" (Osmani, citing "curse of instructions" research). ~150 effective instruction slots after system prompt. "Write minimal code" competes with every other instruction.

**5. Sycophancy.** The model optimizes for agreement, not for questioning premises. "A decent programmer would and should push back" (marginalia_nu) — the model won't, because RLHF rewards helpfulness over challenge. The human must ask "does this need code at all?" because the agent won't volunteer it reliably.

---

**Sources:**
- Dijkstra, "The Humble Programmer" (1972), EWD340
- Kernighan & Plauger, *The Elements of Programming Style* (1978)
- Kernighan, *Software Tools* (1976)
- Hoare, "The Emperor's Old Clothes" (1981), Turing Award Lecture
- McIlroy, Unix Philosophy (1978)
- Beck & Cunningham, Extreme Programming (c. 1999)
- Gall, *Systemantics* (1975)
- Hickey, "Simple Made Easy" (2011)
- Metz, "The Wrong Abstraction" (2016)
- Lehman, "Laws of Software Evolution" (1980)
- Glass, *Facts and Fallacies of Software Engineering* (2002)
- Cowan, "The Magical Number Four" (2001)
- Saint-Exupéry, *Terre des hommes* (1939)
- Kim et al., "Mitigating Length Bias in RLHF" (2026)
- Osmani, "The 80% Problem" (2026); "Good Spec for AI Agents" (2026)
