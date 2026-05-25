# Citations & Follow-up Work: "Generalization on the Unseen, Logic Reasoning and Degree Curriculum" (ICML 2023)

Source: Abbe, Bengio, Lotfi, Rizk. arXiv:2301.13105. ICML 2023 Outstanding Paper. Expanded JMLR 2024 version (v25/24-0220).
Date: 2026-03-24

## Paper Recap

Studies learning of Boolean functions under **GOTU** (Generalization on the Unseen) — extreme OOD where test inputs have *zero overlap* with training support. Key results:
- Neural networks trained by (S)GD converge to a **min-degree interpolator (MDI)** — the interpolator with minimal Fourier mass on higher-degree basis elements.
- Proved for Transformers, random features, diagonal linear networks.
- Leaky MDI reached with larger learning rates / mean-field networks.
- **Implication 1**: Explains length generalization failures for Boolean functions.
- **Implication 2**: **Degree-Curriculum** algorithm — incrementally increasing monomial support to learn more efficiently.

---

## A. Direct Follow-up by Authors (Abbe, Lotfi et al.)

### 1. "How Far Can Transformers Reason? The Globality Barrier and Inductive Scratchpad" (NeurIPS 2024)
- **Authors**: Abbe, Lotfi et al.
- **Key idea**: Identifies a fundamental **globality barrier** — Transformers struggle with tasks requiring global reasoning across the full input because they learn local/shortcut solutions. Proposes **inductive scratchpads** as a mitigation: intermediate computation steps that decompose global reasoning into local steps.
- **Result**: Up to 6× length generalization on arithmetic tasks with proper scratchpad formatting.
- **Connection to GOTU**: Directly extends the MDI insight — shallow Transformers default to low-degree (local) solutions, which is exactly the MDI bias. The scratchpad is a practical workaround for the MDI's inability to capture high-degree structure.
- https://openreview.net/forum?id=FoGwiFXzuN

### 2. "On Provable Length and Compositional Generalization" (ICLR 2025)
- **Authors**: Abbe, Lotfi et al.
- **Key idea**: First **provable guarantees** on length generalization and compositional generalization for deep sets, Transformers, SSMs, and RNNs trained to minimize prediction error. Formalizes conditions under which these architectures can generalize to longer and compositionally novel sequences.
- **Connection to GOTU**: Directly extends the GOTU theoretical framework from Boolean functions to sequence-to-sequence models. Moves from "what is learned on unseen" to "when can we provably guarantee generalization on longer/novel compositions."
- https://openreview.net/forum?id=Hxm0hOxph2

### 3. "Transformers Learn Shortcuts to Automata" (ICLR 2023)
- **Authors**: Abbe, Bengio, Lotfi et al.
- **Key idea**: Transformers simulate automata via O(log T) or O(1)-depth **shortcuts** rather than learning the recurrent algorithm. Characterizes these shortcuts algebraically via transformation semigroups. Shows these solutions are **brittle** — they break on distribution shifts.
- **Connection to GOTU**: The MDI bias from GOTU manifests here as shortcut learning — the network finds the lowest-complexity solution that fits training data, which may not generalize. This is the *mechanism* behind the MDI.
- https://openreview.net/forum?id=De4FYqjFueZ

### 4. "Learning to Reason with Neural Networks: Generalization, Unseen Data and Boolean Measures" (earlier companion, NeurIPS 2022)
- **Authors**: Abbe et al.
- **Key idea**: Predecessor showing that generalization error on Boolean functions learned by GD on symmetric networks is lower-bounded by the **noise-stability** of the target function. Established the theoretical foundation that GOTU built upon.
- https://machinelearning.apple.com/research/generalization-unseen-data-boolean

### 5. "General Intelligence Requires Reward-based Pretraining" (2025)
- **Authors**: Abbe et al. (arxiv:2502.19402, title updated from "General Reasoning Requires Learning to Reason from the Get-go")
- **Key idea**: Argues that LLMs exhibit "artificial useful intelligence" but not general reasoning. Proposes that **reasoning must be built into pretraining** via reward-based objectives, not bolted on via fine-tuning. Suggests coupling a reasoning system with retrieval + external memory.
- **Connection to GOTU**: Extends the GOTU insight to its logical conclusion — if networks default to MDI/shortcut solutions, then post-hoc reasoning training can't overcome this fundamental bias. Reasoning architecture must be baked in from the start.
- https://arxiv.org/abs/2502.19402

