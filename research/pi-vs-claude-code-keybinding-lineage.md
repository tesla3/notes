# Pi vs Claude Code: Did Claude Code copy `Ctrl+G` / `Ctrl+O` from pi, or vice versa?

**Date:** 2026-05-03
**Question:** Have claude code copied many good features (such as `Ctrl+G`, `Ctrl+O`...) from pi agent or the other way around?

**Short answer:** **Pi copied them from Claude Code, not the other way around.** Both bindings shipped in Claude Code months before pi's public release, and pi's later additions match Claude Code's exact (non-readline-standard) semantics.

---

## Sources used

- `packages/coding-agent/CHANGELOG.md` in `badlogic/pi-mono` (3,105 lines, full history)
- `https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md` (recent versions)
- `https://claudelog.com/claude-code-changelog/` (full historical archive — used as primary timeline source)
- `https://developertoolkit.ai/en/claude-code/version-management/changelog/` (early version timeline back to v0.2.0)
- GitHub issues `anthropics/claude-code#9209`, `#9218`, `#8214`, `#18901` for cross-checking dates
- Reddit `r/ClaudeAI` threads on Ctrl+G (Oct 2025 / Nov 2025) for community-confirmation of feature timing

---

## Timeline

### `Ctrl+O` — collapse/expand tool output (and toggle verbose transcript)

