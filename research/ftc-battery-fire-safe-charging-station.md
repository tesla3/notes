# Fire-Safe Charging Station for FTC Batteries: DIY Build Guide

Source: Web research synthesis (Reddit, FliteTest, Bat-Safe, MDPI, FIRST Inspires, RC community)
Date: 2026-04-01

## FTC Battery Context

FIRST Tech Challenge robots use **REV Robotics 12V batteries** — historically NiMH (Slim Battery), with newer Li-ion options now available. FIRST's own wiring guide explicitly states: *"batteries should not be left unattended while charging. The charging process may cause faulty batteries to overheat and create a fire hazard."*

While NiMH batteries are less volatile than LiPo/Li-ion, a fire-safe charging station is prudent for any team — especially those with multiple batteries charging simultaneously, or teams transitioning to Li-ion packs. The same containment principles apply regardless of chemistry.

## The Physics of Battery Fire Containment

A battery in thermal runaway produces three hazards simultaneously:

1. **Flames/sparks** — Temperatures exceed 1,000°F (538°C). Lithium fires generate their own oxygen from cell decomposition, so smothering alone won't work.
2. **Pressure/gases** — Rapidly expanding gases. A sealed container becomes a **pipe bomb**. This is the #1 DIY mistake.
3. **Toxic fumes** — Hydrogen fluoride (HF), hydrogen cyanide (HCN), carbon monoxide, and volatile organic compounds from electrolyte decomposition. These are immediately dangerous to life.

### Critical Design Principle: Contain Heat + Sparks, Vent Gas

The goal is NOT a sealed fireproof box. The goal is:
- **Contain flames** so they don't ignite surroundings
- **Absorb/block radiant heat** so nearby surfaces stay below ignition temperature
- **Vent pressure** so the container doesn't explode
- **Direct toxic smoke** away from people (ideally outdoors)

---

## Design Options: From Simple to Advanced

### Option 1: Cinder Block Bunker (~$10)

The simplest proven design. Widely used in the RC/drone community.

**Materials:**
- 6 cinder blocks (~$1 each)
- 2-4 pieces of 24" cement tile or concrete pavers (~$1 each)
- Sand-filled ziplock bags (for emergency smothering)
- Smoke detector

**Construction:**
1. Place 2 tiles as a base on a **non-combustible surface** (concrete floor, metal shelf — never wood)
2. Arrange 6 cinder blocks in a rectangle around the base tiles, tight together to minimize gaps
3. Route charger cables out over the top edge (not between block seams)
4. Keep power supply **outside** the bunker (it needs cooling airflow)
5. Cover with remaining tiles as a lid — leave a small gap for cable routing and venting

**Pros:** Dead simple, very cheap, non-combustible, naturally vents through gaps between blocks
**Cons:** Heavy, not portable, gaps may let some flame through, no smoke filtering

### Option 2: Ammo Can + Cement Board (~$30-45)

The most popular community-proven design. Balances containment, cost, and portability.

**Materials:**
- .50 cal steel ammo can ($15 — Harbor Freight, Walmart, surplus stores)
- HardieBacker cement board, 1/4" or 1/2" ($5-8 for a 3'×5' sheet)
- Furnace cement / Gorilla Glue ($8-13)
- Optional: high-temp exhaust primer rated 1800-2000°F

**Construction:**
1. **Remove the rubber gasket** from the ammo can lid. This is critical — the gasket creates an airtight seal that turns the can into a bomb during thermal runaway.
2. Cut cement board pieces to line all interior surfaces (bottom, sides, lid underside). The cement board serves dual purpose: thermal insulation and prevents battery shorts against metal walls.
3. Attach cement board with furnace cement (rated for high temps) or a 3:1 mix of Gorilla Glue to water-based wood glue.
4. **Drill vent holes** in the lid or upper sides — at least 4-6 holes of 1/4" to 3/8". Aim holes toward non-combustible directions.
5. Optional: create **individual compartments** with cement board dividers so one battery failing doesn't cascade to adjacent batteries.
6. Drill a cable routing hole in one side (lower, for charging leads). Don't seal this hole — it provides additional venting.
7. Apply black electrical tape to any exposed metal edges (prevents shorts).
8. Place the finished can on a concrete paver or ceramic tile (heat insulation from the surface below).

**Vent Hole Upgrade:** Line vent holes with steel wool or fiberglass mesh to act as a flame arrestor — lets gas through, blocks sparks and flame jets. This is the same principle the Bat-Safe uses commercially.

**Pros:** Portable, excellent containment, individual battery compartments possible, affordable
**Cons:** Requires tools (drill, saw for cement board), heavier than bare can

### Option 3: Metal Toolbox + Drywall/Cement Board (~$30-40)

Better for larger battery collections or when you need more internal volume.

**Materials:**
- Steel toolbox, 18-20" (Harbor Freight aluminum case ~$30, or steel toolbox from Lowes)
- Type X or Type C drywall (fire-rated, better than regular drywall) OR cement board (maximum fire resistance)
- Gorilla Glue + water-based glue mix (3:1)
- Small fans (optional, for active venting)
- Smoke detector

**Construction:**
1. Line all interior surfaces with fire-rated drywall or cement board
2. Build compartment dividers to isolate individual batteries
3. Drill vent holes in the case — multiple holes, directed upward or toward non-combustible areas
4. Route charging cables through a drilled side hole
5. **Do NOT use PlastiDip** or any combustible coating inside — it adds fuel
6. Mount a small 12V fan externally for active ventilation during normal charging (not for fire events)
7. Add a smoke detector nearby or inside

**Pros:** More internal space, can hold charger inside, compartmentalized
**Cons:** Aluminum cases are weaker than steel (aluminum melts at ~1220°F vs steel at ~2500°F — prefer steel)

