← [Coding Agents](../topics/coding-agents.md) · [Index](../README.md)

## HN Thread Distillation: "An AI agent coding skeptic tries AI agent coding, in excessive detail"

**Source:** [minimaxir.com](https://minimaxir.com/2026/02/ai-agent-coding/) by Max Woolf (minimaxir) · [HN thread](https://news.ycombinator.com/item?id=47183527) (56 pts, 9 comments, 8 authors)

**Article summary:** Max Woolf — former Apple QA engineer turned BuzzFeed data scientist, prolific open-source contributor (Big List of Naughty Strings, stylecloud), and self-described agent skeptic — documents his conversion arc from dismissing agentic coding (May 2025) to shipping multiple Rust-with-Python-bindings libraries using Opus 4.5/4.6 and Codex 5.2/5.3. The article has four distinct phases: simple Python tasks (YouTube scraper) → Rust side projects with no benchmark claims (icon-to-image, word clouds, miditui, ballin) → ML benchmaxxing pipeline → reflections. The centerpiece claim comes only in the third phase: a "benchmaxxing" pipeline (implement → benchmark → optimize with Codex → optimize again with Opus → validate accuracy) produces ML algorithm implementations in Rust that beat established libraries by 2–100×. He's now building `rustlearn`, an agent-coded scikit-learn port. Woolf's ML expertise is practical and self-taught (CMU business degree, not CS) — relevant context for evaluating his "domain expert oversight" of algorithm implementations.

### Article Critique

The article is unusually well-structured for this genre — it escalates from trivial tasks (YouTube scraper) to genuinely ambitious ones (beating numpy at dot products with BLAS), which makes the escalation feel earned rather than hype-driven. Woolf's credibility is bolstered by releasing `nndex` as proof alongside the post rather than just making claims. He also doesn't hide failures: the fontdue curves problem, rapier 0.32.0 crashes, Copilot's poor performance with Sonnet 4.5 on data science notebooks, and extensive UI bugs in miditui are all narrated.

However, there's a tension the article doesn't resolve. Woolf's most impressive results (the ML benchmarks) come from a pipeline that *requires* deep domain expertise to design: knowing which algorithms matter, what representative benchmark sizes are, what "cheating" looks like in benchmark construction, and when output quality is suspiciously divergent. This isn't vibecoding — it's closer to being a technical PM who happens to have a tireless staff engineer. The article's framing as "skeptic tries agents" undersells the skill floor required to reproduce his results. And Woolf's practical-but-self-taught ML background raises a question the article doesn't address: is his oversight sufficient to catch subtle algorithmic errors in HDBSCAN or UMAP that a specialist would spot? He can design representative benchmarks and check MAE against known implementations, but that's not the same as auditing the algorithm's correctness on edge cases.

The benchmark claims also deserve scrutiny. Beating Python's xgboost by 24–42× on fit time is impressive but could partly reflect xgboost's Python overhead and safety checks rather than a fundamentally better algorithm. The `nndex` comparison against numpy is more credible because dot products are so well-understood that the comparison surface is small. The HDBSCAN "23–100× faster than the Rust crate" number is eye-catching but the existing `hdbscan` Rust crate may simply be unoptimized — beating a weak baseline isn't the same as achieving an algorithmic breakthrough. Woolf acknowledges the need for skepticism but releases only the simplest project (`nndex`) as evidence, leaving the strongest claims (rustlearn, UMAP, GBDT) unverifiable.

### Dominant Sentiment: Measured validation with expertise caveats

The thread is small (9 comments, 8 authors) and anchored by one genuinely prominent voice (simonw, ~100K karma, Django co-creator). The other commenters are lower-profile — see source notes on key contributors below. The one dissenter (rudiksz) gets swatted down immediately by simonw.

### Source Notes

| User | Karma | Account | Note |
|------|-------|---------|------|
| simonw | ~99,800 | 2007 | Django co-creator. High-credibility endorsement. |
| 7777777phil | 1,068 | Aug 2025 | **Is Philippe Dubach** (`me@philippdubach.com`) — author of the "Impossible Backhand" essay he links in the thread. Self-promotion, not independent endorsement. |
| sarkarsh | 3 | Jan 2016 | 3 karma in 10 years. Near-dormant account. Meta-commentary is articulate but has no demonstrated HN standing. |
| verdverm | — | — | AGENTS.md practitioner. |
| ej88 | — | — | Practitioner confirmation. |
| ivraatiems | — | — | Pro-agent practitioner. |
| rudiksz | — | — | Sole dissenter. |

### Key Insights

**1. AGENTS.md is the actual product, not the model**

The thread's most consistent theme: the differentiator isn't Opus vs. Sonnet, it's the accumulated craft in the AGENTS.md file. verdverm: *"I second that spending effort on your AGENTS.md is game changing. Don't auto generate these, work with them and learn how to make them good."* Woolf's article makes the same point — his results collapsed without the file. This reframes agent skill as prompt engineering's mature successor: a persistent, version-controlled instruction set that encodes domain taste. The uncomfortable implication is that "agents are bad" and "agents are good" can both be accurate reports from people using identical models, separated only by scaffolding quality.

**2. The expertise-leverage amplifier, not the expertise-replacement tool**

7777777phil links to Philippe Dubach's ["The Impossible Backhand"](https://philippdubach.com/posts/the-impossible-backhand/) essay — **noting that 7777777phil *is* Dubach, promoting his own piece.** The essay argues domain expertise is *appreciating* because AI converges to the mean (via next-token prediction, RLHF typicality bias at α=0.57, and model collapse). ej88 names the applied dynamic: *"they essentially offer leverage, and the more skill someone already has the higher their ceiling will be."*

The Dubach essay is well-argued and well-sourced (HLE 53-point gap, Harvard/BCG centaur study, ninth-power scaling costs). But there's a tension neither the thread nor Dubach addresses: **if AI systematically converges to the mean, how is Woolf's benchmaxxing pipeline producing *above-mean* optimizations that beat established libraries?** Either the "convergence to mean" thesis has exceptions (iterative optimization with quality feedback loops is one such exception), or Woolf's results are less impressive than they appear (beating weak baselines, not achieving genuine outlier performance). This contradiction deserves more attention than it gets.

**3. The ivraatiems/rudiksz exchange reveals a bifurcating user population**

ivraatiems reports Claude generating "highly effective and usable code, usually nearly as good or as good as what I'd do myself, with guidance." rudiksz flatly rejects this: *"Claude isn't generating code that is 'highly effective and usable code'."* simonw's retort is sharp: *"If you're not getting effective and usable code out of modern Claude you don't know how to use it."* sarkarsh provides the meta-read: *"Both are probably reporting their experience accurately, which means the variance in agent coding outcomes is enormous."* This isn't the usual HN flamewar — it's a genuine epistemic problem. If outcomes are bimodal and the determining factor is tacit knowledge about scaffolding, then anecdotal evidence about agent quality is nearly worthless without knowing the user's setup.

**4. The "cold start" problem — real but widely recognized**

sarkarsh: *"there's no structured way for agents to carry context across sessions. Each session starts cold. You're hand-maintaining the agent's long-term memory in a markdown file."* AGENTS.md is a manual workaround for what should be infrastructure. Woolf's workflow — saving prompts as versioned markdown, committing with references to prompt files — is essentially hand-rolled session memory. This observation is accurate but not novel — persistent agent memory is one of the most-discussed topics in the agent tooling space (Claude Memory, Cursor's rules evolution, pi's own AGENTS.md mechanism). The gap is widely recognized; what's missing is a good solution, not the diagnosis.

**5. The benchmaxxing pipeline is interesting but less novel than it appears**

The article's most interesting contribution isn't any individual project — it's the methodology. Implement → benchmark with criterion → optimize with Codex → optimize again with Opus → validate against known-good implementation. The claim that chaining *different* models produces better optimizations than either alone is plausible — different models have different training distributions and RLHF signals, so they explore different optimization strategies, analogous to ensemble diversity in ML. But Woolf doesn't explain *why* this works, the thread doesn't interrogate it, and the effect could be confirmation bias or noise. The genuinely non-obvious question would be: *which* complementary strategies do Codex and Opus employ? Does one favor algorithmic restructuring while the other favors micro-optimization? Without that, "chain two models" is a recipe, not an insight.

**6. Simon Willison's endorsement carries signal — including for the benchmark claims**

simonw calling this "my favorite yet of the genre" is notable because Willison tracks agent tools closely. His full comment: *"It starts with relatively simple examples (YouTube metadata scraping) and by the end Max is rewriting Python's skikit-learn framework in Rust and **making it way faster**."* He's endorsing both the narrative escalation *and* the performance claims — the italicized "making it way faster" is not hedged. This is a stronger endorsement than a careful reading might expect from Willison.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Claude doesn't generate effective code" (rudiksz) | Weak | Asserted without evidence or setup details. simonw's retort ("you don't know how to use it") landed because rudiksz offered no counter-specifics. |
| Implicit: benchmark numbers seem too good | Medium | Valid concern — only `nndex` is released for verification. But Woolf acknowledges skepticism is fair and his disclosure of failures elsewhere builds some trust. |
| Implicit: this is just vibecoding | Weak | The article's detailed AGENTS.md, multi-step pipeline, and accuracy validation explicitly refute this. |

### What the Thread Misses

- **Maintenance and debugging cost is unexamined.** Woolf describes *creating* code but never maintaining agent-written codebases over months. The rapier 0.32.0 anecdote is actually evidence *against* the expert-oversight narrative: Woolf couldn't construct a minimal repro and couldn't even tell whether the crash was a real regression or Opus not knowing the new API. He just rolled back to 0.31.0. Agent-written code you can't debug is a liability, not an asset. How does `rustlearn` get maintained when the next model version produces subtly different optimization strategies?

- **The benchmark pipeline's failure modes.** What happens when the agent "optimizes" by introducing numerical instability that only manifests on edge-case inputs not in the benchmark? Woolf's accuracy-validation step (minimize MAE against known implementation) partially addresses this, but MAE on benchmark inputs ≠ correctness on the distribution. Nobody in the thread asks about this.

- **The Dubach-vs-Woolf contradiction.** Dubach's essay (linked approvingly in the thread) argues AI converges to the mean and can't produce outlier quality. Woolf's pipeline claims to produce outlier performance. If both are right, the resolution is probably that iterative optimization with measurable feedback (benchmarks + accuracy checks) is a domain where AI *can* exceed the mean because the objective function is explicit and measurable — unlike creative or judgment tasks where "quality" is fuzzy. This would mean the centaur thesis has a domain-dependent boundary that neither the essay nor the thread maps.

- **Selection bias is present but less severe than it seems.** Woolf does disclose failures (fontdue, rapier, Copilot with Sonnet 4.5, miditui UI bugs). But the effective cost — API spend, wall-clock time, failed optimization passes that got rolled back — is never quantified. "~10 prompts for icon-to-image" tells you the iteration count but not the failure rate or cost.

- **The résumé question is more interesting than Woolf realizes.** He asks it half-jokingly, but it points at a real institutional problem: if agent-aided work can't be credentialed, the people best positioned to use agents (experienced engineers) have the least incentive to publicize it, creating a weird silence around actual adoption.

### Verdict

The article is strong evidence that *scaffolded* agent coding with practitioner oversight produces genuinely impressive results — but the thread correctly identifies that the operative word is "scaffolded." What nobody quite says: the AGENTS.md workflow is reinventing the specification document. Woolf's prompts are detailed specs; his AGENTS.md is a coding standard; his benchmark-then-optimize loop is a performance requirement with acceptance criteria. The "agent revolution" in this framing is less about AI writing code and more about the return of rigorous specification as a first-class engineering artifact — something the industry abandoned when Agile made "just talk to the developer" the default. The irony is that the people who'll be best at agent coding are the ones who remember how to write specs, which skews heavily toward experienced engineers who lived through waterfall. The demographic that's most skeptical of agents is the one best equipped to use them.

The thread's main limitation is its size (9 comments) and source quality. It's anchored by one high-credibility voice (simonw), supplemented by a self-promoting essayist (7777777phil/Dubach) and a near-dormant account offering articulate but unanchored meta-commentary (sarkarsh). The insights are directionally correct but shouldn't be treated as consensus — they're a small, sympathetic sample.
