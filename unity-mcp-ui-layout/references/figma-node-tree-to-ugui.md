# Figma Node Tree to UGUI Mapping

Use this guide when the input is a structured Figma export (node + component tree) and the target is a stable UGUI hierarchy.

## Goal

Convert exported Figma structure into a Unity hierarchy that is:

- structurally meaningful at runtime (not a visual copy of every seam),
- reuse-friendly through prefabs/instances,
- resilient to spacing and resolution changes, and
- easy to repair later by parent-owned containers.

## When to Use

- The task provides exported Figma JSON/AST-like data (frames, groups, components, instances, constraints, layout mode, styles, variables).
- You need deterministic conversion from model-driven structure instead of guessing from a screenshot alone.
- API access to Figma is not available or not allowed.

Do not use this guide for tasks with only an image mockup and no structured node data.

## Intake Rules

Before creating hierarchy, validate the incoming export:

1. Confirm the root node is a `FRAME`-like container for the intended screen region.
2. Confirm each node has at least one stable identifier (`id`, `name`, or path) and a type.
3. Confirm child order is preserved, and `children` arrays are not truncated.
4. Confirm style/variable context can be referenced:
   - explicit style IDs,
   - variable references,
   - direct style values for color/typography/image settings.
5. Confirm image assets are discoverable by the export contract (asset key, fill image key, or alias name).

Assumptions you should state in execution:

- coordinates are in the same design space for this conversion pass,
- absolute values are advisory; hierarchy and ownership are primary for stable layout,
- repeated nodes imply intentional reuse unless evidence strongly suggests unique art.

If any item above is missing, use the fallback rules at the end and capture required follow-up inputs before proceeding.

## Mapping Rules

### Frame / Group

- `FRAME`
  - root-level frame: create a dedicated UGUI container root for the screen or major region.
  - frame with fill/background: create `RectTransform` + `Image` (sprite if image fill, color otherwise).
  - frame with `layoutMode`: map to `VerticalLayoutGroup` or `HorizontalLayoutGroup` depending on axis.
  - frame without visuals and only structural children: create empty `RectTransform` container.
- `GROUP`
  - use as `RectTransform` container first, never automatic sprite unless it carries direct visual decoration intent.
  - collapse to a flatter container if:
    - no runtime behavior,
    - no styling, and
    - it has one child with identical anchoring intent.
  - keep if it clarifies ownership (e.g. region split, reusable local coordinate scope, script attachment target).

### Component / Instance

- `COMPONENT`
  - treat as **prefab definition source**.
  - map component internals once, then place via instance reuse.
  - keep slots for dynamic text/image content where role is clear.
- `INSTANCE`
  - instantiate the matching component prefab, then apply only instance-level data:
    - changed text values,
    - icon swaps,
    - counters/state variants,
    - local spacing nudges that do not change structure.
  - if component is missing from local registry:
    - create a temporary local base prefab from this instance shape,
    - mark as `to-confirm-component-source` for follow-up, then continue.

### Auto Layout Nodes

- `layoutMode = HORIZONTAL`
  - prefer `HorizontalLayoutGroup`.
  - preserve:
    - `itemSpacing` -> `spacing`,
    - `padding*` -> container padding,
    - align/justify intent -> child/alignment settings (best effort).
- `layoutMode = VERTICAL`
  - prefer `VerticalLayoutGroup` with equivalent spacing and padding.
- `counterAxisSizing` / `primaryAxisSizing` hints:
  - fixed size -> fixed child dimensions (`sizeDelta`/preferred size behavior),
  - auto size -> allow content-driven expansion where stable (`ContentSizeFitter` only when parent owns sizing, avoid deep nesting).
- `layoutWrap = WRAP` exports: prefer manual row/column containers over nested auto-layout if wraps are visible and content is repetitive.

### Absolute Children

- Nodes with explicit absolute position inside a non-layout parent are mapped as direct anchored leaves under that parent.
- If an auto-layout parent contains absolute siblings:
  - split parent into two owned containers:
    - one layout container for regular flow children,
    - one overlay/absolute container for detached children.
