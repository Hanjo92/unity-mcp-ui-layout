# Platform Adapters

This folder contains platform-specific packaging for the same Unity MCP UI layout workflow.

## Default

- `Codex` is the default platform and the canonical implementation is the root skill folder:
  - [`unity-mcp-ui-layout/`](../unity-mcp-ui-layout)

## Included Adapters

- [`Codex/`](./Codex)
- [`Google-Antigravity/`](./Google-Antigravity)
- [`Claude-Artifacts/`](./Claude-Artifacts)

## Intent

Each adapter keeps the same core rules:

- prefer anchors and containers over raw pixels
- group the top-level composition by anchor-owned regions before leaf-level tuning
- choose scaling rules before sizing children
- reuse repeated structures through prefabs or reusable blocks where appropriate
- keep likely single-image assets simple unless runtime behavior requires decomposition
- verify with screenshots
- treat popups and safe area carefully
- iterate in small slices instead of one-shot UI generation
