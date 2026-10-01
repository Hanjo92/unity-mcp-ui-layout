#!/usr/bin/env ruby
require "minitest/autorun"
require "yaml"
require "open3"
require "tmpdir"
require "fileutils"
require "rbconfig"

class LayoutPlanSemanticsTest < Minitest::Test
  ROOT = File.expand_path("..", __dir__)
  SKILL = File.join(ROOT, "unity-mcp-ui-layout")
  VALIDATOR = File.join(SKILL, "scripts/validate_layout_plan.rb")

  def plan
    YAML.load_file(File.join(ROOT, "examples/mockup-layout-plan-ui-toolkit-example.yaml"))
  end

  def validate(data, validator: VALIDATOR, extra: [])
    Dir.mktmpdir("layout-plan-test") do |dir|
      path = File.join(dir, "plan.yaml")
      File.write(path, YAML.dump(data))
      output, status = Open3.capture2e(RbConfig.ruby, validator, *extra, path)
      [output, status.success?]
    end
  end

  def accepts(data)
    output, success = validate(data)
    assert success, output
  end

  def rejects(data, reason)
    output, success = validate(data)
    refute success, "Invalid plan accepted: #{reason}"
    assert_includes output, reason
  end

  def test_no_raster_candidates_does_not_require_fabricated_items
    data = plan
    %w[candidate_item_ledger item_rect_plan asset_plan behavior_plan].each { |key| data[key] = [] }
    data["stack_realization"]["ui_toolkit"].delete("behavior_owner")
    accepts(data)
  end

  def test_source_and_target_are_independent
    data = plan
    data["layout_contract"]["target_resolution"] = "1280x720"
    data["verification_targets"][0]["resolution"] = "1280x720"
    data["verification_targets"][1]["resolution"] = "960x720"
    accepts(data)
  end

  def test_user_review_can_accept_medium_confidence_with_recorded_decision
    data = plan
    candidate = data["candidate_item_ledger"][0]
    candidate["confidence_band"] = "medium"
    candidate["review_source"] = "user"
    candidate["decision_note"] = "User explicitly confirmed the icon boundary and split."
    accepts(data)
  end

  INVALID_CASES = {
    "numeric_node_path" => ["node_path must be a non-empty string", ->(d) { d["layout_tree"][1]["node_path"] = 1 }],
    "nontext_evidence" => ["must contain non-empty strings", ->(d) { d["candidate_item_ledger"][0]["evidence"] = [true] }],
    "nontext_stylesheet" => ["must contain non-empty strings", ->(d) { d["stack_realization"]["ui_toolkit"]["stylesheets"] = [42] }],
    "numeric_string" => ["finite number", ->(d) { d["item_rect_plan"][0]["source_rect"]["x"] = "230" }],
    "zero_width" => ["must be positive", ->(d) { d["item_rect_plan"][0]["source_rect"]["width"] = 0 }],
    "infinite_geometry" => ["finite number", ->(d) { d["layout_tree"][0]["geometry_ratios"]["x"] = Float::INFINITY }],
    "negative_source" => ["exceeds source frame", ->(d) { d["candidate_item_ledger"][0]["source_bounds"]["x"] = -1 }],
    "outside_source" => ["exceeds source frame", ->(d) { d["candidate_item_ledger"][0]["source_bounds"]["width"] = 3000 }],
    "target_used_for_normalization" => ["normalized_rect", ->(d) { d["item_rect_plan"][0]["normalized_rect"]["x"] = 230.0 / 1280 }],
    "wrong_local_origin" => ["parent_local_rect", ->(d) { d["item_rect_plan"][0]["parent_local_rect"]["y"] = -24 }],
    "parent_as_leaf" => ["item node parent", ->(d) { d["item_rect_plan"][0]["node_path"] = "QuestScreen/QuestList/QuestRow" }],
    "leaf_geometry_drift" => ["item node geometry_ratios", ->(d) { d["layout_tree"].last["geometry_ratios"]["width"] = 0.2 }],
    "source_ledger_drift" => ["source_rect/source_bounds", ->(d) { d["candidate_item_ledger"][0]["source_bounds"]["x"] += 10 }],
    "medium_auto_accept" => ["requires high confidence", ->(d) { d["candidate_item_ledger"][0]["confidence_band"] = "medium" }],
    "missing_review_source" => ["missing keys: review_source", ->(d) { d["candidate_item_ledger"][0].delete("review_source") }],
    "invented_review_source" => ["user or agent", ->(d) { d["candidate_item_ledger"][0]["review_source"] = "automatic approval" }],
    "held_promoted" => ["held/rejected", ->(d) { d["candidate_item_ledger"][0]["review_decision"] = "hold" }],
    "rejected_promoted" => ["held/rejected", ->(d) { d["candidate_item_ledger"][0]["review_decision"] = "reject" }],
    "missing_source_dimensions" => ["mockup_resolution", ->(d) { d["layout_contract"].delete("mockup_resolution") }],
    "bad_resolution" => ["positive WIDTHxHEIGHT", ->(d) { d["layout_contract"]["mockup_resolution"] = "0x1080" }],
    "same_aspect" => ["alternate aspect ratio", ->(d) { d["verification_targets"][1]["resolution"] = "1600x900" }],
    "almost_same_aspect" => ["alternate aspect ratio", ->(d) { d["verification_targets"][1]["resolution"] = "1366x768" }],
    "main_not_verified" => ["include target_resolution", ->(d) { d["verification_targets"][0]["resolution"] = "1280x720" }],
    "placeholder" => ["unresolved placeholder", ->(d) { d["stack_realization"]["ui_toolkit"]["root_uxml"] = "<path>" }],
    "invalid_mode" => ["build or repair", ->(d) { d["layout_contract"]["mode"] = "whatever" }],
    "fake_boolean" => ["must be boolean", ->(d) { d["asset_plan"][0]["creates_runtime_node"] = "false" }],
    "root_cycle" => ["outside the planned tree", ->(d) { d["layout_tree"][0]["parent_owner"] = "QuestScreen/QuestList" }],
    "ugui_wrong_reuse" => ["must be prefab", ->(d) {
      d.replace(YAML.load_file(File.join(ROOT, "examples/mockup-layout-plan-prefab-example.yaml")))
      d["stack_realization"]["reusable_asset_type"] = "uxml-template"
    }]
  }.freeze

  INVALID_CASES.each do |name, (reason, mutate)|
    define_method("test_rejects_#{name}") do
      data = plan
      mutate.call(data)
      rejects(data, reason)
    end
  end

  def test_packaged_skill_runs_without_repository_siblings
    Dir.mktmpdir("installed-layout-skill") do |dir|
      FileUtils.cp_r(SKILL, dir)
      installed = File.join(dir, "unity-mcp-ui-layout")
      validator = File.join(installed, "scripts/validate_layout_plan.rb")
      output, success = validate(plan, validator: validator)
      assert success, output
      template = File.join(installed, "templates/mockup-layout-plan.yaml")
      output, status = Open3.capture2e(RbConfig.ruby, validator, "--template", template)
      assert status.success?, output
      _, status = Open3.capture2e(RbConfig.ruby, validator, template)
      refute status.success?, "An unresolved template must not pass as a concrete plan"
    end
  end

  def test_public_template_matches_packaged_source
    assert_equal File.binread(File.join(SKILL, "templates/mockup-layout-plan.yaml")),
                 File.binread(File.join(ROOT, "templates/mockup-layout-plan.yaml"))
  end
end
