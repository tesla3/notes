# Critical Review: Neural Networks Generalize on Low Complexity Data

**Paper:** Chatterjee & Sudijono (2024). *Neural Networks Generalize on Low Complexity Data.* arXiv:2409.12446v1. Stanford University.  
**Reviewed:** 2026-03-23  
**Paper type:** Pure theory. No experiments, no empirical validation, no algorithms. Every result is a theorem, proposition, or corollary. The "examples" (primality, sum-of-squares, triangle inequality) are analytical applications of the theorems—plugging in program parameters to derive sample complexity bounds—not experiments run on actual networks.

---

## 1. What the Paper Claims

The central claim is precisely scoped and should be stated exactly:

> "We show that feedforward neural networks with ReLU activation generalize on low complexity data, suitably defined. Given i.i.d. data generated from a simple programming language, the minimum description length (MDL) feedforward neural network which interpolates the data generalizes with high probability."

The paper does **not** claim that SGD-trained networks generalize, nor that any practical training algorithm finds the MDL interpolator. The authors are explicit about this:

> "Theorem 5.1 provides no practical guidance on how to find the minimum description length neural network interpolating the data, beyond brute-force search. [...] Our theorem also does not say anything about neural networks trained with gradient-based methods."

This is a **pure existence theorem** about a combinatorial object (the MDL network) over a restricted data model (Simple Neural Programs). The claim is narrow, technically correct, and honestly presented.

---

## 2. Paper Type: Pure Theory

This is a **purely theoretical paper**. It contains:

- **Zero experiments.** No networks are trained. No datasets are generated. No test errors are measured.
- **Zero algorithms.** No procedure for finding the MDL interpolator is proposed beyond brute-force search, which is uncomputable.
- **Zero empirical validation.** The primality and sum-of-squares "examples" are worked-out corollaries—substituting L=11, V=9, B(N)=N² into the main theorem to get O(ln N / n) error bounds—not experiments on actual hardware.

Every result is a theorem, proposition, lemma, or corollary. The paper sits in the tradition of Solomonoff induction (1964) and Kolmogorov complexity theory: theorems about what *ideal* learners would do, not about what any implementable system does.

## 3. The Architecture of the Argument

The paper has a clean three-act structure:

### Act I: Programs → Networks (Thm 3.1)
Any **Simple Neural Program** (SNP)—a restricted imperative language with integer variables, `for` loops, `if` statements, basic arithmetic, and comparisons—can be compiled into a feedforward ReLU network that computes the same function on all inputs in [N]^I.

This is unsurprising. The Turing completeness of neural networks dates to McCulloch & Pitts (1943) and Siegelmann & Sontag (1992). The paper acknowledges this: "it is not so surprising that Theorem 3.1 holds." What matters is the *efficiency of the encoding*, not its existence.

### Act II: Networks are Compressible (Prop 4.1)
The key insight: `for` loops compile to *repeated blocks of identical layers*, so the network's parameter string admits a compact representation via run-length-like encoding. For a program of length L with V variables bounded by B(N):

> description length ≤ O(L³V² log₂ B(N))

This is polynomial in program attributes, not in N. The description length alphabet is finite: {I, ",", −, 0, 1, *, W, B, (, )}.

### Act III: MDL Interpolator Generalizes (Thm 5.1)
The proof is a counting argument. Given description length ≤ s, Lemma 4.1 bounds the number of networks: |𝒩_s| ≤ e^{cs}. For any two networks in 𝒩_s that disagree on a set of μ-measure ≥ ε, the probability they agree on all n i.i.d. training points is ≤ (1−ε)^n. Union-bounding over all pairs in 𝒩_s² and choosing n large enough makes this probability < δ.

The resulting sample complexity:

> n = O(L³V² log B(N) · (1/ε) · (ln(1/δ) + 1))

For primality testing (L=11, V=9, B(N)=N²), Corollary 5.1 gives:

> P(f̂_MDL(x) ≠ P(x)) ≤ C · L³V² ln B(N) / n = O(ln N / n)

So with n ≫ (ln N)², the MDL interpolator classifies primes correctly with high probability.

---

## 4. What is Genuinely Novel

### 4.1 The Compilation Pipeline as a Complexity Measure

The deepest contribution is **not** the generalization theorem itself—that follows from a standard MDL counting argument. The novelty is the *specific* compilation pipeline from a human-readable programming language to ReLU networks, with tight description-length accounting.

