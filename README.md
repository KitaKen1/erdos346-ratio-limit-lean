# Erdős 346 Ratio-Limit Lean4Web Proof

Single-file Lean 4 Web formalization of the ratio-limit interpretation of Erdős Problem 346.

## Result

This repository contains one Lean file:

```text
LimitExistsVariantLean4Web.lean
```

The main theorem is:

```lean
Erdos346.main
```

Informally, it proves:

If the deletion hypotheses of Erdős Problem 346 hold, and if the quotient sequence `a_{n+1}/a_n` has a limit `L > 1`, then the quotient sequence tends to the golden ratio `φ`.

## How To Check

Open Lean 4 Web with Mathlib available:

```text
https://live.lean-lang.org/
```

Paste the full contents of:

```text
LimitExistsVariantLean4Web.lean
```

Expected axiom report:

```text
'Erdos346.main' depends on axioms: [propext, Classical.choice, Quot.sound]
```

The file contains no `sorry`, `admit`, or problem-specific `axiom`.

## Interpretation

This proves the limit-exists interpretation of the problem.

It is complementary to the non-convergent construction for the literal no-limit reading.

## AI Usage

The Lean formalization and this README were prepared with assistance from Codex and ChatGPT. The final mathematical claims and public presentation remain the author's responsibility.
