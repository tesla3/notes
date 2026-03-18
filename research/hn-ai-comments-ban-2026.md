← [Index](../README.md)

## HN Thread Distillation: "Don't post generated/AI-edited comments. HN is for conversation between humans"

**Thread:** https://news.ycombinator.com/item?id=47340079 (4124 points, 1614 comments)
**Source:** HN's official guidelines page, updated to add: "Don't post generated comments or AI-edited comments. HN is for conversation between humans."
**Date distilled:** 2026-03-11

**Article summary:** HN added a single-sentence rule to their existing guidelines page banning both AI-generated and AI-edited comments, asserting that HN is a space for human conversation. The rule sits between existing guidelines about kindness and not sneering.

### Dominant Sentiment: Enthusiastic approval masking deep anxiety

The thread is overwhelmingly supportive (~80%+ in favor), but the interesting signal is in the minority. The dissenters aren't cranks — they're identifying real structural problems the majority is choosing not to engage with. The thread's enthusiasm functions partly as collective reassurance, like applauding a fire alarm while the building smolders.

### Key Insights

**1. The "proof of work" theory of conversation is the thread's real framework**

The strongest intellectual contribution comes from [hbjkhgkytfkytv]: "HN works because of the 'proof of work' behind a good comment... When the cost of generating a response drops to zero, the value of the conversation follows it down. If the author didn't care enough to write it, why should I care enough to read it?" This is the thread's implicit consensus — conversation has value because it costs something. This echoes [oramit]'s pithier version: "If you didn't bother to write it, why should I bother to read it?" The analogy to proof-of-work is apt and reveals the thread's unstated assumption: the *friction* of writing is a feature, not a bug. It's an anti-efficiency argument from a community that worships efficiency everywhere else.

**2. The ESL/accessibility fault line is real and unresolved**

A significant bloc raises the same objection from different angles: [nkzd] ("being well spoken is associated with higher class"), [chrystianpl] (dyslexia + ESL), [submeta], [ma2kx], [AceJohnny2] (translation), [schappim] (child with severe written language issues), [geobuk-dosa]. The thread never resolves this. The best it manages is [chrisweekly]'s self-aware worry: "It'd be ironic if I start getting flagged as a bot, given I don't even use a spell-checker." The rule as written makes no distinction between "LLM rewrote my braindump from scratch" and "LLM fixed my ESL grammar." This is the most legitimate criticism and the one supporters most actively dodge.

**3. The spell-checker-to-LLM spectrum has no natural boundary**

Multiple commenters identify the sorites paradox at the rule's core: [arendtio] ("Is a spell checker okay? How about one that also suggests alternative wording?"), [dev_l1x_be] (Grammarly), [crossroadsguy] (Apple's Proofread), [xupybd], [dathinab]. The rule says "AI-edited" but doesn't define where "AI" begins. Grammarly uses ML. Apple's Writing Tools use on-device LLMs. Browser spell-check uses statistical models. The boundary is philosophically incoherent, which means enforcement will be vibes-based — which is actually how HN has always operated, and which is maybe fine.

**4. The hypocrisy angle is pointed but ultimately deflected**

Several commenters note the irony of YC — which funds dozens of AI companies — banning AI on its own forum. [mamami]: "YC funds a gazillion AI startups that expand and augment the AI slop pipeline, but would hate to experience the consequences. It's very much slop for thee but not for me." [maplethorpe]: "How can HN be so pro-AI for the rest of the world, but anti-AI on HN?" [forgetfreeman] makes the sharpest version: "Nearly unanimous rejection of AI-generated content while simultaneously breathlessly touting AI tooling in significantly more sensitive environments like the company codebase." This is a real tension, but the thread mostly shrugs it off. The implicit answer is: building AI tools ≠ wanting AI in your social spaces, which is coherent but uncomfortable.

**5. Enforcement skepticism is universal — even among supporters**

Almost no one believes the rule is technically enforceable. [capricio_one]: "who is this guideline going to stop?" [charlie0]: "virtually meaningless as there's no way to enforce it." [stalfie]: "Without a technical means to enforce this, the only result of this policy will be a culture of paranoia and a lot of false positives." The thread's tacit answer is that it functions as a social norm, not a technical control — like speed limits. [GodelNumbering] captures this: "Even if people try to bypass it, having the official rule matters a lot." The interesting question nobody asks: does making an unenforceable rule explicit actually *weaken* authority when violations are visible and unpunished?

