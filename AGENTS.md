# Notes — Agent Instructions

This is a personal research knowledge base. No code. Pure markdown.
Extends global AGENTS.md. Overrides global Work Log section → see Worklog Convention below.

## Reading Protocol
- **For decisions/current state:** start at README.md, follow links to topics/, stop when answered.
- **For specific content search:** grep is fine.
- **For full evidence:** follow topic page links down to research/ files.
- Personal operational state (README, topics/) overrides general research findings when they conflict.

## Writing Protocol
- **New research:** search existing files first (`rg -l` in `research/`) — extend or update existing files rather than creating duplicates. Create in `research/`, add backlink header, add forward link in the topic page's "Deep Research" section.
- **Decision change:** update top-down: README → topic page. Research files keep their own conclusions.
- **New topic page:** only when 2+ research files cluster or a decision needs recording.
- **Renaming/moving:** update all links — backlinks, forward links from topic pages, README if affected.
- **Backlink header:** `← [Topic Name](../topics/X.md) · [Index](../README.md)`

## Research Writing

**Epistemics**
- Be thorough, tough, but fair. Infer, connect, read between lines.
- Validate claims against code, official docs, and expert evaluations. Don't trust secondary sources uncritically.
- Use latest sources — this is fast-moving space. Flag when something might be stale.
- Cite sources like academic papers. Separate facts from hype.
- When unsure, say "not sure" explicitly rather than presenting inference as fact.

**Process**
- Search and research deep and wide before forming conclusions.
- Review your own analysis critically at least once before presenting.
- Forward-looking: project trends, don't just describe current state.
- Maximum clarity without losing necessary nuance.

**Tone**
- Opinionated, critical, and analytical — not balanced corporate prose.
- Include honest assessments: verdicts, trade-offs, what's bad, what's good, self-corrections.

## Output
- Save all research to disk as markdown. This is expected, not optional.
- Don't combine or restructure existing files without explicit instruction.
- When summarizing: keep all important details. Sophistication matters.
- Progressive summarization when asked: full research → standalone synthesis → exec summary (VP/Director level).

## Source Credibility Checks
- When assessing an online commenter/author: check account age, karma, submission history (stories vs. comments only), reply engagement (do they argue back?), burst vs. sustained posting patterns.
- Writing forensics: consistent structure across all comments, perfect grammar with zero typos, overwrought metaphors, and shallow "personal" details that add nothing to the argument are AI-generation signals.
- New accounts with burst-then-silence patterns and zero reply engagement are low-trust sources regardless of comment quality.

## Worklog Convention

**Structure:**
- `worklog.md` — current week's entries (active scratchpad). Header: `# Worklog — YYYY-WNN (Mon D–D)`.
- `worklogs/YYYY-WNN.md` — archived weekly files. Same format as worklog.md.

**Entry format:** `## YYYY-MM-DD — Topic`
- ≤8 concise bullet points. Detail belongs in research files, not here.
- End with `**Decision:**` and/or `**Next:**` where applicable.
- Reverse-chronological within the file (newest day first).

**Rotation procedure (BEFORE writing any entry):**
1. Read the `# Worklog — YYYY-WNN` header in `worklog.md` to get its week number.
2. Compare against the current ISO week.
3. If same week → append entry under today's date. Done.
4. If new week has started:
   a. Move `worklog.md` content to `worklogs/YYYY-WNN.md` (using the OLD week number).
   b. Reset `worklog.md` with new week header and a pointer: `> Past weeks: [worklogs/](worklogs/)`.
   c. Write the new entry.

## Non-Obvious
- Some topics have separate operational vs. market research files (e.g., what works on *our* API key vs. general pricing/landscape). Don't conflate them.
- Default commit type is `docs:`. Use `fix:` for broken links, `chore:` for cleanup.
