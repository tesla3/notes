# Worklog

## 2026-02-17 (session 4)

### Cleanup: Removed MD-TUI

- **Removed** `/usr/local/bin/mdt` (MD-TUI v0.9.4) — Glow is the preferred markdown renderer
- No config files or dotfile references existed, clean removal
- Updated `terminal-markdown-renderers.md` to reflect removal
- **Found:** `google-ai-research.md` has uncommitted edits from session 3 (still unstaged)

---

## 2026-02-17 (session 3)

### models.json + Research Consistency

- **Trimmed** Google models in `~/.pi/agent/models.json` to free-tier-only
- **Dropped** `gemini-3-flash-preview` — preview/unstable, no rate limit guarantees
- **Dropped** `gemini-2.5-pro` — consistently returns `limit: 0` on this key across two separate live tests; likely per-project block from Dec 2025 crackdown (globally documented as 100 RPD free, but not for this project)
- **Final models.json:** `gemini-2.5-flash` (250/day) + `gemini-2.5-flash-lite` (1000/day) — both confirmed working
- **Edited** `google-ai-research.md` to be consistent: 2.5-pro listed as blocked on this key with explanation, free tier table shows only confirmed-working models — ⚠️ **changes were not committed** (still unstaged)
- **Lesson:** Live API test (`limit: 0`) is more reliable than blog posts for per-key availability; `limit: 0` ≠ transient, means zero quota allocation

---

## 2026-02-17 (session 2)

### Google AI Research & Gemini Key Diagnosis

- **Researched** Google's latest LLM landscape for early 2026 via Brave Search
  - Gemini 3 Pro is flagship: #1 LM Arena (1490 score), 1M context, 1T+ params, $2/$12 per M tokens
  - Gemini 3 Flash Preview available free; Gemini 2.5 Flash still best free workhorse
  - Benchmarks: Gemini 3 Pro tops ECI, AA Intelligence Index, AA Coding Index
  - Competitive landscape: Grok 4.1 (#2), Claude Opus 4.5 (#1 coding), GPT-5.1 (#9)
- **Diagnosed Gemini API key** — key is valid, issue is `limit: 0` on free tier for several models
  - Free tier working: `gemini-2.5-flash`, `gemini-2.5-flash-lite`, `gemini-3-flash-preview`, all `gemma-3-*` models
  - Paid only (limit=0): `gemini-2.5-pro`, `gemini-3-pro-preview`, `gemini-2.0-flash`, `gemini-2.0-flash-lite`
  - Deprecated: `gemini-2.5-flash-preview-09-2025` (404)
  - Total models accessible via key: 45
- **Saved** research to `notes/google-ai-research.md`

### Notes Repo

- **Created** `tesla3/notes` GitHub repo to track all research notes
- **Committed** initial files: `google-ai-research.md`, `terminal-markdown-renderers.md`
- **Pushed** `google-llm-research-2026-02.md` as follow-up commit
- Repo: https://github.com/tesla3/notes

---

## 2026-02-17

### Terminal Markdown Renderer Research & Setup

- **Researched** all major terminal markdown renderers: Glow, mdcat, MD-TUI, Rich/rich-cli, Frogmouth, bat, Termimad, Glamour, marked-terminal, pandoc+w3m
- **Checked** GitHub stats, open bugs, maintenance status, real user complaints for each
- **Critical review** exposed key tradeoffs:
  - Glow: prettiest, most popular, but Glamour engine has 4+ year old rendering bugs (lists, blockquotes, code blocks). No streaming.
  - mdcat: most correct (CommonMark), inline images, but archived/dead (Jan 2025)
  - MD-TUI: best navigation (link selection mode), but custom non-compliant parser, AGPL, small community
  - Rich: best Python library, streaming coming via Textual, but slow startup
  - No tool is simultaneously correct, pretty, fast, interactive, and maintained
- **Saved** full research to `notes/terminal-markdown-renderers.md`

### Installations

- **Installed MD-TUI** v0.9.4 — downloaded release binary to `/usr/local/bin/mdt` *(removed in session 4)*
- **Installed Glow** v2.1.1 — via `brew install glow`
- **Winner: Glow** after hands-on testing

### Dotfiles (chezmoi → tesla3/dotfiles)

- Added `alias glow='glow -w 0 -p'` to `.zshrc` (full terminal width + pager)
- Cleaned up wrong config path (`~/.config/glow/`) — glow on macOS uses `~/Library/Preferences/glow/`
- Left default glow config untouched, preferences expressed via alias
- Committed and pushed to dotfiles repo

### Google Gemini LLM Research & Setup

- **Deep research** on Google's LLM offerings using Brave Search (multiple queries, content extraction)
  - Surveyed all Gemini models: 3 Pro Preview, 3 Flash Preview, 2.5 Pro, 2.5 Flash, 2.5 Flash-Lite, 2.0 Flash, 2.0 Flash-Lite
  - Compared pricing across Google, OpenAI, Anthropic, xAI
  - Analyzed free tier limits, December 2025 rate cut incident, consumer subscription plans
  - Key finding: Google's free tier is the most generous in the industry (no credit card, 1M context, 100-1,000 RPD)
  - Key finding: Flash-Lite models are 10-100× cheaper than competing frontier models
- **Saved research** to `notes/google-llm-research-2026-02.md`
- **Set up Gemini API key** in `~/.zshrc` (`GEMINI_API_KEY`)
- **Verified API access** — confirmed 30+ models available including Gemini 3 Pro/Flash, 2.5 Pro/Flash, Nano Banana, Deep Research, Gemma, TTS
- **Configured pi** with 5 Gemini models in `~/.pi/agent/models.json` using `google-generative-ai` API type:
  - Gemini 2.5 Flash, 2.5 Pro, 2.5 Flash-Lite, 3 Pro Preview, 3 Flash Preview
