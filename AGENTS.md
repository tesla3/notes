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
- Don't combine existing research files without explicit instruction.

## Backlink header format
```
← [Topic Name](../topics/X.md) · [Index](../README.md)
```

## Style
Research is opinionated, critical, and analytical — not balanced corporate prose.
Include honest assessments: verdicts, trade-offs, what's bad, what's good, self-corrections.

## Non-Obvious
- `research/google-gemini-api-key.md` = what works **on this specific API key** (operational).
  `research/google-gemini-market.md` = general pricing/landscape. These serve different purposes.
- Commits default to `docs` type. Use `fix` for broken links, `chore` for cleanup.
