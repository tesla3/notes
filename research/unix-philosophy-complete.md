← [Rule 5: Data Dominates](./rule5-data-dominates-education.md) · [Index](../README.md)

# The Unix Philosophy — Complete Reference

A consolidated reference of all major formulations of the Unix philosophy, from the original practitioners to later codifications.

**Source hierarchy:** McIlroy (1978) → Pike (1989) → Gancarz (1994) → Raymond (2003). Each layer adds specificity; Raymond's is the most comprehensive.

---

## 1. Doug McIlroy's Formulation (1978)

McIlroy, inventor of Unix pipes and head of the Computing Techniques Research Department at Bell Labs (where Unix was born), stated the philosophy in a Bell System Technical Journal article:

> (i) Make each program do one thing well. To do a new job, build afresh rather than complicate old programs by adding new features.
>
> (ii) Expect the output of every program to become the input to another, as yet unknown, program. Don't clutter output with extraneous information. Avoid stringently columnar or binary input formats. Don't insist on interactive input.
>
> (iii) Design and build software, even operating systems, to be tried early, ideally within weeks. Don't hesitate to throw away the clumsy parts and rebuild them.
>
> (iv) Use tools in preference to unskilled help to lighten a programming task, even if you have to detour to build the tools and expect to throw some of them out after you've finished using them.

Later summarized (quoted in Peter Salus, *A Quarter Century of Unix*, 1994):

> This is the Unix philosophy: Write programs that do one thing and do it well. Write programs to work together. Write programs to handle text streams, because that is a universal interface.

**Source:** McIlroy, M. D., Pinson, E. N., Tague, B. A. "Unix Time-Sharing System: Foreword." *The Bell System Technical Journal* 57(6), 1978, pp. 1899–1904.

---

## 2. Rob Pike's 5 Rules of Programming (1989)

From "Notes on Programming in C":

1. **You can't tell where a program is going to spend its time.** Bottlenecks occur in surprising places, so don't try to second guess and put in a speed hack until you've proven that's where the bottleneck is.

2. **Measure.** Don't tune for speed until you've measured, and even then don't unless one part of the code overwhelms the rest.

3. **Fancy algorithms are slow when n is small, and n is usually small.** Fancy algorithms have big constants. Until you know that n is frequently going to be big, don't get fancy. (Even if n does get big, use Rule 2 first.)

4. **Fancy algorithms are buggier than simple ones, and they're much harder to implement.** Use simple algorithms as well as simple data structures.

5. **Data dominates.** If you've chosen the right data structures and organized things well, the algorithms will almost always be self-evident. Data structures, not algorithms, are central to programming.

Pike adds: "Rules 3 and 4 are instances of Ken Thompson's design maxim: **When in doubt, use brute force.**"

**Source:** Pike, R. "Notes on Programming in C." February 21, 1989. Originally internal Bell Labs document; widely circulated.

---

## 3. Mike Gancarz's 9 Paramount Precepts (1994)

Gancarz, a member of the team that designed the X Window System, codified the philosophy from practitioner experience:

1. **Small is beautiful.**
2. **Make each program do one thing well.**
3. **Build a prototype as soon as possible.**
4. **Choose portability over efficiency.**
5. **Store data in flat text files.**
6. **Use software leverage to your advantage.**
7. **Use shell scripts to increase leverage and portability.**
8. **Avoid captive user interfaces.**
9. **Make every program a filter.**

Gancarz also added 10 "lesser tenets":

- Allow the user to tailor the environment.
- Make operating system kernels small and lightweight.
- Use lowercase and keep it short.
- Save trees.
- Silence is golden.
- Think parallel.
- The sum of the parts is greater than the whole.
- Look for the 90-percent solution.
- Worse is better.
- Think hierarchically.

**Source:** Gancarz, M. *The UNIX Philosophy.* Digital Press, 1994. ISBN 1-55558-123-4.

---

## 4. Eric S. Raymond's 17 Rules (2003)

The most comprehensive codification, from *The Art of Unix Programming*. Raymond synthesized the earlier formulations into 17 named rules, grouped here by concern.

### Structure

| # | Rule | Principle |
|---|---|---|
| 1 | **Rule of Modularity** | Write simple parts connected by clean interfaces. |
| 3 | **Rule of Composition** | Design programs to be connected to other programs. |
| 4 | **Rule of Separation** | Separate policy from mechanism; separate interfaces from engines. |
| 17 | **Rule of Extensibility** | Design for the future, because it will be here sooner than you think. |