### 6. "Tool-Use Unlocks Length Generalization in State Space Models" (2025)
- **Authors**: Lotfi et al.
- **Key idea**: SSMs (Mamba etc.) have fixed-size memory, which fundamentally limits length generalization. Proposes tool-use as a mechanism to overcome this — the model learns to offload computation to external tools, breaking the memory bottleneck.
- **Connection to GOTU**: The MDI/low-degree bias exists partly because of architectural constraints. Tool-use is a practical escape hatch.
- https://arxiv.org/html/2510.14826v1

---

## B. Key Citing Works (Theory)

### 7. "What Algorithms Can Transformers Learn? A Study in Length Generalization" (ICLR 2024)
- **Authors**: Zhou, Bradley, Littwin, Razin, Saremi, Susskind, Bengio, Nakkiran
- **Key idea**: Proposes the **RASP-Generalization Conjecture** — Transformers length-generalize when the task admits a short RASP-L program. **Explicitly critiques MDI**: gives an example where the MDI model from Abbe et al. does *not* correctly predict Transformer OOD behavior, but RASP-simplicity does.
- **Significance**: Important counterpoint — MDI captures implicit bias of gradient descent, but RASP-simplicity better captures when Transformers actually generalize. Suggests the MDI is a *lower bound* on what Transformers learn, not the full story.
- https://arxiv.org/abs/2310.16028

### 8. "Quantitative Bounds for Length Generalization in Transformers" (2025)
- Formal quantitative bounds on when length generalization succeeds/fails in Transformers. Builds on the GOTU framework to give tighter, architecture-specific guarantees.
- https://arxiv.org/html/2510.27015v1

### 9. "Provable CoT Learning in Transformers" (2025)
- Characterizes length generalization through **attention concentration** mechanism. Links retrieval robustness of attention to state-tracking tasks. Provides theoretical grounding for why chain-of-thought helps with length generalization (connects to scratchpad work).
- https://arxiv.org/abs/2511.07378

### 10. "Learning Boolean Functions with Neural Networks" (ICLR 2024)
- Extends the Boolean function learnability theory. Shows GD can learn despite non-convexity, providing tighter analysis of which Boolean function classes are learnable and how the Fourier spectrum structure determines learnability.
- https://openreview.net/forum?id=LEuuOaZNOT

### 11. "Model Successor Functions" (2025)
- Formalizes **inductive generalization** (length/logical/algorithmic extrapolation) through the concept of **model successors** — a model that can predict the next-harder instance. Provides a unified framework for the many flavors of extrapolation studied in GOTU and subsequent work.
- https://arxiv.org/html/2502.00197v1

---

## C. Key Citing Works (Practical / LLM-facing)

### 12. "Empower Nested Boolean Logic via Self-Supervised Curriculum Learning" (CLR, 2023)
- Proposes **Curriculum Logical Reasoning (CLR)** — a self-supervised method that trains LMs on nested Boolean logic chains with step-by-step difficulty progression. Directly implements the Degree-Curriculum idea from GOTU for language models.
- https://arxiv.org/html/2310.05450v1

### 13. "Unleashing LLM Reasoning with Rule-Based Reinforcement Learning" (2025)
- Trains a 7B model on just **5K logic problems** using rule-based RL. The model develops reflection, verification, and summarization skills *absent from the training corpus*. Generalizes to AIME/AMC math benchmarks.
- **Connection**: Validates the GOTU principle that learning logical structure transfers — low-degree logical reasoning learned via curriculum can generalize far beyond the training distribution.
- https://arxiv.org/html/2502.14768v1

