# Worklog

> **Note:** File paths in entries before 2026-02-17 session 7 refer to the flat structure
> before the notes reorg. See [README.md](README.md) for current file locations.

## 2026-02-19 (session 9)

### Dotfiles/Setup Audit

- **Audited** dotfiles and installed tools against worklog history
- **Verified OK:** mdt removed, web-search.json deleted, glow v2.1.1 installed, glow alias correct, glow config at correct macOS path with defaults, `~/.config/glow/` gone
- **Found 2 drift items (no action taken):**
  - `~/.pi/agent/models.json` — completely missing, not just emptied of Google models as worklog implied
  - `GEMINI_API_KEY` in `~/.zshrc` — fully removed, not commented out as worklog stated

---

## 2026-02-18 (session 8)

### Integrate 16 New Research Files

- **Created** `topics/software-factory.md` — dark factory thesis, StrongDM forensics, verification/alignment, maximum-leverage design
- **Expanded** `topics/coding-agents.md` — added agent landscape (Feb 2026), tool comparisons, practitioner evidence (METR study), context engineering sections; linked 12 research files total
- **Updated** `topics/llm-models.md` — added Sonnet 4.6 to landscape table, linked analysis
- **Updated** `README.md` — added software-factory topic, added "Other Research" section for 4 unlinked files (Fowler ×2, Schillace, careers)
- **Moved** `pi-terminal-bench-research.md` → `research/pi-terminal-bench.md`
- **Added** backlink headers to all 16 new research files
- **Key decisions:** steipete and critical-review-v3 go under coding-agents (practitioner evidence, not factory); Fowler/Schillace/careers stay unlinked (no natural cluster yet); software-factory topic kept tight (4 files)

---

## 2026-02-17 (session 7)

### Notes Reorganization

- **Restructured** notes/ from flat 8-file dump into 3-layer system: README → topics → research
- **Created** `README.md` — active stack dashboard, topic map, conventions
- **Created** `topics/llm-models.md`, `topics/coding-agents.md`, `topics/dev-tools.md` — decision summaries with links to research
- **Moved** 8 research files into `research/` with backlinks to parent topic pages
- **Key decisions:** kept Google files separate (operational vs market research), kept Pi conversation intact (already well-structured), dev-tools.md is a routing page not unified analysis
- **Added** conventions for future notes: research/ first, topic pages when clusters form, README on decision changes
- **Renamed** INDEX.md → README.md for GitHub rendering, updated all 12 internal links
- **Review pass:** removed duplicated landscape content from api-key file, fixed stale INDEX refs, clarified titles, added 2.5 Pro key-block warning to market file
- **Added** `AGENTS.md` — agent instructions covering reading/writing protocol, update direction, style, non-obvious file relationships

---

## 2026-02-17 (session 6)

### Pi & Terminal-Bench Research

- **Researched** why pi coding agent is not on the Terminal-Bench leaderboard
- **Finding:** results were submitted via email but likely never processed/added by Terminal-Bench team
- **Credibility assessment:** high — reproducible, open-source adapter, automated verification, public results.json
- **Saved** research to `notes/pi-terminal-bench-research.md`
- **Follow-up research:** has anyone run updated pi against TB? Answer: **no**
  - HN thread (Feb 11) shows community noticed pi's absence, speculating about it
  - Mario on OSS vacation until Feb 23; adapter stale; no community runs
  - oh-my-pi fork ran custom react-edit-benchmark (not TB) — found harness changes swing scores 5–14pp
  - Updated research note with full section on this

---

## 2026-02-17 (session 5)

### Cleanup: Removed Google Models & API Keys

- **Removed** all Google models from `~/.pi/agent/models.json` (gemini-2.5-flash, gemini-2.5-flash-lite) — free tier quality too low for coding
- **Commented out** `GEMINI_API_KEY` export in `~/.zshrc`
- **Deleted** `~/.pi/web-search.json` — orphaned file, verified nothing reads it (not pi agent, not brave-search skill, not pi-ai SDK)
- Key left intact in `.zshrc` (commented) for potential future re-enable

