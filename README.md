# Unity MCP UI Layout

Reusable Unity UI workflow rules for `unity-mcp`, packaged first as a Codex skill and then adapted for other LLM platforms.

`unity-mcp`를 사용할 때 Unity UI를 더 안정적으로 만들기 위한 워크플로 규칙 모음입니다. 기본 형태는 Codex 스킬이며, 다른 LLM 플랫폼에서도 사용할 수 있도록 확장되어 있습니다.

The repository is built around one core idea: when an LLM creates Unity UI from a mockup, screenshot, or target resolution, it should work from anchors, parent containers, scaling rules, and verification loops instead of raw pixel placement.

이 저장소의 핵심 아이디어는 하나입니다. LLM이 목업, 스크린샷, 목표 해상도를 바탕으로 Unity UI를 만들 때, 절대 픽셀값이 아니라 앵커, 부모 컨테이너, 스케일링 규칙, 검증 루프를 기준으로 작업해야 한다는 점입니다.

It also assumes three practical defaults: group the top-level composition by anchor-owned regions first, turn repeated structures into reusable prefabs or reusable layout blocks, and keep likely single-image resources intact unless runtime behavior requires them to be split.

또한 세 가지 실무 기본값을 전제로 합니다. 최상단 구성을 먼저 앵커 기준 영역으로 그룹화하고, 반복 구조는 재사용 가능한 프리팹 또는 레이아웃 블록으로 만들며, 단일 이미지 리소스로 보이는 영역은 런타임 동작상 분리가 필요할 때만 쪼갭니다.

## Bias And Tradeoff / 작업 성향

This workflow biases toward stable structure, scoped changes, and explicit verification over one-shot mockup mimicry.

For trivial one-widget nudges, use judgment rather than forcing every step mechanically.

이 워크플로는 one-shot 목업 복제보다 안정적인 구조, 범위가 분명한 변경, 명시적인 검증을 우선합니다.

아주 작은 위젯 미세 조정 작업에서는 모든 단계를 기계적으로 강제하기보다 상황에 맞게 판단하는 편이 좋습니다.

## Start Here / 시작점

If you are using this repository for the first time, do not start by reading every file.

처음 이 저장소를 쓰는 경우, 모든 파일을 처음부터 끝까지 읽는 방식으로 시작하지 않는 편이 좋습니다.

1. Open [`unity-mcp-ui-layout/SKILL.md`](./unity-mcp-ui-layout/SKILL.md) first if you are using the Codex skill directly.
2. Choose the UI stack first: `UGUI` or `UI Toolkit`.
3. Choose the change mode next: repair an existing screen or build a new one.
4. Decide whether this is layout-only work or asset-aware reuse work.
5. If the task includes `DESIGN.md`, design tokens, or a design-system source, read that source before styling.
6. Then open [`examples/README.md`](./examples/README.md) for a task-shaped entry point, or jump into [`unity-mcp-ui-layout/references/README.md`](./unity-mcp-ui-layout/references/README.md) if you already know the failure mode.

For a first small exercise, start with [`examples/first-layout-pass-example.md`](./examples/first-layout-pass-example.md) before choosing a more domain-specific example.

1. Codex 스킬을 직접 쓴다면 먼저 [`unity-mcp-ui-layout/SKILL.md`](./unity-mcp-ui-layout/SKILL.md)부터 엽니다.
2. UI 스택을 먼저 고릅니다: `UGUI` 또는 `UI Toolkit`.
3. 그다음 기존 화면 수정인지, 신규 화면 생성인지 작업 모드를 고릅니다.
4. 이 작업이 layout-only인지, asset-aware reuse까지 필요한지 결정합니다.
5. 작업에 `DESIGN.md`, design token, design-system source가 포함되어 있다면 스타일링 전에 그 소스를 먼저 읽습니다.
6. 그 후 작업형 진입점이 필요하면 [`examples/README.md`](./examples/README.md)를, 실패 유형을 이미 알고 있다면 [`unity-mcp-ui-layout/references/README.md`](./unity-mcp-ui-layout/references/README.md)를 엽니다.

