← [Index](../README.md)

## HN Thread Distillation: "We Will Not Be Divided"

**Article summary:** A petition site (notdivided.org) collecting verified signatures from current and former Google and OpenAI employees opposing the Department of War's push to strip AI safety red lines — specifically, mass domestic surveillance and fully autonomous weapons without human oversight. Signatures are verified via corporate email or manual review. Anonymous signing is supported. ~643 signatures at time of thread.

### Dominant Sentiment: Sympathetic but fatalistic, then betrayed

The thread opens with broad support for the petition and Anthropic's stance, but a deep cynicism about its effectiveness runs underneath. That cynicism is vindicated in real-time: 90 minutes after the post, Sam Altman announces OpenAI has cut a deal with the Department of War. The mood shifts to grim validation.

### Key Insights

**1. OpenAI's deal torpedoed the letter while the ink was still wet**

The most important event in this thread isn't a comment — it's breaking news. hakrgrl drops it: "1.5 hours after this was posted, Sam Altman stated openai will work with the DoW." Altman claims the same restrictions Anthropic had, but the thread immediately and correctly identifies this as the Trump playbook: kill the deal with the principled party, sign a worse-or-equal deal with a compliant one, declare victory. straydusk nails the pattern: "Make a negotiation personal → Emotionally lash out and kill the negotiation → Complete a worse or similar deal → Celebrate your worse deal as a better deal." foobarqux spots the actual difference: "Anthropic said that mass surveillance was per se prohibited even if the government self-certified that it was lawful." OpenAI apparently accepted government self-certification of lawfulness — a gap you could drive an entire surveillance apparatus through.

**2. The supply chain risk designation is the real weapon, not the contract dispute**

The thread's sharpest analytical exchange is between timr (who treats the designation as routine vendor exclusion) and several pushbacks. ted_dunning cuts through: "If I sell red widgets that I make by hand to the government, I won't be allowed to use Anthropic to help me write my website." AlexCoventry calls it "essentially a death sentence for a company like Anthropic, which is targeting enterprise business development." dyslexit notes this designation has historically been "reserved for US adversaries, never before publicly applied to an American company." The distinction matters: this isn't a procurement decision, it's economic coercion. The government is not declining a vendor; it's poisoning one.

**3. The "contractors shouldn't set doctrine" argument is more serious than the thread admits**

The strongest pro-government case comes from remarkEon and snickerbockers, channeling Palmer Luckey's position. The core argument: a defense contractor unilaterally imposing moral red lines and retaining a remote kill switch over military infrastructure is structurally dangerous regardless of the contractor's intentions. snickerbockers: "Can Lockheed's drones autonomously blow up hippies' houses for protesting wars? Can a weapons system patch out support for features the contractor is no longer interested in supporting?" This is a genuine structural concern that most of the thread dismisses because the current contractor happens to be right. But the precedent question — should any vendor have veto power over military operations? — deserves more engagement than it gets.

**4. The petition is a honeypot risk that nobody wants to talk about**

dataflow raises the security elephant: anonymous signatories are trusting unknown organizers with career-ending information, verification runs through Google Forms (which Google can obviously monitor on their own servers), and the organizers haven't even verified their own identities. ocdtrekkie adds that "both the automated verification methods depend on Google servers and Google can almost certainly retrieve that data if they want to." In the current political environment — where the administration is designating a domestic company as a supply chain risk for disagreement — this is not paranoia. It's operational security. The thread mostly waves this away.

**5. "They funded this" vs. "accept allies where you find them"**

no_wizard voices the cynical take: tech leaders gave millions to Republican campaigns and are now "feigning ignorance." inkysigma pushes back with receipts — Google employees and the corporation overwhelmingly donated to Harris. SpicyLemonZest offers the pragmatic synthesis: "If someone's willing to openly oppose the Trump regime, even out of self-interest, I'm happy to let them feign as much ignorance as they'd like." This is the correct framework. Purity testing allies during a crisis is a luxury of people who don't understand what's at stake.

**6. The open-source-everything argument collapses on hardware**

