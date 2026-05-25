# AGENTS.md / CLAUDE.md Best Practices: Research & Critical Review

Source: Research synthesis from Anthropic docs, arxiv papers, practitioner blogs — March 2026

## The Evidence Base

### The arxiv paper everyone should read (2602.11988, Feb 2026)

"Evaluating AGENTS.md: Are Repository-Level Context Files Helpful for Coding Agents?" — 138 tasks across 12 repos, tested with Claude Code (Sonnet-4.5), Codex (GPT-5.2/5.1 mini), Qwen Code.

**Key findings:**
- LLM-generated context files **reduce** success rates by 0.5–2% and increase costs >20%
- Developer-written files offer only **~4% improvement** on their custom benchmark, with non-negligible cost increases
- Context files increase reasoning tokens by up to 22% — agents treat instructions as extra constraints
- **Codebase overviews don't help agents find files faster.** Despite being the most commonly recommended section, they're redundant with the file system itself
- Agents are highly compliant with context file instructions, which is the problem — unnecessary instructions create unnecessary work
- When all documentation is removed from a repo, LLM-generated context files become more beneficial — suggesting they mainly provide redundant information otherwise

### The practitioner evidence

**wordman.dev** — "Your Agent Instructions Are Probably Making Things Worse":
- Their IntelliJ monorepo AGENTS.md: **6KB / ~120 lines** for millions of LOC
- Author's side project rules: roughly 5x the size, "most of it was making things worse"
- Key insight: adding one more rule can cause the model to randomly ignore rules across the board
- Effective attention degrades well before the technical context limit

**Vercel's experiment** (via serenitiesai.com):
- Skills (on-demand loaded docs) failed — **56% of eval cases the skill was never invoked**
- AGENTS.md with pre-loaded context achieved 100% pass rate
- Compressed 40KB docs to 8KB using pipe-delimited index format while maintaining results
- "Prefer retrieval-led reasoning over pre-training-led reasoning" as a key instruction

**upsun.com** analysis of the arxiv paper:
- "Signal-to-noise ratio matters more than comprehensiveness"
- "A five-line context file that addresses your project's specific quirks will outperform a 2,000-word generated overview that restates your README"
- Recommends: start empty, add one rule at a time, only when you see the same mistake twice

### Anthropic's official guidance (code.claude.com, Jan 2026)

The official best practices doc is nuanced and good:
- "Keep it concise. For each line, ask: 'Would removing this cause Claude to make mistakes?' If not, cut it."
- "If Claude keeps doing something you don't want despite having a rule against it, the file is probably too long and the rule is getting lost"
- "Treat CLAUDE.md like code: review it when things go wrong, prune it regularly"

**What to include vs exclude:**

| ✅ Include | ❌ Exclude |
|---|---|
| Bash commands Claude can't guess | Anything Claude can figure out by reading code |
| Code style rules differing from defaults | Standard language conventions |
| Testing instructions and preferred runners | Detailed API documentation (link instead) |
| Repo etiquette (branch naming, PR conventions) | Information that changes frequently |
| Architectural decisions specific to project | Long explanations or tutorials |
| Dev environment quirks (required env vars) | File-by-file codebase descriptions |
| Common gotchas or non-obvious behaviors | Self-evident practices like "write clean code" |

### Cross-tool convergence (arxiv 2602.14690, Feb 2026)

Survey of 37,249 repos: context files are converging on a common pattern across tools. AGENTS.md is now recognized by Claude Code, Codex, Cursor, Copilot. CLAUDE.md is Claude-specific. The mechanism taxonomy: context files, settings, skills, subagents, commands, hooks, rules, MCP.

## Synthesized Best Practices

### 1. Less is more (empirically proven)

Every line must justify its existence by preventing a real, repeated mistake. The arxiv paper proves that bloat actively hurts performance. The wordman.dev anecdote of 6KB for millions of LOC is the right order of magnitude.

### 2. Don't tell the agent what it can discover

Codebase overviews, directory structures, language/framework details, file-by-file descriptions — all proven to not help and to increase costs. The file system is the overview.

### 3. Tell the agent what it can't discover

- Non-obvious tool choices (pnpm not npm, micromamba not conda)
- Exact commands for build/test/lint
- Style rules that deviate from defaults
- Environment quirks that cause silent failures
- Gotchas and non-obvious behaviors

### 4. Build incrementally, not upfront

Start empty. Add rules only when you see the same mistake twice. Prune rules that aren't changing behavior. `/init`-generated files are the worst starting point.

### 5. Concrete over abstract

"Use `ruff check` before committing" beats "Follow Python best practices." File paths and exact commands beat descriptions.

### 6. Layered hierarchy works

- Global (`~/.pi/agent/AGENTS.md`): cross-project preferences
- Workspace root: project-specific instructions
- Subdirectories: scope-specific overrides
- Conditional navigation ("if doing X → read Y") prevents bloat

### 7. Test your AGENTS.md like code

If Claude ignores a rule, the file is too long or the rule is ambiguous. Remove rules that aren't needed. Version-control it. Review when things go wrong.

---

## Critical Review of Our Files

### Global AGENTS.md (~/.pi/agent/AGENTS.md)

