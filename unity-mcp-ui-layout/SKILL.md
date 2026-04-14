---
name: unity-mcp-ui-layout
description: Use when Unity UI needs layout-focused repair or implementation through `unity-mcp`, especially for UGUI or UI Toolkit screens with cross-resolution drift, safe-area problems, text overflow, mockup translation, or shared prefab reuse decisions.
---

# Unity MCP UI Layout

## Overview

Use this skill for Unity UI work where layout stability matters more than raw pixel imitation. The core idea is to translate visual intent into anchors, containers, scaling rules, text behavior, and verification loops that survive resolution changes.

**Bias:** Prefer stable structure, scoped changes, and explicit verification over one-shot mockup mimicry. For trivial one-widget nudges, use judgment rather than forcing the full workflow mechanically.

## When to Use

- A mockup, screenshot, or wireframe needs to become runtime Unity UI.
- An existing UGUI screen drifts across aspect ratios or target resolutions.
- A UI Toolkit screen looks correct once but breaks after width, overflow, or text changes.
- Safe area, localization, counters, or long labels are destabilizing the layout.
- A repeated UI block should become reusable instead of being rebuilt manually.
- A one-screen repair may touch shared prefabs, sprites, materials, or text styles.

## When Not to Use

- Pure gameplay or data logic work that only happens to touch UI code.
- Illustration or asset-painting work where no runtime Unity layout is being built.
- Non-Unity UI work.
- Full-stack migration work unless the task is specifically about stabilizing the target UI layout.

## Quick Router

Choose these three boundaries before editing anything:

### 1. UI Stack

- Use **UGUI** when the target uses `Canvas`, `RectTransform`, `CanvasScaler`, `LayoutGroup`, `Image`, or `TextMeshProUGUI`.
- Use **UI Toolkit** when the target uses `UIDocument`, `UXML`, `USS`, `VisualElement`, or `PanelSettings`.
- Do not mix both stacks in one change unless the user explicitly asks for a bridge or migration.

### 2. Change Mode

- Use **repair mode** when the screen already exists and the user wants it fixed, aligned, stabilized, or kept stylistically consistent.
- Use **build mode** when the screen does not exist yet or the user clearly wants a fresh implementation.
- If a repair request starts revealing broken parent structure, explain the scope expansion instead of silently rebuilding.

For the full decision guide, read `references/ui-change-modes.md`.

### 3. Asset Strategy

- Start in **layout-only mode** by default.
- Switch to **asset-aware mode** only when existing prefab, sprite, font, material, or design-system reuse clearly matters.
- Missing `unity-resource-rag`, asset catalogs, or asset indexes is a supported fallback, not an error condition.

## Requires and Fallbacks

- This skill assumes Unity is available through `unity-mcp` or an equivalent MCP bridge.
- It works best when you can inspect the current scene or UI document and verify with screenshots.
- Use asset-aware retrieval only when the environment supports it and the task actually needs reuse-sensitive decisions.
- If asset retrieval is unavailable or low-confidence, continue with structure-first layout work, use placeholders or directly inspected assets, and keep uncertain visuals provisional.

## Quick Success Signal

- The layout stays stable in a fresh screenshot at the main target and one additional aspect ratio.
- Text still behaves correctly with longer strings, counters, or localization growth.
- Shared assets were either left alone, localized through variants/wrappers, or explicitly verified before base edits.
- Script-backed UI changes do not leave unresolved compile or console errors.

## Four Principles

### 1. Clarify the Layout Contract

- Identify the active scene or `UIDocument` before editing.
- Choose the UI stack, change mode, and asset strategy explicitly.
- Inspect the root layout owner before touching children.
- For UGUI, inspect `Canvas`, `CanvasScaler`, parent `RectTransform`, layout components, and safe-area handling.
- For UI Toolkit, inspect `UIDocument`, linked `UXML`, linked `USS`, panel settings, and container ownership.
- Treat any mockup or screenshot as composition guidance first, not as a command to freeze raw pixels.

**The test:** If two reasonable interpretations exist for stack, repair scope, reference resolution, or reuse expectations, do not silently pick one.

### 2. Stabilize Structure Before Polish

- Build or repair in vertical slices: root shell, main regions, one feature block at a time, then polish.
- Fix parent ownership before child offsets.
- When the layout is wrong, inspect parent container choice, anchors or flex ownership, sizing rules, text behavior, then visual polish.
- Convert image-based layouts into relative measurements tied to the reference resolution.
- Keep likely single-image regions intact unless runtime behavior requires decomposition.

**The test:** If you are reaching for pixel nudges before checking the parent structure, you are probably fixing the symptom instead of the cause.

### 3. Reuse Carefully and Locally

- Start in layout-only mode and only switch into asset-aware mode when reuse clearly matters.
- Promote repeated structures into reusable prefabs or reusable layout blocks when repetition is real.
- Prefer scoped variants, wrappers, or screen-owned overrides over direct shared-base edits for one-screen requests.
- Reserve `RawImage` for texture-driven content such as `RenderTexture`, video, or runtime-generated textures.
- Leave room for longer labels, localization growth, and number growth instead of overfitting to the mockup strings.

**The test:** If a structure appears once, do not abstract it yet. If a change is screen-specific, shared-base edits need proof.

### 4. Define Success and Verify It

- Capture fresh screenshots after structural changes.
- Verify at the main target plus at least one additional aspect ratio.
- If scripts changed, refresh Unity and confirm there are no unresolved compile or console errors.
- If text drives layout, re-check longer labels, counters, or localized strings before calling the task done.
- Use the completion gate below as the final stop condition.

**The test:** If you cannot name the screenshot, aspect-ratio, text, and error checks that prove success, the task is not done yet.

## Completion Gate

Do not call the task done until every applicable check below passes:

- A fresh whole-screen verification screenshot exists.
- The layout was re-checked at one additional aspect ratio, or portrait plus landscape for mobile-first work.
- Compile or console errors were cleared if script-backed UI changed.
- Text behavior still works for longer or more realistic content.
- Shared-asset edits were treated with explicit safety checks.
- Low-confidence asset reuse stayed clearly provisional.

## Use the References

### First Stop

- `references/layout-checklist.md`
- `references/common-failures.md`
- `references/review-checks.md`
- `references/ui-change-modes.md`

### Mockups, Resolution, and Safe Area

- `references/image-to-layout.md`
- `references/mockup-decomposition.md`
- `references/mockup-resolution.md`
- `references/mockup-safe-area-mapping.md`
- `references/mobile-device-profiles.md`

### Asset Reuse and Shared-Asset Safety

- `references/asset-discovery-priority.md`
- `references/existing-prefab-reuse.md`
- `references/prefab-reuse.md`
- `references/prefab-variants.md`
- `references/shared-asset-edit-safety.md`
- `references/shared-asset-verification-recipes.md`
- `references/asset-naming-and-folders.md`
- `references/asset-naming-examples.md`

### Text and Image Decisions

- `references/text-layout-rules.md`
- `references/sprite-vs-rawimage.md`

### UGUI

- `references/ugui-anchors-canvas-scaler.md`
- `references/ugui-hud.md`
- `references/ugui-inventory.md`
- `references/ugui-popup.md`
- `references/ugui-mobile-safe-area.md`

### UI Toolkit

- `references/ui-toolkit-layout-rules.md`
- `references/ui-toolkit-failures.md`

### Prompting and MCP Sequences

- `references/mcp-call-recipes.md`
- `references/prompt-patterns.md`
