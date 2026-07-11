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
mcp_recipes="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/mcp-call-recipes.md")"
mcp_build_recipe="$(awk '/^## Build UI Toolkit From a Mockup$/{capture=1; next} capture && /^## /{exit} capture' <<<"$mcp_recipes")"
prompt_patterns="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/prompt-patterns.md")"
existing_prefab_reuse="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/existing-prefab-reuse.md")"
prefab_reuse="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/prefab-reuse.md")"
prefab_variants="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/prefab-variants.md")"
shared_safety="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/shared-asset-edit-safety.md")"
snapshot_contract="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/layout-snapshot-contract.md")"
review_checks="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/review-checks.md")"
layout_rules="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/ui-toolkit-layout-rules.md")"
failure_guide="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/ui-toolkit-failures.md")"

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local scope="$3"

  if ! grep -Fqi "$needle" <<<"$haystack"; then
    printf 'Missing UI Toolkit build phrase in %s: %s\n' "$scope" "$needle" >&2
    return 1
  fi
}

assert_not_contains() {
  local haystack="$1"
  local needle="$2"
  local scope="$3"

  if grep -Fqi "$needle" <<<"$haystack"; then
    printf 'Stale UI Toolkit build phrase in %s: %s\n' "$scope" "$needle" >&2
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

  first_line="$(grep -Fni "$first" <<<"$haystack" | head -n 1 | cut -d: -f1)"
  second_line="$(grep -Fni "$second" <<<"$haystack" | head -n 1 | cut -d: -f1)"

  if [[ -z "$first_line" || -z "$second_line" || "$first_line" -ge "$second_line" ]]; then
    printf 'Expected UI Toolkit build precedence in %s: %s before %s\n' "$scope" "$first" "$second" >&2
    return 1
  fi
}

build_keywords=(
  "manage_ui"
  "create"
  "update"
  "create_panel_settings"
  "manage_gameobject"
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
  "behavior_plan: []"
)

example_keywords=(
  "reusable UXML template"
  "USS classes"
  "PanelSettings"
  "UIDocument"
  "behavior_plan"
  "main"
  "alternate"
  "mockup-layout-plan-ui-toolkit-example.yaml"
  "stable element names"
  "state classes"
  "focus order"
  "executable verification"
)

for keyword in "${build_keywords[@]}"; do
  assert_contains "$build_doc" "$keyword" "build workflow"
done

for keyword in "${example_keywords[@]}"; do
  assert_contains "$example_doc" "$keyword" "mockup example"
done

assert_contains "$skill_body" "references/ui-toolkit-build-workflow.md" "skill routing"

recipe_keywords=(
  "## Build UI Toolkit From a Mockup"
  "ui-stack-selection.md"
  "mockup-layout-plan/v2"
  "manage_ui"
  "create"
  "update"
  'existing `UIDocument` host'
  "manage_gameobject"
  "create_panel_settings"
  "attach_ui_document"
  "get_visual_tree"
  "optional behavior"
  "import"
  "console"
  "main screenshot"
  "alternate screenshot"
  "tool limitation"
  "ui-toolkit-build-workflow.md"
)

prompt_keywords=(
  "UI Toolkit Mockup Build"
  "project-inferred"
  "ui-toolkit-build-workflow.md"
  "reusable intent"
  "prefab"
  "UXML"
  "USS"
)

reuse_keywords=(
  "UXML template"
  "VisualTreeAsset"
  "USS classes"
  "default reusable unit"
  "host prefab"
  "explicit host"
  "scene lifecycle"
)

variant_keywords=(
  "base UXML template"
  "shared USS"
  "wrapper UXML"
  "scoped USS"
  "state classes"
  "prefab variant"
  "structure diverges"
)

shared_safety_keywords=(
  "shared UXML"
  "USS"
  "PanelSettings"
  "theme"
  "behavior scripts"
  "another usage"
)

