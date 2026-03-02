;; SPDX-License-Identifier: PMPL-1.0-or-later
;; PLAYBOOK.scm - Operational runbook for universal-extension-format

(define playbook
  `((version . "1.0.0")
    (procedures
      ((build . (("zig-ffi" . "cd ffi/zig && zig build")
                 ("test" . "cd ffi/zig && zig build test")))
       (rollback . ())
       (debug . ())))
    (alerts . ())
    (contacts . ())))
