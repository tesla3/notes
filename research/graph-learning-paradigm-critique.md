# Graph Learning in 2026: A Paradigm-Level Critique

Source: Consolidation of graph-learning-paradigm-critique.md and gap analysis, March 2026

---

## The Core Problem

The dominant graph learning research narrative in 2025–2026 asks: **"Which architecture (GCN, GAT, GT, SSM) and which positional encoding should I use?"** Three synthesis rounds across 50+ papers converge on an answer: *structural information injection matters more than architecture; invest in PE.* That answer is internally consistent and well-sourced.

But it rests on assumptions that are each challenged by serious, independent evidence:

1. **A graph neural network is the right tool.** Evidence: feature propagation + MLP, graph-augmented tabular models, and logistic regression with graph features all match GNNs on standard tasks.
2. **The WL expressiveness hierarchy is the right measure of progress.** Evidence: for most tasks, 1-WL suffices. More expressivity can hurt generalization.
3. **Pairwise graphs are the right data abstraction.** Evidence: multi-way and hierarchical relational data loses information when forced into edges.
4. **Benchmark performance predicts deployment success.** Evidence: it demonstrably doesn't. Models that ace benchmarks fail on industrial data. Production uses simple MPNNs.
5. **The problem is discriminative.** Evidence: generative graph ML (molecular design, drug discovery) is the highest-impact application and operates under entirely different constraints.
6. **The graph is static and homogeneous.** Evidence: most production graphs are dynamic and heterogeneous, where different findings hold.

This note reframes the landscape by asking the prior questions first — all of them.

---

## Question -1: Do You Even Need a Graph Neural Network?

**Before choosing a GNN architecture, ask whether you need a GNN at all.**

The graph ML community treats the GNN inductive bias as a given. But multiple independent results show that graph-unaware or minimally-graph-aware models match GNNs on standard tasks, suggesting that for many problems, graph structure is useful as *features*, not as an *inductive bias*.

### Feature propagation + MLP matches GNNs

> *"We experimentally show that the proposed approach outperforms previous methods on seven common node-classification benchmarks and can withstand surprisingly high rates of missing features: on average we observe only around 4% relative accuracy drop when 99% of the features are missing."*
> — On the Unreasonable Effectiveness of Feature Propagation in Learning on Graphs with Missing Node Features (arXiv:2111.12128, ICLR 2022)

### Tabular models match GNNs with simple graph features

> *"Our experiments show that graph neural networks indeed can often bring gains in predictive performance for tabular data, but standard tabular models can also be adapted to work with graph data by using simple graph-based feature augmentation, which sometimes enables them to compete with and even outperform graph neural models."*
> — TabGraphs: A Benchmark and Strong Baselines for Learning on Graphs with Tabular Node Features (arXiv:2409.14500v4, NeurIPS 2024)

### Non-neural graph methods outperform with orders-of-magnitude speedup

> *"Going beyond the traditional limited benchmarks, our experiments indicate that GLR increases generalisation ability while reaching performance gains in computation time up to two orders of magnitude compared to its best neural competitor."*
> — Improving Non-Neural Node Classification with Graph-Aware Logistic Regression (arXiv:2411.12330, Nov 2024)

### Even message passing can be dropped at inference

> *"Extensive experiments prove that even without adjacency information in testing phase, our framework can still reach comparable and even superior performance against the state-of-the-art models in the graph node classification task."*
> — Node Classification without Message Passing in Graph (arXiv:2106.04051)

### Attention itself may be unnecessary

> *"We propose Scalable Message Passing Neural Networks (SMPNNs) and demonstrate that, by integrating standard convolutional message passing into a Pre-Layer Normalization Transformer-style block instead of attention, we can produce high-performing deep message-passing-based Graph Neural Networks."*
> — No Need for Attention in Large Graph Representation Learning (arXiv:2411.00835, Nov 2024)

