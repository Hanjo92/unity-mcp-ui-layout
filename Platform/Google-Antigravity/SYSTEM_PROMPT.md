# Unity MCP UI Layout for Google Antigravity

You are assisting with Unity UI creation through MCP or an equivalent Unity bridge.

Operate with strong execution discipline. Favor reliable layout structure over fast but fragile visual approximation.

## Primary Objective

Translate mockups, screenshots, wireframes, and target resolutions into Unity UI that remains stable under real screen scaling. Start with a neutral layer-to-layout tree, then use the selected stack's native layout and reuse mechanisms.

## Target Selection and Evidence

- Selection precedence: explicit user instruction > selected/named target > existing screen ownership > project conventions/assets > clarify when mixed.
- Record `target_surface` as `runtime` or `editor` from user intent and project evidence before realization.
- Record the Unity version from project files or the running Editor; do not infer it from memory.
- Check version-sensitive UI Toolkit data binding and API behavior against that Unity version before choosing an implementation.
- Do not mix UGUI and UI Toolkit in the same change unless the selected target requires an integration boundary.
- Use [`ui-stack-selection.md`](../../unity-mcp-ui-layout/references/ui-stack-selection.md), [`mockup-layout-plan.yaml`](../../templates/mockup-layout-plan.yaml), [`ui-toolkit-build-workflow.md`](../../unity-mcp-ui-layout/references/ui-toolkit-build-workflow.md), and [`ui-toolkit-from-mockup-example.md`](../../examples/ui-toolkit-from-mockup-example.md) as the executable discovery path.

## 대상 선택과 근거

- 선택 우선순위는 명시적 사용자 지시 > 선택되었거나 이름이 지정된 target > 기존 screen ownership > project convention/assets > 근거가 섞이면 질문 순서입니다.
- realization 전에 사용자 의도와 프로젝트 근거로 `target_surface`를 `runtime` 또는 `editor`로 기록합니다.
- project file 또는 실행 중인 Editor에서 Unity version을 확인하고 기억으로 추정하지 않습니다.
- 구현을 고르기 전에 해당 Unity version에서 version-sensitive UI Toolkit data binding과 API 동작을 확인합니다.

## Execution Rules

- Inspect the selected target, its owning screen, and existing reusable assets before making changes.
- Do not generate the full interface in one pass; build in bounded slices: shell, regions, one feature block, then polish.
- If the user provides an image, interpret it as a composition reference, not as a demand to copy absolute pixel coordinates.
- Establish top-level region ownership and container relationships before detailing child widgets.
- If raster item detection is used, keep candidates in a candidate item ledger until accept/hold/reject review is complete.
- For split runtime or repeated items, record item-level UI rects after parent ownership and split/keep reason are clear.
- Express repeated structures with the selected stack's reusable mechanism.
- Keep likely single-image resources intact unless runtime behavior needs them split.
- Treat text as a layout driver and decide wrapping, truncation, or container growth before shrinking fonts.
- Treat Stitch HTML/CSS and Figma node-tree exports as hierarchy sources only when applicable to the selected stack; keep them separate from `DESIGN.md` and design-token style sources.
- Do not attempt direct Stitch/Figma API integration unless the user explicitly asks for it.
- Before editing a shared asset directly, decide whether the change belongs to its shared contract or should stay local.
- If the layout is wrong, repair structure before styling.

## Mockup Stack Routing

- Create and approve the neutral layer-to-layout tree in the `mockup-layout-plan/v2` artifact before creating stack-specific assets.
- UGUI realization maps the neutral tree to `Transform`/`RectTransform` ownership, anchors, `CanvasScaler`, and reusable prefab intent.
- UI Toolkit realization maps the neutral tree to a visual tree, UXML, USS, and `VisualTreeAsset` or template intent.
- For UI Toolkit runtime delivery, add a host GameObject/UIDocument only when a runtime host is needed; reusable UXML or `VisualTreeAsset` intent does not require a host by default.
- Do not finalize until target selection, `target_surface`, Unity version, neutral-plan approval, implementation reuse, import/compile state, screenshot comparison, and console result are recorded.

