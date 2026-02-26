# Worklog

> **Note:** File paths in entries before 2026-02-17 session 7 refer to the flat structure
> before the notes reorg. See [README.md](README.md) for current file locations.

## 2026-02-24

- Deep research: "Who are the most accurate long-range (10+ year) predictors?"
- Searched and analyzed: Dan Luu's futurist scoring, Tetlock's superforecasting research, Open Philanthropy's long-range forecasting feasibility study, Samotsvety, IPCC climate models, Cold Takes futurist track record analysis
- Key finding: **Nobody has a rigorously verified track record for 10+ year predictions.** Climate models are the sole exception (physics-based, 30+ year verified accuracy). All other "great predictors" are either validated at short horizons only (superforecasters: ~1yr) or scored by cherry-picked anecdotes.
- Hierarchy: IPCC > deep domain experts (Gates/MS 1990s) > foxes/superforecasters > Asimov (~50% on 50yr) > professional futurists (Kurzweil ~7%, Kaku ~3-6%)
- Saved to `research/long-range-prediction-accuracy.md`
- Follow-up: what Samotsvety + Tier 3 predictors (Caplan, Yegge, Asimov) say about AI
- Samotsvety: 31% AGI by 2030, 63% by 2050, 81% by 2100 (Jan 2023 update). Epoch AI rated them best judgment-based AGI forecast.
- Caplan: about to lose his first-ever public bet (AI exam bet), unprecedented signal. Still bets against extinction.
- Yegge: all-in on AI coding transformation, predicts 50% engineering cuts, "big companies are doomed"
- Key finding: every forecasting group without exception shortened AI timelines 2022→2025. The convergence is the strongest signal.
- Saved to `research/ai-predictions-best-forecasters.md`

## 2026-02-23 — Session 2

- Distilled HN thread: "Pi – A minimal terminal coding harness" (202 pts, 92 comments)
  - Saved to `research/hn-pi-minimal-terminal-coding-harness.md`
  - Fetched and analyzed article (pi.dev), can1357's "harness problem" blog post, thevinter's negative experience report
- Cross-referenced against insights.md and additional_insights.md — found 7 deeper structural connections:
  - Hashline as Prompt Expansion at tool boundary; recursive Naur's Nightmare (living software = 3rd theory-less layer)
  - LISP Curse at tool layer; Knowledge Integration Decay explains small-prompt advantage
  - Hidden Denominator made visible via thevinter; Fixed-Point Workflow validated (Plan.md despite omission)
  - Approval Fatigue validates Pi's no-popups stance
- Updated: topics/coding-agents.md (new research link)
- No new insights promoted — connections deepen existing entries

## 2026-02-23 — Session 1

