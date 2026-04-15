# Scroll View Example

Use this example when the mockup or existing screen is clearly a scrollable list, feed, catalog, or stacked card surface.

## Example Prompt

```text
Use $unity-mcp-ui-layout to build or repair this scroll-heavy UI.
Decide the scroll owner first, then separate the structure into scroll shell, viewport, content container, and repeated item unit.
If this is UGUI, keep the shell as `ScrollRect -> Viewport -> Content` and make the repeated row/card/cell one reusable prefab or reusable layout block under `Content`.
If this is UI Toolkit, keep one deliberate scroll owner, one content container, and one reusable repeated item structure instead of patching each row independently.
Keep headers, filters, tabs, and footer actions outside the scrolling content unless the design explicitly wants them to scroll too.
Verify that only the intended region scrolls and that longer content does not break the repeated item layout.
```

## Why This Works

- It separates scroll ownership from repeated-item reuse.
- It prevents the whole scroll shell from being mistaken for the reusable unit.
- It keeps fixed chrome outside the list content when the design expects that behavior.

## Suggested References

- [scroll-view-patterns.md](../unity-mcp-ui-layout/references/scroll-view-patterns.md)
- [ugui-inventory.md](../unity-mcp-ui-layout/references/ugui-inventory.md)
- [ui-toolkit-layout-rules.md](../unity-mcp-ui-layout/references/ui-toolkit-layout-rules.md)
