# Research: Spawning Subagents in Pi via tmux

**Date:** 2026-02-17
**Context:** Investigated whether tmux is a viable/elegant approach for spawning pi subagents, searched for ready-built extensions/skills.

---

## The Three Approaches Found

### 1. The Built-in Subagent Extension (process spawning — NOT tmux)

The official `examples/extensions/subagent/` uses **direct process spawning**:

```typescript
spawn("pi", ["--mode", "json", "-p", "--no-session", ...args], {
  cwd: cwd ?? defaultCwd,
  shell: false,
  stdio: ["ignore", "pipe", "pipe"]
});
```

This is pi's recommended programmatic approach. Key features:
- Captures structured JSON events (`message_end`, `tool_result_end`) from stdout in real-time
- Supports three modes: single, parallel (max 8 tasks, 4 concurrent), chain (sequential with `{previous}` placeholder)
- Isolated context window per subagent
- Usage tracking (turns, tokens, cost, context)
- Abort support (Ctrl+C propagates SIGTERM → SIGKILL)
- Agent definitions via markdown files with YAML frontmatter (name, description, tools, model, system prompt)
- Agent discovery from `~/.pi/agent/agents/` (user) and `.pi/agents/` (project)

**All popular community subagent packages use this same pattern — not tmux.**

Source: `/opt/homebrew/lib/node_modules/@mariozechner/pi-coding-agent/examples/extensions/subagent/`

### 2. `@normful/picadillo` "run-in-tmux" Skill (the only tmux-based package)

```bash
pi install https://github.com/normful/picadillo
```

This is the **only published package** that uses tmux — but it's **NOT for subagents**. It's for running persistent background processes (dev servers, watchers, etc.):

```bash
uv run scripts/run-in-tmux -c "npm run dev" -c "npm test" --json
```

Features:
- Creates tmux sessions with split panes (one command per pane)
- Session names: `<repo-slug>-<md5-hash>` pattern
- Returns JSON with peek commands (`tmux capture-pane -t session.N -p`), attach/kill commands
- Requires: Python 3.10+, tmux, git repo, `uv` runtime
- Dependencies: `typer`, `rich` (auto-installed via uv)

**It does NOT spawn pi instances as subagents.**

Source: `https://github.com/normful/picadillo` → `skills/run-in-tmux/`

### 3. The AGENTS.md Pattern (manual tmux for testing)

Pi's own `AGENTS.md` in the monorepo shows tmux for **testing the TUI**, not for subagents:

```bash
# Create tmux session with specific dimensions
tmux new-session -d -s pi-test -x 80 -y 24

# Start pi from source
tmux send-keys -t pi-test "cd /path/to/project && pi" Enter

# Wait for startup, then capture output
sleep 3 && tmux capture-pane -t pi-test -p

# Send input
tmux send-keys -t pi-test "your prompt here" Enter

# Send special keys
tmux send-keys -t pi-test Escape
tmux send-keys -t pi-test C-o  # ctrl+o

# Cleanup
tmux kill-session -t pi-test
```

Source: `AGENTS.md` in `https://github.com/badlogic/pi-mono`

---

## Critical Analysis: Is tmux Elegant for Subagents?

**No.** Here's the comparison:

| Concern                  | `spawn("pi", "--mode json")`                       | tmux approach                                         |
|--------------------------|-----------------------------------------------------|-------------------------------------------------------|
| **Structured output**    | ✅ JSON events stream over stdout                   | ❌ Must `capture-pane` — raw terminal text with ANSI  |
| **Streaming**            | ✅ Real-time event parsing                          | ❌ Polling via `tmux capture-pane`                    |
| **Abort/cleanup**        | ✅ `SIGTERM` → `SIGKILL` with timeouts              | ⚠️ Must manually `tmux kill-session`                  |
| **Parallel execution**   | ✅ Built-in concurrency limits                      | ⚠️ Manual session management                          |
| **Error handling**       | ✅ Exit codes, `stopReason`, structured errors       | ❌ Must parse terminal output                         |
| **Token/cost tracking**  | ✅ Usage stats in JSON events                       | ❌ Not available                                      |
| **Dependencies**         | ✅ None (just `pi` binary)                          | ❌ Requires tmux installed                            |

