← [Index](../README.md)

## HN Thread Distillation: "Can you slim macOS down?"

**Source:** [eclecticlight.co](https://eclecticlight.co/2026/01/21/can-you-slim-macos-down/) | [HN thread](https://news.ycombinator.com/item?id=46702411) (263 pts, 345 comments)

**Article summary:** Howard Oakley examines whether macOS can be stripped of unnecessary processes. He picks Time Machine's `backupd` as a case study: even fully disabled, it still wakes hourly via DAS/CTS, completes in 0.144 seconds, and uses ~5 MB. His conclusion is "no" — the Signed System Volume (SSV) makes system files immutable, DAS/CTS scheduling is opaque and user-inaccessible, and macOS simply isn't built for modularity. He contrasts this with Mac OS 9's component picker.

### Dominant Sentiment: Frustrated agreement, tangential defensiveness

The thread mostly agrees macOS is locked down, but the actual article gets far less attention than two proxy wars it ignites: "is macOS UNIX?" and "why do power users choose macOS over Linux?" Both debates generate more heat than the article warrants.

### Key Insights

**1. The article's own evidence undermines its premise**

Oakley frames 500+ idle processes as concerning, then demonstrates that his exemplar — `backupd` — uses 0.144 seconds per hour and 5 MB of RAM. His article is titled as a question about optimization, but his data shows there's almost nothing to optimize. The thread's sharpest technical voice, `quotemstr`, drives this home:

> "Much harm has arisen out of the superstitious fear of 100% CPU use. Why *wouldn't* you want a compute bound task to use all available compute? It'll finish faster that way. We keep the system responsive with priorities and interactivity-aware thresholds, not by making a scary-looking but innocuous number go down."

`quotemstr` also catches Oakley's naive memory accounting — claiming per-process memory "adds up" when RSS double-counts shared pages. Though `saagarjha` corrects that Activity Monitor actually shows "footprint" (better than RSS), the broader point stands: adding up per-process memory columns to estimate waste is bogus arithmetic. A detailed [anatomy of Activity Monitor](https://www.bazhenov.me/posts/activity-monitor-anatomy/) confirms the underlying complexity.

**2. The author chose to be stymied by the SSV**

`tristor` delivers the hardest hit: Oakley treats SSV as a wall when it can be disabled, calls macOS "not UNIX" when it's literally certified, and never actually explores the question in his title. The Windows modding community (Tiny11, NTLite, Atlas) has long done exactly this kind of work despite similar obstacles. The Mac community hasn't — not because it's impossible, but because its priorities lie elsewhere. `opengears` posts a concrete counterexample: [tahoe-disenshittify](https://github.com/parasew/tahoe-disenshittify), a script that does trim macOS Tahoe with SIP disabled.

**3. The real use case is CI/VMs, not desktop vanity**

The most underserved audience isn't desktop users annoyed by Activity Monitor — it's people running macOS in CI. `egorfine`: "I badly need slimmed down macOS for CI VMs." `big_toast` wants Apple to announce lighter virtualization primitives at WWDC. `egorfine` is actually building Docker-like software for macOS guests — prototype done, no public visibility yet. This is where the bloat *actually* costs money (per-VM resource overhead × fleet scale), and it's almost entirely absent from the article.

**4. "Felt bloat" is the real complaint, and it's a UX failure not a systems failure**

`JSR_FDED` reframes the entire discussion: "If the OS didn't *feel* bloated nobody would care if there were 1000 processes." The irritation comes from unwanted notifications, popups, auto-downloads, and services pushing into the foreground — not from idle daemons. This is an important distinction: the article frames bloat as a systems problem (too many processes), but the actual user pain is a UX boundary problem (the OS won't stay out of your face). Tools like Little Snitch and App Tamer address symptoms, but the root cause is Apple increasingly using the OS as an engagement surface rather than a neutral platform.

**5. The UNIX debate is a tribal identity proxy, not a technical question**

The article's throwaway line — "macOS isn't, and never has been, Unix" — ignites the longest subthread. `pxc` finds that macOS's own UNIX certification requires disabling SIP, which is delicious irony. `spijdar` offers the most clear-eyed take: macOS is UNIX® the way Android is Linux — technically true, practically meaningless for understanding the system's character. The analogy is sharp. `pjmlp` and `7e` defend the certification; `SllX` points out UNIX has been dead since 1988 and the rest is trademark theater. Nobody's mind changes. The debate reveals more about HN's identity politics (BSD heritage = legitimacy) than about macOS's architecture.

**6. The "why macOS?" megathread is a census, not an argument**

Easily 40% of the thread is responses to `sgjohnson`'s question about why power users choose macOS. The answers cluster into: battery life / hardware quality (dominant), "it just works" / no maintenance tax, creative apps (Logic, Photoshop, Affinity), Apple ecosystem lock-in (iCloud, FindMy, Continuity), and 4 modifier keys. `drewg123` (Netflix FreeBSD kernel dev) captures the pragmatic camp: "the macbook is the path of least resistance... it works well as a laptop and comes with a terminal and ssh client that require zero effort." The thread has now fully left the article behind.

**7. The Andy and Bill's Law variant is the sharpest one-liner**

`Flux159`: "What Srouji giveth, Federighi taketh away" — referencing the dynamic where Apple Silicon's efficiency gains get consumed by macOS bloat. This is the thread's only attempt to name the *structural incentive* behind the problem: hardware teams create headroom, software teams fill it, and the user never captures the surplus.

**8. Buggy background processes are the real battery drain, not idle ones**

`kbolino` reports concrete experience: `mds_stores` and `mediaanalysisd` cause case heating on three separate Apple Silicon Macs when plugged in but idle. `crazygringo` confirms: "these processes are all meant to be lightweight, but they're just buggy and end up in bizarre loops." `vlovich123` wonders if there's low-hanging fruit that's simply unowned inside Apple. The issue isn't 500 idle processes — it's 2-3 broken ones that nobody at Apple is actively maintaining.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "macOS IS UNIX, literally certified" | Medium | Factually true, but misses the author's (poorly stated) point about system philosophy |
| "SSV can be disabled, this is intellectually lazy" | Strong | Correct — the article concedes defeat where the Windows community wouldn't |
| "The memory doesn't 'add up' like that" | Strong | `quotemstr`'s RSS critique is valid; `saagarjha` refines it (footprint ≠ RSS) |
| "Who cares, the overhead is trivial" | Medium | True for individual processes, but ignores buggy outliers and CI/VM fleet costs |
| "Just use Linux" | Weak | Tangential; doesn't answer the actual question about macOS |

### What the Thread Misses

- **Apple's incentive structure**: Nobody asks *why* Apple doesn't provide a minimal macOS SKU for VMs/CI. The answer is likely strategic — keeping macOS monolithic protects the ecosystem from fragmentation and maintains leverage over enterprise customers who'd love cheap CI runners.
- **The Hackintosh community's knowledge**: `userbinator` mentions Hackintosh forums as the best source for minimal macOS builds, but this thread of 345 comments doesn't engage with that body of work at all.
- **Comparison with iOS/iPadOS**: Apple already runs stripped-down Darwin variants on other devices. The question isn't whether macOS *can* be slimmed — Apple does it internally — but whether they'll let *you* do it.
- **The security trade-off of SSV removal**: Everyone who suggests disabling SSV glosses over the fact that this eliminates verified boot, making the system vulnerable to persistent rootkits. "Just disable SSV" isn't free.

### Verdict

The article asks a question it's not interested in answering — it's really a meditation on how macOS has become a sealed appliance. The thread confirms this but can't stay focused on it, preferring tribal debates about UNIX identity and platform choice. The actual interesting story is buried: macOS's bloat problem isn't resource consumption (which is negligible for well-behaved processes) but *governance* — unowned background services that go haywire, and an architecture that prevents users from fixing what Apple won't maintain. The people who most need a slim macOS (CI operators) are the least represented in this conversation, and the one person actually building a solution (`egorfine`) has no public channel to announce it. The thread is 345 comments of people arguing about the label on the box while the interesting engineering problem sits unaddressed inside it.
