#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local scope="$3"

  if ! grep -Fq "$needle" <<<"$haystack"; then
    printf 'Missing UI Toolkit documentation phrase in %s: %s\n' "$scope" "$needle" >&2
    return 1
  fi
}

assert_not_contains() {
  local haystack="$1"
  local needle="$2"
  local scope="$3"

  if grep -Fqi "$needle" <<<"$haystack"; then
    printf 'Stale universal UGUI default in %s: %s\n' "$scope" "$needle" >&2
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
    printf 'Expected documentation precedence in %s: %s before %s\n' "$scope" "$first" "$second" >&2
    return 1
  fi
}

assert_link() {
  local path="$1"
  local target="$2"
  local scope="$3"

  assert_contains "$(cat "$path")" "]($target)" "$scope"
  if [[ ! -e "$(dirname "$path")/${target%%#*}" ]]; then
    printf 'Broken Markdown link target in %s: %s\n' "$scope" "$target" >&2
    return 1
  fi
}

assert_local_links_resolve() {
  local path="$1"
  local target

  while IFS= read -r target; do
    case "$target" in
      ""|\#*|http://*|https://*|mailto:*) continue ;;
    esac
    if [[ ! -e "$(dirname "$path")/${target%%#*}" ]]; then
      printf 'Broken local Markdown link in %s: %s\n' "${path#"$ROOT_DIR/"}" "$target" >&2
      return 1
    fi
  done < <(grep -oE '\]\([^)]*\)' "$path" | sed -e 's/^](//' -e 's/)$//')
}

section() {
  local path="$1"
  local heading="$2"

  awk -v heading="$heading" '$0 == heading { capture=1; print; next } capture && /^## / { exit } capture { print }' "$path"
}

subsection() {
  local path="$1"
  local heading="$2"

  awk -v heading="$heading" '$0 == heading { capture=1; print; next } capture && /^### / { exit } capture && /^## / { exit } capture { print }' "$path"
}

preamble() {
  awk '/^## / { exit } { print }' "$1"
}

root_readme="$ROOT_DIR/README.md"
platform_readme="$ROOT_DIR/Platform/README.md"
examples_readme="$ROOT_DIR/examples/README.md"
references_readme="$ROOT_DIR/unity-mcp-ui-layout/references/README.md"
codex_readme="$ROOT_DIR/Platform/Codex/README.md"
google_prompt="$ROOT_DIR/Platform/Google-Antigravity/SYSTEM_PROMPT.md"
claude_prompt="$ROOT_DIR/Platform/Claude-Artifacts/ARTIFACT_PROMPT.md"

for doc in "$root_readme" "$platform_readme" "$examples_readme" "$references_readme" "$codex_readme" "$google_prompt" "$claude_prompt"; do
  assert_local_links_resolve "$doc"
done

assert_link "$root_readme" "./unity-mcp-ui-layout/references/ui-stack-selection.md" "root UI stack navigation"
assert_link "$root_readme" "./unity-mcp-ui-layout/references/ui-toolkit-build-workflow.md" "root UI Toolkit navigation"
assert_link "$root_readme" "./examples/ui-toolkit-from-mockup-example.md" "root UI Toolkit example navigation"
assert_link "$platform_readme" "../unity-mcp-ui-layout/references/ui-stack-selection.md" "platform UI stack navigation"
assert_link "$platform_readme" "../unity-mcp-ui-layout/references/ui-toolkit-build-workflow.md" "platform UI Toolkit navigation"
assert_link "$platform_readme" "../examples/ui-toolkit-from-mockup-example.md" "platform UI Toolkit example navigation"
assert_link "$examples_readme" "../unity-mcp-ui-layout/references/ui-stack-selection.md" "examples UI stack navigation"
assert_link "$examples_readme" "../unity-mcp-ui-layout/references/ui-toolkit-build-workflow.md" "examples UI Toolkit navigation"
assert_link "$examples_readme" "./ui-toolkit-from-mockup-example.md" "examples UI Toolkit walkthrough navigation"

root_start="$(section "$root_readme" '## Start Here / 시작점')"
assert_precedes "$root_start" "Choose the UI stack first" "neutral layer-to-layout tree" "root start guide"

assert_contains "$(preamble "$root_readme")" "neutral layer-to-layout tree" "root introduction"
assert_contains "$(section "$root_readme" '## Quick Rules / 빠른 작업 기준')" "neutral layer-to-layout tree" "root quick rules"
assert_contains "$(section "$platform_readme" '## Intent / 목적')" "neutral layer-to-layout tree" "platform intent"
assert_contains "$(section "$examples_readme" '## Quick Rules')" "neutral layer-to-layout tree" "examples quick rules"
assert_contains "$(section "$examples_readme" '## How to Use')" "neutral layer-to-layout tree" "examples usage rules"

for scoped_doc in \
  "$(preamble "$root_readme")|root introduction" \
  "$(section "$root_readme" '## Quick Rules / 빠른 작업 기준')|root quick rules" \
  "$(section "$root_readme" '## Notes / 참고')|root notes" \
  "$(section "$platform_readme" '## Intent / 목적')|platform intent" \
  "$(section "$examples_readme" '## Quick Rules')|examples quick rules" \
  "$(section "$examples_readme" '## How to Use')|examples usage rules" \
  "$(subsection "$root_readme" '### Google Antigravity')|root generic Google example"; do
  scope="${scoped_doc##*|}"
  content="${scoped_doc%|*}"
  assert_not_contains "$content" "anchor" "$scope"
  assert_not_contains "$content" "RectTransform" "$scope"
  assert_not_contains "$content" "prefab" "$scope"
