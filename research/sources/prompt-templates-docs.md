# Source: Prompt Templates Documentation
# URL: https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/docs/prompt-templates.md
# Retrieved: 2026-02-17

## Mechanism
- Markdown files that expand into full prompts
- Type /name to invoke (filename without .md)
- Locations: ~/.pi/agent/prompts/, .pi/prompts/, packages, settings, CLI

## Argument Support
- $1, $2, ... positional args
- $@ or $ARGUMENTS for all args joined
- ${@:N} for args from Nth position
- ${@:N:L} for L args starting at N

## Example
```markdown
---
description: Create a component
---
Create a React component named $1 with features: $@
```
Usage: /component Button "onClick handler" "disabled support"
