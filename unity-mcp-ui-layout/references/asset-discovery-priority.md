# Asset Discovery Priority

Use this guide when asset-aware mode is active and you need a stable order for checking what the project already has before introducing placeholders or new assets.

## Goal

Prevent random asset choices by following a clear discovery order for existing reusable UI assets.

## Default Discovery Order

Prefer this order:

1. existing reusable prefab or reusable block
2. prefab variant or wrapper candidate
3. existing sprite, atlas entry, or sprite-backed UI image
4. existing font, TMP style, or text style system
5. existing material or shared visual treatment
6. placeholder asset or provisional visual

Do not skip straight to placeholders if higher-confidence reusable assets already exist.

## Why This Order

- Prefabs preserve structure and behavior, not just appearance.
- Variants and wrappers preserve family consistency.
- Sprites preserve the normal UI art workflow.
- Fonts and text styles preserve readability and hierarchy.
- Materials are usually finishing details, not the first reuse anchor.
- Placeholders are acceptable when discovery fails, but should be the last normal step, not the first.

## Practical Rules

- If the same widget already exists as a prefab, check that first before reassembling it from sprites.
- If the same family exists but the current screen needs scoped differences, check for variant or wrapper paths next.
- If no prefab fit exists, look for existing sprite-backed visuals before inventing new temporary art.
- Keep font and text-style reuse deliberate so the screen does not drift away from the project's UI voice.
- Use placeholders only when real asset retrieval is unavailable, low-confidence, or genuinely absent.

## Asset-Aware Mode Behavior

In asset-aware mode:

- inspect reusable prefab candidates first
- then inspect sprite-backed art and text systems
- only after that fall back to placeholder visuals

If the project already has a stable widget family, treat a sudden placeholder-driven rebuild as suspicious.

## Common Anti-Patterns

- Building a widget from scratch even though a close prefab already exists.
- Jumping to a placeholder icon before checking the existing sprite or atlas workflow.
- Reusing a random material first even though the real reuse anchor should have been a prefab or sprite.
- Letting text styles drift because font/TMP reuse was never checked.
- Treating low-confidence asset lookup as permission to stop checking obvious nearby reusable assets.

## Verification Questions

- Did we check reusable prefabs before reconstructing UI from lower-level assets?
- Did we check sprite-backed visuals before inventing placeholders?
- Did we preserve existing font or text style conventions where relevant?
- Are placeholders clearly provisional rather than silent permanent replacements?
