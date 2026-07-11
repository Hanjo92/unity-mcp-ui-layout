# Contributing

Thanks for contributing to this repository.

This project is a documentation-heavy skill package for Unity UI work through `unity-mcp`, so contribution quality depends more on clarity, repeatability, and real-world usefulness than on volume.

## Contribution Priorities

Prioritize contributions in this order:

1. real failure patterns seen during usage
2. concrete `unity-mcp` call sequences that reduce ambiguity
3. examples that connect rules to actual tasks
4. platform-specific prompt improvements
5. repository polish and navigation

## Contribution Principles

- Keep `SKILL.md` lean and procedural.
- Put detailed guidance in `references/`.
- Put copyable task samples in `examples/`.
- Prefer symptom-first documentation when describing failures.
- Prefer bounded, practical examples over broad theoretical advice.
- Preserve the distinction between UGUI and UI Toolkit when it matters.
- Keep top-level layout grouping anchor-driven before leaf-level detail.
- Prefer documenting repeated UI structures as reusable prefabs or reusable blocks.
- Do not encourage splitting likely single-image assets unless runtime behavior requires it.

## Recommended Workflow

1. Identify the real problem or friction point.
2. Decide whether it belongs in:
   - `unity-mcp-ui-layout/SKILL.md`
   - `unity-mcp-ui-layout/references/`
   - `examples/`
   - `Platform/`
3. Keep the change narrowly scoped.
4. Update the root `README.md` if discoverability changes.
5. If the skill structure changes, make sure `SKILL.md` links to the new material.

## What Goes Where

### `unity-mcp-ui-layout/SKILL.md`

Use this for:

- core operating rules
- trigger-oriented guidance
- reference navigation

Do not overload this file with long examples or repetitive detail.

### `unity-mcp-ui-layout/references/`

Use this for:

- layout rules
- anchor and scaler guidance
- failure patterns
- call recipes
- review checklists
- asset granularity guidance when mockups might be over-decomposed

### `examples/`

Use this for:

- realistic user prompts
- scenario walkthroughs
- copyable starting points
- prompts that reinforce anchor-first grouping and prefab reuse where appropriate

### `Platform/`

Use this for:

- service-specific prompt adaptation
- Codex / Google Antigravity / Claude Artifacts packaging

## Good Contribution Examples

- add a new failure pattern that repeatedly appeared in real usage
- add a new example for a common Unity UI task
- improve a platform adapter so the same workflow feels more native there
- tighten a vague rule that often causes unstable layouts

## Changes That Need Extra Care

- changing popup safe-area rules
- changing ownership between layout groups and manual placement
- changing guidance around repeated-structure prefab reuse
- changing guidance around when a mockup region should remain a single image asset
- changing guidance that affects both UGUI and UI Toolkit
- expanding `SKILL.md` without moving details into references

## Validation

Before opening a PR:

- read the changed files once as if you were a first-time user
- make sure new docs are linked from the right entry points
- make sure examples stay aligned with the actual rules
- avoid adding duplicate guidance in multiple places unless it improves discoverability
- if the change affects release prep or maintenance flow, check `RELEASE_CHECKLIST.md` and `MAINTENANCE.md`

## UI Toolkit Documentation Changes / UI Toolkit 문서 변경

When a change makes mockup-to-UI Toolkit work discoverable, keep stack selection before realization, the neutral `mockup-layout-plan/v2` template, both canonical examples (`mockup-layout-plan-prefab-example.yaml` and `mockup-layout-plan-ui-toolkit-example.yaml`), and the public `ui-toolkit-from-mockup-example.md` walkthrough linked from the entry points. Preserve the distinction between UGUI realization (`Transform`/`RectTransform` and prefab intent) and UI Toolkit realization (visual tree, UXML, USS, and `VisualTreeAsset` template intent).

Run `tests/ui_toolkit_docs_keywords.sh`, `tests/ui_toolkit_build_keywords.sh`, and `tests/mockup_layout_plan_schema.sh` when stack selection, public routing, UI Toolkit build/reuse/verification guidance, or v2 plan artifacts change. Also run YAML parsing, `bash -n` for shell tests, and `git diff --check` before opening a PR.

목업에서 UI Toolkit으로 가는 문서 진입점을 바꿀 때는 realization 전에 stack selection을 두고, 중립 `mockup-layout-plan/v2` template, 두 정본 예시(`mockup-layout-plan-prefab-example.yaml`, `mockup-layout-plan-ui-toolkit-example.yaml`), 공개 `ui-toolkit-from-mockup-example.md` walkthrough 링크를 유지합니다. UGUI realization(`Transform`/`RectTransform`과 prefab 의도)과 UI Toolkit realization(visual tree, UXML, USS, `VisualTreeAsset` template 의도)을 구분합니다.

stack selection, public routing, UI Toolkit build/reuse/verification guidance, v2 plan artifact가 바뀌면 `tests/ui_toolkit_docs_keywords.sh`, `tests/ui_toolkit_build_keywords.sh`, `tests/mockup_layout_plan_schema.sh`를 실행합니다. PR 전에 YAML parsing, shell test `bash -n`, `git diff --check`도 실행합니다.

## PR Guidance

Good PRs for this repo usually:

- explain the real usage problem being solved
- keep the change set focused
- show which file category was chosen and why
- avoid mixing unrelated documentation improvements in one branch
