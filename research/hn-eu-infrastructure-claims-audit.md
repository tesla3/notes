← [Index](../README.md)

## Critical Claims Audit: "I tried building my startup entirely on European infrastructure"

**Source thread:** https://news.ycombinator.com/item?id=47085483 (631pts, 321 comments, Feb 2026)
**Companion distillation:** [hn-eu-infrastructure-startup.md](hn-eu-infrastructure-startup.md)
**Deep elaboration on key claims:** [hn-eu-infrastructure-three-claims-deep.md](hn-eu-infrastructure-three-claims-deep.md)

This document examines every substantive claim from the original article and high-signal comments for validity, logical coherence, and practical value. Organized from article claims first, then thread claims.

---

## Part 1: Article Claims

### Claim 1: "The pricing is almost absurdly good compared to AWS, and the performance is solid."

**Verdict: Mostly valid, but meaningfully incomplete.**

The raw compute price comparison is real — nobody in the thread disputes it, and one commenter (thecopy) reports "a third of the running costs and ~50x resources" vs. GCP GKE. Another (apexalpha) gets a dedicated Ryzen 5 / 64GB for €35/mo, which is indeed absurd vs. AWS equivalents.

But this comparison commits the **fallacy of excluded middle costs**. Hetzner pricing is cheap *because they externalize operational complexity to the customer*. No managed databases, no auto-scaling groups, no integrated monitoring, no SLA with teeth. BoorishBears nails this: "paying AWS $200 a month for $20 a month worth of compute" is the real pricing model — you're buying operational insurance, not just CPU cycles. mkzet adds: "extremely demanding to run production workloads there without a dedicated infra guy."

The article never quantifies the author's *time* cost. Self-hosting Gitea, Plausible, CRM, secrets management, error tracking, K8s with Rancher — that's easily 10-20 hours/month of maintenance for a solo founder. At any reasonable hourly rate for a technical founder, the "savings" evaporate. The article says "Is self-hosting more work than SaaS? Obviously" but never connects this back to the cost comparison it opened with, which is intellectually dishonest framing.

**Value:** High for someone aware of the trade-off. Misleading if taken at face value by someone who thinks "cheaper" means "better deal."

---

### Claim 2: "Bunny.net is the unsung hero of this stack."

**Verdict: Credible but under-scrutinized.**

Multiple commenters validate Bunny.net: good DX, fast support, cheap. sreekanth850 uses it for geo DNS load balancing on websocket infra. Daegalus calls it "flawless."

However, two signals suggest limits the article ignores:

1. **throwaway772549** reports Bunny blocked their account after repeated (proven-false) DMCA complaints. This is a serious operational risk for any business in a competitive niche. The article's "unsung hero" framing obscures that Bunny is a small company that may not have the legal sophistication to resist abuse complaints.

2. **r_lee** claims Bunny "runs on Hetzner and random hosts or their colo, it's not as proper as the other ones." If true, this means the "EU sovereignty" story has a turtles-all-the-way-down problem — your CDN runs on infra you can't fully audit. Not verified, but worth noting.

