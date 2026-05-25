# Pi Coding Agent: Tips, Tricks, and Design Philosophy — A Critical Analysis

**Author:** Research compilation  
**Date:** 2026-02-17  
**Subject:** @mariozechner/pi-coding-agent v0.52.12

---

## References

| ID | Source | Author | Date | URL |
|----|--------|--------|------|-----|
| [1] | "What I learned building an opinionated and minimal coding agent" (blog post) | Mario Zechner | 2025-11-30 | https://mariozechner.at/posts/2025-11-30-pi-coding-agent/ |
| [2] | "What if you don't need MCP at all?" (blog post) | Mario Zechner | 2025-11-02 | https://mariozechner.at/posts/2025-11-02-what-if-you-dont-need-mcp/ |
| [3] | Pi Coding Agent README.md (v0.52.12) | Mario Zechner et al. | 2026 (ongoing) | https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/README.md |
| [4] | Pi AI README.md — Cache Retention section (v0.52.12) | Mario Zechner et al. | 2026 (ongoing) | https://github.com/badlogic/pi-mono/blob/main/packages/ai/README.md |
| [5] | system-prompt.ts source code (v0.52.12) | Mario Zechner et al. | 2026 (ongoing) | https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/src/core/system-prompt.ts |
| [6] | Extension Examples README.md | Mario Zechner et al. | 2026 (ongoing) | https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/examples/extensions/README.md |
| [7] | Skills documentation (docs/skills.md) | Mario Zechner et al. | 2026 (ongoing) | https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/docs/skills.md |
| [8] | Prompt Templates documentation (docs/prompt-templates.md) | Mario Zechner et al. | 2026 (ongoing) | https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/docs/prompt-templates.md |
| [9] | pi.dev official website | Mario Zechner | 2026 (ongoing) | https://shittycodingagent.ai |
| [10] | AGENTS.md — Development Rules | Mario Zechner et al. | 2026 (ongoing) | https://github.com/badlogic/pi-mono/blob/main/AGENTS.md |
| [11] | Pi AI CHANGELOG.md — cache retention entry | Mario Zechner et al. | 2026 (ongoing) | https://github.com/badlogic/pi-mono/blob/main/packages/ai/CHANGELOG.md |
| [12] | Pi Coding Agent CHANGELOG.md — cache retention entry | Mario Zechner et al. | 2026 (ongoing) | https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/CHANGELOG.md |
| [13] | Extension directory listing (GitHub) | Mario Zechner et al. | 2026 (ongoing) | https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent/examples/extensions |
| [14] | Terminal-Bench 2.0 results.json (Gist) | Mario Zechner | 2025-12 | https://gist.github.com/badlogic/f45e8f6e481e5ab7d3a50659da84edaa |
| [15] | Terminal-Bench 2.0 benchmark suite | Laude Institute | 2025 (ongoing) | https://github.com/laude-institute/terminal-bench |

---

## 1. The Context Window as the Primary Bottleneck

### The Claim

Pi's entire design philosophy revolves around minimizing unnecessary context consumption, because the context window — not model intelligence — is the practical bottleneck for agent quality.

### Evidence

Pi's system prompt with default tools (read, bash, edit, write) is dynamically generated and significantly smaller than competitors' [5]. At the time of the blog post (November 2025), Zechner stated: *"pi's system prompt and tool definitions together come in below 1000 tokens"* [1, §Minimal system prompt].

**Caveat:** The current system prompt (v0.52.12) has grown beyond the blog's "below 1000 tokens" claim. It now includes a "Pi documentation" section with 8 lines of documentation path references, a line about custom tools from extensions, and dynamically generated guidelines that vary based on enabled tools [5]. It remains substantially smaller than competitors, but the specific "below 1000 tokens" figure is outdated.

Zechner frames this against a general observation: *"There does not appear to be a need for 10,000 tokens of system prompt"* [1, §Minimal system prompt]. He attributes this to RL training: *"all the frontier models have been RL-trained up the wazoo, so they inherently understand what a coding agent is"* [1, §Minimal system prompt]. Note: Zechner does not cite a specific token count for any competitor's system prompt; the "10,000" is a rhetorical figure.

### Why It Matters

