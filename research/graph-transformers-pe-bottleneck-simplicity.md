# Graph Transformers: The PE Bottleneck and the Simplicity Thesis

Source: Critical review of Ma et al., "Plain Transformers Can be Powerful Graph Learners" (arXiv:2504.12588v3, 2025–2026). Reviewed 2026-03-27.

---

## Two Bottlenecks, One Backbone

Standard Transformers fail on graphs for two independent reasons. The paper identifies both, fixes each with a minimal intervention, and shows the combined result matches or beats far more complex alternatives. The two bottlenecks are: (A) the backbone *destroys* structural signal that PE already provides, and (B) the PE extraction pipeline *fails to resolve* the signal's full frequency content.

### Bottleneck A: The Backbone Destroys Magnitude

Four-link causal chain:

1. **Graph learning = multiset encoding.** The WL hierarchy distinguishes graphs by iteratively hashing node neighborhoods as multisets. {{a,b}} ≠ {{a,a,b,b}} — cardinality matters.

2. **Cardinality is encoded as magnitude.** When you sum repeated elements, count becomes norm: {{a,b}} → x, {{a,a,b,b}} → 2x. The L₂ magnitude of a token vector carries structural information.

3. **Normalization destroys magnitude.** Both LayerNorm and RMSNorm project tokens onto a hypersphere: RMSN(x) = RMSN(cx) for any c > 0, since RMS(cx) = c·RMS(x) and the scalar cancels. Every Transformer layer with LN/RMSN erases the signal that encodes multiset cardinality.

4. **SDP attention is blind to magnitude closeness.** Dot-product attention decomposes as cos(q,k)·‖q‖·‖k‖/√D. Two distinct failure modes: (a) ‖q‖ acts as a per-query temperature controlling softmax sharpness — it never measures *closeness* between ‖q‖ and ‖k‖; (b) since cos(q,k) ∈ [−1,1] while ‖k‖ ∈ [0,+∞), large-magnitude keys dominate attention scores regardless of angular relevance (Section 2.2, drawbacks 2 and 3).

**Fix A:** Two minimal modifications. (i) **AdaRMSN** — input-dependent re-scaling after normalization (learnable α, β) — preserves magnitude when the task needs it. (ii) **sL₂ attention** — SDP + bias term −k^Tk/(2√D) — gives attention logit proportional to −‖q−k‖²/(2√D) (up to a query-constant that vanishes under softmax), making it a Euclidean closeness measure over both direction and magnitude. Both are implementable via existing SDP kernels.

### Bottleneck B: The PE Stem Loses High-Frequency Detail

Independent from Bottleneck A:

5. **MLPs lose high-frequency PE features.** Due to the spectral bias of neural networks — "deep ReLU networks are biased towards low frequency functions … which manifests itself as a frequency-dependent learning speed" (Rahaman et al., ICML 2019) — the MLP-based PE stem prioritizes low-frequency modes and loses fine-grained structural information stored in RRWP.

**Fix B:** **SPE** — a sinusoidal pre-encoding on top of RRWP before the MLP stem, inspired by NeRF (Mildenhall et al., 2020). It amplifies signal differences between similar PE vectors, making high-frequency structure learnable. Impact on BREC: without SPE = 54.5% (218/400); with SPE = 58.5% (234/400). The entire 4pp gain comes from the hardest category (CFI: 8→24 pairs), where fine structural distinctions demand high-frequency PE features.

### The Combined Picture

All three fixes are needed: without SPE, PPGT merely matches GRIT at 54.5% on BREC. But the decisive experiment is a PE swap: same PPGT architecture with I²GNN-derived PE reaches **76%** — a 17.5pp jump from changing only the PE. The paper is explicit: *"The expressivity bottleneck of our PPGT model does not stem from its architecture, but rather from the design of positional encodings (PE)."*

