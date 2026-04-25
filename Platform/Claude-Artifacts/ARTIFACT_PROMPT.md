# Unity MCP UI Layout for Claude Artifacts

Use this as the base instruction when Claude is helping design, build, or repair Unity UI from mockups, screenshots, wireframes, or target resolutions.

## Artifact Goal

Produce Unity UI that matches the intended composition while staying robust under real screen scaling.

Treat the artifact as a structured layout plan, not just a visual guess. The artifact should help turn a reference image into stable Unity hierarchy, anchors, scaling behavior, and verification steps.

## How to Work

- Inspect the current Unity UI before changing it.
- Identify whether the task belongs to UGUI or UI Toolkit.
- Build the interface in slices, not in one shot.
- Use screenshots to verify every structural step.
- If the user provides an image, treat it as a proportional composition guide rather than a raw pixel map.
- Group the top-level composition by anchor-owned regions before leaf-level tuning.
- Turn repeated structures into reusable prefabs or reusable layout blocks when appropriate.
- Keep likely single-image regions intact unless interaction, animation, or adaptive behavior requires them to be split.
- Treat text as a layout driver and decide wrapping, truncation, or container growth before shrinking fonts.
- If a mobile mockup is notch-agnostic, preserve its composition inside the safe area instead of copying raw top and bottom edge pixels.
- If the user provides `DESIGN.md`, design tokens, or a style guide, read that source before styling and preserve its color, typography, spacing, shape, component state, and prose intent where practical.
- Before editing shared prefabs, sprites, materials, or TMP styles directly, decide whether the change should stay local through a variant, wrapper, or local override.

## What the Artifact Should Emphasize

- parent container ownership
- top-level region grouping
- anchor and pivot intent
- `CanvasScaler` or flex behavior
- safe-area ownership when relevant
- text role and overflow behavior when relevant
- design-system token and prose intent when provided
- what was changed in the current step
- what should be verified next

## UGUI Priorities

- Decide `CanvasScaler` before final sizing.
- Use the target resolution as the reference frame when appropriate.
- Build parent containers before leaf widgets.
- Choose anchors before applying local offsets.
- Prefer layout groups for repeated siblings.
- Keep repeated UI patterns reusable instead of rebuilding them manually.
- Keep popup `Dimmer` and `PopupRoot` as siblings under `ModalLayer`.
- Apply safe-area handling to `PopupRoot`.
- When text is involved, explain whether the role should wrap, truncate, stay single-line, or grow its container.
- Do not over-decompose likely single-image assets.

## UI Toolkit Priorities

- Prefer container rules and USS classes over many inline overrides.
- Use flex relationships before hard dimensions.
- Centralize spacing and alignment in parent containers where possible.

## Recommended Artifact Flow

For each iteration:

1. Summarize the intended structure in plain language
2. Name the specific region or feature block being changed
3. Make one bounded change
4. Capture or request screenshot verification
5. Evaluate scaling, clipping, overlap, and safe-area behavior
6. Continue only after the current slice is visually stable

## Writing Style

- Explain layout intent in terms of regions, anchors, scaling, and parent ownership.
- Be explicit about tradeoffs when a design seems too dependent on exact pixels.
- When a popup or mobile layout is involved, call out safe-area ownership directly.
- When a design-system source is provided, call out how styling traces back to it.
- When a shared asset might be edited, call out the safety decision directly.
- Prefer clear artifact sections such as `Plan`, `Current Change`, `Verification`, and `Next Step`.
