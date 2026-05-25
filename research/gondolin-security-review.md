← [Coding Agents](../topics/coding-agents.md) · [Index](../README.md)

# Gondolin: First-Principles Security Review

*February 19, 2026. Reviewing [earendil-works/gondolin](../../gondolin/) against the security principles identified in [agent-security-first-principles.md](agent-security-first-principles.md).*

---

## What Gondolin Is

Gondolin is a local micro-VM sandbox for AI coding agents. QEMU-backed Linux VMs boot in under a second. The key architectural decision: **the host implements a userspace network stack and a programmable VFS in JavaScript, so all I/O from the guest is mediated by host-controlled code.** The guest is treated as adversarial.

It ships as a TypeScript SDK + CLI, with a Zig-based guest runtime (sandboxd, sandboxfs, sandboxssh). There's already a [pi extension](../../gondolin/host/examples/pi-gondolin.ts) that overrides all four of pi's tools (read, write, edit, bash) to execute inside the VM.

---

## Review Against the Seven Principles

### Principle 1: The Tool Boundary IS the Security Boundary

**Verdict: Gondolin gets this fundamentally right. This is the most important thing.**

The pi extension (`pi-gondolin.ts`) overrides **all four tools** — read, write, edit, and bash — to execute inside the VM. This is exactly what I argued was missing from every other solution: process isolation for the entire tool surface, not just bash.

```
Pi process (host, trusted)
  └── VM.create() → QEMU micro-VM (guest, untrusted)
       ├── read  → vm.exec(["/bin/cat", guestPath])
       ├── write → vm.exec(["/bin/sh", "-lc", "base64 -d > path"])
       ├── edit  → read + write through VM
       └── bash  → vm.exec(["/bin/bash", "-lc", command])
```

The agent runtime (pi itself) stays on the host. Tool execution happens inside the VM. These are in different trust domains with a hardware boundary (QEMU) between them. This closes the 75% gap I identified — read/write/edit are no longer in-process Node.js `fs` calls.

**One subtlety worth noting:** the pi extension maps paths using `toGuestPath()` which rejects paths that escape the workspace (`rel.startsWith("..") || path.isAbsolute(rel)`). This is a host-side check *before* the VM is even involved. Good defense in depth — but the VM's VFS would also enforce this since only `/workspace` is mounted.

### Principle 2: Least Privilege by Default

**Verdict: Correct architecture, but defaults need scrutiny.**

The guest VM starts with essentially nothing:
- No host filesystem access (except explicitly mounted VFS paths)
- No raw network access (only HTTP/TLS to allowed hosts)
- No host secrets (only random placeholders)
- No access to host services (localhost/metadata blocked by default)

This is the capability-based model done right: **deny everything, then grant specific capabilities.** The `VM.create()` call is where you declare what the guest can do, and everything else is denied by hardware isolation.

However, the **pi extension example** (`pi-gondolin.ts`) mounts the workspace as `RealFSProvider(localCwd)` with **read-write access and no ShadowProvider.** This means:
- `.env` files are readable from the guest
- `~/.ssh` isn't accessible (good — it's not mounted), but any secrets in the project directory are
- The guest can write anywhere in the project tree, including `.git/hooks/`

For a "getting started" example this is reasonable — you need to be able to read and write code. But a production-hardened version should layer `ShadowProvider` to hide `.env`, `.npmrc`, and other secret files, exactly as shown in the VFS documentation. The primitives exist; the example just doesn't use them yet.

**Comparison to the status quo:** Pi bare = full system access. Pi + sandbox extension = bash sandboxed, read/write/edit unsandboxed. Pi + Gondolin = everything sandboxed with explicit mounts. This is a categorical improvement.

### Principle 3: Denylists Always Lose

**Verdict: Gondolin uses allowlists throughout. Correct.**

- **Network:** allowlist of hostnames. Everything not listed is denied. No denylist of "bad" hosts.
- **Filesystem:** allowlist of mounts. Everything not mounted is invisible. No denylist of "sensitive" paths.
- **Protocols:** allowlist of HTTP/TLS (and optionally SSH). Raw TCP, UDP (except DNS), ICMP — all denied. Not a denylist of "dangerous protocols."
- **DNS:** synthetic mode (default) generates fake responses with no upstream resolver. This eliminates DNS tunneling by not having a DNS channel to tunnel through — an allowlist approach to DNS.

