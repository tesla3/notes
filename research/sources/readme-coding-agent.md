# Source: Pi Coding Agent README.md
# Package: @mariozechner/pi-coding-agent v0.52.12
# URL: https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/README.md
# Retrieved: 2026-02-17

## Key Facts

### Editor Features
- `@` for fuzzy file search
- Tab for path completion
- Shift+Enter for multi-line
- Ctrl+V for image paste
- `!command` runs and sends output to LLM
- `!!command` runs without sending

### Message Queue
- Enter = steering message (delivered after current tool, interrupts remaining)
- Alt+Enter = follow-up (waits until agent finishes)
- Escape = abort and restore queued messages
- Alt+Up = retrieve queued messages to editor
- Delivery modes: "one-at-a-time" (default) or "all"

### Session Tree
- /tree navigates the session tree in-place
- Filter modes (Ctrl+O): default → no-tools → user-only → labeled-only → all
- Press `l` to label entries as bookmarks
- /fork creates new session from current branch
- Escape twice opens /tree

### Keyboard Shortcuts
- Ctrl+C = clear editor, twice = quit
- Escape = cancel/abort
- Ctrl+L = model selector
- Ctrl+P / Shift+Ctrl+P = cycle scoped models
- Shift+Tab = cycle thinking level
- Ctrl+O = collapse/expand tool output
- Ctrl+T = collapse/expand thinking blocks

### Built-in Tools
- Default: read, bash, edit, write
- Additional (disabled by default): grep, find, ls
- --tools read,grep,find,ls = read-only mode

### Compaction
- Manual: /compact or /compact <instructions>
- Automatic: enabled by default, triggers on overflow or approaching limit
- Lossy: full history preserved in JSONL, use /tree to revisit
- Customizable via extensions

### Context Files
- ~/.pi/agent/AGENTS.md (global)
- Parent directories (walking up from cwd)
- Current directory
- .pi/SYSTEM.md = replace default system prompt
- APPEND_SYSTEM.md = append without replacing

### CLI Examples
- pi --tools read,grep,find,ls = read-only mode
- pi --no-session = ephemeral mode
- pi -p "query" = print mode
- pi --model sonnet:high = model + thinking level shorthand
- pi --models "claude-*,gpt-4o" = limit cycling

### Environment Variables
- PI_CACHE_RETENTION = Set to "long" for extended prompt cache (Anthropic: 1h, OpenAI: 24h)
- PI_CODING_AGENT_DIR = Override config directory
- PI_SKIP_VERSION_CHECK = Skip version check
