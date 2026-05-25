# Critical Review: "Recent Progress in GAT, Graph Transformers, and GCN (2024–2026)"

Source: Gap analysis of graph-neural-networks-progress-2025-2026.md, March 2026

---

## Verdict

This is an unusually strong research note — well above typical survey quality. The PPGT/CKGConv/Tuned-GNN convergence thesis in Section 5 is the intellectual centerpiece, and it's genuinely insightful. That said, I've identified **seven substantive gaps** (three severe), **two overclaims**, and **several missing research threads** that collectively produce a distorted picture of the 2024–2026 GNN landscape.

---

## GAP 1 (SEVERE): Over-Squashing Is Almost Entirely Absent

The note devotes ~1,500 words to oversmoothing — DYNAMO-GAT, the ergodic theorem, opinion dissensus, semigroup theory — and calls it "finally getting principled theoretical solutions." But **over-squashing** appears exactly once, in passing:

> "r-GAT and SGAT — relational and sparse variants that enhance expressivity for heterogeneous graphs while mitigating over-smoothing and **over-squashing**."

That's it. This is a critical omission because:

1. **Over-squashing and oversmoothing are distinct phenomena**, and conflating or ignoring one misrepresents the field's actual challenges. Oversmoothing = node representations converge with depth (a spectral property). Over-squashing = information from distant nodes is exponentially compressed through graph bottlenecks (a topological property related to the Cheeger constant and Ricci curvature). You can have one without the other.

2. **Over-squashing is the primary theoretical justification for Graph Transformers.** The note's own thesis — that GTs' advantage over MPNNs is mostly a tuning artifact — would be significantly sharpened by engaging with over-squashing. Full attention inherently bypasses graph bottlenecks, giving GTs a genuine structural advantage on tasks with long-range dependencies. The question is: *how often does that advantage matter in practice?* The note can't answer this without discussing over-squashing.

3. **Graph rewiring is an entire missing research thread.** Curvature-based rewiring (Topping et al., ICLR 2022; SDRF), Forman-Ricci curvature approaches (Fesser et al., AISTATS 2024 — "*AFRC effectively characterizes over-smoothing and over-squashing effects in message-passing GNNs*"), spectral sparsification (arXiv:2506.16110), and topological corrections (arXiv:2603.11944, March 2026: "*A Simple Topological Correction for Over-Squashing*") constitute a major approach to extending MPNN expressivity that's **orthogonal to both oversmoothing fixes and Graph Transformers**. This is arguably the third strategy besides "make GTs scalable" and "make MPNNs deeper" — and it's completely absent.

4. **Recent work questions rewiring effectiveness.** arXiv:2407.09381 (July 2024) found that "*edges selected during the rewiring process are not in line with theoretical criteria identifying bottlenecks*" on real-world data, and arXiv:2508.09265 (Aug 2025) notes "*practical impacts are unclear due to the lack of a direct empirical over-squashing metric.*" This nuance would strengthen the note's skeptical posture toward simple narratives.

**Impact on the convergence thesis:** The note argues "it's all about PE, not architecture." But over-squashing provides a counter-argument: on graphs with genuine bottleneck topology, the architecture's ability to route information globally (full attention) or locally (message-passing, even with good PE) is a *structural* difference that PE alone cannot bridge. The thesis needs to engage with this.

---

## GAP 2 (SEVERE): Equivariant / Geometric GNNs Are Completely Missing

The note identifies molecular property prediction as *"the dominant benchmark domain for comparing GAT/GCN/GT architectures"* (Section 4.3) and discusses KAN-GNN (Nature MI, Aug 2025) and ASE-Mol. But **equivariant GNNs — the actual dominant paradigm for 3D molecular tasks — are nowhere in the document.**

This is like writing a survey of computer vision in 2024 and omitting CNNs.

The missing thread:

