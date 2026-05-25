# Critical Review: FTC NiMH Charging Safety Note

Source: Expert review of personal_notes/research/ftc-nimh-charging-safety.md
Date: 2026-04-01

---

## Overall Assessment

The document is well-structured, correctly prioritized, and above-average for FTC community writing. The failure-mode analysis is sound in direction. The hydrogen debunking and ammo-can warning are genuinely valuable — most FTC teams cargo-cult LiPo safety theater onto NiMH without understanding the different failure physics.

That said, there are **seven substantive gaps** and **four technical imprecisions** that matter for a document intended to guide real safety decisions.

---

## 1. Technical Corrections

### 1.1 Charge Time Math Is Wrong — Timer Margin Is Overstated

The document states:
> "3Ah ÷ 1A = 3h from empty" → timer at 4h → "1h margin"

This assumes 100% charge efficiency. NiMH charge efficiency is **not** 100%.

NiMH cells require **110–125% of rated capacity** as charge input at C/3 rates (1A into 3Ah). At lower rates the overhead is even worse: ~140–160% at C/10. The reason: exothermic oxygen recombination at the negative electrode and resistive losses both increase as SOC rises above ~70%, where charge acceptance drops sharply.

**Corrected math:**
- Input needed: 3.0Ah × 1.15–1.25 = **3.45–3.75Ah**
- Time at 1A: **3.45–3.75 hours**
- A 4-hour timer gives **15–33 minutes** of margin, not 60.

This matters: if a team charges a battery that's at 20% SOC (not empty — the common case after a practice session), the timer may cut off *before* peak detection triggers, leaving the battery incompletely charged. Conversely, if they start from a nearly full battery, the 4h timer provides very little overcharge protection.

**Recommendation:** Change the timer guidance to **4.5 hours** from empty, and add a note that partial charges need a shorter timer setting or (better) a smart charger.

**Sources:**
- Charge efficiency at various C-rates: jtr1962 (CandlePowerForums, 2004) — "overall charge efficiency is 90% at 1C but only 70% at 0.1C"
- Empirical input factors at 0.5C: 110–120% (CandlePowerForums thread on NiMH charge efficiency, 2009)
- Linden & Reddy, *Handbook of Batteries*, 4th ed., §29.4: NiMH charge factor 1.2–1.5 depending on rate and temperature

### 1.2 Delta-Peak Sensitivity: −5mV Is Per Cell, Not Total

The document says:
> "Delta-peak detection (−5mV)"

In hobby charger convention, the delta-peak sensitivity setting is **per cell**. For a 10S pack, −5mV/cell means the charger looks for a **50mV total drop** across the entire pack. This is standard and well-confirmed in the RC community.

This distinction matters because:
- If someone interprets "−5mV" as the total pack drop, they'd think the charger is looking for 0.5mV per cell — impossibly sensitive, would false-trigger constantly.
- goBILDA's published setting "Condition: −5 ΔmV" follows the per-cell convention of the Hitec firmware.

**Recommendation:** Clarify: "−5mV/cell delta-peak sensitivity (50mV total across 10S pack)."

**Source:** Australian RC Forums (2010): "the numbers refer to mV per cell. So if you set 3 on a 6-cell pack, it looks for 0.018V total drop." Multiple corroborating sources in hobby charger documentation.

### 1.3 Basic Charger Termination Method Is Assumed, Not Confirmed

The document asserts:
> "If peak detection fails, charges at 1A forever."

This assumes the basic charger uses delta-peak (−dV/dt) termination. goBILDA's product description says only: *"It has a charge current of 1.0A, which will drop to 0.07A once the battery reaches capacity."* The actual termination method is unspecified — it could be:
- Negative delta-V (delta-peak)
- Voltage plateau / dV/dt ≈ 0 detection
- Absolute voltage threshold
- A simple timer

Each method has **different failure modes**. A voltage-threshold charger wouldn't "miss a peak" — it would fail differently (e.g., temperature-shifted threshold, degraded cells never reaching the threshold). Since we don't know the method, the failure analysis is somewhat speculative.

**Recommendation:** Reframe as: "The basic charger uses an unspecified full-charge detection method. If that detection fails for any reason — degraded cells, temperature extremes, charger electronics drift — the charger has no secondary cutoff and will continue charging at 1A indefinitely."

**Source:** goBILDA basic charger product page (SKU 3101-0012-0001).

### 1.4 Hydrogen Production Rate Is Conservatively Wrong (In the Right Direction)

The document calculates 7 mL H₂/min/cell at 1A. This is the Faraday's-law maximum assuming **100% of overcharge current goes to hydrogen generation**. In reality, NiMH cells are specifically engineered to prevent this: the negative electrode has excess capacity, and the dominant overcharge reaction is **oxygen evolution at the positive electrode**, which recombines at the negative electrode in a closed loop. Hydrogen is a *minority* byproduct — typically 5–15% of theoretical maximum under normal overcharge conditions.