**The implication.** The note's later questions — which architecture, which PE, how much expressivity — only matter if you've first established that a GNN outperforms a graph-augmented non-neural baseline on your specific task. For many node classification and link prediction problems, it won't. The GNN inductive bias has a cost (training complexity, inference latency, explainability loss) and the benefit is often marginal.

**When GNNs are worth the cost**: When the task requires *joint* learning of topology and features that can't be decomposed into independent feature engineering; when the graph is large and the label function has strong spatial correlation; when you need end-to-end differentiability through the graph for a downstream objective. Most scientific graph tasks (molecular property prediction, physics simulation) fall here. Many industrial tasks (fraud detection, recommendation) are borderline.

---

## Question 0: Is Your Data Actually a Graph?

**If you do need to model relational structure, ask whether a pairwise graph is the right abstraction.**

Graphs model binary relations. But many real-world systems have **higher-order** structure that pairwise edges cannot represent:

- **Multi-way interactions**: A drug combination of three compounds has an effect that isn't decomposable into three pairwise interactions.
- **Hierarchical containment**: A cell in a tissue, contained in an organ, part of a body. Meshes have faces bounded by edges bounded by vertices.
- **Boundary-aware dependencies**: In computational physics, fluxes across surfaces relate to volumes they bound — a topological relationship with no clean graph analogue.

> *"While graphs offer a flexible representation for modeling 1-dimensional relations, they are intrinsically limited in expressing multi-way, hierarchical, and boundary-aware dependencies that arise in higher-order domains such as hypergraphs, simplicial complexes, and cellular complexes."*
> — Selective SSMs for Higher-Order Graph Learning on Combinatorial Complexes (arXiv:2601.20518, Jan 2026)

**Topological Deep Learning (TDL)** operates on richer structures — simplicial complexes (triangles, tetrahedra), cell complexes (cells of any shape), and hypergraphs (edges connecting arbitrary subsets). TDL is not fringe: it has a position paper calling it *"the new frontier for relational learning"* (arXiv:2402.08871), E(n) equivariant versions (arXiv:2405.15429), SSM/Mamba versions (arXiv:2409.12033), and a unifying axiomatic framework (arXiv:2506.06582).

> *"Topological deep learning (TDL) has emerged recently as a promising tool … TDL enables the principled modeling of arbitrary multi-way, hierarchical higher-order interactions by operating on combinatorial topological spaces, such as simplicial or cell complexes, instead of graphs."*
> — E(n) Equivariant Topological Neural Networks (arXiv:2405.15429, May 2024)

**The implication.** The entire GCN/GAT/GT/SSM architecture debate and the PE design space operate *within* the graph abstraction. If your data has genuine higher-order structure, no amount of PE engineering on a pairwise graph will recover what was lost in the flattening.

**When graphs are the right abstraction**: Pairwise interaction data (social links, citations, molecular bonds in 2D topology), sparse relational structure where edges are the natural unit, problems where the graph is given (road networks, circuit netlists). Most industrial graph ML falls here. TDL is most relevant for scientific domains where the physics involves multi-body or boundary interactions.

---

## Question 0.5: Are You Generating or Predicting?

**The note's analysis — and the vast majority of graph ML research — assumes discriminative tasks. But generative graph ML is arguably the highest-impact application of the field.**

Graph generation — creating novel molecular structures, materials, protein conformations — creates the most direct economic value in graph ML. And the field is undergoing a rapid paradigm shift from diffusion to flow matching:

> *"Flow-matching methods have recently set the state of the art (SOTA) in unconditional molecule generation, surpassing score-based diffusion models. However, diffusion models still lead in property-guided generation."*
> — PropMolFlow: property-guided molecule generation with geometry-complete flow matching (Nature Computational Science, Jan 2026)

> *"Extensive experiments demonstrate state-of-the-art performance across synthetic, molecular, and digital pathology datasets, covering both unconditional and conditional generation settings. It also outperforms most diffusion-based models with just 5–10% of their sampling steps."*
> — DeFoG: Discrete Flow Matching for Graph Generation (ICML 2025, arXiv:2410.04263)

