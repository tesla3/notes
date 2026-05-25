# NAtS-L: Bidirectional and Cross-Attention Feasibility Analysis

**Source:** Code analysis of github.com/automl/NeuralAttentionSearchLinear (local clone)  
**Parent note:** `natsl-consolidated-review-2026-03.md`  
**Date:** 2026-03-27

---

## 1. Current Architecture: Causal Self-Attention Only

The released NAtS-L kernels are designed for decoder-only causal LM. Q, K, V all project from the same `hidden_states` with a shared sequence length `T`.

- **Softmax branch** (`attns.py`): has an `is_causal` flag controlling `STAGE` (3=causal, 1=non-causal), but all callers pass `is_causal=True`
- **GDN branch** (`chunk_h.py`, `chunk_o.py`): structurally causal — forward sequential scan accumulating `h_{t+1} = decay * h_t + k_t ⊗ v_t`, lower-triangular intra-chunk attention
- **Routing** (`natsl_attn_gdn.py`): chunks the single sequence, routes based on mean-pooled hidden states, applies to both branches

---

## 2. Bidirectional Self-Attention

### Softmax branch: trivial

Already supported. Set `is_causal=False`:

```python
# attns.py launch wrapper, line ~1445
stage = 3 if is_causal else 1
```

`STAGE=1` makes the kernel iterate over all softmax-assigned KV blocks without the `o_q >= o_k` causal mask. The inner loop (line ~182) iterates purely by `nats_block_indices` with no position ordering assumed:

```python
for i_iter in tl.range(0, b_n_iters):
    b_o_nats_block = tl.load(nats_block_indices + i_iter * stride_block_types_t).to(tl.int32)
    i_s0 = b_o_nats_block * NAtS_BLOCK_SIZE
    # ... loads KV from assigned blocks, no causal check
```

The STAGE=2 block (intra-chunk attention with causal mask at line ~310: `m_s = (o_q[:, None] >= o_k[None, :])`) would need the mask removed for full bidirectional within-chunk attention. This is a one-line change to make `m_s` a boundary-only mask.

**Backward kernel** (`parallel_nats_attn_bwd_kernel`): same STAGE logic. The `dnats` routing gradient computation (line ~875: `b_dattn += tl.sum(tl.where(m_k[:, None], b_ds, 0))`) aggregates over all query positions — works bidirectionally without change.

### GDN branch: add backward scan

The state propagation in `chunk_fwd_kernel_h` (chunk_h.py, line ~73):

```python
b_h = tl.zeros([BK, BV], dtype=tl.float32)
for i_t in range(NT):
    # ... store intermediate h
    b_h *= exp(b_g_last)           # decay
    b_v = (b_v * exp(b_g_last - b_g)[:, None]).to(b_v.dtype)
    b_h += tl.dot(b_k, b_v)       # accumulate k⊗v
```

For bidirectional, add a backward scan — run the same kernel with reversed KV (or a reversed-index variant). Standard pattern from BiMamba / bidirectional linear attention in vision models.

The output kernel (`chunk_fwd_kernel_o`, chunk_o.py, line ~35) computes `o = q @ h` where `h` is the pre-computed state at each chunk boundary. For bidirectional: query both forward and backward states, sum outputs.

Intra-chunk attention in `chunk_o.py` uses implicit lower-triangular (causal) via the `b_A` matrix construction. Change to full matrix for bidirectional.

**Changes required:**
1. Second `chunk_fwd_kernel_h` call with reversed KV (or trivial index-reversal variant)
2. Second `chunk_fwd_kernel_o` call querying backward states
3. Intra-chunk mask: lower-triangular → full
4. Combine forward + backward GDN outputs (sum, concat, or learned combination)
5. Backward kernels: mirror the forward changes

### Routing: unchanged

Mean-pooled chunk features are position-agnostic. Same `nats_block_types` applies to both scan directions. No modification needed.

### Output combination

Currently combines 2 outputs (softmax, GDN). Bidirectional could be:
- **Option A:** 3 outputs — bidirectional-softmax + forward-GDN + backward-GDN. Extend `FusedMultiInputRMSNormGated` to 3 inputs, `n_ops=3`.
- **Option B:** 2 outputs — bidirectional-softmax + (forward-GDN + backward-GDN pre-combined). Keep existing combiner.
- Option B is simpler; Option A gives the router more control.

---

## 3. Cross-Attention

### Softmax branch: moderate mechanical changes

The kernel currently uses a single `T` for both Q and KV:

```python
# attns.py launch wrapper, line ~1396
B, T, H, K, V = *k.shape, v.shape[-1]
o = torch.empty(B, T, HQ, V, ...)   # same T for output
```

But the inner loop already indexes Q and KV independently — Q via `i_t * BT`, KV via `nats_block_indices`:

```python
# Q block pointer
p_q = tl.make_block_ptr(q + (bos * HQ + i_hq) * K, (T, K), (HQ * K, 1), (i_t * BT, 0), (BT, BK), (1, 0))

# KV block pointers — indexed by nats_block_indices, not by Q position
p_k = tl.make_block_ptr(k, (K, T), (1, stride_kt), (0, i_s), (BK, BS), (0, 1))
p_v = tl.make_block_ptr(v, (T, V), (stride_vt, 1), (i_s, i_v * BV), (BS, BV), (1, 0))
```

**Changes required:**
1. Add `T_q` and `T_kv` as separate constexprs (currently both are `T`)
2. Q block pointers and output use `T_q`; KV block pointers use `T_kv`
3. Drop causal mask (cross-attention is non-causal) — `STAGE=1`
4. `n_iters_per_block` computation uses `T_kv` for KV blocks, `T_q` for Q grid
5. Backward kernel: same decoupling — `dQ` shape is `T_q`, `dK/dV` shape is `T_kv`
6. `dnats` routing gradient: aggregates over decoder Q positions (shape unchanged, indexed by KV chunks)

