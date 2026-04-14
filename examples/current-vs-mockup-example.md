# Current UI vs Mockup Example

Use this example when the UI already exists, but the task is to compare it against a reference image and identify where the composition diverges.

## Example Prompt

```text
Use $unity-mcp-ui-layout to compare the current UI against the attached mockup before changing anything.
Identify which differences come from parent containers, anchor ownership, scaling rules, safe-area handling, or text behavior.
Report the structural mismatches first, then apply only the smallest fix needed for the highest-impact mismatch.
Verify the repaired result against the mockup with a screenshot.
```

## Why This Works

- It separates diagnosis from implementation.
- It pushes the agent toward structure-first comparison.
- It prevents unnecessary redesign while still using the mockup as the truth source.

## Suggested References

- [image-to-layout.md](../unity-mcp-ui-layout/references/image-to-layout.md)
- [layout-checklist.md](../unity-mcp-ui-layout/references/layout-checklist.md)
- [prompt-patterns.md](../unity-mcp-ui-layout/references/prompt-patterns.md)
