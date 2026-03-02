;; SPDX-License-Identifier: PMPL-1.0-or-later
(meta (metadata (version "0.1.0") (last-updated "2026-03-02"))
  (project-info (type standalone) (languages (idris2 zig rescript nickel)) (license "PMPL-1.0-or-later")
    (architecture-decisions
      (adr (id 1) (status accepted) (title "Compile-to-many pattern for cross-platform extensions")
        (rationale "Abstract IR allows one source to generate native packages for every platform, validated by ECHIDNA property tests")))))