Previous program-to-network results exist—Weiss, Goldberg & Yahav (2021) compile RASP to transformers; Livni et al. (2014) show any T(d)-time Turing machine maps to a network of depth O(T(d)) and size O(T(d)²). But these either target different architectures or don't track description length. The SNP → ReLU → compressed representation → description length chain is the paper's genuine construction.

### 4.2 The `for` Loop Compression Insight

The observation that `for` loops produce *identical repeated layer blocks* is elegant and crucial. Without it, the description length would scale with the runtime (potentially polynomial in N), not the program length. This is what makes the bound polynomial in L rather than polynomial in B(N).

> "The encoding of the `for` loop repeats the block of layers inside the `for` loop B+1 times, but ensures that the clause is only applied x_e − x_s + 1 times, by keeping track of a counter variable. The advantage of this construction is that the layers applied to encode the `for` loop are exactly the same copies of each other, repeated B+1 times."

The repetition-compressed representation RC(P) captures this: parenthesized substrings raised to power B+1, stored in O(log B) bits. This is the mechanical heart of the paper.

### 4.3 Tempered Overfitting Extension (Thm 7.1)

The noisy-data extension is well-executed. With ρn corrupted labels:

> error rate of f̂_MDL ≤ ρ + ε, with high probability

This is achieved by showing that the corrupted data can be interpolated by augmenting the true network F_P with a "patch" network that hardcodes the ρn corrections, adding O(I²ρn log(B+I)) to the description length. The resulting tempered overfitting bound—O(ρ) + o_n(1)—is tighter than the ρ ln(1/ρ) + o_n(1) achieved by Harel et al. (2024, NeurIPS) for binary threshold networks, though in a different setting.

---

## 5. Critical Analysis: What the Paper Cannot Do

### 5.1 The Computability Gap: MDL is Uncomputable

The most fundamental limitation, which the authors acknowledge, is that **finding the MDL interpolator is computationally intractable**. It requires searching over all valid symbol strings of bounded length—a problem at least as hard as Kolmogorov complexity, which is uncomputable in general.

This places the result squarely in the tradition of Solomonoff induction (1964): a beautiful theoretical ideal that provides no algorithm. Manoj & Srebro (2023) proved analogous tempered-overfitting results for the MDL learning rule over *universal* description languages, also without algorithmic guidance. The question is whether restricting to neural networks (vs. arbitrary programs) buys anything computational. This paper suggests it doesn't—the search space is still exponential in s.

**Implication:** The theorem tells us that *if* we could find the MDL interpolator, it would generalize. But the "if" is doing enormous work. In practice, SGD finds *some* interpolator, not the MDL one. The paper's relevance to practice hinges entirely on the empirically observed simplicity bias of SGD—that gradient descent implicitly favors low-complexity solutions (Valle-Pérez et al., 2018; Mingard et al., 2019; Goldblum et al., 2023). This connection is suggestive but unproven.

### 5.2 The Expressiveness Gap: SNPs Are Extremely Restricted

The programming language is deliberately minimal, and the restrictions matter:

1. **No arrays or variable-indexed memory access.** You cannot write `a[i]` where `i` is a variable. This rules out essentially all non-trivial algorithms.

2. **No while loops or recursion.** Only bounded `for` loops. This means SNPs are not Turing-complete—they compute only primitive recursive functions bounded by B(N).

3. **No floating-point arithmetic.** All variables are nonnegative integers bounded by B(N). The bound B(N) enters the description length logarithmically, but it enters the *network depth* linearly (each `for` loop repeats B+1 times).

4. **Variable count is fixed, independent of input.** You cannot have O(N) variables. This precludes algorithms that need working memory proportional to input size—which includes, e.g., sorting, dynamic programming, or anything with a lookup table.

The authors state this honestly:

> "The notion of SNPs is somewhat restricted. Although it accommodates many interesting examples, notice that the number of variables cannot scale with the inputs. Moreover, arrays and accessing arrays with variable locations is not allowed."

**Implication:** The "low complexity data" that the theorem covers is *extremely* low complexity. The examples—primality testing via trial division, sum-of-squares checking, triangle inequality—are all problems solvable by short nested loops over bounded integers. These are computationally simple but not representative of the data distributions neural networks encounter in practice (images, text, time series).

### 5.3 The Network Depth Explosion

A critical detail buried in the construction: the compiled network for a depth-d SNP with bound B(N) has layers repeated B+1 times per `for` loop. For the prime-checking program with B(N) = N², the network has depth on the order of (N²)^d · L. For even moderate N, this is an astronomically deep network—far beyond anything trained in practice.

