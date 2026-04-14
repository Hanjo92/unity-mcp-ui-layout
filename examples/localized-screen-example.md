# Localized Screen Example

Use this example when the screen must survive both short English text and longer translated strings.

## Example Prompt

```text
Use $unity-mcp-ui-layout to repair this screen so it survives both short English strings and longer localized text.
Treat text as a layout driver.
For each important region, decide whether text should wrap, truncate, remain single-line, or grow its container.
Do not solve the issue by shrinking fonts first.
Verify the result with one shorter label set and one longer translated label set before calling it stable.
```

## Why This Works

- It forces the agent to plan for more than one text length.
- It keeps text behavior explicit instead of accidental.
- It discourages “works in English only” layout fixes.

## Suggested References

- [text-layout-rules.md](../unity-mcp-ui-layout/references/text-layout-rules.md)
- [review-checks.md](../unity-mcp-ui-layout/references/review-checks.md)
