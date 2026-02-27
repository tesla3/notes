← [Exemplary Codebases](exemplary-codebases-for-llm-context.md) · [Index](../README.md)

# Counter-Evidence: The Fatal Weaknesses of Every "Best" Codebase

**Purpose:** Systematic challenge to every project cited in the exemplary codebases list. For each, the question: what's the substantial, structural weakness that the praise obscures? Not nitpicks — genuine design failures or trade-offs that are *inseparable* from the quality being praised.

**Thesis going in:** If the central claim is "constraint produces quality," then every constraint also produces a *specific, predictable failure mode*. The interesting question is whether the failure mode was worth accepting.

**Compiled:** February 26, 2026

---

## Erlang/OTP — "Let It Crash" Can't Crash Its Way to Intelligence

**The praise:** Supervision trees, isolated processes, automatic recovery, nine-nines uptime.

**The fatal weakness for the AI agent era:**

Your own notes already have the definitive analysis (`research/hn-elixir-agent-frameworks.md`), and it's devastating:

**"Let it crash" assumes state is disposable.** In telecom, a new dial tone is identical to the old one. Restarting a crashed process in clean state is fine — nothing was lost. For AI agents, "clean state" means *lost conversation context, lost tool call history, lost chain-of-thought reasoning.* The entire value of an agent is in its accumulated state. [quadruple] from that HN thread: "If the LLM API returns an error because the conversation is too long, I want to run compacting or other context engineering strategies, I don't want to restart the process."

**Erlang's isolation model prevents exactly the kind of shared context agents need.** Erlang processes communicate only by message passing, share no memory. This is great for fault isolation. It's terrible for agents that need to share context, coordinate on a shared codebase, pass rich state between sub-agents, or maintain a coherent conversation across multiple tool-using components. Every piece of shared state must be serialized, sent as a message, deserialized. For agents passing around 100K+ token contexts, this is structural overhead with no benefit.

**Durability is the elephant.** [mackross], a self-described "huge Elixir fan," delivers the kill shot: "BEAM fanboys sweep durable execution under the rug." ETS tables and supervision trees don't survive deployment restarts. Agents that run for minutes or hours need persistence to a database *regardless of runtime*. Once you're bolting on Oban or your own persistence layer, the simplicity advantage over Python + Celery + Postgres collapses.

**The ecosystem moat is fatal.** Every LLM SDK ships Python-first. Every eval framework, every embedding model, every vector DB client is Python-native. Elixir's equivalents (Jido, Bumblebee) trail years behind. The article that argued BEAM is the natural runtime for agents was "a well-constructed argument for a conclusion the market has already rejected."

**My original analysis missed this:** I praised Erlang's "let it crash" philosophy as "the most counterintuitive design philosophy in this entire collection." I should have immediately connected it to the agent use case — the one the user actually cares about — where it's *structurally wrong*. "Let it crash" works when state is cheap. In the LLM era, state (context, tokens, reasoning traces) is the most expensive thing there is.

---

## SQLite — The Query Planner Hits a Wall

**The praise:** 590:1 test ratio, single-file format, billions of devices, drh's discipline.

**The structural weakness I undersold:**

