# Google Antigravity Adapter

This adapter repackages the Unity MCP UI layout workflow as a more execution-oriented prompt package for Google Antigravity-style custom instructions or workspace guidance.

이 어댑터는 Unity MCP UI 레이아웃 워크플로를 Google Antigravity 스타일의 커스텀 지침 또는 워크스페이스 가이드에 맞는 실행 중심 프롬프트 패키지로 재구성합니다.

## Files / 파일

- `SYSTEM_PROMPT.md`: base instruction set for the assistant
- `SYSTEM_PROMPT.md`: 어시스턴트용 기본 지침 세트

## Usage / 사용 방법

1. Open `SYSTEM_PROMPT.md`
2. Paste or adapt it into your Antigravity custom instruction area
3. Use it together with Unity MCP access or an equivalent Unity bridge
4. Pair it with task prompts that include a layout image, target resolution, and the intended UI stack when known

1. `SYSTEM_PROMPT.md`를 엽니다
2. Antigravity 커스텀 지침 영역에 붙여넣거나 맞게 수정합니다
3. Unity MCP 또는 그에 준하는 Unity 브리지와 함께 사용합니다
4. 가능하면 레이아웃 이미지, 목표 해상도, UI 스택 정보를 포함한 작업 프롬프트와 함께 씁니다

## Goal / 목적

Make Antigravity follow the same rules as the Codex skill, but in a firmer system-prompt style that emphasizes execution discipline:

Codex 스킬과 같은 규칙을 따르되, 실행 규율을 더 강하게 강조하는 system-prompt 스타일로 Antigravity를 유도합니다.

- inspect first
- build in slices
- convert images into relative layout
- group the top-level layout by anchor-owned regions first
- reuse repeated structures through prefabs or reusable blocks
- keep likely single-image regions intact unless runtime behavior requires splitting
- use anchors and scaling instead of raw pixels
- verify with screenshots
- treat text as a layout driver instead of a last-minute font tweak
- remap notch-agnostic mockups into safe-area-aware layouts
- avoid risky direct edits to shared base assets for one-screen fixes

- 먼저 조사합니다
- 작은 단위로 나눠 구현합니다
- 이미지를 상대 레이아웃으로 변환합니다
- top-level 구성을 anchor 기준 영역으로 먼저 나눕니다
- 반복 구조는 prefab 또는 reusable block으로 재사용합니다
- 단일 이미지 자산으로 보이는 영역은 분해가 꼭 필요할 때만 나눕니다
- raw pixel 대신 anchors와 scaling을 사용합니다
- 스크린샷으로 검증합니다
- 텍스트를 마지막 폰트 미세조정이 아니라 레이아웃 드라이버로 다룹니다
- 노치가 반영되지 않은 시안을 safe-area-aware 레이아웃으로 재해석합니다
- 한 화면 수정 때문에 공유 base 자산을 위험하게 직접 수정하지 않습니다

## Example User Prompts / 예시 사용자 프롬프트

```text
Build this Unity HUD from the attached mockup at 1920x1080.
Treat the image as a composition reference, not a raw pixel map.
Group the top-level layout by anchor-owned regions, create parent regions first, choose anchors and CanvasScaler rules, then verify with screenshots.
Turn repeated structures into reusable prefabs or reusable layout blocks.
```

```text
첨부한 목업을 기준으로 1920x1080 Unity HUD를 만들어줘.
이미지는 raw pixel map이 아니라 composition reference로 취급해줘.
top-level 구성을 anchor 기준 영역으로 나누고, 부모 영역을 먼저 만든 뒤 anchors와 CanvasScaler 규칙을 정하고 스크린샷으로 검증해줘.
반복 구조는 reusable prefab 또는 reusable layout block으로 만들어줘.
```

```text
Repair the current UGUI inventory so that slot spacing, detail panel sizing, and scaling remain stable across resolutions.
Preserve the current style.
Keep repeated slot structures reusable instead of rebuilding them one by one.
Inspect first, make bounded changes, and verify at the target resolution and one alternate aspect ratio.
```

```text
현재 UGUI 인벤토리를 수정해서 슬롯 간격, 상세 패널 크기, 스케일링이 해상도 변화에도 안정적으로 유지되게 해줘.
현재 스타일은 보존해줘.
반복 슬롯 구조는 하나씩 다시 만들지 말고 재사용 가능한 구조로 유지해줘.
먼저 조사하고, 범위를 제한해 수정한 뒤 목표 해상도와 대체 비율 한 가지에서 검증해줘.
```

```text
Compare the current UI against the attached reference image.
Find the structural differences causing the layout drift.
Fix top-level anchor grouping, parent containers, and scaling rules before changing styling or local offsets.
Collapse over-modeled decorative regions back into a single image when they are likely one baked asset.
```

```text
현재 UI를 첨부한 기준 이미지와 비교해줘.
레이아웃 드리프트를 만드는 구조 차이를 찾아줘.
스타일이나 로컬 offset을 바꾸기 전에 top-level anchor grouping, parent container, scaling 규칙부터 고쳐줘.
장식 영역이 베이크된 단일 자산으로 보이면 과도하게 쪼갠 구성을 다시 하나의 이미지로 되돌려줘.
```
