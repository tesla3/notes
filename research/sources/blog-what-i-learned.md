# Source: "What I learned building an opinionated and minimal coding agent"
# Author: Mario Zechner
# Date: 2025-11-30
# URL: https://mariozechner.at/posts/2025-11-30-pi-coding-agent/
# Retrieved: 2026-02-17

## Key Quotes (with section references)

### Section: Introduction
> "Over the past few months, Claude Code has turned into a spaceship with 80% of functionality I have no use for. The system prompt and tools also change on every release, which breaks my workflows and changes model behavior."

> "context engineering is paramount. Exactly controlling what goes into the model's context yields better outputs, especially when it's writing code. Existing harnesses make this extremely hard or impossible by injecting stuff behind your back that isn't even surfaced in the UI."

> "I want to inspect every aspect of my interactions with the model. Basically no harness allows that."

### Section: Minimal system prompt
> "pi's system prompt and tool definitions together come in below 1000 tokens."

> "There does not appear to be a need for 10,000 tokens of system prompt, as we'll find out later in the benchmark section"

> "all the frontier models have been RL-trained up the wazoo, so they inherently understand what a coding agent is."

### Section: Minimal toolset
> "As it turns out, these four tools are all you need for an effective coding agent."

### Section: YOLO by default
> "If you look at the security measures in other coding agents, they're mostly security theater."

> "Since we cannot solve this trifecta of capabilities (read data, execute code, network access), pi just gives in."

> "Malicious content in files or command outputs can influence behavior. If you're uncomfortable with full access, run pi inside a container."

### Section: No built-in to-dos
> "to-do lists generally confuse models more than they help. They add state that the model has to track and update, which introduces more opportunities for things to go wrong."

### Section: No plan mode
> "I get to see which sources the agent actually looked at and which ones it totally missed."

> "In Claude Code, the orchestrating Claude instance usually spawns a sub-agent and you have zero visibility into what that sub-agent does."

### Section: No MCP support
> "Playwright MCP has 21 tools using 13.7k tokens (6.8% of Claude's context). Chrome DevTools MCP has 26 tools using 18.0k tokens (9.0%)."

### Section: No background bash
> "In earlier Claude Code versions, the agent forgot about all its background processes after context compaction and had no way to query them, so you had to manually kill them. This has since been fixed."

### Section: No sub-agents
> "You have zero visibility into what that sub-agent does. It's a black box within a black box."

> "Using a sub-agent mid-session for context gathering is a sign you didn't plan ahead."

> "If you need to gather context, do that first in its own session. Create an artifact that you can later use in a fresh session to give your agent all the context it needs without polluting its context window with tool outputs."

> "models are still poor at finding all the context needed for implementing a new feature or fixing a bug. I attribute this to models being trained to only read parts of files rather than full files, so they're hesitant to read everything."

> "Just look at the pi-mono issue tracker and the pull requests. Many get closed or revised because the agents couldn't fully grasp what's needed."

> "Spawning multiple sub-agents to implement various features in parallel is an anti-pattern in my book and doesn't work, unless you don't care if your codebase devolves into a pile of garbage."

### Section: Benchmarks
> "I created a Terminal-Bench 2.0 test run for pi with Claude Opus 4.5 and let it compete against Codex, Cursor, Windsurf, and other coding harnesses with their respective native models."

> "Terminus 2 is the Terminal-Bench team's own minimal agent that just gives the model a tmux session... And it's holding its own against agents with far more sophisticated tooling"

### Section: In summary
> "Twitter is full of context engineering posts and blogs, but I feel like none of the harnesses we currently have actually let you do context engineering."
