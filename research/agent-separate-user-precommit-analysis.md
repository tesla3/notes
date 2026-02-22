← [Agent as Separate macOS User](agent-separate-macos-user.md) · [Friction Rebuttal](agent-isolation-friction-rebuttal.md) · [Index](../README.md)

# Separate macOS User: Pre-Commitment Analysis

**Date:** 2026-02-21
**Context:** Decision document. What you actually get, pay, and forgo by running the Pi agent as a dedicated macOS user. Written to stress-test the recommendation before committing.

---

## What You Actually Get

### 1. Kernel-Enforced Home Directory Isolation

The agent cannot read:
- `~/.ssh/` — your SSH keys (the single most valuable credential on your machine)
- `~/Library/` — browser data, Keychain, app preferences, Mail.app data, Calendar.app data
- `~/Desktop/`, `~/Documents/`, `~/Downloads/`, `~/Pictures/` — personal files
- `~/.aws/`, `~/.kube/`, `~/.gnupg/` — cloud and crypto credentials
- `.env` files in projects outside the shared workspace

This is not advisory. The kernel blocks the read at the syscall level. No configuration to drift. No allowlist to maintain. No human discipline required for the enforcement itself.

### 2. TCC Isolation

macOS TCC (Transparency, Consent, and Control) is per-user. The agent user has:
- No Full Disk Access
- No Accessibility permissions
- No Screen Recording
- No camera/microphone access
- Its own separate TCC database that doesn't inherit your grants

### 3. Blast Radius Reduction

If the agent is compromised via prompt injection, the attacker gets:
- The agent's API keys (Anthropic, GitHub PAT, Brave) — **still bad**
- Contents of the shared workspace — **your project code**
- Whatever is in the agent's home directory
- Whatever is world-readable on the system (see "What Leaks" below)

