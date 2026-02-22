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
- [AI Future Careers Forecast](research/ai-future-careers-deep-forecast.md) — cascade effects, future careers, practical playbook for teens
- [HN: LLM Car Wash Reasoning Failure](research/hn-llm-car-wash-reasoning.md) — goal-constraint violations, token commitment, whack-a-mole patching
- [HN: Ring/Nest Surveillance State](research/hn-ring-nest-surveillance-state.md) — selective enforcement, voluntary corporate compliance, Pinkerton parallel
- [Pacific Ridge School — Critical Analysis](research/pacific-ridge-school.md) — college placement deep dive, San Diego peer comparison, price-to-value
- [PRS Profile Analysis (original)](research/pacific-ridge-school-profile-analysis.md) — AO-perspective reading of the 2025-26 profile
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

## Conventions

- New research → `research/` directly. No topic page required upfront.
- Topic pages created/updated when 2+ research files cluster, or a decision is worth recording.
- Update this README when a decision changes (tool swap, model change, etc.).
- See [worklog.md](worklog.md) for chronological session history.
