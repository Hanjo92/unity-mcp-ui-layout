# Agent Execution Runbook

Use this runbook after the skill triggers and before editing Unity UI. It is the operating sequence for the agent. Keep deeper rule lookup in the linked reference docs.

## Operating Sequence

1. **Name the trigger.** Say why this skill applies: mockup-to-UI, UI 시안, prefab creation, layout repair, structured export, design tokens, safe area, text overflow, or shared prefab reuse.
2. **Classify the task.** Apply `ui-stack-selection.md` before prefab or Canvas defaults. Record `selection.selected_object` and `selection.active_ui_root`. Explicit UI Toolkit requests, a selected `UIDocument`, a resolved visual-tree root, or an editor UI Toolkit owner route to UI Toolkit; then choose change mode, design source, and asset strategy.
3. **Gather Unity state.** Capture a layout snapshot or equivalent smaller-call evidence: target surface, Unity version evidence, `selection.selected_object`, `selection.active_ui_root`, UI stack, root layout owners, screenshot frame, and console state.
4. **Plan hierarchy before objects.** For mockups, produce a layer-to-Transform or layer-to-RectTransform tree before creating or moving UI objects.
5. **Resolve gates and assumptions.** Use `review-gates-and-assumptions.md` to decide whether to ask the user or proceed with named assumptions.
6. **Review raster candidates.** If raster item analysis is used, produce candidate item ledger decisions before item rect planning.
7. **Promote only accepted items.** Record item-level UI rects only for accepted runtime or repeated items. Held candidates remain notes. Rejected candidates must not create Unity objects, prefab children, or crops.
8. **Build or repair in slices.** Work root shell, major regions, one reusable block or region, then polish. Verify after structural slices.
9. **Verify before final response.** Use screenshot, alternate aspect ratio, text behavior, console state, and shared-asset checks where applicable.
10. **Report evidence.** Tell the user what assumptions were made, what artifacts were produced, which screenshots or checks were used, and what residual risks remain.

## Build Mode Notes

- Create the root shell before leaf widgets.
- UGUI: establish CanvasScaler, safe-area owner, and root regions before content details; then establish scroll ownership where applicable.
- UI Toolkit: establish UIDocument/PanelSettings or Editor owner, resolved visual-tree root, and root flex/scroll ownership before content details.
- Promote repeated structures into reusable prefabs or layout blocks when repetition is real.
- Use `templates/mockup-layout-plan.yaml` when the plan needs stable sections across layer tree, candidate ledger, item rects, crops, and verification targets.

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
- Run the layer-to-tree pass before object creation.
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
- produced planning artifacts: layer tree, candidate ledger, item rect plan, asset crop plan, or template path
- implementation scope: regions, prefabs, variants, wrappers, or assets touched
- verification evidence: screenshots, alternate aspect, text checks, console state, shared-asset checks
- candidate decisions by accept, hold, and reject when a candidate ledger was used
- assumptions and unresolved risks

If a check could not be run, state that directly with the reason.
