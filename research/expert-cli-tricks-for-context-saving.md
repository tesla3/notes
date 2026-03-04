← [Agent Tool Use Self-Review](agent-tool-use-self-review.md) · [CLI Tools & Context Efficiency](cli-tools-context-efficiency.md) · [Index](../README.md)

# Expert CLI Tricks for Context Saving: What Decades of Experience Teaches

Cross-referencing human expert tips/tricks with the agent tool-use rules to find what the rules miss. Focus: edge cases that trip up even experienced people, techniques that minimize output, and patterns that only emerge from years of daily use.

**Date:** 2026-03-04
**Sources:** "The Art of Command Line" (jlevy, 153K stars), wooledge BashPitfalls (the definitive gotcha reference), learnbyexample grep/ripgrep, HN threads (41031837, 20493467), MIT Missing Semester, Eric Pement's awk/sed one-liners, practitioner discussion

---

## The Expert's Mental Model vs. The Agent's Rules

The current rules are structured as conditional recommendations: "if X, do Y." But human experts don't think in rules — they think in **composable primitives** that they combine on the fly. The gap between the two approaches reveals techniques the rules systematically miss.

### What Experts Know That the Rules Don't Capture

**1. Process substitution `<()` eliminates temp files AND extra calls**

From "The Art of Command Line":
> `diff /etc/hosts <(ssh somehost cat /etc/hosts)`

This is directly relevant to agents. Instead of:
- Call 1: `rg -l "pattern" dir1/` → get file list A
- Call 2: `rg -l "pattern" dir2/` → get file list B  
- Call 3: manually compare A and B

An expert does it in one call:
```
diff <(rg -l "pattern" dir1/ | sort) <(rg -l "pattern" dir2/ | sort)
```

**Tested:** `comm -23 <(ls research/ | sort) <(rg -o 'research/[a-z-]+\.md' README.md | sed 's|research/||' | sort)` → finds all research files NOT linked from README in a single command (6,781 chars). The multi-call alternative would take 3 calls: ls, rg, then manual diff.

**Edge case:** Process substitution creates non-seekable named pipes (`/dev/fd/63`). Commands that need seekable files (some `sort` modes, `diff` on very large files) can fail silently. `file <(echo test)` → `fifo (named pipe)`.

**2. `sed -n 'X,Yp'` for exact line ranges — the original `read` with offset**

The rules recommend `read` with offset/limit for extracting file sections. But `sed -n '83,93p' file` does the same thing in bash without needing the pi `read` tool's API:

**Tested:** `sed -n '83,93p'` and `rg -A 10 "^## Rules"` produce identical output (327 chars) for the same section. `sed` is better when you know the line number (from a prior `rg -n`), `rg -A` is better when you know the pattern.

**Key insight:** `sed -n '52q;45,50p'` (quit early) is dramatically faster on large files because it stops reading after line 52. Experts cite this explicitly as a performance trick for huge files.

**3. `awk` for field extraction — cheaper than `grep | cut | sed` pipelines**

The rules mention `jq` for JSON but never `awk` for structured text (TSV, space-delimited, etc.). Experts use `awk` as a single-call replacement for multi-tool pipelines:

| Multi-tool pipeline | Single awk equivalent |
|---|---|
| `wc -c files \| cut -d' ' -f1` | `wc -c files \| awk '{print $1}'` |
| `grep pattern file \| cut -d: -f2` | `awk -F: '/pattern/{print $2}' file` |
| `sort file \| uniq -c \| sort -rn` | `awk '{a[$0]++} END{for(k in a) print a[k],k}' file` |

`awk` is relevant for agents because it can filter AND extract in one pass. `rg` finds lines; `awk` finds fields within lines. Together they're a single-call replacement for multi-step extraction.

**4. `--` to terminate options — a silent failure mode the rules never mention**

