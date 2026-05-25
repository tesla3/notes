← [Coding Agents](../topics/coding-agents.md) · [Index](../README.md)

# Best of Pi + Nono: How to Combine Them

*February 19, 2026. Based on nono v0.5.0 (homebrew tap) and pi v0.45.x.*

---

## The Short Answer

Yes, you can get the best of both. They solve different problems at different layers and **compose in principle**. But the integration has real friction and unresolved questions that need testing before you trust it. The right question isn't "pi or nono" — it's "which combination of layers gives me the security I want without breaking the workflow I need."

---

## Why This Isn't Obvious

Pi and nono have **complementary philosophies that create a real integration puzzle:**

| | Pi | Nono |
|---|---|---|
| Security stance | "Not our job — sandbox externally" | "Security is the whole point" |
| What it wraps | LLM ↔ tools ↔ user | Any CLI process, kernel-level |
| Granularity | Per-bash-command (via extensions) | Per-process (whole agent) |
| Network control | Extension can whitelist domains per bash call | All-or-nothing (`--net-block`); fine-grained controls "coming soon" |
| Secret handling | Env vars, agent reads `~/.config` | Keystore injection, filesystem never exposed |
| Audit trail | None built-in | Tamper-resistant JSON logs (claimed) |
| Rollback | None built-in | **Uncertain** — README claims snapshots; blog (Feb 16) says "actively developing atomic rollbacks" |

The puzzle: **nono wraps the whole process, but pi needs different security policies for itself vs. for the bash commands the LLM runs.** Pi itself needs network (to call LLM APIs) and filesystem access (to read config, sessions, extensions). The bash commands the LLM generates are the untrusted part.

---

## ⚠️ The Delete Protection Problem

This needs to be front and center, not buried.

Nono's documentation states that `unlink`/`rmdir` syscalls are blocked at the kernel level with **no override**. The DEV.to article's defense-in-depth table says:

| Layer | Protection | Can Be Overridden? |
|-------|------------|-------------------|
| Command blocklist | Blocks rm, dd, chmod, sudo | Yes, with `--allow-command` |
| Kernel (delete) | Blocks unlink/rmdir syscalls | **No** |
| Kernel (truncate) | Prevents zeroing out files | **No** |

The DEV.to article explicitly says: *"Even allowed paths can't have files deleted."*

On Linux, Landlock distinguishes `LANDLOCK_ACCESS_FS_WRITE_FILE` from `LANDLOCK_ACCESS_FS_REMOVE_FILE` / `LANDLOCK_ACCESS_FS_REMOVE_DIR`. Nono likely grants write but not remove within allowed paths.

**If this is accurate, the following break inside the sandbox:**
- `npm install` / `npm ci` (deletes and replaces files in `node_modules/`)
- `git checkout`, `git switch`, `git stash` (removes/replaces tracked files)
- `cargo build` (cleans build artifacts)
- `pip install` (replaces packages in site-packages)
- Any build tool that does cleanup before rebuilding
- Even `sed -i` on some platforms (writes to temp file, unlinks original, renames)

This is not a theoretical edge case — it's the core workflow of a coding agent. If the agent can't run `npm install` or `git checkout`, it can't do development work.

**Possible explanations I can't verify without testing:**
1. Built-in profiles (like `claude-code`) might relax delete restrictions for allowed paths — but the docs say "No override"
2. Maybe the delete protection only applies outside `--allow` paths — but the docs say "even allowed paths"
3. Maybe the docs are aspirational/simplified and the actual behavior is more nuanced

**Until tested with pi, treat this as a potential showstopper for Approach 1 and 2.** The safest path is to try nono with a toy project first and see what breaks.

---

## Three Approaches, Ranked

### Approach 1: Nono as Outer Wrapper (Works Today — With Caveats)

```bash
# ⚠️ Flag names may differ between v0.5.0 (homebrew tap) and current README.
# v0.5.0 may use --allow . instead of --allow-cwd. Check nono --help.
nono run \
  --allow-cwd \
  --read ~/.pi \
  --read /opt/homebrew/lib/node_modules/@mariozechner \
  --read ~/.nvm \
  --secrets ANTHROPIC_API_KEY \
  -- pi
```