- Deep critical review of pi_agent_rust (Dicklesworthstone's Rust port of Pi Agent)
- Key findings: 556K lines of Rust in 23 days, 79% Claude co-authored, contains "phantom complexity" — modules named after advanced CS concepts (AMAC, trace-JIT, io_uring, S3-FIFO, e-graphs) that don't implement what their names claim
- Central critique: AMAC "interleaving" is a sequential loop; "JIT" can't exist under `forbid(unsafe_code)`; io_uring module explicitly disclaims doing any io_uring; S3-FIFO cache for a system processing ~5 calls/second
- Also flagged: 48K-line single file, custom async runtime (asupersync) with zero external users, MIT+Anthropic-exclusion license on 79% Claude-generated code, benchmark methodology gaps
- Saved to `research/pi-agent-rust-review.md`

## 2026-02-22 — Session 1

- Distilled HN thread on DuckDB as first choice for data processing (310pts, 119 comments)
- Key findings: real moat is relational guarantees not speed, SQL-vs-dataframes debate conflates declarative with SQL, Ibis emerges as thread's implicit answer, governance advantage underappreciated
- Saved to `research/hn-duckdb-first-choice-data-processing.md`, linked from README

## 2026-02-22 — Session 14 (HN distill: Skip open source + Solow critique)

- Distilled HN thread on Skip going free & open source (515pts, 226 comments)
- Created `research/hn-skip-open-source.md`
- Key insights: LGPL-3 license choice creates enterprise friction vs. permissive-licensed competitors; no production case studies after 3 years; Liquid Glass as competitive wedge is a bet on Apple's design instability; paid dev tools are dead but sponsorship model has no successful precedent for frameworks
- Updated README with link
- Added critical evaluation of Solow Paradox analogy to `research/coding-agents-insight-inventory.md` (Pattern E + open question #6)
  - Six structural problems: survivorship bias in analogy selection, different mechanisms (new capabilities vs. speed-up), unfalsifiable timeline, AI-broadly vs. AI-coding conflation, simpler explanation (no paradox needed), rapid model change breaks the frame
  - Verdict: descriptively accurate, predictively weak

## 2026-02-21 — Session 13 (NanoClaw deep dive)

- Created `research/nanoclaw-deep-dive.md` — comprehensive analysis of NanoClaw
- Covers: architecture, security model (container isolation vs app-level), skills-over-features contribution model, competitive landscape, red flags, Cohen's AI-native coding philosophy
- Key finding: genuinely improves blast radius but doesn't solve prompt injection or network exfiltration; VentureBeat coverage was PR-placed
- Cross-linked from Karpathy Claws thread, added to coding-agents topic page and README
- Sources: GitHub, nanoclaw.dev, The New Stack interview, fumics.in analysis, VentureBeat, HN threads, Reddit

## 2026-02-21 — Session 12 (continued Bishop's scrape)

- **Critical correction:** `@tbsdecisions2026` is NOT The Bishop's School (La Jolla) — it's a different school entirely
- Correct account: `@tbs26decisions` — discovered from crashed session's /tmp screenshots
- Salvaged 36 screenshots from /tmp/tbs_*.png (from crashed session)
- Read all 36 screenshots via vision, compiled full dataset
- Scrolled Instagram grid to find 8 additional posts missed by screenshots:
  - **Ariadne Georgiou → Harvard** (Government & Ethnicity, Migration, Rights) — Jan 7, 2026
  - Ella Kaminsky → Northeastern (Business Admin), Wyatt Stone → Duke (Mech Eng), Kayla Pfefferman → GW (Marketing)
  - Connor Gutierrez → Santa Clara (Finance), Penelope Fountain → Alabama (Comms/Pre-Law)
  - Kaylee Yen → NYU (Undecided), Brandon Agbayani → Santa Clara (Business Econ)
- Total: **44 decisions across 28 universities** (36 verified from screenshots, 8 from alt-text needing confirmation)
- Updated `tbs-class-2026-early-decisions.md` (full rewrite), `instagram-scrape-for-college-admission.md`
- **Next:** Screenshot-verify the 8 ⚠️ entries; monitor for RD posts through April

## 2026-02-21 — Session 1

- Researched browser-based tools for coding agents (JS rendering, auth, heavy pages)
- Compared: agent-browser (Vercel), Playwright CLI (Microsoft), Dev Browser (SawyerHood), Firecrawl CLI+Browser Sandbox, Stagehand, Browser Use
- **Recommendation:** agent-browser as primary (CLI-first, snapshot+refs, session state for auth, 93% token savings)
- Created `research/browser-tools-for-coding-agents.md`, updated `topics/dev-tools.md` and `README.md`
- Installed agent-browser globally + as Pi skill at `~/.pi/agent/skills/agent-browser/`
- Used agent-browser to scrape Instagram for PRS Class of 2026 early college decisions
  - **Instagram tag:** `@prsdecisions2026` — student-run account for PRS Class of 2026
  - **Instagram tag (to find):** Bishop's School equivalent — search `bishops decisions 2026` or similar
  - Extracted 19 early decisions across 17 universities (Stanford, UPenn Wharton, Duke, Northwestern, USC×2, UVA, NYU, etc.)
  - Saved to `research/prs-class-2026-early-decisions.md` + `.json`
  - Instagram auth state saved at `~/.agent-browser/instagram-auth.json`
- Saved reusable workflow pattern: `research/instagram-scrape-for-college-admission.md`
- Repeated for The Bishop's School (La Jolla):
  - **Instagram tag:** `@tbsdecisions2026` (found via abbreviation "TBS", not "bishops")
  - 30 early decisions across 18 universities (Miami ×6, Wake Forest ×3, Alabama ×3, Northwestern, Vanderbilt, UVA, etc.)
  - First names only (no last names unlike PRS)
  - Captions are full English sentences — easier to parse than PRS image-only posts
  - Saved to `research/tbs-class-2026-early-decisions.md`
  - Updated workflow doc with search tips (abbreviation matters)

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

## 2026-02-21 (session 11)
- **Research:** [PRS College Profile Analysis](research/pacific-ridge-school-profile-analysis.md) — AO's reading of the school profile document
  - V1 analyzed profile strengths (Harkness, AP cap, counseling ratio, global engagement) and weaknesses (test scores, matriculation gaps)
  - V2 critical self-review caught major errors:
    - FindingSchool data unreliable (Chinese-audience site with biased methodology) — removed as primary comparison source
    - Matriculation ≠ acceptance distinction never addressed in v1
    - AP pass rate (~51% scoring 3+) completely omitted from v1 — below national average, significant red flag
    - Youth-of-school factor (15 graduating classes ever, zero legacy pipeline) massively underweighted
    - UC system mechanics hand-waved instead of analyzed
    - Post-AP courses (Diff EQ, MV Calc) barely mentioned — actually a hidden gem
    - Recount from actual matriculation list: ~8-10% to T30, not FindingSchool's 1.79%
  - Verdict: Sweet spot is T20-50; profile neutral at T10 (student must carry); well-constructed document with some missing data (grading scale, GPA distribution)

## 2026-02-21 (session 10)
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

## 2026-02-21
- **Research:** Absurd (Armin Ronacher/Earendil) durable execution system — deep dive and landscape comparison
  - Researched Absurd GitHub repo, blog post, HN thread, and user test writeups
  - Compared against Temporal, DBOS, Inngest, Restate, Hatchet, `use workflow`
  - Key finding: Absurd and DBOS compete directly (both Postgres-only), but different philosophy — Absurd puts complexity in SQL, DBOS puts it in client annotations
  - Armin tried DBOS and bounced on SDK quality; DBOS improving fast
  - Agent use case is the killer app driving durable execution adoption
  - Wrote `research/absurd-durable-execution-landscape.md`, linked from `topics/software-factory.md`

## 2026-02-21

- Distilled HN thread on [ai-ublock-blacklist](https://news.ycombinator.com/item?id=47098582) — governance problems, AP News false positive, maintainer removed combative FAQ mid-thread
- Researched the full AI slop blocking landscape: domain blocklists (laylavish 5.2k stars, alvi-se, Stevoisiak), content detectors (DeSlop, AI Content Shield, SkipSlop), temporal filtering (Slop Evader), platform responses (Google March 2024 update, YouTube monetization rules), authenticity certification (C2PA, Mosseri's "fingerprint the real")
- Key finding: client-side tools recapitulate email RBL history — solo maintainers → professionalization → platform absorption. Real solution requires Google/platforms to internalize filtering. C2PA is correct long-term direction but only works for media, not text.
- Wrote `research/hn-ai-ublock-blacklist.md` and `research/ai-slop-blocking-landscape.md`, linked from README

## 2026-02-21

- Researched Gondolin (earendil-works/gondolin) — Armin Ronacher's QEMU-based agent sandbox with JS-programmable network/filesystem
- Key findings: 17 days old, 551 stars, Thoughtworks endorsement, closest competitor is Matchlock, differentiated by JS-programmable network stack and secret placeholder injection
- Wrote `research/gondolin-agent-sandbox.md`
- Distilled HN Matchlock thread (46932343) — VM sandboxing for agents, confused deputy consensus, Claude Cowork exfiltration via allowlisted Anthropic API, Opus 4.6 red-team anecdotes, useradd contrarian argument
- Key finding: network allowlisting doesn't solve exfiltration when allowed hosts are general-purpose APIs. Prompt-injected agent produces identical traffic to legitimate agent. Content-aware egress requires LLM-judging-LLM recursion.
- Wrote `research/hn-matchlock-agent-sandbox.md`
- Deep comparison of Gondolin vs Matchlock across 7 solvable attack classes
- Matchlock wins on VM boundary (Firecracker) and in-VM hardening (seccomp-BPF). Gondolin wins on network policy (JS ethernet stack, synthetic DNS, rebinding protection) and filesystem awareness (symlink protection, MemoryProvider).
- Recommendation: Matchlock today (foundation > policy sophistication), watch Gondolin. Ideal tool would combine Gondolin's network stack with Matchlock's VM boundary.
- Wrote `research/gondolin-vs-matchlock.md`
- Practical setup analysis for Matchlock with Pi: 6 layers of config, network allowlist is the ongoing tax, Pi integration doesn't exist (Gondolin's advantage)
- Wrote `research/matchlock-setup-guide.md`
- Elaborated "agent as separate macOS user" — the 80/20 play from matchlock guide. Covers: macOS permission model (750 home dirs, 700 sensitive dirs, TCC), user creation, shared workspace with setgid group, SSH/sudo workflow, Homebrew sharing, threat model comparison table, layering with Matchlock
- Wrote `research/agent-separate-macos-user.md`, linked from matchlock guide and coding-agents topic page
- Self-rebuttal: "just run open" was wrong — undersold threat frequency, bad analogy, confused frequency with expected value, overclaimed friction
- Wrote `research/agent-isolation-friction-rebuttal.md`
- Pre-commitment analysis of separate user: real setup is 60-90 min not 15, /tmp leaks 63 world-readable files, shared workspace permissions fragile, discipline decay, agent's own creds fully exposed
- Wrote `research/agent-separate-user-precommit-analysis.md`
- Landscape survey: what people actually do for agent security. Two worlds: autonomous (OpenClaw/Mac Mini) vs interactive (Claude Code/Pi). Key finding: being on-screen is a real security control the autonomous crowd doesn't have
- Emerging pattern: LuLu outbound firewall + dedicated agent service accounts (ChatPRD pattern) = highest value for interactive use
- Separate user is Tier 3 (optional) for interactive use when LuLu + dedicated accounts are in place
- Wrote `research/agent-security-landscape-what-people-do.md`

## 2026-02-22
- HN distill: "Dead Internet Theory" (697 comments)
- Key thesis: Dead Internet Theory is really Dead Incentive Theory — ad-funded attention economy rewards exactly what bots excel at
- Best framework: shadowgovt's PageRank analogy (filtering interregnum, not terminal condition)
- Non-obvious dynamic: humans converging expression downward to avoid AI suspicion, closing the gap from both sides
- Wrote `research/hn-dead-internet-theory.md`

## 2026-02-22

- HN distill: "The recurring dream of replacing developers" (524 comments, 646 pts)
- Article itself flagged as AI slop — meta-irony: AI-written article arguing humans are essential
- Star comment (davnicwil): dream is about manifesting without details; details are fractal
- Key framework: Twey's "constant complexity budget" — we always operate at max complexity, abstractions just reallocate upward
- dijit's democratization insight: Excel succeeded by accepting catastrophic failure; you can't have accessibility + reliability
- Near-term consensus: junior squeeze is real, bar keeps rising, but nobody follows the pipeline problem forward
- Non-obvious: essential/accidental complexity boundary is being reclassified in real time, not fixed
- Offshoring smokescreen: layoffs may be offshoring dressed as AI disruption (strict9, complicated by Tade0)
- Wrote `research/hn-replacing-developers-dream.md`

## 2026-02-22

- HN distill: "The Singularity will occur on a Tuesday" (756 comments, 1381 pts)
- Article is Trojan horse: looks like sincere singularity prediction, real thesis is only human *attention* is going hyperbolic, not capability
- Thread splits: 60% read through to social argument, 40% stopped at (deliberately bad) math and declared slop
- ubixar crystallizes better than article: "Linear capability growth is the reality. Hyperbolic attention growth is the story."
- Challenger vs JOLTS gap: announced layoffs spike while actual separations stay flat — the gap IS the social singularity mechanism
- cubefox links Scott Alexander's "1960: The Year The Singularity Was Cancelled" — strongest counter-thesis, barely discussed
- Fetched Tim Dettmers' "Why AGI Will Not Happen" — strongest hardware-grounded argument for physical ceilings
- Wrote `research/hn-singularity-tuesday.md`
- Added 6 insights to `insights.md`:
  1. RLHF anti-novelty bias (second mechanism beyond prediction→mean, from hnfong + AlphaZero paper)
  2. Verification gates alien performance (from energy123 — more precise than "theory formation" threshold)
  3. Recognition chain bottleneck (AI compresses generation, not recognition — from hnfong + AlphaZero)
  4. Physical ceilings nearer than assumed (from Dettmers — GPU perf/cost maxed ~2018, transformers near-optimal)
  5. Anticipatory displacement loop (companies act on AI potential not performance — HBR confirms, JOLTS contradicts Challenger)
  6. Infrastructure liability inversion (from Dettmers — $200B+ CAPEX as stranded-asset risk)

## 2026-02-21

- Distilled HN thread on Mitchell Hashimoto's Vouch (community trust management for OSS)
  - 1077 pts, 486 comments — significant community engagement
  - Saved to `research/vouch-hn-thread.md`
- Cross-referenced against insights.md — found one genuinely new structural insight:
  - **Rejection machinery ∝ courtesy norms**: communities build automated rejection systems not for efficiency but for emotional cover. The stronger the professional courtesy norm, the more elaborate the machinery. Placed after Democratization-Failure Tradeoff.
- Existing insights already covered: Apprenticeship Doom Loop (Vouch tightens it), Democratization-Failure Tradeoff (Vouch enacts it), intent vectors (the algorithmic alternative the thread mostly misses)
- Updated: insights.md (new entry), README.md (new research link)

## 2026-02-25

- Distilled HN thread "Making MCP cheaper via CLI" (47157398, 76 comments, 163 score)
- Key finding: MCP is becoming the catalog/registry layer while execution surfaces diversify (CLI, Code Mode, Tool Search) — the "MCP vs CLI" framing is a false dichotomy
- Thread's best insights: composability via piping > token savings, per-turn context replay dwarfs tool definitions, KV cache preservation advantage of CLI, smaller models benefit disproportionately
- Cloudflare's Code Mode (search + execute, ~1K tokens for 2,500 endpoints) undervalued by thread — potentially makes tool definitions obsolete
- Meta-irony: every MCP critic's project takes MCP servers as input
- Saved to `research/hn-mcp-cheaper-via-cli.md`, updated README.md
- Extracted from MCP/CLI distillation:
  - **anecdotes.md**: 5 new entries under "Agent tool architecture" section — 150 Tool Calls vs 1 For Loop (martinald), CLI Accuracy on Small Models (cmdtab), CLI Discovery Chain (thellimist), Per-Turn Replay Dwarfs Tool Definitions (OsrsNeedsf2P), MCP Non-Composability (_pdp_)
  - **additional_insights.md**: New insight "Shell Composability Advantage" — three structural advantages (composability eliminates round-trips, training distribution alignment, KV cache preservation) with security counterpoint
  - **additional_insights.md**: Updated "Skill Loading Illusion" with convergence evidence (5 independent MCP-to-CLI converters + Cloudflare Code Mode + Anthropic Tool Search, all in same week)

- Deep research on harness engineering insights and operational best practices
  - Searched 30+ sources: LangChain Terminal Bench experiments, ETH Zurich AGENTS.md evaluation (arXiv:2602.11988), Pappas convergence analysis, can1357 hashline benchmark, Vercel tool reduction study, Böckeler's independent analysis, Demmel's feedback loop hierarchy, pi-reflect, Arize telemetry analysis, EQ Engineered, New Stack
  - Key empirical findings:
    - LangChain: harness-only changes +13.7pts on Terminal Bench (model fixed)
    - can1357: single edit tool change improved 15 models, weakest by 10×
    - Vercel: removing 80% of tools → 80→100% accuracy, 3.5× faster
    - ETH Zurich: LLM-generated AGENTS.md reduces success by 3%, increases cost 20%+
  - Synthesized hierarchy of leverage: feedback gauntlet > tool simplification > mechanical architecture enforcement > incremental AGENTS.md > self-verification loops > doom loop detection > observability > garbage collection
  - Honest assessment: all success stories are greenfield, hidden denominator uncounted, verification gap structural, zero long-term maintenance data
  - Meta-insight: harness engineering is the industry belatedly realizing skipped engineering practices are now load-bearing
  - Saved to `research/harness-engineering-insights-and-practices.md`
  - Updated topic pages: coding-agents.md, software-factory.md (forward links)

- Self-review of harness engineering research against latest evidence (30+ sources cross-checked)
  - **Corrections applied:**
    - Vercel n=5 sample size: flagged as directional signal, not statistical evidence
    - ETH Zurich AGENTS.md study: added limitations (SWE-bench only, well-documented repos, doesn't measure token efficiency or recurring mistake prevention); HN practitioners pushed back hard, especially for large/messy codebases
    - LangChain vendor conflict: LangSmith recommendation is marketing, flagged more prominently
    - "Harness > model" framing: partially category error — nobody has done controlled marginal comparison
  - **New evidence integrated:**
    - JUXT Allium case study: spec-first development producing distributed BFT system (3K spec → 5.5K Kotlin). Strongest evidence yet for specification approach, but expert-dependent
    - Cemri et al. MAST taxonomy (O'Reilly): 36.9% of multi-agent failures are interagent misalignment — harness literature ignores multi-agent state synchronization
    - HN thread (47034087): practitioner consensus on migrating AGENTS.md rules to mechanical checks (AST linters, pre-commit hooks). "Every rule that CAN be a test SHOULD be a test"
    - Bitter Lesson temporal counter-argument: Manus 4 rebuilds = model improvements erode harness value
  - **Structural additions:**
    - Temporal classification: durable practices (linting, architecture, observability) vs temporal (doom loops, forced verification) vs unknown (AGENTS.md, specs, garbage collection)
    - Specification promoted to rank 4 in leverage hierarchy (was absent)
    - 5-point self-critique section added
    - r/ExperiencedDevs "harness as labor" problem: most orgs can't staff for this
