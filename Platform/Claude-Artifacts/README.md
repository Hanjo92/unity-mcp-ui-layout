# Claude Artifacts Adapter

This adapter repackages the Unity MCP UI layout workflow for Claude project or artifact-oriented usage, with a stronger focus on explanation, iteration, and artifact structure.

## Files

- `ARTIFACT_PROMPT.md`: prompt template for Claude

## Usage

1. Open `ARTIFACT_PROMPT.md`
2. Paste or adapt it into your Claude project instructions or artifact workflow
3. Use it together with Unity MCP access or a similar Unity integration
4. Prefer artifact outputs that separate plan, current change, verification, and next step

## Goal

Keep Claude aligned with the same layout rules as the Codex skill while taking advantage of Claude's artifact-style iterative explanation and review flow.

This includes the newer guidance around:

- mockup-native resolution planning
- text layout as a structural concern
- safe-area-aware reinterpretation of notch-agnostic mobile mockups
- shared asset edit safety for prefabs, sprites, materials, and TMP styles

## Example User Prompts

```text
Using the attached mockup, help me build a 1920x1080 Unity HUD in UGUI.
Please work in an artifact-style loop with sections for Plan, Current Change, Verification, and Next Step.
Group the top-level composition into anchor-owned regions first.
Translate the design into anchors, containers, and CanvasScaler behavior instead of raw screen pixels.
Turn repeated structures into reusable prefabs or reusable layout blocks, and keep likely single-image regions intact when appropriate.
```

```text
Review the current inventory UI and explain why it breaks at narrower widths.
Then make one bounded structural fix at a time and verify each step with screenshots.
Keep the artifact focused on parent ownership, layout groups, reusable slot structures, and scaling behavior.
```

```text
Design a mobile settings popup in UGUI and keep the explanation artifact-oriented.
Use ModalLayer with sibling Dimmer and PopupRoot, and apply safe area to PopupRoot.
Group the top-level popup layout before tuning child offsets, and keep decorative framing as a single image when appropriate.
After each step, note what changed and what still needs visual verification.
```

```text
Compare the current Unity UI to the attached layout image and produce an artifact that identifies the composition mismatches.
Explain which issues come from top-level grouping, anchors, CanvasScaler, or parent structure, then apply the smallest safe correction first.
```

```text
Using the attached mobile mockup, build the popup as a safe-area-aware UGUI layout.
Treat the image as composition guidance instead of raw edge geometry, keep PopupRoot as the safe-area owner, and use artifact sections to explain how the mockup spacing was remapped.
```

```text
Repair this UI without destabilizing shared assets.
Before editing anything, explain whether the current widget belongs to a shared prefab or shared asset family.
If the change is screen-specific, keep it local through a variant, wrapper, or local override and document that decision in the artifact.
```
