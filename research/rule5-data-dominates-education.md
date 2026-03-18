← [Index](../README.md)

# Rule 5: Data Dominates — A Deep Breakdown

**Origin:** Rob Pike's 5 Rules of Programming (1989)
**Related:** [HN distillation](./hn-rob-pike-rules-of-programming.md)

> "If you've chosen the right data structures and organized things well, the algorithms will almost always be self-evident. Data structures, not algorithms, are central to programming."

## What It Actually Means

Most programmers think about code as **procedures** — a sequence of steps to accomplish a task. Rule 5 says: flip it. Think about the **shape of your data** first. When the data is right, the code writes itself. When the data is wrong, no amount of clever code can save you.

Or as Fred Brooks put it in *The Mythical Man-Month* (1975): "Show me your flowcharts and conceal your tables, and I shall continue to be mystified. Show me your tables, and I won't usually need your flowcharts; it'll be obvious."

## The Intuition

Think of it like furniture in a room. If you arrange the furniture well, the paths people walk become obvious — you don't need signs. If the furniture is badly arranged, you end up with duct tape arrows on the floor, ropes guiding people around, exception signs everywhere. That's what bad data structures do to your code — they force you to write navigational logic that shouldn't exist.

---

## Examples

### 1. Permission System

#### Before — Logic-Dominated

You need to check if a user can perform actions. You start thinking procedurally:

```python
def can_edit(user, document):
    if user.role == "admin":
        return True
    if user.role == "editor" and document.department == user.department:
        return True
    if user.id == document.owner_id:
        return True
    if user.role == "editor" and document.is_public:
        return True
    return False

def can_delete(user, document):
    if user.role == "admin":
        return True
    if user.id == document.owner_id and user.role != "viewer":
        return True
    return False

def can_share(user, document):
    if user.role == "admin":
        return True
    if user.id == document.owner_id:
        return True
    if user.role == "editor" and document.department == user.department:
        return True
    return False
```

Every new action = a new function with its own `if` tree. Every new role = you touch every function. The logic is scattered. Bugs hide in the inconsistencies between functions. Adding "can a manager share cross-department?" means editing three places.

#### After — Data-Dominated

Stop. Think about data first. What *is* a permission? It's a relationship: **(role, action, condition) → allowed**.

```python
PERMISSIONS = {
    "admin":  {"edit", "delete", "share", "admin"},
    "editor": {"edit", "share"},
    "viewer": {"view"},
    "owner":  {"edit", "delete", "share"},
}

SCOPE_RULES = {
    "editor": lambda user, doc: doc.department == user.department or doc.is_public,
    "viewer": lambda user, doc: True,
    "owner":  lambda user, doc: True,
    "admin":  lambda user, doc: True,
}

def get_roles(user, document):
    roles = {user.role}
    if user.id == document.owner_id:
        roles.add("owner")
    return roles

def can(user, document, action):
    return any(
        action in PERMISSIONS.get(role, set())
        and SCOPE_RULES.get(role, lambda u, d: False)(user, document)
        for role in get_roles(user, document)
    )
```

Now:
- Adding a new action = add a string to a set
- Adding a new role = one entry in each dict
- The `can()` function **never changes**
- You can serialize `PERMISSIONS` to a database and make it user-configurable
- You can unit test the data table exhaustively with a matrix

**The algorithm (`can`) became trivial because the data structure encodes the domain.**

### 2. State Machine (Order Processing)

#### Before — Code-as-State-Machine

```python
def process_order(order):
    if order.status == "new":
        if payment_received(order):
            order.status = "paid"
            notify_warehouse(order)
        elif order.age_hours > 48:
            order.status = "cancelled"
            refund_if_needed(order)
    elif order.status == "paid":
        if warehouse_confirmed(order):
            order.status = "shipped"
            send_tracking_email(order)
        elif warehouse_rejected(order):
            order.status = "cancelled"
            process_refund(order)
    elif order.status == "shipped":
        if delivery_confirmed(order):
            order.status = "delivered"
            request_review(order)
    # ... 12 more elif blocks
```

