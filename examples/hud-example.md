# HUD Example

## Scenario / 시나리오

The user provides a HUD mockup image and wants a `1920x1080` UGUI implementation that stays stable across aspect ratios.

사용자가 HUD 목업 이미지를 제공했고, `1920x1080` 기준의 UGUI 구현을 원합니다. 결과는 다른 화면 비율에서도 안정적으로 유지되어야 합니다.

## Recommended Prompt / 추천 프롬프트

```text
Use $unity-mcp-ui-layout to build a 1920x1080 UGUI HUD from the attached mockup.
Treat the image as a composition reference, not a raw pixel map.
Create the root canvas structure first, then SafeAreaRoot and HUDRoot, then add corner and center containers before leaf widgets.
Verify each structural step with screenshots and re-check one alternate aspect ratio before finalizing.
```

```text
$unity-mcp-ui-layout를 사용해서 첨부한 목업으로 1920x1080 UGUI HUD를 만들어줘.
이미지는 raw pixel map이 아니라 composition reference로 취급해줘.
먼저 root canvas 구조를 만들고, 그다음 SafeAreaRoot와 HUDRoot를 만든 뒤, leaf widget보다 corner와 center container를 먼저 추가해줘.
각 구조 변경 단계마다 스크린샷으로 검증하고, 마무리 전에 다른 aspect ratio 한 가지도 다시 확인해줘.
```

## Expected Working Style / 기대 작업 흐름

1. Inspect current scene and UI roots
2. Build shell and major regions
3. Add one HUD cluster at a time
4. Verify after each slice

1. 현재 씬과 UI 루트를 확인
2. 화면 셸과 주요 영역 구성
3. HUD 클러스터를 하나씩 추가
4. 각 단계마다 검증

## Useful References / 함께 보면 좋은 문서

- `unity-mcp-ui-layout/references/mcp-call-recipes.md`
- `unity-mcp-ui-layout/references/ugui-hud.md`
- `unity-mcp-ui-layout/references/common-failures.md`
