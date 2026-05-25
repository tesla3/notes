← [Index](../README.md)

# OpenClaw — Design & Architecture

Research into the [openclaw repo](../openclaw), a personal AI assistant platform. ~3,200 TypeScript source files, ~353k non-test LOC. Monorepo, pnpm workspace.

## What It Is

A **self-hosted, single-user AI assistant** that connects to messaging channels you already use (WhatsApp, Telegram, Slack, Discord, Signal, iMessage, Google Chat, Microsoft Teams, Matrix, etc.) and runs tools on your behalf. Not a chatbot SaaS — runs on your devices, under your control.

Built by Peter Steinberger (PSPDFKit founder) and community. Mascot is a lobster named Molty. MIT license.

## High-Level Architecture

```
Messaging Channels (WhatsApp/Telegram/Slack/Discord/Signal/iMessage/Teams/Matrix/WebChat/...)
                │
                ▼
┌────────────────────────────────────┐
│          Gateway (WS + HTTP)       │  ← Single control plane
│       ws://127.0.0.1:18789        │
│                                    │
│  ┌──────────┐  ┌───────────────┐  │
│  │ Sessions  │  │ Channel Mgr   │  │
│  │ & Routing │  │ (per-channel  │  │
│  │           │  │  adapters)    │  │
│  └─────┬────┘  └───────────────┘  │
│        │                           │
│  ┌─────▼────────────────────────┐ │
│  │  Pi Agent Runtime (embedded) │ │  ← LLM orchestration (pi-agent-core)
│  │  • Tool execution            │ │
│  │  • Session management        │ │
│  │  • Streaming / block chunking│ │
│  └──────────────────────────────┘ │
│                                    │
│  ┌────────┐ ┌────────┐ ┌───────┐ │
│  │Plugins │ │ Cron   │ │ Hooks │ │
│  │Registry│ │Service │ │Engine │ │
│  └────────┘ └────────┘ └───────┘ │
└──────────────┬─────────────────────┘
               │
     ┌─────────┼─────────────┐
     ▼         ▼             ▼
  CLI      macOS App     iOS/Android
  (TUI)   (menu bar)     Nodes
```

## Core Subsystems

### 1. Gateway (`src/gateway/`)

The **heart** of the system. A WebSocket + HTTP server (Express) that acts as the single control plane. Everything connects to it.

- **`server.impl.ts`** — main startup: loads config, boots plugins, starts channels, starts cron, wires WS handlers, starts browser control, canvas host, tailscale exposure, health monitoring.
- **Protocol** (`src/gateway/protocol/`) — JSON-RPC-style request/response/event frames over WebSocket. Validated via AJV + TypeBox schemas. ~40+ RPC methods covering: sessions, agents, config, channels, nodes, cron, skills, exec approvals, device pairing, wizard, etc.
- **Server methods** (`server-methods.ts`, `server-methods/`) — handlers for each WS RPC method.
- **Health, presence, maintenance** — health snapshot caching, presence versioning, periodic cleanup timers.
- **Auth** — rate-limited auth, token-based, optional Tailscale identity headers, password mode for Funnel.

### 2. Channels (`src/channels/`, `src/whatsapp/`, `src/telegram/`, `src/discord/`, `src/slack/`, `src/signal/`, `src/imessage/`, `src/web/`)

Each messaging platform has its own adapter. Core channels live in `src/`, extension channels in `extensions/`.

**Core channels:**
- **WhatsApp** — via Baileys (unofficial WA Web API). QR pairing, credential storage.
- **Telegram** — via grammY. Bot token, webhooks or long-polling.
- **Discord** — via discord.js/Carbon. Bot token, slash commands, guild routing.
- **Slack** — via Bolt. Bot + app tokens, Socket Mode.
- **Signal** — via signal-cli.
- **iMessage** — legacy macOS-only + BlueBubbles (recommended, server-based).
- **Google Chat** — via Chat API.
- **WebChat** — served directly from Gateway HTTP.

**Extension channels** (`extensions/`):
- Microsoft Teams, Matrix, Zalo, Zalo Personal, IRC, Nostr, Twitch, Line, Lark/Feishu, Mattermost, Nextcloud Talk, Tlon

**Shared channel infrastructure** (`src/channels/`):
- `registry.ts` — channel plugin discovery
- `allowlists/` — DM pairing, sender allowlisting
- `mention-gating.ts` — group mention filtering
- `command-gating.ts` — slash command routing per channel
- `typing.ts` — typing indicator management
- `dock.ts`, `session.ts` — session binding

