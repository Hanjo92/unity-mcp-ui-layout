---
name: unity-mcp-ui-layout
description: "Use when Unity UI needs sequential design planning, layout-focused implementation, or repair through `unity-mcp`: attached UI mockup, mockup screenshot, uploaded design image, dropped design image, reference image, wireframe, or UI 시안; analyze visual layers with a layer-to-layout-tree pass/레이어 트리 구조; create candidate item ledgers; map item-level UI rects; turn or convert into UGUI/UI Toolkit; create Unity UI prefabs/프리팹 생성; or fix drift, safe area, text overflow, structured exports, tokens, or shared prefab reuse."
---

# Unity MCP UI Layout

## Overview

Use this skill for Unity UI work where layout stability matters more than raw pixel imitation. The core idea is to translate visual intent into stack-appropriate layout rules, containers, scaling rules, text behavior, and verification loops that survive resolution changes; anchors are a UGUI mechanism, not a universal rule.

**Bias:** Prefer stable structure, scoped changes, and explicit verification over one-shot mockup mimicry. For trivial one-widget nudges, use judgment rather than forcing the full workflow mechanically.

## When to Use

- A mockup, screenshot, or wireframe needs to become runtime Unity UI.
- A new Unity screen needs sequential planning with the user before its design and structure are implemented.
- An attached UI mockup, layout image, mockup screenshot, uploaded or dropped design/reference image, or UI 시안 should become UGUI, UI Toolkit, or Unity UI prefabs.
- Natural wording such as "turn this reference image into UI", "convert this mockup to a prefab", "시안 던져줄게", or "프리팹 만들어줘" should trigger this skill.
- A visual design needs a layer-to-layout-tree pass so the neutral layout tree is reviewed under the review policy before stack-specific object creation.
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

## Execution Contract

For implementation and repair, read [references/execution-contract.md](references/execution-contract.md) and [references/agent-runbook.md](references/agent-runbook.md) first. They define proportional planning, source-coordinate conventions, review authority, rerun behavior, and evidence-based completion. Use the bundled [plan template](templates/mockup-layout-plan.yaml) and `scripts/validate_layout_plan.rb` for full mockup plans. A passing plan is not Unity verification.

## Quick Router

Choose these four boundaries before editing anything:

### 1. UI Stack

- Apply `references/ui-stack-selection.md` before using prefab or Canvas defaults.
- An **explicit user instruction** for UI Toolkit, a selected `UIDocument`, a resolved visual-tree root, or an editor UI Toolkit owner routes to UI Toolkit before UGUI defaults.
- Treat `UXML`, `USS`, and `PanelSettings` as corroborating only when referenced by that owner; their mere asset presence is not decisive.
- Use **UGUI** when the selected target uses `Canvas`, `RectTransform`, `CanvasScaler`, `LayoutGroup`, `Image`, or `TextMeshProUGUI`.
- Use **UI Toolkit** when the selected target has decisive UI Toolkit ownership evidence.
- Route UI Toolkit mockup build tasks through `references/ui-toolkit-build-workflow.md` before stack-specific asset creation and completion checks.
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

- With a supplied mockup or UI 시안, use **asset-aware mode**: inspect project images and reuse suitable resources before proposing generated art or placeholders. An explicit user request for layout-only work takes precedence.
- Use **layout-only mode** for structural work without an art requirement; preserve already assigned assets during bounded repairs.
- Missing `unity-resource-rag`, catalogs, or indexes means direct asset discovery and inspection, not permission to skip project images.
- For missing images, first verify that the agent has an available image-generation skill and read its instructions. Only with that skill and a usable generation path may you ask about temporary-resource generation or generate images. Without the skill, skip both the generation question and generation; a standalone tool/API is insufficient. Existing authorization or refusal settles the choice, not the skill prerequisite. Follow `references/image-asset-workflow.md` for execution and fallback.

## Requires and Fallbacks

