# Graph & Graph Modeling Research: Synthesis of Insights (v2)

Source: Synthesis across 8 research notes + critical review with web-verified sources, March 2026

---

## Tier 1 — Paradigm-Level Insights

### 1. Structural Information Injection Dominates Architecture Choice — Within Scope

Three independent paper families converge on a single conclusion: **what structural information you give the model matters more than whether it's a GCN, GAT, or Transformer.**

- **Tuned-GNN** (NeurIPS 2024): *"With slight hyperparameter tuning, these classic GNN models achieve state-of-the-art performance, matching or even exceeding that of recent GTs across 17 out of the 18 diverse datasets examined."* — arXiv:2406.08993v2
- **CKGConv** (ICML 2024): Continuous kernels on pseudo-coordinates prove GCN matches GT expressiveness. — proceedings.mlr.press/v235/ma24k
- **PPGT** (arXiv:2504.12588v3, 2025–2026): *"The expressivity bottleneck of our PPGT model does not stem from its architecture, but rather from the design of positional encodings."* With I²GNN-derived PE, PPGT reaches 76% on BREC — surpassing all standalone methods.

The extended version from ICML 2025 confirms for graph-level tasks: *"contrary to prevailing beliefs, these classic GNNs consistently match or surpass the performance of GTs, securing top-three rankings across all datasets and achieving first place in eight."* — openreview.net/forum?id=ZH7YgIZ3DF

**However, this thesis is "PE over architecture" only in the narrow case.** The deeper principle, identified in the PPGT source analysis, is that **structural information injection** — whether achieved via PE, continuous kernels, or tokenization strategy — is the real variable. PE is one mechanism; it is not the only one.

**Scope: this thesis holds for IID evaluation on homophilic 2D graph benchmarks.** It has sharp, documented boundaries — see §2.

### 2. The Thesis Has Sharp Boundaries — Some Are Existential Threats

The convergence thesis breaks, or is untested, in at least five settings. Two of these are not merely "caveats" — they threaten the thesis's practical utility.

**Boundary 1 (existential): OOD generalization — architecture may matter after all.**

The thesis rests entirely on IID benchmark evaluation. Under distribution shift, the picture inverts:

> *"Our results reveal that GT and hybrid GT-MPNN backbones demonstrate stronger generalization ability compared to MPNNs, even without specialized DG algorithms (on four out of six benchmarks)."*
> — Exploring Graph-Transformer OOD Generalization Abilities (arXiv:2506.20575v2, June 2025)

If GTs and MPNNs match on IID benchmarks (per tuned-baseline papers) but GTs generalize better OOD, then **architecture encodes an inductive bias invisible to IID evaluation but critical for deployment.** This directly contradicts "architecture doesn't matter" for the most practically relevant setting.

Counterpoint: GOODFormer (arXiv:2508.00304v2, updated March 2026) argues GT advantages *don't* survive distribution shifts. The OOD evidence is **contradictory** — not settled in either direction. This is the single most important open question for the convergence thesis.

Also: *"Graph learning models often suffer from limited generalization when applied beyond their training distributions."* — OOD Generalization in Graph Foundation Models (arXiv:2601.21067, Jan 2026)

**Boundary 2 (existential): PE scalability constrains the thesis at real-world scale.**

If "invest in PE" is the recommendation, PE must be computable at the scale you need:

- **Laplacian eigenvectors**: O(N³) naively, O(N·k²) via Lanczos for k eigenvectors. For billion-node graphs, even Lanczos is expensive.
- **RRWP**: Depends on walk length and graph density. Dense storage is O(N² × D_pe).
- **Spectral truncation**: Fails for expander-like graphs (social networks, power-law graphs) where the spectrum decays slowly.

> *"Extending static Laplacian eigenvector approaches to temporal graphs through the supra-Laplacian has shown promise, but also poses key challenges: high eigendecomposition costs, limited theoretical understanding."*
> — Understanding and Improving Laplacian PE for Temporal GNNs (arXiv:2506.01596)

The thesis "PE is what matters" is only actionable if PE is computable. For billion-node graphs, this may not hold, making the convergence thesis an academic insight that doesn't transfer to production systems (Pinterest, Uber, Snapchat all run GNNs at billion-node scale without expensive PE).

