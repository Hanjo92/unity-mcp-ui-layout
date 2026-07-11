# First-Class UI Toolkit Workflow Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make UI Toolkit a first-class mockup-to-Unity-UI path with stack-native planning, assets, MCP execution, reuse, behavior, and verification while preserving UGUI.

**Architecture:** Keep one stack-neutral layout contract and route it through UGUI or UI Toolkit realization fields. Put selection and UI Toolkit details in focused references, keep `SKILL.md` procedural, and use stack-specific schema validation plus clean-context forward tests to prevent UGUI vocabulary from leaking into UI Toolkit output.

**Tech Stack:** Markdown skill instructions, YAML planning artifacts, Bash keyword tests, Ruby YAML validation, GitHub issue #76.

---

### Task 1: Stack Selection and Public Trigger Contract

**Files:**
- Create: `tests/ui_stack_selection_keywords.sh`
- Create: `unity-mcp-ui-layout/references/ui-stack-selection.md`
- Modify: `unity-mcp-ui-layout/SKILL.md`
- Modify: `unity-mcp-ui-layout/agents/openai.yaml`
- Modify: `unity-mcp-ui-layout/references/agent-runbook.md`
- Modify: `unity-mcp-ui-layout/references/layout-snapshot-contract.md`
- Modify: `unity-mcp-ui-layout/references/review-gates-and-assumptions.md`

- [ ] **Step 1: Write the failing stack-selection test**

Create a Bash keyword test using the repository's existing `assert_contains` pattern. It must require these exact concepts from the indicated surfaces:

```bash
assert_contains "$skill_surface" "explicit user instruction" "skill stack router"
assert_contains "$selection_doc" "selected target" "stack selection"
assert_contains "$selection_doc" "target_surface" "stack selection"
assert_contains "$selection_doc" "runtime" "stack selection"
assert_contains "$selection_doc" "editor" "stack selection"
assert_contains "$selection_doc" "Unity version" "stack selection"
assert_contains "$selection_doc" "installed-package presence alone" "stack selection"
assert_contains "$snapshot_doc" "unity_version" "snapshot contract"
assert_contains "$snapshot_doc" "target_surface" "snapshot contract"
assert_contains "$agent_metadata" "UXML/USS" "agent metadata"
```

- [ ] **Step 2: Run the test and verify RED**

Run: `bash -n tests/ui_stack_selection_keywords.sh && bash tests/ui_stack_selection_keywords.sh`

Expected: FAIL because `ui-stack-selection.md` and the required precedence/version/surface wording do not exist.

- [ ] **Step 3: Implement the minimal selection contract**

Add `ui-stack-selection.md` with this precedence and decision behavior:

```text
explicit user instruction
named target or selected UI root
existing screen ownership
project conventions and nearby reusable assets
clarify only when evidence remains mixed
```

Require `target_surface: runtime | editor`, Unity version evidence, and a rule that package presence alone is not decisive. Update `SKILL.md`, snapshot intake, runbook, assumptions, and agent metadata so explicit UI Toolkit requests and UI Toolkit-owned targets route before prefab/Canvas defaults.

- [ ] **Step 4: Run focused and regression tests**

Run:

```bash
bash -n tests/ui_stack_selection_keywords.sh
bash tests/ui_stack_selection_keywords.sh
bash tests/trigger_keywords.sh
bash tests/layout_snapshot_keywords.sh
bash tests/agent_runbook_keywords.sh
bash tests/review_gates_keywords.sh
```

Expected: all commands exit 0.

- [ ] **Step 5: Commit**

```bash
git add tests/ui_stack_selection_keywords.sh unity-mcp-ui-layout/SKILL.md unity-mcp-ui-layout/agents/openai.yaml unity-mcp-ui-layout/references/ui-stack-selection.md unity-mcp-ui-layout/references/agent-runbook.md unity-mcp-ui-layout/references/layout-snapshot-contract.md unity-mcp-ui-layout/references/review-gates-and-assumptions.md
git commit -m "feat: add UI stack selection contract"
```

### Task 2: Stack-Neutral Mockup Plan Schema

**Files:**
- Modify: `templates/mockup-layout-plan.yaml`
- Modify: `examples/mockup-layout-plan-prefab-example.yaml`
- Create: `examples/mockup-layout-plan-ui-toolkit-example.yaml`
- Modify: `tests/mockup_layout_plan_schema.sh`
- Modify: `unity-mcp-ui-layout/references/image-to-layout.md`
- Modify: `unity-mcp-ui-layout/references/mockup-decomposition.md`
- Modify: `unity-mcp-ui-layout/references/layout-snapshot-contract.md`
- Modify: `unity-mcp-ui-layout/references/review-checks.md`

