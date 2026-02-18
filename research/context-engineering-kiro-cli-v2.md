← [Coding Agents](../topics/coding-agents.md) · [Index](../README.md)

# Context Engineering for Kiro CLI

*February 2026 · Verified against official Kiro CLI docs and changelog through v1.24 (Jan 16, 2026)*

---

Kiro CLI is AWS's terminal-based coding agent. Like Claude Code, it offers configurable context that shapes what the agent sees. This article maps Kiro CLI's context features using the same framework as [Birgitta Böckeler's context engineering primer](https://martinfowler.com/articles/exploring-gen-ai/context-engineering-coding-agents.html): what the features are, who triggers them, and when they load.

> **Important:** Kiro has both an IDE and a CLI. Their feature sets differ. This article covers **CLI only**. Where IDE-only features exist, they're called out explicitly.

---

## Core concepts

Context in a coding agent = everything the model sees. Two types of reusable prompts:

- **Guidance** — General conventions. "Use TypeScript strict mode."
- **Instructions** — Task-specific directives. "Write E2E tests using Playwright."

Beyond prompts, the agent needs **context interfaces** to discover more information:

- **Built-in tools** — File read/write, shell, grep, glob, code intelligence (LSP), web search/fetch
- **MCP Servers** — External programs exposing structured tools and data via the Model Context Protocol
- **Knowledge Bases** — Semantically indexed docs the agent can search without consuming the full context window
- **Skills** — Large doc sets where only metadata loads at startup; full content loads on-demand

### Who decides to load context?

| Decision maker | Trade-off |
|---|---|
| **LLM** | Enables unsupervised work. Non-deterministic. |
| **Human** | Full control. Less automation. |
| **Kiro CLI software** | Deterministic. Fires at lifecycle events. |

### Keeping context small

More context ≠ better results. Kiro CLI provides:

- `/context show` — What's loaded and why
- `/usage` — Context window consumption estimate
- `/compact` — Summarize conversation history to free space
- Auto-compaction when the window overflows

Build context incrementally. Add steering files only when the agent consistently gets something wrong.

---

## Feature reference

### Steering Files

**What:** Guidance — persistent project knowledge in markdown.

**Who loads:** Kiro CLI — automatically at session start.

**Where:**
- Workspace: `.kiro/steering/*.md` (project-specific)
- Global: `~/.kiro/steering/*.md` (all projects)
- Workspace takes precedence over global on conflict.

**Foundation files** (auto-generated):
- `product.md` — Product purpose, users, business objectives
- `tech.md` — Frameworks, libraries, constraints
- `structure.md` — File organization, naming, architecture

**⚠️ Critical CLI-specific behavior:** When using custom agents, steering files are **not** automatically included. You must explicitly add them to the agent's `resources`:

```json
{ "resources": ["file://.kiro/steering/**/*.md"] }
```

**AGENTS.md:** Kiro also supports the cross-tool `AGENTS.md` standard. Always included. Place in workspace root or `~/.kiro/steering/`.

**Best practices:** One domain per file. Explain the *why*, not just the *what*. Include code examples. Never commit secrets.

**⚠️ IDE vs CLI difference:** The IDE supports four inclusion modes (`always`, `fileMatch`, `manual`, `auto`) and file references (`#[[file:...]]`). **The CLI does not.** All CLI steering files load automatically.

**Claude Code equivalent:** `CLAUDE.md` + path-scoped Rules.

---

### Custom Agents

**What:** Instructions + tool permissions + model selection + resource scoping, bundled as a JSON config.

**Who loads:** Human — via `kiro chat --agent <name>` or `/agent swap <name>`.

**Where:**
- Local: `.kiro/agents/*.json` (workspace)
- Global: `~/.kiro/agents/*.json` (everywhere)
- Local takes precedence on name conflicts.

**What they configure:**

```json
{
  "name": "backend-specialist",
  "description": "Node.js API layer expert",
  "prompt": "You are a backend specialist...",
  "model": "claude-sonnet-4",
  "tools": ["read", "write", "shell", "use_subagent"],
  "allowedTools": ["read", "shell"],
  "toolsSettings": {
    "write": { "allowedPaths": ["src/api/**"] },
    "shell": { "deniedCommands": ["git push.*"] }
  },
  "resources": [
    "file://README.md",
    "file://.kiro/steering/**/*.md",
    "skill://.kiro/skills/**/SKILL.md",
    {
      "type": "knowledgeBase",
      "source": "file://./docs",
      "name": "APIDocs",
      "indexType": "best",
      "autoUpdate": true
    }
  ],
  "mcpServers": { "git": { "command": "git-mcp-server" } },
  "hooks": {
    "agentSpawn": [{ "command": "git branch --show-current" }],
    "postToolUse": [{ "matcher": "fs_write", "command": "prettier --write" }]
  }
}
```

**Key capabilities:**
- Pre-approved tools — skip permission prompts for trusted tools
- File path restrictions — prevent cross-domain accidents
- Per-agent model selection
- Per-agent MCP servers, hooks, resources, knowledge bases
- Keyboard shortcuts for quick-switching

**When to use:** When different workflows need different tool sets, permissions, or models. A reviewer shouldn't have write access. A frontend agent doesn't need database MCP.

**Claude Code equivalent:** Subagents (but broader — Claude Code subagents don't configure tools/permissions at this granularity).

---

### Hooks

**What:** Shell scripts fired deterministically at lifecycle events. No LLM involvement.

**Who loads:** Kiro CLI software.

| Hook | Fires when | STDIN receives |
|---|---|---|
| `agentSpawn` | Agent activates | `{ cwd }` |
| `userPromptSubmit` | User sends prompt | `{ cwd, prompt }` |
| `preToolUse` | Before tool runs | `{ cwd, tool_name, tool_input }` |
| `postToolUse` | After tool runs | `{ cwd, tool_name, tool_input, tool_response }` |
| `stop` | Agent finishes | `{ cwd }` |

**Exit codes:** `0` = success. `2` = block tool (preToolUse only). Other = warning.

**Matcher:** Target specific tools in `preToolUse`/`postToolUse`:
```json
{ "matcher": "fs_write", "command": "cargo fmt --all", "timeout_ms": 10000 }
```

Matchers use internal tool names (`fs_read`, `fs_write`, `execute_bash`) and support MCP namespaces (`@postgres/query`).

**Use cases:** Auto-format on write. Audit-log bash commands. Block writes to protected paths. Run tests on agent stop.

**Why hooks matter:** They're the only context feature that's truly deterministic — the LLM can't decide to skip them.

**Claude Code equivalent:** Hooks (very similar lifecycle events).

---

### MCP Servers

**What:** External programs exposing tools/data via the Model Context Protocol.

**Who loads:** LLM decides when to call specific tools.

**Where configured:**
- Global: `~/.kiro/settings/mcp.json`
- Workspace: `.kiro/settings/mcp.json`
- Per-agent: in agent JSON under `mcpServers`

Works identically in Kiro IDE and CLI. Configure once, use both.

**Claude Code equivalent:** MCP Servers (same protocol).

---

### Knowledge Bases

**What:** Semantically indexed documentation. Agent searches the index; only relevant chunks enter the context window.

**Who loads:** LLM — searches when it judges documentation is relevant.

**Setup via slash command:**
```
/knowledge add --name "project-docs" --path ./docs --index-type Best
```

**Setup via agent config:**
```json
{
  "type": "knowledgeBase",
  "source": "file://./docs",
  "name": "ProjectDocs",
  "indexType": "best",
  "autoUpdate": true
}
```

**Properties:**
- Supports millions of tokens of indexed content
- Per-agent isolation — each agent has its own knowledge base
- `autoUpdate: true` re-indexes on agent spawn
- Supports code files, markdown, PDFs
- **Experimental** — must enable: `kiro-cli settings chat.enableKnowledge true`

**When to use:** Large doc sets, API specs, ADRs — anything too big for steering files.

**Claude Code equivalent:** No direct equivalent. Closest is Skills loading docs on demand.

---

### Skills

**What:** Resource type for progressive context loading. Only name + description load at startup. Full content loads when the agent deems it relevant.

**Who loads:** LLM (based on description match).

**Added:** CLI v1.24 (Jan 16, 2026).

**Skill file format** — markdown with YAML frontmatter:
```yaml
---
name: react-patterns
description: React component patterns, hooks usage, and state management conventions
---
# React Patterns
...
```

**Loaded via agent config:**
```json
{ "resources": ["skill://.kiro/skills/**/SKILL.md"] }
```

**When to use:** When you have domain-specific documentation that's needed only for certain tasks. Write specific descriptions so the agent reliably knows when to load.

**⚠️ IDE vs CLI difference:** The IDE has **Powers** — bundled packages of MCP + steering + hooks that activate on-demand via keyword matching. Powers are **not available in CLI**. Skills are the CLI's equivalent for on-demand context loading, but without the MCP/hooks bundling.

**Claude Code equivalent:** Skills (very similar concept).

---

### Subagents

**What:** Specialized agents running in isolated context windows.

**Who loads:** LLM (automatically) or Human (via instruction).

**Properties:**
- Own context window — main agent stays clean
- Parallel execution
- Results auto-returned to main agent
- Can use custom agent configs (different tools, models)
- Added: CLI v1.23 (Dec 18, 2025)

**When to use:** Large tasks worth isolated context. Parallel research. "Second opinion" from a different model. Prevent context bloat.

**Claude Code equivalent:** Subagents.

---

### Plan Agent

**What:** Built-in read-only agent that transforms ideas into structured implementation plans.

**Who loads:** Human — via `Shift+Tab` or `/plan`.

**Workflow:**
1. Requirements gathering (structured questions)
2. Codebase research (uses code intelligence, grep, glob — read-only)
3. Implementation plan (task breakdown with objectives)
4. Handoff to execution agent

**Added:** CLI v1.23 (Dec 18, 2025).

**Claude Code equivalent:** No built-in equivalent.

---

### Auto Model

**What:** Dynamic model selector that picks the optimal model per task.

**Who loads:** Kiro CLI software — automatic.

**Behavior:** Balances speed, cost, and quality per request. Enabled by default. Override with `/model` to select a specific model.

**Claude Code equivalent:** No equivalent — Claude Code uses a single model per session.

---

### Experimental features

These require settings flags to enable:

| Feature | Enable with | What it does |
|---|---|---|
| Tangent Mode | `chat.enableTangentMode true` | Side conversation without polluting main context. Toggle with `/tangent` or `Ctrl+T`. |
| Delegate | `chat.delegateModeKey "d"` | Background async agents for long-running tasks. Check with `/delegate status`. |
| Thinking | `chat.enableThinking true` | Extended reasoning before responses. |
| Todo Lists | `chat.enableTodoList true` | Track multi-step tasks within session. |
| Checkpoints | `chat.enableCheckpoint true` | Revert to previous conversation state. |

---

## Conversation management

| Command | Purpose |
|---|---|
| `/save` | Export conversation to JSON |
| `/load` | Import saved conversation |
| `/chat resume` | Resume previous session |
| `/compact` | Manually free context space |
| `/context add <glob>` | Add files to session context |
| `/context show` | Show what's loaded |
| `/context clear` | Remove session context rules |
| `/tools` | View/manage tool permissions |
| `/model` | Switch models mid-session |
| `/agent swap <n>` | Switch agent |
| `/help` | Built-in help agent |
| `/plan` | Plan agent |

**Note:** `/context` changes are session-only. For permanent changes, edit agent config.

**Directory-based persistence:** Sessions auto-associate with working directories. Same project directory = same conversation history.

---

## Mapping to Claude Code

| Claude Code | Kiro CLI | Notes |
|---|---|---|
| `CLAUDE.md` | Steering files (`.kiro/steering/`) | Kiro splits into multiple focused files |
| Rules (path-scoped) | — | **IDE-only** via `fileMatch` inclusion mode |
| Skills | Skills (`skill://` resources) | Very similar concept |
| Subagents | Custom Agents + Subagents | Kiro agents are broader (tool/model config) |
| MCP Servers | MCP Servers | Same protocol |
| Hooks | Hooks | Similar lifecycle events |
| Plugins | — | **IDE-only** (Powers) |
| `/context` | `/context` + `/usage` | Similar transparency |
| — | Plan Agent | No Claude Code equivalent |
| — | Auto Model | Dynamic model selection |
| — | Knowledge Bases | Semantic search over large doc sets |
| — | ACP | Use Kiro CLI as agent in JetBrains, Zed |

---

## The `.kiro` folder

```
my-project/
├── .kiro/
│   ├── steering/          # Guidance (markdown, loaded automatically)
│   │   ├── product.md
│   │   ├── tech.md
│   │   └── structure.md
│   ├── agents/            # Custom agent configs (JSON)
│   ├── skills/            # On-demand documentation (markdown + frontmatter)
│   ├── settings/
│   │   └── mcp.json       # MCP server config
│   └── specs/             # Kiro specs (requirements → design → tasks)
├── AGENTS.md              # Optional cross-tool standard (always loaded)
└── src/
```

Global: `~/.kiro/` mirrors this for steering, agents, settings, and sessions.

Shared between IDE and CLI. Configure once, use both.

---

## Practical rules

1. **Start minimal.** Three foundation files. Add more only when the agent repeatedly gets something wrong.
2. **Scope agents tightly.** Fewer tools and narrower file access = better results.
3. **Remember: custom agents don't inherit steering.** Add `file://.kiro/steering/**/*.md` explicitly.
4. **Use knowledge bases for large docs.** Don't stuff API specs into steering files.
5. **Use hooks for determinism.** If it must always happen (formatting, tests), don't rely on the LLM.
6. **Commit `.kiro/` to version control.** Team gets the same agent behavior. New members inherit context immediately.
7. **Refine iteratively.** Verbose human docs make poor steering. Condense for LLM consumption.

---

## Illusion of control

Steering increases probability. Hooks provide determinism. Everything else is probabilistic. "Ensure it does X" is aspirational. Think in probabilities. Choose the right level of oversight for the stakes.

---

*Official docs: [kiro.dev/docs/cli](https://kiro.dev/docs/cli/) · CLI changelog: [kiro.dev/changelog/cli](https://kiro.dev/changelog/cli/) · Agent config reference: [kiro.dev/docs/cli/custom-agents/configuration-reference](https://kiro.dev/docs/cli/custom-agents/configuration-reference/)*
