# Worklog

> **Note:** File paths in entries before 2026-02-17 notes reorg refer to the flat structure.
> See [README.md](README.md) for current file locations.

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
- Checked in config + notes to chezmoi and notes repo
- **Decision:** use defaults for now

## 2026-03-17 — gpu-ubuntu setup

- Cloned repos from GitHub to `/home/hua/repos/`, symlinked into `/home/hua/pi-place/`
- Installed 9 pi extensions from shitty-extensions + agent-stuff packages
- Configured pi packages in `settings.json`, set context windows to 200K in `models.json`

## 2026-03-15 — Context window config

- Set Opus 4.6 and Sonnet 4.6 to 200K (from 1M default) via `~/.pi/agent/models.json` `modelOverrides`
- Added to chezmoi for cross-machine sync

## 2026-03-08 — Claire STEM internships

- Critically reviewed `research/claire-stem-internships-2026.md` — 3 critical errors (Salk deadline passed, Scripps REACH restricted, SPARK fabricated)
- Re-assessed with "no biology" constraint; verified deadlines — UCSD REHS/COSMOS/Academic Connections all closed
- Deep researched UCSD MAP — best path to verifiable research credential for 2027 applications
- Created `research/claire-stem-internships-2026-review.md`, `research/claire-stem-internships-2026-decision.md`, `research/ucsd-map-deep-dive.md`
- **Decision:** Cooper Union + SRTI only viable formal programs; MAP (opens April 15) is strategic priority
- **Next:** apply Cooper Union by March 22-27, SRTI by ~March 30, MAP by May 31

## 2026-03-06 — Mojo GPU + workflow synthesis

- Researched Mojo GPU programming: competitive on memory-bound kernels (87-102% of CUDA), gaps on compute-bound
- Synthesized workflow doc from three existing research files
- Created `research/mojo-gpu-programming-deep-dive.md`, `research/workflow-minimal-composable-systems.md`

## 2026-03-04 — CLI tools, agent tool use, AGENTS.md best practices

- Researched CLI tools + context efficiency — 99% of agent tokens are re-sent input
- Self-audited tool use across 271 sessions: 121MB output, 6 anti-patterns identified
- Stress-tested all rules: 6/8 break under edge cases, converted to conditional; found 7 more broken rules in second-round review
- Researched AGENTS.md best practices (13 sources) — our file is top tier; applied 4 optimizations
- Created `research/cli-tools-context-efficiency.md`, `research/agent-tool-use-self-review.md`, `research/agents-md-best-practices.md`, `research/expert-cli-tricks-for-context-saving.md`
- **Decision:** rules as conditional decision tree, not absolute; no material AGENTS.md restructuring needed

## 2026-03-03 — HN distills: Claude outage + simplicity promotion

- Distilled Claude outage (162 comments) — OpenAI→Anthropic migration causing outages, AWS ME drone strikes
- Distilled "Nobody Gets Promoted for Simplicity" (173 pts) — rewarded only when replacing visible complexity
- Created `research/hn-claude-outage-2026-03.md`, `research/hn-nobody-gets-promoted-for-simplicity.md`

## 2026-03-02 — Pi as Stateful Actor brainstorm

- Synthesized A2A, Durable Objects, architecture patterns into three-layer architecture
- Self-critique: graded B-. Corrected LOC (3.5K → 10-18K), cost ($90 → $3-10K/op)
- Created `research/brainstorm-pi-a2a-stateful-actor.md`
- **Decision:** "Beautiful architecture. Wrong year. Revisit late 2026."

## 2026-03-01 — Design patterns + Pi A2A/RPC

- Cataloged 70+ design patterns across 14 problem domains
- Brainstormed architecture patterns for AI-pervasive future; researched pattern shifts for agent era
- Deep dive into Pi RPC mode + A2A protocol + ACP
- Created `research/software-design-patterns-by-problem-domain.md`, `research/software-architecture-ai-agent-era.md`, `research/design-patterns-agent-future.md`, `research/pi-rpc-mode-deep-dive.md`, `research/pi-a2a-integration-analysis.md`
- **Decision:** ACP first (~500-800 LOC, 10x more value), A2A second as extension

