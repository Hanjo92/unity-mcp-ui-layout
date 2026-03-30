# Common Unity UI Failures

Use this guide when a `unity-mcp` UI task technically completes but the result is still wrong, fragile, or inconsistent across resolutions.

This document is organized by symptom first, because that is usually how problems appear in real usage.

## 1. The UI Matches One Resolution but Breaks on Another

### Typical symptoms

- a corner HUD drifts inward or outward
- a footer bar floats above the bottom edge
- a side panel becomes too wide or too narrow
- a centered dialog stops looking centered

### Likely causes

- `CanvasScaler` reference resolution does not match the intended target
- `Match Width Or Height` was left at an unexamined default
- anchors express absolute placement instead of screen relationship
- child offsets compensate for a missing parent container

### Fix direction

- inspect `CanvasScaler` first
- rebuild the parent container if children depend on screen-wide offsets
- convert absolute intent into anchored intent
- verify at the target resolution and one alternate aspect ratio

## 2. The Layout Looks Correct but Feels Hand-Placed

### Typical symptoms

- many sibling widgets each have different offsets
- repeated items are positioned one by one
- the hierarchy works only because several numbers happen to line up

### Likely causes

- layout groups were avoided when they should own repeated placement
- padding and spacing live in many child objects instead of the parent
- the design was copied from a mockup too literally

### Fix direction

- move ownership to parent containers
- replace repeated manual placement with `HorizontalLayoutGroup`, `VerticalLayoutGroup`, or `GridLayoutGroup`
- reduce child-specific offsets that are really container padding

## 3. The UI Compiles but the Scene Still Looks Wrong

### Typical symptoms

- scripts compile but the visual result does not change as expected
- newly added components do not behave the way the prompt intended
- the scene reflects only part of the requested change

### Likely causes

- the wrong object or parent was edited
- the visual issue is layout-related, not script-related
- the scene contains multiple UI roots and the wrong one was changed

### Fix direction

- re-run discovery before more edits
- inspect the active UI root and parent chain
- verify with screenshots before assuming the script is the problem

## 4. Layout Groups and Manual Placement Fight Each Other

### Typical symptoms

- child positions snap back unexpectedly
- one child refuses to stay where it was moved
- spacing changes after unrelated edits

### Likely causes

- the parent layout group owns child positioning
- a child was manually positioned anyway
- `LayoutElement` and manual offsets are working at cross purposes

### Fix direction

- decide whether the parent group or manual placement owns the layout
- if the parent group owns it, stop moving children manually
- if a child must be exceptional, use `LayoutElement` before raw offsets

## 5. ContentSizeFitter Creates Instability

### Typical symptoms

- rows resize unpredictably
- lists keep growing or collapsing
- text containers fight their parent size

### Likely causes

- `ContentSizeFitter` is attached to an object already controlled by a parent layout group
- width and height ownership are not clearly separated
- text is driving growth in more than one place

### Fix direction

- remove redundant fitters
- make one level responsible for width and one level responsible for height
- give text a known container width before tuning font behavior

## 6. Popup Safe Area Is Technically Applied but Still Feels Wrong

### Typical symptoms

- popup content stays visible, but close button placement feels off
- the dimmer is correct, but the popup looks visually shifted
- portrait works better than landscape or vice versa

### Likely causes

- safe area is on `PopupRoot`, but internal title or footer spacing is still hard-coded
- popup sections use offsets copied from a non-safe-area mockup
- centered layout is mixed with stretch behavior in the popup content

### Fix direction

- keep safe area on `PopupRoot`
- refactor title, content, and footer sections to use local layout rules
- verify portrait and landscape separately

## 7. Text Causes Cascading Breakage

### Typical symptoms

- labels overflow and expand rows
- buttons become uneven because text lengths differ
- one language works but another would not

### Likely causes

- text containers have no stable width rule
- auto-size is compensating for missing layout decisions
- the design assumes one short English label length

### Fix direction

- decide whether text should wrap, truncate, or stay on one line
- size the container before shrinking the text
- test at least one longer label scenario mentally before calling the layout stable

