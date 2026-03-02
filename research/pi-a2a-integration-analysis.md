← [Index](../README.md)

# Pi A2A Integration — Deep Technical Analysis

**Date:** 2026-03-01
**Source:** Pi mono repo (docs/rpc.md, docs/sdk.md, docs/extensions.md), A2A spec RC v1.0, ACP spec, pi source (dist/modes/rpc/), external: Cline ACP, Kiro ACP, PraisonAI ACP, Gemini CLI ACP, A2A Python SDK examples.

## Review of Prior Research (pi-rpc-mode-deep-dive.md)

The original analysis is **solid on architecture, improved after self-correction, but now partially stale**:

**What holds up:**
- Three-layer stack analysis (Run Mode → AgentSession → Agent) is accurate and confirmed by source inspection
- Consumer analysis correct: tests use RpcClient, Mom uses SDK directly, Web UI uses agent-core directly
- Extension UI sub-protocol analysis thorough and accurate
- "Custom protocol vs JSON-RPC 2.0" as the critical issue — confirmed by every subsequent development

**What's stale or needs updating:**
- A2A has moved to **RC v1.0** (late 2025) with significant API changes: methods renamed from `tasks/send` → `message/send`, `tasks/sendSubscribe` → `message/stream`; new `Part` types (`text`, `raw`, `url`, `data`); `TaskState` values uppercased and prefixed (`TASK_STATE_COMPLETED`); `contextId` introduced for conversation threading; `supportedInterfaces` for multi-transport. The original analysis references v0.2.x terminology.
- ACP ecosystem has grown: Kiro CLI (Amazon), PraisonAI, more Neovim plugins, Zed native refactor. ACP is now essentially the LSP equivalent for coding agents.
- **oh-my-pi** (fork of pi-mono, 1.6k stars) exists with subagents, LSP integration, and the same RPC protocol. Shows the protocol is being consumed downstream.
- The "zero production consumers" self-correction was directionally right but still didn't explore enough: CI/CD integration, multi-agent orchestration, platform bots, and dashboard embedding are all real patterns that pi's RPC enables.

**Verdict on prior work:** B+. Architecturally rigorous, honest self-correction, but the A2A section is too brief to answer "what would it take?" and is now partially outdated.

---

## Pi RPC: Broader Use Cases Beyond Editor Integration

The original analysis focused on the editor-integration use case (ACP). But pi's RPC mode enables several other patterns:

### 1. CI/CD Pipeline Agent

Spawn `pi --mode rpc` in a CI job. Send prompts like "review this PR diff", "generate tests for changed files", "check for security issues". Collect `agent_end` events, parse assistant messages, post results to GitHub. The `bash` RPC command lets you run tests and feed results back without LLM involvement.

**Fit with current RPC:** Good. The `promptAndWait()` pattern is designed for this. The `--no-session` flag prevents disk state. Missing: no way to set a timeout on the agent run itself (only on individual commands).

### 2. Multi-Agent Orchestration (Local)

An orchestrator process spawns N pi instances via RPC. Each specializes (code review agent, test writer, architect). The orchestrator routes tasks, collects results, and composes them. This is pi's answer to "sub-agents" without building it into core.