| Date | Tool | Version | Event |
|---|---|---|---|
| 2025-03-25 | Claude Code | v0.2.54 | "Long Output: **Ctrl+R** reveals full tool output" — first incarnation, on Ctrl+R |
| **2025-09-13** | **Claude Code** | **v1.0.113** | **"Move `Ctrl+R` keybinding for toggling transcript to `Ctrl+O`"** — the binding we know today |
| 2025-09-26 | Claude Code | v1.0.123 | Issue #8214: `(ctrl+o to expand)` hint already widespread on Read tool |
| **2025-11-25** | **pi** | **v0.10.0** | **Initial public release of pi** (no Ctrl+O yet) |
| **2025-11-26** | **pi** | **v0.10.2** | **"Improved tool result display with collapsible output (default collapsed, expand with `Ctrl+O`)"** — added on day 2 of pi's existence |
| 2025-12-04 | pi | v0.12.8 | Fix: "Use CTRL+O consistently for compaction expand shortcut (not CMD+O on Mac)" |
| 2025-12-08 | pi | v0.14.0 | Bash mode added with same Ctrl+O preview/expand toggle |
| 2026-01-15 | pi | v0.46.0 | "Use configurable `expandTools` keybinding instead of hardcoded Ctrl+O" (PR #717 by @dannote) |
| 2026-03-21 | Claude Code | v2.1.81 | MCP read/search calls collapse; expand with `Ctrl+O` |
| 2026-03-25 | Claude Code | v2.1.83 | Transcript search inside Ctrl+O mode (`/`, `n`, `N`) |
| 2026-04-15 | Claude Code | v2.1.110 | `Ctrl+O` narrowed to "normal ↔ verbose transcript"; focus view split off into `/focus` |

**Gap: Claude Code → pi = ~10 weeks (2025-09-13 → 2025-11-26).**

### `Ctrl+G` — open prompt in external editor (`$VISUAL` / `$EDITOR`)

| Date | Tool | Version | Event |
|---|---|---|---|
| **2025-10-08** | **Claude Code** | **v2.0.10** | **"Press `Ctrl-G` to edit your prompt in your system's configured text editor"** — feature debut, alongside terminal-renderer rewrite |
| 2025-10-09 | Claude Code | v2.0.11 | Issues #9209, #9218 filed against the new feature (terminal-corruption bug, paste-expansion request) |
| ≈2025-10-28 | Claude Code | — | Reddit "Pro Tip: Use Ctrl+G…" post calling it a recently added feature |
| 2025-11-25 | pi | v0.10.0 | Initial release — **no Ctrl+G** |
| **2025-12-21** | **pi** | **v0.25.3** | **"External editor support: Press `Ctrl+G` to edit your message. Uses `$VISUAL` or `$EDITOR`…"** ([PR #266](https://github.com/badlogic/pi-mono/pull/266) by **@aliou**) |
| 2026-01-15 | Claude Code | v2.1.9 | Ctrl+G extended to AskUserQuestion "Other" input |
| 2026-03-03 | GitHub Copilot CLI | v0.0.421 | Adds Ctrl+G external editor (independent third party adopting the same convention) |
| 2026-03-07 | pi | v0.57.1 | Fixed Windows external editor launch for `Ctrl+G` (#1925) |
| 2026-03-25 | Claude Code | v2.1.83 | Added readline-native `Ctrl+X Ctrl+E` as an alias; **`Ctrl+G` still works** |
| 2026-04-15 | Claude Code | v2.1.110 | Option to include Claude's last response as commented context inside the Ctrl+G editor |

**Gap: Claude Code → pi = ~10.5 weeks (2025-10-08 → 2025-12-21).**

---

## Why this is "copying" rather than convergence

1. **Pi simply did not exist publicly when these landed in Claude Code.** Pi's first public release is `v0.10.0` on **2025-11-25**. Claude Code shipped Ctrl+O retitling on **2025-09-13** and Ctrl+G external editor on **2025-10-08** — both 2+ months earlier.

2. **The semantics are not Emacs/readline conventions.**
   - In readline, `Ctrl+G` is `abort` (cancel reverse-search, etc.), and the canonical "edit in `$EDITOR`" binding is **`Ctrl+X Ctrl+E`**. Claude Code chose the non-standard `Ctrl+G`, then added `Ctrl+X Ctrl+E` as an alias only later (2026-03-25, v2.1.83). Pi adopted the **same non-standard `Ctrl+G`** semantics — strong evidence it was matching Claude Code rather than reaching independently for a Unix convention.
   - `Ctrl+O` for "expand last tool result" is also not a readline convention; Claude Code itself moved it from `Ctrl+R` to `Ctrl+O` only in Sept 2025.

3. **The PR author confirms the direction.** Pi's Ctrl+G feature was contributed by [@aliou](https://github.com/aliou) in [pi PR #266](https://github.com/badlogic/pi-mono/pull/266) on 2025-12-21 — by which time Claude Code's Ctrl+G was a popular, widely-discussed feature (Reddit "Pro Tip" thread, multiple GitHub issues, etc.).

4. **Subsequent pi work tracks Claude Code's evolution.** Pi later made the binding configurable (v0.46.0, Jan 2026) and fixed Windows shell launching for `Ctrl+G` (v0.57.1, Mar 2026) — the same direction Claude Code took (configurable keybinds via `~/.claude/keybindings.json`).

---

## Where pi *did* push ahead independently

Fairness check — pi isn't only chasing. A few areas where pi shipped first or differently:

- **`Ctrl+I` to cycle models** — pi v0.10.2 (2025-11-26). Claude Code's equivalent (`Ctrl+P`/`Alt+P`) wasn't promoted until December 2025.
- **Fully user-configurable keybindings via `~/.pi/agent/keybindings.json`** — pi v0.46.0 (2026-01-15). Claude Code's `keybindings.json` arrived around v2.1.18 (similar timing, but pi's system is broader: includes digit keys `0-9`, kitty CSI-u and `modifyOtherKeys`).
- **`/tree` branch folding & segment-jump** with `Ctrl+←/→` and `Alt+←/→` — pi v0.57.1 (2026-03-07).
- **Multi-provider model abstraction (`-m provider/model@thinking`)** — pi v0.10.2; Claude Code is Anthropic-only.
- **RPC mode (JSONL on stdin/stdout)** — pi v0.10.3 (2025-11-28), well before ACP became a cross-vendor standard.

So the relationship is asymmetric but not one-way: pi inherits TUI-input conventions from Claude Code (the "obvious" stuff a user expects), and innovates around session/extension architecture and multi-provider plumbing.

---

## Bottom line

For the two specific bindings asked about — `Ctrl+G` and `Ctrl+O` — **pi follows Claude Code by ~10 weeks in both cases**, with semantics matching Claude Code's non-readline-standard choices. The reverse cannot be true: pi didn't exist when Claude Code shipped these. Both tools, in turn, are now influencing others (GitHub Copilot CLI added `Ctrl+G` external editor in March 2026, well after both).