## 2026-02-28 — Agent skills + Rust critical evaluation

- Deep read of pi skills system (7 installed skills, pattern taxonomy from pure-prompt to full framework)
- Rust critical evaluation with 3 revisions (AI section, token efficiency counter-thesis)
- Created `research/agent-skills.md`, `research/rust-language-critical-evaluation-2026.md`

## 2026-02-28 — Signal-to-Value + insights updates

- Decomposed "token efficiency" into semantic density vs verification density
- Updated 39-Point Inversion in insights.md (METR replication broke — devs refuse no-AI)
- Added 2 new insights: Two Densities, Exploration Phase Mismatch
- Created `research/signal-to-value-high-level-languages-exploration.md`
- **Next:** watch METR replication, ARC-AGI-3 results

## 2026-02-28 — Harness & leverage critical review

- Reassessed three core docs against latest evidence: model-harness co-training (Codex), 17% comprehension loss (Anthropic), macro productivity gap
- Created `research/harness-leverage-critical-review-feb28-2026.md`
- **Next:** monitor co-training evidence, longitudinal skill studies

## 2026-02-28 — LLM capability deep dive + critical reviews

- Capability analysis: "context-directed extrapolation" framework, CoT faithfulness, METR RCT (19% slower, 40-point perception gap)
- Critical reviews: capability analysis miscalibrated on magnitudes; extrapolation framework not falsifiable/quantifiable
- Created `research/llm-capability-vs-pseudo-capability.md`, `research/llm-capability-pseudo-cap-critical-review.md`, `research/context-directed-extrapolation-critical-analysis.md`

## 2026-02-28 — Post-Nov 2025 model failures + antidotes

- Taxonomy: 11 failure categories, qualitatively different (smart enough to be dangerous)
- 20 countermeasures evaluated, 12 rated Strong evidence
- Created `research/post-nov-2025-model-failures.md`, `research/post-nov-2025-model-failure-antidotes.md`
- **Decision:** none solve fundamental capability-reliability tension; they buy time and reduce blast radius

## 2026-02-28 — Skills deep synthesis + meta-review

- Skills synthesis: 5 archetypes, ROI matrix, 3 anti-patterns; critical review caught fabricated ROI numbers
- Meta-review of insights corpus: 7 errors in surprises analysis, 58% HN-sourced, systematic negativity bias
- Created `research/skills-deep-synthesis-when-why-roi.md`, `research/skills-deep-synthesis-critical-review.md`
- **Decision:** Culture Amplifier is the containing insight for most others
- **Next:** restructure insights.md around Culture Amplifier; add evidence-tier tags

## 2026-02-28 — Agent skills categories + QMD evaluation

- 12-category skills landscape; security worse than reported (5.4% malicious); new insight: Skill Author Competence Paradox
- QMD evaluation: best on-device knowledge retrieval for coding agents as of Feb 2026
- Created `research/agent-skills-landscape-categories-winners.md`, `research/agent-skills-emerging-winners.md`, `research/qmd-evaluation-and-context-connection.md`

## 2026-02-28 — Semantic search playbook + FDE research

- Practitioner playbook with decision framework + self-review (corrected RTK token category error — input tokens, not output)
- FDE trend research: genuine structural need but massive hype overlay, follows PLG hype cycle
- Created `research/semantic-search-practitioner-playbook.md`, `research/semantic-search-practitioner-playbook-review.md`, `research/forward-deployed-engineers-fde-analysis.md`
- **Lesson:** always check which token category a tool affects before making cost claims

## 2026-02-26 — Claude Code picks, remarkable repos, harness engineering

