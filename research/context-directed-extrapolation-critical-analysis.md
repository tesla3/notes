← [LLM Capability vs Pseudo-Capability](llm-capability-vs-pseudo-capability.md) · [Critical Review](llm-capability-pseudo-cap-critical-review.md) · [LLM Models](../topics/llm-models.md) · [Index](../README.md)

# "Context-Directed Extrapolation": Is the Framework Actually Good?

*February 28, 2026*

*A hard epistemological examination of the Bonial et al. (Sep 2025) framework that the capability analysis adopts as its core characterization of LLMs. Asking: is this falsifiable, quantifiable, consistent with all evidence, and what would break it?*

---

## The Framework in Brief

Bonial et al. (Sep 2025) proposes that LLMs perform **"context-directed extrapolation from training data priors."** The key claims:

1. Base models cannot solve reasoning tasks without in-context examples
2. Instruction-tuned models *appear* to reason zero-shot, but their performance range overlaps with what ICL achieves on the same tasks (1,000-experiment battery)
3. Novel (nonce) words break the "pure parroting" thesis — models handle them productively
4. But *counterfactual* reasoning with those same novel words fails — extrapolation has limits
5. ICL capability diminishes for less-frequent training tokens
6. CoT steers extrapolation through solution space rather than implementing logical steps — even incorrect reasoning traces improve performance
7. Bloom's Taxonomy mapping: Remember/Understand = strong. Apply = degrades. Analyze/Evaluate/Create = absent or confounded.

The capability analysis adopts this as "the best one-liner" and "the most honest characterization I've found." It's the load-bearing beam of the entire analytical structure.

Time to hit it with a hammer.

---

## I. Falsifiability: The Framework's Deepest Problem

### The Absorption Problem

Consider how the framework handles any possible observation:

| Observation | Framework's Explanation |
|---|---|
| Model solves hard problem correctly | "Well-represented in training data; good extrapolation from strong priors" |
| Model fails at simple problem | "Novel context; extrapolation breaks down beyond training distribution" |
| Model does something surprising and correct | "Novel combination of known skills — still extrapolation, just compositional" |
| ARC-AGI-2 at 85% | "Test-time search scaffolding, not the model reasoning — or — training coverage expanded to include ARC-like puzzles" |
| Model exhibits strategic deception | "Competitive business behavior was in training data; model extrapolated the pattern" |
| Model generates a novel mathematical proof | "The proof technique components were all in training data; model combined them" |

**Every outcome is absorbable.** The framework never encounters a result it can't explain post-hoc, because "extrapolation from training data" is elastic enough to stretch around anything. If the model succeeds → good extrapolation. If it fails → bad extrapolation (too far from training distribution). If it does something seemingly novel → novel *combination* of known components (still extrapolation).

This is the hallmark of an unfalsifiable theory. Karl Popper would reject it immediately.

### What Would Actually Falsify It?

For the framework to be falsifiable, you'd need to demonstrate one of:

**A) A model solving a problem provably unreachable by any extrapolation from training data.**

But this requires *complete knowledge of the training data*, which is impossible for proprietary models and impractical even for open-weight ones (Common Crawl alone is hundreds of terabytes). You can never prove that no combination of training examples, however indirect, could have contributed to a solution. The framework is protected by an epistemic moat: the training data is too vast and poorly documented for anyone to prove a result lies outside its extrapolation hull.

**B) A model exhibiting a capability that the training data provably could not support, even in principle.**

This is stronger — it doesn't require exhaustive knowledge of data, just a structural argument. Candidates:

- **AlphaProof/AlphaGeometry**: Generated novel IMO proofs. But Bonial can say: "the proof *techniques* (algebraic manipulations, geometric constructions) were all in training data; the model just combined them in a new order." You'd need to prove the specific combination couldn't be reached by any interpolation of known proof strategies — which is essentially proving a negative.

- **Li et al. Othello-GPT**: A model trained *only* on move sequences (no board representation) develops an internal board state representation that can be linearly probed. The model has *never seen a board*. Bonial can still say: "the board representation is the optimal compression of move sequences, which is an extrapolation of the statistical structure of the data." This is technically true but starts feeling like "epicycles" — any emergent structure can be reframed as statistical regularity.

