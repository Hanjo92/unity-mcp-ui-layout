#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

build_doc_path="$ROOT_DIR/unity-mcp-ui-layout/references/ui-toolkit-build-workflow.md"
example_path="$ROOT_DIR/examples/ui-toolkit-from-mockup-example.md"

if [[ ! -f "$build_doc_path" ]]; then
  printf 'Missing UI Toolkit build workflow: %s\n' "$build_doc_path" >&2
  exit 1
fi

if [[ ! -f "$example_path" ]]; then
  printf 'Missing UI Toolkit mockup example: %s\n' "$example_path" >&2
  exit 1
fi

build_doc="$(cat "$build_doc_path")"
example_doc="$(cat "$example_path")"
skill_body="$(cat "$ROOT_DIR/unity-mcp-ui-layout/SKILL.md")"

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local scope="$3"

  if ! grep -Fqi "$needle" <<<"$haystack"; then
    printf 'Missing UI Toolkit build phrase in %s: %s\n' "$scope" "$needle" >&2
    return 1
  fi
}

build_keywords=(
  "manage_ui"
  "create"
  "update"
  "create_panel_settings"
  "attach_ui_document"
  "get_visual_tree"
  "UXML"
  "USS"
  "VisualTreeAsset"
  "UXML template"
  "target_surface"
  "runtime"
  "Editor UI"
  "Unity version"
  "version-sensitive"
  "behavior owner"
  "binding"
  "callback"
  "state class"
  "focus"
  "navigation"
  "import"
  "console"
  "screenshot"
  "tool limitation"
  "computed styles"
  "event injection"
  "binding diagnostics"
  "host prefab"
)

example_keywords=(
  "reusable UXML template"
  "USS classes"
  "PanelSettings"
  "UIDocument"
  "behavior_plan"
  "main"
  "alternate"
)

for keyword in "${build_keywords[@]}"; do
  assert_contains "$build_doc" "$keyword" "build workflow"
done

for keyword in "${example_keywords[@]}"; do
  assert_contains "$example_doc" "$keyword" "mockup example"
done

assert_contains "$skill_body" "references/ui-toolkit-build-workflow.md" "skill routing"
