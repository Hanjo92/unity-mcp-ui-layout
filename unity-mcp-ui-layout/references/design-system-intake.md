# Design System Intake

Use this guide when the user provides a `DESIGN.md`, `design_tokens.json`, Tailwind theme, style guide, or similar design-system source with a Unity UI task.

Pair it with `design-token-to-unity.md` when you need to map tokens into UGUI, TextMeshPro, UI Toolkit, or USS.
Pair it with `figma-node-tree-to-ugui.md` when the task also includes a Figma node or component-tree export that should drive hierarchy conversion.

## Goal

Use the design-system source as the styling contract while keeping this skill's layout-first workflow intact.

- Tokens provide exact values.
- Prose explains intent, hierarchy, and judgment calls.
- Mockups show composition, not permission to ignore tokens.
- Figma node trees, when present, own hierarchy decisions more directly than this guide does.

## Intake Order

1. Identify the source type: `DESIGN.md`, token JSON, Tailwind theme, Figma-exported values, or prose-only style guide.
2. Decide whether a separate Figma node or component-tree export also exists.
3. If a Figma node tree exists, route hierarchy conversion to `figma-node-tree-to-ugui.md` first and keep this guide focused on style contract intake.
4. Extract color, typography, spacing, rounded, component, and state values.
5. Read prose sections for brand style, color usage, layout philosophy, elevation, shapes, components, and do/don't rules.
6. Decide whether the task is build mode or repair mode before changing style.
7. Map the design source into Unity using `design-token-to-unity.md`.
8. Verify the result with screenshots and a style preservation pass.

## When Figma Node Exports Also Exist

If the task includes both a style source and a Figma hierarchy source:

- use the Figma node tree to decide parent ownership, repeated units, scroll ownership, and overlay separation
- use tokens and prose to decide colors, typography, spacing rhythm, shape language, and state visuals
- do not let token values replace missing layout ownership decisions
- do not let a noisy export force one-node-per-widget recreation when the style source makes repeated intent clearer

## DESIGN.md Specific Rules

For `DESIGN.md` files:

- Read YAML front matter first.
- Then read Markdown sections for intent.
- If both are present, treat tokens as normative for concrete values.
- Use prose to resolve ambiguity such as when to use an accent color, how dense the layout should feel, or whether depth comes from shadows, tonal layers, glass, or borders.
- Preserve unknown sections as useful context instead of treating them as errors.

Common sections to scan:

- `Overview` or `Brand & Style`
- `Colors`
- `Typography`
- `Layout` or `Layout & Spacing`
- `Elevation & Depth`
- `Shapes`
- `Components`
- `Do's and Don'ts`

## Optional CLI Preflight

If the `@google/design.md` CLI is available, run the relevant check before implementation:

```bash
npx @google/design.md lint DESIGN.md
npx @google/design.md diff DESIGN-before.md DESIGN-after.md
npx @google/design.md export --format dtcg DESIGN.md
```

Use the linter output to catch broken references, missing core tokens, contrast problems, section-order issues, and orphaned tokens.

If the CLI is unavailable, continue manually:

- parse the front matter or token file directly
- note unresolved token references
- check obvious text/background contrast pairs by inspection or project tooling
- keep any low-confidence mapping explicit

Missing CLI support is not a blocker for layout work.

## Conflict Rules

When sources disagree:

- Explicit user instruction overrides a design source for the current task.
- A provided design source overrides ad hoc visual guesses.
- Tokens override prose for exact values such as colors, font sizes, spacing, and radii.
- Prose overrides the mockup when the mockup appears to be only illustrative.
- A complete Figma node tree overrides the mockup for hierarchy.
- Existing project UI conventions matter in repair mode; do not restyle unrelated regions just because a token file exists.

## Build Mode

When building a new screen:

- Create a small style inventory before implementation: color roles, text roles, spacing scale, corner scale, and component states.
- Reuse existing project fonts, TMP styles, USS classes, sprites, or prefabs when they already represent the design source.
- Create new local styles only when the design role is missing.
- Keep layout regions, anchors, safe area, scroll ownership, and repeated-item reuse as the primary structure.

## Repair Mode

When repairing an existing screen:

- Compare the current UI against the design source before changing visuals.
- Fix layout drift without introducing new random colors, fonts, radii, or one-off spacing.
- If the screen already uses shared styles that match the design source, preserve them.
- If a shared style appears wrong for the whole product, check another known usage before editing it.
- If the requested change is local, use a local override, wrapper, or variant instead of rewriting the shared style system.

## Completion Questions

Before calling the work done, ask:

- Did every visible color, text role, corner radius, and repeated component style trace back to the design source or an existing project equivalent?
- If a Figma node tree also existed, did tokens/style guide the visuals without corrupting the structural ownership chosen from the export?
- Did prose intent affect hierarchy, density, depth, and interaction feedback?
- Were text/background pairs readable where both values were known?
- Did repair work avoid broad style drift outside the requested scope?
- Were deviations from the design source named instead of hidden?
