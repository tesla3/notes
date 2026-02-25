← [Index](../README.md)

## HN Thread Distillation: "Looks like it is happening"

**Source:** [Peter Woit's blog](https://www.math.columbia.edu/~woit/wordpress/?p=15500) (Columbia math dept) | [HN thread](https://news.ycombinator.com/item?id=47143211) — 146 points, 101 comments, 79 unique authors

**Article summary:** Woit claims arXiv hep-th (high energy physics — theory) submissions have nearly doubled in late 2025/early 2026, hypothesizing AI-generated papers are flooding the preprint server. He cites Sabine Hossenfelder's argument that the PI-grad-student paper mill is being disrupted by AI agents that can produce mediocre papers faster and cheaper. **However, the article contains its own correction:** a commenter (Jerry Ling) identified that Woit searched by "most recently modified" date rather than original submission date. Corrected numbers show ~15-20% year-over-year increases — significant but nowhere near doubling.

### Dominant Sentiment: Alarm validated, data debunked, anxiety persists

The thread is structured around a false premise that gets corrected early, yet the emotional energy of the discussion barely acknowledges the correction. Most commenters are arguing about a doubling that didn't happen, which itself illustrates the AI-slop dynamic they're worried about: low-effort conclusions propagating faster than corrections.

### Key Insights

**1. The article debunks itself, and the thread mostly doesn't notice**

Chinjut posts the Jerry Ling correction as the top comment — the "doubling" is an artifact of searching by last-modified date. Woit updated his post accordingly. But the vast majority of the 101 comments proceed as though the original alarming numbers stand. Only a handful of commenters engage with the corrected data (still a meaningful ~15-20% increase). The thread's reaction to a flawed data claim about AI slop is itself a demonstration of how slop propagates: the narrative is stickier than the correction. As myhf sharpens: *"The last-modified-date effect is even more important, because it can be used to support whatever the latest fad is, without needing to adapt data or arguments to the specifics of that fad."*

**2. dang's HN data is the real signal in this thread**

dang confirms HN submissions and unique submitters have hit all-time highs after being *"surprisingly stable — fluctuating within a fixed range for well over 10 years."* This is far more rigorous than Woit's arXiv numbers because dang has actual operational data, not scraped search results. He's careful to note it's "not double... yet" and admits they don't yet know how much is bots vs. organic growth. rob adds concrete observations: *"They'll type in all lowercase, they'll have the creator post manually to throw you off, they'll make multiple comments within 45 seconds that a normal human couldn't do."* marginalia_nu contributes a sharp statistical observation: 28 em-dashes in /noobcomments vs. one in /newcomments — a telltale stylometric fingerprint of LLM output.

**3. "Publish or perish was already broken" is the thread's consensus — but nobody proposes what replaces it**

This is the strongest convergence in the thread. selridge: *"We were already in a completely unsustainable system. Nobody had an alternative. We still don't have one but at least now it's not just merely unsustainable — it is completely fucked in half."* Certhas adds the realist counterpoint: *"Social systems have an incredible ability to persist in a state of utter fuckedness much longer than seems reasonably possible."* commandlinefan, MarkusQ, and hunterpayne all pile on. The thread reaches full agreement that the incentive structure is rotten and AI is accelerating the rot — then stops. Nobody proposes a replacement metric, a new institutional design, or even a concrete reform. The diagnosis is unanimous; the prescription is absent.

**4. The GPT-5.2 physics result is the elephant nobody wrestles with**

zozbot234 links to OpenAI's preprint showing GPT-5.2 Pro conjectured a genuinely novel result in theoretical physics — *in the very subfield (hep-th) being discussed*. The paper demonstrates AI finding a formula for single-minus gluon tree amplitudes that physicists had assumed were zero, with Nima Arkani-Hamed endorsing it. This creates a tension the thread ignores: the same field supposedly drowning in AI slop is simultaneously producing AI-assisted results endorsed by IAS professors. The mechanism is clear — the same tool floods the bottom of the quality distribution while extending the top — but nobody names it.

**5. lmeyerov's "Software Collapse" is the thread's best original concept**

lmeyerov coins "Software Collapse" (analogous to AI model collapse): *"As the cost to clone good ideas goes to zero, software converges towards the existing best ideas & tools across the field and stops differentiating."* The result is *"higher quality but bland."* This is genuinely non-obvious — most discourse frames AI as either raising quality or lowering it, not simultaneously raising average quality while collapsing variance. The implication for academic papers is direct: if AI makes it trivial to produce competent-but-undifferentiated work, the papers get better on average while becoming less likely to contain novel insight. zozbot234 pushes back that "bland" isn't bad, citing FLOSS's similar trajectory, but misses that academic science — unlike infrastructure software — depends on variance and surprise.

**6. The practitioner-theorist split is stark**

ModernMech, apparently an active researcher, reports: *"I wish the AI could write my papers. I ask it to and it's just bad. The research models return research that doesn't look anything like the research I do... half of it is wrong, the rest is shallow."* This is the inverse of the thread's dominant panic. The people producing genuinely novel research find AI useless for their actual work. The people worried about AI flooding are describing a tier of work that was already low-quality. The antirez blog post (linked by Philpax) makes the structural point: *"Automatic programming produces vastly different results with the same LLMs depending on the human that is guiding the process."* The quality ceiling is set by the operator's vision, not the tool's capability.

**7. The black market for aged accounts surfaces a new attack vector**

dragontamer describes old social media accounts being stockpiled and sold, enabling AI bots to bypass reputation-based trust systems. rob confirms seeing years-old dormant HN accounts suddenly posting at inhuman speeds. This is an underappreciated dynamic: the trust systems built on account age (arXiv endorsements, HN karma, academic reputation) are being arbitraged. The cost of manufacturing "trust" is collapsing alongside the cost of manufacturing content.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| Data is wrong (modified vs. submission date) | **Strong** | Debunks the headline claim entirely. Corrected data still interesting but not alarming. |
| AI can't write real research | **Strong** | ModernMech's first-person account. Countered by GPT-5.2 physics result, suggesting the ceiling is rising fast. |
| Publish-or-perish is the real problem, not AI | **Strong** | Near-universal consensus. But functions as a thought-terminator — names the disease without treating it. |
| Software/research has peaked | **Weak** | krashidov's "no React successor" thesis. Multiple commenters point out AI could build any successor tool on demand. |
| This is just YouTuber clickbait analysis | **Medium** | bitbytebane and seg_lol dismiss Hossenfelder as a source. Fair critique of her specifically, but ad hominem to the underlying data question. |

### What the Thread Misses

- **The corrected 15-20% increase is still historically anomalous and nobody analyzes it.** A ~20% year-over-year jump in a field that had ~1-2% annual growth is significant. The thread either panics about the fake doubling or dismisses the whole thing.
- **Nobody asks about citation patterns.** If new papers flood arXiv but nobody cites them, the problem is self-limiting. If they DO get cited, the corruption of the citation graph is the real crisis, not submission volume.
- **The arXiv endorsement system's failure mode goes unexplored.** arXiv requires endorsers for new submitters. Is the ~20% increase from new authors gaming endorsements, or existing authors publishing more? This distinction matters enormously for the diagnosis.
- **The GPT-5.2 result creates a dual-use problem nobody names.** The same AI capability that extends the frontier of hep-th simultaneously enables flooding the field with competent-looking slop. This is structurally identical to the dual-use problem in biosecurity and the thread doesn't connect the dots.
- **Nobody mentions journal overlay systems or alternative curation mechanisms** that could address the signal/noise problem. The arXiv overlay journal model (e.g., Discrete Analysis, Quantum) already exists and could scale.

### Verdict

The thread debates an AI apocalypse in theoretical physics that the article's own correction reveals hasn't arrived — yet. The real story is subtler and worse: a ~20% year-over-year increase in a stagnant field, combined with the simultaneous demonstration that AI can produce both genuine novelty (GPT-5.2's gluon amplitude result) and undifferentiated mediocrity at scale. The thread circles but never states the core dynamic: AI doesn't break quality filters — it reveals that the filters were already broken by exposing how much "human" work was indistinguishable from what a machine produces. Woit has been saying hep-th is intellectually bankrupt for 25 years; AI is just providing the stress test that proves him right, while also — ironically — producing the first genuinely novel hep-th result the field has gotten excited about in a while.