txrx0000 argues passionately for open-sourcing all AI to prevent government capture. bottlepalm and medi8r immediately identify the flaw: "What use are weights without the hardware to run them? That's the gate." The compute concentration problem makes "just open-source it" into a non-answer. 5o1ecist states it most concisely: "They control the compute." txrx0000's counterargument that human-level AI will run on a single 16GB GPU by decade's end is speculative enough to be irrelevant to the current crisis.

**7. The bioweapons debate produces the thread's best substantive exchange**

jefftk (who works full-time on pandemic early warning at naobservatory.org) vs. txrx0000 and oceanplexian on whether democratized AI creates asymmetric bioweapon risk. jefftk's point is precise: "Symmetry is not guaranteed. If someone creates a deadly pathogen with a long pre-symptomatic period... it could infect essentially everyone before discovery." txrx0000's counter — "for every person that thinks about creating the HIV-like deadly pathogen, there will be millions more thinking about how to defend" — is hopeful but hand-wavy. The core tension: offense/defense asymmetry in biology is real and well-established. "Good people outnumber bad people" is not a security model.

**8. Europe as brain-drain destination is more plausible than HN thinks**

A surprisingly substantive subthread between EdNutting and piskov/dmix/SauntSolaire. EdNutting makes the non-obvious point that major American AI companies are already opening offices in London at competitive salaries, that European sovereign AI hardware programs are further along than assumed, and that ASML's Dutch/German supply chain gives Europe more chip leverage than the US wants to acknowledge. piskov's challenge — "what happens when the US imposes GPU export restrictions?" — gets a strong response: the US doesn't control EUV lithography, TSMC is building fabs on European soil, and RISC-V is Swiss-headquartered. This isn't settled, but the "Europe can't compete" assumption is weaker than the HN default suggests.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| "This is meaningless without resignations/unions" | Medium | Directionally correct but historically wrong — collective action often starts with letters. culi's Kickstarter union comparison is apt. |
| "You can't let contractors dictate military doctrine" | Strong | Structurally valid even if applied badly here. The precedent question is real. |
| "China doesn't care about ethics, so we can't either" | Weak | Classic race-to-the-bottom fallacy. Multiple commenters note China's AI isn't more capable for lacking ethics constraints. |
| "They brought this on themselves by building AI" | Medium | True at the meta level but useless at the action level. The question is what to do now. |
| "Just open-source everything" | Weak | Fails on compute concentration. Doesn't solve the immediate coercion problem. |

### What the Thread Misses

- **The Defense Production Act is the real endgame.** rayiner mentions it late and it gets almost no engagement, but it's the actual legal mechanism that could force Anthropic's hand regardless of contracts, petitions, or employee solidarity. The DPA allows the President to compel private businesses to accept and prioritize government contracts for goods deemed critical. If invoked, everything else in this thread becomes moot.

- **Nobody discusses what happens to Anthropic's non-US customers.** If Anthropic is designated a supply chain risk, what does that mean for European, Asian, and other international enterprise customers who also do business with the US government? The extraterritorial effects could be enormous and would likely accelerate the sovereign AI movement in ways the administration hasn't considered.

- **The thread doesn't connect the resignation letter wave to this moment.** The BI article on AI researcher departures (Sharma, Hitzig, Sutskever, Leike, etc.) documents a pattern: safety researchers keep leaving and writing elegiac letters, but nobody stops building. This petition is the same dynamic at scale — expressing concern while continuing to show up for work. The thread doesn't ask whether the petition is just a mass resignation letter without the resignation.

### Verdict

The thread captures a genuine inflection point but is already outdated by the time it finishes loading. OpenAI's same-day capitulation — dressed up as principled agreement — reveals that the petition's premise ("we will not be divided") was falsified within hours of publication. The deeper dynamic the thread circles but never states: this isn't a negotiation between equals. The government has the Defense Production Act, supply chain designations, and the power to define what's "lawful." Tech companies have... employee petitions and PR. Anthropic's real strategic asset isn't its employees' moral convictions — it's that killing the company would hand the AI frontier to competitors the government trusts even less. The question isn't whether AI companies will comply with military demands, but how much theater they'll perform before doing so.
