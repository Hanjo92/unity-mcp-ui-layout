# Design Token to Unity Mapping

Use this guide after `design-system-intake.md` when a Unity UI task includes concrete design tokens.

The goal is to map design-system values into Unity-owned style assets or classes without weakening layout stability.

## Mapping Summary

| Token group | UGUI / TMP target | UI Toolkit target |
|---|---|---|
| `colors` | `Color`, `Image.color`, TMP color, material or style asset | USS custom properties, classes, `color`, `background-color`, border colors |
| `typography` | TMP font asset, TMP style, font size, weight approximation, line spacing | USS font family, size, weight, line height, letter spacing |
| `spacing` | LayoutGroup padding/spacing, RectTransform offsets, safe-area margins | USS padding, margin, gap, width constraints |
| `rounded` | sliced sprites, panel/button art, mask shape, project shape prefab | `border-radius` where supported |
| `components` | prefab variants, style presets, Selectable states | UXML templates, USS classes, pseudo/state classes |

## Color Tokens

Map semantic roles before applying colors:

- `primary`: main action, dominant highlight, selected state
- `secondary`: secondary action or supporting interactive color
- `tertiary`: accent, badge, special state, or domain highlight
- `surface`, `background`, `neutral`: containers and page foundation
- `on-*`: text or icon color placed on the matching background
- `error`: destructive, invalid, or warning states

For UGUI:

- Prefer existing project color style assets when they match.
- Apply colors through reusable prefabs, TMP styles, or screen-level style helpers instead of scattered one-off overrides.
- Keep static sprite artwork intact when the color is baked into a project asset and the task is only layout repair.

For UI Toolkit:

- Prefer USS classes or custom properties over inline style writes.
- Keep repeated component colors in one class family.

Check text/background contrast when component tokens define both `backgroundColor` and `textColor`.

## Typography Tokens

Map typography by role, not by individual label.

Common role mapping:

- display or headline -> screen title, hero value, large HUD number
- title -> panel title, dialog title, section header
- body -> descriptions, popup copy, settings explanations
- label -> buttons, tabs, badges, metadata
- caption -> helper text, small counters, secondary metadata

For UGUI / TextMeshPro:

- Reuse existing TMP font assets and styles first.
- Create or select a small number of text roles instead of giving every label unique settings.
- Map `fontSize`, `fontWeight`, `lineHeight`, and `letterSpacing` where the project stack supports them.
- Treat unsupported font features or weights as intent to approximate, not as license for random local typography.

For UI Toolkit:

- Put typography roles in USS classes.
- Keep wrapping, truncation, and overflow explicit for important text roles.

## Spacing Tokens

Use spacing tokens as rhythm, not as raw pixel copying.

- Map base units to LayoutGroup spacing, padding, margins, and region gaps.
- Use spacing tokens inside stable parent containers after anchor or flex ownership is correct.
- Do not use token values as many leaf-level offsets to compensate for broken parent structure.
- Keep safe-area padding separate from decorative spacing unless the design source says otherwise.

## Rounded Tokens

For UGUI:

- Prefer existing sliced sprites or panel prefabs that already express the shape language.
- If rounded corners are baked into sprites, avoid replacing assets during a layout-only repair.
- Use variants or wrappers when one screen needs a different radius from the shared base.

For UI Toolkit:

- Map directly to `border-radius` where available.
- Keep radius classes consistent across buttons, cards, inputs, badges, and modals.

## Component Tokens and States

Treat component tokens as reusable style roles.

Examples:

- `button-primary` -> primary button prefab variant or USS class
- `button-primary-hover` -> hover/selected/pressed visual state
- `input-field` -> input prefab, TMP input style, or USS input class
- `card-profile` -> reusable card prefab or UXML template class
- `badge-status` -> small reusable badge style

For UGUI:

- Use `Selectable` color transitions, sprite swaps, animation triggers, or prefab variants for states.
- Keep layout ownership in the parent; keep component styling inside the reusable unit.
- Avoid copying the same button or card values into many children manually.

For UI Toolkit:

- Use USS class families for base and state styles.
- Use pseudo-classes or state classes where the project supports them.
- Keep UXML structure separate from style token values when practical.

## Elevation and Depth

DESIGN.md prose often describes depth more clearly than tokens do.

Map intent conservatively:

- tonal layers -> surface colors and container hierarchy
- shadows -> project shadow component, material, or subtle sprite treatment
- glass -> translucent surface, blur-like project effect if available, edge stroke, and clear contrast checks
- flat design -> borders, spacing, and color contrast instead of invented shadows

Do not add expensive runtime effects just because web prose mentions blur or glass. Use the closest project-supported visual language unless the user asks for a new effect.

## Repair Safety

In repair mode:

- Preserve current style assets that already match the design source.
- Do not replace a shared font, material, sprite, or prefab base for one local mismatch without checking another usage.
- Keep emergency text or spacing fixes local unless the token role itself is wrong everywhere.
- Name any intentional deviation from the design source.

## Review Questions

Ask:

- Are token values mapped through reusable style roles rather than scattered overrides?
- Did typography preserve roles and text behavior?
- Did component states survive, not just the default visual state?
- Did layout still use anchors, containers, flex, and safe-area rules instead of token-sized pixel nudges?
- Does the final screenshot preserve both the design source and the requested composition?
