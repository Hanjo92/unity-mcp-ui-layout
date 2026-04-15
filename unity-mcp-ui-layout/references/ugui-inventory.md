# UGUI Inventory Rules

Use this guide for inventories, equipment windows, shops, crafting panels, and slot-based UI.

## Structure Rules

- Build the root as `Canvas -> ModalRoot -> InventoryPanel`.
- Split the main panel into structural regions before styling:
  - category/navigation region
  - item list or grid region
  - detail or preview region
  - bottom action row if needed
- Keep repeated slots under a dedicated content container.
- If the list or grid can exceed the visible area, structure it as `ScrollRect -> Viewport -> Content -> repeated slot/item`.
- Keep tabs, filters, headers, and bottom actions outside the scrolling content unless the design explicitly wants them to scroll too.

## Anchor Rules

- InventoryPanel: center anchor, center pivot
- Left navigation region: left stretch anchor inside the panel
- Item grid/list region: stretch anchor inside its parent region
- Detail panel: right stretch anchor inside the panel
- Bottom actions: bottom stretch anchor inside the panel

## Layout Rules

- Use `GridLayoutGroup` or `VerticalLayoutGroup` for repeated slots and rows.
- Use `LayoutElement` for special slot sizing instead of manual offsets on each slot.
- Prefer scroll views for long content instead of vertically stacking many absolute-positioned items.
- Let `Viewport` own clipping and let `Content` own repeated placement.
- Treat the slot or row unit as the reusable prefab or reusable block, not the whole scroll shell.

## Sizing Rules

- Let the parent panel own the overall footprint.
- Let the grid or list own repeated slot placement.
- Use fixed slot sizes only when the design explicitly requires uniform cells.

## Verification Rules

- Confirm that item rows and slot gaps stay uniform.
- Confirm that the detail panel does not overlap the list at narrower widths.
- Confirm text labels do not break the row unexpectedly.
- Confirm only the intended content area scrolls and that headers, filters, and footer actions stay fixed when they should.
- Confirm repeated rows or slots are instantiated as reusable units instead of hand-placed children.

## Avoid

- Manually placing dozens of slots
- Treating the entire scroll view shell as the repeated reusable unit
- Mixing `ContentSizeFitter` and `GridLayoutGroup` without clear ownership
- Treating the whole inventory as one flat group with no structural regions
