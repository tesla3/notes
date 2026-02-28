← [Agent Skills: Architecture & Analysis](agent-skills.md) · [Index](../README.md)

# Agent Skills & Tools: Emerging Winners by Category (February 2026)

*Sources: Firecrawl, Bright Data, TestCollab, SupaTest, Tembo, Faros AI, Pinggy, inference.sh, skills.sh, agent-skills.cc, DEV Community, Reddit (r/ClaudeCode, r/mcp, r/cybersecurity), GitHub issues (obra/superpowers), DeepLearning.AI, Anthropic Engineering, Microsoft playwright-mcp repo, multiple independent benchmarks. All sources Feb 2025–Feb 2026.*

---

## The Big Picture: Three Structural Shifts

Before the category-by-category breakdown, three tectonic shifts frame everything:

### 1. CLI Is Beating MCP on Token Efficiency

This is the most consequential development in the agent tooling space. Microsoft's own Playwright team now explicitly recommends CLI over MCP:

> "Modern coding agents increasingly favor CLI-based workflows exposed as SKILLs over MCP because CLI invocations are more token-efficient."
> — [Microsoft playwright-mcp repo](https://github.com/microsoft/playwright-mcp)

The numbers are brutal:

| Approach | Tokens (browser automation task) | Source |
|---|---|---|
| Playwright MCP | ~114,000 | Microsoft benchmarks |
| Playwright CLI | ~27,000 | Microsoft benchmarks |
| Agent Browser (ref system) | ~1,400 per snapshot | Bright Data/Pulumi independent benchmark |
| MCP (GitHub, 93 tools) | ~55,000 schema injection alone | jannikreinhard.com field test |
| CLI (same GitHub tasks) | ~200 per command | jannikreinhard.com field test |

In enterprise scenarios (Microsoft Graph + Intune), the gap is **18-35x** ([jannikreinhard.com](https://jannikreinhard.com/2026/02/22/why-cli-tools-are-beating-mcp-for-ai-agents/)).

**Why:** MCP dumps full tool schemas + rich responses into context. CLI saves state to disk; agent reads only what it needs. The architectural difference is *where browser/tool state lives* — context window vs. filesystem. For coding agents with filesystem access, CLI wins decisively.

**The practitioner consensus is converging fast.** Obsidian creator @kepano: "CLI is better than MCP. Faster. Direct access to your local files. No need for a server or auth. Composable with pipes." Multiple builders independently arriving at "Skills + CLI > MCP" ([applicationlayer.substack.com](https://applicationlayer.substack.com/p/are-mcp-servers-a-thing-of-the-past)).

**Nuance:** MCP isn't dead. It wins for (a) sandboxed agents without filesystem access, (b) structured third-party integrations where no CLI exists, (c) read-only context sources like docs. MCP also adopted "progressive discovery" in Jan 2026, which mitigates the schema-dump problem. But for the core loop of coding agent work, CLI + Skills is the emerging dominant pattern.

### 2. The Agent Skills Standard Achieved Remarkable Cross-Platform Adoption

Anthropic open-sourced the Agent Skills spec at [agentskills.io](https://agentskills.io/) in December 2025. Within two months, adoption across 25+ platforms:

- **Claude Code** (native)
- **OpenAI Codex CLI & ChatGPT** (Simon Willison discovered ChatGPT's `/home/oai/skills` folder in Dec 2025)
- **GitHub Copilot** (VS Code, CLI, coding agent)
- **Cursor, Windsurf, Gemini CLI**
- **Amp, Goose, Roo Code, Trae, OpenCode, Letta, Kilo**

This is the same playbook as MCP: Anthropic establishes an open standard, benefits from being best at using it. The format is simple enough (markdown + frontmatter) that adoption cost is near-zero.

**Distribution:** [skills.sh](https://skills.sh/) (Vercel, Jan 2026) serves as the npm-equivalent: `npx skills add owner/repo`. 57,000+ skills listed. [LobeHub](https://lobehub.com/skills) and [agent-skills.cc](https://agent-skills.cc/) are alternative registries. DeepLearning.AI launched an official "Agent Skills with Anthropic" course.

### 3. The Flywheel Is Already Observable

The co-evolution dynamic we theorized is already happening: Vercel's Agent Browser pioneered the snapshot + refs pattern for token-efficient browser automation. Microsoft's Playwright CLI (launched early 2026) adopted *the same pattern* — element references, compact snapshots, disk-based state. The innovation diffused in weeks, not years.

This is both validation (the ref pattern is winning) and a counter-example to pure winner-takes-all (Microsoft replicated it instantly because the concept is simple).

---

## Category-by-Category: Emerging Winners

### 🌐 Browser Automation for Agents

**The most contested category.** At least 11 serious contenders.

| Tool | GitHub Stars | Approach | Token Efficiency | Best For |
|---|---|---|---|---|
| **Browser Use** | 78,000+ | Full agent loop (Python) | Medium | Autonomous multi-step agents |
| **Playwright** (base) | 70,000+ | Deterministic scripting | N/A (not AI-native) | CI/CD, test suites |
| **Stagehand** | 21,000+ | Hybrid (Playwright + AI) | Medium | Surgical AI actions in larger workflows |
| **Skyvern** | 20,000+ | No-code, CV-based | Medium | No-code automation |
| **Agent Browser** (Vercel) | 14,000+ | Snapshot + refs CLI | **Very high** (~93% reduction) | AI coding assistants |
| **Playwright CLI** (Microsoft) | New (early 2026) | Snapshot + refs CLI | **Very high** (4-100x vs MCP) | AI coding agents, test gen |
| **Bright Data Agent Browser** | N/A (cloud) | Enterprise proxy infra | Medium | Enterprise scraping at scale |
| **OpenBrowser MCP** | New | Single-tool, agent-writes-Python | **Very high** (3.2x vs PW MCP) | MCP-only environments |

**Who's winning and why:**

**Browser Use** (78K stars) leads by raw GitHub popularity — it's the "let the LLM drive the browser" approach. Full agent autonomy, multi-tab, memory, planning. Python-native. But token-hungry because the LLM processes full page state each step.

**Agent Browser** (Vercel, 14K stars) pioneered the *conceptual winner* pattern: snapshot + refs. Its 93% token reduction (15,000 → ~1,000 tokens per page interaction) is the metric everyone benchmarks against. Purpose-built for coding agents. Rust CLI, fast boot. But no anti-bot, no CAPTCHA solving, runs locally on your IP.

**Playwright CLI** (Microsoft, early 2026) is the **most significant entrant**. It adopted Agent Browser's ref pattern, added cross-browser support (Chrome/Firefox/WebKit), YAML-based snapshot persistence, and carries Microsoft's brand weight. Microsoft's own repo recommends CLI over their own MCP server. This is a strong signal.

**The emerging dynamic:** Browser Use wins the "full autonomy" category. Agent Browser / Playwright CLI compete head-to-head for the "token-efficient coding agent" category. Playwright CLI has structural advantages (Microsoft backing, cross-browser, existing Playwright ecosystem). Agent Browser has first-mover advantage and deeper feature set (iOS Simulator, video recording, encrypted sessions, visual diffing).

**My assessment:** This is the category most likely to consolidate. Playwright CLI's entry validates the ref/snapshot pattern and may commoditize it. Agent Browser needs to differentiate on features Microsoft won't build (mobile testing, visual regression, enterprise state management) or risk being absorbed by the larger ecosystem. Browser Use survives in a different niche (autonomous agents that need to reason about page content, not just execute commands).

**The hybrid pattern is emerging:** "Playwright for the 80% of steps that are predictable, Stagehand or Browser Use for the 20% that require AI understanding" ([NxCode](https://www.nxcode.io/resources/news/stagehand-vs-browser-use-vs-playwright-ai-browser-automation-2026)). Not winner-takes-all within the category, but specialization.

### 🔍 Web Search & Content Extraction

| Tool | Type | Approach |
|---|---|---|
| **Brave Search** | API + CLI skill | Direct API, content extraction via Readability |
| **Firecrawl** | API + SDK (82K stars) | Web scraping + crawling, structured extraction |
| **Jina Reader** | API | URL → Markdown conversion |
| **Serper** | API | Google Search results API |

**Who's winning:** Firecrawl (82K+ stars) is the GitHub darling — broader than just search (full crawling, structured extraction). For *agent skills* specifically, Brave Search is the canonical example (referenced in Anthropic's docs, bundled with pi-skills). Jina Reader is lightweight but limited.

**Assessment:** This category is less contested because the skills layer is thin — it's mostly "call an API, return results." The differentiation is in the API itself, not the skill wrapper. Brave Search's free tier + simple CLI makes it the default for individual developers. Firecrawl wins for anything beyond basic search (crawling, structured extraction, enterprise).

### 🧠 Workflow & Meta-Skills

These are "skills about how to work," not tools for specific tasks.

| Skill | GitHub Stars | What It Does |
|---|---|---|
| **Superpowers** (obra) | 45,500+ | Plan-before-code workflow with TDD, subagents, systematic debugging |
| **Vercel React Best Practices** | 131,000+ installs | Official React/Next.js patterns from Vercel Engineering |
| **Web Design Guidelines** | 98,000+ installs | Frontend UI/UX standards |
| **Anthropic official skills** | 73,000 stars | Document processing (docx, pdf, pptx, xlsx), MCP server builder, Playwright testing |

**Superpowers is the standout.** At 45.5K stars, it's the most popular *meta-skill* — it doesn't add a capability, it adds *engineering discipline*. It forces agents through planning → design → implementation → verification. Spawns subagents for context gathering. Enforces TDD. Reddit testimonials describe it as "making Claude Code actually follow engineering best practices" instead of dumping code.

**Why Superpowers matters for the flywheel thesis:** It's the strongest example of co-evolution. The skill was designed specifically for Claude Code's subagent architecture. It's now migrating to the open Agent Skills standard for cross-platform support (GitHub issue #394 shows them adopting the spec for Codex/Gemini compatibility). This is the pattern: start on one platform, prove value, then spread via the standard.

**Vercel's skills** (React Best Practices, Web Design Guidelines) dominate by install count on skills.sh because Vercel controls the distribution platform. This is a flywheel advantage: Vercel operates skills.sh *and* publishes the most popular skills *and* built Agent Browser. Vertical integration.

**Anthropic's official skills** (73K stars) are the reference implementation. Their document processing skills (docx, pdf, pptx, xlsx) are the only "source-available" (vs. Apache 2.0) skills — Anthropic keeps tighter control on their production-grade capabilities. Smart licensing move: open enough to drive adoption, closed enough to maintain quality advantage.

### 📄 Document Processing

| Skill | Publisher | Capabilities |
|---|---|---|
| **Anthropic docx/pdf/pptx/xlsx** | Anthropic (official) | Create, read, edit documents |
| **Trail of Bits Security** | Community | Security auditing |

**Anthropic dominates** this category because document skills are built into Claude.ai (Pro/Max/Team/Enterprise). They work "behind the scenes" — the skill activates automatically when a user mentions slides, spreadsheets, or PDFs. This is the strongest lock-in mechanism: the skill is invisible, the capability is expected, and alternatives can't replicate the tight Claude integration.

### 🔌 Infrastructure & Integrations

| Skill | Publisher | What It Does |
|---|---|---|
| **Weaviate Agent Skills** | Weaviate | Vector DB integration for coding agents |
| **Supabase Agent Skills** | Supabase | Postgres, RLS, Edge Functions |
| **Connect (skills.sh)** | Community | Gmail, Slack, GitHub, Notion automation |

**Emerging pattern:** Database and SaaS vendors are publishing skills to become the "default" their category when agents need integrations. Weaviate launched agent skills Feb 21, 2026. Supabase has them. This is the flywheel at the vendor level — if Claude Code "knows" Weaviate via a well-crafted skill, developers default to it for vector DB needs.

### 🖥️ Terminal Orchestration

This category barely exists as a competitive space. The tmux skill pattern (isolated sockets, wait-for-text polling, session management) is specific to agent-terminal interaction. No major competitors because it's an unusual niche — most developers don't need their agent to drive interactive CLIs through tmux.

---

## The Structural Insight: CLI + Skills Is the Winning Architecture

The biggest insight from this research isn't about any individual tool. It's about the **architectural pattern** that's converging:

```
Agent ──bash──> CLI tool (token-efficient, disk-based state)
  │
  └── SKILL.md (teaches the agent how to use the CLI)
```

This beats MCP for coding agents because:
1. **Token efficiency:** 4-35x less context consumption
2. **Composability:** Unix pipes, chaining, standard shell patterns
3. **Training data advantage:** Models already know CLI tools from billions of lines of training data
4. **Progressive disclosure:** Skill loads on-demand; CLI output goes to disk, read on-demand
5. **Zero infrastructure:** No server process, no auth flow, no schema registration

MCP survives for sandboxed environments (Claude.ai, Cursor without shell), third-party integrations without CLIs, and read-only context injection. But the momentum is clearly toward CLI + Skills.

**Microsoft's pivot is the strongest signal.** When the company that *built* Playwright MCP says "use CLI instead," and rebuilds the same tool as a CLI with a SKILL.md, the direction is clear.

---

## Critical Assessment: What's Real, What's Hype

### Real

- **CLI token efficiency advantage over MCP** — independently verified by Microsoft, multiple test automation vendors, enterprise practitioners. The 4x minimum, 35x in enterprise scenarios numbers are credible.
- **Agent Skills standard adoption** — 25+ platforms in 2 months is genuine. The format is simple enough that adoption cost approaches zero.
- **Superpowers improving agent output quality** — Reddit testimonials are consistent and specific (not "it's amazing" but "it caught missing test cases and split my implementation into proper phases"). The 45.5K stars with active GitHub issues suggests real usage, not just stars.
- **Ref/snapshot pattern for browser automation** — independently converged upon by Vercel (Agent Browser) and Microsoft (Playwright CLI). When competitors adopt your innovation, it's validated.

### Hype / Caution

- **skills.sh "57,000+ skills"** — This number is inflated. skills.sh counts GitHub repos, not curated skills. Many are low-quality, duplicative, or just README files with a SKILL.md frontmatter slapped on. The vibecoding.app review notes: "The top skills are almost all from verified vendors. Community submissions exist, but they're buried under the noise." The *quality* problem is real and unsolved.
- **"Agent browser market $4.5B → $76.8B by 2034"** — Market.us projections cited everywhere. These numbers conflate consumer AI browsers (Perplexity Comet, ChatGPT Atlas) with developer agent tools. The developer-facing category is a fraction of this. Take with extreme skepticism.
- **Security concerns are underplayed.** A Reddit post from r/cybersecurity (3 weeks ago): "I run an AI agent skill marketplace and honestly the state of security across this space is terrifying." Skills run with whatever permissions the agent has — shell access, filesystem, API keys. No sandboxing, no permission scoping, no audit trail. This is a ticking time bomb for enterprise adoption.
- **Cross-platform portability in practice** — "Write once, use everywhere" is the promise. In practice, skills reference specific file paths, assume specific CLI tools are installed, and encode patterns optimized for specific models. A skill written for Claude Code's subagent architecture won't work the same way in Gemini CLI. The format is portable; the *behavior* often isn't.

### The Flywheel Status, Revisited

Our earlier analysis predicted oligopoly with real barriers to entry. The evidence supports this but with a twist:

**The flywheel is operating at the *pattern* level, not the *tool* level.** Agent Browser pioneered snapshot + refs. Playwright CLI adopted it. OpenBrowser MCP adopted it. The pattern won; no single tool locked it in. The innovation diffused too fast for monopoly — because the concept (compact element references for LLMs) is simple to replicate.

What *is* concentrating is **distribution and ecosystem**:
- **Anthropic** controls the spec (agentskills.io), the reference implementation (73K stars), and the best model for using skills
- **Vercel** controls the distribution hub (skills.sh), the top install-count skills, and a key browser tool
- **Microsoft** controls the dominant browser automation stack (Playwright) and is pivoting it toward the skills architecture

The winner-takes-all dynamic is happening at the **platform/vendor** level, not the individual tool level. The tools are commoditizing; the ecosystems are consolidating.

---

## Summary Table: Winners by Category

| Category | Current Leader | Challenger | Why Leader Wins | Risk to Leader |
|---|---|---|---|---|
| **Browser (token-efficient)** | Agent Browser (Vercel) | Playwright CLI (Microsoft) | First mover, deeper features | Microsoft's ecosystem weight |
| **Browser (autonomous)** | Browser Use | Stagehand | Community (78K stars), full agent loop | Stagehand's hybrid approach |
| **Web search (agent skill)** | Brave Search | Firecrawl | Free tier, canonical example | Firecrawl's richer capabilities |
| **Workflow/meta-skill** | Superpowers (obra) | — | 45.5K stars, unique value prop | Platform dependency (Claude Code) |
| **Document processing** | Anthropic official | — | Built-in to Claude, invisible | Lock-in concern |
| **Skill distribution** | skills.sh (Vercel) | LobeHub, agent-skills.cc | First mover, Vercel backing | Quality control problem |
| **Skill specification** | agentskills.io (Anthropic) | — | 25+ platform adoption | De facto standard |
| **Vendor integrations** | Weaviate, Supabase | Others entering | Early mover advantage | Low barrier to entry |

---

## What To Watch

1. **Playwright CLI vs Agent Browser** — The decisive battle. If Microsoft's CLI achieves feature parity with Agent Browser while carrying Playwright's ecosystem, Agent Browser faces commoditization. Watch for Agent Browser's differentiation moves (mobile, visual regression, enterprise features).

2. **MCP progressive discovery** — MCP adopted lazy tool loading in Jan 2026. If this closes the token gap sufficiently, the CLI-vs-MCP narrative may shift back. Watch for benchmarks comparing post-progressive-discovery MCP to CLI.

3. **Security incident** — The skills security model is "trust the file." When (not if) a malicious skill causes a visible incident, it will force the ecosystem to add permission scoping, sandboxing, or signing. This could fragment the currently-easy adoption.

4. **Superpowers cross-platform** — Currently Claude Code-native. GitHub issue #394 shows migration to the open spec. If Superpowers works equally well on Codex/Gemini, it validates true cross-platform portability. If it doesn't, it reveals the limits of the "write once" promise.

5. **skills.sh quality curation** — Currently a leaderboard with no quality gate. The "npm problem" (malicious/low-quality packages) is already emerging. Whether Vercel adds curation, verification, or community-driven quality signals will determine if skills.sh becomes the real npm-for-skills or remains a discovery surface.
