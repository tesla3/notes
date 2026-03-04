← [Index](../README.md)

## HN Thread Distillation: "MacBook Air with M5"

**Source:** [HN thread](https://news.ycombinator.com/item?id=47232502) · 384 points · 433 comments · March 3, 2026

**Article summary:** Apple announces MacBook Air with M5 — faster CPU/GPU with Neural Accelerator cores, base storage doubled to 512GB, Apple N1 chip for Wi-Fi 7/Bluetooth 6, same design and 18hr battery. 13" starts at $1,099 (+$100 over M4 base), available March 11.

### Dominant Sentiment: Bored reverence for a solved product

The thread reads like a eulogy for excitement. Almost nobody disputes the MBA is the best consumer laptop you can buy; the debate is whether that matters anymore when the product category itself has flatlined. The M1 → M5 arc has turned from "revolutionary" to "iPhone of laptops" — annual spec bumps nobody asked for on hardware most people can't saturate.

### Key Insights

**1. The MBA's real competitor is its own back catalog**

The most cutting observation comes not from haters but from satisfied owners. `petesergeant`: "there's just zero reason to upgrade my M2 MBA." `longbucks` is on an M1 Max and "can't justify an upgrade." `NoLinkToMe` bought a new-old M2 for 40% off and considers the value "insane." `allthetime`: "My M1 Air is going strong... Absolutely insane value and anyone who says otherwise has no idea what they are talking about."

Apple has built hardware so durable and performant that the upgrade cycle has stretched to 5-8 years organically. The $100 price increase on the base model — even if offset by the storage bump — signals Apple knows it needs to extract more per unit because volume growth is stalling. The leaked "MacBook Neo" at $599-799 is the real play: harvesting the segment that *would* have bought a discounted older Air.

**2. The price hike is a storage subsidy in disguise — and the thread mostly buys it**

`SirMaster` does the math: "Yesterday the 512GB M4 Air was $1200, now the 512GB M5 Air is $1100." The base went up $100, but the minimum spec got meaningfully better. `c-hendricks` confirms, and `NoLinkToMe` eats their own words mid-thread. This is a classically elegant Apple pricing move — raise the floor, kill the embarrassing 256GB SKU, claim a price *cut* on an apples-to-apples comparison, and pocket more revenue on average.

**3. "Laptops are commoditized and boring" — the thread's actual thesis**

`ajross` names it explicitly: "The news here isn't 'The M5 Air is a disappointment', it's 'Laptops are commoditized and boring.'" `hermanzegerman`: "Hardware is completely boring now. That also applies to Phones." `mixtureoftakes`: "laptops seem kinda solved now?" This is the thread's center of gravity — not M5 vs M4, but the realization that the computing platform that defined personal technology for 40 years has entered its refrigerator era. Nobody reviews refrigerators with excitement.

**4. The ThinkPad-vs-MBA debate reveals tribal identity, not technical assessment**

`mg` opens by noting the 13" MBA weighs more than a ThinkPad X1 Carbon. This kicks off a reliable HN ritual: ThinkPad fans cite weight, trackpoints, Linux, repairability; Mac fans cite build quality, trackpad, sleep reliability, thermals. `caymanjim` had a catastrophic X1 experience; `throw393234` (throwaway account, `whalesalad` correctly flags) ran one for 9 years. Neither is evidence of anything. The actually useful data point comes from `lotsofpulp`: "You can also close the lid and trust it to stay off... How no one else can figure out how to do this in almost 15 years is beyond me." `zonkerdonker` confirms: "My work machine (lenovo) regularly roasts itself to 0% battery in my backpack." This sleep/resume gap is the most durable, least-discussed competitive moat Apple has in laptops.

**5. The Linux-on-Mac question has shifted from "if" to "when... but when keeps slipping"**

`honeycrispy` wants Linux support. The thread converges on Asahi Linux as impressive but perpetually behind — it supports through M2, won't reach M5 for years. `TingPing`: "Asahi is great on earlier models but it will certainly not support the M5 before its already multiple models behind." `wpm` explains the structural reason: the team is focused on upstreaming into the kernel first. `cromka` offers an optimistic take that Apple might offer BootCamp for Linux/Windows to "own the market overnight," but `oblio` delivers the cold water: "Unless Apple starts failing again as a company (bad financials), they won't provide any official support for Windows or Linux." The cycle repeats every generation.

**6. The 128GB RAM ceiling matters to exactly one cohort — and they're vocal**

`HanClinto` is "disappointed" that M5 tops out at 128GB for local LLM serving. `browningstreet` delivers the structural explanation: "Apple hasn't suddenly stopped being Apple. They strongly differentiate the boundaries of their product lines." This is Apple's deliberate ceiling: the Air/Pro get 128GB max; if you want 512GB, buy a Mac Studio. The local-LLM crowd wants to collapse Apple's entire product line into one device. Apple will not oblige. `mft_` notes Apple didn't even bump Max RAM despite the memory price environment — they're protecting the Ultra/Studio tier above.

**7. The cellular modem is the feature the thread *most* wants and Apple *least* wants to ship**

`julianozen` asks the perennial question. `wpm` gives the sharpest rebuttal to the "just use your phone" crowd: "If 'just hotspot your phone' was hunky dory why does Apple sell iPads with cellular modems?" The experience gap is real — one battery drain, lower latency, instant-on. But the structural answer is that Apple segments aggressively: cellular belongs to iPad (and iPhone). Multiple commenters note Apple's own C1X modem should eventually make this feasible; `nicoburns` says rumors point to the M6 Pro redesign later this year. Until Apple's modem is cheap enough to be margin-neutral, it won't happen in the Air.

**8. macOS is getting the Windows treatment — and fans are noticing**

`PaulHoule` reports constant beachballs on a maxed M4 Mini. More damning: "When I set up a new Mac for my wife she was furious at how ad infested it was." `angoragoats`: "When macOS shows an ad, it is sometimes harder to get rid of or disable than the ads built into Windows." `petesergeant` got "tricked" into installing Tahoe on an iPhone 12 Pro and it's now "sluggish and sad." `std_move` — the thread's most enthusiastic MBA advocate — concedes "I would much prefer Linux or a very customized Windows." The hardware praise is unconditional; the software praise is increasingly conditional.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| ThinkPad is lighter/better | Medium | Weight claim is true for X1 Carbon; rest is tribal preference. Sleep/resume and trackpad gaps remain real. |
| Just run Linux in a VM | Weak | `w10-1` suggests it. Works for terminal use, misses the point for anyone who wants native GPU or battery efficiency. |
| Intel Panther Lake closes the gap | Medium | `bryanlarsen` and `elxr` claim parity. `dagmx` demands benchmarks and gets none — PTL matches M5 multicore at 2x power draw. |
| $100 price hike is bad | Misapplied | Spec-for-spec it's a price cut. The base *floor* rose, but 256GB was already inadequate. MacBook Neo fills the gap below. |
| Apple should support Linux | Recurring | Structurally won't happen while Apple is profitable. Asahi exists but trails by 2-3 chip generations. |

### What the Thread Misses

- **The MacBook Neo is the actual story.** The M5 Air is a holding pattern; the $599-799 A18/A19 Pro MacBook ("Neo") leaked the same day and threatens to reshape the entry-level laptop market far more than another Air spec bump. The thread barely mentions it.
- **Memory bandwidth as moat.** The M5 Air hits 153GB/s unified memory bandwidth. Panther Lake can theoretically match this with LPDDR5X-9600, but no shipping laptop does. This bandwidth gap is what makes local inference viable on Mac and painful on everything else — and the thread discusses RAM *capacity* without mentioning *bandwidth* once.
- **The repairability ratchet.** `wisplike` describes drilling out rivets to replace a keyboard. `mikae1` celebrates upgradeable ThinkPads. But the thread doesn't note that Lenovo and others are converging toward Apple's soldered-everything model — the repairability argument has an expiration date.
- **Software bloat as hardware subsidy.** Multiple commenters note macOS is getting heavier, Tahoe slows older devices, web browsers consume 12GB. Nobody connects this to Apple's incentive structure: software bloat is the best upgrade driver when hardware stops being exciting.

### Verdict

The M5 Air thread is really a thread about the end of the laptop as an interesting product category. Apple has won so decisively that even its fans are bored, and the most energetic debates are about features Apple *won't* ship (cellular, Linux, more RAM) rather than what it *did*. The actual strategic move — killing 256GB, raising the floor to $1,099, and preparing a sub-$800 MacBook Neo — is the kind of pricing chess that doesn't generate excitement but generates revenue. The thread circles this without stating it: Apple's challenge isn't making a better laptop, it's making people *buy* a new one when the old one still works perfectly.
