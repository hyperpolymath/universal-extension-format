<!-- SPDX-License-Identifier: PMPL-1.0-or-later -->
<!-- TOPOLOGY.md — Project architecture map and completion dashboard -->
<!-- Last updated: 2026-02-19 -->

# Universal Extension Format (UXF) — Project Topology

## System Architecture

```
                        ┌─────────────────────────────────────────┐
                        │              EXTENSION DEVELOPER        │
                        │        (Declarative .uxf Source)        │
                        └───────────────────┬─────────────────────┘
                                            │ Compile
                                            ▼
                        ┌─────────────────────────────────────────┐
                        │           UXF PIPELINE CORE             │
                        │  ┌───────────┐  ┌───────────────────┐  │
                        │  │ A2ML/Nickel│  │  Abstract IR      │  │
                        │  │ (Validator)│──► (Capabilities)   │  │
                        │  └─────┬─────┘  └────────┬──────────┘  │
                        │        │                 │              │
                        │  ┌─────▼─────┐  ┌────────▼──────────┐  │
                        │  │ Idris2    │  │  ECHIDNA          │  │
                        │  │ (Proofs)  │  │  (Prop Tests)     │  │
                        │  └─────┬─────┘  └────────┬──────────┘  │
                        └────────│─────────────────│──────────────┘
                                 │                 │
                                 ▼                 ▼
                        ┌─────────────────────────────────────────┐
                        │           PLATFORM ADAPTERS             │
                        │  ┌───────────┐  ┌───────────┐  ┌───────┐│
                        │  │ Firefox   │  │ Chrome    │  │ VSCode││
                        │  └───────────┘  └───────────┘  └───────┘│
                        │  ┌───────────┐  ┌───────────┐  ┌───────┐│
                        │  │ WordPress │  │ Zotero    │  │ Safari││
                        │  └───────────┘  └───────────┘  └───────┘│
                        └───────────────────┬─────────────────────┘
                                            │
                                            ▼
                        ┌─────────────────────────────────────────┐
                        │          NATIVE PACKAGES                │
                        │      (.xpi, .crx, .zip, .vsix)          │
                        └─────────────────────────────────────────┘

                        ┌─────────────────────────────────────────┐
                        │          REPO INFRASTRUCTURE            │
                        │  Justfile Automation  .machine_readable/  │
                        │  ECHIDNA / Idris2     0-AI-MANIFEST.a2ml  │
                        └─────────────────────────────────────────┘
```

## Completion Dashboard

```
COMPONENT                          STATUS              NOTES
─────────────────────────────────  ──────────────────  ─────────────────────────────────
CORE PIPELINE
  Abstract IR (Capabilities)        ██████████ 100%    Capability tree stable
  A2ML / Nickel Validation          ████████░░  80%    Type-safe parsing active
  ECHIDNA Property Tests            ██████████ 100%    7/8 critical tests passed
  Idris2 Formal Proofs              ██████░░░░  60%    Transformation proofs refining

PLATFORM ADAPTERS
  Firefox Adapter (V2/V3)           ████░░░░░░  40%    Initial manifest gen active
  Chrome Adapter (V3)               ████░░░░░░  40%    MV3 stubs verified
  Other Adapters (WP/VSCode)        ░░░░░░░░░░   0%    Planned for Phase 2/3

REPO INFRASTRUCTURE
  Justfile Automation               ██████████ 100%    Standard tasks active
  .machine_readable/                ██████████ 100%    STATE tracking active
  Documentation (Analysis)          ██████████ 100%    Comprehensive spec index

─────────────────────────────────────────────────────────────────────────────
OVERALL:                            ████░░░░░░  ~40%   Concept validated, Core active
```

## Key Dependencies

```
UXF Source ──────► A2ML Parser ──────► Abstract IR ──────► Platform Code
     │                 │                   │                    │
     ▼                 ▼                   ▼                    ▼
Idris2 Proof ───► ECHIDNA Test ──────► Adapter Logic ────► Native .xpi
```

## Update Protocol

This file is maintained by both humans and AI agents. When updating:

1. **After completing a component**: Change its bar and percentage
2. **After adding a component**: Add a new row in the appropriate section
3. **After architectural changes**: Update the ASCII diagram
4. **Date**: Update the `Last updated` comment at the top of this file

Progress bars use: `█` (filled) and `░` (empty), 10 characters wide.
Percentages: 0%, 10%, 20%, ... 100% (in 10% increments).