The attacker does NOT get:
- Your SSH keys (can't pivot to other services)
- Your browser sessions (can't access logged-in accounts)
- Your Keychain (can't access stored passwords)
- Your personal documents (can't exfiltrate private files)
- Your email, calendar, photos

This is a meaningful reduction. The difference between "attacker gets some API keys and project code" vs. "attacker gets your entire digital life" is the difference between an incident and a catastrophe.

### 4. Audit Trail

Separate git author attribution. You can distinguish agent commits from your own. Forensically useful if you need to review what the agent did.

---

## What You Actually Pay

### Cost 1: Initial Setup (~45-90 minutes, not 15)

The setup guide claimed 15 minutes. That's the time to create the user account. The real setup includes:

| Task | Realistic time |
|------|---------------|
| Create user account | 5 min |
| Create shared group + workspace with correct permissions | 15 min |
| Install agent's toolchain (Node.js/Pi, git config, micromamba) | 15 min |
| Configure API keys in agent's environment | 10 min |
| Set up SSH to localhost or test sudo -u workflow | 10 min |
| Move/clone projects to shared workspace | 10-30 min |
| Debug first round of permission issues | 15 min |
| **Total** | **~60-90 min** |

This is still one-time, but it's 4-6× the advertised cost. Be honest with yourself about this.

### Cost 2: Shared Workspace Permission Friction (Ongoing)

The setgid + umask 0002 model is conceptually clean but fragile in practice:

- **git creates files with its own permissions.** Without `core.sharedRepository = group` set in every repo, git checkout creates 644 files — the agent can read but not write them. You'll hit this on the first `git clone` and need to remember to configure every new repo.

- **Build tools ignore umask.** npm, pip, cargo, and make create artifacts with whatever permissions they choose. Some respect umask, some don't. You'll find files the agent can't modify, and the fix is `chmod -R g+w` — which you'll need to run periodically.

- **Editors create temp files with default umask.** Vim swap files, VS Code temp files, `.DS_Store` — created with 644 unless your umask is set. If you forget to use `umask 0002` in the shared workspace, new files are group-read-only.

- **Archives extract with their own permissions.** `tar xf`, `unzip`, `pip install` from wheels — all restore permissions from the archive, not your umask.

**Realistic ongoing cost:** You'll run into permission errors that look like bugs. Maybe once a week at first, tapering to once a month. Each takes 2-5 minutes to diagnose and fix. Annoying but not debilitating.

### Cost 3: The SSH / sudo -u Session Tax (Every Session)

Every agent session starts with `ssh agent@localhost` or `sudo -u agent -i` instead of just running `pi`. This is:

- One extra step per session (5 seconds)
- A context switch to remember which user you're operating as
- A separate terminal/tmux pane to manage

If you use SSH, you also pay:
- Enabling Remote Login (opens sshd on port 22 — exposure on untrusted networks like coffee shop WiFi)
- Occasional SSH key management
- One more service to keep in mind

`sudo -u` avoids the sshd exposure but requires your admin password each time.

**Realistic assessment:** This is minor. You'll internalize it within a week.

### Cost 4: Tool Installation Interruptions (Occasional)

The agent can't `brew install`. When it needs a new system tool mid-task:

1. Agent fails with a cryptic error (tool not found)
2. You diagnose that it needs jq/ripgrep/whatever
3. You switch to your user, `brew install jq`
4. Switch back, agent retries

In practice this happens ~3-5 times during initial setup and rarely afterward. But each interruption breaks flow.

**Per-project package installs work fine:** `npm install`, `pip install` (in agent's own micromamba env), `cargo build` — all user-scoped and don't need admin. The friction is only for system-level tools.

### Cost 5: API Credential Setup for "Personal" Tasks (High, If You Need Them)

The [friction rebuttal](agent-isolation-friction-rebuttal.md) claimed "Gmail API key works fine" for email access. The actual setup:

| Service | What's Required | Realistic Setup Time |
|---------|----------------|---------------------|
| Gmail API | Google Cloud project, enable API, OAuth2 consent screen, create credentials, generate refresh token, install/write CLI tool | 1-2 hours |
| Google Calendar API | Same as above with different scopes | 30 min (if Gmail already done) |
| CalDAV (non-Google) | Server URL, app-specific password, CLI tool | 30-60 min |
| iCloud email/calendar | App-specific password, third-party library | 30-60 min |

Each of these introduces a new credential to manage, rotate, and secure. The credentials live in the agent's environment — which means they're vulnerable to the same prompt-injection exfiltration that the separate user doesn't protect against.

**The honest framing:** You're not just "using an API instead of local files." You're building and maintaining an integration layer. For one service it's annoying. For several it's a project.

---

## What You Forgo

### Capabilities You Lose Entirely

| Capability | Why It's Lost | Workaround | Workaround Cost |
|-----------|---------------|------------|-----------------|
| Agent reads your browser sessions/cookies | `~/Library/` is 700 | Set up API credentials per service | High (see above) |
| Agent reads local Mail.app data | `~/Library/Mail/` is 700 | Gmail API or IMAP credentials | 1-2 hours setup |
| Agent reads local Calendar.app data | `~/Library/Calendars/` is 700 | Calendar API or CalDAV | 30-60 min setup |
| Agent accesses your Keychain passwords | `~/Library/Keychains/` is 700 | Manually provide secrets per task | Per-task friction |
| Agent reads/edits your dotfiles directly | `~/` is 750 | Copy/symlink specific files to shared workspace | Per-task friction |
| Agent processes files in ~/Documents, ~/Downloads | 700 permissions | Copy files to shared workspace | Per-task friction |
| Browser automation with your logged-in sessions | Agent runs separate browser profile | Log into services in agent's browser, or use API tokens | Significant setup |

### Capabilities That Degrade

| Capability | How It Degrades | Impact |
|-----------|----------------|--------|
| System troubleshooting | Most commands work, but can't read user-specific logs, app configs, or crash reports in `~/Library/Logs/` | Usually minor — most diagnostics are system-wide |
| Working on multiple projects | Only projects in the shared workspace are accessible; projects in `~/projects/` need to be moved or cloned separately | One-time migration, or ongoing copy discipline |
| Pi skills (browser automation) | Runs in agent's browser profile, no access to your bookmarks, history, or logged-in sessions | Must set up agent's own browser state |
| File-based workflows | "Summarize this PDF I downloaded" requires copying the file first | 10-second tax per file |

### Capabilities That Are Unaffected

- All coding tasks in the shared workspace
- Git operations (with agent's own PAT)
- Web search, research, API calls
- Python/Node/Rust project work (per-project dependencies)
- System commands (`top`, `df`, `ps`, `diskutil`, `log show`, `networksetup`)
- Installing per-project packages (`npm install`, `pip install`, `cargo build`)

**The pattern:** Pure coding agent work is unaffected. General-purpose assistant work loses significant capability or requires substantial setup to restore via APIs.

---

## What Risks Remain (Even With Isolation)

These are the threats the separate-user approach does NOT address. Know them clearly.

### Risk 1: Agent's Own Credentials Are Fully Exposed

The agent's `ANTHROPIC_API_KEY`, `GITHUB_TOKEN`, `BRAVE_API_KEY`, and any other credentials are in its environment. If compromised:

- **Anthropic key** → attacker racks up API charges, or uses it as a proxy for their own queries
- **GitHub PAT** → attacker pushes malicious code to your repos (fine-grained PAT limits blast radius to scoped repos)
- **Brave key** → minor (search API charges)

Separate user doesn't help here at all. Only Matchlock's secret injection (keys never enter the sandbox) addresses this.

**This is the biggest gap.** Your Anthropic key is real money. A compromised GitHub token, even fine-grained, can modify your public repos.

### Risk 2: Unrestricted Network Access

The agent can contact any host on the internet. A compromised agent can:
- Exfiltrate project code to attacker's server
- Exfiltrate its own API keys to attacker's server
- Download and execute malicious payloads
- Establish a reverse shell to an attacker's C2 server
- Use your machine as a proxy/relay

The separate-user approach provides zero network isolation. This is Matchlock's primary value-add.

### Risk 3: Shared Workspace Is Fully Exposed

Everything in `/Users/Shared/workspace/` — your active project code — is readable and writable by the agent. A compromised agent can:
- Delete or corrupt all project files (git is your safety net, but uncommitted work is lost)
- Inject backdoors into your code that survive after you push
- Read proprietary or sensitive code

This risk exists equally in Matchlock (mounted volumes are exposed) and in running unsandboxed. The separate user adds nothing here.

### Risk 4: `/tmp` Leak — Real and Currently Active

**Your machine right now** has 63 world-readable files in `/tmp` owned by your user, including:
- Vim swap files (current editing buffer content)
- Personal PDFs (school profiles)
- Firefox cookie database files
- Python scripts
- Search result dumps

A separate-user agent can read all of these. `/tmp` is `drwxrwxrwt` — the sticky bit prevents deletion but not reading of world-readable files. Any tool that writes temp files with default permissions (644) creates a cross-user information leak.

**This is not theoretical.** Your `/tmp` right now contains files that partially undermine the home directory isolation. The fix is disciplined use of `mktemp -d` (creates 700 directories) and periodic `/tmp` cleanup, but most tools don't follow this convention.

### Risk 5: Process Visibility

`ps aux` shows all users' processes, including command-line arguments. If you run commands with sensitive data in arguments (unlikely but possible), the agent user can see them.

### Risk 6: Persistent Compromise

Unlike Matchlock's ephemeral VM, the agent user's home directory persists across sessions. A compromised agent can:
- Install malware in `/Users/agent/` that runs on next session
- Modify `/Users/agent/.zshrc` to inject malicious commands
- Create cron jobs (via `crontab -e` as agent user)

You'd need to periodically audit the agent's home directory, or nuke and recreate it. Matchlock's ephemeral VM handles this automatically.

### Risk 7: World-Readable System Data

The agent can read:
- `/opt/homebrew/` — all installed packages and their data
- `/etc/` — system configuration
- `/var/log/` — some system logs (not all on modern macOS)
- `/Library/Keychains/System.keychain` and `apsd.keychain` — world-readable (though Keychain items are encrypted and require authentication to access programmatically)
- Other users' process names (via `ps`)

None of this is high-value by itself, but it's information leakage that a VM sandbox would prevent.

---

## The Discipline Decay Problem

This deserves its own section because it's the meta-risk that determines whether the approach works long-term.

The separate-user isolation is only as strong as your discipline in maintaining the boundaries. The kernel enforcement is absolute for home directory access — but the workarounds (file copying, symlinks, temporary grants) are where discipline matters.

**The decay trajectory:**

| Week | What happens |
|------|-------------|
| 1 | Diligent. Copy files to shared workspace, clean up after. |
| 3 | Agent needs a file from ~/Documents. You `cp` it over. Forget to remove it. |
| 6 | Same file type needed again. You symlink `~/Documents/project-docs/` to the workspace "temporarily." |
| 10 | The symlink is still there. You've also symlinked `~/Downloads` because the agent keeps needing downloaded files. |
| 16 | Half your home directory is exposed via forgotten symlinks. The isolation is theater. |

**This is not hypothetical.** It's how every temporary exception works. The immediate cost of maintaining discipline is small per-incident, but the accumulated laziness compounds. There's no consequence for leaving a symlink in place — until there's a catastrophic one.

**Countermeasures:**
- A weekly cronjob that audits the shared workspace for symlinks pointing outside it and alerts you
- A script that creates a fresh shared workspace per-project and nukes it when done
- Use Approach 3 from the setup guide (agent works in its own home, no shared filesystem) — eliminates the symlink temptation entirely, at the cost of more git coordination

**How Matchlock compares:** Matchlock's allowlist also suffers from discipline decay (you widen it for convenience), but it's declarative — the configuration is a script that's visible and auditable, and the VM resets each session. Accumulated permissions don't persist silently like forgotten symlinks.

---

## Decision Framework

### When the Separate User Is the Right Call

✅ Your agent use is **primarily coding** — working in project repos, running tests, writing code, doing research. These tasks don't need personal file access.

✅ You rarely need the agent to access personal data. The occasional `cp` is tolerable.

✅ You want protection against the **highest-impact scenario** (SSH key / Keychain / browser session theft) at the **lowest setup cost**.

✅ You're disciplined enough to maintain the boundary — or willing to use the "agent works in its own home" approach that eliminates the shared-workspace temptation.

✅ You see this as a **stepping stone** — separate user now, add Matchlock later when the tooling matures.

### When It's the Wrong Call

❌ You want a **general-purpose assistant** that helps with email, calendar, document organization, app troubleshooting involving user-level config. The API workarounds are substantial and introduce their own credential management burden.

❌ You're not disciplined about maintaining boundaries. If you know you'll create permanent symlinks within a month, the isolation is theater and you're paying the friction for nothing.

❌ Your primary concern is **agent credential theft** (Anthropic key, GitHub token). The separate user doesn't help — these are in the agent's environment. You need Matchlock for this.

❌ Your primary concern is **network exfiltration** (agent sends code to attacker's server). Separate user provides zero network isolation.

❌ You switch between "agent works on code" and "agent helps with personal stuff" frequently within the same session. The context-switching between isolated and non-isolated access is where the discipline breaks down fastest.

---

## The Honest Picture

| Dimension | Assessment |
|-----------|-----------|
| **What you gain** | Kernel-enforced protection of SSH keys, Keychain, browser data, personal files. Real, meaningful, automatic. |
| **What you pay** | ~60-90 min setup, ongoing permission friction, per-session SSH/sudo step, occasional `brew install` interruption. Moderate. |
| **What you forgo** | Frictionless access to personal data. General-purpose assistant capabilities require API integration work. Significant if you need them, irrelevant if you don't. |
| **What remains exposed** | Agent's own API keys, shared workspace code, network access, `/tmp` leaks, persistent compromise. These are the threats that matter after isolation. |
| **Discipline requirement** | Medium. The isolation itself is automatic, but the workarounds (file sharing) create avenues for erosion. |
| **Compared to no isolation** | Meaningfully better for the catastrophic scenario (credential/personal data theft). Identical for everything else. |
| **Compared to Matchlock** | Much less setup, much less ongoing friction. But doesn't protect agent's credentials, doesn't restrict network, doesn't provide ephemeral environment. Complementary, not a substitute. |

### The Core Tradeoff in One Sentence

You're trading frictionless general-purpose access for kernel-enforced protection against the scenario where a prompt injection steals your SSH keys, browser sessions, and personal files — accepting that your project code, agent API keys, and network access remain fully exposed.

Whether that trade is worth it depends on one question: **is your agent primarily a coding tool, or a general-purpose assistant?** If the former, the trade is clearly favorable. If the latter, the friction cost may exceed the security benefit as workarounds accumulate and discipline erodes.

---

## Sources

- [Agent as Separate macOS User](agent-separate-macos-user.md) — the setup being evaluated
- [Agent Isolation Friction: Self-Rebuttal](agent-isolation-friction-rebuttal.md) — why "just run open" was wrong
- [Matchlock Setup Guide](matchlock-setup-guide.md) — Matchlock's threat model and setup burden for comparison
- [Gondolin vs Matchlock](gondolin-vs-matchlock.md) — VM sandbox security comparison
- Direct observation: `/tmp` contents, macOS permissions, Homebrew paths on current machine
