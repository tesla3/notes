← [Index](../README.md)

## Thesis: Minimum Code + Proper Composition Wins the LLM Era

### The Argument

LLMs make the cost of expressing taste in code collapse toward zero. The people who know the right decomposition have always existed — senior architects, staff engineers, principal engineers. They could see the clean solution. But implementing it, refactoring toward it, exploring alternatives — all of that was prohibitively expensive in human-hours. So they compromised. Incidental complexity accumulated because removing it cost more than tolerating it.

That cost constraint is now falling. If a principal engineer can try three decompositions in an afternoon instead of committing to one for six months, the codebase converges toward what they always knew it should look like. The taste was always there. The execution budget wasn't.

The result: code where every line exists for a reason. No more, no less. Each module does one thing well, with clear interfaces, combinable in ways the author didn't anticipate. The Unix philosophy, applied to the LLM era.

### Five Claims, Examined

**Claim 1: LLM context is constrained and will remain so.**

Strong. Context rot research (Chroma, Hong et al., 2025) measured 18 models: performance degrades non-uniformly as input length grows. Claude 3.5 Sonnet drops from 88% to 30% accuracy on reasoning tasks at 32K. Larger windows don't fix this — effective context is 50-65% of advertised (Morphllm, 2026). Factory.ai: 1-2M tokens covers only a few thousand files, less than most production codebases. Anthropic charges 2× above 200K tokens. Tooling (RAG, compaction, sub-agents) can mitigate but not eliminate the constraint — these are workarounds for a fundamentally limited attention mechanism.

Implication: code that fits in small context windows has a structural advantage. This favors small, focused modules.

**Claim 2: Small and composable are not two properties but one.**

Correct. "Small" without "composable" is just a mess in more files — fragments the LLM can read individually but can't reason about collectively. "Composable" without "small" defeats the purpose because modules don't fit in context. The Unix philosophy captures both: do one thing well, clear inputs and outputs, combinable, predictable. These are the same properties that make code work well with LLMs: bounded problem, clear interfaces, independently workable, simple behavior. Not two overlapping lists. The same list.

**Claim 3: Coding agents can minimize incidental complexity to near zero.**

Plausible, with conditions. Brooks (1986) distinguished essential complexity (inherent to the problem) from incidental complexity (introduced by tools, frameworks, historical decisions). Most modern codebases are dominated by incidental complexity: build systems, framework boilerplate, serialization ceremony, ORM mappings, configuration management, cross-cutting concerns. If coding agents handle this reliably, what remains is the essential complexity — code that tightly reflects the problem structure. But "reliably" is the operative word. Current agents still introduce their own incidental complexity (the compounding-code dynamic: more code in response to every problem, never less). This claim holds only when agents are guided by human taste + automated verification (tests, benchmarks, linters).

**Claim 4: Cheap rewriting converges systems toward essential complexity.**

The strongest novel claim. Historically, rewriting was so expensive you lived with the first approach that worked. Incidental complexity accumulated as geological layers. Coding agents make exploration nearly free — try three architectures, benchmark all three, pick the best. This is search over design space, and with a good fitness function, search converges.

The fitness function requires four components: tests (correctness), benchmarks (performance), metrics (complexity, coupling, LoC), and human taste (is this the right decomposition?). The first three are automatable. The fourth requires skilled practitioners — but those practitioners have always existed. They were bottlenecked by execution cost, not by scarcity of judgment.

Risk: without all four, you converge to a local minimum. The SQLite rewrite converged on code that passed every check except the benchmark nobody wrote. Risk of oscillation (A→B→A→B) without directional pressure. But with a skilled human in the loop, convergence toward essential complexity is the expected trajectory.

**Claim 5: This creates a self-reinforcing flywheel.**

Clean code → fits in context → better LLM output → easier to refactor → cleaner code. The inverse is equally true: bloated code → context rot → worse LLM output → more bloat → worse code. Codebases that start clean will get cleaner. Codebases that start dirty will get dirtier. The gap widens.

This flywheel explains why the pattern may "dominate" despite the Unix philosophy failing to dominate for 50 years. The historical constraint was that doing it right was expensive. Now doing it right is cheap AND doing it wrong actively degrades your tools. The economic incentive flips: clean code becomes cheaper to maintain than messy code, because messy code breaks the LLM flywheel.

### What About Legacy?

Legacy systems were the apparent counterargument — vast amounts of existing messy code that won't get rewritten. But legacy systems actually support the thesis from both ends:

- **Systems that are already clean** (C, Linux kernel): confirm the pattern. The kernel converged toward essential complexity over 34 years through exactly this mechanism — ruthless taste (Linus as fitness function) + continuous refactoring + every line must justify its existence. LLMs compress the timeline.

- **Systems that aren't clean** (COBOL in banking): persist precisely because rewriting was too expensive. They're pent-up demand waiting for the cost to drop, not immovable obstacles. When the cost falls enough, they get rewritten too.

### Boundary Conditions

The thesis holds when:

1. **A skilled practitioner provides taste.** Without human judgment on decomposition, agents converge to local minima — code that passes automated checks but is architecturally wrong. "Minimum code + proper composition" requires someone who knows what "proper" means.

2. **Automated verification exists.** Tests, benchmarks, linters, type checkers. Without fitness signals, iterative rewriting oscillates rather than converges.

3. **The codebase is amenable.** Greenfield projects benefit immediately. Existing well-structured projects benefit quickly. Existing poorly-structured projects need significant upfront investment to enter the flywheel.

Without all three, you get the 576K-line SQLite rewrite: plausible architecture, correct-looking code, 20,171× slower.

### The Insight, Distilled

**Every line of code is a liability. Coding agents make it economically viable to minimize that liability for the first time.** The people with taste were always bottlenecked by execution cost. That bottleneck is breaking. The result is code that converges toward expressing only essential complexity — minimum code, proper composition, each module doing one thing well. The Unix philosophy, not as aspiration, but as economic inevitability.

The mechanism isn't just "context is constrained" (though it is). It's a flywheel: clean code → better LLM performance → cheaper refactoring → cleaner code. And its inverse: bloat → context rot → worse output → more bloat. For the first time, doing it right is cheaper than doing it wrong.

---

**Key sources:** Brooks, "No Silver Bullet" (1986) · Chroma, "Context Rot" (Hong et al., 2025) · Factory.ai, "The Context Window Problem" (2025) · Addy Osmani, "The 80% Problem in Agentic Coding" (Jan 2026) · Marmelab, "Agent Experience" (Jan 2026) · Boris Tane, "How I Use Claude Code" (Feb 2026) · METR RCT (July 2025, updated Feb 2026) · katanaquant, "Your LLM Doesn't Write Correct Code" (Mar 2026) · RLHF length bias papers (Kim et al. 2026, FiMi-RM 2025) · HN thread discussion (Mar 2026)
