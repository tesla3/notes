# Graph & Graph Modeling Research: Synthesis of Insights (v3)

Source: Synthesis across 8 research notes + two rounds of critical review with web-verified sources, March 2026

---

## Tier 1 — Paradigm-Level Insights

### 1. Structural Information Injection Dominates Architecture Choice — Within Scope

Three independent paper families converge: **what structural information you give the model matters more than whether it's a GCN, GAT, or Transformer.**

- **Tuned-GNN** (NeurIPS 2024): *"With slight hyperparameter tuning, these classic GNN models achieve state-of-the-art performance, matching or even exceeding that of recent GTs across 17 out of the 18 diverse datasets examined."* — arXiv:2406.08993v2
- **CKGConv** (ICML 2024): Continuous kernels on pseudo-coordinates prove GCN matches GT expressiveness. — proceedings.mlr.press/v235/ma24k
- **PPGT** (arXiv:2504.12588v3, 2025–2026): *"The expressivity bottleneck of our PPGT model does not stem from its architecture, but rather from the design of positional encodings."* With I²GNN-derived PE, PPGT reaches 76% on BREC — surpassing all standalone methods.

The ICML 2025 extension confirms for graph-level tasks: *"contrary to prevailing beliefs, these classic GNNs consistently match or surpass the performance of GTs, securing top-three rankings across all datasets and achieving first place in eight."* — openreview.net/forum?id=ZH7YgIZ3DF

**However, "PE over architecture" is only the narrow case.** The deeper principle is that **structural information injection** — whether achieved via PE, continuous kernels, tokenization strategy, or attention-mechanism modification — is the real variable. PE is one mechanism; it is not the only one (see §3).

**Critical scope limitation: this thesis is validated primarily on graph-level tasks under IID evaluation on small-to-medium homophilic 2D benchmarks.** It has sharp, documented boundaries — see §2.

### 2. The Thesis Has Sharp Boundaries — Several Are Existential

The convergence thesis breaks, or is untested, in at least six settings. Three threaten the thesis's practical utility.

**Boundary 1 (existential): OOD generalization — architecture may matter after all.**

The thesis rests entirely on IID benchmark evaluation. Under distribution shift, the picture inverts:

> *"Our results reveal that GT and hybrid GT-MPNN backbones demonstrate stronger generalization ability compared to MPNNs, even without specialized DG algorithms (on four out of six benchmarks)."*
> — Exploring Graph-Transformer OOD Generalization Abilities (arXiv:2506.20575v2, June 2025)

If GTs and MPNNs match on IID benchmarks but GTs generalize better OOD, then **architecture encodes an inductive bias invisible to IID evaluation but critical for deployment.**

Counterpoint: GOODFormer (arXiv:2508.00304v2, updated March 2026) argues GT advantages *don't* survive distribution shifts. Also: *"Graph learning models often suffer from limited generalization when applied beyond their training distributions."* — arXiv:2601.21067, Jan 2026. The OOD evidence is **contradictory** — not settled in either direction. This is the single most important open question for the convergence thesis.

**Boundary 2 (existential): PE scalability constrains the thesis at real-world scale.**

If "invest in PE" is the recommendation, PE must be computable at the scale you need:

- **Laplacian eigenvectors**: O(N³) naively, O(N·k²) via Lanczos. For billion-node graphs, even Lanczos is expensive.
- **RRWP**: O(N² × D_pe) dense storage. Depends on walk length and graph density.
- **SPSE**: NP-hard to count exactly; requires approximation.
- **Spectral truncation**: Fails for expander-like graphs (social networks, power-law graphs) where the spectrum decays slowly.

> *"Extending static Laplacian eigenvector approaches to temporal graphs through the supra-Laplacian has shown promise, but also poses key challenges: high eigendecomposition costs, limited theoretical understanding."*
> — Understanding and Improving Laplacian PE for Temporal GNNs (arXiv:2506.01596)

The thesis is only actionable if PE is computable. For billion-node production graphs (Pinterest, Uber, Netflix — the last handling 650TB of graph data), it may not be, making the convergence thesis an academic insight that doesn't transfer to production systems.

**Boundary 3 (existential): Node-level tasks at scale — the thesis is untested.**

The convergence thesis is validated on graph-level benchmarks. For **node-level tasks on large graphs**, the comparison doesn't exist because GTs fail outright:

> *"Graph Transformer (GT) … imposes several limitations in node classification applications: 1) nodes are susceptible to global noise; 2) self-attention computation cannot scale well to large graphs."*
> — Rethinking GT Architecture Design for Node Classification (arXiv:2410.11189, Oct 2024)

> *"We observe existing graph transformers fail on large-scale graphs mainly due to heavy computation, limited scalability and inferior model quality."*
> — A Holistic System for Large-scale Graph Transformer Training (arXiv:2407.14106)

