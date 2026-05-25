# Supplemental Review: NodePFN — Additional Issues Beyond Review + Gaps Analysis

Source: Deep code audit of https://github.com/jeongwhanchoi/NodePFN (torch_geometric==2.3.1)
Date: 2026-03-27

---

## Scope

This document identifies **issues not covered by** either `nodepfn-review.md` (the critical review) or `nodepfn-review-gaps.md` (the gap analysis). I also **re-evaluate** certain claims from both documents where I found nuance or error. All code references verified against the local repo.

---

## NEW ISSUE 1: Double Self-Loops Corrupt GCN Normalization [SIGNIFICANT]

**The problem.** Self-loops are added to the edge index **twice** — once in `transformer.py` before passing into the GPS layer, and again internally by `GCNConv` (default `add_self_loops=True`).

In `transformer.py` (lines within `forward()`):
```python
edge_index = to_undirected(edge_index)
edge_index, _ = remove_self_loops(edge_index)
edge_index, _ = add_self_loops(edge_index, num_nodes=x_src.shape[0])  # ← adds self-loops
edge_index = edge_index.to(x_src.device)
```

Then in `layer.py`, the edge_index is passed to GCNConv:
```python
h_local = self.local_model(h_local_input.transpose(0,1), edge_index).transpose(0,1)
```

Where `self.local_model = pygnn.GCNConv(d_model, d_model)` — and PyG 2.3.1's `GCNConv.__init__` defaults to `add_self_loops=True`, `normalize=True`. Inside its `forward()`, GCNConv calls `add_self_loops()` **again**, creating duplicate self-loop edges.

**Mathematical consequence.** GCN computes $\hat{D}^{-1/2} \hat{A} \hat{D}^{-1/2}$ where $\hat{A} = A + I$. With duplicate self-loops, the effective adjacency becomes $\hat{A}' = A + 2I$. The degree of node $i$ becomes $d_i + 2$ instead of $d_i + 1$. The self-connection weight changes from $\frac{1}{d_i+1}$ (correct) to $\frac{2}{d_i+2}$ (distorted). For low-degree nodes (common in sparse graphs like Cora, avg degree ≈ 4), this over-weights self-features relative to neighbors.

**Evidence this is a known class of issue.** PyG Issue #2288 asks:
> "In many convolution layers, we can set the option `add_self_loops`. By default, it is almost always true... **Isn't it an issue if the dataset already has self-loops?** Shouldn't we always prefer `utils.add_remaining_self_loops()`?"

PyG Issue #1109 confirms:
> "For example, in function `get_laplacian` if a node already has a self-loop, the function adds another self-loop to the node."

**Consistency.** The bug is consistent between training and inference — both paths go through `transformer.py`'s edge processing before the GCN. So the model was trained with double self-loops and infers with double self-loops. The model may have adapted to this, but the normalization is mathematically wrong per the GCN formulation (Kipf & Welling, 2017).

**Fix:** Either set `add_self_loops=False` in `GCNConv` initialization (since self-loops are added upstream), or remove the upstream `add_self_loops` call.

---

## NEW ISSUE 2: Test-Time Feature Normalization Leaks Test Data [MODERATE]

In `node_classification.py`, all inference calls use `normalize_with_test=True`:
```python
predictions, p_eval = clf.predict(X_query, normalize_with_test=True, ...)
prediction_probabilities = clf.predict_proba(X_query, normalize_with_test=True)
```

This flows into `transformer_predict()` → `preprocess_input()`, where:
```python
eval_xs = normalize_data(eval_xs, normalize_positions=-1 if normalize_with_test else eval_position)
```

And `normalize_data` in `utils.py`:
```python
def normalize_data(data, normalize_positions=-1):
    if normalize_positions > 0:
        mean = torch_nanmean(data[:normalize_positions], dim=0)  # train only
        std = torch_nanstd(data[:normalize_positions], dim=0) + .000001
    else:
        mean = torch_nanmean(data, dim=0)  # ALL data including test
        std = torch_nanstd(data, dim=0) + .000001
    data = (data - mean) / std
    ...
```

With `normalize_with_test=True`, **mean and standard deviation are computed over train+test data jointly.** Every test node's features influence the normalization of every other node. This is a form of transductive leakage in preprocessing.

The code itself acknowledges leakage risks. In `transformer_prediction_interface.py`:
```python
# TODO: Caution there is information leakage when to_ranking is used, we should not use it
```

