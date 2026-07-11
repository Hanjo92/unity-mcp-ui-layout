# References Index

This folder contains the detailed working knowledge behind the skill.

Use it when `SKILL.md` points you here for deeper guidance.

## Core Guidance

- `agent-runbook.md` - gives the agent-facing operating sequence after the skill triggers, including mode notes and final response checklist.
- `ui-stack-selection.md` - defines stack selection precedence and the required target, Unity version, and UI-root evidence before stack-specific work.
- `layout-checklist.md`
- `layout-snapshot-contract.md` - defines the ideal Unity UI layout snapshot MCP contract and smaller-call fallback before existing UI edits.
- `image-to-layout.md` - includes mockup-to-layer-to-tree workflow, candidate item ledger guidance, item rect mapping, and the asset-RAG fallback contract for when `unity-resource-rag` is unavailable or low-confidence.
- `../../templates/mockup-layout-plan.yaml` - provides the neutral machine-readable `mockup-layout-plan/v2` artifact shape for layer-to-layout tree, stack realization, candidate ledger, item rect, asset crop, and verification target planning.
- `../../examples/mockup-layout-plan-prefab-example.yaml` - canonical UGUI/prefab-oriented v2 example.
- `../../examples/mockup-layout-plan-ui-toolkit-example.yaml` - canonical UI Toolkit/UXML/USS-oriented v2 example.
- `mcp-call-recipes.md`
- `mockup-decomposition.md` - owns layer-to-tree decomposition, parent ownership, split/keep decisions, and item rect contract for raster mockups.
- `mockup-resolution.md`
- `ui-change-modes.md`
- `asset-discovery-priority.md`
- `asset-naming-and-folders.md`
- `asset-naming-examples.md`
- `existing-prefab-reuse.md`
- `shared-asset-edit-safety.md`
- `shared-asset-verification-recipes.md`
- `prefab-variants.md`
- `prefab-reuse.md`
- `mockup-safe-area-mapping.md`
- `mobile-device-profiles.md`
- `sprite-vs-rawimage.md`
- `text-layout-rules.md`
- `common-failures.md`
- `review-checks.md`
- `review-gates-and-assumptions.md` - explains hard blockers, soft assumptions, candidate review states, no-human-review fallback, and final reporting.
- `scroll-view-patterns.md`
- `design-system-intake.md`
- `design-token-to-unity.md`
- `stitch-html-to-ugui.md`
- `figma-node-tree-to-ugui.md`

## UGUI-Focused Guidance

- `ugui-anchors-canvas-scaler.md`
- `ugui-hud.md`
- `ugui-inventory.md`
- `ugui-popup.md`
- `ugui-mobile-safe-area.md`

## UI Toolkit-Focused Guidance

- `ui-stack-selection.md` - choose UGUI or UI Toolkit before realization using target and ownership evidence.
- `ui-toolkit-build-workflow.md` - realize an approved neutral plan as visual tree, UXML, USS, and optional runtime host.
- `ui-toolkit-layout-rules.md`
- `ui-toolkit-failures.md`
- `../../examples/ui-toolkit-from-mockup-example.md` - canonical mockup-to-UI Toolkit walkthrough.

## Prompting Guidance

- `prompt-patterns.md`
