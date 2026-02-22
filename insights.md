# Insights

- Lazy-loading premise of skills is aspirational — models can't reliably decide when to load a skill autonomously, so hooks forcing evaluation at session start are the actual working pattern. ([source](research/hn-agent-skills-leaderboard.md))

- A compromised agent and a correctly-functioning agent produce identical network traffic and system calls — the agent exfiltrates through the same API calls it legitimately needs (confused deputy). No sandbox, allowlist, or firewall can distinguish the two. Every sandbox product is prompt-injection damage mitigation, not security. ([source](research/agent-security-synthesis.md))

- Permission prompts fail psychologically before they fail technically. Sandboxed YOLO mode is safer than unsandboxed permission prompts with a fatigued human. ([source](research/hn-claude-code-sandboxing-2026.md))

- Credential blast radius matters more than filesystem blast radius. A sandbox protecting your home directory but handing the agent DB tokens protects against the wrong thing. ([source](research/hn-claude-code-sandboxing-2026.md))

- Sandbox defenses are static; the attacker improves every model generation. Heelan got Opus 4.5 / GPT-5.2 to produce 40+ zero-day exploits at $30-50 per chain, bypassing ASLR + CFI + shadow stacks + seccomp. ([source](research/hn-matchlock-agent-sandbox.md))
