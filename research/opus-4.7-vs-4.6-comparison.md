# Claude Opus 4.7 vs 4.6: Which Is Better for What

Source: Web research (benchmarks, expert reviews, Reddit/HN/X anecdotes), 2026-05-05

---

Released: April 16, 2026. Same price ($5/$25 per million tokens), but a new tokenizer inflates actual token count by up to 35% on code-heavy prompts.

## Where 4.7 wins clearly

| Task | Evidence |
|------|----------|
| Agentic coding (multi-step, long-horizon) | 3× more production tasks resolved; CursorBench 70% vs 58%; self-verification loop (checks own work before reporting done); tool errors reduced to ⅓ |
| Vision / image understanding | CharXiv-R: 82.1% vs 68.7%; visual acuity +44pp; 98.5% vs 54.5% on vision accuracy |
| Feature work / greenfield implementation | Slightly better (75% vs 71.4% in one HN user's side-by-side); Anthropic says "hand off multi-hour engineering tasks" |
| Structured enterprise work | Legal (BigLaw 90.9%), data analysis (−21% errors) |
| Instruction following (explicit, structured prompts) | Stricter — treats bullet lists as hard requirements |

## Where 4.6 wins or holds

| Task | Evidence |
|------|----------|
| Long-context needle-in-haystack retrieval | MRCR benchmark roughly halved; "4.6 with 64k extended-thinking dominates 4.7 on multi-needle retrieval" — widely cited on HN/Reddit |
| One-shot coding & debugging | HN user's 3-day side-by-side: coding one-shot dropped 84.7% → 75.4%, debugging 85.3% → 76.5% |
| Conversational warmth / creative writing tone | Reddit/X complaints about "over-formatted outputs," loss of warmth, feels more "combative" |
| Vague or loosely-specified prompts | 4.7's stricter instruction following backfires when prompts are ambiguous — produces different/worse output |
| Multi-turn conversation coherence | Reported regression in context retention across long multi-turn sessions |
| Cost-sensitive workloads | Same sticker price but tokenizer inflation means 0–35% more tokens consumed for identical input |

## The nuanced middle

- **Creative writing (structured):** 4.7 wins on structured creative tasks (outlines, rewrites with clear specs). Loses on freeform/conversational creative where 4.6's looser interpretation was a feature.
- **Prompt migration:** Prompts tuned for 4.6's "loose interpretation" style often break on 4.7. Several reports of needing prompt rewrites.

## New capabilities in 4.7 only

- `xhigh` effort level — finer reasoning/latency tradeoff
- Task budgets (public beta) — cap token spend on long-running agentic jobs
- `/ultrareview` in Claude Code — multi-pass code review session
- Auto Mode for Max users

## Decision framework

**Use 4.7 if:** agentic coding, vision tasks, long-running autonomous work, structured outputs, new projects where you'll write prompts fresh.

**Stay on 4.6 if:** you rely on precise recall from very long documents (100k+ tokens), your prompts are vague/conversational, you need predictable token costs, you value the warmer conversational style, or you do a lot of one-shot debugging.

## Community consensus (post-honeymoon, ~2-3 weeks after launch)

"It's a trade, not a uniform upgrade." The benchmarks are real but so are the regressions. Power users are splitting traffic — 4.7 for agentic/vision, 4.6 for retrieval-heavy and conversational work.

Low-effort 4.7 matches medium-effort 4.6 on quality, so per-task cost can actually drop if you use effort levels strategically.

## Sources

- Anthropic official announcement (anthropic.com/news/claude-opus-4-7)
- allthings.how comparison and review
- verdent.ai agentic coding comparison
- HN item #47825673 (3-day real coding side-by-side)
- wentuo.ai (MRCR long-context regression analysis)
- boringbot substack (Reddit/X sentiment roundup)
- Business Insider ("The Claude-lash")
- mindstudio.ai review
- theneuron.ai live test (vision, long-context)
- llm-stats.com benchmark comparison
- maverickai.it benchmark guide
- epsilla.com ("The Opus 4.7 Paradox")
