# First-Class UI Toolkit Workflow Design

## Context

Issue #76 addresses a structural mismatch in `unity-mcp-ui-layout`: the skill can identify and repair UI Toolkit screens, but its canonical mockup planning artifact, reuse language, MCP build recipes, completion gates, examples, and tests still assume UGUI concepts such as `Canvas`, `RectTransform`, anchors, GameObject prefabs, and `creates_unity_object`.

The target outcome is not a UI Toolkit appendix. UI Toolkit must become an equal realization path behind a stack-neutral mockup-to-layout contract while existing UGUI behavior remains intact.

## Baseline Evidence

Three clean-context forward tests were run against the current skill before any edits:

1. A mixed project with a selected `SettingsUIDocument` correctly chose UI Toolkit, but had no reusable machine-readable UI Toolkit plan contract.
2. An explicit runtime UI Toolkit inventory request produced a useful UXML/USS and behavior design from model knowledge, but those requirements were not discoverable from the skill's template or tests.
3. A UI Toolkit project request phrased as "create a prefab" defaulted to `SettingsScreen.prefab`, `manage_gameobject`, `manage_components`, `creates_unity_object`, and the UGUI-shaped v1 plan.

This establishes the RED condition: stack recognition exists, but the documented implementation contract does not reliably keep UI Toolkit work in UI Toolkit-native assets and verification.

## Design Goals

- Honor explicit user stack instructions before project inference.
- Infer UI Toolkit from the selected target and owned assets when the user does not name a stack.
- Distinguish runtime UI from Editor UI and record the Unity version before choosing version-sensitive behavior.
- Represent the mockup hierarchy with stack-neutral ownership fields.
- Realize repeated UI Toolkit structures as UXML/`VisualTreeAsset` templates and USS classes by default.
- Create a UIDocument host GameObject or prefab only when scene lifecycle or explicit user intent requires one.
- Cover structure, style, behavior, focus/navigation, import/console state, and visual verification.
- Keep existing UGUI guidance and validation working.

## Non-Goals

- Migrating existing UGUI screens to UI Toolkit automatically.
- Claiming feature parity where the active Unity version or target surface does not support it.
- Defining project-specific data models, input actions, or visual assets.
- Replacing Unity's own UI Toolkit documentation with an exhaustive API reference.

## Architecture

### 1. Stack-Neutral Core Contract

The shared workflow uses neutral concepts:

- `layout_tree` rather than a generic Transform tree
- `node_kind` rather than `RectTransform` as the default node type
- `placement_intent` rather than mandatory anchor/pivot data
- `reusable_asset` rather than mandatory prefab data
- `creates_runtime_node` rather than `creates_unity_object`

Stack-specific realization belongs under `stack_realization`:

- UGUI records Canvas, RectTransform, anchors, layout components, and prefab information.
- UI Toolkit records target surface, root UXML, USS files, PanelSettings when applicable, UXML template assets, flex/style owners, and behavior owners.

### 2. Stack Selection Contract

Selection precedence is:

1. explicit user instruction
2. explicitly named target asset or selected UI root
3. existing screen ownership (`UIDocument`/UXML/USS versus Canvas/RectTransform)
4. project conventions and nearby reusable assets
5. user clarification when evidence remains mixed

Installed-package presence alone is not decisive because both stacks commonly coexist. The intake also records `target_surface: runtime | editor` and the Unity version. Version-sensitive data binding or event guidance must be verified against the active project instead of assumed.

### 3. UI Toolkit Build Adapter

The UI Toolkit build path produces these assets as applicable:

- screen UXML for structure
- screen USS plus shared token/state style sheets
- repeated UXML templates (`VisualTreeAsset`) for rows, cards, slots, or tabs
- PanelSettings and UIDocument attachment for runtime screens
- `EditorWindow`, inspector, or property-drawer ownership for Editor UI
- optional C# behavior owner for events, binding, state, focus, and navigation

The word "prefab" is interpreted as reusable UI intent. For UI Toolkit, the default reusable output is a UXML template plus USS classes. A UIDocument host prefab is added only when the scene lifecycle needs a reusable host or the user explicitly requests that host asset.

### 4. MCP Capability Contract

The preferred runtime build sequence is:

1. read project/editor state and Unity version
2. inspect the selected target and existing UI assets
3. create or update UXML and USS through `manage_ui`
4. create or reuse PanelSettings
5. attach or update UIDocument when a runtime host is needed
6. inspect the resulting visual tree
7. create or update C# behavior only when interaction requires it
8. wait for import/compilation and inspect console output
9. verify the main target and an alternate width/aspect with screenshots
10. exercise text, state, focus/navigation, and binding/event checks that apply

If a tool cannot inspect computed styles, inject events, or diagnose bindings, the agent must record that limitation and use file inspection, scripts, Unity tests, UI Debugger evidence, or manual verification rather than claim success.

### 5. Verification

UI Toolkit completion requires applicable evidence for:

- UXML and USS import without errors
- expected UIDocument/PanelSettings or Editor owner
- visual tree matching the approved layout tree
- one deliberate scroll owner and reusable template instances
- container-owned flex, sizing, overflow, and style classes
- interaction callbacks or bindings attached to stable element names/classes
- focus and navigation behavior for keyboard/controller workflows when requested
- main and alternate viewport screenshots
- long text, dynamic values, and state-class behavior
- shared UXML/USS/PanelSettings impact checks before direct edits

## Artifact Changes

- Upgrade `templates/mockup-layout-plan.yaml` to a stack-neutral v2 contract.
- Upgrade the UGUI example to v2 and add a UI Toolkit example that contains no UGUI-only required fields.
- Extend the schema validator with common checks and stack-specific branches.
- Add `ui-stack-selection.md` and `ui-toolkit-build-workflow.md` references.
- Update the skill router, runbook, decomposition, snapshot, MCP recipes, review gates, prompt patterns, reuse guidance, and public metadata.
- Add a dedicated UI Toolkit build example and navigation links.
- Add focused UI Toolkit keyword tests and preserve all existing tests.

## Error Handling and Assumptions

- Mixed evidence is a hard decision gate only when it changes the requested target or would introduce a second UI stack.
- Missing Unity version is a named assumption blocker for version-sensitive bindings, not for structure-only UXML/USS planning.
- Missing UI Toolkit-specific MCP operations trigger documented smaller-call or file-edit fallbacks.
- Missing mockup pixels block visual fidelity claims but do not block a clearly labeled structural plan.
- Shared USS, UXML templates, PanelSettings, themes, and behavior scripts receive the same cross-usage safety treatment as shared UGUI assets.

## Test Strategy

1. RED: preserve the three baseline forward-test outputs described above.
2. Add a failing `tests/ui_toolkit_keywords.sh` before changing guidance.
3. Make the v2 schema test fail until both UGUI and UI Toolkit examples validate through separate realization branches.
4. Run all existing shell tests and skill validation after each task.
5. GREEN: rerun the same three forward-test prompts against the revised skill.
6. Require independent specification and quality reviews before PR creation.

## Acceptance Mapping

- Explicit UI Toolkit requests stay native: stack selector, public trigger, build workflow, forward tests.
- Project evidence selects UI Toolkit: selection precedence and snapshot intake.
- UI Toolkit plan has no UGUI-only requirements: v2 schema, example, validator.
- Repeated units use templates/classes: build workflow, reuse guidance, example.
- MCP creation and inspection are concrete: build workflow and call recipes.
- Runtime/Editor and version differences are explicit: selection contract and completion gates.
- Automated and behavioral validation exists: shell tests plus clean-context forward tests.
- UGUI remains valid: upgraded UGUI example and complete regression suite.
