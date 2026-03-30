# Text Layout Rules

Use this guide when text is likely to drive layout quality: buttons, headers, tabs, inventory rows, settings labels, popup bodies, counters, and localized UI.

The main rule is simple:

- treat text as a layout driver
- do not treat text overflow as a last-minute font-size problem

## 1. Decide the Text Role First

Before changing sizes, decide what the text is supposed to be.

Typical roles:

- title
- section header
- body copy
- button label
- tab label
- value or counter
- item name
- description text

Each role should have a different tolerance for wrapping, truncation, scaling, and container growth.

## 2. Choose Line Behavior Explicitly

Do not leave line behavior to defaults.

For each important text region, decide one of these first:

- single line only
- wrap to multiple lines
- truncate or ellipsis
- expand parent row or container

Examples:

- popup title: usually single line or controlled two-line cap
- body description: usually wraps
- tab label: usually single line and width-constrained
- number display: usually single line with stable alignment
- inventory item name: often one or two lines depending on design

## 3. Size the Container Before Shrinking the Text

When text breaks layout:

1. inspect the parent width rule
2. inspect padding and spacing
3. inspect whether sibling layout is stable
4. only then consider font size changes

Auto-size can hide a structural problem for one resolution and reintroduce it later.

## 4. Prefer Reusable Text Styles

If asset-aware mode is active:

- reuse existing TMP styles or text presentation rules before inventing new ones
- keep title, body, caption, and number systems consistent across screens

Even in layout-only mode:

- do not create random one-off text settings for every widget
- prefer a small number of repeatable text patterns

## 5. Rules for Button and Tab Labels

Buttons and tabs often fail because text is treated as decorative instead of structural.

- Give labels a stable container width rule.
- Do not rely on extreme auto-size ranges to force every string into one tiny button.
- If labels vary, let the button family define a minimum width and an acceptable expansion strategy.
- Keep visual balance across sibling buttons.

If one button becomes much wider than its siblings, check whether the layout should wrap, align, or split actions differently.

## 6. Rules for Numeric Text

Counters, currency, timers, and stat values need stable rhythm.

- Prefer fixed alignment rules.
- Anticipate digit growth.
- Keep enough width for realistic value changes.
- Do not place number text in containers sized only for the mockup's smallest visible value.

If the value can grow at runtime, the container must acknowledge that.

## 7. Localized and Long-String Safety

A layout that works only for one short string is not stable.

Before calling text layout done, ask:

- would this still work with a slightly longer string?
- would another language likely overflow?
- is the current success dependent on unusually short English text?

You do not need full localization coverage for every task, but you should leave reasonable headroom where the role obviously needs it.

## 8. UGUI Guidance

For UGUI:

- inspect `TextMeshProUGUI` overflow and wrapping rules deliberately
- avoid mixing parent-driven layout with desperate font auto-size as the primary fix
- use layout groups and preferred widths thoughtfully for text-heavy rows
- keep text padding in the parent when possible instead of many child offsets

## 9. UI Toolkit Guidance

For UI Toolkit:

- prefer reusable USS classes for text roles
- keep width, flex behavior, and overflow rules predictable
- avoid scattered inline overrides for text sizing unless the case is truly local

## 10. Anti-Patterns

Avoid these:

- shrinking text first without checking container ownership
- using huge auto-size ranges as the default solution
- letting every label choose its own random font settings
- designing buttons around one short string only
- trusting mockup text length as a hard runtime truth
- ignoring number growth in counters and currencies

## 11. Review Questions

Ask:

- Did we decide line behavior explicitly for important text regions?
- Are text containers sized by role rather than by the shortest visible sample?
- Would slightly longer labels still fit acceptably?
- Are reusable text styles being preserved where the project already has them?
- Did we solve layout with structure first and font shrinking second?

If the answer is no, the UI is probably still fragile.
