← [Index](../README.md)

# AGENTS.md / CLAUDE.md Best Practices: What the Best Practitioners Do

Cross-referencing practitioner wisdom, official guidance, and quantitative research to evaluate our global AGENTS.md against the state of the art.

**Date:** 2026-03-04
**Sources:** Anthropic official docs, GitHub Blog (2,500-repo analysis), HumanLayer (instruction budget research), Arize (prompt learning optimization), Buildcamp (2026 guide), rosmur compilation (12-source synthesis), practitioner posts (Shankar, Hwee-Boon Yar, builder.io)

---

## The Consensus: What the Best Practitioners Agree On

Seven high-credibility sources converge on a consistent framework. Ordered by strength of evidence.

### 1. Instruction Budget Is Real and Quantified

**Sources:** HumanLayer (citing arxiv:2507.11538), Buildcamp, AIHero, Anthropic official costs page

Frontier thinking LLMs can reliably follow **~150–200 instructions**. Claude Code's system prompt already consumes ~50. That leaves **~100–150 for your AGENTS.md + user messages + conversation history** before instruction-following degrades.

Key findings from the research:
- Performance degrades **uniformly** — not just later instructions, ALL of them get followed less
- Smaller models show **exponential** decay; frontier thinking models show linear decay
- LLMs bias toward instructions at the **peripheries** of the prompt (beginning and end)
- As instructions increase, the model doesn't just ignore new ones — it starts ignoring everything more

**Anthropic's official recommendation:** keep CLAUDE.md under ~500 lines. HumanLayer's recommendation: as few as possible. Their own root file is <60 lines. General consensus: <300 lines.

**Implication for us:** Our global AGENTS.md is **95 lines, ~55 discrete instructions**. Combined with pi's system prompt (which is separate from Claude Code's 50-instruction system prompt), we're well within budget. This is a strength, not a weakness.

### 2. Progressive Disclosure Is the Only Way to Scale

**Sources:** HumanLayer, Buildcamp, AIHero, Anthropic official, GitHub Blog

The unanimous recommendation: don't dump everything in the root file. Use conditional references.

| Strategy | Description |
|---|---|
| Separate docs | `agent_docs/running_tests.md` referenced from root |
| Skills | On-demand context loaded when relevant |
| Scoped rules | YAML frontmatter in `.claude/rules/` scoping to file patterns |
| Subdirectory AGENTS.md | Loaded on-demand when working in that directory |
| Conditional navigation | "if doing X → read Y" (our approach) |

**Our approach matches best practice.** Our Documentation section explicitly says: "Structure AGENTS.md as conditional navigation ('if doing X → read Y'), not flat inventories." We use skills for specialized tasks (browser automation, commit workflow, search tools). The available_skills block in pi is already progressive disclosure — descriptions + paths, loaded on demand.

### 3. Document Corrections, Not Education

**Sources:** HumanLayer, rosmur compilation (Shankar), Buildcamp, Hwee-Boon Yar

The most effective instructions are **behavioral corrections** — things the agent gets wrong without guidance:

> "Don't write a comprehensive manual. Document what Claude gets wrong." — Shankar (via rosmur)

> "I add instructions as problems come up." — Hwee-Boon Yar (2 days ago)

The anti-pattern: treating AGENTS.md as a textbook that teaches the agent things it already knows. "Write clean code" is waste. "Use `pnpm` (not npm)" is a correction.

**Test:** For each instruction, ask: "Would removing this cause Claude to make mistakes?" If not, cut it.

**Our file passes this test.** Every instruction either:
- Corrects a default I'd get wrong ("push directly to main — no feature branches")
- Documents non-default conventions ("conventional commits," "micromamba not conda")
- Prevents a specific failure mode ("`micromamba activate` will fail," "`| tail` misses stderr")
- Defines user preferences ("Be direct. Match terse style.")

I found zero "write clean code" fluff.

### 4. Commands Early, Specific, With Flags

**Sources:** GitHub Blog (2,500-repo analysis), Anthropic official, Factory docs, Hwee-Boon Yar

The GitHub Blog analysis of 2,500 AGENTS.md files found the single strongest differentiator:

> "Put relevant executable commands in an early section: `npm test`, `npm run build`, `pytest -v`. Include flags and options, not just tool names."

And: "One real code snippet showing your style beats three paragraphs describing it."

**Our file does this.** Micromamba commands with exact flags (`pytest -xvs`), ruff commands, conventional commit format with type list. Commands appear throughout rather than in one block, which is fine since our file is short enough that position doesn't matter much.

### 5. Six Core Areas

**Sources:** GitHub Blog, Factory docs, Buildcamp

The top-tier AGENTS.md files cover:

| Area | Our Coverage |
|---|---|
| **Commands** | ✅ Micromamba run, ruff, pytest |
| **Testing** | ✅ "MUST run tests before committing" |
| **Project structure** | ⚠️ Implicit (flat module preference) — but global file, not project-specific |
| **Code style** | ✅ ruff check/format, flat modules |
| **Git workflow** | ✅ Conventional commits, push to main |
| **Boundaries** | ✅ "never install into base," "Do NOT modify global AGENTS.md" |

