← [Gondolin Research](gondolin-agent-sandbox.md) · [Matchlock HN Thread](hn-matchlock-agent-sandbox.md) · [Index](../README.md)

# Gondolin vs Matchlock: Deep Comparison for Blocking Solvable Attacks

**Date:** 2026-02-21

Both tools share the same architecture (micro-VM + network MITM + secret injection + filesystem bridge) and the same fundamental limitation (can't stop exfiltration through authorized channels — see [Matchlock HN insight #1](hn-matchlock-agent-sandbox.md)). This comparison focuses on the "solvable attacks" — the ones sandboxing CAN block — and which tool blocks them better.

---

## The Solvable Attacks

| # | Attack | What it means |
|---|--------|---------------|
| A | **VM escape** | Guest code breaks out of the VM to run on host |
| B | **In-VM privilege escalation** | Guest code gets kernel privilege inside the VM, enabling attacks on the host↔guest interface |
| C | **Filesystem escape** | Guest reads/writes host files outside the intended mount |
| D | **Network exfiltration to unauthorized hosts** | Guest sends data to destinations not on the allowlist |
| E | **DNS tunneling** | Guest encodes data in DNS queries to exfiltrate without HTTP |
| F | **Credential theft** | Guest reads real API keys/tokens |
| G | **Metadata service access** | Guest reaches cloud instance metadata (169.254.169.254) to steal cloud credentials |

---

## Head-to-Head

### A. VM Escape — Winner: Matchlock

**Matchlock on Linux:** Firecracker. ~50K lines of Rust. Purpose-built for sandboxing untrusted code. Powers AWS Lambda. Minimal device model — no legacy devices, no USB, no PCI, no graphics. The attack surface is deliberately tiny. Extensively audited by AWS and external security researchers.

**Matchlock on macOS:** Apple Virtualization.framework. Apple's native hypervisor, maintained by Apple. Lean — no device emulation layer between guest and hardware virtualization.

**Gondolin:** QEMU with microvm machine type. QEMU is millions of lines of C. The microvm machine type strips it down (no floppy, no PCI), but the QEMU process still carries vastly more code than Firecracker. QEMU has had VM escape CVEs — VENOM (CVE-2015-3456, via the floppy controller) is the famous one. microvm avoids that specific device, but the principle holds: more code = more bugs. Gondolin's own security doc acknowledges this: *"VM escape / hypervisor bugs: Gondolin uses QEMU; a QEMU escape is a host compromise."*

**Verdict:** Firecracker is the strongest VM boundary available for this use case. QEMU microvm is reasonable but has a fundamentally larger attack surface. This is the single most important security property — if the VM boundary falls, nothing else matters.

### B. In-VM Privilege Escalation — Winner: Matchlock (Gondolin doesn't address this)

**Matchlock:** Defense-in-depth inside the VM, developed empirically from Opus 4.6 red-teaming:
- Guest agent spawns commands in new PID + mount namespace
- Drops capabilities: `SYS_PTRACE`, `SYS_ADMIN`, others
- Sets `no_new_privs` (prevents escalation through setuid binaries)
- Installs seccomp-BPF filter blocking: `process_vm_readv/writev`, `ptrace`, kernel module loading (`init_module`, `finit_module`)

This directly counters the attacks jingkai_he observed: gcc kernel modules (blocked by seccomp), ptrace-based exploitation (blocked by cap drop + seccomp), BPF exploitation (partially mitigated by capability drops).

**Gondolin:** No documented seccomp-BPF, no capability drops, no namespace isolation inside the VM. Confirmed by code search — the terms don't appear anywhere in the codebase. The security model relies entirely on the VM boundary (QEMU) + host-side mediation.

**Verdict:** Gondolin assumes the VM boundary is sufficient. Matchlock assumes it isn't and adds layers. Given that Opus 4.6 demonstrated it will try to load kernel modules, exploit ptrace, and probe BPF — the layers matter. With root inside Gondolin's guest, an agent can load kernel modules, manipulate the virtio devices directly, and probe the host↔guest interface. With Matchlock's hardening, those paths are blocked before they start.

### C. Filesystem Escape — Winner: Gondolin (slightly)

Both use custom FUSE-over-virtio bridges. Both are unaudited. Neither has a clean bill of health.

**Matchlock:** FUSE-over-vsock, custom Go protocol. yencabulator identified a probable path traversal bug in `realfs.go` — `filepath.Join` doesn't enforce a root boundary. No documented symlink protections. jingkai_he never addressed the concern.

**Gondolin:** VFS in Node.js via FUSE + virtio. The vendored node-vfs has explicit symlink escape protection:
- *"Symlinks that escape the exposed directory are blocked for operations that follow symlinks"*
- *"Dangling symlinks are also blocked (strict fail-closed behavior)"*
- `denySymlinkBypass: true` by default — consults `realpath()` to block symlink bypasses
- `FsRpcService` validates: file names are single components (no `/` or NUL), paths normalized to absolute POSIX, payload sizes capped

Additionally, Gondolin offers `MemoryProvider` (no host filesystem access at all) and `ReadonlyProvider` (read-only wrapper). You can avoid the filesystem bridge entirely for scratch workspaces.

**Verdict:** Both are custom and new, but Gondolin is demonstrably more aware of this bug class and has documented mitigations. The `MemoryProvider` option — avoiding the host filesystem bridge entirely — is a genuine security advantage. Matchlock has a known probable bug that was raised publicly and not addressed.

### D. Network Exfiltration to Unauthorized Hosts — Winner: Gondolin

Both block unauthorized destinations. The difference is in depth.

**Matchlock on Linux:** nftables DNAT redirecting ports 80/443 through a transparent proxy. Standard Linux networking infrastructure — battle-tested but operates at the transport level. On macOS with `--allow-host`/`--secret`: gVisor userspace TCP/IP stack at L4.

**Gondolin:** Full ethernet stack reimplemented in JavaScript. The host implements its own IP/TCP/HTTP parsing. Key differences:
- **Protocol classification:** For each TCP flow, the host sniffs first bytes and classifies as HTTP, TLS, or SSH. Everything else is **denied** — no arbitrary TCP tunnels.
- **HTTP CONNECT blocked** — prevents proxy tunneling.
- **UDP blocked except DNS** — no arbitrary UDP exfiltration.
- **Redirect following on host side** — redirects can't escape the allowlist because the host follows them and re-checks policy at each hop. The guest only sees the final response.
- **DNS rebinding protection** — IP policy checked twice: once after resolution, once during connection establishment (via custom undici dispatcher).
- **Internal range blocking** — 127/8, 10/8, 172.16/12, 192.168/16, 169.254/16, 100.64/10 all blocked by default. Includes IPv6 equivalents.
- **Programmable hooks** — `onRequestHead`, `onResponse`, `isRequestAllowed`, `isIpAllowed`. You can inspect individual HTTP requests, block specific paths/methods, log traffic.

**Verdict:** Gondolin's network mediation is deeper and more paranoid. The protocol classification (deny everything that isn't HTTP/TLS/SSH) is a much tighter policy than port-based redirection. The redirect policy enforcement and DNS rebinding protection close real attack paths. The programmable hooks let you build custom inspection logic — the closest thing to content-aware egress that exists in either tool.