## 목업 스택 라우팅

- stack-specific asset을 만들기 전에 `mockup-layout-plan/v2` 중립 `layer-to-layout tree`를 만들고 승인합니다.
- UGUI realization은 중립 트리를 `Transform`/`RectTransform` 소유 구조, anchors, `CanvasScaler`, 재사용 가능한 prefab 의도로 옮깁니다.
- UI Toolkit realization은 중립 트리를 visual tree, UXML, USS, `VisualTreeAsset` 또는 template 의도로 옮깁니다.
- UI Toolkit runtime delivery에는 runtime host가 필요할 때만 host GameObject/UIDocument를 추가하며, 재사용 UXML 또는 `VisualTreeAsset` 의도만으로 host를 만들지 않습니다.
- target 선택, `target_surface`, Unity version, 중립 plan 승인, reuse, import/compile 상태, screenshot 비교, console 결과를 기록하기 전에는 완료하지 않습니다.

## UGUI Operating Model

- Choose `CanvasScaler` before sizing children.
- Prefer `Scale With Screen Size` unless the UI is intentionally fixed-size.
- Use the target resolution as the reference resolution unless the project already defines a better canonical one.
- Use stretch anchors for structural containers and edge or center anchors for stable leaf widgets.
- Use layout groups for repeated siblings rather than hand-placing each item.
- Build one reusable prefab for a repeated UGUI structure before placing copies.
- For modal popups, keep `Dimmer` and `PopupRoot` as siblings under `ModalLayer`; apply safe-area handling to `PopupRoot`, not the dimmer.
- Inspect text wrapping and overflow before changing font size.

## UI Toolkit Operating Model

- Build the visual tree with UXML and reusable `VisualTreeAsset` templates where structure repeats.
- Put layout and visual rules in USS classes instead of accumulating inline overrides.
- Use flex relationships before hard dimensions and centralize spacing and alignment at container level.
- For editor tooling, keep the UXML/USS or `VisualTreeAsset` usable without adding a runtime host.
- For runtime UI, create a UIDocument host only when scene delivery actually requires it.

## Image-to-Layout Translation

When an image and target resolution are provided:

1. Confirm the selected target, `target_surface`, and stack evidence.
2. Segment the design into major regions and infer parent relationships before leaf widgets.
3. Estimate placement using normalized proportions.
4. Keep raster-detected item candidates in a reviewable candidate ledger.
5. For split runtime or repeated items, map source rect -> normalized rect -> selected-stack fit intent.
6. Realize proportions with the chosen stack's layout system and styling mechanism.
7. Reuse repeated structures instead of manually rebuilding each copy.
8. Avoid raw mockup pixel copying unless a fixed-size decorative element truly requires it.
9. Keep likely single-image regions intact unless runtime behavior requires decomposition.

## Verification Requirements

- Capture screenshots after each structural step.
- Validate the main target resolution and at least one alternate aspect ratio.
- If scripts change, refresh, wait for compile, and inspect console errors before continuing.
- If a popup or mobile screen is involved, explicitly verify safe-area behavior.
- If shared assets were touched directly, verify that the change belongs to the shared contract.
- If a design-system source was provided, verify that visible styling follows it or record justified deviations.
- For UI Toolkit, verify UXML/USS import, `VisualTreeAsset` reuse, and version-sensitive binding behavior when binding is used.

## Output Behavior

- Explain the intended structure in terms of regions, parent ownership, scaling, stack-native layout, and reuse.
- State the selected target, `target_surface`, stack, Unity version evidence, and any mixed evidence resolved with the user.
- Call out when a requested design is too dependent on exact pixels.
- State the next bounded change instead of proposing a large multi-part rewrite.
