# HN Thread Distillation: "Executing programs inside transformers with exponentially faster inference"

Source: https://news.ycombinator.com/item?id=47348275 | 257 pts, 96 comments, 67 authors
Article: https://www.percepta.ai/blog/can-llms-be-computers
Date: 2026-03-12

**Article summary:** Percepta AI claims to have compiled a WASM interpreter directly into transformer weights, enabling deterministic program execution (Sudoku solver, arithmetic) *inside* the forward pass rather than via external tool calls. The key technical trick: restricting attention heads to 2D enables a convex-hull-based KV lookup (HullKV) that reduces decoding from O(n) to O(k + log n). They claim the process remains differentiable and could integrate with larger models as a "fast path" or speculative execution primitive.

### Dominant Sentiment: Fascinated but deeply skeptical

The thread splits almost exactly in half between "this could be revolutionary" and "why would you want this?" — but the skeptics win on substance. The most technically informed commenters converge on a damning observation: the article is long on narrative and short on every detail that matters.

### Key Insights

**1. The article is a Rorschach test for technical depth**

The sharpest divide isn't about whether the work is interesting — most agree it is — but about what the article actually *claims* versus what it *demonstrates*. Surface readers come away excited about differentiable computation inside transformers. Deeper readers notice the missing loss function, absent training details, and weasel-worded differentiability claims. D-Machine delivers the kill shot:

> "The post is the perfect example of the kind of writing about AI that dupes people that don't really understand how things like LLMs actually work and are actually trained. Anyone who properly understands these things finds the complete and total lack of detail about training and the loss function to be a monstrous red flag here."

The late clarification (by yorwba and confirmed by D-Machine) is crucial: **this isn't trained at all** — the weights are analytically computed to implement a VM. This reframes the entire piece. It's a constructive proof that transformers can simulate computation, not a learning result. The article never makes this clear, which is either sloppy or deliberately misleading.

**2. The differentiability claim is the crux — and it's hollow**

The article's strongest selling point is: "the whole process remains differentiable: we can even propagate gradients through the computation itself." Multiple commenters (D-Machine, yorwba, BenoitP) probe this. yorwba points out that average-hard attention is **not differentiable** w.r.t. keys and queries, and straight-through estimation wouldn't preserve the forward-pass speedup in the backward pass. D-Machine notes that differentiability is meaningless without a loss function that can handle partial/imperfect outputs. BenoitP asks the right question — "Can we gradient-descent effectively inside this huge space?" — but nobody has an answer. The article's key promise is technically vacuous as stated.

**3. The "why not just call a tool?" question is never answered**

This is the thread's gravitational center. teiferer, MattPalmer1086, mobilejdral, mike_hearn, bonoboTP, and graemefawcett all ask variants of the same question: what does embedding computation in weights buy you over calling an external interpreter? The article frames tool calls as expensive (process forking, Python overhead), but as mobilejdral notes, you could just embed WASM natively — the overhead problem is a systems engineering problem, not an architecture problem. mike_hearn: "I spent the whole article thinking, wow, cool, but also... how is this better than an LLM steering a regular computer?"

graemefawcett delivers the most concise summary: "They've implemented a VM inside a transformer, turned an O(1) memory access call into O(n), optimized it down to O(log n) and wrote a post about how smart they are."

**4. The real contribution is HullKV, buried under the narrative**

dnautics identifies what the paper is actually burying: the 2D head restriction enabling log-time retrieval via convex hull lookups. This is a genuinely novel attention mechanism. btown picks up the thread — "What could you do with an LLM that can go into 'focus mode' and generate tokens extremely rapidly?" andy12_ reinforces: "the most interesting thing here is definitely that just 2D heads are enough to do useful computation."

The HullKV primitive may be more valuable as a sparse attention mechanism for general models than as a way to run WASM. But the article buries this under the "computers inside transformers" narrative.

**5. The hybrid/MoE angle is the unexplored goldmine**

