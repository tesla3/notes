# Work Log

## 2026-03-24 — resolve-alias.sh and browser automation exploration

### Completed
- Built `resolve-alias.sh` — multi-strategy name→alias resolver
  - Strategy A: pattern guessing (firstlast, lastfirst, etc.) against PhoneTool `.json` API
  - Strategy B: WIKI search → extract @alias, phonetool URLs from snippets → validate
  - Strategy C: ISK PHONETOOL fallback (currently broken, HTTP 400)
  - Test results: 11/11 pass (6/7 of Yina Gu's team, 3/3 from own team, 2 edge cases)
- Updated AGENTS.md alias resolution to use resolve-alias.sh
- Updated internal_lessons_learned.md with ISK PHONETOOL breakage documentation
- Updated internal-search SKILL.md with PHONETOOL broken warning + resolve-alias docs
- Installed `agent-browser` (vercel-labs, npm global, v0.22.1)

### ISK PHONETOOL Diagnosis
- ISK API returns HTTP 400 "Invalid request body" for ALL PHONETOOL queries
- Other domains (WIKI, ALL, etc.) work fine with identical request structure
- ASBXGenAITools has the same bug (same code path, mocked tests)
- ISK still indexes phonetool data — domainFacets show matches — but the endpoint rejects requests
- The `filters: []` field (present in ASBXGenAITools, missing from our search.sh) is NOT the fix

### Browser Automation (agent-browser) — Blocked
- PhoneTool uses Midway SSO (OIDC + AEA desktop protocol handler)
- The SSO redirect page uses `aea://` protocol to invoke AEA desktop app
- Playwright/agent-browser Chrome doesn't have AEA registered → redirect dies on empty page
- Injecting midway JWT cookies via CDP works (3251-char JWT, needed websocket bypass for size limit) but doesn't help — the SSO redirect itself generates the phonetool session
- **To resume**: need user to authenticate in agent-browser's headed Chrome window, THEN browser search will work

### Remaining Work
- [ ] Get browser-based PhoneTool search working (requires manual auth in agent-browser)
- [ ] Once working: add Strategy B2 (browser search) to resolve-alias.sh for the 13 failures
- [ ] The 13 failing aliases from own team have non-standard patterns (middle name initials, prior names, etc.) — pattern guessing alone won't solve them
- [ ] Consider: is browser search worth the complexity? resolve-alias.sh + "ask user" covers 85%+ of cases

### Key Files
- `~/.pi/agent/skills/internal-search/resolve-alias.sh` — the script
- `~/.pi/agent/skills/internal-search/test_resolve_alias.sh` — test suite (11 cases)
- `~/.pi/agent/skills/internal-search/SKILL.md` — updated docs
- `~/.pi/agent/AGENTS.md` — updated alias resolution procedure
- `internal_tooling/internal_lessons_learned.md` — ISK PHONETOOL breakage documented