Node classification and link prediction are the most common industrial graph ML tasks. For these, the "PE over architecture" recommendation is untested because the GT side of the comparison is absent at relevant scales.

Linear-complexity GTs (SGFormer, GT-SNT, AnchorGT) are beginning to address this — SGFormer achieves *"linear complexity w.r.t. node numbers"* (arXiv:2306.10759v5), and GT-SNT reaches *"up to 130× faster inference speed compared to other GTs"* (arXiv:2504.11840v2). These could eventually enable the convergence thesis to be tested at scale, but they sacrifice the full O(N²) global attention that motivates GTs theoretically.

**Boundary 4: 3D molecular geometry** — architecture (equivariant vs. invariant) makes an irreducible difference; PE and architecture are fused. See §9.

**Boundary 5: Heterophilic graphs** — largely untested.

> *"Standard message-passing GNNs often struggle on graphs with low homophily, yet homophily alone does not explain this behavior, as graphs with similar homophily levels can exhibit markedly different performance."*
> — When Geometry Matters Beyond Homophily in GNNs (arXiv:2601.18912, Jan 2026)

**Boundary 6: PE × architecture interaction is non-trivial.**

> *"Our findings demonstrate that previously untested combinations of GNN architectures and PEs can outperform existing methods."*
> — Benchmarking Positional Encodings for GNNs and Graph Transformers (arXiv:2411.12732, Nov 2024)

The thesis implies PE and architecture are separable. This paper shows they interact combinatorially — optimal PE depends on the backbone.

### 3. Structural Information Injection Has Four Strategies, Not Three

The synthesis of evidence reveals four distinct strategies for injecting structural information, all capable of achieving high expressivity:

| Strategy | Example | PE needed? | Expressivity | Cost |
|---|---|---|---|---|
| **PE augmentation** | RRWP, SPSE, MoSE → any backbone | Yes | PE-dependent; up to GD-WL | O(N² × D) attn + PE cost |
| **Continuous kernels** | CKGConv (ICML 2024) | Implicit | GCN = GT expressiveness | O(E × D) + kernel cost |
| **Tokenization** | Edge Transformer (NeurIPS 2024) | **No** — structure implicit | ≥3-WL natively | O(N⁴ × D) attention |
| **Attention modification** | Eigenformer (arXiv:2401.17791) | **No** — structure in attention | Competitive with GT+PE | O(N² × D) attention |

The Edge Transformer (Müller et al., arXiv:2401.10119) achieves ≥3-WL expressivity **with zero PE** by tokenizing node pairs:

> *"We show that the recently proposed Edge Transformer … has at least 3-WL expressive power when provided with the right tokenization … without relying on positional or structural encodings."*

But at O(N⁴ × D), pair-level tokenization is impractical beyond ~1000-node graphs.

Eigenformer builds spectral awareness directly into the attention mechanism, bypassing PE entirely:

> *"We argue that such encodings may not be required at all, provided the attention mechanism itself incorporates information about the graph structure. We introduce Eigenformer, a Graph Transformer employing a novel spectrum-aware attention mechanism cognizant of the Laplacian spectrum of the graph, and empirically show that it achieves performance comparable to SOTA Graph Transformers."*
> — Graph Transformers without Positional Encodings (arXiv:2401.17791v2)

The implication: **"PE over architecture" was always a special case of a more general principle — "how you give the model access to structure matters more than anything else."** PE is the most common mechanism, but continuous kernels, tokenization design, and attention-mechanism modification are equally valid and sometimes more efficient. The real design variable is the structural information injection strategy, not the backbone.

### 4. Graph Foundation Models: Three Tiers of Maturity

The GFM landscape is not binary (working vs. aspirational). As of early 2026, three distinct tiers are visible:

**Tier A: Scientific MLIPs — demonstrably working, with known failure modes.**

MACE-Osaka24 (arXiv:2412.13088, Dec 2024): *"the first open-source neural network potential model based on a unified dataset covering both molecular and crystalline systems … shows strong performance across diverse chemical systems."*

Documented failure modes remain significant:

- **Catalysis**: *"Models such as MACE-OMAT and -MPA exhibit repulsion between U-corrected metals and their oxides, limiting their value for studying catalysis and oxidation."* — arXiv:2601.21056, Jan 2026
- **Alkali/alkaline earth metals**: *"significant performance gaps emerge in alkali and alkaline earth metal groups."* — arXiv:2512.20230, Dec 2025
- **High-energy kinetics**: *"the reliability of universal machine learning interatomic potentials (uMLIPs) in capturing these high-energy landscapes remains uncertain."* — arXiv:2601.10938, Jan 2026
- **Fundamentally interpolative**: *"This restricts the scope of MLIPs to interpolative calculations, essentially denying the possibility of using them to discover new phenomena in a serendipitous way."* — arXiv:2511.17449, Nov 2025

