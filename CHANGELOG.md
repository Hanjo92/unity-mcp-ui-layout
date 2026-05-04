# Changelog

This project follows a lightweight documentation-focused release flow.

이 프로젝트는 문서 중심의 가벼운 릴리스 흐름을 따릅니다.

## Unreleased

### Added

- Added Figma node-tree to UGUI conversion guidance for mapping frames, groups, components, instances, and auto-layout into reusable Unity hierarchy
- Added a practical Figma export example prompt for structure-first UGUI conversion

### Added / 추가

- frame, group, component, instance, auto-layout을 재사용 가능한 Unity 계층으로 옮기기 위한 Figma node-tree -> UGUI 변환 가이드 추가
- structure-first UGUI 변환용 Figma export 실전 예시 프롬프트 추가

### Changed

- Expanded `SKILL.md`, root README, reference navigation, examples navigation, design-system intake, and review checks so Figma node-tree exports are routed separately from style-token sources

### Changed / 변경

- Figma node-tree export 입력이 style-token source와 분리되어 라우팅되도록 `SKILL.md`, 루트 README, references/examples 인덱스, design-system intake, review check를 확장

## v0.5.0 - 2026-04-25

### Added

- Added `DESIGN.md` and design-token intake guidance for Unity UI tasks that need to preserve colors, typography, spacing, shapes, component states, and prose intent
- Added token-to-Unity mapping guidance for UGUI, TextMeshPro, UI Toolkit, and USS
- Added practical DESIGN.md build and repair examples

### Added / 추가

- 색상, 타이포그래피, 간격, 모양, 컴포넌트 상태, prose intent를 보존해야 하는 Unity UI 작업을 위한 `DESIGN.md` 및 design-token intake 가이드 추가
- UGUI, TextMeshPro, UI Toolkit, USS로 design token을 옮기는 매핑 가이드 추가
- DESIGN.md 기반 신규 화면 생성 및 기존 화면 repair 실전 예시 추가

### Changed

- Expanded `SKILL.md`, review checks, example navigation, root README, and platform adapters so design-system sources are read before visual styling
- Kept the new design-source workflow aligned with layout-first verification, repair/build mode, shared-asset safety, text handling, and screenshot checks

### Changed / 변경

- design-system source를 시각 스타일링 전에 읽도록 `SKILL.md`, review check, example navigation, 루트 README, platform adapter 확장
- 새 design-source 워크플로가 layout-first 검증, repair/build mode, shared-asset safety, text handling, screenshot check와 어긋나지 않도록 정리

## v0.4.1 - 2026-04-23

### Added

- Expanded the practical example catalog with beginner first-layout, current-vs-mockup, localized text, long-label, scroll-view, settings dialog, responsive split-pane, tabbed detail screen, mockup decomposition, mobile device profile verification, and repair asset-aware reuse prompts
- Added mobile device profile guidance for checking a main target, taller phone, and wider mobile or tablet profile before approving mobile-first layouts
- Added release and maintenance notes for issue-to-release flow, release-prep checks, and repository upkeep

### Added / 추가

- beginner first-layout, current-vs-mockup, localized text, long-label, scroll-view, settings dialog, responsive split-pane, tabbed detail screen, mockup decomposition, mobile device profile verification, repair asset-aware reuse 프롬프트로 실전 예시 카탈로그 확장
- 모바일 우선 레이아웃을 승인하기 전에 main target, taller phone, wider mobile/tablet profile을 확인하는 mobile device profile 가이드 추가
- issue부터 release까지의 흐름, release prep 체크, 저장소 유지보수에 대한 운영 문서 추가

### Changed

- Tightened skill onboarding, routing, completion gates, prompt patterns, layout checks, and review checks around the new example coverage
- Updated platform and root repository documentation with bilingual navigation and a clearer explanation of how `SKILL.md`, `references/`, `examples/`, and `Platform/` fit together
- Refreshed the backlog so shipped repository-polish and example-coverage work is no longer listed as open

### Changed / 변경

