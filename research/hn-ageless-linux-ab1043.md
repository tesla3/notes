← [Index](../README.md)

## HN Thread Distillation: "Ageless Linux – Software for humans of indeterminate age"

**Article summary:** Ageless Linux is a civil disobedience project by John McCardle that creates a "regulated operating system" from a bash script modifying Debian's `/etc/os-release`. It's an intentional, documented violation of California's AB 1043 (the Digital Age Assurance Act), which requires OS providers to implement age verification APIs. The site's core argument: the law's definitions are so absurdly broad they cover bash scripts, hobby distros, `cowsay`, and GitHub — while Apple, Google, and Microsoft already comply at zero cost. The law is a compliance moat dressed as child safety. The project plans to hand $6–$18 RISC-V devices running the OS to children at STEM fairs starting January 2027, daring the AG to sue.

### Dominant Sentiment: Sympathetic but fractured on tactics

The thread is overwhelmingly anti-age-verification, but splits hard on *what to do about it*. The majority favors maximal resistance. A significant minority argues the thread is fighting the wrong battle — that OS-level self-attestation is actually the *least bad* outcome compared to cloud-based ID verification that's already spreading. This minority gets downvoted but makes the most structurally interesting argument.

### Key Insights

**1. The "lesser evil" schism reveals a real strategic dilemma**

The most substantive debate axis. **terribleperson** argues: "If the California law flops, the result isn't going to be no age verification. It's going to be increasing numbers of internet services requiring that you verify their identity with them through some shady third-party." The CA law only requires self-attested age brackets (not verified, not your actual age, just one of four buckets). It bars sites from demanding ID if the OS signal exists. By this reading, AB 1043 is *defense* against the worse alternative already happening — Discord face scans, UK's Online Safety Act, 20+ US states requiring ID for adult content.

**applfanboysbgon** delivers the strongest counter: "Average Joe isn't going to understand the nuances of when age verification may or may not be tolerable... If we want to get millions aligned in the same interest, the message needs to be extremely clear." The argument is that nuanced positions collapse into ratchets because the public can't distinguish between harmless and invasive implementations.

Both camps are correct about their own half. The thread never reconciles them. **tstrimple** gets the sharpest line: "They sat silent while websites were asking for license uploads. They were silent while discord asked for face scans. They are outraged that California is trying to setup a system to bypass more privacy violating schemes."

**2. The "compliance moat" thesis goes unchallenged**

The article's central legal analysis — that AB 1043 passed 76-0 / 38-0 with Apple/Google support because they already comply while 600+ volunteer distros cannot — receives essentially no pushback in the thread. Nobody defends the legislative process. Nobody argues the definitions are appropriately scoped. The closest is **raincole** calling it "the best form of age verification one can imagine" — which concedes the framing entirely.

**colordrops** links to a Reddit investigation tracing "$2 billion in nonprofit grants" connecting these laws back to Meta. Whether or not the conspiratorial framing holds, the *cui bono* analysis is obvious: the companies that already have account infrastructure benefit from mandating it.

**3. The Prohibition pedagogy is the article's strongest original argument**

The article's comparison of age gates to Prohibition — not the policy failure, but the *teaching effect* — draws engagement. "The first meaningful interaction a child has with a legal compliance system will be the moment they learn to lie to it." **notpushkin** takes this further: "This is a good lesson. What is legal is orthogonal to what is moral and/or good for you." The thread is surprisingly comfortable with the implication that teaching children that compliance systems are theater might be... fine, actually.

**4. The "it's just parental controls" reframe fails**

**kybernetikos** and **stephbook** try reframing AB 1043 as standardized parental controls — a sysadmin sets ages for users on their machine, what's the problem? The rebuttals are sharp. **slopinthebag**: "Why would it be reasonable for a government to use the power of law to enforce the design of an open source operating system developed by an international consortium?" **themafia** notes that parental control software already exists — the law doesn't fill a gap, it creates a mandate. **akersten** points out you can poll the age-bracket API daily until the bucket changes, recovering exact birthdates for minors.

**5. The AI slop meta-irony**

