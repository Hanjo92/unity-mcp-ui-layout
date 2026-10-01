# Agent Execution Runbook

Use this runbook after the skill triggers and before editing Unity UI. It is the operating sequence for the agent. Apply [execution-contract.md](execution-contract.md) for shared decision, coordinate, and evidence rules. Keep deeper rule lookup in the linked reference docs.

For subagents or orchestration, first apply `agent-capability-routing.md`. Each step below belongs to a qualified executor, not automatically to every worker. Verify per-session vision/image delivery, generation skill/tools, artifact access, and Unity access before dependent dispatch; preserve user decisions across handoffs. A text-only worker receives the approved structured plan, while a qualified visual owner performs image analysis and final visual review.

## Operating Sequence

1. **Name the trigger.** Say why this skill applies: mockup-to-UI, UI 시안, prefab creation, layout repair, structured export, design tokens, safe area, text overflow, or shared prefab reuse.
2. **Classify the task.** Apply `ui-stack-selection.md` before prefab or Canvas defaults. Record `selection.selected_object` and `selection.active_ui_root`. Explicit UI Toolkit requests, a selected `UIDocument`, a resolved visual-tree root, or an editor UI Toolkit owner route to UI Toolkit; then choose change mode, design source, and asset strategy.
3. **Gather Unity state.** Capture a layout snapshot or equivalent smaller-call evidence: target surface, Unity version evidence, `selection.selected_object`, `selection.active_ui_root`, UI stack, root layout owners, screenshot frame, and console state.
4. **Plan hierarchy before objects.** Follow `ui-planning-workflow.md` for new screens and redesigns: ask focused questions about unresolved purpose/behavior, propose composition and a layer-to-layout-tree pass, and reuse prior answers. For mockups, review the tree under the recorded review policy before creating or moving stack-specific UI objects.
5. **Resolve gates and assumptions.** Inspect project images using `asset-discovery-priority.md`; mockups require suitable project image reuse unless the user explicitly chose layout-only scope. Identify gaps and verify an available image-generation skill in the named generation executor before any generation question or execution. Without a qualified executor, skip both even if a standalone image tool exists; record generation as unavailable and continue with project assets or agreed placeholders. With the skill and a usable generation path, resolve temporary-resource use and record the agreed design and asset plan. Use `review-gates-and-assumptions.md` for remaining blockers and local assumptions.
6. **Review raster candidates.** If raster item analysis is used, produce candidate item ledger decisions before item rect planning.
7. **Promote only accepted items.** Record item-level UI rects only for accepted runtime or repeated items. Held candidates remain notes. Rejected candidates must not create runtime nodes, reusable-template children, or crops.
8. **Build or repair in slices.** Work root shell, major regions, one reusable block or region, then polish. Reuse project images and, only when an image-generation skill is available and generation is agreed, follow `image-asset-workflow.md` to generate, inspect, import, and apply missing sprites. Verify after structural slices.
9. **Verify before final response.** Use screenshot, alternate aspect ratio, text behavior, console state, and shared-asset checks where applicable. A capture worker returns images to a verified visual reviewer; missing vision leaves visual verification pending even when technical checks pass.
10. **Report evidence.** Tell the user what assumptions were made, what artifacts were produced, which screenshots or checks were used, and what residual risks remain.

## Build Mode Notes

- Resolve material design choices with the user before dependent creation; an already accepted plan or explicit delegation is sufficient to proceed.
- Create the root shell before leaf widgets.
- UGUI: establish CanvasScaler, safe-area owner, and root regions before content details; then establish scroll ownership where applicable.
- UI Toolkit: establish UIDocument/PanelSettings or Editor owner, resolved visual-tree root, and root flex/scroll ownership before content details.
- Promote repeated structures into UGUI prefabs or UI Toolkit UXML/`VisualTreeAsset` templates with USS classes when repetition is real.
- Use `../templates/mockup-layout-plan.yaml` when the plan needs stable v2 sections across `layout_tree`, `stack_realization`, candidate ledger, item rects, `asset_plan`, `behavior_plan`, and verification targets.

## Repair Mode Notes

- Inspect the current parent chain before editing.
- Keep the repair bounded to the named region unless parent structure is the real cause.
- Preserve existing style unless it directly causes the layout failure.
- Prefer variants, wrappers, or local overrides before direct shared-base edits for one-screen requests.
- Explain scope expansion before rebuilding a region that was requested as a small repair.

## Structured Export Input Notes

- Treat Stitch HTML/CSS, Figma node-tree JSON, component trees, or similar exports as hierarchy sources.
- Normalize export nodes into semantic containers, repeated units, overlays, and layout ownership rules.
- Do not let raster candidate detection override structured export hierarchy.
- Use screenshots or mockups as composition validation, not as the hierarchy source, when a structured export is present.

## Raster-Only Mockup Input Notes

- Use the mockup native resolution when no explicit target resolution exists.
- Run the layer-to-layout-tree pass before object creation.
- Verify that the final UGUI `Transform`/`RectTransform` hierarchy or UI Toolkit visual tree realizes the approved neutral plan.
- Keep candidate item ledger output advisory until review decisions are recorded.
- Use item rects for accepted runtime leaves or repeated items only.
- Keep decorative baked regions whole unless interaction, animation, dynamic content, adaptive layout, or reuse requires splitting.

## Design-Token Input Notes

- Read `DESIGN.md`, design tokens, Tailwind theme values, or equivalent sources before styling.
- Treat machine-readable tokens as the style contract and prose as application intent.
- Keep design-token styling separate from hierarchy ownership decisions.
- Preserve colors, typography, spacing, radius, component states, and readable contrast where the source defines them.

## Final Response Checklist

In the final response after using the skill, include:

- trigger reason and chosen UI stack
- change mode: build or repair
- design source split: structured export, raster mockup, design tokens, or none
- layout snapshot or fallback intake status
- when delegated: role/executor capabilities, artifact revisions and handoffs, evidence owners, and any capability gaps that limited completion
- agreed design/structure, remaining decisions, and temporary-resource choice
- project images reused and generated assets with separate import, assignment, visual verification, and temporary/final status
- produced planning artifacts: layout tree, stack realization, candidate ledger, item rect plan, asset plan, behavior plan, or template path
- implementation scope: regions, reusable templates, variants, wrappers, or assets touched
- verification evidence: screenshots, alternate aspect, text checks, console state, shared-asset checks
- candidate decisions by accept, hold, and reject when a candidate ledger was used
- assumptions and unresolved risks

If a check could not be run, state that directly with the reason.

Report `complete`, `implemented_unverified`, `blocked`, or `plan_only` using the execution contract. A missing tool is blocked evidence, not a passed or inapplicable check.
