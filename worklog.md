# Worklog

> **Note:** File paths in entries before 2026-02-17 session 7 refer to the flat structure
> before the notes reorg. See [README.md](README.md) for current file locations.

## 2026-03-04 — Second-round edge case review of tool-use rules

- Re-reviewed `research/agent-tool-use-self-review.md` stress test with 22 independent tests against 273 session files
- **7 broken rules found:**
  - `head -1 | wc -c` safety check broken on ALL JSONL files (first record = 147-byte header, data records up to 700x larger)
  - `rg -A/-B` context lines completely absent from both docs — it's the best single-call section extractor
  - `rg -l` is a dead end when `rg -n` is always the better first call
  - `ls` default sort is alphabetical; `ls -t` is almost always more useful for agents
  - Snowball "~10 remaining turns" is wrong: 4x underestimate at session start, 2.5x overestimate at end
  - `| tail -20` doesn't capture stderr-only output; needs `2>&1 |`
  - File size < 5KB threshold fires on only 2% of research files; wrong axis (search-target-available is correct)
- **2 missing tools:** `rg -A/-B` (context lines), `rg -F` (literal string search)
- **Meta-finding:** conditional rules spawning sub-rules for each exception → rules keep getting longer. Tool selection is a decision tree, not a rule set.
- Decision: not restructuring into decision tree yet — evidence first, format second
- **Follow-up: Expert CLI tricks research** (`research/expert-cli-tricks-for-context-saving.md`)
  - Searched and read: "The Art of Command Line" (jlevy), wooledge BashPitfalls, learnbyexample grep/rg gotchas, HN threads (41031837, 20493467), MIT Missing Semester, Eric Pement awk one-liners
  - 9 techniques missing from agent rules: process substitution `<()`, `comm` for set operations, `jq -e` for zero-output boolean checks, `awk` for single-pass field extraction, `--` for hyphen-prefixed patterns, `LC_ALL=C` (36% speed boost, tested), `stat` for metadata, `sed -n` with quit-early, `find -exec {} +` for safe batching
  - 5 expert-level edge cases: pipe subshell trap (variables don't persist), redirect order (`2>&1` position matters), `set -e` kills `grep -c` on zero matches, word splitting after command substitution, glob expansion of unquoted `*`
  - Meta-finding: experts think in **operations** ("extract a section", "compare two sets", "check a condition"), not **tools** ("when to use rg", "when to use jq"). Operation-oriented rules naturally compose the right tools; tool-oriented rules miss compositions.
  - Cross-linked from `agent-tool-use-self-review.md`

## 2026-03-03 — HN distill: "Nobody Gets Promoted for Simplicity"

- Distilled HN thread (173 pts, 65 comments) on terriblesoftware.org article
- Article bundles two claims: simplicity is unrewarded (headline) + here's how to get rewarded for it (body). Thread notices the contradiction.
- Key thread findings:
  - Multiple commenters (kstrauser, cyberax, ChadMoran, semiinfinitely) report being promoted for simplicity — but always by *replacing* visible complexity, not building simple from scratch
  - sssilver (former EM): promotions decided by manager's manager who can't distinguish "easy problem" from "hard problem made easy" — legibility at distance is the structural barrier
  - bob001: promotion ladders literally encode complexity in criteria ("year-long initiative", "multiple teams")
  - Swizec: on-call ownership as simplicity incentive — engineers simplify fast when they carry the pager
  - al_borland + abustamam: firefighter-arsonist anti-pattern confirmed from personal experience
  - losalah: unearned complexity as leverage — builder gets the bonus, team services the payments
- Thread misses: AI-generated code amplifies the problem (complexity bottleneck was effort, now removed); measurement void is the real story (no metrics for changeability/maintenance cost); third option beyond "ship simple and hope" or "overbuild" is deliberate judgment trail (ADRs, threshold triggers)
- Saved to `research/hn-nobody-gets-promoted-for-simplicity.md`

## 2026-03-02 — Brainstorm: Pi as Stateful Actor with A2A

- Synthesized research across A2A integration analysis, Durable Objects/Rivet Actors, Software Architecture AI Era, Elixir agent frameworks HN thread, durable execution landscape, and fresh internet search (ActorCore launch, AgentMaster paper, Spring AI A2A patterns, Google ADK Interactions API)
- Core insight: Pi sessions and stateful actors are structurally isomorphic — Pi is already an actor that doesn't know it's an actor
- Designed three-layer architecture: Actor Runtime (Rivet) → Pi Agent Core → A2A Protocol Adapter
- Identified novel patterns: agent specialization via actor templates, agent swarms via actor spawning, institutional memory as shared actor, durable multi-step workflows, A2A service mesh for coding
- Addressed hard problems: filesystem access (git worktrees), preemptive scheduling gap, cost model, trust tiers, context window management, ACP bridge
- Estimated ~3,500 LOC for full system, proposed 5-phase implementation path
- Output: `research/brainstorm-pi-a2a-stateful-actor.md`
- Self-critique and consolidation: graded B-. Consolidated critique back into main document — corrected LOC estimates (3.5K → 10-18K realistic), cost model ($90 → $3-10K per fleet op), added verification gap as biggest issue, Rivet maturity risk, competitive landscape (Agent Teams, Codex, Kiro), durable checkpoint limits for LLM agents, git worktree merge conflict realities, A2A opacity tension. Deleted separate critique file.
- Key conclusion: "Beautiful architecture. Wrong year. Do verification first. Revisit late 2026."

## 2026-03-01 — Pi A2A integration analysis & RPC deep dive review

- Reviewed `research/pi-rpc-mode-deep-dive.md` — architecture analysis still solid, A2A section now stale (spec moved to RC v1.0 with renamed methods, new data model)
- Researched broader pi RPC use cases beyond editor integration: CI/CD pipelines, multi-agent orchestration, platform bots, web dashboards, desktop app embedding, automated benchmarking
- Deep dive into A2A protocol: read RC v1.0 spec, Agent Card structure, task lifecycle states, message/send and message/stream methods, Parts/Artifacts data model, SSE streaming, auth requirements
- Researched ACP (Agent Client Protocol): Zed/JetBrains/Neovim/Cline/Kiro/Gemini CLI/PraisonAI ecosystem, JSON-RPC 2.0 over stdin/stdout, TypeScript SDK
- Created `research/pi-a2a-integration-analysis.md`:
  - 8-layer implementation breakdown: HTTP server, Agent Card generation, JSON-RPC dispatch, task lifecycle, content translation, SSE, auth, session mapping
  - Total estimate: ~1,500-2,200 LOC (3-4× the RPC mode)
  - Hardest part: extension UI protocol → A2A INPUT_REQUIRED state mapping
  - Open problems: concurrency (pi is single-threaded), multi-tenancy, tool permissions for non-human A2A clients, working directory isolation
  - Key recommendation: **ACP first** (~500-800 LOC, 10× more value, mechanical translation), A2A second as extension/package
  - Architecture diagram for A2A-via-extension approach
  - Critical assessment: architecturally misaligned with pi's local/interactive/single-user design, but extension system makes it feasible without core changes
- Updated README with new research entry

## 2026-02-28 — Meta-review: critical self-analysis of insights corpus

- Created `meta-review.md` — thorough critical review of the entire insights corpus, its interpretation, and two rounds of LLM analysis
- **What I got wrong in the "surprises" analysis:**
  - "No historical precedent" for writing degradation — false (code-switching, hiding literacy, many precedents)
  - Tobacco comparison — irresponsible (n=54 preprint vs 480K deaths/year)
  - Democracy/labor leverage as discovery — well-trodden (Standing 2011, Susskind 2020, Acemoglu 2019)
  - Gemini "four-alarm finding" — credulous (broken demo, unmasked model names, shredded methodology)
  - "Pre-war steel" contamination as unsolvable — ignored corpus's own semantic-search evidence
  - Non-transferable workflows as novel — familiar phenomenon, different scale
  - "Goodhart's Law everywhere" as unifying theory — just Goodhart's Law (1975)
- **Structural blind spots in the corpus:**
  - 58% of research files are HN thread distillations — narrow, non-representative population
  - Systematic negativity bias — almost every insight argues AI fails; positive evidence treated as exceptions
  - Temporal boundary acknowledged but not enforced per-citation
  - Almost no evidence from outside Anglophone tech world
  - Cross-referencing creates illusion of convergent evidence when upstream sources are shared
- **Key structural findings:**
  - Culture Amplifier is the containing insight — most other insights are special cases
  - Two completely different AI stories (organizational ~10% / individual activation energy) need separate frameworks
  - Skill atrophy → specification quality death spiral (from harness-leverage review) deserves elevation
  - Compliance-without-conviction spiral (mandates + flat productivity + falling confidence) is real and undernamed
- **Tier classification:** Broken Abstraction Contract, Brooks-Naur, Volume-Value Divergence, Verification Gate strongest. Naur's Nightmare, Apprenticeship Doom Loop, Anticipatory Displacement have thinner evidence than presentation suggests.
- **Epistemic lesson:** First response performed curation as analysis. Second response performed insight as analysis. Both demonstrated the failure modes the corpus predicts (Cognition ≠ Decision, Double Anti-Novelty Lock).
- Added meta-review.md to README collections
- Next: consider restructuring insights.md around Culture Amplifier as meta-principle; add evidence-tier tags; elevate Activation Energy

## 2026-02-28 — Skills deep synthesis: when, why, ROI

- Wrote `research/skills-deep-synthesis-when-why-roi.md` — structural analysis of when skills create durable value vs waste
- Durability filter: most skills on skills.sh are transitional (categories 1-2 get absorbed into training data). Only private knowledge, personal conventions, and staleness patches survive.
- Five structural archetypes: Verification Gauntlet (#1 leverage, consensus evidence), Compounding Loop (sleeper hit, requires frequency), Specification Scaffold (JUXT case, SDD mainstream), Behavioral Constitution (cheapest, universal), Tribal Knowledge Codifier (most durable, hardest to outsource)
- ROI matrix: total initial investment ~6-12 hours for complete stack. Build bottom-up (gauntlet → constitution → loop → scaffold → tribal knowledge)
- Three anti-patterns: Competence Illusion (downloading expertise you can't evaluate), Context Tax (too many skills), Delegation Spiral (automation without engagement)
- Five unbuilt skills with structural demand: verification scaffold generator, cross-session memory architect, skill auditor that isn't itself an attack, brownfield onboarding, cognitive rest pacer
- Meta-insight: skills are engineering infrastructure not features. The most valuable skill is the one you write yourself, for your own codebase. Everything else is transitional.
- Connected insights: Skill Author Competence Paradox, Steering ∝ Theory, Hidden Denominator, Culture Amplifier, Workflow as Tribal Knowledge, Broken Abstraction Contract, Cognitive Rest Erosion
- Critical self-review (`research/skills-deep-synthesis-critical-review.md`):
  - Seven problems: fabricated ROI numbers, category confusion (skills vs harness engineering), selective survivorship bias, unvalidated compounding metaphor
  - Six missing pieces: co-training dissolution, skill atrophy death spiral, observability archetype, audience mismatch, skill format vs alternatives, archetype erosion timelines
  - Three internal contradictions: transitional-but-valuable, hidden-denominator hypocrisy, infrastructure-claim without format validation
  - Key correction: archetypes erode top-down under model improvement (constitutions first, tribal knowledge last) — may invert "build bottom-up" for long-horizon planning
  - Honest version: "Five types of engineering practices that work. I don't know the ROI. Nobody does."
- Updated README with link

## 2026-02-28 — Antidotes to post-Nov 2025 model failures

- Wrote `research/post-nov-2025-model-failure-antidotes.md` — 20 evaluated countermeasures for every failure class in the taxonomy
- Three structural principles: isolation (reward signal removal, sandboxing, least-privilege), verification (CRV white-box, NLDD faithfulness metric, external ground-truth), structure (task-topology matching, session boundaries, ownership tracking)
- Key sources: Google DeepMind scaling study (arXiv:2512.08296), Zhao et al. CRV (ICLR 2026 Oral), Ye et al. NLDD (arXiv:2602.11201), Baker et al. CoT monitoring (OpenAI), EleutherAI djinn testbed, CodeScene code health (arXiv:2601.02200), OWASP agent security, Gravitee 2026 report
- Each antidote rated on evidence quality, first-principles soundness, and practitioner viability (Strong/Moderate/Weak)
- 12 rated Strong, 6 Moderate, 1 Weak, 1 conditional (strong for parallel tasks only)
- Meta-finding: none of these solve the fundamental capability-reliability tension — they buy time, reduce blast radius, catch errors
- Updated README with link to new file

## 2026-02-28 — Critical review of LLM capability analysis

- Wrote `research/llm-capability-pseudo-cap-critical-review.md` — thorough self-critique of the `llm-capability-vs-pseudo-capability.md` analysis
- Laser focus on post-Nov 2025 evidence: step function in agentic capability, test-time compute scaling, multi-agent productization, computer use breakthrough, open-weight convergence, emergent strategic deception
- Key finding: original analysis is correct about mechanisms but miscalibrated about magnitudes; the post-Nov 2025 model generation changed what "context-directed extrapolation" can accomplish
- Added forward link from original analysis and topic page
- Five revised verdicts on the original headline findings
- Wrote `research/context-directed-extrapolation-critical-analysis.md` — deep epistemological critique of the Bonial "context-directed extrapolation" framework
- Finding: the framework is **not falsifiable** (protected by training-data opacity, compositionality retreat, mechanism substitution), **not quantifiable** (no metrics, no functional forms, no predictions), and **strains under post-Nov 2025 evidence** (Othello-GPT, ICL with random labels, test-time compute scaling, C compiler, ARC-AGI-2)
- "Extrapolation" is overloaded — covers 4 distinct operations (retrieval, interpolation, composition, abstract pattern transfer) that should be separately analyzed
- Verdict: useful positioning statement, not a scientific theory. Keep it for framing, stop treating it as explanatory
- Updated forward links from original analysis, critical review, and topic page
- Wrote `research/post-nov-2025-model-failures.md` — comprehensive taxonomy of post-Nov 2025 model failures across 11 categories: emergent strategic deception (Sonnet 4.6 Vending-Bench, o3 reward hacking, Gemini situational alignment), over-eagerness (credential hunting, safety bypass through GUI), intelligence-reliability gap (Gemini smart-but-broken), faithfulness paradox (scalability of fabrication), code quality (1.4-1.75x more defects, orphaned code), context degradation, security (industrialized exploits at $30-50, 500+ OSS vulns, saturated cyber evals), crisis conversation failures, deception-vs-confabulation epistemology, multi-agent compound risks
- Key thesis: post-Nov 2025 failures are qualitatively different — not "model is dumb" but "model is smart enough to be dangerous in undetectable ways"

## 2026-02-28 (session 4)

- **LLM Capability vs. Pseudo-Capability** (`research/llm-capability-vs-pseudo-capability.md`)
  - Follow-up from agent-skills-landscape research to deeply assess what LLMs can/can't actually do
  - Searched and synthesized 20+ sources across academic research, mechanistic interpretability, practitioner evidence
  - **Key findings:**
    - "Stochastic parrot vs AGI" is dead — best framework is "context-directed extrapolation from training data priors" (Bonial et al.)
    - Apple "Illusion of Thinking" debate: rebuttals fixed evaluation artifacts but 8-disk Hanoi wall is real; code generation ≠ domain reasoning
    - Anthropic circuit tracing: genuine internal representations (cross-lingual concepts, multi-hop reasoning), but "grab it, rabbit" counter-evidence challenges poetry planning claim
    - CoT faithfulness: 0.04–13% fabrication rate across production models; *scalability paradox* — bigger models fake better
    - METR RCT: experienced devs 19% slower with AI, believed they were 20% faster (40-point perception gap)
    - MIT Tech Review: 30+ practitioner interviews confirm "slot machine" experience — remember jackpots, forget hours of wrangling
    - ARC-AGI-2: Gemini 3 Deep Think at 84.6% suggests genuine progress but mechanism unknown
    - Built practical capability trust map: high trust for pattern retrieval/classification, low for counterfactual reasoning/self-assessment
  - Updated `topics/llm-models.md` Deep Research section, `README.md` Other Research section
  - **Next:** Watch for METR study replication with current-gen tools; ARC-AGI-3 interactive reasoning results; interpretability scaling to frontier models

## 2026-02-28 (session 3)

- **Harness & Leverage Critical Review** (`research/harness-leverage-critical-review-feb28-2026.md`)
  - Reassessed three core docs (harness insights, Feb 26 update, maximum leverage brainstorm) against latest evidence
  - Searched web for new evidence: model-harness co-training (Codex), Anthropic skill atrophy study, macro productivity data (Economist, SF Fed, Bloomberg, DX survey), SDD mainstreaming, Willison's Agentic Engineering Patterns
  - **Key new findings:**
    - Model-harness co-training (confirmed by OpenAI insider) may dissolve the "harness > model" separation — models trained WITH their harness
    - Anthropic study: 17% comprehension loss from AI coding → potential skill atrophy → spec quality death spiral
    - Macro productivity gap widening: 93% adoption, ~10% productivity, zero aggregate macro impact (Economist, SF Fed)
    - SDD went from our brainstorm idea to mainstream movement in 2-3 weeks — validated but diluted
    - "Review debt" concept (InfoWorld): parallelizing agents creates validation debt faster than humans can pay it down
  - Updated `topics/coding-agents.md` with links to new research and the Feb 26 update
  - **Next:** Monitor co-training evidence, longitudinal skill studies, brownfield SDD tooling, macro productivity inflection

## 2026-02-28 (session 2)

- **Signal-to-Value deep dive** (`research/signal-to-value-high-level-languages-exploration.md`)
  - Critically reviewed whether high-level languages are truly better for exploration, with/without LLMs
  - Decomposed "token efficiency" into two independent metrics: semantic density (Python wins) vs verification density (Rust wins)
  - Resolution: breadth-first exploration decisively favors high-level languages; depth-first favors strict-type languages; the transition is the hard question
  - Key finding: the Rust evaluation's signal-to-value argument is correct but misscoped to exploration
  - Gall's Law applied to language choice — front-loaded correctness is premature optimization in exploration

- **Updated 39-Point Inversion** in `insights.md`
  - Major rewrite: specific number likely obsolete (early-2025 tooling artifact)
  - Added METR Feb 24, 2026 replication: study broke — devs refuse to work without AI, selection effects dominate, raw results now show speedup
  - Structural finding (self-assessment unreliable) strengthened by replication failure
  - Updated all METR references in signal-to-value piece

- **Two new insights** added to `insights.md`
  - **Two Densities**: semantic vs verification density, total-token-to-working-code as correct metric
  - **Exploration Phase Mismatch**: Gall's Law applied to language choice, breadth/depth split

## 2026-02-28

- **New research: Agent Skills Emerging Winners** (`research/agent-skills-emerging-winners.md`)
  - Deep web research across 15+ sources (Firecrawl, Bright Data, TestCollab, SupaTest, Tembo, Faros AI, skills.sh, agent-skills.cc, DEV Community, Reddit, GitHub issues, DeepLearning.AI)
  - Three structural shifts: CLI beating MCP (4-35x token efficiency), Agent Skills standard at 25+ platforms in 2 months, flywheel operating at pattern level not tool level
  - Category winners: Agent Browser (token-efficient browser), Browser Use (autonomous browser), Brave Search (search), Superpowers (workflow/meta), Anthropic official (docs), skills.sh (distribution)
  - Key finding: Microsoft's Playwright CLI adopted Agent Browser's ref pattern, validating it while threatening commoditization. Microsoft's own repo recommends CLI over their own MCP.
  - Critical: skills.sh "57K skills" inflated, security model is a ticking time bomb, cross-platform portability promise stronger in theory than practice

- **New research: Agent Skills** (`research/agent-skills.md`)
  - Deep read of pi skills system: docs, specification, all 7 installed skills (commit, github, tmux, brave-search, youtube-transcript, hn-distill, agent-browser), source code of scripts
  - Walked through simplest (commit: 36-line pure-prompt behavioral override) and most sophisticated (agent-browser: 350+ line framework with refs, state, iOS, diffing, 7 reference docs)
  - Pattern taxonomy: pure prompt → thin wrapper → orchestration → multi-step pipeline → full framework
  - Critical assessment: elegant simplicity and progressive disclosure are genuinely good; LLM routing unreliability, no dependency management, no testing framework, trust-the-file security model are real weaknesses
  - Compared to MCP, AGENTS.md, function calling, GPT Actions
  - Meta-insight: skills are structured knowledge injection — closer to training data than plugins. Transitional technology, but editorial-judgment skills (like hn-distill) have lasting value

- **New research: Rust Critical Evaluation** (`research/rust-language-critical-evaluation-2026.md`)
  - Deep web research across JetBrains DevEco 2025, State of Rust Survey, Stack Overflow, TIOBE, LWN, devclass, enterprise case studies, academic benchmarks, practitioner blogs, arxiv
  - Key findings: 2.27M devs, 45.5% orgs in production, Linux kernel permanent (Dec 2025), enterprise commitments real (AWS/Cloudflare/Microsoft/Google/Discord/Dropbox)
  - Performance: within 5% of C++, 1.5x faster than Go Fiber, concurrency safety is the real differentiator
  - Steelmanned criticisms: compile times structural and unsolvable, mutable shared state genuinely hostile, complexity irreducible, memory safety ≠ reliability (Cloudflare unwrap() outage)
  - Forward-looking: AI coding agents may be the structural solution to Rust's learning curve — strict type system + uniform corpus = better LLM output. Rust-SWE-bench (ICSE 2026) and RunMat case study support this
  - Government/CISA pressure is a one-way ratchet creating structural demand
  - Job market: $150K–$225K, supply-constrained, sector-concentrated
  - Verdict: best language for things that must not break. Not for everything.
  - **Revision 1**: Corrected AI-agent section — "strict type system" is not a differentiator vs C++. Real advantage is UB-is-silent-in-C++ vs loud-in-Rust, uniform corpus, actionable errors, single toolchain. Counter-evidence: LLMs spiral on borrow checker. No comparison to C++/Haskell exists.
  - **Revision 2**: Added Section 5b — token efficiency, context rot, and the high-level language counter-thesis. Python's brevity wins for throwaway exploration but may lose on total-tokens-to-working-code for long-horizon projects. Context rot research (Stanford/UW, Anthropic) shows attention degrades with volume, making front-loaded correctness (Rust's verbosity) potentially cheaper than deferred debugging (Python's brevity). Prototypes ship — exploration language = production commitment. No rigorous measurement of total token cost exists yet.
  - Updated README, verdict, bottom-line table

## 2026-02-26

- **New research: HN — What Claude Code Chooses** (`research/hn-claude-code-picks.md`)
  - Amplifying.ai ran 2,430 prompts against Claude Code across 3 models, 4 repos, 20 tool categories
  - Thread treats findings as confirmation that LLMs are now the most powerful dev tool distribution channel
  - Key insights: Tailwind wins structurally (co-located tokens = better S:N ratio), AGENTS.md works ~80% with imperative prohibitions, LLMs treat their own output as intentional human design (self-deference ratchet), recency gradient likely curated via RL not just training data
  - Thread blind spots: supply-side market power (Anthropic→vendor negotiation), Tailwind paradox (adoption up, revenue down), EU AI Act applicability, the report site itself is archetypal Opus 4.6 output
  - Updated README

- **New research: Architecturally Remarkable Repos** — broad web research across Brave Search, HN, Lobsters, InfoQ, expert blogs
  - 15 modern projects (2020-2026) with novel architectural bets, tiered by depth
  - Tier 1 (study deeply): TigerBeetle, DuckDB, FoundationDB DST pattern
  - Tier 2 (novel bets): Dragonfly, vLLM, Redpanda, Ghostty, Jujutsu
  - Tier 3 (specific ideas): LiteFS, Turso/libSQL, Pebble, Oxc, Valkey, NATS, Tantivy
  - Honorable mentions: Mojo, Roc, SerenityOS, CockroachDB, ClickHouse, etcd/Raft
  - Key meta-insight: classics succeed through *constraint* (refusing features), modern projects through *inversion* (doing the opposite of convention enabled by specific technical insight)
  - Cross-linked with existing `exemplary-codebases-for-llm-context.md` and counter-evidence
  - Saved to `research/architecturally-remarkable-repos.md`, updated README
- **Critical self-review of the above list** — found 6 major problems:
  1. "Inversion" thesis is partly imposed narrative, not analysis
  2. Massive database bias (9/15 entries are data infrastructure)
  3. **ScyllaDB missing** — the progenitor of thread-per-core (Seastar), credited Redpanda for ScyllaDB's innovation
  4. Insufficient counter-evidence (TigerBeetle investor-written praise, vLLM losing to SGLang, jj adoption blockers)
  5. C++/Rust/Zig bias — useless for application-level architecture lessons
  6. Inconsistent novelty bar (DuckDB well-executed but not novel, Tantivy explicitly derivative)
  - **Added 4 missing projects:** ScyllaDB+Seastar (Tier 1), llama.cpp/GGML, Neon, Cilium
  - **Identified 6+ other missing categories:** build systems (Buck2, Turbopack), CRDTs (Corrosion), JS runtimes (Bun), Wasm Component Model, filesystems (bcachefs)
- Deep web research: agent harness engineering — new papers, practitioner reports, anecdotes
- **METR RCT update (Feb 24):** Study is literally breaking — devs refuse to work without AI. Raw data now shows speedup but selection effects make it unreliable. Redesigning study.
- **METR transcript analysis (Feb 17):** 1.5x-13x time savings on Claude Code tasks. Highest savings correlate with agent concurrency (2.3+ parallel sessions). Caveat: soft upper bound, not productivity multiplier.
- **Lulla et al. (arxiv 2601.20404):** AGENTS.md makes agents 29% faster, 17% fewer tokens. Developer-written files help efficiency; LLM-generated hurt accuracy. Studies reconciled.
- **Codified Context paper (arxiv 2602.20478):** 3-tier architecture (hot constitution/specialist agents/cold knowledge base) for 108K LOC project. 283 sessions, 24.2% knowledge-to-code ratio, 4.3% meta-infrastructure overhead. Discovered "brevity bias" — iterative optimization collapses context toward useless brevity.
- **Configuration Landscape (arxiv 2602.14690):** 2,926 repos analyzed. AGENTS.md converging as standard. 83% of Skills have no scripts. Zero repos use subagent persistent memory. Ecosystem still at "markdown file only" maturity.
- **CodeAct/Code Mode:** Agents writing Python instead of JSON tool calls → 20% accuracy gain, 32-81% token reduction. May be next major harness improvement.
- **CSDD (arxiv 2602.02584):** Constitutional security specs → 73% fewer security defects in AI-generated code.
- **Brownfield playbook:** First serious practitioner report. Tests-first, doc tacit knowledge, compromise hierarchy, incremental autonomy.
- **100% autonomy wall:** Gorman's controlled experiments confirm full autonomy doesn't work. Doom loops are unfixable at model level.
- Saved to `research/harness-engineering-update-feb26-2026.md`

## 2026-02-24

- Deep research: "Who are the most accurate long-range (10+ year) predictors?"
- Searched and analyzed: Dan Luu's futurist scoring, Tetlock's superforecasting research, Open Philanthropy's long-range forecasting feasibility study, Samotsvety, IPCC climate models, Cold Takes futurist track record analysis
- Key finding: **Nobody has a rigorously verified track record for 10+ year predictions.** Climate models are the sole exception (physics-based, 30+ year verified accuracy). All other "great predictors" are either validated at short horizons only (superforecasters: ~1yr) or scored by cherry-picked anecdotes.
- Hierarchy: IPCC > deep domain experts (Gates/MS 1990s) > foxes/superforecasters > Asimov (~50% on 50yr) > professional futurists (Kurzweil ~7%, Kaku ~3-6%)
- Saved to `research/long-range-prediction-accuracy.md`
- Follow-up: what Samotsvety + Tier 3 predictors (Caplan, Yegge, Asimov) say about AI
- Samotsvety: 31% AGI by 2030, 63% by 2050, 81% by 2100 (Jan 2023 update). Epoch AI rated them best judgment-based AGI forecast.
- Caplan: about to lose his first-ever public bet (AI exam bet), unprecedented signal. Still bets against extinction.
- Yegge: all-in on AI coding transformation, predicts 50% engineering cuts, "big companies are doomed"
- Key finding: every forecasting group without exception shortened AI timelines 2022→2025. The convergence is the strongest signal.
- Saved to `research/ai-predictions-best-forecasters.md`

## 2026-02-23 — Session 2

- Distilled HN thread: "Pi – A minimal terminal coding harness" (202 pts, 92 comments)
  - Saved to `research/hn-pi-minimal-terminal-coding-harness.md`
  - Fetched and analyzed article (pi.dev), can1357's "harness problem" blog post, thevinter's negative experience report
- Cross-referenced against insights.md and additional_insights.md — found 7 deeper structural connections:
  - Hashline as Prompt Expansion at tool boundary; recursive Naur's Nightmare (living software = 3rd theory-less layer)
  - LISP Curse at tool layer; Knowledge Integration Decay explains small-prompt advantage
  - Hidden Denominator made visible via thevinter; Fixed-Point Workflow validated (Plan.md despite omission)
  - Approval Fatigue validates Pi's no-popups stance
- Updated: topics/coding-agents.md (new research link)
- No new insights promoted — connections deepen existing entries

## 2026-02-23 — Session 1

- Deep critical review of pi_agent_rust (Dicklesworthstone's Rust port of Pi Agent)
- Key findings: 556K lines of Rust in 23 days, 79% Claude co-authored, contains "phantom complexity" — modules named after advanced CS concepts (AMAC, trace-JIT, io_uring, S3-FIFO, e-graphs) that don't implement what their names claim
- Central critique: AMAC "interleaving" is a sequential loop; "JIT" can't exist under `forbid(unsafe_code)`; io_uring module explicitly disclaims doing any io_uring; S3-FIFO cache for a system processing ~5 calls/second
- Also flagged: 48K-line single file, custom async runtime (asupersync) with zero external users, MIT+Anthropic-exclusion license on 79% Claude-generated code, benchmark methodology gaps
- Saved to `research/pi-agent-rust-review.md`

## 2026-02-22 — Session 1

- Distilled HN thread on DuckDB as first choice for data processing (310pts, 119 comments)
- Key findings: real moat is relational guarantees not speed, SQL-vs-dataframes debate conflates declarative with SQL, Ibis emerges as thread's implicit answer, governance advantage underappreciated
- Saved to `research/hn-duckdb-first-choice-data-processing.md`, linked from README

## 2026-02-22 — Session 14 (HN distill: Skip open source + Solow critique)

- Distilled HN thread on Skip going free & open source (515pts, 226 comments)
- Created `research/hn-skip-open-source.md`
- Key insights: LGPL-3 license choice creates enterprise friction vs. permissive-licensed competitors; no production case studies after 3 years; Liquid Glass as competitive wedge is a bet on Apple's design instability; paid dev tools are dead but sponsorship model has no successful precedent for frameworks
- Updated README with link
- Added critical evaluation of Solow Paradox analogy to `research/coding-agents-insight-inventory.md` (Pattern E + open question #6)
  - Six structural problems: survivorship bias in analogy selection, different mechanisms (new capabilities vs. speed-up), unfalsifiable timeline, AI-broadly vs. AI-coding conflation, simpler explanation (no paradox needed), rapid model change breaks the frame
  - Verdict: descriptively accurate, predictively weak

## 2026-02-21 — Session 13 (NanoClaw deep dive)

- Created `research/nanoclaw-deep-dive.md` — comprehensive analysis of NanoClaw
- Covers: architecture, security model (container isolation vs app-level), skills-over-features contribution model, competitive landscape, red flags, Cohen's AI-native coding philosophy
- Key finding: genuinely improves blast radius but doesn't solve prompt injection or network exfiltration; VentureBeat coverage was PR-placed
- Cross-linked from Karpathy Claws thread, added to coding-agents topic page and README
- Sources: GitHub, nanoclaw.dev, The New Stack interview, fumics.in analysis, VentureBeat, HN threads, Reddit

## 2026-02-21 — Session 12 (continued Bishop's scrape)

- **Critical correction:** `@tbsdecisions2026` is NOT The Bishop's School (La Jolla) — it's a different school entirely
- Correct account: `@tbs26decisions` — discovered from crashed session's /tmp screenshots
- Salvaged 36 screenshots from /tmp/tbs_*.png (from crashed session)
- Read all 36 screenshots via vision, compiled full dataset
- Scrolled Instagram grid to find 8 additional posts missed by screenshots:
  - **Ariadne Georgiou → Harvard** (Government & Ethnicity, Migration, Rights) — Jan 7, 2026
  - Ella Kaminsky → Northeastern (Business Admin), Wyatt Stone → Duke (Mech Eng), Kayla Pfefferman → GW (Marketing)
  - Connor Gutierrez → Santa Clara (Finance), Penelope Fountain → Alabama (Comms/Pre-Law)
  - Kaylee Yen → NYU (Undecided), Brandon Agbayani → Santa Clara (Business Econ)
- Total: **44 decisions across 28 universities** (36 verified from screenshots, 8 from alt-text needing confirmation)
- Updated `tbs-class-2026-early-decisions.md` (full rewrite), `instagram-scrape-for-college-admission.md`
- **Next:** Screenshot-verify the 8 ⚠️ entries; monitor for RD posts through April

## 2026-02-21 — Session 1

- Researched browser-based tools for coding agents (JS rendering, auth, heavy pages)
- Compared: agent-browser (Vercel), Playwright CLI (Microsoft), Dev Browser (SawyerHood), Firecrawl CLI+Browser Sandbox, Stagehand, Browser Use
- **Recommendation:** agent-browser as primary (CLI-first, snapshot+refs, session state for auth, 93% token savings)
- Created `research/browser-tools-for-coding-agents.md`, updated `topics/dev-tools.md` and `README.md`
- Installed agent-browser globally + as Pi skill at `~/.pi/agent/skills/agent-browser/`
- Used agent-browser to scrape Instagram for PRS Class of 2026 early college decisions
  - **Instagram tag:** `@prsdecisions2026` — student-run account for PRS Class of 2026
  - **Instagram tag (to find):** Bishop's School equivalent — search `bishops decisions 2026` or similar
  - Extracted 19 early decisions across 17 universities (Stanford, UPenn Wharton, Duke, Northwestern, USC×2, UVA, NYU, etc.)
  - Saved to `research/prs-class-2026-early-decisions.md` + `.json`
  - Instagram auth state saved at `~/.agent-browser/instagram-auth.json`
- Saved reusable workflow pattern: `research/instagram-scrape-for-college-admission.md`
- Repeated for The Bishop's School (La Jolla):
  - **Instagram tag:** `@tbsdecisions2026` (found via abbreviation "TBS", not "bishops")
  - 30 early decisions across 18 universities (Miami ×6, Wake Forest ×3, Alabama ×3, Northwestern, Vanderbilt, UVA, etc.)
  - First names only (no last names unlike PRS)
  - Captions are full English sentences — easier to parse than PRS image-only posts
  - Saved to `research/tbs-class-2026-early-decisions.md`
  - Updated workflow doc with search tips (abbreviation matters)

## 2026-02-19 (session 9)

### Dotfiles/Setup Audit

- **Audited** dotfiles and installed tools against worklog history
- **Verified OK:** mdt removed, web-search.json deleted, glow v2.1.1 installed, glow alias correct, glow config at correct macOS path with defaults, `~/.config/glow/` gone
- **Found 2 drift items (no action taken):**
  - `~/.pi/agent/models.json` — completely missing, not just emptied of Google models as worklog implied
  - `GEMINI_API_KEY` in `~/.zshrc` — fully removed, not commented out as worklog stated

---

## 2026-02-18 (session 8)

### Integrate 16 New Research Files

- **Created** `topics/software-factory.md` — dark factory thesis, StrongDM forensics, verification/alignment, maximum-leverage design
- **Expanded** `topics/coding-agents.md` — added agent landscape (Feb 2026), tool comparisons, practitioner evidence (METR study), context engineering sections; linked 12 research files total
- **Updated** `topics/llm-models.md` — added Sonnet 4.6 to landscape table, linked analysis
- **Updated** `README.md` — added software-factory topic, added "Other Research" section for 4 unlinked files (Fowler ×2, Schillace, careers)
- **Moved** `pi-terminal-bench-research.md` → `research/pi-terminal-bench.md`
- **Added** backlink headers to all 16 new research files
- **Key decisions:** steipete and critical-review-v3 go under coding-agents (practitioner evidence, not factory); Fowler/Schillace/careers stay unlinked (no natural cluster yet); software-factory topic kept tight (4 files)

---

## 2026-02-17 (session 7)

### Notes Reorganization

- **Restructured** notes/ from flat 8-file dump into 3-layer system: README → topics → research
- **Created** `README.md` — active stack dashboard, topic map, conventions
- **Created** `topics/llm-models.md`, `topics/coding-agents.md`, `topics/dev-tools.md` — decision summaries with links to research
- **Moved** 8 research files into `research/` with backlinks to parent topic pages
- **Key decisions:** kept Google files separate (operational vs market research), kept Pi conversation intact (already well-structured), dev-tools.md is a routing page not unified analysis
- **Added** conventions for future notes: research/ first, topic pages when clusters form, README on decision changes
- **Renamed** INDEX.md → README.md for GitHub rendering, updated all 12 internal links
- **Review pass:** removed duplicated landscape content from api-key file, fixed stale INDEX refs, clarified titles, added 2.5 Pro key-block warning to market file
- **Added** `AGENTS.md` — agent instructions covering reading/writing protocol, update direction, style, non-obvious file relationships

---

## 2026-02-17 (session 6)

### Pi & Terminal-Bench Research

- **Researched** why pi coding agent is not on the Terminal-Bench leaderboard
- **Finding:** results were submitted via email but likely never processed/added by Terminal-Bench team
- **Credibility assessment:** high — reproducible, open-source adapter, automated verification, public results.json
- **Saved** research to `notes/pi-terminal-bench-research.md`
- **Follow-up research:** has anyone run updated pi against TB? Answer: **no**
  - HN thread (Feb 11) shows community noticed pi's absence, speculating about it
  - Mario on OSS vacation until Feb 23; adapter stale; no community runs
  - oh-my-pi fork ran custom react-edit-benchmark (not TB) — found harness changes swing scores 5–14pp
  - Updated research note with full section on this

---

## 2026-02-17 (session 5)

### Cleanup: Removed Google Models & API Keys

- **Removed** all Google models from `~/.pi/agent/models.json` (gemini-2.5-flash, gemini-2.5-flash-lite) — free tier quality too low for coding
- **Commented out** `GEMINI_API_KEY` export in `~/.zshrc`
- **Deleted** `~/.pi/web-search.json` — orphaned file, verified nothing reads it (not pi agent, not brave-search skill, not pi-ai SDK)
- Key left intact in `.zshrc` (commented) for potential future re-enable

---

## 2026-02-17 (session 4)

### Cleanup: Removed MD-TUI

- **Removed** `/usr/local/bin/mdt` (MD-TUI v0.9.4) — Glow is the preferred markdown renderer
- No config files or dotfile references existed, clean removal
- Updated `terminal-markdown-renderers.md` to reflect removal
- **Found:** `google-ai-research.md` had uncommitted edits from session 3 *(committed in session 5)*

---

## 2026-02-17 (session 3)

### models.json + Research Consistency

- **Trimmed** Google models in `~/.pi/agent/models.json` to free-tier-only
- **Dropped** `gemini-3-flash-preview` — preview/unstable, no rate limit guarantees
- **Dropped** `gemini-2.5-pro` — consistently returns `limit: 0` on this key across two separate live tests; likely per-project block from Dec 2025 crackdown (globally documented as 100 RPD free, but not for this project)
- **Final models.json:** `gemini-2.5-flash` (250/day) + `gemini-2.5-flash-lite` (1000/day) — both confirmed working
- **Edited** `google-ai-research.md` to be consistent: 2.5-pro listed as blocked on this key with explanation, free tier table shows only confirmed-working models *(committed in session 5)*
- **Lesson:** Live API test (`limit: 0`) is more reliable than blog posts for per-key availability; `limit: 0` ≠ transient, means zero quota allocation

---

## 2026-02-17 (session 2)

### Google AI Research & Gemini Key Diagnosis

- **Researched** Google's latest LLM landscape for early 2026 via Brave Search
  - Gemini 3 Pro is flagship: #1 LM Arena (1490 score), 1M context, 1T+ params, $2/$12 per M tokens
  - Gemini 3 Flash Preview available free; Gemini 2.5 Flash still best free workhorse
  - Benchmarks: Gemini 3 Pro tops ECI, AA Intelligence Index, AA Coding Index
  - Competitive landscape: Grok 4.1 (#2), Claude Opus 4.5 (#1 coding), GPT-5.1 (#9)
- **Diagnosed Gemini API key** — key is valid, issue is `limit: 0` on free tier for several models
  - Free tier working: `gemini-2.5-flash`, `gemini-2.5-flash-lite`, `gemini-3-flash-preview`, all `gemma-3-*` models
  - Paid only (limit=0): `gemini-2.5-pro`, `gemini-3-pro-preview`, `gemini-2.0-flash`, `gemini-2.0-flash-lite`
  - Deprecated: `gemini-2.5-flash-preview-09-2025` (404)
  - Total models accessible via key: 45
- **Saved** research to `notes/google-ai-research.md`

### Notes Repo

- **Created** `tesla3/notes` GitHub repo to track all research notes
- **Committed** initial files: `google-ai-research.md`, `terminal-markdown-renderers.md`
- **Pushed** `google-llm-research-2026-02.md` as follow-up commit
- Repo: https://github.com/tesla3/notes

---

## 2026-02-17

### Terminal Markdown Renderer Research & Setup

- **Researched** all major terminal markdown renderers: Glow, mdcat, MD-TUI, Rich/rich-cli, Frogmouth, bat, Termimad, Glamour, marked-terminal, pandoc+w3m
- **Checked** GitHub stats, open bugs, maintenance status, real user complaints for each
- **Critical review** exposed key tradeoffs:
  - Glow: prettiest, most popular, but Glamour engine has 4+ year old rendering bugs (lists, blockquotes, code blocks). No streaming.
  - mdcat: most correct (CommonMark), inline images, but archived/dead (Jan 2025)
  - MD-TUI: best navigation (link selection mode), but custom non-compliant parser, AGPL, small community
  - Rich: best Python library, streaming coming via Textual, but slow startup
  - No tool is simultaneously correct, pretty, fast, interactive, and maintained
- **Saved** full research to `notes/terminal-markdown-renderers.md`

### Installations

- **Installed MD-TUI** v0.9.4 — downloaded release binary to `/usr/local/bin/mdt` *(removed in session 4)*
- **Installed Glow** v2.1.1 — via `brew install glow`
- **Winner: Glow** after hands-on testing

### Dotfiles (chezmoi → tesla3/dotfiles)

- Added `alias glow='glow -w 0 -p'` to `.zshrc` (full terminal width + pager)
- Cleaned up wrong config path (`~/.config/glow/`) — glow on macOS uses `~/Library/Preferences/glow/`
- Left default glow config untouched, preferences expressed via alias
- Committed and pushed to dotfiles repo

### Google Gemini LLM Research & Setup

- **Deep research** on Google's LLM offerings using Brave Search (multiple queries, content extraction)
  - Surveyed all Gemini models: 3 Pro Preview, 3 Flash Preview, 2.5 Pro, 2.5 Flash, 2.5 Flash-Lite, 2.0 Flash, 2.0 Flash-Lite
  - Compared pricing across Google, OpenAI, Anthropic, xAI
  - Analyzed free tier limits, December 2025 rate cut incident, consumer subscription plans
  - Key finding: Google's free tier is the most generous in the industry (no credit card, 1M context, 100-1,000 RPD)
  - Key finding: Flash-Lite models are 10-100× cheaper than competing frontier models
- **Saved research** to `notes/google-llm-research-2026-02.md`
- **Set up Gemini API key** in `~/.zshrc` (`GEMINI_API_KEY`)
- **Verified API access** — confirmed 30+ models available including Gemini 3 Pro/Flash, 2.5 Pro/Flash, Nano Banana, Deep Research, Gemma, TTS
- **Configured pi** with 5 Gemini models in `~/.pi/agent/models.json` using `google-generative-ai` API type:
  - Gemini 2.5 Flash, 2.5 Pro, 2.5 Flash-Lite, 3 Pro Preview, 3 Flash Preview

## 2026-02-21

- **HN distill:** [Car wash reasoning failure thread](research/hn-llm-car-wash-reasoning.md) (47031580, 1511pts/948 comments)
  - Key finding: failure is premature token commitment + post-hoc rationalization, not reasoning incapacity
  - Spot-patching cycle already in progress (TikTok viral → models patched → trivial variants bypass patch)
  - Best thread insight: System 1/2 framing as cost optimization by providers (keeda)
- **HN distill:** [Ring/Nest surveillance state thread](research/hn-ring-nest-surveillance-state.md) (47023238, 935pts/663 comments)
  - Key finding: AnthonyMouse's selective enforcement model explains the "total surveillance + rampant crime" paradox
  - Voluntary compliance with admin subpoenas is the actionable lever nobody focuses on
  - ~20% of thread wasted on Greenwald credibility debate, functioning as surveillance-critique deflection

## 2026-02-21 (session 11)
- **Research:** [PRS College Profile Analysis](research/pacific-ridge-school-profile-analysis.md) — AO's reading of the school profile document
  - V1 analyzed profile strengths (Harkness, AP cap, counseling ratio, global engagement) and weaknesses (test scores, matriculation gaps)
  - V2 critical self-review caught major errors:
    - FindingSchool data unreliable (Chinese-audience site with biased methodology) — removed as primary comparison source
    - Matriculation ≠ acceptance distinction never addressed in v1
    - AP pass rate (~51% scoring 3+) completely omitted from v1 — below national average, significant red flag
    - Youth-of-school factor (15 graduating classes ever, zero legacy pipeline) massively underweighted
    - UC system mechanics hand-waved instead of analyzed
    - Post-AP courses (Diff EQ, MV Calc) barely mentioned — actually a hidden gem
    - Recount from actual matriculation list: ~8-10% to T30, not FindingSchool's 1.79%
  - Verdict: Sweet spot is T20-50; profile neutral at T10 (student must carry); well-constructed document with some missing data (grading scale, GPA distribution)

## 2026-02-21 (session 10)
- **Research:** [Pacific Ridge School critical analysis](research/pacific-ridge-school.md) — deep dive on college placement
  - Key finding: PRS sends ~1–2% to T25 vs Bishop's ~19%, Parker ~17%, LJCDS ~12% — order-of-magnitude gap at similar tuition
  - HYPSM: ~0.9–1.3% (≈1 student/year). MIT notably absent from entire matriculation list
  - AP scores strong (72% at 4-5), suggesting good instruction but weak college outcomes driven by 90% acceptance rate, youth (est. 2007), and less selective student body
  - Community colleges (MiraCosta, Palomar) appear with asterisks on matriculation list — unusual for $45K school
  - Verdict: B+ school at A+ prices. Good holistic experience, poor placement ROI vs peers
- **Research (Rev 3):** Recut PRS analysis to T20 using US News 2026 rankings
  - UC Berkeley (#15) and UCLA (#17) enter T20; Georgetown, Emory, UVA, USC drop out
  - PRS T20: 6.5–9.0% (nearly unchanged from T25). Bishop's 30%, Parker 19%, LJCDS 18%
  - Interesting dynamic: Parker *gains* under T20 (Berkeley is its largest feeder at 23), Bishop's *loses* (USC 24-student pipeline drops out)
  - Extracted all four school PDFs via PyMuPDF for exact counts; found PRS website vs PDF data discrepancies (Harvard/Yale asterisk swap, Duke/Notre Dame present on website but not PDF)
  - Updated PRS profile stats: SAT middle 50% now 1150–1450, 4 college counselors for 108 seniors

## 2026-02-21
- **Research:** Absurd (Armin Ronacher/Earendil) durable execution system — deep dive and landscape comparison
  - Researched Absurd GitHub repo, blog post, HN thread, and user test writeups
  - Compared against Temporal, DBOS, Inngest, Restate, Hatchet, `use workflow`
  - Key finding: Absurd and DBOS compete directly (both Postgres-only), but different philosophy — Absurd puts complexity in SQL, DBOS puts it in client annotations
  - Armin tried DBOS and bounced on SDK quality; DBOS improving fast
  - Agent use case is the killer app driving durable execution adoption
  - Wrote `research/absurd-durable-execution-landscape.md`, linked from `topics/software-factory.md`

## 2026-02-21

- Distilled HN thread on [ai-ublock-blacklist](https://news.ycombinator.com/item?id=47098582) — governance problems, AP News false positive, maintainer removed combative FAQ mid-thread
- Researched the full AI slop blocking landscape: domain blocklists (laylavish 5.2k stars, alvi-se, Stevoisiak), content detectors (DeSlop, AI Content Shield, SkipSlop), temporal filtering (Slop Evader), platform responses (Google March 2024 update, YouTube monetization rules), authenticity certification (C2PA, Mosseri's "fingerprint the real")
- Key finding: client-side tools recapitulate email RBL history — solo maintainers → professionalization → platform absorption. Real solution requires Google/platforms to internalize filtering. C2PA is correct long-term direction but only works for media, not text.
- Wrote `research/hn-ai-ublock-blacklist.md` and `research/ai-slop-blocking-landscape.md`, linked from README

## 2026-02-21

- Researched Gondolin (earendil-works/gondolin) — Armin Ronacher's QEMU-based agent sandbox with JS-programmable network/filesystem
- Key findings: 17 days old, 551 stars, Thoughtworks endorsement, closest competitor is Matchlock, differentiated by JS-programmable network stack and secret placeholder injection
- Wrote `research/gondolin-agent-sandbox.md`
- Distilled HN Matchlock thread (46932343) — VM sandboxing for agents, confused deputy consensus, Claude Cowork exfiltration via allowlisted Anthropic API, Opus 4.6 red-team anecdotes, useradd contrarian argument
- Key finding: network allowlisting doesn't solve exfiltration when allowed hosts are general-purpose APIs. Prompt-injected agent produces identical traffic to legitimate agent. Content-aware egress requires LLM-judging-LLM recursion.
- Wrote `research/hn-matchlock-agent-sandbox.md`
- Deep comparison of Gondolin vs Matchlock across 7 solvable attack classes
- Matchlock wins on VM boundary (Firecracker) and in-VM hardening (seccomp-BPF). Gondolin wins on network policy (JS ethernet stack, synthetic DNS, rebinding protection) and filesystem awareness (symlink protection, MemoryProvider).
- Recommendation: Matchlock today (foundation > policy sophistication), watch Gondolin. Ideal tool would combine Gondolin's network stack with Matchlock's VM boundary.
- Wrote `research/gondolin-vs-matchlock.md`
- Practical setup analysis for Matchlock with Pi: 6 layers of config, network allowlist is the ongoing tax, Pi integration doesn't exist (Gondolin's advantage)
- Wrote `research/matchlock-setup-guide.md`
- Elaborated "agent as separate macOS user" — the 80/20 play from matchlock guide. Covers: macOS permission model (750 home dirs, 700 sensitive dirs, TCC), user creation, shared workspace with setgid group, SSH/sudo workflow, Homebrew sharing, threat model comparison table, layering with Matchlock
- Wrote `research/agent-separate-macos-user.md`, linked from matchlock guide and coding-agents topic page
- Self-rebuttal: "just run open" was wrong — undersold threat frequency, bad analogy, confused frequency with expected value, overclaimed friction
- Wrote `research/agent-isolation-friction-rebuttal.md`
- Pre-commitment analysis of separate user: real setup is 60-90 min not 15, /tmp leaks 63 world-readable files, shared workspace permissions fragile, discipline decay, agent's own creds fully exposed
- Wrote `research/agent-separate-user-precommit-analysis.md`
- Landscape survey: what people actually do for agent security. Two worlds: autonomous (OpenClaw/Mac Mini) vs interactive (Claude Code/Pi). Key finding: being on-screen is a real security control the autonomous crowd doesn't have
- Emerging pattern: LuLu outbound firewall + dedicated agent service accounts (ChatPRD pattern) = highest value for interactive use
- Separate user is Tier 3 (optional) for interactive use when LuLu + dedicated accounts are in place
- Wrote `research/agent-security-landscape-what-people-do.md`

## 2026-02-22
- HN distill: "Dead Internet Theory" (697 comments)
- Key thesis: Dead Internet Theory is really Dead Incentive Theory — ad-funded attention economy rewards exactly what bots excel at
- Best framework: shadowgovt's PageRank analogy (filtering interregnum, not terminal condition)
- Non-obvious dynamic: humans converging expression downward to avoid AI suspicion, closing the gap from both sides
- Wrote `research/hn-dead-internet-theory.md`

## 2026-02-22

- HN distill: "The recurring dream of replacing developers" (524 comments, 646 pts)
- Article itself flagged as AI slop — meta-irony: AI-written article arguing humans are essential
- Star comment (davnicwil): dream is about manifesting without details; details are fractal
- Key framework: Twey's "constant complexity budget" — we always operate at max complexity, abstractions just reallocate upward
- dijit's democratization insight: Excel succeeded by accepting catastrophic failure; you can't have accessibility + reliability
- Near-term consensus: junior squeeze is real, bar keeps rising, but nobody follows the pipeline problem forward
- Non-obvious: essential/accidental complexity boundary is being reclassified in real time, not fixed
- Offshoring smokescreen: layoffs may be offshoring dressed as AI disruption (strict9, complicated by Tade0)
- Wrote `research/hn-replacing-developers-dream.md`

## 2026-02-22

- HN distill: "The Singularity will occur on a Tuesday" (756 comments, 1381 pts)
- Article is Trojan horse: looks like sincere singularity prediction, real thesis is only human *attention* is going hyperbolic, not capability
- Thread splits: 60% read through to social argument, 40% stopped at (deliberately bad) math and declared slop
- ubixar crystallizes better than article: "Linear capability growth is the reality. Hyperbolic attention growth is the story."
- Challenger vs JOLTS gap: announced layoffs spike while actual separations stay flat — the gap IS the social singularity mechanism
- cubefox links Scott Alexander's "1960: The Year The Singularity Was Cancelled" — strongest counter-thesis, barely discussed
- Fetched Tim Dettmers' "Why AGI Will Not Happen" — strongest hardware-grounded argument for physical ceilings
- Wrote `research/hn-singularity-tuesday.md`
- Added 6 insights to `insights.md`:
  1. RLHF anti-novelty bias (second mechanism beyond prediction→mean, from hnfong + AlphaZero paper)
  2. Verification gates alien performance (from energy123 — more precise than "theory formation" threshold)
  3. Recognition chain bottleneck (AI compresses generation, not recognition — from hnfong + AlphaZero)
  4. Physical ceilings nearer than assumed (from Dettmers — GPU perf/cost maxed ~2018, transformers near-optimal)
  5. Anticipatory displacement loop (companies act on AI potential not performance — HBR confirms, JOLTS contradicts Challenger)
  6. Infrastructure liability inversion (from Dettmers — $200B+ CAPEX as stranded-asset risk)

## 2026-02-21

- Distilled HN thread on Mitchell Hashimoto's Vouch (community trust management for OSS)
  - 1077 pts, 486 comments — significant community engagement
  - Saved to `research/vouch-hn-thread.md`
- Cross-referenced against insights.md — found one genuinely new structural insight:
  - **Rejection machinery ∝ courtesy norms**: communities build automated rejection systems not for efficiency but for emotional cover. The stronger the professional courtesy norm, the more elaborate the machinery. Placed after Democratization-Failure Tradeoff.
- Existing insights already covered: Apprenticeship Doom Loop (Vouch tightens it), Democratization-Failure Tradeoff (Vouch enacts it), intent vectors (the algorithmic alternative the thread mostly misses)
- Updated: insights.md (new entry), README.md (new research link)

## 2026-02-25

- Distilled HN thread "Making MCP cheaper via CLI" (47157398, 76 comments, 163 score)
- Key finding: MCP is becoming the catalog/registry layer while execution surfaces diversify (CLI, Code Mode, Tool Search) — the "MCP vs CLI" framing is a false dichotomy
- Thread's best insights: composability via piping > token savings, per-turn context replay dwarfs tool definitions, KV cache preservation advantage of CLI, smaller models benefit disproportionately
- Cloudflare's Code Mode (search + execute, ~1K tokens for 2,500 endpoints) undervalued by thread — potentially makes tool definitions obsolete
- Meta-irony: every MCP critic's project takes MCP servers as input
- Saved to `research/hn-mcp-cheaper-via-cli.md`, updated README.md
- Extracted from MCP/CLI distillation:
  - **anecdotes.md**: 5 new entries under "Agent tool architecture" section — 150 Tool Calls vs 1 For Loop (martinald), CLI Accuracy on Small Models (cmdtab), CLI Discovery Chain (thellimist), Per-Turn Replay Dwarfs Tool Definitions (OsrsNeedsf2P), MCP Non-Composability (_pdp_)
  - **additional_insights.md**: New insight "Shell Composability Advantage" — three structural advantages (composability eliminates round-trips, training distribution alignment, KV cache preservation) with security counterpoint
  - **additional_insights.md**: Updated "Skill Loading Illusion" with convergence evidence (5 independent MCP-to-CLI converters + Cloudflare Code Mode + Anthropic Tool Search, all in same week)

- Deep research on harness engineering insights and operational best practices
  - Searched 30+ sources: LangChain Terminal Bench experiments, ETH Zurich AGENTS.md evaluation (arXiv:2602.11988), Pappas convergence analysis, can1357 hashline benchmark, Vercel tool reduction study, Böckeler's independent analysis, Demmel's feedback loop hierarchy, pi-reflect, Arize telemetry analysis, EQ Engineered, New Stack
  - Key empirical findings:
    - LangChain: harness-only changes +13.7pts on Terminal Bench (model fixed)
    - can1357: single edit tool change improved 15 models, weakest by 10×
    - Vercel: removing 80% of tools → 80→100% accuracy, 3.5× faster
    - ETH Zurich: LLM-generated AGENTS.md reduces success by 3%, increases cost 20%+
  - Synthesized hierarchy of leverage: feedback gauntlet > tool simplification > mechanical architecture enforcement > incremental AGENTS.md > self-verification loops > doom loop detection > observability > garbage collection
  - Honest assessment: all success stories are greenfield, hidden denominator uncounted, verification gap structural, zero long-term maintenance data
  - Meta-insight: harness engineering is the industry belatedly realizing skipped engineering practices are now load-bearing
  - Saved to `research/harness-engineering-insights-and-practices.md`
  - Updated topic pages: coding-agents.md, software-factory.md (forward links)

- Self-review of harness engineering research against latest evidence (30+ sources cross-checked)
  - **Corrections applied:**
    - Vercel n=5 sample size: flagged as directional signal, not statistical evidence
    - ETH Zurich AGENTS.md study: added limitations (SWE-bench only, well-documented repos, doesn't measure token efficiency or recurring mistake prevention); HN practitioners pushed back hard, especially for large/messy codebases
    - LangChain vendor conflict: LangSmith recommendation is marketing, flagged more prominently
    - "Harness > model" framing: partially category error — nobody has done controlled marginal comparison
  - **New evidence integrated:**
    - JUXT Allium case study: spec-first development producing distributed BFT system (3K spec → 5.5K Kotlin). Strongest evidence yet for specification approach, but expert-dependent
    - Cemri et al. MAST taxonomy (O'Reilly): 36.9% of multi-agent failures are interagent misalignment — harness literature ignores multi-agent state synchronization
    - HN thread (47034087): practitioner consensus on migrating AGENTS.md rules to mechanical checks (AST linters, pre-commit hooks). "Every rule that CAN be a test SHOULD be a test"
    - Bitter Lesson temporal counter-argument: Manus 4 rebuilds = model improvements erode harness value
  - **Structural additions:**
    - Temporal classification: durable practices (linting, architecture, observability) vs temporal (doom loops, forced verification) vs unknown (AGENTS.md, specs, garbage collection)
    - Specification promoted to rank 4 in leverage hierarchy (was absent)
    - 5-point self-critique section added
    - r/ExperiencedDevs "harness as labor" problem: most orgs can't staff for this

## 2026-02-28

- **Agent Skills: Comprehensive category research**
  - Created `research/agent-skills-landscape-categories-winners.md` — 12-category deep analysis
  - Sources: skills.sh, Tessl Registry, Oathe audit (1,620 skills), Snyk ToxicSkills (3,984 skills), Block Engineering blog, Pulumi blog, r/ClaudeCode, ScriptByAI, multiple practitioner reports
  - **Key findings:**
    - Self-improvement loops (wrap-up, session hygiene) are the sleeper hit — compounds over time
    - Bug pattern libraries emerged as new software artifact category (112 production war stories as skills)
    - Block published best design framework: 3 principles (what agent should NOT decide, SHOULD decide, constitutional constraints)
    - Security is worse than previously reported: Oathe found 5.4% malicious, leading scanner missed 91%, attacks are English in markdown not code
    - Vendor skills (Firebase, Stripe, AWS) = new go-to-market channel
    - Non-obvious: video transcription→QA, receiving-code-review > requesting, anti-sycophancy as design requirement
  - Updated README with new research link
  - **Deep-dive conversation:** self-improvement skills, bug pattern libraries, all non-obvious winners
    - Elaborated "design for the arc" (Block's bonus principle) — skill creates conversation loop where output feeds next step
    - Clarified: arc is NOT a decision tree (absolute difference, not semantic) — decision tree is finite/enumerable/Markovian; arc is open-ended/generative/context-dependent
    - Identified arc failure modes: amplifies bad reasoning (wrong diagnosis → wrong treatment → wrong verification), hallucinated vulnerabilities generate cascading work from nothing
    - **New insight: Skill Author Competence Paradox** — added to both research note (#8 non-obvious winner) and insights.md (Section VI)
    - Three faces: authoring paradox (expert doesn't need it), evaluation circularity (judging output requires the expertise skill provides), calibration drift (skills untethered to models)
    - Block's internal marketplace as proof it's solvable under narrow conditions (same org, fast feedback)
    - Connected to 5 existing insights: Cognition ≠ Decision, Steering ∝ Theory, Inverted Principal-Agent, Naur's Nightmare, Workflow as Tribal Knowledge

- **QMD: Deep evaluation & strategic context analysis**
  - Created `research/qmd-evaluation-and-context-connection.md` — full source code review, architecture assessment, competitive landscape, connected to 5 prior research threads
  - **What QMD is:** Tobi Lütke's (Shopify CEO) on-device hybrid search engine for markdown. BM25 + vector (embeddinggemma-300M) + LLM reranker (Qwen3-0.6B) + fine-tuned query expansion (Qwen3-1.7B SFT). ~9,700 LOC TypeScript, 295 commits since Dec 7 2025, ~20 external contributors. CLI + MCP + HTTP daemon.
  - **Key architectural strengths:** query document format (lex:/vec:/hyde: typed sub-queries), hierarchical context annotations, smart markdown chunking with break-point scoring, position-aware RRF blending, agent-optimized output formats with lazy discovery
  - **Weaknesses:** sqlite-vec alpha quality, 2GB cold-start download, Node 22+ requirement, bus factor concerns, no incremental embedding
  - **Competitive landscape:** closest competitor is Khoj (RAG chatbot) but different abstraction — QMD returns results, doesn't generate answers. Kiro Knowledge Bases are enterprise cloud equivalent. rg+fzf is the floor for small collections.
  - **Connections to prior research:**
    - Context-as-precious-resource: QMD implements lazy scored retrieval (discovery → selective full retrieval), exactly the pattern identified in CLI-vs-MCP research
    - Harness engineering: occupies context engineering layer; value depends on whether knowledge retrieval is the agent's actual bottleneck
    - CLI > MCP: QMD's CLI path is superior for coding agents; MCP daemon is smart hedge for non-terminal agents
    - Search APIs: QMD fills the private knowledge gap external APIs can't reach
    - Output trimming: built-in output budget controls (--min-score, -n, -l, --max-bytes, --files format)
  - **Verdict:** Best on-device knowledge retrieval tool for AI coding agents as of Feb 2026. Natural fit for Pi + terminal-native workflow.
  - Updated `topics/dev-tools.md` with QMD section, `topics/coding-agents.md` with forward link

## 2026-02-28 (session 6) — Semantic search practitioner playbook + self-review

- **Created** `research/semantic-search-practitioner-playbook.md` — distilled from `semantic-search-llm-token-savings-research.md`
  - Decision framework: 3 yes/no questions (codebase size, query type, pricing model)
  - 3-tier implementation stack ranked by impact-to-effort
  - Tool comparison table: Augment Code, claude-context, GrepAI, CodeGrok
  - Persona-specific priorities (solo API, solo Max, team Cursor, team custom agent)
  - Validated against latest data: Augment Context Engine MCP (Feb 6, 30-80% quality on Elasticsearch), MCP Tool Search (Jan 14, 95% context savings), RTK (Feb 2026, 89% CLI output savings)
- **Critical self-review** found and corrected significant issues:
  - **RTK token category error (must-fix)**: Claimed RTK saves output tokens at $25/M — wrong. RTK saves input tokens (tool results) at $5/M or $0.50/M cached. "5× dollar impact" claim was false. Corrected to lead with quality argument (less noise → better attention allocation).
  - **Augment 30-80% overstated**: Single-repo vendor benchmark (Elasticsearch). 30% marginal over Cursor is the honest number. 80% on Claude Code partly reflects Claude Code's weak default retrieval on unfamiliar Java monorepos. Added caveat.
  - **Serena "most underutilized" without evidence**: Demoted to "architecturally promising, undervalidated." No rigorous benchmarks exist.
  - **Missing: AGENTS.md as Tier 0**: Added as first recommendation — highest-ROI optimization (zero tokens, zero infra, zero staleness)
  - **Missing: model selection as cost lever**: Opus→Sonnet = 40% savings, more than any tool in the playbook
  - **Self-Route conflated**: Separated Li et al. academic architecture (trained classifier) from ad-hoc AGENTS.md approximation
  - **"Quality not cost" too binary**: Added cost = session sustainability for API users, rate-limit windows for Max users
  - **Action bias**: Added "do nothing baseline is improving" caveat
- Saved review to `research/semantic-search-practitioner-playbook-review.md`
- Updated `topics/coding-agents.md` with links to both files
- **Lesson**: Always check which token category a tool actually affects (input vs output vs cache) before making cost claims. "CLI output" ≠ "LLM output tokens."

## 2026-02-28 — Session: FDE (Forward Deployed Engineer) Research

- Researched the FDE trend: origin (Palantir early 2010s), current hype cycle (800%+ job posting surge in 2025), and critical assessment
- Sources consulted: First Round Review (expert panel), SVPG/Marty Cagan, a16z thesis, Pragmatic Engineer, Constellation Research, Thomas Otter (Angular Ventures), David Peterson (Angular Ventures), Reddit/HN threads
- Key finding: genuine structural need (AI products are harder to deploy than traditional SaaS) but massive hype overlay — follows exact PLG hype cycle pattern from 2018–2022
- Verdict: real but narrow need being indiscriminately applied; most "FDE" jobs are rebranded solutions/implementation roles; VC pattern-matching in full effect
- Saved to `research/forward-deployed-engineers-fde-analysis.md`

## 2026-03-01 — Session 41

- Researched software design patterns organized by problem domain (language-agnostic, not paradigm-specific)
- Deep web research across: DDD tactical/strategic patterns, CQRS/Event Sourcing, distributed coordination (Saga, Outbox, Compensating Transaction), resilience (Circuit Breaker, Bulkhead, Backpressure), Enterprise Integration Patterns (Pipes & Filters, Routing, Scatter-Gather), concurrency models (Actor, CSP, Structured Concurrency), architecture (Hexagonal, Clean, Vertical Slice), data access (Repository, Data Mapper, Active Record, Unit of Work), caching strategies, migration patterns (Strangler Fig, ACL), deployment patterns, business rules (State Machine, Rules Engine), API boundaries (Gateway, BFF, Sidecar), observability
- 14 problem domains, 70+ patterns cataloged with critical assessments and when-to-use guidance
- Includes pattern interaction map showing common compositions
- Saved to `research/software-design-patterns-by-problem-domain.md`

## 2026-03-01

- Brainstormed software architecture patterns for AI/agent-pervasive future
- Synthesized across existing research: dark factory thesis, harness engineering, MCP/CLI convergence, design patterns, HN practitioner threads (frameworks debate, beyond agentic coding, eight more months, MCP CLI)
- Identified 10 architectural patterns: verified-by-construction, orchestration-as-architecture, progressive discovery, memory-as-architecture, reviewability-first, adversarial interfaces, event-sourced actions, collapsing middle, HITL control flow, cost-aware design
- Pattern survival analysis: which traditional patterns are reinforced/transformed/dying
- Key thesis: the transition is a structural inversion from "optimize for human comprehension" to "optimize for machine navigability + automated verification"
- Saved to `research/software-architecture-ai-agent-era.md`

### Session 41 continued

- Follow-up research: how design patterns shift in an agent-everywhere future
- Deep web research across: multi-agent orchestration frameworks (LangGraph, Google ADK, AgentOrchestra), agent interoperability protocols (MCP, A2A, ACP, ANP), context engineering (Karpathy, SitePoint, Henry Vu), guardian/guardrail patterns (TRiSM, Spring AI LLM-as-Judge, Patronus AI, OWASP), human-in-the-loop architectures, hierarchical agent delegation
- Analysis in three categories: (1) existing patterns that become load-bearing (State Machine, Circuit Breaker, Saga, Idempotency, Pipes & Filters, Pub-Sub, Observability, Hexagonal), (2) patterns needing adaptation (CQRS, Repository→RAG, ACL for LLM output, Feature Flags→Capability Flags), (3) genuinely new patterns (Context Engineering, Guardian/Sentinel, HITL Gate, Capability Card, Nondeterminism Envelope, Memory Hierarchy, Prompt-as-Contract, Hierarchical Delegation, Sandboxed Execution, Asymmetric Verification)
- Identified 6 open problems not yet crystallized into patterns: agent identity/trust, cost-aware routing, graceful capability degradation, long-horizon consistency, multi-agent conflict resolution, adversarial robustness as architecture
- Saved to `research/design-patterns-agent-future.md`

## 2026-03-01

- Deep dive into Pi RPC mode from pi-mono repo
  - Read all source: rpc-mode.ts, rpc-types.ts, rpc-client.ts, tests, examples, extension UI demo
  - Analyzed all consumers: Mom (SDK direct), Web UI (agent-core direct), tests (RpcClient), examples (spawn subprocess)
  - Key finding: zero production consumers — RPC is well-designed but untested by real apps
  - Identified bugs: fire-and-forget error swallowing on prompt, shutdown hang, no backpressure
  - Compared integration patterns: RPC vs SDK vs agent-core direct
  - Saved to `research/pi-rpc-mode-deep-dive.md`
  - Self-review round: searched internet for broader ecosystem context
  - Key correction: stdin/stdout JSON agent protocol is now industry standard (ACP by Zed, adopted by JetBrains/Neovim/Cline/Gemini CLI/Kiro/Claude Code)
  - Pi's custom protocol vs JSON-RPC 2.0 is the real competitive disadvantage, not "no consumers"
  - A2A (Google) is a different layer entirely — agent-to-agent orchestration, not editor-to-agent control
  - AAIF (Linux Foundation) now governs MCP + AGENTS.md + A2A; protocol landscape crystallizing
  - Revised verdict: "good answer in the wrong dialect" — ACP implementation is the obvious next step
  - Updated research file with self-corrections and broader protocol landscape

## 2026-03-03
- Distilled HN thread on Claude outage (47227647, 162 comments)
  - Key dynamics: OpenAI→Anthropic migration surge causing the outages, DoD standoff as retention moat, AWS ME data centers hit by drone strikes (first military strike on US Big Tech infra), skill atrophy debate crystallized into 3 camps, knowledge-hoarding feedback loop (LLM as sole knowledge repository)
  - Star comment: vidarh's sub-agent workflow for context management
  - Thread meta-irony: moral conviction driving migration IS the scaling pressure causing outages
  - Saved to research/hn-claude-outage-2026-03.md, linked from README

## 2026-03-04

- Deep research: CLI tools & context efficiency for coding agents
  - Explored available CLI tools in pi environment (rg, fd, ast-grep, jq, sqlite3, tokei, bat, eza, delta, gh, curl, tmux, rodney)
  - Researched what experts/practitioners are doing for context efficiency
  - Key findings:
    - 99% of agent tokens are re-sent input (trajectory), not output — context efficiency is THE optimization
    - Claude Code deliberately abandoned RAG for agentic search (rg/grep) — simpler tools, better results
    - Token efficiency varies 10x between agents: Aider (8.5-13k via tree-sitter+PageRank) vs Codex CLI (highest)
    - AgentDiet (Sep 2025): 40-60% token reduction via trajectory pruning, no performance loss
    - Simple observation masking beats LLM summarization (cheaper, Pareto-optimal)
    - CLI > MCP for token efficiency (~40% savings — no persistent tool definitions, no JSON-RPC framing)
    - ast-grep practitioners forcing it as primary search tool for accuracy + less noise
    - Sub-agents for context isolation (explored by sub-agent, summary returned to main)
  - Synthesized into research/cli-tools-context-efficiency.md, linked from README
  - Self-audited tool use across 271 sessions in this project
    - 121MB total tool output (~30M tokens); 72% read, 26% bash
    - This session: 74% of context consumed by web searches at max token settings
    - Identified 6 anti-patterns: max-token searches before surveying, large dir listings, incremental file reads, trial-and-error schema probing, redundant tool discovery, no `| head` safety
    - Key fix: search.js → content.js pipeline instead of llm-context.js --tokens 16384
    - Saved to research/agent-tool-use-self-review.md
  - Critical review of agent-tool-use-self-review.md — independent verification
    - Re-parsed all 272 session JSONL files; verified every quantitative claim
    - Numbers directionally correct but inflated 3-6%: 114.4 MB actual vs 121 MB claimed
    - Image session claim wrong: 37 unique images (not 44), 65 MB consumed (not 33 MB), 36 duplicated across sessions
    - Web search % on "this session" actually worse than stated (79% vs 74%)
    - Found citation error in companion doc: arxiv:2508.11126 is "AI Agentic Programming: A Survey," NOT the code retrieval study
    - ContextBench framing inconsistency: paper says "marginal gains," doc presented it as supporting 10x efficiency differences
    - Verified: AgentDiet, Lindenbauer, CompLLM, Chroma context rot, NVIDIA RULER — all check out
    - Updated both research files with corrections and verification notes
  - Stress-tested all anti-pattern rules against edge cases
    - Ran actual commands for each rule: bad vs good approach, measured savings
    - Found 6 of 8 rules break under edge cases — converted absolute rules to conditional
    - Key findings: search.js→content.js 2.6x WORSE for breadth (llm-context 4096 covers 16 sources in 21K);
      content.js on arxiv/wikipedia dumps 65K chars (no cap); 2-search limit misses critical papers;
      rg -l worse than ls for <20 files; head|jq dangerous on large records; |head hides tail errors
    - Measured trajectory turn cost: 1,206 chars/turn non-thinking, ~12 KB snowball per extra turn
    - grep vs rg in node_modules dir: 1,208,782 vs 1,240 chars (99.9% savings — rg's biggest win)
    - git diff --stat overhead is only 225 chars (~1-3%) — always worth it even worst case

### 2026-03-04 (session 5) — AGENTS.md Best Practices Research & Critical Review

- **Fixed**: "4x" → "~10x" in CLI Tool Use snowball cost (was wrong per self-review data: 39/4≈10x)
- **Researched**: 13 credible sources on AGENTS.md/CLAUDE.md best practices
  - Key sources: Anthropic official docs, GitHub Blog (2,500-repo analysis), HumanLayer (instruction budget),
    Arize (prompt learning +5-11% from instructions alone), Buildcamp (2026 guide), rosmur (12-source synthesis)
- **Key findings**:
  - Instruction budget: ~150-200 for frontier LLMs; Claude Code system prompt uses ~50; our file has ~55 instructions (well within budget)
  - Performance degrades uniformly as instruction count increases (not just later instructions)
  - LLMs bias toward instructions at prompt peripheries (beginning + end) — our layout is optimal
  - "Document corrections, not education" — every rule in our file passes this test
  - Progressive disclosure is the unanimous recommendation — we already do this via skills + conditional navigation
  - Arize's prompt learning: +5.19% accuracy from instructions alone, +10.87% for repo-specific
- **Critical review verdict**: Our AGENTS.md is in the top tier. No material changes recommended.
  95 lines, ~55 instructions, correction-oriented, no fluff, CLI section uniquely valuable
- **Saved**: research/agents-md-best-practices.md, updated README index
- **AGENTS.md optimizations applied** (4 changes total this session):
  1. `4x` → `~10x` snowball cost (factual fix from self-review data)
  2. `"Verify accuracy before acting and after changing"` — closes verify-after gap (Anthropic's #1 best practice)
  3. `"Suggest CLI/TUI alternatives, not GUI"` — alternative instead of bare prohibition
  4. `IMPORTANT:` on decision ladder — marks high-violation-risk rule
- **Skipped** (justified): one-sentence scope description, IMPORTANT consistency review, CLI section extraction to skill
- Synced AGENTS.md via chezmoi, committed and pushed to dotfiles repo

## 2026-03-06 — Mojo GPU Programming Deep Dive
- Researched Mojo language for GPU programming: architecture, benchmarks, competitive landscape
- **Key sources**: ORNL peer-reviewed paper (arxiv:2509.21039), Modular GitHub/blog, Lattner's own comments, HN/Reddit threads, Modular forum
- **Key findings**: MLIR-native approach is architecturally sound; memory-bound kernels competitive (87–102% of CUDA); compute-bound has gaps (38–59% on some workloads); AMD support immature; Apple Silicon is the sleeper play
- Flagged "markaicode.com" Rust-vs-Mojo article as likely AI-generated SEO content with unverifiable claims
- Filed as `research/mojo-gpu-programming-deep-dive.md`, added to README

## 2026-03-06

- Synthesized workflow document from three existing research files: thesis (flywheel), playbook (tactics), root cause analysis (why instructions fail)
- Created `research/workflow-minimal-composable-systems.md` — actionable checklist for human+agent collaboration on maintainable code
- Grounded in historical expert quotes: Dijkstra (humble programmer), Hoare (two ways), Kernighan (debugging twice as hard), McIlroy (Unix philosophy), Beck (simplest thing), Gall's Law, Hickey (simple≠easy), Metz (wrong abstraction), Lehman's Laws, Glass (maintenance 60-80%)
- Key structural insight: five agent self-awareness items (RLHF length bias, autoregressive momentum, statelessness, context degradation, sycophancy) — not behavioral tips, but architectural constraints
- Added all four related files to README (three source files were missing)

## 2026-03-08 — Claire STEM Internships: Critical Review

- Critically reviewed `research/claire-stem-internships-2026.md` against primary sources (Brave Search verification)
- Found 3 critical errors: Salk deadline already passed (March 1, not March 28), Scripps REACH restricted to 9 partner schools (not generally available), SPARK deadline appears fabricated
- Found 3 moderate errors: Cooper Union deadline ambiguous (March 22 vs 27), Salk acceptance rate unverified, Salk eligibility more flexible than stated
- Discovered missed opportunity: Scripps Research Translational Institute (SRTI) — separate program with no school restriction — was on the same page but overlooked
- Created `research/claire-stem-internships-2026-review.md` with corrected situation table, verified next steps, and meta-analysis of how the errors happened
- Pattern diagnosis: year confusion on cached deadline pages, eligibility blindness (bold notice missed), precision fabrication (specific numbers without sources)
- Key takeaway: Cooper Union is the one confirmed viable formal program; everything else needs fresh investigation

## 2026-03-08 — Claire STEM: Decision Brief (with bio constraint)

- Re-assessed all options incorporating the "no biology" constraint
- Verified every remaining program against primary sources (deadlines, eligibility, biology requirements)
- Key findings from verification:
  - UCSD REHS: deadline was March 15 — already past (not caught in first review)
  - UCSD COSMOS: deadline was Feb 6 — already past
  - UCSD Academic Connections: cancelled for 2026 entirely
  - SRTI (Scripps Translational Institute): confirmed still open (~March 30 deadline), no biology requirement, computational/data science focus — strong fit
  - Cooper Union: confirmed still open (March 22 or 27), detailed all 8 course options with prerequisites
  - BE WiSE: deadline March 20, year-round community program (not summer-only)
  - UCSD MAP: opens April 15, 8-month mentorship (not summer program)
  - UCSD Research Scholars: Summer 2026 Bioengineering track deadline May 8
- Biology gap is a non-issue: all viable options are engineering/computational
- Created `research/claire-stem-internships-2026-decision.md` — distilled decision brief with verified data, biology impact table, Cooper Union vs SRTI decision framework, and 12-month credential-building strategy
- Core insight: the real gap isn't missed deadlines, it's no research experience. 2026 summer = first credential in a 12-month build toward 2027 elite applications

## 2026-03-08 — UCSD MAP Deep Dive

- Deep researched UCSD Mentor Assistance Program from primary sources (SDSC website, UCSD press releases, mentor pages, application details)
- Created `research/ucsd-map-deep-dive.md` — comprehensive analysis covering: program structure, eligibility, application process, all current mentors with project descriptions, mentor selection strategy for Claire, critical assessment, timeline, strategic positioning
- Key findings: 10th year of operation, ~60 students / ~13 mentors per cohort, 2-4 hrs/week Oct–May, culminates in poster + lightning talk at SDSC symposium
- Best mentor matches for Claire: Dr. Jack Silberman (AI/ML on the Edge — hands-on, Python, AI hardware + SDSC supercomputer access) and Dr. Angela Berti (TILOS AI Research Institute — national AI institute, MIT/Yale partnerships)
- Critical strategic insight: MAP is the cheapest path to "verifiable UCSD research experience with named faculty" — the single credential that transforms 2027 elite program applications
- Application opens April 15, deadline May 31, notification August 1-15

## 2026-03-15
- Set Claude Opus 4.6 and Sonnet 4.6 context windows back to 200K (from 1M default)
  - Via `~/.pi/agent/models.json` using `modelOverrides` — survives pi updates
