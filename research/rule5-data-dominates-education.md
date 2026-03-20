← [Index](../README.md)

# Rule 5: Data Dominates — A Deep Breakdown

**Origin:** Rob Pike's 5 Rules of Programming (1989)
**Related:** [HN distillation](./hn-rob-pike-rules-of-programming.md) · [Unix philosophy — complete reference](./unix-philosophy-complete.md)

> "If you've chosen the right data structures and organized things well, the algorithms will almost always be self-evident. Data structures, not algorithms, are central to programming."

## What It Actually Means

Most programmers think about code as **procedures** — a sequence of steps to accomplish a task. Rule 5 says: flip it. Think about the **shape of your data** first. When the data is right, the code writes itself. When the data is wrong, no amount of clever code can save you.

Or as Fred Brooks put it in *The Mythical Man-Month* (1975, pp. 102–103): "Show me your flowcharts and conceal your tables, and I shall continue to be mystified. Show me your tables, and I won't usually need your flowcharts; they'll be obvious."

## The Intuition

Think of it like furniture in a room. If you arrange the furniture well, the paths people walk become obvious — you don't need signs. If the furniture is badly arranged, you end up with duct tape arrows on the floor, ropes guiding people around, exception signs everywhere. That's what bad data structures do to your code — they force you to write navigational logic that shouldn't exist.

---

## Examples

### 1. State Machine (Order Processing)

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

### 2. Scheduling / Calendar Conflicts

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

### 3. Permission System — When Decomposition Meets Reality

The first two examples are clean wins for Rule 5 — the problems decompose naturally into data, and the engines are trivial. Permission systems look like they should work the same way. Often they don't.

#### Before — Disorganized Procedural Code

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

Three functions, each with its own if-tree. The admin check is duplicated everywhere. Editor conditions are split across `can_edit` with the owner check wedged between them. Adding a role means touching every function. Adding an action means writing another function with another copy of the admin/owner boilerplate.

But the deeper problem isn't duplication — it's that the code doesn't read like a policy. The structure follows no organizing principle: not grouped by role, not ordered by priority, just whatever order the developer thought of the cases.

#### Data-Dominant Refactoring

Apply Rule 5. What *is* a permission? A relationship: **(role, action, condition) → allowed**.

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

Two clean data tables. One six-line engine. Adding a role means one entry in each dict. The engine never changes. You can serialize `PERMISSIONS` to a database and test it with a matrix.

> ⚠️ **This refactoring introduced two behavioral changes from the original.** Compare the before and after carefully — what permissions changed? Try to identify them before reading on.

#### The Bugs

**Bug 1 — Editor sharing scope widened.** The original allows editors to *edit* public cross-department docs but only *share* within their department. The refactored version uses one scope rule per role for all actions — so editors can now share public docs from any department. The decomposition assumed scope varies by **role** alone, but it actually varies by **(role, action)**.

**Bug 2 — Viewer-owners can now delete.** The original explicitly blocks this: `user.role != "viewer"` in `can_delete`. The refactored version treats roles as purely additive — any granting role is sufficient. But the domain has a restrictive interaction: viewer status overrides ownership for deletion. The data model assumes role independence; the domain has role interference.

Both bugs share a root cause: the domain's rules don't factor into independent dimensions. Scope varies by (role, action), not by role alone. Roles interact non-additively. The clean `(role → actions) + (role → scope)` decomposition silently changed the semantics.

The claimed benefits unravel with it:

- **"Serialize to a database"** — fixing Bug 1 requires `(role, action) → lambda`. Lambdas aren't serializable.
- **"Engine never changes"** — fixing Bug 2 requires deny-logic in the engine.
- **"One entry per role"** — a corrected model needs entries per (role, action) pair, plus restriction rules.

You can force a fix, but the "data" table becomes a dict of lambdas — code wearing a data costume. The indirection adds complexity without adding clarity.

#### After — Clean Procedural Code

The right answer for this domain isn't a data table. It's a single function whose structure mirrors how the business describes the policy:

