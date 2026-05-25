# Gap Analysis: Graph Learning Paradigm Critique

Source: Critical review of graph-learning-paradigm-critique.md, March 2026

---

## Context

This is a gap analysis of `graph-learning-paradigm-critique.md` — identifying structural omissions that would change conclusions if addressed. Not incremental additions but paradigm-level gaps in a paradigm-level note.

---

## Gap 1: Question -2 Is Missing — "Can You Trust the Reported Numbers?"

The note uses reported benchmark numbers as evidence throughout (PPGT's 17.5pp on BREC, RelGT's +18% on RelBench, feature propagation matching GNNs). It correctly cites "Where Did the Gap Go?" (arXiv:2309.00367) showing that hyperparameter tuning collapses most reported gaps. But it draws this as a conclusion about *deployment* rather than recognizing it as an **epistemological prior** that undermines the note's own evidence base.

If uncontrolled hyperparameter tuning budgets confound all historical architecture comparisons, then the note's central synthesis — "structural information injection > architecture" — is itself built on potentially confounded evidence. The papers establishing that PE matters more than backbone *also* didn't control for equal tuning budgets across all four structural injection strategies.

The evaluation methodology crisis is broader:

> *"Several Graph Neural Network models have been developed to effectively tackle graph classification. However, experimental procedures often lack rigorousness and are hardly reproducible."*
> — A Fair Comparison of Graph Neural Networks for Graph Classification (arXiv:1912.09893, updated Feb 2022)

> *"The current graph neural network (GNN) systems have established a clear trend of not showing training accuracy results, and directly or indirectly relying on smaller datasets for evaluations majorly."*
> — Single-GPU GNN Systems (arXiv:2402.03548, 2024)

And even expressivity metrics are unstable — a March 2026 paper proposes a new evaluation framework revealing that global pooling choice changes expressivity rankings:

> *"Building on these datasets, we propose a general evaluation framework that assesses three key aspects (generalizability, sensitivity, and robustness) and introduces two new quantitative metrics."*
> — Property-Driven Evaluation of GNN Expressiveness at Scale (arXiv:2603.00044, Mar 2026)

**Implication.** This should be Question -2. Almost all architecture comparisons in graph ML — including the ones the critique cites favorably — are provisional.

---

## Gap 2: Heterophily Is Conflated with Heterogeneity

The decision tree asks "Is your graph heterogeneous (multiple node/edge types)?" but never asks **"Is your graph heterophilic?"** These are orthogonal properties:

- **Heterogeneous** = multiple node/edge types (structural multiplicity)
- **Heterophilic** = connected nodes tend to have different labels (semantic dissimilarity)

A homogeneous graph with a single node type can be strongly heterophilic (dating networks, predator-prey ecosystems, adversarial transactions in fraud). The note's Question -1 evidence — that GNNs are often unnecessary — is almost entirely derived from **homophilic** benchmarks (Cora, CiteSeer, PubMed, OGB).

Classic message-passing GNNs implement **neighborhood averaging** — a smoothing operation. On homophilic graphs, smoothing is the right inductive bias. On heterophilic graphs, smoothing is *actively harmful* — it averages away the discriminative signal. This makes "do you need a GNN at all?" contingent on a property of the graph (homophily ratio) that the note never surfaces.

And the heterophily research program itself is on shaky ground:

> *"Are Heterophilic GNNs and Homophily Metrics Really Effective? Evaluation Pitfalls and New Benchmarks"*
> — arXiv:2409.05755, Sep 2024

Standard homophily metrics fail to capture actual difficulty — some heterophilic graphs are trivially easy for vanilla GCN, while some supposedly homophilic graphs are hard. The entire dichotomy may be a false binary.

**Implication.** Add a branch in the decision tree between "Does a non-GNN baseline saturate?" and the data-type questions: "Is your graph's label function aligned with neighborhood smoothing?" The "GNNs often unnecessary" finding may not hold on heterophilic data.

---

## Gap 3: Equivariance Is Treated as Binary ("Non-Negotiable") When It's a Spectrum

The decision tree states: "3D molecular geometry → Equivariant GNN (MACE, NequIP). Non-negotiable." This is the 2023 consensus. By 2025–2026, three independent lines of evidence complicate it.

**Strict equivariance limits expressivity:**

