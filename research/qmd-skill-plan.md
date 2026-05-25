# QMD Skill Plan for Pi

## Status

- **qmd repo**: cloned at `~/gh_repo/qmd`
- **qmd installed**: v1.0.7 at `/opt/homebrew/bin/qmd` — **broken** (native module `better-sqlite3` compiled for NODE_MODULE_VERSION 127, system requires 141). Fix: `npm rebuild -g @tobilu/qmd` or reinstall.
- **Skill location**: `~/.pi/agent/skills/qmd-search/`

---

## Research: Best Practices for Agent Skills (2025)

### Sources

- Claude official: https://docs.claude.com/en/docs/agents-and-tools/agent-skills/best-practices (also mirrors at `platform.claude.com`)
- agentskills.io spec: https://agentskills.io/specification
- Community (Minko Gechev): https://github.com/mgechev/skills-best-practices
- Anthropic complete guide (PDF → gist): https://gist.github.com/liskl/269ae33835ab4bfdd6140f0beb909873

### Key Takeaways

1. **Frontmatter is the only thing loaded at startup** — description must be trigger-optimized, third-person, specific
2. **Context window is a shared resource** — only add what the agent doesn't already know
3. **Progressive disclosure (3 levels)**: frontmatter → SKILL.md body → referenced files
4. **SKILL.md body < 500 lines / < 5000 tokens** — offload detail to `references/`
5. **References one level deep only** — no nested chains
6. **Third-person imperative** — "Search the index..." not "I will search..."
7. **Consistent terminology** — pick one term per concept
8. **Decision trees for conditional workflows** — guide the agent through branch points
9. **No absolute paths** — use relative paths or `$HOME`
10. **No time-sensitive info**, no redundant explanations of things the agent already knows

### Spec Constraints

- `name`: kebab-case, 1-64 chars, must match parent directory name
- `description`: max 1024 chars, include "what it does" + "when to use it" + negative triggers
- Keep metadata under ~100 tokens
- Scripts should handle errors explicitly, not punt to the agent
- Claude docs recommend **gerund form** naming (`searching-notes`, `processing-pdfs`); noun phrases (`qmd-search`) are listed as "acceptable alternatives"

---

## Why Not Use the Bundled `qmd` Skill?

The qmd repo ships `skills/qmd/SKILL.md`. It was designed for Claude Code with MCP and is a poor fit for pi:

| Problem | Impact in pi |
|---------|-------------|
| MCP-first structure (~35 lines of MCP JSON) | Pi has no MCP tools — 100% wasted tokens |
| `allowed-tools: Bash(qmd:*), mcp__qmd__*` | `mcp__qmd__*` is meaningless in pi |
| HTTP API section | Irrelevant to pi |
| CLI section is 6 lines, an afterthought | The ONE thing pi needs is the thinnest section |
| No explicit search→retrieve workflow | Agent must infer the two-step pattern |
| No safety section | "Never auto-run" rules live only in CLAUDE.md (not loaded by pi) |
| Setup section includes `collection add` + `embed` | Contradicts safety rules — agent might auto-run destructive commands |
| `!` auto-execute template syntax | Pi doesn't support this Claude Code feature |
| Missing CLI flags: `-c`, `-n`, `--min-score`, `--full`, `--line-numbers`, `-l` | Agent won't know these exist |
| No discovery workflow, no output format guidance | Agent flies blind |

**Conclusion**: ~60% of the bundled skill's tokens are irrelevant in pi, and critical CLI-specific guidance is missing. A separate skill is justified.

---

## Skill Design

### Name: `qmd-search`

Avoids collision with qmd's own bundled `skills/qmd/SKILL.md` (name: `qmd`).
Noun-phrase pattern — acceptable per Claude docs (gerund `searching-qmd` would also work but reads less naturally).

### Structure

```
qmd-search/
├── SKILL.md
└── references/
    └── query-syntax.md
```

### Description (draft)

```yaml
description: >-
  Searches and retrieves documents from local markdown knowledge bases using QMD
  hybrid search. Use when the user asks to search notes, find documents, look up
  information, check what they wrote about a topic, find meeting notes, or retrieve
  files from their indexed collections. Not for web search or non-indexed content.
```

### SKILL.md Outline (~120 lines)

