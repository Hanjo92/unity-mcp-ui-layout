#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

skill_surface="$(sed -n '1,4p' "$ROOT_DIR/unity-mcp-ui-layout/SKILL.md"; printf '\n'; cat "$ROOT_DIR/unity-mcp-ui-layout/agents/openai.yaml")"
skill_body="$(cat "$ROOT_DIR/unity-mcp-ui-layout/SKILL.md")"
image_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/image-to-layout.md")"
mockup_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/mockup-decomposition.md")"
review_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/review-checks.md")"
prompt_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/prompt-patterns.md")"
mcp_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/mcp-call-recipes.md")"
ugui_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/ugui-anchors-canvas-scaler.md")"
stitch_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/stitch-html-to-ugui.md")"
figma_doc="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/figma-node-tree-to-ugui.md")"
references_index="$(cat "$ROOT_DIR/unity-mcp-ui-layout/references/README.md")"
entry_docs="$(cat "$ROOT_DIR/README.md"; printf '\n'; cat "$ROOT_DIR/Platform/README.md"; printf '\n'; cat "$ROOT_DIR/Platform/Codex/README.md")"
examples_docs="$(cat "$ROOT_DIR/examples/README.md"; printf '\n'; cat "$ROOT_DIR/examples/mockup-decomposition-example.md")"

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local scope="$3"

  if ! grep -Fqi "$needle" <<<"$haystack"; then
    printf 'Missing layer/tree phrase in %s: %s\n' "$scope" "$needle" >&2
    return 1
  fi
}

assert_contains "$skill_surface" "layer-to-layout-tree pass" "skill metadata"
assert_contains "$skill_surface" "레이어" "skill metadata"
assert_contains "$skill_surface" "트리 구조" "skill metadata"

assert_contains "$skill_body" "If no structured hierarchy source exists" "skill body"
assert_contains "$skill_body" "composition validation" "skill body"

assert_contains "$image_doc" "layer pass" "image-to-layout"
assert_contains "$image_doc" "neutral layout tree" "image-to-layout"
assert_contains "$image_doc" "Transform/RectTransform" "image-to-layout UGUI realization"
assert_contains "$image_doc" "anchors" "image-to-layout UGUI realization"
assert_contains "$image_doc" "layout components" "image-to-layout UGUI realization"
assert_contains "$image_doc" "prefab roots" "image-to-layout UGUI realization"
assert_contains "$image_doc" "visual tree" "image-to-layout UI Toolkit realization"
assert_contains "$image_doc" "UXML templates" "image-to-layout UI Toolkit realization"
assert_contains "$image_doc" "VisualTreeAsset" "image-to-layout UI Toolkit realization"
assert_contains "$image_doc" "flex/style owners" "image-to-layout UI Toolkit realization"
assert_contains "$image_doc" "optional behavior owner" "image-to-layout UI Toolkit realization"
assert_contains "$image_doc" "Tree plan schema" "image-to-layout"
assert_contains "$image_doc" "node_kind" "image-to-layout"
assert_contains "$image_doc" "placement_intent" "image-to-layout"
assert_contains "$image_doc" "layout_owner" "image-to-layout"
assert_contains "$image_doc" "geometry ratios" "image-to-layout"
assert_contains "$image_doc" "split/keep" "image-to-layout"
assert_contains "$image_doc" "asset_plan_id" "image-to-layout"
assert_contains "$image_doc" "creates_runtime_node" "image-to-layout"

for section in layout_tree stack_realization asset_plan behavior_plan; do
  assert_contains "$image_doc" "$section" "image-to-layout v2 template sections"
  assert_contains "$mockup_doc" "$section" "mockup-decomposition v2 template sections"
done

assert_contains "$mockup_doc" "layer stack" "mockup-decomposition"
assert_contains "$mockup_doc" "parent-owned layout hierarchy" "mockup-decomposition"
assert_contains "$mockup_doc" "prefab" "mockup-decomposition UGUI realization"
assert_contains "$mockup_doc" "UXML" "mockup-decomposition UI Toolkit realization"
assert_contains "$mockup_doc" "VisualTreeAsset" "mockup-decomposition UI Toolkit realization"
assert_contains "$mockup_doc" "USS classes" "mockup-decomposition UI Toolkit realization"
assert_contains "$mockup_doc" "draw order" "mockup-decomposition"
assert_contains "$mockup_doc" "containment" "mockup-decomposition"
assert_contains "$mockup_doc" "overlay depth" "mockup-decomposition"
assert_contains "$mockup_doc" "레이어 구조" "mockup-decomposition"

assert_contains "$review_doc" "Layer And Layout Tree Check" "review-checks"
assert_contains "$prompt_doc" "layer-to-Transform tree pass" "prompt-patterns"
assert_contains "$prompt_doc" "layer-to-RectTransform tree pass" "prompt-patterns"
assert_contains "$mcp_doc" "layer-to-RectTransform tree plan" "mcp-call-recipes"
assert_contains "$ugui_doc" "UGUI realization" "ugui-anchors"
assert_contains "$stitch_doc" "composition validation" "stitch-html"
assert_contains "$figma_doc" "composition validation" "figma-node-tree"
assert_contains "$references_index" "layer-to-tree" "references index"

assert_contains "$entry_docs" "visual layers -> clean Unity Transform/RectTransform tree" "entry docs"
assert_contains "$examples_docs" "layer-to-tree pass" "examples docs"
assert_contains "$examples_docs" "Transform tree plan" "examples docs"
assert_contains "$examples_docs" "레이어/트리 구조" "examples docs"