### 3. Agent Runtime (`src/agents/`)

The AI agent engine. Wraps Mario Zechner's **pi-agent-core** / **pi-ai** / **pi-coding-agent** libraries as an embedded runtime inside the Gateway process.

Key components:
- **`pi-embedded-runner.ts`** — core runner. Orchestrates: system prompt construction, session history loading, auth profile rotation, model failover, tool binding, sandboxing, streaming subscriptions.
- **`pi-embedded-subscribe.ts`** — subscribes to the pi agent's streaming output and translates it into channel-deliverable chunks (block replies, code spans, markdown fencing).
- **`pi-tools.ts`** — tool definitions (bash, read, write, edit, browser, canvas, nodes, cron, sessions_*, channel tools). Policy-gated.
- **`bash-tools.ts`** — PTY-based bash execution with process registry, send-keys, background process supervision.
- **Model catalog** (`model-catalog.ts`) — discovers available models across providers.
- **Auth profiles** (`auth-profiles/`) — manages multiple API key / OAuth credential sets with rotation, cooldown, failover.
- **Skills** (`skills/`, `skills-install.ts`) — bundled, managed (ClawHub), and workspace skills. Skills are markdown files (`SKILL.md`) injected into agent context.
- **Subagents** (`subagent-*.ts`) — agent-to-agent coordination via `sessions_spawn`, `sessions_send`, announce queues, depth limits.
- **Sandbox** (`sandbox*.ts`) — Docker-based sandboxing for non-main sessions (security boundary).
- **Compaction** (`compaction.ts`) — session context compaction (summarization) when context windows fill.

### 4. Auto-Reply Pipeline (`src/auto-reply/`)

The **inbound message processing pipeline**. When a message arrives from any channel:

1. **Inbound** — debounce, media staging, group activation check
2. **Command detection** — `/status`, `/reset`, `/think`, `/model`, etc.
3. **Dispatch** — routes to the correct agent session
4. **Reply** — runs the agent, streams chunks back, handles block streaming, typing indicators, media notes
5. **Envelope** — wraps reply for channel-specific delivery (chunking, formatting)

### 5. Routing (`src/routing/`)

Maps inbound messages to sessions:
- **Session key** derivation — `main` for direct chats, per-group isolation, per-channel routing
- **Multi-agent routing** — routes channels/accounts/peers to isolated agents with separate workspaces
- **Bindings** — explicit route bindings configuration

### 6. Configuration (`src/config/`)

JSON5 config at `~/.openclaw/openclaw.json` with:
- **TypeBox schema** (`schema.ts`) — strongly typed, validated configuration
- **Zod schemas** (`zod-schema*.ts`) — parallel validation layer
- **Type definitions** — ~30+ `types.*.ts` files covering every subsystem
- **Legacy migration** — automatic migration from old config formats
- **Env substitution** — `${ENV_VAR}` expansion in config values
- **Runtime overrides** — CLI flags and env vars can override config
- **Hot reload** — config changes detected and applied without restart

### 7. Plugin System (`src/plugins/`)

- **Plugin SDK** (`src/plugin-sdk/`) — public API for extensions. Exports via `openclaw/plugin-sdk`.
- **Plugin registry** — discovery, loading (via jiti), lifecycle management
- **Hook system** (`hooks.ts`) — phase hooks: before-agent-start, after-tool-call, compaction, LLM, message, session, gateway lifecycle
- **HTTP routes** — plugins can register HTTP endpoints on the gateway
- **Slots** — named extension points (e.g., memory plugin slot — only one active at a time)

### 8. Browser Control (`src/browser/`)

Full Chromium/Chrome control via Playwright + CDP:
- Dedicated browser instance management
- Snapshot/action model for agent interaction
- Profile management (cookies, storage state)
- Bridge server for extension relay
- Control UI auth integration

### 9. Canvas Host (`src/canvas-host/`)

**A2UI** (Agent-to-UI) — agent-driven visual workspace:
- Push/reset HTML/JS content
- Eval JavaScript in canvas context
- Snapshot canvas state
- Served on macOS/iOS/Android companion apps

### 10. Companion Apps (`apps/`)

- **macOS** (`apps/macos/`) — Swift, menu bar app. Voice Wake, PTT, Talk Mode overlay, WebChat, gateway health control.
- **iOS** (`apps/ios/`) — Swift. Canvas, Voice Wake, Talk Mode, camera, screen recording, Bonjour pairing.
- **Android** (`apps/android/`) — Kotlin/Gradle. Canvas, Talk Mode, camera, screen recording, optional SMS.
- **Shared** (`apps/shared/`) — OpenClawKit, shared Swift code.

