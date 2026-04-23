# Mockup Decomposition Example

Use this example when a mockup exists and the main risk is splitting visual regions too much, or not splitting runtime-owned parts enough.

## Scenario

- A mockup image exists.
- The UI may contain baked decorative art, repeated cards or rows, and interactive widgets.
- The task needs a decomposition decision before layout tuning or pixel matching.

## Example Prompt

```text
Use $unity-mcp-ui-layout to build this UI from the attached mockup.
Before creating objects, inspect the mockup and write a decomposition pass:
- top-level anchor-owned regions
- repeated groups that should become reusable blocks or prefabs
- runtime-owned widgets that need interaction, dynamic text, state, animation, safe-area behavior, or adaptive layout
- decorative or baked regions that should stay as one image or sprite region

Decompose by runtime responsibility, not by visual outline alone.
Keep decorative panels, ornaments, and baked art whole unless runtime behavior requires separation.
Do not trace every visible seam into a child object.
Turn repeated cards, rows, slots, button groups, or badge clusters into one reusable pattern before placing copies.
After the decomposition pass, build parent containers before leaf widgets and keep likely single-image regions simple.
Verify that every split has a runtime reason and that no repeated block was rebuilt manually.
```

## Why This Works

- It makes asset granularity a deliberate decision before layout work starts.
- It prevents fake child objects that only mirror visual edges in the mockup.
- It keeps interactive, stateful, and adaptive parts separate from baked art.
- It promotes repeated structures into reusable blocks instead of one-off copies.

## Decision Checklist

- Can each split be justified by interaction, dynamic data, state, animation, safe-area behavior, or adaptive layout?
- Did decorative panels, ornaments, and baked art stay whole where possible?
- Are repeated cards, rows, slots, button groups, or badge clusters represented by one reusable pattern?
- Are top-level regions grouped before atomic widgets are tuned?
- Would another engineer understand why each region exists at runtime?

## Suggested References

- [mockup-decomposition.md](../unity-mcp-ui-layout/references/mockup-decomposition.md)
- [image-to-layout.md](../unity-mcp-ui-layout/references/image-to-layout.md)
- [mockup-resolution.md](../unity-mcp-ui-layout/references/mockup-resolution.md)
- [prompt-patterns.md](../unity-mcp-ui-layout/references/prompt-patterns.md)
