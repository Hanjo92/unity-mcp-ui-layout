# UI Toolkit Example

Use this example when the target screen is clearly built with `UIDocument`, `UXML`, `USS`, and `VisualElement`.

## Example Prompt

```text
Use $unity-mcp-ui-layout to repair this UI Toolkit settings screen.
Inspect the current UIDocument, UXML, USS, and visual tree first.
Keep layout ownership in containers, not leaf elements.
Clarify which regions own flex direction, width, overflow, and scroll behavior.
If text is breaking the layout, decide whether it should wrap, truncate, or grow its container before shrinking fonts.
Verify the result at the main target width and one narrower width.
```

## Why This Works

- It forces discovery before styling changes.
- It treats flex ownership as a container problem first.
- It treats text behavior as a structural decision.

## Suggested References

- [ui-toolkit-layout-rules.md](../unity-mcp-ui-layout/references/ui-toolkit-layout-rules.md)
- [ui-toolkit-failures.md](../unity-mcp-ui-layout/references/ui-toolkit-failures.md)
- [text-layout-rules.md](../unity-mcp-ui-layout/references/text-layout-rules.md)