The architecture wasn't the bottleneck — it was (A) *breaking* the information the PE already provided and (B) *failing to extract* its full resolution. Once you stop breaking and start extracting, a minimally modified Transformer matches or beats far more complex alternatives.

**Three-layer story for the field:** (1) don't destroy PE signal in the backbone (AdaRMSN + sL₂), (2) extract PE signal at full resolution (SPE), (3) design richer PEs (open problem — see §PE Design Frontier below).

---

## Scope and Limits of the PE-Bottleneck Thesis

The PE-bottleneck thesis — that architecture design has diminishing returns and PE design has a higher ceiling — is well-supported **within node-level Transformers**. But it has a sharp boundary condition.

### The Edge Transformer Counterexample

Müller et al., "Towards Principled Graph Transformers" (NeurIPS 2024, arXiv:2401.10119): *"We show that the recently proposed Edge Transformer, a global attention model operating on node pairs instead of nodes, has at least 3-WL expressive power when provided with the right tokenization."* And: *"Empirically, we demonstrate that the Edge Transformer surpasses other theoretically aligned architectures regarding predictive performance while not relying on positional or structural encodings."*

The Edge Transformer gets ≥3-WL expressivity **with zero PE** by changing the unit of tokenization from nodes to node pairs. Operating on N² pair-tokens, graph structure is implicit in which pairs exist — no PE needed.

This means the bottleneck isn't PE per se — it's the **level of abstraction at which tokens are defined**. PE is a workaround for node-level tokenization's inability to natively encode pairwise structure. The Edge Transformer sidesteps the entire problem.

### The Correct Scope

| Domain | PE-bottleneck holds? | Why |
|---|---|---|
| Node-level Transformers (PPGT, GRIT, Graphormer) | **Yes** | Tokens are nodes; structure must be injected via PE |
| Pair-level Transformers (Edge Transformer) | **No** | Structure is implicit in tokenization; PE ≈ free |
| Message-passing GNNs | Partially | Topology is hardwired into aggregation; PE augments |

The PPGT thesis is correct but must be scoped: within node-level Transformers, PE design dominates architecture design. Across the broader design space, **tokenization strategy** is the higher-order choice.

### The Pseudo-Coordinate Unification

This scope condition connects to a deeper pattern across Ma et al.'s research arc:
- **CKGConv** (Ma et al., ICML 2024): continuous kernels on pseudo-coordinates, proving GCN can match GT expressiveness.
- **PPGT** (Ma et al., 2025–2026): showing minimally modified Transformers match complex GTs.
- **Edge Transformer** (Müller et al., 2024): achieving expressivity through tokenization, bypassing PE.

The unifying concept: **pseudo-coordinates — whether encoded as PE, learned as attention bias, or made implicit through tokenization — are the fundamental abstraction for graph learning.** Whether you use convolution, node-level attention, or pair-level attention over them is secondary. The PE-bottleneck thesis is a special case of this broader principle.

---

## Expressivity ≠ Generalization

### The BREC Caveat

BREC is a test suite of 400 curated non-isomorphic graph pairs chosen to be hard for specific WL classes. A model scoring 58.5% distinguishes 234/400 hard pairs — it does not have "58.5% expressivity" in any absolute sense. The numbers only have meaning relative to other models on the same suite.

More importantly, **BREC performance does not predict real-world task performance**. The theory–practice relationship is non-monotonic even within BREC:

| Model | Theoretical class | BREC |
|---|---|---|
| EPNN | GD-WL ⊒ EPWL ⊐ 3-WL | 53.8% |
| PPGN | 3-WL equivalent | 58.2% |
| PPGT | GD-WL ⊐ 3-WL (weaker than EPNN) | 58.5% |
| I²GNN | Incomparable to 3-WL | 70.2% |
| N²GNN | 2-FWL (genuinely stronger) | 71.8% |

The paper: *"EPNN and PPGN, despite having stronger theoretical expressivity, achieve worse empirical expressivity compared to PPGT. This indicates that besides theoretical expressivity, whether GNNs can effectively learn to fulfill their theoretical expressivity also matters."*

