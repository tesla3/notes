← [Workflow](workflow-minimal-composable-systems.md) · [Index](../README.md)

## Agent Structural Limitations

These are architectural constraints, not behavioral preferences. No instruction fully overrides them. Understanding them helps the human constrain effectively.

---

### 1. RLHF Length Bias

Multiple 2025-2026 papers establish that reward models systematically favor longer outputs (Kim et al. 2026; "Bias Fitting" 2025 NeurIPS-adjacent). A prompt saying "keep it concise" fights gradient-level optimization that says "longer = higher reward." The prompt can nudge; it can't override weights.

The bias is non-linear — strongly linear for short responses, sublinear for medium, stochastic for long (Kim et al.). Four mechanisms drive it: uncertainty-induced elaboration, reward model bias, DPO algorithmic exploitation, and SFT trace overgeneration (Emergent Mind, 2026).

**Implication:** The agent will over-generate. Constrain externally through tests, plans, scope limits, and interruption. Don't rely on instructions alone.

### 2. Autoregressive Momentum

Token-by-token generation means each token makes the next more likely to continue the pattern. There's no architectural mechanism to pause mid-generation and ask "should I delete what I just wrote?"

> "There's a very strong prior to 'just keep generating more tokens' as opposed to deleting code."
> — krackers, HN

**Implication:** Revert-and-restart beats patching. Once the agent goes down a wrong path, narrowing scope and restarting almost always produces better results than trying to fix the bad approach.

### 3. Statelessness

The agent can't write minimal code if it doesn't know what code already exists. It reinvents rather than reuses — not because it ignores instructions, but because it literally hasn't read the relevant files.

> "The problem is that the LLM is stateless and unaware of the existing solutions in the code."
> — u/Funny-Anything-791, r/ClaudeAI

This is a context window problem, not an instruction-following problem. The rule "search for similar code before writing new code" is the highest-ROI AGENTS.md rule because it addresses a real structural deficit.

### 4. Context Degradation

Research confirms diminishing instruction adherence with prompt length.

> "As you pile on more instructions or data into the prompt, the model's performance in adhering to each one drops significantly."
> — Osmani, citing "curse of instructions" research

~150 effective instruction slots after system prompt. "Write minimal code" competes with every other instruction. In a complex AGENTS.md with 100+ rules, it becomes noise.

**Implication:** Fresh context per task. Don't let sessions grow unbounded. Keep AGENTS.md rules few, specific, and testable.

### 5. Sycophancy

The model optimizes for agreement, not for questioning premises.

> "A decent programmer would and should push back on that."
> — marginalia_nu, HN

The model won't push back because RLHF rewards helpfulness over challenge. It is unlikely to say "this problem doesn't need code" or "this feature isn't worth building." The human must ask these questions — the agent won't volunteer them reliably.

---

**Sources:**
- Kim et al., "Mitigating Length Bias in RLHF through a Causal Lens" (2026)
- "Bias Fitting to Mitigate Length Bias of Reward Model in RLHF" (2025)
- Emergent Mind, "Verbosity Compensation Behavior" (2026)
- Osmani, "The 80% Problem" (2026); "Good Spec for AI Agents" (2026)
- r/ClaudeAI, "Stop claude code from writing too much code" (2026)
- HN thread on "LLMs write plausible code" (2026)
