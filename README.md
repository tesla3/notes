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
- [Pacific Ridge School — Critical Analysis](research/pacific-ridge-school.md) — college placement deep dive, San Diego peer comparison, price-to-value
- [PRS Profile Analysis (original)](research/pacific-ridge-school-profile-analysis.md) — AO-perspective reading of the 2025-26 profile
- [HN: IBM Plunges After Anthropic COBOL Blog Post](research/hn-ibm-cobol-anthropic.md) — narrative-driven stock crash, mainframe lock-in reality, content-marketing-as-market-event
- [HN: Claude's New Constitution](research/hn-claude-constitution-2026.md) — institutional vs. individual priorities, judgment-over-rules as untested empirical bet
- [PRS Profile Analysis Review](research/pacific-ridge-profile-analysis-review.md) — critical review of the above analysis
- [PRS Comprehensive Profile Review](research/pacific-ridge-school-profile-comprehensive-review.md) — definitive AO-grade profile assessment with full contextualization
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

## Collections

- [Insights](insights.md) — durable, transferable structural insights with strong evidence
- [AI Coding Agent Anecdotes](anecdotes.md) — first-hand practitioner reports on AI coding tools
- [Product Design Observations](product-design.md) — novel implementation patterns and UX choices observed in the wild

## Conventions

- New research → `research/` directly. No topic page required upfront.
- Topic pages created/updated when 2+ research files cluster, or a decision is worth recording.
- Update this README when a decision changes (tool swap, model change, etc.).
- See [worklog.md](worklog.md) for chronological session history.
