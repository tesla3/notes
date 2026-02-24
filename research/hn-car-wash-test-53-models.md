← [Index](../README.md)

## HN Thread Distillation: "Car Wash test with 53 models"

**Source:** [opper.ai/blog/car-wash-test](https://opper.ai/blog/car-wash-test) · [HN thread](https://news.ycombinator.com/item?id=47128138) (165 comments, 144 points)

**Article summary:** Opper.ai (an LLM gateway startup) tested 53 models on "I want to wash my car. The car wash is 50 meters away. Should I walk or drive?" — forced binary, no system prompt. Only 5/53 pass reliably (10/10 across 10 runs). 42/53 said "walk" on a single run. Human baseline via Rapidata: 71.5% said drive. The article concludes with a pitch for Opper's "context engineering" product as the fix.

### Dominant Sentiment: Skeptical of the benchmark, not the models

The thread is more interested in deconstructing the question than defending the models. The dominant energy is "this is an ambiguous prompt being scored as if it has one obvious answer." Notably, very few commenters are impressed by the benchmark itself.

### Key Insights

**1. The question tests prompt sensitivity, not reasoning**

The most damning finding in the thread isn't in the article. `pcwelder` discovered that telling Sonnet 4.6 "You're being tested for intelligence" flips it to 100% correct. `zapperdulchen` confirmed: simply reordering the two sentences ("The car wash is 50 meters away. I want to wash my car.") makes Sonnet pass 3/3. `cadamsdotcom` found that adding "Use symbolic reasoning" fixes Gemini. `andai` showed that appending "(Hint: trick question)" fixes Grok-4.1 non-reasoning (previously 0/10).

These aren't reasoning improvements. They're attention-steering. The "short distance = walk" heuristic is so strong in training data that it hijacks the response unless the prompt structure disrupts the pattern match. The article treats this as a reasoning benchmark; the thread proves it's a prompt sensitivity test.

**2. The 28.5% human failure rate undermines the "trivial question" thesis**

The article insists "there's one correct answer and the reasoning to get there takes one step." But 28.5% of 10,000 humans also said "walk." The article waves this off, but the thread doesn't buy it. `capitrane`: "Either it's truly trick-shaped for people too, or forced binary questions amplify noise more than we think." `CobrastanJorji` offers the clearest rebuttal to the whole exercise: people who got it wrong in a rapid-fire survey "would almost certainly get the answer right" if told the correct answer was worth a million bucks. Same applies to models given better prompts — which the thread proved.

**3. Real-world system prompts make models dumber at this task**

`andai` ran Opus 4.6 through the Claude app (which scored 10/10 in the article's API test) and it failed. The culprit: the app's memory and biographical pre-prompts. Disabling them restored correct answers. Re-enabling either one broke it again. This is a direct attack on the article's methodology — testing models with zero system prompt tells you nothing about production behavior, where system prompts are universal. It also creates a delicious irony: the article's proposed fix (adding context) is the same category of thing that *causes* the failure in the app.

**4. The stochastic middle tier is the real danger**

`umairnadeem123` identifies the insight the article almost reaches but doesn't: "GPT-5 going 7/10 means its internal representation is unstable for this kind of reasoning... that's actually more concerning than a model that consistently fails, because you can't predict when it'll get things right." The article segments models into 3 tiers and calls the middle tier "most dangerous," but frames it as a product pitch rather than exploring the mechanism. `snowhale` provides the mechanism: "the training signal for 'short distance = walk' is way stronger than edge cases where the destination requires the vehicle." It's not competing reasoning pathways — it's a distribution fight where temperature sampling determines which basin you land in.

**5. The sycophancy angle nobody fully develops**

`wisty` raises that models are "trained to not question the basic assumptions being made" — they don't want to imply the user is asking a dumb question. `Sonnet 4.5` literally demonstrated this: it *saw* the right answer ("the only scenario where driving might make sense is if you need to drive the car into the car wash") and then picked walk. It recognized the logic and rejected it in favor of the "helpful" heuristic. This is RLHF working exactly as designed, producing exactly the wrong behavior.

**6. The forced binary is the real trick**

`layer8` and `hmokiguess` argue the correct answer is neither "walk" nor "drive" but "can you clarify?" — and they're right in a production sense. `umairnadeem123`: "forced choice without a 'need more context' option is doing a lot of work here. In production systems I always give models an explicit escape hatch... cuts wrong-answer rates roughly in half." The question's ambiguity is genuine: it doesn't specify where the car is, doesn't specify the user wants to wash *at* the car wash, and `redwood` points out that at many car washes you walk up to pay before moving the car. The benchmark's forced binary is itself an anti-pattern for production AI.

**7. The article has an internal inconsistency that suggests AI-assisted writing**

`socalgal2` catches it: the article says "Gemini 3 models nailed it, all 2.x failed" in one section, while listing Gemini 2.0 Flash Lite as passing 10/10 in both the single-run and consistency sections. `shaokind` flags the same contradiction. This is the kind of error a human editor catches but a model generating sections independently wouldn't — and it's notable in an article *about* AI reasoning failures.

**8. Perplexity's Sonar: right answer, deranged reasoning**

The article's funniest finding: Sonar models got "drive" by arguing that walking burns calories requiring food production energy, making walking more polluting. `floatrock` connects this to Sam Altman making literally the same calorie-based argument about AI energy use at an India summit that same weekend. The symmetry — a model arriving at the right answer via the same logic as the CEO defending AI's energy footprint — is a level of meta-irony the article doesn't seem to notice.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Question is genuinely ambiguous (car location unspecified, "car wash" could be product) | Strong | Multiple posters, and 28.5% human failure rate supports this |
| Test excluded thinking/reasoning models | Medium | Author says reasoning models were included; `tverbeure` notes model names like "kimi-k2-thinking" in the set |
| Human baseline is noisy (Rapidata respondent quality) | Medium | `tantalor` raised it, author clarified Rapidata has pre-screening; but `slongfield` cites Pew finding 15% of US adults under 30 claim nuclear submarine training |
| The article is product marketing | Weak (underexplored) | Thread barely engages with this despite the article ending with an Opper product pitch |

### What the Thread Misses

- **The benchmark is a sales funnel.** The article is structured as: (1) models fail without context → (2) Opper's context engineering fixes this → (3) here's a case study where Opper made a cheap model match a frontier model. Nobody in the thread calls this out explicitly, despite the URL being opper.ai/blog/.
- **The meta-question: what would a good benchmark for common-sense physical reasoning look like?** Everyone debates whether this particular question is fair, but nobody proposes what a better test would be — one that doesn't rely on ambiguity, forced binaries, or prompt sensitivity.
- **The language/culture dimension.** `zapperdulchen` discovers that asking Mistral in French makes it answer correctly every time. Nobody explores this — are "walk short distances" heuristics English-training-data specific? What does the French training corpus look like for car-related queries?

### Verdict

The thread exposes the article as measuring something real but misidentifying what it is. The car wash test doesn't reveal which models "can reason" — it reveals which models' training distributions are robust enough that the "drive to car wash" pattern survives competition with the much stronger "short distance = walk" pattern. The proof is that trivial prompt modifications (reordering sentences, adding "hint: trick question") flip failures to successes. This means the article's central claim — that only 5 models can do basic one-step reasoning — is wrong. Most models *have* the knowledge; they just need the prompt to not actively fight their training priors. Which is, ironically, exactly the "context engineering" the article is selling — making the benchmark a circular argument for its own product.
