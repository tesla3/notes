← [Index](../README.md)

## HN Thread Distillation: "Agents that run while I sleep"

**Source:** [HN thread](https://news.ycombinator.com/item?id=47327559) (285 points, 263 comments) · [Article](https://www.claudecodecamp.com/p/i-m-building-agents-that-run-while-i-sleep) · June 2026

**Article summary:** The author (a Claude Code workshop instructor) describes the problem of verifying autonomous agent-generated code. His solution: write acceptance criteria in plain English before prompting, then use Playwright browser agents to verify each criterion independently. He packages this as a Claude Skill called `opslane/verify` that uses Opus for planning/judging and parallel Sonnet calls for browser verification.

### Dominant Sentiment: Skeptical practitioners reinventing old wheels

The thread is notably sober for an agent-coding discussion. The dominant energy isn't anti-AI — it's fatigue with people rediscovering TDD and acceptance testing as if they're novel, plus genuine alarm at the review bottleneck nobody has solved.

### Key Insights

**1. "Test Theatre" is the thread's consensus diagnosis — and it's already coined**

bhouston's term "Test Theatre" (from [his 2025 blog post](https://benhouston3d.com/blog/the-rise-of-test-theater)) became the thread's dominant frame. The core insight: AI-generated tests that verify AI-generated code are tautologies — "a student writing their own exam after seeing the answers." JBorrow quantified it: "600 lines of tests for my 100 lines of code... when you actually look at the content of the tests they're meaningless." InsideOutSanta reports the downstream pathology: 100% coverage mandates met by LLM-written tests now mean *every* non-trivial change breaks tests, so developers just tell Claude to fix the tests too. The test suite becomes a token-burning costume change, not quality assurance.

**2. The review bottleneck is the real unsolved problem, not code generation speed**

afro88 dropped the thread's most revealing confession: "Last week I did about 4 weeks of work over 2 days... But all this code needs to be reviewed... It's like 20k line changes over 30-40 commits. There's no proper solution to this problem yet." Several commenters (kg, tdeck) pointed out the uncomfortable truth: you didn't do 4 weeks of work — you *started* 4 weeks of work. The review *is* part of the work. The agent shifted effort from production to verification but didn't reduce total effort. kg's advice — "apply backpressure, stop generating new AI code if previously generated code hasn't been reviewed" — is the most operationally sound comment in the thread, and the one most likely to be ignored.

**3. Differential testing with information barriers is the most promising technical approach**

seanmcdirmid describes the strongest architecture: three sub-agents where one writes code from spec, one writes tests from spec, and a QA agent (the only one that sees both) assigns blame on failures. "The coder never gets to see the test." This is genuine separation of concerns, not theatre. The key claim — that correlated failure between independent agents is "like something that will happen before the heat death of the universe" — is hyperbolic, but the information barrier principle is sound. foundatron's OctopusGarden pipeline implements something similar: the code review phase sees *only the diff*, not the issue or plan.

**4. The article's own evidence undermines its thesis**

The article claims this approach catches "integration failures, rendering bugs, and behavior that works in theory but breaks in a real browser" — then immediately concedes it "doesn't catch spec misunderstandings." But spec misunderstandings *are the primary failure mode* of autonomous agents. The article's example (login flow acceptance criteria) is precisely the kind of well-specified CRUD work where agents already do fine. interpol_p's counterexample — a Metal renderer where Codex looped for hours on a bloom shader, eventually told the user what they were seeing "was expected," and confidently rejected the correct diagnosis — is the actual hard case. The verification framework solves the easy problem.

**5. The "different model reviews different model" idea is folk belief, not engineering**

Multiple commenters suggest using GPT to review Claude, or vice versa. throwatdem12311 calls it "superstition," and xandrius correctly points out LLMs don't have reward functions in the way people imagine. storus responds with a wall of arxiv links on multi-agent debate, but these papers study *reasoning tasks with verifiable answers*, not open-ended code review where "correct" is underdefined. The real insight: a different *context* matters more than a different model. throwaway7783: "I simply use a different Claude Code session... there is no self-congratulation." Fresh context, not brand diversity, is the active ingredient.

**6. The speed-quality tradeoff is heading in only one direction**

daxfohl names the dynamic nobody else will: "What if instead, the goal of using agents was to increase quality while retaining velocity, rather than the current goal of increasing velocity while (trying to) retain quality?" The thread overwhelmingly confirms velocity is winning. rglover: "Very few if any of the people setting stuff like this up truly care about delivering a quality result — *any* result is the real goal." throwyawayyyy goes further: "I am afraid that we are heading to a world in which we simply give up on the idea of correct code as an aspiration." lbreakjai's pushback is sharp — "A service that's up 100% of the time but is 80% correct is useless" — but the market isn't listening.

**7. The meta-irony: a Claude Code workshop instructor selling Claude Code verification tooling**

wesselbindt asks the question the thread mostly avoids: "Does anyone know what this guy is having his agents build? Bc I looked a bit and all I see him ship is LinkedIn posts about Claude." serial_dev connects it: "Not if you are an AI gold rush shovel salesman." The article author (aray07) is selling workshops and building verification tools *for the workflow he's promoting*. This isn't necessarily wrong — shovel sellers can be right about gold — but TonyAlicea's "entropy tolerance" framework offers a more honest framing: most processes can't tolerate the uncertainty agents introduce, and the people most excited about autonomous agents are building low-stakes tooling *about* autonomous agents.

**8. File permissions as a proxy for trust boundaries**

BeetleB's request — "I wish there was a way to freeze the tests" so the agent can't edit them — spawned the thread's most practically useful subthread. Solutions range from devcontainers with read-only mounts (simlevesque), to Claude PreToolUse hooks (mgrassotti), to simply committing tests and telling the agent not to touch them (comradesmith/dboreham). The gradient from "just tell it" to "physically enforce it with OS permissions" maps exactly to how much you trust the agent. The fact that people are reaching for OS-level enforcement reveals how little they trust prompt-level instructions for anything that matters.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Use a different model to review" | Weak | Different context matters more than different weights. Folk belief dressed up as engineering. |
| "TDD solves this" | Medium | Correct directionally, but TDD requires knowing what to test. Agents fail precisely where specs are ambiguous — TDD's blind spot too. |
| "Just don't review, treat agent code like assembly" (eikenberry) | Provocative | Logically consistent but assumes the "compiler" (prompts + context) is correct — the exact thing in question. |
| "Acceptance criteria fix everything" | Misapplied | Only works for well-specified behavior. The hard problems are the ones you can't spec in advance. |

### What the Thread Misses

- **The economics of verification scale worse than generation.** Generating code is O(tokens). Verifying code is O(complexity × domain knowledge). As agents get faster, the verification gap widens superlinearly. Nobody models this.
- **Spec-writing *is* programming.** The article's acceptance criteria are a DSL for behavior. The thread keeps treating "writing specs" as easier than "writing code" — but detailed, unambiguous specs *are* code, just in English. The bottleneck didn't move; it changed syntax.
- **Nobody discusses liability.** If autonomous agents ship bugs to production overnight, who's responsible? The thread treats this as purely a technical problem. In regulated industries, "the agent did it while I slept" is not a defense.
- **The Godot contamination anecdote (hermit_dev) deserves more attention.** Open-source projects drowning in unreviewed AI contributions is a *different* failure mode from internal autonomous agents — it's adversarial, not cooperative — and the thread conflates them.

### Verdict

The thread circles a truth it never quite lands on: autonomous code generation has outrun human verification capacity, and no amount of tooling can close that gap because verification is *inherently* harder than generation. The article's Playwright-based acceptance testing is a reasonable incremental improvement for well-specified CRUD features, but it's being marketed as a solution to a problem that's actually a fundamental asymmetry. The real question isn't "how do we verify agent output?" — it's "what are we willing to ship without verifying?" The industry is answering that question implicitly every day by merging faster than it can review, and no one in this thread wants to say that out loud.
