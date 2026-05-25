# Recent Progress in GAT, Graph Transformers, and GCN (2024–2026)

Source: Web research, March 2026

---

## Executive Summary

The graph neural network landscape in 2024–2026 is defined by five macro trends: (1) **Graph Transformers** ascending as the dominant paradigm, displacing message-passing networks on many benchmarks — though this advantage is **increasingly contested** (NeurIPS 2024, ICML 2025 showed well-tuned classic GNNs match or beat GTs); (2) **oversmoothing** finally getting principled theoretical solutions; (3) **scalability** breakthroughs enabling billion-edge training; (4) **KAN-based architectures** injecting new expressivity into both GCN and Transformer variants; and (5) the emergence of **Graph Foundation Models** as an aspirational (but still contested) paradigm. The boundaries between GAT, GCN, and Graph Transformer are increasingly blurred — the winning architectures mix attention, convolution, and positional encoding freely.

---

## 1. Graph Attention Networks (GAT)

### 1.1 GATv2 and Beyond

The original GAT (Veličković et al., 2018) used static attention — the ranking of neighbors is independent of the query node. **GATv2** (Brody et al., 2022) fixed this with dynamic, query-conditioned attention by reordering the concatenation and projection steps. GATv2 remains the standard attention backbone in 2025–2026. Key extensions:

