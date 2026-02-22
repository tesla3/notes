← [Lean 4 HN Thread](hn-lean4-theorem-prover-ai.md) · [Index](../README.md)

# Formal Verification Tools: Who Uses What and Why

Companion to the [Lean 4 HN thread distillation](hn-lean4-theorem-prover-ai.md). The thread surfaced four alternatives to Lean 4 for formal verification. This maps each tool to its actual users, domains, and trade-offs.

## The Landscape

### TLA+ — Distributed systems at scale

**Primary user: Amazon Web Services.** Since 2011, AWS engineers have used TLA+ for formal specification and model checking of critical distributed systems. Their landmark 2014 CACM paper reports 7+ teams finding high value, preventing "subtle, serious bugs from reaching production, bugs that we would not have found via any other technique." Used on S3, DynamoDB, EBS, and internal lock managers. AWS continues to invest — their 2025 CACM paper on "Systems Correctness Practices" lists TLA+ as a core tool alongside Dafny and Lean.

**Other users:** Microsoft (Cosmos DB), Elastic (Elasticsearch replication), CockroachDB (Raft consensus). Mostly infrastructure teams at companies where a distributed systems bug costs millions.

**Method:** Model checking — specifies *behaviors over time* (sequences of states), then exhaustively checks finite instances against temporal properties like "no two nodes ever hold the same lock simultaneously." Does not verify code directly; verifies a model of the system's design.

**AI/LLM ecosystem:** Minimal. upghost in the HN thread reports using AI assistance with TLA+ but flags that AI was "proving things that were either trivial or irrelevant to the problem at hand."

### Dafny — Software verification at Amazon

**Primary user: Amazon.** Dafny is used for **Cedar**, AWS's authorization policy language — formally verified for security properties with proofs compiled to production-ready code. Amazon also teaches Dafny internally to engineers as their program verification tool of choice, with [published course material](https://dafny.org/blog/2023/12/15/teaching-program-verification-in-dafny-at-amazon/). Their paper on "Formally Verified Cloud-Scale Authorization" describes using Dafny to build an "efficient, imperative, verification-aware implementation."

