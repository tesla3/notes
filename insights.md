# Insights

- Lazy-loading premise of skills is aspirational — models can't reliably decide when to load a skill autonomously, so hooks forcing evaluation at session start are the actual working pattern. ([source](research/hn-agent-skills-leaderboard.md))

- Agent sandboxing has a ceiling: a compromised agent exfiltrates through the same API hosts it legitimately needs (confused deputy). Destination-based controls — allowlists, firewalls, network policies — can't distinguish the two. Content inspection is the only theoretical fix, but it requires an LLM judging another LLM, reintroducing the injection surface. ([source](research/agent-security-synthesis.md))

- Permission prompts fail psychologically before they fail technically. Approval fatigue trains users to mash Enter — the same failure mode as Windows Vista UAC. ([source](research/hn-claude-code-sandboxing-2026.md))

- Credential blast radius matters more than filesystem blast radius. A sandbox protecting your home directory but handing the agent DB tokens or API keys has the isolation pointed at the wrong thing — the famous `rm -rf` incidents get attention, but remote DB wipes via MCP tokens are harder to recover from. ([source](research/hn-claude-code-sandboxing-2026.md))

- Sandbox defenses are static; the attacker improves every model generation. Heelan got Opus 4.5 / GPT-5.2 to produce 40+ working exploit chains for a single zero-day at $30-50 per chain, bypassing ASLR + CFI + shadow stacks + seccomp. ([source](research/hn-matchlock-agent-sandbox.md))
