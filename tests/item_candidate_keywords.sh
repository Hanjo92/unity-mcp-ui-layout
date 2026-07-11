#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

skill_body="$(cat "$ROOT_DIR/unity-mcp-ui-layout/SKILL.md")"
agent_metadata="$(cat "$ROOT_DIR/unity-mcp-ui-layout/agents/openai.yaml")"
image_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/image-to-layout.md")"
mockup_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/mockup-decomposition.md")"
review_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/review-checks.md")"
prompt_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/prompt-patterns.md")"
sprite_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/sprite-vs-rawimage.md")"
stitch_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/stitch-html-to-ugui.md")"
figma_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/figma-node-tree-to-ugui.md")"
references_index="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/README.md")"
entry_docs="$(
  cat "$ROOT_DIR/README.md"
  printf '\n'
  cat "$ROOT_DIR/Platform/README.md"
  printf '\n'
  cat "$ROOT_DIR/Platform/Codex/README.md"
)"
examples_docs="$(
  cat "$ROOT_DIR/examples/README.md"
  printf '\n'
  cat "$ROOT_DIR/examples/prefab-from-mockup-example.md"
  printf '\n'
  cat "$ROOT_DIR/examples/mockup-decomposition-example.md"
)"
maintenance_docs="$(cat "$ROOT_DIR/MAINTENANCE.md"; printf '\n'; cat "$ROOT_DIR/RELEASE_CHECKLIST.md")"

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local scope="$3"

  if ! grep -Fqi "$needle" <<<"$haystack"; then
    printf 'Missing item-candidate phrase in %s: %s\n' "$scope" "$needle" >&2
    return 1
  fi
}

assert_contains "$skill_body" "candidate item ledger" "skill body"
assert_contains "$skill_body" "candidate set" "skill body"
assert_contains "$skill_body" "human review" "skill body"
assert_contains "$agent_metadata" "candidate item ledger" "agent metadata"

assert_contains "$image_doc" "Candidate item ledger pass" "image-to-layout"
assert_contains "$image_doc" "advisory candidate set" "image-to-layout"
assert_contains "$image_doc" "candidate id" "image-to-layout"
assert_contains "$image_doc" "confidence band" "image-to-layout"
assert_contains "$image_doc" "evidence" "image-to-layout"
assert_contains "$image_doc" "suggested role" "image-to-layout"
assert_contains "$image_doc" "crop padding" "image-to-layout"
assert_contains "$image_doc" "review_decision" "image-to-layout"
assert_contains "$image_doc" "accepted candidates" "image-to-layout"

assert_contains "$mockup_doc" "review_decision" "mockup-decomposition"
assert_contains "$mockup_doc" "accept/hold/reject" "mockup-decomposition"
assert_contains "$mockup_doc" "not a final manifest" "mockup-decomposition"
assert_contains "$mockup_doc" "parent ownership and split reason" "mockup-decomposition"

assert_contains "$review_doc" "Candidate Ledger Review Check" "review-checks"
assert_contains "$review_doc" "candidate over-decomposition" "review-checks"
assert_contains "$review_doc" "human review gate" "review-checks"

assert_contains "$prompt_doc" "candidate item ledger" "prompt-patterns"
assert_contains "$prompt_doc" "accept/hold/reject" "prompt-patterns"
assert_contains "$sprite_doc" "crop padding" "sprite-vs-rawimage"

assert_contains "$stitch_doc" "raster candidate ledger cannot override structured export hierarchy" "stitch-html"
assert_contains "$figma_doc" "raster candidate ledger cannot override structured export hierarchy" "figma-node-tree"
assert_contains "$references_index" "candidate item ledger" "references index"

assert_contains "$entry_docs" "candidate item ledger" "entry docs"
assert_contains "$examples_docs" "candidate item ledger" "examples docs"
assert_contains "$examples_docs" "confidence band" "examples docs"
assert_contains "$examples_docs" "review decision" "examples docs"
assert_contains "$maintenance_docs" "item candidate keyword checks" "maintenance docs"