Every token consumed by system prompt and tool definitions is a token unavailable for actual work — file contents, tool outputs, conversation history. MCP servers illustrate the cost dramatically: Playwright MCP consumes 13,700 tokens (21 tools), Chrome DevTools MCP consumes 18,000 tokens (26 tools), representing 6.8% and 9.0% of Claude's context window respectively [1, §No MCP support] [2, §Problems with Common Browser DevTools]. These costs are paid on **every session**, regardless of whether the tools are used.

Context pressure compounds: as the window fills, compaction triggers — a lossy summarization that destroys precise details the agent needs for subsequent work [3, §Compaction]. Minimizing unnecessary context consumption delays or avoids compaction, preserving information quality across longer sessions.

### Practical Application

- Use skills for progressive disclosure: only descriptions enter the system prompt; full instructions load on-demand when the agent reads the SKILL.md file [7] [9, §Context].
- Replace MCP servers with CLI tools and README files. Zechner demonstrated replacing 21 MCP tools (13,700 tokens) with 4 CLI scripts and a 225-token README — approximately 61× less context consumption [2, §The Benefits].
- Write AGENTS.md files for project-specific context rather than relying on always-present system prompt content [3, §Context Files].

---

## 2. Observability Over Automation

### The Claim

Seeing everything the agent does matters more than having the agent do things autonomously. Black-box automation leads to undetectable errors.

### Evidence

Zechner argues this from direct experience with Claude Code's sub-agent system: *"You have zero visibility into what that sub-agent does. It's a black box within a black box. Context transfer between agents is also poor"* [1, §No sub-agents].

Regarding plan mode specifically: *"I get to see which sources the agent actually looked at and which ones it totally missed. In Claude Code, the orchestrating Claude instance usually spawns a sub-agent and you have zero visibility into what that sub-agent does"* [1, §No plan mode].

He cites empirical evidence from the pi-mono project itself: *"Just look at the pi-mono issue tracker and the pull requests. Many get closed or revised because the agents couldn't fully grasp what's needed. That's not the fault of the contributors... It just means we trust our agents too much"* [1, §No sub-agents].

The root cause is identified as a training artifact: *"models are still poor at finding all the context needed for implementing a new feature or fixing a bug. I attribute this to models being trained to only read parts of files rather than full files, so they're hesitant to read everything"* [1, §No sub-agents].

### Why It Matters

An agent that completes 50 steps autonomously but makes an error at step 3 wastes 47 steps of compute, tokens, and time. Without observability, you cannot detect the error until the final output. With observability, you can course-correct immediately.

Pi's steering messages (Enter while agent works) provide an interrupt mechanism: they are *"delivered after current tool execution"* and *"interrupt remaining tools"* [3, §Message Queue]. This is the practical mechanism for correcting an agent mid-task when you observe it going wrong.

### Practical Application

- Use steering messages (Enter) to redirect the agent when you see it exploring the wrong files or taking the wrong approach [3, §Message Queue].
- When using sub-agents, spawn pi via bash (`pi --print`) so you see the full output rather than a summarized version [1, §No sub-agents].
- Use tmux for long-running processes — it provides observable, interactive, queryable process management that survives compaction [1, §No background bash].

---

## 3. Two-Phase Workflow: Context Gathering Then Implementation

### The Claim

Context gathering and implementation should be separate sessions, with an intermediate artifact connecting them.

### Evidence

Zechner states: *"Using a sub-agent mid-session for context gathering is a sign you didn't plan ahead. If you need to gather context, do that first in its own session. Create an artifact that you can later use in a fresh session to give your agent all the context it needs without polluting its context window with tool outputs"* [1, §No sub-agents].

He elaborates on the benefits: *"That artifact can be useful for the next feature too, and you get full observability and steerability, which is important during context gathering"* [1, §No sub-agents].

This extends to planning: *"Unlike ephemeral planning modes that only exist within a session, file-based plans can be shared across sessions, and can be versioned with your code"* [1, §No plan mode].

### Why It Matters

When an agent explores a codebase (reading files, running grep, navigating directories), all tool calls and their outputs accumulate in the context window. By the time the agent begins implementation, a substantial portion of the context is consumed by exploration artifacts that have no further value. A fresh session with a curated artifact starts at full capacity.

The file-based approach (PLAN.md, TODO.md, design docs) creates external state that is:
- Persistent across sessions
- Version-controllable with git
- Human-readable and editable
- Reusable across multiple features

