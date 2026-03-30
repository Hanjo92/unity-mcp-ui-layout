# Image to Layout Rules

Use this guide when the user provides a layout image, mockup, wireframe, or screenshot together with a target resolution.

Pair it with `mockup-resolution.md` when the mockup's own native pixel size should become the planning reference frame.

## Goal

Translate a visual reference into Unity UI that is stable at the target resolution or mockup reference resolution and anchored by screen relationships, not by arbitrary absolute pixels.

## Input Rules

Require these inputs when available:

- One layout image
- One target resolution such as `1920x1080` or `1080x1920`
- The intended UI stack if already known: UGUI or UI Toolkit
- Any fixed constraints such as safe area, notch area, or margins

If the image is the only reliable source of truth, use it as the composition reference.
If no explicit target resolution is provided, use the image's native resolution as the initial reference frame instead of defaulting immediately to `1920x1080`.

## Reference Resolution Priority

Choose the planning frame in this order:

1. explicit target resolution from the user
2. mockup image native resolution
3. project-defined target resolution if already known
4. fallback default such as `1920x1080`

If both the mockup resolution and an explicit target resolution exist, keep both and normalize geometry between them instead of pretending they are the same pixel space.

## Asset-RAG Fallback Contract

When image-to-layout work intersects with asset reuse, keep the layout workflow moving even if asset retrieval is incomplete.

- If `unity-resource-rag` is unavailable, continue with image-to-layout translation using the existing layout rules.
- Preserve structure-first execution: build regions, anchors, and parent containers before spending time on final art selection.
- Use placeholder visuals or existing manually discovered assets when retrieval support is missing.
- Explicitly say that asset-aware retrieval was skipped when `unity-resource-rag` is unavailable.
- If `unity-resource-rag` is available but retrieval confidence is low, do not force an asset match just to claim reuse.
- Keep the layout workflow moving, mark visuals as provisional, and verify structure first.
- Never present missing or low-confidence asset-RAG capability as a hard blocker unless the user explicitly requires asset-index-backed reuse.
- Keep any asset-mode disclosure to one or two lines.
- In asset-aware mode, say that existing project assets will be retrieved and reused where confidence is high.
- In layout-only mode, say that the task will proceed without asset-index-backed retrieval, focus on stable structure first, and use placeholders or directly inspected assets if needed.

## Translation Procedure

### 1. Segment the image

Break the layout into:

- Root frame
- Major regions
- Repeated groups
- Atomic widgets

Do not jump directly from whole image to dozens of leaf nodes.
Group the topmost composition by anchor-owned regions first so the largest blocks already belong to stable screen relationships.

### 2. Estimate normalized geometry

For each major element, estimate:

- Left ratio: `x / screen_width`
- Top ratio: `y / screen_height`
- Width ratio: `w / screen_width`
- Height ratio: `h / screen_height`

Treat these as planning values, not necessarily as final serialized numbers.
When a mockup image exists, derive them from the mockup's own width and height before mapping them to the implementation frame.

### 3. Pick anchor strategy by region

Use these defaults:

- Top bar or top-left HUD: top anchors
- Bottom HUD or action bar: bottom anchors
- Side panel: left or right stretch against its screen edge
- Center dialog: centered anchors with stable width/height constraints
- Full content body: stretch anchors inside a bounded parent

Anchor according to the element's relationship to the screen, not according to whichever raw coordinates are easiest to enter.

### 4. Build parent containers first

Create the parent zones before children:

- Safe area root
- Header/footer/sidebar/content containers
- Nested rows, columns, or grids

Once the parent is right, many child values become smaller and more stable.
If the same structure appears multiple times, make one reusable prefab or reusable block before placing all copies.

### 5. Respect single-image regions

If a visual area appears to be one baked image or sprite:

- Keep it as a single image resource unless there is clear evidence that parts must resize, animate, or respond independently.
- Do not force decorative shapes into separate widgets just to trace the mockup more literally.
- Only split the image when interaction, dynamic text, or adaptive layout requires it.

### 6. Convert proportions into concrete values

For a given target resolution:

- Use ratios to decide anchor placement and stretch behavior.
- Use offsets for local spacing from the anchor frame.
- Use width/height values only after parent and anchor decisions are made.

Prefer "anchored top-right with 4% inset" over "x=1798, y=54".

## UGUI Rules

- Set `CanvasScaler` before evaluating final element size.
- If the UI is composition-driven, use a reference resolution matching the user-provided target resolution.
- Pick `Scale With Screen Size` by default unless the UI is intentionally non-responsive.
- Set `Match Width Or Height` deliberately based on which axis preserves composition better.
- Use anchor presets that match the image region before setting `anchoredPosition`.
- Use stretch anchors for structural containers and corner/center anchors for leaf widgets.
- For groups of siblings, prefer layout groups and padding to repeated manual offsets.
- Turn repeated sibling structures into prefabs or reusable blocks when they recur across the same screen.
- Align pivot with anchor and expected growth or animation direction.
- Keep manual positions only for isolated decorative elements or deliberate overlaps.
- If a decorative area is likely a single sprite, keep it as one image instead of rebuilding it from many forced sub-elements.

## UI Toolkit Rules

- Translate image regions into nested containers with flex rules.
- Use percentage or flex relationships at container level where possible.
- Move repeated spacing, alignment, and sizing logic into USS classes.
- Avoid many per-element inline absolute values unless the design is intentionally fixed.

## Review Questions

Before calling the result correct, verify:

- Does the composition match the image at the target resolution?
- If the mockup had a native resolution, was that resolution captured and used correctly as the planning frame?
- Are the top-level regions grouped by stable anchor ownership before child tuning?
- Are anchors consistent with the element's visual role?
- Were repeated structures converted into reusable prefabs or layout blocks where appropriate?
- If the resolution changes a little, does the UI still preserve intent?
- Was any likely single-image region over-decomposed into fake widgets without a runtime need?
- Are any values suspiciously pixel-specific where a ratio or container rule should exist?

If the answer to the last question is yes, refactor before continuing.
