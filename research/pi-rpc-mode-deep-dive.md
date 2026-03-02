← [Index](../README.md)

# Pi RPC Mode — Deep Dive & Critical Review

**Date:** 2026-03-01 (revised same day after self-review and internet research)
**Source:** pi-mono repo (`packages/coding-agent/src/modes/rpc/`), docs (`docs/rpc.md`, `docs/sdk.md`), consumer packages (`mom`, `web-ui`), tests, examples. External: ACP spec, A2A spec, Cline CLI 2.0, Zed ACP integrations, Kiro CLI.

## What Is RPC Mode?

Pi's RPC mode is a **headless JSON-lines protocol over stdin/stdout** for controlling the coding agent without a TUI. You spawn `pi --mode rpc` as a subprocess and exchange newline-delimited JSON:

- **Commands** → stdin (e.g., `{"type": "prompt", "message": "Hello"}`)
- **Responses** → stdout (correlated by optional `id` field)
- **Events** → stdout (streaming deltas, tool execution, lifecycle)

It's one of three run modes alongside interactive (TUI) and print (single-shot). All three share the same `AgentSession` core — RPC just wires it to stdin/stdout instead of a terminal UI.

## Architecture

### Three-Layer Stack

```
┌─────────────────────────────────────────────┐
│  Run Mode (rpc-mode.ts / interactive / print)│  ← UI layer
├─────────────────────────────────────────────┤
│  AgentSession (agent-session.ts)            │  ← Session management, compaction, extensions
├─────────────────────────────────────────────┤
│  Agent (pi-agent-core)                      │  ← Core LLM loop, tool execution
└─────────────────────────────────────────────┘
```

RPC mode (`rpc-mode.ts`, ~350 lines) is a thin adapter. It:
1. Creates a readline interface on stdin
2. Parses each line as a `RpcCommand`
3. Delegates to `AgentSession` methods
4. Serializes `AgentSessionEvent`s to stdout
5. Bridges extension UI (dialogs, notifications) via a sub-protocol

### Key Design Decisions

**Fire-and-forget prompting.** `prompt` returns immediately with `success: true` — actual LLM work streams as events. This is non-blocking by design: the client sends a prompt, then consumes a stream of `message_update` events until `agent_end`.

**Request-response correlation.** Optional `id` field on commands. Responses echo it back. Events never carry `id`. This lets clients multiplex commands and responses on the same channel.

**Extension UI sub-protocol.** Extensions can request user interaction (`select`, `confirm`, `input`, `editor`). In TUI mode these are native dialogs. In RPC mode, they emit `extension_ui_request` on stdout and block until the client sends back `extension_ui_response` on stdin. Fire-and-forget methods (`notify`, `setStatus`, `setWidget`) emit requests but don't expect responses.

## The RPC Client (`rpc-client.ts`)

A typed TypeScript client (~300 lines) that wraps the subprocess protocol:

```typescript
const client = new RpcClient({ cliPath: "dist/cli.js", provider: "anthropic" });
await client.start();  // spawns pi --mode rpc
await client.promptAndWait("Hello");  // sends prompt, collects events until agent_end
await client.stop();
```

Key methods: `prompt()`, `steer()`, `followUp()`, `abort()`, `bash()`, `getState()`, `setModel()`, `compact()`, `waitForIdle()`, `collectEvents()`, `promptAndWait()`.

The client handles request ID generation, response correlation, event dispatching, and timeout management.

## Who Uses What — The Actual Patterns

### Pattern 1: RPC Client for Tests (`test/rpc.test.ts`)

The only consumer of `RpcClient` in the monorepo is the test suite. Tests spawn a real pi process, send commands, and assert on responses/events. Tests cover: state management, session persistence, compaction, bash execution, thinking levels, model cycling, session naming, HTML export. All are integration tests hitting real LLM APIs.

### Pattern 2: Custom TUI Over RPC (`examples/rpc-extension-ui.ts`)

A ~400-line TUI chat app built with pi's own `@mariozechner/pi-tui` library. Spawns pi as an RPC subprocess and renders streaming output, tool calls, and extension UI dialogs. A demo/reference implementation.

### Pattern 3: SDK Direct (Mom — Slack Bot, `packages/mom/`)

**Mom does NOT use RPC mode.** It uses the SDK (`AgentSession`) directly in-process. Creates one `Agent` + `AgentSession` per Slack channel, builds custom system prompts, uses custom tools, subscribes to events to post to Slack. Correct choice — same-process, no IPC overhead, full type safety.

### Pattern 4: Web UI (`packages/web-ui/`)

**Web UI does NOT use RPC mode.** It uses `@mariozechner/pi-agent-core` directly (the lower `Agent` layer). Runs in the browser. Correct choice — no subprocess available.

