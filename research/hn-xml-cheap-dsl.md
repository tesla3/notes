← [Index](../README.md)

## HN Thread Distillation: "XML is a Cheap DSL"

**Source:** https://news.ycombinator.com/item?id=47375764 (243 comments, 140 authors)

**Article summary:** Alex Petros, engineering lead on the IRS's new open-source Tax Withholding Estimator, argues XML is the right format for declarative tax logic. The "Fact Graph" (originally from IRS Direct File) encodes the US Tax Code as named, dependency-linked XML facts. XML's named tags, universal tooling (XPath, fzf one-liners), and cross-platform parsability make it a cheaper DSL than JSON, s-expressions, or Prolog — even though those alternatives look "nicer." The key insight: a universal data representation is worth its weight in gold, and XML is the only serious option besides JSON when you need a DSL.

### Dominant Sentiment: Grudging respect, strong nostalgia friction

The thread is split between people who lived through XML's heyday and carry visceral scars (SOAP, XSD meetings, SAX parsers) and people evaluating the article's narrow claim on its merits. The former group is louder; the latter is more correct.

### Key Insights

**1. The real XML trauma was the ecosystem, not the format**

The sharpest division in the thread is between "XML the format" and "XML the ecosystem." `llm_nerd` nails this: *"XML with XSD and XSL(T) was godly for data flow systems… What hurt XML was the ecosystem of overly complex shit that just sullied the whole space. Namespaces were a disaster… poorly thought out garbage specs like SOAP just made everyone want to toss all of it into the garbage bin."* The article is careful to scope its claim — XML as a cheap DSL, not XML as a religion — but most negative commenters are reacting to their memories of the ecosystem, not to the argument being made.

**2. skrebbel's counter is the strongest and most experienced**

`skrebbel` delivers the thread's most substantive rebuttal: *"Every client or server speaking an XML-based protocol had to have their own encoder/decoder… JSON, while not perfect, maps neatly onto data structures that nearly every language has: arrays, objects and dictionaries. That is why it got popular, and no other reason."* This is well-argued and historically accurate — for data interchange. But skrebbel then concedes the article's actual thesis: *"XML is a DSL. So working with XML is a bit like working with a custom designed language… That's where XML shines… But the article you quoted makes the case that XML was good at more stuff than 'lightweight DSL'… And believe me, it really wasn't."* The agreement here is bigger than the disagreement. Skrebbel is arguing against a position the article doesn't hold.

**3. The s-expression contingent reveals the real alternative**

Multiple commenters (`catlifeonmars`, `phlakaton`, `Decabytes`, `imglorp`) independently converge on s-expressions as the superior DSL substrate. `catlifeonmars`: *"S-expressions are great. They are trivial to implement parsers for."* `phlakaton`: *"it just makes me want to dust off and write a bunch of s-expr tools to make that ecosystem equally or more attractive for DSLs."* The article anticipated this and has the best counter: s-expressions work great in Lisp, but XML gives you universal tooling for free. The s-expression people are implicitly conceding the article's framing (you need something structured, not JSON) while arguing about the implementation. Nobody actually shipped an s-expression tax engine.

**4. The embedded-DSL-in-a-real-language proposal exposes a security intuition gap**

`miki123211` proposes encoding the fact graph directly in Python with operator overloading — `total_owed = Max(Dollar(0), total_tax - total_credits)`. `catlifeonmars` immediately flags the issue: *"You've now introduced arbitrary code execution into something that should be data."* The ensuing exchange is revealing: `n_e` argues "it's source code, not untrusted input," and `catlifeonmars` responds with the real insight: *"A natural extension of this is to be able to simulate tax code that hasn't been implemented yet. 'Bring your own facts' is practically begging to be a feature here."* This is a sharp product-thinking argument — the data/code boundary matters not because of today's threat model but because of tomorrow's feature requests.

**5. The Norway tangent reveals the real meta-argument**

`thatwasunusual` derails into "Norway solved taxes years ago" and `SoftTalker` patiently explains the structural differences (self-employment, tax incentives as policy tools, the tax-prep lobbying industry). The exchange is substantively interesting but reveals the thread's deepest dynamic: most commenters are arguing about *whether* taxes should be complicated, not about what format to use *given* that they are. The article's entire premise — that tax complexity is a fact to be managed, not a problem to be wished away — never gets directly challenged but is implicitly rejected by a large fraction of the thread.

