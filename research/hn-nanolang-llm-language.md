← [Index](../README.md)

## HN Thread Distillation: "Nanolang: A tiny experimental language designed to be targeted by coding LLMs"

**Source:** [HN thread](https://news.ycombinator.com/item?id=46684958) (232 points, 202 comments) · [GitHub repo](https://github.com/jordanhubbard/nanolang)

**Article summary:** NanoLang is a minimal experimental language by Jordan Hubbard (FreeBSD co-founder, former Apple engineering director, current NVIDIA senior director) that transpiles to C, requires mandatory test blocks ("shadow") per function, supports prefix notation for unambiguity, has core semantics formally proved in Coq, and includes a custom stack-based VM. It's explicitly designed for LLMs to write and humans to read.

### Dominant Sentiment: Respectful skepticism, wrong-problem energy

The thread largely respects the author's pedigree and intellectual honesty, but converges on a shared doubt: is the syntax layer where LLM code generation actually fails? Most practitioners say no.

### Key Insights

**1. The compiler-in-the-loop is the actual unlock, not language design**

Simon Willison runs the definitive experiment in the thread. He dumps NanoLang's MEMORY.md into Claude Opus 4.5 as a system prompt and asks for a Mandelbrot generator — it fails. He then fires up Claude Code inside a nanolang checkout with compiler access — it works. The delta is tooling feedback, not language familiarity.

> "The thing that really unlocked it was Claude being able to run a file listing against nanolang/examples and then start picking through the examples" — **simonw**

This replicates what **cmrdporcupine** observes: "With a good code base for it to explore and good tooling, and a really good prompt I've had excellent results with frankly quite obscure things, including homegrown languages." Even **vidarh** reports GPT-3.5 could reason about zero-shot franken-languages given just an EBNF grammar. The training data objection (**thorum**'s top-level claim that LLM performance scales with corpus representation) is effectively dead as a hard constraint — multiple practitioners confirm LLMs handle low-resource languages fine with context + feedback loops.

**2. The Mandelbrot code is the thread's accidental thesis statement**

The LLM-generated NanoLang Mandelbrot renderer works — and contains a 10-level nested if-else chain to index into a 10-character gradient string. As **antonvs** immediately notes, all that code should be `gradient[idx]`. **vidarh** piles on: "There's no need for any conditional construct here whatsoever."

This is the thread's unintentional proof that NanoLang solves the wrong problem. The failure mode isn't syntactic ambiguity (NanoLang's target) — it's semantic stupidity. The LLM produced valid, compilable, tested code that is grotesquely wrong at the design level. No amount of prefix notation or mandatory shadow blocks prevents this. The code passes every formal check and is still garbage.

**3. "The pain is in fully specifying behavior" — the specification camp**

**deepsquirrelnet**'s top comment (and the thread's real center of gravity) argues we need new specification languages, not new programming languages. **GrowingSideways** delivers the sharpest version: "The code was always a secondary effect of making software. The pain is in fully specifying behavior."

**keepamovin** offers the most interesting counter: since 99% of future code will be AI-written, languages that reduce LLM-specific error rates matter even if they're worse for humans. This is a genuinely novel framing — language design as LLM error-rate optimization rather than human ergonomics — but nobody pressure-tests it with data.

**4. The mandatory testing gambit has a bootstrap problem nobody names**

NanoLang's most distinctive feature — every function must have a `shadow` test block or it won't compile — gets surface-level discussion. **_flux** asks the interesting question about path coverage enforcement. **pmontra** is properly skeptical: real code will either be "completely polluted by tests" or degenerate to `shadow process_order { assert test_process_order }` with actual tests in another file.

But the deeper problem goes unstated: if the LLM writes both the function *and* its shadow test, the test is tautological. The LLM will write tests that match its own implementation, not tests that catch its own bugs. Mandatory testing only has teeth if the test author is independent of the code author.

**5. Jordan Hubbard's most valuable insight is buried in a late comment**

The author's response is refreshingly humble ("total thought experiment," "it accreted features," "firing a shotgun in the dark"), but his most technically valuable insight comes in a reply about why he left Clojure:

> "I actually tried to do a bunch of agentic coding in Clojure but found that the parser really got in my way — it continuously fooled the LLM on what line number the errors actually occurred on! This is why I made nanolang always report line numbers accurately and also have a built-in 'trace mode'" — **jkh99**

Line-number accuracy in error reporting and a trace mode that maps generated C back to source lines — these are concrete, actionable features for LLM-in-the-loop development. More useful than prefix notation, and the thread barely engages with them.

**6. The RL bootstrapping flamewar reveals HN's expertise-signaling pathology**

A combative subthread between **measurablefunc** and **nl**/**thorum**/**whimsicalism** about whether reinforcement learning can bootstrap code generation for novel languages devolves into demands for "exact passages and equations." **measurablefunc** insists RL can't work without training data; **nl** cites DeepSeek R1's GRPO approach; **measurablefunc** moves the goalposts to "novel domains with novel syntax & semantic validators." The exchange generates heat without light. **whimsicalism** drops the thread's best meta-comment: "imo generally not worth it to keep going when you encounter this sort of HN archetype."

**7. The practitioner split on Rust + LLMs is real and unresolved**

**adastra22** claims Rust's compiler feedback makes training data volume irrelevant. **root_axis** flatly contradicts this: "This isn't even true today. Source: heavy user of claude code and gemini with rust for almost 2 years now." **bevr1337** adds practical color: agents slip in `todo!()` macros, Cursor makes "huge, sweeping, wrong changes." **ekidd** says "I have zero problem getting Opus 4.5 to write high-quality Rust code." The split likely reflects different complexity thresholds — simple Rust is fine, lifetimes + trait bounds + async at scale is where it falls apart — but nobody delineates where the boundary actually is.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Training data matters more than language design | **Strong but dated** | True circa GPT-3, increasingly false with long-context models + tooling loops |
| Just use an existing language with good compiler feedback | **Strong** | Simon's experiment supports this — Claude Code + NanoLang's compiler worked |
| LLMs need new spec languages, not new programming languages | **Medium** | Correct diagnosis, no concrete proposals beyond hand-waving |
| Prefix notation is "vibes" not evidence | **Strong** | No benchmarks, no evals, no A/B comparisons. forgotpwd16 is right |
| Just a simplified Rust that transpiles to C | **Medium** | Fair surface comparison, misses the formal verification and mandatory testing angles |

### What the Thread Misses

- **The Coq proofs are the most interesting feature and nobody discusses them.** NanoLang's core semantics are formally verified with zero axioms — type soundness, determinism, semantic equivalence. For LLM-generated code, proven language semantics mean "if it type-checks, it can't get stuck." This is a genuinely novel combination with LLM targeting that the thread completely ignores.

- **The C transpilation target silently inherits C's problems.** The Coq proofs cover NanoLang's semantics, not the generated C. Buffer overflows, use-after-free, and undefined behavior in the transpiled output are all possible. The "formally proved" claim has a scope gap nobody probes.

- **Nobody asks who writes the shadow tests in an LLM workflow.** If the same LLM writes both function and test, you get tautological validation. The architecture needs adversarial test generation — a second model, or property-based testing, or mutation testing — to make mandatory shadows meaningful. This is a solvable design problem but the thread doesn't even frame it.

- **mike_hearn's taxonomy of LLM-era language futures is the thread's best strategic thinking** and gets almost no engagement. His four paths — (1) give up on new languages, ISA-style convergence; (2) define as delta on existing languages; (3) bundle your own fine-tuned LLM; (4) pay to get into training sets — is a useful framework. Path (2) is clearly dominant today, and it implies that NanoLang's approach (an entirely new language) is the hardest path to viability.

### Verdict

NanoLang is an honest experiment that accidentally proves its own thesis wrong. The Mandelbrot test shows that when you give an LLM a clean, unambiguous, test-mandatory language with compiler feedback, it produces working code that is *semantically idiotic* — exactly the failure mode that syntax design can't address. The thread circles this but never states it: **the binding constraint on LLM code quality is not syntactic ambiguity, it's semantic judgment, and no language design can fix that.** What NanoLang actually demonstrates is that the valuable features for LLM-in-the-loop development are mundane infrastructure ones — accurate line numbers, source-to-output tracing, fast compiler feedback — not novel syntax. Jordan Hubbard seems to know this ("it taught me a lot in the process"), which makes the project valuable as a learning exercise even if the premise is flawed.
