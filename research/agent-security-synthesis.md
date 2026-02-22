← [Coding Agents](../topics/coding-agents.md) · [Index](../README.md)

# Agent Security: Synthesis

**Date:** 2026-07-21
**Distilled from:** 10 research files, ~45K words. [Sources](#sources) at bottom.

---

## The Fundamental Constraint

Prompt injection is unsolved. Everything in agent security follows from this.

A compromised agent uses the same API calls, network connections, and system commands as a correctly-functioning one. There is no observable difference — not during execution, not in logs after the fact. This isn't a bug to be fixed; it's inherent to how agents work. They're *designed* to follow instructions, and a prompt injection is just another instruction.

The specific failure this creates: an agent exfiltrates data through the channels it legitimately needs. Claude Cowork proved this — a crafted document caused the agent to `curl api.anthropic.com` (a host it *must* be able to reach) with an attacker's API key, uploading victim files. No sandbox, allowlist, or firewall can block this because the traffic looks identical to normal operation.

**What sandboxing actually buys:** protection against the *solvable* attacks — accidental damage, credential theft via unauthorized destinations, personal file access. These are real threats worth mitigating. But no sandbox addresses exfiltration through authorized channels. Call the entire product category what it is: **prompt-injection damage mitigation**, not security.

---

## What Actually Goes Wrong

| Threat | Sandboxable? | Notes |
|--------|:---:|-------|
| Accidental `rm -rf`, bad git ops | ✅ | Most common. Git recovers most of it. |
| Agent reads SSH keys, Keychain, browser data | ✅ | Requires prompt injection. Catastrophic if it happens — these credentials unlock everything else. |
| Credential exfiltration to attacker's server | ✅ | Network allowlisting blocks this. |
| Data exfiltration through *allowed* APIs | ❌ | The confused deputy. Unsolvable with current techniques. |
| Agent wipes remote DB or repo | ❌ | The credential blast radius problem. Sandbox can't help if the agent has the tokens. |
| LLM-generated sandbox escape | ⚠️ | Theoretical today. Heelan's research (40+ zero-day exploits at $30-50/chain) shows the capability curve is steep. Defense-in-depth buys time. |

**Approval fatigue** deserves its own row. Permission prompts don't fail technically — they fail psychologically. Users mash Enter after the 50th prompt. This is the Windows Vista UAC problem, recreated. It's why `--dangerously-skip-permissions` exists and why everyone uses it.

---

## The Capability–Isolation Tradeoff

Every sandbox faces the same dilemma: useful agents need access to exactly the things that are dangerous (package managers, Docker, databases, network, git). Restrict them → agent is crippled. Permit them → sandbox is porous.

No tool has resolved this. The 25+ sandbox tools that exist as of mid-2026 represent 25+ different positions on this tradeoff curve, not 25+ solutions to the problem. They haven't converged because the tradeoff is genuine — there is no position that is clearly right.

### Tiers by Isolation Strength

| Tier | Examples | What it adds | What it can't do | Friction |
|------|----------|-------------|-----------------|----------|
| **Nothing** | Bare metal, YOLO mode | — | — | Zero |
| **Separate OS user** | `useradd`, dedicated macOS account | Kernel-enforced personal file isolation | No network control, no credential protection, shared kernel | Low |
| **OS sandbox** | bubblewrap, Seatbelt, Landlock | Filesystem + partial network restrictions | Shared kernel; Claude Code's built-in sandbox has a self-escape hatch and known bypasses | Low-medium |
| **Container** | Docker, devcontainer, Podman | Filesystem + process isolation | Shared kernel (container escape = host compromise); DinD problem for agents that need Docker | Medium |
| **Micro-VM** | Matchlock, Gondolin, Docker MicroVMs (coming) | Separate kernel + network allowlisting + secret injection | Authorized-channel exfiltration; mounted project dirs still exposed | High |
| **Dedicated hardware** | Mac Mini, VPS, PXE-boot | Physical air gap | Still exposed to whatever credentials you give the agent | Medium ($$) |

Each tier adds protection for the *solvable* attacks at the cost of more friction. None addresses the *unsolvable* one (authorized-channel exfiltration).

### The Two Serious Local VM Tools

**Matchlock** — stronger foundation. Firecracker VM (~50K LOC Rust), seccomp-BPF, capability drops. Empirically red-teamed: Opus 4.6 tried kernel module loading, ptrace exploitation, metadata service probing, vsock crafting. Defenses shaped by what the LLM actually attempted.

**Gondolin** — more sophisticated policy. JS-programmable network stack with protocol classification (deny everything that isn't HTTP/TLS/SSH), synthetic DNS that eliminates DNS tunneling entirely, symlink-aware VFS, MemoryProvider that avoids the host filesystem bridge altogether.

Neither is mature. The ideal tool combines Matchlock's VM boundary with Gondolin's network stack. It doesn't exist.

---

## The Exploit Curve Changes the Timeline

Sean Heelan pointed Opus 4.5 and GPT-5.2 at a zero-day QuickJS vulnerability and got 40+ working exploits — bypassing ASLR, CFI, hardware shadow stacks, and seccomp simultaneously — at $30-50 per chain. The hardest solve chained 7 glibc exit-handler calls, a technique Heelan hadn't seen documented.

This matters for sandbox decisions because: sandbox defenses are static; the attacker improves every model generation. Today's Firecracker boundary holds. Whether it holds in 2027 against models 10× more capable at exploit generation is a bet, not a fact. Defense-in-depth (Matchlock's layered approach) buys time. A single-layer VM boundary (Gondolin's current design) is more exposed to this curve.

---

## Autonomous vs. Interactive: Different Threat Models

The agent security landscape splits into two worlds that need different protections:

| | Autonomous (OpenClaw, 24/7 Mac Mini) | Interactive (Pi, Claude Code, you're watching) |
|-|-------|------------|
| Attack window | Always open | Only while you're present |
| Detection speed | Minutes to hours | Seconds (you see it) |
| Kill switch | Remote command | Ctrl-C |
| Primary risk | Unmonitored compromise accumulates | Approval fatigue, stepping away briefly |

Being on-screen is a real security control — not sufficient alone, but it meaningfully shrinks the attack window. The OpenClaw crowd needs heavy isolation because nobody's watching. Interactive use tolerates lighter measures.

**Honest caveat:** You don't read every tool call. A subtle `curl` buried in a build sequence, or data embedded in a legitimate API request body, is easy to miss even while watching.

---

## Personal Posture

**Context:** Pi coding agent on personal Mac. Interactive use only. Personal data on machine.

### Adopted

| Measure | What it protects | Cost |
|---------|-----------------|------|
| **Dedicated macOS user** | SSH keys, Keychain, browser data, personal files. Kernel-enforced — nothing to configure or maintain. | ~1hr setup, SSH per session |
| **LuLu outbound firewall** | Catches exfiltration to unauthorized hosts in real-time. | Free. Learning baseline takes a few days. |
| **Dedicated agent Google account** | Personal email/calendar never exposed to the agent. | ~30min setup. |
| **Fine-grained GitHub PATs** | Blast radius limited to specific repos with minimum permissions. | 10min per token. |
| **Interactive presence + Ctrl-C** | Catches gross behavioral changes. Cheapest control available. | Already doing it. |

### Deferred

**Micro-VM sandboxing (Matchlock/Gondolin)** — the allowlist debugging burden is high, there's no Pi integration, and both tools are weeks old. The additional protection (credential injection, kernel isolation, ephemeral environment) is real but doesn't justify the friction yet. Revisit when tooling matures.

### Accepted Residual Risks

- **Agent's API keys are exposed.** Anthropic key, GitHub PAT live in the agent's environment. Only Matchlock/Gondolin's secret injection addresses this.
- **Project code can be exfiltrated to allowed hosts.** Unsolvable by any current tool.
- **`/tmp` leak.** World-readable temp files (vim swap, downloaded PDFs) partially undermine home dir isolation.
- **Discipline decay.** Shared workspace symlinks accumulate over time. Periodic audit required.

---

## Where This Is Going

The sandbox era is transitional. The destination: **treat agents like untrusted CI workers** with auditable, reversible access.

- **Assume failure, ensure recovery.** PITR for databases, locked branches, scoped tokens, network segmentation. Don't try to prevent every mistake — make mistakes recoverable.
- **Audit over prevention.** Log what the agent does. Review diffs before push. Separate agent commits from human commits.
- **Content-aware egress** is the missing piece. Inspecting *what* the agent sends, not just *where* it sends it — but this requires an LLM judging another LLM's output, which reintroduces the prompt injection surface. Nobody has solved this recursion.

---

## Sources

| File | Key contribution |
|------|-----------------|
| [HN: Claude Code Sandboxing](hn-claude-code-sandboxing-2026.md) | 25+ tools, approval fatigue, YOLO survivorship bias |
| [HN: Matchlock Agent Sandbox](hn-matchlock-agent-sandbox.md) | Confused deputy proof, Opus 4.6 red-teaming, exploit economics |
| [Gondolin Agent Sandbox](gondolin-agent-sandbox.md) | JS-programmable network, synthetic DNS, secret injection design |
| [Gondolin vs Matchlock](gondolin-vs-matchlock.md) | 7-attack-class security comparison |
| [HN: Claude Code Security](hn-claude-code-security.md) | Vuln scanning as agent feature, disclosure timeline breakdown |
| [Agent Security: What People Do](agent-security-landscape-what-people-do.md) | Autonomous vs interactive split, LuLu + dedicated accounts pattern |
| [Agent Isolation Friction: Self-Rebuttal](agent-isolation-friction-rebuttal.md) | Why "just run open" was wrong, tiered access model |
| [Separate macOS User](agent-separate-macos-user.md) | Setup, kernel-enforced isolation, limitations |
| [Separate User: Pre-Commitment](agent-separate-user-precommit-analysis.md) | Honest cost/benefit, discipline decay trajectory |
| [Matchlock Setup Guide](matchlock-setup-guide.md) | Real configuration burden for Pi on macOS |
| [Google Dedicated Account](agent-google-dedicated-account-setup.md) | Agent service account setup |
