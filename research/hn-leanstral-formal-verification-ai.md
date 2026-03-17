← [Index](../README.md)

## HN Thread Distillation: "Leanstral: Open-source agent for trustworthy coding and formal proof engineering"

**Source:** [HN](https://news.ycombinator.com/item?id=47404796) · [Article](https://mistral.ai/news/leanstral) · 624 pts · 139 comments · 2026-03-16

**Article summary:** Mistral releases Leanstral, an Apache-2.0 licensed 120B-A6B MoE model specifically trained for Lean 4 formal proof engineering. Benchmarked on FLTEval (completing proofs in PRs to the Fermat's Last Theorem formalization project). At pass@1 (21.9) it trails Haiku (23.0) and Sonnet (23.7); at pass@2 (26.3) it surpasses both and all open-source competitors; at pass@16 (31.9, ~$290) it narrows the gap to Opus (39.6, $1,650) but doesn't close it. The article's claim that performance "continues to scale linearly" is challenged by `igravious`, who notes diminishing returns visible in the chart.

### Dominant Sentiment: Excited about the direction, mixed on this product

The thread is genuinely energized by the convergence of formal verification and AI agents — 624 points reflects real interest. But reactions to Leanstral itself split: the proof-engineering community sees a useful, efficient open-weights tool; generalists struggle with why they should care when Opus still wins and they don't know Lean. The cost-vs-correctness tension in the marketing lands poorly with the latter group.

### Key Insights

**1. pass@k with a proof kernel is a qualitatively different game**

`ainch`: "pass@k means you run the model k times and give it a pass if any of the answers is correct. Lean is one of the few use cases where pass@k actually makes sense, since you can automatically validate correctness." Other coding domains have pass@k via test suites, but those suites are *incomplete* — passing all tests doesn't guarantee correctness. Lean's kernel is a *complete verifier*: if the proof type-checks, it is mathematically valid. This means you can brute-force attempts with certainty that a success is real, not a false positive. The cost-per-attempt becomes the competitive axis, not single-pass quality — and that's where Leanstral's 6B active parameters and $18/pass economics matter.

**2. The "who watches the watchmen" problem has a real answer**

`TimTheTinker` raises the natural concern: if the agent writes the Lean spec, aren't we back to square one? `justboy1987` gives the thread's star comment: "You're not trusting the agent — you're trusting the kernel." The Lean type-checker is ~10k lines, heavily scrutinized by the PL community. The idealized workflow: human writes spec (creative, domain-expertise work), agent generates proof, kernel mechanically verifies. The agent can hallucinate freely — invalid proofs get rejected deterministically. This is a genuinely different trust model from "hope the tests are good." Caveat: `AlotOfReading` notes from SeL4 experience that "knowing whether those theorems are the *right* theorems for the problem can be as difficult as understanding the implementation itself" — the kernel guarantees the proof is *valid*, not that it proves *what you intended*.

**3. Translate-to-formal-language is already a working bug-finding workflow**

`baq` describes a concrete, production-relevant approach: "yesterday I had to tell a frontier model to translate my code to tla+ to find a tricky cache invalidation bug which nothing could find... translation took maybe 5 mins, the bug was found in seconds, total time to fix from idea to commit — about 15 minutes." And crucially: "if you can get a model to quickly translate a relevant subset of your code to lean to find tricky bugs and map lean fixes back to your codebase space, you've got yourself a huge unlock. (spoiler alert: you basically can, today)." This answers `drdaeman`'s question ("can this help my Go programs?") more convincingly than anything else in the thread: you don't rewrite in Lean, you *translate a subset* for verification, then map fixes back. The workflow exists today, albeit for sophisticated users.

**4. The spec-vs-implementation asymmetry is the real unlock — but proof length is a red herring**

`justboy1987`: "A formal spec in Lean is typically 10-50x shorter than the code it proves correct." `specvsimpl` (new account, single comment — treat with source caution) extends with Fermat's Last Theorem: every teenager understands the statement, the proof is thousands of pages. `AlotOfReading` counters with SeL4: 8.7k lines of C required 100k+ lines of proof and 15k lines of Isabelle spec. But `auggierose` makes the crucial clarification: "You are confusing the proof with the spec/theorem. A correct proof and a valid proof are the same thing. It doesn't really matter how long the proof is, and you don't even need to understand it for it to be correct, the machine can check that." The proof can be arbitrarily long — that's the machine's problem. What matters is whether the *spec/theorem* is readable and captures intent. SeL4's 100k-line proof is irrelevant; its 15k-line spec-vs-8.7k-line implementation ratio is the real concern.

**5. TDD-as-alignment is converging — but "passing tests ≠ understanding" is the dissent**

`cadamsdotcom`'s top comment articulates the broader thesis: executable verification suites encode *details*, not intent, and cost zero tokens when correct. `tonymet`: "AI is the reality that TDD never before had the opportunity to live up to." `nextos` extends to Amazon's property-based testing via Kiro. The convergence from TDD to QuickCheck-style property testing to full formal methods is visible — a ladder of verification granularity that AI agents can climb.

But the thread's TDD skeptics are substantive. `discreteevent`: "Vibing is not understanding... Vibe programmers make a mess of the codebase piling on patch after patch. But they get the tests to pass! Vibing gives you something like the geocentric model of the solar system. It kind of works but it's much more complicated and hard to work with." `pydry`: "This assumes that tests are realistic, which for the most part they are not." `cowboy_henk`: "The moment you let the LLM write the tests without understanding them, you may as well just let it write the code directly." `bluGill` warns about tests encoding *implementation details* rather than intended behavior, blocking refactoring. The dissent centers on a real gap: passing machine-checkable constraints is not the same as producing comprehensible, maintainable software.

**6. Mistral's sovereignty story is contested but evolving**

`ainch` identifies the business dynamic: Mistral is chasing enterprise deals (HSBC, ASML, AXA, BNP Paribas) as a French "national champion" amid anti-US sentiment. `warpspin` challenges: "Mistral runs its own stuff on US Cloud Act affected infrastructure... If I accept a level of 'independence' whereby I run on AWS or Azure, I could as well pay for Anthropic or GPT for SOTA performance." The critique lands, but isn't the full picture. `tin7in`: "They are building their own infra - south of Paris and another one was announced in Sweden recently." `kimsant` reframes the value as vendor lock-in avoidance: "I don't care about the servers... The key is to avoid chantage [extortion], remember Oracle with DBs." And the Apache-2.0 open weights genuinely enable self-hosting — `nimchimpsky`: "the model is open source, you can run it locally. You don't think that's significant?" The sovereignty proposition is incomplete today but not empty, and the open-weights angle is substantively different from API-only competitors.

**7. LLM alloys for formal verification have unexplored potential**

`patall` asks whether mixing different models across passes would improve results. `andai` confirms this is called an "LLM alloy" and cites research showing the less overlap in correctly solved problems between models, the greater the boost. For formal verification — where you have a complete verifier and pass@k is meaningful — this is an unusually clean application. Run Leanstral, Qwen, and Opus in parallel; take the first valid proof. Nobody in the thread explores the cost math, but it's potentially more efficient than 16× passes of a single model.

**8. MDD failed for 20 years — LLMs may be the missing piece**

`rusk` on why model-driven development never delivered: "MDD never really worked because the tooling never really dealt with intent. You would get so far with your specifications but the semantic rigidity of the tooling meant that at some point your solution would have to part way. LLM is the missing piece that finally makes this approach viable where the intent can be inferred dynamically." This connects Leanstral to a 20-year arc of failed spec-to-code paradigms. UML, executable models, code generation — all stumbled on the gap between formal specification and messy real-world intent. LLMs bridge that gap by inferring intent dynamically, while formal verification keeps the output honest. The combination might finally make spec-driven development viable.

**9. Vibe coding stigma is real and Mistral's marketing aggravates it**

`teekert`: "Maybe it's good to not use 'vibe coding' as a synonym for programming with agent assistance. Just to protect our profession." `benterix` reports vibe-coding several projects and throwing them all away. The article's subtitle is literally "trustworthy vibe-coding" — coupling formal verification (which appeals to rigor-seeking engineers) with a term that serious practitioners actively reject may be counterproductive to reaching its natural audience.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Opus still wins; cost savings irrelevant for correctness | Strong | 39.6 vs 31.9 matters when trust is the pitch. But pass@k economics complicate this — see Insight 1 |
| Agent-written tests are circular | Medium | Valid for TDD; Lean's kernel breaks the circularity, though spec correctness remains human-dependent |
| Mistral models generally trail frontier | Strong | Consistent sentiment. Multiple users push back with real usage (`badsectoracula`, `chucky_z`, `brainless`, `Adrig`, `Fnoord`), but the quality gap on frontier tasks is acknowledged |
| "Open source" vs "open weights" | Medium | `jasonjmcghee`: can't reproduce the model. Apache-2.0 weights is genuinely good; "open source" is still imprecise |
| "Scales linearly" claim is false | Medium | `igravious`: "it clearly and demonstrably does not" from the chart. Diminishing returns visible |
| EU sovereignty hollow on US clouds | Medium | Real today per `warpspin`, but evolving: own infra in France/Sweden (`tin7in`), and open weights enable self-hosting |

### What the Thread Misses

- **The training data bootstrapping problem.** Lean 4 has a tiny corpus compared to Python/JS. Nobody asks about data sourcing, which is likely the binding constraint on improvement. The FLT project itself is a narrow training/eval domain.
- **The spec-writing bottleneck.** Everyone agrees "humans write specs, agents prove them" is the right workflow. Nobody asks: how many developers *can* write formal specs? This is the real adoption barrier, not model quality.
- **Lean as a programming language, not just a proof assistant.** `trenchgun` built a shell + most of Unix coreutils in Lean 4 with Claude Code "in a couple of hours" and notes you can "start moving up the verification ladder piece by piece." `strongly-typed` proposes using Lean as an orchestrator of verified interfaces with extraction to performant languages. This bottom-up path — write in Lean, verify incrementally, extract to C/Rust — gets less attention than it deserves.
- **What Opus is actually doing differently.** Opus leads by ~8 points. Nobody asks *why* — whether it's better chain-of-thought, more Lean training data, or architectural advantages. Understanding the gap would tell you whether specialized models like Leanstral can close it.

### Verdict

Leanstral matters more than its benchmark position suggests, and for reasons the thread mostly gets right. The core insight is structural: formal verification gives AI agents a *complete* oracle, making pass@k a fundamentally different strategy than retry-until-tests-pass. That property, combined with Apache-2.0 weights and 6B active parameters, creates a real niche — not cheap Opus, but a self-hostable verification engine you can run in parallel at scale.

The thread's sharpest tension goes unnamed: **the people who can use Leanstral (proof engineers, formal methods researchers) don't need the "trustworthy vibe coding" pitch, and the people who need trustworthy coding can't use Lean.** `baq`'s translate-to-formal-language workflow hints at the bridge — but it requires frontier-model sophistication to do the translation, which means Leanstral alone isn't the product. The real unlock is a *pipeline*: frontier model translates a code subset to Lean, Leanstral proves it, fixes map back. Nobody is shipping that pipeline yet, but the pieces exist. Leanstral is a necessary component in a system that doesn't quite exist — which is exactly where you want to be if you're building infrastructure for the next paradigm.
