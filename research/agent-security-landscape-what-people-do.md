← [Separate User Pre-Commit](agent-separate-user-precommit-analysis.md) · [Index](../README.md) · → [Google Dedicated Account Setup](agent-google-dedicated-account-setup.md)

# Agent Security in Practice: What People Actually Do (Feb 2026)

**Date:** 2026-02-21
**Context:** Survey of real-world agent security practices across the OpenClaw, Claude Code, and Pi ecosystems. Focused on: what patterns exist, what works, and what applies to interactive (human-on-screen) agent use on a personal Mac.

---

## The Two Worlds

The agent security landscape has split into two fundamentally different use cases, and most advice conflates them:

### World 1: Autonomous 24/7 Agents (OpenClaw / Mac Mini crowd)

The dominant pattern in Feb 2026. People buy a $599 Mac Mini, install OpenClaw, connect via Telegram/WhatsApp, and let it run unattended. The agent processes emails at 3am, monitors calendars, does research, replies to messages. Nobody is watching.

**Who does this:** Early adopters, "AI lifestyle" enthusiasts, content creators. The Unwind AI guy has 6 named agents (Monica, Dwight, Kelly...) running on a Mac Mini, coordinating via filesystem. Stephen Lee's Medium post documents security-first OpenClaw setup with separate user, LuLu firewall, pairing-mode DM access. ChatPRD tested it for 24 hours and uninstalled — "too scary, and I want one."

**Their security posture:**
- Dedicated machine (Mac Mini is the default — not their daily driver)
- Separate standard macOS user account (widely recommended, Stephen Lee documents this explicitly)
- LuLu or Little Snitch for outbound network monitoring
- Dedicated email/calendar accounts for the agent (NOT personal accounts)
- Gateway bound to 127.0.0.1, token auth mandatory since v2026.1.29
- Pairing-mode DM access (manual approval for new contacts)
- FileVault + macOS firewall enabled
- Some run in UTM VMs for maximum isolation

**Their real-world security incidents:**
- CVE-2026-25253: one-click RCE via token theft through crafted webpage (CVSS 8.8, patched in 2026.1.29)
- ClawHavoc campaign: 341 malicious skills on ClawHub (out of 2,857 — 12%), distributing Atomic Stealer malware targeting macOS credentials, crypto wallets, SSH keys
- Shodan exposure: thousands of instances found with 0.0.0.0 binding and no auth
- Cisco Skill Scanner found 26% of 31,000 agent skills contained at least one vulnerability

**The key insight:** These people need heavy isolation because nobody is watching. The agent runs for hours/days between human check-ins. The attack window is wide open.

### World 2: Interactive Supervised Agents (Claude Code / Pi crowd)

The coding agent pattern. You open a terminal, start Pi or Claude Code, steer it through tasks, watch the output, and close it when done. The agent only runs while you're present.

**Who does this:** Developers using Pi, Claude Code, Codex, Cursor. The "MARVIN" builder (Reddit) uses Claude Code as a harness but extends it with MCP integrations for email, calendar, Jira, Confluence. He's present for most interactions. The r/ClaudeCode "personal assistant" thread shows people trying to bridge coding agents into general-purpose use.

**Their security posture:** Mostly... nothing. They run the agent as their own user, on their daily driver, with full access to everything. The implicit security control is **they're watching the screen**.

**Why this matters for you:** You're in World 2. You steer Pi interactively. The OpenClaw security advice (dedicated machine, separate user, pairing mode) is designed for World 1's unattended operation. Some of it applies to you; some is overkill; some doesn't apply at all.

---

## Your Situation Is Different — Why "On-Screen" Matters

Being on-screen while the agent works is a genuine security control. Not a perfect one, but a real one. Here's what it changes:

### What Being On-Screen Gives You

