# Repair With Asset-Aware Reuse Example

Use this example when an existing screen needs a bounded repair, but the affected widget might belong to a reusable prefab, variant family, shared sprite, material, or text style.

## Scenario

The current UI mostly works, but one repeated or shared-looking block is misaligned, visually outdated, or missing a local state. The goal is not to rebuild the screen. The goal is to repair the target area while making an explicit reuse decision: direct reuse, prefab variant, wrapper, local override, or new base prefab.

## Example Prompt

```text
Use $unity-mcp-ui-layout to repair the [target region or widget] in asset-aware mode.
Keep this in repair mode unless inspection proves the existing structure is not worth preserving.
Inspect the current screen, parent chain, and similar reusable UI candidates before creating new assets or placeholders.

Follow this reuse decision order:
1. Reuse an existing stable prefab or UI block directly if only data, text, icon, count, or state values need to change.
2. Create a prefab variant or thin wrapper if the base structure is right but this screen needs scoped visuals, optional sections, or local behavior.
3. Create a new base prefab only if existing candidates are structurally misleading, too coupled, or unsafe to extend.

Keep screen-level placement in the parent container instead of pushing one-screen anchors, offsets, or layout ownership into a shared base prefab.
If a variant would need many structural overrides, stop and reconsider a wrapper or new base prefab.
If a direct shared-base edit still looks necessary, find one additional known usage first and compare whether the requested change should apply there too.
If that impact cannot be verified, prefer a variant, wrapper, local override, or screen-owned asset.
Do not mutate shared sprites, materials, or TMP styles for a one-screen visual or text fix unless the change is truly global.
Name any new or promoted assets by role and scope, and keep placeholders visibly provisional.
Verify the repaired target screen and one related base-family usage before finalizing.
```

## Why This Works

- It keeps a repair request from quietly becoming a broad rebuild.
- It forces reusable asset discovery before placeholder-driven reconstruction.
- It separates data-level reuse from variant-worthy scoped differences.
- It prevents one-screen anchors or spacing fixes from leaking into shared prefab bases.
- It gives direct shared-base edits a concrete verification gate.
- It keeps shared sprites, materials, and text styles out of local rescue fixes.

## Decision Checklist

- Did the task stay in repair mode unless a rebuild was justified?
- Were existing prefab or reusable UI candidates inspected before creating anything new?
- Is the chosen path explicit: direct reuse, variant, wrapper, local override, or new base?
- If a variant was considered, did the base structure still fit without heavy structural overrides?
- Are screen-level placement rules kept outside shared prefab assets?
- Was another known usage checked before any direct shared-base edit?
- Were shared sprites, materials, and TMP styles left alone unless the change was truly global?
- Are new or promoted assets named by role and scope rather than copy history or temporary labels?

## Suggested References

- [ui-change-modes.md](../unity-mcp-ui-layout/references/ui-change-modes.md)
- [existing-prefab-reuse.md](../unity-mcp-ui-layout/references/existing-prefab-reuse.md)
- [prefab-variants.md](../unity-mcp-ui-layout/references/prefab-variants.md)
- [shared-asset-edit-safety.md](../unity-mcp-ui-layout/references/shared-asset-edit-safety.md)
- [shared-asset-verification-recipes.md](../unity-mcp-ui-layout/references/shared-asset-verification-recipes.md)
- [asset-naming-and-folders.md](../unity-mcp-ui-layout/references/asset-naming-and-folders.md)
- [prompt-patterns.md](../unity-mcp-ui-layout/references/prompt-patterns.md)