- Convert absolute values to:
  - anchor-preserving offsets on the `RectTransform`,
  - local offsets only when parent is a fixed region.
- Do not mix absolute offsets as the primary structure for whole screens.

### Text Nodes

- Map text nodes to `TextMeshProUGUI`.
- Text role assignment:
  - title/headline -> title role,
  - body/description -> body role,
  - metadata/caption/counters -> caption/label role,
  - button/interactive label -> label role.
- Preserve:
  - alignment,
  - max-lines behavior,
  - line break/overflow policy.
- If text appears as a fixed asset label with no runtime updates and no localization requirement, keep one static text node.
- If text is expected to change (values, labels, counters, i18n), keep as dynamic role with clear binding target.

### Image / Vector / Icon Nodes

- Map static visuals to `Image` with Sprite workflow by default.
- Use icon treatment for small repeated symbols with shared import settings.
- Keep decorative image groups intact when splitting would only create fake semantics.
- If a region is truly composite and behaviorless, prefer one image/sprite over many tiny image children.

## Reducing Noisy Node Trees

Collapse or ignore nodes only when they do not carry runtime intent:

- empty wrappers,
- purely presentational one-child wrappers,
- hidden/invisible wrappers with no semantic naming or constraints,
- helper separators and decorative seams with no interaction/state/animation.

Do not collapse:

- named containers that indicate region ownership,
- containers tied to constraints (safe area, margins, orientation),
- components reused across nodes,
- anchors/scroll/content ownership boundaries.

## Repeated Blocks Strategy

Use stable reuse when structure repeats:

- detect repeats by:
  - same `componentId` or
  - matching subtree shape across 2+ nodes.
- normalize a single clean base and create one prefab or reusable layout block.
- place copies as prefab instances; vary by instance properties only.
- if size changes by screen context, create prefab variants for size-class differences rather than rebuilding.

If repeat detection is noisy or ambiguous, run one-pass normalization:

1. identify the visually most stable candidate,
2. build prefab from candidate,
3. replace 2+ manual duplicates,
4. verify one base and one variant.

## Variable + Style Export Coexistence

Treat variable references and explicit style values as a hierarchy:

1. Use variable definitions as primary semantic intent when available.
2. Fill missing variable-backed values from resolved style values.
3. Keep explicit styles where they represent one-off exceptions.
4. Record unresolved variables as TODO comments for follow-up or local constants.

Conflict rule:

- If variable value and explicit value conflict, prefer variable semantics for shared roles.
- For single-purpose local exceptions, keep explicit style and mark it as scoped override.
- If token meaning is unclear, keep behavior safe and ask for a token glossary before finalizing.

## Fallback Rules

- Unknown node type
  - convert to a container and preserve children structure,
  - log the type mismatch in notes for later cleanup.
- Unknown/unsupported constraints
  - map geometry to `RectTransform` with anchored offsets and document assumptions.
- Missing image asset
  - create placeholder object with descriptive name and move forward.
- Too noisy or deep tree
  - perform one flattening pass while preserving parent ownership and repeated blocks.
- Mixed layout intent (partial auto + absolute)
  - separate into layout flow and overlay containers as above.

## Fallback to Review Mode

When a block cannot be reliably mapped, switch to repair mode:

- preserve existing design intent as a single image region,
- keep hierarchy minimal,
- complete core regions first, then refine lower layers once the stable shell is built.

## Review Questions

- Are root containers clearly owning region layout and anchors?
- Are frames and groups used only when they own layout/responsibility?
- Are components mapped to reusable prefabs, with instances driving repeated copies?
- Are auto-layout nodes translated into layout groups instead of manual offsets?
- Are absolute children isolated so they do not destabilize flow layout?
- Did we keep one-source visual regions (image/text role decisions) clean and reusable?
- Are variables and explicit styles harmonized with clear fallback notes?
- Do any repeated structures still exist as manual copies?
- Are unresolved nodes/types documented before finalization?
- Is there any place where we mapped by pixel position because structural ownership was missing?
