# Source: Skills Documentation
# URL: https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/docs/skills.md
# Retrieved: 2026-02-17

## Key Mechanism

1. At startup, pi scans skill locations and extracts names and descriptions
2. The system prompt includes available skills in XML format per the Agent Skills standard
3. When a task matches, the agent uses `read` to load the full SKILL.md
4. The agent follows the instructions, using relative paths to reference scripts and assets

> "This is progressive disclosure: only descriptions are always in context, full instructions load on-demand."

## Skill Locations
- Global: ~/.pi/agent/skills/
- Project: .pi/skills/
- Packages: skills/ directories or pi.skills entries in package.json
- Settings: skills array with files or directories
- CLI: --skill <path> (repeatable)

## Cross-harness Compatibility
Can use Claude Code or Codex skills by adding their directories to settings:
```json
{ "skills": ["~/.claude/skills", "~/.codex/skills"] }
```

## Description Best Practices
Good: "Extracts text and tables from PDF files, fills PDF forms, and merges multiple PDFs. Use when working with PDF documents."
Poor: "Helps with PDFs."

## Skill Repositories Referenced
- https://github.com/anthropics/skills
- https://github.com/badlogic/pi-skills
