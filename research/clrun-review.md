← [Index](../README.md)

# Review: clrun — The Interactive CLI for AI Agents

**Source:** [GitHub](https://github.com/cybertheory/clrun) · [Website](https://www.commandline.run) · [npm](https://www.npmjs.com/package/clrun) · [PyPI](https://pypi.org/project/clrun-cli/)
**Author:** Rishabh Singh (cybertheory)
**Reviewed:** Feb 21, 2026

## What It Is

clrun wraps interactive terminal programs (TUI scaffolders, dev servers, prompts) in a structured interface for AI agents. You run `clrun "npx create-vue@latest"`, get back a YAML response with a terminal ID and the current screen output, then interact with `clrun <id> "my-project"` or `clrun key <id> down down enter`. Sessions persist, suspend after idle, and auto-restore on input. Available as both npm and PyPI packages.

The problem it targets is real: AI agents choke on interactive CLIs. When Claude Code hits a `create-vue` prompt asking you to pick a framework with arrow keys, it's stuck. The standard workaround — `--yes` flags, non-interactive modes, piped configs — doesn't exist for every tool.

## The Facts

- **Created:** February 15, 2026 (6 days before this review)
- **Commits:** 23 total, from initial commit to full website + dual-language support in ~48 hours
- **Every single commit** is co-authored by `Cursor <cursoragent@cursor.com>`
- **GitHub:** 2 stars, 0 forks, 0 issues
- **npm downloads:** 0/day except 104 on Feb 15 (launch) and 88 on Feb 17 — likely the author's own installs and CI
- **GitHub description** contains the typo "Interqactive" — nobody caught it because there are no users
- **Test suite:** ~10 integration tests, all happy paths
- **Author's other recent repos:** `swp` (Feb 22), `mailroom_cli` (Feb 20), `x402` (Dec 2025), `mcpkit` (Sep 2025) — a pattern of rapid project creation targeting trending keywords

## Architecture

File-based state in `.clrun/`:
- `sessions/<id>.json` — metadata
- `queues/<id>.json` — input queue
- `buffers/<id>.log` — raw PTY output
- `ledger/events.log` — audit trail

Node.js uses `node-pty` for PTY management; Python uses `pexpect`. Both spawn a detached worker process per session. Sessions auto-suspend after 5 min idle by capturing env vars and cwd, killing the PTY, then re-spawning and re-exporting everything on next input.

## What's Good

**1. The problem framing is correct.** Interactive CLIs are a genuine gap for AI agents. `--yes` flags don't exist universally, and blind keystroke injection via `expect` scripts requires knowing the exact prompt sequence in advance. A structured intermediary that shows the agent what's on screen and accepts named keystrokes is a legitimate design.

**2. The YAML response format with hints is well-designed.** Every response tells the agent what to do next with copy-pasteable commands. Error responses include alternatives and recovery steps. This is the right level of hand-holding for an LLM that can't remember state between calls.

**3. The TUI interaction table is genuinely useful reference material.** The mapping of visual patterns (`●`, `◻`, `◆`) to action types (single-select, multi-select, text input) is a concise knowledge artifact. Even if you never use clrun, that table is worth stealing for any agent-TUI integration.

**4. The queue system with priority and override is thoughtful.** Letting agents cancel all pending inputs and send an override is the right escape hatch for when an agent's mental model of the interaction diverges from reality.

## What's Bad

**1. Documentation-to-substance ratio is pathological.** The repo has ~120 files. The actual core logic is maybe 12 TypeScript files. The rest is: a Next.js marketing website with shadcn components, the same skill definition duplicated in 5+ locations (root SKILL.md, skills/clrun/SKILL.md, plugins/clrun-skill/skills/clrun/SKILL.md, website/public/skills/*, .claude-plugin/), separate "integration guides" for Claude Code and OpenClaw, llms.txt and llms-full.txt, and a `.cursor/rules` directory. This is a documentation edifice built for a tool that has 2 stars and zero real users. The effort allocation reveals priorities: this is a marketing project, not an engineering project.

**2. File-based locking for PTY multiplexing is inherently fragile.** The lock manager uses JSON files with PIDs for coordination. This breaks under: concurrent access (TOCTOU races between reading and writing session files), abnormal termination (stale locks, orphaned workers), NFS/network filesystems, and any situation where two agents or processes interact with the same session. The "crash recovery" is just checking if PIDs are still alive. Real PTY multiplexers (tmux, screen) solved these problems decades ago with Unix domain sockets and proper IPC.

**3. The suspend/restore mechanism is optimistic to the point of naivety.** When suspending, it captures env vars by running `env` in the shell and parsing the output, then kills the PTY. On restore, it spawns a fresh shell and re-exports everything. This approach:
   - Loses shell functions, aliases, and non-exported variables
   - Loses any in-process state (a node REPL, a Python shell, a running server)
   - Has a hardcoded 600ms wait for "shell to flush state files" — a magic number that will fail under load
   - Doesn't validate that the restored environment is correct
   - Can't restore a TUI that was mid-interaction (the whole point of the tool)

   The auto-suspend is a feature that sounds good in docs but would break in practice for exactly the use cases clrun is designed for.

**4. The Python port is premature scaling.** Two days after initial commit, with zero users, the author created a full Python reimplementation with identical architecture. This doubles the maintenance surface for no benefit — nobody is blocked on "I need this in Python." The pexpect-based version has a different processing interval (100ms vs 200ms) and no Windows support, which means "identical CLI" is aspirational.

**5. Aggressive auto-installation of skill files.** v1.1.0 (2 days in) auto-installs skill markdown files into global agent directories (`~/.claude/skills/`, etc.) on first run. Writing to a user's home directory structure without explicit consent is hostile behavior, especially from a tool with no track record.

**6. The test suite tests existence, not behavior.** 10 integration tests verify happy paths: "echo works," "env vars persist," "kill works," "YAML parses." Zero tests for: concurrent sessions, suspend/restore round-trip fidelity, actual TUI interaction (select lists, checkboxes), queue priority ordering, crash recovery, race conditions, long-running processes, or the Python implementation. The README claims "50 tests (unit + integration)" but the repo contains 4 test files.

**7. No Windows support for Python, questionable for Node.** The Python version explicitly doesn't support Windows. The Node version uses `node-pty` which technically works on Windows but the worker uses Unix assumptions (shell detection via `$SHELL`, `env` command parsing). The skill documentation doesn't mention this limitation.

## Competitive Landscape

clrun competes against approaches that actually work today:

| Approach | Maturity | Tradeoff |
|----------|----------|----------|
| **tmux + scraping** (e.g., pi's tmux skill) | Decades | Battle-tested, universal, but output is unstructured text |
| **expect/pexpect** | Decades | The standard for automating interactive programs; requires knowing prompts in advance |
| **`--yes` / non-interactive flags** | Universal | The production answer when available; not universal |
| **Tool-specific config files** | Per-tool | `create-vue` accepts `--default`, Vite has config files — most tools have non-interactive paths |
| **Agent framework built-ins** | Varies | Claude Code, Cursor, etc. already handle basic terminal execution |

clrun's differentiator vs. tmux-scraping is structured YAML output and named keystrokes. That's a real advantage *if* it works reliably. But reliability is exactly what's unproven.

## The Meta-Irony

This project is a case study in the exact phenomenon the [Show HN drowning thread](https://news.ycombinator.com/item?id=47045804) describes. Consider:

- Vibe-coded in a weekend (every commit co-authored by Cursor)
- First commit to published npm package + marketing website in under 3 hours
- Typo in the GitHub description that no human proofread
- Documentation volume optimized for LLM consumption (llms.txt, multiple skill formats, YAML everywhere) rather than human evaluation
- Zero organic adoption signal — the docs are written for users that don't exist
- The author is simultaneously churning out `swp`, `mailroom_cli`, and other agent-infrastructure projects at the same velocity

This isn't necessarily bad — rapid prototyping to validate an idea is fine. But the *presentation* claims production-grade ("Persistent. Deterministic. Agent-Native.") when the reality is a 6-day-old prototype that has never been used by anyone other than its author.

## Verdict

The problem is real, the API design is decent, and the TUI interaction reference table is genuinely useful. But clrun is a marketing surface wrapped around an untested prototype. The engineering shortcuts (file-based locking, optimistic suspend/restore, no real test coverage) are exactly the ones that matter for a tool whose value proposition is *reliability* in interactive terminal sessions. You can't sell "deterministic" when your locking mechanism has TOCTOU races.

If this were presented as "here's a weekend prototype exploring structured agent-TUI interaction" it would be a solid proof of concept. Presented as production infrastructure with a marketing site, llms.txt, and global auto-installation — it's resume-driven development targeting the agent-tooling hype cycle.

**Would I use it?** No. tmux + scraping is ugly but battle-tested. The idea deserves better execution — by someone willing to spend months, not hours, on the hard parts (reliability, concurrency, cross-platform PTY management). The TUI pattern table is worth bookmarking regardless.
