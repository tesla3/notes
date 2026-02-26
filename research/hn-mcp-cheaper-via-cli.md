← [Index](../README.md)

## HN Thread Distillation: "Making MCP cheaper via CLI"

- **HN:** https://news.ycombinator.com/item?id=47157398
- **Article:** https://kanyilmaz.me/2026/02/23/cli-vs-mcp.html
- **Score:** 161 · 76 comments · 54 unique authors
- **Date:** 2026-02-25

**Article summary:** The author argues that MCP's approach of dumping full JSON schemas into context is token-wasteful (~15.5K tokens for 84 tools), while CLI equivalents using lazy `--help` discovery cost ~94% less. He built CLIHub, a converter that compiles MCP servers into standalone CLI binaries. The article also benchmarks against Anthropic's Tool Search and claims CLI still wins by 74–88%.

### Dominant Sentiment: CLI vindication, MCP fatigue

The thread leans strongly pro-CLI, but the interesting commenters don't care about the article's token arithmetic — they're reaching for deeper arguments about composability, training data advantages, and what MCP actually contributes. The few MCP defenders make weak structural arguments ("just don't load everything") that get swatted down.

### Key Insights

**1. Composability is the real CLI advantage, not token savings**

The article fixates on token counts, but the thread's sharpest commenters identify a different mechanism entirely. `martinald`: "Imagine you want to sum the total of say 150 order IDs (and the API behind the scenes only allows one ID per API calls). With MCP the agent would have to do 150 tool calls and explode your context. With CLIs the agent can write a for loop… in *one tool call*." `_pdp_` makes the same point: "Coding assistant will typically pipe the tool in jq or tail to process the data chunk by chunk because this is how they are trained these days."

This is the argument the article should have led with. Token savings on schema loading are a one-time cost; composability savings compound across every multi-step workflow.

**2. Models are RL-trained on shell — CLI gets a free accuracy boost**

`cmdtab` drops the thread's most empirically grounded claim: "Even the smallest models are RL trained to use shell commands perfectly. Gemini 3 flash performs better with a cli with 20 commands vs 20+ tools in my testing." He also notes CLI preserves KV cache better than swapping tool definitions, and that models can "compose a giant command sequence to one shot task" — something tool-call protocols structurally prevent.

This is non-obvious and underreported. CLI isn't just a cheaper transport; it maps onto a capability models already have baked into their weights. MCP's JSON-RPC tool-call format is learned only through fine-tuning on tool-use datasets, which are smaller and less diverse than the shell-command corpus.

**3. Cumulative conversation re-sending dwarfs schema cost — and CLI doesn't fix it**

`OsrsNeedsf2P` delivers the strongest structural counterpoint: "The real killer is the input tokens on each step. If you have 100k tokens in the conversation, and the LLM calls an MCP tool, the output *and the existing* conversation is sent back… Now imagine 10 tool calls per user message — or 50. You're sending 1-5M input tokens." He reports cache hit rates as low as 40% in production.

