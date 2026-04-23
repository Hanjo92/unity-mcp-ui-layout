# Examples

This folder contains practical prompt examples for common Unity UI tasks.

Use these files when you want a copyable starting point instead of only reference guidance.

## Quick Rules

- Group the top-level layout by anchor-owned regions before tuning leaf widgets.
- Reuse repeated structures through prefabs or reusable layout blocks.
- Keep likely single-image regions intact unless runtime behavior requires decomposition.
- Verify structure with screenshots instead of chasing raw pixel alignment.

## Included Examples

- `first-layout-pass-example.md`
- `hud-example.md`
- `inventory-example.md`
- `mockup-resolution-example.md`
- `mobile-safe-area-mockup-example.md`
- `current-vs-mockup-example.md`
- `popup-safe-area-example.md`
- `scroll-view-example.md`
- `repair-one-region-example.md`
- `repair-asset-aware-reuse-example.md`
- `asset-naming-example.md`
- `localized-screen-example.md`
- `long-labels-and-counters-example.md`
- `shared-asset-safety-example.md`
- `shared-asset-verification-example.md`
- `ui-toolkit-example.md`

## How to Use

1. Pick the example closest to your task.
2. Copy the prompt and adapt the target resolution, UI stack, and requested scope.
3. Keep the top-level layout grouped by anchor-owned regions, reuse repeated structures, and avoid over-splitting likely single-image assets.
4. Use the linked reference documents when you need deeper rules or troubleshooting.

## Pick by Stack

- Start with `first-layout-pass-example.md` if you are new to the workflow or want one small structure-first practice task before choosing a domain-shaped example.
- Start with `hud-example.md`, `inventory-example.md`, `popup-safe-area-example.md`, or `mobile-safe-area-mockup-example.md` when the target is clearly UGUI.
- Start with `scroll-view-example.md` when the main problem is list/feed/catalog scrolling plus repeated item reuse.
- Start with `ui-toolkit-example.md` when the target is clearly driven by `UIDocument`, `UXML`, and `USS`.
- If the stack is not obvious yet, decide that first before choosing a task-shaped example.

## Pick by Problem

- Start with `first-layout-pass-example.md` when you need a small build-mode exercise before choosing a domain-shaped example.
- Start with `current-vs-mockup-example.md` when the existing screen should be compared against a reference before repair.
- Start with `repair-one-region-example.md` when the request must stay bounded to one named region.
- Start with `repair-asset-aware-reuse-example.md` when the repair may touch reusable prefabs, variants, wrappers, shared sprites, materials, or text styles.
- Start with `shared-asset-verification-example.md` when a direct shared-base edit might be needed but another usage should be checked first.
- Start with `asset-naming-example.md` when the task creates, promotes, or normalizes reusable UI assets.
- Start with `localized-screen-example.md` or `long-labels-and-counters-example.md` when text growth is the main layout risk.
- Start with `mobile-safe-area-mockup-example.md` when a mobile mockup ignores notch or home-indicator constraints.

## Suggested Reading Order

1. `first-layout-pass-example.md` if you want the smallest structure-first practice task
2. `hud-example.md` if you are starting with a composition-driven overlay
3. `inventory-example.md` if your UI is slot- or list-based
4. `mockup-resolution-example.md` if the mockup's native pixel resolution should drive planning
5. `current-vs-mockup-example.md` if the screen already exists and should be compared against a reference image first
6. `mobile-safe-area-mockup-example.md` if the mockup ignores notch or home-indicator constraints
7. `popup-safe-area-example.md` if mobile safe area and modal structure matter
8. `scroll-view-example.md` if the core challenge is scroll ownership plus reusable repeated rows or cards
9. `repair-one-region-example.md` if the request should stay bounded to one named region
10. `repair-asset-aware-reuse-example.md` if a repair may need prefab reuse, variants, wrappers, or shared-asset impact checks
11. `asset-naming-example.md` if the task also needs shared-versus-screen asset cleanup
12. `localized-screen-example.md` if the screen must survive both short English and longer localized strings
13. `long-labels-and-counters-example.md` if long labels, body text, and number growth compete for the same layout
14. `shared-asset-safety-example.md` if a repair might touch shared prefabs or other shared UI assets
15. `shared-asset-verification-example.md` if you need a concrete “check another usage first” prompt for shared assets
16. `ui-toolkit-example.md` if the target screen is clearly driven by `UIDocument`, `UXML`, and `USS`