The IPv6 limitation (can't route IPv4→IPv6 origin) flagged by Daegalus is a real technical gap vs. Cloudflare.

**Value:** Reasonable recommendation for small-to-mid projects. Not battle-tested for adversarial environments.

---

### Claim 3: "Removing social logins entirely is a conversion killer."

**Verdict: Directionally correct, but the "killer" framing is overstated and lacks the author's own data.**

The author presents this as settled fact but provides zero data from their own product. It's stated as industry wisdom, not measured reality.

zbentley's municipal service anecdote is the thread's strongest evidence: users preferred *paying a fine* over completing a signup form, and adding SSO tripled net signups. This is compelling — but it's one anecdote about a low-motivation government service, not a SaaS product someone actively sought out. The generalization from "municipal compliance form" to "car parts marketplace" is a significant leap. Motivation context matters enormously: people who arrive at hank.parts via search for a specific car part have higher intent than someone facing a generic municipal obligation.

The thread also surfaces a logical counter-point that nobody synthesizes: **the "conversion killer" framing conflates preference with dealbreaker**. bdcravens is precise: "each tiny bit of friction increases the possibility of abandonment." That's marginal conversion rate impact, not a binary kill. The author escalates "proven conversion booster" (which is well-documented) to "removing it is a killer" (which implies catastrophic loss), and nobody calls out this rhetorical inflation.

apublicfrog provides a valuable control: "None of my businesses use a 'sign in with...' option and I highly doubt it would increase conversions." Industry-dependent, not universal law.

**Logical issue:** The claim also serves a convenient rhetorical function in the article — it lets the author frame US dependency as *unavoidable* rather than as a trade-off they chose not to make. "Conversion killer" forecloses debate; "costs us 5-15% of signups" invites cost-benefit analysis.

**Value:** Real signal that SSO matters for consumer apps. Overweighted as a universal truth.

---

### Claim 4: "Transactional email... the EU options exist, but finding one that matches on deliverability, pricing, and developer experience took real effort."

**Verdict: Valid and well-corroborated.**

This is one of the article's strongest claims. The thread confirms it from multiple angles:
- mcbetz identifies the gap extends further into marketing/newsletter email at scale (20M+/month).
- zelphirkalt reports Mistral-grade reliability problems (timeouts) with Scaleway's TEM.
- The author's own experience: shared IP deliverability issues, had to move to dedicated IP.
- Lettermint (NL) and MailerSend get positive mentions but with short track records.

No commenter disputes this claim or names an EU provider that fully matches Sendgrid/Postmark DX. This absence of counter-evidence is itself strong signal.

**One nuance the article misses:** "developer experience" and "community knowledge" are partially circular problems. US providers have better DX because they have more users, which generates more SO answers and integrations, which improves DX. This is a network effect, not an inherent quality gap. The EU providers could close this gap with adoption — but someone has to go first and eat the cost. The author did, which is genuinely valuable.

**Value:** High. Probably the most actionable finding in the article.

---

### Claim 5: "Certain TLDs cost significantly more when purchased through European registrars. I'm talking 2-3x markups."

**Verdict: Partially valid, partially self-inflicted.**

LeonidasXIV fact-checks this in real time: .party is $21.09 at Porkbun vs. €32.80 at INWX. That's ~1.5x, not 2-3x. The author then reveals they're paying "in the 50s" — which is 2x+ but likely reflects a bad registrar choice, not a structural EU problem. The author's own reaction ("Wow, gotta check out INWX") reveals they didn't shop around thoroughly.

The "2-3x" framing also ignores that Porkbun shows prices without VAT while EU registrars include it. After VAT adjustment, the gap narrows further. This isn't a conspiracy — it's tax regime differences.

psychoslave raises the deeper structural point: ICANN governance is US-centric, and wholesale TLD pricing *may* disadvantage non-US registrars. But nobody provides evidence for this mechanism beyond assertion.

wolfhumble makes the most incisive point the article misses entirely: for .com domains, **the registrar's location is irrelevant to sovereignty** because .com is under US jurisdiction regardless. Moving your .com from Porkbun to INWX changes nothing about who controls the TLD. The sovereignty value only exists for ccTLDs like .de, .fr, .eu.

**Value:** Low. The core finding is "I didn't shop around well" dressed up as "EU registrars are expensive."

---

### Claim 6: "If you want Claude, and I very much want Claude, that's Anthropic, that's the US."

**Verdict: Factually correct, but the framing conceals a choice.**

Yes, Claude is US-based. But the article presents this as an immovable constraint while simultaneously choosing not to evaluate EU alternatives seriously. The thread exposes this:
- zelphirkalt reports Mistral API has serious reliability problems (timeouts).
- dwedge calls Mistral "openoffice to word 20 years ago."
- The author used Nebius for inference, which can run open-weight models.

The honest framing would be: "I want frontier-quality AI and I'm not willing to compromise on quality for sovereignty here." That's a legitimate choice. But it undermines the article's thesis — if you make exceptions wherever quality matters, "Made in EU" becomes "Made in EU where it's easy." The author acknowledges this to their credit, but the "can't avoid" framing is still misleading. You *can* avoid it; you *choose* not to. Those are different things.

**Self-contradiction:** The article was itself written with Claude (confirmed by the author in comments). An article about EU sovereignty was produced using US AI infrastructure. This is a fair irony, not a gotcha — but it does illustrate the depth of the dependency.

**Value:** Moderate. Correctly identifies the frontier AI gap. Incorrectly frames it as a hard constraint rather than a quality/sovereignty trade-off.

---

### Claim 7: "My data residency story is clean."

**Verdict: Dubious by the article's own admissions.**

The article lists three categories of unavoidable US dependency: Google/Apple auth, App Store distribution, and AI APIs. Each of these involves sending user data or business-critical data to US servers. "Clean data residency" while routing every user authentication through Google OAuth is... not clean. It's "cleaner than full AWS" but presenting it as "clean" is **moving the goalposts**.

raffkede catches another gap: the blog itself wasn't EU-compliant (no ownership info), which the author quickly fixed. This suggests the compliance surface area is larger than the article's infrastructure focus acknowledges.

The deeper problem: the article conflates *server location* with *data sovereignty*. As s_dev points out regarding AWS European Sovereign Cloud: "US CLOUD Act directly conflicts with EU's GDPR. If these two conflict Amazon will side with the US." This legal analysis applies in reverse too — even with EU servers, if your auth flows, app distribution, and AI APIs transit US infrastructure, data sovereignty is partial at best.

**Value:** The article's claim isn't false, just marketing-grade rather than legal-grade.

---

### Claim 8: "The EU has real infrastructure companies building serious products. They deserve the traffic."

**Verdict: This is values framing, not an argument.**

"Deserve" is doing heavy lifting here. Infrastructure providers deserve traffic to the extent their products are good, not because of where they're located. The article's actual evidence — Hetzner is cheap, Bunny is good, Scaleway works — supports "EU providers are competitive" which is a much stronger claim than "they deserve it."

piokoch raises the uncomfortable counter: "All of those considerations are driven by politics, not technical matters. What if in Germany next election will be won by AfD?" The sovereignty argument cuts both ways — you're not just betting on EU infra, you're betting on EU political stability.

mgol94's response ("Data sovereignty... is not political, it's logical choice") is itself doing political work. Choosing your infrastructure providers based on their country of incorporation is definitionally a political choice, even if it has logical justifications.

**Value:** Low as an argument. Fine as a stated preference.

---

## Part 2: High-Signal Thread Claims

### Claim 9 (znnajdla): "Managed databases are a scam... Just buy a few Mac Studios and run them in-house."

**Verdict: Provocative, irresponsible as advice.**

This is the thread's most detailed contrarian argument and it fails on multiple levels:

**Factual problems:**
- "The setup I described isn't fully in production yet" — admitted under questioning. The entire cost comparison is based on testing, not operational reality.
- MinIO is recommended as core storage, but it was deprecated/relicensed weeks before this thread. The commenter apparently didn't know.
- "Claude Opus-level performance (Kimi K2.5) over a cluster of Mac Studios with Exo.Labs" — when asked if they actually use Exo, the answer is "No not yet. Planning to." So the AI inference claim is also aspirational, not proven.
- Networking redundancy plan: "Got lucky that we have a good personal relationship with our small local ISP." This is not a redundancy plan. This is hope.

**ekidd's counter** is the best comment in the entire thread: "The fundamental problem of self-hosted databases is that you test the happy path every day, but you only test true disaster recovery every 5-10 years. And in practice, this means that disaster recovery will usually fail." This is a genuine structural insight about operational epistemology, not just an anecdote.

znnajdla's response — "I test my backup recovery several times a month by actually baking into our CI/CD workflow" — is admirable if true, but represents extreme selection bias. The advice is targeted at general readers who will *not* do this.

**The "scam" framing** is a **false equivalence fallacy**. A managed database charges you for operational insurance (DR, monitoring, patching, scaling). Calling insurance a "scam" because you personally haven't had a disaster is the same logic as calling health insurance a scam because you haven't been sick.

**Sovereignty angle:** petcat lands the sharpest punch: "I fail to see the point of this when the system you've decided to run 'yourself' is entirely owned and dependent on *another* American company." Running macOS servers for EU sovereignty is genuinely incoherent. The commenter's defense ("I'm not anti American") confirms this was never really about sovereignty — it's about cost and control. Fair enough, but then it doesn't belong in this thread.

**Value:** Interesting as a thought experiment. Dangerous as actionable advice. The 50K EUR one-time vs. 25K EUR/month comparison is apples-to-oranges unless you honestly account for your own time, the opportunity cost of that time, and the actual operational risks.

---

### Claim 10 (setgree): "The author spent their innovation tokens on a political commitment."

**Verdict: Clever framing, but misapplies the framework.**

The "Choose Boring Technology" framework is about *technical* novelty risk — choosing MongoDB when Postgres would work, etc. Using Hetzner instead of AWS is not technically novel; Hetzner has existed since 1997 and runs standard Linux VMs. The "innovation" here is operational (less community knowledge, fewer integrations), not technological.

vanschelven's rebuttal is sharp: "The more boring your tech stack, the easier it is to host it anywhere (including Europe). So choosing boring tech is actually an enabler of this choice." If your app is a boring Postgres + Rails/Django monolith, moving it between hosting providers is trivial. The "innovation token" cost is highest precisely when you've coupled yourself to AWS-specific services (Lambda, DynamoDB, SQS) — which is the *opposite* of boring technology.

However, setgree's underlying point survives the rebuttal for the *email and auth* cases specifically. Choosing Scaleway TEM over Sendgrid *is* spending an innovation token — you're accepting worse DX, fewer integrations, and thinner community knowledge. Same for self-hosting Gitea over GitHub. The framework applies selectively, not globally.

**Value:** Moderate. Good heuristic, misapplied to compute but valid for ecosystem services.

---

### Claim 11 (stackbutterflow): "Running entirely on non-American services will never happen."

**Verdict: Demonstrably false by historical precedent, but emotionally resonant.**

deaux's sarcasm is the definitive rebuttal: "It took absolute *trillions* of Euros for 'Sign in with VK' to become a common option in Russia." China, Russia, Japan, South Korea — all have substantially independent digital ecosystems. They didn't require trillions of investment; they required either regulation (China/Russia) or organic market development (Japan/Korea's LINE, Naver, etc.).

The claim also contains a **nirvana fallacy**: defining success as "zero American dependencies" and then declaring it impossible. Nobody in the article claims or needs 100% purity. The actual goal — reducing US dependency to a manageable risk surface — is demonstrably achievable, as the article itself shows.

stackbutterflow's framing also **confuses incumbent advantage with impossibility**. Google/Apple sign-in dominance is a network effect, not a law of physics. Network effects can and do break, usually through regulatory intervention or platform shifts.

**Value:** Low. The "never" framing is the kind of absolutism that makes for punchy comments but bad analysis.

---

### Claim 12 (s_dev): "Zero chance the data stays in the EU [on AWS European Sovereign Cloud]. US CLOUD Act directly conflicts with EU's GDPR."

**Verdict: Legally sophisticated but overstated as certainty.**

The CLOUD Act vs. GDPR tension is real and unresolved. The legal theory is sound: a US-headquartered company can be compelled under the CLOUD Act to produce data stored abroad. AWS's European Sovereign Cloud is structured to resist this (operated by an EU subsidiary, EU staff only), but it's untested in court.

However, "zero chance" is overstatement. The AWS China model (operated by Sinnet/NWCD as genuinely separate entities) has held up for years. The EU version may be less robust (bdcravens notes it's a "walled-off subsidiary" not a third-party licensee), but "zero chance" implies certainty about a legal question that doesn't have settled case law.

The more precise claim: "Relying on legal architecture controlled by a US parent company to resist legal demands from the US government is a bet, not a guarantee." That's valid and important.

**Value:** High. The underlying concern is one of the strongest practical arguments for EU-native infrastructure. The certainty of the framing undermines the credibility of the argument.

---

### Claim 13 (gethly): "Europe has orders of magnitude more developed IT infrastructure than USA."

**Verdict: Misleading at best.**

"For every one VPS provider in North America, Europe has 10" — this may be true by raw count of small hosting providers. But counting VPS companies is like counting restaurants: having 10 mediocre options is not better than having 3 excellent ones if the excellent ones serve your needs.

The claim that "nothing is missing" is contradicted by the *entire rest of the thread*, which extensively discusses missing or inferior EU alternatives for: transactional email, marketing email, social auth, frontier AI, managed databases, observability, and payments.

"Asia is actually quite a joke" is simply wrong. Japan, South Korea, Singapore, and Hong Kong have world-class datacenter infrastructure. Alibaba Cloud, NTT, and NHN Cloud are serious providers.

**Value:** Zero. This is EU cheerleading, not analysis.

---

### Claim 14 (kkfx): "Sovereignty means you own the stack not that you just choose other suppliers."

**Verdict: Definitionally correct, operationally useless.**

If sovereignty requires owning physical servers, fiber, power generation, and the full hardware supply chain, then *nobody* has sovereignty — not even nation-states (as bob1029 points out: "Who makes the photolithography machines?").

bdcravens offers the pragmatic reframing: "the bigger point is to ensure that none of their infrastructure is under the purview of any US entity." This is a practical, achievable definition — reducing legal jurisdictional exposure — rather than kkfx's absolutist one.

But kkfx's point does highlight a real intellectual weakness in the article: the author uses "sovereignty" and "Made in EU" interchangeably with "hosted on EU companies." These are different things. Hosting on Hetzner gives you EU data residency and EU legal jurisdiction over your hosting provider. It doesn't give you sovereignty over your infrastructure in any meaningful sense — Hetzner can still change terms, raise prices, or shut down your account.

**Value:** Good as a conceptual corrective. Unhelpful as a practical standard.

---

### Claim 15 (zbentley): Users preferred paying a fine over filling out a signup form.

**Verdict: The thread's most powerful data point, but dangerously over-generalized.**

This is presented as evidence for the "conversion killer" thesis, and it's vivid. But examine the conditions: a municipal service used a few times a year, low motivation, an ordinary form requiring name/address/email/phone. Adding Google/Facebook SSO tripled signups.

What this actually shows: **for low-engagement, low-motivation interactions, form friction is massively underestimated**. This is consistent with UX research going back decades.

What it does *not* show: that users of a car parts marketplace (high intent — they need a specific part) would behave the same way. User motivation is the key moderating variable, and the anecdote strips it away.

The "tripled net signups" figure is also ambiguous — does this include people who *would never have signed up under any circumstances* but now do because it's zero-effort? If so, are those valuable users or noise? The anecdote doesn't distinguish.

**Value:** High as a specific data point about low-motivation contexts. Moderate as evidence for the general "conversion killer" claim.

---

### Claim 16 (ekidd): "You only test true disaster recovery every 5-10 years. In practice, this means that disaster recovery will usually fail."

**Verdict: One of the thread's best insights. Structurally correct.**

This is an application of Nassim Taleb's point about untested systems: the longer you go without testing something, the more likely it is to fail when tested. Applied to self-hosted databases, the logic is:

1. You set up backups.
2. You verify they run (you see the cron job succeeds).
3. You never actually *restore from backup to a fresh system*.
4. Years later, your disk fails.
5. You discover the backup is corrupt / the restore script has a dependency on something no longer installed / the schema has drifted / etc.

This is empirically common enough to be almost a law. The OVH Strasbourg fire thread (2021) is full of people discovering their "backups" didn't work.

The one caveat: this applies equally to managed databases. DigitalOcean's managed database backups have also famously failed. The advantage of managed services isn't that they're immune — it's that they test restore at scale across thousands of customers, so their failure probability per-customer is lower than yours.

znnajdla's response (testing restore weekly via CI/CD) is the correct engineering answer but requires discipline that most teams don't maintain.

**Value:** Very high. Should be internalized by anyone running self-hosted stateful services.

---

## Part 3: Meta-Analysis

### What the article gets right
- The core thesis — EU infrastructure is viable and maturing — is well-supported.
- The "hard parts" section (email, auth, AI) is honest and validated by the thread.
- The practical stack recommendations (Hetzner, Bunny, Scaleway) have genuine community validation.

### What the article gets wrong
- **Inconsistent sovereignty definition.** Uses "Made in EU" in the title but admits major US dependencies in the body. The honest title is "Mostly Made in EU, Except Where It's Hard."
- **Cost comparison without total cost.** Compares hosting prices without accounting for operational time costs, which is the classic self-hosting error.
- **Missing critical categories.** No mention of payments (the hardest remaining dependency), observability, or the operational cost of self-hosting 5+ services on K8s.
- **Written by Claude, about avoiding US dependencies.** The irony is acknowledged but not wrestled with.

### Structural bias in the thread
The thread has a strong **selection effect**: people who have successfully moved to EU infrastructure comment enthusiastically; people who tried and failed (or decided it wasn't worth it) are mostly silent. The one exception is mkzet/BoorishBears arguing for hyperscalers, but they're outnumbered. This creates a misleadingly positive picture.

The thread also shows a **demographic split** that nobody names: the enthusiasts are overwhelmingly solo founders and small teams. Not a single commenter describes doing this migration for a team larger than ~5 people, or for a service with serious SLA requirements. The advice may not scale.

### The article's actual contribution
Strip away the sovereignty framing and you have a useful practical guide: "Here are EU hosting providers that work well for small SaaS." That's valuable. The sovereignty narrative adds emotional resonance but also introduces the intellectual problems above. The article would be stronger — and more honest — without the "Made in EU" framing and with a straightforward "Here's how to build cheap and independent on European infra."
