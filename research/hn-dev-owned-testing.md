← [Index](../README.md)

# HN Thread Distillation: "Dev-owned testing: Why it fails in practice and succeeds in theory"

- **Source:** [HN thread](https://news.ycombinator.com/item?id=46646226) · [ACM paper](https://dl.acm.org/doi/10.1145/3780063.3780066)
- **Score:** 161 · **Comments:** 182 · **Date:** ~Jan 2026

**Article summary:** An ACM SIGSOFT position paper by an Amazon QA manager argues that "shift-left" / dev-owned testing consistently fails in practice due to skill gaps, misaligned incentives, and organizational dysfunction — despite looking compelling in theory. The paper draws on industry signals (including Google's 16% test flakiness rate) and recommends the research community better support dev-owned testing as a socio-technical system. Notably, 4 of its 7 references point to a single Google blog post.

## Dominant Sentiment: Nostalgic agreement, qualified dissent

The thread runs ~60/40 pro-QA, but the interesting part is that both sides agree on the *same underlying problem* (management dysfunction and incentive misalignment) and disagree only on who should hold the bag.

## Key Insights

**1. The paper arrives pre-discredited**

Multiple commenters independently torpedo the article's credibility before anyone engages with its substance. wesselbindt flags the author's conflict of interest as an Amazon QA manager. MoreQARespect notes that "this paper has 7 references and 4 of them are to a single Google blog post... there is very little of interest in this paper." \_\_alexs calls it "basically a blog post that somehow got published in ACM." pjdesno pushes back — it's a position paper in SE Notes, which is exactly what that publication is for — but the damage is done. The thread treats this as an opinion piece wearing academic robes, and evaluates it accordingly.

**2. The economic incentive trap nobody wants to name**

The sharpest structural insight comes not from the thread but from KingOfCoders' [linked article](https://www.amazingcto.com/tests-are-bad-for-developers/): bugs found during development count *against* sprint commitments. Bugs found in production get their own sprint allocation. This makes skipping tests *locally rational* for developers under time pressure. terribleidea crystallizes the lived experience: "if you try adjusting your estimates to include proper testing, you get push back, and you have to ARGUE your case as to why a feature will take two weeks instead of one." The perversity is that organizations that eliminate QA to increase velocity then punish devs for spending time on the quality work they just inherited.

**3. The bimodal QA distribution has a causal explanation**

hinkley observes QA capability is bimodal — "the good ones are great, the bad ones infuriating" — and several commenters echo this. But the thread converges on *why*: MoreQARespect admits "testing is probably my favorite topic in development... but no way in hell am I taking a pay cut and joining the part of the org nobody listens to." daotoad: "If you're a talented SDET, you're probably also, at least, a good SDE. If you'll make more money and have more opportunity as an SDE, which career path will you follow?" The bimodal distribution isn't a mystery — it's a predictable outcome of paying QA less and respecting them less. You get the people who couldn't leave and the rare idealists. pixl97 closes the loop: "Companies think QA is shit, so they hire shit QA, and they get shit QA results. Then they get rid of QA."

**4. "Dev-owned testing" conflates two very different things**

terribleidea makes the thread's most underappreciated distinction: "When devs say that devs should be responsible for testing, they *usually* mean [unit and integration tests], and not this separate skillset of coming up with a bunch of weird edge cases... what happens if I drop my laptop in a dumpster while making the request from firefox and safari at the same time." The paper and the thread keep sliding between "devs writing automated tests" (which basically everyone agrees should happen) and "devs doing adversarial exploratory testing" (which requires a different mindset). marcosdumay pins it: "it's certainly a separate mindset... One just can't competently do both at the same time. And 'time' is quantized here in months-long intervals."

**5. The DevOps parallel is more damning than the thread realizes**

scott\_w draws the analogy to "throwing it over the wall" to Ops — we discarded that view a decade ago. But darkwater flips this into a darker pattern: "First they came with the NoOps movement... Then they came with the dev-owned testing... Now they are coming with LLM agents." The unstated mechanism: each "shift-left" is management discovering it can eliminate a headcount category by making devs absorb the work — without adjusting expectations or timelines. TeMPOraL names the economic structure directly: "extra salaries are legible in the books, while heavy loss of productivity isn't."

**6. Dev-owned testing works — when you control the preconditions**

sethammons describes the most detailed success case: team set its own timelines, owned on-call, had a rotating "quality focused dev," and automated comprehensively. "Eventually people stopped even manually verifying their code because if the tests were green, you *knew* it worked." The pattern across all success stories (sethammons, regularfry, tracerbulletx, inetknght) is the same: *the team controlled its own pace.* The moment velocity is externally imposed by PMs or leadership, dev-owned testing collapses — not because devs can't test, but because they're not given time to. donatj's experience is the dark mirror: "One day they just let our entire QA team go. Literally no direction at all."

**7. The bbayles boomerang: bad QA as accidental quality lever**

bbayles tells a story about a QA person who consistently misunderstood features and wrote "pages and pages of misguided commentary." This forced bbayles to make features smaller, document defensively, and write isolation scripts — "which is what I should have been doing in the first place!" SoftTalker adds the punchline: "If a QA person (presumably familiar with the product) misunderstands the point of a feature how do you suppose most users are going to fare with it?" The QA person's apparent incompetence was actually a P5-user proxy, stress-testing the feature's legibility rather than its implementation. This is the kind of value that vanishes when you eliminate QA and is invisible in productivity metrics.

**8. The insurance market has already priced this**

monster\_truck introduces an angle nobody else explores: "Ask your insurance agent about the premiums for contractual liability insurance with and without a QA team. If you can provide metrics on their performance, -10-15% is not uncommon... Without one? +15-50%." When an industry with actual skin in the game — insurers — prices QA presence as a 25-65 percentage point swing in risk assessment, the "devs can own it all" position faces a hard empirical wall, at least for regulated/contractual software.

## Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "QA is a separate skillset, devs shouldn't do it" | Medium | True for adversarial/exploratory testing; overstated for automated tests |
| "Dev-owned testing works fine, I've done it" | Strong | Valid but always comes with preconditions (team autonomy, on-call ownership) that survivors don't realize are unusual |
| "Most QA people are bad anyway" | Medium | Confuses effect (talent drain from underpay) with cause; the fix is better QA hiring, not elimination |
| "AI will solve this" | Weak | Only one comment raises it; the thread conspicuously ignores AI for testing |
| "The paper is academically weak" | Strong | The bibliography issue is real and undermines the claims |

## What the Thread Misses

- **Nobody asks what Amazon's own data shows.** The author is *at Amazon* — a company famous for data-driven decisions. If dev-owned testing were measurably failing there, Amazon would presumably have the data to prove it. The paper doesn't cite any. Neither the author nor the thread addresses why.
- **The thread treats "QA" as monolithic** when the role has fractured into at least three jobs: manual exploratory testers, SDET/automation engineers, and quality-process-architects. Each has different economics and different replaceability by devs. The "do we need QA" question has three different answers depending on which you mean.
- **Nobody connects this to the broader white-collar role elimination pattern.** TeMPOraL gets closest with the "false economy" frame, but the thread doesn't notice this is the same playbook applied to tech writers, internal tooling teams, and now junior devs via AI. The common thread is legible cost reduction vs. illegible quality/productivity loss.

## Verdict

The thread circles but never quite states the core dynamic: dev-owned testing isn't a technical question, it's a power question. Every success story features teams that controlled their own timelines and priorities. Every failure story features external velocity pressure consuming the time QA work requires. The paper and the thread both frame this as "culture" or "mindset" — soft, squishy things — when it's actually about who holds the authority to say "this isn't ready." Eliminating QA doesn't eliminate that decision; it just ensures nobody with organizational standing makes it. The devs know it's not ready, but they don't have the positional authority to block a release the way a QA lead does. hinkley nearly says this outright — "with three people 'in charge' of the project instead of two, you get restoration of Checks and Balances" — but the thread treats this as an anecdote rather than the structural insight it is.
