import Lake
open Lake DSL

package "346lean" where
  version := v!"0.1.0"
  keywords := #["math"]
  leanOptions := #[
    ⟨`pp.unicode.fun, true⟩ -- pretty-prints `fun a ↦ b`
  ]

require "leanprover-community" / "mathlib" @ git "v4.31.0"

@[default_target]
lean_lib «346lean» where
  -- add any library configuration options here