From wooledge BashPitfalls (#3) and "The Art of Command Line":

If a filename or search pattern starts with `-`, commands interpret it as an option flag. This fails silently:
```
rg "-v" file      # rg: ripgrep requires at least one pattern (it read -v as invert flag)
rg -- "-v" file   # correct
grep -- "-2" file # correct
```

**Tested:** `rg "-v"` produces an error, `rg -- "-v"` works. This matters for agents searching codebases where patterns frequently contain hyphens (CSS classes, CLI flags in docs, negative numbers).

**5. `LC_ALL=C` for performance on large data**

From learnbyexample gotchas chapter:
> Changing locale to ASCII can give a significant speed boost.

**Tested on 273 session files:** `rg -c "toolResult"` → 0.181s. `LC_ALL=C rg -c "toolResult"` → 0.115s. **36% faster.** On the 908MB Linux kernel source, the learnbyexample author measured 4.5x speedup for regex operations.

For agents scanning large codebases, this is free performance. The edge case: `LC_ALL=C` breaks character class ranges `[a-z]` for non-ASCII input. Only safe when you know the data is ASCII (code, JSON, logs).

**6. `jq -e` for boolean checks without output**

From Mastering jq (CodeFaster):
```bash
echo '{"status":"error"}' | jq -e '.status == "ok"' > /dev/null 2>&1
echo $?  # 1 (false)
```

**Tested:** `jq -e` changes exit code based on truthiness of the output. This means an agent can CHECK a condition in JSON without dumping any output into context. Zero bytes in trajectory vs. the current approach of extracting a field and comparing in the assistant message.

Perfect for: "does this config have feature X enabled?" — the answer is just the exit code.

**7. `stat` for file metadata without reading content**

```bash
stat --printf='%s bytes, modified %y\n' file  # 58 chars
```

vs. `wc -c file` (only size, 45 chars) or `ls -l file` (everything, ~100 chars). `stat` gives exactly the metadata you specify in the format you want. Especially useful for "should I read this file?" decisions — get size and modification time in one call, 58 chars.

**8. `comm` for set operations — finding what's missing/different**

From "The Art of Command Line":
```bash
sort a b | uniq > c     # union
sort a b | uniq -d > c   # intersection  
sort a b b | uniq -u > c # difference a - b
```

**Tested:** `comm -23 <(ls research/ | sort) <(rg -o ... README.md | sort)` found all unlinked research files in a single command. This is a pattern agents need constantly: "which files changed?", "which tests are missing?", "which entries aren't in the index?"

The current rules have no set-operation patterns at all.

**9. `xargs -0` with `find -print0` for safe batching**

From wooledge BashPitfalls (#1 — the most common bash mistake):
> You can't simply treat the output of `ls` or `find` as a list of filenames and iterate over it.

Filenames can contain spaces, newlines, glob characters. The safe pattern:
```bash
find . -name "*.md" -print0 | xargs -0 wc -l  # safe for ANY filename
find . -name "*.md" -exec wc -l {} +           # also safe, POSIX
```

This matters for agents because: `for f in $(find ...)` (wrong) can silently skip files with spaces, and an agent working in an unfamiliar codebase can't assume filenames are well-behaved. The `-print0`/`-0` or `-exec {} +` patterns are the expert solution.

**`find -exec {} +` also auto-batches**, running as few commands as possible while staying under `ARG_MAX` (1,048,576 bytes on this system). One call instead of N.

**10. Quoting — the #1 source of silent bugs**

The entire first 10 entries of wooledge BashPitfalls are quoting mistakes. The core rule experts internalize:

> **Always double-quote variable expansions and command substitutions.** The only exceptions are inside `[[ ]]` (where it's safe but not harmful), and assignments.

For agents, the dangerous pattern is:
```bash
file=$(rg -l "pattern" .)  # This breaks if the filename has spaces
# Correct:
file="$(rg -l 'pattern' .)"
```

Also: always use single quotes for `rg`/`grep` patterns unless you need variable expansion. `rg '$HOME'` searches for literal `$HOME`. `rg "$HOME"` expands to `/Users/js`.

---

## Techniques That Directly Apply to Agent Context Saving

Ranked by impact — how many context bytes each technique saves in typical agent workflows:

### Tier 1: High Impact (>50% savings on common operations)

| Technique | What it replaces | Savings | Edge case |
|---|---|---|---|
| `rg -A N "pattern" file` | `rg -n` then `read` with offset (2 calls) | 1 call vs 2; output bounded by N | Multiple matches produce merged/separated output blocks |
| `comm -23 <(A) <(B)` | Two separate lists + manual comparison (3 calls) | 1 call; output is only the differences | Inputs must be sorted; process substitution not seekable |
| `jq -e '.condition' > /dev/null` | Extract field + compare in assistant msg | 0 bytes output vs N bytes | Requires `2>&1` redirect; exit code lost if piped |
| `awk '/pat/{print $N}' file` | `grep pat file \| cut -dX -fN` (2 cmds or 1 pipe) | 1 pass vs 2; extracts exactly what's needed | Field numbering starts at $1; $0 is whole line |
| `stat --printf='%s'` | `wc -c` (which also outputs filename) | Exactly the number, no parsing needed | GNU stat vs BSD stat syntax differs (GNU on this system) |

### Tier 2: Medium Impact (correctness + modest savings)

| Technique | What it replaces | Savings | Edge case |
|---|---|---|---|
| `--` before patterns with `-` | Nothing (silent failure) | Prevents wrong results | Not all commands support it (echo doesn't) |
| `rg -F 'literal'` | `rg 'escaped\.pattern'` | Correctness; no escaping needed | `-F` disables all regex features |
| `LC_ALL=C` before grep/rg | Default locale | 36%+ speed on large data | Breaks `[a-z]` for non-ASCII |
| `find -print0 \| xargs -0` | `for f in $(find ...)` | Correctness for filenames with spaces | Requires both sides to agree on NUL delimiter |
| Double-quoting `"$var"` | Unquoted `$var` | Correctness | Inside `[[ ]]` it's optional |

### Tier 3: Situational (powerful when applicable)

| Technique | Use case | Agent context |
|---|---|---|
| `<(command)` process substitution | Comparing two command outputs | Eliminates temp files; 1 call for diffs |
| `sed -n '52q;45,50p'` | Extract lines from huge file | Quit-early optimization for large files |
| `sort \| uniq -c \| sort -rn` | Frequency analysis | Tallying patterns, error types, etc. |
| `column -t` | Align tabular output | Makes output readable without more chars |
| `tee file \| cmd` | Save output while processing | Debugging without extra calls |

---

## Edge Cases Experts Have Internalized

These are failure modes that experienced practitioners have hit enough times to encode as reflexes:

### 1. The Pipe Subshell Trap
```bash
count=0
cat file | while read line; do ((count++)); done
echo $count  # Always 0! The while loop runs in a subshell.
```
Fix: `while read line; do ((count++)); done < file` or use `< <(command)`.

An agent writing bash one-liners to count things in files will hit this. Variables set in a piped `while` loop don't persist.

### 2. Redirect Order Matters
```bash
cmd 2>&1 > file   # stderr goes to terminal, stdout to file (WRONG for most intents)
cmd > file 2>&1   # both stdout and stderr go to file (RIGHT)
cmd &> file       # bash shorthand for the above
```
The redirect order matters because redirections are processed left-to-right. `2>&1` duplicates fd1's CURRENT target, not its future target.

### 3. The `set -e` Surprise
```bash
set -e
count=$(grep -c "pattern" file)  # If pattern not found, grep exits 1, script DIES
```
`set -e` (exit on error) kills the script when `grep -c` finds zero matches (exit code 1). Experts know: `grep -c` returning 0 matches is not an error, but `set -e` can't tell the difference. Fix: `count=$(grep -c "pattern" file || true)`.

### 4. Word Splitting After Command Substitution
```bash
files=$(find . -name "*.md")     # WRONG: if filenames have spaces
files=( $(find . -name "*.md") ) # STILL WRONG: glob expansion too
```
The wooledge wiki's #1 pitfall: never iterate over `$(find ...)`. Use `find -exec` or `while read -r -d ''` with `-print0`.

### 5. Glob Expansion of `*` in Unexpected Places
```bash
rg '*' file          # WRONG: shell expands * to filenames before rg sees it
rg '*' file          # In some contexts, may work if no files match (but fragile)
rg '\*' file         # Escaped: searches for literal *
rg -F '*' file       # Best: fixed string mode
```

---

## What This Means for the Tool-Use Rules

### Missing from the current rules entirely:
1. **`rg -A/-B/-C`** — still the biggest gap (confirmed by second-round review)
2. **Process substitution `<()`** — eliminates multi-call comparison workflows
3. **`awk` for field extraction** — single-pass alternative to grep+cut pipelines
4. **`comm` / set operations** — finding differences between two lists
5. **`jq -e` for boolean checks** — zero-output condition testing
6. **`--`** before patterns — preventing silent failures with hyphen-prefixed patterns
7. **`-F`** for literal strings — preventing regex misinterpretation (confirmed by second-round review)
8. **`stat` for metadata** — lighter than `ls -l` or `wc -c` when you need specific fields
9. **Quoting discipline** — `"$var"` always, `'pattern'` for search, affects correctness not just style

### Rules that experts would rewrite:

| Current rule | Expert version |
|---|---|
| "Before `read`, ask: can `rg` answer this?" | "Before any call, ask: can one composed pipeline answer this?" |
| "`rg -l` for finding files" | "`rg -n` or `rg -A N` — skip the intermediate step" |
| "`\| head -20` on exploratory commands" | "`\| head -20` for discovery, `2>&1 \| tail -20` for errors, `awk 'NR==1 \|\| /ERROR/'` for structure+errors" |
| "Check record size with `head -1 \| wc -c`" | "`awk '{print NR, length}' file \| head -5` — shows size distribution, not just first line" |
| "Use `jq` for JSON" | "`jq -e` for boolean checks (0 bytes), `jq -r '.field'` for raw output, `jq -c` for compact" |

### The meta-lesson:

The current rules are **tool-specific**: "when to use rg", "when to use jq", "when to use head/tail." Expert knowledge is **operation-specific**: "when extracting a section", "when comparing two sets", "when checking a condition." The operation-specific framing naturally leads to the right tool combination, while the tool-specific framing misses compositions.

A better structure for the rules would be:

```
OPERATION: Extract a section from a known file
  → Know line numbers? sed -n 'X,Yp'
  → Know a pattern? rg -A N "pattern" file
  → Exploring? read with offset/limit

OPERATION: Compare two sets
  → comm -23 <(A | sort) <(B | sort)  
  → diff <(A) <(B) for full diff

OPERATION: Check a condition in structured data
  → JSON: jq -e '.condition' > /dev/null; echo $?
  → Text: rg -q "pattern" file; echo $?
  → Either: 0 bytes in context
```

---

## Key Sources

- jlevy, "The Art of Command Line," github.com (153K stars), comprehensive expert reference
- wooledge BashPitfalls, mywiki.wooledge.org, the definitive bash gotcha compilation (65+ entries)
- learnbyexample, "CLI text processing with GNU grep and ripgrep," gotchas chapter
- HN thread 41031837 (Bash-Oneliners, 2024): command commenting, history as workflow documentation, readline/inputrc
- HN thread 20493467 (Terminal tricks you wish you knew sooner, 2019): process substitution, ssh escape sequences, fc command
- MIT Missing Semester, "Data Wrangling" lecture, missing.csail.mit.edu
- Eric Pement, "Handy One-Line Scripts for AWK" (v0.28, 2019), pement.org
- CodeFaster, "Mastering jq: Bash tricks," codefaster.substack.com
- GNU coreutils documentation (stat, sort, comm, etc.)
- Verified by testing against 273 pi sessions and project data
