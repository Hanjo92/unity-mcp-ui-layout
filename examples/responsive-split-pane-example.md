# Responsive Split Pane Example

Use this example when the target is a desktop-style, tablet-capable, or editor-like screen with a stable left/right split, such as a list plus detail view, navigation rail plus content panel, inspector view, or management dashboard.

## Scenario

The user wants a split layout that looks stable at the main target width and still behaves intentionally at a narrower width. The goal is to define which container owns the horizontal split, which pane can compress, where scrolling begins, and how text behaves before tuning individual rows or cards.

## Example Prompt

```text
Use $unity-mcp-ui-layout to build or repair this responsive split-pane UI.
Identify the active UI stack first and do not mix UGUI and UI Toolkit in one change unless I explicitly ask for a bridge.
Define the top-level split owner before tuning leaf widgets.

If this is UGUI, use a Canvas with CanvasScaler, then create stable major regions such as `ContentRoot -> LeftPane -> RightPane`.
Use stretch anchors for the content body, give the left pane an intentional fixed/min width, and let the right pane own the remaining detail area.
If this is UI Toolkit, inspect the UIDocument, UXML, USS, and visual tree first, then put horizontal split, min widths, flex grow/shrink, spacing, and overflow on containers rather than leaf elements.

Decide the narrow-width behavior explicitly:
- keep the left pane fixed and let the right pane compress
- collapse the left pane to an icon rail
- stack panes vertically
- or require a wider/tablet layout only if the product explicitly allows that constraint

Keep scroll ownership deliberate. If both panes contain long content, each pane may have its own scroll owner, but avoid nested scroll containers inside the same pane.
Keep headers, filters, tabs, and footer actions outside a pane's scrolling content unless the design explicitly wants them to scroll.
Turn repeated rows, cards, inspector fields, or navigation items into one reusable pattern instead of rebuilding each item by hand.
Treat row labels, detail titles, counters, and metadata as layout drivers; decide whether they wrap, truncate, or reserve width before shrinking fonts.
Verify at the main target width and one narrower width, and include a wider/tablet check if this screen is expected to support it.
```

## Why This Works

- It makes the horizontal split a parent-container decision instead of a pile of leaf offsets.
- It forces an explicit narrow-width strategy before flex or anchor defaults choose one accidentally.
- It separates pane ownership from per-pane scrolling and repeated row/card layout.
- It keeps text behavior from becoming an emergency font-size fix.
- It gives tablet-capable or editor-style screens a verification target beyond the main width.

## Decision Checklist

- Is the active UI stack clear: UGUI or UI Toolkit?
- Which parent owns the left/right split?
- Does each pane have an intentional width, min width, or flex rule?
- Is the narrow-width behavior named instead of left to defaults?
- Are scroll owners limited to the panes that actually need scrolling?
- Do fixed headers, filters, tabs, and footer actions stay outside the scrolling content where appropriate?
- Are repeated rows or cards handled through a reusable pattern?
- Were text wrapping, truncation, and value widths decided before font-size changes?
- Was the layout checked at the main width and one narrower width?
- Was a wider/tablet check included when the screen is expected to support it?

## Suggested References

- [ui-toolkit-layout-rules.md](../unity-mcp-ui-layout/references/ui-toolkit-layout-rules.md)
- [ugui-anchors-canvas-scaler.md](../unity-mcp-ui-layout/references/ugui-anchors-canvas-scaler.md)
- [scroll-view-patterns.md](../unity-mcp-ui-layout/references/scroll-view-patterns.md)
- [text-layout-rules.md](../unity-mcp-ui-layout/references/text-layout-rules.md)
- [mobile-device-profiles.md](../unity-mcp-ui-layout/references/mobile-device-profiles.md)
- [review-checks.md](../unity-mcp-ui-layout/references/review-checks.md)
- [layout-checklist.md](../unity-mcp-ui-layout/references/layout-checklist.md)
