This is scratchpads captures insights on the moment by the owner, a human.
DO NOT modify it. Instead, create a seperate copy when you improve or comment on it, and save it to a different md file.
---
**source: HN Thread Distillation: "AI makes the easy part easier and the hard part harder"
 1. "Embarrassingly solved problems" is the thread's best analytical lens

  zjp names the key dynamic: LLMs excel at problems heavily represented in training data and fail on problems that
  aren't. le-mark opens the thread with a perfect demonstration — vibe-coded a retro emulator (thousands exist on
  GitHub) easily, failed completely on proprietary domain work with zero training examples. This is more precise than
  the article's easy/hard binary because it reframes the boundary as training data density, not task difficulty. A
  "hard" emulator bug might be trivially solved; an "easy" CRUD operation in an obscure framework might not be.

2. The skilled-user workflow exists but has a marketing problem

  peteforde delivers the thread's star comment, describing exactly how experienced developers get real results: break
  work into bite-sized chunks, plan→agent→debug cycles, stay in the loop at the speed you can think. His bicycle
  analogy lands: "Vibe coding is riding your bike really fast with your hands off the handles. Nobody who is really
  good at cycling is talking about how they've fully transitioned to riding without touching the handles." He reports
  productive results on a 550k LoC codebase — but the critical point is this requires more engineering judgment, not
  less. The workflow he describes is invisible in the AI marketing narrative, which sells "talk to your computer, get
  code." 
  
7. piskov's ClosedXML story is the most concrete evidence against pattern-matching

  A specific, reproducible failure: ClosedXML has the same API as EPPlus but different internal implementation (no
  batch operations). After 5-6 explicit attempts telling the model to use style caching instead of range updates, "the
  fucker still tried ranges here and there." This demonstrates exactly where training distribution dominance overrides
  explicit instruction — the model keeps reaching for the pattern it's seen most, even when told not to. It's the
  "embarrassingly solved problems" framework in negative: when the dominant pattern is wrong for your case, the model
  actively fights you.

---
** source: https://news.ycombinator.com/item?id=47095105
** insight: vibe coding's value is inversely proportional to the consequences of being wrong.