### E. DNS Tunneling — Winner: Gondolin (Matchlock doesn't address this)

**Gondolin:** Three DNS modes:
- `synthetic` (default): **No upstream DNS at all.** The host replies with synthetic A/AAAA answers. DNS cannot be used as an exfiltration channel because queries never leave the host.
- `trusted`: Forwards valid DNS queries to trusted resolvers only. Prevents UDP/53 as arbitrary transport, but doesn't prevent classic DNS tunneling to attacker-controlled domains.
- `open`: Forwards to guest-targeted destination. Enables tunneling.

The default (`synthetic`) is the most secure option possible — it eliminates DNS as a data channel entirely.

**Matchlock:** No documented DNS policy. Unclear how DNS is handled on either platform.

**Verdict:** Gondolin's synthetic DNS is a real security feature with no equivalent in Matchlock. DNS tunneling is a well-known exfiltration technique that bypasses HTTP-level controls. Blocking it by default is meaningful defense.

### F. Credential Theft — Roughly Equal

Both use placeholder-based MITM substitution. Secrets never enter the VM. Both substitute only for allowed hosts.

**Gondolin extras:**
- Decodes/re-encodes Base64 Basic auth (`Authorization: Basic ...`)
- Query parameter substitution available as explicit opt-in
- If placeholder found but destination not allowed → request blocked (not just unsubstituted)
- Security doc explicitly warns: *"do not assume allowed hosts can't echo secrets back"*

**Matchlock extras:**
- Private IP blocking configurable per-secret in SDK
- Secret scoping via `--secret KEY@host` syntax in CLI

**Verdict:** Functionally equivalent. Gondolin is slightly more thorough (Base64 auth handling, query params, explicit blocking on host mismatch).

### G. Metadata Service Access — Roughly Equal

Both block RFC1918 and link-local ranges (including 169.254.169.254) by default. Both let you override this if needed.

---

## Beyond Security: Practical Factors

| Factor | Matchlock | Gondolin |
|--------|-----------|---------|
| **Docker image support** | ✅ Any OCI image | ❌ Custom Arch Linux images only |
| **SDKs** | Go, Python, TypeScript | TypeScript only |
| **CLI UX** | `matchlock run --image alpine` | `npx @earendil-works/gondolin bash` |
| **Programmability** | JSON-RPC SDK, basic hooks | Deep JS hooks for network, filesystem, VM lifecycle |
| **Red-team tested** | ✅ Empirical Opus 4.6 testing, defense shaped by results | No documented red-teaming |
| **Author track record** | New developer (jingkai_he) | Armin Ronacher (Flask, Jinja, Rye, ex-Sentry) |
| **VFS overhead** | FUSE-over-vsock (Go) | FUSE-over-virtio (Node.js) — acknowledged as "very suboptimal" |
| **License** | MIT | Apache-2.0 |
| **Pi integration** | None | Built-in extension |