**Fit with current RPC:** Decent. The `RpcClient` class handles spawn/communicate/stop. Missing: no structured way to pass context between agents (you'd serialize manually), no shared session state, no task routing primitives. Extensions could fill some gaps.

### 3. Platform Bots (Slack, Discord, Teams)

Mom (Slack bot) uses the SDK directly. But for non-Node.js platforms or for process isolation, RPC works: spawn a pi process per conversation, send messages via `prompt`, stream responses via events, post them to the platform API.

**Fit with current RPC:** Good. Session management (`new_session`, `switch_session`, `fork`) maps naturally to conversation threads. The extension UI sub-protocol could bridge to platform-specific interactions (reactions, buttons). Missing: no webhook/callback mechanism — the client must poll events via stdout.

### 4. Web Dashboard / Admin Panel

A web server wraps pi RPC processes. Users interact via browser, the server translates HTTP requests to RPC commands, streams SSE or WebSocket events back. Essentially a custom "web-ui" built on RPC rather than agent-core.

**Fit with current RPC:** Moderate. Works for single-user. For multi-user, you need one pi process per session — that's expensive. Missing: no HTTP transport, no auth layer, no resource limits. You'd be building exactly the infrastructure A2A defines.

### 5. Automated Testing / Benchmarking

This is the existing primary use case. The test suite (`test/rpc.test.ts`) demonstrates the pattern well. Also useful for benchmarking agents across models, prompts, and configurations — spawn, prompt, measure, compare.

**Fit with current RPC:** Excellent. This is what it was designed for.

### 6. Desktop App Embedding

An Electron/Tauri app embedding pi as the AI backend. Spawn via RPC, build a native UI on top. The oh-my-pi fork validates this pattern.

**Fit with current RPC:** Good. The event stream provides everything needed for UI rendering. The extension UI sub-protocol could drive native dialogs.

---

## What It Takes to Add A2A to Pi — Deep Analysis

### The Core Question

A2A is **fundamentally different** from pi's RPC:

| Dimension | Pi RPC | A2A |
|-----------|--------|-----|
| Transport | stdin/stdout (local subprocess) | HTTP/HTTPS (network) |
| Wire format | Custom JSON-lines | JSON-RPC 2.0 |
| Discovery | None (you spawn it) | Agent Card at `/.well-known/agent-card.json` |
| Session model | Tree-branching JSONL files | Context IDs + Task IDs |
| Auth | None (local process) | OAuth 2.0, API keys, mTLS |
| Task lifecycle | Implicit (agent_start → agent_end) | Explicit states (submitted → working → completed/failed/canceled) |
| Streaming | JSON-lines on stdout | SSE over HTTP |
| Multi-agent | Not supported | Core purpose |
| Content model | Text + images + tool calls | Parts (text, file, data, raw) + Artifacts |

Adding A2A to pi means: **building an HTTP server that wraps AgentSession, translates A2A's data model to pi's internal model, manages task lifecycle, serves an Agent Card, handles auth, and streams via SSE.**

### Implementation Layers

#### Layer 1: HTTP Server (~300-500 LOC)

Pi has no HTTP server. You need one. Options:

1. **Extension approach**: Build an extension that starts an HTTP server (e.g., using Node.js `http` module or Express). Extensions can access `AgentSession` directly via the SDK. This is the lowest-friction path — no core changes.

2. **New run mode**: Add `pi --mode a2a --port 8080` alongside `rpc`, `interactive`, `print`, `json`. This would be a new file in `modes/a2a/` (~similar to how `rpc-mode.ts` adapts AgentSession to stdin/stdout, `a2a-mode.ts` adapts it to HTTP).

3. **Standalone wrapper**: A separate Node.js process that uses the SDK (`createAgentSession()`) and exposes A2A endpoints. Like Mom, but for A2A instead of Slack.

**Recommendation: Option 2 (new run mode)** for parity with how RPC works. Option 1 is viable for community contribution. Option 3 is what you'd use in production but doesn't integrate into pi's CLI.

The server must handle:
- `GET /.well-known/agent-card.json` — serve Agent Card
- `POST /` (or configured endpoint) — JSON-RPC 2.0 dispatch for all A2A methods
- SSE endpoint for streaming responses
- CORS headers for browser-based clients

#### Layer 2: Agent Card Generation (~150-200 LOC)

The Agent Card must describe pi's capabilities. This maps directly from pi's existing metadata:

```typescript
// Pseudocode for Agent Card generation
function generateAgentCard(session: AgentSession): AgentCard {
  return {
    protocolVersion: "1.0",
    name: "Pi Coding Agent",
    description: "Terminal-native coding agent with tools, extensions, and skills",
    url: `http://localhost:${port}`,
    version: piVersion,
    capabilities: {
      streaming: true,
      pushNotifications: false, // complex, skip v1
      extendedAgentCard: false,
    },
    defaultInputModes: ["text/plain", "image/png", "image/jpeg"],
    defaultOutputModes: ["text/plain", "text/markdown"],
    skills: session.resourceLoader.getSkills().skills.map(s => ({
      id: `skill:${s.name}`,
      name: s.name,
      description: s.description,
    })),
    // Extension-registered tools become skills too
    ...extensionToolsAsSkills(session),
  };
}
```

Pi's `get_commands` RPC command already aggregates extensions, skills, and prompt templates — the Agent Card can derive from the same data.

**Open question:** Should pi's built-in tools (read, bash, edit, write) be advertised as A2A skills? Probably not — they're implementation details. A2A skills should map to high-level capabilities ("code review", "test generation", "refactoring") — which are really pi skills or prompt templates, not raw tools.

#### Layer 3: JSON-RPC 2.0 Method Dispatch (~400-600 LOC)

Map A2A methods to pi operations:

| A2A Method | Pi Equivalent |
|------------|---------------|
| `message/send` | `session.prompt()` + collect events until `agent_end` |
| `message/stream` | `session.prompt()` + stream events as SSE |
| `tasks/get` | Lookup task state from in-memory task store |
| `tasks/cancel` | `session.abort()` |
| `tasks/list` | List managed tasks (new state needed) |
| `tasks/resubscribe` | Reconnect SSE to existing task |

The `message/send` → `session.prompt()` mapping is straightforward:

```typescript
async function handleMessageSend(params: SendMessageParams): Promise<Task | Message> {
  const task = createTask(params);
  taskStore.set(task.id, task);
  
  // Translate A2A Parts to pi content
  const { text, images } = translateParts(params.message.parts);
  
  // Subscribe to events for task lifecycle
  const unsub = session.subscribe(event => {
    if (event.type === "agent_start") {
      task.status = { state: "TASK_STATE_WORKING" };
    }
    if (event.type === "agent_end") {
      task.status = { state: "TASK_STATE_COMPLETED" };
      task.artifacts = extractArtifacts(event.messages);
    }
  });
  
  if (params.configuration?.blocking) {
    await session.prompt(text, { images });
    unsub();
    return task;
  } else {
    session.prompt(text, { images }).catch(e => {
      task.status = { state: "TASK_STATE_FAILED", message: errorToMessage(e) };
    });
    return task; // Return immediately with TASK_STATE_SUBMITTED
  }
}
```

#### Layer 4: Task Lifecycle Management (~200-300 LOC)

A2A has explicit task states. Pi doesn't — it has `agent_start` / `agent_end` events and `isStreaming` boolean. You need a task store that maps between them:

```
A2A TaskState          ← Pi Event/State
─────────────────      ──────────────────
TASK_STATE_SUBMITTED   ← prompt() called
TASK_STATE_WORKING     ← agent_start event
TASK_STATE_COMPLETED   ← agent_end event (no error)
TASK_STATE_FAILED      ← agent_end event (with error) or prompt rejection
TASK_STATE_CANCELED    ← abort() called
TASK_STATE_INPUT_REQUIRED ← extension_ui_request (select/confirm/input)
```

The interesting mapping is `INPUT_REQUIRED`. When a pi extension calls `ctx.ui.confirm()` or `ctx.ui.select()`, in RPC mode this emits an `extension_ui_request` and blocks. In A2A mode, this should transition the task to `TASK_STATE_INPUT_REQUIRED` and include the question in the task status message. The A2A client then sends a follow-up `message/send` with the answer, which maps to `extension_ui_response`.

This is the **hardest part of the integration** because pi's extension UI protocol is bidirectional (agent asks client) while A2A folds this into the task state machine. The translation requires:
1. Catching `extension_ui_request` events
2. Transitioning task to `INPUT_REQUIRED`
3. Holding the extension's promise
4. Receiving the A2A client's response message
5. Resolving the extension's promise with the translated response

#### Layer 5: Content Model Translation (~150-200 LOC)

A2A uses `Part` (text/raw/url/data) and `Artifact` objects. Pi uses `UserMessage`, `AssistantMessage`, `ToolResultMessage`, and streaming deltas.

**Inbound (A2A → Pi):**
```
A2A Part(kind=text)           → pi text content
A2A Part(kind=raw, image/*)   → pi ImageContent (base64)
A2A Part(kind=data)           → pi text content (JSON.stringify)
A2A Part(kind=url)            → fetch URL, convert to appropriate pi content
```

**Outbound (Pi → A2A):**
```
pi AssistantMessage text blocks → A2A Part(kind=text)
pi tool_execution_end results   → A2A Artifact (with Parts)
pi thinking blocks              → A2A Part(kind=text) in metadata or discarded
pi streaming deltas             → A2A TaskArtifactUpdateEvent (append=true)
```

The artifact model is a good fit: each tool result (file read, bash output, file write) can become a separate Artifact with a descriptive name.

#### Layer 6: SSE Streaming (~100-150 LOC)

Map pi's event stream to A2A's SSE format:

```
Pi Event                 → A2A SSE Event
────────────────         ────────────────────
agent_start              → Task object (state=WORKING)
message_update(text_delta)→ TaskArtifactUpdateEvent (append=true, lastChunk=false)
message_end              → TaskArtifactUpdateEvent (lastChunk=true)
tool_execution_start     → TaskStatusUpdateEvent (state=WORKING, message="Running tool: X")
tool_execution_end       → TaskArtifactUpdateEvent (new artifact per tool result)
agent_end                → TaskStatusUpdateEvent (state=COMPLETED) + close stream
```

Pi already serializes all events as JSON (that's what RPC mode does). SSE just wraps them differently: `data: {json}\n\n` instead of `{json}\n`.

#### Layer 7: Authentication (~200-400 LOC, or skip for v1)

A2A requires security. For a v1/proof-of-concept:
- **API key auth**: Simple `X-API-Key` header check against a configured secret
- Skip OAuth 2.0, mTLS, and push notifications

For production:
- OAuth 2.0 with PKCE (pi already has OAuth for provider auth via `/login`)
- JWT validation
- Rate limiting
- CORS configuration

#### Layer 8: Context/Session Mapping (~100-150 LOC)

A2A's `contextId` maps to pi's sessions. A2A's `taskId` maps to individual prompt→response cycles within a session.

```
A2A contextId → pi session file
A2A taskId    → pi agent_start/agent_end cycle within that session
```

Multiple A2A tasks with the same `contextId` should route to the same pi session. New `contextId` → `session.newSession()`. Existing `contextId` → resume that session.

### Total Estimate

| Component | LOC (est.) | Difficulty |
|-----------|-----------|------------|
| HTTP server + routing | 300-500 | Medium (boilerplate) |
| Agent Card generation | 150-200 | Easy |
| JSON-RPC 2.0 dispatch | 400-600 | Medium |
| Task lifecycle management | 200-300 | Medium-Hard |
| Content model translation | 150-200 | Easy-Medium |
| SSE streaming | 100-150 | Easy |
| Auth (API key only) | 50-100 | Easy |
| Context/session mapping | 100-150 | Medium |
| **Total** | **~1,500-2,200** | **Medium overall** |

For comparison: `rpc-mode.ts` is ~350 LOC, `rpc-client.ts` is ~300 LOC. An A2A adapter would be roughly **3-4× the size** of the RPC mode because of HTTP server infrastructure, task state management, content translation, and auth.

### The Extension Approach: Lowest Friction

The most practical path is **a pi extension** rather than core changes:

```typescript
// .pi/extensions/a2a-server.ts (conceptual)
export default function(pi: ExtensionAPI) {
  const server = createA2AServer({
    port: parseInt(process.env.A2A_PORT ?? "8080"),
    agentCard: generateCardFromPi(pi),
    onMessageSend: async (params) => {
      // Use pi.sendUserMessage() for prompts
      // Subscribe to events via pi.on()
      // Return A2A Task/Message
    },
    onMessageStream: async (params, sseWriter) => {
      // Same, but write SSE events
    },
  });
  
  pi.on("session_shutdown", () => server.close());
}
```

Why this works:
- Extensions have full access to the ExtensionAPI, which includes `sendMessage`, `sendUserMessage`, event subscription, session management, and UI interaction
- Extensions can spawn HTTP servers (they can import Node.js built-ins)
- Extensions are hot-reloadable via `/reload`
- No core pi changes needed
- Can be distributed as a pi package (`pi install npm:pi-a2a-server`)

Why this might not be ideal:
- Extensions run inside pi's process — no isolation between A2A server and agent
- The extension API is oriented toward interactive use (commands, shortcuts, UI widgets), not server mode
- Extensions can't easily modify the startup behavior (you still need `pi --mode interactive` or `pi --mode rpc` running)
- Extension tools can register tools/commands but can't expose a clean HTTP endpoint without workarounds

**Better: hybrid approach.** An extension that registers the A2A server AND a new run mode `pi --mode a2a` that sets up the extension's HTTP server as the primary interface (no TUI, no stdin).

### Critical Assessment: Should Pi Even Add A2A?

**Arguments for:**
1. A2A has 150+ backers, Linux Foundation governance, and is the only protocol for agent-to-agent communication. If multi-agent patterns matter, this is the standard.
2. Makes pi usable as a "remote coding agent" — an enterprise could expose a pi instance as an A2A endpoint for other agents to delegate coding tasks to.
3. Differentiator: most coding agents (Claude Code, Cline, Kiro) focus on ACP (editor integration). Being the first to support A2A would be a unique value proposition.
4. Pi's extension system means the community could build this without core changes.

**Arguments against:**
1. **ACP is the higher-priority protocol.** A2A is for agent-to-agent; ACP is for editor-to-agent. Pi is a coding agent used by humans in editors. ACP adoption gets pi into Zed, JetBrains, and Neovim immediately. A2A gets pi into... multi-agent pipelines that barely exist yet.
2. **A2A's use case doesn't match pi's design.** Pi is stateful, local, interactive. A2A is for network-accessible, multi-tenant, enterprise agents. Making pi serve HTTP, handle auth, and manage concurrent tasks is a significant architectural shift.
3. **The market isn't there yet.** A2A has impressive backers but few real production deployments. Most A2A examples are toy demos (joke-telling, hello-world). Enterprise multi-agent orchestration is aspirational, not operational.
4. **Complexity cost is real.** 1,500-2,200 LOC is manageable, but the ongoing maintenance — A2A spec updates, security patches, task lifecycle edge cases — is substantial for a project that values minimalism.

**Verdict:** Pi should add **ACP first** (mechanical translation, immediate ecosystem value) and **A2A second** (if multi-agent orchestration becomes a real use case). A2A as a pi extension/package is the right approach — keep it out of core, let the community validate the need.

### Comparison: ACP vs A2A Implementation Effort

| Aspect | ACP for Pi | A2A for Pi |
|--------|-----------|------------|
| Transport change | None (already stdin/stdout) | Needs HTTP server |
| Wire format change | Custom JSON-lines → JSON-RPC 2.0 | Custom JSON-lines → JSON-RPC 2.0 over HTTP |
| Discovery | None needed | Agent Card at well-known URL |
| Auth | None needed | OAuth 2.0 / API keys |
| Session model | Direct mapping | contextId/taskId translation |
| Task lifecycle | None (ACP is stateless) | Full state machine |
| Streaming | Already works | SSE translation |
| Content model | Minor adjustments | Part/Artifact translation |
| LOC estimate | ~500-800 | ~1,500-2,200 |
| Immediate value | Zed, JetBrains, Neovim, Emacs | Multi-agent pipelines (nascent) |

ACP is roughly **3× less work** for **10× more immediate value**.

### The A2A-via-Extension Architecture (If You Build It)

```
                                   ┌─────────────────────────────┐
                                   │     A2A Client (Remote)     │
                                   │  (another agent, dashboard) │
                                   └──────────┬──────────────────┘
                                              │ HTTP/HTTPS + JSON-RPC 2.0
                                              │ SSE for streaming
                                              ▼
┌──────────────────────────────────────────────────────────────────┐
│  pi process (--mode a2a)                                         │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │  A2A Extension / Run Mode                                  │  │
│  │  ┌──────────────┐  ┌─────────────┐  ┌──────────────────┐ │  │
│  │  │ HTTP Server   │  │ Task Store  │  │ Content Translator│ │  │
│  │  │ (Express/raw) │  │ (in-memory) │  │ (Parts↔Messages) │ │  │
│  │  └──────┬───────┘  └──────┬──────┘  └────────┬─────────┘ │  │
│  │         │                 │                   │            │  │
│  │         └─────────────────┴───────────────────┘            │  │
│  │                           │                                │  │
│  │                    ┌──────┴──────┐                         │  │
│  │                    │ Agent Card  │                         │  │
│  │                    │ Generator   │                         │  │
│  │                    └──────┬──────┘                         │  │
│  └───────────────────────────┼────────────────────────────────┘  │
│                              │ ExtensionAPI / SDK                 │
│  ┌───────────────────────────┴────────────────────────────────┐  │
│  │  AgentSession                                              │  │
│  │  ┌──────────┐  ┌────────────┐  ┌────────────────────────┐ │  │
│  │  │ prompt() │  │ subscribe()│  │ session management     │ │  │
│  │  │ steer()  │  │ events     │  │ (new, switch, fork)    │ │  │
│  │  │ abort()  │  │            │  │                        │ │  │
│  │  └──────────┘  └────────────┘  └────────────────────────┘ │  │
│  └────────────────────────────────────────────────────────────┘  │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │  Agent (pi-agent-core)                                     │  │
│  │  LLM loop, tool execution, extensions                      │  │
│  └────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### Open Problems

1. **Concurrency.** Pi's AgentSession is single-threaded (one prompt at a time, with steer/followUp queueing). A2A clients may send multiple tasks concurrently. Options: reject concurrent tasks (simple), or spawn multiple AgentSession instances (complex, memory-heavy).

2. **Session persistence.** Pi sessions are JSONL files tied to a working directory. A2A contexts are ephemeral IDs. How do you map A2A `contextId` to pi session files? Option: keep a lookup table, create session files on demand.

3. **Tool permissions.** Pi's extension UI protocol allows interactive approval (confirm before `rm -rf`). A2A has `INPUT_REQUIRED` state. But A2A clients may not be human — they may be other agents. Automatic approval policies are needed.

4. **Multi-tenancy.** A2A implies multiple clients connecting to one agent. Pi is single-user. Options: one pi process per client (expensive), or session-based isolation within one process (requires AgentSession to support concurrent sessions, which it currently doesn't).

5. **Working directory.** Pi tools operate relative to `cwd`. A2A tasks may reference different projects. Either: one pi instance per project (matches current model), or dynamic `cwd` switching (not supported).

6. **Push notifications.** A2A supports webhooks for task updates. Pi has no outbound HTTP client infrastructure. Skip for v1, add later.

## Bottom Line

Adding A2A to pi is **mechanically feasible but architecturally misaligned.** Pi is a local, interactive, single-user coding agent. A2A is a network protocol for multi-agent, multi-tenant, enterprise orchestration. The translation layer is ~1,500-2,200 LOC — not trivial, but not enormous. The real cost is in the conceptual mismatch: concurrency, multi-tenancy, auth, and working directory isolation are all problems pi doesn't currently have.

**Priority order:**
1. **ACP** — ~500-800 LOC, instant editor ecosystem access, mechanical translation
2. **A2A as extension/package** — community-driven, validates demand before committing core complexity
3. **A2A as core mode** — only if multi-agent coding orchestration becomes a real, proven pattern

The pi philosophy is "build what you want via extensions." A2A is a perfect candidate for that philosophy: the extension system can host an HTTP server, generate Agent Cards, manage tasks, and translate content models — all without touching pi core. If it works, promote it. If nobody uses it, it's just a package you can uninstall.
