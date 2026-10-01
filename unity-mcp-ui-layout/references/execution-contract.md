# Reproducible Execution Contract

Read this with `agent-runbook.md` for implementation or repair. It defines the shared decisions and evidence expected from any agent. Equivalent results mean the same target, stack, scope, hierarchy ownership, candidate decisions, and verification verdict for the same evidence. Object IDs, generated filenames, and pixel-identical rendering are not guaranteed across tools or Unity versions.

This contract complements `ui-planning-workflow.md`, `image-asset-workflow.md`, and `agent-capability-routing.md`. Recorded candidate review does not settle unresolved product choices, authorize image generation, or establish visual capability. Preserve their existing scope, generation, and per-executor evidence boundaries. Temporary art remains provisional until its required review is complete.

## Resolve Before Mutation

1. Apply the user's explicit choices and existing authorization. Inspect the named target before relying on the current selection. Use `ui-stack-selection.md` for routing; an explicit stack choice does not silently authorize migrating an existing screen owned by another stack. Surface that conflict and continue independent planning only.
2. Record target, surface, stack and evidence, build/repair scope, source files and dimensions, orientation constraints, allowed assets, and available inspection/edit/compile/screenshot capabilities. Missing bridge access permits planning or authorized source edits; it never counts as Unity execution evidence. Do not infer tool availability from recipe names.
3. For a local widget repair, keep a short record of the target, parent owner, intended change and checks. Use the full plan only for mockup decomposition, new screen structure, or changes to multiple layout owners. Do not fabricate raster candidates for structured-export-only or text-only work.
4. For a full mockup plan, copy [the packaged template](../templates/mockup-layout-plan.yaml), replace placeholders, retain only the selected realization branch, and validate before object creation. Keep candidate/item/asset arrays empty when no raster items are promoted. Keep `behavior_plan: []` when behavior is outside scope. Repeated rows alone do not establish a scroll requirement; add a scroll owner only when requested or supported by inspected content/overflow evidence.
5. Read only the applicable branch references: raster -> `image-to-layout.md` and `mockup-resolution.md`; structured export -> its mapping guide; UI Toolkit build -> `ui-toolkit-build-workflow.md`; shared assets -> safety guide; mobile -> `mobile-device-profiles.md`.

## Review And Source Authority

- `review-gates-and-assumptions.md` owns review policy. “Approved plan” means a recorded review under that policy, not an automatic requirement to ask the user. Honor an explicit human review gate; never replace it with agent review. Prior user approval remains valid for its original scope.
- User instructions override sources. An applicable structured export owns hierarchy, machine-readable tokens own style, and raster images provide composition evidence. If these disagree materially, record the discrepancy; preserve the owned structure and avoid speculative migration or shared edits. Ask only for the unresolved decision that changes authorized scope.
- Record each candidate's `review_source: user | agent` and its evidence in `decision_note`. `user` requires an actual user decision, not silence or a model inference. Agent acceptance requires **all** of: a declared parent, visible boundary evidence, and runtime/reuse need grounded in the request or inspected project. A repeated shape alone does not prove runtime behavior.
- If explicit human approval is pending, use `review_decision: hold`, `review_source: agent`, and record any recommended acceptance in `decision_note`. A proposal is not an accepted candidate; keep its measured bounds in the ledger and leave its item/asset entries absent until approval.
- High confidence means all three facts are established; medium means one remains unresolved; low means the boundary or parent is uncertain. Without explicit human review, accept only high-confidence candidates, hold unresolved candidates, and reject known baked decoration. Review source and evidence matter more than a confidence label.
- Preserve stable semantic IDs between passes. On rerun, inspect and update the previously owned nodes/assets instead of duplicating them. Reopen only decisions affected by new evidence or user changes.

## Coordinate Contract

`layout_contract.mockup_resolution` is the measured source image size; `target_resolution` is the implementation/verification size. Both are required for concrete raster plans, even when equal. For older v2 plans, add the actual source dimensions before validation; do not copy target dimensions unless the source confirms them. Without source measurements, keep an incomplete draft instead of inventing geometry.

