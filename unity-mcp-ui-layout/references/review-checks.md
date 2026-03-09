# Unity UI Review Checks

Use this guide at the end of a `unity-mcp` UI task before calling the result complete.

This is a final review pass, not a discovery checklist. The goal is to catch issues that often survive basic implementation.

## 1. Composition Check

Ask:

- Does the screen match the intended composition from the mockup or task description?
- Are the major regions in the correct places?
- Is the visual hierarchy obvious at a glance?

If the answer is no, return to parent containers and region structure before changing polish details.

## 2. Alignment Check

Ask:

- Are corner widgets actually attached to the intended corner?
- Are bars aligned cleanly to the top, bottom, left, or right edges?
- Are centered elements truly centered in their intended parent?
- Do sibling groups share common visual baselines?

Look for subtle drift, especially in HUD clusters and popup headers or footers.

## 3. Scaling Check

Ask:

- Does the UI still look correct at the target resolution?
- Does it remain acceptable at one alternate aspect ratio?
- Are size changes caused by `CanvasScaler`, anchors, or container logic behaving as expected?

If only one resolution works, the implementation is not done yet.

## 4. Ownership Check

Ask:

- Does each region have a clear parent that owns layout?
- Does each repeated group have a clear layout owner?
- Are child offsets being used only for local adjustments rather than structural compensation?

If many children carry unique offsets, the structure is probably still too fragile.

## 5. Text Check

Ask:

- Is any text clipped, wrapping incorrectly, or causing row expansion?
- Are button labels visually balanced?
- Would the current layout likely survive slightly longer strings?

Text problems should be treated as layout problems first, not only font-size problems.

## 6. Interaction Area Check

Ask:

- Are buttons, tabs, and actionable rows placed where users expect them?
- Are close buttons and footer actions clearly reachable?
- Do overlays and dimmers cover the correct area?

This check is especially important for popup and mobile layouts.

## 7. Safe Area Check

Ask:

- Are top and bottom edge controls inside the safe area?
- Is safe-area ownership applied only once at the correct container?
- For popups, is safe area owned by `PopupRoot` rather than the dimmer or individual children?

If safe area works only because several children have manual offsets, the design still needs cleanup.

## 8. Visual Consistency Check

Ask:

- Are gaps and padding visually even?
- Are panel sizes, border spacing, and section rhythms consistent?
- Does the layout feel deliberate instead of patched together?

This is where hand-placed designs usually reveal themselves.

## 9. Scope Check

Ask:

- Did the task stay inside the requested region?
- Were unrelated screens or widgets changed unnecessarily?
- Was the original style preserved when the request was a repair?

If the answer is no, narrow the change before shipping it.

## 10. Final Go/No-Go Rule

Do not call the UI complete unless:

1. the composition is correct
2. the layout survives at least one alternate aspect ratio
3. no obvious clipping or overlap remains
4. safe area ownership is correct where relevant
5. the structure does not depend on arbitrary pixel corrections
