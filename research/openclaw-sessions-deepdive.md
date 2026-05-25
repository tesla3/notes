# OpenClaw Sessions: Deep Dive

> **Provenance note.** This document was initially reconstructed from secondary sources (architecture blog posts, GitHub README, news coverage). All key claims have since been **verified against the OpenClaw source code** at commit `750276fa3`: session key construction (`src/routing/session-key.ts`), routing pipeline (`src/routing/resolve-route.ts`), visibility scoping (`src/agents/tools/sessions-access.ts`), cron session reuse (`src/cron/isolated-agent/session.ts`), lane queue execution model (`src/process/command-queue.ts`, `src/agents/pi-embedded-runner/run.ts`), subagent spawn depth (`src/agents/subagent-spawn.ts`), and identity link resolution (test suite `src/routing/resolve-route.test.ts`).

---

## Design Assumptions & Constraints

Before diving into sessions, it's worth naming the assumptions baked into OpenClaw's architecture. These constrain what the session system can and cannot do.

### 1. Single Process, Single Machine

OpenClaw runs as one Node.js process on one machine. This means:
- Lane queues live in memory — no distributed locking or coordination needed
- Session metadata is an in-memory store persisted to local disk
- Transcripts are local files, not a database

**Implication:** If you wanted to scale horizontally (multiple OpenClaw processes behind a load balancer), the lane queue model breaks — two processes could pick up messages for the same session simultaneously. The design assumes you don't need this. For a personal agent, that's correct.

### 2. Personal Scale (1–10 Users)

The system is designed for a single person or a small group. This explains choices that wouldn't survive at enterprise scale:
- Session keys are flat strings with no secondary index — cross-cutting queries require scanning all keys
- Transcripts are individual JSONL files — no aggregation, no full-text search across sessions
- Configuration is a single JSON file — no admin UI, no per-user settings panel

### 3. The LLM Is a Trusted-but-Unreliable Executor

This is the subtlest assumption. Session visibility scoping (`self`, `tree`, `agent`, `all`) controls which sessions the LLM's tools can *access*. The default `tree` limits access to the current session and its spawn tree — a reasonable boundary. But within any scope, there's no further access control — the LLM decides when and why to use `sessions_history`. The system trusts the LLM to follow its system prompt's instructions about privacy.

This means: if visibility is `agent` and the system prompt says "don't read other users' sessions," the only enforcement is the LLM's compliance. A jailbreak or prompt injection could cause the LLM to ignore that instruction. The visibility scope is a **tool-availability boundary**, not an **access-control enforcement** in the traditional security sense.

### 4. Channel Adapters Are the Trust Boundary for Identity

The system trusts that each channel adapter (Telegram, Discord, WhatsApp, etc.) correctly identifies the sender. If an adapter is compromised or buggy, it could mis-identify a sender, which would route messages to the wrong session. There's no independent identity verification layer above the adapters.

### 5. Designed for Conversation, Not Arbitrary Workflows

Sessions model conversations — sequential exchanges between a user and an agent. They're not a general-purpose workflow engine. Long-running, multi-step processes (build pipelines, data ETL) can be shoehorned in via cron + persistent memory, but the session abstraction doesn't natively support checkpointing, branching, or resumption of complex task graphs.

---

## What Is a Session?

A **session** in OpenClaw is the fundamental unit of conversational state. It binds together:

1. **A session key** — a deterministic string that identifies *which conversation* this is
2. **A session ID** — a UUID that identifies *the current lifecycle* of that conversation (resets create a new ID under the same key)
3. **A JSONL transcript** — the full message history on disk
4. **A session entry** — metadata in the store (model, tokens, thinking level, labels, origin, delivery context, etc.)
5. **A position in the Lane Queue** — ensuring serial execution per session

The session key is the **identity**; the session ID is the **incarnation**. When you `/reset`, the key stays the same but you get a fresh ID and transcript.

---

## How Session Keys Are Built

Session keys are **deterministically derived** from routing context: who sent the message, on what channel, to which agent, and what type of chat it is. The key formula depends on the **chat type** and the **`dmScope` setting**.

### The Key Taxonomy

