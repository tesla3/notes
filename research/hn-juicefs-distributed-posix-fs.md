← [Index](../README.md)

## HN Thread Distillation: "JuiceFS is a distributed POSIX file system built on top of Redis and S3"

**Article summary:** JuiceFS is an Apache-2.0-licensed distributed filesystem that splits storage into data chunks on S3 (or any object store) and metadata on a pluggable engine (Redis, MySQL, PostgreSQL, TiKV, FoundationDB, etc.). It claims full POSIX compliance, strong consistency, and cloud-native support via Kubernetes CSI. The architecture is chunk/slice/block — files are broken into opaque pieces on S3, making the metadata store the single source of truth for filesystem structure.

### Dominant Sentiment: Cautiously impressed, operationally wary

The thread treats JuiceFS as a proven tool (186 upvotes, multiple production users reporting in) rather than a novelty. But almost every positive take is qualified by a specific operational concern — metadata durability, FUSE limitations, small-file performance, or the opacity of the chunk format on S3. The thread was likely catalyzed by tptacek's Sprites post, which uses a heavily modified JuiceFS fork.

### Key Insights

**1. The metadata store is the real product; JuiceFS is just the glue**

The thread's central debate isn't about JuiceFS per se — it's about which metadata backend you pick and whether that choice undermines the entire value proposition. staticassertion opens with the sharpest framing: "Why would I care about distributed storage on a system like S3, which is all about consistency/durability/availability guarantees, just to put my metadata into Redis?" The official benchmarks confirm Redis is 2–4x faster than alternatives for pure metadata ops, but this advantage vanishes on large I/O where S3 dominates. This means the headline benchmarks (using Redis) overstate real-world performance for anyone who cares about durability.

JuiceFS co-founder suavesu and TiKV co-founder c4pt0r both confirm that at scale (100+ PiB, 10B+ files), TiKV is the recommended metadata backend. The Redis headline is effectively marketing for small/medium deployments.

**2. The Redis durability debate reveals a philosophical split, not a technical one**

bastawhiz argues Redis with AOF `appendfsync always` is "perfectly reasonable" for this workload. danpalmer counters that if you're running Redis in always-fsync mode, you've sacrificed almost all of Redis's speed and should just use a proper database. Both are technically correct but talking past each other. The real question is: does the metadata workload actually need in-memory speed? The JuiceFS benchmarks themselves show metadata operations in the hundreds-of-microseconds range for Redis — fast, but not so fast that a well-tuned PostgreSQL (1.5–2x slower on writes, 4x on reads) couldn't serve. The Redis choice is an optimization for the demo benchmark, not a necessity.

**3. FUSE is the hidden tax nobody prices in**

huntaub (who built NFS/Lustre products at AWS) delivers the thread's most forward-looking claim: "2026 is going to be filled with people finding this out the hard way as they pivot towards FUSE for agents." The compatibility surface is deceptively large — git clone needs unlink-while-open, vim needs renames and hardlinks, SQLite won't work on JuiceFS at all. mrkurt confirms: "FUSE is full of gotchas. I wouldn't replace NFS with JuiceFS for arbitrary workloads." IshKebab pushes back that these are just standard POSIX features you have to implement, but huntaub's point is subtler — the long tail of per-application compatibility work is unbounded, and each edge case manifests as a mysterious production failure.

**4. The Sprites team validated the architecture by gutting the implementation**

tptacek: "we tore out a lot of the metadata stuff, and our metadata storage is SQLite + Litestream.io." This is a strong signal that JuiceFS's *design* (separate data plane on object storage, metadata plane on fast local storage) is sound, but the specific implementation choices are negotiable. Litestream gives them durable writes replicated to S3 without the operational burden of Redis/TiKV. The Sprites approach trades horizontal metadata scaling for operational simplicity — which is the right trade for a single-writer architecture.

**5. ZeroFS benchmarks are inflammatory but not credible**

Eikon (ZeroFS author) posted benchmarks showing 175–227x performance advantages. The thread correctly identified multiple red flags: 92% of JuiceFS data modification operations "failed" (suggesting misconfiguration, not real failure), no JuiceFS setup details are published despite the benchmark code being open source, and ZeroFS is single-writer (one read-write instance, multiple read-only) which is a fundamental architectural constraint that invalidates direct comparison. huntaub and wgjordan pressed on methodology; Eikon deflected to "submit a PR." As __turbobrew__ noted: "It is like saying I can write a faster etcd by only having a single node."