```python
def can(user, document, action):
    # Admins can do anything
    if user.role == "admin":
        return True

    # Owners can edit, delete, and share their documents
    # Exception: viewers can't delete even their own documents
    if user.id == document.owner_id:
        if action == "delete" and user.role == "viewer":
            return False
        return action in {"edit", "delete", "share"}

    # Editors get department-scoped access
    if user.role == "editor":
        if action == "edit":
            return document.department == user.department or document.is_public
        if action == "share":
            return document.department == user.department

    # All other roles (including viewers): no access
    return False
```

Eighteen lines. Every case handled correctly. A PM can verify it against the spec in 30 seconds.

| | Disorganized procedural | Data-dominant | Clean procedural |
|---|---|---|---|
| Correct? | ✅ Yes | ❌ Two bugs | ✅ Yes |
| Reads like policy? | ❌ Scattered, no structure | ⚠️ Need to trace through lambdas | ✅ Top-to-bottom |
| PM can verify? | ❌ Across three functions | ❌ Across two dicts + engine | ✅ Single function |
| Extend with new role? | Touch every function | Add dict entries (if rules are regular) | Add one block |

#### The Lesson

The state machine and calendar examples decomposed cleanly: independent dimensions, trivial engines, purely inspectable data. That's Rule 5 at its best.

This permission system looked like it should decompose the same way — but the domain has **cross-cutting rules**. Scope varies by (role, action), not by role alone. Roles interact non-additively. These irregularities mean the data table either silently changes semantics (the bugs above) or needs lambdas and exception mechanisms (code in a data costume).

**When clean decomposition doesn't exist, well-structured procedural code is the right answer — not a compromise.** The original three functions weren't bad because they used if/else. They were bad because the if/else was disorganized: scattered conditions, no grouping principle, duplicated checks, an ordering that reflects stream-of-consciousness rather than domain structure.

Good procedural code treats its if/else tree as a **decision tree** and optimizes for two things:

1. **Minimum structure.** No redundant checks. Unify related cases. The three-function version checks `user.role == "admin"` three times; the clean version checks it once.

2. **Semantic match.** The tree's shape mirrors how the business reasons about the policy — what comes first, what's grouped, what's a special case of what. If the business says "admins override everything, then ownership matters, then role-based access," the code has exactly those blocks in exactly that order.

**The test:** can someone who knows the policy but not the codebase read the function and confirm it's correct? If yes, the decision tree matches the domain. If they have to simulate execution paths or cross-reference multiple data structures, it doesn't.

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

## The Same Idea, Different Lenses

Rule 5 is not an isolated observation. Several traditions arrived at the same principle independently, each adding a distinct lens.

### Unix: Rule of Representation

Eric S. Raymond, in *The Art of Unix Programming* (2003), codified Rule 5 as the **Rule of Representation**: "Fold knowledge into data so program logic can be stupid and robust." Raymond explicitly cites Pike's "Notes on Programming in C" as a source. The Unix tradition takes this further: if you can express a domain as a data format (config files, `/proc` entries, `.ini` files, crontabs), you separate the *what* from the *how* and make the system composable with generic tools like `grep`, `awk`, and `sort`.

This is why the Unix filesystem appears in the "codebases in the wild" table: the decision that "everything is a file descriptor" is a data abstraction that made the rest of Unix's design — pipes, redirection, device I/O — fall out naturally. The algorithms are trivial because the representation was right.

### Domain-Driven Design: Rule 5 for Complex Business Software

Eric Evans's *Domain-Driven Design* (2003) is the most systematic methodology for applying Rule 5 to enterprise software. Where Pike gives the principle and a few examples, Evans provides a full toolkit:

- **Entities and Value Objects** — the data-first building blocks. Entities have identity and lifecycle; Value Objects are defined entirely by their data (an `Address` is its fields, not a mutable object with an ID).
- **Aggregates** — boundaries around data consistency. They answer: "what cluster of data must be consistent together?" This is a data design question, not a code question.
- **Bounded Contexts** — the recognition that the same real-world concept (e.g., "customer") has different data representations in different parts of a system. A billing context's `Customer` has payment methods; a shipping context's `Customer` has addresses. Forcing one shared model creates the very "code compensating for wrong data" that Rule 5 warns against.
- **Ubiquitous Language** — the vocabulary that bridges the domain expert's mental model and the data model in code. When the data model's names match the domain's names, the code becomes legible to non-programmers.

