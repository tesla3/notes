# Deep Dive: Problem-Solving Logic Guided Curriculum ICL (Ma, Jiang, Huang 2025)

Source: arxiv:2502.15401. ACL 2025 Findings (pp. 8394–8412). Beijing Normal University.
Date: 2026-03-24

## TL;DR

Uses **problem-solving logic** (formalized decomposition of questions into operator sequences) to both **select** and **order** ICL demonstrations. Selection: pick examples whose operator sequence is a prefix-subsequence of the query's. Ordering: easy-to-hard by step count (curriculum). On Llama3-8B, +2.24% avg accuracy over prior ICL methods across 5 benchmarks, while using **fewer demonstrations** (avg 2.74 vs 6+) and **less time** (9–67% savings).

---

## Method

### Step 1: Problem-Solving Logic (PSL) Extraction

- Built on **QDMR** (Question Decomposition Meaning Representation, Wolfson et al. 2020) — decomposes complex questions into sub-questions, each tagged with one of 13 predefined operators (select, project, group, superlative, filter, etc.).
- Constructed an instruction-tuning dataset from the **BREAK dataset** (60K question-answer pairs with QDMR annotations).
- Fine-tuned **Llama3-8B with LoRA** on this dataset to predict PSL for arbitrary questions.
- Output: an ordered sequence of operators, e.g., `select → project → group → superlative`.

### Step 2: Demonstration Selection (PSL-based)

- For a query with PSL of m operations, a candidate example with n operations (n ≤ m) is selected **iff** its n operations match the **first n operations** of the query's PSL (ordered prefix subsequence).
- This ensures demonstrations share the same **reasoning structure** as the query, but may differ in semantics (boosting generalization).
- When more candidates match than needed, four **difficulty sampling strategies** were tested:
  1. **Prioritize simplicity** — pick easiest examples first
  2. **Prioritize difficulty** — pick hardest first
  3. **Select randomly** — random
  4. **Prioritize diversity** — sample at most one from each difficulty level ← **winner**

### Step 3: Curriculum Ordering

- Difficulty metric: **number of PSL operations** (more steps = harder).
- Order demonstrations **easy → hard** following curriculum learning principles.
- Final prompt: ordered demonstrations + query → LLM.

---

## Key Results (Llama3-8B)

| Method | Selection | Ordering | SVAMP | AQuA | GSM8K | CSQA | StratQA | **Avg** |
|--------|-----------|----------|-------|------|-------|------|---------|---------|
| Random | Random | Random | 76.5 | 46.5 | 73.8 | 75.8 | 65.1 | 67.5 |
| VoteK | KNN | Similarity | 74.9 | 44.9 | 76.7 | 75.4 | 69.0 | 68.2 |
| AutoCoT | K-means | Similarity | 77.5 | 47.2 | 75.3 | 76.0 | 71.2 | 69.4 |
| CoT+Fewshot | Fixed | Fixed | 80.5 | 44.5 | 79.4 | 75.1 | 69.4 | 69.8 |
| AL-ICL | KNN | Similarity | 80.8 | 45.7 | 78.2 | 77.9 | 68.1 | 70.1 |
| **PSL-Curriculum** | **PSL** | **Curriculum** | **83.4** | **50.8** | **81.1** | 75.0 | **71.6** | **72.4** |

### Ablations: What Matters

**Selection strategy (with curriculum ordering):**
| Strategy | Avg demos | Avg accuracy | Time |
|----------|-----------|--------------|------|
| Prioritize diversity | **2.74** | **72.37%** | **100%** |
| Select randomly | 6.42 | 71.70% | 144% |
| Prioritize simplicity | 6.38 | 70.79% | 117% |
| Prioritize difficulty | 6.02 | 69.77% | 167% |

**Ordering effect:**
- Diversity + curriculum ordering: 72.37% → without ordering: 70.11% (**+2.26% from ordering alone**)
- Simplicity: ordering adds only +0.24%
- Difficulty: ordering *hurts* by -0.52%
- Key insight: **ordering matters most when difficulty diversity is high**. Standard deviation of difficulty levels across demos correlates positively with both performance and the gain from curriculum ordering.

### Efficiency

Prioritize-diversity uses avg **2.74 demos** vs 6+ for other strategies. This means:
- Shorter prompts → faster inference
- 9–67% time savings vs other strategies
- Counterintuitive: fewer but *structurally diverse* demos > many similar demos

---

## Analysis & Critique

### Strengths

1. **Principled difficulty metric.** Number of PSL operations is a clean, interpretable proxy for reasoning difficulty. It's not ad hoc — it reflects the actual computation graph depth of the problem.

