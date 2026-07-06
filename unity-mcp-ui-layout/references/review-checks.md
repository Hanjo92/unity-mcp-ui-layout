# Unity UI Review Checks

Use this guide at the end of a `unity-mcp` UI task before calling the result complete.

This is a final review pass, not a discovery checklist. The goal is to catch issues that often survive basic implementation.

For ambiguity handling and candidate review policy, use `review-gates-and-assumptions.md`.

## 0. Layout Snapshot Intake Check

Use this check when the task edited an existing Unity UI screen or built mockup-driven UI inside an existing scene.

For the full expected intake shape, use `layout-snapshot-contract.md`.

Ask:

- Was a layout snapshot captured before structural edits, or were equivalent smaller MCP calls used?
- Did the intake identify active scene, active UI root, UI stack, Canvas or UIDocument settings, root layout owners, screenshot resolution, screenshot path, and console state?
- Were anchors, pivots, bounds, layout groups, masks, scroll owners, prefab links, and key text overflow/wrap settings inspected for the target region?
- Were referenced sprites, materials, TMP styles, prefabs, and shared asset markers inspected when asset-aware mode was active?
- Were unknown fields recorded explicitly instead of guessed or silently skipped?
- If the unified snapshot tool was unavailable, did the fallback still gather enough evidence to choose stack, change mode, parent ownership, and verification target?

If the active root, UI stack, parent ownership, screenshot frame, or console state is unknown, resolve that gap before claiming the UI work is complete.

## 1. Composition Check

Ask:

- Does the screen match the intended composition from the mockup or task description?
- Are the major regions in the correct places?
- Is the visual hierarchy obvious at a glance?

If the answer is no, return to parent containers and region structure before changing polish details.

## 2. Alignment Check

Ask:

- Are corner widgets actually attached to the intended corner?
- Are bars aligned cleanly to the top, bottom, left, or right edges?
- Are centered elements truly centered in their intended parent?
- Do sibling groups share common visual baselines?
- Are the major top-level regions grouped by anchor ownership before leaf-level adjustments?

Look for subtle drift, especially in HUD clusters and popup headers or footers.

## 3. Scaling Check

Ask:

- Does the UI still look correct at the target resolution?
- Does it remain acceptable at one alternate aspect ratio?
- Are size changes caused by `CanvasScaler`, anchors, or container logic behaving as expected?
- If a mockup image was provided, did we use the mockup's native resolution or the explicitly stated target resolution deliberately instead of falling back to an arbitrary default?
- If this is mobile-first work, did we verify a taller phone profile and a wider mobile or tablet profile where appropriate?

If only one resolution works, the implementation is not done yet.

## 4. Ownership Check

Ask:

- Does each region have a clear parent that owns layout?
- Is there a clear layer stack from screen shell to regions, repeated groups, runtime leaves, and decorative image layers?
- Does the Unity Transform tree or RectTransform tree match that layer stack instead of a flat set of visual fragments?
- Does each repeated group have a clear layout owner?
- Were repeated structures turned into reusable prefabs or reusable layout blocks where appropriate?
- Are child offsets being used only for local adjustments rather than structural compensation?
- If this is UI Toolkit, do containers own flex direction, width, overflow, and scroll behavior instead of leaf overrides?
- If this is a scroll-heavy UI, is there one clear scroll owner, one content container, and one reusable repeated-item pattern?

If many children carry unique offsets, the structure is probably still too fragile.

## 4A. Layer And Transform Tree Check

Use this check when a mockup, screenshot, reference image, or UI 시안 drove the implementation.

Ask:

- Was a layer pass done before object creation?
- Does every layer name its parent owner, runtime responsibility, and keep-whole or split reason?
- Are major visual layers mapped to a parent-owned transform hierarchy rather than copied as unrelated siblings?
- Are reusable groups represented by prefab roots or reusable layout block roots?
- Are decorative image layers kept as single image nodes unless interaction, animation, dynamic content, or adaptive layout requires splitting?
- 레이어 구조 and 트리 구조가 Unity `Transform`/`RectTransform` hierarchy에서 읽히는가?

If the transform tree cannot be read without opening every leaf, return to decomposition before polishing visuals.

## 4B. Item Rect And Size Match Check

