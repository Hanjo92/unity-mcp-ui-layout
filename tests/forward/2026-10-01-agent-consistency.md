# Agent consistency forward evaluation — 2026-10-01

This is a recorded reasoning evaluation, not Unity execution proof and not a shell-invoked LLM test. Two independent fresh-context evaluators (`/root/forward_a`, `/root/forward_b`) received the same requests and raw facts below. They read the skill and relevant references only; they were not given expected answers or the other evaluator's output. They were prohibited from editing files, invoking Unity, and inspecting tests.

## Inputs supplied to both evaluators

A. User: “현재 선택된 SettingsUIDocument의 설정 행 간격을 수정해줘. 다시 승인받지 말고 진행해. 세로 전용이야.” Facts: Unity 2022.3; selected SettingsUIDocument owns linked Settings.uxml/Settings.uss; unrelated Canvas exists; screen-local USS controls row spacing; no scripts or runtime behavior changes; source editing available, screenshots unavailable; main frame 1080x1920.

B. User: “UI Toolkit으로 반복 퀘스트 행 만들어줘. 아이콘은 런타임에 바뀌어. 사람 검토 기다리지 말고 진행해.” Facts: raster-only mockup 1920x1080; parent QuestScreen/QuestList/QuestRow source origin (192,216); clear icon bounds (230,250,96,96); uncertain soft backdrop glow; known baked decorative hairline; target 1280x720; no Unity bridge, source creation available. Evaluators were asked for candidate decisions, coordinate values, leaf ownership, alternate ratio, next actions and completion status.

C. Same facts as B, but user adds: “후보는 내가 승인한 다음에만 오브젝트로 만들어.” No approval received.

## Initial observed results

| Decision | Evaluator A | Evaluator B |
| --- | --- | --- |
| A routing/scope | UI Toolkit, repair, local USS, short record | Same |
| A confirmation | Proceed on reversible spacing assumption | Same |
| A verification | 1080x1920 and 810x1920, portrait only | Same |
| A verdict after source edit | implemented_unverified | Same |
| B candidates | Icon accept/high/agent; glow hold; hairline reject | Same |
| B normalized icon | (0.11979167, 0.23148148, 0.05, 0.08888889) | Same within rounding |
| B parent-local source rect | (38, 34, 96, 96) | Same |
| B item node | QuestScreen/QuestList/QuestRow/Icon | Same |
| B alternate | 960x720 | Same |
| B behavior | Runtime icon update is required; inspect owner/version | Same |
| B evidence limits | Missing other bounds and host/version; no fabricated plan/runtime pass | Same |
| C candidate promotion | Wait for actual user approval | Same |
| C ledger representation | “proposed accept” without exact enum | Explicit hold plus acceptance recommendation |
| B scrolling | No asserted scroll requirement | Suggested a scroll owner without overflow evidence |

The first pass exposed two remaining ambiguities, rather than proving universal agreement. The contract was then amended to require `hold`/`agent` while explicit human approval is pending, and to require request or content/overflow evidence before adding scrolling.

## Follow-up observations

Both evaluators independently reread the updated execution contract and answered the same bounded follow-up about C's exact ledger fields and B's scroll requirement. Both returned:

```yaml
review_decision: hold
review_source: agent
# decision_note recommends accepting the clearly bounded dynamic icon,
# records pending user approval, and prohibits item/asset promotion until then.
```

Both stated that repeated rows alone do not require scrolling. Their natural-language notes differed, while the enum, permission boundary, and implementation decision matched.

## Limitations

- These were hypothetical requests with supplied observations, not visual perception tests or actual Editor mutations.
- The two initial runs were independent; follow-ups retained each evaluator's own earlier context. The follow-up is not described as a new full clean-context run.
- This run exercises UI Toolkit routing, repair/build proportionality, candidate review, source/target geometry and unavailable verification. UGUI plan semantics are covered by local validator regressions, not live UGUI implementation here.
- No claim is made about every model, cross-platform rendering, byte-identical assets, or future outcomes. Preserve this historical record; rerun the prompts for changed policies instead of changing the observations.

## Contract fingerprints after the corrections

- `unity-mcp-ui-layout/SKILL.md`: `7b1d8282f9565d07528aa32ce17ff4ccbad8670477c8c325899572b905ca6348`
- `unity-mcp-ui-layout/references/execution-contract.md`: `ff28173f318c67d1527a33efedc2aeeed025e7b9ca3bdb87de00508e0a8a4b67`
- `unity-mcp-ui-layout/references/review-gates-and-assumptions.md`: `b89f97202c09f97e0d51b8e48d78c7a9d503590aa6641bc8e7812daa73655e73`

## Integration note

The recorded forward runs above preceded rebasing this change onto remote main `291e3e7`. Integration preserved the newer UI-planning, image-generation, executor-capability, and localized README guidance. The fingerprints identify the evaluated version, not the later integrated tree. Local regression and documentation checks were rerun after integration; the earlier agent observations are not represented as a fresh evaluation of the merged version.
