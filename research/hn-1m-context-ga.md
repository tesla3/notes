## HN Thread Distillation: "1M context is now generally available for Opus 4.6 and Sonnet 4.6"

**Article summary:** Anthropic announces that Claude Opus 4.6 and Sonnet 4.6 now include the full 1M token context window at standard pricing (no long-context premium), with 6x more media per request (600 images/PDF pages), and automatic 1M context for Claude Code Max/Team/Enterprise users. Opus 4.6 scores 78.3% on MRCR v2, claimed highest among frontier models at that length.

### Dominant Sentiment: Excited but empirically skeptical

The thread buzzes with genuine enthusiasm — 1106 upvotes — but the most substantive comments are from practitioners who've already run into the gap between "supports 1M tokens" and "reasons well at 1M tokens." The celebration is real; the trust is conditional.

### Key Insights

**1. The coherence cliff is the real benchmark, not the context window size**

The thread's sharpest technical insight comes from `jeff_antseed`: *"the degradation isn't linear — there's something like a cliff somewhere around 600-700k where instruction following starts getting flaky and the model starts ignoring things it clearly 'saw' earlier."* Multiple practitioners independently confirm quality degrades around 150-200k regardless of window size. `jFriedensreich`: *"I can tell blindly at this point when 150-200k tokens are reached because the coding quality and coherence just drops by one or two generations."* `PeterStuer` hopes for 250k coherence. The gap between "context window" and "effective context" is well-understood by heavy users but completely absent from the blog post's framing.

**2. Standard pricing is the real signal — it implies architectural innovation**

`jeff_antseed` again: *"the fact that they're shipping at standard pricing is more interesting to me than the window size itself. That suggests they've got the KV cache economics figured out, which is harder than it sounds."* `cubefox` raises whether this means Anthropic has moved away from quadratic attention entirely. `bob1029` speculates they're using recursive/iterative processing rather than raw attention at 1M. The pricing decision reveals more about Anthropic's technical position than the feature announcement itself — they've either solved the cost problem or are subsidizing it as competitive positioning.

**3. Sophisticated users are converging on "don't fill the window" as the real technique**

The thread's star comment is `jeremychone`'s detailed breakdown of a code-map workflow: Flash generates per-file semantic summaries (summary, when_to_use, public_types, public_functions), an auto-context agent narrows 381 files to 5, and the big model works in 30-80k tokens. Result: *"Higher precision on the input typically leads to higher precision on the output."* `gskm` nails the principle: *"More context isn't free, even when the window supports it... 'I can fit more' and 'I should put more in' are very different things."* `sergiotapia` confesses this as an unlearning challenge. The irony: the users getting the best results from LLMs are the ones who least need 1M context.

**4. Compaction is the real pain point 1M solves — not raw context capacity**

The most emotionally charged comments aren't about needing more context; they're about compaction ruining sessions. `iandanforth`: *"it was always like a punch to the gut when a compaction came along... the model suddenly forgetting key aspects of the work."* `fnordpiglet` calls compacting a large context even worse: *"it defers it and makes it worse almost when it happens."* The announcement's real value for Claude Code users is fewer compaction events, not more tokens — Hex reports a 15% decrease. The feature is sold as "more room" but adopted as "fewer catastrophic forgetting events."

**5. The "AGI" vs "clueless junior" split reveals a task-topology dependence**

`dzink` declares *"Opus 4.6 is AGI in my book"*; `alienchow` describes it as *"a clueless junior engineer that never learns"* that negotiates against specs and litters repos with random markdown files. The difference isn't skill or prompting — it's task structure. Greenfield implementation with clear specs works brilliantly. Infrastructure work requiring OSS forks, cross-cluster Helm charts, and undocumented arg combinations fails consistently. `prmph`: *"For basic implementation of a detailed and well-specced design, it is capable."* The models are strong at tasks that look like training data and weak at tasks that don't. This isn't news, but the thread demonstrates it's getting *more* polarized as models improve, not less.

**6. The cost model is confusing even power users**

`aragonite` asks whether long sessions burn budgets faster — yes, since every turn resends the full conversation. `dathery` calculates: *"at 800k tokens with all cached, the API price is $0.40 per request... you can easily end up making many $0.40 requests per minute."* `holoduke` reports hitting 5-hour limits in 5-10 minutes across three Max subscriptions. `pixelpoet` burned 13% of weekly usage in a handful of prompts. `LoganDark` pays $200/mo and still can't use fast mode without extra billing. The pricing is "standard" but the consumption model makes costs non-obvious — a 1M window at standard per-token rates is still enormously expensive per turn when you're deep in a session.

**7. Multi-model routing is emerging as the real skill**

