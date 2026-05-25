# jot — Critical Code Evaluation

Source: ~/gh_repo/jot/ (github.com/mariozechner/jot)
Date: 2026-04-02
Revised: 2026-04-02 (second-pass review against full source)

## What It Is

Minimal self-hosted collaborative markdown editor with inline comment threads. 5862 LOC total. Designed for humans and AI agents. Published as `@mariozechner/jot` on npm.

**Stack:** Express 5 + WebSocket (ws), vanilla JS frontend (no framework), `articulated` library for CRDT-style ID lists, `marked` + `highlight.js` + `sanitize-html` for rendering. TypeScript server, plain JS client.

## Architecture

```
server.ts (2182 LOC)  — Express routes + WebSocket server + auth + persistence + all business logic
collab.ts (350 LOC)   — Collaborative state: TrackedIdList wrapper, mutation application, serialization
app.js (1834 LOC)     — Entire SPA: list page, editor page, public page, comment UI, modals
collab-editor.js (469 LOC) — Textarea-based collaborative editor with remote cursors
collab-shared.js (351 LOC) — Browser-side mutable IdList + mutation application
components.js (59 LOC) — Two web components (jot-icon-button, jot-button)
login.js (68 LOC)      — Auth page form handling
theme.js (29 LOC)      — Dark/light theme toggle, persisted to localStorage
cli/jot.mjs (520 LOC)  — CLI client: register, owner commands, shared commands
```

Single-process, in-memory note store (`Map<string, NoteRecord>`), persisted as `.md` + `.json` per note. No database.

## Design Strengths

### 1. Agent-first collaboration model — genuinely novel
The killer feature isn't the editor itself — it's the collaboration surface between humans and AI agents. Each note has a share URL that doubles as a credential. Agents get copy-paste CLI instructions from a modal. Comments are anchored to text selections. This is a thoughtful human-agent interaction pattern.

### 2. Collaborative editing via semantic mutations
Uses Matt Weidner's "text without CRDTs" approach: stable character IDs, semantic client mutations (insert/delete), server as authority, client-side rebasing of pending mutations. This is the right architecture for a centralized collaborative editor — simpler than full CRDTs while getting convergence right.

### 3. Minimal dependency surface
Six runtime dependencies. No React, no bundler, no ORM. The Dockerfile is a clean multi-stage build. Docker compose integrates with Caddy for TLS. The whole thing deploys in one container.

### 4. Share access model is well-designed
Four tiers (none → view → comment → edit) on a stable URL. Share link is the credential for guests. Owner bypasses all access checks. The access hierarchy is consistently enforced across REST, WebSocket, and comment endpoints.

### 5. CLI is genuinely useful
Two modes: owner (API key, full access) and shared (link-based, scoped access). Supports read with offset/limit for large notes. Edit via `[{oldText, newText}]` JSON — same as most AI coding tools. Thread/comment CRUD. This is how an agent actually interacts with it.

### 6. Comment anchoring is well-engineered
Anchors store quote + prefix + suffix + offsets. `locateAnchor` tries exact-position match first, then falls back to full-text search, scores candidates by prefix/suffix match AND proximity to original position. Handles document drift gracefully — one of the better-engineered parts of the system.