- **Edge-Conditioned GATv2** — integrates multi-dimensional edge features into the attention computation, enabling adaptive message passing in heterogeneous/directed graphs. Applied to mmWave IAB network deployment, achieving 98.7% coverage. ([emergentmind.com, Nov 2025](https://www.emergentmind.com/topics/edge-conditioned-gatv2))
- **r-GAT and SGAT** — relational and sparse variants that enhance expressivity for heterogeneous graphs while mitigating over-smoothing and over-squashing. ([emergentmind.com, Nov 2025](https://www.emergentmind.com/topics/graph-attention-network-gat))

### 1.2 DYNAMO-GAT: Solving Oversmoothing via Dynamical Systems

**The most significant GAT paper in this period.** Published at ICLR 2025 (proceedings.mlr.press/v267):

- **Core idea:** Model GAT layers as a coupled dynamical system. Oversmoothing = convergence to a single fixed-point attractor. DYNAMO-GAT uses noise-driven covariance analysis + Anti-Hebbian learning to selectively prune attention weights, preserving distinct attractor states for different nodes.
- **Result:** Superior accuracy with *better* computational efficiency than prior anti-oversmoothing methods. Enables meaningfully deep GATs (10+ layers) without representation collapse.
- **Why it matters:** Previous oversmoothing fixes were heuristic (DropEdge, PairNorm, etc.). DYNAMO-GAT provides a principled theoretical framework grounded in dynamical systems theory.
- Sources: [OpenReview](https://openreview.net/forum?id=44gnGhurnZ), [PMLR](https://proceedings.mlr.press/v267/chakraborty25a.html), [arXiv:2412.07243](https://arxiv.org/html/2412.07243v1)

### 1.3 Oversmoothing: Other Theoretical Advances

- **Multiplicative Ergodic Theorem approach** (Jan 2026): Rigorous proof that residual connections effectively mitigate oversmoothing across broad families of parameter distributions. ([arXiv:2501.00762](https://arxiv.org/html/2501.00762v1))
- **Opinion Dissensus** (ICLR 2026 submission): Reframes oversmoothing as consensus in linear opinion dynamics; proposes nonlinear opinion dynamics as an inductive bias to guarantee dissensus (= node distinctiveness). ([OpenReview](https://openreview.net/forum?id=e4SvuiVHcW))
- **Operator Semigroup Theory**: Diverges from random walk analysis, studies oversmoothing through diffusion operator semigroups. ([arXiv:2402.15326](https://arxiv.org/html/2402.15326v1))

### 1.4 Domain-Specific GAT Applications

- **Spatiotemporal forecasting**: GAT + temporal attention for traffic, air quality, epidemic modeling — integrating spatial message-passing with temporal attention to dynamically learn relationships among sensor nodes. ([emergentmind.com, Dec 2025](https://www.emergentmind.com/topics/graph-attention-based-forecasting))
- **Power outage prediction**: Graph attention models achieving >93% accuracy, outperforming XGBoost, Random Forest, GCN, and vanilla GAT by 2–15%. ([arXiv:2511.10898](https://arxiv.org/html/2511.10898v1))

---

## 2. Graph Transformers

### 2.1 The Dominant Architecture Trend

Graph Transformers have become the **most active research frontier** in graph learning. They adapt full self-attention to graph-structured data, capturing both local and global (long-range) dependencies. The key challenge: how to inject graph structure into the Transformer without losing its scalability.

### 2.2 Scalability Breakthroughs

The quadratic complexity of full self-attention is the primary bottleneck. Major solutions:

- **SGFormer** (NeurIPS 2023, extended 2024): Single-layer global attention with **linear complexity** w.r.t. graph size. No approximations — exact all-pair interactions in O(N) via a simplified attention model. Expanded version: [arXiv:2409.09007](https://arxiv.org/abs/2409.09007). This was a landmark: it showed that one attention layer + one propagation layer is often sufficient.
- **GraphGPS** (Rampášek et al., ICML 2022, continued influence): Recipe for general, powerful, scalable Graph Transformers with O(N+E) complexity by decoupling local real-edge aggregation from fully-connected Transformer. ([arXiv:2205.12454](https://ar5iv.labs.arxiv.org/html/2205.12454))
- **Anchor-based sparse attention and linear approximations**: Reduce quadratic cost while preserving long-range capture. ([emergentmind.com, Feb 2026](https://www.emergentmind.com/topics/graph-transformers-gts))

### 2.3 PPGT: Plain Transformers as Powerful Graph Learners (2025–2026)

A pivotal paper that reframes the entire GT debate. Ma et al. (McGill/Mila/Huawei, same group as CKGConv). arXiv:2504.12588v3, Jan 2026.

- **Core thesis:** Existing GTs deviated from plain Transformers to solve the wrong problems. The real issues are: (1) token-wise normalization (LN/RMSN) destroys magnitude information critical for graph multiset encoding; (2) SDP attention is blind to magnitude closeness, biased toward large-magnitude keys.
- **Three minimal fixes:** (1) Simplified L₂ attention (SDP + a bias term — implementable via float attention mask in FlashAttention); (2) AdaRMSN — adaptive normalization that can preserve magnitude when needed; (3) MLP-based PE stem for positional encoding preprocessing.
- **Results:** Best or second-best across ZINC, MNIST, CIFAR10, PATTERN, CLUSTER, Peptides-Struct, PascalVOC-SP — matching GRIT and beating GraphGPS. On BREC expressivity benchmark, surpasses subgraph GNNs and higher-order GNNs despite weaker theoretical expressivity.
- **Key insight:** *"The expressivity bottleneck does not stem from architecture, but from positional encoding design."* With I2GNN-generated PE, PPGT reaches 76% on BREC — surpassing all standalone methods.
- **Connection to CKGConv:** PPGT with URPE "can be interpreted as a generalization of CKGConv with a dynamic density function." Same group, complementary results: CKGConv proves GCN matches GT; PPGT proves plain Transformer matches GT. Both identify PE as the true differentiator.
- **Implication for multimodal unification:** If graph learning only needs a near-plain Transformer, then language + vision + graph unification becomes architecturally trivial. This is the paper's strongest pragmatic argument.
- Sources: [arXiv:2504.12588v3](https://arxiv.org/html/2504.12588v3)

### 2.4 GrokFormer: Graph Fourier Kolmogorov-Arnold Transformers

**The most architecturally novel Graph Transformer of 2025.** Published at ICLR 2025 ([PMLR v267](https://proceedings.mlr.press/v267/ai25d.html)).

- **Core idea:** Replace fixed activation functions with learnable Fourier-series-based activation functions (from the Kolmogorov-Arnold representation theorem). Learns adaptive spectral filters over the graph Fourier domain.
- **What it captures:** Intricate patterns across different orders and frequency levels of graph signals — "order-and-frequency-adaptive" representations.
- **Addresses:** (1) Node susceptibility to global noise; (2) scalability of self-attention on large graphs.
- **Why it matters:** Merges two hot trends — KAN architectures and graph spectral methods — into a single coherent model. Represents a new direction: **spectral filter learning through activation function design** rather than fixed polynomial filters (ChebNet) or learned adjacency matrices.
- Sources: [arXiv:2411.17296](https://arxiv.org/abs/2411.17296), [PMLR](https://proceedings.mlr.press/v267/ai25d.html)

### 2.5 Positional and Structural Encodings

A critical enabler for Graph Transformers — how to encode graph structure into the attention mechanism:

- **Random Walk Structural Encoding (RWSE)**: Now standard. Encodes both structural and positional information into edge representations. ([arXiv:2502.09365](https://arxiv.org/html/2502.09365v1))
- **Simple Path Structural Encoding (SPSE)** (Feb 2025): Proposed as an alternative to RWSE, encoding structural information via simple paths rather than random walks. More expressive for certain graph types.
- **Edge Transformer** (Jan 2024): Surpasses other theoretically-aligned architectures *without* relying on positional or structural encodings. Competitive on algorithmic reasoning and molecular regression. ([arXiv:2401.10119](https://arxiv.org/html/2401.10119))

### 2.6 Heterogeneous Graph Transformers

- **Type-specific self-attention** with hierarchical token grouping and spectral positional encoding for graphs with diverse node/edge types. Significant improvements on bibliographic networks, knowledge graphs, and multimodal data. ([emergentmind.com, Jan 2026](https://www.emergentmind.com/topics/graph-transformer-and-heterogeneous-models))
- **Soft Meta-Paths**: Dynamically constructed (learned) meta-paths integrating heterogeneous relation types. ([emergentmind.com, Sep 2025](https://www.emergentmind.com/topics/graph-transformer))

### 2.7 Mechanistic Interpretability

- **Attention Graphs** (Feb 2025): A new tool for mechanistic interpretability of GNNs and Graph Transformers based on the mathematical equivalence between message passing and self-attention. Brings the mechanistic interpretability toolbox from language models to graph models. ([arXiv:2502.12352](https://arxiv.org/html/2502.12352))

---

## 3. Graph Convolutional Networks (GCN)

### 3.1 CKGConv: Continuous Kernel Graph Convolution (ICML 2024)

**The most significant GCN paper in this period.** Ma et al., ICML 2024.

- **Core idea:** Parameterize graph convolution kernels as **continuous functions** of pseudo-coordinates derived from graph positional encoding. Subsumes many existing graph convolutions as special cases.
- **Expressiveness:** Provably as powerful as Graph Transformers in distinguishing non-isomorphic graphs.
- **Performance:** Outperforms existing GCNs and matches the best Graph Transformers across a variety of benchmarks.
- **Why it matters:** Closes the expressiveness gap between GCN and Graph Transformer architectures while retaining the message-passing paradigm's efficiency. Shows that the GCN framework is not inherently limited — the bottleneck was discrete, fixed kernels.
- Sources: [PMLR](https://proceedings.mlr.press/v235/ma24k.html), [arXiv:2404.13604](https://arxiv.org/abs/2404.13604)

### 3.2 Deep GCNs: Oversmoothing Solutions

- **Neighborhood graph filters + residual connections + dynamic residual schemes**: Core innovations enabling deep (10+ layer) GCNs. ([emergentmind.com, Nov 2025](https://api.emergentmind.com/topics/deep-graph-convolutional-neural-networks))
- **ScaleGNN** (Apr 2025): Adaptively fuses multi-hop node features for scalable and effective graph learning. Addresses both oversmoothing and scalability simultaneously. ([arXiv:2504.15920](https://arxiv.org/html/2504.15920v5))

### 3.3 Multi-Scale GCNs

- Expand effective receptive field, improve expressiveness, mitigate over-smoothing. Applications: semi-supervised node classification, visual recognition, clustering, scientific modeling. ([emergentmind.com, Feb 2026](https://www.emergentmind.com/topics/multi-scale-graph-convolutional-networks-gcns))
- Key techniques: hierarchical pooling, dilated convolutions on graphs, multi-resolution spectral filters.

### 3.4 KAN-GCN Hybrid: Kolmogorov-Arnold GNNs

Published in **Nature Machine Intelligence** (Aug 2025) — a strong validation signal:

- Replace MLPs in GNN layers with **Kolmogorov-Arnold Networks (KANs)** — learnable activation functions instead of fixed nonlinearities + learned weights.
- Improved expressivity, parameter efficiency, and interpretability for molecular property prediction.
- Also: **FourierKAN-GCF** uses Fourier KAN as feature transformation modules within GCN propagation layers for collaborative filtering, enhancing representation while reducing training difficulty. ([arXiv:2406.01034](https://arxiv.org/html/2406.01034v3))

### 3.5 Spatiotemporal GCN Models

- Integration of spatial graph convolutions with temporal modules (RNNs, TCNs, temporal attention) for traffic forecasting, air quality, epidemics. Mature application area with continuing refinement. ([emergentmind.com, Jan 2026](https://www.emergentmind.com/topics/graph-convolutional-spatiotemporal-models))

---

## 4. Cross-Cutting Themes

### 4.1 Graph Foundation Models (GFMs)

The biggest emerging paradigm across all three architecture families:

- **Definition:** Pre-trained on extensive, heterogeneous graph data using self-supervised objectives; adapted via fine-tuning or prompting to downstream tasks.
- **GraphFM**: Perceiver-based encoder using learned latent tokens to compress domain-specific features into a common latent space. ([arXiv:2407.11907](https://arxiv.org/html/2407.11907v1))
- **GFM-RAG** (NeurIPS 2025, ICLR 2026): Graph Foundation Model for Retrieval-Augmented Generation. ([github.com/RManLuo/gfm-rag](https://github.com/RManLuo/gfm-rag))
- **MDGFM**: Bridges different domains via topology alignment + prompt-tuning. ([arXiv:2502.02017](https://arxiv.org/html/2502.02017v1))
- **Open questions:** Transferability across datasets remains challenging. Some researchers question the very feasibility of GFMs given graph heterogeneity. ([arXiv:2509.21489](https://arxiv.org/html/2509.21489v2))
- **"Graph Foundation Models are Already Here"** (Feb 2024, updated 2025): Argues GFMs are emerging but acknowledges the gap vs. LLM-style foundation models. ([arXiv:2402.02216](https://arxiv.org/html/2402.02216v3))

### 4.2 Billion-Scale Training

- **Plexus**: 3D parallel full-graph GNN training. Tested on up to 2048 GPUs on Perlmutter and Frontier. 2.3–12.5× speedup over prior SOTA. 5.2–54.2× reduction in time-to-solution. ([arXiv:2505.04083](https://www.arxiv.org/abs/2505.04083))
- **PyG 2.0**: Major overhaul of PyTorch Geometric for billion-scale graphs, heterogeneous data, real-world deployments. Now the standard framework. ([arXiv:2507.16991](https://arxiv.org/html/2507.16991v2))
- **GiGL (Snapchat)**: Production-scale GNN infrastructure interfacing with PyG for internal practitioners. ([arXiv:2502.15054](https://arxiv.org/html/2502.15054v1))
- **RapidGNN**: Near-linear scalability with increasing compute units. 44% CPU and 32% GPU energy efficiency gains. ([arXiv:2509.05207](https://arxiv.org/html/2509.05207v1))

### 4.3 Molecular Property Prediction

The dominant benchmark domain for comparing GAT/GCN/GT architectures:

- **KAN-GNN** (Nature Machine Intelligence, Aug 2025): KAN-based GNNs for molecular property prediction with improved expressivity and interpretability.
- **ASE-Mol**: MoE architecture for substructure-aware molecular prediction, SOTA on 8 benchmarks. ([arXiv:2504.05844](https://arxiv.org/html/2504.05844v1))
- **Molecular property prediction via next-token prediction**: Reframing molecular prediction as an autoregressive problem — convergence with Foundation Models for Science. ([arXiv:2601.02530](https://arxiv.org/html/2601.02530v3))

### 4.4 Industry Adoption

Uber, Google, Alibaba, Pinterest, Twitter/X, Snapchat all using GNN-based approaches in core products. Substantial performance improvements over previous SOTA. ([assemblyai.com](https://www.assemblyai.com/blog/ai-trends-graph-neural-networks/))

---

## 5. Opinionated Assessment

### What's working

1. **Graph Transformers are winning on expressivity** — they capture long-range dependencies that message-passing inherently struggles with. GrokFormer and SGFormer represent the two viable directions: maximally expressive vs. maximally simple.
2. **Oversmoothing is solved in theory** — DYNAMO-GAT, multiplicative ergodic theorem analysis, and opinion dissensus approaches collectively provide principled solutions. The practical impact is enabling deeper architectures.
3. **KAN integration is the sleeper hit** — replacing MLPs with learnable activation functions is a simple change with outsized impact on expressivity and interpretability. Nature MI publication validates this isn't a fad.

### What's contested

1. **Graph Transformers' advantage is largely a tuning artifact.** Two major papers deflate the GT hype:
   - **"Classic GNNs are Strong Baselines: Reassessing GNNs for Node Classification"** (NeurIPS 2024, Luo et al.): Reassesses GCN, GAT, and GraphSAGE against Graph Transformers on **18 node classification datasets**. With proper hyperparameter tuning, these classic GNNs match or exceed GTs on **17 out of 18 datasets**. Code: [github.com/LUOyk1999/tunedGNN](https://github.com/LUOyk1999/tunedGNN). [OpenReview](https://openreview.net/forum?id=xkljKdGe4E), [arXiv:2406.08993](https://arxiv.org/html/2406.08993v2)
   - **"Can Classic GNNs Be Strong Baselines for Graph-level Tasks? Simple Architectures Meet Excellence"** (ICML 2025): Extends the argument to **graph-level** tasks (classification + regression on molecular graphs). Classic GNNs secure top-3 rankings across all datasets, **first place on 8**, while running **several times faster** than GTs. [OpenReview](https://openreview.net/forum?id=ZH7YgIZ3DF), [arXiv:2502.09263](https://arxiv.org/html/2502.09263v2)
   - **Implication:** Much of the GT advantage reported in the literature reflects unfair comparisons — classic GNNs use default/minimal hyperparameters while GTs get full tuning budgets. When the playing field is leveled, the gap vanishes or reverses, and GNNs are far more efficient. This doesn't mean GTs are useless — they may still win on tasks requiring genuine long-range dependencies — but it severely undermines the narrative that GTs are a strict upgrade.
2. **Graph Foundation Models** — attractive idea, unclear execution. Graph data is far more heterogeneous than text/images. Transferability across graph domains (social → molecular → citation) is fundamentally harder than ImageNet → medical imaging.
3. **Simplicity vs. expressivity** — SGFormer shows a single attention layer suffices; GrokFormer shows complex spectral filters help. The field hasn't resolved which direction scales better.

### Deep Dive: Why Architecture Class Doesn't Matter — the PPGT / CKGConv / Tuned-GNN Convergence

Three seemingly different papers, published at three top venues, converge on the same deep conclusion from different directions:

| Paper | Venue | Claim |
|---|---|---|
| Classic GNNs are Strong Baselines | NeurIPS 2024 | Well-tuned GCN/GAT/GraphSAGE match GTs on 17/18 node-classification datasets |
| Can Classic GNNs Be Strong Baselines (graph-level) | ICML 2025 | Same result for graph-level tasks; classic GNNs take 1st place on 8 datasets, several × faster |
| Plain Transformers Can be Powerful Graph Learners (PPGT) | arXiv 2504.12588v3, Jan 2026 | A *plain* Transformer with 3 minimal fixes matches/beats sophisticated GTs (GRIT, GraphGPS) |

**The surface-level reading:** "GTs aren't better than GNNs" vs. "Plain Transformers are great graph learners" — these seem contradictory. But they're not. They're the same insight stated from opposite ends.

#### Why existing Graph Transformers underperformed their promise

The PPGT paper identifies the **root cause** of why existing GTs had to deviate from plain Transformers and add complexity (message-passing in GraphGPS, conditional-MLP attention in GRIT, edge-updating in EGT):

1. **Token-wise normalization (LayerNorm / RMSN) destroys magnitude information.** In graphs, multiset cardinality is encoded as token magnitude (e.g., `{{a,b}}` vs. `{{a,a,b,b}}` → `x` vs. `c·x`). Both LayerNorm and RMSN are **strictly invariant** to input magnitude — they retract everything onto a hypersphere. This erases information critical for graph isomorphism testing. Previous GTs patched this with BatchNorm (which breaks the token-wise paradigm) or complex attention mechanisms.

2. **Scaled dot-product (SDP) attention has a magnitude blindspot.** For each query `q_i`, the query norm `‖q_i‖` degenerates to a temperature factor — SDP measures *angular* similarity only and is biased toward large-magnitude keys. It cannot measure *closeness* in magnitude between query and key, which matters for graph structure.

3. **Previous GTs treated symptoms, not causes.** They added message-passing layers (to compensate for attention's inability to capture local structure), complex non-SDP attention (to compensate for SDP's magnitude blindness), and edge-update mechanisms. These work but (a) stray far from standard Transformer architecture, (b) prevent leveraging Transformer training advances (FlashAttention, scaling laws, normalization tricks), and (c) add complexity without addressing the fundamental issue.

#### PPGT's three minimal fixes

PPGT proposes three targeted repairs that preserve the plain Transformer architecture:

1. **Simplified L₂ attention** — replace SDP with negative squared Euclidean distance: `softmax(-½‖q_i - k_j‖²/D)`. This decomposes as `softmax(q_iᵀk_j/D - k_jᵀk_j/(2D))` — literally SDP attention + a bias term. Implementable via existing FlashAttention with a float attention mask. Measures both angular AND magnitude closeness.

2. **AdaRMSN (Adaptive Root-Mean-Square Norm)** — an input-dependent scale factor `γ'(x) = ‖α·x + β‖/√D` that can recover the identity transform when magnitude information is needed. Initialized to behave as standard RMSN, learns when to preserve magnitude. Drop-in replacement for RMSN.

3. **MLP-based PE stem** — a simple MLP to preprocess graph positional encoding (RRWP) before feeding into attention. Not architecturally novel, but critical for information extraction from PE.

**Result:** PPGT achieves best or second-best on ZINC (0.057 MAE), MNIST, CIFAR10, PATTERN, CLUSTER, Peptides-Struct, and PascalVOC-SP — matching or beating GRIT, GraphGPS, and CKGConv — while remaining a plain pre-norm Transformer.

#### The convergence: it's all about positional encoding, not architecture

The PPGT paper's most revealing result is Table 1 (BREC expressivity benchmark):

- All GD-WL methods (CKGConv, GRIT, PPGT) with RRWP achieve ~54.5% on BREC
- Adding SPE (better PE extraction) to PPGT jumps to 58.5%
- Using I2GNN-generated PE with PPGT reaches **76%** — surpassing all standalone methods

The paper's own conclusion: *"The expressivity bottleneck of our PPGT model does not stem from its architecture, but rather from the design of positional encodings."*

**This is the key unifying insight across all three paper families:**

- **Tuned-GNN papers** show: GT's apparent advantage over GCN/GAT disappears with proper tuning → the GT architecture itself wasn't contributing much
- **PPGT** shows: a plain Transformer matches complex GTs → the GT-specific modifications weren't contributing much
- **CKGConv** shows: GCN with continuous kernels over graph PE matches GT expressiveness → the architecture class doesn't determine expressiveness

**They all point to the same conclusion: the real variable is what structural information (PE) you give the model, not whether the model is a GCN, GAT, or Transformer.**

#### Same research group, same insight, two sides

Note: PPGT is by Liheng Ma et al. (McGill / Mila / Huawei Noah's Ark) — the **same first author as CKGConv**. The connection is explicit in the paper: "PPGT with URPE enhancement can also be interpreted as a generalization of CKGConv with a dynamic density function." CKGConv proved GCN can match GT; PPGT proved plain Transformer can match GT. Both argue the differentiator is PE quality, not model family.

#### Why the "well-tuned baseline" papers were right — and incomplete

The NeurIPS 2024 and ICML 2025 baseline papers correctly identified that the GT advantage is artifactual, but they attributed it to **tuning asymmetry** (GTs get more hyperparameter search budget). PPGT suggests a deeper explanation:

1. **Information asymmetry, not just tuning asymmetry.** GTs typically incorporate positional encodings (RRWP, Laplacian PE, random walk PE) in their pipeline. The "classic GCN/GAT" baselines in many comparisons don't use PE at all. So the unfairness isn't just in HP tuning — it's in what structural features the model has access to. A GCN with the same PE as a GT should narrow the gap further.

2. **Architectural complexity masks the real contribution.** When GraphGPS beats GCN, is it the self-attention? The message-passing? The PE? PPGT shows that with the right fixes, plain attention + PE is sufficient — the message-passing in GraphGPS was compensating for SDP's magnitude blindness, not contributing irreplaceable inductive bias.

3. **"Mismatch between expressivity and real-world performance."** PPGT Table 1 shows that methods with *stronger* theoretical expressivity (subgraph GNNs, K-WL GNNs) underperform methods with weaker theoretical expressivity but better PE (PPGT, GRIT) on ZINC. Theoretical power isn't translating to benchmark wins. This validates the tuned-baseline papers' finding from a different angle.

#### Practical implications

1. **For practitioners:** Don't chase architecture; invest in PE engineering. A well-tuned GCN/GAT with good positional encoding will likely match a Graph Transformer at a fraction of the compute cost.

2. **For the GT research agenda:** The path forward is NOT more complex attention mechanisms. It's (a) better PE schemes that encode richer structural information, and (b) keeping architecture simple enough to inherit Transformer infrastructure (FlashAttention, tensor parallelism, scaling laws).

3. **For the unified multimodal vision:** PPGT's strongest argument is pragmatic — if graphs can be handled by a near-plain Transformer, then language + vision + graph unification becomes architecturally trivial. The modifications (L₂ attention bias term, AdaRMSN) are compatible with standard Transformer infra. This is the real value proposition, not benchmark points.

4. **The O(N²) elephant:** PPGT inherits quadratic complexity from full attention. SGFormer showed linear-complexity alternatives exist but sacrifice expressivity (equivalent to MPNN + virtual node). The scalability vs. expressivity tradeoff remains unsolved for plain graph Transformers.

### What to watch

1. **Convergence of GCN and GT**: CKGConv proved GCN can match GT expressiveness. Expect more hybrid architectures that aren't cleanly categorizable.
2. **Autoregressive molecular prediction**: If next-token prediction works for molecules, it could displace graph-specific architectures entirely.
3. **Billion-scale infrastructure**: Plexus + PyG 2.0 = production-ready billion-node training. Opens entirely new application domains.

---

## Key Papers (sorted by significance)

| Paper | Venue | Year | Area | Why Notable |
|---|---|---|---|---|
| DYNAMO-GAT | ICLR 2025 | 2025 | GAT | Principled oversmoothing solution via dynamical systems |
| GrokFormer | ICLR 2025 | 2025 | GT | KAN + Fourier spectral filters for graph transformers |
| CKGConv | ICML 2024 | 2024 | GCN | Continuous kernels close GCN-GT expressiveness gap |
| SGFormer | NeurIPS 2023 (ext. 2024) | 2024 | GT | Linear-complexity single-layer graph transformer |
| Simplifying GTs (PPGT) | arXiv 2025–26 | 2026 | GT | Plain Transformer + 3 fixes matches complex GTs; PE is the real bottleneck |
| KAN-GNN | Nature MI 2025 | 2025 | GCN | KAN replaces MLP in GNNs for molecular prediction |
| Plexus | arXiv 2025 | 2025 | Infra | 3D parallel GNN training, 2048 GPUs |
| PyG 2.0 | arXiv 2025 | 2025 | Infra | Billion-scale GNN framework |
| Oversmoothing via Ergodic Thm | arXiv 2026 | 2026 | Theory | Rigorous residual connection analysis |
| GFM-RAG | NeurIPS'25/ICLR'26 | 2025-26 | GFM | Graph foundation model for RAG |
| Attention Graphs | arXiv 2025 | 2025 | Interpretability | Mechanistic interpretability for graph models |
| Tuned GNNs = GTs (node) | NeurIPS 2024 | 2024 | Benchmarking | Well-tuned GCN/GAT/GraphSAGE match GTs on 17/18 datasets |
| Tuned GNNs = GTs (graph) | ICML 2025 | 2025 | Benchmarking | Classic GNNs match/beat GTs on graph-level tasks, several × faster |
