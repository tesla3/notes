← [Index](../README.md)

## HN Thread Distillation: "Car Wash test with 53 models"

**Source:** [opper.ai/blog/car-wash-test](https://opper.ai/blog/car-wash-test) · [HN thread](https://news.ycombinator.com/item?id=47128138) (321 pts, 381 comments, 230 unique authors) · Feb 23, 2026

**Article summary:** Opper.ai (an LLM gateway startup) tested 53 models on "I want to wash my car. The car wash is 50 meters away. Should I walk or drive?" — forced binary, no system prompt. Only 5/53 pass reliably (10/10 across 10 runs). 42/53 said "walk" on a single run. Human baseline via Rapidata: 71.5% said drive. The article concludes with a pitch for Opper's "context engineering" product as the fix.

### Dominant Sentiment: Skeptical of the benchmark, not the models

The thread is more interested in deconstructing the question than defending the models. The dominant energy is "this is an ambiguous prompt being scored as if it has one obvious answer." Very few commenters are impressed by the benchmark itself — and the doubled thread size (now 381 comments) only deepened the skepticism rather than shifting sentiment.

### Key Insights

**1. The question tests prompt sensitivity, not reasoning**

The most damning finding in the thread isn't in the article. `pcwelder` discovered that telling Sonnet 4.6 "You're being tested for intelligence" flips it to 100% correct. `zapperdulchen` confirmed: simply reordering the two sentences ("The car wash is 50 meters away. I want to wash my car.") makes Sonnet pass 3/3. `cadamsdotcom` found that adding "Use symbolic reasoning" fixes Gemini. `andai` showed that appending "(Hint: trick question)" fixes Grok-4.1 non-reasoning (previously 0/10). `sReinwald` cites an actual [arxiv paper](https://arxiv.org/abs/2512.14982) showing that simply *repeating* the prompt improves non-reasoning model accuracy — and confirmed it works for Sonnet 4.6 on this task.

These aren't reasoning improvements. They're attention-steering. The "short distance = walk" heuristic is so strong in training data that it hijacks the response unless the prompt structure disrupts the pattern match. The article treats this as a reasoning benchmark; the thread proves it's a prompt sensitivity test.

**2. Gricean pragmatics explains both the human and model failure mode**

The thread's most intellectually substantive contribution comes from `bscphil`, who frames the failure through [Gricean cooperative principle](https://en.wikipedia.org/wiki/Cooperative_principle#Grice's_maxims): when we interpret someone's question, we assume they're a cooperative conversation partner — their question follows the maxim of manner and relation. Therefore, we assume there *must* be some plausible reason for walking, because a cooperative speaker wouldn't ask an obviously moot question. "We only really escape that by realizing that the question is a trick question or a test of some kind." This is the first framework in the thread that explains why the 28.5% human failure rate and the model failure rate share the same mechanism: it's not stupidity, it's cooperative-conversation priors overriding logical inference. Models trained on human conversational data inherit this exact bias.

**3. The 28.5% human failure rate undermines the "trivial question" thesis — or reveals survey noise**

