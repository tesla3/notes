← [Index](../README.md)

## HN Thread Distillation: "Looks like it is happening"

**Source:** [Peter Woit's blog](https://www.math.columbia.edu/~woit/wordpress/?p=15500) (Not Even Wrong) · [HN thread](https://news.ycombinator.com/item?id=47143211) · 144 points, 100 comments · Feb 2026

**Article summary:** Peter Woit claims arXiv hep-th (high energy physics – theory) submissions have nearly doubled in recent months compared to stable historical baselines, attributing the spike to AI-generated papers. He invokes Sabine Hossenfelder's "End of Theory" video and his long-running critique that hep-th quality was already abysmal. However, the article's own data was debunked within hours: the arXiv search used "most recently modified" date instead of original submission date, inflating 2025–2026 numbers. Woit updated the post — corrected figures show a real but modest ~15–20% year-over-year increase, not a doubling.

### Dominant Sentiment: Resigned acceleration of existing rot

The thread treats the AI paper flood not as a new crisis but as the logical terminus of publish-or-perish. There's more fatigue than alarm. The corrective comment demolishing the headline numbers gets top billing, and the thread pivots rapidly from "is this happening?" to "does it even matter given how broken things already were?"

### Key Insights

**1. The article's evidence undermines its own thesis**

The most important fact in this thread is that the headline claim is wrong. Jerry Ling (cited by **Chinjut**, top comment) points out the arXiv search artifact: searching by "most recently modified" date biases toward recent papers because older papers have had time to accumulate modifications. Corrected numbers show ~15–20% growth — significant, but nowhere near "apocalypse." **myhf** sharpens this into a broader epistemological point: "The last-modified-date effect is even more important, because it can be used to support whatever the latest fad is, without needing to adapt data or arguments to the specifics of that fad." The irony of sloppy data analysis in a post about sloppy papers is thick and unacknowledged.

**2. "Already broken" is the thread's consensus framework**

Nearly every substantive commenter converges on: AI didn't break academic publishing, it's stress-testing a system that was already failing. **selridge** captures it best: "We were already in a completely unsustainable system. Nobody had an alternative. We still don't have one but at least now it's not just merely unsustainable — it is completely fucked in half." **commandlinefan** concurs: "'Publish or perish' meant that a lot of human-generated slop was being published by people who were put in a position of perverse incentives." **MarkusQ** provides the historical depth, linking the Experimental History essay on peer review's failure — which documents that reviewers catch only ~25–30% of major flaws, that half of authors retract rather than share raw data, and that Nobel laureate Sydney Brenner called peer review "a completely corrupt system." The thread's implicit model: AI-generated slop is human-generated slop with lower marginal cost.

**3. The GPT-5.2 hep-th result complicates the "AI = mediocrity" frame**

**zozbot234** drops a genuinely important counterpoint that the thread doesn't adequately engage with: OpenAI's preprint showing GPT-5.2 Pro derived a new result in theoretical physics — specifically in hep-th, the very field Woit is claiming AI will drown in slop. The paper shows single-minus gluon tree amplitudes are nonzero, contradicting textbook assumptions. GPT-5.2 both conjectured and formally proved the general formula. This is the kind of result that, if robust, directly falsifies the "AI can only produce mediocre recombinations" thesis. The thread mostly ignores it, which is itself telling — the narrative of AI-as-noise-generator is more emotionally satisfying than the messy reality where AI simultaneously floods and advances the field.

**4. dang confirms the signal is real beyond arXiv**

HN's own admin provides the most credible data point in the thread: "The # of submissions and # of submitters, which traditionally had been surprisingly stable — fluctuating within a fixed range for well over 10 years — has recently been reaching all-time highs." He doesn't know yet whether it's bots, new users, or both. **marginalia_nu** offers forensic detail: new accounts posting gibberish, suspiciously high em-dash density in /noobcomments (a known AI tell), and a wave of "inane reddit-level drivel" on AI topics. **rob** reports seeing years-old dormant accounts suddenly posting multiple times in rapid succession — suggesting a black market in aged accounts, as **dragontamer** confirms.

**5. The "Software Collapse" model deserves more scrutiny than it gets**

**lmeyerov** introduces the most original concept in the thread: "Software Collapse," analogous to AI model collapse. As AI makes it trivial to port and recombine existing ideas, software converges toward a homogeneous best-practice blend — "higher quality but bland." This is a genuinely non-obvious dynamic: AI doesn't just add noise, it *compresses variance*. The implication for research is that AI-assisted papers would converge on the same well-trodden approaches rather than exploring novel territory. **zozbot234** pushes back that "bland" isn't bad, comparing it to how FLOSS replaced the chaotic shareware era. But the analogy breaks down: FLOSS converged because humans voluntarily concentrated effort; AI convergence happens because it's cheaper to recombine than to think.

**6. The outsider-access tension nobody resolves**

**xamuel** — a non-academic who just published in the top math biology journal after years of effort — raises the hardest practical question: "I do really worry that without academic affiliation it is going to get harder and harder for outsiders as gates are necessarily kept more and more securely because of all the slop." This is the mechanism by which noise-fighting *specifically* harms the people the open-science movement was supposed to help. arXiv already requires institutional vouching. Every additional gate erected against AI slop will disproportionately filter out independent researchers. Nobody in the thread proposes a solution.

**7. Antirez's distinction between vibe coding and automatic programming applies to research too**

**Philpax** links antirez's essay arguing that skilled human + AI produces qualitatively different output than unskilled human + AI. This maps directly onto the research question: the GPT-5.2 physics paper had IAS/Harvard physicists steering the process; the feared slop flood comes from PIs using AI as a grad-student replacement with minimal guidance. The thread gestures at this distinction without naming it: there's a spectrum from "AI as creative partner" to "AI as paper mill," and the distribution matters more than the volume.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Data artifact — numbers are wrong | **Strong** | Definitively shown; author acknowledged |
| Peer review was already broken | **Strong** | Well-evidenced, historically grounded |
| AI also produces genuine advances (GPT-5.2) | **Strong** | Under-engaged by the thread |
| Just add attestation ("I wrote this") | **Weak** | (**sixtyj**) — trivially circumvented, misunderstands incentives |
| This is good — forces the broken system to finally change | **Medium** | (**selridge**, **Certhas**) — plausible but no mechanism for *how* |
| Software/research has "peaked" | **Weak** | (**krashidov**) — refuted by same-thread evidence of AI advancing physics |

### What the Thread Misses

- **Nobody asks whether the 15–20% real increase is AI at all.** It could be geographic expansion (more researchers in China, India, Iran publishing in hep-th), post-COVID normalization, or simply more cross-listing. The thread leaps from "more papers" to "AI papers" without evidence for the causal link.
- **The filtering problem has known partial solutions nobody mentions.** Formal verification, registered reports, results-blind review, and replication markets all exist. The thread treats "how do we separate wheat from chaff" as unsolved when it's more accurately "unsolved at the institutional-will level."
- **The economic model of AI paper mills is unexplored.** Who benefits from flooding arXiv specifically? Unlike SEO spam, there's no direct monetization. The incentive is career advancement — but only if the papers get cited. AI slop that nobody cites is noise without consequence. The real threat is AI slop that *does* get cited by other AI agents in a self-reinforcing loop, and nobody in the thread names this dynamic.
- **arXiv's own response is absent.** What is arXiv doing? Do they have detection tools? Volume caps? The thread speculates without checking.

### Verdict

The thread's most important contribution is also its least celebrated: the top comment destroying the article's data. Strip that away and you have a blog post riding vibes to a predetermined conclusion — a veteran physicist who didn't check his search parameters before declaring an apocalypse, which is exactly the kind of low-effort analysis he accuses AI of producing. The real story isn't that AI is flooding hep-th (the evidence for that specific claim is weak). It's that the publish-or-perish system has created a landscape where the *threat* of AI flooding is indistinguishable from the *reality* of human flooding — and nobody can tell the difference because nobody was checking quality in the first place. The system's inability to distinguish AI slop from human slop is not a new failure; it's the old failure made legible.
