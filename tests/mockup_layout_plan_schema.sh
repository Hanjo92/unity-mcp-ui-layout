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

assert_contains "$ROOT_DIR/unity-mcp-ui-layout/references/image-to-layout.md" "../../templates/mockup-layout-plan.yaml"
assert_contains "$ROOT_DIR/unity-mcp-ui-layout/references/mockup-decomposition.md" "../../templates/mockup-layout-plan.yaml"
assert_contains "$ROOT_DIR/unity-mcp-ui-layout/references/prompt-patterns.md" "../../templates/mockup-layout-plan.yaml"
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

ruby - "${PLAN_PATHS[@]}" <<'RUBY'
require "yaml"

paths = ARGV

REQUIRED_ROOT_KEYS = %w[
  schema_version
  layout_contract
  stack_realization
  layout_tree
  candidate_item_ledger
  item_rect_plan
  asset_plan
  behavior_plan
  verification_targets
].freeze

REQUIRED_CONTRACT_KEYS = %w[
  ui_stack
  mode
  mockup_source
  target_resolution
  root_owner
  structure_rule
  candidate_policy
].freeze

REQUIRED_POLICY_KEYS = %w[
  accepted
  held
  rejected
].freeze

REQUIRED_LAYOUT_TREE_KEYS = %w[
  node_path
  role
  parent_owner
  node_kind
  layout_owner
  placement_intent
  geometry_ratios
  split_keep_reason
].freeze

REQUIRED_REALIZATION_KEYS = %w[target_surface reusable_asset_type].freeze
REQUIRED_UGUI_REALIZATION_KEYS = %w[canvas_root reference_resolution].freeze
REQUIRED_UI_TOOLKIT_REALIZATION_KEYS = %w[root_uxml stylesheets behavior_owner].freeze

REQUIRED_CANDIDATE_KEYS = %w[
  candidate_id
  source_bounds
  confidence_band
  evidence
  suggested_role
  parent_hint
  crop_padding
  nine_slice_candidate
  review_decision
  decision_note
].freeze

REQUIRED_ITEM_RECT_KEYS = %w[
  item_id
  candidate_id
  node_path
  source_rect
  normalized_rect
  parent_local_rect
  fit_mode
  placement_intent
  split_keep_reason
  asset_plan_id
].freeze

REQUIRED_ASSET_KEYS = %w[
  asset_plan_id
  item_id
  candidate_id
  plan
  source
  nine_slice
  creates_runtime_node
].freeze

REQUIRED_BEHAVIOR_KEYS = %w[behavior_id owner intent].freeze

REQUIRED_RECT_KEYS = %w[x y width height].freeze

def fail_with(path, message)
  warn "#{path}: #{message}"
  exit 1
end

def require_hash(path, value, label)
  fail_with(path, "#{label} must be a map") unless value.is_a?(Hash)
end

def require_array(path, value, label)
  fail_with(path, "#{label} must be a non-empty list") unless value.is_a?(Array) && !value.empty?
end

def require_array_type(path, value, label)
  fail_with(path, "#{label} must be a list") unless value.is_a?(Array)
end

def require_keys(path, hash, keys, label)
  missing = keys.reject { |key| hash.key?(key) }
  fail_with(path, "#{label} missing keys: #{missing.join(', ')}") unless missing.empty?
end

def require_rect(path, rect, label)
  require_hash(path, rect, label)
  require_keys(path, rect, REQUIRED_RECT_KEYS, label)
end

def require_unique(path, values, label)
  duplicates = values.group_by(&:itself).select { |_value, occurrences| occurrences.length > 1 }.keys
  fail_with(path, "duplicate #{label}: #{duplicates.join(', ')}") unless duplicates.empty?
end

def recursively_find_keys(value, forbidden_keys, found = [])
  case value
  when Hash
    value.each do |key, nested_value|
      found << key if forbidden_keys.include?(key)
      recursively_find_keys(nested_value, forbidden_keys, found)
    end
  when Array
    value.each { |nested_value| recursively_find_keys(nested_value, forbidden_keys, found) }
  end
  found
end

