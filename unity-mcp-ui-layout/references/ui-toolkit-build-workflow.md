# UI Toolkit Mockup Build Workflow

Use this as the canonical practical workflow when an approved mockup layout plan must become UI Toolkit UI. Keep general layout decisions in the neutral `mockup-layout-plan/v2` contract; use this guide only for UI Toolkit realization.

## 1. Confirm Intake and Target

Record selection evidence before creating assets:

- the explicit user instruction, selected owner, active UI root, and mockup source
- `target_surface: runtime` or `target_surface: editor`
- the live Unity version and the evidence used to identify it
- existing UXML, USS, `PanelSettings`, `UIDocument`, Editor UI owner, and nearby conventions

Do not infer the stack from loose asset presence. A runtime `UIDocument`, an Editor UI owner, or explicit direction must establish ownership.

## 2. Approve the Neutral Plan First

Produce and approve the `mockup-layout-plan/v2` artifact before creating UXML, USS, C#, or host objects. It must include the layout contract, stack realization, layout tree, candidate item ledger, item rect plan, asset plan, `behavior_plan`, and main plus alternate verification targets. The `behavior_plan` section is always present; write `behavior_plan: []` when no behavior is needed.

Resolve containers, repeated units, scroll ownership, responsive intent, and text behavior before choosing assets or tuning styles. Detailed shared-asset edit safety remains in `shared-asset-edit-safety.md`; this workflow only records which shared assets are intended for reuse.

## 3. Build the Selected Surface

Create new owned assets with `manage_ui(action="create", path="Assets/UI/Inventory.uxml", contents="<ui:UXML ...>...</ui:UXML>")`; use the corresponding `.uss` path and contents for the stylesheet. When intake identifies existing owned assets, use `manage_ui(action="update", path="Assets/UI/Inventory.uxml", contents="<ui:UXML ...>...</ui:UXML>")` and update the USS separately as appropriate.

For every repeated unit, default to a reusable UXML template backed by a `VisualTreeAsset`, with repeatable appearance expressed as USS classes.

### Stylesheet Linking

Unity-valid canonical syntax is bare `<Style src="..." />`. Require an existing valid reference or add that bare element manually.

1. Inspect the available `manage_ui` capabilities before considering `link_stylesheet`.
2. Only when that action is advertised and its output can be inspected, call `manage_ui(action="link_stylesheet", path="Assets/UI/Inventory.uxml", stylesheet="Assets/UI/Inventory.uss")`.
3. Read the resulting UXML immediately and verify the stylesheet reference.
4. If the action emits `<ui:Style>`, `<ui:Style>` is invalid and must not be accepted as a successful stylesheet link.
5. Replace invalid output with `manage_ui(action="update", path="Assets/UI/Inventory.uxml", contents="<ui:UXML ...><Style src=&quot;Inventory.uss&quot; />...</ui:UXML>")`.
6. After the manual update, read the UXML again and confirm the bare style element is present.
7. Then trigger import for the changed assets.
8. Finally, read the console for UXML or USS errors.

Do not invoke `link_stylesheet` blindly. Verify the stylesheet link before owner attachment or visual checks.

### Runtime

1. Inspect the selected scene and find an existing `UIDocument` host before creating any host object. Reuse it when ownership and lifecycle match the plan.
2. If the runtime screen needs a host and none exists, use `manage_gameobject` to create a host GameObject.
3. Reuse a compatible `PanelSettings` asset. Otherwise call `manage_ui(action="create_panel_settings", path="Assets/UI/RuntimePanelSettings.asset")` with settings justified by the target and project conventions.
4. Attach the approved source to that `UIDocument` host with `manage_ui(action="attach_ui_document", target="InventoryUI", source_asset="Assets/UI/Inventory.uxml", panel_settings="Assets/UI/RuntimePanelSettings.asset")`.
5. Inspect the attached host with `manage_ui(action="get_visual_tree", target="InventoryUI", max_depth=8)`, then compare the resolved hierarchy with the approved layout tree.

Creating a host GameObject in a scene is not creating a prefab asset. In mockup language, "prefab" usually means reusable intent; satisfy that intent with a reusable UXML template and USS classes. Create a host prefab only when the user explicitly requires host reuse or the host has scene lifecycle responsibilities.

### Editor UI

1. For `target_surface: editor`, create or update UXML and USS plus the actual Editor UI owner: an `EditorWindow` with `CreateGUI`, a custom inspector, or a property drawer.
2. Verify the owner can load or clone the intended `VisualTreeAsset`, adds the clone to its root visual element, and resolves the canonical stylesheet reference.
3. Verify the loaded or cloned hierarchy through the owner and retain that evidence. Editor completion does not assume a runtime host lifecycle.

## 4. Add Behavior Only When Needed

UXML and USS own structure and presentation. The C# behavior owner is optional and is needed only when the UI requires callback registration, data binding, a state class or state transitions, focus policy, or keyboard/controller navigation.

Keep the root `behavior_plan` section in every v2 artifact. When behavior exists, name the behavior owner and its responsibilities there; otherwise use `behavior_plan: []`. Keep callback, binding, state, focus, and navigation ownership explicit instead of hiding behavior in asset setup steps.

Bindings and related APIs are version-sensitive. Verify them against the live Unity version and installed API before writing code. Never silently apply Unity 6 binding assumptions to an older Unity version.

## 5. Verify the Build

Run a complete evidence loop:

1. Trigger asset import and script compile.
2. Check the console for import, UXML, USS, and C# errors or warnings.
3. For runtime UI, retain the resolved tree from `manage_ui(action="get_visual_tree", target="InventoryUI", max_depth=8)` on the attached `UIDocument` host and verify the stylesheet link before reviewing relevant text/state output.
4. For Editor UI, verify the Editor owner loads or clones the intended `VisualTreeAsset`; inspect the resulting owner hierarchy and stylesheet without assuming runtime `UIDocument` or `PanelSettings` setup.
5. Capture a main screenshot at the approved target size.
6. Capture an alternate screenshot at the approved narrower, wider, or otherwise meaningful size.
7. Check hierarchy, text, state, and interaction behavior at both targets, including repeated template instances, binding results, callbacks, focus, and navigation when applicable.

Do not accept a screenshot alone when behavior or state is part of the plan. Preserve the main and alternate evidence in the completion report.

## 6. Disclose Tool Limits and Use Fallback Evidence

Treat every MCP tool limitation honestly. If the available MCP cannot inspect computed styles, perform event injection, or provide binding diagnostics, do not imply those checks ran.

Use the narrowest useful fallback:

- inspect UXML, USS, and C# files directly
- add focused edit-mode or play-mode scripts/tests
- use Unity's UI Debugger for computed styles and resolved layout
- perform manual interaction checks for events, focus, or navigation
- capture console, screenshot, text, and state evidence

State the tool limitation and the fallback evidence in the final report. If a required claim still cannot be verified, mark it unresolved rather than inferring success.
