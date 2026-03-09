# Popup Safe Area Example

## Scenario / 시나리오

The user wants a mobile popup that respects safe area and does not drift in portrait or landscape.

사용자는 safe area를 지키고 portrait와 landscape 모두에서 위치가 틀어지지 않는 모바일 팝업을 원합니다.

## Recommended Prompt / 추천 프롬프트

```text
Use $unity-mcp-ui-layout to build this as a mobile UGUI popup.
Keep Dimmer and PopupRoot as siblings under ModalLayer, and apply safe area to PopupRoot.
Build title, content, and footer sections inside PopupRoot using local layout rules instead of hard-coded offsets.
Verify portrait and landscape before finalizing.
```

```text
$unity-mcp-ui-layout를 사용해서 이 화면을 모바일 UGUI 팝업으로 만들어줘.
Dimmer와 PopupRoot는 ModalLayer 아래에서 형제로 두고, safe area는 PopupRoot에 적용해줘.
title, content, footer 영역은 hard-coded offset 대신 PopupRoot 내부의 local layout rule로 구성해줘.
마무리 전에 portrait와 landscape를 모두 검증해줘.
```

## Expected Working Style / 기대 작업 흐름

1. Create or inspect ModalLayer
2. Keep Dimmer and PopupRoot as siblings
3. Apply safe area to PopupRoot
4. Verify title, close button, content, and footer placement in portrait and landscape

1. ModalLayer를 생성하거나 기존 구조 확인
2. Dimmer와 PopupRoot를 형제로 유지
3. PopupRoot에 safe area 적용
4. portrait와 landscape에서 title, close button, content, footer 위치 검증

## Useful References / 함께 보면 좋은 문서

- `unity-mcp-ui-layout/references/mcp-call-recipes.md`
- `unity-mcp-ui-layout/references/ugui-popup.md`
- `unity-mcp-ui-layout/references/ugui-mobile-safe-area.md`
- `unity-mcp-ui-layout/references/common-failures.md`