Multiple commenters (**bastawhiz**, **royal__**, **kykat**, **landl0rd**, **petterroea**) immediately clock the site as Claude-generated — the dark mode cards, IBM Plex Mono, semi-transparent borders, em-dash-heavy prose. "LLMs have really made pushing out protest websites easier recently," notes **petterroea**. The meta-irony: a project protesting tech regulation is itself a product of AI tools that are driving the identity-verification push (AI-generated content → platforms need to distinguish humans → identity infrastructure). The site doesn't disclose its AI authorship. **tosti** notes "there's a meta tag for that, but hardly anyone uses it."

**6. Real-world age verification is already broken**

**zimpenfish** provides the thread's best concrete evidence: iOS 26.4 has an immovable "verify you're 18+" flag. They have no credit card (won't accept debit), no driving license, no national ID, and passports aren't accepted — despite decades of Apple purchases and credit checks. "Absolute farce." This is what the "just comply" position actually looks like in practice: a system that locks out adults who don't fit the identity-document monoculture.

**7. The DeCSS precedent is apt but underexplored**

**jwrallie** invokes the DeCSS T-shirts — code published as free speech to protest the DMCA. **irusensei** mentions Phil Zimmermann publishing PGP source as a book. These are the correct historical parallels: the question of whether code is speech, and whether mandating code inclusions is compelled speech. The thread namedrops them but doesn't develop the legal theory. **akersten**'s framing — "The State should not be allowed to compel speech (what code you write)" — is the right frame but gets called "a stretch" by **TZubiri**.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| OS-level attestation is the least invasive option | Strong | terribleperson. Factually correct about the alternative landscape. Thread dismisses via slippery-slope but doesn't engage the actual tradeoff. |
| It's just standardizing parental controls | Medium | kybernetikos, stephbook. Ignores that mandating features in FOSS is categorically different from offering them. |
| The project is performative / no real risk | Medium | parsimo2010, singpolyma3. Fair that the AG won't sue a bash script. But the article explicitly wants to be sued — the legal test case *is* the product. |
| The site is AI slop, hard to take seriously | Weak-to-Medium | Valid observation about the site's authorship. But ad hominem to the argument. The legal analysis in the article stands regardless of who or what wrote it. |
| Children need protection, this is just anti-regulation | Weak | mursu, stephbook. Nobody in the thread argues against child safety. The dispute is whether this mechanism achieves it. |

### What the Thread Misses

- **Jurisdictional arbitrage is the real endgame.** If CA mandates OS-level age signals, and NY mandates verified identity, and the EU mandates something else, OS providers face an impossible patchwork. The actual outcome is that only platforms large enough to implement per-jurisdiction compliance survive — which is exactly the moat thesis, scaled globally. Nobody discusses this.

- **The enforcement mechanism is stranger than anyone acknowledges.** AB 1043 fines are $7,500 "per affected child." But as the article points out, you identify affected children *through the age data you're being fined for not collecting*. This circular dependency makes enforcement structurally incoherent. The thread doesn't pick this up.

- **The "code as compelled speech" question is heading to SCOTUS.** NetChoice v. Paxton is already there on adjacent issues. AB 1043's requirement that OS developers implement specific APIs is a much cleaner compelled-speech case than content moderation mandates. If someone actually litigates it, this is a plausible First Amendment challenge. The thread waves at this but doesn't connect the legal dots.

- **What happens to privacy-focused distros?** Tails, Whonix, Qubes — distributions whose *entire purpose* is anonymity — would be required to implement age-disclosure APIs. The article mentions this briefly. The thread ignores it entirely. This is where the law's absurdity is most concrete and most dangerous.

### Verdict

The thread is having two different arguments past each other. Camp A says "any government-mandated OS feature is an unacceptable precedent." Camp B says "the alternative is worse and already happening." Both are right, which is why neither can convince the other — they're optimizing for different threat models on different timescales. Camp A is correct about the 10-year trajectory (mandates ratchet). Camp B is correct about the 2-year trajectory (cloud ID verification is spreading now).

What the thread circles but never states: the real audience for Ageless Linux isn't the California AG or HN commenters. It's future courts. McCardle is manufacturing a test case — a maximally sympathetic defendant (a bash script, a $12 RISC-V board, children learning Python) designed to produce a legal ruling that the law's definitions are unconstitutionally overbroad. The project is litigation bait wearing a hoodie. Whether the AG takes it is beside the point; the documented record of intentional, public, good-faith noncompliance is the asset.
