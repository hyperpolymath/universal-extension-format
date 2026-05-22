; SPDX-License-Identifier: MPL-2.0
;; guix.scm — GNU Guix package definition for universal-extension-format
;; Usage: guix shell -f guix.scm

(use-modules (guix packages)
             (guix build-system gnu)
             (guix licenses))

(package
  (name "universal-extension-format")
  (version "0.1.0")
  (source #f)
  (build-system gnu-build-system)
  (synopsis "universal-extension-format")
  (description "universal-extension-format — part of the hyperpolymath ecosystem.")
  (home-page "https://github.com/hyperpolymath/universal-extension-format")
  (license ((@@ (guix licenses) license) "MPL-2.0"
             "https://github.com/hyperpolymath/palimpsest-license")))
