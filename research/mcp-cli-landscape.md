# MCP CLI Tool Landscape

**Source:** HN thread [item?id=47157398](https://news.ycombinator.com/item?id=47157398) — "Making MCP cheaper via CLI"
**Score:** 309 points, 117 comments | **Date:** 2026-02-25
**Article:** [kanyilmaz.me/2026/02/23/cli-vs-mcp.html](https://kanyilmaz.me/2026/02/23/cli-vs-mcp.html)
**Date compiled:** 2026-02-26

---

## The Core Thesis

MCP tools are sent on every request, bloating context windows (potentially thousands of tokens of tool descriptions before the model starts thinking). CLI tools sidestep this — the agent only needs to know the tool exists and what flags it takes. Output is piped and processed, not dumped wholesale into context. Composability comes free via pipes (`jq`, `grep`, `head`).

**Where MCP still wins:** OAuth/auth dance for consumer-facing products, dynamic client registration, running inside ChatGPT/Claude where you can't provide a CLI.

---

## Similar Repos to MCPorter

### Tier 1: Direct Competitors (MCP → CLI)

#### CLIHub
- **Repo:** [github.com/thellimist/clihub](https://github.com/thellimist/clihub)
- **Author:** thellimist (the article's author)
- **Language:** Go
- **Approach:** Compiles MCP servers into self-contained static binaries (~6.5MB)
- **Auth:** OAuth2 w/ PKCE, S2S, Google SA, API key, basic, bearer (extensible)
- **Key differentiator:** Zero runtime dependencies, cross-compilation built-in
- **No:** daemon, SDK, config discovery
- **Install:** `go install github.com/thellimist/clihub@latest`
- **vs MCPorter:** CLIHub = compiler (lighter output). MCPorter = full toolkit (more features, heavier)

#### mcp-cli
- **Repo:** [github.com/philschmid/mcp-cli](https://github.com/philschmid/mcp-cli)
- **Author:** Phil Schmid (Hugging Face)
- **Language:** TypeScript/Bun
- **Approach:** Lightweight CLI client for MCP servers. Shell-friendly JSON output
- **Features:** Connection pooling daemon (60s idle), tool filtering, stdio + HTTP, compiles to standalone via `bun build --compile`
- **Install:** `curl -fsSL .../install.sh | bash` or `bun install -g`
- **vs MCPorter:** Much smaller scope — no code generation, no typed clients, no config auto-discovery. Simpler to start with

#### mcp-cli-ent
- **Repo:** [github.com/EstebanForge/mcp-cli-ent](https://github.com/EstebanForge/mcp-cli-ent)
- **Author:** EstebanForge
- **Language:** Go (13 stars)
- **Approach:** "Context-guardian" — returns **clean, structured summaries** instead of raw MCP responses
- **Key differentiator:** Specifically prevents context window overflow by summarizing
- **vs MCPorter:** Narrower focus on output summarization

### Tier 2: MCP Proxy / Bridge Architecture

#### mcpshim
- **Repo:** [github.com/mcpshim/mcpshim](https://github.com/mcpshim/mcpshim)
- **Website:** [mcpshim.dev](https://mcpshim.dev)
- **Author:** _pdp_
- **Language:** Go
- **Approach:** Local Unix socket daemon + CLI bridge. Centralizes MCP sessions, auth, discovery, tool execution
- **Key differentiator:** **SQLite-backed call history** — agents can query what they did previously
- **Architecture:** `mcpshimd` (daemon) handles lifecycle; `mcpshim` (CLI) talks over Unix socket
- **Install:** `go install github.com/mcpshim/mcpshim/cmd/mcpshim{d,}@latest`
- **vs MCPorter:** mcpshim = runtime bridge/proxy (persistent, has history). MCPorter = toolkit (codegen, SDK, discovery)

#### CMCP (Code Mode MCP)
- **Repo:** [github.com/assimelha/cmcp](https://github.com/assimelha/cmcp)
- **Author:** assimelha
- **Language:** Rust
- **Approach:** Aggregates all MCP servers behind just **2 tools**: `search()` and `execute()`
- **Key differentiator:** Agent writes TypeScript to discover/call tools. Runs in sandboxed QuickJS (64MB limit). **99% fewer tool definitions** in context
- **Inspired by:** [Cloudflare Code Mode MCP](https://blog.cloudflare.com/code-mode-mcp/)
- **Features:** Hot-reload (add servers without restarting), composable, type-safe, sandboxed
- **Install:** `cargo install --path .` then `cmcp add <name> <url>`
- **vs MCPorter:** Most architecturally novel. Radical context reduction but requires Rust toolchain

#### pi-mcp-adapter
- **Repo:** [github.com/nicobailon/pi-mcp-adapter](https://github.com/nicobailon/pi-mcp-adapter)
- **Author:** nicobailon
- **Language:** TypeScript
- **Approach:** Token-efficient MCP adapter specifically for the Pi coding agent
- **Key differentiator:** One proxy tool (~200 tokens) replaces hundreds. Lazy server startup. Schema caching
- **Install:** `pi install npm:pi-mcp-adapter`
- **vs MCPorter:** Pi-specific. Minimal overhead but not general-purpose

### Tier 3: Agent-First CLI Tools (Complementary, Not Competitors)

#### mini-browser
- **Repo:** [github.com/runablehq/mini-browser](https://github.com/runablehq/mini-browser)
- **Author:** runablehq (cmdtab in thread)
- **Language:** TypeScript
- **Approach:** Browser CLI where each command is a Unix tool (`go`, `snap`, `click`, `type`, `fill`, `js`)
- **Key insight from thread:** "Frontier models use it much better than explicit MCP browser tools because they can compose command sequences to one-shot tasks"
- **Install:** `npm install -g @runablehq/mini-browser`
- **Commands:** `mb go <url>`, `mb snap`, `mb click <x> <y>`, `mb type <text>`, `mb js <code>`, etc.

#### playwright-cli
- **Repo:** [github.com/microsoft/playwright-cli](https://github.com/microsoft/playwright-cli)
- **By:** Microsoft
- **Comparison article:** [testcollab.com/blog/playwright-cli](https://testcollab.com/blog/playwright-cli)
- **Context:** CLI alternative to Playwright MCP with significant token savings

---

## Comparison Matrix

| Repo | Lang | Approach | Auth | Daemon | Codegen | Composability |
|---|---|---|---|---|---|---|
| **MCPorter** | TS | Full toolkit (CLI+SDK+codegen) | OAuth+basic | ✅ | ✅ (CLI+types) | Via proxy API |
| **CLIHub** | Go | MCP→static binary compiler | OAuth2/PKCE+5 | ❌ | ✅ (binary) | Unix pipes |
| **mcp-cli** | Bun | Lightweight CLI client | Config | ✅ (pool) | ❌ | JSON+pipes |
| **mcpshim** | Go | Unix socket proxy/bridge | Centralized | ✅ (core) | ❌ | Socket+CLI |
| **CMCP** | Rust | 2-tool proxy (search+exec) | Passthrough | ❌ | ❌ | TypeScript code |
| **mcp-cli-ent** | Go | Context-guardian CLI | Config | ❌ | ❌ | Summarized output |
| **pi-mcp-adapter** | TS | Lazy proxy for Pi agent | Config | ❌ | ❌ | Pi skill system |
| **mini-browser** | TS | Agent-first browser CLI | N/A | ❌ | ❌ | Unix pipes |

---

## Key Thread Insights

### MCP's real value is narrow
- **Auth handshake** for third-party SaaS (OAuth, dynamic client registration)
- **Running inside ChatGPT/Claude** where you can't provide a CLI
- **Bundled operations** for LLM-friendly interfaces (fewer round-trips)
- Thread commenter: "If someone just extracted the OAuth layer into a standard that CLIs could use, there's very little reason for the rest of the protocol to exist"

### CLI advantages are structural
- Models are **already RL-trained** on shell commands; MCP is learned from scratch
- CLI output is **pipeable** — `jq`, `grep`, `head` give composability for free
- **KV cache friendly** — `--help` appends only, vs changing tool definitions invalidating cache
- Permission boundaries are clearer (whitelist commands, flags, working dir)
- Audit logs come naturally (CLI trail is replayable)

### The real cost isn't tool definitions
- Commenter OsrsNeedsf2P: "The real killer is the **input tokens on each step**. If you have 100k tokens in conversation and the LLM calls an MCP tool, the output AND existing conversation is sent back"
- 10 tool calls per message → 1-5M input tokens, not from MCP defs but from conversation replay
- Cache hit rates can be as low as 40%
- Biggest savings come from **batching/parallelizing** tool calls

### Skills vs MCP vs CLI
- **Skills** = progressive disclosure (lightweight descriptions upfront, full defs on demand)
- **CLI** = models already know how to use, pipeable, composable
- **MCP** = structured, provider-maintained, handles auth, works in closed platforms
- Several commenters converge on: **Skills + CLI is the sweet spot for developer workflows**

### Counterpoint: MCP can work well
- brookst: Has 120-function MCP with 500k tokens of docs — hierarchical, with `--help` params, agent-friendly hints. "A good MCP tool is hierarchical... bad implementations, not intrinsic to the interface"
- ianm218: Got "dramatically better performance" for multi-step data pipeline workflows with MCP vs CLI — structured I/O eliminates shell-string-parsing impedance mismatch
- Anthropic's Tool Search already solves the bloat problem for Claude Code users

### Emerging pattern: MCP gateways
- jFriedensreich: "No one should still consider connecting MCPs directly to agents... you connect MCPs and tools to a single gateway that has an API, handles federation, auditing, policies"
- CMCP's 2-tool approach is an implementation of this pattern

---

## Related Resources

- [Anthropic: Advanced Tool Use](https://www.anthropic.com/engineering/advanced-tool-use)
- [Cloudflare: Code Mode MCP](https://blog.cloudflare.com/code-mode-mcp/)
- [Agent Skills Specification](https://agentskills.io/specification#progressive-disclosure)
- [Simon Willison: The Lethal Trifecta](https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/) (security concern: env vars + LLM control)
- [Playwright CLI vs MCP comparison](https://testcollab.com/blog/playwright-cli)
- [CLI tools beating MCP for AI agents](https://jannikreinhard.com/2026/02/22/why-cli-tools-are-beating-mcp-for-ai-agents/)