Theory doesn't reliably predict practice *among methods with similar bounds*, but methods with substantially stronger theoretical capacity (subgraph/higher-order GNNs) do tend to outperform on BREC. Theory sets a ceiling; architecture + optimization determine how much of that ceiling is reached.

### Classic GNNs as the Inconvenient Baseline

"Can Classic GNNs Be Strong Baselines for Graph-level Tasks?" (arXiv:2502.09263, Feb 2025): *"Contrary to prevailing beliefs, these classic GNNs consistently match or surpass the performance of GTs, securing top-three rankings across all datasets and achieving first place in eight. Furthermore, they demonstrate greater efficiency, running several times faster than GTs on many datasets."*

Classic GNNs that would score terribly on BREC outperform Graph Transformers on practical benchmarks. The expressivity measured by BREC is necessary for *some* tasks (e.g., distinguishing similar molecular structures) but irrelevant for *many* tasks where simple message-passing suffices. The PE-bottleneck thesis applies to the expressivity frontier, not necessarily to practical performance frontiers.

---

## On "Plainness" as a Rhetorical Device

PPGT claims to be a "plain Transformer." It uses:
- A non-standard attention mechanism (sL₂ ≠ SDP)
- A non-standard normalization layer (AdaRMSN ≠ RMSN)
- A URPE multiplicative term requiring custom attention code
- N² pairwise PE preprocessing through multiple FFN layers

