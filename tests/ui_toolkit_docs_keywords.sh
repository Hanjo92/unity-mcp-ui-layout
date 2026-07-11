#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local scope="$3"

  if ! grep -Fq "$needle" <<<"$haystack"; then
    printf 'Missing UI Toolkit discovery phrase in %s: %s\n' "$scope" "$needle" >&2
    return 1
  fi
}

assert_not_contains() {
  local haystack="$1"
  local needle="$2"
  local scope="$3"

  if grep -Fq "$needle" <<<"$haystack"; then
    printf 'Stale universal UGUI-only phrase in %s: %s\n' "$scope" "$needle" >&2
    return 1
  fi
}

assert_precedes() {
  local haystack="$1"
  local first="$2"
  local second="$3"
  local scope="$4"
  local first_line
  local second_line

  first_line="$(grep -Fn "$first" <<<"$haystack" | head -n 1 | cut -d: -f1)"
  second_line="$(grep -Fn "$second" <<<"$haystack" | head -n 1 | cut -d: -f1)"

  if [[ -z "$first_line" || -z "$second_line" || "$first_line" -ge "$second_line" ]]; then
    printf 'Expected UI Toolkit discovery precedence in %s: %s before %s\n' "$scope" "$first" "$second" >&2
    return 1
  fi
}

section() {
  local path="$1"
  local heading="$2"

  awk -v heading="$heading" '$0 == heading { capture=1; print; next } capture && /^## / { exit } capture { print }' "$path"
}

root_readme="$(cat "$ROOT_DIR/README.md")"
root_start="$(section "$ROOT_DIR/README.md" '## Start Here / 시작점')"
root_rules="$(section "$ROOT_DIR/README.md" '## Quick Rules / 빠른 작업 기준')"
platform_readme="$(cat "$ROOT_DIR/Platform/README.md")"
platform_intent="$(section "$ROOT_DIR/Platform/README.md" '## Intent / 목적')"
examples_readme="$(cat "$ROOT_DIR/examples/README.md")"
examples_rules="$(section "$ROOT_DIR/examples/README.md" '## Quick Rules')"
references_readme="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/README.md")"
codex_readme="$(cat "$ROOT_DIR/Platform/Codex/README.md")"
google_prompt="$(cat "$ROOT_DIR/Platform/Google-Antigravity/SYSTEM_PROMPT.md")"
claude_prompt="$(cat "$ROOT_DIR/Platform/Claude-Artifacts/ARTIFACT_PROMPT.md")"
contributing="$(cat "$ROOT_DIR/CONTRIBUTING.md")"
maintenance="$(cat "$ROOT_DIR/MAINTENANCE.md")"
release_checklist="$(cat "$ROOT_DIR/RELEASE_CHECKLIST.md")"
unreleased="$(awk '/^## Unreleased$/{capture=1; next} capture && /^## /{exit} capture{print}' "$ROOT_DIR/CHANGELOG.md")"

for doc in "$root_readme" "$platform_readme" "$examples_readme" "$references_readme"; do
  assert_contains "$doc" "ui-stack-selection.md" "public navigation"
  assert_contains "$doc" "ui-toolkit-build-workflow.md" "public navigation"
  assert_contains "$doc" "ui-toolkit-from-mockup-example.md" "public navigation"
  assert_contains "$doc" "mockup-layout-plan.yaml" "public navigation"
  assert_contains "$doc" "mockup-layout-plan-prefab-example.yaml" "public navigation"
  assert_contains "$doc" "mockup-layout-plan-ui-toolkit-example.yaml" "public navigation"
done

assert_precedes "$root_start" "Choose the UI stack first" "neutral layer-to-layout tree" "root start guide"
assert_contains "$root_rules" "neutral layer-to-layout tree" "root quick rules"
assert_contains "$platform_intent" "neutral layer-to-layout tree" "platform intent"
assert_contains "$examples_rules" "neutral layer-to-layout tree" "examples quick rules"

