# Source: Extension Examples README and Directory Listing
# URL: https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent/examples/extensions
# Retrieved: 2026-02-17

## Extension Files with Sizes (from GitHub listing)

- permission-gate.ts (1,017 B)
- protected-paths.ts (806 B)
- confirm-destructive.ts (1.6 KB)
- dirty-repo-guard.ts (1.4 KB)
- sandbox/ (directory)
- todo.ts (8.8 KB)
- hello.ts (629 B)
- question.ts (7.6 KB)
- tool-override.ts (4.6 KB)
- minimal-mode.ts (13.5 KB)
- truncated-tool.ts (6.2 KB)
- ssh.ts (7.1 KB)
- subagent/ (directory)
- plan-mode/ (directory)
- handoff.ts (4.5 KB)
- git-checkpoint.ts (1.4 KB)
- auto-commit-on-exit.ts (1.5 KB)
- custom-compaction.ts (4.0 KB)
- trigger-compact.ts (1.0 KB)
- notify.ts (1.9 KB)
- preset.ts (13.0 KB)
- snake.ts (9.2 KB)
- space-invaders.ts (14.8 KB)
- doom-overlay/ (directory)
- pirate.ts (1.4 KB)
- claude-rules.ts (2.4 KB)
- mac-system-theme.ts (1.2 KB)
- custom-provider-anthropic/ (directory)
- custom-provider-gitlab-duo/ (directory)
- custom-provider-qwen-cli/ (directory)

Total: 50+ examples

## Key Extension Patterns (from README)

### State persistence via details:
```typescript
return {
  content: [{ type: "text", text: "Done" }],
  details: { todos: [...todos], nextId },  // Persisted in session
};
```

### StringEnum for Google API compatibility:
```typescript
import { StringEnum } from "@mariozechner/pi-ai";
action: StringEnum(["list", "add"] as const)  // Good
// Type.Union([Type.Literal(...)]) does NOT work with Google
```
