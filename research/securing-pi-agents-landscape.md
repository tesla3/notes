← [Coding Agents](../topics/coding-agents.md) · [Index](../README.md)

# Securing Pi Agents: Landscape & Patterns (Feb 2026)

*How people are actually securing agents built with pi-mono. Companion to [Pi + Nono](pi-plus-nono-best-of-both.md) (specific tool integration) and [Pi-Mono vs Rust](research-pi-mono-rust.md) (language-level security argument).*

---

## The Core Problem Pi Exposes (But Doesn't Solve)

Pi's philosophy is: **"No permission popups. Run in a container, or build your own confirmation flow with extensions inline with your environment and security requirements."**

NVIDIA's AI Red Team (Feb 2026) lends real support to the underlying argument: application-level controls are insufficient *alone*. Once control passes to a subprocess, the application has no visibility. Attackers use indirection — calling a restricted tool through a permitted one — to bypass allowlists. OS-level controls are the only controls that cover every process in the sandbox.

But the NVIDIA paper also lists **per-instance user approval as a recommended control** — the very thing pi dismisses as theater. Their framing: approval prompts are insufficient as a sole defense but useful as one layer. Claude Code's permission prompts catch obvious catastrophic mistakes (accidental `rm -rf /`, writes to system directories) even though they're trivially bypassed by sophisticated attacks or user habituation. That's not worthless — it's a real safety floor for the 90% of users who never configure external sandboxing.

The OWASP Top 10 for Agentic Applications (2026 edition) identified the same hierarchy: prompt injection (ASI01), tool misuse (ASI02), privilege abuse (ASI03), supply chain (ASI04), and unexpected RCE (ASI05) are the top five. None are *fully* solved by permission dialogs, but defense-in-depth means layers with overlapping coverage.

**The honest verdict:** Pi is right that permission popups alone are insufficient against targeted attacks. But pi's actual default — full system access with zero guardrails — is strictly worse than Claude Code's default of "annoying prompts that catch obvious mistakes." The gap between pi's philosophy and pi's defaults is where the real work happens, and most users never do that work.

---

## Four Layers People Actually Use

Based on pi-mono's shipped examples, a handful of Reddit/Discord discussions, and general industry patterns, there are roughly four layers people *can* use, composable in any combination. **Important caveat: I have no adoption data.** Pi's community is small and I found no usage surveys or telemetry. What follows is "what's available" not "what's widely adopted."

### Layer 1: Pi Extension-Level Guards (Application Layer)

**What exists today — shipped as example extensions in pi-mono:**

| Extension | What It Does | Threat Covered |
|-----------|-------------|----------------|
| `permission-gate.ts` | Confirms before `rm -rf`, `sudo`, `chmod 777` | Accidental destruction |
| `protected-paths.ts` | Blocks write/edit to `.env`, `.git/`, `node_modules/` | Secret leakage, dependency tampering |
| `tool-override.ts` | Replaces built-in `read` with audited version; blocks `.env`, `*.pem`, `~/.ssh`, `~/.aws` | Credential exfiltration |
| `dirty-repo-guard.ts` | Warns on uncommitted changes before session switch/fork | Losing unsaved work |
| `git-checkpoint.ts` | Git stash checkpoint per turn; restore on fork | Reversibility |
| `auto-commit-on-exit.ts` | Commits on shutdown | Audit trail |

**What people build themselves** (from Reddit/Discord patterns):

- **Allowlist-only write:** extension that blocks writes to any path outside a configured project directory
- **Command audit log:** `tool_call` handler that logs every bash command to a timestamped file
- **Cost gates:** block model calls if session cost exceeds threshold
- **Network command blocklist:** block `curl`, `wget`, `nc`, `ssh` in bash unless user confirms

**Honest assessment:** These are the seatbelt, not the airbag. They intercept the *tool call* before execution, so they catch the LLM saying "I want to run `rm -rf /`" but **cannot catch** what happens inside a subprocess. A bash command that runs `python -c "import os; os.remove('/important')"` bypasses the `permission-gate.ts` pattern entirely. The LLM can also be prompt-injected into crafting commands that look benign but aren't.