This is simpler than GRIT (same first author's prior work), but it is not "plain" the way ViT or GPT is plain. TokenGT (Kim et al., NeurIPS 2022) used a genuinely unmodified Transformer and performed worse — which actually shows the modifications matter.

Better framing: **"Minimally modified Transformers can be powerful graph learners."** The contribution is identifying the *minimal* modifications, not eliminating them.

The paper makes the CKGConv connection explicit: *"PPGT with URPE enhancement can also be interpreted as a generalization of CKGConv … the φ(p_ij) term serves as the convolution kernel, analogous to that in CKGConv, while the Softmax(…) component can be regarded as a dynamic density function."* Ma's research program reveals that graph convolution and graph attention are two implementations of the same underlying operation on pseudo-coordinates. Demonstrating your own prior work was more complex than necessary — GRIT (complex, SOTA) then PPGT (simpler, also SOTA) — is rare and credible. Incentives in ML research favor ever-more-complex architectures; this paper pushes against that.

---

## The Pairwise PE Scaling Problem

Current Graph Transformers (PPGT, GRIT, Graphormer-GD) store dense pairwise PE: N² × D_pe floats. This creates apparent tension between expressivity, graph size, and memory.

**This is NOT fundamental.** It's an artifact of dense storage.

### Why RRWP Can Be Factored

RRWP: p_ij = [I, W, W², ..., W^{K-1}]_{i,j}, where W = D⁻¹A.

Via spectral decomposition: W^k_{ij} = Σ_l λ_l^k · u_l(i) · v_l(j). Every entry is an inner product of per-node spectral features. Store top-m eigenvectors per node — O(N×m) — and compute any p_ij on-the-fly.

**Caveat — diagonalizability:** For undirected graphs, W = D⁻¹A is similar to the symmetric matrix D⁻¹/²AD⁻¹/² (via D¹/²WD⁻¹/²), so it has real eigenvalues and is always diagonalizable (though left and right eigenvectors differ: u_l ≠ v_l). For directed graphs, W may have complex eigenvalues or may not be diagonalizable, limiting this approach.

**Caveat — practical costs:** (i) Computing top-m eigenvectors costs O(N·m²) via Lanczos — which for large graphs can itself be the bottleneck. (ii) Truncation error: when the spectral gap is small (expander-like graphs, social networks with high conductance), truncating to top-m eigenvectors introduces significant approximation error. The claim that "real-world graphs have low effective spectral dimension" holds for molecular graphs but not necessarily for social networks, citation networks, or power-law graphs where the spectrum decays slowly.

**Caveat — the RoPE/ALiBi analogy is suggestive, not direct.** Language models compute pairwise PE on-the-fly from per-token position indices because position is 1D and monotonic — trivially factorable. Graph "position" is multi-dimensional and irregular. The analogy points to an engineering pattern, not a ready-made solution.

### What IS Fundamental

| Constraint | Type | Fundamental? | Why |
|---|---|---|---|
| O(N²) compute for full pairwise attention | Computational | Yes | Must examine all pairs for global receptive field |
| O(N²) memory for pairwise PE | Engineering | **No** | Factorable via spectral decomposition |
| O(N^k) for k-WL expressivity | Information-theoretic | Yes | Must process k-tuples |
| PE quality caps expressivity | Information-theoretic | Yes | Model can only use what PE provides |
| PE rank bottleneck (m dims per node) | Empirical | Depends on graph family | Molecular: low rank suffices; social: may not |

### The Real Tradeoff

Not a triangle but a two-axis tradeoff:
- **Compute**: O(N²×D) for full attention, reducible only by approximation
- **PE rank**: how many spectral dimensions per node encode structure

With factored PE + FlashAttention-style tiling, memory becomes O(N×m) — linear. The binding constraint shifts from memory to compute.

**Engineering frontier:** No fused FlashAttention kernel yet computes p_ij = f(φ_i, φ_j) inside attention tiles. But the engineering pattern exists: PaTH (arXiv:2505.16381, 2025) implements *"a FlashAttention-style blockwise algorithm that minimizes I/O cost"* for Householder-based PE in sequences. FlashAttention-3 (2024) on Hopper GPUs with asynchronous execution and warp specialization lowers the kernel programming barrier. The graph analogue is nontrivial but not far off.

---

## FlashAttention: What It Actually Does

Common misconception: FlashAttention reduces memory from O(N²) to O(N log N).

**Correct:** O(N²) → O(N). No log factor. Source: Dao et al. (NeurIPS 2022): *"Memory Efficient: standard attention memory usage is quadratic with sequence length (i.e. O(N²)). FlashAttention is sub-quadratic at O(N)."*

| | Naïve Attention | FlashAttention |
|---|---|---|
| FLOPs | O(N²D) | O(N²D) — **unchanged** |
| HBM memory | O(N²) for attention matrix | O(N) — never materializes it |
| Mechanism | Writes full N×N attn matrix to GPU global memory | Tiles computation, keeps intermediates in SRAM, uses online softmax |

FlashAttention computes **exact** attention. Same results, fewer memory round-trips. The speedup (2–4×) comes from IO-awareness — reducing slow HBM reads/writes — not from fewer operations.

Categorically different from approximate methods (Performer O(N), Reformer O(N log N), Linformer O(N)) which change what is computed.

---

## The PE Design Frontier

The paper's own PE-swap experiment (RRWP→I²GNN-derived PE: 58.5%→76%) shows the PE ceiling is far from reached. What does the frontier look like?

### Beyond Random Walks: Homomorphism Counts

MoSE (ICLR 2025): *"Empirically, we observe that MoSE outperforms other well-known positional and structural encodings across a range of architectures, and it achieves state-of-the-art performance on a widely studied molecular property prediction dataset."* Homomorphism counts to small pattern graphs (triangles, cycles, paths) provide a fundamentally different PE paradigm from random walks — grounded in Lovász's theory rather than diffusion. They count substructures rather than measuring diffusion distances, and they scale differently: O(N · |pattern|^treewidth) per pattern, pre-computable.

### The PE × Architecture Interaction

"Benchmarking Positional Encodings for GNNs and Graph Transformers" (arXiv:2411.12732, Nov 2024): *"Our findings demonstrate that previously untested combinations of GNN architectures and PEs can outperform existing methods."* The PE-bottleneck thesis implies PE quality is architecture-independent; this finding shows the interaction is non-trivial. Optimal PE depends on the backbone — the design space is combinatorial.

### Topological PE

"Positional Encoding meets Persistent Homology on Graphs" (arXiv:2506.05814): PE from persistent homology captures multi-resolution topological features (connected components, loops, voids) that neither random walks nor homomorphism counts encode. "Facilitating Graph Neural Networks with Random Walk on Simplicial Complexes" (NeurIPS 2023) extends random walks to higher-order simplices via Hodge Laplacians.

### The Open Problem

The PE design space has at least four axes — all currently explored independently:
1. **Diffusion-based**: RRWP, Laplacian eigenvectors (spectral)
2. **Combinatorial**: homomorphism counts, subgraph counts
3. **Topological**: persistent homology, simplicial random walks
4. **Learned**: end-to-end differentiable PE (risk: training instability)

No existing PE combines all four. The I²GNN PE that pushed PPGT to 76% on BREC uses subgraph-derived information — suggesting the combinatorial axis has the most immediate headroom for node-level Transformers.

---

## The Unified Backbone Question

The paper claims PPGT enables cross-modality unification (language + vision + graphs on one architecture). No experiment tests AdaRMSN or sL₂ attention on non-graph tasks, so this is aspiration, not evidence.

However, the concern that the modifications may *hurt* non-graph performance deserves nuance. Recent work on multimodal LLMs (arXiv:2512.08374, Dec 2025) finds that standard pre-norm architectures cause *"an 'asymmetric update dynamic,' where high-norm visual tokens exhibit a 'representational inertia,' causing them to transform semantically much slower than their textual counterparts. This fundamentally impairs effective cross-modal feature fusion."* This is precisely the magnitude-erasure problem that AdaRMSN addresses, manifesting in a non-graph domain.

The pattern: whenever multiple signal types with different norm distributions interact within one backbone — graph structure + node features, visual tokens + text tokens — standard normalization's scale-invariance becomes a liability. AdaRMSN's input-dependent re-scaling may be more broadly useful than initially apparent, at least in multimodal settings. A truly unified backbone would need to show AdaRMSN is at worst neutral on single-modality tasks and beneficial on cross-modal ones.

The follow-up "Plain Transformers are Surprisingly Powerful Link Predictors" (arXiv:2602.01553, Feb 2026) extends the simplification thesis to link prediction, finding that complex structural encodings in GTs *"incur significant overhead"* with limited benefit. The thesis has legs beyond graph classification, though it remains within the graph domain.

---

## Meta-Observations

**On self-correction in research.** Ma, Coates et al. published GRIT (complex, SOTA) then PPGT (simpler, also SOTA). Demonstrating your own prior work was more complex than necessary is rare and credible. The research arc — CKGConv (ICML 2024) → PPGT (2025–2026) — reveals a coherent simplification program, not a one-off result.

**On the expressivity–generalization gap.** The note's central tension: BREC says expressivity matters; "Can Classic GNNs Be Strong Baselines?" (arXiv:2502.09263) says classic GNNs win on real tasks. These are not contradictory. Expressivity is necessary for tasks that *require* distinguishing structurally similar graphs (molecular property prediction, combinatorial optimization). For tasks where coarse structure suffices (node classification on social networks, many graph-level labels), simpler models with lower expressivity but better inductive bias and efficiency win. The PE-bottleneck thesis applies at the expressivity frontier — and that frontier only matters for the subset of tasks that need it.

**On what "minimal" really means.** The contribution is not that the modifications are small in code — sL₂ attention requires a custom kernel, AdaRMSN adds parameters, SPE adds preprocessing. The contribution is that they are *conceptually minimal*: each targets one specific information-theoretic failure mode (magnitude erasure, angular-only attention, spectral bias) with a single-purpose fix. No component does double duty; no component is there "just in case." This is engineering in the best sense: diagnosis first, minimal intervention second.
