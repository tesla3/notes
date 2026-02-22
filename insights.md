# Insights

- Lazy-loading premise of skills is aspirational — models can't reliably decide when to load a skill autonomously, so hooks forcing evaluation at session start are the actual working pattern. ([source](research/hn-agent-skills-leaderboard.md))

- Agent sandboxing has a ceiling: a compromised agent exfiltrates through the same API hosts it legitimately needs (confused deputy). Destination-based controls — allowlists, firewalls, network policies — can't distinguish the two. Content inspection is the only theoretical fix, but it requires an LLM judging another LLM, reintroducing the injection surface. ([source](research/agent-security-synthesis.md))

- Permission prompts fail psychologically before they fail technically. Approval fatigue trains users to mash Enter — the same failure mode as Windows Vista UAC. ([source](research/hn-claude-code-sandboxing-2026.md))

- Credential blast radius is under-addressed relative to filesystem blast radius. Most sandbox efforts protect the home directory, but the agent's own API keys and DB tokens remain exposed inside the sandbox. Filesystem damage (the famous `rm -rf` stories) is more common; credential misuse (remote DB wipes via MCP, unauthorized pushes) is less visible but can be equally destructive. ([source](research/hn-claude-code-sandboxing-2026.md))

- Sandbox defenses are static; the attacker improves every model generation. Heelan got Opus 4.5 / GPT-5.2 to produce 40+ working exploit chains for a single zero-day at $30-50 per chain, bypassing ASLR + CFI + shadow stacks + seccomp. ([source](research/hn-matchlock-agent-sandbox.md))

- The Solow Paradox analogy for AI coding is descriptively accurate but predictively weak. IT enabled genuinely new capabilities (networking, e-commerce) that drove organizational restructuring; AI coding accelerates an existing non-bottleneck. Survivorship bias in analogy selection, unfalsifiable timeline, and a simpler explanation (micro data is just biased, no paradox needed) all undermine its predictive use. ([source](research/coding-agents-insight-inventory.md#e-the-solow-parallel))
