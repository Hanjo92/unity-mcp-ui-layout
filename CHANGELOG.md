# Changelog

This project follows a lightweight documentation-focused release flow.

이 프로젝트는 문서 중심 저장소에 맞춘 가벼운 릴리스 흐름을 따릅니다.

## v0.2.1 - 2026-03-27

### Added

- Sprite versus `RawImage` guidance for static versus texture-driven UI assets
- Review checks for catching static UI visuals that incorrectly drift into `RawImage`
- Failure-pattern guidance for converting ordinary static UI visuals back into the sprite workflow

### Added / 추가

- 정적 UI 자산과 texture-driven UI 자산을 구분하기 위한 Sprite 대 `RawImage` 규칙 추가
- 정적 UI 비주얼이 잘못 `RawImage`로 흘러간 경우를 잡아내는 최종 검수 체크 추가
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
- 프리팹 재사용, 기존 프리팹 재사용, Prefab Variant용 MCP 호출 레시피 추가
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

- `unity-mcp-ui-layout` 저장소 최초 공개 버전
- Codex 스킬 패키지와 Google Antigravity, Claude Artifacts용 플랫폼 어댑터 추가
- 루트 README 한영 병기, MIT 라이선스, 첫 GitHub 공개 릴리스 추가
