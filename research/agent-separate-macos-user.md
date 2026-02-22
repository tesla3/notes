← [Matchlock Setup Guide](matchlock-setup-guide.md) · [Index](../README.md)

# Agent as a Separate macOS User

**Date:** 2026-02-21
**Context:** Pi coding agent on Apple Silicon Mac, personal data on the machine, low-cost isolation alternative to VM sandboxing.

---

## What This Is

A deep look at the "dedicated macOS user account" approach mentioned (but not elaborated) in the [Matchlock setup guide](matchlock-setup-guide.md). This is the highest-value, lowest-effort isolation you can get without any sandbox tooling. It's not a replacement for Matchlock — it solves a different (and arguably more likely) threat: **the agent accidentally or maliciously accessing your personal files**.

---

## What macOS User Isolation Actually Gives You

macOS home directories are `drwxr-x---` (750) by default. Sensitive subdirectories are even tighter:

| Path | Permissions | Agent user can access? |
|------|------------|----------------------|
| `/Users/js/` | `rwxr-x---` (750, owner:staff) | ❌ No — not in `js` group by default, and the `x` for group won't help a different user without `r` |
| `/Users/js/.ssh/` | `rwx------` (700) | ❌ No |
| `/Users/js/Desktop/`, `Documents/`, `Downloads/` | `rwx------` + ACL deny delete | ❌ No |
| `/Users/js/Library/` | `rwx------` | ❌ No — this includes Keychains, browser data, app preferences |
| `/Users/js/Library/Keychains/` | `rwx--x--x` | ❌ Execute bit only — can't list or read files |
| `/Users/js/Pictures/`, `Movies/`, `Music/` | `rwx------` | ❌ No |

**This is real isolation.** A process running as user `agent` literally cannot read your SSH keys, browser cookies, Keychain, photos, documents, or any file in your home directory. The kernel enforces this — no configuration, no allowlists, no forgetting to exclude a mount.

### What it does NOT isolate

| Resource | Isolated? | Notes |
|----------|-----------|-------|
| Files in your home | ✅ Yes | Kernel-enforced |
| Network access | ❌ No | Agent can contact any host, exfiltrate anything it has access to |
| CPU/memory | ❌ No | Agent can fork-bomb or OOM your machine |
| Kernel | ❌ No | Shared kernel — but macOS kernel exploits from userland are rare and high-value |
| System-wide readable files | ❌ No | `/etc/hosts`, `/usr/local/`, Homebrew cellar are world-readable |
| `/Users/Shared/` | ❌ No | World-writable — don't put secrets here |
| Processes | Partial | Agent can `ps aux` and see your process names, but can't `ptrace` or signal them |

**The honest framing:** This protects your **personal data** from the agent. It does NOT protect against credential exfiltration (if the agent has API keys in its own env, it can send them anywhere), network-based attacks, or system-level compromise. For those, you need Matchlock.

---

## Setup: Creating the Agent User

### Option A: GUI (System Settings)

System Settings → Users & Groups → Add Account. Standard user, not admin. Name it `agent` or `piagent`. Done.

### Option B: CLI (sysadminctl)

```bash
# Create a standard (non-admin) user
sudo sysadminctl -addUser agent -fullName "Pi Agent" -password - -home /Users/agent
```

The `-password -` flag prompts interactively. Pick something simple — you'll primarily use `sudo -u` or SSH, not interactive login.

**Important: do NOT use `-admin`.** An admin user can `sudo` to root, which defeats the entire purpose. Standard users cannot escalate privileges on macOS without knowing an admin password.

### Post-Creation Checklist

```bash
# Verify the user exists and is NOT admin
dscl . -read /Users/agent | grep -i admin
# Should return nothing. If it shows PrimaryGroupID 80 or membership in admin group, delete and recreate.

# Verify home directory permissions
ls -la /Users/agent/
# Should be drwxr-x--- agent staff

# Verify the agent can't read your home
sudo -u agent ls /Users/js/
# Should fail: "Permission denied"

# Verify the agent can't read your SSH keys
sudo -u agent cat /Users/js/.ssh/id_ed25519
# Should fail: "Permission denied"
```

---

## Shared Project Directory

The agent needs access to your project files. Two approaches:

### Approach 1: Shared Group with Dedicated Directory (Recommended)

