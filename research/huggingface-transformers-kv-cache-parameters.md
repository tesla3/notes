# HuggingFace Transformers KV Cache Parameters: use_cache, past_key_values, cache_position

Source: HuggingFace Transformers source code (v4.44, v5.4, main branch), 2026-04-14

---

## Overview

Three parameters control KV caching in HuggingFace Transformers model forward passes. Traced through actual Mistral/LLaMA source code.

## 1. `use_cache: bool`

**What**: Boolean flag — "should this forward pass store and return K/V projections for reuse?"

**Default resolution** (via `merge_with_config_defaults` decorator):
- If `None` → reads `model.config.use_cache` (typically `True`)
- If `gradient_checkpointing=True` during training → forced to `False` with warning

**Code path when `True`**:
1. Creates `DynamicCache` if `past_key_values` is `None`
2. Each attention layer stores K/V into the cache via `cache.update()`
3. Returns filled cache in `outputs.past_key_values`

**Code path when `False`**:
- No cache created
- K/V computed and discarded each pass
- Returns `None` for `past_key_values`

**When to use**:
- `True` → inference / autoregressive generation (avoid recomputing K/V)
- `False` → training (full sequence at once; caching wastes memory)

## 2. `past_key_values: Cache | None`

**What**: The actual KV cache object holding previously computed Key and Value tensors for every layer. Pass it back on subsequent calls to reuse old K/V states.

**Data structure** (`DynamicCache`):
```python
class DynamicCache(Cache):
    # One tensor per layer, shape: [batch_size, num_kv_heads, seq_len, head_dim]
    key_cache: List[torch.Tensor]
    value_cache: List[torch.Tensor]
```

**Lifecycle**:

1. **First call (prefill)**: `past_key_values=None` → model creates empty `DynamicCache`, fills it with K/V for all input tokens
2. **Subsequent calls (decode)**: pass `outputs.past_key_values` back → model computes K/V for new token(s) only, concatenates with cached history

**Core mechanism** (`DynamicCache.update()`):
```python
# First call: append
self.key_cache.append(key_states)
# Subsequent calls: concatenate along sequence dimension
self.key_cache[layer_idx] = torch.cat([self.key_cache[layer_idx], key_states], dim=-2)
```

Attention then uses Q from new token(s) against full K/V (cached + new), reducing generation from O(N³) to O(N²).

**`StaticCache`** alternative: pre-allocates fixed-size buffers, writes at specific indices via `index_copy_`. Used with `torch.compile` / `torch.export`.

## 3. `cache_position: torch.LongTensor` (DEPRECATED in v5.x)

**What**: 1D tensor of absolute position indices — "these tokens are at positions [X, X+1, ...]".

**Why it existed** (v4.44 and earlier):
1. **StaticCache needs write locations**: `k_out.index_copy_(2, cache_position, key_states)` — knows which buffer slots to fill
2. **Causal mask construction**: `exclude_mask = torch.arange(target_length) > cache_position.reshape(-1, 1)` — builds correct lower-triangular + sliding-window mask
3. **Drives `position_ids`** for RoPE: `position_ids = cache_position.unsqueeze(0)` — ensures correct rotary embeddings

**Auto-generation** (v4.44):
```python
if cache_position is None:
    past_seen_tokens = past_key_values.get_seq_length() if past_key_values is not None else 0
    cache_position = torch.arange(past_seen_tokens, past_seen_tokens + seq_len, device=device)
```

**Status in v5.4**: Completely removed from Mistral (and other models). Zero occurrences in source. The model now infers positions directly from the `Cache` object:
```python
if position_ids is None:
    past_seen_tokens = past_key_values.get_seq_length() if past_key_values is not None else 0
    position_ids = torch.arange(inputs_embeds.shape[1], device=device) + past_seen_tokens
```

Deprecated in `masking_utils.py` with: "will be removed in Transformers v5.6. Please use `q_length` and `q_offset` instead."

## How They Work Together

```
use_cache=True   →  "Yes, save K/V for later"
past_key_values  →  The container holding saved K/V (None first call, pass back after)
cache_position   →  [DEPRECATED v5.x] Absolute positions of current tokens
```

## Minimal Usage Pattern (v5.4+)

```python
# Prefill
outputs = model(input_ids=prompt_ids, use_cache=True)

# Decode loop
for _ in range(max_new_tokens):
    outputs = model(
        input_ids=new_token_id,
        past_key_values=outputs.past_key_values,
        use_cache=True
        # No cache_position needed — library infers from Cache object
    )
```

## Version Changes

| Parameter | v4.44 | v5.4 (current) |
|---|---|---|
| `use_cache` | Explicit param, config fallback | Same, plus `merge_with_config_defaults` decorator |
| `past_key_values` | `DynamicCache` / tuple (legacy) | `DynamicCache` only (tuple support dropped) |
| `cache_position` | Active param, auto-generated if missing | **Removed entirely**, inferred from Cache |
| Cache types | `DynamicCache`, `StaticCache`, `SlidingWindowCache` | Refactored: `DynamicCache` with `DynamicLayer` / `DynamicSlidingWindowLayer` per-layer |
