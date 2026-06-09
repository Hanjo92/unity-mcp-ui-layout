# UGUI Anchors and CanvasScaler Rules

Use this guide when the target UI stack is UGUI.

## 1. Canvas Root Rules

Pick the root strategy before touching child coordinates.

### Preferred default

- `Canvas` with `CanvasScaler`
- `UI Scale Mode = Scale With Screen Size`
- `Reference Resolution =` the user-provided target resolution
- `Screen Match Mode = Match Width Or Height`

Use this as the default for most game HUDs, menus, overlays, dialogs, and responsive screen UI.

### When to use `Match Width Or Height`

- Use `match = 0.5` as the neutral default when width and height are equally important.
- Bias toward width when horizontal composition matters more than vertical spacing.
- Bias toward height when vertical spacing and top/bottom stacking matter more.

Do not leave the choice implicit. State why the match setting was chosen.

### When to use `Expand`

- Use when the UI must stay fully visible and can tolerate extra empty space.
- Common for broad background panels or safe container roots.

### When to use `Shrink`

- Use sparingly.
- Only use when the whole UI must remain inside the screen even if it becomes smaller than intended.

### When to use `Constant Pixel Size`

- Use only for intentionally fixed pixel overlays, debug tools, or render surfaces that are not meant to scale responsively.
- Do not use this as the default for gameplay UI copied from a mockup.

### When to use `Constant Physical Size`

- Rare.
- Use only when physical size consistency across DPI is an explicit requirement.

## 2. Container Hierarchy Rules

Build UGUI in layers. This is the UGUI realization of the `image-to-layout.md` layer pass:

1. `Canvas`
2. Safe-area root if needed
3. Screen root or modal/overlay root
4. Major screen regions such as header, footer, left rail, right rail, content, modal root
5. Scroll owners and content roots where applicable
6. Reusable prefab roots or repeated layout block roots
7. Local groups such as rows, columns, grids
8. Runtime leaves and decorative image leaves

Prefer a stable parent container over repeatedly calculating child offsets against the full screen.

## 3. Anchor Selection Rules

Pick anchors from the element's screen relationship.

### Corner HUD widgets

- Top-left minimap, quest tracker: anchor top-left, pivot top-left
- Top-right currencies, status chips: anchor top-right, pivot top-right
- Bottom-left chat, shortcuts: anchor bottom-left, pivot bottom-left
- Bottom-right action cluster: anchor bottom-right, pivot bottom-right

Use offsets as insets from that corner, not as full-screen coordinates.

### Edge bars

- Header bar: stretch horizontally at top, pivot top-center
- Footer bar: stretch horizontally at bottom, pivot bottom-center
- Left rail: stretch vertically on left, pivot left-center
- Right rail: stretch vertically on right, pivot right-center

For these, prefer stretch anchors plus padding rather than fixed widths tied to the screen unless the design explicitly requires a fixed-size rail.

### Centered elements

- Modal dialogs: centered anchors, pivot center
- Crosshair or center reticle: centered anchors, pivot center
- Toast stack near center top: top-center or center-top band parent, not arbitrary x offsets

### Full content panels

- Content body between header and footer: stretch to the parent bounds
- Scroll views and list bodies: stretch inside the content container, then control padding internally

## 4. Pivot Rules

Pivot should match the direction from which the element grows or animates.

- Corner-attached panels: pivot at the same corner
- Top bars: pivot high on the element
- Bottom bars: pivot low on the element
- Center dialogs: pivot center
- Sliding side panels: pivot on the attached edge

Bad pivot choices cause surprising scaling and animation behavior even if anchors are correct.

## 5. Size Rules

Use this order:

1. Decide parent bounds
2. Decide anchors
3. Decide whether the element stretches
4. Set preferred width/height or offsets
5. Only then fine-tune `anchoredPosition`

Avoid setting `sizeDelta` first and trying to recover with anchors afterward.

## 6. Layout Component Rules

### Preferred usage

- Use `HorizontalLayoutGroup`, `VerticalLayoutGroup`, or `GridLayoutGroup` for repeated siblings.
- Use `LayoutElement` to override preferred, min, or flexible size on specific children.
- Use padding and spacing on the group before manual child movement.

### Dangerous combinations

- Parent `LayoutGroup` plus manual child `anchoredPosition`
- `ContentSizeFitter` on an object whose size is already controlled by a parent layout group
- Multiple nested fitters and groups without a clear ownership of width and height

If a layout group owns child positioning, do not also hand-place those children.

## 7. Text and TMP Rules

- Treat text as variable-sized content.
- Give text a clear container width before shrinking font size.
- Prefer wrapping and layout growth rules over fixed boxes that clip unpredictably.
- If a label must stay on one line, encode that as a deliberate rule and test it at target resolutions.
- Check localization risk before freezing sizes tightly around current English text.

## 8. Image and Sprite Rules

- Use 9-sliced sprites for scalable frames and panels.
- Check `Preserve Aspect` only when aspect integrity matters more than filling the slot.
- Decorative art can be fixed; functional panels should usually scale through anchors or parent layout.

## 9. Safe Area Rules

- Put notch-sensitive UI under a safe-area root.
- Do not solve safe-area issues by adding random per-widget offsets.
- Keep the safe-area root responsible for the screen inset, then place children normally inside it.

## 10. Anti-Patterns

Avoid these unless the design explicitly requires them:

- Full-screen child placement by raw `anchoredPosition` copied from the mockup
- `Constant Pixel Size` for a responsive game HUD
- Deep nesting of empty `RectTransform` wrappers with no layout responsibility
- Manual width and height on every sibling where a layout group should own spacing
- Repeated per-element offsets that are really just container padding

## 11. Verification Loop

After each UGUI slice:

1. Confirm `CanvasScaler` values
2. Confirm the parent container anchors
3. Confirm the child anchors and pivot
4. Confirm whether a layout component owns placement
5. Capture a screenshot at the target resolution
6. Capture one more at a second aspect ratio
7. Refactor if any widget drifts due to raw pixel assumptions
