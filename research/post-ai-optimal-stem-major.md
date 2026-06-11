← [CogSci Critique](cognitive-science-rigor-critique.md) · [Index](../README.md)

# What STEM Major Best Prepares You for the Post-AI Era?

> First-principles analysis using economics, technological evolution, and human nature as foundations.
> Consolidated from two earlier drafts. Corrects the reality-stack fallacy, survivorship bias, biology blind spot, judgment moat overestimation, and transition-period underweighting. Arrives at a defensible, actionable conclusion.

---

## 1. The Economic Engine: Commoditization Cascades

Every general-purpose technology follows the same pattern: **it commoditizes the current value layer and shifts value to the layer it can't reach.**

| Transition | What got commoditized | Where value moved |
|---|---|---|
| Agricultural → Industrial | Physical labor | Machine operation, organization design |
| Industrial → Information | Routine physical + cognitive processes | Software, services, information processing |
| Internet → Cloud | Distribution & infrastructure | Domain-specific applications, attention, data |
| **Information → AI** | **Cognitive execution** (writing, coding, analysis, pattern matching) | **???** |

History's answer is consistent: value moves to **judgment, framing, and operation in the domain the new technology can't reach.**

But this framework, while real, is incomplete in two ways:

**First, speed changes strategy.** Previous transitions took 50–100 years. AI disruption is playing out over years, not generations. The direction of value migration is predictable; the speed is not, and speed changes what you should optimize for. A 50-year transition lets you retrain mid-career. A 10-year transition doesn't.

**Second, GPTs create new categories, not just shifts.** The steam engine didn't just move value from muscles to machine operators — it created railroads, factories, and urbanization. The internet didn't just move value from distribution to applications — it created social networks, search, and the attention economy. **AI will create categories of valuable work that don't exist yet and that this analysis cannot predict.** Any framework that only asks "what existing domains survive?" is structurally incomplete. The best we can do is optimize for the ability to recognize and enter new categories quickly.

---

## 2. Two Independent Axes, Not One