### Option 4: Steel Cabinet with Filtered Venting (Advanced, ~$50-100+)

For teams wanting maximum protection, especially if charging indoors or in shared spaces.

**Materials:**
- Small steel filing cabinet, locker, or custom welded box
- Ceramic fiber blanket (furnace insulation) for air-gap insulation
- Steel wool + fiberglass mesh for flame arrestor vents
- Activated charcoal (optional, for smoke filtration)
- Dryer vent duct + window adapter (for external smoke venting)

**Construction:**
1. Use double-wall construction if possible — an inner steel container inside an outer one, with 1-1.5" air gap. The air gap insulates so the outer surface stays cool enough to touch.
2. Line the inner container with ceramic fiber blanket or cement board.
3. Create vent ports in the top — cover with multi-layer flame arrestors:
   - Layer 1: Steel mesh/hardware cloth (blocks large debris)
   - Layer 2: Steel wool (absorbs heat, blocks sparks)
   - Layer 3: Fiberglass mesh (final flame barrier)
4. Optionally route the vent port through a metal dryer duct out a window for external smoke venting. Use a gravity damper flap that opens from internal pressure.
5. Include a cable grommet port (fire collar style) for charging leads.
6. Place on concrete pavers with 1" gap below for bottom insulation.

**The Bat-Safe commercial product (~$70-80) uses exactly this approach:** double-wall steel + fiberglass/steel wool flame-arresting filter + integrated venting + fire collar grommets for cables.

---

## Critical Safety Rules (All Designs)

### Must-Do
- **Never seal airtight.** A sealed container + battery fire = bomb. Always have venting.
- **Remove rubber gaskets** from ammo cans or any sealed containers.
- **Keep power supply/charger outside the containment box.** Chargers can also catch fire. Route only battery leads inside.
- **Place on non-combustible surface** — concrete paver, ceramic tile, metal shelf. Never directly on wood.
- **Never charge unattended.** A charging station buys you time to react — it doesn't eliminate risk.
- **Have a fire extinguisher nearby** — Class D (metal fires) for lithium, or ABC dry chemical as a minimum. Sand also works for smothering.
- **Sand bags** kept within arm's reach — sand is the best first response for a lithium battery fire.
- **Smoke detector** — mount one near the charging station, or inside a larger enclosure.
- **Keep away from walls and combustibles** — at least 2-3 feet clearance from anything flammable.

### Don't Do
- **Don't use fireproof document safes** — they protect contents from external fire, not the other way around. The internal plastic liner adds fuel.
- **Don't trust LiPo bags alone** — they're a single layer of protection, not a containment system. Use as an inner layer within a rigid container.
- **Don't charge in extreme heat** — above 100°F ambient significantly increases risk.
- **Don't charge damaged or puffy batteries** — dispose of them properly.
- **Don't put all batteries in one compartment** — if one goes, the heat cascades to all others.

### Toxic Smoke Warning
No DIY containment box fully filters toxic fumes. During a thermal runaway event:
- **Do not breathe the smoke.** It contains hydrogen fluoride and hydrogen cyanide.
- If indoors, evacuate the room immediately and ventilate.
- The box contains flames and buys time to move the box outside. That's its purpose.
- For teams charging in classrooms/workshops: position the station near a door or window for quick egress.

---

## FTC Team-Specific Recommendations

### Recommended Build: Ammo Can + Cement Board (Option 2)

Best balance for FTC teams because:
- **Portable** — can bring to competitions and practice spaces
- **Affordable** — under $40 in materials
- **Right-sized** — REV 12V batteries fit well in a .50 cal ammo can
- **Demonstrable** — shows judges the team takes safety seriously (engineering notebook material)

### Sizing for FTC Batteries
- REV Slim Battery: ~140mm × 48mm × 25mm (easily fits 2-4 in a .50 cal can with dividers)
- .50 cal ammo can interior: ~280mm × 130mm × 180mm (plenty of room)

### Competition/Event Considerations
- Check if your venue allows open-flame containment devices (most do, but ask)
- Label the box clearly: "BATTERY CHARGING STATION — DO NOT SEAL"
- Include instructions on the box for anyone who might use it
- Keep a fire extinguisher with the charging station at all events

### Bill of Materials (Recommended Build)

| Item | Source | Cost |
|------|--------|------|
| .50 cal steel ammo can | Harbor Freight / Walmart | $15 |
| HardieBacker cement board (3'×5' sheet) | Home Depot / Lowes | $8 |
| Furnace cement (small container) | Home Depot | $8 |
| Steel wool (fine grade, for vent filter) | Hardware store | $3 |
| Concrete paver (base) | Home Depot | $2 |
| Smoke detector (battery-powered) | Any store | $5 |
| Sand (5 lbs, for emergency bags) | Hardware store | $3 |
| **Total** | | **~$44** |

### Tools Needed
- Drill with metal bits (for vent holes and cable port)
- Utility knife or saw for cutting cement board (score-and-snap works, or use abrasive blade)
- Dust mask (cement board dust is silica — always wear protection when cutting)
- Marker/pencil for measurements

---

## References

- FIRST Inspires Robot Wiring Guide — battery safety guidelines
- Bat-Safe commercial design — double-wall steel + fiberglass/steel wool filter architecture
- Justrite ChargeGuard system — 9-layer industrial containment with automatic dampers
- MDPI "Toxic Gas Emissions from Damaged Lithium Ion Batteries" — textile composite fire prevention + activated charcoal/KMnO4/alumina gas filtration
- FliteTest "LiPo Battery Bunker" and "Charging & Storage Bunker Alternative" — community builds using cinder blocks and HardieBacker cement board
- Reddit r/AskEngineers, r/fpv, r/rccars, r/ebikes — practitioner experience and failure modes
