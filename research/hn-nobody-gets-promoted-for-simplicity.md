← [Index](../README.md)

## HN Thread Distillation: "Nobody Gets Promoted for Simplicity"

**Source:** [terriblesoftware.org](https://terriblesoftware.org/2026/03/03/nobody-gets-promoted-for-simplicity/) | [HN thread](https://news.ycombinator.com/item?id=47242765) (173 pts, 65 comments, 2026-03-03)

**Article summary:** Engineer A ships 50 lines in two days; Engineer B builds a pub/sub abstraction layer in three weeks. At promotion time, B's packet writes itself while A's reads "Implemented feature X." The article argues this is a systemic incentive problem — complexity looks smart because our evaluation systems reward it — then offers concrete advice for both engineers (frame your decisions, not just your code) and leaders (put the burden of proof on complexity, celebrate deletions).

### Dominant Sentiment: "Actually, I have been promoted for this"

Surprisingly, the thread *does not* rally behind the headline. A significant bloc of experienced commenters pushes back with direct counter-evidence, and the dominant emergent framework isn't "simplicity goes unrewarded" but rather "simplicity goes *unsold*."

### Key Insights

**1. The article answers its own headline — and the thread notices**

The piece's strongest material is in its second half: specific framing advice ("evaluated three approaches… determined straightforward implementation met all requirements… shipped in two days with zero incidents"). Multiple commenters (tabs_or_spaces, dfxm12, scuff3d) zero in on this and reframe the problem: this isn't an engineering problem, it's a sales problem. scuff3d demonstrates by having GPT write a corporate self-eval for a 50-line solution and getting a perfectly promotable blurb. The implication is uncomfortable: the "simplicity isn't rewarded" complaint may partly be "I don't want to do marketing for my own work."

**2. The promotion mechanics are structural, not cultural**

sssilver, a former EM at a near-household-name company, delivers the thread's most granular comment. The key insight: your manager probably *does* understand your work, but promotions are decided by your manager's *manager*, who is "too busy, distracted, and uninvested in you personally to pay attention to anything other than quick, easily observable and defensible impressions." This is the structural mechanism the article gestures at but never names — it's not that people *prefer* complexity, it's that complexity is legible at a distance. Simplicity requires context that doesn't survive the reporting chain.

**3. Promotion ladders literally encode complexity**

bob001 makes the most concrete structural observation: "Every large company has a ladder for promotions that includes many words that basically come down to 'complex.' 'Drive a year long initiative' or 'multiple teams' or 'large complex task with multiple components.'" This is harder to dismiss than anecdotes in either direction — the criteria themselves select for scope-as-complexity. Even if a manager values simplicity, the rubric fights them.

**4. On-call as a simplicity incentive**

Swizec (who went into management specifically to fix this) offers the thread's sharpest incentive design: ship whatever you want, but you're on-call for it. "You'd be surprised how quickly engineers start simplifying stuff when they feel like they can't get anything done because someone's always asking questions or triggering alarms about that weird thing they built 3 months ago." tomxor names it in one word: *ownership*. Then samrus and pjmlp note the uncomfortable corollary — companies resist ownership because it makes employees harder to replace and gives them leverage. The incentive fix works, but organizations have counter-incentives against deploying it.

**5. The firefighter-arsonist anti-pattern**

al_borland surfaces the closely related dynamic: Person A writes stable code and fades into the background; Person B creates bugs, then heroically fixes them over the weekend, getting praised for the "heroics." abustamam *admits to having been this person* and getting promoted to staff for it: "I'm back to being a senior in a new org and I try to be person A, but… I find I spend more time trying to understand how to explain the value my work has to the business than trying to actually do my work." The honesty is notable — the arsonist-to-firefighter pipeline is real and people know they're in it.

**6. The counter-evidence is real but conditional**

kstrauser, cyberax, ChadMoran, and semiinfinitely all report being promoted for simplicity. But the pattern in their stories is revealing: every case involved *replacing existing complexity*. kstrauser replaced Xbase-on-network-share with PostgreSQL; ChadMoran's simple changes generated 9-figure revenue on Amazon's retail platform; semiinfinitely replaced a "critical" complex system. The delta was visible. pinkmuffinere provides the counter-case: eliminated a test station on Amazon's Astro line (~$1M savings), and the manager said "somebody else made that value, you just stopped it from being thrown away." Simplicity *from scratch* — where there's no before/after comparison — remains harder to reward.

**7. Complexity as unpriced leverage**

losalah's framing stands out: "unearned complexity is like taking on leverage. Sometimes it's the right move, but you should need a business case, not just enthusiasm." The carrying cost rarely gets charged to the builder — the team pays it later in surface area, failure modes, and onboarding time. This reframes the problem from aesthetics ("clean code good") to economics (complexity is debt with hidden interest rates, and the person who takes it on gets the bonus while the team services the payments).

**8. The thread's own LLM subplot**

linehedonist accuses losalah's comment of being AI-written; losalah says it was dictated in Obsidian. notreallya flatly accuses the article itself. p1anecrazy pushes back: "people shouldn't start writing word salad just because LLMs were trained on structured text." A minor but telling dynamic — we're now in an era where writing clearly and structurally invites AI suspicion, which creates a perverse incentive toward *less* polished communication.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "I've been promoted for simplicity" | Strong | Real counter-evidence, but conditionally — almost always involved *replacing* visible complexity, not building simple from scratch |
| "This is a sales problem, not an engineering problem" | Strong | The article largely agrees in its second half; the headline overstates the case |
| "Junior engineers over-engineer, seniors drive simplicity — this isn't a real trend" (danpalmer) | Medium | True as a general pattern, but doesn't address the structural ladder problem bob001 identifies |
| "Simple solutions ignore edge cases" (bruce511) | Weak/Misapplied | Conflates essential complexity with accidental complexity — exactly what the article distinguishes |
| "It's AI-written" (notreallya) | Weak | Drive-by dismissal with no evidence; the article reads cleanly and has a distinct voice |

### What the Thread Misses

- **AI-generated code amplifies the problem.** If complexity's bottleneck was effort, LLMs remove that bottleneck. Generating a pub/sub abstraction layer now takes minutes, not weeks. The ratio of "complexity produced" to "judgment exercised" is about to get much worse, and nobody in the thread connects this to cube00's worry about AI boilerplate.
- **The measurement void is the real story.** sssilver nearly says it: "they simply have no other way of measuring programmer productivity." The thread treats this as a background condition rather than the central problem. If you could measure *system changeability* or *incident-free time per feature* the way you measure "scope of project," the entire incentive structure flips. The reason simplicity goes unrewarded is that we literally lack the metrics for it.
- **The article's Engineer A/B framing hides a third option.** The real senior move isn't "ship simple and hope someone notices" or "overbuild for the promo packet" — it's to ship simple *and build organizational trust capital* through the judgment trail (ADRs, explicit option analysis, threshold triggers). losalah sketches this, but nobody develops it into a full strategy.

### Verdict

The headline is wrong, and the article knows it — its own advice section is a manual for getting promoted for simplicity. The thread's actual finding is subtler: simplicity is rewarded when it's *legible*, and legibility requires either a visible before/after delta (replacing complexity) or deliberate narrative work (selling the decision, not just the output). The structural barrier isn't culture — it's that promotion rubrics and reporting chains are optimized for *scope*, and complexity is scope's easiest proxy. Until organizations instrument for changeability and maintenance cost the way they instrument for feature delivery, the incentive will persist regardless of how many blog posts tell engineers to "keep it simple."