**Impact.** Standard supervised baselines (GCN, GAT, GraphSAGE) typically normalize only with training statistics at evaluation time. The normalization leakage gives NodePFN an unfair advantage in comparisons, particularly on datasets where the test distribution differs from train. The magnitude depends on the test-to-train ratio — for datasets where the query set is much larger than the train set (e.g., Cora: 140 train, 2428 query), the test data dominates the normalization statistics.

---

## NEW ISSUE 3: GCN Initialization Asymmetry Creates Training Bias [MODERATE]

In `transformer.py`, `init_weights()` deliberately zeroes out specific components:
```python
def init_weights(self):
    ...
    for layer in self.transformer_encoder.layers:
        nn.init.zeros_(layer.linear2.weight)    # FFN last layer → zeroed
        nn.init.zeros_(layer.linear2.bias)
        attns = layer.self_attn if isinstance(layer.self_attn, nn.ModuleList) else [layer.self_attn]
        for attn in attns:
            nn.init.zeros_(attn.out_proj.weight)  # Attention output → zeroed
            nn.init.zeros_(attn.out_proj.bias)
```

This initialization — zeroing the attention output projection and FFN last layer — is inherited from TabPFN. It means that at the start of training, the attention branch produces near-zero outputs. However, **the GCN branch (`layer.local_model`) keeps its PyG default initialization** (Glorot/Xavier for weights, zero for bias in `GCNConv`). The GCN branch produces non-trivial outputs from step 1.

The GPS combination with per-branch residuals gives:
```
output ≈ (h_in + GCN_out) + (h_in + 0) = 2*h_in + GCN_out  [early training]
```

The model is initialized to rely entirely on the GCN path. The attention mechanism must learn to contribute from a zero-output starting point, while competing with an already-functional GCN. This creates an **inductive bias toward local graph structure** in early training that may persist — a form of the "rich-get-richer" phenomenon in optimization.

This is neither documented nor ablated. Whether it helps or hurts depends on the task, but it's a design choice with significant consequences that should be explicit.

---

## NEW ISSUE 4: Edge Index Concatenation Bug for Batched Graphs [LATENT — COMPOUNDING]

In `flexible_categorical.py` (line ~268):
```python
x, y, y_, edge_index = zip(*sample)
x, y, y_, edge_index = torch.cat(x, 1).detach(), ..., torch.cat(edge_index, 1).detach()
```

And identically in `differentiable_prior.py` (line ~258) and `prior_bag.py` (line ~27).

When `batch_size_per_gp_sample > 1`, this concatenates edge indices from **separate synthetic graphs** along dimension 1. But each graph's edge indices use node IDs 0..N-1. Concatenating them creates a merged edge list where edges from graph $i$ and graph $j$ reference the same node IDs, mixing graph structures.

The correct approach for multi-graph batching in PyG is to offset node indices per graph (using `torch_geometric.data.Batch`). This code does no offset.

**Interaction with the "batch bug" from the review (§3).** The review identified that `generate_edge_index` only returns the last batch item's graph. The gaps analysis correctly noted this never triggers (batch_size=1). However, if someone fixed the `generate_edge_index` bug to return per-sample graphs, they would immediately hit THIS concatenation bug. The two bugs are **compensating**: fixing one would expose the other. Any attempt to increase training graph diversity by raising the batch size would silently produce corrupted training data through both bugs.

---

## NEW ISSUE 5: Over-Smoothing from Compounded Graph Processing [SIGNIFICANT]

The review (§5) notes the triple application of graph structure but doesn't quantify the depth. Consider Cora (the primary benchmark):

| Processing stage | Graph operations | Hops |
|---|---|---|
| External pre-smoothing | `smoothing_steps=4` × GCN-normalized averaging | 4 |
| GPS GCN layers | 12 transformer layers × 1 GCNConv per layer | 12 |
| **Total** | | **16** |

Sixteen rounds of message-passing on a graph with mean degree ~4. The classic over-smoothing result from Li et al. (AAAI 2018) showed:
> "We find that the performance of GCN significantly drops when the number of layers is larger than 3 in the standard semi-supervised node classification setting."

And Oono & Suzuki (ICLR 2020) proved:
> "Graph convolutions with ReLU activations exponentially lose expressive power regarding the input node features as the number of layers increases."

The 12-layer GCN-per-layer is partially mitigated by the residual connections (the `h_in1` term preserves the input). But 4 external smoothing steps have NO residual — they are pure averaging. The smoothed features that enter the model have already lost substantial node-level discrimination.

