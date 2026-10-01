# Unity MCP UI Layout

**English** | [한국어](./README.ko.md) | [简体中文](./README.zh-CN.md)

Reusable Unity UI workflow rules for `unity-mcp`, packaged as a Codex skill with adapters for other LLM platforms.

Create a neutral layer-to-layout tree from a mockup, screenshot, structured export, or target resolution, then implement it with the selected UI stack's layout, reuse, scaling, and verification mechanisms. Establish top-level region ownership before leaf details, reuse repeated structures, and keep single-image resources intact unless runtime behavior requires a split.

Current release: [v0.7.0](https://github.com/Hanjo92/unity-mcp-ui-layout/releases/tag/v0.7.0) · [Changelog](./CHANGELOG.md)

## Start Here

1. Open [`unity-mcp-ui-layout/SKILL.md`](./unity-mcp-ui-layout/SKILL.md) for the canonical workflow.
2. Choose the UI stack first, before realization: `UGUI` or `UI Toolkit`.
3. Choose the change mode: repair an existing screen or build a new one.
4. For a new screen or redesign, resolve open design and structure choices through sequential questions, then agree on the neutral layer-to-layout tree. Carry forward prior answers.
5. With a mockup, inspect and reuse suitable project images. For missing roles, ask about generation and generate only with an available image-generation skill and usable execution path. Without that skill, skip both even if a standalone image tool exists. Honor explicit layout-only requests.
6. For Stitch HTML/CSS, Figma node-tree exports, `DESIGN.md`, or design tokens, identify hierarchy sources and style sources before editing.
7. Choose a task from [`examples/README.md`](./examples/README.md), follow the [agent runbook](./unity-mcp-ui-layout/references/agent-runbook.md), or consult the [reference index](./unity-mcp-ui-layout/references/README.md) for a specific rule or failure mode.

For a small first exercise, use the [first layout pass example](./examples/first-layout-pass-example.md). Natural requests such as “build this Unity UI from the attached UI mockup” or “create Unity UI prefabs from this design screenshot” should activate the skill without naming it explicitly.

The workflow favors stable structure, scoped changes, and explicit verification. Small widget adjustments do not need every planning step.

The [execution contract](./unity-mcp-ui-layout/references/execution-contract.md) standardizes routing, review authority, coordinates, and completion verdicts. The installable skill includes its [plan template](./unity-mcp-ui-layout/templates/mockup-layout-plan.yaml) and [Ruby validator](./unity-mcp-ui-layout/scripts/validate_layout_plan.rb); the repository-level template is a synchronized compatibility copy. This makes decisions and plan checks repeatable, without promising identical pixels across models or Unity versions.

## Planning and Image Resources

Follow [UI planning](./unity-mcp-ui-layout/references/ui-planning-workflow.md), then the [image asset workflow](./unity-mcp-ui-layout/references/image-asset-workflow.md). Agree on unresolved design and structure choices, reuse suitable project images, and generate only the agreed gaps when a qualified executor is available. Missing asset indexes use direct project discovery.

Generated images are inspected, imported, assigned, and visually verified in the chosen UI stack. Temporary-resource authorization does not make the art final. The [worked example](./examples/planned-ui-with-project-images-example.md) covers prior answers, generation declined/unavailable, and both UI stacks.

## Mixed Agents and Orchestration

For Orca/Paseo-managed sessions, Claude/OpenCode workers, or API delegates, follow [agent capability routing](./unity-mcp-ui-layout/references/agent-capability-routing.md) and the [mixed-agent example](./examples/mixed-agent-ui-workflow-example.md). Verify capabilities in each executing session before assigning roles. Provider names and parent capabilities do not qualify a child.

| Role | Required evidence |
| --- | --- |
| Image analysis and visual QA | Actual image delivery and interpretation for the current revision |
| Image generation | The same executor has read its generation skill and has a usable execution path |
| Structure and code | An approved structured plan and access to assigned files |
| Unity application and capture | Verified project/Editor access and the relevant tools |

Only the designated coordinator may relay a verified generator's question; a skill-less implementation child cannot ask or forward it. Text-only workers use approved structure, measurements, and asset references. Qualified visual owners analyze images and review final screenshots. Capture, import, or code-check success does not establish visual quality. If the team lacks vision, required image analysis and visual verification remain pending.

## Quick Rules

- Establish top-level region ownership and container relationships before tuning leaf widgets.
- With a mockup, create a neutral layer-to-layout tree before creating objects.
- Map that tree to the selected stack's native hierarchy, styling, and reuse mechanisms.
- Add a screen host only when the runtime path requires one; reusable UI intent alone does not require a host.
- Keep semi-automated raster detections in a candidate item ledger until reviewed.
- For split runtime/repeated items, record source rect, normalized rect, Unity fit intent, and asset/crop plan.
- Express repeated structures through the selected stack's reusable mechanism.
- Keep single-image regions intact unless interaction, animation, or adaptive behavior requires decomposition.
- Verify structure with screenshots instead of chasing raw pixel alignment.

## Mockup to UI Toolkit

Follow this path in order:

1. Select the stack in [ui-stack-selection.md](./unity-mcp-ui-layout/references/ui-stack-selection.md).
2. Approve the neutral `mockup-layout-plan/v2` artifact from [templates/mockup-layout-plan.yaml](./templates/mockup-layout-plan.yaml).
3. Implement it with [ui-toolkit-build-workflow.md](./unity-mcp-ui-layout/references/ui-toolkit-build-workflow.md).

The canonical YAML examples cover [UGUI prefab intent](./examples/mockup-layout-plan-prefab-example.yaml) and [UI Toolkit realization](./examples/mockup-layout-plan-ui-toolkit-example.yaml). See the [UI Toolkit walkthrough](./examples/ui-toolkit-from-mockup-example.md) for a complete example.

## Completion Checks

- Layout holds at the main target and one additional aspect ratio.
- Text handles longer labels, counters, and localization growth.
- Shared assets are preserved, changed locally, or verified across another known usage before base edits.
- Script-backed changes leave no unresolved compile or console errors.
- Required visual review covers the current output revision; technical checks and user art acceptance are reported separately.

## What This Helps With

- Mockup and screenshot analysis: native resolution, layer trees, candidate review, item rects, crop plans, and asset granularity.
- UGUI: anchors, `CanvasScaler`, prefab reuse/variants, static sprites versus texture-driven `RawImage`, and safe shared-asset edits.
- UI Toolkit: container ownership, flex layout, UXML/USS, reusable `VisualTreeAsset` templates, and text overflow.
- Structured design intake: Stitch HTML/CSS, Figma node trees, `DESIGN.md`, design tokens, and mappings to Unity styling.
- Asset reuse: discovery priority, project images, naming/folders, shared versus screen-owned resources, and qualified generation.
- Responsive UI: HUDs, inventories, popups, scroll views, mobile safe areas, taller phones, wider ratios, and tablet profiles.
- Text and localization: wrapping, truncation, auto-size discipline, long labels, multiline body text, and growing counters.
- Build and repair: bounded changes, current-vs-mockup comparisons, MCP call recipes, screenshot loops, and failure recovery.

## Repository Guide

| Path | Purpose |
| --- | --- |
| [unity-mcp-ui-layout/](./unity-mcp-ui-layout) | Canonical installable skill: `SKILL.md`, agent metadata, and detailed references |
| [Platform/](./Platform) | Codex, Google Antigravity, and Claude Artifacts adapters |
| [examples/](./examples/README.md) | Copyable prompts and task walkthroughs |
| [templates/mockup-layout-plan.yaml](./templates/mockup-layout-plan.yaml) | Neutral layout plan template |
| [tests/](./tests) | Documentation, metadata, and schema checks |
| [tests/forward/](./tests/forward) | Retained prompts, reports, and diagnostic fixtures |
| [docs/validation/](./docs/validation) | Observed live runs and their limits |
| [CONTRIBUTING.md](./CONTRIBUTING.md) | Contribution workflow and scope guidance |

Start with the skill and a relevant example; open deeper references as needed. The UI Toolkit documentation check also verifies public routing, plan links, platform prompts, and release-document guidance. Checking stored reports does not launch new agents.

## Platform Notes

### Codex

Codex is the default platform. Copy the canonical skill folder into your Codex skills directory using the commands below.

### Google Antigravity

Use the prompt package in `Platform/Google-Antigravity/` for an Antigravity workspace or custom instructions with Unity access through MCP or an equivalent bridge.

### Claude Artifacts

Use the prompt package in `Platform/Claude-Artifacts/` for a Claude project or artifact workflow connected to Unity tooling.

## Install for Codex

Run these commands from the repository root.

### Windows

```powershell
Copy-Item -Recurse -Force .\unity-mcp-ui-layout $HOME\.codex\skills\
```

### macOS / Linux

```bash
cp -R ./unity-mcp-ui-layout ~/.codex/skills/
```

## Example Request

```text
Use $unity-mcp-ui-layout to build a 1920x1080 UGUI HUD from the attached layout image.
Analyze the visual layers into a clean Unity Transform/RectTransform tree before creating objects.
If item detection is uncertain, keep candidates in a candidate item ledger until reviewed.
For split runtime or repeated items, record item-level UI rects from the mockup before tuning Unity sizes.
Group top-level composition into anchor-owned regions, then map it to parent containers and CanvasScaler rules.
Turn repeated structures into reusable prefabs or reusable layout blocks.
Keep single-image regions intact unless runtime behavior requires a split.
Verify the result with screenshots.
```

## Platform Examples

### Codex

```text
Use $unity-mcp-ui-layout to repair the current inventory layout in UGUI.
Preserve the style, fix slot spacing and scaling drift, and verify at 1920x1080 plus one narrower aspect ratio.
Keep repeated slot structures reusable instead of rebuilding them one by one.
```

### Google Antigravity

```text
Build this Unity HUD from the attached mockup at 1920x1080.
Choose the target UI stack, create a neutral layer-to-layout tree, and implement top-level regions with that stack's native layout system.
Verify the result with screenshots.
```

### Claude Artifacts

```text
Using the attached mockup, help me build a 1920x1080 Unity HUD in UGUI.
Work in an artifact-style loop with sections for Plan, Current Change, Verification, and Next Step.
```

## Validation

Run the focused checks when release preparation or public workflow guidance changes:

```bash
bash tests/agent_runbook_keywords.sh
bash tests/layout_snapshot_keywords.sh
bash tests/mockup_layout_plan_schema.sh
ruby tests/layout_plan_semantics_test.rb
bash tests/review_gates_keywords.sh
bash tests/trigger_keywords.sh
bash tests/layer_tree_keywords.sh
bash tests/item_rect_keywords.sh
bash tests/item_candidate_keywords.sh
bash tests/ui_toolkit_docs_keywords.sh
bash tests/ui_stack_selection_keywords.sh
bash tests/ui_toolkit_build_keywords.sh
bash tests/ui_toolkit_forward_contract.sh
for test in tests/*.sh; do bash -n "$test" || exit 1; done
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py unity-mcp-ui-layout
git diff --check
```

The [2026-09-09 live capability validation](./docs/validation/2026-09-09-agent-capability-routing.md) records real Codex and OpenCode sessions under Orca. Both interpreted the diagnostic image. An initial OpenCode question-relay contradiction was corrected in the instructions and passed a same-session follow-up; both reports are retained.

Actual image generation, Unity execution, Paseo/Claude runs, and a vision-disabled runtime were not exercised. The shell checks above cover documentation/schema contracts and stored evidence, not those execution paths.

## Release and Maintenance

- [Changelog](./CHANGELOG.md)
- [Backlog](./BACKLOG.md)
- [Release checklist](./RELEASE_CHECKLIST.md)
- [Maintenance notes](./MAINTENANCE.md)

## Notes

- The Codex skill is the source of truth; platform adapters follow the same workflow.
- Real project usage should guide future refinements.
- Document repeated UI through the selected stack's reusable mechanism.
- Keep decorative single-image areas simple unless interaction or adaptive behavior requires decomposition.
- Keep the English, Korean, and Simplified Chinese README pages aligned when changing the overview, commands, or verification limits. Linked references retain their own languages.
