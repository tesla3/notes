← [Index](../README.md)

# Rig: Critical Review & Comparative Analysis

*Date: 2026-03-01*
*Source: github.com/0xPlaygrounds/rig (cloned locally, source-level review)*

## What It Is

Rig is a **Rust library for building LLM-powered applications**, focused on ergonomics and modularity. Created by **Playgrounds Analytics** (0xPlaygrounds), it provides a unified interface across 20+ model providers and 10+ vector stores. At **v0.31.0**, MIT-licensed, ~98K lines of Rust across the workspace (~54K in rig-core), 911 commits over ~21 months (May 2024–March 2026), 169 unique contributors. Positioned as the Rust ecosystem's answer to LangChain/LlamaIndex — but as a *library*, not a framework.

---

## Architecture: What Rig Actually Is

Rig is a **provider abstraction layer with agent ergonomics bolted on top**. The core architecture is straightforward:

| Layer | What It Does | Key Types |
|-------|-------------|-----------|
| **Client** | HTTP client with auth, retry, SSE parsing | `Client<Ext, H>`, `ProviderClient` |
| **Completion** | Unified request/response across providers | `CompletionModel`, `CompletionRequest`, `CompletionRequestBuilder` |
| **Agent** | High-level wrapper: preamble + context + tools + model | `Agent<M, P>`, `AgentBuilder` |
| **Tool** | Tool definition, execution, MCP integration | `Tool`, `ToolSet`, `ToolServer` |
| **Vector Store** | Embedding storage, similarity search | `VectorStoreIndex`, `InsertDocuments` |
| **Streaming** | Token-by-token streaming with pause/abort | `StreamingPrompt`, `StreamingChat` |
| **Pipeline** | Composable operation DAG | `Op`, `TryOp`, `parallel!` |
| **Extractor** | Structured data extraction via JSON schema | `Extractor<M, T>` |

The **trait hierarchy** is the real architecture:

```
CompletionModel (provider implements this)
  → Completion (low-level request builder)
    → Prompt (one-shot: prompt → string)
    → Chat (multi-turn: prompt + history → string)
    → TypedPrompt (prompt → deserialized struct)
    → StreamingPrompt / StreamingChat (streaming variants)
```

This is clean. A provider only needs to implement `CompletionModel` (and optionally `EmbeddingModel`), and gets the entire agent/streaming/extraction stack for free. The builder pattern on `Agent` is well-designed — typestate prevents mixing tool configuration approaches.

---

## What's Genuinely Good

### 1. The Abstraction Layer Is Well-Designed
The `CompletionModel` trait is minimal (3 required methods: `make`, `completion`, `stream`) and the `CompletionRequest` struct is provider-agnostic. This means switching from OpenAI to Anthropic to Gemini is genuinely a one-line change. The request builder pattern with method chaining is idiomatic Rust. This is the core value proposition, and it delivers.

### 2. Provider Coverage Is Exceptional
20+ providers in core alone: OpenAI, Anthropic, Gemini, Cohere, DeepSeek, Groq, Ollama, OpenRouter, Mistral, HuggingFace, xAI, Hyperbolic, Mira, Moonshot, Galadriel, Perplexity, VoyageAI, Together, Azure. Plus external crates for Bedrock, VertexAI, Fastembed, EternalAI. This is the widest Rust provider coverage available.

### 3. Vector Store Breadth
10 vector store integrations (MongoDB, LanceDB, Neo4j, Qdrant, SQLite, SurrealDB, Milvus, ScyllaDB, S3Vectors, HelixDB, Postgres) plus an in-memory store. The `VectorStoreIndex` trait with generic filter types is reasonably clean. Each integration is a separate crate — good dependency isolation.

### 4. WASM Compatibility
The `wasm_compat` module with `WasmCompatSend`/`WasmCompatSync` traits that conditionally require `Send`/`Sync` based on target is clever. CI checks WASM compilation. This enables browser-based LLM apps in Rust — a genuine differentiator vs. Python frameworks.

