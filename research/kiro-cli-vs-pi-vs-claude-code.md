← [Index](../README.md)

# Kiro CLI vs Pi vs Claude Code — Comparative Analysis

**Date:** 2026-03-01
**Kiro CLI version:** 1.26.2 · **Pi version:** current npm · **Claude Code version:** ~2.1.x

---

## 1. What is Kiro CLI?

Kiro CLI is **AWS's terminal coding agent**, installed via:
```bash
curl -fsSL https://cli.kiro.dev/install | bash
```

It's the CLI counterpart to **Kiro IDE** (a VS Code fork). Built on top of **Q Developer CLI** technology (Amazon's former CodeWhisperer/Q lineage), it adds social login, custom agents, and Kiro's signature **spec-driven development** philosophy.

**Authentication:** AWS Builder ID, Google, or GitHub (social login). No raw API key option — you're on Kiro's platform, paying per-credit.

**Models available:** Claude Sonnet 4.0/4.5, Claude Opus 4/4.5 (Pro+/Power tiers only), Claude Haiku 4.5, plus an "Auto" mode that blends models with intent detection and caching.

---

## 2. Step-by-Step Walkthrough

### Installation
```bash
curl -fsSL https://cli.kiro.dev/install | bash
# Installs to ~/.local/bin/kiro-cli
kiro-cli --version  # 1.26.2
```

### Authentication
```bash
kiro-cli login
# Opens browser for AWS Builder ID / Google / GitHub
kiro-cli whoami  # Check auth status
kiro-cli doctor  # Diagnose issues
```

### Basic Chat
```bash
kiro-cli                              # Interactive chat (default)
kiro-cli chat "How do I list files?"  # Direct question
kiro-cli chat --resume                # Resume last session
kiro-cli chat --resume-picker         # Pick from saved sessions
kiro-cli chat --no-interactive --trust-all-tools "Show pwd"  # Non-interactive
```

### Slash Commands (inside chat)
| Command | Purpose |
|---------|---------|
| `/model` | Switch model |
| `/tools` | View/trust/untrust tools |
| `/tools trust-all` | Auto-approve everything |
| `/context` | Manage context |
| `/agent swap <name>` | Switch agent |
| `/code init` | Initialize LSP code intelligence |
| `/compact` | Summarize to free context |
| `/paste` | Add clipboard image |
| `/save` / `/load` | Export/import session |
| `/experiment` | Toggle experimental features |
| `!` | Run shell command inline |
| `ctrl-j` | Multi-line input |
| `ctrl-k` | Fuzzy search |

### Custom Agents
```bash
kiro-cli agent create --name my-agent
# Or inside chat:
# /agent generate
```

Agent config (JSON):
```json
{
  "name": "backend-specialist",
  "description": "Backend coding expert",
  "tools": ["read", "write", "shell"],
  "allowedTools": ["read"],
  "resources": ["file://README.md", "skill://.kiro/skills/**/SKILL.md"],
  "prompt": "You are a backend expert",
  "model": "claude-sonnet-4"
}
```

Stored at `~/.kiro/agents/` (global) or `.kiro/agents/` (project).

### MCP Servers
```bash
kiro-cli mcp add --name fetch --command "fetch3.1" --scope global
kiro-cli mcp list
kiro-cli mcp status
```

### Agent Steering
Create `.kiro/steering/*.md` files — equivalent to AGENTS.md / CLAUDE.md in other tools. These inject project-specific instructions into the agent context.

### Hooks
Pre/post tool execution hooks for automation:
```json
{
  "hooks": {
    "postToolUse": [{
      "matcher": "fs_write",
      "command": "cargo fmt --all"
    }]
  }
}
```

### Shell Translation
```bash
kiro-cli translate "find all Python files modified this week"
# → Outputs the shell command, asks to execute
```

### Inline Completions (Ghost Text)
```bash
kiro-cli inline enable   # AI-powered shell completions
kiro-cli inline status
```

### Experimental Features
```bash
kiro-cli settings chat.enableThinking true       # Thinking/reasoning
kiro-cli settings chat.enableTangentMode true     # Side conversations
kiro-cli settings chat.enableTodoList true        # Auto todo lists
kiro-cli settings chat.enableCheckpoint true      # Git-like checkpoints
kiro-cli settings chat.enableKnowledge true       # Persistent knowledge base
kiro-cli settings chat.enableDelegate true        # Async parallel tasks
```

---

## 3. Head-to-Head Comparison

### Architecture & Philosophy

| Dimension | Kiro CLI | Pi | Claude Code |
|-----------|----------|-----|-------------|
| **Maker** | AWS (Amazon) | OSS (badlogic/mariozechner) | Anthropic |
| **Heritage** | Q Developer CLI + Kiro IDE | Ground-up OSS | Anthropic internal tool, productized |
| **Philosophy** | Spec-driven, structured | Minimal harness, user-extensible | Maximum capability, minimal ceremony |
| **Core bet** | Process prevents tech debt | Adapt tool to workflow, not vice versa | Raw AI power + autonomy |

### Authentication & Pricing