**Boundary 3: 3D molecular geometry** — architecture (equivariant vs. invariant) makes an irreducible difference; PE and architecture are fused. See §8.

**Boundary 4: Heterophilic graphs** — largely untested. New evidence suggests geometry beyond homophily matters:

> *"Standard message-passing GNNs often struggle on graphs with low homophily, yet homophily alone does not explain this behavior, as graphs with similar homophily levels can exhibit markedly different performance."*
> — When Geometry Matters Beyond Homophily in GNNs (arXiv:2601.18912, Jan 2026)

**Boundary 5: PE × architecture interaction is non-trivial.**

> *"Our findings demonstrate that previously untested combinations of GNN architectures and PEs can outperform existing methods."*
> — Benchmarking Positional Encodings for GNNs and Graph Transformers (arXiv:2411.12732, Nov 2024)

The thesis implies PE and architecture are separable. This paper shows they interact combinatorially — optimal PE depends on the backbone.

### 3. Tokenization Strategy Subsumes PE — The Higher-Order Choice

The Edge Transformer (Müller et al., NeurIPS 2024, arXiv:2401.10119) achieves ≥3-WL expressivity **with zero PE** by tokenizing node pairs instead of nodes:

> *"We show that the recently proposed Edge Transformer … has at least 3-WL expressive power when provided with the right tokenization … without relying on positional or structural encodings."*

This reframes the convergence thesis: **"PE over architecture" is a special case of "structural information injection over architecture."** Whether you encode structure as PE, as continuous kernels, or as implicit in tokenization is a design choice at a higher level of abstraction. The PPGT source analysis identifies this explicitly: *"The bottleneck isn't PE per se — it's the level of abstraction at which tokens are defined."*

| Tokenization level | PE needed? | Expressivity | Cost |
|---|---|---|---|
| Node-level (PPGT, GRIT) | **Yes** — structure must be injected | Up to GD-WL; PE-dependent | O(N² × D) attention + PE cost |
| Pair-level (Edge Transformer) | **No** — structure is implicit | ≥3-WL natively | O(N⁴ × D) attention |
| Message-passing (GCN, GAT) | Partially — topology hardwired | 1-WL base; PE augments | O(E × D) |

The practical tradeoff: pair-level tokenization trades PE computation for N⁴ attention cost. Neither extreme scales well to large graphs.

### 4. Graph Foundation Models: One Domain Working, the Rest Aspirational

**In scientific computing (atomistic simulation): the foundation-model paradigm is demonstrably working**, with caveats.

MACE-Osaka24 (arXiv:2412.13088, Dec 2024): *"the first open-source neural network potential model based on a unified dataset covering both molecular and crystalline systems … shows strong performance across diverse chemical systems, exhibiting comparable or improved accuracy in predicting organic reaction barriers compared to specialized models, while effectively maintaining state-of-the-art accuracy for inorganic systems."*

**But "working" ≠ "universal."** Documented failure modes:

- **Catalysis**: *"Models such as MACE-OMAT and -MPA exhibit repulsion between U-corrected metals and their oxides, limiting their value for studying catalysis and oxidation."* — arXiv:2601.21056, Jan 2026
- **Alkali/alkaline earth metals**: *"significant performance gaps emerge in alkali and alkaline earth metal groups."* — arXiv:2512.20230, Dec 2025
- **High-energy kinetics**: *"the reliability of universal machine learning interatomic potentials (uMLIPs) in capturing these high-energy landscapes remains uncertain."* — arXiv:2601.10938, Jan 2026
- **Fundamentally interpolative**: *"This restricts the scope of MLIPs to interpolative calculations, essentially denying the possibility of using them to discover new phenomena in a serendipitous way."* — arXiv:2511.17449, Nov 2025

MACE faces active competition from GRACE (arXiv:2508.17936, Aug 2025): *"This work establishes GRACE as a robust and adaptable foundation for the next generation of atomistic modeling, enabling high-fidelity simulations across the periodic table."* And from efficiency-focused alternatives achieving comparable performance with <10% of MACE's training compute (arXiv:2509.08418, Sep 2025).

**For general-purpose graphs: GFMs remain aspirational.**

