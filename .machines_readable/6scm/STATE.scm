;; SPDX-License-Identifier: PMPL-1.0-or-later
;; STATE.scm - Project state tracking for universal-extension-format
;; Media-Type: application/vnd.state+scm

(define-state universal-extension-format
  (metadata
    (version "0.1.0")
    (schema-version "1.0.0")
    (created "2025-01-01")
    (updated "2026-03-02")
    (project "universal-extension-format")
    (repo "hyperpolymath/universal-extension-format"))

  (project-context
    (name "universal-extension-format")
    (tagline "One abstract extension definition compiled to all platforms")
    (tech-stack (idris2 zig rescript nickel)))

  (current-position
    (phase "concept")
    (overall-completion 40)
    (components
      ("abstract-ir" "a2ml-parser" "echidna-tests" "idris2-proofs"
       "firefox-adapter" "chrome-adapter" "abi-ffi-layer"))
    (working-features
      ("echidna-property-tests" "compile-to-many-pattern")))

  (route-to-mvp
    (milestones
      ((name "Phase 1: Browser-Only")
       (status "in-progress")
       (completion 40)
       (items
         ("A2ML parser for extension definitions" . todo)
         ("Abstract IR for browser capabilities" . done)
         ("Firefox adapter (Manifest V2/V3)" . in-progress)
         ("Chrome adapter (Manifest V3)" . in-progress)
         ("Nickel type-safe contracts" . todo)
         ("ECHIDNA property tests" . done)
         ("Idris2 formal proofs" . in-progress)))))

  (blockers-and-issues
    (critical ())
    (high ())
    (medium ())
    (low ()))

  (critical-next-actions
    (immediate
      "Complete Firefox adapter"
      "Complete Chrome adapter")
    (this-week
      "Implement A2ML parser for extension definitions"
      "Add Nickel type-safe contracts")
    (this-month
      "Proof-of-concept: Port existing extension (FireFlag)"
      "Complete Phase 1 browser adapters"))

  (session-history ()))

;; Helper functions
(define (get-completion-percentage state)
  (current-position 'overall-completion state))

(define (get-blockers state severity)
  (blockers-and-issues severity state))

(define (get-milestone state name)
  (find (lambda (m) (equal? (car m) name))
        (route-to-mvp 'milestones state)))
