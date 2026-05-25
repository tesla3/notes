# OpenClaw Routing & Binding: Deep Dive

← [OpenClaw Analysis](openclaw-analysis.md) · [Sessions Deep Dive](openclaw-sessions-deepdive.md) · [DM Routing Analysis](openclaw-dm-routing-analysis.md)

> **Sources.** Official docs (`docs.openclaw.ai`, `openclaw.dog`), config guide (`moltfounders.com`), beginner tutorials (`openclawd.wiki`), GitHub issues (#9198, #9884, #1615, #12826, #19008), GitLab advisory CVE-2026-26328, Snyk analysis, sessions deepdive (verified against source at commit `750276fa3`), DeepWiki code analysis. Cross-referenced for consistency; discrepancies noted and resolved below.

---

## The Big Picture: Three Layers, In Order

When a message arrives from any channel, OpenClaw processes it through three distinct layers. Understanding that these are **sequential** — not parallel, not interchangeable — is key to understanding the whole system.

```
Inbound message (WhatsApp / Telegram / Discord / Slack / Signal / iMessage / Teams / Google Chat)
│
▼
┌─────────────────────────────────────────────────┐
│  LAYER 1: ACCESS CONTROL (dmPolicy / groupPolicy)│
│  "Should this message be processed at all?"      │
│  Runs per-channel. Rejects or admits.            │
└────────────────────┬────────────────────────────┘
                     │ (admitted)
                     ▼
┌─────────────────────────────────────────────────┐
│  LAYER 2: AGENT ROUTING (bindings)               │
│  "Which agent handles this message?"             │
│  Deterministic tier cascade. First match wins.   │
└────────────────────┬────────────────────────────┘
                     │ (agentId resolved)
                     ▼
┌─────────────────────────────────────────────────┐
│  LAYER 3: SESSION KEY CONSTRUCTION               │
│  "Which conversation slot does it land in?"      │
│  Applies dmScope + identity links.               │
└────────────────────┬────────────────────────────┘
                     │ (session key resolved)
                     ▼
               Lane Queue → LLM execution
```

**Design choice:** These layers are intentionally decoupled. Access control is per-channel (configured under `channels.*`), agent routing is cross-channel (configured under `bindings[]`), and session key construction is per-agent (configured under `session.*`). This means you can change who gets access without changing routing, and change routing without changing session isolation. The separation is clean — until you hit edge cases where one layer's assumptions leak into another (see "Known Bugs" below).

---

## Layer 1: Access Control (Before Routing Happens)

This layer runs **before** the binding system ever sees the message. It's configured per-channel, and it governs DMs and group chats separately.

### DM Policy (`dmPolicy`)

Four modes, evaluated per-channel:

| Mode | Behavior | Use case |
|------|----------|----------|
| `"pairing"` (default) | Unknown sender gets a 6-digit code, valid 1 hour. Owner approves via `openclaw pairing approve <channel> <code>`. Message **not processed** until approved. | Personal agent — secure default |
| `"allowlist"` | Only senders in `allowFrom[]` array are processed. Everyone else silently ignored. | Team deployment with known users |
| `"open"` | Anyone can DM. Requires `"*"` in `allowFrom`. | Public-facing bots (use with extreme caution) |
| `"disabled"` | All DMs ignored. Agent only operates in groups. | Group-only deployments |

**Critical subtlety:** DM access control is **global per channel account**, not per agent. If you have two agents (`alex` and `mia`) sharing one WhatsApp number, the `allowFrom` list applies to both. You can't give Alex's WhatsApp DMs a different access policy than Mia's. The binding system routes *after* access is granted.

### Group Policy (`groupPolicy`)

Separate from DM policy. Controls which groups the agent participates in:
- `"allowlist"` — only explicitly listed groups
- `"open"` — respond in any group the bot is added to

Per-group settings can further control `requireMention` (agent only responds when @mentioned) and per-topic configuration for Telegram forum groups.

### Why This Ordering Matters

The access control layer is the **hard security boundary**. Bindings are a routing convenience — they assume the message is already authorized. This has been validated by real vulnerabilities:

- **CVE-2026-26328** (Feb 2026): Under iMessage `groupPolicy=allowlist`, group authorization was incorrectly satisfied by identities from the DM pairing store. A user who had paired for DMs was implicitly trusted for group access. DM trust leaked into group context. Fixed in v2026.2.14.

- **Issue #12826**: Slack `dm.policy: "allowlist"` with a user in `allowFrom` still triggered the pairing prompt. The access control layer had a bug where the correct policy wasn't being applied. Workaround: `dm.policy: "open"`.

These bugs show that the access control layer, while conceptually clean, is channel-adapter-specific and has had implementation gaps. Each channel adapter implements its own access checks, and the trust boundary is the adapter's correct identification of the sender (see sessions deepdive, Design Assumption #4).

---

## Layer 2: Agent Routing (The Binding System)

Once a message is admitted, the binding system determines which agent handles it. This is where the complexity lives.

### The Binding Object

A binding maps a match pattern to an agent:

```json5
{
  agentId: "work",           // Target agent
  match: {
    channel: "whatsapp",     // Required: which channel
    accountId: "biz",        // Optional: which bot account
    peer: {                  // Optional: specific conversation
      kind: "dm" | "group",
      id: "+15551234567"     // E.164 for WhatsApp, numeric for Telegram, etc.
    },
    guildId: "999888",       // Optional: Discord guild (server)
    roles: ["dev-team"],     // Optional: Discord roles (requires guildId)
    teamId: "T0123ABC",      // Optional: Slack workspace
  }
}
```

### The Tier Cascade: Reconciling the Sources

Different sources describe binding priority differently. Here's what each says:

| Source | Tiers listed |
|--------|-------------|
| **Sessions deepdive** (source-verified) | 8 tiers: peer → peer.parent → guild+roles → guild → team → account → channel → default |
| **Official docs** (openclaw.dog) | 6 tiers: peer → guildId → teamId → accountId → channel → default |
| **Config guide** (moltfounders.com) | 4 tiers: peer → guildId/teamId → accountId → default |
| **Beginner tutorial** (openclawd.wiki) | 6 tiers: peer → guildId → teamId → accountId → channel → default |

**Resolution:** The sessions deepdive is the most granular because it was verified against `src/routing/resolve-route.ts`. The other sources simplify for readability. The complete tier cascade is:

#### Tier 1: `binding.peer` — Exact conversation match
Most specific. Matches a specific DM sender or group ID on a specific channel. Always wins over everything below.

```json5
{ agentId: "opus", match: { channel: "whatsapp", peer: { kind: "dm", id: "+15551234567" } } }
```

#### Tier 2: `binding.peer.parent` — Thread inherits from parent
When a message arrives in a thread (Telegram topic, Slack thread, Discord thread), and no direct peer binding exists for the thread, the system checks if the **parent conversation** has a binding. If so, the thread inherits it.

**This is NOT configurable** — you can't set `peer.parent` in a binding rule. It's an automatic fallback behavior: "if a thread doesn't have its own peer binding, use the parent group's binding." This is why Issue #1615 requests per-topic agent routing — currently, all Telegram forum topics in a group inherit the same agent.

#### Tier 3: `binding.guild + roles` — Discord guild + role match
Discord-specific. Matches when the message comes from a specific guild AND the sender has specific roles. More specific than guild-only.

```json5
{ agentId: "codebot", match: { channel: "discord", guildId: "999888", roles: ["dev-team"] } }
```

**Design note:** The `roles` field only works in combination with `guildId`. There's no standalone role-based routing without a guild context. This makes sense — Discord roles are guild-scoped.

#### Tier 4: `binding.guild` — Discord guild match
Matches any message from a specific Discord guild, regardless of role.

```json5
{ agentId: "work", match: { channel: "discord", guildId: "999888" } }
```

#### Tier 5: `binding.team` — Slack/Teams workspace match
Matches any message from a specific Slack workspace or Teams team.

```json5
{ agentId: "work", match: { channel: "slack", teamId: "T0123ABC" } }
```

#### Tier 6: `binding.account` — Specific bot account match
Matches all messages arriving via a specific bot account (e.g., WhatsApp number "biz" vs "personal"), regardless of who sent them.

```json5
{ agentId: "work", match: { channel: "whatsapp", accountId: "biz" } }
```

#### Tier 7: `binding.channel` — Wildcard channel match
Matches all messages from a channel, any account. Equivalent to `accountId: "*"`.

```json5
{ agentId: "work", match: { channel: "googlechat" } }
```

#### Tier 8: Default agent
If no binding matches at any tier, falls back to the default agent. The default is determined by: `agents.list[].default: true`, or the first entry in `agents.list[]`, or `main` if no list exists.

### Critical Rule: First Tier Wins, Then First-Defined Wins

The tiers are evaluated **top-to-bottom** (most specific first). The first tier that has **any** match wins — all lower tiers are skipped entirely.

Within a single tier, if multiple bindings match (e.g., two `binding.guild` rules for different agents on the same guild), the code uses `Array.find()` — **first-defined-wins** based on order in the `bindings[]` array in `openclaw.json`. There is no error, no warning, no ambiguity detection. The system silently picks the first one.

**Practical implication:** Put more specific bindings before less specific ones in your config. A peer binding before a channel binding. This isn't about tier priority (that's automatic) — it's about avoiding ambiguity within the same tier.