> *"A versatile GFM has not yet been achieved. The key challenge in building GFM is how to enable positive transfer across graphs with diverse structural patterns."*
> — Graph Foundation Models (arXiv:2402.02216v2, Feb 2024)

> *"Achieving strong transferability is a major challenge due to the structural, feature, and distributional variations in graph data."*
> — Towards Graph Foundation Models (arXiv:2503.09363, March 2025)

The gap between scientific MLIPs and general GFMs is fundamental, not just a matter of scale: scientific graphs have consistent node/edge semantics (atoms, bonds, 3D coordinates) and physics-based loss functions. General graphs (social, citation, knowledge) have heterogeneous semantics across domains and no equivalent of energy conservation as a training signal.

---

## Tier 2 — Mechanistic / Technical Insights

### 5. Why Standard Transformers Fail on Graphs (Two Bottlenecks)

The PPGT paper (Ma et al., arXiv:2504.12588v3) provides the most precise diagnosis:

**Bottleneck A: The backbone destroys magnitude.**

Four-link causal chain: (1) Graph learning = multiset encoding. (2) Cardinality encodes as magnitude: {{a,b}} → x, {{a,a,b,b}} → 2x. (3) LayerNorm/RMSN projects tokens onto a hypersphere: RMSN(x) = RMSN(cx), erasing scale. (4) SDP attention decomposes as cos(q,k)·‖q‖·‖k‖/√D — query norm acts as temperature, never measuring closeness between ‖q‖ and ‖k‖.

**Bottleneck B: MLP PE stems lose high-frequency detail.**

Spectral bias of neural networks (Rahaman et al., ICML 2019) causes MLP-based PE stems to prioritize low-frequency modes, losing fine-grained structural information in RRWP.

**Three minimal fixes:** (1) **sL₂ attention** — SDP + bias term −k^Tk/(2√D), measuring both angular and Euclidean closeness. (2) **AdaRMSN** — input-dependent re-scaling after normalization. (3) **SPE** — sinusoidal pre-encoding on RRWP before the MLP stem (inspired by NeRF). All implementable via FlashAttention. Impact of SPE on BREC: 54.5% → 58.5%, with the entire gain on the hardest (CFI) category.

**On "plainness" as rhetoric:** PPGT uses non-standard attention (sL₂ ≠ SDP), non-standard normalization (AdaRMSN ≠ RMSN), and a URPE multiplicative term requiring custom attention code. It is simpler than GRIT but not "plain" the way ViT or GPT-2 is plain. TokenGT (Kim et al., NeurIPS 2022) used a genuinely unmodified Transformer and performed worse — showing the modifications matter. Better framing: **"minimally modified Transformers can be powerful graph learners."**

**Cross-modal relevance of AdaRMSN:** Recent multimodal LLM work (arXiv:2512.08374, Dec 2025) finds standard pre-norm causes *"an 'asymmetric update dynamic,' where high-norm visual tokens exhibit a 'representational inertia.'"* This is precisely the magnitude-erasure problem. AdaRMSN may be broadly useful whenever multiple signal types with different norm distributions interact — not just for graphs.

### 6. The Oversmoothing Narrative Has Collapsed

Five independent position papers challenge the premise that oversmoothing was THE central GNN problem:

| Paper | Venue/Date | Claim |
|---|---|---|
| "The Oversmoothing Fallacy" | ICLR 2026 submission | Influence overstated |
| "Don't be Afraid of OS and OSq" | arXiv Jan 2026 (2601.07419) | Less critical than assumed |
| "Position: Misled by OS/OSq" | ICML 2025 | **Can be beneficial** for graph-level tasks |
| "Are We Measuring Correctly?" | arXiv Feb 2025 (2502.04591) | Metrics may be wrong |
| "Demystifying Common Beliefs" | arXiv May 2025 (2505.15547) | Consolidated beliefs not always true |

The ICML 2025 position paper goes furthest: *"For graph-level tasks, over-smoothing can even be beneficial if the smoothed state is label-informative."* — openreview.net/forum?id=U46jD48SJi

**Practical reality:** Most practitioners still use 2–4 layer GNNs. The entire oversmoothing-as-central-problem framing may have been a theoretical detour. This doesn't mean DYNAMO-GAT and other fixes are useless — they enable deeper architectures when depth genuinely helps — but the framing of "oversmoothing is the problem, depth is the solution" is now contested at its foundation.