## 8. The UI Toolkit Version Feels Worse After Small Fixes

### Typical symptoms

- one local override fixes the current problem but breaks another section
- spacing becomes inconsistent across siblings
- a screen looks right only because several inline overrides happen to align

### Likely causes

- too many inline styles
- container ownership is weak
- flex rules are being overridden piecemeal

### Fix direction

- move repeated rules into USS classes
- let parent containers own spacing and alignment
- remove local overrides that duplicate container intent

## 9. The Agent Keeps Redesigning Instead of Repairing

### Typical symptoms

- unrelated parts of the screen keep changing
- a small bug fix turns into a large rebuild
- visual style drifts even though the task was only structural

### Likely causes

- the prompt did not constrain scope tightly enough
- the current state was not inspected before editing
- the task was treated as greenfield creation instead of bounded repair

### Fix direction

- restate the task as a limited repair
- name the exact region that may change
- verify the current state before making new structure decisions

## 10. Static UI Assets Drift Into RawImage

### Typical symptoms

- static icons, panels, or button visuals are wired through `RawImage`
- sprite slicing or normal UI asset reuse no longer fits the implementation
- prefab reuse feels awkward because the visual source is treated like arbitrary texture data

### Likely causes

- `RawImage` was used as a shortcut instead of importing or reusing a proper sprite
- the agent did not distinguish between a mockup image and a runtime texture source
- the real issue was asset lookup or import setup, not component type

### Fix direction

- convert ordinary static UI visuals back to `Image` plus sprite-based assets
- reserve `RawImage` for `RenderTexture`, video, runtime-generated textures, or other true texture-driven cases
- if the screen already uses sprite-backed UI assets elsewhere, stay consistent with that workflow

## 11. The Agent Skips Obvious Existing Assets

### Typical symptoms

- a placeholder-heavy UI is built even though similar widgets already exist in the project
- a repeated widget is reconstructed from loose parts even though a prefab family already exists
- text and icon styling drift away from the rest of the project

### Likely causes

- asset-aware mode was entered, but no clear lookup order was followed
- placeholder creation started before prefab or sprite reuse was checked
- the agent treated low-confidence retrieval as permission to stop checking nearby reusable assets

### Fix direction

- check reusable prefabs first
- then check variant or wrapper paths
- then check sprite-backed visuals, text styles, and materials
- leave placeholders as a deliberate last resort, not a default first step

## 12. New Assets Are Named and Stored Like Scratch Files

### Typical symptoms

- reusable assets are left as `Copy`, `New`, or `Temp`
- shared widgets are buried inside one random screen folder
- placeholder visuals start looking like permanent design-system assets

### Likely causes

- asset creation focused only on today's task, not future rediscovery
- shared versus screen-owned scope was never decided
- assets were extracted quickly but never normalized into a stable folder shape

### Fix direction

- rename assets by role instead of editor history
- move shared assets into stable shared UI folders
- keep screen-owned assets near the screen that owns them
- keep placeholder assets visibly provisional so later replacement stays easy

## 13. Text Is Forced to Fit Instead of Being Designed to Fit

### Typical symptoms

- button labels become tiny just to stay on one line
- counters overlap icons when values grow
- one localized string breaks a row that looked fine in the mockup
- text auto-size hides the issue at one resolution but fails at another

### Likely causes

- text line behavior was never decided explicitly
- container width was copied from the mockup without runtime headroom
- font shrinking was used before fixing parent width or sibling layout
- reusable text styles were ignored in favor of local emergency tweaks

### Fix direction

- decide whether the text should wrap, truncate, stay single-line, or grow its container
- stabilize the parent width and sibling layout first
- leave headroom for longer labels and runtime number growth
- use font shrinking only as a controlled final adjustment, not as the default structural fix

## 14. Quick Recovery Strategy

When the work starts drifting, reset the process:

1. inspect the current UI again
2. identify the exact region that is wrong
3. inspect the parent chain
4. fix structure before style
5. verify with a screenshot
6. continue only if the previous slice is stable