MACE faces active competition from GRACE (arXiv:2508.17936, Aug 2025): *"This work establishes GRACE as a robust and adaptable foundation for the next generation of atomistic modeling."* And from efficiency-focused alternatives achieving comparable performance with <10% of MACE's training compute (arXiv:2509.08418, Sep 2025).

**Tier B: Knowledge Graph Foundation Models — emerging and showing real transfer.**

> *"Through comprehensive experiments on 31 diverse benchmarks spanning transductive, inductive, and cross-domain settings, we demonstrate consistent state-of-the-art performance with minimal adaptation, improving the prediction performance by up to 35% compared to the strongest baselines."*
> — A Foundation Model for Knowledge Graph Reasoning (arXiv:2505.11125, May 2025)

KGFMs work because knowledge graphs, like molecules, have relatively consistent relational semantics. They occupy a middle ground the v2 synthesis missed entirely.

**Tier C: General-purpose GFMs — attempted at scale, failing on real data.**

The scale ambition has materialized: GraphBFF (arXiv:2602.04768, Feb 2026) presents *"the first end-to-end recipe for building billion-parameter Graph Foundation Models (GFMs) for arbitrary heterogeneous, billion-scale graphs"* — a 1.4 billion-parameter model pretrained on one billion samples. General GFMs are no longer "aspirational" in the sense of being unattempted.

But they fail when evaluated outside academic benchmarks:

> *"We show that all of those models fail on our real-world data, while the very same models perform well on public benchmark datasets."*
> — arXiv:2509.20479

> *"We evaluate currently available general-purpose graph foundation models and find that they fail to produce competitive results on our proposed datasets."*
> — Evaluating Graph ML Models on Diverse Industrial Data (arXiv:2409.14500v4)

> *"Our preliminary results indicate that embeddings from pretrained models improve generalization only with enough downstream data points and in a degree which depends on the quantity and properties of pretraining data."*
> — An Analysis on Cross-Dataset Transfer of Pretrained GNNs (arXiv:2412.17609)

The gap between scientific MLIPs and general GFMs is structural: scientific graphs have consistent node/edge semantics (atoms, bonds, 3D coordinates) and physics-based loss functions. General graphs (social, citation, knowledge) have heterogeneous semantics across domains and no equivalent of energy conservation as a training signal. Graph SSL (§13) is the candidate mechanism for closing this gap, but transfer quality lags text/image SSL.

**Why the three-tier structure matters**: the pattern is not "scientific = working, everything else = broken." It's a gradient of semantic consistency: physics > relational logic > arbitrary topology. This predicts where GFMs will next succeed — domains with consistent semantics and composable structure (e.g., electronic circuit design, program analysis).

---

## Tier 2 — Mechanistic / Technical Insights

### 5. Why Standard Transformers Fail on Graphs (Two Bottlenecks)

The PPGT paper (Ma et al., arXiv:2504.12588v3) provides the most precise diagnosis:

**Bottleneck A: The backbone destroys magnitude.**

Four-link causal chain: (1) Graph learning = multiset encoding. (2) Cardinality encodes as magnitude: {{a,b}} → x, {{a,a,b,b}} → 2x. (3) LayerNorm/RMSN projects tokens onto a hypersphere: RMSN(x) = RMSN(cx), erasing scale. (4) SDP attention decomposes as cos(q,k)·‖q‖·‖k‖/√D — query norm acts as temperature, never measuring closeness between ‖q‖ and ‖k‖.

**Bottleneck B: MLP PE stems lose high-frequency detail.**

Spectral bias of neural networks (Rahaman et al., ICML 2019) causes MLP-based PE stems to prioritize low-frequency modes, losing fine-grained structural information in RRWP. This is the same phenomenon that motivates Fourier feature encodings in NeRF and positional encoding in PINNs — a cross-domain convergence worth noting.

**Three minimal fixes:** (1) **sL₂ attention** — SDP + bias term −k^Tk/(2√D), measuring both angular and Euclidean closeness. (2) **AdaRMSN** — input-dependent re-scaling after normalization. (3) **SPE** — sinusoidal pre-encoding on RRWP before the MLP stem (inspired by NeRF). All implementable via FlashAttention. Impact of SPE on BREC: 54.5% → 58.5%, with the entire gain on the hardest (CFI) category.

**On "plainness" as rhetoric:** PPGT uses non-standard attention (sL₂ ≠ SDP), non-standard normalization (AdaRMSN ≠ RMSN), and a URPE multiplicative term requiring custom attention code. TokenGT (Kim et al., NeurIPS 2022) used a genuinely unmodified Transformer and performed worse — showing the modifications matter. Better framing: **"minimally modified Transformers can be powerful graph learners."**

**Cross-modal relevance of AdaRMSN:** Recent multimodal LLM work (arXiv:2512.08374, Dec 2025) finds standard pre-norm causes *"an 'asymmetric update dynamic,' where high-norm visual tokens exhibit a 'representational inertia.'"* This is precisely the magnitude-erasure problem. AdaRMSN may be broadly useful whenever multiple signal types with different norm distributions interact.