---

## 2026-02-17 (session 4)

### Cleanup: Removed MD-TUI

- **Removed** `/usr/local/bin/mdt` (MD-TUI v0.9.4) — Glow is the preferred markdown renderer
- No config files or dotfile references existed, clean removal
- Updated `terminal-markdown-renderers.md` to reflect removal
- **Found:** `google-ai-research.md` had uncommitted edits from session 3 *(committed in session 5)*

---

## 2026-02-17 (session 3)

### models.json + Research Consistency

- **Trimmed** Google models in `~/.pi/agent/models.json` to free-tier-only
- **Dropped** `gemini-3-flash-preview` — preview/unstable, no rate limit guarantees
- **Dropped** `gemini-2.5-pro` — consistently returns `limit: 0` on this key across two separate live tests; likely per-project block from Dec 2025 crackdown (globally documented as 100 RPD free, but not for this project)
- **Final models.json:** `gemini-2.5-flash` (250/day) + `gemini-2.5-flash-lite` (1000/day) — both confirmed working
- **Edited** `google-ai-research.md` to be consistent: 2.5-pro listed as blocked on this key with explanation, free tier table shows only confirmed-working models *(committed in session 5)*
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

## 2026-02-21

- **HN distill:** [Car wash reasoning failure thread](research/hn-llm-car-wash-reasoning.md) (47031580, 1511pts/948 comments)
  - Key finding: failure is premature token commitment + post-hoc rationalization, not reasoning incapacity
  - Spot-patching cycle already in progress (TikTok viral → models patched → trivial variants bypass patch)
  - Best thread insight: System 1/2 framing as cost optimization by providers (keeda)
- **HN distill:** [Ring/Nest surveillance state thread](research/hn-ring-nest-surveillance-state.md) (47023238, 935pts/663 comments)
  - Key finding: AnthonyMouse's selective enforcement model explains the "total surveillance + rampant crime" paradox
  - Voluntary compliance with admin subpoenas is the actionable lever nobody focuses on
  - ~20% of thread wasted on Greenwald credibility debate, functioning as surveillance-critique deflection

## 2026-02-21
- **Research:** [Pacific Ridge School critical analysis](research/pacific-ridge-school.md) — deep dive on college placement
  - Key finding: PRS sends ~1–2% to T25 vs Bishop's ~19%, Parker ~17%, LJCDS ~12% — order-of-magnitude gap at similar tuition
  - HYPSM: ~0.9–1.3% (≈1 student/year). MIT notably absent from entire matriculation list
  - AP scores strong (72% at 4-5), suggesting good instruction but weak college outcomes driven by 90% acceptance rate, youth (est. 2007), and less selective student body
  - Community colleges (MiraCosta, Palomar) appear with asterisks on matriculation list — unusual for $45K school
  - Verdict: B+ school at A+ prices. Good holistic experience, poor placement ROI vs peers
- **Research (Rev 3):** Recut PRS analysis to T20 using US News 2026 rankings
  - UC Berkeley (#15) and UCLA (#17) enter T20; Georgetown, Emory, UVA, USC drop out
  - PRS T20: 6.5–9.0% (nearly unchanged from T25). Bishop's 30%, Parker 19%, LJCDS 18%
  - Interesting dynamic: Parker *gains* under T20 (Berkeley is its largest feeder at 23), Bishop's *loses* (USC 24-student pipeline drops out)
  - Extracted all four school PDFs via PyMuPDF for exact counts; found PRS website vs PDF data discrepancies (Harvard/Yale asterisk swap, Duke/Notre Dame present on website but not PDF)
  - Updated PRS profile stats: SAT middle 50% now 1150–1450, 4 college counselors for 108 seniors
