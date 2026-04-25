# DESIGN.md Layout Example

Use this example when you are building a new Unity UI screen from a mockup plus a `DESIGN.md` or design-token document.

## Example Prompt

```text
Use $unity-mcp-ui-layout to build a new [screen name] UI from the attached mockup and DESIGN.md.
Read DESIGN.md before editing anything.
Extract the design tokens and the prose intent: spacing, color, typography, radius, component states, density, hierarchy, and any layout stability rules.
Identify the active UI stack:
- For UGUI/TMP, map tokens to CanvasScaler, RectTransform anchors, TMP styles, sprites, materials, and reusable prefabs where appropriate.
- For UI Toolkit, map tokens to UXML structure, USS variables/classes, VisualElement layout, typography, and reusable templates where appropriate.
- If both stacks appear possible, ask before editing.

Create the screen structure from containers outward.
Preserve layout stability rules from DESIGN.md, including safe areas, fixed versus flexible regions, wrapping/truncation behavior, scroll ownership, and alternate aspect ratios.
Do not invent local colors, fonts, spacing, or component styles when DESIGN.md already defines them.
If component tokens define both text and background colors, check their contrast in the implemented state.
Verify with screenshots at the main target resolution and one alternate aspect ratio.
Report which tokens were applied, any DESIGN.md gaps, the screenshot checks, and any contrast concerns.
```

## Why This Works

- It treats `DESIGN.md` as the source of truth before the mockup is translated.
- It maps tokens differently for UGUI/TMP and UI Toolkit instead of mixing stack rules.
- It keeps responsive behavior and contrast checks inside the first build pass.

## Suggested References

- [design-system-intake.md](../unity-mcp-ui-layout/references/design-system-intake.md)
- [design-token-to-unity.md](../unity-mcp-ui-layout/references/design-token-to-unity.md)
- [layout-checklist.md](../unity-mcp-ui-layout/references/layout-checklist.md)
- [ugui-anchors-canvas-scaler.md](../unity-mcp-ui-layout/references/ugui-anchors-canvas-scaler.md)
- [ui-toolkit-layout-rules.md](../unity-mcp-ui-layout/references/ui-toolkit-layout-rules.md)
- [text-layout-rules.md](../unity-mcp-ui-layout/references/text-layout-rules.md)
