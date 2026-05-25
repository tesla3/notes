← [Index](../README.md)

## HN Thread Distillation: "I tried building my startup entirely on European infrastructure"

**Source:** https://news.ycombinator.com/item?id=47085483 · 631 points · 321 comments · Feb 2026
**Article:** https://www.coinerella.com/made-in-eu-it-was-harder-than-i-thought/

**Article summary:** A founder documents building a SaaS (hank.parts, a car parts platform) entirely on EU providers — Hetzner for compute, Scaleway for email/registry/observability, Bunny.net for CDN, Nebius for AI inference, Hanko for auth, plus self-hosted Gitea/Plausible/CRM on K8s. Honest about what can't be avoided: Google/Apple sign-in, App Store distribution, and frontier AI models.

### Dominant Sentiment: Enthusiastic validation, pragmatic caveats

The thread is overwhelmingly sympathetic — a rare HN consensus. Not "we should all do this" idealism but practical "here's how I did it too" energy. The Trump-era geopolitical context is the unspoken accelerant; multiple commenters explicitly cite it. The few contrarians arguing it's wasted "innovation tokens" or politically fickle get pushed back hard.

### Key Insights

**1. Hetzner is the consensus anchor, but with known limits**

Virtually every commenter doing EU infra converges on Hetzner for compute. The value proposition is uncontested — "a third of the running costs and ~50x resources" vs. GCP. But the thread surfaces real operational gaps: internal network intermittent failures, no serious SLA, "overly cautious" account onboarding due to razor-thin margins, and the absence of a dedicated infra person being a genuine risk. The split is clear: solo devs and small teams love it; anyone thinking about production SLOs at scale hesitates.

> "If you are serious about your product SLOs, hyperscales shine, and you can only accept the 'cloud tax'." — mkzet

**2. Scaleway is the quiet favorite, OVH is radioactive**

Scaleway gets consistent praise — good IAM, reasonable pricing, solid support — yet almost nobody outside the thread seems to know about it. The recurring puzzle: "I wonder why it's not used more?" OVH, by contrast, has become a cautionary tale. The Strasbourg datacenter fire, forced 2FA lockouts requiring *paper letters by post*, and a control panel "riddled with bugs" have created a trust deficit that persists years later.

> "They enabled 2FA without my consent and then demanded a signed letter on paper by post to let me back into my account... Just when I was preparing to punish them by moving, my VPS went up in smoke at that fire in their Strasbourg datacenter." — bluebarbet

**3. The social login trap is the real lock-in**

The thread's longest and most heated subthread isn't about servers — it's about "Sign in with Google/Apple." The technical crowd doesn't understand why users won't just use email/password. The data is brutal: one commenter reports that before adding SSO to a *government-adjacent municipal service*, users preferred *paying a fine* over completing a signup form. The EU Digital Identity Wallet project exists but is embryonic and, ironically, developed on GitHub. National solutions (BankID in Nordics) work domestically but fragment across borders.

> "People weren't choosing in-person over filling out the create-account form. They were choosing to *pay a fine* instead of filling out the create-account form." — zbentley

**4. Transactional email is the surprising pain point**

Multiple commenters confirm the author's finding: EU transactional email is underdeveloped. Sendgrid/Postmark/Mailgun equivalents don't exist at the same DX or deliverability level. Scaleway TEM, Mailjet (now Swedish-owned via Sinch), Lettermint (NL), and MailerSend get mentions, but the ecosystem is thin. Marketing/newsletter email at scale (20M+/month) is even worse. This is a genuine gap, not a perception problem.

**5. The "Mac Studios in a closet" counterpoint**

One long, detailed comment argues you can skip cloud entirely: 4 Mac Studios, MinIO for S3-compatible storage, local Postgres, Elixir/Phoenix for distribution — all for ~50K EUR one-time vs. 25K EUR/month on AWS. The thread is both fascinated and skeptical. The networking redundancy answer ("I have a good personal relationship with my ISP") drew deserved scrutiny. Still, the underlying point — that modern hardware has so much headroom that most startups dramatically over-provision via cloud — resonated. Note: MinIO was deprecated/relicensed in early 2026, making this specific stack already dated.

**6. Domain pricing asymmetry is real and unexplained**

The author found 2-3x markups on niche TLDs at EU registrars. Thread confirms it: `.party` is $21 at Porkbun vs. €32.80 at INWX (the best EU option found). Nobody provided a satisfying explanation. ICANN's US-centric governance is flagged as the structural issue, with one commenter calling it "the one administratively completely entangled into USA system."

**7. The geopolitical motivation is now mainstream, not fringe**

This isn't ideological purity — it's risk management. Multiple commenters frame it explicitly: the US administration has "casually mentioned they could turn off all access to US digital services." The thread treats EU infrastructure migration as a reasonable business continuity decision, not a political statement. The comparison to Russia/China building alternatives isn't hypothetical anymore — it's a roadmap being studied.

**8. Forgejo > Gitea is the new consensus**

The thread converges quickly: Gitea's trademark/governance controversy (silent transfer to a for-profit entity) makes Forgejo the recommended fork. Codeberg gets love for open-source hosting but isn't suitable for private/commercial repos. The GitHub ecosystem lock-in (Actions, social graph, integrations) remains the real barrier, not the git hosting itself.

### What the Thread Misses

- **Monitoring/observability gap.** Nobody seriously discusses EU alternatives to Datadog/New Relic/PagerDuty beyond Scaleway's offering. This is a major operational dependency that goes unexamined.
- **Payments.** The author admits they haven't solved this yet. The thread mentions Adyen (NL) and Revolut Pay (UK) in passing but nobody has actually migrated off Stripe to an EU processor and reported back. This is arguably the hardest remaining dependency.
- **Legal/regulatory costs.** Author mentions getting lucky with lawyers. Nobody quantifies the GDPR compliance overhead of self-hosting everything — which is ironic given GDPR is a motivator for the whole exercise.
- **Team scaling.** Every "EU stack" described is a solo-founder or tiny-team setup. Nobody addresses what happens when you need to hire and onboard — GitHub's social graph and CI/CD ecosystem are recruiting and productivity tools, not just hosting.
- **Backup/DR testing discipline.** The Mac Studio commenter tests DR weekly via CI/CD — admirable but rare. The managed-vs-self-hosted database debate doesn't address the median case: teams that *think* they have backups but have never tested recovery.

### Verdict

The EU infrastructure stack is viable for small-to-medium SaaS in 2026 — cheaper on compute, adequate on most services, genuinely painful only on transactional email, social auth, and frontier AI. The real story isn't technical feasibility; it's that geopolitical risk has crossed the threshold where pragmatic founders (not just ideologues) are actively migrating. The remaining US dependencies — Apple/Google app stores, social login, AI APIs — are structural, not solvable by better EU startups, and will require either regulation or a true political rupture to dislodge. Hetzner + Bunny.net + self-hosting is the emerging "boring EU stack," and it works. The question is whether the European ecosystem can mature fast enough before the current geopolitical motivation fades — or intensifies.