done

selection_precedence="Selection precedence: explicit user instruction > selected/named target > existing screen ownership > project conventions/assets > clarify when mixed."
for prompt_spec in \
  "$codex_readme|Codex" \
  "$google_prompt|Google Antigravity" \
  "$claude_prompt|Claude Artifacts"; do
  prompt_path="${prompt_spec%%|*}"
  prompt_name="${prompt_spec##*|}"
  prompt="$(cat "$prompt_path")"

  assert_contains "$prompt" "$selection_precedence" "$prompt_name prompt"
  assert_contains "$prompt" "target_surface" "$prompt_name prompt"
  assert_contains "$prompt" "runtime" "$prompt_name prompt"
  assert_contains "$prompt" "editor" "$prompt_name prompt"
  assert_contains "$prompt" "Unity version" "$prompt_name prompt"
  assert_contains "$prompt" "version-sensitive" "$prompt_name prompt"
  assert_contains "$prompt" "neutral layer-to-layout tree" "$prompt_name prompt"
  assert_contains "$prompt" "UGUI realization" "$prompt_name prompt"
  assert_contains "$prompt" "UI Toolkit realization" "$prompt_name prompt"
  assert_contains "$prompt" "UXML" "$prompt_name prompt"
  assert_contains "$prompt" "USS" "$prompt_name prompt"
  assert_contains "$prompt" "VisualTreeAsset" "$prompt_name prompt"
  assert_contains "$prompt" "only when a runtime host is needed" "$prompt_name prompt"
  assert_contains "$prompt" "Do not finalize until" "$prompt_name prompt"
  assert_contains "$prompt" "screenshot" "$prompt_name prompt"
  assert_contains "$prompt" "console" "$prompt_name prompt"
  assert_precedes "$prompt" "$selection_precedence" "UGUI realization" "$prompt_name routing"
  assert_precedes "$prompt" "$selection_precedence" "UI Toolkit realization" "$prompt_name routing"
  assert_link "$prompt_path" "../../unity-mcp-ui-layout/references/ui-stack-selection.md" "$prompt_name stack-selection link"
  assert_link "$prompt_path" "../../templates/mockup-layout-plan.yaml" "$prompt_name neutral-plan link"
  assert_link "$prompt_path" "../../unity-mcp-ui-layout/references/ui-toolkit-build-workflow.md" "$prompt_name UI Toolkit workflow link"
  assert_link "$prompt_path" "../../examples/ui-toolkit-from-mockup-example.md" "$prompt_name UI Toolkit example link"
done

google_common="$(section "$google_prompt" '## Execution Rules')$(section "$google_prompt" '## Image-to-Layout Translation')$(section "$google_prompt" '## Output Behavior')"
claude_common="$(section "$claude_prompt" '## How to Work')$(section "$claude_prompt" '## What the Artifact Should Emphasize')$(section "$claude_prompt" '## Recommended Artifact Flow')$(section "$claude_prompt" '## Writing Style')"
for scoped_doc in "$google_common|Google common operations" "$claude_common|Claude common operations"; do
  scope="${scoped_doc##*|}"
  content="${scoped_doc%|*}"
  assert_not_contains "$content" "anchor" "$scope"
  assert_not_contains "$content" "RectTransform" "$scope"
  assert_not_contains "$content" "prefab" "$scope"
done

assert_not_contains "$(cat "$codex_readme")" "using UGUI unless the project already uses UI Toolkit" "Codex prompt"
assert_not_contains "$(cat "$google_prompt")" "Group the top-level layout into anchor-owned regions" "Google prompt"
assert_not_contains "$(cat "$claude_prompt")" "Group the top-level composition by anchor-owned regions" "Claude prompt"

maintenance="$(cat "$ROOT_DIR/MAINTENANCE.md")"
release_checklist="$(cat "$ROOT_DIR/RELEASE_CHECKLIST.md")"
for doc_spec in "$maintenance|maintenance" "$release_checklist|release validation"; do
  content="${doc_spec%|*}"
  scope="${doc_spec##*|}"
  assert_contains "$content" "tests/ui_toolkit_docs_keywords.sh" "$scope"
  assert_contains "$content" "tests/ui_toolkit_build_keywords.sh" "$scope"
  assert_contains "$content" "Get-ChildItem" "$scope"
  assert_contains "$content" "ForEach-Object" "$scope"
  assert_not_contains "$content" 'for test in tests/*.sh' "$scope"
done

assert_contains "$maintenance" "YAML parsing" "maintenance validation"
assert_contains "$release_checklist" "quick_validate.py" "release validation"
assert_contains "$release_checklist" "YAML parsing" "release validation"
assert_contains "$release_checklist" "bash -n" "release validation"
assert_contains "$release_checklist" "git diff --check" "release validation"

unreleased="$(awk '/^## Unreleased$/{capture=1; next} capture && /^## /{exit} capture{print}' "$ROOT_DIR/CHANGELOG.md")"
for phrase in \
  "stack selection before realization" \
  "neutral mockup layout plan v2" \
  "UI Toolkit build and reusable UXML" \
  "UI Toolkit verification" \
  "UI Toolkit docs keyword test" \
  "realization 전에 stack selection" \
  "중립 mockup layout plan v2" \
  "UI Toolkit build와 재사용 가능한 UXML" \
  "UI Toolkit 검증"; do
  assert_contains "$unreleased" "$phrase" "Unreleased changelog"
done

printf 'UI Toolkit public/discovery documentation checks passed.\n'
