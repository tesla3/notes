← [Index](../README.md)

## HN Thread Distillation: "Hetzner Prices increase 30-40%"

**Source:** [HN thread](https://news.ycombinator.com/item?id=47120145) (385 points, 572 comments) · [Hetzner announcement](https://docs.hetzner.com/general/infrastructure-and-availability/price-adjustment/) · 2026-02-23

**Article summary:** Hetzner announced price increases effective April 1, 2026 across cloud and dedicated server products. Cloud VPS prices rise ~30-32%, dedicated servers ~3-15%, and memory add-ons up to 575%. Hetzner cites DRAM costs up 500% since September 2025 and general hardware supply crunch driven by AI infrastructure demand. OVH simultaneously announced similar increases.

### Dominant Sentiment: Resigned acceptance, anger at AI externalities

The thread is unusually aligned. Almost nobody blames Hetzner. The anger is directed at AI companies for consuming hardware supply with venture-capital-subsidized demand, creating a tax on the productive economy. A notable undercurrent of "still cheaper than AWS" copium runs throughout.

### Key Insights

**1. The headline number masks a wildly uneven distribution**

The "30-40%" figure applies only to cloud VPS. Dedicated servers are up 3-15%. The real shock is memory add-ons: 575% effective immediately, reflecting the raw spot price of DRAM. `ozgune` breaks it down sharply: "AX162-R for €207 and add 128 GB of RAM for €46. Starting today... €264 for the 128 GB RAM add-on." It's now cheaper to provision a second server than to add RAM to an existing one. This inverts the normal economics of vertical scaling and will push customers toward horizontal architectures whether they want them or not.

**2. EU sovereignty is now a pricing moat Hetzner didn't ask for**

`jacquesm`: "Hetzner has a very nice sales representative in the White House." `AdamN` adds: "a lot of people are moving to them who are 'Buy EU'-driven and are less price sensitive." The BuyFromEU movement and Trump-era distrust of US cloud providers has given Hetzner pricing power independent of hardware costs. They can raise prices and still gain customers. `embedding-shape` confirms: "they're themselves citing that as the reason for a huge uptick in sales and new users." This is a structural advantage that will persist even if DRAM prices normalize — Hetzner has moved from competing on price alone to competing on jurisdiction.

**3. The "just supply and demand" framing gets demolished**

`Aurornis` delivers the textbook economics take: "This is actually a textbook example of markets functioning in response to a demand shock where supply cannot be increased rapidly." Multiple commenters punch holes in this. `BunsanSpace`: "demand is being propped up by speculative capital... AI companies are a bubble that is suffocating productive parts of the market." `kevincloudsec`: "companies that haven't turned a profit are outbidding the rest of the economy for hardware. that's not a supply shortage, it's a subsidy funded by venture capital." `StopDisinfo910` goes furthest: "It's an oligopoly with an extremely inelastic supply side... suppliers want to protect their margins and fear the market contracting again." The key tension: it's supply-and-demand mechanics *operating on distorted demand*. VC-subsidized companies burning cash can bid hardware prices up in ways that productive businesses cannot sustain.

**4. Manufacturers are deliberately not adding non-AI capacity**

`snowhale`: "Samsung and SK Hynix have been shifting capacity from commodity DRAM to HBM for AI accelerators. Same fabs, different product mix." `maxboone`: "RAM producers aren't adding more capacity on the non-HBM side of things." `gck1`: "RAM, SSD, HDD — they just reallocated their existing supply to AI." This is the structural insight the "prices will normalize" camp misses. Even when AI demand cools, commodity DRAM supply won't snap back because the fab capacity has been permanently reallocated. The Register article confirms HDDs are sold out through 2026, with WD and Seagate taking firm purchase orders into 2028. Omdia forecasts the top ten cloud providers will account for 70%+ of server capex in 2026.

**5. The "still cheaper than AWS" comparison is the wrong benchmark**

Multiple comments fall back on this. `mnewme`: "Still 90% cheaper than using AWS." But `oldherl` corrects: "Hetzner should not be compared to AWS or GCP for pricing. It should be compared to Vultr, Linode or DigitalOcean." This matters because Hetzner's actual competitive set is mid-market hosting, where a 30% hike is significant. The AWS comparison is a coping mechanism — it's like saying your rent increase is fine because penthouses cost more. `nozzlegear` actually does the comparison properly and finds Hetzner's CCX23 at $39.99 post-increase vs. DigitalOcean's equivalent at $126, which *does* validate the gap. But DO is also sitting on aging hardware that's overdue for a refresh at today's component prices.

**6. Self-hosting is becoming economically rational again**

`huijzer` bought a Raspberry Pi 4 + NVMe for €80 to replace a €5/mo Hetzner runner — payback in under 2 years. `chasd00` suggests "pick up an HP EliteDesk off eBay." `someguyornotidk`: "Hetzner is currently cheaper than getting a static IP from my ISP + electricity, but just barely." `anonzzzies` is "buying older servers by the truckloads" to fill their own cage. This is the reverse of the decade-long migration to cloud. When cloud costs were falling, the math was clear. With a 30% hike and rising trajectory, the break-even calculation flips for many workloads. The secondhand hardware market is already being cited by The Register as going "mainstream."

**7. The Chinese manufacturing wildcard nobody can size**

`Haven880`: "We wait for Huawei photonics GPUs... CXMT and YMTC ramping up production to flood the market." `rm30` sees a structural shift: "Western memory manufacturers decided to chase the AI bubble, abandoning the consumer and low-requirement markets entirely. Chinese manufacturers are now capturing that entire segment." But `re-thc` counters: "China doesn't have enough to supply itself." The thread can't resolve this because nobody has good data on Chinese fab ramp timelines. `lnsru` asks the right question: "Is this a point where Chinese companies will rise worldwide?" If CXMT/YMTC can fill the commodity DRAM vacuum left by Samsung/SK Hynix's pivot to HBM, it's a permanent market realignment, not a cyclical correction.

**8. Industry-wide, not Hetzner-specific**

OVH: 20-50% increases, confirmed by multiple commenters. Netcup: cancelled their winter sale. DigitalOcean: overdue for a refresh on aging hardware at today's prices. `hyperionultra`: "This will be as a shockwave in web hosting industry... there is nowhere to run." `piva00` provides the most comprehensive supply-side view: "RAM shortage, CPUs shortage (lead times for Intel at 6 months for server-class CPUs, AMD also notified enterprise customers about a crunch), GPUs shortage, storage prices increasing." Every input cost is moving in the same direction simultaneously.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "Still cheaper than AWS" | Misapplied | Wrong benchmark — should compare to mid-market hosts, not hyperscalers |
| "AI bubble will burst and prices normalize" | Medium | Ignores that fab capacity has been *reallocated*, not just temporarily overloaded |
| "Just switch to OVH/Netcup/Scaleway" | Weak | They're all doing the same thing for the same reasons |
| "Self-host on Raspberry Pi / old servers" | Medium | Valid for hobbyists; doesn't work for businesses needing SLAs, bandwidth, IPv4 |
| "Market dynamics, nothing to see" | Medium | Technically correct on mechanism, but ignores that demand is artificially inflated by VC subsidy |
| "Hetzner is just profiteering from EU demand" | Weak | Memory add-on pricing tracks raw DRAM spot prices almost exactly |

### What the Thread Misses

- **The insurance/warranty dimension.** Hetzner replacing failed DRAM in existing servers at 5x the original component cost is an underappreciated ongoing liability. The 3% auction server increase may be a hedge against this, not just a cash grab.
- **Contract/commitment pricing.** Nobody discusses whether Hetzner offers or should offer locked-in pricing for 1-3 year commitments, which is standard at hyperscalers. This would let price-sensitive customers hedge and give Hetzner predictable revenue.
- **Demand destruction is already happening.** If startups can't afford to prototype on cheap VPS, some products simply won't get built. The thread acknowledges this but doesn't grapple with the second-order: reduced SaaS competition means *higher* software prices downstream.
- **The tariff wildcard.** With US tariffs in flux and EU-China trade tensions, hardware supply chains could face additional shocks beyond the AI demand pull. Nobody connects this to the hosting price trajectory.
- **Power costs are actually *falling* in Germany.** `eigenspace` notes this but nobody follows through: the energy excuse is dead, this is purely a hardware story. Hetzner's own messaging bundles "operating costs" generically, which obscures where the money is actually going.

### Verdict

The thread correctly identifies the proximate cause (AI-driven hardware demand) but doesn't follow the logic to its conclusion: the era of monotonically decreasing cloud hosting costs is structurally over, not cyclically paused. Memory manufacturers have made a rational bet that HBM margins beat commodity DRAM margins indefinitely. They won't rebuild commodity capacity even if AI demand plateaus — they'll just enjoy the scarcity premium. What's happening to Hetzner is the first visible symptom of a permanent repricing of compute for the non-AI economy. The question isn't whether prices will come back down. It's whether the Chinese commodity DRAM industry can scale fast enough to create an alternative supply before the cost shock cascades into software pricing, startup formation rates, and the overall accessibility of the European indie dev ecosystem that Hetzner helped build.
