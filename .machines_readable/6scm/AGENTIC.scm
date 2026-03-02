;; SPDX-License-Identifier: PMPL-1.0-or-later
;; AGENTIC.scm - AI agent interaction patterns for universal-extension-format

(define agentic-config
  `((version . "1.0.0")
    (claude-code
      ((model . "claude-opus-4-6")
       (tools . ("read" "edit" "bash" "grep" "glob"))
       (permissions . "read-all")))
    (patterns
      ((code-review . "thorough")
       (refactoring . "conservative")
       (testing . "comprehensive")))
    (constraints
      ((languages . (idris2 zig rescript nickel))
       (banned . ("typescript" "go" "python" "makefile"))))))
