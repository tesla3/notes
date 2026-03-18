# MacBook Air 15" Buying Guide — March 2026

## Current Machine
- MacBook Air 13" (Early 2020) — Intel Core i3, 8GB RAM, 256GB SSD
- Battery: 424 cycles, 80% capacity (3508/4381 mAh)
- macOS Sequoia 15.7.4 — **last supported macOS** (won't get Tahoe)
- Craigslist listing drafted at **$225** (fair market $175–$225)

---

## Final Three Options

| | M4 16/256 | M4 24/512 | M5 16/512 |
|---|---|---|---|
| Price | **$999** | $1,299 | $1,249 |
| CPU | 10-core M4 | 10-core M4 | 10-core M5 (~15% faster) |
| GPU | 10-core M4 | 10-core M4 | 10-core M5 (~30-50% faster) |
| RAM | 16GB | **24GB** | 16GB |
| Storage | **256GB** | 512GB | 512GB |
| AI (TTFT) | Baseline | Baseline | **3.3–4x faster** |
| Memory BW | 120 GB/s | 120 GB/s | **153 GB/s (+28%)** |
| Wi-Fi | 6E | 6E | **7 + Bluetooth 6** |
| SSD speed | Standard | Standard | **2x faster** |
| macOS support | ~6 yrs | ~6 yrs | **~7 yrs** |

### Verdict
- **M4 16/256 ($999): Eliminated.** 256GB is a deal-breaker for a 5-year machine. ~180GB usable after OS + apps.
- **M4 24/512 ($1,299): Best for** heavy multitaskers, developers (Docker + IDE + browser), local AI (14B+ models).
- **M5 16/512 ($1,249): Best for** most people. Six improvements (CPU, GPU, AI, SSD, Wi-Fi, OS support) vs one (RAM). $50 cheaper.

---

## Key Research Findings

### M5 vs M4 Performance (measured, sourced)

**Source: Apple ML Research blog** — MacBook Pro M5 vs M4, base chips, MLX framework, 4096-token prompt.
Same memory bandwidth as Air models (M4=120 GB/s, M5=153 GB/s). TTFT is short burst (applies to Air). Sustained generation may differ ~5-10% due to Air's fanless throttling.

| Model | TTFT Speedup | Generation Speedup | RAM needed |
|-------|-------------|-------------------|-----------|
| Qwen3-1.7B BF16 | 3.57x | 1.27x (27%) | 4.40 GB |
| Qwen3-8B 4-bit | 3.97x | 1.24x (24%) | 5.61 GB |
| Qwen3-14B 4-bit | 4.06x | 1.19x (19%) | 9.16 GB |
| Qwen3-30B-A3B MoE 4-bit | 3.52x | 1.25x (25%) | 17.31 GB |

Token generation is memory-bandwidth bound (~28% gain tracks bandwidth delta). TTFT is compute-bound (Neural Accelerators give 3.3–4x).

**Source: Tom's Guide** — MacBook Air 15" M5 vs M4, lab tested.

| Test | M4 Air | M5 Air | Difference |
|------|--------|--------|------------|
| Geekbench 6 Multi | 14,921 | 17,276 | +16% |
| Handbrake 4K→1080p | 4:57 | 4:34 | 23 sec faster (~8%) |
| Photoshop score | 10,185 | 11,865 | +16% |
| Photoshop time | 12.05 min | 9.14 min | ~3 min faster (24%) |
| SSD read/write | ~3,300 MB/s | ~6,700 MB/s | 2x faster |

**Source: Apple press release** — M5 vs M4 Air claims.
- Blender ray tracing: 1.5x faster
- Affinity image processing: 1.5x faster
- FLUX image generation (1024x1024): 3.8x faster

### Everyday tasks: M5 vs M4
Browsing, email, docs, streaming — **imperceptible difference**. Both are 3-4x faster than current Intel i3.

### Gaming (M5 vs M4, various sources)
- Resident Evil Village: 82 fps vs 51 fps (M5 vs M4 at 1440p)
- Baldur's Gate 3: 68 fps vs 43 fps
- AC Shadows / Cyberpunk at 1200p medium: below 30 fps on both

### Throttling (both Air models)
Both are fanless. Under sustained all-core load, both throttle similarly. Short bursts (TTFT, app launch, quick exports) run at peak. Multi-minute renders/encodes throttle to same thermal envelope. Ars Technica: *"the M1 MacBook Air and M5 MacBook Air don't behave exactly the same under load, but the curves have a pretty similar shape."*

---

## 16GB vs 24GB RAM Evidence

### No controlled benchmarks exist
RAM doesn't make tasks faster when it fits — it prevents slowdowns when it doesn't. The difference is binary (fits vs swaps), not a percentage.

### Real user memory usage data

| Workload | RAM used | Swap? | Pressure |
|----------|---------|-------|----------|
| 50 Chrome tabs (24GB Air) | ~18GB | None | Green |
| Lightroom + Capture One + few tabs (24GB) | <24GB | None | Green |
| 25 tabs + Lightroom + Capture One (24GB) | >24GB | Begins | Yellow |
| YT + tabs + light photo/video editing (16GB) | >16GB | Yes | Orange |
| 4K video editing in Resolve (tested) | ~19GB | Heavy on 16GB | Red on 16GB |
| Unity + VS + Adobe + Xcode + FCP (24GB Pro) | 21GB | 8-13GB | Yellow/Red |
| Xcode alone (16GB) | <16GB | None | Green |
| Docker + IDE + browser + Slack (16GB) | >16GB | Yes | Yellow |

### What fits where (4-bit quantized LLMs)

| Model | RAM needed | 16GB Mac | 24GB Mac |
|-------|-----------|----------|----------|
| 8B dense | ~5.6 GB | ✅ Comfortable | ✅ |
| 14B dense | ~9.2 GB | ⚠️ Tight (2-3GB left for OS) | ✅ Comfortable |
| 20B dense | ~12 GB | ❌ Swaps heavily | ✅ Fits |
| 30B dense | ~17-18 GB | ❌ Won't run | ⚠️ Tight |

### macOS swap behavior
Light swap (1-2GB) is nearly invisible on Apple Silicon SSDs (~3-6 GB/s). Heavy swap (8GB+) causes sluggish app switching, background app killing, and SSD wear over years.

---

## Other Options Evaluated

### Apple Refurbished (apple.com/shop/refurbished)
- 15" M4 Air 16/256 (10-core GPU): **$929** — cheapest 15" M4, Apple warranty
- 15" M4 Air 16/512 (10-core GPU): **$1,019** — cheaper than Amazon's $1,079

### Used M1/M2 Air: Not recommended
- M1: 1-2 years macOS support left. Poor cost-per-year.
- M2 15" (Craigslist $520): Decent at $450-475. 3-4 years support. But 8GB/256GB base config is limiting.

### Craigslist MBP 16" M1 Pro ($1,100): Overpriced
- eBay sold: $650-800 for same config. Fair CL price: $700-750.

---

## macOS Support Timeline
| Chip | macOS Tahoe (26, current) | Next macOS (27, ~2026) | Expected EOL |
|------|--------------------------|----------------------|-------------|
| Intel i3 (current) | ❌ Not supported | ❌ | Already dead |
| M1 | ✅ | ⚠️ Likely last year | ~2027 |
| M2 | ✅ | ✅ | ~2029 |
| M4 | ✅ | ✅ | ~2031 |
| M5 | ✅ | ✅ | ~2032 |

---

## Where to Buy (March 14, 2026 prices)

| Config | Amazon | Apple Refurb | B&H |
|--------|--------|-------------|-----|
| M4 15" 16/256 10-core | $999 | $929 | — |
| M4 15" 16/512 10-core | $1,079 (Midnight) | $1,019 | $1,079 |
| M4 15" 24/512 10-core | $1,299 | — | — |
| M5 15" 16/512 | $1,249 | Full price | — |
| M5 15" 24/1TB | $1,650 | Full price | — |

M4 clearance prices are temporary — once stock is gone, they're gone. M5 discounts will deepen over the coming months.

---

*Last updated: March 14, 2026*
