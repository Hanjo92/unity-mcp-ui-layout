# Shared Asset Verification Recipes

Use this guide when a requested UI change might touch a shared prefab, sprite, material, or TMP style and you need a practical review flow before editing the shared base directly.

These recipes are intentionally conservative.
The point is to stop one-screen fixes from quietly becoming shared regressions.

## 1. Shared Prefab Verification

Use this when the target widget may belong to a shared prefab family.

### Typical sequence

1. Inspect the current screen instance and identify the likely prefab family
2. Decide whether the requested change is truly shared or still local
3. Find at least one additional known usage of the same family
4. Compare whether the requested change would still make sense there
5. Only then decide between direct base edit, variant, wrapper, or local override

### Example prompt

```text
Before editing this shared prefab directly, inspect the current screen instance and identify one additional known usage of the same prefab family.
Compare whether the requested change belongs to the shared base contract or should stay local through a variant, wrapper, or override.
Do not edit the shared base until that comparison is explicit.
```

### Common calls

- `find_gameobjects`
- `manage_prefabs`
- `manage_gameobject`
- `manage_components`
- `manage_camera`

## 2. Shared Sprite Verification

Use this when a screen seems to rely on a common sprite or atlas-backed visual.

### Typical sequence

1. Confirm that the sprite is truly shared and not screen-owned
2. Inspect one other usage where the same sprite appears
3. Decide whether the requested visual change belongs to the shared art contract
4. If not, use a screen-owned sprite, placeholder replacement path, or different asset instead of mutating the shared one

### Example prompt

```text
Inspect whether this sprite is shared across more than one screen before changing it.
Find one other usage of the same sprite or sprite-backed visual and compare whether the requested change should really apply there too.
If not, keep the change local instead of mutating the shared sprite asset.
```

## 3. Shared Material Verification

Use this when a requested effect might be applied by changing a common UI material.

### Typical sequence

1. Confirm that the material is common rather than screen-owned
2. Inspect another usage that depends on the same material
3. Decide whether the requested visual effect is part of the common treatment or only local to the target screen
4. If local, duplicate or localize the material instead of editing the shared one

### Example prompt

```text
Inspect whether this UI material is shared by other screens before editing it.
Find at least one additional usage and compare whether the requested effect belongs to the shared visual contract or only to this screen.
If it is local, use a duplicated or screen-owned material instead of mutating the shared one.
```

## 4. Shared TMP Style Verification

Use this when a text layout fix might tempt you to change a shared TMP style or shared text presentation rule.

### Typical sequence

1. Confirm that the current text styling comes from a shared style family
2. Inspect one other usage of the same style role
3. Decide whether the requested change is a true role improvement or a local rescue tweak
4. If it is local, use a local style, local override, or new named style instead of rewriting the common one

### Example prompt

```text
Inspect whether this text style is shared before changing it.
Find one other usage of the same style role and compare whether the requested size, spacing, or overflow change should really apply there too.
If it is only a local rescue tweak, keep it out of the shared text style.
```

## 5. Minimum Safe Review Rule

If you cannot inspect another known usage:

- treat direct shared-base editing as higher risk
- bias toward variant, wrapper, local override, or duplicated asset
- only proceed with direct edit if the change is obviously global and low-risk

## 6. Review Questions

Ask:

- Did we confirm the asset is truly shared?
- Did we inspect at least one additional known usage before editing the shared base directly?
- Did the requested change still make sense in that additional usage?
- If we could not verify another usage, did we bias toward a safer local path?

If the answer is no, direct shared-base editing is probably still under-verified.
