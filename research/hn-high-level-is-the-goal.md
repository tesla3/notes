← [Index](../README.md)

## HN Thread Distillation: "High-Level Is the Goal"

**Source:** [bvisness.me/high-level](https://bvisness.me/high-level/) · [HN thread](https://news.ycombinator.com/item?id=46630816) (276 pts, 153 comments, 90 authors)

**Article summary:** Ben Visness (Handmade community, Mozilla wasm compiler team) argues that "low-level" programming matters not as a goal but as a means to build *better* high-level tools from lower in the stack. Uses New Reddit (React+Redux, 200ms to collapse a comment) vs. Old Reddit (jQuery, 10ms) as the core exhibit. Claims the software stack tree is dangerously top-heavy with JS frameworks, low-level tooling is "artificially terrible," and the Handmade community should build the next generation of platforms rather than just feeling smug about knowing how things work.

### Dominant Sentiment: Sympathetic but wanting more specifics

The thread broadly agrees with the diagnosis (modern web stacks are wasteful, the incentive structure is broken) but splits on remedies. The loudest sub-debate — what should replace the browser for desktop apps — inadvertently proves the article's point: there's no good answer yet.

### Key Insights

**1. The network-effects trap explains the incentive failure better than developer laziness**

The sharpest exchange in the thread. `torginus` sets it up with the automotive analogy (a 10% worse car kills a company), and `dijit` nails the structural point: "You're not choosing between a slow product and a faster alternative, you're choosing between a slow product and *losing access to everyone still using it*. That's not a market choice, it's a hostage situation." They observe that performance IS rewarded where switching costs are low — ripgrep over grep, esbuild over webpack — and absent where network effects dominate. `dijit` delivers the kill shot: "The fact that it's 'not worth optimising' is itself evidence of market power, not sound economics." This reframes the entire "developer time vs. user experience" debate as a symptom of monopoly, not a rational tradeoff.

**2. "If everyone does it wrong, it's the framework's fault" — and React's defenders prove the point**

`fullstackchris` mounts the standard React defense: the problem is devs who don't read release notes, not the framework. Author `bvisness` counters: the irrelevant-update problem was "pervasive across all of New Reddit, across the app I worked on professionally for five years, and across many other applications I've looked at." `MrJohz` closes the loop by pointing out SolidJS, Svelte, and Vue achieve equivalent DX without the "rerender everything by default" design. React's core architectural bet — rerender the world, then optimize — is simply the wrong default. The existence of frameworks that are equally high-level but don't have this problem makes the "skill issue" defense untenable.

**3. The Qt-shaped hole in the stack is the thread's gravitational center**

`cyber_kinetist`'s call for "a native cross-platform desktop UI framework that doesn't suck" is the most-engaged top-level comment. It spawns mentions of Slint (ex-Qt devs, Rust/C++), PanGUI (C#, transpile-to-native strategy), gpui (Zed's framework), Flutter (Dart anchor dragging it down), wxWidgets (legacy), and Dear ImGui. The debate reveals a paradox: everyone agrees the gap exists, nobody agrees on how to fill it. `ragall` wants a minimal graphical toolkit, not a framework. `cocoto` insists truly native feel requires platform-specific toolkits. `tonyedgecombe` says the cross-platform dream is inherently mediocre. `vouwfietsman` argues the browser already IS the cross-platform framework and the problem is misuse, not the platform. Thirty-plus comments, zero convergence.

**4. Dear ImGui as the existence proof nobody fully explores**

Both `bvisness` and `torginus` cite Dear ImGui as genuinely easier than React. The author states flatly: "I find it easier to use Dear Imgui from a 'lower-level language' like Odin or Go than to use any web framework with JS." `michalsustr` adds that egui (Rust ImGui derivative) is "just a joy" for their product. This is the article's thesis in concrete form — a "low-level" tool that's a better high-level tool than the "high-level" ones — but the thread doesn't stress-test *why* ImGui hasn't conquered the world. `gr4vityWall` offers the clearest clue: "You give up on hot reloading... Tooling is the problem." ImGui's superiority in runtime performance is real; its inferiority in developer iteration speed is equally real. The article's prescription (make low-level tools high-level) is exactly what ImGui still needs.

**5. Software "engineering" without cost internalization isn't engineering**

`wat10000` makes the most precise version of this argument: civil/automotive engineers optimize because the builder pays. Software "engineers" don't optimize because costs are externalized to users. `torginus`'s rebuttal is historically grounded: Reddit's refusal to internalize performance costs led users to cling to Old Reddit, which forced the API shutdown, which destroyed goodwill and drove away high-value contributors. The externalized cost eventually boomeranged — just on a longer timescale than in physical engineering. The mechanism is real but the feedback loop is too slow and too indirect to discipline individual decisions.

**6. The Handmade community's reputation problem**

`tialaramex` calls it a "Life of Brian" scenario — people "who can't and won't make useful software but feel Casey has given them permission to criticise anybody who does." `cyber_kinetist` concedes the snobby-elitist problem but credits Casey's educational material (Handmade Hero, Computer: Enhance) with invigorating interest in low-level work. The tension is real: the community's value is in expanding the overlap between "low-level skill" and "drive to innovate" (the article's Venn diagram), but its culture of performance purism repels exactly the people it claims to recruit.

**7. The jQuery bait-and-switch was the article's best rhetorical move — and the thread bit hard**

The article's fake-out (showing jQuery's call stack, then revealing it was Old Reddit) triggered exactly the reaction intended. `cellis` accuses the article of "glorifying jQuery" — three mentions don't constitute glorification, as `ulbu` points out. `throwup238` piles on with jQuery's inefficiencies, only for `JimDabell` and `wtetzner` to correct the historical record (jQuery predated querySelector, not the reverse). The meta-point the thread misses: the article isn't pro-jQuery. It's demonstrating that even a "bad" old tool on the right architectural foundation outperforms a "good" new tool on the wrong one. The correction of `throwup238`'s timeline error is itself evidence of how poorly the industry remembers its own history.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Reddit devs just used React wrong | Weak | Author has 5 years of professional React experience; SolidJS/Svelte prove the design is fixable |
| The browser IS the cross-platform framework | Medium | True for distribution, but the thread's own 30-comment framework debate proves dissatisfaction |
| Low-level tools already exist, author just doesn't know them | Weak | `teiferer` claims this but provides no examples matching browser dev tools quality; `bvisness` directly compares Chrome profiler vs. `perf` |
| Hardware/x86 is also bloated | Misapplied | `noelwelsh` raises this but `Nevermark` correctly notes CPUs running billions of ops/sec aren't the bottleneck for collapsing a comment |
| Article doesn't say what to actually DO | Strong | `NooneAtAll3` and `cons0le` both note the missing concrete call to action and no link to the Handmade community |

### What the Thread Misses

- **Distribution, not performance, is why the web won.** The thread debates native vs. browser performance endlessly but nobody names the real moat: zero-install, URL-addressable, instant-update deployment. Native frameworks don't just need to be fast and pretty — they need to solve distribution, or they'll remain niche regardless of quality.

- **AI code generation should collapse the "developer time is expensive" defense.** If AI makes it cheap to write and optimize code, the entire justification for shipping bloat evaporates. Either companies optimize (breaking the equilibrium) or they pocket the savings and ship the same bloat faster (proving it was never about cost). Nobody in the thread connects this, despite it being the most obvious near-term disruption to the incentive structure they're diagnosing.

- **The article's "tree" metaphor breaks at migration.** Software stacks are more fungible than car frames. Reddit *did* migrate from React to Web Components. Incremental migration is possible in software in ways it isn't in physical engineering. The Truckla analogy is evocative but overstates lock-in.

- **The framework gap persists because of the incentive gap.** The two biggest sub-debates (network effects killing performance pressure, and the missing native UI framework) are discussed as separate problems but are causally linked. Nobody will fund Qt's successor while the browser is "good enough" and distribution advantage trumps everything.

### Verdict

The article is well-argued and the thread mostly validates its diagnosis while failing to advance its prescription. The core irony: a post calling for builders to create better low-level foundations generates 153 comments debating which existing framework is least bad — exactly the "painting Truckla a different color" trap the article warns against. The thread's gravitational pull toward the cross-platform UI framework debate reveals that even sympathetic readers default to shopping for solutions rather than building them. The article says the overlap between "low-level skill" and "drive to innovate" is tiny; the thread demonstrates *why* it stays tiny — the structural incentives (network effects, externalized costs, broken feedback loops) that make bloat rational at the individual level make revolution irrational too. Until something breaks the equilibrium — a distribution breakthrough for native apps, a cost collapse in low-level tooling, or a competitive threat that forces performance to matter — the Handmade community's call to arms will remain a sermon to the choir.
