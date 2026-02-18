← [Software Factory](../topics/software-factory.md) · [Index](../README.md)

# Maximum Leverage: Minimum Human Supervision for High-Utility Agent Code

## Where We Actually Are (February 2026)

Before brainstorming forward, let me anchor in the ground truth.

The dominant pattern in production right now is **agent loop with test feedback**: the agent writes code, runs it, reads the error, fixes it, repeats. Claude Code, Codex, Cursor Agent Mode all work this way. The CLAUDE.md / AGENTS.md file tells the agent what "done" looks like. Spotify's background agents run automated "verifiers" (build, lint, test) in a loop and add an LLM-as-judge to veto scope creep. Anthropic's own research on long-running agents found that the key to spanning multiple context windows was an *initializer agent* that sets up the verification environment — feature lists marked "failing" that later coding agents work through.

The Awesome Testing blog (published literally yesterday, Feb 13 2026) crystallizes the consensus: *"The act of producing syntax is cheaper than ever; the expensive parts are judgement, validation, and risk management."*

This is the landscape. Now: how do type hints, property-based testing, and runtime contracts fit into it — not as theoretical methods, but as **components of a verification harness** that minimizes the human in the loop?

---

## The Core Design Insight

Here is the key reframe. Stop thinking about these three methods as "testing techniques you apply to code." Start thinking about them as **three layers of a machine-readable specification** that the agent's feedback loop can use to self-correct.

- **Type hints** = specification of data shape (what goes in, what comes out)
- **Contracts** = specification of semantic boundaries (what must be true before/after)
- **Properties** = specification of behavioral invariants (what must hold across all inputs)

The human writes specifications. The machine checks them. The agent iterates until the checks pass. The human never reads the implementation.

This isn't hypothetical. It's the logical extension of what Spotify, Anthropic, and every serious agentic workflow is already doing — but most teams stop at "run pytest and check the exit code." The brainstorm is about how to make the specification layer *richer* without making the human cost proportionally higher.

---

## Idea 1: The Specification Sandwich

**Human writes the bread. Agent fills the middle.**

```
# Human writes this file: specs/user_service.py

from typing import Protocol
import deal

class UserService(Protocol):
    """Service for user CRUD operations."""

    @deal.pre(lambda email: "@" in email and "." in email.split("@")[1])
    @deal.pre(lambda name: 0 < len(name) <= 200)
    @deal.post(lambda result: result.id is not None)
    @deal.post(lambda result: result.created_at is not None)
    def create_user(self, name: str, email: str) -> User: ...

    @deal.pre(lambda user_id: user_id > 0)
    @deal.post(lambda result: result is None or isinstance(result, User))
    def get_user(self, user_id: int) -> User | None: ...

    @deal.pre(lambda user_id: user_id > 0)
    @deal.ensure(lambda self, user_id: self.get_user(user_id) is None)
    def delete_user(self, user_id: int) -> None: ...
```

The human reviews this file. It's ~20 lines. The contracts are readable. The types are obvious. This is where 100% of the human's verification effort goes.

Then the CLAUDE.md says:

```markdown
## Verification

After implementing any module in src/:
1. Run `pyright --outputjson src/ | python scripts/check_errors.py` — zero errors required
2. Run `python -m deal test src/` — all contract-derived tests must pass
3. Run `pytest tests/ -x` — all property tests must pass
4. Do NOT modify any file in specs/ — those are the ground truth
```

The agent implements, the harness checks, the agent iterates. The human only re-engages if the agent gets stuck after N iterations (circuit breaker).

**Why this works better than "write tests":** Tests are implementation-flavored. They encode specific input-output pairs, which means they share the agent's assumptions. Specifications encode *what must be true*, which is orthogonal to how it's implemented. A contract like `ensure(lambda self, user_id: self.get_user(user_id) is None)` on `delete_user` catches bugs regardless of whether the agent uses SQL, an ORM, or an in-memory dict.

**Human cost:** 15-30 minutes per module to write the spec file. Zero cost per iteration.