- 새 예시 커버리지에 맞춰 skill onboarding, routing, completion gate, prompt pattern, layout check, review check 문구 정리
- `SKILL.md`, `references/`, `examples/`, `Platform/`의 관계가 더 잘 보이도록 platform 문서와 루트 저장소 문서의 한영 안내 보강
- 이미 반영된 repository polish와 example coverage 작업이 열린 backlog처럼 보이지 않도록 backlog 정리

## v0.4.0 - 2026-04-02

### Added

- UI Toolkit layout rules for container ownership, flex stability, overflow, and text handling
- UI Toolkit failure patterns for narrow-width collapse, inline-override drift, and unclear scroll ownership
- UI Toolkit practical example prompt
- Shared asset verification recipes for checking another known usage before direct base edits
- Shared asset verification example prompt
- Practical asset naming and folder examples, including before/after trees and variant-family organization
- Asset naming practical example prompt

### Added / 추가

- container ownership, flex 안정성, overflow, text handling을 다루는 UI Toolkit 레이아웃 규칙 추가
- 좁은 폭 붕괴, inline override 누적, 불명확한 scroll ownership을 다루는 UI Toolkit 실패 패턴 추가
- UI Toolkit용 실전 예시 프롬프트 추가
- 공용 자산 직접 수정 전에 다른 known usage를 확인하는 shared asset verification 레시피 추가
- shared asset verification 예시 프롬프트 추가
- before/after 폴더 트리와 variant family 구성을 포함한 자산 네이밍/폴더 실전 예시 추가
- 자산 네이밍 정리용 실전 예시 프롬프트 추가

### Changed

- Expanded `SKILL.md`, prompt patterns, review checks, examples, and reference indexes to include the new UI Toolkit and shared-asset verification guidance
- Refined the backlog by moving the completed high-priority items into the release history and leaving the next candidate items behind

### Changed / 변경

- 새 UI Toolkit 규칙과 shared asset verification 가이드를 반영하도록 `SKILL.md`, prompt patterns, review checks, examples, references index를 확장
- 완료된 높은 우선순위 항목을 릴리스 이력으로 옮기고, 다음 후보만 남도록 backlog를 정리

## v0.3.1 - 2026-03-30

### Added

- Synchronized the Codex, Google Antigravity, and Claude adapter documents with the newer `v0.3.0` layout guidance
- Added a `BACKLOG.md` file to track likely next improvements after `v0.3.0`

### Added / 추가

- `v0.3.0`에서 정리한 최신 레이아웃 규칙이 반영되도록 Codex, Google Antigravity, Claude 어댑터 문서를 동기화
- `v0.3.0` 이후 이어갈 가능성이 높은 개선 항목을 정리한 `BACKLOG.md` 추가

### Changed

- Refined the repository description and topic metadata for discoverability
- Linked the backlog from the root README so future work is easier to track

### Changed / 변경

- 검색성과 가독성을 위해 저장소 설명과 토픽 메타데이터를 정리
- 이후 작업 추적이 쉽도록 루트 README에 backlog 링크 추가

## v0.3.0 - 2026-03-30

### Added

- Mockup-native resolution rules so design images can define the planning frame before implementation
- Mockup decomposition guidance for deciding what should stay baked, what should split, and what should become reusable blocks
- Repair mode versus build mode rules for bounded fixes versus greenfield UI creation
- Asset discovery priority rules covering prefabs, variants, sprites, text styles, materials, and placeholders
- Asset naming and folder rules for shared versus screen-owned UI assets
- Text layout rules for wrapping, truncation, auto-size discipline, counters, and localization headroom
- Safe-area remapping guidance for mobile mockups that do not visibly account for notches or home indicators
- Shared asset edit safety rules for deciding when direct base edits are too risky
- New practical examples for mockup resolution, mobile safe-area mapping, and shared asset safety

### Added / 추가