- **NequIP** (Batatia et al., 2021; Nature Comms 2022): E(3)-equivariant message passing with irreducible representations. "*E(3)-equivariant neural network approach for learning interatomic potentials from ab-initio calculations*."
- **MACE** (Batatia et al., 2022–2024): Higher-order equivariant message passing via Atomic Cluster Expansion. MACE-MP-0 is now described as a *"foundation model for atomistic simulation … applicable throughout the periodic table"* (emergentmind.com). A paper in 2024 from the same group: "*A foundation model for atomistic materials chemistry*" (arXiv:2401.00096). MACE has Hugging Face checkpoints (mace-foundations/mace-mh-1). This is the **actual Graph Foundation Model success story** — far more concrete than the speculative GFMs in Section 4.1.
- **PaiNN**, **Allegro**, **ViSNet** (Nature Comms 2024: *"equivariant geometry-enhanced graph neural network … elegantly extracts geometric features and efficiently models molecular structures with low computational costs"*), **Equiformer** / **EquiformerV2**.
- **Universal Machine Learning Interatomic Potentials** (arXiv:2403.04217): *"A recent class of advanced MLIPs, which use equivariant representations and deep graph neural networks, is known as universal models. These models are proposed as foundation models suitable for any system."*

Why this matters:

1. **Equivariant GNNs are where GNNs have had the most real-world impact** — molecular dynamics simulations, materials discovery, drug design. The note's industry adoption section (4.4) lists Uber/Google/Pinterest for recommendation but misses the entire scientific computing adoption.

2. **MACE-MP-0 is arguably the most successful Graph Foundation Model to date**, yet the GFM section doesn't mention it. It transfers across the periodic table — precisely the kind of cross-domain transfer that Section 4.1 calls "challenging" and "unclear."

3. **The equivariance-vs-invariance debate** is a major architectural question: should the network preserve 3D symmetries explicitly (equivariant networks) or learn them from data (invariant networks with augmentation)? This connects directly to the note's PE-vs-architecture thesis — in geometric GNNs, the *structure* is 3D coordinates, and how you encode that structure matters enormously.

4. **The KAN-GNN paper (Nature MI)** cited in Section 3.4 is about molecular property prediction. Without the equivariant GNN context, the reader can't assess whether KAN-GNN matters — is it advancing beyond MACE/NequIP, or is it solving a different (2D graph) molecular task? The note doesn't distinguish 2D molecular graphs from 3D molecular geometry, which are fundamentally different problems.

---

## GAP 3 (SEVERE): LLM + Graph Integration Is Missing

The note mentions GFM-RAG and autoregressive molecular prediction, but the **entire LLM + Graph convergence** — one of the hottest research areas in 2024–2026 — is absent:

- **GraphGPT** (arXiv:2310.13023): "*graph instruction tuning … a text-graph grounding component to link textual and graph structures and a dual-stage instruction tuning approach.*"
- **LLaGA** (arXiv:2402.08170): "*reorganizing graph nodes to structure-aware sequences and then mapping these into the token embedding space through a versatile projector.*"
- **Graph-Language Models (GLMs)** as an emerging framework class (emergentmind.com, Sep 2025): "*frameworks that combine large language models with graph neural networks to jointly process textual and graph-structured data.*"
- **E-LLaGNN** (arXiv:2407.14996): "*enriches message passing procedure of graph learning by enhancing a limited fraction of nodes from the graph.*"
- Two comprehensive surveys: "*A Survey of Graph Meets Large Language Model*" (arXiv:2311.12399v4), "*A Survey of Large Language Models for Graphs*" (arXiv:2405.08011).

This gap matters because:

1. The note's Section 5 argues for "multimodal unification" as PPGT's strongest pragmatic value: *"If graph learning only needs a near-plain Transformer, then language + vision + graph unification becomes architecturally trivial."* But it doesn't mention the **actual unification attempts** already underway (GraphGPT, LLaGA). You can't argue unification is the prize without reviewing the contestants.

2. LLM+Graph integration challenges the entire framework of the note. If LLMs can handle graph tasks via text serialization (as some results suggest), then the GAT-vs-GCN-vs-GT taxonomy may be beside the point. The note should at least acknowledge this threat to its framing.

3. The GFM section (4.1) discusses Graph Foundation Models as "aspirational" but misses that LLM-based approaches may leapfrog GNN-based GFMs entirely for text-attributed graphs (social networks, citation networks, knowledge graphs).

---

## GAP 4 (MODERATE): Graph Generation / Diffusion Models

Completely absent. Graph generation via diffusion is a major research thread in 2024–2026:

