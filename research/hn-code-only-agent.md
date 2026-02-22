← [Index](../README.md)

## HN Thread Distillation: "The Code-Only Agent"

**Source:** [rijnard.com/blog/the-code-only-agent](https://rijnard.com/blog/the-code-only-agent) (Jan 2026) · [HN thread](https://news.ycombinator.com/item?id=46674416) (155 pts, 68 comments, 52 unique authors)

**Article summary:** Proposes giving AI agents exactly one tool — `execute_code` — instead of bash, ls, grep, etc. The agent must write Python (or any language) for every action. The author frames the output as a "code witness" with "semantic guarantees" grounded in language runtime semantics, invokes the Curry-Howard correspondence (programs as proofs), and positions this as "the only way forward for computable things." Ships as a Claude Code plugin.

**Article critique:** The core insight — that code artifacts are reviewable, reusable, and composable in ways ephemeral tool calls aren't — is sound and well-supported by Ronacher's earlier "Tools: Code Is All You Need" (Jul 2025). But the article buries it under philosophical overreach. Invoking Curry-Howard for Python subprocess wrappers is a category error (Python has no type-level guarantees the correspondence requires), and "fully trustworthy" is unearned. More critically, it fails to cite CodeAct (Wang et al., ICML 2024), which formalized this exact paradigm with empirical evaluation across 17 LLMs. Independent rediscovery dressed in heavier theory than the evidence supports.

### Dominant Sentiment: Intrigued but unconvinced

The thread splits roughly 40/40/20: practitioners who've tried code-only and find it promising, skeptics who see unnecessary indirection, and a smaller group pointing out this isn't new. Energy is higher than typical for an agent-architecture post — people have strong opinions because they've tried variants themselves.

### Key Insights

**1. The agent-as-toolmaker pattern is the real story, not code-only execution**

binalpatel describes the most complete working system in the thread: an agent that creates persistent CLIs, reuses them across sessions, and lets the human use the same CLIs as a side channel. The pattern — ask → agent can't do it → agent builds a tool → tool persists → agent and human share the tool — is more interesting than the article's thesis because it produces *durable artifacts that compound*, not just ephemeral code witnesses. fudged71 claims "1000 skills by end of this week arranged in an evolving DAG," citing a 2026 paper on Evolving Programmatic Skill Networks. The convergence is clear: multiple practitioners independently arriving at self-tooling agents.

> binalpatel: "Each interaction results in updated/improved toolkits for the things you ask it for. You as the user can use all these CLIs as well which ends up an interesting side-channel way of interacting with the agent."

**2. The "code witness" is often a subprocess wrapper — adding failure modes, not guarantees**

iepathos delivers the thread's sharpest technical critique. In practice, the code-only agent doesn't replace ripgrep with a pure Python implementation; it writes `subprocess.run(["rg", ...])`. You get the same underlying tool call plus encoding bugs, exit code mishandling, and stderr parsing failures. The "semantic guarantee" of the wrapper is strictly weaker than the tool it wraps. This isn't a theoretical objection — it's what actually happens when you run these systems.

> iepathos: "You're now trusting both the tool AND the generated wrapper... the generated wrapper doesn't provide stronger semantics than rg alone, it actually provides strictly weaker ones."

**3. The rollback argument is the strongest case for code-only — and nobody fully develops it**

znnajdla (appearing 5 times in the thread, consistently the best defender of the concept) identifies the real value proposition: atomicity and reversibility. A series of tool calls creates intermediate state that's hard to roll back. A single code block either succeeds from clean state or doesn't, and you can re-run it. This reframes the debate from "code vs. tools" to "what granularity should agent actions be atomic at?" The article gestures at this but never names it directly. znnajdla does:

> znnajdla: "It's hard to rollback a series of tool calls. It's easier to revert state and rerun a complete piece of code until you get the desired result."

**4. Self-tooling agents reconverge on something like MCP**

j16sdiz makes an elegant structural argument: if code-only agents create tools, those tools need persistence, sharing, cross-session discovery, and a common protocol — and you've just reinvented MCP. throwup238 recalls a paper where agents search existing tools via embeddings before creating new ones. kbdiaz links to Voyager (2023), which did exactly this in Minecraft. The pattern is: start minimal → agent builds tools → tools need management → you need infrastructure → you're back at a tool ecosystem. The question isn't whether this happens, but whether the intermediate "build your own tools" phase produces better tools than hand-curated ones.

**5. Model efficiency vs. artifact quality is the real tradeoff, and nobody has data**

killerstorm argues that tool-use is baked into model weights — forcing code generation wastes capacity the model could spend on the actual problem. meander_water asks about token costs. Nobody provides numbers. rcarmo's linked blog post offers the closest thing to evidence: MCP workflows with smaller models (Haiku) outperform skills/code-only approaches with frontier models for multi-step tasks, because MCP constrains the action space and provides next-step prompting. This suggests code-only may be a luxury of frontier model capability that doesn't scale down.

**6. Prior art erasure: CodeAct exists and the thread mostly ignores it**

tucnak's frustrated comment — "Ctrl+F CodeAct. No hits." — points at a real problem. CodeAct (Feb 2024, ICML) formalized executable Python as a unified action space, benchmarked it against JSON/text tool-call formats across 17 LLMs, and showed substantial improvements. The article's "Further Reading" lists 8 sources, none of which are the actual academic paper that established the paradigm. alexsmirnov notes HuggingFace's smolagents implemented this "far ago," and river_otter reports that by late 2025, a small set of flexible tools was outperforming the single-tool approach.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Code-only just wraps subprocess calls, adding failure modes | **Strong** | iepathos. Empirically true for filesystem/search operations. |
| Battle-tested tools > generated wrappers | **Strong** | mkw5053, ray_v. Unix philosophy argument — decades of hardened code thrown away. |
| Tool-use is in model weights; code-only wastes capacity | **Medium** | killerstorm. Plausible but no one provides benchmarks. |
| Self-built tools reconverge on MCP-like infrastructure | **Strong** | j16sdiz. Structurally inevitable once tools need persistence/sharing. |
| This was solved by CodeAct in 2024 | **Strong** | tucnak, alexsmirnov. Article fails to cite key prior work. |
| Bash is also Turing-complete; distinction is arbitrary | **Weak-Medium** | jebarker, ray_v. Misses the atomicity/reproducibility point znnajdla makes — a bash *script* is code-only; sequential bash *tool calls* are not. |

### What the Thread Misses

- **The training data angle.** Cloudflare's Code Mode article (cited by the author but not discussed in thread) identifies the deepest reason code-only works: LLMs are trained on vastly more code than tool-call formats. Code generation is in the sweet spot of the training distribution. This isn't about philosophical guarantees — it's about where the model's probability mass concentrates.

- **The granularity question.** Everyone debates "code vs. tools" as binary. The actual design parameter is action atomicity: how much work should one agent step encompass? Code-only forces coarse-grained steps (write a whole script). Fine-grained tools allow incremental exploration. The optimal granularity likely varies by task type and is learnable, not fixed.

- **Self-tooling agents are reinventing package ecosystems.** binalpatel's agent builds CLIs; fudged71 has a DAG of skills; throwup238 describes embedding-based tool search. This is the early-stage equivalent of npm/pip emerging — tool discovery, versioning, dependency management. Nobody in the thread names this trajectory, but it's where self-tooling inevitably leads.

- **The formal verification claim is hand-waving.** The article invokes Lean and Curry-Howard as aspirational directions. The distance between "Python script that calls subprocess" and "formal proof in Lean" is roughly the distance between a napkin sketch and an architectural blueprint. Nobody in the thread pushes back on this specifically, perhaps because it's too obviously aspirational to engage with.

### Verdict

The code-only agent is a rediscovery of CodeAct dressed in stronger theoretical claims than the evidence supports, but the practitioners in the thread — particularly binalpatel and znnajdla — articulate something the article doesn't: the value isn't in "code witnesses" or "semantic guarantees," it's in *artifact durability*. Tool calls evaporate; scripts persist, compound, and become shared infrastructure. The thread circles this insight without stating it cleanly. What's actually emerging isn't a "code-only" paradigm but a *self-tooling* paradigm where agents bootstrap their own tool ecosystems — and the interesting open question isn't whether to use code or tools, but how to manage the lifecycle of agent-generated tools once they start accumulating faster than humans can review them.
