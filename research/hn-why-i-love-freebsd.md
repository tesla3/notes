← [Index](../README.md)

## HN Thread Distillation: "Why I love FreeBSD"

**Source:** [HN thread](https://news.ycombinator.com/item?id=47397574) (466 pts, 228 comments, 126 unique authors) · [Article](https://it-notes.dragas.net/2026/03/16/why-i-love-freebsd/)

**Article summary:** A 20+ year FreeBSD user writes a love letter to the OS, praising its documentation (the Handbook), stability ("evolution, not revolution"), jails, ZFS, bhyve, and above all its community. He acknowledges FreeBSD left his desktop for Mac due to hardware gaps but insists it remains his first choice for servers. The core evidence is personal experience from 2002 — compiling KDE on a Sony Vaio, better thermal behavior, no crashes. When `shevy-java` challenges the performance claims, the author (`draga79`) clarifies: "those experiences are from 2002 and I was writing about my first experience when running it on my Sony Vaio. Running on a modern 64GB RAM hardware is a totally different experience, 24 years later." The article is sentimental, not analytical — it bundles "I love FreeBSD" with "FreeBSD is objectively better" but the evidence only supports the former.

### Dominant Sentiment: Enthusiastic validation with known tradeoffs

The thread is overwhelmingly positive — veterans sharing uptime numbers and operational experience, newcomers asking how to get started. But the most technically substantive exchanges are the ones mapping where FreeBSD genuinely excels, where it doesn't, and what the workarounds are. The warmth is real; the friction is acknowledged without despair.

### Key Insights

**1. Docker is the real moat — and it's an ecosystem problem, not a technical one**

The thread's clearest signal. Multiple commenters (stego-tech, CodeCompost, Hendrikto, whizzter, chillfox) want FreeBSD but keep hitting the Docker wall. Jails predate Docker by 13 years and provide better isolation, but that's not the point.

`st3fan` delivers the star comment: "People comparing Docker and Jails don't really understand that Docker is 99% about packaging and composing software. From that perspective Jails are nothing like Docker containers. No versioning, no standard, no registry, no compose, no healthchecks, no tree of containers."

This reframes the entire jails-vs-Docker debate. The gap isn't in containerization technology — it's in the packaging ecosystem built on top. `overfeed` reinforces: "Better isolation, better security, but far fewer gists and shared config-files shared on the Internet for common tasks. Docker comprehensively won the popularity contest." Nobody in the thread has a convincing answer to this.

**2. bhyve as hypervisor host is a legitimate architecture, not a concession**

The instinctive reaction — running a whole second OS for containers seems absurd — is wrong. Multiple commenters treat FreeBSD-as-host + Linux-VMs-for-containers as a deliberate architectural choice:

- `vermaden` provides a complete bhyve guide, notes overhead is ~0.5%
- `TacticalCoder`: "I run Docker on my Linux servers *inside a VM*. There's no way I let Docker touch the bare metal, not with a ten foot pole."
- macOS does exactly this — Docker Desktop runs a Linux VM

This is the practical resolution to insight #1: you don't fight the Docker ecosystem, you host it on a stable FreeBSD hypervisor. `frumplestlatz` suggests making this seamless: "ideally we could get docker on FreeBSD using the same approach as is used on macOS — automatically run Linux VMs under bhyve." The linuxulator (Linux syscall compatibility) is an alternative path but unreliable for complex workloads — `sidkshatriya`: "some syscalls not implemented, there are edge case issues with procfs. Best to execute in a Linux VM." `whizzter` flags a forward-looking concern: as Linux runtimes adopt io_uring, the linuxulator gap may widen, reinforcing the VM approach.

**3. The "set and forget" server niche is real and well-evidenced**

The thread's strongest empirical claims, from multiple independent sources:

- `AdieuToLogic`: ~3000 days (~8 years) without rebooting production servers, including applying userland patches
- `doublerabbit`: 1752 days uptime on colocated Dell and Cisco hardware
- `blackhaz`: 1707 days on a DigitalOcean droplet
- `adrian_b`: FreeBSD admin overhead compares to Linux as Linux compares to Windows — servers untouched for years running firewalls, DNS, email, web

`adiabatichottub` crystallizes the value proposition: "If you want to run a mail server for 20 years and go through multiple hardware and OS upgrades with minimal pain and maximal uptime then you can't beat it." `krylon` upgraded from 14 to 15 last weekend: "it left me wondering why I hadn't done it sooner, because it went quickly and smoothly." This is not nostalgia — these are current, running systems.

**4. ZFS advantage has shifted from exclusive to integrated**

`znpy` states a fact many commenters seem unaware of: "the zfs in freebsd and in linux are the same codebase. Literally. It's OpenZFS." FreeBSD even imported the OpenZFS implementation, replacing its own, because they couldn't keep up with development pace.

The remaining FreeBSD advantage is integration, not the filesystem:
- Native boot environments via `bectl` — `evanjrowley` provides an excellent survey of Linux alternatives (btrfs+snapper, ostree, NixOS generations, bootable containers, etc.) and concludes that only OpenSUSE and Red Hat approaches let you treat system images and data the same way, and "capabilities of both approaches are limited compared to ZFS"
- ARC integrated directly with the VM subsystem vs. Linux's shrinker API, which `atmosx` notes "has historically been a problem" leading to OOMs (though `grahamjperrin` asks whether this is still current)
- ZFS boot environments available since 2008 on FreeBSD/Solaris

But Linux is converging: `grahamjperrin` reports Ubuntu now has encrypted root-on-ZFS from its installer — something FreeBSD can't yet do (bug #263171). The first-mover advantage is real but narrowing.

**5. Hardware support is a structural gap, not a solvable bug**

The thread's sharpest irony, from `crdrost`: WiFi problems drove people from Windows to Linux 20 years ago; now the same problems drive people from FreeBSD to Linux. `Gud` is blunter: "Linux had better WiFi 20 years ago than FreeBSD has today. I still prefer FreeBSD."

Specific gaps named: WiFi (`SanjayMehta`, `jdefr89`), sleep/suspend (`smm11`), RDNA4 GPUs (`badgersnake`), CUDA/ROCm (`MrResearcher` — zero substantive replies). `adrian_b` explains the root cause: Linux has a massive database of hardware bug workarounds accumulated through user-base size — vendors write Windows drivers with built-in workarounds and don't document the bugs, so other OSes must reverse-engineer them. "Here Linux has the advantage of a much greater user base than any alternative." This is self-reinforcing and won't be solved by FreeBSD effort alone.

Counter-evidence: `nesarkvechnep` runs Sway on FreeBSD daily, finding it "way snappier and sharper than on any Linux distro." `burner420042` just installed FreeBSD 15 on a T480 and is investigating battery life. Modern laptops aren't hopeless — but it's per-model luck, not systematic support.

**6. Documentation quality is genuinely contested**

The article opens with the Handbook and many commenters echo the praise. But `grahamjperrin` — a former FreeBSD doc tree committer — pushes back with specifics: the ZFS chapter "telling people to do the WRONG thing," the ports chapter "wrongly updated," too few doc committers, stalled translations. He bluntly states: "Documentation certainly is not gold standard."

`AdieuToLogic` rebuts directly, citing the Handbook, Porter's Handbook, Developer's Handbook, and McKusick's design book: "I stand by my statement that the cited FreeBSD resources are 'a gold standard' while acknowledging they are not perfect. What they are, again in my humble opinion, is vastly superior to what I have found to exist in the Linux world."

The resolution: FreeBSD's *structural* documentation (handbooks, man pages, unified style) is better than most Linux distributions. But the *maintenance* of that documentation has quality issues from too few contributors. `gzread` offers the best explanation: "I wonder if this is a curse of popularity. Presumably the documentation is stable and good because the software is also stable." The stability that makes docs possible also means fewer people rotating through to catch errors.

**7. The network stack: mostly solid, with specific failure modes**

`commandersaki` ran FreeBSD colocated for a decade with persistent mbuf exhaustion on Intel NICs. `kalleboo` couldn't push past 5Gbps on 10G NICs, immediately got 9Gbps on Linux.

But the counterweight is substantial:
- `kev009`, who volunteers as maintainer of several Intel NIC drivers, says "as of FreeBSD 12-13 most major issues are addressed from 1gig up to current 100g"
- `adrian_b` has used Intel NICs on Supermicro for 30 years without these problems
- `doublerabbit`: "Network has been solid" across Dell and Cisco servers since FreeBSD 8

On the mbuf issue specifically: `commandersaki`'s four supporting links are all pfSense/OPNsense (pf firewall). `adrian_b` correctly identifies this — "all your links show such a problem caused by the same application, the firewall pf." The mbuf problem appears to be pf-specific, not a general network stack issue. With the native FreeBSD firewall (ipfw), adrian_b has never seen buffer exhaustion. This matters: the network stack's reputation is being shaped partly by pf's resource consumption patterns, not by the stack itself.

**8. New users are actually showing up**

The thread isn't just veterans reminiscing. Active newcomers and returners:
- `stego-tech` plans to install FreeBSD on a second NUC for jails
- `Hendrikto` set up a FreeBSD home server a week ago
- `hedora` is a "Linux refugee" planning 5-10 FreeBSD cattle servers
- `burner420042` just installed FreeBSD 15
- `w4rh4wk5` asking how to get started, specifically about Wayland
- `olivierestsage`: "This post rekindles the flame"

The typical path: experienced Linux sysadmin, frustrated by complexity/systemd/Docker, drawn to FreeBSD's simplicity and jails. `stego-tech` captures the motivation: "for two years now, there's been a pretty consistent campaign of love-letters for the BSDs that keep tugging at what I love about technology: that the whole point was to enable you to *spend more time living*, rather than wrangling what a computer does."

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Just run Linux in bhyve" for Docker | Strong | 0.5% overhead, proven architecture, same approach as Docker Desktop on macOS |
| "Jails are better than Docker" | Misapplied | True for isolation; irrelevant to the packaging ecosystem (`st3fan`) |
| "FreeBSD docs are gold standard" | Contested | Defended by current users, challenged by a former doc committer with specifics |
| "Hardware bugs are vendor's fault" | Medium | True root cause, but the practical consequence is identical |
| "Network stack has problems" | Narrow | Strongest evidence is pf-specific; general stack has strong defenders with credentials |

### What the Thread Misses

- **The article's evidence doesn't support its implicit thesis.** The piece reads as "FreeBSD is better than Linux" but the evidence is personal anecdote from 2002. The author switched his own desktop to Mac. `shevy-java` invokes the "worse is better" framework (jwz) — Linux's chaotic ecosystem wins through volume and coverage, not elegance — and the thread largely validates this without anyone naming the pattern explicitly.
- **Rust in the FreeBSD kernel.** `waynesonfire` raises it, `grahamjperrin` provides context on active Rust KPI development for 2026. This is a live tension between FreeBSD's conservative philosophy and the modernization pressure that the thread's stability-loving commenters should care about but don't engage with.
- **Who's funding FreeBSD development?** The article praises the Foundation. Netflix is mentioned once. But the thread doesn't examine whether the funding and contributor base can sustain the project's ambitions — only that the current product works well for current users.
- **The "worse is better" dynamic is the thread's unspoken framework.** FreeBSD is the MIT/Stanford approach, Linux is the New Jersey approach. The thread demonstrates both sides: FreeBSD's coherence and elegance vs. Linux's messy but comprehensive coverage. `joshstrange`'s "death by a thousand papercuts" using FreeBSD at work daily is the purest expression of "worse is better" winning — individually each cut is trivial, collectively they drive people to the messier but better-supported system.

### Verdict

FreeBSD's "set and forget" server niche is real, well-evidenced, and currently healthy — not just nostalgia but active deployments with multi-year uptimes and new users arriving from Linux. The Docker ecosystem gap is the single biggest practical barrier, but the bhyve-as-hypervisor approach is a genuine solution, not a copout. The thread's unspoken dynamic is "worse is better": FreeBSD is more coherent, better documented (structurally if not always in maintenance), and simpler to administer — but Linux's chaotic comprehensiveness in hardware support, packaging ecosystems, and community size means that for most people, most of the time, Linux wins by default. FreeBSD doesn't need to beat Linux broadly; it needs its niche to remain viable. The thread suggests it is — with the caveat that the Docker and hardware gaps require workarounds rather than native solutions, and the tolerance for those workarounds is what separates FreeBSD's audience from everyone else.
