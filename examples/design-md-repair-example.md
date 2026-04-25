# DESIGN.md Repair Example

Use this example when an existing Unity UI screen should be repaired while preserving a provided `DESIGN.md` or design-token document.

## Example Prompt

```text
Use $unity-mcp-ui-layout to repair the existing [screen name] UI while preserving DESIGN.md.
Read DESIGN.md before editing anything.
Keep the repair bounded to [named region or specific problem].
Inspect the current UI stack, parent chain, shared prefabs/styles, and any local overrides before changing values.

Compare the current screen against DESIGN.md tokens and prose intent.
Detect style drift: local colors, fonts, spacing, radii, TMP styles, USS classes, sprites, or materials that do not match the design source.
Do not replace drift with new random local values; either restore the matching DESIGN.md token/style or explain why the screen needs a scoped override.
If a shared prefab, TMP style, material, sprite, USS selector, or UXML template is involved, check other usages before editing the shared asset.
Prefer a variant, wrapper, or local override when the repair is screen-specific.
Preserve existing behavior outside the bounded repair area unless the parent structure directly causes the issue.
Verify with a before/after screenshot at the main target resolution and one alternate aspect ratio if layout could shift.
Report the drift found, the bounded changes made, shared-asset safety checks, and any DESIGN.md gaps.
```

## Why This Works

- It repairs against the design source instead of eyeballing a new style.
- It prevents one-screen fixes from leaking into shared assets.
- It keeps the agent focused on the named problem area.

## Suggested References

- [design-system-intake.md](../unity-mcp-ui-layout/references/design-system-intake.md)
- [design-token-to-unity.md](../unity-mcp-ui-layout/references/design-token-to-unity.md)
- [ui-change-modes.md](../unity-mcp-ui-layout/references/ui-change-modes.md)
- [common-failures.md](../unity-mcp-ui-layout/references/common-failures.md)
- [shared-asset-edit-safety.md](../unity-mcp-ui-layout/references/shared-asset-edit-safety.md)
- [prompt-patterns.md](../unity-mcp-ui-layout/references/prompt-patterns.md)