```
Session Key Format                                          When Used
─────────────────────────────────────────────────────────── ─────────────────────────────
agent:<agentId>:<mainKey>                                   DMs (dmScope="main", default)
agent:<agentId>:direct:<peerId>                             DMs (dmScope="per-peer")
agent:<agentId>:<channel>:direct:<peerId>                   DMs (dmScope="per-channel-peer")
agent:<agentId>:<channel>:<accountId>:direct:<peerId>       DMs (dmScope="per-account-channel-peer")
agent:<agentId>:<channel>:group:<groupId>                   Group chats
agent:<agentId>:<channel>:channel:<channelId>               Channel/room chats
agent:<agentId>:<channel>:group:<groupId>:thread:<threadId> Threaded messages (Telegram topics, Slack threads)
agent:<agentId>:subagent:<uuid>                             Spawned sub-agents
cron:<jobId>                                                Cron/heartbeat jobs (fresh when reset policy triggers)
hook:<name>                                                 Webhook triggers (configurable via hooks.defaultSessionKey)
node-<nodeId>                                               Device node sessions
```

### ⚠️ The Default dmScope Is Dangerous for Multi-User

The default dmScope is `main`, which means **every person who DMs the agent shares a single conversation context**. Alice's messages, Bob's messages, a stranger's messages — all land in the same session with the same transcript. This is fine for solo use (one person, one agent), but it is a **data-leaking misconfiguration** the moment a second user sends a DM.

If you serve more than one person, you **must** change dmScope. `per-channel-peer` is the safe default for multi-user deployments. The walkthrough below uses `per-channel-peer` for this reason.

### The Routing Pipeline

When a message arrives, `resolveAgentRoute()` (in `src/routing/resolve-route.ts`) runs this pipeline:

