← [Index](../README.md)

## HN Thread Distillation: "Leanstral: Open-source agent for trustworthy coding and formal proof engineering"

**Source:** [HN](https://news.ycombinator.com/item?id=47404796) · [Article](https://mistral.ai/news/leanstral) · 624 pts · 139 comments · 2026-03-16

**Article summary:** Mistral releases Leanstral, an Apache-2.0 licensed 120B-A6B MoE model specifically trained for Lean 4 formal proof engineering. Key pitch: at pass@16, Leanstral scores 31.9 on their FLTEval benchmark for ~$290, vs. Opus at 39.6 for $1,650. It beats all open-source competitors and Claude Sonnet/Haiku, but notably still falls short of Opus by ~8 points.

### Dominant Sentiment: Interested but skeptical of value prop

Thread is genuinely excited about the *direction* (formal verification + AI agents), but struggles to get excited about *this product*. The benchmark numbers undermine the marketing: Opus still wins handily, and the cost argument is unconvincing when correctness is the whole point.

### Key Insights

**1. The cost-vs-correctness paradox exposes confused positioning**

The article leads with cost savings, but the thread immediately spots the tension: if you're doing formal verification, you presumably care about correctness above all else. `andai`: "If you're optimizing for correctness, why would 'yeah it sucks but it's 10 times cheaper' be relevant?" Leanstral at pass@16 ($290) still trails Opus ($1,650) by ~8 points. For a domain where the entire value proposition is *trustworthiness*, the 5.6x cost savings vs. a clear quality gap is a hard sell. The real pitch should be "run it locally on your own hardware" — sovereignty, not savings — but Mistral undersells this.

**2. pass@k is Lean's killer advantage over vibe coding**

`ainch` makes the crucial observation: "pass@k means you run the model k times and give it a pass if any of the answers is correct. Lean is one of the few use cases where pass@k actually makes sense, since you can automatically validate correctness." This is the genuinely important insight buried in the thread. Formal verification gives you a *deterministic oracle* — you can brute-force attempts and know with certainty when one succeeds. No other coding domain has this property. The cost scaling of pass@k becomes the real competitive axis, not single-pass quality.

**3. The "who watches the watchmen" problem has a real answer**

`TimTheTinker` raises the natural concern: if the agent writes the Lean spec, aren't we back to square one? `justboy1987` gives the thread's star comment: "You're not trusting the agent — you're trusting the kernel." The Lean type-checker is ~10k lines, heavily scrutinized. The workflow is: human writes spec (creative, domain-expertise work), agent generates proof, kernel mechanically verifies. The agent can hallucinate freely — invalid proofs get rejected deterministically. This is a genuinely different trust model from "hope the tests are good."

**4. TDD-as-alignment is converging from multiple directions**

`cadamsdotcom`'s top comment articulates the broader thesis: executable verification suites are superior to markdown specs because they encode *details*, not intent, and cost zero tokens when the code is correct. `tonymet` sharpens it: "AI is the reality that TDD never before had the opportunity to live up to." `nextos` extends to Amazon's property-based testing via Kiro. The convergence is clear — from TDD to QuickCheck-style property testing to full formal methods, the industry is building a ladder of verification granularity that AI agents can climb. Each rung trades human review effort for machine-checkable constraints.

**5. Mistral's actual moat is enterprise sovereignty theater**

`ainch` nails the real business dynamic: Mistral is chasing enterprise deals (HSBC, ASML, AXA, BNP Paribas) as a French "national champion." `warpspin` delivers the devastating counter: "Mistral runs its own stuff on US Cloud Act affected infrastructure… If I accept a level of 'independence' whereby I run on AWS or Azure, I could as well pay for Anthropic or GPT for SOTA performance." The band where Mistral's value prop works is narrow — organizations that need independence *on paper* but not in practice. Real sovereignty requires self-hosting, and for that the model quality gap matters more.

**6. The spec-vs-implementation asymmetry is the real unlock**

`justboy1987`: "A formal spec in Lean is typically 10-50x shorter than the code it proves correct." `specvsimpl` extends the argument beautifully: Fermat's Last Theorem — every teenager understands the statement, the proof is thousands of pages. This asymmetry is why formal verification + AI could work: humans handle the tractable creative task (what should be true), machines grind on the hard mechanical task (proving it). `AlotOfReading` pushes back with SeL4: 8.7k lines of C required 100k+ lines of proof and 15k lines of Isabelle spec. The asymmetry is real but not universal — some specs genuinely approach implementation complexity.

**7. LLM alloys for formal verification have unexplored potential**

`patall` asks whether mixing different models across passes would improve results. `andai` confirms this is called an "LLM alloy" and cites research showing the *less overlap* in correctly solved problems between models, the greater the boost. For formal verification — where you have a perfect verifier and pass@k is meaningful — this is an unusually clean application. Run Leanstral, Qwen, and Opus in parallel; take the first valid proof. Nobody in the thread explores the cost math here, but it's potentially more efficient than 16x passes of a single model.

**8. Vibe coding stigma is real and growing**

`teekert` articulates the emerging professional identity split: "Maybe it's good to not use 'vibe coding' as a synonym for programming with agent assistance. Just to protect our profession." `benterix` reports vibe-coding several projects and throwing them all away, wishing for the time back. Mistral's marketing leans into "trustworthy vibe-coding" — but the thread suggests serious practitioners actively reject the vibe-coding framing. Coupling formal verification with the term "vibe coding" may be actively counterproductive to reaching the audience that would value it most.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Opus still wins, cost savings irrelevant for correctness | Strong | Core value prop tension. 39.6 vs 31.9 matters when the whole point is trust |
| Agent-written tests are circular | Medium | Valid for TDD, but Lean's kernel-checked proofs break the circularity |
| Mistral models generally trail frontier | Strong | Consistent thread sentiment. Enterprise deals won't survive persistent quality gap |
| "Open source" vs "open weights" | Medium | `jasonjmcghee` correctly notes you can't reproduce the model. Minor point but recurring HN concern |
| EU sovereignty claims hollow while running on US clouds | Strong | `warpspin`'s critique is precise and unanswered |

### What the Thread Misses

- **The training data bootstrapping problem.** Lean 4 has a tiny corpus compared to Python/JS. How does Leanstral's training data quality compare? Nobody asks about data sourcing, which is likely the binding constraint on improvement.
- **Lean 4 ecosystem readiness.** `wazHFsRy` asks "is anyone actually shipping production code this way?" and gets zero responses. The thread debates the theory extensively without grounding it in current adoption — because adoption is near-zero outside research math.
- **The spec-writing bottleneck isn't going away.** Everyone agrees "humans write specs, agents prove them" is the right workflow. Nobody asks: how many developers *can* write formal specs? This is the real adoption barrier, not model quality. The thread is 90% engineers debating AI capabilities, 0% about whether the Lean learning curve is tractable.
- **Integration story is absent.** `drdaeman` asks "can this help me with my Go programs?" and gets no satisfying answer. The article shows no path from "Lean proof" to "deployed production code in language X." Without that bridge, this remains a research tool.

### Verdict

Leanstral is directionally important and practically premature. The thread correctly identifies that formal verification + AI agents is a powerful combination — pass@k with a deterministic oracle is a qualitatively different game than vibe coding with vibes-based tests. But the thread circles a truth it never states: **the bottleneck isn't the proving model, it's the absence of a Lean-integrated development workflow anyone outside the proof-assistant community could use.** Mistral built a better engine for a car that has no roads. The real product isn't a model — it's a toolchain that lets a Go or Rust developer write specs in something Lean-adjacent and get verified code back. Until that exists, Leanstral is an impressive research artifact competing with Opus on a benchmark that matters to approximately 200 people worldwide.