`vessenes` suggests pairing Opus with Codex/DeepThink for audit, noting *"opus is still prone to... enthusiastic architectural decisions."* `petesergeant` reports Codex finding genuine bugs that would have shipped if trusting Claude alone. `jeremychone`'s workflow uses Flash for indexing, GPT-5.4 or Opus for coding. `gregharned` frames it as routing: *"Opus 4.6 at 1M is overkill for 80% of coding tasks. The ROI only works if you're being intentional about when to use it."* The emerging best practice is orchestration across models, not loyalty to one.

### Anecdotal Effective Context Lengths

| Who | Effective ceiling | Detail |
|-----|------------------|--------|
| `jFriedensreich` | **150-200k** | *"I can tell blindly at this point when 150-200k tokens are reached because the coding quality and coherence just drops by one or two generations."* |
| `PeterStuer` | **<250k** | *"I'm hoping 250k"* — implying current experience is below that |
| `chaboud` | **400-500k** | Soft-triggered compaction at 400k with Sonnet 4.5 because *"it wandered off into the weeds at 500k"*; notes 4.6 is more stable |
| `jeff_antseed` | **600-700k** | *"there's something like a cliff somewhere around 600-700k where instruction following starts getting flaky"* — instruction-following, not deep reasoning |
| `vessenes` | **~256k equivalent** | *"The stats claim Opus at 1M is about like 5.4 at 256k"* — citing Anthropic's benchmarks on needle tests, not his own measured ceiling; adds *"I haven't seen dramatic falloff in my tests"* |
| `MorkMindy74` | **~100k usable, decay after** | *"Context decay is real — I've noticed quality dropping toward the end of long inputs even when the relevant text is there"* |
| `bob1029` | **avoids >100k** | *"The performance is simply terrible. There's no training data for a megabyte of your very particular context."* |
| `jeremychone` | **30-80k** | Deliberately stays here via code-map workflow; never needs more than 200k even with Gemini's 1M available |
| `mvrckhckr` | **~200k** | *"I never get to more than 20% of the 1M context window, and it's working great"* |
| `gskm` | **N/A (structural)** | The problem isn't distance — it's noise: *"By 700k you're not testing long-context reasoning, you're testing the model's ability to find signal in a haystack it built itself"* |

**Rough consensus:** Reasoning quality holds to ~150-200k. Instruction-following stretches to maybe 400-500k. Beyond that you're paying for retrieval (needle-in-haystack), not comprehension. The practitioners getting the best results engineer their workflows to stay well under 100k.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Quality degrades well before 1M | Strong | Multiple independent confirmations of ~150-200k effective ceiling |
| "Just write the code yourself" | Weak | `AussieWog93`'s rebuttal — time-constrained professionals getting things done that otherwise wouldn't happen — is decisive |
| This is just a way to get people to spend more tokens | Medium | Plausible for API users; for Max subscribers the economics actually improve |
| Compaction was already good enough | Weak | Thread overwhelmingly disagrees; compaction is consistently described as traumatic |

### What the Thread Misses

- **Nobody asks about prompt injection risk at 1M.** A million-token window is a million-token attack surface. Loading entire codebases or "full due diligence bundles" means ingesting untrusted content at scale. Zero discussion.
- **The infrastructure use case is systematically failing and nobody's diagnosing why.** `alienchow`'s detailed report of Helm/CNI failures gets no serious replies. This is a hard constraint on where agentic coding actually works, and it's being hand-waved away as a "skill issue."
- **The "context as RAM" metaphor (`jf___`'s elaborate post) is precisely wrong** in the way that matters most: RAM has uniform access time; transformer attention does not. The metaphor flatters the technology by implying a property it lacks.
- **Selection bias is rampant.** The thread is dominated by people who already pay $100-200/mo for AI coding tools — they're optimizing marginal gains on workflows already designed around LLM strengths. The much larger population of developers for whom this is irrelevant is silent.

### Verdict

The thread reveals that 1M context is simultaneously a genuine infrastructure improvement and a distraction from the actual bottleneck. The effective coherence window hasn't moved much — it's still somewhere around 150-200k — and the most productive users are the ones who figured out how to stay *under* that ceiling through indexing, routing, and semantic compression. What 1M actually buys is insurance against compaction, which matters enormously for session continuity but not at all for reasoning quality. Anthropic's real flex here is the pricing: shipping 1M at standard rates is either an architectural breakthrough or a strategic loss-leader, and the thread doesn't have enough information to distinguish the two. The question nobody's asking is whether "fill the window" workflows will produce a generation of developers who confuse context size with comprehension — and what happens when they hit the coherence cliff at scale.