### When tmux DOES make sense:
- Running persistent background processes (dev servers, watchers)
- Interactive debugging where you need to manually attach
- Cases where you want a subagent running long-term and want to peek at it
- Human-observable multi-agent setups (multiple tmux panes, each with a pi instance)

### When tmux does NOT make sense:
- Programmatic subagent delegation with structured results
- Parallel task orchestration with concurrency control
- Chain workflows with output piping between agents
- Automated pipelines requiring error handling and usage tracking

---

## What Exists Ready-Built (from pi Package Gallery)

### Subagent Packages (all use `spawn("pi")`, not tmux)

| Package                    | Approach         | Downloads/mo |
|----------------------------|------------------|-------------|
| **`pi-subagents`**         | `spawn("pi")`   | 2,843       |
| **`pi-interactive-shell`** | TUI overlay      | 3,183       |
| **`pi-parallel-agents`**   | `spawn("pi")`   | 398         |
| **`pi-librarian`**         | `spawn("pi")`   | 1,046       |
| **`pi-finder-subagent`**   | `spawn("pi")`   | 1,031       |
| **`@vaayne/pi-subagent`**  | `spawn("pi")`   | 112         |
| **`@mjakl/pi-subagent`**   | `spawn("pi")`   | 0           |
| **`@hyperprior/pi-subagent`** | `spawn("pi")` | 0          |
| **`@e9n/pi-subagent`**     | `spawn("pi")`   | 0           |
| **`@tmustier/pi-agent-teams`** | `spawn("pi")` | 510       |
| Built-in `subagent/` example | `spawn("pi")` | (bundled)   |

### tmux-Related Packages

| Package                    | Use Case                        | Downloads/mo |
|----------------------------|---------------------------------|-------------|
| **`@normful/picadillo`**   | Background processes in tmux    | 771         |

### Background Process Packages (alternatives to tmux)

| Package                    | Approach                        | Downloads/mo |
|----------------------------|---------------------------------|-------------|
| **`@aliou/pi-processes`**  | Background process management   | 1,309       |
| **`@juanibiapina/pi-gob`** | Background job management       | 256         |
| **`holdpty`**              | Detached PTY (tmux alternative) | 100         |

---

## Pi README Philosophy

From `packages/coding-agent/README.md`:

> **No sub-agents.** There's many ways to do this. Spawn pi instances via tmux, or build your own with extensions, or install a package that does it your way.
>
> **No background bash.** Use tmux. Full observability, direct interaction.

The tmux mention is a **philosophical statement** ("we don't dictate, here are options"), not a recommended architecture. The community has unanimously chosen direct process spawning for subagents.

---

## Key Source Files Referenced

- Pi subagent example: `packages/coding-agent/examples/extensions/subagent/index.ts`
- Pi subagent agents: `packages/coding-agent/examples/extensions/subagent/agents.ts`
- Pi subagent README: `packages/coding-agent/examples/extensions/subagent/README.md`
- Pi SDK docs: `packages/coding-agent/docs/sdk.md`
- Pi RPC docs: `packages/coding-agent/docs/rpc.md`
- Pi extensions docs: `packages/coding-agent/docs/extensions.md`
- Pi packages docs: `packages/coding-agent/docs/packages.md`
- Picadillo run-in-tmux skill: `skills/run-in-tmux/SKILL.md`
- Picadillo run-in-tmux script: `skills/run-in-tmux/scripts/run-in-tmux`
- Pi AGENTS.md tmux testing pattern: `AGENTS.md` (root of pi-mono)

---

## Conclusion

For spawning pi subagents, the elegant and proven approach is `spawn("pi", ["--mode", "json", ...])` — not tmux. The built-in subagent extension example and every community package validate this. tmux remains useful for persistent background processes and manual multi-agent observation, but not for programmatic agent orchestration.
