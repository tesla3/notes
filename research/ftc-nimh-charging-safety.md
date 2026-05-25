# FTC NiMH Charging Safety: goBILDA Nested Battery

Source: goBILDA user manual (SKU 3100-0012-0020), Hitec RDX2 200 product page, FTC Game Manual R601, FDK NiMH handling precautions, GMSTC NiMH Battery Fact Sheet, Battery University BU-410 (charging at temperature extremes), Linden & Reddy *Handbook of Batteries* 4th ed., Fisher Scientific KOH SDS, TI Application Report SLUA516 (NiMH/NiCd charging basics), Panasonic NiMH Technical Handbook, IEC 61951-2 (NiMH secondary cells), r/FTC community experience.
Date: 2026-04-01

---

## The Battery

goBILDA 12V NiMH Nested Battery (3100-0012-0020). $64.99.

- 10× Sub-C NiMH cells in series. 3000mAh. 12V nominal.
- XT30 connector — polarized, keyed. Cannot be plugged in backwards.
- 20A ATM mini blade inline fuse. Never replace with higher.
- 16AWG wire. 597g.
- Max discharge: 30A (fuse-limited to 20A).
- "Nested" form factor: designed to sit inside goBILDA 1120 Series U-Channel on the robot.
- Made FTC-legal in the 2024–25 season.
- Electrolyte: **potassium hydroxide (KOH)** — a strong caustic base. Causes severe skin burns and eye damage if leaked.

Energy content: 36Wh. For scale — a phone battery is ~15Wh, a LiPo drone pack is ~50–80Wh. A cordless drill battery is ~40–90Wh. NiMH at FTC scale is low-energy compared to most household battery packs.

### Why Cells Drift: Imbalance in Series Packs

This is a 10-cell series pack with **no per-cell balancing** (unlike Li-ion packs with a BMS). Over charge/discharge cycles, individual cells inevitably drift in capacity and internal resistance. This imbalance is the root cause of the two most dangerous failure modes below (reverse-cell during discharge, unpredictable behavior during charge). Pack voltage masks cell-level problems — you can't see imbalance with a multimeter on the pack terminals.

The manufacturer-recommended cycling procedure (discharge to 10V, rest, charge to full) works because:
- Deep discharge brings all cells to a similar low-SOC baseline.
- Full charge from that baseline tends to equalize cells better than charging from random SOC.
- The process breaks down ordered crystalline phases (voltage depression / "memory effect") primarily associated with the nickel hydroxide positive electrode (Linden & Reddy §29.4.6). The exact NiMH mechanism is less definitively established than in NiCd — some literature discusses negative electrode surface passivation as a contributing factor — but deep cycling addresses it regardless of which electrode dominates.

This is why cycling isn't optional maintenance — it's the only tool available to manage imbalance in a pack without individual cell access.

---

## The Binding Standard

FTC Game Manual R601: *"Batteries should be charged in accordance with manufacturer's specification."*

This makes the goBILDA user manual the authoritative charging and safety reference. Not forum posts, not generic NiMH datasheets. The manufacturer's spec is the rule. Everything below builds on what that manual says and where it falls short for a garage team.

---

## What the Manufacturer Says

### Charging (§1.1)

- **Do not leave charging batteries unattended.**
- Monitor battery heat. If hot, remove from charger immediately and discontinue use.
- Ambient temperature: 0–40°C (32–104°F).
- Recommended charge rate: **1A**. Rapid up to 3A acceptable but degrades performance over time.
- Remove from charger once fully charged. Trickle charge is for short-term peak hold only — extended trickle degrades performance.

### Cycling / Conditioning (§1.2)

- Discharge at 0.4–0.6A to 10V, rest 10 min, charge at 1A.
- Cycle new batteries before first use.
- Cycle after recharge from storage voltage.
- Cycle can restore degraded batteries.
- Recommended every 3 months.

### Storage (§1.3)

- Storage voltage: ~10V (never below 9V).
- Store dry, between −20°C and 40°C.
- Cycle every 3 months in storage.
- If cycling isn't possible, store above 10V so drift doesn't cross 9V.

### Absolute Floor