for doc_name in "root mockup workflow" "platform intent" "examples quick rules"; do
  case "$doc_name" in
    "root mockup workflow") doc="$root_rules" ;;
    "platform intent") doc="$platform_intent" ;;
    "examples quick rules") doc="$examples_rules" ;;
  esac
  assert_contains "$doc" "UGUI realization" "$doc_name"
  assert_contains "$doc" "Transform/RectTransform" "$doc_name"
  assert_contains "$doc" "prefab" "$doc_name"
  assert_contains "$doc" "UI Toolkit realization" "$doc_name"
  assert_contains "$doc" "visual tree" "$doc_name"
  assert_contains "$doc" "UXML" "$doc_name"
  assert_contains "$doc" "USS" "$doc_name"
  assert_contains "$doc" "VisualTreeAsset" "$doc_name"
done

assert_contains "$root_rules" "host GameObject/UIDocument only when runtime host is needed" "root quick rules"
assert_contains "$platform_intent" "host GameObject/UIDocument only when runtime host is needed" "platform intent"
assert_contains "$examples_rules" "host GameObject/UIDocument only when runtime host is needed" "examples quick rules"

assert_not_contains "$root_rules" "visual layers -> clean Unity Transform/RectTransform tree" "root quick rules"
assert_not_contains "$platform_intent" "visual layers -> clean Unity Transform/RectTransform tree" "platform intent"
assert_not_contains "$examples_rules" "visual layers -> clean Unity Transform/RectTransform tree" "examples quick rules"

for prompt_name in "Codex" "Google Antigravity" "Claude Artifacts"; do
  case "$prompt_name" in
    "Codex") prompt="$codex_readme" ;;
    "Google Antigravity") prompt="$google_prompt" ;;
    "Claude Artifacts") prompt="$claude_prompt" ;;
  esac
  assert_contains "$prompt" "Choose the UI stack before realization" "$prompt_name prompt"
  assert_contains "$prompt" "neutral layer-to-layout tree" "$prompt_name prompt"
  assert_contains "$prompt" "UGUI realization" "$prompt_name prompt"
  assert_contains "$prompt" "UI Toolkit realization" "$prompt_name prompt"
  assert_contains "$prompt" "mockup-layout-plan/v2" "$prompt_name prompt"
  assert_contains "$prompt" "Do not finalize until" "$prompt_name prompt"
  assert_contains "$prompt" "screenshot" "$prompt_name prompt"
  assert_contains "$prompt" "console" "$prompt_name prompt"
done

assert_contains "$contributing" "tests/ui_toolkit_docs_keywords.sh" "contributing validation"
assert_contains "$contributing" "mockup-layout-plan-ui-toolkit-example.yaml" "contributing artifacts"
assert_contains "$contributing" "stack selection" "contributing validation trigger"
assert_contains "$maintenance" "tests/ui_toolkit_docs_keywords.sh" "maintenance validation"
assert_contains "$maintenance" "ui-toolkit-build-workflow.md" "maintenance artifacts"
assert_contains "$maintenance" "YAML parsing" "maintenance validation"
assert_contains "$release_checklist" "tests/ui_toolkit_docs_keywords.sh" "release validation"
assert_contains "$release_checklist" "quick_validate.py" "release validation"
assert_contains "$release_checklist" "YAML parsing" "release validation"
assert_contains "$release_checklist" "bash -n" "release validation"
assert_contains "$release_checklist" "git diff --check" "release validation"

for phrase in \
  "stack selection before realization" \
  "neutral mockup layout plan v2" \
  "UI Toolkit build and reusable UXML" \
  "UI Toolkit verification" \
  "UI Toolkit docs keyword test"; do
  assert_contains "$unreleased" "$phrase" "English Unreleased changelog"
done

for phrase in \
  "realization 전에 stack selection" \
  "중립 mockup layout plan v2" \
  "UI Toolkit build와 재사용 가능한 UXML" \
  "UI Toolkit 검증" \
  "UI Toolkit docs keyword test"; do
  assert_contains "$unreleased" "$phrase" "Korean Unreleased changelog"
done

printf 'UI Toolkit public/discovery documentation checks passed.\n'