DDD is relevant because it addresses a gap in Rule 5's original formulation: **how do you discover the right data model?** Pike assumes the programmer can see it. Evans recognizes that for complex business domains, the model must be co-developed with domain experts through iterative refinement. The data model isn't right on the first try — it converges through conversation and feedback. This connects directly to the convergence discussion below: Stage 2 (informal convergence) is essentially what DDD does within a single team.

### Data-Oriented Design: Rule 5 at the Hardware Level

Mike Acton's CppCon 2014 talk "Data-Oriented Design and C++" applies Rule 5 at the hardware level. His formulation: "The transformation of data is the only purpose of any program" and "Lie #3: Code is more important than data" (Acton, CellPerformance blog, 2008).

Data-Oriented Design (DOD), prevalent in game development and high-performance systems, goes further than Rule 5 by arguing that **data layout** — how data is arranged in memory — matters as much as data structure choice. The key distinction: **struct-of-arrays (SoA) vs. array-of-structs (AoS)**.

```python
# Array of Structs (AoS) — OOP default
particles = [
    {"x": 1.0, "y": 2.0, "vx": 0.1, "vy": 0.2, "color": "red", "name": "p1"},
    {"x": 3.0, "y": 4.0, "vx": 0.3, "vy": 0.4, "color": "blue", "name": "p2"},
    # ... 10,000 more
]

# Updating positions touches x, y, vx, vy but also loads color and name
# into cache lines — wasting memory bandwidth on irrelevant fields.

# Struct of Arrays (SoA) — data-oriented
x  = [1.0, 3.0, ...]    # contiguous in memory
y  = [2.0, 4.0, ...]
vx = [0.1, 0.3, ...]
vy = [0.2, 0.4, ...]

# Updating positions touches ONLY the relevant arrays.
# CPU cache lines are fully utilized. 2-10x faster on hot loops.
```

DOD demonstrates that Rule 5 operates at multiple levels: the logical level (what entities and relationships exist), the representational level (what structures encode them), and the physical level (how those structures map to hardware). The article's examples address the first two; DOD adds the third.

This matters beyond game engines. Database storage formats (row-oriented vs. columnar), SIMD vectorization, and GPU compute all depend on data layout decisions that make the difference between "fast enough" and "unusable." Apache Arrow and Parquet are column-oriented data formats that exist precisely because SoA layout enables faster analytical queries — the same DOD principle applied to data infrastructure.

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

There are two distinct but related threads here, often conflated.

**Thread 1: Kay's 2003 email on OOP origins.** In a [2003 email to Stefan Ram](https://userpage.fu-berlin.de/~ram/pub/pub_jf47ht81Ht/doc_kay_oop_de), Kay wrote: "I wanted to get rid of data. The B5000 almost did this via its almost unbelievable HW architecture. I realized that the cell/whole-computer metaphor would get rid of data." In context, Kay meant eliminating the 1960s practice of tightly coupling business logic to manual pointer-walking through custom data structures. His solution: objects that communicate only via messages, so code doesn't depend on another object's internal data layout. This is a modularity argument, not an anti-data argument.