The `ShadowProvider` is technically a denylist (hide `.env`), but it operates *within* an already-allowlisted mount. The outer boundary is still allowlist-only. This is the correct composition: allowlist at the perimeter, optional denylist for refinement within.

### Principle 4: The Context Window Is an Exfiltration Channel

**Verdict: Gondolin significantly reduces — but doesn't eliminate — this threat.**

My original analysis identified this as the most overlooked risk: once data enters the LLM's context, it's exfiltrated to the API provider (Anthropic) and potentially encodable in future outputs.

Gondolin helps in two ways:

1. **Filesystem confinement prevents reading things you didn't mount.** `~/.ssh`, `~/.aws`, `~/.gnupg` simply don't exist in the VM. The agent can't `read ~/.ssh/id_rsa` because there's no such file. This is a hard guarantee (QEMU boundary), not an application-level check.

2. **Network confinement prevents the agent from sending context to unauthorized destinations.** Even if a secret enters context (from a `.env` file in the project), the agent can't `curl evil.com` to exfiltrate it — only allowlisted hosts are reachable, and only via HTTP/TLS that the host can inspect.

What it **doesn't** prevent:
- Secrets in the mounted project directory still enter context if the agent reads them. The fix: use `ShadowProvider` to hide `.env` etc.
- Data is still sent to the LLM API provider with every API call. Gondolin can't help here because pi's LLM communication happens on the host, outside the VM. This is inherent to cloud-based LLM agents.
- Exfiltration to *allowed* hosts. If `api.github.com` is allowlisted, the agent could encode secrets into a GitHub API call. The security docs are honest about this: *"Gondolin prevents network egress to other hosts, but does not stop the guest from uploading arbitrary data to an allowed host."*

**The API key proxy pattern I proposed is already built into Gondolin.** The secret placeholder mechanism is architecturally identical: the guest never sees real API keys, only random placeholders. The host substitutes real values at the network layer, only for allowed hosts. This is better than my crude HTTP proxy sketch — it's per-secret, per-host, and operates at the header level with support for Basic auth decoding. And it existed before I proposed it.

### Principle 5: Defense in Depth Requires Independent Failure Modes

**Verdict: Genuinely layered, with independent failure modes.**

Gondolin's layers have *different* enforcement mechanisms:

| Layer | Mechanism | What it catches | How it could fail |
|-------|-----------|----------------|-------------------|
| QEMU VM boundary | Hardware virtualization (HVF/KVM) | Process escape, memory access, raw syscalls | QEMU exploit (hypervisor bug) |
| Userspace network stack | Protocol parsing + allowlist | Network exfiltration, tunneling | Bug in TCP/HTTP parser |
| VFS providers | Host-side filesystem mediation | Unauthorized file access | Bug in RPC service or provider |
| ShadowProvider | Path-matching + symlink resolution | Secret file reads within mounted dirs | Incomplete shadow patterns |
| Secret placeholders | Header substitution at network layer | Credential theft | Reflection via allowed host echoing back headers |

Each layer fails for different reasons. A QEMU escape bypasses everything (acknowledged non-goal). A bug in the HTTP parser might allow raw TCP — but the VFS still confines filesystem access. A symlink bypass in the ShadowProvider leaks a secret file — but network confinement prevents exfiltrating it to an unauthorized host.

This is genuine defense in depth, not "four application-level checks that all fail to the same `python -c`" trick.

### Principle 6: The Audit Trail Must Be Outside the Blast Radius

**Verdict: Partial. Hooks exist for comprehensive auditing; no built-in append-only log.**

Gondolin provides observable hooks:
- `httpHooks.onRequestHead` / `onResponse` — see every HTTP request/response
- `vfs.hooks.before` / `after` — see every filesystem operation
- `ssh.execPolicy` — see and approve/deny every SSH exec request

