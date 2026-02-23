← [Coding Agents](../topics/coding-agents.md) · [Index](../README.md)

## HN Thread Distillation: "LLMs as the new high level language"

**Source:** [federicopereiro.com/llm-high](https://federicopereiro.com/llm-high/) · [HN thread](https://news.ycombinator.com/item?id=46868928) (177 pts, 378 comments, Feb 2026)

**Article summary:** The author proposes that LLMs are the next step in the high-level language progression (assembly → C → Java → Python → LLM prompts), where multiple autonomous agents will replace direct coding the way C replaced assembly. He lists common objections, dismisses them, then sketches a future built on documentation-as-spec, agent dialogs, and MCP as universal API glue. He admits he's "not sure of it yet" and later, in an update prompted by the thread itself, concedes the analogy breaks if you're still reading and verifying the generated code — which is the current state of affairs.

### Dominant Sentiment: Annoyed skepticism with pockets of genuine debate

The thread splits roughly 60/30/10: dismissive critics, serious technical rebuttals, and cautious optimists. The ratio of upvotes to comments (177:378, well under 1:1) is the classic HN signal for controversial engagement-bait. Multiple commenters (kazinator, badgersnake, phplovesong, niobe) call it LinkedIn-grade AI hype. But the serious responses — particularly from kristjansson, QuadrupleA, and sarchertech — elevate the thread well above the article.

### Key Insights

**1. The "commit your prompts" challenge is the analogy's kill shot**

Multiple commenters independently converge on the same devastatingly simple test: if prompts are the new source code, why isn't anyone committing prompts to git and regenerating the codebase from them? "We don't commit compiled blobs in source control. Why can't the same be done for LLMs?" (ares623). Verdex, kaapipo, koiueo, and dsr_ all arrive at variants of this. Nobody has a good answer because the answer is: you can't. The prompts aren't sufficient to reproduce the output. This single observation does more damage to the thesis than any theoretical argument. The Quesma "vibe code git blame" article (linked by stared) demonstrates this empirically — same prompt, same model, same settings, different output every time.

**2. Prompts are neither sufficient nor local — kristjansson's formal takedown**

The thread's star comment. kristjansson introduces two formal properties of real programming languages: *sufficiency* (the code contains all information needed to define program behavior) and *locality* (a small change in code produces a correspondingly small change in behavior). LLM prompts fail both tests. A prompt doesn't fully determine its output — "any variation whatsoever would result in a different generated program, with no guarantee that program would satisfy the constraints." And prompts aren't local: a one-word change in a spec can and "frequently does produce unrecognizably different output" (sarchertech). This isn't a difference of degree from traditional compilation — it's a difference of kind. "The prompt → LLM → program abstraction presents leaks of such volume and variety that it cannot be ignored."

**3. The reliability gap is measured in orders of magnitude, not increments**

QuadrupleA frames it quantitatively: classical computing gives you "huge-number-of-9s" reliability per instruction. LLMs "are not even 'one 9' reliable." Each token is a draw from a probability distribution, and errors compound multiplicatively. The hackyhacky camp tries to counter by noting gcc and clang produce different assembly — but runarberg demolishes this by pointing to the C standard's formal guarantees. GCC and Clang produce *semantically equivalent* programs; Claude and Gemini produce *different programs that might happen to do the same thing*. The distinction between these two situations is the entire field of formal verification.

**4. The analogy's defenders retreat from technical to economic ground**

A revealing dynamic: every time the determinism/sufficiency argument gets pressed, defenders shift to "the business owner doesn't care about the details" (hackyhacky) or "does the product work? Everything else is secondary" (dainiusse). This is conceding the technical argument entirely. It's also a different claim — "LLMs are economically useful for shipping software" is obviously true and uncontroversial, but it has nothing to do with whether LLMs constitute a "high-level language." The framework-shopping is telling.

**5. "Prompting is managing, not programming" — the category error**

beefsack nails it in five words. freetonik expands: "There's a reason we distinguish between programmers and managers; if LLMs are just the new high level language, then a manager is just another programmer operating on a level above code." The article's thesis collapses the distinction between *specifying what to build* and *building it*. Every previous step in the language progression preserved the relationship: the programmer writes deterministic instructions that the compiler executes faithfully. LLM prompting replaces this with delegation to a probabilistic agent — which is management, not compilation.

**6. The sketch.dev outage reveals a new failure class**

rvz links a concrete case study: an LLM moved code between files and silently changed a `break` to `continue` because the adjacent comment said "continue with other installations." The LLM's local token prediction overrode transcription fidelity. This is a failure mode that *cannot exist* in deterministic compilation — cut-and-paste preserves bytes; LLM code generation reconstructs them probabilistically. As sketch.dev's team noted: "A human doing this refactor would select the original text, cut it, move to the new file, and paste it. Any changes after that would be intentional." The author's dismissal of "the code LLMs make is much worse" as analogous to hand-written assembly being worse than compiler output misses this entirely — compilers don't introduce *semantic drift* during translation.

**7. The author concedes the thesis in his own update**

The most remarkable moment: the author adds an update acknowledging that "the analogy is correct if most coding becomes vibe coding" — i.e., only if you stop reading the generated code. But since everyone currently reads and verifies the code, the analogy doesn't hold for the present and depends entirely on a future state that may never arrive. This is the thread's most effective critic, and it's the author himself.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Non-determinism disqualifies the analogy | **Strong** | Thread's dominant objection. Formally grounded by kristjansson, empirically supported by the "commit prompts" test |
| LLMs aren't reliable enough (9s argument) | **Strong** | QuadrupleA's quantitative framing is sharp; not refuted |
| gcc/clang also produce different output | **Weak** | Repeatedly dismantled — semantic equivalence under a formal standard ≠ probabilistic reconstruction |
| "It will get better" / future improvement | **Medium** | hackyhacky and others assert improvement will fix current gaps, but this is unfalsifiable projection, not argument |
| This is just management, not programming | **Strong** | Identifies the category error at the heart of the thesis |
| Business doesn't care about internals | **Misapplied** | True but irrelevant — answers a different question than the one the article asks |

### What the Thread Misses

- **The compilation target problem.** In the HLL chain (assembly → C → Java → Python), each layer compiles *to* the one below via deterministic transformation. LLMs don't compile prompts to Python — they *generate* Python via statistical reconstruction. The relationship between "source" and "target" is fundamentally different. Nobody names this clearly.

- **The rental economics of the analogy.** Every historical language transition gave developers tools they *owned* — GCC is free, javac is free, the Python interpreter is free. LLM "compilation" is a proprietary service that can change behavior without notice, deprecate model versions, or adjust pricing. afavour gestures at this ("we don't even own the compilers") but nobody follows through on what it means: the historical analogy would require C compilers to be cloud APIs that silently change optimization behavior between calls.

- **MCP as the real story.** The article's most interesting claim — MCP as the new XMLHttpRequest, breaking application silos — gets zero thread engagement. If anything survives from this article, it might be this idea, not the language analogy.

- **The Zechner counterexample works against the thesis.** The author cites Mario Zechner's "prompts are code" work as validation, but Zechner's actual article describes the enormous engineering effort needed to make LLM workflows *barely reproducible* — structured sequential prompts, serialized state to JSON/markdown, clipboard workarounds for transcription errors. This is evidence for how far LLMs are from being a "language," not how close.

### Verdict

**Insight cross-references:** Confirms [Broken Abstraction Contract](../insights.md#broken-abstraction-contract) (all four contract properties violated), [Democratization-Failure Tradeoff](../insights.md#democratization-failure-tradeoff) (defenders retreat to accepting failure modes), and [Theory Formation Threshold](../insights.md#theory-formation-threshold) (author concedes analogy requires crossing it). No new standalone insights.

The article bundles two claims: "LLMs are economically transformative for software development" (broadly true, broadly uncontested) and "LLMs are the next step in the high-level language progression" (the actual thesis, which the thread thoroughly demolishes). The analogy fails on every formal property that defines the HLL progression: determinism, sufficiency, locality, and reproducibility. What the thread circles but never quite states is that the language analogy isn't just wrong — it's *actively harmful* because it encourages people to think about LLMs using a mental model (compilation) that will lead them to skip the verification step that currently makes LLM-assisted development actually work. The author's own concession — the analogy holds only if you stop reading the code — inadvertently names the danger: the analogy is most convincing precisely when it's most reckless.