Project structure is the one area where we're light — but that's correct for a global file. Project-specific structure belongs in project AGENTS.md files.

### 6. Don't Auto-Generate, Don't Use as Linter

**Sources:** HumanLayer, Buildcamp, AIHero

Multiple sources explicitly warn against `/init` or auto-generation:

> "CLAUDE.md is the highest leverage point of the harness. Avoid auto-generating it. You should carefully craft its contents." — HumanLayer

> "Never send an LLM to do a linter's job." — HumanLayer

**We follow both.** Our code style section uses ruff (a real linter/formatter), not AGENTS.md rules, to enforce style. The AGENTS.md just says "MUST pass ruff check and ruff format" — delegating enforcement to the tool, not the model.

### 7. Stale Docs Poison Context

**Sources:** AIHero, Buildcamp, Anthropic official

> "If your AGENTS.md says 'authentication logic lives in src/auth/handlers.ts' and that file gets renamed or moved, the agent will confidently look in the wrong place." — AIHero

File paths change constantly. Document **capabilities and concepts**, not locations.

**Our file has zero file paths** (except the tools-installed section, which is stable). All references are to tools and commands, not file locations. This is correct.

---

## What the Research Adds Beyond Practitioner Wisdom

### Arize Prompt Learning: +5–11% from Instructions Alone

Arize used reinforcement-learning-style optimization on Claude Code's system prompt, testing on SWE-Bench Lite:
- **By-repo split** (general coding): +5.19% accuracy
- **Within-repo** (same codebase): +10.87% accuracy

No architecture changes, no fine-tuning — purely better instructions. This confirms that AGENTS.md is genuinely high-leverage, not placebo.

**Implication:** Our instructions are the right place to invest effort. Every line matters.

### Claude Code's System-Reminder Wrapper

HumanLayer discovered via API proxy that Claude Code wraps CLAUDE.md content with:

```
<system-reminder>
IMPORTANT: this context may or may not be relevant to your tasks. 
You should not respond to this context unless it is highly relevant to your task.
</system-reminder>
```

This means Claude actively ignores CLAUDE.md content it deems irrelevant to the current task. The more noise in the file, the more likely important rules get ignored too.

**Relevance to us:** We use pi, not Claude Code, so this exact wrapper doesn't apply. But the underlying principle is universal — irrelevant instructions dilute relevant ones. Our file's tightness is an advantage.

### Periphery Bias: Position Matters

LLMs attend more strongly to instructions at the **beginning** and **end** of the prompt. Our layout:

| Position | Section | Importance |
|---|---|---|
| **Beginning** | Scope, Environment → **Interaction** | Interaction rules are high-frequency ✅ |
| **Middle** | Stack, Code Style, Environments, Testing, Git, Docs, Work Log | Standard operational rules |
| **End** | Self-Improvement → **CLI Tool Use** → tools installed | CLI section is high-frequency ✅ |

Our most important behavioral rules (Interaction, CLI Tool Use) are at the peripheries. Whether this was intentional or accidental, it's optimal.

---

## Critical Review of Our AGENTS.md

### What's Strong

1. **Instruction count (~55) is well within budget.** Combined with whatever system prompt pi uses, we have headroom. Most practitioners' files are 2–5x longer.

2. **Every instruction passes the "would removing it cause mistakes?" test.** No fluff, no "write clean code," no obvious programming wisdom.

3. **Progressive disclosure is structural.** The skills block, conditional navigation principle, and documentation layering all implement this correctly.

4. **Commands are specific with flags.** `micromamba run -n <env-name> pytest -xvs`, `ruff check`, conventional commit format.

5. **CLI Tool Use section is uniquely valuable.** No other AGENTS.md I found in the research has anything comparable — most are pure project-configuration. Ours directly improves agent efficiency at the tool-call level, backed by quantitative research. This is a genuine innovation.

6. **No file paths.** Immune to the stale-docs-poisoning problem.

7. **Corrections, not education.** The file documents behavioral corrections and non-default conventions, exactly as best practice recommends.

8. **Linting delegated to tools.** ruff handles code style; AGENTS.md just says to run it. Proper separation of concerns.

### What Could Be Improved

1. **No "provide alternative, not just prohibition" check.** Multiple sources emphasize: "Never use --foo-bar" causes the agent to get stuck. Always provide the preferred alternative. Let me check our prohibitions:
   - "never install into base" → ✅ followed by "Use: `micromamba run -n <env-name> <command>`" (alternative provided)
   - "Do NOT modify global AGENTS.md without explicit permission" → ⚠️ No alternative. But this is a hard boundary, not a workflow choice. Acceptable.
   - "No GUI suggestions" → ⚠️ No alternative, but "Terminal, vim, tmux user" is the implicit alternative. Could be tighter.
   - "no feature branches or PRs" → ✅ "push directly to main" is the alternative

   **Verdict:** Mostly fine. No action needed.

