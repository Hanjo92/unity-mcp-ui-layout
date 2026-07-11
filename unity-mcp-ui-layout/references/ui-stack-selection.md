# UI Stack Selection

Use this contract before treating a Unity UI request as a prefab or Canvas task. It selects the implementation stack without prescribing a build workflow.

## Required Intake Evidence

Record these fields before stack-specific work begins:

```yaml
target_surface: runtime | editor
unity_version: string | unknown
unity_version_evidence: Unity ProjectVersion.txt, Editor About dialog, or inspected project metadata
selected_target: string | unknown
selected_ui_root: string | unknown
```

`target_surface` distinguishes player-facing runtime UI from editor tooling. Record Unity version evidence even when the version is unknown; the evidence source or absence must be explicit.

## Selection Precedence

Apply this exact precedence, stopping at the first conclusive evidence:

1. **explicit user instruction**
2. **named target or selected UI root**
3. **existing screen ownership**
4. **project conventions and nearby reusable assets**
5. **clarify only when evidence remains mixed**

An explicit request for UI Toolkit, or a target owned by `UIDocument`, `UXML`, `USS`, `VisualElement`, or `PanelSettings`, selects UI Toolkit before prefab or Canvas defaults. An explicit UGUI request, or a target owned by `Canvas`, `RectTransform`, `CanvasScaler`, `LayoutGroup`, `Image`, or `TextMeshProUGUI`, selects UGUI.

Use `target_surface` as part of the evidence: runtime UI commonly belongs to a scene `UIDocument` or Canvas, while editor tooling may use editor UI Toolkit roots. Do not infer stack solely from the target surface.

## Evidence Discipline

- Preserve the selected target and UI root in intake metadata so later calls can be checked against the routing decision.
- Existing screen ownership outweighs general project habits. Do not migrate an owned screen as a side effect of a layout task.
- Project conventions and nearby reusable assets break ties only when higher-precedence evidence is absent.
- Installed-package presence alone is not decisive. A project may have UI Toolkit packages without an applicable UI Toolkit target, or retain UGUI screens alongside them.
- If the evidence remains mixed after applying the precedence order, ask the user to identify the target stack before editing.

This contract only selects the stack. Follow the selected stack's existing layout and verification guidance after intake.