**6. The meta-irony of this thread is thick**

Multiple commenters post obviously AI-generated joke responses: [stephenlf] ("Great catch! You're absolutely right"), [tristanb], [xupybd], [zekenie], [whalesalad], [dopidopHN2] — all posting "You're absolutely right!" as a running gag. [s_dev] openly shares a Claude link. [monksy] pastes raw LLM output. [gos9] observes: "Half of this thread is AI assisted writing. lol." The thread about banning AI comments is itself partially composed of AI comments, which is either a damning indictment of enforceability or performance art.

**7. The "impersonation of thought" fear is the real driver**

Beneath the practical arguments, the emotional core is fear of *epistemic fraud* — reading something you believe was thought through by a person, when it wasn't. [nunez]: "I hate how easy AI has made outsourcing thinking." [randusername] quotes Orwell: "If people cannot write well, they cannot think well." The concern isn't really about text quality — it's about whether engaging with AI-generated comments is a form of being deceived. This is why [spullara]'s "if a comment is useful I don't really care" position, while logically defensible, gets no traction. The community viscerally feels that the source matters.

**8. Concrete technical proposals get surprisingly little engagement**

[rob] posts a detailed 5-point technical plan (account age thresholds, timestamp analysis, dedicated flag-bot button). [hellcow] suggests paid account creation. [boramalper] wants CAPTCHAs. [foxfired] wants rate-limiting new accounts. These get modest upvotes but no substantive discussion. The thread prefers philosophical hand-wringing over implementation details, which mirrors a broader HN pattern: the community loves talking about problems more than solutions.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| ESL/accessibility users need AI editing | **Strong** | Genuinely disadvantaged group with no good alternative offered |
| Spell-checker ↔ LLM boundary is arbitrary | **Strong** | Philosophically unresolvable; HN's vibes-based moderation may handle it in practice |
| Rule is unenforceable | **Medium** | True technically, but social norms don't require perfect enforcement |
| YC funding AI while banning AI comments is hypocritical | **Medium** | Logically sound but "don't shit where you eat" is a coherent position |
| "Judge content not origin" | **Weak** | Ignores that epistemic trust is part of conversation's value; you can't judge what you can't verify |
| This is ableist/Luddite | **Weak** | [zmef]'s "cave painting" argument is overwrought; writing, printing, and LLMs differ in kind, not just degree |

### What the Thread Misses

- **The training data feedback loop.** [8cvor6j844qw_d6] and [polskibus] barely scratch this: a human-only forum becomes an unusually clean training corpus. HN's policy doesn't just preserve human conversation — it creates a valuable dataset. Nobody connects these dots to YC's commercial interests.

- **The false positive cost is asymmetric.** Banning a bot costs nothing. Falsely accusing a human of being a bot is deeply alienating. The thread has no framework for this asymmetry, and [chrisweekly] and [AyanamiKaine] only gesture at it. As detection becomes more aggressive, the false-positive rate will matter more than the true-positive rate.

- **The generational divide.** Nobody asks whether younger users, who grew up with AI-assisted writing as default, will see this rule as reasonable or as absurdly puritanical. HN's demographics skew older-tech; this rule may accelerate that skew.

- **AI-generated *submissions* are the bigger problem.** [alansaber], [Madmallard], [rc-1140], and [pton_xd] note that AI-generated blog posts hitting the front page is arguably worse than AI comments, since they consume far more collective attention. The guidelines update only addresses comments.

### Verdict

The thread circles a tension it never names: HN's value proposition has always been *curation through friction* — karma thresholds, no images, minimal UI, social norms enforced by a tiny mod team. AI-generated comments don't just add noise; they threaten the entire selection mechanism. The rule isn't really about AI detection — it's about preserving the *cost of participation* that makes HN's signal-to-noise ratio possible. The community intuitively understands this (hence the "proof of work" framing) but can't articulate why that same logic shouldn't apply to AI-assisted code, AI-assisted research, or AI-assisted everything-else in their professional lives. The cognitive dissonance is real, but the policy is probably correct for the narrow goal of keeping HN readable. The harder question — what happens when the best comments are indistinguishable from AI regardless of origin — remains unasked.
