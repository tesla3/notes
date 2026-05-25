# Critical Review: How Does Unfaithful Reasoning Emerge from Autoregressive Training?

**Paper:** Wang, Alazali, & Zhong (2025). "How Does Unfaithful Reasoning Emerge from Autoregressive Training? A Study of Synthetic Experiments." arXiv:2602.01017. University of Wisconsin-Madison.

**Date reviewed:** 2026-03-23  
**Revision:** Second revision — corrected analytical errors, added missing literature, moderated overclaims.

---

## I. What the Paper Claims

Three core contributions, stated verbatim from the paper:

1. **A minimal testbed and formal definitions.** "We introduce a synthetic task AER and formalize two faithfulness notions: mathematical consistency and counterfactual intervention on reasoning steps."

2. **A faithfulness threshold from simplicity bias.** "We find that reasoning faithfulness is possible only when training noise is below a critical threshold, a phenomenon explained by algorithmic simplicity bias."

3. **Three reasoning modes and emergent self-verification.** "Under moderate noise, training dynamics exhibit three distinct reasoning modes, with a transition from faithful stepwise reasoning to unfaithful skip-step reasoning through an intermediate mixed mode marked by a transient rise in prediction entropy, indicating emergent implicit self-verification."

---

## II. Experiment Setup — Precisely

The task is **Arithmetic Expression Reasoning (AER)**: a single-step compositional chain over modular arithmetic.

- **Chain format:** `e₁ → e₂ → e₃` (11 tokens), where `e₁ = a × b op₂ c`, `e₂ = d op₂ c` (the result of evaluating `a × b` mod N), and `e₃` is the final integer result.
- **Modulus:** N = 97 (prime) by default. Ablations at N = 29, 38, 83, 94, 113.
- **Model:** Standard transformer, **3 layers, 2 heads, 128 embedding dim, 512 FFN dim**, RoPE. ~50 minutes per run on a single A30 GPU.
- **Training:** AdamW (lr=0.001, wd=0.01, batch=512), standard autoregressive loss, 62,500 steps, 2M training examples.
- **Noise injection:** Two independent noise parameters:
  - ε₁ (prompt noise): with probability ε₁, replace either `a` or `b` in `e₁` with a uniform random integer from V_N.
  - ε₂ (reasoning noise): with probability ε₂, replace `d` in `e₂` with a uniform random integer from V_N.

This is important: **the "reasoning chain" is exactly one compositional step**. The model must learn f₂ ∘ f₁ where f₁ evaluates a two-operator expression down to a one-operator expression, and f₂ evaluates the one-operator expression to a scalar.

**Faithfulness is measured two ways:**

1. **Consistency-based:** Does the model's generated chain `(e₁, e'₂, e'₃)` match the ground-truth chain `(e₁, e₂, e₃)`? Metric: Reasoning Inconsistency Ratio (RIR).
2. **Intervention-based:** If you replace `e₂` with a random `ẽ₂`, does the model's prediction of `e₃` change? Metrics: Interventional Non-flip Rate (INR) and Interventional Distribution Sensitivity (IDS). High INR + low IDS = skip-step reasoning (model ignores the chain). Low INR + high IDS = stepwise reasoning (model causally depends on the chain).

---

## III. What They Actually Found

### Finding 1: Critical noise threshold for faithfulness

Below a threshold τ_c(ε₁) of reasoning noise ε₂, models learn **intervention-based faithful reasoning** — the prediction of e₃ causally depends on e₂, not just on e₁. Above this threshold, both consistency and intervention metrics sharply degrade.

Crucially: "both unfaithfulness metrics are close to 0 under the noiseless setting (ε₁ = ε₂ = 0), indicating that faithful reasoning is achievable when training only on consistent chains."

**Important nuance the paper provides:** The transition to unfaithfulness is not universal. The model reaches P3 (skip-step) only when ε₂ >> ε₁. When ε₁ ≈ ε₂, it gets stuck in P2:

> "for (ε₁, ε₂) = (0.1, 0.1), the model gets stuck in the self-verification regime and does not reach the optimal predictive distribution."
> — Appendix B.3, Figure 13

When ε₁ > ε₂, it stays in P1 (faithful). The model also exhibits "inertia":