By contrast, built-in plan modes and todo tools create ephemeral internal state. Zechner argues built-in to-dos specifically *"generally confuse models more than they help. They add state that the model has to track and update, which introduces more opportunities for things to go wrong"* [1, §No built-in to-dos].

### Practical Application

- Session 1: Explore codebase, produce a PLAN.md or design artifact. This session is disposable.
- Session 2: Start fresh, feed the artifact. 100% of context available for implementation.
- Use `pi --tools read,grep,find,ls` for read-only exploration sessions [3, §CLI Reference].
- Store plans and todos as markdown files in the project directory.

---

## 4. CLI Tools Over MCP: Composability and Efficiency

### The Claim

CLI tools invoked via bash are superior to MCP servers for most agent use cases due to composability, token efficiency, and ease of extension.

### Evidence

Zechner wrote a dedicated blog post on this topic [2], arguing: *"many of the most popular MCP servers are inefficient for a specific task. They need to cover all bases, which means they provide large numbers of tools with lengthy descriptions, consuming significant context"* [2, §Introduction].

The composability argument: *"MCP servers also aren't composable. Results returned by an MCP server have to go through the agent's context to be persisted to disk or combined with other results"* [2, §Introduction]. CLI tools can pipe outputs, redirect to files, and chain commands — standard Unix composability primitives that bypass the context window entirely.

The extensibility argument is demonstrated practically: when Zechner needed a new browser tool (element picker, cookies), he had the agent build it in under a minute and added a few lines to the README [2, §Adding the Pick Tool, §Adding the Cookies Tool]. Extending an MCP server requires understanding its codebase and framework.

Quantitatively: 4 CLI scripts + 225-token README vs. 21 MCP tools + 13,700 tokens (Playwright) or 26 tools + 18,000 tokens (Chrome DevTools) [2, §The Benefits] [2, §Problems with Common Browser DevTools].

### Why It Matters

The token savings are significant: ~61× reduction compared to Playwright MCP. But the composability benefit may be even more important. When an MCP tool returns data, it must pass through the agent's context. When a CLI tool writes output to a file, it can be processed by other tools or code without ever entering the context window — preserving it for actual reasoning.

### Practical Application

- Build tools as simple CLI scripts with README files describing usage [2].
- Use skills to surface tool READMEs on-demand rather than loading all tool descriptions at startup [7].
- If MCP is required, use mcporter (by Peter Steinberger) to wrap MCP servers as CLI tools [1, §No MCP support].
- Maintain a tools directory and add it to PATH via aliases for cross-session reuse [2, §Making This Reusable].

---

## 5. Tmux as the Process Management Layer

### The Claim

Tmux replaces the need for background bash, providing superior observability, interactivity, and reliability.

### Evidence

Zechner explains the problem with built-in background process management: *"In earlier Claude Code versions, the agent forgot about all its background processes after context compaction and had no way to query them, so you had to manually kill them. This has since been fixed"* [1, §No background bash].

Tmux solves this by externalizing process state from the agent entirely. The agent interacts with tmux via bash commands [1, §No background bash]:
- `tmux new-session -d -s name` — start processes
- `tmux capture-pane -t name -p` — observe output
- `tmux send-keys -t name "input" Enter` — interact
- `tmux list-sessions` — discover running processes

The AGENTS.md file demonstrates tmux usage for testing pi's own TUI [10, §Testing pi Interactive Mode with tmux].

### Why It Matters

Tmux state lives outside the agent's context window and memory. It:
- Survives compaction (no state is lost when context is summarized)
- Survives session changes (processes persist across pi sessions)
- Is observable (capture-pane gives the agent a snapshot at any time)
- Is interactive (both agent and human can interact with the same session)
- Is queryable (list-sessions provides process discovery without internal state tracking)

The pi.dev website summarizes: *"Use tmux. Full observability, direct interaction"* [9, §Philosophy].

### Practical Application

- For dev servers: `tmux new-session -d -s devserver "npm run dev"`
- For debugging: have the agent spawn LLDB/GDB in a tmux session [1, §No background bash]
- For sub-agents: spawn pi in a tmux session for full observability and direct interaction [1, §No sub-agents]
- To check output: `tmux capture-pane -t session -p`

---

## 6. Extensions as Architecture — Primitives Over Features

