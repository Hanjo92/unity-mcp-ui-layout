# Inventory Example

## Scenario / 시나리오

The user wants to create or repair a slot-based inventory panel in UGUI without manually placing each slot.

사용자는 슬롯 기반 인벤토리 패널을 UGUI로 만들거나 수정하려고 하며, 각 슬롯을 수동으로 배치하는 방식은 피하고 싶어 합니다.

## Recommended Prompt / 추천 프롬프트

```text
Use $unity-mcp-ui-layout to build this as a UGUI inventory panel.
Create the main panel first, then split it into navigation, grid, detail panel, and bottom actions.
Group the top-level layout by anchor-owned regions before tuning child slots.
If the list or grid needs scrolling, structure it as `ScrollRect -> Viewport -> Content` and keep the slot unit reusable as a prefab or reusable block under `Content`.
Use layout groups for repeated slots instead of manual placement.
Preserve the current visual style if assets already exist, and verify that the detail panel does not overlap the list at narrower widths.
```

```text
$unity-mcp-ui-layout를 사용해서 이 화면을 UGUI 인벤토리 패널로 만들어줘.
먼저 메인 패널을 만들고, 그다음 navigation, grid, detail panel, bottom actions 영역으로 나눠줘.
최상단 레이아웃은 먼저 anchor 기준 영역으로 그룹화해줘.
반복되는 슬롯은 수동 배치 대신 layout group으로 처리하고, 슬롯 단위는 재사용 가능한 프리팹 또는 블록으로 유지해줘.
이미 에셋이 있으면 현재 비주얼 스타일은 유지하고, 화면이 좁아졌을 때 detail panel이 리스트를 덮지 않는지도 검증해줘.
```

## Expected Working Style / 기대 작업 흐름

1. Create or inspect the main panel
2. Group top-level regions and separate structural areas
3. Use layout groups for repeated slot placement and keep slot units reusable
4. If scrolling is needed, keep only the list body scrolling and keep the repeated slot under `Content`
5. Verify spacing, overlap, and text behavior

1. 메인 패널을 생성하거나 기존 패널 확인
2. 최상단 영역을 그룹화하고 구조 영역을 분리
3. 반복 슬롯은 layout group으로 배치하고 슬롯 단위는 재사용
4. 스크롤이 필요하면 리스트 본문만 스크롤되게 하고 반복 슬롯은 `Content` 아래 유지
5. 간격, 겹침, 텍스트 동작 검증

## Useful References / 함께 보면 좋은 문서

- `unity-mcp-ui-layout/references/mcp-call-recipes.md`
- `unity-mcp-ui-layout/references/scroll-view-patterns.md`
- `unity-mcp-ui-layout/references/ugui-inventory.md`
- `unity-mcp-ui-layout/references/common-failures.md`