1. **Normalize** the channel, account ID, peer kind (direct/group/channel), and peer ID
2. **Pre-filter bindings** by channel and account — only bindings matching this channel (exact) and this account (exact or `*` wildcard) survive.
3. **Evaluate surviving bindings** in priority tiers (first match in the highest-priority tier wins):
   - `binding.peer` (binding specifies a peer, and it matches the message's peer exactly)
   - `binding.peer.parent` (binding matches the parent conversation's peer — thread inheritance)
   - `binding.guild+roles` (binding requires a guild ID + at least one matching role)
   - `binding.guild` (binding requires a guild ID, no role constraint)
   - `binding.team` (binding requires a Teams team ID)
   - `binding.account` (binding has a specific or default account — no peer/guild/team/role constraints)
   - `binding.channel` (binding uses `accountId: "*"` — broadest match)
4. **Fallback** — if no binding matches at any tier, route to the `default` agent.
5. **Build the session key** via `buildAgentPeerSessionKey()`, which applies dmScope and identity links
6. **Build the main session key** for reference (always `agent:<agentId>:main`)

The tiers are evaluated top-to-bottom; the **first tier that has any match wins**, and lower tiers are never checked. Within a single tier, if multiple bindings match (e.g., two `binding.guild` rules for different agents on the same guild), the code uses `Array.find()` — meaning **first-defined-wins** based on config file ordering. There's no error or warning for ambiguous bindings. Avoid overlapping bindings at the same tier.

The result: a `ResolvedAgentRoute` containing `{ agentId, channel, accountId, sessionKey, mainSessionKey, matchedBy }`.

---

## Non-Trivial Example: A Day in the Life of "Molty"

Let's trace a realistic scenario where one OpenClaw instance ("Molty") handles multiple users, channels, and automated tasks simultaneously. This illustrates how sessions create isolation, continuity, and coordination.

### Setup

```json5
// ~/.openclaw/openclaw.json
{
  agents: {
    list: [
      { id: "molty", default: true },
      { id: "codebot" }
    ]
  },
  session: {
    dmScope: "per-channel-peer",
    identityLinks: {
      alice: ["telegram:111111", "whatsapp:+1555000111"],
      bob: ["discord:222222"]
    },
    reset: { mode: "daily", atHour: 4, idleMinutes: 120 },
    resetByChannel: {
      discord: { mode: "idle", idleMinutes: 10080 }  // 1 week for Discord
    }
  },
  bindings: [
    {
      match: { channel: "discord", guildId: "999888", roles: ["dev-team"] },
      agentId: "codebot"
    }
  ]
}
```

### 8:00 AM — Alice DMs on Telegram

Alice (telegram ID `111111`) sends "What's on my calendar today?"

**Routing:**
- Channel: `telegram`, peer kind: `direct`, peer ID: `111111`
- No binding match → default agent `molty`
- **Identity link fires:** `telegram:111111` maps to canonical identity `alice`
- dmScope is `per-channel-peer` → key = `agent:molty:telegram:direct:alice`

**Session key:** `agent:molty:telegram:direct:alice`

A new session ID (UUID) is minted because the last session expired at 4:00 AM daily reset. Molty reads Alice's calendar, replies on Telegram. The transcript is written to `~/.openclaw/agents/molty/sessions/<sessionId>.jsonl`.

### 8:15 AM — Alice DMs on WhatsApp

Alice (whatsapp `+1555000111`) sends "Also remind me about the 3pm meeting."

**Routing:**
- Channel: `whatsapp`, peer kind: `direct`, peer ID: `+1555000111`
- **Identity link fires:** `whatsapp:+1555000111` maps to canonical identity `alice`
- dmScope is `per-channel-peer` → BUT the identity link replaces the peerId with `alice`
- Key = `agent:molty:whatsapp:direct:alice`

**Session key:** `agent:molty:whatsapp:direct:alice`

⚠️ **This is a DIFFERENT session** from the Telegram one (`agent:molty:telegram:direct:alice` vs `agent:molty:whatsapp:direct:alice`). Both resolve Alice's identity correctly, but `per-channel-peer` still isolates by channel — the `telegram` vs `whatsapp` prefix keeps them apart. If Alice wanted one unified DM session across channels, dmScope would need to be `per-peer`, which would collapse both to `agent:molty:direct:alice`.

**Design insight:** This is intentional. Alice might share her WhatsApp with family but keep Telegram private. Per-channel isolation prevents context leaks across platforms.

### 9:00 AM — Bob posts in Discord group "#project-alpha"

Bob (discord `222222`) writes "@Molty summarize yesterday's PRs" in a Discord group (ID `555555`) on guild `999888`. Bob has the `dev-team` role.

**Routing:**
- Channel: `discord`, peer kind: `group`, peer ID: `555555`
- Binding check: guild `999888` + role `dev-team` → matches → routes to agent `codebot`
- Group chats always get their own key regardless of dmScope

**Session key:** `agent:codebot:discord:group:555555`

**Critical:** This goes to **codebot**, not molty. The binding system routed based on guild + role. Codebot has its own workspace, skills, memory, and system prompt — completely isolated from molty. The session persists for 1 week (per `resetByChannel.discord`).

### 9:05 AM — Codebot spawns a sub-agent

Codebot decides the PR summary task is complex and uses `sessions_spawn`:

**Session key:** `agent:codebot:subagent:a1b2c3d4-...`

The sub-agent:
- Gets its own isolated session
- Has `spawnedBy: "agent:codebot:discord:group:555555"` and `spawnDepth: 1`
- Cannot spawn further sub-agents (default `maxSpawnDepth` is 1, configurable via `agents.defaults.subagents.maxSpawnDepth`)
- Tool access configurable via `tools.subagents.tools` (allow/deny lists)
- Session lifecycle follows the standard reset policy (no special auto-archive mechanism found in source)
- When done, announces results back to the parent session (which relays to the Discord group)

### 10:00 AM — Cron heartbeat fires

A configured cron job checks for urgent emails:

**Session key:** `cron:email-check`

Cron sessions follow the same reset policy as other sessions — they **reuse an existing session if it's still fresh** (passes the configured reset policy), and only mint a new session ID when the previous one has expired or when `forceNew` is set. This means a cron job that runs every 30 minutes under a daily reset policy will accumulate transcript history throughout the day, resetting at the configured hour.

**Persistent state across resets:** When a cron job needs to remember state across session resets (e.g., which emails it already processed), it uses the agent's **persistent memory** system — plain-text markdown files in the agent's workspace (`MEMORY.md`, `memory.md`, or `memory/**/*.md` under the workspace directory). Default agent workspace: `~/.openclaw/workspace/`; non-default agents: `~/.openclaw/workspace-<agentId>/` (or a custom path from config). This is separate from session transcripts. The session is the conversation scratchpad; memory is the durable store.

### 11:00 AM — Bob DMs Molty on Discord

Bob (discord `222222`) sends a private DM to Molty: "Hey, what's Alice working on?"

**Routing:**
- Channel: `discord`, peer kind: `direct`, peer ID: `222222`
- No binding match for DMs from this peer (the binding was guild+role specific for groups)
- Falls back to default agent `molty`
- dmScope `per-channel-peer` → key = `agent:molty:discord:direct:bob` (identity link maps `discord:222222` → `bob`)

**Session key:** `agent:molty:discord:direct:bob`

**Security implication:** Bob's DM session has its own context window, completely separate from Alice's. Molty's responses to Bob won't *accidentally* contain Alice's data because the LLM only sees Bob's transcript. With the default `tree` visibility, Molty *cannot* use session tools to read Alice's transcript from Bob's session — they're in separate spawn trees. If an operator widens visibility to `agent`, Molty *could* use `sessions_history` to deliberately pull Alice's transcript into Bob's context. (See the 3:00 PM scenario below for the full visibility analysis.)

### 2:00 PM — Alice sends `/new claude-sonnet` on Telegram

Alice resets her Telegram session with a model override.

**What happens:**
- Same session **key**: `agent:molty:telegram:direct:alice`
- New session **ID**: fresh UUID
- New transcript file
- Model override stored in the session entry: `modelOverride: "claude-sonnet"`
- Molty sends a greeting confirming the reset

### 3:00 PM — Cross-session communication

Molty (in Alice's Telegram session) needs to check something from Bob's recent conversation. It uses `sessions_list` to discover active sessions, then `sessions_history` to read Bob's transcript.

**Visibility scoping kicks in** (config: `tools.sessions.visibility`, verified against source):
- `"self"` — can only see its own session. Most restrictive.
- `"tree"` **(default)** — can see its own session and any sub-agents it spawned. **Bob's session is invisible** from Alice's. This is the default because it balances isolation with parent→child coordination.
- `"agent"` — can see all sessions under agent `molty` but NOT codebot's sessions. Molty-in-Alice's-session can read Bob's full transcript.
- `"all"` — can see everything, including cross-agent sessions (still requires `tools.agentToAgent.enabled=true`).

Sandboxed sessions have a separate clamp (`agents.defaults.sandbox.sessionToolsVisibility`, default `"spawned"`) that can further restrict visibility regardless of the global setting.

**With the default `tree` visibility, this scenario would be blocked** — Alice's session can't see Bob's because Bob's session isn't in Alice's spawn tree. The default is secure for multi-user setups. But if an operator sets visibility to `agent` (common for single-user setups where the agent needs to coordinate across conversations), the boundary opens:

**🔴 Tension: isolation vs. cross-session access.** At `agent` or `all` visibility, `sessions_history` **pierces per-session isolation entirely**. If Molty can read Bob's DM transcript from Alice's session, then the "isolation" between Alice and Bob is only isolation of the LLM context window, not isolation of data access.

This is a deliberate design choice — it enables useful workflows (an agent coordinating across conversations). But operators must understand that `tree` (default) = real multi-user privacy; `agent` = single-user convenience with no user-to-user privacy.

### Summary of Sessions Active During This Day

| Time | Session Key | Agent | Source | Lifecycle |
|------|------------|-------|--------|-----------|
| 8:00 | `agent:molty:telegram:direct:alice` | molty | Alice Telegram DM | Daily reset at 4AM |
| 8:15 | `agent:molty:whatsapp:direct:alice` | molty | Alice WhatsApp DM | Daily reset at 4AM |
| 9:00 | `agent:codebot:discord:group:555555` | codebot | #project-alpha group | 1 week idle timeout |
| 9:05 | `agent:codebot:subagent:a1b2c3d4-...` | codebot | Spawned sub-agent | Follows reset policy |
| 10:00 | `cron:email-check` | molty | Cron job | Reused if fresh, else new |
| 11:00 | `agent:molty:discord:direct:bob` | molty | Bob Discord DM | Daily reset at 4AM |
| 14:00 | `agent:molty:telegram:direct:alice` | molty | Alice resets | New ID, same key |

---

## What Makes a Session: The Complete Picture

A session in OpenClaw is **not** just "a conversation." It's closer to a lightweight process with its own state, execution queue, and security context. Here's what's actually stored and how it works at a concrete level.

### On Disk

Each session produces two artifacts:

1. **Transcript file:** `~/.openclaw/agents/<agentId>/sessions/<sessionId>.jsonl` (verified: `resolveSessionTranscriptPath()` in `src/config/sessions/paths.ts`). One JSON object per line, each representing a message (user turn, assistant turn, tool call, tool result). JSONL is a natural fit: append-only, human-readable, debuggable with `tail -f`. Topics/threads get a variant path: `<sessionId>-topic-<topicId>.jsonl`. The downside: no random access or efficient querying across sessions — you'd need to scan files.

2. **Session entry in the store:** A record in the session store file (`sessions.json`), keyed by session key. Contains: session ID, `updatedAt` timestamp (there is no separate `createdAt` — the session ID change marks creation), model/provider overrides, token counts (input + output + total + context), thinking/verbose/reasoning levels, labels, delivery context (`lastChannel`, `lastTo`, `lastAccountId`, `lastThreadId`), send policy, queue mode, chat type, spawn metadata (`spawnedBy`, `spawnDepth`), and a skills snapshot. Full type definition in `src/config/sessions/types.ts`.

### In Memory (at runtime)

3. **Lane Queue slot:** Execution uses **two nested queues** (verified in `src/agents/pi-embedded-runner/run.ts`):
   - **Session lane** (`session:<sessionKey>`, `maxConcurrent: 1`): serializes messages within a single session. This is the actor model — one mailbox per session, strict ordering.
   - **Global lane** (`main`/`cron`/`subagent`): bounds total system parallelism. Defaults: `main` = 4 concurrent runs, `subagent` = 8, `cron` = 1.
   
   The nesting works as: `enqueueSession(() => enqueueGlobal(() => { /* LLM work */ }))`. A task first claims its session slot (ensuring ordering), then competes for a global slot (ensuring the system doesn't overload). This means: per-session serial execution is guaranteed, and cross-session parallelism exists but is **bounded** — at most 4 main-agent sessions can actively run LLM calls simultaneously.

4. **LLM context window:** The subset of the transcript that fits the model's token limit, assembled fresh for each turn. This is where the per-session token counts matter — they track how much budget has been consumed and when context needs truncation.

### Security Boundaries

Each session enforces isolation at multiple levels:
- **Context isolation:** LLM only sees this session's transcript. No bleed from other conversations (unless cross-session tools are used — see the tension noted above).
- **Delivery isolation:** Replies route back to the platform this session originated from. A Telegram session cannot accidentally send to Discord.
- **Sandbox isolation (optional):** Non-main sessions can run in a per-session Docker container, so file system and network access are confined.
- **Send policy:** Per-session allow/deny for outbound messages. A sub-agent can be prevented from sending to external channels.
- **Visibility scope:** Controls whether session tools can see other sessions (`self`, `tree` [default], `agent`, or `all`).

### Per-Session Configuration

Sessions carry runtime overrides that persist across turns within the same session ID:
- **Model:** `/new claude-sonnet` starts a new session with a different model
- **Thinking level:** `/think high` changes reasoning depth for this session only
- **Verbose level, TTS mode, queue mode, group activation mode** — all per-session

These overrides live in the session entry, not in the transcript. On reset (`/new` or `/reset`), override handling is **selective, not blanket** (verified in `src/auto-reply/reply/session.ts`):
- **Explicitly preserved:** `thinkingLevel`, `verboseLevel`, `reasoningLevel`, `ttsAuto` — the code comment says "carry over user-set behavior overrides so the user doesn't have to re-enable them every time."
- **Cleared:** `modelOverride`, `providerOverride`, `sendPolicy`, `queueMode`, queue settings, token counts, compaction state.
- **Implicitly preserved via store merge:** Fields not mentioned in the new entry construction (e.g., `elevatedLevel`, `groupActivation`, `label`) survive because the reset writes `{ ...oldEntry, ...newEntry }` to the store.

This means a `/new` reset preserves your thinking/verbose preferences but clears your model choice — unless you specify one inline (`/new claude-sonnet`).

### Agent Affinity

Sessions don't just belong to "the bot" — they belong to a **specific agent** (`molty`, `codebot`, etc.). Agents are **statically defined** in the config's `agents.list` array — they are not created dynamically per channel or per user. Each agent has:
- Its own **workspace directory** (default: `~/.openclaw/workspace/` for the default agent, `~/.openclaw/workspace-<agentId>/` for others) containing personality files (`SOUL.md`), instructions (`AGENTS.md`), tools config (`TOOLS.md`), identity (`IDENTITY.md`, `USER.md`), memory (`MEMORY.md`, `memory/**/*.md`), and a heartbeat script (`HEARTBEAT.md`). These files are injected into the system prompt at session start.
- Its own **sessions directory** (`~/.openclaw/agents/<agentId>/sessions/`) for transcripts and the session store (`sessions.json`).
- Its own **skills filter** — optionally restricting which skills are available.

The routing system maps incoming messages to these pre-defined agents. One agent can serve many channels, many users, and many concurrent sessions. The agent is the personality and capability boundary; the session is the conversational state boundary within it. A session's agent affinity is determined at routing time and cannot change mid-session.

Sub-agents spawned via `sessions_spawn` can optionally target a *different* agent ID (if `agents.<requesterAgent>.subagents.allowAgents` permits it), running under that agent's workspace and identity. But the target agent must still be defined in the config — no agents are created on the fly.

---

## Known Tensions & Trade-offs

These are honest assessments of where the design creates friction or makes debatable choices.

### 1. Isolation vs. Coordination

The session model wants two contradictory things: strong per-session isolation (for security) and cross-session awareness (for usefulness). The default visibility (`tree`) is well-chosen — it allows parent→child coordination while blocking cross-user access. But the moment an operator sets `tools.sessions.visibility: "agent"` (a common single-user convenience), `sessions_history` gives the agent full read access to all sessions under that agent, effectively making per-session isolation a context-window boundary, not a data-access boundary. The gap between `tree` and `agent` is a cliff, not a gradient.

### 2. dmScope Default vs. Multi-User Safety

The default `main` dmScope pools all DMs into one session. This is a single-user convenience that becomes a multi-user data leak. The system doesn't warn you. There's no prompt during setup asking "will multiple people DM this agent?" This is the single most likely misconfiguration in a real deployment.

### 3. Deterministic Keys vs. Cross-Dimension Queries

Session keys are hierarchical strings optimized for point lookups ("give me Alice's Telegram session"). They're bad for cross-cutting queries ("give me all of Alice's sessions across all channels" or "which sessions are using codebot?"). These queries require scanning all keys, which is fine at small scale but doesn't scale to thousands of sessions. No secondary index exists.

### 4. Cron Session Reuse vs. Expectations

Cron sessions are **not** always fresh — they follow the standard reset policy and will reuse an existing session if it hasn't expired. This means a cron job running every 30 minutes under a daily reset accumulates transcript throughout the day. This is useful (the agent has context from prior runs) but surprising if you expect each cron run to be stateless. The `forceNew` flag exists to force a fresh session, but it's not the default. The interaction between cron frequency, reset policy, and transcript growth is non-obvious and under-documented.

### 5. Reset Ambiguity

Resets happen via daily schedule, idle timeout, or manual `/new` command. In all three cases, the user sees the same thing: conversation history gone, fresh start. But the *cause* differs, and the system doesn't clearly communicate which one happened. Coming back after lunch to find your session reset because of an idle timeout feels different from an intentional `/new`, but the system treats them identically.

---

## Key Design Insights

1. **Sessions are the unit of trust** — and the defaults mostly uphold this. With the default `tree` visibility, sessions can't read each other's transcripts (only their own spawn tree). But switching to `agent` visibility collapses this boundary. Don't confuse "separate context window" with "separate data access" — they only align at `tree`/`self` visibility. (See Tension #1.)

2. **The key is deterministic, the ID is ephemeral.** The "conversation slot" is stable (Alice on Telegram always maps to the same key) but the actual conversation can be reset without losing the routing. This is the same pattern as Kubernetes Deployments vs. ReplicaSets, or DNS names vs. IP addresses — stable identity, replaceable instance.

3. **dmScope is the most consequential setting.** Get it wrong, and you have either a privacy breach (`main` with multiple users) or fragmented context (`per-channel-peer` when you wanted unified). There's no middle ground that's universally right — it depends on your deployment model.

4. **Identity links solve the multi-channel fragmentation problem.** When one person uses Telegram and WhatsApp, identity links collapse their platform-specific IDs into a canonical name (`alice`). This works *within* the chosen dmScope — it doesn't override it. Under `per-channel-peer`, Alice still gets separate per-channel sessions, just with a consistent peer ID in both.

5. **Bindings enable multi-agent architectures.** One gateway routes different channels/guilds/roles to completely different agents. The binding priority cascade (peer → guild+roles → guild → team → account → channel → default) is powerful but requires care to avoid ambiguity at the same tier.

6. **The Lane Queue is what makes sessions reliable.** Two nested queues — per-session serial + global bounded parallelism — prevent both race conditions (within a session) and system overload (across sessions). The default global limit of 4 concurrent main-agent runs means heavy multi-user traffic will queue, but per-session ordering is never violated.
