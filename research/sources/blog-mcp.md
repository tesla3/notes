# Source: "What if you don't need MCP at all?"
# Author: Mario Zechner
# Date: 2025-11-02
# URL: https://mariozechner.at/posts/2025-11-02-what-if-you-dont-need-mcp/
# Retrieved: 2026-02-17

## Key Quotes

### Section: Introduction
> "many of the most popular MCP servers are inefficient for a specific task. They need to cover all bases, which means they provide large numbers of tools with lengthy descriptions, consuming significant context."

> "MCP servers also aren't composable. Results returned by an MCP server have to go through the agent's context to be persisted to disk or combined with other results."

### Section: Problems with Common Browser DevTools
> "Playwright MCP has 21 tools using 13.7k tokens (6.8% of Claude's context). Chrome DevTools MCP has 26 tools using 18.0k tokens (9.0%). That many tools will confuse your agent, especially when combined with other MCP servers and built-in tools."

### Section: The Benefits
> "instead of pulling in 13,000 to 18,000 tokens like the MCP servers mentioned above, this README has a whopping 225 tokens."

> "These simple tools are also composable. Instead of reading the outputs of an invocation into the context, the agent can decide to save them to a file for later processing, either by itself or by code."

### Section: Making This Reusable
> Describes adding tool dirs to PATH and using aliases for cross-agent reusability

### Section: In Conclusion
> "This general principle can apply to any kind of harness that has some kind of code execution environment. Think outside the MCP box and you'll find that this is much more powerful than the more rigid structure you have to follow with MCP."
