# Algorithmic Creativity in LLMs: Research Notes

**Papers analyzed:**
1. **"Roll the Dice & Look Before You Leap"** — Nagarajan, Wu, Ding, Raghunathan (Google Research + CMU). ICML 2025 Outstanding Paper (oral). [arXiv:2504.15266](https://arxiv.org/abs/2504.15266)
2. **"Combinatorial Creativity: A New Frontier in Generalization Abilities"** — Schapiro, Shashidhar, Gladstone, Black, Moon, Hakkani-Tur, Varshney (UIUC / Stony Brook / Spiral Works). Submitted to ICLR 2026. [arXiv:2509.21043](https://arxiv.org/abs/2509.21043)

**Last updated:** 2 March 2026

---

## 1. What the Papers Are

Both papers study creativity as a measurable capability of language models, using **synthetic graph-based algorithmic tasks** as controlled proxies. Both draw on **Margaret Boden's (2003/2004) taxonomy** of creativity (combinational, exploratory, transformational). Both train models on graph-structural data stored in weights (not in context), then test whether models can generate valid novel structures.

Paper 1 asks: **how should models learn and sample** for creative tasks?
Paper 2 asks: **how should we evaluate** creativity, and what do architecture/scale reveal?

Paper 2 explicitly positions itself as extending Paper 1 (cites it 7+ times, includes a full comparison section §3.5).

---

## 2. Paper 1: "Roll the Dice" — Summary

### Tasks
- **Combinational creativity:** Sibling Discovery (generate (child, child, parent) triplets from bipartite graph), Triangle Discovery (generate triangles from a graph)
- **Exploratory creativity:** Circle Construction, Line Construction (generate adjacency lists that resolve to valid structures under some permutation)

### Key claims
1. **NTP is myopic for creative tasks.** The "Clever Hans cheat" argument: in teacher-forced training, later tokens can be trivially predicted from the ground-truth prefix, starving earlier tokens of supervision. This causes data-inefficiency — NTP needs O(mn²) data where the natural generative process needs O(mn). *[NOTE: This is presented as a conjecture for their tasks, not a proof. The original Bachmann & Nagarajan 2024 result is a stronger impossibility for path-star graphs.]*
2. **Multi-token prediction helps dramatically.** Teacherless training and diffusion models achieve up to 5× higher algorithmic creativity than NTP, primarily by reducing memorization. Tested on Gemma v1 (2B) and GPT-2 (86M).
3. **Seed-conditioning works.** Prepending arbitrary random prefixes during training/inference produces diverse output even with greedy decoding — comparable to or better than temperature sampling. The model learns to map arbitrary noise to structured randomness.
4. **Permutation-invariant tasks resist all token-reordering fixes.** Circle and line construction tasks have no privileged token ordering, challenging proposals to fix NTP via permutations or partial lookaheads.

### Creativity metric
`cr = unique(coherent ∧ not-in-training-set) / |T|`

Binary coherence, binary novelty (in training set or not), population-level diversity measure.

### Models tested
GPT-2 (86M), SEDD diffusion (90M), ~400M variants, Gemma v1 (2B) finetuned.

---

## 3. Paper 2: "Combinatorial Creativity" — Summary

### Task
Graph walks on labeled undirected graphs. Creative prompts specify (start node, end node, inclusion set of required edge labels, exclusion set of forbidden edge labels). Model must generate a valid path satisfying all constraints.

### Key claims
1. **Continuous novelty and utility measures** are needed. Novelty N(P) = α_h·h + α_r·S(P) where h is path length and S(P) is average negative log-likelihood of label probabilities. Utility U(P;x) scales with number of satisfied inclusion/exclusion constraints. Creativity C(θ) = E[U·N].
2. **Optimal depth/width sweet spots exist.** Non-monotonic: ~8 layers optimal at 100M params. E/L ratio 200-300 optimal across scales (1M, 10M, 100M).
3. **Novelty-utility tradeoff persists across scales.** More constraints → less novel output. Does not improve at 100M.
4. **Error types shift with scale.** Small models hallucinate (invalid edges/nodes); large models make logical errors (constraint violations). Errors become subtler, not fewer.
5. **Explains ideation-execution gap** via novelty-utility tradeoff, mapping inclusion/exclusion constraints to real-world failure modes from Si et al. (2024, 2025).

### Models tested
GPT-2 decoder-only transformers only, 1M/10M/100M parameter sweeps. **NTP only — does not test multi-token prediction or seed-conditioning.**

---

## 4. Comparison

| Dimension | Paper 1 | Paper 2 |
|---|---|---|
| Creativity types studied | Combinational + Exploratory | Combinational only |
| Novelty measure | Binary (in training set?) | Continuous (path length + label surprise) |
| Utility measure | Binary (coherent?) | Continuous (constraint satisfaction, scaled) |
| Diversity measured? | Yes (uniqueness in batch) | No (acknowledged as limitation) |
| Training objectives tested | NTP, teacherless, diffusion | NTP only |
| Inference methods tested | Greedy, temperature, seed-conditioning | Standard autoregressive |
| Architecture sweep | No (fixed architectures) | Yes (systematic depth/width/heads) |
| Scale range | 86M–2B (finetuning) | 1M–100M (from scratch) |
| Structural novelty in artifacts | Fixed-length structures | Variable-length walks |
| Venue status | ICML 2025 Outstanding Paper | ICLR 2026 submission |

**The critical missing experiment:** Paper 2 never tests multi-token prediction or seed-conditioning — Paper 1's strongest interventions. Paper 2's novelty-utility tradeoff might diminish under multi-token prediction. Conversely, Paper 1 never tests whether its gains hold under harder constrained creative tasks like Paper 2's.

---

## 5. Critical Issues

### 5.1 The fundamental validity question: Is this "creativity"?

Both papers study constrained graph search/generation on synthetic random graphs. The connection to actual creativity (writing puns, generating research ideas, composing music) is established **entirely by analogy**:
- "You can think of the parent vertex as the punchline" (Paper 1)
- "Exclusion constraints are a minimal abstraction for preventing unrealistic assumptions" (Paper 2)

These are narratively suggestive but formally unvalidated. If we replaced "creativity" with "constrained combinatorial generation" throughout both papers, the technical contributions would be identical but the framing would be less exciting. Neither paper demonstrates transfer to any real creative task.

Paper 1 attempts a real-world validation (summarization, §4.2) but the results are weak: diversity gains are "only by a slight amount" and "not always noticeable for CNN/DailyMail." This is evidence *against* clean transfer.

### 5.2 Paper 2's novelty measure is differently arbitrary, not more principled

N(P) = α_h·h + α_r·S(P) contains two free scalar parameters. Different choices produce different novelty rankings. The measure is continuous but not derived from first principles. Binary novelty (Paper 1) requires no parametric choices and has the virtue of assumption-freedom. Paper 2 trades simplicity for expressiveness but introduces researcher degrees of freedom.

### 5.3 The Varshney tradeoff connection is analogical, not formal

Paper 2 claims its novelty-utility tradeoff recovers Varshney's (2019) information-theoretic limit. But Varshney's theorem uses Bayesian surprise (relative entropy), not path-length + label-surprise. The connection is: both show a downward trend when constraints tighten. The functional form and mechanism are different. Moreover, Varshney is an author on Paper 2, making this partly self-validating.

### 5.4 The ideation-execution gap explanation is a metaphor

Paper 2's Table 2 maps synthetic constraints to Si et al.'s real-world failure modes. But an exclusion constraint on edge labels has no structural relationship to "don't assume access to 10,000 GPUs." The gap likely has prosaic causes (LLMs lack tacit engineering knowledge, generate plausible-but-underdetermined plans) unrelated to information-theoretic tradeoffs on random graphs.

### 5.5 Scale limitations are more damaging than acknowledged

Both papers study models ≤100M (Paper 2) or ≤2B finetuned (Paper 1). Frontier models are 100-1000× larger. Emergent capabilities at scale are well-documented. The novelty-utility tradeoff at 100M could diminish or vanish at 100B. Claims about "the creative potential of LLMs in their current form" from 100M-parameter experiments are premature.

### 5.6 Paper 1's Clever Hans argument is a conjecture, not a proof

For their sibling/triangle/construction tasks, the mechanistic explanation is explicitly conjectured. The data-inefficiency claim (O(mn²) vs O(mn)) follows from the conjecture. The empirical gap between NTP and multi-token is real; the explanation is hypothesized.

### 5.7 Boden's taxonomy has known limitations

Ritchie (2001): the combinational/exploratory distinction is "hard to pin down" — any combinational process involves exploring a space of combinations. Wiggins (2006): transformational creativity reduces to exploratory creativity at a meta-level. Both papers inherit this conceptual instability without confronting it.

### 5.8 Neither paper measures both diversity and degree-of-novelty

Paper 1 measures diversity + non-memorization but not degree-of-novelty. Paper 2 measures degree-of-novelty + degree-of-utility but not diversity (acknowledged). Each metric is incomplete in a way that makes cross-comparison difficult.

---

## 6. What Holds Up

1. **NTP's data-inefficiency for open-ended tasks is empirically robust** (Paper 1). The gap between NTP and multi-token prediction is real, reproduced across models/tasks, and the ICML Outstanding Paper recognition reflects genuine quality.

2. **Paper 2's formal framework is a real contribution** — explicit definitions of conceptual space, creative artifact, creative prompt, novelty, utility, and creativity give the field concrete objects to build on and critique. The specific choices may be debatable, but making them explicit is progress.

3. **The novelty-utility tradeoff is a real empirical phenomenon** in these synthetic tasks, even if its interpretation as "fundamental" or "information-theoretic" is overclaimed.

4. **Seed-conditioning is a useful finding** — arbitrary random prefixes produce diverse output with greedy decoding. Connects to conditional generation (GANs, VAEs, diffusion) but the autoregressive-with-text-prefix version is new and practically relevant. Still lacks theoretical explanation.

5. **Error-type shift with scale** (Paper 2) is a clean, useful observation: scaling reduces surface errors (hallucination) but reveals deeper logical failures. This pattern likely generalizes beyond creativity tasks.

---

## 7. Open Questions and Future Directions

1. **The obvious synthesis:** Use Paper 2's framework (continuous novelty/utility, inclusion/exclusion constraints) with Paper 1's interventions (multi-token prediction, seed-conditioning, diffusion). Does multi-token prediction shift the novelty-utility Pareto frontier?

2. **Real-world validation:** Can any finding from either paper be shown to hold on actual creative tasks (joke generation, research ideation, drug design)?

3. **Scale:** What happens at 1B-100B scale? Does the novelty-utility tradeoff persist? Do the architectural sweet spots shift?

4. **Beyond Boden:** Both papers anchor to a 20+ year-old taxonomy. More modern frameworks (Jordanous & Keller's 14-component model, Wiggins' formalization, integrational creativity) might provide richer theoretical foundations.

5. **Planning-aware architectures:** Neither paper tests architectures that can explicitly represent and satisfy constraints during generation (energy-based models, neuro-symbolic approaches, structured planning with verifiers). These might address the novelty-utility tradeoff from a different angle than training-objective changes.

6. **Seed-conditioning theory:** Why does arbitrary noise become structured randomness in autoregressive transformers? This finding needs a mechanistic explanation (perhaps via representation analysis or information-theoretic arguments about input entropy propagation).

---

## 8. Bottom Line

These papers represent serious, controlled work on a genuinely hard problem. Paper 1 is the stronger empirical contribution (clean findings, real interventions, well-deserved ICML recognition). Paper 2 is the stronger theoretical contribution (formal framework, architectural analysis) but with more overclaiming.

**The central unsettled question for the entire research program:** whether "algorithmic creativity" on synthetic graphs tells us anything meaningful about actual creativity in AI systems. Both papers bet that it does, by analogy to how arithmetic benchmarks inform our understanding of reasoning. Whether this bet pays off is the single most important thing to watch as the field develops.
