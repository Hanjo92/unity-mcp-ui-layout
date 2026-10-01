# Unity MCP UI Layout

[English](./README.md) | **한국어** | [简体中文](./README.zh-CN.md)

`unity-mcp`를 사용해 Unity UI를 안정적으로 만드는 재사용 가능한 워크플로 규칙입니다. Codex 스킬을 정본으로 제공하며, 다른 LLM 플랫폼용 어댑터도 포함합니다.

목업, 스크린샷, 구조화된 내보내기 자료, 목표 해상도를 바탕으로 중립 `layer-to-layout tree`를 만든 뒤, 선택한 UI 스택의 레이아웃·재사용·스케일링·검증 수단으로 구현합니다. 세부 위젯보다 최상위 영역의 소유 관계를 먼저 정하고, 반복 구조를 재사용하며, 런타임 동작상 분리가 필요하지 않은 단일 이미지 리소스는 그대로 유지합니다.

최신 릴리스: [v0.7.0](https://github.com/Hanjo92/unity-mcp-ui-layout/releases/tag/v0.7.0) · [변경 기록](./CHANGELOG.md)

## 시작하기

1. 정본 워크플로인 [`unity-mcp-ui-layout/SKILL.md`](./unity-mcp-ui-layout/SKILL.md)를 엽니다.
2. 구현 전에 UI 스택을 먼저 고릅니다: `UGUI` 또는 `UI Toolkit`.
3. 기존 화면 수정인지, 새 화면 생성인지 작업 모드를 정합니다.
4. 새 화면이나 재설계는 미정인 시안·구조를 순차적으로 질문하고 중립 `layer-to-layout tree`를 확정합니다. 기존 답변은 유지합니다.
5. 시안이 있으면 프로젝트 이미지를 확인하고 적합한 리소스를 재사용합니다. 부족한 리소스는 이미지 생성 스킬과 실행 가능한 경로가 있을 때만 생성 여부를 묻고 생성합니다. 스킬이 없으면 도구만 있어도 질문·생성을 생략합니다. 명시적인 레이아웃 전용 요청은 우선합니다.
6. Stitch HTML/CSS, Figma 노드 트리, `DESIGN.md`, 디자인 토큰이 있다면 수정 전에 구조 소스와 스타일 소스를 구분합니다.
7. [`examples/README.md`](./examples/README.md)에서 작업 예시를 고르거나, [에이전트 실행 가이드](./unity-mcp-ui-layout/references/agent-runbook.md)를 따르거나, [참조 문서 목록](./unity-mcp-ui-layout/references/README.md)에서 필요한 규칙과 실패 유형을 찾습니다.

첫 연습은 [기본 레이아웃 예제](./examples/first-layout-pass-example.md)로 시작합니다. “첨부한 UI 시안을 기준으로 Unity UI를 만들어줘”, “이 디자인 스크린샷으로 UI 프리팹을 만들어줘” 같은 자연어 요청도 스킬명을 직접 언급하지 않고 사용할 수 있어야 합니다.

안정적인 구조, 범위가 분명한 변경, 명시적인 검증을 우선합니다. 작은 위젯 조정에 모든 계획 단계를 강제하지 않습니다.

[실행 규칙](./unity-mcp-ui-layout/references/execution-contract.md)은 스택 선택, 검토 권한, 좌표 계산, 완료 판정을 통일합니다. 설치형 스킬에 [계획 템플릿](./unity-mcp-ui-layout/templates/mockup-layout-plan.yaml)과 [Ruby 검증기](./unity-mcp-ui-layout/scripts/validate_layout_plan.rb)를 포함하며 저장소 최상위 템플릿은 동기화된 호환 복사본입니다. 판단과 계획 검증을 반복 가능하게 만들지만 모델·Unity 버전 간 픽셀 단위 동일 결과를 보장하지는 않습니다.

## 단계별 계획과 이미지 리소스

[UI 계획](./unity-mcp-ui-layout/references/ui-planning-workflow.md)을 세운 뒤 [이미지 리소스 흐름](./unity-mcp-ui-layout/references/image-asset-workflow.md)을 따릅니다. 미정인 시안·구조를 확정하고 적합한 프로젝트 이미지를 재사용하며, 자격을 확인한 실행자가 있을 때만 합의한 부족 리소스를 생성합니다. 자산 인덱스가 없으면 프로젝트를 직접 탐색합니다.

생성 이미지는 선택한 UI 스택에서 검수·임포트·할당·시각 검증을 거칩니다. 임시 리소스 생성 승인이 최종 아트 승인을 뜻하지는 않습니다. [대화 예제](./examples/planned-ui-with-project-images-example.md)는 기존 답변, 생성 거절·불가, 두 UI 스택의 처리 방법을 다룹니다.

## 여러 에이전트와 오케스트레이션

Orca·Paseo 세션, Claude·OpenCode 작업자, API 위임에는 [에이전트 기능별 역할 분담](./unity-mcp-ui-layout/references/agent-capability-routing.md)과 [혼합 에이전트 예제](./examples/mixed-agent-ui-workflow-example.md)를 적용합니다. 역할을 배정하기 전에 실행 세션마다 기능을 확인합니다. 서비스 이름이나 상위 에이전트의 기능만으로 하위 에이전트의 자격을 판단하지 않습니다.

| 역할 | 필요한 근거 |
| --- | --- |
| 이미지 분석·시각 검수 | 현재 버전의 이미지를 실제로 전달받고 해석할 수 있음 |
| 이미지 생성 | 같은 실행자가 생성 스킬을 읽었고 실행 가능한 경로를 갖춤 |
| 구조·코드 구현 | 승인된 구조화 계획과 담당 파일 접근 권한 |
| Unity 적용·촬영 | 해당 프로젝트·Editor 접근 및 관련 도구 확인 |

검증된 생성 담당자의 질문은 지정된 총괄만 전달할 수 있습니다. 스킬이 없는 구현 담당 하위 에이전트는 질문하거나 대신 전달할 수 없습니다. 텍스트 전용 작업자는 승인된 구조·측정값·자산 참조를 사용하고, 실제 이미지를 볼 수 있는 담당자가 이미지 분석과 최종 스크린샷 검수를 수행합니다. 촬영·임포트·코드 검사 성공만으로 시각 품질을 입증할 수 없습니다. 팀에 비전 기능이 없으면 필요한 이미지 분석과 시각 검증은 미완료로 남깁니다.

## 빠른 작업 기준

- 세부 위젯을 조정하기 전에 최상위 영역의 소유 관계와 컨테이너 관계를 정합니다.
- 시안이 있으면 오브젝트 생성 전에 중립 `layer-to-layout tree`를 만듭니다.
- 이 트리를 선택한 스택의 계층·스타일·재사용 수단으로 옮깁니다.
- 런타임 경로에 필요할 때만 화면 호스트를 추가합니다. 재사용 UI를 만든다는 이유만으로 호스트가 필요한 것은 아닙니다.
- 반자동 이미지 분석으로 찾은 후보는 검토 전까지 `candidate item ledger`에 유지합니다.
- 분리되는 런타임 요소와 반복 요소에는 원본 rect, 정규화 rect, Unity 배치 의도, 자산·크롭 계획을 기록합니다.
- 반복 구조는 선택한 스택의 재사용 수단으로 표현합니다.
- 상호작용·애니메이션·적응형 동작이 필요하지 않으면 단일 이미지 영역을 유지합니다.
- 픽셀 좌표를 그대로 맞추기보다 스크린샷으로 구조를 검증합니다.

## 목업에서 UI Toolkit으로

다음 순서로 진행합니다.

1. [ui-stack-selection.md](./unity-mcp-ui-layout/references/ui-stack-selection.md)에서 스택을 고릅니다.
2. [templates/mockup-layout-plan.yaml](./templates/mockup-layout-plan.yaml)의 중립 `mockup-layout-plan/v2` 산출물을 승인합니다.
3. [ui-toolkit-build-workflow.md](./unity-mcp-ui-layout/references/ui-toolkit-build-workflow.md)에 따라 구현합니다.

정본 YAML 예시는 [UGUI 프리팹 계획](./examples/mockup-layout-plan-prefab-example.yaml)과 [UI Toolkit 구현](./examples/mockup-layout-plan-ui-toolkit-example.yaml)을 다룹니다. 전체 흐름은 [UI Toolkit 예제](./examples/ui-toolkit-from-mockup-example.md)를 참고합니다.

## 완료 확인

- 메인 타깃 해상도와 추가 화면 비율 한 가지에서 레이아웃이 유지됩니다.
- 긴 라벨, 카운터, 번역 문자열 증가에도 텍스트가 정상 동작합니다.
- 공용 자산을 보존하거나 변경을 국소화하며, 공용 원본을 수정할 때는 다른 사용처도 검증합니다.
- 스크립트가 포함된 변경에 미해결 컴파일·콘솔 오류가 없습니다.
- 필요한 시각 검수는 현재 결과 버전을 대상으로 수행하며, 기술 검사와 사용자 아트 승인을 별도로 보고합니다.

## 다루는 작업

- 시안·스크린샷 분석: 원본 해상도, 레이어 트리, 후보 검토, 요소 rect, 크롭 계획, 이미지 분해 단위.
- UGUI: 앵커, `CanvasScaler`, 프리팹 재사용·Variant, 정적 Sprite와 텍스처 기반 `RawImage` 구분, 공용 자산 수정 안전성.
- UI Toolkit: 컨테이너 소유 관계, flex 레이아웃, UXML/USS, 재사용 가능한 `VisualTreeAsset` 템플릿, 텍스트 넘침.
- 구조화된 디자인 입력: Stitch HTML/CSS, Figma 노드 트리, `DESIGN.md`, 디자인 토큰, Unity 스타일 매핑.
- 자산 재사용: 탐색 우선순위, 프로젝트 이미지, 이름·폴더 규칙, 공용·화면 전용 리소스, 자격을 확인한 이미지 생성.
- 반응형 UI: HUD, 인벤토리, 팝업, 스크롤 뷰, 모바일 Safe Area, 긴 화면·넓은 비율·태블릿 검증 프로필.
- 텍스트·지역화: 줄바꿈, 말줄임, 자동 크기 조절 기준, 긴 라벨, 여러 줄 본문, 늘어나는 카운터.
- 생성·수정: 범위를 제한한 변경, 현재 화면과 시안 비교, MCP 호출 예시, 스크린샷 검증 반복, 실패 복구.

## 저장소 안내

| 경로 | 용도 |
| --- | --- |
| [unity-mcp-ui-layout/](./unity-mcp-ui-layout) | 설치 가능한 정본 스킬: `SKILL.md`, 에이전트 메타데이터, 상세 참조 문서 |
| [Platform/](./Platform) | Codex, Google Antigravity, Claude Artifacts 어댑터 |
| [examples/](./examples/README.md) | 복사해서 쓸 수 있는 프롬프트와 작업 예제 |
| [templates/mockup-layout-plan.yaml](./templates/mockup-layout-plan.yaml) | 중립 레이아웃 계획 템플릿 |
| [tests/](./tests) | 문서·메타데이터·스키마 검사 |
| [tests/forward/](./tests/forward) | 보존된 프롬프트·보고서·검증 자료 |
| [docs/validation/](./docs/validation) | 실제 실행 결과와 검증 한계 |
| [CONTRIBUTING.md](./CONTRIBUTING.md) | 기여 절차와 작업 범위 기준 |

스킬과 관련 예제로 시작하고, 필요한 상세 참조 문서를 추가로 읽습니다. UI Toolkit 문서 검사는 공개 진입점, 계획 링크, 플랫폼 프롬프트, 릴리스 문서 지침도 확인합니다. 저장된 보고서를 검사한다고 새 에이전트가 실행되는 것은 아닙니다.

## 플랫폼 안내

### Codex

기본 플랫폼입니다. 아래 명령으로 정본 스킬 폴더를 Codex 스킬 디렉터리에 복사합니다.

### Google Antigravity

`Platform/Google-Antigravity/`의 프롬프트 패키지를 워크스페이스나 사용자 지침에 사용합니다. MCP 또는 동등한 브리지를 통한 Unity 접근이 필요합니다.

### Claude Artifacts

`Platform/Claude-Artifacts/`의 프롬프트 패키지를 Unity 도구와 연결된 Claude 프로젝트나 artifact 작업 흐름에 사용합니다.

## Codex에 설치

저장소 루트에서 다음 명령을 실행합니다.

### Windows

```powershell
Copy-Item -Recurse -Force .\unity-mcp-ui-layout $HOME\.codex\skills\
```

### macOS / Linux

```bash
cp -R ./unity-mcp-ui-layout ~/.codex/skills/
```

## 요청 예시

```text
$unity-mcp-ui-layout를 사용해서 첨부한 레이아웃 이미지를 기준으로 1920x1080 UGUI HUD를 만들어줘.
오브젝트 생성 전에 시각적 레이어를 명확한 Unity Transform/RectTransform 트리로 분석해줘.
요소 탐지가 불확실하면 검토 전까지 후보를 candidate item ledger에 유지해줘.
분리되는 런타임·반복 요소는 시안 기준의 item-level UI rect를 먼저 기록한 뒤 Unity 크기를 조정해줘.
최상위 구성을 앵커 기준 영역으로 나누고 부모 컨테이너와 CanvasScaler 규칙에 연결해줘.
반복 구조는 재사용 가능한 프리팹이나 레이아웃 블록으로 만들어줘.
런타임 동작상 분리가 필요하지 않으면 단일 이미지 영역을 유지해줘.
스크린샷으로 결과를 검증해줘.
```

## 플랫폼별 예시

### Codex

```text
$unity-mcp-ui-layout를 사용해서 현재 UGUI 인벤토리 레이아웃을 수정해줘.
스타일은 유지하고 슬롯 간격과 스케일링 문제를 고친 뒤 1920x1080과 더 좁은 비율 한 가지에서 검증해줘.
반복 슬롯은 하나씩 다시 만들지 말고 재사용 가능한 구조로 유지해줘.
```

### Google Antigravity

```text
첨부한 목업을 기준으로 1920x1080 Unity HUD를 만들어줘.
대상 UI 스택을 고르고 중립 layer-to-layout tree를 만든 뒤 해당 스택의 레이아웃 시스템으로 최상위 영역을 구현해줘.
스크린샷으로 결과를 검증해줘.
```

### Claude Artifacts

```text
첨부한 목업을 바탕으로 1920x1080 UGUI HUD를 만들 수 있게 도와줘.
Plan, Current Change, Verification, Next Step 섹션을 둔 artifact 방식으로 반복 작업해줘.
```

## 검증

릴리스 준비나 공개 워크플로 지침을 변경할 때 다음 검사를 실행합니다.

```bash
bash tests/agent_runbook_keywords.sh
bash tests/layout_snapshot_keywords.sh
bash tests/mockup_layout_plan_schema.sh
ruby tests/layout_plan_semantics_test.rb
bash tests/review_gates_keywords.sh
bash tests/trigger_keywords.sh
bash tests/layer_tree_keywords.sh
bash tests/item_rect_keywords.sh
bash tests/item_candidate_keywords.sh
bash tests/ui_toolkit_docs_keywords.sh
bash tests/ui_stack_selection_keywords.sh
bash tests/ui_toolkit_build_keywords.sh
bash tests/ui_toolkit_forward_contract.sh
for test in tests/*.sh; do bash -n "$test" || exit 1; done
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py unity-mcp-ui-layout
git diff --check
```

[2026-09-09 실제 기능 검증 기록](./docs/validation/2026-09-09-agent-capability-routing.md)은 Orca에서 실행한 Codex·OpenCode 세션을 다룹니다. 두 세션 모두 검증 이미지를 판독했습니다. OpenCode의 최초 질문 전달 해석 오류를 지침에 반영하고 같은 세션에서 재검증했으며, 최초·수정 후 보고서를 함께 보존했습니다.

실제 이미지 생성, Unity 실행, Paseo·Claude 실행, 비전 비활성 런타임은 검증하지 않았습니다. 위 shell 검사는 문서·스키마 계약과 저장된 근거를 확인하며, 해당 실행 경로의 성공을 입증하지 않습니다.

## 릴리스와 유지보수

- [변경 기록](./CHANGELOG.md)
- [Backlog](./BACKLOG.md)
- [릴리스 체크리스트](./RELEASE_CHECKLIST.md)
- [유지보수 메모](./MAINTENANCE.md)

## 참고

- Codex 스킬이 정본이며, 플랫폼 어댑터는 같은 워크플로를 따릅니다.
- 실제 프로젝트 사용 경험을 바탕으로 개선합니다.
- 반복 UI는 선택한 스택의 재사용 수단을 기준으로 문서화합니다.
- 장식용 단일 이미지 영역은 상호작용이나 적응형 동작이 필요할 때만 분해합니다.
- 개요·명령·검증 한계를 수정할 때 영어·한국어·중국어 간체 README를 함께 갱신합니다. 연결된 참조 문서는 각 문서의 기존 언어로 제공됩니다.