### 6. The Oversmoothing Narrative Is Under Serious Revision

Five independent position papers challenge the premise that oversmoothing was THE central GNN problem:

| Paper | Venue/Date | Claim |
|---|---|---|
| "The Oversmoothing Fallacy" | ICLR 2026 submission (unreviewed) | Influence overstated |
| "Don't be Afraid of OS and OSq" | arXiv Jan 2026 (2601.07419) | Less critical than assumed |
| "Position: Misled by OS/OSq" | ICML 2025 | **Can be beneficial** for graph-level tasks |
| "Are We Measuring Correctly?" | arXiv Feb 2025 (2502.04591) | Metrics may be wrong |
| "Demystifying Common Beliefs" | arXiv May 2025 (2505.15547) | Consolidated beliefs not always true |

The ICML 2025 position paper goes furthest: *"For graph-level tasks, over-smoothing can even be beneficial if the smoothed state is label-informative."* — openreview.net/forum?id=U46jD48SJi

An important nuance: the original oversmoothing concern was about **node-level representations** becoming indistinguishable with depth. The ICML 2025 finding that smoothing can help graph-level tasks doesn't resolve the node-level concern — it shows the problem was never universal. The framing "oversmoothing is the problem, depth is the solution" is being revised, not refuted wholesale. One key paper ("The Oversmoothing Fallacy") remains an unreviewed ICLR 2026 submission.

**Practical reality:** Most practitioners still use 2–4 layer GNNs. This doesn't mean DYNAMO-GAT and other depth-enabling fixes are useless — they enable deeper architectures when depth genuinely helps — but depth was never the bottleneck for most applications.

### 7. Over-Squashing ≠ Oversmoothing — And It's the Real Justification for GTs

Over-squashing (exponential compression through graph bottlenecks) is distinct from oversmoothing and is the actual theoretical reason full attention helps. The SSM bridge paper (NeurIPS 2025, arXiv:2502.10818) provides the key unification:

> *"We propose an interpretation of GNNs as recurrent models and empirically demonstrate that a simple state-space formulation of a GNN effectively alleviates over-smoothing and over-squashing at no extra trainable parameter cost."*

This unifies oversmoothing, over-squashing, and vanishing gradients under a single recurrent/SSM framework — suggesting these aren't three separate problems requiring three separate fixes, but manifestations of one underlying issue (information propagation dynamics).

**Graph rewiring** remains active with improving results, despite earlier critiques. Spectrum-Preserving Sparsification (ICML 2025) *"generates graphs with enhanced connectivity while maintaining sparsity and largely preserving the original graph spectrum"* (arXiv:2506.16110). Schreier-Coset Graph Rewiring (OpenReview, Feb 2026) *"reduces effective resistance by 15–40% across benchmark datasets while maintaining competitive accuracy and lower computational overhead"*. And a simpler approach argues *"deleting edges can address over-squashing and over-smoothing simultaneously"* (Spectral Graph Pruning, arXiv:2404.04612v2).

However, the foundational critique remains: *"edges selected during the rewiring process are not in line with theoretical criteria identifying bottlenecks"* on real-world data (arXiv:2407.09381, July 2024). The rewiring literature is maturing toward better spectral foundations, but the gap between theory and practice persists.

### 8. The PE Design Frontier Is Wide Open — And Moving Fast

The PE design space has at least **five** axes, all currently explored independently:

1. **Diffusion-based**: RRWP, Laplacian eigenvectors (spectral)
2. **Path-counting**: **SPSE** (ICLR 2025) — simple path counts between node pairs. Already outperforms RRWP: *"SPSE demonstrates significant performance improvements over RRWP on various benchmarks, including molecular and long-range graph datasets."* — proceedings.mlr.press/v267/airale25a. Notable because it supersedes the PE that PPGT's mechanistic story is built around.
3. **Combinatorial**: Homomorphism counts / **MoSE** (ICLR 2025): *"MoSE outperforms other well-known positional and structural encodings across a range of architectures."* — proceedings.iclr.cc. I²GNN-derived PE pushed PPGT from 58.5% → 76% on BREC, suggesting the combinatorial axis has the most immediate headroom.
4. **Topological**: Persistent homology (arXiv:2506.05814), simplicial random walks via Hodge Laplacians (NeurIPS 2023).
5. **Learned / Pre-trained**: **GFSE** (arXiv:2504.10917): *"achieves state-of-the-art performance in 81.6% evaluated cases, spanning diverse graph models and datasets."* This points toward PE-as-a-service — pre-trained structural representations as a reusable component.

No existing PE combines all five. The decisive experiment remains PPGT's PE-swap: same architecture, different PE → 17.5pp jump on BREC. **PE design is the highest-leverage intervention for graph learning expressivity** — but which PE depends on the task, the graph family, and (per arXiv:2411.12732) the architecture.