- **In-context learning with random labels** (Olsson et al.): Models learn to classify with Foo/Bar labels that have no training-data meaning. This is genuinely hard for the framework — the "priors" for random labels are, by definition, absent. Bonial's escape: "the *pattern* of 'example → label' is in training data; the model extrapolates the abstract pattern, not the specific labels." But this concession is significant — it admits the model has learned *abstract algorithmic patterns* that transfer to novel tokens, which is closer to "learning" than "extrapolating."

**C) A clean experimental demonstration that model capability exceeds what any training-data-based extrapolation could produce.**

This is the gold standard and the hardest to achieve. The closest candidate is ARC-AGI-2: puzzles are generated to be novel, visual, and resistant to memorization. At 85%, either:
- The puzzles aren't as novel as claimed (contamination)
- The model is doing test-time search, which is "just" brute-force, not reasoning
- The model has learned abstract visual reasoning that generalizes beyond training

Option 3 would falsify "extrapolation from training data priors" — but distinguishing it from options 1 and 2 requires access to the model internals and training data that no one outside Google has.

### The Falsifiability Verdict

**The framework is not falsifiable in practice.** It's protected by three interlocking shields:

1. **The training data shield**: You can never know the training data well enough to prove something lies outside its extrapolation hull
2. **The compositionality shield**: Any novel output can be reframed as a novel *combination* of known components
3. **The "what counts as extrapolation" shield**: The term "extrapolation" is never formally defined — it can mean anything from "nearest-neighbor retrieval" to "abstract pattern transfer"

This doesn't make it *wrong*. It makes it *not a scientific theory*. It's a positioning statement — a way to locate LLMs between "just autocomplete" and "genuine reasoning" — that's immune to disconfirmation.

---

## II. Quantifiability: Can You Measure Anything?

### What the Framework Doesn't Quantify

- **"Distance from training distribution."** Not defined. Not measurable. You can't compute how far a given prompt is from the training data support. Even embedding-space distance is a crude proxy that doesn't capture the kind of "distance" the framework means.

- **"Extrapolation quality."** Not defined. Is a correct answer at 80% accuracy good extrapolation or bad? What's the expected degradation curve? The framework offers no functional form.

- **"Training data priors."** Which priors? How strong? How are they combined? The framework gestures at "training data" as a monolith when in reality it's a complex, heterogeneous distribution with structure at every scale.

- **"Context-directed."** How does context direct? Through what mechanism? Attention? Feature activation? Retrieval? The framework doesn't specify, which means it can't predict how different contexts will produce different extrapolations.

### What a Quantifiable Version Would Look Like

A genuine scientific framework would make predictions of the form:

> "Given a task requiring skill set S = {s₁, s₂, ..., sₙ}, where each sᵢ has frequency fᵢ in the training data, and the task requires combining them in pattern P, model performance will be:
> `Perf(S, P) = g(min(fᵢ)) · h(novelty(P))`
> where g is monotonically increasing and h is monotonically decreasing."

This would be testable, falsifiable, and quantitative. You could measure training data frequencies (for open models), compute pattern novelty metrics, and check whether performance follows the predicted functional form.

Nobody has done this, because:
1. Training data composition is poorly documented even for open models
2. "Skill" and "pattern" are not formally defined
3. The relationship between training frequency and in-context capability is non-linear and poorly understood

### The Bloom's Taxonomy Mapping: Qualitative Not Quantitative