### 5. Streaming Is First-Class
Multi-turn streaming with tool calls, pause/resume control, abort handles, and hook integration. The `MultiTurnStreamItem` enum cleanly separates text deltas, tool call deltas, reasoning deltas, and final responses. This is production-quality streaming infrastructure.

### 6. Hook System
The `PromptHook` trait provides interception points at every stage: before/after completion calls, before/after tool calls, on text deltas, on tool call deltas. Hooks can continue, skip tool calls (with reason fed back to LLM), or terminate loops. This is genuinely useful for logging, approval workflows, cost controls, and guardrails.

### 7. OpenTelemetry Integration
Full GenAI Semantic Convention support with `SpanCombinator` trait. The telemetry module records `gen_ai.usage.input_tokens`, `gen_ai.response.id`, etc. per the OpenTelemetry spec. Several examples show Langfuse integration. Observability as a first-class concern.

### 8. MIT License
No commercial restrictions. Period.

---

## Critical Weaknesses

### 1. Testing Is Inadequate for a Library of This Scope
- **345 `#[test]`** + **91 `#[tokio::test]`** across rig-core's 54K LOC = ~1 test per 124 lines
- **7 test files** in rig-core's `tests/` directory (2,391 LOC total)
- **111 tests** across all integration crates
- CI requires **live API keys** (OpenAI, Anthropic, Gemini, Cohere, Perplexity) — the test suite cannot run without paid credentials
- No mocked provider tests. Zero. Every provider interaction test hits a real API.
- The integration tests for vector stores require running databases (testcontainers)

For a library that 15+ companies depend on (per README), the test coverage is alarmingly thin. The provider implementations — which are the most complex and failure-prone code (OpenRouter completion alone is 3,243 lines) — are effectively tested only by running examples against live APIs. A malformed SSE response, an unexpected JSON field, a rate limit edge case — none of these have dedicated test coverage.

### 2. Provider Code Is Bloated and Duplicative
The four largest provider files:
- `openrouter/completion.rs`: 3,243 lines
- `gemini/completion.rs`: 2,551 lines
- `anthropic/completion.rs`: 2,068 lines
- `openai/completion/mod.rs`: 1,461 lines

Each provider re-implements response parsing, error handling, streaming chunk assembly, tool call extraction, and reasoning trace handling. The OpenAI-compatible providers (OpenRouter, DeepSeek, Groq, Hyperbolic, Together, Moonshot) should share a common base — but don't. There's significant structural duplication. When a streaming bug is found in one provider, it must be checked and fixed across 20+ implementations.

### 3. Panics in Production Code Paths
156 `panic!` calls in rig-core source (excluding tests). Notable:
- **MCP tool handler**: `panic!("Support for audio results from an MCP tool is currently unimplemented. Come back later!")` and `panic!("Unsupported type found: {thing:?}")` — these are in the live tool execution path. An MCP server returning an audio result will crash the application.
- **Cohere streaming**: 5 panics in streaming chunk parsing
- **Gemini completion**: 15+ panics in response deserialization helpers

422 `unwrap()` calls in non-test code. While many are in serialization paths where failure is "impossible," the sheer volume suggests insufficient attention to error propagation. For a library, panics are unacceptable — they crash the caller's application with no recourse.

### 4. No Memory / State Management
Rig has **zero built-in memory**. The `Agent` struct holds no conversation state — chat history must be managed externally and passed to every call. There's no memory abstraction, no summarization, no context window management. Compare to:
- **Spacebot**: Typed graph memory with 8 types, 5 edge types, hybrid search
- **LangChain**: Multiple memory backends (buffer, summary, entity, knowledge graph)
- **Mem0**: Dedicated memory-as-a-service

For simple one-shot calls this is fine. For building actual conversational agents, the user must build their own memory system from scratch. The library name suggests "rigging" — assembling agents — but delivers only the completion layer.

### 5. No Built-in Orchestration Beyond Pipelines
The pipeline module is a basic DAG executor with `map`/`chain`/`parallel` combinators. There's no:
- Agent-to-agent communication
- Workflow state machines
- Retry/fallback at the orchestration level
- Conditional routing based on model output
- Planning or decomposition

