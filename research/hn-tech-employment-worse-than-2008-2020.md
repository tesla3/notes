← [Index](../README.md)

## HN Thread Distillation: "Tech employment now significantly worse than the 2008 or 2020 recessions"

**Source:** [HN thread](https://news.ycombinator.com/item?id=47278426) (790 points, 532 comments) — March 6, 2026

**Article summary:** Joey Politano tweets BLS data showing US tech employment dropped 12k last month and 57k YoY, with the rate of decline now exceeding both the 2008 and 2020 recessions. A companion chart shows the only historical parallel for scale and duration is the dot-com bust.

### Dominant Sentiment: Bleak validation with methodological skepticism

The thread is split between people living the downturn (hundreds of applications, ghosting, lowball offers) and statisticians pointing out the chart shows a *rate of change* not absolute levels — tech employment is still higher than 2022 in raw numbers. The emotional weight overwhelmingly favors the former camp, but the latter has the stronger argument.

### Key Insights

**1. The chart is doing real rhetorical work the data doesn't support**

Multiple commenters independently flag the same issue: the graph shows YoY first-derivative change, not absolute employment levels. `thcipriani` does the math: tech jobs are up 12% since April 2020 (2.34M → 2.63M) and still above early 2022 levels. `dasil003` notes the chart conveniently starts at 2016 — the peak of boom times — and never shows 2008 despite the headline claiming to compare against it. `kittikitti` goes deepest, actually pulling the BLS series and finding that some categories show increases in February data the tweet omits, and that the "Custom Computer Programming Services" category can't even be located. The headline is technically about rate of decline, but it's designed to read as "fewer jobs than 2008," which is false.

**2. The market is violently bimodal, not uniformly bad**

`mjr00`: "Top candidates are commanding higher salaries than ever, but an 'average' developer is going to have an extremely hard time." This gets strong corroboration. `crystal_revenge` reports 4 interviews in a month without trying hard. `vicchenai` is getting 500+ applications per role for a fintech startup. `wnolens` is drowning in recruiter emails. Meanwhile `Trasmatta` (15 YOE, strong resume) can't get a single interview, `agentultra` has been searching 7 months with deep systems experience, and `coolThingsFirst` passed top 5% on a technical screen and still didn't get hired. The bimodality isn't senior vs. junior — it's "builder who ships" vs. "specialist who maintains," and the market has flipped hard toward the former.

**3. ZIRP correction, not AI apocalypse — but the narrative matters**

The thread mostly converges on this: the timing doesn't match an AI-driven contraction. `marginalia_nu`: "The dip started years before we had meaningful AI codegen." `jmward01` agrees the chart doesn't correlate with code assistant adoption. `pclowes` makes the strongest version: "Tech hiring is all downstream of interest rates. AI has had almost no impact, at least not yet." But `mattas` names the real dynamic: "Post-ZIRP companies are correcting [overhiring] but under the guise of AI." CEOs are using AI as investor catnip and political cover for what's actually a macro correction. The *narrative* of AI displacement is doing real damage to hiring decisions even if AI isn't actually displacing many workers yet.

**4. Employers are delusional about compensation and it's creating a structural impasse**

`stego-tech` provides the thread's standout comment — a detailed, data-backed job search log (100 applications, 7% interview rate, 50% ghost rate) plus qualitative observations. The key finding: employers want architect-level talent at mid-level pay in metros where median rent is $3,500/month. They're "under-titling" (wanting Leads for Senior roles), demanding impossible breadth (specialist engineers expected to cover the full stack including ERP/HRIS), and then acting offended when candidates name a market-rate floor. `jdwithit` corroborates: salary ranges like "$80k–$250k commensurate with experience" are malicious compliance with pay transparency laws. The impasse is structural: employers genuinely don't understand cost-of-living ("one employer had no clue the median rent was three and a half grand") while candidates have already cut from peak-FAANG pay and can't cut further.

**5. The "learn to code" generation is arriving at the worst possible moment**

`overgard` identifies the supply-side bomb: 15 years of "everyone should learn to code" created massive talent supply without proportional demand growth. `kypro` is harsher: 2-week bootcamps produced 6-figure hires in 2021, some working multiple jobs simultaneously. `bluecheese452` delivers the bitter rebuttal: "I graduated during the great recession. No one was hiring. Everyone from the president on down told us to learn to code. So we did." The cohort that followed society's explicit instructions is now being told they're surplus. Meanwhile `stackedinserter` and `cyberpunk` report from the hiring side that 80%+ of candidates can't write basic code — the supply glut is quantity without quality, which paradoxically makes it *harder* for everyone because it buries real candidates in noise.

**6. Ghost jobs and AI slop are poisoning the signal layer**

`ICantFeelMyToes`: ghost jobs are "a dirty secret for a bunch of Series A places." `stego-tech` finds ~20% of rejections have the role re-posted within 30 days. `albinowax_` reports recruiter spam is now "AI generated slop from gmail addresses, for some kind of scam." `janalsncm` jokes about LLM-generated recruiter outreach meeting LLM-generated responses. The matching infrastructure between employers and candidates is degrading at both ends simultaneously — applicants use AI to spray resumes, employers use AI ATS to auto-reject, and human signal gets crushed in between.

**7. Offshoring is the quiet story nobody wants to own**

`nphardon`: "My co is shedding US jobs and moving them to Taiwan, paying up to 75% less." `johnnyanmac` notes Microsoft still hires a lot — just not in North America. `alephnerd` argues WFH inadvertently justified offshoring: once you proved the work could be done remotely, the next question was obvious. `ph4rsikal` links to data showing India's tech job market is booming. This is the mechanism that connects ZIRP unwinding to permanent job loss: remote work proved feasibility, and the rate environment provided the incentive.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "It's first derivative, absolute numbers are fine" | Strong | Factually correct; the headline is genuinely misleading |
| "It's just shedding COVID overhires" | Medium | Explains 2022–2024 but not why the decline is *accelerating* into 2026 |
| "Good — incompetent people deserve to be culled" | Weak | Survivorship bias; plenty of strong engineers are struggling too |
| "Just move to SF/NYC" | Medium | Density helps, but `flatline` reports even in-market searches are coming up dry |
| "Start a startup" | Weak | VC is in a bad place and AI is eating all funding (`overgard`) |

### What the Thread Misses

- **The contractor/contingent workforce is invisible.** BLS data tracks payroll employment. Contract, freelance, and offshore workers don't show up. The real contraction is almost certainly larger than 57k, and the composition shift from W-2 to 1099 is unmeasured.
- **Nobody asks what's happening to total software output.** If employment is down but software production is up (via AI tooling, offshoring, or just fewer people doing more), the industry is getting *more productive*, not dying. That's a very different problem than "tech is shrinking."
- **The compensation impasse has a resolution and it's ugly.** Employers won't raise offers; candidates can't survive on them. The equilibrium is geographic: people leave expensive metros, companies either follow or offshore. The thread keeps framing this as a negotiation problem when it's actually a cost-of-living crisis that tech used to be exempt from.
- **No one connects the degraded hiring infrastructure to the bimodal outcome.** If AI ATS rejects good candidates and ghost jobs waste everyone's time, the only reliable channel is referrals — which inherently favors the already-connected, reinforcing bimodality.

### Verdict

The thread is arguing about whether this is 2001 or 2008 when it's actually neither. The dot-com bust was a demand collapse; this is a *repricing*. Tech employment isn't cratering — it's redistributing: toward AI-adjacent roles, toward cheaper geographies, toward fewer, higher-leverage engineers. The chart's first-derivative framing is emotionally compelling but analytically misleading, and the thread half-knows this but can't resist the doom. What nobody says clearly: the ZIRP era didn't just overhire — it set compensation expectations that created a structural mismatch with post-ZIRP economics. The pain isn't that jobs disappeared; it's that the jobs that remain don't pay what the jobs that preceded them did, in cities that got more expensive in the interim. That's not a recession. It's a regime change.
