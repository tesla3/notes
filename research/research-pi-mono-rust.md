# Pi-Mono vs. Rust AI Agent Alternatives: Security-Focused Research (Corrected)

*Last updated: February 19, 2026. This space moves weekly — treat specifics as perishable.*

---

## The Right Question First: What Are We Actually Defending Against?

Before comparing tools, we need a threat model. For AI coding agents, the primary threats are:

1. **Prompt injection** — LLM tricked into running malicious commands via bash/shell
2. **Data exfiltration** — agent sends SSH keys, API tokens, or source code to external servers
3. **Filesystem damage** — agent writes/deletes outside the intended workspace
4. **Supply chain attacks** — malicious npm/pip packages pulled by the agent or its extensions
5. **Lateral movement** — compromised agent pivots into other systems via network access

Critically, **none of these are prevented by the language the agent is written in.** They are all prevented by **sandboxing** — filesystem isolation, network isolation, and permission boundaries. A TypeScript agent inside bubblewrap is more secure than a Rust agent running with full system access.

This distinction — **language safety vs. execution environment safety** — shapes everything that follows.

---

## Pi-Mono Overview

**Repository:** [github.com/badlogic/pi-mono](https://github.com/badlogic/pi-mono)
**Author:** Mario Zechner (badlogic)
**Stars:** ~7,700 | **Forks:** ~770 | **Contributors:** 114 | **Commits:** 2,877
**Language:** TypeScript (96.5%) | **License:** MIT

Pi-mono is a monorepo AI agent toolkit with seven packages:

| Package | Purpose |
|---------|---------|
| `pi-ai` | Unified multi-provider LLM API (OpenAI, Anthropic, Google, etc.) |
| `pi-agent-core` | Agent runtime with tool calling and state management |
| `pi-coding-agent` | Interactive coding agent CLI |
| `pi-mom` | Slack bot delegating to the pi coding agent |
| `pi-tui` | Terminal UI library with differential rendering |
| `pi-web-ui` | Web components for AI chat interfaces |
| `pi-pods` | CLI for managing vLLM deployments on GPU pods |

### Design Philosophy

Pi-mono is deliberately minimal. From the README:

> "No permission popups. Run in a container, or build your own confirmation flow with extensions inline with your environment and security requirements."

And explicitly:

> "Security: Pi packages run with full system access. Extensions execute arbitrary code, and skills can instruct the model to perform any action including running executables. Review source code before installing third-party packages."

**This is a design choice, not an oversight.** Pi-mono decouples the agent from the sandbox — the same philosophy as `bash` itself. The shell doesn't sandbox you; the OS and deployment infrastructure do. The tradeoff is intentional: maximum flexibility and composability at the cost of requiring the operator to provide their own isolation layer.

### Where Pi-Mono Leads
- Mature, proven extension/package ecosystem (114 contributors, npm + git distribution)
- True multi-provider LLM support through a unified API
- Four operating modes (interactive, print/JSON, RPC, SDK embedding)
- Web UI components — rare in this category
- Active community (issue tracker reopens Feb 23, 2026 after vacation)

### Real Security Concerns
- **npm supply chain risk** — extensions install arbitrary code. This is the most concrete risk, independent of sandboxing.
- **No built-in guardrails** — a new user can accidentally grant the agent destructive permissions without any warning. "Run in a container" is only useful advice if you know to follow it.
- **No audit trail** — no built-in logging of what commands ran and what files changed.

---

## The Sandboxing Layer: Language-Agnostic Solutions

Before jumping to "rewrite in Rust," it's worth noting that **strong sandboxing is achievable today without changing pi-mono's language or codebase.** These solutions work with pi-mono as-is.

### Claude Code Sandbox Runtime (Open Source)

Anthropic open-sourced their sandbox runtime as an npm package. It uses:

- **macOS Seatbelt** for filesystem and process isolation
- **Linux bubblewrap** for namespace-based isolation
- Both **filesystem isolation** (write access scoped to working directory) and **network isolation** (traffic proxied through a controlled gateway)
- Anthropic reports a **84% reduction in permission prompts** internally
- All child processes inherit sandbox restrictions — no escapes via subprocess spawning

This directly demonstrates that TypeScript/Node.js agents can have kernel-level security. The sandbox wraps the bash tool, not the agent's language runtime.

### Docker Sandboxes for Coding Agents

Docker ships purpose-built sandbox templates for AI coding agents (Claude Code, Codex, Gemini, Kiro). These provide:

- **microVM-based isolation** — stronger than OS-level sandboxing alone
- Platform-agnostic (consistent behavior on macOS, Linux, Windows)
- Agents can run Docker *inside* the sandbox (nested container support)
- Snapshot/restore for instant recovery from filesystem damage
- Works with pi-mono today: `docker sandbox run` with pi configured as the agent

### Nono — Kernel-Enforced Sandbox CLI

**Repository:** [github.com/always-further/nono](https://github.com/always-further/nono)
**Language:** Rust core | **Maturity: Early (not yet in homebrew, requesting stars for approval)**

Nono wraps any CLI agent with kernel-enforced isolation:

- **Landlock** (Linux) + **Seatbelt** (macOS) for filesystem control
- **Supervised mode** — agent starts locked down; file access requests intercepted via seccomp user notification, routed to user for approval
- **Never-grantable paths** — SSH keys, system config blocked regardless of user approval
- **Undo snapshots** — every filesystem change gets a rollback point
- **Secure secret injection** — API keys loaded from system keystore, injected as env vars at runtime; keystore files never exposed to the sandboxed process
- **Tamper-resistant audit trail** — JSON session logs with cryptographic commitments
- Built-in profiles for claude-code, opencode, openclaw
- SDK bindings in Rust, Python, and TypeScript

```bash
# Wrapping pi-mono with nono
nono run --read ./src --write ./output -- pi
```

**Honest assessment:** Nono's design is genuinely innovative (especially supervised mode and secret injection), but it is early-stage software with a small community. Production use requires careful evaluation.

---

## Rust Alternatives: The Landscape

### Tier 1: Production-Grade, Large Community

#### OpenAI Codex (codex-rs)

**Repository:** [github.com/openai/codex/tree/main/codex-rs](https://github.com/openai/codex/tree/main/codex-rs)
**Stars:** ~60,000 (parent repo) | **Language:** Rust | **License:** Apache 2.0
**Backed by:** OpenAI engineering team

The Rust rewrite of Codex CLI with integrated sandbox:

- **Tiered sandbox modes:** `read-only` (default), `workspace-write`, `danger-full-access`
- **Linux:** `codex-linux-sandbox` binary combining Landlock + seccomp
- **macOS:** Seatbelt profiles; `.git` and `.codex` kept read-only even in write mode
- **Windows:** `WindowsRestrictedToken` with elevated setup
- **Network blocked by default** — outbound fully denied unless configured
- **MCP client + server** — extensible via Model Context Protocol
- **Config via TOML** — `sandbox_mode` persisted in `~/.codex/config.toml`

**Key limitation: OpenAI models only.** Codex-rs uses the OpenAI Responses API. If you chose pi-mono for multi-provider flexibility, Codex-rs doesn't solve the same problem. It wins on security but serves a different use case.

**Where the Rust language genuinely matters here:** The sandbox enforcement layer (`codex-linux-sandbox`) is security-critical code where memory bugs could compromise the entire isolation model. Writing this in Rust rather than C is a meaningful safety win. But the agent logic above the sandbox? The language matters far less.

#### Rig — Rust LLM Application Framework

**Repository:** [github.com/0xPlaygrounds/rig](https://github.com/0xPlaygrounds/rig)
**Stars:** ~4,300–6,000 (approaching 6k as of Feb 2026) | **Forks:** ~467–655
**License:** MIT | **Latest:** v0.31 (Feb 17, 2026)

**This is the closest Rust equivalent to pi-mono's `pi-ai` unified LLM layer,** and my original research undersold it. Rig provides:

- Unified API across OpenAI, Anthropic, Google, Cohere, Perplexity, and more
- Agent abstractions with tool calling and multi-turn streaming
- Built-in RAG support with multiple vector store backends
- Structured outputs (new in v0.31)
- Type-safe tool definitions via derive macros
- MCP tool integration
- Active ecosystem: used by VT Code, St. Jude, Dria, Nethermind, Coral Protocol, Listen, Cairnify, and others

Rig is a library, not a complete agent CLI. It replaces `pi-ai` and parts of `pi-agent-core`, but you'd need to build the TUI, extension system, and sandbox layer yourself (or compose with other tools).

**Honest assessment:** Rig is the most mature Rust LLM library with real production users. The "here be dragons" warning on breaking changes is worth taking seriously — APIs are still evolving. But the velocity and community suggest it will stabilize.

---

### Tier 2: Promising, Smaller Community

#### VT Code — Rust Coding Agent with Security

**Repository:** [github.com/vinhnx/vtcode](https://github.com/vinhnx/vtcode)
**Stars: 283** | **Forks: 25** | **Contributors: Largely single-author** | **Commits:** 2,705
**Language:** Rust | **License:** MIT

VT Code has impressive feature breadth for a young project:

- Multi-provider LLM support (uses Rig under the hood)
- OS-native sandboxing (Seatbelt + Landlock/seccomp)
- Tool policies (allow/deny/prompt per tool)
- Tree-sitter code intelligence for 6+ languages
- Agent Skills standard (open spec)
- ACP + A2A protocol support for inter-agent communication
- Lifecycle hooks for event-driven automation

**Critical caveat: This has 27x fewer stars than pi-mono and appears to be largely a solo project.** The feature list is ambitious, but community validation, bug discovery, and long-term maintenance are legitimate concerns. I would not recommend replacing a 7,700-star, 114-contributor ecosystem with a 283-star project without significant due diligence.

**Fair use case:** Worth watching as an example of what a security-first Rust coding agent looks like. Not yet a production replacement for pi-mono.

#### AutoAgents — WASM-Sandboxed Multi-Agent Framework

**Repository:** [github.com/liquidos-ai/AutoAgents](https://github.com/liquidos-ai/AutoAgents)
**Language:** Rust | **Maturity:** Active but smaller community

Notable for its **WASM sandboxed tool runtime** — a fundamentally different security approach. Instead of restricting the OS (Landlock/seccomp), AutoAgents runs untrusted tool code inside a WebAssembly sandbox. The tool can't access the filesystem or network at all unless the host explicitly provides capabilities.

Also offers:

- Pluggable LLM backends (OpenAI, local via Mistral-rs, LlamaCpp)
- ReAct executor with streaming
- Derive macros for type-safe tools
- OpenTelemetry integration
- Multi-agent orchestration with typed pub/sub

**Honest assessment:** The WASM sandbox idea is compelling for extension/plugin security (exactly where pi-mono's npm supply chain risk lives). But the project is smaller and less battle-tested than Rig or Codex-rs.

#### Other Notable Rust LLM Libraries

- **graniet/llm** — Unified multi-backend library (OpenAI, Anthropic, Ollama, DeepSeek, xAI, Groq, Google, Cohere, Mistral, HuggingFace, ElevenLabs). Builder pattern, multi-step chains, parallel evaluation. Maps to `pi-ai`.
- **llm-sdk** (hoangvvo) — Minimal unified LLM API in JS, Rust, and Go. Philosophy of "nothing hidden, no secret prompts."
- **Anda** — TEE-secured Rust agent framework on ICP blockchain. Hardware-backed security via Trusted Execution Environments. Strongest possible isolation, but with massive complexity overhead.

---

## Honest Comparison

### Maturity & Adoption

| Project | Stars | Contributors | Production Users | Maturity |
|---------|-------|-------------|-----------------|----------|
| OpenAI Codex | ~60,000 | OpenAI team + community | Massive | Production |
| Pi-mono | ~7,700 | 114 | Real (openclaw, etc.) | Production |
| Rig | ~4,300–6,000 | Growing | St. Jude, Dria, Nethermind, etc. | Active, breaking changes |
| VT Code | 283 | ~1 primary | Unknown | Early |
| Nono | Very small | Small team | Unknown | Early |
| AutoAgents | Small | Small | Unknown | Active, early |

### Security: What Actually Matters

| Threat | Pi-mono (bare) | Pi-mono + Docker Sandbox | Pi-mono + Nono | Codex-rs | VT Code |
|--------|:-:|:-:|:-:|:-:|:-:|
| Prompt injection → filesystem | Vulnerable | Contained | Contained | Contained | Contained |
| Data exfiltration via network | Vulnerable | Contained | Contained | Contained | Contained |
| Malicious extension code | Vulnerable | Contained | Partially contained | N/A (MCP) | Partially (policies) |
| Secret/key exposure | Vulnerable | Partially contained | Contained (keystore) | Partially | Partially |
| No audit trail of actions | Yes | Depends on config | Solved | Partial | Solved |

Notice: pi-mono + Docker Sandbox or pi-mono + nono addresses most of the same threats as a full Rust rewrite.

### Feature Parity

| Capability | Pi-mono | Codex-rs | Rig | VT Code |
|-----------|:---:|:---:|:---:|:---:|
| Multi-provider LLM API | ✅ | ❌ (OpenAI only) | ✅ | ✅ (via Rig) |
| Mature extension ecosystem | ✅ (npm/git) | MCP servers | Crate ecosystem | Agent Skills (early) |
| TUI library | ✅ | ✅ | ❌ (library only) | ✅ |
| Web UI components | ✅ | ❌ | ❌ | ❌ |
| Slack bot | ✅ | ❌ | ❌ | ❌ |
| vLLM pod management | ✅ | ❌ | ❌ | ❌ |
| RPC/SDK embedding mode | ✅ | Partial | ✅ (library) | Partial |

---

## Recommendations by Scenario

### "I use pi-mono today and want better security"

**Don't rewrite anything.** Use:
1. **Docker Sandboxes** — microVM isolation, works with pi today, platform-agnostic
2. **Nono** — if you want Landlock/Seatbelt without containers: `nono run --allow-cwd -- pi`
3. **Claude Code sandbox runtime** (npm package) — if you want to embed sandboxing into your own tooling

This preserves your existing extensions, skills, workflows, and community.

### "I'm building a new agent from scratch, security is paramount"

If locked to OpenAI: **Codex-rs** — production-proven, massive community, integrated sandbox.

If multi-provider is required: **Rig** (LLM layer) + **nono** (sandbox layer) + custom agent logic in Rust. More work than pi-mono, but gives you type safety and kernel-level isolation.

### "I need the best unified multi-provider LLM API in Rust"

**Rig.** It's the most mature option with real production users and an active release cadence. Accept that it's still evolving (v0.31, breaking changes expected).

### "I want the easiest path to secure agentic coding right now"

**Claude Code with sandboxing enabled.** One command to set up, open-sourced sandbox runtime, both filesystem and network isolation, works today. Not Rust-specific, but directly relevant to the stated goal of "best security."

### "I want to evaluate Rust coding agents for future adoption"

Watch **VT Code** and **Codex-rs**, but be honest about where they are. VT Code is early with a small community. Codex-rs is mature but OpenAI-locked. Neither is a drop-in replacement for pi-mono's multi-provider, extension-rich ecosystem today.

---

## Key Insight

The original version of this research pushed a "rewrite in Rust for security" narrative. That narrative doesn't survive scrutiny.

**Sandboxing is the security primitive that matters, and it is language-agnostic.** The kernel doesn't care if the process it's restricting was compiled from Rust, TypeScript, or COBOL. What matters is whether filesystem access is scoped, network egress is controlled, and destructive commands are blocked before execution.

Rust does genuinely help for **the sandbox enforcement layer itself** (where memory bugs in the sandbox could compromise everything) and for **building new, performance-critical agent infrastructure.** But for an existing, mature ecosystem like pi-mono, the pragmatic path to security is adding a sandbox wrapper, not rewriting 96.5% TypeScript into Rust.

---

*This research has a shelf life measured in weeks. Pi-mono's issue tracker reopens Feb 23, 2026. Rig is shipping breaking changes. Nono is pre-homebrew. Verify current status before making decisions.*
