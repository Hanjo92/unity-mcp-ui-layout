# Examples

This folder contains practical prompt examples for common Unity UI tasks.

Use these files when you want a copyable starting point instead of only reference guidance.

## Quick Rules

- Group the top-level layout by anchor-owned regions before tuning leaf widgets.
- Reuse repeated structures through prefabs or reusable layout blocks.
- Keep likely single-image regions intact unless runtime behavior requires decomposition.
- Verify structure with screenshots instead of chasing raw pixel alignment.

## Included Examples

- `hud-example.md`
- `inventory-example.md`
- `popup-safe-area-example.md`

## How to Use

1. Pick the example closest to your task.
2. Copy the prompt and adapt the target resolution, UI stack, and requested scope.
3. Keep the top-level layout grouped by anchor-owned regions, reuse repeated structures, and avoid over-splitting likely single-image assets.
4. Use the linked reference documents when you need deeper rules or troubleshooting.

## Suggested Reading Order

1. `hud-example.md` if you are starting with a composition-driven overlay
2. `inventory-example.md` if your UI is slot- or list-based
3. `popup-safe-area-example.md` if mobile safe area and modal structure matter
