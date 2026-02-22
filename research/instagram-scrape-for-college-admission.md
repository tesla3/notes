← [Index](../README.md)

# Instagram Scrape Pattern: School College Decisions

Workflow for extracting early college decision data from student-run Instagram accounts.

## Finding the Account

School decision accounts follow a naming convention:

```
@{school}decisions{year}
```

**How to search (must be logged in):**

```bash
agent-browser --session-name instagram open https://www.instagram.com/
agent-browser --session-name instagram wait --load networkidle
agent-browser --session-name instagram snapshot -i   # find Search link ref
agent-browser --session-name instagram click @eN     # click Search
agent-browser --session-name instagram wait 1000
agent-browser --session-name instagram snapshot -i   # find search input ref
agent-browser --session-name instagram fill @eN "bishops decisions 2026"
agent-browser --session-name instagram wait 2000
agent-browser --session-name instagram snapshot -i   # results appear as links — click the profile
```

Known accounts (**the abbreviation varies by school** — not always obvious):
- `prs decisions 2026` → `@prsdecisions2026` (Pacific Ridge School)
- `tbs26decisions` → `@tbs26decisions` (The Bishop's School, La Jolla — note: "tbs26decisions" not "tbsdecisions2026", which is a **different school**)
- `torrey pines decisions 2026` → TBD

**Finding tip:** If the obvious name doesn't work, try the school's common abbreviation (TBS, TPHS, LCC, etc.) or search for `{school name} class of 2026` to find adjacent accounts (`@tbsclassof2026`) that may follow or be followed by the decisions account.

**Important:** Use Instagram's in-app search, not explore/tags (tags redirects to keyword search and gives noisy results).

## Prerequisites

- `agent-browser` installed globally (`npm install -g agent-browser && agent-browser install`)
- Logged-in Instagram session

### Login (first time or after session expires)

```bash
# Open headed browser — you enter credentials manually
agent-browser --session-name instagram close 2>/dev/null
agent-browser --headed --session-name instagram open https://www.instagram.com/accounts/login/

# Wait for user to log in (poll for URL change)
# After login, Instagram redirects to / or /accounts/onetap/
```

**Use `--session-name` (not `--session`).** The `--session-name` flag auto-persists cookies and localStorage to `~/.agent-browser/sessions/` across browser restarts. Plain `--session` is in-memory only — state is lost on close.

### Session expiry

Instagram sessions expire frequently (hours, not days). If you see a login form when opening instagram.com, re-auth with the headed flow above. **Do not bother with `state save` / `state load`** — in practice, `state load` fails if any daemon process is lingering, and killing the daemon cleanly is unreliable. `--session-name` auto-persistence is simpler.

## Extraction Workflow

### 1. Open profile and load all posts

```bash
agent-browser --session-name instagram open https://www.instagram.com/{account}/
agent-browser --session-name instagram wait --load networkidle

# Scroll to load all posts (adjust count based on post volume)
for i in $(seq 1 6); do
  agent-browser --session-name instagram scroll down 2000
  sleep 1
done
```

**Login wall mid-scroll:** Instagram may pop a signup/login dialog overlay even when logged in. If `snapshot -i` returns only `Close / Sign up / Log in` buttons, click `Close` to dismiss and continue. If it persists, the session may have expired — re-auth.

### 2. Extract post metadata via JS eval

Instagram's auto-generated alt text contains OCR of the image graphic (university, major, student name):

```bash
agent-browser --session-name instagram eval --stdin <<'EVALEOF'
JSON.stringify(
  Array.from(document.querySelectorAll('a[href*="/p/"], a[href*="/reel/"]'))
    .map(a => ({
      href: a.href,
      alt: a.querySelector('img')?.alt || '',
    }))
    .filter(p => p.alt && !p.alt.startsWith('Carousel'))
)
EVALEOF
```

### 3. Parse alt text

The alt text pattern is:
```
Photo shared by {account} on {date} tagging @{handle}.
May be an image of text that says '{UNIVERSITY} {Major} {STUDENT NAME}'.
```

The OCR text typically contains: `UNIVERSITY NAME Major/Program STUDENT NAME` — but with garbled Unicode where stylized fonts or non-Latin characters appear in the graphic.

**This gets ~60-70% of posts cleanly.** The rest need screenshot + vision (step 4).

### 4. Screenshot + vision for unclear posts

For posts where alt text is garbled or just says "May be an image of text":

```bash
agent-browser --session-name instagram open https://www.instagram.com/{account}/p/{code}/
agent-browser --session-name instagram wait --load networkidle
sleep 1
agent-browser --session-name instagram screenshot /tmp/{name}.png
```

Then read the screenshot with the `read` tool — the graphics clearly show university, major, and student name.

**Bonus: the caption area.** These are image-only posts (no typed caption), but the account owner adds a short caption like:

> `@handle is off to Stanford! Go Cardinal! 🌲`

This is visible in the screenshot and provides a reliable university name even when the graphic OCR is garbled. It's the single most reliable text signal per post.

### 5. Compile results

Output as markdown table + JSON. See `prs-class-2026-early-decisions.md` for the output format.

## Known Issues

- **Session expiry:** Instagram sessions expire in hours. `--session-name` auto-persistence helps but doesn't prevent expiry. Be ready to re-auth headed.
- **`state save`/`state load` is fragile:** The daemon process lingers and blocks `state load`. Don't rely on it — use `--session-name` instead.
- **Login wall overlays:** Instagram pops signup dialogs during scrolling. Dismiss with click, or verify you're still logged in.
- **Scroll limits:** Non-logged-in users see ~12 posts before being blocked. Must be logged in for full scroll.
- **Graphic templates vary by school:** Each decisions account uses different layouts. Alt-text OCR quality varies. Vision fallback is always needed for some posts.
- **Rate limiting:** 1-second delays between scrolls work fine. Don't parallelize.

## Completed Scrapes

| School | Account | Year | Posts | File |
|--------|---------|------|-------|------|
| Pacific Ridge School | `@prsdecisions2026` | 2026 | 19 | `prs-class-2026-early-decisions.md` |
| The Bishop's School (La Jolla) | `@tbs26decisions` | 2026 | 44 (8 unverified) | `tbs-class-2026-early-decisions.md` |
