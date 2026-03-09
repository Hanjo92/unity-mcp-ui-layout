# Inventory Example

## Scenario / 시나리오

The user wants to create or repair a slot-based inventory panel in UGUI without manually placing each slot.

사용자는 슬롯 기반 인벤토리 패널을 UGUI로 만들거나 수정하려고 하며, 각 슬롯을 수동으로 배치하는 방식은 피하고 싶어 합니다.

## Recommended Prompt / 추천 프롬프트

```text
Use $unity-mcp-ui-layout to build this as a UGUI inventory panel.
Create the main panel first, then split it into navigation, grid, detail panel, and bottom actions.
Use layout groups for repeated slots instead of manual placement.
Preserve the current visual style if assets already exist, and verify that the detail panel does not overlap the list at narrower widths.
```

```text
$unity-mcp-ui-layout를 사용해서 이 화면을 UGUI 인벤토리 패널로 만들어줘.
먼저 메인 패널을 만들고, 그다음 navigation, grid, detail panel, bottom actions 영역으로 나눠줘.
반복되는 슬롯은 수동 배치 대신 layout group으로 처리해줘.
이미 에셋이 있으면 현재 비주얼 스타일은 유지하고, 화면이 좁아졌을 때 detail panel이 리스트를 덮지 않는지도 검증해줘.
```

## Expected Working Style / 기대 작업 흐름

1. Create or inspect the main panel
2. Separate structural regions
3. Use layout groups for repeated slot placement
4. Verify spacing, overlap, and text behavior

1. 메인 패널을 생성하거나 기존 패널 확인
2. 구조 영역을 분리
3. 반복 슬롯은 layout group으로 배치
4. 간격, 겹침, 텍스트 동작 검증

## Useful References / 함께 보면 좋은 문서

- `unity-mcp-ui-layout/references/mcp-call-recipes.md`
- `unity-mcp-ui-layout/references/ugui-inventory.md`
- `unity-mcp-ui-layout/references/common-failures.md`