## The Broader Ecosystem: stdin/stdout Agent Protocols Are Now Standard

### Self-Correction: "Zero production consumers" was wrong

My initial analysis said pi's RPC mode has "zero production consumers" and called it "waiting for its first real consumer." This was **too narrow a frame**. While the monorepo itself doesn't have a production RPC consumer, the stdin/stdout JSON protocol pattern for coding agents has become an **industry standard** in 2025-2026. Pi's RPC mode is an early, well-executed instance of a pattern that's now everywhere:

**ACP (Agent Client Protocol)** — Zed Industries created ACP as "the LSP for AI coding agents." It uses JSON-RPC 2.0 over stdin/stdout — spawn an agent as a subprocess, exchange newline-delimited JSON. The pattern is structurally identical to pi's RPC mode. ACP is now supported by:
- **Zed** (native, created the spec)
- **JetBrains IDEs** (IntelliJ, PyCharm, WebStorm)
- **Neovim** (via CodeCompanion, avante.nvim, agentic.nvim)
- **Emacs**
- **Cline CLI 2.0** (`cline --acp`) — Cline's CLI mode is ACP-compliant, works in all the above editors
- **Claude Code** — Zed built an ACP adapter wrapping Claude Code even before Anthropic officially adopted ACP
- **Gemini CLI** — Google collaborated directly with Zed on ACP integration
- **Kiro CLI** (Amazon) — implements ACP for JetBrains and Zed
- **PraisonAI** — `praisonai acp` for multi-editor support

**MCP (Model Context Protocol)** — Anthropic's protocol for tool integration also uses JSON-RPC 2.0 over stdio as its primary transport. Claude Desktop, Claude Code, and MCP servers all communicate via stdin/stdout JSON-RPC. 10,000+ active public MCP servers.

The pattern is: **spawn agent/tool as subprocess → JSON-RPC over stdin/stdout → editor/client renders UI**. Pi got there independently with a custom protocol rather than JSON-RPC 2.0. The architecture is the same.

### How Pi's RPC Compares to ACP

| Aspect | Pi RPC | ACP (Zed) |
|--------|--------|-----------|
| Transport | JSON-lines over stdin/stdout | JSON-RPC 2.0 over stdin/stdout |
| Message format | Custom `type` discriminated unions | JSON-RPC 2.0 (method/params/result) |
| Streaming | Event stream (message_update deltas) | JSON-RPC notifications |
| Session management | Built-in (new_session, switch, fork, tree) | session/new, session/load |
| Tool permissions | Extension UI sub-protocol (select/confirm) | session/request_permission |
| Capability discovery | get_commands, get_available_models | Initialize handshake with capabilities |
| Bidirectional queries | Extension UI requests (agent → client) | fs/read_text_file, fs/write_text_file (agent → client) |
| Schema | TypeScript types only | JSON-RPC 2.0 spec |
| Adoption | Pi ecosystem only | Zed, JetBrains, Neovim, Emacs, Cline, Gemini CLI, Kiro |

**Key difference:** ACP uses JSON-RPC 2.0 — a standard with existing parsers in every language. Pi uses a custom protocol. This is the single biggest friction point for external adoption.

### Relation to A2A (Agent-to-Agent Protocol)

A2A is Google's protocol (April 2025, now at Linux Foundation) for **agent-to-agent communication** — a fundamentally different layer than pi's RPC:

| Aspect | Pi RPC | A2A |
|--------|--------|-----|
| Purpose | Human/editor ↔ single agent | Agent ↔ agent (multi-agent orchestration) |
| Transport | stdin/stdout (local subprocess) | HTTP/HTTPS, SSE, JSON-RPC (network) |
| Discovery | N/A (you spawn the process) | Agent Cards at `/.well-known/agent.json` |
| Task model | Prompt → stream events → agent_end | Task lifecycle: submitted → working → completed/failed |
| Auth | N/A (local process) | OAuth 2.0, enterprise-grade |
| Session | Stateful (session files, tree branching) | Stateful or stateless |
| Scope | Single coding agent control | Multi-vendor, multi-framework agent collaboration |
| Backers | Pi (single project) | 150+ orgs: Google, Microsoft, SAP, Salesforce, etc. |

**Pi's RPC is not comparable to A2A.** They solve different problems at different layers:

- **MCP** = agent ↔ tools (vertical: "give me data/capabilities")
- **ACP** = editor ↔ agent (vertical: "do coding work for me")
- **A2A** = agent ↔ agent (horizontal: "delegate this task to another agent")
- **Pi RPC** ≈ ACP (editor/client ↔ agent control)

Pi's RPC mode is closest to **ACP** — both are about controlling a single coding agent from an external client. A2A is about multi-agent orchestration across organizational boundaries, with discovery, authentication, and long-running task lifecycle. Pi doesn't operate at that layer.