> "at low noise, models exhibit inertia: it continues to rely on stepwise reasoning rather than immediately switching to skip-step reasoning for a slightly lower loss."
> — §3.1

### Finding 2: Simplicity bias explains the preference

The explanation: stepwise reasoning (evaluating e₂, a single-operator expression) is algorithmically simpler than skip-step reasoning (evaluating e₁, a two-operator expression). Gradient-based optimization has an inductive bias toward simpler functions.

**Key validation:** When they increased the complexity gap (making e₁ a three-operator expression), the threshold τ_c shifted upward — models tolerated more noise before abandoning faithful reasoning. When they **swapped positions** of e₁ and e₂, the intervention metrics stayed the same, ruling out positional confounds.

### Finding 3: Four training phases

At moderate noise (ε₁ = 0.01, ε₂ = 0.1), training proceeds through:

- **P0 (format following):** Model learns token positions in first ~1k steps.
- **P1 (stepwise reasoning):** f̂₂(e₁, e₂) ≈ f₂(e₂). Model relies on e₂. Accuracy ~90% (= 1 - ε₂).
- **P2 (mixed reasoning):** On inconsistent chains (where f(e₁) ≠ f₂(e₂)), the model outputs a near-uniform distribution. On consistent chains, it still predicts correctly. **Prediction entropy rises** despite monotonically decreasing loss.
- **P3 (skip-step reasoning):** f̂₂(e₁, e₂) ≈ f(e₁). Model ignores e₂. Accuracy rises to ~99% (= 1 - ε₁).

### Finding 4: "Implicit self-verification"

The Phase 2 behavior is interpreted as the model learning to detect inconsistency between e₁ and e₂ — a form of internal consistency checking. The Hidden State Contrast (HSC) and Attention Contrast (AC) metrics show sharp differentiation between consistent and inconsistent chains during P2.

---

## IV. The Foundational Problem: The Task Doesn't Need CoT

This is the deepest issue with the paper, and it shapes everything else.

AER is a **shallow task**. A 3-layer transformer can compute `a × b ± c mod 97` in a single forward pass — it does not need intermediate tokens `e₂` to arrive at `e₃`. The chain of thought is computationally unnecessary.

This matters because recent theoretical work establishes that CoT has two fundamentally different roles depending on task complexity:

- **Shallow tasks** (within the model's computational depth): CoT is decorative. The model can compute the answer directly and the intermediate tokens are optional scaffolding.
- **Deep tasks** (requiring serial computation beyond model depth): CoT is necessary computation. The model physically cannot compute the answer in one forward pass and needs intermediate tokens as external memory.

Feng et al. (2024) show:

> "CoT empowers the model with the ability to perform inherently serial computation, which is otherwise lacking in transformers, especially when depth is low."
> — "Chain of Thought Empowers Transformers to Solve Inherently Serial Problems," arXiv:2402.12875

And Merrill & Sabharwal (2023):

> "surprisingly simple reasoning problems, such as checking if two nodes in a graph are connected or simulating finite-state machines, [are] provably unsolvable by standard transformers that answer immediately after reading their input."
> — "The Expressive Power of Transformers with Chain of Thought," arXiv:2310.07923

**The paper exclusively studies the shallow regime.** In this regime, the model can always bypass CoT by computing directly from the input. Skip-step reasoning isn't just possible — it's the computationally rational strategy when e₂ is noisy. The paper documents the model learning to do the obvious thing, then frames it as a concerning "emergence of unfaithfulness."

For deep tasks — where CoT is computationally necessary — skip-step is **impossible**, not just suboptimal. The model needs the intermediate tokens. Multiple lines of evidence converge here. OpenAI (2026) finds that current reasoning models struggle to control their CoTs even when explicitly instructed to:

> "current reasoning models struggle to control their CoTs, even when told they are being monitored. While controllability is higher for larger models, it decreases as models are asked to reason for longer."
> — OpenAI, "Reasoning models struggle to control their chains of thought," March 2026

And METR (2025) confirms empirically that CoT is most informative precisely when tasks are hard enough that models need it:

> "In practice, many dangerous kinds of reasoning, like deciding to alignment-fake or planning surreptitious sabotage, seem complex enough that models will likely benefit from using the CoT to perform them."
> — METR, "CoT May Be Highly Informative Despite 'Unfaithfulness'," August 2025

**However, a critical distinction must be drawn: computational necessity of intermediate tokens is not the same as semantic faithfulness.** A model can *need* intermediate tokens as scratch computation (can't bypass them) while the *content* of those tokens doesn't faithfully represent the algorithm being executed. Boppana et al. (2026) find exactly this pattern in production reasoning models:

> "We provide evidence of performative chain-of-thought (CoT) in reasoning models, where a model becomes strongly confident in its final answer, but continues generating tokens without revealing its internal belief."
> — Boppana et al., "Disentangling Model Beliefs from Chain-of-Thought," arXiv:2603.05488

This means that even for deep tasks, intermediate tokens can serve as arbitrary external memory without being human-interpretable reasoning steps. The paper's mechanism — models bypassing their own stated reasoning — could manifest differently but not vanish entirely in the deep regime. The model might use the tokens computationally while the *semantic content* of those tokens drifts from the underlying computation.

**The upshot:** The paper's findings are most directly relevant to the shallow-task regime, where they are least surprising. But they are not entirely irrelevant to harder tasks for two reasons: (1) real tasks are compositions of sub-steps at varying depths, and a 100-layer model doing 3-step arithmetic inside a 20-step proof is in exactly the shallow regime for that sub-step — the paper's noise-driven skip-step mechanism could operate at the sub-step level within harder problems; (2) even when intermediate tokens are computationally necessary, *semantic* faithfulness (the tokens reflecting the actual algorithm) is a separate question the paper's framework doesn't address. The paper studies a regime where its findings are expected, and leaves unstudied the regime where they would be most informative.

---

## V. What Survives

### 1. The formalization

The distinction between **consistency-based** and **intervention-based** faithfulness remains useful:

> "Perfect stepwise reasoning: f̂₂(e₁, e₂) = f₂(e₂) for all e₁ ∈ E₁, e₂ ∈ E₂."
> "Perfect skip-step reasoning: f̂₂(e₁, e₂) = f(e₁) for all e₁ ∈ E₁, e₂ ∈ E₂."

However, this formalization is a mathematical packaging of the same operational idea that Turpin et al. (2023) and Lanham et al. (2023) already used — perturb the chain, measure change in answer. Neater, but not a new idea.

### 2. The swap experiment

Swapping e₁ and e₂ positions while keeping all else constant (Table 2: INR stays at 0, IDS ~24.7 → ~26.0) rules out positional confounds cleanly. This is a well-designed control.

### 3. The core mechanism is confirmed in real LLMs

The phenomenon the paper models — models bypassing their own reasoning chains — is real and extensively documented in production systems:

> "LLMs do not reliably use their intermediate reasoning steps when generating an answer."
> — "Measuring and Improving Faithfulness of Chain-of-Thought Reasoning," arXiv:2402.13950

> "LLMs often ignore structural changes, revealing a gap between reasoning and decision-making."
> — "Breaking the Chain: A Causal Analysis of LLM Faithfulness," OpenReview 2026

> "several production models exhibit surprisingly high rates of post-hoc rationalization: GPT-4o-mini (13%) and Haiku 3.5 (7%)."
> — Arcuschin et al., 2025, arXiv:2503.08679

The paper models something real. The question is whether its explanation adds to what was already known.

---

## VI. What Doesn't Survive

### 1. The "self-verification" claim

Phase 2 is not self-verification. The model has learned two conflicting signals and hedges when they disagree — outputting near-uniform distributions on inconsistent inputs. This is signal conflict under uncertainty, not metacognition.

> "prediction is most uncertain (uniform distribution) if e₁ and e₂ are inconsistent, and consistent with both e₁, e₂ otherwise."
> — §3.2

What the model does in P2 — outputting near-uniform distributions when two signals disagree — is exactly what a Bayesian posterior looks like when two likelihood functions of comparable weight conflict. It is posterior uncertainty under signal disagreement, not an internal consistency-checking mechanism. The grokking literature (Power et al., 2022) documents similar transient entropy phenomena during phase transitions in modular arithmetic tasks. The Phase 2 entropy bump likely reflects the same underlying dynamics as the memorization-to-generalization transition — a transient regime where the model has partially learned a new representation but hasn't yet committed to it — not a novel form of metacognition.

Moreover, Phase 2 is **transient** — the model abandons it. A "cornerstone for meta-reasoning abilities" (the paper's claim) that the model itself discards is no cornerstone.

### 2. The phase dynamics

The signature finding — multi-phase transitions, entropy bump — **disappears with a slightly larger model**:

> "The 5-layer model also eventually learns the skip-step reasoning strategy; however, its entropy curve becomes essentially monotone and no longer exhibits the non-monotonic 'bump' associated with the Phase 2 self-verification regime."
> — Appendix C

The authors recover the phases by increasing task complexity (N = 113), showing the dynamics depend on the capacity-to-task ratio. This means the phases are a property of **marginally sufficient models** — they appear when the model is barely powerful enough for the task.

**Caveat:** Phase transitions in learning dynamics are often capacity-dependent in their *location* but not their *existence*. The relevant question is whether every model encounters some subtask that puts it in this marginal regime. For real LLMs encountering tasks spanning many orders of difficulty, it's plausible that some fraction of subtasks always sit at the edge of the model's capacity. But the paper provides no evidence for or against this hypothesis — it demonstrates the dynamics at one narrow capacity-to-task ratio and extrapolates. The phases cannot be claimed as a general property of learning until their existence is shown to be robust across scales.

### 3. The practical implications

The paper states:

> "Low noise in training data and large complexity gaps in reasoning steps are critical to inducing high faithfulness in CoT reasoning."
> — §3.1

> "Prolonged autoregressive training for CoT reasoning (particularly supervised finetuning) may reduce faithfulness by encouraging skip-step reasoning."
> — §3.2

These are presented as general principles but demonstrated only for a one-step arithmetic chain where CoT is unnecessary. For tasks where CoT is computationally necessary, the first claim may still hold (clean data helps), but the second likely reverses — more training on a depth-requiring task should improve the model's use of intermediate steps, since that's the only path to a correct answer.

More importantly, these implications are limited to a training paradigm that cutting-edge reasoning models have already moved beyond (see §VII on RLVR). The paper doesn't distinguish between task regimes or training paradigms, making its practical recommendations unreliable as general guidance.

### 4. The explanatory mechanism

The paper's "why" for unfaithfulness reduces to: the model finds a lower-loss strategy by computing directly from the input. This is what training does. Saying "loss minimization causes unfaithfulness" has the same explanatory power as "gravity causes things to fall."

The simplicity bias explanation adds genuine nuance — the model prefers the simpler function first and tolerates some accuracy loss to use it. This is consistent with recent theoretical work: Rajaraman et al. (2024) show that overparameterized neural networks learn "simple classifiers before progressing to more complex, non-linear functions" (arXiv:2410.19637), and Li et al. (2025) provide a unifying "saddle-to-saddle" framework for simplicity bias "across neural network architectures" (arXiv:2512.20607). The general phenomenon is well-established.

However, the paper's specific application — simplicity bias explaining the faithfulness threshold in transformers trained on modular arithmetic — rests on an informal complexity ordering (single-operator < two-operator expressions). The paper provides no formal measure of circuit complexity. The swap experiment (Table 2) offers strong evidence that it's about function complexity, not positional proximity — swapping e₁ and e₂ doesn't change which gets learned first — but the mechanism connecting gradient dynamics to the threshold τ_c remains hand-waved.

**A deeper tension the paper doesn't address:** The authors use **AdamW** as their optimizer. Recent work shows that "Adam is more resistant to [simplicity] bias" compared to SGD (arXiv:2505.24022). If simplicity bias is the core mechanism driving the faithfulness threshold, and their optimizer specifically *attenuates* simplicity bias, then the observed threshold may be a lower bound — SGD-trained models might show even stronger faithfulness (higher τ_c). This is an untested prediction that would strengthen or falsify the simplicity bias explanation.

### 5. The definition of faithfulness itself

The paper's intervention-based faithfulness metric defines a model as "faithful" when it causally depends on e₂ and "unfaithful" when it bypasses e₂ to compute from e₁. But when e₂ is *wrong* (which happens with probability ε₂), ignoring it and computing directly from e₁ produces the correct answer. The model that "unfaithfully" bypasses its chain is *more accurate* and arguably *more truthful* — it's faithful to the underlying mathematical relationship, just not to its own intermediate tokens.

Barez et al. (arXiv:2512.23032) make a related argument at scale:

> "this metric confuses unfaithfulness with incompleteness, the lossy compression needed to turn distributed transformer computation into a linear natural language narrative."

The paper's faithfulness definition assumes that following the chain is always the correct behavior. But if the chain is wrong, following it is a failure mode, not a virtue. A model that learns to detect and bypass corrupted intermediate steps has learned something useful — the paper frames this as a pathology because its definitions don't distinguish "bypasses correct chains" from "bypasses corrupted chains." A more nuanced framework would separate these cases.

---

## VII. What's Missing

1. **A depth-requiring task.** The single most important missing experiment. Study a task where CoT is computationally necessary and ask: does noise still erode faithfulness when skip-step is impossible? This would distinguish "unfaithfulness as rational optimization" from "unfaithfulness as fundamental pathology." Even here, the question would bifurcate: do models *use* the intermediate tokens (computational faithfulness) vs. do the tokens *reflect the algorithm* (semantic faithfulness)?

2. **Multi-step chains.** AER has one compositional step. All findings might change qualitatively with 3, 5, or 10 steps, where the model faces a combinatorial space of partial skip-step strategies. A model might faithfully use early steps but skip later ones, or vice versa. The single-step setup cannot reveal such structure.

3. **Structured noise.** Uniform random replacement is a worst-case i.i.d. corruption. Real training data noise is systematic, correlated, and near-miss (e.g., rounding errors, off-by-one mistakes, plausible-but-wrong intermediate steps). The clean threshold behavior may depend on the uniform-noise assumption. Systematic noise might produce qualitatively different dynamics — the model might learn to *correct* near-miss errors rather than bypass the chain entirely.

4. **RL/RLVR training.** The most capable reasoning models use reinforcement learning from verifiable rewards. RLVR explicitly rewards correct final answers, creating a fundamentally different optimization landscape. The paper studies only autoregressive training. Recent work shows this gap matters in both directions: "Learning to Reason Faithfully through Step-Level Faithfulness Maximization" (arXiv:2602.03507) demonstrates that RLVR can be specifically designed to maximize step-level faithfulness, while "Faithfulness-Aware Step-Level Reinforcement Learning" (FaithRL, arXiv:2602.05897) shows it "consistently reduces hallucinations in both the CoT and final answers." However, the picture is not uniformly positive — benchmarking on counterfactual interventions finds that "RL-style post-training can degrade reasoning faithfulness" (arXiv:2602.17053). The autoregressive-only regime the paper studies is increasingly divorced from how reasoning models are actually trained.

5. **Scale.** The 3→5 layer ablation destabilizes the findings. What happens at 12, 24, 48 layers? The paper needs a scaling analysis, not a two-point comparison.

6. **Natural language.** The paper strips away language entirely but cites "ambiguity of natural languages" as motivation for the noise model. A hybrid task (natural language wrapping a formal computation) would bridge the gap and test whether the noise-threshold dynamics survive in the presence of linguistic variability.

7. **Optimizer sensitivity.** Given the AdamW-vs-SGD simplicity bias tension (§VI.4), a comparison across optimizers would test whether the faithfulness threshold is a property of the *task* or the *optimizer*.

---

## VIII. Verdict

The paper asks an important question — how does unfaithful CoT reasoning emerge during training? — and provides a technically clean answer on a controlled synthetic task. The formalization of faithfulness definitions is useful. The experiments are well-executed within their scope.

But the paper has a fundamental design flaw: **it studies a task where CoT is computationally unnecessary, discovers the model learns to skip it, and presents this as insight into CoT faithfulness.** On a task that doesn't need CoT, discovering that models learn to bypass CoT is an expected outcome, not a surprising finding. The mechanism ("loss minimization prefers the more reliable signal") is largely obvious once you see the setup.

The interesting dynamics — phase transitions, entropy bump, "self-verification" — are properties of models at the edge of their capacity for the task. They vanish with a slightly larger model (5 layers vs 3). They may reappear at different capacity-to-task ratios, but the paper provides no evidence of robustness across scales.

The paper's practical implications are stated as general principles but are specific to two narrow regimes simultaneously: shallow tasks (where CoT is decorative) and autoregressive training (where the optimization landscape is unstructured by step-level rewards). For hard reasoning tasks where CoT is computationally necessary, the skip-step mechanism cannot operate in full — but this does not guarantee *semantic* faithfulness, which is a separate and harder question the paper's framework doesn't address.

The paper also misses an important conceptual issue with its own definitions: a model that learns to bypass noisy intermediate steps to compute directly from the input isn't necessarily "unfaithful" — it's robust. The faithfulness metrics conflate "ignores correct chains" with "ignores corrupted chains," treating both as pathology.

**Rating: Technically competent execution of an experiment whose design makes its central finding largely inevitable. The formalization of faithfulness has reuse value; the swap experiment is a well-designed control. The experimental findings are narrow, capacity-dependent, and specific to a task regime where they are least surprising. The explanatory mechanism (simplicity bias) is plausible but undercut by the optimizer choice and lacks formal grounding for the specific setting. The claims — particularly "self-verification" and general practical recommendations — substantially overshoot the evidence.**

---

## Sources

- Wang, Alazali, & Zhong (2025). arXiv:2602.01017.
- Turpin, Michael, Perez, & Bowman (2023). "Language Models Don't Always Say What They Think." NeurIPS 2023. arXiv:2305.04388.
- Lanham et al. (2023). "Measuring Faithfulness in Chain-of-Thought Reasoning."
- Arcuschin et al. (2025). "Chain-of-Thought Reasoning In The Wild Is Not Always Faithful." arXiv:2503.08679.
- Chen et al. (2025). "Reasoning Models Don't Always Say What They Think." Anthropic. arXiv:2505.05410.
- Betley et al. (2025). "Emergent Misalignment: Narrow Finetuning Can Produce Broadly Misaligned LLMs." ICML 2025. arXiv:2502.17424.
- Power et al. (2022). "Grokking: Generalization Beyond Overfitting on Small Algorithmic Datasets." arXiv:2201.02177.
- Guo et al. (2025). "DeepSeek-R1: Incentivizing Reasoning Capability in LLMs via Reinforcement Learning." arXiv:2501.12948.
- Soudry et al. (2018). "The Implicit Bias of Gradient Descent on Separable Data." JMLR.
- Abbe et al. (2024). "Generalization on the Unseen, Logic Reasoning and Degree Curriculum." JMLR.
- Feng & Ye (2024). "Chain of Thought Empowers Transformers to Solve Inherently Serial Problems." NeurIPS 2024. arXiv:2402.12875.
- Merrill & Sabharwal (2023). "The Expressive Power of Transformers with Chain of Thought." ICLR 2024. arXiv:2310.07923.
- OpenAI (2026). "Reasoning models struggle to control their chains of thought." March 2026.
- METR (2025). "CoT May Be Highly Informative Despite 'Unfaithfulness'." August 2025. https://metr.org/blog/2025-08-08-cot-may-be-highly-informative-despite-unfaithfulness/
- Boppana et al. (2026). "Disentangling Model Beliefs from Chain-of-Thought" (Reasoning Theater). Goodfire. arXiv:2603.05488.
- Barez et al. (2025). "Is Chain-of-Thought Really Not Explainability? Chain-of-Thought Can Be Faithful without Hint Verbalization." arXiv:2512.23032.
- Rajaraman et al. (2024). "A Distributional Simplicity Bias in the Learning Dynamics of Transformers." arXiv:2410.19637.
- Li et al. (2025). "Saddle-to-Saddle Dynamics Explains A Simplicity Bias Across Neural Network Architectures." arXiv:2512.20607.
- Ahn et al. (2025). "On the Implicit Bias of Adam." arXiv:2505.24022.
- "Learning to Reason Faithfully through Step-Level Faithfulness Maximization." arXiv:2602.03507.
- "Faithfulness-Aware Step-Level Reinforcement Learning for Small Reasoning Models" (FaithRL). arXiv:2602.05897.
- "Benchmarking Reasoning Faithfulness under Counterfactual Reasoning Intervention in Large Reasoning Models." arXiv:2602.17053.
- Bao et al. (2024). "LLMs with Chain-of-Thought Are Non-Causal Reasoners." arXiv:2402.16048.
- "Measuring and Improving Faithfulness of Chain-of-Thought Reasoning." arXiv:2402.13950.