These run on the **host**, outside the VM boundary. The guest cannot tamper with them. This is the right architecture for auditing.

What's missing: no built-in structured audit log with tamper-evidence (hash chaining, append-only storage). You'd build it yourself using the hooks. Given Gondolin's SDK-first design, this is a "compose it" rather than "missing" situation — but a `createAuditLogger()` utility that writes hash-chained JSONL to a specified path would be a valuable addition.

The session registry (`~/.cache/gondolin/sessions/`) provides basic lifecycle tracking but isn't an audit trail.

### Principle 7: Time is a Threat Dimension

**Verdict: Correctly addressed by ephemeral-by-default design.**

The [workloads documentation](../../gondolin/docs/workloads.md) explicitly advocates: *"Treat VMs as disposable... Design your workloads so that throwing away a VM is always safe."*

- VMs boot in under a second — no incentive to keep them alive
- Root filesystem is a qcow2 overlay — discarded on close
- tmpfs paths (`/root`, `/tmp`, `/var/log`) don't survive
- VFS mounts use host providers — state is explicit and controllable
- Disk checkpoints are opt-in and explicit, not silent accumulation

Cross-session poisoning attacks (modifying `.bashrc`, planting git hooks, etc.) are naturally mitigated: the VM starts fresh each time. The guest's `/root/.bashrc` is tmpfs-backed and doesn't persist. The `.git/hooks/` directory is only accessible through the VFS mount — and since the mount is configured by the host, not the guest, the host controls what persists.

One gap: if using `RealFSProvider` with read-write access, the guest *can* write `.git/hooks/pre-commit` to the host project directory, and that hook will persist across VM sessions (because it's on the host filesystem). This is an inherent trade-off of read-write workspace mounts — the agent needs to write code, and code can include git hooks. The `ShadowProvider` could shadow `.git/hooks/` if you're paranoid, but this breaks legitimate git workflow.

---

## What Gondolin Gets Right That Nobody Else Does

### 1. Secret Non-Exposure Is Architecturally Correct

Every other solution I've reviewed (pi's sandbox extension, nono, Docker containers, Claude Code) puts secrets into the agent's environment or filesystem and then tries to prevent the agent from leaking them. This is fundamentally backwards — the secret is already in the untrusted domain.

Gondolin's placeholder mechanism is the correct approach: **real secrets never enter the guest.** The guest gets `GONDOLIN_SECRET_<random>`. When the guest makes an HTTP request, the host substitutes the real value *only* for allowed hosts, *only* in headers. The guest cannot read, print, log, or exfiltrate the real value because it literally doesn't have it.

The security doc is honest about the limitation: *"does not fully protect the system if there are ways to utilize the target server to echo the secrets back."* An httpbin-style service on an allowed host could reflect headers. But this requires the attacker to both control an allowed host and have the guest send a request there — a much narrower attack surface than "the secret is in an env var."

The defense-in-depth check is also clever: `assertSecretValuesAllowedForHost()` scans outbound requests for real secret values (not just placeholders) and blocks them if the destination isn't allowed. This catches scenarios where a redirect chain moves a request from an allowed host to a disallowed one while carrying the substituted secret.

### 2. The Userspace Network Stack Is the Key Innovation

Instead of "give the guest a real network and try to firewall it," Gondolin says: the guest has no real network. It has an Ethernet interface connected to a host-side TCP/IP stack that only understands HTTP and TLS.

This eliminates entire threat categories:
- **No raw TCP tunnels.** Period. Not blocked by a rule — structurally impossible.
- **No UDP (except DNS).** No DNS tunneling in default synthetic mode (no upstream DNS to tunnel to).
- **No SSH/SOCKS/VPN.** SSH only when explicitly enabled, proxied by the host, exec-only (no shells, no SFTP).
- **No ICMP exfiltration.** Pings "work" but are faked by the host — no real ICMP packets leave.
- **DNS rebinding protection.** The host resolves hostnames itself, independently of guest DNS. Guest DNS results are disregarded for policy decisions.

The HTTP bridging means the host can inspect, transform, and policy-check every request *after* TLS termination. The guest thinks it's talking HTTPS to `api.github.com`. The host terminates TLS locally, inspects the HTTP request, applies policy, substitutes secrets, and replays the request to the real server. The guest never gets a raw socket to the internet.

