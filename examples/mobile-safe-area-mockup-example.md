# Mobile Safe Area Mockup Example

Use this example when the provided mockup does not visibly account for a notch or home indicator, but the real target is a mobile safe-area layout.

## Example Prompt

```text
Use $unity-mcp-ui-layout to build this mobile popup from the attached mockup.
Treat the mockup as a composition reference, not as raw unsafe edge geometry.
Apply safe-area ownership to PopupRoot, remap top and bottom spacing inside the safe area, and verify both portrait and landscape.
Keep the dimmer full-screen, but keep popup content local to PopupRoot.
```

## Why This Works

- It tells the agent that the mockup is composition-first.
- It prevents raw top and bottom pixel copying.
- It forces safe-area ownership to stay on the correct parent.

## Suggested References

- `D:\UnityUICreater\unity-mcp-ui-layout\references\mockup-safe-area-mapping.md`
- `D:\UnityUICreater\unity-mcp-ui-layout\references\ugui-mobile-safe-area.md`
- `D:\UnityUICreater\unity-mcp-ui-layout\references\ugui-popup.md`