처음 해볼 작은 연습 과제가 필요하다면 더 구체적인 예시를 고르기 전에 [`examples/first-layout-pass-example.md`](./examples/first-layout-pass-example.md)부터 시작합니다.

## Quick Rules / 빠른 작업 기준

- Group the top-level layout by anchor-owned regions before tuning leaf widgets.
- Turn repeated UI structures into reusable prefabs or reusable layout blocks.
- Keep likely single-image regions intact unless interaction, animation, or adaptive behavior requires decomposition.
- Verify structure with screenshots instead of chasing raw pixel alignment.

- leaf widget를 만지기 전에 최상단 레이아웃을 먼저 anchor 기준 영역으로 그룹화합니다.
- 반복되는 UI 구조는 재사용 가능한 프리팹 또는 레이아웃 블록으로 만듭니다.
- 단일 이미지 리소스로 보이는 영역은 상호작용, 애니메이션, 적응형 동작이 필요할 때만 분해합니다.
- raw pixel 정렬을 쫓기보다 스크린샷으로 구조를 검증합니다.

## Quick Success Signal / 빠른 완료 신호

- the layout still holds at the main target and one additional aspect ratio
- text still behaves correctly with longer labels, counters, or localization growth
- shared assets were either left alone, localized safely, or explicitly verified before base edits
- script-backed UI changes do not leave unresolved compile or console errors

- 메인 타깃 해상도와 추가 비율 한 가지에서 레이아웃이 유지됩니다
- 긴 라벨, 카운터, 지역화 문자열 증가에도 텍스트 동작이 무너지지 않습니다
- shared asset는 그대로 두었거나, 안전하게 국소화했거나, base 수정 전에 명시적으로 검증했습니다
- 스크립트가 얽힌 UI 변경이 미해결 컴파일/콘솔 오류를 남기지 않습니다

## Default Platform / 기본 플랫폼

The default platform is `Codex`.

기본 플랫폼은 `Codex`입니다.

The canonical skill lives in:

정본 스킬은 아래 경로에 있습니다.

- [`unity-mcp-ui-layout/`](./unity-mcp-ui-layout)

Platform-specific adapters live in:

플랫폼별 어댑터는 아래 경로에 있습니다.

- [`Platform/`](./Platform)

## What This Helps With / 해결하려는 문제

- image-to-layout translation
- UGUI anchors and `CanvasScaler`
- HUD, inventory, popup, and mobile safe-area layout rules
- prefab promotion rules for repeated UI structures
- reuse/variant/new-base decision rules for existing prefabs
- prefab variant rules for controlled divergence from a shared base
- sprite/image vs `RawImage` rules for static versus texture-driven UI assets
- mockup-native resolution rules when a design image exists
- mockup decomposition rules for deciding what should stay baked, what should split, and what should become reusable blocks
- repair mode vs greenfield build mode rules for existing-screen fixes versus new UI creation
- DESIGN.md and design-token intake rules for preserving colors, typography, spacing, shapes, component states, and prose intent
- Unity mapping rules for translating design-system tokens into UGUI, TextMeshPro, UI Toolkit, and USS
- asset discovery priority rules for prefab, sprite, font, material, and placeholder reuse order
- asset naming and folder rules so reusable assets stay discoverable and screen-owned assets stay scoped correctly
- practical naming and folder examples for shared versus screen-owned assets and variant family organization
- text layout rules for wrapping, truncation, auto-size discipline, counters, and localization headroom
- localization-focused examples for longer translated strings, multi-line body text, and number growth
- safe-area remapping rules for mobile mockups that do not visibly account for notches or home indicators
- mobile verification profiles for taller phones, wider mobile ratios, and tablet-capable layouts
- visual comparison and bounded repair examples such as `current UI vs mockup` and `repair only one region`
- shared asset edit safety rules for deciding when direct base edits are too risky
- shared asset verification recipes for checking another known usage before direct base edits
- UI Toolkit container ownership, flex stability, and text overflow guidance
- concrete MCP call recipes for common UI tasks
- common failure patterns and recovery guidance
- final review checks before calling a UI task done
- screenshot verification loops
- safer `unity-mcp` prompting across different LLM products