Protocol bridging: macOS/iOS/Android apps connect to Gateway via WS and advertise capabilities via `node.list`/`node.describe`. Gateway routes tool calls to nodes via `node.invoke`.

### 11. Web UI (`ui/`)

- **Control UI** — served from Gateway HTTP, Lit-based web components
- **WebChat** — full chat interface in the browser
- Built with Vite, bundled into Gateway dist

## Key Design Decisions

### Single-process, single-user architecture
Everything runs in one Node.js process. No microservices. The Gateway IS the product — it's the process that holds state, runs the agent, and connects to channels. This is deliberate: simplicity for a personal assistant.

### Embedded agent runtime (not RPC)
The Pi agent runs **inside** the Gateway process, not as a separate service. This avoids serialization overhead and simplifies state management. The agent subscribes to streaming events and emits block-chunked replies directly.

### Channel-agnostic routing
All inbound messages go through the same auto-reply pipeline regardless of source channel. Session keys derived from channel + sender + context. This means the same conversation can span channels.

### Security model: trust gradient
- **Main session** (your 1:1 chat): full host access, tools run directly.
- **Non-main sessions** (groups, other users): optionally sandboxed in per-session Docker containers.
- **DM pairing**: unknown senders get a pairing code challenge before the bot engages.

### Extension-first for new channels
New messaging channels should be added as extensions (`extensions/`), not core. 36+ extension packages already. Each is a workspace package with its own `package.json`.

### Skills over hardcoded capabilities
Agent capabilities are injected via markdown skill files (`SKILL.md`), not hardcoded. Skills can be bundled (in repo), managed (from ClawHub registry), or workspace-local.

## Data Flow: Message In → Reply Out

```
1. Channel adapter receives message (e.g., WhatsApp Baileys callback)
2. Channel adapter normalizes → inbound event
3. Routing: derive session key (channel + sender + group context)
4. Auto-reply pipeline:
   a. Command detection (/status, /reset, /think, etc.)
   b. If not command → dispatch to agent
   c. Agent runner:
      - Load session history
      - Build system prompt (identity + AGENTS.md + SOUL.md + skills + tools)
      - Call LLM (with auth profile rotation + model failover)
      - Stream response, execute tool calls (bash, browser, read, write, etc.)
      - Emit block-chunked reply events
   d. Reply dispatcher:
      - Format for target channel
      - Chunk long messages
      - Send typing indicators
      - Deliver via channel adapter
5. Session state persisted to disk (~/.openclaw/agents/<id>/sessions/*.jsonl)
```

## Tech Stack

- **Runtime**: Node.js ≥22, TypeScript ESM
- **Build**: tsdown (rolldown-based), Vite (UI)
- **Test**: Vitest, V8 coverage, extensive e2e suite
- **Lint/Format**: Oxlint, Oxfmt
- **Schema validation**: TypeBox + AJV (protocol), Zod (config)
- **Agents**: pi-agent-core / pi-ai / pi-coding-agent (Mario Zechner's framework)
- **LLM providers**: Anthropic (recommended), OpenAI, Google, Bedrock, Ollama, many more via auth profiles
- **Channel SDKs**: Baileys (WA), grammY (Telegram), discord.js/Carbon (Discord), Bolt (Slack), Playwright (browser)
- **Native apps**: Swift (macOS/iOS), Kotlin (Android)
- **Packaging**: npm (global install), Docker, Nix

## Scale & Complexity

- **3,218** TypeScript source files
- **~353k** non-test lines of code
- **~388k** total lines (including tests)
- **36+** extension packages
- **3** native companion apps (macOS, iOS, Android)
- **14+** messaging channel integrations
- **~40+** WebSocket RPC methods
- Configuration schema with **30+** typed subsection modules

## Verdict

OpenClaw is an impressively ambitious project — essentially a personal operating system for AI interaction. The architecture is pragmatic: single-process, embedded agent, channel-agnostic pipeline. The extension system is well-designed (new channels as workspace packages, skills as markdown files).

The main risks are complexity sprawl (3,200 files is a lot for what's essentially one developer's personal assistant) and the single-process model limiting scalability if it ever needs to serve more than one user. But for its stated goal — a personal, single-user assistant — the design is sound and the feature set is remarkable.
