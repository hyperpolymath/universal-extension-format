# Universal Extension Architecture
## From One Source to ALL Platforms

### The Vision

**One pre-manifest source** → **Multiple platform targets**

```
                    ┌─────────────────────────┐
                    │ Universal Pre-Manifest  │
                    │ (extension.uxf)         │
                    │                         │
                    │ • Abstract metadata     │
                    │ • Platform-agnostic API │
                    │ • Common functionality  │
                    └─────────────────────────┘
                               ↓
          ┌────────────────────┴────────────────────┐
          │   Compiler Pipeline (A2ML + K9-SVC)     │
          │                                         │
          │  1. Parse UXF source                   │
          │  2. Validate contracts                 │
          │  3. Generate platform adapters         │
          │  4. Emit target-specific code          │
          └─────────────────────────────────────────┘
                               ↓
    ┌──────────────────────────┴──────────────────────────┐
    │                                                      │
    ↓                    ↓                    ↓            ↓
┌─────────┐      ┌─────────┐      ┌─────────┐    ┌─────────┐
│ Firefox │      │ Chrome  │      │ Safari  │    │ Edge    │
│ XPI     │      │ CRX     │      │ App Ext │    │ CRX     │
│         │      │         │      │         │    │         │
│ MV2/MV3 │      │ MV3     │      │ webkit  │    │ MV3     │
└─────────┘      └─────────┘      └─────────┘    └─────────┘
    ↓                    ↓                    ↓            ↓
┌─────────┐      ┌─────────┐      ┌─────────┐    ┌─────────┐
│ Zotero  │      │VSCode   │      │WordPress│    │Obsidian │
│ Plugin  │      │Extension│      │ Plugin  │    │ Plugin  │
└─────────┘      └─────────┘      └─────────┘    └─────────┘
```

## Level 1: Manifest Versions (EASY)

### Problem
Firefox deprecated Manifest V2, moving to V3:
- Background pages → Service workers
- `permissions` → `permissions` + `host_permissions`
- Different CSP rules

### Solution: Dual-Target Generation

```nickel
# Universal format
let extension = {
  metadata = {
    name = "FireFlag",
    version = "0.1.0",
  },

  background = {
    type = "persistent",  # Abstract concept
    entry = "background.js",
  },

  permissions = {
    host = ["<all_urls>"],  # Abstract permission
    api = ["storage", "tabs"],
  },
}

# Generator adapts to target
let generate_mv2 = fun ext => {
  manifest_version = 2,
  background = { scripts = [ext.background.entry] },
  permissions = ext.permissions.api ++ ext.permissions.host,
}

let generate_mv3 = fun ext => {
  manifest_version = 3,
  background = { service_worker = ext.background.entry },
  permissions = ext.permissions.api,
  host_permissions = ext.permissions.host,
}
```

**Result:** One source → MV2 + MV3 manifests

## Level 2: Browser Targets (MEDIUM)

### Problem
Different browsers have incompatible APIs:

| Feature | Firefox | Chrome | Safari |
|---------|---------|--------|--------|
| Namespace | `browser.*` | `chrome.*` | `webkit.*` |
| Sidebar | ✅ `sidebar_action` | ❌ None | ❌ None |
| Promises | ✅ Native | ⚠️ Callbacks | ⚠️ Callbacks |
| Manifest key | `browser_specific_settings` | None | `safari_specific_settings` |

### Solution: Cross-Browser Adapter

```nickel
# Universal API surface
let extension = {
  ui = {
    sidebar = {
      enabled = true,
      panel = "sidebar.html",
    },
    popup = {
      enabled = true,
      html = "popup.html",
    },
  },

  storage = {
    type = "local",
    schema = { flags = "object" },
  },
}

# Firefox adapter
let firefox_manifest = {
  sidebar_action = {
    default_panel = ext.ui.sidebar.panel,
  },
  action = {
    default_popup = ext.ui.popup.html,
  },
}

# Chrome adapter (no sidebar)
let chrome_manifest = {
  # Sidebar → Side panel (Chrome 114+)
  side_panel = {
    default_path = ext.ui.sidebar.panel,
  },
  action = {
    default_popup = ext.ui.popup.html,
  },
}

# Safari adapter (different structure)
let safari_manifest = {
  # Safari has different UI model
  safari_web_extension = {
    toolbar_item = {
      action = ext.ui.popup.html,
    },
  },
}
```

