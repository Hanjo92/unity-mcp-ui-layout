# Unity MCP UI Layout for Claude Artifacts

Use this as the base instruction when Claude is helping design, build, or repair Unity UI from mockups, screenshots, wireframes, or target resolutions.

## Shared Execution Contract

Follow [execution-contract.md](../../unity-mcp-ui-layout/references/execution-contract.md) and [review-gates-and-assumptions.md](../../unity-mcp-ui-layout/references/review-gates-and-assumptions.md) for the same routing, review, coordinate, and completion decisions on every platform. Approval means recorded review under that policy; require a human only for an explicit human gate or an unresolved scope-changing blocker. Preserve prior authorization. Use the packaged template and validator; a successful plan check is not Unity execution evidence. Report missing runtime verification as `implemented_unverified`, never complete. When distributing this prompt, include those references and the skill's templates/scripts; do not rely on inaccessible links.

## Artifact Goal

Produce Unity UI that matches the intended composition while staying robust under real screen scaling. Treat the artifact as a neutral layer-to-layout tree and verification plan before creating stack-specific assets.

## Target Selection and Evidence

- Selection precedence: explicit user instruction > selected/named target > existing screen ownership > project conventions/assets > clarify when mixed.
- Record `target_surface` as `runtime` or `editor` from the request and project evidence before realization.
- Record the Unity version from project files or the running Editor.
- Check version-sensitive UI Toolkit data binding and API behavior against that Unity version before recommending implementation details.
- Use [`ui-stack-selection.md`](../../unity-mcp-ui-layout/references/ui-stack-selection.md), [`mockup-layout-plan.yaml`](../../templates/mockup-layout-plan.yaml), [`ui-toolkit-build-workflow.md`](../../unity-mcp-ui-layout/references/ui-toolkit-build-workflow.md), and [`ui-toolkit-from-mockup-example.md`](../../examples/ui-toolkit-from-mockup-example.md) as the executable discovery path.

## 대상 선택과 근거

- 선택 우선순위는 명시적 사용자 지시 > 선택되었거나 이름이 지정된 target > 기존 screen ownership > project convention/assets > 근거가 섞이면 질문 순서입니다.
- realization 전에 요청과 프로젝트 근거로 `target_surface`를 `runtime` 또는 `editor`로 기록합니다.
- project file 또는 실행 중인 Editor에서 Unity version을 확인합니다.
- 구현 세부 사항을 제안하기 전에 해당 Unity version에서 version-sensitive UI Toolkit data binding과 API 동작을 확인합니다.

## How to Work

- Inspect the selected target, owning screen, and existing reusable assets before changing them.
- Build the interface in bounded slices, not in one shot.
- Use screenshots to verify every structural step.
- If the user provides an image, treat it as a proportional composition guide rather than a raw pixel map.
- Establish top-level region ownership and parent relationships before leaf-level tuning.
- If raster item detection is used, keep candidates in a candidate item ledger until accept/hold/reject review is complete.
- For split runtime or repeated items, record item-level UI rects after parent ownership and split/keep reason are clear.
- Express repeated structures with the selected stack's reusable mechanism.
- Keep likely single-image regions intact unless interaction, animation, or adaptive behavior requires them to be split.
- Treat text as a layout driver and decide wrapping, truncation, or container growth before shrinking fonts.
- Keep hierarchy-source inputs separate from `DESIGN.md`, design tokens, and other style sources.
- Do not attempt direct Stitch or Figma API integration unless explicitly requested.
- Before editing a shared asset directly, decide whether the change belongs to its shared contract or should stay local.

## Planning and Image Resources

