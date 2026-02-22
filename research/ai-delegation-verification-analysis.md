← [Index](../README.md)

# AI Delegation and the Verification Problem: Historical Analogies and Their Limits

**Context:** Elaboration and critical review of a claim from the [HN thread distillation on Claude Code planning-first workflows](hn-claude-code-planning-execution.md). The claim: the planning-first workflow may be a transitional pattern, not an endpoint, because history shows that as agents become cheap and competent, human oversight shifts from direct review to system design. This document develops the argument, then tears it apart.

## The Argument

### The verification problem isn't new

Every complex society runs on delegation to agents whose work the delegator cannot fully verify. The Roman senator couldn't inspect every province. The CEO can't read every line of code. The patient can't verify the surgeon's technique mid-operation. Civilization scaled *because* we developed mechanisms to delegate to unverifiable agents, not despite it.

### Five historical mechanisms

1. **Outcome-based accountability.** You can't watch the work, but you can measure the results. The bridge stands or falls. The patient lives or dies. You don't need to understand the process if the outcomes are legible.

2. **Reputation and repeated games.** You trust the agent because defection has long-term costs. The guild system, professional licensure, career consequences. Only works when the agent has a persistent identity and something to lose.

3. **Hierarchical verification with sampling.** You can't check everything, so you check some things. Audits, spot checks, inspections. The agent doesn't know *which* work will be verified, so they treat all work as potentially inspected.

4. **Structural constraints.** You design the system so the agent *can't* defect easily, regardless of intent. Separation of powers, double-entry bookkeeping, two-key launch. Architecture prevents failure modes rather than detecting them.

5. **Adversarial verification.** Multiple agents check each other. Peer review, adversarial legal system, second medical opinions, red teams. No single agent is trusted; the process produces trust through disagreement and resolution.

### Three genuinely new things about AI delegation

**Cost collapse.** Delegation historically required recruiting, training, managing, and compensating human agents. AI delegation costs fractions of a cent per task. This means you can delegate things you'd never have delegated before—trivial, speculative, low-expected-value tasks. When delegation is cheap enough, the optimal strategy shifts from "specify perfectly upfront" toward "generate many attempts, verify outcomes, discard failures."

**Speed of iteration.** Historical delegation operated on slow cycles—months for a governor, weeks for a construction project. Getting the delegation right upfront was critical because iteration was slow. AI delegation operates on seconds-to-minutes cycles. The planning-first workflow is importing a slow-feedback-loop strategy into a fast-feedback-loop environment.

**Parallel adversarial agents at zero marginal cost.** You couldn't cheaply clone a lawyer and have the clone audit the original's work. You can do exactly that with AI. The economics of adversarial verification are completely transformed.

### The original conclusion

The planning-first workflow maps to mechanism #4 (structural constraints)—the most conservative option. The historical pattern when agents improve is a shift toward outcome-based accountability + adversarial verification. The annotation cycle won't be replaced by nothing; it'll be replaced by outcome tests, adversarial agents, and structural constraints at a higher level of abstraction. The human's role shifts from reviewer to system designer.

---

## The Critique

### The central analogy is weaker than presented

The failure modes of human delegation and AI delegation are fundamentally different:

- **Human agents:** understand the task but may not be aligned. The governor knows how to tax; he might skim. Solutions focus on *alignment*—incentives, accountability, reputation.
- **AI agents:** are aligned (try to do what you ask) but may not understand. Claude isn't sandbagging—it's producing wrong code because it lacks genuine comprehension. Solutions need to focus on *competence verification*.

Most of the five historical mechanisms solve the alignment problem, not the competence problem. This means the mechanisms don't transfer as cleanly as claimed:

