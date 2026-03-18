# MacBook Air Upgrade Research

*2026-03-15*

## Current situation

- Intel MacBook Air, still working fine for daily use (Safari + ad blockers + AI chat)
- No urgent need to upgrade today

## 16GB vs 24GB RAM — real-world reports

- **16GB is fine** for browsing, light creative work, single IDE, 80% of users
- **24GB matters** for: Docker (~8GB flat), VMs/Parallels, 30+ browser tabs + heavy app, Figma + Chrome, local LLMs, longer video editing, GPU-heavy tasks (GPU shares the unified memory pool)
- macOS memory compression + fast SSD swap makes 16GB stretch further than on Windows/Linux
- Activity Monitor raw numbers are misleading — check memory *pressure* (green/yellow/red), not usage
- Can't upgrade RAM later; $200 upgrade is cheap insurance on a $1200+ machine

## Models considered

| Model | Price (refurb) | Notes |
|---|---|---|
| 13" M4 Air 24GB/512GB | $1,019 | Lighter (1.24kg), more portable |
| 15" M4 Air 24GB/512GB | $1,189 | Better screen/speakers, same chip |

- Identical specs except screen size (13.6" vs 15.3"), speakers (4 vs 6), weight (270g difference)
- 15" worth it if laptop screen is primary display; 13" if docking to external monitor
- For light browsing/chat use case, 13" is the smarter pick

## Buy now vs wait

- **Wait wins.** Current Intel Air is still functional. More machine/$ over time
- Worry about geopolitical disruption (Iran, memory prices) is mostly overblown:
  - Apple pre-negotiates component prices years out
  - ~$160B cash reserves to absorb cost shocks
  - Iran is not a semiconductor node (Taiwan/TSMC is the real risk)
  - Even during COVID, Apple held pricing — only delivery times and refurb stock were affected
  - Memory prices are cyclical, spikes correct
- The smart move: buy calmly before being forced to, not in reaction to speculation

## Intel Mac end-of-life timeline

1. Apple drops macOS support (1-2 releases away)
2. Safari and browsers stop updating on old macOS
3. Ad blockers (AdGuard, uBlock) stop working against evolving ads
4. Web apps use APIs old browsers don't support
5. Security patches stop

- It's a slow fade, not sudden death — **2-3 usable years** likely remain even after macOS drops support
- Firefox supports older macOS longer than Chrome/Safari
- The trigger to buy: when browser can't handle sites properly or ad blockers stop updating

## Decision

Wait. Buy when the Intel Mac starts failing at its actual job (browsing + chat). Watch for refurb M4/M5 Air deals when the time comes.
