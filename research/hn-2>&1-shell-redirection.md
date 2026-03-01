← [Index](../README.md)

## HN Thread Distillation: "What does '2>&1' mean?"

**Source:** [Stack Overflow Q&A](https://stackoverflow.com/questions/818255/what-does-21-mean) (classic 2009 question, ~4.5M views) | [HN thread](https://news.ycombinator.com/item?id=47171233) — 193 points, 116 comments, 92 unique authors

**Article summary:** A canonical Stack Overflow question explaining that `2>&1` redirects file descriptor 2 (stderr) to wherever file descriptor 1 (stdout) currently points, with detailed answers covering the underlying `dup2` syscall, ordering semantics, and common patterns.

### Dominant Sentiment: Nostalgic defense of comfortable arcana

The thread has the energy of experienced programmers rationalizing syntax they internalized decades ago. Criticism of shell syntax gets reflexive pushback ("the programmers *were* the users"), while genuine pedagogical insights get buried under "well actually" corrections. Notable that 92 unique authors showed up — `2>&1` is apparently the Rorschach test of Unix identity.

### Key Insights

**1. The dup2 mental model is the only one that actually scales**

wahern's top comment — that `2>&1` literally translates to `dup2(1, 2)` — is the thread's most genuinely useful contribution. It's the only framing that correctly predicts behavior when redirections compose (ordering, pipes, multiple FDs). The SO answer's "redirect stderr to stdout" phrasing is fine for the single case but actively misleading when you chain redirections. As kazinator explains: `bob > file 2>&1` works because `> file` moves stdout to the file first, then `2>&1` dups stderr into it. Reverse the order (`bob 2>&1 > file`) and stderr still goes to the terminal — left-to-right matters because each redirection mutates state. The pipe case inverts this: `bob 2>&1 | prog` works because the pipe is established *first* on fd 1, then `2>&1` dups into it. This is genuinely confusing and the thread does a decent job surfacing it.

**2. The `&` is a parser disambiguation hack, not a conceptual operator**

The thread's most interesting micro-debate: is `&` in `>&1` analogous to C's address-of operator? maxeda had an epiphany reading it that way. jibal immediately corrects: "the shell author needed *some* way to distinguish file descriptor 1 from a file named '1'" — it's a parsing convenience, not a semantic choice. kazinator sharpens this further: `>&` is a single compound operator, not `>` followed by `&`. You can write `2>& 1` (space after the operator) but not `2 >& 1` (space before the fd). The SO commenter who asked "shouldn't it be `&2>&1`?" identified the real asymmetry — the left-side fd doesn't need `&` because position alone disambiguates it. This is the kind of syntactic accident that calcifies into "tradition."

**3. Higher file descriptors are a real technique, not a curiosity**

jez's example of using fd 3 for "escape hatch" output drew a surprising number of real-world confirmations: nothrabannosir uses it to work around AWS CLI's stdout-clobbering behavior, Red Hat kickstart scripts use tty3, and hugmynutus shared a [gist](https://gist.github.com/valarauca/71b99af82ccbb156e0601c5df8a27d8b) that buffers stdout/stderr into fd 3/4 and only replays them on failure. The pattern is always the same: you need a clean channel when existing tools have claimed stdout and stderr for their own purposes. It's duct tape, but it's load-bearing duct tape.

**4. The "archaic vs. enduring" debate reveals a values split, not a technical one**

amelius kicked off the main culture-war thread: "It's a reminder of how archaic the systems we use are." The responses split cleanly:

- **Defenders** (nusl, agentdrek, murphyslaw): stability *is* the feature. "My scripts from 15 years ago still work just fine."
- **Critics** (phailhaus, bigstrat2003, crazygringo): backwards compatibility isn't a virtue when it prevents improvement. Bash syntax is objectively hostile.
- **Pragmatists** (nixon_why69, Normal_gaussian): sh is everywhere and it's for *gluing processes*, not programming. If you're writing enough bash that the syntax is the bottleneck, you've misidentified your tool.

Normal_gaussian's comment is the thread's sharpest take: "You're scripting on the shell because you're mainly gluing other processes together, and this is what (ba)sh is designed to do." The defenders and critics are arguing past each other because they're evaluating different use cases — one-liner pipelines vs. 500-line deploy scripts.

**5. The spaces-in-paths horror chain is the best argument against "just quote your variables"**

deathanatos's three-factor bug story (Python + virtualenvs + macOS + spaces in path) is the thread's star anecdote. Shebangs have *no escaping mechanism*. Python's tooling detects this and emits a bash polyglot shebang as a workaround — which then hits macOS's ancient bundled bash, which strips environment variables. The lesson isn't "quote your variables" (the standard advice); it's that the Unix text-stream-of-bytes abstraction has fundamental composability failures that no amount of careful quoting can fix, because the failure surfaces in layers you don't control (kernel shebang parsing, OS-bundled shell versions).

**6. LLMs have made `2>&1` more prevalent, not less**

Multiple commenters (vessenes, keithnz, anitil, TacticalCoder) note that LLM-generated shell commands use `2>&1` constantly — "agentic AI tends to use it ALL the time." The irony: a syntax so confusing it spawned a 4.5M-view SO question is now being written more than ever, by machines that learned it from the humans who looked it up. TacticalCoder's observation is apt: "not-humans are using this extensively precisely because humans used this combination extensively for decades."

**7. Stack Overflow nostalgia is real but unfocused**

solomonb: "Man I miss stack overflow. It feels so much better to ask humans a question than the machine." numbers adds: "no AI fluff to start or end the answer, just facts straight to the point." This is the thread's emotional undercurrent — a 2009 SO question hitting HN front page in 2026 is itself a statement about what's been lost.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Just use /dev/stdout instead of &1" | Weak | murphyslaw correctly notes this is Linux-specific, not portable |
| "Modern shells (nushell, powershell) solve this" | Medium | True but sidesteps that sh/bash is the *lingua franca* — you can't choose your shell on every system |
| "The syntax is fine, RTFM" (stephenr) | Misapplied | Arrow functions and operator overloading are also in manuals; the complaint is about discoverability, not documentation |
| "Use Python/sh module instead" | Medium | Normal_gaussian's rebuttal is sharp: Python is worse for process orchestration, the thing shells exist for |

### What the Thread Misses

- **Nobody mentions `set -o pipefail`**, which is critical to understanding why `2>&1 |` behaves as it does in error-handling contexts. The thread treats redirection as a syntax question when in practice the bugs are in error propagation through pipelines.
- **No discussion of structured stderr.** The thread touches on JSON-to-fd-3 (sigwinch) but doesn't engage with the deeper question: stderr is unstructured by convention, which is why everyone keeps needing `2>&1` — to grep error output you must merge it with stdout first because there's no structured way to filter it.
- **The "LLMs use it" observation goes nowhere.** Nobody asks the obvious follow-up: if AI agents are the primary new consumers of shell, should shell syntax evolve for machine parseability rather than human readability? The fd-3-for-JSON movement (mentioned once, ignored) is actually the leading edge of this.
- **Missing the generational shift.** This SO question is from 2009 and the thread is mostly 30+ year veterans. The actual audience who needs this explained — junior devs, data scientists, SREs who grew up on containers — isn't represented in the discussion.

### Verdict

The thread demonstrates a community that has thoroughly internalized a bad interface and now defends it as philosophy. The real insight isn't in the syntax explanation — it's that `2>&1` persists not because it's good, but because the Unix process model's three-fd convention is so deeply embedded that even clean-sheet designs (PowerShell) reproduce it. The thread circles this but never states it: the syntax is a symptom, and the disease is that Unix's 1971 decision to give processes exactly three named streams became an unkillable architectural assumption. Every "just use nushell" suggestion bounces off this reality.
