#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

skill_body="$(cat "$ROOT_DIR/unity-mcp-ui-layout/SKILL.md")"
agent_metadata="$(cat "$ROOT_DIR/unity-mcp-ui-layout/agents/openai.yaml")"
snapshot_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/layout-snapshot-contract.md")"
references_index="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/README.md")"
mcp_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/mcp-call-recipes.md")"
review_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/review-checks.md")"
entry_docs="$(
  cat "$ROOT_DIR/README.md"
  printf '\n'
  cat "$ROOT_DIR/MAINTENANCE.md"
  printf '\n'
  cat "$ROOT_DIR/RELEASE_CHECKLIST.md"
)"

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local scope="$3"

  if ! grep -Fqi "$needle" <<<"$haystack"; then
    printf 'Missing layout-snapshot phrase in %s: %s\n' "$scope" "$needle" >&2
    return 1
  fi
}

assert_contains "$skill_body" "layout snapshot" "skill body"
assert_contains "$skill_body" "active UI root" "skill body"
assert_contains "$skill_body" "console state" "skill body"
assert_contains "$agent_metadata" "layout snapshot" "agent metadata"
assert_contains "$agent_metadata" "smaller-call evidence" "agent metadata"

assert_contains "$snapshot_doc" "Unity UI Layout Snapshot Contract" "snapshot contract"
assert_contains "$snapshot_doc" "Expected Snapshot Fields" "snapshot contract"
assert_contains "$snapshot_doc" "UGUI Example Snapshot" "snapshot contract"
assert_contains "$snapshot_doc" "UI Toolkit Example Snapshot" "snapshot contract"
assert_contains "$snapshot_doc" "Fallback: Gather Equivalent Smaller Calls" "snapshot contract"
assert_contains "$snapshot_doc" "screenshot_path" "snapshot contract"
assert_contains "$snapshot_doc" "compile_state" "snapshot contract"
assert_contains "$snapshot_doc" "prefab_source" "snapshot contract"
assert_contains "$snapshot_doc" "overflow" "snapshot contract"

assert_contains "$references_index" "layout-snapshot-contract.md" "references index"
assert_contains "$mcp_doc" "Capture a Layout Snapshot Before Editing" "mcp recipes"
assert_contains "$mcp_doc" "unified layout snapshot" "mcp recipes"
assert_contains "$mcp_doc" "smaller-call fallback" "mcp recipes"
assert_contains "$review_doc" "Layout Snapshot Intake Check" "review checks"
assert_contains "$review_doc" "layout-snapshot-contract.md" "review checks"
assert_contains "$review_doc" "unknown fields recorded explicitly" "review checks"

assert_contains "$entry_docs" "layout snapshot keyword checks" "entry docs"
