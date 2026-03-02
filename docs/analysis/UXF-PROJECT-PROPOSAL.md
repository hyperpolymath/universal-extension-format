<!-- SPDX-License-Identifier: PMPL-1.0-or-later -->
# Universal Extension Format (UXF) - Project Proposal

## Vision

**One source → All platforms**

A formally-verified, platform-agnostic extension format that compiles to:
- Browser extensions (Firefox, Chrome, Safari, Edge)
- IDE plugins (VSCode, Obsidian, Zed)
- CMS plugins (WordPress, Drupal)
- Scholarly tools (Zotero, JabRef)
- Desktop apps (Electron, Tauri)

## Why This Doesn't Exist

Existing tools (Plasmo, WXT, Extension.js) only solve **browser cross-compilation**.

UXF goes further:
1. **Platform-agnostic abstractions** (not just browser APIs)
2. **Formal verification** (Idris2 proofs of correctness)
3. **Attestation** (A2ML provenance tracking)
4. **Self-validation** (K9-SVC contracts)

## Repository Structure

```
universal-extension-format/
├── spec/
│   ├── UXF-SPEC.adoc              # Format specification
│   ├── ABSTRACT-CAPABILITIES.adoc  # Platform-agnostic APIs
│   └── PLATFORM-ADAPTERS.adoc      # Target mappings
│
├── compiler/
│   ├── src/
│   │   ├── parser/                # A2ML/K9 parser
│   │   ├── validator/             # Nickel contracts
│   │   ├── adapters/              # Platform-specific generators
│   │   │   ├── firefox.ncl
│   │   │   ├── chrome.ncl
│   │   │   ├── wordpress.php.ncl
│   │   │   ├── vscode.ts.ncl
│   │   │   └── zotero.ncl
│   │   └── codegen/               # Code generation
│   └── tests/
│       └── fixtures/              # Test extensions
│
├── stdlib/
│   ├── capabilities/              # Abstract capability definitions
│   │   ├── storage.uxf
│   │   ├── ui.uxf
│   │   ├── permissions.uxf
│   │   └── lifecycle.uxf
│   └── adapters/                  # Runtime adapters
│       ├── browser-polyfill.js
│       ├── wordpress-bridge.php
│       └── vscode-shim.ts
│
├── examples/
│   ├── hello-world/
│   │   ├── extension.uxf          # Source
│   │   └── dist/                  # Generated outputs
│   │       ├── firefox/
│   │       ├── chrome/
│   │       ├── wordpress/
│   │       └── vscode/
│   ├── fireflag/                  # Port of FireFlag
│   └── academic-tools/            # Zotero example
│
├── proofs/
│   ├── Correctness.idr            # Manifest generation correctness
│   ├── SafetyLevels.idr           # Safety property preservation
│   └── PlatformCompat.idr         # Platform compatibility proofs
│
├── cli/
│   ├── src/uxf.ml                 # OCaml CLI tool
│   └── bin/uxf                    # Binary
│
├── docs/
│   ├── QUICKSTART.adoc
│   ├── PLATFORM-SUPPORT.adoc
│   ├── MIGRATION-GUIDE.adoc
│   └── API-REFERENCE.adoc
│
└── .machine_readable/
    ├── STATE.scm
    ├── ECOSYSTEM.scm
    └── META.scm
```

## UXF File Format

```a2ml
# extension.uxf
# SPDX-License-Identifier: PMPL-1.0-or-later

@metadata:
name: MyExtension
version: 1.0.0
author: You <you@example.com>
license: PMPL-1.0-or-later
@end

@capabilities:
## What the extension does (abstract)
storage:
  - type: local
  - schema:
      settings: {
        enabled: boolean,
        theme: string,
      }

ui:
  - popup:
      title: "Quick Settings"
      components: [toggle, dropdown]
  - sidebar:
      title: "Detailed View"
      components: [list, chart]
  - options:
      title: "Configuration"
      components: [form]

permissions:
  - storage: local
  - ui: popup, sidebar, options
@end

@lifecycle:
## Platform-agnostic lifecycle events
on_install:
  - initialize_storage
  - show_welcome_message

on_update:
  - migrate_data
  - show_changelog

on_uninstall:
  - cleanup_storage
@end

@targets:
## Platform-specific configuration
firefox:
  min_version: 142.0
  manifest_version: 3

chrome:
  min_version: 114.0
  manifest_version: 3

wordpress:
  php_version: 8.1
  wp_version: 6.0

vscode:
  engine_version: 1.75.0
@end
```

## Compiler Pipeline

```bash
# Compile to single target
uxf compile extension.uxf --target firefox

# Compile to all targets
uxf compile extension.uxf --all

# Validate without compiling
uxf validate extension.uxf

# Show platform support matrix
uxf targets extension.uxf

# Generate from template
uxf init my-extension --template basic
```

## Technology Stack

### Core Components
- **Format**: A2ML (attested markup) + K9-SVC (self-validating)
- **Validation**: Nickel (contracts) + Idris2 (proofs)
- **Generation**: ReScript (compiler) + Deno (runtime)
- **CLI**: OCaml or Rust

