#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

skill_surface="$(cat "$ROOT_DIR/unity-mcp-ui-layout/SKILL.md")"
selection_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/ui-stack-selection.md")"
snapshot_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/layout-snapshot-contract.md")"
agent_metadata="$(cat "$ROOT_DIR/unity-mcp-ui-layout/agents/openai.yaml")"
runbook="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/agent-runbook.md")"

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local scope="$3"

  if ! grep -Fqi "$needle" <<<"$haystack"; then
    printf 'Missing keyword in %s: %s\n' "$scope" "$needle" >&2
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
    printf 'Expected precedence in %s: %s before %s\n' "$scope" "$first" "$second" >&2
    return 1
  fi
}

assert_contains "$skill_surface" "explicit user instruction" "skill stack router"
assert_contains "$skill_surface" "target surface" "skill snapshot intake"
assert_contains "$skill_surface" "Unity version evidence" "skill snapshot intake"
assert_contains "$skill_surface" "selected object" "skill snapshot intake"
assert_contains "$skill_surface" "active UI root" "skill snapshot intake"
assert_contains "$selection_doc" "selected target" "stack selection"
assert_contains "$selection_doc" "selected_object" "stack selection"
assert_contains "$selection_doc" "active_ui_root" "stack selection"
assert_contains "$selection_doc" "target_surface" "stack selection"
assert_contains "$selection_doc" "runtime" "stack selection"
assert_contains "$selection_doc" "editor" "stack selection"
assert_contains "$selection_doc" "Unity version" "stack selection"
assert_contains "$selection_doc" "installed-package presence alone" "stack selection"
assert_contains "$selection_doc" 'selected `UIDocument`' "stack selection"
assert_contains "$selection_doc" "resolved visual-tree root" "stack selection"
assert_contains "$selection_doc" "editor UI Toolkit owner" "stack selection"
assert_contains "$selection_doc" "corroborating only when referenced by that owner" "stack selection"
assert_contains "$snapshot_doc" "unity_version" "snapshot contract"
assert_contains "$snapshot_doc" "target_surface" "snapshot contract"
assert_contains "$snapshot_doc" "selected_object" "snapshot contract"
assert_contains "$snapshot_doc" "active_ui_root" "snapshot contract"
assert_contains "$agent_metadata" "UXML/USS" "agent metadata"
assert_contains "$agent_metadata" "selected UIDocument" "agent metadata"
assert_contains "$runbook" "selected_object" "runbook intake"
assert_contains "$runbook" "active_ui_root" "runbook intake"
assert_contains "$runbook" "UGUI: establish CanvasScaler, safe-area owner, and root regions" "runbook build mode"
assert_contains "$runbook" "UI Toolkit: establish UIDocument/PanelSettings or Editor owner, resolved visual-tree root, and root flex/scroll ownership" "runbook build mode"

assert_precedes "$selection_doc" "explicit user instruction" "named target or selected UI root" "stack selection"
assert_precedes "$selection_doc" "named target or selected UI root" "existing screen ownership" "stack selection"
assert_precedes "$selection_doc" "existing screen ownership" "project conventions and nearby reusable assets" "stack selection"
assert_precedes "$selection_doc" "project conventions and nearby reusable assets" "clarify only when evidence remains mixed" "stack selection"
