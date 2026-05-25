# Source: pi.dev (shittycodingagent.ai) — Official Website
# URL: https://shittycodingagent.ai
# Retrieved: 2026-02-17

## Key Descriptions

### Tagline
> "Pi is a minimal terminal coding harness. Adapt pi to your workflows, not the other way around."

### Philosophy Section
> "Pi is aggressively extensible so it doesn't have to dictate your workflow."

### What we didn't build
- No MCP: "Build CLI tools with READMEs (see Skills), or build an extension that adds MCP support."
- No sub-agents: "Spawn pi instances via tmux, or build your own with extensions"
- No permission popups: "Run in a container, or build your own confirmation flow"
- No plan mode: "Write plans to files, or build it with extensions"
- No built-in to-dos: "They confuse models. Use a TODO.md file"
- No background bash: "Use tmux. Full observability, direct interaction."

### Context Engineering Section
- "Pi's minimal system prompt and extensibility let you do actual context engineering."
- AGENTS.md loaded hierarchically
- SYSTEM.md for prompt replacement/append
- Compaction: "Auto-summarizes older messages when approaching the context limit. Fully customizable via extensions"
- Skills: "Progressive disclosure without busting the prompt cache"
- Prompt templates: "Reusable prompts as Markdown files. Type /name to expand."
- Dynamic context via extensions: "inject messages before each turn, filter the message history, implement RAG, or build long-term memory"

### Message Queue
- "Enter sends a steering message (delivered after current tool, interrupts remaining tools)"
- "Alt+Enter sends a follow-up (waits until the agent finishes)"

### Modes
- Interactive, Print/JSON, RPC, SDK
