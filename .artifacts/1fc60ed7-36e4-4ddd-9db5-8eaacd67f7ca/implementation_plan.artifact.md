# Implementation Plan - Fix Gift Gold Module for Dark and Light Mode

This plan details the changes required to make the "Gift Gold" module fully compatible with both dark and light modes by replacing hardcoded colors with theme-based lookups.

## Proposed Changes

### Wallet Module

#### [MODIFY] [gift_gold_bottom_sheet.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/wallet/views/gift_gold_bottom_sheet.dart)
- Replace `Colors.white` with `Theme.of(context).colorScheme.surface` for main containers and chips.
- Replace `Colors.black` with `Theme.of(context).colorScheme.onSurface` for text and primary buttons.
- Replace hardcoded grey colors (e.g., `Colors.grey[100]`, `Colors.grey[500]`) with semantic theme colors like `Theme.of(context).colorScheme.surfaceContainer`, `Theme.of(context).dividerColor`, or `Theme.of(context).hintColor`.
- Use `Theme.of(context).colorScheme.outline` for borders.
- Update `_buildHeader` and `_buildWeightValueInput` to use theme-aware contrast colors.

#### [MODIFY] [gift_gold_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/wallet/views/gift_gold_view.dart)
- Replace hardcoded `Colors.white` in `Scaffold` background and various containers.
- Update `_getMetalColors` to return theme-appropriate background colors (e.g., using `Theme.of(context).colorScheme.surfaceContainer` or semi-transparent brand colors).
- Replace `Colors.black`, `Colors.black54`, and hardcoded grey shades with theme-based text and divider colors.
- Ensure all input fields and buttons follow the app's established theme.

## Verification Plan

### Manual Verification
- Switch between Light and Dark mode in the Android emulator settings.
- Open the "Gift Gold" bottom sheet and verify:
    - Background color matches the theme.
    - Text is legible in both modes.
    - Icons and indicators are visible.
    - Input fields look correct.
    - "Gold" and "Silver" specific styling still looks good against dark/light backgrounds.
- Open the full "Gift Gold" view and perform the same checks.
