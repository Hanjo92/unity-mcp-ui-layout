# Review Gates And Assumptions

Use this guide when mockup-driven UI work has ambiguity. The goal is to avoid two failure modes: blocking every small task, or silently turning uncertain visual guesses into real Unity objects, prefab children, or crop assets.

This is the canonical review policy for the entrypoint, examples, and platform adapters. “Approve” means record a review decision; it does not itself require a new user confirmation. Honor existing authorization and explicit human review requirements. Use [execution-contract.md](execution-contract.md) for confidence criteria, `review_source`, coordinates, and evidence status.

## Decision Rule

- Use `ui-planning-workflow.md` for unresolved product, design, or major structure choices in new screens and redesigns. Read-only inspection and a concrete proposal come before asking for a decision.
- Honor existing answers, approved plans, and explicit delegation. Ask only about a material decision still outside that agreement; a bounded repair does not need a fresh design approval.
- Ask the user before editing when the ambiguity can change the target screen, UI stack, shared asset contract, or destructive scope.
- Continue with named assumptions when the ambiguity is local, reversible, and does not create shared assets or crops from uncertain candidates.
- Record every assumption and review decision in the final response.
- Apply `ui-stack-selection.md` before any prefab or Canvas default. An explicit UI Toolkit request, selected `UIDocument`, resolved visual-tree root, or editor UI Toolkit owner is decisive; `UXML`, `USS`, and `PanelSettings` corroborate only when referenced by that owner. Installed-package presence alone is not decisive.

## Hard Blockers: Ask Before Editing

Ask only if inspected evidence and existing authorization do not resolve one of these scope-changing decisions. Continue independent authorized work while waiting:

- **Unconfirmed design or major structure.** Example: a new shop could use tabs or one scrolling catalog, and neither user input nor a supplied design settles the choice. Present a concrete proposal and resolve it before creating that screen.
- **Unknown UI stack in a mixed-stack project.** Example: both `Canvas` and `UIDocument` are active, the selected target has no established owner, and the user did not identify the target stack.
- **Unclear target screen or prefab root.** Example: multiple inventory screens are open and the request only says "fix this UI."
- **Destructive shared-base change.** Example: the repair would alter an unauthorized shared contract. Prefer a local override; an already-authorized shared edit needs regression evidence, not repeated permission.
- **Ambiguous repair versus rebuild scope.** Example: a bounded alignment fix appears to require replacing the parent layout system.
- **Missing required runtime behavior.** Example: behavior is required but unspecified. Hold the uncertain behavior and continue the independent layout; do not invent callbacks.

Hard blocker response pattern:

```text
I need one confirmation before editing: this project has both UGUI and UI Toolkit roots, and the request does not identify which stack owns the target screen. Which UI stack should I modify?
```

## Soft Ambiguities: Proceed With Named Assumptions

Proceed with an explicit assumption when the choice is local and reversible:

- **Mockup native resolution fallback.** If no target resolution is provided, use the image's native resolution as the planning frame.
- **Layout-only placeholder assets.** If the user chose layout-only scope or allowed placeholders for confirmed gaps, keep them provisional. A missing asset index does not authorize skipping direct project-image discovery or the skill-availability check in `image-asset-workflow.md`. Temporary-generation questions apply only when an image-generation skill is available and usable; without it, skip both the generation question and generation.
- **Non-destructive local spacing choice.** If two parent-owned spacing interpretations are close, choose the one that preserves anchors and layout groups.
- **Unknown final copy length.** Use realistic text headroom and note that final localization still needs a content pass.
- **No human candidate review available.** Within the already agreed design scope, build parent structure first, accept only high-confidence runtime/reuse candidates with evidence, keep low-confidence candidates held, and avoid creating crop assets from uncertain candidates. This fallback does not approve a new screen's unresolved design.

Soft assumption response pattern:

```text
Proceeding with the mockup's native 1440x2560 resolution as the planning frame because no target resolution was provided. I will keep asset choices provisional and avoid shared-base edits.
```

Soft assumption example:

```text
The user requested a layout-only preview and allowed placeholders for missing images. I will preserve assigned project images and mark the remaining visuals provisional.
```

## Candidate Ledger Review States

Use exactly these states:

- `accept`: enough evidence exists to promote the candidate into item-level UI rect planning.
- `hold`: evidence is incomplete or no review is available; keep it as a note only.
- `reject`: evidence shows the candidate should not become a runtime object, prefab child, or crop.

Accepted candidate evidence should name:

- parent hint from the layer tree
- split reason tied to interaction, dynamic data, state, animation, adaptive layout, reuse, or import boundary
- visible evidence such as containment, repeated shape, shared baseline, icon/text cluster, strong contrast boundary, panel boundary, or explicit user hint
- fit or crop intent if the candidate will become a rect or crop

Held candidates remain review notes and must not create Unity objects, prefab children, or crop assets.
Rejected candidates must not create Unity objects, prefab children, or crop assets.

## Concrete Candidate Examples

### Accepted Candidate

```yaml
candidate_id: "candidate/RewardCard/Icon"
confidence_band: "high"
evidence:
  - "dynamic reward content"
  - "centered icon cluster"
  - "strong contrast boundary"
parent_hint: "RewardPopupRoot/RewardCard"
review_source: "agent"
review_decision: "accept"
decision_note: "Promote to item rect because the icon changes at runtime and belongs to the RewardCard prefab."
```

### Held Candidate

```yaml
candidate_id: "candidate/RewardCard/OuterGlow"
confidence_band: "medium"
evidence:
  - "soft decorative boundary"
parent_hint: "RewardPopupRoot/RewardCard"
review_source: "agent"
review_decision: "hold"
decision_note: "Keep as review note. It may be baked into the card background, so do not create a prefab child or crop yet."
```

### Rejected Candidate

```yaml
candidate_id: "candidate/RewardCard/InnerHighlightLine"
confidence_band: "medium"
evidence:
  - "decorative separator"
parent_hint: "RewardPopupRoot/RewardCard"
review_source: "agent"
review_decision: "reject"
decision_note: "Reject as a separate item. It stays inside the baked card background and must not create a Unity object or crop."
```

## When No Human Review Is Available

If no human review is available during the current run:

1. Preserve pending design questions. Build the parent-owned layer tree first only within the already agreed scope; otherwise retain it as a proposal.
2. Unless the user explicitly requires human review, accept only high-confidence candidates with a clear parent hint, visible boundary, split reason, and request/project-backed runtime/reuse evidence; record `review_source: agent`.
3. Hold medium/low-confidence unresolved candidates; reject decoration known to remain baked.
4. Do not create crop assets from held or rejected candidates.
5. Prefer suitable existing assets or already authorized placeholders over mockup-derived crops when evidence is uncertain. Do not infer temporary-generation authorization from silence.
6. Report which candidates were accepted, held, and rejected in the final response.

## Final Response Requirements

When assumptions or candidate review decisions affected the work, report:

- hard blockers that were confirmed, or that no hard blockers remained
- soft assumptions used
- design/structure agreement and any pending answers that limited implementation
- project image discovery, temporary-resource decision, and generated-art review status when applicable
- candidate counts by `accept`, `hold`, and `reject`
- any accepted candidate promoted into item rect planning
- held candidates that stayed notes
- rejected candidates that were prevented from creating objects, prefab children, or crops
- remaining risks that need user or art review
