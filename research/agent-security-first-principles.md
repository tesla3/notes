← [Coding Agents](../topics/coding-agents.md) · [Index](../README.md)

# Agent Security from First Principles: What the Landscape Gets Wrong

*February 19, 2026. A first-principles critique of the [securing-pi-agents-landscape](securing-pi-agents-landscape.md) analysis, the broader coding agent security model, and a proposed architecture that actually works.*

---

## The Problem With the Current Analysis

The landscape document is good — honest, self-correcting, and pragmatic. But it inherits the same conceptual error that every tool in this space makes: **it treats security as a series of walls to add around an inherently insecure architecture, instead of asking what a secure architecture would look like from scratch.**

The four-layer model (extension guards → sandbox extension → outer process sandbox → read-only mode), the NVIDIA mapping, the practical tiers — these are all "how do we make this less bad?" thinking. That's useful. But it never asks: **why is the architecture bad in the first place, and what would a correct one look like?**

Let's start over.

---

## First Principles

### Principle 1: The Tool Boundary IS the Security Boundary

In any agent system, there are exactly three trust domains:

1. **The LLM** — inherently untrustworthy (prompt-injectable, hallucination-prone, opaque reasoning)
2. **The tool executor** — performs real-world actions (filesystem, network, processes)
3. **The operator** — the human who set the thing up and bears the consequences

Security means: **the LLM can only affect the real world through the tool executor, and the tool executor enforces invariants the operator defined.** If the LLM can bypass the tool executor, or if the tool executor doesn't enforce invariants, you have no security. Everything else is theater.

**Pi's fundamental architectural flaw:** Three of its four tools (read, write, edit) execute **in-process** as direct Node.js filesystem calls. They are in the same trust domain as the agent runtime. The sandbox extension — pi's "highest-value intervention" — only wraps bash because only bash spawns a subprocess. The read/write/edit tools bypass all OS-level sandboxing because there's no process boundary to sandbox at.

This means 75% of pi's tool surface is architecturally unsandboxable. Not "hard to sandbox" — *impossible to sandbox at the OS level* without changing the architecture. The landscape document mentions this ("only sandboxes bash commands... major gap") but frames it as a limitation. It's not a limitation. **It's the architecture being fundamentally wrong for security.**

The same flaw exists in Claude Code, Codex, and every other agent that runs file operations in-process. It's an industry-wide failure to separate trust domains.

### Principle 2: Least Privilege Means Starting With Nothing

The correct security model is capability-based: the agent starts with **zero** capabilities and is explicitly granted what it needs.

Every agent in the market, including pi, does the opposite: start with full system access, then try to restrict. This is the "ambient authority" anti-pattern — the same mistake that led to decades of Unix root-as-default vulnerabilities.

The landscape document's NVIDIA mapping shows pi's defaults as ❌ across the board. But the deeper point is that **the default should be deny-all, not allow-all.** Security should not require 15 minutes of extension installation. The safe state should be the zero-configuration state.

Pi's philosophy — "no permission popups, sandbox externally" — is a correct *observation* (application-level controls are insufficient alone) weaponized into an incorrect *conclusion* (therefore we should ship no controls at all). The correct conclusion is: **ship deny-all defaults and provide escape hatches for power users who understand the risks**, which is literally the opposite of what pi does.

### Principle 3: Denylists Always Lose

The extension guards (`permission-gate.ts`, `protected-paths.ts`, `tool-override.ts`) are all denylists: block `.env`, block `~/.ssh`, block `rm -rf`. The landscape document acknowledges these are bypassable ("a bash command that runs `python -c 'import os; os.remove(...)'` bypasses the permission-gate pattern entirely").

But it's worse than that. Denylists are not just *practically* insufficient — they are *theoretically* guaranteed to fail. The set of dangerous actions is unbounded and context-dependent. Is reading `/etc/passwd` dangerous? Usually no. Is reading `/proc/self/environ` dangerous? Yes — it contains every environment variable including API keys. Is writing to `~/.bashrc` dangerous? Extremely. Is writing to `~/.config/fish/config.fish` dangerous? Equally, but a denylist protecting `.bashrc` won't catch it.

The correct approach is an **allowlist of capabilities**: "this agent can read files matching `./src/**` and `./tests/**`, write files matching `./src/**`, and execute `npm test` and `git` commands." Everything else is denied by default. Not because you thought of the specific threat, but because you didn't explicitly grant the capability.

### Principle 4: The Context Window Is an Exfiltration Channel

This is the most overlooked threat in the entire landscape document. Once data enters the LLM's context window, it has been exfiltrated — to the model provider at minimum (Anthropic sees every token in every API call), and potentially to any future output.

