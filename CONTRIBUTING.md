# Contributing

Thanks for contributing to this repository.

This project is a documentation-heavy skill package for Unity UI work through `unity-mcp`, so contribution quality depends more on clarity, repeatability, and real-world usefulness than on volume.

## Contribution Priorities

Prioritize contributions in this order:

1. real failure patterns seen during usage
2. concrete `unity-mcp` call sequences that reduce ambiguity
3. examples that connect rules to actual tasks
4. platform-specific prompt improvements
5. repository polish and navigation

## Contribution Principles

- Keep `SKILL.md` lean and procedural.
- Put detailed guidance in `references/`.
- Put copyable task samples in `examples/`.
- Prefer symptom-first documentation when describing failures.
- Prefer bounded, practical examples over broad theoretical advice.
- Preserve the distinction between UGUI and UI Toolkit when it matters.

## Recommended Workflow

1. Identify the real problem or friction point.
2. Decide whether it belongs in:
   - `unity-mcp-ui-layout/SKILL.md`
   - `unity-mcp-ui-layout/references/`
   - `examples/`
   - `Platform/`
3. Keep the change narrowly scoped.
4. Update the root `README.md` if discoverability changes.
5. If the skill structure changes, make sure `SKILL.md` links to the new material.

## What Goes Where

### `unity-mcp-ui-layout/SKILL.md`

Use this for:

- core operating rules
- trigger-oriented guidance
- reference navigation

Do not overload this file with long examples or repetitive detail.

### `unity-mcp-ui-layout/references/`

Use this for:

- layout rules
- anchor and scaler guidance
- failure patterns
- call recipes
- review checklists

### `examples/`

Use this for:

- realistic user prompts
- scenario walkthroughs
- copyable starting points

### `Platform/`

Use this for:

- service-specific prompt adaptation
- Codex / Google Antigravity / Claude Artifacts packaging

## Good Contribution Examples

- add a new failure pattern that repeatedly appeared in real usage
- add a new example for a common Unity UI task
- improve a platform adapter so the same workflow feels more native there
- tighten a vague rule that often causes unstable layouts

## Changes That Need Extra Care

- changing popup safe-area rules
- changing ownership between layout groups and manual placement
- changing guidance that affects both UGUI and UI Toolkit
- expanding `SKILL.md` without moving details into references

## Validation

Before opening a PR:

- read the changed files once as if you were a first-time user
- make sure new docs are linked from the right entry points
- make sure examples stay aligned with the actual rules
- avoid adding duplicate guidance in multiple places unless it improves discoverability

## PR Guidance

Good PRs for this repo usually:

- explain the real usage problem being solved
- keep the change set focused
- show which file category was chosen and why
- avoid mixing unrelated documentation improvements in one branch
