# Platform Adapters

This folder contains platform-specific packaging for the same Unity MCP UI layout workflow.

이 폴더는 같은 Unity MCP UI 레이아웃 워크플로를 플랫폼별로 맞춘 패키지를 담고 있습니다.

## Default / 기본값

- `Codex` is the default platform and the canonical implementation is the root skill folder:
  - [`unity-mcp-ui-layout/`](../unity-mcp-ui-layout)
- 기본 플랫폼은 `Codex`이며, 정본 구현은 루트 스킬 폴더입니다:
  - [`unity-mcp-ui-layout/`](../unity-mcp-ui-layout)

## Included Adapters / 포함된 어댑터

- [`Codex/`](./Codex)
- [`Google-Antigravity/`](./Google-Antigravity)
- [`Claude-Artifacts/`](./Claude-Artifacts)

## Intent / 목적

Each adapter keeps the same core rules:

각 어댑터는 아래 코어 규칙을 유지합니다.

- prefer anchors and containers over raw pixels
- group the top-level composition by anchor-owned regions before leaf-level tuning
- analyze mockups into a neutral layer-to-layout tree before stack-specific realization
- UGUI realization maps the tree to `Transform/RectTransform` ownership and reusable prefab intent
- UI Toolkit realization maps the tree to a visual tree, UXML, USS, and VisualTreeAsset template intent
- add a host GameObject/UIDocument only when runtime host is needed; reusable UI intent does not require a host prefab by default
- keep semi-automated raster detections in a candidate item ledger until reviewed
- record item-level UI rects for split runtime/repeated mockup items before final size tuning
- choose scaling rules before sizing children
- reuse repeated structures through prefabs or reusable blocks where appropriate
- treat Stitch HTML/CSS and Figma node-tree exports as hierarchy sources when provided
- keep hierarchy sources separate from DESIGN.md or design-token style sources
- keep likely single-image assets simple unless runtime behavior requires decomposition
- verify with screenshots
- treat popups and safe area carefully
- iterate in small slices instead of one-shot UI generation

- raw pixel보다 anchors와 containers를 우선합니다
- leaf-level 조정보다 먼저 top-level 구성을 anchor 기준 영역으로 나눕니다
- 목업이나 UI 시안은 스택별 realization 전에 중립 layer-to-layout tree로 먼저 분석합니다
- UGUI realization은 이 트리를 `Transform/RectTransform` 소유 구조와 재사용 가능한 prefab 의도로 옮깁니다
- UI Toolkit realization은 이 트리를 visual tree, UXML, USS, VisualTreeAsset template 의도로 옮깁니다
- runtime host가 필요할 때만 host GameObject/UIDocument를 추가하며, 재사용 UI 의도만으로 host prefab을 만들지 않습니다
- 반자동 raster detection 후보는 검토 전까지 candidate item ledger에만 둡니다
- 목업에서 분리되는 runtime/repeated item은 최종 크기 조정 전에 item-level UI rect를 기록합니다
- 자식 크기를 만지기 전에 scaling 규칙을 먼저 정합니다
- 반복 구조는 상황에 맞게 prefab 또는 reusable block으로 재사용합니다
- Stitch HTML/CSS와 Figma node-tree export가 제공되면 hierarchy source로 다룹니다
- hierarchy source와 DESIGN.md 또는 design token 기반 style source를 구분합니다
- 단일 이미지 자산으로 보이는 영역은 런타임 동작상 분해가 필요할 때만 나눕니다
- 스크린샷으로 검증합니다
- popup과 safe area를 신중하게 다룹니다
- one-shot 생성보다 작은 단위로 나눠 반복합니다

## Mockup-To-UI Toolkit / 목업에서 UI Toolkit으로

All adapters route mockup work through stack selection before realization. Start with [`ui-stack-selection.md`](../unity-mcp-ui-layout/references/ui-stack-selection.md), approve [`mockup-layout-plan.yaml`](../templates/mockup-layout-plan.yaml) as the neutral `mockup-layout-plan/v2` artifact, and then use [`ui-toolkit-build-workflow.md`](../unity-mcp-ui-layout/references/ui-toolkit-build-workflow.md) for UI Toolkit realization. Keep [`ui-toolkit-from-mockup-example.md`](../examples/ui-toolkit-from-mockup-example.md), [`mockup-layout-plan-prefab-example.yaml`](../examples/mockup-layout-plan-prefab-example.yaml), and [`mockup-layout-plan-ui-toolkit-example.yaml`](../examples/mockup-layout-plan-ui-toolkit-example.yaml) as the canonical public examples.

모든 adapter는 목업 작업에서 realization 전에 stack selection을 거칩니다. [`ui-stack-selection.md`](../unity-mcp-ui-layout/references/ui-stack-selection.md)에서 시작하고, 중립 `mockup-layout-plan/v2` 산출물인 [`mockup-layout-plan.yaml`](../templates/mockup-layout-plan.yaml)을 승인한 뒤, UI Toolkit realization에는 [`ui-toolkit-build-workflow.md`](../unity-mcp-ui-layout/references/ui-toolkit-build-workflow.md)를 사용합니다. 공개 정본 예시는 [`ui-toolkit-from-mockup-example.md`](../examples/ui-toolkit-from-mockup-example.md), [`mockup-layout-plan-prefab-example.yaml`](../examples/mockup-layout-plan-prefab-example.yaml), [`mockup-layout-plan-ui-toolkit-example.yaml`](../examples/mockup-layout-plan-ui-toolkit-example.yaml)입니다.
