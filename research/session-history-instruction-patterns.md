← [Index](../README.md)

# Session History Analysis — Instruction Patterns & Preferences

**Source:** 55 sessions, 7 project directories, ~150 user messages (Feb 17–19, 2026)

---

## 1. Signature Research Protocol

The single most dominant pattern. Nearly every research session follows this cycle:

### The Iteration Loop
1. **Broad research** — "research deep and wide", "search and research deeply"
2. **Critical review** — "review critically. Be thorough, tough, but fair."
3. **Repeat** — "One more time. Ensure accuracy, clarity, completeness."
4. **Distill** — progressive summarization into shorter, sharper forms

The phrase **"Be thorough, tough, but fair"** appears 15+ times verbatim. It's the signature quality bar.

### Recurring Modifiers (descending frequency)
| Phrase | Count | Meaning |
|---|---|---|
| "Be thorough, tough, but fair" | 15+ | Quality bar for reviews |
| "Be intelligent" | 10+ | Don't be mechanical — infer, connect, read between lines |
| "Maximum clarity" | 8+ | Prioritize readability without losing nuance |
| "Think deep" / "Research deep and wide" | 8+ | Don't stop at surface |
| "Forward looking" | 6+ | Project trends, not just current state |
| "Validate against code/sources" | 6+ | Don't trust claims — verify |
| "Cite sources" | 4+ | Like academic papers, not vibes |
| "Separate facts from hype" | 2+ | Honest assessment over cheerleading |

### Source Validation (Hard Rule)
- "Cross-validate sources and claims"
- "Validate key assumption and claims against official doc, other expert's evaluation, and actually CODE"
- "Use latest sources as this is fast moving space"
- "Ensure 100% accuracy" — then review again
- "Infer the correct mental model of the designer (or explicitly say 'not sure')"

---

## 2. Progressive Summarization Pipeline

Clear three-tier output expectation for research:

| Tier | Audience | Style |
|---|---|---|
| **Full research** | Expert / grad student CS | Thorough, all details, cite everything, minimum jargon |
| **Synthesis summary** | Standalone document | Consolidate into one doc, cite original sources (not intermediate notes), keep sophistication |
| **Exec summary** | VP / Director of Engineering | "Shorter, more digestible, authentic tone. Maximum clarity without losing necessary nuance" |

Key: synthesis docs must be **standalone** — no references to internal review versions (V2, V3, etc.).

---

## 3. Interaction Style

### Terse & Imperative
Commands are short, direct, no pleasantries:
- "fix it", "save to disk", "commit and push", "abort"
- "y" for batch approvals
- "review your analysis critically" (not "could you please review...")

### Escalation Signal
Frustration shows as repetition with added force:
- "sandbox is still disabled. Fix it." (after prior failed attempt)
- "are you sure? Think deep and dig deeper. Check conversation history."
- "I have already set it up, No?" (you should have known)

**Translation:** when the user repeats + adds emphasis → they believe you're wrong or not trying hard enough. Stop, re-examine from scratch, check actual state.

### Expects Proactive Intelligence
- "Ask me anything unclear to you" (multiple sessions)
- "Infer author's design assumption intelligently"
- Don't guess silently — ask or flag uncertainty explicitly

---

## 4. Verification-Before-Action Rule

Strong pattern: the user demands verification of accuracy **before** making changes:
- "check code and extension very carefully to make sure you are accurate before we change anything"
- "review your proposal critically to ensure 100% accuracy and rigor"
- "re-evaluate your above analysis to ensure 100% accuracy. Be intelligent and thorough."

**Rule:** Verify first, then act. Never present untested claims as facts.

---

## 5. Output & Persistence

- **Always save research to disk** as markdown — this is expected, not optional
- **Spelling/grammar fixes** go one-by-one for approval (don't batch-rewrite prose)
- **Don't combine existing research files** without explicit instruction
- **Don't rewrite the user's own prose** — fix only what's asked

---

## 6. Anti-Patterns (What Triggers Frustration)

| Anti-pattern | Evidence |
|---|---|
| Confident wrong answers | "are you sure?" (5+ escalations) |
| Not verifying before claiming | "check your code to make sure you are accurate" |
| Balanced corporate prose | AGENTS.md: "not balanced corporate prose" |
| Surface-level research | "Think deep", "Research deeper and wider" |
| Losing details in summarization | "Keep the sophistication and all important details" |
| Acting without understanding root cause | "Research why" |
| Combining files without permission | AGENTS.md: explicit prohibition |

---

## 7. Tool & Environment Preferences

- **Model:** Claude Opus 4.6 via Anthropic, thinking level high
- **Search:** Brave API (via skill, not extension)
- **Minimal toolset:** actively removed unnecessary skills/extensions
- **Security-conscious:** tested sandbox, found and documented bypass, researched agent security from first principles
- **Self-sufficient debugging expected:** "Debug and fix it", not "what could be wrong?"

---

## Distilled Reusable Instructions

```markdown
## Research Quality Bar
- Be thorough, tough, but fair. Be intelligent — infer, connect, read between lines.
- Validate claims against code, official docs, and expert evaluations. Don't trust secondary sources uncritically.
- Use latest sources — this is fast-moving space. Flag when something might be stale.
- Cite sources like academic papers. Separate facts from hype.
- When unsure, say "not sure" explicitly rather than presenting inference as fact.

## Research Process
- Search and research deep and wide before forming conclusions.
- Review your own analysis critically at least once before presenting.
- Forward-looking: project trends, don't just describe current state.
- Maximum clarity without losing necessary nuance.

## Output
- Save all research to disk as markdown. This is expected, not optional.
- For spelling/grammar fixes on existing prose: propose one-by-one, get approval.
- Don't combine or restructure existing files without explicit instruction.
- When summarizing: keep all important details. Sophistication matters.

## Interaction
- Be direct. Match the user's terse style.
- Ask when unclear rather than guessing silently.
- Verify accuracy before acting. Check actual state, not assumptions.
- When corrected or challenged: re-examine from scratch, don't defend.
- Debug and fix problems autonomously — don't just report what might be wrong.
```