Create a shared group and a workspace directory both users can access:

```bash
# Create a group for shared agent work
sudo dscl . -create /Groups/agentwork
sudo dscl . -create /Groups/agentwork PrimaryGroupID 600  # pick unused GID
sudo dscl . -append /Groups/agentwork GroupMembership js
sudo dscl . -append /Groups/agentwork GroupMembership agent

# Create shared workspace
sudo mkdir -p /Users/Shared/workspace
sudo chown js:agentwork /Users/Shared/workspace
sudo chmod 2775 /Users/Shared/workspace  # setgid so new files inherit group
```

Then clone/symlink your projects there:

```bash
# From your normal user
cd /Users/Shared/workspace
git clone git@github.com:you/project.git
```

**The setgid bit (`2775`) is critical.** Without it, files created by `js` are group `staff` and the agent can't write them; files created by `agent` are group `staff` and you can't write them. With setgid, all new files inherit group `agentwork`.

**Gotcha: umask.** Default umask `0022` means new files are `rw-r--r--` — group can read but not write. Both users need `umask 0002` in their shell config for shared directories to work bidirectionally. Add to the agent user's profile:

```bash
# /Users/agent/.zshrc (or .bashrc)
umask 0002
```

And for your own sessions when working in shared workspace, either set umask globally (affects all your files) or use a wrapper:

```bash
# Alias for working in the shared workspace
alias ws='cd /Users/Shared/workspace && umask 0002'
```

### Approach 2: ACLs on Your Existing Project Directory

If you don't want to move projects, grant the agent user access to specific directories:

```bash
# Grant agent read+write to a specific project
chmod -R +a "agent allow read,write,execute,delete,add_file,add_subdirectory,file_inherit,directory_inherit" ~/projects/my-project
```

**Downside:** ACLs are fragile. New files created by git, editors, or build tools may not inherit the ACL unless `file_inherit` and `directory_inherit` are set correctly. You'll chase permissions issues. The shared group approach is more robust.

### Approach 3: Agent Works in Its Own Home

Simplest: the agent clones repos into `/Users/agent/projects/`. You `sudo -u agent` to interact. No shared filesystem.

**Downside:** You can't easily edit the same files from your normal user session. Two separate working copies = merge headaches. Only works if you treat the agent as fully autonomous (you review via git, not by editing the same files).

---

## Running Pi as the Agent User

### Method 1: `sudo -u` (simplest)

```bash
sudo -u agent -i  # get a login shell as agent
# Now install and run Pi normally
```

Or for one-off commands:

```bash
sudo -u agent bash -lc 'cd /Users/Shared/workspace/project && pi'
```

**Pros:** Zero setup. Works immediately.
**Cons:** You need your admin password. The terminal session runs in your terminal emulator — no isolation of terminal state. If Pi writes to `~`, it writes to `/Users/agent/`, which is correct.

### Method 2: SSH to localhost (better isolation)

```bash
# One-time setup: enable Remote Login for the agent user
# System Settings → General → Sharing → Remote Login → Allow access for: agent

# Or via CLI:
sudo systemsetup -setremotelogin on
sudo dscl . -append /Groups/com.apple.access_ssh GroupMembership agent

# Then SSH in
ssh agent@localhost
cd /Users/Shared/workspace/project
pi
```

**Pros:** Full session isolation — separate environment, separate terminal state, clean shell. You can run this in a tmux pane alongside your normal work. If the agent process hangs or goes haywire, you close the SSH session.

**Cons:** Requires Remote Login enabled (opens port 22, though localhost-only use is fine behind a firewall). Slightly more setup.

**Recommended:** Use SSH for regular sessions. Use `sudo -u` for quick one-offs.

### Method 3: tmux Session Under Agent User

```bash
# Start a persistent tmux session as the agent user
sudo -u agent tmux new-session -d -s pi-agent
# Attach to it
sudo -u agent tmux attach -t pi-agent
```

**Pros:** Persistent session — survives terminal disconnect. You can detach and reattach.
**Cons:** tmux server runs as `agent` user, which is what you want, but `sudo -u agent tmux attach` from your user can have socket permission issues. The SSH approach avoids this entirely (tmux inside the SSH session just works).

---

## Agent User Environment Setup

The agent user needs its own toolchain. This is a one-time setup:

