← [Developer Tools](../topics/dev-tools.md) · [Index](../README.md)

# Kiro CLI Customization Capabilities

**Research Date:** 2026-02-20  
**Status:** Comprehensive customization available through multiple mechanisms

## Executive Summary

Kiro CLI provides extensive customization capabilities through three primary mechanisms:

1. **Custom Agents** — Full control over system prompts, tool access, and behavior via JSON configuration
2. **MCP Servers** — Add custom tools through Model Context Protocol integration
3. **Steering Files** — Persistent project knowledge and conventions via markdown files

You can customize both the system prompt and tools. The architecture is designed for this.

## System Prompt Customization

### Method 1: Custom Agents (Primary)

Custom agents allow complete system prompt customization through the `prompt` field in agent configuration files.

**Location:**
- Local (project): `.kiro/agents/<agent-name>.json`
- Global (user): `~/.kiro/agents/<agent-name>.json`

**Prompt Configuration:**

```json
{
  "name": "my-agent",
  "prompt": "You are an expert in X. Follow these rules: ..."
}
```

**External Prompt Files:**

```json
{
  "prompt": "file://./my-agent-prompt.md"
}
```

Path resolution:
- Relative paths resolve from agent config directory
- Absolute paths work as-is
- Supports markdown format

**Creation:**
- Interactive: `/agent generate` (within chat session)
- CLI: `kiro-cli agent create --name my-agent`
- Manual: Create JSON file directly

**Usage:**
- Start with agent: `kiro-cli --agent my-agent`
- Switch during session: `/agent swap`
- Keyboard shortcuts: Configure `keyboardShortcut` field

### Method 2: Steering Files (Supplementary)

Steering files provide persistent project knowledge that augments the base prompt.

**Locations:**
- Workspace: `.kiro/steering/*.md`
- Global: `~/.kiro/steering/*.md`
- AGENTS.md standard: Root or `~/.kiro/steering/AGENTS.md`

**Behavior:**
- Automatically loaded in default agent
- Must be explicitly added to custom agents via `resources` field
- Workspace steering overrides global when conflicts exist

**Example Custom Agent with Steering:**

```json
{
  "resources": ["file://.kiro/steering/**/*.md"]
}
```

## Custom Tools

### Method 1: MCP Servers (Primary)

Model Context Protocol servers provide custom tools to Kiro.

**Configuration File:**
- Workspace: `.kiro/settings/mcp.json`
- Global: `~/.kiro/settings/mcp.json`

**Local Server Example:**

```json
{
  "mcpServers": {
    "web-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-bravesearch"],
      "env": {
        "BRAVE_API_KEY": "${BRAVE_API_KEY}"
      }
    }
  }
}
```

**Remote Server Example:**

```json
{
  "mcpServers": {
    "api-server": {
      "url": "https://api.example.com/mcp",
      "headers": {
        "Authorization": "Bearer ${API_TOKEN}"
      }
    }
  }
}
```

**Tool Control:**
- Disable servers: `"disabled": true`
- Disable specific tools: `"disabledTools": ["tool_name"]`
- Auto-approve tools: `"autoApprove": ["tool_name"]`

**View Loaded Servers:**
```bash
/mcp
```

### Method 2: Custom Agent Tool Configuration

Custom agents provide granular control over which tools are available.

**Tool Selection:**

```json
{
  "tools": [
    "read",              // Built-in tool
    "write",
    "@git",              // All tools from git MCP server
    "@fetch/fetch_url"   // Specific tool from MCP server
  ]
}
```

**Tool Permissions:**

```json
{
  "allowedTools": [
    "read",
    "@git/git_status",
    "@server/read_*",    // Wildcard pattern
    "@fetch"             // All tools from server
  ]
}
```

**Tool Settings:**

```json
{
  "toolsSettings": {
    "write": {
      "allowedPaths": ["src/**", "tests/**"]
    },
    "shell": {
      "allowedCommands": ["git status"],
      "deniedCommands": ["git push .*"],
      "autoAllowReadonly": true
    }
  }
}
```

**Tool Aliases (Collision Resolution):**

```json
{
  "toolAliases": {
    "@github-mcp/get_issues": "github_issues",
    "@gitlab-mcp/get_issues": "gitlab_issues"
  }
}
```

## Configuration Priority

### MCP Server Loading Priority

When same server defined in multiple locations (highest to lowest):

1. Agent Config — `mcpServers` field in agent JSON
2. Workspace MCP JSON — `.kiro/settings/mcp.json`
3. Global MCP JSON — `~/.kiro/settings/mcp.json`

**Behavior:**
- Same name = complete override (only highest priority used)
- Different names = additive (all loaded)
- Can disable via override: `"disabled": true`

### Agent Precedence

When same agent name exists:

1. Local agents (`.kiro/agents/`)
2. Global agents (`~/.kiro/agents/`)

Local takes precedence with warning message.

### Steering File Priority

When conflicts exist:
- Workspace steering overrides global steering
- Allows global defaults with project-specific overrides

## Advanced Features

### Hooks

Execute commands at specific lifecycle points:

```json
{
  "hooks": {
    "agentSpawn": [
      {"command": "git status"}
    ],
    "userPromptSubmit": [
      {"command": "ls -la"}
    ],
    "preToolUse": [
      {
        "matcher": "execute_bash",
        "command": "{ echo \"$(date) - Bash:\"; cat; } >> /tmp/audit.log"
      }
    ],
    "postToolUse": [
      {
        "matcher": "fs_write",
        "command": "cargo fmt --all"
      }
    ],
    "stop": [
      {"command": "npm test"}
    ]
  }
}
```

