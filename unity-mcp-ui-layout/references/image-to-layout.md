# Image to Layout Rules

Use this guide when the user provides, uploads, attaches, or drops a layout image, reference image, UI design, mockup screenshot, wireframe, UI 시안, or screenshot together with a target resolution or prefab creation request.

Pair it with `mockup-resolution.md` when the mockup's own native pixel size should become the planning reference frame.
Pair it with `mockup-decomposition.md` when you need a stricter rule for deciding what should stay as one asset versus what should become runtime-owned UI.
Use `../../templates/mockup-layout-plan.yaml` when the agent needs a concise machine-readable plan for the layer tree, candidate item ledger, item rect plan, asset crop plan, and verification targets.

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

### 1. Run a layer pass

Before creating Unity objects, describe the layer stack from broad to narrow:

- screen/background layer
- safe-area or modal ownership layer
- major region layer such as header, body, footer, side rail, popup, or overlay
- repeated group layer such as cards, slots, rows, tabs, badges, or button clusters
- runtime leaf layer such as text, button hit targets, dynamic icons, counters, and stateful badges
- decorative image layer that should stay as one sprite or image where runtime behavior does not need splitting

The layer pass should produce a neutral layout tree, not just a visual checklist. Approve that layer-to-layout-tree pass before creating stack-specific objects.

Realize the approved tree explicitly for the chosen stack:

- **UGUI realization:** map nodes to a Transform/RectTransform hierarchy such as `Canvas -> SafeAreaRoot -> ScreenRoot -> RegionRoot -> ReusableGroup -> RuntimeLeaf`, then assign anchors, layout components, and prefab roots.
- **UI Toolkit realization:** map nodes to the visual tree, use UXML templates or `VisualTreeAsset` for reusable structure, assign flex/style owners through containers and USS classes, and name an optional behavior owner only where runtime behavior needs one.

Tree plan schema:

- `node_path`: stable path from the screen root, such as `ScreenRoot/HUDRoot/TopRightCluster/CurrencyChip`
- role: shell, safe-area owner, region, scroll owner, overlay, reusable group, runtime leaf, or decorative image
- `parent_owner`: the parent that controls position, scaling, spacing, clipping, or safe area
- `node_kind`: structural container, reusable unit, runtime leaf, or decorative image
- `placement_intent`: edge-owned, stretch, centered, fixed overlay, scroll content, or parent-flow child
- `layout_owner`: the parent or named controller that owns layout; stack-specific components or USS classes belong in `stack_realization`
- geometry ratios: approximate normalized bounds for parent-owned regions before child offsets
- `split_keep_reason`: split/keep rationale such as runtime behavior, dynamic data, state, animation, reuse, baked art, or decoration

### 2. Run a Candidate item ledger pass

Use this pass when raster-only mockups need semi-automated item analysis, but treat the output as an advisory candidate set rather than final hierarchy or final crop data.

If a structured export such as Figma node-tree JSON or Stitch HTML/CSS exists, do not use raster candidates to replace export hierarchy. Use the structured export for hierarchy and use the raster candidate ledger only to catch missing overlays, visible baked art, or composition mismatches.

Candidate ledger schema:

- candidate id: stable temporary id such as `candidate/InventorySlot/Icon01`
- source bounds: estimated `x`, `y`, `width`, and `height` in the mockup image coordinate space
- confidence band: `low`, `medium`, or `high`, based on visible evidence rather than a numeric guarantee
- evidence: containment, repeated shape, shared baseline, icon/text cluster, contrast boundary, shadow/panel boundary, or user-supplied hint
- suggested role: runtime leaf, repeated item unit, decorative image, panel/frame, icon, text-adjacent asset, or hold-for-review
- parent hint: likely parent region or repeated group from the layer tree
- crop padding: transparent or visual padding that appears part of the intended item bounds
- 9-slice candidate: whether a scalable panel/frame should become sliced art rather than a flat stretched crop
- review decision: `accept`, `hold`, or `reject`

Only accepted candidates can become item-level UI rect entries. Held candidates remain notes for manual review, and rejected candidates must not create Unity objects, crops, or prefab children.

Do not use low-confidence candidates to force a split. If the candidate cannot name a parent hint, split/keep reason, and evidence, keep it in the nearest existing visual layer.

For fixed-column planning output, copy the v2 template at `../../templates/mockup-layout-plan.yaml` and validate it with `../../tests/mockup_layout_plan_schema.sh`. Start with `layout_tree`, select the matching branch in `stack_realization`, connect accepted items to `asset_plan`, and record only known ownership in `behavior_plan`.

