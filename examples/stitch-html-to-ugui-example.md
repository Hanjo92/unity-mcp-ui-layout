# Stitch HTML to UGUI Example

Use this example when the user provides Google Stitch-exported HTML/CSS (or similar front-end export artifacts) and wants a stable UGUI conversion.

## Example Prompt

```text
Use $unity-mcp-ui-layout to build this UGUI screen from the attached Google Stitch export.

Inputs:
- exported html: <path or pasted content>
- exported css: <path or pasted content>
- exported assets: <list>
- reference resolution: <width>x<height>
- target stack: UGUI
- target profile: <1920x1080, mobile portrait/landscape if needed>

Do not use direct API calls. Keep the conversion structure-first:
1. Read the export and identify structural containers, repeating blocks, overflow/scroll areas, and any absolute-only decorative overlays.
2. Map the DOM-like hierarchy to UGUI containers first:
   - section/main/footer/header/nav wrappers become anchor-owned region containers
   - repeated item blocks become one reusable unit under one parent content container
   - images become Image/raw image roles
   - headings, labels, body, captions, and button text become TextMeshProUGUI roles
3. Convert `display:flex` containers into container layout ownership (HorizontalLayoutGroup / VerticalLayoutGroup / GridLayoutGroup), and avoid assigning many leaf-level offsets when a parent can own spacing/alignment.
4. Handle `overflow/scroll` as `ScrollRect -> Viewport -> Content`, keep fixed headers/filters/footer buttons outside the scrolling area unless the design explicitly scrolls them.
5. For absolute-positioned nodes, only keep absolute intent if it's truly an overlay or badge; otherwise convert into layout-aware containers.
6. If this is mobile and safe area is required, apply safe area on the correct root parent once, then remap edge spacing inside that boundary.
7. Return a UGUI hierarchy plan and list any CSS features that cannot be represented cleanly as a fallback note.
```

## Why This Prompt Works

- it declares source type and target profile before the hierarchy, so the conversion starts with stable ownership.
- it explicitly forbids API behavior, matching current task scope.
- it separates flex conversion, repeated block reuse, scroll ownership, absolute intent, and safe-area ownership into independent decisions.
- it asks for fallback notes so unsupported CSS is surfaced instead of hidden.

## Suggested References

- [stitch-html-to-ugui.md](../unity-mcp-ui-layout/references/stitch-html-to-ugui.md)
- [image-to-layout.md](../unity-mcp-ui-layout/references/image-to-layout.md)
- [ugui-anchors-canvas-scaler.md](../unity-mcp-ui-layout/references/ugui-anchors-canvas-scaler.md)
- [scroll-view-patterns.md](../unity-mcp-ui-layout/references/scroll-view-patterns.md)
- [mockup-safe-area-mapping.md](../unity-mcp-ui-layout/references/mockup-safe-area-mapping.md)
- [text-layout-rules.md](../unity-mcp-ui-layout/references/text-layout-rules.md)
- [review-checks.md](../unity-mcp-ui-layout/references/review-checks.md)

