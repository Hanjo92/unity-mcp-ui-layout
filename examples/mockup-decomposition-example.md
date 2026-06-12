# Mockup Decomposition Example

Use this example when a mockup exists and the main risk is splitting visual regions too much, not splitting runtime-owned parts enough, or creating a Unity Transform tree that does not reflect the design layers.

## Scenario

- A mockup image exists.
- The UI may contain baked decorative art, repeated cards or rows, and interactive widgets.
- The task needs a decomposition decision and Transform tree plan before layout tuning or pixel matching.

## Example Prompt

```text
Use $unity-mcp-ui-layout to build this UI from the attached mockup.
Before creating objects, inspect the mockup and write a layer-to-tree pass:
- top-level anchor-owned regions
- repeated groups that should become reusable blocks or prefabs
- runtime-owned widgets that need interaction, dynamic text, state, animation, safe-area behavior, or adaptive layout
- decorative or baked regions that should stay as one image or sprite region
- a Transform tree plan, such as Canvas -> SafeAreaRoot -> ScreenRoot -> RegionRoot -> ReusableGroup -> RuntimeLeaf
- an item rect plan for each split runtime or repeated item, including source rect, normalized rect, parent-local rect or fit mode, and asset/crop plan

Decompose by runtime responsibility, not by visual outline alone.
Keep decorative panels, ornaments, and baked art whole unless runtime behavior requires separation.
Do not trace every visible seam into a child object.
Turn repeated cards, rows, slots, button groups, or badge clusters into one reusable pattern before placing copies.
After the decomposition pass, build parent containers before leaf widgets and keep likely single-image regions simple.
Verify that every split has a runtime reason and that no repeated block was rebuilt manually.
```

```text
첨부한 UI 시안을 먼저 레이어/트리 구조로 분석해줘.
시각 레이어를 background, safe-area owner, major regions, reusable groups, runtime leaves, decorative image layers로 나누고,
각 레이어가 Unity RectTransform tree에서 어떤 부모/자식 관계가 되는지 제안한 뒤 오브젝트를 만들어줘.
분리되는 runtime/repeated item마다 source rect와 normalized rect를 기록하고, Unity에서 어떤 parent-local rect 또는 fit mode로 맞출지도 같이 제안해줘.
```

## Why This Works

- It makes asset granularity a deliberate decision before layout work starts.
- It forces a Transform tree plan before object creation.
- It makes split item sizing explicit through source rect and normalized rect evidence.
- It prevents fake child objects that only mirror visual edges in the mockup.
- It keeps interactive, stateful, and adaptive parts separate from baked art.
- It promotes repeated structures into reusable blocks instead of one-off copies.

## Decision Checklist

- Can each split be justified by interaction, dynamic data, state, animation, safe-area behavior, or adaptive layout?
- Did decorative panels, ornaments, and baked art stay whole where possible?
- Are repeated cards, rows, slots, button groups, or badge clusters represented by one reusable pattern?
- Are top-level regions grouped before atomic widgets are tuned?
- Does the layer-to-tree pass produce a readable parent-owned Unity Transform tree?
- Does each split runtime/repeated item have an item rect plan with source rect, normalized rect, and asset/crop plan?
- 레이어/트리 구조가 부모 소유권, 반복 그룹, 런타임 leaf를 구분하는가?
- Would another engineer understand why each region exists at runtime?

## Suggested References

- [mockup-decomposition.md](../unity-mcp-ui-layout/references/mockup-decomposition.md)
- [image-to-layout.md](../unity-mcp-ui-layout/references/image-to-layout.md)
- [mockup-resolution.md](../unity-mcp-ui-layout/references/mockup-resolution.md)
- [prompt-patterns.md](../unity-mcp-ui-layout/references/prompt-patterns.md)
