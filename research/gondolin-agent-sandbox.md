← [Index](../README.md)

# Gondolin: Agent Sandbox Research

**Date:** 2026-02-21
**Repo:** https://github.com/earendil-works/gondolin
**Author:** Armin Ronacher ([@mitsuhiko](https://x.com/mitsuhiko)) — creator of Flask, Jinja, Rye; ex-Sentry; now co-founder of Earendil PBC (Vienna, Jan 2026)
**License:** Apache-2.0

---

## What It Is

Gondolin is a local QEMU-based micro-VM sandbox for AI agents with a TypeScript control plane and a Zig guest daemon. It boots lightweight Linux VMs in under a second on macOS (Apple Silicon) and Linux (aarch64).

The key architectural bet: **the entire network stack and virtual filesystem are implemented in JavaScript**, making them fully programmable from the host. This is unusual — most sandbox tools treat networking as infrastructure; Gondolin treats it as application code.

### Core Features

- **Secret injection at network boundary** — Guest VM only sees placeholders (`GONDOLIN_SECRET_<random>`). Real credentials are substituted by the host during HTTP requests, only for allowed hosts. Base64-encoded Basic auth is decoded, substituted, and re-encoded. The VM never possesses the actual secret.
- **Programmable network policy** — Host allowlists, request/response hooks, DNS modes (synthetic by default to block DNS tunneling), DNS rebinding protection, MITM TLS for mediation.
- **Programmable VFS** — Mount in-memory filesystems, read-only host directories, shadow providers, custom providers proxying to remote storage. All via FUSE + virtio.
- **macOS/Linux parity** — QEMU chosen over Firecracker specifically because Firecracker can't run on Macs.
- **Pi agent integration** — Ships with an example extension for the pi coding agent.
- **Snapshots** — Disk-only qcow2 checkpoints with resume.
- **Custom images** — `gondolin build` pipeline for custom packages, kernel, init scripts.
- **Session management** — `gondolin list`, `gondolin attach`, `gondolin snapshot`.

### Tech Stack

| Component | Technology |
|-----------|-----------|
| Host control plane | TypeScript (Node.js) |
| Guest daemon (sandboxfs) | Zig 0.15.2 |
| VM engine | QEMU |
| Guest OS | Arch Linux (considering NixOS) |
| Network stack | JavaScript (ethernet stack reimplementation) |
| VFS | Node.js VFS + FUSE |
| Package | npm (`@earendil-works/gondolin`) |

---

## Timeline & Velocity

| Date | Event |
|------|-------|
| 2026-01-27 | Earendil PBC announced on lucumr.pocoo.org |
| 2026-02-04 | npm 0.1.0 published |
| 2026-02-07 | 0.2.0 — image builder rewrite, debug logging, CLI improvements |
| 2026-02-12 | Armin tweets about vmg's Docker-to-Gondolin image converter |
| 2026-02-15 | 0.3.0 — SSH, WebSocket proxying, snapshots, DNS modes, streaming |
| 2026-02-18 | 0.4.0 — session registry, attach/list CLI, FUSE improvements |
| 2026-02-19 | 0.5.0 — host-side fs APIs, rootfs modes, snapshots |

**5 minor releases in 15 days.** Extremely rapid iteration, consistent with Armin's known shipping cadence. Built "with the support of coding agents" per the repo disclaimer.

---

## Traction & Metrics

| Metric | Value | As of |
|--------|-------|-------|
| GitHub stars | ~551 | 2026-02-21 |
| GitHub forks | 39 | 2026-02-21 |
| Open issues | 10 | 2026-02-21 |
| npm monthly downloads | ~1,157 | 2026-02 (first month) |
| npm first publish | 2026-02-04 | — |

**No confirmed production users** publicly. This is 17 days old.

---

## Who's Talking About It

### Thoughtworks — "So, You Want to Run OpenClaw?" (Feb 20, 2026)

The most substantive external endorsement so far. Thoughtworks' security blog [explicitly recommends Gondolin](https://www.thoughtworks.com/en-us/insights/blog/security/want-run-openclaw) as the go-to option for local agent sandboxing:

> *"If you want to experiment, you have options, such as cloud VMs or local micro-VM tools like Gondolin."*

> *"Gondolin is particularly notable for its secret injection capability, where the VM only sees placeholders for API keys, swapping in real credentials only at the network boundary."*

They also recommend it for the broader security practice of treating secrets as "toxic waste" and using short-lived tokens. **This is notable** — Thoughtworks is a respected voice in software security, and they called out Gondolin by name alongside general practices.

### Hacker News — Matchlock Thread (Feb 17, 2026)

In the [Matchlock Show HN](https://news.ycombinator.com/item?id=46932343) discussion, a commenter positions Gondolin as a peer:

> *"There are a lot of options in this space. Armin Ronacher is working on Gondolin for example. I built agentd as a layer in front of this stuff so you can expose secure shell capabilities over the network."*

The broader thread sentiment: Claude Code's bubblewrap sandbox is "practically useless" (read access to everything by default); vendors don't have incentives to do security properly; people are actively looking for alternatives. Gondolin fits this niche.

### awesome-pi-agent

Listed alongside nono, codemap, and other pi ecosystem tools as "Linux micro-VM sandbox with programmable network/filesystem and Pi integration."

### Armin on X

Tweeting about ecosystem development — vmg building a Docker image → Gondolin VM converter (Feb 12). ~6,700 views. Small but engaged audience.

---

## Competitive Landscape

### Direct Competitors (Local Agent Sandboxes)

| Tool | Isolation | macOS | Network Control | Secret Injection | SDKs | Stars |
|------|-----------|-------|----------------|-----------------|------|-------|
| **Gondolin** | QEMU micro-VM | ✅ (Apple Silicon) | JS ethernet stack, host allowlists | ✅ Placeholder MITM | TypeScript only | ~551 |
| **Matchlock** | QEMU (Mac) / Firecracker (Linux) | ✅ | Domain allowlists | ✅ Placeholder MITM | Go, Python | new |
| **nono** | Landlock (Linux) / Seatbelt (macOS) | ✅ | Kernel-level | ❌ | CLI | ~new |
| **Claude Code sandbox** | bubblewrap | Linux only | Limited | ❌ | Built-in | N/A |

**Matchlock** is the closest competitor — nearly identical feature set (ephemeral microVMs, network allowlisting, secret injection via MITM). Key differences:
- Matchlock uses Docker images directly (via BuildKit-in-VM); Gondolin uses custom Arch Linux images
- Matchlock has Go + Python SDKs; Gondolin is TypeScript only
- Matchlock uses Firecracker on Linux (stronger isolation narrative); Gondolin is QEMU everywhere (simpler parity story)
- Gondolin's JS-programmable network/filesystem is more flexible for hooks and custom behavior

### Cloud/Managed Platforms (Different Category)

| Platform | Isolation | Use Case | Pricing |
|----------|-----------|----------|---------|
| **E2B** | Firecracker | Cloud sandboxes, SaaS integration | Metered |
| **Daytona** | Docker/Kata/Sysbox | Fastest cold starts (27-90ms) | Metered |
| **Modal** | gVisor | ML/GPU workloads | Metered |
| **Northflank** | Kata/gVisor | Enterprise multi-tenant | Metered |
| **Sprites.dev** | Firecracker | Long-running dev environments | Metered |

These are a different category — cloud-hosted, metered pricing, multi-tenant. Gondolin's value prop is **local, self-hosted, zero cloud dependency**. They compete on different axes.

---

## Strengths

1. **Armin Ronacher's reputation** — Flask, Jinja, Rye, Sentry. One of the most respected open-source developers in the Python/web ecosystem. His projects tend to be well-designed and well-maintained.

2. **macOS first-class support** — Most agent sandbox tools are Linux-first. Gondolin choosing QEMU over Firecracker specifically for Mac parity is a pragmatic decision that matters for developer adoption. Most AI devs are on Apple Silicon Macs.

3. **JS-programmable everything** — The ethernet-stack-in-JavaScript approach is unusual and powerful. You can hook individual HTTP requests, inject custom headers, log traffic, implement custom DNS behavior — all from the same Node.js process. No separate proxy configuration. This is genuinely differentiated.

4. **Secret injection design** — Not just "secrets as env vars inside the VM" (which every tool does). The placeholder-substitution-at-network-boundary approach means the VM literally cannot exfiltrate the real credential — even to allowed hosts in unexpected ways. Thoughtworks called this out specifically.

5. **Rapid iteration** — 5 releases in 15 days. The project is clearly Armin's primary focus.

6. **Pi integration** — Built-in extension for the pi coding agent ecosystem.

---

## Weaknesses & Risks

1. **17 days old** — This is an experiment, not production software. The CHANGELOG shows rapid feature addition but no stability period. No production users.

2. **ARM64 only** — x86_64 support is not tested. This limits CI/cloud deployment scenarios where x86 is standard.

3. **TypeScript-only SDK** — The cloud platforms offer Python and Go SDKs. Many agent frameworks are Python-based. No Python SDK is a real adoption barrier for the broader agent ecosystem.

4. **VFS performance** — The README acknowledges FUSE-over-virtio-over-Node.js is "from a performance perspective very suboptimal." For heavy file I/O workloads, this matters.

5. **HTTP/1.x only network mediation** — No HTTP/2, no raw TCP passthrough, no UDP. WebSocket support was just added in 0.3.0. Non-HTTP protocols are limited.

6. **No formal security audit** — The security design doc is thoughtful but this hasn't been pen-tested. The MITM TLS approach has a known limitation: traffic to allowed hosts can still exfiltrate data.

7. **Small team risk** — Built by one person with AI assistance at an early-stage company. If Armin's attention shifts to other Earendil projects (Absurd has 959 stars), development could slow.

8. **No Docker image support** — You can't `gondolin run python:3.12 my_script.py`. You need to build custom guest images or use the default Arch Linux image. Matchlock's Docker image support is a significant UX advantage. (vmg's converter exists but it's external.)

---

## Verdict

Gondolin is an impressive 2-week-old experiment by a developer with an exceptional track record. The JS-programmable network stack and secret injection design are genuinely novel — not just "another sandbox CLI." The Thoughtworks endorsement this early is a strong signal.

**However:** It's pre-production software with no users, one language SDK, ARM64 only, and significant missing features. Matchlock is attacking the same niche with a more practical Docker-based approach and multi-language SDKs. The cloud platforms (E2B, Modal, Daytona) are more mature for production use cases.

**Watch if:** You're building TypeScript-based agent infrastructure on Apple Silicon and want maximum control over network policy and secret handling. The programmable network stack is worth the bet if you need custom HTTP hooks.

**Wait if:** You need Python SDKs, x86 support, Docker image compatibility, or production stability. Matchlock or E2B are safer bets today.

**Trend:** The agent sandbox space is exploding — 4+ new entries in February 2026 alone. Gondolin's differentiation (local + JS-programmable + secret injection) is real but narrow. The winner will likely be whoever gets Docker image support + multi-language SDKs + macOS support first. Gondolin has 2 of 3.

---

## Sources

1. [Gondolin GitHub](https://github.com/earendil-works/gondolin) — repo, README, CHANGELOG, docs
2. [Earendil GitHub org](https://github.com/earendil-works) — 551 stars, 39 forks
3. [Thoughtworks: "So, you want to run OpenClaw?"](https://www.thoughtworks.com/en-us/insights/blog/security/want-run-openclaw) (Feb 20, 2026)
4. [HN: Matchlock thread](https://news.ycombinator.com/item?id=46932343) (Feb 17, 2026) — Gondolin mentioned as alternative
5. [Armin Ronacher: "Colin and Earendil"](https://lucumr.pocoo.org/2026/1/27/earendil/) (Jan 27, 2026)
6. [npm: @earendil-works/gondolin](https://www.npmjs.com/package/@earendil-works/gondolin) — 1,157 downloads in first month
7. [Matchlock GitHub](https://github.com/jingkaihe/matchlock) — closest competitor
8. [Northflank: Agent Sandboxing Guide](https://northflank.com/blog/how-to-sandbox-ai-agents) — landscape context
9. [SoftwareSeni: E2B vs Daytona vs Modal vs Sprites](https://www.softwareseni.com/e2b-daytona-modal-and-sprites-dev-choosing-the-right-ai-agent-sandbox-platform/) — cloud platform comparisons
10. [LangChain: Two sandbox patterns](https://blog.langchain.com/the-two-patterns-by-which-agents-connect-sandboxes/) — architectural patterns
11. [awesome-pi-agent](https://github.com/qualisero/awesome-pi-agent) — ecosystem listing
12. [vietanh.dev: Agent Sandboxes Guide](https://www.vietanh.dev/blog/2026-02-02-agent-sandboxes) — landscape overview