paths.each do |path|
  data = YAML.load_file(path)
  require_hash(path, data, "document")
  require_keys(path, data, REQUIRED_ROOT_KEYS, "root")
  unexpected_root_keys = data.keys - REQUIRED_ROOT_KEYS
  fail_with(path, "root has unexpected keys: #{unexpected_root_keys.join(', ')}") unless unexpected_root_keys.empty?
  fail_with(path, "schema_version must be mockup-layout-plan/v2") unless data.fetch("schema_version") == "mockup-layout-plan/v2"

  contract = data.fetch("layout_contract")
  require_hash(path, contract, "layout_contract")
  require_keys(path, contract, REQUIRED_CONTRACT_KEYS, "layout_contract")
  policy = contract.fetch("candidate_policy")
  require_hash(path, policy, "candidate_policy")
  require_keys(path, policy, REQUIRED_POLICY_KEYS, "candidate_policy")

  stack_realization = data.fetch("stack_realization")
  require_hash(path, stack_realization, "stack_realization")
  require_keys(path, stack_realization, REQUIRED_REALIZATION_KEYS, "stack_realization")

  ui_stack = contract.fetch("ui_stack")
  realization_key = ui_stack == "UGUI" ? "ugui" : "ui_toolkit"
  realization = stack_realization[realization_key]
  require_hash(path, realization, "stack_realization.#{realization_key}")

  case ui_stack
  when "UGUI"
    if stack_realization.key?("ui_toolkit")
      fail_with(path, "UGUI plan must not define stack_realization.ui_toolkit")
    end
    require_keys(path, realization, REQUIRED_UGUI_REALIZATION_KEYS, "stack_realization.ugui")
  when "UI Toolkit"
    if stack_realization.key?("ugui")
      fail_with(path, "UI Toolkit plan must not define stack_realization.ugui")
    end
    require_keys(path, realization, REQUIRED_UI_TOOLKIT_REALIZATION_KEYS, "stack_realization.ui_toolkit")
    require_array(path, realization.fetch("stylesheets"), "stack_realization.ui_toolkit stylesheets")
    unless stack_realization.fetch("reusable_asset_type") == "uxml-template"
      fail_with(path, "stack_realization reusable_asset_type must be uxml-template for UI Toolkit")
    end
    forbidden = recursively_find_keys(data, %w[
      anchor_pivot_intent
      creates_unity_object
      prefab_source
      canvas_root
      reference_resolution
      unity_type
    ])
    unless forbidden.empty?
      fail_with(path, "UI Toolkit plan contains forbidden UGUI-only keys: #{forbidden.uniq.join(', ')}")
    end
  else
    fail_with(path, "layout_contract ui_stack must be UGUI or UI Toolkit")
  end

  layout_tree = data.fetch("layout_tree")
  candidates = data.fetch("candidate_item_ledger")
  item_rects = data.fetch("item_rect_plan")
  asset_plans = data.fetch("asset_plan")
  behavior_plan = data.fetch("behavior_plan")
  verification_targets = data.fetch("verification_targets")

  require_array(path, layout_tree, "layout_tree")
  require_array(path, candidates, "candidate_item_ledger")
  require_array(path, item_rects, "item_rect_plan")
  require_array(path, asset_plans, "asset_plan")
  require_array_type(path, behavior_plan, "behavior_plan")
  require_array(path, verification_targets, "verification_targets")

  layout_paths = layout_tree.map do |node|
    require_hash(path, node, "layout_tree entry")
    require_keys(path, node, REQUIRED_LAYOUT_TREE_KEYS, "layout_tree entry")
    require_rect(path, node.fetch("geometry_ratios"), "geometry_ratios")
    node.fetch("node_path")
  end
  require_unique(path, layout_paths, "node_path")

  root_owner = contract.fetch("root_owner")
  root_matches = layout_tree.count { |node| node.fetch("node_path") == root_owner }
  unless root_matches == 1
    fail_with(path, "layout_contract.root_owner must identify exactly one layout_tree node: #{root_owner}")
  end

  layout_tree.each do |node|
    next if node.fetch("node_path") == root_owner

    parent_owner = node.fetch("parent_owner")
    unless layout_paths.include?(parent_owner)
      fail_with(path, "layout node #{node.fetch('node_path')} parent_owner is not declared in layout_tree: #{parent_owner}")
    end
    immediate_parent = node.fetch("node_path").split("/")[0...-1].join("/")
    unless parent_owner == immediate_parent
      fail_with(path, "layout node #{node.fetch('node_path')} parent_owner must equal immediate parent path: #{immediate_parent}")
    end
  end

  decisions = {}
  candidate_ids = []
  candidates.each do |candidate|
    require_hash(path, candidate, "candidate entry")
    require_keys(path, candidate, REQUIRED_CANDIDATE_KEYS, "candidate entry")
    require_rect(path, candidate.fetch("source_bounds"), "source_bounds")
    decision = candidate.fetch("review_decision")
    unless %w[accept hold reject].include?(decision)
      fail_with(path, "candidate #{candidate.fetch('candidate_id')} has invalid review_decision: #{decision}")
    end
    evidence = candidate.fetch("evidence")
    require_array(path, evidence, "candidate evidence")
    candidate_id = candidate.fetch("candidate_id")
    candidate_ids << candidate_id
    decisions[candidate_id] = decision
    unless layout_paths.include?(candidate.fetch("parent_hint"))
      fail_with(path, "candidate #{candidate_id} parent_hint is not declared in layout_tree: #{candidate.fetch('parent_hint')}")
    end
  end
  require_unique(path, candidate_ids, "candidate_id")

  item_ids = []
  item_rect_candidate_ids = item_rects.map do |item|
    require_hash(path, item, "item_rect_plan entry")
    require_keys(path, item, REQUIRED_ITEM_RECT_KEYS, "item_rect_plan entry")
    require_rect(path, item.fetch("source_rect"), "source_rect")
    require_rect(path, item.fetch("normalized_rect"), "normalized_rect")
    require_rect(path, item.fetch("parent_local_rect"), "parent_local_rect")
    unless layout_paths.include?(item.fetch("node_path"))
      fail_with(path, "item #{item.fetch('item_id')} node_path is not present in layout_tree")
    end
    item_ids << item.fetch("item_id")
    item.fetch("candidate_id")
  end
  require_unique(path, item_ids, "item_id")

  asset_plan_ids = []
  asset_candidate_ids = asset_plans.map do |asset|
    require_hash(path, asset, "asset_plan entry")
    require_keys(path, asset, REQUIRED_ASSET_KEYS, "asset_plan entry")
    asset_plan_ids << asset.fetch("asset_plan_id")
    asset.fetch("candidate_id")
  end
  require_unique(path, asset_plan_ids, "asset_plan_id")

  behavior_ids = behavior_plan.map do |behavior|
    require_hash(path, behavior, "behavior_plan entry")
    require_keys(path, behavior, REQUIRED_BEHAVIOR_KEYS, "behavior_plan entry")
    behavior.fetch("behavior_id")
  end
  require_unique(path, behavior_ids, "behavior_id")

  accepted = decisions.select { |_id, decision| decision == "accept" }.keys
  held = decisions.select { |_id, decision| decision == "hold" }.keys
  rejected = decisions.select { |_id, decision| decision == "reject" }.keys

  unknown_item_candidates = item_rect_candidate_ids - decisions.keys
  unless unknown_item_candidates.empty?
    fail_with(path, "item_rect_plan references undeclared candidates: #{unknown_item_candidates.join(', ')}")
  end

  unknown_asset_candidates = asset_candidate_ids - decisions.keys
  unless unknown_asset_candidates.empty?
    fail_with(path, "asset_plan references undeclared candidates: #{unknown_asset_candidates.join(', ')}")
  end

  missing_item_rect = accepted - item_rect_candidate_ids
  fail_with(path, "accepted candidates missing item_rect_plan entries: #{missing_item_rect.join(', ')}") unless missing_item_rect.empty?

  disallowed_item_rect = (held + rejected) & item_rect_candidate_ids
  fail_with(path, "held/rejected candidates must not appear in item_rect_plan: #{disallowed_item_rect.join(', ')}") unless disallowed_item_rect.empty?

  disallowed_asset = (held + rejected) & asset_candidate_ids
  fail_with(path, "held/rejected candidates must not appear in asset_plan: #{disallowed_asset.join(', ')}") unless disallowed_asset.empty?

  item_rects.each do |item|
    asset_id = item.fetch("asset_plan_id")
    asset = asset_plans.find { |entry| entry.fetch("asset_plan_id") == asset_id }
    unless asset
      fail_with(path, "item #{item.fetch('item_id')} references missing asset_plan_id: #{asset_id}")
    end
    unless asset.fetch("item_id") == item.fetch("item_id") && asset.fetch("candidate_id") == item.fetch("candidate_id")
      fail_with(path, "item #{item.fetch('item_id')} asset reference does not preserve item and candidate ownership")
    end
  end

  asset_plans.each do |asset|
    matching_items = item_rects.select do |item|
      item.fetch("item_id") == asset.fetch("item_id") &&
        item.fetch("candidate_id") == asset.fetch("candidate_id") &&
        item.fetch("asset_plan_id") == asset.fetch("asset_plan_id")
    end
    unless matching_items.length == 1
      fail_with(path, "asset_plan entry must match exactly one item_rect_plan: #{asset.fetch('asset_plan_id')}")
    end
  end

  verification_targets.each do |target|
    require_hash(path, target, "verification target")
    require_keys(path, target, %w[target resolution checks], "verification target")
    require_array(path, target.fetch("checks"), "verification target checks")
  end