The width is better controlled (≤ 4LV, i.e., O(L·V)), but the depth makes these networks purely theoretical objects. No one is training a network with 10^12 layers to check if numbers up to N = 10^6 are prime.

### 5.4 The Uniform Distribution Assumption

All examples use the uniform distribution on [N]^I or analyze behavior relative to an arbitrary distribution μ. But Theorem 5.1's sample complexity is:

> n = Ω(L³V² log B(N) / ε)

For primality with ε set to the density of primes (~1/ln N), you need n = Ω((ln N)² · L³V²). This is impressively small relative to N, but the theorem says nothing about *which* primes are classified correctly. The error guarantee is over a random test point from μ—it could systematically fail on all primes in a particular residue class, for instance. The guarantee is in expectation, not worst-case over inputs.

### 5.5 The Description Length Measure is Bespoke

The alphabet 𝒜 and the compression scheme (allowing (...)^*k notation) are tailored to make `for` loops compress well. A different description length measure—say, one based on counting nonzero weights, or on the rank of weight matrices, or on parameter norm—would give entirely different results. The theorem is sensitive to this choice, and there's no argument that this particular description length is the "right" one for understanding practical neural networks.

Remark 4.1 acknowledges the bound may be loose: most weight matrices are sparse (identity + small perturbation), so the L³V² factor could potentially be tightened.

---

## 6. Relationship to the Broader Literature

### 6.1 The Zhang et al. (2017/2021) Puzzle

The paper is motivated by the foundational observation of Zhang, Bengio, Hardt, Recht & Vinyals (2017, CACM 2021) that neural networks can fit random labels yet generalize on real data. VC dimension and Rademacher complexity, being distribution-independent, cannot distinguish these cases. The paper's response: make the *data* structured (generated by a short program), and show that MDL selects the structured explanation.

This is a clean theoretical resolution of a conceptual puzzle, but it resolves it by fiat—the data is *defined* to be low-complexity, and MDL is *designed* to prefer low-complexity explanations. The hard question—why does SGD on real data behave *as if* it's doing MDL?—remains open.

### 6.2 Comparison with Manoj & Srebro (2023)

Manoj & Srebro (2023, COLT) proved that the minimum program length (MPL) learning rule—essentially Solomonoff's universal prediction applied to interpolation—exhibits tempered overfitting for *any* universal description language. Their result is more general (applies to all computable functions, not just SNPs) but also more abstract.

Chatterjee & Sudijono's contribution is to instantiate this abstract framework for a *specific* architecture (feedforward ReLU nets) with a *specific* complexity measure (the symbol-string description length). This gives concrete, interpretable bounds—e.g., O(ln N / n) for primality—whereas Manoj & Srebro's bounds involve unspecified constants from the universal description language.

### 6.3 Comparison with Harel et al. (2024, NeurIPS)

Harel, Hoza, Vardi, Evron, Srebro & Soudry (2024) prove tempered overfitting for minimum-size *binary threshold* networks—a different architecture and complexity measure (number of weights, not description length). Their error bound with adversarial noise is ρ ln(1/ρ) + o_n(1), slightly worse than this paper's O(ρ) + o_n(1), though in a different setting (binary inputs/outputs, teacher-student model with noise).

The comparison is instructive: both papers show that "smallest network that fits the data" generalizes temperedly. The specific rate depends on the architecture and complexity measure, but the qualitative phenomenon—tempered overfitting of MDL-type interpolators—appears robust across settings.

### 6.4 The Simplicity Bias Connection

The empirical literature on simplicity bias in neural networks (Valle-Pérez et al., 2018; Mingard et al., 2019; Goldblum et al., 2023) shows that SGD-trained networks favor low Kolmogorov complexity functions. Goldblum et al. (2023) argue:

> "While virtually all uniformly sampled datasets have high complexity, real-world problems disproportionately generate low-complexity data, and we argue that neural network models share this same preference, formalized using Kolmogorov complexity."

If SGD's implicit bias could be shown to approximate MDL selection, this paper's theorems would become directly relevant to practice. But that connection remains conjectural.

---

## 7. The Deepest Insight

The paper's deepest insight is not its main theorem but an *architectural* observation: **the structure of a program maps naturally onto the structure of a deep network, and the compressibility of the program (loops = repeated structure) maps onto the compressibility of the network (repeated layer blocks).** This is more than a proof technique—it's a conceptual bridge between programming language theory and neural network complexity theory.