- HN distill: amplifying.ai 2,430-prompt study — Tailwind wins structurally, AGENTS.md works ~80%
- Architecturally remarkable repos: 15 projects tiered; self-review found 6 problems (database bias, ScyllaDB missing), added 4
- Harness engineering: METR study breaking, Lulla et al. AGENTS.md +29% speed, 100% autonomy wall confirmed
- Created `research/hn-claude-code-picks.md`, `research/architecturally-remarkable-repos.md`, `research/harness-engineering-update-feb26-2026.md`
- **Next:** monitor METR redesign, brownfield SDD tooling

## 2026-02-25 — MCP cheaper via CLI + harness engineering insights

- HN distill: MCP becoming catalog/registry while execution diversifies (CLI, Code Mode)
- Harness engineering research (30+ sources): harness-only changes +13.7pts on Terminal Bench, 80% tool reduction → 100% accuracy
- Self-review: corrected Vercel n=5, ETH Zurich limitations; added JUXT Allium, temporal classification
- Created `research/hn-mcp-cheaper-via-cli.md`, `research/harness-engineering-insights-and-practices.md`
- Updated anecdotes.md, additional_insights.md

## 2026-02-24 — Long-range prediction + AI forecasters

- Nobody has verified 10+ year prediction track record except IPCC climate models
- Every forecasting group shortened AI timelines 2022→2025 — convergence is the strongest signal
- Samotsvety: 31% AGI by 2030; Caplan about to lose first-ever public bet; Yegge all-in on AI coding
- Created `research/long-range-prediction-accuracy.md`, `research/ai-predictions-best-forecasters.md`

## 2026-02-23 — pi_agent_rust review + Pi HN distill

- Reviewed Dicklesworthstone's Rust port: 556K lines in 23 days, 79% Claude-authored, "phantom complexity" (modules named after concepts they don't implement)
- Distilled Pi HN thread (202 pts, 92 comments) — 7 structural connections to insights.md
- Created `research/pi-agent-rust-review.md`, `research/hn-pi-minimal-terminal-coding-harness.md`
- **Decision:** no new insights promoted — connections deepen existing entries

## 2026-02-22 — HN distills: DuckDB, Skip, Dead Internet, Replacing Developers, Singularity

- DuckDB (310pts): moat is relational guarantees not speed; Ibis as implicit answer
- Skip open source (515pts): LGPL-3 friction, no production case studies after 3 years
- Dead Internet Theory (697 comments): really Dead Incentive Theory; humans converging expression downward
- Replacing developers (524 comments): article itself is AI slop (meta-irony); constant complexity budget
- Singularity Tuesday (1381 pts): Trojan horse article; Challenger vs JOLTS gap IS the social singularity mechanism
- Added Solow Paradox critique to `research/coding-agents-insight-inventory.md`; added 6 insights to insights.md
- Created `research/hn-duckdb-first-choice-data-processing.md`, `research/hn-skip-open-source.md`, `research/hn-dead-internet-theory.md`, `research/hn-replacing-developers-dream.md`, `research/hn-singularity-tuesday.md`

## 2026-02-21 — Browser tools, Instagram scraping, school analysis

- Researched browser tools for agents; recommended agent-browser (CLI-first, 93% token savings)
- Installed agent-browser globally + as Pi skill
- Scraped Instagram for PRS and TBS Class of 2026 early decisions (44 total across 28 universities)
- TBS scrape correction: `@tbsdecisions2026` is wrong; correct is `@tbs26decisions`
- Created `research/browser-tools-for-coding-agents.md`, `research/prs-class-2026-early-decisions.md`, `research/tbs-class-2026-early-decisions.md`, `research/instagram-scrape-for-college-admission.md`
- **Next:** screenshot-verify 8 unconfirmed TBS entries; monitor for RD posts

## 2026-02-21 — PRS + TBS school analysis

- PRS critical analysis: ~1-2% to T25 vs Bishop's ~19% — order-of-magnitude gap at similar tuition
- PRS profile: AP pass rate ~51% (below national average), post-AP courses a hidden gem
- Recut to T20 with US News 2026 rankings; extracted school PDFs via PyMuPDF
- Created `research/pacific-ridge-school.md`, `research/pacific-ridge-school-profile-analysis.md`
- **Decision:** PRS verdict: B+ school at A+ prices; sweet spot is T20-50