**Result:** One source → Firefox XPI + Chrome CRX + Safari extension

## Level 3: Different Ecosystems (HARD)

### Problem
Completely different plugin architectures:

| Platform | Language | Format | Runtime |
|----------|----------|--------|---------|
| Firefox | JavaScript | XPI | Gecko |
| Chrome | JavaScript | CRX | Chromium |
| Zotero | JavaScript | XPI | Firefox-based |
| WordPress | PHP | ZIP | Apache/Nginx |
| VSCode | TypeScript | VSIX | Electron |
| Obsidian | TypeScript | ZIP | Electron |

### Solution: Abstract Functionality Model

Instead of describing HOW (implementation), describe WHAT (functionality):

```a2ml
# Universal Extension Format (UXF)
@extension:
name: FireFlag
type: configuration-manager
category: browser-tools

@capabilities:
## What the extension does (abstract)
- manage-settings:
    domain: browser-flags
    storage: local
    ui: [popup, sidebar, options]

- track-changes:
    history: true
    export: [json, csv, markdown]

- validate-safety:
    levels: [safe, moderate, advanced, experimental]
    warnings: true
@end

@ui-components:
## Abstract UI (not platform-specific)
- popup:
    type: quick-access
    features: [search, filter, toggle]

- sidebar:
    type: detailed-view
    features: [history, analytics, export]

- options:
    type: settings
    features: [permissions, preferences]
@end

@storage-schema:
## Data model (platform-agnostic)
flags:
  type: map<string, FlagState>

history:
  type: array<ChangeEvent>
  max_size: 1000
@end

@targets:
## Platform-specific generation rules
firefox:
  manifest_version: 3
  min_version: 142.0
  apis: [storage.local, browserSettings, privacy]

chrome:
  manifest_version: 3
  min_version: 114.0
  apis: [storage.local, sidePanel]

zotero:
  type: preference-handler
  schema: zotero-7.0
  inject: preferences-pane

wordpress:
  type: admin-plugin
  php_version: 8.1
  hooks: [admin_menu, admin_init]
@end
```

### Target Adapters

#### 1. Zotero Adapter

```javascript
// Generated Zotero plugin structure
// fireflag-zotero/
// ├── chrome.manifest
// ├── install.rdf
// └── content/
//     └── fireflag-preferences.xul

// install.rdf (generated)
{
  id: "fireflag@hyperpolymath.org",
  name: "FireFlag for Zotero",
  type: "extension",
  targetApplication: {
    id: "zotero@chnm.gmu.edu",
    minVersion: "7.0",
  }
}

// Adapter maps abstract UI to Zotero preferences
pane = {
  prefpane: {
    id: "fireflag-preferences",
    label: "FireFlag Settings",
    script: "fireflag.js",
  }
}
```

#### 2. WordPress Adapter

```php
<?php
/**
 * Plugin Name: FireFlag
 * Description: Manage browser configuration flags
 * Version: 0.1.0
 * Author: Jonathan D.A. Jewell
 */

// Generated from UXF abstract capabilities
class FireFlag_Plugin {
    // Abstract "manage-settings" → WordPress admin menu
    public function add_admin_menu() {
        add_menu_page(
            'FireFlag Settings',
            'FireFlag',
            'manage_options',
            'fireflag',
            [$this, 'render_admin_page']
        );
    }

    // Abstract "track-changes" → WordPress options table
    public function save_flag_change($flag, $value) {
        $history = get_option('fireflag_history', []);
        $history[] = [
            'flag' => $flag,
            'value' => $value,
            'timestamp' => time(),
        ];
        update_option('fireflag_history', $history);
    }

    // Abstract "validate-safety" → WordPress nonce + capability check
    public function validate_flag_change($flag, $value) {
        if (!current_user_can('manage_options')) {
            wp_die('Insufficient permissions');
        }

        $safety_level = $this->get_safety_level($flag);
        if ($safety_level === 'experimental') {
            // Show WordPress admin notice
            add_action('admin_notices', function() {
                echo '<div class="notice notice-warning">';
                echo '<p>Warning: This flag is experimental</p>';
                echo '</div>';
            });
        }
    }
}
```

#### 3. VSCode Adapter