Note that PE augmentation is not the only route — Eigenformer achieves competitive results by building spectral awareness into the attention mechanism (§3), and the Edge Transformer bypasses PE entirely through tokenization. The five axes above apply specifically to the PE-augmentation strategy.

**PE scalability remains the Achilles' heel**: Laplacian eigenvectors = O(N³), RRWP = O(N·K·E) for K-step walks, SPSE = NP-hard to count exactly (approximated). For billion-node production graphs, none of these are cheap. Factored storage helps with memory but not compute, and truncation error is high for expander-like graphs.

### 9. Equivariance = Baked-In Physics = Data Efficiency

Equivariant GNNs guarantee correct symmetry by construction (E(3) group). MACE reproduces experimental molecular vibrational spectra from **50 training configurations**. This is the strongest argument for domain-specific architectural inductive bias — and the clearest refutation of "architecture doesn't matter" in the domain where it matters most.

The equivariant/invariant distinction is a genuine architectural choice that PE cannot replace: encoding 3D rotation/translation symmetry as a network constraint (equivariant) vs. learning it from augmented data (invariant) produces measurably different data efficiency and generalization. This is the sharpest boundary of the convergence thesis.

---

## Tier 3 — Emerging Paradigms

### 10. Graph State Space Models — Evolving Fast, Fundamental Limits Remain

Comprehensive survey: arXiv:2412.18322. Graph SSMs are an established architecture family with concrete results:

- **STG-Mamba**: SOTA for spatial-temporal graph forecasting with linear complexity. — arXiv:2403.12418v4
- **Graph Mamba for WSI**: Transformer-level performance with 7× fewer FLOPs. — arXiv:2505.17457
- **HGMN**: Heterogeneous Graph Mamba. — arXiv:2405.13915
- **Topological SSMs**: Mamba on simplicial complexes. — arXiv:2409.12033

**Mamba limitations documented on Mamba-1/2 (some may be partially addressed by Mamba-3):**

- **Long-range failure**: *"A surprising weakness remains: despite being built on architectures designed for long-range dependencies, Mamba performs poorly on long-range sequential tasks."* — arXiv:2505.09022, May 2025
- **Copying/ICL weakness**: *"Both Mamba and Mamba-2 models lag behind Transformer models on tasks which require strong copying or in-context learning abilities."* — arXiv:2406.07887, June 2024
- **Non-causal interaction limit**: *"The recurrent scanning mechanism of Mamba offers computational efficiency [but] inherently limits non-causal interactions between image patches."* — arXiv:2603.16423, March 2026

**Mamba-3 (March 2026) may shift this picture.** Together AI's release adopts an inference-first design with MIMO architecture, complex-valued dynamics, and 50% smaller state size:

> *"Mamba‑3, a fully open‑source state space model (SSM) that outperforms comparable Transformers by ≈4% on language‑model quality while running up to 7x faster at long sequences."*
> — redblink.com, March 2026

Whether Mamba-3's improvements (particularly MIMO and complex-valued dynamics) address the copying/ICL weakness and long-range failure modes documented for Mamba-1/2 is an open question. The memory-decay limitation was a known target:

> *"This development addresses a critical limitation in SSMs: memory decay during iterative reasoning loops."*
> — Recursive Latent Forcing, thenextgentechinsider.com, March 2026

**The bigger signal: hybrid Mamba-Transformer is the production architecture.** The sequence modeling world has converged on hybrid designs:

- **Nemotron 3 Super** (NVIDIA, GTC March 2026): 120B parameter hybrid Mamba-2/Transformer MoE, 12B active parameters, 1M token context window.
- **Nemotron Nano 2**: *"the majority of self-attention layers in the common Transformer architecture are replaced with Mamba-2 layers, to achieve improved inference speed"* (arXiv:2508.14444).

If the sequence modeling world says "use both," the Graph SSM community should take note. The likely future is **hybrid Graph Mamba-Transformer architectures** that use SSM layers for efficiency and attention layers where precise structural recall matters. Framing Graph SSMs as a "fourth architecture" distinct from GTs may be premature — the convergence toward hybrids suggests a continuum.

**The graph-specific limitation remains fundamental regardless of Mamba version:** Converting a graph to a sequence for any SSM requires a "graph scanning" strategy that imposes a linear ordering on inherently non-linear topology. Information is necessarily lost. The scan order becomes a design choice with no principled default. This is structural, not fixable by improving the SSM itself.

### 11. LLM + Graph: Two Paradigms, One Working

The LLM-Graph intersection has bifurcated into two distinct paradigms with different maturity levels.

**Paradigm A: GraphRAG — working and deployed.**

GraphRAG uses graphs as retrieval structure for LLMs rather than asking LLMs to process graph structure directly. This sidesteps the permutation-invariance problem entirely:

