# Coding Agents

← [Index](../INDEX.md)

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

## Nanoagent Ecosystem

"NanoAgent" is a namespace collision of 5+ unrelated repos sharing the "minimal agent" idea. Combined stars ~292, zero production deployments. The anti-LangChain rebellion — minimalism as philosophy.

**Worth watching:** ASSERT-KTH/nano-agent — Bitter Lesson applied to coding agents, RL on minimal agents. Unproven but intellectually interesting.

**Not worth using:** All of them. For production, use established tools (Pi, Claude Code, Aider).

## Deep Research

- [Pi Practitioner Review](../research/pi-practitioner-review.md) — critical analysis from power users (Ronacher, Januschka), provider abstraction deep dive, KV cache analysis
- [OpenClaw Analysis](../research/openclaw-analysis.md) — value proposition, security risks, competitive context
- [OpenClaw Innovations](../research/openclaw-innovations.md) — architecture deep dive (Gateway, A2UI, memory tiers, heartbeat, Node Bridge)
- [Nanoagent Survey](../research/nanoagent-survey.md) — all 5 repos evaluated with critical assessment