```typescript
// Generated VSCode extension structure
// fireflag-vscode/
// ├── package.json (generated manifest)
// ├── extension.js (generated entry point)
// └── webview/ (UI components)

// package.json (adapted from UXF)
{
  "name": "fireflag",
  "displayName": "FireFlag",
  "version": "0.1.0",
  "engines": { "vscode": "^1.75.0" },

  // Abstract "manage-settings" → VSCode configuration
  "contributes": {
    "configuration": {
      "title": "FireFlag",
      "properties": {
        "fireflag.enableTracking": {
          "type": "boolean",
          "default": true,
          "description": "Track flag changes"
        }
      }
    },

    // Abstract "ui-components.sidebar" → VSCode webview
    "viewsContainers": {
      "activitybar": [{
        "id": "fireflag",
        "title": "FireFlag",
        "icon": "resources/icon.svg"
      }]
    },

    "views": {
      "fireflag": [{
        "id": "fireflag-flags",
        "name": "Browser Flags"
      }]
    }
  },

  // Abstract "track-changes" → VSCode storage API
  "activationEvents": ["onView:fireflag-flags"]
}

// extension.js (generated)
import * as vscode from 'vscode';

export function activate(context: vscode.ExtensionContext) {
    // Abstract storage → VSCode globalState
    const storage = context.globalState;

    // Abstract UI → VSCode webview
    const provider = new FireFlagViewProvider(context.extensionUri, storage);
    context.subscriptions.push(
        vscode.window.registerWebviewViewProvider(
            'fireflag-flags',
            provider
        )
    );
}
```

## Level 4: The Ultimate - Cross-Platform Plugins (VERY HARD)

### Can ONE source generate:
- ✅ Firefox extension (XPI)
- ✅ Chrome extension (CRX)
- ✅ Safari extension
- ✅ Zotero plugin
- ✅ WordPress plugin
- ✅ VSCode extension
- ✅ Obsidian plugin
- ✅ Electron app?

**YES, with the right abstractions!**

### The Key: Layered Architecture

```
┌─────────────────────────────────────────────┐
│ Layer 4: Platform-Specific Code            │
│ (Generated: manifest.json, PHP, TS, etc.)  │
└─────────────────────────────────────────────┘
                    ↑
┌─────────────────────────────────────────────┐
│ Layer 3: Platform Adapters                 │
│ (Maps abstract → platform-specific)        │
└─────────────────────────────────────────────┘
                    ↑
┌─────────────────────────────────────────────┐
│ Layer 2: Abstract Capabilities             │
│ (What the extension does, not how)        │
└─────────────────────────────────────────────┘
                    ↑
┌─────────────────────────────────────────────┐
│ Layer 1: Universal Extension Format (UXF) │
│ (A2ML + K9-SVC source)                     │
└─────────────────────────────────────────────┘
```

### Abstract Capabilities Map to Platform APIs

| Abstract Capability | Firefox | Chrome | WordPress | VSCode |
|---------------------|---------|--------|-----------|--------|
| **Storage** | `browser.storage.local` | `chrome.storage.local` | `update_option()` | `globalState` |
| **UI: Popup** | `action.popup` | `action.popup` | Admin page | Quick pick |
| **UI: Sidebar** | `sidebar_action` | `side_panel` | Widget | Webview panel |
| **UI: Settings** | `options_ui` | `options_page` | Settings API | Configuration |
| **Permissions** | `permissions` API | `chrome.permissions` | Capabilities | N/A (all granted) |
| **Background** | Service worker | Service worker | Admin init hook | `activate()` |

### Implementation Strategy

```nickel
# Universal Extension Format compiler
let compile_uxf = fun source target =>
  let abstract = parse_uxf(source) in
  let adapter = load_adapter(target) in
  let code = adapter.generate(abstract) in
  let manifest = adapter.generate_manifest(abstract) in
  package(code, manifest, target)

# Example: Compile to all targets
let targets = [
  "firefox-xpi",
  "chrome-crx",
  "safari-extension",
  "zotero-xpi",
  "wordpress-zip",
  "vscode-vsix",
  "obsidian-zip",
]

let build_all = fun uxf_source =>
  std.array.map (fun target => compile_uxf(uxf_source, target)) targets
```

## Real-World Example: FireFlag UXF