> *"The common intuition is that symmetry in the data distribution should naturally lead to equivariance constraints on learned functions. However, even in symmetric domains, it appears that equivariant functions have an important limitation: the inability to break symmetry at the level of data samples."*
> — Symmetry Breaking and Equivariant Neural Networks (arXiv:2312.09016v2)

> *"By examining the boundary hyperplanes and the channel vectors of ReLU networks, we construct an example showing that equivariance constraints could strictly limit expressive power."*
> — Drawback of Enforcing Equivariance and its Compensation via the Lens of Expressive Power (arXiv:2512.09673, Dec 2025)

**Scaling can compensate for missing equivariance:**

> *"A growing line of work argues that strict equivariance may over-constrain a model and limit its scalability, and that increasing model capacity and training data can compensate for the lack of built-in symmetry."*
> — Probing Equivariance and Symmetry Breaking in Convolutional Networks (arXiv:2501.01999v3, Jan 2025)

**Approximate equivariance can be learned:**

> *"Building on the existing e3nn framework, we propose the use of relaxed weights to allow for controlled symmetry breaking. We show empirically that these relaxed weights learn the correct amount of symmetry breaking."*
> — Relaxed Equivariant Graph Neural Networks (arXiv:2407.20471, Jul 2024)

**Implication.** Real molecular systems have approximate symmetries (crystal defects, solvent effects, protein flexibility). The right question isn't "is your data geometric?" but "how exact are your symmetries, and is the data efficiency gain from strict equivariance worth the expressivity cost?"

---

## Gap 4: Learned Physical Simulation Is a Missing Paradigm

The note identifies two paradigms: **discriminative** and **generative**. But **autoregressive simulation** — rolling out physics forward in time on mesh/particle representations — is a third, with constraints that fit neither framework:

**Error accumulation** over thousands of timesteps (not an issue in single-step prediction):

> *"While Graph Neural Networks (GNNs) have emerged as powerful surrogate models for mesh-based data, their standard autoregressive application for long-term prediction is often plagued by error accumulation and instability."*
> — Graph-Informed Neural ODE for Mesh-Based Physical Systems (arXiv:2509.18445, Sep 2025)

**Over-squashing is MORE severe** in simulation — physics requires long-range force propagation:

> *"Unlike the fields of Natural Language Processing (NLP) and Computer Vision (CV), physical systems are more complex and unstable, where every piece of information is crucial. This implies that issues like over-smoothing and over-squashing might be more pertinent in physical simulations."*
> — Learning Physical Simulation with Message Passing Transformer (arXiv:2406.06060, Jun 2024)

**Scalability to large meshes** requires distinct techniques:

> *"However, these models face several limitations, including scalability issues, requirement for meshing at inference, and challenges in handling long-range interactions."*
> — Scalable Multi-Scale Graph Neural Networks for Physics Simulation (arXiv:2411.17164, Nov 2024)

**Implication.** The decision tree should have a branch for "are you simulating dynamics?" routing to multi-scale graph construction, rollout stability, and temporal integration — rather than collapsing all scientific uses into "equivariant GNN."

---

## Gap 5: Generalization Theory Is Cited but Not Interrogated

The note cites "More Expressivity, but at What Cost?" (arXiv:2510.10101) for the expressivity-generalization tradeoff. But the deeper theoretical landscape is in worse shape than presented.

The most striking result:

> *"This paper focuses on the generalization of GNNs by investigating their Vapnik–Chervonenkis (VC) dimension. We extend previous results to demonstrate that 1-dimensional GNNs with a single parameter have an infinite VC dimension for unbounded graphs."*
> — A note on the VC dimension of 1-dimensional GNNs (arXiv:2410.07829, Oct 2024, updated Jun 2025)

A **single-parameter, 1-dimensional GNN has infinite VC dimension** on unbounded graphs. Standard generalization theory gives vacuous bounds. The expressivity-generalization tradeoff the note discusses is real empirically but lacks adequate theoretical explanation.

The best available bounds scale with structural properties:

> *"Prior works have developed generalization bounds for graph neural networks, which scale with graph structures in terms of the maximum degree."*
> — Generalization in Graph Neural Networks (arXiv:2302.04451, Feb 2023)