### The Claim

Pi deliberately omits features (plan mode, sub-agents, permission gates, MCP, todos) and instead provides primitives to build them, yielding strictly more power for users who know their workflows.

### Evidence

The pi.dev website states: *"Pi is aggressively extensible so it doesn't have to dictate your workflow. Features that other tools bake in can be built with extensions, skills, or installed from third-party pi packages"* [9, §Philosophy].

The extension system provides: custom tools, commands, keyboard shortcuts, event handlers, UI components, system prompt modification, compaction customization, and message filtering [3, §Extensions] [6].

The examples directory contains 50+ extensions demonstrating implementations of features other agents build in [13]:

| Feature | Extension | Size |
|---------|-----------|------|
| Permission gates | `permission-gate.ts` | 1,017 B |
| Path protection | `protected-paths.ts` | 806 B |
| Plan mode | `plan-mode/` | directory |
| Sub-agents | `subagent/` | directory |
| Todos | `todo.ts` | 8.8 KB |
| Git checkpoints | `git-checkpoint.ts` | 1.4 KB |
| Custom compaction | `custom-compaction.ts` | 4.0 KB |
| SSH delegation | `ssh.ts` | 7.1 KB |
| Desktop notifications | `notify.ts` | 1.9 KB |
| Named presets | `preset.ts` | 13.0 KB |
| Context handoff | `handoff.ts` | 4.5 KB |

State persistence in extensions follows a specific pattern: store state in tool result `details` for session fork support, and reconstruct from session entries on `session_start` events [6, §Key Patterns].

### Why It Matters

The problem space for AI-assisted coding is not yet settled. Every harness that bakes in an opinionated plan mode, sub-agent system, or permission model bets on a specific answer. Pi bets on composability: if the user can build any of these features, the user can also build the version that fits their specific workflow, project, and security requirements.

The tradeoff is real: Pi requires more initial effort from the user. Claude Code's defaults are immediately productive. Pi's advantage appears over time as the user accumulates extensions, skills, and prompt templates tailored to their workflow.

---

## 7. Model Switching as a Strategic Tool

### The Claim

Mid-session model switching — enabled by cross-provider context handoff — allows using the right model for each sub-task, optimizing for both quality and cost.

### Evidence

Pi supports model switching via Ctrl+L (selector), Ctrl+P/Shift+Ctrl+P (cycle scoped models), and a shorthand syntax `--model sonnet:high` for model + thinking level [3, §Keyboard Shortcuts] [3, §CLI Reference].

The pi-ai library was *"designed from the start"* for cross-provider context handoff [1, §Context handoff]. When switching providers, thinking traces and signed blobs are automatically transformed. For example, *"if you switch from Anthropic to OpenAI mid-session, Anthropic thinking traces are converted to content blocks inside assistant messages, delimited by `<thinking></thinking>` tags"* [1, §Context handoff].

Thinking levels can be cycled with Shift+Tab [3, §Keyboard Shortcuts], allowing adjustment of reasoning depth per-task without changing models.

The `--models` flag limits Ctrl+P cycling: `--models "claude-*,gpt-4o"` restricts to matching patterns [3, §CLI Reference].

### Why It Matters

Different tasks within a coding session have different intelligence requirements. Using a frontier reasoning model for directory listing wastes tokens and money. A workflow-aware user can switch to cheaper models for exploration and reserve expensive models for complex reasoning.

Cross-provider handoff also enables second opinions: ask Claude a design question, then switch to GPT to verify, then switch to Gemini for a third perspective — all within the same session with full context continuity [1, §Context handoff].

---

## 8. The Session Tree — Version Control for Conversations

### The Claim

Pi's tree-structured sessions with branching and labeling provide a uniquely powerful mechanism for exploring alternative approaches without losing history.

### Evidence

Sessions are *"stored as JSONL files with a tree structure. Each entry has an `id` and `parentId`, enabling in-place branching without creating new files"* [3, §Sessions].

The `/tree` command navigates the tree with multiple filter modes accessible via Ctrl+O: `default → no-tools → user-only → labeled-only → all` [3, §Branching]. Entries can be labeled as bookmarks by pressing `l` in tree view [3, §Branching].

`/fork` creates a new session file from the current branch, copying history up to a selected point [3, §Branching].

