← [Exemplary Codebases (Classics)](exemplary-codebases-for-llm-context.md) · [Index](../README.md)

# Architecturally Remarkable GitHub Repos: Modern Projects Worth Studying

**Purpose:** Projects from ~2020–2026 that make genuinely novel architectural bets to solve hard problems. Not "popular repos" or "awesome lists" — projects where the *design itself* is the interesting thing. Each entry answers: what's the hard problem? What's the architectural bet? Why is it unique? What do experts actually think?

**Differentiation from [Exemplary Codebases](exemplary-codebases-for-llm-context.md):** That file covers constraint-driven classics (SQLite, Redis, Lua). This file covers **modern projects making architectural gambles** — newer, less proven, but with design ideas worth understanding even if the project dies.

**Compiled:** February 26, 2026. **Sources:** Lobsters, HN, InfoQ, expert blog posts, architecture docs, Jepsen analyses, my own critical evaluation.

---

## The Organizing Insight

The classic codebases succeeded through *constraint* — saying no to features. The modern projects here succeed through *inversion* — taking a well-known architecture and doing the opposite of what everyone assumes is necessary, then making it work. TigerBeetle inverts "databases need many threads." DuckDB inverts "analytics needs a server." vLLM inverts "GPU memory is fixed-size allocation." Dragonfly inverts "Redis must be single-threaded." Each is a bet against conventional wisdom, backed by a specific technical insight that makes the inversion viable.

---

## Tier 1: Study the Architecture Docs Line by Line

These have exceptional architecture documentation *and* genuinely novel designs.

---

### 1. TigerBeetle — The Financial Database That Bets Against Threads

