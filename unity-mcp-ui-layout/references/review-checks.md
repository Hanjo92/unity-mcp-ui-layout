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
- Are the major top-level regions grouped by anchor ownership before leaf-level adjustments?

Look for subtle drift, especially in HUD clusters and popup headers or footers.

## 3. Scaling Check

Ask:

- Does the UI still look correct at the target resolution?
- Does it remain acceptable at one alternate aspect ratio?
- Are size changes caused by `CanvasScaler`, anchors, or container logic behaving as expected?
- If a mockup image was provided, did we use the mockup's native resolution or the explicitly stated target resolution deliberately instead of falling back to an arbitrary default?
- If this is mobile-first work, did we verify a taller phone profile and a wider mobile or tablet profile where appropriate?

If only one resolution works, the implementation is not done yet.

## 4. Ownership Check

Ask:

- Does each region have a clear parent that owns layout?
- Does each repeated group have a clear layout owner?
- Were repeated structures turned into reusable prefabs or reusable layout blocks where appropriate?
- Are child offsets being used only for local adjustments rather than structural compensation?
- If this is UI Toolkit, do containers own flex direction, width, overflow, and scroll behavior instead of leaf overrides?

If many children carry unique offsets, the structure is probably still too fragile.

## 5. Asset Granularity Check

Ask:

- Did we keep likely single-image regions as single image resources?
- Was any decorative area split into fake widgets without a runtime need?
- Do separate elements exist only where interaction, animation, text, or adaptive layout requires them?
- Were repeated mockup regions promoted into reusable blocks where appropriate instead of being manually rebuilt?
- If asset-aware mode was active, did we follow a sensible discovery order instead of jumping straight to placeholders?

If the UI was decomposed more than the runtime behavior needs, simplify it before shipping.

## 6. Asset Type Check

Ask:

- Are ordinary static UI visuals using `Image` and sprite-backed assets instead of `RawImage`?
- If a `RawImage` exists, is there a clear runtime texture source such as `RenderTexture`, video, or generated texture data?
- Did any static icon, panel, slot, or button art bypass the sprite workflow without a good reason?

If the answer is no, convert the asset usage back toward the normal sprite workflow before calling the UI done.

## 7. Asset Naming and Placement Check

Ask:

- Were newly created or promoted assets given names that reveal role clearly?
- Are shared assets stored in shared UI folders and screen-owned assets stored near the screen that owns them?
- Are placeholder assets still visibly marked as provisional instead of looking like stable shared assets?
- Would another agent be able to rediscover the asset family without guessing?

If the answer is no, rename or relocate the assets before calling the UI done.

## 8. Text Check

Ask:

- Is any text clipped, wrapping incorrectly, or causing row expansion?
- Are button labels visually balanced?
- Would the current layout likely survive slightly longer strings?
- Was line behavior chosen deliberately for major text roles instead of left to defaults?
- Are counters, currencies, and dynamic values given enough room for realistic growth?
- Did we solve the text issue by fixing layout first instead of immediately shrinking fonts?
- If this is UI Toolkit, are wrap and overflow behaviors explicit for important text regions instead of being left implicit?

Text problems should be treated as layout problems first, not only font-size problems.

## 9. Interaction Area Check

Ask:

- Are buttons, tabs, and actionable rows placed where users expect them?
- Are close buttons and footer actions clearly reachable?
- Do overlays and dimmers cover the correct area?

This check is especially important for popup and mobile layouts.

## 10. Safe Area Check

Ask:

- Are top and bottom edge controls inside the safe area?
- Is safe-area ownership applied only once at the correct container?
- For popups, is safe area owned by `PopupRoot` rather than the dimmer or individual children?
- If the mockup was notch-agnostic, did we reinterpret edge spacing inside the safe area instead of copying raw top and bottom pixels?
- Did the safe area still behave correctly on the taller-phone verification profile?

If safe area works only because several children have manual offsets, the design still needs cleanup.

## 11. Visual Consistency Check

Ask:

- Are gaps and padding visually even?
- Are panel sizes, border spacing, and section rhythms consistent?
- Does the layout feel deliberate instead of patched together?

This is where hand-placed designs usually reveal themselves.

## 12. Scope Check

Ask:

- Did the task stay inside the requested region?
- Were unrelated screens or widgets changed unnecessarily?
- Was the original style preserved when the request was a repair?
- Did we stay in the correct operating mode: bounded repair for fixes, or build mode for true greenfield work?
- If an existing shared asset was edited directly, was that scope truly justified?
- If a shared asset was edited directly, was at least one additional known usage checked first where practical?

If the answer is no, narrow the change before shipping it.

## 13. Final Go/No-Go Rule

Do not call the UI complete unless:

1. the composition is correct
2. the layout survives at least one alternate aspect ratio
3. no obvious clipping or overlap remains
4. safe area ownership is correct where relevant
5. the structure does not depend on arbitrary pixel corrections
