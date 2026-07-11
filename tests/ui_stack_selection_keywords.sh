#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

skill_surface="$(cat "$ROOT_DIR/unity-mcp-ui-layout/SKILL.md")"
selection_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/ui-stack-selection.md")"
snapshot_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/layout-snapshot-contract.md")"
agent_metadata="$(cat "$ROOT_DIR/unity-mcp-ui-layout/agents/openai.yaml")"

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local scope="$3"

  if ! grep -Fqi "$needle" <<<"$haystack"; then
    printf 'Missing keyword in %s: %s\n' "$scope" "$needle" >&2
    return 1
  fi
}

assert_contains "$skill_surface" "explicit user instruction" "skill stack router"
assert_contains "$selection_doc" "selected target" "stack selection"
assert_contains "$selection_doc" "target_surface" "stack selection"
assert_contains "$selection_doc" "runtime" "stack selection"
assert_contains "$selection_doc" "editor" "stack selection"
assert_contains "$selection_doc" "Unity version" "stack selection"
assert_contains "$selection_doc" "installed-package presence alone" "stack selection"
assert_contains "$snapshot_doc" "unity_version" "snapshot contract"
assert_contains "$snapshot_doc" "target_surface" "snapshot contract"
assert_contains "$agent_metadata" "UXML/USS" "agent metadata"