Consider: a `for` loop that runs B times becomes B copies of identical layers. The program's *syntactic* complexity (number of statements) controls the network's *description length*, while the program's *runtime* complexity (number of steps) controls the network's *depth*. Generalization depends on the former, not the latter. This cleanly separates *what* a network computes (which may be complex) from *how simply it can be described* (which determines generalization).

This resonates with the grokking literature (e.g., Nanda et al., 2023; arxiv 2412.09810), where networks transition from memorization to generalization by finding compressed internal representations. The SNP framework makes this transition legible: a network that memorizes a lookup table has high description length; one that implements a short program has low description length. MDL prefers the latter.

---

## 8. What Would Strengthen the Paper

1. **An algorithm, even approximate.** Even a heuristic that tends toward low description length (e.g., weight pruning + quantization + architecture search) would connect theory to practice.

2. **Empirical validation.** Train actual networks on primality data or sum-of-squares data. Do SGD-trained networks' weights exhibit the repetitive structure predicted by the SNP compilation? Do they achieve the O(ln N / n) error rate?

3. **Extension to richer languages.** Arrays, variable-length loops, or at minimum `while` loops with provable termination. The current SNP language is too restricted to model most algorithmic tasks.

4. **Connection to gradient descent.** Even a partial result—e.g., showing that SGD with weight decay on the compiled network architecture converges to a low-description-length solution—would be transformative.

5. **Tighter description length bounds.** The authors note the L³V² factor is likely loose due to weight matrix sparsity. Exploiting this could yield practically tighter sample complexity.

---

## 9. Verdict

This is a **technically clean, honestly scoped, and conceptually clarifying** paper from a first-rate probabilist (Chatterjee is a Stanford professor of Statistics and Mathematics, Infosys Prize laureate in mathematical sciences). The proofs are correct and the construction is explicit. The paper advances our *theoretical understanding* of why low-complexity data should be learnable by neural networks under MDL-type selection principles.

But its **practical relevance is essentially zero** in its current form. The MDL interpolator is uncomputable, the SNP language is too restricted to model real tasks, the compiled networks are absurdly deep, and no connection to gradient-based training is established. It is a theorem about the *existence* of good neural network solutions, not about *finding* them.

The paper belongs in the same intellectual lineage as Solomonoff induction and Kolmogorov complexity: beautiful, foundational, and non-constructive. It tells us that the universe of feedforward ReLU networks *contains* good generalizers for low-complexity data, and that MDL is the principle that selects them. Whether practical training algorithms approximate this principle is the open question that would make this work matter beyond theory.

**Rating:** Strong theoretical contribution. Honest about limitations. Advances the MDL-for-neural-networks research program meaningfully. Not a breakthrough—more a careful, well-executed step in a longer intellectual project connecting algorithmic information theory to deep learning theory.

---

## Sources

- Chatterjee & Sudijono (2024). arXiv:2409.12446v1.
- Zhang, Bengio, Hardt, Recht & Vinyals (2021). "Understanding deep learning (still) requires rethinking generalization." *CACM* 64(3).
- Manoj & Srebro (2023). "Shortest Program Interpolation Learning." *COLT 2023*, PMLR 195.
- Harel, Hoza, Vardi, Evron, Srebro & Soudry (2024). "Provable Tempered Overfitting of Minimal Nets and Typical Nets." *NeurIPS 2024*.
- Valle-Pérez, Camargo & Louis (2018). "Deep learning generalizes because the parameter-function map is biased towards simple functions." arXiv:1805.08522.
- Goldblum, Finzi, Rowan & Wilson (2023). "The No Free Lunch Theorem, Kolmogorov Complexity, and the Role of Inductive Biases in Machine Learning." arXiv:2304.05366.
- Mingard, Skalse, Valle-Pérez et al. (2019). "Neural networks are a priori biased towards boolean functions with low entropy." arXiv:1909.11522.
- Solomonoff (1964). "A formal theory of inductive inference." *Information and Control* 7(1).
- Livni, Shalev-Shwartz & Shamir (2014). "On the computational efficiency of training neural networks." *NeurIPS 2014*.
- Weiss, Goldberg & Yahav (2021). "Thinking like transformers." *ICML 2021*.
- Siegelmann & Sontag (1992). "On the computational power of neural nets." *COLT 1992*.
- Nanda et al. (2023). "Progress measures for grokking via mechanistic interpretability." arXiv:2301.05217.