---

## Idea 2: Contract Gradients — Tighten as Confidence Grows

A practical problem: comprehensive contracts are expensive to write up front. Solution: **start loose, tighten incrementally**.

**Phase 1 — Skeleton contracts (5 minutes):**
```python
@deal.post(lambda result: result is not None)
def process(data: list[dict]) -> DataFrame: ...
```

This catches crashes and None returns. Cheap to write. Already valuable.

**Phase 2 — Shape contracts (after first working version, 10 minutes):**
```python
@deal.pre(lambda data: len(data) > 0)
@deal.post(lambda result: len(result) == len(data))
@deal.post(lambda result: set(result.columns) == {"id", "name", "score"})
def process(data: list[dict]) -> DataFrame: ...
```

Now you're checking dimensional correctness. Most LLM bugs are shape bugs.

**Phase 3 — Semantic contracts (for critical paths, 20 minutes):**
```python
@deal.pre(lambda data: all("score" in d for d in data))
@deal.post(lambda result: result["score"].between(0, 100).all())
@deal.post(lambda result: result["score"].is_monotonic_increasing == False or len(result) <= 1)
@deal.ensure(lambda data, result: set(result["id"]) == {d["id"] for d in data})
def process(data: list[dict]) -> DataFrame: ...
```

The key insight: **you can tighten contracts without changing the implementation**. Tell the agent "I've updated the spec, make sure your code still passes." The contracts are the ratchet; they only tighten.

This mirrors how formal methods are actually adopted in practice — not all at once, but progressively, focused on the modules where correctness matters most.

---

## Idea 3: Agent-Written Properties, Human-Reviewed

My self-critique identified a real problem: if the agent writes both the code and the tests, the tests share the code's misconceptions. But there's a middle path.

**Have the agent propose properties. Have the human approve them. Then use them as the verification harness.**

The workflow:

1. Human gives the agent a task: "Implement a merge function for sorted lists"
2. Before implementing, agent writes proposed properties:
   ```python
   # PROPOSED PROPERTIES — please review
   @given(st.lists(st.integers(), min_size=0), st.lists(st.integers(), min_size=0))
   def test_merge_preserves_length(a, b):
       assert len(merge(sorted(a), sorted(b))) == len(a) + len(b)

   @given(st.lists(st.integers(), min_size=0), st.lists(st.integers(), min_size=0))
   def test_merge_result_is_sorted(a, b):
       result = merge(sorted(a), sorted(b))
       assert all(result[i] <= result[i+1] for i in range(len(result)-1))

   @given(st.lists(st.integers(), min_size=0), st.lists(st.integers(), min_size=0))
   def test_merge_preserves_elements(a, b):
       result = merge(sorted(a), sorted(b))
       assert sorted(result) == sorted(a + b)
   ```
