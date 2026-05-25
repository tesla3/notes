# Lesson: Follow the Alias Resolution Procedure — Don't Improvise

**Date:** 2026-03-11
**Source:** Direct observation during person-activity lookup for "burak". Five tool calls instead of two because the agent improvised rather than following the documented procedure.

---

## The Incident

Asked the agent "what burak is working on last week?" The agent:

1. Tried `internal-search` as a raw command (failed, exit 127)
2. Read the internal-search SKILL.md to find the right script
3. Ran search with `--size 10`, got 500+ results with null aliases in the jq extraction
4. Inspected raw JSON to understand the structure
5. Re-queried with `--size 50` and filtered by **title regex** (`Scien|SDE|Software|ML...`)
6. Found `GUVENB` in the results, then ran activity

Five tool calls to resolve an alias. Should have been one.

## The Root Cause

The AGENTS.md alias resolution procedure is explicit and complete:

1. Search PHONETOOL
2. One match → use it
3. Multiple matches → narrow by **org proximity** (same team → same director → same VP → same dept)

The agent skipped step 3's org-proximity filtering and substituted a title-based heuristic — filtering for "scientist/SDE/software" roles. This is both **lossy** (misses non-eng roles) and **noisy** (matches hundreds of SDEs company-wide). The procedure says to filter on org structure, not job title.

## The Optimal Solution

Two calls total:

```bash
# 1. Search + filter by org proximity in one pipeline
search.sh "burak" --domain PHONETOOL --size 50 --json | \
  jq -r '.response.people[] | select(.departmentName | test("SPS|Mach Learning")) | "\(.uid) — \(.firstName) \(.lastName) — \(.title) — \(.departmentName)"'

# 2. Fetch activity
activity.sh guvenb --months 1
```

The department name "SPS Mach Learning Accelerator" is in the user's org chain. Filtering on `departmentName` is the direct translation of "narrow by org proximity."

## The Lesson

- **Procedures exist to be followed mechanically, not creatively interpreted.** The alias resolution procedure already encodes the right heuristic — org proximity beats title matching.
- **The documentation wasn't unclear — the execution was undisciplined.** Adding examples wouldn't help; following the steps would.
- **Compose one pipeline instead of multiple exploratory calls.** Know the JSON structure (or inspect it once), then filter in the same call.
- **Don't add worked examples to clear procedures.** If the steps are explicit and the failure is execution discipline, more documentation just adds noise.
