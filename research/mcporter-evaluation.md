# MCPorter Evaluation

**Repo:** [github.com/steipete/mcporter](https://github.com/steipete/mcporter)
**Author:** Peter Steinberger (steipete)
**Version:** 0.7.4 | **License:** MIT | **Language:** TypeScript
**Date reviewed:** 2026-02-26

## What It Is

TypeScript runtime, CLI, and code-generation toolkit for the Model Context Protocol (MCP). Lets you discover, call, and compose MCP servers from the terminal or TypeScript code, and can generate standalone CLI tools from any MCP server definition.

## Codebase Stats

- **Source:** ~15k LoC across 28 files in `src/` + 37 CLI files + submodules
- **Tests:** ~11k LoC across 80+ test files (Vitest)
- **Dependencies:** `@modelcontextprotocol/sdk`, `commander`, `zod`, `rolldown`, `acorn`, `jsonc-parser`, `ora`, `es-toolkit`, `@iarna/toml`
- **CI:** GitHub Actions on Ubuntu, macOS, Windows

## Architecture

| Layer | Purpose |
|---|---|
| `src/runtime.ts` | Connection-pooled MCP runtime, lazy client init, OAuth, timeouts |
| `src/server-proxy.ts` | Proxy-based ergonomic wrapper — camelCase→kebab-case, positional args, schema defaults, validation |
| `src/config.ts` + `src/config/` | Layered config (home → project), imports from Cursor/Claude/Codex/Windsurf/VS Code/OpenCode |
| `src/cli/` (~4.8k LoC) | `list`, `call`, `auth`, `generate-cli`, `emit-ts`, `config`, `inspect-cli`, `daemon` |
| `src/daemon/` (~1.2k LoC) | Unix-socket daemon for keep-alive MCP servers (e.g., Chrome DevTools) |
| `src/generate-cli.ts` + `src/cli/generate/` | Turns MCP server into standalone CLI; Rolldown/Bun bundling, Bun compilation |
| `src/result-utils.ts` | `CallResult` wrapper with `.text()`, `.markdown()`, `.json()`, `.content()` |
| `src/error-classifier.ts` | Classifies errors into auth/offline/http/stdio-exit/other |

## Key Features

- **Zero-config discovery** — merges home config, project config, and 7+ editor imports
- **CLI generation** — `mcporter generate-cli` produces standalone CLI from any MCP server
- **Typed client generation** — `mcporter emit-ts` emits `.d.ts` interfaces or client wrappers
- **Server proxy** — camelCase methods, auto defaults, schema validation, `CallResult` helpers
- **OAuth + stdio ergonomics** — caching, log tailing, stdio wrappers, multiple transports
- **Ad-hoc connections** — point at any MCP endpoint without config; `--persist` to save
- **Keep-alive daemon** — for stateful servers like chrome-devtools, mobile-mcp
- **Auto-correct** — typo correction for tool names with edit-distance matching

## Strengths

1. **Well-structured modular design.** Clean separation of concerns across runtime, CLI, config, daemon, codegen
2. **Comprehensive test suite.** 80+ files with unit, integration (real HTTP MCP fixtures), CLI, config, daemon tests
3. **Thoughtful API design.** `createRuntime()` → `createServerProxy()` chain is ergonomic and well-considered
4. **Zero-config discovery.** 7+ editor config auto-imports with proper layering and deduplication
5. **Robust error handling.** Distinct classification of auth, network, HTTP, stdio errors; connection reset on transport failure
6. **Cross-platform CI.** Ubuntu + macOS + Windows
7. **Active development.** 20+ releases, community PRs being merged, thorough changelogs
8. **Rich CLI UX.** TypeScript-style `list` output, function-call syntax, auto-correction, colorized output, JSON mode

## Weaknesses

1. **Heavy `unknown` usage.** `result-utils.ts` and `server-proxy.ts` rely on manual typeof/in narrowing extensively
2. **Complex proxy magic.** 300-line Proxy `get` trap handling positional args, named args, options, schema caching, aliases — hard to debug
3. **Large files.** `cli.ts` mixes routing + help + auth. Proxy handler is one dense function
4. **Schema cache complexity.** Disk-based cache with async hydration + background refresh + dedup is non-trivial to reason about
5. **Force-exit workaround.** `setImmediate(() => process.exit(0))` to work around lingering Node.js stdio handles
6. **Documentation scattered.** 27 docs files, no architecture overview. README is ~26KB

## Verdict

**B+/A-** — Professional-quality, feature-rich MCP toolkit. Most complete solution in its category. Main risks are complexity in proxy/schema-cache layer and heavy TS/Node runtime dependency. Fills an important gap in the MCP ecosystem.