> *"These results demonstrate that deterministic flow matching provides a unified, accurate, and computationally efficient foundation for molecular generative modeling, signaling that flow matching is the future for molecular generation across chemistry."*
> — Flow matching for reaction pathway generation (arXiv:2507.10530v3)

**Why generation is a different paradigm.** The constraints that govern discriminative graph ML do not apply:

- **Expressivity** means something different. A generator needs to cover the distribution of valid graphs, not distinguish non-isomorphic ones. BREC scores are irrelevant.
- **The production gap is inverted.** For drug discovery, research-frontier models (equivariant diffusion/flow matching) *are* directly deployed. There's no "simple models win in production" story — molecular generation requires geometric inductive biases.
- **The architecture does matter.** Equivariance, geometric completeness, and denoising capacity are non-negotiable. The "architecture doesn't matter, only PE does" finding has no bearing here.

**The generative frontier (mid-2026):**

| Method | Key property | Status |
|---|---|---|
| Diffusion on graphs (DiGress, GDSS) | Established, well-understood | SOTA for conditional/property-guided generation |
| Flow matching (DeFoG, GGFlow) | 10–20× faster sampling, ODE-based | SOTA for unconditional generation; displacing diffusion |
| Equivariant flow matching (ET-Flow, PropMolFlow) | SE(3)-equivariant generation | SOTA for 3D molecular conformers |
| Bayesian Flow Networks | Unified discrete/continuous | Emerging alternative to both |

If your task is *generating* graphs, the rest of this note's analysis (PE design, expressivity hierarchies, architecture comparisons) is mostly irrelevant. The relevant questions are: discrete or continuous generation? Property-guided or unconditional? 2D molecular graph or 3D geometry? The answers point to different methods in the table above.

---

## Question 1: Do You Actually Need Expressivity Beyond 1-WL?

*From here forward, we assume: (a) you need a GNN, (b) your data is well-represented as a pairwise graph, (c) you're doing a discriminative task.*

The research community has spent enormous effort climbing the Weisfeiler-Leman expressiveness ladder: subgraph GNNs, higher-order GNNs, pair-level tokenization, combinatorial PE. PPGT (arXiv:2504.12588v3) reaches 76% on BREC. The synthesis frames PE design as "the highest-leverage intervention for graph learning expressivity." But four independent results question whether this ladder matters:

### 1-WL is sufficient for almost all practical graph datasets

> *"Interestingly, we find that the expressiveness of WL is sufficient to identify almost all graphs in most datasets. Moreover, we find that the classification accuracy upper bounds are often close to 100%."*
> — 1-WL Expressiveness Is (Almost) All You Need (arXiv:2202.10156)

For standard graph classification benchmarks, a 1-WL GNN (basic GCN/GIN) can *in principle* achieve near-perfect accuracy. The expressivity ceiling is rarely the binding constraint.

### More expressivity can actively hurt generalization

> *"While more expressive GNNs can distinguish a richer set of graphs, they are also observed to suffer from higher generalization error. This work provides a theoretical explanation for this trade-off by linking expressivity and generalization through the lens of coloring algorithms."*
> — More Expressivity, but at What Cost? (arXiv:2510.10101)

The *capacity* to distinguish more graphs comes with a larger hypothesis class, which requires more data to generalize. BREC rewards exactly the capability that hurts generalization.

### Topology awareness can hurt deployment fairness

> *"Contrary to the prevailing belief that enhancing the topology awareness of GNNs is always advantageous, our analysis reveals a critical insight: improving the topology awareness of GNNs may inadvertently lead to unfair generalization across structural groups."*
> — On the Topology Awareness and Generalization Performance of GNNs (arXiv:2403.04482)

### The WL framework itself is questioned as a measure

