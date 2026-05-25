← [Coding Agents](../topics/coding-agents.md) · [Index](../README.md)

# Gondolin Security Review: Code Validation & Cross-Reference

*February 19, 2026. Validating [gondolin-security-review.md](gondolin-security-review.md) against the actual codebase at `../../gondolin/` and external security expert evaluations.*

---

## Methodology

Every architectural claim, code reference, and security assertion in the original review was checked against the actual source files. Key files inspected:

- `host/examples/pi-gondolin.ts` — pi extension (tool overrides)
- `host/src/http-hooks.ts` — secret placeholders, allowlist enforcement
- `host/src/network-stack.ts` — TCP flow classification, protocol sniffing
- `host/src/qemu-net.ts` — HTTP bridging, TLS MITM, WebSocket handling
- `host/src/sandbox-controller.ts` — QEMU invocation, args, arch detection
- `host/src/vfs/shadow.ts` — ShadowProvider, symlink bypass protection
- `host/vendor/node-vfs/lib/internal/vfs/providers/real.js` — RealFSProvider path containment
- `host/src/vfs/provider.ts` — VfsHooks (before/after)
- `host/src/qemu-ssh.ts` — SSH exec policy
- `host/fuzz/` — fuzz targets
- `.github/workflows/ci.yml` — CI matrix (architectures tested)
- `docs/security.md`, `docs/secrets.md`, `docs/network.md`, `docs/limitations.md`

External search conducted via Brave Search for third-party audits, security evaluations, and expert commentary on Gondolin.

---

## Confirmed Accurate

### Tool Boundary Architecture
`pi-gondolin.ts` overrides all 4 tools (read, write, edit, bash) exactly as described. `toGuestPath()` rejects `..` and absolute paths (lines 49–55). Architecture diagram in the review maps correctly to the code.

### Secret Placeholder Mechanism
`http-hooks.ts` confirms: `GONDOLIN_SECRET_<random>` placeholders via `crypto.randomBytes(24)`. `assertSecretValuesAllowedForHost()` scans outbound requests for real secret values in both plaintext headers and Base64-decoded Basic auth. Blocks requests carrying secrets to non-allowed hosts. Defense-in-depth check on redirect chains confirmed.

### RealFSProvider Symlink Hardening
`real.js` confirms the 3-method approach exactly as the review describes:
1. `_resolvePathLexical()` — lexical containment only
2. `_resolvePathFollow()` — lexical + `realpath()` verification, dangling symlinks rejected (strict fail-closed), ancestor validation via `_assertAncestorWithinRoot()`
3. `_resolvePathNoFollowFinal()` — validates ancestors via follow checks, treats final segment lexically

macOS `/var` → `/private/var` edge case handled via `fs.realpathSync()` in constructor. Correctly described.

### ShadowProvider
`shadow.ts` confirms `denySymlinkBypass` defaults to `true`. Resolves via backend's `realpath()` before policy check. The review's characterization as "technically a denylist within an allowlisted mount" is precise.

### Network Stack Protocol Classification
`network-stack.ts` `classifyTcpFlow()` (line 631) confirms:
- TLS: `looksLikeTlsClientHello()` detection
- HTTP: method prefix matching + request line parsing
- SSH: `SSH-` banner on configured ports only
- Everything else: `{ status: "deny", reason: "unknown-protocol" }` → RST

HTTP `CONNECT` explicitly identified and denied (`isConnect` flag). All as described.

### DNS Synthetic Mode
Confirmed as default (`DEFAULT_DNS_MODE: DnsMode = "synthetic"`). Synthetic A/AAAA answers with documentation IPs (`192.0.2.1`, `2001:db8::1`). No upstream resolver. Structurally eliminates DNS tunneling.

### QEMU Minimal Config
`buildQemuArgs()` confirms: `-nodefaults`, `-no-reboot`, `-nographic`, virtio-only devices (serial ×4 ports, net, blk, rng). No USB, no PCI passthrough.

### VFS and SSH Hooks
`VfsHooks` type in `provider.ts` (line 33) confirms `before`/`after` hooks running on host. `ssh.execPolicy` callback confirmed in `qemu-ssh.ts` (line 91, 633). `httpHooks.onRequestHead`/`onResponse` confirmed in `qemu-net.ts`.