### 3. Run an item rect mapping pass

Use this pass only for runtime leaves, repeated item units, or static image items with an explicit reuse, import, or fit boundary after split/keep review. It is not permission to break decorative art into fake child objects.

Layer/tree ownership and split/keep reason come before item-level rects. If the parent owner or runtime reason is unclear, keep the candidate inside the nearest existing layer and do not promote it into its own rect entry yet.

For each mapped item, record:

- item id: stable name such as `InventorySlot/ItemIcon`, `RewardCard/Icon`, or `Header/CloseButton`
- node path: matching neutral path from `layout_tree`
- source rect: `x`, `y`, `width`, and `height` in the mockup image coordinate space
- normalized rect: source rect divided by the mockup width and height
- parent-local rect: the item's rect relative to the parent owner when that parent is already identified
- fit mode: stretch, fixed, preserve-aspect, sliced, layout-group child, or manual exception
- `placement_intent`: how the item should attach, flow, or grow inside its parent
- split/keep reason: runtime data, interaction, state, animation, adaptive layout, reuse, baked art, or decoration
- `asset_plan_id`: reference to the matching `asset_plan` entry for existing asset reuse, mockup-derived crop, 9-slice candidate, placeholder, or keep-whole image

Each `asset_plan` entry records `creates_runtime_node` so asset generation cannot silently imply a new layout node. Use `behavior_plan` separately for known behavior ownership; do not infer behavior from visual decomposition alone.

The source rect is measurement data, not the final authority. Convert it through normalized rects and parent-local ownership before setting Unity offsets or sizes.

Do not create item rect entries for decorative sub-parts inside a region that should stay a single image. Record the outer image region instead and keep the internal shapes baked.

### 4. Segment the image

Break the layout into:

- Root frame
- Major regions
- Repeated groups
- Runtime leaves only after runtime responsibility is proven

Do not jump directly from whole image to dozens of leaf nodes.
Group the topmost composition by anchor-owned regions first so the largest blocks already belong to stable screen relationships.
Split only when runtime behavior requires it, and keep likely decorative baked regions whole.

### 5. Estimate normalized geometry

For each major element, estimate:

- Left ratio: `x / screen_width`
- Top ratio: `y / screen_height`
- Width ratio: `w / screen_width`
- Height ratio: `h / screen_height`

Treat these as planning values, not necessarily as final serialized numbers.
When a mockup image exists, derive them from the mockup's own width and height before mapping them to the implementation frame.
For item-level sizing, use the item rect mapping pass instead of guessing leaf sizes from full-screen offsets.

### 6. Pick anchor strategy by region

Use these defaults:

- Top bar or top-left HUD: top anchors
- Bottom HUD or action bar: bottom anchors
- Side panel: left or right stretch against its screen edge
- Center dialog: centered anchors with stable width/height constraints
- Full content body: stretch anchors inside a bounded parent

Anchor according to the element's relationship to the screen, not according to whichever raw coordinates are easiest to enter.

### 7. Build parent containers first

Create the parent zones before children:

- Safe area root
- Header/footer/sidebar/content containers
- Nested rows, columns, or grids

Once the parent is right, many child values become smaller and more stable.
If the same structure appears multiple times, make one reusable prefab or reusable block before placing all copies.

### 8. Respect single-image regions

If a visual area appears to be one baked image or sprite:

- Keep it as a single image resource unless there is clear evidence that parts must resize, animate, or respond independently.
- Do not force decorative shapes into separate widgets just to trace the mockup more literally.
- Only split the image when interaction, dynamic text, or adaptive layout requires it.

### 9. Convert proportions into concrete values

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
- Did the layer pass produce a clear parent-owned neutral layout tree before object creation?
- Does the final UGUI or UI Toolkit realization match that approved tree and its chosen `stack_realization` branch?
- If a candidate item ledger was used, were accepted candidates reviewed before item-level UI rects or crop plans were created?
- Did any split runtime or repeated item have an item-level UI rect plan with source rect, normalized rect, parent-local rect or fit mode, and asset/crop plan?
- If the mockup had a native resolution, was that resolution captured and used correctly as the planning frame?
- Are the top-level regions grouped by stable anchor ownership before child tuning?
- Are anchors consistent with the element's visual role?
- Were repeated structures converted into reusable prefabs or layout blocks where appropriate?
- If the resolution changes a little, does the UI still preserve intent?
- Was any likely single-image region over-decomposed into fake widgets without a runtime need?
- Are any values suspiciously pixel-specific where a ratio or container rule should exist?

If the answer to the last question is yes, refactor before continuing.
