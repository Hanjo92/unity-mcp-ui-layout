# UI Toolkit From Mockup Example

This example turns an attached runtime UI Toolkit inventory/settings mockup into an implementation plan. It uses reusable UI Toolkit assets and does not automatically create a GameObject prefab.

## Intake Evidence

- mockup source: attached inventory/settings mockup
- selected owner: existing `InventorySettingsHost` with `UIDocument`
- `target_surface`: `runtime`
- Unity version: read from the live project before choosing binding APIs
- main target: 1920x1080
- alternate target: 1366x768

## v2 Layout Contract

```yaml
schema_version: "mockup-layout-plan/v2"
layout_contract:
  ui_stack: "UI Toolkit"
  mode: "build"
  mockup_source: "attached runtime inventory/settings mockup"
  root_owner: "InventorySettingsScreen"
  structure_rule: "approve neutral regions and repeated units before assets"
stack_realization:
  target_surface: "runtime"
  root_uxml: "Assets/UI/InventorySettings/InventorySettingsScreen.uxml"
  stylesheets:
    - "Assets/UI/InventorySettings/InventorySettingsScreen.uss"
  panel_settings: "Assets/UI/RuntimePanelSettings.asset"
  ui_document_host: "existing InventorySettingsHost"
```

## v2 Layout Tree

```yaml
layout_tree:
  - node_path: "InventorySettingsScreen"
    role: "screen root"
    layout_owner: ".inventory-settings-screen column"
  - node_path: "InventorySettingsScreen/InventoryPane/ItemGrid"
    role: "scroll owner and repeated item container"
    layout_owner: ".item-grid wrap and scroll"
  - node_path: "InventorySettingsScreen/InventoryPane/ItemGrid/ItemTile"
    role: "repeated inventory unit"
    node_kind: "TemplateContainer from VisualTreeAsset"
  - node_path: "InventorySettingsScreen/SettingsPane"
    role: "settings form"
    layout_owner: ".settings-pane minimum width"
```

## v2 Candidate and Asset Plans

```yaml
candidate_item_ledger:
  - candidate_id: "candidate/ItemTile/Icon"
    review_decision: "accept"
    evidence: ["repeated inventory icon slot", "runtime item data"]
  - candidate_id: "candidate/SettingsPane/Divider"
    review_decision: "reject"
    decision_note: "render with a USS border class"
item_rect_plan:
  - item_id: "ItemTile/Icon"
    candidate_id: "candidate/ItemTile/Icon"
    fit_mode: "flex-none preserve-aspect"
    placement_intent: "first child in reusable item tile"
asset_plan:
  - asset_plan_id: "asset/ItemTile/Icon"
    plan: "bind an existing item texture to the template icon element"
```

## UI Toolkit Realization

- Use `manage_ui` to create or update `InventorySettingsScreen.uxml` and `InventorySettingsScreen.uss`.
- Implement `ItemTile.uxml` as the reusable UXML template loaded as a `VisualTreeAsset`.
- Put repeated styling in USS classes such as `.item-tile`, `.item-tile__icon`, `.settings-row`, and `.settings-toggle`.
- Reuse the existing `PanelSettings` and attach the screen to the existing `UIDocument` host.
- Do not create an automatic GameObject prefab. A host prefab is outside this build unless explicit host reuse or scene lifecycle ownership is requested.

## v2 Behavior Plan

```yaml
behavior_plan:
  - behavior_id: "behavior/Inventory/PopulateTiles"
    owner: "InventorySettingsController"
    intent: "clone ItemTile.uxml and bind inventory item state"
    reusable_template: "Assets/UI/InventorySettings/ItemTile.uxml"
  - behavior_id: "behavior/Settings/Callbacks"
    owner: "InventorySettingsController"
    intent: "register settings callbacks and preserve focus navigation"
```

## v2 Verification Targets

```yaml
verification_targets:
  - target: "main runtime verification"
    resolution: "1920x1080"
    checks:
      - "inventory and settings regions match the attached mockup"
      - "reusable UXML template instances share the expected USS classes"
      - "settings bindings, callbacks, text, and focus state are correct"
  - target: "alternate runtime verification"
    resolution: "1366x768"
    checks:
      - "inventory scroll ownership remains stable"
      - "settings pane keeps its minimum width without clipping"
      - "keyboard or controller navigation remains usable"
```

Finish by checking import and compile results, the console, `get_visual_tree`, and screenshots for both the main and alternate targets. Disclose any MCP limitation and the fallback evidence used.