| | Kiro CLI | Pi | Claude Code |
|---|----------|-----|-------------|
| **Auth** | AWS Builder ID / Google / GitHub social login | API keys or OAuth (Anthropic, OpenAI, Google, etc.) | Anthropic subscription or API key |
| **Pricing** | Credit-based (free 500 credits, then pay-as-you-go) | BYOK (pay your provider directly) | Pro $20/mo, Max $100/200/mo, or API |
| **Lock-in** | Kiro platform | None — any provider | Anthropic ecosystem |

**Verdict:** Pi has **zero lock-in** — bring any key from 20+ providers. Claude Code locks to Anthropic. Kiro locks to AWS/Kiro's credit system. Pi wins for flexibility; Kiro wins for "just sign up and go" simplicity.

### Model Support

| | Kiro CLI | Pi | Claude Code |
|---|----------|-----|-------------|
| **Models** | Claude family only (Sonnet 4, Opus 4, Haiku 4.5) | 20+ providers, hundreds of models | Claude family (Sonnet, Opus, Haiku) |
| **Model switching** | `/model` in chat | `/model`, Ctrl+L, Ctrl+P cycling | `/model` in chat |
| **Local models** | No | Yes (via OpenRouter, custom providers) | No |

**Verdict:** Pi dominates. Kiro and Claude Code are both Claude-only (though Kiro may add Bedrock models eventually).

### Core Tools

| Tool | Kiro CLI | Pi | Claude Code |
|------|----------|-----|-------------|
| File read | ✅ `fs_read` | ✅ `read` | ✅ `Read` |
| File write | ✅ `fs_write` | ✅ `write` | ✅ `Write` |
| File edit (surgical) | ✅ (via write) | ✅ `edit` (find/replace) | ✅ `Edit` |
| Bash/shell | ✅ `shell` | ✅ `bash` | ✅ `Bash` |
| Web search/fetch | ✅ built-in `web_search` + `web_fetch` | Via skills (brave-search, etc.) | No built-in (MCP needed) |
| AWS CLI | ✅ built-in `aws` tool | No (bash it) | No |
| Grep/glob | ✅ built-in | Via bash | Via bash |
| LSP/Code Intelligence | ✅ `/code init` (8 languages) | No built-in | No built-in |
| Image input | ✅ `/paste` | ✅ Ctrl+V | ✅ drag/paste |
| Clipboard copy | ❓ | ✅ `copy_to_clipboard` tool | No |
| Plans/todos | ✅ experimental todo tool | ✅ `plan` tool (file-based) | No built-in |

**Kiro's unique tools:** Built-in web search/fetch, AWS CLI tool, LSP-powered code intelligence (find references, hover docs, rename across 8 languages). These are genuinely useful — especially the code intelligence, which no other CLI agent has natively.

**Pi's unique tools:** `edit` (surgical find-replace, not full file rewrite), `copy_to_clipboard`, file-based `plan` management. The `edit` tool is critical for precision on large files.

### Customization & Extensibility

| | Kiro CLI | Pi | Claude Code |
|---|----------|-----|-------------|
| **Context/steering files** | `.kiro/steering/*.md` | `AGENTS.md` / `CLAUDE.md` (hierarchical) | `CLAUDE.md` |
| **Custom agents** | ✅ JSON configs with tools, permissions, prompts, MCP, hooks | No "agents" — use skills + prompt templates + extensions | No custom agents |
| **Skills** | ✅ `.kiro/skills/**/SKILL.md` (Agent Skills standard) | ✅ `.pi/skills/**/SKILL.md` (Agent Skills standard) | No |
| **Prompt templates** | Via prompts system | ✅ Markdown files, `/templatename` | No |
| **Extensions (code)** | No | ✅ TypeScript extensions (TUI widgets, custom tools, custom commands, themes) | No |
| **Hooks** | ✅ Pre/post tool use, agent spawn, user prompt submit | No built-in hooks | ✅ Pre/post tool hooks |
| **MCP** | ✅ First-class | Via extensions or external | ✅ First-class |
| **Themes** | ✅ light/dark/system | ✅ Full theme system (custom colors, fonts) | No |

**Verdict:** Pi is the **most extensible** — TypeScript extensions can add custom tools, TUI widgets, commands, even replace the editor. Kiro is **most structured** — hooks + custom agents with granular tool permissions. Claude Code is the **least customizable** but compensates with raw capability.

### Session Management

| | Kiro CLI | Pi | Claude Code |
|---|----------|-----|-------------|
| **Persistence** | Directory-based, auto-save | JSONL tree files in `~/.pi/agent/sessions/` | Directory-based |
| **Resume** | `--resume`, `--resume-picker` | `pi -c` (continue), `pi -r` (browse) | `--resume` |
| **Branching** | No | ✅ `/tree` — navigate + branch in-place, `/fork` | No |
| **Compaction** | ✅ auto + manual | ✅ auto + manual + custom via extensions | ✅ auto + manual |
| **Export** | `/save` (JSON) | `/export` (HTML), `/share` (GitHub gist) | No |

