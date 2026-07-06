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

ruby - "$ROOT_DIR/templates/mockup-layout-plan.yaml" "$ROOT_DIR/examples/mockup-layout-plan-prefab-example.yaml" <<'RUBY'
require "yaml"

paths = ARGV

REQUIRED_ROOT_KEYS = %w[
  schema_version
  plan_id
  layout_contract
  layer_tree
  candidate_item_ledger
  item_rect_plan
  asset_crop_plan
  verification_targets
].freeze

REQUIRED_CONTRACT_KEYS = %w[
  ui_stack
  mode
  mockup_source
  reference_resolution
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

REQUIRED_LAYER_KEYS = %w[
  node_path
  role
  parent_owner
  unity_type
  anchor_pivot_intent
  layout_owner
  geometry_ratios
  split_keep_reason
].freeze

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
  anchor_pivot_intent
  split_keep_reason
  asset_crop_plan_id
].freeze

REQUIRED_CROP_KEYS = %w[
  asset_crop_plan_id
  item_id
  candidate_id
  plan
  source
  nine_slice
  creates_unity_object
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

paths.each do |path|
  data = YAML.load_file(path)
  require_hash(path, data, "document")
  require_keys(path, data, REQUIRED_ROOT_KEYS, "root")

  contract = data.fetch("layout_contract")
  require_hash(path, contract, "layout_contract")
  require_keys(path, contract, REQUIRED_CONTRACT_KEYS, "layout_contract")
  policy = contract.fetch("candidate_policy")
  require_hash(path, policy, "candidate_policy")
  require_keys(path, policy, REQUIRED_POLICY_KEYS, "candidate_policy")

  layer_tree = data.fetch("layer_tree")
  candidates = data.fetch("candidate_item_ledger")
  item_rects = data.fetch("item_rect_plan")
  crop_plans = data.fetch("asset_crop_plan")
  verification_targets = data.fetch("verification_targets")

  require_array(path, layer_tree, "layer_tree")
  require_array(path, candidates, "candidate_item_ledger")
  require_array(path, item_rects, "item_rect_plan")
  require_array(path, crop_plans, "asset_crop_plan")
  require_array(path, verification_targets, "verification_targets")

  layer_paths = layer_tree.map do |layer|
    require_hash(path, layer, "layer_tree entry")
    require_keys(path, layer, REQUIRED_LAYER_KEYS, "layer_tree entry")
    require_rect(path, layer.fetch("geometry_ratios"), "geometry_ratios")
    layer.fetch("node_path")
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
    unless layer_paths.include?(item.fetch("node_path"))
      fail_with(path, "item #{item.fetch('item_id')} node_path is not present in layer_tree")
    end
    item.fetch("candidate_id")
  end

  crop_candidate_ids = crop_plans.map do |crop|
    require_hash(path, crop, "asset_crop_plan entry")
    require_keys(path, crop, REQUIRED_CROP_KEYS, "asset_crop_plan entry")
    crop.fetch("candidate_id")
  end

  accepted = decisions.select { |_id, decision| decision == "accept" }.keys
  held = decisions.select { |_id, decision| decision == "hold" }.keys
  rejected = decisions.select { |_id, decision| decision == "reject" }.keys

  missing_item_rect = accepted - item_rect_candidate_ids
  fail_with(path, "accepted candidates missing item_rect_plan entries: #{missing_item_rect.join(', ')}") unless missing_item_rect.empty?

  disallowed_item_rect = (held + rejected) & item_rect_candidate_ids
  fail_with(path, "held/rejected candidates must not appear in item_rect_plan: #{disallowed_item_rect.join(', ')}") unless disallowed_item_rect.empty?

  disallowed_crop = (held + rejected) & crop_candidate_ids
  fail_with(path, "held/rejected candidates must not appear in asset_crop_plan: #{disallowed_crop.join(', ')}") unless disallowed_crop.empty?

  item_rects.each do |item|
    crop_id = item.fetch("asset_crop_plan_id")
    unless crop_plans.any? { |crop| crop.fetch("asset_crop_plan_id") == crop_id }
      fail_with(path, "item #{item.fetch('item_id')} references missing asset_crop_plan_id: #{crop_id}")
    end
  end

  verification_targets.each do |target|
    require_hash(path, target, "verification target")
    require_keys(path, target, %w[target resolution checks], "verification target")
    require_array(path, target.fetch("checks"), "verification target checks")
  end
end
RUBY