> *"GNN expressiveness has been primarily assessed via the Weisfeiler-Leman (WL) hierarchy. However, such an expressivity measure has notable limitations: it is inherently coarse, qualitative, and may not well reflect practical requirements (e.g., the ability to encode substructures)."*
> — Beyond Weisfeiler-Lehman: A Quantitative Framework for GNN Expressiveness (OpenReview, HSKaGOi7Ar)

### Graph self-supervised learning shows the same pattern

The expressivity mirage extends beyond architecture design. Graph Contrastive Learning (GCL) — a massive research program (GraphCL, GraphMAE, BGRL, hundreds of papers) — shows the same overoptimization on easy benchmarks:

> *"On synthetic datasets, GCL accuracy approximately scales with the logarithm of the number of graphs and its performance gap (compared with untrained GNNs) varies with respect to task complexity."*
> — Graph Contrastive Learning versus Untrained Baselines (arXiv:2509.01541, Sep 2025)

Untrained GNNs, simple MLPs, and handcrafted statistics rival or exceed GCL on standard benchmarks. The entire graph SSL research program may be solving a non-problem on easy datasets — the same pattern as the architecture debate and the expressivity race.

### The nuance: expressivity matters *sometimes*

> *"Theoretical studies conjecture a trade-off between the two: highly expressive models risk overfitting, while those focused on generalization may sacrifice expressivity. However, empirical evidence often contradicts this assumption, with expressive GNNs frequently demonstrating strong generalization."*
> — Towards Bridging Generalization and Expressivity of GNNs (arXiv:2410.10051)

For molecular property prediction where distinguishing subtle isomers matters, expressivity may help. For social network node classification, it almost certainly doesn't.

**Practical test**: Before investing in expensive PE or beyond-1-WL architectures, check whether a 1-WL GNN (GCN/GIN + basic features) saturates your task. If it does, your bottleneck is elsewhere — data quality, feature engineering, training procedure, or distribution shift.

---

## Question 2: Will Your Benchmark Results Hold in Deployment?

The graph learning field has a benchmark-to-deployment gap that is wider than commonly acknowledged — and the gap extends to settings the research community barely evaluates.

### GFMs pass benchmarks, fail on real data

> *"We show that all of those models fail on our real-world data, while the very same models perform well on public benchmark datasets."*
> — arXiv:2509.20479

> *"We evaluate currently available general-purpose graph foundation models and find that they fail to produce competitive results on our proposed datasets."*
> — Evaluating Graph ML Models on Diverse Industrial Data (arXiv:2409.14500v4)

### IID benchmarks overstate architecture differences

> *"Through a rigorous empirical analysis, we demonstrate that the reported performance gap is overestimated due to suboptimal hyperparameter choices. It is noteworthy that across multiple datasets the performance gap completely vanishes after basic hyperparameter optimization."*
> — Where Did the Gap Go? (Tönshoff et al., ICML 2024, arXiv:2309.00367)

### The same pattern holds for temporal graphs

Simple heuristics (recency, frequency, common neighbors) are competitive with deep temporal graph models — the dynamic-graph equivalent of "tuned GCN matches GT":

> *"These results emphasize the importance of refined evaluation schemes to enable fair comparisons and promote the development of more robust temporal graph models. Additionally, they reveal that current deep learning methods often struggle to capture the key patterns underlying predictions in real-world temporal graphs."*
> — On the Power of Heuristics in Temporal Graphs (arXiv:2502.04910, Feb 2025)

The diagnostic benchmark T-GRAB (arXiv:2507.10183) isolates basic temporal skills — counting repetitions, inferring delayed causal effects, long-range dependencies — and finds existing models struggle with these fundamentals.

### "Architecture doesn't matter" may not hold for heterogeneous graphs

The central finding — structural injection > architecture choice — is derived primarily from homogeneous benchmarks. On heterogeneous/multi-relational data, Graph Transformers genuinely outperform GNNs:

