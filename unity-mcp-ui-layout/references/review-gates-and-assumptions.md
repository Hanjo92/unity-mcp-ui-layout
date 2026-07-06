# Review Gates And Assumptions

Use this guide when mockup-driven UI work has ambiguity. The goal is to avoid two failure modes: blocking every small task, or silently turning uncertain visual guesses into real Unity objects, prefab children, or crop assets.

## Decision Rule

- Ask the user before editing when the ambiguity can change the target screen, UI stack, shared asset contract, or destructive scope.
- Continue with named assumptions when the ambiguity is local, reversible, and does not create shared assets or crops from uncertain candidates.
- Record every assumption and review decision in the final response.

## Hard Blockers: Ask Before Editing

Pause for confirmation when any of these are true:

- **Unknown UI stack in a mixed-stack project.** Example: both `Canvas` and `UIDocument` are active, and the user did not identify the target stack.
- **Unclear target screen or prefab root.** Example: multiple inventory screens are open and the request only says "fix this UI."
- **Destructive shared-base change.** Example: the repair would directly edit a common prefab, sprite, material, or TMP style used by other screens.
- **Ambiguous repair versus rebuild scope.** Example: a bounded alignment fix appears to require replacing the parent layout system.
- **Missing required runtime behavior.** Example: a mockup element may be decorative or clickable, and creating it as a button would change behavior.

Hard blocker response pattern:

```text
I need one confirmation before editing: this project has both UGUI and UI Toolkit roots, and the request does not identify which stack owns the target screen. Which UI stack should I modify?
```

## Soft Ambiguities: Proceed With Named Assumptions

Proceed with an explicit assumption when the choice is local and reversible:

- **Mockup native resolution fallback.** If no target resolution is provided, use the image's native resolution as the planning frame.
- **Layout-only placeholder assets.** If asset retrieval is unavailable or low-confidence, use placeholders and mark visuals provisional.
- **Non-destructive local spacing choice.** If two parent-owned spacing interpretations are close, choose the one that preserves anchors and layout groups.
- **Unknown final copy length.** Use realistic text headroom and note that final localization still needs a content pass.
- **No human candidate review available.** Build parent structure first, accept only high-confidence runtime/reuse candidates with evidence, keep low-confidence candidates held, and avoid creating crop assets from uncertain candidates.

Soft assumption response pattern:

```text
Proceeding with the mockup's native 1440x2560 resolution as the planning frame because no target resolution was provided. I will keep asset choices provisional and avoid shared-base edits.
```

Soft assumption example:

```text
Assumption: asset retrieval is unavailable, so this pass stays layout-only. I will use placeholders, avoid shared-base edits, and mark visuals provisional until project assets are reviewed.
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
review_decision: "reject"
decision_note: "Reject as a separate item. It stays inside the baked card background and must not create a Unity object or crop."
```

## When No Human Review Is Available

If no human review is available during the current run:

1. Build the parent-owned layer tree first.
2. Accept only high-confidence candidates with a clear parent hint, split reason, and runtime/reuse evidence.
3. Hold low-confidence or decorative candidates.
4. Do not create crop assets from held or rejected candidates.
5. Prefer placeholders or existing assets over mockup-derived crops when evidence is uncertain.
6. Report which candidates were accepted, held, and rejected in the final response.

## Final Response Requirements

When assumptions or candidate review decisions affected the work, report:

- hard blockers that were confirmed, or that no hard blockers remained
- soft assumptions used
- candidate counts by `accept`, `hold`, and `reject`
- any accepted candidate promoted into item rect planning
- held candidates that stayed notes
- rejected candidates that were prevented from creating objects, prefab children, or crops
- remaining risks that need user or art review
