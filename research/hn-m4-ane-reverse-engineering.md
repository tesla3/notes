← [Index](../README.md)

## HN Thread Distillation: "Inside the M4 Apple Neural Engine, Part 1: Reverse Engineering"

**Source:** [HN thread](https://news.ycombinator.com/item?id=47208573) (319 pts, 91 comments) · [Article](https://maderix.substack.com/p/inside-the-m4-apple-neural-engine) · 2026-03-02

**Article summary:** A reverse engineering deep-dive into the M4's Neural Engine, mapping the full software stack from CoreML to the IOKit kernel driver, discovering direct `_ANEClient` API access without CoreML, cracking the MIL/E5 binary format, and claiming to achieve model training on inference-only hardware. Co-authored by a human (maderix) and Claude Opus 4.6. Part 1 of 3, covering the RE methodology; Parts 2-3 cover benchmarks and training.

### Dominant Sentiment: Impressed but trust-fractured

The thread wants to engage with substantial RE work but can't stop arguing about whether Claude co-authorship taints it. Technical discussion keeps getting hijacked by meta-debates about AI-assisted writing — which is itself a signal about where the industry's head is at.

### Key Insights

**1. The Claude co-authorship disclaimer is functioning as a Rorschach test**

The article opens with a note that Claude Opus 4.6 was the co-author. This immediately bifurcated the thread. `eleventyseven` dismissed it outright: *"Why would I ever trust a vibe coded analysis? LLMs write convincing bullshit that even fools experts."* Meanwhile `brookst` fired back: *"You'd feel better if it was two people you don't know? Because obviously any random person is 100% accurate?"*

The more interesting response came from `michaelmrose`, who identified the actual mechanism: humans have resumes and credentials that let you calibrate trust — LLMs "trip all the right searches to fool these shortcuts" while having no verifiable track record. This is the real epistemological problem: not that AI output is wrong, but that it defeats the heuristics humans use to assess reliability. The author `maderix` responded weakly, essentially saying the human's job is "goal management" — which doesn't address the verification concern at all.

**2. Someone validated the work in 6 hours — and that matters more than the debate**

`vdivyanshu` went on a 6-hour bender and actually offloaded parts of Karpathy's NanoGPT training onto the ANE using maderix's work: classifier 10x faster, softmax 34x faster on ANE, plus fixing a memory leak in the original repo. This is the strongest possible endorsement of the article's claims — someone independently built on it and got results. The thread mostly ignored this in favor of continuing the AI-writing argument, which tells you something about what HN optimizes for (discourse) vs. what matters (replication).

**3. The ANE is an OS feature chip, not a developer resource — and Apple likes it that way**

The most underappreciated dynamic in the thread: Apple built the ANE for its own OS-level inference (FaceID, OCR, voice processing, computational photography) and never intended third-party access. `bri3d` put it clearly: *"it's a limited resource power efficient inference engine for smallish edge models... Almost every 'biggish' CPU has one of these now."* Dennis Forbes' linked article reinforces this — even Apple's own MLX team can't use it in open source because the only public API is CoreML.

`behnamoh` claims *"the source code of ANE is not available even to the MLX team"* and speculates this drove the MLX project head's departure. `bri3d` pushes back: the MLX team has said ANE can't do backprop and isn't useful for their use cases. The real story is that Apple has a two-tier accelerator strategy emerging: ANE for power-efficient OS inference, and the new M5/A19 GPU tensor cores ("neural accelerators") for the heavier stuff developers actually want.

**4. Apple's "38 TOPS" claim is misleading — and nobody inside cares**

From Part 2 (linked by `Octoth0rpe`): the true FP16 peak is ~19 TFLOPS; Apple doubles it by counting INT8 as 2× FP16, but the hardware doesn't actually execute INT8 ops any faster. `AceJohnny2` expressed genuine surprise that Apple would do this. `Shebanator`'s response — *"You assume the marketing folks actually talk with the hardware folks"* — rings true, but `AceJohnny2` countered with an anecdote about Apple chip engineers refusing to round up transistor counts for marketing. The TOPS inflation is an industry-wide disease (NVIDIA, Qualcomm all do it), but Apple's brand trades on precision, making it more jarring.

**5. The LLMism detection game has become its own genre of noise**

`love2read` flagged "The key insight" and sentence inversion patterns as Claude tells. `rafram` spotted the Prior Art section's repetitive verb structure. `qaadika` wrote the most thoughtful analysis — breaking down the grammatical uniformity of the bullet points vs. what human-written repo descriptions actually look like: *"If it was not interesting to read it was probably not interesting to write, which I take as an LLM writing it."*

But `pixl97` and `DrScientist` correctly noted these patterns existed pre-LLM. The thread is stuck in a loop: pointing out LLMisms is now itself a formulaic HN comment pattern. `walthamstow` predicted human writing will absorb LLM style within a year; `baxtr` immediately proved it by replying in pitch-perfect Claude voice (likely intentionally).

**6. The "blobbers problem": ANE is invisible to most developers**

`blobbers` asked the practical question nobody else did: *"Can someone help me understand when these neural engines kick in in open source software?"* as someone using numpy, scikit-learn, xgboost daily. The answer, from `zozbot234`: basically never, because NPUs are vendor-specific and open source numerics libraries don't target them. `blobbers` landed the punchline: *"great it seems like I'm paying for a hardware accelerator that makes Siri go faster. And I use Siri on my laptop exactly 0 times."*

This is the silent majority position. The ANE's value proposition only works for Apple's own features and CoreML-targeting app developers. For the scientific Python / ML engineering crowd — which is most of HN — it's dead silicon.

**7. The real technical insight: ANE is a graph execution engine, not a compute unit**

Buried under all the meta-discussion: the ANE's architecture is fundamentally different from GPUs. It takes a compiled computation graph and executes it atomically. `jasonwatkinspdx` gave the best technical context: NPU designs use systolic arrays with quadratic speedup for matrix ops, are far simpler than GPUs, and optimize for power efficiency over raw throughput. The E5 binary being nearly identical size regardless of matrix dimensions (2,680 vs 2,688 bytes) confirms the hardware has fixed compute primitives parameterized by tensor descriptors — it's configuration, not code. `zozbot234` noted the practical implication: for large matmuls, CoreML overhead vanishes, making ANE viable for LLM prefill but not decode (which is memory-bandwidth limited).

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Claude slop, can't trust it" | Medium | Legitimate concern about verification, but dismissing empirical results because of the writing tool is lazy. vdivyanshu's replication is the actual test. |
| "ANE is useless for developers" | Strong | Factually correct for open-source ML stack users. Only matters if you're in CoreML's ecosystem. |
| "LLMisms in the writing" | Weak | True but irrelevant to the technical claims. Now a genre of performative comment. |
| "Apple's TOPS are lies" | Strong | Industry-wide problem, but Apple's specific claim is measurably 2× inflated per their own hardware. |

### What the Thread Misses

- **The article's real contribution isn't the RE — it's the in-memory compilation path.** Prior work (Asahi Linux, hollance, mdaiter) had already mapped much of the ANE interface. The novel piece is `_ANEInMemoryModelDescriptor` enabling weight updates without filesystem round-trips, which is what makes training feasible. The thread barely engages with this.
- **Apple's Core AI framework replacement** (flagged by `GeekyBear` via Bloomberg) could obsolete this entire line of RE. If Apple ships a modern framework with better ANE access, the private API spelunking becomes moot. Nobody connected these dots.
- **The power efficiency story is undersold.** 6.6 TFLOPS/W with hard power gating to 0W idle is remarkable for edge inference. The thread fixated on raw TOPS instead of asking whether ANE's efficiency makes it the right chip for always-on AI features that don't justify GPU wake.
- **No one asked whether training on ANE is actually useful** beyond proof-of-concept. Fine-tuning small models on-device with zero power overhead could enable personalization without cloud round-trips — but the thread never got past "can you?" to "should you?"

### Verdict

The article is a solid piece of systems research that happens to have been written with an LLM, and the thread can't get past the second half of that sentence. The most telling moment is `vdivyanshu` actually building on the work — offloading NanoGPT layers to ANE with real speedups — while the rest of the thread debates whether Claude's prose style invalidates the findings. The core tension Apple faces isn't about reverse engineering; it's that they've shipped a genuinely capable accelerator in every device but locked it behind an API designed for their own use, right as the market demands on-device AI. The Bloomberg-reported Core AI framework may be Apple's belated answer, which would make this RE work both a vindication (the capability was always there) and a footnote (Apple will provide official access anyway).
