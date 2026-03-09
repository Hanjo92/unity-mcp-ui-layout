# Unity MCP UI Layout

Reusable Unity UI workflow rules for `unity-mcp`, packaged first as a Codex skill and then adapted for other LLM platforms.

`unity-mcp`를 사용할 때 Unity UI를 더 안정적으로 만들기 위한 워크플로 규칙 모음입니다. 기본 형태는 Codex 스킬이며, 다른 LLM 플랫폼에서도 사용할 수 있도록 확장되어 있습니다.

The repository is built around one core idea: when an LLM creates Unity UI from a mockup, screenshot, or target resolution, it should work from anchors, parent containers, scaling rules, and verification loops instead of raw pixel placement.

이 저장소의 핵심 아이디어는 하나입니다. LLM이 목업, 스크린샷, 목표 해상도를 바탕으로 Unity UI를 만들 때, 절대 픽셀값이 아니라 앵커, 부모 컨테이너, 스케일링 규칙, 검증 루프를 기준으로 작업해야 한다는 점입니다.

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
- concrete MCP call recipes for common UI tasks
- common failure patterns and recovery guidance
- final review checks before calling a UI task done
- screenshot verification loops
- safer `unity-mcp` prompting across different LLM products

- 이미지 기반 레이아웃 해석
- UGUI 앵커와 `CanvasScaler` 설정
- HUD, 인벤토리, 팝업, 모바일 safe area 레이아웃 규칙
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
  hud-example.md
  inventory-example.md
  popup-safe-area-example.md
```

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
Translate the composition into anchors, parent containers, and CanvasScaler rules.
Verify the result with screenshots instead of relying on raw pixel placement.
```

```text
$unity-mcp-ui-layout를 사용해서 첨부한 레이아웃 이미지를 기준으로 1920x1080 UGUI HUD를 만들어줘.
구성을 anchor, 부모 컨테이너, CanvasScaler 규칙으로 변환하고,
절대 픽셀 배치 대신 스크린샷 검증으로 결과를 확인해줘.
```

## Platform Examples / 플랫폼별 예시

### Codex

```text
Use $unity-mcp-ui-layout to repair the current inventory layout in UGUI.
Preserve the style, fix slot spacing and scaling drift, and verify at 1920x1080 plus one narrower aspect ratio.
```

```text
$unity-mcp-ui-layout를 사용해서 현재 UGUI 인벤토리 레이아웃을 수정해줘.
기존 스타일은 유지하고, 슬롯 간격과 스케일링 드리프트를 고친 뒤
1920x1080과 더 좁은 비율 한 가지에서 검증해줘.
```

### Google Antigravity

```text
Build this Unity HUD from the attached mockup at 1920x1080.
Treat the image as a composition reference, create parent regions first, then verify with screenshots.
```

```text
첨부한 목업을 기준으로 1920x1080 Unity HUD를 만들어줘.
이미지는 절대 좌표 지시가 아니라 composition reference로 취급하고,
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
- Real project usage should drive future refinements.

- Codex 스킬이 정본입니다.
- `Platform/` 폴더는 같은 워크플로를 다른 LLM 서비스에 맞게 변환한 것입니다.
- `examples/` 폴더에는 자주 쓰는 UI 작업용 실전 예시 프롬프트가 들어 있습니다.
- 실제 프로젝트에서 사용하면서 얻는 피드백을 기준으로 계속 보완하는 것이 좋습니다.
