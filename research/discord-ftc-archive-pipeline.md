← [Dev Tools](../topics/dev-tools.md) · [Index](../README.md)

# Discord FTC Archive Pipeline — Research & Plan

**Created:** 2026-03-17. **Revised:** 2026-03-18. **Status:** Planning — architecture selected, critical blockers must be resolved before building.

---

## Goal

Make historical FTC Discord conversations accessible and searchable by an AI agent (Claude/pi) for research, learning, and question-answering. Not a one-time dump — a maintained, incrementally updated archive.

**Requirements (from discussion):**
1. Searchable by AI agent — keyword and semantic search
2. Periodic/on-demand incremental sync (rate limits make full re-fetches impractical)
3. Organized and filterable by date, user ID
4. Enrichment/transformation: not immediately needed, keep the door open

---

## Target Servers

| Invite Link | Likely Purpose |
|-------------|---------------|
| discord.gg/ftc | Official FTC community |
| discord.gg/k64bJNj | Unknown — needs verification |
| discord.gg/2GfC4qBP5s | Unknown — needs verification |
| discord.gg/yass | Unknown — needs verification |
| discord.gg/frc | FRC (FIRST Robotics Competition) community |

**⚠️ Unverified:** Server names, sizes, and channel counts not yet confirmed. Size matters — a 50-person server is trivial; a 10k+ server with years of history takes hours due to Discord API rate limits (~5 req/5s per channel for message history).