Compaction is lossy, but *"The full history remains in the JSONL file; use /tree to revisit"* [3, §Compaction].

### Why It Matters

When an agent goes down a wrong path in a linear conversation, the only options are: accept the bad output, or start over (losing all prior context and tokens). With branching, you jump back to any previous point and try a different approach. The wrong branch remains accessible — you might cherry-pick parts of it later.

The filter modes solve a navigation problem in long sessions. In a 200-exchange session, `user-only` mode shows just your prompts, revealing the narrative structure. `labeled-only` shows bookmarked decision points.

---

## 9. Editor Operators: `!`, `!!`, and `@`

### The Claim

Small editor features provide outsized workflow acceleration by eliminating round-trips and context pollution.

### Evidence

The README documents [3, §Editor]:
- `!command` — runs bash command and sends output to the LLM
- `!!command` — runs bash command without sending output to the LLM
- `@` — triggers fuzzy file search for file inclusion in messages

File arguments also work from the CLI: `pi @screenshot.png "What's in this image?"` [3, §File Arguments].

### Why It Matters

`!git diff --cached` runs the command and injects the output into your next message in one step. Without it, you would either: (a) ask the agent to run the command (one agent round-trip, one tool call wrapper consuming tokens), or (b) run it yourself and copy-paste (multiple manual steps). The `!` operator eliminates both overhead paths.

`!!` is the counterpart for when you want to check something without polluting the context window — validating your own assumptions before directing the agent.

`@` with fuzzy search lets you precisely control which files enter the context, rather than relying on the agent to discover them (which, per Zechner's observation, agents systematically do poorly because they're biased toward partial reads [1, §No sub-agents]).

---

## 10. Cache Retention Configuration

### The Claim

Setting `PI_CACHE_RETENTION=long` extends prompt caching duration, which can reduce costs for long sessions but involves a tradeoff for Anthropic.

### Evidence

The pi-ai README documents [4, §Cache Retention]:

| Provider  | Default    | With `PI_CACHE_RETENTION=long` |
|-----------|------------|--------------------------------|
| Anthropic | 5 minutes  | 1 hour                         |
| OpenAI    | in-memory  | 24 hours                       |

The feature *"only affects direct API calls to `api.anthropic.com` and `api.openai.com`. Proxies and other providers are unaffected"* [4, §Cache Retention].

**Important caveat:** *"Extended cache retention may increase costs for Anthropic (cache writes are charged at a higher rate). OpenAI's 24h retention has no additional cost"* [4, §Cache Retention].

The CHANGELOG entry provides additional detail: *"Added `PI_CACHE_RETENTION` environment variable to control cache TTL for Anthropic (5m vs 1h) and OpenAI (in-memory vs 24h). Set to `long` for extended retention. Only applies to direct API calls"* [11].

### Why It Matters

Prompt caching avoids re-processing the system prompt and early messages on each turn. For long sessions where the same prefix is sent repeatedly, this reduces input token costs for cached portions. However, for Anthropic specifically, the tradeoff is non-trivial: cache writes cost more per token, so the benefit only materializes if cached content is read multiple times within the retention window. For OpenAI, there is no additional cost for extended retention [4].

### Practical Application

- For long sessions with many turns: `PI_CACHE_RETENTION=long` likely saves money on both providers.
- For short, disconnected sessions: the cache may never be hit, and Anthropic's higher write cost could increase total spend.
- Does not work through proxies, OpenRouter, or non-direct API endpoints [4].

---

## 11. Prompt Templates for Workflow Codification

### The Claim

Reusable prompt templates allow codifying repeated workflows into single-command invocations.

### Evidence

Templates are Markdown files placed in `~/.pi/agent/prompts/` or `.pi/prompts/`. The filename becomes the command: `review.md` → `/review` [8].

Templates support positional arguments (`$1`, `$2`), all-args (`$@`), and slicing (`${@:N}`, `${@:N:L}`) [8, §Arguments].

Zechner demonstrates a code review sub-agent template in the blog [1, §No sub-agents]:

```markdown
---
description: Run a code review sub-agent
---
Spawn yourself as a sub-agent via bash to do a code review: $@
Use `pi --print` with appropriate arguments.
Pass a prompt to the sub-agent asking it to review the code for:
- Bugs and logic errors
- Security issues
- Error handling gaps
Do not read the code yourself. Let the sub-agent do that.
Report the sub-agent's findings.
```

