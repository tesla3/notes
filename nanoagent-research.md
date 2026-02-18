# NanoAgent / Nano-Agent — Research Survey (Feb 2026)

"NanoAgent" is not one project — it's a **namespace collision** of 5+ unrelated repos sharing
the same name/idea. Each tackles a different facet of the "minimal agent" space. Here's a
thorough, critical assessment.

---

## 1. hbbio/nanoagent — TypeScript Agent Control Loop

| Stat | Value |
|------|-------|
| Stars | 57 |
| npm downloads/month | **17** |
| Language | TypeScript (Bun) |
| License | MIT |
| Created | 2025-04-27 |
| Last push | 2025-10-20 (**4 months stale**) |
| Author | Henri (co-founder @okcontract, PhD ML) |

**What it is:** A ~1 kLOC micro-framework for LLM agent loops in pure TypeScript. Zero
dependencies outside Bun. Immutable state, deterministic stepping, MCP client/server support.

**Key design ideas:**
- `AgentState` is immutable — every step returns a new snapshot (functional programming style)
- `stepAgent` = exactly one model call → one tool call → state update (deterministic)
- Built-in stuck detection (duplicate messages, empty replies)
- `Sequence` for multi-stage wizard-style workflows
- MCP integration for remote tools over HTTP

**What's genuinely good:**
- The "do one thing well" philosophy is sound. Offloading RAG, vector search, etc. to MCP
  tools and focusing only on the control loop is a clean architectural choice.
- Immutable state makes debugging and replay trivial.
- You can actually audit the entire codebase in an afternoon — the claim is real.

**Critical assessment:**
- **17 npm downloads/month** — essentially zero adoption. This is a personal project, not a
  community standard.
- **4 months without a push** — either finished or abandoned. For a framework in a fast-moving
  space, this is a red flag.
- **Bun-only** — locks out the vast majority of the Node.js ecosystem. Bun has ~5% server-side
  JS market share.
- **Only supports OpenAI-compatible and Ollama** — no Anthropic, no Google, no Bedrock.
  In 2026, that's a hard limitation.
- **No production evidence** — no case studies, no benchmark results, no known users.
- **"100x smaller than langchain"** — true but misleading. LangChain is bloated, but the
  comparison doesn't prove NanoAgent is *better*, just smaller. Size isn't the bottleneck
  for most agent developers.

**Practitioner signal:** One notable tweet from @cedric_chee: "Pi is what pushed me to start
building nanoagent. Pi SDK > Claude Agent SDK." — suggests it's a hobbyist/hacker tool
inspired by pi, not a production framework.

**Verdict:** Elegant toy. Good design principles. Zero real-world impact. If you want a
minimal TS agent loop for learning, it's a clean read. For anything else, use the AI SDK,
Vercel AI, or even pi's own SDK.

---

## 2. QuwsarOhi/NanoAgent — 135M Parameter Agentic SLM

| Stat | Value |
|------|-------|
| Stars | 29 |
| HF downloads | 379 |
| HF likes | 22 |
| Language | Python (MLX) |
| License | Apache-2.0 |
| Created | 2025-10-17 |
| Last push | 2026-02-02 |
| Base model | SmolLM2-135M-Instruct |

**What it is:** A 135M-parameter language model fine-tuned (SFT) for tool calling, instruction
following, and lightweight reasoning. Runs on CPU in ~135 MB (8-bit). Trained on an M1 Mac.

**Key innovation claim:** Teaching a tiny model to do structured tool calling — traditionally
a capability reserved for 7B+ models.

**What's genuinely interesting:**
- The *ambition* is right: if you could get reliable tool calling at 135M, that unlocks edge
  deployment (IoT, wearables, embedded systems) where no other agent model can run.
- Transparent training: full dataset list, training methodology documented, open weights.
- Found that dataset deduplication and shorter responses significantly improved performance —
  useful applied ML insight.
- GRPO (agentic RL fine-tuning) was attempted and **failed** — honest reporting.

**Critical assessment:**
- **No published benchmarks against standards.** No BFCL (Berkeley Function Call Leaderboard),
  no ToolBench, no standardized eval. Reddit commenters specifically asked for this; the author
  said "pending." Months later, still pending. This is the single biggest gap — without
  quantified evaluation, all claims are anecdotal.
- **135M is almost certainly too small for reliable tool calling.** At this scale, you get
  pattern matching on training data, not generalization. The model will work on tasks similar
  to its training set and break on anything novel. The SmolLM2-135M base doesn't even support
  tooling natively — the author is forcing a capability the architecture wasn't designed for.
- **"Runs on your watch" is marketing, not engineering.** There's no evidence of deployment on
  any wearable. Running inference on a Mac M1 is not the same as running on a Cortex-M class
  MCU. The gap is enormous.
- **Beta disclaimer is buried** — "may produce incorrect or incomplete outputs, not for
  production use." This should be the headline, not a footnote.
