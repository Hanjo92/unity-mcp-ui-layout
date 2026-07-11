# Codex Adapter

Codex is the default platform for this repository.

Codex는 이 저장소의 기본 플랫폼입니다.

## Canonical Skill / 정본 스킬

Use the root skill folder directly:

루트 스킬 폴더를 그대로 사용합니다.

- [`unity-mcp-ui-layout/`](../../unity-mcp-ui-layout)

## What Changed In Recent Versions / 최근 버전 주요 보강

- mockup-native resolution guidance
- mockup decomposition rules
- repair mode versus build mode rules
- DESIGN.md and design-token intake rules
- Stitch HTML/CSS and Figma node-tree export to UGUI hierarchy rules
- asset discovery priority and asset naming/folder rules
- text layout rules
- notch-agnostic mockup to safe-area mapping
- shared asset edit safety rules
- mobile verification profiles and bounded comparison examples

- 시안 원본 해상도 기준 규칙
- 시안 분해 기준
- repair mode / build mode 규칙
- DESIGN.md 및 design token intake 규칙
- Stitch HTML/CSS 및 Figma node-tree export를 UGUI hierarchy로 옮기는 규칙
- 자산 탐색 우선순위와 자산 네이밍/폴더 규칙
- 텍스트 레이아웃 규칙
- 노치 없는 시안을 safe area 레이아웃으로 재해석하는 규칙
- 공용 자산 직접 수정 안전 규칙
- 모바일 검증 프로필과 범위 제한 비교 예시

## Install / 설치

### Windows

```powershell
Copy-Item -Recurse -Force .\unity-mcp-ui-layout $HOME\.codex\skills\
```

### macOS / Linux

```bash
cp -R ./unity-mcp-ui-layout ~/.codex/skills/
```

## Invoke / 호출

```text
Use $unity-mcp-ui-layout to build or fix a Unity UI layout from a mockup, screenshot, or target resolution.
If Stitch HTML/CSS or Figma node-tree exports are provided, treat them as hierarchy sources.
If DESIGN.md or design tokens are provided, read them as style sources before styling.
```

```text
$unity-mcp-ui-layout를 사용해서 목업, 스크린샷, 목표 해상도를 기준으로 Unity UI 레이아웃을 만들거나 수정해줘.
Stitch HTML/CSS나 Figma node-tree export가 제공되면 hierarchy source로 다뤄줘.
DESIGN.md나 design token이 제공되면 style source로 스타일링 전에 먼저 읽어줘.
```

## Mockup Stack Routing / 목업 스택 라우팅

Choose the UI stack before realization. First select the target with [`ui-stack-selection.md`](../../unity-mcp-ui-layout/references/ui-stack-selection.md), then create and approve the neutral layer-to-layout tree in the `mockup-layout-plan/v2` artifact from [`mockup-layout-plan.yaml`](../../templates/mockup-layout-plan.yaml). Use [`ui-toolkit-build-workflow.md`](../../unity-mcp-ui-layout/references/ui-toolkit-build-workflow.md) for the selected UI Toolkit path and [`ui-toolkit-from-mockup-example.md`](../../examples/ui-toolkit-from-mockup-example.md) for the canonical mockup walkthrough. The canonical machine-readable examples are [`mockup-layout-plan-prefab-example.yaml`](../../examples/mockup-layout-plan-prefab-example.yaml) and [`mockup-layout-plan-ui-toolkit-example.yaml`](../../examples/mockup-layout-plan-ui-toolkit-example.yaml).

UGUI realization maps the neutral tree to `Transform`/`RectTransform` ownership and reusable prefab intent. UI Toolkit realization maps it to a visual tree, UXML, USS, and `VisualTreeAsset` template intent. Add a host GameObject/UIDocument only when a runtime host is needed; reusable UI intent does not require a host prefab by default.

Do not finalize until the selected stack, neutral plan, reusable structure, import/compile state, screenshot comparison, and console result are recorded. Keep completion evidence explicit for both UGUI and UI Toolkit paths.