- **Never use below 9V** (open-circuit, after rest). Permanent damage. "Unloaded" means open-circuit voltage measured with a multimeter **after at least 15 minutes of rest** — not immediately after disconnecting the robot. NiMH voltage rebounds significantly once the I×R drop disappears; a pack that reads 8.5V under 15A load may recover to 10V+ after resting. The 10-minute rest in the cycling procedure (§1.2) exists for this reason. (Source: standard battery testing practice; IEC 61951-2 specifies OCV measurement after rest period.)

---

## The Two Chargers

goBILDA sells two chargers. The choice between them is the single most consequential safety decision for a garage team.

### Basic Charger ($14.99, SKU 3101-0012-0001)

Wall-wart style. 1A charge, drops to 0.07A trickle when full. LED: red = charging, green = done. XT30 connector, plug and play.

**What it lacks:**

- No temperature sensor. No dT/dt termination backup.
- No backup timer. The charger uses an **unspecified full-charge detection method** (goBILDA does not document whether it is delta-peak, voltage threshold, or other). If that detection fails for any reason — degraded cells, temperature extremes, charger electronics drift — the charger has no secondary cutoff and will continue charging at 1A indefinitely.
- No discharge function. Cannot perform manufacturer-recommended cycling.
- No IR measurement. Cannot assess battery health.
- Trickle (0.07A ≈ C/43) is indefinite. C/43 is at or below the standard NiMH maintenance trickle rate (C/40 to C/30, per Panasonic/FDK specs), so the oxygen recombination cycle manages it short-term. A few days is unlikely to cause harm, but over **weeks** (school breaks, vacations) sustained trickle causes cumulative heat stress, electrolyte dry-out, and capacity degradation.

This is what most budget FTC teams will buy. It works correctly under normal conditions. It has no defense against abnormal conditions.

### Hitec RDX2 200 ($139.99, SKU 44370)

Full smart charger. 2 ports, 100W each. Multi-chemistry (NiMH/NiCd/LiPo/LiFe/Li-Ion/Pb, 1–15 cells NiMH). Delta-peak detection (−5mV/cell — see note below), configurable charge rate (0.1–10A), backup timer, discharge/cycle modes, IR measurement, battery resistance meter. AC/DC input. Includes XT60-to-XT30 adapters.