This partially undermines the article's thesis. If schema overhead is ~15K tokens but conversation re-sending costs millions, optimizing the schema is polishing the wrong knob. CLI's composability (insight #1) *does* help here — fewer round-trips means fewer re-sends — but the article doesn't make this connection.

**4. MCP's actual contribution is auth, and CLI fragments it**

`crazylogger`: "MCP is a thin toolcall auth layer that has to be there so that ChatGPT and claude.ai can 'connect to your Slack.'" `martinald`: "MCP defines a consistent authentication protocol. This is the real issue with CLIs, each CLI can (and will) have a different way of handling authentication." The author himself admits "mainly oauth is the blocker since that logic needs to be custom implemented to the CLI."

The thread surfaces a real tension: CLI wins on execution but loses on auth standardization. CLIHub's answer (supporting OAuth2/PKCE/etc.) is essentially rebuilding MCP's auth layer inside each binary. Whether that's elegant or redundant depends on your perspective.

**5. Everyone is converging on the same pattern from different directions**

Anthropic's Tool Search, Cloudflare's Code Mode (search + execute two-tool pattern), Skills' progressive disclosure, and CLI's `--help` lazy loading are all implementations of the same idea: don't load tool definitions until you need them, and let the agent decide what to load. `philfreo` points this out directly, citing Skills' specification for progressive disclosure. `eggplantiny` tries to abstract further to "normalized semantic primitives" but `TeMPOraL` correctly notes that shell already provides this: "`cat`, `grep` and pipes and redirects may not be semantically pure, but they're pretty close to universal."

Nobody names the converged pattern explicitly: **deferred schema resolution with agent-driven discovery**. The debate isn't "CLI vs MCP" — it's push vs. pull for tool metadata. Every serious implementation has landed on pull.

**6. "You reinvented Skills" — and the author's defense is weak**

`jbellis`: "You just reinvented Skills." The author's response — "I don't prefer to use online skills where half has malware. Official MCPs are trusted." — is a non-sequitur. Skills are a protocol pattern (progressive disclosure of CLI tools), not a package registry. The article's actual contribution is the MCP-to-CLI compiler, not the lazy-loading concept, but it's marketed as an insight about architecture.

**7. The Cloudflare Code Mode approach may leapfrog both**

Cloudflare's Code Mode collapses the entire API surface to two tools (search + execute) at ~1,000 tokens, achieving 99.9% reduction for their 2,500-endpoint API. The agent writes JavaScript against the OpenAPI spec rather than learning individual tool schemas. `aceelric` built CMCP using the same pattern. This is structurally superior to both MCP's schema dumping *and* CLI's `--help` approach because it eliminates per-tool overhead entirely — the agent discovers and invokes through code in a sandbox.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Just don't load all 84 tools" (`eongchen`) | Weak | "You're holding it wrong." Doesn't address the protocol's default behavior or that most MCP clients don't filter. |
| "Prompt caching makes schema cost negligible" (`kanodiaayush`) | Medium | Partially true for single-provider setups, but OsrsNeedsf2P reports 40% cache hit rates in production. |
| "Tool Search already solves this" (`philfreo`) | Strong | Correct, but Anthropic-only. CLI is vendor-neutral. |
| "CLI auth is fragmented" (`martinald`) | Strong | Real unsolved problem. CLIHub rebuilds auth per-binary, which doesn't scale. |

### What the Thread Misses

- **Security model regression.** CLI turns every LLM into a shell agent. MCP at least has a permission model and sandboxed tool execution. Nobody discusses that giving an agent `notion --help` also gives it `rm -rf` unless you build a separate allowlist. The thread celebrates "the Unix way" without acknowledging that Unix's permission model wasn't designed for untrusted AI executors.
- **Training data dependency.** CLI's accuracy advantage (insight #2) exists because models were trained on shell commands. This means CLI's superiority is contingent on training data, not protocol design. If labs started training heavily on MCP tool-call traces, the gap would close. Nobody frames it this way.
- **The MCP-to-CLI pipeline is a transitional hack.** If the converged answer is deferred schema resolution, the clean solution is fixing MCP clients to do lazy loading (which Tool Search and Code Mode already do), not maintaining a parallel CLI binary for every MCP server. CLIHub is useful today but architecturally temporary.

### Verdict

The thread circles an insight it never quite lands: **the CLI advantage isn't the CLI itself — it's that shell is the largest, most battle-tested "tool use" dataset in LLM training**. Models don't need JSON Schema to understand `grep`; they need it for `notion-search` because `notion-search` doesn't exist in their pretraining. The real question is whether to bring tools to the model's existing competence (CLI) or bring the model's competence to the tools (better fine-tuning on MCP traces). The industry is currently choosing the former because it's cheaper and works now, but the long-term winner is whoever makes deferred discovery a first-class protocol feature — which Anthropic and Cloudflare are already doing. CLIHub is a well-executed bridge solution for the gap between MCP's current defaults and the lazy-loading future everyone agrees on.