- Follow [ui-planning-workflow.md](../../unity-mcp-ui-layout/references/ui-planning-workflow.md) for new screens or redesigns: inspect, ask sequential questions about material open choices, propose composition and structure, resolve assets, then implement the agreed slices. Honor prior answers and explicit delegation; small repairs do not need a new brainstorming cycle.
- With a mockup, inspect and reuse suitable project images. Missing indexes require direct discovery; they do not select layout-only mode. An explicit layout-only request takes precedence.
- Only when the agent has an available image-generation skill and a usable execution path, ask about temporary generation for missing roles if undecided and generate agreed images. Without that skill, skip both generation questions and generation even if a standalone image tool exists. Follow [image-asset-workflow.md](../../unity-mcp-ui-layout/references/image-asset-workflow.md) to generate, inspect, import, apply, and verify agreed images. Preserve UGUI or UI Toolkit ownership and temporary/final status.
- While a required design answer is pending, continue inspection and proposals or independent agreed work; do not create the unconfirmed screen. If generation or Unity tools are unavailable, report the corresponding unfinished image or application scope.

## Delegated Execution

- Before subagent/orchestrated dispatch, apply [agent-capability-routing.md](../../unity-mcp-ui-layout/references/agent-capability-routing.md). Verify each session's actual vision/image delivery, generation skill/tools, artifact access, and Unity connection; parent capabilities and provider/model names do not qualify a worker.
- Give text-only workers approved structured plans, source-linked measurements, and bounded file ownership. Keep raster interpretation, asset matching, and final image comparison with a verified visual owner; capturing or reading a screenshot file is insufficient.
- Generation belongs to a verified executor with its own skill and usable tools. A coordinator may relay that executor's generation question; it cannot supply a parent's skill to qualify a tool-only child. Keep generation and visual review separate when the invoked skill permits it.
- Transfer actual input/output revisions, serialize shared-target writes, and collect attributed technical and visual evidence. Missing vision or tools leaves the dependent role/check pending; do not report a worker's code/capture success as whole-task visual completion.

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

## What the Artifact Should Emphasize

- target and `target_surface` evidence
- top-level region and parent ownership
- stack-native layout and scaling intent
- candidate item ledger for semi-automated raster detections when relevant
- item-level UI rect plan for split runtime/repeated items when relevant
- text role and overflow behavior when relevant
- design-system token and prose intent when provided
- the reusable mechanism selected for repeated structures
- what changed in the current step and what should be verified next

## UGUI Priorities

- Decide `CanvasScaler` before final sizing.
- Use the target resolution as the reference frame when appropriate.
- Build parent containers before leaf widgets and choose anchors before local offsets.
- Prefer layout groups for repeated siblings and prefabs for repeated UGUI structures.
- Keep popup `Dimmer` and `PopupRoot` as siblings under `ModalLayer`; apply safe-area handling to `PopupRoot`.
- Explain whether each text role wraps, truncates, stays single-line, or grows its container.
- Do not over-decompose likely single-image assets.

## UI Toolkit Priorities

- Build the visual tree with UXML and reusable `VisualTreeAsset` templates.
- Put layout and visual rules in USS classes instead of many inline overrides.
- Use flex relationships before hard dimensions and centralize spacing in parent containers.
- Keep editor artifacts host-free; add a UIDocument host only when runtime scene delivery needs it.
- Verify version-sensitive data binding against the recorded Unity version when binding is used.

## Recommended Artifact Flow

For each iteration:

1. State the selected target, `target_surface`, stack evidence, and Unity version.
2. Summarize the intended neutral structure in plain language.
3. Name the specific region or feature block being changed.
4. Make one bounded change through the selected stack branch.
5. Capture or request screenshot verification.
6. Evaluate scaling, clipping, overlap, and safe-area behavior.
7. Continue only after the current slice is visually stable.

## Writing Style

- Explain layout intent in terms of regions, parent ownership, scaling, stack-native layout, and reuse.
- Be explicit about tradeoffs when a design seems too dependent on exact pixels.
- When a popup or mobile layout is involved, call out safe-area ownership directly.
- When a design-system source is provided, call out how styling traces back to it.
- When multiple source types are used, state whether each is a hierarchy source or style source.
- When a shared asset might be edited, call out the safety decision directly.
- Prefer clear artifact sections such as `Plan`, `Current Change`, `Verification`, and `Next Step`.
