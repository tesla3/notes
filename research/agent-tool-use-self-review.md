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

**Estimated savings:** ~70-80% of search token cost. **Verified:** `llm-context.js --tokens 16384` → 77.8 KB. `search.js` + `content.js` on best URL → 34 KB (56% savings). `llm-context.js --tokens 4096` → 21 KB (73% savings). The 70-80% estimate holds when you factor in the original session's *five* calls at max tokens vs what a disciplined pipeline would produce.

### 2. Directory listing on large dirs instead of targeted search

**The sin:** `ls research/` dumped 200+ filenames (9.2KB) when I just needed to know if my new file existed yet.

**The fix:** `rg -l "cli-tools-context" research/` → ~50 bytes. Or `ls research/cli-tools*` → bounded.

### 3. Incremental file reading instead of one pass or targeted grep

**The sin:** Three separate `read` calls on README.md with different offsets (5.3KB + 3.8KB + 2.5KB = 11.6KB). I was looking for where to insert a new link.

**The fix:** `rg -n "Claude Outage" README.md` to find the last entry → one `read` with tight offset/limit. Or just read the whole file once (it's ~5KB).

### 4. Schema exploration by trial and error

**The sin:** 6 sequential `jq` calls probing the JSONL session format — trying `keys`, then `type`, then `role`, then `content[].type`, then `toolName` vs `name`.

**The fix:** `head -2 file.jsonl | jq '.'` — read one or two full records first to understand the schema. Then write the correct query. One call instead of six.

**Nuance (verified):** The "good" approach actually produces *more* raw output (~2.4 KB vs ~0.8 KB from 6 probes) because a full JSON pretty-print is verbose. The savings are in **trajectory turns, not output bytes** — each turn adds ~1.2 KB of non-thinking assistant content (text + tool call args, measured across 50 sessions) that snowballs through the context window. 6 turns × 1.2 KB × ~10 remaining turns ≈ 72 KB of extra trajectory cost.

**Safety caveat (tested):** `head -2 | jq '.'` on files with large records (e.g., session JSONL with base64 images at 1.1 MB/line) can dump megabytes. **Always check record size first:** `head -1 file | wc -c`. If > 5 KB, use `head -5 | jq -c '{type, keys: keys}'` (396 chars) instead of full pretty-print.

### 5. Tool discovery for tools I already know about

**The sin:** Running `which` loops on dozens of tools when my own guidelines already tell me `rg`, `find`, `ls` are available.

**The fix:** Only check tools I don't already know about from my system prompt / AGENTS.md.

### 6. Verbose bash output without output caps

**The sin:** Several exploratory commands without output caps. `brew list` (2.7KB), `find /Users/js/.pi ...` (3.6KB) — not catastrophic individually, but the habit matters.

**The fix:** Cap exploratory commands — but **choose head vs tail based on where the signal is.**
- Discovery/sampling (`ls`, `find`, `brew list`): `| head -20`
- Error checking (`make`, `pytest`, `pip install`): `| tail -20` — errors are at the end, head hides them
- Both: `cmd 2>&1 | { head -5; echo '...'; tail -10; }` when you need structure + error

---

## Rules to Internalize (Stress-Tested)

_Every rule below was tested against edge cases. Caveats are noted where the original recommendation was too absolute._

### Search Discipline

**Choose by query type, not by default:**

| Query type | Best tool | Why |
|---|---|---|
| Known URL | `content.js` | Skip search entirely |
| Specific answer (1-2 facts) | `search.js` → `content.js` on best hit | Targeted, 56% savings vs max-token llm-context |
| Survey / breadth | `llm-context.js --tokens 4096` | Aggregates 16+ sources into ~21 KB — best signal density per byte |
| Deep on one source | `content.js` | But beware: arxiv HTML = 65K chars, Wikipedia = 65K chars. No built-in cap. |
| Almost never | `llm-context.js --tokens 16384` | 77K chars; rarely justified |

~~**`search.js` → `content.js`** is almost always better than **`llm-context.js`**~~ — **Wrong.** For breadth/survey queries, `llm-context.js --tokens 4096` gives 16 sources in 21K chars. The `search.js → content.js` pipeline excels at depth on 1-2 sources but costs *more* for breadth (content.js on 3 URLs = 99K chars vs llm-context 4096 = 38K chars).

~~Never run more than 2 web searches before reviewing results and narrowing~~ — **Too aggressive for research.** Tested: 2 focused searches found 6 unique URLs; 5 searches found 15 (including 2 critical papers missed by the 2-search approach). 57% token savings but real coverage gaps. **Better rule:** For fact-checking, 2 searches max. For genuine research, search broadly but review before fetching content.

### File Reading Discipline

- Before `read`, ask: can `rg` answer this? (`rg -l`, `rg -c`, `rg -n "pattern"`)
- **Files < 5 KB:** just read the whole file. 1 call beats `rg -n` + targeted `read` (2 calls). _Median research file in this project: 10 KB. 75th percentile: 15 KB. Most files are large enough that targeted reading matters._
- **For structural tasks** (e.g., "find last list item"): `rg -n "^## "` for section boundaries + `sed -n 'X,Yp'` beats reading the whole file. But `rg` requires a searchable pattern — for pure exploration, read with offset/limit.
- ~~Never `ls` a directory with 100+ items~~ → **Threshold matters.** For small dirs (< 20 files), `ls` is fine and actually cheaper than `rg -l` (which requires a pattern and adds path prefixes). For 20-100 files, `ls | head -20`. For 100+, `rg -l` or `fd` with a pattern. Tested: `rg -l` on a 4-file dir produced MORE output (92 chars) than `ls` (64 chars).

### Data Exploration Discipline

- ~~Read one full record before writing `jq` queries~~ → **Check record size first.** `head -1 file | wc -c` costs almost nothing. If records are < 5 KB, `head -2 | jq '.'` is safe. If records contain base64 images (1.1 MB/line in this project's session files), a blind `jq '.'` dumps megabytes.
- **Safer approach:** `head -5 file | jq -c '{type, keys: keys}'` → 396 chars. Inspect the schema skeleton, THEN pretty-print only small records.

### Output Discipline

- ~~`| head -20` on anything exploratory~~ → **Depends on where the signal is.**
  - Errors from builds, `pytest`, `pip install` are at the **end**. `| head -20` hides them.
  - `| tail -20` for error-checking. `| head -5; echo '...'` + `| tail -10` for structure + errors.
  - `| head -20` is correct for discovery commands (`ls`, `find`, `brew list`) where you want a sample.
- `2>/dev/null` on anything that might produce irrelevant stderr — still valid.
- Prefer `--quiet`, `-l`, `-c` flags that produce minimal output — still valid.
- `git diff --stat` before full `git diff` — **overhead is ~1%** (225 chars). Always worth it when the full diff might be 30K+ chars. If you proceed to full diff anyway, you lost only 225 chars.

### Meta Discipline
- After writing about best practices, **check your own session** for violations
- The biggest context waste isn't a single bad call — it's the **habit of defaulting to maximum output**
- **Rules with "never" and "always" are wrong.** Conditional rules survive edge cases. Absolute rules don't.

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

### Anti-Pattern Validation (Tested)

Every anti-pattern and proposed rule was tested with actual commands against this project's data. Then each was stress-tested against edge cases to find where the recommendation breaks.

#### Basic Validation

| # | Anti-Pattern → Fix | Bad | Good | Savings |
|---|---|---|---|---|
| 1 | `llm-context --tokens 16384` → `search.js + content.js` | 77,787 ch | 34,033 ch | 56% |
| 1 | `llm-context --tokens 16384` → `llm-context --tokens 4096` | 77,787 ch | 21,021 ch | 73% |
| 2 | `ls research/` → `rg -l "pattern" research/` | 8,901 ch | 39 ch | 99.6% |
| 3 | 3 `read` calls with offsets → `rg -n` + `read` 5 lines | 17,493 ch | 1,823 ch | 90% |
| 4 | 6 `jq` probes → `head -2 \| jq '.'` | 806 ch (6 calls) | 2,380 ch (1 call) | -195% raw, saves ~72K trajectory tokens |
| 5 | `which` loops (15 tools) → check 3 unknown only | 583 ch | 84 ch | 86% |
| 6 | `brew list` without `\| head -20` | 448 ch | 157 ch | 65% |
| R | `grep -r` → `rg -l` | 2,130 ch | 101 ch | 95% |
| R | `grep -r` → `rg` (in dir with node_modules) | **1,208,782 ch** | 1,240 ch | **99.9%** |
| R | `git log` → `git log --oneline` | 1,927 ch | 361 ch | 81% |
| R | `git diff` → `git diff --stat` | 30,556 ch | 342 ch | 99% |

#### Edge Cases That Break the Rules

| Rule | Edge case | What happens | Correction |
|---|---|---|---|
| `search.js→content.js` always better | **Breadth query** (need multiple sources) | `content.js` on 3 URLs = 99K chars. `llm-context --tokens 8192` = 38K chars covering 16 sources. Pipeline is **2.6x worse.** | Use `llm-context --tokens 4096` for breadth. Pipeline for depth. |
| `search.js→content.js` always better | **Long page** (arxiv HTML, Wikipedia) | `content.js` returns 65K chars — no built-in truncation. Can exceed `llm-context --tokens 16384`. | content.js has no output cap. Dangerous on docs/reference pages. |
| Never > 2 searches | **Research task** | 2 searches found 6 URLs. 5 searches found 15, including AgentDiet paper and JetBrains blog **missed by 2-search approach.** | 2-search limit for fact-checking. Research needs broader sweeps. |
| `rg -l` over `ls` | **Small directory** (4 files) | `rg -l` = 92 chars. `ls` = 64 chars. rg is **44% worse** and needs a pattern you may not have. | ls is fine for < 20 files. |
| `rg -l` over `ls` | **Exploration** (no pattern) | `rg -l` requires a search pattern. If exploring, you don't have one. | `ls \| head -20` for exploration. `rg -l` for known-target search. |
| `head -2 \| jq '.'` for schema | **Large records** (base64 images) | Records can be 1.1 MB each. `head -2 \| jq '.'` dumps megabytes. | `head -1 \| wc -c` first. If > 5KB, use `jq -c '{type, keys: keys}'` instead. |
| `\| head -20` on everything | **Build/test output** | Errors from pytest, make, pip are at the **end**. `head -20` hides them entirely. | `\| tail -20` for error checking. `head` for discovery/sampling only. |
| `git diff --stat` first | **Small change** (1 file, 5 lines) | `--stat` adds 225 chars overhead. Full diff is only 7.5K. Overhead = 3%. | 3% overhead is always worth it — stat tells you whether to proceed. The rule holds even in the worst case. |

#### Trajectory Turn Cost (Measured)

Anti-pattern #4 requires quantifying trajectory snowball to justify "fewer turns > less output":

| Metric | Value | Source |
|---|---|---|
| Avg non-thinking assistant content per turn | 1,206 chars | 50 sessions, 1,186 turns |
| Breakdown: visible text | 444 KB (31%) | |
| Breakdown: tool call args | 987 KB (69%) | |
| Thinking tokens per turn | 269 chars | NOT in trajectory (provider-dependent) |
| Snowball cost per extra turn | ~12 KB | 1,206 chars × ~10 remaining turns |
| 6-probe vs 1-probe: extra 5 turns | ~60 KB trajectory waste | 5 × 12 KB |

**Conclusion:** For schema exploration (#4), the turn reduction argument is valid — 5 extra turns cost ~60 KB in trajectory snowball, far exceeding the 1.5 KB extra from a full pretty-print. But this only applies to tool calls that trigger multiple round trips. For single-call optimizations (#1-3, #5-6), raw output reduction is the dominant factor.

### Self-Assessment

The original self-review was **honest in direction, sloppy in specifics.** The anti-patterns identified are real and the prescriptions are sound. But the quantitative analysis committed the very sin it was criticizing: it prioritized narrative impact over precision. The image session error (44 → 37 images, 33 MB → 65 MB) actually supports the document's thesis *more strongly* than the original claim — reading the same images twice across sessions is textbook redundant context waste. The author understated the problem while trying to describe it.

The companion research document has stronger factual grounding but the citation error on arxiv:2508.11126 undermines the token efficiency comparison table — the paper that table claims to be based on is a completely different paper.

---

## Second-Round Edge Case Review (2026-03-04)

Independent re-review found **7 broken rules, 2 missing tools, and 3 wrong assumptions** that the original stress test missed. The stress test caught surface-level edge cases but didn't think broadly enough about the actual tool-use workflow.

### BROKEN: `head -1 | wc -c` Safety Check for JSONL

The rule says: "check record size first with `head -1 file | wc -c`."

**Tested:** ALL 273 session files have first record = exactly 147 bytes (session metadata header). Actual data records start at line 2+ and range up to 104K+ chars — a **700:1 ratio** between first and largest record. In 20/20 recent sessions tested, `head -1 | wc -c` returns 147, which passes the 5KB safety threshold, but later records routinely exceed 50KB.

**The rule would greenlight `jq '.'` on every session file and get burned on every one.**

| File | head -1 | Max record | Ratio |
|---|---|---|---|
| All 273 files | 147 bytes | varies | - |
| Session with images | 147 | 104,738 | 713x |
| Typical session | 147 | 17,714 | 120x |

**Fix:** `head -1 | wc -c` only works when records are homogeneous. For JSONL with a header line (which is the norm in pi, and common in ML/analytics formats), use `awk 'NR>1{print length; exit}'` or check multiple lines: `head -5 | awk '{print length}'`. The 5KB threshold should apply to the MAX of the first few records, not just line 1.

### MISSING: `rg -A/-B` Context Lines (Single-Call Alternative)

Neither document mentions `rg -A N` or `rg -B N` anywhere. This is a major gap — it's often the **single best tool for the job**.

**Tested against the doc's own anti-pattern #3 (3 read calls with offsets):**

| Approach | Chars | Calls |
|---|---|---|
| 3 `read` calls with offsets | 17,493 | 3 |
| `rg -n` + `read` 10 lines | ~1,050 | 2 |
| `rg -A 20 "^## section"` | **954** | **1** |
| Read whole 19KB file | 19,310 | 1 |

`rg -A 20` gets the same information in 1 call and fewer chars than any multi-call approach. Break-even with full-file-read is ~2.1 KB — meaning for any file > 2KB, `rg -A N` is better when you know what section you want.

Also useful: `rg -B 2 -A 5 "pattern"` for getting context around matches — 2,308 chars for "snowball" in a 19KB file, vs 19,310 for the whole file. For clustered matches, `rg` auto-deduplicates overlapping context regions.

**This should be the PRIMARY recommendation for "find a section in a known file," not `rg -n` + `read`.**

### BROKEN: `rg -l` When You Need `rg -n` Anyway

The rules recommend `rg -l` to find which file, then further search. But in practice, if you need to know *where* in the file, you always follow `rg -l` with `rg -n` — two calls when one suffices.

**Tested:**

| Approach | Chars | Calls |
|---|---|---|
| `rg -l "AgentDiet" research/` | 80 | 1 (but need another call) |
| `rg -n "AgentDiet" research/` | 1,918 | 1 (done) |

`rg -l` is only correct when the question is literally "which files contain X?" and you don't need line numbers. For the common "find and read" workflow, `rg -n` (or `rg -A N`) is always the right first call.

**Exception:** `rg -l` is still better than `ls` for large directories where you're filtering (the original doc's point). But it's not a step in a multi-call pipeline.

### BROKEN: `ls` Default Sort for Agent Workflows

`ls` alphabetizes by default. For an agent, the most recent files are almost always more relevant.

**Tested:** `ls research/ | head -5` returns `absurd-durable-execution-landscape.md` through `agent-security-synthesis.md` (alphabetically early but months old). `ls -t research/ | head -5` returns today's files. Same character count (733 vs 597 — time sort is actually 18% shorter because recent filenames happen to be shorter).

**Fix:** The rule should say `ls -t | head -20` for discovery, not `ls | head -20`. Alphabetical sort is only useful when you know the filename prefix.

### WRONG: "~10 Remaining Turns" Snowball Estimate

The trajectory snowball formula uses "~10 remaining turns" as a constant. The actual session turn count distribution (273 sessions):

| Percentile | Turns |
|---|---|
| P25 | 20 |
| P50 (median) | 44 |
| P75 | 73 |
| P90 | 119 |

At turn 5 of a median session, you have ~39 remaining turns — the snowball cost is **4x higher** than claimed (230 KB, not 60 KB). At turn 40, only 4 remaining — **2.5x lower** (24 KB). The doc's fixed estimate of ~60 KB for 5 extra turns is wrong for **both** early and late sessions.

| Position | Remaining | 5-turn snowball cost |
|---|---|---|
| Turn 5 | ~39 | 230 KB |
| Turn 10 | ~34 | 200 KB |
| Turn 20 | ~24 | 141 KB |
| Turn 30 | ~14 | 82 KB |
| Turn 40 | ~4 | 24 KB |

**Implication:** Turn reduction matters MORE early in a session and LESS late. The fixed "~10 remaining" estimate understates early-session waste by 4x — which is when multi-probe exploration (#4) most commonly happens.

### BROKEN: `| tail -20` on stderr-Only Commands

The doc's advice: "`| tail -20` for error-checking."

**Tested:** A command that writes only to stderr (common with `pip install`, `curl -s`, progress bars):
- `command | tail -5` → captures nothing (pipe only catches stdout)
- `command 2>&1 | tail -5` → captures the errors

The doc mentions `2>&1` once in a combined recipe but doesn't flag that `| tail` is BROKEN for stderr-only output. Many common error-producing commands (pip, curl, cargo) write progress to stderr and errors to stderr. Piping stdout catches neither.

**Fix:** The error-checking rule should always be `2>&1 | tail -20`, never just `| tail -20`.

### WRONG: "< 5KB Just Read Whole File" Threshold

**Tested against actual project data:**

| Directory | Files < 5KB | Total files | % under threshold |
|---|---|---|---|
| research/ | 6 | 281 | **2.1%** |
| topics/ | 3 | 4 | 75% |
| root .md files | 2 | 10 | 20% |

The rule fires on 2% of research files. The median research file is 10.6 KB. For this project, a 5KB threshold means "always use targeted reading" on almost everything. 

The break-even calculation (with `rg -A N` as the alternative) shows full-file-read loses at ~2.1 KB. So the 5KB threshold is actually too *generous* — `rg -A N` beats full read starting at 2KB, not 5KB. But if `rg -A N` isn't in the toolkit (and it isn't in the current rules), the break-even for rg-n-then-read is ~2.2 KB (2 calls).

**The real rule:** If you have a search pattern, use `rg -A N` regardless of file size. If you're exploring without a pattern, just read the file. The size threshold is a red herring — what matters is whether you have a search target.

### MISSING: `rg -F` for Literal Searches

`rg` uses regex by default. Searching for code patterns with `|`, `(`, `.`, `*`, `[` will produce wrong results silently.

**Tested:** `rg -c '|' file` matches ALL 53 lines containing pipe characters (regex OR). `rg -Fc '|---|' file` correctly finds 4 table separators.

The rules recommend rg throughout but never mention `-F` for literal strings. An agent searching for `console.log(` or `import { x }` will get garbage regex matches unless it knows to use `-F` or escape.

### Additional Finding: Per-Turn Overhead in Current Session

This session's own tool calls (43 calls, 42 results) show:
- Average tool call framing: 600 chars
- Average tool result: 2,766 chars
- Total tool result content: 113 KB in 42 calls

This session spent 43 tool calls collecting evidence for a review document. Whether that's efficient depends on the alternative — but it's a live demonstration of the "many small probes" pattern that anti-pattern #4 warns about. The difference: these probes are independent (parallel-safe), not sequential trial-and-error.

### Summary: What the Stress Test Got Right and Wrong

**Got right:**
- Breadth vs depth search tool selection (llm-context vs search+content)
- `| head` hiding errors
- Large JSONL records breaking `jq '.'`
- `rg -l` worse than `ls` for small dirs
- `git diff --stat` always worth it

**Missed:**
1. `head -1 | wc -c` broken on files with header lines (all JSONL in this project)
2. `rg -A/-B` context lines — the best single-call alternative for section extraction
3. `rg -l` is a dead end when you need `rg -n` anyway
4. `ls` vs `ls -t` for agent-relevant sort order
5. Snowball cost is position-dependent (4x underestimate early, 2.5x overestimate late)
6. `| tail` doesn't capture stderr without `2>&1`
7. File size threshold is the wrong axis — search-target-available is the right one
8. `rg -F` for literal strings never mentioned
9. Multiple small reads: batch with `cat` saves turns (~15% at 3 files)

**Meta-pattern:** The stress test found edge cases where absolute rules break, then replaced them with conditional rules. But the conditional rules themselves have edge cases (header lines, stderr routing, regex vs literal). The lesson isn't "make rules more conditional" — it's that **tool selection is a decision tree, not a rule set.** The rules keep getting longer because each exception spawns a sub-rule. A decision tree (if/then) is more compact and executable than a list of caveated rules.

---

## Related

- [Expert CLI Tricks for Context Saving](expert-cli-tricks-for-context-saving.md) — cross-reference of expert human knowledge against these rules. Identifies 9 missing techniques and proposes operation-oriented rule structure.

## Sources
- Self-analysis of 273 pi sessions in `/Users/js/.pi/agent/sessions/`
- [CLI Tools & Context Efficiency for Coding Agents](cli-tools-context-efficiency.md)
- Verification: independent re-parse of all session JSONL files, Brave Search for source verification
- Second-round edge case testing: 2026-03-04, 22 independent tests against project data
