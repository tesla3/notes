← [Index](../README.md)

## HN Thread Distillation: "Don't make me talk to your chatbot"

**Source:** [raymyers.org](https://raymyers.org/post/dont-make-me-talk-to-your-chatbot/) | [HN thread](https://news.ycombinator.com/item?id=47239943) (227 pts, 189 comments, 132 unique authors) | 2026-03-02

**Article summary:** Ray Myers argues that pasting AI-generated text into human conversations is bad communication — not because AI is inherently bad, but because it buries intention under verbosity. The fix: figure out what you want to say, then say it. If you must share AI output, add a short human preface ("bare minimum curation"). The article is moderate, pragmatic, and uses PR descriptions as its concrete example.

### Dominant Sentiment: Meta-ironic mass RTFA failure

The thread's defining feature isn't any argument about AI — it's that roughly 70% of commenters responded to the *title* ("chatbot" → customer support) without reading the article, which is about copy-pasting LLM output in human-to-human communication. Multiple commenters flagged this throughout the thread (appreciatorBus, dmd, ifokiedoke, davis, godelski, Juminuvi). This is the thread's central irony: an article about people not putting in the effort to communicate clearly spawned a thread where people didn't put in the effort to read.

### Key Insights

**1. The information-theoretic argument is the sharpest version of the thesis**

hatthew delivers the thread's cleanest formulation: *"If you have 1000 bits of information you want to transfer, you can't give 300 bits of information to an LLM and have it fill in the remaining 700, because it doesn't know what those 700 bits are."* If the LLM can guess the 700 bits correctly, they weren't information — just padding you're now forcing the reader to filter out. This is stronger than the article's argument because it makes the case unfalsifiable: either the AI adds noise (bad) or adds nothing (pointless). The related blog post [Just Send Me the Prompt](https://blog.gpkb.org/posts/just-send-me-the-prompt/) (cited by zahlman) makes the same point with delightful sarcasm — "I prefer the older terminology: writing."

**2. LLMs as "misunderstanding amplifiers" — the enterprise angle nobody else developed**

SaberTail introduces the most original framing in the thread: LLMs don't just produce slop, they *amplify ambiguity*. When someone uses jargon like "the platform" without specifying which platform, the LLM doesn't flag the ambiguity — it confidently invents a meaning from context, and that wrong meaning propagates through copy-paste. *"When this gets copy/pasted and sent around, it causes everyone who isn't familiar to get the wrong idea."* This is an under-explored failure mode. It's worse than verbose filler because it's *confidently wrong* in ways that are hard to detect without domain expertise.

**3. PR descriptions: the thread's one concrete battleground**

jfreds provides the most visceral evidence for the article's thesis: AI PR descriptions that *"leak details about the CoT that didn't make it into the final solution ('removed the SQLite implementation' — what SQLite implementation? There isn't one on main…)"* and are *"devoid of context about why the work is even being done."* guerython describes their team's countermeasure — shipping agent drafts with a labeled "agent draft" block below a two-sentence human anchor. This pattern matches exactly what the article proposes. The fact that teams are independently converging on this convention suggests it's solving a real, recurring pain point.

**4. The support chatbot tangent reveals something about AI's emotional footprint**

The off-topic majority is itself data. When people hear "chatbot," their *immediate* association is adversarial customer support — not colleagues copy-pasting from Claude. This suggests the dominant public relationship with AI is still coercive: you encounter it when a company is trying to prevent you from reaching a human. The article's actual concern (AI in peer communication) is a more subtle problem that most people haven't even noticed yet, which makes it more interesting and more dangerous.

**5. Doctorow's "nonconsensual slopping" is the aggressive twin**

ivarv linked Cory Doctorow's [same-day piece](https://pluralistic.net/2026/03/02/nonconsensual-slopping/#robowanking), which makes a harder version of the same argument: emailing someone unverified AI output is *"an attempt to coerce a stranger into unpaid labor on your behalf. Strangers are not your 'human in the loop.'"* Where Myers offers pragmatic curation tips, Doctorow names the power dynamic — the cost of generating slop is near-zero, but the cost of evaluating it falls entirely on the recipient. This asymmetry is the economic engine behind the problem. Myers is being diplomatic; Doctorow is being precise.

**6. The "but what if it's good?" defense collapses on inspection**

pizzathyme and jibal argue that quality is all that matters — if AI output were good, nobody would complain. The article pre-empts this: yes, quality matters, but the *pattern* is that pasted AI output buries intention, and the people doing it rarely notice. chrysoprace's response cuts deeper: *"If my colleague can't be bothered to write a PR comment themselves then I can't be bothered to read it."* The issue isn't quality in the abstract — it's that sending AI output *signals* you didn't think hard enough to have something to say, and that signal poisons the communication regardless of the text's surface quality.

**7. The cost-of-support thread is a masterclass in talking past each other**

com2kid's top-level comment about $20/call support costs at Microsoft spawned the thread's longest subthread — and it's entirely off-topic. But it's instructive: com2kid frames support as an unwanted expense, while respondents like autoexec and godelski frame it as a consequence of shipping bad products. Both sides are making the same category error as the support-chatbot commenters: they're arguing about the *deployment* of AI (to replace human labor) when the article is about the *output* of AI (replacing human thought). The shared blind spot is conflating AI-as-labor-substitute with AI-as-communication-tool.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Quality is all that matters, not AI-ness | Medium | True in theory but ignores that the *pattern* of pasted AI is reliably low-signal. The exception doesn't disprove the rule. |
| Writing atrophy makes AI necessary | Weak | TimFogarty admits his writing has atrophied, then concedes LLMs "suck at writing." The cure is the disease. |
| This is just old-man-yells-at-cloud | Weak | onion2k invokes Douglas Adams. WD-42's response — "Do you enjoy reading slop?" — is sufficient. |
| Some people need AI to express themselves | Medium | foxglacier's wheelchair analogy is interesting but misapplied — the article already exempts careful iterative AI use. The problem is lazy paste, not assisted writing. |
| AI will improve and the problem will vanish | Weak | hatthew's information theory argument applies regardless of model quality. Better AI = less detectable padding, not more information. |

### What the Thread Misses

- **The asymmetry is economic, not just social.** Generating AI text is near-free; evaluating it costs real human attention. As AI gets better, this asymmetry *worsens* because the evaluation gets harder. Nobody in the thread models this as a market failure.
- **No one discusses the feedback loop.** If people stop reading AI-pasted content, the pasters get no signal that their communication failed. Unlike bad human writing (which at least reflects the writer's actual confusion), AI slop masks incomprehension behind fluency.
- **The "bare minimum curation" pattern needs tooling.** guerython's team does it manually. The article suggests doing it at PR-ready time. But no one asks: why isn't this a first-class feature in coding agents or PR tools? The gap between "everyone agrees this is good practice" and "no tool enforces it" is where the actual work is.
- **The RTFA rate *is* the phenomenon.** ~70% of commenters demonstrated exactly the lazy-communication pattern the article warns about — just with reading instead of writing. The irony is total, and nobody synthesizes it.

### Verdict

The article is modest and correct. The thread mostly validates it by example rather than engagement. The real contribution is hatthew's information-theoretic framing (you can't add information by expanding low-context input) and SaberTail's "misunderstanding amplifier" concept (AI doesn't just pad, it confidently invents meaning for ambiguous input). Together these go further than Myers does: the problem isn't just verbosity, it's that AI-mediated communication systematically destroys the signal that tells you *what the other person actually thinks*. The thread's own mass failure to read the article before commenting is the strongest possible evidence that the core dynamic — people optimizing for output volume over comprehension effort — predates AI and will only accelerate with it.