Most analyses (including this paper's v1) collapse two distinct dimensions into one. They're independent, and the distinction is critical.

### Axis 1: Knowledge Half-Life (long ↔ short)

Some knowledge is permanent. Some depreciates.

| Long half-life (centuries) | Short half-life (years) |
|---|---|
| Calculus, linear algebra, probability | Specific programming languages (5–15 yr) |
| Newtonian mechanics, thermodynamics, E&M | Frameworks and tools (2–5 yr) |
| Evolution, central dogma, thermodynamics of living systems | Memorized domain facts |
| First-principles decomposition | Specific API knowledge |
| Systems architecture thinking | Routine analytical procedures |

### Axis 2: AI Vulnerability (execution ↔ judgment)

Some work is execution within a defined frame. Some is judgment about the frame itself.

**Execution** (AI does well and will do better): pattern matching, code generation from specs, optimization over defined objectives, standard analysis, textbook problem-solving, synthesis of known information.

**Judgment** (AI struggles with longer): choosing the right problem, operating on physical reality, decisions under genuine novelty with no historical data, accountability with consequences, navigating human systems, paradigm-shifting discovery.

### Why the distinction matters

These axes are **independent.** You can have:

- **Long half-life + execution** → Solving textbook differential equations. Knowledge is permanent, but AI does it. A physics undergrad grinding problem sets is here.
- **Long half-life + judgment** → Deciding which physical model applies to a novel system. Knowledge is permanent, AI can't do it. A senior engineer diagnosing an unprecedented failure mode is here.
- **Short half-life + execution** → Writing React components. Knowledge depreciates, AI does it. Most web developers are here.
- **Short half-life + judgment** → Choosing the right architecture for a novel distributed system given this week's tool landscape. Knowledge depreciates, but the judgment is real and current. A senior systems architect is here.

**The optimal training maximizes BOTH axes: long-half-life knowledge AND judgment capability.** Being at a "deeper layer of reality" (v1's thesis) only helps on Axis 1. It says nothing about Axis 2. A physics graduate solving textbook problems has durable knowledge but vulnerable skills. A CS architect making novel design trade-offs has less durable knowledge but more durable judgment.

---

## 3. The Judgment Moat Is Real but Narrower Than You Think

Both earlier drafts treated "judgment" as a stable, broad human advantage. This needs a stress test.

**AI is already performing routine judgment:**
- Medical diagnosis (matching or exceeding specialists on imaging, differential diagnosis)
- Risk assessment (credit scoring, fraud detection, insurance underwriting)
- Strategic recommendations (consulting-style analysis, market research synthesis)
- Code review and architectural suggestions
- Scientific hypothesis generation within known paradigms

These are judgment tasks. AI does them. The "AI can only execute, not judge" framing was approximately true in 2023. It's decreasingly true in 2026.

**What remains durably human is narrower than "judgment":**

1. **Judgment under genuine novelty** — situations with no historical analog, where the distribution itself is unknown (Knightian uncertainty). AI trained on past data structurally struggles here.
2. **Judgment with accountability** — someone signs the certification, takes the liability, goes to jail. This is structural (legal/regulatory), not capability-based. It persists even if AI is technically better.
3. **Judgment involving taste and values** — what *should* we optimize for? What's worth building? What's beautiful? These require choosing objectives, not optimizing given ones.
4. **Judgment about AI itself** — knowing when AI output is wrong, when the training distribution doesn't match the deployment context, when the model is confidently hallucinating. This is meta-judgment, and it requires deep domain expertise.

**Implication:** Training that develops only "I can reason formally" is insufficient. You need training that develops the ability to operate in genuinely novel situations, bear real consequences, exercise taste, and critically evaluate AI output in a specific domain. This is a more specific — and more useful — prescription than "develop judgment."

---

## 4. Where Capital Is Flowing

Follow the money. Where are the hard, economically massive, unsolved problems?

### Physical-world transformation (atoms, not bits)
- **Energy:** batteries, grid modernization, solar, fusion, nuclear, hydrogen — trillions in capital
- **Biotech/pharma:** drug discovery, gene therapy, synthetic biology, precision medicine, aging — the largest physical-world value creation opportunity of the coming decades
- **Advanced manufacturing:** semiconductors, materials science, additive manufacturing
- **Infrastructure:** everything is old and needs rebuilding
- **Robotics:** bridging AI and the physical world
- **Space:** launch, satellites, resource extraction

### AI infrastructure layer
- Alignment and safety, human-AI trust architecture
- Systems that deploy AI reliably at scale
- Evaluation, monitoring, and governance of AI systems

### Frontier science
- Novel materials, quantum computing, neuroscience, climate modeling
- AI accelerates within-paradigm discovery; humans still set agendas and recognize paradigm shifts

### Honest mapping of domains to workforce

| Sector | Primary workforce | Physics relevance |
|---|---|---|
| Energy transition | EE, ChemE, materials science | Indirect — foundations, not application |
| Biotech/pharma | Biology, chemistry, bioengineering, MDs | **Minimal** — you cannot derive pharmacology from the Hamiltonian |
| Semiconductors | EE, materials science, ChemE | Moderate |
| Robotics | EE, MechE, CS (controls/perception) | Indirect |
| Infrastructure | Civil, MechE | Minimal |
| AI systems | CS, applied math, EE (signals/ML) | Indirect |
| Fusion/nuclear | Physics directly | High |

Physics is *adjacent* to most high-value sectors but *directly optimal* for almost none of them. The "universal adapter" narrative is real but carries a hidden retraining cost and career-entry delay. This delay matters more than v1 acknowledged — see Section 6.

**The biology blind spot.** The single largest physical-world value creation opportunity — biotech, CRISPR, mRNA platforms, synthetic biology, aging research — is fundamentally *biology*. Biology has its own irreducible first principles (evolution, the central dogma, thermodynamic constraints on living systems, ecological dynamics) that are genuine foundations, not stamp-collecting. You cannot derive the Krebs cycle from quantum mechanics. Emergent complexity is real, not a failure of reductionism.

---

## 5. What Actually Develops the Skills That Matter?

The durable human advantage is: judgment under novelty, with accountability, in a specific domain, augmented by AI tools. What *training* develops this?

### The ingredients

1. **Formal reasoning depth** — so you can evaluate whether a solution is solving the right problem. Math through at least: multivariable calculus, linear algebra, differential equations, probability/statistics. Ideally: real analysis or abstract algebra. This is the compounding engine.

2. **Deep expertise in at least one domain** — so you know what real mastery feels like and can evaluate AI output critically. By graduation, you should look at AI output in your domain and know when it's wrong without being told. That's judgment. It takes years.

3. **Physical-world fluency** — so you operate where AI is weakest and capital is flowing. Lab work, manufacturing, field experience, building things with atoms.

4. **Serious computational fluency** — not "Python basics" (that's "can use a calculator" in 2026), but genuine systems thinking: how to decompose problems for AI agents, evaluate outputs, build reliable pipelines, architect human-AI workflows. This is a **core competency**, not an accessory. Minor in CS, 4–6 serious CS courses, or equivalent sustained project work.

5. **Learning velocity** — the ability to rapidly acquire new domain knowledge. In a world of rapid disruption, this may be the single most important meta-skill. It's developed through: exposure to multiple domains, practice learning under time pressure, and deep enough foundations that new knowledge has existing structure to attach to.

6. **Breadth of exposure** — problem-framing is fundamentally cross-domain. The best problem-framers (Darwin, Shannon, the Wright brothers) were polymaths — depth plus breadth. Taste develops through confronting many different types of problems with real stakes.

### The critical question: what kind of training ACTUALLY delivers judgment?

Not coursework alone. **Judgment develops through exposure to real problems with real consequences and real feedback loops.** This means:

- Research experience (even undergraduate) where you face genuinely open questions
- Internships and co-ops where your work has consequences
- Projects where you build things that have to actually work (not just pass a grader)
- Years of experience in a domain, accumulating pattern recognition about what matters

This has a profound implication for major selection: **a major that gets you into real-stakes work earlier may develop judgment faster than a major with deeper theoretical foundations but slower career entry.** Two years of real-world problem-solving builds more judgment than two years of additional coursework. This is not anti-intellectual — it's recognizing that judgment is a skill of practice, not a skill of study.

---

## 6. The Timeline Problem: Why It's Not a Footnote

This is the most underweighted variable in most analyses, including v2. Let me make the case for why it might be *the* most important consideration.

**The transition period (2025–2045)** is when most current students will build their careers, develop their networks, establish their reputations, and compound their judgment through experience. The "equilibrium" (2050+) is what they'll face in their late career.

**For the transition period:**
- Computational depth is at peak leverage — understanding the AI tools reshaping everything gives a massive multiplier
- Career entry speed matters — getting started 2–3 years earlier compounds: you build judgment, network, and reputation during the period of maximum disruption
- The sectors absorbing talent *right now* have specific skill demands; generalized physics training requires additional specialization to enter any of them
- Adaptability matters — CS-style training, where you constantly learn new tools and paradigms, may develop adaptation muscles that physics-style "master timeless fundamentals" training does not

**For the equilibrium (20+ years out):**
- Mathematical depth and physical intuition compound over a full career
- Domain-specific tools churn; foundations don't
- Physical-world fluency becomes increasingly valuable as AI penetrates more digital work

**The strategic tension:** If you optimize for the equilibrium, you may not survive the transition. A beautiful theoretical foundation doesn't help if you can't get hired for 3 years after graduation. But if you optimize for the transition, you may be caught flat-footed when the equilibrium arrives and your rapidly-acquired skills have depreciated.

**Resolution:** The training that resolves this tension is one that provides *enough* formal depth for long-term compounding *and* enough practical applicability for immediate career entry. This is a Pareto optimization, not a single-axis maximization. It's why "physics is the best major" (v1's conclusion) is overfit — physics maximizes one axis at the expense of the other. The engineering disciplines (EE, MechE, ChemE) sit closer to the Pareto frontier.

---

## 7. Human Nature: Structural Demand for Human Agents

This dimension holds up best under scrutiny because it's about institutional and psychological structures, not capability comparisons that AI can erode.

1. **Trust with consequences.** People want a human doctor who takes liability, a human engineer who signs the structural certification. Trust requires skin in the game — a body, a reputation, something to lose. This is institutional, legal, and psychological. It persists even if AI is technically better at the task.

2. **Meaning and status.** Humans pay premium for human-made, human-judged, human-curated output. This "artisanal" instinct *increases* as AI-generated content floods every channel. Human judgment becomes a scarce signal in a world of infinite AI noise.

3. **Physical presence.** No AI builds a bridge, performs surgery, fixes a power grid. The physical world requires physical agents. For decades, those will be humans augmented by machines, not machines alone. (The robotics timeline is compressing — Boston Dynamics, Figure, Tesla Optimus — but novel physical situations in unstructured environments remain far from solved.)

4. **Accountability.** Governance, regulation, liability require human agents. When cascading AI failures cause real harm, someone human must diagnose, decide, and answer for it.

All four favor training that combines formal depth with physical-world fluency and domain expertise. They don't uniquely favor any single major — they favor the *profile.*

---

## 8. Correcting Common Analytical Errors

### Error 1: The Reality-Stack Fallacy (v1)

V1 argued AI commoditizes "top-down" through a reality stack (social sciences → CS → biology → chemistry → physics → math), so being at the "bottom" is safest.

**Wrong.** AI attacks execution at ALL layers simultaneously. AlphaProof does mathematical reasoning. GNoME discovers 2.2M crystal structures. AlphaFold solves protein folding. AI doesn't eat reality top-down — it automates *execution* at every layer while leaving *judgment* at every layer. The durable advantage is judgment at whatever layer you operate, not sitting at a "deeper" layer.

The grain of truth: lower-layer knowledge has longer half-lives (Axis 1). The Schrödinger equation won't change; the React framework will. But long half-life ≠ AI-proof. Solving the Schrödinger equation for known potentials is long-half-life *execution* — and AI does it.

### Error 2: Survivorship Bias in Physics Data (v1)

V1 cited physics graduates' GRE/LSAT/MCAT scores and career optionality as evidence that physics training is superior. This conflates selection effects with training effects. Physics attracts and retains — through a brutal curriculum — students pre-selected for raw cognitive horsepower. Would those same students have performed equally well with a math, EE, or CS degree? Almost certainly.

The proper test (two students of identical aptitude, different majors, compared over a career) doesn't exist. The GRE data tells you smart people choose physics. It doesn't tell you physics makes people smarter.

**Corrected claim:** Physics is one of several rigorous STEM majors that develops strong formal reasoning. Its distinctive advantage is the *combination* of mathematical depth with physical intuition — real, but not as large as naive cross-major comparisons imply.

### Error 3: Underrating Biology (v1)

V1 gave biology ★★ for first-principles thinking, reflecting a bias equating "first-principles" with "mathematical formalism." Evolution, the central dogma, thermodynamic constraints on living systems, ecological dynamics — these are genuine first principles with enormous explanatory power. The biotech sector is likely the single largest physical-world value creation opportunity of the coming decades. Ignoring biology because it's "less mathematical" is a serious analytical failure.

### Error 4: Overestimating the Judgment Moat (v2)

Addressed in Section 3. The moat is real but narrower than "all judgment." It's specifically: judgment under genuine novelty + accountability + taste/values + meta-judgment about AI. Training should target these specifically, not just "develop judgment" generically.

### Error 5: Treating "Major" as the Primary Variable

Companies hire for roles and demonstrated skills, not majors. The major is a signal and a training path, not a destiny. Two physics graduates with different research experiences, internships, and side projects will have radically different career outcomes. The major choice matters for the first 5 years of career, decreasingly thereafter. What matters more: the *profile* you assemble across coursework, research, projects, and internships.

---

## 9. The Scorecard

### Criteria

1. **Math depth** — formal reasoning that compounds across decades
2. **Physical-world fluency** — operating where AI is weakest and capital is flowing
3. **Computational fluency** — using AI as genuine amplification (systems thinking, not just scripting)
4. **First-principles / judgment development** — rated for the *median graduate*, not the ceiling
5. **Domain depth** — real expertise where you can evaluate AI output critically
6. **Career entry** — ability to start building real-world judgment early

| Major | Math | Physical | Compute | Judgment | Domain | Entry | Post-AI durability |
|---|---|---|---|---|---|---|---|
| **EE (modern)** | ★★★★ | ★★★★★ | ★★★★ | ★★★★ | ★★★★★ | ★★★★ | **Highest** |
| **Physics + CS depth** | ★★★★★ | ★★★★★ | ★★★★ | ★★★★ | ★★★★ | ★★★ | **Highest** (requires supplement) |
| **CS (systems/AI depth)** | ★★★ | ★ | ★★★★★ | ★★★★ | ★★★★ | ★★★★★ | **High** |
| **MechE** | ★★★★ | ★★★★★ | ★★★ | ★★★★ | ★★★★ | ★★★★ | **High** |
| **ChemE** | ★★★★ | ★★★★★ | ★★★ | ★★★★ | ★★★★★ | ★★★★ | **High** |
| **Physics (pure BS)** | ★★★★★ | ★★★★★ | ★★★ | ★★★ | ★★★★ | ★★ | High (entry friction) |
| **Applied Math** | ★★★★★ | ★★ | ★★★ | ★★★★★ | ★★ | ★★★ | High (needs domain) |
| **Comp. Biology** | ★★★ | ★★★★ | ★★★★ | ★★★ | ★★★★★ | ★★★★ | High (sector tailwind) |
| **CS (general/web)** | ★★★ | ★ | ★★★★★ | ★★ | ★★★ | ★★★★★ | **Medium** (execution-layer risk) |
| **Biology** | ★★ | ★★★★ | ★★ | ★★★ | ★★★★ | ★★★ | Medium |
| **CogSci (ML track)** | ★★★ | ★ | ★★★★ | ★★★ | ★★★ | ★★★ | Medium |
| **CogSci (general BA)** | ★★ | ★ | ★★ | ★★ | ★★ | ★★ | Low |

### Key rating decisions

- **Physics pure BS judgment at ★3, not ★5.** Undergraduate physics develops formal problem-solving on well-defined problems. The deep judgment skill ("which simplifications are safe?" "which model applies to this unprecedented situation?") develops primarily through *research experience*, not coursework. Most BS graduates don't reach that level. Rate the median graduate, not the ceiling.
- **Physics + CS depth at ★4 judgment.** The supplement forces more real-world problem-solving and project work, developing judgment faster than pure coursework.
- **EE at ★4 judgment.** Lab-heavy, project-heavy curriculum with tighter feedback loops between theory and practice. Develops practical judgment earlier.
- **MechE computation upgraded to ★3.** Modern MechE involves significant simulation, CAD, and increasingly ML — not the ★2 from v2.
- **CS split into two tracks.** Systems/AI depth (understanding the tool reshaping everything) vs. general/web (building things the tool increasingly builds itself). The gap is real and widening.
- **"Highest" tier requires combination.** No single pure major achieves top marks on all axes. EE comes closest because it inherently sits at the physical-digital interface.

---

## 10. Game Theory: What Everyone Else Does

Individual optimal strategy depends on collective behavior. Basic labor economics.

If everyone follows "study CS" → CS graduates become oversupplied → their wages drop relative to scarcer skills. If "CS is dying" narrative spreads → CS enrollment drops → remaining CS graduates become scarcer and more valuable.

**Current state (2026):** CS enrollment is at record highs. Physics, EE, ChemE, MechE enrollment is relatively low. The contrarian signal — studying something rigorous but unfashionable — provides market positioning value independent of the subject matter.

**Structural point:** The specific ranking in Section 9 matters less than whether you go genuinely deep in something rigorous while assembling the complete profile. If everyone zigs toward AI/CS, there's real value in zagging toward physical-world disciplines — *especially* if you supplement with computational depth that CS-native students take for granted.

---

## 11. The Synthesis

### The core insight

**The post-AI era rewards a profile, not a pedigree.** The analysis converges on six properties that matter, and multiple majors can anchor them:

1. **Formal reasoning depth** that compounds over decades (math through DiffEq + LinAlg + Prob/Stats minimum; ideally real analysis)
2. **Physical-world fluency** where AI is weakest and capital is flowing
3. **Serious computational fluency** — systems thinking, model evaluation, AI-augmented workflow design (not just scripting)
4. **One domain of genuine depth** — real expertise where you have judgment AI lacks
5. **Learning velocity and breadth** — exposure to multiple domains, ability to rapidly acquire new knowledge
6. **Early entry into real-stakes work** — judgment compounds only through experience with consequences

### Tiered assessment

**Tier 1 — Strongest post-AI positioning:**

- **EE (modern: embedded ML, robotics, energy, signals/controls)** — Sits exactly at the physical-digital interface. Math, physical intuition, computation, and a concrete domain — all in one major. Reasonable career entry. The dark horse that deserves to be the frontrunner. The modern EE grad focused on autonomous systems, energy systems, or embedded AI is the single best-positioned STEM graduate.

- **Physics + serious computational supplement** — Deepest formal foundations plus physical intuition. Powerful *combination*, but the pure physics BS without computational depth and domain specialization faces real career-entry friction. This path works best for students headed toward graduate school, research, or who aggressively self-supplement with CS and research experience. Without the supplement, drops to Tier 2 due to entry friction.

- **CS with depth (systems architecture, AI/ML internals, distributed systems, hardware)** — Understanding the technology reshaping everything is a massive advantage during the transition period. The skill is shifting from "I can write code" (commodity) to "I understand the system reshaping everything" (strategic). Enormous transition-period leverage. Long-term risk is real but manageable if you build domain depth alongside.

**Tier 2 — Strong with tailwinds:**

- **MechE, ChemE** — Operate directly on physical reality with serious mathematical foundations. Underrated because everyone is distracted by software. ChemE maps to energy transition and materials — massive capital flows. MechE maps to robotics, manufacturing, infrastructure.

- **Computational biology / bioengineering** — The largest physical-world value creation sector (biotech) needs people combining biological domain knowledge with computational tools. Strong 20+ year sector tailwind. Narrower bet than Tier 1 options but high expected value if the biotech thesis plays out (it probably does).

- **Applied Math + aggressive domain specialization** — Physics-tier formal reasoning. But pure applied math without a domain is a tool without a workbench — you can solve equations but don't know which equations matter. Must be combined with sustained research or project work in a specific physical-world domain.

**Tier 3 — Viable, needs supplementation:**

- **Biology** — Increasingly important domain (biotech tailwind) but insufficient formal and computational depth on its own. Strongest when combined with quantitative/computational focus.
- **CS (general/application-focused)** — Still employable, still in demand, but the middle-80% CS grad building standard web apps is among the most AI-vulnerable positions in STEM. The execution layer is being commoditized by the tools CS built.
- **CogSci (ML track)** — Legitimate quantitative training + domain expertise in human cognition. Relevant to human-AI interface. But narrow market.

**Tier 4 — Insufficient on its own:**

- **CogSci (general BA)** — Mostly soft science with computational garnish. The claimed advantage of "interdisciplinary synthesis" is exactly what LLMs do at machine speed. Needs hard supplementation.

### The non-negotiable checklist (regardless of major)

1. **Math:** Multivariable calculus, linear algebra, differential equations, probability and statistics. Minimum. Ideally: one proof-based course (real analysis, abstract algebra).
2. **Computation:** Can architect a system, critically evaluate AI output, build data pipelines, understand ML well enough to know when it's failing. 4–6 serious CS courses or equivalent project work. Not optional.
3. **Physical-world exposure:** Research in a lab, internship in manufacturing/energy/biotech, hands-on engineering project. This is where capital flows and AI is weakest.
4. **Domain depth:** By graduation, you can look at AI output in your domain and know when it's wrong without being told. That's judgment. It takes years.
5. **Breadth:** Courses outside your discipline. Reading widely. The problem-framing skill requires exposure to many frames.
6. **Real stakes early:** Undergraduate research, co-ops, internships, projects that ship. Don't wait for the credential to start building judgment.

### The asymmetry to exploit (revised)

Physics and math are harder to self-teach than programming. This is the v1 insight and it's real. But v1 underestimated the *depth* of computational skill needed. "Python basics" in 2026 is table stakes. Effective AI-augmented work requires genuine systems thinking about computation — decomposing problems for AI agents, evaluating outputs, building reliable pipelines, architecting human-AI workflows.

**Revised prescription:** Major in something with deep formal and physical-world foundations (physics, EE, MechE, ChemE) AND invest serious effort in computational depth (minor + sustained projects). Or: major in CS with genuine depth AND invest serious effort in physical-world domain exposure through research and internships.

Both paths work. Neither works halfway. **The worst move is optimizing along a single axis** — pure theory without computation, pure coding without physical intuition, pure breadth without any depth.

---

## 12. What Could Make This Analysis Wrong

Intellectual honesty requires stating the conditions under which the entire framework fails.

**Scenario 1: AGI arrives fast (5–10 years) and commoditizes ALL human cognitive work.** If AI achieves human-level general intelligence and the physical-world robotics problem is solved simultaneously, then no STEM training provides durable advantage. The analysis assumes AI capabilities plateau or progress slowly in key areas. If that assumption fails, nothing here matters. *Probability: low but non-trivial. Hedge: the physical-world and accountability advantages are the last to fall even in this scenario.*

**Scenario 2: The transition period is much shorter than assumed.** If AI disruption compresses into 5 years rather than 20, the "optimize for transition" argument weakens — everyone will need to adapt fast regardless of training. The formal-foundations advantage reasserts because those with deeper reasoning can adapt faster. *Probability: moderate. Hedge: this makes the non-negotiable math/foundations checklist even more important.*

**Scenario 3: New categories of valuable work emerge that don't map to current disciplines.** Previous GPTs created entirely new job categories. AI will too. If the biggest value creation happens in a domain that doesn't yet exist, then optimizing for any current domain is the wrong strategy. The right strategy is maximizing learning velocity and adaptability. *Probability: high — this will definitely happen. Hedge: the profile (formal depth + breadth + learning velocity) is optimized for this scenario.*

**Scenario 4: Credentials become irrelevant.** If AI makes knowledge acquisition so easy that anyone can learn anything, the major choice becomes purely about signaling and network effects, not about training. *Probability: partially true already and increasing. Hedge: this strengthens the "profile not pedigree" conclusion — what you can demonstrate matters more than what you studied.*

**Scenario 5: Physical-world automation advances faster than expected.** The "atoms are harder than bits" argument has been made about every task AI eventually conquered (chess, Go, protein folding). If humanoid robotics and autonomous manufacturing reach human-level competence in 10–15 years, the physical-world moat narrows dramatically. *Probability: moderate for routine physical work, low for novel unstructured physical situations. Hedge: the advantage is in novel physical situations, not routine ones.*

---

## The One-Paragraph Summary

The post-AI era rewards a profile, not a major: formal reasoning depth that compounds over decades, physical-world fluency where AI is weakest and capital is flowing, serious computational fluency to use AI as genuine amplification, one domain of real expertise where you have judgment AI lacks, and early entry into real-stakes work where judgment actually develops. EE (modern focus), physics with computational supplement, and deep-track CS are the strongest anchors for this profile. The major matters less than whether you assemble the complete package — and the worst strategic error is maximizing along a single axis while neglecting the others.

---

*Consolidated analysis: June 2026. First-principles reasoning corrected for survivorship bias, reality-stack fallacy, judgment moat overestimation, biology blind spot, timeline dynamics, and single-axis optimization. Supersedes v1 and v2.*
