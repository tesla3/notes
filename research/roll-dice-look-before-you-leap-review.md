← [Index](../README.md)

# Critical Review: "Roll the dice & look before you leap"

**Paper:** Nagarajan, Wu, Ding, Raghunathan (2025). ICML 2025 Oral.
**arXiv:** [2504.15266](https://arxiv.org/abs/2504.15266) · **OpenReview:** [Hi0SyHMmkd](https://openreview.net/forum?id=Hi0SyHMmkd)
**Code:** [github.com/ChenWu98/algorithmic-creativity](https://github.com/ChenWu98/algorithmic-creativity)

---

## TL;DR

The paper designs minimal algorithmic tasks that abstract "creative" open-ended generation, shows NTP (next-token prediction) is myopic on these tasks (high memorization, low diversity), and demonstrates that multi-token prediction (teacherless training, diffusion) + a novel "seed-conditioning" method significantly improve diversity/originality. Accepted as ICML 2025 oral (reviewer scores: 5, 4, 4 → after rebuttal: 5, 4, 4).

---

## What the Paper Actually Claims

1. **NTP is myopic for creative tasks.** On tasks requiring a "leap of thought" — implicit planning of globally-coherent random structures — NTP suffers from "Clever Hans" cheating (learning later tokens trivially from prefix, starving gradient for latent plan learning). This causes high memorization and low diversity.

2. **Multi-token prediction (MTP) significantly improves "algorithmic creativity."** Specifically: teacherless training on Gemma-2B shows ~5× creativity gain; SEDD diffusion (90M) beats GPT-2 (86M) NTP on 3/4 tasks.

3. **Seed-conditioning (hash-conditioning) is a viable alternative to temperature sampling** for eliciting diversity. Random meaningless prefixes, paired arbitrarily with training data, let the model produce diverse outputs even under greedy decoding.

4. **Permutation-invariant tasks resist all NTP fixes.** Unlike the path-star task from Bachmann & Nagarajan 2024 (which can be fixed by reversing token order), the construction tasks (circle, line) have no privileged token ordering — NTP can't be rescued by permutation.

---

## Strengths

### 1. Elegant problem formulation (genuinely novel angle)
The cognitive-science-grounded taxonomy (Boden 2003: combinational vs. exploratory creativity) mapped to graph-theoretic tasks is intellectually clean. Sibling discovery ≈ wordplay (find punchline connecting two concepts), Triangle discovery ≈ higher-order analogy, Circle/Line construction ≈ puzzle design. These are the right abstractions: simple enough to measure precisely, complex enough to expose real limitations.

**Cross-validation:** This builds on and meaningfully extends Bachmann & Nagarajan (ICML 2024), which showed NTP breaks on "path-star" planning tasks. That paper demonstrated *correctness* failures; this one demonstrates *diversity* failures — an orthogonal and arguably more practically relevant dimension for scientific discovery and data generation use cases.

### 2. Permutation-invariance argument is the strongest contribution
The insight that Circle/Line construction tasks are *permutation-invariant* — no token ordering helps NTP — is the paper's sharpest theoretical point. This directly challenges not just NTP but also recent "fix NTP via permutations" proposals (Pannatier et al. 2024, Thankaraj et al. 2025) and partial-lookahead methods (Gloeckle et al. 2024, Bavarian et al. 2022). The argument: when the latent generative process is not decomposable left-to-right *in any order*, the whole token must be learned simultaneously.

**Cross-validation:** This aligns with the concurrent "Future Summary Prediction" paper (Mahajan et al., Oct 2025, Meta), which independently argues MTP captures only short-range dependencies and proposes predicting compact summaries of the long-term future. The community is converging on the view that NTP (and even naive MTP) misses global structure.

### 3. Seed-conditioning is genuinely surprising and provocative
The finding that arbitrary random prefixes (with no semantic relationship to the output) produce diverse outputs even under greedy decoding is the paper's most unexpected result. It suggests a fundamentally different way to think about randomness in generative models: inject it at the input rather than sampling from the output distribution.

**Cross-validation:** This has loose parallels in:
- Diffusion model literature: CADS (Condition-Annealed Diffusion Sampler, 2023) injects noise into conditioning for diversity.
- Prompt perturbation literature: varying prompt wordings is known to induce diversity (Li et al. 2023, Lau et al. 2024).
- Concurrent position paper by Jahrens & Martinetz (2025) independently argues a similar representational point.

But seed-conditioning goes further: the seeds are semantically meaningless, yet the model learns to use them as diversification signals. This is non-trivial and poorly understood even by the authors.

### 4. Thorough experimental methodology
- 4 seeds per run for Gemma experiments, variation plotted.
- Extensive hyperparameter sensitivity analysis (Appendix E, F).
- Ablations ruling out confounds (token reordering, dataset size, complexity).
- Multiple model scales (GPT-2 86M, SEDD 90M, Gemma 2B, with 400M added in revision).

### 5. Exceptionally well-written
Reviewer Lrgc's "strong accept" note that "the text addresses most questions that come up while reading" is accurate. The paper manages real conceptual density while remaining clear. The lay summary is one of the better ones I've seen at a top venue.

---

## Weaknesses

### 1. The elephant in the room: ecological validity
**Severity: High, but acknowledged.**

The tasks are *extremely* minimal. "Creativity" here means "generate novel coherent graph structures from a memorized graph" — not write a poem, design an experiment, or compose music. The jump from "find novel triangles in a 50-node graph" to "generate creative scientific hypotheses" is enormous and fundamentally unvalidated.

The summarization experiment (§4.2) is the only real-world bridge, and it's weak: the diversity gain from MTP is "slight" and "does not hold for smaller models" and "is not always noticeable for CNN/DailyMail." This is a substantial gap. The authors acknowledge it candidly, arguing that real-world creativity benchmarks don't exist — which is true but doesn't strengthen the paper's claims.

**Verdict:** The tasks are useful as *necessary conditions* (if you can't even do this, you can't do real creativity), but showing NTP fails here does not prove it fails on actual creative tasks. Large pretrained models with chain-of-thought, tool use, and RL might overcome these specific failure modes.

### 2. Model scale is uncomfortably small
The paper tests GPT-2 (86M), SEDD (90M), Gemma-2B, and (in revision) a 400M diffusion model. No model exceeds 2B parameters.

Modern frontier models are 70B-1T+ parameters. The paper's own argument about "Clever Hans cheats" and gradient starvation might scale differently with capacity — a model with far more parameters might learn both the cheat *and* the underlying structure. The authors argue 2B is "very large" for their minimal datasets, which is fair, but it means the results don't tell us about frontier model behavior on richer data.

**Cross-validation:** Gloeckle et al. (2024, Meta) found MTP gains are "increasingly useful for larger model sizes" in their multi-token prediction paper. This is suggestive but doesn't resolve whether the NTP-vs-MTP creativity gap persists, widens, or narrows at scale. The paper could have at least tested on 7B or 13B pretrained models.

### 3. Seed-conditioning mechanism is poorly understood
The authors are refreshingly honest about this — "We do not understand this presently" — but it's still a major limitation. Three speculative explanations are offered:
1. Top-K sampling restricts output diversity (but the effect persists without top-K).
2. Representational: seed lets model flesh out one thought instead of maintaining multiple.
3. Planning: fixing randomness up front aids multi-step coordination.

None are verified. More critically, seed-conditioning doesn't help diffusion models (§F.3), which undercuts the generality of the mechanism. If it only helps autoregressive Transformers, the practical path is narrower than implied.

### 4. Creativity metric is crude
The "algorithmic creativity" metric (Eq. 1) counts unique, non-memorized, coherent outputs divided by total samples. This conflates diversity, originality, and coherence into a single number, making it hard to diagnose *what specifically* is failing.

The paper does decompose this into memorization and diversity components (§H.2), but the main results are presented with the composite metric. Self-BLEU for the summarization experiment is a widely-used but shallow diversity proxy — it measures lexical variation, not conceptual diversity.

### 5. The NTP argument is data-efficiency, not impossibility
The paper is careful to call this a "data-inefficiency result" rather than an impossibility result (unlike B&N'24). NTP on the sibling task requires O(m·n²) data instead of O(m·n). But this means with enough data, NTP should eventually match MTP. Given that pretraining corpora are massive, the practical import depends on whether the data-efficiency gap matters at internet scale. The paper doesn't address this directly.

### 6. Missing comparison with CoT/reasoning methods
All three reviewers flagged this. The authors' rebuttal arguments are thoughtful:
- CoT is designed for correctness, not diversity/originality.
- Creative traces rarely exist in human data.
- It's unclear what CoT for triangle discovery would even look like.

These are valid points but also somewhat self-serving. The real question is whether RL-tuned models with chain-of-thought (e.g., o1-style reasoning) could learn to explicitly plan diverse outputs. This is neither tested nor conclusively argued against.

---

## Cross-Validation Against the Broader Literature

### Consistent with:
- **B&N'24 (Pitfalls of NTP):** Same first author, extends the path-star impossibility result to creativity/diversity. Consistent and natural progression.
- **Gloeckle et al. 2024 (Meta MTP):** Found MTP improves coding/reasoning, especially at scale. Consistent directionally.
- **SEDD (Lou et al. 2024):** SEDD generating "faithful text without temperature scaling" aligns with the finding that non-autoregressive methods naturally produce more diverse outputs.
- **DeepSeek-V3 (2024):** Uses MTP in production training. Industry has already bet on MTP mattering, though for different reasons (speed, representation quality).
- **Mahajan et al. 2025 (Future Summary Prediction):** Independently identifies NTP's failure on long-horizon coherence and creativity. Cites this paper.

### In tension with:
- **Scaling laws for NTP:** The empirical success of NTP at massive scale (GPT-4, Claude, Llama 3) suggests that whatever NTP fails at on toy tasks may be compensated by scale, data, and RLHF. The paper's tasks are deliberately adversarial to NTP.
- **Chain-of-thought as planning:** If models can learn to explicitly plan via CoT tokens, the "implicit planning" bottleneck the paper identifies might be a solvable artifact of the supervised-only regime.
- **Temperature + nucleus sampling in practice:** Practitioners routinely get diverse outputs from NTP models using temperature/top-p. The paper's finding that these are insufficient is specific to its tasks and may not generalize.

### Open questions the paper raises:
1. Does the NTP-MTP creativity gap persist at 70B+ scale with internet-scale data?
2. Can seed-conditioning work in real pretraining, not just fine-tuning on tiny datasets?
3. Is the "Clever Hans" effect actually what's happening in large pretrained models, or only in the small fine-tuned setting?
4. How does RL (RLHF/RLAIF) interact with the creativity bottleneck?

---

## Assessment of the Reviews

The three reviews were reasonable:
- **Reviewer Lrgc (5, Strong Accept):** Best review. Correctly identifies the paper's value as a failure-test (models failing here should be expected to fail at larger scale), appropriate caveats about CoT, appreciates the elegance.
- **Reviewer gG8C (4, Accept):** Identifies the three main weaknesses (hash-conditioning mechanism unclear, real-world gap, scale). Solid but less engaged.
- **Reviewer 16p5 (3→4, Accept after rebuttal):** Initially more skeptical, correctly pushed for data examples and mechanism clarification. Good question about hash-prefix-only attention.

The AC decision correctly identifies this as a testbed/benchmark contribution with novel ideas (hash-conditioning) rather than a methods paper per se. The oral designation is justified: it's a thought-provoking, well-executed paper on a timely topic, even if the practical implications remain speculative.

---

## Verdict

**Rating: Strong paper with clear limitations it honestly acknowledges.**

The core insight — that creative open-ended generation requires implicit global planning that NTP is poorly suited to learn — is sound, important, and well-demonstrated within the paper's scope. The permutation-invariance argument is the most compelling contribution; seed-conditioning is the most intriguing.

The main risk is over-generalization. The paper is about *algorithmic tasks on small graphs*, not about creativity writ large. The Galileo/Newton analogy in the lay summary (studying simple objects to understand fundamental forces) is apt but also a bit self-serving — Galileo's spheres on inclined planes did generalize, but not every simplified experiment does.

**Who should read this:** Anyone working on MTP, diffusion language models, diversity in generation, or theoretical foundations of autoregressive training. The permutation-invariance argument alone is worth the read.

**Who should be cautious:** Anyone tempted to conclude from this paper that NTP "can't be creative." It can't do *these specific tasks* efficiently. The gap to real-world creative writing, scientific discovery, or protein design remains enormous and uncharted.

---

## Code & Reproducibility Status

**Repo:** [github.com/ChenWu98/algorithmic-creativity](https://github.com/ChenWu98/algorithmic-creativity) — 85 stars, 7 forks, 11 commits (as of Feb 2026).

**What's released:**
- All 4 tasks: sibling-discovery, triangle-discovery, circle-construction, line-construction
- Each with NTP, teacherless, and diffusion training scripts + Jupyter notebooks for data generation
- Runs on a single A6000 GPU
- Data examples on HuggingFace: [sibling](https://huggingface.co/datasets/ChenWu98/sibling.5.500.10.50000), [triangle](https://huggingface.co/datasets/ChenWu98/triangle.10), [circle](http://huggingface.co/datasets/ChenWu98/circle.10.9.10.10000), [line](https://huggingface.co/datasets/ChenWu98/line.10.9.10.10000)

**What's missing:**
- **Gemma-2B code not released.** README states: "we have experiments with both Gemma 2B and GPT-2/SEDD in the paper, while this repo only contains the GPT-2/SEDD code." The headline 5× creativity gain is from Gemma, so the most impressive result is not reproducible from the repo.
- The 400M diffusion model experiments (added in revision) — unclear if code is included.

**Open issues (2):**
1. NielsRogge (HuggingFace staff) requesting dataset release on HF (Apr 2025, still open).
2. A user flagging a Seq2Seq config error in NTP vs. teacherless baseline settings (Aug 2025, still open — potentially affecting reproducibility of the core NTP-vs-teacherless comparison).

**Community engagement:** Low. 85 stars is modest for an ICML oral. 7 forks, no closed PRs, no external replications found. The config error issue (open 6+ months) is a yellow flag.

---

## Frontier Model Follow-ups: Nobody Has Done This

**The most important open question — does the NTP-vs-MTP creativity gap persist at frontier scale? — remains completely untested as of Feb 2026.**

Exhaustive search found:
- **Zero replications** using Claude (any version), GPT-4/5, Gemini 3, or any model >2B parameters on these specific tasks.
- **Zero blog posts, tweets, or informal experiments** applying these benchmarks to frontier models.
- **No citations from frontier model papers** (GPT-5, Claude Opus 4.5, Gemini 3 tech reports) referencing these tasks.

This is a significant gap. The tasks are simple enough that any API-accessible model could be tested via in-context learning (for the in-context variants) or fine-tuning (for the in-weights variants). The community's failure to close this gap in ~10 months post-publication is notable.

### One Academic Follow-up

**"Combinatorial Creativity: A New Frontier in Generalization Abilities"**
Schapiro, Shashidhar et al. (arXiv [2509.21043](https://arxiv.org/abs/2509.21043), Sep 2025, UIUC/Stony Brook). Preprint, 5 revisions through Jan 2026.

**Relationship to original paper:**
- Directly compares with and extends the Nagarajan et al. sibling/triangle discovery tasks (§3.5, Table 1).
- Uses the same Boden (2003) creativity taxonomy but builds a richer framework.

**Key critiques of the original:**
1. **Novelty is binary** — the original only checks "was this in the training set?" Real creativity requires degrees of novelty. The follow-up defines continuous novelty via graph walk distance and label surprise.
2. **No structural novelty** — original tasks fix output length/format (always a triple). The follow-up allows variable-length path generation.
3. **No utility gradation** — original only checks coherence (boolean). The follow-up adds inclusion/exclusion constraints with continuous utility scoring, abstracting real-world creative constraints (e.g., "your research idea must include a proper baseline" = inclusion constraint).

**Key findings:**
- Discovers **optimal model depths and widths** for creativity at fixed parameter budgets (peak creativity at ~8 layers for 100M models, E/L ratio 200-300).
- Finds a persistent **novelty-utility tradeoff** that doesn't improve with scale to 100M — more constraints → less novel outputs. Proposes this explains the "ideation-execution gap" in LLM scientific idea generation (Si et al. 2024/2025).
- At small scales, hallucination dominates errors; at 100M, "invalid path" (logical inconsistency) errors rise — suggesting scaling fixes surface errors but not deep structural ones.

**Limitations of the follow-up:**
- **Still only goes to 100M parameters.** Explicitly acknowledges "frontier models today are well into the billions of parameters."
- **NTP only** — does not test MTP, diffusion, or seed-conditioning. Does not validate or refute the original paper's central MTP-vs-NTP claim.
- Uses GPT-2 architecture only.
- Preprint, not peer-reviewed.

**Verdict on follow-up:** Useful theoretical extension with better-grounded creativity metrics, but doesn't address the frontier-scale question or test the original paper's MTP/seed-conditioning interventions. Complementary rather than validating or refuting.

### Why Nobody Has Tested Frontier Models

Likely reasons:
1. **Fine-tuning required.** The in-weights tasks (sibling, triangle) require the graph to be memorized during training — you can't just prompt GPT-5 with these. You'd need to fine-tune, and frontier model fine-tuning is expensive/restricted.
2. **Missing Gemma code.** The most compelling results (5× gain on Gemma-2B) can't be reproduced without the unreleased code.
3. **Niche audience.** The paper is theoretical/conceptual. Practitioners building creative AI systems haven't adopted these as benchmarks.
4. **Unclear practical relevance.** The gap between "find triangles in a synthetic graph" and "write a creative poem" remains so large that frontier labs may not see the benchmarks as worth investing in.

---

*Sources: arXiv 2504.15266v4, OpenReview forum Hi0SyHMmkd (3 reviews + rebuttals + AC decision), GitHub repo ChenWu98/algorithmic-creativity (inspected Feb 2026), Bachmann & Nagarajan ICML 2024, Gloeckle et al. 2024 (Meta MTP), Lou et al. 2024 (SEDD), Mahajan et al. 2025 (FSP), DeepSeek-V3 tech report, Schapiro et al. 2025 (arXiv 2509.21043).*
