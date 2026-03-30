# Google Antigravity Adapter

This adapter repackages the Unity MCP UI layout workflow as a more execution-oriented prompt package for Google Antigravity-style custom instructions or workspace guidance.

## Files

- `SYSTEM_PROMPT.md`: base instruction set for the assistant

## Usage

1. Open `SYSTEM_PROMPT.md`
2. Paste or adapt it into your Antigravity custom instruction area
3. Use it together with Unity MCP access or an equivalent Unity bridge
4. Pair it with task prompts that include a layout image, target resolution, and the intended UI stack when known

## Goal

Make Antigravity follow the same rules as the Codex skill, but in a firmer system-prompt style that emphasizes execution discipline:

- inspect first
- build in slices
- convert images into relative layout
- group the top-level layout by anchor-owned regions first
- reuse repeated structures through prefabs or reusable blocks
- keep likely single-image regions intact unless runtime behavior requires splitting
- use anchors and scaling instead of raw pixels
- verify with screenshots
- treat text as a layout driver instead of a last-minute font tweak
- remap notch-agnostic mockups into safe-area-aware layouts
- avoid risky direct edits to shared base assets for one-screen fixes

## Example User Prompts

```text
Build this Unity HUD from the attached mockup at 1920x1080.
Treat the image as a composition reference, not a raw pixel map.
Group the top-level layout by anchor-owned regions, create parent regions first, choose anchors and CanvasScaler rules, then verify with screenshots.
Turn repeated structures into reusable prefabs or reusable layout blocks.
```

```text
Repair the current UGUI inventory so that slot spacing, detail panel sizing, and scaling remain stable across resolutions.
Preserve the current style.
Keep repeated slot structures reusable instead of rebuilding them one by one.
Inspect first, make bounded changes, and verify at the target resolution and one alternate aspect ratio.
```

```text
Create a modal reward popup for mobile.
Use a ModalLayer with sibling Dimmer and PopupRoot, and keep safe-area handling on PopupRoot.
Group the top-level popup layout before tuning child offsets, and keep decorative framing as a single image when appropriate.
Do not build the whole screen at once. Implement the popup structure first, then verify portrait and landscape.
```

```text
Compare the current UI against the attached reference image.
Find the structural differences causing the layout drift.
Fix top-level anchor grouping, parent containers, and scaling rules before changing styling or local offsets.
Collapse over-modeled decorative regions back into a single image when they are likely one baked asset.
```

```text
Build this mobile popup from the attached mockup, but do not copy raw edge pixels from the image.
Treat the mockup as composition guidance, map top and bottom spacing into the safe area, keep Dimmer and PopupRoot separate, and verify both portrait and landscape.
```

```text
Repair this UI without destabilizing the design system.
Check whether the affected widget is part of a shared prefab or shared asset family first.
If the requested change is local to one screen, prefer a variant, wrapper, or local override over a direct base edit.
```
