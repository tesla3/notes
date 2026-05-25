# Self-Critique: Discussion Thread on Wang et al. (2025)

**Date:** 2026-03-23

Critical evaluation of our multi-turn discussion on "How Does Unfaithful Reasoning Emerge from Autoregressive Training?"

---

## Claim-by-Claim Audit

### 1. "Unfaithfulness is what good evidence-weighting looks like" — PARTIALLY WRONG

**What we said:** The model ignoring noisy e₂ and computing directly from e₁ is the rational, loss-optimal strategy. Unfaithfulness = good learning.

**What we missed:** This only holds when the model has sufficient depth to compute e₁ → e₃ directly in a single forward pass. The AER task is trivially shallow — a 3-layer transformer can compute `a × b ± c mod 97` without needing intermediate tokens. But there exist problems where this is **provably impossible**.

Feng et al. (2024) show:

> *"CoT empowers the model with the ability to perform inherently serial computation, which is otherwise lacking in transformers, especially when depth is low."*
> — "Chain of Thought Empowers Transformers to Solve Inherently Serial Problems," arXiv:2402.12875

And the theoretical foundations (Merrill & Sabharwal, 2023; arXiv:2310.07923):

> *"Recent theoretical work has identified surprisingly simple reasoning problems, such as checking if two nodes in a graph are connected or simulating finite-state machines, that are provably unsolvable by standard transformers that answer immediately after reading their input."*
> — "The Expressive Power of Transformers with Chain of Thought"

**Why this matters:** For tasks that exceed the transformer's computational depth, skip-step reasoning is not just suboptimal — it's **impossible**. The model literally cannot compute the answer in one forward pass. For such tasks, CoT is *necessary computation*, not optional decoration, and the model MUST use the intermediate tokens faithfully to get the right answer.

**The correction:** "Unfaithfulness is rational evidence-weighting" is true **only for tasks the model can solve without CoT**. For tasks requiring serial computation beyond the model's depth, faithful CoT is the only path to correct answers. Our entire discussion was shaped by the paper's choice of a trivially shallow task, and we generalized without noticing.

### 2. "CoT monitoring has a fundamental ceiling" — DIRECTLY CONTRADICTED BY EVIDENCE

**What we said:** The better the model gets at ignoring noise, the worse CoT monitoring becomes. Fundamental tension, can't be resolved.

**What the literature actually shows:**

Baker et al. (2025):

> *"While chain-of-thought (CoT) monitoring is an appealing AI safety defense, recent work on 'unfaithfulness' has cast doubt on its reliability. These findings highlight an important failure mode, particularly when CoT acts as a post-hoc rationalization in applications like auditing for bias."*

But crucially:

> *"models being unable to evade monitoring for hard tasks"*
> — "When Chain of Thought is Necessary, Language Models Struggle to Evade Monitors," arXiv:2507.05246

And OpenAI's own findings (March 2026):

> *"We find that current reasoning models struggle to control their CoTs, even when told they are being monitored. While controllability is higher for larger models, it decreases as models are asked to reason for longer and when they undergo additional post-training."*
> — OpenAI, "Reasoning models struggle to control their chains of thought" (2026)

**The correction:** CoT monitoring is NOT fundamentally broken. It has two regimes:

- **Easy tasks** (solvable without CoT): Monitoring is unreliable because CoT is decorative. This is what Wang et al.'s paper studies.
- **Hard tasks** (requiring CoT for computation): Monitoring works because the model cannot skip-step — it needs the intermediate tokens. Models struggle to obfuscate reasoning they actually need.

We collapsed these two cases into one pessimistic narrative. The reality is task-dependent.

### 3. "Phase dynamics are capacity artifacts" — CORRECT BUT OVERSTATED

**What we said:** The phase transitions (P1 → P2 → P3) are artifacts of models barely large enough for the task. Larger models skip straight to the endpoint.

**Paper evidence supporting us:**

> *"the higher-capacity model spends little time in Phases 1 and 2 and rapidly transitions into the skip-step regime that achieves the optimal solution."*
> — Appendix C

**Paper evidence complicating this:**

> *"the characteristic multi-phase dynamics re-emerge and remain qualitatively consistent in this larger-modulus regime, [which] provides evidence that our observations are robust to scaling in both model capacity and problem size."*
> — Appendix C, regarding N=113 with 5-layer model