### 7. Over-Squashing ≠ Oversmoothing — And It's the Real Justification for GTs

Over-squashing (exponential compression through graph bottlenecks) is distinct from oversmoothing and is the actual theoretical reason full attention helps. The SSM bridge paper (NeurIPS 2025, arXiv:2502.10818) provides the key unification:

> *"We propose an interpretation of GNNs as recurrent models and empirically demonstrate that a simple state-space formulation of a GNN effectively alleviates over-smoothing and over-squashing at no extra trainable parameter cost."*

This unifies oversmoothing, over-squashing, and vanishing gradients under a single recurrent/SSM framework — suggesting these aren't three separate problems requiring three separate fixes, but manifestations of one underlying issue (information propagation dynamics).

Graph rewiring (the third strategy besides "make GTs scalable" and "make MPNNs deeper") is an active but contested approach. Over-squashing is generating practical solutions at top venues (Spectrum-Preserving Sparsification, ICLR 2025), but rewiring effectiveness itself is questioned: *"edges selected during the rewiring process are not in line with theoretical criteria identifying bottlenecks"* on real-world data (arXiv:2407.09381, July 2024).

### 8. The PE Design Frontier Is Wide Open — And Moving Fast

The PE design space has at least **five** axes, all currently explored independently:

1. **Diffusion-based**: RRWP, Laplacian eigenvectors (spectral)
2. **Path-counting**: **SPSE** (ICLR 2025) — simple path counts between node pairs. Already outperforms RRWP: *"SPSE demonstrates significant performance improvements over RRWP on various benchmarks, including molecular and long-range graph datasets."* — proceedings.mlr.press/v267/airale25a. This is notable because it supersedes the PE that PPGT's mechanistic story is built around.
3. **Combinatorial**: Homomorphism counts / **MoSE** (ICLR 2025): *"MoSE outperforms other well-known positional and structural encodings across a range of architectures."* — proceedings.iclr.cc. I²GNN-derived PE pushed PPGT from 58.5% → 76% on BREC, suggesting the combinatorial axis has the most immediate headroom.
4. **Topological**: Persistent homology (arXiv:2506.05814), simplicial random walks via Hodge Laplacians (NeurIPS 2023).
5. **Learned / Pre-trained**: **GFSE** (arXiv:2504.10917) — the first cross-domain graph structural encoder pre-trained with self-supervised objectives: *"designed to capture transferable structural patterns across diverse domains such as molecular graphs, social networks, and citation networks."* This points toward PE-as-a-service — pre-trained structural representations as a reusable component.

No existing PE combines all five. The decisive experiment remains PPGT's PE-swap: same architecture, different PE → 17.5pp jump on BREC. **PE design is the highest-leverage intervention for graph learning expressivity** — but which PE depends on the task, the graph family, and (per arXiv:2411.12732) the architecture.

**PE scalability remains the Achilles' heel**: Laplacian eigenvectors = O(N³), RRWP = O(N·K·E) for K-step walks, SPSE = NP-hard to count exactly (approximated). For billion-node production graphs, none of these are cheap. Factored storage (spectral decomposition → O(N×m) per-node) helps with memory but not compute, and truncation error is high for expander-like graphs.

### 9. Equivariance = Baked-In Physics = Data Efficiency

Equivariant GNNs guarantee correct symmetry by construction (E(3) group). MACE reproduces experimental molecular vibrational spectra from **50 training configurations**. This is the strongest argument for domain-specific architectural inductive bias — and the clearest refutation of "architecture doesn't matter" in the domain where it matters most.

The equivariant/invariant distinction is a genuine architectural choice that PE cannot replace: encoding 3D rotation/translation symmetry as a network constraint (equivariant) vs. learning it from augmented data (invariant) produces measurably different data efficiency and generalization. This is the sharpest boundary of the convergence thesis.

---

## Tier 3 — Emerging Paradigms

### 10. Graph State Space Models — A Fourth Architecture With Real Limitations

Comprehensive survey: arXiv:2412.18322. Graph SSMs are an established architecture family with concrete results:

