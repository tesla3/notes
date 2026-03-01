← [Index](../README.md)

# RTX 6000 Pro Blackwell vs RTX 3090 for Local LLM Inference

**Date:** 2026-02-28
**Context:** Hardware claims from [HN Qwen3.5 thread](hn-qwen35-local-models-2026-02.md) — specifically that the RTX 6000 Pro Blackwell (96GB, ~$8K) is "the serious option" and the RTX 3090 (24GB, ~$600-700 used) is "the budget entry point." Testing these claims against evidence.

---

## RTX 6000 Pro Blackwell: The Case

### Specs

- **GPU:** GB202 (Blackwell), 24,064 CUDA cores, 752 5th-gen Tensor Cores
- **VRAM:** 96GB GDDR7 with ECC, 512-bit bus
- **Bandwidth:** 1,792 GB/s (workstation ed.) / 1,597 GB/s (server ed.)
- **TDP:** 600W (workstation), 300W (Max-Q)
- **Price:** ~$8,000 (street, down from $9,300 launch). Server edition available through cloud providers.
- **Variants:** Workstation (600W, active cooling), Max-Q (300W, dual-slot), Server (passive, rack-mount)

### Evidence FOR

**1. Single-GPU capacity is transformative for large models.**
96GB VRAM on one card means you can run a 70B Q4_K_M (~40GB) with enormous context, or a 122B MoE Q4 (~70GB) entirely in VRAM on a single GPU — no multi-GPU overhead. This is the core value proposition. Multi-GPU setups (e.g., 4×3090) lose 10-50% of throughput to inter-GPU communication depending on NVLink availability and PCIe topology.
- Source: r/LocalLLaMA benchmark post showing NVLink improves 2×3090 inference by ~50%, meaning without NVLink you're losing ~33% of potential throughput to PCIe bottleneck. ([himeshp.blogspot.com](http://himeshp.blogspot.com/2025/03/vllm-performance-benchmarks-4x-rtx-3090.html))

**2. Actual benchmark numbers (llama.cpp, llama-bench):**

| Model | Size in VRAM | pp512 (t/s) | tg128 (t/s) |
|-------|-------------|-------------|-------------|
| Llama 7B Q4_0 | 3.6 GB | 16,634 | 279 |
| Mistral Nemo 12B Q4_K_M | 7.0 GB | 9,877 | 163 |
| Qwen3 30B-A3B Q4_K_M | 17.3 GB | 7,640 | 252 |
| GPT-OSS 120B Q8_0 | 60 GB | 2,419 | 193 |
| Llama 70B Q4_K_M | 39.6 GB | 1,794 | 34 |
| Llama 405B IQ2_XXS | 99.9 GB | 222 | 2.7 |