end
RUBY

if [[ "$RUN_NEGATIVE_CASES" == true ]]; then
  temp_dir="$(mktemp -d)"
  trap 'rm -rf "$temp_dir"' EXIT
  manifest="$temp_dir/cases.tsv"

  empty_behavior_plan="$temp_dir/empty-behavior-plan.yaml"
  ruby -ryaml - "$ROOT_DIR/examples/mockup-layout-plan-ui-toolkit-example.yaml" "$empty_behavior_plan" <<'RUBY'
source_path, output_path = ARGV
data = YAML.load_file(source_path)
data["behavior_plan"] = []
File.write(output_path, YAML.dump(data))
RUBY
  if ! bash "$0" "$empty_behavior_plan"; then
    printf 'Validator rejected valid empty behavior_plan\n' >&2
    exit 1
  fi

  ruby -ryaml - "$ROOT_DIR/templates/mockup-layout-plan.yaml" \
    "$ROOT_DIR/examples/mockup-layout-plan-ui-toolkit-example.yaml" "$temp_dir" >"$manifest" <<'RUBY'
template_path, toolkit_path, temp_dir = ARGV

cases = [
  ["unknown-item-candidate", template_path, "item_rect_plan references undeclared candidates", lambda { |data|
    data["item_rect_plan"][0]["candidate_id"] = "candidate/Undeclared/Item"
  }],
  ["unknown-asset-candidate", template_path, "asset_plan references undeclared candidates", lambda { |data|
    data["asset_plan"][0]["candidate_id"] = "candidate/Undeclared/Asset"
  }],
  ["duplicate-node-path", template_path, "duplicate node_path", lambda { |data|
    data["layout_tree"] << data["layout_tree"].last.dup
  }],
  ["duplicate-candidate-id", template_path, "duplicate candidate_id", lambda { |data|
    data["candidate_item_ledger"] << data["candidate_item_ledger"].first.dup
  }],
  ["duplicate-item-id", template_path, "duplicate item_id", lambda { |data|
    data["item_rect_plan"] << data["item_rect_plan"].first.dup
  }],
  ["duplicate-asset-plan-id", template_path, "duplicate asset_plan_id", lambda { |data|
    data["asset_plan"] << data["asset_plan"].first.dup
  }],
  ["duplicate-behavior-id", template_path, "duplicate behavior_id", lambda { |data|
    data["behavior_plan"] << data["behavior_plan"].first.dup
  }],
  ["unknown-candidate-parent", template_path, "parent_hint is not declared in layout_tree", lambda { |data|
    data["candidate_item_ledger"][0]["parent_hint"] = "Canvas/Undeclared"
  }],
  ["incorrect-root-owner", template_path, "root_owner must identify exactly one layout_tree node", lambda { |data|
    data["layout_contract"]["root_owner"] = "Canvas/Undeclared"
  }],
  ["malformed-parent", template_path, "parent_owner must equal immediate parent path", lambda { |data|
    data["layout_tree"][1]["parent_owner"] = data["layout_tree"][2]["node_path"]
  }],
  ["orphan-asset", template_path, "asset_plan entry must match exactly one item_rect_plan", lambda { |data|
    orphan = data["asset_plan"].first.dup
    orphan["asset_plan_id"] = "asset/Orphan"
    orphan["item_id"] = "Orphan/Item"
    data["asset_plan"] << orphan
  }],
  ["missing-behavior-id", template_path, "behavior_plan entry missing keys: behavior_id", lambda { |data|
    data["behavior_plan"][0].delete("behavior_id")
  }],
  ["missing-behavior-owner", template_path, "behavior_plan entry missing keys: owner", lambda { |data|
    data["behavior_plan"][0].delete("owner")
  }],
  ["missing-behavior-intent", template_path, "behavior_plan entry missing keys: intent", lambda { |data|
    data["behavior_plan"][0].delete("intent")
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
  ["toolkit-opposite-branch", toolkit_path, "must not define stack_realization.ugui", lambda { |data|
    data["stack_realization"]["ugui"] = {"canvas_root" => "Canvas", "reference_resolution" => "1920x1080"}
  }],
  ["ugui-opposite-branch", template_path, "must not define stack_realization.ui_toolkit", lambda { |data|
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