```bash
# SSH in or sudo -u agent -i
ssh agent@localhost

# Install Homebrew (agent's own copy, or use system Homebrew if world-readable)
# Option A: Shared Homebrew (simpler — /opt/homebrew is world-readable on macOS)
# Just works: agent can run brew-installed binaries.
# But agent can't `brew install` without admin rights. Pre-install what you need.

# Option B: Agent's own Homebrew (full independence)
# Not recommended — duplicates disk usage, maintenance burden.

# Install Node.js (for Pi) — via your shared Homebrew
which node  # should work if Homebrew's node is installed

# Install Pi
npm install -g @mariozechner/pi-coding-agent

# Set up API keys
echo 'export ANTHROPIC_API_KEY="sk-ant-..."' >> ~/.zshrc
# Use a DIFFERENT API key than your personal one if possible.
# This way you can revoke it independently if compromised.

# Set up git
git config --global user.name "Pi Agent"
git config --global user.email "agent@localhost"  # or your real email
# Use a fine-grained PAT for HTTPS auth (see matchlock-setup-guide.md)

# Set up micromamba if using Python projects
# Install into /Users/agent/micromamba

# Pi configuration — copy or symlink
mkdir -p ~/.pi/agent
cp /Users/Shared/workspace/pi-config/AGENTS.md ~/.pi/agent/
# Or symlink to a shared read-only copy
```

### Homebrew Sharing: The Details

On Apple Silicon Macs, Homebrew installs to `/opt/homebrew/`, which is world-readable:

```
drwxrwxr-x  root  admin  /opt/homebrew
```

The `agent` user **can execute** anything installed by Homebrew but **cannot install new packages** (requires admin group membership). This is actually ideal:

- You (admin user) install tools: `brew install node python git`
- Agent user runs them
- Agent cannot install arbitrary packages — reduces attack surface

If the agent needs to install something mid-session (e.g., `brew install jq`), it fails. You install it from your user, then the agent retries. Mildly inconvenient, but a security feature.

---

## Threat Model Comparison

How does "separate user" compare to the threats from [Matchlock setup guide](matchlock-setup-guide.md)?

| Threat | No isolation | Separate user | Matchlock VM |
|--------|-------------|---------------|-------------|
| Agent reads `~/.ssh/`, `~/.aws/` | ✅ Full access | ❌ **Blocked** | ❌ Blocked |
| Agent reads browser data, photos, docs | ✅ Full access | ❌ **Blocked** | ❌ Blocked |
| Agent reads Keychain | ✅ Full access | ❌ **Blocked** | ❌ Blocked |
| Agent exfiltrates project code to attacker server | ✅ Possible | ⚠️ **Still possible** — has network | ⚠️ Still possible to allowed hosts |
| Agent exfiltrates its own API keys | ✅ Possible | ⚠️ **Still possible** — has network | ❌ Blocked (keys never enter VM) |
| Agent corrupts/deletes project files | ✅ Yes | ⚠️ Yes (if shared dir) | ⚠️ Yes (if mounted) |
| Agent installs persistent malware | ✅ In your user space | ⚠️ In agent's user space — but survives reboot | ❌ VM is ephemeral |
| Agent runs `rm -rf /` | ⚠️ Damages your user files | ⚠️ Damages agent's home + shared dirs only | ⚠️ Damages VM + mounted dirs |
| Agent exploits kernel vuln | ✅ Host compromise | ✅ Host compromise | ❌ Contained in VM |
| Agent fork-bombs / OOMs | ✅ Affects your machine | ✅ Affects your machine | ❌ Contained in VM |

**The key insight:** Separate user eliminates the **most probable, most damaging** scenario — agent accessing your personal files. It does NOT address network-based threats (exfiltration, contacting attacker C2 servers). For personal projects on a personal Mac, the personal-files threat is the one that keeps you up at night. Network exfiltration of code is bad but recoverable; exfiltration of SSH keys, session cookies, or Keychain data is catastrophic.

### Layering: Separate User + Matchlock

These are complementary, not alternatives:

1. **Separate user alone:** Protects personal files. Agent still has unrestricted network. Good enough for most personal dev.
2. **Matchlock alone:** Protects network + kernel. But you must configure mounts carefully — one wrong `-v` flag and your personal files are exposed.
3. **Both together:** Run Matchlock from the agent user. Even if Matchlock's FUSE bridge has the path traversal bug, the agent user can't reach your home directory. Defense in depth.

