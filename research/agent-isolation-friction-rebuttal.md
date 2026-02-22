← [Agent as Separate macOS User](agent-separate-macos-user.md) · [Index](../README.md)

# Agent Isolation Friction: Self-Rebuttal

**Date:** 2026-02-21
**Context:** Critical review of the argument that OS-level agent isolation "isn't worth the friction" for general-purpose agent use.

---

## The Argument Being Challenged

After writing the [separate macOS user guide](agent-separate-macos-user.md), the initial reaction was: isolation causes too much friction for a general-purpose agent. Email, calendar, system troubleshooting — these "personal" tasks require exactly the access isolation blocks. The recommendation was to skip isolation, run the agent as yourself, and accept residual risk.

**That recommendation was wrong.** Here's why, point by point.

---

## Problem 1: The Threat Is Not Low-Frequency

The claim was that prompt injection via untrusted content is "low-frequency" and the threat model is "narrow." In reality:

- **brave-search** runs in nearly every research session — fetches and parses arbitrary web content
- **npm install / pip install** happens at the start of every project — pulls code and READMEs written by strangers
- **git clone** of any repo the agent works with
- **Error messages** from compilers, linters, test runners include content from untrusted code
- **HN threads, Stack Overflow, blog posts** — every web page the agent reads is a potential injection surface

The agent processes untrusted input in *nearly every session*, not occasionally. And the attacker doesn't need to target you specifically. Spray-and-pray works: a poisoned npm package, hidden text in a web page, invisible prompts in a popular Stack Overflow answer. These hit anyone with an agent processing web content — an increasingly attractive target population.

---

## Problem 2: The Installed-Software Analogy Was Wrong

The claim: "The residual risk is comparable to installing any software you didn't audit." This analogy is categorically wrong.

**Software you install:**
- Runs deterministically (same input → same output)
- Doesn't take runtime instructions from untrusted web content
- Is sandboxed by macOS to some degree (App Sandbox, Gatekeeper, TCC)
- Doesn't have a general-purpose "execute any bash command" capability

**An AI agent:**
- Takes instructions from a mix of trusted (you) and untrusted (web content, code, error messages) sources
- Has bash access — can do literally anything the user can do
- Makes novel decisions each run — you can't predict what it will do
- Is specifically *designed to be instructed* — that's the attack surface for prompt injection

Prompt injection exploits the agent's core capability, not a bug. This is fundamentally different from conventional software exploits.

---

## Problem 3: Frequency vs. Expected Value

The analysis optimized for "most likely damage scenarios" (accidental deletion, runaway processes) and dismissed high-impact scenarios (credential theft, personal data exfiltration) as low-probability.

This is a textbook risk assessment error. Expected damage = probability × impact.

**What "residual risk" actually means on a personal Mac:**
- **SSH keys exfiltrated** → attacker has push access to all repos on all services
- **Browser cookies/session tokens** → attacker has your logged-in sessions (GitHub, Gmail, banking)
- **Keychain data** → passwords for everything
- **Personal documents** → photos, tax returns, medical records
- **`.env` files across projects** → API keys for every service you use

Low probability × catastrophic, irreversible impact ≠ acceptable residual risk. You don't skip seatbelts because crashes are rare.

---

## Problem 4: "Do Nothing" Dressed as Pragmatism

The proposed mitigations:

| Mitigation | Addresses credential theft? | Addresses data exfiltration? |
|------------|---------------------------|------------------------------|
| Git for rollback | ❌ Only helps with code | ❌ No |
| Fine-grained PATs | ⚠️ GitHub only | ❌ No |
| Don't put secrets in env vars | ❓ Where do they go? Agent needs API keys | ❌ No |
| Review before push | ❌ Prevents bad commits, not exfiltration | ❌ No |
| "Accept residual risk" | — Not a mitigation | — Not a mitigation |

Three of five don't address the high-impact threats at all. The fifth isn't a measure, it's resignation. This list was presented as sufficient when it's clearly not.

---

## Problem 5: The Friction Was Overclaimed

The central argument was that "personal tasks" like email, calendar, and system troubleshooting require full home directory access, making isolation a straitjacket. This conflated "personal tasks" with "personal file access" without checking which tasks actually need what.

**Email:** If using Gmail or any web-based mail, the agent needs API credentials or OAuth tokens, not filesystem access to `~/Library/Mail/`. A separate user with a Gmail API key works fine.

**Calendar:** Google Calendar API or CalDAV, not local `~/Library/Calendars/` files. Works from any user.

**System troubleshooting:** `log show`, `diskutil`, `top`, `ps`, `df`, `sw_vers`, `system_profiler`, `networksetup` — all work as any user. Most system diagnostics don't require your home directory.

**Dotfiles:** Selectively copy or symlink specific files (`.zshrc`, `.gitconfig`) to the agent's home. You control exactly what's shared.

**The actual tasks that require your personal files** — browsing `~/Documents`, reading local Mail.app data, accessing photos — are a small subset. Not the common case.

---

## Problem 6: Binary Thinking

The original analysis framed this as a binary: either full isolation (straitjacket) or full access (run as yourself). The actual answer is tiered:

**Default state:** Agent runs as `agent` user. Isolated from personal files. Handles coding, research, calendar (via API), email (via API), system troubleshooting — all fine.

**Occasional escalation:** When a task genuinely needs something from your home directory, you explicitly provide it:
- Copy the specific file to the shared workspace
- Pipe content to the agent's session
- Temporarily symlink a single directory

Each escalation is informed, deliberate, and auditable. You know exactly what you're exposing and why.

**Never permanent:** Don't mount `~/` into the agent's workspace "for convenience." Each exception should be temporary and task-specific. Once the task is done, remove the access.

This is friction, but it's *proportional* friction — you pay the cost only when the access is actually needed. Most sessions won't need it.

---

## Corrected Assessment

| Original claim | Correction |
|----------------|------------|
| Threat is low-frequency | Agent processes untrusted content in nearly every session |
| Risk is comparable to installing unaudited software | Categorically different — agent is designed to follow instructions, including malicious ones |
| Most likely scenarios are what matter | Expected value (probability × impact) is what matters; credential theft is catastrophic |
| Proposed mitigations are sufficient | Three of five don't address the actual high-impact threats |
| Isolation causes too much friction for personal tasks | Most "personal" tasks work via APIs, not local file access; friction is narrower than claimed |
| Binary choice: full isolation or full access | Tiered access with per-task escalation is the right model |

---

## Revised Recommendation

The [separate macOS user approach](agent-separate-macos-user.md) is the right default. The friction is real but manageable and narrower than initially claimed. "Just run open" was the easy answer, not the right one.

For the small set of tasks that genuinely require personal file access, use intentional per-task grants rather than abandoning isolation entirely. The security payoff — kernel-enforced protection of SSH keys, Keychain, browser data, personal documents — justifies the occasional `cp` or symlink.

---

## Sources

- [Agent as Separate macOS User](agent-separate-macos-user.md) — the setup being evaluated
- [Matchlock Setup Guide](matchlock-setup-guide.md) — threat model baseline
- [HN: Matchlock Agent Sandbox](hn-matchlock-agent-sandbox.md) — Claude Cowork exfiltration proof, prompt injection as realistic attack