> *"GraphRag is a technique developed by Microsoft Research that layers a knowledge graph on top of a standard RAG pipeline. Instead of treating your corpus as a bag of independent text chunks, it treats it as a network of interconnected facts."*
> — edlitera.com, March 2026

> *"Graph-RAG is a paradigm that integrates graph-based retrieval and LLM generation to support multi-hop, context-rich, and domain-adapted reasoning. It employs hybrid lexical–semantic scoring, GNNs, and agentic workflows to enhance retrieval precision and streamline evidence aggregation."*
> — emergentmind.com, Feb 2026

GraphRAG is the most commercially impactful LLM+Graph development. It works because the graph organizes retrieval — the LLM never processes raw graph topology.

**Paradigm B: LLM-GNN hybrids — active, partially working on text-attributed graphs.**

The architecture taxonomy (enhancer, predictor, alignment — per arXiv:2311.12399v4) describes approaches where LLMs directly interact with graph structure. The fundamental challenge remains:

> *"Early 'LLM-centered' pipelines (e.g., converting graphs to serialized token sequences or using text-only prompts) fail to encode permutation invariance or message passing, resulting in poor graph learning."*
> — emergentmind.com/topics/gnn-llm-integration, Feb 2026

**Where it works:** Text-attributed graphs (social networks, citation graphs, knowledge graphs) where node features are rich text. Here, LLMs provide semantic understanding that GNNs can't match, and the combination is strictly better than either alone.

Progress toward parameter efficiency is rapid:

> *"We present GaLoRA, a parameter-efficient framework that integrates structural information into LLMs. GaLoRA demonstrates competitive performance on node classification tasks with TAGs, performing on par with state-of-the-art models with just 0.24% of the parameter count required by full LLM fine-tuning."*
> — arXiv:2603.10298, March 2026

**Where it doesn't work:** For pure-structure tasks (molecular graphs, combinatorial optimization), LLMs add little. The core tension — LLMs are sequence models that lack permutation invariance; graphs are permutation-invariant structures — is structural and unsolved.

### 12. Total Energy Alignment (TEA) — A Transferable Data Engineering Pattern

TEA solves heterogeneous dataset fusion by learning per-element energy offsets during training (arXiv:2412.13088). Analogous to BatchNorm's per-channel shifts: different datasets define "zero energy" differently, and TEA learns the offset.

This pattern transfers to any domain with incompatible label scales across data sources — multi-site clinical data, multi-institution sensor networks, merged financial datasets with different accounting conventions. The insight is that dataset-level bias is a learnable nuisance parameter, not a data-cleaning prerequisite.

### 13. Graph Self-Supervised Learning — The Missing Mechanism for GFMs

Graph SSL is how general GFMs pre-train in the absence of physics-based supervision:

- **Contrastive**: GraphCL, BGRL, CCA-SSG — learn by contrasting augmented views
- **Generative**: GraphMAE, GraphMAE2 — learn by reconstructing masked features
- **Hybrid**: CORE (arXiv:2512.13235, Dec 2025) outperforms GraphMAE by up to 3.82% on graph classification

> *"Self-supervised learning (SSL) on graphs generates node and graph representations that can be used for downstream tasks. Graph SSL is particularly useful in scenarios with limited or no labeled data."*
> — Generative and Contrastive Graph Representation Learning (arXiv:2505.11776, May 2025)

The fact that graph SSL lags behind text/image SSL in transfer quality is a major reason general GFMs lag behind scientific ones (§4). The gap is partly structural — text and images have consistent low-level features (tokens, pixels) while graphs vary in topology across domains — and partly a matter of scale (graph SSL datasets are orders of magnitude smaller than text/image pretraining corpora).

---

## Tier 4 — Cautionary / Methodological

### 14. NodePFN: A Case Study in "Universal" Claims That Aren't

The PFN-for-graphs idea is sound, but execution reveals: 5 per-dataset hyperparameters, dead GP prior (MLP-only training), double self-loop bug corrupting GCN normalization, test-time normalization leakage, 16 hops of compounded message-passing, and the "posterior predictive distribution" claim violated at 3 levels.

Note: GraphPFN (arXiv:2509.21489, Sep 2025) may address some of these issues, showing *"strong in-context learning performance and achieves state-of-the-art results after finetuning … on diverse real-world graph datasets with up to 50,000 nodes."*

- *Source:* [nodepfn-review.md](nodepfn-review.md), [nodepfn-review-gaps.md](nodepfn-review-gaps.md), [nodepfn-review-supplement.md](nodepfn-review-supplement.md)

### 15. Benchmarking Is Broken — And OOD Evaluation Is the Missing Piece

**IID benchmarks are unreliable:**

> *"Through a rigorous empirical analysis, we demonstrate that the reported performance gap is overestimated due to suboptimal hyperparameter choices. It is noteworthy that across multiple datasets the performance gap completely vanishes after basic hyperparameter optimization."*
> — Where Did the Gap Go? (Tönshoff et al., ICML 2024, arXiv:2309.00367)

