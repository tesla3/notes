← [Index](../README.md)

# MCP-to-CLI Repo Evaluation

**Source:** [HN thread distillation](hn-mcp-cheaper-via-cli.md) — five projects that convert MCP servers into CLI-callable tools.
**Date:** 2026-02-25

## Summary Table

| Repo | Language | Stars | Age | Contributors | Status |
|-------|----------|-------|-----|--------------|--------|
| [mcporter](https://github.com/steipete/mcporter) | TypeScript | 2,153 | 4 months | 5+ | Mature, active |
| [mcp-cli](https://github.com/chrishayuk/mcp-cli) | Python | 1,893 | 15 months | 5+ | Mature, feature-heavy |
| [CLIHub](https://github.com/thellimist/clihub) | Go | 135 | 2 days | 1 | Fresh launch, solo |
| [mcpshim](https://github.com/mcpshim/mcpshim) | Go | 27 | 2 days | 1 | Fresh launch, solo |
| [cmcp](https://github.com/assimelha/cmcp) | Rust | 14 | 4 days | 1 | Fresh launch, solo |

## Evaluations

### 1. mcporter — The ecosystem anchor

**What it is:** TypeScript runtime + CLI + codegen toolkit. Discovers MCP servers from your existing Cursor/Claude/Codex/VS Code configs, exposes tools as typed camelCase methods, and can generate standalone CLIs from any MCP server.

**Strengths:**
- Most mature project by far. 4 months old, 5+ contributors, 154 forks, 52 open issues (sign of active use, not neglect).
- Zero-config discovery — merges configs from every major AI editor automatically.
- Ad-hoc connections without config: point at any HTTP or stdio MCP endpoint.
- OAuth handled well, including auto-detection of hosted MCPs (Supabase, Vercel) that need browser login.
- TypeScript type generation (`emit-ts`) gives agents strong typing without hand-writing plumbing.
- Spawned a downstream ecosystem: `mcp2cli-plugin` and `mcp-to-pi-tools` both build on mcporter.

**Weaknesses:**
- Feature sprawl. 52 open issues, complex flag surface. Docs spread across multiple files.
- Last commit was Jan 7 — nearly 7 weeks stale. Unclear if this is a pause or a plateau.
- Node.js/Bun dependency for generated CLIs (not truly standalone binaries).
- The "function-call style" syntax (`mcporter call 'linear.create_comment(issueId: "ENG-123")'`) is fragile in shell contexts — exactly the problem mcp2cli was created to solve.

**Verdict:** The default choice if you're already in the TypeScript/Node ecosystem. Most battle-tested, broadest compatibility. The 7-week commit gap is the main risk signal.

---

### 2. mcp-cli — The kitchen sink

**What it is:** Full-featured Python CLI for interacting with MCP servers. Not just a converter — it's an entire interactive client with chat mode, session management, tool execution, and now "AI Virtual Memory."

**Strengths:**
- Most feature-rich by a mile: chat mode, interactive mode, command mode, session persistence, token tracking, health monitoring.
- IBM-backed (repo moved to IBM org). 297 forks, 5+ contributors, active development (commits from today).
- 3,200+ tests, 15 documented architecture principles. This is real engineering.
- Connection pooling with lazy-spawn daemon — warm connections with 60s idle timeout.
- The AI Virtual Memory system (v0.16) is genuinely novel: OS-style paging for conversation context.

**Weaknesses:**
- **Scope mismatch.** This is an MCP *client*, not an MCP-to-CLI *converter*. It doesn't generate standalone CLI tools — it *is* the CLI. Your agent has to learn `mcp-cli call <server> <tool> <json>` syntax rather than getting native-feeling commands.
- Heavyweight. Python + multiple dependencies + Ollama default config. The opposite of "lightweight CLI tool."
- The Virtual Memory feature is cool research but adds complexity for the core use case.
- Tool-call JSON still goes through `mcp-cli call` — no lazy discovery via `--help` per tool.
- Default Ollama config is odd for a tool that's pitched as agent infrastructure.

**Verdict:** Wrong category. This is a power-user MCP client, not a CLI converter. If you want to interactively explore MCP servers or build Python-based agent workflows, it's excellent. For the "give my agent CLI tools" use case from the HN thread, it misses the point. The agent still has to understand MCP semantics — it just calls them through a different interface.

---

### 3. CLIHub — The purist's answer

**What it is:** Go tool that connects to an MCP server, discovers all tools, generates a Go CLI with one subcommand per tool, and compiles to a static binary. Zero runtime dependencies.

**Strengths:**
- **Static binaries.** This is the killer feature. 6.5MB, no runtime, no Node, no Python. Cross-compile to linux/amd64, darwin/arm64, windows/amd64. This is what "CLI tool" actually means.
- Clean mental model: one MCP server → one binary → one subcommand per tool with flags from JSON Schema.
- Comprehensive auth support (OAuth, bearer, API key, basic, S2S, Google service account).
- Tool filtering (`--include-tools`, `--exclude-tools`) — only generate what you need.
- The blog post that spawned the HN thread is well-argued.

**Weaknesses:**
- 2 days old, solo developer, 135 stars (HN launch bump). No track record.
- Requires Go 1.21+ installed to generate CLIs (it runs `go build` under the hood). The *output* is dependency-free, but the *generator* isn't.
- No daemon / connection pooling. Each CLI invocation presumably re-authenticates or reads credentials from disk.
- Haven't tested with poorly-behaved MCP servers that return unexpected schemas. The HN thread's own "What the Thread Misses" section flags this risk.
- Single contributor, all recent commits are docs/README polishing — the actual code hasn't been stress-tested in the wild.

**Verdict:** Best design for the stated goal. Static binaries with `--help` per subcommand is exactly what agents want. But it's 2 days old with one developer. Needs time to prove reliability. If you're willing to bet early, this is the most architecturally clean option.

---

### 4. mcpshim — The daemon approach

**What it is:** Go daemon + CLI pair. The daemon (`mcpshimd`) holds persistent connections to all MCP servers, handles auth and retries. The CLI (`mcpshim`) sends requests over a Unix socket.

**Strengths:**
- Daemon architecture solves the connection/auth problem properly. One process manages all MCP sessions, CLI calls are fast IPC.
- SQLite-backed call history — useful for debugging and auditing.
- Script generation (`mcpshim script --install`) creates alias wrappers so tools feel like native commands.
- Unix socket is agent-friendly — fast, no HTTP overhead, works with any language.
- Config-driven: YAML config is the source of truth, `mcpshim reload` for changes.

**Weaknesses:**
- 2 days old, solo developer, 27 stars. Even less proven than CLIHub.
- No license declared. Risky for any real use.
- The daemon model adds operational complexity: you have to start `mcpshimd`, manage its lifecycle, handle crashes.
- Tool calls still go through `mcpshim call --server s --tool t --arg value` — verbose compared to CLIHub's native subcommands.
- The companion project "Pantalk" mentioned in latest commit is unclear — scope creep signal this early is concerning.
- Only 36KB repo size — minimal code. Hard to tell if this is elegant or incomplete.

**Verdict:** Interesting architecture for multi-server setups where connection management matters. The daemon model is genuinely useful when you have 5+ MCP servers with different auth requirements. But it's the least proven of the five, missing a license, and the CLI ergonomics are weaker than CLIHub or mcporter.

---

### 5. cmcp — The Cloudflare Code Mode clone

**What it is:** Rust tool that aggregates all your MCP servers behind two tools: `search()` and `execute()`. The agent writes TypeScript to discover and call tools. Code runs in a QuickJS sandbox.

**Strengths:**
- **Fundamentally different approach.** Not MCP-to-CLI — it's MCP-to-code-execution. Two tools regardless of how many servers/tools you have. This scales where CLI-per-tool doesn't.
- Rust + QuickJS = fast, memory-safe sandbox (64MB limit). No Node/Python runtime needed at execution time.
- Auto-generated TypeScript declarations from JSON Schema — the agent gets typed APIs.
- Hot-reload: add servers without restarting your AI client.
- `cmcp import` pulls existing configs from Claude/Codex. Low friction to try.
- Composability is first-class: chain calls across multiple servers in a single `execute()`.

**Weaknesses:**
- 4 days old, solo developer, 14 stars. The least proven.
- Depends on the agent being good at writing TypeScript against generated type declarations. Frontier models handle this; smaller models may not.
- QuickJS sandbox is limited — no async I/O beyond the provided MCP call bridges, 64MB memory cap.
- The "search then execute" two-step adds latency vs. directly calling a CLI tool.
- Unclear error handling when MCP servers return unexpected results inside the sandbox.
- The approach only works when the agent client supports tool-use — doesn't help with plain shell scripting or non-AI automation.

**Verdict:** The most intellectually ambitious of the five, directly implementing the Cloudflare Code Mode pattern. If Cloudflare's thesis is right — that agents should write code, not call tools — cmcp is the open-source version of that future. But it's a bet on a specific model capability (code generation quality) that makes it less universal than CLI approaches. Worth watching, not yet worth depending on.

---

## Overall Assessment

The five repos split into three categories:

1. **Mature ecosystem tools** (mcporter, mcp-cli): Real users, real contributors, real bugs. mcporter is the practical choice today. mcp-cli is miscategorized — it's a client, not a converter.

2. **Fresh CLI converters** (CLIHub, mcpshim): Both 2 days old, both Go, both solo developers. CLIHub has the cleaner design (static binaries); mcpshim has the better architecture for multi-server setups (daemon + socket). Neither is proven.

3. **Code Mode** (cmcp): Different paradigm entirely. Not competing with the others — it's betting that the whole "tool catalog" model is a dead end and agents should just write code. Highest ceiling, highest risk.

**For pi/agent use specifically:** CLIHub's static-binary approach aligns best with pi's philosophy (no runtime dependencies, one tool = one command, `--help` for discovery). mcporter is the safe bet if you want something that works today. cmcp is the one to watch if you believe agents will increasingly prefer code execution over tool calling.

**The HN thread's insight holds up:** MCP is converging toward being a catalog/registry standard, not a runtime protocol. All five projects validate this — they all consume MCP as input and produce something else as the execution surface.
