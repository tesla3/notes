← [Coding Agents](../topics/coding-agents.md) · [Index](../README.md)

# Agent Security: Synthesis

**Date:** 2026-07-21
**Distilled from:** 10 research files, ~45K words. [Sources](#sources) at bottom.

---

## The Core Problem

**Prompt injection is unsolved. Everything else is damage mitigation.**

A prompt-injected agent and a correctly-functioning agent produce identical system calls, network traffic, and log entries. There is no observable boundary between "agent working" and "agent compromised." This makes detection — during or after the fact — structurally impossible with current techniques.

The confused deputy is the specific mechanism: a compromised agent exfiltrates through the same API calls that are its legitimate function. The Claude Cowork attack proved this — `curl api.anthropic.com` with the attacker's API key uploads victim files through a "trusted" channel. No sandbox, allowlist, or network policy can distinguish this from normal operation.

**Implication:** Every sandbox product is prompt-injection damage mitigation, not security. The honest ceiling: sandboxing blocks lazy attacks (credential theft, unauthorized destinations, accidental `rm -rf`). It cannot block exfiltration through authorized channels.

---

## The Impossibility Theorem

No isolation boundary preserves full agent capability while providing meaningful security. Useful agents need access to exactly the things that are dangerous: package managers, Docker, databases, network, git. Every sandbox either restricts these (making the agent less useful) or permits them (making the sandbox porous).

---

## What Actually Goes Wrong

| Threat | Frequency | Impact | Sandboxing helps? |
|--------|-----------|--------|-------------------|
| Accidental `rm -rf`, bad git ops | Common | Low-medium (git recovers most) | ✅ Yes |
| Agent reads personal files (SSH keys, Keychain, browser data) | Requires prompt injection | Catastrophic, irreversible | ✅ Yes |
| Credential exfiltration to unauthorized host | Requires prompt injection | High | ✅ Yes |
| Credential exfiltration to *authorized* host | Requires prompt injection | High | ❌ No |
| Data exfiltration through allowed APIs | Requires prompt injection | High | ❌ No |
| Agent wipes remote DB via MCP/tokens | Uncommon but documented | High | ❌ Not if tokens are present |
| VM/sandbox escape via LLM-generated exploit | Theoretical today, plausible soon | Critical | Partially — defense-in-depth helps |

**The approval fatigue failure mode** is as dangerous as any technical attack. Permission prompts train users to click through without reading — the UAC problem. This is why `--dangerously-skip-permissions` exists and why everyone uses it.

---

## The Solution Landscape (Jul 2026)

**25+ tools, no convergence.** The tradeoff matrix (isolation depth × DX friction × Docker-in-Docker support × cost × latency) has too many dimensions.

### Tiers by Isolation Strength

| Tier | Examples | Protects | Doesn't protect | Friction |
|------|----------|----------|-----------------|----------|
| **Nothing** | YOLO bare metal | — | Everything | Zero |
| **Separate OS user** | `useradd`, dedicated macOS account | Personal files (kernel-enforced) | Network, credentials, kernel | Low (~1hr setup) |
| **OS sandbox** | bubblewrap, Seatbelt, Landlock | Filesystem, partial network | Shared kernel, authorized-channel exfil | Low-medium |
| **Container** | Docker, devcontainer, Podman | Filesystem, process | Shared kernel, DinD problem | Medium |
| **Micro-VM** | Matchlock, Gondolin, Firecracker, Docker MicroVMs (coming) | Filesystem, network, kernel | Authorized-channel exfil, mounted dirs | High |
| **Dedicated hardware** | Mac Mini, mini-PC, VPS, PXE-boot | Physical air gap | Credentials given to agent | Medium ($$) |

### Matchlock vs Gondolin (the two serious local VM tools)

Matchlock wins on **foundation**: Firecracker VM (~50K LOC Rust) + seccomp-BPF + capability drops, empirically red-teamed with Opus 4.6. Gondolin wins on **policy sophistication**: JS-programmable network stack, synthetic DNS (blocks DNS tunneling), symlink-aware VFS, MemoryProvider. Neither is mature. The ideal tool combines both; it doesn't exist.

### Claude Code's Built-in Sandbox

Broken. Self-escape hatch the agent can trigger. Full read access to filesystem by default. Multiple open issues showing permission bypass. `TZubiri`: "Don't depend on the thing to protect you from the thing."

---

## The Exploit Curve

Sean Heelan demonstrated Opus 4.5 and GPT-5.2 generating 40+ working exploits for a zero-day vulnerability — bypassing ASLR, CFI, shadow stacks, seccomp — at $30-50 per exploit chain. Agents don't skip the "unlikely" approaches; they try everything systematically. Static sandbox defenses face an attacker that improves every model generation. Today's micro-VM boundary holds; tomorrow's is a bet, not a guarantee.

---

## Personal Posture (This Machine)

**Context:** Interactive coding agent (Pi) on personal Mac, personal data on machine.

**Adopted:**
1. **Dedicated macOS user** — kernel-enforced home dir isolation. The 80/20 play: 1hr setup, protects SSH keys/Keychain/browser data/photos, zero maintenance. ([Setup](agent-separate-macos-user.md))
2. **LuLu outbound firewall** — catches exfiltration to unauthorized hosts in real-time. Free. ([Landscape](agent-security-landscape-what-people-do.md))
3. **Dedicated agent Google account** — agent never touches personal email/calendar. ([Setup](agent-google-dedicated-account-setup.md))
4. **Fine-grained GitHub PATs** — scoped to specific repos, minimum permissions.
5. **Interactive presence** — genuine security control for supervised use. Not sufficient alone, but meaningfully different from unattended agents.

**Deferred:**
- **Matchlock/Gondolin** — friction too high (allowlist debugging, terminal-in-VM, no Pi integration). Revisit when tooling matures. ([Assessment](matchlock-setup-guide.md))

**Accepted residual risks:**
- Agent's own API keys are exposed (Anthropic, GitHub PAT). Only secret injection (Matchlock/Gondolin) addresses this.
- Network exfiltration of project code to allowed hosts. Unsolvable by any current tool.
- `/tmp` leak — world-readable temp files partially undermine home dir isolation.
- Discipline decay on shared workspace symlinks. Mitigated by periodic audit.

---

## The Actual Destination

The sandbox era is transitional. The destination is **treating AI agents like untrusted-but-authenticated CI workers** with:
- Infrastructure-level controls (PITR, locked branches, scoped tokens, network segmentation)
- Assumption that mistakes *will* happen, making them recoverable rather than preventable
- Auditable, reversible access to real systems
- Content-aware egress policies (when someone figures out how to build them without recursing into another LLM)

---

## Sources

- [HN: Claude Code Sandboxing](hn-claude-code-sandboxing-2026.md) — popular-level survey, 25+ tools, approval fatigue
- [HN: Matchlock Agent Sandbox](hn-matchlock-agent-sandbox.md) — confused deputy, Opus 4.6 red-teaming, exploit generation
- [Gondolin Agent Sandbox](gondolin-agent-sandbox.md) — Armin Ronacher's QEMU micro-VM, JS-programmable network
- [Gondolin vs Matchlock](gondolin-vs-matchlock.md) — 7-attack-class comparison
- [HN: Claude Code Security](hn-claude-code-security.md) — vuln scanning as coding-agent feature, disclosure timeline
- [Agent Security: What People Do](agent-security-landscape-what-people-do.md) — World 1 (autonomous) vs World 2 (interactive)
- [Agent Isolation Friction: Self-Rebuttal](agent-isolation-friction-rebuttal.md) — why "just run open" was wrong
- [Separate macOS User](agent-separate-macos-user.md) — setup, threat model, limitations
- [Separate User: Pre-Commitment](agent-separate-user-precommit-analysis.md) — honest cost/benefit, discipline decay
- [Matchlock Setup Guide](matchlock-setup-guide.md) — practical burden for Pi on macOS
- [Google Dedicated Account Setup](agent-google-dedicated-account-setup.md) — agent service accounts
