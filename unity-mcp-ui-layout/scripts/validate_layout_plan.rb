#!/usr/bin/env ruby
# Validates planning data only; does not inspect Unity or prove visual fidelity.
require "yaml"

template_mode = ARGV.delete("--template")
paths = ARGV
abort "Usage: ruby validate_layout_plan.rb [--template] plan.yaml [...]" if paths.empty?

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
  mockup_resolution
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
REQUIRED_UI_TOOLKIT_REALIZATION_KEYS = %w[root_uxml stylesheets].freeze
TEMPLATE_UI_STACK = "<UGUI|UI Toolkit>"
TEMPLATE_TARGET_SURFACE = "<runtime|editor>"
TEMPLATE_REUSABLE_ASSET_TYPE = "<prefab|uxml-template>"
TARGET_SURFACES = %w[runtime editor].freeze

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
  review_source
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
STRING_KEYS = %w[
  schema_version ui_stack mode mockup_source mockup_resolution target_resolution
  root_owner structure_rule accepted held rejected node_path role parent_owner
  node_kind layout_owner placement_intent split_keep_reason target_surface
  reusable_asset_type canvas_root reference_resolution root_uxml behavior_owner
  candidate_id confidence_band suggested_role parent_hint crop_padding
  review_decision review_source decision_note item_id fit_mode asset_plan_id
  plan source behavior_id owner intent target resolution
].freeze

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

def require_string_list(path, value, label)
  require_array(path, value, label)
  unless value.all? { |entry| entry.is_a?(String) && !entry.strip.empty? }
    fail_with(path, "#{label} must contain non-empty strings")
  end
end

def require_array_type(path, value, label)
  fail_with(path, "#{label} must be a list") unless value.is_a?(Array)
end

def require_keys(path, hash, keys, label)
  missing = keys.reject { |key| hash.key?(key) }
  fail_with(path, "#{label} missing keys: #{missing.join(', ')}") unless missing.empty?
  (keys & STRING_KEYS).each do |key|
    unless hash[key].is_a?(String) && !hash[key].strip.empty?
      fail_with(path, "#{label}.#{key} must be a non-empty string")
    end
  end
end

def require_rect(path, rect, label)
  require_hash(path, rect, label)
  require_keys(path, rect, REQUIRED_RECT_KEYS, label)
  REQUIRED_RECT_KEYS.each do |key|
    value = rect[key]
    unless value.is_a?(Numeric) && value.finite?
      fail_with(path, "#{label}.#{key} must be a finite number")
    end
  end
  unless rect["width"] > 0 && rect["height"] > 0
    fail_with(path, "#{label} width and height must be positive")
  end
end

def resolution(path, value, label)
  unless value.is_a?(String) && value.match?(/\A[1-9]\d*x[1-9]\d*\z/)
    fail_with(path, "#{label} must be positive WIDTHxHEIGHT")
  end
  value.split("x").map(&:to_f)
end

def require_bounds(path, rect, width, height, label)
  if rect["x"] < 0 || rect["y"] < 0 || rect["x"] + rect["width"] > width + 0.0001 || rect["y"] + rect["height"] > height + 0.0001
    fail_with(path, "#{label} exceeds source frame")
  end
end

def require_close_rect(path, actual, expected, tolerance, label)
  unless REQUIRED_RECT_KEYS.all? { |key| (actual[key] - expected[key]).abs <= tolerance }
    fail_with(path, "#{label} does not match derived geometry")
  end
end

def check_scalar_content(path, value, template_mode)
  case value
  when Hash
    value.each_value { |child| check_scalar_content(path, child, template_mode) }
  when Array
    value.each { |child| check_scalar_content(path, child, template_mode) }
  when String
    fail_with(path, "blank string is not concrete plan data") if value.strip.empty?
    if !template_mode && value.match?(/<[^>]+>/)
      fail_with(path, "unresolved placeholder in concrete plan")
    end
  when NilClass
    fail_with(path, "null is not concrete plan data")
  end
end

def require_unique(path, values, label)
  duplicates = values.group_by(&:itself).select { |_value, occurrences| occurrences.length > 1 }.keys
  fail_with(path, "duplicate #{label}: #{duplicates.join(', ')}") unless duplicates.empty?
end

def recursively_find_ugui_keys(value, found = [])
  case value
  when Hash
    value.each do |key, nested_value|
      key_name = key.to_s
      if %w[creates_unity_object reference_resolution unity_type].include?(key_name) ||
          key_name.match?(/anchor|prefab|canvas|rect_?transform|layout_?element/i)
        found << key_name
      end
      recursively_find_ugui_keys(nested_value, found)
    end
  when Array
    value.each { |nested_value| recursively_find_ugui_keys(nested_value, found) }
  end
  found
end

NARRATIVE_KEYS = %w[
  accepted held rejected evidence decision_note split_keep_reason intent plan
  structure_rule checks mockup_source target
].freeze