## 2026-02-21 — HN distills + NanoClaw + agent security

- NanoClaw deep dive: improves blast radius but doesn't solve prompt injection or exfiltration
- HN car wash (1511pts): premature token commitment, not reasoning incapacity
- HN Ring/Nest (935pts): selective enforcement model explains surveillance + crime paradox
- Absurd durable execution: Postgres-only, competes with DBOS; agent use case is killer app
- ai-ublock + slop blocking landscape: client-side tools recapitulate email RBL history
- Gondolin vs Matchlock: Matchlock wins VM boundary, Gondolin wins network policy
- Agent security landscape: LuLu + dedicated accounts = highest value for interactive use
- Vouch HN thread: new insight added — Rejection machinery ∝ courtesy norms
- Created `research/nanoclaw-deep-dive.md`, `research/hn-llm-car-wash-reasoning.md`, `research/hn-ring-nest-surveillance-state.md`, `research/absurd-durable-execution-landscape.md`, `research/hn-ai-ublock-blacklist.md`, `research/ai-slop-blocking-landscape.md`, `research/gondolin-agent-sandbox.md`, `research/hn-matchlock-agent-sandbox.md`, `research/gondolin-vs-matchlock.md`, `research/matchlock-setup-guide.md`, `research/agent-separate-macos-user.md`, `research/agent-isolation-friction-rebuttal.md`, `research/agent-separate-user-precommit-analysis.md`, `research/agent-security-landscape-what-people-do.md`, `research/vouch-hn-thread.md`
- **Decision:** separate macOS user is Tier 3 for interactive agent use (after LuLu + dedicated accounts)

## 2026-02-19 — Dotfiles/setup audit

- Audited dotfiles against worklog history — verified mdt removed, web-search.json deleted, glow configured
- Found 2 drift items: `models.json` completely missing (not just emptied), `GEMINI_API_KEY` fully removed (not commented)
- **Decision:** no action on drift items

## 2026-02-18 — Integrate 16 new research files

- Created `topics/software-factory.md`; expanded `topics/coding-agents.md`; updated `topics/llm-models.md`, `README.md`
- Moved `pi-terminal-bench-research.md` → `research/pi-terminal-bench.md`; added backlinks to all 16 files
- **Decision:** steipete/critical-review-v3 under coding-agents; Fowler/Schillace/careers stay unlinked

## 2026-02-17 — Notes reorganization

- Restructured from flat 8-file dump into 3-layer system: README → topics → research
- Created README.md, 3 topic pages, moved 8 research files with backlinks
- Created `AGENTS.md` for this repo

## 2026-02-17 — Pi & Terminal-Bench research

- Researched why pi is not on Terminal-Bench leaderboard — results submitted but likely never processed
- No one has run updated pi against TB; Mario on OSS vacation
- Created `research/pi-terminal-bench.md`
- **Next:** re-run when pi updates

## 2026-02-17 — Google models cleanup

- Trimmed to free-tier-only, then removed all Google models — quality too low for coding
- Commented out `GEMINI_API_KEY` in `.zshrc`; deleted orphaned `~/.pi/web-search.json`
- **Decision:** Google free tier not viable for coding; key preserved (commented) for re-enable
- **Lesson:** `limit: 0` from live API test > blog posts for per-key availability

## 2026-02-17 — Removed MD-TUI

- Removed `/usr/local/bin/mdt` (MD-TUI v0.9.4) — Glow is preferred
- **Decision:** Glow wins over MD-TUI

## 2026-02-17 — Terminal markdown renderers + Google Gemini + dotfiles

- Researched all major terminal renderers; Glow wins (prettiest, most popular, despite rendering bugs)
- Installed Glow v2.1.1; added alias `glow='glow -w 0 -p'` to .zshrc
- Deep research on Google LLM landscape; set up Gemini API key; configured 5 models in pi
- Created notes repo (github.com/tesla3/notes); committed initial files
- **Decision:** Glow as markdown renderer; Google free tier for supplementary model access