**Size:** ~3.5KB, ~95 lines. Moderate — within the effective range but pushing it.

**What's good:**
- Concrete commands throughout (`micromamba run -n <env-name>`, `ruff check`, conventional commit format)
- The "CLI Tool Use" section with the decision ladder is genuinely valuable — this is a non-obvious behavior the agent can't discover, and it saves real tokens
- Environment quirk about `micromamba activate` failing in pi's shell — exactly the kind of gotcha that belongs here
- Self-improvement mechanism ("next time" → update AGENTS.md) is smart meta-instruction

**What's questionable:**
- **"CLI Tool Use" section is ~40% of the file.** It's the longest section and contains detailed examples. Research says long files cause random rule-dropping. This section is genuinely useful but its length may be drowning out other instructions. Consider: is the agent actually following the decision ladder consistently? If not, the section may be too long to be effective.
- **"Be direct. Match the user's terse style."** — Models already tend toward concise output with terse users. Is this preventing a real mistake?
- **"Verify accuracy before acting and after changing."** — Generic good practice. Does removing this cause Claude to make mistakes? Probably not — it's self-evident.
- **"Be complete, consistent, and no-dup"** in Documentation section — vague. What does "no-dup" mean operationally?
- **"Layer linked docs by distance"** — Interesting but abstract. Is the agent actually implementing this? Hard to verify.
- **Stack section** lists Python 3.14 — this is discoverable from pyproject.toml in each project. Does it need to be here?

**Verdict:** Good bones, ~25% could be pruned. The CLI Tool Use section is the highest-value content but may need compression. The interaction style guidelines are mostly self-evident noise.

### Workspace AGENTS.md (/Users/realname/agent/AGENTS.md)

**Size:** ~2.5KB, ~75 lines. Good — concise and focused.

**What's good:**
- Opens with the most critical fact: "This workspace contains three note directories. No code. Pure markdown." — immediately scopes everything
- Sensitivity section with bright-line rules — critical safety instruction, exactly what belongs in a context file
- Research Writing guidelines are high-value — these are genuinely non-obvious preferences the agent couldn't infer
- "Don't" section at the end — explicit anti-patterns, proven effective in practice
- qmd commands are exact and copy-pasteable

**What's questionable:**
- **Source Credibility Checks section** — is this actually invoked often enough to justify permanent context? It's very specific to one type of research task. This might be better as a skill file loaded on demand.
- **"Be thorough, tough, but fair"** — style guidance that's somewhat vague. "Opinionated, critical, and analytical — not balanced corporate prose" is better — it's a concrete anti-pattern.
- **Filing section** lists directory structure — the arxiv paper says directory overviews don't help. However, this is a non-standard structure (personal_notes/research/ vs root) that *can't* be inferred from the file system alone because the *intent* behind each directory matters. Edge case where it's probably justified.

**Verdict:** Best of the three. Tight, focused on what the agent can't discover, concrete commands, clear boundaries. Source Credibility Checks is the one section that might be better as a skill.

### Internal Tooling AGENTS.md (/Users/realname/agent/internal_tooling/AGENTS.md)

**Size:** ~3.5KB, ~95 lines. Moderate.

**What's good:**
- Active/Retired skills tables — prevents the agent from using deprecated code paths
- tmux testing instructions with exact commands — non-obvious, concrete
- "When to test" section — clear decision rules
- Prerequisites section — prevents cryptic failures

**What's problematic:**
- **The entire "Structure" section, Active Skills table, Retired Skills table, and Dependencies section** are essentially a README/codebase overview. The arxiv paper specifically found these don't help. The agent can discover what's in `internal-pi-skills/` by looking. It can read SKILL.md files. It can find dependencies in the scripts themselves.
- **The Active Skills table duplicates what's in each skill's SKILL.md.** The agent will read those files when working on them anyway.
- **Dependencies section** lists `jq`, `node`, `raw`, `builder-mcp` — all discoverable from the scripts. If `raw` is missing, the script will fail with an error that tells the agent what's needed.
- **Design docs section** — "here are some files in the notes/ directory" is discoverable by `ls notes/`.
- **The file is ~50% codebase overview** that the research says doesn't help and actively costs tokens.

**The testing section is the only part that earns its keep.** tmux usage, the filter argument, when to test — these are all non-obvious behaviors the agent would get wrong without instruction.

**Verdict:** Weakest of the three. Half the file is a README-style overview that the research says is counterproductive. Should be aggressively pruned to the testing section plus any gotchas/non-obvious rules. The overview content belongs in a README.md (for humans) not AGENTS.md (for the agent).

## Summary Recommendations

| File | Action | Impact |
|---|---|---|
| Global | Compress CLI Tool Use (~40% → ~20%), prune self-evident interaction style rules | Moderate — prevents rule-dropping |
| Workspace | Consider moving Source Credibility Checks to a skill | Minor — already good |
| Internal Tooling | **Aggressive prune**: remove overview/structure/dependencies sections, keep testing + gotchas only. Move overview content to README.md | High — currently ~50% counterproductive content |

**Meta-rule for all three:** Apply the arxiv paper's test — for each line, ask: "Would removing this cause the agent to make a mistake it can't recover from?" If no, cut it.
