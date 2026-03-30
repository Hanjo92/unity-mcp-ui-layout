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

For UGUI, prefer `find_gameobjects`, `manage_gameobject`, `manage_components`, `manage_scene`, `manage_prefabs`, `manage_script`, `manage_camera`, `refresh_unity`, and `read_console`.

For UI Toolkit, prefer `manage_ui`, `manage_script`, `find_in_file`, `manage_camera`, `refresh_unity`, and `read_console`.

## Workflow

### 1. Inspect Before Writing

Read the current context before making changes.

- Check editor readiness through `editor_state` or equivalent resources.
- Find the active scene, existing UI roots, and relevant cameras.
- For UGUI, inspect `Canvas`, `CanvasScaler`, parent `RectTransform`, active layout components, and safe-area handling before changing child objects.
- For UI Toolkit, find the active `UIDocument`, linked `UXML`, linked `USS`, and panel settings before editing styles.
- If the user provides a layout image and target resolution, treat them as the source spec for composition before creating any objects.
- If the user provides a layout image but no explicit target resolution, capture the image's native resolution and treat that as the initial reference frame.

Before planning changes, decide whether the task should stay in bounded repair mode or operate in greenfield build mode. Do not silently treat an existing-screen repair request like a full rebuild.

After the initial scene/editor inspection, run a quick capability check before planning the implementation:

- Detect whether `unity-resource-rag` MCP/tools are available.
- Detect whether an asset catalog or asset index is available.
- Default to layout-only mode unless there is a clear reuse signal.
- Switch into asset-aware mode only when at least one of these is true:
  - the user explicitly asks to preserve existing project visuals
  - the user mentions existing assets, prefabs, fonts, sprite atlases, or design system reuse
  - the requested screen type strongly suggests reusable project widgets
  - the project already contains similar UI and consistency clearly matters
- If those reuse signals are absent, stay in layout-only mode even if asset-retrieval tooling is available.
- If asset-aware mode is warranted and both `unity-resource-rag` and an asset catalog or asset index are available, look for matching reusable assets before building replacements from scratch.
- In asset-aware mode, follow a stable discovery order: reusable prefabs first, then variants or wrappers, then sprite-backed visuals, then text styles, then materials, and placeholders last.
- If asset-aware mode is warranted but `unity-resource-rag` is unavailable, continue with image-to-layout translation using the existing layout rules, preserve structure-first execution, use placeholder visuals or existing manually discovered assets, and explicitly state that asset-aware retrieval was skipped.
- If asset-aware mode is warranted and `unity-resource-rag` is available but retrieval confidence is low, do not force an asset match, keep the layout workflow moving, mark visuals as provisional, and verify structure first.
- Missing or low-confidence asset-RAG capability is not a hard blocker unless the user explicitly requires asset-index-backed reuse.
- Make it explicit in your reasoning that missing `unity-resource-rag` support is normal and supported. Treat its absence as an expected environment variation, not as an error condition.
- Keep any mode disclosure brief: one or two lines only.
- In asset-aware mode, say that existing project assets will be retrieved and reused where confidence is high.
- In layout-only mode, say that the task will proceed without asset-index-backed retrieval, focus on stable structure first, and use placeholders or directly inspected assets if needed.

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
2. Group the topmost composition into anchor-owned regions first so every major block belongs to a stable top, bottom, left, right, or center frame before you tune children.
3. Estimate each element's position and size as percentages of the target resolution, not as final hard-coded pixels.
4. Choose anchors from the element's semantic region: top bar, bottom HUD, left rail, right panel, centered modal, full stretch content.
5. For repeated structures, build one reusable prefab or reusable layout block first, then duplicate or instantiate it instead of rebuilding the same shape manually.
6. If a region appears to be a single image resource, do not force it into an artificial multi-widget structure just to mimic shapes that are already baked into the art.
7. Use pixel values only as the result of converting those proportions into the current reference resolution.
8. Re-check that the chosen anchors preserve the composition if the aspect ratio changes slightly.

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
- Group major top-level regions by anchor ownership before detailing leaf widgets.
- Choose anchors based on the element's persistent relationship to screen edges or center, then fit size and offsets inside that anchored frame.
- For UGUI, pick a `CanvasScaler` strategy before sizing children: usually `Scale With Screen Size`, occasionally `Constant Pixel Size`, rarely `Constant Physical Size`.
- For UGUI, use stretch anchors for containers and fixed anchors for leaf widgets that hug a stable corner or center.
- Do not mix `LayoutGroup` control with manual child placement unless you intentionally disable the layout system first.
- Turn repeated sibling patterns into reusable prefabs or reusable layout blocks when the same structure appears more than once.
- Always inspect `CanvasScaler` before judging element sizes across resolutions.
- Avoid storing a design as "x=742, y=118" unless the UI intentionally targets a fixed render surface with no adaptive behavior.
- Avoid combining `ContentSizeFitter` and parent layout control in ways that create feedback loops.
- Do not decompose a likely single-image asset into fake sub-shapes unless interaction, animation, or dynamic layout actually requires separate elements.
- For static UI visuals, prefer `Image` plus sprite-based assets. Reserve `RawImage` for true texture-driven content such as `RenderTexture`, video, or runtime-generated textures.
- Treat text as a layout driver. Check wrapping, overflow, best-fit/auto-size, and font asset limits before resizing containers.
- For UI Toolkit, prefer USS classes and container rules over many inline style overrides.
- If the user gives only a visual description, assume one target resolution first, implement for that resolution, then test at additional aspect ratios.
- If the screen looks crowded, reduce hierarchy complexity and nesting depth before adding more overrides.