The conclusion (no explosive risk in a garage) is correct and actually has an even larger safety margin than stated. But the intermediate number (7 mL/min/cell) would mislead anyone who uses it in further calculations.

**Recommendation:** Add a qualifier: "7 mL/min/cell is the theoretical maximum from Faraday's law assuming 100% current→H₂ conversion; actual production is far lower because NiMH cells use oxygen recombination to suppress hydrogen generation. The real safety margin is even larger than this calculation suggests."

**Source:** Linden & Reddy, *Handbook of Batteries*, 4th ed., §29.6 (NiMH overcharge mechanism); FDK NiMH technical handbook, §4.2.

---

## 2. Missing Failure Modes

### 2.1 Cold-Garage Charging (Gap: High Priority)

**This is the single biggest gap in the document.** The note lists the 0–40°C ambient range as a spec but doesn't explain *why it matters mechanically* or how dangerous the edges are.

Battery University (BU-410) states clearly:

> "The ability to recombine oxygen and hydrogen diminishes when charging nickel-based batteries below 5°C. If charged too quickly, pressure builds up in the cell that can lead to venting. Reduce the charge current to 0.1C when charging below freezing."

And for heat:

> "NDV [negative delta-V] for full-charge detection becomes unreliable at higher temperatures, and temperature sensing is essential for backup."

**Why this matters for FTC garage teams:**
- An unheated garage in the northern US (Minnesota, Michigan, New England) easily drops below 5°C from November through March — the core of FTC build season.
- At low temperatures: charge acceptance drops, gas recombination fails, internal pressure rises, and **delta-peak detection gives false positives** (pressure-driven voltage drop mimics full-charge voltage drop). The basic charger would prematurely switch to trickle, leaving the battery undercharged. Or worse — in some scenarios the charger may *not* trigger peak detection at all, because the voltage curve flattens at low temps.
- At high temperatures (summer garage, competition venue without AC): charge efficiency drops to 70% at 45°C and 35–40% at 55°C for commercial NiMH. More energy becomes heat, creating a positive feedback loop.

**Recommendation:** Add as failure mode #2 (between Charger Overshoot and Reverse-Cell), and add to Tier 1: "Do not charge below 10°C (50°F) or above 35°C (95°F). If garage is cold, bring batteries inside the house to charge."

**Sources:**
- Battery University BU-410: "Fast charging of most batteries is limited to 5°C to 45°C. For best results, narrow to 10°C–30°C."
- TI Application Note (BQ34110 forum, 2019): "The charging current needs to be on the order of C/2 [for reliable delta-V termination]. Delta voltage becomes unreliable at low charge currents [or low temperatures]."

### 2.2 Mechanical Damage from Robot Impacts (Gap: Medium Priority)

FTC robots crash. They get hit by other robots. They drive off platforms. The battery sits in a U-channel — somewhat protected but not shock-isolated. Impacts can cause:

- **Spot-weld fractures** between cells in the series chain → high-resistance joint → localized heating during discharge → potential thermal event
- **Cell casing cracks** → electrolyte (KOH) leak → corrosive damage to robot wiring and surrounding components
- **Wire/connector stress** → intermittent connection → arcing under 20A load

These failures are insidious because they're internal and invisible. A battery that "looks fine" after a hard match may have a compromised weld that heats up catastrophically during the next charge or heavy discharge.

**Recommendation:** Add post-impact inspection protocol: after any match where the robot took a significant hit, check battery voltage (sudden drop = possible cell disconnect), check IR if a smart charger is available, physically inspect for deformation or electrolyte leak. If IR has jumped, retire the pack.

**Source:** General pack engineering practice; see also Sandia National Laboratories report SAND2017-6925 on mechanical abuse of NiMH packs in transportation applications.

### 2.3 Wrong Chemistry / Wrong Settings on Smart Charger (Gap: Medium Priority)

The Hitec RDX2 200 charges LiPo, LiFe, Li-Ion, NiCd, NiMH, and Pb. If a team member accidentally selects:

- **LiPo mode for a NiMH pack:** The charger would attempt to charge to 4.2V/cell × 10 = **42V** — catastrophically overvoltaging a pack that should peak at ~14.5V. The cells would vent, burst, or worse long before reaching that voltage, and the charger would keep pushing because it hasn't hit its LiPo termination voltage.
- **Wrong cell count (e.g., 8S instead of 10S):** Charger terminates early. Not dangerous, but frustrating — battery is undercharged.
- **Excessive charge rate:** The Hitec supports up to 10A. At 10A into a 3Ah pack, that's 3.3C — well above the manufacturer's 3A maximum and extremely harsh on the cells.

