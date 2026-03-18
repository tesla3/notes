← [Discord FTC Archive Pipeline](discord-ftc-archive-pipeline.md) · [Index](../README.md)

# Discord User Token Scraping — Risk Assessment (March 2026)

**Created:** 2026-03-18. **Status:** Research complete.

---

## Summary

User token scraping of Discord servers carries **real and elevated risk as of March 2026**. Discord has tightened enforcement specifically against DiscordChatExporter's API request pattern. The detection mechanism is header-level (missing `x-super-properties`), not behavioral analysis. A fix is in progress but not yet merged.

Every tool that archives Discord without admin cooperation uses a user token. There is no third path. The decision is binary: bot token (needs server cooperation, zero risk) or user token (any tool, elevated risk).

---

## Evidence Inventory

### Confirmed ban/restriction reports (first-person accounts)

| Who | When | Tool | What Happened | Source |
|-----|------|------|---------------|--------|
| **nischay876** | Oct 2021 | DiscordChatExporter | "my account was clear clean and after i export some chat in 3 days my account got banned." Could not get unbanned. | [GitHub Discussion #726](https://github.com/Tyrrrz/DiscordChatExporter/discussions/726) |
| **stevenOCR** | Mar 11, 2026 | DiscordChatExporter | "Platform Manipulation" — chat ability disabled for 2 days. Used DCE "a few times this week, each going back about two months." | [GitHub Discussion #889](https://github.com/Tyrrrz/DiscordChatExporter/discussions/889) |
| **absdq2** | Mar 1, 2026 | DiscordChatExporter CLI | Token works once, then account blocked. Had to reset password 8 times in one week. "Haven't had any issues in months/years using it but the last week, this has happened 8 times." | [GitHub Issue #1497](https://github.com/Tyrrrz/DiscordChatExporter/issues/1497) |
| **itsAedan** | Mar 2025 | Custom selfbot | Used Discord API to join a server → account disabled. Sending messages in one server was fine. | [r/Discord_selfbots](https://www.reddit.com/r/Discord_selfbots/comments/1jm9glv/) |

**Total: 4 first-person ban reports across all time. 2 from March 2026 (both DCE-specific).**

### Reports of no issues (first-person)

| Who | When | Tool | What They Said | Source |
|-----|------|------|---------------|--------|
| **Tyrrrz** (DCE maintainer) | Oct 2021 | DiscordChatExporter | "Unlikely, most people use it without issues. But there's never any guarantee." | [GitHub Discussion #726](https://github.com/Tyrrrz/DiscordChatExporter/discussions/726) |
| **96-LB** (DCE contributor) | Aug 2022 | DiscordChatExporter | "I've heard very few reports of anybody losing their account because they used DiscordChatExporter with a user token, but it can happen." | [GitHub Discussion #889](https://github.com/Tyrrrz/DiscordChatExporter/discussions/889) |
| **FAS_Guardian** | Feb 2026 | DiscordChatExporter | Uses it on a schedule dumping to NAS. "nobody's gonna come after you for that." | [r/selfhosted](https://www.reddit.com/r/selfhosted/comments/1r143fk/) |

---

## What Discord Detects (Evidence-Based)

### Known detection signals

| Detection Signal | Evidence | Source |
|-----------------|----------|--------|
| **Missing `x-super-properties` header** | Two independent PRs (#1507, #1510) add this header to DCE. PR #1507: "if this header is not provided, discord may flag requests and cause accounts to be banned/restricted." | [PR #1507](https://github.com/Tyrrrz/DiscordChatExporter/pull/1507), [PR #1510](https://github.com/Tyrrrz/DiscordChatExporter/pull/1510), March 2026 |
| **Missing JA3/TLS fingerprints** | "You need to use Ja3 fingerprints and chrome browser data to emulate your activity as a real user, using API without this will signal to Discord that you're doing bot activity." | r/Discord_selfbots, March 2025 |
| **Joining servers via API** | Programmatic server joins get flagged immediately. Message reading/sending in servers you're already in is lower risk. | r/Discord_selfbots, March 2025 |
| **Request pattern anomalies** | General consensus: rapid API calls, unusual request patterns trigger detection. | Multiple sources |

### What Discord does NOT reliably detect (per community consensus)

| Activity | Evidence | Source |
|----------|----------|--------|
| **Selfbot reading messages in existing servers** | "there isn't a way (from what I can tell) to detect selfbots unless they use commands and their own account responds to it." | r/discordapp, Discord support forums |
| **Properly client-emulating requests** | "as long as you use appropriate delays, discord aren't going to be able to tell the difference between an autohotkey script and normal human discord usage" | r/discordapp, 2021 |

---

## The March 2026 Shift

### What changed

- **Pre-2026**: DCE user token usage was technically against TOS but rarely enforced. Very few reports over 4+ years.
- **March 2026**: Two independent users report issues within the same week (March 1 and March 11). Both used DCE.
- **Root cause**: DCE's missing `x-super-properties` header. Discord apparently started checking for this header, and requests without it are flagged as non-client automation.
- **Piunikaweb article (March 12, 2026)**: Reported the crackdown, citing X posts and GitHub issues. Speculated the cause is preventing AI scrapers. [Source](https://piunikaweb.com/2026/03/12/discord-is-cracking-down-on-discordchatexporter/).

### Fix status

PRs #1507 and #1510 add `x-super-properties` to DCE. Neither merged as of March 18, 2026. If merged, DCE may return to pre-2026 risk level. Unknown whether Discord will add further detection layers.

---

## Tool Comparison for User Token Path

| Tool | How It Makes Requests | Detection Profile | .NET Required | Output |
|------|----------------------|-------------------|---------------|--------|
| **DiscordChatExporter** | Raw HTTP to Discord API. Missing `x-super-properties` (fix pending). | **HIGH** — actively detected as of March 2026. | Yes | JSON, HTML, CSV, TXT |
| **Discord History Tracker (DHT)** | Injects JS into Discord's DevTools. Auto-scrolls UI, causing the real Discord client to fire API requests with all proper headers. | **Lower** — requests carry correct headers, cookies, session data. But automated rapid scrolling is still detectable in principle. | Yes (also C#/.NET) | SQLite |
| **Custom script with proper headers** | Your HTTP requests, your headers. Must include `x-super-properties`, JA3 fingerprints, proper TLS. | **Depends on implementation** — good emulation = low risk. | No | Whatever you build |

**Key correction**: DHT does NOT avoid API calls. It triggers the same Discord API calls the real client makes by scrolling the UI. The detection advantage is that these requests go through the actual Discord client with proper headers — not that they bypass the API.

**Key correction**: DHT also requires .NET (ASP.NET Core Runtime 9). It does not eliminate the .NET dependency.

---

## Discord Official Data Export — Not Viable

Discord's official data export (Settings → Privacy & Safety → Request Data) only exports **your own messages and account metadata**. It does not include other users' messages in servers you're a member of. Verified from multiple sources:

> "The package centers on the requesting account's own messages and a simple inventory of servers rather than a full mirror of other users' content." — [Factually.co](https://factually.co/fact-checks/technology/discord-data-package-what-is-included-message-history-deleted-messages-server-content-775279)

**Useless for community archiving.**

---

## All Known Archival Tools

From [ArchiveTeam wiki](https://wiki.archiveteam.org/index.php/Discord):

| Tool | Needs Admin? | Auth | Incremental | Output | Notes |
|------|-------------|------|-------------|--------|-------|
| **DiscordChatExporter** | No | User or Bot token | Manual (`--after`) | JSON/HTML/CSV/TXT | Most mature. Handles threads, forums, attachments. |
| **Discord History Tracker** | No | User session (browser) | Yes | SQLite | Browser script + desktop app. Also C#/.NET. |
| **discord-fetch** | Yes (bot) | Bot token | Yes (`since_date`) | JSON | Python. v0.0.11. **GitHub repo 404** — may be dead. |
| **DiscordChatExporterPy** | Yes (bot) | Bot token | Via `after` param | HTML only | discord.py plugin. HTML-only output. |
| **pullcord** | No | User token | Yes | TSV | Go. No recent reports on detection risk. |
| **Discordless** | No | User session (mitmproxy) | Yes | HTML/JSON | Passive traffic capture. Unknown detection risk. |
| **discard2** | No | User session (headless Chrome) | Unknown | Mitmdump/Wireshark | Unknown detection risk. |
| **Custom discord.py** | Yes (bot) | Bot token | You build it | Anything | 200-800 lines depending on scope. |

**ArchiveTeam's warning**: "Discord's Developer Policy forbids you from scraping or even just disclosing user data without their consent. Using these tools with your account may get your account banned. Use at your own risk!"

---

## Assessment for FTC Server Archival

### Risk factors in favor

- Alt account — main account protected regardless
- Already joined the server — no programmatic server join (a known trigger)
- Read-only — not sending messages
- FTC server is a community server, not a high-profile enforcement target

### Risk factors against

- DCE currently lacks `x-super-properties` header (the known March 2026 detection vector)
- Initial full export = high volume of API requests in short period
- Fresh alt account with minimal history making bulk API calls may look more suspicious

### Bottom line

**Two paths exist. Every tool falls into one.**

1. **Bot token** — ask server admin to add bot. Zero risk. Tools: DCE (with bot token), custom discord.py, DiscordChatExporterPy.
2. **User token** — use alt account. Risk is real and elevated in March 2026. Among tools, DHT has best detection profile (proper client headers). DCE is highest risk until header fix merges.

---

## Open Questions

1. Have DCE PRs #1507/#1510 been merged? Changes risk calculus significantly.
2. How large is the FTC server? Small = might complete before detection. Large = likely flagged.
3. Is DHT worth testing on alt as lower-risk probe before committing to full DCE export?
4. Is asking an FTC server admin to add a bot feasible?

---

## Sources

| Source | Type | Key Contribution |
|--------|------|-----------------|
| [GitHub Issue #1497](https://github.com/Tyrrrz/DiscordChatExporter/issues/1497) | Primary | March 2026 ban report, spawned header fix PRs |
| [GitHub Discussion #889](https://github.com/Tyrrrz/DiscordChatExporter/discussions/889) | Primary | Historical + March 2026 ban reports |
| [GitHub Discussion #726](https://github.com/Tyrrrz/DiscordChatExporter/discussions/726) | Primary | 2021 ban report + maintainer response |
| [GitHub PR #1507](https://github.com/Tyrrrz/DiscordChatExporter/pull/1507) | Primary | `x-super-properties` fix, detection mechanism |
| [GitHub PR #1510](https://github.com/Tyrrrz/DiscordChatExporter/pull/1510) | Primary | `x-super-properties` fix, detection mechanism |
| [Piunikaweb article](https://piunikaweb.com/2026/03/12/discord-is-cracking-down-on-discordchatexporter/) | Secondary | Aggregated reports, March 12, 2026 |
| [ArchiveTeam Discord wiki](https://wiki.archiveteam.org/index.php/Discord) | Reference | Tool comparison table |
| [Grokipedia: Discord selfbot](https://grokipedia.com/page/discord-selfbot) | Reference | TOS/legal analysis, detection mechanisms |
| [r/Discord_selfbots](https://www.reddit.com/r/Discord_selfbots/) | Community | Detection triggers, JA3 fingerprints |
| [r/DataHoarder](https://www.reddit.com/r/DataHoarder/) | Community | User experiences, tool recommendations |
| [Simon Willison on DHT](https://simonwillison.net/2022/Sep/2/discord-history-tracker/) | Reference | DHT mechanism description |