### Pi Extension Limitations
Confirmed: no `ShadowProvider`, no `httpHooks`, no `secrets` configuration. Uses `RealFSProvider(localCwd)` bare. Review's characterization is accurate — including the subtle point that no `httpHooks` means no-network-by-default (since no allowed hosts exist).

### NVIDIA Controls Mapping
Validated against the actual NVIDIA AI Red Team blog post (Feb 2026, "Practical Security Guidance for Sandboxing Agentic Workflows"). The mapping is accurate. The mandatory controls (network egress, write outside workspace, config file writes, read outside workspace, sandbox everything, secret injection, lifecycle management) all map correctly to Gondolin's guarantees.

### Fuzz Harness
Confirmed: 5 targets (virtio, network, DNS, tar, SSH exec). Deterministic with seed/repro support. `host/fuzz/README.md` documents usage.

### Ephemeral Design
Confirmed: qcow2 overlay for root disk (`snapshot=on`), tmpfs-backed transient paths, disposable VMs. `.git/hooks` persistence concern via `RealFSProvider` RW mount is valid.

### Defense-in-Depth Layer Independence
The review's 5-layer table (QEMU boundary, userspace network stack, VFS providers, ShadowProvider, secret placeholders) maps accurately to independent code paths with distinct failure modes. Not just "four application-level checks."

---

## Errors Found

### 1. "ARM64-only currently tested" — WRONG

**Review states:** *"ARM64-only currently tested (Apple Silicon + Linux aarch64)"* (in "What it costs" section)

**Reality:** CI (`ci.yml`) builds guest images for **both x86_64 and aarch64** in a matrix build. The full test suite runs on `ubuntu-latest` (x86_64) with KVM acceleration enabled (`sudo chown $(id -u) /dev/kvm`). The `selectMachineType()` function selects `microvm` for Linux x86_64, `virt` for arm64, `q35` as fallback. `selectAccel()` handles KVM (Linux), HVF (macOS), and TCG (fallback) for both architectures.

**Both architectures are first-class.** The review should say something like "macOS (Apple Silicon via HVF) and Linux (aarch64/x86_64 via KVM) are tested in CI."

### 2. WebSocket Tunnel Omitted — Security-Relevant Gap

**Review states:** *"HTTP/1.x only. No HTTP/2, HTTP/3, QUIC, WebRTC"* under the userspace network stack analysis.

**Reality:** WebSocket upgrades are supported by default (`allowWebSockets: true` in `qemu-net.ts` line 447). After the `101 Switching Protocols` response, the connection becomes an **opaque bidirectional tunnel** — HTTP-level hooks (`onRequestHead`, `onRequest`, `onResponse`) no longer mediate the traffic. Only the initial handshake is inspectable/hookable.

The security doc explicitly warns: *"WebSocket upgrades are supported, but after the 101 response the connection becomes an opaque tunnel (only the handshake is mediated/hookable). Disable via `allowWebSockets: false` / `--disable-websockets`."*

**Security implication the review missed:** A WebSocket connection to an allowed host creates a persistent bidirectional channel that bypasses all HTTP observation hooks post-handshake. An adversarial agent could:
1. Establish a WebSocket to an allowed host
2. Exfiltrate data through the WebSocket frame stream
3. None of this would be visible to `onRequestHead` or `onResponse` hooks

This is a strictly worse exfiltration channel than standard HTTP to allowed hosts (which the review does analyze), because HTTP requests are at least hookable per-request. WebSocket traffic flows unmediated.

**Mitigation exists:** `allowWebSockets: false`. But the review should have flagged this in its "Exfiltration to Allowed Hosts" section and in the defense-in-depth table.

---

## Notable Omissions (Not Errors)

These are things absent from the review that would strengthen or nuance its analysis:

### 1. `sandboxingress` — Host-to-Guest HTTP Routing
A fourth virtio-serial port (`virtio-ingress`) enables the host to route inbound HTTP requests into guest services. Not discussed. Relevant for workloads where the VM serves HTTP (dev servers, preview deployments).

