← [Coding Agents](../topics/coding-agents.md) · [Index](../README.md)

# Block Goose vs Pi (pi-mono): Deep Comparison

**Date:** February 2026
**Sources:** GitHub repos (block/goose, badlogic/pi-mono), official docs, Tembo 2026 CLI comparison, techbuddies.io Goose vs Claude Code analysis, Goose roadmap discussions (#3319, #3387), Mario Zechner's blog post, Brave search results (Feb 2026), Goose v1.25.0 release notes

---

## Executive Summary

Goose and Pi are both open-source, model-agnostic terminal coding agents that compete in the same space — but they embody **radically different philosophies** about what an agent should be. Goose is a **maximalist platform** backed by a major fintech (Block, formerly Square) with 5,000 internal users, an Electron desktop app, MCP-native architecture, and ambitious plans for sub-agents, recipes, and hosted apps. Pi is a **minimalist harness** built by one person (Mario Zechner, of libGDX fame) with ~14K stars, deliberately no MCP, no sub-agents, no plan mode, no permission gates — and an extension system powerful enough to build all of those yourself.

**The core tension:** Goose says "we built it for you." Pi says "build it yourself, or ask the agent to build it for you."

Both are legitimate answers. Which is right depends entirely on whether you're a platform consumer or a control maximizer.

---

## 1. Architecture

### Goose

| Aspect | Detail |
|--------|--------|
| **Language** | Rust (core), TypeScript (desktop/Electron) |
| **Binary size** | ~21 MB compiled binary |
| **Interfaces** | CLI + Electron desktop app |
| **Extension protocol** | MCP (Model Context Protocol) — external process per extension |
| **Built-in extensions** | Developer tools, web scraping, automation, memory, screen capture, "Top of Mind" (tom) |
| **Agent architecture** | Interface → Agent → Extensions. Multiple agents per interface possible. |
| **Session storage** | Per-session files, session resume/search |
| **Context management** | Auto-compaction at configurable threshold (default 80%), tool output summarization after 10+ calls, truncation fallback, manual compaction |
| **CLI providers** | Can wrap Claude Code, Codex, Cursor Agent, Gemini CLI as pass-through providers |

Goose's architecture is a **three-layer stack**: the interface (CLI or Electron), the agent (Rust core managing the interactive loop), and extensions (MCP servers providing tools). The agent manages an event loop: user prompt → LLM → tool call → execute via MCP → results back to LLM → repeat until done.

The Rust rewrite (from an earlier Python version) eliminated the Python dependency entirely — no virtualenv, no pip. Binary distribution. This is a genuine advantage for onboarding.

The **CLI provider** feature is unique and fascinating: Goose can literally shell out to Claude Code, Codex, Cursor Agent, or Gemini CLI, parse their output, and present it through Goose's own session management. You get Goose's recipes, persistence, and workflow features while using another agent's subscription. This is architecturally bonkers — wrapping a competing agent as a provider — but practically useful for people who already pay for Claude Max or ChatGPT Pro.

### Pi

| Aspect | Detail |
|--------|--------|
| **Language** | TypeScript (entire stack) |
| **Install** | `npm install -g` (~single command) |
| **Interfaces** | CLI only (interactive, print, JSON, RPC, SDK) |
| **Extension protocol** | Native TypeScript modules loaded via jiti (no separate process) |
| **Built-in tools** | 4: read, write, edit, bash (optionally grep, find, ls) |
| **Agent architecture** | Monorepo: pi-ai (LLM API) → pi-agent (loop) → pi-tui (UI) → pi-coding-agent (CLI) |
| **Session storage** | JSONL with tree structure (branching in single file) |
| **Context management** | Auto-compaction (proactive + overflow recovery), customizable via extensions |
| **Modes** | Interactive, print (`-p`), JSON (`--mode json`), RPC (`--mode rpc`), SDK |

Pi's architecture is a **layered monorepo** where each package is independently useful:
- `pi-ai`: Unified LLM API across 15+ providers with streaming, tool calling, cost tracking
- `pi-agent`: Minimal agent loop (tool execution, validation, events)
- `pi-tui`: Custom terminal UI framework with differential rendering
- `pi-coding-agent`: The actual CLI wiring it all together

Extensions run **in-process** as TypeScript loaded by jiti — no compilation step, no separate process, no IPC overhead. This means extensions can intercept every event (tool calls, messages, compaction, tree navigation, model switching), modify the system prompt on the fly, replace built-in tools, render custom TUI components, and even replace the editor. The extension surface area is absurdly large.

### Architectural Verdict

Goose's architecture is **enterprise-oriented**: Rust for performance and portability, MCP for standardized integration, Electron for non-terminal users, CLI providers for subscription leverage. It's designed to be a **platform** that organizations can deploy, configure, and extend through standard protocols.

Pi's architecture is **hacker-oriented**: TypeScript for hackability, in-process extensions for zero-overhead customization, JSONL tree sessions for post-processing, five programmatic modes for embedding anywhere. It's designed to be a **toolkit** that power users can reshape completely.

---

## 2. Extension Systems (The Core Differentiator)

This is where the philosophies diverge most sharply.

### Goose: MCP-Native

Goose extensions are MCP servers — separate processes communicating via stdio or SSE. Three categories:

1. **Built-in extensions**: Compiled into the Rust binary (developer tools, memory, etc.)
2. **Platform extensions**: Rust code with access to session state and provider
3. **External extensions**: Any MCP server (community or custom)

**Advantages of MCP:**
- Language-agnostic (write extensions in Python, TypeScript, Rust, Go, anything)
- Process isolation (extension crash ≠ agent crash)
- Ecosystem leverage (thousands of existing MCP servers)
- Standard protocol — portable across agents

**Disadvantages:**
- IPC overhead per tool call
- No event interception (can't block a tool call, modify compaction, or inject context pre-turn)
- Extensions can't modify the agent's UI, session tree, system prompt, or behavior
- Extension lifecycle management is more complex (startup, shutdown, error handling)
- Configuration is YAML/JSON with env var plumbing — not trivially composable

Goose also has **recipes** — reusable workflow packages that bundle extensions, prompts, and settings. Recipes can specify models, include sub-recipes, and be shared via URLs. This is closer to a deployment/configuration system than an extension system.

### Pi: In-Process TypeScript

Pi extensions are TypeScript modules that receive an `ExtensionAPI` handle. They run in the same process with full access to:

- **22+ event hooks**: session lifecycle, agent turns, tool calls (can block), tool results (can modify), compaction (can replace), tree navigation, model selection, user input
- **Tool registration**: custom tools with TypeScript schemas, streaming updates, custom TUI rendering
- **Command registration**: slash commands with argument completion
- **Shortcut registration**: keyboard shortcuts
- **UI control**: custom editors (vim mode, etc.), widgets, status lines, footers, overlays, notifications, dialogs with timeouts
- **Session control**: fork, navigate tree, compact, new session, inject messages
- **State management**: persistent entries that survive restarts, access to full session tree
- **Provider registration**: add custom LLM providers with OAuth support

**Advantages of in-process:**
- Zero overhead — extensions are function calls
- Full event interception — can block destructive tool calls, modify any behavior
- UI integration — extensions can render TUI components, replace the editor, add overlays
- Composability — extensions share the TypeScript ecosystem, import from each other
- The 50+ example extensions cover permission gates, git checkpointing, plan mode, sub-agents, SSH execution, sandboxing, custom compaction, Doom (yes)

**Disadvantages:**
- TypeScript only (though extensions can shell out to anything)
- No process isolation (buggy extension can crash the agent)
- No standard protocol — extensions are pi-specific
- Can't use the MCP ecosystem directly (though an extension can add MCP support)

### Extension Verdict

If you want to **consume** an ecosystem of pre-built integrations (Slack, Jira, GitHub, databases), Goose's MCP approach gives you access to thousands of servers with zero custom code.

If you want to **control** the agent's behavior at every level — intercept tool calls, customize compaction, modify the system prompt per-turn, build plan mode, add permission gates, render custom UI — Pi's in-process model is dramatically more powerful. It's not even close. The depth of control Pi offers is closer to "fork the agent" level without actually forking.

The meta-insight: Pi's "no MCP" stance is not anti-extension. It's anti-IPC. Zechner's argument is that CLI tools with READMEs (skills) + bash give you everything MCP does without the protocol overhead, and that the LLM is smart enough to invoke tools via bash. Meanwhile, an extension can always add MCP support if you truly need it.

---

## 3. Session Management

### Goose
- Sessions with resume/search
- Auto-compaction at configurable threshold
- Tool output summarization (background, configurable cutoff)
- Context strategies: summarization, truncation, clear, or prompt user
- Manual compaction available
- Session history visible in desktop app
- No session branching (linear history)

### Pi
- **Tree-structured sessions** in single JSONL file (each entry has `id` + `parentId`)
- `/tree` navigator: search, filter (no-tools, user-only, labeled-only), bookmark entries
- `/fork`: create new session from any branch point
- Branching: try something, rewind, continue from earlier point — all in one file
- Auto-compaction: proactive + overflow recovery, fully customizable via extensions
- `/compact` with optional custom instructions
- `/share` exports to GitHub gist with rendered HTML
- `/export` to HTML file

### Session Verdict

Pi's session tree is a genuine innovation that no other CLI agent has replicated. The ability to branch, rewind, bookmark, and navigate a conversation tree — while keeping everything in a single file — is qualitatively different from linear session history. For iterative exploration (try approach A, rewind, try approach B, compare), it's invaluable.

Goose has more sophisticated automatic context management (tool output summarization as a separate concern from full compaction, configurable strategies per environment), but lacks the structural insight of tree-based sessions.

---

## 4. Model Support & Provider Strategy

### Goose
- Any LLM via API (Anthropic, OpenAI, Google, Groq, OpenRouter, Ollama, etc.)
- **Multi-model configuration** — use different models for different tasks
- **CLI providers** — wrap Claude Code, Codex, Cursor Agent, Gemini CLI subscriptions
- Model switching mid-session
- Custom provider support via configuration
- Dynamic model selection planned for sub-agents (per-task model routing)

### Pi
- 15+ built-in providers (Anthropic, OpenAI, Google, Azure, Bedrock, Mistral, Groq, Cerebras, xAI, HuggingFace, Kimi, MiniMax, OpenRouter, Vercel, ZAI, OpenCode Zen, Ollama)
- OAuth login support for subscriptions (Claude Pro/Max, ChatGPT Plus/Pro, Copilot, Gemini CLI, Antigravity)
- Mid-session model switching via `/model` or `Ctrl+L`
- Model cycling via `Ctrl+P` (configurable scoped model list)
- Custom providers via `models.json` or extensions (with OAuth support)
- `pi-ai` package provides unified API across all four major LLM API styles

### Provider Verdict

Roughly equivalent breadth. Pi has slightly broader first-party provider coverage and offers OAuth subscription access (use your Claude Max subscription directly). Goose's CLI provider trick — wrapping competing agents as providers — is unique and clever. Both support mid-session model switching.

The real difference: Pi's `pi-ai` package is a standalone, well-documented unified LLM API that handles the four incompatible API styles (Anthropic Messages, OpenAI Completions, OpenAI Responses, Google GenerativeLanguage) with seamless cross-provider context handoff. This is useful beyond the agent itself — it's a library you can build on.

---

## 5. Community, Governance & Adoption

### Goose
- **~29,500 GitHub stars** (as of Jan 2026), growing ~4,400/month
- **Apache 2.0 license**
- Backed by **Block (formerly Square)** — dedicated team, 5,000 internal users
- Active Discord, YouTube, LinkedIn, X, Bluesky, Nostr
- Published roadmap with ratings on delivery
- Formal governance: GOVERNANCE.md, CONTRIBUTING.md
- **Custom distributions** — organizations can fork with pre-configured providers, extensions, branding
- Monthly releases (v1.25.0 as of Feb 2026, 100+ total releases)
- Active community PRs but historically had PR backlog issues (300 open issues, 100+ unprocessed PRs per July 2025 roadmap)

### Pi
- **~14,200 GitHub stars**
- **MIT license**
- Built primarily by **Mario Zechner** (badlogic) — known for libGDX game framework
- Active Discord community (smaller but enthusiastic)
- Opinionated solo maintainer ("OSS vacation" Feb 10-23, 2026)
- **Pi packages** — share extensions, skills, prompts, themes via npm or git
- ~2,968 commits, rapid development pace
- "oh-my-pi" fork exists for features Pi deliberately excludes
- OpenClaw (Steinberger) runs Pi under the hood — 180K+ stars indirect amplification

### Community Verdict

Goose has corporate backing, larger absolute community, and more structured governance. Block's 5,000 internal users provide real-world testing at scale. The custom distribution feature makes it viable for enterprise deployment.

Pi has a smaller but more technical community. The solo maintainer model means faster, more opinionated decisions — but also bus-factor risk. The indirect amplification through OpenClaw (which uses Pi's SDK) significantly extends Pi's real-world reach beyond its star count.

---

## 6. UX & Interface Design

### Goose
- **Desktop app** (Electron) — GUI with settings, extension management, recipe editing, token usage visualization
- **CLI** — terminal interface with session management
- Deep-link protocol for extension installation from web
- Settings via GUI or YAML config
- bat-based syntax highlighting
- Recipes shareable via URLs

### Pi
- **Terminal-only** — but with a custom TUI framework (pi-tui) providing:
  - Differential rendering (flicker-free)
  - Inline editor with `@` file references, tab completion, image paste
  - Message queue: steering messages (interrupt) and follow-ups (wait)
  - `/tree` visual navigator with search and filters
  - Thinking level indicator (editor border color)
  - Footer with working directory, session, token usage, cost, model
  - Extensions can add widgets, status lines, overlays, custom editors, even games
- Four programmatic modes beyond interactive: print, JSON, RPC, SDK
- HTML export and GitHub gist sharing

### UX Verdict

Goose wins for **accessibility** — the Electron desktop app lowers the barrier for non-terminal users significantly. Recipe sharing via URLs is consumer-friendly.

Pi wins for **terminal power users** — the custom TUI is more sophisticated than any other CLI agent's interface. Message queuing (steering vs follow-up), session tree navigation, thinking level cycling, model cycling via keyboard shortcuts — these are workflow accelerators for people who live in the terminal. The five output modes (interactive, print, JSON, RPC, SDK) make Pi dramatically more embeddable.

---

## 7. Context Engineering

### Goose
- System prompt + extension tools auto-discovered
- `gooserc` and profile configurations
- `.goosehints` files for project context
- Recipes bundle prompts + extensions + settings
- Tool output summarization (separate from compaction)
- Customizable compaction prompt template
- Environment variables for tuning (GOOSE_AUTO_COMPACT_THRESHOLD, GOOSE_TOOL_CALL_CUTOFF)

### Pi
- **Sub-1,000 token system prompt** (minimal, leaves maximum context for work)
- AGENTS.md / CLAUDE.md files loaded from global, parent dirs, and cwd (composable)
- SYSTEM.md / APPEND_SYSTEM.md to replace or augment system prompt per-project
- Skills: on-demand capability packages (progressive disclosure — pay token cost only when needed)
- Prompt templates: reusable markdown prompts with variables
- Extensions can:
  - Inject messages before each turn (`before_agent_start`)
  - Modify the system prompt per-turn
  - Filter/modify the message history (`context` event)
  - Implement custom compaction logic
  - Build RAG, long-term memory, or any context strategy

### Context Engineering Verdict

Pi is measurably better for context engineering. The minimal system prompt preserves more context window for actual work. Skills provide progressive disclosure (load instructions only when needed). Extensions provide unlimited customization of what enters the context window and when.

Goose has reasonable defaults (auto-compaction, tool output summarization) but far less control over what's happening behind the scenes. The system prompt and extension tool descriptions consume more baseline tokens.

This matters because **context is the primary bottleneck** in coding agent performance. Every token spent on system prompt overhead is a token not available for your code, conversation history, or reasoning.

---

## 8. Security Model

### Goose
- **macOS sandboxing** for desktop app (v1.25.0)
- Process-isolated extensions via MCP
- SLSA build provenance attestations
- No built-in permission gates in CLI
- Extension ecosystem has no vetting
- Can set `AGENT=goose` env var for cross-tool compatibility

### Pi
- **YOLO by default** — no permission prompts, no sandboxing
- Zechner's argument: other agents' security is "mostly theater" — permission popups train users to click "yes"
- Extensions can build permission gates (example: `permission-gate.ts`, `protected-paths.ts`)
- Extensions can build sandboxed execution (example: `sandbox/`)
- Skills marked with security warning — "skills can instruct the model to perform any action"
- Pi packages run with full system access

### Security Verdict

Neither is production-secure out of the box. Goose's macOS sandboxing for the desktop app is the only real security measure either tool ships. Goose's MCP process isolation provides some extension sandboxing by accident (crashed extension doesn't crash agent).

Pi's "build your own security" approach is honest but dangerous for casual users. The pre-built permission gate examples are good starting points but require deliberate installation.

For real security, both need to run in containers or VMs. This is true of all coding agents in Feb 2026.

---

## 9. Unique Features (Things Only One Has)

### Only Goose
- **Desktop app** (Electron GUI)
- **CLI providers** — wrap Claude Code / Codex / Cursor / Gemini CLI as providers
- **Recipes** — shareable workflow packages with URLs, sub-recipes, per-recipe model selection
- **Custom distributions** — white-label Goose with pre-configured everything
- **MCP ecosystem** — access to thousands of community MCP servers
- **macOS sandboxing**
- **Built-in extensions** for web scraping, memory, automation, screen capture
- **Multi-agent roadmap** — sub-agent orchestration, Goose Apps hosting

### Only Pi
- **Session trees** — branch, rewind, navigate conversation history as a tree
- **In-process extensions** with 22+ event hooks (block tool calls, modify compaction, replace editor, render overlays)
- **Message queuing** — steering messages (interrupt agent) vs follow-ups (wait for idle)
- **5 output modes** — interactive, print, JSON, RPC, SDK
- **Standalone SDK** — embed pi as a library in your own apps
- **Custom TUI rendering** — extensions can render components, replace the editor, add overlays
- **Sub-1,000 token system prompt** — minimal context overhead
- **Thinking level control** — per-message reasoning budget (off → minimal → low → medium → high → xhigh)
- **`pi-ai`** as standalone unified LLM library
- **Doom** (yes, Doom runs in a pi overlay)

---

## 10. Who Should Use What

### Use Goose if:
- You want a **desktop app** or your team includes non-terminal users
- You need **MCP integrations** (Slack, Jira, databases, etc.) out of the box
- You're an **organization** wanting custom-branded agent distributions
- You want to leverage existing **Claude Code / Codex / Gemini CLI subscriptions** through one interface
- You value **corporate backing** and structured governance
- You want **recipes** for repeatable team workflows
- You prefer consuming a **platform** over building one

### Use Pi if:
- You're a **terminal power user** who wants maximum control
- You care deeply about **context engineering** (minimal system prompt, progressive skills, context event hooks)
- You want **session branching** for iterative exploration
- You need to **embed** the agent (SDK, RPC, JSON modes)
- You want to **build** your own agent experience via extensions (plan mode, sub-agents, permission gates, custom compaction)
- You value **transparency** — you want to see and control every token that enters the context window
- You're building **on top of** an agent, not just using one (OpenClaw uses Pi's SDK)
- You find the "if I don't need it, it won't be built" philosophy liberating rather than limiting

---

## 11. Projections & Trends

**Goose** is executing an enterprise platform strategy. The roadmap shows sub-agent orchestration, dynamic model selection, Goose Apps (hosting vibe-coded apps in Electron), async container agents, and self-improving agents. If Block stays committed, Goose could become the Kubernetes of coding agents — a platform that enterprises customize and deploy at scale. The custom distribution feature is the tell: they're building for organizational adoption, not just individual developers.

**Risk:** Feature creep. The roadmap is enormous. Goose already fell behind on MCP compliance (March standard, not June 2025). The PR backlog suggests maintaining quality at scale is hard. The Electron app adds significant maintenance surface.

**Pi** is executing a minimalist toolkit strategy. By keeping the core tiny and making everything extensible, Pi can adapt to whatever the agent landscape throws at it. The OpenClaw integration proves the SDK model works for real products. The "ask pi to build it for you" philosophy becomes more powerful as models improve — today's user builds extensions by asking the agent; tomorrow's agent might self-configure entirely.

**Risk:** Solo maintainer. If Zechner loses interest or gets hired by a lab, Pi's development velocity drops to community contributions. The "build it yourself" philosophy limits adoption to high-skill users. The branding ("shitty coding agent") is a genuine barrier for professional contexts.

**Convergence:** Both are moving toward the same tools (any model, any provider, session management, extensibility). The real question is whether the future favors **platforms** (Goose) or **toolkits** (Pi). History suggests platforms win for mass adoption but toolkits win for power users. Both can coexist.

---

## 12. Verdict

These are not interchangeable tools competing for the same user. They're **different answers to different questions:**

- **Goose** answers: "How do we build an open-source agent platform that organizations can adopt, customize, and scale?"
- **Pi** answers: "How do we build a minimal agent harness that gives one developer maximum control over every aspect of the interaction?"

For this knowledge base's user profile (experienced dev, control maximizer, terminal-native, context engineering obsessed): **Pi remains the right choice.** The session tree, context control, in-process extensions, and minimal system prompt are qualitative advantages that Goose's feature breadth doesn't offset.

But Goose is the tool I'd recommend to a **team lead** evaluating open-source coding agents for organizational adoption. Desktop app + MCP ecosystem + custom distributions + recipes = a deployable platform. Pi is a power tool; Goose is a product.

Neither is a Claude Code killer. Claude Code has an informational advantage — Anthropic knows their models' behaviors deeply and tunes Claude Code's system prompt and tool definitions to exploit them. But the "co-optimization moat" is overstated: the model's tool-use capabilities are general, third-party agents achieve comparable performance with the same models, and Anthropic-defined tool interfaces are public. See [detailed audit](anthropic-model-tool-co-optimization-audit.md). Goose and Pi both accept the release-cadence trade-off in exchange for model freedom.