A Jan 2026 analysis ([yyhh.org](https://yyhh.org/blog/2026/01/sqlite-in-production-not-so-fast-for-complex-queries/)) with JOB benchmark data exposes the real ceiling: **SQLite's query optimizer fundamentally cannot handle complex joins.** The cardinality estimation is primitive compared to PostgreSQL's. For queries with many tables, the planner can't explore enough of the plan space to find good join orderings. The result: query plans that process *orders of magnitude more intermediate rows than necessary*.

This isn't a bug. It's an architectural choice. drh optimized for the "file format, not a database" constraint. A sophisticated query planner would make the codebase larger, harder to test, and harder to embed. The same constraint that produces the 156K SLOC compactness produces a planner that falls over on 10-way joins.

**The single-writer limitation is deeper than acknowledged.** Everyone knows SQLite doesn't support concurrent writes well. What's less discussed: even in WAL mode, all writes are serialized through a single writer. For web applications with any meaningful write load, this means SQLite is *structurally incapable* of scaling. drh's own "appropriate uses" page says "SQLite competes with fopen(), not with client/server databases" — but the "SQLite for everything" movement ignores this, and my original analysis enabled that by praising SQLite without adequately stressing what "file format, not a database server" *actually excludes*.

**The cathedral model has a bus-factor cost.** drh barely accepts patches. The project depends on one person's taste, one person's continued engagement. drh has committed to maintaining SQLite through 2050. But the project's quality is inseparable from its autocracy — and autocracy is fragile by definition.

---

## Redis — The Fork Proved the Design Was Wrong

**The praise:** Most readable C codebase, single-threaded simplicity, antirez's taste.

**The structural weakness the praise obscures:**

**Single-threaded was a design choice, and the ecosystem eventually rejected it.** antirez's argument — the bottleneck is network I/O, not CPU — was true for Redis-as-cache in 2009. It became increasingly false as Redis took on roles as a message broker, session store, and primary data store where multi-core utilization matters. Kelly Sommers was "blocked and ridiculed for saying Redis should be multi-threaded. Both by the community and the maker for years" — and was eventually proven right.

The fork (Redis → Valkey) happened partly because the licensing change, but the underlying technical tension had been building for years. antirez's design philosophy prioritized aesthetic coherence over serving the community's evolving needs. The readable, beautiful, single-threaded codebase *couldn't evolve* without losing the properties that made it beautiful.

**This is the dark side of solo-author excellence.** When the solo author's taste conflicts with the ecosystem's needs, the project either bends (losing its character) or breaks (fork). Redis broke. The very thing I praised — "the code is beautiful *because* concurrency is absent" — is also the reason the project eventually failed its community.

**Memory efficiency was always poor.** Redis stores everything in memory with significant per-key overhead. For large datasets, this translates to 5-10x the raw data size in memory consumption. This was acceptable when Redis was a small cache; it's expensive when Redis is your primary data store with millions of keys.

**The "readable C" has limits.** At ~65K SLOC it's clean. But as features were added (Cluster, Streams, modules), the codebase started accumulating the complexity that antirez's minimalism had held at bay. The pre-fork codebase was *already* less clean than the early versions. The golden era people praise was a moment in time, not a stable state.

---

## Lua — Elegant Isolation Is Also Elegant Abandonment

**The praise:** 30K SLOC, everything is a table, stack-based API, fits in a context window.

**The structural weakness:**

**"Punt the hard parts to the host" has a name in software engineering: it's called not solving the problem.** Lua can't do I/O, networking, string manipulation, threading, or real error handling without C bindings. Every real application needs a substantial binding layer. The 30K SLOC elegance exists *because Lua externalized all the hard engineering*. Praising Lua's small size is like praising an engine for weighing nothing because it shipped without a transmission.

**1-indexed arrays.** Not a nitpick — a genuine cognitive load problem that every Lua programmer encounters daily and that creates bugs at the boundary between Lua and every other language (all 0-indexed). This is the kind of "principled choice" (matching mathematical convention) that looks elegant in the design document and causes real damage in practice.

**Error handling is genuinely bad.** `pcall` and `xpcall` are the error handling mechanism. No exceptions, no Result types, no stack traces by default. "Limited error handling support" is the polite version; "error handling is an afterthought" is the honest one. The same minimalism that produces the clean VM produces an error story that real applications have to work around.

**The ecosystem is a wasteland of abandoned packages.** LuaRocks exists but the package quality and maintenance is dramatically worse than pip, npm, cargo, or even Go modules. The small community means most libraries are single-author, single-year efforts. This is the direct consequence of Lua's "small core, minimal stdlib" philosophy — the community never reached critical mass to sustain an ecosystem.

**The constraint that produces elegance also produces irrelevance.** Lua is excellent at what it does (embedded scripting). But the "what it does" has shrunk over time as other embedded options (Wren, Squirrel, or just "embed Python/JS") have emerged. Lua's design philosophy is best understood as the right answer to a 1993 question that fewer people are asking in 2026.

---

## Git — Beautiful Data Model, Hostile to Humans

**The praise:** Content-addressable storage, four object types, branches as pointers.

**The structural weakness:**

**The data model's beauty doesn't propagate to the interface — and this isn't an accident.** Torvalds designed Git for *himself* and for kernel maintainers who think in terms of Merkle trees and patch series. The CLI was never intended to be friendly. `git checkout` means four different things. `git reset` has three modes that even experts confuse. `git rebase` can silently lose work if interrupted incorrectly (yes, the reflog usually saves you, but "usually" isn't "always").

The HN thread "What's wrong with Git?" (2016) identifies the core problem: "A tool for managing collaborative work through a beautiful distributed graph theory tree model... with a very, very difficult to use UI." This isn't fixable without breaking backwards compatibility, which Git will never do.

**The "no rename tracking" trade-off has real costs.** Git detects renames heuristically by comparing file content similarity. This works most of the time. When it doesn't — when you rename a file AND heavily modify it in the same commit — Git loses the history. For codebases with significant refactoring, this is a genuine limitation that causes real lost-history problems. The "elegant simplicity" of not tracking renames comes at the cost of *sometimes getting it wrong in ways you can't fix*.

**Git's distributed model is a fiction for most teams.** The "every clone is a full repository" design enables distributed workflows that almost nobody uses. In practice, 99% of Git usage is centralized (push to GitHub/GitLab). The distributed complexity (remote tracking branches, fetch vs pull, upstream configuration) is overhead for the actual use case. The elegant architecture serves a use case that barely exists.

---

## FoundationDB — The Simulation Trap

**The praise:** Deterministic simulation testing, one trillion CPU-hours of testing, "couldn't have built it without this technology."

**The structural weakness:**

**Apple acqui-hired the team and shut down the product.** In 2015, Apple bought FoundationDB and immediately yanked downloads. Users were "shit outta luck." The product was later re-open-sourced (2018), but the damage was done — adoption cratered and never recovered. **The most tested database in the world has one of the smallest production footprints.** Testing perfection didn't prevent business failure.

**The simulation-first approach has an adoption problem.** You can't retrofit deterministic simulation onto an existing codebase. It's a day-one architectural commitment that constrains every subsequent choice. This means the approach, however brilliant, has almost zero transferability. It worked for FoundationDB and TigerBeetle because they could build from scratch with simulation as the foundation. For the 99.9% of projects that already exist, it's inspirational but not actionable.

**FoundationDB has hard-coded limitations that limit real-world use.** 5-second transaction timeout. Transactions must be "quite small." Keys limited to 10KB, values to 100KB. These constraints fall out of the distributed architecture and can't be relaxed without fundamental redesign. For many workloads, these are dealbreakers.

**TigerBeetle inherits the problem in a different form.** Oct 2025 community scrutiny revealed: no built-in authentication, no SQL support, single-core processing per node, limited to financial transactions only, incompatible with serverless platforms. The performance claims ("1000x faster than SQL") were challenged with evidence of MySQL handling 80-90K QPS in production. The original praising article was written by TigerBeetle's own investor. TIGER_STYLE.md is impressive engineering documentation; the product's real-world adoption is a tiny fraction of what the testing sophistication would suggest.

---

## ripgrep — The Counterargument Is Weak, But It Exists

**The praise:** Best Rust crate architecture, BurntSushi's taste, decomposed into reusable libraries.

**The honest weakness:**

ripgrep is the hardest project on this list to criticize because it's a *solved problem done well*. grep has been around since 1973. The search space for "what could go wrong" is tiny.

**The weakness is the domain, not the design.** ripgrep demonstrates excellent architecture in a domain where the architecture doesn't need to be excellent. A monolithic grep replacement would work fine. The crate decomposition is elegant but arguably over-engineered for the problem — how many consumers of `grep-printer` exist outside ripgrep itself? VS Code uses the regex engine, but the other crates are largely library-for-the-sake-of-library.

**Rust itself is the accessibility barrier.** ripgrep's codebase is idiomatic Rust, which means it's impenetrable to anyone who doesn't know Rust well. The "readability" praise is Rust-community-internal. Compare to Redis's C, which non-C-programmers can follow. ripgrep's Rust is excellent Rust, but "excellent Rust" and "readable to outsiders" are not the same thing.

---

## Plan 9 — Correctness That Nobody Wanted

**The praise:** "Everything is a file" taken seriously, per-process namespaces, conceptual purity.

**The fatal weakness:**

**Plan 9 is the strongest possible evidence that architectural elegance is insufficient for success.** The design was right. The namespace model was right. The ideas were decades ahead. And it failed completely in the market.

Why? Not lack of marketing or documentation (though those didn't help). The real reason: **Plan 9 offered no migration path.** It couldn't run Unix binaries. It had no drivers for commodity hardware. It required learning new editors (sam, acme), a new shell (rc), new tools for everything. The cost of adoption was "throw away everything you know and all your software." No amount of conceptual elegance justifies that cost to working engineers.

The lesson is uncomfortable: **design elegance and adoption are at best orthogonal, possibly anti-correlated.** The most elegant systems (Plan 9, Lisp machines, Smalltalk environments) tend to fail commercially because the elegance comes from refusing to compromise with the messy existing world. The systems that win (Unix, Linux, JavaScript) are *ugly compromises* that meet users where they are.

For the LLM context use case, this is the most important counter-evidence in the whole document: **if you point a coding agent at Plan 9's design philosophy and say "build like this," you'll get something beautiful that nobody can use with their existing tools, libraries, and infrastructure.**

---

## Go Standard Library — Boring Has a Price

**The praise:** Universal readability, language-enforced simplicity, "every line oozes purpose."

**The structural weakness:**

**The error handling is genuinely bad, and the Go team knows it.** `if err != nil` on every fourth line isn't just verbose — it's a cognitive tax that obscures the actual logic. The Go team's own blog: "the verbosity is real, and complaints about error handling have topped our annual user surveys for years." They tried to fix it (the `try` proposal, the `check/handle` proposal) and failed both times because the simplicity constraint prevents any solution that adds new control flow.

**The "language won't let you be clever" constraint also won't let you be expressive.** Before generics (Go 1.18, 2022), you literally could not write a type-safe generic data structure. `interface{}` everywhere, runtime type assertions, panic on mismatch. This wasn't an edge case — it was the fundamental design of maps, channels, and slices being generic while user code couldn't be. The aristocracy of built-in types over user-defined types was a genuine design flaw that took 13 years to partially fix.

**Go's simplicity is partly enforced ignorance.** No sum types means you can't express "this value is either A or B" in the type system — you use an interface with methods that only one variant implements, and pray. No enums (just iota constants) means the compiler can't check exhaustive switches. These aren't missing features — they're missing safety guarantees that other languages proved valuable decades ago.

The Go stdlib is clean *within the constraints of a language that prevents certain kinds of cleanliness.* Praising it is partly praising the ceiling as if it were the sky.

---

## The Pattern Across All of Them

Every project's weakness is **the direct, inseparable consequence of its strength.**

| Project | Strength | Weakness (same coin, other side) |
|---------|----------|----------------------------------|
| SQLite | "File format, not a server" | Can't handle complex queries or concurrent writes |
| Redis | Single-threaded simplicity | Can't use multiple cores; community outgrew the design |
| Lua | 30K SLOC minimalism | Externalizes all hard problems; ecosystem never formed |
| Erlang | "Let it crash" + stateless restart | Useless when state is expensive (agents, LLMs) |
| Git | Content-addressable simplicity | UI so hostile it's a meme; rename tracking is heuristic |
| FoundationDB | Simulation-first correctness | Tiny adoption; can't retrofit; hard-coded limitations |
| TigerBeetle | Zero-dep, zero-compromise | No auth, no SQL, single-core, financial-transactions-only |
| ripgrep | Decomposed crate architecture | Over-engineered for a solved problem; Rust is barrier |
| Plan 9 | Conceptual purity | No migration path; failed completely |
| Go stdlib | Enforced simplicity | Can't express basic type safety; error handling is genuinely bad |

The meta-lesson: **there is no such thing as a design that's excellent without qualification.** Every constraint that produces quality also produces a specific failure. The question is never "is this well-designed?" but "is this well-designed *for my problem*, and can I afford the failure mode that comes with it?"

For the LLM context use case: when you tell an agent "design like X," you're also implicitly telling it "accept the failure mode of X." Make sure you know what that failure mode is.

---

## Sources

- Own notes: `research/hn-elixir-agent-frameworks.md` (Erlang/agent fatal weakness)
- [SQLite in Production? Not So Fast for Complex Queries (Jan 2026)](https://yyhh.org/blog/2026/01/sqlite-in-production-not-so-fast-for-complex-queries/) — JOB benchmark evidence
- [SQLite: Appropriate Uses](https://sqlite.org/whentouse.html) — drh's own limitations acknowledgment
- [Redis Analysis Part 1: Threading Model (2021)](https://www.romange.com/2021/12/09/redis-analysis-part-1-threading-model/) — Kelly Sommers vindication, mathematical argument for vertical scaling
- [TigerBeetle Community Scrutiny (Oct 2025)](https://biggo.com/news/202510011913_TigerBeetle_Database_Community_Scrutiny) — missing auth, performance claims challenged
- [No More FoundationDBs (2015)](https://petabridge.com/blog/no-more-foundationdbs/) — Apple acquisition damage
- [Go Blog: Error Handling Syntax (2024)](https://go.dev/blog/error-syntax) — Go team acknowledges the problem
- [Lua: Good, Bad, and Ugly Parts](https://notebook.kulchenko.com/programming/lua-good-different-bad-and-ugly-parts)
- HN: "What's wrong with Git? A conceptual design analysis" (2016)
- Wikipedia: Plan 9 adoption failures