realization 전에 UI stack을 고릅니다. 먼저 [`ui-stack-selection.md`](../../unity-mcp-ui-layout/references/ui-stack-selection.md)로 대상을 선택하고, [`templates/mockup-layout-plan.yaml`](../../templates/mockup-layout-plan.yaml)의 `mockup-layout-plan/v2` 중립 `layer-to-layout tree`를 만들고 승인합니다. 선택한 UI Toolkit 경로는 [`ui-toolkit-build-workflow.md`](../../unity-mcp-ui-layout/references/ui-toolkit-build-workflow.md)를, 정본 목업 walkthrough는 [`ui-toolkit-from-mockup-example.md`](../../examples/ui-toolkit-from-mockup-example.md)를 사용합니다. 정본 machine-readable 예시는 [`mockup-layout-plan-prefab-example.yaml`](../../examples/mockup-layout-plan-prefab-example.yaml)과 [`mockup-layout-plan-ui-toolkit-example.yaml`](../../examples/mockup-layout-plan-ui-toolkit-example.yaml)입니다.

UGUI realization은 중립 트리를 `Transform`/`RectTransform` 소유 구조와 재사용 가능한 prefab 의도로 옮깁니다. UI Toolkit realization은 visual tree, UXML, USS, `VisualTreeAsset` template 의도로 옮깁니다. runtime host가 필요할 때만 host GameObject/UIDocument를 추가하며, 재사용 UI 의도만으로 host prefab을 만들지 않습니다.

선택한 stack, 중립 계획, 재사용 구조, import/compile 상태, screenshot 비교, console 결과를 기록하기 전에는 완료하지 않습니다. UGUI와 UI Toolkit 양쪽의 completion evidence를 명시합니다.

The same trigger should apply without naming the skill explicitly when the user provides an attached UI mockup, uploaded screenshot, dropped design image, reference image, mockup screenshot, or UI 시안 and asks to turn, convert, make, generate, or create Unity UI prefabs, reusable UI blocks, or 프리팹 생성.

사용자가 첨부 UI 시안, 디자인 스크린샷, 목업, reference image를 주고 Unity UI 프리팹 생성, reusable UI block 생성, "프리팹 생성", "시안 던져줄게", 또는 "프리팹 만들어줘"를 요청하면 스킬명을 직접 쓰지 않아도 같은 트리거로 봅니다.

## Example User Prompts / 예시 사용자 프롬프트

```text
Use $unity-mcp-ui-layout to convert the attached Stitch HTML/CSS export into a UGUI screen.
Do not use direct Stitch API calls.
Treat the export as the hierarchy source: map sections, flex containers, repeated cards, scroll regions, and overlays into stable UGUI containers and reusable blocks.
Use any DESIGN.md or token file only as the style source, then verify the result with screenshots.
```

```text
Use $unity-mcp-ui-layout to convert the attached Figma node-tree JSON into a UGUI hierarchy.
Do not use direct Figma API calls.
Map frames, groups, components, instances, auto-layout, text nodes, and image nodes into parent-owned UGUI containers and reusable prefabs.
Flag missing assets, unresolved variables, or unsupported node types before finalizing.
```

```text
Use $unity-mcp-ui-layout to build a 1920x1080 UGUI HUD from the attached layout image.
Group the top-level composition into anchor-owned regions first.
Analyze the visual layers -> clean Unity Transform/RectTransform tree before creating objects.
Keep semi-automated raster detections in a candidate item ledger until accept/hold/reject review is complete.
For split runtime or repeated items, create an item-level UI rect plan from the mockup source rect before final Unity sizing.
Translate the image into anchors, parent containers, and CanvasScaler rules.
Turn repeated structures into reusable prefabs or reusable layout blocks.
Keep likely single-image regions intact unless runtime behavior requires them to be split.
Verify the result with screenshots instead of raw pixel placement.
```