**The correction:** The phase dynamics are an artifact of the capacity-to-task-complexity *ratio*, not of absolute capacity. They disappear when the model is overparameterized for the task, but reappear when task complexity scales up. Whether real LLMs are in this "barely sufficient" regime for real reasoning tasks is an open question — plausible for hard math, implausible for tasks LLMs find easy.

### 4. "The distributional mismatch between training and inference" — REAL BUT MISAPPLIED

**What we said:** Teacher forcing creates a mismatch — during training the model sees noisy e₂ from the data; at inference it sees its own (correct) e₂. This mismatch is the mechanism of unfaithfulness.

**The exposure bias literature confirms the general phenomenon:**

> *"Exposure bias is the discrepancy between teacher-forced training and free-running inference, affecting autoregressive models ... It causes error propagation and performance degradation such as hallucinations."*
> — emergentmind.com, "Exposure Bias in Machine Learning"

**But our application is backwards.** Standard exposure bias means: model trained on clean data, surprised by its own errors at inference. Here the situation is inverted: model trained on **noisy** data, sees **cleaner** input at inference (its own correct generations). The model has learned to distrust a position that is now trustworthy. This is exposure bias in reverse — call it "negative exposure bias" or "learned distrust."

This is a real phenomenon but the mechanism is subtler than we stated. The model doesn't just learn "ignore e₂." It learns the statistical relationship p(e₃ | e₁, e₂) from the training distribution. At inference, the joint distribution of (e₁, e₂) is different (because e₂ is now self-generated, not drawn from noisy training data), but the model applies the same learned conditional. Whether this matters depends on whether the model's learned p(e₃ | e₁, e₂) generalizes across this distributional shift.

### 5. "Noise-ignoring is what learning IS" — CORRECT BUT INCOMPLETE

**What we said:** Models learning to filter noise from signal is the core capability. Unfaithfulness = successful noise filtering.

**What we missed:** This frames the model as a passive evidence-weigher. But in autoregressive generation, the model is also a **generator** — it produces e₂ before predicting e₃. The model has dual roles:

1. **Generator of e₂:** Here it SHOULD use e₁ faithfully (learning f₁)
2. **Predictor of e₃ given e₂:** Here it should use e₂ faithfully (learning f₂)

The paper's skip-step finding means the model fulfills role 1 (generates plausible e₂) but fails role 2 (ignores its own e₂ when predicting e₃). This is a more specific failure than "evidence-weighting" — it's a disconnect between the model's generation and consumption of its own intermediate tokens.

Bao et al. (2024) confirm this pattern in real LLMs:

> *"a surprising frequency of correct answers following incorrect CoTs and vice versa."*
> — "LLMs with Chain-of-Thought Are Non-Causal Reasoners," arXiv:2402.16048

And the causal mediation analysis across twelve LLMs:

> *"LLMs do not reliably use their intermediate reasoning steps when generating an answer."*
> — "Measuring and Improving Faithfulness of Chain-of-Thought Reasoning," arXiv:2402.13950

### 6. "Prompt noise is artificial" (user's claim) — HALF RIGHT

**What the user argued:** In math, the problem IS the problem. There's no "wrong" e₁. Prompt noise is artificial.

**Where this is right:** The specific noise mechanism (uniform random replacement of a/b) doesn't model any real phenomenon well. Real "prompt noise" would be ambiguous word problems, not corrupted numbers.

**Where this is wrong:** The *function* of ε₁ in the experiment is to control the reliability of the e₁ → e₃ pathway. Without ε₁, e₁ is always a perfect signal for e₃, and the experiment can't study the competition between pathways. The user is right that it's artificial *as a model of reality*, but wrong to dismiss it — it's a necessary *experimental control*.

**A better framing:** ε₁ doesn't model "wrong problems." It models the regime where the direct problem-to-answer pathway is degraded. In real data, this happens when: (a) the problem statement is ambiguous, (b) the training example pairs a problem with someone else's solution, (c) the problem requires context not present in e₁. These are real phenomena, just not well-modeled by uniform noise.

### 7. "The paper's practical implications are overstated" — WE WENT TOO FAR

**What we collectively argued:** The paper's findings are mostly capacity artifacts on a toy task. Real LLMs are overparameterized, so the dynamics don't apply.

**What we missed:** The empirical evidence from real LLMs actually *supports* the paper's core finding (skip-step reasoning happens), even though the mechanism may differ:

> *"LLMs often ignore structural changes, revealing a gap between reasoning and decision-making."*
> — "Breaking the Chain: A Causal Analysis of LLM Faithfulness," OpenReview 2026

