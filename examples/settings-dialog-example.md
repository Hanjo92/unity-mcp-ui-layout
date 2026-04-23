# Settings Dialog Example

Use this example when the target is a settings, preferences, options, pause-menu settings, or configuration dialog with grouped controls such as toggles, dropdowns, sliders, segmented choices, and apply/cancel actions.

## Scenario

The user wants a settings dialog that stays readable as labels grow, keeps dense controls aligned, and does not let the footer actions drift or scroll accidentally. The goal is to define the dialog shell, section groups, control rows, and verification behavior before polishing individual widgets.

## Example Prompt

```text
Use $unity-mcp-ui-layout to build or repair this settings dialog.
Identify the active UI stack first and do not mix UGUI and UI Toolkit in the same change unless I explicitly ask for a bridge.
If this is UGUI, structure it as `Canvas -> ModalLayer`, with `Dimmer` and `PopupRoot` as siblings, and keep title, scrollable settings body, and footer actions inside `PopupRoot`.
If this is UI Toolkit, inspect the active UIDocument, UXML, USS, and visual tree first, then keep layout ownership in containers and repeatable styling in USS classes.

Group the dialog into title/header, settings body, and footer action regions before tuning individual controls.
Inside the settings body, group controls by section and make one reusable row pattern for label + control + optional description or value text.
Keep the settings body as the only scroll owner when the content is long; title, close button, and apply/cancel actions should stay outside the scrolling content.
For toggles, dropdowns, sliders, and segmented choices, align labels and controls through parent row rules instead of per-widget offsets.
Decide whether each important label should wrap, truncate, or reserve fixed width before changing font sizes.
Verify the dialog at the main target size and one narrower or denser text scenario, including longer labels and realistic option values.
If this is mobile settings UI, also verify portrait and landscape when safe-area pressure matters.
```

## Why This Works

- It makes the stack decision explicit before layout work starts.
- It treats a settings dialog as a shell plus repeated control rows, not as many unrelated widgets.
- It keeps footer actions fixed while only the settings body scrolls.
- It pushes label, value, and control alignment into parent row rules.
- It verifies long labels and dense controls before visual polish.

## Decision Checklist

- Is the UI stack clear: UGUI or UI Toolkit?
- Does the dialog have distinct header, body, and footer ownership?
- Is there exactly one intended scroll owner for long settings content?
- Are repeated control rows reusable instead of hand-positioned one by one?
- Are labels and values given explicit wrap, truncate, or width rules?
- Do apply/cancel actions remain reachable when the settings body scrolls?
- Was the dialog checked with longer labels or realistic option values?
- If this is mobile settings UI, was portrait and landscape behavior checked where safe-area pressure matters?

## Suggested References

- [ugui-popup.md](../unity-mcp-ui-layout/references/ugui-popup.md)
- [ugui-anchors-canvas-scaler.md](../unity-mcp-ui-layout/references/ugui-anchors-canvas-scaler.md)
- [ui-toolkit-layout-rules.md](../unity-mcp-ui-layout/references/ui-toolkit-layout-rules.md)
- [text-layout-rules.md](../unity-mcp-ui-layout/references/text-layout-rules.md)
- [layout-checklist.md](../unity-mcp-ui-layout/references/layout-checklist.md)
- [scroll-view-patterns.md](../unity-mcp-ui-layout/references/scroll-view-patterns.md)