### 2. VFS RPC Payload Cap
`MAX_RPC_DATA = 60 KiB` per VFS operation. Each file read/write is chunked at this size over virtio-serial RPC. Relevant to the performance discussion (the review mentions VFS-over-FUSE-over-RPC overhead but doesn't quantify the chunking).

### 3. HTTP Body Size Limits
`DEFAULT_MAX_HTTP_BODY_BYTES = 64 MiB` for requests. Configurable per-request via `maxBufferedRequestBodyBytes` in hook results. Provides some DoS mitigation not accounted for in the review's "no complete DoS isolation" characterization.

### 4. HTTP Concurrency Limiting
`DEFAULT_MAX_CONCURRENT_HTTP_REQUESTS = 128` via `AsyncSemaphore`. Another DoS mitigation layer.

### 5. `krun` Backend Investigation
GitHub issue #7 tracks a `krun` (libkrun) backend as an alternative to QEMU. If implemented, would eliminate the QEMU dependency concern (~200MB) and potentially reduce attack surface (krun is smaller than QEMU). Relevant to the review's "What it costs" section.

### 6. `per-host` Synthetic DNS Hostname Mapping
For SSH egress, synthetic DNS can map each hostname to a unique IP (`syntheticHostMapping: "per-host"`), allowing the host to derive the intended hostname from the destination IP. Clever mechanism not discussed.

### 7. Container-Based Image Builds
CI demonstrates Docker-based image building as an alternative to the standard Alpine build. Relevant for custom images.

---

## External Security Evaluations

### Third-Party Audits: None Found

Searched Brave for:
- `"gondolin" microvm agent sandbox security` (various combinations)
- `earendil-works gondolin` (all results)
- `gondolin security review` (with freshness filters)
- Site-specific searches: Reddit, Hacker News, X

**No independent security audits, penetration tests, or expert evaluations of Gondolin exist publicly.** The project has 104 stars and 5 forks on GitHub — still early-stage. No security researcher has published analysis of the codebase.

### NVIDIA AI Red Team (Feb 2026)
The NVIDIA blog post "Practical Security Guidance for Sandboxing Agentic Workflows and Managing Execution Risk" is the key external framework. It validates the *threat model categories* Gondolin addresses but does not mention Gondolin specifically. The review's mapping to NVIDIA controls is self-assessment against an external framework, not an external endorsement.

Key NVIDIA positions that support the review's conclusions:
- Application-level controls are insufficient; OS-level enforcement required ✓ (Gondolin uses VM boundary)
- Secret injection approach recommended ✓ (Gondolin's placeholder mechanism)
- Lifecycle management controls recommended ✓ (Gondolin's ephemeral VMs)
- Virtualization to isolate sandbox kernel from host kernel ✓ (QEMU)
- Network egress controls mandatory ✓ (userspace network stack)

### Industry Landscape
Northflank, vietanh.dev, and other agent sandboxing blog posts discuss microVMs (mostly Firecracker) but don't reference Gondolin. No competitive analysis from other sandbox vendors.

---

## Revised Assessment

The original review is **high-quality, well-reasoned, and mostly accurate.** Its architectural analysis holds up under code inspection, and the security reasoning is sound.

**Required corrections:**
1. Fix "ARM64-only" → both architectures tested in CI
2. Add WebSocket opaque tunnel as a security gap (allowWebSockets defaults to true, post-handshake traffic bypasses HTTP hooks)

**Recommended additions:**
- Note WebSocket risk in the "Exfiltration to Allowed Hosts" section and defense-in-depth table
- Add HTTP body/concurrency limits to nuance the DoS characterization
- Mention `krun` investigation as future mitigation for QEMU dependency
- Flag absence of third-party security audits (the review is currently the most thorough public analysis)

The review's bottom-line conclusion — that Gondolin is the architecturally correct solution to the coding agent security problem — remains well-supported by the evidence. The WebSocket gap is real but bounded (mitigable via `allowWebSockets: false`, and only exploitable against allowed hosts). The ARM64 error is factual but doesn't affect the security analysis.

---

*Validated against gondolin repository and external sources, February 19, 2026.*
