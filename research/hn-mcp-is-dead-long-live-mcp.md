← [Index](../README.md)

# HN Thread Distillation: "MCP is dead; long live MCP"

**Source:** [chrlschn.dev](https://chrlschn.dev/blog/2026/03/mcp-is-dead-long-live-mcp/) | [HN thread](https://news.ycombinator.com/item?id=47380270) (209 pts, 172 comments, 101 unique authors)

**Article summary:** CharlieDigital (Motion engineering) argues the anti-MCP zeitgeist is influencer-driven and misses the key distinction: MCP over stdio is indeed unnecessary overhead, but MCP over streamable HTTP is essential infrastructure for orgs/enterprises wanting centralized auth, telemetry, dynamic content delivery (prompts + resources), and consistent agent capabilities across teams. CLI token savings are real but overstated for bespoke tools not in training data.

**Article assessment:** The article correctly identifies that people conflate stdio and HTTP MCP. But it makes a deeper rhetorical move that the thread mostly doesn't catch: it lists HTTP MCP's benefits (auth, telemetry, dynamic content, security) without acknowledging these benefits exist *because* MCP constrains agents to fixed tool menus. Every governance benefit is purchased by surrendering the unbounded flexibility that makes CLIs powerful. The article presents this as "CLI vs MCP" when the actual tradeoff is "flexibility vs governance" — and that tradeoff is inherent, not solvable by picking the right transport.

### Dominant Sentiment: Three populations talking past each other

Solo devs who find MCP pointless, enterprise engineers who need centralized governance, and protocol skeptics who think the problem is misframed. Unusually low heat for HN AI discourse. Most people are genuinely trying to figure out what works — but almost nobody notices they're optimizing for different objectives.

### Key Insights

**1. The stdio/HTTP distinction is real taxonomy but weak argument**

The article's core claim — stdio MCP ≠ HTTP MCP — is architecturally correct. stdio MCP is a local process wrapper (correctly rejected as pointless overhead). HTTP MCP is centralized infrastructure. These are genuinely different things discussed under one name, which explains why the debate never converges.

But the article oversells what this distinction buys you. HTTP MCP achieves its governance benefits (auth, audit, telemetry) *by constraining the agent to pre-defined tool schemas*. A remote MCP server exposing `searchFlights(origin, destination, date)` is a menu, not a kitchen. The agent can only do what someone anticipated. The moment you try to make MCP flexible enough to match CLI — say, an `executeBash(script)` tool — you destroy every governance benefit: secrets are exposed through arbitrary code, audit logs say "ran a script" instead of "called searchFlights," input validation becomes impossible. The constraint IS the feature. This means HTTP MCP isn't competing with stdio MCP (which everyone already dismissed) — it's competing with CLIs on a fundamentally different axis: governance vs. flexibility. The article frames it as an upgrade; it's a tradeoff.

**2. tptacek is more right than the thread gives him credit for**

tptacek: *"Once you can run commands, MCP becomes silly"* and *"If the chief reason to use MCP is security, I'm sold: it's a dead letter."* The thread pushes back hard — phpnode (*"How are those CLIs being installed and run on hosted services?"*), clintonb (*"MCP is also available on mobile devices"*), locknitpicker (*"a silly way to reinvent the wheel"*).

But these pushbacks are mostly about **deployment convenience**, not architectural necessity. Deploying CLIs to ephemeral runtimes and non-technical users is a real ops problem, but it's a solved category — package managers, container images, SSO CLIs exist. The harder question tptacek is gesturing at: why should the *protocol for agent-tool communication* also be the *deployment and auth framework*? Those are separable concerns. You can have centralized auth (OAuth, SSO) and centralized secrets (Vault, AWS SSM) without MCP. You can have telemetry (OpenTelemetry on any HTTP call) without MCP. MCP bundles these together, which is convenient — but "convenient bundle" is a weaker claim than "essential infrastructure."

Where tptacek's position genuinely fails: non-developer users who will never open a terminal. clintonb's point about product managers and designers connecting Claude Desktop to a gateway via one-click OAuth is real. But this is a UI/UX argument, not a protocol argument.

**3. The "Skills" camp identifies the right abstraction layer but undersells the ops gap**

ArcaneMoose, charcircuit, simianwords, jswny, and socketcluster all argue Skills (.md files with progressive disclosure) are a superset of MCP. charcircuit: *"Anything done with MCP could have an equivalent done with a skill."* socketcluster provides the most compelling practical evidence: *"Adding the troubleshooting file was a game changer... It made the whole experience seamless and foolproof."*

The skills camp is mechanically correct — skills provide everything MCP tools provide for agent context, plus progressive disclosure, plus customizability, without schema bloat. But they handwave the operational questions: How do you distribute skills across 20 repos? Keep them in sync? Handle auth for the underlying CLIs? Get telemetry on which skills agents actually use? simianwords repeats *"skills"* as an answer to every CharlieDigital challenge without engaging with the delivery mechanism. The gap isn't conceptual — it's operational. Skills need a distribution and update story, and right now that story is "commit .md files to each repo" which doesn't scale.

That said — MCP Resources and Prompts are essentially server-delivered skills. So MCP itself is converging toward the skills model, just with HTTP delivery. The real question is whether that HTTP delivery layer needs to be MCP-specific or could be any file server.

**4. The token savings debate is noise — both sides converge on the same solution**

The article correctly notes bespoke CLIs not in training data need the same context as MCP schemas (via `--help` instead of `tools/list`). Both sides agree naive MCP is wasteful. The actual efficiency technique is identical in both paradigms: keep intermediate data out of context.

- CLI does this via pipes: `curl ... | jq '.results[]' | head -5`
- Anthropic's "programmatic tool calling" does this by having the agent write code that calls MCP tools, processes results in a sandbox, returns only the final output. They report 98.7% token savings.

But notice what programmatic MCP tool calling actually is: the agent writes code that calls APIs and processes results before returning to context. That's... just CLI with extra steps. The 98.7% figure compares against *naive* MCP (everything in context), not against CLI (which always had pipes). The improvement is real but the baseline is MCP's own worst case.

jamesrom makes a pragmatic suggestion: *"by default MCP tools should run in forked context. Only a compacted version of the tool response should be returned."* This is sensible but again — it's reimplementing what `command | head -20` already does.

**5. The security argument is architecturally sound but practically hollow**

brabel makes the strongest theoretical case: *"CLIs either use a secret, in which case the LLM will have the exact same permission as you... and prevents AI auditing since it's not the AI that seems to use the secret, it's just you!"* This is correct as stated. A credential proxy where the agent never sees the key is genuinely better architecture.

But three things undermine this:

First, **the agent still sees the data**. If `getDocument` returns sensitive content, the agent has it in context regardless of transport. The credential proxy prevents key exfiltration but not data exfiltration. The security boundary is narrower than claimed.

Second, **CLI security is a solved problem** — not elegant, but solved. jmogly: *"All of the issues you mention can be solved by giving the agent its own set of secrets or using basic file permissions, which are table stakes."* Sandboxed execution (chroot, containers), scoped API keys, least-privilege service accounts — these predate MCP by decades. tptacek: *"Constraining a CLI is a very old problem, one security teams have been solving for at least 2 decades. Securing MCPs is an open problem."*

Third, **MCP's own security history is damning**. troupo: *"They had no security at all until several versions later when they hastily bolted on OAuth."* krzyk: *"There is no standard for MCP authentication... it is blocked in my enterprise."* The protocol that claims security as a key differentiator shipped without auth. brabel's defense — *"leave security open until clear patterns emerge"* — is generous but enterprise security teams don't grade on intentions.

**6. antirez wins the philosophical argument; CharlieDigital wins the organizational one**

antirez: *"What kind of tool I would love to have, to accomplish the work I'm asking the LLM agent to do? Often times, what is practical for humans to use, it is for LLMs. And the reply is almost never the kind of things MCP exports."* His follow-up is devastating: *"MCP makes happy developers that need the illusion of 'hooking' things into the agent, but it does not make LLMs happy."*

Why doesn't MCP make LLMs happy? Because LLMs are trained on text — CLI help pages, Stack Overflow, documentation, code. They reason in natural language and code. A JSON-RPC schema is legible to them but not *native*. More importantly, fixed tool menus prevent the model from doing what it's best at: composing novel solutions from primitives. When an agent writes `curl ... | jq ... | grep ...`, it's *thinking* — combining tools creatively. When it calls `searchFlights(origin, destination, date)`, it's filling out a form.

CharlieDigital's counter: *"You interact with REST APIs and web pages every day."* True, but humans also have UIs, documentation, and the ability to explore. The MCP equivalent is... the tool schema, which is exactly the "bloat" everyone complains about.

CharlieDigital wins on the organizational question though. When your concern is "50 engineers using 5 different agent harnesses getting inconsistent results," antirez's "just use good tools" doesn't help. You need a standardized delivery mechanism. Whether that *must* be MCP is debatable; that you need *something* centralized is not.

**7. The OpenAPI question is the elephant in the room**

hannasanarion: *"I still don't understand why we can't just use OpenAPI."* This never gets adequately answered. OpenAPI provides: schema discovery, input/output shapes, auth specifications, documentation, code generation. MCP adds: JSON-RPC transport, prompts, resources, subscriptions/notifications.

But OpenAPI + webhooks covers most of that. paulddraper inadvertently admits it: *"[MCP is] JSON-RPC plus OAuth. Plus a couple bits around managing a local server lifecycle."* If MCP is "just JSON-RPC plus OAuth" — why not use the existing standards that already have mature tooling, wide adoption, and battle-tested implementations?

The honest answer is probably: MCP exists because Anthropic made it and had the market gravity to get adoption. It's a de facto standard by commercial weight, not a technically necessary one. This isn't damning — HTTP won over technically superior alternatives too — but it means the "MCP is essential" argument is really "MCP has momentum."

**8. Programmatic MCP tool calling reveals MCP's identity crisis**

menix flags an important development: Anthropic and Cloudflare now have the agent write *code* that calls MCP tools, rather than calling them directly. Cloudflare: *"LLMs are better at writing code to call MCP than at calling MCP directly."*

Think about what this means. The industry built MCP so models could call tools via structured schemas. Then discovered models are actually better at writing code to call those same tools. So the solution is: wrap MCP tools in a code execution layer where the model writes TypeScript/Python against a generated API.

This is CLI with extra architectural layers. The model writes code → the code calls an API → gets results → processes them → returns summary. That's exactly what `bash -c 'curl ... | jq ...'` does, minus the MCP server, minus the code sandbox infrastructure, minus the generated TypeScript SDK.

The 98.7% token savings are real — but they're savings over MCP's own worst case (dumping raw tool results into context). CLI pipelines always had this capability. MCP created a problem (context bloat from tool results) and is now solving it by reinventing what CLI pipelines already do.

**9. Google's strategic positioning may matter more than the technical debate**

SilverElfin flags that Google removed MCP from their Workspace CLI while launching "Gemini CLI Extensions": *"feels a lot like Microsoft's Embrace, Extend, Extinguish."* If true, the "MCP is a standard" argument weakens significantly. A protocol is only a standard if major platforms support it. If Google fragments the ecosystem, you get MCP (Anthropic), Gemini Extensions (Google), and whatever OpenAI does — which is exactly the integration fragmentation MCP was supposed to solve.

**10. colinator's implementation quality point is quietly devastating**

*"Every LLM harness that does support MCP at all supports it poorly and with bugs."* Claude Code hallucinated about MCP image results. Codex truncates MCP responses. No harness handles server restarts gracefully. CharlieDigital himself admits: *"many clients are still half-assed on supporting functions outside of MCP tools."*

This isn't a temporary maturity issue — it's a signal. If the protocol is complex enough that even its creator's own tool (Claude Code) implements it badly, the protocol may be over-specified for what implementations can reliably deliver. Compare with CLI: `exec` + `stdin/stdout` + `exit code`. Trivially implemented, universally reliable, decades of battle-testing.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| CLIs save tokens over MCP | Medium | True for training-set tools; false for bespoke tools. But CLI pipes inherently keep intermediate data out of context — MCP needs extra architecture (programmatic calling) to achieve the same |
| MCP is just an API wrapper | Strong | Correct for stdio. For HTTP: it's an API wrapper with auth+telemetry bundled — convenient but not architecturally novel |
| Skills are a superset of MCP | Strong mechanically, Weak operationally | Correct on agent-context delivery; handwaves distribution, sync, auth, and telemetry |
| MCP security is a joke | Strong | Architecturally right, historically wrong, practically blocked at real enterprises (krzyk) |
| Just use OpenAPI | Strong, unanswered | The thread never explains what MCP provides that OpenAPI + webhooks + existing auth doesn't |
| HTTP MCP is essential for enterprise | Medium | Genuine ops convenience; but the same benefits are achievable with existing tools (OAuth, OTel, package managers) without a new protocol |

### What the Thread Misses

- **The flexibility-governance tradeoff is inherent, not solvable.** Nobody states clearly: MCP's governance benefits *require* constraining agents to fixed tools. You cannot have auditable, credentialed, schema-validated tool calls AND unbounded agent creativity. Every argument for MCP is an argument against agent autonomy, and vice versa. The thread treats these as separate feature checklists rather than a single tradeoff curve.

- **Training data gravity favors CLI massively — for now.** Every Unix tool, every Stack Overflow answer, every tutorial is CLI training data. MCP has a fraction of that. Models are natively better at CLI interactions because they've seen billions of examples. MCP proponents never address why you'd fight this current instead of riding it. Counter: if MCP achieves enough adoption, this reverses over time. But "invest now, pay off later if adoption holds" is a bet, not a fact.

- **Agent identity is the real unsolved problem.** agentpiravi raises this once, gets zero engagement: *"delegation isn't identity. An agent with delegated Gmail access is acting as a deputy."* The entire auth debate (MCP credential proxy vs CLI scoped keys) is about delegating *human* permissions to agents. Neither approach addresses agents as first-class principals with their own identity, accountability, and trust boundaries. This is what enterprises will actually need.

- **MCP server ops burden is unexamined.** The thread assumes MCP servers are fire-and-forget. Running a centralized HTTP service with OAuth, monitoring, uptime requirements, and security patching is operationally heavier than distributing a CLI binary. The enterprise cost comparison is incomplete without this.

- **"Enterprise" is mostly speculative.** clintonb and simonjgreen speak from actual enterprise deployment. Everyone else invoking "enterprise" is a small-team lead or solo dev projecting. The article's enterprise argument is plausible but under-evidenced.

- **MCP is converging toward what skills already are.** MCP Resources ≈ server-delivered docs. MCP Prompts ≈ server-delivered skills. The protocol is evolving to deliver the same artifacts that .md files already deliver, just over HTTP instead of from the filesystem. The question "why not just serve .md files over HTTP?" is never asked.

### Verdict

The thread's core tension — governance vs. flexibility — is real but never explicitly named. MCP is a **governance protocol** that developers experience as a **capability constraint**. Its benefits (auth, audit, telemetry, centralized delivery) are genuine but exist *because* agents are restricted to pre-defined tool menus. Every time someone proposes making MCP more flexible, they erode the governance properties that justify its existence.

The article is right that the stdio/HTTP distinction matters and that influencer discourse is shallow. But it commits its own sleight of hand: listing HTTP MCP's governance benefits without acknowledging they come at the cost of agent flexibility — the exact property that makes CLIs superior for actual development work.

The deeper irony: Anthropic's own "programmatic tool calling" — where agents write code against MCP tools instead of calling them directly — is the industry admitting that models are better at writing code than filling out tool schemas. This is convergence toward CLI-style interaction with extra layers. MCP created a context-bloat problem that didn't exist with CLI pipes, then invented an architectural solution (code execution sandboxes) that reimplements what `bash` already does.

Who should use what: if your agents do open-ended development work and your team can manage their own security, CLIs + skills win on every axis that matters to the agent. If you're deploying agent capabilities to non-developers, across heterogeneous harnesses, with compliance requirements — MCP HTTP's governance bundle is genuinely the path of least resistance, not because the protocol is technically necessary, but because the alternative (assembling the same capabilities from existing tools) is more operational work than most orgs will do. MCP wins by bundling, not by being right.