> *"Across 21 tasks from the RelBench benchmark, RelGT consistently matches or outperforms GNN baselines by up to 18%, establishing Graph Transformers as a powerful architecture for Relational Deep Learning."*
> — Relational Graph Transformer (arXiv:2505.10960, May 2025)

Most production graphs are heterogeneous (multiple node/edge types: users, products, sellers with purchase, click, review edges). The scope of "architecture doesn't matter" is narrower than the original synthesis acknowledges.

### "Long-range" benchmarks test short-range dependencies

> LRA's "long-range" performance comes mostly from short-range dependencies. — arXiv:2501.14850

### Production reality: simple models win — and here's why

The most successful production graph ML systems — Pinterest PinSage, Uber Eats recommendations, Snapchat GiGL, Netflix's graph abstraction (650TB) — use **2-3 layer GCN/GraphSAGE with massive feature engineering and systems optimization**. No production system uses PPGT, Graph Transformers, expensive PE, or any architecture above 1-WL expressiveness.

This isn't just inertia. Production teams prefer simple models for structural reasons that benchmark performance doesn't capture:

**Adversarial robustness.** GNNs are extremely vulnerable to adversarial attacks on both structure and features:

> *"Despite the exploding interest in graph neural networks there has been little effort to verify and improve their robustness. This is even more alarming given recent findings showing that they are extremely vulnerable to adversarial attacks on both the graph structure and the node attributes."*
> — Certifiable Robustness to Graph Perturbations (arXiv:1910.14356)

A fraud detection GNN can potentially be evaded by creating a few fake edges. Certified defenses exist (PGNNCert, arXiv:2503.18503) but remain limited. This operational risk — not benchmark performance — is often why production teams stick with feature-engineered gradient-boosted trees.

**Explainability.** Regulated domains (finance, healthcare) require interpretable predictions. GNN explanations remain unreliable:

> *"Incorporating both graph structure and feature information leads to complex models and explaining predictions made by GNNs remains unsolved."*
> — GNNExplainer (Ying et al., NeurIPS 2019)

Worse, existing explanations aren't robust — small input perturbations change explanations dramatically (arXiv:2505.02566). The decision tree should ask "Do your stakeholders need to understand predictions?" before recommending any complex GNN.

**Latency and maintenance.** Message passing creates inference-time neighborhood expansion. A 3-hop GNN on a billion-node graph requires sampling or partitioning strategies that add systems complexity. Simple models with precomputed graph features avoid this entirely.

---

## Question 3: Will LLMs Make Your GNN Obsolete?

**Most production graphs are text-attributed. The GNN-vs-LLM question is not peripheral — it's the central strategic issue for production graph ML.**

User profiles have descriptions. Products have titles and reviews. Papers have abstracts. The research community's focus on topology-heavy, feature-light benchmarks (Cora, OGB) obscures the fact that most real-world graphs are semantically rich.

The integration problem remains unsolved and cuts both ways:

> *"LLM-centered models often struggle to capture graph structures effectively, while GNN-centered models compress variable-length textual data into fixed-size vectors, limiting their ability to understand complex semantics."*
> — Rethinking the Combination of Graph Neural Network and Large Language Model (arXiv:2412.06849, Dec 2024)

The GFM community is converging on text as the universal transfer medium:

> *"We can treat text as a medium to enable cross-domain generalization of graph learning Model, allowing a single graph model to effectively handle the diversity of downstream graph-based Task across different data domains."*
> — A Survey from the Perspective of Data, Models, and Tasks (arXiv:2412.12456, Dec 2024)

TAG foundation models are emerging with LLMs as backbone:

> *"Text-Attributed Graphs (TAGs), where each node is associated with text descriptions, are ubiquitous in real-world scenarios. They typically exhibit distinctive structure and domain-specific knowledge, motivating the development of Graph Foundation Models (GFM) that generalize across diverse graphs and tasks."*
> — Graph Vocabulary Learning for Text-Attributed Graph Foundation Models (arXiv:2503.03313v3, Mar 2025)

