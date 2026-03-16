# Unity UI Layout Checklist

Use this checklist when a generated UI does not match the intended layout.

If the user gave a layout image and resolution, also read `image-to-layout.md` and check whether the implementation preserved composition through anchors and parent containers rather than raw coordinate copying.
If the target is UGUI, also read `ugui-anchors-canvas-scaler.md` before changing anchors or scaler settings.

## 1. Identify the UI System

### UGUI signals

- `Canvas`
- `RectTransform`
- `CanvasScaler`
- `HorizontalLayoutGroup`, `VerticalLayoutGroup`, `GridLayoutGroup`
- `ContentSizeFitter`
- `TextMeshProUGUI`

### UI Toolkit signals

- `UIDocument`
- `UXML`
- `USS`
- `VisualElement`
- `PanelSettings`

## 2. UGUI Triage Order

Check these top to bottom.

1. `Canvas` render mode and active camera
2. `CanvasScaler` mode, reference resolution, and width-height match behavior
3. Safe-area root and major region containers
4. Parent anchors and stretch mode
5. Parent layout groups and content fitters
6. Child anchors, pivot, and size delta
7. Whether child placement is owned by layout components or manual offsets
8. Text wrapping, overflow, and auto-size
9. Sprite slicing and image preserve-aspect rules
10. Safe area handling for edge-aligned elements

## 3. UGUI Failure Patterns

### Elements drift on different resolutions

- Inspect `CanvasScaler` first.
- Confirm the reference resolution matches the intended target frame.
- Confirm `Match Width Or Height` was chosen deliberately instead of left at an arbitrary default.
- Replace fixed offsets with anchors or stretch presets.
- Replace copied image pixel coordinates with normalized placement intent.
- Remove redundant nested containers that each impose size rules.

### Children ignore manual positions

- Check for active layout groups on the parent.
- Disable or reconfigure the layout group before applying manual child transforms.
- Confirm the child should be hand-placed at all; repeated siblings usually should not be.
- If the same child structure repeats, replace manual reconstruction with a reusable prefab or reusable layout block.

### Top-level composition feels unstable

- Check whether the screen was grouped into anchor-owned top regions before child tuning.
- Rebuild the largest header, footer, sidebar, corner cluster, or center modal containers first.
- Avoid solving top-level drift with many per-widget offsets.

### Text overflows or collapses the row

- Check TMP wrapping and overflow settings.
- Check whether `ContentSizeFitter` and layout groups are fighting each other.
- Give the text container a clear width rule before changing font size.

### HUD touches screen edges

- Verify anchors and pivot.
- Confirm safe-area logic for mobile layouts.
- Put edge UI under a dedicated safe-area container instead of offsetting each child.

### Mockup was over-translated into fake widgets

- Check whether a decorative area is actually one sprite or one baked image resource.
- Collapse forced sub-elements back into a single image unless they need separate runtime behavior.
- Keep structural splitting only where interaction, animation, text, or adaptive sizing requires it.

### Modal scales strangely or animates from the wrong point

- Check centered anchors first.
- Check pivot alignment with the intended animation origin.
- Remove inherited stretch behavior if the modal should be fixed-size inside a centered parent.

## 4. UI Toolkit Triage Order

1. Root `UIDocument` and `PanelSettings`
2. Root container size rules
3. Parent `flex-direction`, `justify-content`, `align-items`
4. Child `flex-grow`, basis, width, height, min/max constraints
5. Margins, padding, and gaps
6. Text overflow, white-space, and font sizing
7. Class-based USS versus inline overrides

## 5. UI Toolkit Failure Patterns

### Layout looks right in one panel but breaks after another edit

- Find conflicting inline style writes.
- Move repeated rules into USS classes.
- Reduce one-off overrides on children if the parent flex rule should handle the layout.

### Element will not fill expected space

- Inspect parent size constraints first.
- Check `flex-grow`, width, and min-width/min-height together.
- Confirm the parent is not using a conflicting alignment rule.
- Check whether the design was translated from image pixels instead of parent-relative rules.

### Spacing becomes inconsistent

- Standardize on parent `gap` or explicit margins, not both everywhere.
- Remove duplicated padding from both container and child where possible.

## 6. Screenshot Review Questions

After each iteration, ask:

- Is the root composition correct?
- Are regions aligned to the intended edges and center lines?
- Is any text clipped, wrapping unexpectedly, or causing row growth?
- Are sibling gaps visually even?
- Does the design survive one alternate aspect ratio?
- Are the top-level regions grouped by anchor ownership rather than many leaf-level corrections?
- Were repeated structures reused instead of rebuilt one by one?
- Was any likely single-image region kept simple instead of over-modeled?
- Did any placement depend on raw image pixels when an anchor or container rule should have been used?

If any answer is no, fix structure before polishing visuals.
