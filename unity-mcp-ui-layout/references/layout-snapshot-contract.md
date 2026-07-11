# Unity UI Layout Snapshot Contract

Use this contract before editing Unity UI when a `unity-mcp` bridge can inspect the Editor. It defines the ideal single snapshot artifact an MCP tool or wrapper should return before layout repair or build work begins.

The snapshot is an intake artifact. It does not replace layer-to-tree planning, candidate item review, item rect planning, or screenshot verification.

## Goal

Capture the current UI state in one predictable shape so the agent does not start editing before it understands the active root, UI stack, parent ownership, layout controllers, assets, screenshot frame, and console state.

## When To Capture

Capture a layout snapshot when:

- the task edits an existing Unity UI screen
- the user asks for a mockup-to-prefab build inside an existing scene
- the task may touch shared prefabs, sprites, materials, or text styles
- the UI stack is unclear
- a repair depends on anchors, pivots, layout groups, safe area, scroll ownership, or text overflow

For a new screen in an empty scene, capture the snapshot anyway if the Editor is available. It records the absence of existing UI roots and prevents accidental edits to the wrong scene.

## Expected Snapshot Fields

A complete snapshot should include these fields. If a field cannot be inspected, include it with `unknown`, `not_applicable`, or an explicit fallback note rather than silently omitting it.

```yaml
snapshot_id: string
captured_at: string
target_surface: runtime | editor
unity_version: string | unknown
unity_version_evidence: string
scene:
  name: string
  path: string
  active_camera: string
selection:
  selected_object: string
  active_ui_root: string
ui_stack: UGUI | UI Toolkit | mixed | unknown
viewport:
  game_view_resolution: string
  aspect_ratio: string
  screenshot_path: string
  safe_area: string
ugui:
  canvases:
    - path: string
      render_mode: string
      sorting_layer: string
      sorting_order: number
      canvas_scaler:
        ui_scale_mode: string
        reference_resolution: string
        match_width_or_height: number
      safe_area_owner: string
ui_toolkit:
  documents:
    - path: string
      panel_settings: string
      source_uxml: string
      source_uss:
        - string
hierarchy:
  nodes:
    - path: string
      role: shell | safe-area owner | region | scroll owner | overlay | reusable group | runtime leaf | decorative image
      unity_type: string
      prefab_source: string
      rect:
        anchors: string
        pivot: string
        size: string
        anchored_position: string
        world_bounds: string
      layout:
        owner: string
        components:
          - string
        clipping_or_mask: string
        scroll_owner: string
      text:
        value_sample: string
        component: string
        overflow: string
        wrapping: string
assets:
  sprites:
    - string
  materials:
    - string
  tmp_styles:
    - string
  prefabs:
    - path: string
      shared: boolean
  reusable_uxml_templates:
    - string
  stylesheets:
    - string
  panel_settings:
    - string
  behavior_owners:
    - path: string
      behavior_scripts:
        - string
console:
  compile_state: clean | errors | unknown
  errors:
    - string
gaps:
  - string
```

`selection.selected_object` and `selection.active_ui_root` are the canonical intake names used by `ui-stack-selection.md` and `agent-runbook.md`. Do not introduce parallel selected-target or selected-root fields.

## UGUI Example Snapshot

```yaml
snapshot_id: "layout-snapshot/HUDScene/2026-07-06T10:00:00Z"
captured_at: "2026-07-06T10:00:00Z"
target_surface: "runtime"
unity_version: "2022.3.35f1"
unity_version_evidence: "ProjectSettings/ProjectVersion.txt"
scene:
  name: "HUDScene"
  path: "Assets/Scenes/HUDScene.unity"
  active_camera: "Main Camera"
selection:
  selected_object: "Canvas/HUDRoot"
  active_ui_root: "Canvas"
ui_stack: UGUI
viewport:
  game_view_resolution: "1920x1080"
  aspect_ratio: "16:9"
  screenshot_path: "Artifacts/Screenshots/HUDScene-1920x1080.png"
  safe_area: "full screen; no device override detected"
ugui:
  canvases:
    - path: "Canvas"
      render_mode: "Screen Space - Overlay"
      sorting_layer: "UI"
      sorting_order: 0
      canvas_scaler:
        ui_scale_mode: "Scale With Screen Size"
        reference_resolution: "1920x1080"
        match_width_or_height: 0.5
      safe_area_owner: "Canvas/SafeAreaRoot"
ui_toolkit:
  documents: []
hierarchy:
  nodes:
    - path: "Canvas/SafeAreaRoot"
      role: "safe-area owner"
      unity_type: "RectTransform"
      prefab_source: "not_applicable"
      rect:
        anchors: "stretch-stretch"
        pivot: "0.5,0.5"
        size: "1920x1080"
        anchored_position: "0,0"
        world_bounds: "0,0,1920,1080"
      layout:
        owner: "Canvas"
        components: []
        clipping_or_mask: "none"
        scroll_owner: "none"
      text:
        value_sample: "not_applicable"
        component: "none"
        overflow: "not_applicable"
        wrapping: "not_applicable"
    - path: "Canvas/SafeAreaRoot/HUDRoot/TopRightCluster"
      role: "region"
      unity_type: "RectTransform"
      prefab_source: "Assets/UI/Prefabs/HUD/CurrencyCluster.prefab"
      rect:
        anchors: "top-right"
        pivot: "1,1"
        size: "360x96"
        anchored_position: "-48,-36"
        world_bounds: "1512,36,360,96"
      layout:
        owner: "Canvas/SafeAreaRoot/HUDRoot"
        components:
          - "HorizontalLayoutGroup"
          - "ContentSizeFitter"
        clipping_or_mask: "none"
        scroll_owner: "none"
      text:
        value_sample: "12,340"
        component: "TextMeshProUGUI"
        overflow: "ellipsis"
        wrapping: "disabled"
assets:
  sprites:
    - "Assets/UI/Sprites/CurrencyIcon.png"
  materials: []
  tmp_styles:
    - "HUD/Counter"
  prefabs:
    - path: "Assets/UI/Prefabs/HUD/CurrencyCluster.prefab"
      shared: true
console:
  compile_state: "clean"
  errors: []
gaps: []
```