**Other users:** Microsoft Research (where it was created by Rustan Leino, who also built Spec#, ESC/Java). Smaller community than Lean but more production-oriented.

**Method:** Auto-active verification. Looks like C#/Java with pre/postconditions and loop invariants. Engineers can read and write it without learning type theory. The SMT solver (Z3) handles most proof obligations automatically — you only intervene when automation fails. The [miniF2F-Dafny paper](https://arxiv.org/html/2512.10187) (Feb 2026) shows Dafny's automation alone solves 39-44% of math benchmark problems with empty proofs; with Claude Sonnet 4.5, 55.7%.

**AI/LLM ecosystem:** Growing. The miniF2F-Dafny benchmark explicitly frames "effective division of labor: LLMs provide high-level guidance while automation handles low-level details." This may be the most practical near-term path for AI-assisted verification of actual software.

### F* — Verified cryptography in billions of devices

**Primary user: Microsoft, via [Project Everest](https://project-everest.github.io/) (2016-2021).** F* produced provably correct cryptographic code now deployed in production:

- **Mozilla Firefox** — verified Curve25519 implementation since 2017
- **Windows kernel and Hyper-V**
- **Linux kernel**
- **Python standard library**
- **Microsoft's QUIC protocol implementation**

The [HACL*](https://hacl-star.github.io/) library (written in F*, compiled to C) provides verified implementations of Curve25519, Ed25519, AES-GCM, Chacha20, Poly1305, SHA-2, SHA-3. Each primitive is verified for memory safety, functional correctness, and resistance to timing side-channels.

**Method:** Dependent types + SMT automation (hybrid of Lean and Dafny approaches). Key innovation: Dijkstra Monads for effect-based reasoning — you can reason about pure code separately from stateful code. The Low* subset compiles to idiomatic C via KaRaMeL, enabling integration into C projects (crucial for getting verified code into Firefox or Linux). Also extracts to OCaml, F#, and WebAssembly.

**AI/LLM ecosystem:** Minimal. F*'s community is small and research-focused. No significant LLM training or benchmarking efforts.

**This is the highest-impact formal verification deployment in existence** — billions of people use F*-verified code daily without knowing it. Nobody talks about it because crypto primitives are invisible infrastructure.

### Event-B — Railway, automotive, aerospace, defense

**Primary users:** European industrial systems engineering, especially safety-critical domains with regulatory certification requirements:

- **Siemens Transportation** — train control and signalling
- **Bosch** — cruise control, start-stop systems
- **Alstom / Systerel** — railway controllers and signalling
- **Space Systems Finland** — BepiColombo space probe (attitude and orbit control)
- **AWE** (UK defense) — co-design architecture
- **Thales** — railway interlocking
- **SAP** — business choreography analysis
- **Japanese consortium** (NTT-Data, Fujitsu, Hitachi, NEC, Toshiba) — Dependable Systems Forum
- **QNX** — medical device software

**Method:** Stepwise refinement. Start with abstract safety requirements, refine to concrete designs; each refinement step generates proof obligations. Tolerates under-specification — you don't need to define the whole universe to start proving properties. The Rodin IDE (Eclipse-based) is mature if dated. Maps directly to safety certification flows (DO-178C for avionics, EN 50128 for railway).

**AI/LLM ecosystem:** None. Zero training data, no model fine-tuning, no agentic integration. The [LeanMachines](https://github.com/lean-machines-central/lean-machines) project (alpha) recreates Event-B constructs inside Lean 4 as a library, which could bridge this gap if it matures.

**The gap:** Rochus's argument in the HN thread that Event-B is better suited for LLMs than Lean is theoretically sound (tolerates incomplete sketches, uses proof obligations as iterative feedback) but practically unproven — nobody has actually done it.

### Lean 4 — Mathematics, and emerging software use

**Primary users for math:**
- **DeepMind** — AlphaProof (IMO silver medal level)
- **Harmonic AI** — $100M funding, "hallucination-free" math chatbot using Lean verification
- **Terence Tao** — Analysis textbook formalization
- **Mathlib community** — 1M+ lines of formalized mathematics
- **DeepSeek** — open-source Lean prover models

**Primary users for software:**
- **AWS Cedar** — authorization policy language (also verified in Dafny)
- **Aeneas** — Rust verification, leveraging Lean's type system to eliminate memory reasoning

**Method:** Interactive theorem proving with dependent types. Every claim must be justified by constructing a proof term (or using tactics that generate one). No SMT solver in the loop — Lean reimplements core procedures specialized for its type theory. Extremely expressive (can prove anything provable in constructive logic + choice) but requires the most manual effort for non-mathematical domains.

**AI/LLM ecosystem:** **Dominant.** This is where all the AI research is happening — OpenAI, Meta, DeepMind, Harmonic, DeepSeek all training models on Lean. Mathlib provides the largest corpus of formalized math for training. The virtuous cycle between AI capability and Lean adoption is real but confined to mathematics.

**The honest picture:** Lean's industrial adoption for *software* is thin — basically Cedar and Aeneas. Its dominance is in mathematics formalization, where it has won decisively over Rocq/Coq for new projects.

## Summary Table

| Tool | Domain | Key deployers | Proof method | AI/LLM ecosystem |
|------|--------|--------------|-------------|-----------------|
| **TLA+** | Distributed systems | AWS, Microsoft, CockroachDB | Model checking | Minimal |
| **Dafny** | Imperative software | Amazon (Cedar), MSR | SMT-automated | Growing |
| **F*** | Cryptography, low-level | Microsoft → Firefox, Linux, Windows | SMT + dependent types | Minimal |
| **Event-B** | Safety-critical systems | Siemens, Bosch, Alstom, Thales | Refinement + proof obligations | None |
| **Lean 4** | Mathematics, some software | DeepMind, Harmonic, AWS (Cedar) | Interactive/tactic | **Dominant** |

## The Meta-Pattern

Each tool occupies a different point on the "how much can you formalize?" spectrum:

- **Lean** assumes "all of it" — full dependent types, total functions, everything proven from axioms
- **Event-B** assumes "some of it, refined iteratively" — sketch vague boundaries, tighten through proof obligations
- **Dafny/F*** assumes "the contracts" — preconditions, postconditions, invariants, with SMT handling the details
- **TLA+** assumes "a finite model of it" — check behaviors exhaustively over bounded state spaces

The right position on this spectrum depends on the domain, not the tool's theoretical power. F* has the largest real-world impact despite being less famous than Lean, because crypto primitives are a domain where full formalization is both tractable and enormously valuable. Event-B dominates safety-critical engineering because regulators understand refinement-based evidence. Lean dominates math because mathematical theorems *are* their own spec.

**The VentureBeat article's error** was treating Lean as a universal tool when it's actually the most specialized — optimized for the one domain (pure mathematics) where the spec gap nearly vanishes.

## Sources

- [AWS formal methods CACM paper](https://lamport.azurewebsites.net/tla/formal-methods-amazon.pdf) (2014)
- [AWS Systems Correctness Practices](https://cacm.acm.org/practice/systems-correctness-practices-at-amazon-web-services/) (2025)
- [Amazon Dafny teaching material](https://dafny.org/blog/2023/12/15/teaching-program-verification-in-dafny-at-amazon/)
- [Project Everest](https://project-everest.github.io/) — F* verified crypto
- [Event-B industrial projects](https://wiki.event-b.org/index.php/Industrial_Projects)
- [LeanMachines](https://github.com/lean-machines-central/lean-machines) — Event-B in Lean 4
- [miniF2F-Dafny](https://arxiv.org/html/2512.10187) — LLM + auto-active verification benchmark
- [Lean vs Rocq cultural comparison](https://artagnon.com/logic/leancoq)
- [Stack Overflow: Lean vs F* vs Dafny](https://stackoverflow.com/questions/46010923/whats-the-difference-between-lean-f-and-dafny) — by a Lean core developer
