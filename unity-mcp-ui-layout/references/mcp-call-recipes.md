# Unity MCP Call Recipes

Use this guide when you need concrete `unity-mcp` call order instead of only high-level layout rules.

These recipes are intentionally practical. Start from discovery, make one bounded change, then verify.

## 1. Inspect an Existing UI Before Editing

Use this when the scene already contains UI and you need to understand what is there before changing it.

### Typical sequence

1. Read the current editor state
2. Find UI roots and relevant objects
3. Capture a screenshot
4. Decide whether the issue is structural or visual

### Example prompt

```text
Inspect the current Unity UI before editing anything.
Find the active UI roots, determine whether this is UGUI or UI Toolkit, and capture a verification screenshot.
Do not modify assets yet.
```

### Common calls

- `editor_state` resource
- `find_gameobjects`
- `manage_camera` with screenshot capture

## 2. Build a New UGUI HUD From a Layout Image

Use this when the user provides a mockup or screenshot and wants a HUD built in UGUI.

### Typical sequence

1. Inspect the existing scene and UI roots
2. Create or identify the root canvas structure
3. Build `SafeAreaRoot` and `HUDRoot`
4. Add corner and center containers
5. Add one HUD group at a time
6. Capture screenshots after each slice

### Example prompt

```text
Build a 1920x1080 UGUI HUD from the attached image.
Create the root canvas structure first, then SafeAreaRoot and HUDRoot, then add corner containers before leaf widgets.
Verify each structural step with screenshots.
```

### Common calls

- `find_gameobjects`
- `manage_gameobject`
- `manage_components`
- `manage_camera`
- `read_console`

## 3. Repair a Drifting HUD Corner

Use this when one corner widget moves incorrectly at different resolutions.

### Typical sequence

1. Identify the drifting widget and its parent chain
2. Inspect anchors, pivot, and parent layout ownership
3. Check `CanvasScaler`
4. Apply the smallest anchor or parent-container fix
5. Verify at target and alternate aspect ratios

### Example prompt

```text
Inspect why the top-right HUD cluster is drifting.
Check the parent chain, anchors, pivot, and CanvasScaler settings first.
Apply the smallest structural fix and verify with screenshots at two aspect ratios.
```

### Common calls

- `find_gameobjects`
- `manage_components`
- `manage_gameobject`
- `manage_camera`

## 4. Build an Inventory Panel

Use this when building a slot-based inventory, shop, equipment panel, or crafting UI.

### Typical sequence

1. Create the main panel
2. Split the panel into navigation, list or grid, detail panel, and bottom actions
3. Use layout groups for repeated slots
4. Verify spacing and overlap

### Example prompt

```text
Build this as a UGUI inventory panel.
Create the main panel first, then split it into navigation, grid, detail, and actions.
Use layout groups for repeated slots instead of manual placement.
```

### Common calls

- `manage_gameobject`
- `manage_components`
- `manage_camera`
- `read_console`

## 5. Build a Mobile Popup With Safe Area

Use this when creating or fixing a popup on mobile.

### Typical sequence

1. Create or identify `ModalLayer`
2. Keep `Dimmer` and `PopupRoot` as siblings
3. Apply safe-area handling to `PopupRoot`
4. Add title, content, and footer sections
5. Verify portrait and landscape

### Example prompt

```text
Build this popup as a mobile UGUI modal.
Use ModalLayer with sibling Dimmer and PopupRoot, and keep safe-area handling on PopupRoot.
Verify portrait and landscape before finalizing.
```

### Common calls

- `manage_gameobject`
- `manage_components`
- `manage_camera`
- `read_console`

## 6. Script-Backed UI Changes

Use this when the UI depends on scripts, custom components, or compiled behavior.

### Typical sequence

1. Edit or create the required script
2. Refresh Unity
3. Read console output
4. Continue UI changes only if compile is clean
5. Capture a verification screenshot

### Example prompt

```text
Make the required script changes for this UI feature first.
After editing scripts, run refresh, wait for compile, inspect console errors, then continue with the UI layout work.
Capture a screenshot after the UI is updated.
```

### Common calls

- `manage_script`
- `refresh_unity`
- `read_console`
- `manage_camera`

## 7. UI Toolkit Screen Adjustment

Use this when the project uses `UIDocument`, `UXML`, and `USS`.

### Typical sequence

1. Identify the active `UIDocument`
2. Find related `UXML` and `USS`
3. Adjust parent containers first
4. Reduce inline style overrides when container rules should own layout
5. Verify with a screenshot

### Example prompt

```text
Inspect the current UI Toolkit screen and find the active UIDocument, UXML, and USS files.
Fix the layout by adjusting parent containers and style ownership before changing local overrides.
Then verify with a screenshot.
```

### Common calls

- `manage_ui`
- `find_in_file`
- `manage_script`
- `manage_camera`
- `read_console`

## 8. Promote a Repeated UI Block to a Prefab

Use this when the same slot, card, row, badge, or button cluster appears more than once and should stop being rebuilt manually.

### Typical sequence

1. Find the repeated instances and choose the cleanest one as the base
2. Normalize the base hierarchy and component setup
3. Create or update one reusable prefab
4. Replace repeated copies with prefab instances
5. Verify the base instance and at least one variant

### Example prompt

```text
Inspect the repeated UI blocks on this screen and find the cleanest shared structure.
Extract one reusable prefab for that structure, keep screen-level placement in the parent container, then replace the repeated manual copies with prefab instances.
Verify one base case and one content variant with screenshots.
```

### Common calls

- `find_gameobjects`
- `manage_gameobject`
- `manage_components`
- `manage_prefabs`
- `manage_camera`
- `read_console`