The meta-dynamic: Eikon's counter-accusation that huntaub runs a VC-backed competitor (Archil) was fair disclosure, but also revealed that this subthread was essentially three competing storage companies sniping at each other.

**6. Real production reports cluster around "works great with caveats"**

adamcharnock: running JuiceFS on bare-metal K8s with Valkey + MinIO, saturating 25G NIC with 16+ concurrent users. Saw file corruption with zero-redundancy MinIO (MinIO's fault, not JuiceFS). eerikkivistik: tested at multi-PB scale for satellite/geo workloads, found the open-source version slower than the commercial one, and metadata backend choice critical for latency. willbeddow (Krea): moved away because they couldn't get sufficient training performance, and the metadata store location forced single-datacenter use. The pattern: JuiceFS works well for read-heavy, large-file workloads with a co-located metadata store. It struggles with write-heavy, small-file, or multi-region scenarios.

**7. The "POSIX on S3 is inverted" argument is emotionally satisfying but practically wrong**

hsn915: "We need a kernel native distributed file system so that we can build distributed storage/databases on top of it. This is like building an operating system on top of a browser." satoru42 delivers the perfect counter: "Show me an operating system built on top of a browser that can be used to solve real-world problems like JuiceFS." The inversion argument ignores that S3 is effectively infinite durable storage with a simple API — exactly the kind of substrate you want for data, as long as you handle metadata properly. The whole point of JuiceFS is that POSIX semantics are the hard part, and S3 is the easy part.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Redis isn't durable enough for filesystem metadata | Strong | Valid concern; official recommendation at scale is TiKV, not Redis |
| FUSE has too many gotchas for production use | Strong | Multiple experienced practitioners confirm; SQLite specifically won't work |
| Opaque chunk format means losing metadata = losing data | Medium | True but mitigated by metadata backup to S3; same failure mode as ZFS losing its metadata device |
| POSIX over S3 is architecturally inverted | Weak | Ignores that thousands of production deployments validate the approach |
| ZeroFS is 175x faster | Misapplied | Single-writer architecture, dubious methodology, 92% "failure" rate suggests misconfiguration |

### What the Thread Misses

- **The AI training pipeline is the real driver.** Multiple comments reference ML/AI workloads, but nobody connects the dots: the explosion of GPU clusters needing shared access to massive training datasets is why JuiceFS exists *now* rather than five years ago. The MLPerf benchmark link from suavesu goes unexamined.
- **Multi-region metadata is the unsolved problem.** willbeddow's experience at Krea (metadata store location forces single-datacenter) is a fundamental limitation that nobody drills into. For globally distributed AI inference, this is a dealbreaker that no metadata backend choice can fix.
- **The commercial vs. open-source gap.** eerikkivistik mentions the open-source version is slower, but nobody asks *how much slower* or *what's behind the paywall*. This matters because JuiceFS's pitch is open-source, but its production viability may depend on the commercial offering.
- **Cost modeling is absent.** S3 API operations aren't free. aeblyve mentions JuiceFS is "wasteful in terms of S3 operations" at scale with "meaningful cost," but nobody runs the numbers. For PB-scale deployments, the S3 PUT/GET costs could dwarf the storage costs.

### Verdict

JuiceFS has won the "POSIX filesystem over object storage" category by default — it's the only mature, production-validated option with pluggable metadata backends and real horizontal scaling. But the thread reveals that its headline pitch (Redis + S3) is the *worst* way to run it: Redis is a durability liability, and the benchmarks using it are misleading for production planning. The real JuiceFS is TiKV/PostgreSQL + S3 with aggressive local caching, and that's a significantly more complex operational story than the README suggests. What the thread circles but never states outright: JuiceFS is less a filesystem and more a protocol for teaching legacy POSIX applications to speak object storage — and its real competition isn't other filesystems, but the slow migration of applications to native S3 APIs, which makes the entire POSIX compatibility layer unnecessary.