```a2ml
@extension:fireflag
version: 0.1.0
type: browser-configuration-manager

@abstract-capabilities:
manage-flags:
  - read: browser configuration flags
  - write: browser configuration values
  - validate: safety levels
  - rollback: previous values

track-usage:
  - record: flag changes
  - export: history reports
  - analyze: performance impact

provide-ui:
  - quick-access: popup (filter, search, toggle)
  - detailed-view: sidebar (analytics, history)
  - configuration: options page
  - developer: devtools integration
@end

@data-model:
Flag:
  key: string
  value: any
  safetyLevel: safe | moderate | advanced | experimental
  category: privacy | performance | network | ui

Change:
  flag: string
  beforeValue: any
  afterValue: any
  timestamp: datetime
  source: string
@end

@platform-mappings:
## Firefox
firefox:
  manage-flags → browserSettings API + privacy API
  track-usage → storage.local
  provide-ui.quick-access → browser_action.popup
  provide-ui.detailed-view → sidebar_action
  provide-ui.configuration → options_ui
  provide-ui.developer → devtools_page

## Chrome
chrome:
  manage-flags → chrome.browserSettings (limited)
  track-usage → chrome.storage.local
  provide-ui.quick-access → action.popup
  provide-ui.detailed-view → side_panel
  provide-ui.configuration → options_page
  provide-ui.developer → devtools_page

## WordPress (different paradigm!)
wordpress:
  manage-flags → Custom post type "ff_flags"
  track-usage → WordPress options table
  provide-ui.quick-access → Admin bar shortcut
  provide-ui.detailed-view → Admin menu page
  provide-ui.configuration → Settings API
  provide-ui.developer → WP_CLI commands

## VSCode
vscode:
  manage-flags → Workspace configuration
  track-usage → Global state API
  provide-ui.quick-access → Command palette
  provide-ui.detailed-view → Tree view provider
  provide-ui.configuration → Contribution points
  provide-ui.developer → Debug console integration
@end
```

## Build Pipeline

```bash
# One command, multiple targets
just build-universal

# Generated output:
extension/dist/
├── firefox/
│   └── fireflag-0.1.0.xpi
├── chrome/
│   └── fireflag-0.1.0.crx
├── safari/
│   └── fireflag-0.1.0.appex
├── zotero/
│   └── fireflag-zotero-0.1.0.xpi
├── wordpress/
│   └── fireflag-wp-0.1.0.zip
├── vscode/
│   └── fireflag-vscode-0.1.0.vsix
└── obsidian/
    └── fireflag-obsidian-0.1.0.zip
```

## Challenges & Solutions

### Challenge 1: Paradigm Mismatches
**Problem:** WordPress uses PHP + hooks, browsers use JavaScript + events

**Solution:** Abstract to "lifecycle events"
```
browser.runtime.onInstalled → PHP register_activation_hook
browser.storage.onChange → WordPress update_option hook
```

### Challenge 2: API Incompatibilities
**Problem:** Firefox has `sidebar_action`, Chrome has `side_panel`

**Solution:** Feature detection + graceful degradation
```nickel
let generate_sidebar = fun target =>
  if target == "firefox" then
    { sidebar_action = ... }
  else if target == "chrome" then
    { side_panel = ... }
  else
    null  # Omit if not supported
```

### Challenge 3: Different Security Models
**Problem:** Browsers have permissions, WordPress has capabilities, VSCode has no permissions

**Solution:** Abstract to "required access"
```a2ml
@access:
- storage: local
- settings: browser-configuration
- ui: administrative-interface

# Maps to:
# Firefox: permissions: ["storage", "browserSettings"]
# WordPress: capability: "manage_options"
# VSCode: (no manifest, all access granted)
```

## Future: Universal Plugin Ecosystem

Imagine a world where:
```bash
# One source
extension.uxf

# Compiled to 10+ targets
just compile --all

# Deployed everywhere
just publish firefox chrome safari zotero wordpress vscode obsidian
```

**One codebase, all platforms.**

This is the **"Write Once, Run Anywhere"** dream for extensions!

## Next Steps

Want me to:
1. **Prototype Level 1** (MV2/MV3 generator for FireFlag)?
2. **Prototype Level 2** (Firefox + Chrome from one source)?
3. **Design full UXF spec** (universal extension format)?
4. **Build proof-of-concept** (one source → 3 platforms)?