The basic charger is actually *safer* in this regard: it has no settings to misconfigure. The smart charger's versatility is also its risk vector.

**Recommendation:** Add to Tier 2: "Save the correct NiMH 10S / 1A profile in the charger's memory slots. Label the slot. Train all team members to verify 'NiMH / 10 cells' on the charger display before every charge. Never let the charger auto-detect cell count on a NiMH pack."

**Source:** This is basic smart-charger safety practice; Hitec RDX2 200 product listing confirms multi-chemistry capability (LiPo/LiFe/Li-Ion/NiCd/NiMH/Pb, 1-15 cells NiMH, up to 10A). The risk is inherent in the hardware.

### 2.4 Electrolyte (KOH) Identification and First Aid (Gap: Low Priority but Important)

The document mentions "electrolyte can leak" multiple times but never identifies what the electrolyte is or its hazards:

- NiMH electrolyte is **potassium hydroxide (KOH)** — a strong base (pH ~14 in concentrated solution).
- Per the OSHA SDS: "Causes severe skin burns and eye damage. Toxic if swallowed. May cause respiratory irritation."
- First aid for skin contact: flush with large amounts of water for 15+ minutes. For eye contact: flush for 15 minutes and seek immediate medical attention.
- White crystalline residue around a battery seal is dried KOH — corrosive. Don't touch with bare hands.

For a garage team with teenagers, knowing "this stuff burns your skin and can blind you" is more actionable than "electrolyte can leak."

**Recommendation:** Add to the "puffy/hot/leaking" warning: "NiMH electrolyte is potassium hydroxide (KOH), a strong caustic base. If leaked: do not touch with bare hands. Wear gloves. Flush any skin or eye contact with water for 15+ minutes. Seek medical attention for eye exposure. Clean leaked electrolyte with dilute vinegar (acid neutralizes base) then water."

**Source:** Fisher Scientific SDS for Potassium Hydroxide (CAS 1310-58-3); Battery University BU-410 (general electrolyte exposure guidance).

---

## 3. Missing Practical Considerations

### 3.1 Temperature-Based Charge Termination (dT/dt) — Unused Safety Feature

The Hitec RDX2 200 has a **temperature sensor port** (confirmed for the B6 V2 platform; the RDX2 shares the Hitec firmware architecture). The dT/dt (rate of temperature rise) termination method is actually **more reliable than −dV for NiMH**, because:

- It works at all charge rates (−dV requires ≥C/2 for reliable detection per TI's application guidance)
- It works at temperature extremes where −dV false-triggers
- It provides an absolute temperature cutoff as an additional safety net

The document never mentions dT/dt or the temperature probe. For a document that recommends the Hitec, this is a meaningful omission — it's like recommending a car with airbags and never mentioning you should plug in the seatbelt.

**Recommendation:** Add to the Hitec section: "Use the temperature sensor probe (if available). Attach it to the battery pack during charging. Configure dT/dt termination as a secondary cutoff alongside delta-peak. Set absolute temperature cutoff to 45°C. This provides redundant charge termination — if delta-peak fails, temperature rise still stops the charge."

**Source:** TI BQ34110 forum (2019): "The charging current needs to be on the order of C/2 [for delta-V]. [At lower rates] delta voltage method becomes void." Battery University BU-410: "Temperature sensing is essential for backup."

### 3.2 Operational Degradation Symptoms (Before Physical Symptoms)

The document says:
> "Stop using any battery that is puffy, hot, leaking, discolored, or smells."

These are **late-stage** symptoms. By the time a NiMH pack is puffy, it has already been through a severe abuse event. Earlier observable symptoms include:

- **Dramatically reduced run time** (capacity loss from cell degradation or imbalance)
- **Unusual heat during discharge** — one section of the pack being warmer than others when touched through the shrink wrap (indicates a high-IR cell dissipating energy as heat)
- **Voltage sag under load** — the robot loses power or behaves erratically before the pack voltage should be low
- **Failure to reach peak charge** — charger takes much longer than expected, or shows lower-than-expected capacity during cycling

These symptoms are the *precursors* to the physical failure indicators. Catching them early prevents the physical failure from occurring.

**Recommendation:** Add an "Early Warning Signs" subsection before the physical symptoms list. Encourage teams to track run times and flag any battery whose run time drops below 70% of its peers.

### 3.3 Budget Charger Pricing Needs Verification

The document suggests:
> "SkyRC IMAX B6 (~$25–35)"

At $25–35, you're buying a **clone**, not a genuine SkyRC product. The genuine SkyRC IMAX B6 V2 retails at **$40–55** (confirmed: HobbyKing, AMain Hobbies). Clones are ubiquitous on Amazon at $20–30, but they have:
- Unreliable delta-peak detection (the exact failure mode this document warns about)
- Poor calibration
- Questionable safety certifications

Recommending a $25 clone charger in a safety document is self-undermining.

The ISDT 608PD is confirmed to support **1–16S NiMH** (Progressive RC spec sheet) and the genuine B6 V2 supports **1–15S** (HobbyKing spec sheet). Both support 10S. ✓

**Recommendation:** Update the price range for the B6 to "$45–55 (genuine SkyRC only — avoid clones)" and add a caution about counterfeit chargers.

**Sources:** HobbyKing listing (SkyRC IMAX B6 V2, $44.99), AMain Hobbies listing ($49.99); Progressive RC (ISDT 608PD, ~$85 retail); widespread documentation of B6 clone quality issues on RCGroups and Reddit r/radiocontrol.

### 3.4 Cell Imbalance Over Time — The Invisible Degradation

NiMH series packs (unlike Li-ion with per-cell BMS) have **no cell balancing**. Over cycles, cells inevitably drift in capacity and internal resistance. This imbalance is the root cause of two failure modes the document already identifies (reverse-cell during discharge, unpredictable behavior during charge) but the document doesn't explain *why imbalance develops* or *why cycling helps*.

The cycling/conditioning procedure works because:
- Deep discharge to 1.0V/cell (10V pack) ensures all cells reach a similar low-SOC state
- Full charge from that baseline tends to equalize cells better than charging from random SOC states
- The process also breaks down crystalline formations (voltage depression / "memory effect") in the metal hydride negative electrode

Understanding this mechanism makes the "cycle every 3 months" recommendation feel purposeful rather than arbitrary, which increases compliance.

**Recommendation:** Add a brief explanation of why cycling works, tied to the cell imbalance mechanism.

---

## 4. Minor Items

| Item | Issue | Fix |
|------|-------|-----|
| Insurance mention | "Host family verifies homeowner's insurance covers the activity" — this is prudent advice but could panic parents. | Add context: NiMH at FTC scale (36Wh) is lower energy than a cordless drill battery. The insurance check is general good practice for any youth activity in a home, not specific to battery risk. |
| Battery Beak | "Battery Beak (~$30) is the FTC-specific alternative." | Battery Beak appears to be discontinued or hard to find as of 2025. Verify current availability. A multimeter + IR-capable charger may be the more realistic recommendation. |
| XT30 connector wear | Not mentioned. | XT30 connectors are rated for ~30A continuous but have a limited mating cycle life. Repeated plugging/unplugging (daily practice) can loosen contacts. A loose XT30 under 15A creates localized heating. Add to periodic inspection: "Check connector for looseness or discoloration." |
| Charger power limit | The Hitec RDX2 is 100W per port in AC mode. At 3A × 14.5V peak ≈ 43.5W — well within limits. | Not an issue, but good to confirm. No action needed. |

---

## Summary of Gaps by Priority

| Priority | Gap | Section |
|----------|-----|---------|
| **High** | Cold-garage charging — temperature effects on charge termination and safety | §2.1 |
| **High** | Charge time/timer math is wrong (margin overstated 3×) | §1.1 |
| **Medium** | dT/dt temperature termination — unused safety feature on the recommended charger | §3.1 |
| **Medium** | Wrong-chemistry risk on smart charger | §2.3 |
| **Medium** | Mechanical damage from robot impacts | §2.2 |
| **Medium** | Basic charger termination method is assumed, not confirmed | §1.3 |
| **Low** | KOH electrolyte identification and first aid | §2.4 |
| **Low** | Delta-peak per-cell clarification | §1.2 |
| **Low** | Early degradation symptoms | §3.2 |
| **Low** | Budget charger clone warning | §3.3 |
| **Low** | Cell imbalance mechanism explanation | §3.4 |

---

## What the Document Gets Right

To be clear — the foundation is solid:

- **Failure mode prioritization** is correct. Charger overshoot > reverse-cell > trickle > in-channel > storage decay is the right order.
- **Hydrogen explosion debunking** is valuable and the conclusion is sound (even more conservative than reality).
- **Ammo can warning** is exactly right and runs counter to common FTC forum advice.
- **Tiered recommendations** are practical and budget-aware.
- **Outlet timer as a low-cost safety backstop** is a genuinely clever recommendation that most teams can implement immediately.
- **The 20A fuse section** correctly identifies that it provides zero charging protection — this is a common misconception worth explicitly addressing.
- **R601 as the binding standard** is the right legal framing.

The document doesn't need a rewrite. It needs the gaps filled and the numbers corrected.