snapshot_keywords=(
  "reusable UXML templates"
  "stylesheets"
  "PanelSettings"
  "theme_or_style_assets"
  "behavior owners"
  "behavior scripts"
  "asset-aware mode"
)

completion_keywords=(
  "visual tree"
  "import"
  "bindings"
  "callbacks"
  "state classes"
  "focus"
  "navigation"
  "host lifecycle"
  "tool limitations"
)

layout_failure_keywords=(
  "UXML template"
  "USS classes"
  "binding"
  "callback"
  "state class"
  "focus"
  "navigation"
)

for keyword in "${recipe_keywords[@]}"; do
  assert_contains "$mcp_recipes" "$keyword" "MCP recipes"
done

for keyword in "${prompt_keywords[@]}"; do
  assert_contains "$prompt_patterns" "$keyword" "prompt patterns"
done

for keyword in "${reuse_keywords[@]}"; do
  assert_contains "$prefab_reuse" "$keyword" "prefab reuse"
done

for keyword in "${variant_keywords[@]}"; do
  assert_contains "$prefab_variants" "$keyword" "prefab variants"
done

for keyword in "${shared_safety_keywords[@]}"; do
  assert_contains "$shared_safety" "$keyword" "shared asset safety"
done

for keyword in "${snapshot_keywords[@]}"; do
  assert_contains "$snapshot_contract" "$keyword" "layout snapshot"
done

for keyword in "${completion_keywords[@]}"; do
  assert_contains "$review_checks" "$keyword" "review checks"
  assert_contains "$skill_body" "$keyword" "skill completion gate"
done

for keyword in "${layout_failure_keywords[@]}"; do
  assert_contains "$layout_rules" "$keyword" "UI Toolkit layout rules"
  assert_contains "$failure_guide" "$keyword" "UI Toolkit failures"
done

automatic_import_phrase="script tools trigger automatic import and compilation"
assert_contains "$skill_body" "$automatic_import_phrase" "skill script verification"
assert_contains "$prompt_patterns" "$automatic_import_phrase" "script-backed prompt pattern"
assert_contains "$existing_prefab_reuse" "$automatic_import_phrase" "existing prefab reuse"
assert_not_contains "$skill_body" "refresh_unity" "skill script verification"
assert_not_contains "$prompt_patterns" "refresh_unity" "script-backed prompt pattern"
assert_not_contains "$existing_prefab_reuse" "refresh_unity" "existing prefab reuse"

assert_precedes "$mcp_build_recipe" "ui-stack-selection.md" "mockup-layout-plan/v2" "UI Toolkit MCP recipe"
assert_precedes "$mcp_build_recipe" "mockup-layout-plan/v2" "manage_ui" "UI Toolkit MCP recipe"
assert_precedes "$mcp_build_recipe" 'existing `UIDocument` host' "create_panel_settings" "UI Toolkit MCP recipe"
assert_precedes "$mcp_build_recipe" "create_panel_settings" "attach_ui_document" "UI Toolkit MCP recipe"
assert_precedes "$mcp_build_recipe" "attach_ui_document" "get_visual_tree" "UI Toolkit MCP recipe"
assert_precedes "$mcp_build_recipe" "get_visual_tree" "optional behavior" "UI Toolkit MCP recipe"
assert_precedes "$mcp_build_recipe" "optional behavior" "wait for import and compilation" "UI Toolkit MCP recipe"
assert_precedes "$mcp_build_recipe" "wait for import and compilation" "main screenshot" "UI Toolkit MCP recipe"

assert_precedes "$build_doc" 'find an existing `UIDocument` host' "manage_gameobject" "runtime host lifecycle"
assert_precedes "$build_doc" "manage_gameobject" "attach_ui_document" "runtime host lifecycle"
assert_contains "$build_doc" "host GameObject" "runtime host lifecycle"
assert_contains "$build_doc" "prefab asset" "runtime host lifecycle"

bash "$ROOT_DIR/tests/mockup_layout_plan_schema.sh" \
  "$ROOT_DIR/examples/mockup-layout-plan-ui-toolkit-example.yaml"
