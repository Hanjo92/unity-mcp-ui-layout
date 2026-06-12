#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

skill_body="$(cat "$ROOT_DIR/unity-mcp-ui-layout/SKILL.md")"
agent_metadata="$(cat "$ROOT_DIR/unity-mcp-ui-layout/agents/openai.yaml")"
image_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/image-to-layout.md")"
mockup_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/mockup-decomposition.md")"
resolution_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/mockup-resolution.md")"
review_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/review-checks.md")"
layout_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/layout-checklist.md")"
prompt_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/prompt-patterns.md")"
mcp_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/mcp-call-recipes.md")"
sprite_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/sprite-vs-rawimage.md")"
examples_docs="$(
  cat "$ROOT_DIR/examples/prefab-from-mockup-example.md"
  printf '\n'
  cat "$ROOT_DIR/examples/mockup-decomposition-example.md"
  printf '\n'
  cat "$ROOT_DIR/examples/mockup-resolution-example.md"
)"
platform_docs="$(
  cat "$ROOT_DIR/README.md"
  printf '\n'
  cat "$ROOT_DIR/Platform/README.md"
  printf '\n'
  cat "$ROOT_DIR/Platform/Codex/README.md"
)"

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local scope="$3"

  if ! grep -Fqi "$needle" <<<"$haystack"; then
    printf 'Missing item-rect phrase in %s: %s\n' "$scope" "$needle" >&2
    return 1
  fi
}

assert_contains "$skill_body" "item-level UI rect" "skill body"
assert_contains "$skill_body" "source rect" "skill body"
assert_contains "$skill_body" "asset/crop plan" "skill body"
assert_contains "$agent_metadata" "item-level UI rect" "agent metadata"

assert_contains "$image_doc" "Item rect mapping pass" "image-to-layout"
assert_contains "$image_doc" "Layer/tree ownership and split/keep reason come before item-level rects" "image-to-layout"
assert_contains "$image_doc" "source rect" "image-to-layout"
assert_contains "$image_doc" "normalized rect" "image-to-layout"
assert_contains "$image_doc" "parent-local rect" "image-to-layout"
assert_contains "$image_doc" "fit mode" "image-to-layout"
assert_contains "$image_doc" "asset/crop plan" "image-to-layout"

assert_contains "$mockup_doc" "Item Rect Contract" "mockup-decomposition"
assert_contains "$mockup_doc" "Do not map an item rect until its parent ownership and runtime split reason are named" "mockup-decomposition"
assert_contains "$mockup_doc" "runtime or repeated item" "mockup-decomposition"
assert_contains "$mockup_doc" "decorative sub-parts" "mockup-decomposition"

assert_contains "$resolution_doc" "source rect" "mockup-resolution"
assert_contains "$resolution_doc" "target rect" "mockup-resolution"
assert_contains "$resolution_doc" "item-level" "mockup-resolution"

assert_contains "$review_doc" "Item Rect And Size Match Check" "review-checks"
assert_contains "$review_doc" "item rect drift" "review-checks"
assert_contains "$layout_doc" "item rect drift" "layout-checklist"

assert_contains "$prompt_doc" "item-level UI rect plan" "prompt-patterns"
assert_contains "$mcp_doc" "item-level UI rect plan" "mcp-call-recipes"
assert_contains "$sprite_doc" "mockup-derived crop" "sprite-vs-rawimage"

assert_contains "$examples_docs" "item rect plan" "examples"
assert_contains "$examples_docs" "source rect" "examples"
assert_contains "$platform_docs" "item-level UI rect" "platform docs"
