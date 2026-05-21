# Figma Node Tree to UGUI Example

Use this example when the input is a structured Figma export and you want a deterministic import into UGUI.

## Scenario

- The user provides:
  - exported Figma JSON / node tree
  - optional component definitions
  - optional variable/style references
  - optional screenshot for visual verification
- Direct Figma API calls are not required and not allowed for this task.

## Copyable Prompt

```text
Use $unity-mcp-ui-layout to build this screen as UGUI from the attached Figma export only.
Do not use Figma API calls.

1) Parse the input first and produce a short intake map:
   - root frame and all top-level regions,
   - which nodes are FRAME, GROUP, COMPONENT, INSTANCE,
   - which nodes use AUTO-LAYOUT,
   - which nodes are absolute-child style,
   - which text/image roles appear repeatedly.

2) Build the hierarchy in this order:
   - stable root containers (by region ownership),
   - frame/group containers and layout owners,
   - prefab candidates from COMPONENT nodes,
   - INSTANCE placements as prefab instances,
   - leaf text and image nodes as TMP/Image roles.
   Choose anchors and pivots from each node's parent relationship, constraints, growth, and motion intent. Do not default every RectTransform pivot to top-left just because Figma coordinates are measured from a top-left origin.

3) Convert AUTO-LAYOUT frames:
   - HORIZONTAL -> HorizontalLayoutGroup,
   - VERTICAL -> VerticalLayoutGroup,
   - WRAP or grid-like repeated content -> GridLayoutGroup or owned row/column layout groups,
   - preserve spacing/padding/alignment intent,
   - use LayoutElement for intentional per-child size differences,
   - avoid per-child anchoredPosition when a parent layout group can own spacing and alignment,
   - keep mixed ABSOLUTE children in an overlay container when needed.

4) Handle decomposition:
   - collapse obvious noisy wrappers (single-child visual-only groups, empty wrappers, decorative seams) but keep semantic ownership containers,
   - keep likely baked decorative regions whole as one image/block unless interaction, animation, dynamic text, or adaptation requires split,
   - convert repeated structures to reusable prefabs or reusable layout blocks first, then instance them under a layout-group-owned parent when spacing is regular.

5) Text/image role pass:
   - assign TMP roles (title/body/label/caption) with explicit overflow/word-wrap choices,
   - map static art to Image with sprite workflow unless runtime texture behavior is required,
   - do not use RawImage for static UI unless justified by runtime source.

6) Variable/style co-existence:
   - prefer variable-backed shared values when present,
   - fall back to explicit styles for local exceptions,
   - flag unresolved variables and style conflicts as follow-up questions.

7) Before completion, run a concise self-check:
   - Are repeated blocks instances instead of manual duplicates?
   - Are parent containers structurally stable and not replaced by pixel nudges?
   - Are auto-layout and regular repeated siblings owned by LayoutGroup components unless an exception is named?
   - Are anchors and pivots role-driven instead of top-left defaults copied from Figma coordinates?
   - Are unresolved nodes/types documented with fallback decisions?

If critical fields are missing from the export (children, constraints, component IDs, or asset refs), pause and request exactly what is missing before creating final structure.
```

## Why This Works

- It enforces a stable order: structure, then components, then leaves.
- It makes explicit decisions for auto-layout vs absolute children, which avoids fragile offset-only hierarchies.
- It treats components as reusable contracts and instances as data changes, reducing rebuild work.
- It ties variables and styles to deterministic precedence rules, making repeated decisions repeatable.
- It avoids over-decomposition by preserving likely single-image regions unless runtime ownership is clear.

## Suggested References

- [figma-node-tree-to-ugui.md](../unity-mcp-ui-layout/references/figma-node-tree-to-ugui.md)
- [mockup-decomposition.md](../unity-mcp-ui-layout/references/mockup-decomposition.md)
- [prefab-reuse.md](../unity-mcp-ui-layout/references/prefab-reuse.md)
- [design-system-intake.md](../unity-mcp-ui-layout/references/design-system-intake.md)
- [layout-checklist.md](../unity-mcp-ui-layout/references/layout-checklist.md)
- [prompt-patterns.md](../unity-mcp-ui-layout/references/prompt-patterns.md)