- **DiGress** (Vignac et al., ICLR 2023, continued influence): Discrete denoising diffusion for graph generation.
- **Latent Graph Diffusion** (arXiv:2402.02518): "*Unifying Generation and Prediction on Graphs*" — embeds graphs in latent space, trains diffusion there. Can do conditional generation and reframes prediction as generation.
- **HOG-Diff** (arXiv:2502.04308, Feb 2025): "*Higher-Order Guided Diffusion … coarse-to-fine generation curriculum guided by higher-order topology.*"
- **Diffusion-Free Graph Generation with Next-Scale Prediction** (arXiv:2503.23612): "*diffusion models maintain permutation invariance and enable one-shot generation but require up to thousands of denoising steps.*" — an alternative approach.

This matters because graph generation is the bridge between graph learning and drug design / materials discovery / circuit design. It's also where the diffusion model revolution intersects with graph learning — a cross-cutting trend the note misses.

---

## GAP 5 (MODERATE): Benchmarking Crisis and LRGB Reassessment

The note critiques GT benchmarking via the tuned-GNN papers but doesn't discuss:

1. **"Where Did the Gap Go? Reassessing the Long-Range Graph Benchmark"** (arXiv:2309.00367, Tönshoff et al.): Found that *"Empirical evidence suggests that on these tasks Graph Transformers significantly outperform Message Passing GNNs"* — but then showed that this gap can be substantially narrowed, questioning LRGB's validity as a long-range benchmark.

2. **"A Comprehensive Benchmark For Graph Transformers"** (arXiv:2506.04765, 2025): Explicitly notes that GTs' *"applicable scenarios are still underexplored, this highlights the need to identify when and why they excel."*

3. **"On the locality bias and results in the Long Range Arena"** (arXiv:2501.14850): Found that *"while the LRA is a benchmark for long-range dependency modeling, in reality most of the performance comes from short-range dependencies."* This parallels the graph benchmarking problem.

4. **OOD generalization** (arXiv:2506.20575, June 2025): *"While graph-transformer backbones have recently outperformed traditional message-passing neural networks in multiple in-distribution benchmarks, their effectiveness under distribution shifts remains largely unexplored."*

The note makes strong claims about GT advantage being a "tuning artifact" but limits evidence to two papers. The benchmarking problem is much broader — ZINC has 12K graphs, PATTERN/CLUSTER are synthetic, and the field lacks large-scale realistic graph benchmarks comparable to ImageNet or GLUE.

---

## GAP 6 (MODERATE): The "Oversmoothing Is Solved" Overclaim

The Executive Summary states: *"oversmoothing finally getting principled theoretical solutions."* Section 5 says: *"Oversmoothing is solved in theory."* This is significantly overstated.

Counter-evidence:

1. **"A Misguided Narrative in GNN Research"** (arXiv:2506.04653, 2025 position paper): Explicitly argues that *"the influence of oversmoothing has been overstated and advocates for a further exploration of deep GNN architectures."* The premise that oversmoothing was the core blocker may itself be wrong.

2. **"Are We Measuring Oversmoothing in Graph Neural Networks Correctly?"** (arXiv:2502.04591, Feb 2025): Questions whether existing metrics for oversmoothing are even measuring the right thing.

3. **"Oversmoothing, 'Oversquashing', Heterophily, Long-Range, and more"** (arXiv:2505.15547, May 2025): A position paper noting *"the fast pace of progress around the topics of oversmoothing and oversquashing, the homophily-heterophily dichotomy, and long-range tasks, came with the consolidation of commonly accepted beliefs and assumptions that are not always true nor easy to distinguish from each other."*

4. **Practical reality:** Most practitioners still use 2–4 layer GNNs. If oversmoothing were "solved," we'd see widespread adoption of 10+ layer GNNs in production. We don't. The note acknowledges DYNAMO-GAT "enables meaningfully deep GATs (10+ layers)" but doesn't ask: *does anyone actually need 10+ layers?* The shallow-is-sufficient empirical reality goes unexamined.

---

## GAP 7 (MINOR): SGFormer "Exact All-Pair Interactions" Is Misleading

The note states:

> "**SGFormer** … Single-layer global attention with **linear complexity** w.r.t. graph size. **No approximations — exact all-pair interactions in O(N)** via a simplified attention model."

