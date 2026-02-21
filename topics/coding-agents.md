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
- [Pi Practitioner Review](../research/pi-practitioner-review.md) — power user analysis (Ronacher, Januschka), provider abstraction, KV cache
- [Pi Blog Review](../research/pi-blog-review-conversation.md) — critical review of Ronacher's Pi blog post
- [Pi Terminal-Bench](../research/pi-terminal-bench.md) — why Pi isn't on the leaderboard (submitted but never added)
- [OpenClaw Analysis](../research/openclaw-analysis.md) — value proposition, security risks, competitive context
- [OpenClaw Innovations](../research/openclaw-innovations.md) — architecture deep dive (Gateway, A2UI, memory, heartbeat)
- [OpenClaw Real-World Uses](../research/openclaw-real-world-uses.md) — use cases from Reddit, blogs, X threads

### Landscape & Tool Comparisons
- [AI Coding Agents Feb 2026](../research/ai-coding-agents-feb-2026-deep-assessment.md) — state of the landscape: Anthropic, OpenAI, Google, AWS, Apple
- [OpenCode vs Claude Code vs Kiro](../research/critical-review-opencode-claude-code-kiro.md) — claim-by-claim tool comparison review
- [Context Engineering for Kiro CLI](../research/context-engineering-kiro-cli-v2.md) — full feature reference for Kiro's context model

### Multi-Agent Coordination
- [HN: Cord — Coordinating Agent Trees](../research/hn-cord-coordinating-agent-trees.md) — spawn/fork primitives, context flow debate, framework ephemerality thesis

### Practitioner Tips & Productivity Evidence
- [Zechner & Steinberger Tips Review](../research/critical-review-v3-final.md) — corroborated, contested, and complicated
- [Steinberger Final Evaluation](../research/steipete-final-evaluation.md) — claims vs METR study, macro productivity data
- [HN: AI Productivity 10% Plateau](../research/hn-ai-productivity-10-percent-plateau.md) — DX 121K-dev survey, Amdahl's Law framing, composition fallacy, METR replication
- [Nanoagent Survey](../research/nanoagent-survey.md) — all 5 "nano" agent repos critically assessed

## Related

- [Software Factory](software-factory.md) — autonomous production, verification layers, the "dark factory" thesis
