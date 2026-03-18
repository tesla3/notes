← [Index](../README.md)

## HN Thread Distillation: "$96 3D-printed rocket that recalculates its mid-air trajectory using a $5 sensor"

**Source:** [GitHub repo](https://github.com/novatic14/MANPADS-System-Launcher-and-Rocket) by Alisher Khojayev (student, Los Angeles Valley College). A 3D-printed guided rocket with ESP32 flight computer, MPU6050 IMU, GPS/barometric navigation, canard-stabilized with folding fins. Total BOM: ~$96. Companion repo provides a [distributed camera tracking system](https://github.com/novatic14/Distributed-Camera-Node-Tracking-System) for target acquisition. Claude is listed as a contributor.

**Thread:** 411 points, 366 comments, 186 unique authors. ([HN link](https://news.ycombinator.com/item?id=47385935))

### Dominant Sentiment: Impressed but nervously looking over their shoulders

Thread splits roughly 40/30/30 between technical appreciation, legal alarm, and geopolitical musing. Remarkably few dismissive comments for what is essentially a hobby rocket with an edgy name. The fear of being "on a list" for even *clicking the link* is a recurring half-joke.

### Key Insights

**1. The legal exposure is real but narrower than commenters think**

The most substantive comment comes from **mothballed**, citing [18 USC §2332g](https://www.law.cornell.edu/uscode/text/18/2332g) — possessing a system "intended to launch or guide a rocket or missile" that seeks/guides toward aircraft carries **25 years to life**. This is not ITAR (export control); it's a domestic criminal statute with no NFA stamp escape hatch. However, **neoinkarasuyuu** correctly notes the statute requires the missile to "seek or proceed toward energy radiated or reflected from an aircraft or toward an image locating an aircraft." This system does neither — it navigates to a static GPS coordinate via inertial measurement. It's closer to a guided ground-attack munition than a MANPAD. The author's choice to *name* it MANPADS is the most legally dangerous thing about the project, not the technology itself.

**2. It's not a MANPAD — it's a résumé**

**K0balt** nails it: "This isn't a serious project… It's basically a resume to work as a junior engineer at Anduril." **codethief** quotes YouTube: "This guy really wants that defense contract." **nine-one-two** checked the code and found a naive proportional controller with no error accumulation or trajectory interpolation — "a joke" as a weapons system, credible as a portfolio project. The project's real innovation isn't the rocket; it's the distributed camera tracking system in the companion repo. **kikkia** points out that GPS guidance makes it conceptually useless for air defense — "Typically manpads would use something like an infrared/optical or radar guidance system which would run way more than $5."

**3. The IMU choice reveals the gap between demo and capability**

**peterus** delivers the thread's best technical comment: the MPU6050 is obsoleted in both cost and capability. The ST LSM6DSOX has 4x better rate noise density (110 vs 400 µg/√Hz) and is *cheaper*. Sony even built a synchronized array of consumer IMUs that became export-controlled despite using only off-the-shelf components — a delicious irony that illustrates how the line between "hobby" and "controlled" is drawn at *integration*, not components. **torginus** pushes back on doubts about MEMS accuracy, finding a 16G-rated IMU with velocity drift of ~0.0002 (m/s)/s, "way more than good enough for short flights."

**4. The real democratization already happened — in Ukraine**

The thread's best macro-insight emerges from multiple commenters but nobody synthesizes it fully. Ukraine's Wild Hornets [Sting interceptor](https://en.wikipedia.org/wiki/Sting_(drone)) — a 3D-printed quadcopter with thermal imaging — costs $2,100 and has destroyed 3,900+ Shahed drones at 10,000+ units/month production. **jacquesm** highlights the rapidly climbing success rate. **Svoka** provides the devastating economics: 57,000 Shaheds launched vs. only 2,500 Patriot-compatible PAC missiles in existence, with a 100x cost difference. The asymmetry isn't "cheap offense overwhelms expensive defense" — it's that *both* offense and defense are getting cheap, but defense procurement bureaucracies haven't caught up.

**5. The drone-vs-drone debate reveals unsolved detection problems**

**tamimio** (claims field experience building drones) makes the thread's strongest technical argument: the hardest problem isn't interception but *detection*. Small FPV drones are "almost impossible to detect unless you can hear it" — too small for radar (bird-sized false negatives), too fast for visual tracking at 250km/h, acoustic sensors fail in noisy environments. Even combining sensors with AI pattern detection is "far from reliable in practical applications." He also deflates FPV drone lethality — claims ~1% hit rate from a Canadian soldier source, with only successes going viral.

**6. The laser counter-drone fantasy gets a thorough debunking**

**lukan** proposes lasers as the obvious counter. The thread efficiently dismantles this: **condensedcrab** (tight focusing = expensive optics), **rdtsc** (beam divergence + tracking precision at distance), **robotresearcher** (dumping thousands of Joules on a tiny moving target is easier with explosives), **hermitcrab** (links the comprehensive Naval Gazing series on laser limitations at sea). The consensus: lasers solve a physics problem nobody has, while ignoring the engineering problems everybody does.

**7. The generational anxiety is more interesting than the project**

**ryandrake** delivers the thread's most upvoted emotional comment: fear of a future where kids "are only allowed to stay home and mindlessly consume corporate approved product, never make things, never build things." **clbrmbr** — who built homemade rocket engines post-9/11 and got a fire marshal's blessing — begs the author to take it down, not because it's dangerous but because it *narrows the window* for others to do similar work legally. **ivanjermakov** notes that in many countries, building rockets with guidance systems is "borderline jail time." The thread performs a live demonstration of the ratchet: each provocative project makes the next one harder to attempt.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| This violates 18 USC §2332g / ITAR | Medium | Statute requires aircraft-seeking guidance; this uses GPS to static coordinates. The *name* is the liability, not the tech. |
| The code/engineering is too primitive to matter | Weak | Misses the point — the project demonstrates accessible integration, not weapons-grade capability. |
| Lasers will solve counter-drone | Weak | Thoroughly debunked by multiple physics-literate commenters. |
| This can't actually shoot down aircraft | Strong | Correct — GPS-guided with no seeker. It's a guided surface-to-surface munition cosplaying as air defense. |
| Open-sourcing this enables bad actors | Medium | The KNO3/sugar propellant and servo-controlled canards are textbook model rocketry. The distributed camera tracking is the only genuinely novel component. |

### How Far From Competent? (Thread-sourced alternatives)

The thread provides specific upgrade paths for the weakest components but only gestures at the algorithmic fixes.

**IMU — specific alternatives from peterus:**

| Part | Noise density | Notes | Price vs MPU6050 |
|------|--------------|-------|-----------------|
| **ST LSM6DSOX** | 110 µg/√Hz @ 16g | His personal pick for rocket flight computers | Cheaper on LCSC |
| **ST LSM6DSV** | 60 µg/√Hz | Newer, better, but pricier | More expensive |
| **ST LSM6DSV320X** | ~60 µg/√Hz + integrated high-g | Obsoletes the separate ADXL375 high-g accelerometer | New (<1yr), supply uncertain |
| MPU6050 (current) | 400 µg/√Hz | Long obsolete | — |

**torginus** also found the h4-lab QMU102 — 16G capable with compounding velocity error of ~0.0002 (m/s)/s, "way more than good enough for short flights." The hardware swap is near drop-in (same I2C/SPI interface), maybe an afternoon's work.

**Controller/algorithm — criticism without prescription:** **nine-one-two** diagnosed the problem ("naive proportional response that doesn't even account for error let alone interpolate trajectory") but nobody named a specific library or algorithm. What they're implicitly pointing at:

- **P → PID**: Add integral (accumulated error) and derivative (rate of change) terms. Textbook, ESP32 handles it trivially.
- **Trajectory interpolation**: Predict where the rocket *will be* given current velocity/attitude, compute corrections along a planned path. Requires a **Kalman filter** (sensor fusion of IMU + GPS + barometer) for state estimation — the current code apparently has none.
- Open-source model rocketry flight controllers and drone firmware (Betaflight, ArduPilot) provide reference implementations for all of this on comparable MCUs.

**Difficulty assessment:** The gap from "demo" to "competent" is ~2-4 weeks for someone with undergraduate controls knowledge. The hardware swap is trivial; PID + Kalman filtering on ESP32 is routine. The real bottleneck is testing — each flight is destructive if wrong, iterations are slow (build, mix propellant, launch, recover, analyze), which explains why the code is primitive. The gap from "competent" to "weapons-grade" is a different universe: reliable propulsion, professional test infrastructure, and export-controlled integration.

### What the Thread Misses

- **The Claude contributor angle is completely unexplored.** An AI co-authored an open-source weapons-adjacent project. Nobody asks what Claude contributed, whether Anthropic's use policies were violated, or what this means for AI safety commitments. This is arguably the most consequential aspect of the project.
- **No one compares this to the [Bruce Simpson $5K cruise missile](https://en.wikipedia.org/wiki/Bruce_Simpson_(blogger)#DIY_Cruise_Missile) from 2003** — except one commenter (**femto**) who drops the link without analysis. Simpson was raided by New Zealand authorities. The 23-year cost reduction from $5,000 to $96 for a guided projectile is the real story.
- **The thread assumes US jurisdiction** almost exclusively. The GitHub repo is globally accessible. The most likely users of a cheap guided munition design are not American hobbyists but non-state actors in conflict zones with no ITAR to worry about.
- **Nobody discusses the propellant as the real bottleneck.** KNO3/sugar motors are unreliable, low-impulse, and dangerous to manufacture. The flight computer is the easy part; the motor is what separates a demo from a weapon, and it's conspicuously janky in the videos.

### Verdict

The project is a provocatively packaged college portfolio piece that accidentally became a Rorschach test for how different communities process the democratization of weapons technology. Hawks see validation; civil libertarians see a closing window; defense professionals see a job application; and legal scholars see a trap. What the thread circles but never states: the meaningful threshold was crossed years ago in Ukraine, where 3D-printed interceptor drones are being produced at 10,000/month and exported to allied nations. This GitHub repo isn't the future — it's a student recreating, poorly, what a war economy already industrialized. The real question isn't whether one kid in LA can build a guided rocket for $96; it's that the components enabling it (ESP32, MEMS IMUs, 3D printers, AI coding assistants) are now so commodity that *preventing* such projects requires controlling the entire consumer electronics supply chain.
