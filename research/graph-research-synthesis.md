# Graph & Graph Modeling Research: Synthesis of Insights

Source: Synthesis across 7 research notes, March 2026

---

## Tier 1 — Paradigm-Level Insights

### 1. PE over Architecture: The Convergence Thesis
Three independent paper families (Tuned-GNN @ NeurIPS 2024, CKGConv @ ICML 2024, PPGT @ arXiv 2026) converge: **what structural information you give the model matters more than whether it's a GCN, GAT, or Transformer.** Well-tuned classic GNNs with good PE match Graph Transformers at a fraction of the compute.
- *Source:* [graph-neural-networks-progress-2025-2026.md](graph-neural-networks-progress-2025-2026.md) §5 (convergence table + deep dive)
- *Source:* [graph-transformers-pe-bottleneck-simplicity.md](graph-transformers-pe-bottleneck-simplicity.md) (full mechanistic explanation)

### 2. The Thesis Has Sharp Boundaries
The PE-over-architecture thesis holds for **2D graph benchmarks** but breaks in at least three domains:
- **3D molecular geometry** — architecture (equivariant vs. invariant) makes an irreducible difference; PE and architecture are fused
- **Heterophilic graphs** — untested
- **OOD generalization** — untested; GOODFormer (arXiv:2508.00304) suggests GT advantages don't survive distribution shifts
- *Source:* [graph-neural-networks-progress-2025-2026-review-v2.md](graph-neural-networks-progress-2025-2026-review-v2.md) §§Gap 2, Review-Gap B, Gap 5
- *Source:* [mace-osaka24-explainer.md](mace-osaka24-explainer.md) Step 11

### 3. Graph Foundation Models Already Exist — In Science
MACE-Osaka24 is the first open-source proof that the foundation-model paradigm works for graphs: pre-train broadly (molecules + crystals via TEA dataset unification), fine-tune cheaply, transfer across chemical domains. It matches specialized models on molecules while maintaining SOTA on inorganics.
- *Source:* [mace-osaka24-explainer.md](mace-osaka24-explainer.md) Steps 5–9
- *Source:* [graph-neural-networks-progress-2025-2026-review-v2.md](graph-neural-networks-progress-2025-2026-review-v2.md) §Gap 2 (MACE-Osaka24 verified)

---

## Tier 2 — Mechanistic / Technical Insights

### 4. Why Standard Transformers Fail on Graphs (Two Bottlenecks)
- **Bottleneck A:** LayerNorm/RMSN destroys magnitude information that encodes multiset cardinality (critical for WL-expressivity). SDP attention measures angular similarity only, blind to magnitude closeness.
- **Bottleneck B:** MLP PE stems lose high-frequency structural features due to spectral bias of neural nets.
- **Fixes:** AdaRMSN (input-dependent re-scaling), sL₂ attention (SDP + Euclidean bias term), SPE (sinusoidal pre-encoding). All implementable via FlashAttention.
- *Source:* [graph-transformers-pe-bottleneck-simplicity.md](graph-transformers-pe-bottleneck-simplicity.md) §§Bottleneck A, B

### 5. Oversmoothing Narrative Has Collapsed
Five independent position papers (ICLR 2026, ICML 2025, arXiv 2025–2026) challenge the premise that oversmoothing was THE central GNN problem. It may be **overstated**, **incorrectly measured**, or even **beneficial** in some settings. Most practitioners still use 2–4 layer GNNs.
- *Source:* [graph-neural-networks-progress-2025-2026-review-v2.md](graph-neural-networks-progress-2025-2026-review-v2.md) §Gap 6 (table of 5 papers)
- *Source:* [graph-neural-networks-progress-2025-2026-review.md](graph-neural-networks-progress-2025-2026-review.md) §Gap 6

### 6. Over-Squashing ≠ Oversmoothing (And It's the Real Justification for GTs)
Over-squashing (exponential compression through graph bottlenecks) is distinct, less studied in the original survey, and is the actual theoretical reason full attention helps. The SSM bridge paper (NeurIPS 2025, arXiv:2502.10818) unifies oversmoothing, over-squashing, and vanishing gradients under one recurrent/SSM framework.
- *Source:* [graph-neural-networks-progress-2025-2026-review.md](graph-neural-networks-progress-2025-2026-review.md) §Gap 1
- *Source:* [graph-neural-networks-progress-2025-2026-review-v2.md](graph-neural-networks-progress-2025-2026-review-v2.md) §Gap 1 (confirmed + extended)

### 7. The PE Design Frontier Is Wide Open
Four independent axes — diffusion (RRWP, Laplacian), combinatorial (homomorphism counts / MoSE), topological (persistent homology), learned (end-to-end) — all explored in isolation. No PE combines all four. I²GNN-derived PE pushed PPGT from 58.5% → 76% on BREC, suggesting combinatorial axis has most immediate headroom. PE scalability is the Achilles' heel: Laplacian eigenvectors = O(N³), RRWP depends on walk length.
- *Source:* [graph-transformers-pe-bottleneck-simplicity.md](graph-transformers-pe-bottleneck-simplicity.md) §PE Design Frontier

### 8. Equivariance = Baked-In Physics = Data Efficiency
Equivariant GNNs guarantee correct symmetry by construction (E(3) group). MACE reproduces experimental molecular vibrational spectra from **50 training configurations**. This is the strongest argument for domain-specific architectural inductive bias.
- *Source:* [mace-osaka24-explainer.md](mace-osaka24-explainer.md) Steps 3–4

---

## Tier 3 — Emerging Paradigms to Track

