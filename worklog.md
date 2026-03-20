# Worklog — 2026-W12 (Mar 16–22)

> Current week. At week's end, move to `worklogs/2026-W12.md`.
> Past weeks: [`worklogs/`](worklogs/)

## 2026-03-20 — TBS Instagram college decisions update

- Re-scraped `@tbs26decisions` — still 44 posts, no new since Feb 16
- Screenshot-verified all 8 previously-⚠️ entries: all alt-text extractions were correct
- All 44/44 now fully ✅ screenshot-verified
- **Next:** Ivy Day imminent (late March) — check back for RD wave

## 2026-03-20 — PRS Instagram college decisions re-scrape

- Re-scraped `@prsdecisions2026` — 1 new post since Feb 17
- New entry: Ben Kinsley → Utah State University (Aviation Technology - Professional Pilot), Mar 11
- Total now 20 decisions across 18 universities
- RD wave not yet started; most RD results expected April–May
- **Next:** re-scrape again in mid-April when RD posts should be flowing

## 2026-03-20 — Tailscale mesh + discord-scrape on gpu-linux

- Set up Tailscale on gpu-linux (machine name: `nlp`) and intel-macbook-air (`jack-sparrow`)
- SSH access from macbook-air: `ssh hua@nlp`
- Developed `discord-scrape` on nlp using pi-coding-agent — downloads technical Discord channels
- Indexed scraped data with qmd for retrieval
- Code in private GitHub repo; tested with two analyses under `analysis/`

## 2026-03-20 — Ghostty SSH terminfo fix

- Delete key sending wrong escape sequence when SSH'd from macOS Ghostty to hua@nlp (GPU Linux)
- Root cause: remote missing `xterm-ghostty` terminfo entry (`'xterm-ghostty': unknown terminal type`)
- Fix: `infocmp -x xterm-ghostty | ssh nlp 'tic -x -'` from Mac copies terminfo to remote
- **Decision:** one-time fix per remote host; no alias override needed

## 2026-03-19 — HN distillation: scaling autoresearch + hn-distill skill update

- Distilled HN thread on SkyPilot's "Scaling Karpathy's Autoresearch" (58pts, 22 comments)
- Key finding: arxiv MCP (field report from [kraddypatties]) is the buried lede — real-time literature retrieval breaks agents out of weight-space recombination, addressing the actual bottleneck (knowledge, not compute)
- Karpathy showed up, conceded current behavior resembles autotuning but bet on trajectory
- Updated `~/.pi/agent/skills/hn-distill/SKILL.md`: added "What's Novel" section (guidelines + template)
  - Novelty criteria: specific/contextual, falsifiable, cited exactly, with implications developed
  - Distinct from insights (thread dynamics) — novelty is about the world
- Saved to `research/hn-scaling-autoresearch-skypilot.md`

## 2026-03-19 — HN distillation: web advertising dysfunction

- Distilled HN thread on Gruber's "Your Frustration Is the Product" (278pts, 172 comments)
- Key finding: paying subscribers still get full ad load (NYT $2B sub revenue, still stuffs ads)
- Best signal: donohoe's claim that cleaning up mobile pages *increased* ad revenue 30%
- Thread's blind spot: ad-tech intermediaries as the actual power center, not publishers
- Saved to `research/hn-your-frustration-is-the-product.md`

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
