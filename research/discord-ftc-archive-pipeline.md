← [Dev Tools](../topics/dev-tools.md) · [Index](../README.md)

# Discord FTC Archive Pipeline — Research & Plan

**Created:** 2026-03-17. **Status:** Planning — key architecture decided, open questions remain.

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

## Architecture Decision: DiscordChatExporter → Markdown → QMD

### Options Evaluated

| Approach | Pros | Cons | Verdict |
|----------|------|------|---------|
| **discord.py custom script** | Full control, direct-to-SQLite | Reimplements pagination, rate limiting, thread discovery. Significant custom code. | ❌ Rejected — reimplements solved problems |
| **DiscordChatExporter → custom SQLite + FTS5** | Structured queries, incremental via high-water mark | Must build search layer, FTS5 setup, query interface | ❌ Superseded by QMD |
| **DiscordChatExporter → Markdown → QMD** | Minimal custom code. QMD handles FTS5 + vector + reranking. CLI + MCP for agent access. | Depends on QMD. Extra conversion step. | ✅ Selected |

### Why This Architecture

1. **DiscordChatExporter** is mature, actively maintained (10k+ stars), handles all Discord API complexity: pagination, rate limiting, thread discovery (active + archived + forum), attachments. Supports `--after` for incremental pulls and `--include-threads All`. No reason to rewrite this.

2. **QMD** ([evaluation](qmd-evaluation-and-context-connection.md)) is already the selected local knowledge search tool. It provides FTS5 keyword search, vector semantic search (sqlite-vec), hybrid search with LLM reranking, smart markdown chunking, and a CLI/MCP interface designed for AI agents. Building a custom SQLite + FTS5 solution would be strictly worse.

3. **The only custom code needed** is a converter (DiscordChatExporter JSON → structured markdown) and a sync wrapper (tracks last-fetched timestamps, runs exporter incrementally, triggers `qmd update`).

### Pipeline

```
Discord API
    │
    ▼
DiscordChatExporter (--after DATE --include-threads All -f Json)
    │
    ▼
JSON export files
    │
    ▼
Converter script (JSON → organized markdown)
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
│       ├── how-to-tune-pid-controller.md
│       └── ...
├── ftc-unofficial/
│   └── ...
└── .sync-state.json   ← tracks last-fetched timestamp per guild/channel
    │
    ▼
qmd collection add discord-archive/ftc-discord --name ftc-discord
qmd update && qmd embed
    │
    ▼
qmd search "PID tuning"          # keyword
qmd vsearch "drivetrain gearing"  # semantic
qmd query "how to tune PID"       # hybrid + reranking
```

---

## Markdown Format Design

QMD's smart chunking scores heading boundaries highly (H1=100, H2=90, H3=80). The markdown structure should exploit this for clean chunk boundaries.

**Thread files** (one file per thread — threads are natural conversation units):
```markdown
# Thread: How to tune PID controller
Channel: #programming | Started: 2025-03-10 | Server: FTC

## user1 — 2025-03-10 14:00
How do I tune a PID controller for our drivetrain?

## user2 — 2025-03-10 14:05
Start with P only. Set I and D to zero...
```

**Channel files** (one file per channel per day for non-thread messages):
```markdown
# #general — 2025-03-15
Server: FTC

## user1 — 10:30
Message content here

## user2 — 10:32
Reply content here
```

**Design rationale:**
- H1 carries context (channel, server, date) — every QMD chunk inherits this via the title extraction
- H2 per message gives 90-score break points for QMD's chunking algorithm
- Author and timestamp in the H2 line make them searchable via both `rg` and FTS5
- Flat text, no nested structure — maximizes `rg` usability

**⚠️ Open question:** File granularity not yet confirmed. One file per thread is natural. One file per channel per day for main channel messages is a proposal — could also be per-week or per-month depending on message volume. Needs data on actual message density per channel.

---

## Discord Bot — Key Facts

- **One bot token works across all servers.** A single bot application can be invited to multiple guilds. Same token everywhere.
- **Bot permissions needed:** `Read Message History`, `View Channels`, `Manage Threads` (for private archived threads)
- **Bot setup:** Discord Developer Portal → New Application → Bot tab → copy token → OAuth2 URL Generator → `bot` scope → select permissions → generate invite link per server
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

1. `.sync-state.json` tracks `last_exported_timestamp` per guild
2. Each sync run: `discordchatexporter export --after {last_timestamp} ...`
3. Converter appends new messages to existing markdown files (or creates new daily files)
4. `qmd update && qmd embed` re-indexes changed files
5. Update `.sync-state.json` with new timestamp

**⚠️ Edge cases not yet addressed:**
- Message edits and deletions after initial export (DiscordChatExporter fetches current state, but incremental runs won't catch edits to already-exported messages)
- Thread archival/unarchival between sync runs
- How DiscordChatExporter handles `--after` for threads (does it filter by thread creation date or message date within threads?)

---

## Open Questions (Must Resolve Before Building)

1. **Does the user have a Discord bot application?** Status: "let me check" — not yet confirmed.
2. **Server verification:** The 5 invite links need to be joined/verified to confirm server names, sizes, and channel counts. This determines expected data volume and time estimates.
3. **File granularity:** One file per channel per day vs. per week vs. per month — depends on message density. Need data.
4. **QMD installation status:** Is QMD installed and working on this machine? Need to confirm before depending on it.
5. **Architecture confirmation:** User has not yet explicitly approved the DiscordChatExporter → markdown → QMD pipeline. Presented but not confirmed.
6. **DiscordChatExporter installation:** Requires .NET runtime. Is it installed? If not, is dotnet available or preferred to install via Homebrew?
7. **Storage location:** Where should `discord-archive/` live? Inside `pi-place/notes`? Separate repo? Home directory?

---

## What's NOT in Scope (Decided)

- **Custom discord.py fetcher** — rejected in favor of DiscordChatExporter
- **Custom SQLite + FTS5 search** — superseded by QMD
- **Vector search from scratch** — QMD handles this
- **Enrichment/transformation** — not needed now, architecture doesn't preclude adding later
- **Real-time streaming** — on-demand periodic sync is sufficient

---

## Sources

| Source | Used For |
|--------|----------|
| [Discord API docs](https://discord.com/developers/docs) | Thread endpoints, pagination, bot permissions |
| [DiscordChatExporter](https://github.com/Tyrrrz/DiscordChatExporter) | Fetch layer — capabilities, CLI flags, limitations |
| [QMD README](../qmd/README.md) | Search layer — architecture, chunking algorithm, score breakpoints |
| [QMD evaluation](qmd-evaluation-and-context-connection.md) | Prior assessment of QMD for local knowledge search |
| [Workflow: Minimal Composable Systems](workflow-minimal-composable-systems.md) | Planning methodology — first-order questions, narrowest useful version |
