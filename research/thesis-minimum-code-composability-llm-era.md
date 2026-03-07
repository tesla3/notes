← [Index](../README.md)

## Minimum Code + Proper Composition Wins the LLM Era

### The Flywheel

Clean code → fits in context → better LLM output → cheaper refactoring → cleaner code.

Bloated code → context rot → worse LLM output → more bloat → worse code.

For the first time, doing it right is cheaper than doing it wrong.

### Why Now

The people with taste — who know the right decomposition — have always existed. They were bottlenecked by execution cost. A principal engineer who sees three possible architectures could only afford to build one. Incidental complexity accumulated because removing it cost more than tolerating it.

Coding agents collapse that cost. Try three decompositions in an afternoon. Refactor repeatedly until only essential complexity remains. The taste was always there. The budget wasn't.

### Why Small + Composable

Not two properties. One. The Unix philosophy: do one thing well, clear interfaces, combinable, predictable.

Small without composable is a mess in more files. Composable without small doesn't fit in context. You need both. And they're the same properties that make code work with LLMs: bounded problems, clear interfaces, independently workable, predictable behavior.

### Why It Converges

Cheap rewriting = search over design space. With a fitness function — tests (correctness), benchmarks (performance), metrics (complexity), and human taste (right decomposition?) — iterative rewriting converges toward essential complexity. Every pass sheds incidental complexity: boilerplate, ceremony, framework artifacts, historical accidents.

Without human taste, you converge to a local minimum. The 576K-line SQLite rewrite passed every automated check. It was 20,171× slower on primary key lookups.

### Why "Dominate" Holds This Time

The Unix philosophy has been technically superior for 50 years without dominating. The difference: historically, doing it right was expensive. Now doing it right is cheap AND doing it wrong actively degrades your tools (context rot breaks the LLM flywheel). The economic incentive flips.

Legacy systems aren't a counterargument. Clean ones (C, Linux kernel) confirm the pattern — they converged through taste + refactoring over decades. Dirty ones (COBOL) persist because rewriting was too expensive. They're pent-up demand, not immovable obstacles.

### Boundary Conditions

Requires all three: skilled practitioner providing taste, automated verification (tests/benchmarks/linters), and a codebase structured enough to enter the flywheel. Without these, you get the SQLite rewrite — plausible code, catastrophically wrong.

---

**Sources:** Chroma "Context Rot" (2025) · Factory.ai "Context Window Problem" (2025) · Brooks "No Silver Bullet" (1986) · Osmani "80% Problem" (2026) · Marmelab "Agent Experience" (2026) · METR RCT (2025) · katanaquant "Plausible Code" (2026) · RLHF length bias papers (2025-2026)
