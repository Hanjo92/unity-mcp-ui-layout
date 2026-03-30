# Shared Asset Edit Safety

Use this guide when the requested UI change touches assets that might be shared across screens.

This includes:

- shared prefabs
- prefab families
- common sprites
- shared materials
- TMP styles or font presentation assets

The goal is to avoid solving a one-screen task by destabilizing a shared asset family.

## 1. Core Decision

Before editing an existing shared asset, decide which of these is safest:

1. direct shared-asset edit
2. variant or wrapper
3. local screen-owned override
4. new asset family

Do not assume direct editing is the default.

## 2. When Direct Edit Is Reasonable

Direct shared-asset edit is acceptable only when:

- the requested change clearly improves the shared base contract
- the change is intended for all known usages
- the visual or structural shift is small and consistent with the design system
- there is no obvious screen-specific behavior being pushed into the base

Examples:

- fixing a genuinely broken shared padding rule
- correcting a shared icon alignment bug
- improving a shared button text inset that is wrong everywhere

## 3. When Direct Edit Is Risky

Direct shared-asset edit is risky when:

- the user asked for a one-screen repair
- the requested layout difference is screen-specific
- the change adds or removes optional sections only one screen needs
- the base asset is already used by several families
- the impact radius is unknown

In those cases, prefer variant, wrapper, or local screen-owned composition.

## 4. Variant vs Wrapper

Use a variant when:

- the base structure is right
- only scoped visuals or optional sections differ
- the base contract should remain intact

Use a wrapper when:

- the screen needs extra surrounding layout
- the base widget should stay unchanged inside a screen-specific host
- screen-level positioning or composition should not pollute the shared base

## 5. Shared Non-Prefab Assets

Apply similar caution to:

### Sprites

- Do not replace a shared sprite asset just to satisfy one screen's temporary art need.
- Prefer a screen-owned sprite or a placeholder replacement path if the design is not final.

### Materials

- Do not mutate a common UI material for one popup effect if other screens rely on it.
- Prefer a duplicated or screen-owned material when the visual treatment is local.

### TMP Styles or Font Assets

- Do not push one screen's emergency size tweak into a common text style unless the shared text system really should change everywhere.
- Prefer local style application or a new named style when the role differs.

## 6. Verification Before Direct Edit

Before directly editing a shared asset, try to verify at least one additional known usage.

If another usage cannot be checked:

- treat the edit as higher risk
- bias toward variant, wrapper, or local override unless the change is clearly global

## 7. Anti-Patterns

Avoid these:

- fixing one popup by editing the common button base for every screen
- editing a shared sprite just because it is already loaded in the scene
- using a shared material as a scratch pad for local experimentation
- changing a common TMP style to rescue one crowded row

## 8. Review Questions

Ask:

- Is this asset truly shared?
- Is the requested change truly shared?
- Would another screen be surprised by this edit?
- Should this be a variant, wrapper, or local override instead?
- Did we verify another usage before editing the shared base directly?

If those answers are unclear, direct base edit is probably too risky.
