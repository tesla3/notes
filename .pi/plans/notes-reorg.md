{
  "id": "notes-reorg",
  "title": "",
  "status": "active",
  "created_at": "",
  "assigned_to_session": "61b9d5c5-05e8-4049-a01c-67b808224322",
  "steps": []
}

# Plan: Organize notes/ with 3-layer navigation system

## Goal
Restructure flat notes/ into a layered system (INDEX → topics → research) with cross-links so decisions and evidence are findable by navigating up/down in abstraction.

## Steps

1. Create `topics/` and `research/` directories
2. Write `INDEX.md` at root — active stack, topic map with links, recent activity (~50 lines, references future paths)
3. Write `topics/llm-models.md` — decisions at top, model landscape, free tier status, links to both Google research files
4. Write `topics/coding-agents.md` — decisions at top, Pi/OpenClaw/nanoagent summaries, links to research files
5. Write `topics/dev-tools.md` — thin routing page with two sections (markdown renderers, search APIs), each with decision + link to research file. Don't try to unify analysis.
6. Move+rename `google-ai-research.md` → `research/google-gemini-api-key.md` (operational: what works on this key)
7. Move+rename `google-llm-research-2026-02.md` → `research/google-gemini-market.md` (market: pricing, competitors, landscape)
8. Move `nanoagent-research.md` → `research/nanoagent-survey.md`
9. Move `openclaw-analysis.md` → `research/openclaw-analysis.md`
10. Move `openclaw-innovations-analysis.md` → `research/openclaw-innovations.md`
11. Move+rename `pi-coding-agent-conversation.md` → `research/pi-practitioner-review.md` (keep intact — already well-structured analysis, not a raw transcript)
12. Move `search-api-evaluation.md` → `research/search-api-evaluation.md`
13. Move `terminal-markdown-renderers.md` → `research/terminal-markdown-renderers.md`
14. Add backlink header to each research file pointing to its parent topic page
15. Add historical note to top of `worklog.md`: paths in entries before this date refer to flat structure before reorg, see INDEX.md for current locations
16. Single atomic `git add -A && git commit && git push`

## Design Principles
- Layer 0 (INDEX): "What do I use right now?" (~50 lines)
- Layer 1 (topics): "What are my options and what did I decide?" (decisions at top, then analysis)
- Layer 2 (research): "What's the full evidence?" (deep research, read on-demand)
- Links are directional: INDEX → topics → research, with backlinks
- Decisions float to the top of every document
- Worklog stays chronological at root (orthogonal to topical layers)

## Conventions for Future Notes
- New research goes into `research/` directly — no need to create topic page first
- Topic pages created/updated when 2+ research files cluster on a theme, or when a decision is worth recording
- INDEX.md updated whenever a decision changes (tool swap, model change, etc.)
- This prevents "must create 3 files to add one note" overhead

## Key Decisions from Critical Review
- **Don't merge Google files.** They're complementary, not duplicates. `google-gemini-api-key.md` is operational (this key's limits), `google-gemini-market.md` is market research (pricing, competitors). Topic page unifies decisions from both.
- **Don't extract from Pi conversation file.** It's already well-structured analysis with clear headings. Rename to `pi-practitioner-review.md` and link from topic page to specific sections.
- **Write navigation layer (steps 2-5) before moving files (steps 6-13).** Avoids broken intermediate state if interrupted.
- **dev-tools.md is a routing page, not unified analysis.** Markdown renderers and search APIs share nothing — don't force coherence.
- **Don't rewrite worklog history.** Add a note about the path changes instead.

## Target Structure
```
notes/
├── INDEX.md
├── worklog.md
├── topics/
│   ├── llm-models.md
│   ├── coding-agents.md
│   └── dev-tools.md
└── research/
    ├── google-gemini-api-key.md
    ├── google-gemini-market.md
    ├── nanoagent-survey.md
    ├── openclaw-analysis.md
    ├── openclaw-innovations.md
    ├── pi-practitioner-review.md
    ├── search-api-evaluation.md
    └── terminal-markdown-renderers.md
```