Use this check when a mockup, screenshot, reference image, or UI 시안 drove item placement, icon/card/slot/button sizing, or prefab creation.

Ask:

- Did each split runtime or repeated item record a source rect from the mockup image?
- Was that source rect converted to a normalized rect before Unity offsets, preferred sizes, or layout values were chosen?
- Is the implemented size controlled by the parent owner, layout group, anchor rule, or named fit mode rather than unrelated full-screen offsets?
- Are major item widths, heights, and aspect ratios still visually close to the mockup after the target-resolution mapping?
- Is any item rect drift visible in the final screenshot: cropped icon, stretched card, compressed slot, clipped badge, or oversized button?
- Does every mockup-derived crop have an asset/crop plan, and did existing sprites or prefabs stay preferred when available?
- Were decorative sub-parts left inside a single image unless runtime behavior required splitting?

If item rect drift is visible, fix parent ownership or fit mode before pixel nudging leaf offsets.

## 4C. Candidate Ledger Review Check

Use this check when raster mockup analysis produced a candidate item ledger before item-level UI rect planning.

Ask:

- Did the ledger stay an advisory candidate set rather than a final manifest?
- Does every candidate include confidence band, evidence, suggested role, crop padding, 9-slice candidate status, and review decision?
- Did accepted candidates pass a human review gate before becoming item-level UI rects, Unity objects, prefab children, or mockup-derived crops?
- Were held candidates left as notes instead of silently becoming objects?
- Were rejected candidates prevented from creating Unity nodes or crop assets?
- Was any candidate over-decomposition visible, such as decorative seams becoming fake children without runtime responsibility?
- If a structured export also existed, did the export still own hierarchy while the raster candidate ledger stayed advisory?

If candidate over-decomposition is present, reject or hold the candidate and return to layer ownership before item sizing.

## 4D. Assumption And Review Gate Check

Use this check when ambiguity was handled during mockup-driven UI work.

Ask:

- Were hard blockers confirmed before editing, such as unknown UI stack in a mixed-stack project, unclear target screen, destructive shared-base changes, ambiguous repair versus rebuild scope, or missing required runtime behavior?
- Were soft ambiguities handled with named assumptions, such as mockup native resolution fallback, layout-only placeholder assets, non-destructive spacing choices, or content-length headroom?
- If no human review was available, were low-confidence candidates held while parent structure was built first?
- Were held and rejected candidates prevented from creating Unity objects, prefab children, or crop assets?
- Did the final response summarize assumptions, candidate decisions, and remaining review risks?

If assumptions or candidate decisions are missing from the final report, add them before calling the task complete.

## 5. Asset Granularity Check

Ask:

- Did we keep likely single-image regions as single image resources?
- Was any decorative area split into fake widgets without a runtime need?
- Do separate elements exist only where interaction, animation, text, or adaptive layout requires them?
- Were repeated mockup regions promoted into reusable blocks where appropriate instead of being manually rebuilt?
- If a region was split into item-level UI rects, does each split have a source rect, normalized rect, split reason, and asset/crop plan?
- If asset-aware mode was active, did we follow a sensible discovery order instead of jumping straight to placeholders?

If the UI was decomposed more than the runtime behavior needs, simplify it before shipping.

## 6. Asset Type Check

Ask:

- Are ordinary static UI visuals using `Image` and sprite-backed assets instead of `RawImage`?
- If a `RawImage` exists, is there a clear runtime texture source such as `RenderTexture`, video, or generated texture data?
- Did any static icon, panel, slot, or button art bypass the sprite workflow without a good reason?

If the answer is no, convert the asset usage back toward the normal sprite workflow before calling the UI done.

## 7. Asset Naming and Placement Check

Ask:

- Were newly created or promoted assets given names that reveal role clearly?
- Are shared assets stored in shared UI folders and screen-owned assets stored near the screen that owns them?
- Are placeholder assets still visibly marked as provisional instead of looking like stable shared assets?
- Would another agent be able to rediscover the asset family without guessing?

If the answer is no, rename or relocate the assets before calling the UI done.

## 8. Text Check

Ask:

