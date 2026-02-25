# Coding Agents

← [Index](../README.md)

## Current Decision

**Using Pi** (shittycodingagent.ai) as primary coding agent with Claude Opus 4.6.

**Why Pi wins for this user profile** (experienced dev, wants control, terminal-native):
- Sub-1,000-token system prompt → maximum context for actual work
- 4 tools (read, write, edit, bash) — frontier models don't need more
- Session trees — branch for side quests, rewind to main line with summary
- Mid-session model switching — Claude for deep work, Gemini for large context, GPT for second opinion
- Extension system — agent can modify itself; replace MCPs with skills the agent builds
- Native Anthropic API — full KV cache, prompt caching, signed reasoning blobs when staying on one provider
- Best context efficiency — sustains longer sessions before compaction than Claude Code

**Why not Claude Code / Codex / Cursor:**
- Claude Code's system prompt is thousands of tokens and changes per release (worse cache behavior)
- No mid-session model switching
- No session branching
- Pi competes on Terminal-Bench 2.0 despite radical minimalism

**Known trade-offs:**
- High skill floor — "build it yourself" philosophy, no built-in MCP/sub-agents/plan mode/permission gates
- YOLO security model — no sandboxing (Zechner argues other agents' security is "mostly theater")
- Un-Googleable name, "shitty coding agent" branding alienates professional contexts
- Community is enthusiastic but small; oh-my-pi fork adds features Pi deliberately excludes

## OpenClaw

OpenClaw (Peter Steinberger) is the viral agent (180K+ stars) that runs Pi under the hood. Key innovations:
- **Gateway pattern** — channel-agnostic agent routing (WhatsApp/Telegram/Slack all go to same brain)
- **Identity-as-filesystem** — SOUL.md, MEMORY.md, etc. are Git-versionable plain files
- **A2UI protocol** — declarative agent-generated UI, no code injection
- **Tiered memory** — session transcripts → daily logs → MEMORY.md → QMD hybrid search
- **Selective skill injection** — only relevant skills loaded per turn (vs blind prompt stuffing)
- **Security concern:** "Faustian bargain" — root-like access + community skills with ~15% malicious rate

### NanoClaw

Lightweight alternative to OpenClaw by Gavriel Cohen (ex-Wix). ~3.9K LOC TypeScript, ~10K GitHub stars in 3 weeks. Key differentiator: OS-level container isolation (Apple Container / Docker) instead of app-level permission checks. Claude-only, WhatsApp-only by design — other integrations added via "skills" (Claude Code rewrites your fork). Novel contribution model: no plugins, no config files, just code changes mediated by AI. Genuinely improves blast radius on compromise but doesn't solve prompt injection or network exfiltration. → [Deep dive](../research/nanoclaw-deep-dive.md)

## Agent Landscape (Feb 2026)

A phase transition between Jan 12 – Feb 14, 2026: Anthropic launched Cowork + Agent Teams, OpenAI launched Codex macOS app with parallel agents, Apple opened Xcode to third-party agents via MCP, AWS upgraded Kiro with autonomous agent.

**Five major players, diverging strategies:**
- **Anthropic** — frontrunner. Claude Code + Cowork + Agent Teams. Best model-tool integration.
- **OpenAI** — catching up. Codex app, GPT-5.2-Codex model, parallel execution.
- **Google** — infrastructure play. Jules/Gemini Code Assist, massive context windows.
- **AWS** — enterprise full-stack. Kiro spec-driven development + autonomous agent.
- **Apple** — surprise kingmaker. Xcode 26.3 opened to Claude Agent + Codex via MCP.

**Tools are diverging into categories:** interactive CLI, multi-agent orchestration, autonomous background work. The winning move is using the right category for the right task, not picking one.

## Tool Comparisons

OpenCode vs Claude Code vs Kiro CLI: "the war is between the models, not the tools" holds broadly, but tools are adding model-independent differentiation (Agent Teams, autonomous agents, cross-session memory). Claude Code recommended as primary, but Kiro's autonomous agent is genuinely novel — dismiss was premature.

## Practitioner Evidence

The METR RCT (July 2025) found experienced developers 19% *slower* with AI tools while believing they were 20% faster — a 39-point perception gap. Mike Judge's replication: 21% slower, plus flat macro metrics (new apps, new games, new GitHub projects). Stack Overflow Dec 2025: first-ever decline in AI tool sentiment.

Counter-evidence: Anthropic reports 30-79% faster enterprise cycles. Rakuten compressed 24→5 day feature cycles. Opsera: seniors get 5× the productivity gains of juniors. Nobody has clean data. "We're all working from vibes" (Zechner).

## Context Engineering

Kiro CLI's context model: guidance (conventions) + instructions (task-specific) + context interfaces (auto-discovery). Steering files, custom agents, hooks, MCP servers, knowledge bases, skills, subagents, plan agent. See research for full feature reference.

## Nanoagent Ecosystem

"NanoAgent" is a namespace collision of 5+ unrelated repos sharing the "minimal agent" idea. Combined stars ~292, zero production deployments. The anti-LangChain rebellion — minimalism as philosophy.

**Worth watching:** ASSERT-KTH/nano-agent — Bitter Lesson applied to coding agents, RL on minimal agents. Unproven but intellectually interesting.

**Not worth using:** All of them. For production, use established tools (Pi, Claude Code, Aider).

## Deep Research

### Pi & OpenClaw
- [HN: Pi – A Minimal Terminal Coding Harness](../research/hn-pi-minimal-terminal-coding-harness.md) — harness problem empirics (hashline 10× gains), vendor API lockdown as platform re-aggregation, Prompt Expansion at tool boundary, recursive Naur's Nightmare (living software), LISP Curse at tool layer, Hidden Denominator made visible, Fixed-Point Workflow validated
- [Pi Practitioner Review](../research/pi-practitioner-review.md) — power user analysis (Ronacher, Januschka), provider abstraction, KV cache
- [Pi Blog Review](../research/pi-blog-review-conversation.md) — critical review of Ronacher's Pi blog post
- [Pi Terminal-Bench](../research/pi-terminal-bench.md) — why Pi isn't on the leaderboard (submitted but never added)
- [OpenClaw Analysis](../research/openclaw-analysis.md) — value proposition, security risks, competitive context
- [OpenClaw Innovations](../research/openclaw-innovations.md) — architecture deep dive (Gateway, A2UI, memory, heartbeat)
- [OpenClaw Real-World Uses](../research/openclaw-real-world-uses.md) — use cases from Reddit, blogs, X threads
- ["Bad Vibes From Pi" — Critical Blog Review](../research/thevinter-bad-vibes-from-pi.md) — detailed migration failure diary, ecosystem quality evidence, pi-guardrails regex/blocklist critique, vibecoded supply chain argument

### Landscape & Tool Comparisons
- [AI Coding Agents Feb 2026](../research/ai-coding-agents-feb-2026-deep-assessment.md) — state of the landscape: Anthropic, OpenAI, Google, AWS, Apple
- [OpenCode vs Claude Code vs Kiro](../research/critical-review-opencode-claude-code-kiro.md) — claim-by-claim tool comparison review
- [Context Engineering for Kiro CLI](../research/context-engineering-kiro-cli-v2.md) — full feature reference for Kiro's context model

### Agent Sandboxing & Security

- **[Agent Security Synthesis](../research/agent-security-synthesis.md)** — distillation of all security research: core problem, solution landscape, personal posture, what's unsolvable

**Landscape status (Jul 2026):** 25+ sandbox tools/approaches now exist (Gondolin, Matchlock, yolobox, bubblewrap-tui, cco, sandvault, construct-cli, agentbox, shellbox.dev, sandbox-run, claudebox, code-on-incus, agentic-devcontainer, Docker Sandboxes, etc.) — no convergence on a standard approach. Docker has confirmed MicroVM-backed sandboxes replacing DinD (`ejia`, Docker PM, in [HN thread](../research/hn-claude-code-sandboxing-2026.md)). Sean Heelan's [exploit generation research](https://sean.heelan.io/2026/01/18/on-the-coming-industrialisation-of-exploit-generation-with-llms/) demonstrates LLMs generating 40+ zero-day exploits at $30-50/chain — static sandbox defenses face an attacker that improves every model generation.

- [HN: Claude Code Sandboxing Approaches](../research/hn-claude-code-sandboxing-2026.md) — popular-level survey (351pts, 258 comments): approval fatigue as security failure, sandbox zoo, Vagrant sync-folder pitfalls, YOLO survivorship bias
- [Gondolin Agent Sandbox](../research/gondolin-agent-sandbox.md) — Armin Ronacher's QEMU micro-VM sandbox
- [HN: Matchlock Agent Sandbox](../research/hn-matchlock-agent-sandbox.md) — VM sandboxing, confused deputy, Claude Cowork exfiltration, Opus 4.6 red-teaming
- [Gondolin vs Matchlock](../research/gondolin-vs-matchlock.md) — security comparison across 7 attack classes
- [Matchlock Setup Guide](../research/matchlock-setup-guide.md) — practical configuration burden for Pi on macOS
- [Agent as Separate macOS User](../research/agent-separate-macos-user.md) — low-cost OS-level isolation, 80/20 alternative to VM sandboxing
- [Agent Isolation Friction: Self-Rebuttal](../research/agent-isolation-friction-rebuttal.md) — why "just run open" was wrong, tiered access model
- [Separate User: Pre-Commitment Analysis](../research/agent-separate-user-precommit-analysis.md) — what you get, pay, forgo, and what remains exposed
- [Agent Security: What People Actually Do](../research/agent-security-landscape-what-people-do.md) — interactive vs autonomous, LuLu + dedicated accounts pattern, tiered recommendations

### Multi-Agent Coordination
- [HN: Cord — Coordinating Agent Trees](../research/hn-cord-coordinating-agent-trees.md) — spawn/fork primitives, context flow debate, framework ephemerality thesis
- [HN: Cursor Browser Experiment](../research/hn-cursor-browser-experiment.md) — autonomous agents produce 3M LOC non-compiling browser, "from scratch" claim debunked, verification as missing primitive

### Harness Engineering
- [Harness Engineering Playbook — Distilled](../research/harness-engineering-playbook.md) — tactical tips from Ignorance.ai synthesis (OpenAI, Stripe, Steinberger, Hashimoto, Tane)
- [Harness Engineering — Critical Review](../research/harness-engineering-critical-review.md) — cross-checked against primary sources, macro data, our research corpus; survivorship bias, hidden denominator, source credibility issues

### Practitioner Tips & Productivity Evidence
- [Zechner & Steinberger Tips Review](../research/critical-review-v3-final.md) — corroborated, contested, and complicated
- [Steinberger Final Evaluation](../research/steipete-final-evaluation.md) — claims vs METR study, macro productivity data
- [HN: AI Productivity 10% Plateau](../research/hn-ai-productivity-10-percent-plateau.md) — DX 121K-dev survey, Amdahl's Law framing, composition fallacy, METR replication
- [HN: AI Productivity & Jobs in Europe](../research/hn-ai-productivity-jobs-europe.md) — BIS/EIB causal study, 4% gain masks big-data-not-LLMs, training 6x multiplier, shadow AI gap
- [HN: AI Made Coding More Enjoyable](../research/hn-ai-coding-enjoyable.md) — enjoyment inversely proportional to code-caring, LLM debt, review cost inflation, flow state destruction
- [HN: Beyond Agentic Coding](../research/hn-beyond-agentic-coding.md) — calm technology thesis, Amdahl's Law for dev workflows, review as bottleneck, trust reset problem
- [Amazon AI Culture Amplification](../research/amazon-ai-culture-amplification-assessment.md) — prediction audit: internal tooling lagging, self-undermining loop already active, talent drain dominant
- [Nanoagent Survey](../research/nanoagent-survey.md) — all 5 "nano" agent repos critically assessed
- [HN: Elixir/BEAM for AI Agents](../research/hn-elixir-agent-frameworks.md) — actor model vs agent model, "let it crash" semantic gap, durability problem, ecosystem lock-in

## Related

- [Insights](../insights.md) — durable structural insights (epistemic foundations, abstraction failure, productivity evidence, code ownership, security, economics)
- [Additional Insights](../additional_insights.md) — supplementary insights of narrower scope
- [Software Factory](software-factory.md) — autonomous production, verification layers, the "dark factory" thesis
