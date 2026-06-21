# Erdős Problem 346: Limit-Exists Interpretation Attempt in Lean 4

This repository contains a sorry-free Lean 4 formalization of an attempt on the
limit-exists interpretation of Erdős Problem 346.

You can check the Lean proof in your browser using Lean4Web:
**[open the Lean4Web check](https://live.lean-lang.org/#url=https%3A%2F%2Fraw.githubusercontent.com%2FKitaKen1%2Ferdos346-ratio-limit-lean%2Fmain%2Flean4web%2FLimitExistsVariantLean4Web.lean)**.

## Mathematical Background: Two Interpretations of Erdős Problem 346

### Original Problem Statement

The statement on the
[Erdős Problems page for Problem #346](https://www.erdosproblems.com/346)
asks the following. [Reference 1]

Let \(A=\{1\leq a_1<a_2<\cdots\}\) be an increasing sequence of positive
integers.  Assume:

- deleting any finite subset \(B\) leaves \(A\setminus B\) complete;
- deleting any infinite subset \(B\) leaves \(A\setminus B\) not complete.

Here, complete means that all sufficiently large integers can be written as
sums of distinct members of the sequence.

Question: if there is some \(\epsilon>0\) such that
\[
\frac{a_{n+1}}{a_n}\geq 1+\epsilon
\]
for all \(n\), must
\[
\lim_n \frac{a_{n+1}}{a_n}=\frac{1+\sqrt{5}}{2}
\]
hold?

### Two Interpretations for Erdős Problem 346

The question can be read in two closely related ways, depending on whether the
existence of the quotient limit is part of the conclusion or part of the
hypotheses.

First: convergence-from-hypotheses interpretation.  The original hypotheses
alone are asked to imply both that the quotient sequence \(a_{n+1}/a_n\)
converges and that its limit is the golden ratio.

Second: limit-exists interpretation.  The quotient limit is assumed to exist,
and the question is whether the hypotheses force that limit to be the golden
ratio.

### Forum discussion and this repository relation

In the discussion thread for Problem #346, Liam Price submitted an answer for
the first, convergence-from-hypotheses interpretation [Reference 2].
In response, Dogmachine proposed the second, limit-exists interpretation
[Reference 3], citing ambiguity in the Erdős-Graham phrasing [Reference 4] and
Graham's earlier formulation [Reference 5], which asks whether one can have
\(\lim_n a_{n+1}/a_n \neq (1+\sqrt{5})/2\).  This supports reading the problem
as already assuming the quotient limit exists.

This repository shows a Lean 4 formalization for that second,
limit-exists interpretation.  The formalized statement is:

> If the two deletion hypotheses hold, the sequence has a uniform ratio gap,
> and the quotient sequence \(a_{n+1}/a_n\) has a limit \(L > 1\), then that
> quotient sequence tends to the golden ratio.

## Natural-Language Statement and Lean Theorem Correspondence

The final public theorem for the value-deletion formulation is:

```lean
theorem main_valueDeletion_expanded
    {a : ℕ → ℕ}
    (hmono : StrictMono a)
    (hpos : ∀ n : ℕ, 0 < a n)
    (hratioGap :
      ∃ ε : ℝ, 0 < ε ∧
        ∀ n : ℕ, 1 + ε ≤ quotient a n)
    (hfinite :
      ∀ B : Set ℕ, B.Finite →
        ∃ H : ℕ, ∀ n : ℕ, H ≤ n →
          n ∈ subsetSums a {i : ℕ | a i ∉ B})
    (hinfinite :
      ∀ B : Set ℕ, B.Infinite → B ⊆ Set.range a →
        ¬ ∃ H : ℕ, ∀ n : ℕ, H ≤ n →
          n ∈ subsetSums a {i : ℕ | a i ∉ B})
    (hexists : ∃ L : ℝ, 1 < L ∧ Tendsto (quotient a) atTop (nhds L)) :
    Tendsto (quotient a) atTop (nhds Real.goldenRatio)
```

Here is how this theorem corresponds to the natural-language statement.

| Lean theorem component | Natural-language meaning |
| --- | --- |
| `{a : ℕ → ℕ}` with `hmono : StrictMono a` and `hpos : ∀ n, 0 < a n` | \(A=\{a_0<a_1<a_2<\cdots\}\) is an increasing sequence of positive integers. |
| `hratioGap : ∃ ε : ℝ, 0 < ε ∧ ∀ n, 1 + ε ≤ quotient a n` | There is some \(\epsilon>0\) such that \(a_{n+1}/a_n\ge 1+\epsilon\) for all \(n\). |
| `hfinite` | Deleting any finite set \(B\) of sequence values leaves a complete sequence. |
| `hinfinite` | Deleting any infinite set \(B\) of actual sequence values leaves a non-complete sequence. |
| `hexists : ∃ L : ℝ, 1 < L ∧ Tendsto (quotient a) atTop (nhds L)` | This is the limit-exists interpretation: the quotient sequence has a limit \(L>1\). |
| Conclusion `Tendsto (quotient a) atTop (nhds Real.goldenRatio)` | The quotient sequence tends to the golden ratio. |

## Deleting Values and Deleting Indices

The theorem displayed above is the value-deletion version.  The Lean files also
include the index-deletion version:

```lean
theorem main_expanded
    {a : ℕ → ℕ}
    (hmono : StrictMono a)
    (hpos : ∀ n : ℕ, 0 < a n)
    (hratioGap :
      ∃ ε : ℝ, 0 < ε ∧
        ∀ n : ℕ, 1 + ε ≤ quotient a n)
    (hfinite :
      ∀ D : Set ℕ, D.Finite →
        ∃ H : ℕ, ∀ n : ℕ, H ≤ n →
          n ∈ subsetSums a Dᶜ)
    (hinfinite :
      ∀ D : Set ℕ, D.Infinite →
        ¬ ∃ H : ℕ, ∀ n : ℕ, H ≤ n →
          n ∈ subsetSums a Dᶜ)
    (hexists : ∃ L : ℝ, 1 < L ∧ Tendsto (quotient a) atTop (nhds L)) :
    Tendsto (quotient a) atTop (nhds Real.goldenRatio)
```

Here the deleted set is an index set:

```lean
D : Set ℕ
```

The remaining terms are indexed by `Dᶜ`.  By contrast, the value-deletion
theorem uses sets `B : Set ℕ` of deleted values, and the remaining terms are
represented by their indices:

```lean
{i : ℕ | a i ∉ B}
```

For the infinite value-deletion hypothesis, the side condition

\[
B \subseteq \operatorname{range}(a)
\]

means that \(B\) consists only of actual sequence values.

The original problem is phrased as deleting elements of the value set \(A\), not
indices.  Since the theorem assumes `StrictMono a`, the map from indices to
values is injective, so deleting indices and deleting the corresponding values
are equivalent.  This equivalence is also formalized in Lean:

```lean
Erdos346.finiteDeletionComplete_iff_valueFiniteDeletionComplete
Erdos346.infiniteDeletionIncomplete_iff_valueInfiniteDeletionIncomplete
```

## Web Verification by Lean4Web

You can check the proof in a web browser using Lean4Web:

**[open the Lean4Web check](https://live.lean-lang.org/#url=https%3A%2F%2Fraw.githubusercontent.com%2FKitaKen1%2Ferdos346-ratio-limit-lean%2Fmain%2Flean4web%2FLimitExistsVariantLean4Web.lean)**.

The Lean4Web file includes `#check` commands for the public theorem statements
and `#print axioms` commands for their axiom dependencies.

Expected `#print axioms` report:

```text
'Erdos346.main_expanded' depends on axioms:
[propext, Classical.choice, Quot.sound]
'Erdos346.main_valueDeletion_expanded' depends on axioms:
[propext, Classical.choice, Quot.sound]
```

These are standard Lean/mathlib axioms.  There are no custom axioms and no
`sorryAx`.

## Local Verification

From the repository root:

```bash
lake exe cache get
lake build
```

If a fresh checkout does not get the aggregate `Mathlib.olean` from the cache,
run:

```bash
lake build Mathlib
lake build
```

To check only the local main file:

```bash
lake env lean 346lean/LimitExistsVariant.lean
```

To check the Lean4Web single-file version locally:

```bash
lake env lean lean4web/LimitExistsVariantLean4Web.lean
```

Quick audit:

```bash
rg -n '^\s*axiom\b|\bsorry\b|\badmit\b|unsafe' 346lean 346lean.lean lean4web --glob '*.lean'
```

Expected result: no matches.

## References

- [Reference 1] T. F. Bloom, Erdős Problem #346, Erdős Problems,
  <https://www.erdosproblems.com/346>, accessed 2026-06-21.
- [Reference 2] Liam Price, comment on Erdős Problems discussion thread for
  Problem #346, 23:31 on 19 June 2026,
  <https://www.erdosproblems.com/forum/thread/346>, accessed 2026-06-21.
- [Reference 3] Dogmachine, comment on Erdős Problems discussion thread for
  Problem #346, 23:52 on 19 June 2026,
  <https://www.erdosproblems.com/forum/thread/346>, accessed 2026-06-21.
- [Reference 4] P. Erdős and R. L. Graham, *Old and New Problems and Results in
  Combinatorial Number Theory*, Monographie No. 28 de L'Enseignement
  Mathématique, 1980.  PDF:
  <https://www.math.ucsd.edu/~ronspubs/80_11_number_theory.pdf>.
- [Reference 5] R. L. Graham, "A Property of Fibonacci Numbers", *The Fibonacci
  Quarterly* 2 (1964), 1-10.  PDF:
  <https://plouffe.fr/Fibonacci%20Quartely/pdf/02505graham.pdf>.

## AI Usage Disclosure

The Lean formalization and this writeup were prepared with assistance from
Codex and ChatGPT.  The final mathematical claims and public presentation remain
the author's responsibility.