Consider this attack:
1. Agent reads `~/.aws/credentials` (via the unsandboxed `read` tool, or from a file that symlinks to it)
2. Credentials are now in the context window
3. Agent is prompted to "summarize what you've learned" — the summary, displayed to the user's terminal, contains encoded credentials
4. Or: the agent stores a "note" via a skill that writes to a file that gets synced somewhere
5. Or: the credentials persist in pi's session files (`~/.pi/agent/sessions/`) and are included in future context

No sandbox prevents this. The data crossed the trust boundary the moment `read` was called. The landscape analysis focuses on preventing *actions* (writes, bash commands) but ignores that **reads are the primary exfiltration vector** because they move data from the filesystem into an uncontrollable domain (the LLM's context + the API provider's servers).

Even with read restrictions, the agent legitimately reads source code — which may contain hardcoded secrets, internal URLs, architecture details. All of this goes to the API provider. If you're working on proprietary code via Anthropic's API, Anthropic's infrastructure sees your entire codebase, one file at a time.

This isn't a bug to fix — it's inherent to the architecture of cloud-based LLM agents. The only mitigations are:
- Local models (no exfiltration to provider, but current capability gap)
- Information flow tracking (know what's in context, restrict what can leave)
- Aggressive context pruning (don't let stale sensitive data persist)

The landscape document's entire security model has a blind spot here because it frames threats as "agent does bad thing to filesystem/network" and ignores "agent learns secret and the secret is now in multiple uncontrolled locations."

### Principle 5: Defense in Depth Requires Independent Failure Modes

The landscape document advocates "defense in depth" — multiple overlapping layers. But real defense in depth requires layers with **independent failure modes**. If the same bypass defeats multiple layers, you have defense in *width* (more controls at the same level), not defense in *depth* (controls at different levels that catch different things).

Pi's extension guards all share a failure mode: **the LLM constructs a tool call that looks benign but isn't.** If the model says `bash: python3 -c "..."`, the permission gate sees "python3" (allowed) while the actual behavior is arbitrary code execution. The protected-paths extension sees the tool call target but not what happens inside the subprocess. The tool-override extension checks the filename argument but not symlinks, mount points, or `/proc/self/fd/` tricks.

A bash sandbox extension with an outer nono wrapper — *that's* independent failure modes. The extension enforces per-command policy, nono enforces process-level invariants. Even if the sandbox extension has a bypass, nono catches it at the kernel level. This is genuinely layered. But as noted: 75% of tools (read/write/edit) only have extension-level controls with no independent backup layer.

### Principle 6: The Audit Trail Must Be Outside the Blast Radius

Pi has no built-in audit trail. The `auto-commit-on-exit.ts` extension commits to the project's own git repo — which the agent can also modify. Session files are in `~/.pi/agent/sessions/` — which the agent can read and (via the unsandboxed `write` tool) modify.

A meaningful audit trail must be:
- **Append-only** from the agent's perspective (the agent can add entries but not modify or delete them)
- **Outside the agent's filesystem scope** (not in the project directory or pi's config)
- **Tamper-evident** (hash chaining, external witness, or write-once storage)
- **Complete** (every tool call, every tool result, every context modification)

None of the current tools in the landscape (pi, Claude Code, nono) provide this. Nono claims "tamper-resistant JSON logs" but this is unverified. A proper audit trail would be a separate process that receives structured events over a Unix socket and writes to a location the agent process cannot access.

### Principle 7: Time is a Threat Dimension

The landscape analysis treats each session as independent. But agents have persistent state:
- Pi's session files contain full conversation history
- Extensions and skills persist across sessions
- Git repos contain history that influences future sessions
- The user's filesystem accumulates agent-written config files, scripts, crontabs

An attacker who compromises one session can plant persistent artifacts that activate in future sessions. A poisoned `.pi/agent/skills/` file. A modified `.bashrc` alias. A git hook in `.git/hooks/`. A crontab entry. The landscape document's Tier 3 mentions git checkpoints for reversibility within a session, but doesn't address cross-session persistence attacks.

The NVIDIA paper's "lifecycle management" control addresses this — but pi maps to ❌ and none of the community patterns fix it. Docker Sandboxes come closest (disposable per-workspace containers), but the session state still persists.

---

## What a Correct Architecture Would Look Like

Given the principles above, here's what a secure coding agent architecture requires. This isn't specific to pi — no current tool implements this fully. But it's what "secure" actually means.

### Architecture: Split Trust Domain Agent

```
┌─────────────────────────────────────────────────────────────┐
│  OPERATOR DOMAIN (trusted)                                  │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────────────┐ │
│  │ Config/Policy │  │ Audit Logger │  │ Capability Granter│ │
│  │ (read-only    │  │ (append-only │  │ (issues tokens    │ │
│  │  to agent)    │  │  log store)  │  │  per session)     │ │
│  └──────┬───────┘  └──────▲───────┘  └───────┬───────────┘ │
│         │                 │                   │             │
└─────────┼─────────────────┼───────────────────┼─────────────┘
          │ policy          │ events            │ tokens
          ▼                 │                   ▼
┌─────────────────────────────────────────────────────────────┐
│  AGENT DOMAIN (untrusted)                                   │
│                                                             │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  Agent Runtime                                         │ │
│  │  - Talks to LLM API via proxy (never sees raw API key) │ │
│  │  - Receives tool results, sends tool requests          │ │
│  │  - NO direct filesystem/network access                 │ │
│  └────────────────────┬───────────────────────────────────┘ │
│                       │ tool requests                       │
│                       ▼                                     │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  Tool Executor (separate process, sandboxed)           │ │
│  │  - Validates capability token for each operation       │ │
│  │  - read/write/edit/bash ALL go through this            │ │
│  │  - OS-level sandbox (Landlock/Seatbelt/seccomp)        │ │
│  │  - Logs every operation to Audit Logger                │ │
│  │  - Allowlist-only: rejects anything not granted        │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Key Design Decisions

**1. All tools execute out-of-process.**

Read, write, edit, and bash all go through the Tool Executor — a separate process with its own sandbox. The agent runtime has NO `fs` module access, NO `child_process` module access. It communicates with the Tool Executor over a Unix domain socket or similar IPC.

This is the single most important change. It makes read/write/edit sandboxable at the OS level, closing the 75% gap.

**2. Capability tokens, not denylists.**

At session start, the operator (or a policy file) issues capability tokens:

```yaml
# .pi/project-policy.yaml
session:
  read:
    allow:
      - "./src/**"
      - "./tests/**"
      - "./package.json"
      - "./tsconfig.json"
  write:
    allow:
      - "./src/**"
      - "./tests/**"
    deny:
      - "**/.env*"
      - "**/*.key"
      - "**/*.pem"
  bash:
    allow:
      - "npm test"
      - "npm run build"
      - "git *"
      - "tsc --noEmit"
    deny:
      - "curl *"
      - "wget *"
      - "nc *"
  network:
    allow:
      - "registry.npmjs.org"
      - "github.com"
```

The Tool Executor checks capabilities before every operation. Everything not explicitly allowed is denied. The capability set is logged at session start for audit purposes.

The operator can also define **escalation policies**: "if the agent requests a capability it doesn't have, ask me (one-time prompt for that specific capability, not a blanket yes/no)." This is where permission prompts actually make sense — not as a denylist filter on every command, but as an escalation mechanism for capability requests the policy didn't anticipate.

**3. API key proxy.**

The agent runtime never sees the raw API key. A separate proxy process (trivially simple — under 100 lines) holds the key, accepts requests over a local socket, adds authentication headers, and forwards to the LLM API. The agent process's environment contains only the socket path, not the key.

This means: even if the agent is fully compromised (prompt injection causes it to dump its environment), the API key doesn't leak. Even if a malicious extension runs in the agent process, it can't extract the key. The proxy is outside the agent's trust domain.

```
Agent Runtime → unix:///tmp/pi-proxy.sock → Proxy Process → api.anthropic.com
                (no API key here)          (has API key)
```

**4. Context taint tracking.**

When the Tool Executor serves a file read, it can tag the response with a sensitivity label:
- **public** — open source code, documentation
- **internal** — proprietary source code
- **secret** — anything matching `*.env*`, `*.key`, `*.pem`, credential patterns

The agent runtime tracks these labels in context. If context contains **secret**-tagged content, the Tool Executor restricts subsequent operations: no network commands, no writes to files outside the project. The LLM can still *see* the secret (necessary for some workflows), but the blast radius of that knowledge is contained.

This isn't perfect — taint tracking has known limitations (implicit flows, etc.) — but it's strictly better than the current model of "read anything, context is untracked, hope for the best."

**5. Immutable audit outside the blast radius.**

The Audit Logger is a separate process. It receives structured events (tool calls, results, capability checks, escalation decisions) over a Unix socket. It writes to a location the agent process cannot access (different user, different directory, append-only filesystem attribute).

Each event includes a hash of the previous event (hash chain). The operator can verify the chain wasn't tampered with. For serious deployments, the logger can forward events to an external SIEM or write-once storage.

**6. Ephemeral by default.**

Sessions start clean. No persistent state carries over unless explicitly imported. Session files are stored outside the agent's write scope. Skills and extensions are loaded from a read-only snapshot at session start — the agent can't modify them mid-session.

For cross-session memory, the operator explicitly promotes specific outputs (summaries, decisions, learned preferences) into a persistent store that's reviewed before import. This prevents persistent poisoning attacks.

---

## What's Achievable Today Without Architecture Changes

The full split-domain architecture would require significant changes to pi (or any agent). Here's what you can do today that's principled, not just "more walls around the same bad architecture":

### Tier 0: The One Thing That Actually Matters (5 min)

**Run pi inside a Docker container with no host network and a bind-mounted workspace.**

```bash
docker run -it --rm \
  --network=none \
  -v $(pwd):/workspace \
  -w /workspace \
  -e ANTHROPIC_API_KEY \
  --read-only \
  --tmpfs /tmp \
  --tmpfs /root/.pi \
  node:22-slim \
  bash -c "npm i -g @mariozechner/pi-coding-agent && pi"
```

Wait — `--network=none` blocks API calls. So:

```bash
# Create a network that only allows Anthropic API
docker network create --driver bridge pi-net
# Use iptables/nftables rules or a proxy container to restrict egress
```

This is harder than it should be. The fundamental tension: the agent needs network for API calls but network is the primary exfiltration channel. The proxy architecture solves this cleanly; without it, you're stuck choosing between "no network" (broken) and "full network" (insecure) or fiddling with network policies (complex).

**Pragmatic version:**

```bash
docker run -it --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  -e ANTHROPIC_API_KEY \
  --tmpfs /tmp \
  --tmpfs /root/.pi \
  node:22-slim \
  bash -c "npm i -g @mariozechner/pi-coding-agent && pi"
```

This gives you filesystem isolation (agent can't see host filesystem outside workspace) but not network isolation. It's still better than running pi bare on the host because it protects `~/.ssh`, `~/.aws`, `~/.gnupg`, and every other sensitive directory by not mounting them.

### Tier 1: API Key Proxy (30 min, massive ROI)

Build a trivial proxy that holds the API key and forwards requests:

```javascript
// pi-api-proxy.mjs — runs OUTSIDE the container
import http from 'http';
import https from 'https';

const API_KEY = process.env.ANTHROPIC_API_KEY;
const server = http.createServer((req, res) => {
  const opts = {
    hostname: 'api.anthropic.com',
    path: req.url,
    method: req.method,
    headers: { ...req.headers, 'x-api-key': API_KEY, host: 'api.anthropic.com' }
  };
  const proxy = https.request(opts, (upstream) => {
    res.writeHead(upstream.statusCode, upstream.headers);
    upstream.pipe(res);
  });
  req.pipe(proxy);
});
server.listen(9100, '127.0.0.1');
```

Run pi with `ANTHROPIC_API_BASE_URL=http://host.docker.internal:9100` (or equivalent). The container never has the API key. A compromised agent dumping its environment gets a localhost URL, not a key.

This is the highest-ROI security improvement you can make that no one in the landscape is talking about. It's trivial to build, it completely eliminates API key exfiltration from the agent process, and it works with every agent (pi, Claude Code, Codex, anything that supports a base URL override).

### Tier 2: Read Allowlist Extension (15 min)

The landscape document's `tool-override.ts` is a denylist. Flip it:

```typescript
// allowlist-read.ts — only allow reads within project directory
export default {
  name: 'allowlist-read',
  tool_call: (call) => {
    if (call.tool === 'read') {
      const target = path.resolve(call.params.path);
      const workspace = path.resolve(process.cwd());
      if (!target.startsWith(workspace)) {
        return { error: `Read blocked: ${call.params.path} is outside workspace` };
      }
      // Also block symlinks that escape
      const real = fs.realpathSync(target);
      if (!real.startsWith(workspace)) {
        return { error: `Read blocked: ${call.params.path} resolves outside workspace` };
      }
    }
    return call; // pass through
  }
};
```

This is still application-level (bypassable by bash), but it closes the read/write/edit gap that the sandbox extension misses. Combined with the sandbox extension (which restricts bash), you get coverage on all four tools — imperfect at each layer, but with different failure modes.

**Do the same for write and edit.** Allowlist, not denylist. Only project directory. Resolve symlinks.

### Tier 3: Context Hygiene (Ongoing discipline)

- Use `--tools read,grep,find,ls` for review/exploration tasks. Switch to full tools only for implementation.
- Don't let the agent read files you wouldn't paste into a web form. If you wouldn't put it in ChatGPT, don't let the agent read it.
- Periodically start fresh sessions. Long sessions accumulate sensitive context.
- Review session files (`~/.pi/agent/sessions/`) — they contain everything the agent saw. Treat them as sensitive data.

---

## Mapping This to the Landscape Document's Framework

| Landscape Layer | First-Principles Assessment |
|---|---|
| Layer 1: Extension guards | Denylists in the wrong trust domain. Replace with allowlists + symlink resolution. Catch different things than OS sandboxing, so still worth having as an inner layer. |
| Layer 2: Sandbox extension | Good for bash, architecturally unable to cover read/write/edit. Necessary but insufficient. |
| Layer 3: Outer sandbox | The only layer that actually works for all tools — but only if ALL tools go through a sandboxed process boundary. Currently only bash does. Container isolation is the pragmatic answer. |
| Layer 4: Read-only mode | Correct principle (least privilege). Should be the default, not an opt-in flag. |
| NVIDIA controls | The mapping table should add a column for "what an architecture change would give you" — most ❌ become ✅ with the split-domain model. |

---

## The Honest Assessment of Pi Specifically

**What the landscape document gets right:**
- Permission prompts are not theater — they catch real mistakes
- VM/container isolation is the endgame
- Pi's extension API is a genuine advantage for custom security
- The sandbox extension's bash-only coverage is a serious gap
- Pi's defaults are irresponsible

**What the landscape document undersells:**
- The read tool is more dangerous than bash. Bash exfiltration can be blocked by network sandboxing. Read exfiltration happens by default to the API provider with every API call. No sandbox fixes this because the agent *needs* to read files to function.
- Session persistence is a cross-session attack vector that no tier addresses.
- The API key is exposed to the agent process in every deployment pattern described. The proxy pattern eliminates this entirely and is trivially buildable today.
- Symlink/procfs attacks bypass every application-level file check. An allowlist that doesn't resolve symlinks is barely better than a denylist.

**What the landscape document overcomplicates:**
- The nono analysis. Nono is pre-alpha, unverified, and adds a dependency with unclear maintenance prospects. A Docker container gives you equivalent filesystem isolation today, with a battle-tested tool, and is easier to reason about. Nono's value proposition is the integrated experience (audit, rollback, secrets) — but those features are either unshipped or unverified.
- The four-tier setup. Most of the security value is in two things: (1) container isolation, (2) API key proxy. Everything else is marginal. Don't let the complexity of a four-tier plan prevent you from doing the two things that matter.

---

## Summary: Three Things That Actually Matter

1. **Process isolation for ALL tools.** Today: Docker container. Tomorrow: split-domain architecture where read/write/edit are out-of-process. This is the only way to get OS-level enforcement on the full tool surface.

2. **API key proxy.** Eliminates the entire class of "agent leaks API key" attacks. Trivial to build. Nobody is doing it. It should be standard practice for every cloud-based agent.

3. **Allowlists, not denylists.** For file access, for bash commands, for network egress. The default is deny. Capabilities are explicitly granted. This is a mindset change more than a technical one, but the practical implementations (allowlist extensions, Docker bind mounts, network policies) follow directly.

Everything else — nono integration, Seatbelt nesting, Kubernetes pods, audit trails, taint tracking — is either speculative, marginal, or a nice-to-have built on top of these three foundations. Get the foundations right first.

---

## Self-Assessment

**What's strong:** The identification of pi's in-process tool execution as the fundamental architectural flaw. The API key proxy pattern as an overlooked high-ROI intervention. The allowlist vs. denylist argument as theoretically grounded, not just "more is better." The context-as-exfiltration-channel observation.

**What's speculative:** The full split-domain architecture is a design, not a tested implementation. Capability tokens and taint tracking add complexity that may not be worth it for individual developers. The Docker network isolation setup is non-trivial in practice.

**What I might be wrong about:** The "read is more dangerous than bash" claim depends on your threat model. If your primary concern is filesystem destruction (not exfiltration), bash is clearly more dangerous. If your primary concern is IP/credential theft, read is more dangerous. The claim is context-dependent, not universal. Also: the proxy pattern assumes pi supports `ANTHROPIC_API_BASE_URL` or equivalent — this needs verification.

---

*This document is a critique of the current landscape analysis and a proposal for principled alternatives. It should be read alongside [securing-pi-agents-landscape.md](securing-pi-agents-landscape.md), not as a replacement.*
