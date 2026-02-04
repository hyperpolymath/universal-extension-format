# Manifest Generation Pipeline Architecture

## Overview

Use **A2ML + K9-SVC** to create a single source-of-truth that generates multiple manifest variants for different platforms/versions.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│ Source of Truth: fireflag-manifest.k9 (or .a2ml)           │
│                                                             │
│  • Common fields (name, version, permissions)              │
│  • Platform-specific overrides (desktop/android)           │
│  • Validation contracts (Nickel)                           │
│  • Build logic (generation rules)                          │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ Compiler Pipeline (Nickel + A2ML)                          │
│                                                             │
│  1. Parse source (K9-SVC or A2ML)                          │
│  2. Validate contracts:                                    │
│     - Required fields present                              │
│     - Version constraints satisfied                        │
│     - Permission dependencies met                          │
│  3. Generate platform variants                             │
└─────────────────────────────────────────────────────────────┘
                              ↓
        ┌─────────────────────┴─────────────────────┐
        ↓                     ↓                     ↓
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ Unified      │    │ Desktop-Only │    │ Android      │
│ manifest.json│    │ manifest.json│    │ manifest.json│
│              │    │              │    │              │
│ FF 142+      │    │ FF 112+      │    │ FF 142+      │
│ Desktop+And. │    │ Desktop only │    │ Android opt. │
└──────────────┘    └──────────────┘    └──────────────┘
        ↓                     ↓                     ↓
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ web-ext      │    │ web-ext      │    │ web-ext      │
│ build        │    │ build        │    │ build        │
└──────────────┘    └──────────────┘    └──────────────┘
        ↓                     ↓                     ↓
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ fireflag-    │    │ fireflag-    │    │ fireflag-    │
│ unified.zip  │    │ desktop.zip  │    │ android.zip  │
└──────────────┘    └──────────────┘    └──────────────┘
```

## Benefits

### 1. DRY (Don't Repeat Yourself)
- Single source for all manifest data
- Platform overrides only specify differences
- Reduce copy-paste errors

### 2. Type Safety (Nickel)
```nickel
# Compile-time validation
let validate_version = fun version =>
  std.string.is_match "^[0-9]+\\.[0-9]+\\.[0-9]+$" version

let validate_permissions = fun perms =>
  std.array.all (fun p =>
    p | [| "storage", "tabs", "notifications", ... |]
  ) perms
```

### 3. Attestation (A2ML)
```a2ml
@attestation:
generated_by: a2ml-compiler v0.1.0
source_hash: sha256:abc123...
timestamp: 2026-02-04T15:58:00Z
signature: ed25519:def456...
@end
```

### 4. Automation (Just + K9)
```bash
# One command generates all variants
just release

# Output:
# ✓ Generated 3 manifests
# ✓ Validated all contracts
# ✓ Built 3 platform variants
# ✓ Checksums computed
# ✓ All variants signed
```

## Implementation Roadmap

### Phase 1: K9-SVC Prototype (Nickel)
- [x] Create fireflag-manifest.k9 with platform variants
- [ ] Add Nickel validation contracts
- [ ] Integrate into justfile
- [ ] Test generation pipeline

### Phase 2: A2ML Integration
- [ ] Create fireflag-manifest.a2ml
- [ ] Implement A2ML compiler for manifest generation
- [ ] Add attestation/provenance
- [ ] Document syntax

### Phase 3: Advanced Features
- [ ] Idris2 proofs for manifest correctness
- [ ] K9-sign integration for cryptographic signing
- [ ] CI/CD pipeline integration
- [ ] Multi-browser support (Chrome, Safari, Edge)

## Example: Platform Variants

### Unified (manifest.json)
```json
{
  "manifest_version": 3,
  "name": "FireFlag",
  "version": "0.1.0",
  "browser_specific_settings": {
    "gecko": {
      "strict_min_version": "142.0"
    }
  }
}
```

### Desktop-Only (manifest-desktop.json)
```json
{
  "manifest_version": 3,
  "name": "FireFlag",
  "version": "0.1.0",
  "browser_specific_settings": {
    "gecko": {
      "strict_min_version": "112.0"
    }
  }
}
```

### Android-Optimized (manifest-android.json)
```json
{
  "manifest_version": 3,
  "name": "FireFlag",
  "version": "0.1.0",
  "description": "Manage Firefox flags (optimized for Android)",
  "browser_specific_settings": {
    "gecko": {
      "id": "fireflag-android@hyperpolymath.org",
      "strict_min_version": "142.0"
    }
  }
}
```

## Integration with Existing Tools

### A2ML (Attested Markup)
- **Role**: Source format + attestation
- **Benefits**:
  - Progressive strictness (lax → checked → attested)
  - Opaque payloads preserved byte-for-byte
  - Renderer portability

### K9-SVC (Self-Validating Components)
- **Role**: Validation + deployment automation
- **Benefits**:
  - Nickel contracts for type safety
  - Security levels (Kennel/Yard/Hunt)
  - Cryptographic signing

### Nickel (Configuration Language)
- **Role**: Type-safe configuration + validation
- **Benefits**:
  - Compile-time type checking
  - Contract system for constraints
  - JSON-compatible output

## Why This Approach?

### Problem: Current State
```bash
# Manual process (error-prone):
1. Edit manifest.json for desktop
2. Copy-paste to manifest-android.json
3. Change min_version and extension_id
4. Hope you didn't miss anything
5. Manually validate both
6. Build both separately
```

### Solution: Automated Pipeline
```bash
# One command:
just gen-manifests

# Generates all variants with:
# ✓ Type safety (Nickel validation)
# ✓ Attestation (A2ML provenance)
# ✓ Automation (Just orchestration)
# ✓ Signing (K9-sign)
```

## Files to Create

1. **fireflag-manifest.k9** - Nickel source (immediate)
2. **fireflag-manifest.a2ml** - A2ML source (future)
3. **justfile additions** - Build recipes
4. **Idris2 proofs** - Manifest correctness (advanced)

## Next Steps

Would you like me to:
1. Create the working K9-SVC manifest for fireflag?
2. Add it to your justfile?
3. Test the generation pipeline?
4. Create the A2ML version?