All source rectangles and parent-local planning rectangles use top-left origin, +x right, +y down, and source-image pixels. `geometry_ratios` and `normalized_rect` are relative to the **whole source image**, never to the immediate parent. Width/height must be positive finite numbers. Source item bounds are inside the image; crop padding is separate and does not enlarge the layout rect.

For source size `(W, H)` and item `(x, y, w, h)`:

```text
normalized_rect = (x/W, y/H, w/W, h/H)
parent_origin = (parent.geometry_ratios.x * W, parent.geometry_ratios.y * H)
parent_local_rect = (x - parent_origin.x, y - parent_origin.y, w, h)
```

Store ratios to at least four decimal places. Validator tolerance is `0.0001` for normalized values and one source pixel for derived parent-local geometry. A split item's `node_path` points to the leaf itself, and that leaf's immediate parent matches the candidate's `parent_hint`. Its geometry matches the item rect. `source_bounds` and `source_rect` match; update the ledger first if review refines a boundary.

Parent-local planning coordinates are **not** UGUI `anchoredPosition` or UI Toolkit style offsets. Realize the selected stack's flow/anchors from `fit_mode` and `placement_intent`; record any stack-space conversion separately. A parent layout controller owns positioning of its children. Do not write competing manual offsets merely to match these measurements.

## Verification And Completion

Choose verification targets before implementation. Use the explicit target plus a project-supported alternate with a width/height ratio differing by at least 5%. If no alternate is specified, hold height constant and reduce width to 75%, retaining the supported orientation; if this crosses the orientation boundary, reduce height to 75% instead. This is a stress-test assumption, not a new supported device. Respect portrait-only/landscape-only products; cover both orientations only when supported. Real mobile profiles still follow `mobile-device-profiles.md`.

Keep evidence next to the plan or in the final handoff. For each applicable check record `check`, `status`, `evidence`, and `reason`:

| Status | Meaning |
| --- | --- |
| `pass` | Executed after the final relevant change, with screenshot/log/inspection evidence |
| `fail` | Executed and a defect remains |
| `blocked` | Required check could not run; name the missing capability/input |
| `not_applicable` | Outside this task, with a specific reason; tool absence is not a reason |

Required implementation checks: whole-screen capture and hierarchy comparison at main and alternate targets; no unintended overlap/clipping or unreachable controls; text growth; relevant interactions; fresh import/compile and console state; shared-use regression when a shared base changed. Use supplied long strings or project localization fixtures first; otherwise test a label at twice its current length and the largest known counter value, marking synthetic content as such. Do not apply a universal pixel-difference threshold to subjective visual fidelity; report any visible mismatch to the supplied composition.

After a relevant edit, rerun affected checks and recapture affected screenshots. Preserve the baseline console evidence: fix new errors caused by the change; list pre-existing errors separately and identify which checks they block. Do not expand into unrelated repairs to obtain a clean console.

- `complete`: all applicable requested checks pass, with justified `not_applicable` entries.
- `implemented_unverified`: authorized changes exist but required evidence is blocked. Never label this Unity-verified.
- `blocked`: required scope/input/authorization prevents the requested change; report independent work already completed.
- `plan_only`: planning was the requested deliverable; plan validation is not runtime validation.

If any required check fails, keep repairing within scope; if an external blocker prevents repair, report the defect and blocker without claiming completion. A planning-only request does not require launching Unity.

## Packaged Validation

Requires Ruby with its standard YAML library. From the skill folder:

```bash
ruby scripts/validate_layout_plan.rb /absolute/path/to/plan.yaml
# Template maintenance only; never evidence that a concrete plan is ready:
ruby scripts/validate_layout_plan.rb --template templates/mockup-layout-plan.yaml
```

The validator checks schema, references, decisions, numeric geometry, ownership, and aspect coverage. It cannot prove that the image was measured correctly, the user approved a decision, or Unity renders correctly. If Ruby is absent, inspect these invariants manually and report the automated check as blocked; do not install tools or alter client configuration implicitly.
