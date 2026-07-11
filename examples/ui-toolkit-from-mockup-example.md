# UI Toolkit From Mockup Example

This scenario adapts the validated [UI Toolkit mockup layout plan](mockup-layout-plan-ui-toolkit-example.yaml) for an attached runtime inventory/settings mockup. That YAML file is the canonical machine-readable `mockup-layout-plan/v2` artifact and is covered by `tests/mockup_layout_plan_schema.sh`; this page does not duplicate it as partial YAML.

## Scenario Adaptation

Keep the canonical artifact's required root sections and ownership rules, then replace its quest-specific values with evidence from this screen:

- set `mockup_source` to the attached inventory/settings mockup and keep `target_surface` runtime
- set `root_owner` to `InventorySettingsScreen` and map the layout tree to `InventoryPane`, `ItemGrid`, `ItemTile`, and `SettingsPane`
- adapt the accepted candidate and item rect to `ItemTile/Icon`; keep decorative dividers as USS rather than runtime image nodes
- point `root_uxml` and `stylesheets` to the inventory/settings assets while retaining `reusable_asset_type: uxml-template`
- keep the required `behavior_plan` array; use `behavior_plan: []` only if the adapted screen has no callbacks, binding, state, focus, or navigation behavior
- replace verification targets with main 1920x1080 and alternate 1366x768 runtime checks

Run the canonical plan validator after adapting the YAML:

```bash
bash tests/mockup_layout_plan_schema.sh path/to/inventory-settings-plan.yaml
```

## Runtime Build

Use `manage_ui` to create or update `InventorySettingsScreen.uxml`, `ItemTile.uxml`, and `InventorySettingsScreen.uss`. `ItemTile.uxml` is the reusable UXML template loaded as a `VisualTreeAsset`.

Use these stable element names:

- `inventory-settings-screen`
- `inventory-scroll-view`
- `item-grid`
- `settings-pane`
- `close-button`
- `music-toggle`
- `sfx-slider`

Use these stable USS classes:

- `.inventory-settings-screen`
- `.inventory-settings-screen--compact`
- `.item-grid`
- `.item-tile`
- `.item-tile--selected`
- `.item-tile__icon`
- `.settings-row`
- `.settings-control--disabled`

Reuse a compatible `PanelSettings`. First inspect the scene for an existing `UIDocument` host with the correct lifecycle. If none exists and the runtime screen needs one, create a host GameObject with `manage_gameobject`, then use `attach_ui_document`. This scene object is not a prefab asset. Do not create a host prefab unless explicit host reuse or scene lifecycle requirements call for one.

## Behavior Details

Use `InventorySettingsController` as the optional behavior owner. Its adapted `behavior_plan` should name these responsibilities:

- clone `ItemTile.uxml` into `item-grid` and bind stable item IDs, icon textures, labels, counts, and selected state
- register `ClickEvent` on `close-button`, `ChangeEvent<bool>` on `music-toggle`, and `ChangeEvent<float>` on `sfx-slider`
- toggle `.item-tile--selected`, `.settings-control--disabled`, and `.inventory-settings-screen--compact` as explicit state classes
- set focus order from `close-button` to inventory tiles in row order, then `music-toggle`, then `sfx-slider`
- define keyboard/controller navigation so arrow input stays within the item grid, Tab advances to settings controls, and cancel invokes the close callback

Use stable element names and USS classes as query and state contracts; do not query by visual position or transient hierarchy index.

## Executable Verification

1. Run `bash tests/mockup_layout_plan_schema.sh path/to/inventory-settings-plan.yaml` and require exit 0.
2. Trigger Unity import and compile, then query the console and require no new UXML, USS, or C# errors.
3. Call `get_visual_tree`; verify one `inventory-settings-screen`, one `inventory-scroll-view`, one `item-grid`, one `settings-pane`, and the expected number of cloned item tiles.
4. At the main 1920x1080 target, capture a screenshot and verify region proportions, text, bound item state, `.item-tile--selected`, and all three callbacks.
5. Move focus through the documented order and exercise arrow, Tab, and cancel navigation; record text/state evidence when event injection is unavailable.
6. At the alternate 1366x768 target, capture a screenshot and verify `.inventory-settings-screen--compact`, inventory scroll ownership, settings minimum width, callback results, and focus continuity.
7. Record any MCP tool limitation and the UI Debugger, script/test, or manual evidence used instead.
