<!-- SPDX-License-Identifier: MPL-2.0 -->
# The Unified Architecture Pattern
## You're Already Using It Across Multiple Projects!

## The Pattern

All three projects follow the **SAME architecture**:

```
┌──────────────────────────────────────────────────────────┐
│ Declarative Source (Platform-Agnostic)                  │
│ • UXF: extension.uxf                                     │
│ • HAR: Ansible YAML / Terraform HCL                      │
│ • HTTP-Gateway: policy.yaml (Verb Governance Spec)       │
└──────────────────────────────────────────────────────────┘
                          ↓
┌──────────────────────────────────────────────────────────┐
│ Parser + Validator                                       │
│ • UXF: A2ML parser + Nickel contracts                    │
│ • HAR: IaC parser (Ansible/Salt/Terraform)               │
│ • HTTP-Gateway: DSL validator                            │
└──────────────────────────────────────────────────────────┘
                          ↓
┌──────────────────────────────────────────────────────────┐
│ Abstract Intermediate Representation (IR)                │
│ • UXF: Abstract capabilities (storage, UI, permissions)  │
│ • HAR: Semantic graph (operations + dependencies)        │
│ • HTTP-Gateway: Enforcement rules (verb policies)        │
└──────────────────────────────────────────────────────────┘
                          ↓
┌──────────────────────────────────────────────────────────┐
│ Compiler / Router / Transformer                          │
│ • UXF: Platform adapters (Firefox/Chrome/WordPress)      │
│ • HAR: Routing engine (Ansible→Salt→Terraform)           │
│ • HTTP-Gateway: Enforcement compiler                     │
└──────────────────────────────────────────────────────────┘
                          ↓
┌──────────────────────────────────────────────────────────┐
│ Target-Specific Output                                   │
│ • UXF: XPI, CRX, WordPress ZIP, VSIX                     │
│ • HAR: Ansible playbook, Salt SLS, Terraform HCL         │
│ • HTTP-Gateway: Nginx rules, Apache config, iptables     │
└──────────────────────────────────────────────────────────┘
```

## Side-by-Side Comparison

| Component | UXF (Extensions) | HAR (Infrastructure) | HTTP-Gateway (Governance) |
|-----------|------------------|----------------------|---------------------------|
| **Domain** | Browser/IDE plugins | IaC automation | HTTP verb control |
| **Source** | extension.uxf | Ansible YAML | policy.yaml |
| **Parser** | A2ML + K9-SVC | Elixir parsers | YAML validator |
| **IR** | Abstract capabilities | Semantic graph | Enforcement rules |
| **Targets** | Firefox, Chrome, WordPress, VSCode | Ansible, Salt, Terraform, bash | Nginx, Apache, custom enforcement |
| **Output** | XPI, CRX, ZIP, VSIX | YAML, HCL, SLS | Config files, iptables rules |

## How They Could Share Infrastructure

### Shared Components

All three could use:

1. **A2ML** for declarative source format
2. **K9-SVC** for self-validation
3. **Nickel** for type-safe contracts
4. **Idris2** for formal proofs

### Example: HAR with A2ML + K9-SVC

**Current HAR:**
```yaml
# Ansible playbook
- name: Install nginx
  apt:
    name: nginx
    state: present
```

**Enhanced HAR (with A2ML):**
```a2ml
@infrastructure:webserver
version: 1.0.0
platform: linux

@operations:
install-package:
  - package: nginx
  - version: latest
  - manager: auto  # Abstract - HAR routes to apt/yum/pacman

start-service:
  - service: nginx
  - enable: true
  - depends: install-package
@end

@targets:
ansible:
  format: yaml
  module_style: declarative

salt:
  format: sls
  state_system: highstate

terraform:
  provider: aws
  resource_type: ec2_instance
@end

@attestation:
generated_by: HAR v2.0
source_hash: sha256:abc123...
signature: ed25519:def456...
@end
```

**Benefits:**
- **Type safety**: Nickel validates operations exist
- **Attestation**: A2ML tracks provenance
- **Self-validation**: K9-SVC ensures correctness

### Example: http-capability-gateway with A2ML + K9-SVC

