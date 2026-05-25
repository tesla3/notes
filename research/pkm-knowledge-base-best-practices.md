# Personal Knowledge Base: Best Practices Research & Plan

Date: 2026-03-03

## Sources

- dsebastien.net — "Personal Knowledge Management at Scale" (8,000 notes, 64,000 links)
- zettelkasten.de — "How to Increase Knowledge Productivity: Combine the Zettelkasten and BASB"
- dsebastien.net — "12 Common Personal Knowledge Management Mistakes"
- infobytes.guru — "Building a Personal Knowledge Management (PKM) System"
- hbenjamin.com — "Building a personal knowledge base" (plain markdown + git + terminal)
- recapio.com — "10 Actionable Models for Best Practice Knowledge Management in 2026"
- reddit.com/r/PKMS — practitioner threads on AI-powered PKM, failure modes
- reddit.com/r/ObsidianMD — "Is the concept of Personal Knowledge Management flawed?"
- news.ycombinator.com — "Do you use a personal knowledge base?" (item 21108527)
- Various: Computerworld KM failures, IFS KM failures, KMInstitute failure analysis

## Current State (as of 2026-03-03)

- 1 qmd collection (`personal_notes`), 358 files, 4.8 MB
- 338 in `research/` (94%): ~159 HN thread distillations + ~179 original research/reviews/analyses
- 11 root files: readme, insights, anecdotes, agents, meta-review, worklog, product-design, my-notes, new-words, additional-insights, lesson-llm-analysis-failure-mode
- 4 in `topics/`: coding-agents, dev-tools, llm-models, software-factory (MOC files)
- 4 in `personal/`: school profile reviews
- 1 in `notes/`: worklog.md
- No qmd contexts configured
- No YAML frontmatter on notes
- No note templates

## What's Already Working

1. **Plain markdown, git-versioned** — universally praised as the most future-proof foundation. No vendor lock-in, AI-friendly, tooling-agnostic.
2. **Single source of truth** — one collection, one place. The #1 recommendation from every PKM practitioner at scale.
3. **Semantic search via qmd** — hybrid retrieval (BM25 + vector + rerank). Compensates for weak manual organization.
4. **Topic MOC files** — `topics/` directory with coding-agents, llm-models, etc. The readme is a top-level MOC.
5. **Worklog** — session-based capture with cross-references to research files. Acts as fleeting/literature note pipeline.

## Key Findings from Research

### Consensus Principles

