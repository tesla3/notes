# FTC Garage Charging Station: Concrete Setup for 10+ NiMH Batteries

## The Actual Risk Profile

Your batteries: REV Slim / Matrix 12V 3Ah NiMH. Aqueous electrolyte. ~36 Wh each.

**Primary risks (ranked by likelihood):**
1. **Charger or power supply failure** — this is the real fire source, not the batteries
2. **Short circuit** — bare terminals contact metal shelf/tools/each other
3. **Overcharging a degraded cell** — produces hydrogen gas (flammable, but dissipates quickly in a ventilated garage)
4. **Battery fire** — extremely unlikely with NiMH; no thermal runaway mechanism

The charger is more dangerous than the batteries. Design around that.

---

## The Setup (~$30-50)

### Surface
- **Metal shelf or metal tray on a workbench**, sitting on a **concrete paver** ($2)
- Garage concrete floor works fine as-is if you don't need bench height
- Keep 2 feet clear of anything flammable (cardboard, rags, solvents — garage stuff)

### Charging Area
- **Charger(s) and power supply on the metal surface** — not on wood, not on a shelf above
- Route cables neatly — no dangling wires near moving/sharp things
- If you charge 10+ batteries in rotation, a **multi-port charger** (like a 4-bay NiMH charger) reduces the number of charge cycles and time batteries sit on chargers

### Battery Storage While Not Charging
- **Plastic bin or toolbox** (non-conductive) with dividers or individual bags
- Terminals must be **protected** — tape over exposed connectors, or use dust caps
- Never store loose batteries with metal tools, screws, or other batteries where terminals can bridge

### Safety Equipment

| Item | Why | Cost |
|------|-----|------|
| **ABC fire extinguisher** (5 lb minimum) | Covers any plausible fire — charger, battery, or surrounding materials. NOT Class D. Per Amerex and NFPA: Li-ion and NiMH are not metal fires. | $20-30 |
| **Smoke detector** (battery-powered, mounted above charging area) | Early warning. You won't always be staring at the chargers. | $5-10 |
| **Power strip with overload protection** or a **timer outlet** | Prevents indefinite charging if you forget. A mechanical timer that cuts power after 4-6 hours is cheap insurance. | $10-15 |

**Optional but smart:** a $10 carbon monoxide / combustible gas detector near the charging area. Catches hydrogen gas buildup from a venting NiMH cell — the one failure mode that's actually plausible.

### That's It for NiMH

Total: ~$35-55. No cement board. No ammo cans. No flame arrestors. Proportionate to the actual hazard.

---

## Procedures (Post These on the Wall)

Print and tape next to the charging station:

```
FTC BATTERY CHARGING RULES

1. Never leave batteries charging when nobody is in the garage.
2. Check batteries before charging:
   - Physically damaged? → RETIRE IT
   - Hot to the touch? → Let it cool 30 min first
   - Swollen or leaking? → RETIRE IT
3. One battery per charger port. Don't daisy-chain.
4. Charger shows DONE → remove battery promptly.
5. Timer outlet cuts power after ___ hours (set per your charger).
6. Store charged batteries in the plastic bin, terminals covered.
7. Fire extinguisher location: ____________
8. If anything smells wrong or a battery is hot: UNPLUG → MOVE BATTERY
   TO CONCRETE FLOOR → STEP BACK → VENTILATE (open garage door)
```

---

## Battery Health Program (Prevents Problems)

This matters more than any containment box. Bad batteries are the risk; good maintenance eliminates it.

1. **Number every battery** (sharpie on the case: BAT-01, BAT-02, etc.)
2. **Log internal resistance** with a Battery Beak at start of season
   - REV Slim: healthy = <170 mΩ when new (per REV Robotics)
   - Track trend over time — rising IR = aging cell
3. **Retire batteries** that show measurable IR increase or reduced capacity
4. **Designate tiers:** fresh batteries = competition, older = practice only
5. **Don't deep-discharge** — swap batteries before the robot dies on the field
6. **Charge to storage voltage** if batteries will sit unused for weeks

Source: REV Robotics official guidance via FIRST FTC Forum — *"the best practice for tracking the health of every battery is to note the internal resistance when the battery is new, and then monitor the change in that resistance over time."*

---

## If You Want the Enhanced Build Anyway (Engineering Notebook Credit)

If the team wants to build a containment station as a **safety engineering project** — great for the notebook, demonstrates safety culture to judges — here's the honest version:

**Steel ammo can ($15) + cement board lining ($8) + gasket removed**
- Overkill for NiMH, but teaches real containment principles
- Present it honestly: "We built this to practice safety engineering and prepare for potential future Li-ion battery rules"
- Don't claim NiMH has thermal runaway risk — judges who know batteries will catch that

**Better notebook framing:**
- "We assessed the actual risk profile of our NiMH batteries"
- "We identified charger failure as the primary fire risk"
- "We implemented proportionate controls: non-combustible surface, ABC extinguisher, timer outlet, battery health tracking"
- "We also built a containment box as an engineering exercise in case FTC rules change to allow Li-ion"

This shows **engineering judgment** — more impressive than over-engineering.

---

## Quick Reference

| Question | Answer |
|----------|--------|
| Fire extinguisher type? | **ABC dry chemical** (Amerex, NFPA) |
| Biggest fire risk? | Charger/PSU failure, not the batteries |
| Do I need cement board / ammo can? | No, for NiMH. Nice to have for the exercise. |
| Sand buckets? | Unnecessary for NiMH. |
| Toxic fumes concern? | NiMH vents hydrogen (flammable, not toxic). Open the garage door. |
| What if FTC goes Li-ion? | THEN build the full containment station from the original note. |