def recursively_find_ugui_values(value, parent_key = nil, found = [])
  case value
  when Hash
    value.each do |key, nested_value|
      recursively_find_ugui_values(nested_value, key.to_s, found)
    end
  when Array
    value.each { |nested_value| recursively_find_ugui_values(nested_value, parent_key, found) }
  when String
    return found if NARRATIVE_KEYS.include?(parent_key)

    if value.match?(/\b(?:RectTransform|LayoutElement|Canvas|prefab)\b/i) || value.match?(/\.prefab\z/i)
      found << value
    end
  end
  found
end

paths.each do |path|
  begin
    data = YAML.safe_load(File.read(path), permitted_classes: [], permitted_symbols: [], aliases: false)
  rescue Psych::Exception, SystemCallError => error
    fail_with(path, "cannot read plan: #{error.message}")
  end
  require_hash(path, data, "document")
  require_keys(path, data, REQUIRED_ROOT_KEYS, "root")
  unexpected_root_keys = data.keys - REQUIRED_ROOT_KEYS
  fail_with(path, "root has unexpected keys: #{unexpected_root_keys.join(', ')}") unless unexpected_root_keys.empty?
  fail_with(path, "schema_version must be mockup-layout-plan/v2") unless data.fetch("schema_version") == "mockup-layout-plan/v2"

  contract = data.fetch("layout_contract")
  require_hash(path, contract, "layout_contract")
  require_keys(path, contract, REQUIRED_CONTRACT_KEYS, "layout_contract")
  check_scalar_content(path, data, template_mode)
  unless %w[build repair].include?(contract["mode"])
    fail_with(path, "layout_contract mode must be build or repair")
  end
  if !template_mode
    source_width, source_height = resolution(path, contract["mockup_resolution"], "mockup_resolution")
    target_width, target_height = resolution(path, contract["target_resolution"], "target_resolution")
  end
  policy = contract.fetch("candidate_policy")
  require_hash(path, policy, "candidate_policy")
  require_keys(path, policy, REQUIRED_POLICY_KEYS, "candidate_policy")

  stack_realization = data.fetch("stack_realization")
  require_hash(path, stack_realization, "stack_realization")
  require_keys(path, stack_realization, REQUIRED_REALIZATION_KEYS, "stack_realization")

  ui_stack = contract.fetch("ui_stack")
  target_surface = stack_realization.fetch("target_surface")
  behavior_plan = data.fetch("behavior_plan")
  require_array_type(path, behavior_plan, "behavior_plan")

  if ui_stack == TEMPLATE_UI_STACK
    fail_with(path, "template requires --template") unless template_mode
    unless target_surface == TEMPLATE_TARGET_SURFACE
      fail_with(path, "template target_surface must be #{TEMPLATE_TARGET_SURFACE}")
    end
    unless stack_realization.fetch("reusable_asset_type") == TEMPLATE_REUSABLE_ASSET_TYPE
      fail_with(path, "template reusable_asset_type must be #{TEMPLATE_REUSABLE_ASSET_TYPE}")
    end

    ugui = stack_realization["ugui"]
    ui_toolkit = stack_realization["ui_toolkit"]
    require_hash(path, ugui, "stack_realization.ugui template stub")
    require_hash(path, ui_toolkit, "stack_realization.ui_toolkit template stub")
    require_keys(path, ugui, REQUIRED_UGUI_REALIZATION_KEYS, "stack_realization.ugui template stub")
    require_keys(path, ui_toolkit, REQUIRED_UI_TOOLKIT_REALIZATION_KEYS, "stack_realization.ui_toolkit template stub")
    require_array(path, ui_toolkit.fetch("stylesheets"), "stack_realization.ui_toolkit stylesheets")
    require_keys(path, ui_toolkit, %w[behavior_owner], "stack_realization.ui_toolkit template stub") unless behavior_plan.empty?
  else
    unless TARGET_SURFACES.include?(target_surface)
      fail_with(path, "stack_realization target_surface must be runtime or editor")
    end

    fail_with(path, "--template requires template ui_stack") if template_mode
    realization_key = ui_stack == "UGUI" ? "ugui" : "ui_toolkit"
    realization = stack_realization[realization_key]
    require_hash(path, realization, "stack_realization.#{realization_key}")

    case ui_stack
    when "UGUI"
      if stack_realization.key?("ui_toolkit")
        fail_with(path, "UGUI plan must not define stack_realization.ui_toolkit")
      end
      require_keys(path, realization, REQUIRED_UGUI_REALIZATION_KEYS, "stack_realization.ugui")
      resolution(path, realization["reference_resolution"], "reference_resolution")
      fail_with(path, "UGUI reusable_asset_type must be prefab") unless stack_realization["reusable_asset_type"] == "prefab"
    when "UI Toolkit"
      if stack_realization.key?("ugui")
        fail_with(path, "UI Toolkit plan must not define stack_realization.ugui")
      end
      require_keys(path, realization, REQUIRED_UI_TOOLKIT_REALIZATION_KEYS, "stack_realization.ui_toolkit")
      require_string_list(path, realization.fetch("stylesheets"), "stack_realization.ui_toolkit stylesheets")
      require_keys(path, realization, %w[behavior_owner], "stack_realization.ui_toolkit") unless behavior_plan.empty?
      unless stack_realization.fetch("reusable_asset_type") == "uxml-template"
        fail_with(path, "stack_realization reusable_asset_type must be uxml-template for UI Toolkit")
      end
      forbidden_keys = recursively_find_ugui_keys(data)
      unless forbidden_keys.empty?
        fail_with(path, "UI Toolkit plan contains forbidden UGUI-only keys: #{forbidden_keys.uniq.join(', ')}")
      end
      forbidden_values = recursively_find_ugui_values(data)
      unless forbidden_values.empty?
        fail_with(path, "UI Toolkit plan contains forbidden UGUI-only values: #{forbidden_values.uniq.join(', ')}")
      end
    else
      fail_with(path, "layout_contract ui_stack must be UGUI or UI Toolkit")
    end
  end

  layout_tree = data.fetch("layout_tree")
  candidates = data.fetch("candidate_item_ledger")
  item_rects = data.fetch("item_rect_plan")
  asset_plans = data.fetch("asset_plan")
  verification_targets = data.fetch("verification_targets")

  require_array(path, layout_tree, "layout_tree")
  require_array_type(path, candidates, "candidate_item_ledger")
  require_array_type(path, item_rects, "item_rect_plan")
  require_array_type(path, asset_plans, "asset_plan")
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

  root_node = layout_tree.find { |node| node["node_path"] == root_owner }
  if layout_paths.include?(root_node["parent_owner"])
    fail_with(path, "root parent_owner must be outside the planned tree")
  end
  layout_tree.each do |node|
    unless node["node_path"] == root_owner || node["node_path"].start_with?(root_owner + "/")
      fail_with(path, "layout node must descend from root_owner")
    end
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
    unless %w[high medium low].include?(candidate["confidence_band"])
      fail_with(path, "invalid confidence_band")
    end
    unless %w[user agent].include?(candidate["review_source"])
      fail_with(path, "review_source must be user or agent")
    end
    if candidate["review_source"] == "agent" && candidate["review_decision"] == "accept" && candidate["confidence_band"] != "high"
      fail_with(path, "agent acceptance requires high confidence")
    end
    unless [true, false].include?(candidate["nine_slice_candidate"])
      fail_with(path, "nine_slice_candidate must be boolean")
    end
    require_bounds(path, candidate["source_bounds"], source_width, source_height, "source_bounds") unless template_mode
    decision = candidate.fetch("review_decision")
    unless %w[accept hold reject].include?(decision)
      fail_with(path, "candidate #{candidate.fetch('candidate_id')} has invalid review_decision: #{decision}")
    end
    evidence = candidate.fetch("evidence")
    require_string_list(path, evidence, "candidate evidence")
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
    %w[nine_slice creates_runtime_node].each do |key|
      fail_with(path, "#{key} must be boolean") unless [true, false].include?(asset[key])
    end
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

  item_rects.each do |item|
    candidate = candidates.find { |entry| entry["candidate_id"] == item["candidate_id"] }
    node = layout_tree.find { |entry| entry["node_path"] == item["node_path"] }
    unless node["parent_owner"] == candidate["parent_hint"]
      fail_with(path, "item node parent must match candidate parent_hint")
    end
    require_close_rect(path, item["source_rect"], candidate["source_bounds"], 0.0001, "source_rect/source_bounds")
    next if template_mode

    rect = item["source_rect"]
    require_bounds(path, rect, source_width, source_height, "source_rect")
    expected = {"x" => rect["x"] / source_width, "y" => rect["y"] / source_height,
                "width" => rect["width"] / source_width, "height" => rect["height"] / source_height}
    require_close_rect(path, item["normalized_rect"], expected, 0.0001, "normalized_rect")
    require_close_rect(path, node["geometry_ratios"], expected, 0.0001, "item node geometry_ratios")
    parent = layout_tree.find { |entry| entry["node_path"] == node["parent_owner"] }
    local = rect.merge("x" => rect["x"] - parent["geometry_ratios"]["x"] * source_width,
                       "y" => rect["y"] - parent["geometry_ratios"]["y"] * source_height)
    require_close_rect(path, item["parent_local_rect"], local, 1.0, "parent_local_rect")
  end

  sizes = []
  verification_targets.each do |target|
    require_hash(path, target, "verification target")
    require_keys(path, target, %w[target resolution checks], "verification target")
    require_string_list(path, target.fetch("checks"), "verification target checks")
    sizes << resolution(path, target["resolution"], "verification resolution") unless template_mode
  end
  unless template_mode
    unless sizes.include?([target_width, target_height])
      fail_with(path, "verification must include target_resolution")
    end
    main_ratio = target_width / target_height
    unless sizes.any? { |width, height| ((width / height) / main_ratio - 1).abs >= 0.05 }
      fail_with(path, "verification needs an alternate aspect ratio differing by at least 5%")
    end
  end
  puts "Validated #{path} (#{template_mode ? 'template only' : 'planning data only'})"
end
