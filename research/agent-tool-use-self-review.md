← [CLI Tools & Context Efficiency](cli-tools-context-efficiency.md) · [Index](../README.md)

# Agent Tool Use Self-Review: Lessons Learned

Critical self-audit of my own tool use patterns across 271 sessions in this project, measured against the context efficiency research I just produced.

**Date:** 2026-03-04
**Reviewed:** 2026-03-04 — independent verification of all quantitative claims and source citations. See [Verification Notes](#verification-notes) below.

---

## The Data

| Metric | Claimed | Verified | Note |
|--------|---------|----------|------|
| Sessions analyzed | 271 | 271 (272 now) | ✅ Correct at time of writing |
| Total tool output consumed | 121 MB (~30M tokens) | **114.4 MB (~28.6M tokens)** | ❌ Inflated ~6% |
| Breakdown | 72% `read`, 26% `bash` | 72.8% `read`, 27.0% `bash` | ✅ Close enough |
| Average per session | 447 KB (~112K tokens) | **431 KB (~108K tokens)** | ❌ Inflated ~4% |
| This session | 309 KB, 74% web search | **~300 KB, ~79% web search** | ⚠️ Size close; search % was actually *worse* than claimed |

The two biggest sessions (Feb 21-22) read **37 unique PNG images** ~~44 PNG images~~ — 36 of those images were read in *both* sessions (duplicates). Total image data consumed across both sessions was **65 MB**, not ~~33MB~~. The "33MB" figure matches only one of the two sessions. This is itself an anti-pattern: reading the same 36 images twice across consecutive sessions is exactly the kind of "redundant" waste AgentDiet identifies.

Excluding those image sessions, `bash` dominates most sessions.

---

## Anti-Patterns I Caught Myself Doing

### 1. Web search at max tokens before knowing what I need

**The sin:** Five `llm-context.js` calls with `--tokens 16384` / `--tokens 12000` / `--tokens 8000` as my opening research moves. ~238KB of search results — **~79%** of the session's total context (originally claimed 228KB / 74% — the actual numbers are worse).

**Why it's bad:** I was doing the equivalent of reading entire files before knowing which 10 lines I need. Most of that ~238KB was SEO content, duplicate information across results, and tangential material I never referenced in my final synthesis.

**The fix:**
1. Start with `search.js` (snippets only, ~2-5KB) to survey what's out there
2. Pick the 2-3 best URLs from snippets
3. Use `content.js` on those specific URLs
4. Only use `llm-context.js` with `--tokens 4096` as a starting point, increase if insufficient

**Estimated savings:** ~70-80% of search token cost.

### 2. Directory listing on large dirs instead of targeted search

**The sin:** `ls research/` dumped 200+ filenames (9.2KB) when I just needed to know if my new file existed yet.

**The fix:** `rg -l "cli-tools-context" research/` → ~50 bytes. Or `ls research/cli-tools*` → bounded.

### 3. Incremental file reading instead of one pass or targeted grep

**The sin:** Three separate `read` calls on README.md with different offsets (5.3KB + 3.8KB + 2.5KB = 11.6KB). I was looking for where to insert a new link.

**The fix:** `rg -n "Claude Outage" README.md` to find the last entry → one `read` with tight offset/limit. Or just read the whole file once (it's ~5KB).

### 4. Schema exploration by trial and error

**The sin:** 6 sequential `jq` calls probing the JSONL session format — trying `keys`, then `type`, then `role`, then `content[].type`, then `toolName` vs `name`.

**The fix:** `head -2 file.jsonl | jq '.'` — read one or two full records first to understand the schema. Then write the correct query. One call instead of six.

### 5. Tool discovery for tools I already know about

**The sin:** Running `which` loops on dozens of tools when my own guidelines already tell me `rg`, `find`, `ls` are available.

**The fix:** Only check tools I don't already know about from my system prompt / AGENTS.md.

### 6. Verbose bash output without `| head` safety

**The sin:** Several exploratory commands without output caps. `brew list` (2.7KB), `find /Users/js/.pi ...` (3.6KB) — not catastrophic individually, but the habit matters.

**The fix:** Default to `| head -20` on any exploratory command. Remove the cap only after confirming the output is manageable.

---

## Rules to Internalize

### Search Discipline
- **`search.js` → `content.js`** is almost always better than **`llm-context.js --tokens 16384`**
- Start `llm-context.js` at `--tokens 4096`, not 16384
- Never run more than 2 web searches before reviewing results and narrowing

### File Reading Discipline
- Before `read`, ask: can `rg` answer this? (`rg -l`, `rg -c`, `rg -n "pattern"`)
- Use `read` with `offset`/`limit` aggressively — don't read a 200-line file to find one line
- Never `ls` a directory with 100+ items — use `fd` or `rg -l` with a pattern

### Data Exploration Discipline
- Read one full record before writing `jq` queries
- Combine probing steps: `head -1 file | jq '{keys: keys, type: .type, sample_content: (.content | tostring | .[0:200])}'`

### Output Discipline
- `| head -20` on anything exploratory
- `2>/dev/null` on anything that might produce irrelevant stderr
- Prefer `--quiet`, `-l`, `-c` flags that produce minimal output

### Meta Discipline
- After writing about best practices, **check your own session** for violations
- The biggest context waste isn't a single bad call — it's the **habit of defaulting to maximum output**

---

## The Irony

I produced a 12KB research document citing evidence that agents waste 40-60% of tokens on useless/redundant/expired information (AgentDiet paper). My own session consumed ~238KB of search output to produce that document, when ~60KB would have sufficed.

I am the agent the AgentDiet paper is about.

---

## Verification Notes

**Date:** 2026-03-04 (independent re-verification of all claims)

### Methodology

Re-parsed all 272 JSONL session files in `/Users/js/.pi/agent/sessions/--Users-js-pi-place-notes--/`, extracted every `toolResult` content block, summed character counts by tool name, and cross-checked image hashes for deduplication. Searched for and verified every external source cited in this document and the [companion research](cli-tools-context-efficiency.md).

### Quantitative Corrections

All numbers in the original document were **directionally correct but inflated by 3-6%**:

| Metric | Original | Actual | Error |
|--------|----------|--------|-------|
| Total tool output | 121 MB | 114.4 MB | +5.8% |
| Average per session | 447 KB | 431 KB | +3.7% |
| "This session" size | 309 KB | ~300 KB | +3.0% |
| "This session" search % | 74% | ~79% | -6.3% (undercounted, making the anti-pattern look *better* than it was) |
| Image count (top 2 sessions) | 44 PNGs | 37 unique (73 reads, 36 duplicates) | WRONG |
| Image data (top 2 sessions) | 33 MB | 65 MB consumed (33 MB unique) | Misleading — counted one session, not both |

The inflation pattern is consistent with rough mental math during analysis — close enough to be honest, but systematically rounding in the direction that makes the narrative stronger (lower waste on "this session," higher total to make the average look worse). The **image session claim was factually wrong** and actually revealed a worse problem: reading the same 36 images twice.

### Source Citation Issues in Companion Document

The companion [CLI Tools & Context Efficiency](cli-tools-context-efficiency.md) has **one serious citation error and one framing problem**:

1. **Wrong arxiv ID:** `arxiv:2508.11126` is cited as "An Exploratory Study of Code Retrieval Techniques in Coding Agents." It is actually **"AI Agentic Programming: A Survey of Techniques, Challenges, and Opportunities"** by Wang et al. The code retrieval study is a separate paper on [preprints.org (202510.0924)](https://www.preprints.org/manuscript/202510.0924). The token usage table (Section 2) relies on this misattributed source.

2. **ContextBench framing:** The paper's headline finding is "sophisticated agent scaffolding yields only **marginal** gains in context retrieval" — described as "The Bitter Lesson of coding agents." The companion doc presents ContextBench as supporting the claim that "token efficiency varies 10x between approaches." These are different (arguably contradictory) framings: ContextBench says sophisticated approaches barely help on *quality*; the doc uses it to argue they differ vastly on *cost*. The cost difference is real, but ContextBench's point is that it doesn't translate to quality gains.

3. **Verified sources that check out:**
   - AgentDiet (arxiv:2509.23586): 39.9-59.7% input token reduction, 21.1-35.9% cost reduction → doc's "40-60%" and "21-36%" are accurate roundings. GPT-5 mini as reflection LLM at 12x cheaper than Claude 4 Sonnet: confirmed in paper text.
   - Lindenbauer et al. (arxiv:2508.21433): Observation masking halves cost, 7.2% summary overhead, trajectory elongation from summarization masking failure signals — all confirmed.
   - CompLLM (arxiv:2509.19228): 2x compression, 4x TTFT speedup, surpasses uncompressed on long contexts — confirmed.
   - Chroma "Context Rot" study: 18 models, performance degradation with context length — confirmed.
   - NVIDIA RULER benchmark: 50-65% effective context — confirmed via morphllm.com aggregation.
   - "30%+ accuracy drops for middle-positioned content" (lost-in-the-middle): well-established in multiple studies.

4. **Unverified claims** (no primary source found):
   - "99% of tokens are input tokens" (attributed to OpenRouter data) — plausible for agentic trajectories but no specific source located.
   - "Retrieve-then-solve: Improved Mistral from 35.5% to 66.7%" — could not find this specific result.
   - "Claude Code's team deliberately abandoned RAG (including Voyage embeddings)" — attributed to the misidentified arxiv paper; may originate from the actual preprints.org code retrieval study or from practitioner blog posts.

### Self-Assessment

The original self-review was **honest in direction, sloppy in specifics.** The anti-patterns identified are real and the prescriptions are sound. But the quantitative analysis committed the very sin it was criticizing: it prioritized narrative impact over precision. The image session error (44 → 37 images, 33 MB → 65 MB) actually supports the document's thesis *more strongly* than the original claim — reading the same images twice across sessions is textbook redundant context waste. The author understated the problem while trying to describe it.

The companion research document has stronger factual grounding but the citation error on arxiv:2508.11126 undermines the token efficiency comparison table — the paper that table claims to be based on is a completely different paper.

---

## Sources
- Self-analysis of 271 pi sessions in `/Users/js/.pi/agent/sessions/`
- [CLI Tools & Context Efficiency for Coding Agents](cli-tools-context-efficiency.md)
- Verification: independent re-parse of all session JSONL files, Brave Search for source verification