### 14. "Automated Distribution-Level Curriculum Learning for RL-based LLM Post-training" (2025)
- Principled curriculum framework using **distribution-level learnability** — the magnitude of policy advantages indicates how much a model can benefit from further training on a given distribution. Automates the difficulty scheduling that Degree-Curriculum does manually.
- https://arxiv.org/html/2504.09710v1

### 15. "What Makes a Good Curriculum? Disentangling the Effects of Data Ordering on LLM Mathematical Reasoning" (2025)
- Systematic study of when curriculum learning helps LLM reasoning. Disentangles difficulty metrics and training setups. Asks: when does easy-to-hard ordering actually help?
- https://arxiv.org/html/2510.19099v1

### 16. "Problem-Solving Logic Guided Curriculum In-Context Learning for LLMs Complex Reasoning" (2025)
- Applies curriculum ideas to **in-context learning** — ordering demonstration examples from simple to complex improves ICL reasoning. Shows the Degree-Curriculum principle applies even without weight updates.
- https://arxiv.org/html/2502.15401

### 17. "Self-Supervised Transformers that Think Past Their Training for Length Extrapolation" (2025)
- Directly tackles length extrapolation for algorithmic reasoning and multi-step arithmetic. Self-supervised approach to train Transformers that maintain accuracy beyond training sequence lengths.
- https://arxiv.org/html/2506.00920v1

### 18. "Length-based Overfitting of Elementary Functions in Transformers" (2024)
- Shows Transformers overfit to training sequence lengths. Generalization to shorter sequences is possible, but longer sequences are "highly problematic" with only partial correctness. Empirical validation of the GOTU-predicted MDI behavior.
- https://arxiv.org/html/2410.13802v1

### 19. "On Logical Extrapolation for Mazes with Recurrent and Implicit Networks" (2025)
- Studies logical extrapolation (train-easy, test-hard) for maze-solving. Shows recurrent/implicit networks learn scalable iterative algorithms that converge to solutions — an alternative architecture that avoids the MDI trap.
- https://arxiv.org/html/2410.03020v2

---

## D. Research Trajectory & Open Questions

### Theoretical frontier
1. **MDI vs. RASP-simplicity debate**: MDI captures SGD's implicit bias; RASP captures what's expressible by Transformers. When do they diverge, and which better predicts real LLM behavior? (Zhou et al. 2024 vs. Abbe et al. 2023)
2. **Beyond Boolean**: GOTU studied Boolean functions. Extending to continuous/structured domains (graphs, programs, natural language) is the major open direction. Abbe's 2025 work on reward-based pretraining gestures at this.
3. **Architecture-specific MDI characterization**: Different architectures (SSMs, RNNs, Transformers) have different implicit biases. The provable guarantees paper (ICLR 2025) starts this but much remains open.
4. **Fourier analysis for token sequences**: Can the Boolean Fourier framework be lifted to work on natural language tokens? Would give a formal handle on "complexity" of linguistic reasoning.

### Practical frontier
1. **Degree-Curriculum at scale**: The original Degree-Curriculum was for synthetic Boolean tasks. The practical implementations (CLR, automated distribution-level CL, logic-guided ICL) show it transfers to LLMs, but principled difficulty metrics for real tasks remain ad hoc.
2. **Scratchpads/CoT as MDI escape**: The globality barrier + inductive scratchpad work shows that intermediate computation steps let models overcome MDI limitations. This connects directly to why CoT/o1-style reasoning works — it decomposes high-degree targets into sequences of low-degree steps.
3. **Tool-use as architectural bypass**: When the MDI bias is fundamental to the architecture, tool-use (calculators, code interpreters) lets models offload the high-degree computation they can't learn.
4. **RL for reasoning**: The 5K-logic-problems result suggests that curriculum + RL on small logical tasks may be a surprisingly efficient way to build reasoning capabilities that transfer to math/code.

### Key insight chain
```
GOTU (2023): Networks learn MDI on unseen data
    → Shortcuts to Automata (2023): MDI = shortcut solutions, which are brittle
    → Globality Barrier (2024): The barrier is fundamental; scratchpads help
    → Provable Guarantees (2025): Conditions for when generalization IS possible
    → General Reasoning (2025): Reasoning must be in pretraining, not fine-tuning
```
