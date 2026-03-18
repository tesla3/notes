# Worklog — 2026-W12 (Mar 16–22)

> Current week. At week's end, move to `worklogs/2026-W12.md`.
> Past weeks: [`worklogs/`](worklogs/)

## 2026-03-18 — Discord FTC archive pipeline review

- Reviewed `discord-ftc-archive-pipeline.md` — found 15 gaps (dotnet priority, server name wrong, channel rename orphaning)
- Researched user token risk: March 2026 crackdown confirmed, DCE header fix PRs #1507/#1510 pending
- Evaluated 6 alternative tools — all use user tokens, no third path exists
- Created `research/discord-user-token-risk-assessment.md`
- **Decision:** bot token (ask admin) vs user token (alt account) — binary choice, unresolved
- **Next:** check DCE PR merge status, determine server size, decide on admin approach

## 2026-03-18 — Ghostty keybindings

- Attempted macOS-style keybinds on Ubuntu; confirmed GNOME doesn't grab the keys but needs restart
- Reverted custom keybinds; documented defaults in `ghostty-tips.md`
- Key learning: `Ctrl+<letter>` = ASCII control codes (to shell); macOS `Cmd` handled at GUI layer
- **Decision:** use defaults for now

## 2026-03-18 — Worklog cleanup

- Reviewed worklog against AGENTS.md spec — found 5 violations (verbosity, broken ordering, inconsistent format, missing Decision/Next, session numbering)
- Compressed all entries to ≤8 bullets; standardized `## YYYY-MM-DD — Topic` format
- Cross-checked all content between `worklog.md` and `worklogs/*.md` — found 21 research files only in weekly files, 1 entry missing from W11
- Compressed all 4 weekly files; merged missing entries both directions
- Set `worklog.md` to current-week-only with rotation procedure
- Updated `AGENTS.md` with weekly rotation instructions
- **Decision:** weekly files are canonical; worklog.md is current-week scratchpad

## 2026-03-17 — gpu-ubuntu setup

- Cloned repos from GitHub to `/home/hua/repos/`, symlinked into `/home/hua/pi-place/`
- Installed 9 pi extensions from shitty-extensions + agent-stuff packages
- Configured pi packages in `settings.json`, set context windows to 200K in `models.json`