### Why It Matters

Templates capture expert workflows as reusable artifacts. Instead of re-typing complex multi-step instructions, a single `/review PR #42 --model opus` expands into a full, well-structured prompt. Templates can be:
- Shared across teams (via pi packages or git)
- Version-controlled alongside the project
- Composed with file arguments and other features

---

## 12. Ephemeral and Read-Only Modes

### The Claim

Pi's CLI flags enable purpose-specific configurations that protect codebases and reduce overhead.

### Evidence

From the README [3, §CLI Reference]:
- `pi --no-session` — ephemeral mode, no session file created
- `pi --tools read,grep,find,ls` — read-only mode, no writes or bash execution
- `pi -p "query"` — print mode, outputs response and exits
- `pi --no-session -p "query"` — combined ephemeral + print for quick one-off queries

### Why It Matters

Read-only mode (`--tools read,grep,find,ls`) is valuable for:
- Code audits where the agent must not modify anything
- Exploration during the context-gathering phase (see §3)
- Onboarding to unfamiliar codebases

Ephemeral mode avoids accumulating session files for throwaway queries, reducing disk clutter and making it clear the interaction is disposable.

---

## 13. The Philosophical Core: Benchmarks Support Minimalism

### The Claim

A minimal harness (small system prompt, few tools) performs comparably to feature-rich competitors on standardized benchmarks.

### Evidence

Zechner ran Terminal-Bench 2.0 [15] with pi using Claude Opus 4.5, competing against Codex, Cursor, Windsurf, and other harnesses with their native models [1, §Benchmarks]. Results were submitted to the leaderboard [14].

He specifically highlights Terminus 2, the benchmark team's own minimal agent: *"Terminus 2 is the Terminal-Bench team's own minimal agent that just gives the model a tmux session. The model sends commands as text to tmux and parses the terminal output itself. No fancy tools, no file operations, just raw terminal interaction. And it's holding its own against agents with far more sophisticated tooling"* [1, §Benchmarks].

Zechner frames this cautiously: *"Obviously, we all know benchmarks aren't representative of real-world performance, but it's the best I can provide you as a sort of proof that not everything I say is complete bullshit"* [1, §Benchmarks].

**Note:** The specific ranking positions and comparative scores are shown in images in the blog post that cannot be verified as text. Zechner does not make explicit claims of "beating" specific competitors in prose.

### Why It Matters

The benchmark evidence, while acknowledged as imperfect, challenges the assumption that more tools, larger system prompts, and built-in features produce better outcomes. If a sub-1000-token system prompt (as of Nov 2025) with 4 tools produces competitive results, the additional complexity of larger harnesses may not justify its cost — both in tokens consumed and in reduced user control.

Zechner's final assessment: *"Twitter is full of context engineering posts and blogs, but I feel like none of the harnesses we currently have actually let you do context engineering. pi is my attempt to build myself a tool where I'm in control as much as possible"* [1, §In summary].

---

## Appendix: Accuracy Notes

These corrections apply to the preliminary analysis produced before this cited version:

1. **"Claude Code's system prompt consumes ~10,000 tokens"** — Zechner does not state this. He makes a general claim that 10,000 tokens of system prompt is unnecessary [1]. The specific size of Claude Code's prompt is not measured in any pi source.

2. **"Pi's system prompt is under 1,000 tokens"** — This was true as of the Nov 2025 blog [1] but is no longer accurate for v0.52.12, which has grown to include documentation references and dynamic guidelines [5].

3. **"saves 30-50% on token costs" for PI_CACHE_RETENTION** — No pi source makes any percentage savings claim. Additionally, Anthropic's extended cache *increases* cache write costs [4]. The net effect depends on usage patterns.

4. **"competes with (and often beats)" on benchmarks** — Zechner does not make this claim in prose. He presents results without explicit comparative ranking claims [1].

5. **Filter modes missing final state** — The complete sequence is `default → no-tools → user-only → labeled-only → all` [3]. The preliminary analysis omitted `→ all`.

6. **Compaction status** — The Nov 2025 blog states *"Missing compaction hasn't been a problem for me personally"* [1]. However, compaction is now fully implemented in v0.52.12 with manual and automatic modes [3, §Compaction]. The blog predates this feature.