The state machine is **implicit in the control flow**. You can't answer "what transitions are possible from state X?" without reading every branch. Adding a new state means weaving it into the existing spaghetti.

#### After — Data-Dominated

Make the state machine **explicit data**:

```python
TRANSITIONS = {
    "new": [
        {"when": payment_received,    "to": "paid",      "do": [notify_warehouse]},
        {"when": expired_48h,         "to": "cancelled",  "do": [refund_if_needed]},
    ],
    "paid": [
        {"when": warehouse_confirmed, "to": "shipped",    "do": [send_tracking_email]},
        {"when": warehouse_rejected,  "to": "cancelled",  "do": [process_refund]},
    ],
    "shipped": [
        {"when": delivery_confirmed,  "to": "delivered",  "do": [request_review]},
    ],
}

def process_order(order):
    for transition in TRANSITIONS.get(order.status, []):
        if transition["when"](order):
            order.status = transition["to"]
            for action in transition["do"]:
                action(order)
            break
```

Now you can:
- See **all possible transitions** at a glance
- Generate a state diagram automatically from the data
- Add a new state without touching the engine
- Test transitions as data: "from state X with condition Y, do we reach Z?"

The engine is 6 lines. It will **never change**. All future complexity goes into the data table, where it's visible and testable.

### 3. Scheduling / Calendar Conflicts

#### Before — Algorithm-First

"Find all conflicting meetings." You start writing nested loops and comparisons:

```python
def find_conflicts(meetings):
    conflicts = []
    for i, a in enumerate(meetings):
        for j, b in enumerate(meetings):
            if i >= j:
                continue
            if a.start < b.end and b.start < a.end:
                if a.room == b.room:
                    conflicts.append((a, b))
    return conflicts
```

Looks reasonable for 10 meetings. For 10,000 across 500 rooms, it's O(n²).

#### After — Data-Structure-First

Ask: what's the right way to **organize** meetings so conflicts become obvious?

**Group by the dimension that partitions conflicts** (room), then sort by the dimension that orders them (time):

```python
from collections import defaultdict

def find_conflicts(meetings):
    by_room = defaultdict(list)
    for m in meetings:
        by_room[m.room].append(m)

    conflicts = []
    for room, room_meetings in by_room.items():
        room_meetings.sort(key=lambda m: m.start)
        for i in range(len(room_meetings) - 1):
            a, b = room_meetings[i], room_meetings[i + 1]
            if a.end > b.start:
                conflicts.append((a, b))
    return conflicts
```

- O(n log n) instead of O(n²)
- The algorithm is a trivial linear scan — **the sort did the work**
- More importantly: the *grouping* did the thinking. Once meetings are partitioned by room and sorted by time, conflict detection is just "check your neighbor"

You didn't invent a clever algorithm. You organized the data so that the obvious algorithm is the fast one.

---

## The Step-by-Step Method

When you face a problem, try this:

### Step 1: Name the entities

What are the *things* in this problem? Users, documents, orders, events, connections? Write them down. Don't write any code.

### Step 2: Name the relationships

How do these things relate? One-to-many? Many-to-many? Hierarchical? Sequential? Temporal? This is where most design thinking should happen.

### Step 3: Pick representations that make relationships queryable

The key question: **what questions will your code need to ask of this data?**

- "Who owns this?" → Put an `owner_id` on the thing
- "What's in this group?" → A dict keyed by group
- "What comes next?" → A sorted list or linked structure
- "Is X related to Y?" → A set or adjacency map
- "What's the current state?" → An enum with a transition table

The representation should make your most common query **trivial** — O(1) lookup, simple iteration, direct access. If answering a common question requires looping through everything, your data structure is wrong.

### Step 4: Write the dumbest possible code against that structure

If you did steps 1–3 well, the code should be boring. If you find yourself writing complex branching logic, that's a signal the data structure is fighting you. **Go back to step 3.**

### Step 5: Validate by trying to extend