### Build Pipeline
- **Parser**: A2ML → AST
- **Validator**: Nickel contracts + Idris2 proofs
- **Adapter**: AST → Platform-specific IR
- **Codegen**: IR → Target code
- **Package**: Code → Distributable (XPI, CRX, ZIP, VSIX)

## Platform Support Matrix

| Platform | Status | Notes |
|----------|--------|-------|
| Firefox | ✅ Tier 1 | Full WebExtensions API |
| Chrome | ✅ Tier 1 | Full WebExtensions API |
| Safari | ⚠️ Tier 2 | Limited API coverage |
| Edge | ✅ Tier 1 | Chromium-based |
| Zotero | ⚠️ Tier 2 | Firefox-based + custom APIs |
| WordPress | ⚠️ Tier 2 | PHP paradigm shift |
| VSCode | ⚠️ Tier 2 | TypeScript + different API model |
| Obsidian | 🔄 Tier 3 | Planned |
| Electron | 🔄 Tier 3 | Standalone app generation |

## Proof-of-Concept Roadmap

### Phase 1: Browser-Only (3 months)
- [ ] UXF spec v0.1
- [ ] Firefox + Chrome adapters
- [ ] Manifest V2/V3 generation
- [ ] CLI tool (compile, validate)
- [ ] 3 example extensions

### Phase 2: IDE Plugins (3 months)
- [ ] VSCode adapter
- [ ] Obsidian adapter
- [ ] TypeScript code generation
- [ ] 2 example plugins

### Phase 3: CMS Plugins (3 months)
- [ ] WordPress adapter
- [ ] PHP code generation
- [ ] Hooks/filters mapping
- [ ] 1 example plugin

### Phase 4: Scholarly Tools (3 months)
- [ ] Zotero adapter
- [ ] RDF/citation handling
- [ ] 1 example translator

### Phase 5: Formal Verification (6 months)
- [ ] Idris2 proofs of correctness
- [ ] Safety property preservation
- [ ] Platform compatibility proofs

## Success Metrics

1. **Adoption**: 10+ real-world extensions using UXF
2. **Platform coverage**: 5+ platforms supported
3. **Code reduction**: 80% less platform-specific code
4. **Maintenance**: 1 source update → all platforms
5. **Verification**: 100% formally verified core

## Competitive Advantages

| Feature | UXF | Plasmo | WXT | Extension.js |
|---------|-----|--------|-----|--------------|
| Browser extensions | ✅ | ✅ | ✅ | ✅ |
| IDE plugins | ✅ | ❌ | ❌ | ❌ |
| CMS plugins | ✅ | ❌ | ❌ | ❌ |
| Formal verification | ✅ | ❌ | ❌ | ❌ |
| Attestation | ✅ | ❌ | ❌ | ❌ |
| Self-validation | ✅ | ❌ | ❌ | ❌ |

## Example: FireFlag Migration

### Before (manual maintenance)
```
fireflag/
├── firefox/manifest.json           # Manual
├── chrome/manifest.json            # Manual (copy-paste)
└── zotero/install.rdf              # Manual (different format)
```

### After (UXF)
```
fireflag/
├── extension.uxf                   # Single source
└── dist/                           # Generated
    ├── firefox/
    ├── chrome/
    ├── safari/
    ├── zotero/
    ├── wordpress/
    └── vscode/
```

## Risks & Mitigations

### Risk 1: Platform API Drift
**Problem**: Platforms change APIs frequently

**Mitigation**:
- Abstract capabilities, not APIs
- Version adapters separately
- Automated platform API tracking

### Risk 2: Paradigm Mismatches
**Problem**: PHP vs JavaScript vs TypeScript

**Mitigation**:
- Focus on shared abstractions (storage, UI, lifecycle)
- Platform-specific escape hatches
- Gradual adoption (browsers first, then expand)

### Risk 3: Adoption Barriers
**Problem**: Developers already invested in platform-specific code

**Mitigation**:
- Migration tools (Firefox → UXF, Chrome → UXF)
- Incremental adoption (start with manifest, expand to code)
- Strong ROI demonstration (one source → 5+ platforms)

## Relation to Hyperpolymath Ecosystem

- **A2ML**: Format for UXF source files
- **K9-SVC**: Self-validation contracts
- **Nickel**: Type-safe configuration
- **Idris2**: Formal proofs
- **ReScript**: Compiler implementation
- **Deno**: Runtime for tooling

## Call to Action

This could be a **landmark project** for hyperpolymath:
1. Novel solution (no existing competitor at this scale)
2. Demonstrates formal methods in practice
3. Solves real-world pain (multi-platform development)
4. Showcase for A2ML + K9-SVC + Nickel + Idris2 integration

## Next Steps

Want me to:
1. **Create the RSR template repo** for `universal-extension-format`?
2. **Prototype Phase 1** (Firefox + Chrome from one source)?
3. **Write the UXF spec** (formal grammar + examples)?
4. **Build proof-of-concept** (FireFlag as first UXF project)?