**Current HTTP-Gateway:**
```yaml
# policy.yaml
service:
  name: ledger-api
verbs:
  GET: { exposure: public }
  POST: { exposure: authenticated }
  DELETE: { exposure: internal }
```

**Enhanced HTTP-Gateway (with A2ML):**
```a2ml
@service:ledger-api
version: 1
environment: production

@verb-policy:
## Declarative verb governance
GET:
  - exposure: public
  - rate_limit: 1000/min
  - cache: true

POST:
  - exposure: authenticated
  - rate_limit: 100/min
  - audit: true
  - requires: [csrf_token, valid_session]

DELETE:
  - exposure: internal
  - rate_limit: 10/min
  - audit: full
  - requires: [admin_role, mfa_verified]
  - stealth: 404  # Hide from untrusted
@end

@enforcement-targets:
## Generate rules for different backends
nginx:
  format: nginx.conf
  use_lua: true

apache:
  format: .htaccess
  use_mod_rewrite: true

envoy:
  format: yaml
  use_external_auth: true

iptables:
  format: rules
  use_conntrack: true
@end

@attestation:
policy_author: security-team@company.com
reviewed_by: cto@company.com
approved_date: 2026-02-04
signature: ed25519:xyz789...
@end
```

**Benefits:**
- **Multi-backend**: One policy → Nginx + Apache + Envoy + iptables
- **Attestation**: Know who approved the policy and when
- **Self-validation**: K9-SVC verifies policy before deployment

## The Universal Pattern: "Compile-to-Many"

### What You're Building

You have **THREE implementations** of the same pattern:

1. **UXF**: Extensions → Many platforms (browsers, IDEs, CMS)
2. **HAR**: Infrastructure → Many IaC tools (Ansible, Salt, Terraform)
3. **HTTP-Gateway**: Policies → Many enforcement backends (Nginx, Apache, Envoy)

### The Meta-Pattern

```
┌────────────────────────────────────────┐
│ Domain-Specific Source (A2ML + K9-SVC) │
│ • Declarative                          │
│ • Type-safe (Nickel)                   │
│ • Attested (A2ML)                      │
│ • Self-validating (K9-SVC)             │
└────────────────────────────────────────┘
              ↓
┌────────────────────────────────────────┐
│ Abstract Intermediate Representation   │
│ • Domain-agnostic operations           │
│ • Platform-independent semantics       │
│ • Dependency graph                     │
└────────────────────────────────────────┘
              ↓
┌────────────────────────────────────────┐
│ Platform Adapters (Pluggable)          │
│ • Target-specific transformations      │
│ • Code generation                      │
│ • Format conversion                    │
└────────────────────────────────────────┘
              ↓
┌────────────────────────────────────────┐
│ Multiple Target Outputs                │
│ • Each platform gets native format     │
│ • Provenance maintained                │
│ • Audit trail preserved                │
└────────────────────────────────────────┘
```

## Shared Tooling Opportunities

### 1. Common Compiler Infrastructure

```elixir
# Shared across UXF, HAR, HTTP-Gateway
defmodule Hyperpolymath.Compiler do
  def compile(source, target) do
    source
    |> parse_a2ml()        # Shared A2ML parser
    |> validate_nickel()   # Shared Nickel contracts
    |> verify_idris()      # Shared Idris2 proofs
    |> route_to_adapter(target)
    |> generate_code()
    |> attest_k9svc()      # Shared K9-SVC attestation
  end
end
```

### 2. Universal Build Pipeline (Just)

```bash
# Shared Justfile recipes
gen-all-targets SOURCE:
    @echo "Compiling {{SOURCE}} to all targets..."
    hyperpolymath compile {{SOURCE}} --all

validate SOURCE:
    @echo "Validating {{SOURCE}}..."
    nickel typecheck {{SOURCE}}
    a2ml validate {{SOURCE}}
    k9-sign verify {{SOURCE}}

attest SOURCE:
    @echo "Generating attestation for {{SOURCE}}..."
    k9-sign sign {{SOURCE}}
    a2ml attest {{SOURCE}}
```

### 3. Unified CLI

