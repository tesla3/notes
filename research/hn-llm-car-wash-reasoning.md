← [Index](../README.md)

## HN Thread Distillation: "I want to wash my car. The car wash is 50 meters away. Should I walk or drive?"

**Source:** [Mastodon post](https://mastodon.world/@knowmadd/116072773118828295) showing screenshots of multiple LLMs recommending "walk" when asked about getting to a car wash 50m away — missing that the car itself must be present to be washed. 1511 points, 948 comments.

**Article summary:** A Mastodon user (@knowmadd) posted screenshots of several LLMs all confidently recommending walking 50 meters to a car wash, none recognizing that the car must physically accompany you. The post went viral on TikTok (~3.5M views) before hitting HN.

### Dominant Sentiment: Gleeful but fractured along tribal lines

The thread oscillates between "gotcha!" satisfaction and defensive "well MY model gets it right." Roughly 40% of comments are people pasting raw LLM output — a dynamic globular-toast aptly calls out: "The majority of people just pasting stuff they got from LLMs when trying it themselves. Totally uninteresting, lazy and devoid of any thought/intelligence." The thread is itself a demonstration of the LLM-mediated discourse it's critiquing.

### Key Insights

**1. The answer is chosen before the reasoning — autoregressive generation's original sin**

shagie provides the sharpest technical observation in the thread: the "walk" token gets selected early based on the "short distance → walk" pattern, and then everything that follows is post-hoc rationalization. When shagie forced ChatGPT to enumerate necessary conditions *before* answering, it correctly identified that the car must be present and selected "drive." This isn't a reasoning failure in the traditional sense — it's a generation-order problem. The model commits to a conclusion in its first few tokens and then confabulates justification. This is exactly how chain-of-thought prompting and "thinking" modes help: they insert reasoning tokens *before* the commitment point.

> shagie: "The inability for ChatGPT to go back and 'change its mind' from what it wrote before makes this prompt a demonstration of the 'next token predictor'. By forcing it to 'think' about things before answering... [it] was able to reason about."

**2. The System 1/System 2 framing is the thread's best explanatory model — but nobody follows it to its economic conclusion**

keeda demonstrates that appending "Make sure to check your assumptions" — without specifying *which* assumptions — restores correct answers even on weak models. This maps cleanly to Kahneman's System 1/System 2 distinction. But keeda also surfaces the key insight everyone else misses: *this is an intentional cost optimization by providers.* The correct answer burns more tokens. Defaulting to "System 1" fast inference is cheaper and right often enough to be the profit-maximizing default. The models aren't incapable — they're economizing. The providers have a financial incentive to keep the default cheap.

> keeda: "So why don't the model providers have such wordings in their system prompts by default? ... Likely the default to System-1 type thinking is simply a performance optimization because that is cheaper."

**3. The "ambiguous question" defense gets demolished — but reveals something real about RLHF**

Several commenters (cynicalsecurity, momentary, natmaka) argue the question is underspecified. dataflow eviscerates this: "If the car is already at the car wash then you can't possibly drive it there. So how else could you possibly drive there? Drive a *different* car?" The question has exactly one reasonable interpretation for any human listener. But the defenders accidentally point toward something real: RLHF trains models to assume the user is asking a sensible question and to provide a helpful answer rather than questioning the premise. wisty articulates this well — models are "trained to make us feel clever by humouring our most bone headed requests." The failure isn't in parsing; it's in a trained reflex to always produce a helpful-sounding answer to the question-as-phrased rather than the question-as-meant.

**4. The whack-a-mole patching cycle is the real story, not the individual failure**

tlogan reports the TikTok video went viral a week before HN, and models were already being patched. cracki confirms Gemini *admitted knowledge of the meme when asked.* flowerthoughts then demonstrates the patch is brittle: changing "car wash" to "workshop" and "wash" to "repair" bypasses it entirely, and Opus 4.6 fails again. This is the benchmark contamination problem applied to common sense. Each viral failure gets spot-fixed, creating an illusion of improving reasoning while the underlying failure mode persists. The fix is memorization, not generalization.

> flowerthoughts: "changing it to 'I want to repair my car. The workshop is 50 meters away' ... Really suggests it assumes the car is already there."

**5. Non-determinism makes single-shot anecdotes meaningless — but the thread runs on them**

pu_pe makes the methodological point almost nobody heeds: "one thing that needs to die very fast is to assume that you can test what it 'knows' by asking a question." kombine reports Sonnet 4.5 gives the wrong answer one out of five times. gurjeet shows GPT 5.2 with *extended thinking* fails on the third attempt despite succeeding twice. cuillevel3 is right that someone should run this 1000 times per model, but nobody does — because single anecdotes are more shareable than statistical distributions. The thread is 948 comments of people rolling a die once and reporting the result as a property of the die.

**6. jibal's exchange with Claude Sonnet 4.5 is the thread's star comment — three corrections deep and still fumbling**

jibal posts a multi-turn exchange where Claude Sonnet 4.5 gets the answer wrong, then when told it's ignoring something obvious, guesses the wrong thing (drive-through vs self-service), then when told that's irrelevant, *still* gets the reason wrong ("because after washing the car, you need to drive it back home!"), and only on the fourth exchange finally identifies the actual constraint. This is devastating not because the model fails — but because it demonstrates that even explicit correction doesn't reliably produce understanding. The model isn't updating a world model; it's generating plausible-sounding corrections. Claude's own meta-comment — "it's embarrassing that after you pointed out what I was missing, I still fumbled the explanation" — is itself just another plausible-sounding token sequence.

**7. The "coding works but common sense doesn't" paradox has a simple explanation**

sjducb marvels: "It still blows my mind that this technology can write code despite unable to pass simple logic tests." But this isn't paradoxical. Code has immediate verifiable feedback (compilers, tests, type systems). Common sense has no equivalent verification loop. aaronbrethorst gets closest: "LLMs seem to work best in a loop with tests. If you were applying this in the real world with a goal... it'd pretty quickly figure out that the end goal was unreachable." The models aren't smart or stupid — they're as good as their feedback loops. Code has tight loops; open-ended questions have none.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "The question is ambiguous/underspecified" | Weak | dataflow demolishes this. No human would interpret it as needing a second car. |
| "My model gets it right" | Misapplied | Single-shot anecdotes on a non-deterministic system. Try it 100 times. |
| "Humans fail trick questions too" | Medium | True (didgetmaster, Saline9515 re: breakfast question) but misses the asymmetry: humans have the *mechanism* for common sense even when tricked; the question is whether LLMs do. |
| "Just prompt better" | Medium | Works (keeda, shagie), but as FatherOfCurses says: "That's just Steve Jobs saying 'you're holding it wrong.'" |
| "They've already patched it" | Strong evidence of a problem | Spot-fixing viral failures ≠ fixing reasoning. flowerthoughts' variant proves the patch is brittle. |
| "RLHF/environmentalism bias causes this" | Weak-to-Medium | deliciousturkey, kqr suggest "walk not drive" is alignment bias. Possible contributing factor, but the failure persists even when framed neutrally. |

### What the Thread Misses

- **The constraint-checking problem is the agentic AI risk in miniature.** If a model can't verify that its plan satisfies the goal's prerequisites for a one-step task, what happens in a 50-step agentic workflow? dotdi gestures at this but nobody develops it. Each intermediate step is a potential "should I walk" moment, and the error compounds multiplicatively. A 95% per-step accuracy rate gives you a 7.7% chance of a fully correct 50-step plan.

- **Nobody tests the "thinking" tax.** Opus 4.6 with extended thinking nails it; without thinking, it sometimes fails. But thinking modes are 5-20x more expensive. The real question isn't "can models solve this" but "at what cost, and who decides when to pay it?" This is a resource allocation problem that will shape how models are deployed in practice.

- **The thread treats this as a binary (models can/can't reason) when it's actually a question about default inference budgets.** Models are already capable of solving this — with thinking, with better prompts, with explicit constraint-checking. The failure is in the *default configuration*, which is a product decision, not a capability limit. This distinction matters enormously for predicting where AI goes next.

- **The "I asked it and it worked for me" comments are themselves an LLM-era epistemological problem.** How do you form reliable beliefs about a non-deterministic system based on anecdotal single-shot tests? The thread has no answer, and neither does the field.

### Verdict

The car wash question is a clean demonstration of a specific failure mode — premature token commitment followed by post-hoc rationalization — not a referendum on whether LLMs "can reason." The thread treats it as one, which is why it generates heat but little light. The deeper signal is in the *response* to the failure: spot-patching that breaks on trivial variations, non-deterministic behavior that makes any individual test meaningless, and a trained reflex to produce confident answers rather than identify missing constraints. These are architectural and economic properties of how LLMs are built and deployed, not bugs to be fixed. The question isn't whether your favorite model passes this specific test today — it's whether the *class of failure* (goal-constraint violations in common-sense reasoning) is being systematically addressed or just individually patched as each one goes viral.
