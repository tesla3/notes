# Pi Coding Agent & Terminal-Bench — Research (Feb 2026)

## Question

Why is pi coding agent not on the Terminal-Bench leaderboard?

## Finding: Pi Was Likely Never Officially Added

Pi's results were **submitted but never published** on the official leaderboard.

### Evidence

1. **Submission was manual (email-based).** Mario Zechner's [blog post](https://mariozechner.at/posts/2025-11-30-pi-coding-agent/) (Nov 30, 2025) states: *"here's the results.json file I've submitted to the Terminal-Bench folks for inclusion in the leaderboard."* The [pi-terminal-bench](https://github.com/badlogic/pi-terminal-bench) repo confirms submission is done by emailing results to `mchlmerrill@gmail.com` / `alex@laude.org`.

2. **The leaderboard placement shown in the blog was self-calculated.** The blog shows an image of where pi *would rank* as of Dec 2, 2025 — not a screenshot of pi on tbench.ai. The repo includes a local `show-results.js` script for this purpose.

3. **Neither leaderboard lists pi today:**
   - **TB 1.0** (tbench.ai): 62 entries — no pi
   - **TB 2.0** (tbench.ai): 103 entries — no pi

4. **Possible reasons for non-inclusion:**
   - Email submission lost or deprioritized among 100+ entries from commercial agents
   - pi-mono repo on "OSS Vacation" until Feb 23, 2026 — Mario may not have followed up
   - Results may need re-running under updated Harbor framework

### Key Context