Note: these are the same application-level controls that pi's philosophy dismisses as insufficient when Claude Code does them. The difference is that Claude Code ships them by default, while pi ships them as examples you have to manually install. The security value is identical — both are bypassable by subprocess indirection, both catch obvious mistakes. The ergonomics differ.

**When to use:** Always, as defense-in-depth. Never as your only layer.

### Layer 2: Pi's Sandbox Extension (OS-Level Per-Command)

The `sandbox/` example extension uses Anthropic's `@anthropic-ai/sandbox-runtime` to wrap **only the bash tool** in OS-level sandboxing:

- **macOS:** Seatbelt (sandbox-exec profiles)
- **Linux:** bubblewrap (namespace-based)
- **Configurable per-project** via `.pi/sandbox.json`
- Network whitelist (npm, GitHub, PyPI by default)
- Filesystem: deny read `~/.ssh`, `~/.aws`, `~/.gnupg`; allow write only CWD + `/tmp`; deny write `.env`, `*.pem`, `*.key`
- Child processes inherit restrictions — no escape via subprocess spawning

**This is the highest-value single intervention within pi's ecosystem.** It turns pi's bash tool from "trust the model" to "verify at the kernel level." But the coverage gap is significant — see limitations.

**Limitations — these are serious, not footnotes:**
- **Only sandboxes bash commands.** The read/write/edit tools are in-process Node.js calls, not subprocesses. The sandbox extension does nothing for them. Reading `~/.ssh/id_rsa` via pi's `read` tool? Unsandboxed. Writing to `~/.bashrc` via pi's `write` tool? Unsandboxed. This is a major gap: the LLM can exfiltrate secrets or modify system config without ever touching bash.
- Pi itself still runs unsandboxed (needs network for API calls, filesystem for sessions/config)
- Extensions run in pi's process — a malicious extension bypasses everything
- macOS Seatbelt nesting (if combining with an outer sandbox like nono) is undocumented
- **Unverified in practice.** This is example code in pi-mono, not a maintained security product. I haven't tested it, I haven't found reports of others testing it on current macOS/Linux, and `@anthropic-ai/sandbox-runtime`'s own maintenance posture is unclear. Treat as promising but unvalidated.

### Layer 3: Outer Process Sandbox (Whole-Agent Isolation)

Wrapping the entire pi process in a sandbox. Three approaches people use:

**a) Docker Sandboxes (Docker Desktop 4.50+)**

Docker Sandboxes are purpose-built for coding agents. Each runs in a **microVM** with:
- Project workspace mounted at the same absolute path
- Git credentials injected
- Docker-in-Docker support (agents can build containers)
- Network isolation with allow/deny lists
- One sandbox per workspace (state persists across sessions)
- Disposable — delete and recreate instantly

Docker explicitly targets Claude Code, Gemini CLI, Codex, and Kiro. **Pi isn't listed as a supported agent yet**, but since pi is just a Node.js CLI, it should work inside a Docker Sandbox with a custom template. Nobody has published a pi-specific Docker Sandbox template as of Feb 19, 2026.

**b) Nono (kernel-level wrapper)**

See [Pi + Nono: Best of Both](pi-plus-nono-best-of-both.md) for the detailed analysis. TL;DR: promising but pre-1.0 alpha, delete protection may break dev workflows, Seatbelt nesting on macOS unverified. No pi profile yet.

**c) Plain Docker / Podman containers**

The "just containerize it" approach. People run:
```bash
docker run -it --rm \
  -v $(pwd):/workspace \
  -e ANTHROPIC_API_KEY \
  --network=host \
  node:22 \
  npx @mariozechner/pi-coding-agent
```

This gives you filesystem isolation but `--network=host` defeats network isolation. For real isolation you'd need to configure network policies, which most people don't bother with.

**d) Kubernetes (Axon controller)**

Axon (from a Reddit post this week) is a Kubernetes controller that treats agent tasks as ephemeral, sandboxed pods. Each task gets its own pod with resource limits, network policies, and automatic cleanup. Overkill for individual developers but relevant for teams running agents at scale.

