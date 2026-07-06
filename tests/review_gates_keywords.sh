#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

gate_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/review-gates-and-assumptions.md")"
skill_body="$(cat "$ROOT_DIR/unity-mcp-ui-layout/SKILL.md")"
mockup_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/mockup-decomposition.md")"
review_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/review-checks.md")"
runbook="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/agent-runbook.md")"
references_index="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/README.md")"
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
    printf 'Missing review-gates phrase in %s: %s\n' "$scope" "$needle" >&2
    return 1
  fi
}

assert_contains "$gate_doc" "Review Gates And Assumptions" "review gates doc"
assert_contains "$gate_doc" "Hard Blockers: Ask Before Editing" "review gates doc"
assert_contains "$gate_doc" "Unknown UI stack in a mixed-stack project" "review gates doc"
assert_contains "$gate_doc" "Destructive shared-base change" "review gates doc"
assert_contains "$gate_doc" "Soft Ambiguities: Proceed With Named Assumptions" "review gates doc"
assert_contains "$gate_doc" "Mockup native resolution fallback" "review gates doc"
assert_contains "$gate_doc" "Layout-only placeholder assets" "review gates doc"
assert_contains "$gate_doc" "Candidate Ledger Review States" "review gates doc"
assert_contains "$gate_doc" "Accepted Candidate" "review gates doc"
assert_contains "$gate_doc" "Held Candidate" "review gates doc"
assert_contains "$gate_doc" "Rejected Candidate" "review gates doc"
assert_contains "$gate_doc" "When No Human Review Is Available" "review gates doc"
assert_contains "$gate_doc" "must not create Unity objects, prefab children, or crop assets" "review gates doc"
assert_contains "$gate_doc" "Final Response Requirements" "review gates doc"

assert_contains "$skill_body" "references/review-gates-and-assumptions.md" "skill body"
assert_contains "$mockup_doc" "review-gates-and-assumptions.md" "mockup decomposition"
assert_contains "$mockup_doc" "If no human review is available" "mockup decomposition"
assert_contains "$review_doc" "review-gates-and-assumptions.md" "review checks"
assert_contains "$review_doc" "Assumption And Review Gate Check" "review checks"
assert_contains "$runbook" "review-gates-and-assumptions.md" "agent runbook"
assert_contains "$references_index" "review-gates-and-assumptions.md" "references index"
assert_contains "$maintenance_docs" "review gates keyword checks" "maintenance docs"
