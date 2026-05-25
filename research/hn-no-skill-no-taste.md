← [Index](../README.md)

## HN Thread Distillation: "No Skill. No Taste"

**Source:** https://news.ycombinator.com/item?id=47089907 · 130 points · 132 comments · 2026-02-20

**Article summary:** A developer with 20 years of experience argues that LLMs have created an illusion of lower barriers to entry in software. The real barrier was always *taste*—knowing what resonates with people—and LLMs do nothing to remove it. Show HN is drowning in derivative, poorly-crafted vibe-coded apps because their creators overestimate both their skill and their taste. Uses a "magic quadrant" of skill × taste to argue that crossing the quality threshold for saturated categories requires exceptional taste, which most newcomers lack.

### Dominant Sentiment: Defensive backlash against gatekeeping

The thread is largely hostile to the article's thesis. Most commenters read it as elitist gatekeeping dressed up in aesthetic language, and rallied around the right to build whatever you want. The author (ianbutler) spent significant effort in the comments trying to narrow his claim—"I'm not against building for yourself, just against spamming others without considering them"—but the thread had already decided what it thought.

### Key Insights

**1. The "taste is subjective" vs. "taste is intersubjective" split is the real philosophical divide**

The sharpest exchange was throw4847285 invoking Kant: *"A judgment of taste involves a claim to subjective universality... we usually resort to 'that's just your opinion man' when we give up and disengage. But we don't believe that, not really."* This was countered by selridge arguing taste is fundamentally a class construct—a *"stalking horse for money and distinction."* These two camps talked past each other the entire thread. The Kantian camp thinks taste is real but hard to define; the materialist camp thinks "taste" is just social hierarchy wearing a turtleneck.

**2. tptacek crystallized the anti-gatekeeping position in one line**

*"Where by 'spamming' you mean daring to post it to HN under a 'Show HN' title."* This reframe landed hard. The author's distinction between "building for yourself" (fine) and "posting to Show HN without considering others" (not fine) struck many as arbitrary policing of a community space that already has a voting mechanism. brador made the same point dryly: *"If only we had some kind of voting system that could uplift the good stuff..."*

**3. The "taste can't be defined therefore it's useless" challenge went unanswered**

altmanaltman pushed hardest: *"If someone claims good taste is the differentiator for good and bad in software, they should have some basic objective ways to measure it, right? If it's just vibes... then everyone's app is good."* Multiple people tried (James_K: "taste is the ability to differentiate good from bad objectives"; markbao: "an intuition for what people like") but nobody produced anything concrete enough to be actionable. The author himself admitted: *"I'd argue it's not definable globally, but within whatever niches you're a part of it probably is."* Which is essentially conceding the weakness.

**4. barrkel's data argument was the thread's most technically substantive comment**

Completely orthogonal to the taste debate, barrkel argued the *real* hard thing about software is data, not code: *"Vibe coding creates the illusion that code has become far more malleable. And it has, for greenfield... But most applications of significance work with a lot of data. Data resists the malleability you have with code."* This was the one comment that moved beyond aesthetics into engineering substance. Underappreciated in the thread.

The argument deserves unpacking because it identifies a constraint that most vibe-coding discourse completely ignores:

**Code is newly malleable; data is not.** LLMs make it trivially easy to generate, refactor, or rewrite code—especially greenfield code with no state. A game, a utility, a static site generator: these are essentially stateless or ephemeral. You can throw the code away and regenerate it. This is where vibe coding shines and where the "anyone can build an app" narrative lives. But most software that matters is a *data custodian*. A todo app is trivial; a todo app with 50,000 users who've been using it for two years has migration constraints, backward compatibility requirements, and data integrity obligations. The code is the easy part. The schema is the hard part.

barrkel identified several specific constraint layers:

- **Data at rest resists refactoring.** You can't regenerate a database schema the way you regenerate a React component. Migrations are sequential, order-dependent, and often irreversible. A vibe-coded "let me restructure this" that drops a column or merges fields can destroy information that can't be recovered.
- **Distributed data creates invisible constraints.** When data lives across multiple systems—replicas, caches, third-party integrations, edge nodes—you can't just push a change and see what happens. You need patterns like dual-writing (writing to old and new systems simultaneously), fallback reads (reading from new system, falling back to old), and gradual migration. These are coordination problems that require understanding the *topology* of your data, not just the code that touches it.
- **Privacy-gated data adds another dimension.** GDPR, HIPAA, data residency requirements—these create constraints that aren't visible in the codebase. An AI that can see your code can't see your compliance obligations. It can't know that a particular field can't be logged, or that data from EU users can't be replicated to US servers, unless someone with domain knowledge encodes those constraints.
- **AI thrives on fast feedback loops; data problems have slow, catastrophic feedback.** Test-first development works great with AI because you get immediate signal. But data corruption often has delayed symptoms. You might not discover you've been silently truncating a field or losing precision for weeks. By then the damage is baked into your backups.
- **The sovereignty problem is the deepest one.** Even if AI gets good enough to handle all the above reliably, there's an irreducible problem: who decides? If you tell the AI to merge two fields into one, the AI might warn you it's destructive, but it can't *override* your bad judgment without removing your agency. And if we build systems where AI *can* override human decisions about data—refuse to execute a destructive migration, for instance—we've created something with its own authority over your data. As barrkel put it: *"That would be a very dangerous place to go; I would hope, and expect, that we don't go there."*

