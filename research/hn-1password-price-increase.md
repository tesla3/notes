← [Index](../README.md)

## HN Thread Distillation: "1Password pricing increasing up to 33% in March"

**Source:** [HN thread](https://news.ycombinator.com/item?id=47139951) — 105 points, 163 comments, 99 unique authors (Feb 2026). Text post sharing 1Password's price increase email. No external article.

**Article summary:** 1Password is raising individual plans from $35.88→$47.88/yr (+33%) and family plans from $59.88→$71.88/yr (+20%) effective March 27, 2026. The email justifies this with a feature list including "AI-powered item naming," enhanced Watchtower, and phishing prevention. Some EU users must actively consent or get auto-cancelled.

### Dominant Sentiment: Resigned anger from captive customers

The thread is loud but structurally toothless. Nearly every commenter expressing outrage also acknowledges they probably won't leave, or that the alternatives are worse. The anger is real but the switching costs are higher than the price delta — and 1Password knows it.

### Key Insights

**1. The enterprise pivot is the actual story; consumers are the legacy tail**

The press release 1Password issued in Nov 2025 tells a different story than the price-increase email. The company crossed $400M ARR, 75%+ of revenue now comes from business customers, and the executive hires are all enterprise-growth people (ex-Barracuda, ex-SAP, ex-Qualtrics). The consumer product is becoming the loss-leader that feeds brand awareness for enterprise sales. `et-al` nails it: *"Too bad they took VC funding and have to be a 'global leader in identity security' instead of just making a damn good password manager."* The feature list in the email (Watchtower, phishing prevention, "AI-powered item naming") reads like enterprise checkbox items backported to justify a consumer price hike.

**2. The inflation defense is mathematically correct and psychologically irrelevant**

`tzs` makes the strongest counterargument: *"Inflation calculated from the CPI over the last 8 years in the US was 31%, which is fuzzy enough that it should be considered approximately equal to 33%."* This is factually true. But `otterley` (OP) identifies why it doesn't land: *"Raising prices 3% every year is perceived quite differently than raising it 20-33% once."* The real issue isn't the economics — it's that 1Password chose to absorb inflation during growth years and then pass the accumulated delta in a single shock, at precisely the moment quality complaints are peaking. The timing transforms a defensible adjustment into evidence of enshittification.

**3. Passkeys are creating a new, worse form of lock-in — and the thread barely notices**

`jasonriddle` raises the most important point in the entire thread, almost in passing: *"I was feeling more uncomfortable having websites promote using passkeys, and I would store that in 1Password, but then I wasn't sure if 1Password was going to make it easy to migrate that stuff out."* Passwords can be exported as CSV. Passkeys involve cryptographic keys tied to the provider's storage. The industry spent a decade promising passwordless auth would liberate users from password reuse; instead it's creating provider lock-in at the *authentication primitive* level. Several commenters mention this as a reason to prefer open-source solutions, but nobody engages with the structural implication: the switching cost for password managers is going up, not down, which means future price increases face even less resistance.

**4. The alternatives landscape is a market failure**

The thread is a graveyard of unsatisfying options. Bitwarden: `k_bx` — *"a shit product lacking basic niceties: search is terrible, UI is sometimes non-async, consumes memory and CPU."* And Bitwarden itself just doubled premium pricing ($10→$20/yr). Apple Passwords: works great in Safari, terrible subdomain handling (`drcongo`: it treats `site1.example.com` and `site2.example.com` as the same site), no Android/Linux, requires biometric auth every session in non-Safari browsers. KeePass/KeePassXC: free but requires self-managed sync, no non-technical family member will tolerate the setup. Self-hosted Vaultwarden: same problem amplified. Nobody in 163 comments can name a product that matches 1Password's *old* value proposition (cross-platform, family sharing, good UX, reasonable price, secure). The market has a hole where a good consumer password manager should be.

**5. Quality regression is the force multiplier for price anger**

The price increase alone wouldn't generate this thread. What does is the combination with 1Password 8's Electron migration, which surfaces in nearly every subthread. `al_borland` (18-year user): *"The browser extension doesn't work half the time... A lack of reliability of the extension leaves people more vulnerable to phishing, since they have to copy/paste passwords out of the app."* `imfing` reports their Chrome extension was breaking code block rendering on websites for weeks — only fixed after Vue.js creator Evan You tweeted about it. `jsheard`: Windows client crashes on every fresh boot. `daringrain32781`: Linux app crashes half the time. The thread reveals a product caught between two customer bases: enterprises paying six-figure contracts get priority support; individual/family users get Electron jank and a 33% bill.

**6. "AI-powered item naming" is doing real brand damage**

This feature gets called out by name in at least 8 separate comments, always derisively. `fnoef`: *"Hope the price increase is not to cover their useless AI spendings."* `seatac76`: *"That has to be the lamest use of 'AI' to justify price increases."* `avazhi`: *"listing AI auto naming of items as an improvement got a genuine laugh out of me."* In a security product, injecting "AI" into the value proposition without specificity reads as either dishonest (using it as a pricing excuse) or worrying (sending my data to LLMs?). It's a marketing misfire that undermines the legitimate items on the same list.

**7. The EU consent-or-cancel mechanism reveals regulatory asymmetry**

`fnwbr` (Germany) and `bytebln` (Switzerland) received emails requiring them to actively approve the price change at `my.1password.com/billing`, with auto-cancellation if they don't. US users got no such requirement. `wartijn_` (Netherlands) didn't get it either, suggesting this isn't uniform EU policy but varies by jurisdiction. This is a small but interesting detail: European consumer protection law is functioning as a real friction on SaaS pricing, forcing an opt-in that US users don't get. For 1Password, this creates a natural experiment — the cancellation rate in consent-required jurisdictions will be meaningfully higher.

**8. The F1 sponsorship lands as a devastating detail**

`sega_sai`: *"They manage to find the money to sponsor an F1 team, so I don't think the money is the issue."* This one comment reframes the entire pricing narrative. You can't simultaneously tell customers you need 33% more to keep innovating and be writing eight-figure sponsorship checks. The response — `FragenAntworten`: *"I'm guessing they'd view that as a marketing expense"* — is technically correct and emotionally tone-deaf. It confirms the enterprise pivot: F1 sponsorship is B2B brand-building, subsidized by consumer price hikes.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "It's just inflation" (tzs) | Strong on math, weak on timing | True in aggregate, but 1P chose to deliver it as a shock during a quality trough |
| "It's still cheap / worth it" (morgango, fred_is_fred, aborsy) | Medium | Valid for satisfied users, but ignores that quality has degraded for many |
| "Just switch to Apple/Google" | Weak | Platform lock-in, no cross-platform, worse UX for non-default browser |
| "Just self-host" (vdfs, supernes) | Weak for families | Works for technical individuals, fails the "my wife/kids use it" test |
| "Bitwarden is the answer" | Medium | Cheaper but UX is widely panned; also just raised prices 100% |

### What the Thread Misses

- **The real squeeze hasn't started.** If 75% of revenue is enterprise and consumer plans are a brand funnel, the rational move is to keep raising consumer prices until the churn rate hits the brand-damage threshold. This is increase #1.
- **Password manager consolidation is coming.** Apple, Google, and Microsoft are all building free, integrated password management. The viable commercial market is narrowing to enterprises and the cross-platform niche. 1Password's pivot anticipates this.
- **Nobody discusses the security implications of mass migration.** If thousands of users hastily export passwords to CSV files to switch providers, the aggregate attack surface during transition is enormous. The safest thing for most users is to stay put — which is another form of lock-in.
- **The thread treats "open source" as a security guarantee.** Multiple comments suggest Bitwarden/KeePass as more trustworthy because they're open-source. Nobody mentions that Bitwarden's server code was only recently made fully open, or that KeePass has had its own vulnerability disclosures. Open source is necessary but not sufficient for security trust.

### Verdict

This thread is 163 comments of people discovering that they're the B-side of an enterprise software company. 1Password's consumer product isn't enshittifying in the Doctorow sense — it's not being monetized through degradation. It's being *deprioritized*. The Electron rewrite, the AI feature-stuffing, the quality regression, and the price increase all follow the same logic: consumer plans need to either subsidize enterprise growth or shed users who aren't worth supporting at current margins. The cruelest irony is that passkeys — the technology the security community championed as a user-liberating successor to passwords — are becoming the mechanism that locks users into whichever vault they chose first. The thread is full of people who "should" switch but won't, and that inertia is the product.