The examples show multi-agent patterns (`agent_orchestrator.rs`, `agent_routing.rs`, `debate.rs`), but these are hand-wired — no reusable orchestration primitives. For anything beyond linear pipelines, you're writing custom async Rust.

### 6. Breaking Changes Are Ongoing
The README warns: *"future updates **will** contain **breaking changes**"*. At v0.31.0 after 21 months, the API is still not stable. The `CompletionModelDyn` trait is already deprecated (since 0.25.0). The `DynClientBuilder` is deprecated. The edition was recently bumped to 2024. For production users, each upgrade is a potential migration effort.

### 7. Single-Company Dependency
Joshua Mo accounts for **812/911 commits (89%)**. The next contributors (Christophe: 198, Garance: 195) appear to be from the same company (Playgrounds Analytics / 0xPlaygrounds). The 169 unique contributors are mostly single-PR external contributors. The core development is a 1-3 person operation. If Playgrounds pivots or loses funding, maintenance stalls.

### 8. The "Agent" Is Thin
The `Agent` struct is essentially: model + preamble + static context + tools + temperature + max_tokens. The multi-turn loop is a simple retry-until-no-tool-calls loop with a max depth limit. There's no:
- Planning or reasoning chains
- Self-reflection or error recovery
- Dynamic tool selection beyond RAG
- Guardrails beyond hooks
- Cost tracking beyond token counting

Calling this an "agent" is generous. It's a **completion wrapper with tool dispatch**. The hook system adds flexibility, but the core loop is: send prompt → if tool call, execute tool, append result, retry → return text.

---

## Architecture Deep Dive: What's Under the Hood

### Tool Server
The `ToolServer` runs as a Tokio task, receiving messages via mpsc channel. Tools are executed through this indirection layer, which enables concurrent tool execution and dynamic tool management. The `ToolServerHandle` is cloneable and can be shared across agents. This is well-architected — it separates tool lifecycle from agent lifecycle.

### Structured Outputs
Two paths: `Extractor<M, T>` (legacy, uses tool-calling trick) and `TypedPrompt`/`prompt_typed()` (newer, uses native JSON schema). The `prompt_typed()` path generates a `schemars::Schema` from the target type and sends it to providers that support structured output. Clean design with good fallback behavior.

### Reasoning Traces
Cross-provider reasoning trace roundtrip — reasoning content (think tokens from Anthropic, CoT from DeepSeek) is preserved through multi-turn conversations. The `ReasoningContent` type captures both text and signatures. Recent addition (v0.30+), shows the project is tracking the frontier.

### SSE State Machine
The `sse.rs` module implements a reified SSE parser state machine for streaming responses. This replaced a previous approach and is cleaner for handling provider-specific SSE quirks (Anthropic's line-delimited format, Gemini's chunked responses).

---

## vs. The Landscape

| Dimension | Rig | LangChain (Python) | LlamaIndex (Python) | Vercel AI SDK (TS) |
|-----------|-----|-------------------|---------------------|-------------------|
| **Language** | Rust | Python | Python | TypeScript |
| **Provider coverage** | 20+ native | 80+ via integrations | 40+ | 15+ |
| **Memory** | None | Multiple backends | Multiple backends | AI SDK memory |
| **Orchestration** | Basic pipelines | LangGraph, chains | Workflows | Server actions |
| **Type safety** | Full (compile-time) | Runtime | Runtime | TypeScript types |
| **Performance** | Excellent (Rust) | Slow (Python) | Slow (Python) | Good (V8) |
| **WASM** | Yes | No | No | N/A (already JS) |
| **Maturity** | Pre-1.0, breaking changes | Stable, massive ecosystem | Stable | Stable |
| **Testing** | Thin | Extensive | Extensive | Extensive |

| Dimension | Rig | Spacebot | OpenClaw |
|-----------|-----|----------|----------|
| **Purpose** | Library (build your own) | Platform (deploy agents) | Platform (deploy agents) |
| **Memory** | None | Graph + vector hybrid | Markdown files |
| **Multi-user** | Not addressed | Core design | Single-user |
| **Security** | No sandboxing | Bubblewrap/sandbox-exec | CVE history |
| **Concurrency** | User-managed | 5-process delegation | Serial |