```json5
// CORRECT: peer binding first, channel binding second
bindings: [
  { agentId: "opus", match: { channel: "whatsapp", peer: { kind: "dm", id: "+15551234567" } } },
  { agentId: "chat", match: { channel: "whatsapp" } },
]

// ALSO CORRECT: order doesn't matter here because they're different tiers
// (peer = tier 1, channel = tier 7), so peer always wins regardless of order.
// But putting specific ones first is a good habit for readability.
bindings: [
  { agentId: "chat", match: { channel: "whatsapp" } },
  { agentId: "opus", match: { channel: "whatsapp", peer: { kind: "dm", id: "+15551234567" } } },
]
// This still routes +15551234567 to opus, because peer (tier 1) > channel (tier 7).
```

### What Bindings Do NOT Match On

Understanding the gaps is as important as the features:

- **No sender identity matching** — bindings use raw platform IDs, not identity-linked canonical names. If Alice is `telegram:111111` and you bind `peer.id: "alice"`, it won't work. Identity links are applied in Layer 3 (session key construction), not Layer 2.
- **No content/intent matching** — bindings are purely structural (who, where, which account). No routing based on message content.
- **No time-based routing** — can't route to different agents at different times of day.
- **No per-topic routing** (requested in Issue #1615) — Telegram forum topics inherit the group's binding. Session keys do include topic isolation, but agent selection doesn't.
- **No role-based routing outside Discord** — `roles` only works with Discord `guildId`. Slack and Teams have no equivalent.

---

## Layer 3: Session Key Construction

After Layer 2 determines the agent, Layer 3 builds the session key — the deterministic string that identifies which conversation slot this message belongs to. This is implemented in `buildAgentPeerSessionKey()` in `src/routing/session-key.ts`.

### For DMs: dmScope Controls Everything

| dmScope | Key pattern | Identity link effect |
|---------|-------------|---------------------|
| `"main"` (default) | `agent:<agentId>:<mainKey>` | Irrelevant — all DMs collapse to one session |
| `"per-peer"` | `agent:<agentId>:direct:<peerId>` | `<peerId>` becomes canonical name (e.g., `alice`) |
| `"per-channel-peer"` | `agent:<agentId>:<channel>:direct:<peerId>` | `<peerId>` becomes canonical name |
| `"per-account-channel-peer"` | `agent:<agentId>:<channel>:<accountId>:direct:<peerId>` | `<peerId>` becomes canonical name |

### For Groups, Channels, and Threads: dmScope Is Irrelevant

Groups, channels, and threads always get their own session key regardless of dmScope:

```
agent:<agentId>:<channel>:group:<groupId>                    Groups
agent:<agentId>:<channel>:channel:<channelId>                Channels/rooms
agent:<agentId>:<channel>:group:<groupId>:thread:<threadId>  Threads/topics
```

**Design choice:** This makes sense. A group chat is shared by definition — there's no ambiguity about "whose session is this?" It's the group's session. DMs are where the ambiguity lives (whose perspective? one shared conversation or per-person?), hence the dmScope knob.

### Identity Links: Canonicalization, Not Routing

Identity links are configured under `session.identityLinks`:

```json5
session: {
  identityLinks: {
    alice: ["telegram:111111", "whatsapp:+1555000111"],
    bob: ["discord:222222"],
  }
}
```

They replace the platform-specific peer ID with the canonical name **only in the session key**. They do NOT affect:
- Access control (Layer 1) — still uses raw platform IDs
- Agent routing (Layer 2) — bindings use raw platform IDs
- Which channel the reply goes to — replies go back to the originating channel

**What identity links solve:** Without them, Alice on Telegram gets key `agent:molty:telegram:direct:111111` and Alice on WhatsApp gets `agent:molty:whatsapp:direct:+1555000111`. These are completely unrelated strings. If you're using `per-peer` scope wanting cross-channel unity, you'd get `agent:molty:direct:111111` and `agent:molty:direct:+1555000111` — still separate, because the raw IDs are different. Identity links collapse both to `agent:molty:direct:alice`.

**What identity links don't solve:** Under `per-channel-peer`, identity links still give you separate sessions per channel (`agent:molty:telegram:direct:alice` ≠ `agent:molty:whatsapp:direct:alice`). The canonical name makes the keys readable and consistent, but channel isolation still applies. This is intentional — see sessions deepdive for the rationale (Alice might have different privacy expectations per platform).

---

## Worked Examples

### Example 1: The Simplest Setup (Single Agent, No Bindings)

```json5
{
  agent: { workspace: "~/.openclaw/workspace", model: "anthropic/claude-sonnet-4-5" },
  channels: { whatsapp: { dmPolicy: "pairing", allowFrom: ["+15551234567"] } }
}
```

**What happens when +15551234567 DMs:**
1. Access control: `dmPolicy: "pairing"`, user is in `allowFrom` → admitted
2. Routing: No bindings → default agent `main`
3. Session key: default `dmScope: "main"` → `agent:main:main`

**What happens when a stranger DMs:**
1. Access control: unknown sender → pairing code issued, message NOT processed
2. Routing/session: never reached

### Example 2: Multi-Agent Split by Channel

```json5
{
  agents: { list: [
    { id: "chat", model: "anthropic/claude-sonnet-4-5" },
    { id: "opus", model: "anthropic/claude-opus-4-5" },
  ]},
  bindings: [
    { agentId: "chat", match: { channel: "whatsapp" } },
    { agentId: "opus", match: { channel: "telegram" } },
  ]
}
```

- WhatsApp DM → tier 7 (channel) → `chat` → session key depends on dmScope
- Telegram DM → tier 7 (channel) → `opus` → session key depends on dmScope
- Discord DM → no binding match → default agent (first in list = `chat`)

**Design insight:** The default agent fallback is important here. If you forget to bind a channel, messages don't get dropped — they silently go to the default agent. This is a convenience that can also be a surprise. The Google Chat bug (Issue #9198) showed a channel adapter that bypassed bindings entirely, always falling to default.

### Example 3: One WhatsApp Number, Two People, Full Isolation

```json5
{
  agents: { list: [
    { id: "alex", workspace: "~/.openclaw/workspace-alex" },
    { id: "mia", workspace: "~/.openclaw/workspace-mia" },
  ]},
  bindings: [
    { agentId: "alex", match: { channel: "whatsapp", peer: { kind: "dm", id: "+15551230001" } } },
    { agentId: "mia",  match: { channel: "whatsapp", peer: { kind: "dm", id: "+15551230002" } } },
  ],
  channels: { whatsapp: { dmPolicy: "allowlist", allowFrom: ["+15551230001", "+15551230002"] } }
}
```

- +15551230001 DMs → tier 1 (peer) → agent `alex`
- +15551230002 DMs → tier 1 (peer) → agent `mia`
- Both reply from the same WhatsApp number (no per-agent sender identity)
- Each agent has its own workspace, memory, sessions, auth profiles — full isolation

**Official docs caveat:** "direct chats collapse to the agent's main session key, so true isolation requires one agent per person." This means with default `dmScope: "main"`, Alex's session key is `agent:alex:main` and Mia's is `agent:mia:main`. The isolation comes from the agent boundary, not the session key.

### Example 4: Discord Guild + Role Routing

```json5
{
  agents: { list: [
    { id: "molty", default: true },
    { id: "codebot" },
  ]},
  bindings: [
    { agentId: "codebot", match: { channel: "discord", guildId: "999888", roles: ["dev-team"] } },
  ]
}
```

**Scenario:** Bob (has `dev-team` role) posts in guild 999888, group `#project-alpha`:
1. Access control: group policy allows it
2. Routing: tier 3 (guild+roles) → `codebot`
3. Session key: `agent:codebot:discord:group:555555`

**Scenario:** Carol (has `marketing` role, not `dev-team`) posts in same guild:
1. Routing: tier 3 doesn't match (wrong role), tier 4 (guild-only) — no guild-only binding exists, falls through all tiers → default agent `molty`
3. Session key: `agent:molty:discord:group:555555`

**Wait — same group, different agents?** Yes. Bob's messages in `#project-alpha` go to codebot, Carol's go to molty. They share the same Discord channel but get routed to different agents based on their roles. The session keys are different because the agent ID differs. This means the group conversation is **split** — codebot sees Bob's messages but not Carol's, and vice versa. Whether this is useful or confusing depends on the deployment.

### Example 5: Thread Inheritance (Tier 2 in Action)

```json5
bindings: [
  { agentId: "codebot", match: { channel: "telegram", peer: { kind: "group", id: "-100123456789" } } },
]
```

A Telegram forum group (`-100123456789`) has topics. Topic 42 gets a message.

1. Routing: tier 1 — no peer binding for topic 42 specifically
2. Routing: tier 2 — check parent: the parent group `-100123456789` has a peer binding → **inherits** → `codebot`
3. Session key: `agent:codebot:telegram:group:-100123456789:thread:42`

All topics in this group route to `codebot`. You can't currently route topic 42 to a different agent (Issue #1615). The session keys are separate (topic isolation), but the agent affinity is shared.

### Example 6: The Outbound Identity Problem

From Issue #9884: Bindings only control **inbound** routing. When an agent sends an outbound message, it uses the channel's **default** account — not the account that the binding matched on for inbound.

```json5
{
  agents: { list: [{ id: "agent-a" }] },
  bindings: [
    { agentId: "agent-a", match: { channel: "discord", accountId: "agent-a-bot" } },
  ],
  channels: { discord: { accounts: { "default-bot": {...}, "agent-a-bot": {...} } } }
}
```

- Inbound: message arrives via `agent-a-bot` → binding matches → routed to `agent-a` ✓
- Outbound: `agent-a` replies → uses `default-bot` identity ✗

The binding system is **inbound-only**. Outbound identity requires either:
- Explicit `accountId` parameter in every `message` tool call (tedious, error-prone)
- The proposed `defaultAccountId` per-agent config (not yet implemented)
- Prompt engineering ("always use accountId=agent-a-bot when sending")

**Design gap:** Inbound routing is automatic and deterministic. Outbound identity is manual and fragile. The system has asymmetric routing — bindings route inward but don't inform outward delivery.

---

## Design Choices & Assumptions

### 1. Specificity Over Configuration Order

The tier cascade means you don't need to worry about binding order for *cross-tier* cases. A peer binding always beats a channel binding regardless of where they appear in the array. This is a good design — it reduces configuration errors. The only case where order matters is *within* a tier (same-specificity conflicts), which is an edge case most users won't hit.

**Contrast with nginx:** nginx evaluates location blocks in a complex mix of prefix matching, regex order, and exact matches. OpenClaw's tier system is simpler and more predictable.

### 2. No Negative Bindings

You can't say "route everything from WhatsApp to `work` EXCEPT this one group." You'd need to explicitly bind the exception to another agent at a higher tier (peer binding for the group → different agent, channel binding for WhatsApp → `work`). This works because tier 1 beats tier 7, but it's not immediately obvious to users.

### 3. Channel Adapters Own Identity

The system trusts each channel adapter to correctly identify the sender. There's no cross-channel identity layer at the routing level. Identity links exist but they're Layer 3 only — they affect session keys, not routing decisions. If a Telegram adapter reports the wrong sender ID, the message routes to the wrong agent and session with no detection.

### 4. Agent Isolation Is Deep

Each agent is truly isolated: separate workspace (files, `AGENTS.md`, `SOUL.md`), separate auth profiles (`auth-profiles.json`), separate session store, separate memory. The binding system determines which isolated world a message enters. Crossing agent boundaries requires explicit `tools.agentToAgent.enabled: true` and an allowlist — off by default.

### 5. Access Control and Routing Are Decoupled

`dmPolicy`/`groupPolicy` are per-channel config. `bindings[]` are top-level config. You can have 10 binding rules but if `dmPolicy: "disabled"`, no DMs reach any of them. This is clean but can confuse users who expect a binding to implicitly grant access.

### 6. The "Main Session" Default Is a Solo Optimization

The default `dmScope: "main"` with no bindings creates a single funnel: every DM from every channel lands in `agent:main:main`. This is optimized for one person with one agent — minimum configuration, maximum context continuity. The moment you add a second user or a second agent, this default becomes dangerous. The system doesn't detect or warn about this transition.

---

## Known Bugs & Edge Cases

### Google Chat Bypasses Bindings (Issue #9198)

Google Chat DM handling for paired users bypasses the binding evaluation layer entirely, collapsing directly to `agent:main:main`. Channel-level, peer-level, and even default-agent-swap bindings are all ignored. The user verified that `openclaw agents list --bindings` correctly shows the binding, and the work agent responds to manual `--deliver` commands — only inbound Google Chat DMs ignore bindings. Hypothesis: the Google Chat adapter sends messages through a different code path that skips `resolveAgentRoute()`.

**Implication:** The binding system's guarantees depend on each channel adapter correctly calling the routing pipeline. If an adapter has a bug, bindings silently fail and messages go to the default agent. There's no centralized enforcement point — each adapter must opt in to routing.

### iMessage DM Trust Leaks into Groups (CVE-2026-26328)

Under iMessage `groupPolicy=allowlist`, group authorization was satisfied by identities from the DM pairing store. A user who had paired for DMs was implicitly trusted for group access. This crossed the boundary between Layer 1's DM and group access control.

### Slack Allowlist Shows Pairing Prompt (Issue #12826)

Even with `dm.policy: "allowlist"` and a valid user ID in `allowFrom`, the Slack adapter still triggered the pairing prompt. The access control logic wasn't correctly recognizing the allowlist mode. Workaround: `dm.policy: "open"`.

### Discord Actions Skip Authorization (Issue #19008, CVSS 7.6 High)

The `message` tool exposes Discord guild-admin and moderation actions (channel-delete, kick, ban) to any sender who can induce tool execution — no sender-role check. This is a Layer 2/3 gap: the binding system routes based on roles, but the tool execution layer doesn't re-check roles before performing privileged operations. A non-owner user in an allowed conversation can trigger bot-privileged Discord operations through prompt injection.

### Outbound Identity Mismatch (Issue #9884)

Bindings route inbound messages to the correct agent via the correct account, but outbound messages use the default account. No symmetric routing exists.

---

## Summary: What Makes This Design Work (and Where It Creaks)

**What works well:**
- The tier cascade is elegant. Specificity-based routing eliminates most ordering bugs.
- Access control before routing is the correct layering. You can't route what you've already rejected.
- Agent isolation is deep and real. Separate workspace, auth, sessions, memory.
- dmScope gives 4 granularity levels for the exact problem (DM session isolation) that matters most.
- Identity links solve multi-channel identity without complicating routing.

**Where it creaks:**
- Each channel adapter must correctly implement both access control and routing pipeline calls. Bugs in individual adapters can silently break both (Google Chat, Slack, iMessage CVE).
- Outbound routing doesn't mirror inbound routing. Bindings are half a solution.
- No ambiguity detection within a tier. Silent first-match behavior can mask configuration errors.
- No negative bindings ("everything except X"). Requires thinking in terms of tier precedence.
- Thread/topic routing is inherited, not configurable. Limits multi-agent use within a single group.
- The default configuration (`dmScope: "main"`, no bindings, single agent) is optimized for solo use but creates a hidden cliff when adding users. No guardrails at the transition point.

**The fundamental design assumption:** This is a personal-scale system (1–10 users). The binding system is powerful enough for that scale but would need secondary indices, ambiguity detection, a routing debugger, and outbound symmetry to work at enterprise scale. For what it is — a personal AI gateway — the routing is surprisingly well-thought-out.