**Verdict:** Pi's session branching (`/tree`) is a killer feature nobody else has. Navigate to any point in history, branch off, switch between branches — all in one file.

### Non-Interactive / CI Usage

| | Kiro CLI | Pi | Claude Code |
|---|----------|-----|-------------|
| **Non-interactive** | `--no-interactive` | `pi -p "prompt"` (print mode), `pi --json` | `--print` |
| **Trust tools** | `--trust-all-tools`, `--trust-tools=a,b` | N/A (tools always available) | `--dangerously-skip-permissions` |
| **SDK/embedding** | No | ✅ Full TypeScript SDK | ✅ SDK |
| **RPC mode** | No | ✅ RPC for process integration | No |

### Unique Features Per Tool

**Kiro CLI only:**
- **Shell translation** (`kiro-cli translate "..."`) — NL to shell command
- **Inline ghost text** — AI autocomplete in your regular shell
- **Built-in LSP code intelligence** — 8 languages, find refs, rename, hover docs
- **Built-in web search/fetch** — no skill/MCP needed
- **AWS CLI tool** — native AWS integration
- **Agent hooks** — pre/post tool automation
- **Delegate mode** — async parallel agent tasks (experimental)
- **Tangent mode** — side conversations without losing context (experimental)
- **Checkpoints** — git-like snapshots within a session (experimental)

**Pi only:**
- **Session tree branching** (`/tree`, `/fork`) — navigate and branch history
- **TypeScript extensions** — custom tools, TUI widgets, commands, themes
- **20+ providers** — most model options by far
- **`edit` tool** — surgical find-replace (not full file rewrite)
- **Message queue** — steer agent mid-execution or queue follow-ups
- **Prompt templates** — reusable parameterized prompts
- **Pi packages** — share extensions/skills/themes via npm/git
- **SDK + RPC** — embed in your own apps
- **File-based plans** — built-in plan management tool

**Claude Code only:**
- **Agentic search** — autonomous deep codebase exploration
- **Opus 4/4.5 access** — most powerful reasoning model
- **GitHub Actions integration** — native CI/CD
- **Sub-agents** — delegate to specialized sub-processes
- **Deepest autonomy** — least hand-holding needed for complex tasks

---

## 4. Benchmark Data (Feb 2026, aimultiple.com)

| Agent | Combined Score | Speed (avg sec) | Token Usage |
|-------|---------------|-----------------|-------------|
| Codex | 67.7% | 426s | 258k |
| **Kiro CLI** | **58.1%** | **168s** ⚡ | N/A (46 credits) |
| Claude Code | 55.5% | 745s | 397k |
| Aider | 52.7% | 257s | 126k |

Kiro is notably the **fastest** agent while scoring well. Claude Code is the most expensive in tokens but has the best frontend score (95%).

---

## 5. Who Should Use What?

| You are... | Use |
|-----------|-----|
| Terminal power user who wants max flexibility | **Pi** |
| Building complex systems, want enforced process | **Kiro CLI** |
| Want raw AI horsepower, deep autonomous coding | **Claude Code** |
| Need to switch between many models/providers | **Pi** |
| AWS shop, want native cloud integration | **Kiro CLI** |
| Want to customize the tool itself (extensions, UI) | **Pi** |
| CI/CD automation, non-interactive pipelines | **Claude Code** or **Kiro CLI** |
| Free tier matters | **Kiro CLI** (500 free credits) |
| Privacy-conscious, BYOK | **Pi** |

---

## 6. Honest Assessment

**Kiro CLI strengths:**
- Spec-driven approach genuinely reduces rework on complex features
- Fastest execution in benchmarks
- Built-in web search, LSP, and AWS tools are table-stakes features others lack
- Custom agents with granular permissions are well-designed
- Shell translation and inline completions are nice quality-of-life
- Free tier is generous

**Kiro CLI weaknesses:**
- Locked to Claude models via AWS — no model diversity
- Credit-based pricing is opaque compared to direct API billing
- No session branching
- No real extension system — JSON config only
- Many best features are still "experimental" flags
- Community is small compared to Claude Code
- Auth required for everything — can't just `export API_KEY` and go

**Pi strengths:**
- Most extensible by far (TypeScript extensions = unlimited customization)
- Most providers supported (20+, including local models)
- Zero lock-in, zero platform dependency
- Session branching is genuinely unique and powerful
- True BYOK — transparent cost, no middleman markup
- Minimal philosophy means it doesn't impose workflow

**Pi weaknesses:**
- No built-in web search, LSP, or hooks
- Requires more setup (skills, extensions) to match Kiro's out-of-box features
- Smaller mindshare than Claude Code
- No built-in spec-driven workflow

**Claude Code strengths:**
- Most powerful autonomous coding (Opus 4.5 access)
- Best at complex multi-step reasoning
- Deepest codebase understanding
- Strong ecosystem (GitHub Actions, sub-agents)
- Anthropic subscription is simple and predictable

**Claude Code weaknesses:**
- Most expensive in tokens/time
- Locked to Anthropic
- Least customizable
- No session branching, limited session management
- No built-in web search or LSP
