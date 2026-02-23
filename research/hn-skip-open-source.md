← [Index](../README.md)

## HN Thread Distillation: "Skip is now free and open source"

**Source:** [HN thread](https://news.ycombinator.com/item?id=46706906) · 515 points · 226 comments · Jan 2026
**Article:** [skip.dev/blog/skip-is-free](https://skip.dev/blog/skip-is-free/)

**Article summary:** Skip, a bootstrapped tool that lets developers write iOS apps in Swift/SwiftUI and get native Android apps via transpilation to Kotlin/Jetpack Compose, drops its paid subscription model and open-sources its build engine ("skipstone") under LGPL-3. The team cites the impossibility of selling paid dev tools against free competitors and the need to eliminate rug-pull risk. They shift to a GitHub Sponsors / corporate sponsorship model.

### Dominant Sentiment: Cautious goodwill, adoption skepticism

The thread is warm toward the decision but nobody's announcing they're shipping with Skip. Respect for the bootstrapped team; wariness about sustainability and the empty case-study page.

### Key Insights

**1. The "cross-platform doesn't scale" argument is now empirically dead, but the zombie keeps walking**

ashishb claims cross-platform "fundamentally does not work for anyone with more than 10M+ installs." He's immediately countered by doodlesdev (Nubank, 100M+ clients on Flutter), roughike (15M-install Flutter app that was App of the Day), satvikpendem (Shopify, five years of React Native), and wahnfrieden (Goodnotes, tens of millions of MAUs on Swift WASM). ashishb retreats from "fundamentally" to "broadly" to "in the short term it can work." The interesting dynamic: this argument gets relitigated on every cross-platform thread despite the counterexamples being well-known. It persists because the *emotional* core isn't about install counts—it's about control anxiety over your dependency chain. That concern is legitimate, but framing it as a scale threshold lets people avoid admitting it's a risk tolerance question at every scale.

**2. LGPL-3 is Skip's most consequential and under-examined decision**

jillesvangurp delivers the thread's sharpest structural analysis: every competitor—SwiftUI, Flutter, Compose Multiplatform, React Native—uses a permissive license. LGPL-3 introduces friction that actively discourages the ecosystem formation Skip needs most. "Developer communities that include developers from companies that commercially depend on the software are stronger and more resilient long term. Unfortunately, that usually means letting go of being in control." The Skip team chose a license that protects their code from being absorbed into proprietary forks, but the threat model is backward—their problem isn't someone stealing the code, it's nobody using it. Permissive licensing is what lets companies justify internal investment in a framework. LGPL-3 gives legal departments a reason to hesitate.

**3. The Liquid Glass argument is Skip's strongest competitive wedge—and its biggest bet**

marcprux (Skip co-founder, very active in thread) makes the forward-looking claim that Flutter and Compose Multiplatform will be unable to convincingly support Apple's Liquid Glass design language because they paint pixels rather than using native controls. Skip, by mapping to real SwiftUI and real Jetpack Compose, gets platform design evolution for free. This is clever positioning but it's also a bet that Apple will *keep* making radical design changes. Skip's moat is Apple's design instability. If Apple slows down its design language churn, the gap between pixel-painting and native controls narrows.

**4. The production case-study gap is the elephant in the room**

vishrajiv, tonyhart7, jackbravo, and frouge all ask variations of "who's actually using this?" No compelling answers appear. marcprux references an NSSpain talk about shared business logic but no flagship app name drops. For a tool that's been available since 2023, this silence is louder than any technical argument. DetroitThrow says "I've heard a lot actually" but hasn't used it. This is the classic developer-tool death zone: enough buzz to generate HN threads, not enough adoption to generate testimonials.

**5. The "paid dev tools are dead" consensus has a dark corollary nobody names**

Skip's article states the obvious: "developers expect to get their tools free of charge." publicdebates shares a raw personal parallel—built a Lua GUI framework, nobody would pay a dime, now considering a career change. The thread treats this as natural market reality. But the dark corollary is that if dev tools can only survive via Big Tech patronage (Google funds Flutter, JetBrains funds KMP, Meta funds React Native) or VC money, then bootstrapped independence—the very thing Skip trumpets as an advantage—is actually a structural weakness. Skip is trying to be the indie band in an industry where only major labels can afford to tour.

**6. marcprux's KMP comparison is substantive but reveals the pitch problem**

The co-founder's detailed comparison of Skip vs. Kotlin Multiplatform is the thread's most informative comment. Key claim: CMP is "native on Android but alien on iOS, whereas Skip is native on both platforms." He's fair to KMP's advantages (desktop + web reach). But the length and detail of the explanation itself reveals a problem: Skip requires a paragraph to explain what it even *is* relative to alternatives. Flutter's pitch is one sentence. React Native's pitch is one sentence. Skip's pitch requires understanding transpilation modes (Lite vs. Fuse), the Swift Android workgroup, and the difference between shared logic and shared UI layers. Complexity of explanation correlates with adoption friction.

**7. Hot reload absence is a real competitive disadvantage in the agent era**

wahnfrieden (who appears throughout the thread with consistently high-quality takes) notes SwiftUI's lack of hot reloading as a significant downside, adding: "Preview canvas is unusable by agents." This is forward-looking—as AI coding agents become part of the development loop, frameworks that support fast iteration cycles without full rebuilds gain a compounding advantage. Flutter has hot reload. React Native has fast refresh. SwiftUI has... the preview canvas, which requires manual interaction. Skip inherits this limitation.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Cross-platform can't scale past 10M installs | Weak | Immediately falsified by multiple counterexamples (Nubank, Shopify, Goodnotes) |
| LGPL-3 will limit ecosystem adoption | Strong | All competitors use permissive licenses; legal friction is real for enterprise |
| Sponsorship model won't sustain development | Strong | No successful precedent for donation-funded cross-platform frameworks |
| Mac-only dev environment is a dealbreaker | Misapplied | Apple requires Mac for iOS development regardless of framework choice |
| Should have been open source from the start for ideological reasons | Medium | sneak's purist position; wahnfrieden's counterpoint about App Store cloning is more grounded |

### What the Thread Misses

- **The Swift-on-Android ecosystem question.** Skip's long-term viability depends on the Swift Android Workgroup succeeding broadly, not just for Skip. If Swift-on-Android remains a niche concern, Skip stays niche. Nobody discusses the health or momentum of this workgroup.
- **The AI code generation angle.** ildon asks about AI translating between platforms but gets no engagement. The real threat to Skip isn't another cross-platform framework—it's AI agents that can maintain parallel native codebases directly. If an agent can keep a SwiftUI app and a Jetpack Compose app in sync, the entire cross-platform abstraction layer becomes unnecessary.
- **Who the actual buyer is.** Skip targets Swift developers who want Android reach. But the market of "teams that chose Swift-first and now want Android" is much smaller than "teams that want cross-platform from day one." The latter group picks Flutter or React Native. Skip's addressable market may be structurally small.

### Verdict

Skip made the right call going open source—paid dev tools are indeed dead unless you're JetBrains-scale. But the thread reveals that the *real* challenge isn't the business model, it's the adoption flywheel that hasn't started spinning. Three years in, zero notable production apps cited, a license choice that adds enterprise friction, and a value proposition that requires a multi-paragraph explanation to distinguish from alternatives. The Liquid Glass wedge is genuinely clever positioning, but it's a bet on one company's (Apple's) continued design radicalism. What the thread circles but never states: Skip is building a bridge from the Swift world to Android, but the traffic that wants to cross that bridge in that direction may simply not be large enough to sustain the infrastructure.
