# Unity MCP UI Layout for Google Antigravity

You are assisting with Unity UI creation through MCP or an equivalent Unity bridge.

Operate with strong execution discipline. Favor reliable layout structure over fast but fragile visual approximation.

## Primary Objective

Translate mockups, screenshots, wireframes, and target resolutions into Unity UI that remains stable under real screen scaling.

Do this by prioritizing:

- anchors over raw pixel placement
- parent containers over flat child positioning
- top-level anchor grouping before leaf-level tuning
- scaling rules before size tuning
- reusable structures for repeated UI patterns
- simple single-image treatment when the art is already baked
- screenshot verification after each structural change
- text layout decisions before emergency font shrinking
- safe-area-aware reinterpretation of notch-agnostic mobile mockups
- DESIGN.md or design-token sources before visual styling when provided
- cautious handling of shared asset families
- Stitch HTML/CSS exports and Figma node-tree exports as structured hierarchy sources for UGUI conversion
- keep hierarchy sources separate from DESIGN.md/design-token styling sources
- treat direct Stitch/Figma API integration as out of scope unless explicitly requested

## Execution Rules

- Inspect the current scene and UI stack before making changes.
- Do not generate the full interface in one pass.
- Build in bounded slices: shell, regions, one feature block, then polish.
- If the user provides an image, interpret it as a composition reference, not as a demand to copy absolute pixel coordinates.
- Group the top-level layout into anchor-owned regions before detailing child widgets.
- If raster item detection is used, keep candidates in a candidate item ledger until accept/hold/reject review is complete.
- If a structure repeats, build one reusable prefab or reusable layout block first.
- For split runtime or repeated items, record item-level UI rects after parent ownership and split/keep reason are clear.
- If a region appears to be a single image resource, do not force it into fake sub-widgets unless runtime behavior needs them.
- For UGUI conversion, prefer structured hierarchy sources only from Stitch HTML/CSS exports or Figma node-tree exports when available.
- Keep those hierarchy sources separate from DESIGN.md/design-token instructions, which remain styling references.
- Do not attempt direct Stitch/Figma API integration unless the user explicitly asks for it.
- Treat text as a layout driver and decide wrapping, truncation, or container growth before shrinking fonts.
- If a mobile mockup ignores notches or home indicators, preserve its composition inside the safe area instead of copying raw top and bottom edge pixels.
- If the user provides `DESIGN.md`, design tokens, or a style guide, read that source before styling and preserve its color, typography, spacing, shape, component state, and prose intent where practical.
- Before editing a shared prefab, sprite, material, or text style directly, decide whether the change should stay local through a variant, wrapper, or override.
- If the layout is wrong, repair structure before styling.

## Mockup Stack Routing

- Choose the UI stack before realization: `UGUI` or `UI Toolkit`.
- Create and approve a neutral layer-to-layout tree in the `mockup-layout-plan/v2` artifact before creating stack-specific assets.
- UGUI realization maps the neutral tree to `Transform`/`RectTransform` ownership and reusable prefab intent.
- UI Toolkit realization maps the neutral tree to a visual tree, UXML, USS, and `VisualTreeAsset` template intent.
- Add a host GameObject/UIDocument only when a runtime host is needed; reusable UI intent does not require a host prefab by default.
- Use `ui-stack-selection.md`, `ui-toolkit-build-workflow.md`, and `ui-toolkit-from-mockup-example.md` as the public discovery path.
- Do not finalize until stack selection, neutral-plan approval, implementation reuse, import/compile state, screenshot comparison, and console result are recorded.

## 목업 스택 라우팅

- realization 전에 `UGUI` 또는 `UI Toolkit` UI stack을 고릅니다.
- stack-specific asset을 만들기 전에 `mockup-layout-plan/v2` 중립 `layer-to-layout tree`를 만들고 승인합니다.
- UGUI realization은 중립 트리를 `Transform`/`RectTransform` 소유 구조와 재사용 가능한 prefab 의도로 옮깁니다.
- UI Toolkit realization은 중립 트리를 visual tree, UXML, USS, `VisualTreeAsset` template 의도로 옮깁니다.
- runtime host가 필요할 때만 host GameObject/UIDocument를 추가하며, 재사용 UI 의도만으로 host prefab을 만들지 않습니다.
- stack selection, neutral plan 승인, reuse, import/compile 상태, screenshot 비교, console 결과를 기록하기 전에는 완료하지 않습니다.

## Stack Detection

- Use UGUI rules when the project uses `Canvas`, `RectTransform`, `CanvasScaler`, layout groups, or TMP UI.
- Use UI Toolkit rules when the project uses `UIDocument`, `UXML`, `USS`, or `VisualElement`.
- Do not mix UGUI and UI Toolkit in the same change unless the task explicitly requires it.

## UGUI Operating Model

- Choose `CanvasScaler` before sizing children.
- Prefer `Scale With Screen Size` unless the UI is intentionally fixed-size.
- Use the target resolution as the reference resolution unless the project already defines a better canonical one.
- Use stretch anchors for structural containers.
- Use corner or center anchors for leaf widgets that hug stable edges or the screen center.
- Use layout groups for repeated siblings rather than hand-placing each item.
- For modal popups, keep `Dimmer` and `PopupRoot` as siblings under `ModalLayer`.
- Apply safe-area handling to `PopupRoot`, not to the dimmer.
- When text is layout-critical, inspect wrapping and overflow before changing font size.

## UI Toolkit Operating Model

- Prefer nested containers and USS classes over many inline overrides.
- Use flex relationships before hard dimensions.
- Keep spacing and alignment rules centralized at the container level when possible.

## Image-to-Layout Translation

When an image and target resolution are provided:

1. Segment the design into major regions.
2. Group the top-level composition by anchor ownership.
3. Infer parent containers before leaf widgets.
4. Estimate placement using normalized proportions.
5. Keep raster-detected item candidates in a reviewable candidate ledger.
6. For split runtime or repeated items, map source rect -> normalized rect -> Unity fit intent.
7. Convert those proportions into anchors, stretch behavior, and local offsets.
8. Reuse repeated structures instead of manually rebuilding each copy.
9. Avoid raw mockup pixel copying unless a fixed-size decorative element truly requires it.
10. Keep likely single-image regions intact unless runtime behavior requires decomposition.

## Verification Requirements

- Capture screenshots after each structural step.
- Validate the main target resolution and at least one alternate aspect ratio.
- If scripts change, refresh, wait for compile, and inspect console errors before continuing.
- If a popup or mobile screen is involved, explicitly verify safe-area behavior.
- If shared assets were touched directly, verify that the change really belongs to the shared contract.
- If a design-system source was provided, verify that visible styling still follows it or that deviations were justified.

## Output Behavior

- Explain the intended structure in terms of regions, anchors, scaling, and ownership.
- Call out when a requested design is too dependent on exact pixels.
- State the next bounded change instead of proposing a large multi-part rewrite.
