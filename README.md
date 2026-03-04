# Notes

## Active Stack

- **Coding agent:** Pi (shittycodingagent.ai) — [why →](topics/coding-agents.md)
- **Primary model:** Claude Opus 4.6 via Anthropic API — [model landscape →](topics/llm-models.md)
- **Free backup:** Gemini 2.5 Flash (250 RPD) — [free tier details →](topics/llm-models.md#gemini-free-tier)
- **Markdown viewer:** Glow v2.1.1 (`brew install glow`) — [alternatives →](topics/dev-tools.md#markdown-renderers)
- **Search API:** TBD (Brave recommended for paid, Serper+Jina for budget) — [evaluation →](topics/dev-tools.md#search-apis)
- **Browser tool:** TBD (agent-browser recommended) — [comparison →](topics/dev-tools.md#browser-tools-for-coding-agents)

## Topics

- [LLM Models & Pricing](topics/llm-models.md) — Gemini landscape, Sonnet 4.6, free tier, API key status
- [Coding Agents](topics/coding-agents.md) — Pi, OpenClaw, agent landscape, tool comparisons, practitioner evidence
- [Software Factory](topics/software-factory.md) — autonomous production, dark factory thesis, verification layers, StrongDM
- [Developer Tools](topics/dev-tools.md) — terminal markdown renderers, search APIs, browser comparison

## Other Research

Not yet grouped into topics:

- [Martin Fowler's Site — Critical Analysis](research/fowler-critical-analysis.md) — article-by-article assessment, Jul 2025–Feb 2026
- [Fowler Articles — Novelty Ranked](research/fowler-articles-novelty-ranked.md) — ranked by novelty to my own thinking
- [Sam Schillace's Sunday Letters](research/sunday-letters-deep-dive.md) — Microsoft Deputy CTO on software unbundling, AI personhood, taste
- [AI Predictions: Best Forecasters](research/ai-predictions-best-forecasters.md) — Samotsvety, Caplan, Yegge, Gates, Hinton, Hassabis, Huang, Karpathy; bear cases; 2026 reality check
- [AI Predictions: Social & Economic Impact](research/ai-predictions-social-economic-impact.md) — Acemoglu, Autor, Perez, Brynjolfsson, Brooks; who's best at predicting AI's societal effects
- [AI Future Careers Forecast](research/ai-future-careers-deep-forecast.md) — cascade effects, future careers, practical playbook for teens
- [HN: LLM Car Wash Reasoning Failure](research/hn-llm-car-wash-reasoning.md) — goal-constraint violations, token commitment, whack-a-mole patching
- [HN: Ring/Nest Surveillance State](research/hn-ring-nest-surveillance-state.md) — selective enforcement, voluntary corporate compliance, Pinkerton parallel
- [HN: Em-Dash Bots on HN](research/hn-em-dash-bots-2026.md) — new accounts 10x more em-dashes, AI startup astroturfing vocabulary, humans degrading their own writing

- [HN: IBM Plunges After Anthropic COBOL Blog Post](research/hn-ibm-cobol-anthropic.md) — narrative-driven stock crash, mainframe lock-in reality, content-marketing-as-market-event
- [HN: Claude's New Constitution](research/hn-claude-constitution-2026.md) — institutional vs. individual priorities, judgment-over-rules as untested empirical bet

- [HN: Karpathy on "Claws"](research/hn-karpathy-claws-llm-agents.md) — persistent AI agent systems, security impossibility, emotional vs functional appeal
- [NanoClaw Deep Dive](research/nanoclaw-deep-dive.md) — ~4K LOC container-isolated Claw alternative, security model, skills-over-features philosophy
- [HN: AI uBlock Blacklist](research/hn-ai-ublock-blacklist.md) — blocklist governance, false positives, professionalization pressure
- [AI Slop Blocking Landscape](research/ai-slop-blocking-landscape.md) — blocklists, detection extensions, temporal filtering, C2PA, platform responses
- [Gondolin Agent Sandbox](research/gondolin-agent-sandbox.md) — Armin Ronacher's QEMU micro-VM sandbox, competitive landscape, Thoughtworks endorsement
- [HN: Matchlock Agent Sandbox](research/hn-matchlock-agent-sandbox.md) — VM sandboxing for AI agents, confused deputy problem, Claude Cowork exfiltration, Opus 4.6 red-teaming
- [Gondolin vs Matchlock](research/gondolin-vs-matchlock.md) — deep security comparison across 7 attack classes, scorecards, recommendation
- [Matchlock Setup Guide](research/matchlock-setup-guide.md) — practical configuration burden for Pi on macOS, honest assessment
- [Agent as Separate macOS User](research/agent-separate-macos-user.md) — low-cost OS-level isolation, shared workspace setup, threat model comparison
- [Agent Isolation Friction: Self-Rebuttal](research/agent-isolation-friction-rebuttal.md) — why "just run open" was wrong, tiered access as the right model
- [Separate User: Pre-Commitment Analysis](research/agent-separate-user-precommit-analysis.md) — what you get, pay, forgo; decision framework
- [Agent Security: What People Actually Do](research/agent-security-landscape-what-people-do.md) — OpenClaw vs interactive crowd, LuLu + dedicated accounts, tiered security
- [Claude Opus 4.6: 1M Context Window Analysis](research/claude-opus-4.6-1m-context-window.md) — 1M vs 200K, attention dilution research, practitioner evidence, verdict
- [HN: Skip Goes Free & Open Source](research/hn-skip-open-source.md) — Swift→Android cross-platform, LGPL-3 friction, paid dev tools death, adoption flywheel gap
- [HN: Cognitive Debt from ChatGPT](research/hn-cognitive-debt-chatgpt.md) — MIT EEG study, tool use vs skill substitution, conflict of interest, Socrates fallacy
- [Three-Pillar Learning Framework](research/three-pillar-learning-framework.md) — theory/practice/metacognition, why LLMs differ from prior tools, critical evaluation
- [HN: Dead Internet Theory](research/hn-dead-internet-theory.md) — incentive theory vs detection theater, em-dash witch hunt, human-bot convergence, PageRank analogy
- [HN: The Recurring Dream of Replacing Developers](research/hn-replacing-developers-dream.md) — essential vs accidental complexity reclassification, junior pipeline crisis, democratization-by-failure, AI slop meta-irony
- [HN: DuckDB as First Choice for Data Processing](research/hn-duckdb-first-choice-data-processing.md) — relational guarantees over speed, SQL-vs-dataframes conflation, Ibis convergence, governance moat, production gaps
- [HN: Data Is the Only Moat](research/hn-data-is-the-only-moat.md) — VC 2×2 framework, data-as-suitcase-word, distribution-before-data sequence, unfalsifiable positioning
- [HN: Slop Is Everywhere](research/hn-slop-everywhere-eyes-to-see.md) — FYP demand/supply inversion, algorithm-forced creator slop, Vine myth, grammar-pedantry meta-irony, principal-agent blind spot
- [HN: Loneliness Epidemic](research/hn-loneliness-epidemic.md) — cost disease framing, survivorship bias in "just organize" advice, obligation-based institution design pattern, AI companionship tension
- [HN: Shellbox.dev — SSH Linux Boxes](research/hn-shellbox-dev.md) — suspend/resume VMs via SSH, pricing death spiral, SSH-as-management-plane insight, AI agent sandbox market timing
- [HN: News Publishers Limit Internet Archive over AI Scraping](research/hn-news-publishers-internet-archive-ai-scraping.md) — security theater, paywall-as-pretext, gatekeeper inversion, astroturf meta-irony, "compliant get punished" dynamic
- [HN: Eight More Months of Agents](research/hn-eight-more-months-agents.md) — founder testimonial vs organizational reality, $170 taste gap, tribal knowledge scaling, process bottleneck blindspot
- [HN: What AI Coding Costs You](research/hn-ai-coding-costs-47194847.md) — cognitive debt vs technical debt, Shen-Tamkin study misreadings, review paradox, seniority pipeline collapse, joy erosion
- [HN: LocalGPT Rust Assistant](research/hn-localgpt-rust-assistant.md) — OpenClaw clone pattern crystallization, lethal trifecta security exchange, LLM-slop credibility problem, confirmatory of existing insights
- [HN: AI Labor Obsolescence — Who Gets to Eat?](research/hn-ai-labor-obsolescence-who-eats.md) — power-asymmetry ratchet, identity-as-labor psychological barrier, democracy's structural dependency on labor leverage
- [AI and Future Society: Deep Research](research/ai-future-society-deep-research.md) — GPT adoption timelines, Acemoglu/Autor/Brynjolfsson schools, bubble anatomy, Global South extraction, Narrow Corridor framework, four grounded scenarios
- [HN: 1Password Pricing +33%](research/hn-1password-price-increase.md) — enterprise deprioritization of consumers, passkey lock-in, password manager market failure, performative churn
- [HN: Vouch — Community Trust Management](research/vouch-hn-thread.md) — judgment laundering through mechanism, kayfabe insight, web-of-trust redux, newcomer exclusion tradeoff
- [HN: Coding Agents Replaced Every Framework](research/hn-coding-agents-replaced-frameworks.md) — LISP curse redux, training data commons depletion, sovereignty transfer not reclamation, retirement manifesto
- [AI Workplace Mandates vs. Productivity Paradox](research/ai-workplace-mandates-productivity-paradox.md) — Goodhart's Law in AI KPIs, vendor-customer ouroboros, cargo-cult mandates, Solow parallel limits
- [HN: Making MCP Cheaper via CLI](research/hn-mcp-cheaper-via-cli.md) — MCP-as-catalog not runtime, composability > token savings, five convergent projects, Code Mode endgame
- [Exemplary Codebases for LLM Context](research/exemplary-codebases-for-llm-context.md) — deeply interesting designs with unique constraints, trade-offs, and what to learn; includes [counter-evidence](research/exemplary-codebases-counter-evidence.md) challenging every project
- [Architecturally Remarkable Repos](research/architecturally-remarkable-repos.md) — modern projects with novel architectural bets, plus critical self-review: ScyllaDB/Seastar, TigerBeetle, DuckDB, vLLM, FoundationDB DST, Redpanda, Ghostty, Jujutsu, llama.cpp/GGML, Neon, Cilium, and more
- [HN: What Claude Code Chooses](research/hn-claude-code-picks.md) — LLM tool recommendations as invisible kingmaking, Tailwind's structural advantage, AGENTS.md 80% compliance, build-vs-buy bias, recency gradient as curated RL
- [Rust: Critical Evaluation (Feb 2026)](research/rust-language-critical-evaluation-2026.md) — adoption numbers, Linux kernel permanence, enterprise deployments, performance benchmarks, steelmanned criticisms, AI-agent thesis (overstated), token efficiency vs context rot analysis, job market, forward outlook
- [Signal-to-Value: High-Level Languages for Exploration](research/signal-to-value-high-level-languages-exploration.md) — deep dive testing whether high-level languages are truly better for exploration (LLM or not), evidence/counter-evidence on semantic density vs verification density, Gall's Law, borrow-checker death spirals, breadth-first vs depth-first resolution
- [Pi RPC Mode — Deep Dive & Critical Review](research/pi-rpc-mode-deep-dive.md) — architecture, protocol design, three-layer stack, all consumers (SDK/RPC/agent-core); relation to ACP (Zed's JSON-RPC 2.0 stdin/stdout standard adopted by JetBrains/Neovim/Cline/Gemini CLI/Kiro), A2A (Google's agent-to-agent, different layer entirely), MCP, AAIF; critical self-correction: "no consumers" was wrong — the pattern is industry standard, pi just speaks a custom dialect; key recommendation: implement ACP for ecosystem compatibility
- [Pi A2A Integration — Deep Technical Analysis](research/pi-a2a-integration-analysis.md) — what it takes to add A2A to pi: 8-layer implementation breakdown (~1,500-2,200 LOC), HTTP server + Agent Card + JSON-RPC dispatch + task lifecycle + content translation + SSE + auth; pi RPC broader use cases (CI/CD, multi-agent, platform bots, dashboards); critical assessment: ACP first (~500-800 LOC, 10× more value), A2A second as extension/package; architecture diagrams; open problems (concurrency, multi-tenancy, tool permissions, cwd isolation)
- [Agent Skills: Architecture & Analysis](research/agent-skills.md) — pi skills mechanism, progressive disclosure, commit (simplest) vs agent-browser (most sophisticated), critical assessment, MCP comparison
- [Agent Skills & Tools: Emerging Winners](research/agent-skills-emerging-winners.md) — category-by-category analysis (browser, search, workflow, docs), CLI vs MCP token math, Playwright CLI vs Agent Browser, skills.sh ecosystem, flywheel at platform level not tool level
- [Agent Skills: Category Landscape & Non-Obvious Winners](research/agent-skills-landscape-categories-winners.md) — 12-category deep map, Block's 3 design principles, self-improvement loops as sleeper hit, bug pattern libraries, security attack taxonomy (Oathe/Snyk audits), vendor skills as GTM, non-obvious creative uses (video→QA, session compounding)
- [Skills: Deep Synthesis — When, Why, ROI](research/skills-deep-synthesis-when-why-roi.md) — durability filter (durability ≠ value), 5 structural archetypes (gauntlet/loop/scaffold/constitution/codifier), delivery mechanism fit (extension vs skill vs AGENTS.md), ROI matrix (estimates, not data; maintenance cost explicit), anti-patterns, unbuilt skills (coding + non-coding), four-tier skill market structure (private knowledge / methodology seeds / tool bridges / staleness patches)
- [LLM Capability vs. Pseudo-Capability](research/llm-capability-vs-pseudo-capability.md) — what's real vs illusion in LLM reasoning; mechanistic interpretability evidence (Anthropic circuit tracing, Gemma Scope 2); faithfulness problem (0.04–13% CoT fabrication); METR 19% slowdown RCT; Apple "Illusion of Thinking" full debate; context-directed extrapolation framework; practitioner reality check; capability trust map
- [Post-Nov 2025 Model Failures: Antidotes](research/post-nov-2025-model-failure-antidotes.md) — 20 evaluated countermeasures across isolation/verification/structure; CRV, NLDD, asymmetric verification, code health scoring, DeepMind scaling principles, environment-dependent strategy; each rated on evidence, first-principles soundness, and practitioner viability
- [Software Design Patterns by Problem Domain](research/software-design-patterns-by-problem-domain.md) — 14 problem domains, 70+ patterns organized by what they solve (not paradigm); covers business complexity, distributed coordination, resilience, CQRS/ES, messaging, concurrency, architecture, persistence, caching, migration, deployment, business rules, API boundaries, observability; pattern interaction map; critical takes on each category
- [Software Architecture in the AI/Agent Era](research/software-architecture-ai-agent-era.md) — 10 architectural patterns for LLM/agent-pervasive systems: verified-by-construction, orchestration-as-architecture, progressive discovery, memory-as-architecture, reviewability-first, adversarial interfaces, event-sourced actions, collapsing middle, HITL control flow, cost-aware design; pattern survival analysis (reinforced/transformed/dying); grounded in existing research corpus
- [Design Patterns in an Agent-Everywhere Future](research/design-patterns-agent-future.md) — what shifts when LLM agents are primary actors; 10 existing patterns that become load-bearing (State Machine, Circuit Breaker, Saga, Idempotency), patterns needing adaptation (CQRS, Repository/RAG, ACL for LLM output), 10 genuinely new patterns (Context Engineering, Guardian/Sentinel, Human-in-the-Loop Gate, Capability Card, Nondeterminism Envelope, Memory Hierarchy, Prompt-as-Contract, Hierarchical Delegation, Sandboxed Execution, Asymmetric Verification), open problems, pattern interaction map for agent systems
- [Clojure for AI Agent-Assisted Coding](research/clojure-ai-agent-coding.md) — REPL advantage real but commoditized, type system gap (critical), training data deficit, Mycelium thesis (language-agnostic), source echo chamber; revised verdict: weaker than advocates claim
- [HN: Claude Outage March 2026](research/hn-claude-outage-2026-03.md) — dependency crisis masked by tribal politics, OpenAI migration DDoS, AWS drone strikes, skill atrophy generational split, knowledge-hoarding feedback loop

## Collections

- [Insights](insights.md) — durable, transferable structural insights with strong evidence
- [Meta-Review](meta-review.md) — critical self-review: what survives scrutiny, what's overstated, blind spots, epistemic lessons
- [LLM Analysis Failure Mode](lesson-llm-analysis-failure-mode.md) — the three-turn tax: why LLM analysis requires adversarial review, how to reduce the cost
- [AI Coding Agent Anecdotes](anecdotes.md) — first-hand practitioner reports on AI coding tools
- [Product Design Observations](product-design.md) — novel implementation patterns and UX choices observed in the wild

## Conventions

- New research → `research/` directly. No topic page required upfront.
- Topic pages created/updated when 2+ research files cluster, or a decision is worth recording.
- Update this README when a decision changes (tool swap, model change, etc.).
- See [worklog.md](worklog.md) for chronological session history.