**What this gives you:**
- ✅ Kernel-enforced filesystem isolation — agent can't read `~/.ssh`, `~/.aws`, `~/.gnupg`
- ✅ Secure secret injection — API key loaded from macOS Keychain, never on disk
- ✅ Child process inheritance — everything pi spawns is equally restricted
- ✅ Audit trail (claimed in README)
- ⚠️ Rollback snapshots — **unclear if shipped.** README says yes; blog from Feb 16 says "actively developing atomic rollbacks." Contradictory.
- ⚠️ Delete protection — may prevent normal dev tools from working (see warning above)

**What it doesn't solve:**
- ❌ **Network exfiltration** — can't use `--net-block` because pi itself needs to reach `api.anthropic.com`, `generativelanguage.googleapis.com`, etc. Nono's fine-grained network controls are "coming soon" but not shipped.
- ❌ **No per-command granularity** — every bash command gets the same filesystem policy.

**Practical friction:**
- Pi needs read access to its own installation path, `~/.pi/`, Node.js runtime, and **write access** to `~/.pi/agent/sessions/` for session persistence. You must add all these paths.
- Nono has built-in profiles for `claude-code`, `opencode`, and `openclaw` — **no pi profile yet.** You'd craft the right flags manually.
- **Homebrew tap name uncertainty:** Older sources (YouTube, ~2 weeks ago) use `brew tap lukehinds/nono`. Newer sources (blog, 3 days ago; lib.rs) use `brew tap always-further/nono`. The v0.5.0 release may be on the older tap. Check both if install fails.
- **CLI flag names may have changed** between v0.5.0 and the current README (which reflects an in-progress refactor). Run `nono --help` to verify.

**Verdict:** Good concept for filesystem + secrets protection. But the delete protection issue and version instability mean you need to test before relying on it. Try with a disposable project first.

### Approach 2: Defense in Depth — Nono Outside + Pi's Sandbox Extension Inside

Pi ships an example sandbox extension at `examples/extensions/sandbox/` that uses Anthropic's `@anthropic-ai/sandbox-runtime`. This extension does something nono can't: **it sandboxes only the bash tool, not pi itself.**

```
┌──────────────────────────────────────────────────────┐
│  nono (kernel-level)                                  │
│  ✗ ~/.ssh, ~/.aws, ~/.gnupg blocked                  │
│  ⚠️ unlink/rmdir may be blocked (see warning above)  │
│  ✓ ~/.pi, node_modules, CWD accessible               │
│  ✓ Secrets injected from keystore                    │
│                                                      │
│  ┌──────────────────────────────────────────────┐    │
│  │  pi (agent runtime)                          │    │
│  │  ✓ Full access to LLM APIs (network open)    │    │
│  │  ✓ Config, sessions, extensions accessible    │    │
│  │                                              │    │
│  │  ┌──────────────────────────────────────┐    │    │
│  │  │  bash tool (Anthropic sandbox-runtime)│    │    │
│  │  │  ✗ Network restricted to whitelist   │    │    │
│  │  │  ✗ Write restricted to CWD + /tmp    │    │    │
│  │  │  ✗ ~/.ssh, .env, *.pem denied        │    │    │
│  │  └──────────────────────────────────────┘    │    │
│  └──────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────┘
```

**What this layered approach aims to give you:**

| Threat | Layer that catches it |
|--------|----------------------|
| Agent reads `~/.ssh` | **Both** (nono kernel blocks + extension blocks) |
| Agent deletes project files | **Nono** (unlink blocked at syscall level — but see delete warning) |
| Bash command does `curl evil.com` | **Pi sandbox extension** (network whitelist) |
| Agent exfiltrates via bash `wget` | **Pi sandbox extension** (only npmjs.org, github.com, etc. allowed) |
| Malicious extension code reads secrets | **Nono** (keystore injection, no file to read) |
| API keys on disk | **Nono** (secrets never touch filesystem) |

**Setup:**

1. Install nono:
   ```bash
   # Try the newer tap first; fall back to older if it fails
   brew tap always-further/nono && brew install nono
   # OR: brew tap lukehinds/nono && brew install nono
   ```
2. Store your API key in macOS Keychain:
   ```bash
   # ⚠️ Use $(which nono) to get the actual binary path.
   # On Apple Silicon: likely /opt/homebrew/bin/nono
   # On Intel Mac: likely /usr/local/bin/nono
   security add-generic-password \
     -T "$(which nono)" \
     -s "nono" \
     -a "ANTHROPIC_API_KEY" \
     -w "sk-ant-your-key-here"
   ```
   **Uncertainty:** The nono README shows lowercase account names (e.g., `openai_api_key`) but pi expects uppercase `ANTHROPIC_API_KEY`. Nono's `--secrets` flag injects the value as an env var — but it's unclear if the env var name matches the account name exactly. If pi can't find the key, try storing with lowercase name and checking if nono uppercases it, or vice versa.

