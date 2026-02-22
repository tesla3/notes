← [Index](../README.md)

## HN Thread Distillation: "Experts Have World Models. LLMs Have Word Models"

**Source:** [Latent Space](https://www.latent.space/p/adversarial-reasoning) (Ankit Maloo, edited by swyx) · [HN thread](https://news.ycombinator.com/item?id=46936920) · 238 points, 272 comments, 101 unique authors

**Article summary:** LLMs fail in adversarial/multi-agent domains because they're trained to produce text that sounds good in isolation rather than text that survives contact with self-interested opponents. The chess/poker taxonomy: chess-like tasks (deterministic, perfect information) are LLM-tractable; poker-like tasks (hidden state, information asymmetry, recursive opponent modeling) are not. The fix is RL in multi-agent environments, not more scale.

### Dominant Sentiment: Intrigued but unconvinced by the binary

The thread broadly accepts the core observation—LLMs lack adversarial robustness—but aggressively attacks the chess/poker framing as too clean. The most engaged commenters are ML practitioners and domain experts who find the taxonomy useful but leaky.

### Key Insights

**1. The article's own example refutes its strongest claim**

IanCal delivers the thread's most damaging counterpoint: he pastes the article's Slack message example into ChatGPT and simply adds "review." The model immediately identifies every failure the article attributes to expert-only reasoning—Priya's triage heuristics, the cost of vagueness, the need for bounded time commitments—and produces three alternative drafts graded by scenario. The output is nearly identical to the "experienced coworker" version the article presents as beyond LLM capability.

This directly undermines the article's Step 1 claim (models can't detect when a situation is strategic). They *can*—they just need the prompt to frame the task as evaluation rather than generation. The gap the article describes is real but narrower than presented: it's a UX/prompting failure as much as an architectural one.

**2. The chess/poker taxonomy is a category error for real domains**

measurablefunc hammers this repeatedly: both chess and poker are finite, closed games with complete rule sets. Programming—the article's poster child for "chess-like"—is neither finitely axiomatizable nor has a win condition. Comparing programming to finite games is comparing across fundamentally different mathematical categories. The article's analogy breaks precisely where it matters most.

pixl97 adds quantitative teeth: chess has ~10^44 legal board states; any Turing-complete application has a state space exceeding the entropy of the visible universe. The "bounded" label for programming doesn't survive contact with combinatorics.

The author (ankit219) responds that bounded domains are about reasoning narrowing search space, not absolute state count. This is a reasonable rescue, but it concedes the framing is misleading—the actual distinction is "amenable to search" vs. "requires opponent modeling," which is subtler than chess vs. poker suggests.

**3. The multimodality debate reveals where the real ceiling is**

D-Machine produces the thread's most technically substantive argument chain: current "multimodal" models are multimodal in a limited, one-directional way. Text improves vision tasks, but vision/audio representations don't meaningfully improve textual reasoning. Most model architectures use separate backbones with limited cross-pollination, not truly integrated sensory processing.

This matters because the article's "word model" framing implicitly suggests multimodality would fix things. D-Machine argues it won't yet: "LLMs are indeed still mostly constrained by their linguistic core." The interesting frontier is work like V-JEPA-2 and Sam-3D that actually use visuospatial representations *for reasoning*, not just as inputs to text generation.

**4. "Text is the residue of action"—the thread validates this but doesn't go far enough**

toss1 provides the thread's best empirical testimony: CNC fabrication parameters (deterministic, chess-like) work brilliantly with ChatGPT. But a biglaw attorney in the family finds it "awful, and definitely in the ways identified." The twist: toss1 adds a *second* failure mode the article doesn't cover. Legal domains are polluted with confident-sounding but catastrophically wrong practitioner marketing content. LLMs ingest it all with equal credulity, producing outputs that are wrong in ways only experts can detect—and by then it's too late. This is GIGO compounded by adversarial dynamics: not just "the model can't reason about opponents" but "the model's training data is actively hostile territory."

**5. The cognition/decision split reframes the whole debate**

robh78 arrives late with the thread's clearest synthesis: both "word model" and "world model" camps are arguing past each other because they're conflating two distinct capabilities. LLMs *do* build rich internal representations (cognition: exploring possibilities, tracking constraints, simulating implications). What they lack is *authority*—the ability to collapse that space into grounded claims about reality.