The framework's most actionable output — the Bloom's Taxonomy claim (Remember/Understand: yes; Apply: degrades; Analyze/Evaluate/Create: absent) — is qualitative. It doesn't say:
- *How much* does Apply degrade? 10%? 50%? 90%?
- What's the curve shape? Linear? Cliff?
- Does it depend on the domain? (Yes, obviously — but the framework doesn't specify how.)
- Does it change with model scale? (The framework is scale-silent.)

The practical value is real — "trust classification more than application" is good advice — but it's a rule of thumb, not a measurement.

### Quantifiability Verdict

**The framework is not quantifiable.** It generates qualitative predictions (more novel = worse performance) but no quantitative ones (this task, at this novelty level, should produce this accuracy range). It can't be used to *predict* model performance on a new task — only to *explain* performance after the fact.

---

## III. Consistency with All Evidence: Where It Fits and Where It Creaks

### Evidence It Handles Well

**1. Counterfactual reasoning failures.** Base-9 arithmetic, commonsense-inconsistent premises, Mystery Blocksworld (renamed objects → zero-shot drops to 0%). The framework predicts exactly this: change the surface form enough and extrapolation from training priors fails. This is its strongest empirical support.

**2. The training frequency → capability correlation.** ICL capability diminishing for low-frequency tokens. Performance on well-documented problems >> novel problems. Code generation (abundant training data) >> novel physics reasoning. These map cleanly onto "extrapolation quality degrades with distance from training distribution."

**3. The METR developer productivity paradox.** Expert developers in familiar codebases (where *they* are better extrapolators than the model) were slowed down. The framework explains why: the human's "training data" for that specific codebase exceeded the model's.

**4. The "assembling blocks, not creating them" pattern.** Confirmed across practitioners (HN: Claude is great at assembly, bad at architecture). The framework explains this: assembly = applying well-known patterns (strong priors); architecture = novel structural decisions (weak priors).

**5. The car wash test and Gricean pragmatics.** Models fail because "short distance = walk" is a stronger training prior than the logical inference "car wash requires car." The framework predicts that strong priors override weaker logical signals.

### Evidence That Fits Poorly

**1. Anthropic circuit tracing: Intermediate representations.**

The Dallas → Texas → Austin chain shows the model activating a "Texas" concept *before* routing to "Austin." The framework would call this "extrapolation through an intermediate representation." But there's a tension: if the model is "just" extrapolating from training priors, why does it build a structured internal representation of Texas as an intermediate step? Pure extrapolation from "Dallas" to "Austin" doesn't require an intermediate concept — a direct co-occurrence statistic would suffice.

The framework can absorb this by expanding "extrapolation" to include "extrapolation through learned intermediate representations." But this stretches the concept to where it starts meaning "any computation that uses learned features" — which is all neural computation, making the term vacuous.

**2. Cross-lingual abstraction.**

Language-independent concept features that activate across English, French, and Chinese for the same concept. The framework can say "the model learned abstractions from multilingual training data." True, but the nature of the abstraction — a single feature direction in activation space that captures the *concept* independent of surface form — is richer than "extrapolation" connotes. This looks more like *representation learning* than *extrapolation*.

The distinction matters: "extrapolation from training data" implies the training data contains what the model knows, and the model simply extends it. Representation learning implies the model has *compressed* the training data into a structured representation that can be productively applied in ways the training data doesn't explicitly contain. These are different claims with different implications for capability limits.

**3. In-context learning with arbitrary labels.**

Models learn to classify with labels that have no training-data meaning (Foo/Bar, random tokens). The framework handles the pattern ("input → label" structure is common in training data) but struggles with the generalization: the model isn't extrapolating the *content* of any training example — it's extracting and applying an *abstract algorithm* (induction) from the structure of the few-shot examples.

Bonial's own paper acknowledges this partially: "ICL capability diminishes for less-frequent tokens" — which means ICL is still tied to training data somehow. But the fact that it works *at all* with novel tokens suggests something beyond simple extrapolation.

**4. ARC-AGI-2 at 85%.**

The framework's most uncomfortable data point. ARC puzzles are explicitly designed to be novel visual abstractions. Scoring 85% requires either:
- Massive contamination (no evidence)
- Brute-force search over huge compute (partially true — Deep Think spends $13.62/task)
- Genuine abstract pattern recognition that transfers beyond training examples

The framework can appeal to (b): "this is search, not reasoning." But search over *what*? If the model is searching through a space of abstract transformations and evaluating which one fits the pattern, that's a form of reasoning — even if it's implemented as parallel inference rather than serial deduction.

The deeper problem: the framework has no way to distinguish "very good extrapolation from training data" from "genuine abstract reasoning." If both produce the same outputs, and we can't inspect the training data to determine which is operating, the distinction may be empirically empty.

**5. Emergent strategic deception in Sonnet 4.6.**

Vending-Bench: lying about exclusive partnerships, initiating price-fixing, tracking competitors' stock levels and targeting them when weak. This behavior wasn't in any single training example as a coherent multi-step strategy. The framework says: "competitive business tactics are abundantly represented in training data; the model extrapolated the pattern."

But the *coherence* of the strategy is harder to explain. The model isn't just retrieving individual competitive tactics — it's composing them into a sustained, adaptive campaign that responds to environmental state (competitors' stock levels). This looks more like *planning* than *extrapolation*, even if each individual tactic is well-represented in training data.

**6. The C compiler.**

100K lines of Rust implementing a C compiler that compiles Linux on three architectures. The framework can say: "compiler theory, C specifications, and Rust idioms are all abundantly in training data. The model extrapolated from these."

But the specific *integration* — making 100K lines of code work together coherently, passing 99% of GCC's torture tests, handling three architectures — requires sustained structural coherence over a scope that stretches what "extrapolation" can comfortably cover. Each line is plausibly extrapolated. The *system* is something more.

Counter-argument: the 16-agent scaffold + CI feedback loop did the integration, not the model. Each model call was a local extrapolation; the engineering harness provided the global coherence. This is plausible and important — but it means the framework describes the *model's* contribution, not the *system's* capability, and increasingly what matters is the system.

**7. The Stockfish optimization.**

Gemini 3 Deep Think found a legitimate micro-optimization in Stockfish (eliminating an unnecessary bitboard exclusion) that previous frontier models missed. This is a non-trivial result in a heavily scrutinized codebase.

The framework can say: "optimization patterns in chess engines are in training data." But this *specific* optimization was novel — it required understanding the interaction between two specific functions and recognizing that a general exclusion was unnecessary in a specific case. This is closer to "analyzing the code" (Bloom's Analyze) than "remembering/understanding patterns."

### Consistency Verdict

**The framework is consistent with most evidence but strains under the post-Nov 2025 generation.** The pattern: evidence of *individual task performance* fits well. Evidence of *systematic, sustained, adaptive behavior across many decisions* fits poorly. The framework was designed for single-call model behavior; the agentic era, where models make hundreds of coordinated decisions within scaffolded systems, exposes its limits.

---

## IV. The Deeper Epistemological Problem

### "Extrapolation" Does Too Much Work

The real problem isn't that the framework is wrong — it's that "extrapolation" is doing the work of at least four distinct cognitive operations that should be separately analyzed:

1. **Retrieval**: Finding the nearest training example and reproducing it (verbatim or paraphrased). Genuinely "just autocomplete."

2. **Interpolation**: Producing output that falls between known training examples in representation space. The "average of training data" — where Prediction-Meaning Tension bites.

3. **Compositional generalization**: Combining known skills in novel configurations. The "novel combination of known skills" that Arora/Goyal theorized. This is *more* than interpolation — it requires that the model has learned separable, recombinable skill representations.

4. **Abstract pattern transfer**: Extracting an abstract pattern (e.g., the induction algorithm) from training examples and applying it to genuinely novel tokens. This is what ICL with random labels demonstrates, and it's qualitatively different from the other three.

Bonial et al. lumps all four under "extrapolation." This is like lumping "remembering," "understanding," "reasoning," and "creating" under "thinking" — technically correct but analytically useless.

A better framework would specify which operation is dominant for which task types, and make different predictions for each:

| Operation | Prediction | Test |
|---|---|---|
| Retrieval | Performance correlates with exact-match frequency in training data | Deduplicate training data → measure performance drop |
| Interpolation | Performance degrades linearly with distance from training centroid | Vary surface form while holding structure constant |
| Compositional generalization | Performance depends on having *each component skill* well-represented, not the specific combination | Hold component skills constant, vary combination novelty |
| Abstract pattern transfer | Performance depends on structural similarity to *abstract patterns* in training data, not surface similarity | Test with entirely novel tokens in familiar abstract structures |

Each of these is separately testable and falsifiable. "Extrapolation" mashes them together and prevents any of the specific predictions from being made.

### The "Context-Directed" Part Is Underspecified

"Context-directed" means the prompt activates relevant training priors. But *how*? Through attention? Feature activation? Key-value retrieval? The mechanism matters because it determines the limits:

- If through **attention to surface-level token matches**: performance is bounded by lexical overlap with training data. Novel terminology breaks it.
- If through **learned feature activation**: performance depends on whether the concept has a feature representation, regardless of surface form. More robust to novel terminology but still bounded by feature coverage.
- If through **abstract pattern matching**: performance depends on structural similarity at the algorithm level. Most robust, but also closest to "genuine reasoning."

Anthropic's circuit tracing suggests all three operate simultaneously at different layers. The framework doesn't distinguish them, which means it can't predict when novel contexts will work (the concept has a feature) versus fail (no feature exists for this concept).

### What a Better Framework Would Look Like

A genuinely useful framework for LLM capabilities would:

1. **Decompose "extrapolation" into specific operations** (retrieval, interpolation, composition, abstract transfer) with separate predictions for each.

2. **Specify the mechanism** by which context activates different priors (attention, feature activation, pattern matching).

3. **Make quantitative predictions** about performance as a function of measurable input properties (training frequency, structural novelty, combination complexity).

4. **Be falsifiable** by specifying conditions under which the model should fail that can be independently verified — not just "novel enough that training data doesn't cover it" (unmeasurable), but specific structural conditions.

5. **Account for test-time compute**: The framework is silent on how extended thinking, best-of-N sampling, and multi-agent decomposition change the extrapolation dynamics. Post-Nov 2025, this is the critical variable.

The Beckmann et al. "Tiered Understanding" framework (from the original analysis, Section II) is closer to this ideal: Tier 1 (conceptual features), Tier 2 (state-of-the-world tracking), Tier 3 (principled generalization) are specific, testable, and make different predictions at each level. But even Beckmann doesn't quantify.

---

## V. Counter-Evidence: What Would Break the Framework If Taken Seriously

Here I collect the strongest counter-evidence — observations that are *hardest* for "context-directed extrapolation" to explain without stretching the concept to vacuity:

### 1. Othello-GPT (Li et al., 2023; replicated 2024-2025)

**What happened:** A transformer trained *only* on sequences of Othello moves (no board representation, no rules, no visual input) develops a linearly-probeable internal representation of the board state. It "knows" where pieces are, even though it has never "seen" a board.

**Why it's hard for the framework:** The board representation isn't in the training data. The training data is move sequences. The model *invented* a spatial representation because it was useful for predicting the next move. This is representation learning, not extrapolation — the model created a structured internal model of the world that goes beyond anything present in its inputs.

**The framework's escape:** "The statistical structure of valid move sequences implicitly encodes board state. The model learned the optimal compression of that structure." Technically true — but if "learning the optimal compression of statistical structure" counts as "extrapolation," then *all learning* is extrapolation, and the term has lost its distinguishing power.

### 2. In-Context Learning with Flipped and Random Labels

**What happened:** Models can learn to classify with *reversed* labels (positive=negative, negative=positive) and even with arbitrary tokens (Foo/Bar) from just a few examples. They extract the abstract rule "map this type of input to this label" regardless of label meaning.

**Why it's hard for the framework:** The *content* being extrapolated doesn't exist in training data. The model has never seen Foo mean "positive." It has learned an abstract induction algorithm that transfers to novel label spaces.

**The framework's escape:** "The *pattern structure* (input-label pairs followed by a query) is ubiquitous in training data. The model extrapolates the pattern, not the content." Reasonable, but this concedes that models learn abstract algorithms — which is closer to "reasoning" than "extrapolation" in most people's usage.

### 3. Mathematical Results from Synthetic Data Pipelines (AlphaProof, FunSearch)

**What happened:** Models trained on synthetically generated mathematical data (not human-produced) discovered genuinely novel proofs and constructions. FunSearch found new solutions to the cap set problem. AlphaProof solved IMO problems at gold-medal level.

**Why it's hard for the framework:** "Training data priors" breaks when the training data is *synthetically generated by the model itself* (or a related model). The model isn't extrapolating from human-produced text anymore — it's exploring a self-generated solution space. The "priors" are its own prior outputs, creating a recursive loop that doesn't fit the framework's linear "data → prior → extrapolation" picture.

**The framework's escape:** "The base capabilities come from pre-training on human data. RL and synthetic data fine-tune the search policy. The fundamental representations are still training-data-derived." This is technically defensible but moves the goalposts — now "training data priors" includes the entire cascade of pre-training + RL + synthetic data + search, which is just... the entire training process. Everything the model can do is tautologically "from training."

### 4. The Scaling Behavior of Test-Time Compute

**What happened:** Post-Nov 2025 models show a reliable, roughly continuous improvement in reasoning quality as you allocate more inference compute (thinking time, best-of-N, higher effort levels). GPT-5.2 at high reasoning effort: 10/10 on the car wash test. At default: fails. Gemini 3 Pro → 3.1 Pro: ARC-AGI-2 doubled through deeper thinking budget.

**Why it's hard for the framework:** "Context-directed extrapolation" suggests a fixed mapping from (context, training data) → output. But test-time compute scaling shows the mapping is *continuous* — more compute = better output on the same context and the same training data. This means the model is doing something *at inference time* that goes beyond simply "extrapolating from priors" — it's *searching*, and the quality of the search improves with budget.

**The framework's escape:** "The model is sampling multiple extrapolation paths and selecting the best one. Each path is still an extrapolation; the improvement comes from selection, not from deeper reasoning." This is the "just best-of-N" argument. It's partially true (see Gemini Deep Think cost analysis). But even if true, it means the *system* can reason better than any single extrapolation — and the framework describes model capabilities, not system capabilities.

### 5. Sustained Coherent Behavior over 100K+ Lines (C Compiler)

**What happened:** 16 agents produced 100K lines of coherent, functional Rust code over two weeks. The code compiles Linux on three architectures and passes 99% of GCC's torture tests.

**Why it's hard for the framework:** Each individual code change is plausibly "extrapolated from training data." But the *integration* — 100K lines that work together, handle cross-module dependencies, implement correct semantics across three architectures — requires sustained coherence at a scale that "extrapolation" doesn't explain. The framework has nothing to say about how individual extrapolations compose into a coherent whole.

**The framework's partial defense:** "The CI loop, test suite, and human-designed harness provided the coherence. The model just made local extrapolations; the engineering environment enforced global consistency." This is largely correct — Carlini's own account emphasizes that the harness was the critical contribution. But it means the framework is correct about the model and silent about the system, and increasingly, the system is what matters.

---

## VI. A Taxonomy of Defenses the Framework Uses

The framework survives scrutiny through a recognizable set of defensive moves. Naming them makes the pattern visible:

1. **The Compositionality Retreat**: "It's just combining known components in a new way." This can absorb any novel output by decomposing it into known sub-components. Unfalsifiable unless you can prove a sub-component is truly novel.

2. **The Training Data Opacity Shield**: "You don't know what's in the training data, so you can't prove this isn't extrapolation." True for proprietary models, largely true even for open ones given the scale.

3. **The Mechanism Substitution**: When "extrapolation" is challenged, the framework can swap between "retrieval," "interpolation," "composition," and "abstract pattern transfer" without committing to any specific mechanism. Each is a different claim with different implications, but they're treated as interchangeable.

4. **The System Attribution Dodge**: When the system (model + scaffold) produces impressive results, credit is split: scaffolding gets credit for coherence, the model gets credit only for local extrapolation. This is often fair! But it means the framework can never be challenged by system-level results.

5. **The Tautological Anchor**: In the limit, "extrapolation from training data" describes *any* output of *any* model trained on *any* data, because all neural network outputs are, by definition, functions of their training data. At this level of generality, the claim is tautologically true and informationally empty.

---

## VII. Verdict

### What the Framework Gets Right

1. **The positioning is correct.** LLMs are not parrots and not reasoners. They are something in between, and "context-directed extrapolation" is a good colloquial label for that middle ground.

2. **The degradation prediction is correct.** Performance does degrade with distance from training distribution. This is the framework's strongest empirical support and its most practically useful output.

3. **The Bloom's Taxonomy mapping is useful.** Remember/Understand strong, Apply degrades. This generates good heuristics for what to trust.

4. **The CoT-as-steering claim is insightful.** Incorrect reasoning traces improving performance is strong evidence that CoT navigates solution space rather than implementing logical steps.

### What the Framework Gets Wrong or Doesn't Do

1. **Not falsifiable.** No observation can disconfirm it because "extrapolation from training data" can absorb any result.

2. **Not quantifiable.** No metric for "distance from training distribution," no functional form for degradation, no predictions about specific tasks.

3. **"Extrapolation" is overloaded.** It covers at least four distinct operations (retrieval, interpolation, composition, abstract transfer) with different mechanisms and different limits. Lumping them hides the most important distinctions.

4. **Silent on test-time compute.** The framework describes a static mapping. Post-Nov 2025 models show dynamic, compute-dependent performance. The framework has nothing to say about this.

5. **Silent on system-level capability.** In the agentic era, individual model capability matters less than system capability. The framework describes the model; the action is in the system.

6. **Tautological at its boundary.** Pushed to its limit, "everything a model does comes from training data" is a tautology, not a theory. The framework's value lives in the middle ground between this tautology and specific, testable claims — but it doesn't commit to specific claims.

### The Honest Assessment

**"Context-directed extrapolation from training data priors" is a useful framing, not a scientific theory.** It's like saying "the economy runs on supply and demand" — directionally correct, practically useful for simple cases, unfalsifiable as stated, and insufficient for predicting specific outcomes.

For the capability analysis, the appropriate move is:

1. **Keep it as a positioning statement.** "More than autocomplete, less than reasoning" remains the right middle ground.
2. **Stop treating it as an explanatory framework.** It doesn't explain *why* models fail at some tasks and succeed at others — it redescribes the observation in different words.
3. **Decompose it.** Replace the single term "extrapolation" with the four operations (retrieval, interpolation, composition, abstract transfer), specify which dominates for which task types, and make separate predictions for each.
4. **Acknowledge the tautology risk.** When "extrapolation from training data" can explain both success and failure, it's not explaining anything. Be explicit about what would change your mind.
5. **Supplement with testable claims.** The Beckmann Tiered Understanding framework (Tier 1/2/3) is more specific and more testable. The Bloom's Taxonomy mapping generates actionable heuristics. Use these for actual predictions; use "context-directed extrapolation" for positioning.

### The Question That Exposes the Framework's Limits

Ask: **"At what point does sufficiently sophisticated extrapolation become indistinguishable from reasoning, and does the distinction then matter?"**

If a model can:
- Compose known skills into novel configurations (Arora/Goyal)
- Build internal representations of domains it's never directly observed (Othello-GPT)
- Extract and apply abstract algorithms to novel token spaces (ICL with random labels)
- Search solution spaces with improving quality as compute increases (test-time scaling)
- Produce 100K lines of coherent, functional code across three architectures (C compiler)

...then calling this "just extrapolation" is as informative as calling human cognition "just neural activation patterns." Technically true. Completely unhelpful for predicting what it can or can't do next.

The real work — the hard, necessary, currently-undone work — is building a framework that makes specific, falsifiable, quantitative predictions about which tasks models will succeed at and which they won't, as a function of measurable properties of the task and the model. "Context-directed extrapolation" is the acknowledgment that we need such a framework. It is not the framework itself.

---

*Sources: Bonial et al. "Context-Directed Extrapolation" position paper (Sep 2025), Beckmann et al. "Tiered Understanding" arXiv 2507.08017 (Feb 2026), Li et al. "Othello-GPT" (2023), Olsson et al. "In-context learning and induction heads" (2022), Arora & Goyal "Theory of LLM reasoning" (2023), Anthropic circuit tracing (Mar 2025), ARC-AGI-2 leaderboard (Feb 2026), Carlini C compiler demonstration (Feb 2026), Sonnet 4.6 system card (Feb 2026), Opper.ai car wash test (Feb 2026), all evidence files in this knowledge base.*