**Current state (mid-2026).** For text-attributed graphs, the practical hierarchy is:
1. **LLM embeddings as node features + simple GNN** — best practical approach today
2. **GraphRAG** — for retrieval tasks specifically, this is production-ready
3. **End-to-end GNN-LLM fusion** — research frontier, not production-ready
4. **LLM-only (no GNN)** — competitive on node classification when text is rich and topology signal is weak

The implication: for the majority of production graph tasks where nodes carry text, the architecture/PE/expressivity debate within GNNs may be a second-order concern. The first-order question is how to integrate LLM-derived semantic representations with graph structure.

---

## What the Research Frontier Tells Us (Conditioned on the Right Paradigm)

Given that you've confirmed: (a) you've tried non-GNN baselines and they don't suffice, (b) your data is well-represented as a pairwise graph, (c) you're doing a discriminative task, (d) you're operating at a scale where research architectures are feasible — here is what the frontier says, with appropriate confidence levels.

### High confidence

**Structural information injection > architecture choice** — for graph-level IID tasks on homogeneous graphs. Three independent paper families converge (Tuned-GNN NeurIPS 2024, CKGConv ICML 2024, PPGT arXiv:2504.12588v3). Scope: graph-level, IID, small-to-medium, homophilic, homogeneous. Does *not* generalize to heterogeneous/relational settings (RelGT evidence).

**PPGT's mechanistic diagnosis is correct.** The magnitude-erasure (LayerNorm kills multiset cardinality) and spectral-bias (MLPs smooth PE) bottlenecks have precise causal chains and empirical validation. PPGT is the state of the art in *understanding* graph transformers — the best diagnostic paper, not the best model. Tuned GCNs match or beat it on practical benchmarks.

**PE design space has high leverage on expressivity benchmarks.** PPGT PE-swap (17.5pp on BREC), SPSE outperforming RRWP (ICLR 2025), MoSE outperforming across architectures (ICLR 2025). Whether this translates to proportional task-performance gains is unestablished.

### Medium confidence

**Four structural injection strategies are equivalent.** PE augmentation, continuous kernels (CKGConv), tokenization (Edge Transformer), and attention modification (Eigenformer) all achieve high expressivity. Practical tradeoffs are underexplored.

**The oversmoothing narrative was overstated.** Five independent papers challenge it. The ICML 2025 position is strongest: smoothing can be beneficial for graph-level tasks. But the node-level concern remains valid. "Under serious revision" not "collapsed."

**Over-squashing unifies with oversmoothing via SSM framework.** The NeurIPS 2025 bridge paper (arXiv:2502.10818) is theoretically clean. Rewiring is the practical winner but has a persistent theory-practice gap.

### Low confidence