- **Plain text is future-proof.** Markdown + git is the gold standard. Every serious practitioner converges here.
- **Single source of truth.** Knowledge spread across multiple apps is harder to search and connect. One home.
- **Tags > Links > Hierarchy.** Flat structure with dense connections beats deep folder trees. (dsebastien, zettelkasten.de)
- **Manual organization breaks down past ~1,000 notes.** Automation and search become essential.
- **Atomic notes scale better.** Small, focused notes enable better linking and reuse. (Caveat: doesn't mean all notes should be atomic — coherent analyses have their own value.)
- **Maps of Content as hubs.** MOCs serve as entry points to leverage accumulated knowledge.
- **Templates maximize consistency.** Every PKM system surviving past 500 notes uses them.
- **Capture → Process → Connect.** Never skip the processing and connecting steps.
- **Complexity is a flaw.** The #1 killer of PKM systems is spending more time organizing than creating.

### Content Type Separation (Zettelkasten + BASB Synthesis)

The strongest recommendation from zettelkasten.de and dsebastien:

- **Literature notes** — processed external inputs. What someone else said, in your words.
- **Permanent notes** — your own synthesized thinking, opinions, decisions, frameworks.
- **MOCs** — maps of content linking related notes across types.
- **Fleeting/inbox** — quick captures before processing.

Purpose: intellectual integrity ("never confuse others' ideas with your own") and cleaner retrieval ("what did I read about X" vs "what do I think about X").

### PARA vs. Zettelkasten

- **PARA** (Projects, Areas, Resources, Archives) — action-oriented, project-centric. Best for people juggling actionable tasks with deadlines. Speaks the "language of action."
- **Zettelkasten** — knowledge-oriented, idea-centric. Best for researchers, writers building deep expertise. Speaks the "language of knowledge."
- **Hybrid** (dsebastien approach) — PARA for resource management + Zettelkasten for idea development. PARA handles urgency/actionability; Zettelkasten handles depth/connections.
- **For this KB:** primarily knowledge-centric (research, analysis, decisions), not project-centric. PARA wholesale is wrong fit. Current structure (readme → topics → research) is already more appropriate.

### Common Failure Modes (Anti-Patterns)

From "12 PKM Mistakes" and practitioner threads:

1. **Hoarding** — capturing everything without ever leveraging anything. The flat `research/` dump risks this.
2. **Orphan notes** — notes with no links to anything else. Most of the 338 research files are islands.
3. **Complexity monsters** — making the system harder than it needs to be. Over-engineering kills adoption.
4. **Tool hopping** — constantly switching tools, losing momentum. Not a problem here (stable stack).
5. **No backups** — people lose years of notes to disk failures. Git remote push is essential.
6. **Optimism about retrieval** — assuming you'll find things later without investing in connections now.
7. **Retroactive reorganization** — spending weeks restructuring existing notes instead of creating new ones.

### AI + PKM Integration

From Reddit/practitioner threads:

- Local RAG over markdown (exactly what qmd provides) is the most praised setup
- Obsidian + Co-Pilot plugin popular but locked to Obsidian ecosystem
- NotebookLM praised for citation-backed answers but cloud-only
- Consensus: AI search compensates for organizational weakness but doesn't replace intentional linking
- qmd's hybrid search + rerank already implements the recommended RAG architecture (BM25 + vector + rerank)

## Recommended Actions

### Priority 1: YAML Frontmatter — **Deferred**

Add to new notes going forward. Enables qmd filtering by type/tags. Deferred: current notes work fine without it at 370 files. Revisit if retrieval friction emerges or note count exceeds ~1,000.

### Priority 2: More Topic MOCs — **Deferred**

Current 4 MOCs cover decision-relevant clusters. qmd handles discovery for everything else. More MOCs = more maintenance. Deferred: only create when 2+ research files cluster around an active decision.

### Priority 3: Configure qmd Contexts — **Done** (2026-03-03)

Added contexts to all three collections (personal_notes, work_notes, docs).

### Priority 4: Document Note Templates — **Deferred**

Consistent H1 + source/date line is sufficient at current scale. dsebastien uses templates at 8K notes. Revisit past ~1,000 notes.

### Priority 5: Weekly Review Habit — **Deferred**

AGENTS.md already has worklog convention + archiving rule. Adding MOC update obligations creates maintenance the system explicitly avoids ("Don't update topic pages for every new research note"). Cross-links deferred per same logic as backlinks.

### Priority 6: Verify Git Remote Backups — **TODO**

Confirm remote push is active. Test restore. (Git push currently failing with 403 — needs auth fix.)

### Priority 7: Literature/Permanent Split — **Deferred**

Already implemented structurally: root files = permanent notes, research/ = literature notes. Documented in AGENTS.md filing section. No further action needed unless retrieval confusion emerges.

## What NOT to Do

- **Don't reorganize 338 existing files.** Retroactive restructuring is the classic PKM procrastination trap. Notes work. qmd finds them. Move forward.
- **Don't adopt PARA wholesale.** Wrong fit for a research/knowledge-centric KB.
- **Don't add tooling.** No Obsidian, no plugins, no databases. Plain markdown + vim + qmd + git scales.
- **Don't chase atomic notes dogmatically.** 10-30KB coherent research analyses are more valuable intact than split into 50 atomic zettels.
- **Don't over-organize.** Use search as primary retrieval, not navigation. The system that works is the one you actually use.