```text
$unity-mcp-ui-layout를 사용해서 첨부한 레이아웃 이미지를 기준으로 1920x1080 UGUI HUD를 만들어줘.
먼저 top-level 구성을 anchor 기준 영역으로 나눠줘.
오브젝트를 만들기 전에 visual layers -> clean Unity Transform/RectTransform tree로 레이어/트리 구조를 먼저 분석해줘.
반자동 raster detection 후보는 accept/hold/reject 검토가 끝날 때까지 candidate item ledger에만 둬줘.
분리되는 runtime 또는 repeated item은 목업 source rect에서 item-level UI rect plan을 먼저 만들어줘.
이미지를 anchors, parent containers, CanvasScaler 규칙으로 변환해줘.
반복 구조는 reusable prefab 또는 reusable layout block으로 만들어줘.
단일 이미지로 보이는 영역은 런타임 동작상 분리가 필요할 때만 나눠줘.
raw pixel 배치 대신 스크린샷으로 검증해줘.
```

```text
I attached a Unity UI mockup from the current project.
Create Unity UI prefabs from this design screenshot, using UGUI unless the project already uses UI Toolkit.
Analyze visual layers into a clean Unity Transform/RectTransform tree before creating prefab assets.
Use a candidate item ledger for semi-automated raster detections and promote only accepted candidates.
Record item-level UI rects for split runtime/repeated items before final prefab sizing.
Group the screen into anchor-owned parent regions first, then make repeated blocks reusable.
```

```text
현재 Unity 프로젝트의 UI 시안을 첨부했어.
이 시안을 기준으로 프리팹 생성해줘. 프로젝트가 이미 UI Toolkit을 쓰는 경우가 아니면 UGUI로 진행해줘.
먼저 화면을 anchor 기준 부모 영역으로 나누고, 반복 블록은 재사용 가능한 프리팹이나 레이아웃 블록으로 만들어줘.
```

```text
목업 스크린샷 보고 Unity UI 프리팹 만들어줘.
현재 프로젝트에 맞춰 기존 UI 스택을 확인하고, 반복되는 부분은 하나의 재사용 가능한 프리팹으로 뽑아줘.
```

```text
시안 던져줄게. 이 reference image를 보고 Unity UI 프리팹 만들어줘.
스크린샷을 그대로 픽셀 복사하지 말고 부모 영역, 앵커, 반복 프리팹 단위부터 잡아줘.
```

```text
Use $unity-mcp-ui-layout to repair the current inventory layout.
Keep it in UGUI, preserve the existing visual style, and fix slot spacing, anchors, and scaling drift.
Keep repeated slot structures reusable instead of rebuilding them one by one.
Check the result at 1920x1080 and one narrower aspect ratio.
```

```text
$unity-mcp-ui-layout를 사용해서 현재 인벤토리 레이아웃을 수정해줘.
UGUI는 유지하고 기존 시각 스타일을 보존한 채 슬롯 간격, 앵커, 스케일링 드리프트를 고쳐줘.
반복 슬롯 구조는 하나씩 다시 만들지 말고 재사용 가능한 구조로 유지해줘.
1920x1080과 더 좁은 비율 한 가지에서 결과를 확인해줘.
```

```text
Use $unity-mcp-ui-layout to create a mobile settings popup in UGUI.
Keep Dimmer and PopupRoot as siblings under ModalLayer, and apply safe area to PopupRoot.
Group the top-level popup layout before tuning child offsets, and keep decorative framing as a single image when appropriate.
Verify portrait and landscape before finalizing.
```

```text
$unity-mcp-ui-layout를 사용해서 UGUI 모바일 설정 팝업을 만들어줘.
Dimmer와 PopupRoot는 ModalLayer 아래 형제로 두고, safe area는 PopupRoot에 적용해줘.
child offset을 만지기 전에 top-level popup 구성을 먼저 잡고, 장식 프레임은 적절하면 단일 이미지로 유지해줘.
마무리 전에 portrait와 landscape를 검증해줘.
```