radarsat1 proposes the most promising application: combining this with a normal model MoE-style, where a router learns to dispatch deterministic subtasks to frozen compiled layers. soerxpso and derangedHorse hint at similar ideas — using compiled computational primitives as fixed subnetworks within trainable models. ACCount37 says directly: "I'm less interested in turning programs into transformers and more interested in turning programs into subnetworks within large language models. The interface between the two is a hard problem."

This is where the real research frontier is, and the article barely touches it.

**6. The AI-writing debate consumes a third of the thread**

bonoboTP opens the meta-discussion by noting the article reads like AI-generated text — eloquent sentences that don't deliver information. This spawns a 15+ comment flame war with famouswaffles defending the authors. soulofmischief escalates: "It is *without a doubt* written by an LLM... it immediately sets off yellow flags about how Percepta operates." D-Machine connects the writing quality to the technical gaps: "a huge tell that the authors/company/platform puts bullshitting and sales above truth and correctness."

The meta-irony is thick: a post about making transformers compute is itself a demonstration of transformers generating plausible-sounding text with no computational substance behind it.

**7. The complexity theory lineage is real but obscure**

yorwba provides the missing academic context: treating attention as lookup operations is standard in computational complexity theory (citing Merrill & Sabharwal 2023). The constructive proof approach — analytically computing weights rather than training them — is a known technique in this literature. This legitimizes the *method* while deflating the *novelty claims*. The article presents itself as a breakthrough when it's closer to an engineering demonstration of known theoretical results.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Just call a tool" — external compute is simpler, faster, more reliable | **Strong** | Never refuted. The article's framing of tool-call overhead is a strawman. |
| No training details or loss function | **Strong** | Because there is no training — weights are computed directly. Article obscures this. |
| Differentiability claim is empty | **Strong** | Hard attention isn't differentiable; no loss function exists for this setup. |
| AI-generated writing masks lack of substance | **Medium** | True but the writing debate consumed disproportionate oxygen. |
| "Old neurosymbolic garbage restated" | **Medium** | ACCount37's framing is reductive but not wrong — the philosophical motivation is warmed-over neurosymbolics. |
| WASM is a poor compilation target for this | **Weak** | dnautics raises it but nobody develops the argument. |

### What the Thread Misses

- **The forward-pass-only constraint is the real bottleneck.** Everyone debates tool calls vs. embedded execution, but nobody asks: how do you handle loops and recursion in a fixed-depth transformer? The article apparently handles this via unrolled execution traces, which means program complexity is bounded by context length. This is a fundamental limitation that neither the article nor the thread confronts.

- **Speculative decoding is the killer app nobody develops.** The article mentions it in passing, btown quotes it, but nobody models what this would look like in practice. A fast, deterministic, O(log n) token generator that proposes structured computation tokens for a larger model to verify — that's actually useful and doesn't require the differentiability claims to be true.

- **The "compiled weights" approach has a distribution problem.** clarionbell hints at it ("if compiled code can be efficiently shared between models of the same architecture") but nobody asks: how large are these weight patches? How architecture-specific? Could you build a registry of computational primitives as weight diffs? This is the LoRA-for-algorithms idea and it's unexplored.

- **Nobody benchmarks against speculative decoding baselines.** The O(log n) claim is compared against standard KV cache attention, but the right comparison is speculative decoding with a small draft model, which already achieves significant speedups for structured outputs.

### Verdict

Percepta has built a clever proof-of-concept that a transformer can mechanically simulate a virtual machine via analytically computed weights and a novel 2D convex-hull attention mechanism. The article wraps this in grandiose claims about "internalizing computation" and differentiable execution that the work doesn't support. The thread correctly identifies that the narrative obscures the actual contribution: HullKV is interesting, the compiled-weights construction is a neat engineering trick, and the MoE/hybrid integration direction has genuine research potential. But the article's refusal to clearly state what it is (a constructive proof, not a trained model) and what it isn't (differentiable, trainable, or faster than just calling a tool) undermines trust in the whole enterprise. The most valuable thing here might be the attention mechanism, not the computer.
