;; SPDX-License-Identifier: PMPL-1.0-or-later
;; ECOSYSTEM.scm - Ecosystem relationships for universal-extension-format
;; Media-Type: application/vnd.ecosystem+scm

(ecosystem
  (version "1.0.0")
  (name "universal-extension-format")
  (type "tool")
  (purpose "Cross-platform extension compiler: one abstract definition generates native packages for all platforms")

  (position-in-ecosystem
    "Implements the compile-to-many pattern for browser extensions and IDE plugins. "
    "Part of the hyperpolymath ecosystem, sharing infrastructure with HAR, HTTP-Gateway, and protocol-squisher.")

  (related-projects
    (sibling-standard "hybrid-automation-router" "Same compile-to-many pattern for Ansible/Salt/Terraform")
    (sibling-standard "http-capability-gateway" "Same pattern for HTTP policies to Nginx/Apache/Envoy")
    (sibling-standard "protocol-squisher" "Same pattern for serialization format adapters")
    (dependency "echidna" "Property testing framework validates UXF transformations")
    (dependency "proven" "Idris2 formal proofs for transformation correctness"))

  (what-this-is
    "A cross-platform extension compiler that takes one abstract extension definition "
    "and generates native packages for Firefox, Chrome, Safari, WordPress, VSCode, Zotero, and more.")

  (what-this-is-not
    "This is not a browser extension itself. It is a compiler/code generator "
    "that produces browser extensions and platform plugins from a single source."))