- **Agent:** pi coding agent ([badlogic/pi-mono](https://github.com/badlogic/pi-mono)) — 13.2k ★
- **Model used:** Claude Opus 4.5
- **Benchmark:** Terminal-Bench 2.0, k=5 (5 trials per task, leaderboard-eligible)
- **Adapter:** [badlogic/pi-terminal-bench](https://github.com/badlogic/pi-terminal-bench) (Harbor-based, open source)
- **Results:** [results.json gist](https://gist.github.com/badlogic/f45e8f6e481e5ab7d3a50659da84edaa)

---

## Credibility Assessment: High

The self-reported results are credible despite not being on the official leaderboard.

### Why credible

| Factor | Detail |
|---|---|
| **Automated verification** | Terminal-Bench tasks run in Docker sandboxes with verification scripts — pass/fail is objective, not subjective |
| **Reproducible** | Open-source adapter, public results.json, standard Harbor framework — anyone can re-run |
| **Standard methodology** | k=5 trials per task, same as all leaderboard entries |
| **Operational honesty** | Blog notes API error rates worsen during PST hours, started separate CET-only run — detail that signals genuine benchmarking |
| **Bug documentation** | Found and documented a Harbor `upload_dir` bug, published the patch |
| **Pi is just a harness** | The model (Claude Opus 4.5) does the heavy lifting — pi's minimal scaffold (4 tools, ~200 token system prompt) is the variable being tested |

### Only caveat

Self-reported results without independent verification carry less weight than official leaderboard entries. But given full reproducibility and the objective nature of Terminal-Bench verification, there is no strong reason to doubt the numbers.

### Key insight

Most benchmark variance comes from the **model**, not the harness. Pi's minimal approach (4 tools, tiny prompt, no sub-agents, no plan mode) performing comparably to heavier harnesses is actually the *expected* outcome — and is the central thesis of Mario's blog post.

---

## Terminal-Bench 2.0 Leaderboard Snapshot (Feb 2026)

Top 10 as of Feb 17, 2026:

| Rank | Agent | Model | Org | Accuracy |
|---|---|---|---|---|
| 1 | Simple Codex | GPT-5.3-Codex | OpenAI | 75.1% |
| 2 | CodeBrain-1 | GPT-5.3-Codex | Feeling AI | 70.3% |
| 3 | Droid | Claude Opus 4.6 | Factory | 69.9% |
| 4 | Mux | GPT-5.3-Codex | Coder | 68.5% |
| 5 | Deep Agents | GPT-5.2-Codex | LangChain | 66.5% |
| 6 | Mux | Claude Opus 4.6 | Coder | 66.5% |
| 7 | Droid | GPT-5.2 | Factory | 64.9% |
| 8 | Ante | Gemini 3 Pro | Antigma Labs | 64.7% |
| 9 | Terminus 2 | GPT-5.3-Codex | Terminal Bench | 64.7% |
| 10 | Junie CLI | Gemini 3 Flash | JetBrains | 64.3% |

Notable: **Terminus 2** (Terminal-Bench team's own minimal agent — raw tmux, no tools) ranks competitively at #9, reinforcing the thesis that minimal harnesses + strong models perform well.

---

## Has Anyone Run Updated Pi Against Terminal-Bench?

**No.** As of Feb 17, 2026, nobody has publicly run the latest pi (with updated system prompt and tool descriptions) against Terminal-Bench.

### Community Awareness

The [HN thread](https://news.ycombinator.com/item?id=46844822) (re-surfaced ~Feb 11, 2026) shows the community has noticed:

> *"Also please note this is nowhere on the terminal bench leaderboard anymore. I'd advise everyone reading the comments here to be aware of that. This isn't a CLI to use. Just a good experiment and write up."*

> *"I don't follow nor use pi so no horse in this race, but I think the results were never submitted to terminal bench? not sure how the process works exactly but it's entirely missing from the benchmark. is this a sign of weakness? I honestly don't know."*

### Why No Updated Run Exists

1. **Mario is on vacation.** pi-mono is on "OSS Vacation" until Feb 23, 2026 — no commits, PRs, or benchmark runs.
2. **Stale adapter.** The [pi-terminal-bench](https://github.com/badlogic/pi-terminal-bench) repo still references `claude-sonnet-4-5` in examples — hasn't been updated for Opus 4.6, GPT-5.3-Codex, etc.
3. **No community runs.** Despite 13.2k stars, no one has publicly reported running updated pi against TB 2.0.

### Closest Thing: oh-my-pi's Custom Benchmark

[can1357/oh-my-pi](https://github.com/can1357/oh-my-pi) — a pi fork with ~1,300 additional commits — ran a **react-edit-benchmark** (16 models, 180 tasks, 3 runs each). This tests edit tool formats (hashline vs str_replace vs patch), not Terminal-Bench. Key findings from the [blog post](https://blog.can.ac/2026/02/12/the-harness-problem/):

- Harness/tool changes alone swing model scores by **5–14 percentage points**
- Grok Code Fast 1: 6.7% → 68.3% (10× improvement) just by changing edit format
- Gemini 3 Flash: +5pp over str_replace, beating Google's own best attempt
- Thesis: *"The harness problem is real, measurable, and it's the highest-leverage place to innovate right now"*

This strongly suggests a fresh pi TB 2.0 run with updated tools could yield meaningfully different results than the Nov 2025 run — but nobody has done it.

### What a Fresh Run Would Show

Pi has evolved significantly since Nov 2025 (~2,961 total commits in pi-mono). A new TB 2.0 run with Opus 4.6 or GPT-5.3-Codex would clarify:
- Whether pi's updated system prompt / tool descriptions improve benchmark scores
- How pi compares to the current top agents (Simple Codex 75.1%, Droid 69.9%)
- Whether the oh-my-pi finding (harness matters more than people think) holds for Terminal-Bench tasks

---

## Sources

- Blog: https://mariozechner.at/posts/2025-11-30-pi-coding-agent/
- TB 2.0 Leaderboard: https://www.tbench.ai/leaderboard/terminal-bench/2.0
- TB 1.0 Leaderboard: https://www.tbench.ai/leaderboard/terminal-bench/1.0
- Pi Terminal-Bench adapter: https://github.com/badlogic/pi-terminal-bench
- Results gist: https://gist.github.com/badlogic/f45e8f6e481e5ab7d3a50659da84edaa
- Artificial Analysis TB Hard: https://artificialanalysis.ai/evaluations/terminalbench-hard
- HN discussion (Feb 2026): https://news.ycombinator.com/item?id=46844822
- oh-my-pi (pi fork): https://github.com/can1357/oh-my-pi
- oh-my-pi harness blog: https://blog.can.ac/2026/02/12/the-harness-problem/
- oh-my-pi edit benchmark: https://github.com/can1357/oh-my-pi/tree/main/packages/react-edit-benchmark
