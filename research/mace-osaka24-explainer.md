# MACE-Osaka24: Why It Matters — A Step-by-Step Explanation

Source: Deep research, March 2026

---

## Step 1: The Problem — Simulating Atoms Is Impossibly Expensive

Everything in chemistry and materials science reduces to one question: *given a collection of atoms, what is the energy of the system, and what forces act on each atom?*

If you know the energy and forces, you can simulate how atoms move (molecular dynamics), predict which crystal structures are stable, design drugs that bind to proteins, discover new battery materials — essentially all of computational chemistry.

The "correct" way to compute this is quantum mechanics — solving the Schrödinger equation. In practice, we use **Density Functional Theory (DFT)**, an approximation that's accurate enough for most purposes. But DFT is brutally expensive:

> *"Machine learning interatomic potentials (MLIPs) are a new paradigm in computational materials science due to their reduced cost compared to density functional theory (DFT) calculations."*
— [arXiv:2602.02228](https://arxiv.org/html/2602.02228v1)

> *"Machine-learned interatomic potentials (MLIPs) enable large-scale atomistic simulations at moderate computational cost while retaining ab initio accuracy."*
— [arXiv:2508.14306](https://arxiv.org/html/2508.14306v1)

DFT scales as roughly O(N³) with the number of electrons. A single energy evaluation for a modest protein fragment (~1000 atoms) takes hours on a supercomputer. Running molecular dynamics for a nanosecond (millions of timesteps) is often infeasible. This is the bottleneck holding back drug discovery, materials design, and catalysis research.

**The dream:** Train a neural network on DFT data, then use the network (which runs in milliseconds) as a surrogate. This is a **Machine Learning Interatomic Potential (MLIP).**

---

## Step 2: The Challenge — Why Molecules Are Not Ordinary Graphs

The GNN research note treats molecules as graphs: atoms = nodes, bonds = edges. That works for predicting simple molecular properties (toxicity, solubility) from **2D molecular graphs** (the "structural formula" you drew in chemistry class).

But real atomistic simulation operates in **3D**. The energy depends on:
- **Exact 3D coordinates** of every atom (not just connectivity)
- **Bond angles** (the angle between three atoms)
- **Dihedral angles** (the twist around a bond between four atoms)
- **Many-body interactions** (how groups of 3, 4, 5+ atoms collectively influence each other)

A standard GNN (GCN, GAT, Graph Transformer) processes a graph as an abstract combinatorial object. It doesn't "know" about 3D geometry. If you rotate a molecule in space, a standard GNN might give a different answer — which is physically nonsensical, because energy doesn't change when you rotate a molecule.

This is where **equivariance** enters.

---

## Step 3: Equivariance — Baking Physics into the Architecture

The key physics constraint: the laws of nature don't change if you translate, rotate, or reflect your coordinate system. Mathematically, this is the **E(3) symmetry group** (Euclidean group in 3D: translations + rotations + reflections).

> *"By encoding these symmetry constraints at every layer, E(3)-equivariant neural networks dramatically improve sample efficiency, generalization, and physical fidelity relative to conventional and invariant architectures."*
— [EmergentMind, E(3)-Equivariant Neural Networks](https://api.emergentmind.com/topics/e-3-equivariant-neural-networks)

> *"Steerable graph neural networks (GNNs) encoding geometric information with spherical harmonics respect the fundamental symmetries of atomic systems—permutation, rotation, and translation—for more physically realistic predictions."*
— [arXiv:2509.08418](https://arxiv.org/html/2509.08418v1)

What does equivariance mean in practice?

- **Energy** (a scalar) must be **invariant**: same value regardless of rotation. E → E.
- **Forces** (vectors) must be **equivariant**: if you rotate the molecule, the forces rotate the same way. If F points "up" before rotation, it should point in the correspondingly rotated direction after.
- **Stress tensors** (rank-2 tensors) must also transform correctly.

An equivariant GNN guarantees these constraints **by construction** — it's architecturally impossible for it to give a wrong-symmetry answer. This is enormously more data-efficient than trying to learn symmetry from data augmentation (rotating training examples randomly).

**Think of it like this:** A standard GNN is like trying to learn arithmetic without knowing that a + b = b + a. An equivariant GNN has commutativity built into its wiring. It never needs to learn it, so it can spend all its capacity on the hard parts.

---

## Step 4: The MACE Architecture — How It Works

MACE = **M**essage Passing **A**tomic **C**luster **E**xpansion. Created by Ilyes Batatia et al. (University of Cambridge).

> *"MACE (Multilayer Atomic Cluster Expansion) neural network potentials are a class of rotation-equivariant, message-passing machine learning interatomic potentials that generalize the atomic cluster expansion (ACE) formalism by embedding it in a deep neural architecture."*
— [EmergentMind, MACE Neural Network Potential](https://api.emergentmind.com/topics/mace-neural-network-potential)

It fuses two ideas:

**Idea A — Message Passing (from GNNs):** Each atom sends messages to its neighbors. After *L* rounds, each atom's representation encodes information from its *L*-hop neighborhood. Standard GNN stuff.

**Idea B — Atomic Cluster Expansion (ACE):** A mathematical framework from the interatomic potentials community. ACE says: the energy contribution of atom *i* can be expanded as a sum over clusters — pairs of atoms (2-body), triples (3-body), quadruples (4-body), etc. Each body order captures progressively more complex interactions. The expansion uses **spherical harmonics** (mathematical functions that naturally encode angular information in 3D) to represent how atoms are arranged around a central atom.

**MACE's insight:** Combine these. Each message-passing layer constructs **higher-order equivariant messages** using tensor products of spherical harmonic features. After just 2 message-passing layers, MACE effectively captures up to ~4-body or 5-body interactions, because the tensor products compound body order multiplicatively with depth.

> *"Message Passing Atomic Cluster Expansion (MACE) is a framework that combines symmetry-adapted atomic cluster expansion with message passing to accurately represent complex many-body interactions in atomic systems."*
— [EmergentMind, Message Passing ACE](https://emergentmind.com/topics/message-passing-atomic-cluster-expansion-mace)

**Crucial property:** Because MACE uses spherical harmonics and Clebsch-Gordan coefficients (tools from representation theory) for its tensor products, **equivariance is guaranteed at every layer.** The output energy is exactly invariant; the output forces are exactly equivariant. No data augmentation needed. No symmetry-breaking artifacts.

> *"E(3)-Equivariant Convolutions are neural operators that guarantee invariance under translations, rotations, and reflections in 3D space. They use group-theoretic tools like spherical harmonics, Clebsch–Gordan coefficients, and radial functions to enforce symmetry."*
— [EmergentMind, E(3)-Equivariant Convolutions](https://www.emergentmind.com/topics/e-3-equivariant-convolutions)

**Result:** MACE is remarkably data-efficient:

> *"We show that MACE is very data efficient, and can reproduce experimental molecular vibrational spectra when trained on as few as 50 randomly selected reference configurations."*
— [arXiv:2305.14247v2](https://arxiv.org/html/2305.14247v2)

---

## Step 5: MACE-MP-0 — The First Universal Potential

Once MACE proved to be accurate and efficient, the natural question was: can we train *one* MACE model that works for *any* element in the periodic table?

This is **MACE-MP-0** (Batatia et al., 2024). Trained on the Materials Project dataset (MPTrj — trajectories from DFT relaxations covering most of the periodic table).

> *"Designed as a 'foundation model' for atomistic simulation, MACE-MP-0 leverages symmetry-preserving message-passing neural networks built atop tensor product representations from ACE, yielding a flexible, transferable potential applicable throughout the periodic table and in complex, physically relevant environments."*
— [EmergentMind, MACE-MP-0](https://emergentmind.com/topics/mace-mp-0)

**Why "foundation model" language is apt:**
- Pre-trained on broad data (entire periodic table)
- Transfers to new systems without retraining
- Can be fine-tuned for specific applications with small data

> *"We present an accurate and data-efficient protocol based on fine-tuning of the foundational MACE-MP-0 model and showcase its capabilities on sublimation enthalpies and physical properties of ice polymorphs."*
— [arXiv:2405.20217](https://arxiv.org/html/2405.20217v1)

This was already remarkable. But MACE-MP-0 had a limitation: it was trained only on **inorganic/crystalline materials** from the Materials Project. Molecules (organic chemistry, drug molecules) were a different world — different DFT settings, different datasets, different energy reference conventions.

---

## Step 6: The Dataset Problem — Why You Can't Just Mix Databases

Here's the core data engineering obstacle that MACE-Osaka24 solves. To understand it, you need to know how DFT works:

DFT computes **total energy** of a system. But "total energy" includes the energy of isolated atoms, which depends on arbitrary choices in the calculation setup:
- Which **exchange-correlation functional** (the approximation at the heart of DFT — e.g., PBE, B3LYP, ωB97X)
- Which **basis set** (how you represent electron wavefunctions — e.g., plane waves for crystals, Gaussian orbitals for molecules)
- **Pseudopotential** choices (how you approximate core electrons)

These choices produce **different energy scales.** A carbon atom might have a total energy of -37.8 Hartrees in one DFT setup and -37.3 Hartrees in another. The *relative* energies (energy differences between configurations) are comparable, but the *absolute* energies are not.

This means you **cannot naively combine** datasets computed with different DFT setups. If you trained on both simultaneously, the model would see contradictory labels for similar configurations and produce garbage.

Before MACE-Osaka24, the workaround was brute force: **recompute everything** at a single DFT level. This is enormously expensive (millions of CPU-hours) and creates an **accessibility barrier**:

> *"This difficulty creates an accessibility barrier, allowing only institutions with substantial computational resources — those able to perform costly recalculations to standardize data — to contribute meaningfully to the advancement of universal MLIPs."*
— [arXiv:2412.13088](https://arxiv.org/html/2412.13088v1)

Only mega-labs (Google DeepMind with GNoME, Meta with Open Catalyst) could afford to build universal models.

---

## Step 7: Total Energy Alignment (TEA) — The Key Innovation

TEA is the methodological breakthrough in MACE-Osaka24. The insight is elegant:

The energy offset between datasets is (approximately) a **per-element constant.** If dataset A computes carbon at one reference level and dataset B at another, the difference is roughly a fixed number per carbon atom, regardless of what molecule or crystal the carbon is in.

TEA learns these per-element energy shifts **during training**, treating them as learnable parameters alongside the neural network weights. No expensive recomputation needed.

> *"We present Total Energy Alignment (TEA), which is an approach that enables the seamless integration of heterogeneous quantum chemical datasets without redundant calculations."*
— [arXiv:2412.13088v2](https://arxiv.org/html/2412.13088v2)

> *"Here, we present Total Energy Alignment (TEA), an approach that enables the seamless integration of heterogeneous quantum chemical datasets almost without redundant calculations."*
— [arXiv:2412.13088](https://arxiv.org/abs/2412.13088)

**Why this is profound:** TEA transforms the data problem from "expensive recomputation" to "a few extra learnable parameters." It's analogous to how batch normalization in deep learning lets you combine heterogeneous data by learning per-channel shifts and scales — except here the "channels" are chemical elements and the "shifts" have physical meaning (per-element energy references).

---

## Step 8: MACE-Osaka24 — What It Is

Using TEA to unify previously incompatible datasets, the team trained a single MACE model on both molecular *and* crystalline/materials data:

> *"Using TEA, we trained MACE-Osaka24, the first open-source MLIP model based on a unified dataset covering molecular and crystalline systems."*
— [arXiv:2412.13088v2](https://arxiv.org/html/2412.13088v2)

**"First"** is the key word. Before MACE-Osaka24:
- MACE-MP-0 handled crystals/inorganics
- Separate models (ANI, AIMNet) handled organic molecules
- No single open-source model did both

MACE-Osaka24 crosses this boundary.

**Performance:**

> *"This universal model shows strong performance across diverse chemical systems, exhibiting comparable or improved accuracy in predicting organic reaction barriers compared to specialized models, while effectively maintaining state-of-the-art accuracy for inorganic systems."*
— [arXiv:2412.13088](https://arxiv.org/abs/2412.13088)

Read that carefully: it matches *specialized* models on molecules while *also* being SOTA on inorganics. One model. No task-specific retraining.

---

## Step 9: Why This Is the Actual "Graph Foundation Model" Success Story

Now connect this back to the GNN research landscape. The original research note discusses **Graph Foundation Models (GFMs)** and calls them "aspirational" with "unclear execution":

> *"Graph Foundation Models — attractive idea, unclear execution. Graph data is far more heterogeneous than text/images. Transferability across graph domains (social → molecular → citation) is fundamentally harder."*

But MACE-Osaka24 **already does this** — just not across the domains the note was thinking about. Instead of social → molecular → citation, it transfers across **molecular ↔ crystalline ↔ surface chemistry**:

> *"By fine-tuning on datasets at different levels of electronic structure theory—including inorganic crystals, molecular systems, surface chemistry, and reactive organic chemistry—we demonstrate that a single unified model achieves state-of-the-art performance across several chemical domains."*
— [arXiv:2510.25380 (Cross Learning paper, building on MACE)](https://arxiv.org/html/2510.25380v1)

The analogy to LLMs is precise:

| LLM Foundation Model | MACE Foundation Model |
|---|---|
| Pre-train on broad text corpus | Pre-train on diverse DFT data (TEA-unified) |
| Fine-tune for specific tasks | Fine-tune for specific chemical systems |
| Architecture: Transformer | Architecture: Equivariant message-passing GNN |
| Emergent capabilities across domains | Transferability across chemistry domains |
| Open-source (LLaMA, etc.) | Open-source (MACE-Osaka24, [github.com/ACEsuit/mace](https://github.com/ACEsuit/mace)) |

The note missed that graph foundation models **already exist and work** — just in a domain (atomistic simulation) it didn't consider.

---

## Step 10: The Broader Ecosystem and What's Next

MACE-Osaka24 isn't isolated. It catalyzed a competitive ecosystem:

**GRACE** (Graph Atomic Cluster Expansion, Aug 2025):
> *"Foundational machine learning interatomic potentials that can accurately and efficiently model a vast range of materials are critical for accelerating atomistic discovery. We introduce universal potentials based on the graph atomic cluster expansion (GRACE) framework, trained on several of the largest available materials datasets."*
— [arXiv:2508.17936](https://arxiv.org/html/2508.17936v1)

**Efficiency competitors** (Sep 2025):
> *"Training on the MPTrj dataset, our model achieves performance comparable to leading approaches with significantly fewer parameters and less than 10% of the training computation. We demonstrate a 2× speedup compared to MACE models."*
— [arXiv:2509.08418](https://arxiv.org/html/2509.08418v1)

**Uncertainty quantification** for safe deployment:
> *"Universal machine learning interatomic potentials (uMLIPs) are reshaping atomistic simulation as foundation models, delivering near ab initio accuracy at a fraction of the cost. Yet the lack of reliable, general uncertainty quantification limits their safe, wide-scale use."*
— [arXiv:2507.21297](https://arxiv.org/html/2507.21297v1)

**Long-range extensions** (FieldMACE):
> *"We introduce FieldMACE, an extension of the MACE architecture that integrates the multipole expansion to model long-range interactions more efficiently."*
— [arXiv:2502.21045](https://arxiv.org/html/2502.21045v1)

**Even the limits are instructive** (Nature, March 2026):
> *"While there are many efforts for constructing universal big MLIP models, their accuracies and speeds of inference still need to be improved for many practical applications."*
— [Nature npj Comp. Mat., March 2026](https://www.nature.com/articles/s41524-026-02023-y)

---

## Step 11: Why This Matters for GNN Research Understanding

**For the convergence thesis ("PE over architecture"):**
In equivariant GNNs, the "positional encoding" IS the 3D coordinates + spherical harmonic features. The architecture's equivariance constraints ARE what makes those encodings useful. You cannot separate PE from architecture here — they're fused. This is a domain where the convergence thesis **does not apply**: the architecture (equivariant vs. invariant) makes a measurable, irreducible difference.

**For the "Graph Transformers are winning" narrative:**
Equivariant GNNs are message-passing networks. They don't use self-attention. They're winning in the domain with the most real-world scientific impact. The GT-vs-MPNN debate looks parochial when viewed from this angle — both sides are fighting over 2D benchmarks while message-passing networks (with equivariance) are solving actual scientific problems.

**For the foundation model question:**
MACE-Osaka24 proves that graph foundation models are feasible when:
1. The graphs share a common underlying physics (atomic interactions)
2. The architecture respects the symmetries of that physics (equivariance)
3. The data heterogeneity problem is solved (TEA)

The question for other GFM domains (social, citation, knowledge graphs) is: what are conditions 1–3 in those settings? Maybe there's no common underlying "physics," which is why cross-domain transfer is harder for generic GFMs.

**Bottom line:** MACE-Osaka24 is significant because it is the first open-source proof that the "foundation model" paradigm — pre-train broadly, fine-tune cheaply, transfer across domains — works for graph neural networks on real scientific problems. It's not aspirational. It's deployed. It's being extended, competed with, fine-tuned, and used. That makes it the most important data point in the Graph Foundation Model discussion, and its absence from the original research note is a critical gap.
