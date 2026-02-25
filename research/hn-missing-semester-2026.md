← [Index](../README.md)

## HN Thread Distillation: "The Missing Semester of Your CS Education – Revised for 2026"

**Source:** [HN thread](https://news.ycombinator.com/item?id=47124171) · 420 points · 120 comments · 91 unique authors
**Date:** 2026-02-22

**Article summary:** MIT's Missing Semester course (first launched 2020) returns with a 2026 revision — 9 lectures on practical developer tooling (shell, git, debugging, packaging, code quality). The big change: five new lectures, including one entirely on agentic coding. AI is also woven throughout other lectures rather than siloed. The instructors explicitly ask HN for feedback on the AI inclusion.

### Dominant Sentiment: Warm nostalgia meets AI anxiety

The thread is overwhelmingly positive about the course's existence — many cite it as one of the most useful things they encountered in CS education. But the AI content splits the room in a way that reveals more about the commenters than the course.

### Key Insights

**1. The git debate exposes that version control's real problem is conceptual, not mechanical**

The largest sub-thread (40+ comments) argues about whether git is badly designed or users are lazy. Both sides miss the insight that **1718627440** nails in one sentence: *"The hardest thing to get people to, is to think of an evolution of their codebase as opposed to just a single state with a sophisticated backup system."* The bandsaw metaphor gets flogged by five different commenters, but the actual diagnostic is that people lack the *mental model*, not the CLI skills. **xml** starts the usability critique ("If most people are not using a tool properly, it is not their fault; it is the tool's fault"), and **shagie** demolishes it with historical evidence: the same problem existed in svn, perforce, cvs, and rcs. The tool changed four times; the behavior didn't. That's a people problem wearing a tooling mask.

**2. The PR-as-unit-of-work reframe is the most operationally useful comment in the thread**

**sh34r** cuts through the git idealism with a pragmatic observation that in most professional settings, *the PR is the unit of work, not the commit*. PRs trigger CI/CD, map to tickets, and get squash-merged. Feature-branch commit history is personal scratch space. This directly challenges Hendrikto's original "your commit history should tell a story" absolutism — and sh34r acknowledges both positions have merit while noting that *"excessive rigidity is not an endearing quality."* The thread's git idealists never engage with this, which tells you something about the gap between open-source workflow norms (where commits *are* the contribution unit) and enterprise reality.

**3. The "is CS dead" voices self-refute in real time**

**mono442** asks "Is there even a point learning CS now with the rapid progress of agentic coding?" and gets the thread's star comment from **zjp**: agents tried to implement Flying Edges (a parallel isosurface algorithm) and just produced marching cubes superficially shaped like Flying Edges. *"You are still necessary to push the frontier forward."* **ModernMech** adds the sharpest one-liner: *"Computer science and coding are as related as physics and writing."* **operation_moose** provides ground truth from automation work with poorly-documented APIs: agents are "completely, 100% useless" when the task requires domain knowledge that isn't in the training set. The nihilist position collapses under first-contact reports from people doing actual novel work.

**4. The agentic coding lecture is better than the thread gives it credit for**

Having read the actual lecture content, it's notably careful: explains how LLMs work mechanically, warns about rabbit holes and gaslighting, emphasizes that "verifying code can be harder than writing it," and covers privacy implications of cloud-hosted tools. The "manager of an intern" mental model is apt. But almost nobody in the thread engages with *what the lecture actually teaches*. **cratermoon** says "Delete the AI bullshit" without having read it. **qsort** wants more AI content. **bigstrat2003** says AI "isn't yet to the point where it's actually a useful tool." The polarization is about identity and priors, not pedagogy.

**5. The code quality critique identifies the course's actual weak spot**

**dvfjsdhgfv** makes the thread's most substantive criticism: the code quality lecture covers formatters, linters, testing, CI/CD, and regex but omits complexity, maintainability, and modularity — the structural qualities that actually determine whether software survives. **ontouchstart** amplifies: *"The trend in the industry is putting emphasis on cosmetic qualities (format, workflow, testing)... A low quality software can have beautiful code just like a low quality book has beautiful fonts."* This is a real gap. The lecture teaches tooling for code *hygiene* but not code *design* — which is exactly the kind of "missing" knowledge the course claims to address.

**6. The "missing semester" gap persists across decades and geographies — but the UK claims otherwise**

Multiple commenters confirm the gap from personal experience spanning 20+ years. **whateveracct** (Purdue), **ontouchstart** (NYU, 1990s), **ILoveHorses**, **ghc** — all validate that practical tooling education is rare. **Stevvo** pushes back: *"In the UK, you would learn version control in the first week."* **zerkten** (UK grad, early 2000s) contradicts this, noting academics recognized the need but *"weren't permitted to teach it due to time available and the view that it wasn't academic."* The gap isn't about knowledge — it's about institutional incentives that reward theory over practice.

**7. The thread's anti-AI absolutists and pro-AI nihilists share the same error**

**cratermoon** ("delete the AI bullshit"), **bigstrat2003** ("remove the AI stuff entirely"), and **blks** ("omit agentic coding altogether") occupy one pole. **mono442** ("Is there even a point learning CS"), **DGAP** ("irrelevant in the age of AI"), and **nautilus12** ("does any of this matter anymore") occupy the other. Both treat AI capability as binary and static. Neither engages with the course's actual position, which is that AI is a *tool with known limitations that evolves rapidly*. The course's approach — integrate AI throughout, teach the mechanics, emphasize verification — is the only position that survives contact with the present reality where agents can refactor code but can't implement novel algorithms.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Git's UX is the real problem, not users | Medium | Historical evidence (same behavior across svn/cvs/perforce) undermines this |
| AI content shouldn't be in a tools course | Weak | Commenters didn't read the lecture; it's about tool mechanics, not hype |
| CS is dead because of AI | Weak | Refuted by multiple first-person reports of AI failure on novel tasks |
| Course should cover ethics | Misapplied | MIT already has a dedicated ethics course (E4E); the instructors note this |
| Code quality lecture is too shallow | Strong | Legitimate gap: covers hygiene tools but not design principles |
| Testing deserves its own lecture | Strong | Multiple commenters note this; the agentic coding lecture even implies TDD matters |

### What the Thread Misses

- **The course's real innovation is structural, not topical.** Weaving AI *into* every lecture rather than siloing it into one "AI lecture" is a pedagogical choice that mirrors how AI tools actually get used. Nobody discusses this design decision, which is arguably more important than any individual lecture's content.
- **The "agentic coding" lecture teaches you how agents work mechanically** (context windows, tool-calling loops, the 200-line harness), which is the foundation for *evaluating* when to use them and when not to. This is closer to teaching someone how an engine works than teaching them to drive. The thread treats it as the latter.
- **Nobody asks the hard question about AI in education:** if students learn to code *with* agents from day one, do they develop the mental models needed to *verify* agent output? The course's "manager of an intern" framing implicitly requires that the manager already knows how to code. What happens when the manager never learned?
- **The course has no networking/systems lecture.** For a "missing semester" in 2026, understanding DNS, HTTP, TLS, and basic networking feels more foundational than regex.

### Verdict

The course is doing something harder than it appears: teaching practical tooling in a field where "practical" now includes tools that didn't exist 18 months ago and may not exist in 18 months. The thread's loudest voices want certainty — either "AI changes everything" or "AI is bullshit" — but the course's strength is that it refuses both positions. Its weak spot isn't the AI inclusion; it's that "code quality" stops at linting and formatting when the real missing knowledge is *software design*. The irony the thread circles but never names: the commenters most hostile to AI in education are often the same ones who'd benefit most from the course's "Beyond the Code" lecture on communication and collaboration — their absolutism is itself a soft-skills deficit.
