# Shared Asset Safety Example

Use this example when the requested change might touch a common prefab, sprite, material, or TMP style that is reused across multiple screens.

## Example Prompt

```text
Use $unity-mcp-ui-layout to repair this inventory row without destabilizing shared assets.
Inspect whether the current widget is a shared prefab family first.
If the requested change is screen-specific, prefer a variant, wrapper, or local override instead of editing the shared base directly.
Only edit the shared asset itself if you can justify that the change should apply across its other usages too.
```

## Why This Works

- It forces a scope decision before editing.
- It reduces accidental shared-base regressions.
- It keeps one-screen repairs from leaking into the design system.

## Suggested References

- [shared-asset-edit-safety.md](../unity-mcp-ui-layout/references/shared-asset-edit-safety.md)
- [existing-prefab-reuse.md](../unity-mcp-ui-layout/references/existing-prefab-reuse.md)
- [prefab-variants.md](../unity-mcp-ui-layout/references/prefab-variants.md)
