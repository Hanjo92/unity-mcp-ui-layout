#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FIXTURE_PATH="$ROOT_DIR/tests/forward/ui_toolkit_forward_contract.yaml"

if [[ ! -f "$FIXTURE_PATH" ]]; then
  printf 'Missing UI Toolkit forward contract fixture: %s\n' "$FIXTURE_PATH" >&2
  exit 1
fi

ruby - "$FIXTURE_PATH" <<'RUBY'
require "date"
require "yaml"

path = ARGV.fetch(0)
data = YAML.safe_load(File.read(path), aliases: false)

def fail_with(path, message)
  warn "#{path}: #{message}"
  exit 1
end

def require_hash(path, value, label)
  fail_with(path, "#{label} must be a map") unless value.is_a?(Hash)
end

def require_array(path, value, label, minimum: 1)
  fail_with(path, "#{label} must be a list") unless value.is_a?(Array) && value.length >= minimum
end

def require_string(path, value, label)
  fail_with(path, "#{label} must be a non-empty string") unless value.is_a?(String) && !value.empty?
end

def require_date(path, value, label)
  require_string(path, value, label)
  Date.iso8601(value)
rescue Date::Error
  fail_with(path, "#{label} must be an ISO-8601 date: #{value.inspect}")
end

def require_member(path, values, expected, label)
  fail_with(path, "#{label} missing #{expected.inspect}") unless values.include?(expected)
end

require_hash(path, data, "document")
fail_with(path, "schema_version must be ui-toolkit-forward-contract/v1") unless data.fetch("schema_version") == "ui-toolkit-forward-contract/v1"
fail_with(path, "issue must be 76") unless data.fetch("issue") == 76

execution = data.fetch("execution")
require_hash(path, execution, "execution")
fail_with(path, "execution.mode must be clean-context-llm-forward-test") unless execution.fetch("mode") == "clean-context-llm-forward-test"
fail_with(path, "execution.llm_invocation must be true") unless execution.fetch("llm_invocation") == true
fail_with(path, "execution.automated_by_shell must be false") unless execution.fetch("automated_by_shell") == false
fail_with(path, "execution.status must be pass") unless execution.fetch("status") == "pass"
require_date(path, execution.fetch("recorded_on"), "execution.recorded_on")
require_string(path, execution.fetch("evidence_basis"), "execution.evidence_basis")

scenarios = data.fetch("scenarios")
require_array(path, scenarios, "scenarios", minimum: 3)
expected_ids = %w[
  explicit-ui-toolkit-mockup-prefab-like-rows
  mixed-project-selected-settings-owner
  unity-2022-runtime-inventory
]
actual_ids = scenarios.map { |scenario| scenario.fetch("id") }
fail_with(path, "scenario IDs must be exactly #{expected_ids.inspect}") unless actual_ids == expected_ids

common_forbidden = "automatic UGUI realization"
scenario_contracts = {
  "explicit-ui-toolkit-mockup-prefab-like-rows" => {
    prompt_markers: ["Unity UI Toolkit UI를 만들어줘", "프리팹처럼 구성"],
    must_include: [
      "UI Toolkit selected",
      "mockup-layout-plan/v2",
      "UXML/VisualTreeAsset template",
      "USS",
      "host only if runtime lifecycle needs it",
      "screenshots",
      "console",
      "visual tree"
    ],
    must_not_include: ["Canvas/RectTransform/prefab as the default realization"]
  },
  "mixed-project-selected-settings-owner" => {
    prompt_markers: ["SettingsUIDocument", "SettingsScreen.uxml", "Settings.uss", "UI 스택은 따로 지정하지"],
    must_include: [
      "UI Toolkit from selected target/ownership",
      "SettingsUIDocument",
      "SettingsScreen.uxml",
      "Settings.uss",
      "repair-first",
      "no UGUI fallback"
    ],
    must_not_include: ["UGUI fallback without conflicting project evidence"]
  },
  "unity-2022-runtime-inventory" => {
    prompt_markers: ["Unity 2022 LTS 런타임 인벤토리", "UIDocument가 있는지 모르겠어"],
    must_include: [
      "version evidence",
      "existing host search/reuse or create runtime host",
      "repeated items",
      "selection",
      "data refresh",
      "callbacks",
      "keyboard/gamepad focus",
      "behavior/focus/navigation",
      "no Unity 6 binding assumption"
    ],
    must_not_include: ["Unity 6 binding APIs as an assumed baseline", "UGUI fallback without runtime evidence"]
  }
}

scenarios.each do |scenario|
  scenario_id = scenario.fetch("id")
  contract = scenario_contracts.fetch(scenario_id)
  require_hash(path, scenario, "scenario #{scenario_id}")
  require_string(path, scenario.fetch("prompt"), "scenario #{scenario_id}.prompt")
  require_date(path, scenario.fetch("executed_on"), "scenario #{scenario_id}.executed_on")
  fail_with(path, "scenario #{scenario_id}.pass_status must be pass") unless scenario.fetch("pass_status") == "pass"

  prompt = scenario.fetch("prompt")
  contract.fetch(:prompt_markers).each do |marker|
    fail_with(path, "scenario #{scenario_id}.prompt missing exact marker #{marker.inspect}") unless prompt.include?(marker)
  end

  expected = scenario.fetch("expected")
  require_hash(path, expected, "scenario #{scenario_id}.expected")
  must_include = expected.fetch("must_include")
  must_not_include = expected.fetch("must_not_include")
  require_array(path, must_include, "scenario #{scenario_id}.expected.must_include")
  require_array(path, must_not_include, "scenario #{scenario_id}.expected.must_not_include")
  contract.fetch(:must_include).each { |concept| require_member(path, must_include, concept, "scenario #{scenario_id}.must_include") }
  require_member(path, must_not_include, common_forbidden, "scenario #{scenario_id}.must_not_include")
  contract.fetch(:must_not_include).each { |concept| require_member(path, must_not_include, concept, "scenario #{scenario_id}.must_not_include") }

  observed = scenario.fetch("observed_outcome_summary")
  require_string(path, observed, "scenario #{scenario_id}.observed_outcome_summary")
  require_string(path, scenario.fetch("evidence_note"), "scenario #{scenario_id}.evidence_note")
end

printf "UI Toolkit forward contract fixture passed: %s\n", path
RUBY