If you eventually adopt Matchlock, doing it from a dedicated user account means a misconfigured mount can only expose the agent user's files (API keys in env — still bad, but not your SSH keys or browser data).

---

## Practical Workflow

### Daily Pattern

```
# Terminal 1: Your normal work (user: js)
vim ~/projects/something/main.py

# Terminal 2: Agent session (user: agent)
ssh agent@localhost
cd /Users/Shared/workspace/project
pi
# Agent works, commits, you review via git
```

Or in tmux:

```
# Pane 0: your editor
# Pane 1: ssh agent@localhost → pi session
# Pane 2: your normal shell
```

### Git Workflow

Both users can push/pull from the shared workspace. Commits show different authors:

```
commit abc1234 Author: Pi Agent <agent@localhost>    ← agent's work
commit def5678 Author: Your Name <you@email.com>    ← your work
```

This is actually a feature — clear attribution of what the agent did vs. what you did.

**Conflict risk:** If both users edit the same file simultaneously, you get filesystem-level conflicts (last write wins, no merge). Mitigate by:
- Don't edit the same project simultaneously without git coordination
- Or use Approach 3 (agent works in its own clone) and merge via git

### When the Agent Needs a New Tool

```
# Agent session: "I need jq to parse this JSON"
# Agent can't install it. You switch to your terminal:
brew install jq
# Agent retries — jq is now available.
```

Not seamless, but infrequent after initial setup.

---

## Edge Cases and Gotchas

### macOS TCC (Transparency, Consent, and Control)

macOS 10.15+ has per-app/per-user privacy controls for camera, microphone, screen recording, accessibility, full disk access, etc. The agent user:
- Has **no** Full Disk Access by default (can't read other users' files even with root-owned process)
- Has **no** accessibility permissions (can't control other apps)
- TCC database is per-user — agent's TCC grants don't affect your TCC grants
- This is an additional layer of protection beyond Unix permissions

### FileVault

If FileVault is enabled, the agent user needs to be added to the list of users who can unlock the disk at boot. This is optional — if you always boot and log in as `js` first, the agent user doesn't need FileVault access. Only matters if you want the agent user to unlock the disk at startup.

### Spotlight / mdworker

Spotlight indexes the agent's home directory. If the agent creates many temp files, this causes disk I/O. Minor — but you can exclude `/Users/agent` from Spotlight indexing in System Settings.

### `/tmp` and `/var/tmp`

World-writable. Both users share these. If the agent writes sensitive temp files here, you (or any process) can read them. The agent should use `mktemp -d` for temp dirs (which creates with 700 permissions), but a compromised agent won't follow conventions. Low risk in practice.

### Login Window

The agent user appears on the macOS login screen. Cosmetic annoyance. You can hide it:

```bash
sudo dscl . create /Users/agent IsHidden 1
```

---

## Cost / Benefit Summary

| | Cost | Benefit |
|-|------|---------|
| Setup | ~15 minutes (create user, shared dir, install tools) | Personal file isolation — kernel-enforced |
| Ongoing | Minimal — occasional `brew install` from admin user | Zero maintenance, zero allowlist, zero config drift |
| Workflow friction | One extra terminal/SSH session | Clear audit trail (separate git author) |
| What you give up vs. Matchlock | No network isolation, no kernel isolation, no ephemeral environment | No allowlist debugging, no image rebuilds, no 20-flag command |

**This is the 80/20 play.** 15 minutes of setup eliminates the most likely and most damaging threat (personal file access) with zero ongoing maintenance. Matchlock adds the remaining 20% of protection (network, kernel) at 10x the maintenance cost. For personal dev on a personal Mac, the separate user is the right starting point — and you can layer Matchlock on top later if your threat model warrants it.

---

## Sources

- macOS file permissions model: direct observation on Apple Silicon (macOS 15.x)
- [Matchlock setup guide](matchlock-setup-guide.md) — threat model and comparison baseline
- [Apple: sysadminctl](https://support.apple.com/en-us/102561) — user management CLI
- [Apple: TCC](https://developer.apple.com/documentation/security/app-sandbox) — Transparency, Consent, and Control framework
- macOS `dscl`, `chmod`, `chown` man pages
