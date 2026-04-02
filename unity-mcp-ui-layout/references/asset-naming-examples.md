# Asset Naming and Folder Examples

Use this guide together with `asset-naming-and-folders.md` when you want concrete before/after examples instead of only abstract rules.

## 1. Shared vs Screen-Owned Before/After

### Bad

The structure below makes reuse hard to reason about:

```text
Assets/UI/Inventory/
  Button_New.prefab
  CommonButton_Copy.prefab
  GoldIcon.png
  PopupBlur.mat
```

Problems:

- a likely shared button is buried inside one screen folder
- the names do not reveal scope clearly
- one asset looks copied rather than intentionally promoted
- a common visual treatment appears screen-owned by accident

### Better

```text
Assets/UI/Common/Prefabs/Buttons/
  UI_Common_Button_Primary.prefab

Assets/UI/Common/Sprites/Icons/
  UI_Common_Icon_Gold.sprite

Assets/UI/Common/Materials/
  UI_Common_BlurOverlay.mat

Assets/UI/Screens/Inventory/Prefabs/
  UI_Inventory_ActionBar.prefab
```

Why this is better:

- shared assets read as shared
- screen-owned assets stay near the screen that owns them
- names reveal role and scope immediately

## 2. Bad Names vs Better Names

| Bad | Better | Why |
|---|---|---|
| `Button_New` | `UI_Common_Button_Primary` | role and scope are explicit |
| `InventorySlot_Copy` | `UI_Inventory_Slot` | no copy-history noise |
| `TopLeft_1920_Button` | `UI_HUD_QuickSlotButton` | meaning instead of coordinates |
| `Popup_v3_really_final` | `UI_Settings_PopupRoot` | stable ownership and role |
| `GoldIcon2` | `UI_Common_Icon_Gold` | reusable naming family |

## 3. Variant Folder Example

Use a structure like this when one shared base prefab has a real family of variants:

```text
Assets/UI/Common/Prefabs/Buttons/
  UI_Common_Button_Primary.prefab
  Variants/
    UI_Common_Button_Primary_Selected.prefab
    UI_Common_Button_Primary_Disabled.prefab
    UI_Common_Button_Primary_Danger.prefab
```

This works well when:

- the base contract is stable
- variants differ in controlled local ways
- the family is large enough to justify a `Variants` folder

## 4. Wrapper vs Variant Example

### Variant case

```text
Assets/UI/Common/Prefabs/RewardCard/
  UI_Common_RewardCard.prefab
  Variants/
    UI_Common_RewardCard_Epic.prefab
```

Use this when the base card structure is right and only scoped visuals or optional sections differ.

### Wrapper case

```text
Assets/UI/Common/Prefabs/RewardCard/
  UI_Common_RewardCard.prefab

Assets/UI/Screens/Inventory/Prefabs/
  UI_Inventory_RewardCardHost.prefab
```

Use this when the screen needs extra surrounding layout or screen-owned composition that should not pollute the shared base.

## 5. Placeholder Example

### Bad

```text
Assets/UI/Common/Sprites/
  GoldIconTemp.png
```

This quietly makes a placeholder look like a permanent shared asset.

### Better

```text
Assets/UI/Screens/Inventory/Placeholders/
  UI_Inventory_Placeholder_ItemIcon.sprite
```

This keeps provisional work visibly provisional and easy to replace later.

## 6. Promotion Example

A repeated screen-owned block can start local and later be promoted.

### Early stage

```text
Assets/UI/Screens/Inventory/Prefabs/
  UI_Inventory_ItemCard.prefab
```

### After real reuse becomes visible

```text
Assets/UI/Common/Prefabs/ItemCard/
  UI_Common_ItemCard.prefab
  Variants/
    UI_Common_ItemCard_Selected.prefab
```

The important point is:

- do not promote too early
- but once a pattern is clearly shared, rename and relocate it deliberately

## 7. Review Questions

Ask:

- If a new teammate opened this folder tree, would they know what is shared?
- If a variant exists, is it grouped clearly with its base family?
- If the asset is still local to one screen, does the path reveal that?
- Are placeholders visibly provisional instead of looking like final design-system assets?

If the answer is no, clean up naming and placement before the pattern spreads.
