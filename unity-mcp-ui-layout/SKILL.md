---
name: unity-mcp-ui-layout
description: Guide for building or fixing Unity UI through MCP for Unity when working from mockups, screenshots, wireframes, or target resolutions, especially for UGUI HUDs, inventories, popups, mobile safe-area layouts, or UI Toolkit screens where anchors drift, scaling breaks, spacing is inconsistent, or the result does not match the intended composition. Use when Codex is controlling Unity with unity-mcp to translate layout images into anchored UI, choose CanvasScaler rules, repair popup safe-area behavior, iterate from screenshots, and keep UI work in small verifiable steps instead of one large generation.
---

# Unity MCP UI Layout

## Overview

Build Unity UI through `unity-mcp` in a staged loop: inspect first, create a small slice, verify with screenshots, then adjust structure before visuals. Prefer deterministic layout systems over manual pixel nudging and convert visual references into resolution-aware layout rules rather than raw absolute coordinates.

## Choose the UI Stack First

Identify the target before editing:

- Use UGUI when the scene uses `Canvas`, `RectTransform`, `CanvasScaler`, `LayoutGroup`, `ContentSizeFitter`, `Image`, or `TextMeshProUGUI`.
- Use UI Toolkit when the project uses `UIDocument`, `UXML`, `USS`, `VisualElement`, or `PanelSettings`.
- Do not mix both stacks in the same change unless the user explicitly asks for a bridge or migration.

For UGUI, prefer `find_gameobjects`, `manage_gameobject`, `manage_components`, `manage_scene`, `manage_script`, `manage_camera`, `refresh_unity`, and `read_console`.

For UI Toolkit, prefer `manage_ui`, `manage_script`, `find_in_file`, `manage_camera`, `refresh_unity`, and `read_console`.

## Workflow

### 1. Inspect Before Writing

Read the current context before making changes.

- Check editor readiness through `editor_state` or equivalent resources.
- Find the active scene, existing UI roots, and relevant cameras.
- For UGUI, inspect `Canvas`, `CanvasScaler`, parent `RectTransform`, active layout components, and safe-area handling before changing child objects.
- For UI Toolkit, find the active `UIDocument`, linked `UXML`, linked `USS`, and panel settings before editing styles.
- If the user provides a layout image and target resolution, treat them as the source spec for composition before creating any objects.

### 2. Build in Vertical Slices

Do not generate the full interface in one shot.

Build in this order:

1. Root shell: canvas or root visual element, scaler/panel settings, safe area container.
2. Main regions: header, content, footer, sidebar, modal layer.
3. One feature block at a time: inventory panel, HUD bar, dialog, settings row.
4. Visual polish after structure is stable.

After each slice, verify with a screenshot and only then continue.

Use `manage_camera` for screenshot verification. Use `refresh_unity` followed by `read_console` after script edits or when the layout depends on newly compiled components.

### 3. Convert Images Into Relative Layout

When a layout image and target resolution are provided, derive structure from the image before editing:

1. Identify major regions and each element's intended parent container.
2. Estimate each element's position and size as percentages of the target resolution, not as final hard-coded pixels.
3. Choose anchors from the element's semantic region: top bar, bottom HUD, left rail, right panel, centered modal, full stretch content.
4. Use pixel values only as the result of converting those proportions into the current reference resolution.
5. Re-check that the chosen anchors preserve the composition if the aspect ratio changes slightly.

If an element is described as "10% from the left, 8% from the top, 25% width", encode that intent through anchors and container rules first. Use offsets only for the final local adjustment inside the anchored region.

### 4. Fix Structure Before Styling

When layout is wrong, inspect these in order:

1. Parent container choice
2. Anchors, pivot, and stretch rules
3. Layout groups or flex direction
4. Size constraints and preferred sizes
5. Text wrapping, overflow, and auto-sizing
6. Spacing, padding, margins, colors, and sprites

Do not start with pixel offsets if the parent layout model is wrong.

### 5. Verify Every Iteration

Use screenshots aggressively.

- Capture the whole screen after each structural change.
- Capture verification screenshots with `manage_camera`.
- If a specific panel is wrong, isolate that region and inspect its parent chain.
- Read console errors after script edits or component changes with `read_console`.
- If scripts were added or modified, run `refresh_unity`, confirm compilation, then continue UI edits.

## Guardrails

- Prefer anchors and layout groups over hard-coded child positions in UGUI.
- When the user provides a layout image, interpret it as a proportional composition guide, not a demand for exact screen pixels everywhere.
- Choose anchors based on the element's persistent relationship to screen edges or center, then fit size and offsets inside that anchored frame.
- For UGUI, pick a `CanvasScaler` strategy before sizing children: usually `Scale With Screen Size`, occasionally `Constant Pixel Size`, rarely `Constant Physical Size`.
- For UGUI, use stretch anchors for containers and fixed anchors for leaf widgets that hug a stable corner or center.
- Do not mix `LayoutGroup` control with manual child placement unless you intentionally disable the layout system first.
- Always inspect `CanvasScaler` before judging element sizes across resolutions.
- Avoid storing a design as "x=742, y=118" unless the UI intentionally targets a fixed render surface with no adaptive behavior.
- Avoid combining `ContentSizeFitter` and parent layout control in ways that create feedback loops.
- Treat text as a layout driver. Check wrapping, overflow, best-fit/auto-size, and font asset limits before resizing containers.
- For UI Toolkit, prefer USS classes and container rules over many inline style overrides.
- If the user gives only a visual description, assume one target resolution first, implement for that resolution, then test at additional aspect ratios.
- If the screen looks crowded, reduce hierarchy complexity and nesting depth before adding more overrides.

## Resolution and Verification Rules

- Default to `1920x1080` only if the project does not already define another target resolution.
- If the user specifies a target resolution, treat it as the reference frame for size and offset calculations.
- Express intended measurements in normalized terms during planning: width ratio, height ratio, edge distance ratio, safe-area relationship.
- Re-check at one narrow aspect ratio and one wide aspect ratio before calling the layout done.
- If the project appears mobile-first, verify portrait and landscape separately.
- Use visual comparison language in follow-up steps: aligned, clipped, stretched, overflowing, uneven, off-safe-area.

## Use the References

- Read `references/layout-checklist.md` when the UI is misaligned, clipped, stretched, or behaving differently across resolutions.
- Read `references/common-failures.md` when the UI result technically exists but still feels fragile, inconsistent, overfit to one resolution, or structurally wrong.
- Read `references/image-to-layout.md` when the user provides a mockup, screenshot, wireframe, or other layout image plus a target resolution.
- Read `references/mcp-call-recipes.md` when you need concrete `unity-mcp` call sequences for discovery, creation, repair, verification, or script-backed UI work.
- Read `references/review-checks.md` when you need a final quality pass before calling a Unity UI task complete.
- Read `references/ugui-anchors-canvas-scaler.md` when the target is UGUI or when anchor, pivot, or screen-scaling behavior is causing drift.
- Read `references/ugui-hud.md` for always-on-screen HUD, minimap, status bars, and action bars.
- Read `references/ugui-inventory.md` for slot grids, item lists, equipment panels, and shop layouts.
- Read `references/ugui-popup.md` for modal dialogs, settings windows, reward popups, and overlays.
- Read `references/ugui-mobile-safe-area.md` for notch-safe mobile layouts in portrait or landscape.
- Read `references/prompt-patterns.md` when decomposing a UI request into smaller MCP operations or when you need a safer prompt shape for iterative generation.
