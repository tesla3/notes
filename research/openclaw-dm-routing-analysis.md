# OpenClaw DM Routing: Accuracy-Checked Analysis

← [OpenClaw Analysis](openclaw-analysis.md) · [Sessions Deep Dive](openclaw-sessions-deepdive.md) · [Routing & Binding Deep Dive](openclaw-routing-binding-deepdive.md)

---

## What "DM" Means in OpenClaw

DM = **Direct Message** — private messages sent to an agent on any channel (Telegram, WhatsApp, Discord, etc.), as opposed to group chats or channel posts.

### DM Pairing (Security Mitigation)

Unknown senders receive a **pairing code** and their messages are **not processed** until they authenticate. Prevents random strangers from interacting with the agent.

---

## How DM Routing & Session Matching Works

When a DM arrives, `resolveAgentRoute()` (in `src/routing/resolve-route.ts`) runs this pipeline:

1. **Normalize** the channel, account ID, peer kind (`direct`), and peer ID
2. **Check bindings** — explicit routing rules evaluated in priority tiers (first tier with any match wins, lower tiers never checked):
   - `binding.peer` (exact peer match)
   - `binding.peer.parent` (thread inherits from parent)
   - `binding.guild+roles` (Discord guild + role)
   - `binding.guild` (Discord guild)
   - `binding.team` (Teams team)
   - `binding.account` (specific account)
   - `binding.channel` (wildcard account)
   - `default` (fallback to default agent)
3. **Build the session key** via `buildAgentPeerSessionKey()`, applying dmScope and identity links
4. **Build the main session key** for reference (always `agent:<agentId>:main`)

Within a single tier, if multiple bindings match, `Array.find()` picks **first-defined-wins** by config file order. No error or warning for ambiguous bindings.

Result: `{ agentId, channel, accountId, sessionKey, mainSessionKey, matchedBy }`

---

## dmScope: The Most Consequential Setting

All four options:

| dmScope | Session key pattern | Effect |
|---------|-------------------|--------|
| `main` **(default)** | `agent:<agentId>:<mainKey>` | All DMs from all people share one session — **data leak for multi-user** |
| `per-peer` | `agent:<agentId>:direct:<peerId>` | Isolated per person, unified across platforms |
| `per-channel-peer` | `agent:<agentId>:<channel>:direct:<peerId>` | Isolated per person per platform |
| `per-account-channel-peer` | `agent:<agentId>:<channel>:<accountId>:direct:<peerId>` | Isolated per person per platform per bot account |

### The Dangerous Default

The default `main` dmScope pools **every person's DMs into a single session** with a shared transcript. Fine for solo use. Silent data leak the moment a second user DMs the agent. The system doesn't warn about this during setup. Called out in the source as "the single most likely misconfiguration in a real deployment."

`per-channel-peer` is the recommended safe default for multi-user deployments.

---

## Identity Links

Identity links map platform-specific IDs to a canonical name:

```json
{
  "alice": ["telegram:111111", "whatsapp:+1555000111"],
  "bob": ["discord:222222"]
}
```

This replaces the raw platform peer ID with the canonical name in the session key. Works *within* the chosen dmScope — does not override it.

### Example: Alice on Two Platforms (dmScope = `per-channel-peer`)

- Telegram `111111` → identity `alice` → key: `agent:molty:telegram:direct:alice`
- WhatsApp `+1555000111` → identity `alice` → key: `agent:molty:whatsapp:direct:alice`

These are **separate sessions** — intentionally. Alice might share WhatsApp with family but keep Telegram private. Per-channel isolation prevents context leaks across platforms.

To unify them into one session, use `per-peer` → both collapse to `agent:molty:direct:alice`.

---

## Provenance

This analysis was cross-checked against:
- `openclaw-analysis.md` — section 3 (Security) for DM pairing
- `openclaw-sessions-deepdive.md` — Key Taxonomy, Routing Pipeline, Molty walkthrough, Known Tensions §2

All claims verified against the sessions deepdive, which itself was verified against OpenClaw source code at commit `750276fa3`.
