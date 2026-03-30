# Mockup Resolution Rules

Use this guide when the user provides a mockup, screenshot, wireframe, or design image and the image's own pixel resolution should influence how the UI is planned.

## Goal

Use the mockup's native pixel resolution as an intentional reference frame instead of silently falling back to an arbitrary default such as `1920x1080`.

## Core Rule

- If the user provides a mockup image and no explicit target resolution, use the mockup image's native resolution as the reference resolution.
- If the user provides both a mockup image and an explicit target resolution, keep both:
  - use the mockup resolution as the composition measurement space
  - use the explicit target resolution as the implementation and verification space

## Decision Flow

```mermaid
flowchart TD
    A["Mockup image provided"] --> B{"Explicit target resolution also provided?"}
    B -- "No" --> C["Use mockup native resolution as the reference resolution"]
    B -- "Yes" --> D["Measure composition against mockup resolution"]
    D --> E["Map normalized geometry into the explicit target resolution"]
    C --> F["Build and verify against the mockup-sized reference frame"]
    E --> G["Verify against the explicit target and one alternate aspect ratio if needed"]
```

## Practical Rules

- Do not default to `1920x1080` if the mockup already has a clear pixel size and the user did not override it.
- If the user says "make it according to the mockup resolution", treat the mockup resolution as the primary reference frame.
- If the user gives both a mockup and a target device resolution, do not confuse them:
  - the mockup tells you composition and spacing intent
  - the target resolution tells you the actual implementation frame
- Always convert geometry through normalized ratios rather than copying raw mockup pixels directly.
- If the mockup is obviously a reduced export of a known target device, prefer the explicitly known target device resolution while still preserving the mockup's normalized layout relationships.

## Measurement Rules

When the mockup resolution is known:

- estimate `x`, `y`, `width`, and `height` relative to the mockup dimensions first
- treat those values as composition ratios
- only after that convert them into anchors, offsets, and size constraints for the target frame

This keeps the UI aligned with the design intent instead of overfitting to one arbitrary set of absolute numbers.

## Common Mistakes

- ignoring the mockup resolution and silently planning everything around `1920x1080`
- mixing mockup pixels and target pixels as if they were the same coordinate space
- copying raw pixel coordinates from the mockup without normalizing first
- treating a mockup export size as meaningless even when it is the only explicit resolution evidence available

## Verification Questions

- Did we capture the mockup's native resolution before planning?
- If no explicit target resolution was given, did we use the mockup resolution instead of an arbitrary default?
- If both mockup and target resolutions exist, did we keep their roles separate?
- Were geometry estimates normalized before turning them into anchors and offsets?