3. Install pi's sandbox extension:
   ```bash
   cp -r /opt/homebrew/lib/node_modules/@mariozechner/pi-coding-agent/examples/extensions/sandbox ~/.pi/agent/extensions/
   cd ~/.pi/agent/extensions/sandbox && npm install
   ```
4. Configure sandbox (`~/.pi/agent/sandbox.json`):
   ```json
   {
     "enabled": true,
     "network": {
       "allowedDomains": [
         "api.anthropic.com", "*.anthropic.com",
         "generativelanguage.googleapis.com",
         "api.openai.com",
         "npmjs.org", "*.npmjs.org",
         "github.com", "*.github.com",
         "pypi.org", "*.pypi.org"
       ]
     },
     "filesystem": {
       "denyRead": ["~/.ssh", "~/.aws", "~/.gnupg", "~/.kube", "~/.docker"],
       "allowWrite": [".", "/tmp"],
       "denyWrite": [".env", ".env.*", "*.pem", "*.key"]
     }
   }
   ```
5. Launch — the sandbox extension auto-loads from `~/.pi/agent/extensions/sandbox/` (no `-e` flag needed):
   ```bash
   nono run \
     --allow-cwd \
     --read ~/.pi \
     --read /opt/homebrew/lib/node_modules/@mariozechner \
     --write ~/.pi/agent/sessions \
     --secrets ANTHROPIC_API_KEY \
     -- pi
   ```
   To disable the sandbox extension for a run without uninstalling: `pi --no-sandbox`

**Can the sandboxes nest?** Maybe. Landlock (Linux) is explicitly designed for stacking — each layer can only be more restrictive. **Seatbelt (macOS) nesting is unverified.** Both nono and Anthropic's sandbox-runtime use Seatbelt on macOS. Whether a process already under a Seatbelt profile can have children with additional Seatbelt restrictions applied is not well-documented by Apple. If they conflict, bash commands inside pi's sandbox extension might fail with sandbox violations when the outer nono sandbox is also active. **This needs testing on macOS before relying on it.**

**Verdict:** The architecture is sound — two layers covering each other's gaps. But three unknowns remain: (1) delete protection breaking dev tools, (2) Seatbelt nesting on macOS, (3) secret injection env var naming. Test all three before trusting this setup.

### Approach 3: Nono's TypeScript SDK Inside Pi (Future — Speculative)

Nono's README shows `nono-ts` bindings as "Coming Very Soon":

```typescript
import { CapabilitySet, AccessMode, apply } from "nono-ts";

const caps = new CapabilitySet();
caps.allowPath("/data/models", AccessMode.Read);
caps.allowPath("/tmp/workspace", AccessMode.ReadWrite);

apply(caps); // Irreversible — kernel-enforced from here on
```

**⚠️ Critical architectural problem with this API for per-command sandboxing:**

`apply(caps)` sandboxes the **calling process** irreversibly. If a pi extension calls `apply()`, it sandboxes pi itself — not just the bash child process. You can't un-sandbox to apply different policies to different commands.

For per-command sandboxing from a pi extension, you'd need to:
1. Fork a child process
2. In the child, call `apply()` with command-specific capabilities
3. Exec the bash command in that child

Whether `nono-ts` will expose a spawn/fork helper for this pattern is unknown. The library API might look completely different from my original speculative code. **Don't design around this API until it ships and you can read the actual docs.**

**What it could give you (if the API supports per-command sandboxing):**
- Nono's audit trail integrated into pi's session
- Rollback snapshots as a pi `/undo` command (if rollback ships)
- Nono's `why` diagnostic exposed as a pi command
- Single sandbox library instead of two different ones

**Timeline reality check:** Nono-ts hasn't shipped. The repo is less than 30 days old (not yet in homebrew-core). "Coming very soon" in an early alpha could be weeks or months. Don't wait for this.

---

## What Nono Can't Fix (And What Can)

### The Extension/npm Supply Chain Problem

Nono sandboxes the agent process. But pi extensions are TypeScript that runs *inside* pi's process. A malicious extension executes with pi's full permissions — inside or outside the sandbox. Nono's filesystem restrictions help (the extension can't read `~/.ssh`), but a malicious extension could:

- Exfiltrate data through the LLM API connection (pi already has network access to API endpoints)
- Modify pi's behavior to ignore sandbox restrictions for future commands
- Read the API key from the environment variable that nono injected (nono protects the keystore file, but the env var is readable by in-process code)

**Mitigation:** Review extension source code before installing. This is pi's stated policy and it's the right one. Nono reduces the blast radius but doesn't eliminate the insider threat of in-process code.

### Model-Level Prompt Injection

If someone poisons a file in your codebase with hidden instructions, the LLM might follow them. Neither nono nor pi's sandbox can prevent the LLM from *wanting* to do something bad — they can only prevent the bad action from succeeding at the OS level.

**This is exactly why sandboxing matters:** Accept that prompt injection will happen, make the consequences survivable.

---

## Practical Recommendation For Your Setup

You use Pi with Claude Opus 4.6 via Anthropic API, on macOS.

**Step 1 — Low risk, do now (10 minutes):**

Install pi's sandbox extension for per-bash-command protection. This is purely within pi's ecosystem, no new external tool, and uses Anthropic's battle-tested sandbox-runtime:

```bash
cp -r /opt/homebrew/lib/node_modules/@mariozechner/pi-coding-agent/examples/extensions/sandbox ~/.pi/agent/extensions/
cd ~/.pi/agent/extensions/sandbox && npm install
```

This closes the `curl evil.com` exfiltration gap and blocks bash from reading `~/.ssh`. The extension auto-loads. Disable per-session with `pi --no-sandbox`.

**Step 2 — Medium risk, when curious (30 minutes):**

Install nono and test with a disposable project. Specifically verify:
1. Can `npm install` complete inside the sandbox? (delete protection)
2. Can `git checkout` work? (delete protection)
3. Does pi's sandbox extension work inside nono on macOS? (Seatbelt nesting)
4. Does `--secrets ANTHROPIC_API_KEY` inject the env var with the right name?

```bash
brew tap always-further/nono && brew install nono
cd /tmp/test-project && npm init -y
nono run --allow-cwd -- pi
# Try: "run npm install lodash, then git init and make a commit"
```

If these work, create the full alias:
```bash
# Shell function (more reliable than multi-line alias)
pis() {
  nono run \
    --allow-cwd \
    --read ~/.pi \
    --read /opt/homebrew/lib/node_modules/@mariozechner \
    --write ~/.pi/agent/sessions \
    --secrets ANTHROPIC_API_KEY \
    -- pi "$@"
}
```

**Step 3 — Watch and wait:**
- Nono is pre-1.0 alpha, iterating fast. Check back monthly for: stable 1.0, pi profile, fine-grained network controls, nono-ts SDK, and resolution of the delete protection question.

---

## Summary of Uncertainties

| Claim in original draft | Status | Impact |
|------------------------|--------|--------|
| Rollback snapshots work | **Contradicted** by blog vs README | Feature may not exist yet |
| Delete protection is a benefit | **Potentially a showstopper** | May break npm/git/cargo |
| Seatbelt sandboxes nest cleanly | **Unverified** | Approach 2 may not work on macOS |
| `nono-ts apply()` enables per-command sandboxing | **Architecturally wrong** | Approach 3 code was misleading |
| `brew tap always-further/nono` | **Uncertain** | Older tap `lukehinds/nono` may be needed for v0.5.0 |
| `-T /usr/local/bin/nono` for keychain | **Wrong on Apple Silicon** | Should use `$(which nono)` |
| `pi -e sandbox` to load extension | **Wrong** | Auto-loads from `~/.pi/agent/extensions/` |
| Secret injection env var naming | **Unverified** | May need case adjustment |

---

## Key Insight

Your existing research concluded: "sandboxing is the security primitive that matters, and it is language-agnostic." This analysis confirms it, and takes the next step: **the best sandbox would be layers** — nono for the kernel perimeter, pi's extension for per-command policy.

But the honest conclusion is that **this combination hasn't been tested by anyone yet.** Nono is 3 weeks old. Pi doesn't have a nono profile. The two tools' authors haven't collaborated. The delete protection semantics are unclear. Seatbelt nesting is undocumented.

The safest immediate win is pi's sandbox extension alone (Step 1). It uses Anthropic's proven sandbox-runtime, handles per-bash-command network and filesystem restrictions, and introduces zero new dependencies. Adding nono on top is promising but experimental.

---

*Nono is pre-1.0 alpha. Every claim about its behavior should be verified against `nono --help` and actual testing, not just README/blog text. This document will need updating as nono stabilizes.*