- 시안 이미지의 원본 해상도를 구현 전 계획 기준으로 삼을 수 있는 시안 해상도 규칙 추가
- 어떤 요소를 단일 자산으로 유지하고, 어떤 요소를 분리하거나 재사용 블록으로 승격할지 판단하는 시안 분해 가이드 추가
- 기존 화면 수정과 신규 UI 생성을 구분하는 Repair Mode / Build Mode 규칙 추가
- 프리팹, Variant, 스프라이트, 텍스트 스타일, 머티리얼, 플레이스홀더를 어떤 순서로 찾을지 정리한 자산 탐색 우선순위 규칙 추가
- 공유 자산과 화면 전용 자산을 구분하기 위한 자산 네이밍 및 폴더 규칙 추가
- 줄바꿈, truncation, auto-size 절제, 숫자 영역, 지역화 여유를 다루는 텍스트 레이아웃 규칙 추가
- 노치나 홈 인디케이터가 없는 시안을 모바일 safe area 안쪽 여백으로 재해석하는 규칙 추가
- 공용 base 자산을 직접 수정하는 것이 위험한지 판단하는 공유 자산 수정 안전 규칙 추가
- 시안 해상도, 모바일 safe area 매핑, 공유 자산 수정 안전성 관련 실전 예시 문서 추가

### Changed

- Expanded the skill references, review checks, prompt patterns, and failure guides to cover the new layout, asset, and text rules
- Improved repository navigation through more complete example indexing and reference indexing
- Rewrote the changelog in clean UTF-8 so bilingual release notes remain readable

### Changed / 변경

- 새로운 레이아웃, 자산, 텍스트 규칙을 반영하도록 스킬 참조, 검수 체크, 프롬프트 패턴, 실패 가이드를 확장
- examples 및 references 인덱스를 보강해 저장소 탐색성을 개선
- 한영 병기 릴리스 노트가 깨지지 않도록 changelog를 UTF-8 기준으로 정리

## v0.2.1 - 2026-03-27

### Added

- Sprite versus `RawImage` guidance for static versus texture-driven UI assets
- Review checks for catching static UI visuals that incorrectly drift into `RawImage`
- Failure-pattern guidance for converting ordinary static UI visuals back into the sprite workflow

### Added / 추가

- 정적 UI 자산과 texture-driven UI 자산을 구분하기 위한 Sprite 대 `RawImage` 규칙 추가
- 정적 UI 비주얼이 잘못 `RawImage`로 흘러가는 경우를 잡아내는 최종 검수 체크 추가
- 일반 정적 UI 비주얼을 다시 sprite 워크플로로 되돌리기 위한 실패 패턴 가이드 추가

### Changed

- Updated the root README and skill references so sprite-based UI asset usage is easier to discover

### Changed / 변경

- sprite 기반 UI 자산 사용 규칙을 더 쉽게 찾을 수 있도록 루트 README와 스킬 참조를 정리

## v0.2.0 - 2026-03-27

### Added

- Prefab promotion rules for repeated UI structures
- Existing prefab reuse rules for choosing reuse, variant, wrapper, or a new base
- Prefab variant rules for controlled divergence from a shared base
- MCP call recipes for prefab reuse, existing prefab reuse, and prefab variant workflows
- Prompt patterns for repeated structures, existing prefab reuse, and prefab variants

### Added / 추가

- 반복 UI 구조를 프리팹으로 승격하는 규칙 추가
- 기존 프리팹을 직접 재사용할지, Variant/Wrapper로 갈지, 새 Base를 만들지 판단하는 규칙 추가
- 공용 Base에서 안전하게 분기하는 Prefab Variant 규칙 추가
- 프리팹 재사용, 기존 프리팹 재사용, Prefab Variant용 MCP 호출 예시 추가
- 반복 구조, 기존 프리팹 재사용, Prefab Variant용 프롬프트 패턴 추가

### Changed

- Updated the skill references and root documentation so prefab-oriented workflows are easier to discover

### Changed / 변경

- 프리팹 중심 워크플로를 더 쉽게 찾을 수 있도록 스킬 참조와 루트 문서를 정리

## v0.1.0 - 2026-03-09

### Added

- Initial public release of the `unity-mcp-ui-layout` repository
- Codex skill package plus platform adapters for Google Antigravity and Claude Artifacts
- Bilingual root README, MIT license, and the first public GitHub release

### Added / 추가

- `unity-mcp-ui-layout` 저장소 첫 공개 버전
- Codex 스킬 패키지와 Google Antigravity, Claude Artifacts용 플랫폼 어댑터 추가
- 루트 README 한영 병기, MIT 라이선스, 첫 GitHub 공개 릴리스 추가