**Repo:** [github.com/tigerbeetle/tigerbeetle](https://github.com/tigerbeetle/tigerbeetle)
**Language:** Zig · **Started:** ~2020

**The hard problem:** Financial transactions (double-entry bookkeeping) require strict serializability with high throughput on Pareto-distributed accounts (a few accounts handle most transfers). Traditional databases handle this poorly because hot accounts create lock contention.

**The architectural bet:**

1. **Single-threaded commit loop + io_uring.** Instead of multi-threaded with locking, a single thread processes all transactions. I/O is asynchronous via io_uring (Linux) or equivalent. The Lobsters discussion captures it: "you can have another core once you've saturated the first one." The insight: for *this workload*, lock contention costs more than single-thread limitation.

2. **Deterministic simulation testing (inherited from FoundationDB).** The entire cluster — network, disk, clocks — is simulated deterministically in a single process. Same seed = same execution = reproducible bugs. TigerBeetle claims this catches bugs that would take years to surface in production.

3. **Zero dependencies, Zig, assertions in production.** Not a purity play — it's that simulation testing requires total control of every syscall. You can't simulate a dependency you don't control. The language choice (Zig over C/Rust) is partly about `comptime` enabling zero-allocation data structures and partly about a simpler compilation model.

4. **Custom LSM tree for the specific workload.** Not a general-purpose storage engine — designed around the access patterns of financial accounts (Pareto distribution, small fixed-schema records, multi-object transactions).

5. **The Viewstamped Replication consensus protocol** — chosen over Raft because VSR allows pipelining prepare messages while maintaining strict serializability.

**What experts actually think:**

- Lobsters (2023): "Following and trying to understand what TigerBeetle are doing has been very educational to me. Not all of it is relevant to my work, but nearly all of it has expanded my thinking." Genuine enthusiasm from systems programmers.
- A commenter who "worked on a multithreaded database" validates the single-thread choice: "Using multiple threads to write to the same physical drive is usually just moving the single point of synchronization to the kernel/firmware."
- **Critical voices (Oct 2025):** No built-in authentication, no SQL, single-core per node, limited to financial transactions only, incompatible with serverless. Performance claims ("1000x faster than SQL") challenged with evidence of MySQL handling 80-90K QPS. The original praise article was written by TigerBeetle's own investor.

**My assessment:** The architecture documentation ([ARCHITECTURE.md](https://github.com/tigerbeetle/tigerbeetle/blob/main/docs/internals/ARCHITECTURE.md), [TIGER_STYLE.md](https://github.com/tigerbeetle/tigerbeetle/blob/main/docs/TIGER_STYLE.md)) is among the best engineering writing in any open-source project. The ideas are transferable even if TigerBeetle-the-product never achieves mass adoption. The single-threaded-with-io_uring pattern, the deterministic simulation approach, the "zero dependencies for simulability" reasoning chain — these are genuinely novel design arguments worth internalizing.

**What to study:** ARCHITECTURE.md (the full document), TIGER_STYLE.md (engineering principles), the LSM tree implementation, the io_uring integration.

---

### 2. DuckDB — The SQLite of Analytics

**Repo:** [github.com/duckdb/duckdb](https://github.com/duckdb/duckdb)
**Language:** C++ · **Started:** 2018 (CWI Amsterdam)

**The hard problem:** Analytical queries (aggregations, scans, joins on large datasets) traditionally require standalone OLAP servers (Snowflake, ClickHouse, BigQuery). But most analysts work locally on datasets that fit on a single machine. They're paying server overhead for a local problem.

**The architectural bet:**

1. **In-process, embedded, zero-dependency OLAP.** Like SQLite for OLTP, DuckDB is a library you link into your process. No server, no network protocol, no separate process. `import duckdb; duckdb.sql("SELECT ...")` — that's it. This eliminates the entire client-server layer that dominates query latency for small-to-medium datasets.

2. **Vectorized execution engine.** Where SQLite processes rows one at a time (Volcano model), DuckDB processes *vectors* of values — typically 1024 rows at once. This exploits CPU SIMD instructions and cache locality. The same query can be 10-100x faster simply because the execution model aligns with modern hardware.

3. **Columnar storage with row groups.** Data is stored column-by-column, not row-by-row. Analytical queries that touch 3 columns of a 100-column table read only 3% of the data. Combined with lightweight compression (dictionary, RLE, bitpacking), this slashes I/O.

4. **Reads anything without import.** DuckDB can query Parquet, CSV, JSON, Arrow, Pandas DataFrames, SQLite databases, and PostgreSQL tables *directly* without ETL. The "data comes to the query engine" pattern eliminates the biggest friction in analytics: the import step.

**What experts actually think:**

- HN's DuckDB threads are overwhelmingly positive, but the interesting critique comes from `pracdata.io` (Sep 2024): "DuckDB doesn't eliminate the need for a proper data warehouse at scale — it's brilliant below ~100GB, competitive to ~1TB, and not the right tool beyond that." The ceiling is real.
- The academic lineage is significant: DuckDB comes from CWI Amsterdam (the same lab that produced MonetDB, the grandfather of columnar analytics). This isn't a startup guessing — it's 30 years of OLAP research crystallized into an embeddable library.
- Your own HN research (`hn-duckdb-first-choice-data-processing.md`) captures the key debate: relational guarantees vs raw speed, SQL-vs-dataframes conflation, and the governance moat.

**My assessment:** DuckDB is the strongest example of *architectural inversion* on this list. The entire OLAP industry assumes you need servers, clusters, distributed compute. DuckDB says: "most of your data fits on one machine, and an in-process engine with the right execution model is faster than a networked server for that scale." This is SQLite's original insight applied to a different domain — and it's working. DuckDB's adoption curve in data science is steeper than any database in recent memory.

**What to study:** The vectorized execution engine design, the buffer manager (how it handles datasets larger than memory), the multi-file Parquet scanning with predicate pushdown, the extension system (DuckDB extensions can add new file formats, functions, even storage backends).

---

### 3. FoundationDB — Simulation as Architecture (Not Just Testing)

**Repo:** [github.com/apple/foundationdb](https://github.com/apple/foundationdb)
**Language:** C++ with Flow (custom actor framework) · **Started:** 2009

Already covered in the [classics file](exemplary-codebases-for-llm-context.md), but the simulation architecture deserves deeper treatment here because it's spawning a **design pattern** (DST) now adopted by multiple projects.

**The hard problem that's actually two problems:**

1. Distributed ACID transactions on an ordered key-value store.
2. **Testing a distributed system to a standard that allows you to sleep at night.** This is the problem FoundationDB actually solved — the database is the vehicle, the testing methodology is the product.

**The simulation architecture in detail:**

Pierre Zemb's deep dive (Oct 2025) reveals the implementation: a global `g_network` pointer holds an `INetwork` interface. In production, it points to `Net2` (real TCP via Boost.ASIO). In simulation, it points to `Sim2` (fake connections writing to in-memory buffers). Same code, both paths. Network latency is `delay()` calls from `deterministicRandom()`. Packet loss is `throw connection_failed()`. Everything is a single-threaded discrete event loop.

**BUGGIFY:** The secret sauce most people miss. Throughout the codebase, `BUGGIFY` macros fire 25% of the time (deterministically), introducing chaos: slow disks, delayed messages, corrupted packets. The insight: rare bugs need rare combinations of events. Rather than waiting for them, BUGGIFY *forces* them. "Swizzle-clogging" (the championship failure pattern) randomly clogs and unclogs network connections to different nodes in overlapping sequences.

Zemb's operational testimony: "After years of on-call shifts running FoundationDB at Clever Cloud: **I've never been woken up by FDB.** Every production incident traced back to our code, our infrastructure, our mistakes. Never FDB itself."

**The spawning pattern:** DST is now adopted by TigerBeetle (Zig), Resonate (deterministic execution), and others. Antithesis (founded by FoundationDB alumni) commercialized the approach as a deterministic hypervisor — you don't even need to build your system for DST; Antithesis runs your existing code in a deterministic VM. BugBash 2025 conference (organized by Antithesis) brought together Kyle Kingsbury (Jepsen), Mitchell Hashimoto (Ghostty/HashiCorp), and FoundationDB creators.

**What to study:** [apple.github.io/foundationdb/testing.html](https://apple.github.io/foundationdb/testing.html), the `Sim2` implementation in `fdbrpc/sim2.actor.cpp`, the BUGGIFY macro usage patterns, and the [Will Wilson Strange Loop 2014 talk](https://www.youtube.com/watch?v=4fFDFbi3toc) (the canonical introduction).

---

## Tier 2: Novel Architectural Bets Worth Understanding

These make a single, bold architectural choice that's genuinely different from the mainstream approach.

---

### 4. Dragonfly — Shared-Nothing Redis at Multi-Core Scale

**Repo:** [github.com/dragonflydb/dragonfly](https://github.com/dragonflydb/dragonfly)
**Language:** C++ · **Started:** 2022

**The hard problem:** Redis is single-threaded. Modern servers have 64+ cores. The industry "solution" was Redis Cluster (shard across multiple Redis instances), which adds operational complexity, cross-slot limitations, and network hops. Can you build a multi-threaded, Redis-compatible system that *actually* scales linearly with cores?

**The architectural bet:**

1. **Shared-nothing, thread-per-core architecture.** Each thread owns a partition of the keyspace. No locks, no shared data structures. Inter-thread communication is via lock-free queues. This is the Seastar/ScyllaDB model applied to an in-memory key-value store.

2. **Dash — a novel hash table.** Dragonfly doesn't use Redis's `dict.c` hash. It uses "Dash" (Dashtable), a segmented hash table designed for the shared-nothing model where each segment is owned by one thread. This eliminates the "rehashing" pauses that plague Redis during resize operations.

3. **Novel snapshotting using versioned pointers.** Instead of Redis's fork()-based snapshotting (which doubles memory usage via copy-on-write), Dragonfly uses a serialization technique that doesn't require forking. Each entry carries a version counter; the snapshot serializer reads entries at a consistent version without blocking writers.

**What experts actually think:**

- Redis/Valkey advocates argue that for most workloads, a single Redis instance is fast enough and the operational simplicity wins. "You don't need multi-core for a cache."
- Dragonfly's own benchmarks show 25x throughput over Redis on the same hardware. Independent benchmarks are less dramatic but still show significant gains (3-5x for realistic workloads).
- The Valkey fork (from Redis) is now pursuing multi-threaded I/O too, potentially eating Dragonfly's advantage from the established ecosystem.

**My assessment:** The interesting lesson isn't "multi-threaded is better than single-threaded" — that's obvious. It's **how you make multi-threaded correct without locks.** The Dash hash table and the snapshot-without-fork technique are genuine innovations. Even if Dragonfly doesn't win the market (Valkey has ecosystem gravity), the *techniques* are worth studying.

**What to study:** The Dash hash table design, the snapshot mechanism, the shared-nothing threading model.

---

### 5. vLLM — OS Virtual Memory for GPU Attention

**Repo:** [github.com/vllm-project/vllm](https://github.com/vllm-project/vllm)
**Language:** Python + CUDA · **Started:** 2023 (UC Berkeley)

**The hard problem:** LLM inference requires storing a KV (key-value) cache for each token in each request. The cache grows dynamically as the model generates tokens. Pre-allocating maximum-length buffers wastes 60-80% of GPU memory. Fragmentation from variable-length requests wastes more. GPU memory is the bottleneck — wasted memory = fewer concurrent requests = lower throughput.

**The architectural bet: PagedAttention.**

Take the operating system's virtual memory and paging technique and apply it to GPU KV cache management:

1. **KV cache is divided into fixed-size "pages" (blocks).** Each block holds KV vectors for a fixed number of tokens (e.g., 16).
2. **A page table maps logical token positions to physical GPU memory blocks.** Just like an OS page table maps virtual addresses to physical memory.
3. **Blocks are allocated on demand** as the model generates tokens. No pre-allocation waste.
4. **Blocks can be shared** across requests that share a common prefix (like a system prompt). Copy-on-write semantics — shared until one request diverges.
5. **No memory fragmentation.** Blocks are fixed-size and interchangeable, like OS pages.

**Why this is brilliant:** It's a direct, precise analogy to a 60-year-old OS concept. Virtual memory solved *exactly this problem* (variable-length processes competing for fixed physical memory) in the 1960s. The insight isn't complex — it's "we've solved this before in a different domain." The SOSP 2023 paper showed 2-4x throughput improvement over existing serving systems with near-zero memory waste.

**What experts actually think:**

- The SOSP paper was immediately influential. vLLM became the default LLM serving framework within months of release.
- Critics note that PagedAttention adds latency per attention operation (the indirection through the page table). For latency-sensitive applications, this can matter.
- Subsequent work (FlashAttention, FlashInfer) has partly caught up on memory efficiency through different techniques (fused kernels, ragged tensors). The field is moving fast.

**My assessment:** vLLM is the clearest example I know of **cross-domain architectural transfer** — taking a well-understood solution from OS design and recognizing it applies to GPU memory management. The lesson isn't vLLM-specific: when you face a resource allocation problem, ask "has this already been solved in a different domain?"

**What to study:** The [PagedAttention paper](https://arxiv.org/abs/2309.06180), the block manager implementation, the scheduler (how it decides which requests to batch and when to preempt).

---

### 6. Redpanda — Thread-Per-Core Kafka Without the JVM

**Repo:** [github.com/redpanda-data/redpanda](https://github.com/redpanda-data/redpanda)
**Language:** C++ (Seastar framework) · **Started:** 2020

**The hard problem:** Apache Kafka is the de facto event streaming platform, but it runs on the JVM with all the associated overhead: GC pauses, memory bloat, large operational footprint. Kafka requires ZooKeeper (or KRaft) for metadata. Tuning Kafka for tail latency requires deep JVM expertise.

**The architectural bet:**

1. **Thread-per-core via Seastar.** Each CPU core gets one thread with its own memory pool, network connections, and disk I/O. No shared state between cores. No locks. Communication between cores is via async message passing (SPSC queues). This is ScyllaDB's model (Seastar was built by the ScyllaDB team) applied to event streaming.

2. **Raft for everything.** Where Kafka needed ZooKeeper/KRaft for metadata consensus *plus* its own replication protocol for data, Redpanda uses Raft for both. Each partition is a Raft group. One protocol, one correctness argument.

3. **Single binary, no JVM.** No garbage collector pauses. Predictable tail latency. Memory usage is what you allocate, not what the GC decides to keep around.

**What experts actually think:**

- InfoQ (2023): The thread-per-core model "unlocks the performance of modern hardware" but "brings new challenges for robustness and developer productivity." Seastar's programming model is genuinely hard — cooperative scheduling means any blocking call stalls the entire core.
- Kafka partisans argue that KRaft (Kafka's replacement for ZooKeeper) closes the operational gap, and Kafka's ecosystem (Kafka Connect, ksqlDB, Schema Registry) is irreplaceable.
- Redpanda's own blog (Sep 2025) on buffer management reveals the depth: managing memory in a thread-per-core model without a global allocator requires novel techniques for cross-core buffer ownership.

**My assessment:** The thread-per-core pattern (Seastar) is the most important systems programming pattern most developers haven't heard of. It's the logical conclusion of "shared-nothing": don't just avoid locks — avoid *sharing* anything, including the memory allocator. The cost is programming difficulty (cooperative scheduling, manual memory management per-core). The payoff is predictable, near-hardware-limit performance. Even if you never use Redpanda, understanding the Seastar model changes how you think about server architecture.

**What to study:** The [Seastar tutorial](https://seastar.io/), Redpanda's Raft implementation, the buffer management blog posts, the benchmark methodology.

---

### 7. Ghostty — Platform-Native Terminal via Zig Library Core

**Repo:** [github.com/ghostty-org/ghostty](https://github.com/ghostty-org/ghostty)
**Language:** Zig + Swift (macOS) + GTK (Linux) · **Author:** Mitchell Hashimoto · **Started:** 2022

**The hard problem:** Terminal emulators are either cross-platform but feel foreign (Alacritty, Kitty use custom rendering), or platform-native but not cross-platform (Terminal.app, GNOME Terminal). Can you have both?

**The architectural bet:**

1. **libghostty: a cross-platform C-ABI library.** The terminal emulation core (parsing, state machine, font handling, rendering) is a Zig library with a C ABI. Platform-specific apps are thin consumers.

2. **Platform-native UI on top.** macOS app is real SwiftUI with native windowing, menu bars, settings GUI, Metal renderer, CoreText font discovery. Linux uses GTK. Not a least-common-denominator abstraction layer — each platform gets its native experience.

3. **GPU rendering.** The terminal grid is rendered on the GPU (Metal on macOS, OpenGL/Vulkan on Linux). This isn't about "making the terminal look pretty" — it's about consistent frame rates with large scrollback buffers and complex unicode rendering.

4. **Zig patterns for the core.** Hashimoto's talk details specific patterns: comptime for configuration validation, arena allocators for per-frame memory, zero-copy parsing of escape sequences.

**What experts actually think:**

- The Rust community (Feb 2024 AMA) was interested in why Hashimoto chose Zig over Rust. His answer: simpler compilation model, comptime is more powerful than Rust macros for his use cases, and C interop is trivial (critical for the C-ABI library design).
- The "custom UI framework in Rust/Zig is a huge investment" concern (from Warp's blog) is real. Hashimoto is betting that the investment pays off in control and performance.

**My assessment:** The architectural lesson here is **the library-core pattern for cross-platform applications.** Instead of an abstraction layer that homogenizes platforms (Electron, Qt), you build a headless library and write thin, native frontends. This gives you the best of both: shared core logic, native look and feel. The trade-off is maintaining multiple frontends — viable for a small number of platforms, impossible for "run everywhere."

**What to study:** The libghostty architecture (how the C ABI boundary is designed), the Zig patterns talk, the renderer architecture, the separation of terminal state from rendering.

---

### 8. Jujutsu (jj) — Version Control That Fixes Git's Conceptual Model

**Repo:** [github.com/jj-vcs/jj](https://github.com/jj-vcs/jj)
**Language:** Rust · **Started:** 2022 (Google)

**The hard problem:** Git's data model is elegant (see [classics file](exemplary-codebases-for-llm-context.md#git)), but its user model is broken. Working directory changes, staging area, stash, branches, HEAD — these are *different concepts* for what's fundamentally the same thing: "snapshots I'm working with." Can you fix the conceptual model while staying Git-compatible?

**The architectural bet:**

1. **Working copy is just another commit.** In jj, your uncommitted changes are automatically snapshotted into a "working copy commit" that updates continuously. There's no "staged vs unstaged" distinction. `git add` doesn't exist. Every state is a commit on a graph.

2. **First-class conflicts.** In Git, a merge conflict is an *error state* — you're in a broken "merging" state until you resolve it. In jj, conflicts are *data* — a conflicted file is just a file with conflict markers, and you can commit it, rebase it, or manipulate it like any other state. This means operations that would fail in Git (rebase with conflicts) just produce a commit with conflicts that you can fix later.

3. **Operation log.** Every jj operation (rebase, merge, checkout) is recorded in an undo log. You can `jj undo` any operation, including complex rebases. Git's reflog provides similar safety but is harder to use and doesn't cover all operations.

4. **Anonymous branches (no required bookmarks).** In Git, every commit must be reachable from a named reference or it gets garbage collected. In jj, all commits are preserved by default. "Branches" (called bookmarks) are optional labels, not structural requirements.

5. **Git-compatible backend.** jj stores data in a Git repository. Your collaborators don't need to know you're using jj. You push/pull to GitHub normally.

**What experts actually think:**

- Steve Klabnik: jj "takes the best of git, the best of Mercurial, and synthesizes it into something new, yet strangely familiar."
- The "Google uses it internally" fact provides confidence in the design, but Google also abandoned many internal tools.
- Critics worry about conceptual overhead: jj replaces Git's confusing model with a *different* model that also needs learning. The anonymous-branches-by-default behavior surprises Git users who expect garbage collection.

**My assessment:** jj's "working copy is a commit" and "conflicts are data, not errors" are the two most important conceptual improvements to version control since Git. Whether jj wins adoption depends on the Git ecosystem's inertia, but the *ideas* are correct. If you're designing any system that manages snapshots and changes (not just VCS — think document editors, database migrations, infrastructure-as-code), jj's conflict-as-data and operation-log patterns are transferable.

**What to study:** The conflict model, the operation log implementation, how the Git backend stores jj-native concepts, the [Steve Klabnik tutorial](https://steveklabnik.github.io/jujutsu-tutorial/).

---

## Tier 3: Specific Architectural Ideas to Extract

These aren't full "study the whole thing" recommendations. Each has one or two design ideas that are genuinely novel and worth knowing.

---

### 9. LiteFS — FUSE Filesystem for Distributed SQLite

**Repo:** [github.com/superfly/litefs](https://github.com/superfly/litefs)
**Language:** Go · **Author:** Ben Johnson (Fly.io)

**The idea:** Instead of modifying SQLite itself, put a FUSE (Filesystem in Userspace) layer *between the application and the database file*. LiteFS intercepts SQLite's file operations — it sees every write to the WAL (Write-Ahead Log) and replicates those writes to other nodes. The application thinks it's writing to a local file. It doesn't know replication exists.

**Why it's clever:** This is the *least invasive* possible approach to making SQLite distributed. No SQLite code changes. No application code changes. The distribution layer is below the filesystem boundary. The trade-off: FUSE adds overhead, single-writer (one primary), and eventual consistency on replicas. But for read-heavy workloads with a single write location, it's elegant.

**What to study:** The FUSE interception design, the WAL page set replication protocol, the Consul-based primary election.

---

### 10. Turso/libSQL — Forking the Unforkable

**Repo:** [github.com/tursodatabase/libsql](https://github.com/tursodatabase/libsql)
**Language:** C (SQLite fork) + Rust

**The idea:** Fork SQLite (which doesn't accept outside contributions) and add what the ecosystem needs: embedded replicas (a local SQLite that syncs from a remote primary), native HTTP server, vector search extensions, WASM-based user-defined functions, and an open contribution model.

**The hard problem they must solve:** Keeping the fork in sync with upstream SQLite while diverging enough to be useful. Every SQLite release, they must merge changes into a codebase that's increasingly different. This is the classic "friendly fork" dilemma — the further you diverge, the harder merging gets, but if you don't diverge, why fork?

**The "database-per-user" architecture** is the interesting vision: instead of one big database, every user gets their own SQLite database running at the edge. Turso's multi-tenant architecture claims to handle billions of databases. This inverts the traditional architecture where one database serves all users.

**What to study:** The embedded replica sync protocol, the multi-tenant database architecture, how they manage the upstream merge burden.

---

### 11. Pebble — Replacing Your Storage Engine Mid-Flight

**Repo:** [github.com/cockroachdb/pebble](https://github.com/cockroachdb/pebble)
**Language:** Go

**The idea:** CockroachDB was built on RocksDB (C++) via cgo bindings. cgo has overhead, debugging across the C/Go boundary is painful, and depending on an external storage engine limits your ability to optimize for your specific workload. So CockroachDB wrote their own LSM-tree storage engine in pure Go.

**The challenging problem:** Replacing the foundational storage layer of a distributed database *in production, without downtime*. Pebble had to be bug-for-bug compatible with RocksDB's file format (so existing databases could be opened), while being different enough to be worth building.

**Notable innovations:**
- **"Calling your shot" deletes:** `DeleteSized` records the expected size of the deleted value, allowing the compaction heuristics to more accurately estimate space amplification. Tiny optimization with large impact on space efficiency.
- **Range key support** designed specifically for CockroachDB's MVCC garbage collection — an example of a storage engine feature that only makes sense for one consumer but makes that consumer dramatically better.

**What to study:** The decision analysis for "build vs. depend" on storage engines, how they maintained compatibility during migration, the space amplification optimizations.

---

### 12. Oxc — Rust-Based JavaScript Toolchain at 100x Speed

**Repo:** [github.com/oxc-project/oxc](https://github.com/oxc-project/oxc)
**Language:** Rust

**The idea:** Rewrite JavaScript/TypeScript tooling (parser, linter, formatter, minifier, transformer) in Rust. Achieve 3-100x speedup over existing JS-based tools through zero-copy parsing, cache-friendly data structures, and native compilation.

**Why the speed matters architecturally:** At 100x speed, you can lint on every keystroke (not just on save). You can format the entire VS Code repository (4800+ files) in 0.7 seconds. You can run the parser as a library inside other tools without the parser being the bottleneck. **Speed enables new use patterns, not just faster old patterns.**

**Part of VoidZero's vision** (Evan You's unified toolchain): Oxc provides the parsing/linting layer, Rolldown provides bundling (Rollup-compatible, Rust-based), and together they replace the fragmented JS toolchain (ESLint + Prettier + Babel + Terser + Webpack/Rollup/esbuild).

**What to study:** The zero-copy parser architecture, how the AST is represented for cache efficiency, the plugin system design.

---

### 13. Valkey — Evolving Redis's Architecture From Within

**Repo:** [github.com/valkey-io/valkey](https://github.com/valkey-io/valkey)
**Language:** C · **Forked:** 2024

**The idea:** When Redis changed its license, the community forked as Valkey. But the interesting part isn't the fork — it's what happened next. Valkey immediately started making architectural changes that Redis's single-maintainer model had resisted for years.

**The key architectural change:** Multi-threaded I/O with a more aggressive approach than Redis 6.0's. Redis kept data manipulation single-threaded and only offloaded socket reads/writes. Valkey is pushing toward per-thread keyspace partitioning — moving closer to Dragonfly's shared-nothing model while maintaining Redis protocol compatibility.

**The broader lesson:** Community-governed forks can evolve architecturally faster than single-maintainer projects, because the "one person's taste" bottleneck is removed. Redis's golden-era code quality came from antirez's singular vision. Valkey's evolution comes from removing that constraint. Both approaches have value; they're optimizing for different things.

**What to study:** The I/O threading changes (compare Redis 7.x threading model to Valkey's), the community governance model, how they're managing backwards compatibility while evolving internals.

---

### 14. NATS — Messaging as Infrastructure Primitive

**Repo:** [github.com/nats-io/nats-server](https://github.com/nats-io/nats-server)
**Language:** Go

**The idea:** A messaging system so simple it can be a single static binary with zero configuration. Pub/sub, request/reply, queue groups — all with a protocol that fits on an index card. Then layer persistence (JetStream), object storage, and key-value on top of the same protocol.

**What makes it architecturally unique:**
- **Subject-based routing** instead of queues/exchanges. Messages go to subjects (like `orders.us.new`), and subscriptions use wildcards (`orders.*.new`, `orders.>`). The routing is a namespace, not a topology.
- **Leaf nodes and superclusters** for multi-region: edge clusters connect to hub clusters, forming a global mesh where any publisher can reach any subscriber without knowing the topology.
- **Single-threaded I/O loop in Go.** Unusual choice — Go's goroutines encourage multi-threaded designs, but NATS uses a single event loop for determinism and simplicity (echoing Redis's design philosophy).

**What to study:** The subject-based routing model, the leaf node federation architecture, the JetStream persistence layer design.

---

### 15. Tantivy — Lucene's Ideas, Rewritten With Memory Safety

**Repo:** [github.com/quickwit-oss/tantivy](https://github.com/quickwit-oss/tantivy)
**Language:** Rust

**The idea:** Apache Lucene is the foundation of Elasticsearch, Solr, and most full-text search. But it's Java, it's enormous, and its internal architecture evolved over 20+ years into something difficult to modify. Tantivy rebuilds Lucene's core ideas (inverted indexes, BM25 scoring, segment-based architecture) in Rust with modern design.

**The challenging problem:** Full-text search indexing is inherently complex — you need concurrent reads and writes, segment merging, custom tokenization, efficient posting list compression, and correct BM25 scoring. Doing this in Rust means solving the ownership and lifetime puzzles for concurrent data structures that are inherently mutation-heavy.

**Used by:** Quickwit (log search, Elasticsearch alternative), ParadeDB (Postgres-native search), Meilisearch (typo-tolerant search).

**What to study:** The [ARCHITECTURE.md](https://github.com/quickwit-oss/tantivy/blob/main/ARCHITECTURE.md), the segment merge strategy, the inverted index representation, how concurrent reads and writes are managed.

---

## Honorable Mentions: Worth Knowing Exists

| Project | Architectural idea | Hard problem |
|---------|-------------------|-------------|
| **Mojo** ([modular.com](https://docs.modular.com/mojo/)) | First language designed for MLIR (compiler IR). Python syntax, systems-level performance. | Can you make Python-syntax code as fast as C++ for AI workloads by targeting MLIR natively? Still closed-source compiler. Jury out. |
| **Roc** ([roc-lang.org](https://www.roc-lang.org)) | Platform/application separation — your app is pure functions, the platform provides all I/O. | Can you make functional programming practical by making I/O someone else's problem (literally)? Echoes Lua's "punt hard parts" strategy. |
| **SerenityOS** ([github.com/SerenityOS/serenity](https://github.com/SerenityOS/serenity)) | OS from scratch with a "no third-party code" policy. Every component (browser engine, GUI toolkit, shell) written by the community. | Can a community build an OS without standing on anyone's shoulders? The browser engine (now Ladybird) is being spun out as a standalone project. |
| **CockroachDB** ([github.com/cockroachdb/cockroach](https://github.com/cockroachdb/cockroach)) | Spanner-inspired distributed SQL with serializable isolation, without Google's atomic clocks. Uses hybrid-logical clocks instead. | Can you build globally-consistent SQL without specialized hardware? The clock-skew problem is unsolved in general — CockroachDB bounds it. |
| **ClickHouse** ([github.com/ClickHouse/ClickHouse](https://github.com/ClickHouse/ClickHouse)) | Columnar OLAP with MergeTree engine — data is sorted, merged, and compressed in the background. Sparse primary indexes. | Extreme analytical query speed on append-mostly data. The MergeTree design trades write amplification for read performance. |
| **etcd/Raft** ([github.com/etcd-io/raft](https://github.com/etcd-io/raft)) | The most widely-used Raft implementation (powers Kubernetes). Clean separation of Raft state machine from I/O. | Library Raft: the application drives the I/O, Raft just manages state transitions. This inversion makes it embeddable anywhere. |

---

## The Meta-Pattern: What Makes These Different From the Classics

The [classics](exemplary-codebases-for-llm-context.md) succeed through **constraint** (refusing features). These modern projects succeed through **inversion** (doing the opposite of convention):

| Project | The convention | The inversion |
|---------|---------------|---------------|
| TigerBeetle | Databases use many threads | Single commit thread + io_uring |
| DuckDB | Analytics requires servers | In-process, embedded OLAP |
| Dragonfly | Redis must be single-threaded | Shared-nothing multi-core |
| vLLM | GPU memory is statically allocated | Paged virtual memory for KV cache |
| Redpanda | Event streaming runs on JVM | Thread-per-core C++ via Seastar |
| Ghostty | Cross-platform = abstraction layer | Library core + native frontends |
| Jujutsu | Working dir ≠ commits | Working dir IS a commit |
| LiteFS | Distributed DB requires DB changes | FUSE layer below the DB |
| Turso | One database serves all users | Database per user at the edge |
| Pebble | Use an existing storage engine | Build your own, mid-production |
| Oxc | JS tools written in JS | JS tools written in Rust, 100x faster |

**The common thread:** Each inversion is enabled by a specific technical insight that the conventional approach overlooked. vLLM's insight is "OS virtual memory solved this." DuckDB's insight is "most data fits on one machine." TigerBeetle's insight is "lock contention costs more than single-threading." These aren't random contrarianism — they're cases where the conventional wisdom was built on assumptions that no longer hold (hardware changed, workloads changed, or the assumption was always wrong).

---

## How to Use This List

1. **For architectural taste:** Read TigerBeetle's ARCHITECTURE.md, FoundationDB's testing docs, and the vLLM paper. These three together cover the three hardest problems in modern systems: storage, distributed consensus, and GPU resource management.

2. **For design patterns you can steal:** Thread-per-core (Redpanda/Seastar), library-core + native-frontend (Ghostty), conflict-as-data (Jujutsu), FUSE-interposition (LiteFS), PagedAttention (vLLM).

3. **For LLM context when building:** Put TIGER_STYLE.md in context for engineering discipline. Put DuckDB's extension system docs in context when building plugin architectures. Put jj's conflict model docs in context when designing merge/sync systems.

4. **For understanding what "novel" actually means:** Notice how many of these are cross-domain transfers (vLLM ← OS, LiteFS ← filesystems, TigerBeetle ← FoundationDB's testing). The best architectural innovations come from recognizing that someone already solved your problem in a different field.

---

---

## Critical Self-Review: What's Wrong With This List

**Added:** February 26, 2026 (second pass after research and self-critique).

### 1. The "Inversion" Thesis Is Partly Narrative, Not Analysis

I framed every project as "inverting convention." But not all of them actually do. DuckDB doesn't *invert* "analytics needs a server" — it *transfers* SQLite's design to OLAP. That's not an inversion; it's an application of an existing pattern to a new domain. Ghostty doesn't invert anything — "library core + native frontends" is the standard pattern for any serious cross-platform project (every game engine, every multimedia framework). I was retrofitting a clean narrative onto messy reality.

The honest version: some of these are genuine inversions (TigerBeetle's single-thread, Dragonfly's shared-nothing), some are cross-domain transfers (vLLM ← OS paging), some are incremental improvements (Valkey over Redis), and some are just "good engineering" without a novel architectural idea (Tantivy). Lumping them all under "inversion" makes the list feel more coherent than it is. **Beware of narrative coherence as a substitute for analytical precision.**

### 2. Massive Database Bias — The Dog That Isn't Barking

Count the entries: TigerBeetle (DB), DuckDB (DB), FoundationDB (DB), Dragonfly (cache/DB), Pebble (storage engine), Turso/libSQL (DB), Valkey (cache/DB), NATS (messaging), Tantivy (search index). That's **9 out of 15 entries** in the data infrastructure category. Plus ClickHouse, CockroachDB, and etcd in honorable mentions. This isn't a "list of architecturally remarkable projects" — it's a **database showcase with a few guests.**

**What's missing entirely:**

- **Operating systems / kernels:** bcachefs (copy-on-write filesystem with B-tree innovations — log-structured nodes inside B-trees, snapshot versioning without COW tree cloning), io_uring itself (the Linux async I/O subsystem that TigerBeetle depends on — arguably more architecturally interesting than TigerBeetle)
- **Networking / eBPF:** Cilium (eBPF-based networking that bypasses the entire Linux network stack — iptables replacement in the kernel, programmable datapath). This is a genuine architectural revolution happening in Kubernetes networking and I didn't mention it.
- **Build systems:** Buck2 (Meta's Rust rewrite of Buck, with a dynamic/monadic computation graph inspired by build system theory — "Build Systems à la Carte" paper). Turbopack (incremental memoization framework for bundling, inspired by Salsa/Rust-Analyzer). These solve a genuinely hard problem: correct incrementality in build graphs.
- **ML infrastructure beyond serving:** llama.cpp / GGML — arguably the most impactful single project in the local AI revolution. Georgi Gerganov, one person, made LLMs run on consumer laptops. The GGML tensor library is architecturally interesting: pure C, no dependencies, custom quantization formats (GGUF), cross-platform inference on CPU/GPU/NPU. Simon Willison (Feb 2026): "It's hard to overstate the impact Georgi Gerganov and llama.cpp have had on the local model space." This is a *glaring* omission.
- **Serverless Postgres:** Neon (storage-compute separation for PostgreSQL — compute nodes write to a shared WAL service, page service handles reads, branching via copy-on-write page references). This is "what if Aurora but open-source" and the architecture is genuinely novel.
- **JS runtimes:** Bun (Zig + JavaScriptCore, all-in-one runtime/bundler/test-runner). The architectural bet is "one tool replaces Node + npm + webpack + jest" via a monolithic runtime written in a systems language. Worth studying for the "monolith vs. ecosystem" design tension.
- **WebAssembly Component Model:** A cross-language, shared-nothing component system with interface types, a genuinely hard problem in language interop. Not a single project but a standards-level architectural innovation.
- **CRDTs in practice:** Corrosion (Fly.io's distributed service discovery using gossip protocol + CR-SQLite for conflict resolution). The interesting idea: use CRDTs to make SQLite eventually consistent across a cluster. Each node owns specific rows, gossip propagates changes, CRDTs resolve conflicts. This is "distributed SQLite" from a completely different angle than LiteFS or Turso.

### 3. ScyllaDB: The Missing Progenitor

This is the most embarrassing omission. I described Redpanda's thread-per-core architecture as if it were Redpanda's innovation. **It isn't. ScyllaDB invented it.** ScyllaDB (2015) created the Seastar framework and the entire shard-per-core model. Redpanda (2020) adopted Seastar from ScyllaDB. Crediting Redpanda for the architecture without featuring ScyllaDB is like crediting Chrome for V8 without mentioning Node.js... actually it's worse, because ScyllaDB literally *wrote the framework Redpanda uses.*

**ScyllaDB deserves its own Tier 1 entry:**

- **Repo:** [github.com/scylladb/scylladb](https://github.com/scylladb/scylladb) + [github.com/scylladb/seastar](https://github.com/scylladb/seastar)
- **Founded by:** Avi Kivity (creator of KVM, the hypervisor underlying most production clouds) and Dor Laor — these aren't random startup founders; they built the virtualization layer the cloud runs on, then applied the same kernel-bypass, per-core-sharding philosophy to databases.
- **The architectural bet:** Take Cassandra's data model (wide-column, distributed, eventual consistency) and rewrite it in C++ with thread-per-core, NUMA-aware memory allocation, userspace I/O scheduling, and zero GC. Same API, 10x fewer nodes.
- **The production evidence is real:** Discord migrated *trillions* of messages from Cassandra to ScyllaDB (Bo Ingram, 2023). 177 Cassandra nodes → dramatically fewer ScyllaDB nodes. The migration blog is one of the best real-world architecture case studies available. Their Cassandra problems: unpredictable latency, GC pauses, compaction backlogs, constant paging. ScyllaDB's shard-per-core eliminated the GC entirely and gave each core its own compaction schedule.
- **The hard problem ScyllaDB had to solve that Redpanda didn't:** Cooperative scheduling in a database context. When everything is one thread per core, *any blocking operation stalls the entire core*. ScyllaDB had to build a userspace disk I/O scheduler, a userspace CPU scheduler (with priority classes for reads vs. writes vs. compaction vs. repair), and a custom memory allocator — all to avoid ever blocking. Their 2017 blog on CPU-bound optimization goes down to PMU counters and instruction-per-cycle analysis. This is operating-system-level work inside a database.
- **What Seastar (ScyllaDB's framework) actually provides:** Single-producer/single-consumer lock-free queues for inter-core communication, custom memory barriers optimized for x86 (they wrote a detailed blog post on this), cooperative task scheduling, a futures/promises model that's *not* based on threads. The Seastar tutorial is the best introduction to thread-per-core programming that exists.

**Why I missed it:** Survivorship bias in my search queries. I searched for "modern 2020-2026 projects." ScyllaDB started in 2015. It fell outside my date filter. But the Seastar *pattern* is a 2015 innovation that's still being adopted — Redpanda (2020), Dragonfly-style shared-nothing (2022). The progenitor is more architecturally interesting than its children.

### 4. Insufficient Counter-Evidence for Projects I Did Cover

**TigerBeetle:** I noted the Oct 2025 scrutiny but didn't stress: the "1000x faster" claims were from their *own investor's blog post* (Amplify Partners). Independent verification is thin. The single-threaded architecture that I praised has a concrete ceiling: one core's throughput, period. Their answer ("you can have another core once you've saturated the first one") is witty but doesn't address the scaling question for workloads that *do* saturate a core.

**vLLM:** I praised PagedAttention without noting that SGLang (from the same UC Berkeley group) is now *outperforming* vLLM on multi-turn conversations through better KV cache reuse strategies. r/LocalLLaMA (Mar 2025): "SGLang crushes it with Data Parallelism." vLLM is also "crashier than SGLang" on some hardware. The architectural idea (paged KV cache) remains brilliant, but the *project*'s dominance is already being challenged — within 2 years of the paper.

**Jujutsu:** I didn't mention the real adoption blockers: no Git LFS support, no submodules, no .gitattributes. An HN commenter (Sep 2025) returned to Git because jj doesn't have named branches, breaking their shared-branch workflow. The conceptual model is elegant but the missing features are precisely the "ugly but necessary" parts of Git that real teams depend on. This is a Plan-9-style risk: conceptual purity that can't handle messy reality.

**Redpanda:** The thread-per-core model's difficulty is real but I understated it. Cooperative scheduling means *any* CPU-intensive operation (compression, encryption, serialization) must be manually broken into small chunks that yield control. This is viral — every line of code in the system must be aware of the scheduling model. One blocking call, anywhere, stalls the core. This is why Seastar-based development is restricted to a small number of teams: the programming model is hostile to normal engineering.

### 5. Missing Meta-Observation: The C++ / Rust / Zig Axis

Almost every project on this list is written in C++, Rust, or Zig. Zero are in Java, Go, Python, or JavaScript (the languages most software is actually written in). This is a selection bias: I was looking for *architectural* novelty, and the interesting architectural decisions tend to happen at the systems level where C++/Rust/Zig operate.

But this means the list is nearly useless for learning architectural lessons applicable to **application-level software** — web services, API backends, mobile apps, data pipelines. A web developer studying TigerBeetle's io_uring integration won't extract anything they can use in their Express.js API. The transferable lessons are at the *philosophy* level (constraint, simulation testing, cross-domain transfer), not at the implementation level.

### 6. The "Novel" Bar Is Inconsistent

- **Genuinely novel:** TigerBeetle's simulation testing in Zig, vLLM's PagedAttention, Jujutsu's conflict-as-data model, ScyllaDB's shard-per-core (in 2015 it was genuinely new)
- **Well-executed but not novel:** DuckDB (columnar embedded DB existed — MonetDB/e, then MonetDBLite), Oxc (rewriting JS tools in Rust is the same bet as esbuild/swc/Biome, they're just faster at it), Tantivy (Lucene-in-Rust, explicitly derivative), Valkey (Redis fork with engineering improvements)
- **Novel framing of existing ideas:** Ghostty (library-core is standard), NATS (subject-based routing has been around for decades), LiteFS (FUSE interposition is a well-known technique)

I should have been more honest about this gradient instead of presenting everything as equally novel.

---

## Additions From Self-Review

### ScyllaDB + Seastar — The Progenitor of Thread-Per-Core

**Repo:** [github.com/scylladb/scylladb](https://github.com/scylladb/scylladb) + [github.com/scylladb/seastar](https://github.com/scylladb/seastar)
**Language:** C++ · **Started:** 2015 · **Founders:** Avi Kivity (KVM creator), Dor Laor

**Should be Tier 1.** ScyllaDB invented the shard-per-core model that Redpanda and others adopted. Avi Kivity brought kernel-level thinking (from building KVM) to database architecture. The Seastar framework is the foundational innovation — lock-free inter-core SPSC queues, cooperative scheduling, userspace I/O scheduler, NUMA-aware memory allocation. Discord's migration from Cassandra (trillions of messages, 177 → fewer nodes) is the strongest production validation on this list.

**The hard problem ScyllaDB uniquely had to solve:** Making cooperative scheduling work for a database. Unlike Redpanda (which processes relatively simple message append/read operations), ScyllaDB must handle complex operations: range scans, secondary index lookups, materialized view maintenance, repair, compaction — all without blocking. Every operation must yield cooperatively. This required building a complete userspace OS inside the database: CPU scheduler with priority classes, I/O scheduler with bandwidth allocation, memory allocator with per-core pools.

**What to study:** The [Seastar tutorial](https://github.com/scylladb/seastar/blob/master/doc/tutorial.md), the I/O scheduler blog series, the memory barrier optimization blog, and the Discord migration post.

### llama.cpp / GGML — One Person Changes Local AI

**Repo:** [github.com/ggml-org/llama.cpp](https://github.com/ggml-org/llama.cpp) + [github.com/ggml-org/ggml](https://github.com/ggml-org/ggml)
**Language:** C/C++ · **Author:** Georgi Gerganov · **Started:** March 2023

**Should be Tier 2 at minimum.** Gerganov made LLaMA run on a MacBook in an evening. The first README (March 10, 2023): "The main goal is to run the model using 4-bit quantization on a MacBook. [...] This was hacked in an evening - I have no idea if it works correctly."

**The architectural ideas worth studying:**

1. **GGML tensor library:** Pure C, no dependencies, strict memory management (pre-allocated contiguous blocks for cache locality), custom quantization formats. The design mirrors SQLite's philosophy: minimal, embeddable, zero dependencies.
2. **GGUF format:** A self-describing binary format for model serialization with extensible metadata, backward compatibility, and cross-platform support. Solves the "how do you ship a model" problem cleanly.
3. **Multi-backend abstraction:** CPU (x86 AVX/AVX2/AVX-512, ARM NEON), GPU (CUDA, Metal, Vulkan, SYCL, HIP), NPU — all behind a unified interface. The backend abstraction lets the same model run on any hardware without code changes.
4. **4-bit quantization making inference accessible:** The key insight: you don't need full-precision weights for inference. 4-bit quantization with clever block-based schemes (Q4_K_M, Q5_K_M) retains most quality at 1/4 the memory. This is what made "LLMs on consumer hardware" possible.

**Why it's remarkable:** This is the strongest modern example of the SQLite/Redis pattern — solo author, C, no dependencies, extreme portability, disproportionate impact. Gerganov is to local AI what drh is to embedded databases. GGML just joined Hugging Face (Feb 2026) for long-term sustainability.

### Neon — Serverless Postgres via Storage-Compute Separation

**Repo:** [github.com/neondatabase/neon](https://github.com/neondatabase/neon)
**Language:** Rust + C (Postgres) · **Started:** 2021

**The hard problem:** PostgreSQL is a monolith — compute and storage are coupled. You can't scale them independently. You can't branch a database like you branch code. You can't scale to zero (idle databases still consume resources).

**The architectural bet:** Split Postgres into a stateless compute layer and a shared storage layer:
- **Compute nodes** run standard Postgres but write WAL to a shared **Safekeeper** service instead of local disk.
- **Pageserver** stores actual data pages, serving them to compute on demand (like a network-attached page cache).
- **Branching** is copy-on-write at the page level — creating a branch is near-instant regardless of database size.
- **Scale to zero:** When no queries arrive, compute shuts down completely. Storage persists independently.

**Why it matters:** This is the "Aurora but open-source" bet. AWS Aurora proved storage-compute separation works for OLTP databases. Neon does it with standard Postgres, in Rust, open-source. Jack Vanlightly's analysis (Nov 2023) provides rigorous technical evaluation.

### Cilium — eBPF Replaces the Linux Network Stack

**Repo:** [github.com/cilium/cilium](https://github.com/cilium/cilium)
**Language:** Go + C (eBPF programs) · **Started:** 2016

**The hard problem:** Kubernetes networking uses iptables — a 20-year-old packet filtering system that doesn't scale. With thousands of services, iptables rules become a performance bottleneck and a debugging nightmare. Can you replace the entire Linux network stack for container networking?

**The architectural bet:** Write networking, security, and observability logic as eBPF programs that run *inside the Linux kernel* — bypassing iptables, kube-proxy, and the traditional network stack entirely. Packets are processed at the XDP (eXpress Data Path) layer before they even reach the TCP/IP stack.

**Why it's remarkable:** This is one of the few projects that genuinely changes the platform it runs on. Cilium doesn't work *on top of* Linux networking — it *replaces* it. The eBPF programs are JIT-compiled, verified by the kernel's eBPF verifier (provably safe), and run at near-hardware speed. This is a genuine paradigm shift in how container networking works, and it's becoming the default CNI for major Kubernetes distributions.

---

## Sources

- [TigerBeetle ARCHITECTURE.md](https://github.com/tigerbeetle/tigerbeetle/blob/main/docs/internals/ARCHITECTURE.md)
- [TigerBeetle Architecture — Lobsters discussion](https://lobste.rs/s/b5buoi/tigerbeetle_architecture)
- [InfoQ: A New Era for Database Design with TigerBeetle](https://www.infoq.com/presentations/tigerbeetle/) — Joran Greef talk transcript
- [FoundationDB: Simulation and Testing](https://apple.github.io/foundationdb/testing.html)
- [Pierre Zemb: Diving into FoundationDB's Simulation Framework](https://pierrezemb.fr/posts/diving-into-foundationdb-simulation/) (Oct 2025)
- [Pierre Zemb: DST Learning Resources](https://pierrezemb.fr/posts/learn-about-dst/) (Apr 2025)
- [Antithesis: Deterministic Simulation Testing](https://antithesis.com/resources/deterministic_simulation_testing/)
- [vLLM: PagedAttention Paper (SOSP 2023)](https://arxiv.org/abs/2309.06180)
- [vLLM Blog: Easy, Fast, Cheap LLM Serving](https://blog.vllm.ai/2023/06/20/vllm.html)
- [Redpanda: Thread-per-core buffer management](https://www.redpanda.com/blog/tpc-buffers) (Sep 2025)
- [InfoQ: Adventures in Thread-per-Core Async](https://www.infoq.com/presentations/high-performance-asynchronous3/)
- [Dragonfly vs Redis Architecture Comparison](https://www.dragonflydb.io/guides/redis-and-dragonfly-architecture-comparison)
- [Ghostty: About](https://ghostty.org/docs/about) + [How Warp Works](https://www.warp.dev/blog/how-warp-works) (contrast)
- [Mitchell Hashimoto: Ghostty and Zig Patterns talk](https://mitchellh.com/writing/ghostty-and-useful-zig-patterns)
- [Jujutsu: Steve Klabnik tutorial](https://steveklabnik.github.io/jujutsu-tutorial/)
- [LiteFS: How It Works](https://fly.io/docs/litefs/how-it-works/)
- [Introducing LiteFS — Fly.io Blog](https://fly.io/blog/introducing-litefs/)
- [Turso/libSQL README](https://github.com/tursodatabase/libsql)
- [CockroachDB: Introducing Pebble](https://www.cockroachlabs.com/blog/pebble-rocksdb-kv-store/)
- [Oxc: Benchmarks](https://oxc.rs/docs/guide/benchmarks)
- [Valkey vs Redis Architecture](https://andrewbaker.ninja/2026/01/04/redis-vs-valkey-a-deep-dive-for-enterprise-architects/)
- [NATS About](https://nats.io/about/)
- [Tantivy ARCHITECTURE.md](https://github.com/quickwit-oss/tantivy/blob/main/ARCHITECTURE.md)
- [DuckDB Academic Overview](https://clickhouse.com/docs/academic_overview) + [DuckDB Beyond the Hype](https://www.pracdata.io/p/duckdb-beyond-the-hype)
- Own notes: [Exemplary Codebases (Classics)](exemplary-codebases-for-llm-context.md), [Counter-Evidence](exemplary-codebases-counter-evidence.md), [HN: DuckDB as First Choice](hn-duckdb-first-choice-data-processing.md)

### Self-Review Sources (second pass)
- [ScyllaDB Shard-per-Core Architecture](https://www.scylladb.com/product/technology/shard-per-core-architecture/)
- [Why ScyllaDB's Shard Per Core Architecture Matters (Oct 2024)](https://www.scylladb.com/2024/10/21/why-scylladbs-shard-per-core-architecture-matters/) — Dor Laor, Bo Ingram, Tzach Livyatan perspectives
- [How Discord Stores Trillions of Messages (Aug 2023)](https://discord.com/blog/how-discord-stores-trillions-of-messages) — Bo Ingram, Cassandra → ScyllaDB migration
- [Seastar Memory Barriers Blog](https://www.scylladb.com/2018/02/15/memory-barriers-seastar-linux/) — inter-core communication optimization
- [ScyllaDB I/O Scheduler Design (2016)](https://www.scylladb.com/2016/04/14/io-scheduler-1/) — userspace disk I/O scheduling
- [ScyllaDB CPU-Bound Optimization (2017)](https://www.scylladb.com/2017/07/06/scyllas-approach-improve-performance-cpu-bound-workloads/) — PMU analysis, IPC optimization
- [40 Cassandra Nodes vs 4 ScyllaDB Nodes Benchmark](https://thenewstack.io/benchmarking-apache-cassandra-40-nodes-vs-scylladb-4-nodes/)
- [Simon Willison on llama.cpp impact (Feb 2026)](https://news.ycombinator.com/item?id=47090880)
- [llama.cpp Wikipedia](https://en.wikipedia.org/wiki/Llama.cpp) — history, GGML origins
- [GGML Technical Architecture (Oreate AI)](https://www.oreateai.com/blog/practical-quantization-of-llama-models-detailed-explanation-of-gguf-and-llamacpp-technologies/)
- [Neon Architecture Overview](https://neon.com/docs/introduction/architecture-overview)
- [Jack Vanlightly: Neon Serverless PostgreSQL Analysis (Nov 2023)](https://jack-vanlightly.com/analyses/2023/11/15/neon-serverless-postgresql-asds-chapter-3)
- [Neon: Storage-Compute Separation Performance (Jul 2025)](https://neon.com/blog/separation-of-storage-and-compute-perf)
- [Cilium GitHub + eBPF Architecture](https://docs.cilium.io/en/v1.13/bpf/architecture/)
- [Fly.io Corrosion: Gossip + CRDTs + SQLite](https://fly.io/blog/corrosion/)
- [Buck2: Why Buck2](https://buck2.build/docs/about/why/)
- [Turbopack Incremental Computation (Jan 2026)](https://nextjs.org/blog/turbopack-incremental-computation)
- [Bun: Why Zig for JavaScriptCore](https://www.reddit.com/r/Zig/comments/16ho53m/why_did_the_bunjs_team_use_zig_to_create_bun/)
- [SGLang vs vLLM KV Cache Reuse](https://www.runpod.io/blog/sglang-vs-vllm-kv-cache)
- [Jujutsu adoption barriers (HN Sep 2025)](https://news.ycombinator.com/item?id=45083952)
- [TigerBeetle scrutiny (BigGo Oct 2025)](https://biggo.com/news/202510011913_TigerBeetle_Database_Community_Scrutiny)