**Hook Types:**
- `agentSpawn` — Agent initialization
- `userPromptSubmit` — User message submission
- `preToolUse` — Before tool execution (can block)
- `postToolUse` — After tool execution
- `stop` — Assistant finishes responding

### Resources

Provide context to agents:

```json
{
  "resources": [
    "file://README.md",                    // Loaded at startup
    "file://docs/**/*.md",                 // Glob patterns
    "skill://.kiro/skills/**/SKILL.md"     // Progressive loading
  ]
}
```

**Resource Types:**
- `file://` — Loaded into context at startup
- `skill://` — Metadata loaded at startup, full content on demand
- Knowledge bases — Indexed documentation with search

**Knowledge Base Example:**

```json
{
  "resources": [
    {
      "type": "knowledgeBase",
      "source": "file://./docs",
      "name": "ProjectDocs",
      "description": "Project documentation",
      "indexType": "best",
      "autoUpdate": true
    }
  ]
}
```

### Model Selection

Specify model per agent:

```json
{
  "model": "claude-sonnet-4"
}
```

Falls back to default if unavailable.

### Welcome Messages

Display message when switching to agent:

```json
{
  "welcomeMessage": "Ready to help with AWS and Rust development!"
}
```

## Complete Example

```json
{
  "name": "aws-rust-agent",
  "description": "Specialized agent for AWS and Rust development",
  "prompt": "file://./prompts/aws-rust-expert.md",
  "mcpServers": {
    "fetch": {
      "command": "fetch-server",
      "args": []
    },
    "git": {
      "command": "git-mcp",
      "args": [],
      "env": {
        "GIT_CONFIG_GLOBAL": "/dev/null"
      }
    }
  },
  "tools": [
    "read",
    "write",
    "shell",
    "aws",
    "@git",
    "@fetch/fetch_url"
  ],
  "toolAliases": {
    "@git/git_status": "status",
    "@fetch/fetch_url": "get"
  },
  "allowedTools": [
    "read",
    "@git/git_status"
  ],
  "toolsSettings": {
    "write": {
      "allowedPaths": ["src/**", "tests/**", "Cargo.toml"]
    },
    "aws": {
      "allowedServices": ["s3", "lambda"],
      "autoAllowReadonly": true
    }
  },
  "resources": [
    "file://README.md",
    "file://docs/**/*.md",
    "file://.kiro/steering/**/*.md"
  ],
  "hooks": {
    "agentSpawn": [
      {"command": "git status"}
    ],
    "postToolUse": [
      {
        "matcher": "fs_write",
        "command": "cargo fmt --all"
      }
    ]
  },
  "model": "claude-sonnet-4",
  "keyboardShortcut": "ctrl+shift+r",
  "welcomeMessage": "Ready to help with AWS and Rust development!"
}
```

## Security Considerations

**MCP Servers:**
- Use environment variable references: `${API_TOKEN}`
- Never hardcode credentials
- Only connect to trusted servers
- Use `disabledTools` for dangerous operations

**Custom Agents:**
- Start restrictive, expand as needed
- Use specific patterns over wildcards
- Configure `toolsSettings` for sensitive operations
- Test in safe environments first

**Steering Files:**
- Never include API keys, passwords, or sensitive data
- Treat as code — require reviews
- Version control with project

## Best Practices

**Custom Agents:**
- Use descriptive names indicating purpose
- Document usage in descriptions
- Store in version control
- Test thoroughly before sharing

**MCP Servers:**
- Validate JSON syntax
- Verify command paths exist in PATH
- Check environment variables are set
- Review configuration loading priority

**Steering Files:**
- One domain per file
- Use clear, descriptive names
- Include context (why, not just what)
- Provide code examples
- Maintain regularly

**Organization:**
- Local agents for project-specific needs
- Global agents for general-purpose use
- Workspace steering for project standards
- Global steering for universal conventions

## Verdict

Kiro CLI provides comprehensive customization capabilities that rival or exceed other AI coding assistants:

**Strengths:**
- Multiple customization layers (agents, MCP, steering)
- Clear priority hierarchy
- Both inline and file-based prompts
- Granular tool control with wildcards
- Security-first design (allowedTools, toolsSettings)
- Hooks for lifecycle integration
- Progressive loading (skills, knowledge bases)
- Team-wide deployment support

**Architecture Quality:**
- Well-designed separation of concerns
- Composable configuration (agents + MCP + steering)
- Flexible scoping (global vs. local)
- Override mechanisms at each level

**Comparison to Alternatives:**
- More structured than Cursor's .cursorrules
- More flexible than Cline's custom instructions
- MCP integration provides extensibility beyond most competitors
- Hooks enable workflow automation others lack

**Practical Assessment:**
This is production-grade customization infrastructure. The three-layer approach (agents for behavior, MCP for tools, steering for knowledge) provides both power and maintainability. The priority system prevents configuration chaos while allowing overrides where needed.

## Sources

1. [Kiro CLI — Agent Configuration Reference](https://kiro.dev/docs/cli/custom-agents/configuration-reference/)
2. [Kiro CLI — Creating Custom Agents](https://kiro.dev/docs/cli/custom-agents/creating/)
3. [Kiro CLI — MCP Configuration](https://kiro.dev/docs/cli/mcp/configuration/)
4. [Kiro CLI — Steering](https://kiro.dev/docs/cli/steering/)
5. [Kiro CLI — Model Context Protocol](https://kiro.dev/docs/cli/mcp/)
