← [Index](../README.md)

# HN Thread Distillation: "Asahi Linux Progress Report: Linux 6.19"

**Source:** [HN thread](https://news.ycombinator.com/item?id=47059275) (452 points, 174 comments, 120 unique authors) · [Article](https://asahilinux.org/2026/02/progress-report-6-19/) · 2026-02-18

**Article summary:** The Asahi Linux project's latest progress report announces USB-C DisplayPort Alt Mode (experimental), preliminary M3 support (keyboard/touchpad/WiFi/NVMe/USB3 working), 120Hz on MacBook Pro panels via a clever timestamp hack, major DCP display driver refactoring enabling HDR/VRR/overlay groundwork, a five-bug cascade fix for webcams spanning Mesa/PipeWire/kernel, GPU driver upstreaming beginning (21,000 lines), and significant memory copy/clear performance optimizations.

## Dominant Sentiment: Reverent admiration tempered by existential doubt

The thread splits cleanly between people marveling at the technical achievement and people asking whether the entire project is a Sisyphean exercise against Apple's proprietary moat. The admiration is genuine; the doubt is structural, not personal.

## Key Insights

### 1. The acceleration curve the thread doesn't see

Most commenters frame Asahi as "five years and M1 still isn't done." The article tells a different story: M3 went from zero to Arch-beta-equivalent (keyboard, touchpad, WiFi, NVMe, USB3) in a matter of months, driven by *three new contributors* who stepped up independently. The downstream patch count dropped 30% (1232→858) in 12 months. The infrastructure is compounding — each generation requires less reverse engineering because the platform abstractions, tooling, and upstream presence already exist. The "Sisyphean" framing confuses startup cost with marginal cost.

### 2. The five-bug cascade is the article's buried lede

The webcam section documents a bug chain spanning four projects: Mesa's OpenGL driver mishandled planar video formats → Honeykrisp misreported plane counts → PipeWire's GStreamer code had an integer overflow → PipeWire's latency calculation assumed period numerator of 1 (Apple uses 256/7680) → the GPU kernel driver deadlocked on DMA-BUF imports. Five bugs, four codebases, each hidden behind the one above it. This is the most honest depiction of systems-level Linux development you'll find in a blog post, and the thread completely ignores it. The real insight: Asahi's value isn't just "Linux on Mac" — it's the forcing function that finds and fixes cross-project bugs nobody else triggers.

### 3. The bootloader openness is security strategy, not altruism

The thread's "does Apple care?" subthread is well-trodden, but [wpm] nails the structural argument everyone else dances around: *"The happy path on the Mac was provided so the talent capable of booting Linux on it could take the happy path that hides all of the stuff Apple would rather not have a bunch of reverse engineers sniffing around."* The Mac and iOS share a boot chain. If Apple locked Macs down, the people capable of running Asahi would instead jailbreak the boot chain — exposing vulnerabilities Apple needs locked for the App Store's 15-30% cut. The open bootloader is a containment strategy. [amelius]'s "honeypot" framing is cynical but directionally correct; [Bigpet]'s XenoKovah tweet predates Asahi, suggesting the decision was about general-purpose boot flexibility rather than Asahi specifically.

### 4. The 120Hz timestamp hack reveals DCP's design philosophy

Oliver Bestmann discovered that DCP refuses >60Hz without three presentation timestamp fields, found they're for VRR frame pacing, and then — in a move the article beautifully describes as "sometimes doing something stupid is actually very smart" — stuffed static values into all three. It worked. This tells us something important about Apple's display firmware: VRR isn't optional infrastructure that 120Hz happens to use — it's the *only* path to high refresh rates. Apple designed for dynamic refresh from the ground up and has no fixed-rate fast path. This has implications for how the eventual proper implementation must work.

### 5. The "don't buy a Mac" argument is stuck in 2020

[WD-42]'s "if you care about Linux, don't buy a Mac" triggers the thread's longest subthread. The counterarguments ([gf000], [_ph_], [cardanome], [logicprog]) boil down to: nothing else combines Apple's build quality, battery life, and silence. [array_key_first] makes a reasonable case for Intel Lunar Lake closing the efficiency gap, and [imiric] reports 12 hours on an X1 Carbon Gen 13. But the interesting dynamic is [rowanG077]'s reframe: *"This reasoning is essentially just as true for any other laptop maker... Dell, Lenovo, Asus, Framework, HP etc might also decide to bomb linux support at any time."* The notion that buying non-Apple hardware guarantees Linux support is a comfortable fiction. x86 Linux support exists because of market accidents, not vendor commitments.

### 6. The used M1 market is forming but geographically fragmented

[haunter] reports buying a 16GB M1 in Hungary for €230; [joe_mamba] can't find one under €400 in neighboring Austria. The price differential is large enough to suggest the secondary M1 market hasn't rationalized yet. [gr4vityWall]'s prediction that M1/M2 machines become "the new ThinkPad T420" is appealing but has a structural flaw that [Tuna-Fish] identifies: soldered SSDs with finite write cycles make longevity a gamble, and [agildehaus] adds that keyboard failure means an $800 top-cover replacement. The ThinkPad's charm was user-serviceable parts; the M1's charm is performance-per-watt. These are different value propositions that attract different secondary markets.

### 7. The GPU upstreaming is the real political test

The GPU driver is 21,000 lines — double DCP, triple the ISP driver. The DRM maintainers already granted an unusual concession (UAPI headers without accompanying driver), and Janne is now submitting IGT test patches as groundwork. But the thread doesn't discuss what will actually be hard: review capacity. A 21,000-line driver from a reverse-engineering project, partially in Rust, touching DRM subsystems, will face intense scrutiny. The Asahi team knows this ("we expect the review process to take quite some time"), and the downstream-to-upstream patch reduction (95K→83K lines, only 15% despite 30% fewer patches) hints at how much large-driver code remains.

### 8. Battery life is the adoption gate, and both sides exaggerate

[tmikaeld] calls Asahi battery life "abysmal"; [cromka] counters with 8 hours on an M1 Air at 80% battery health. [testing22321] resolves it correctly: "Abysmal by macOS on M-series standards, pretty decent by everything else standards." [neobrain], an actual daily driver user, says it's "still long enough that I don't have to think about it (which I can't say about any x86 laptops)." The real dynamic: Asahi's battery life is *good enough* for people who've made the commitment, but *not good enough* for the aspirational users waiting on the sidelines like [Noaidi] ("my M1 is just waiting to install once battery life meets my needs"). The gap is emotional, not functional.

## Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Apple could lock this down tomorrow" | Weak | They've had 5 years and actively chose not to. The boot chain sharing argument explains why. |
| "Just buy a ThinkPad / x86 laptop" | Medium | Intel Lunar Lake is genuinely closing the gap, but no x86 laptop matches the total M-series package yet. More honest than 2 years ago. |
| "Soldered SSDs mean limited lifespan" | Medium | Real concern for longevity, but resoldering services are emerging. Timeline matters: will SSDs fail before machines are obsolete? Probably not for most users. |
| "This is Sisyphean — they'll never catch up" | Misapplied | Confuses the M1 bootstrap (hard) with subsequent generations (compounding). M3 basic support arrived via new contributors in months. |
| "AI agents should do this work" | Weak | [znnajdla]'s suggestion mistakes architectural reverse engineering for brute-force search. The webcam bug cascade alone required understanding five codebases' design intent. |

## What the Thread Misses

- **Asahi as ARM Linux ecosystem catalyst.** The article documents fixes to Mesa, PipeWire, GStreamer, and the DRM subsystem — none Apple-specific. Asahi is the highest-stress test of AArch64 desktop Linux that exists. The bug fixes it forces benefit every ARM Linux user, including Qualcomm laptop owners and Raspberry Pi desktop users. Nobody in the thread frames it this way.
- **The DCP Rust rewrite decision.** The article mentions planning a Rust rewrite of the DCP driver but explicitly choosing to push forward in C rather than wait for Rust KMS bindings. This is a significant strategic call — the Rust-in-kernel movement's slow upstream progress is now directly shaping Asahi's architecture decisions, and neither the article nor the thread explores the implications.
- **Apple's compressed framebuffer format.** Oliver's reverse engineering of the "Apple Interchange" format and Lina's observation that macOS uses shaders to decompress it suggest some AGX variants may lack hardware support. If confirmed, this has GPU driver architecture implications that extend beyond Asahi to anyone doing Apple Silicon GPU research.
- **The M4 boot change.** [monocasa] drops a crucial detail — M4 forces a choice between Apple's page table monitor in guarded mode or all Apple extensions disabled — and nobody follows up. This is potentially the biggest threat to future Asahi generations and deserves far more discussion.

## Verdict

The thread treats Asahi as a story about a small team versus a giant corporation, but the article reveals it's become something else: a systems-integration project whose primary output isn't "Linux on Mac" but upstream Linux improvements that wouldn't exist otherwise. The 30% patch reduction, the five-bug webcam cascade, the DRM test suite patches — these are the marks of a project transitioning from heroic reverse engineering to infrastructure. The thread's existential anxiety about "keeping up with Apple" misses that Asahi has already achieved something no amount of catching up could: it made AArch64 desktop Linux real enough that other people started fixing their own bugs. The question isn't whether Asahi will ever be "done" — it's whether the ecosystem it catalyzed becomes self-sustaining before the core contributors burn out.