---

## The Scorecard

| Attack | Matchlock | Gondolin | Winner |
|--------|-----------|----------|--------|
| **A. VM escape** | Firecracker (~50K LOC Rust) | QEMU microvm (millions LOC C) | **Matchlock** |
| **B. In-VM privilege escalation** | seccomp-BPF + cap drops + namespaces | Not addressed | **Matchlock** |
| **C. Filesystem escape** | Probable path traversal bug | Symlink protection, MemoryProvider | **Gondolin** |
| **D. Unauthorized network exfiltration** | nftables/gVisor proxy | JS ethernet stack, protocol classification, redirect enforcement, rebinding protection | **Gondolin** |
| **E. DNS tunneling** | Not addressed | Synthetic DNS (default: no upstream) | **Gondolin** |
| **F. Credential theft** | Placeholder MITM | Placeholder MITM + Base64 auth | Tie |
| **G. Metadata service** | Blocked by default | Blocked by default | Tie |

Matchlock: 2 wins (A, B). Gondolin: 3 wins (C, D, E). Ties: 2 (F, G).

---

## Recommendation

**Neither is clearly better. They're strong in opposite places.**

Matchlock's wins (A, B) are about the **primary isolation boundary** — the VM itself. If the VM is escaped or the guest gets kernel privilege, nothing else matters. Firecracker + seccomp-BPF + capability drops is a harder wall than QEMU with no in-VM hardening. This is the foundation everything else rests on.

Gondolin's wins (C, D, E) are about **policy sophistication** — what happens within the boundary. The JS-programmable network stack, synthetic DNS, symlink protection, and MemoryProvider give you more tools to express fine-grained policy. If the VM holds, Gondolin lets you do more with the containment.

**My recommendation: Matchlock today, watch Gondolin.**

The reasoning:

1. **The foundation matters most.** A sophisticated network policy on a weaker VM is worse than a simple allowlist on a stronger VM. If Opus 4.6 loads a kernel module inside Gondolin's guest (which nothing prevents), it can manipulate virtio devices and potentially bypass the host-side network stack entirely. In Matchlock, seccomp blocks kernel module loading before it starts.

2. **Docker image support is a practical requirement.** Most real agent workflows need specific runtimes. `matchlock run --image python:3.12-alpine --allow-host api.github.com` is immediately usable. Gondolin requires building custom images.

3. **Empirical red-teaming over theoretical design.** Matchlock's defenses were shaped by what Opus 4.6 actually tried. Gondolin's security model is thoughtfully designed (Armin's security doc is excellent) but hasn't been publicly tested against an adversarial LLM.

4. **Multi-language SDKs.** If you're not in TypeScript, Matchlock is your only option.

**When Gondolin would be the better choice:**

- You're building a TypeScript agent framework and need programmable network hooks (inspect request bodies, custom per-path policies, log traffic patterns)
- You specifically need DNS tunneling prevention (Matchlock has no answer for this)
- You want to avoid host filesystem exposure entirely (Gondolin's `MemoryProvider` eliminates the bridge)
- You're already in the Pi agent ecosystem

**The ideal tool would combine Gondolin's network stack with Matchlock's VM boundary and in-VM hardening.** That doesn't exist yet.

**Update (Jul 2026):** Sean Heelan's [exploit generation research](https://sean.heelan.io/2026/01/18/on-the-coming-industrialisation-of-exploit-generation-with-llms/) strengthens the case for Matchlock's foundation-first approach. Heelan got Opus 4.5 and GPT-5.2 to generate 40+ working exploits for a zero-day vulnerability, bypassing ASLR + CFI + shadow stacks + seccomp, at ~$30-50 per exploit chain. This isn't CTF benchmark performance — it's primary evidence of LLMs developing novel exploit chains against real targets. Gondolin's lack of in-VM hardening (no seccomp, no capability drops) means an agent with kernel access inside the guest could attempt these techniques against the QEMU↔host interface. The economics ($30-50 per chain) make this practical, not theoretical.

---

## Sources

- [Gondolin security design](https://earendil-works.github.io/gondolin/security/)
- [Gondolin VFS docs](https://earendil-works.github.io/gondolin/vfs/) — symlink protection details
- [Gondolin network docs](https://earendil-works.github.io/gondolin/network/) — DNS modes, protocol classification
- [Matchlock README](https://github.com/jingkaihe/matchlock)
- [VirtusLab: Matchlock deep dive](https://virtuslab.com/blog/ai/matchlock-your-agents-bulletproof-cage/) — Layer-by-layer architecture analysis
- [HN thread](https://news.ycombinator.com/item?id=46932343) — red-teaming anecdotes, yencabulator's path traversal concern
