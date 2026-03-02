← [Index](../README.md)

## HN Thread Distillation: "If AI writes code, should the session be part of the commit?"

**Source:** [git-memento](https://github.com/mandel-macaque/memento) — a Git extension that attaches AI coding session transcripts to commits via `git notes`. F# / .NET, NativeAOT. Includes a GitHub Action for CI gating and note rendering. 119 points, 138 comments, March 2026.

**Article summary:** git-memento stores cleaned markdown conversation logs as git notes on commits, keeping them outside normal history. It supports Codex and Claude Code, handles squash/rebase note carry-over, and provides audit tooling to enforce note coverage. The tool is well-engineered for what it does — the question is whether what it does matters.

### Dominant Sentiment: Practical no, philosophical maybe

The thread overwhelmingly rejects storing raw sessions but splits sharply on whether *some* distilled artifact of the AI interaction should be preserved. The real energy isn't about this specific tool — it's about the dawning realization that AI-assisted development is creating an intent documentation gap that existing practices (commit messages, PRs, ADRs) weren't designed to fill.

### Key Insights

**1. The compiler analogy is dead on arrival**

burntoutgray's provocative claim — "The session becomes the source code... just as `.c` became the originating artifact over assembly" — gets demolished from multiple angles. WD-42, sumeno, and bonoboTP all land the same punch: compilers are deterministic with well-understood input/output relationships; LLMs are neither. But bonoboTP sharpens the point beyond determinism: "small changes of the input will cause unknown changes in the output. You change one function's definition, it doesn't impact another function's definition." The relationship between prompt and output is fundamentally opaque in a way that source-to-assembly never was. This analogy will keep resurfacing and will keep being wrong.

**2. The squash commits framing is the right one**

onion2k nails the actual analogy: "Conceptually this is very similar to the question of whether or not you should squash your commits. To the point that it's really the same question." This reframes the debate from "is AI special?" to "how much process archaeology do you value?" — and the answer is team-dependent, not technology-dependent. D-Machine endorses this as "the right analogy, contrary to some other very poor ones in this thread." The squash-vs-preserve debate has been raging for a decade with no resolution, which tells you something about where this AI variant will land.

**3. The keystroke-log objection kills the maximalist position**

tpmoney delivers the thread's sharpest rebuttal to storing full sessions: "We don't make the keystroke logs part of the commit history. We don't make the menu item selections part of the commit history." This correctly identifies that AI sessions are *process artifacts*, not *product artifacts*. The maximalists (like D-Machine, who argues for storing prompts for "reproducibility" of reasoning) are really arguing for something closer to lab notebooks — useful in principle, rarely consulted in practice.

**4. A new artifact type is crystallizing — but nobody agrees on what it is**

The thread converges on "something between raw session and nothing" but fragments on specifics:
- **Structured intent documents:** rcy links to "Change Intent Records" (CIRs) — a proposed ADR-like format capturing intent, behavior specs, constraints, and decisions. This is the most mature proposal.
- **Spec-first + plan versioning:** brendanmc6 and hatmanstack independently describe committing plan/spec files that evolve during the session, not the session itself.
- **Prompt-only logging:** visarga logs only user messages, not AI responses. D-Machine argues first-N prompts are the practical heuristic.
- **Post-task reflections:** reflectt describes structured "what we tried, what failed, what we'd do differently" summaries — a few hundred tokens instead of tens of thousands.
- **Devlog IDs:** hakanderyal stores summaries in a database, commits only a reference ID.

The pattern: everyone reinventing the wheel slightly differently, which means the actual winning format hasn't emerged yet.

**5. dang's meta-comment is the most important thing in the thread**

HN's moderator hijacks the discussion to surface a governance problem: Show HN is drowning in AI-generated submissions with nothing but "a generated repo with a generated readme." His four-point framing — (1) some are good, (2) creation is good, (3) foolish to fight the future, (4) no obvious filter — is notable for its resigned pragmatism. grayhatter pushes back hard: "Fighting the future is different from letting people doing something different ruin the good thing you currently have. Sure electric cars are the future, but that's no reason to welcome them in a group that loves rebuilding classic hot rods." dang doesn't have an answer. This isn't about git-memento; it's about whether quality communities can survive the AI output flood without gatekeeping mechanisms that feel exclusionary.

**6. The "Ape Coding" fiction is the thread's unconscious self-portrait**

midnitewarrior links to a satirical Wikipedia-style article from the future where hand-writing code becomes a hobbyist practice called "ape coding." The piece is brilliant speculative fiction: Linux becomes a museum artifact, humans attempt to write a compiler for an AI-designed programming language, and the project forks over a C-vs-Rust dispute. The thread doesn't engage with it deeply, but it's the subtext of the entire debate — this community is negotiating the terms of its own obsolescence.

**7. The accountability angle is underexplored but real**

D-Machine raises the management case repeatedly: "from a business standpoint, you still need to select for competent/incompetent prompters/AI users. It is hard to do so when you have no evidence of what the session looked like." raggi offers the counterpoint nobody else considers: session logs can leak PII from bug reports. The thread doesn't reconcile these — enterprises need audit trails but also can't safely store everything. This tension will drive the actual tooling decisions more than any developer-experience argument.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "It's like committing your Google search history" (YoumuChan, umairnadeem123) | Medium | Captures the noise objection but misses that searches aren't causal inputs to the artifact the way prompts partially are |
| "Just write better commit messages" (spion, e3bc54b2) | Weak | Assumes the problem is laziness rather than a structural gap — vibe coders who skip review won't write good commit messages either |
| "The code is the artifact, sessions are exhaust" (rfw300, causal) | Strong | Correct for the *current* debugging workflow; may age badly if intent-tracing becomes standard |
| "Non-determinism makes sessions useless for reproduction" (WD-42, sumeno, natex84) | Strong for reproduction, Misapplied for intent | Conflates reproducing outputs with understanding reasoning |
| "Just read the code before committing" (latexr) | Strong in principle, Irrelevant in practice | mandel_x: "People won't do that, unfortunately. We are a dying breed." The thread mostly agrees. |

### What the Thread Misses

- **The commit itself may be the wrong unit.** Everyone debates what to attach to commits, but AI-assisted development often produces changes that span multiple logical units or arrive as monolithic blocks. The commit abstraction assumes human-paced, intentional chunking. If the unit of work shifts to "task" or "spec," the attachment point shifts too.
- **Model context is the real missing piece, not session logs.** rerdavies notes most AI use is autocomplete and inline prompts, not big sessions. The thread fixates on agentic coding sessions while ignoring that the majority of AI-assisted code comes from invisible, unlogged interactions. No tool captures these.
- **Cost and storage are never discussed.** Full session transcripts for every commit in a large team would be enormous. git notes live in the repo. Nobody does the math.
- **The legal/IP dimension is absent.** If sessions contain model outputs, storing them in open-source repos raises questions about training data provenance and license compliance that nobody touches.

### Verdict

The thread circles a truth it never quite states: **the problem isn't preserving AI sessions — it's that AI-assisted development has decoupled intent from implementation faster than our tooling and culture can adapt.** Commit messages, code review, and documentation all assumed a human who understood what they wrote and why. Remove that assumption and the entire provenance chain breaks. git-memento is a technically clean solution to a symptom, but the disease is that "why was this built this way?" is becoming unanswerable through code alone. The winning approach will look less like session logging and more like structured intent capture (CIRs, spec files, plan docs) — artifacts that are *written for future readers*, not transcripts of a process that was never meant to be read. The irony: the thread about documenting AI sessions is itself an artifact of a community trying to document its own transition, and mostly failing.
