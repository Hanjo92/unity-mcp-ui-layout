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

ruby - "$ROOT_DIR/templates/mockup-layout-plan.yaml" "$ROOT_DIR/examples/mockup-layout-plan-prefab-example.yaml" "$ROOT_DIR/examples/mockup-layout-plan-ui-toolkit-example.yaml" <<'RUBY'
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

def require_keys(path, hash, keys, label)
  missing = keys.reject { |key| hash.key?(key) }
  fail_with(path, "#{label} missing keys: #{missing.join(', ')}") unless missing.empty?
end

def require_rect(path, rect, label)
  require_hash(path, rect, label)
  require_keys(path, rect, REQUIRED_RECT_KEYS, label)
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
    require_keys(path, realization, REQUIRED_UGUI_REALIZATION_KEYS, "stack_realization.ugui")
  when "UI Toolkit"
    require_keys(path, realization, REQUIRED_UI_TOOLKIT_REALIZATION_KEYS, "stack_realization.ui_toolkit")
    require_array(path, realization.fetch("stylesheets"), "stack_realization.ui_toolkit stylesheets")
    unless stack_realization.fetch("reusable_asset_type") == "uxml-template"
      fail_with(path, "stack_realization reusable_asset_type must be uxml-template for UI Toolkit")
    end
    forbidden = recursively_find_keys(data, %w[anchor_pivot_intent creates_unity_object prefab_source])
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
  require_array(path, behavior_plan, "behavior_plan")
  require_array(path, verification_targets, "verification_targets")

  layout_paths = layout_tree.map do |node|
    require_hash(path, node, "layout_tree entry")
    require_keys(path, node, REQUIRED_LAYOUT_TREE_KEYS, "layout_tree entry")
    require_rect(path, node.fetch("geometry_ratios"), "geometry_ratios")
    node.fetch("node_path")
  end

  decisions = {}
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
    decisions[candidate.fetch("candidate_id")] = decision
  end

  item_rect_candidate_ids = item_rects.map do |item|
    require_hash(path, item, "item_rect_plan entry")
    require_keys(path, item, REQUIRED_ITEM_RECT_KEYS, "item_rect_plan entry")
    require_rect(path, item.fetch("source_rect"), "source_rect")
    require_rect(path, item.fetch("normalized_rect"), "normalized_rect")
    require_rect(path, item.fetch("parent_local_rect"), "parent_local_rect")
    unless layout_paths.include?(item.fetch("node_path"))
      fail_with(path, "item #{item.fetch('item_id')} node_path is not present in layout_tree")
    end
    item.fetch("candidate_id")
  end

  asset_candidate_ids = asset_plans.map do |asset|
    require_hash(path, asset, "asset_plan entry")
    require_keys(path, asset, REQUIRED_ASSET_KEYS, "asset_plan entry")
    asset.fetch("candidate_id")
  end

  accepted = decisions.select { |_id, decision| decision == "accept" }.keys
  held = decisions.select { |_id, decision| decision == "hold" }.keys
  rejected = decisions.select { |_id, decision| decision == "reject" }.keys

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

  verification_targets.each do |target|
    require_hash(path, target, "verification target")
    require_keys(path, target, %w[target resolution checks], "verification target")
    require_array(path, target.fetch("checks"), "verification target checks")
  end
end
RUBY