- **379 HF downloads** — minimal community interest.
- **Trained on M1 with 16GB** — commendable resourcefulness, but also a ceiling. The model
  is as good as what SFT on a laptop can produce, which is inherently limited.

**Practitioner signal:** Reddit r/LocalLLaMA thread had mild interest, a few commenters asked
for benchmarks (never delivered). No follow-up adoption reports.

**Verdict:** An interesting educational project that demonstrates SFT for tool calling at tiny
scale. Not usable for anything real. The lack of standardized benchmarks after months makes
the claims unverifiable. The edge/wearable angle is aspirational fiction for now.

---

## 3. disler/nano-agent — MCP Server for LLM Benchmarking

| Stat | Value |
|------|-------|
| Stars | **193** (highest of the bunch) |
| Forks | 56 |
| Language | Python |
| License | None specified |
| Created | 2025-08-10 |
| Last push | 2025-08-10 (**6 months stale, single commit?**) |
| Author | disler (YouTuber/content creator) |

**What it is:** An MCP server that lets you delegate coding tasks to different LLMs (GPT-5,
Claude, local Ollama models) and compare their agentic performance. Uses a "Higher Order
Prompt / Lower Order Prompt" (HOP/LOP) pattern.

**Key design ideas:**
- Nested agent architecture: Claude Code (or any MCP client) spawns sub-agents on different
  models to run the same task.
- Unified multi-provider interface: OpenAI, Anthropic, Ollama all behind one tool.
- Comparative benchmarking: run 9 models in parallel, compare results.

**What's genuinely good:**
- The *idea* of standardized agentic benchmarking across providers is valuable.
- YouTube demos show real results — GPT-5 Nano/Mini surprisingly competitive, local models
  viable for simple tasks.
- Practical finding: "Claude Opus 4.1 is extraordinarily expensive — performance isn't
  everything." This is useful practitioner wisdom.

**Critical assessment:**
- **Created and last pushed on the same day (2025-08-10).** This appears to be a content
  creation artifact — built for a YouTube video, not a maintained tool.
- **No license** — legally unusable for any serious purpose.
- **193 stars likely from YouTube audience**, not organic developer adoption. Stars from
  content creators correlate with video views, not project quality.
- **The HOP/LOP pattern is just prompt engineering dressed up with jargon.** It's "use a
  smart model to evaluate a less smart model" — not novel.
- **No systematic benchmark methodology.** The "findings" are anecdotal from a few runs,
  not statistically rigorous evaluations. No error bars, no repeated trials, no controlled
  variables.
- **6 months stale** — abandoned after the video.

**Verdict:** A YouTube demo project with good production value. The 193 stars reflect content
marketing, not technical merit. Useful as inspiration for setting up your own multi-model
evaluation, but not as a tool to adopt.

---

## 4. ASSERT-KTH/nano-agent — Minimal Coding Agent for RL Research

| Stat | Value |
|------|-------|
| Stars | 4 |
| Language | Python |
| License | None specified |
| Created | 2025-05-04 |
| Last push | 2026-01-16 |
| Author | Bjarni Haukur (KTH ASSERT lab) |

**What it is:** A zero-bloat coding agent with exactly 2 tools: `shell(cmd)` and
`apply_patch({...})`. Designed explicitly for agent-in-the-loop reinforcement learning.

**Key innovation — and this is the genuinely novel one:**
- **The Bitter Lesson applied to coding agents.** The explicit thesis: most coding agents
  (Aider, SWE-Agent, Devin) bake in hand-crafted heuristics (repo maps, retry logic, memory).
  These make agents *capable* but *opaque*. Nano strips all that away so the model's raw
  behavior is observable and can be reinforced.
- **Clean RL integration:** Produces unaltered interaction logs that feed directly into
  TRL's GRPOTrainer. The messages/tools are already in the right format for tokenization
  and reward modeling.
- **SWE-bench integration** built in — can run against real GitHub issues.
- Uses `rbash` (restricted bash) for sandboxing — simple, effective.

**What's genuinely good:**
- The *intellectual framework* is the strongest of all five projects. The argument that
  hand-crafted agent scaffolding is the wrong long-term bet, and that RL on minimal agents
  is the right path, is a defensible and interesting research position.
- Has a HuggingFace TRL fork with direct agent integration — shows actual research work.
- Actively maintained (pushed Jan 2026).
- From KTH's ASSERT lab — reputable software testing research group.

**Critical assessment:**
- **4 stars.** Almost invisible.
- **No published results.** No paper, no SWE-bench scores, no RL training curves. The
  research thesis is compelling but entirely unvalidated publicly.
- **No license** — can't even legally use it.
- **The Bitter Lesson argument has limits.** Rich Sutton's point was about *compute scaling*,
  not about removing all engineering. A model that needs 10x more training to discover what
  a repo map gives you for free isn't necessarily better — it's just more expensive. The
  bitter lesson says "scale eventually wins," not "start with nothing today."
