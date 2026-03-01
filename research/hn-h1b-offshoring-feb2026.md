← [Index](../README.md)

## HN Thread Distillation: "Silicon Valley can't import talent like before. So it's exporting jobs"

**Source:** [Rest of World](https://restofworld.org/2026/h1b-visa-impact-india-tech-hiring-faamng/) (Feb 2026) · [HN thread](https://news.ycombinator.com/item?id=47124475) (65 pts, 114 comments, 61 authors)

**Article summary:** FAANG companies added ~33,000 workers in India in 2025 (+18% YoY), with Alphabet reportedly leasing space for 20,000 more in Bengaluru. The article attributes the surge to Trump-era H-1B fee hikes ($5K→$100K per petition) and rising rejections, citing a UPenn study finding that for every H-1B rejection, multinationals hire 0.4–0.9 employees abroad. Nearly half of open positions are in AI/ML, cloud, and cybersecurity.

**Article critique:** The article bundles two distinct claims — (1) offshoring is accelerating and (2) H-1B restrictions are the cause — then treats them as a single story. The 33K hiring figure and the Alphabet lease are solid evidence for claim #1. But claim #2 is weakly supported: the article's own timeline shows Amazon and Microsoft committed $52.5B to India *before* the latest H-1B changes, and the companies' India buildouts predate the fee hikes by years. The UPenn study provides a genuine causal mechanism, but the article uses it as confirmation rather than testing whether H-1B restrictions are the *marginal* driver versus long-running cost arbitrage. The "talent" framing in the headline is particularly slippery — the article quotes an HR expert praising India's "deep tech, deep learning" workforce, but the economic logic of 85% mid-to-senior roles at Indian salary scales goes unexamined.

### Dominant Sentiment: Cynical vindication, zero surprise

The thread is overwhelmingly unsurprised and contemptuous of the "talent" framing. Nobody — not even those defending offshoring on efficiency grounds — believes the headline's premise that this is about access to talent rather than cost. The few genuine disagreements are about whether this outcome is *bad* or merely *inevitable*.

### Key Insights

**1. The thread instantly demolishes the article's causal claim**

The top comment (palmotea) sets the tone: "They didn't open the office because they had a hard time hiring in the US. They opened it because they wanted to pay developers $10k/year instead of $100k a year." Multiple commenters (silisili, some_random, givemeethekeys) point out that FAANG offshoring predates H-1B scrutiny by a decade. The article is describing an acceleration, not a new phenomenon, and the thread correctly identifies the H-1B angle as corporate PR cover for a cost optimization play that was already in motion.

**2. "Old Google vs. New Google" as a periodization of decline**

lokar (ex-Google, credible based on specifics) describes the old hiring model: "We simply hired as many people as we could find who could get through the process... We would never hire a less qualified person simply because they could work in the US." siliconc0w responds: "New Google lays off teams and moves them to India. New grad hiring is all but paused." lokar's own explanation is devastating: "various issues inevitably reduced Eng effectiveness to the point where now outsourcing is no worse." The implication is that finance-driven management degraded internal engineering quality until offshoring became rational — the rot preceded the offshoring, not the reverse. billev2k draws the Boeing parallel, which lands.

**3. The "talent shortage" is a salary shortage — and both sides know it**

kadabra9 hammers this repeatedly: "it's really a 'pipeline and talent at salaries I want to pay' issue." alephnerd (cybersecurity founder) pushes back with specifics — eBPF, Linux internals, OS backgrounds — arguing bootcamp grads genuinely can't do the work. But the thread doesn't let him escape: kadabra9, anonym29, and mixmastamyk all note that *experienced* domestic candidates exist and are being passed over, not just juniors. The real debate isn't junior vs. senior — it's whether companies have a legitimate right to redefine "the market" by expanding the labor pool globally, or whether that's wage suppression dressed as meritocracy. alephnerd's own hiring move (shifting to Tel Aviv at Atlanta-equivalent salaries) reveals the tell: it's not that talent doesn't exist domestically, it's that the *price-to-quality ratio* is better elsewhere. anonym29 nails it: "There is sufficient talent inside the US, it just comes with a price tag they don't like."

**4. The offshoring cycle has a documented history — and a documented crash**

JamesLeonis delivers the star comment with heavily sourced historical parallels: post-2000 offshoring rush → poor quality code → re-shoring by mid-2000s → collapsed CS enrollment pipeline. The Brown University quote (CS enrollment dropping from 220 to 60 shoppers) is a concrete datapoint for how offshoring signals destroy the domestic talent pipeline, creating the very shortage companies later complain about. This is the cycle that stego-tech describes more abstractly — but JamesLeonis pins it to dates and sources.

**5. The H-1B as "modern indentured servitude" — a structural power argument**

anonym29 describes the coercive dynamics: 90-day window to find a new sponsor or self-deport, creating a power imbalance where "the employer can basically ruin the employee's life whenever they want." skeledrew, an actual former visa holder, partially validates the system — "I was super grateful for the opportunity" and found the wages "very livable" — but this *confirms* the power asymmetry rather than refuting it. The gratitude of the exploited doesn't make the structure non-exploitative.

**6. The geopolitical angle: US companies as stateless actors vs. China's strategic coherence**

palmotea makes the sharpest structural argument: "A US company *should be* loyal to the US: the fact that they are not is political dysfunction. China, for all its faults, gets that." This reframes the debate from labor economics to national strategy. The thread's libertarian wing (baron816, energy123) argues for pure free-market logic, but palmotea and lkjdsklf point out that these companies depend on US infrastructure, legal systems, tax advantages, and government contracts — they extract value from the US while exporting its economic base. lkjdsklf: "Why would we give government contracts to a company that's offshoring jobs?"

**7. Israel as the quiet counter-model**

alephnerd (same cybersecurity founder) notes a shift to Tel Aviv hiring: "Israeli tech salaries are comparable to Atlanta and Dallas, yet we get better talent across the board — less bootcamp grads and more people with a background in OS and algos." This is the one data point in the thread suggesting genuine quality-driven offshoring rather than pure cost arbitrage. butterbomb correctly identifies why: Israel's military-industrial pipeline (especially Unit 8200) produces OS/systems-level engineers at scale in a way the US bootcamp ecosystem doesn't.

**8. The protectionism debate generates more heat than light**

baron816 and energy123 argue the pure free-market position: "200 years of economic research shows protectionism always backfires." mikkupikku fires back: "You're just regurgitating old arguments which were once used to persuade Americans that outsourcing manufacturing to China was in America's best interest. Few Americans still find this persuasive." spwa4 provides the most quantitative take: "the average global wage is $24,000 in PPP... such a global system will be on average a 75% pay cut for US workers." The thread never resolves this because it's genuinely unresolvable — it's a values question about which workers' interests a democratic government should prioritize, not an empirical question about market efficiency.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| This was always about cost, not H-1B policy | **Strong** | Multiple first-hand accounts; article's own evidence supports it |
| "Talent shortage" is a salary shortage | **Strong** | Even the founder arguing quality (alephnerd) is really arguing price-for-quality |
| Offshoring will produce poor quality and reverse | **Medium** | Historical precedent is strong (JamesLeonis), but AI tooling and better remote infrastructure may break the pattern this time |
| Free markets demand free labor movement | **Weak as applied** | Ignores that companies benefit from non-market US inputs (legal system, infrastructure, contracts) while arbitraging labor markets |
| H-1B workers are exploited too | **Strong** | anonym29's structural argument is well-formed; skeledrew's rebuttal inadvertently confirms it |

### What the Thread Misses

- **The AI tooling wildcard.** The 2000s offshoring cycle reversed partly because coordination costs were too high and quality too low. AI coding assistants may dramatically reduce both — making this cycle's offshoring stickier than the last. Nobody connects the "AI is replacing programmers" thread to the "offshoring is back" thread, but they're the same labor supply expansion operating on different axes.

- **India's own wage inflation.** If FAANG is hiring 33K engineers/year in Bengaluru at AI/ML-level salaries, the cost arbitrage erodes quickly. Indian tech wages in Tier 1 cities have been rising 10-15% annually. The "cheap talent" window has a shelf life. The thread treats Indian labor costs as static.

- **The GCC model as the real story.** The article mentions that India hosts 2 million workers in Global Capability Centers — company-owned offshore units doing R&D, analytics, and strategic functions. This isn't outsourcing to Infosys; it's building parallel internal organizations. The GCC model means these jobs aren't coming back even if H-1B policy reverses, because the institutional knowledge will have shifted.

- **Second-order effects on Indian startups.** Only sharadov and AdamN touch this. FAANG hiring in India at premium wages (by local standards) will vacuum up the best talent, potentially *weakening* India's domestic startup ecosystem even while strengthening its employee class — the same dynamic that H-1B caused in reverse.

### Verdict

The thread gets the cynicism right but stops at "they were always going to offshore." The deeper story is that *three forces are converging simultaneously*: H-1B restrictions providing political cover, AI tooling reducing coordination costs of distributed teams, and GCC maturation making India offices genuinely capable of high-value work. Any one of these is reversible; all three together represent a structural shift. The irony the thread circles but never states: the same populist movement that restricted H-1B to "protect American jobs" has accelerated the one form of labor arbitrage that *can't* be controlled by immigration policy — and the AI tools that the same tech industry is building are the force multiplier that makes it work this time when it failed in 2003.
