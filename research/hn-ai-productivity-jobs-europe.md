← [Software Factory](../topics/software-factory.md) · [Coding Agents](../topics/coding-agents.md) · [Index](../README.md)

## HN Thread Distillation: "How AI is affecting productivity and jobs in Europe"

**Source:** [HN thread](https://news.ycombinator.com/item?id=47068320) (169 points, 132 comments) · [VoxEU article](https://cepr.org/voxeu/columns/how-ai-affecting-productivity-and-jobs-europe) (Aldasoro et al. 2026, BIS/EIB) · Feb 18, 2026

**Article summary:** First causal study of AI's effect on European firms (12,000+ surveyed). Finds AI adoption increases labour productivity by 4% on average, with no short-run employment reduction — consistent with capital deepening (augmentation, not displacement). Gains concentrate in medium/large firms; small firms see negligible or negative effects. Critical multiplier: an extra percentage point spent on worker training amplifies AI productivity gains by 5.9 percentage points. Uses a novel instrumental variable design matching EU firms to comparable US firms to isolate causation.

### Dominant Sentiment: Skeptical of the study, anxious about the future

The thread splits between methodological critics who find the 4% figure too early/too blurry to trust, and workers who hear "no job losses" and don't believe it for their own horizon. Almost nobody engages with the study's strongest finding (the training multiplier). The discussion drifts heavily toward search engine decay and labor politics — telling in itself.

### Key Insights

**1. The study measures "big data analytics and AI," not LLMs — and almost nobody notices**

[gwern] catches it: "I'm not sure this is even measuring LLMs in the first place! They say the definition is 'big data analytics and AI.'" [yorwba] confirms the definition includes "machine learning, robotic process automation, NLP, algorithms, neural networks." [aregue] connects the dots: "This article does not seem to contradict more recent findings that LLM do not (yet) provide any increased productivity at the company level." This is a fundamental category confusion — the HN headline primes readers for LLM discourse, but the study is measuring a much broader basket of technologies, many of which have been deployed for years. The 4% figure may mostly reflect pre-LLM automation gains.

**2. Self-reported adoption data is the study's weakest link**

[rwmj] digs into the methodology after finding the actual paper: "Use of AI is based on self-reported data" from "senior managers or financial directors." The adoption question lumps together firms that say AI is "used in parts of the business" with those whose "entire business is organized around this technology." A CFO saying "yes, we use AI" could mean anything from a chatbot on the website to an ML-driven supply chain. This measurement problem likely inflates the adoption denominator while blurring the productivity signal.

**3. The "too early" argument is strong but self-serving**

[irjustin] sets the frame: "Large orgs have very sensitive data privacy considerations... Deloitte only recently gave the approval in picking Gemini as their AI platform." [jillesvangurp] provides ground-truth from German SMEs: "Forget AI, these guys are stuck in the last century when it comes to software. A lot of paper based processes." This is all true — and it's the reason the study's 4% figure exists at all. But the "too early to judge" argument is doing double duty: it's simultaneously used by AI boosters ("the gains will be huge, just wait") and by skeptics ("the gains are modest because adoption hasn't happened"). Both can't be right. The study's actual contribution — that *among firms that have adopted*, gains are moderate and concentrated — is ignored by both camps.

**4. The training multiplier is the buried lede**

The study's most actionable finding gets zero thread engagement: "An additional percentage point spent on training amplifies AI's productivity gains by 5.9 percentage points." This is a 6x multiplier — dramatically larger than the 2.4x multiplier from software/data infrastructure investment. It implies that the binding constraint on AI productivity isn't the technology but workers' ability to use it. [epolanski] inadvertently confirms this from the field: Italian companies "shoving NotebookLM and Gemini down their employees" with the attitude of "find the time to understand how to use these tools in your own role" — no training, just mandates.

**5. The Deloitte hallucination incident is a perfect microcosm**

[shakna] surface-mines gold: Deloitte's Australian arm produced a $290K government report containing fabricated academic citations and a made-up court quote, then offered only a partial refund. This happened despite (or because of) "shadow AI" — employees using AI tools before official organizational rollout. [fhd2] names it: "individuals might just use their personal plans anyway, potentially in violation with their contract." The incident captures the 2026 AI adoption paradox: organizations move slowly on official adoption while employees move fast on unofficial adoption, creating a gap where nobody is responsible for quality.

**6. The search engine decay subthread reveals a displacement dynamic the study doesn't measure**

Half the thread discusses how AI search is replacing degraded Google search. This isn't tangential — it reveals a form of AI "productivity gain" that no firm-level survey captures: individuals recovering time previously lost to enshittified infrastructure. [m463]: "an AI assist with a web search usually eliminates the search altogether." [kdheiwns] pushes back hard: "What used to be a 10 second google search is now a 2-3 minute exercise" because you have to verify AI answers. [cor_NEEL_ius] provides data: tested 6 AI presentation tools, "best accuracy was 44%." The thread converges on a framework: **AI shifts the cost from search to verification**, and nobody is accounting for the verification cost in productivity studies.

**7. The labor politics subthread names a dynamic the study's "no job losses" finding obscures**

[8cvor6j844qw_d6]: "Managers are openly asking all employees to pitch in ideas for AI in order to reduce employee headcount." [AlexeyBelov] provides the darkest data point: a department "went out of their way to show top managers they could leverage AI... 75% of people from that dept were let go because of how successful their AI trial was." The study finds no aggregate employment effects — but that's a firm-level average that can hide compositional shifts (roles eliminated, different roles created, or the same headcount doing more work). [fatherwavelet] articulates the non-linear threat: "It is not going to be a % more productive than our business. The company I work for will go from 1 to zero really quick."

### What the Thread Misses

- **The instrumental variable design is clever and nobody interrogates it.** Using matched US firm adoption as an instrument for EU firm exposure is methodologically interesting — it assumes US adoption is exogenous to EU-specific factors. But if both are driven by the same global tech vendor push (Microsoft Copilot rollouts, etc.), the instrument is contaminated. Nobody in the thread has the econometrics background to engage with this.
- **The small-firm negative productivity finding is potentially devastating and nobody dwells on it.** If AI adoption *hurts* small firms — the backbone of European economies — the aggregate 4% figure is masking a widening competitive gap. This is a concentration-of-power dynamic, not a productivity story.
- **Nobody connects the training multiplier to the shadow AI problem.** If training is a 6x multiplier and most adoption is unofficial/untrained, the current productivity measurement is capturing a worst-case scenario. The upside could be substantially higher — or the quality risks substantially worse.

### Verdict

The study is careful empirical work measuring something that isn't quite what the headline implies — broad "AI and big data" adoption, not LLMs specifically. The thread reveals the gap between this academic measurement and lived experience: practitioners oscillating between "it's too early to tell" and "people are already getting fired." What nobody names is the **measurement-experience divergence**: the study finds moderate average gains and no job losses because it measures firms that self-report adoption, at a moment when the actual adoption is happening through shadow channels that no survey captures and no training supports. The 4% figure isn't wrong — it's measuring the wrong thing at the wrong resolution to answer the question everyone is actually asking.