- **Two tools is too few for real-world coding.** No file listing, no search, no tree view.
  The model has to `shell("find . -name '*.py'")` for everything — burning context and
  tool calls on what better agents give for free.

**Verdict:** The most intellectually interesting project in this set, but also the least
validated. A research bet that RL on minimal agents will outperform hand-crafted ones.
Worth watching if/when they publish results. Today: an unproven hypothesis with clean code.

---

## 5. NTT123/nano-agent — DAG-based Python Agent Library

| Stat | Value |
|------|-------|
| Stars | 9 |
| Language | Python |
| License | None |
| Created | 2026-01-25 |
| Last push | 2026-02-10 |
| Author | NTT123 |

**What it is:** A minimalistic Python agent library using an immutable DAG (directed acyclic
graph) for conversation flow. Includes a CLI (`nano-cli`), a Discord bot, and multi-provider
support (Claude, Gemini).

**Key design idea:** Conversations are graphs, not lists. Every message is a node in a DAG.
Branch for parallel tool execution, merge for results. Immutable — every operation returns
a new DAG.

**What's genuinely good:**
- The DAG conversation model is actually a more correct abstraction than the flat message
  list most frameworks use. Parallel tool calls naturally branch, and you can visualize the
  full execution graph.
- Built-in tools (Bash, Read, Write, Edit, Glob, Grep) — usable out of the box as a
  coding agent.
- Discord bot integration is practical.
- Uses Claude Code OAuth — creative hack for auth.

**Critical assessment:**
- **9 stars, 3 weeks old.** Too early to evaluate impact.
- **No license** — a recurring theme in this space.
- **Claude Code OAuth capture is a hack**, not a supported auth method. Could break at any
  time.
- **DAG model adds complexity** — for most use cases, a flat message list with tool call
  IDs is sufficient. The graph model is more correct in theory but whether it produces
  better outcomes in practice is undemonstrated.

**Verdict:** Very new. The DAG model is the most architecturally interesting idea here but
has zero validation. Check back in 6 months.

---

## Cross-Cutting Analysis

### Why So Many "Nano" Agents?

There's a clear cultural moment: developers are frustrated with LangChain's bloat, Semantic
Kernel's enterprise verbosity, and CrewAI's abstraction layers. The "nano" prefix signals
rebellion against complexity. But rebellion alone doesn't produce good tools — most of these
projects solve the *complexity problem* without solving the *capability problem*.

### The "Minimal Agent" Trap

Every one of these projects pitches minimalism as the key value prop. But minimalism is a
**means**, not an **end**. Users need agents that *work* — that means error recovery, context
management, provider abstraction, streaming, cost tracking, sandboxing. Stripping these out
makes for cleaner code but worse outcomes. The winning agent frameworks in 2026 (Claude Code,
Cursor, pi, Aider) are complex because the problem is complex.

### What's Actually Novel Across All Five?

1. **Immutable agent state** (hbbio, NTT123) — good idea, underexplored. Makes replay,
   debugging, and checkpointing trivial. Should be a feature in major frameworks, not a
   standalone project.
2. **Agentic RL on minimal agents** (ASSERT-KTH) — the most intellectually honest project.
   If it delivers published results, it could influence how future models are trained for
   tool use.
3. **135M tool-calling** (QuwsarOhi) — interesting existence proof, but needs benchmarks to
   matter.
4. **DAG conversations** (NTT123) — more correct than flat lists, but unvalidated.
5. **Multi-model agentic benchmarking** (disler) — the need is real, the execution is a
   YouTube demo.

### Actual Impact (Feb 2026)

**Near zero.** Combined stars across all 5 repos: ~292. Combined real-world deployments: 0
documented. Combined peer-reviewed publications: 0. These are hobbyist, educational, and
early-research projects. None has influenced the mainstream agent ecosystem.

### Who Should Care?

- **Learners**: hbbio/nanoagent is a genuinely clean codebase to study agent loop design.
- **Researchers**: ASSERT-KTH/nano-agent is worth watching for the RL angle.
- **Edge ML enthusiasts**: QuwsarOhi/NanoAgent is interesting if they ever publish benchmarks.
- **Practitioners building production agents**: None of these. Use established tools.

---

## Summary Table

| Repo | Type | Stars | Innovation | Validation | Impact |
|------|------|-------|-----------|------------|--------|
| hbbio/nanoagent | TS framework | 57 | Immutable state + MCP-only | None | Zero |
| QuwsarOhi/NanoAgent | 135M SLM | 29 | Tiny tool-calling model | No benchmarks | Zero |
| disler/nano-agent | MCP benchmark | 193 | Multi-model eval | Anecdotal | YouTube only |
| ASSERT-KTH/nano-agent | RL research | 4 | Bitter Lesson for agents | No published results | Zero (yet) |
| NTT123/nano-agent | DAG agent lib | 9 | Graph conversation model | Too new | Zero |