- **STG-Mamba**: SOTA for spatial-temporal graph forecasting with linear complexity. — arXiv:2403.12418v4
- **Graph Mamba for WSI**: Transformer-level performance with 7× fewer FLOPs. — arXiv:2505.17457
- **HGMN**: Heterogeneous Graph Mamba. — arXiv:2405.13915
- **Topological SSMs**: Mamba on simplicial complexes. — arXiv:2409.12033

**But Mamba has fundamental limitations the graph community has not fully reckoned with:**

- **Long-range failure**: *"A surprising weakness remains: despite being built on architectures designed for long-range dependencies, Mamba performs poorly on long-range sequential tasks."* — arXiv:2505.09022, May 2025
- **Copying/ICL weakness**: *"Both Mamba and Mamba-2 models lag behind Transformer models on tasks which require strong copying or in-context learning abilities."* — arXiv:2406.07887, June 2024
- **Non-causal interaction limit**: *"The recurrent scanning mechanism of Mamba offers computational efficiency [but] inherently limits non-causal interactions between image patches."* — arXiv:2603.16423, March 2026
- **Graph linearization is lossy**: Converting a graph to a sequence for Mamba requires a "graph scanning" strategy that imposes a linear ordering on inherently non-linear topology. Information is necessarily lost. The scan order becomes a design choice with no principled default.

For the convergence thesis: if "PE over architecture" holds, then Graph SSMs with good PE should match GTs — and the GNN-as-SSM bridge paper (arXiv:2502.10818) suggests something like this. But SSMs' inability to do precise structural recall (copying) and non-causal interaction may limit their ceiling on tasks requiring exact topology awareness.

**Assessment:** Graph SSMs are real, competitive on efficiency-sensitive tasks (spatiotemporal forecasting, medical imaging), and worth tracking. But they are not a universal replacement for attention, and presenting them as "SOTA with linear complexity" without noting their long-range and copying weaknesses is misleading.

### 11. LLM + Graph Integration — Active, Unsolved, Not Imminent

LLM-GNN integration is a recognized architecture family with a taxonomy (enhancer, predictor, alignment — per arXiv:2311.12399v4) and 5+ surveys. But the fundamental challenges remain unsolved:

> *"Early 'LLM-centered' pipelines (e.g., converting graphs to serialized token sequences or using text-only prompts) fail to encode permutation invariance or message passing, resulting in poor graph learning."*
> — emergentmind.com/topics/gnn-llm-integration, Feb 2026

> *"LLM-centered models often struggle to capture graph structures effectively, while GNN-centered models compress variable-length textual data into fixed-size vectors, limiting their ability to understand complex semantics."*
> — Rethinking the Combination of GNN and LLM (arXiv:2412.06849)

The core tension: LLMs are sequence models that fundamentally lack permutation invariance. Graphs are permutation-invariant structures. Text serialization of graphs is inherently order-dependent, violating this property. Hybrid architectures (GNN encoder → LLM, or LLM features → GNN) work better but don't obsolete either component.

**Where LLM-Graph integration genuinely helps:** Text-attributed graphs (social networks, citation graphs, knowledge graphs) where node features are rich text. Here, LLMs provide semantic understanding that GNNs can't match, and the combination is strictly better than either alone. For pure-structure tasks (molecular graphs, combinatorial optimization), LLMs add little.

**Assessment:** LLM-GNN hybrids will reshape text-attributed graph processing. They will not obsolete the GAT/GCN/GT taxonomy for structure-centric tasks. The framing "may obsolete" was overclaimed.

### 12. Total Energy Alignment (TEA) — A Transferable Data Engineering Pattern

TEA solves heterogeneous dataset fusion by learning per-element energy offsets during training (arXiv:2412.13088). Analogous to BatchNorm's per-channel shifts: different datasets define "zero energy" differently, and TEA learns the offset.

This pattern transfers to any domain with incompatible label scales across data sources — multi-site clinical data, multi-institution sensor networks, merged financial datasets with different accounting conventions. The insight is that dataset-level bias is a learnable nuisance parameter, not a data-cleaning prerequisite.

### 13. Graph Self-Supervised Learning — The Missing Mechanism for GFMs

