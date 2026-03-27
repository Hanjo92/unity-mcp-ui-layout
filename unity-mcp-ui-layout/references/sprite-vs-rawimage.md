# Sprite vs RawImage Rules

Use this guide when Unity UI asset usage starts drifting toward `RawImage` for ordinary static UI visuals that should really stay in the normal sprite workflow.

## Goal

Keep static UI assets in the sprite-based workflow by default, and reserve `RawImage` for true texture-driven cases such as `RenderTexture`, video, runtime-generated textures, or external texture streams.

## Default Rule

- Use `Image` with a `Sprite` for ordinary static UI visuals.
- Use `RawImage` only when the content is truly texture-driven and not naturally part of the sprite workflow.

## Prefer `Image` + `Sprite` When

- The asset is a normal UI icon, frame, badge, slot background, panel, button background, or decorative sprite.
- The element should participate in standard UI authoring and asset reuse.
- You need sprite slicing, packed sprite usage, atlas-driven organization, or normal prefab reuse.
- The visual is a stable imported UI asset rather than a live texture feed.
- The region is likely one baked UI image and not a runtime texture source.

## Prefer `RawImage` When

- The source is a `RenderTexture`.
- The UI displays a camera preview or 3D scene capture.
- The source is video or another live texture stream.
- The texture is generated or updated at runtime.
- The source is not naturally available as a sprite asset and should remain texture-backed.

## Do Not Use `RawImage` Just Because

- it is quicker than importing a proper sprite
- the asset "looks like an image"
- the prompt mentioned a screenshot or mockup
- the element is decorative but static
- the same visual would normally be used in multiple prefabs or screens

## Why This Matters

If static UI visuals drift into `RawImage`, the workflow usually gets worse:

- sprite slicing and normal UI scaling patterns are bypassed
- asset reuse becomes weaker
- prefab families become harder to keep consistent
- image assets stop matching the expected import pipeline
- the agent starts treating stable UI art like arbitrary texture data

## Asset-Aware Mode Rule

In asset-aware mode:

- prefer retrieving existing sprite-backed UI assets first
- preserve sprite-based reuse when the project already uses it
- do not convert known sprite workflow assets into `RawImage` unless the runtime source truly changed

If a screen already uses a consistent sprite workflow, treat a sudden `RawImage` choice as suspicious and re-check the source type.

## UGUI Rules

- `Image` is the normal default for static UGUI visuals.
- Use `Sprite` assets for icons, borders, slots, frames, and panel art.
- If a resizable panel needs 9-slice behavior, it should almost certainly stay in `Image`, not `RawImage`.
- Do not solve layout problems by swapping `Image` to `RawImage`.
- If an asset should be atlas-friendly or prefab-friendly, keep it in the sprite pipeline.

## UI Toolkit Equivalent

UI Toolkit does not map one-to-one to `Image` and `RawImage`, but the same principle applies:

- keep stable UI visuals in the normal project asset pipeline
- avoid treating ordinary static UI art like arbitrary texture data
- reserve texture-driven display patterns for genuinely dynamic sources

## Common Anti-Patterns

- Static icon shown through `RawImage` even though it should be a sprite.
- Button background built with `RawImage` so the normal sprite workflow is lost.
- Panel frame switched to `RawImage` even though 9-slice or normal sprite scaling is needed.
- Multiple prefabs each wiring the same static texture through `RawImage` instead of sharing sprite assets.
- Using `RawImage` as a shortcut when the real problem was import setup or asset lookup.

## Verification Questions

- Is this a true texture-driven element, or just a static UI image?
- Would the project be more consistent if this stayed in the sprite workflow?
- Does this element need sprite slicing, atlas reuse, or normal prefab-friendly UI art behavior?
- If this is a `RawImage`, can you clearly explain the runtime texture source?
- If the answer is no, should this be converted back to `Image` + `Sprite`?
