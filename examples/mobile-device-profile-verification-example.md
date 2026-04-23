# Mobile Device Profile Verification Example

Use this example when a mobile-first UI should be verified across device shapes before it is called stable.

## Scenario

- A mobile UI already exists or has just been built.
- One portrait screenshot looks acceptable, but the product has not ruled out taller phones, wider mobile layouts, or tablet-like profiles.
- The task is verification and targeted repair, not a full rebuild.

## Example Prompt

```text
Use $unity-mcp-ui-layout to verify this mobile-first UI across device profiles before calling it complete.
Treat this as a verification pass, not a rebuild.
Identify the active UI stack first and do not mix UGUI and UI Toolkit in one change unless I explicitly ask for a bridge.

Use the project's main target profile as the baseline.
If no exact device list is specified, verify:
1. the standard phone or main target profile
2. one taller phone profile
3. one wider mobile or small tablet profile when the product may support it

If the product is tablet-capable, include one explicit tablet-like verification pass.
Do not assume portrait-only unless the product or task explicitly says so.
For each profile, inspect the result and report changes in anchors, safe-area pressure, spacing, clipping, scroll or content fit, text fit, and panel balance.
Apply only the smallest structural fix needed for a verified issue, then repeat the affected profile check and the main target check.
```

## Why This Works

- It turns "looks good on mobile" into named verification coverage.
- It keeps the main target as the baseline instead of comparing only alternate profiles.
- It catches tall-phone safe-area pressure and wider-profile spacing drift.
- It prevents portrait-only assumptions from being made silently.
- It keeps fixes targeted to verified profile failures.

## Decision Checklist

- Was the main target profile checked first?
- Was one taller phone profile checked?
- Was one wider mobile or small tablet profile checked, or explicitly ruled out by product scope?
- Was a tablet-like pass included when tablet support matters?
- Were anchors, spacing, clipping, text fit, scroll fit, safe-area behavior, and panel balance compared across profiles?
- Did any fix get rechecked on the affected profile and the main target profile?

## Suggested References

- [mobile-device-profiles.md](../unity-mcp-ui-layout/references/mobile-device-profiles.md)
- [review-checks.md](../unity-mcp-ui-layout/references/review-checks.md)
- [prompt-patterns.md](../unity-mcp-ui-layout/references/prompt-patterns.md)
- [ugui-mobile-safe-area.md](../unity-mcp-ui-layout/references/ugui-mobile-safe-area.md)
- [ui-toolkit-layout-rules.md](../unity-mcp-ui-layout/references/ui-toolkit-layout-rules.md)