**Implication.** Generalization on dense or power-law graphs (most social and biological networks) is theoretically harder — a **structural** property, not an **architecture** property. The note's "practical test" (check if 1-WL saturates your task) is right, but should acknowledge it's operational *because the theory gives no guidance*.

---

## Gap 6: Graphs as Reasoning Scaffolds for LLMs (The Reverse Direction)

The note's Question 3 treats the LLM-graph relationship as LLMs replacing GNNs. The reverse is at least as significant: **graphs are emerging as computational scaffolds for LLM reasoning**.

> *"We introduce the Diagram of Thought (DoT), a framework wherein a single auto-regressive LLM internally constructs and navigates a Directed Acyclic Graph (DAG)."*
> — On the Diagram of Thought (arXiv:2409.10038v3)

> *"Rather than relying on fixed-step methods like Chain of Thought (CoT) or Tree of Thoughts (ToT), AGoT recursively decomposes complex queries into structured subproblems, forming a dynamic directed acyclic graph (DAG) of interdependent reasoning steps."*
> — Test-Time Adaptive Reasoning Unifying Chain, Tree, and Graph Structures (arXiv:2502.05078, Feb 2025)

> *"We present an agentic, autonomous graph expansion framework that iteratively structures and refines knowledge in situ."*
> — Agentic Deep Graph Reasoning Yields Self-Organizing Knowledge Networks (arXiv:2502.13025, Feb 2025)

And connecting to higher-order structures:

> *"This work establishes a 'teacherless' agentic reasoning system where hypergraph topology acts as a verifiable guardrail, accelerating scientific discovery by uncovering relationships obscured by traditional graph methods."*
> — Higher-Order Knowledge Representations for Agentic Scientific Reasoning (arXiv:2601.04878, Jan 2026)

**Implication.** Even if LLMs replace GNNs for learning from graph-structured data, the demand for graph representations may *increase* because LLMs need them for structured reasoning. Graph learning may shift from "predict node labels" to "construct, navigate, and refine graph-structured knowledge." Question 3 should flag this counter-trend.

---

## Gap 7: The Note's Scope Claim Doesn't Match Its Evidence Base

The note claims Level 3 insights represent "what the evidence supports when you question every assumption." But the evidence base is almost entirely from **node classification and graph classification** on small, static, homophilic, homogeneous, feature-light graphs:

- Feature propagation + MLP: node classification benchmarks
- TabGraphs: node classification with tabular features
- 1-WL sufficiency: graph classification (TUDatasets)
- "Where Did the Gap Go?": graph-level OGB benchmarks
- BREC: synthetic expressivity test

The note correctly branches away from these conclusions for most real-world settings (temporal, heterogeneous, generative, text-attributed). But the framing presents the narrow claims as the headline finding.

**This is the note's version of the same benchmarking trap it critiques.** "GNNs are often unnecessary" is supported on Cora/CiteSeer/PubMed. Whether it's true on a billion-node production fraud graph with weak features and strong structural signal is an open question.

---

## Summary Table

| Gap | Current claim | Corrected claim |
|---|---|---|
| **Evaluation crisis** | Benchmarks don't predict deployment | ...AND most reported results (including this note's sources) are confounded by evaluation methodology |
| **Heterophily** | Check if graph is heterogeneous | ...AND whether the smoothing bias helps or hurts (homophily ratio) |
| **Equivariance** | Non-negotiable for 3D geometry | Strict equivariance is a tradeoff — approximate equivariance and scale can compensate |
| **Physical simulation** | Binary: discriminative vs. generative | Ternary: discriminative vs. generative vs. autoregressive simulation |
| **Generalization theory** | More expressivity = harder to generalize | We lack a predictive generalization theory for GNNs; the tradeoff is empirical |
| **Graphs for LLM reasoning** | LLMs threaten GNNs | LLMs also create new demand for graph representations as reasoning scaffolds |
| **Evidence scope** | Level 3 insights are universal | Level 3 insights hold on small/homophilic/homogeneous benchmarks; generalization is uncertain |

## The Meta-Gap

The note's greatest strength — asking assumptions before architecture — should be applied reflexively to its own evidence base. The honest answer: **we don't yet know whether the "simple models suffice" story generalizes beyond the settings where it's been tested, and the evaluation methodology doesn't give us reliable tools to find out.**