LRA's "long-range" performance comes mostly from short-range dependencies (arXiv:2501.14850). No large-scale realistic graph benchmark comparable to ImageNet/GLUE exists. OpenGT (arXiv:2506.04765) is attempting to fill this gap.

**GFMs expose the problem most starkly**: models that look strong on academic benchmarks fail completely on industrial data (§4). *"We show that all of those models fail on our real-world data, while the very same models perform well on public benchmark datasets"* (arXiv:2509.20479). This is the strongest indictment of current graph benchmarking practice.

**OOD evaluation is the real frontier.** Almost all claims in this synthesis — convergence thesis, tuned baselines, PE-over-architecture — rest on IID evaluation. Under distribution shift, the picture may be fundamentally different (see §2, Boundary 1). Until OOD evaluation becomes standard, **every IID-only result should be treated as provisional.**

---

## Practitioner's Decision Guide

For someone starting a graph learning project today:

**Step 1: What kind of graph and task?**

| Graph type / task | Recommended starting point | Why |
|---|---|---|
| 3D molecular geometry | Equivariant GNN (MACE, NequIP) | Physics symmetry is non-negotiable; PE can't substitute |
| Text-attributed (social, citation, KG) | GNN + LLM features (E-LLaGNN) or GraphRAG | LLM provides semantics; GNN provides structure. For retrieval: GraphRAG |
| Knowledge graph completion | KGFM (arXiv:2505.11125) or TransE/RotatE | KGFMs show real transfer across 31 benchmarks |
| Link prediction / recommendation | GCN/GAT with edge-level features | Negative sampling strategy matters more than backbone; start with simple MPNN |
| Pure topology, small (< 10K nodes) | GCN/GAT + SPSE or MoSE PE | Simple, fast, PE gives expressivity |
| Pure topology, large (> 100K nodes) | GCN/GAT with RWSE or no PE | PE scalability limits; MPNN still wins on efficiency. Consider SGFormer if global context needed |
| Heterogeneous graph, large scale | R-GCN / HGT; consider GraphBFF fine-tuning | GraphBFF (arXiv:2602.04768) targets this; early but promising |
| Spatiotemporal | STG-Mamba or GAT + temporal attention | SSMs are genuinely competitive; linear complexity matters |
| Dynamic / temporal KG | TGN or DyRep + temporal PE | Supra-Laplacian PE promising but expensive (arXiv:2506.01596) |

**Step 2: When to upgrade to a Graph Transformer**

