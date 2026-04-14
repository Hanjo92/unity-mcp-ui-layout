# Asset Naming Example

Use this example when the task is not only to build UI, but also to normalize asset names and folder placement so future reuse is easier.

## Example Prompt

```text
Use $unity-mcp-ui-layout to normalize the naming and folder placement of the UI assets touched by this change.
Decide which assets are truly shared and which are screen-owned.
Move shared assets into stable common UI folders, keep screen-owned assets near the screen that owns them, and keep placeholders visibly provisional.
Rename assets by role and scope instead of copy-history, coordinates, or temporary labels.
If a prefab family has real variants, group them near the base prefab in a clear Variants folder.
```

## Why This Works

- It forces a scope decision before renaming or moving assets.
- It discourages accidental promotion into `Common`.
- It gives the agent a stable target structure for future discovery.

## Suggested References

- [asset-naming-and-folders.md](../unity-mcp-ui-layout/references/asset-naming-and-folders.md)
- [asset-naming-examples.md](../unity-mcp-ui-layout/references/asset-naming-examples.md)
