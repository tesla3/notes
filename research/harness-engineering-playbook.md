← [Coding Agents](../topics/coding-agents.md) · [Software Factory](../topics/software-factory.md) · [Index](../README.md)

# The Emerging "Harness Engineering" Playbook

**Source:** [Artificial Ignorance — The Emerging "Harness Engineering" Playbook](https://www.ignorance.ai/p/the-emerging-harness-engineering) (Feb 2026)

Synthesis of convergent practices from OpenAI (3-engineer team, million-line internal product), Stripe (Minions — 1,000+ merged PRs/week), Peter Steinberger (OpenClaw — 6,600+ commits/month solo), Anthropic (long-running agents research), and Mitchell Hashimoto (Terraform/Ghostty creator).

---

## The Core Thesis

The engineer's job is splitting into two halves that run simultaneously:

1. **Building the harness** — the constraints, tools, docs, and feedback loops that keep agents productive.
2. **Managing the work** — planning, directing, reviewing, parallelizing agent output.

Each half informs the other. Agent failures reveal what the harness is missing; a better harness reduces management friction.

The term "harness engineering" comes from Mitchell Hashimoto: "Anytime you find an agent makes a mistake, you take the time to engineer a solution such that the agent never makes that mistake again."

---

## Part I: Building the Harness

### 1. Enforce Rigid Architecture Mechanically

OpenAI's team enforced a strict layered architecture — each business domain divided into fixed layers with validated dependency directions and limited permissible edges. Constraints enforced via **custom linters and structural tests** (themselves agent-generated).

- **Constraining the solution space increases reliability**, not expanding it. (Böckeler on martinfowler.com: we may choose tech stacks for harness-friendliness, not flexibility.)
- In a human-first workflow these rules feel pedantic. With agents, they become **multipliers**: once encoded, they apply everywhere at once.

### 2. Give Agents the Same Tooling as Humans

Stripe's Minions run in isolated, pre-warmed "devboxes" — the same dev environments humans use, but **sandboxed from production and the internet**. They connect to 400+ internal tools through a centralized MCP integration called **Toolshed**.

- Brockman: "Maintain a list of tools your team relies on, and make someone responsible for making them agent-accessible (CLI or MCP server)."
- The right tools don't just expand what agents can do — they **improve the reliability of everything they already do**. Linters and test suites before committing increase confidence in every diff.
- Browser automation for e2e testing dramatically improves thoroughness — agents catch bugs invisible from code alone. (Confirmed by both OpenAI and Anthropic teams.)

### 3. Make Tooling Teach the Agent

OpenAI's cleverest trick: **custom linter error messages that double as remediation instructions**. When an agent violates an architectural constraint, the error message tells the agent *how to fix it*. The tooling teaches the agent while it works.

Brockman: "Write tests which are quick to run, and create high-quality interfaces between components."

### 4. AGENTS.md as Living Feedback Loop

AGENTS.md is an emerging convention — a Markdown file at the repo root that coding agents read at session start. Build steps, testing commands, coding conventions, architectural constraints, common pitfalls.

What makes it load-bearing infrastructure rather than another rotting doc is the **usage pattern**:

- **Update it every time the agent does something wrong.** Hashimoto's [Ghostty AGENTS.md](https://github.com/ghostty-org/ghostty/blob/ca07f8c3f775fe437d46722db80a755c2b6e6399/src/inspector/AGENTS.md): each line corresponds to a specific past agent failure now prevented.
- **Point to deeper sources of truth.** OpenAI's team kept a small AGENTS.md linking to design docs, architecture maps, execution plans, quality grades — all versioned in the repo.
- **Automate doc maintenance.** A background agent periodically scanned for stale documentation and opened cleanup PRs. Documentation *for* agents, *by* agents.
- **Use structured formats for state.** Anthropic found JSON > Markdown for feature tracking — agents are less likely to inappropriately edit or overwrite structured data.
- **Structured progress files serve as shift handoffs** between agent sessions that have no shared memory. (Anthropic's approach to long-running agents.)

---

## Part II: Managing the Work

### 5. Plan Extensively Before Execution

Boris Tane (Cloudflare): "The separation of planning and execution is the single most important thing I do. It prevents wasted effort, keeps me in control of architecture decisions, and produces significantly better results than jumping straight to code."

- Anthropic's "initializer agent" generates a comprehensive feature list from a high-level prompt — 200+ individual features with explicit test steps, all initially marked "failing." This decomposition prevents one-shotting and premature victory declarations.
- The work that matters most now happens **before any code is written**.

### 6. Hold the Review Bar

"Say no to slop." When agents produce PRs faster than you can review, the temptation is to lower the bar. Every source argues against this.

- Brockman: "Ensure some human is accountable for any code that gets merged. As a code reviewer, maintain at least the same bar as you would for human-written code."
- Steinberger ships code he doesn't read line-by-line but acts as **architectural gatekeeper** ("benevolent dictator"). In his contributor Discord, he talks only architecture and big decisions, never code.
- Review at a higher abstraction: too clever? too repetitive? maintenance headaches in 6 months? right abstraction level?
- The author calls this skill **"bullshit detection" / taste** — it becomes more critical, not less, as output volume increases.

### 7. Parallelize — Two Distinct Modes

**Attended**: Actively managing multiple agent sessions, checking in, redirecting. Steinberger runs 5–10 simultaneously. The author caps at 3–4 before becoming the bottleneck. More control, catches problems early, but cognitively demanding.

**Unattended**: Developer posts a task and walks away. Agent handles everything through CI; human re-enters at review. Stripe's mode — developer posts in Slack, Minion writes code, passes CI, opens PR. No interaction in between.

These have different prerequisites. Unattended requires a **mature harness** — good CI, comprehensive tooling, high trust. Stripe can do it because of Toolshed, pre-warmed devboxes, and tight CI integration. Most teams aren't there yet. Expect the balance to shift toward unattended as harnesses improve and models get better at sustaining longer tasks.

---

## Open Problems (No Convincing Answers Yet)

1. **Code entropy.** Agent-generated code accumulates cruft differently than human-written code. "Garbage collection" agents that scan for inconsistencies are emerging but immature. (Brockman: how do you prevent "functionally-correct but poorly-maintainable code"?)
2. **Verification at scale.** Agents mark features complete without proper e2e testing. Absent explicit prompting, they fail to recognize something doesn't work. Even browser automation has blind spots — e.g., Anthropic found Puppeteer can't see browser-native alert modals, so features using those modals ended up buggier.
3. **Brownfield retrofit.** All success stories are greenfield or purpose-built harnesses. Applying to a legacy codebase with no architectural constraints, inconsistent testing, and patchy docs is an open question. (Böckeler: like running a static analysis tool on a codebase that's never had one — you'd drown in alerts.)
4. **Cultural adoption.** Someone has to build all of this. Engineers who love solving algorithmic puzzles struggle to go agent-native; those who love shipping products adapt quickly. Even Steinberger spends a significant chunk of his time on the meta-work of making agents effective rather than on the product itself.

---

## The Compounding Argument

The investment compounds. Every AGENTS.md update prevents a class of future failures. Every custom linter teaches every future agent session. Every tool exposed via MCP makes every subsequent task faster. Upfront cost is significant, but returns accelerate.

Supporting data: OpenAI's three-engineer team averaged **3.5 PRs per engineer per day** over five months building a million-line product — and **throughput increased as the team grew**, suggesting the harness scales rather than degrading.