### 9. Graph State Space Models (Mamba/S4) — The Fourth Architecture
Comprehensive survey exists (arXiv:2412.18322). STG-Mamba achieves SOTA with linear complexity. Graph Mamba for WSI achieves Transformer-level performance with 7× fewer FLOPs. A fourth paradigm beyond MPNN/GAT/GT that the convergence thesis must account for.
- *Source:* [graph-neural-networks-progress-2025-2026-review-v2.md](graph-neural-networks-progress-2025-2026-review-v2.md) §Review-Gap A

### 10. LLM + Graph Integration — May Obsolete the Taxonomy
If LLMs can handle graph tasks via text serialization or hybrid GNN-LLM architectures, the GAT/GCN/GT debate becomes moot. Three+ surveys, recognized architecture taxonomy (GNN-LLM integration). Still unsolved: LLMs struggle with structure, GNNs compress text.
- *Source:* [graph-neural-networks-progress-2025-2026-review.md](graph-neural-networks-progress-2025-2026-review.md) §Gap 3
- *Source:* [graph-neural-networks-progress-2025-2026-review-v2.md](graph-neural-networks-progress-2025-2026-review-v2.md) §Gap 3

### 11. Total Energy Alignment (TEA) — A Transferable Data Engineering Pattern
TEA solves heterogeneous dataset fusion by learning per-element energy offsets during training. Analogous to BatchNorm's per-channel shifts. This pattern may transfer to other domains with incompatible label scales across data sources.
- *Source:* [mace-osaka24-explainer.md](mace-osaka24-explainer.md) Steps 6–7

---

## Tier 4 — Cautionary / Methodological

### 12. NodePFN: A Case Study in "Universal" Claims That Aren't
The PFN-for-graphs idea is sound, but execution reveals: 4 per-dataset hyperparameters + 32-member ensembles contradicting "universality," dead GP prior (MLP-only training), double self-loop bug corrupting GCN normalization, test-time normalization leakage, PFN independence violated at 3 levels (pre-smoothing, normalization, GCN leakage), and an obsolete TabPFN v1 backbone. The preprocessing pipeline does the heavy lifting — FAFs (NeurIPS 2025) suggest fixed graph features + any classifier ≈ GNNs, making the PFN apparatus potentially superfluous. Competitive landscape has moved past it: G2T-FM, GraphPFN, BOLERO, GraphAny all address the same problem with stronger foundations.
- *Source:* [nodepfn-review-consolidated.md](nodepfn-review-consolidated.md) (consolidated review — supersedes individual documents below)
- *Prior sources (superseded):* [nodepfn-review.md](nodepfn-review.md), [nodepfn-review-gaps.md](nodepfn-review-gaps.md), [nodepfn-review-supplement.md](nodepfn-review-supplement.md), [nodepfn-review-supplement-gaps.md](nodepfn-review-supplement-gaps.md)

### 13. Benchmarking Is Broken
LRGB's GT advantage largely vanishes with proper HP tuning ("Where Did the Gap Go?" ICML 2024). LRA's "long-range" performance comes mostly from short-range dependencies. No large-scale realistic graph benchmark comparable to ImageNet/GLUE exists. OOD generalization is untested for most claims.
- *Source:* [graph-neural-networks-progress-2025-2026-review.md](graph-neural-networks-progress-2025-2026-review.md) §Gap 5
- *Source:* [graph-neural-networks-progress-2025-2026-review-v2.md](graph-neural-networks-progress-2025-2026-review-v2.md) §Gap 5

---

## Key Papers for Deep Dive

| Paper | Why | Priority |
|---|---|---|
| PPGT (arXiv:2504.12588v3) | Mechanistic root cause of GT failures + minimal fixes | **Must read** |
| CKGConv (ICML 2024) | Proves GCN = GT expressiveness; continuous kernel design | **Must read** |
| Tuned GNNs (NeurIPS 2024 + ICML 2025) | Deflates GT hype with rigorous baselines | **Must read** |
| MACE-Osaka24 (arXiv:2412.13088) | Working graph foundation model + TEA | **Must read** |
| GNN-as-SSM bridge (arXiv:2502.10818, NeurIPS 2025) | Unifies oversmoothing/over-squashing/vanishing gradients | High |
| MoSE (ICLR 2025) | Homomorphism-count PE — new PE paradigm | High |
| Graph SSM survey (arXiv:2412.18322) | Fourth architecture paradigm | Medium |
| Edge Transformer (arXiv:2401.10119) | Pair-level tokenization bypasses PE entirely | Medium |
| DYNAMO-GAT (ICLR 2025) | Best oversmoothing fix (if the problem matters) | Medium |
| GrokFormer (ICLR 2025) | KAN + Fourier spectral filters | Medium |

---

## Source Notes

This synthesis draws from 7 research notes in `personal_notes/research/`:

1. `graph-neural-networks-progress-2025-2026.md` — Base survey of GAT/GT/GCN landscape
2. `graph-neural-networks-progress-2025-2026-review.md` — Gap analysis identifying 7 omissions
3. `graph-neural-networks-progress-2025-2026-review-v2.md` — Meta-review verifying gaps against primary sources
4. `graph-transformers-pe-bottleneck-simplicity.md` — Deep dive on PPGT and the PE bottleneck thesis
5. `nodepfn-review.md` — Critical code review of NodePFN (ICLR 2026)
6. `nodepfn-review-supplement.md` — Additional bugs and issues found in deep audit
7. `nodepfn-review-gaps.md` — Gap analysis of the NodePFN review itself
8. `mace-osaka24-explainer.md` — Equivariant GNNs and the MACE foundation model story