**e) Dedicated VMs / Cloud Dev Environments**

Some people (the Reddit "SentryForge" thread, several r/ClaudeCode commenters) just spin up a VM per project. GitHub Codespaces, Gitpod, or a plain EC2 instance. Crude but effective — full isolation with no tooling complexity. The downside is cost and setup friction.

### Layer 4: Read-Only / Tool-Restricted Mode

Pi supports `--tools read,grep,find,ls` to run in read-only mode. No bash, no write, no edit. This is useful for:
- Code review
- Codebase Q&A
- Audit tasks

Combined with `-p` (print mode), this gives you a genuinely safe "ask questions about my code" workflow with zero destructive capability.

Some people use `pi.setActiveTools()` in extensions to dynamically restrict tools — e.g., read-only during a "review phase" then full access during an "implement phase" of a plan-mode extension.

---

## The NVIDIA Red Team's Mandatory Controls (Feb 2026)

NVIDIA published the most authoritative security guidance for coding agents to date. Their **mandatory** controls:

1. **Network egress controls** — block access to arbitrary sites (prevents exfiltration, reverse shells)
2. **Block file writes outside workspace** — prevents persistence mechanisms, sandbox escapes, RCE
3. **Block writes to configuration files everywhere** — prevents exploitation of hooks, skills, MCP configs that run outside sandbox context

Their **recommended** controls:

4. Prevent reads outside workspace
5. Sandbox the entire IDE and all spawned processes (hooks, MCP, skills, tools) — run as own user
6. **Use virtualization** (microVM, Kata container, full VM) to isolate sandbox kernel from host kernel
7. Require per-instance user approval for actions violating isolation controls (not allow-once/run-many)
8. **Secret injection** — prevent secrets in env vars from being shared with agent
9. Lifecycle management — prevent accumulation of code, IP, or secrets in the sandbox

**How pi maps to this — honest version with two columns for default vs. configured:**

| NVIDIA Control | Pi Default | Pi + Sandbox Extension + Guards |
|---------------|-----------|------|
| Network egress | ❌ Unrestricted | ⚠️ Bash only — whitelist via sandbox ext. Read/write/edit tools unaffected. |
| Write outside workspace | ❌ Unrestricted | ⚠️ Bash only — restricted to CWD + /tmp. Pi's `write` tool still writes anywhere. |
| Config file writes | ❌ Unrestricted | ⚠️ `protected-paths.ts` blocks `.env` via write/edit tools. Bash writes blocked by sandbox ext. Not comprehensive. |
| Read outside workspace | ❌ Unrestricted | ⚠️ Sandbox ext blocks bash reads of `~/.ssh` etc. Pi's `read` tool blocked by `tool-override.ts` if installed. Neither enforces strict workspace-only. |
| Sandbox everything | ❌ | ❌ Extensions, skills, hooks run in pi's unsandboxed process |
| Virtualization | ❌ | ❌ Requires external layer (Docker Sandboxes, VM, nono) |
| Per-instance approval | ❌ | ⚠️ `permission-gate.ts` for bash; nothing for read/write/edit |
| Secret injection | ❌ | ❌ Requires external layer (nono keystore, Docker secrets) |
| Lifecycle management | ❌ | ❌ No built-in session/sandbox cleanup |

**The uncomfortable truth:** Pi's defaults are ❌ across the board — every NVIDIA mandatory control is unmet out of the box. With the sandbox extension plus guard extensions installed, you get partial coverage for bash commands but the read/write/edit tools remain a gap. Full NVIDIA compliance requires an external isolation layer (Docker Sandboxes, VMs, etc.) regardless of what pi extensions you install.

---

## The Supply Chain Problem (Unique to Pi)