**Thread 2: The 2016 HN exchange.** In a [2016 HN AMA](https://news.ycombinator.com/item?id=11945722), Kay asked provocatively: "What if 'data' is a really bad idea?" Hickey responded, and the two talked past each other — largely because they used "data" to mean different things (as Eric Normand [analyzed in detail](https://ericnormand.me/podcast/what-if-data-is-a-really-bad-idea)):

- **Kay** used "data" in the programmer's sense: bytes, signals, structures without built-in interpretation. His concern was about **scaling communication between unknown systems**. His key line: "For important negotiations we don't send telegrams, we send ambassadors." He was asking: what comes after TCP/IP's data layer? How do systems that have never met negotiate meaning? His answer: you need something richer than raw data — computation bundled with data, "ambassadors" that can interpret and negotiate.

- **Hickey** used "data" in the epistemological sense: recorded facts, observations, measurements — the dictionary definition going back to pre-writing record-keeping. His position: data (facts given) is the most fundamental concept in computing. Even ambassadors exchange data. "Data is as bad an idea as numbers, facts, and record-keeping. Science couldn't have happened if consuming and reasoning about data had the risk of interacting with an ambassador."

They weren't really disagreeing about engineering practice. They were asking different questions at different scales:

| | Hickey's question | Kay's question |
|---|---|---|
| Scope | Within and between known systems | Between unknown systems at massive scale |
| "Data" means | Recorded facts with sufficient metadata | Raw signal requiring interpretation |
| Position | Data is the foundation; interpretation is secondary | Data alone is insufficient; systems need bundled interpreters |
| Practical analogy | A seismometer recording numbers that a separate process interprets as an earthquake | Two civilizations that have never met trying to exchange knowledge |

In his 2012 keynote *The Value of Values* (JaxConf), Hickey argues that most of what we call "objects" should just be immutable values — maps, vectors, sets — because values can be printed, compared, serialized, and reasoned about. This aligns with Rule 5's emphasis on explicit, inspectable data structures.

**How this connects to Rule 5 and "many domains":** Rule 5 assumes a shared context — a team, a codebase, a domain where everyone knows what the data means. Hickey's "just use data" works in this scope. Kay's concern becomes relevant precisely when that shared context breaks down: across service boundaries, across organizations, across domains. When you can't assume the receiver knows what your `{:status "active", :amount 500}` means, raw data isn't enough — you need schemas, contracts, versioning, or Kay's hypothetical ambassadors. This is why the industry converged on self-describing formats (JSON with schemas, Protobuf with `.proto` files, Avro with schema registries) at system boundaries — they're partial answers to the problem Kay identified.

The "many domains" observation from the convergence analysis below is one instance of Kay's broader concern: when domains are many, meaning can't be inferred from structure alone. Within a mature domain, data models converge because meaning is shared (Hickey is right). Across domains or at domain boundaries, meaning diverges and must be made explicit (Kay's point applies).

---

## The Ecosystem Problem: Lisp Curse and Clojure

Rule 5 is advice for individual projects: get the data right, and the code follows. But what happens when you zoom out from one codebase to an entire language ecosystem? The history of Lisp and Clojure reveals a tension between individual design freedom and collective convergence.

### The Lisp Curse

Rudolf Winestock's essay *The Lisp Curse* (c. 2011) makes a specific argument: Lisp is so expressive that any individual programmer can build their own solution to any problem. The result is that Lisp communities **never converge**. Instead of one good HTTP library, you get twelve half-finished ones. Instead of one web framework, you get none — because everyone rolls their own and it's "good enough" for their case.

The key insight: "Lisp is so powerful that problems which are technical issues in other programming languages are social issues in Lisp" (Winestock). Or as Mark Tarver (quoted by Winestock) observed of Lisp GUI libraries in the 1990s: "No problem, there were 9 different offerings. The trouble was that none of the 9 were properly documented and none were bug free. Basically each person had implemented his own solution and it worked for him so that was fine."

Winestock's essay is specifically about code and library fragmentation — the social dynamics that prevent Lisp communities from building shared infrastructure. **By analogy** (this is my extension, not Winestock's), the same dynamic *could* apply to data representations: where Perlis's epigram envisions "100 functions on 1 data structure," an ecosystem cursed by individual expressiveness produces something closer to 100 incompatible representations of the same domain, each with its own bespoke functions. The fragmentation happens not because anyone chose a bad data model, but because nobody coordinated on a shared one.

**Caveat on this analogy:** it's somewhat strained. Winestock's argument is about *libraries and infrastructure* — the functions and abstractions people build. Different libraries can still operate on the same underlying data structures (that's exactly Perlis's point about 100 functions on one structure). Library fragmentation does not automatically imply data representation fragmentation. The analogy holds best when each library invents its own domain model (e.g., nine Lisp GUI toolkits with nine different event models), but it doesn't hold when libraries fragment while sharing data formats.

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

## Where Rule 5 Breaks Down

Rule 5 is powerful advice, but it has domain boundaries. Treating it as universal leads to its own failure mode: **data-first cargo cult** — reaching for lookup tables and state machines where a direct algorithm or a simple function would be clearer and faster.

### Algorithm-Dominant Domains

Some problems are genuinely algorithm-first. The breakthrough is in the *method*, not the *representation*:

- **Numerical methods.** The Fast Fourier Transform (Cooley–Tukey, 1965) is a breakthrough in algorithm, not data structure. The input and output are the same arrays; the insight is *how* to decompose the computation. Same for conjugate gradient descent, interior-point methods, and Newton's method — the data is just vectors and matrices, the algorithm is everything.
- **Graph algorithms.** Dijkstra's shortest path, A* search, max-flow/min-cut — the adjacency list vs. adjacency matrix choice matters, but the *algorithmic insight* (priority queues, heuristic functions, augmenting paths) is where the real thinking happens. Switching from an adjacency matrix to an adjacency list doesn't make Dijkstra "self-evident."
- **Compression and encoding.** Huffman coding, LZ77, arithmetic coding — these are fundamentally algorithmic inventions. The data (a stream of bytes) is given; the compression ratio depends entirely on the algorithm's cleverness.
- **Cryptography.** AES, RSA, elliptic curve operations — the data is just bytes; the security properties emerge from mathematical operations, not from restructuring the input.

In these domains, the right response to "I'm writing complex logic" is not "your data structure is wrong" — it's "this domain is inherently algorithmic." Rule 5 is advice for *business logic and system design*, not for *computational mathematics*.

### When Data Tables Become Code in Disguise

The permission example earlier in this document illustrates this directly: the data-dominant refactoring looked clean, but the domain's cross-cutting rules — scope varying by (role, action), roles restricting each other — meant the decomposition silently changed behavior. Many real business rules don't decompose cleanly:

> "Editors can edit cross-department documents only during the first 48 hours after creation, unless the department head approved an extension, except for compliance-flagged documents which require VP-level approval regardless."

You can encode this in a data table — but the "condition" column becomes a complex lambda that references multiple entities, time calculations, and exception chains. At that point, the data table is just code wearing a data costume: you've moved the complexity into the lambdas without actually making it more inspectable or testable. The table gives a false sense of organization while the real logic hides in the condition functions.

The honest test: **can a non-programmer read your data table and understand the policy?** If yes, data dominates. If the table requires reading code to understand, you've achieved indirection, not clarity.

### Premature Data Modeling

Over-investing in the "right" data model before understanding the domain can be as wasteful as premature optimization. This is DDD's core caution: the data model should be *iteratively refined* through conversation with domain experts, not designed top-down and set in stone.

A common failure mode: spending weeks designing an elaborate schema, then discovering that the domain experts think about the problem differently. The schema gets defended because of sunk cost, and the code compensates for the mismatch — exactly what Rule 5 warns against, but caused by premature commitment to a data model rather than by ignoring data altogether.

The mitigation: start with the simplest representation that could work, write code against it, and refactor the data model as understanding grows. Rule 5 is iterative, not waterfall.

### The "Worse is Better" Tension

Richard Gabriel's 1989 essay *Worse is Better* (also called "The Rise of New Jersey Style") argues that simpler, less correct designs beat more principled ones in adoption and survival. The Unix approach — get 90% right with a simple implementation — outcompetes the MIT/Stanford approach of getting the abstraction perfectly right before shipping.

Rule 5 has an implicit MIT/Stanford flavor: get the data model *right*, and everything follows. But in practice, a mediocre data model that ships and gets iterated beats a perfect one that's still on the whiteboard. The tension isn't that Rule 5 is wrong — it's that *the search for the right data model has diminishing returns*, and shipping with a good-enough model plus willingness to refactor is often the winning strategy.

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

**Normalization theory** is the strongest evidence that data structure correctness is formalizable, not just intuitive. Codd's normal forms (1NF through BCNF, with 4NF and 5NF addressing multi-valued and join dependencies) are mathematical rules for when a relational data model is *correct* — meaning no update anomalies, no redundancy, all dependencies declared. A table in 3NF guarantees that every non-key attribute depends on "the key, the whole key, and nothing but the key" (Bill Kent's mnemonic). This is Rule 5 given a proof system: there are formal criteria for "right data structure" in the relational domain, and violating them produces exactly the maintenance pain Rule 5 predicts.

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
3. **Conway's Law.** "Organizations which design systems are constrained to produce designs which are copies of the communication structures of those organizations" (Melvin Conway, 1968). Two companies in the same industry with different org structures will produce different schemas for the same domain.
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