## Resolution and Verification Rules

- Default to `1920x1080` only if the project does not already define another target resolution.
- If a mockup or design image exists and no explicit target resolution was provided, use the mockup image's native resolution as the reference resolution.
- If the user specifies a target resolution, treat it as the reference frame for size and offset calculations.
- If both a mockup resolution and an explicit target resolution exist, use the mockup resolution as the composition measurement space and the explicit target resolution as the implementation and verification space.
- Express intended measurements in normalized terms during planning: width ratio, height ratio, edge distance ratio, safe-area relationship.
- Re-check at one narrow aspect ratio and one wide aspect ratio before calling the layout done.
- If the project appears mobile-first, verify portrait and landscape separately.
- Use visual comparison language in follow-up steps: aligned, clipped, stretched, overflowing, uneven, off-safe-area.

## Use the References

- Read `references/layout-checklist.md` when the UI is misaligned, clipped, stretched, or behaving differently across resolutions.
- Read `references/common-failures.md` when the UI result technically exists but still feels fragile, inconsistent, overfit to one resolution, or structurally wrong.
- Read `references/image-to-layout.md` when the user provides a mockup, screenshot, wireframe, or other layout image plus a target resolution.
- Read `references/mcp-call-recipes.md` when you need concrete `unity-mcp` call sequences for discovery, creation, repair, verification, or script-backed UI work.
- Read `references/mockup-decomposition.md` when a design image exists and you need to decide which regions should stay as one asset, which should be split, and which should become reusable blocks.
- Read `references/mockup-resolution.md` when a design image exists and its own native resolution should become the planning reference frame.
- Read `references/ui-change-modes.md` when you need to decide whether the task should be handled as bounded repair or as a new build.
- Read `references/asset-discovery-priority.md` when asset-aware mode is active and you need to decide what kinds of existing assets to search in what order.
- Read `references/existing-prefab-reuse.md` when the project likely already contains a similar reusable UI block and you need to choose reuse, variant, wrapper, or a new base prefab.
- Read `references/prefab-variants.md` when one shared base prefab should branch into a controlled family of variants without polluting the base asset.
- Read `references/prefab-reuse.md` when the same UI shape appears more than once and should be extracted into one reusable prefab or template-style block.
- Read `references/review-checks.md` when you need a final quality pass before calling a Unity UI task complete.
- Read `references/sprite-vs-rawimage.md` when static UI assets are being wired through `RawImage` instead of the normal sprite workflow.
- Read `references/ugui-anchors-canvas-scaler.md` when the target is UGUI or when anchor, pivot, or screen-scaling behavior is causing drift.
- Read `references/ugui-hud.md` for always-on-screen HUD, minimap, status bars, and action bars.
- Read `references/ugui-inventory.md` for slot grids, item lists, equipment panels, and shop layouts.
- Read `references/ugui-popup.md` for modal dialogs, settings windows, reward popups, and overlays.
- Read `references/ugui-mobile-safe-area.md` for notch-safe mobile layouts in portrait or landscape.
- Read `references/prompt-patterns.md` when decomposing a UI request into smaller MCP operations or when you need a safer prompt shape for iterative generation.