| # | Section | What's in it | Lines |
|---|---------|-------------|-------|
| 1 | **Frontmatter** | name, expanded description with natural triggers + negative triggers, compatibility | 8 |
| 2 | **Verify** | `qmd status` — confirm installation and see collections | 3 |
| 3 | **Core workflow** | The two-step search→retrieve pattern: `query --json` → `get "#docid"`. THE key pattern. | 15 |
| 4 | **Which search command** | 4-row decision table: `query` (auto-expand + rerank, **default**) / `query $'lex:...\nvec:...'` (structured) / `search` (BM25 keywords, no LLM) / `vsearch` (semantic only) | 14 |
| 5 | **Query tips** | Lex essentials (`"phrase"`, `-exclude`), natural language for vec, expand as implicit default, `-c` collection filter, `-n`, `--min-score`, `--full` | 25 |
| 6 | **Retrieve documents** | `get` by path or `#docid` (`#` optional), `:line` suffix, `-l` max lines, `--line-numbers`, `multi-get` by glob or comma list | 15 |
| 7 | **Result triage** | Practical guidance: retrieve top 2–3 results; if top result scores far above the rest, it's likely sufficient; use `--min-score` to filter noise. No invented thresholds. | 6 |
| 8 | **Output formats** | Default CLI for simple lookups, `--json` for programmatic search→retrieve, `--md` for LLM context, `--files` for listings | 10 |
| 9 | **Discovery** | `status`, `ls [collection]`, `collection list`, `context list`, `context check` | 10 |
| 10 | **Safety** | Never auto-run `collection add`, `embed`, `update` — write commands for user to run manually | 6 |
| 11 | **Advanced queries** | One-line pointer to `references/query-syntax.md` for structured multi-line queries | 3 |

### references/query-syntax.md (~90 lines)

| Section | Content |
|---------|---------|
| Expand (auto-expand) | Implicit default of `qmd query`; explicit `expand: question`; do not mix with other typed lines |
| Structured query documents | Multi-line `lex:/vec:/hyde:` prefix syntax |
| When to use structured queries | Simple question → just `query` (implicit expand). Need precision → structured. |
| Lex syntax detail | Full table: prefix match, `"phrase"`, `-exclude`, `-"exclude phrase"` |
| Vec guidance | Natural language questions, be specific, include context |
| Hyde guidance | Write 50-100 word hypothetical answer passage |
| Combining types | First query gets 2× weight, lex+vec for best recall |
| CLI examples | `$'lex: ...\nvec: ...'` multi-line patterns, `$'expand: question'` |

---

## Design Decisions

| Decision | Rationale |
|----------|-----------|
| **Name: `qmd-search`** | Avoids collision with qmd's bundled `qmd` skill; clear and specific |
| **No `scripts/` directory** | `qmd` is a global CLI — no wrapper scripts needed |
| **Core workflow first** | Two-step search→retrieve is THE agent pattern; must be front-and-center |
| **`query` (expand) as the default** | It's what `qmd query "question"` actually does — implicit auto-expand + rerank |
| **Lex essentials in SKILL.md** | Phrases + negation are 3-4 lines; too common to hide in references |
| **Structured syntax + expand in references/** | Progressive disclosure — only loaded when agent needs multi-line queries |
| **CLI-only (no MCP/HTTP)** | Pi uses bash tool; bundled skill wastes ~60% of tokens on MCP/HTTP |
| **No fabricated score thresholds** | qmd docs have zero guidance on score ranges; BM25/vector/RRF scores have different scales. Practical triage guidance instead. |
| **Output format: conditional** | CLI for simple lookups, `--json` for structured search→retrieve workflow |
| **Safety section: short & imperative** | Critical constraint from qmd's CLAUDE.md; stated once clearly |
| **`context` commands in Discovery** | `context list` reveals what collections contain; high-value for agent orientation |

---

## Issues Found During Review (vs. Original Plan)

| Issue | Resolution |
|-------|-----------|
| Install status was wrong ("NOT YET") | Fixed — installed but broken, needs rebuild |
| Core workflow was implicit/scattered | Made it section #3, right after verify |
| `expand:` query type was missing entirely | Added as the default in decision table; full docs in references |
| Collection filter `-c` was missing | Added to query tips section |
| Score thresholds were fabricated | Replaced with practical triage guidance (no invented numbers) |
| Lex essentials hidden in references | Moved to SKILL.md; only full grammar in references |
| Description lacked natural triggers | Added "check what they wrote", "meeting notes", etc. |
| Output format too opinionated ("always --json") | Conditional: CLI for simple, --json for structured |
| `context` commands were missing | Added to Discovery section (`context list`, `context check`) |
| `--line-numbers` flag was missing | Added to Retrieve documents section |
| Bundled skill rationale was implicit | Added explicit "Why Not Use the Bundled Skill?" section |
| Source URLs needed cleanup | Replaced with canonical/verified URLs |

---

## Next Steps

1. Fix qmd: `npm rebuild -g @tobilu/qmd` (or reinstall to pick up v1.1.0 from repo)
2. Set up a test collection and run searches to validate the skill design
3. Write SKILL.md and references/query-syntax.md
4. Test the skill with pi — verify triggering, search→retrieve flow, safety guardrails