### Behavior

| # | Rule | Principle |
|---|---|---|
| 2 | **Rule of Clarity** | Clarity is better than cleverness. |
| 5 | **Rule of Simplicity** | Design for simplicity; add complexity only where you must. |
| 6 | **Rule of Parsimony** | Write a big program only when it is clear by demonstration that nothing else will do. |
| 7 | **Rule of Transparency** | Design for visibility to make inspection and debugging easier. |
| 8 | **Rule of Robustness** | Robustness is the child of transparency and simplicity. |
| 10 | **Rule of Least Surprise** | In interface design, always do the least surprising thing. |
| 11 | **Rule of Silence** | When a program has nothing surprising to say, it should say nothing. |
| 12 | **Rule of Repair** | When you must fail, fail noisily and as soon as possible. |
| 16 | **Rule of Diversity** | Distrust all claims for "one true way". |

### Approach

| # | Rule | Principle |
|---|---|---|
| 9 | **Rule of Representation** | Fold knowledge into data so program logic can be stupid and robust. |
| 13 | **Rule of Economy** | Programmer time is expensive; conserve it in preference to machine time. |
| 14 | **Rule of Generation** | Avoid hand-hacking; write programs to write programs when you can. |
| 15 | **Rule of Optimization** | Prototype before polishing. Get it working before you optimize it. |

### Key elaborations from the text

- **Modularity:** "The only way to write complex software that won't fall on its face is to hold its global complexity down — to build it out of simple parts connected by well-defined interfaces, so that most problems are local."
- **Clarity:** "Write programs as if the most important communication they do is not to the computer that executes them but to the human beings who will read and maintain the source code in the future (including yourself)."
- **Robustness:** "One very important tactic for being robust under odd inputs is to avoid having special cases in your code. Bugs often lurk in the code for handling special cases."
- **Representation:** "Even the simplest procedural logic is hard for humans to verify, but quite complex data structures are fairly easy to model and reason about. [...] Data is more tractable than program logic. It follows that where you see a choice between complexity in data structures and complexity in code, choose the former."
- **Least Surprise:** "The flip side of the Rule of Least Surprise is to avoid making things superficially similar but really a little bit different. This is extremely treacherous because the seeming familiarity raises false expectations." (Henry Spencer, quoted by Raymond)
- **Optimization:** "'Premature optimization is the root of all evil' — Donald Knuth, quoting C. A. R. Hoare."

**Source:** Raymond, E. S. *The Art of Unix Programming.* Addison-Wesley, 2003. Chapter 1, "Basics of the Unix Philosophy." Full text: http://www.catb.org/~esr/writings/taoup/html/ch01s06.html

---

## Cross-Reference: Who Said What

| Principle | McIlroy (1978) | Pike (1989) | Gancarz (1994) | Raymond (2003) |
|---|---|---|---|---|
| Do one thing well | ✓ (i) | | ✓ (#2) | ✓ (Modularity, Parsimony) |
| Composability | ✓ (ii) | | ✓ (#9) | ✓ (Composition) |
| Text as universal interface | ✓ (ii) | | ✓ (#5) | ✓ (Composition elaboration) |
| Prototype early | ✓ (iii) | | ✓ (#3) | ✓ (Optimization) |
| Build tools | ✓ (iv) | | ✓ (#6, #7) | ✓ (Generation) |
| Don't optimize prematurely | | ✓ (#1, #2, #3) | | ✓ (Optimization) |
| Simple algorithms & data structures | | ✓ (#4) | | ✓ (Simplicity) |
| Data dominates | | ✓ (#5) | | ✓ (Representation) |
| Brute force when in doubt | | ✓ (Thompson maxim) | ✓ (#8 "90% solution") | ✓ (Simplicity) |
| Worse is better | | | ✓ (lesser tenet) | ✓ (Diversity) |
| Silence is golden | | | ✓ (lesser tenet) | ✓ (Silence) |

---

## The Overarching Principle

Brian Kernighan, quoted by Raymond:

> "Controlling complexity is the essence of computer programming."

All formulations are variations on this theme. The Unix philosophy is a set of heuristics for managing complexity in software by keeping the parts small, the interfaces clean, and the data visible.
