← [Index](../README.md)

# Agent Skills: Architecture, Analysis, and Walkthrough

*February 2026*

## What Are Agent Skills?

Agent skills are **self-contained capability packages** — markdown files with optional scripts and assets — that teach a coding agent how to perform specific tasks. They follow the [Agent Skills standard](https://agentskills.io/specification), an emerging open specification for portable agent capabilities.

The core idea is **progressive disclosure**: only skill *names and descriptions* are injected into the system prompt at startup. The full skill instructions are loaded on-demand when the agent determines a task matches. This keeps the context window lean while enabling arbitrarily deep specialized workflows.

Think of skills as **documented APIs for LLMs** — except instead of function signatures, you write natural language instructions with code examples that the model follows step-by-step.

## How the Mechanism Works

```
Startup:
  1. Scan skill directories (~/.pi/agent/skills/, .pi/skills/, etc.)
  2. Parse SKILL.md frontmatter → extract name + description
  3. Inject <available_skills> XML block into system prompt
     (just names + descriptions, ~50-100 tokens per skill)

Runtime:
  4. User request comes in
  5. Model matches request against skill descriptions
  6. Model uses `read` tool to load full SKILL.md
  7. Model follows the instructions, invoking scripts via bash
```

**The matching is entirely LLM-driven.** There's no routing layer, no embedding similarity search, no classifier. The model reads the description and decides. This is both the strength (zero setup, handles fuzzy intent) and the weakness (model might not load the skill, or load the wrong one).

Fallback: users can force-load via `/skill:name` commands.

## Anatomy of a Skill

A skill is just a directory with a `SKILL.md`. Everything else is freeform.

```
my-skill/
├── SKILL.md              # Required: YAML frontmatter + markdown instructions
├── scripts/              # Helper scripts the agent invokes
├── references/           # Detailed docs loaded on-demand (progressive disclosure, again)
├── templates/            # Reusable patterns
└── assets/
```

### Required Frontmatter

```yaml
---
name: my-skill          # lowercase, hyphens, must match directory name
description: ...        # ≤1024 chars. This is what drives skill selection.
---
```

The description is the most critical field. It's what the model sees to decide whether to load the skill. Vague descriptions → skill never gets triggered. Overly broad descriptions → false positives.

## Skill Discovery Locations (Priority Order)

| Location | Scope |
|----------|-------|
| `~/.pi/agent/skills/` | Global (all projects) |
| `~/.agents/skills/` | Global (cross-harness standard) |
| `.pi/skills/` | Project |
| `.agents/skills/` (walk up to repo root) | Project hierarchy |
| `package.json` `pi.skills` | Package-declared |
| `settings.json` `skills` array | Explicit config |
| `--skill <path>` CLI flag | Per-invocation |

Notably, you can point pi at Claude Code's skills directory (`~/.claude/skills`) or Codex's (`~/.codex/skills`). The format is compatible. This is the cross-harness portability promise of the Agent Skills standard.

---

## Walkthrough: Simplest Skill — `commit`

The `commit` skill is the best example of a **pure-prompt skill**: no scripts, no dependencies, no setup. Just instructions.

### Full SKILL.md (36 lines)

```yaml
---
name: commit
description: "Read this skill before making git commits"
---
```

The body is pure natural-language workflow:

1. **Format rules**: Conventional Commits format (`type(scope): summary`)
2. **Behavioral constraints**: Don't push, don't add sign-offs, ask about ambiguous files
3. **Steps**: Review `git status`/`git diff` → infer scope → stage files → commit

### What Makes It Work

- **No code at all.** The skill is entirely "prompt engineering as a file." It steers the agent's existing `bash` tool (which can run `git`).
- **Description is a directive**, not a description: "Read this skill before making git commits." This works because the agent sees it in the system prompt and treats it as a standing instruction.
- **Constraints prevent common mistakes**: "Only commit; do NOT push" avoids the agent doing something destructive. "If ambiguous files, ask the user" prevents silent wrong commits.

### What It Teaches About Skills

The simplest skills are **behavioral overrides** — they don't add new capabilities, they add *judgment* and *protocol*. The agent already knows how to run `git commit`. The skill tells it *how you want it done*: your naming convention, your staging rules, your push policy.

This pattern generalizes: code review skills, documentation skills, testing skills. None need scripts. They're reusable prompt fragments with the structure to be conditionally loaded.

### Limitation

The description "Read this skill before making git commits" works as a standing instruction, but it relies on the model being compliant. There's no enforcement mechanism. A distracted model (deep in a long conversation, near context limits) might skip it. The `/skill:commit` command is the safety net.

---

## Walkthrough: Sophisticated Skill — `agent-browser`

The `agent-browser` skill is a **full automation framework** wrapped in skill format. It's the most complex skill in this installation and demonstrates the ceiling of what skills can do.

### Structure

```
agent-browser/
├── SKILL.md                              # ~350 lines of instructions
├── references/
│   ├── commands.md                       # Full command reference
│   ├── snapshot-refs.md                  # Ref lifecycle deep-dive
│   ├── session-management.md             # Parallel sessions, state
│   ├── authentication.md                 # Login flows, OAuth, 2FA
│   ├── video-recording.md               # Recording workflows
│   ├── profiling.md                      # Chrome DevTools profiling
│   └── proxy-support.md                  # Proxy configuration
└── templates/
    ├── form-automation.sh                # Ready-to-use form filling
    ├── authenticated-session.sh          # Login + state save
    └── capture-workflow.sh               # Content extraction
```

### The Architecture

`agent-browser` is a **CLI tool** that the skill teaches the agent to drive. The skill itself doesn't contain the CLI — it wraps an external `npx`-installable package. The SKILL.md is a comprehensive operations manual.

**Core workflow pattern:**

```
Navigate → Snapshot → Interact → Re-snapshot
```

The key innovation is the **ref system** (`@e1`, `@e2`, etc.):

```bash
agent-browser snapshot -i
# Output: @e1 [input type="email"], @e2 [button] "Submit"

agent-browser fill @e1 "user@example.com"
agent-browser click @e2
```

Traditional web automation (Selenium, Playwright) requires CSS selectors or XPath — brittle, verbose, and token-expensive for LLMs. The ref system compresses page state into ~200-400 tokens vs. 3000-5000 for raw DOM. This is purpose-built for the LLM context window constraint.

### Progressive Disclosure in Action

The SKILL.md is already ~350 lines. But the `references/` directory contains 7 more documents for specialized topics. The agent reads them on-demand:

```markdown
| Reference | When to Use |
|-----------|-------------|
| [references/commands.md](references/commands.md) | Full command reference |
| [references/authentication.md](references/authentication.md) | Login flows, OAuth, 2FA |
```

This is two-level progressive disclosure:
1. System prompt shows only name + description (~30 tokens)
2. Agent loads SKILL.md when needed (~350 lines)
3. Agent loads specific reference docs when the task demands it

### Sophistication Markers

1. **State management**: `agent-browser state save auth.json` / `state load auth.json` — the agent can persist browser sessions across runs. Auto-save/restore with `--session-name`.

2. **Parallel sessions**: Multiple isolated browser instances (`--session site1`, `--session site2`).

3. **Platform abstraction**: The same skill covers desktop Chromium *and* iOS Simulator (Mobile Safari via Appium).

4. **Visual diffing**: `diff snapshot` compares accessibility trees; `diff screenshot` does pixel-level visual regression with mismatch percentages.

5. **Security features**: Encrypted session state at rest (`AGENT_BROWSER_ENCRYPTION_KEY`).

6. **JavaScript bridge**: `agent-browser eval` runs arbitrary JS in the browser context, with careful shell-quoting guidance (`--stdin`, `-b` base64 mode).

7. **Ref lifecycle management**: The SKILL.md explicitly teaches the agent *when refs become invalid* and drills the "always re-snapshot after navigation" pattern. This is essential — it's the #1 failure mode if the agent doesn't understand it.

### What It Teaches About Skills

The `agent-browser` skill demonstrates that skills can wrap **entire tool ecosystems**. It's not just "here's how to do one thing" — it's a comprehensive operations manual with:
- Core workflows
- Advanced patterns
- Error handling guidance
- Behavioral rules (ref lifecycle)
- Layered reference documentation
- Ready-to-run templates

The skill format scales from 36-line behavioral overrides to 350+ line tool manuals with reference libraries.

---

## Comparative Analysis: The Skill Spectrum

### Spectrum by Complexity

| Skill | Lines | Scripts | Dependencies | Type |
|-------|-------|---------|-------------|------|
| `commit` | 36 | 0 | git (assumed) | Behavioral override |
| `github` | 40 | 0 | `gh` CLI | Cheat sheet |
| `youtube-transcript` | 25 | 1 (45 lines) | npm package | Wrapper |
| `brave-search` | 65 | 2 (130+80 lines) | npm + API key | Capability |
| `tmux` | 120 | 2 (bash) | tmux | Orchestration |
| `hn-distill` | 100 | 1 (200 lines) | Node.js | Workflow pipeline |
| `agent-browser` | 350+ | 3 templates, 7 refs | npx package | Full framework |

### Pattern Taxonomy

**1. Pure Prompt (commit, github)**
- Zero scripts. Instructions only.
- Steers existing tools (git, gh).
- Low maintenance. Portable across any agent with bash.

**2. Thin Wrapper (youtube-transcript, brave-search)**
- Small scripts that call external APIs.
- The SKILL.md is mostly "here's the CLI, here are the options."
- Value is in making external data sources accessible to the agent.

**3. Orchestration (tmux)**
- Teaches the agent to drive a complex interactive system.
- Contains procedural knowledge: "send keys, wait for prompt, then send more keys."
- The scripts are helpers (wait-for-text.sh), not the main capability.

**4. Multi-Step Pipeline (hn-distill)**
- Defines a multi-step research workflow: fetch article → fetch thread → fetch high-signal links → analyze → save.
- The fetch script is substantial (200 lines, concurrent HN API calls).
- The analysis instructions are the real value — they encode editorial judgment.

**5. Full Framework (agent-browser)**
- Wraps an entire external tool with its own paradigm (ref system).
- Layered docs, templates, advanced patterns.
- Closest to what you'd get from a plugin system in traditional software.

---

## Critical Assessment

### What's Good

**1. Elegant simplicity.** Skills are just markdown files. No SDK, no compilation, no registration API. A text editor is the IDE. This is the right level of abstraction for the current moment — we don't need more framework complexity.

**2. Progressive disclosure is genuinely well-designed.** The three-tier approach (description in prompt → SKILL.md on load → references on demand) is the best answer I've seen to the context window problem for agent capabilities. Compare this to cramming everything into a system prompt (what most agent frameworks do).

**3. Cross-harness portability.** Pi can consume Claude Code skills and vice versa. The Agent Skills standard at agentskills.io is minimal enough to be implementable across tools. Whether this actually becomes a standard depends on adoption, but the design is right.

**4. Composability.** The `hn-distill` skill calls into `brave-search`'s scripts for content fetching. Skills can reference each other without formal dependency management. It works because everything is file paths.

**5. Low barrier to entry.** You can create a useful skill (like `commit`) in 5 minutes. The format doesn't demand ceremony.

### What's Problematic

**1. LLM-driven routing is unreliable.** The model reads descriptions and *decides* whether to load a skill. It can fail to match, match the wrong skill, or forget to load the skill during long conversations. There's no fallback beyond the user manually typing `/skill:name`. For critical workflows (like commit conventions), this is a real gap. Anthropic's Claude Code has the same problem — it relies on the model's compliance.

**2. No dependency management.** Skills reference scripts by file path, and those scripts have their own dependencies (`npm install`). There's no lockfile, no version pinning across skills, no way to declare "this skill requires Node.js >= 20." The setup sections say "run `npm install`" — but who runs it? When? The agent can, but it's a runtime surprise. Compare to MCP servers which at least have `package.json` with explicit dependencies.

**3. No testing or validation framework.** You can write a skill that gives the agent terrible instructions, and nothing catches it. There's YAML frontmatter validation (name format, description length), but zero validation of whether the skill's instructions actually work. No way to write a test that says "given this user request, the agent should load this skill and produce this outcome."

**4. Security model is "trust the file."** The docs say "review skill content before use," but skills can instruct the agent to execute arbitrary code. A malicious skill in a shared repository could tell the agent to exfiltrate data, modify files, or install backdoors. The `allowed-tools` frontmatter field is experimental and doesn't provide real sandboxing. This is comparable to npm's `postinstall` script problem but worse — the "scripts" are natural language instructions to an agent with shell access.

**5. Description-driven selection creates adversarial dynamics.** If two skills have similar descriptions, the model picks unpredictably. Skill authors have an incentive to write broad, SEO-style descriptions to maximize their skill's activation. The spec caps descriptions at 1024 chars but doesn't address semantic overlap.

### Compared to Alternatives

**vs. MCP (Model Context Protocol):** MCP provides typed tools with JSON schemas. Skills provide untyped natural-language instructions. MCP is more rigorous but heavier — you need a server process. Skills are lighter but less reliable. For structured API calls, MCP wins. For teaching complex workflows (like how to use tmux for debugging), skills win. They solve different problems and are complementary.

**vs. Custom System Prompts / AGENTS.md:** Skills are basically modular AGENTS.md fragments with on-demand loading. The key advantage over monolithic AGENTS.md is context efficiency — you don't pay tokens for capabilities you're not using. The disadvantage is the routing uncertainty.

**vs. Function Calling / Tool Use:** Skills *use* tool calling (the agent calls `bash` to run scripts) but they're at a higher level of abstraction. A tool is "run this function." A skill is "here's a multi-step procedure using multiple tools." Skills are closer to SOPs (Standard Operating Procedures) than to function definitions.

**vs. OpenAI's GPT Actions / Plugins (deprecated):** GPT Actions were API-schema-driven, server-hosted, and centrally registered. Skills are file-based, local-first, and decentralized. Skills are more flexible but less discoverable. The GPT plugin ecosystem died partly because the centralized marketplace model didn't work. Skills' decentralized approach may have better staying power.

---

## Meta-Observation

The most interesting thing about agent skills is what they reveal about the current state of AI coding agents: **the bottleneck is not capability but workflow knowledge.** The agent can already run any shell command. What it lacks is the *judgment* of when to run which command, in what order, with what error handling. Skills are structured knowledge injection — they're closer to training data than to plugins.

This suggests skills are a transitional technology. As models get better at autonomous task decomposition and tool discovery, the need for hand-written step-by-step instructions should decrease. But right now, in February 2026, the models still benefit enormously from being told "after you click a link, you MUST re-snapshot to get new refs." That kind of procedural knowledge isn't in the training data because the tools are too new.

The best skills (like `hn-distill`) encode *editorial judgment*, not just procedural steps. That kind of knowledge won't be obsoleted by better models — it's domain expertise compressed into a format agents can consume. That's where the lasting value is.
