← [Index](../README.md)

## HN Thread Distillation: "What it means that Ubuntu is using Rust"

**Source:** [smallcultfollowing.com (Niko Matsakis)](https://smallcultfollowing.com/babysteps/blog/2026/02/23/ubuntu-rustnation/) · [HN thread](https://news.ycombinator.com/item?id=47125286) (270 comments, 183 points, Feb 2026)

**Article summary:** Rust project lead Niko Matsakis frames Ubuntu/Canonical's adoption of Rust coreutils, sudo-rs, and ntpd-rs through Geoffrey Moore's "Crossing the Chasm" model. He argues Rust is transitioning from early adopters to early majority and needs to adapt — bigger stdlib (or "battery packs"), listening to pragmatist adopters, and showing empathy toward newcomers. The article is a political document aimed at preparing the Rust community to accept changes they historically resisted (like the 2016 "Rust Platform" proposal).

### Dominant Sentiment: Skeptical pragmatism over evangelism fatigue

The thread splits into Rust practitioners who want real problems fixed (ABI, stdlib, ecosystem maturity) and a vocal group who see the coreutils rewrite as solution-in-search-of-a-problem. Notably low on the breathless enthusiasm that characterized Rust threads circa 2022-23. The mood has shifted from "should we use Rust?" to "are these specific rewrites actually ready?"

### Key Insights

**1. The ABI gap is the actual chasm, not stdlib size**

pizlonator delivers the thread's strongest technical argument: replacing 20 C/C++ shared objects with 20 Rust shared objects currently means 20 copies of the Rust standard library. And if you use C ABI for interop between them, you're back to manual memory management at every boundary, gutting the safety benefit. "So long as Rust doesn't have a safe ABI, the upside of a Rust rewrite might be too low in terms of safety/security gained to be worth doing." The article's focus on stdlib/"battery packs" is a supply-side fix for a demand-side problem — distro maintainers don't need more crates blessed, they need Rust libraries to compose without memory duplication and without losing safety at FFI boundaries. choeger correctly identifies that Rust's compile-time monomorphization makes this fundamentally harder than C's ABI story.

**2. The dd bug is a live demonstration of the rewrite risk**

stabbles surfaces a concrete, currently-biting bug: rust-coreutils' `dd` implementation doesn't fully write data to slow readers, breaking makeself archives — which means VirtualBox guest additions, CUDA toolkit installers, and anything using makeself fail checksum validation on Ubuntu 25.10. The [Launchpad bug](https://bugs.launchpad.net/ubuntu/+source/rust-coreutils/+bug/2125535) is damning: the fix is a one-line behavior change, but the original reporter's frustration is palpable ("please ignore the editorial comment!"). This is exactly the kind of 20-year edge-case fix the article hand-waves past. The bug validates UI_at_80x24's worry that "20+ years of bug fixes and edge-case improvements can't be accounted for by simply using a newer/better code-base." Matsakis's article has no answer for this — the "Crossing the Chasm" framework treats product-market fit as a messaging problem, but this is an engineering readiness problem.

**3. GPL → MIT is the governance story hiding behind the language story**

Multiple commenters (nekiwo, throwaway613746, a456463) flag what Matsakis doesn't mention: rust-coreutils is MIT-licensed, not GPL. This is a material change to the social contract of Linux infrastructure. jsheard's point that AI has become "an automatic copyright laundering machine" — transmuting GPL code into permissive-licensed output — adds an uncomfortable dimension. The thread doesn't resolve whether Canonical's motivation is genuine open-source pragmatism or strategic positioning to offer proprietary enterprise patches. But the license change is arguably a bigger discontinuity than the language change, and the article's framing of "minimizing discontinuity with old ways" is ironic given it doesn't acknowledge this one.

**4. AI is inverting Rust's adoption barrier in real time**

A fascinating sub-thread emerges: canadiantim switched from Python to Rust specifically because AI makes it tenable. ChadNauseam explains the mechanism — Rust's compiler errors are machine-readable feedback loops: "I can change one function signature and have my output fill up with compile errors (that would all be runtime errors in Python). Then I just let Claude cook on fixing them." the_duke and mr_mitm reinforce that Rust's strict type system and mandatory error handling make AI agents more effective than in dynamically-typed languages. But Sytten pushes back from production experience: "AI is still pretty shit at Rust. It largely fails to understand lifetime, Pin, async... It hallucinates a lot more in general than JS." The resolution might be that AI works well for Rust's *easy mode* (types, error handling, simple ownership) but fails at Rust's *hard mode* (lifetimes, async, Pin) — which is exactly where systems programming lives. lelanthran's warning that "AI written Rust will have much more undefined behavior than human-written C" cuts at the irony of using a safety-focused language with a non-deterministic code generator.

**5. Ubuntu's fragmentation risk is the unspoken downside of "crossing the chasm"**

mrweasel articulates the risk Matsakis's article ignores entirely: if Ubuntu's Rust replacements aren't adopted by other distributions, the result is a more fragmented Linux ecosystem, not a safer one. "Ubuntu might accidentally, or deliberately, create a semi-incompatible parallel Linux environment, like Alpine, but worse." aragilar draws the pulseaudio parallel — Ubuntu has a history of "shipping software that isn't ready and turning the community against it." Combined with the dd bug, the picture is of premature deployment driven by strategic positioning rather than engineering readiness. PunchyHamster is blunter: "they pushed untested tools that even authors didn't think are production ready on unsuspecting users."

**6. The stdlib debate has a constraint most commenters ignore**

The "make the stdlib bigger" chorus (bigstrat2003, moomin citing .NET) runs into okanat's detailed rebuttal: Rust spans from bare-metal microcontrollers (<64K) to hosted applications, and a large stdlib with hosted-system assumptions breaks `no_std` code sharing. "Having a huge baggage of std both causes issues like this for the users and also increases maintenance burden of the maintainers." This is why the problem is genuinely hard — C++ suffered from this, and Rust's core/std split already has friction. hombre_fatal's suggestion of blessed-but-separate-versioned crates (like `regex`) is probably the right architectural direction, which is essentially what Matsakis's "battery packs" proposal aims at.

**7. The "virtue signaling" accusation reveals a real adoption failure mode**

egorfine's dismissal — "coreutils is one of the most stable pieces of Linux infrastructure... the rewrite serves no purpose" — is crude but points at something real: the value proposition for rewriting *already-working, battle-tested* infrastructure in a new language is genuinely thin unless you can demonstrate measurable security improvement. The article frames this as a marketing/messaging problem ("industry standard" vs "state-of-the-art"), but the thread suggests it's an *actual* value problem. If the rewrite introduces new bugs (dd) while providing theoretical safety guarantees that haven't prevented real exploits in the originals, the ROI is negative. The counterargument — that memory safety bugs in coreutils are a genuine attack surface — goes largely unmade in the thread, which is itself telling.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Nobody asked for a coreutils rewrite" | Medium | True for coreutils specifically, but ignores sudo/ntpd where CVE history justifies it |
| "Rust stdlib should be bigger" | Medium | Correct for hosted use cases, ignores no_std constraint |
| "AI makes Rust easy now" | Weak-to-Medium | Works for simple ownership patterns, fails at async/lifetimes where systems code lives |
| "MIT license is a betrayal" | Medium | Legitimate governance concern, but overstated — the code remains open regardless |
| "This is just Ubuntu being Ubuntu" | Strong | Pattern-matches to Upstart, Mir, Unity — Canonical's track record of premature divergence is real |

### What the Thread Misses

- **Nobody asks who benefits from coreutils CVEs.** The security case for rewriting coreutils in Rust would require showing exploitable memory safety bugs in GNU coreutils. The thread assumes both sides — "it's safer!" and "it was already safe!" — without evidence.
- **The economic incentive structure is backwards.** Matsakis reveals that funding often comes from companies *considering* Rust, not those *using* it. This means investment is driven by hope rather than validated need — the opposite of the pragmatist adoption model the article advocates.
- **Dynamic linking isn't just a technical problem, it's a political one.** Distributions *require* dynamic linking for security patching (update one .so, fix all consumers). Rust's static-linking default means every Rust binary embeds its own copies of dependencies, making CVE patching a rebuild-the-world operation. Nobody connects this to the ABI discussion.
- **The "Crossing the Chasm" framing itself is misleading.** Moore's model describes commercial product adoption with competitors. Rust's situation is different: it's replacing C/C++ in contexts where the "competitor" is the incumbent with 40+ years of ecosystem lock-in. The chasm isn't between early adopters and early majority — it's between "new code in Rust" (easy, happening organically) and "rewrite existing code in Rust" (hard, questionable ROI).

### Verdict

The article and the thread are having two different conversations. Matsakis is preparing the Rust community for uncomfortable internal changes (bigger stdlib, blessed crates, accommodating pragmatists). The thread is asking whether Ubuntu's specific Rust deployments are ready — and the evidence says no. The dd bug, the incomplete sudo-rs feature parity, the license change nobody voted on — these are concrete problems that no amount of "Crossing the Chasm" framing resolves. The deeper irony is that Matsakis's article preaches empathy toward new adopters while deploying a marketing framework that treats their objections as adoption-stage psychology rather than legitimate engineering concerns. The real chasm Rust needs to cross isn't between early adopters and early majority — it's between "Rust code that replaces C" and "Rust infrastructure that replaces C infrastructure," where decades of edge cases, ABI expectations, and licensing norms constitute the actual gap.
