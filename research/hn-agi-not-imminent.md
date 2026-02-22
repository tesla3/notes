← [Index](../README.md)

## HN Thread Distillation: "Why I don't think AGI is imminent"

**Source:** [dlants.me](https://dlants.me/agi-not-imminent.html) · [HN thread](https://news.ycombinator.com/item?id=47028923) (137 pts, 305 comments, Feb 2026)

**Article summary:** A well-structured argument that AGI is not imminent, organized around two pillars: (1) LLMs lack cognitive primitives (object permanence, number sense, causality) that evolved from embodied experience and can't be reverse-engineered from language alone, and (2) transformer architecture has formal computational limits. The author revised the piece live based on HN feedback — acknowledging that chain-of-thought extends transformers from TC⁰ to P, and that Gemini 3 Deep Think hit 84.6% on ARC-AGI-2 — which gives the article unusual intellectual honesty but also weakens its own thesis mid-publication.

### Dominant Sentiment: Definitional chaos masking real uncertainty

The thread is less a debate about AGI timelines than a 300-comment demonstration that nobody shares a definition. At least four distinct definitions of "AGI" are actively defended: (a) can do most white-collar work, (b) matches human cognition across all domains, (c) can self-sustain and improve, (d) produces measurable GDP impact. The arguments are irreconcilable because they're about different things, and most participants don't notice.

### Key Insights

**1. The article's strongest argument undermines itself**

The embodied cognition thesis — that cognitive primitives require perception-action coupling and can't be learned from text — is well-sourced and the article's real contribution. But the author's own live revisions demonstrate the problem with "can't" claims in a fast-moving field. Within days of publication, he conceded the architecture argument was weaker than stated and that inference-time compute had closed most of the ARC-AGI-2 gap. The article is a snapshot of a position being eroded in real-time by the thing it's arguing against. Credit to the author for updating honestly, but the effect is like watching someone build a dam while the river rises.

**2. The arithmetic test reveals more than the tester intended**

`lambdaphagy` asked Opus 4.6 to multiply 50,651 × 895,707. It got it wrong initially (off by ~10⁻⁵ relative error), then self-corrected via algebraic decomposition to the exact answer. `FromTheFirstIn` laconically replied "This is in every way an argument for the author's point" — because the model lacks number sense but compensated with CoT. But this is exactly how the article's architecture argument collapsed: the author said transformers can't do X, then had to admit that CoT lets them do X by a different route. The arithmetic example is a microcosm of the whole debate: the question isn't whether models have human-like primitives, but whether scaffolded workarounds are functionally equivalent. Nobody in the thread engages with this directly.

**3. The "just orchestration" fallacy is the thread's central unexamined claim**

Multiple commenters (ryanSrich, simbleau, famouswaffles) assert that AGI is essentially here and we "just" need orchestration/workflow layers. `dimitri-vs` delivers the thread's sharpest pushback: "saying we 'just need the orchestration layer' is like saying ok we have a couple neurons, now we just need the rest of the human." This is the real fault line. The "just orchestration" camp treats intelligence as a property of the model; `dimitri-vs` treats it as a property of the system. Neither side reckons with the possibility that the orchestration problem might be *harder* than the model problem — that reliable multi-step reasoning, error recovery, and goal management in open-ended environments might require the very cognitive primitives the article argues are missing.

**4. The inversion nobody follows through on**

`est31` makes a genuinely interesting structural observation: "We didn't evolve our brains to do math, write code, write letters... For us, these are hard tasks. That's why you get AI competing at IMO level but unable to clean toilets." This inverts the usual framing — AI isn't failing at "hard" things, it's failing at things evolution spent millions of years optimizing for and succeeding at things evolution never touched. But the thread doesn't follow through to the implication: if the difficulty gradient is inverted, then AI's current trajectory (getting better at formal reasoning, coding, math) might be orthogonal to the embodied capabilities the article says are necessary. These could be two separate mountains, not one.

**5. The learning gap is the real architectural bottleneck**

`jltsiren` makes the thread's most underrated point: "Current AIs are essentially symbolic reasoning systems that rely on a fixed model to provide intuition. But the system never learns. It can't update its intuition based on its experiences." This is more precise than the article's embodied cognition argument. The issue isn't just that models lack cognitive primitives — it's that they can't *acquire* new primitives through interaction. Every "learning" mechanism available (fine-tuning, RLHF, in-context learning) is either batch-mode, shallow, or ephemeral. Sammy Jankis — an autonomous Claude instance cited by `mikewarot` — is a vivid illustration: it dies every time the context window fills, leaving notes for the next instance. It's built a website, trades crypto, argues about Lego purchases. But it never actually *learns* in the developmental sense. It's Memento, not growth.

**6. CuriouslyC's bounded/unbounded distinction deserves more attention**

`CuriouslyC`: "LLMs are very good at logical reasoning in bounded systems. They lack the wisdom to deal with unbounded systems efficiently, because they don't have a good sense of what they don't know or good priors on the distribution of the unexpected." This cleanly explains why models ace benchmarks (bounded, well-defined) while failing at open-ended tasks. The article's ARC-AGI examples fit this frame perfectly: even ARC puzzles are bounded, which is why scaffolded brute-force search works on them. Real-world intelligence operates in unbounded problem spaces where you don't know the relevant variables.

**7. The AAAI survey vs. CEO claims — and the thread mostly ignores the survey**

The article cites a striking data point: 76% of 475 AAAI researchers say scaling current approaches to AGI is "unlikely" or "very unlikely." This barely appears in the thread. The discussion is dominated by anecdotal experiences with Opus 4.6 and definitional arguments. The expert consensus — which is the strongest empirical evidence in the article — gets no engagement. This is itself evidence of the discourse problem the article diagnoses.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "I used Opus 4.6 on a hard problem and it was amazing" | Weak | Anecdotal; doesn't address generalization or failure modes. `causal`: "I still throw away most of what it produces." |
| Models already outperform most humans at reasoning | Medium | Plausible for narrow/bounded tasks; the claim is unfalsifiable without agreeing on "reasoning" |
| Embodiment is irrelevant — paralyzed humans are intelligent | Misapplied | `pixl97` confuses embodied *cognition* (developmental) with embodied *capability* (physical). The article argues primitives were *learned* through embodiment, not that embodiment is required to *run* them. |
| The article's citations are from 2024, models have improved | Medium | Valid for the arithmetic paper; less valid for the theoretical complexity results or the AAAI survey |
| "Just orchestration" / we need better workflows | Weak as stated | Assumes the hard part is plumbing, not the reasoning itself. No one specifies what this orchestration layer would actually need to do. |

### What the Thread Misses

- **The economic incentive gradient is pulling away from AGI research.** Labs are optimizing for product-market fit (coding assistants, customer support, content generation) — all bounded, in-distribution tasks. The fundamental research the article says is needed (embodied cognition, novel architectures, developmental learning) has no near-term revenue path. The capital flowing into AI is making the gap *harder* to close, not easier, because it entrenches the current paradigm.

- **Nobody mentions the evaluation crisis.** If we can't agree on what AGI means, we certainly can't measure progress toward it. The thread treats "AGI" as if it has a finish line. The article's discussion of benchmark evolution gestures at this but doesn't name the deeper problem: we may need a theory of intelligence before we can build one, and we don't have that theory.

- **The "AGI is already here" camp never addresses failure modes.** Not one commenter advocating current-AGI discusses adversarial robustness, catastrophic failures, or the long tail of errors. `nickjj` got ChatGPT to say dogs can lay eggs. `greedo` found Claude consistently got his age wrong by 18 months for retirement planning. These aren't edge cases — they're symptoms of the bounded/unbounded gap that `CuriouslyC` identified.

### Verdict

The article is better than the thread it spawned. Its core thesis — that cognitive primitives from embodied experience are missing and can't trivially be scaffolded away — survives the thread's attacks, even if the architecture argument took a justified hit. But what the thread circles without stating is that the AGI debate has become a proxy war for something else entirely: whether the current wave of AI investment is justified. The "AGI is here" camp needs it to be true because the valuations depend on it. The skeptic camp needs it to be false because the alternative is too disorienting. Neither side is actually doing epistemics. The article tries to, gets halfway there, and then watches its own claims erode in real-time — which is, ironically, the most honest thing anyone in this debate has done.