AI is competent at the *code* half of Rule 5 — writing simple operations on well-designed structures. It is weak at the *design* half — choosing the right structures in the first place. The question is *why*, and whether the gap is fixable.

### Why: Five Layers of Failure

AI's weakness at data-dominant design isn't a single problem. It decomposes into five layers with different causes and different fixability profiles.

**Layer 1: Training distribution bias.** Most code on GitHub is mediocre and procedural. AI learns the statistical mean. As `bfivyvysj` put it: "it is fighting against the literal mean." The if/elif permission checker appears in thousands of repositories; the data-dominant version appears in dozens. AI reproduces the frequency distribution of its training data.

**Layer 2: Task framing bias.** Users ask "write a function that checks permissions" — not "design the data model for a permission system." The prompt frames the problem as code generation, so AI generates code. The interface itself biases toward implementation over design. This is partly a user habit and partly a tool design issue: code editors, chat interfaces, and agent frameworks are all oriented around producing code, not around producing data models that make code unnecessary.

**Layer 3: Optimization target mismatch.** AI coding models are evaluated on **correctness** — tests pass, code runs, output matches. Data-dominant design optimizes for **maintainability, extensibility, and clarity** — qualities with no automated signal. The if/elif permission checker *passes every test you'd write*. It's functionally identical to the data-dominant version. The difference only shows up months later when you add a new role, a new action, a new exception. Current evaluation benchmarks reward the wrong thing: they can measure whether code works but not whether the design is right.