Source: [llm-tracker.info/RTX-PRO-6000](https://llm-tracker.info/RTX-PRO-6000)

The 70B at 34 t/s token gen is usable for interactive coding. The MoE models (GPT-OSS 120B, Qwen3 30B-A3B) benefit massively from the architecture — 193 t/s and 252 t/s respectively because only active params need compute while inactive experts just sit in VRAM.

**3. Training compute is exceptional.**
One r/LocalLLaMA user benchmarked the Max-Q edition (300W!) against a 3090 desktop equivalent: the 6000 Pro completed a training run in 20 minutes vs 2.5 hours. "With proper optim, the card can single handedly deliver the training compute of 7.5 rtx 3090 cards, while pulling only 300W of electricity." If you do fine-tuning/LoRA, this is a massive differentiator.

**4. Power-limited performance is remarkably graceful.**
The llama-bench data shows tg128 on Llama 7B barely changes from 600W → 400W (279 → 279 t/s) because token generation is memory-bandwidth-bound, not compute-bound. You can power-limit to 400W and lose essentially nothing for inference. Only at 300W and below does throughput degrade meaningfully.

**5. Future-proof for MoE era.**
The trend in open models is toward larger MoE architectures (Qwen3.5-122B-A10B, Qwen3.5-35B-A3B, DeepSeek, etc.). These models have large total parameter counts but small active parameter counts — meaning they need lots of VRAM for storage but relatively little compute per token. This is exactly the 6000 Pro's sweet spot: tons of VRAM, fast bandwidth, all on one card.

### Evidence AGAINST

**1. Bleeding-edge software pain is real.**
Multiple early adopters report significant issues:
- "The RTX 6000 96GB Blackwell is bleeding edge. I had to build all libraries with the latest CUDA driver to get it to be usable." — r/LocalLLaMA user who wasted 2 days rebuilding libraries.
- "Switch back to the 3090 inside the Razer Core X and everything just works beautifully." — Same user.
- "There is next to no documentation on the RTX Pro 6000's capabilities."
- vLLM forum user: "I am very disappointed, since I do have only problems."
- Must use Linux. Multiple reports that Windows + Ollama/LM Studio on the 6000 is slow/"dumber" than a 3090 running the same model, likely due to backend optimization gaps.

As of late 2025, the software ecosystem is still catching up to Blackwell (compute capability 12.0). This has improved into 2026 but is not fully mature.

**2. "Awkward middle ground" for some workloads.**
One user who owns the card: "when it comes to LLMs, unless you're running two or three of these cards, you end up stuck in this awkward middle ground." 96GB isn't enough for unquantized frontier-class models (which are 200B+ dense or 600B+ MoE), but it's overkill for models that fit on a 24GB card. The sweet spot is specifically models between ~40GB and ~90GB in VRAM footprint.

**3. Price-performance is unfavorable vs multi-3090.**
$8,000 buys you one 96GB GPU. The same money buys 10-13 used RTX 3090s at $600-700 each, giving you 240-312 GB of total VRAM. Yes, multi-GPU has communication overhead, but for batch inference or running multiple models simultaneously, the raw VRAM-per-dollar of used 3090s is ~4× better.

**4. Token generation speed on dense models is bandwidth-limited, not exceptional.**
70B Q4_K_M at 34 t/s on the 6000 Pro vs ~8 t/s on a single 3090 (can't fit fully, needs partial CPU offload) vs ~17 t/s on 2×3090 with NVLink. The 6000 is 2× faster than the NVLink pair — but costs 6× more. The bandwidth advantage of GDDR7 (1,792 GB/s) over GDDR6X (936 GB/s) is ~1.9×, which almost exactly matches the ~2× throughput difference. No magic here — you're paying for bandwidth.

**5. The 600W TDP is no joke.**
GamersNexus measured GPU core at 82°C and VRAM at 88°C under load (vs 72°C/90°C for a 5090). You need a proper workstation chassis with good airflow. The Max-Q edition at 300W is more practical but trades some compute performance (negligible for inference, as shown above). Still, sustained 600W in a desktop requires attention to cooling and PSU capacity.

---

## RTX 3090: The Case

### Specs

- **GPU:** GA102 (Ampere), 10,496 CUDA cores, 328 3rd-gen Tensor Cores
- **VRAM:** 24GB GDDR6X, 384-bit bus
- **Bandwidth:** 936 GB/s
- **TDP:** 350W (can be undervolted to 200-250W for inference)
- **Price:** ~$600-700 used (eBay, 2026)

### Evidence FOR

**1. VRAM-per-dollar is still unmatched in 2026.**
24GB for $600-700 used. Nothing else comes close. The RTX 5090 has 32GB for $2,000-3,500 (street). The 4090 has 24GB for ~$1,600. Two 3090s ($1,200-1,400) give you 48GB of VRAM for less than one 4090.
- Source: XDA Developers article (Feb 2026): "The RTX 3090 nails the performance and VRAM sweet spot... You can buy two RTX 3090s for less than the price of a single used RTX 5090."

**2. Software ecosystem is the most mature.**
Five years of community optimization. Every framework, every quantization format, every inference engine works out of the box. No rebuilding CUDA libraries. No hunting for compute capability flags. "Switch back to the 3090 and everything just works beautifully" is a recurring sentiment.

**3. Practical local LLM performance is well-documented.**
- Llama 70B Q4: ~42 t/s on a single 3090 per one benchmark site (localaimaster.com, likely with partial CPU offload or generous measurement), more conservatively ~8-10 t/s with aggressive quantization that fits in 24GB.
- Dual 3090 setup (r/LocalLLaMA, Jul 2025): ~1000 pp512 / ~100 tg128 on Qwen3-30B-A3B Q4_K_M. That's fast enough for agentic coding.
- Models up to ~14B at high quantization fit comfortably with room for context.
- MoE models like Qwen3-30B-A3B (17GB Q4) are the 3090's sweet spot — fits on one card, fast inference.

**4. NVLink support (unique among consumer cards) is a genuine advantage.**
The 3090 is the last consumer NVIDIA GPU that supports NVLink. Two 3090s with an NVLink bridge see ~50% improvement in tensor-parallel inference over PCIe-only. This is a real, measured advantage for running models that span two cards. 4090s don't have NVLink.

**5. Power efficiency is surprisingly good when undervolted.**
Users report undervolting to 200-250W with minimal performance loss for inference workloads (which are memory-bound, not compute-bound). At 200W × 2 cards = 400W total, a dual 3090 setup draws less than a single RTX 6000 Pro workstation edition.

### Evidence AGAINST

**1. 24GB is the hard ceiling, and it's increasingly tight.**
Qwen3.5-27B at Q4 is ~16GB — fits, but leaves limited room for KV cache / context. Qwen3.5-122B-A10B at Q4 is ~70GB — impossible on one card, needs 3+ cards. As model sizes grow, 24GB becomes more limiting. Multi-card setups add complexity, noise, power, and inter-GPU latency.

**2. Used hardware carries risk.**
Many 3090s available are ex-mining cards. No warranty in most cases (or 3-6 months at best). One user notes needing a "$40 Noctua fan upgrade" for thermals. Some thermal pad degradation after years of mining. Risk is manageable but nonzero.

**3. Multi-GPU is not seamless.**
PCIe topology matters. One user reports one GPU on PCIe 3.0 x16, the other on PCIe 3.0 x4, capping inter-GPU bandwidth at 8 GB/s. Motherboard selection matters. NVLink bridges for 3090 are expensive ($150-250) and require a 3-slot bridge (not the common 2-slot). Not all motherboards have the right slot spacing. Quad 3090 setups need serious power delivery (1400W+) and specialized cases.

**4. No FP8/FP4 hardware support.**
Blackwell's hardware FP4 and FP8 support enables native low-precision inference that can double or quadruple throughput for compatible models. The 3090's Ampere architecture only supports FP16/BF16 natively. This becomes increasingly relevant as model quantization formats evolve.

**5. Older architectural features mean slower prompt processing.**
3090: ~2,800 pp512 on Llama 7B Q4 (estimated from bandwidth ratio). 6000 Pro: 16,634 pp512 on same model. That's roughly 6× faster prefill. For agentic workloads with large context windows and frequent re-prompting, this matters a lot.

---

## Head-to-Head Comparison

| Factor | RTX 6000 Pro Blackwell | RTX 3090 (used) |
|--------|----------------------|-----------------|
| **Price** | ~$8,000 | ~$600-700 |
| **VRAM** | 96GB | 24GB (48GB with 2 cards) |
| **Bandwidth** | 1,792 GB/s | 936 GB/s |
| **tg128 (70B Q4)** | ~34 t/s | ~8-10 t/s (1 card) / ~17 t/s (2× NVLink) |
| **tg128 (30B MoE Q4)** | ~252 t/s | ~100 t/s |
| **pp512 (7B Q4)** | 16,634 t/s | ~3,000-4,000 t/s (est.) |
| **TDP** | 600W (300W Max-Q) | 350W (200W undervolted) |
| **Software maturity** | Catching up (compute cap 12.0) | Fully mature |
| **VRAM/dollar** | $83/GB | $25-29/GB |
| **Max model (single GPU)** | ~70B Q4 dense, 122B MoE Q4 | ~14B Q4 dense, 30B MoE Q4 |
| **FP4 hardware** | Yes (NVFP4) | No |
| **NVLink** | No (PCIe only) | Yes (last consumer GPU) |

---

## Verdict

**The HN thread's claim that the 6000 Pro is "the serious option" is correct — but with a major asterisk.** It's serious for people who need to run models in the 40-90GB VRAM range on a single card with minimal fuss. That's specifically: 70B dense models at useful quantization, or 100B+ MoE models. The single-GPU simplicity eliminates multi-card headaches (PCIe topology, NVLink bridges, power delivery, cooling). For MoE models specifically, the 6000 Pro is spectacular — lots of VRAM for inactive experts, fast bandwidth for active params.

**The 3090's "budget entry point" framing undersells it.** For models that fit in 24GB (≤14B dense, ≤30B MoE at Q4), the 3090 delivers 80-90% of the practical experience at 8-12% of the cost. The software maturity advantage is real and saves hours/days of debugging. A dual 3090 setup with NVLink ($1,400-1,650 all-in) handles 70B Q4 at ~17 t/s — slower than the 6000 Pro's ~34 t/s, but at 20% of the price.

**The non-obvious insight:** The right comparison isn't 6000 Pro vs 3090 — it's "one 6000 Pro" vs "the hybrid approach" (local 3090 for bounded tasks + cloud API for hard tasks). At $8,000, the 6000 Pro needs to recoup its cost against API spend. At Sonnet 4.5 pricing ($18/M tokens total), $8,000 buys ~444M tokens — roughly 2-5 years of heavy personal use. The calculus favors the 6000 Pro only if you have (a) privacy/sovereignty requirements, (b) sustained heavy usage, or (c) need to run models that don't exist as APIs.

**Who should buy what:**
- **3090 ($600-700):** Hobbyists, learners, anyone whose primary models are ≤30B MoE or ≤14B dense. Best value in the market, full stop.
- **2×3090 + NVLink ($1,400-1,650):** Sweet spot for 70B Q4 on a budget. Requires compatible motherboard and PSU research.
- **6000 Pro ($8,000):** Professionals running 70B+ dense or 100B+ MoE models daily with privacy requirements. Must use Linux for best results. Software maturity is now acceptable but not seamless.
- **Neither — use APIs:** If you don't have privacy requirements and your usage is <$200/month in API costs, hardware ROI doesn't work out for years.