| Property | Autonomous (unattended) | Interactive (you're watching) |
|----------|------------------------|-------------------------------|
| Attack window | Always open — agent processes inputs 24/7 | Only open during your session |
| Prompt injection response time | Minutes to hours before anyone notices | Seconds — you see the agent's behavior change |
| Unusual behavior detection | Requires logging + post-hoc review | You watch it happen in real-time |
| Kill switch | Telegram command, remote shutdown | Ctrl-C. Instant. |
| Permission model | Agent acts on standing permissions | You can say "wait, why are you doing that?" |
| Session persistence | Persistent — compromise survives across sessions | Ephemeral — close terminal, agent stops |

**The session is bounded.** Unlike OpenClaw running 24/7, your Pi session starts when you open it and ends when you close it. There's no 3am window where a poisoned email triggers unmonitored behavior. The attack must succeed during your active session while you're watching.

### What Being On-Screen Does NOT Give You

**You don't read every tool call.** Be honest. Pi makes 10-20 tool calls per task. You skim most of them. A subtle `curl` buried in a build sequence, or data exfiltration embedded in a legitimate-looking API request body, would be easy to miss.

**Exfiltration through allowed channels is invisible.** If the agent sends your SSH key as a field in an Anthropic API request, you won't see it in Pi's output. The data leaves through a channel you've already approved. LuLu won't flag it because api.anthropic.com is expected traffic.

**You step away.** Bathroom. Coffee. Phone call. The agent keeps processing. Even a 2-minute gap is enough for a compromised agent to read and exfiltrate files.

**Honest assessment:** Being on-screen is "human on the loop" — you're supervising, not approving every action. It catches gross behavioral changes (agent suddenly starts reading ~/.ssh) but misses subtle exfiltration (data embedded in normal API calls). It's a meaningful control for World 2 that World 1 doesn't have, but it's not sufficient by itself for high-stakes data.

---

## What People Actually Do for General-Purpose + Security

From the research, four practical patterns emerge. Ordered from most common to most rigorous:

### Pattern 1: "YOLO on Daily Driver" (Most Common)

Run the agent as yourself, on your main machine, full access. Security is "I'm watching" + git for rollback.

**Who:** Most individual developers using Claude Code or Pi for coding.
**Pros:** Zero friction, full capability.
**Cons:** If anything goes wrong, everything is exposed.
**When it breaks:** Prompt injection via npm package, web search, or malicious code.

### Pattern 2: "Dedicated Machine" (OpenClaw Default)

Buy a Mac Mini (or repurpose an old laptop). Agent lives there. Your personal machine is untouched.

**Who:** OpenClaw 24/7 users. The Unwind AI team. Stephen Lee. ChatPRD (briefly).
**Pros:** Physical air gap from personal data. Agent can have full access to its own machine.
**Cons:** $599+. Second machine to maintain. Can't easily share files with your daily driver. Overkill for interactive use.
**When it breaks:** If you sync personal data to the agent machine (iCloud, shared folders).

### Pattern 3: "Separate User + Network Monitoring" (Emerging Best Practice)

Agent runs as a dedicated standard macOS user. LuLu or Little Snitch monitors all outbound connections. Dedicated service accounts (email, calendar) for the agent.

**Who:** Security-conscious OpenClaw users (Stephen Lee's guide). Some Claude Code users on r/ClaudeCode. Recommended by UGREEN, Sitepoint, multiple setup guides.
**Pros:** Kernel-enforced file isolation + network visibility. No extra hardware. Works on your existing machine.
**Cons:** Shared workspace friction, permission management (see [pre-commit analysis](agent-separate-user-precommit-analysis.md)).
**When it breaks:** Discipline decay on symlinks. Exfiltration through allowed hosts (LuLu can't help if exfiltration goes through api.anthropic.com).

### Pattern 4: "Dedicated Agent Service Accounts" (The ChatPRD Pattern)

Don't give the agent access to your personal accounts at all. Create separate accounts for every service the agent touches:
- Agent gets its own Gmail address (`your-agent@gmail.com`)
- Agent gets its own Google Calendar
- Agent creates events on *its* calendar and invites you
- Agent sends emails *from its own address*, not yours

**Who:** ChatPRD's Clawdbot setup (explicitly documented). Stephen Lee (1Password vault for agent credentials only).
**Pros:** Even if compromised, attacker gets the agent's throwaway accounts, not yours. Your personal email/calendar/credentials are never exposed.
**Cons:** Setup burden (new accounts per service). Agent can't read your existing email history or calendar. Agent emails come from a different address.
**Works beautifully with interactive use:** You tell the agent "check my email" and it checks *its* inbox, which you've forwarded relevant items to. Or you paste content into the session.

---

## The Right Cocktail for Your Situation

You want general-purpose use (including coding), on your personal Mac, with you on-screen steering Pi. You're not the OpenClaw 24/7 crowd. Here's what the landscape evidence suggests:

### Tier 1: Do These Regardless (30 min total)

**1. LuLu outbound firewall** (free, open-source, from Objective-See)

```bash
brew install --cask lulu
```

This is the single highest-value security addition for interactive agent use. It shows every outbound connection any process makes. Run it in monitoring mode for a few days to learn your baseline, then set alerts for unexpected destinations.

Why this matters more than user isolation for your case: user isolation protects your files from the agent. LuLu protects against exfiltration — the actual high-impact threat. If a prompt injection tries to `curl` your data to an attacker's server, LuLu alerts you in real-time. You're already on-screen; the alert is immediately actionable.

**Limitation:** LuLu can't inspect the *content* of allowed connections. If exfiltration goes through api.anthropic.com, it looks like normal traffic. This is the "confused deputy" problem no tool solves at the network level.

**2. Fine-grained GitHub PAT** (10 min)

Already in your research. Scoped to specific repos, minimum permissions. Revocable independently.

**3. Separate API keys for the agent** (10 min)

If your Anthropic account supports multiple keys, create one specifically for agent use. Set a spend limit. If compromised, revoke it without affecting your other tooling.

**4. Git discipline** (0 min — just do it)

Commit before risky operations. Review diffs before push. This is your rollback mechanism for the shared workspace.

### Tier 2: Add If You Want General-Purpose Assistant Capability (1-2 hours)

**5. Dedicated agent service accounts** (the ChatPRD pattern)

Create separate Google/email/calendar accounts for the agent. The agent works through *its own accounts*, not yours. You forward relevant emails to it, or it creates calendar events and invites you.

This eliminates the whole "agent needs access to my personal email/calendar" problem without any filesystem isolation. The agent never sees your personal inbox. If compromised, the attacker gets a throwaway Gmail, not your primary account.

**This is the insight that changes the calculus.** The friction rebuttal said "most personal tasks work via APIs." True, but the better move is: they work via *the agent's own accounts*. You don't need to set up Gmail API OAuth for your personal account. You create a new Gmail for the agent and give it those credentials.

**6. Review Pi's output for sensitive file access** (0 min — habit)

When Pi uses `read` or `bash`, glance at what it's accessing. If you see it reading `~/.ssh/`, `~/Library/`, or anything outside the project, that's a red flag. This is cheap because you're already watching.

### Tier 3: Add If Your Risk Tolerance Is Lower (45-90 min)

**7. Separate macOS user account**

Per the [setup guide](agent-separate-macos-user.md). Kernel-enforced protection for your personal files. The analysis in the [pre-commit doc](agent-separate-user-precommit-analysis.md) still applies — the friction is real but manageable for coding, more burdensome for general-purpose use.

**For your situation, this is optional, not essential.** Here's why: Tiers 1-2 address the highest-impact threats (exfiltration via network, credential theft from service accounts) without filesystem isolation. User isolation adds protection against the scenario where a prompt injection reads your SSH keys or browser cookies — but you're watching the screen, and LuLu monitors the exfiltration channel. The compound probability of "injection reads sensitive file AND exfiltrates it AND you don't notice AND LuLu doesn't flag it" is very low for interactive sessions.

Where it still makes sense: if you leave Pi sessions running while you step away frequently, or if you start running the agent unattended (scheduled tasks, background processing).

---

## The OpenClaw Question

> Are they all going crazy with OpenClaw?

Yes, largely. OpenClaw is the dominant "personal AI assistant" platform in Feb 2026. 180K+ GitHub stars, dedicated subreddits, Mac Mini setup guides from every tech publication, a CVE already patched, a Cisco security audit of its skill marketplace.

But OpenClaw is a different tool for a different use case. It's a 24/7 autonomous daemon connected to messaging apps. You're using Pi as an interactive coding agent you steer in real-time. The overlap is:
- Both need API keys
- Both can run bash commands
- Both can access files

The divergence is:
- OpenClaw runs unattended → needs heavy isolation
- Pi runs while you watch → your presence is a security control
- OpenClaw connects to messaging/email/calendar natively → bigger attack surface
- Pi accesses services via skills/tools you explicitly invoke → smaller, more predictable surface
- OpenClaw's ClawHub skills marketplace has 12% malicious rate → you don't use a marketplace

**The MARVIN pattern** (Claude Code as personal assistant harness, extending with MCP integrations) is closer to what you'd do with Pi. And that guy runs it on his daily driver, as himself, with full access. His security model is "I'm present, I trained it, I trust it." Whether that's wise is debatable, but it's the common pattern for interactive use.

---

## The Emerging "LuLu + Dedicated Accounts" Pattern

Multiple sources converge on the same recommendation for agents on personal machines:

1. **UGREEN OpenClaw guide:** "Install Little Snitch ($49) or the free LuLu — shows every outbound connection"
2. **DZone "Trust No Agent":** "Little Snitch, LuLu, OpenSnitch intercept all outbound connections and let you approve or deny them"
3. **Stephen Lee:** 1Password vault with agent-only credentials, separate accounts
4. **ChatPRD:** Dedicated email, dedicated calendar, agent invites you rather than writing to your calendar
5. **Reddit r/AI_Agents "3 months running agents":** "Use Docker, a VM, or a dedicated machine. Not worth the risk on your daily driver."

The Reddit advice is aimed at World 1 (autonomous). For World 2 (interactive), the dedicated machine is overkill. But the network monitoring + dedicated accounts pattern applies equally.

**Nobody is combining LuLu + separate user + interactive use.** The security-conscious OpenClaw crowd does separate user + LuLu + dedicated machine. The interactive Claude Code/Pi crowd does YOLO. There's a gap in the middle that your research has identified: **interactive use with proportional security** — network monitoring and dedicated service accounts, without the overhead of a separate machine or the friction of user isolation for every session.

---

## Bottom Line

The landscape splits into two crowds with different needs. You're in the interactive crowd, where being on-screen is a real (imperfect) security control that the autonomous crowd doesn't have.

The highest-value moves for your situation:
1. **LuLu** — outbound firewall, catches exfiltration attempts, free
2. **Dedicated agent service accounts** — agent gets its own email/calendar, your personal accounts never exposed
3. **Separate API keys** with spend limits
4. **Fine-grained GitHub PAT**
5. **Your eyeballs + Ctrl-C** — the cheapest and most underrated security control

User isolation (separate macOS account) is a Tier 3 addition — valuable but optional for interactive use when Tiers 1-2 are in place. If you start running the agent unattended, promote it to Tier 1.

---

## Sources

- [Stephen Lee: OpenClaw Mac Mini Security-First Setup](https://stephenslee.medium.com/i-set-up-openclaw-on-a-mac-mini-with-security-as-priority-one-heres-exactly-how-050b7f625502) — separate user, LuLu, pairing mode, loopback binding
- [ChatPRD: 24 Hours with Clawdbot](https://www.chatprd.ai/how-i-ai/24-hours-with-clawdbot-moltbot-3-workflows-for-ai-agent) — dedicated email/calendar accounts, permission negotiation, calendar chaos
- [Unwind AI: Autonomous Agent Team](https://www.theunwindai.com/p/how-i-built-an-autonomous-ai-agent-team-that-runs-24-7) — 6 agents on Mac Mini, filesystem coordination, "agents get their own world"
- [UGREEN: OpenClaw Mac Mini Setup](https://us.ugreen.com/blogs/docking-stations/openclaw-on-mac-mini) — separate user, LuLu/Little Snitch, dedicated workspace
- [Reddit r/AI_Agents: 3 Months Running Agents](https://www.reddit.com/r/AI_Agents/comments/1r6t1vc/) — "not worth the risk on your daily driver," logging, isolation
- [Reddit r/ClaudeAI: MARVIN Personal Agent](https://www.reddit.com/r/ClaudeAI/comments/1qlurq6/) — Claude Code as personal assistant harness, 15+ MCP integrations
- [Reddit r/ClaudeCode: Personal Assistant Solutions](https://www.reddit.com/r/ClaudeCode/comments/1r2p37k/) — bridging coding agent to general-purpose use
- [Cisco: OpenClaw Security Nightmare](https://blogs.cisco.com/ai/personal-ai-agents-like-openclaw-are-a-security-nightmare) — skill scanner, ClawHavoc, data exfiltration via skills
- [NVIDIA: Sandboxing Agentic Workflows](https://developer.nvidia.com/blog/practical-security-guidance-for-sandboxing-agentic-workflows-and-managing-execution-risk) — VM isolation guidance
- [Docker: 3Cs Framework for Agent Security](https://www.docker.com/blog/the-3cs-a-framework-for-ai-agent-security/) — "human attention is not a scalable control plane"
- [Objective-See: LuLu](https://objective-see.org/products/lulu.html) — free open-source macOS outbound firewall
- [Anthropic: Claude Code Security](https://thehackernews.com/2026/02/anthropic-launches-claude-code-security.html) — vulnerability scanning (announced Feb 20, 2026, unrelated to sandbox)