**Layer 4: The negative insight problem.** Data-dominant design is fundamentally about **restraint** — recognizing "this complexity shouldn't be code at all, it should be data." It's a *negative* insight: stop generating, step back, restructure. AI is trained to *produce tokens*. The entire reinforcement loop rewards generating output, not pausing to reconsider the problem framing. This is analogous to how AI struggles with "the answer is: we need more information" or "the right move is to do nothing." Knowing when to stop writing code and start restructuring data requires a meta-cognitive move that current training objectives don't reward.

**Layer 5: Problem modeling vs. solution generation.** This is the deepest layer. **Data design is about modeling the problem. Code generation is about implementing a solution.** These are fundamentally different cognitive acts.

The step-by-step method from earlier in this document reveals why:
- **Name the entities** — requires understanding the *domain*, not the code
- **Name the relationships** — requires knowing what changes, what's stable, who the stakeholders are
- **Pick representations that make relationships queryable** — requires anticipating *future* access patterns

None of this information is in the code. It's in the problem space. And the problem space includes things AI cannot observe from its training data:
- **Organizational structure** — Conway's Law means the "right" schema depends on team boundaries
- **Change vectors** — which requirements will shift next quarter
- **Stakeholder mental models** — DDD's "ubiquitous language" comes from conversations with domain experts, not from code
- **Questions that haven't been asked yet** — the whole point of Rule 5 is that good data structures make *unforeseen* queries easy

AI can pattern-match "e-commerce systems usually have Product → Cart → Order → Payment" because that pattern is heavily represented in training data. But it can't tell you whether *your* business should model subscriptions as a separate entity or as a recurring order — that depends on your business strategy, your org structure, your existing integrations. This is domain judgment that requires understanding the problem, not recognizing patterns in solutions.

### The Cost Equation Shifts — Asymmetrically

The bull case for AI: if code is cheap to rewrite, who cares if the data structures are initially wrong? Just regenerate everything.

