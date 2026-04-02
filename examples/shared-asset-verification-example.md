# Shared Asset Verification Example

Use this example when a one-screen repair might accidentally mutate a shared base asset.

## Example Prompt

```text
Use $unity-mcp-ui-layout to repair this screen, but verify shared asset impact before changing anything common.
If the affected widget comes from a shared prefab, sprite, material, or TMP style family, find one additional known usage first.
Compare whether the requested change truly belongs to the shared contract or should stay local through a variant, wrapper, duplicated asset, or local override.
Do not edit the shared base directly until that comparison is explicit.
```

## Why This Works

- It forces impact review before direct base edits.
- It keeps one-screen rescue work from quietly becoming a project-wide regression.
- It gives the agent a concrete decision gate instead of a vague warning.

## Suggested References

- `D:\UnityUICreater\unity-mcp-ui-layout\references\shared-asset-edit-safety.md`
- `D:\UnityUICreater\unity-mcp-ui-layout\references\shared-asset-verification-recipes.md`
- `D:\UnityUICreater\unity-mcp-ui-layout\references\prefab-variants.md`