- Before delegated/orchestrated work, use `references/agent-capability-routing.md` to verify each executing session's skills, generation tools, vision, artifact access, and Unity access. Do not infer inheritance or capability from Orca/Paseo, Claude/OpenCode, API, or model names.
- Assign raster analysis and visual QA only to an executor with verified image input and interpretation. Text-only workers implement approved structured handoffs; screenshot capture, file access, and code checks do not prove visual inspection. If no qualified reviewer exists, keep required visual analysis/verification pending.
- Keep generation questions and execution with a verified skill-owning generation executor. A coordinator may relay that executor's question; parent skills plus child tools do not automatically qualify the child. Apply the generation skill's own inspection requirements when splitting generation and review roles.
- This skill assumes Unity is available through `unity-mcp` or an equivalent MCP bridge.
- It works best when you can inspect the current scene or UI document and verify with screenshots.
- When editing existing Unity UI, capture a layout snapshot or equivalent smaller-call evidence before structural edits: target surface, Unity version evidence, selected object (`selection.selected_object`), active UI root (`selection.active_ui_root`), UI stack, root layout owners, screenshot frame, and console state.
- Structured export artifacts are valid first-class inputs even when direct Figma or Stitch API access is unavailable.
- If a `DESIGN.md` or token source is present, style decisions should be traced back to that source where practical.
- `@google/design.md` CLI checks are useful when available, but missing CLI tooling is a supported fallback.
- Use indexed asset retrieval when available; otherwise inspect project assets directly through the Unity bridge or filesystem and previews.
- If no suitable asset can be found, follow the agreed generation or provisional-fallback decision. Continue independent, agreed structure work and keep missing visuals explicit.

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
- For new screens or substantial redesigns, follow `references/ui-planning-workflow.md`: inspect, ask about unresolved purpose/behavior, propose composition and structure, settle resource choices, then implement the agreed plan. Reuse prior answers and authorization; small repairs do not require a fresh planning cycle.
- If a structured export source exists, normalize it into a semantic tree before copying any coordinates.
- If a design-system source exists, extract the tokens, prose intent, component states, and any do/don't guardrails before styling.
- If no structured hierarchy source exists and a mockup, screenshot, reference image, or UI 시안 exists, run a layer-to-layout-tree pass before creating objects and keep that neutral layout tree as the layout contract.
- If a structured export and a mockup/screenshot both exist, let the structured export own hierarchy and use the raster layer pass as composition validation.
- If raster item analysis is useful, produce a candidate item ledger as an advisory candidate set with confidence band, evidence, and recorded review before promoting anything into item-level UI rects. Human review is required only when the user requests it or a hard blocker remains; otherwise follow `references/review-gates-and-assumptions.md`.
- For any runtime leaf or repeated item intentionally split from a mockup, record an item-level UI rect: source rect in the mockup, normalized rect, parent-local rect or Unity fit intent, split/keep reason, and asset/crop plan.
- Inspect the root layout owner before touching children.
- For UGUI, inspect `Canvas`, `CanvasScaler`, parent `RectTransform`, layout components, and safe-area handling.
- For UI Toolkit, inspect `UIDocument`, linked `UXML`, linked `USS`, panel settings, and container ownership.
- If the UI is scroll-heavy, decide the scroll owner, viewport boundary, content container, and repeated-item strategy before styling rows or cards.
- Treat any mockup or screenshot as composition guidance first, not as a command to freeze raw pixels.

**The test:** Resolve choices from inspected evidence first. Ask only for unresolved scope-changing decisions; record local reversible assumptions and continue.

### 2. Stabilize Structure Before Polish

- Build or repair in vertical slices: root shell, main regions, one feature block at a time, then polish.
- Fix parent ownership before child offsets.
- When the layout is wrong, inspect parent container choice, anchors or flex ownership, sizing rules, text behavior, then visual polish.
- Convert image-based layouts into relative measurements tied to the reference resolution.
- Keep likely single-image regions intact unless runtime behavior requires decomposition.
- Use item-level UI rects to size split runtime/repeated items, not to force decorative sub-parts into fake child objects.

**The test:** If you are reaching for pixel nudges before checking the parent structure, you are probably fixing the symptom instead of the cause.

### 3. Reuse Carefully and Locally

- For mockup-driven work, inspect and use suitable project images; use an available image-generation skill for agreed missing or replacement art only, keeping temporary assets visibly provisional.
- Promote repeated structures into the stack's reusable unit when repetition is real: UGUI prefabs for UGUI, or UXML/`VisualTreeAsset` templates plus USS classes for UI Toolkit.
- For scroll-heavy UIs, keep the scroll shell structural and treat repeated rows/cards/cells as the reusable unit.
- Prefer scoped variants, wrappers, or screen-owned overrides over direct shared-base edits for one-screen requests.
- Reserve `RawImage` for texture-driven content such as `RenderTexture`, video, or runtime-generated textures.
- Leave room for longer labels, localization growth, and number growth instead of overfitting to the mockup strings.