### GDN branch: *simpler* than current code

This is the key insight. For cross-attention, encoder KV builds the state, decoder Q queries it. The sequential scan over encoder chunks produces a final state `S`:

```python
# chunk_fwd_kernel_h runs over encoder KV:
for i_t in range(NT_encoder):
    b_h *= exp(b_g_last)
    b_h += tl.dot(b_k_enc, b_v_enc)
# → S = final b_h
```

Every decoder Q position sees the **same** state `S` (no causal ordering between encoder and decoder). The output kernel collapses to:

```python
# For each decoder Q chunk:
b_o = tl.dot(b_q_dec, b_h)   # b_h is the single pre-computed encoder state
```

No intermediate states needed. No intra-chunk attention between decoder positions (they don't attend to each other via GDN — that's the encoder's job). The `chunk_fwd_kernel_o` simplifies because `h` is the same for all decoder chunks.

**NAtS routing applies to encoder chunks** — which encoder chunks get softmax (exact retrieval) vs GDN (compressed into state). The router mean-pools encoder hidden states.

**Changes required:**
1. `chunk_fwd_kernel_h`: runs over encoder KV only (already works — just feed encoder KV)
2. `chunk_fwd_kernel_o`: query with decoder Q, all chunks use the same final `h`. Remove intra-chunk lower-triangular attention (decoder tokens don't attend to each other through this path). Simplification, not complication.
3. Launch wrapper: separate `T_encoder` and `T_decoder`
4. Backward: `dQ` flows from decoder, `dK/dV/dg/dbeta` flow to encoder, `dh` connects them

### Routing for cross-attention

Route based on **encoder** chunks:

```python
# Currently in natsl_attn_gdn.py forward:
hs_reduced = self.pooling_func(nats_layer_input.unsqueeze(-2), chunk_size=self.nats_block_size)
nats_op_types = self.nats_layer(hs_reduced)
```

For cross-attention, `nats_layer_input` = encoder hidden states. Minimal change — the caller passes encoder hidden states to the routing path, decoder hidden states to Q projection.

### Output combination

Q-derived weights (`nats_out_weights_layer`) use decoder Q — correct for cross-attention (decoder decides what it needs). `FusedMultiInputRMSNormGated` operates on decoder-length outputs from both branches. Gate projection (`g_proj`) takes decoder hidden states. All unchanged.

---

## 4. Effort Estimate

| Modification | Softmax kernel | GDN kernel | Routing | Combiner | Backward kernels |
|---|---|---|---|---|---|
| **Bidirectional** | 1 flag + 1 mask line | Add reversed scan + combine (new kernel call, ~50 lines) | None | Extend to 3 inputs or pre-combine | Mirror forward changes |
| **Cross-attention** | Decouple `T_q`/`T_kv` (~20 lines) | Simplify — remove intra-chunk attn, single state query | Encoder input instead of self | None | Decouple T dimensions |

**Bidirectional:** ~1-2 days. Backward scan is the main work, but it's a well-known pattern. Testing against a naive PyTorch reference is straightforward.

**Cross-attention:** ~1-2 days. Mostly mechanical decoupling of sequence lengths. The GDN branch actually gets simpler. The softmax backward kernel (`parallel_nats_attn_bwd_kernel`) is the most tedious part — it has the same `T` coupling.

**Both combined:** ~3-4 days. The changes are orthogonal and compose cleanly.

---

## 5. Design Considerations

### Bidirectional: scan combination strategy

Options for combining forward and backward GDN outputs:
- **Sum:** `o_gdn = o_fwd + o_bwd`. Simple, loses directional information.
- **Concatenate + project:** `o_gdn = W_o [o_fwd; o_bwd]`. Doubles value dim temporarily. More expressive.
- **Per-direction routing:** Route chunks to {softmax, forward-GDN, backward-GDN} independently. `n_ops=3`. Most flexible but increases routing complexity.

Recommendation: start with sum (simplest), benchmark, then try concat if quality is insufficient.

### Cross-attention: where does routing gradient come from?

In self-attention, the routing gradient piggybacks on the backward kernels that process both Q and KV from the same sequence. In cross-attention:
- **Softmax `dnats_attn`:** Aggregates `b_ds` over decoder Q positions attending to encoder KV blocks. Still works — the decoder's loss gradient flows through attention logits to encoder KV blocks.
- **GDN `dnats_gdn`:** Computes `sum(b_k * b_dk)` — how much each encoder key's contribution to the state affects downstream decoder loss. Still works — `dh` propagates from decoder output through the state to encoder KV.

Both gradient signals remain meaningful for cross-attention. No auxiliary loss needed.

### Cross-attention: routing depends on encoder only

The router sees only encoder hidden states at routing time — it cannot condition on what the decoder will query. This is the same "premature commitment" problem as in self-attention (§5.8 of the consolidated review), but arguably less severe: in cross-attention, the encoder representation is fully formed (post-encoder), so the mean-pooled features are more informative than the pre-attention hidden states used in self-attention routing.

### Shared vs separate routing for encoder/decoder

If using NAtS-L in both the encoder self-attention and the cross-attention layers, the encoder chunks could be routed once and reused. The same chunk that was softmax-assigned in encoder self-attention would also be softmax-assigned in cross-attention. This avoids redundant routing but loses task-specific flexibility (a chunk might need exact retrieval for cross-attention but not for encoder self-attention).

---

*Analysis based on code inspection of local clone of github.com/automl/NeuralAttentionSearchLinear, 2026-03-27.*