### 7. Architecture document (`plan.md`) is exceptional
A 400-line architecture document that correctly diagnoses every problem with the pre-rewrite state, cites primary sources (Weidner's article, `articulated` library), specifies exact execution order, and lists concrete acceptance criteria. The shipped code faithfully implements this plan. This is better technical writing than most teams produce.

## Design Weaknesses

### 1. Tombstone accumulation — the core performance problem
Both client-side `SimpleIdList` and server-side `articulated IdList` accumulate tombstones permanently. Every deleted character stays in memory as a marked-deleted entry. A note that's been heavily edited will have `entries.length >> visible text length`.

The client's `at(index)` does a linear scan through ALL entries (including tombstones) to find the nth live one — O(total_ever_inserted), not O(document_length). Building mutations requires multiple `at()` calls. For a 10K-character document after an hour of heavy editing, these scans could traverse 50K+ entries. Degradation is quadratic in editing history. (Server-side `articulated` uses a tree internally, so `at()` is O(log n) there — the quadratic problem is client-only.)

Neither `articulated` nor `SimpleIdList` offers any compaction API. There is no way to reclaim tombstones short of rebuilding the collab state from the current markdown (which destroys all stable IDs and breaks connected editors — see Weakness #11).

Compounding this: the `chars` Map in `CollabState` stores a character for every ID ever inserted. Deleting characters removes them from the IdList but **not** from `chars`. The Map grows monotonically. `collabToMarkdown()` only reads live IDs, so dead chars accumulate silently — a parallel memory leak the IdList tombstones alone don't account for.

Both leaks also affect persistence: `saveCollabState()` serializes the full IdList (tombstones included) and all associated chars to JSON. Every keystroke writes this synchronously (see Weakness #7). A 10K-character document with 50K historical entries produces a multi-megabyte JSON file on every save. The tombstone and sync-I/O problems compound multiplicatively.

### 2. No test suite whatsoever
Zero tests. No test framework configured. No test scripts. The `plan.md` explicitly lists 8 acceptance criteria that should be automated tests. The author knows they should exist and chose not to write them. For a collaborative editor where convergence bugs are subtle and devastating, this isn't just a gap — it's a development practice problem.

### 3. Collaborative correctness is unverified
The collab architecture follows the right pattern (semantic mutations, server authority, client rebasing), but correctness has not been verified against conflict scenarios. Key questions unexamined: Does `applyClientMutations` handle concurrent inserts at the same position correctly? Does client-side rebasing preserve intention when two users edit the same region? The code *looks* correct but the hardest bugs in collaborative editing are the ones that only surface under specific interleaving.

### 4. God-file server (2182 LOC)
`server.ts` contains everything: Express routes, WebSocket handling, auth, persistence, markdown rendering, HTML template generation, cookie management, note CRUD, collaborative state management, and comment business logic. No separation into modules. Not a scalability problem — it's a comprehension and modification problem.

### 5. Massive code duplication: owner vs. share endpoints
The edit logic (`POST /api/notes/:id/edit` and `POST /api/share/:shareId/edit`) is **literally copy-pasted** — ~50 lines of identical mutation-building code. Same for comment/reply/thread endpoints. ~400 LOC of near-identical code total. A shared handler would halve this.

### 6. Auth reads from disk on every request
`loadAuthData()` does `fs.readFileSync` + `JSON.parse` on every authentication check. `verifyOwnerToken()` iterates all stored tokens, running scrypt for each. `verifyApiKey()` does the same. With N API keys and M tokens, every authenticated request does N+M scrypt operations and reads a file from disk.

### 7. Persistence is synchronous
All file writes (`fs.writeFileSync`) block the event loop. On every keystroke in collaborative mode, the server writes both `.md` and `.json` synchronously. Under load, this will cause latency spikes — though for the typical 1-3 user scenario this is likely imperceptible.

### 8. Composition/IME input gets degraded conflict resolution
The collab editor correctly skips `beforeinput` during composition and handles `compositionend` via diff fallback. But the diff fallback creates a single coarse delete+insert pair instead of granular per-character mutations. This means CJK input gets worse conflict behavior than Latin typing — the entire composed string is one atomic operation rather than individual character insertions.

### 9. No rate limiting or abuse protection
No rate limiting on any endpoint. No request size validation beyond Express's 2MB limit. The comment/thread endpoints accept unlimited creation from any authenticated user.

### 10. Monolithic client-side JavaScript
`app.js` is 1834 lines in a single IIFE. No modules, no component boundaries. State is a closure-scoped object. UI rendering is innerHTML string concatenation. DOM references are passed as a `refs` bag through every function. Fine for a prototype but becomes unmanageable as features grow.

### 11. `PUT /api/notes/:id` with markdown destroys collab state — silent data loss
When the `PUT` endpoint receives a markdown change, it rebuilds the entire collab state from scratch:
```ts
note.collab = collabFromMarkdown(nextMarkdown, note.collab.serverCounter + 1);
```
This creates a fresh IdList with new bunchIds. All connected collaborative editors receive a `hello` reset and replay their `pendingMutations` against the new state — but those mutations reference old IDs that no longer exist. `applyClientMutation` checks `isKnown(before)`, fails, returns state unchanged. **Pending edits from connected users are silently dropped.**

The CLI `update` command uses this endpoint. A CLI user running `jot my-jot update <id> --markdown "..."` while someone is editing in the browser causes silent data loss for the browser user. The `POST /api/notes/:id/edit` endpoint correctly works through the collab mutation system, but `PUT` bypasses it entirely. This is the most dangerous design flaw in the codebase.

### 12. `clientAcks` Map never cleaned up
Each `NoteRecord` has `clientAcks: Map<string, number>` tracking the last acknowledged mutation counter per client. `handleDisconnect()` removes the client from the `clients` array and broadcasts presence-leave, but never deletes the client's entry from `clientAcks`. Client IDs are sequential (`c1`, `c2`, ...), so this Map grows indefinitely across the server's lifetime. A note with heavy collaborative traffic accumulates thousands of stale entries.

### 13. Full markdown in every WebSocket mutation message
The `ServerMutationMessage` includes `markdown: note.markdown` — the entire document content. Every keystroke from any editor broadcasts the full document to all connected editors. This is architecturally forced: `IdListUpdate` carries `{before, id, count}` for inserts but not the character content, so clients can't reconstruct text incrementally. The client uses `msg.markdown` directly as the authoritative server text in `receiveMutation`. For a 100KB document with 5 editors, every keystroke generates ~500KB of WebSocket traffic. Fine for the target 1-3 user scenario; hard ceiling on scalability.

### 14. `contentLength + 10` tolerance allows over-deletion
Both server (`collab.ts:315`) and client (`collab-shared.js:300`) delete mutations have:
```ts
if (contentLength !== undefined && currentLength > contentLength + 10) { return; }
```
The `+ 10` tolerance means a delete intended for N characters will proceed even if the region has grown to N+10 characters due to concurrent inserts between the start and end IDs. Those concurrently-inserted characters get deleted. This is not a theoretical concern — it's the exact scenario that concurrent editing produces.

### 15. Thread anchors silently orphan when quoted text is deleted
When an edit removes the exact text a thread is anchored to, `locateAnchor` in app.js returns null and the thread's highlight + rail card are not rendered. The thread becomes completely invisible in the UI — no highlight, no rail card, no mobile dialog access. The data persists in `note.threads` (accessible via REST API or direct JSON), but the user has no way to see, manage, or delete orphaned threads from the editor. No notification surfaces that threads have been orphaned. Over time, heavily edited documents accumulate invisible ghost threads.

### 16. CLI agents on shared notes get ephemeral commenter identity
The CLI doesn't persist cookies. The `ensureCommentAuthor` path for non-owner requests calls `getOrCreateCommenterId(req, res)` which sets a `md_commenter_id` cookie — but the CLI ignores Set-Cookie headers. Each subsequent request generates a fresh `authorId`. Consequences: (a) comments from the same CLI agent appear as independent commenters, (b) `canManageMessage` checks `commenter.id === message.authorId` which always fails since the ID changes, so the agent can never edit or delete its own comments. Owner-mode CLI (API key auth) is unaffected since it uses `authorId: "__owner__"`.

## Code Quality

### Good
- Consistent coding style throughout
- Proper use of `crypto.timingSafeEqual` for secret comparison
- Sanitization of rendered HTML via `sanitize-html`
- Clean cookie handling with secure/httponly flags
- Comment body/title length limits
- Proper `escapeHtml` in both server templates and client rendering
- WebSocket heartbeat with configurable interval
- Collaborative mutation/ack protocol is well-designed: server broadcasts to all connections including sender, sender uses `senderId === clientId` to prune pending mutations — this is the correct ack mechanism

### Concerning
- No TypeScript on the client side — ~2600 LOC of plain JS with no type annotations or JSDoc
- `innerHTML` assignment throughout `app.js` — while inputs are escaped, this pattern invites XSS if any escaping is missed
- The `update` CLI command fetches current state then sends title + markdown together, creating a TOCTOU race — and needlessly includes markdown even for title-only updates (sending just `{ title }` would skip the markdown path in PUT)
- The `__api__` sender ID used for REST-initiated mutations is a magic string (collision with WebSocket client IDs is impossible since they use format `c${counter}`, but the magic string pattern is still fragile)
- `persistNote` redundantly calls `collabToMarkdown(note.collab)` on every save, even though the mutation handler already computed markdown via `applyClientMutations` and set `note.markdown = result.markdown`. This is O(live_entries + tombstones) of wasted work on every keystroke
- Title changes (via either PUT or the edit endpoint) trigger `broadcastEditorHello`, which sends the full collab state to all editors and forces a reset+replay cycle. A lightweight title-update message would suffice but doesn't exist in the protocol

### Client-side IdList: deliberate tradeoff, not duplication
`collab-shared.js` reimplements IdList as a mutable flat-array (`SimpleIdList`) while `articulated`'s `IdList` is immutable (returns new instances on insert/delete). The client editor needs efficient mutable replay of pending mutations during rebasing. Using the immutable `IdList` would allocate a new instance per mutation per rebase cycle. The reimplementation is a deliberate tradeoff for the hot path, not laziness — though `articulated` does ship a browser-compatible ESM build (`browser: 'build/esm/index.js'`) that could be used elsewhere.

## Security

**Adequate for a self-hosted single-user tool.** The auth model (single owner password + device tokens + API keys) is appropriate for the threat model. Share links as bearer credentials is the right tradeoff for shareability.

State-changing requests use either Bearer tokens (immune to CSRF) or session cookies with JSON content-type. Browsers won't send `Content-Type: application/json` cross-origin without CORS preflight, which the server doesn't enable. CSRF is not a practical attack vector.

**Gaps:**
- No HTTPS enforcement in code (relies on reverse proxy)
- Cookie `Secure` flag is conditional on `req.secure`, which requires `trust proxy` to work correctly behind a proxy — this is set, but fragile
- Commenter identity is a client-side cookie (`md_commenter_id`). Anyone can impersonate any commenter by setting the cookie value. Acceptable for the threat model but worth documenting
- API keys are never rotated or expired
- No session expiration for device tokens beyond the cookie max-age

## Docker deployment note

`docker-compose.base.yml` mounts `./data/notes` into `/app/data`, but `DATA_DIR` is set to `/app/data` and the server creates `notesDir = path.join(dataDir, "notes")` inside that. On the host, files end up at `docker/data/notes/notes/` — a double-nesting that suggests the Docker setup wasn't tested end-to-end.

## Gaps

1. **No tests** — most critical gap
2. **`PUT` endpoint destroys collab state** — silent data loss for connected editors (see Weakness #11)
3. **Undo/redo is unreliable** — `beforeinput` has no handler for `historyUndo`/`historyRedo`, so they fall through to browser default behavior. Browser undo then modifies the textarea, and `handleInput` → `applyDiffFallback` captures the diff as a coarse mutation. This partially works, but the browser's undo stack is corrupted by programmatic textarea updates during collab sync, making undo unpredictable
4. **No conflict indication** — when two users edit the same region, changes merge silently; the `contentLength + 10` tolerance can silently over-delete (see Weakness #14)
5. **No graceful shutdown** — `process.on('SIGTERM')` not handled; in-flight writes could be lost
6. **No access logging** — no audit trail for who viewed/edited what
7. **`findNoteByShareId` is O(n)** — every share-link request linearly scans all notes; `clients` array broadcasts also iterate all connections regardless of note
8. **WebSocket presence name is stale** — shared editors set `conn.name` from cookies at connection time; if the user changes their name via the identity endpoint, the WebSocket presence display retains the old name until reconnect
9. **Thread anchors orphan silently** — heavily edited documents accumulate invisible threads that can only be found via the REST API (see Weakness #15)
10. **CLI agents can't manage own shared comments** — ephemeral commenter identity means no edit/delete capability (see Weakness #16)

## Verdict

Jot is a well-conceived tool with a genuine insight — using collaborative markdown notes as a human-agent interaction surface. The architectural choices are sound: semantic mutations, centralized authority, client-side rebasing. The `plan.md` shows deep engagement with the problem space, and the shipped code faithfully implements it.

The most serious liability is that `PUT /api/notes/:id` silently destroys collab state and drops in-flight edits from connected users — a data loss bug that can bite even a 2-person deployment. Beyond that: zero test coverage for a system where correctness is hard to verify by inspection; tombstone + chars Map accumulation that degrades both memory and on-disk persistence over editing lifetime; full document content in every mutation WebSocket message (architecturally forced by the IdListUpdate format lacking character data); and a 2200-line god-file with ~400 lines of copy-pasted endpoint logic. These are all fixable without architectural changes, though the `PUT`/collab tension requires a design decision (remove `PUT` markdown writes, or route them through the mutation system), and the bandwidth issue requires extending the update protocol to carry character content.

The code is competent but under-disciplined. The author writes better architecture documents than tests — which is the wrong ratio for a collaborative editor.

**Would I use it?** For solo use with agents, yes. **Would I use it with even one other concurrent editor?** Not until the `PUT` data loss is fixed and the delete tolerance (`contentLength + 10`) is tightened. **Would I deploy it for a team of 50?** Not without tests, tombstone compaction, incremental mutation messages, and async I/O.
