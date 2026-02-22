← [Index](../README.md)

## HN Thread Distillation: "AI makes the easy part easier and the hard part harder"

**Source:** [HN thread](https://news.ycombinator.com/item?id=46939593) (531 pts, 367 comments) · [Article](https://www.blundergoat.com/articles/ai-makes-the-easy-part-easier-and-the-hard-part-harder) by Matthew Hansen, 31 Jan 2026

**Article summary:** Hansen argues that offloading code-writing to AI leaves developers with only the hard parts (investigation, context-building, review) while stripping them of the context they'd normally build by writing the code themselves. He coins "senior skill, junior trust" — AI writes competently but needs junior-level verification. His own positive example (AI-assisted bug investigation) undermines his framing by showing AI helping directly with the "hard part."

### Dominant Sentiment: Fractured agreement, methodological divide

The thread mostly *agrees* with the article's premise while splitting sharply on what to *do* about it. The interesting fault line isn't skeptic-vs-enthusiast — it's people who've found a working methodology versus people who think one doesn't exist yet.

### Key Insights

**1. "Embarrassingly solved problems" is the thread's best analytical lens**

zjp names the key dynamic: LLMs excel at problems heavily represented in training data and fail on problems that aren't. le-mark opens the thread with a perfect demonstration — vibe-coded a retro emulator (thousands exist on GitHub) easily, failed completely on proprietary domain work with zero training examples. This is more precise than the article's easy/hard binary because it reframes the boundary as *training data density*, not *task difficulty*. A "hard" emulator bug might be trivially solved; an "easy" CRUD operation in an obscure framework might not be.

**2. The skilled-user workflow exists but has a marketing problem**

peteforde delivers the thread's star comment, describing exactly how experienced developers get real results: break work into bite-sized chunks, plan→agent→debug cycles, stay in the loop at the speed you can think. His bicycle analogy lands: *"Vibe coding is riding your bike really fast with your hands off the handles. Nobody who is really good at cycling is talking about how they've fully transitioned to riding without touching the handles."* He reports productive results on a 550k LoC codebase — but the critical point is this requires *more* engineering judgment, not less. The workflow he describes is invisible in the AI marketing narrative, which sells "talk to your computer, get code."

**3. The context-building paradox is the article's strongest claim, and the thread validates it**

theredbeard provides the sharpest formulation: *"Over 60% of what the model sees is file contents and command output, stuff you never look at. Nobody did the work of understanding by building / designing it. You're reviewing code that nobody understood while writing it."* This isn't the article's vague "hard part gets harder" — it's a specific mechanism: skipping context-building upfront creates an evaluation debt you pay with interest later. Multiple commenters independently confirm this pattern without coordinating on the vocabulary.

**4. The compiler analogy dies on contact with formal methods**

marcus_holmes argues we'll trust LLMs like we trust compilers. johnbender kills this cleanly: compilers have a single formal correctness specification that works for *all* programs, defined *once*. AI-assisted coding would need such a specification *per application* — and if you could write that spec, you've already solved the hard problem. whaleidk and lock1 pile on: natural language is fundamentally ambiguous, and removing that ambiguity means reinventing a programming language. Nobody attempts a rebuttal because there isn't one.

**5. The ratchet effect is real and under-discussed**

RataNova's one-liner is the thread's most compressed insight: *"Speedups without changes in expectations just reset the baseline, and then you're sprinting forever."* The article raises this as a management problem, but the thread barely engages with it structurally. TrackerFF describes the mechanism from the code side — vibe-coded projects accumulate technical debt "of such magnitude that you're basically a slave to the machine" past a few thousand lines. The ratchet operates at two levels: management expectations *and* codebase entropy.

**6. The license-washing sub-thread exposes an unresolved legal vacuum**

AuthAuth calls it license washing; 20k claims to regularly see "100s of lines of code just completely stolen." The thread splits between "IP law is broken anyway" (ThunderSizzle) and "laws should apply equally" (ibeckermayer, Hendrikto, danaris). The most telling exchange: thedevilslawyer asks for evidence of plagiarized snippets and gets a 2022 tweet and a general memorization paper. The strongest argument (direwolf20) is also the most cynical: *"Did they get penalised? No? Then there's no reason for legal to block it."* Nobody resolves whether training on GPL code virally infects output — graemep correctly notes the legal theory is underdeveloped.

**7. piskov's ClosedXML story is the most concrete evidence against pattern-matching**

A specific, reproducible failure: ClosedXML has the same API as EPPlus but different internal implementation (no batch operations). After 5-6 explicit attempts telling the model to use style caching instead of range updates, *"the fucker still tried ranges here and there."* This demonstrates exactly where training distribution dominance overrides explicit instruction — the model keeps reaching for the pattern it's seen most, even when told not to. It's the "embarrassingly solved problems" framework in negative: when the dominant pattern is wrong for your case, the model actively fights you.

**8. Eliezer's meta-critique hits the article's weakest point**

The article names no model, no date, no version. Eliezer: *"Every time somebody writes an article like this without any dates and without saying which model they used, my guess is that they've simply failed to internalize the idea that 'AI' is a moving target."* iLoveOncall pushes back — *"We have had those comments with every single model release"* — but Eliezer's point is structural, not predictive. The article's 500→100 line deletion anecdote *is* outdated; josefrichter and adamtaylor_13 both say they haven't seen behavior like that in over a year.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "You're just using it wrong" | Weak as stated | Forgeties79 lands the counter: if countless people are using it wrong, the tool has a problem. But peteforde's detailed methodology shows *some* version of this is true. |
| AI will improve so current limits don't matter | Medium | True directionally, but unfalsifiable as argument. Thread's own history (iLoveOncall) shows each generation triggers the same "this time it's different" claim. |
| AI is just regurgitated training data | Misapplied | logicprog correctly notes RLVR is now the primary driver of coding improvements, not more training data. The "averaged echo" framing (uoaei) is outdated. |
| The hard part is always hard, AI doesn't change this | Strong | koliber's practical report (3-5x on easy stuff, keep AI away from hard stuff) is the most credible individual account precisely because it's modest. |

### What the Thread Misses

- **The junior pipeline problem.** If the "easy part" is 80% of junior developer work, and AI eats that, who trains the next generation of seniors? The context-building mechanism theredbeard describes is literally *how juniors learn*. cess11 mentions this once in a sub-thread about Copilot autocomplete killing a teaching moment, and nobody picks it up.

- **Team dynamics, not just individual productivity.** The entire thread is about one developer + one AI. Nobody discusses what happens when half the team generates 3x the code volume and the other half drowns in review. The asymmetry is corrosive and the thread has zero discussion of it.

- **Three different things conflated as one.** The thread constantly mixes chat completion, human-in-the-loop agentic coding, and fully autonomous vibe coding. peteforde's methodology is nothing like vibe coding, yet he's drawn into defending "AI" generically. The vocabulary hasn't caught up to the practice.

- **What the "type system" for AI coding would look like.** The compiler analogy gets properly killed but nobody asks the constructive follow-up. zozbot234 gestures at "write a detailed spec" — but that's just restating the problem. The thread doesn't explore formal or semi-formal constraint systems that could make AI-generated code verifiable.

### Verdict

The article's own structure reveals the answer it doesn't quite articulate: every negative example is about AI as *code generator*, and its one positive example is AI as *context navigator*. The thread reproduces this split exactly. Commenters who report success (peteforde, koliber, djx22) describe investigation-and-orchestration workflows where AI searches, explains, and drafts while humans direct. Those who report failure describe generation-and-review workflows where AI produces and humans inspect. The framing, not the tool, determines the outcome — but this creates a vicious selection effect: the people who can use AI as a context navigator are exactly those who already had strong engineering judgment. AI doesn't close the skill gap. It amplifies it. The thread senses this without naming it, circling around "you need to be a good engineer to use AI well" without noticing that this means AI's greatest productivity gains accrue to the people who needed them least.