- 이미지 기반 레이아웃 해석
- UGUI 앵커와 `CanvasScaler` 설정
- HUD, 인벤토리, 팝업, 모바일 safe area 레이아웃 규칙
- 반복되는 UI 구조를 프리팹으로 승격하는 규칙
- 기존 프리팹을 재사용/Variant/신규 생성 중 무엇으로 갈지 판단하는 규칙
- 공용 base에서 안전하게 분기하는 Prefab Variant 규칙
- 정적 UI 자산에서 sprite/image와 `RawImage`를 어떻게 구분할지에 대한 규칙
- 시안 이미지가 있을 때 시안의 원본 해상도를 기준 프레임으로 삼는 규칙
- 시안 요소를 어디까지 분해하고 어디를 단일 자산이나 재사용 블록으로 유지할지에 대한 규칙
- 기존 UI 수정 요청과 신규 UI 생성 요청을 구분하는 작업 모드 규칙
- 색상, 타이포그래피, 간격, 모양, 컴포넌트 상태, prose intent를 보존하기 위한 DESIGN.md 및 design token intake 규칙
- design-system token을 UGUI, TextMeshPro, UI Toolkit, USS로 옮기기 위한 Unity 매핑 규칙
- 프리팹, 스프라이트, 폰트, 머티리얼, 플레이스홀더를 어떤 순서로 찾을지에 대한 자산 탐색 우선순위 규칙
- 재사용 자산은 다시 찾기 쉽고 화면 전용 자산은 범위가 드러나도록 만드는 자산 네이밍/폴더 규칙
- shared vs screen-owned 자산과 variant family 구성을 실제 트리로 보여주는 실전 예시
- 줄바꿈, truncation, auto-size 절제, 숫자 영역, 지역화 여유를 위한 텍스트 레이아웃 규칙
- 긴 번역 문자열, multi-line body text, 숫자 증가에 대응하는 지역화 중심 예시
- 노치/홈 인디케이터가 없는 시안을 모바일 safe area 안쪽 여백으로 재해석하는 규칙
- taller phone, wide mobile, tablet 검증 기준을 위한 모바일 검증 프로필
- `current UI vs mockup`, `repair only one region` 같은 비교/범위 제한 예시
- 공용 prefab/sprite/material/text style에 대한 직접 수정이 위험한지 판단하는 안전 규칙
- 공용 자산 직접 수정 전에 다른 known usage를 확인하는 shared asset verification 레시피
- UI Toolkit 화면에서 container ownership, flex 안정성, text overflow를 다루는 가이드
- 자주 쓰는 UI 작업용 구체적인 MCP 호출 레시피
- 자주 실패하는 패턴과 복구 가이드
- 작업 완료 전에 보는 최종 검수 체크
- 스크린샷 기반 검증 루프
- 다양한 LLM 서비스에서 더 안전하게 `unity-mcp`를 쓰는 프롬프트 구성

## Repository Structure / 저장소 구조

```text
unity-mcp-ui-layout/
  SKILL.md
  agents/
  references/

Platform/
  README.md
  Codex/
    README.md
  Google-Antigravity/
    README.md
    SYSTEM_PROMPT.md
  Claude-Artifacts/
    README.md
    ARTIFACT_PROMPT.md

examples/
  README.md
  first-layout-pass-example.md
  hud-example.md
  inventory-example.md
  popup-safe-area-example.md

CONTRIBUTING.md
CHANGELOG.md
```

## How The Pieces Fit / 구성 관계

Use this section as the repo map: start with the skill, choose an example, then open references only for the specific failure mode or rule you need.

