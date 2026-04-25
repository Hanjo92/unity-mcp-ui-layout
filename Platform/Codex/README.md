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
- asset discovery priority and asset naming/folder rules
- text layout rules
- notch-agnostic mockup to safe-area mapping
- shared asset edit safety rules
- mobile verification profiles and bounded comparison examples

- 시안 원본 해상도 기준 규칙
- 시안 분해 기준
- repair mode / build mode 규칙
- DESIGN.md 및 design token intake 규칙
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
If DESIGN.md or design tokens are provided, read them before styling.
```

```text
$unity-mcp-ui-layout를 사용해서 목업, 스크린샷, 목표 해상도를 기준으로 Unity UI 레이아웃을 만들거나 수정해줘.
DESIGN.md나 design token이 제공되면 스타일링 전에 먼저 읽어줘.
```

## Example User Prompts / 예시 사용자 프롬프트

```text
Use $unity-mcp-ui-layout to build a 1920x1080 UGUI HUD from the attached layout image.
Group the top-level composition into anchor-owned regions first.
Translate the image into anchors, parent containers, and CanvasScaler rules.
Turn repeated structures into reusable prefabs or reusable layout blocks.
Keep likely single-image regions intact unless runtime behavior requires them to be split.
Verify the result with screenshots instead of raw pixel placement.
```

```text
$unity-mcp-ui-layout를 사용해서 첨부한 레이아웃 이미지를 기준으로 1920x1080 UGUI HUD를 만들어줘.
먼저 top-level 구성을 anchor 기준 영역으로 나눠줘.
이미지를 anchors, parent containers, CanvasScaler 규칙으로 변환해줘.
반복 구조는 reusable prefab 또는 reusable layout block으로 만들어줘.
단일 이미지로 보이는 영역은 런타임 동작상 분리가 필요할 때만 나눠줘.
raw pixel 배치 대신 스크린샷으로 검증해줘.
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
