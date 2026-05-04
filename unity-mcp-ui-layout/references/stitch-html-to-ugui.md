# Stitch HTML to UGUI Guide

Use this guide when the user provides Google Stitch export artifacts (HTML/CSS or similar front-end exports) and asks for a stable Unity UGUI hierarchy.

## Goal

Convert exported structure into runtime-holdable UGUI containers first, then style and populate details second.

- keep layout ownership in parent containers
- keep repeated structures reusable
- preserve visual intent while replacing web positioning with anchor-based hierarchy

## When To Use

- an HTML/CSS export is attached instead of only a raster screenshot
- export includes clearly repeated cards/rows/items that look like reusable units
- the source has flex, absolute offsets, and/or overflow behavior that should be interpreted for Unity
- you are not making direct API integration calls and should not depend on runtime data fetching inside this task

## Intake Rules (Structured Export Input)

1. Confirm the target stack is UGUI and the target platform profile (desktop only, mobile portrait, mobile landscape, or both).
2. Confirm measurement space:
   - preferred `referenceWidth x referenceHeight` (from exported CSS viewport or `meta viewport` context)
   - if missing, choose one explicit basis and keep it visible in the request
3. Identify available artifacts:
   - exported `HTML`
   - exported `CSS` (or inline styles + class names)
   - asset files for images/icons/backgrounds
   - optional screenshot of the expected final result
4. Build a clean semantic tree before coordinates:
   - map structural blocks (`body`, `header`, `nav`, `main`, `section`, `footer`, repeated lists)
   - isolate decorative wrappers from interactive or dynamic ones
5. Normalize repeated units by signature:
   - same tag/class structure repeated more than once should be tagged as one reusable block
6. Capture edge handling constraints:
   - any `overflow`, `position: sticky/fixed/absolute`, `z-index`, and stacking hints
7. Resolve unknown constraints as assumptions and state them explicitly in handoff.

If required files are missing, request missing inputs instead of guessing hierarchy from partial CSS.

## Mapping DOM-Like Hierarchy to UGUI Containers

Use this ownership-first mapping:

- root document (`html`/`body`) → `Canvas`-anchored root and safe-area-aware screen containers
- page sections (`header`, `main`, `section`, `article`, `footer`) → anchor-owned structural `RectTransform` containers
- group wrappers (`div`, `ul`, `ol`, `li`, `nav`) → semantic containers; prefer dedicated grouping nodes over flattening
- repeated list item definitions (`ul > li`, cards, chips, menu rows) → reusable block under a single content owner
- control-like leafs (`button`, `a`, `input`) → `Button` or clickable wrapper + child label/icon
- decorative leaves (`img`, static icon, background vector regions) → `Image` with sprite/raw image role
- text nodes (`p`, `h1`~`h6`, `span`, labels) → `TextMeshProUGUI` roles

Do not copy raw pixel values one-to-one onto all leaves.  
Keep container-level rules and only convert important offsets when no structural parent exists.

### Recommended Structural Pattern

```text
Canvas
└─ SafeAreaRoot (mobile only, when needed)
   └─ ScreenRoot
      ├─ HeaderContainer
      ├─ ContentContainer
      │  ├─ RowOrColumnContainer (flex owner or content owner)
      │  └─ ReusableItemContainer
      └─ FooterContainer
```

## Handling Flex From Export

- `display:flex` should be interpreted as a container layout owner, not a leaf style.
- Map direction:
  - `flex-direction: row` → `HorizontalLayoutGroup` (or explicit anchored children if irregular)
  - `flex-direction: column` → `VerticalLayoutGroup`
- Map grow/shrink intent:
  - `flex-grow` and `flex-basis` become explicit container weight/size rules first, then per-child `LayoutElement`
- Map justification/alignment:
  - `justify-content` / `align-items` become child alignment and padding/spacing rules on the container
  - for `space-between` and similar distributions, consider `HorizontalLayoutGroup` + spacing, not per-child absolute offsets
