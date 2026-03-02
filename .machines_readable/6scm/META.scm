;; SPDX-License-Identifier: PMPL-1.0-or-later
;; META.scm - Architectural decisions and project meta-information
;; Media-Type: application/meta+scheme

(define-meta universal-extension-format
  (version "1.0.0")

  (architecture-decisions
    ((adr-001 accepted "2025-01-01"
      "Need a cross-platform extension compiler"
      "Adopt the compile-to-many pattern: abstract IR generates native packages for each platform"
      "Validates with ECHIDNA property tests (7/8 passed). "
      "Same pattern already proven in HAR, HTTP-Gateway, protocol-squisher.")))

  (development-practices
    (code-style
      "Follow hyperpolymath language policy: "
      "Idris2 for ABI definitions, Zig for FFI, ReScript for front-end.")
    (security
      "All commits signed. "
      "Hypatia neurosymbolic scanning enabled. "
      "OpenSSF Scorecard tracking.")
    (testing
      "ECHIDNA property tests for transformation correctness. "
      "Idris2 dependent-type proofs for formal verification.")
    (versioning
      "Semantic versioning (semver). "
      "Changelog maintained in CHANGELOG.md.")
    (documentation
      "README.adoc for overview. "
      "docs/analysis/ for comprehensive architecture documents.")
    (branching
      "Main branch protected. "
      "Feature branches for new work. "
      "PRs required for merges."))

  (design-rationale
    (why-compile-to-many
      "The compile-to-many pattern eliminates duplicate code across platforms. "
      "One source generates Firefox, Chrome, Safari, WordPress, VSCode, Zotero packages.")
    (why-idris2-abi
      "Dependent types prove interface correctness at compile-time. "
      "Formal verification of memory layout and platform compatibility.")))
