← [Index](../README.md)

## HN Thread Distillation: "10% of Firefox crashes are caused by bitflips"

**Article summary:** Gabriele Svelto (Mozilla) posted a Mastodon thread describing how he built a heuristic to detect bitflip-related crashes in Firefox telemetry, then deployed an actual post-crash memory tester on user machines. Of ~470,000 crash reports in one week, ~25,000 (5%) were flagged as potential bitflip-caused crashes. He extrapolates this to "up to 10%" via a hand-waved 2x multiplier for the heuristic being conservative.

### Dominant Sentiment: Engineers swapping war stories around a clickbait headline

882 points, 458 comments — but the energy is nostalgia and anecdote-swapping, not alarm. The headline number gives people permission to share their favorite debugging-the-hardware stories. A significant minority pushes back on the methodology. Almost nobody asks "does this matter?"

### Key Insights

**1. The Guild Wars anecdote steals the show — and validates the thesis better than the article does**

The top comment (netcoyote / Patrick Wyatt, ArenaNet co-founder) describes a 2004 system that ran math-heavy computations every frame to detect hardware faults, finding 1-in-1000 computers failed. The causes — overclocked CPUs, bad PSUs, dusty fans, Dell's cheap capacitors — paint a picture of *systemic hardware marginality*, not cosmic rays. This anecdote has better methodology disclosure than the source article and implicitly demonstrates that the problem is real but dominated by garbage-tier hardware, not some unavoidable physics floor.

> "Sometimes I'm amazed that computers even work at all!" — netcoyote

**2. The 10% number is epistemically weak but the phenomenon is real**

The actual measured figure is 5% (25k/470k). The "up to 10%" headline comes from doubling via a "conservative heuristic" with zero methodology disclosure. Several commenters (crazygringo, CamouflagedKiwi, ryukoposting) correctly identify this as marketing-grade inflation. But the *existence* of the problem is well-established — Google's 2009 DRAM study, the Julia/rr debugging story (KenoFischer), adonovan's Go telemetry data showing ~10 inexplicable crashes/week among gopls users, and multiple practitioner anecdotes all converge.

> "So the data actually only supports 5% being caused by bitflips, then there's a magic multiple of 2? Come on." — CamouflagedKiwi

**3. Browsers are disproportionate bitflip detectors — it's a selection effect, not a Firefox problem**

The sharpest analytical insight comes from the thread converging on *why* browsers surface this more than other software: they use enormous amounts of RAM, scatter data across address space, JIT-compile code, and run continuously. As tuetuopay notes, Factorio devs were equally confident enough to tell a user their RAM was bad from a single null-pointer crash. The key framing from WhatsTheBigIdea: if Chrome experiences the same bitflip rate but has 5x fewer software bugs, then bitflips could be 50% of Chrome crashes while only 10% of Firefox's — which would actually be *worse* news for Firefox.

> "If 50% of chrome crashes were due to bit flips... that would indicate that chrome experiences 1/5th the total crashes of firefox... It would have been better news for firefox if the number of crashes due to faulty hardware were actually much higher!" — WhatsTheBigIdea

**4. The ECC debate reveals Intel's market segmentation as the actual villain**

Multiple commenters (loeg, hurfdurf, kmeisthax, lunar_rover) converge on the same structural argument: ECC memory itself isn't expensive (~25% more chips for DDR5), but Intel deliberately stripped it from consumer CPUs to maintain price discrimination between consumer and workstation/server lines. AMD has been better but inconsistent, leaving motherboard vendors to decide support. The thread treats this as settled consensus — the technical barrier is negligible; the barrier is purely commercial.

> "This attitude is entirely corporate-serving cope from Intel to serve market segmentation." — kmeisthax

**5. DDR5's "on-die ECC" is a yield trick, not a reliability feature**

Several knowledgeable commenters (jml7c5, himata4113, kevin_thibedeau, drpixie) explain that DDR5's built-in ECC exists to let manufacturers ship marginal DRAM that would otherwise fail QC. It corrects single-bit errors *within* the chip but cannot detect errors on the bus between RAM and CPU, and provides no error reporting to the OS. As jcalvinowens precisely notes, it can even *miscorrect* double-bit errors into triple-bit errors — though these are mathematically guaranteed to be caught by proper system-level ECC on top. The net result: DDR5 is probably no worse than DDR4 for users, but it's not the reliability upgrade the marketing suggests.