The synthesis of GFM discussion (§4) requires acknowledging how GFMs pre-train. Graph self-supervised learning is the mechanism:

- **Contrastive**: GraphCL, BGRL, CCA-SSG — learn by contrasting augmented views
- **Generative**: GraphMAE, GraphMAE2 — learn by reconstructing masked features
- **Hybrid**: CORE (arXiv:2512.13235, Dec 2025) outperforms GraphMAE by up to 3.82% on graph classification

> *"Self-supervised learning (SSL) on graphs generates node and graph representations that can be used for downstream tasks. Graph SSL is particularly useful in scenarios with limited or no labeled data."*
> — Generative and Contrastive Graph Representation Learning (arXiv:2505.11776, May 2025)

For scientific GFMs (MACE), the pre-training signal is physics (energy, forces, stress). For general GFMs, the equivalent is graph SSL — and the fact that graph SSL lags behind text/image SSL in transfer quality is a major reason general GFMs lag behind scientific ones.

---

## Tier 4 — Cautionary / Methodological

### 14. NodePFN: A Case Study in "Universal" Claims That Aren't

The PFN-for-graphs idea is sound, but execution reveals: 5 per-dataset hyperparameters, dead GP prior (MLP-only training), double self-loop bug corrupting GCN normalization, test-time normalization leakage, 16 hops of compounded message-passing, and the "posterior predictive distribution" claim violated at 3 levels.

- *Source:* [nodepfn-review.md](nodepfn-review.md), [nodepfn-review-gaps.md](nodepfn-review-gaps.md), [nodepfn-review-supplement.md](nodepfn-review-supplement.md)

### 15. Benchmarking Is Broken — And OOD Evaluation Is the Missing Piece

**IID benchmarks are unreliable:**

> *"Through a rigorous empirical analysis, we demonstrate that the reported performance gap is overestimated due to suboptimal hyperparameter choices. It is noteworthy that across multiple datasets the performance gap completely vanishes after basic hyperparameter optimization."*
> — Where Did the Gap Go? (Tönshoff et al., ICML 2024, arXiv:2309.00367)

LRA's "long-range" performance comes mostly from short-range dependencies (arXiv:2501.14850). No large-scale realistic graph benchmark comparable to ImageNet/GLUE exists. OpenGT (arXiv:2506.04765) is attempting to fill this gap.

**OOD evaluation is the real frontier.** Almost all claims in this synthesis — convergence thesis, tuned baselines, PE-over-architecture — rest on IID evaluation. Under distribution shift, the picture may be fundamentally different (see §2, Boundary 1). Until OOD evaluation becomes standard, **every IID-only result should be treated as provisional.**

---

## Practitioner's Decision Guide

For someone starting a graph learning project today:

**Step 1: What kind of graph?**

| Graph type | Recommended starting point | Why |
|---|---|---|
| 3D molecular geometry | Equivariant GNN (MACE, NequIP) | Physics symmetry is non-negotiable; PE can't substitute |
| Text-attributed (social, citation, KG) | GNN + LLM features (E-LLaGNN pattern) | LLM provides semantic features; GNN provides structure |
| Pure topology, small (< 10K nodes) | GCN/GAT + SPSE or MoSE PE | Simple, fast, PE gives expressivity; start simple |
| Pure topology, large (> 100K nodes) | GCN/GAT with RWSE or no PE | PE scalability limits; message-passing still wins on efficiency |
| Spatiotemporal | STG-Mamba or GAT + temporal attention | SSMs are genuinely competitive here; linear complexity matters |

**Step 2: When to upgrade to a Graph Transformer**