**OOD generalization behavior of GTs vs MPNNs.** Contradictory evidence (arXiv:2506.20575 says GTs win OOD; GOODFormer says they don't). This is the most important open question. Causal GNN methods — building invariant representations via counterfactual neighborhoods (CNL-GNN, arXiv:2602.17934) and confounder-aware frameworks (CCAGNN, arXiv:2602.17941) — are the principled attempt to resolve it, but remain early-stage.

**GFMs for general graphs.** GraphBFF (arXiv:2602.04768) shows the engineering is feasible. KGFMs (arXiv:2505.11125) show transfer works with consistent semantics. But general GFMs fail on industrial data. The semantic consistency gradient (physics > relational logic > arbitrary topology) is the best predictive framework for where GFMs will work next.

**Graph scaling laws.** Emerging work shows graph data scaling requires edge count, not graph count, as the metric (arXiv:2402.02054), and that neural scaling laws emerge even on random graph walks (arXiv:2601.10684). But it remains unclear whether scaling will eventually vindicate complex architectures or whether the irregular nature of graph data imposes fundamental scaling ceilings that don't exist in NLP/vision. Without answering this, we can't distinguish "production uses simple models because they're better" from "production uses simple models because it hasn't tried scaling complex ones."

---

## The Practitioner's Decision Tree

```
START
│
├─ Are you GENERATING new graphs or PREDICTING on existing ones?
│  ├─ GENERATING → Different paradigm. Expressivity/PE/architecture debates
│  │   │           are mostly irrelevant.
│  │   ├─ 3D molecular geometry → Equivariant flow matching (ET-Flow, PropMolFlow)
│  │   ├─ 2D molecular graphs → DeFoG (flow matching) or DiGress (diffusion)
│  │   ├─ Property-guided → Diffusion models still lead; flow matching closing gap
│  │   └─ General graph generation → DeFoG; 5-10% of diffusion sampling steps
│  │
│  └─ PREDICTING → Continue
│
├─ Does a non-GNN baseline saturate your task?
│  │  (graph-augmented XGBoost, feature propagation + MLP, label propagation)
│  ├─ YES → You don't need a GNN. Graph structure is useful as features,
│  │         not as inductive bias. Stop here.
│  └─ NO → Continue
│
├─ Does your data have multi-way or hierarchical relational structure?
│  ├─ YES → Consider TDL (simplicial/cell complexes). Graphs lose information.
│  │         Papers: arXiv:2402.08871, arXiv:2405.15429, arXiv:2601.20518
│  └─ NO → Continue (pairwise graph is appropriate)
│
├─ Are your nodes text-attributed?
│  ├─ YES → LLM embeddings + simple GNN is the practical default.
│  │         GraphRAG for retrieval. GaLoRA for parameter efficiency.
│  │         The PE/architecture debate is secondary to the LLM integration
│  │         strategy. Skip to deployment checks.
│  └─ NO → Continue
│
├─ Is your graph dynamic/temporal?
│  ├─ YES → Benchmark simple heuristics first (recency, frequency, common
│  │         neighbors). TGNNs may not beat them (arXiv:2502.04910).
│  │         If heuristics don't suffice: TGN, DyRep, or STG-Mamba.
│  └─ NO → Continue
│
├─ Is your graph heterogeneous (multiple node/edge types)?
│  ├─ YES → GTs may genuinely outperform GNNs here (RelGT, up to +18%
│  │         on RelBench). The "architecture doesn't matter" finding
│  │         may not apply. Try RelGT or HGT.
│  └─ NO → Continue (homogeneous static graph)
│
├─ How large is your graph?
│  ├─ > 100K nodes → GCN/GraphSAGE, 2-3 layers. Invest in feature
│  │                  engineering and data quality. PE is expensive
│  │                  at this scale; RWSE if anything. GTs don't scale here.
│  └─ < 100K nodes → Continue
│
├─ Does a basic GCN/GIN saturate your task performance?
│  ├─ YES → Your bottleneck is not architecture or expressivity.
│  │         Invest in: data quality, feature engineering, training
│  │         procedure, OOD robustness. Tune hyperparameters first
│  │         (arXiv:2309.00367).
│  └─ NO → The expressivity interventions become relevant. Continue.
│
├─ What kind of task?
│  ├─ 3D molecular geometry → Equivariant GNN (MACE, NequIP). Non-negotiable.
│  ├─ Knowledge graph → KGFM (arXiv:2505.11125) or TransE/RotatE
│  ├─ Graph classification/regression (small) → GCN/GAT + PE (see below)
│  └─ Link prediction → Simple MPNN; negative sampling strategy matters
│                        more than backbone
│
├─ PE selection (only if you need expressivity beyond 1-WL):
│  ├─ Default: RWSE — cheap, well-understood
│  ├─ Higher expressivity: SPSE (ICLR 2025) — outperforms RRWP
│  ├─ Molecular tasks: MoSE (ICLR 2025) — homomorphism counts
│  ├─ Cross-domain transfer: GFSE (arXiv:2504.10917)
│  └─ Avoid PE entirely: Eigenformer or CKGConv
│
└─ Before deploying:
   ├─ Test OOD. IID benchmarks do not predict deployment performance.
   ├─ Test adversarial robustness. Can an adversary manipulate your graph?
   ├─ Can you explain predictions? Regulated domains may require it.
   └─ Every IID-only result is provisional.
```

---

## What Should Be Read First

Priorities depend on which question you're answering. The table is ordered by decision sequence, not publication prestige.

| Priority | Paper | Why |
|---|---|---|
| **Everyone** | TabGraphs (arXiv:2409.14500v4, NeurIPS 2024) | Question -1: do you even need a GNN? |
| **Everyone** | Where Did the Gap Go? (arXiv:2309.00367, ICML 2024) | Tuned baselines collapse most reported gaps |
| **If discriminative** | 1-WL Is (Almost) All You Need (arXiv:2202.10156) | Determines whether the expressivity ladder matters |
| **If discriminative** | More Expressivity, but at What Cost? (arXiv:2510.10101) | The counterargument to the entire PE research program |
| **If generative** | DeFoG (arXiv:2410.04263, ICML 2025) | Flow matching displacing diffusion for graph generation |
| **If generative** | PropMolFlow (Nature Comp Sci, Jan 2026) | SOTA molecular generation |
| **If text-attributed** | arXiv:2412.12456 + arXiv:2503.03313v3 | LLM-graph convergence and TAG foundation models |
| **If temporal** | On the Power of Heuristics in Temporal Graphs (arXiv:2502.04910) | Simple baselines are strong; benchmark them first |
| **If heterogeneous** | RelGT (arXiv:2505.10960) | Where GTs genuinely beat GNNs |
| **For deployment** | Industrial GFM Evaluation (arXiv:2409.14500v4) | The benchmark-deployment gap in hard numbers |
| **For deployment** | arXiv:2506.20575v2 + GOODFormer | OOD behavior — the unsettled deployment question |
| **If expressivity matters** | SPSE (ICLR 2025) + MoSE (ICLR 2025) | The PE frontier |
| **If higher-order data** | TDL frontier paper (arXiv:2402.08871) | Whether to leave the graph paradigm |
| **If molecular science** | MACE-Osaka24 (arXiv:2412.13088) | The one domain where GFMs work |

---

## Three Levels of Insight

**Level 1 — What most graph ML researchers believe (the mainstream narrative):**
Architecture matters (GCN < GAT < GT). More expressivity is better. New PE designs are the frontier. GFMs are coming. Self-supervised pretraining helps.

**Level 2 — What careful synthesis shows (the corrected narrative):**
Architecture matters less than structural information injection. PE is one of four equivalent strategies. Tuned baselines close most gaps. GFMs work for science, fail for general graphs. OOD behavior is unsettled.

**Level 3 — What the evidence supports when you question every assumption:**

- You may not need a GNN at all. Feature propagation + MLP or graph-augmented tabular models match GNNs for many tasks. The GNN inductive bias has a cost and the benefit is often marginal.
- 1-WL suffices for most discriminative tasks. More expressivity can hurt. The expressivity race — and the graph SSL research program built on the same benchmarks — may be solving non-problems.
- Benchmarks don't predict deployment. And the reasons production prefers simple models go beyond performance gaps to robustness, explainability, and latency.
- Graphs may be the wrong abstraction for higher-order data.
- The discriminative framing ignores the highest-impact application (generative graph ML), where different rules apply.
- The static homogeneous framing ignores production reality (temporal heterogeneous graphs), where different methods win.
- LLMs may be flanking the entire GNN program for text-rich graphs.
- Whether scaling will eventually vindicate complex architectures is unknown — and is the question that determines whether Level 2's corrected narrative is permanent or temporary.

The mainstream narrative is useful for understanding the literature. The corrected narrative prevents common mistakes. The paradigm-level critique allocates effort wisely — by establishing *which questions to ask* before answering any of them.
