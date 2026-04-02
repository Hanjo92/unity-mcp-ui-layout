# Claude Artifacts Adapter

This adapter repackages the Unity MCP UI layout workflow for Claude project or artifact-oriented usage, with a stronger focus on explanation, iteration, and artifact structure.

이 어댑터는 Unity MCP UI 레이아웃 워크플로를 Claude 프로젝트 또는 artifact 중심 사용 방식에 맞게 재구성하며, 설명, 반복 개선, artifact 구조를 더 강하게 강조합니다.

## Files / 파일

- `ARTIFACT_PROMPT.md`: prompt template for Claude
- `ARTIFACT_PROMPT.md`: Claude용 프롬프트 템플릿

## Usage / 사용 방법

1. Open `ARTIFACT_PROMPT.md`
2. Paste or adapt it into your Claude project instructions or artifact workflow
3. Use it together with Unity MCP access or a similar Unity integration
4. Prefer artifact outputs that separate plan, current change, verification, and next step

1. `ARTIFACT_PROMPT.md`를 엽니다
2. Claude 프로젝트 지침이나 artifact 워크플로에 붙여넣거나 맞게 수정합니다
3. Unity MCP 또는 유사한 Unity 연동과 함께 사용합니다
4. Plan, Current Change, Verification, Next Step을 구분한 artifact 출력을 권장합니다

## Goal / 목적

Keep Claude aligned with the same layout rules as the Codex skill while taking advantage of Claude's artifact-style iterative explanation and review flow.

Claude의 artifact 스타일 반복 설명/검토 흐름을 살리면서도, Codex 스킬과 동일한 레이아웃 규칙을 따르게 합니다.

This includes the newer guidance around:

여기에는 최근 추가된 아래 가이드도 포함됩니다.

- mockup-native resolution planning
- text layout as a structural concern
- safe-area-aware reinterpretation of notch-agnostic mobile mockups
- shared asset edit safety for prefabs, sprites, materials, and TMP styles
- mobile verification profiles and bounded repair comparisons

- 시안 원본 해상도 기준 계획
- 구조 문제로서의 텍스트 레이아웃
- 노치 없는 모바일 시안을 safe-area-aware 레이아웃으로 재해석하는 규칙
- prefab, sprite, material, TMP style에 대한 공유 자산 수정 안전 규칙
- 모바일 검증 프로필과 범위 제한 비교/수정 규칙

## Example User Prompts / 예시 사용자 프롬프트

```text
Using the attached mockup, help me build a 1920x1080 Unity HUD in UGUI.
Please work in an artifact-style loop with sections for Plan, Current Change, Verification, and Next Step.
Group the top-level composition into anchor-owned regions first.
Translate the design into anchors, containers, and CanvasScaler behavior instead of raw screen pixels.
Turn repeated structures into reusable prefabs or reusable layout blocks, and keep likely single-image regions intact when appropriate.
```

```text
첨부한 목업을 바탕으로 1920x1080 UGUI HUD를 만들 수 있게 도와줘.
Plan, Current Change, Verification, Next Step 섹션이 있는 artifact-style 루프로 진행해줘.
먼저 top-level 구성을 anchor 기준 영역으로 나눠줘.
raw screen pixel 대신 anchors, containers, CanvasScaler 동작으로 설계를 변환해줘.
반복 구조는 reusable prefab 또는 reusable layout block으로 만들고, 단일 이미지로 보이는 영역은 적절하면 그대로 유지해줘.
```

```text
Review the current inventory UI and explain why it breaks at narrower widths.
Then make one bounded structural fix at a time and verify each step with screenshots.
Keep the artifact focused on parent ownership, layout groups, reusable slot structures, and scaling behavior.
```

```text
현재 인벤토리 UI를 검토하고 왜 더 좁은 폭에서 깨지는지 설명해줘.
그 다음 범위를 제한한 구조 수정 하나씩 적용하고, 각 단계마다 스크린샷으로 검증해줘.
artifact는 parent ownership, layout group, reusable slot structure, scaling 동작 중심으로 유지해줘.
```

```text
Compare the current Unity UI to the attached layout image and produce an artifact that identifies the composition mismatches.
Explain which issues come from top-level grouping, anchors, CanvasScaler, or parent structure, then apply the smallest safe correction first.
```

```text
현재 Unity UI를 첨부한 레이아웃 이미지와 비교해서 composition mismatch를 정리한 artifact를 만들어줘.
문제가 top-level grouping, anchors, CanvasScaler, parent structure 중 어디서 오는지 설명하고, 가장 작은 안전한 수정부터 적용해줘.
```