This is half right. AI makes **code** cheap to change. It does not make **data** cheap to change. Data structures are architectural:

- **Database schemas** have migrations, foreign keys, and millions of rows that need to move.
- **API contracts** have external consumers who will break.
- **Event formats** in distributed systems have downstream subscribers.
- **State shapes** in frontends determine component hierarchies.

You can regenerate all the code in an afternoon. You cannot regenerate a production database schema with three years of data in it. **The AI era makes Rule 5 more important, not less** — the part AI does well (code) is now cheap, and the part it does poorly (data design) is still expensive to get wrong.

**Schema evolution is the hard problem.** If data dominates, what happens when the data model was wrong? The industry has developed partial answers: database migration frameworks (Flyway, Alembic), Protobuf's backward/forward compatibility rules (field numbering, `optional` by default), Avro's schema registries with compatibility checks, and API versioning strategies. These exist precisely because data structures are load-bearing — you can't just swap them out the way you swap out a function body. AI can help generate migration scripts, but the *decision* to restructure — and the judgment about what the new model should be — remains a design problem that requires domain understanding.

**The `nostrademons` counterargument** (from the [HN thread](https://news.ycombinator.com/item?id=47425935)): "The rule may not hold with AI driven development. The rule exists because it's expensive to rewrite code that depends on a given data structure arrangement... If writing code becomes free, the AI will just rewrite the whole program to fit the new requirements." This user reports exactly this behavior on small (~1,000-line) programs. The counterargument has real force for throwaway scripts, prototypes, and applications without persistent data. It weakens once you have a production database, external API consumers, or event subscribers — because those are data contracts that can't be rewritten unilaterally.

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

This is the scenario where Rule 5 matters most and gets practiced least.

**The "good enough to be dangerous" variant.** The compounding debt paradox becomes worse as AI *improves* at data design. If AI were 0% competent at data design, every developer would have to do it themselves — the skill would be preserved. If AI is 80% competent, it handles the permission systems and state machines correctly (because those are well-represented patterns in training data), and developers stop practicing. The remaining 20% — the novel domain models, the weird one-off business rules, the cross-system data contracts — are precisely the cases where getting the data model wrong is most expensive. AI handles the easy cases well enough that humans lose the skill needed for the hard cases. Partial competence is more corrosive to human expertise than total incompetence.

The mitigation is to keep data design as a human-owned responsibility, even as code generation is delegated to AI. Use AI to *explore* schema variations and *simulate* their downstream implications, but keep the *judgment* about which model fits the domain on the human side.

### Intrinsic vs. Transient

Are these failures things AI will outgrow, or hard limits? The five layers have different answers.

| Layer | Nature | Fixability | Timescale |
|---|---|---|---|
| 1. Training distribution bias | Transient | Better data curation, RLHF on design quality | 1–2 years |
| 2. Task framing bias | Transient | Prompt design, tool UX changes | Already addressable (Level 1 prompting works) |
| 3. Optimization target mismatch | Transient | New benchmarks that reward design, not just correctness | 3–5 years (requires evaluation community shift) |
| 4. Negative insight / restraint | Mixed | Architectural advances + prompting partially address it; training objective tension remains | Uncertain |
| 5. Problem modeling / domain judgment | Mostly intrinsic | Richer context helps; residual remains | Hard ceiling, softened by better context |

**What "mostly intrinsic" means for Layer 5:** It does not mean AI will never improve at data design. It means the improvement curve flattens. AI with rich enough context — domain documentation, org charts, stakeholder interview transcripts, existing schemas, product roadmaps — can get substantially better at modeling problems. But data design requires tacit knowledge about domain boundaries and change vectors that experienced engineers build over years of watching systems evolve. That tacit knowledge resists formalization, which means it resists being encoded in a prompt or a training set. The gap narrows but doesn't close.

**A partial counterargument:** the "Premature Data Modeling" section earlier in this document argues that data design is iterative, not a single act of insight. If so, AI's ability to generate 20 schema variations and simulate queries against each one could compress the iteration cycle — making AI a powerful *exploration tool* for data design even if it can't do the final judgment. The failure mode isn't "AI can't help with data design" — it's "AI defaults to skipping it entirely unless explicitly directed." The intervention at Level 1 (prompting) addresses exactly this default.

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
| Need full history / audit / undo | Event sourcing (append-only event log) | Current state derived from data; history is free |

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
| **Datomic** (Hickey, 2012) | Entity-attribute-value triples, immutable and time-indexed | Database as a value. The data model makes time-travel queries and auditing trivial — no special code needed. An event-sourced database: current state is derived by replaying the immutable log of facts. |
| **Unix filesystem** (Thompson & Ritchie, 1969) | Inodes, directory entries, file descriptors | "Everything is a file" is a data abstraction. Once you have file descriptors and inodes, pipes, sockets, and devices are just the same operations on different data. |
| **Event-sourced systems** (general pattern) | Append-only log of domain events; current state derived by replaying the log | The event log *is* the system of record. All queries, projections, and materializations are derived views. The state machine example in this document encodes transitions as data; event sourcing goes further — it makes the *entire history* a data structure. Often combined with CQRS (separate read/write models). Used in financial systems, audit-critical domains, and distributed architectures where the event log provides a single source of truth. |

---

## Related Quotes

- **Fred Brooks**, *The Mythical Man-Month* (1975, pp. 102–103): "Show me your flowcharts and conceal your tables, and I shall continue to be mystified. Show me your tables, and I won't usually need your flowcharts; they'll be obvious."
- **Linus Torvalds**, [git mailing list](https://lwn.net/Articles/193245/) (2006): "I will, in fact, claim that the difference between a bad programmer and a good one is whether he considers his code or his data structures more important. Bad programmers worry about the code. Good programmers worry about data structures and their relationships."
- **Alan Perlis**, *Epigrams on Programming*, SIGPLAN Notices 17(9) (1982): "It is better to have 100 functions operate on one data structure than 10 functions on 10 data structures."
- **Rich Hickey**, *The Value of Values*, JaxConf keynote (2012): Values — immutable data — can be printed, compared, serialized, and shared. Objects can't.
- **Alan Kay**, [email to Stefan Ram](https://userpage.fu-berlin.de/~ram/pub/pub_jf47ht81Ht/doc_kay_oop_de) (2003): "I wanted to get rid of data." Context: eliminating tight coupling between business logic and manual data-structure traversal in 1960s programming; the cell/computer metaphor replaces it with message-passing.
- **Alan Kay**, [HN AMA](https://news.ycombinator.com/item?id=11945722) (2016): "For important negotiations we don't send telegrams, we send ambassadors." Context: systems at massive scale need something richer than raw data — bundled computation that can negotiate meaning with unknown counterparts.
- **Rich Hickey**, [HN response to Kay](https://news.ycombinator.com/item?id=11945722) (2016): "Data is as bad an idea as numbers, facts, and record-keeping. Science couldn't have happened if consuming and reasoning about data had the risk of interacting with an ambassador."
- **Eric S. Raymond**, *The Art of Unix Programming* (2003), Rule of Representation: "Fold knowledge into data so program logic can be stupid and robust."
- **Mike Acton**, CppCon 2014 / CellPerformance blog (2008): "The transformation of data is the only purpose of any program." And: "Lie #3: Code is more important than data."
- **Rudolf Winestock**, [*The Lisp Curse*](http://www.winestockwebdesign.com/Essays/Lisp_Curse.html) (c. 2011): "Lisp is so powerful that problems which are technical issues in other programming languages are social issues in Lisp."
- **Melvin Conway**, ["How Do Committees Invent?"](http://www.melconway.com/research/committees.html), *Datamation* 14(4) (1968): "Organizations which design systems are constrained to produce designs which are copies of the communication structures of those organizations."
- **Eric Normand**, [*What if data is a really bad idea?*](https://ericnormand.me/podcast/what-if-data-is-a-really-bad-idea) (2021): The most thorough analysis of the Kay-Hickey exchange. Concludes they used "data" to mean different things and were asking questions at different scales.

---

Get the data right, and the code becomes obvious. Get it wrong, and no amount of cleverness saves you.
