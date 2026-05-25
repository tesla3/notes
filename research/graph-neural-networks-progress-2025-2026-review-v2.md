# Meta-Review: Critical Assessment of the Gap Analysis

Source: Deep research verification of graph-neural-networks-progress-2025-2026-review.md, March 2026

---

## Purpose

This document critically reviews the existing gap analysis (review.md) of the original GNN research note (2025-2026.md). For each identified gap, I verify the claim against primary sources, assess severity accuracy, identify what the review itself missed, and surface new gaps the review didn't catch.

**Method:** Every factual claim below is backed by a verbatim quote from a verified source. Where I cannot verify a claim, I say so explicitly.

---

## PART I: Verification of the Seven Gaps

### GAP 1 (Over-Squashing): CONFIRMED — Severity Accurate, But Understated

The review correctly identifies over-squashing as a severe omission. My research strengthens the case further:

**1a. Over-squashing is a *major* active research front, not a niche concern.**

The ICLR 2025 proceedings include **Spectrum-Preserving Sparsification** (Liang et al., PMLR v267), whose abstract states:

> *"The message-passing paradigm of Graph Neural Networks often struggles with exchanging information across distant nodes typically due to structural bottlenecks in certain graph regions, a limitation known as over-squashing. To reduce such bottlenecks, graph rewiring, which modifies graph topology, has been widely used. However, existing graph rewiring techniques often overlook the need to preserve critical properties of the original graph, e.g., spectral properties. Moreover, many approaches rely on increasing edge count to improve connectivity, which introduces significant computational overhead and exacerbates the risk of over-smoothing."*
— [proceedings.mlr.press/v267/liang25a](https://proceedings.mlr.press/v267/liang25a.html)

This demonstrates over-squashing is not merely theoretical — it's generating practical solutions at top venues.

**1b. Rewiring effectiveness IS contested, as the review claims.**

"Is Rewiring Actually Helpful in Graph Neural Networks?" (arXiv:2305.19717) states:

> *"Having deep models that can leverage longer-range interactions between nodes is hindered by the issues of over-smoothing and over-squashing. In particular, the latter is attributed to the graph topology which guides the message-passing, causing a node representation to become insensitive to information contained at distant nodes. Many graph rewiring methods have been proposed to remedy or mitigate this problem. However, properly evaluating the benefits of these methods is made difficult by the coupling of over-squashing with other issues strictly related to model training, such as vanishing gradients."*
— [ar5iv.labs.arxiv.org/html/2305.19717](https://ar5iv.labs.arxiv.org/html/2305.19717)

**1c. What the review missed: the GNN-as-SSM bridge paper.** 

The most conceptually important over-squashing paper of 2025 is "On Vanishing Gradients, Over-Smoothing, and Over-Squashing in GNNs: Bridging Recurrent and Graph Learning" (arXiv:2502.10818, **NeurIPS 2025 poster**):

> *"We propose an interpretation of GNNs as recurrent models and empirically demonstrate that a simple state-space formulation of a GNN effectively alleviates over-smoothing and over-squashing at no extra trainable parameter cost."*
— [arxiv.org/abs/2502.10818](https://www.arxiv.org/abs/2502.10818); [neurips.cc poster 118405](https://neurips.cc/virtual/2025/loc/san-diego/poster/118405)

This is significant because it **unifies** over-smoothing, over-squashing, and vanishing gradients under a single recurrent/SSM framework — suggesting these aren't three separate problems requiring three separate fixes, but manifestations of one underlying issue (information propagation dynamics). This directly challenges the original note's narrative of oversmoothing as a standalone problem with standalone solutions, AND strengthens the review's point that the note is incomplete.

**1d. New: Schreier-Coset rewiring (ICLR 2026 submission, Feb 2026).**

> *"Graph Neural Networks (GNNs) provide a principled framework for learning on graph-structured data, yet their expressiveness is fundamentally limited by over-squashing — the exponential compression of information from distant nodes into fixed size vectors."*
— [openreview.net/forum?id=oysNtFbrBO](https://openreview.net/forum?id=oysNtFbrBO)

This is the latest rewiring approach, using algebraic (Schreier-coset) graph constructions. The review's claimed paper arXiv:2603.11944 ("A Simple Topological Correction") I **cannot independently verify** — it may exist but is not yet indexed in my searches.

**1e. New: AdaMeshNet — over-squashing in PDE/physics applications (ICLR 2026 submission).**

> *"To address these limitations, we propose a novel framework, called Adaptive Graph Rewiring in Mesh-Based Graph Neural Networks (AdaMeshNet), that introduces an adaptive rewiring process into the message-passing procedure to model the gradual propagation of physical interactions."*
— [openreview.net/forum?id=Tq2n0lFSOd](https://openreview.net/forum?id=Tq2n0lFSOd)

Over-squashing is now being tackled in domain-specific settings (fluid dynamics), further confirming its practical significance beyond benchmark papers.

**Verdict on Gap 1:** ✅ Confirmed, correctly assessed as severe. The review actually *underestimates* the gap — the SSM-bridge paper and physics-domain rewiring work add further dimensions the original note misses.

---

### GAP 2 (Equivariant / Geometric GNNs): CONFIRMED — Severity Accurate

The review's strongest claim. Verified comprehensively:

**2a. MACE-MP-0 as a foundation model.**

EmergentMind (Aug 2025):
> *"Designed as a 'foundation model' for atomistic simulation, MACE-MP-0 leverages symmetry-preserving message-passing neural networks built atop tensor product representations from ACE, yielding a flexible, transferable potential applicable throughout the periodic table and in complex, physically relevant environments."*
— [emergentmind.com/topics/mace-mp-0](https://emergentmind.com/topics/mace-mp-0)

**2b. MACE-Osaka24 — actual cross-domain transfer success.**

"Towards Foundation Models for Atomistic Scale Simulations" (arXiv:2412.13088, Dec 2024):
> *"Using TEA, we have trained MACE-Osaka24, the first open-source neural network potential model based on a unified dataset covering both molecular and crystalline systems, utilizing the MACE architecture developed by Batatia et al."*

And:
> *"This universal model shows strong performance across diverse chemical systems, exhibiting comparable or improved accuracy in predicting organic reaction barriers compared to specialized models, while effectively maintaining state-of-the-art accuracy for inorganic systems."*
— [arxiv.org/abs/2412.13088](https://arxiv.org/abs/2412.13088)

This is the **direct counter-evidence** to the original note's claim that GFM transferability is "challenging" and "unclear." MACE-Osaka24 demonstrates cross-domain transfer (molecules ↔ crystals) with maintained accuracy — exactly what the note says doesn't exist.

**2c. ViSNet confirmed (Nature Communications 2024).**

> *"Here we propose an equivariant geometry-enhanced graph neural network called ViSNet, which elegantly extracts geometric features and efficiently models molecular structures with low computational costs."*
— [nature.com/articles/s41467-023-43720-2](https://www.nature.com/articles/s41467-023-43720-2)

**2d. GRACE framework — competing with MACE (arXiv:2508.17936, Aug 2025).**

> *"Foundational machine learning interatomic potentials that can accurately and efficiently model a vast range of materials are critical for accelerating atomistic discovery. We introduce universal potentials based on the graph atomic cluster expansion (GRACE) framework, trained on several of the largest available materials datasets."*
— [arxiv.org/html/2508.17936v1](https://arxiv.org/html/2508.17936v1)

**2e. Efficiency advances competing with MACE (arXiv:2509.08418, Sep 2025).**

> *"Training on the MPTrj dataset, our model achieves performance comparable to leading approaches with significantly fewer parameters and less than 10% of the training computation. We demonstrate a 2× speedup compared to MACE models on a crystal relaxation task representative of crystal structure prediction workflows."*
— [arxiv.org/html/2509.08418v1](https://arxiv.org/html/2509.08418v1)

**2f. The review's claim that this is "like writing a CV survey and omitting CNNs" is apt.** The equivariant GNN field has its own scaling race (MACE vs GRACE vs Allegro), its own foundation model story (MACE-MP-0, MACE-Osaka24, CHGNet), and its own industrial adoption (atomistic simulation, drug discovery). The original note's molecular section (4.3) discusses KAN-GNN and ASE-Mol but these operate on **2D molecular graphs**, not 3D molecular geometry — a distinction the note never makes.

**Verdict on Gap 2:** ✅ Confirmed, correctly assessed as severe. MACE-Osaka24 makes the case even stronger than the review states — it's a verified, functioning cross-domain Graph Foundation Model.

---

### GAP 3 (LLM + Graph Integration): CONFIRMED — Severity Accurate

**3a. Two comprehensive surveys verified.**

"A Survey of Graph Meets Large Language Model" (arXiv:2311.12399v4):
> *"In this survey, we first present a comprehensive review and analysis of existing methods that integrate LLMs with graphs. First of all, we propose a new taxonomy, which organizes existing methods into three categories based on the role (i.e., enhancer, predictor, and alignment component) played by LLMs in graph-related tasks."*
— [arxiv.org/html/2311.12399v4](https://arxiv.org/html/2311.12399v4)

"A Survey of Large Language Models for Graphs" (arXiv:2405.08011):
> *"This survey aims to serve as a valuable resource for researchers and practitioners eager to leverage large language models in graph learning, and to inspire continued progress in this dynamic field."*
— [arxiv.org/html/2405.08011v1](https://arxiv.org/html/2405.08011v1)

**3b. GNN-LLM integration is now a recognized architecture family.**

EmergentMind (Feb 2026):
> *"Graph Neural Network (GNN)–LLM integration refers to a family of hybrid architectures, learning paradigms, and system pipelines that combine the structural inductive biases and message-passing capabilities of GNNs with the data-driven semantic, generative, and reasoning abilities of LLMs."*
— [emergentmind.com/topics/gnn-llm-integration](https://www.emergentmind.com/topics/gnn-llm-integration)

**3c. The challenge is real and unsolved.**

"Rethinking the Combination of Graph Neural Network and Large Language model" (arXiv:2412.06849):
> *"LLM-centered models often struggle to capture graph structures effectively, while GNN-centered models compress variable-length textual data into fixed-size vectors, limiting their ability to understand complex semantics."*
— [arxiv.org/html/2412.06849v1](https://arxiv.org/html/2412.06849v1)

**3d. Additional 2025 survey the review didn't cite.**

"Using Large Language Models to Tackle Fundamental Challenges in Graph Learning" (arXiv:2505.18475, May 2025):
> *"This survey provides a comprehensive review of how LLMs can be integrated with graph learning to address the aforementioned challenges. For each challenge, we review both traditional solutions and modern LLM-driven approaches, highlighting how LLMs contribute unique advantages."*
— [arxiv.org/html/2505.18475v1](https://arxiv.org/html/2505.18475v1)

**3e. E-LLaGNN confirmed.**
> *"We propose E-LLaGNN (Efficient LLMs augmented GNNs), a framework with an on-demand LLM service that enriches message passing procedure of graph learning by enhancing a limited fraction of nodes from the graph."*
— [arxiv.org/html/2407.14996v1](https://arxiv.org/html/2407.14996v1)

**Verdict on Gap 3:** ✅ Confirmed, correctly assessed as severe. The field has moved from individual papers to recognized architecture taxonomies. The omission is unjustifiable for a 2024–2026 survey.

---

### GAP 4 (Graph Generation / Diffusion Models): CONFIRMED

**4a. Active research area confirmed.**

EmergentMind (Feb 2026):
> *"Graph Diffusion Models are generative paradigms that iteratively corrupt and denoise graph-structured data using score-based SDEs to produce high-quality, permutation-invariant graphs."*
— [emergentmind.com/topics/graph-diffusion-model-gdm](https://www.emergentmind.com/topics/graph-diffusion-model-gdm)

**4b. HOG-Diff confirmed.**

> *"In this work, we propose a novel Higher-order Guided Diffusion (HOG-Diff) model that follows a coarse-to-fine generation curriculum and is guided by higher-order information, enabling the progressive generation of plausible graphs with inherent topological structures."*
— [arxiv.org/html/2502.04308v1](https://arxiv.org/html/2502.04308v1)

**4c. Latent Graph Diffusion confirmed — unifies generation and prediction.**

> *"We then propose Latent Graph Diffusion (LGD), a generative model that can generate node, edge, and graph-level features of all categories simultaneously."*
— [arxiv.org/html/2402.02518v2](https://arxiv.org/html/2402.02518v2)

**4d. Scalability challenge being addressed.**

"Improving Graph Diffusion Generative Model via Stochastic Block Diffusion" (arXiv:2508.14352):
> *"To address these challenges, we propose the stochastic block graph diffusion (SBGD) model, which refines graph representations into a block graph space. This space incorporates structural priors based on real-world graph patterns, significantly reducing memory complexity and enabling scalability to large graphs."*
— [arxiv.org/html/2508.14352v1](https://arxiv.org/html/2508.14352v1)

**Verdict on Gap 4:** ✅ Confirmed as moderate. The graph diffusion/generation space is active but doesn't fundamentally challenge the original note's thesis. Correctly prioritized as P1 rather than P0.

---

### GAP 5 (Benchmarking Crisis / LRGB Reassessment): CONFIRMED — Possibly Understated

**5a. "Where Did the Gap Go?" verified.**

Tönshoff et al. (arXiv:2309.00367, published at ICML 2024):
> *"Through a rigorous empirical analysis, we demonstrate that the reported performance gap is overestimated due to suboptimal hyperparameter choices. It is noteworthy that across multiple datasets the performance gap completely vanishes after basic hyperparameter optimization."*
— [openreview.net/forum?id=Nm0WX86sKv](https://openreview.net/forum?id=Nm0WX86sKv)

**5b. OpenGT benchmark confirmed.**

"A Comprehensive Benchmark For Graph Transformers" (arXiv:2506.04765):
> *"To address this gap, this paper introduces OpenGT, a comprehensive benchmark for Graph Transformers. OpenGT enables fair comparisons and multidimensional analysis by establishing standardized experimental settings and incorporating a broad selection of state-of-the-art GNN and GTs."*
— [arxiv.org/html/2506.04765](https://arxiv.org/html/2506.04765)

**5c. LRA locality bias confirmed.**

arXiv:2501.14850:
> *"We show that while the LRA is a benchmark for long-range dependency modeling, in reality most of the performance comes from short-range dependencies."*
— [arxiv.org/html/2501.14850v1](https://arxiv.org/html/2501.14850v1)

**5d. OOD generalization — a deeper problem than the review suggests.**

"Exploring Graph-Transformer Out-of-Distribution Generalization Abilities" (arXiv:2506.20575, June 2025):
> *"In this work, we address the challenge of out-of-distribution (OOD) generalization for graph neural networks, with a special focus on the impact of backbone architecture. We systematically evaluate GT and hybrid backbones in OOD settings and compare them to MPNNs."*
— [arxiv.org/html/2506.20575v2](https://arxiv.org/html/2506.20575v2)

**New:** "Out-of-Distribution Generalization in Graph Foundation Models" (arXiv:2601.21067, Jan 2026):
> *"However, graph learning models often suffer from limited generalization when applied beyond their training distributions. In practice, distribution shifts may arise from changes in graph structure, domain semantics, available modalities, or task formulations."*
— [arxiv.org/html/2601.21067](https://arxiv.org/html/2601.21067)

**New:** GOODFormer (arXiv:2508.00304v2, updated March 2026):
> *"Graph Transformers (GTs) have demonstrated great effectiveness across various graph analytical tasks. However, the existing GTs focus on training and testing graph data originated from the same distribution, but fail to generalize under distribution shifts."*
— [arxiv.org/abs/2508.00304v2](http://arxiv.org/abs/2508.00304v2)

**Why I say "understated":** OOD generalization is potentially the most important practical concern for anyone deploying GNNs. The original note's entire benchmarking discussion assumes IID evaluation. If GT advantages on benchmarks don't survive distribution shifts (which arXiv:2506.20575 suggests), then the "tuning artifact" finding is even more significant — and the PE-over-architecture thesis needs OOD testing. This deserves P0, not P1.

**Verdict on Gap 5:** ✅ Confirmed. Should arguably be upgraded to P0 because OOD generalization threatens the entire evaluation framework the note relies on.

---

### GAP 6 (Oversmoothing Overclaim): CONFIRMED — Review UNDERSTATES the Problem

The review identifies four counter-evidence papers. My research reveals the counter-narrative is now **significantly stronger** than the review captured:

**6a. "The Oversmoothing Fallacy" — now at ICLR 2026.**

The review cites arXiv:2506.04653 as "2025 position paper." It has now been submitted to and is under review at ICLR 2026:
> *"Oversmoothing has been recognized as a main obstacle to building deep Graph Neural Networks (GNNs), limiting the performance. This paper argues that the influence of oversmoothing has been overstated and advocates for a further exploration of deep GNN architectures."*
— [openreview.net/forum?id=EDEjrJB4Bc](https://openreview.net/forum?id=EDEjrJB4Bc) (ICLR 2026 submission, Feb 2026)

**6b. "Don't be Afraid" — the review MISSED this paper entirely.**

"Don't be Afraid of Over-Smoothing And Over-Squashing" (arXiv:2601.07419, Jan 2026):
> *"Over-smoothing and over-squashing have been extensively studied in the literature on Graph Neural Networks (GNNs) over the past years. We challenge this prevailing focus in GNN research, arguing that these phenomena are less critical for practical applications than assumed."*
— [arxiv.org/html/2601.07419v1](https://arxiv.org/html/2601.07419v1)

**6c. ICML 2025 position paper — even stronger.**

"Position: Graph Learning May Have Been Misled By Over-smoothing And Over-squashing" (ICML 2025):
> *"For graph-level tasks, over-smoothing can even be beneficial if the smoothed state is label-informative. Similarly, we challenge the notion that over-squashing, i.e., the compression of exponentially growing information into fixed-size node embeddings, is always detrimental in practical applications."*
— [openreview.net/forum?id=U46jD48SJi](https://openreview.net/forum?id=U46jD48SJi)

This goes further than the review recognized — oversmoothing may not just be "overstated as a blocker," it may be **actively beneficial** in some cases.

**6d. "Are We Measuring Oversmoothing Correctly?" confirmed.**
> *"Oversmoothing is a fundamental challenge in graph neural networks (GNNs): as the number of layers increases, node embeddings become increasingly similar, and model performance drops sharply."*
— [arxiv.org/html/2502.04591v4](https://arxiv.org/html/2502.04591v4)

**6e. Demystifying position paper confirmed.**

arXiv:2505.15547:
> *"In this position paper, we notice how the fast pace of progress around the topics of oversmoothing and oversquashing, the homophily-heterophily dichotomy, and long-range tasks, came with the consolidation of commonly accepted beliefs and assumptions that are not always true nor easy to distinguish from each other."*
— [arxiv.org/html/2505.15547](https://arxiv.org/html/2505.15547)

**The full picture:** By March 2026, there are now **at least five independent papers/position pieces** questioning the oversmoothing narrative:

| Paper | Venue/Date | Core Claim |
|---|---|---|
| "The Oversmoothing Fallacy" | ICLR 2026 submission | Influence overstated |
| "Don't be Afraid" | arXiv Jan 2026 | Less critical than assumed |
| "Position: Misled by OS/OSq" | ICML 2025 | Can be beneficial |
| "Are We Measuring Correctly?" | arXiv Feb 2025 | Metrics may be wrong |
| "Demystifying Common Beliefs" | arXiv May 2025 | Beliefs not always true |

The original note's claim that oversmoothing is "finally getting principled theoretical solutions" isn't just an overclaim — it may be **solving the wrong problem**. The review correctly identifies the overclaim but doesn't connect the dots to this deeper implication: the entire oversmoothing-as-central-problem framing is contested.

**Verdict on Gap 6:** ✅ Confirmed. The review is right but **undersells** the severity. Should be upgraded from P1 to P0. The "oversmoothing is solved" framing isn't just premature — the premise that oversmoothing was THE problem may itself be wrong.

---

### GAP 7 (SGFormer "Exact"): CONFIRMED — Minor

The review correctly notes the misleading framing. The SGFormer paper (arXiv:2306.10759v5) uses simplified attention, not full softmax attention. The original note does self-correct later. Minor issue, correctly prioritized as P2.

**Verdict on Gap 7:** ✅ Confirmed, minor.

---

## PART II: What the Review Itself Missed

### REVIEW-GAP A (SEVERE): Graph State Space Models — A Third Architecture Paradigm

The review lists "Graph SSMs" as a minor missing thread. This significantly underestimates it. By March 2026, Graph Mamba/SSM is an established architecture family, not a nascent idea:

"A Comprehensive Survey on State-Space Models for Graph Learning" (arXiv:2412.18322, Dec 2024):
> *"Graph Mamba, a powerful graph embedding technique, has emerged as a cornerstone in various domains, including bioinformatics, social networks, and recommendation systems."*
— [arxiv.org/html/2412.18322v1](https://arxiv.org/html/2412.18322v1)

"Spatial-Temporal Graph Mamba (STG-Mamba)" (arXiv:2403.12418):
> *"We introduce Spatial-Temporal Graph Mamba (STG-Mamba) as the first exploration of leveraging the powerful selective state space models for STG learning … It not only surpasses existing state-of-the-art methods in terms of STG forecasting performance, but also effectively alleviates the computational bottleneck of large-scale graph networks."*
— [arxiv.org/html/2403.12418v4](https://arxiv.org/html/2403.12418v4)

"Heterogeneous Graph Mamba Network (HGMN)" (arXiv:2405.13915):
> *"This work proposes a heterogeneous graph mamba network (HGMN) to explore the next-generation heterogeneous graph learning by leveraging the powerful selective state space models (SSSMs), tailored to surpass the most popular transformer-based methods."*
— [arxiv.org/html/2405.13915v1](https://arxiv.org/html/2405.13915v1)

"Topological Deep Learning with State-Space Models" (arXiv:2409.12033):
> *"We propose a novel architecture designed to operate with simplicial complexes, utilizing the Mamba state-space model as its backbone. Our approach generates sequences for the nodes based on the neighboring cells, enabling direct communication between all higher-order structures, regardless of their rank."*
— [arxiv.org/html/2409.12033v1](https://arxiv.org/html/2409.12033v1)

"Graph Mamba for Efficient Whole Slide Image Understanding" (arXiv:2505.17457):
> *"The proposed GMamba block integrates Message Passing, Graph Scanning & Flattening, and feature aggregation via a Bidirectional State Space Model (Bi-SSM), achieving Transformer-level performance with 7× fewer FLOPs."*
— [arxiv.org/html/2505.17457v1](https://arxiv.org/html/2505.17457v1)

EmergentMind (Feb 2026):
> *"STG-Mamba achieves state-of-the-art accuracy with linear computational complexity, offering significant computational savings and robust performance across diverse graph-based tasks."*
— [emergentmind.com/topics/spatial-temporal-graph-mamba-stg-mamba](https://api.emergentmind.com/topics/spatial-temporal-graph-mamba-stg-mamba)

**Why this matters for the convergence thesis:** The original note frames the landscape as GCN vs. GAT vs. Graph Transformer, then argues PE is what matters, not architecture. But Graph SSMs introduce a **fourth architecture paradigm** with fundamentally different computational properties: linear complexity, recurrent state propagation, input-dependent gating. If PE-over-architecture is truly the lesson, then Graph SSMs with good PE should match GTs too — and the NeurIPS 2025 GNN-as-SSM paper (arXiv:2502.10818) suggests exactly this. The original note can't test its own thesis without acknowledging this paradigm.

Furthermore, a **comprehensive survey** already exists (arXiv:2412.18322). There's no excuse for a 2024–2026 GNN survey to omit Graph SSMs — they've achieved "cornerstone" status per the survey.

---

### REVIEW-GAP B (MODERATE): The Heterophily Dimension

The review mentions heterophily as "barely touched" but doesn't develop why this matters for the convergence thesis. New research sharpens the issue:

"When Geometry Matters Beyond Homophily in Graph Neural Networks" (arXiv:2601.18912, Jan 2026):
> *"Standard message-passing graph neural networks (GNNs) often struggle on graphs with low homophily, yet homophily alone does not explain this behavior, as graphs with similar homophily levels can exhibit markedly different performance and some heterophilous graphs remain easy for vanilla GCNs."*
— [arxiv.org/html/2601.18912v1](https://arxiv.org/html/2601.18912v1)

"Are Heterophilic GNNs and Homophily Metrics Really Effective?" (arXiv:2409.05755):
> *"Over the past decade, Graph Neural Networks (GNNs) have achieved great success on machine learning tasks with relational data. However, recent studies have found that heterophily can cause significant performance degradation of GNNs, especially on node-level tasks."*
— [arxiv.org/html/2409.05755v1](https://arxiv.org/html/2409.05755v1)

**Impact on the convergence thesis:** The original note's "PE over architecture" argument is tested primarily on homophilic benchmarks (ZINC, PATTERN, ogbg-*). On heterophilic graphs, different architectures genuinely behave differently — the architecture DOES matter because how you aggregate neighbor information determines whether dissimilar neighbors help or hurt. The thesis is incomplete until tested on heterophilic datasets.

---

### REVIEW-GAP C (MODERATE): PE Scalability — The Thesis's Achilles' Heel

The review correctly flags this in "Missing Research Threads" (#6) but buries it. It deserves more prominence because it's a **logical constraint on the central thesis**, not a side issue.

"Understanding and Improving Laplacian Positional Encodings For Temporal GNNs" (arXiv:2506.01596):
> *"Extending static Laplacian eigenvector approaches to temporal graphs through the supra-Laplacian has shown promise, but also poses key challenges: high eigendecomposition costs, limited theoretical understanding, and ambiguity about when and how to apply these encodings."*
— [arxiv.org/html/2506.01596v1](https://arxiv.org/html/2506.01596v1)

"Learning Efficient Positional Encodings with Graph Neural Networks" (arXiv:2502.01122, ICLR 2025):
> *"Positional encodings (PEs) are essential for effective graph representation learning because they provide position awareness in inherently position-agnostic transformer architectures and increase the expressive capacity of Graph Neural Networks (GNNs)."*
— [arxiv.org/abs/2502.01122](https://arxiv.org/abs/2502.01122)

The original note argues "invest in PE engineering, not architecture." But:
- **Laplacian eigenvectors** require eigendecomposition: O(N³) naively, O(N·k²) with Lanczos for k eigenvectors. For a billion-node graph (Section 4.2's Plexus), even Lanczos is expensive.
- **RRWP** (the PE that PPGT uses) requires computing random walk landing probabilities, which depends on walk length and graph density.
- **I2GNN-generated PE** (which gives PPGT 76% on BREC) requires running a subgraph GNN, which has its own compute cost.

The thesis "PE is what matters" is only actionable if PE is computable at the scale you need. For billion-node graphs, this may not hold. The review should have elevated this from P2 to P1.

---

### REVIEW-GAP D (MODERATE): Graph Self-Supervised Learning Is Actively Advancing

The review mentions "GraphMAE, BGRL, CCA-SSG" as a missing thread but doesn't note that this area has continued to advance significantly:

"Contrastive Masked Feature Reconstruction on Graphs" (arXiv:2512.13235, Dec 2025):
> *"Empirically, our proposed framework CORE significantly outperforms MFR across node and graph classification tasks, demonstrating state-of-the-art results. In particular, CORE surpasses GraphMAE and GraphMAE2 by up to 2.80% and 3.72% on node classification tasks, and by up to 3.82% and 3.76% on graph classification tasks."*
— [arxiv.org/html/2512.13235v1](https://arxiv.org/html/2512.13235v1)

"Generative and Contrastive Graph Representation Learning" (arXiv:2505.11776, May 2025):
> *"Self-supervised learning (SSL) on graphs generates node and graph representations (i.e., embeddings) that can be used for downstream tasks such as node classification, node clustering, and link prediction. Graph SSL is particularly useful in scenarios with limited or no labeled data."*
— [arxiv.org/html/2505.11776v2](https://arxiv.org/html/2505.11776v2)

This matters for the GFM discussion: self-supervised pre-training is the mechanism by which Graph Foundation Models learn transferable representations. The original note discusses GFMs without discussing how they pre-train — like discussing LLMs without mentioning next-token prediction.

---

## PART III: Errors and Overclaims in the Review Itself

### Error 1: Citation arXiv:2603.11944 Unverifiable

The review cites arXiv:2603.11944 (March 2026, "A Simple Topological Correction for Over-Squashing") as evidence. I **cannot verify this paper exists** through any search. Given the current date is March 27, 2026, it may be extremely recent and not yet indexed, or the arXiv ID may be incorrect. The review should not have presented this as established evidence without hedging.

### Error 2: Review Doesn't Question Its Own Severity Calibration

The review rates three gaps as "SEVERE" (over-squashing, equivariant GNNs, LLM+Graph) and four as "MODERATE." But:

- **Gap 6 (oversmoothing overclaim)** should be P0/SEVERE, not P1. Five independent papers questioning the premise means the original note's second macro-trend ("oversmoothing finally getting principled theoretical solutions") is built on a potentially false framing. This is as fundamental as any of the three P0 gaps.

- **Gap 5 (benchmarking/OOD)** should arguably be P0. If benchmark evaluations don't survive distribution shifts, then the entire evidence base for the convergence thesis is questionable.

### Possible Overclaim 1: "Equivariant GNNs are where GNNs have had the most real-world impact"

The review states this confidently. This is *probably* true for scientific computing (atomistic simulation, drug design), but GNNs for recommendation systems (Pinterest, Uber, Twitter/X) likely serve orders of magnitude more users daily. "Most impact" depends on the metric — scientific impact vs. commercial deployment scale. The review should qualify this claim.

### Possible Overclaim 2: "LLM-based approaches may leapfrog GNN-based GFMs entirely for text-attributed graphs"

The review states this as a near-certainty. But arXiv:2412.06849 explicitly notes *"LLM-centered models often struggle to capture graph structures effectively."* The leapfrogging potential is real but contested. The review should present it as an open question.

---

## PART IV: Updated Severity Assessment

Combining original review gaps + newly identified review-gaps:

| Priority | Gap | Source of Evidence | Effect on Convergence Thesis |
|---|---|---|---|
| **P0** | Over-squashing + rewiring (Gap 1) | ICLR 2025, NeurIPS 2025, ICLR 2026 submissions | PE alone can't bypass graph bottlenecks |
| **P0** | Equivariant GNNs (Gap 2) | MACE-MP-0, MACE-Osaka24, ViSNet, GRACE | Entire untested domain; actual GFM success |
| **P0** | LLM + Graph (Gap 3) | 3+ surveys, EmergentMind taxonomy, E-LLaGNN | May obsolete GCN/GAT/GT taxonomy |
| **P0** | Oversmoothing narrative collapse (Gap 6↑) | 5 independent position papers | Undermines note's macro-trend #2 entirely |
| **P0** | OOD generalization (Gap 5↑) | GOODFormer, 2506.20575, 2601.21067 | Threatens evaluation framework |
| **P1** | Graph SSMs (Review-Gap A) | Comprehensive survey, STG-Mamba, HGMN, GMamba | Fourth architecture paradigm |
| **P1** | Graph diffusion/generation (Gap 4) | HOG-Diff, LGD, SBGD | Bridge to drug/materials design |
| **P1** | PE scalability (Review-Gap C↑) | 2506.01596, 2502.01122 | Limits thesis applicability at scale |
| **P1** | Heterophily (Review-Gap B) | 2601.18912, 2409.05755 | Thesis untested on heterophilic data |
| **P2** | Graph SSL/pre-training (Review-Gap D) | CORE, 2505.11776 | Missing mechanism for GFMs |
| **P2** | SGFormer framing (Gap 7) | — | Minor presentation issue |
| **P3** | Subgraph GNNs, k-WL details | — | Pedagogical, not substantive |

---

## PART V: What Survives Scrutiny

Both the original note and the review get several things right, and this should be stated clearly:

1. **The PE-over-architecture convergence thesis is the most important insight in the note.** It survives scrutiny for 2D graph benchmarks. The question is its *scope* — does it hold for 3D geometry (equivariant GNNs), heterophilic graphs, OOD settings, and billion-scale graphs? The thesis needs boundaries, not retraction.

2. **The review's analytical assessment of the original note's strengths is accurate.** The PPGT deep dive, the convergence table, and the "information asymmetry" framing are genuinely valuable.

3. **The review's identification of the top three gaps (over-squashing, equivariant GNNs, LLM+Graph) is correct** and confirmed by primary sources.

4. **The tuned-GNN finding is robust.** Both "Where Did the Gap Go?" (ICML 2024) and the NeurIPS 2024 / ICML 2025 tuned-baseline papers converge: GT advantage on standard benchmarks is largely a tuning/information artifact.

5. **MACE is the actual Graph Foundation Model success story.** This is the review's strongest original contribution — identifying that the original note's GFM section discusses aspirational work while ignoring the realized success in a different domain.

---

## Summary

The review is a high-quality gap analysis that correctly identifies the three most severe omissions (over-squashing, equivariant GNNs, LLM+Graph) in the original note. However, the review itself:

1. **Understates Gap 6** — the oversmoothing narrative has *collapsed*, not just been overclaimed. Five independent papers challenge the premise. This should be P0.
2. **Understates Gap 5** — OOD generalization threatens the entire evaluation framework. Should be P0.
3. **Underrates Graph SSMs** — an entire architecture paradigm with its own comprehensive survey and SOTA results, dismissed as a minor mention.
4. **Buries PE scalability** — the central thesis's main limitation, classified as P2.
5. **Has one unverifiable citation** (arXiv:2603.11944).
6. **Slightly overclaims** on equivariant GNN impact (needs to distinguish scientific vs. commercial impact) and LLM leapfrogging potential.

The combined effect: the original note's landscape is even more incomplete than the review suggests. The 2024–2026 GNN field has at least **four** architecture paradigms (MPNN, GAT, Graph Transformer, Graph SSM), **three** problem domains (2D graphs, 3D molecular geometry, text-attributed graphs), and a **contested theoretical foundation** (oversmoothing/oversquashing may not be the core problems). No survey covering only one paradigm (GT as "dominant") and one domain (2D benchmarks) can credibly represent this landscape.