3. Human reviews properties (~30 seconds each — they're declarative). Approves, rejects, or amends.
4. Agent implements against approved properties.

**Why this flips the leverage equation:** Reviewing a property takes seconds. Reviewing an implementation takes minutes. And once approved, the property is a permanent, reusable verification oracle.

The research supports this. The Vikram et al. (2023) paper found that LLM-generated properties were ~79% sound. That means you're starting from a mostly-correct set and just checking for the ~20% that are wrong. That's a fundamentally different workload than reviewing the implementation from scratch.

**The CLAUDE.md instruction:**
```markdown
## Before implementing any function:
1. Write proposed Hypothesis properties in tests/proposed/
2. STOP and ask me to review them
3. Only implement after I approve the properties
4. Implementation must pass all approved properties
```

---

## Idea 4: The Differential Oracle

Here's a technique that's underexplored but extremely powerful for agent workflows: **use a slow-but-obviously-correct reference implementation as the oracle for property tests.**

```python
# reference.py — Human writes this. 30 lines. Obviously correct. Maybe slow.
def naive_shortest_path(graph, start, end):
    """BFS. O(V*E). Definitely correct. Definitely slow."""
    from collections import deque
    queue = deque([(start, [start])])
    visited = {start}
    while queue:
        node, path = queue.popleft()
        if node == end:
            return path
        for neighbor in graph[node]:
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append((neighbor, path + [neighbor]))
    return None

# Agent implements optimized_shortest_path using Dijkstra or A*.
# The property test:
@given(graph_strategy(), st.sampled_from(nodes), st.sampled_from(nodes))
def test_optimized_matches_naive(graph, start, end):
    naive = naive_shortest_path(graph, start, end)
    optimized = optimized_shortest_path(graph, start, end)
    if naive is None:
        assert optimized is None
    else:
        assert len(optimized) == len(naive)  # same length path
```

The human writes a dumb, 30-line reference implementation. The agent writes the real one. Hypothesis generates thousands of random graphs and checks they agree. This is the oracle pattern, and it's available any time you can write a slow-but-correct version of something.

**Where this excels:** Algorithm implementations, data transformations, parsers, serializers — anywhere the "obvious" solution exists but is too slow for production. The agent's job is to make it fast; the reference's job is to keep it correct.

---

## Idea 5: Verification Hooks in the Agent Harness

Claude Code supports hooks — commands that fire on specific events. The most powerful configuration I can envision:

```json
// .claude/settings.json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": { "tool_name": "write_file", "file_pattern": "src/**/*.py" },
        "command": "pyright --outputjson $FILE | python scripts/type_check_gate.py"
      }
    ],
    "PostToolUse": [
      {
        "matcher": { "tool_name": "write_file", "file_pattern": "src/**/*.py" },
        "command": "python -m deal lint $FILE"
      }
    ]
  }
}
```

This means: **every time the agent writes a Python file, pyright and deal's linter run automatically, before the agent even moves to the next step.** The agent sees the errors in its tool output and self-corrects immediately, within the same context window.

This is tighter than running verification at the end. It's verification *inline with every write*. The human cost is zero — it's a one-time configuration.

The Spotify engineering blog describes exactly this pattern: "verifiers that activate automatically depending on the software component contents." Their Maven verifier fires when it sees a pom.xml. The principle generalizes: a pyright verifier fires when it sees .py.

---

## Idea 6: The Contract-Hypothesis Bridge as Auto-Generated Fuzz Harness

This is where `deal.cases()` and `icontract-hypothesis` become genuinely powerful — not as testing tools, but as **automatic fuzz harnesses derived from contracts**.

The workflow:
1. Human writes contracts on module interfaces
2. `deal.cases()` or `icontract-hypothesis` automatically generates Hypothesis strategies from the contracts
3. These run as part of the agent's verification loop
4. Any counterexample found gets fed back as a structured error

The current limitation (from my self-critique): auto-inferred strategies are weak for complex inputs. But here's the creative fix: **use the agent itself to strengthen the strategies.**

```markdown
## CLAUDE.md
After implementing a module:
1. Run `python -m deal test src/module.py`
2. If deal.cases() finds no issues but coverage is low:
   - Write custom Hypothesis strategies in tests/strategies/ that generate
     realistic inputs for the domain
   - Re-run with custom strategies
3. Custom strategies must satisfy all @deal.pre contracts
```

The agent writes the *strategies* (how to generate test data), the human writes the *contracts* (what must be true). The strategies can be wrong without causing false confidence — a bad strategy just means fewer inputs are tested, not that wrong inputs are accepted. The contracts can't be wrong without being caught by the human's review.

---

## Idea 7: The Initializer Agent Writes Specs, Not Code

Anthropic's research on long-running agents found that an "initializer agent" that sets up the environment before coding agents start was critical. Currently, the initializer writes feature lists and boilerplate.

**What if the initializer writes the specification layer instead?**

Prompt to initializer:
```
You are setting up a project for a coding agent. Your job is NOT to write code.
Your job is to create the verification harness:

1. Read the requirements document
2. For each module described:
   - Create a Protocol class with typed method signatures
   - Add @deal.pre and @deal.post contracts for each method
   - Write 3-5 Hypothesis property tests
3. Create a pyproject.toml with pyright in strict mode
4. Create a Makefile with `make verify` that runs all checks
5. Mark every property test as FAILING (expected)
6. Write CLAUDE.md instructions for the coding agent

DO NOT write any implementation code.
```

Then the coding agent starts in a project where:
- Every function has a typed signature it must implement
- Every function has contracts it must satisfy
- Every module has property tests it must pass
- `make verify` reports exactly what's still failing

The coding agent's only job is turning red checks green. The human's only job is reviewing the initializer's specification output — which is much more tractable than reviewing implementations.

**This is the "shifts" metaphor from Anthropic's long-running agent research, but with a spec-first twist.** Each "shift" (context window) of the coding agent starts fresh, but the specifications persist across all shifts. The spec is the shared memory.

---

## Idea 8: Graduated Autonomy Based on Verification Depth

Not all code needs the same supervision. The verification depth should determine the autonomy level:

| Verification Depth | Human Touch | Agent Autonomy |
|---|---|---|
| Type hints only | None after setup | Full (merge on green CI) |
| Types + contracts | Review contracts once | High (merge after CI + contract check) |
| Types + contracts + property tests | Review properties once | Very high (merge after full verification suite) |
| Types + contracts + properties + differential oracle | Review oracle once | Near-complete (background agent, async PR) |

The idea: **code that has richer specifications gets less human review.** A function with typed signatures, three contracts, and five property tests that all pass has been verified from more angles than most human-reviewed code. It should need *less* review, not more.

This inverts the current default, where all PRs get equal review regardless of test quality. Instead: the specification depth is a trust signal. The richer the spec, the more you can trust the agent's output without looking at it.

Spotify's background agent system already does something like this — their LLM-as-judge vetos ~25% of agent PRs. The verification depth could modulate that veto rate: if the PR passes a deep specification suite, the judge's bar can be lower.

---

## What This Actually Looks Like in Practice

For a concrete, grounded version: imagine a team using Claude Code to build a data pipeline.

**Day 0 (1 hour human investment):**
- Write `pyproject.toml` with pyright strict mode
- Write `CLAUDE.md` with verification instructions
- Set up hooks for inline type checking

**Per-module workflow (30 min human, hours of agent time):**
1. Human writes a Protocol class with type hints and deal contracts (15 min)
2. Human reviews agent-proposed Hypothesis properties (10 min)
3. Human writes a naive reference implementation for the core transform (5 min)
4. Agent implements, iterates against verification harness, submits PR
5. Human skims diff for architectural concerns only — correctness is mechanically verified

**The leverage ratio:** 30 minutes of human specification work enables hours of unsupervised agent coding, with higher confidence in correctness than most human-written, human-reviewed code achieves.

---

## What Could Change This Picture

**If models get much better at writing sound properties** (currently ~79% sound): the human review of proposed properties becomes even cheaper, approaching rubber-stamp. The agent writes both properties and code, and the human just checks for the occasional unsound property.

**If CrossHair or deal-solver matures**: you get symbolic verification of contracts without running the code. The gap between "property testing" and "formal verification" narrows. The spec sandwich becomes provably correct for the subset of Python that these tools support.

**If agent harnesses get native contract support**: instead of hooking pyright and deal into CLAUDE.md instructions, the agent SDK directly understands "run this function against its contracts" as a built-in verification primitive. This reduces setup friction to near zero.

**The biggest risk**: teams skip the specification step because it requires human thought, and instead rely entirely on agent-generated tests. This produces exactly the "cycle of self-deception" that the research warns about. The specification is the part that can't be automated away — it's where the human's understanding of the domain lives. Trying to shortcut it defeats the entire approach.

---

## The One-Sentence Version

Write specifications (types + contracts + properties) that are short enough to review in minutes, wire them into the agent's feedback loop so it self-corrects in seconds, and never read the implementation at all.