## UI Toolkit Example Snapshot

```yaml
snapshot_id: "layout-snapshot/SettingsScene/2026-07-06T10:05:00Z"
captured_at: "2026-07-06T10:05:00Z"
target_surface: "runtime"
unity_version: "2022.3.35f1"
unity_version_evidence: "ProjectSettings/ProjectVersion.txt"
scene:
  name: "SettingsScene"
  path: "Assets/Scenes/SettingsScene.unity"
  active_camera: "Main Camera"
selection:
  selected_object: "SettingsUIDocument"
  active_ui_root: "SettingsUIDocument"
ui_stack: "UI Toolkit"
viewport:
  game_view_resolution: "1366x768"
  aspect_ratio: "16:9"
  screenshot_path: "Artifacts/Screenshots/SettingsScene-1366x768.png"
  safe_area: "not_applicable"
ugui:
  canvases: []
ui_toolkit:
  documents:
    - path: "SettingsUIDocument"
      panel_settings: "Assets/UI/PanelSettings.asset"
      source_uxml: "Assets/UI/Settings/SettingsScreen.uxml"
      source_uss:
        - "Assets/UI/Settings/SettingsScreen.uss"
hierarchy:
  nodes:
    - path: "root/settings-shell/content-scroll"
      role: "scroll owner"
      unity_type: "VisualElement"
      prefab_source: "not_applicable"
      rect:
        anchors: "not_applicable"
        pivot: "not_applicable"
        size: "960x620"
        anchored_position: "not_applicable"
        world_bounds: "203,88,960,620"
      layout:
        owner: "root/settings-shell"
        components:
          - "flex-direction: column"
          - "overflow: scroll"
        clipping_or_mask: "overflow hidden"
        scroll_owner: "self"
      text:
        value_sample: "not_applicable"
        component: "none"
        overflow: "not_applicable"
        wrapping: "not_applicable"
assets:
  sprites: []
  materials: []
  tmp_styles: []
  prefabs: []
  reusable_uxml_templates:
    - "Assets/UI/Common/SettingsRow.uxml"
  stylesheets:
    - "Assets/UI/Settings/SettingsScreen.uss"
    - "Assets/UI/Common/SettingsControls.uss"
  panel_settings:
    - "Assets/UI/PanelSettings.asset"
  behavior_owners:
    - path: "SettingsUIDocument"
      behavior_scripts:
        - "Assets/UI/Settings/SettingsScreenController.cs"
console:
  compile_state: "clean"
  errors: []
gaps:
  - "No direct prefab source exists for UI Toolkit visual tree nodes."
```

## Fallback: Gather Equivalent Smaller Calls

If a unified layout snapshot tool is unavailable, gather equivalent evidence through smaller calls before editing:

1. Read editor state for Unity version, target surface, scene, selection, play mode, and compile state.
2. Find UI roots and classify UGUI, UI Toolkit, mixed, or unknown.
3. Inspect `Canvas`, `CanvasScaler`, `UIDocument`, `PanelSettings`, safe-area owners, and root layout containers.
4. Inspect the parent chain and children for the target region, including anchors, pivots, bounds, layout groups, masks, scroll owners, and prefab links.
5. Inspect key text nodes for component type, sample value, wrapping, overflow, and style ownership.
6. Inspect referenced sprites, materials, TMP styles, prefabs, reusable UXML templates, stylesheets, `PanelSettings`, behavior owners, behavior scripts, and likely shared asset families when asset-aware mode is active.
7. Capture a screenshot and record resolution, aspect ratio, and screenshot path.
8. Read console or compile status before continuing with script-backed UI changes.

Fallback output can be shorter than the full schema, but it must still name the target surface, Unity version evidence, UI stack, active UI root, screenshot frame, parent ownership, layout controllers, and console state or explain why those fields could not be gathered.

## How Agents Should Use The Snapshot

- Use the snapshot to choose UI stack, change mode, design source, and asset strategy before editing.
- Use snapshot hierarchy as current-state evidence, not as the final intended hierarchy.
- For mockup-driven work, still produce a neutral layer-to-layout-tree plan before creating objects, then verify the final UGUI `Transform`/`RectTransform` hierarchy or UI Toolkit visual tree against it.
- For raster item analysis, keep candidate item ledger decisions separate from snapshot data.
- For item-level UI rect planning, map accepted runtime or repeated items to the planned hierarchy, not directly to snapshot leaf offsets.
- If snapshot gaps include unknown stack, unknown active root, compile errors, or missing screenshot, resolve those gaps before structural edits unless the user explicitly requested offline planning only.
