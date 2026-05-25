# Gap Analysis: FTC Garage Charging Station Recommendation

Date: 2026-04-01

## Verdict: I Overcorrected

The critical review rightly caught the LiPo-threat-model mistake. But the final recommendation swung too far toward "NiMH is basically harmless." NiMH manufacturers themselves warn of fire, bursting, and hydrogen gas. I also missed several practical risks specific to a garage team with 10+ batteries.

---

## Gap 1: NiMH CAN Catch Fire and Explode — Manufacturer Says So

I framed NiMH failure as "pressure vent → hydrogen gas → no big deal." The actual manufacturer safety data is more serious.

**FDK (major NiMH cell manufacturer), official handling precautions:**
- *"Overcharging cause leakage of battery fluid, heat generation, bursting and fire."*
- *"If Ni-MH batteries leak fluid, change color, change shape, or change in any other way, do not use them, otherwise they may cause heat generation, bursting and fire."*
- *"Charging batteries with the terminals reversed may... cause leakage of battery fluid, heat generation, bursting and fire."*

Source: [fdk.com/battery/nimh_e/caution](https://www.fdk.com/battery/nimh_e/caution/)

**CandlePower Forums (SilverFox, experienced battery tester):**
- *"When a NiMH cell vents, it releases Hydrogen gas. If there is a spark present, things can heat up quickly."*
- *"If the cell has vented previously and tries to vent again and the vent happens to be plugged, you can have a situation where 'rapid disassembly' occurs... otherwise known as explosion. Larger cells can shoot the top of the cell 10-20 feet."*
- *"If the cell shorts out, it can get very hot and melt whatever is around it."*

Source: [candlepowerforums.com](https://www.candlepowerforums.com/threads/nimh-battery-failure.162457/)

**Endless-Sphere (NiMH e-bike pack explosion report):**
- An acquaintance had a *"NiMH pack overheat and cook itself inside his bike's pack tank one night, while charging"*
- Reverse-polarity connection to a NiCd pack caused cells to *"literally glow red hot"*

Source: [endless-sphere.com](https://endless-sphere.com/sphere/threads/case-of-the-exploding-nimh-pack.2171/)

**My error:** Saying NiMH has "no thermal runaway mechanism" was overconfident. NiMH can't self-sustain a fire the way Li-ion does (no flammable electrolyte, no internal oxygen generation), but it CAN overheat, vent flammable hydrogen, burst, and ignite surrounding materials. The risk is lower, not zero. A non-combustible charging surface and basic containment are justified — not just "nice to have."

---

## Gap 2: Hydrogen Gas + Garage Ignition Sources

I mentioned hydrogen venting but didn't think through what a garage actually contains.

**Hydrogen facts:**
- Lower Explosive Limit (LEL): **4% by volume** (NFPA, IEEE, IFC all reference this)
- Hydrogen is lighter than air — rises and accumulates at ceiling level
- At 4% LEL: *"does not explode, but rather burns off with more of a fizzle"* — but at 6-8%: *"it pops"*, and at 10-20%: *"explosive power becomes very impressive, able to blow the doors, roof, or walls off a battery shelter"*

Source: [zomeworks.com](https://www.zomeworks.com/battery-electronic-enclosures/hydrogen-venting-system/hydrogen-vent-faq/)

**Garage-specific ignition sources for hydrogen:**
- **Gas water heater with pilot light** — common in garages, open flame at floor level, and hydrogen rises past it
- **Furnace / HVAC** — pilot lights or electric igniters
- **Sparks from power tools** (grinder, welder)
- **Car electrical systems** — starting a car near venting batteries
- **Light switches** — can spark

**Will 10 FTC batteries reach LEL in a garage?** Almost certainly not under normal conditions. A 3Ah NiMH cell vents tiny amounts of hydrogen during normal charging. But a **failure event** (stuck charger, degraded cell being overcharged) could produce sustained hydrogen output. In a closed garage (door down, winter), with poor air circulation near the ceiling — it's not impossible for a local pocket to form.

**What I should have said:** "If your garage has a gas water heater or furnace with a pilot light, do not charge batteries near it. Charge with the garage door cracked or a window open for ventilation."

---

## Gap 3: Reverse-Cell Charging — The Actual FTC-Specific Failure Mode

This is the most relevant risk I completely missed.

FTC batteries are **10 NiMH cells in series**. If one cell degrades (high IR, reduced capacity) while the others are healthy, during discharge the weak cell hits 0V first. The remaining 9 cells then force current through the weak cell **in reverse polarity**.

**FDK manufacturer warning:** *"Do not charge or use Ni-MH batteries with the ⊕ and ⊖ terminals reversed. Charging batteries with the terminals reversed may discharge rather than charge the batteries, or it may cause abnormal chemical reaction in the batteries."*

**What happens:**
- The weak cell heats up dramatically (all pack energy dumping into it as heat)
- Can cause venting, hydrogen release, electrolyte leakage
- In extreme cases: cell rupture

**This is why battery health monitoring matters more than containment.** A degraded cell in a series pack is the actual failure path for FTC batteries. The Battery Beak / IR tracking I recommended is the right mitigation — but I undersold it as optional "battery health program" when it should be the **primary safety measure**.

---

## Gap 4: Charger Quality Is the Critical Control — Specific Charger Evaluation

I said "the charger is the real fire risk" then gave no guidance on chargers. This is the biggest practical gap. A detailed comparison of the two chargers sold by goBILDA for FTC use fills this gap.

**NiMH charging failure modes:**
- **Dumb timer chargers** — charge for a fixed time regardless of battery state. If battery is already partially charged, it overcharges. FDK warns against this explicitly.
- **Delta-peak detection failure** — the charger looks for a voltage drop (~5mV/cell) that signals full charge. False peaks cause premature termination (annoying but safe). **Missed peaks** cause overcharge (dangerous). Degraded cells with high IR are most prone to missed peaks.
- **No temperature cutoff** — quality chargers have thermistors that stop charging if the battery gets hot. Cheap chargers don't.

Source: RC community consensus (rctech.net, rctalk.com, CandlePower Forums). SilverFox (CandlePower): *"Most charger melt downs are really cells that have gotten very hot and melted into the case of the charger."*

### Charger Comparison: Hitec RDX2 200 ($140) vs goBILDA Simple Charger ($15)

goBILDA sells both chargers for FTC use. They map very differently to the safety controls above.

**Hitec RDX2 200** ([gobilda.com](https://www.gobilda.com/hitec-rdx2-200-ac-dc-multi-function-smart-charger/)): Dual-channel, multi-chemistry (NiMH/NiCd/LiPo/LiFe/LiIon/LiHV/Pb), 100W per channel, LCD display, metal scroll wheel. Hitec RCD is a well-established RC brand (San Diego, founded 1990). goBILDA provides exact FTC settings: NiMH, 10S(12.0V), -5mV delta-peak, 1A charge current.

**goBILDA Simple Charger** ([gobilda.com](https://www.gobilda.com/battery-charger-nicad-nimh-12-1/)): Single-purpose NiMH/NiCd charger, 1A fixed charge rate, XT30 connector, LED indicator (red=charging, green=full), drops to 0.07A trickle when "full." **Charge termination method is undisclosed.** Product page does not specify delta-V, timer, or voltage threshold detection.

| Safety Control | RDX2 200 | Simple $15 Charger |
|----------------|----------|--------------------|
| Delta-peak detection (-5mV/cell) | ✅ Yes, configurable | ❓ Unknown — not disclosed |
| Temperature monitoring | ✅ Sensor port available | ❌ No |
| Backup safety timer | ✅ Configurable | ❓ Unknown |
| Capacity cutoff | ✅ Configurable | ❌ No |
| Internal resistance measurement | ✅ Detects degraded cells (Gap 3 mitigation) | ❌ No |
| Discharge/cycle mode | ✅ Can recondition and identify weak cells | ❌ No |
| Dual channels | ✅ 2 batteries simultaneously | ❌ Single battery |
| Charge current options | ✅ 0.1–10A configurable | Fixed 1A only |

**The IR meter directly addresses Gap 3** (reverse-cell failure mode). A degraded cell with rising internal resistance is the precursor to a thermal event in a series NiMH pack. The RDX2 200 lets you measure IR and retire packs before they become hazards. The simple charger gives you a green LED.

**The simple charger's unknown termination is concerning, not just a performance issue.** If it's timer-based (common in $15 chargers), it will overcharge a partially-charged battery — exactly the scenario FDK warns against. If it uses crude voltage threshold instead of delta-V, it may cut off too early (leaving batteries undercharged) or too late (overcharging). At 1A (~0.33C for a 3Ah pack), delta-V detection is feasible but faint — Battery University notes that below 0.5C, negative delta-V is weak and can be missed. The simple charger's 0.07A trickle (0.023C for 3Ah) is within safe range per manufacturer specs, but the product page warns *"leaving a battery on the charger for extended periods of time can degrade its performance"* — acknowledging the trickle isn't benign indefinitely.

**FTC community consensus aligns.** Multiple FTC forum threads (firstinspires.org, r/FTC) note that *"the 'official' charger isn't particularly smart"* and recommend upgrading. Experienced FTC mentor (5294-jjkd): *"NiMH batteries require some care to manage well. Some chargers will treat the batteries better than others."* Another: *"I highly recommend a smart charger even just for battery life time."*

**Expert/reviewer feedback on Hitec RDX2 line:**
- Big Squid RC reviewed the RDX2 family favorably — "worked flawlessly," charge quality indistinguishable from $400 iCharger units. Noted the menu is intuitive for experienced users but beginners should read the manual.
- AMain Hobbies verified buyers: uniformly positive (4-5 stars). One bought it specifically after a LiPo fire incident with a cheaper charger.
- No recalls, no confirmed safety incidents for the RDX2 200 or its siblings. (Note: a YouTube reviewer's RDX2 1600 Duo — a different, $500+ product — smoked during a live stream, but the reviewer suspected his own wiring error with a custom 25V battery bank setup. Not comparable to normal FTC use.)
- The HTRC C240 recall (2024, US government safety hazard designation for causing fires) applies to a different brand entirely — HTRC is a Chinese generic, not Hitec RCD. Do not conflate them.

### Charger Recommendation

**For teams with 4+ batteries or competition use: Hitec RDX2 200.** The IR measurement alone justifies the cost as a safety tool (Gap 3 mitigation), the delta-peak + temp sensor + backup timer provide proper charge termination (this section's core requirement), and dual channels halve charging time at tournaments. One-time setup with goBILDA's published settings.

**For teams with 1-2 batteries and tight budget: the simple charger is adequate but not ideal.** It works. NiMH is forgiving enough that even imperfect charge termination is unlikely to cause a fire at 1A. But it provides zero diagnostics — you're flying blind on battery health. Pair it with a Battery Beak ($30) to partially compensate.

**For either charger:** never leave unattended, charge on non-combustible surface, and follow the operational controls in this document.

---

## Gap 5: Electrical Load — 10+ Batteries on One Garage Circuit

Completely unaddressed. This is a real fire risk that has nothing to do with batteries.

- Typical garage outlet: **15A circuit** (1,800W)
- A NiMH charger drawing 1-2A at 12V is ~12-24W each — 10 chargers = 120-240W — probably fine
- **BUT:** if teams also run power tools, shop lights, space heaters on the same circuit, or use extension cords / daisy-chained power strips, the circuit can overload
- Extension cords and power strips are the #1 cause of residential electrical fires (NFPA data)

**What I should have said:** "Don't daisy-chain power strips. Use a single heavy-duty power strip with a built-in circuit breaker. Know which outlets share a circuit. Don't charge batteries on the same circuit as high-draw equipment (compressor, shop vac, space heater)."

---

## Gap 6: The Youth Team Factor

These are teenagers. I wrote procedures for responsible adults.

**Realistic failure scenarios with teens:**
- Charging a battery they know is damaged because they need it for practice tomorrow
- Forgetting batteries on the charger overnight (or over a weekend)
- Using the wrong charger settings (wrong cell count, wrong chemistry mode)
- Leaving before charging is done, nobody monitors
- Stacking batteries loosely, terminals exposed, near metal tools

**What the recommendation should include:**
- **One designated "battery person"** responsible for all charging
- **Buddy system:** charging only happens when 2+ people are present
- **Adult check-in** before any charging session in the garage
- **Damaged battery quarantine:** a separate labeled container where suspect batteries go, away from the charging station, and an adult decides disposal
- **The rules poster matters more than the hardware** — if nobody reads it, the fire extinguisher doesn't help

---

## Gap 7: Homeowner Liability

A garage team means someone's family is hosting. If a fire starts:
- **Homeowner's insurance** may or may not cover fire from a robotics charging operation — this varies by policy
- If the fire is attributed to negligence (e.g., unattended charging), claims can be denied
- The host family should **check with their insurance agent** about the charging activity
- The team should have **FIRST's team insurance** active (FIRST provides general liability coverage to registered teams)

I gave zero mention of this. For a parent hosting 10+ batteries charging in their garage, this is a real concern.

---

## Revised Recommendation (Filling the Gaps)

### Primary Safety Controls (in priority order)

1. **Battery health monitoring** — Battery Beak every battery, every month. Retire degraded cells. This prevents the reverse-charging failure mode that is the actual NiMH risk for FTC series packs.

2. **Quality charger with delta-peak + temperature cutoff + backup timer** — The charger is the most important piece of safety equipment. Not the container.

3. **Non-combustible charging surface + basic metal containment** — A metal tray on a concrete paver. An ammo can with gasket removed is cheap and justified, even for NiMH. Not because NiMH will produce LiPo-style fire jets, but because it contains any plausible event (overheating cell, melting charger, electrolyte leak).

4. **Ventilation** — Crack the garage door or open a window during charging. Especially if gas water heater or furnace with pilot light is present. Hydrogen rises and can ignite on pilot lights.

5. **Electrical safety** — One heavy-duty power strip with circuit breaker. No daisy-chaining. No sharing circuit with high-draw tools during charging.

6. **ABC fire extinguisher** (5 lb+) accessible within 10 feet of charging area.

7. **Smoke detector** above charging area.

### Operational Controls (the teen-proof layer)

8. **Designated battery person** + buddy system (2+ people present during charging).

9. **Damaged battery quarantine container** — separate, labeled, adult-decides.

10. **Written charging procedures posted on the wall** — include charger settings, max charge time, what to do if a battery feels hot.

11. **No overnight charging.** If the session ends, batteries come off the charger.

12. **Host family checks homeowner's insurance** for coverage of the activity. Team insurance through FIRST should be active.

### Hardware (~$40-60)

| Item | Cost |
|------|------|
| .50 cal ammo can, gasket removed (battery containment during charging) | $15 |
| Concrete paver (base insulation) | $2 |
| Hitec RDX2 200 charger (delta-peak + temp sensor + IR meter + dual channel) | $140 |
| Heavy-duty power strip with circuit breaker | $15 |
| ABC fire extinguisher, 5 lb | $20-30 |
| Smoke detector | $5 |
| Battery Beak or IR meter | ~$30 (one-time, may already own) |

---

## What Changed From the Previous Recommendation

| Previous | Revised | Why |
|----------|---------|-----|
| "NiMH is extremely unlikely to fire" | NiMH can overheat, vent hydrogen, burst. Risk is lower than Li-ion but not negligible. | FDK manufacturer warnings, CandlePower expert, Endless-Sphere incident reports |
| No charger guidance | Hitec RDX2 200 recommended; simple $15 charger adequate but blind. Charger with delta-peak + temp sensor + IR meter is the #1 control | SilverFox: most charger meltdowns are from hot cells. Simple charger's unknown termination method is a real gap. IR measurement directly mitigates reverse-cell failure (Gap 3). FTC community consensus: stock charger is "not particularly smart." |
| "Timer outlet as backstop" | Quality charger has its own backup timer; external timer is secondary | Delta-peak detection + temperature cutoff are the proper controls |
| No ventilation guidance | Crack garage door during charging | Hydrogen LEL at 4%, pilot lights in garages are ignition sources |
| No electrical load discussion | One power strip, no daisy-chaining | Extension cord fires are #1 residential electrical fire cause (NFPA) |
| Adult procedures | Teen-proofed: buddy system, battery person, no overnight charging | These are 14-18 year olds in someone's garage |
| No insurance mention | Check homeowner's insurance, verify FIRST team insurance | Real liability concern for host family |
| Ammo can was "overkill" | Ammo can is justified as proportionate containment | NiMH manufacturer warnings justify basic metal containment |