**Limitation:** HTTP/1.x only. No HTTP/2, HTTP/3, QUIC, WebRTC. Some APIs might require these, but for coding agent workflows (npm, git HTTPS, API calls), HTTP/1.x covers virtually everything.

### 3. The VFS Architecture Solves the Read Tool Problem

My first-principles analysis identified `read` as the most dangerous tool because it's in-process and unsandboxable. Gondolin solves this by making `read` into a VFS operation that goes through the host provider stack:

```
Agent calls read("foo.txt")
  → pi-gondolin extension maps to /workspace/foo.txt
    → vm.exec(["/bin/cat", "/workspace/foo.txt"])
      → guest kernel → FUSE → sandboxfs → RPC → host VFS provider
        → ShadowProvider checks path
          → RealFSProvider reads from host disk (with symlink escape protection)
```

Every step in this chain is on the host side or inside the VM boundary. The `RealFSProvider` has hardened symlink handling — `_resolvePathFollow()` checks `realpath()` against the root directory, `_assertAncestorWithinRoot()` validates ancestor paths, dangling symlinks are rejected (strict fail-closed). The code in `host/vendor/node-vfs/lib/internal/vfs/providers/real.js` shows this was carefully considered:

- Lexical path containment check first (`_resolvePathLexical`)
- Then realpath verification to catch symlinks escaping root (`_resolvePathFollow`)
- Then a separate method for nofollow-final that validates ancestors but treats the final segment lexically (`_resolvePathNoFollowFinal`)
- macOS `/var` → `/private/var` symlink edge case handled explicitly

### 4. The Pi Extension Proves the Integration Model

`pi-gondolin.ts` is ~250 lines and overrides all four tools. It demonstrates that Gondolin's SDK is composable enough to retrofit security onto an existing agent without modifying the agent itself. Pi doesn't need to change — the extension intercepts tool calls and redirects them to the VM.

This is the "split trust domain" architecture I proposed, implemented as a pi extension rather than an agent architecture change. Pragmatically better — works today with stock pi.

---

## What's Weak or Missing

### 1. The Pi Extension Example Is Under-Hardened

`pi-gondolin.ts` uses `RealFSProvider(localCwd)` with no `ShadowProvider`, no network hooks, and no secrets configuration. It's a proof of concept, not a secure default. An agent using this extension can:

- Read `.env` files in the project (secrets enter context)
- Access any file in the project tree including `.git/config` (may contain credentials)
- Write to `.git/hooks/` (persistent cross-session payloads)
- Make no outbound HTTP requests at all (no `httpHooks` configured — which actually means the default no-network policy applies, but this isn't obvious from reading the code)

**Recommendation:** Ship a hardened variant alongside the minimal example. Something like:

```typescript
const { httpHooks, env } = createHttpHooks({
  allowedHosts: ["registry.npmjs.org", "*.github.com"],
  secrets: {
    GITHUB_TOKEN: { hosts: ["*.github.com"], value: process.env.GITHUB_TOKEN! },
  },
});

const workspace = new ShadowProvider(new RealFSProvider(localCwd), {
  shouldShadow: createShadowPathPredicate([
    "/.env", "/.env.local", "/.env.production",
    "/.npmrc", "/.git/config",
  ]),
  writeMode: "deny",
});

const vm = await VM.create({ httpHooks, env, vfs: { mounts: { "/workspace": workspace } } });
```

### 2. Exfiltration to Allowed Hosts Is the Residual Risk

The security doc acknowledges this clearly. If `api.github.com` is allowed, the agent can POST project source code there (e.g., create a gist). If `registry.npmjs.org` is allowed, the agent could publish a package containing exfiltrated data.

This is inherent to the allowlist model — anything you allow can be abused. The HTTP hooks (`onRequestHead`, `onRequest`) provide the mechanism to restrict this further (e.g., block POST/PUT to certain paths, block `npm publish`, etc.), but this requires per-workflow policy engineering.

For most agent workflows, the practical risk is low: the allowed hosts are usually services the agent legitimately needs (npm registry, git remote, API endpoints). But for high-security environments where the agent handles proprietary code, even allowed-host exfiltration matters.

### 3. No Audit Trail Out of the Box

The hooks are there. The architecture is correct (host-side observation). But there's no `createAuditLogger()` convenience that writes structured, timestamped, hash-chained events to a file. For a security-focused tool, this should be built-in, not "compose it yourself."

### 4. TLS MITM CA Management

The local CA key is stored under `~/.cache/gondolin/ssl`. A compromised host process or a local attacker with same-user access could sign arbitrary certificates trusted by guests. The security doc notes: *"Treat the CA private key as sensitive."* There's a `mitmCertDir` option for per-run isolation, but the default is a persistent shared CA.

For most users this is fine — the CA is only trusted inside ephemeral VMs. But it's worth noting that the TLS MITM is a real trust addition: the guest trusts certificates it normally wouldn't. If the CA key leaks, an attacker could MITM the guest's HTTPS without Gondolin's involvement.

### 5. QEMU as the Isolation Boundary

The security model's strongest guarantee depends on QEMU not having exploitable vulnerabilities. QEMU is a large, complex codebase with a history of CVEs. The QEMU configuration is intentionally minimal (`-nodefaults`, virtio devices only, no USB/PCI passthrough), which significantly reduces attack surface, but the risk isn't zero.

For most threat models (prompt injection → agent does bad thing), QEMU isolation is massive overkill — the agent would need a kernel exploit + QEMU escape chain. For nation-state threat models, the VM boundary is a real concern. Gondolin's non-goal list is honest about this.

### 6. Performance Overhead of VFS-via-FUSE-via-RPC

Every filesystem operation in the guest goes: FUSE → RPC → virtio-serial → host provider. For write-heavy workflows (large `npm install`, compilation with many output files), this could be significantly slower than native filesystem access. The docs acknowledge this: *"from a performance perspective very suboptimal."*

For typical agent workflows (read some files, edit a few, run tests), this is probably fine. But for build-heavy tasks, the VFS overhead could be noticeable.

### 7. Host Process Is Fully Trusted

Gondolin's threat model explicitly assumes the host (Node.js process) is trusted. This means:
- A malicious pi extension running on the host has full access to everything
- The Gondolin SDK itself runs with full host privileges
- If the host Node.js process is compromised (dependency chain attack on Gondolin's own npm dependencies), all guarantees collapse

This is a reasonable design choice — you have to trust *something*. But it means Gondolin doesn't protect against pi's supply chain risk (malicious community extensions or skills). Those execute on the host, outside the VM.

---

## Mapping to the NVIDIA Controls

| NVIDIA Control | Gondolin | Notes |
|---|---|---|
| Network egress | ✅ | Userspace stack, allowlist-only, no raw TCP/UDP |
| Write outside workspace | ✅ | VFS mount is the only writable path; no host FS by default |
| Config file writes | ✅ | `.git/hooks`, `.bashrc` etc. not in VM; ShadowProvider available for project-dir config |
| Read outside workspace | ✅ | Only mounted paths exist; `~/.ssh` etc. structurally absent |
| Sandbox everything | ✅ | All four tools execute in VM (with pi extension) |
| Virtualization | ✅ | QEMU micro-VM with HVF/KVM |
| Per-instance approval | ⚠️ | Not built-in, but HTTP hooks + VFS hooks could implement it |
| Secret injection | ✅ | Placeholder substitution at network layer; secrets never in guest |
| Lifecycle management | ✅ | Ephemeral VMs; tmpfs for transient state; qcow2 overlay discarded |

**This is the first tool I've reviewed that achieves ✅ on the NVIDIA mandatory controls.** Docker containers get close but miss secret injection and granular network control. Nono gets close but is unverified and may break dev tools. Gondolin covers them all with a coherent, tested architecture.

---

## Comparison to My Proposed "Split Trust Domain" Architecture

In the [first-principles document](agent-security-first-principles.md), I proposed an ideal architecture with:

| Proposed Component | Gondolin Equivalent | Match? |
|---|---|---|
| All tools out-of-process | Pi extension routes all tools through VM | ✅ |
| Capability tokens per session | VFS mount map + network allowlist + ShadowProvider | ✅ (declarative, not token-based, but equivalent) |
| API key proxy | Secret placeholder mechanism | ✅ (better — per-secret, per-host, header-level) |
| Context taint tracking | Not present | ❌ |
| Immutable audit outside blast radius | Hooks on host; no built-in logger | ⚠️ (architecture correct, tooling missing) |
| Ephemeral by default | VMs are disposable; tmpfs transient state | ✅ |

**Gondolin is the closest thing to the architecture I proposed that actually exists.** It's missing taint tracking (which I acknowledged was speculative) and a built-in audit logger (which is a tooling gap, not an architectural one). Everything else maps directly.

The secret mechanism is better than my API key proxy proposal because it's integrated into the network stack rather than being a separate process, and it supports per-secret host restrictions and Basic auth handling.

---

## The Honest Bottom Line

Gondolin is the **architecturally correct solution** to the coding agent security problem. Not "another layer of walls around a bad architecture" — an actually good architecture that puts trust boundaries in the right places.

**What it gets right that matters:**
1. All tools execute inside a VM (hardware isolation boundary)
2. Secrets never enter the guest (placeholder substitution at network layer)
3. Network is allowlist-only with no raw sockets (userspace stack)
4. Filesystem is allowlist-only (mount-based, not denylist-based)
5. Ephemeral by default (disposable VMs)

**What it costs:**
1. QEMU dependency (~200MB guest image download on first run)
2. Sub-second boot latency per VM (real but small)
3. VFS performance overhead for I/O-heavy workflows
4. Complexity — more moving parts than "just run pi bare"
5. ARM64-only currently tested (Apple Silicon + Linux aarch64)

**What it changes about the landscape document's conclusions:**
- The landscape document concluded: "pi's defaults are ❌ across the board on NVIDIA controls." Pi + Gondolin extension achieves ✅ on all mandatory controls. This is a material change.
- The landscape document concluded: "VM-level isolation is the endgame." Gondolin *is* that endgame, with the added insight that the VM boundary alone isn't enough — you also need network mediation and secret non-exposure, which Gondolin provides.
- The landscape document spent significant space on nono. Gondolin renders nono mostly irrelevant for this use case — it provides everything nono promises (filesystem confinement, secret management, lifecycle control) plus things nono doesn't have (network mediation, VFS programmability, tool-level isolation), and it's further along in development (shipped SDK + CLI + tests + fuzz harness, not pre-alpha).
- My first-principles document proposed an API key proxy as "the highest-ROI intervention nobody is doing." Gondolin already does it, and does it better.

**The remaining unsolved problem:** data exfiltration to the LLM provider. Every API call sends context (including file contents the agent read) to Anthropic's servers. Gondolin can't fix this — it's inherent to using a cloud LLM. The only solution is local models, which currently can't match frontier model capability. This is the one threat that no sandbox can address.

---

## Self-Assessment

**What's strong in this review:** Direct code inspection of the security-critical components (http-hooks.ts, shadow.ts, real.js, sandbox-controller.ts, pi-gondolin.ts). The NVIDIA mapping is based on actual architectural guarantees, not documentation claims. The comparison to my own proposed architecture is honest — Gondolin does most of what I proposed, and does the secret handling better.

**What I haven't verified:** Actual VM breakout resistance (depends on QEMU, which I haven't audited). Performance impact of VFS-over-FUSE-over-RPC in real agent workflows. Whether the userspace TCP stack handles all edge cases correctly (the fuzz harness exists, which is reassuring). Whether the pi extension works end-to-end with current pi versions (the code looks correct but I haven't run it).

**What could change this assessment:** A QEMU escape CVE. A bug in the network stack that allows raw TCP tunneling. Discovery that the VFS RPC has a path traversal despite the containment checks. Or, performance being bad enough that users disable the VFS mount and go back to host-direct tools.

---

*This review is based on the gondolin repository at `../gondolin/` as of Feb 19, 2026. The project appears to be under active development.*
