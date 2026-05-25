# Source: AGENTS.md — Development Rules
# URL: https://github.com/badlogic/pi-mono/blob/main/AGENTS.md
# Retrieved: 2026-02-17

## Key Rules (relevant to understanding pi's design philosophy)

### Code Quality Rules
- No `any` types unless absolutely necessary
- NEVER use inline imports
- NEVER remove or downgrade code to fix type errors — upgrade dependency instead
- All keybindings must be configurable (no hardcoded key checks)

### Command Restrictions
- NEVER run: npm run dev, npm run build, npm test
- After code changes: npm run check (get full output, no tail)

### Style
- "Keep answers short and concise"
- "No emojis in commits, issues, PR comments, or code"
- "No fluff or cheerful filler text"
- "Technical prose only, be kind but direct"

### Git Rules for Parallel Agents
- ONLY commit files YOU changed in THIS session
- NEVER use git add -A or git add .
- ALWAYS use git add <specific-file-paths>
- Forbidden: git reset --hard, git checkout ., git clean -fd, git stash, git commit --no-verify

### Critical Tool Usage
- NEVER use sed/cat to read files — always use the read tool
- Must read every file in full before editing