**6. XSD validation vs. Zod: a generational proxy war**

`dale_glass` complains JSON has "no good system for validation." `n_e` fires back: *"With tools like Zod, it is much more pleasant to write schemas and validate."* `catlifeonmars` correctly observes this is backwards: *"Libraries like zod exist because JSON is so ubiquitous. Someone could just as easily implement a zod for XML."* This exchange captures a subtle dynamic: the JSON ecosystem has rebuilt many of XML's features (schema validation, comments via JSON5, typed parsing) in piecemeal fashion, and each piece is genuinely better than its XML equivalent, but the aggregate is less coherent. Nobody states this directly.

**7. The "cheap" in "cheap DSL" is doing all the work**

The article's real argument isn't that XML is the *best* DSL substrate — it's that it's the *cheapest*. You get parsing, tooling, XPath, cross-language support, and comments for zero implementation cost. `alexpetros` (the author, commenting) reinforces this: *"an embedded DSL to represent most expressions tersely is a worthwhile idea to explore — it's just a more expensive one. That's a cost-effective choice at some levels of resourcing, but not every level of resourcing."* This is the most important sentence in the thread and most commenters missed it. The IRS is not a startup that can pick the aesthetically optimal tool; it needs the one with the lowest adoption barrier across a heterogeneous team.

### Common Pushbacks

| Pushback | Quality | Note |
|----------|---------|------|
| JSON is simpler and maps to native data structures | **Strong** for interchange, **Misapplied** for DSLs | skrebbel's argument is correct but doesn't address the article's actual claim |
| S-expressions are better for this | **Medium** | Theoretically true, practically irrelevant — no tooling ecosystem outside Lisp |
| Just embed the DSL in a real language | **Weak** | catlifeonmars correctly identifies the data/code boundary problem |
| YAML is a middle ground | **Weak** | Multiple commenters (`IshKebab`, `DamonHD`) immediately reject; `tuetuopay` acknowledges you'd need a "safe strict subset" which doesn't exist |
| XML is unreadable/unmaintainable | **Weak** | Visceral but unsupported — most who say this are remembering SOAP, not structured DSLs |
| AI will solve format debates | **Weak** | `foltik`: *"An omniscient AI would tell you the same thing as any experienced engineer: 'it depends.'"* |

### What the Thread Misses

- **The article is really about the IRS's engineering constraints, not XML's inherent qualities.** The Fact Graph was inherited from Direct File. The team had to build on it with limited budget and heterogeneous skills. XML was "cheap" in a very literal, organizational sense. Most commenters evaluate XML in the abstract rather than engaging with this constraint.

- **Nobody discusses XML's actual failure mode in this context: schema evolution.** What happens when the tax code changes and you need to version the fact dictionary? XSD's approach to schema evolution is notoriously painful. This is the one area where the article's thesis has a real vulnerability, and nobody probes it.

- **The thread never engages with auditability as a first-class requirement.** The article's strongest argument — that declarative graphs give you "auditability and introspection for free" — gets almost no discussion. For tax software specifically, being able to prove *why* a number was computed is arguably more important than how pleasant the format is to author. `cluckindan` dismisses it as dependent on implementation, which is technically true but misses the structural advantage.

- **The LLM angle is mentioned but not developed.** `matchagaucho` and `cl0ckt0wer` note that LLMs like XML, and `jrm4` asks whether AI can solve format debates. Nobody connects the dots: if LLMs are increasingly writing and reading these specs, XML's verbosity becomes a *feature* (more context for the model) rather than a bug.

### Verdict

The article makes a narrow, correct claim — XML is the cheapest DSL when you need universal tooling and don't have the budget to build a custom parser ecosystem — and the thread mostly argues against a broader claim the article never made. The real lesson isn't about XML vs. JSON vs. s-expressions; it's that **format choice is an organizational decision, not a technical one**, and the IRS made the rational choice given their constraints. The thread's collective inability to engage with this framing — preferring instead to relitigate the XML Wars of 2005 — is itself the most interesting signal.
