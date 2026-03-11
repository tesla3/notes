← [Index](../README.md)

## HN Thread Distillation: "Claude's Cycles [pdf]"

**Source:** [HN thread](https://news.ycombinator.com/item?id=47230710) · 822 points · 356 comments · March 2026
**Paper:** [Claude's Cycles](https://www-cs-faculty.stanford.edu/~knuth/papers/claude-cycles.pdf) by Donald Knuth

**Article summary:** Donald Knuth (88, Turing Award, TAOCP) published a paper describing how Claude Opus 4.6 solved an open directed Hamiltonian cycle decomposition problem on an m×m×m toroidal grid that he and collaborator Filip Stappers had been stuck on for weeks. The problem: decompose 3m³ directed edges into exactly three Hamiltonian cycles for all odd m > 2. Claude found a constructive solution on its 31st exploration attempt (after brute force, serpentine patterns, fiber decompositions, simulated annealing all failed). The "serpentine pattern" Claude derived turned out to correspond to the classical modular m-ary Gray code — a known combinatorial structure applied in a new context. Knuth then provided the rigorous proof. The paper opens with "Shock! Shock!" and Knuth writes he'll "have to revise my opinions about generative AI." The even-m case remains unsolved.

### Dominant Sentiment: Vindicated awe meets entrenched denial

The thread splits cleanly into two camps that barely engage each other: people who read the paper and find it significant, and people who didn't and relitigate "stochastic parrot" arguments from 2023. The top-voted comments lean toward significance, but the volume of philosophical debate dwarfs the technical discussion.

### Key Insights

**1. The "training data" reflex is now falsifiable — and falsified**

The reflexive "it's in the training data" response (e.g., [miroljub]: "Solves? It's a part of the training set. Nothing more, nothing less.") gets demolished cleanly. [skinner_] delivers the kill shot: "if Claude had regurgitated a known solution, it would have come up with it in the first exploration round, not the 31st." [mwigdahl] and [ordu] reinforce that if Knuth — the world authority on combinatorial algorithms — calls a problem open, and nobody has corrected him, it's open. The training-data objection has become an unfalsifiable security blanket: if AI solves something novel, claim it was in the data; if it fails, claim it's not intelligent. The thread increasingly treats this position as unserious.

**2. The "just next-token prediction" debate has bifurcated into a technical and a philosophical version — both stuck**

[ainiriand]'s sincere question ("Are not LLMs supposed to just find the most probable word?") sparks the thread's longest subchain. The *technical* version is mostly settled: [dilap], [wrsh07], and [adampunk] correctly note that post-RLHF models are no longer accurately described as next-token predictors — the objective function has been modified multiple times. [tux3] gives the clearest explanation of how RLHF changes the distribution. But the *philosophical* version — whether the mechanism matters or only the capability — remains deadlocked. [gpm] and [dilap] have a genuinely interesting exchange about whether "predictive" is inherent to the architecture or "perspective hangover from historical development." Neither convinces the other.

**3. Knuth's credibility is doing the heavy lifting — but the difficulty is overstated**

The paper's impact comes less from the mathematical result and more from who's impressed. [cjcole] nails the dynamic: "Imagine hearing pre-attention-is-all-you-need that 'AI' could do something that Donald Knuth could not." The thread repeatedly gravitates to Knuth's authority as the real signal. [sigmar]: "we're going to have several years of people claiming genAI 'didn't really do something novel here,' despite experts saying otherwise."

But the difficulty calibration matters. In Knuth's own TAOCP taxonomy (0 = trivial, 50 = Fields Medal territory), this was framed as "part of the answer to an exercise" — not a standalone conjecture. The solution turned out to be a known combinatorial object (m-ary Gray codes) applied in a new way. Hamiltonian decomposition of Cayley graphs is a well-studied area: the 4-regular undirected case was solved in 1989, Alspach's general conjecture dates to the 1980s, and Knuth's specific instance sits where general tools exist but don't quite reach this structure. The r/math thread (203 upvotes, 25 comments) treats it as "Claude is a useful tool for research mathematicians" — nobody there calls it a major open problem.

Knuth at 88 is still sharp enough to write the rigorous proof, but "several weeks stuck" from an 88-year-old — even a legendary one — is different from "several weeks stuck" from a 35-year-old postdoc specializing in Hamiltonian decomposition. The r/math comment "I'm amazed that Knuth is still so sharp at 88" suggests the community is aware of this. The result is: the problem isn't hard enough to be independently impressive, but Knuth's endorsement makes it impossible to dismiss. That asymmetry is the actual story.

**4. The Turing completeness tangent reveals a real insight**

[vidarh] makes a substantive claim: put a loop around an LLM and it's trivially Turing complete, so the question reduces to whether thinking requires exceeding the Turing-computable. [gpm] pushes back correctly that as typically deployed, LLMs are finite automata (fixed context window). But [roywiggins] resolves it: equip an LLM with read/write/move tools and you literally have a Turing machine. The real insight buried here: the *tool-use paradigm* (Claude Code, agentic loops) isn't just a UX improvement — it's a fundamental computational upgrade from finite automaton to Turing-equivalent. Most of the thread doesn't notice this implication.

**5. The gap between "useful tool" and "AGI" remains huge — but the thread can't agree where the goalposts are**

[emp17344] cites the Aletheia benchmark: only 13/700 open Erdős problems solved, only 4 autonomously. This is genuine evidence of limitation. But [cjcole]'s response is sharp: "Putnam perfect, IMO gold, etc — the idea that this is all 'statistical parrot' stuff is wearing thin." The thread has a goalpost problem in both directions: skeptics keep moving the bar (from "can't reason" to "can't do novel math" to "can't do hard enough novel math"), while enthusiasts conflate "impressive on benchmarks" with "approaching AGI." [emp17344] asks the right question — "what goalposts do you think are being moved?" — but never gets a direct answer.

**6. The "what about physics?" subthread is surprisingly well-reasoned**

[rustyhancock] makes the strongest contrarian argument in the thread: AI can't solve GR/QFT unification because we lack *experimental data* at that boundary, not because AI lacks intelligence. "To do so with a particle accelerator it would need to be the size of the Milky Way." This cleanly separates the intelligence question from the data question. [ajam1507] pushes back with Einstein's thought experiments, but [rustyhancock] counters that Einstein had decades of prior experimental results (Lorentz transforms, Poincaré's work) to synthesize — we have "approximately 0 experimental evidence at the GR/QFT boundary." The exchange illustrates a general principle the thread doesn't state: AI's bottleneck for frontier science isn't reasoning capability but data availability.

**7. The biological intelligence analogy cuts both ways**

[bitexploder] provides the thread's most thoughtful extended analysis, comparing LLMs to patients with anterograde amnesia. Both have frozen knowledge but can still solve problems with existing information. But the human still rewires parts of the brain in real-time, still has embodied sensory integration. The argument is careful: LLMs have *a kind of* intelligence localized to the present, but lack the continuous self-modification that characterizes biological intelligence. [supern0va] responds wisely: "just because LLMs don't have what we'd describe as human intelligence, doesn't mean they don't have intelligence. I think we're witnessing the creation and growth of a weird new type of intelligence."

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "It's in the training data" | Weak | Falsified by the 31-attempt trajectory and the problem's open status |
| "Just statistical pattern matching" | Misapplied | Accurate for base models, outdated post-RLHF; conflates mechanism with capability |
| "Still fails at many problems" | Strong | Aletheia's 13/700 Erdős results are real; single successes don't prove generality |
| "No understanding, just tokens" | Medium | Philosophically coherent but unfalsifiable — applies equally to "neurons just fire" |
| "We lack data for hard science" | Strong | Correctly identifies a bottleneck that's independent of AI capability |

### What the Thread Misses

- **The human-in-the-loop is doing real work.** Filip Stappers formulated the problem, restarted sessions after errors, kept Claude on track, chose what to pursue. The thread treats this as Claude solving the problem alone. The paper is more honest: it's a human-AI collaboration where the human provides judgment and the AI provides search. Nobody asks what would have happened if Stappers had given up after attempt 10.

- **The "31 explorations" number is the actual story.** Claude didn't intuit the answer — it ran a systematic search through mathematical approaches for about an hour, failing 30 times before succeeding. This is closer to automated theorem proving with natural-language heuristics than to "creative problem solving." The thread doesn't discuss what this implies about AI reasoning: it's more like massively parallel intellectual labor than human-style insight.

- **The solution was a rediscovery, not an invention.** Claude's "serpentine pattern" turned out to be the classical modular m-ary Gray code. Claude didn't know it was rediscovering something named — it derived it from scratch through the problem constraints. This is legitimately useful (finding the right known tool for a new problem is valuable), but it's different from producing genuinely novel mathematics. Nobody in the thread notices this distinction.

- **Cost and reproducibility.** Nobody asks how much compute the 31 explorations cost, whether this is reproducible across runs, or what the success rate would be on a broader class of similar problems. One success is an anecdote, not a capability benchmark.

- **The difficulty is exercise-level, not conjecture-level.** Knuth framed this as "part of the answer to an exercise" for TAOCP Volume 4C, not as a standalone research conjecture. The HN thread and media coverage consistently overstate the difficulty. The r/math community's measured response ("useful tool") is closer to the right calibration than HN's "AI solves open problem Knuth couldn't crack."

### Verdict

The thread is really about whether Knuth's endorsement should update your priors on AI — and the answer is yes, but less than the enthusiasm suggests. The actual result: an AI rediscovered a known combinatorial structure (m-ary Gray codes) as the solution to a TAOCP exercise-level problem after 31 guided attempts, and a human then proved it correct. What makes it significant isn't the math but the *social proof*: the most credentialed possible skeptic just publicly updated. What neither the thread nor the media coverage calibrates is that this is an exercise answer Knuth was stuck on, not a major conjecture — and the r/math community's response ("useful tool for research mathematicians") is far more measured than HN's reaction.

The thread circles but never states the real dynamic: we're not debating AI capability anymore, we're debating whether to trust expert testimony about AI capability — while simultaneously inflating what the expert actually said. Knuth said "I'll have to revise my opinions." The internet heard "AI solved a problem Knuth couldn't." Those are different claims, and the gap between them is where most of the thread's arguments live.
