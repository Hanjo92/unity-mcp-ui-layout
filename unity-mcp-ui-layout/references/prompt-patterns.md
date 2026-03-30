# Prompt Patterns for Unity MCP UI Work

Use these patterns to keep UI work incremental and verifiable.

## Pattern 1: Start With Discovery

Use when the scene already contains UI.

```text
Inspect the current scene UI before editing anything.
Identify whether this is UGUI or UI Toolkit.
List the root UI objects/files, the scaling setup, and the likely source of the layout issue.
Do not modify assets yet.
```

## Pattern 2: Build the Shell First

Use when creating a new interface from scratch.

```text
Create only the root UI shell for this screen.
Set up the correct canvas or root visual element, scaling rules, and the main top-level regions.
Do not add detailed widgets yet.
After creating the shell, capture a screenshot and summarize what still needs adjustment.
```

## Pattern 3: Add One Region

Use after the shell is stable.

```text
Add only the [header/content/footer/sidebar/modal] region.
Keep layout rules clean and avoid hard-coded positions unless unavoidable.
After the change, capture a screenshot and check for clipping, uneven spacing, or anchor issues.
```

## Pattern 4: Repair a Broken Layout

Use when the current UI exists but looks wrong.

```text
Fix this layout without redesigning unrelated parts.
Inspect the parent chain first and explain whether the issue comes from scaling, anchors/flex rules, text sizing, or conflicting layout controllers.
Apply the smallest structural fix, then verify with a screenshot.
```

## Pattern 4A: Stay In Repair Mode

Use when the screen already exists and the user wants a bounded fix, not a redesign.

```text
Treat this as a repair of the existing UI, not as a new screen build.
Inspect the current parent chain first, keep the scope bounded to the named region, and preserve the current style unless it is the direct source of the problem.
Only widen the change if you can explain why the parent structure or shared asset is the real cause.
```

## Pattern 5: Cross-Resolution Verification

Use before finalizing.

```text
Verify this UI at the main target resolution and at one additional aspect ratio.
Report which elements stretch, clip, drift, or bunch together.
Only make the minimum changes needed to stabilize the layout across both views.
```

## Pattern 6: Image Plus Resolution Layout Build

Use when the user provides a mockup or screenshot and target resolution.

```text
Use the attached layout image as the composition reference and [WIDTHxHEIGHT] as the reference resolution.
Before creating objects, identify the major UI regions, group the top-level composition by anchor ownership, and estimate each region's normalized position and size.
Create the parent containers and anchors first.
If the same structure repeats, make one reusable prefab or reusable layout block before placing all copies.
If a region looks like a single image resource, keep it as one image unless runtime behavior requires it to be split.
Do not translate the image into raw pixel coordinates unless a fixed-size element truly requires it.
After implementation, capture a screenshot and compare it against the reference image.
Use `manage_camera` for the screenshot capture.
```

If no explicit target resolution is provided, use the mockup image's native resolution as the reference resolution instead of falling back immediately to `1920x1080`.

## Pattern 7: Image-Based Layout Repair

Use when the current UI should match an image more closely.

```text
Compare the current UI against the provided layout image at [WIDTHxHEIGHT].
Find where the composition diverges.
Fix parent containers, top-level anchor grouping, and scaling rules before adjusting local offsets.
Convert repeated structures into reusable prefabs or reusable layout blocks when the same shape appears multiple times.
Collapse over-modeled decorative regions back into a single image when they are likely one baked asset.
Keep the repair proportional to the reference image, not tied to arbitrary screen pixels.
Use `manage_camera` to verify the repaired result against the image.
```

## Pattern 17: Use Mockup Native Resolution First

Use when the user provides a design image but does not explicitly name a target resolution.

```text
Inspect the mockup image and capture its native pixel resolution first.
Use that mockup resolution as the planning reference frame instead of defaulting to 1920x1080.
Estimate geometry as normalized ratios from the mockup, then convert those ratios into anchors and offsets for implementation.
If a separate target resolution is later provided, keep the mockup as the composition space and the target resolution as the implementation space.
```

## Pattern 18: Decompose the Mockup by Runtime Responsibility

Use when a mockup exists and the agent might over-split decorative regions into fake widgets.

```text
Before creating objects, inspect the mockup and decide which regions should stay as one baked visual asset, which regions should become interactive UI elements, and which repeated regions should become reusable blocks.
Decompose by runtime responsibility, not by visual outline alone.
Keep decorative regions whole unless interaction, animation, dynamic text, or adaptive layout requires separation.
Turn repeated structures into reusable prefabs or reusable layout blocks instead of rebuilding them manually.
```

## Pattern 8: Script-Aware UI Editing

Use when script changes are necessary.