- [ ] **Step 1: Extend the schema test before changing artifacts**

Require v2 common fields and both stack branches:

```ruby
REQUIRED_LAYER_KEYS = %w[
  node_path role parent_owner node_kind layout_owner
  placement_intent geometry_ratios split_keep_reason
].freeze

REQUIRED_REALIZATION_KEYS = %w[target_surface reusable_asset_type].freeze
UGUI_REALIZATION_KEYS = %w[canvas_root reference_resolution].freeze
UI_TOOLKIT_REALIZATION_KEYS = %w[root_uxml stylesheets behavior_owner].freeze
```

For `UI Toolkit`, reject UGUI-only keys recursively:

```ruby
forbidden = %w[anchor_pivot_intent creates_unity_object prefab_source]
```

Load and validate the template, the UGUI example, and `examples/mockup-layout-plan-ui-toolkit-example.yaml`.

- [ ] **Step 2: Run the schema test and verify RED**

Run: `bash -n tests/mockup_layout_plan_schema.sh && bash tests/mockup_layout_plan_schema.sh`

Expected: FAIL because the v2 common fields, realization branches, and UI Toolkit example are missing.

- [ ] **Step 3: Implement the v2 neutral contract**

Use these root sections:

```yaml
schema_version: "mockup-layout-plan/v2"
layout_contract: {}
stack_realization: {}
layout_tree: []
candidate_item_ledger: []
item_rect_plan: []
asset_plan: []
behavior_plan: []
verification_targets: []
```

The UGUI example must populate `stack_realization.ugui`. The UI Toolkit example must populate `stack_realization.ui_toolkit` with `target_surface`, `root_uxml`, `stylesheets`, optional `panel_settings`, `reusable_asset_type: uxml-template`, and `behavior_owner`. Use `placement_intent` and `creates_runtime_node` in common entries.

- [ ] **Step 4: Align shared decomposition and review language**

Replace generic mandatory Transform wording with `layout tree`, then describe stack realization explicitly:

```text
UGUI -> Transform/RectTransform tree, anchors, layout components, prefab roots
UI Toolkit -> visual tree, UXML templates, flex/style owners, optional behavior owner
```

Keep item rect, candidate review, and crop safety behavior unchanged.

- [ ] **Step 5: Run focused and regression tests**

Run:

```bash
bash tests/mockup_layout_plan_schema.sh
bash tests/layer_tree_keywords.sh
bash tests/item_rect_keywords.sh
bash tests/item_candidate_keywords.sh
bash tests/layout_snapshot_keywords.sh
bash tests/review_gates_keywords.sh
```

Expected: all commands exit 0 and both stack examples validate.

- [ ] **Step 6: Commit**

```bash
git add templates/mockup-layout-plan.yaml examples/mockup-layout-plan-prefab-example.yaml examples/mockup-layout-plan-ui-toolkit-example.yaml tests/mockup_layout_plan_schema.sh unity-mcp-ui-layout/references/image-to-layout.md unity-mcp-ui-layout/references/mockup-decomposition.md unity-mcp-ui-layout/references/layout-snapshot-contract.md unity-mcp-ui-layout/references/review-checks.md
git commit -m "feat: add stack-neutral mockup plan schema"
```

### Task 3: UI Toolkit Build, Reuse, Behavior, and MCP Workflow

**Files:**
- Create: `tests/ui_toolkit_build_keywords.sh`
- Create: `unity-mcp-ui-layout/references/ui-toolkit-build-workflow.md`
- Create: `examples/ui-toolkit-from-mockup-example.md`
- Modify: `unity-mcp-ui-layout/references/ui-toolkit-layout-rules.md`
- Modify: `unity-mcp-ui-layout/references/ui-toolkit-failures.md`
- Modify: `unity-mcp-ui-layout/references/mcp-call-recipes.md`
- Modify: `unity-mcp-ui-layout/references/prompt-patterns.md`
- Modify: `unity-mcp-ui-layout/references/prefab-reuse.md`
- Modify: `unity-mcp-ui-layout/references/prefab-variants.md`
- Modify: `unity-mcp-ui-layout/references/shared-asset-edit-safety.md`
- Modify: `unity-mcp-ui-layout/references/review-checks.md`
- Modify: `unity-mcp-ui-layout/SKILL.md`