Mentally add a new requirement. Does it mean:
- **(a) Adding data** to the structure (new row in a table, new key in a dict)? ✅ Good.
- **(b) Adding logic** to the code (new if-branch, new special case)? ❌ The structure is leaking.

If extension means more data, you're on the right track. If extension means more code, your data isn't dominating — your code is compensating for a data model that doesn't capture the domain.

---

## The Deeper Principle

Rule 5 is really about **where complexity lives**. Complexity is conserved — you can't eliminate it, only move it. You have two choices:

| | Data-dominated | Code-dominated |
|---|---|---|
| Complexity lives in | Explicit, inspectable structures | Implicit control flow |
| Adding features means | Adding data | Adding branches |
| Testing is | Systematic (enumerate the data) | Combinatorial (trace all paths) |
| Reading the code | Structure tells you the design | You must simulate execution |

The reason experienced developers converge on this rule is that **data is legible**. You can print it, diff it, serialize it, visualize it. Code paths are invisible until executed. A dict you can stare at. A 200-line `if/elif` chain you can only simulate in your head.

---

## Connection to Functional Programming

Rule 5 and functional programming arrive at the same destination from different starting points. Rule 5 is engineering advice: pick good representations and the code becomes obvious. FP is a paradigm: computation *is* data transformation. Both put data before procedures. Both treat code as secondary to structure.

### Where They Converge

**1. Data is visible, not hidden**

OOP's core principle — encapsulation — encourages **hiding** data behind methods. You call `order.process()` and the object mutates internally. The data shape is private; you can't inspect it, diff it, or reason about it from outside.

FP encourages **exposing** data as immutable values and passing them through functions. You call `process(order)` and get back a *new* order. The data flows visibly through the program.

```python
# OOP: data hidden, logic scattered across methods
class Order:
    def process(self):
        if self._status == "new" and self._payment_ok():
            self._status = "paid"
            self._notify_warehouse()
    # Where does the data live? Buried in self._*
    # What shape is it? Read every method to find out.

# FP-style: data explicit, logic is transformation
def process(order: Order) -> Order:
    match order.status:
        case "new" if payment_ok(order):
            return replace(order, status="paid")
    return order
# Data shape is the Order type. Visible. Inspectable.
# process() is: Order → Order
```

This maps directly to Rule 5. When data is hidden behind behavior, you must read all the methods to understand the system. When data is explicit and central, you look at the structures and the program's logic follows.

**2. Perlis's Epigram is FP's design bet**

Alan Perlis, in *Epigrams on Programming* (1982):

> "It is better to have 100 functions operate on one data structure than 10 functions on 10 data structures."

This is functional programming's core design philosophy, taken to its extreme by Clojure. In Clojure, almost everything is a map, vector, or set. The standard library provides `map`, `filter`, `reduce`, `group-by`, `sort-by`, `update-in`, and dozens more — all operating on the same generic structures. You don't define a `CustomerList` class with bespoke methods; you have a vector of maps and use the same functions you use for everything else.

This is Rule 5 operationalized: a small number of well-chosen data structures plus a rich vocabulary of generic operations means you rarely need custom algorithms.

**3. Types-first design**

Languages in the ML family (Haskell, OCaml, ReScript) push you to **define your types before writing any functions**. This is Rule 5's step-by-step method enforced by the compiler:

```haskell
-- Step 1-2: Name entities and relationships FIRST
data OrderStatus = New | Paid | Shipped | Delivered | Cancelled

data Order = Order
  { orderId   :: OrderId
  , status    :: OrderStatus
  , items     :: [Item]
  , createdAt :: UTCTime
  }

-- Step 4: Write the dumbest possible code
process :: Order -> Order
process order = case status order of
  New | paymentReceived order -> order { status = Paid }
  _                          -> order
```

You can't write the function until you've defined the data. The language forces you to think about shape first. This is why learning a typed functional language is one of the fastest ways to internalize Rule 5 — the compiler won't let you skip it.

**4. The shared habit**