이 섹션을 저장소 지도로 보면 됩니다. 먼저 스킬을 읽고, 예시를 고른 다음, 필요한 실패 유형이나 규칙이 있을 때만 레퍼런스를 엽니다.

- `unity-mcp-ui-layout/SKILL.md` is the fast decision layer: choose the UI stack, decide repair versus build mode, work in vertical slices, and verify before finishing.
- `unity-mcp-ui-layout/references/` holds the deeper rules for failure modes, UI types, asset decisions, and fallback guidance.
- `examples/` contains copyable task-shaped prompts that show how to apply the skill without rereading the whole reference set.
- `Platform/` adapts the same core workflow to other LLM environments while keeping the Codex skill as the canonical source.
- `unity-mcp-ui-layout/agents/` contains lightweight metadata used for agent discovery and default invocation text.

- `unity-mcp-ui-layout/SKILL.md`는 빠른 의사결정 레이어입니다. UI 스택을 고르고, repair/build 모드를 정하고, vertical slice로 진행하고, 마무리 전 검증하는 흐름을 담습니다.
- `unity-mcp-ui-layout/references/`는 실패 패턴, UI 유형, 자산 판단, fallback 규칙 같은 깊은 세부 지식을 담습니다.
- `examples/`는 전체 레퍼런스를 다시 읽지 않아도 바로 적용할 수 있는 작업형 프롬프트 예시를 담습니다.
- `Platform/`은 같은 코어 워크플로를 다른 LLM 환경에 맞게 옮긴 어댑터이며, 정본은 여전히 Codex 스킬입니다.
- `unity-mcp-ui-layout/agents/`는 에이전트 검색과 기본 호출 문구에 쓰이는 가벼운 메타데이터를 담습니다.

## Release Notes / 릴리스 노트

- [`CHANGELOG.md`](./CHANGELOG.md)
- [`BACKLOG.md`](./BACKLOG.md)

## Maintenance Docs / 운영 문서

- [`RELEASE_CHECKLIST.md`](./RELEASE_CHECKLIST.md)
- [`MAINTENANCE.md`](./MAINTENANCE.md)

## Platform Notes / 플랫폼 설명

### Codex

Use the skill folder directly by copying `unity-mcp-ui-layout` into your Codex skills directory.

`unity-mcp-ui-layout` 폴더를 Codex 스킬 디렉터리로 복사해서 바로 사용할 수 있습니다.

### Google Antigravity

Use the prompt package in `Platform/Google-Antigravity/` as the base instruction set for an Antigravity workspace or custom skill-like setup that has access to Unity through MCP or an equivalent bridge.

`Platform/Google-Antigravity/`의 프롬프트 패키지를 Antigravity 워크스페이스 또는 커스텀 지침에 넣어서 사용할 수 있습니다. Unity와는 MCP 또는 유사한 브리지를 통해 연결된 상태를 가정합니다.

### Claude Artifacts

Use the prompt package in `Platform/Claude-Artifacts/` as the base instruction for a Claude project or artifact workflow that is connected to Unity tooling.

`Platform/Claude-Artifacts/`의 프롬프트 패키지를 Claude 프로젝트 또는 artifact 워크플로의 기본 지침으로 사용할 수 있습니다.

## Install For Codex / Codex 설치

### Windows

```powershell
Copy-Item -Recurse -Force .\unity-mcp-ui-layout $HOME\.codex\skills\
```

### macOS / Linux

```bash
cp -R ./unity-mcp-ui-layout ~/.codex/skills/
```

## Example Request / 예시 요청

```text
Use $unity-mcp-ui-layout to build a 1920x1080 UGUI HUD from the attached layout image.
Group the top-level composition into anchor-owned regions, then translate it into parent containers and CanvasScaler rules.
Turn repeated structures into reusable prefabs or reusable layout blocks.
If a region looks like a single image resource, keep it as one image unless runtime behavior requires it to be split.
Verify the result with screenshots instead of relying on raw pixel placement.
```