- Map wrapping:
  - `flex-wrap: wrap` often maps to `GridLayoutGroup` or wrapped content strategy under an owned content container
- Avoid putting many sibling `margin`/`gap` overrides on leaves when a parent container owns the same behavior.

## Handling Absolute Positioning

Use absolute positioning only when it is semantically fixed:

- floating overlays
- icon labels anchored to a card edge
- badge/pill markers
- decorative ornaments
- background elements that should not affect sibling flow

For absolute blocks:

1. find the smallest stable parent container first
2. convert coordinates to anchored offsets relative to that container
3. keep each absolute leaf minimal and avoid chains of absolute siblings that hide missing container rules

If many siblings are absolute with equal spacing, that is usually a flattened structure issue.
Convert them into a container with layout rules instead of leaving many static offsets.

## Repeated Blocks

- if node shape, role names, and child ordering repeat:
  - create one reusable UGUI block
  - place instances under one parent container or scroll content owner
- if only text/image values change between repeats:
  - reuse the same block and override content only
- do not create unique prefabs for each visual copy unless behavior diverges.

## Text and Image Roles

Use explicit role mapping before styling:

### Text Roles

- title / section title / hero text: large emphasis label
- body: normal readable paragraph text
- metadata or timestamp: small subdued text
- count/value: fixed-width or expandable data text region
- action label: button text role with strong contrast and alignment
- tooltip/copy line: helper or microcopy role

### Image Roles

- icon: small fixed-size image node, generally local and repeated
- thumbnail: moderate fixed area under repeated item or card
- background: full-area panel/background image, usually one owner panel with a single image
- decorative badge: anchored small image, often absolute-style.

For each text region, define one behavior early:
- single-line clip/truncate
- wrap
- dynamic growth container

Do not rely on shrinking font size first. Give containers width/height rules first, then tune overflow behavior.

## Scroll Regions

- identify `overflow:auto`, `overflow-y:auto`, or explicit long content areas in the export
- ensure one clear scroll owner:
  - `ScrollRect` shell
  - child `Viewport` for clipping
  - `Content` for layout and spacing
- repeated scroll items go under `Content` using one reusable item block
- keep fixed chrome (tabs, filters, sticky action bars) outside the scrolling content unless the design explicitly says otherwise

## Safe Area Notes

Only apply when target includes mobile displays that need cutout handling:

- set one safe-area owner (usually `SafeAreaRoot`) and avoid applying safe-area offsets to many descendants
- map export edge distances into safe-area space:
  - do not copy raw top/bottom/left/right values from web export directly to final leaf nodes
- if an element is intentionally full-bleed (e.g., background art), place it behind the safe-area owner and keep interactive controls in safe-space

## Non-Goals and Fallback Rules

- No direct API access, data binding, or runtime fetch logic is in scope.
- No behavioral JavaScript reconstruction from export.
- If CSS uses advanced selectors, pseudo-elements, or browser-only features with no stable container equivalent, use best-effort approximations and mark assumptions.
- If the export has no semantic anchors for a complex page, stop and request:
  - intended role labels for repeated blocks
  - safe area target profile
  - preferred interaction intent for control-like nodes
- if CSS claims unsupported layout features, prioritize structural stability and a readable mapping over perfect pixel mimicry.

## Review Questions

- Did we map ownership to structural containers before placing text and images?
- Do repeated blocks use one reusable unit or one content owner, rather than one-off copies?
- Are flex behaviors encoded as container layout rules instead of many leaf-level manual offsets?
- Are all overflow/scroll regions given one `ScrollRect` owner each?
- Did we convert absolute elements only where fixed intent is clear?
- Are text and image roles explicit and stable at runtime?
- Is safe area handled at one correct parent (where needed)?
- Did we flag unsupported CSS or unclear intent instead of silently guessing?

