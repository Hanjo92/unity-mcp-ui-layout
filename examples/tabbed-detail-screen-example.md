# Tabbed Detail Screen Example

Use this example when the target screen has tabs, filters, or category buttons that switch between detail panels, lists, or cards while shared chrome such as headers and footer actions should stay fixed.

## Scenario

The user wants a screen with a stable tab bar and a content area that changes by selected tab. The goal is to define tab ownership, content host ownership, scroll behavior, and tab label text rules before styling individual tab contents.

## Example Prompt

```text
Use $unity-mcp-ui-layout to build or repair this tabbed detail screen.
Identify the active UI stack first and do not mix UGUI and UI Toolkit in one change unless I explicitly ask for a bridge.
Build or repair the shell before styling individual tabs: `ScreenRoot -> Header -> TabBar -> ContentHost -> FooterActions`.

Keep the TabBar, filters, header, and footer actions outside the scrolling content unless the design explicitly wants them to scroll.
Make the TabBar one reusable tab-button pattern with clear selected, unselected, disabled, and overflow behavior.
Decide whether tab labels should stay single-line, truncate, wrap, or move into a more compact mode before shrinking fonts.

For UGUI, put tab buttons under a layout-owned row and keep active content under a bounded `ContentHost`; if the active tab has long content, use `ScrollRect -> Viewport -> Content` inside that tab panel.
For UI Toolkit, inspect the UIDocument, UXML, USS, and visual tree first; keep tab row layout, selected-state styling, content switching, and overflow behavior in containers and reusable classes rather than leaf overrides.

If each tab has repeated rows or cards, create one reusable row/card pattern inside that tab's content container.
Verify the selected tab state, at least one alternate tab, longer tab labels, and a longer content set.
Verify at the main target size and one narrower width or alternate aspect ratio before finalizing.
```

## Why This Works

- It separates fixed navigation chrome from scrollable or switchable tab content.
- It treats the tab button family as a reusable pattern instead of hand-styling each tab.
- It gives tab labels explicit text behavior before font shrinking.
- It keeps scroll ownership local to the active content panel.
- It verifies more than the default selected tab.

## Decision Checklist

- Is the UI stack clear: UGUI or UI Toolkit?
- Are Header, TabBar, ContentHost, and FooterActions owned by distinct parent regions?
- Do tabs, filters, headers, and footer actions stay outside scrolling content where appropriate?
- Is there one reusable tab-button pattern with selected, unselected, disabled, and overflow states?
- Are tab label overflow rules explicit?
- Does only the active content panel own scrolling when content is long?
- Are repeated rows or cards inside tab content reusable?
- Was at least one alternate tab checked, not only the default selected tab?
- Was the layout checked with longer tab labels and a longer content set?

## Suggested References

- [scroll-view-patterns.md](../unity-mcp-ui-layout/references/scroll-view-patterns.md)
- [text-layout-rules.md](../unity-mcp-ui-layout/references/text-layout-rules.md)
- [ui-toolkit-layout-rules.md](../unity-mcp-ui-layout/references/ui-toolkit-layout-rules.md)
- [ugui-anchors-canvas-scaler.md](../unity-mcp-ui-layout/references/ugui-anchors-canvas-scaler.md)
- [review-checks.md](../unity-mcp-ui-layout/references/review-checks.md)
- [prompt-patterns.md](../unity-mcp-ui-layout/references/prompt-patterns.md)