```text
$unity-mcp-ui-layout를 사용해서 첨부한 레이아웃 이미지를 기준으로 1920x1080 UGUI HUD를 만들어줘.
최상단 구성을 먼저 anchor 기준 영역으로 그룹화한 뒤 부모 컨테이너와 CanvasScaler 규칙으로 변환해줘.
반복 구조는 재사용 가능한 프리팹 또는 레이아웃 블록으로 만들어줘.
단일 이미지 리소스로 보이는 영역은 런타임 동작상 분리가 필요할 때만 나눠줘.
절대 픽셀 배치 대신 스크린샷 검증으로 결과를 확인해줘.
```

## Platform Examples / 플랫폼별 예시

### Codex

```text
Use $unity-mcp-ui-layout to repair the current inventory layout in UGUI.
Preserve the style, fix slot spacing and scaling drift, and verify at 1920x1080 plus one narrower aspect ratio.
Keep repeated slot structures reusable instead of rebuilding them one by one.
```

```text
$unity-mcp-ui-layout를 사용해서 현재 UGUI 인벤토리 레이아웃을 수정해줘.
기존 스타일은 유지하고, 슬롯 간격과 스케일링 드리프트를 고친 뒤
1920x1080과 더 좁은 비율 한 가지에서 검증해줘.
반복되는 슬롯 구조는 하나씩 다시 만들지 말고 재사용 가능한 형태로 유지해줘.
```

### Google Antigravity

```text
Build this Unity HUD from the attached mockup at 1920x1080.
Treat the image as a composition reference, group the top-level layout by anchor-owned regions, create parent regions first, and verify with screenshots.
```

```text
첨부한 목업을 기준으로 1920x1080 Unity HUD를 만들어줘.
이미지는 절대 좌표 지시가 아니라 composition reference로 취급하고, 최상단 레이아웃은 anchor 기준 영역으로 먼저 그룹화해줘.
먼저 부모 영역을 만든 뒤 스크린샷으로 검증해줘.
```

### Claude Artifacts

```text
Using the attached mockup, help me build a 1920x1080 Unity HUD in UGUI.
Please work in an artifact-style loop with sections for Plan, Current Change, Verification, and Next Step.
```

```text
첨부한 목업을 바탕으로 1920x1080 UGUI HUD를 만들 수 있게 도와줘.
Artifact 스타일로 Plan, Current Change, Verification, Next Step 섹션을 나눠서 진행해줘.
```

## Notes / 참고

- The Codex skill is the source of truth.
- The platform folders adapt the same workflow for other LLM services.
- The `examples/` folder contains practical prompt examples for common UI tasks.
- `CONTRIBUTING.md` explains how to extend the repo without making the skill harder to use.
- Real project usage should drive future refinements.
- Repeated UI structures should usually be documented as reusable prefabs or reusable blocks, not as repeated manual reconstruction steps.
- Decorative areas that are likely single image assets should stay simple unless interaction or adaptive behavior requires decomposition.

- Codex 스킬이 정본입니다.
- `Platform/` 폴더는 같은 워크플로를 다른 LLM 서비스에 맞게 변환한 것입니다.
- `examples/` 폴더에는 자주 쓰는 UI 작업용 실전 예시 프롬프트가 들어 있습니다.
- `CONTRIBUTING.md`에는 저장소를 확장할 때 스킬 사용성을 해치지 않도록 하는 기여 가이드가 들어 있습니다.
- 실제 프로젝트에서 사용하면서 얻는 피드백을 기준으로 계속 보완하는 것이 좋습니다.
- 반복되는 UI 구조는 수동 재구성 절차보다 재사용 가능한 프리팹 또는 블록 기준으로 문서화하는 편이 좋습니다.
- 장식 영역이 단일 이미지 에셋으로 보이면, 상호작용이나 적응형 동작이 필요할 때만 분해하는 편이 좋습니다.