This is technically defensible but misleading. SGFormer achieves O(N) by using a **simplified** attention mechanism — essentially computing a global mean + learned residual, which is equivalent to an MPNN with a virtual node. The SGFormer paper itself frames it as *"a simple attention model that can efficiently propagate information among arbitrary nodes"* (arXiv:2306.10759v5). It's "approximation-free" in the sense that it doesn't approximate standard softmax attention — it **replaces** it with a different, simpler operation.

The note later acknowledges this correctly: *"SGFormer showed linear-complexity alternatives exist but sacrifice expressivity (equivalent to MPNN + virtual node)."* But the first mention gives a much stronger impression. A reader encountering Section 2.2 would think SGFormer achieves full softmax all-pair attention in O(N), which isn't what happens.

---

## Missing Research Threads (Beyond the Seven Gaps)

Enumerated briefly because they're each individually minor but collectively represent blind spots:

1. **Heterophily.** The homophily-heterophily dichotomy is a fundamental axis in GNN design. Graphs where connected nodes are dissimilar (heterophilic) break many GNN assumptions. Barely touched.

2. **Graph State Space Models (SSMs).** Mamba/S4-based architectures for graphs are emerging as a third path between MPNNs and full attention. The note discusses Transformers and MPNNs only.

3. **Self-supervised learning on graphs.** GraphMAE, BGRL, CCA-SSG — pre-training objectives are critical for GFMs but discussed only obliquely.

4. **Graph contrastive learning.** GraphCL, GRACE, GCA — a major pre-training paradigm, absent.

5. **Subgraph GNNs / higher-order WL.** Referenced in the BREC discussion (I2GNN, k-WL) but never explained. A reader unfamiliar with the expressivity hierarchy can't evaluate the BREC results.

6. **PE scalability.** The note's central thesis is "PE over architecture." But computing good PE (Laplacian eigenvectors = O(N³), random walk PE = depends on walk length and graph size) has its own cost. For billion-edge graphs (Section 4.2), can you even compute the PE that PPGT needs? This is a first-order constraint on the thesis that goes unaddressed.

---

## Analytical Strengths Worth Preserving

To be clear about what works exceptionally well:

1. **The PPGT deep dive** is outstanding — the identification of LayerNorm destroying magnitude information and SDP attention's angular bias is presented with unusual clarity. The three-fix explanation is better than the original paper's abstract.

2. **The convergence table** (Tuned-GNN / PPGT / CKGConv) synthesizes three paper families into a unified insight that I haven't seen stated this cleanly elsewhere.

3. **The "treating symptoms, not causes" framing** for why existing GTs added message-passing layers is genuinely incisive.

4. **The "information asymmetry, not just tuning asymmetry" extension** of the tuned-GNN argument is original analytical value-add.

---

## Summary of Recommended Additions

| Priority | Gap | Estimated Effort |
|---|---|---|
| **P0** | Over-squashing + graph rewiring as distinct from oversmoothing | New section + revise convergence thesis |
| **P0** | Equivariant/geometric GNNs (MACE, NequIP, etc.) | New section; revise GFM and molecular sections |
| **P0** | LLM + Graph integration | New section or integrate into GFM |
| **P1** | Downgrade "oversmoothing is solved" claim | Revise exec summary + Section 5 |
| **P1** | Graph generation / diffusion models | New subsection in cross-cutting |
| **P1** | Benchmarking methodology (LRGB reassessment, OOD) | Expand Section 5 |
| **P2** | PE scalability as constraint on convergence thesis | Add to PPGT deep dive |
| **P2** | Fix SGFormer "exact" framing | Edit Section 2.2 |
| **P3** | Heterophily, Graph SSMs, SSL, subgraph GNNs | Brief mentions in cross-cutting |

The note's intellectual spine — the PE-over-architecture convergence thesis — is sound and well-argued. But it currently lives in a world of 2D benchmarks (ZINC, PATTERN, OGB) and node/graph classification. The three severe gaps (over-squashing, equivariant GNNs, LLM+graph) represent entire *problem domains* where that thesis hasn't been tested and may not hold. Filling them would either strengthen the argument or reveal its boundaries — both valuable outcomes.