Pi packages are npm or git repos that can contain **extensions** (arbitrary TypeScript running in pi's process) and **skills** (markdown that instructs the LLM to take actions). Pi's own README warns:

> "Pi packages run with full system access. Extensions execute arbitrary code, and skills can instruct the model to perform any action including running executables. Review source code before installing third-party packages."

OpenClaw's community reportedly found a significant rate of malicious or unsafe community skills (the ~15% figure cited in this repo's earlier analysis — I haven't independently verified the methodology or sample size, so treat this as directional, not precise). This is the "agentic supply chain" risk (OWASP ASI04). Mitigations available in pi:

- **Pin package versions:** `pi install npm:@foo/bar@1.2.3` — prevents silent updates
- **Review source before install** — pi packages are small enough to audit (unlike npm dependency trees)
- **Project-local installs:** `pi install -l` keeps packages scoped to the project, not global
- **`pi config`** — enable/disable individual extensions, skills, prompts, themes from packages
- **`--no-extensions --no-skills`** — nuclear option, disable all discovery

The Reddit r/ClaudeCode thread on pi had a telling comment: *"It only supports yolo mode, which is honestly fine but if you want security just use linux and useradd claude and use that so it can't access your own home directory."* The principle is sound — Unix user isolation is battle-tested. But "costs nothing" is misleading: configuring a separate user with the right permissions for npm globals, node_modules, project directory access, and API key forwarding is non-trivial setup work.

---

## What the Community Seems to Do (Low-Confidence Inferences)

**Evidence quality disclaimer:** Pi's community is small. I found ~5 relevant Reddit comments, a few Discord references, and the DeepWiki summary. There's no usage telemetry, no survey data, no package download counts for extensions. Everything below is inference from a tiny sample, not observed population behavior.

**Probable majority:** Nothing. Run pi with full access, trust the model. This inference comes from: (a) it's the default, (b) there's no documentation pushing users toward security setup, (c) general developer behavior with all coding agents skews toward convenience. This is also true for Claude Code users who habituate to clicking "Yes" on every prompt — at least they have a prompt to habituate to.

**Plausible minority:** Pi's sandbox extension installed globally. It's the easiest win and the most obvious security extension. But I have zero evidence of actual adoption numbers.

**Mentioned in discussions but unquantifiable:**
- Sandbox extension + git checkpoint + protected paths (the "defense in depth" stack within pi's ecosystem)
- Docker container with workspace mount
- Dedicated Linux user with restricted home directory
- pi-mom (Slack bot) with Docker sandboxing per channel — shipped in pi-mono itself
- SDK integration (like OpenClaw) with custom isolation layers
- Kubernetes pods per agent task (the Axon Reddit post — one person's project)

**Not observed anywhere:**
- Docker Sandboxes with a pi template
- Nono + pi in production (too new)
- microVM isolation (Firecracker/E2B) for pi specifically

---

## The Prompt Injection Reality

Neither sandboxing nor permission gates prevent the LLM from *wanting* to do something bad. They make the consequences survivable. The threat model for coding agents:

1. Malicious content in a file the agent reads (most common vector)
2. Poisoned git history / PR content
3. Malicious AGENTS.md / CLAUDE.md files in cloned repos
4. Compromised MCP responses (pi doesn't use MCP by default, but skills can instruct similar actions)

**Pi's architecture has minor structural advantages here:** The 4-tool constraint means fewer dangerous capabilities than agents with 20+ tools. No MCP by default means no MCP poisoning vector. These are real but modest benefits.

**Overclaimed in the original draft:** I initially wrote that pi's minimal system prompt (~1,000 tokens) means "less surface area for the LLM to get confused." That's a stretch. Prompt injection via retrieved file content doesn't depend on system prompt size — it depends on the model's ability to distinguish instructions from data, which is a model property, not an agent architecture property. Claude Opus 4.6 is equally vulnerable to file-based injection whether run via pi or Claude Code.

**The `context` event hook:** Pi's extension API lets you filter/modify messages before each LLM call. In theory, an extension could scan for prompt injection patterns. In practice, reliable prompt injection detection is an unsolved research problem — known patterns are trivially evaded with rephrasing, encoding, or language switching. This hook exists but shouldn't be presented as a meaningful mitigation until someone demonstrates it actually works.

---

## Practical Tiers (What to Actually Do)

**Tier 0 — Minimum viable security (5 minutes):**
```bash
# Install sandbox extension globally
cp -r $(npm root -g)/@mariozechner/pi-coding-agent/examples/extensions/sandbox ~/.pi/agent/extensions/
cd ~/.pi/agent/extensions/sandbox && npm install
```
This sandboxes bash commands at the OS level — network whitelist, filesystem restrictions. **But only bash.** The read/write/edit tools remain unsandboxed. An LLM instructed to `read ~/.ssh/id_rsa` and then exfiltrate it via a subsequent bash command would be caught at the bash step, but could still read the file content into context. Still, it's the highest-ROI single step.

**Tier 1 — Sensible defaults (15 minutes):**
Add `permission-gate.ts`, `protected-paths.ts`, and `tool-override.ts` to `~/.pi/agent/extensions/`. These add application-level guards on read/write/edit — blocking `.env` writes, auditing reads, confirming dangerous bash commands. Same quality of protection as Claude Code's built-in permissions (bypassable by subprocess indirection, but catches obvious mistakes).

**Tier 2 — Serious isolation (30 minutes):**
Run pi inside a Docker container or dedicated Linux user. Mount only the project directory. Forward only the API key env var.

**Tier 3 — Defense in depth (1 hour):**
All of the above plus: git checkpoint extension, audit log extension, read-only tool mode for review tasks, pinned package versions, `--no-extensions` when working on untrusted repos.

**Tier 4 — Enterprise (ongoing):**
Kubernetes pods per agent, network policies, secret injection via vault, audit trail to SIEM, lifecycle management. Use the SDK to embed pi with custom isolation.

---

## Key Insight

The industry is converging on **VM-level isolation as the correct security primitive for coding agents.** Docker Sandboxes, Firecracker, nono, Kata containers — they all point the same direction. Application-level controls alone are insufficient against sophisticated attacks.

But "insufficient alone" ≠ "worthless." This is where I have to self-correct from the original draft's framing. Pi's dismissal of permission prompts as "theater" is intellectually clean but practically irresponsible when the alternative — external sandboxing — has real setup cost. Claude Code users who click through permission prompts are still better protected than pi users running with zero guardrails. A leaky umbrella beats no umbrella.

**Pi's actual advantage** is not that it "doesn't bake in security" — that's just the absence of a feature, which any tool achieves by not building it. The real advantage is the extension API: `tool_call` interception, `tool_result` modification, tool overrides, `context` filtering, custom bash operations. These hooks let you build security that fits your specific threat model rather than accepting a one-size-fits-all permission dialog. But this advantage only materializes for the small percentage of users who actually build or install extensions.

**Pi's actual disadvantage** is that the extension examples are buried in `examples/extensions/` and treated as demos, not as recommended security baseline. There's no "first run" security setup wizard, no warning when running without any security extensions, no documentation page titled "Securing Your Pi Installation." The philosophy is sound; the onboarding is negligent.

**For every tool, including pi:** external VM/container isolation is the endgame. The question is what happens for the majority of users who never get there. Claude Code gives them permission prompts. Pi gives them nothing.

---

## Self-Assessment of This Document

**What's solid:** The four-layer taxonomy, the NVIDIA/OWASP mapping (corrected version), the read/write/edit gap analysis, the supply chain section, the practical tier structure.

**What's weak:** Community adoption claims rest on ~5 Reddit comments and inference. The sandbox extension has not been tested by me or (as far as I can tell) publicly validated by others. The "what people build themselves" patterns in Layer 1 are inferred from general agent security discussions, not pi-specific evidence.

**What changed in review:** The original draft was too favorable to pi. It framed permission prompts as pure theater (they're not — they catch obvious mistakes), overclaimed the sandbox extension's coverage (bash only, not read/write/edit), presented guesses about community behavior as facts, and cheerled pi's "architecture" for a property (external sandboxability) that every tool has by default. The NVIDIA mapping table now honestly shows pi's defaults are ❌ across the board.

---

*Sources: NVIDIA AI Red Team blog (Feb 2026), OWASP Top 10 for Agentic Applications (2026), Docker Sandboxes documentation, pi-mono extension examples, r/ClaudeCode and r/LocalLLaMA discussions, Blaxel/vietanh.dev sandbox guide, dev.to Docker Sandboxes tutorial, Kaspersky OWASP analysis.*