Use a GT (PPGT, GraphGPS) only if:
1. Your task requires genuine long-range dependencies (test this — most don't)
2. Your graphs are small enough for O(N²) attention **or** you use a linear-complexity GT (SGFormer, GT-SNT)
3. You've already tried a tuned GCN/GAT with good PE and it's not sufficient

**Step 3: PE selection**

- **Default for most tasks**: RWSE — cheap, well-understood, widely implemented
- **If expressivity matters and graphs are small**: SPSE (ICLR 2025) — outperforms RRWP. Note: exact computation is NP-hard; uses approximation
- **If expressivity matters on molecular data**: MoSE (ICLR 2025) — homomorphism counts, strongest on BREC
- **If transfer across domains matters**: GFSE (arXiv:2504.10917) — pre-trained cross-domain, 81.6% SOTA rate
- **If you want to avoid PE entirely**: consider Eigenformer (attention-based structural encoding) or CKGConv (continuous kernels)

**Step 4: Don't forget**

- **Tune your baselines.** The GT advantage is largely a tuning artifact (arXiv:2309.00367).
- **Test OOD if you're deploying.** IID benchmarks don't predict deployment performance.
- **Oversmoothing is probably not your problem.** Most tasks work fine with 2–4 layers.
- **Link prediction ≠ node classification.** Different tasks on the same graph need different approaches.
- **Consider the hybrid future.** If you need both efficiency and long-range interaction, Mamba-Transformer hybrids are the trend in sequence modeling and will likely reach graph learning.

---

## Key Papers for Deep Dive

| Paper | Why | Priority |
|---|---|---|
| PPGT (arXiv:2504.12588v3) | Mechanistic root cause of GT failures + minimal fixes | **Must read** |
| CKGConv (ICML 2024) | Proves GCN = GT expressiveness; continuous kernel design | **Must read** |
| Tuned GNNs (NeurIPS 2024 + ICML 2025) | Deflates GT hype with rigorous baselines | **Must read** |
| MACE-Osaka24 (arXiv:2412.13088) | Working scientific GFM + TEA pattern | **Must read** |
| SPSE (ICLR 2025, proceedings.mlr.press/v267/airale25a) | Already outperforms RRWP; path-counting PE | **Must read** |
| GT OOD Generalization (arXiv:2506.20575v2) | GTs may generalize better OOD — challenges convergence thesis | **Must read** |
| GraphBFF (arXiv:2602.04768) | First billion-scale GFM recipe; heterogeneous graphs | **Must read** |
| Eigenformer (arXiv:2401.17791v2) | GT without PE via spectrum-aware attention | High |
| GNN-as-SSM bridge (arXiv:2502.10818, NeurIPS 2025) | Unifies oversmoothing/over-squashing/vanishing gradients | High |
| MoSE (ICLR 2025) | Homomorphism-count PE — new PE paradigm | High |
| GRACE (arXiv:2508.17936) | MACE's primary competitor; efficiency gains | High |
| Edge Transformer (arXiv:2401.10119, NeurIPS 2024) | Pair-level tokenization bypasses PE entirely | High |
| KG Foundation Model (arXiv:2505.11125) | Working cross-domain transfer on 31 benchmarks | High |
| SGFormer (arXiv:2306.10759v5) | Linear-complexity GT for large graphs | High |
| Industrial GFM Evaluation (arXiv:2409.14500v4) | GFMs fail on real data; sharpest benchmarking critique | High |
| GFSE (arXiv:2504.10917) | Pre-trained cross-domain PE; 81.6% SOTA rate | Medium |
| Graph SSM survey (arXiv:2412.18322) | SSM architecture landscape | Medium |
| GOODFormer (arXiv:2508.00304v2) | OOD evaluation for GTs (contradicts arXiv:2506.20575) | Medium |
| DYNAMO-GAT (ICLR 2025) | Best oversmoothing fix (if the problem matters) | Medium |
| GrokFormer (ICLR 2025) | KAN + Fourier spectral filters | Medium |
| Spectrum-Preserving Sparsification (ICML 2025) | Best current graph rewiring approach | Medium |

---

## Open Questions (Ranked by Impact)

1. **Does architecture matter OOD?** arXiv:2506.20575 says yes (GTs > MPNNs OOD); GOODFormer says no. If yes, the convergence thesis is limited to academic benchmarks. This is testable and urgent.

2. **Can PE or structural injection scale to billion-node graphs?** Current best PEs (SPSE, MoSE, Laplacian) are too expensive for production-scale graphs. Linear-complexity GTs (SGFormer) trade expressivity for scale. Either new O(N) structural encodings emerge, or the convergence thesis remains academic.

3. **Will general-purpose GFMs emerge?** GraphBFF shows the engineering is feasible at billion-parameter scale. But GFMs fail on industrial data (arXiv:2409.14500v4). The gap may be in the pre-training signal (graph SSL quality), the benchmark-to-deployment distribution shift, or the fundamental semantic heterogeneity of general graphs. KGFMs (arXiv:2505.11125) suggest domains with consistent relational semantics are next.

4. **How do Mamba-3 and hybrid architectures change Graph SSMs?** Mamba-3's MIMO architecture and the Nemotron hybrid trend suggest Graph SSMs will converge with Graph Transformers rather than replace them. The graph linearization problem remains structural regardless of SSM version.

5. **Is the oversmoothing/over-squashing distinction practically meaningful?** The SSM bridge paper (arXiv:2502.10818) suggests they're manifestations of the same dynamics. If so, the separate literatures should merge. Rewiring (now with better spectral foundations) may be the practical winner over both deeper architectures and full attention.

6. **Will GraphRAG or GNN-LLM hybrids dominate text-attributed graph tasks?** GraphRAG works now but doesn't learn graph structure. GNN-LLM hybrids learn structure but are expensive. Parameter-efficient approaches (GaLoRA at 0.24% parameter cost) may bridge the gap.

---

## Source Notes

This synthesis draws from 8 research notes in `personal_notes/research/` plus two rounds of critical review with web-verified sources:

1. `graph-neural-networks-progress-2025-2026.md` — Base survey of GAT/GT/GCN landscape
2. `graph-neural-networks-progress-2025-2026-review.md` — Gap analysis identifying 7 omissions
3. `graph-neural-networks-progress-2025-2026-review-v2.md` — Meta-review verifying gaps against primary sources
4. `graph-transformers-pe-bottleneck-simplicity.md` — Deep dive on PPGT and the PE bottleneck thesis
5. `nodepfn-review.md` — Critical code review of NodePFN (ICLR 2026)
6. `nodepfn-review-supplement.md` — Additional bugs and issues found in deep audit
7. `nodepfn-review-gaps.md` — Gap analysis of the NodePFN review itself
8. `mace-osaka24-explainer.md` — Equivariant GNNs and the MACE foundation model story
9. `graph-research-synthesis-review.md` — Critical review of v1 with web-verified sources (March 2026)
10. `graph-research-synthesis-v3-review.md` — Critical review of v2 addressing scope gaps, missing work (GraphBFF, Eigenformer, GraphRAG, Mamba-3, linear-complexity GTs, KGFMs), and overstatement corrections (March 2026)