> "Most failures people worry about don't come from models lacking structure. They come from models (or users) quietly treating cognition as decision: coherence as truth, explanation as diagnosis, simulation as fact." —robh78

This reframing dissolves the titular dichotomy: LLMs have word models that contain significant world-relevant structure, but treating their outputs as *decisions* rather than *explorations* is the actual failure mode. The question isn't "does it understand?" but "when should its outputs be treated as authoritative?"

**6. The D-Machine vs. famouswaffles debate: the thread's deepest philosophical trench**

famouswaffles argues LLMs model "patterns in data that reflect the world directly"—text is an artifact of physical processes, not just a description of mental states. D-Machine fires back: LLMs can only work with tokenizations of texts written by people who produce text to *represent* their models. Every step of mediation makes LLMs *a priori* more distant from reality than humans.

famouswaffles's strongest counter: gradient descent *is* the verify-update loop D-Machine claims only humans have—the model makes predictions, data provides feedback, parameters update. D-Machine's strongest counter: humans verify against *reality* (try behaviors, observe outcomes), while LLMs verify against *text about reality*—a fundamentally different grounding signal.

Neither wins cleanly. But the exchange exposes a real fault line: whether the compression artifacts in text are lossy in ways that *fundamentally prevent* useful world modeling, or merely make it inefficient. The empirical evidence is mixed—LLMs solve novel physics problems (favoring famouswaffles) but fail at cooking advice because training data is polluted with myths (favoring D-Machine).

**7. The "expensive detour" thesis**

benreesman drops the thread's most provocative macro-claim: ten years ago, the obvious AI path was RL with ever-growing task sets, opportunistically unifying on durable generalities. Instead, "Large Language Models are Few Shot Learners" collided with Sam Altman's ambition, and "TensorRT-LLM is dictating the shape of data centers in a self-reinforcing loop." The result: "an expensive way to spend five years making two years of progress." This is the article's thesis in economic terms—the LLM scaling path was a path-dependent detour from the RL-based adversarial training the article prescribes.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Just prompt it to review" solves the Slack example | **Strong** | IanCal demonstrates this live. Undermines the article's most vivid example. |
| Chess/poker are both finite games; programming is neither | **Strong** | measurablefunc. Category error in the core framing. |
| Current multimodality is one-directional, doesn't fix the word→world gap | **Strong** | D-Machine, well-sourced with architecture references. |
| LLMs *do* have world models, just degenerate/inefficient ones | **Medium** | naasking, calf. Reasonable but doesn't address adversarial robustness. |
| "LLMs only parrot"—no internal structure at all | **Weak** | chrisjj, tovej. Empirically falsified by novel problem-solving results. |

### What the Thread Misses

- **The prompt-engineering gap is closing faster than the architectural gap.** IanCal's "just say review" point is devastating to the article's *current* claims but irrelevant to the *structural* argument. The thread doesn't separate these. Today's workaround (tell the model to be adversarial) doesn't solve tomorrow's problem (the model deployed as an autonomous agent with no human to say "review"). The article buries this distinction in footnotes; the thread never finds it.

- **Nobody discusses the LLM-vs-LLM case.** The article and thread assume human-vs-LLM adversarial dynamics. But the emerging scenario is LLM agents negotiating with other LLM agents—procurement bots, sales bots, legal review bots. In that regime, the "readable tells" problem becomes symmetric and may actually favor LLMs (they can play game-theory-optimal strategies consistently, like Pluribus, while humans get tired and emotional). The chess/poker taxonomy collapses differently when both players are machines.

- **The alignment thread (OldSchool) consumed ~25% of comments but is tangential.** The censorship/truth concerns are real but orthogonal to the world model thesis. The thread let a culture-war attractor absorb discussion energy that could have gone into the adversarial reasoning question.

### Verdict

The article identifies a real phenomenon—LLMs optimize for artifact plausibility, not outcome robustness—but packages it in a taxonomy (chess vs. poker) that's too clean to survive the thread's scrutiny. The most damaging objection isn't philosophical but practical: IanCal shows the article's centerpiece example is solved by a one-word prompt change, which suggests the gap is as much about how we *use* LLMs as about what they *are*. The thread circles but never states the deeper tension: the article prescribes RL in multi-agent environments as the fix, but this is exactly the path the industry abandoned in favor of scaling language models—and the sunk costs, infrastructure lock-in, and investor expectations that drove that choice aren't technical problems a better training loop can solve. The real barrier to adversarial AI isn't architectural. It's economic.