**The test:** If a structure appears once, do not abstract it yet. If a change is screen-specific, shared-base edits need proof.

### 4. Define Success and Verify It

- Capture fresh screenshots after structural changes.
- Verify at the main target plus at least one additional aspect ratio.
- If scripts changed, remember that script tools trigger automatic import and compilation; wait for editor state to settle and inspect the console for unresolved errors.
- If text drives layout, re-check longer labels, counters, or localized strings before calling the task done.
- Use the completion gate below as the final stop condition.

**The test:** If you cannot name the screenshot, aspect-ratio, text, and error checks that prove success, the task is not done yet.

## Completion Gate

Do not call the task done until every applicable check below passes:

- Material design and structure choices were settled with the user or covered by explicit delegation; required pending answers did not become speculative UI.
- For delegated work, each role had verified capabilities and accessible input revisions. Record technical and visual evidence owners separately; a worker's completion or screenshot capture did not substitute for final visual review of the current output.
- For mockup-driven work, project image discovery and chosen paths are recorded, with gaps and any explicit layout-only exception named. Generation questions and execution occurred only with an available image-generation skill. Generated art has skill identity, generation/import/assignment/visual-check evidence, and temporary or final status recorded.
- A fresh whole-screen verification screenshot exists.
- For existing Unity UI edits, a layout snapshot or equivalent smaller-call intake identified target surface, Unity version evidence, selected object (`selection.selected_object`), active UI root (`selection.active_ui_root`), UI stack, layout ownership, screenshot frame, and console state before structural changes.
- If a mockup, screenshot, or wireframe was provided, one final review pass was run against it after implementation changes.
- If no structured hierarchy source existed and a mockup, screenshot, reference image, or UI 시안 drove the work, the final stack-specific realization still matches the approved layout tree: UGUI through its `Transform`/`RectTransform`, anchors, layout components, and prefab roots; UI Toolkit through its visual tree, UXML templates or `VisualTreeAsset`, flex/style owners, and optional behavior owner.
- If a structured export existed alongside a mockup/screenshot, hierarchy still follows the export and the raster image was used for composition validation.
- If a candidate item ledger was used, accepted candidates have a recorded `review_source` and meet the review policy before item-level UI rect planning; honor any explicit human review gate.
- If item-level UI rect planning was needed, key split items have source rect, normalized rect, parent-local or fit intent, and asset/crop plan recorded before final visual tuning.
- The layout was re-checked at one additional aspect ratio, within supported orientations; test portrait plus landscape only when both are supported.
- New compile or console errors caused by the change were cleared; pre-existing errors and any verification they block are reported separately.
- Text behavior still works for longer or more realistic content.
- UGUI repeated siblings and regular auto-layout/flex groups use layout components, or the manual-placement exception is named.
- Structured export inputs were normalized into stable containers, repeated blocks, or overlays instead of remaining as noisy one-off copies.
- Provided design-system tokens and prose were preserved, or deviations were explicitly justified.
- Component text/background pairs were checked for readable contrast where the source defines both values.
- Shared-asset edits were treated with explicit safety checks.
- Low-confidence asset reuse stayed clearly provisional.
- For every UI Toolkit build, asset import and console evidence are clean and the resolved visual tree matches the plan. For each category in bindings, callbacks, state classes, focus, and navigation, record exercised evidence or `not_applicable` with a reason when `behavior_plan: []` or the build is structure-only. Record host lifecycle ownership for runtime UI, or `not_applicable` with the Editor owner and reason for Editor UI. Report any tool limitations with fallback evidence.

## Use the References

### First Stop

- `references/agent-runbook.md`
- `references/agent-capability-routing.md`
- `references/ui-planning-workflow.md`
- `references/layout-checklist.md`
- `references/layout-snapshot-contract.md`
- `references/common-failures.md`
- `references/review-checks.md`
- `references/review-gates-and-assumptions.md`
- `references/ui-stack-selection.md`
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
- `references/image-asset-workflow.md`
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

- `references/ui-toolkit-build-workflow.md`
- `references/ui-toolkit-layout-rules.md`
- `references/ui-toolkit-failures.md`

### Prompting and MCP Sequences

- `references/mcp-call-recipes.md`
- `references/prompt-patterns.md`