2. **Missing: one-sentence scope description.** Multiple sources recommend starting with a one-liner about what this file IS. Our Scope section says "These rules apply to all projects unless overridden by a project AGENTS.md" — which is technically scope, but doesn't orient the agent on WHO the user is or WHAT kind of work this covers.

   **However:** This is a global file. The user is a single person. Project-level context belongs in project files. The Interaction section ("Be direct. Match terse style.") and Environment section ("Terminal, vim, tmux user") already establish the user persona. Adding more would be noise.

   **Verdict:** No change needed. The current Scope + Environment + Interaction trio already serves this purpose.

3. **IMPORTANT prefix consistency.** Three sections use "IMPORTANT:" (Python Environments, Git Conventions, Documentation). The research on instruction emphasis is mixed — Anthropic says you CAN use "IMPORTANT" or "YOU MUST" to improve adherence, but overuse dilutes the signal. Three uses in a 95-line file is fine. The self-review found these ARE the rules I most commonly violate, so the emphasis is data-driven.

4. **The CLI section is the longest section (~30 lines out of 95).** Some practitioners might argue this should be a skill or separate doc. But:
   - It applies to literally every tool call in every session
   - It directly reduces context consumption (meta-optimization: the rules about saving context themselves save context)
   - Moving it to a skill risks it not being loaded when needed most (first tool call)
   
   **Verdict:** Keep inline. The cost of having it in every session (~30 lines ≈ ~600 tokens) is paid back within the first 2-3 optimized tool calls.

5. **No explicit "verify your work" instruction.** Anthropic's #1 best practice is "Give Claude a way to verify its work." Our "MUST run tests before committing" partially covers this, but it's limited to commits. We don't explicitly say "verify changes work before reporting success."

   **However:** This is borderline "obvious programming wisdom" — I do verify my work without being told. Adding it would add an instruction for marginal gain. The user's Interaction rules ("Verify accuracy before acting. Check actual state, not assumptions.") already cover the spirit.

   **Verdict:** Already covered by Interaction rules. No change needed.

### What's Missing That Others Have (And Whether We Need It)

| Common in other files | In ours? | Need it? |
|---|---|---|
| Project description / purpose | No | No — global file, not project-specific |
| Tech stack with versions | Yes | ✅ |
| File structure overview | No | No — project-specific |
| Architecture decisions | No | No — project-specific |
| Deployment commands | No | No — project-specific |
| Security boundaries | Partial | "never install into base" — sufficient for global |
| "Don't modify X files" | Yes | "Do NOT modify global AGENTS.md" ✅ |
| Hook/automation setup | No | No — pi uses skills, not hooks |
| Code review instructions | No | No — user reviews via git, not agent self-review |
| Planning mode instructions | No | No — implicit in "verify accuracy before acting" |
| Multiple CLAUDE.md hierarchy | N/A | N/A — pi uses different mechanism |

**Verdict:** Nothing missing that should be in a global file.

---

## Final Assessment

**Our AGENTS.md is in the top tier of what the research recommends.** It's:

- **Lean** (95 lines, ~55 instructions — well under the 150-200 budget)
- **Correction-oriented** (every rule prevents a real mistake)
- **Progressive** (skills for specialization, conditional navigation for docs)
- **Specific** (commands with flags, not vague guidance)
- **Innovation-forward** (CLI Tool Use section has no equivalent in the wild)
- **Properly positioned** (important rules at peripheries)
- **Stale-proof** (no file paths, no architecture specifics)

The one legitimate criticism is that the CLI section is long relative to the rest of the file. But the quantitative evidence from our own research (cli-tools-context-efficiency.md, agent-tool-use-self-review.md) shows the cost-benefit is overwhelmingly positive — 30 lines of instruction prevent thousands of wasted tokens per session.

**No material changes recommended.** The file is well-optimized for its purpose.

---

## Key Sources

- Anthropic, "Best Practices for Claude Code," code.claude.com/docs/en/best-practices, 2026
- Anthropic, "Manage costs effectively," code.claude.com/docs/en/costs, 2026
- Matt Nigh (GitHub), "How to write a great agents.md: Lessons from over 2,500 repositories," github.blog, Nov 2025
- HumanLayer, "Writing a good CLAUDE.md," humanlayer.dev/blog, Nov 2025 (citing arxiv:2507.11538 on instruction-following limits)
- Buildcamp, "The Ultimate Guide to CLAUDE.md in 2026," buildcamp.io, Feb 2026
- AIHero, "A Complete Guide To AGENTS.md," aihero.dev, 2026
- rosmur, "Claude Code Best Practices" (12-source synthesis), rosmur.github.io, 2025
- Arize, "CLAUDE.md: Best Practices Learned from Optimizing with Prompt Learning," arize.com/blog, Nov 2025
- Shankar, "How I Use Every Claude Code Feature," blog.sshh.io, Nov 2025
- Hwee-Boon Yar, "How I Write and Maintain AGENTS.md for My Coding Agents," hboon.com, Mar 2026
- Factory, "AGENTS.md," docs.factory.ai, 2026
- OpenAI, "Custom instructions with AGENTS.md," developers.openai.com/codex, 2026
- agents.md (open standard), agents.md, 2025–2026
