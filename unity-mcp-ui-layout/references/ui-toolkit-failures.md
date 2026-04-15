# UI Toolkit Failure Patterns

Use this guide when a UI Toolkit screen technically renders but still feels fragile, inconsistent, or overfit to one width.

This document is symptom-first so it is easier to use during repair work.

## 1. One Inline Fix Breaks Another Region

### Typical symptoms

- changing one element width breaks sibling balance
- one local margin fix shifts another section unexpectedly
- a small style tweak improves one screen width but breaks another

### Likely causes

- container ownership is weak
- too many inline overrides exist
- the screen layout intent lives in leaves instead of containers

### Fix direction

- move layout ownership back into containers
- convert repeated overrides into USS classes
- remove local patches that duplicate container intent

## 2. The Screen Works at One Width but Collapses When Narrower

### Typical symptoms

- side panels collapse too early
- one column crushes another
- text suddenly pushes buttons or rows out of shape

### Likely causes

- no explicit min or max width decisions
- `flex-grow` relationships are implicit or conflicting
- wrap and overflow behavior were never decided

### Fix direction

- decide which region should compress first
- add deliberate min or max width rules where needed
- decide whether text wraps, truncates, or triggers scroll behavior

## 3. Scroll Ownership Is Unclear

### Typical symptoms

- the wrong region scrolls
- nested scroll containers feel unstable
- content disappears or clips inside panels

### Likely causes

- multiple nested containers are trying to own overflow
- screen structure does not define a clear scroll boundary
- one region is expected to expand and scroll at the same time
- the content container and repeated row structure were never separated cleanly

### Fix direction

- choose one deliberate scroll owner
- simplify nested overflow behavior
- move overflow responsibility higher or lower until the ownership is obvious
- keep one content container inside the scroll owner and normalize repeated rows into one reusable structure

## 4. Text Fixes Keep Becoming Font Tweaks

### Typical symptoms

- labels keep shrinking to fit
- one width works only because text got smaller
- long labels break buttons, tabs, or inspector rows

### Likely causes

- text role behavior is implicit
- width ownership is unclear
- font-size changes are compensating for missing layout decisions

### Fix direction

- decide wrap, truncate, or growth behavior first
- stabilize parent width and sibling layout first
- use font changes only after the structure is already reasonable

## 5. The Visual Tree Feels Flat but the Styles Feel Overcomplicated

### Typical symptoms

- too much layout meaning is encoded in classes and local overrides
- related widgets have no meaningful grouping container
- debugging the screen requires checking many unrelated elements

### Likely causes

- structure was under-modeled
- style was asked to do the job of hierarchy
- grouping containers were skipped too early

### Fix direction

- reintroduce meaningful grouping containers
- let the tree reveal screen regions clearly
- keep USS focused on repeatable style, not missing hierarchy

## 6. Reusable UI Toolkit Patterns Still Behave Like One-Off Layouts

### Typical symptoms

- repeated rows still need local patching
- one panel class almost works but each instance needs exceptions
- style drift grows across similar screens

### Likely causes

- no stable base class or container pattern exists
- repeated structure is not actually represented as a reusable pattern
- the screen evolved through one-off fixes

### Fix direction

- extract a clearer reusable container or class pattern
- normalize spacing, text role, and alignment rules
- reduce per-instance exceptions

## 7. Quick Recovery Strategy

When UI Toolkit work starts drifting:

1. inspect the visual tree again
2. identify the container that should own the failing behavior
3. reduce leaf-level overrides
4. make text overflow behavior explicit
5. verify one narrower width before declaring success
