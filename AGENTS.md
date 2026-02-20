# Notes — Agent Instructions

This is a personal research knowledge base. No code. Pure markdown.

## Reading Protocol
- **For decisions/current state:** start at README.md, follow links to topics/, stop when answered.
- **For specific content search:** grep is fine.
- **For full evidence:** follow topic page links down to research/ files.
- Personal operational state (README, topics/) overrides general research findings when they conflict.

## Writing Protocol
- **New research:** create in `research/`, add backlink header, add forward link in the topic page's "Deep Research" section.
- **Decision change:** update top-down: README → topic page. Research files keep their own conclusions.
- **New topic page:** only when 2+ research files cluster or a decision needs recording.
- **Renaming/moving:** update all links — backlinks, forward links from topic pages, README if affected.

## Backlink header format
```
← [Topic Name](../topics/X.md) · [Index](../README.md)
```

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

## Non-Obvious
- `research/google-gemini-api-key.md` = what works **on this specific API key** (operational).
  `research/google-gemini-market.md` = general pricing/landscape. These serve different purposes.
- Commits use conventional commits. Default to `docs: ...`. Use `fix:` for broken links, `chore:` for cleanup.