2. **Selection via reasoning structure, not surface similarity.** Prior work (KNN, BM25, embedding similarity) selects demos by surface features. PSL-based selection matches **reasoning patterns**, which is conceptually superior for reasoning tasks. An example about dogs and one about cars can share the same PSL.

3. **Diversity >> quantity.** The finding that 2.74 diverse demos beat 6+ similar ones is practically significant. Matches the broader curriculum learning insight: what matters is covering difficulty levels, not repeating similar examples.

4. **Ordering sensitivity to diversity.** The observation that curriculum ordering only helps when difficulty diversity is high is a clean, actionable insight. If your demos are all the same difficulty, ordering them is meaningless.

### Weaknesses

1. **Only Llama3-8B.** No experiments on larger models or different architectures. The curriculum effect may diminish with scale — larger models may already internalize these ordering effects. Authors acknowledge this.

2. **PSL extractor is trained on BREAK, which is domain-specific.** BREAK covers reading comprehension, knowledge-based QA, and some math. Whether the 13 QDMR operators generalize well to arbitrary reasoning tasks (code generation, scientific reasoning) is unclear. The operator vocabulary is fixed and hand-designed.

3. **No comparison with CDS** (Curriculum Demonstration Selection, arxiv:2411.18126). CDS uses generic complexity metrics and was tested on 9 LLMs / 3 benchmarks. Would have been a more direct competitor.

4. **CommonsenseQA performance.** PSL-Curriculum gets 75.0% on CSQA, below AL-ICL's 77.9%. For commonsense reasoning, PSL-based structural matching may be weaker than semantic similarity — commonsense questions may not have clean decomposable logic.

5. **Prefix-subsequence matching is restrictive.** Requiring the demo's operator sequence to match the *first n* operators of the query's sequence is brittle. If the PSL extractor makes one mistake (e.g., swaps two operators), the match breaks. No soft matching or edit-distance fallback.

---

## Connection to GOTU / Degree-Curriculum

The paper doesn't cite Abbe et al. (2023) directly, but the conceptual parallels are strong:

| GOTU (Abbe et al.) | This paper |
|---------------------|------------|
| Boolean Fourier degree | Number of PSL operations |
| Degree-Curriculum: increment monomial support | Curriculum ICL: increment reasoning steps |
| MDI bias: network learns lowest-degree solution | Demos start simple → prime the model for low-degree reasoning first |
| Train on seen, generalize to unseen | Learn from demos, generalize to query |

**The key theoretical link:** GOTU shows that networks biased toward low-degree interpolation benefit from curricula that build up degree. In ICL, the model's in-context "learning" similarly benefits from building up complexity — simple demos first establish the reasoning pattern, then harder ones extend it. The PSL step count is an empirical proxy for what GOTU formalizes as Fourier degree.

**Where they diverge:** GOTU is about *weight updates* (SGD converges to MDI). ICL has *no weight updates* — the curriculum effect operates through the attention mechanism's in-context processing. This suggests the MDI-like bias may be deeper than just optimization dynamics — it may reflect how attention processes sequential information.

---

## Comparison: PSL-Curriculum vs CDS vs ICCL

| | PSL-Curriculum | CDS (2411.18126) | ICCL (Liu et al. 2024) |
|---|---|---|---|
| **Venue** | ACL 2025 Findings | AAAI? / arxiv | Prior work |
| **Difficulty metric** | PSL step count | Generic complexity (token count, tree depth, etc.) | Human/LLM-defined |
| **Selection** | PSL prefix match | Similarity + complexity partitioning | Varies |
| **Key insight** | Reasoning structure > surface features | Diversity across difficulty > similarity alone | Easy-to-hard ordering helps |
| **Scale tested** | Llama3-8B only | 9 LLMs | Varies |
| **Limitation** | Domain-specific PSL extractor | Generic metrics may miss reasoning structure | Needs human expertise |

---

## Practical Takeaways

1. **For prompt engineering:** Order your few-shot examples easy → hard. If you can only pick a few, pick ones that span difficulty levels rather than many similar ones.

2. **For building ICL pipelines:** Don't use embedding similarity alone to select demos. If you can extract problem structure (decomposition, dependency graph, step count), use that for matching.

3. **Diminishing returns on demo count:** 3 well-chosen, diverse-difficulty demos often beat 8 similar ones. This is both cheaper and faster.

4. **When curriculum ordering helps most:** When your demo set spans a range of difficulties. If all demos are equally easy/hard, ordering doesn't matter.

5. **Open opportunity:** The PSL extractor is domain-specific to BREAK's 13 operators. A more general "reasoning structure extractor" (perhaps using CoT decomposition or plan generation) would make this approach domain-agnostic.