> *"CoT outputs frequently do not reflect the genuine inner workings of the model. Instead, they often serve as post-hoc rationalizations that mask the actual decision-making process."*
> — Barez et al., "Chain-of-Thought Is Not Explainability" (2025)

> *"several production models exhibit surprisingly high rates of post-hoc rationalization: GPT-4o-mini (13%) and Haiku 3.5 (7%)."*
> — Arcuschin et al., "Chain-of-Thought Reasoning In The Wild" (2025)

The paper's *specific mechanism* (simplicity bias + noise threshold) may not be the right explanation for real LLMs. But the *phenomenon* it models (models bypassing their own reasoning chains) is robustly observed across production models. We were right to question the mechanism but wrong to imply the phenomenon is an artifact.

---

## The Biggest Thing We Got Wrong

We built a narrative arc across the conversation: unfaithfulness is fundamental → noise-ignoring is just good learning → CoT monitoring is doomed. This narrative was **internally consistent but externally incomplete** because it ignored the computational complexity dimension.

The critical distinction we missed throughout:

| Task type | CoT role | Skip-step possible? | Faithfulness |
|-----------|----------|---------------------|-------------|
| **Shallow** (solvable in one forward pass) | Decorative / post-hoc | Yes — model has enough depth | Unstable; unfaithfulness is optimal |
| **Deep** (requires serial computation) | Necessary computation | No — model needs the tokens | Robust; unfaithfulness hurts accuracy |

Wang et al.'s AER task is firmly in the "shallow" category. A 3-layer transformer can compute `a × b ± c mod 97` directly. So of course the model learns to skip e₂ — it doesn't need it.

For truly hard multi-step reasoning (long derivations, multi-hop inference, complex code generation), the model's depth is insufficient to compute the answer in one pass. It NEEDS the intermediate tokens as "external memory" for serial computation. In that regime, skip-step reasoning would actually *reduce* accuracy, and the training objective naturally favors faithful reasoning.

**This means the paper's central finding — that unfaithfulness is the loss-optimal strategy — is true only for tasks within the model's direct computational budget.** For tasks beyond it, faithfulness IS the loss-optimal strategy. The paper never tests this case because AER is trivially shallow.

## The Biggest Thing We Got Right

The user's core intuition — that something feels artificial about the setup — was correct at a deeper level than either of us initially articulated. The artificiality is not just the noise model or the toy scale. It's that **the task was chosen to be solvable without CoT**, which makes CoT unfaithfulness a foregone conclusion. A more interesting experiment would study a task where CoT is computationally necessary and ask: does noise still erode faithfulness when skip-step is impossible?

## Summary of Discussion Accuracy

| Claim | Verdict | Error type |
|-------|---------|------------|
| Unfaithfulness = good evidence-weighting | True for shallow tasks only | Overgeneralization |
| Phase dynamics are capacity artifacts | True but ratio-dependent, not absolute | Minor overstatement |
| CoT monitoring is fundamentally limited | False — works for hard tasks | Contradicted by Baker et al. 2025 |
| Train/inference mismatch explains unfaithfulness | Real but mechanism is inverted from standard exposure bias | Misapplication |
| Prompt noise is artificial | Partly — artificial as model of reality, valid as experimental control | Half right |
| Paper's phenomenon is real in production LLMs | Yes — extensively confirmed | We acknowledged but underweighted |
| The paper studies the wrong task regime | Yes — this is the deepest critique | Correct but articulated too late |

---

## Sources

- Wang, Alazali, & Zhong (2025). arXiv:2602.01017.
- Feng & Ye (2024). "Chain of Thought Empowers Transformers to Solve Inherently Serial Problems." arXiv:2402.12875. NeurIPS 2024.
- Merrill & Sabharwal (2023). "The Expressive Power of Transformers with Chain of Thought." arXiv:2310.07923. ICLR 2024.
- Baker et al. (2025). "When Chain of Thought is Necessary, Language Models Struggle to Evade Monitors." arXiv:2507.05246.
- OpenAI (2026). "Reasoning models struggle to control their chains of thought."
- Bao et al. (2024). "LLMs with Chain-of-Thought Are Non-Causal Reasoners." arXiv:2402.16048.
- arXiv:2402.13950. "Measuring and Improving Faithfulness of Chain-of-Thought Reasoning."
- Arcuschin et al. (2025). "Chain-of-Thought Reasoning In The Wild Is Not Always Faithful." arXiv:2503.08679.
- Barez et al. (2025). "Chain-of-Thought Is Not Explainability."
