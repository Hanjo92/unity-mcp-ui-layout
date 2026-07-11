# Unity MCP UI Layout for Claude Artifacts

Use this as the base instruction when Claude is helping design, build, or repair Unity UI from mockups, screenshots, wireframes, or target resolutions.

## Artifact Goal

Produce Unity UI that matches the intended composition while staying robust under real screen scaling.

Treat the artifact as a structured layout plan, not just a visual guess. The artifact should help turn a reference image into stable Unity hierarchy, anchors, scaling behavior, and verification steps.

## How to Work

- Inspect the current Unity UI before changing it.
- Identify whether the task belongs to UGUI or UI Toolkit.
- Build the interface in slices, not in one shot.
- Use screenshots to verify every structural step.
- If the user provides an image, treat it as a proportional composition guide rather than a raw pixel map.
- For UGUI, treat Stitch HTML/CSS exports and Figma node-tree exports as structured hierarchy-source inputs when provided.
- Group the top-level composition by anchor-owned regions before leaf-level tuning.
- If raster item detection is used, keep candidates in a candidate item ledger until accept/hold/reject review is complete.
- For split runtime or repeated items, record item-level UI rects after parent ownership and split/keep reason are clear.
- Turn repeated structures into reusable prefabs or reusable layout blocks when appropriate.
- Keep likely single-image regions intact unless interaction, animation, or adaptive behavior requires them to be split.
- Treat text as a layout driver and decide wrapping, truncation, or container growth before shrinking fonts.
- If a mobile mockup is notch-agnostic, preserve its composition inside the safe area instead of copying raw top and bottom edge pixels.
- If the user provides `DESIGN.md`, design tokens, or a style guide, read that source before styling and preserve its color, typography, spacing, shape, component state, and prose intent where practical.
- Keep hierarchy-source inputs (Stitch/Figma exports) separate from style sources like `DESIGN.md` and token/style guides.
- Do not attempt direct Stitch or Figma API integration unless explicitly requested.
- Before editing shared prefabs, sprites, materials, or TMP styles directly, decide whether the change should stay local through a variant, wrapper, or local override.

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

## What the Artifact Should Emphasize

- parent container ownership
- top-level region grouping
- anchor and pivot intent
- `CanvasScaler` or flex behavior
- safe-area ownership when relevant
- candidate item ledger for semi-automated raster detections when relevant
- item-level UI rect plan for split runtime/repeated items when relevant
- text role and overflow behavior when relevant
- design-system token and prose intent when provided
- what was changed in the current step
- what should be verified next

## UGUI Priorities

- Decide `CanvasScaler` before final sizing.
- Use the target resolution as the reference frame when appropriate.
- Build parent containers before leaf widgets.
- Choose anchors before applying local offsets.
- Prefer layout groups for repeated siblings.
- Keep repeated UI patterns reusable instead of rebuilding them manually.
- Keep popup `Dimmer` and `PopupRoot` as siblings under `ModalLayer`.
- Apply safe-area handling to `PopupRoot`.
- When text is involved, explain whether the role should wrap, truncate, stay single-line, or grow its container.
- Do not over-decompose likely single-image assets.

## UI Toolkit Priorities

- Prefer container rules and USS classes over many inline overrides.
- Use flex relationships before hard dimensions.
- Centralize spacing and alignment in parent containers where possible.

## Recommended Artifact Flow

For each iteration:

1. Summarize the intended structure in plain language
2. Name the specific region or feature block being changed
3. Make one bounded change
4. Capture or request screenshot verification
5. Evaluate scaling, clipping, overlap, and safe-area behavior
6. Continue only after the current slice is visually stable

## Writing Style

- Explain layout intent in terms of regions, anchors, scaling, and parent ownership.
- Be explicit about tradeoffs when a design seems too dependent on exact pixels.
- When a popup or mobile layout is involved, call out safe-area ownership directly.
- When a design-system source is provided, call out how styling traces back to it.
- When multiple source types are used, state whether each came from hierarchy export or style source.
- When a shared asset might be edited, call out the safety decision directly.
- Prefer clear artifact sections such as `Plan`, `Current Change`, `Verification`, and `Next Step`.