Use a GT (PPGT, GraphGPS) only if:
1. Your task requires genuine long-range dependencies (test this — most don't)
2. Your graphs are small enough for O(N²) attention
3. You've already tried a tuned GCN/GAT with good PE and it's not sufficient

**Step 3: PE selection**

- **Default**: SPSE (ICLR 2025) — outperforms RRWP, reasonable compute
- **If expressivity matters**: MoSE (ICLR 2025) — homomorphism counts, strong on molecular
- **If scale matters**: RWSE — cheaper than Laplacian eigenvectors
- **If transfer matters**: GFSE (arXiv:2504.10917) — pre-trained cross-domain

**Step 4: Don't forget**

- Tune your baselines. The GT advantage is largely a tuning artifact.
- Test OOD if you're deploying. IID benchmarks don't predict deployment performance.
- Oversmoothing is probably not your problem. Most tasks work fine with 2–4 layers.

---

## Key Papers for Deep Dive

| Paper | Why | Priority |
|---|---|---|
| PPGT (arXiv:2504.12588v3) | Mechanistic root cause of GT failures + minimal fixes | **Must read** |
| CKGConv (ICML 2024) | Proves GCN = GT expressiveness; continuous kernel design | **Must read** |
| Tuned GNNs (NeurIPS 2024 + ICML 2025) | Deflates GT hype with rigorous baselines | **Must read** |
| MACE-Osaka24 (arXiv:2412.13088) | Working scientific graph foundation model + TEA | **Must read** |
| SPSE (ICLR 2025, proceedings.mlr.press/v267/airale25a) | Already outperforms RRWP; path-counting PE | **Must read** |
| GT OOD Generalization (arXiv:2506.20575v2) | GTs may generalize better OOD — challenges convergence thesis | **Must read** |
| GNN-as-SSM bridge (arXiv:2502.10818, NeurIPS 2025) | Unifies oversmoothing/over-squashing/vanishing gradients | High |
| MoSE (ICLR 2025) | Homomorphism-count PE — new PE paradigm | High |
| GRACE (arXiv:2508.17936) | MACE's primary competitor; efficiency gains | High |
| Edge Transformer (arXiv:2401.10119, NeurIPS 2024) | Pair-level tokenization bypasses PE entirely | High |
| GFSE (arXiv:2504.10917) | Pre-trained cross-domain PE | Medium |
| Graph SSM survey (arXiv:2412.18322) | Fourth architecture paradigm | Medium |
| GOODFormer (arXiv:2508.00304v2) | OOD evaluation for GTs | Medium |
| DYNAMO-GAT (ICLR 2025) | Best oversmoothing fix (if the problem matters) | Medium |
| GrokFormer (ICLR 2025) | KAN + Fourier spectral filters | Medium |

---

## Open Questions (Ranked by Impact)

1. **Does architecture matter OOD?** arXiv:2506.20575 says yes (GTs > MPNNs OOD); GOODFormer says no. If yes, the convergence thesis is limited to academic benchmarks. This is testable and urgent.

2. **Can PE scale to billion-node graphs?** Current best PEs (SPSE, MoSE, Laplacian) are too expensive for production-scale graphs. Either new O(N) PEs emerge, or the convergence thesis doesn't apply where industry needs it.

3. **Will general-purpose GFMs emerge?** Scientific MLIPs work because chemistry provides consistent semantics and physics-based loss. No equivalent exists for social/citation/knowledge graphs. Graph SSL is the candidate mechanism, but transfer quality lags text/image SSL.

4. **How do graph SSMs interact with PE?** If the convergence thesis holds, Graph Mamba + good PE should match Graph Transformers. Untested.

5. **Is the oversmoothing/over-squashing distinction practically meaningful?** The SSM bridge paper (arXiv:2502.10818) suggests they're manifestations of the same underlying dynamics. If so, the separate literatures should merge.

---

## Source Notes

This synthesis draws from 8 research notes in `personal_notes/research/` plus a critical review with web-verified sources:

1. `graph-neural-networks-progress-2025-2026.md` — Base survey of GAT/GT/GCN landscape
2. `graph-neural-networks-progress-2025-2026-review.md` — Gap analysis identifying 7 omissions
3. `graph-neural-networks-progress-2025-2026-review-v2.md` — Meta-review verifying gaps against primary sources
4. `graph-transformers-pe-bottleneck-simplicity.md` — Deep dive on PPGT and the PE bottleneck thesis
5. `nodepfn-review.md` — Critical code review of NodePFN (ICLR 2026)
6. `nodepfn-review-supplement.md` — Additional bugs and issues found in deep audit
7. `nodepfn-review-gaps.md` — Gap analysis of the NodePFN review itself
8. `mace-osaka24-explainer.md` — Equivariant GNNs and the MACE foundation model story
9. `graph-research-synthesis-review.md` — Critical review of v1 with web-verified sources (March 2026)
