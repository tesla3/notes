# The State of Graph Learning: Mid-2026

*Research survey — synthesized from ~55 web searches across arxiv, conference proceedings, and technical sources. July 2026.*

---

## Executive Summary

Graph learning in mid-2026 is defined by a central irony: the field's most celebrated advances — graph transformers, higher-order expressiveness, foundation models — are being systematically challenged by evidence that simpler approaches work just as well when properly tuned. Meanwhile, the *actually* transformative work is happening in domain-specific applications (equivariant GNNs for molecular simulation) and infrastructure (billion-scale training systems), not in architecture novelty.

The field is in a correction phase. After years of "graph transformers beat everything" narratives, 2024–2026 produced a wave of reassessment papers showing the emperor has fewer clothes than advertised. At the same time, genuinely new paradigms — topological deep learning, graph SSMs, LLM-graph hybrids — are emerging but haven't yet proven they matter outside benchmarks.

---

## I. The GNN vs Graph Transformer Debate: Settled (Sort Of)

This is the most important development in graph learning over the past two years, and the answer is uncomfortable for GT advocates.

### The Reassessment Papers

Three papers form a devastating triptych:

1. **"Classic GNNs are Strong Baselines"** (Luo et al., NeurIPS 2024). Reassessed GCN, GAT, and GraphSAGE against advanced GTs on 18 node classification datasets. With *slight* hyperparameter tuning, classic GNNs matched or exceeded GTs on **17 of 18 datasets**. Implementation: [github.com/LUOyk1999/tunedGNN](https://github.com/LUOyk1999/tunedGNN).

2. **"Can Classic GNNs Be Strong Baselines for Graph-level Tasks?"** (ICML 2025). Extended the finding to graph-level tasks. Classic GNNs secured top-3 rankings across *all* datasets, first place in 8, while running **several times faster** than GTs.

3. **"Where Did the Gap Go?"** (Tönshoff et al., NeurIPS 2024 workshop → journal). Showed the LRGB performance gap between GTs and MPGNNs was **overestimated due to suboptimal hyperparameter choices**. On multiple datasets, the gap *completely vanished* after basic HPO.

### What This Means

The GT advantage was largely a benchmarking artifact. GTs were compared against poorly-tuned GNN baselines. When you give GCN/GAT/GraphSAGE the same hyperparameter budget, they're competitive or better — and dramatically more efficient.

This doesn't mean GTs are useless. They still show advantages in:
- **Long-range dependency tasks** where over-squashing genuinely matters (though even here, the gap is smaller than claimed)
- **OOD generalization**: GTs show stronger generalization under distribution shift on 4/6 benchmarks (arxiv 2506.20575)
- **Relational deep learning**: RelGT outperforms GNN baselines by up to 18% on RelBench (arxiv 2505.10960)

But for the bread-and-butter tasks (node classification, standard graph classification), a well-tuned GCN is hard to beat.

### The Simplification Movement

Parallel to the reassessment, a push toward simpler GT designs:

- **SGFormer** (NeurIPS 2023 → journal 2024): Single-layer global attention with O(N) complexity. No approximation needed. Scales to massive graphs.
- **PPGT** ("Plain Transformers Can be Powerful Graph Learners", arxiv 2504.12588, 2025): Shows a *plain* transformer — no message-passing, no sophisticated attention — achieves strong expressivity on BREC benchmarks, competitive with subgraph GNNs and higher-order GNNs. Key implication: graph transformers may converge toward standard transformers with good tokenization.
- **Eigenformer** (2024): Eliminates positional encodings entirely by building spectrum-awareness into the attention mechanism itself. Competitive with SOTA GTs.

The trend is clear: complexity is being stripped away, not added.

---

## II. The Oversmoothing/Over-squashing Reckoning

These two problems have dominated GNN theory for years. In 2025–2026, the field is questioning whether they actually matter.

### Position Papers Challenging the Narrative

- **"The Oversmoothing Fallacy"** (ICLR 2026): Argues oversmoothing's influence has been **overstated**. Advocates for deeper GNN exploration rather than treating depth as inherently problematic.
- **"Don't be Afraid of Over-Smoothing And Over-Squashing"** (ICML 2025 position): For graph-level tasks, oversmoothing can be *beneficial* if the smoothed state is label-informative. Over-squashing isn't always detrimental in practice.
- **"Oversmoothing, Oversquashing, Heterophily, Long-Range, and more"** (arxiv 2505.15547): Meta-position paper noting that commonly accepted beliefs about these phenomena "are not always true nor easy to distinguish from each other."
- **"Are We Measuring Oversmoothing Correctly?"** (arxiv 2502.04591): Questions the metrics themselves.

### What Actually Works for Deep GNNs

Despite the theoretical hand-wringing, practical solutions exist:

- **DYNAMO-GAT** (ICLR 2025): Uses dynamical systems theory to selectively prune attention weights, preserving node distinctiveness. Combines noise-driven covariance analysis with Anti-Hebbian learning.
- **SSM formulation** (NeurIPS 2025): Interprets GNNs as recurrent models; a simple state-space formulation alleviates oversmoothing, over-squashing, *and* vanishing gradients at **zero extra parameter cost**.
- **Nonlocal message passing** (arxiv 2512.08475): Post-LN inducing algebraic smoothing, supporting 256+ layers without oversmoothing.

### Over-squashing and Rewiring

Graph rewiring remains active but increasingly scrutinized:

- **Spectrum-preserving sparsification** (ICML 2025): Novel approach that *removes* edges while improving connectivity — preserves Laplacian spectrum while reducing bottlenecks.
- **Schreier-Coset Graph Rewiring** (2026): Reduces effective resistance by 15–40% with lower computational overhead.
- **Curvature-based rewiring questioned** (arxiv 2407.09381): On real-world datasets, edges selected during rewiring don't align with theoretical bottleneck criteria. The practical gains may come from something other than what the theory predicts.
- **"Is Rewiring Actually Helpful?"** (arxiv 2305.19717): Properly evaluating rewiring is confounded by coupling with training issues like vanishing gradients.

---

## III. Structural and Positional Encodings: The Real Battleground

If the GT vs GNN debate is settling, the PE/SE design space is where the action moved.

### Key Advances

- **MoSE** (ICLR 2025): Motif structural encoding based on homomorphism counts. Outperforms RWSE and other encodings across architectures. SOTA on molecular property prediction. Theoretically stronger than random-walk encodings.
- **SPSE** (ICLR 2025): Simple Path Structural Encoding. Significant improvements over RRWP on molecular and long-range benchmarks. Simpler than alternatives.
- **Eigenformer**: Eliminates PEs entirely via spectrum-aware attention. Competitive results suggest PEs may be a crutch rather than a necessity.
- **GFSE** (arxiv 2504.10917): Universal cross-domain graph structural encoder. SOTA in 81.6% of evaluated cases.

### The Scalability Problem

Laplacian eigenvector computation doesn't scale to billion-node graphs. This is a fundamental bottleneck for GT deployment at scale. Learnable alternatives (arxiv 2502.01122) and Lanczos-based approaches (arxiv 2408.12334, achieving 20x speedup) are emerging but not yet mature.

---

## IV. Expressiveness: Does It Actually Matter?

The WL hierarchy has been the theoretical backbone of GNN analysis. Recent work questions its practical relevance.

### The Expressiveness-Generalization Tradeoff

- **"1-WL Expressiveness Is (Almost) All You Need"** (arxiv 2202.10156): WL is sufficient to identify almost all graphs in most datasets. Classification accuracy upper bounds are often near 100%.
- **"More Expressivity, but at What Cost?"** (arxiv 2510.10101): More expressive GNNs suffer from *higher* generalization error. Theoretical explanation via coloring algorithms.
- **"Beyond Weisfeiler-Lehman"** (ICLR 2024): The WL measure is "inherently coarse, qualitative, and may not well reflect practical requirements."
- **Topology awareness tradeoff** (arxiv 2403.04482): Improving topology awareness can lead to *unfair generalization* across structural groups.

The emerging consensus: expressiveness beyond 1-WL matters for specific tasks (substructure counting, certain molecular properties) but is not a universal good. The field over-indexed on theoretical expressiveness at the expense of practical performance.

---

## V. Graph Foundation Models: Aspirational, Not Yet Real

GFMs are the field's biggest bet — and its biggest disappointment so far.

### The Vision

Pre-train on diverse graphs, transfer to arbitrary downstream tasks. The "GPT moment" for graphs.

### The Reality

- **"A versatile GFM has not yet been achieved"** (arxiv 2402.02216). The key challenge: enabling positive transfer across graphs with diverse structural patterns.
- **GFMs fail on industrial data** (arxiv 2409.14500): "We evaluate currently available general-purpose graph foundation models and find that they fail to produce competitive results on our proposed datasets." Models that work on public benchmarks fail on real-world data.
- **Transfer requires sufficient downstream data** (arxiv 2412.17609): Pretrained embeddings only help with enough downstream data points.
- **Fundamental challenges** (arxiv 2509.21489): Transferability and data scarcity "call into question the very feasibility of graph foundation models."

### Bright Spots

- **GraphBFF** (arxiv 2602.04768, Feb 2026): First end-to-end recipe for billion-parameter GFMs on heterogeneous, billion-scale graphs. 1.4B-parameter model pretrained on 1B samples. Addresses practical constraints (imbalanced type distributions, high-degree nodes).
- **GraphPFN** (arxiv 2509.21489): Prior-data fitted approach showing strong in-context learning on graphs up to 50K nodes.
- **Knowledge graph FMs** showing real transfer: 35% improvement over baselines across 31 benchmarks (arxiv 2505.11125).

The gap between graph FMs and language/vision FMs remains enormous. Graphs lack the universal tokenization that makes text/image FMs work. Every graph domain has different node features, edge semantics, and structural patterns.

---

## VI. Equivariant GNNs and Scientific ML: Where Graphs Actually Won

This is the field's clearest success story. Equivariant GNNs for molecular simulation are *production-ready* and transforming computational chemistry.

### MACE: The Dominant Architecture

MACE (Multilayer Atomic Cluster Expansion) combines E(3)-equivariant message passing with atomic cluster expansions. Key properties:
- Rotation/translation equivariance baked into every layer
- Higher-order messages via tensor products and spherical harmonics
- Extremely data-efficient (reproduces vibrational spectra from 50 training configs)

### Foundation Models for Atomistic Simulation

- **MACE-MP-0** (Batatia et al., 2024): Foundation model covering the entire periodic table. Trained on Materials Project data.
- **MACE-Osaka24** (arxiv 2412.13088, Dec 2024): First open-source MLIP covering *both* molecular and crystalline systems. Uses **Total Energy Alignment (TEA)** to integrate heterogeneous quantum chemical datasets without redundant calculations. Strong performance on organic reaction barriers while maintaining SOTA for inorganic systems.
- **MACE architecture enhancements** (arxiv 2510.25380): Cross-domain learning bridging molecular, surface, and inorganic crystal chemistry in a single model.

### Limitations and Open Problems

- **Long-range interactions**: Message-passing MLIPs struggle with electrostatics. FieldMACE (arxiv 2502.21045) adds multipole expansion. Polarizable models (arxiv 2410.13820) integrate charge equilibration.
- **Uncertainty quantification**: "The lack of reliable, general uncertainty quantification limits their safe, wide-scale use" (arxiv 2507.21297).
- **Failure modes**: MACE-OMAT/MPA exhibit repulsion between U-corrected metals and oxides (arxiv 2601.21056). Performance gaps on alkali/alkaline earth metals (arxiv 2512.20230).
- **Interpolation-only**: MLIPs are restricted to interpolative calculations, "denying the possibility of using them to discover new phenomena in a serendipitous way" (arxiv 2511.17449).

### KAN-GNN Convergence

Kolmogorov-Arnold Networks meeting graph learning: **KA-GNNs** (Nature Machine Intelligence, 2025) replace MLPs with KAN layers in GNNs, offering improved expressivity, parameter efficiency, and interpretability for molecular property prediction.

---

## VII. LLM-Graph Integration: Three Paradigms, No Clear Winner

### The Taxonomy

1. **LLM as enhancer**: LLMs encode text features → GNN processes structure. E.g., E-LLaGNN enriches message passing by enhancing a fraction of nodes.
2. **LLM as predictor**: Graphs serialized into token sequences for LLM processing. E.g., GraphGPT, LLaGA. Problem: "fail to encode permutation invariance or message passing."
3. **LLM as alignment component**: Joint training with graph-text alignment. E.g., graph instruction tuning.

### The Core Tension

"LLM-centered models often struggle to capture graph structures effectively, while GNN-centered models compress variable-length textual data into fixed-size vectors, limiting their ability to understand complex semantics" (arxiv 2412.06849).

### GraphRAG: The Practical Winner

The most impactful LLM-graph integration isn't architectural — it's **GraphRAG**: layering knowledge graphs on top of RAG pipelines for multi-hop reasoning. Microsoft's approach treats corpora as networks of interconnected facts rather than bags of chunks. This is seeing real production adoption.

### Text-Attributed Graphs as Unifying Medium

TAGs (text-attributed graphs) are emerging as the bridge: text provides a universal feature space across graph domains, enabling cross-domain GFMs. Several 2025–2026 papers propose cascaded LM+GNN architectures with masked graph modeling pretraining on TAGs.

---

## VIII. Alternative Architectures: Graph Mamba and Beyond

### Graph Mamba / SSMs

State-space models adapted for graphs, offering linear complexity:

- **STG-Mamba**: SOTA on spatiotemporal forecasting with linear complexity. Significant computational savings.
- **HGMN**: Heterogeneous graph Mamba network targeting transformer-based methods.
- **Comprehensive survey** (arxiv 2412.18322): First survey devoted to Graph Mamba.

**Mamba limitations for graphs**: The fundamental challenge is that graphs are *unordered* — Mamba requires sequential scanning. Graph scanning strategies are heuristic and may lose structural information. Mamba also struggles with copying/in-context learning tasks where transformers excel.

**Mamba-3** (March 2026): Inference-first design, 50% smaller state, 7x faster than transformers at long sequences, +4% on LM quality. NVIDIA's Nemotron 3 Super (120B params, 12B active) uses hybrid Mamba-Transformer MoE with 1M token context. The hybrid approach — Mamba for efficiency, attention for recall — is winning over pure SSMs.

### Graph Diffusion Models

Active area for molecular generation and drug discovery:

- **Latent Graph Diffusion (LGD)**: Unifies generation and prediction via latent-space diffusion.
- **HOG-Diff**: Higher-order guided diffusion with coarse-to-fine generation.
- **DemoDiff**: In-context molecular design via demonstration-conditioned diffusion.
- **Scalability challenge**: Diffusion models require thousands of denoising steps. Next-scale prediction (arxiv 2503.23612) and stochastic block diffusion (arxiv 2508.14352) address this.

### Topological Deep Learning

The "beyond graphs" movement:

- Operating on simplicial complexes, cell complexes, and combinatorial complexes instead of graphs
- Captures multi-way, hierarchical, boundary-aware dependencies that pairwise graphs cannot
- **E(n) Equivariant Topological Neural Networks** (2024): Principled modeling of higher-order interactions
- **Combinatorial Complex Mamba** (CCMamba): SSMs for higher-order topologies
- Still early: scalability is poor, practical advantages over well-tuned GNNs on standard tasks are unclear

---

## IX. Scalability: The Unglamorous Frontier That Matters Most

### Training at Scale

- **Plexus** (arxiv 2505.04083, 2025): 3D parallel full-graph GNN training. 2.3–12.5x speedup over prior SOTA on 2048 GPUs. 5.2–54.2x reduction in time-to-solution.
- **PyG 2.0** (arxiv 2507.16991): Major update supporting billion-scale graphs, heterogeneous data, real-world deployments.
- **RapidGNN** (arxiv 2509.05207): Near-linear scalability with 44% energy efficiency improvement on CPU, 32% on GPU.
- **Snapchat GiGL** (arxiv 2502.15054): Production GNN system interfacing with PyG while handling scaling/productionization.

### Linear-Complexity Architectures

- **SGFormer**: O(N) single-layer attention, no approximation
- **GT-SNT**: Spiking node tokenization for 130x faster inference than standard GTs
- **AnchorGT**: Anchor-based sparse attention with almost-linear complexity
- **SMPNNs** (arxiv 2411.00835): "No Need for Attention" — convolutional message passing in transformer-style blocks matches GT performance

### The Scaling Law Question

Graph scaling laws are poorly understood compared to language/vision. Key finding: number of graphs is a bad metric for data volume due to irregular sizes; **number of edges** is more appropriate (arxiv 2402.02054). Scaling laws emerge even from random graph walks without power-law data structure (arxiv 2601.10684).

---

## X. What I Think: Opinionated Takes

1. **Graph transformers are overhyped for standard tasks.** The reassessment papers are devastating. For node classification and standard graph classification, start with a well-tuned GCN/GAT. Only reach for GTs when you have genuine long-range dependency needs or OOD requirements.

2. **The expressiveness obsession was a wrong turn.** 1-WL is sufficient for most practical datasets. Higher-order expressiveness often *hurts* generalization. The field spent years chasing theoretical power that doesn't translate to practical gains.

3. **Graph foundation models are 3–5 years behind language FMs**, and the gap may not close. Graphs lack universal tokenization. Every domain has different semantics. The "fail on industrial data" finding is damning.

4. **Equivariant GNNs for science are the field's crown jewel.** MACE and its descendants are genuinely transforming computational chemistry. This is where graph learning delivers irreplaceable value — not in yet another node classification benchmark.

5. **The hybrid Mamba-Transformer pattern will dominate.** Pure attention is too expensive for large graphs. Pure SSMs lose structural information. The Nemotron-H pattern (mostly Mamba, some attention) is the pragmatic sweet spot.

6. **Topological deep learning is intellectually exciting but practically premature.** Simplicial/cell complexes are theoretically richer than graphs, but the scalability and tooling aren't there. Watch this space in 2–3 years.

7. **GraphRAG is the most impactful LLM-graph integration**, not architectural fusion. The practical value is in structured retrieval for reasoning, not in making LLMs process graph tokens.

8. **Oversmoothing was a red herring.** The position papers are right — the field over-indexed on this problem. Most practical GNNs are shallow (2–4 layers) and never encounter oversmoothing. The real bottleneck was always engineering, not theory.

---

## Key Papers Reference

| Paper | Venue | Key Finding |
|-------|-------|-------------|
| Classic GNNs are Strong Baselines | NeurIPS 2024 | Tuned GCN/GAT/GraphSAGE match GTs on 17/18 datasets |
| Can Classic GNNs Be Strong Baselines (graph-level) | ICML 2025 | Classic GNNs top-3 on all datasets, first on 8 |
| Where Did the Gap Go? | NeurIPS 2024 | LRGB gap vanishes with basic HPO |
| The Oversmoothing Fallacy | ICLR 2026 | Oversmoothing influence overstated |
| Don't be Afraid of Over-Smoothing/Squashing | ICML 2025 | These phenomena less critical than assumed |
| PPGT (Plain Transformers) | arxiv 2504.12588 | Plain transformers competitive with subgraph/higher-order GNNs |
| MoSE | ICLR 2025 | Homomorphism-count encodings outperform RWSE |
| SPSE | ICLR 2025 | Simple path encoding beats RRWP |
| GrokFormer | ICLR 2025 | Fourier KAN spectral filters for adaptive graph representations |
| DYNAMO-GAT | ICLR 2025 | Dynamical systems pruning for deep GATs |
| MACE-Osaka24 | arxiv 2412.13088 | First universal MLIP covering molecules + crystals |
| GraphBFF | arxiv 2602.04768 | First billion-parameter GFM recipe |
| Plexus | arxiv 2505.04083 | 3D parallel GNN training, 2048 GPUs |
| Spectrum-Preserving Sparsification | ICML 2025 | Rewiring via edge removal, preserving spectrum |
| SSM formulation for GNNs | NeurIPS 2025 | State-space GNN fixes oversmoothing at zero cost |
| OpenGT | arxiv 2506.04765 | Comprehensive GT benchmark with standardized evaluation |
| Evaluating Progress in GFMs | arxiv 2603.10033 | March 2026 assessment of GFM state |
| DeFoG | ICLR 2025 | Discrete flow matching: SOTA with 5-10% of diffusion steps |
| GraphCast | Nature 2023 | GNN weather forecasting beats ECMWF HRES on 90% of targets |
| GenCast | Nature 2024 | Probabilistic ensemble weather prediction, 15-day SOTA |
| Can GNNs Learn Link Heuristics? | arxiv 2411.14711 | GNNs can't learn common neighbor counts from set-based pooling |
| On the Power of Heuristics in Temporal Graphs | arxiv 2502.04910 | Deep models struggle to capture key temporal patterns |
| PGNNCert | arxiv 2503.18503 | Deterministic certified defense against arbitrary poisoning |
| RelGT | arxiv 2505.10960 | Graph Transformer +18% on RelBench heterogeneous tasks |
| Mamba-3 | March 2026 | SSM +4% LM quality, 7x faster than transformers at long sequences |
| Nemotron 3 Super | GTC March 2026 | 120B hybrid Mamba-Transformer MoE, 1M context, 12B active params |

---

## XI. Additional Frontiers

### Temporal Graph Learning

Temporal GNNs (TGNNs) fuse graph topology with temporal evolution for dynamic predictions. Active area but with a sobering finding: **"current deep learning methods often struggle to capture the key patterns underlying predictions in real-world temporal graphs"** (arxiv 2502.04910). Heuristic methods based on recency and structural density often rival deep models. T-GRAB (arxiv 2507.10183) provides a diagnostic benchmark isolating temporal skills. Key challenge: positional encoding for temporal graphs remains limited (arxiv 2506.01596).

### Flow Matching Replacing Diffusion for Graph Generation

Flow matching is overtaking diffusion models for molecular generation:
- **DeFoG** (ICLR 2025): Discrete flow matching achieving SOTA on synthetic, molecular, and pathology datasets. Outperforms most diffusion models with **5–10% of their sampling steps**.
- **PropMolFlow** (Nature Computational Science, 2025): Flow matching sets SOTA for unconditional molecule generation, surpassing score-based diffusion. Diffusion still leads for property-guided generation.
- Flow matching provides deterministic ODE dynamics vs diffusion's stochastic SDE, yielding better efficiency and controllability.

### Graph Condensation

Emerging scalability technique: synthesize a compact substitute graph for efficient GNN training. Active research with multiple approaches (causal perspective, Gaussian process, information bottleneck). Key challenge: existing methods rely on bi-level optimization requiring extensive GNN training. Benchmarking efforts underway (arxiv 2405.14246).

### GNN Production Success Stories

The clearest production wins for GNNs:
- **GraphCast** (DeepMind, Nature 2023): GNN-based weather forecasting outperforms ECMWF's HRES on 90% of 2760 verification targets. 10-day forecasts in under a minute on a single TPU v4. Now operationally deployed.
- **GenCast** (DeepMind, Nature 2024): Probabilistic ensemble weather prediction with 50+ trajectories, 15-day forecasts with SOTA accuracy.
- **Fraud detection**: Real-time GNN inference for multihop risk propagation in transaction graphs (deployed in production alongside rule-based filters).
- **Recommendation systems**: GNN-based approaches adopted at Uber, Google, Pinterest, Twitter with substantial performance improvements over prior SOTA.

### Link Prediction: GNNs Can't Learn Common Neighbors

A striking finding: **"GNNs cannot effectively learn structural information related to the number of common neighbors between two nodes, primarily due to the nature of set-based pooling"** (arxiv 2411.14711). Heuristic methods (common neighbors, shortest paths) often rival vanilla GNNs for link prediction. This motivates subgraph-based and sequence-based approaches (SP4LP, PENCIL).

### Continual Graph Learning

Catastrophic forgetting on evolving graphs is an active challenge. Key approaches:
- **GCAL** (ICLR 2025): Bilevel optimization with information maximization for domain adaptation.
- **E-CGL**: Reduces catastrophic forgetting to -1.1% average across benchmarks.
- **Randomized representations** show "unreasonable effectiveness" for online continual graph learning (arxiv 2510.06819).
- Federated continual graph learning combines privacy preservation with evolving data.

### Adversarial Robustness and Certified Defenses

GNNs remain "extremely vulnerable to adversarial attacks on both graph structure and node attributes." Certified defenses maturing:
- **PGNNCert** (arxiv 2503.18503): Deterministic certification against arbitrary poisoning perturbations, outperforming prior certified defenses.
- **ELEGANT** (arxiv 2311.02757): Certified fairness defense — fairness level provably cannot be corrupted under certain perturbation budgets.
- Robustness also questions interpretability: explanations may not be robust to small perturbations (arxiv 2505.02566).

### Knowledge Graph Reasoning

Neurosymbolic approaches gaining traction:
- **Spectral NSR**: Embeds logical rules as spectral templates, performs inference in graph spectral domain. Unifies interpretability of symbolic reasoning with scalability of spectral learning.
- **Graph-as-Memory Cross-Attention**: LLM-KG fusion via cross-attention rather than shallow prefix concatenation.
- KG foundation models showing real transfer: 35% improvement across 31 benchmarks (arxiv 2505.11125).

### GNN for Combinatorial Optimization

Neural combinatorial optimization (NCO) for vehicle routing and scheduling is active but still augmenting rather than replacing classical solvers. GNN heatmaps improve Hybrid Genetic Search for CVRP. Generalization across problem sizes remains the key challenge.

### Privacy-Preserving Graph Learning

Federated graph learning with differential privacy is maturing. Local differential privacy mechanisms protect node features against inference attacks. Key tension: privacy-utility tradeoff — layer-specific noise calibration achieving ε=1.0, δ=10⁻⁵ with optimal tradeoffs.

### Uncertainty Quantification

Conformal prediction adapted for GNNs:
- **CondSR** (arxiv 2405.11968): Conditional shift-robust conformal prediction, model-agnostic for node classification.
- Valid conformal prediction for dynamic GNNs via tensor unfolding representation.
- For MLIPs: "the lack of reliable, general uncertainty quantification limits their safe, wide-scale use" — heterogeneous ensembles proposed as universal UQ metric.

### Explainability

Shift from model-centric to user-centric explanations. GraphXAIN enhances understandability, satisfaction, convincingness, and suitability. Self-explainable GNNs integrate explanation extraction with prediction. But: **robustness questions interpretability** — explanations may not be stable under perturbations.

---

## XII. Updated Opinionated Takes (Post-Additional Research)

Adding to the original 8 takes:

9. **GraphCast/GenCast are GNNs' strongest real-world validation.** Weather forecasting is where GNNs unambiguously beat the incumbent (ECMWF HRES) at scale, in production, with measurable impact. This plus MACE for molecular simulation are the two killer apps.

10. **Flow matching will replace diffusion for molecular generation within a year.** DeFoG's 5-10% sampling step result is too compelling. Diffusion may retain an edge for property-guided generation, but the efficiency gap is decisive.

11. **Link prediction exposes a fundamental GNN weakness.** The inability to learn common neighbor counts from set-based pooling is a real architectural limitation, not a tuning problem. This is why heuristics remain competitive.

12. **Graph condensation is underrated.** As graphs get bigger, the ability to synthesize compact training surrogates will become as important as model architecture. Watch this space.

13. **Temporal graph learning is where "simple baselines beat deep models" will hit next.** The finding that heuristics outperform TGNNs on real-world temporal patterns mirrors the GT vs GNN reassessment story. Expect position papers.

---

## XIII. More Application Domains

### Physical Simulation (Non-Molecular)

GNN-based learned simulators for meshes and particles are promising but face key limitations:
- **Error accumulation**: Autoregressive rollouts are "plagued by error accumulation and instability" (arxiv 2509.18445). Neural ODE formulations proposed as alternative.
- **Over-smoothing/squashing more pertinent**: "Physical systems are more complex and unstable, where every piece of information is crucial" — these issues matter more here than in NLP/CV (arxiv 2406.06060).
- **Scalability**: X-MeshGraphNet addresses multi-scale challenges; MGN-T overcomes long-range propagation limits on high-resolution meshes.
- **Modest speedups**: Physics-informed GNNs for n-body yield only ~17% speedup over conventional methods — not yet the orders-of-magnitude gains seen in molecular simulation.

### AlphaFold3: GNNs for Structural Biology

AlphaFold3 (May 2024, Nature) uses a diffusion-based architecture to predict joint structures of protein complexes with nucleic acids, small molecules, ions, and modified residues. 76% success rate on protein-ligand complexes (RMSD < 2Å). Far greater accuracy than specialized docking tools. Now enabling computational drug discovery at pharmaceutical companies.

### Chip Design / EDA

GNNs for circuit placement and routing:
- **TransPlace**: Transferable GNN placement with 1.2x speedup, 30% congestion reduction, 9% timing improvement.
- **RoutePlacer/RouteGNN**: End-to-end routability-aware placement.
- **LiTPlace** (2026): GNN inspired by signal propagation for timing-driven placement.
- Google's original graph placement methodology (Nature 2021) generates chip layouts matching human-designed standards in under 6 hours.

### 3D Vision and Robotics

- **3D semantic scene graphs**: Heterogeneous GNNs fuse local observations with historical data for incremental mapping.
- **Graph2Nav**: Real-time 3D object-relation graph generation for autonomous navigation.
- **RaGNNarok**: Lightweight GNN for enhancing radar point clouds on unmanned ground vehicles.

### Graph-Structured Reasoning for LLMs

Emerging paradigm using graph structures to organize LLM reasoning:
- **Diagram of Thought (DoT)**: LLM internally constructs and navigates a DAG of propositions, critiques, refinements, and verifications.
- **AGoT** (Adaptive Graph of Thought): Recursively decomposes queries into DAG of interdependent reasoning steps, unifying CoT/ToT.
- **GPTSwarm**: Represents agents as optimizable graphs where nodes are operations (LLM inference, tool use).
- **Agentic Deep Graph Reasoning**: Autonomous graph expansion coupling reasoning LLMs with continually updated graph representations.

### Multimodal Graph Learning

- **MARIO**: Multimodal graph reasoning with LLMs, capturing relational structure that VLMs miss when encoding image-text pairs in isolation.
- **MMGraphRAG**: Integrates visual scene graphs with text KGs via spectral clustering for cross-modal entity linking.
- VLMs show promise for interpreting visualized graph data but face input-token scalability bottlenecks.

## XIV. Generalization Theory

GNN generalization bounds are maturing but remain loose:
- **VC dimension**: 1-dimensional GNNs with a single parameter have *infinite* VC dimension for unbounded graphs (arxiv 2410.07829). Bounds investigated for Pfaffian activation functions.
- **PAC-Bayesian bounds**: Derived for both GCNs and MPGNNs, scaling with maximum degree. Norm-based bounds show promise for data-dependent guarantees.
- **Semi-supervised setting**: Sharp non-asymptotic risk bounds separating approximation, stochastic, and optimization errors, making explicit how performance scales with labeled node fraction (arxiv 2602.17115).

## XV. Systems and Infrastructure

### GNN Inference Serving

- **Omega** (arxiv 2501.08547): Low-latency GNN serving system for large graphs with minimal accuracy loss. Addresses the gap between training-focused research and production serving needs.
- Graph condensation as a serving optimization: synthesize compact graphs for faster inference.

### Reproducibility Concerns

"Experimental procedures often lack rigorousness and are hardly reproducible" (arxiv 1912.09893). GNN systems trend toward not showing training accuracy and relying on smaller datasets. Property-driven evaluation frameworks (arxiv 2603.00044) propose new quantitative metrics for generalizability, sensitivity, and robustness.

---

*Sources: ~90 web searches across arxiv, OpenReview, ICML/ICLR/NeurIPS proceedings, Nature, Google DeepMind, and technical blogs. July 2026.*