**Why this matters for the taste debate:** The article and most of the thread were arguing about the *front-end* of the problem—UI, UX, whether your app looks good, whether anyone needs another todo app. barrkel was pointing at the *back-end* problem, which is far harder and completely unaddressed by the "taste + AI = success" formula. You can have impeccable taste and still destroy your users' data because you don't understand migration patterns. Taste gets you users; engineering competence keeps their data safe. The vibe-coding narrative elides this entirely because the apps being discussed are almost always greenfield toys with no persistent state and no users.

**The implied conclusion:** The gap between "I built an app" and "I run a service people depend on" is *enormous*, and it's mostly made of data problems that AI currently can't see, can't reason about holistically, and can't safely automate. This is where skill—real, non-vibeable skill—remains non-negotiable. The article's magic quadrant of skill × taste is missing a third axis: *stewardship*.

**5. roywiggins identified a genuine cognitive hazard: the slot machine effect**

*"Spending too much time with generative AI makes your taste worse, by habituating you to stuff that's pretty bad... you get used to losing and when something goes slightly well you wildly overestimate how good it is."* Named Darren Aronofsky's AI slop as a concrete example of a formerly tasteful creator whose standards degraded through overexposure. Also flagged Claudese READMEs reaching the HN front page with nobody noticing—evidence of collective habituation.

**6. The "build for yourself" crowd won the vibes war but missed the author's actual point**

lubesGordi's top comment ("I'm writing a flashcard app and I like it") and amarant's pushback ("stop shitting on people for making things") were the emotional poles. The author kept clarifying he wasn't against personal projects—just against posting derivative slop publicly without considering the audience. But the thread consistently interpreted the article as "you shouldn't build things," and the clarifications never caught up with the initial read.

**7. PaulHoule's meta-observation about AI discourse itself was sharp**

*"A report on AI coding is usually like a report on what happened when you spent an evening playing the slots—it's not at all reproducible... I go to the /new page quite often and find there are 22 articles about AI (probably 20 are noise)."* pu_pe made the same irony explicit: *"Ironic that you complain about people posting a to-do app because it's so common, and proceed to post the 100th AI rant of the day with absolutely no original thought in it."*

**8. The accessibility angle was a genuine bright spot**

devinprater, a blind developer, described vibe-coding an Emacs accessibility package on his phone: *"Because it's all controlled by me, I can tell it how to have the package speak... I'm not stuck with whatever some sighted person at some big company thinks a blind person wants."* This was the strongest concrete counterexample to the article's thesis—someone using AI to solve a problem that the market systematically ignores.

**9. tristor correctly identified that the thread was reinventing product management**

*"This blog post is on point, but it's somewhat interesting to see developers realizing that taste matters. That's fundamentally the idea behind product management as a role... There's a whole lot of people wrestling with something that is the core purpose of an entire career that is often derided as being useless."* The irony: developers discovering that understanding users matters, which is literally what PMs have been saying (and been mocked for) for decades.

### What the Thread Misses

- **No one discussed curation vs. creation.** The actual problem isn't that bad apps exist—it's that discovery and curation mechanisms (Show HN, App Store, etc.) are breaking down under volume. That's a platform design problem, not a taste problem.
- **The economics of attention scarcity went unexplored.** When creation cost drops to near-zero but attention remains fixed, you get a classic tragedy of the commons. Nobody framed it this way.
- **Zero discussion of whether AI itself could develop or apply taste.** Could an LLM trained on successful products help filter or improve outputs before they're published? The thread treated AI as purely an amplifier, never as a potential curator.
- **The "crypto stink" analogy in the article deserved more scrutiny.** The parallel is actually quite strong—both involve dramatically lowered barriers to *creation* without lowered barriers to *value*—but nobody developed it.

### Verdict

The article makes a defensible point wrapped in an off-putting tone, and the thread correctly identified the tone problem while mostly failing to engage with the substance. The real insight isn't about taste—it's that LLMs have decoupled creation from curation, and communities built around human-filtered quality (like HN) are experiencing the same content flood that hit every other platform before them. "Taste" is just a vibes-word for the filtering function that used to be performed by technical barriers to entry. The thread's most valuable contributions came from the edges: barrkel on data as the real constraint, roywiggins on AI-induced standards degradation, and devinprater on accessibility as the strongest pro-AI argument. The center of the thread was a predictable culture-war skirmish between builders who felt attacked and an author who couldn't land his nuance.