| FP habit | Rule 5 equivalent |
|---|---|
| Define types before functions | Design data structures before algorithms |
| Prefer immutable values | Make data inspectable and diffable |
| Compose generic transformations | Write simple code on well-chosen structures |
| Separate data from behavior | Don't hide structure behind methods |
| Make state changes explicit | Keep the data shape visible |

### Where They Diverge

Rule 5 is paradigm-agnostic. It says: **make the data shape right for your domain**. Sometimes that means a mutable array. Sometimes a relational table. Sometimes an immutable persistent tree. FP has opinions about *which* data structures and patterns are acceptable (immutability, referential transparency); Rule 5 doesn't care — it only asks whether the structure makes the algorithm obvious.

FP can also violate Rule 5's spirit through its own forms of overengineering:

- **Excessive type abstraction.** When everything is a typeclass or generic trait, the concrete data shape disappears. You know something is a `Functor` but can't tell what it *contains*.
- **Monad stacking.** A signature like `ReaderT Config (StateT AppState (ExceptT AppError IO)) a` has data in it, technically, but it's buried under layers of abstraction. The "shape" is obscured, not clarified.
- **Premature generalization.** Writing `Foldable t => t a -> [a]` when you have a list and will only ever have a list. The abstraction adds indirection without making the data relationship clearer.

These are FP-specific failure modes, but the underlying error is the same one Rule 5 warns against: letting abstractions dominate instead of letting the data structure lead.

### The Kay–Hickey Tension

There's a genuine philosophical divide. Alan Kay — originator of Smalltalk and the OOP concept — argues that "data" is the wrong primitive. His position: data without an interpreter is dead bytes. What matters is **meaning**, not structure. Objects should be "ambassadors that can negotiate with other objects they've never seen" (Kay, [HN discussion, 2016](https://news.ycombinator.com/item?id=11945722); [Quora posts on "meaning vs data"](https://qr.ae/pCVB9m)).