**Ablation evidence from the code itself.** Heterophilic datasets ALL use `smoothing_steps=0` (from `run.sh`):
```bash
# Cornell: --smoothing_steps 0
# Texas: --smoothing_steps 0
# Wisconsin: --smoothing_steps 0
# Chameleon: --smoothing_steps 0
# Actor: --smoothing_steps 0
# Deezer: --smoothing_steps 0
```

This confirms that external smoothing hurts when the graph's label structure is not homophilic — exactly as over-smoothing theory predicts. The "universal" model's external preprocessing must be turned off for an entire class of graphs.

---

## NEW ISSUE 6: GPS Combination Uses Sum Instead of Mean — Documented? [MODERATE]

The gaps analysis (Gap 2) correctly identifies the doubled residual. I can now confirm this differs from the **reference implementation**. PyG 2.3.1's official `GPSConv` (the same version NodePFN depends on) uses **mean** combination:

From [PyG GPSConv source](https://pytorch-geometric.readthedocs.io/en/2.3.1/_modules/torch_geometric/nn/conv/gps_conv.html):
```python
# After per-branch residuals:
hs.append(h_local)  # = h + local_out
hs.append(h_attn)   # = h + attn_out
out = sum(hs) / len(hs)  # ← MEAN, not SUM
```

Effective residual with **mean**: `(h + local) + (h + attn)) / 2 = h + (local + attn)/2` → **1× residual**

NodePFN `layer.py`:
```python
h = sum(h_out_list)  # ← SUM, not MEAN
```

Effective residual with **sum**: `(h + local) + (h + attn) = 2h + local + attn` → **2× residual**

The original GPS paper (Rampášek et al., NeurIPS 2022) lists sum, mean, and concatenation as valid combination strategies. But the 2× residual from per-branch-residual + sum is an architectural detail with real consequences for gradient flow and training dynamics. It's not documented as a deliberate choice in NodePFN.

---

## NEW ISSUE 7: The Pre-Smoothing Destroys the PFN's Feature Independence Assumption [SIGNIFICANT — CONCEPTUAL]

This is a deeper version of the review's §5 point, connecting it to the PFN's Bayesian foundation.

The PFN framework approximates $p(y_* | x_*, D_\text{train})$ — the posterior predictive distribution conditioned on the training set and a single test point. For this to be valid, the features $x_*$ of the test point must be the **original** features, not features contaminated by other test points.

The external smoothing step:
```python
for step in range(args.smoothing_steps):
    X = conv(X, dataset.graph['edge_index'], dataset.graph['edge_weight'])
```

This operates on the **entire graph** — train and test nodes together. After smoothing, test node $i$'s features contain information from its neighbors, including **other test nodes**. The PFN then receives these smoothed features as if they were independent inputs. But they're not — they encode the test set's feature distribution through the graph structure.

This violates the PFN's conditional independence assumption at the input level. The model is no longer approximating $p(y_* | x_*, D_\text{train})$ but rather $p(y_* | \tilde{x}_*(\mathcal{X}_\text{test}), D_\text{train})$ where $\tilde{x}_*$ is a function of the entire test feature matrix. This compounds the GCN leakage issue the review identifies in §8, but happens **before** the model even sees the data.

Combined with the `normalize_with_test=True` normalization (Issue 2 above), the test-time independence assumption is violated in at least three separate ways: (1) feature smoothing, (2) feature normalization, (3) GCN message-passing inside the model.

---

## RE-EVALUATION: Gaps Analysis on the "Critical Bug" [AGREE WITH NUANCE]

The gaps analysis correctly determines the edge_index batch bug never triggers with the shipped config (`batch_size_per_gp_sample=1` after the aggregate-k-gradients division). I independently verified the full call chain:

```
pretrain.py: batch_size=8, aggregate_k_gradients=8
→ model_builder.py: batch_size = ceil(8/8) = 1
→ differentiable_prior.get_batch: batch_size_per_gp_sample = min(64, 1) = 1, num_models = 1
→ prior_bag.get_batch: batch_size_per_gp_sample = min(64, 1) = 1, num_models = 1
→ flexible_categorical.get_batch: batch_size_per_gp_sample = min(32, 1) = 1, num_models = 1
→ FlexibleCategorical.forward: get_batch returns x with shape (1024, 1, H)
→ generate_edge_index: loop range(x.shape[1]) = range(1) → single iteration
```

However, I add: the review's observation about the code **intent** is still valuable. The loop structure `for b in range(x.shape[1])` clearly intended per-batch-item graph generation. Combined with Issue 4 above (the concatenation bug), this reveals a pattern: the codebase was designed for multi-graph batching but only works correctly with batch_size=1. Two independent bugs prevent proper multi-graph training.

---

## RE-EVALUATION: Gaps Analysis on the GP Prior [AGREE, WITH SHARPER FRAMING]

The gaps analysis correctly identifies that `prior_bag_exp_weights_1 ≈ 1,000,000` makes the GP prior effectively dead. I independently verified:

```python
# model_configs.py:
'prior_bag_exp_weights_1': {'distribution': 'uniform', 'min': 1000000.0, 'max': 1000001.0}

# prior_bag.py:
prior_bag_priors_p = [1.0] + [hyperparameters['prior_bag_exp_weights_1']]  # = [1.0, ~1000000.5]
weights = torch.softmax(torch.tensor([1.0, 1000000.5]), 0)  # ≈ [0.0, 1.0]

# model_builder.py:
prior_bag_hyperparameters = {'prior_bag_get_batch': (get_batch_gp, get_batch_mlp), ...}
# Index 0 = GP, Index 1 = MLP
# softmax weight 1.0 → GP, softmax weight 1000000 → MLP
# MLP selected ~100% of the time
```

**Sharper framing:** The paper's abstract says priors include "GP" and "MLP" feature generators. This is marketing — the GP code exists but is dead. The model was trained on MLP-generated features only. The `fast_gp.py` module (144 lines) is dead code during training. The `gpytorch` dependency is unused. This should be disclosed; claiming "GP feature priors" without qualification is misleading.

---

## RE-EVALUATION: Doubled Residual [AGREE, EXTEND]

The gaps analysis correctly identifies the doubled residual. I extend with the **downstream consequence**:

After the GPS branch combination produces `h = 2*h_in1 + local_out + pfn_out`, the FFN block adds another residual:
```python
h2 = self.linear2(self.dropout(self.activation(self.linear1(h))))
h = h + self.dropout2(h2)  # = 2*h_in1 + local_out + pfn_out + FFN(...)
```

Through L=12 layers, the accumulated residual coefficient on the original input is at least $2^{12} = 4096$ times what it would be with single residuals (for layers where both GCN and attention are active). In practice, the normalization layers partially compensate, but the effective learning rate for the GCN and attention outputs is much smaller relative to the residual than intended.

This may explain an otherwise puzzling observation: the model works despite a simplistic prior and limited architecture. The extremely strong residual path means the model is essentially performing a mild perturbation of its input features at each layer, with the GCN and attention contributing small corrections. The model is closer to a feature refiner than a deep graph transformer.

---

## SUMMARY OF ALL NEW ISSUES

| Issue | Severity | Type | Source |
|---|---|---|---|
| Double self-loops in GCNConv | Significant | Bug | `transformer.py` + PyG GCNConv default |
| Test-time normalization leakage | Moderate | Methodological | `node_classification.py` → `utils.py` |
| GCN/Attention initialization asymmetry | Moderate | Design gap | `transformer.py:init_weights()` |
| Edge index concatenation for multi-graph | Latent bug | Bug | `flexible_categorical.py`, `prior_bag.py` |
| Over-smoothing from 16-hop graph processing | Significant | Methodological | `node_classification.py` + `layer.py` |
| Sum vs Mean GPS combination (2× residual) | Moderate | Undocumented deviation | `layer.py` vs PyG `GPSConv` |
| Pre-smoothing violates PFN independence | Significant | Theoretical | `node_classification.py` |

**Overall assessment of the review + gaps analysis.**

The review is sharp and the gaps analysis is excellent — the correction of the "critical bug" saves credibility. Together they cover the major architectural, theoretical, and practical issues. The findings above are mostly **compounding factors** that reinforce the existing verdict rather than overturning it:

1. The "it works despite everything" pattern (§10 of the review) is explained by the extreme residual strength — the model is a mild feature refiner, not a deep graph transformer.
2. The "universality" claim is further weakened: the model leaks test information in three independent ways (smoothing, normalization, GCN), making it less "clean" than claimed even for the transductive setting.
3. The codebase's multi-graph training capability is doubly broken (generate_edge_index bug + concatenation bug), revealing that single-graph-per-step was an accident of configuration, not a design choice.

The strongest addition to the overall critique is the **theoretical point** (Issue 7): the PFN's Bayesian grounding requires test-point independence, but NodePFN violates this at the *input level* through pre-smoothing — before the model even runs. Combined with the review's §8 (GCN leakage inside the model) and the new Issue 2 (normalization leakage), the "posterior predictive distribution" claim is undermined at three levels: input, architecture, and preprocessing.
