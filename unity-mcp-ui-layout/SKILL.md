---
name: unity-mcp-ui-layout
description: "Use when Unity UI needs layout-focused implementation or repair through `unity-mcp`: attached UI mockup, mockup screenshot, uploaded design image, dropped design image, reference image, wireframe, or UI 시안; analyze visual layers into a layer-to-Transform tree/레이어 트리 구조; create candidate item ledgers; map item-level UI rects; turn or convert into UGUI/UI Toolkit; create Unity UI prefabs/프리팹 생성; or fix drift, safe area, text overflow, structured exports, tokens, or shared prefab reuse."
---

# Unity MCP UI Layout

## Overview

Use this skill for Unity UI work where layout stability matters more than raw pixel imitation. The core idea is to translate visual intent into anchors, containers, scaling rules, text behavior, and verification loops that survive resolution changes.

**Bias:** Prefer stable structure, scoped changes, and explicit verification over one-shot mockup mimicry. For trivial one-widget nudges, use judgment rather than forcing the full workflow mechanically.

## When to Use

- A mockup, screenshot, or wireframe needs to become runtime Unity UI.
- An attached UI mockup, layout image, mockup screenshot, uploaded or dropped design/reference image, or UI 시안 should become UGUI, UI Toolkit, or Unity UI prefabs.
- Natural wording such as "turn this reference image into UI", "convert this mockup to a prefab", "시안 던져줄게", or "프리팹 만들어줘" should trigger this skill.
- A visual design needs a layer-to-Transform tree pass so the Unity Transform or RectTransform hierarchy is planned before object creation.
- A raster mockup needs a candidate item ledger before item-level UI rects are promoted into Unity objects or crop plans.
- A provided mockup needs item-level UI rect planning for runtime leaves, repeated cards, slots, rows, icons, or buttons that were intentionally split from the visual design.
- The user asks to create Unity UI prefabs, 프리팹, prefab variants, or reusable UI blocks from a provided design image.
- An existing UGUI screen drifts across aspect ratios or target resolutions.
- A UI Toolkit screen looks correct once but breaks after width, overflow, or text changes.
- A scroll-heavy list, feed, catalog, or picker mockup needs one clear scroll owner plus reusable repeated items.
- Safe area, localization, counters, or long labels are destabilizing the layout.
- A Stitch HTML/CSS export should become a stable UGUI hierarchy instead of a literal web-runtime copy.
- A Figma-exported node tree or component tree should become reusable UGUI containers and prefabs.
- A `DESIGN.md`, `design_tokens.json`, Tailwind theme, or similar design-system source should guide Unity UI styling.
- A repeated UI block should become reusable instead of being rebuilt manually.
- A one-screen repair may touch shared prefabs, sprites, materials, or text styles.

## When Not to Use

- Pure gameplay or data logic work that only happens to touch UI code.
- Illustration or asset-painting work where no runtime Unity layout is being built.
- Non-Unity UI work.
- Full-stack migration work unless the task is specifically about stabilizing the target UI layout.

## Quick Router

Choose these four boundaries before editing anything:

### 1. UI Stack

- Use **UGUI** when the target uses `Canvas`, `RectTransform`, `CanvasScaler`, `LayoutGroup`, `Image`, or `TextMeshProUGUI`.
- Use **UI Toolkit** when the target uses `UIDocument`, `UXML`, `USS`, `VisualElement`, or `PanelSettings`.
- Do not mix both stacks in one change unless the user explicitly asks for a bridge or migration.

### 2. Change Mode

- Use **repair mode** when the screen already exists and the user wants it fixed, aligned, stabilized, or kept stylistically consistent.
- Use **build mode** when the screen does not exist yet or the user clearly wants a fresh implementation.
- If a repair request starts revealing broken parent structure, explain the scope expansion instead of silently rebuilding.

For the full decision guide, read `references/ui-change-modes.md`.

### 3. Design Source

- If the user provides Stitch HTML/CSS, Figma node-tree JSON, or another structured export artifact, treat it as a hierarchy source before creating Unity objects.
- If the user provides `DESIGN.md`, design tokens, Tailwind theme values, or a design-system document, read it before styling.
- Use structured exports for ownership, grouping, repeated blocks, and layout behavior. Use design-system sources for colors, typography, spacing scales, shape language, and state styling.
- If both source families exist, keep the split explicit:
  - structured export -> hierarchy and repeated-unit decisions
  - design-system source -> style contract
  - mockup or screenshot -> composition verification
- Treat machine-readable tokens as the style contract and Markdown prose as intent for applying those values.
- Use design-source guidance to preserve color, typography, spacing, shape, component states, and accessibility while still following layout stability rules.

For design-system intake and mapping rules, read `references/design-system-intake.md` and `references/design-token-to-unity.md`.
For structured export intake and hierarchy mapping, read `references/stitch-html-to-ugui.md` and `references/figma-node-tree-to-ugui.md`.

### 4. Asset Strategy

- Start in **layout-only mode** by default.
- Switch to **asset-aware mode** only when existing prefab, sprite, font, material, or design-system reuse clearly matters.
- Missing `unity-resource-rag`, asset catalogs, or asset indexes is a supported fallback, not an error condition.

## Requires and Fallbacks

