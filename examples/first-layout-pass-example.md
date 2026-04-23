# First Layout Pass Example / 첫 레이아웃 패스 예시

Use this as the first practice task when you are new to the repository and want a small, verifiable exercise before taking on a full screen.

이 예시는 저장소를 처음 쓰는 사람이 전체 화면 제작 전에 작고 검증 가능한 연습 과제를 해보고 싶을 때 사용합니다.

## Scenario / 시나리오

You have one simple UI screen, mockup, or existing Unity scene. The goal is not final polish. The goal is to make the first stable layout pass: root structure, major regions, one repeated block if needed, and a screenshot-based verification loop.

간단한 UI 화면, 목업, 또는 기존 Unity 씬 하나가 있습니다. 목표는 최종 폴리시가 아닙니다. 목표는 첫 안정화 패스를 만드는 것입니다: 루트 구조, 주요 영역, 필요할 경우 반복 블록 하나, 그리고 스크린샷 기반 검증 루프입니다.

## Recommended Prompt / 추천 프롬프트

```text
Use $unity-mcp-ui-layout for a first layout pass on the attached mockup or current UI.
Keep this scoped as a beginner exercise, not a full visual polish pass.
Identify the active UI stack first:
- Use UGUI if the target uses Canvas, RectTransform, CanvasScaler, Image, or TextMeshProUGUI.
- Use UI Toolkit if the target uses UIDocument, UXML, USS, VisualElement, or PanelSettings.
- If both stacks appear, ask before editing.

Create or repair only the root layout shell and 3 to 5 major regions.
For UGUI, set up the CanvasScaler, SafeAreaRoot if relevant, and anchor-owned region containers before adding leaf widgets.
For UI Toolkit, set up the root container, major flex regions, and overflow behavior before styling leaf elements.
Use placeholders for art unless an existing asset is clearly intended for reuse.
Only turn a repeated row, button, or card into a reusable block if it appears at least twice.
Verify the result with one screenshot at the main target resolution and one additional aspect ratio.
Report what stayed stable, what changed, and what should be left for a later polish task.
```

```text
$unity-mcp-ui-layout를 사용해서 첨부한 목업 또는 현재 UI의 첫 레이아웃 패스를 만들어줘.
이 작업은 최종 비주얼 폴리시가 아니라 초보자용 작은 연습 과제로 범위를 제한해줘.
먼저 활성 UI 스택을 확인해줘:
- Canvas, RectTransform, CanvasScaler, Image, TextMeshProUGUI를 쓰면 UGUI로 진행해줘.
- UIDocument, UXML, USS, VisualElement, PanelSettings를 쓰면 UI Toolkit으로 진행해줘.
- 두 스택이 모두 보이면 수정 전에 물어봐줘.

루트 레이아웃 셸과 주요 영역 3~5개만 생성하거나 수정해줘.
UGUI라면 leaf widget을 추가하기 전에 CanvasScaler, 필요한 경우 SafeAreaRoot, anchor 기준 영역 컨테이너를 먼저 구성해줘.
UI Toolkit이라면 leaf element 스타일링 전에 root container, 주요 flex 영역, overflow 동작을 먼저 구성해줘.
명확히 재사용해야 할 기존 자산이 보이지 않는다면 아트는 placeholder로 둬줘.
반복되는 row, button, card가 최소 두 번 이상 나올 때만 reusable block으로 만들어줘.
메인 타깃 해상도 스크린샷 하나와 추가 aspect ratio 하나로 결과를 검증해줘.
무엇이 안정적으로 유지됐는지, 무엇이 바뀌었는지, 나중의 polish 작업으로 남길 것은 무엇인지 보고해줘.
```

## Expected Working Style / 기대 작업 흐름

1. Confirm the active UI stack and change mode.
2. Inspect the current root owner before touching child elements.
3. Create or repair the shell and 3 to 5 major regions.
4. Add only the smallest placeholder or repeated block needed to prove structure.
5. Verify the layout at the target resolution and one alternate aspect ratio.

1. 활성 UI 스택과 작업 모드를 확인합니다.
2. 자식 요소를 만지기 전에 현재 루트 소유자를 확인합니다.
3. 셸과 주요 영역 3~5개를 생성하거나 수정합니다.
4. 구조를 증명하는 데 필요한 최소 placeholder 또는 반복 블록만 추가합니다.
5. 타깃 해상도와 다른 aspect ratio 하나에서 레이아웃을 검증합니다.

## Success Signal / 완료 신호

- The root structure is understandable without inspecting every child.
- The major regions keep their intended ownership across two aspect ratios.
- Placeholder art does not force premature sprite slicing or asset creation.
- Any reusable block exists because the screen actually repeats that structure.
- The final report names the screenshot checks and the remaining polish work.

- 모든 자식 요소를 열어보지 않아도 루트 구조를 이해할 수 있습니다.
- 주요 영역이 두 가지 aspect ratio에서 의도한 소유권을 유지합니다.
- placeholder 아트가 이른 sprite 분리나 자산 생성을 강제하지 않습니다.
- reusable block은 실제 반복 구조가 있을 때만 만들어졌습니다.
- 최종 보고에 스크린샷 검증 내용과 남겨둔 폴리시 작업이 명시됩니다.

## Useful References / 함께 보면 좋은 문서

- [layout-checklist.md](../unity-mcp-ui-layout/references/layout-checklist.md)
- [ui-change-modes.md](../unity-mcp-ui-layout/references/ui-change-modes.md)
- [ugui-anchors-canvas-scaler.md](../unity-mcp-ui-layout/references/ugui-anchors-canvas-scaler.md)
- [ui-toolkit-layout-rules.md](../unity-mcp-ui-layout/references/ui-toolkit-layout-rules.md)
