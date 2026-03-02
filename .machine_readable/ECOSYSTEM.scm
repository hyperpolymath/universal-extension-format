;; SPDX-License-Identifier: PMPL-1.0-or-later
(ecosystem (metadata (version "0.1.0") (last-updated "2026-03-02"))
  (project (name "universal-extension-format") (purpose "One abstract extension definition compiled to all platforms") (role cross-platform-compiler)
    (related-projects
      (project (name "hybrid-automation-router") (relationship sibling-standard) (notes "Same compile-to-many pattern for Ansible/Salt/Terraform"))
      (project (name "http-capability-gateway") (relationship sibling-standard) (notes "Same pattern for HTTP policies to Nginx/Apache/Envoy"))
      (project (name "protocol-squisher") (relationship sibling-standard) (notes "Same pattern for serialization format adapters"))
      (project (name "echidna") (relationship upstream-dependency) (notes "Property testing framework validates UXF transformations"))
      (project (name "proven") (relationship upstream-dependency) (notes "Idris2 formal proofs for transformation correctness")))))