Rich Hickey (Clojure's creator) takes the opposite view: data is simple, universal, and composable. Wrapping data in objects makes it opaque and domain-locked. In his 2012 keynote *The Value of Values* (JaxConf), Hickey argues that most of what we call "objects" should just be immutable values — maps, vectors, sets — because values can be printed, compared, serialized, and reasoned about. Objects can't.

Rule 5 sides with Hickey for single-system design. But Kay's point gains force in distributed systems, where data crosses service boundaries and needs to be self-describing and evolvable — which is why the industry converged on formats like JSON, Protobuf, and Avro with schema registries, rather than passing raw structs.

---

## The Ecosystem Problem: Lisp Curse and Clojure

Rule 5 is advice for individual projects: get the data right, and the code follows. But what happens when you zoom out from one codebase to an entire language ecosystem? The history of Lisp and Clojure reveals a tension between individual design freedom and collective convergence.

### The Lisp Curse

Rudolf Winestock's essay *The Lisp Curse* (c. 2011) makes a specific argument: Lisp is so expressive that any individual programmer can build their own solution to any problem. The result is that Lisp communities **never converge**. Instead of one good HTTP library, you get twelve half-finished ones. Instead of one web framework, you get none — because everyone rolls their own and it's "good enough" for their case.

The key insight: "Lisp is so powerful that problems which are technical issues in other programming languages are social issues in Lisp" (Winestock).

The connection to Rule 5 is ironic. Perlis's epigram says "100 functions on 1 data structure." The Lisp Curse produces the opposite in practice: **100 data structures with 1 function each.** Every Lisper designs their own representation for the same domain, writes code that works on *their* representation, and never collaborates because translating between representations is friction nobody wants to pay.

Rule 5 is correct at the individual project level. It breaks down at the ecosystem level when there's no forcing function for convergence. This is a **coordination problem**, not an engineering problem.

### Clojure: Rule 5 as Language Design

Clojure (Rich Hickey, first released 2007) is the most deliberate attempt to solve the Lisp Curse through Rule 5. Hickey made specific design choices:

- **Standardize on a tiny set of immutable data structures**: maps, vectors, sets, lists. No custom classes for domain modeling — use maps.
- **Build a rich standard library** of generic functions that operate on these structures: `map`, `filter`, `reduce`, `group-by`, `update-in`, `assoc`, `dissoc`, etc.
- **Host on the JVM** (and later JS via ClojureScript) to piggyback on an existing ecosystem instead of building one from scratch.

This is Perlis's epigram as language design. A handful of data structures, hundreds of functions. It works — Clojure developers report that data-first design feels natural in the language. Nubank, a major Brazilian fintech, built its core systems on Clojure. Companies that adopt it tend to keep it.

### Why Clojure Didn't Achieve Mainstream Adoption

Not because "data dominates" is wrong. Because language adoption has almost nothing to do with engineering philosophy:

1. **Syntax barrier.** Lisp's parenthesized prefix notation is unfamiliar to developers trained on C-family syntax. This is aesthetic, not rational, but it's a real adoption filter.
2. **Dynamic typing in a static-typing era.** The industry moved toward TypeScript, Rust, Go — all statically typed. Clojure's `spec` system (for optional runtime validation) arrived late and is opt-in.
3. **The cognitive switch.** "Just use maps" sounds simple but requires a fundamentally different way of thinking than OOP-trained developers are used to. Rule 5 is *hard to internalize* even when the language supports it.
4. **Hiring pipeline.** Companies adopt languages they can hire for. No bootcamps teach Clojure. The ecosystem stays small because it's small — a classic chicken-and-egg trap.
5. **Hickey's withdrawal.** Rich Hickey stepped back from active Clojure development. Evolution slowed. The community is stable but not growing.

**The deeper lesson:** Rule 5 tells you how to write good software. It tells you nothing about what wins in the market. Being right doesn't cross the adoption chasm. Developer familiarity, hiring economics, corporate sponsorship, and ecosystem momentum do.

**However:** Clojure's *ideas* are spreading even as the *language* stays niche. TypeScript's increasing use of plain objects and type-narrowing, Python's dataclasses and TypedDicts, Rust's emphasis on data layout and ownership — these all reflect data-first thinking without requiring Clojure's syntax or ecosystem. Rule 5 is winning at the idea level, even if its purest language embodiment isn't.

---

## Do Data Models Converge?

A natural objection arises: if Rule 5 is correct — if there are "right" data structures for given domains — why hasn't software converged on canonical data models the way science converged on the periodic table or Newtonian mechanics?

The answer: **it has, far more than is commonly recognized.** And the comparison to science is more apt than it first appears.

### The Evidence: Software Has Converged Significantly

| Domain | Converged data model | Approximate age |
|---|---|---|
| Relational data | Tables, rows, columns, SQL (Codd, 1970; SQL standard, 1986) | ~55 years |
| Accounting | Double-entry ledger — debits and credits on accounts (Pacioli codified it, 1494) | ~530 years |
| Web interchange | JSON (Crockford, early 2000s; ECMA-404, 2013) | ~25 years |
| Web APIs | Resources + HTTP verbs + status codes — REST (Fielding, 2000) | ~25 years |
| E-commerce | Product → Cart → Order → LineItem → Payment | ~25 years |
| CRM | Contact → Account → Opportunity → Activity (Salesforce model, c. 1999) | ~25 years |
| Healthcare records | HL7 FHIR — Patient, Observation, Condition, etc. (first draft 2014) | ~10 years, maturing |
| Version control | Commits, branches, DAG of snapshots (Git, Torvalds, 2005) | ~20 years |
| Financial messaging | FIX protocol (1992), FpML | ~30+ years |
| ERP | SAP's entity model — Materials, Plants, Sales Orgs, etc. (R/3, c. 1992) | ~30+ years |

These aren't obscure standards. They're the backbone of most business software. The e-commerce data model (product/cart/order/payment) is as standardized in its domain as the periodic table is in chemistry — every Shopify store, every Amazon clone, every payment processor uses essentially the same entities and relationships.

### The Convergence Pattern

The pattern across these examples parallels scientific convergence:

**Stage 1 — Exploration.** Domain is new. Everyone experiments. Multiple representations compete. High fragmentation. *(Early web frameworks; ML pipelines today.)*

**Stage 2 — Informal convergence.** Practitioners discover what works. Patterns crystallize in blog posts, conference talks, influential open-source projects. *(Current state for most microservices patterns and event-driven architectures.)*

**Stage 3 — Formal standardization.** Industry bodies or dominant players codify the model. SQL, REST, HL7 FHIR, OpenAPI. The data model becomes infrastructure. *(Where e-commerce, finance, and healthcare are now.)*

**Stage 4 — Stable core, divergent edges.** The core model is settled. Innovation happens at the boundaries — new entity types, new relationships, domain-specific extensions. *(Where relational databases and accounting are — nobody questions double-entry, but people argue about how to model crypto assets within it.)*

The timescale is shorter than science (decades vs. centuries) because feedback loops are faster — deploy and observe vs. theorize and experiment.

### Why Some Domains Resist Convergence

The domains that *haven't* converged share properties that differ from both science and the domains listed above:

1. **Genuine diversity.** An "order" at Amazon, a restaurant, and a hospital are fundamentally different entities with different lifecycles, constraints, and relationships. Unlike atoms (which really are the same everywhere), business entities vary because businesses vary.
2. **Requirements evolve faster than representations stabilize.** Chemistry's subject matter is fixed. Business rules change quarterly. ML pipelines can't stabilize because the research keeps changing what "model," "dataset," and "experiment" mean.
3. **Conway's Law.** "Organizations which design systems are constrained to produce designs which are copies of the communication structures of those organizations" (Melvin Conway, 1967). Two companies in the same industry with different org structures will produce different schemas for the same domain.
4. **No replication pressure.** In science, independent groups must reproduce results using shared formalisms — this forces convergence. In software, each codebase is private. There's no "peer review" of your schema. Bad data models survive indefinitely because nobody outside the company sees them.

### Comparison to Science

Science converged because **reality is one, and feedback is honest.** If your model of an atom is wrong, your experiments fail. Nature is the arbiter and it's the same for everyone.

Software converges more slowly because **business domains are many, and feedback is noisy** — a bad schema can survive for years behind enough developer effort and hardware.

But the trajectory is the same. Both are driven by the same mechanism: wrong representations create pain, right representations make everything obvious. The key variable is **how quickly wrong representations get selected out.** In science, experiments fail immediately. In software, the pain is deferred (tech debt, maintenance cost, performance degradation).

Rule 5 at the individual level ("get the data right for your project") is the same principle as industry-level convergence ("the field discovers the right data model for this domain"). Both are driven by the feedback loop between representation and problem-solving friction.

---

## The AI Coding Agent Era

What happens to Rule 5 when AI agents write most of the code?

### What AI Gets Wrong

AI coding agents are pattern matchers trained on the corpus of existing code. Most existing code is mediocre, procedurally structured, and code-dominated. So AI defaults to:

- Procedural logic with lots of branching
- Naive data structures (flat dicts, generic lists, no domain modeling)
- Code that *works* but doesn't *reveal* the domain

Multiple practitioners in the [HN thread on Pike's rules](https://news.ycombinator.com/item?id=47423647) (2026) confirmed this. User `ta20211004_1`: "Claude is much more likely to suggest or expand complex control flow logic on small data types than it is to recognize and implement an opportunity to encapsulate ideas in composable chunks." User `bfivyvysj`: "The data structures [from AI] are incredibly naive... no amount of context management will help you, it is fighting against the literal mean." User `jerf`: "AI tends to code the same way it documents... it won't have either clear flow charts or tables unless you carefully prompt for them."

AI is competent at the *code* half of Rule 5 — writing simple operations on well-designed structures. It is weak at the *design* half — choosing the right structures in the first place. That requires domain judgment that can't be pattern-matched from GitHub.

### The Cost Equation Shifts — Asymmetrically

The bull case for AI: if code is cheap to rewrite, who cares if the data structures are initially wrong? Just regenerate everything.

This is half right. AI makes **code** cheap to change. It does not make **data** cheap to change. Data structures are architectural:

- **Database schemas** have migrations, foreign keys, and millions of rows that need to move.
- **API contracts** have external consumers who will break.
- **Event formats** in distributed systems have downstream subscribers.
- **State shapes** in frontends determine component hierarchies.

You can regenerate all the code in an afternoon. You cannot regenerate a production database schema with three years of data in it. **The AI era makes Rule 5 more important, not less** — the part AI does well (code) is now cheap, and the part it does poorly (data design) is still expensive to get wrong.

### The Lisp Curse Intensifies

The Lisp Curse was about expressiveness enabling fragmentation — every programmer powerful enough to roll their own. AI agents are the ultimate version of this.

When every developer has an agent that can generate a bespoke solution in minutes:

- There's even less incentive to learn and use shared libraries.
- Every codebase becomes a snowflake with its own representations.
- Interoperability gets worse because the generated code has no shared design vocabulary.
- The "100 data structures with 1 function each" anti-pattern scales further.

However, this mostly affects the *code* layer. If AI consistently generates the same *schema structure* for the same *domain problem* — because the training data converges on it — the code can be bespoke while the data model converges. Code fragmentation and data model convergence can coexist on different axes.

### The Convergence Counterargument

AI may actually **accelerate data model convergence**, not hinder it. The bottleneck to convergence has always been exploration and evaluation cost, not invention:

1. **Cheaper exploration.** An AI agent can generate 20 schema variations in the time a human produces one. It can sketch downstream implications — what queries each schema makes easy, what migrations each one requires.
2. **Cross-codebase pattern recognition.** AI trained on millions of repositories can identify convergent patterns no individual human could see: "In 80% of e-commerce codebases that survived past year 3, the order model has these properties."
3. **Faster feedback loops.** AI can simulate access patterns, generate test data, and stress-test a schema against hypothetical requirements *before you commit to it*.
4. **Lower migration cost.** If AI makes it cheaper to generate migration scripts and update downstream code, more teams will *actually refactor* data models when they learn more, instead of living with tech debt forever.

This parallels how computational tools accelerated scientific convergence — molecular dynamics simulations, protein folding models, climate simulations all compressed the exploration-to-convergence timeline.

### The Compounding Debt Paradox

There's a risk specific to the AI era:

1. AI generates naive structures → code works but is fragile.
2. More AI-generated code builds on those structures → architecture calcifies.
3. Requirements change → data model can't accommodate them → human redesign needed.
4. But the human hasn't been practicing data design because AI was writing everything → the skill has atrophied.

This is the scenario where Rule 5 matters most and gets practiced least. The mitigation is to keep data design as a human-owned responsibility, even as code generation is delegated to AI.

---

## Applying Rule 5 to AI-Assisted Development

Three levels of intervention, ordered by effort and ROI.

### Level 1: Prompt Engineering (start here)

Add data-first design requirements to your agent's system prompt or AGENTS.md:

```markdown
## Data-First Design (Rule 5)

Before writing ANY implementation code:
1. Define the core entities and their relationships.
2. Show me the data structures / schema / types FIRST.
3. I will review the data model before you proceed.
4. If you find yourself writing complex branching logic, STOP —
   the data structure is probably wrong. Propose a restructure.

When refactoring: look for if/elif chains, switch statements, and
type-checking conditionals. These are symptoms of data that doesn't
capture the domain. Propose a data structure that eliminates them.
```

This works because AI *will* do data-first design if explicitly required — the default is mediocre because nobody asks, not because the model can't do it (`jerf` in the HN thread confirmed this). **Test this first and measure whether output improves before investing in anything more complex.**

### Level 2: Pattern Catalog (if Level 1 is insufficient)

A small reference of problem shapes mapped to data-dominant patterns. The emphasis is on *recognition* — "I see this shape of problem, I should reach for this pattern":

| Problem shape | Data-dominant pattern | Why it works |
|---|---|---|
| Multiple conditions → different behavior | Lookup table / decision matrix | New cases = new data rows, not new branches |
| Entity moves through stages | Explicit state machine (transition table) | All transitions visible, engine never changes |
| "Can X do Y to Z?" | Permission / capability matrix | Relationships as data, not scattered if-checks |
| Transform A→B with variations | Pipeline of named steps (data) | Steps are reorderable, composable, testable |
| Hierarchical categorization | Tree / DAG as data, generic traversal | Structure changes don't require code changes |
| Repeated similar-but-different logic | Configuration-driven (data describes variants) | Variants are data rows, not code forks |

This table plus one concrete before/after per row is likely more useful than a large collection of curated codebases. It teaches the recognition skill, not just the pattern.

### Level 3: Fine-Tuning (likely unnecessary)

Custom-training a model on data-dominant codebases. This requires defining "data-dominant" in a machine-evaluable way, curating training data, running fine-tuning, and evaluating results. Weeks to months of work.

**Caution:** The harder problem isn't "show the AI good examples" — it's "teach the AI to evaluate domain requirements and pick the right structure." That's reasoning, not pattern-matching. Fine-tuning on a curated set risks trading one bias (code-first) for another (data-first cargo cult — reaching for lookup tables and state machines where a simple function would be better).

The right sequence: Level 1 → measure → Level 2 if needed → measure → Level 3 only with evidence that 1 and 2 aren't sufficient.

---

## Data-Dominant Codebases in the Wild

Real-world systems where the data model *is* the architecture, worth studying:

| System | Data model | Why it's exemplary |
|---|---|---|
| **Git** (Torvalds, 2005) | Blobs, trees, commits, refs — a content-addressed DAG | Every operation (branch, merge, log, diff) derives from this object model. The code is just traversal. |
| **Redis** (Sanfilippo, 2009) | Strings, lists, sets, sorted sets, hashes, streams | The entire API is organized by data structure. Each command is an operation on a specific type. The data structure *is* the product. |
| **SQLite** (Hipp, 2000) | B-tree pages, cells, overflow chains | The on-disk format drives the entire architecture. All code follows from the page structure. |
| **Kubernetes** (Google, 2014) | Declarative resource types (Pod, Service, Deployment) + reconciliation controllers | The desired-state data model *is* the system. Controllers are just loops: read desired state, compare to actual, reconcile. |
| **PostgreSQL system catalog** | `pg_class`, `pg_attribute`, `pg_type`, etc. — the database describes itself as tables | The server is essentially "code that operates on the catalog." Schema information is data, queryable with SQL. |
| **Datomic** (Hickey, 2012) | Entity-attribute-value triples, immutable and time-indexed | Database as a value. The data model makes time-travel queries and auditing trivial — no special code needed. |
| **Unix filesystem** (Thompson & Ritchie, 1969) | Inodes, directory entries, file descriptors | "Everything is a file" is a data abstraction. Once you have file descriptors and inodes, pipes, sockets, and devices are just the same operations on different data. |

---

## Related Quotes

- **Fred Brooks**, *The Mythical Man-Month* (1975): "Show me your tables, and I won't usually need your flowcharts; it'll be obvious."
- **Linus Torvalds**, [git mailing list](https://lwn.net/Articles/193245/) (2006): "Bad programmers worry about the code. Good programmers worry about data structures and their relationships."
- **Alan Perlis**, *Epigrams on Programming*, SIGPLAN Notices 17(9) (1982): "It is better to have 100 functions operate on one data structure than 10 functions on 10 data structures."
- **Rich Hickey**, *The Value of Values*, JaxConf keynote (2012): Values — immutable data — can be printed, compared, serialized, and shared. Objects can't.
- **Rudolf Winestock**, *The Lisp Curse* (c. 2011): "Lisp is so powerful that problems which are technical issues in other programming languages are social issues in Lisp."
- **Melvin Conway** (1967): "Organizations which design systems are constrained to produce designs which are copies of the communication structures of those organizations."

---

Get the data right, and the code becomes obvious. Get it wrong, and no amount of cleverness saves you.