### In the Rust Ecosystem Specifically
Rig's main Rust competitors are thin:
- **llm-chain**: Abandoned (last commit 2023)
- **langchain-rust**: Community port, limited
- **kalosm**: Local models focus, different niche

Rig is effectively **the** production-grade Rust LLM library. This is both its strength (no real competition) and its risk (if Rig stalls, the Rust AI ecosystem has no fallback).

---

## Who's Actually Using It

The adoption signals are real but narrow:
- **St. Jude Children's Hospital**: Chatbot in genomics visualization tool (proteinpaint)
- **Neon** (the serverless Postgres company): V2 of app.build agent, full rewrite from TS to Rust
- **Listen**: AI portfolio management framework
- **Ironclaw** (Near AI): Secure personal assistant
- **Coral Protocol**: Rust SDK integration

These are real companies with real products. But the usage pattern is telling: they're all using Rig as a **provider abstraction layer** with basic agent capabilities — not for its pipeline or orchestration features. The value is "call any LLM from Rust with a clean API."

---

## Code Quality Assessment

**Strengths:**
- Workspace lints forbid `dbg!`, `todo!`, `unimplemented!` (but not `panic!`)
- CI runs fmt, clippy (all features), nextest, WASM check, doc build
- Clean module organization with `pub(crate)` visibility control
- Typestate patterns (AgentBuilder tool config) prevent misuse at compile time
- `#[non_exhaustive]` on key enums for forward compatibility
- 1 `unsafe` in the entire codebase

**Weaknesses:**
- `panic!` not forbidden despite `todo!` and `unimplemented!` being forbidden — inconsistent
- `//FIXME: Must fix!` in Azure provider (shipping known broken code)
- Provider completion files are 1,500–3,200 lines each — these need decomposition
- 8 TODO/FIXME in non-test code (not terrible, but some are in shipped paths)
- The `one_or_many.rs` module (730 lines) is a custom `NonEmptyVec` — could use a crate
- Evals module is `experimental` feature-gated and minimally implemented

---

## Bottom Line

Rig is the **best Rust library for calling LLMs** in early 2026. The provider abstraction is well-designed, the coverage is unmatched in the Rust ecosystem, and the ergonomics are good for Rust. The streaming infrastructure, hook system, and WASM support are genuine differentiators. MIT license, active development, real production users.

**But it's not an agent framework.** It's a **completion client library with agent-shaped ergonomics**. The "agent" is a thin wrapper. There's no memory, no orchestration beyond basic pipelines, no planning, no state management. If you need those, you're building them yourself on top of Rig — which is a valid approach, but the marketing ("building scalable, modular LLM-powered applications") oversells what the library actually delivers today.

**The testing gap is the most serious concern.** A library used in production by hospitals and fintech companies should not have zero mocked tests for its provider implementations. The 156 panics in non-test code are a liability. A single unexpected API response format can crash the caller's application.

**The value proposition is clear:** If you're writing Rust and need to talk to LLMs, use Rig. There is no credible alternative. If you need agents with memory, orchestration, and multi-user support, Rig gives you a good foundation to build on — but you'll be building most of the agent infrastructure yourself.

**The bet:** Rig is betting that being the best *library* — composable, type-safe, provider-agnostic — is more valuable than being a batteries-included *framework*. History is mixed on this. Express won over Sails, but Rails won over Sinatra. In the AI agent space specifically, the value is increasingly in orchestration and memory — areas where Rig has minimal presence. The question is whether Rig will grow into those areas before a competitor (or a Rust port of a Python framework) fills the gap.

---

## Sources

- Rig repo: github.com/0xPlaygrounds/rig (local clone, source-level review)
- crates.io/crates/rig-core — download stats, version history
- docs.rig.rs — official documentation
- ECOSYSTEM.md — project and company listings
- CI configuration (.github/workflows/ci.yaml)
- Git log analysis (911 commits, 169 contributors, 21 months)
- Neon app.build repo: github.com/neondatabase/appdotbuild-agent
- St. Jude proteinpaint: github.com/stjude/proteinpaint
