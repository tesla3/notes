← [Dev Tools](../topics/dev-tools.md) · [Index](../README.md)

# Discord FTC Archive Pipeline — Research & Plan

**Created:** 2026-03-17. **Revised:** 2026-03-18. **Status:** Planning — architecture selected, ready to build.

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

---

## Architecture Decision: discord.py-self → Markdown → QMD

### Options Evaluated

| Approach | Pros | Cons | Verdict |
|----------|------|------|---------|
| **DiscordChatExporter → Markdown → QMD** | Mature CLI, handles threads/attachments | **Actively detected by Discord as of March 2026** — missing `x-super-properties` header. Fix PRs (#1507, #1510) unmerged. Requires .NET runtime. | ❌ Rejected — broken for user token use |
| **DiscordChatExporter → custom SQLite + FTS5** | Structured queries | Same detection problem + must build search layer | ❌ Rejected |
| **discord.py-self → Markdown → QMD** | Proper client emulation (sends `X-Super-Properties`, `Sec-CH-UA`, dynamic build numbers). Rate limiting built in. Direct Python objects — no JSON parsing step. `clean_content` resolves mentions. `message.reference.resolved` gives reply context. Full control over incremental sync. | More custom code than DCE wrapper (~800–1200 LOC). Must implement thread discovery loop manually. | ✅ Selected |

### Why discord.py-self Over DiscordChatExporter

The March 2026 Discord crackdown changed the calculus. See [risk assessment](discord-user-token-risk-assessment.md) for full evidence.

**Detection problem:** Discord started checking for the `X-Super-Properties` header on API requests. DiscordChatExporter doesn't send it — accounts get flagged ("Platform Manipulation" restrictions, forced password resets). Fix PRs exist but aren't merged as of 2026-03-18.

**discord.py-self solves this by design:**
- Sends `X-Super-Properties` on every request (`http.py:805`) with dynamically fetched build numbers and browser versions
- Generates proper `Sec-CH-UA` client hints, realistic `User-Agent`, all `Sec-Fetch-*` headers
- Falls back to hardcoded values if Discord's info API is down
- Emulates a real Discord web client at the HTTP level

**What we gain vs DCE:**
- Actually works without triggering detection
- Full control over incremental sync — per-channel, per-thread high-water marks, whatever we want
- Direct Python objects — `message.clean_content` resolves `<@id>` → `@username`, `<#id>` → `#channel-name` automatically
- `message.reference.resolved` gives the replied-to message as a full object — no separate lookup needed
- `attachment.save(path)` downloads files directly

**What we lose vs DCE:**
- No ready-made `--include-threads All` — must iterate channels → `channel.archived_threads()` + `guild.threads` manually
- No `--media` flag — must call `attachment.save()` per attachment
- More custom code (~800–1200 LOC vs ~500–800 with DCE)

**Net:** More code, but the fetch layer works. And the `--after` thread blocker from the previous architecture dissolves — we control fetch logic directly, so per-thread high-water marks are straightforward.

### Pipeline

```
Discord API
    │
    ▼
discord.py-self (Python script using user token)
    │  connects as self-bot, iterates guilds → channels → threads
    │  fetches via channel.history(after=last_message_id, oldest_first=True)
    │  rate limiting handled internally by library
    │
    ▼
Python Message objects → format to markdown in-process
    │  message.clean_content for resolved mentions
    │  message.reference.resolved for reply context
    │  attachment.save() for media download
    │  per-channel/thread state tracked in .sync-state.json
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
│       ├── t-123456789-how-to-tune-pid.md
│       └── ...
├── ftc-unofficial/
│   └── ...
└── .sync-state.json   ← per-channel + per-thread last message ID
    │
    ▼
qmd collection add discord-archive/ftc-discord --name ftc-discord
qmd update && qmd embed
    │
    ▼
qmd query "PID tuning"           # hybrid + reranking
```

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

discord.py-self uses a **user token** (self-bot). This is the only viable path — these are community servers where you're a member, not an admin who can invite a bot.

| Method | Access | Risk | Status |
|--------|--------|------|--------|
| **User token via discord.py-self** | Any server you're a member of | Violates Discord TOS. Mitigated by proper client emulation. See [risk assessment](discord-user-token-risk-assessment.md). | ✅ Selected |
| **Bot token** | Only servers where you have admin/invite permission | None | Not feasible for most target servers |

### Token extraction

Get your user token from Discord in browser: DevTools → Network tab → any request to `discord.com/api` → copy `Authorization` header value. Store in environment variable, never commit to git.

### Risk mitigation

discord.py-self's client emulation (proper headers, dynamic build numbers) significantly reduces detection risk compared to DCE. Additional measures:
- Use reasonable delays between channel fetches (library handles per-route rate limits, but add inter-channel courtesy delays)
- Don't run during Discord outages or maintenance windows
- Consider a dedicated alt account for archival if risk tolerance is low

---

## discord.py-self API Reference (Thread & Channel Fetching)

Documented here because the API has non-obvious structure.

### Channel access

```python
guild = client.get_guild(GUILD_ID)           # from cache after connect
channels = guild.text_channels               # List[TextChannel]
channel = client.get_channel(CHANNEL_ID)     # cached lookup
channel = await client.fetch_channel(ID)     # API call (if not cached)
```

### Message history

```python
# Incremental fetch (after high-water mark, chronological order)
async for msg in channel.history(after=Object(id=last_msg_id), oldest_first=True):
    # msg.clean_content — resolved mentions
    # msg.created_at — UTC datetime
    # msg.author.display_name — author name
    # msg.reference.resolved — replied-to message (or None/DeletedReferencedMessage)
    # msg.attachments — List[Attachment], each has .save(path)

# Full fetch (first sync)
async for msg in channel.history(limit=None, oldest_first=True):
    ...
```

### Thread discovery

```python
# Active threads (from guild cache — available after connect)
for thread in guild.threads:
    if thread.parent_id == channel.id:
        async for msg in thread.history(...): ...

# Archived public threads (per channel, paginated)
async for thread in channel.archived_threads(limit=None):
    async for msg in thread.history(...): ...

# Archived private threads (needs manage_threads permission)
async for thread in channel.archived_threads(private=True, limit=None):
    async for msg in thread.history(...): ...
```

### Key facts
- `channel.history()` auto-paginates in batches of 100
- Rate limiting is handled internally by the library's `RateLimiter`
- `guild.threads` is a cache property — only contains active threads visible to the user
- `channel.archived_threads()` is an async iterator — handles pagination automatically
- `Thread` extends `Messageable` — `.history()` works identically to channels
- Forum channel posts are threads — use `archived_threads()` on forum channels

---

## Incremental Sync Strategy

### Sync state design

`.sync-state.json` tracks state **per channel and per thread** (not per guild — a per-guild timestamp loses data on partial failures):

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
        }
      },
      "threads": {
        "thread_id_1": {
          "name": "how-to-tune-pid",
          "parent_channel_id": "channel_id_1",
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

1. Connect as self-bot via discord.py-self
2. For each guild, iterate `guild.text_channels`
3. Per channel:
   a. `channel.history(after=Object(id=last_message_id), oldest_first=True)` → format and append to markdown files
   b. Discover threads: `guild.threads` (active) + `channel.archived_threads(limit=None)` (public) + `channel.archived_threads(private=True, limit=None)` (private, if permissions allow)
   c. Per thread: `thread.history(after=Object(id=last_message_id), oldest_first=True)` → format and append to thread file
4. On success per channel/thread: update that entry's `last_message_id` and `last_sync` in `.sync-state.json` (atomic write: write to `.tmp`, rename)
5. On failure: log error, skip, continue. Failed entries retry from unchanged high-water mark on next run.
6. After all channels: `qmd update && qmd embed`

### Crash recovery

Same principle as before — state is per-channel/thread, only advanced after successful write:
- Crash mid-sync → completed channels are up to date, incomplete ones retry from last good state
- Append-only + high-water mark = no duplicates, no missed messages

### Thread discovery

discord.py-self provides:
- `guild.threads` — active threads only (from cache after connection)
- `channel.archived_threads(limit=None)` — paginated async iterator over all archived public threads
- `channel.archived_threads(private=True, limit=None)` — archived private threads (needs `manage_threads` permission)

**Strategy:** On each sync, discover all threads (active + archived) per channel. For threads already in `.sync-state.json`, fetch incrementally from high-water mark. For new threads, fetch from the beginning. This handles threads created, archived, or unarchived between syncs.

**Cost:** Thread discovery adds API calls (~1 per channel for active, paginated for archived). For a server with 50 channels and moderate thread usage, this is ~100–200 extra requests per sync — negligible vs message history fetches.

### Known limitations

- **Message edits:** `channel.history()` returns current message state. Edited messages past the high-water mark are silently stale. Acceptable — full re-export on a schedule (e.g., monthly) can catch edits if needed.
- **Message deletions:** Deleted messages remain in the archive. This is a feature — preserves history.
- **Archived thread completeness:** `archived_threads()` returns threads in order of decreasing `archive_timestamp`. All archived threads should be reachable, but very old servers with thousands of archived threads will take time on first sync.

---

## Formatter Scope

The formatter converts discord.py-self `Message` objects to markdown and manages file output. Simpler than the old DCE JSON converter because discord.py-self does the heavy lifting.

### What the library gives us for free

| Concern | Library Solution |
|---------|-----------------|
| **Mention resolution** | `message.clean_content` → `<@id>` becomes `@DisplayName`, `<#id>` becomes `#channel-name` |
| **Reply context** | `message.reference.resolved` → full parent `Message` object (or `DeletedReferencedMessage`) |
| **Pagination** | `channel.history()` auto-paginates in batches of 100, handles cursors |
| **Rate limiting** | Internal `RateLimiter` handles per-route and global limits |
| **Attachment download** | `attachment.save(path)` — downloads to file |
| **Thread discovery** | `channel.archived_threads()` (public/private), `guild.threads` (active) |
| **Timestamps** | `message.created_at` (UTC datetime from snowflake), `message.edited_at` |

### What we build

| Responsibility | Details |
|---------------|---------|
| **Format to markdown** | `Message` → markdown string per the format spec below. Use `clean_content`, format reply blockquotes from `reference.resolved` |
| **Reply context** | Truncate parent `clean_content` to ~100 chars, render as `> ↩ author: ...` blockquote |
| **Message ID tracking** | Embed message ID in HTML comment (`<!-- msg:ID -->`) for dedup/linking |
| **File output** | Append-only writes to date-partitioned channel files and per-thread files |
| **Incremental sync** | Track last message ID per channel/thread in `.sync-state.json`. Use `after=` parameter. No merge logic needed — append-only with high-water mark means no dedup required |
| **File naming** | Channel files: `{channel-name}/{YYYY-MM-DD}.md`. Thread files: `threads/t-{thread_id}-{slugified-title}.md` |
| **Bot/system message filtering** | See [Message Filtering](#message-filtering) |
| **Attachment download** | Call `attachment.save()`, store relative paths. See [Attachments and Media](#attachments-and-media) |

### Key simplification vs DCE approach

**No merge logic.** Because we control the fetch layer, we always fetch `after=last_message_id`. New messages are appended to the end of the current day's file. No need to read existing files, parse message IDs, or merge. The high-water mark guarantees no duplicates. This eliminates the most complex and error-prone part of the old design.

### Estimated scope

800–1200 lines of Python total (fetcher + formatter + sync state + CLI). The fetch/thread-discovery loop is the bulk of the new code. The formatter itself is simple string formatting.

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

**Implementation:** Filter by `message.type` (discord.py-self `MessageType` enum) and `message.author.bot` flag. For bot messages, decide per-bot after inspecting actual content during server verification. Start with a simple allowlist/blocklist of bot user IDs, refined after initial export.

---

## Attachments and Media

Discord switched to signed, expiring CDN URLs in late 2023. Image and file links in exported messages **will break within hours to days**.

### Options

| Approach | Storage cost | Durability | Complexity |
|----------|-------------|------------|------------|
| **Ignore attachments** | None | Links break | None |
| **Download with `attachment.save()`** | Potentially tens of GB for media-heavy servers | Durable | Per-attachment call, straightforward but high storage |
| **Download selectively** | Moderate | Durable for selected types | Medium — must filter by file type/size |

### Recommendation

For the initial build: **download attachments with `--media`** for the first server, observe actual storage usage, then decide whether to filter. FTC channels are full of robot photos, CAD screenshots, and wiring diagrams — these have genuine reference value.

In the markdown output, reference downloaded media by relative path rather than Discord CDN URL.

---

## Initial Export — Resumability

The first full export of a large FTC Discord (10k+ members, years of history) could take **4–8 hours** due to rate limits.

### Mitigation

The per-channel sync loop doubles as the resume strategy:
1. Export channel by channel, writing `.sync-state.json` after each
2. If the process dies at channel 50 of 100, restart → channels 1–49 already have high-water marks, export resumes from channel 50
3. Within a channel, if the process dies mid-history-fetch, the high-water mark hasn't been updated yet — that channel restarts from scratch, but already-synced channels are safe

Same code path for initial and incremental exports. No separate "full export" mode.

**Improvement over DCE:** discord.py-self maintains a persistent WebSocket connection, so the client stays "alive" during long exports. DCE made independent HTTP requests per export invocation.

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

### P0 — Blocks build

1. **User token.** Obtain and store securely (env var or `.env` file, gitignored).
2. **Server verification.** Join the 5 invite links, confirm server names, sizes, channel counts. Determines data volume and time estimates.

### P1 — Blocks deployment

3. **File granularity.** One file per channel per day vs. per week vs. per month — depends on message density. Need data from server verification. Start with per-day, revisit after first export.
4. **Storage location.** Where should `discord-archive/` live? Inside `pi-place/notes`? Separate repo? Home directory?
5. **Attachment storage budget.** How much disk space is acceptable for downloaded media?
6. **Bot message filtering.** Which bots are present on target servers? Which produce valuable content vs. noise? Start with include-all, filter after inspecting output.

### Resolved

- **QMD installation status:** ✅ Installed and working (confirmed 2026-03-18). No collections indexed yet.
- **Architecture selection:** ✅ discord.py-self → Markdown → QMD.
- **`--after` thread blocker:** ✅ Dissolved — we control fetch logic directly. Per-thread high-water marks are straightforward.
- **Bot token vs user token:** ✅ User token via discord.py-self. Bot token not feasible for community servers.
- **.NET dependency:** ✅ Eliminated — discord.py-self is pure Python.

---

## What's NOT in Scope (Decided)

- **DiscordChatExporter** — rejected due to March 2026 detection issues
- **Custom SQLite + FTS5 search** — superseded by QMD
- **Vector search from scratch** — QMD handles this
- **Enrichment/transformation** — not needed now, architecture doesn't preclude adding later
- **Real-time streaming** — on-demand periodic sync is sufficient
- **Edit/deletion tracking** — accepted as a known limitation. Full re-export on a schedule can backfill if needed later.

---

## Sources

| Source | Used For |
|--------|----------|
| [discord.py-self](https://github.com/dolfies/discord.py-self) | Fetch layer — self-bot library with proper client emulation |
| [Discord user token risk assessment](discord-user-token-risk-assessment.md) | Detection analysis, why DCE is broken, why discord.py-self is safer |
| [Discord API docs](https://discord.com/developers/docs) | Thread endpoints, pagination, CDN URL expiry |
| [QMD README](../qmd/README.md) | Search layer — architecture, chunking algorithm, score breakpoints |
| [QMD evaluation](qmd-evaluation-and-context-connection.md) | Prior assessment of QMD for local knowledge search |
| [Workflow: Minimal Composable Systems](workflow-minimal-composable-systems.md) | Planning methodology — first-order questions, narrowest useful version |
