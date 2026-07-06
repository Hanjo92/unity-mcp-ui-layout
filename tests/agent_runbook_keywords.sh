#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

runbook="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/agent-runbook.md")"
skill_body="$(cat "$ROOT_DIR/unity-mcp-ui-layout/SKILL.md")"
references_index="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/README.md")"
root_readme="$(cat "$ROOT_DIR/README.md")"
maintenance_docs="$(
  cat "$ROOT_DIR/MAINTENANCE.md"
  printf '\n'
  cat "$ROOT_DIR/RELEASE_CHECKLIST.md"
)"

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local scope="$3"

  if ! grep -Fqi "$needle" <<<"$haystack"; then
    printf 'Missing agent-runbook phrase in %s: %s\n' "$scope" "$needle" >&2
    return 1
  fi
}

assert_contains "$runbook" "Agent Execution Runbook" "runbook"
assert_contains "$runbook" "Name the trigger" "runbook"
assert_contains "$runbook" "Classify the task" "runbook"
assert_contains "$runbook" "Gather Unity state" "runbook"
assert_contains "$runbook" "Plan hierarchy before objects" "runbook"
assert_contains "$runbook" "Review raster candidates" "runbook"
assert_contains "$runbook" "Promote only accepted items" "runbook"
assert_contains "$runbook" "Build Mode Notes" "runbook"
assert_contains "$runbook" "Repair Mode Notes" "runbook"
assert_contains "$runbook" "Structured Export Input Notes" "runbook"
assert_contains "$runbook" "Raster-Only Mockup Input Notes" "runbook"
assert_contains "$runbook" "Design-Token Input Notes" "runbook"
assert_contains "$runbook" "Final Response Checklist" "runbook"
assert_contains "$runbook" "assumptions and unresolved risks" "runbook"

assert_contains "$skill_body" "references/agent-runbook.md" "skill body"
assert_contains "$references_index" "agent-runbook.md" "references index"
assert_contains "$root_readme" "agent-runbook.md" "root README"
assert_contains "$maintenance_docs" "agent runbook keyword checks" "maintenance docs"
