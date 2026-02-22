← [Index](../README.md)

## HN Thread Distillation: "Amazon is ending all inventory commingling as of March 31, 2026"

**Source:** [Twitter/X post by @ghhughes](https://twitter.com/ghhughes/status/2012824754319753456) summarizing [Amazon Seller Central announcement](https://sellercentral.amazon.com/seller-forums/discussions/t/106d0747-e5c6-44d8-86f3-7669f11238fe) | [HN thread](https://news.ycombinator.com/item?id=46678205) (523 points, 259 comments, Jan 2026)

**Article summary:** Amazon announced that effective March 31, 2026, it will end inventory commingling — the practice of treating identical products from different sellers as interchangeable in fulfillment centers. Brand owners can now use manufacturer barcodes; resellers must use Amazon barcodes. Existing commingled inventory in warehouses is not affected and will sell through under current rules.

### Dominant Sentiment: Vindication laced with permanent distrust

The thread reads like a class-action deposition. Nearly every commenter has a personal counterfeit story — SD cards, Samsung monitors, water bottles, dental products, bicycle tires, books with missing chapters, skincare with wrong formulations. The mood is not celebration; it's "about damn time" shading into "too late, I already left." The few commenters expressing satisfaction are immediately corrected by others pointing out what this *doesn't* fix.

### Key Insights

**1. Amazon insiders confirm commingling was known-risky from the start**

The thread's star comments come from three former Amazon employees. **jonhohle**, who worked on Prime and Delivery Experience until 2013, says commingling "was considered relatively taboo due to the destruction of customer trust that would likely result. It was an obvious optimization... It turned out pretty much the way we figured it would." **ajkjk**, who implemented commingling at the warehouse level starting in 2013, provides a detailed technical account of how provenance tracking was designed to blur attribution once items were physically mixed. The system distinguished "trusted" sellers (whose stock could commingle) from untrusted ones (tracked via individual license-plate barcodes, borrowed from Zappos). ajkjk's verdict: "In hindsight trusting FBA sellers to not become essentially malevolent actors seems comically naive." **aserafini** (pre-2007 Amazon) confirms there was never computational overhead to commingling — "the opposite was true" — and that even returns couldn't be attributed to the correct supplier. These accounts collectively show that Amazon chose commingling knowing it sacrificed accountability, because the logistics savings were worth more than the trust they were burning.

**2. The real driver isn't customer complaints — it's that commingling became unnecessary**

**Fiveplus** provides the sharpest structural read: Amazon's own announcement says "most sellers maintain inventory levels that keep products close to customers." Amazon has spent years aggressively penalizing sellers who don't distribute inventory regionally. The distributed-cache optimization that commingling provided is now redundant because Amazon has shifted the burden onto sellers. As **ethbr1** notes, this trades "the operational complexity of physical sorting for the software complexity of forcing sellers to manage regional inventory better." In other words, Amazon isn't fixing a moral failure — it's deprecating a system that no longer improves its metrics. The customer trust benefit is a side effect, not the cause.

**3. The existing inventory loophole guts the announcement's immediate impact**

**bshanks** and **happymellon** flag that the policy only applies to inventory *shipped to Amazon* after March 31. Everything already in warehouses stays commingled and will sell through. **Ajedi32** notes this means it'll take months — potentially much longer for slow-moving SKUs — before commingled stock is fully depleted. For anyone buying a niche product, the announcement changes nothing in 2026. **brohee**: "They certainly cannot 'uncommingle' existing stock, so you may be able to buy new product with better source assurance, but for existing products..."

**4. The counterfeit mechanism was a textbook moral hazard — and some exploited it deliberately**

**numpad0** explains the perverse incentive: "malicious sellers can deliver literal counterfeits to warehouses and externalize the consequences, down to angry 1-star reviews and disposal of returned counterfeit examples, to somebody else." **withinboredom** provides a concrete case: a colleague who bought pallets of used CDs/DVDs, buffed and shrinkwrapped them, shipped them to FBA as "new," and relied on commingling to ensure someone *else's* customer got the unplayable disc while his customer got the legitimate one. He called it "arbitrage." He eventually got banned. This is not edge-case abuse — it's the system working exactly as its incentives predicted.

**5. This doesn't fix Amazon's other trust-destroying systems**

Multiple commenters note that commingling is only one layer of a deeper rot:
- **Review hijacking**: **thayne** and **al_borland** describe listings where reviews from one product get transferred to an inferior replacement. al_borland found chopstick reviews that were actually about a wok.
- **Shadow-banned negative reviews**: **embedding-shape**, **kevin_thibedeau**, and **AlexandrB** all report legitimate negative reviews being silently hidden. Amazon's review moderation appears to suppress quality signals that would hurt sales.
- **Listing manipulation**: **Someone1234** had a review warning about a product swap rejected because it was deemed "feedback on the seller."
- **Junk brand proliferation**: **qmr** notes Amazon is "stuffed to the gills with random 5 letter 'brands' (SUNEG, TRSTF, KALINE) selling the same Chinesium products."

Ending commingling addresses the supply chain layer but leaves the information layer — reviews, listings, search — thoroughly corrupted.

**6. The Kenya coffee parallel reveals the deep structure**

**specialist** surfaces a striking analogy: Kenya's colonial coffee auction system commingled beans from all producers, destroying any individual farmer's incentive to invest in quality. The result was a decades-long race to the bottom. **DoughnutHole** identifies the key variable: "What these systems rely on is a governing body that punishes producers that don't meet the body's standards and ruin the party for everyone else. Amazon is the governing body here and has previously shown no interest in protecting legitimate producers from counterfeiters." This is the mechanism Amazon replicated — commingling socializes the reputation cost of bad actors across all sellers, destroying the price signal that would otherwise reward quality.

**7. The behavioral damage may be irreversible for a cohort of power users**

A striking number of HN commenters — the exact demographic Amazon should worry about losing — describe permanent behavioral changes. **comrade1234**: "cancelled my Amazon account years ago." **zerosizedweasle**: "Too late, I stopped buying from Amazon because of this. Now my shopping habits have changed." **julianozen** quotes a former Amazon fulfillment executive who "was unwilling to buy anything from Amazon to put in or on his body." **logankeenan**: "DTC from quality producers now have decent websites, free shipping, and good customer service. If I'm going to buy a premium expensive product, why risk it." These aren't people who'll come back because of a policy change. They found alternatives and the switching cost now runs in Amazon's *dis*favor.

**8. The YouTube piracy playbook: ride illegitimacy to dominance, then clean up**

**resters** names the pattern: "Just as YouTube finally 'cracked down' on piracy after riding it to massive market share, Amazon has done the same with counterfeit goods." **pengaru** calls it a "fake it 'til you make it variant." This framing reappears throughout the thread — the suspicion that Amazon tolerated counterfeits because the volume and low friction they generated were more valuable than the trust they destroyed, and now cleans up only because the growth phase is over and the reputational cost is beginning to matter at the margin.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Amazon is basically AliExpress now" (tgsovlerkhgsel) | Medium | Directionally right on trust erosion, but overstates — Amazon's returns infrastructure and delivery speed remain structurally different. The gap is narrowing though. |
| "This is just PR, they'll never actually do it" (sovietmudkipz) | Weak | The Seller Central announcement has specific technical requirements (barcode labeling changes) that are concrete and verifiable. This isn't vaporware. |
| "Secularism caused this" (boelboel) | Misapplied | Attempts to frame trust erosion as a values/religion problem. Gets thoroughly dismantled. The actual mechanism is platform economics and regulatory capture, not metaphysics. |
| "The grocery store does the same thing" (doctorpangloss) | Demolished | **khuey**, **InitialLastName**, **teraflop**, and **PKop** all pile on. Grocery stores curate suppliers, inspect produce visually, maintain distribution chains with QC, and face liability. Amazon lets anyone slap a barcode on anything. The analogy doesn't survive first contact. |

### What the Thread Misses

- **Regulatory pressure is conspicuously absent from the discussion.** No one mentions the EU's Digital Services Act or Product Safety Regulation, both of which impose marketplace liability obligations that went into effect in 2024-2025. Amazon may be preemptively harmonizing US fulfillment practices with EU requirements where they're now legally liable for third-party goods they warehouse.
- **The second-order effect on Amazon's competitive moat.** If every seller must now maintain distributed regional inventory to get decent delivery times, the barrier to entry for small FBA sellers rises significantly. This could accelerate consolidation toward larger sellers — exactly the kind of sellers who were already less likely to counterfeit. The policy cleans up quality *and* thins the competitive field. That's not a coincidence.
- **Nobody asks whether Amazon barcodes on reseller products actually prevent counterfeiting** or merely enable *attribution* after the fact. A barcode traces the item back to the seller who shipped it — it doesn't verify authenticity. A counterfeiter who labels their fakes with Amazon barcodes has merely moved from anonymous fraud to attributable fraud. Enforcement still requires Amazon to actually inspect and punish.

### Verdict

The thread circles but never quite lands on the central irony: Amazon is being credited for solving a problem it *chose* to create, at the exact moment the solution costs it nothing. Commingling was always a calculated trade — logistics efficiency against trust — and Amazon rode it for over a decade while the cost was borne by sellers and customers. Now that regionalized fulfillment has made commingling operationally redundant, ending it is free PR. The insiders in the thread make clear this was predicted and preventable from day one. The real question isn't whether Amazon will stop mixing inventory — it's whether the deeper information corruption (reviews, listings, search) that commingling made possible will ever face the same reckoning, or whether those systems still have enough juice left to be worth protecting.
