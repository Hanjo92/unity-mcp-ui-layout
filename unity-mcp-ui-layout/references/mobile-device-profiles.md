# Mobile Device Profiles

Use this guide when a UI is mobile-first and should not be considered stable after only one portrait screenshot.

The goal is to make verification intentional instead of vague.

## 1. Minimum Verification Set

For most mobile-first UI, verify at least:

1. the main target device ratio
2. one taller phone ratio
3. one wider mobile or tablet ratio when the product is expected to support it

Do not assume one portrait screenshot is enough.

## 2. Suggested Verification Profiles

Use profiles like these when the exact device list is not specified:

### Tall Phone

- narrow width
- tall portrait height
- useful for notch pressure, top bars, bottom CTA spacing, and stacked content

### Standard Phone

- the default main target used by the project
- useful as the baseline comparison

### Wide Mobile or Small Tablet

- wider landscape-oriented layout pressure
- useful for side spacing, modal balance, HUD edge ownership, and stretched panels

If the project is tablet-capable, explicitly include one tablet-like verification pass.

## 3. What Each Profile Is Good At

### Tall Phone Checks

- notch and top safe-area pressure
- bottom home-indicator pressure
- overly tall content stacks
- portrait spacing drift

### Wider Mobile Checks

- side spacing inflation
- center modal over-width
- HUD corner ownership drift
- stretched empty regions

### Tablet Checks

- oversized content containers
- weak center grouping
- side-panel balance
- text blocks that become too wide and visually loose

## 4. Portrait-Only Assumptions

Portrait-only assumptions are acceptable only when at least one of these is true:

- the product is explicitly portrait-only
- the task is clearly scoped to a portrait-only screen
- the user explicitly says landscape is irrelevant

If those conditions are absent, do not silently skip landscape or wider-width verification.

## 5. Practical Verification Flow

For mobile-first work:

1. verify the intended main target first
2. verify one taller phone profile
3. verify one wider mobile or tablet profile when the product may support it
4. compare what changed in anchors, spacing, clipping, and safe-area behavior

## 6. Anti-Patterns

Avoid these:

- checking only one portrait resolution
- assuming portrait-only without evidence
- calling a popup stable after checking only its center alignment
- ignoring tablet or wider mobile behavior when the product does not forbid it

## 7. Review Questions

Ask:

- Did we verify a taller phone profile?
- Did we verify a wider mobile or tablet profile when appropriate?
- Are we assuming portrait-only because the product demands it, or just because it was easier?
- Did the safe area still behave correctly across those verification profiles?

If the answer is no, the mobile verification pass is probably incomplete.
