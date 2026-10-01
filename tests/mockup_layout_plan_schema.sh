#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

assert_contains() {
  local file_path="$1"
  local needle="$2"

  if ! grep -Fqi "$needle" "$file_path"; then
    printf 'Missing mockup layout plan phrase in %s: %s\n' "$file_path" "$needle" >&2
    return 1
  fi
}

assert_contains "$ROOT_DIR/unity-mcp-ui-layout/references/image-to-layout.md" "../templates/mockup-layout-plan.yaml"
assert_contains "$ROOT_DIR/unity-mcp-ui-layout/references/mockup-decomposition.md" "../templates/mockup-layout-plan.yaml"
assert_contains "$ROOT_DIR/unity-mcp-ui-layout/references/prompt-patterns.md" "../templates/mockup-layout-plan.yaml"
assert_contains "$ROOT_DIR/examples/prefab-from-mockup-example.md" "../templates/mockup-layout-plan.yaml"
assert_contains "$ROOT_DIR/examples/prefab-from-mockup-example.md" "mockup-layout-plan-prefab-example.yaml"

PLAN_PATHS=(
  "$ROOT_DIR/templates/mockup-layout-plan.yaml"
  "$ROOT_DIR/examples/mockup-layout-plan-prefab-example.yaml"
  "$ROOT_DIR/examples/mockup-layout-plan-ui-toolkit-example.yaml"
)
RUN_NEGATIVE_CASES=true
if (( $# > 0 )); then
  PLAN_PATHS=("$@")
  RUN_NEGATIVE_CASES=false
fi

validator="$ROOT_DIR/unity-mcp-ui-layout/scripts/validate_layout_plan.rb"
if [[ "$RUN_NEGATIVE_CASES" == true ]]; then
  ruby "$validator" --template "${PLAN_PATHS[0]}"
  ruby "$validator" "${PLAN_PATHS[@]:1}"
else
  ruby "$validator" "${PLAN_PATHS[@]}"
fi


if [[ "$RUN_NEGATIVE_CASES" == true ]]; then
  temp_dir="$(mktemp -d)"
  trap 'rm -rf "$temp_dir"' EXIT
  manifest="$temp_dir/cases.tsv"

  empty_behavior_plan="$temp_dir/empty-behavior-plan.yaml"
  ruby -ryaml - "$ROOT_DIR/examples/mockup-layout-plan-ui-toolkit-example.yaml" "$empty_behavior_plan" <<'RUBY'
source_path, output_path = ARGV
data = YAML.load_file(source_path)
data["behavior_plan"] = []
data["stack_realization"]["ui_toolkit"].delete("behavior_owner")
File.write(output_path, YAML.dump(data))
RUBY
  if ! bash "$0" "$empty_behavior_plan"; then
    printf 'Validator rejected valid empty behavior_plan\n' >&2
    exit 1
  fi

  narrative_comparison="$temp_dir/narrative-comparison.yaml"
  ruby -ryaml - "$ROOT_DIR/examples/mockup-layout-plan-ui-toolkit-example.yaml" "$narrative_comparison" <<'RUBY'
source_path, output_path = ARGV
data = YAML.load_file(source_path)
data["verification_targets"][0]["checks"] << "compare against the prior Canvas, RectTransform, LayoutElement, and prefab result"
File.write(output_path, YAML.dump(data))
RUBY
  if ! bash "$0" "$narrative_comparison"; then
    printf 'Validator rejected neutral comparison text\n' >&2
    exit 1
  fi

  ruby -ryaml - "$ROOT_DIR/examples/mockup-layout-plan-prefab-example.yaml" \
    "$ROOT_DIR/examples/mockup-layout-plan-ui-toolkit-example.yaml" "$temp_dir" >"$manifest" <<'RUBY'
ugui_path, toolkit_path, temp_dir = ARGV

cases = [
  ["unknown-item-candidate", ugui_path, "item_rect_plan references undeclared candidates", lambda { |data|
    data["item_rect_plan"][0]["candidate_id"] = "candidate/Undeclared/Item"
  }],
  ["unknown-asset-candidate", ugui_path, "asset_plan references undeclared candidates", lambda { |data|
    data["asset_plan"][0]["candidate_id"] = "candidate/Undeclared/Asset"
  }],
  ["duplicate-node-path", ugui_path, "duplicate node_path", lambda { |data|
    data["layout_tree"] << data["layout_tree"].last.then { |value| Marshal.load(Marshal.dump(value)) }
  }],
  ["duplicate-candidate-id", ugui_path, "duplicate candidate_id", lambda { |data|
    data["candidate_item_ledger"] << data["candidate_item_ledger"].first.then { |value| Marshal.load(Marshal.dump(value)) }
  }],
  ["duplicate-item-id", ugui_path, "duplicate item_id", lambda { |data|
    data["item_rect_plan"] << data["item_rect_plan"].first.then { |value| Marshal.load(Marshal.dump(value)) }
  }],
  ["duplicate-asset-plan-id", ugui_path, "duplicate asset_plan_id", lambda { |data|
    data["asset_plan"] << data["asset_plan"].first.then { |value| Marshal.load(Marshal.dump(value)) }
  }],
  ["duplicate-behavior-id", ugui_path, "duplicate behavior_id", lambda { |data|
    data["behavior_plan"] << data["behavior_plan"].first.then { |value| Marshal.load(Marshal.dump(value)) }
  }],
  ["unknown-candidate-parent", ugui_path, "parent_hint is not declared in layout_tree", lambda { |data|
    data["candidate_item_ledger"][0]["parent_hint"] = "Canvas/Undeclared"
  }],
  ["incorrect-root-owner", ugui_path, "root_owner must identify exactly one layout_tree node", lambda { |data|
    data["layout_contract"]["root_owner"] = "Canvas/Undeclared"
  }],
  ["malformed-parent", ugui_path, "parent_owner must equal immediate parent path", lambda { |data|
    data["layout_tree"][1]["parent_owner"] = data["layout_tree"][2]["node_path"]
  }],
  ["orphan-asset", ugui_path, "asset_plan entry must match exactly one item_rect_plan", lambda { |data|
    orphan = data["asset_plan"].first.then { |value| Marshal.load(Marshal.dump(value)) }
    orphan["asset_plan_id"] = "asset/Orphan"
    orphan["item_id"] = "Orphan/Item"
    data["asset_plan"] << orphan
  }],
  ["missing-behavior-id", ugui_path, "behavior_plan entry missing keys: behavior_id", lambda { |data|
    data["behavior_plan"][0].delete("behavior_id")
  }],
  ["missing-behavior-owner", ugui_path, "behavior_plan entry missing keys: owner", lambda { |data|
    data["behavior_plan"][0].delete("owner")
  }],
  ["missing-behavior-intent", ugui_path, "behavior_plan entry missing keys: intent", lambda { |data|
    data["behavior_plan"][0].delete("intent")
  }],
  ["nonsense-target-surface", toolkit_path, "target_surface must be runtime or editor", lambda { |data|
    data["stack_realization"]["target_surface"] = "game-view-ish"
  }],
  ["toolkit-anchors", toolkit_path, "forbidden UGUI-only keys: anchors", lambda { |data|
    data["layout_tree"][0]["anchors"] = {"min" => [0, 0], "max" => [1, 1]}
  }],
  ["toolkit-anchor-pivot", toolkit_path, "forbidden UGUI-only keys: anchor_pivot_intent", lambda { |data|
    data["layout_tree"][0]["anchor_pivot_intent"] = "stretch"
  }],
  ["toolkit-creates-object", toolkit_path, "forbidden UGUI-only keys: creates_unity_object", lambda { |data|
    data["asset_plan"][0]["creates_unity_object"] = true
  }],
  ["toolkit-prefab-source", toolkit_path, "forbidden UGUI-only keys: prefab_source", lambda { |data|
    data["asset_plan"][0]["prefab_source"] = "Assets/UI/Invalid.prefab"
  }],
  ["toolkit-canvas-root", toolkit_path, "forbidden UGUI-only keys: canvas_root", lambda { |data|
    data["behavior_plan"][0]["canvas_root"] = "Canvas"
  }],
  ["toolkit-reference-resolution", toolkit_path, "forbidden UGUI-only keys: reference_resolution", lambda { |data|
    data["behavior_plan"][0]["reference_resolution"] = "1920x1080"
  }],
  ["toolkit-unity-type", toolkit_path, "forbidden UGUI-only keys: unity_type", lambda { |data|
    data["layout_tree"][0]["unity_type"] = "VisualElement"
  }],
  ["toolkit-rect-transform-kind", toolkit_path, "forbidden UGUI-only values: RectTransform container", lambda { |data|
    data["layout_tree"][0]["node_kind"] = "RectTransform container"
  }],
  ["toolkit-rect-transform-value", toolkit_path, "forbidden UGUI-only values: RectTransform", lambda { |data|
    data["layout_tree"][0]["layout_owner"] = "RectTransform"
  }],
  ["toolkit-canvas-value", toolkit_path, "forbidden UGUI-only values: Canvas/Root", lambda { |data|
    data["layout_tree"][0]["parent_owner"] = "Canvas/Root"
  }],
  ["toolkit-layout-element-value", toolkit_path, "forbidden UGUI-only values: LayoutElement", lambda { |data|
    data["layout_tree"][0]["layout_owner"] = "LayoutElement"
  }],
  ["toolkit-opposite-branch", toolkit_path, "must not define stack_realization.ugui", lambda { |data|
    data["stack_realization"]["ugui"] = {"canvas_root" => "Canvas", "reference_resolution" => "1920x1080"}
  }],
  ["ugui-opposite-branch", ugui_path, "must not define stack_realization.ui_toolkit", lambda { |data|
    data["stack_realization"]["ui_toolkit"] = {
      "root_uxml" => "Assets/UI/Invalid.uxml",
      "stylesheets" => ["Assets/UI/Invalid.uss"],
      "behavior_owner" => "InvalidController"
    }
  }]
]

cases.each do |name, source, expected, mutate|
  data = YAML.load_file(source)
  mutate.call(data)
  output_path = File.join(temp_dir, "#{name}.yaml")
  File.write(output_path, YAML.dump(data))
  puts [name, output_path, expected].join("\t")
end
RUBY

  assert_rejected() {
    local case_name="$1"
    local fixture_path="$2"
    local expected="$3"
    local output_path="$temp_dir/$case_name.out"

    if bash "$0" "$fixture_path" >"$output_path" 2>&1; then
      printf 'Validator accepted invalid case: %s\n' "$case_name" >&2
      return 1
    fi
    if ! grep -Fq "$expected" "$output_path"; then
      printf 'Validator rejected %s for an unexpected reason:\n' "$case_name" >&2
      cat "$output_path" >&2
      return 1
    fi
  }

  while IFS=$'\t' read -r case_name fixture_path expected; do
    assert_rejected "$case_name" "$fixture_path" "$expected"
  done <"$manifest"
fi
