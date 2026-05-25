# Critical Review: Fire-Safe FTC Charging Station Proposal

Date: 2026-04-01

## Verdict: The Original Proposal Has Significant Problems

The research note is mechanically sound for LiPo/Li-ion batteries but **miscalibrated for the actual FTC use case**. It contains one factual error dangerous enough to call out explicitly, overstates the threat model, and borrows risk profiles from the wrong battery chemistry. Here's the full breakdown.

---

## Error 1 (CRITICAL): Fire Extinguisher Recommendation Was Wrong

**Original claim:** "Have a fire extinguisher nearby — Class D (metal fires) for lithium."

**This is incorrect and potentially dangerous.** Three authoritative sources agree:

- **Amerex (fire extinguisher manufacturer), 2013 technical bulletin:** *"Lithium-ion batteries do not require a Class D extinguisher... Class D fire extinguishers, which contain dry powder, are intended for combustible metal fires only. Since lithium-ion batteries aren't made with metallic lithium, a Class D dry powder extinguisher would not be effective."* — [amerex-fire.com](https://www.amerex-fire.com/upl/downloads/library/29-i-need-a-class-d-extinguisher-for-lithium-ion-batteries.pdf)

- **Ansul (Lith-X manufacturer):** *"Rechargeable lithium ion batteries do NOT pose a Class D fire threat but typically involve a flammable electrolyte material or casing and should be protected by an appropriate Class ABC or BC dry chemical extinguisher."* — [safetyemporium.com](https://www.safetyemporium.com/09451)

- **NFPA Research Foundation (2011), "Lithium-Ion Batteries Hazard and Use Assessment":** *"Lithium-ion cells do not contain metallic lithium in any significant quantity to affect fire suppression; in lithium-ion cells, Li+ ions function simply as carriers of electric charge."*

**The distinction:** Class D is for **lithium metal** (non-rechargeable, disposable) batteries only. Rechargeable Li-ion batteries are **Class B fires** (flammable liquid electrolyte). The correct extinguisher is **ABC dry chemical**. This is the most common household extinguisher — easier to source, cheaper, and actually effective.

For NiMH batteries (the actual FTC chemistry), this entire discussion is largely moot since NiMH failures rarely produce open flame. But if an ABC extinguisher is on hand for general fire safety, it covers any plausible scenario.

**Correction: Use a standard ABC fire extinguisher. Not Class D.**

---

## Error 2 (FUNDAMENTAL): The Threat Model Doesn't Match FTC Batteries

**Original claim:** Treated FTC batteries as if they pose LiPo/Li-ion-level fire risks, including thermal runaway at 1,000°F, self-sustaining flames, and toxic HF/HCN gas release.

**The reality:** All FTC-legal batteries are **NiMH** (Nickel-Metal Hydride). Confirmed by multiple sources:

- **r/FTC (experienced mentor, 10 upvotes):** *"The FTC legal batteries all have 10 NiMH cells inside, wired in series to form a 12 Volt 3000 mAH battery pack."* — [reddit.com/r/FTC](https://www.reddit.com/r/FTC/comments/15t6alh/rev_12v_slim_battery/)

- **FIRST FTC Forum (REV Robotics official rep):** Confirmed NiMH chemistry, 12V, 3Ah with 20A fused discharge. — [ftcforum.firstinspires.org](https://ftcforum.firstinspires.org/forum/ftc-technology/6212-determining-the-health-of-rev-robotics-slim-battery)

- **Battery Beak configuration guidance:** *"Make sure the Beak is configured for NiMH, 12V, 3 Ah."*

NiMH batteries have a **fundamentally different failure profile** than Li-ion/LiPo:

| Property | NiMH (FTC batteries) | Li-ion / LiPo |
|----------|---------------------|----------------|
| Electrolyte | Aqueous (water-based KOH) | Organic solvents (flammable) |
| Thermal runaway | Extremely rare | Well-documented risk |
| Failure mode | Pressure buildup → relief valve vents gas | Self-heating → fire → flame jets |
| Fire risk | Very low | Moderate to high |
| Toxic fumes | Hydrogen gas, KOH mist | HF, HCN, CO, VOCs |
| Self-sustaining fire | No | Yes (generates own oxygen) |

Source: [himaxbattery.com](https://www.himaxbattery.com/2025/11/18/regarding-battery-safety-are-nickel-metal-hydride-batteries-really-safer-than-lithium-batteries/) — *"NiMH does not use flammable solvents... NiMH generates less heat during normal operation... NiMH is more tolerant of overcharging... NiMH has fewer catastrophic failure modes."* When a NiMH cell fails: *"No flames. No explosion. Minimal risk of spreading fire... NiMH batteries may leak electrolyte, but the leakage is usually mild and non-flammable."*

**The implication:** The original proposal's cement board, flame arrestors, steel wool filters, and toxic smoke warnings are **engineering for a hazard that NiMH chemistry largely doesn't present**. The entire design was copied from the RC/drone LiPo community where batteries are genuinely dangerous — but FTC uses a fundamentally safer chemistry.

**This doesn't mean safety precautions are worthless** — it means the cost/complexity should be proportional to actual risk. A simple metal container on a non-combustible surface, with a smoke detector and ABC extinguisher nearby, is proportionate for NiMH. The full ammo-can-with-cement-board-and-flame-arrestors build is overengineered for 12V 3Ah NiMH packs.

---

## Error 3 (OVERSTATED): The "Pipe Bomb" Claim

**Original claim:** *"A sealed container becomes a pipe bomb. This is the #1 DIY mistake."*

**More nuanced reality:** A sealed .50 cal ammo can with a LiPo fire inside does NOT detonate like a pipe bomb. Multiple test videos and community reports show:

- The can **deforms and bulges** significantly under pressure
- The rubber gasket seal **eventually fails**, releasing pressure as a directed flame jet
- The can itself does not fragment or send shrapnel

**r/rccars commenter:** *"the structure of the box isn't designed to hold any significant pressure. They just bend/split and then release it. All the videos of people testing it show the same thing, it doesn't explode. This is one of those prevailing myths."*

**Bat-Safe promotional video (with conflict of interest noted):** Shows an ammo can deforming and producing a "flamethrower" effect — dramatic but not an explosion.

**The real danger isn't explosion — it's the directed flame jet.** When the seal fails, pressurized hot gas exits violently in whatever direction the seal breaks. This can ignite nearby objects. The "remove the gasket" advice is correct — but framing it as preventing a "pipe bomb" is hyperbolic. A more accurate framing: removing the gasket prevents pressure buildup that causes uncontrolled directed flame jets.

**For NiMH batteries specifically:** this entire concern is academic. NiMH cells have pressure relief valves and vent hydrogen gas — they don't produce the volume of flaming gas that pressurizes a container.

---

## Error 4 (MISLEADING): Toxic Fume Claims Applied to Wrong Chemistry

**Original claim:** *"Hydrogen fluoride (HF), hydrogen cyanide (HCN), carbon monoxide, and volatile organic compounds from electrolyte decomposition. These are immediately dangerous to life."*

**This is accurate for Li-ion/LiPo but NOT for NiMH.** The cited MDPI paper ("Toxic Gas Emissions from Damaged Lithium Ion Batteries") tested NMC lithium-ion pouch cells — a completely different chemistry from FTC's NiMH packs.

NiMH failure produces:
- **Hydrogen gas** (from electrolysis of aqueous electrolyte) — flammable but not toxic in ventilated spaces
- **KOH mist** (potassium hydroxide) — caustic/irritating but not the acute poisoning threat of HF

Presenting HF/HCN hazards as if they apply to FTC batteries is fear-mongering with misattributed chemistry.

---

## Error 5 (QUESTIONABLE): Sand as Primary Fire Response

**Original claim:** *"Sand bags kept within arm's reach — sand is the best first response for a lithium battery fire."*

**Mixed expert opinion:**

- **NFPA assessment (cited on Reddit by knowledgeable user):** *"Water flood is prevailing method [for Li-ion fires]... Home use and small individual cells sand is a good alternative to smother a fire that's going to burn itself out. It's just not good for packs as it doesn't offer any means of cooling additional cells and preventing thermal runaway."*

- **Counter-argument (r/batteries):** *"All these sand ideas ffs... The smoke is the most toxic part (fluorine) and you need perlite or something that would make a ceramic layer... Water is the only way, and lots of water. You need to remove heat so the reaction stops."*

- **FireFighterLine.com:** *"Sand or dry powder should only be used as a last resort. It is best to call the fire department."*

Sand smothers surface flame but **doesn't cool the cells** — thermal runaway continues underneath. For large packs, water flooding is superior because it removes heat. For FTC's small NiMH packs, sand is adequate if anything happens at all, but positioning it as "the best first response" overstates the evidence. The actual best first response is: **move the battery to a non-combustible outdoor area and let it burn out** (for small cells) or **flood with water** (for larger events).

---

## What the Original Proposal Got Right

To be fair, several elements are well-supported:

1. **"Never seal airtight"** — Universal agreement across all sources. Even for NiMH (which vents hydrogen), sealing is bad.

2. **HardieBacker cement board as non-combustible material** — Confirmed by manufacturer testing: EN 13501-1 classification A1, S1-d0 = "fully non-combustible." This is a good material choice.

3. **Charger outside the containment** — Multiple community reports of chargers themselves catching fire (iCharger failure, PSU failures). Keeping the charger outside the box is correct.

4. **Steel wool + fiberglass as flame arrestor** — Validated by both Bat-Safe's commercial design and the MDPI research paper's textile composite (fiberglass mesh + glass fleece + stainless steel-reinforced para-aramid fibers).

5. **Smoke detector nearby** — Universally recommended, low-cost, high-value.

6. **Don't use fireproof document safes** — Correct. They protect contents FROM fire, not surroundings from an internal fire. The plastic liner adds fuel.

---

## Revised Recommendation for FTC Teams

Given that FTC batteries are NiMH (~36 Wh, 12V 3Ah), the proportionate response is:

### Minimum (Adequate for NiMH Risk Level)
- Charge on a **non-combustible surface** (concrete paver, ceramic tile, metal tray)
- Keep an **ABC fire extinguisher** accessible (not Class D)
- **Never charge unattended** (FIRST's own rule)
- **Smoke detector** in the charging area
- Inspect batteries for damage/swelling before charging
- Don't charge immediately after heavy use (let batteries cool)

### Enhanced (If Team Wants Extra Safety / Engineering Notebook Credit)
- **Ammo can with gasket removed** — cheap, portable, contains any plausible NiMH event
- Cement board lining — adds thermal insulation, prevents shorts
- Individual battery compartments — prevents cascade (minor concern for NiMH)
- Labeled clearly with safety procedures

### The Honest Assessment
For 12V 3Ah NiMH packs, the risk of a fire event during proper charging with a functioning charger is **extremely low**. The aqueous electrolyte doesn't burn. There's no thermal runaway mechanism comparable to Li-ion. The FIRST wiring guide's caution about "faulty batteries" creating a "fire hazard" is appropriate general safety guidance, but the actual failure mode of NiMH is a pressure relief vent releasing hydrogen gas — not the flame jets and cascading thermal runaway of Li-ion.

Building the full cement-board-lined, flame-arrestor-filtered ammo can is a fine engineering exercise and makes great notebook material, but it should be presented honestly: **this is engineering practice and prudent over-engineering, not a response to a serious fire threat from NiMH batteries.**

If the team ever transitions to **Li-ion batteries** (which some FTC discussions suggest wanting), THEN the full containment build becomes genuinely warranted.

---

## Source Summary

| Claim | Source | Type |
|-------|--------|------|
| FTC batteries are NiMH | r/FTC mentors, FIRST FTC Forum, REV Robotics rep | Primary / Manufacturer |
| NiMH failure: no flames, no explosion | himaxbattery.com battery safety comparison | Industry analysis |
| Class D wrong for Li-ion | Amerex (manufacturer bulletin), Ansul (manufacturer), NFPA 2011 | Manufacturer + Standards body |
| ABC correct for Li-ion | Amerex, Ansul, NFPA, multiple fire service sources | Manufacturer + Standards body |
| HardieBacker is non-combustible | James Hardie tech data sheet, EN 13501-1 A1,S1-d0 | Manufacturer + EU standard |
| Ammo can doesn't truly explode | Community test videos, r/rccars analysis | Empirical / Community |
| Sealed can produces flame jets | Bat-Safe test video, r/fpv community | Empirical (note: Bat-Safe has commercial interest) |
| Sand limitations for cooling | NFPA assessment (via r/batteries), FireFighterLine | Standards body (indirect) + Fire service |
| Toxic fumes (HF/HCN) from Li-ion only | MDPI "Toxic Gas Emissions from Damaged Lithium Ion Batteries" | Peer-reviewed research |
| Steel wool/fiberglass flame arrestor works | Bat-Safe design, MDPI textile composite research | Commercial + Peer-reviewed |
