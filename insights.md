# Insights

- Lazy-loading premise of skills is aspirational — models can't reliably decide when to load a skill autonomously, so hooks forcing evaluation at session start are the actual working pattern. ([source](research/hn-agent-skills-leaderboard.md))

- A compromised agent and a correctly-functioning agent produce identical system calls, network traffic, and logs. Detection — during or after — is structurally impossible. Every sandbox product is prompt-injection damage mitigation, not security. ([source](research/agent-security-synthesis.md))

- The confused deputy is the specific mechanism that defeats all sandboxing: an agent exfiltrates through the API calls it legitimately needs. The Claude Cowork attack proved this — `curl api.anthropic.com` with the attacker's key uploads victim files through a "trusted" channel. ([source](research/hn-matchlock-agent-sandbox.md))

- Permission prompts fail psychologically before they fail technically. Users mash Enter after the 50th prompt — the Windows Vista UAC problem, recreated. Sandboxed YOLO mode is safer than unsandboxed permission prompts with a fatigued human. ([source](research/hn-claude-code-sandboxing-2026.md))

- No isolation boundary preserves full agent capability while providing meaningful security. 25+ sandbox tools exist as of mid-2026 — they represent 25+ positions on the capability–isolation tradeoff curve, not 25+ solutions. ([source](research/agent-security-synthesis.md))

- Autonomous agents (OpenClaw, 24/7) and interactive agents (Pi, Claude Code) have fundamentally different threat models. Being on-screen is a genuine security control — not sufficient alone, but it shrinks the attack window from always-open to session-bounded. Most security advice conflates the two. ([source](research/agent-security-landscape-what-people-do.md))

- Credential blast radius matters more than filesystem blast radius. A sandbox that protects your home directory but gives the agent DB tokens and API keys protects against the wrong thing. Two of three famous "Claude deleted my stuff" incidents weren't filesystem damage — they were remote DB wipes. ([source](research/hn-claude-code-sandboxing-2026.md))

- A dedicated OS user account is the 80/20 play: ~1hr setup, kernel-enforced isolation of SSH keys / Keychain / browser data / personal files, zero ongoing maintenance. It blocks the highest-impact scenario (personal credential theft) at the lowest cost. Everything above it on the isolation ladder adds diminishing returns at escalating friction. ([source](research/agent-separate-macos-user.md))

- LLM exploit generation is no longer theoretical. Heelan got Opus 4.5 / GPT-5.2 to produce 40+ working exploits for a zero-day, bypassing ASLR + CFI + shadow stacks + seccomp, at $30-50 per chain. Sandbox defenses are static; the attacker improves every model generation. ([source](research/hn-matchlock-agent-sandbox.md))

- Content-aware egress — inspecting *what* an agent sends, not just *where* — is the only theoretical fix for authorized-channel exfiltration. But it requires an LLM judging another LLM's output, which reintroduces the prompt injection surface. Nobody has solved this recursion. ([source](research/hn-matchlock-agent-sandbox.md))
