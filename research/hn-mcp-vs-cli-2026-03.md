← [Index](../README.md)

## HN Thread Distillation: "When does MCP make sense vs CLI?"

**Source:** [ejholmes blog post](https://ejholmes.github.io/2026/02/28/mcp-is-dead-long-live-the-cli.html) · [HN thread](https://news.ycombinator.com/item?id=47208398) · 439 points · 284 comments · March 2026

**Article summary:** Developer argues MCP is dying and unnecessary — LLMs already know CLIs from training data, CLIs compose via pipes, auth already works via existing flows (SSO, kubeconfig), and MCP adds flaky processes, re-auth friction, and all-or-nothing permissions. Acknowledges MCP has a place when no CLI equivalent exists but frames that as the exception.

### Dominant Sentiment: Mostly agree, with caveats

The thread broadly validates the article's core thesis for developer-centric use cases, but the most substantive pushback comes from people pointing out the article commits the classic sin of generalizing from `claude code on my laptop` to all agentic architectures. The vibe is "yes, for us in terminals, but the world is bigger than us."

### Key Insights

**1. The real split is deployment context, not protocol quality**

The thread's most important axis isn't MCP-good vs MCP-bad — it's *where does the agent run*. Local terminal agents (Claude Code, OpenClaw, pi) have bash, so CLI wins by default. Cloud/chat agents (ChatGPT, Claude Web, enterprise backends) have no shell — MCP is the only game in town. Neither camp is wrong; they're answering different questions.

`simonw` nails it in one line: *"MCP makes sense when you're not running a full container-based Unix environment for your agent to run Bash commands inside of."*

`Myrmornis` extends this to enterprise: *"Engineering teams working in that latter category are going to want to expose their own networked services to the agentic app... a JSON-RPC API with clearly defined single-purpose tool-calling endpoints is far, far closer to what they're looking for than the ability for the agent to do wtf it wants by using bash to script its own invocation of executables."*

**2. Composability is the argument nobody refutes**

Of all the article's claims, composability is the one the thread treats as settled. MCP tool calls are atomic — you call a tool, get a result, it goes into context. CLI output can be piped through `jq`, `grep`, `head`, redirected to files. For large payloads (Terraform plans, log dumps), this is the difference between burning 100k tokens and burning 200.

`ejholmes` (author): *"Plan JSON is massive. You're not saving tokens by using a Terraform MCP and shoving an entire plan into context. Composition allows for efficient token use."*

`wenc` provides the most vivid proof-by-practice: Opus 4.6 using `duckdb` CLI to probe hundreds of GBs of Parquet in S3, writing probing queries, recovering from wrong strategies, tracing ML model predictions backwards through input data — all deterministic, all reproducible, all transparent. *"CLI tools are deterministic and transparent that way. (unlike MCPs which are black boxes)"*

No commenter successfully argues that MCP can match this. The closest attempt is `cbcoutinho` pointing to MCP Sampling as a future fix, but admits no major client supports it yet.

**3. The token budget is an architectural constraint, not a preference**

Multiple commenters identify the same mechanism: MCP tool definitions sit in context permanently, taxing every turn. `jeremyjh`: *"Reading on GH issue with MCP burns 54k tokens just to load the spec."* `SOLAR_FIELDS`: *"There is an upper bound that you hit pretty quick of how many tools you can realistically expose to an agent without adding some intermediary lookup layer."*

CLI tools sidestep this because the model already knows common tools from training data (grep, git, gh, aws, kubectl). For novel tools, `--help` is invoked on-demand, consuming tokens only when needed. Skills/AGENTS.md files load contextually. The dynamic is: MCP pays upfront and always; CLI pays incrementally and sometimes.

`sophiabits` surfaces a deeper technical point: dynamically adding tool definitions busts prompt cache, since LLMs expect tools defined at the start of the context window. This means even "lazy-loaded" MCP tools have a hidden cost.

**4. The "skills" pattern is quietly winning the middle ground**

A recurring theme: the skill/AGENTS.md pattern (markdown files describing CLI tools and workflows, loaded on demand) is doing most of what MCP promised — structured tool guidance — without the runtime overhead. `bhekanik`: *"Instead of wrestling with MCP server configs, I just write a small markdown file describing the CLI tool and its common use cases. The agent loads it on demand."*

`kaydub` has a conversion moment: *"I didn't know the skill got pulled into context ONLY for the single command being ran with the skill, I thought the skill got pulled into context and stayed there once it was called. That does seem very powerful."*

This is the pattern that OpenClaw, pi, and Claude Code's own skills system have converged on. It's not technically MCP vs CLI — it's MCP vs CLI-plus-contextual-instructions, and the latter is winning for power users.

**5. Auth is the one legitimate MCP advantage, and it's narrower than claimed**

Remote MCP with OAuth discovery (`buremba` citing Sentry's `https://mcp.sentry.dev/mcp`) is genuinely smoother than managing CLI credentials for non-technical users. Several enterprise-oriented commenters (`jngiam1`, `fastball`, `jptoor`) argue MCP's read/write permission separation is easier than building bespoke CLI permission layers.

But the counterargument is strong: `__MatrixMan__` points out *"all of the benefits of MCP over CLI go away if you just bother to run your agents as OS users with locked down permissions"* — decades of Unix permission systems exist. `nvllsvm` describes running Claude Code in Docker with SSH-proxied CLI wrappers that restrict subcommands. The auth advantage is real for consumer/enterprise chat interfaces; it evaporates for developers who already live in terminals.

**6. Sentry's David Cramer reframes the entire debate as nonsensical**

The sharpest external contribution comes from `alfozan` linking David Cramer's post. Cramer (who built Sentry's MCP server) argues the real value of MCP isn't the protocol — it's *steering the agent*. By crafting tool descriptions with USE-THIS-WHEN directives, examples, and hints, you control how the LLM approaches a problem domain. The shaped response from Sentry's MCP (structured issue summary, not raw API JSON) is the actual product.

His implicit point: the CLI-vs-MCP framing is a category error. What matters is the *information design* of what you put in context, not the transport.

**7. MCP adoption is a marketing signal that became a network effect**

`AznHisoka` cites 242% growth in MCP servers over 6 months. `lakrici88284` dismisses it as trend-chasing. But `AznHisoka` pushes back: *"even if this is just a matter of 'chasing a trend', it does have a network effect and makes the entire MCP ecosystem much more useful to consumers, which begets more MCP servers."*

`pmontra` provides the ground truth: developers asking his customer for an MCP server — no MCP, they might switch providers. MCP is becoming a checkbox on procurement due diligence. Whether that's rational or not is beside the point; it's a market force.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| CLI doesn't work for non-developers in chat UIs | **Strong** | Fundamental constraint — ChatGPT/Claude Web can't run bash. Article doesn't address this at all. |
| MCP handles auth/permissions more safely | **Medium** | True for remote services with OAuth, but Unix permissions + containers cover most developer cases. |
| CLI in production is a security nightmare | **Medium** | Valid for hosted/enterprise agents, but solvable with sandboxing (gVisor, Docker, bwrap). |
| MCP tool schemas prevent hallucinated flags | **Weak** | `--help` parsing works fine for frontier models; training data coverage is massive. |
| MCP will improve (Sampling, etc.) | **Speculative** | No major client supports advanced features yet. Betting on the come. |
| CLI tools don't have discovery | **Weak** | Skills/AGENTS.md solve this; `--help` is already standardized discovery. |

### What the Thread Misses

- **The convergence nobody names:** Skills + CLI + contextual markdown is isomorphic to what a well-designed MCP does (Cramer's point). The debate is really about runtime overhead and developer ergonomics, not capability. In 12 months, the distinction may not matter — someone will build a bridge that makes MCP tools callable as CLI and vice versa (MCPorter already exists).

- **Token economics will kill bloated MCP servers before opinions do.** As agents get more cost-conscious and context windows stay expensive, the 54k-token-per-MCP-spec problem is a death sentence for poorly designed servers. Market pressure, not blog posts, will force MCP tools to slim down or die.

- **Nobody asks whether LLMs should be calling tools at all** for some of these use cases. Half the thread's examples (JIRA ticket creation, Confluence search) are things a 10-line script could do deterministically. The tool-calling loop adds latency, tokens, and error surface for tasks that don't need inference.

- **The enterprise security argument proves too much.** If you don't trust the LLM with CLI access, why do you trust it with MCP access to the same underlying APIs? The permission boundary is the same; MCP just makes it more explicit. The real security answer is sandboxing the agent, not the protocol.

### Verdict

The thread circles a conclusion it never quite states: **MCP is a distribution and discovery protocol, not a technical superiority.** It won the enterprise checkbox and the chat-UI integration point, not the developer workflow. For terminal-native agents — which is where the most capable agentic work currently happens — CLI + skills is strictly better on every axis that matters: composability, token efficiency, debuggability, and reliability. MCP's survival depends not on technical merit but on whether chat-based agent interfaces (where CLI is impossible) remain the dominant form factor. If terminal agents keep gaining share — and OpenClaw, pi, Amp, Claude Code all suggest they will — MCP's relevance narrows to enterprise OAuth plumbing and non-developer chat integrations. A useful niche, but a far cry from "the standard for AI tools."