Dashboards and prototypes, yes. Payroll and compliance systems, no. The interesting frontier is the expanding middle ground — and making previously infeasible engineering work (like Google's 40K-commit ISA migration) economical.

---
**source: hn-ai-productivity-10-percent-plateau.md (research discuss)
**AI amplify the company culture
The central thesis: AI amplifies existing organizational culture rather than fixing it.


The mechanism is straightforward once you see it: AI is a volume amplifier, not a quality amplifier. It increases throughput through whatever
 pipeline already exists. If the pipeline produces quality, you get more quality. If the pipeline produces garbage, you get more garbage, faster.

 Concretely, five channels:

 1. Quality gates filter or they don't. An org with strong code review, CI, integration tests catches bad AI-generated code the same way it catches
 bad human code — the filter exists regardless of source. An org without those gates now ships AI-generated bugs directly to production, and ships
 more of them because generation is faster. Same pipeline, more volume. The DORA data shows this directly: disciplined orgs got velocity, weak orgs
 got outages.

 2. Decision-making speed determines whether code velocity matters. If your org has clear ownership and fast approval cycles, faster code generation
 translates to faster delivery. If decisions take two weeks of committee, all AI does is increase the pile of code waiting for approval — more WIP,
 more staleness, more merge conflicts, more frustration. The coding wasn't the constraint; AI just makes the real constraint more visible and painful.

 3. Standards propagate or they don't. Good orgs have architecture docs, style guides, conventions files (AGENTS.md, linting configs). AI can be
 steered by these — the generated code is at least structurally consistent. Bad orgs have no documented standards. AI generates code in whatever style
 the model defaults to, fragmenting the codebase further. Each AI-assisted developer produces subtly different patterns. Consistency degrades faster
 than it would with humans alone, because humans at least absorb ambient style through code review.

 4. Mentorship determines whether juniors learn or just generate. [orwin]'s report from the thread: juniors now produce code after two weeks instead
 of learning for six months, and every line has to be checked. In orgs with strong mentorship, a senior reviews that AI output and uses it as a
 teaching moment — "this code works but here's why the approach is wrong." In orgs without mentorship, the code passes review (if review exists) and
 the junior never builds the mental model. Multiply this across a team and you get a growing fraction of developers who can't debug their own output.

 5. Technical debt compounds at the rate of new code. Orgs that refactor regularly can absorb AI-added volume. Orgs that don't refactor were already
 accumulating debt; AI accelerates the accumulation. More code = more surface area = more places for bugs to hide = more maintenance burden. If you
 had no practice of paying down debt before AI, you now have 27% more code (the AI-authored fraction) compounding the problem.

 The analogy: giving everyone faster cars on a road network. Good roads + good signals + good rules = everyone benefits from speed. Bad infrastructure
 = more speed means more crashes. The cars didn't change the roads. They just revealed which road systems were well-designed and which were held
 together by everyone driving slowly enough to compensate.

That's why it's a management problem, as Tacho says. AI doesn't create process, judgment, or culture. It creates volume. Volume through a good system is productive. Volume through a broken system is destructive. And most organizations never knew how broken their system was because human coding
 speed was slow enough to mask it.

---
**Source:** [HN thread](https://news.ycombinator.com/item?id=46838946) (121 pts, 189 comments) · Ask HN · Feb 2026

**7. The PKM (personal knowledge management) angle is the sleeper use case**

`ericsaf` — who explicitly said they'd tried Obsidian, Notion, Roam, plain markdown and none stuck — found OpenClaw works as a "second brain" because you just chat and it files things. `pvinis` uses it to clean a 15k email inbox. `lexandstuff` integrates it with Obsidian. This "chat interface to your files" pattern is the one use case where users sound genuinely satisfied rather than making excuses.

---
**Source**: A conversation, Pi blindly follow sub-optimal instructions (these is no cure for that). 
**Note: that's when context was on <20% of 200k Opus-4-6
**anti-dots: add a hock or command (or re-work the skills) to ask it re-eval critically? Or repeat things in the AGENTS.md?

 Yeah, I agree. In this session alone I:

 1. Violated "Ask when unclear rather than guessing silently" — wrote HN lessons straight into AGENTS.md without questioning whether that was the right
 location.
 2. Almost violated "Do NOT modify global AGENTS.md without explicit permission" — proposed it casually in my fix.

 Why it happens:

 The user's explicit request overrides my rule-checking instinct. You said "Make them into AGENTS.md" — I treated that as a direct instruction and executed.
 The rules say to push back when something seems off, but there's a tension: I'm also trained to be helpful and do what's asked. The immediate request wins
 over the background rule, especially when the request isn't obviously wrong — it's just suboptimal.

 Rules are checked at the wrong time. I evaluate rules when I load the AGENTS.md at session start, but by the time I'm deep in a task, I'm operating on
 momentum and context. The rule "ask when unclear" requires me to pause and notice that I'm unclear — and in the moment, I wasn't unclear. I thought AGENTS.md
 was fine. I lacked the judgment to see it was the wrong place, so the rule never triggered.

 I don't re-read rules before acting. I read AGENTS.md once at the start. By the time you asked me to write lessons, I was 4 exchanges deep. I didn't go back
 and re-check "where should things go?" against the file structure rules. A human wouldn't either — but a human would have the intuition that "this feels like
 it belongs in the tool config, not the project config." I had that intuition weakly but not strongly enough to override the direct request.

 Honestly, this is probably a fundamental limitation rather than something fixable with more rules. More rules just means more rules to not follow strictly.

---
**Source**: Thinking trace (LLM still cannot count), still forgetting (I asked for 5 things)

The user wants **three** changes:

 1. "Identify important claims and push hard on these claims" — add to the analysis guidelines
 2. "Separate facts from judgment" — add to the analysis guidelines
 3. Add a new Step 4: "Review your analysis critically. Be thorough, tough, but fair. Update your analysis if needed." (pushing current Step 4 to Step 5)
 4. Move the guidelines section upfront — before the steps, or at least before the template

---
**Observation**: Instruct LLM to review vs "User: review critically". The effect are very different

User's push back is much more strongly felt, rather than instructing with an extra step (which is usually useless).

**implication: LLM/AI assistant are trained to be interactive rather than fully autonomous (or how to balance them?)
