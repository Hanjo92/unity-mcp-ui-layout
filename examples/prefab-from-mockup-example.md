# Prefab From Mockup Example

Use this example when a user uploads, attaches, or drops a Unity UI mockup screenshot, design image, reference image, or UI 시안 and asks to turn, convert, make, generate, or create Unity UI prefabs.

## Scenario

- A mockup screenshot or design image exists.
- The user might say "reference image", "turn this into a prefab", "시안 던져줄게", or "프리팹 만들어줘".
- The user may not name `$unity-mcp-ui-layout` explicitly.
- The goal is to create Unity UI prefabs or reusable layout blocks, not to trace every visual edge into separate objects.
- The project may already imply UGUI or UI Toolkit.

## Example Prompt

```text
I attached a mockup screenshot from the current Unity project.
Create a Unity UI prefab from this design image.
Inspect whether the project uses UGUI or UI Toolkit before creating objects.
Run a layer-to-tree pass so the visual layers become a clean Transform/RectTransform hierarchy before prefab creation.
Group the top-level screen into anchor-owned parent regions first.
Turn repeated cards, slots, buttons, or rows into reusable prefabs or reusable layout blocks.
Keep decorative baked regions as single image assets unless runtime behavior requires splitting.
Verify the created prefab instance with a screenshot.
```

```text
현재 Unity 프로젝트의 UI 시안을 첨부했어.
이 시안 이미지로 Unity UI 프리팹 만들어줘.
먼저 프로젝트가 UGUI인지 UI Toolkit인지 확인해줘.
프리팹을 만들기 전에 layer-to-tree pass를 실행해서 시각 레이어가 깔끔한 Transform/RectTransform hierarchy가 되게 해줘.
화면을 anchor 기준 부모 영역으로 나눈 다음, 반복되는 카드/슬롯/버튼/행은 재사용 가능한 프리팹이나 레이아웃 블록으로 만들어줘.
장식용으로 구워진 영역은 런타임 동작상 분리가 필요할 때만 나눠줘.
생성한 프리팹 인스턴스를 스크린샷으로 검증해줘.
```

```text
시안 던져줄게. 이 reference image를 보고 Unity UI 프리팹 만들어줘.
먼저 UGUI인지 UI Toolkit인지 확인하고, 화면을 부모 영역과 반복 프리팹 후보로 나눠줘.
장식용 이미지는 런타임 동작이 필요할 때만 분리하고, 결과는 스크린샷으로 검증해줘.
```

## Why This Works

- It gives auto-trigger wording for mockup screenshot, dropped design image, reference image, UI 시안, 시안 던져줄게, and 프리팹 생성 requests.
- It routes prefab creation through the same structure-first layout rules as screen creation.
- It prevents over-decomposition by checking runtime responsibility before splitting assets.
- It makes reusable prefab extraction explicit when the design repeats.

## Suggested References

- [image-to-layout.md](../unity-mcp-ui-layout/references/image-to-layout.md)
- [mockup-decomposition.md](../unity-mcp-ui-layout/references/mockup-decomposition.md)
- [prefab-reuse.md](../unity-mcp-ui-layout/references/prefab-reuse.md)
- [prefab-variants.md](../unity-mcp-ui-layout/references/prefab-variants.md)
- [prompt-patterns.md](../unity-mcp-ui-layout/references/prompt-patterns.md)