- [ ] **Step 1: Write the failing UI Toolkit build test**

Require the build workflow and routing surfaces to contain:

```bash
assert_contains "$build_doc" "manage_ui" "UI Toolkit build workflow"
assert_contains "$build_doc" "create_panel_settings" "UI Toolkit build workflow"
assert_contains "$build_doc" "attach_ui_document" "UI Toolkit build workflow"
assert_contains "$build_doc" "get_visual_tree" "UI Toolkit build workflow"
assert_contains "$build_doc" "VisualTreeAsset" "UI Toolkit build workflow"
assert_contains "$build_doc" "UXML template" "UI Toolkit build workflow"
assert_contains "$build_doc" "runtime" "UI Toolkit build workflow"
assert_contains "$build_doc" "Editor UI" "UI Toolkit build workflow"
assert_contains "$build_doc" "binding" "UI Toolkit build workflow"
assert_contains "$build_doc" "focus" "UI Toolkit build workflow"
assert_contains "$build_doc" "navigation" "UI Toolkit build workflow"
assert_contains "$build_doc" "tool limitation" "UI Toolkit build workflow"
assert_contains "$mcp_doc" "Build UI Toolkit From a Mockup" "MCP recipes"
assert_contains "$reuse_doc" "host prefab" "reuse guidance"
assert_contains "$example_doc" "reusable UXML template" "UI Toolkit example"
```

- [ ] **Step 2: Run the test and verify RED**

Run: `bash -n tests/ui_toolkit_build_keywords.sh && bash tests/ui_toolkit_build_keywords.sh`

Expected: FAIL because the build workflow, recipe, and example do not exist.

- [ ] **Step 3: Implement the UI Toolkit build adapter**

Document the concrete sequence:

```text
project/editor state -> target assets -> layout plan -> UXML -> USS
-> PanelSettings/UIDocument or Editor owner -> visual tree
-> optional C# behavior -> import/compile/console -> screenshots and interaction checks
```

Specify that UI Toolkit "prefab" intent defaults to a UXML template plus USS classes. Create a UIDocument host prefab only for explicit host reuse or scene lifecycle. Cover runtime versus Editor ownership, Unity-version checks before version-sensitive binding, stable element names/classes, callbacks/bindings, state classes, focus/navigation, shared UXML/USS/PanelSettings safety, and honest fallbacks when MCP cannot inspect computed styles or inject events.

- [ ] **Step 4: Run focused and regression tests**

Run:

```bash
bash tests/ui_toolkit_build_keywords.sh
bash tests/ui_stack_selection_keywords.sh
bash tests/mockup_layout_plan_schema.sh
bash tests/review_gates_keywords.sh
bash tests/trigger_keywords.sh
```

Expected: all commands exit 0.

- [ ] **Step 5: Commit**

```bash
git add tests/ui_toolkit_build_keywords.sh unity-mcp-ui-layout/SKILL.md unity-mcp-ui-layout/references/ui-toolkit-build-workflow.md unity-mcp-ui-layout/references/ui-toolkit-layout-rules.md unity-mcp-ui-layout/references/ui-toolkit-failures.md unity-mcp-ui-layout/references/mcp-call-recipes.md unity-mcp-ui-layout/references/prompt-patterns.md unity-mcp-ui-layout/references/prefab-reuse.md unity-mcp-ui-layout/references/prefab-variants.md unity-mcp-ui-layout/references/shared-asset-edit-safety.md unity-mcp-ui-layout/references/review-checks.md examples/ui-toolkit-from-mockup-example.md
git commit -m "feat: add UI Toolkit mockup build workflow"
```

### Task 4: Discovery, Platform Sync, and Full Validation

**Files:**
- Create: `tests/ui_toolkit_docs_keywords.sh`
- Modify: `unity-mcp-ui-layout/references/README.md`
- Modify: `examples/README.md`
- Modify: `README.md`
- Modify: `Platform/Codex/README.md`
- Modify: `Platform/Google-Antigravity/SYSTEM_PROMPT.md`
- Modify: `Platform/Claude-Artifacts/ARTIFACT_PROMPT.md`
- Modify: `CONTRIBUTING.md`
- Modify: `MAINTENANCE.md`
- Modify: `RELEASE_CHECKLIST.md`
- Modify: `CHANGELOG.md`
- Modify: `tests/trigger_keywords.sh`
- Modify: `tests/layer_tree_keywords.sh`