If pi wanted A2A relevance, it would need to be an A2A "remote agent" that publishes an Agent Card and accepts tasks over HTTP. RPC mode is strictly local subprocess control.

### The AAIF (Agentic AI Foundation) Context

As of late 2025, the Linux Foundation created the **Agentic AI Foundation (AAIF)** co-founded by OpenAI, Anthropic, and Block. It houses:
- **MCP** (Anthropic's contribution)
- **AGENTS.md** (OpenAI's contribution, adopted by 60K+ projects)
- **Goose** (Block's contribution)
- **A2A** (Google, separately at Linux Foundation)

The protocol landscape is crystallizing into layers: MCP for tools, ACP (or A2A) for agent communication, with AAIF as governance. Pi's custom RPC protocol sits outside all of these.

## Critical Self-Review

### What I Got Wrong

1. **"Zero production consumers" framing was misleading.** I was too focused on the monorepo. The pattern — JSON over stdin/stdout for agent control — is now the dominant architecture. ACP, MCP, Cline CLI, Gemini CLI, Claude Code, Kiro CLI all use it. Pi's RPC isn't isolated; it's an independent invention of what became industry standard. The question isn't "does anyone use this pattern" (everyone does) but "does anyone use pi's specific protocol" (no, just pi).

2. **Understated the custom-protocol problem.** I mentioned it as weakness #3 but buried it. In hindsight, **this is the critical issue**. Every other major agent (Cline, Gemini CLI, Claude Code, Kiro) is converging on ACP (JSON-RPC 2.0). Pi's custom protocol means it can't plug into Zed, JetBrains, or Neovim without a custom adapter. This is a real competitive disadvantage, not a theoretical concern.

3. **Overstated the "solid foundation" verdict.** The foundation is clean engineering, but a foundation nobody else can build on (because it's a custom protocol) is less valuable than a messier one with ecosystem compatibility. ACP's JSON-RPC 2.0 basis means every language has ready-made parsers. Pi's clients must be written from scratch.

4. **Missed the ACP adapter opportunity.** Zed built an ACP wrapper around Claude Code (which also doesn't natively speak ACP). Pi could do the same — or better, implement ACP natively alongside its custom RPC. This is the obvious next step that I should have identified.

### What I Got Right

1. **Architecture analysis is solid.** The three-layer stack, thin adapter design, and consumer analysis are accurate.
2. **Specific bugs are real.** The prompt error swallowing, shutdown hang, and backpressure issues are genuine implementation problems.
3. **SDK vs RPC guidance is correct.** Same-process consumers should use the SDK. RPC is for cross-process/cross-language.
4. **Extension UI sub-protocol analysis is thorough.** The dialog/fire-and-forget split, timeout handling, and TUI degradation are well-designed and I assessed them correctly.

### What I Should Have Investigated

1. **External pi users.** Are there any community projects using pi's RPC mode? The monorepo isn't the only place to look. (I didn't search npm, GitHub, or community forums.)
2. **Performance characteristics.** How does pi's RPC mode compare on latency/throughput vs direct SDK? The JSON serialization/deserialization and subprocess overhead are real costs.

## Revised Verdict

Pi's RPC mode is a **well-engineered implementation of what became an industry-standard pattern** (JSON over stdin/stdout for agent control). The architecture is clean, the protocol is comprehensive, and the extension UI sub-protocol is genuinely innovative compared to ACP's simpler permission model.

But pi made the critical mistake of **inventing a custom protocol instead of adopting JSON-RPC 2.0**. Every major competitor — Cline, Gemini CLI, Claude Code (via Zed adapter), Kiro — now speaks ACP, which uses JSON-RPC 2.0. This means pi can't plug into the rapidly growing ACP ecosystem (Zed, JetBrains, Neovim, Emacs) without an adapter layer.

**Recommendations:**

1. **Implement ACP support** — either natively or as a thin adapter over existing RPC. This is the highest-leverage change. It would make pi usable in Zed, JetBrains, and Neovim immediately.
2. **Keep the custom RPC for backward compatibility** — the extension UI sub-protocol and session management features are richer than ACP's equivalents.
3. **Fix the prompt error swallowing** — this is a real bug regardless of protocol choice.
4. **Consider A2A only if multi-agent orchestration becomes relevant** — it's a different layer entirely, not a replacement for RPC/ACP.

The bottom line: pi's RPC is a **good answer to the right question, in the wrong dialect**. The question was "how should editors/clients control coding agents?" The industry answered "JSON-RPC 2.0 over stdio" (ACP). Pi answered "custom JSON-lines over stdio." Same architecture, incompatible protocols. The fix is mechanical, not architectural.
