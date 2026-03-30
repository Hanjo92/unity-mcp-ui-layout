# Mockup Resolution Example

This example shows how to work from a design image when the mockup's own pixel resolution matters.

## Scenario

- A mockup image exists
- The mockup export is `1600x900`
- The final implementation target is `1920x1080`
- The screen is a UGUI HUD with repeated status widgets

## Example Prompt

```text
Use $unity-mcp-ui-layout to build this UGUI HUD from the attached mockup.
The mockup image is 1600x900 and the implementation target is 1920x1080.
Use the mockup resolution as the composition measurement space and 1920x1080 as the implementation and verification space.
Group the top-level composition into anchor-owned regions first.
Do not decompose decorative baked regions unless runtime behavior requires it.
Turn repeated status widgets into one reusable prefab or reusable layout block.
Verify the result with screenshots at 1920x1080 and one alternate aspect ratio.
```

## Why This Example Matters

- It avoids silently treating every design as if it were authored for `1920x1080`.
- It separates composition measurement from implementation resolution.
- It reinforces that repeated UI should be reusable.
- It reinforces that decorative baked art should not be over-decomposed.

## What To Watch For

- Do not copy raw `1600x900` pixel positions directly into the final layout.
- Normalize positions and sizes against `1600x900` first.
- Then map those ratios into anchors, offsets, and sizing rules for `1920x1080`.
- If the same widget repeats, do not rebuild it by hand.