**Access method per server:** Some servers may not allow adding a bot (you're a member, not admin). Identify which servers require a **user token** fallback vs. bot token. See [Authentication](#authentication).

---

## Architecture Decision: DiscordChatExporter → Markdown → QMD

### Options Evaluated

| Approach | Pros | Cons | Verdict |
|----------|------|------|---------|
| **discord.py custom script** | Full control, direct-to-SQLite | Reimplements pagination, rate limiting, thread discovery. Significant custom code. | ❌ Rejected — reimplements solved problems |
| **DiscordChatExporter → custom SQLite + FTS5** | Structured queries, incremental via high-water mark | Must build search layer, FTS5 setup, query interface | ❌ Superseded by QMD |
| **DiscordChatExporter → Markdown → QMD** | QMD handles FTS5 + vector + reranking. CLI + MCP for agent access. | Depends on QMD. Non-trivial converter code. | ✅ Selected |

### Why This Architecture

1. **DiscordChatExporter** is mature, actively maintained (10k+ stars), handles all Discord API complexity: pagination, rate limiting, thread discovery (active + archived + forum), attachments. Supports `--after` for incremental pulls and `--include-threads All`. No reason to rewrite this.

2. **QMD** ([evaluation](qmd-evaluation-and-context-connection.md)) is already the selected local knowledge search tool. It provides FTS5 keyword search, vector semantic search (sqlite-vec), hybrid search with LLM reranking, smart markdown chunking, and a CLI/MCP interface designed for AI agents. Building a custom SQLite + FTS5 solution would be strictly worse.

3. **Custom code required:** a converter (DiscordChatExporter JSON → structured markdown) and a sync wrapper (per-channel state tracking, incremental export orchestration, merge logic, `qmd update` trigger). This is a real project — estimated 500–800 lines of Python — not a thin glue script. See [Converter Scope](#converter-scope) for the full requirements.

### Pipeline

```
Discord API
    │
    ▼
DiscordChatExporter (--after DATE --include-threads All -f Json)
    │  (per-channel loop with crash resume — see Sync Strategy)
    ▼
JSON export files (one per channel per run)
    │
    ▼
Converter script (JSON → organized markdown, dedup by message ID)
    │
    ▼
discord-archive/
├── ftc-discord/
│   ├── general/
│   │   ├── 2025-03-15.md
│   │   └── 2025-03-16.md
│   ├── programming/
│   │   └── ...
│   └── threads/
│       ├── t-123456789-how-to-tune-pid.md   ← thread ID in filename
│       └── ...
├── ftc-unofficial/
│   └── ...
└── .sync-state.json   ← per-channel last-exported timestamp + message ID
    │
    ▼
qmd collection add discord-archive/ftc-discord --name ftc-discord
qmd update && qmd embed
    │
    ▼
qmd query "PID tuning"           # hybrid + reranking
```

---

## Critical Blocker: `--after` Behavior with Threads

**This must be resolved before building anything.** The entire incremental sync strategy depends on the answer.

`--after DATE` in DiscordChatExporter filters messages for channel exports. The open question: **how does it interact with threads?**

| Scenario | Behavior | Consequence |
|----------|----------|-------------|
| **A: Filters by thread creation date** | Thread created March 1, new messages March 15. Sync with `--after March 10` → thread is skipped entirely. | **Incremental sync is broken for ongoing threads.** New messages in old threads are silently lost. |
| **B: Filters by message date within threads** | Same scenario → only March 15 messages are exported from the thread. | Works, but converter must **merge** new messages into existing thread files, matching by message ID. |
| **C: Threads are always fully re-exported** | `--after` is ignored for threads. | Wastes API calls but is safe. Converter must dedup. |

**Action required:** Run a controlled test — export a thread, post a new message, re-export with `--after` set between the old and new messages. Observe what DiscordChatExporter returns. Document the actual behavior here.

**Fallback if Scenario A:** Must export threads separately without `--after`, or track per-thread high-water marks and fetch threads individually. This significantly complicates the sync wrapper.

---

## Markdown Format Design

QMD's smart chunking scores heading boundaries highly (H1=100, H2=90, H3=80). The markdown structure should exploit this for clean chunk boundaries.

### Thread files (one file per thread)

Threads are natural conversation units. Filename includes thread ID for stable identity (thread titles can be renamed).

```markdown
# Thread: How to tune PID controller
Channel: #programming | Started: 2025-03-10 | Server: FTC | Thread ID: 123456789

## user1 — 2025-03-10 14:00 <!-- msg:111111111 -->
How do I tune a PID controller for our drivetrain?

## user2 — 2025-03-10 14:05 <!-- msg:222222222 -->
> ↩ user1: How do I tune a PID controller for our drivetrain?

Start with P only. Set I and D to zero...
```

### Channel files (one file per channel per day)

```markdown
# #general — 2025-03-15
Server: FTC

## user1 — 10:30 <!-- msg:333333333 -->
Message content here

## user2 — 10:32 <!-- msg:444444444 -->
> ↩ user1: Message content here

Reply content here
```

### Design rationale

- **H1** carries context (channel, server, date) — every QMD chunk inherits this via title extraction
- **H2** per message gives 90-score break points for QMD's chunking algorithm
- **Author and timestamp** in the H2 line make them searchable via both `rg` and FTS5
- **Message ID** in HTML comment (`<!-- msg:ID -->`) enables dedup on incremental merge, edit tracking, and linking back to Discord. HTML comments are invisible to rendered markdown and QMD search but greppable with `rg`
- **Reply context** (`> ↩ user1: ...`) as a blockquote preserves conversational context. Without this, search hits on answers are orphaned from their questions. Truncate parent message to ~100 chars to keep chunks focused
- **Thread ID in filename** (`t-123456789-how-to-tune-pid.md`) provides stable identity. Thread titles can change; the Discord thread ID cannot
- Flat text, no nested structure — maximizes `rg` usability

### File granularity

One file per thread is natural and decided. One file per channel per day for main channel messages is the proposal — could also be per-week or per-month depending on message volume. **Needs data** on actual message density per channel before finalizing.

---

## Authentication

DiscordChatExporter supports both bot tokens and user tokens.

| Method | Access | Setup | Risk |
|--------|--------|-------|------|
| **Bot token** | Servers where you can add the bot (need admin or invite permission) | Developer Portal → New Application → Bot → copy token | None — standard API usage |
| **User token** | Any server you're a member of, including ones where you can't add a bot | Extract from browser DevTools or Discord client | Violates Discord TOS. Risk of account suspension. |

**Recommendation:** Use a bot token for all servers where possible. For servers where you can't add a bot, decide explicitly whether to use a user token and accept the TOS risk, or skip that server.

### Bot setup

- **One bot token works across all servers.** A single bot application can be invited to multiple guilds.
- **Permissions needed:** `Read Message History`, `View Channels`, `Manage Threads` (for private archived threads)
- **Setup:** Discord Developer Portal → New Application → Bot tab → copy token → OAuth2 URL Generator → `bot` scope → select permissions → generate invite link per server
- **⚠️ User status:** User said "let me check" whether they have an existing bot. Not yet confirmed.

---

## Discord API — Thread Fetching (Reference)

Documented here because the API has non-obvious structure:

| Thread Type | Endpoint | Scope | Pagination |
|-------------|----------|-------|------------|
| Active threads | `GET /guilds/{guild_id}/threads/active` | Guild-wide, single call | None (returns all) |
| Archived public | `GET /channels/{channel_id}/threads/archived/public` | Per-channel | `before` (ISO8601 of `archive_timestamp`), `limit` |
| Archived private | `GET /channels/{channel_id}/threads/archived/private` | Per-channel, needs `MANAGE_THREADS` | Same as above |
| Forum posts | Same as archived threads | Per forum channel | Same as above |

**Key facts:**
- Archived threads are per-channel — must iterate every text/announcement/forum channel
- Threads archived before the bot joined ARE accessible (archived threads persist in the API)
- Forum channel posts are threads — use `archived_threads()` on forum channels
- Rate limits: ~50 req/s global, ~5 req/5s per route for message history
- DiscordChatExporter handles all of this. Listed here for reference if debugging is needed.

---

## Incremental Sync Strategy

### Sync state design

`.sync-state.json` tracks state **per channel** (not per guild — a per-guild timestamp loses data on partial failures):

```json
{
  "guilds": {
    "guild_id_1": {
      "name": "FTC",
      "channels": {
        "channel_id_1": {
          "name": "general",
          "last_message_id": "123456789",
          "last_sync": "2025-03-16T00:00:00Z",
          "status": "ok"
        },
        "channel_id_2": {
          "name": "programming",
          "last_message_id": "987654321",
          "last_sync": "2025-03-16T00:00:00Z",
          "status": "ok"
        }
      }
    }
  }
}
```

### Sync loop

1. For each guild, iterate channels
2. Per channel: `discordchatexporter export --channel {id} --after {last_message_id} --include-threads All -f Json`
3. Converter processes JSON → markdown, deduplicating by message ID against existing files
4. On success: update that channel's entry in `.sync-state.json` (atomic write: write to `.sync-state.json.tmp`, then rename)
5. On failure: log error, skip channel, continue to next. Failed channel retries on next sync run with its unchanged high-water mark.
6. After all channels: `qmd update && qmd embed`

### Crash recovery

Because state is per-channel and only advanced after successful export + conversion:
- Crash mid-sync → completed channels are up to date, incomplete channels retry from their last good state
- No duplicates (converter deduplicates by message ID)
- No missed messages (high-water mark only advances on success)

### Thread-specific sync

**Depends on resolving the [critical blocker](#critical-blocker---after-behavior-with-threads).** Possible strategies once behavior is known:

- **If `--after` works per-message within threads:** The standard per-channel sync loop handles threads automatically. Converter merges new messages into existing thread files by message ID.
- **If `--after` skips old threads entirely:** Must maintain a separate per-thread high-water mark. On each sync, list all threads (active + recently archived), and re-export threads that have new messages since their last sync. Significantly more complex.

### Known limitations

- **Message edits:** DiscordChatExporter exports current message state. If a message was edited after initial export, the incremental run won't re-fetch it (it's already past the high-water mark). Edits are silently lost. Acceptable tradeoff for now — full re-export on a schedule (e.g., monthly) could catch edits if needed.
- **Message deletions:** Same issue. Deleted messages remain in the archive. This is arguably a feature (preserves history) but should be understood.
- **Thread archival/unarchival:** A thread archived between syncs may or may not appear in subsequent exports depending on DiscordChatExporter's thread discovery logic. Needs testing.

---

## Converter Scope

The converter is the most significant piece of custom code. Framing it as "simple" would lead to a wrong build estimate.

### Requirements

| Responsibility | Details |
|---------------|---------|
| **Parse JSON** | DiscordChatExporter's JSON schema: messages, embeds, attachments, reactions, mentions, replies, system messages |
| **Resolve Discord markup** | `<@123456789>` → `@username`, `<#channel_id>` → `#channel-name`, `<t:timestamp:F>` → human-readable datetime, `:custom_emoji:` → text placeholder or skip |
| **Reply context** | Extract parent message content for reply-to messages. Truncate to ~100 chars. Include as blockquote. |
| **Message ID tracking** | Embed message ID in HTML comment for dedup, edit tracking, and cross-referencing |
| **Merge logic** | On incremental sync: read existing markdown file, parse out existing message IDs, append only new messages, maintain chronological order |
| **File naming** | Channel files: `{channel-name}/{YYYY-MM-DD}.md`. Thread files: `threads/t-{thread_id}-{slugified-title}.md` (ID for stability, title for readability) |
| **Bot/system message filtering** | See [Message Filtering](#message-filtering) |
| **Attachment handling** | See [Attachments and Media](#attachments-and-media) |

### Estimated scope

500–800 lines of Python. Non-trivial state management for merge logic. Should have tests for the merge/dedup path — bugs there cause data loss or duplication that's hard to detect after the fact.

---

## Message Filtering

FTC Discords likely have bots posting match schedules, team registrations, scoring results, moderation actions, welcome messages, and role assignment confirmations.

### Strategy

| Message type | Action | Rationale |
|-------------|--------|-----------|
| **Regular user messages** | Include | Core content |
| **Bot messages — informational** (match results, schedules, official announcements) | Include | High-value reference data |
| **Bot messages — noise** (welcome, role assignment, "please read #rules") | Exclude | Pollutes search results |
| **System messages** (user joined, boosted server, pinned message) | Exclude | No search value |

**Implementation:** Filter by message type field in DiscordChatExporter JSON. For bot messages, decide per-bot after inspecting actual content during server verification. Start with a simple allowlist/blocklist of bot user IDs, refined after initial export.

---

## Attachments and Media

Discord switched to signed, expiring CDN URLs in late 2023. Image and file links in exported messages **will break within hours to days**.

### Options

| Approach | Storage cost | Durability | Complexity |
|----------|-------------|------------|------------|
| **Ignore attachments** | None | Links break | None |
| **Download with `--media`** | Potentially tens of GB for media-heavy servers | Durable | Low (DiscordChatExporter handles download) but high storage |
| **Download selectively** | Moderate | Durable for selected types | Medium — must filter by file type/size |

### Recommendation

For the initial build: **download attachments with `--media`** for the first server, observe actual storage usage, then decide whether to filter. FTC channels are full of robot photos, CAD screenshots, and wiring diagrams — these have genuine reference value.

In the markdown output, reference downloaded media by relative path rather than Discord CDN URL.

---

## Initial Export — Resumability

The first full export of a large FTC Discord (10k+ members, years of history) could take **4–8 hours** due to rate limits. DiscordChatExporter does not checkpoint — a failed run starts fresh.

### Mitigation

The per-channel sync loop (see [Sync Strategy](#sync-loop)) doubles as the resume strategy:
1. Export channel by channel, not the entire guild at once
2. After each successful channel export + conversion, update `.sync-state.json`
3. If the process dies at channel 50 of 100, restart → channels 1–49 are already marked as synced, export resumes from channel 50

This means the sync wrapper should handle both initial and incremental exports with the same code path. No separate "full export" mode needed.

---

## QMD Collection Strategy

| Approach | Pros | Cons |
|----------|------|------|
| One collection per server | Scoped search, smaller index | Must specify collection for cross-server queries |
| One collection for all FTC servers | Unified search across all communities | Larger index, no server-level filtering without QMD metadata support |

**Recommendation:** Start with one collection per server (`ftc-discord`, `frc-discord`, etc.). QMD supports searching multiple collections in a single query (`"collections": ["ftc-discord", "frc-discord"]`), so unified search is still possible without merging indexes.

Re-indexing time scales with collection size. Monitor `qmd embed` duration as the archive grows. If it becomes slow, consider splitting large servers by channel category.

---

## Open Questions (Must Resolve Before Building)

### P0 — Blocks architecture

1. **`--after` behavior with threads.** Must test empirically. See [Critical Blocker](#critical-blocker---after-behavior-with-threads). Everything downstream depends on this.
2. **Does the user have a Discord bot application?** Status: "let me check" — not yet confirmed. Required for any export.
3. **Server access method per server.** Which of the 5 servers allow adding a bot? Which require user token? Which should be skipped?

### P1 — Blocks build estimate

4. **Server verification.** Join the 5 invite links, confirm server names, sizes, channel counts. Determines data volume and time estimates.
5. **File granularity.** One file per channel per day vs. per week vs. per month — depends on message density. Need data from server verification.
6. **DiscordChatExporter installation.** Requires .NET runtime. Is dotnet installed? Preferred install method?

### P2 — Needed before deployment

7. **Storage location.** Where should `discord-archive/` live? Inside `pi-place/notes`? Separate repo? Home directory?
8. **Attachment storage budget.** How much disk space is acceptable for downloaded media?
9. **Bot message filtering.** Which bots are present on target servers? Which produce valuable content vs. noise?

### Resolved

- **QMD installation status:** ✅ Installed and working (confirmed 2026-03-18). No collections indexed yet.
- **Architecture selection:** ✅ DiscordChatExporter → Markdown → QMD.

---

## What's NOT in Scope (Decided)

- **Custom discord.py fetcher** — rejected in favor of DiscordChatExporter
- **Custom SQLite + FTS5 search** — superseded by QMD
- **Vector search from scratch** — QMD handles this
- **Enrichment/transformation** — not needed now, architecture doesn't preclude adding later
- **Real-time streaming** — on-demand periodic sync is sufficient
- **Edit/deletion tracking** — accepted as a known limitation. Full re-export on a schedule can backfill if needed later.

---

## Sources

| Source | Used For |
|--------|----------|
| [Discord API docs](https://discord.com/developers/docs) | Thread endpoints, pagination, bot permissions, CDN URL expiry |
| [DiscordChatExporter](https://github.com/Tyrrrz/DiscordChatExporter) | Fetch layer — capabilities, CLI flags, limitations |
| [QMD README](../qmd/README.md) | Search layer — architecture, chunking algorithm, score breakpoints |
| [QMD evaluation](qmd-evaluation-and-context-connection.md) | Prior assessment of QMD for local knowledge search |
| [Workflow: Minimal Composable Systems](workflow-minimal-composable-systems.md) | Planning methodology — first-order questions, narrowest useful version |
