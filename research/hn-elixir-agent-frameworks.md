← [Coding Agents](../topics/coding-agents.md) · [Index](../README.md)

## HN Thread Distillation: "What years of production-grade concurrency teaches us about building AI agents"

**Source:** [HN thread](https://news.ycombinator.com/item?id=47067395) (136 points, 50 comments) · [Article](https://georgeguimaraes.com/your-agent-orchestrator-is-just-a-bad-clone-of-elixir/) · Feb 18, 2026

**Article summary:** George Guimarães (ex-Plataformatec, Nubank) argues that Python AI agent frameworks are reinventing BEAM/Erlang primitives — isolated processes, message passing, supervision trees, fault recovery — in languages not designed for them. Claims BEAM is the natural runtime for agent workloads: thousands of concurrent stateful sessions, non-deterministic failures, hot code swapping. Acknowledges ecosystem gaps in tooling and testability but says they're closing.

### Dominant Sentiment: Sympathetic but unconvinced on practicality

The thread broadly agrees with the architectural argument — actors map well to agents — but practitioners who've actually run BEAM in production surface real gaps the article glosses over. The enthusiasm gradient runs inverse to experience: the most excited commenter ([znnajdla]) is a recent convert; the most measured ([randomtoast], [mackross]) have shipped large OTP systems.

### Key Insights

**1. The article's strongest evidence undermines its own conclusion**

The convergence table — showing LangGraph, CrewAI, AutoGen, and Langroid all independently arriving at actor-like patterns — is presented as proof you should use the BEAM. But it actually proves the opposite: if four teams independently build adequate actor abstractions in Python, that suggests the pattern is implementable at the application layer without runtime support. The question isn't whether BEAM is architecturally superior (it is). It's whether the superiority is *decisive* for a workload that's 95% I/O-bound API calls. [randomtoast], who's built "fairly large OTP systems," draws the line clearly: "If you are mostly gluing API calls together for a few thousand users, the runtime differences are less decisive than the surrounding tooling and hiring pool."

**2. "Let it crash" has a semantic gap for agents that telecom doesn't have**

This is the thread's sharpest insight, surfaced by [veunes] and [quadruple] from different angles. In telecom, restarting a crashed process in clean state is fine — a new dial tone is identical to the old one. For AI agents, "clean state" means *lost conversation context*. [quadruple]: "If the LLM API returns an error because the conversation is too long, I want to run compacting or other context engineering strategies, I don't want to restart the process." [veunes] coins a useful concept: "We need Semantic Supervision Trees that can change strategy on restart. BEAM doesn't give this out of the box." The rebuttal from [znnajdla] — that you can model failure states declaratively — is technically correct but concedes the point: you're writing custom state management anyway, which is exactly what Python frameworks do with try/except.

**3. Durability is the elephant BEAM advocates won't name**

[mackross], self-described "huge elixir fan," delivers the most damaging critique: "BEAM fanboys sweep durable execution under the rug." ETS and supervision trees don't survive deployment restarts. For agents that run for minutes or hours, you need persistence to a database regardless of runtime. "Whatever you choose, you will need to spend a fair amount of time considering how your processes are going to survive restarts." This collapses the simplicity argument — if you're bolting on Oban or rolling your own persistence layer, the gap to Python + Celery + Postgres narrows considerably.

**4. The real moat isn't the runtime — it's the ecosystem**

Nobody in the thread says this explicitly, but it's the structural reason Elixir won't capture the agent market despite being architecturally better. Every LLM provider ships a Python SDK first. Every evaluation framework (RAGAS, DeepEval, LMSYS) is Python. Every ML library, every embedding model, every vector DB client is Python-first. The article acknowledges ecosystem gaps and points to Elixir's LangChain, Jido, and Bumblebee — but these are small community projects trailing years behind Python equivalents. [fud101] touches this obliquely: "you have to have a real reason to buy into such a monster that you couldn't do with a simpler stack." The reason to choose Elixir would need to be overwhelming enough to outweigh the ecosystem tax, and for most teams it isn't.

**5. The author's 70/30 split is the most honest claim in the article — and it defeats his thesis**

"You can get about 70% there with enough engineering. The remaining 30% (preemptive scheduling, per-process GC, hot code swapping, true fault isolation) requires runtime-level support." This is accurate. But for the vast majority of agent deployments — which are sub-1000 concurrent sessions calling external APIs — 70% is enough. The 30% matters at WhatsApp/Discord scale. The number of teams building agent systems at that scale who don't already have strong infrastructure opinions is approximately zero.

**6. One accusation worth noting: AI-generated content**

[walletdrainer]: "Every single post on this blog is AI generated spam." The article does have structural tells — perfect progression, neat tables, "The uncomfortable truth" framing — but the author cites specific personal experience (Plataformatec, Nubank fintech) and the technical arguments have real substance. More likely AI-assisted than AI-generated. The meta-irony of an article about AI agent infrastructure potentially being written by an AI agent did not escape notice.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Agents are I/O bound, scheduling model doesn't matter" | Strong | [randomtoast], [mccoyb] — if 95% of time is waiting on API calls, preemptive scheduling is irrelevant |
| "Let it crash" loses conversation context | Strong | [veunes], [quadruple] — semantic gap between telecom and LLM sessions |
| BEAM doesn't solve durable execution | Strong | [mackross] — state evaporates on deploy/restart, need persistence layer anyway |
| OS threads are fine for this scale | Medium | [kibwen] — modern Linux handles thousands of threads; [mccoyb] — "I don't believe this matters" |
| Elixir tooling is too heavy | Weak | [fud101] — "can't dev on N100 minipc" is a niche complaint |

### What the Thread Misses

- **The actor model vs. state machine distinction matters.** The article conflates them. Agents don't need message-passing between isolated processes as much as they need durable state machines with rich failure semantics. Temporal.io, not Erlang, may be the better analogy — and [mackross] wishes it existed for Elixir.
- **Nobody asks who the article is actually for.** Teams choosing agent infrastructure in 2026 are either (a) startups that need to ship fast (Python wins on ecosystem), (b) enterprises with existing infrastructure commitments (Java/Go/TypeScript wins on integration), or (c) scale-out platforms like WhatsApp/Discord (already on BEAM or equivalent). There's no large unclaimed market segment that would adopt Elixir for agents.
- **The "Python frameworks are reinventing Erlang" framing ignores that reinvention is cheap.** Building actor-like abstractions in Python took relatively small teams relatively little time. The Python versions are "worse" architecturally but "good enough" practically, and they get the entire ML ecosystem for free.

### Verdict

The article is a well-constructed argument for a conclusion the market has already rejected. BEAM *is* architecturally superior for concurrent, stateful, fault-prone workloads — the thread doesn't seriously contest this. But the thread reveals (without stating) why it doesn't matter: **the agent infrastructure problem is being solved at the wrong layer for Elixir to win.** The hard problems in 2026 aren't process isolation and preemptive scheduling — they're durable execution, semantic error recovery, and ecosystem integration. BEAM solves the 1986 version of the problem brilliantly. The 2026 version needs Temporal-style durability, LLM-aware failure semantics, and Python-ecosystem compatibility — none of which are BEAM strengths.
