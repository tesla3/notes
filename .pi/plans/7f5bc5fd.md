{
  "id": "7f5bc5fd",
  "title": "brave-search: parallelize content fetches",
  "status": "completed",
  "created_at": "2026-02-21T21:19:55.269Z",
  "assigned_to_session": "64a6dabc-365b-420a-b935-9715549a21e6",
  "steps": [
    {
      "id": 1,
      "text": "Copy brave-search skill directory into my-pi-skills repo (search.js, SKILL.md, package.json, node_modules)",
      "done": true
    },
    {
      "id": 2,
      "text": "Replace sequential for-await with Promise.all() in search.js",
      "done": true
    },
    {
      "id": 3,
      "text": "Test: run with --content -n 5, confirm all results have content and wall-clock is ~2-3s not ~10s",
      "done": true
    },
    {
      "id": 4,
      "text": "Update pi skill config to point brave-search at my-pi-skills copy",
      "done": true
    },
    {
      "id": 5,
      "text": "Commit to my-pi-skills repo",
      "done": true
    }
  ]
}

## Context

`brave-search/search.js` fetches page content sequentially when `--content` flag is used. With 10 results at ~1-2s each, that's 10-20s of serial waiting. Should be `Promise.all()`.

## Details

- Source: `~/.pi/agent/skills/pi-skills/brave-search/`
- Destination: `/Users/js/pi-place/my-pi-skills/brave-search/` (version-controlled customized skills repo)
- Copy full skill directory first, then modify in-place.
- `fetchPageContent()` catches errors internally (returns error strings), so `Promise.all` won't reject. No need for `Promise.allSettled` or concurrency limits (max 20 fetches to distinct hosts).
- Git repo: `/Users/js/pi-place/my-pi-skills/`
- After commit, update pi skill config to point at the local copy.
