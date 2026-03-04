← [Index](../README.md)

## HN Thread Distillation: "When AI writes the software, who verifies it?"

**Source:** [HN thread](https://news.ycombinator.com/item?id=47234917) (188 points, 175 comments) · [Article](https://leodemoura.github.io/blog/2026/02/28/when-ai-writes-the-worlds-software.html) by Leonardo de Moura (Lean creator/Lean FRO)

**Article summary:** De Moura argues that AI-generated code is scaling faster than our ability to verify it, and that the only sustainable answer is machine-checked formal verification via Lean. He cites a new result: an AI agent converted C's zlib to Lean and proved a roundtrip correctness theorem with minimal human guidance. The essay is part manifesto, part Lean sales pitch — it wants you to believe we're at an inflection point where formal verification becomes economically viable because AI can now write the proofs too.

### Dominant Sentiment: Anxious agreement, low on solutions

The thread overwhelmingly agrees there's a verification crisis but splits sharply on whether formal methods are the answer or a fantasy. Most commenters are practitioners drowning in AI-generated PRs right now, not academics thinking about Lean. The mood is "we know this is bad, we don't know what to do."

### Key Insights

**1. The review bottleneck is already catastrophic — and no one has a fix**

The most visceral thread comes from `throwaw12`, who describes receiving 10-15 AI-assisted PRs per day from 4 teammates, each touching 5-6 files. The math is brutal: ~50-60 files to review daily, with changes scattered across methods and call hierarchies where GitHub's diff view can't show the second-order effects. "How am I supposed to review all these?" Every proposed solution — slow down, trust your teammates, better architecture — is met with the correct rebuttal that it doesn't solve the bottleneck, it just throttles the system. `sjajzh` cuts to the core: "Slow is smooth, and smooth is fast" — but `throwaw12` fires back that teammates' brains have gotten lazy, and "I still trust them as good faith actors, but not their brain anymore (and my own as well)." This is the most honest admission in the thread: AI isn't just generating unreviewed code, it's actively degrading the reviewers' judgment.

**2. The test-generation loop is a trap that recapitulates the very problem it claims to solve**

`roadbuster` (top comment) nails the core pathology: teams ask AI to write code, then ask the same AI to write tests for that code. "The LLM happily churns out unit tests which are simply reinforcing the existing behaviour of the code." `MartyMcBot` provides a concrete war story: a PUT endpoint set `completed=true` but never set the completion timestamp — agent-written tests all passed because they tested what the code *does*, not what it *should do*. 59 tasks shipped with null timestamps. The old TDD answer (write tests first) keeps getting invoked but rings hollow — `daliusd` points out that "tests catch only what you tell AI to write. AI does not know what is right."

**3. The formal verification pitch has a credibility gap the article doesn't address**

Several experienced commenters push hard on the article's central claim. `maltalex`: "To be production-ready, that spec would have to cover all possible use cases, edge cases, error handling, performance targets... That sounds awfully close to being an actual implementation, only in a different language." `csense` raises the specification fidelity problem: "it feels like it would be very easy to accidentally prove ∃x s.t. decompress(compress(x)) == x while thinking you proved ∀x, decompress(compress(x)) == x." `hwayne` offers the best counter: specifications don't need to be "obviously computable" — expressing "if some function has a reference to a value, that value will not change unless that function explicitly changes it" is simple, but implementing it requires Rust's borrow checker.

**4. Regehr's fuzzing result is simultaneously impressive and devastating for both camps**

`faitswulff` links to John Regehr's experiment: he fuzzed the Claude C Compiler, found 11 miscompilation bugs, had Codex fix all 11, and then 400,000 further fuzz runs found zero miscompiles. Regehr's assessment is balanced but biting: the bugs were "the kind of mistake one would make if one was implementing a C compiler without reading the standard closely and carefully. They're surface-level bugs that you would simply not find in a serious compiler." The article uses CCC as evidence *for* verification; Regehr shows that traditional fuzzing + AI repair already gets you surprisingly far — undermining the urgency of the Lean pitch while simultaneously proving the article's point that AI code contains subtle bugs invisible to test suites.

**5. The Dafny-vs-Lean practical gap matters more than the article admits**

`muraiki` tried Lean, gave up, switched to Dafny, and was productive in half a day — reviewing Claude's Dafny code for a security kernel. `cpeterso` cites a benchmark: LLM vericoding success rates are 27% for Lean, 44% for Verus/Rust, and 82% for Dafny. `nextos` explains the trade-off: Dafny is less expressive but hits a sweet spot where refinement types let you write something close to normal code. The article's insistence that Lean is the inevitable platform obscures that the tool most accessible to both humans and LLMs right now is Dafny — and accessibility is the whole ballgame if you want mainstream adoption.

**6. The "who cares about quality" equilibrium is self-reinforcing**

`sarchertech`: "A lot of people who know better are keeping their mouths shut and waiting for things to blow up." `shigawire` adds the social pressure: "If you say we should slow down your competence is questioned by others who are going very fast." `shinycode` drops the thread's most darkly comic anecdote: "Our CEO, an expert in marketing, has discovered Claude Code and is the one having the most open PRs of all developers and is pushing for us to 'quickly review'. He does not understand why reviews are so slow because it's 'the easiest part'." This is the incentive trap: the people generating the code are rewarded for volume, the people reviewing it are punished for being slow, and quality has no constituency until something breaks.

**7. gwern identifies the article's structural failure**

`gwern` (arriving late, as usual delivering the sharpest single comment) diagnoses why this important article isn't landing: it "buries the lede." The zlib autoformalization result — an AI agent converting production C to verified Lean with minimal guidance — should have *opened* the essay. Instead, it's buried after pages of "rather graceless and ugly LLM-written generic prose about AI topics that to many readers is already tiresomely familiar." The meta-irony: an article about the dangers of AI-generated slop appears to contain AI-generated slop in its own introduction.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "When humans write software, who verifies it?" — we never had this solved | Medium | True but deflects: the *rate* of unverified code is the new variable |
| Formal specs are just implementation in a different language | Strong | `hwayne` provides a good counter, but the objection stands for most real-world CRUD |
| AI reviewing AI is fighting nondeterminism with nondeterminism | Strong | `g947o`'s point is correct; `pyridines` notes fresh-eyes agents do help in practice |
| Just write tests first (TDD) | Weak | Keeps getting invoked as if nothing changed; misses that specs are the real gap |
| Lean is an island — can't build real systems in it | Medium | `ozten` is right today; the article's timeline is years-to-decades, not months |

### What the Thread Misses

- **The liability vacuum.** Nobody in 175 comments seriously discusses who is *legally* liable when AI-generated code causes harm. `tartoran` waves at it; no one engages. This is the forcing function that will matter more than technical elegance — regulation and litigation will drive verification adoption faster than engineering taste.

- **The training data poisoning angle.** The article raises adversarial supply-chain attacks on AI models. The thread completely ignores this. If a model's training data can be poisoned to inject subtle vulnerabilities, then all downstream code — and all downstream *tests* — are suspect. Formal verification against an independent spec is the only architecture that survives this threat model, and that's the article's strongest argument, which no commenter engages with.

- **The specification authorship problem at scale.** Everyone agrees "specs are important." Nobody asks: who writes the specs for the 25-30% of Google/Microsoft code that's already AI-generated? There is no spec. There was never a spec. The code *is* the spec, and now the code is AI-generated. The verification crisis isn't just about checking output — it's about the complete absence of a ground truth to check against.

### Verdict

The thread is living proof of the article's thesis: practitioners know the verification gap is widening and have no answer beyond "slow down" (which no one will do) or "write tests first" (which doesn't scale when you can't even define correct behavior). The article's Lean pitch is directionally correct but strategically misaimed — the people in this thread don't need to be convinced that verification matters; they need a tool that works in their Python/TypeScript/Go codebase *this quarter*, not a theorem prover they'll learn in 2028. The deepest tension the thread circles without naming: AI has decoupled code production from code understanding for the first time in computing history, and every institutional process — code review, testing, deployment gates — was designed for a world where the author understood what they wrote.