- **Reputation (#2) doesn't apply to AI at all.** You can't fire Claude. There's no career consequence, no persistent identity with something to lose. This mechanism is simply inapplicable.
- **Outcome-based accountability (#1) transfers weakly.** Bridges stand or fall; software has a vast spectrum of "sort of works." It passes tests but is unmaintainable, handles the happy path but fails under load, is correct today but creates compounding architectural debt. The planning-first workflow exists precisely because "it works" is insufficient. Outcome verification only works when outcomes are legible, and software quality is notoriously illegible.
- **Sampling (#3) transfers** but was underdeveloped in the argument.
- **Structural constraints (#4) and adversarial verification (#5) do transfer.** These are the load-bearing parts; the argument should have been built entirely on them.

The "humans solved this already" framing is oversold. Humans solved a *different* problem (misaligned agents) with mechanisms that partially but not cleanly address the AI problem (incompetent-but-aligned agents). The planning-first workflow is a *competence-enhancement* mechanism—giving the AI more context so it understands better—which maps poorly onto the alignment-focused historical toolkit.

### The "trajectory toward less oversight" has major counterexamples

The argument claims: as agents improve, oversight relaxes. Counterexamples:

- **Aviation:** Pilots got dramatically better AND structural constraints got tighter—more checklists, more procedures, more redundancy, more regulation.
- **Medicine:** More protocols, more checklists, more structural safeguards, not fewer, even as doctors became more capable.
- **Finance:** Regulation has generally increased as financial professionals became more sophisticated.

The actual pattern in high-stakes domains: as systems become more complex and consequential, structural constraints *increase* even when agent competence increases. The relaxation of oversight may only hold for low-stakes domains. For high-stakes software (medical, financial, infrastructure), the trajectory might be *more* planning documents, *more* human review, *more* structural constraint—not less.

### Correlated failures undermine adversarial verification

The argument calls parallel adversarial agents "genuinely unprecedented" then waves at correlated failures as a caveat. But this caveat is load-bearing. If Claude reviews Claude's code, the reviewer shares the same training data, the same blind spots, the same systematic errors as the author. This isn't two independent experts—it's closer to identical twins reviewing each other's homework. Cross-model verification helps but models share much of their training data. The independence assumption underlying adversarial verification may be much weaker for AI than for humans.

### The conclusion is unfalsifiable

"Structural constraints at a higher level of abstraction" is a direction-gesture, not a claim. It doesn't commit to anything specific enough to be wrong. The honest version: it's unclear what replaces the annotation cycle, and the boring answer might be "better tests and better CI"—not a deep historical pattern about delegation.

### Implicit assumption of continued capability improvement

The entire trajectory argument depends on models continuing to get dramatically better. If capabilities plateau or improve slowly, the planning-first workflow isn't transitional—it's just what AI-assisted development looks like for a long time. That's an empirical bet, not a historical inevitability.

### One-sided cost framing

The cost of *generating* code has collapsed. The cost of *bad* delegation hasn't changed—shipping buggy code to production is just as expensive whether a human or AI wrote it. Cheap generation + unchanged failure cost means the verification burden gets *harder*, not easier, because you're generating more candidates to verify.

---

## What Survives

- **Speed-of-iteration tension is real.** Planning-first is importing a slow-feedback strategy into a fast-feedback environment. Under-discussed.
- **Parallel-agent economics are genuinely new**, even with the correlated-failure caveat.
- **Structural constraints are the most conservative strategy.** The planning-first workflow *is* the most constraining option in the toolkit. Correct observation.
- **The core question is right** even if the answer was overconfident: whether human review is a permanent necessity or a transitional comfort.

## Honest Conclusion

The historical delegation analogy is *suggestive* but not *determinative*. Human society solved delegation of misaligned agents; AI delegation is a competence problem with different structure. Some mechanisms transfer (outcome verification, adversarial checks, structural constraints), one doesn't (reputation), and the one that matters most (outcome verification) is limited by how legible software quality is.

The trajectory toward less oversight is plausible for low-stakes work and historically unsupported for high-stakes work. The strongest defensible claim: **the annotation cycle will shrink as models improve, and the most productive practitioners will be the ones who figure out which parts of human oversight to replace with automated verification first.** That's less grand than "it's just the historical delegation pattern playing out again." It's also more likely to be true.