- This skill assumes Unity is available through `unity-mcp` or an equivalent MCP bridge.
- It works best when you can inspect the current scene or UI document and verify with screenshots.
- Structured export artifacts are valid first-class inputs even when direct Figma or Stitch API access is unavailable.
- If a `DESIGN.md` or token source is present, style decisions should be traced back to that source where practical.
- `@google/design.md` CLI checks are useful when available, but missing CLI tooling is a supported fallback.
- Use asset-aware retrieval only when the environment supports it and the task actually needs reuse-sensitive decisions.
- If asset retrieval is unavailable or low-confidence, continue with structure-first layout work, use placeholders or directly inspected assets, and keep uncertain visuals provisional.

## Quick Success Signal

- The layout stays stable in a fresh screenshot at the main target and one additional aspect ratio.
- If a mockup drove item placement, split runtime or repeated items have source rect, normalized rect, Unity fit intent, and asset/crop plan before final tuning.
- Text still behaves correctly with longer strings, counters, or localization growth.
- If a structured export source was provided, repeated blocks and parent ownership still read clearly in the resulting Unity hierarchy.
- If a design-system source was provided, visible colors, typography, spacing, shape, and component states still follow it.
- Shared assets were either left alone, localized through variants/wrappers, or explicitly verified before base edits.
- Script-backed UI changes do not leave unresolved compile or console errors.

## Four Principles

### 1. Clarify the Layout Contract

- Identify the active scene or `UIDocument` before editing.
- Choose the UI stack, change mode, design source, and asset strategy explicitly.
- If a structured export source exists, normalize it into a semantic tree before copying any coordinates.
- If a design-system source exists, extract the tokens, prose intent, component states, and any do/don't guardrails before styling.
- If no structured hierarchy source exists and a mockup, screenshot, reference image, or UI 시안 exists, run a layer-to-Transform tree pass before creating objects and keep that tree as the layout contract.
- If a structured export and a mockup/screenshot both exist, let the structured export own hierarchy and use the raster layer pass as composition validation.
- If raster item analysis is useful, produce a candidate item ledger as an advisory candidate set with confidence band, evidence, and human review before promoting anything into item-level UI rects.
- For any runtime leaf or repeated item intentionally split from a mockup, record an item-level UI rect: source rect in the mockup, normalized rect, parent-local rect or Unity fit intent, split/keep reason, and asset/crop plan.
- Inspect the root layout owner before touching children.
- For UGUI, inspect `Canvas`, `CanvasScaler`, parent `RectTransform`, layout components, and safe-area handling.
- For UI Toolkit, inspect `UIDocument`, linked `UXML`, linked `USS`, panel settings, and container ownership.
- If the UI is scroll-heavy, decide the scroll owner, viewport boundary, content container, and repeated-item strategy before styling rows or cards.
- Treat any mockup or screenshot as composition guidance first, not as a command to freeze raw pixels.

**The test:** If two reasonable interpretations exist for stack, repair scope, reference resolution, or reuse expectations, do not silently pick one.

### 2. Stabilize Structure Before Polish

- Build or repair in vertical slices: root shell, main regions, one feature block at a time, then polish.
- Fix parent ownership before child offsets.
- When the layout is wrong, inspect parent container choice, anchors or flex ownership, sizing rules, text behavior, then visual polish.
- Convert image-based layouts into relative measurements tied to the reference resolution.
- Keep likely single-image regions intact unless runtime behavior requires decomposition.
- Use item-level UI rects to size split runtime/repeated items, not to force decorative sub-parts into fake child objects.

**The test:** If you are reaching for pixel nudges before checking the parent structure, you are probably fixing the symptom instead of the cause.

### 3. Reuse Carefully and Locally

- Start in layout-only mode and only switch into asset-aware mode when reuse clearly matters.
- Promote repeated structures into reusable prefabs or reusable layout blocks when repetition is real.
- For scroll-heavy UIs, keep the scroll shell structural and treat repeated rows/cards/cells as the reusable unit.
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
- If a mockup, screenshot, or wireframe was provided, one final review pass was run against it after implementation changes.
- If no structured hierarchy source existed and a mockup, screenshot, reference image, or UI 시안 drove the work, the final Unity Transform or RectTransform tree still matches the approved layer-to-tree pass.
- If a structured export existed alongside a mockup/screenshot, hierarchy still follows the export and the raster image was used for composition validation.
- If a candidate item ledger was used, accepted candidates passed a human review gate before item-level UI rect planning.
- If item-level UI rect planning was needed, key split items have source rect, normalized rect, parent-local or fit intent, and asset/crop plan recorded before final visual tuning.
- The layout was re-checked at one additional aspect ratio, or portrait plus landscape for mobile-first work.
- Compile or console errors were cleared if script-backed UI changed.
- Text behavior still works for longer or more realistic content.
- UGUI repeated siblings and regular auto-layout/flex groups use layout components, or the manual-placement exception is named.
- Structured export inputs were normalized into stable containers, repeated blocks, or overlays instead of remaining as noisy one-off copies.
- Provided design-system tokens and prose were preserved, or deviations were explicitly justified.
- Component text/background pairs were checked for readable contrast where the source defines both values.
- Shared-asset edits were treated with explicit safety checks.
- Low-confidence asset reuse stayed clearly provisional.

## Use the References

### First Stop

- `references/layout-checklist.md`
- `references/common-failures.md`
- `references/review-checks.md`
- `references/scroll-view-patterns.md`
- `references/ui-change-modes.md`

### Design Systems and Tokens

- `references/design-system-intake.md`
- `references/design-token-to-unity.md`

### Structured Export Sources

- `references/stitch-html-to-ugui.md`
- `references/figma-node-tree-to-ugui.md`

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