```text
Make the required script or component changes for this UI feature.
After editing scripts, run `refresh_unity`, wait for compilation, and use `read_console` for errors before continuing with more UI work.
Then use `manage_camera` to capture a screenshot and confirm the UI still matches the intended layout.
```

## Pattern 9: Default Repair Strategy

Use when the request is vague.

```text
Do not generate the whole UI at once.
Inspect first, then create or fix the interface in small slices.
Prioritize structure over visual polish, and verify each slice with a screenshot before moving on.
```

## Pattern 9A: Decide Repair Mode vs Build Mode First

Use when it is not yet clear whether the request is a bounded repair or a fresh screen build.

```text
Inspect the current UI first and decide whether this request should stay in repair mode or switch to build mode.
If the relevant UI already exists, default to repair mode until a rebuild is clearly justified.
If a rebuild is required, explain why the existing structure is not worth preserving before switching modes.
```

## Pattern 9B: Follow Asset Discovery Priority

Use when asset-aware mode is active and the project likely already has reusable UI assets.

```text
Treat this as asset-aware work and follow a strict discovery order.
Check reusable prefabs first, then variant or wrapper paths, then existing sprite-backed visuals, then text style systems, then materials, and use placeholders only if those higher-priority options are unavailable or low-confidence.
Do not jump straight to placeholder-driven reconstruction while obvious reusable assets still exist.
```

## Pattern 10: UGUI HUD Build

Use when building or repairing a HUD.

```text
Build this screen as UGUI HUD.
Use a `Canvas -> SafeAreaRoot -> HUDRoot` structure and create corner or center containers before leaf widgets.
Choose anchors by screen role: top-left, top-right, bottom-left, bottom-right, bottom-center, or center.
Do not hand-place repeated buttons or status icons if a layout group should own them.
Turn repeated HUD clusters into reusable prefabs when the same structure appears more than once.
After implementation, capture a screenshot at [WIDTHxHEIGHT] and one alternate aspect ratio.
```

## Pattern 11: UGUI Inventory Build

Use when building inventories, shops, crafting panels, or equipment windows.

```text
Build this UI as a UGUI inventory-style panel.
Create the main panel first, then split it into navigation, list or grid, detail panel, and bottom actions as needed.
Use layout groups for repeated slots and rows instead of manually positioning each slot.
Keep sizing parent-driven and verify that the detail panel does not overlap the list at [WIDTHxHEIGHT].
```

## Pattern 12: UGUI Popup Build

Use when building or repairing a modal popup.

```text
Build this UI as a UGUI popup with `Canvas -> ModalLayer`, and keep `Dimmer` and `PopupRoot` as siblings under `ModalLayer`.
Apply safe-area handling to `PopupRoot`, not to `ModalLayer` and not to individual popup children.
Keep the dimmer full-screen and keep popup content local to `PopupRoot`.
Use centered anchors for the popup by default, then use `manage_camera` to verify that close buttons and footer actions stay inside the safe area at [WIDTHxHEIGHT].
```

## Pattern 13: UGUI Mobile Safe Area Repair

Use when mobile UI clips into the notch, rounded corners, or home indicator area.

```text
Repair this mobile UGUI layout with explicit safe-area ownership.
Use `SafeAreaRoot` for normal full-screen UI, but for modal popups apply safe-area handling to `PopupRoot`.
Remove duplicate per-widget safe-area offsets where a single parent should own them.
Verify both portrait and landscape and report any controls that still touch unsafe edges.
```

## Pattern 14: Reusable Prefab First

Use when the same UI shape appears more than once.

```text
Inspect the repeated UI structures on this screen before rebuilding them.
Choose the cleanest shared structure, extract one reusable prefab or template-style block, and keep screen-level placement in the parent container.
Only vary data-level content such as text, icon, count, or state per instance.
Verify that one structural change propagates cleanly across repeated instances.
```

## Pattern 15: Reuse Existing Prefab Before Creating a New One

Use when the project may already contain a similar reusable widget.

```text
Before creating a new prefab, inspect whether the project already contains a reusable UI block for this role.
Choose explicitly between direct reuse, prefab variant, thin wrapper, or a new base prefab.
Do not edit a shared base prefab for a one-screen request unless you verify the impact on another known usage.
Keep screen-level placement in the parent container rather than pushing one-screen offsets into the shared prefab.
```

## Pattern 16: Use a Prefab Variant, Not a Base Edit

Use when the base prefab is structurally right but the current screen needs scoped differences.

```text
Inspect the existing base prefab and determine whether this request should be solved as a prefab variant instead of a direct base edit.
Keep the base contract intact, limit overrides to local visuals, optional sections, or scoped behavior, and do not push one-screen placement rules into the variant asset.
If the variant would need too many structural overrides, stop and reconsider a wrapper or new base prefab instead.
Verify the target variant and one related base-family usage with screenshots.
```