```bash
# One CLI for all "compile-to-many" tools
hyper compile extension.uxf --target firefox
hyper compile infrastructure.har --target salt
hyper compile policy.http --target nginx

# Or use domain-specific commands
uxf compile extension.uxf --all
har convert playbook.yml --to terraform
http-gateway enforce policy.yaml --backend envoy
```

## Integration Examples

### HAR + HTTP-Gateway Integration

**Use Case**: Deploy infrastructure with built-in HTTP governance

```a2ml
@infrastructure:api-server
@http-policy:embedded

## Infrastructure operations
operations:
  - install: nginx
  - configure: reverse-proxy
  - deploy: app-container

## HTTP governance (embedded)
http-policy:
  verbs:
    GET: public
    POST: authenticated
    DELETE: internal

@targets:
## HAR generates infrastructure
ansible:
  playbook: deploy.yml

## HTTP-Gateway generates governance
nginx:
  config: http-policy.conf
  integrate_with: ansible_deployment
@end
```

**Output**: One source generates BOTH:
- Ansible playbook (deploys server)
- Nginx config (enforces HTTP policy)

### HAR + UXF Integration

**Use Case**: Deploy browser extension management infrastructure

```a2ml
@infrastructure:extension-cdn
@extension:fireflag

## Infrastructure for extension distribution
infrastructure:
  - cdn: cloudflare
  - storage: s3
  - signing: mozilla-signing-service

## Extension to distribute
extension:
  name: fireflag
  targets: [firefox, chrome]

@output:
## HAR provisions infrastructure
terraform:
  cdn_config: cloudflare.tf
  s3_bucket: extension-cdn.tf

## UXF builds extensions
firefox:
  manifest: fireflag-firefox/manifest.json

chrome:
  manifest: fireflag-chrome/manifest.json
@end
```

## The Vision: Hyperpolymath Compiler Suite

```
hyperpolymath/
├── universal-extension-format/     # UXF compiler
├── hybrid-automation-router/       # HAR compiler
├── http-capability-gateway/        # HTTP-Gateway compiler
└── hyperpolymath-compiler/         # Shared infrastructure
    ├── parsers/
    │   ├── a2ml/                   # A2ML parser
    │   └── k9svc/                  # K9-SVC validator
    ├── validators/
    │   └── nickel/                 # Nickel contracts
    ├── proofs/
    │   └── idris2/                 # Formal verification
    ├── codegen/
    │   ├── adapters/               # Platform adapters
    │   └── templates/              # Code templates
    └── attestation/
        └── k9-sign/                # Signing + verification
```

## Next Steps

### Option 1: Enhance Existing Projects

Add A2ML + K9-SVC support to:
1. **HAR**: `infrastructure.a2ml` → Ansible/Salt/Terraform
2. **HTTP-Gateway**: `policy.a2ml` → Nginx/Apache/Envoy
3. Both get attestation + formal verification

### Option 2: Create Shared Foundation

Build `hyperpolymath-compiler` with:
- Shared A2ML parser
- Shared Nickel validator
- Shared K9-SVC attestation
- Shared Idris2 proof framework

Then UXF, HAR, and HTTP-Gateway become "domain adapters" on top of common infrastructure.

### Option 3: Meta-Compiler

Build a **meta-compiler** that generates compilers!

```a2ml
@compiler:new-domain-compiler
domain: container-orchestration
input_format: a2ml

@abstract-ir:
## Define abstract operations
operations:
  - deploy_container
  - scale_service
  - setup_ingress

@targets:
## Define output targets
kubernetes:
  format: yaml

docker-swarm:
  format: compose

nomad:
  format: hcl
@end
```

This generates a NEW compiler for container orchestration that follows the same pattern!

## Conclusion

You've independently discovered the **"Compile-to-Many"** pattern across three domains:
1. **UXF**: Browser extensions → Many platforms
2. **HAR**: Infrastructure code → Many IaC tools
3. **HTTP-Gateway**: HTTP policies → Many enforcement backends

**The opportunity**: Unify them with shared tooling (A2ML + K9-SVC + Nickel + Idris2) to create the **Hyperpolymath Compiler Suite** - a family of "compile-to-many" tools sharing common infrastructure.

This would be a **major architectural contribution** to the ecosystem!
