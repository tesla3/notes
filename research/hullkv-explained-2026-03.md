# HullKV: Step-by-Step Explanation

## The Problem

In standard transformer decoding, every new token must attend to all previous tokens. For each attention head, this means:

```
For query q (current token), compute q · k_i for every key k_i in the KV cache
Then softmax over all scores, weighted sum of values
```

Cost per token: **O(n · d)** where n = sequence length, d = head dimension.

For a model executing a program step-by-step over thousands of tokens, this O(n) scan per head per layer per token becomes the bottleneck.

## Step 1: Replace Softmax with Hard Attention (Argmax)

Standard attention is "soft" — it computes a weighted average of all values:

```
output = Σ softmax(q · k_i / √d) · v_i
```

Hard attention replaces this with argmax — pick the single best-matching key and return only its value:

```
output = v_{argmax_i(q · k_i)}
```

**Why this works for program execution:** A VM reading a register or memory address needs *exact* lookup, not a fuzzy weighted blend. Hard attention gives you a lookup table: "which stored key best matches my query?" → return that value.

**Trade-off:** You lose the expressiveness of soft attention (blending information from multiple positions). But for deterministic computation, that's exactly what you want — one address, one value.

## Step 2: Restrict Head Dimension to 2

Percepta's key architectural choice: set d_head = 2. Each key and query is now just a **point in 2D space**.

From the code in the thread:
```python
# d_model = 36 with n_heads = 18 gives exactly 2D per head
```

So 18 attention heads, each operating in its own 2D plane. Think of each head as its own coordinate system where keys are scattered as (x, y) points.

**Why 2D?** This is where the geometric speedup lives. In higher dimensions, there's no fast structure. In 2D, we can use convex hulls.

## Step 3: The Core Geometric Insight

The argmax query `argmax_i(q · k_i)` over 2D points has a beautiful geometric interpretation:

**The dot product q · k_i = |q| · |k_i| · cos(θ)** where θ is the angle between q and k_i.

Maximizing q · k_i means: *"which point k_i has the largest projection onto the direction of q?"*

Visually: imagine shining a light in the direction q. The point that casts the farthest shadow along that direction wins.

**Critical fact from computational geometry:** The extreme point of a set of 2D points in any direction always lies on the **convex hull** of those points.

```
        *  ← this point is extreme in direction ↗
       / \
      /   \
     *     *
     |     |
     *-----*
     
Interior points NEVER win the argmax for any query direction.
```

## Step 4: Build the Convex Hull of Keys

Instead of storing all n keys and scanning them linearly, maintain the **convex hull** of the key points in each 2D head.

Properties of convex hulls in 2D:
- The hull has h ≤ n vertices (often h ≪ n)
- Hull vertices are sorted by angle around the hull
- Adding a new point: O(log h) amortized to update the hull
- The hull is a polygon

As each new KV pair arrives (each generated token), insert the new 2D key into the hull. Points that end up in the interior can be ignored for argmax queries — they'll never be the answer for any query direction.

## Step 5: Binary Search for Argmax (The Speedup)

Here's the punchline. Given a query q, we want `argmax_i(q · k_i)` over the hull vertices.

The dot product q · k varies *unimodally* around the convex hull (it increases, peaks, then decreases as you walk the vertices). This means **binary search works**:

```
Hull vertices sorted by angle: v_1, v_2, ..., v_h

For query direction q:
  - Check the midpoint vertex v_m
  - Compare q · v_{m-1} vs q · v_{m+1} to determine which half contains the max
  - Recurse on that half

Cost: O(log h) ≤ O(log n)
```

This replaces the O(n) linear scan over all keys with **O(log n) binary search** on the hull.

## Step 6: The Full HullKV Cache

Putting it together for each 2D attention head:

```
Data structure per head:
  - Convex hull of all key points seen so far
  - Mapping from each hull vertex back to its position (to retrieve the corresponding value)

On new token (key k_new, value v_new):
  1. Insert k_new into the 2D convex hull → O(log h)
  
On query (query q):
  1. Binary search the hull for argmax(q · k) → O(log n)
  2. Look up the corresponding value v → O(1)
  3. Return v
```

**Total decoding cost per token:** O(k + log n) where k is the number of heads (18 here) — instead of O(k · n) for standard attention.

For a sequence of length 10,000:
- Standard: scan 10,000 keys per head per token
- HullKV: binary search ~13 steps per head per token

That's roughly a **750x speedup** in the attention computation.

## Step 7: Why 2D Specifically? (Not 1D, Not 3D)

**1D (d_head = 1):** Argmax is just "find the max scalar." You can track this in O(1), but you only get one distinguishable "direction." A single 1D head is one register. Not enough for a VM.

**2D (d_head = 2):** Convex hull is a polygon. Binary search on vertices is O(log n). Incremental updates are O(log n). The hull rejects interior points, keeping the structure small. This is the computational geometry sweet spot.

**3D+ (d_head ≥ 3):** Convex hulls become polyhedra/polytopes. Extreme point queries jump to O(log² n) or worse. Hull maintenance becomes much harder. The number of hull facets can grow as O(n^⌊d/2⌋). The clean binary search property vanishes.

**2D is the unique dimension where convex hull queries are both fast AND expressive enough to encode multiple distinguishable addresses.**

## Step 8: How This Enables a VM

With 18 heads, each a 2D lookup table:
- Different heads serve as different "register files" or "memory banks"
- Keys encode addresses (2D coordinates chosen by the weight compiler)
- Values encode data at those addresses
- The feed-forward layers between attention layers implement the ALU (arithmetic, branching logic)

Each transformer layer = one clock cycle of the VM:
1. **Read** (attention): query the hull to fetch register/memory values in O(log n)
2. **Compute** (FFN): apply operations to the fetched values
3. **Write** (output → next layer's KV): store results as new keys/values

The WASM interpreter is "compiled" into weights that orchestrate this read-compute-write cycle to execute WASM bytecode.

## The Key Limitation

**Hard attention is not differentiable with respect to keys and queries.** The argmax operation has zero gradient almost everywhere. As yorwba pointed out in the thread, straight-through estimation doesn't preserve the speedup in the backward pass.

This means:
- The weights are **computed analytically**, not trained via gradient descent
- The article's claim that "the whole process remains differentiable" is misleading at best
- You can't learn new programs through this mechanism — you can only compile known programs into weights

## Connection to Known Techniques

HullKV is essentially the well-known **convex hull trick** from competitive programming (used to optimize DP transitions of the form `max(a_i · x + b_i)` over i), but applied to transformer attention:

| Competitive Programming | HullKV |
|------------------------|--------|
| Lines y = a·x + b | Key points (k_x, k_y) |
| Query: given x, find max y | Query: given q, find max q·k |
| Maintain upper envelope | Maintain convex hull |
| Binary search on hull | Binary search on hull |

The insight is recognizing that restricting attention to 2D makes the attention operation *equivalent* to this classic problem, unlocking the same O(log n) optimization.
