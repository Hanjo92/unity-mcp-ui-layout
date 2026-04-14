# Repair One Region Example

Use this example when the screen mostly works, but one named region should be repaired without redesigning the rest.

## Example Prompt

```text
Use $unity-mcp-ui-layout to repair only the [named region] of the current UI.
Keep the rest of the screen unchanged unless the parent structure is the direct cause.
Inspect the current parent chain first, explain the likely structural cause, then apply the smallest fix that stabilizes this region.
Verify the result with a screenshot focused on the repaired region and one full-screen verification pass.
```

## Why This Works

- It keeps scope bounded.
- It reduces the chance of unintended redesign.
- It still allows a parent-level fix when the parent is the real cause.

## Suggested References

- [ui-change-modes.md](../unity-mcp-ui-layout/references/ui-change-modes.md)
- [common-failures.md](../unity-mcp-ui-layout/references/common-failures.md)
- [prompt-patterns.md](../unity-mcp-ui-layout/references/prompt-patterns.md)
