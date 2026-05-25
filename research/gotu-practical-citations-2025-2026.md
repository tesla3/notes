# Practical Papers Citing GOTU (Abbe et al., ICML 2023) — Most Recent & Interesting

Source: Semantic Scholar citations of arxiv:2301.13105, filtered for practical relevance.
Date: 2026-03-24

---

## 1. Learning from Synthetic Data Improves Multi-hop Reasoning ⭐
**Kabra, Weinberger et al. (ICLR 2026)** — `arxiv:2603.02091`

RL fine-tuning on **rule-generated synthetic data** (fictional knowledge, zero human annotation) → LLMs perform significantly better on **real-world QA benchmarks**. Key finding: synthetic data teaches LLMs to **compose knowledge** — a generalizable reasoning skill. On stratifying by question difficulty, the gains concentrate on harder multi-hop questions.

**Why it matters:** Validates the GOTU principle end-to-end at scale — learning logical structure on synthetic distributions transfers to real tasks. Synthetic data is free and unlimited.

---

## 2. Provable Benefit of Curriculum in Transformer Tree-Reasoning Post-Training ⭐
**Bu, Huang et al. (2025)** — `arxiv:2511.07372`

First **provable theory** for why curriculum works in LLM RL post-training. Models CoT generation as an autoregressive reasoning tree. Shows curriculum RL achieves **polynomial sample complexity** where direct learning hits an **exponential bottleneck**. Covers both depth-increasing (longer chains) and hint-decreasing (shorter prefixes) curricula. Also proves analogous gains for test-time scaling.

**Why it matters:** Turns the GOTU Degree-Curriculum from an empirical trick into a theoretically grounded principle for LLM post-training. Directly explains why DeepSeek-R1-style training benefits from progressive difficulty.

---

## 3. Positive Distribution Shift as a Framework for Understanding Tractable Learning ⭐
**Medvedev, Srebro et al. (2026)** — `arxiv:2602.08907`

Flips the usual distribution shift narrative: a **well-chosen training distribution D'(x)** can make learning *easier*, not harder. The benefit is often **computational** — PDS allows computationally hard problems to become tractable with standard gradient training. Formalizes this for hard function classes.

**Why it matters:** This is the GOTU Degree-Curriculum idea generalized into a clean theoretical framework. Degree-Curriculum *is* positive distribution shift — you're deliberately choosing a non-test training distribution (lower-degree monomials first) to make learning tractable.

---

## 4. Logic-RL: Unleashing LLM Reasoning with Rule-Based RL
**arxiv:2502.14768 (2025)**

Trains a 7B model on just **5K synthetic logic problems** using rule-based RL. The model spontaneously develops reflection, verification, and summarization — skills **absent from the training corpus**. Generalizes to AIME and AMC math competitions.

**Why it matters:** Dramatic efficiency. 5K problems is tiny. Shows that logical reasoning is a foundational skill that transfers far — directly echoing GOTU's insight that learning low-degree Boolean structure scaffolds higher-degree generalization.

---

## 5. Teaching Models to Teach Themselves
**arxiv:2601.18778 (2026)**

Models can generate useful **stepping stones** (intermediate-difficulty problems) without already being able to solve the hard target problems. This provides a path to **escape reasoning plateaus without curated data**.

**Why it matters:** Self-generating curriculum. The model *becomes its own Degree-Curriculum designer*. If this works reliably, it removes the human bottleneck in curriculum construction.

---

## 6. How Does Unfaithful Reasoning Emerge from Autoregressive Training?
**Wang, Alazali, Zhong (2026)** — `arxiv:2602.01017`

Trains small transformers on noisy arithmetic with CoT. Finds a **critical noise threshold**: below it → faithful step-by-step reasoning; above it → unfaithful skip-step reasoning, via an intermediate mixed mode with transient entropy spike. Attributes the transition to **simplicity bias** (= MDI from GOTU).

**Why it matters:** Directly maps the MDI/simplicity bias to a practical failure mode (unfaithful CoT). Gives a mechanistic explanation for when CoT reasoning breaks down, with the noise level as the control knob.

---

## 7. Bootstrapping LLMs to Reason over Longer Horizons via RL
**arxiv:2510.07312 (2025)**

Synthetically **composes short-horizon problems into multi-step dependency chains** of arbitrary length, then trains with RL. Bootstraps long-horizon reasoning from abundant short-horizon data.

**Why it matters:** This *is* Degree-Curriculum for reasoning depth. Start with 2-hop reasoning, compose into 3-hop, 4-hop, etc. Practical recipe for scaling reasoning chain length.

---

## Reading Priority

| Priority | Paper | Why |
|----------|-------|-----|
| **Read now** | Synthetic Data Multi-hop (ICLR'26) | Strongest practical validation of GOTU at LLM scale |
| **Read now** | Provable Curriculum Benefit | Theory you can actually use for post-training design |
| **Read soon** | Positive Distribution Shift | Clean framework for *why* curriculum works |
| **Skim** | Logic-RL | Known result but efficient + dramatic |
| **Skim** | Teaching Models to Teach Themselves | Early but promising self-curriculum direction |
| **Skim** | Unfaithful Reasoning | Mechanistic; connects MDI to CoT failure modes |
| **Skim** | Bootstrapping Longer Horizons | Practical recipe, straightforward extension |
