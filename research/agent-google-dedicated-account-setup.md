← [Agent Security Landscape](agent-security-landscape-what-people-do.md) · [Index](../README.md)

# Google Dedicated Agent Account: Setup Plan & Skill Recommendations

**Date:** 2026-02-21
**Context:** Decision on how to set up a dedicated Google account for Pi agent use, with skill-based (not MCP) access to Google services. Based on research into what ChatPRD, rida (HN), Harper Reed, and the OpenClaw community actually did.

---

## Decision Summary

- **Gmail for email** (already using Gmail personally)
- **Google ecosystem for agent services** (Calendar, Tasks, Drive) — not Apple, because Google has real APIs with granular OAuth scopes
- **Dedicated agent Gmail account** — agent never touches personal account
- **Skills over MCP** — CLI tools called via bash, same pattern as brave-search
- **LuLu + eyeballs** as security controls (interactive use, no unattended sessions)
- **No separate macOS user** (don't leave sessions running)

---

## Step-by-Step Setup

### Step 1: Create Agent Gmail Account (~5 min)

Create `yourname-agent@gmail.com` (or similar). Google may ask for phone number — use your existing number (Google allows same phone on multiple accounts). This is a real account you'll keep.

### Step 2: Share Personal Calendar with Agent (~5 min)

1. `calendar.google.com` → hover calendar → three dots → **Settings and sharing**
2. **Share with specific people** → Add agent's Gmail
3. Permission: **"See all event details"** (read-only, excludes private events)
4. Agent accepts the sharing invite from its Gmail

**Permission levels (verified):**

| Level | Sees | Changes | Use? |
|-------|------|---------|------|
| See only free/busy | Availability only | Nothing | ❌ Too limited |
| See all event details | Names, times, locations, descriptions (not private) | Nothing | ✅ Start here |
| Make changes to events | Everything | Add, edit, delete | ⚠️ Only if needed later |
| Make changes and manage sharing | Everything | Full admin | ❌ Never |

**ChatPRD lesson:** She gave write access to family calendar → chaos (wrong days, agent fighting deletions, duplicates). Start read-only. Seriously.

### Step 3: "Invite Me" Pattern for Calendar Events (~0 min)

Agent creates events on **its own calendar** and invites your personal Gmail as attendee. You accept/decline.

- If agent gets dates wrong, just decline. No cleanup.
- If agent account compromised, attacker can only send invites — can't modify your events.
- Every calendar action is an explicit invitation you approve.

Verified working by ChatPRD: *"Hey, can you just create an event on your calendar and invite me to it? It worked perfectly."*

### Step 4: Email Forwarding (~5-15 min)

**Start with manual:** Forward specific emails to agent's Gmail. Tell Pi to read and draft replies.

**Add filters later:** In personal Gmail → Settings → Forwarding and POP/IMAP → Add forwarding address (agent Gmail) → verify. Then create filters (Settings → Filters) to auto-forward from specific senders/subjects.

**Agent sends from its own address.** Draft-only policy recommended (Harper Reed's lesson — his agent accidentally sent an email, recipient replied "F U").

### Step 5: Google Tasks as Reminders Replacement (~0 min)

Comes with the Gmail account. API scopes:
- `tasks.readonly` — view only
- `tasks` — full CRUD

**Limitations vs Apple Reminders:** No location-based triggers, no priority levels, no tags. Simpler but has a real API.

### Step 6: OAuth Scope Control (during skill setup)

Grant minimum scopes. Push back on broad requests (ChatPRD's agent initially requested everything).

**Verified Google OAuth scopes:**

| Service | Read-only | Read-write |
|---------|-----------|------------|
| Calendar | `calendar.readonly` | `calendar` or `calendar.events` |
| Gmail | `gmail.readonly` | `gmail.send` (send only) or `gmail.modify` (full) |
| Tasks | `tasks.readonly` | `tasks` |
| Contacts | `contacts.readonly` | `contacts` |
| Drive | `drive.readonly` | `drive` or `drive.file` (specific files only) |

**For agent's own account:** `calendar` (full), `gmail.send` + `gmail.readonly`, `tasks` (full).
**For personal calendar:** No OAuth needed — shared via Step 2.

### Step 7: Separate Credential Vault (~10 min)

Create a new 1Password vault (or Bitwarden folder) named "Pi Agent" or similar. Store:
- Agent Gmail password
- Google OAuth client secrets
- Any API keys the agent uses
- Anthropic API key for agent

Never store personal credentials in this vault. Never store agent credentials in personal vault.

### Step 8: Notes (no good Google equivalent)

- **Google Keep:** No public API. Dead end.
- **Use markdown files in a git repo** — Pi's native workflow.
- **Paste into session** for one-off notes.
- **Google Docs** via Drive API if persistent shared docs needed.

### Step 9: Install Google Skills for Pi

**Total setup time:** ~30-45 minutes (excluding skill evaluation).

---

## Recommended Skills

### Primary: `minkhant1996/openclaw-google-skills`

**GitHub:** `github.com/minkhant1996/openclaw-google-skills`

Full CLI tools for Google Workspace. Node.js wrappers around Google APIs. Pi calls via bash (same pattern as brave-search skill).

```bash
# Calendar
gcal list | gcal today | gcal tomorrow
gcal create "Meeting" --start "tomorrow 2pm" --duration 1h
gcal free tomorrow

# Gmail
gmail inbox | gmail sent | gmail starred
gmail send --to x@y.com --subject "Hi" --body "..."
gmail search "from:boss"

# Drive
gdrive list | gdrive search "report"
gdrive upload file.pdf --to <folderId>

# Docs
gdocs create "My Doc" | gdocs read <id>
gdocs append <id> --text "Add this"
```

**Setup:** Google Cloud project → enable APIs → OAuth 2.0 client ID (desktop app) → download JSON → `~/.openclaw/credentials/google-oauth-client.json` → run `node authorize.mjs` → one-time browser auth → tokens saved.

**Why this one:**
- CLI tools, not MCP — Pi calls via bash
- No third-party routing (unlike Composio)
- Direct Google API calls from your machine
- LuLu sees connections to `googleapis.com` (expected, flaggable)
- OAuth credentials belong to agent account only

**Install only what's needed:**
- `gcal` — calendar (agent's calendar + shared view of yours)
- `gmail` — agent's email (read forwarded emails, send from agent address)
- `gdrive` — optional, shared docs
- Skip `gsheet`, `gslides`, `gdocs` until needed

### Alternative: `idanbeck/claude-skills`

**GitHub:** `github.com/idanbeck/claude-skills`

Individual SKILL.md files per service:
- `gmail-skill` — read, search, send, draft emails + contacts, multi-account
- `gcal-skill` — Google Calendar
- `google-docs-skill`, `google-sheets-skill`, `google-slides-skill`

Pure SKILL.md format (no CLI tools). More native to Claude Code / Pi skill system. Less comprehensive than openclaw-google-skills.

### Reference: Harper Reed's email-management skill

**Blog:** `harper.blog/2025/12/03/claude-code-email-productivity-mcp-agents/`

Custom SKILL.md for email triage workflow. Key patterns to adopt:
1. Find thread → get context
2. Check calendar for scheduling context
3. Draft reply (NEVER send directly)
4. Save as draft for human review
5. Match writing style from past emails

### Skills Directories (for finding more)

| Directory | Size | URL |
|-----------|------|-----|
| skillsmp.com | 96,751+ skills | `skillsmp.com` |
| agent37.com | 225,000+ (semantic search) | `agent37.com/skills` |
| claudeskills.info | Curated | `claudeskills.info` |
| VoltAgent/awesome-agent-skills | Official + community | `github.com/VoltAgent/awesome-agent-skills` |

---

## What You Need to Write

A Pi-specific `SKILL.md` that teaches Pi:
- When to use each CLI tool
- The "invite me" calendar pattern (create on agent calendar, invite personal)
- Draft-only email policy
- Which account is which (agent vs personal)
- OAuth scope boundaries

---

## Security Model

| Layer | Control | Catches |
|-------|---------|---------|
| Dedicated agent account | Blast radius — compromised agent gets throwaway Gmail | Account compromise |
| OAuth scopes | Minimum permissions per service | Over-permissioning |
| LuLu outbound firewall | Monitors all connections from Pi | Exfiltration to unknown hosts |
| Your eyeballs + Ctrl-C | Real-time behavioral monitoring | Gross behavior changes |
| Draft-only email | Agent can't send without your review | Accidental/malicious sends |
| Separate credential vault | Agent creds isolated from personal | Credential theft |
| Calendar read-only + invite pattern | Agent can't modify your calendar | Calendar chaos (ChatPRD's experience) |

**What this does NOT catch:** Exfiltration through `googleapis.com` (looks like normal traffic to LuLu). This is the "confused deputy" problem — no network-level tool solves it. Your mitigation: the agent account only has access to agent data, not your personal data.

---

## Sources

- [ChatPRD: 24 Hours with Clawdbot](https://www.chatprd.ai/how-i-ai/24-hours-with-clawdbot-moltbot-3-workflows-for-ai-agent) — dedicated Google Workspace account, OAuth scope negotiation, "invite me" calendar pattern, calendar chaos
- [HN: Ask real OpenClaw users](https://news.ycombinator.com/item?id=46838946) — rida's setup: separate email, separate 1Password vault, read-only service accounts, auditable specs
- [Harper Reed: Claude Code email](https://harper.blog/2025/12/03/claude-code-email-productivity-mcp-agents/) — draft-only email policy, accidental send incident, SKILL.md structure
- [Peter Hartree: Hardened Google Workspace MCP](https://wow.pjh.is/journal/claude-code-google-workspace-mcp) — security-first approach, prompt injection warning
- [CreatorEconomy: OpenClaw tutorial](https://creatoreconomy.so/p/master-openclaw-in-30-minutes-full-tutorial) — "Zoe" bot with own Gmail ID, read access to personal calendar, write access to select files
- [Google OAuth scopes](https://developers.google.com/identity/protocols/oauth2/scopes) — official scope reference
- [Google Tasks API auth](https://developers.google.com/workspace/tasks/auth) — `tasks` and `tasks.readonly` scopes
- [openclaw-google-skills](https://github.com/minkhant1996/openclaw-google-skills) — CLI tools for Calendar, Gmail, Drive, Docs, Sheets, Slides
- [idanbeck/claude-skills](https://github.com/idanbeck/claude-skills) — individual SKILL.md files for Google services
- [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills) — curated skills list, connect-apps skill
