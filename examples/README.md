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
- `mockup-decomposition-example.md`
- `mobile-safe-area-mockup-example.md`
- `mobile-device-profile-verification-example.md`
- `current-vs-mockup-example.md`
- `popup-safe-area-example.md`
- `settings-dialog-example.md`
- `responsive-split-pane-example.md`
- `tabbed-detail-screen-example.md`
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
- Start with `hud-example.md`, `inventory-example.md`, `popup-safe-area-example.md`, `settings-dialog-example.md`, or `mobile-safe-area-mockup-example.md` when the target is clearly UGUI.
- Start with `scroll-view-example.md` or `tabbed-detail-screen-example.md` when the main problem is list/feed/catalog scrolling plus repeated item reuse.
- Start with `ui-toolkit-example.md`, `settings-dialog-example.md`, or `responsive-split-pane-example.md` when the target is clearly driven by `UIDocument`, `UXML`, and `USS`.
- If the stack is not obvious yet, decide that first before choosing a task-shaped example.

## Pick by Problem

- Start with `first-layout-pass-example.md` when you need a small build-mode exercise before choosing a domain-shaped example.
- Start with `mockup-resolution-example.md` when the mockup's own pixel resolution should drive planning.
- Start with `mockup-decomposition-example.md` when the main question is what should stay baked, what should split, and what should become a reusable block before layout work begins.
- Start with `current-vs-mockup-example.md` when the existing screen should be compared against a reference before repair.
- Start with `repair-one-region-example.md` when the request must stay bounded to one named region.
- Start with `repair-asset-aware-reuse-example.md` when the repair may touch reusable prefabs, variants, wrappers, shared sprites, materials, or text styles.
- Start with `shared-asset-verification-example.md` when a direct shared-base edit might be needed but another usage should be checked first.
- Start with `asset-naming-example.md` when the task creates, promotes, or normalizes reusable UI assets.
- Start with `localized-screen-example.md` or `long-labels-and-counters-example.md` when text growth is the main layout risk.
- Start with `settings-dialog-example.md` when the screen is a dense options, preferences, pause-menu settings, or configuration dialog.
- Start with `responsive-split-pane-example.md` when the screen has a left/right split, navigation rail plus detail panel, inspector view, or tablet-capable dashboard layout.
- Start with `tabbed-detail-screen-example.md` when tabs, filters, or category buttons should stay fixed while selected content switches or scrolls.
- Start with `mobile-safe-area-mockup-example.md` when a mobile mockup ignores notch or home-indicator constraints.
- Start with `mobile-device-profile-verification-example.md` when a mobile-first screen needs explicit verification across a standard phone, a taller phone, and a wider mobile or tablet profile.

## Suggested Reading Order

1. `first-layout-pass-example.md` if you want the smallest structure-first practice task
2. `hud-example.md` if you are starting with a composition-driven overlay
3. `inventory-example.md` if your UI is slot- or list-based
4. `mockup-resolution-example.md` if the mockup's native pixel resolution should drive planning
5. `mockup-decomposition-example.md` if the main question is what should stay baked, split, or become reusable
6. `current-vs-mockup-example.md` if the screen already exists and should be compared against a reference image first
7. `mobile-safe-area-mockup-example.md` if the mockup ignores notch or home-indicator constraints
8. `mobile-device-profile-verification-example.md` if a mobile-first screen needs named profile coverage before approval
9. `popup-safe-area-example.md` if mobile safe area and modal structure matter
10. `settings-dialog-example.md` if the screen is a dense options or preferences dialog
11. `responsive-split-pane-example.md` if the screen uses a left/right split or tablet-capable dashboard layout
12. `tabbed-detail-screen-example.md` if tabs, filters, or category buttons switch the visible content
13. `scroll-view-example.md` if the core challenge is scroll ownership plus reusable repeated rows or cards
14. `repair-one-region-example.md` if the request should stay bounded to one named region
15. `repair-asset-aware-reuse-example.md` if a repair may need prefab reuse, variants, wrappers, or shared-asset impact checks
16. `asset-naming-example.md` if the task also needs shared-versus-screen asset cleanup
17. `localized-screen-example.md` if the screen must survive both short English and longer localized strings
18. `long-labels-and-counters-example.md` if long labels, body text, and number growth compete for the same layout
19. `shared-asset-safety-example.md` if a repair might touch shared prefabs or other shared UI assets
20. `shared-asset-verification-example.md` if you need a concrete “check another usage first” prompt for shared assets
21. `ui-toolkit-example.md` if the target screen is clearly driven by `UIDocument`, `UXML`, and `USS`
