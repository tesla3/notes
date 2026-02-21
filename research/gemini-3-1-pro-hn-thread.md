← [LLM Models](../topics/llm-models.md) · [Index](../README.md)

## HN Thread Distillation: "Gemini 3.1 Pro"

**Source:** [HN thread](https://news.ycombinator.com/item?id=47074735) (935 points, 889 comments) · [Blog post](https://blog.google/innovation-and-ai/models-and-research/gemini-models/gemini-3-1-pro/) · Feb 19, 2026

**Article summary:** Google releases Gemini 3.1 Pro, a point release over 3 Pro with the headline claim of doubling ARC-AGI-2 score (31.1% → 77.1%). Available in preview across AI Studio, Vertex AI, Gemini CLI, Antigravity IDE, and the consumer Gemini app. Pricing unchanged ($2/M input, $12/M output). Blog post leans heavily on SVG generation demos and benchmark charts.

### Dominant Sentiment: Benchmark-impressive, practically frustrating

The thread is a case study in the growing gap between model intelligence (as measured by benchmarks) and model utility (as experienced in real workflows). Near-universal acknowledgment that Gemini is smart; near-universal frustration that it can't channel that intelligence reliably.

### Key Insights

**1. The intelligence-reliability gap is Gemini's defining problem**

The top comment ([spankalee], self-identified ex-Googler) sets the frame the entire thread orbits: "stunningly good at reasoning, design, and generating the raw code, but it just falls over a lot when actually trying to get things done." This isn't an edge case take — it's echoed by dozens of commenters across different use cases. The pattern: Gemini benchmarks near or above Opus/Codex, but in agentic loops it enters thinking loops, breaks structured output, makes drive-by refactors, and narrates tool calls instead of executing them. [datakazkn] names the mechanism: "Gemini tends to over-explain its reasoning mid-tool-call in a way that breaks structured output expectations." Anthropic and OpenAI treat tool calls as first-class operations; Gemini treats them as things to discuss.

**2. Anthropic's moat is behavioral tuning, not raw intelligence**

Several commenters converge on this independently. [bluegatty]: "Claude is definitively trained on the *process of coding* not just the code." [avereveard]: "Anthropic discovered pretty early with Claude 2 that intelligence and benchmark don't matter if the user can't steer the thing." [NiloCK]: "The breakthrough of Opus 4.5 over 4.1 wasn't an intelligence jump, but a jump in discerning scope and intent behind user queries." What's happening here is a market realization that instruction-following fidelity, task scoping, and knowing when to stop are *the* differentiating capabilities for coding agents — and they aren't captured by any existing benchmark. [mbh159] puts it sharply: "We have excellent benchmarks for reasoning. We have almost nothing that measures reliability in agentic loops. That gap explains this thread."

**3. The ARC-AGI-2 doubling is real but suspect**

31.1% → 77.1% in a point release is extraordinary. Multiple commenters flag this as likely benchmark-focused optimization rather than general capability gain. [ponyous] provides a useful data point: 3.1 costs 2.6x more per generation and is 2.5x slower than 3.0, suggesting the improvement comes largely from increased thinking budget. [Topfi] is more direct: "Appears the only difference to 3.0 Pro Preview is Medium reasoning." [culi] notes the ARC-AGI cost-per-task has increased 4.2x. This looks like buying benchmark points with compute, not a fundamental capability leap — which would explain why users aren't seeing proportional real-world improvement.

**4. Google's product/billing chaos is a meaningful competitive disadvantage**

This isn't just griping — it's a structural barrier to adoption. [horsawlarway]'s rant about billing is representative of a dozen similar comments: "17 different products, all overlapping, with myriad project configs, API keys that should work then don't." [Robdel12] accidentally spent $10 and couldn't figure out the billing UI. [amluto] contrasts: OpenAI signup is trivial, Anthropic has a minimum purchase but is clear, Google requires figuring out IAM rules first. [cmrdporcupine] can't even find the model in Gemini CLI despite having a subscription. And 3.0 Pro is *still* in preview — they're releasing 3.1 preview on top of an un-GA'd 3.0. [mijoharas] notes some deprecated models have no suggested replacement. This is textbook Google product management dysfunction applied to a market where Anthropic and OpenAI are making onboarding frictionless.

**5. Cost advantage is real but overrated in current market**

[sdeiley]'s lead argument — Gemini is half the cost of Opus — generated the most pushback of any claim. [startages] provides live experiment data: Gemini Pro spent $18 on a task where Opus spent $4 because of reasoning token bloat. [mritchie712]: "It's half the price per token. Not all tokens are generated equally." [sothatsit] draws the analogy to share prices — per-token cost is meaningless without knowing token consumption. At the current stage of AI coding adoption, practitioners are optimizing for output quality and developer time, not API cost. As [fastball] puts it: "We are not at the moment where price matters. All that matters is performance."

**6. The pelican SVG benchmark is being benchmaxxed to death**

Simon Willison's pelican-on-a-bicycle test has become so famous that multiple commenters note it's likely in training data now. Google's own blog post leads with animated SVG demos. [jasonjmcghee] flags that Jeff Dean personally highlighted pelican SVG quality — "The most absurd benchmaxxing." [roryirvine] provides a useful control: "creation of other vector image formats (eg. PostScript) hasn't improved nearly so much. Perhaps they're deliberately optimising for SVG generation." [ertgbnm]: "Gemini has beat the benchmark and now differences are just coming down to taste... we need a new vibe check."

**7. Flash is the sleeper — practitioners want 3.1 Flash, not Pro**

Scattered but consistent signal: several commenters prefer Flash for daily work. [attentive]: "Flash 3.0 with opencode is reasonably good and reliable coder. I'd rate it between haiku 4.5 and sonnet. Closer to sonnet." [mark_l_watson] uses Flash as primary API. [hsaliak]: "Flash is awesome. What we really want is gemini-3.1-flash." [pawelduda]: "The current [Flash] is so good & fast I rarely switch to pro anymore." Flash's cost/speed profile may matter more than Pro's benchmark scores for high-volume agentic use.

**8. One star comment: the fabrication test**

[conception] describes a brilliantly simple test — asking models about an obscure BBS door game from the 1990s. "OpenAI and Google's Deep Research produce a very long, 100% made up report. If I question the AI on the report, they both admit they just made it up. Claude just returns, 'I couldn't find anything.'" This gets at a deeper issue than benchmarks: calibration of confidence. The willingness to say "I don't know" is a form of intelligence that no current benchmark captures.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Gemini is half the cost" | Weak | Per-token price ≠ per-task cost when model burns 4x tokens thinking |
| "Benchmarks prove it's best" | Medium | ARC-AGI-2 gain is real but appears compute-bought; no agentic benchmarks shown |
| "Just use it in Antigravity/OpenCode" | Medium | Harness matters, but underlying tool-calling weakness persists across harnesses |
| "SVG generation proves visual reasoning" | Weak | Likely trained specifically for SVGs; doesn't generalize to PostScript or 3D |

### What the Thread Misses

- **The thinking token problem is structural, not a bug.** Gemini's verbose internal reasoning isn't just annoying — it actively sabotages agentic workflows by injecting narration into tool-call sequences. This may be an architectural choice (train of thought as safety mechanism?) rather than something a point release can fix.
- **Nobody asks why Google can't dogfood their way to better agentic behavior.** [motoboi] comes closest: "how else would they not have the RL trajectories to get a decent agent?" The answer might be that Google's internal coding tools are so different from the external products that internal usage doesn't generate transferable signal.
- **The preview-on-preview release pattern suggests Google's model release pipeline is broken.** 3.0 never reached GA. 3.1 is preview on top of preview. Models are being deprecated without replacements. This isn't just confusing — it means no enterprise can safely build on Gemini models without expecting forced migration.
- **No one connects Google's data advantage to the instruction-following deficit.** Google crawls more code than anyone, but the gap is in behavioral tuning, not knowledge. You can't crawl your way to better task scoping — you need curated human feedback on process, which is exactly what Anthropic invested in early.

### Verdict

Gemini 3.1 Pro is a model that benchmarks like a top-3 hire but works like a brilliant intern who can't stop talking during meetings. The thread circles but never quite names the core dynamic: **Google is optimizing for intelligence while Anthropic optimizes for agency, and in February 2026, agency is what practitioners are paying for.** The ARC-AGI-2 doubling is impressive but irrelevant to the user who can't get Gemini to stop refactoring code it wasn't asked to touch. Until Google builds (or acquires) Anthropic-grade behavioral tuning — and fixes a product/billing experience that actively repels potential converts — the benchmark crown will continue to be a consolation prize.