- Is any text clipped, wrapping incorrectly, or causing row expansion?
- Are button labels visually balanced?
- Would the current layout likely survive slightly longer strings?
- Was line behavior chosen deliberately for major text roles instead of left to defaults?
- Are counters, currencies, and dynamic values given enough room for realistic growth?
- Did we solve the text issue by fixing layout first instead of immediately shrinking fonts?
- If this is UI Toolkit, are wrap and overflow behaviors explicit for important text regions instead of being left implicit?

Text problems should be treated as layout problems first, not only font-size problems.

## 9. Interaction Area Check

Ask:

- Are buttons, tabs, and actionable rows placed where users expect them?
- Are close buttons and footer actions clearly reachable?
- Do overlays and dimmers cover the correct area?
- If this is a scroll-heavy UI, do headers, filters, or footer actions stay outside the scrolling region when they are supposed to remain fixed?

This check is especially important for popup and mobile layouts.

## 10. Safe Area Check

Ask:

- Are top and bottom edge controls inside the safe area?
- Is safe-area ownership applied only once at the correct container?
- For popups, is safe area owned by `PopupRoot` rather than the dimmer or individual children?
- If the mockup was notch-agnostic, did we reinterpret edge spacing inside the safe area instead of copying raw top and bottom pixels?
- Did the safe area still behave correctly on the taller-phone verification profile?

If safe area works only because several children have manual offsets, the design still needs cleanup.

## 11. Visual Consistency Check

Ask:

- Are gaps and padding visually even?
- Are panel sizes, border spacing, and section rhythms consistent?
- Does the layout feel deliberate instead of patched together?

This is where hand-placed designs usually reveal themselves.

## 12. Design System Check

Use this check when the task included `DESIGN.md`, design tokens, a Tailwind theme, or another design-system source.

Ask:

- Did visible colors, typography, spacing, radius, and component states trace back to the design source or an existing project equivalent?
- Were token values treated as the concrete style contract and prose treated as intent?
- Are button, card, input, badge, and list states mapped through reusable styles instead of local one-off values?
- Were known text/background pairs checked for readable contrast?
- Did the work avoid introducing style drift outside the requested repair scope?
- Were any deviations from the design source named and justified?
- If a structured export also existed, did the style source stay in the role of visual contract instead of replacing hierarchy ownership decisions?

If the answer is no, revisit the design-source mapping before calling the UI done.

## 13. Structured Export Check

Use this check when the task included Stitch HTML/CSS, Figma node-tree JSON, component-tree exports, or another hierarchy-bearing export artifact.

Ask:

- Was the export normalized into semantic parent containers instead of copied node-for-node?
- Were repeated cards, rows, tabs, or list items promoted into one reusable unit where the export clearly repeated them?
- Did flex, auto-layout, or overflow signals become container ownership rules instead of many leaf-level offsets?
- For UGUI, did regular repeated siblings use `HorizontalLayoutGroup`, `VerticalLayoutGroup`, `GridLayoutGroup`, and targeted `LayoutElement` overrides unless an irregular manual-placement exception was named?
- Were anchors and pivots chosen from UI role, constraints, growth, or motion intent instead of defaulting to the export coordinate origin?
- Were absolute or overlay-like children isolated deliberately instead of leaking into the main flow layout?
- If a style source also existed, did the export still own hierarchy decisions?
- Were missing assets, unsupported CSS features, or unresolved node types surfaced as fallback notes instead of silently guessed?

If the answer is no, revisit the export-to-Unity mapping before calling the UI done.

## 14. Scope Check

Ask:

- Did the task stay inside the requested region?
- Were unrelated screens or widgets changed unnecessarily?
- Was the original style preserved when the request was a repair?
- Did we stay in the correct operating mode: bounded repair for fixes, or build mode for true greenfield work?
- If an existing shared asset was edited directly, was that scope truly justified?
- If a shared asset was edited directly, was at least one additional known usage checked first where practical?

If the answer is no, narrow the change before shipping it.

## 15. Final Go/No-Go Rule

Do not call the UI complete unless:

1. the composition is correct
2. the layout survives at least one alternate aspect ratio
3. no obvious clipping or overlap remains
4. safe area ownership is correct where relevant
5. the structure does not depend on arbitrary pixel corrections
6. any provided design-system source is still respected where applicable
7. any provided structured export source was normalized into stable hierarchy instead of copied literally
