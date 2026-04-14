# Long Labels and Counters Example

Use this example when long button labels, multi-line descriptions, and growing numbers all compete for space on the same screen.

## Example Prompt

```text
Use $unity-mcp-ui-layout to stabilize this UI for long labels, multi-line body text, and number growth.
Inspect which containers own width first.
Let descriptions wrap where appropriate, keep action labels visually balanced, and make sure counters have headroom for realistic value growth.
Do not rely on extreme auto-size ranges as the primary fix.
Verify the result with one longer body text sample and one larger numeric sample.
```

## Why This Works

- It combines the three most common text-stability risks in one prompt.
- It keeps number growth and text wrapping from being treated as separate afterthoughts.
- It pushes the agent toward container fixes before font-size rescue.

## Suggested References

- [text-layout-rules.md](../unity-mcp-ui-layout/references/text-layout-rules.md)
- [prompt-patterns.md](../unity-mcp-ui-layout/references/prompt-patterns.md)