- [ ] **Step 1: Write the failing discovery-sync test**

Require every public entry point to link the two new references and build example:

```bash
assert_contains "$references_index" "ui-stack-selection.md" "references index"
assert_contains "$references_index" "ui-toolkit-build-workflow.md" "references index"
assert_contains "$examples_index" "ui-toolkit-from-mockup-example.md" "examples index"
assert_contains "$root_readme" "VisualTreeAsset" "root README"
assert_contains "$platform_docs" "UXML template" "platform adapters"
assert_contains "$maintenance_docs" "ui_toolkit_build_keywords.sh" "maintenance docs"
```

- [ ] **Step 2: Run the test and verify RED**

Run: `bash -n tests/ui_toolkit_docs_keywords.sh && bash tests/ui_toolkit_docs_keywords.sh`

Expected: FAIL because navigation, platform, and maintenance surfaces are not synchronized.

- [ ] **Step 3: Synchronize public documentation and adapters**

Add concise UI Toolkit build discoverability without duplicating the detailed reference. Update the changelog's Unreleased section in English and Korean. Add the new tests to maintenance and release command lists. Update platform adapters so their neutral mockup hierarchy language routes to either UGUI or UI Toolkit realization.

- [ ] **Step 4: Run complete local validation**

Run:

```bash
for test_file in tests/*.sh; do
  bash -n "$test_file"
  bash "$test_file"
done
python /Users/song/.codex/skills/.system/skill-creator/scripts/quick_validate.py unity-mcp-ui-layout
ruby -e 'require "yaml"; Dir["templates/*.yaml", "examples/*.yaml"].each { |path| YAML.load_file(path) }; puts "yaml ok"'
git diff --check
```

Expected: every command exits 0, skill validation prints `Skill is valid!`, and YAML validation prints `yaml ok`.

- [ ] **Step 5: Rerun clean-context forward tests**

Use the same three baseline prompts from the design spec. Expected behavior:

```text
explicit UI Toolkit -> UXML/USS/template realization, no automatic host prefab
selected UIDocument -> UI Toolkit chosen from target ownership evidence
runtime UI Toolkit -> version-aware behavior, focus/navigation and verification plan
```

- [ ] **Step 6: Commit**

```bash
git add tests/ui_toolkit_docs_keywords.sh tests/trigger_keywords.sh tests/layer_tree_keywords.sh unity-mcp-ui-layout/references/README.md examples/README.md README.md Platform/Codex/README.md Platform/Google-Antigravity/SYSTEM_PROMPT.md Platform/Claude-Artifacts/ARTIFACT_PROMPT.md CONTRIBUTING.md MAINTENANCE.md RELEASE_CHECKLIST.md CHANGELOG.md
git commit -m "docs: publish first-class UI Toolkit workflow"
```

### Task 5: Final Review and Pull Request

**Files:**
- Review all changes since `b47349ecf552ee23f6a0d9bd63760713e36c53ea`

- [ ] **Step 1: Run a specification compliance review**

Check every acceptance criterion in issue #76 and the design spec against concrete files and test evidence. Fix every missing criterion before continuing.

- [ ] **Step 2: Run an independent code/document quality review**

Review schema consistency, shell/Ruby correctness, routing contradictions, progressive-disclosure quality, duplicated guidance, UGUI regressions, and misleading Unity-version claims. Fix all Critical and Important findings and rerun review.

- [ ] **Step 3: Run final validation from a clean shell**

Repeat the complete Task 4 validation and inspect `git status --short --branch` plus `git diff --check`.

- [ ] **Step 4: Push and create the PR**

```bash
git push -u origin codex/issue-76-ui-toolkit
gh pr create --base main --head codex/issue-76-ui-toolkit --title "[codex] Add first-class UI Toolkit workflow" --body $'## Summary\n- add stack-selection precedence and a neutral mockup layout contract\n- add UI Toolkit-native UXML, USS, template, behavior, MCP, and verification guidance\n- add schema, keyword, and clean-context forward-test coverage while preserving UGUI\n\n## Verification\n- all tests/*.sh\n- skill quick validation\n- YAML parsing\n- git diff --check\n- three clean-context forward tests\n\nCloses #76'
```

The PR body must link `Closes #76`, summarize the neutral contract and UI Toolkit adapter, and list the complete validation evidence.