**Delta-peak sensitivity: −5mV is per cell.** For a 10S pack, this means the charger looks for a **50mV total drop** across the entire pack. This is the standard convention in hobby charger firmware. (Source: RC community documentation; confirmed in the goBILDA setting "Condition: −5 ΔmV" which follows Hitec's per-cell convention.)

**Temperature sensor port:** The Hitec has a temperature probe input. The dT/dt (rate of temperature rise) termination method is **more reliable than delta-peak for NiMH** because:
- Delta-peak (−dV) requires charge rates ≥C/2 for reliable detection (per TI application guidance). At 1A into 3Ah (C/3), delta-peak is near its reliability limit.
- dT/dt is more reliable than −dV across a wider range of charge rates — particularly at C/3 to 1C where −dV may be marginal — and at temperature extremes where −dV false-triggers. Below ~C/5, dT/dt also becomes less reliable as the temperature rise signal approaches ambient noise (TI SLUA516).
- It provides an absolute temperature cutoff as an additional safety net.

**Charge rate vs. detection reliability tradeoff:** The manufacturer recommends 1A (C/3) for longevity, but delta-peak detection is more reliable at ≥C/2 (≥1.5A) where the voltage peak-and-drop is more pronounced. For competition-day charging where reliable termination matters most, charging at **1.5–2A** (C/2 to 2C/3) produces a cleaner −dV signal at the cost of slightly reduced cycle life. This tradeoff is most relevant when no temperature probe is available for dT/dt backup. At 3A (1C), delta-peak is fully reliable but battery degradation accelerates per manufacturer — reserve for emergencies.

**Use the temperature probe.** Attach it to the battery pack during charging. Configure dT/dt termination as a secondary cutoff alongside delta-peak. Set absolute temperature cutoff to 45°C. This provides redundant charge termination — if delta-peak fails, temperature rise still stops the charge.

goBILDA publishes FTC-specific settings for it:
- Battery Type: NiMH
- Cell Count: 10S (12.0V)
- Condition: −5 ΔmV (per cell; 50mV total pack drop)
- Charge Current: 1A recommended, up to 3A for competition

Can perform all manufacturer-recommended maintenance (cycling, IR testing, storage discharge). This is the correct charger for any team that takes battery safety and longevity seriously.

**⚠️ Smart charger misconfiguration risk:** The Hitec charges 7 chemistries at up to 10A. If accidentally set to LiPo mode, it would target 4.2V/cell × 10 = **42V** on a 12V NiMH pack — catastrophic overvoltage causing venting/rupture/fire. If set to 10A, that's 3.3C — well above the manufacturer's 3A limit. **Save the correct NiMH 10S / 1A profile in the charger's memory slots. Label the slot. Train all team members to verify "NiMH / 10 cells" on the charger display before every charge. Never let the charger auto-detect cell count on a NiMH pack.**

**The tension:** The charger costs 2× the battery. A team buying 3 batteries ($195) will default to basic chargers ($15–30) unless someone makes the case for the Hitec. Middle-ground options exist — hobby-grade NiMH chargers with delta-peak, timer cutoff, and discharge capability:

| Charger | Price | NiMH Cell Support | Notes |
|---------|-------|-------------------|-------|
| Hitec RDX2 200 | ~$140 | 1–15S | goBILDA ecosystem match. 2 ports. Best option. |
| ISDT 608PD | ~$85 | 1–16S | Compact, USB-C input, app control. Confirmed 10S NiMH. |
| SkyRC IMAX B6 V2 (genuine) | ~$45–55 (+$15–25 PSU) | 1–15S | Well-proven. **DC input only — needs a separate 11–18V power supply, not included.** Budget the PSU. |

**⚠️ Avoid IMAX B6 clones** (~$20–30 on Amazon). Counterfeit B6 chargers are ubiquitous and have unreliable delta-peak detection, poor calibration, and no safety certification — the exact failure mode this document warns about. In a safety context, a $25 clone undermines the entire purpose of upgrading from the basic charger. Buy genuine SkyRC from a reputable hobby retailer (HobbyKing, AMain Hobbies).

---

## Failure Modes in Priority Order

### 1. Charger Overshoot (Most Likely)

**What happens:** Basic charger fails to detect full charge. Continues at 1A into a full pack. Cells heat up. Internal pressure rises. Vent activates. Hydrogen gas released. Electrolyte (KOH — caustic) can leak. In sustained overcharge: cell can bulge, burst, or (per FDK) catch fire.

**Why it happens:** The basic charger uses an unspecified full-charge detection method with no backup cutoff. If the detection fails — due to degraded cells, temperature extremes, or charger electronics drift — 1A flows into a full pack indefinitely. Even with a smart charger, delta-peak detection can fail: degraded cells produce a flattened voltage curve, high ambient temperature shifts the voltage profile, and a detection sensitivity of −5mV/cell is near the noise floor for a 10-cell pack.

**Mitigation:** Smart charger with backup timer + dT/dt temperature termination. Or: basic charger + mechanical outlet timer set to **4.5 hours** (see charge time math below). The outlet timer is crude but effective — it limits the maximum possible overcharge duration regardless of what the charger does or fails to do.

**Charge time math:** NiMH charge efficiency is **not** 100%. At C/3 (1A into 3Ah), cells require ~115–125% of rated capacity as charge input due to oxygen recombination losses and resistive heating, especially above 70% SOC. Input needed: 3.0Ah × 1.15–1.25 = **3.45–3.75Ah**. Time at 1A: **3.45–3.75 hours** from empty. A 4.5h timer gives ~45–65 min of margin. (Sources: Linden & Reddy §29.4, charge factor 1.2–1.5 depending on rate/temp; CandlePowerForums empirical data: 110–120% at 0.5C.)

**Note on partial charges:** If charging a battery that's at 50% SOC, a 4.5h timer provides too much runway. For partial charges, a smart charger with delta-peak + timer + dT/dt is the only robust answer. With a basic charger, there's no way to set the timer correctly without knowing starting SOC.

### 2. Cold-Garage Charging (Most Overlooked)

**What happens:** Team charges batteries in an unheated garage during build season. Below 5°C (41°F), NiMH cells lose the ability to recombine oxygen produced during charging. Pressure builds inside cells. Can cause venting, electrolyte leak, or cell rupture. Simultaneously, delta-peak detection becomes unreliable — pressure-induced voltage drops mimic full-charge voltage drops, causing either false termination (battery undercharged) or missed termination (battery overcharged).

**Why this matters for FTC:** Build season runs November through March. An unheated garage in the northern US (Minnesota, Michigan, New England) easily drops below 5°C. This overlaps perfectly with peak charging activity. Hot garages (summer, southern US) are equally dangerous: at 45°C, NiMH charge acceptance drops to ~70%; at 55°C, commercial NiMH accepts only 35–40% of charge input — the rest becomes heat, creating a positive feedback loop.

**Sources:** Battery University BU-410: *"The ability to recombine oxygen and hydrogen diminishes when charging nickel-based batteries below 5°C. If charged too quickly, pressure builds up in the cell that can lead to venting. Reduce the charge current to 0.1C when charging below freezing."* Also: *"NDV for full-charge detection becomes unreliable at higher temperatures, and temperature sensing is essential for backup."*

**Mitigation:** Charge between **10°C (50°F) and 35°C (95°F)**. If the garage is cold, bring batteries inside the house to charge. If charging must happen in a cold space, reduce charge rate to 0.3A or lower and use a temperature-probe-equipped smart charger. Never fast-charge (3A) in a cold environment.

**The inverse problem — charging a hot battery:** After a hard FTC match, cells can be 35–45°C from I²R heating at 15–20A. Immediately plugging into the charger compounds the problem: charge acceptance is already reduced at elevated cell temperature, so more input energy becomes heat rather than stored charge — a positive feedback loop that worsens at higher charge rates. Delta-peak detection is also less reliable on the flattened voltage curve of hot cells. **Rest batteries for 15–30 minutes before charging after robot operation.** Touch-test: if the pack is warm to the touch, wait. With a temperature probe: wait until ≤30°C. This is especially critical for competition-day rapid charging at 3A. (Source: Panasonic NiMH Technical Handbook §5.1.)

### 3. Reverse-Cell During Deep Discharge (Most Consequential)

**What happens:** One weak cell in the 10-cell series pack reaches 0V before the others. The remaining 9 cells force current through it in reverse. The weak cell heats dramatically — all pack energy dissipates as heat in that one cell. Can cause venting, rupture, electrolyte (KOH) leak. Damage is internal and invisible.

**When it happens:** During robot operation, not charging. A hard-fought match that drains the battery. A practice session that runs too long. The danger materializes on the **next charge** — the already-damaged cell behaves unpredictably under charge current.

**Why the 9V floor doesn't fully protect:** 9V is a pack-level measurement. In a mismatched pack, one cell can be at 0.1V while the pack reads 10V+ — above the warning threshold. Pack voltage masks cell-level danger. This is a direct consequence of cell imbalance in a series pack with no per-cell BMS.

**Mitigation:** IR testing after every competition day, especially after matches where the robot lost power or behaved erratically. The Hitec RDX2 measures IR directly. A multimeter and IR-capable charger are the practical tools (the Battery Beak, once the FTC-standard tool, appears discontinued as of 2025 — verify availability before recommending). Track IR relative to each pack's own baseline — see §Practical Recommendations for approximate thresholds. Rising IR = retire the pack to practice, then to disposal.

**⚠️ Reverse-cell risk during cycling discharge:** The same reversal mechanism can occur during the manufacturer-recommended cycling procedure. When discharging a 10S pack to 10V (1.0V/cell average), the weakest cell may reach 0V while the pack is still above 10V — the charger sees only pack voltage and has no per-cell visibility. The mitigating factor is rate: cycling discharge at 0.4–0.6A produces far less thermal stress in a reversed cell than 15–20A robot operation. But for a pack suspected of significant imbalance (after extended storage, after a deep discharge incident), discharge at the **lowest available rate** (0.1A if the charger supports it) and monitor for unusual heat. If a pack already has a known bad cell (high IR, low capacity), cycling won't fix it — retire. (Source: Linden & Reddy §29.5.2.)

### 4. Mechanical Damage from Robot Impacts (Invisible)

**What happens:** FTC robots crash, get hit by other robots, and drive off platforms. The battery sits in a U-channel — somewhat protected but not shock-isolated. Impacts can cause:
- **Spot-weld fractures** between cells → high-resistance joint → localized heating during discharge or charge → potential thermal event.
- **Cell casing cracks** → KOH electrolyte leak → corrosive damage to robot wiring and components.
- **Wire/connector stress** → intermittent connection → arcing under 15–20A load.

These failures are insidious because they're internal and invisible. A battery that "looks fine" after a hard match may have a compromised weld that heats up catastrophically during the next charge or heavy discharge.

**Mitigation:** After any match where the robot took a significant hit: check battery voltage (sudden drop from expected = possible cell disconnect), check IR if smart charger is available, physically inspect for deformation, bulging, or white crystalline residue (dried KOH). If IR has jumped significantly from baseline, retire the pack.

### 5. Extended Trickle / Left on Charger (Common)

**What happens:** Battery left on basic charger for extended periods. 0.07A (C/43) trickle continuously. At C/43 — at or below the standard NiMH trickle rate (C/40 to C/30 per Panasonic/FDK specs) — the oxygen recombination cycle manages the overcharge current short-term. A few days is unlikely to cause harm. Over **weeks** (school break, forgotten after practice, vacation), cumulative heat stress from continuous oxygen recombination accelerates electrolyte dry-out and capacity degradation. Over months, pressure buildup and potential venting become possible.

**Mitigation:** Remove batteries from charger after green LED. Outlet timer as backstop. Timescale guidance: a weekend is low-risk; one week is borderline (remove if possible); two or more weeks causes real degradation; a school break or vacation — never leave connected.

### 6. Charging in the U-Channel (Plausible)

**What happens:** Team charges battery while still mounted in the robot's 1120 U-Channel. Aluminum channel restricts airflow on 3 sides. Heat builds up. Temperature-sensitive peak detection (if using smart charger) may be affected. Can't visually inspect or touch the battery.

**Manufacturer says:** *"Monitor battery heat."* — impossible if battery is enclosed in a channel.

**Mitigation:** Always remove battery from robot before charging.

### 7. Off-Season Storage Decay (Slow but Damaging)

**What happens:** Batteries stored at end of season (May) without proper preparation. Standard NiMH Sub-C cells (likely what the goBILDA pack uses — LSD Sub-C is rare at this price point) self-discharge at approximately **20–30% of remaining capacity per month** at room temperature (Panasonic NiMH Technical Handbook §7.1; Energizer NiMH Engineering Data). Whether the goBILDA cells are standard or LSD is unconfirmed, but the price point and form factor suggest standard. Cells self-discharge unevenly — this uneven self-discharge is a major driver of cell imbalance.

Critical context: the recommended storage voltage of ~10V (1.0V/cell) is already near the bottom of the NiMH discharge curve — cells are at roughly 5–15% SOC. At this low SOC, even modest self-discharge over 1–2 months can push weak cells below 0.9V. By September, weak cells may be well below 0.9V individually. First charge attempt can stress reversed cells.

**Manufacturer says:** Discharge to 10V for storage. Cycle every 3 months. If can't cycle, store at higher voltage.

**Mitigation:** End-of-season protocol: if committing to cycle every 3 months through the off-season, discharge to 10V per manufacturer spec. If cycling is uncertain, store at **11–11.5V** (1.1–1.15V/cell, ~30–50% SOC) instead — the higher starting SOC provides self-discharge runway before crossing the 9V damage floor. Cycle in July at the latest — with standard NiMH self-discharge rates, 3 months is near the maximum safe interval from storage voltage. First-of-season: cycle before use. All of this requires a discharge-capable charger.

---

## What Does NOT Meaningfully Apply

### Hydrogen Explosion in the Garage

Hydrogen LEL is 4% by volume. A two-car garage is ~50,000 liters. Even 100 cells (10 batteries) all simultaneously venting produce a theoretical maximum of ~7 mL H₂/min/cell = 700 mL/min total (Faraday's law, assuming 100% of overcharge current converts to hydrogen). In practice, actual hydrogen production is **far lower** — NiMH cells are engineered with excess negative electrode capacity so the dominant overcharge reaction is oxygen evolution at the positive electrode, which recombines at the negative electrode in a closed loop. Hydrogen is a minority byproduct, typically 5–15% of the Faraday's-law maximum. (Source: Linden & Reddy §29.6, FDK NiMH technical handbook §4.2.)

Even using the worst-case theoretical number: time to reach LEL in the garage would be ~47 hours in a perfectly sealed room. Not physically plausible at FTC scale. The Zomeworks hydrogen FAQ (cited in the earlier gap analysis) describes industrial lead-acid battery rooms — wrong chemistry, wrong scale by orders of magnitude.

**Local hydrogen concern is real only inside enclosures** — e.g., an ammo can or sealed container. Don't charge in sealed containers. Open-air charging with normal room ventilation is sufficient.

### Ammo Can Containment

Wrong for NiMH. NiMH failure products are heat and hydrogen gas. An ammo can traps both. Creates a small volume where hydrogen can reach LEL. Creates an oven that worsens thermal events. Blocks visual/tactile monitoring.

Ammo cans are appropriate for LiPo (containing flame jets). For NiMH: metal tray, open air, non-combustible surface.

### The 20A Fuse During Charging

The fuse protects against discharge-side overcurrent and short circuits on the robot. During charging at 1–3A, the 20A fuse is electrically invisible. It provides **zero protection** against any charging failure mode.

---

## Practical Recommendation for a Garage Team

### Tier 1: Non-Negotiable

1. **Remove battery from robot before charging.** Don't charge in the U-channel.
2. **Charge on a non-combustible surface.** Metal tray on concrete floor or paver. Open air, not enclosed.
3. **Outlet timer** set to **4.5 hours** if using the basic charger (charging from empty). This accounts for NiMH charge inefficiency (~115–125% input factor at C/3). For partial charges from ~50% SOC, ~3 hours is a rough guideline — but without knowing exact SOC, timer-based cutoff is less reliable for partial charges. If partial-charging regularly, this is a strong reason to upgrade to a smart charger. The timer is crude but limits maximum overcharge duration regardless of charger behavior.
4. **Temperature discipline — ambient AND battery.**
   - **Ambient:** Charge between 10°C (50°F) and 35°C (95°F). If the garage is below 10°C, bring batteries inside the house to charge. Cold charging causes pressure buildup and unreliable charge termination. Hot charging causes heat accumulation and reduced charge acceptance. Check with a thermometer — don't guess.
   - **Battery cool-down:** After robot operation (especially competition matches), rest batteries for **15–30 minutes** before charging. Cells can reach 35–45°C after heavy discharge at 15–20A. Charging a hot pack reduces charge acceptance — more input energy becomes heat, creating a positive feedback loop that worsens at higher charge rates. Touch-test: if warm to the touch, wait. With a temperature probe: wait until ≤30°C.
5. **Don't leave unattended.** Per manufacturer. Realistically: outlet timer is the backstop for when this rule gets broken.
6. **Stop using any battery showing these symptoms:**
   - **Physical (retire immediately):** Puffy, leaking, discolored, smells, or hot after rest.
   - **Early warning (investigate with IR test, consider retiring):** Dramatically reduced run time vs. peers, unusual heat during discharge (one section warmer than others through the shrink wrap), voltage sag under load (robot loses power earlier than expected), charger shows much lower capacity than rated during cycling, pack voltage drops noticeably overnight after a full charge (>0.5V in 24 hours suggests an internal micro-short — distinct from normal self-discharge).
   - Quarantine suspect batteries in a labeled container away from the charging station. Adult decides disposal.
7. **If electrolyte leaks:** NiMH electrolyte is **potassium hydroxide (KOH)** — a strong caustic base (pH ~14). White crystalline residue around seals is dried KOH. Do not touch with bare hands. Wear gloves. Flush any skin or eye contact with water for 15+ minutes. Seek medical attention for eye exposure. Clean residue with dilute vinegar (acid neutralizes base), then water. (Source: Fisher Scientific KOH SDS, CAS 1310-58-3.)

### Tier 2: Strongly Recommended

8. **Smart charger with delta-peak + backup timer + dT/dt + discharge capability.** Hitec RDX2 200 ($140) is the ecosystem match. ISDT 608PD (~$85) and genuine SkyRC IMAX B6 V2 (~$45–55) are confirmed alternatives supporting 10S NiMH. **Avoid IMAX B6 clones** (~$20–30 on Amazon) — unreliable delta-peak detection and poor calibration defeat the purpose of upgrading. Buy genuine from hobby retailers (HobbyKing, AMain Hobbies).
9. **Use the temperature probe** if your charger has one. Attach to the **center of the battery pack** — cells in the middle have the least surface area for heat dissipation and run hottest. Press firmly against the shrink wrap where two cells meet, secured with tape or a rubber band. A loosely attached or end-of-pack probe reads artificially low, causing dT/dt to fire late and undermining its purpose. Configure dT/dt as secondary termination and absolute temperature cutoff at 45°C. This is more reliable than delta-peak alone, especially at C/3 rates where −dV detection is near its reliability limit.
10. **Save and verify charger profiles.** Store the correct NiMH 10S / 1A settings in a named memory slot. Verify "NiMH / 10 cells" on the charger display before every charge. A team member accidentally selecting LiPo mode would target 42V on a 12V pack — catastrophic.
11. **IR testing after every competition day.** Measure each pack's IR when new to establish a baseline (typical new 10S Sub-C NiMH pack: ~60–150mΩ total, varying by cell source and measurement method — AC impedance and DC pulse give different absolute numbers, so always use the same charger for consistency). **Track trend relative to each pack's own baseline, not absolute thresholds.** Rules of thumb: >50% increase from that pack's baseline = investigate, consider relegating to practice; >2× baseline or >2× any peer pack = retire; sudden jump between sessions (e.g., 120→250mΩ) suggests internal damage from impact or cell failure — retire immediately. Log IR for each numbered battery after every competition day.
12. **Post-impact inspection.** After any match where the robot took a significant hit: check pack voltage, check IR, inspect for deformation or white residue (KOH). A battery that "looks fine" can have internal weld fractures that create dangerous hot spots.
13. **Charge cycling every 3 months** and after storage — per manufacturer. Requires discharge-capable charger.
14. **ABC fire extinguisher** (5 lb) within reach. **Smoke detector** above charging area. Both cheap, both useful for any garage activity.

### Tier 3: Operational / Team

15. **One designated battery person** per session. Responsible for plug-in, monitoring, removal.
16. **Pre-charge checklist at the charging station** (laminated card, not a poster across the room):
    - Inspect for damage, puffing, loose wires, white residue, connector looseness/discoloration
    - Check pack voltage (multimeter, after ≥15 min rest from last use). Below 9V → quarantine.
    - Check ambient temperature. Below 10°C or above 35°C → move charging location.
    - Check battery temperature. Warm to touch after recent use → rest 15–30 min before charging.
    - Remove from robot. Place on charging tray.
    - Connect charger. Verify chemistry/cell count on display (smart charger) or LED (basic charger).
    - Set outlet timer (4.5h from empty, 3h from ~50% SOC).
    - Log battery # and start time.
17. **End-of-season protocol:** If committing to cycle every 3 months through the off-season, discharge to 10V per manufacturer spec. If cycling is uncertain, discharge to **11–11.5V** instead — the higher SOC provides self-discharge runway before the 9V floor (see §Off-Season Storage Decay for self-discharge rates). Store in dry location. Label with date, voltage, and battery number. Calendar reminder to cycle in 3 months (critical — standard NiMH can approach 9V within 3–4 months from 10V storage voltage).
18. **New batteries:** Cycle before first use per manufacturer §1.2. Expect **~80–90% of rated capacity on the first cycle** — NiMH cells need 3–5 full charge/discharge cycles for the electrodes to fully activate (the "forming" process). Whether goBILDA pre-forms packs at the factory is unknown; their recommendation to cycle before first use suggests not. Don't judge a new battery by its first cycle, and don't push it harder to compensate for apparently low runtime. Plan forming cycles before the first competition. (Source: Panasonic NiMH Technical Handbook §3.1.)
19. **XT30 connector maintenance.** XT30 connectors have limited mating cycle life. Repeated daily plugging/unplugging can loosen contacts. A loose XT30 under 15A creates localized heating. Inspect connectors for looseness or discoloration at each pre-charge check.
20. **Host family verifies homeowner's insurance** covers the activity. This is general good practice for any youth activity in a home — NiMH at 36Wh is lower energy than a cordless drill battery, so the risk profile is modest. Team's FIRST registration includes general liability coverage — keep it current.
21. **Disposal.** Retired NiMH packs contain nickel, cobalt, and rare earth metals — recycle, don't trash. **Call2Recycle** (call2recycle.org) offers free drop-off at most Home Depot, Lowe's, and Staples locations in the US. Tape over the XT30 connector before transport to prevent accidental short circuit.

### Hardware List

| Item | Cost | Why |
|------|------|-----|
| Metal tray (cookie sheet / baking pan) | $5–10 | Non-combustible charging surface |
| Concrete paver (optional, under tray) | $2 | Thermal insulation from workbench |
| Mechanical outlet timer | $5–8 | Backup cutoff for basic charger. Set to 4.5h. |
| Thermometer (garage) | $5–10 | Verify charging ambient is 10–35°C |
| Smart charger (if upgrading from basic) | $45–140 | Delta-peak, dT/dt, timer, discharge, IR. The real safety investment. |
| Temperature probe (if not included with charger) | $5–10 | dT/dt termination — more reliable than delta-peak alone |
| ABC fire extinguisher, 5 lb | $20–30 | General garage safety |
| Smoke detector | $5 | Early warning |
| Multimeter | $10–20 | Voltage / basic health checks |
| Nitrile gloves (box) | $8 | KOH electrolyte handling if leak occurs |
| Permanent marker + masking tape | $2 | Label batteries with number, date, status |

Total with basic charger: ~$55–70. Total with smart charger upgrade: ~$100–210.

---

## Key Numbers

| Parameter | Value | Source |
|-----------|-------|--------|
| Recommended charge rate | 1A | goBILDA manual |
| Max rapid charge rate | 3A (degrades battery) | goBILDA manual |
| Charge time from empty at 1A | ~3.5–3.75 hours | 3Ah × 1.15–1.25 charge factor ÷ 1A |
| Outlet timer setting (from empty) | 4.5 hours | ~3.75h charge + ~45 min margin |
| Outlet timer setting (from ~50% SOC) | 3 hours | ~1.9h charge + ~1h margin |
| Voltage floor (never use below) | 9V unloaded | goBILDA manual |
| Storage voltage | ~10V (above 9V) | goBILDA manual |
| Cycling interval | Every 3 months | goBILDA manual |
| Ambient charge temperature (mfr spec) | 0–40°C (32–104°F) | goBILDA manual |
| Ambient charge temperature (recommended) | 10–35°C (50–95°F) | Battery University BU-410 |
| Ambient storage temperature | −20–40°C (−4–104°F) | goBILDA manual |
| Energy content | 36Wh | 12V × 3Ah |
| Inline fuse | 20A ATM mini blade | goBILDA manual |
| Basic charger trickle | 0.07A (indefinite) | goBILDA charger spec |
| Delta-peak sensitivity (Hitec) | −5mV/cell (50mV total for 10S) | goBILDA Hitec product page |
| Electrolyte | Potassium hydroxide (KOH), pH ~14 | NiMH chemistry; Fisher SDS |
| Self-discharge rate (standard NiMH) | ~20–30% of remaining capacity/month at 25°C | Panasonic NiMH Technical Handbook §7.1 |
| New pack IR baseline (10S) | ~60–150mΩ (varies by cells and measurement method) | Empirical; track relative trend |
| Battery cool-down threshold | ≤30°C before charging | Panasonic NiMH Technical Handbook §5.1 |
| Forming cycles for new cells | 3–5 cycles to reach rated capacity | Panasonic NiMH Technical Handbook §3.1 |
