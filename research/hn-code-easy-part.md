← [Index](../README.md)

## HN Thread Distillation: "Code has always been the easy part"

**Source:** [laughingmeme.org](https://laughingmeme.org/2026/02/09/code-has-always-been-the-easy-part.html) (Kellan Elliott-McCord, ex-CTO Etsy) · [HN thread](https://news.ycombinator.com/item?id=47099476) (76 pts, 74 comments, Feb 2026)

**Article summary:** Kellan argues that code was *never* the hard part of software — the hard part is the human-technology system that ships product, evolves, and meets real needs. AI making code cheap is genuinely new, but the pattern of technology breaking team structures and requiring reinvention is not. He acknowledges the moment is real while cautioning against fetishizing code as the primary artifact.

### Dominant Sentiment: Polarized and mutually accusatory

Both sides accuse the other of "coping." The article's supporters say critics are clinging to identity. The critics say the article is rationalizing displacement. The thread generates more heat than light because nobody agrees on what "code" means.

### Key Insights

**1. "Cope" is a symmetric weapon — and that's the tell**

The most revealing feature of this thread isn't any single argument but the structure of the debate itself. xnx dismisses the article: *"I can only assume so many people are repeating this as cope."* jama211 fires back: *"Or perhaps you are the one who is 'coping'?"* SirensOfTitan calls it *"just cope at this point."* When both sides deploy the same accusation, it usually means neither has a falsifiable position — they're arguing about identity, not evidence. The thread is a Rorschach test for how people relate to their craft.

**2. Retroactive trivialization is a known cognitive pattern**

hnfong names the sharpest dynamic in the thread: *"Every time computers master a skill that was previously thought to require a lot of intelligence/knowledge/ingenuity, people suddenly claim that it wasn't that hard after all."* This is the real mechanism operating here. Arithmetic, chess, and now code all got retroactively demoted once machines could do them. The article participates in this pattern while claiming to transcend it — Kellan says code was *always* easy, but the market priced it as scarce for decades. hnfong's observation is the one the whole thread should have engaged with and didn't.

**3. The word "code" is doing triple duty and nobody notices**

The thread is incoherent because participants use "code" to mean three different things: (a) the mechanical act of typing syntax, (b) the design/architecture/systems-thinking that produces working software, and (c) the entire job of a software engineer including meetings, debugging, deployment, and coordination. The article's thesis is trivially true for (a), debatable for (b), and clearly false for (c). mountainriver gestures at this — *"totally depends on what kind of coding you are doing"* — but nobody builds the taxonomy. Kellan's Etsy anecdote is about (b): the team was stuck on architecture, not syntax. But his conclusion slides to (a): code is cheap.

**4. The leadership-position blind spot**

The article is written by a CTO who stopped a rewrite and redirected the team. From that altitude, code *is* the easy part — you're not writing it, you're managing the system around it. citizenpaul pushes back sharply: *"I do and always will believe this phrase to be wage suppression propaganda. The proof is self evident. ie salaries."* This is crude but points at something real: the people most enthusiastic about "code is easy" tend to be leaders, architects, and commentators — people whose value was never primarily in code production. analog31 is refreshingly honest: *"I only say these things as an observer, since I can code all day, but didn't pursue a software development career."*

**5. The "fast iteration forgives everything" thesis gets properly demolished**

mikert89 makes the strongest contrarian case: *"When the time to build collapses, all product/sales/design/marketing mistakes are forgiven. You can pivot so fast that mistakes in other domains don't matter."* jama211 rebuts cleanly: *"This is literally the opposite of what is true. When the time to build collapses, those things become the criticality of the entire product."* denkmoon adds the empirical kill shot: *"building something with AI then changing direction half way through is a great way to generate garbage structure and garbage code."* The "just iterate" thesis assumes AI-generated code is as malleable as a whiteboard sketch. It isn't.

**6. SirensOfTitan reframes the entire debate — and gets ignored**

The most important comment in the thread shifts from "is code easy?" to "does it matter?": *"We're devaluing all white collar work. The thing that keeps the US economy afloat. Even if this tech requires human oversight, why would companies keep you when they can hire someone overseas at 1/10th the cost and get to 80% of the productivity with AI?"* Nobody engages with the macroeconomic argument. The only response is bendmorris asking *"start doing what instead?"* — which is exactly the question the thread is avoiding.

**7. The Mythical Man Month test**

roxolotl's top comment anchors on Brooks: *"9 agents still cannot have a baby in 1 month because the problem has never been the speed at which we type."* analog31 extends this into a litmus test: *"I'll concede that AI can develop software when The Mythical Man Month no longer reads like it was written yesterday."* This is the strongest framing for the "code was always easy" camp — the bottleneck is coordination and conceptual integrity, not production speed. But it also sets a clear falsifiability bar that the article itself doesn't.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| If code was easy, why the high salaries? | Medium | Confuses "code" with "the full SWE job." But the market-price signal is real and under-addressed. |
| This is wage suppression propaganda | Weak | Motive-based argument. But citizenpaul is right that the timing is suspicious. |
| AI code is unmaintainable garbage | Medium | denkmoon's experience is real but may be temporary. The question is trajectory. |
| Code difficulty varies enormously by domain | Strong | mountainriver and 8n4vidtmkvmk correctly note that CRUD ≠ kernel ≠ ML ≠ game engine. Article generalizes from web/enterprise. |
| "Just iterate" solves product mistakes | Weak | Thoroughly rebutted. Fast building ≠ fast learning what to build. |

### What the Thread Misses

- **The market priced code as scarce for 30 years.** If code was "always" the easy part, the labor market had a multi-decade pricing error. Nobody reconciles the "always easy" thesis with revealed preference in compensation. The most likely resolution — you were paid for the *bundle* of skills, code was just the visible output — actually supports a weaker version of Kellan's thesis, but he never makes that argument precisely.

- **What happens when AI gets good at the "hard parts" too?** The article's implicit comfort is: code goes to zero, but systems thinking / product sense / coordination remain human. Nobody asks how long that lasts. If the hard parts are next, "code was always easy" is just the opening move of a much larger displacement.

- **The article bundles two claims and the thread only debates one.** Claim 1: code was always the easy part. Claim 2: tech transitions requiring team reinvention are familiar and survivable. The thread fights about (1) endlessly and almost nobody engages with (2), which is actually the more interesting and more falsifiable claim.

### Deeper Structures the Thread Circles But Never Names

Cross-referenced against [insights.md](../insights.md) and [additional_insights.md](../additional_insights.md). The thread brushes against several well-evidenced structural dynamics without surfacing them. These are the insights the distillation would have missed without the cross-check.

**1. The ownership cost is unchanged — and that's the real answer to "code is cheap"**

The thread's strongest unspoken argument. mcoliver built an app in 2 hours; paxys rebutted with "how long to turn it into a business?" But the deeper point is [Liability Acceleration](../insights.md#liability-acceleration): every line of code carries maintenance tax — it must be understood, modified, tested, explained to new hires, and kept consistent — **regardless of how it was generated**. Generation cost is plunging; ownership cost is unchanged. GitClear data: code churn doubled, duplication up 8x, refactoring down 60% in AI-assisted codebases. A post-agentic survival analysis (201 projects, 200K+ code units) found agent code persists *longer* than human code — not because it's better, but because nobody owns it and nobody wants to touch it. "Code is cheap" conflates production cost with total cost of ownership. The thread never makes this distinction.

**2. Naur's Nightmare: the "big ball of mud" is theory-less code, and AI prevents the theory from ever forming**

roxolotl's top comment — outsourced code is "a big ball of mud" — is describing [Naur's Nightmare](../insights.md#naurs-nightmare) without the framework. The insight goes deeper than "AI writes bad code": Shen & Tamkin (Jan 2026 RCT, n=52) found developers using AI scored **17% lower on conceptual understanding**, with the largest gap in *debugging* — the skill most dependent on having a mental model. AI doesn't just produce balls of mud — **it prevents the human from forming the mental model needed to un-mud them**. The next developer can't reverse-engineer the theory from the code because the code was never an expression of a theory in the first place. roxolotl's "hard part is long term maintenance" is precisely right, but misses *why* it's going to get harder: AI severs the theory-building mechanism that made maintenance possible at all.

**3. Amdahl's Law quantifies the "code is easy" thesis — and shows it's less interesting than Kellan thinks**

The thread invokes Brooks qualitatively (roxolotl, analog31) but nobody runs the numbers. [Brooks-Naur Vindication](../insights.md#brooks-naur-vindication) does: IDC (2024) measured coding at **16%** of developer time; Microsoft's "Time Warp" study (2025, 484 devs) measured it at **11%**. Even infinitely fast coding yields a **1.1–1.2x** organizational speedup. This *quantifies* Kellan's claim — yes, code is the easy part, which means making it cheaper changes less than everyone on both sides of this thread assumes. The article oversells the magnitude of the change; the critics overclaim the value of what's being replaced.

**4. Diagnostic Pain: some of the friction AI removes is load-bearing**

Nobody in the thread mentions [Diagnostic Pain](../insights.md#diagnostic-pain). When Kellan celebrates the fun of "throwing all the pieces up in the air," he's missing that some friction is a signal that an abstraction is wrong. The practical test: if removing the friction also removes the incentive to build a better abstraction, the friction was load-bearing. Ironically, Kellan's own Etsy PHP story is a diagnostic-pain case: the pain of maintaining two incompatible architectures told the team the abstraction strategy was wrong. An AI that numbed that nerve by making the maintenance tolerable would have been *worse* than the pain.

**5. Cognitive Rest Erosion: removing the "easy part" makes the job harder, not easier**

If code is the easy part and AI does it, what remains is 100% high-cognitive-load judgment — architecture, requirements, coordination, debugging conceptual problems. [Cognitive Rest Erosion](../additional_insights.md#cognitive-rest-erosion) identifies that mechanical tasks served as implicit recovery periods between bouts of hard thinking. Removing them creates 8 hours of sustained decision-making that is unsustainably draining. The thread treats "easy part goes away" as liberation; the structural prediction is burnout. This connects to why habinero's framing — *"you're a knowledge worker so people look to you to make decisions"* — is actually describing the problem, not the solution.

**6. The Apprenticeship Doom Loop: PROTechThor is a canary**

PROTechThor says *"as a junior dev, it wasn't so easy for me"* — a throwaway comment that maps to the [Apprenticeship Doom Loop](../insights.md#apprenticeship-doom-loop): 54% of engineering leaders plan fewer junior hires (LeadDev 2025), AND the learning mechanisms that produce seniors are degraded (pairing, whiteboarding, progressive review). The "code was always easy" framing accelerates this: if code is trivial, why invest in teaching people to do it? The seniors of 2032 are the juniors not being hired or trained in 2026. Nobody in the thread connects these dots.

**7. Volume-Value Divergence: the empirical answer to "just iterate faster"**

mikert89's "fast iteration forgives everything" thesis has a direct empirical rebuttal beyond what the thread provides. [Volume-Value Divergence](../insights.md#volume-value-divergence): AI-authored code is rising (22→26.9% QoQ) while measured productivity is flat at ~10% (DX, 121K devs). More code ≠ more value. The lines are diverging across multiple quarters, weakening the "measurement lag" defense. NBER (Feb 2026, 6K CEOs/CFOs): ~90% of firms report no AI impact on employment or productivity over 3 years.

**8. Steering ∝ Theory resolves the thread's incoherence better than "code means three things"**

My insight #3 (code doing triple duty) is descriptively useful but [Steering ∝ Theory](../insights.md#steering-theory) provides the actual resolution: for theory-sparse work (CRUD, boilerplate, standard integrations), AI genuinely excels and code IS easy — McKinsey: ~50% time savings. For theory-dense work (novel architectures, differentiating features), steering IS the product and code is a side effect — McKinsey: <10% savings. The thread's domain-dependent pushback (mountainriver, 8n4vidtmkvmk) is pointing at this without having the framework. The article generalizes from theory-sparse work; the critics generalize from theory-dense work. Neither is wrong; both are incomplete.

**9. Commoditized Labor and Anticipatory Displacement: the macro story SirensOfTitan was reaching for**

SirensOfTitan's ignored comment maps directly to two structural insights. [Commoditized Labor](../insights.md#commoditized-labor): AI doesn't replace labor — it commoditizes it, collapsing geographic wage premiums and shifting value capture from workers to workflow owners. Cleveland Fed: young college graduates' job-finding rates have converged with high-school graduates (lowest gap since the 1970s). [Anticipatory Displacement](../insights.md#anticipatory-displacement): companies are already restructuring based on AI's *potential*, not performance (HBR Jan 2026). The loop is self-fulfilling: announce cuts → stock rewards → more cuts → the displacement becomes real regardless of whether AI delivers. SirensOfTitan was the only person in the thread looking at the right level of analysis.

### Verdict

The article is half right in the least interesting way. Yes, typing syntax was never where the value lived — this is a truism dressed up as provocation. The actually bold claim — that this transition is *familiar* and manageable — goes untested because the thread gets stuck on the easy bait. What nobody says plainly: "code was always easy" is retroactive narrative revision enabled by the arrival of a tool that makes it look easy. The same people saying this in 2026 were not saying it in 2020. hnfong identified the mechanism; the thread failed to reckon with it.

But the cross-reference reveals something more damaging to Kellan's thesis than the thread managed: the "easy part" framing is self-defeating at every level. Amdahl's Law shows coding is 11–16% of the work, so even free code yields marginal organizational gain — making the change *less* exciting than Kellan claims. Liability Acceleration shows the ownership costs don't shrink — making the transition *harder* than he implies. Naur's Nightmare shows AI severs theory-building — making the *hard parts harder* by eliminating the cognitive mechanism that made them tractable. Diagnostic Pain shows some friction was load-bearing — making AI relief *counterproductive* in specific cases. And Cognitive Rest Erosion shows removing the easy part creates unsustainable all-judgment workloads — making the remaining job *worse*. The article says "code was never the hard part" as comfort; the structural evidence says "removing the easy part makes everything else harder."

The thread's deeper irony: jama211 posted 10+ comments aggressively defending the article, inadvertently demonstrating that the *real* scarce resource in a world of cheap code is attention, judgment, and taste in argument. Most of those comments added volume, not signal — a microcosm of [Volume-Value Divergence](../insights.md#volume-value-divergence).