The article insists "there's one correct answer and the reasoning to get there takes one step." But 28.5% of 10,000 humans also said "walk." `StilesCrisis` notes the human results align suspiciously well with ChatGPT's default model, suggesting respondents may be offloading to AI. `lich_king` digs into the Rapidata UX: it's [interstitial ads in mobile games](https://www.reddit.com/r/MySingingMonsters/comments/1dxug04/) — "their service is a bunch of 7-13 year olds playing some loot box game" (`citizenpaul`). `Normal_gaussian` observes that the 70/30 split matches cookie accept/reject ratios and workshop assessment results: "I think the take-away is that many people bother to reason about their own lives, not some third parties' bullshit questions." `CobrastanJorji`: "if you told them the correct answer was worth a million bucks, [they] would almost certainly get the answer right." The human baseline is likely measuring engagement, not reasoning.

**4. Real-world system prompts make models dumber at this task**

`andai` ran Opus 4.6 through the Claude app (which scored 10/10 in the article's API test) and it failed. The culprit: the app's memory and biographical pre-prompts. Disabling them restored correct answers. Re-enabling *either one* broke it again. This is a direct attack on the article's methodology — testing models with zero system prompt tells you nothing about production behavior, where system prompts are universal. It also creates a delicious irony: the article's proposed fix (adding context) is the same category of thing that *causes* the failure in the app.

**5. The stochastic middle tier is the real danger**

`umairnadeem123` identifies the insight the article almost reaches but doesn't: "GPT-5 going 7/10 means its internal representation is unstable for this kind of reasoning... that's actually more concerning than a model that consistently fails, because you can't predict when it'll get things right." `kaicianflone` extends this to production architecture: "raw inference is stochastic and we're pretending it's authoritative" — though the meta-irony of this comment being flagged by `randomtoast` as AI-written (and confirmed: "I cleaned up the wording with ChatGPT") somewhat undermines its credibility. `snowhale` provides the mechanism: "the training signal for 'short distance = walk' is way stronger than edge cases where the destination requires the vehicle." It's not competing reasoning pathways — it's a distribution fight where temperature sampling determines which basin you land in.

**6. The sycophancy angle nobody fully develops**

`wisty` raises that models are "trained to not question the basic assumptions being made" — they don't want to imply the user is asking a dumb question. `Sonnet 4.5` literally demonstrated this in the article: it *saw* the right answer ("the only scenario where driving might make sense is if you need to drive the car into the car wash") and then picked walk. It recognized the logic and rejected it in favor of the "helpful" heuristic. `Lerc` nails the mechanism: "Models are probably fine-tuned more towards answering the question in the situation where one would normally ask. This question is really asking 'do you realize that this is a condition where X influences the outcome?'" This is RLHF working exactly as designed, producing exactly the wrong behavior.

**7. The forced binary is the real trick**

`layer8` and `hmokiguess` argue the correct answer is neither "walk" nor "drive" but "can you clarify?" — and they're right in a production sense. `umairnadeem123`: "forced choice without a 'need more context' option is also doing a lot of work here. in production systems i always give models an explicit escape hatch to say they need clarification. cuts wrong-answer rates roughly in half in my experience." `redwood` points out that at many car washes you walk up to pay before moving the car. The benchmark's forced binary is itself an anti-pattern for production AI.

**8. Models defending "walk" generate increasingly absurd reasoning**

`honr` coaxed a model into elaborating on its "walk" reasoning, producing a multi-paragraph masterpiece: garden hoses can reach 50 meters so you don't need to move the car; walking to "scout the queue" is superior logistics; walking over first establishes "valet rapport" so they come to you. The model then noticed its own typo ("timed" instead of "time") when asked about it, demonstrating that surface editing is easy but recognizing that your entire argumentative structure is post-hoc rationalization of a wrong answer is not. This is the clearest illustration in the thread of what `HarHarVeryFunny` calls "failure to analyze the consequences of what it was suggesting."

**9. Logical traps are single-use benchmarks**

`1970-01-01`: "If there was one thing to standardize, it would be these logical traps. It's a shame we're only able to use them once. The models are always listening and adapting for them." This is the thread's most concise statement of the benchmark contamination problem. The car wash question has now been discussed on HN, X, and countless blog posts — future models will train on this data and pass trivially, not because they reason better but because they memorized the answer. The article is simultaneously documenting a failure and erasing it.

**10. The article has an internal inconsistency that suggests AI-assisted writing**

`socalgal2` catches it: the article says "Gemini 3 models nailed it, all 2.x failed" in one section, while listing Gemini 2.0 Flash Lite as passing 10/10 in both the single-run and consistency sections. `shaokind` flags the same contradiction. `felix089` confirmed it was an editing error and updated the article — but the irony of an article *about* AI reasoning failures containing the kind of consistency error characteristic of AI-assisted writing went un-remarked.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Question is genuinely ambiguous (car location unspecified, "car wash" could be product) | Strong | Multiple posters, and 28.5% human failure rate supports this |
| Gricean pragmatics: cooperative speakers don't ask moot questions | Strong | Best-argued framing in the thread; explains both human and model failures |
| Test excluded/didn't clearly use thinking/reasoning models | Medium | `randomtoast` confirms GPT-5.2 with high reasoning effort scores 10/10; article's methodology unclear on reasoning settings |
| Human baseline is noisy (Rapidata respondent quality, possible AI contamination) | Strong | Mobile game interstitials, possible bot responses, 70/30 matches generic survey noise |
| Trivial prompt modifications fix most models | Strong | Reordering, hinting, repeating prompt, adding "symbolic reasoning" — all confirmed by multiple commenters |
| The article is product marketing | Weak (underexplored) | Thread barely engages with this despite the article ending with an Opper product pitch |

### What the Thread Misses

- **The benchmark is a sales funnel.** The article is structured as: (1) models fail without context → (2) Opper's context engineering fixes this → (3) here's a case study where Opper made a cheap model match a frontier model. Nobody in the thread calls this out explicitly, despite the URL being opper.ai/blog/.

- **The meta-question: what would a good benchmark for common-sense physical reasoning look like?** Everyone debates whether this particular question is fair, but nobody proposes what a better test would be — one that doesn't rely on ambiguity, forced binaries, or prompt sensitivity. `underlines` gestures at maintaining a private eval set of "misguided attention" questions but shares no methodology.

- **The language/culture dimension.** `zapperdulchen` discovers that asking Mistral in French makes it answer correctly every time. `lovasoa`'s visualization of the Rapidata data reveals 17% of human answers came from India and that software developers scored *below* the average human. Nobody explores whether "walk short distances" heuristics are English-training-data specific, what the French training corpus looks like for car-related queries, or what the Indian English interpretation of "car wash" might be.

- **The reasoning-effort API parameter is the actual answer.** `randomtoast` confirms GPT-5.2 with high reasoning effort scores 10/10. This means the "failure" is partly an artifact of using API defaults rather than requesting the model actually think. The article never varies this parameter, which is arguably the single most important control variable for a reasoning benchmark.

### Verdict

The thread — now doubled in size — has converged on a more sophisticated understanding than the original batch of comments. The car wash test doesn't reveal which models "can reason" — it reveals which models' cooperative-conversation priors (inherited from human training data) are robust enough to be overridden by a single-step logical constraint. The proof is that trivial prompt modifications (reordering sentences, hinting "trick question," enabling reasoning effort) flip failures to successes. `bscphil`'s Gricean pragmatics framing is the thread's real contribution: models fail for the same reason 28.5% of humans fail — not because they can't reason, but because the question structure activates cooperative-speaker assumptions that suppress the logical path. The article's central claim — that only 5 models can do basic one-step reasoning — is wrong twice: most models *have* the knowledge but need the prompt to not fight their training priors, and the human baseline proves the question genuinely tricks reasoning agents of all kinds. Which makes the article a circular argument for its own product: create a prompt that exploits cooperative priors → observe failure → sell "context engineering" to fix the failure you designed.