**6. The crash concentration problem makes the headline misleading**

conartist6, fastaguy88, and Neil44 identify the key statistical issue: if a small number of machines with flaky hardware generate a disproportionate share of crash reports, the "10% of crashes" figure vastly overstates the problem for the average user. Without per-machine deduplication (which Svelto admits he hasn't done), the statistic is essentially uninterpretable as a user-facing metric. For a user with good hardware, hardware-caused crashes might be 0/0.

**7. The Go toolchain's parallel investigation adds credibility**

adonovan's detailed account of inexplicable crashes in gopls — corrupt stack pointers, panics after nil checks, crashes in non-memory instructions like `MOV ZR, R1` — provides the strongest independent corroboration. His napkin math estimating the expected rate of hardware-caused crashes aligns with what Mozilla observes. The detail about I-cache being SRAM (potentially *more* fragile than DRAM) is a genuine insight nobody else surfaced.

**8. The overclocker confound is huge and unaddressed**

Modified3019, arprocter, Habgdnv, and several others describe personal experiences where overclocked or XMP-profiled RAM appeared stable but produced intermittent errors only caught by ECC or prolonged testing. The thread never quantifies this, but the implication is that a non-trivial fraction of the "bitflip" population may be self-inflicted overclocking, not intrinsic hardware defects or cosmic rays. Modified3019's observation that DDR5 has much less overclocking headroom and is far more heat-sensitive than previous generations suggests this problem is getting worse.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "If bitflips were this common, all software would crash equally" | Weak | Ignores that crash rate = f(memory footprint, stability). More stable software with larger footprint surfaces more hardware crashes proportionally. |
| "My Firefox never crashes, so this is BS" | Misapplied | Confuses per-user experience with fleet-wide statistics. Most machines are fine; a small number with bad hardware dominate the crash reports. |
| "The methodology is unexplained, so the 10% claim is hollow" | Strong | The heuristic is never disclosed, the 2x multiplier is unjustified, and no per-machine deduplication is done. The 5% measured figure is defensible; the 10% is not. |
| "ECC would fix this" | Medium | Would fix RAM-resident errors but not bus errors, CPU faults, or overclocker-induced instability. Also doesn't help with the ~90% of crashes that are software bugs. |
| "This is just Firefox blaming hardware for their bugs" | Weak | The post-crash memory tester finding bad RAM on 50% of flagged machines is reasonably strong evidence. Multiple independent codebases (Go, Julia, games) report the same phenomenon. |

### What the Thread Misses

- **"So what?"** 470k crashes/week across ~200M monthly users means most users never crash. Of those crashes, 5-10% from hardware is a rounding error per-user. Consumer software doesn't need five 9s, and nobody's life is worse because of this. The thread never interrogates whether the finding is *interesting* vs. *important* — it assumes importance from the excitement.
- **Silent data corruption — the one real tail risk — is a non-issue in practice.** Most files that matter exist in multiple copies: cloud sync, email, bank PDFs, version history. The single-local-copy-gets-silently-corrupted scenario is increasingly fictional.
- **The Rowhammer angle gets one passing mention** (strongpigeon) but no discussion. Firefox executes untrusted JavaScript billions of times daily — some "analog" crashes could be deliberate attacks, not passive degradation. This is the one angle that might actually matter and nobody explores it.

### Verdict

**A nothingburger dressed as a revelation.** The phenomenon is real — bitflips happen, bad hardware exists, and if your software is stable enough the hardware tail becomes visible. Practitioners across Firefox, Go, Julia, Factorio, and Guild Wars independently reached this conclusion over two decades. But "real" and "important" are different things. 470k crashes/week across 200M users is noise per-user. People who need reliability already buy ECC. The consumer market is allocating correctly — nobody fixes this because it's genuinely small, not because of market failure.

The thread's actual value is as a collection of excellent debugging war stories (especially netcoyote's Guild Wars anecdote and adonovan's Go telemetry work), plus a useful heuristic for software developers: if you've eliminated your bugs and a stubborn tail of inexplicable crashes remains, it's probably hardware. That's worth knowing. It's not worth a crisis narrative.
