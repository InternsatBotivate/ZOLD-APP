# Implementation Plan - Portfolio UI/UX & Keyboard Response Fix

This plan addresses the crash in the Portfolio module and improves the UI/UX to match the Next.js frontend, ensuring full keyboard responsiveness.

## User Review Required

> [!IMPORTANT]
> - **Crash Fix**: I will replace the problematic `capitalizeFirst` extension calls with a safer implementation to prevent the `NoSuchMethodError`.
> - **Next.js Parity**: The "My Coins" section and the main Portfolio header will be redesigned to match the Next.js visual style (Glassmorphism, specific card themes).
> - **Keyboard Responsiveness**: All bottom sheets (Gift, Delivery) will be updated to handle the software keyboard properly, preventing content from being obscured.

## Proposed Changes

### Portfolio Module

#### [MODIFY] [wallet_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/wallet/views/wallet_view.dart)
- Fix `capitalizeFirst` crash in `_buildCoinItem`.
- Redesign `_buildCoinItem` to match the Next.js card style (gold/silver gradients, float effect, action buttons).
- Update `_buildGlassmorphismOverview` to better align with the Next.js header.
- Ensure the main view handles safe areas and scrolling properly.

#### [MODIFY] [gift_gold_bottom_sheet.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/wallet/views/gift_gold_bottom_sheet.dart)
- Wrap the body in `SingleChildScrollView` to allow scrolling when the keyboard is open.
- Add padding based on `MediaQuery.of(context).viewInsets.bottom`.
- Fix `capitalizeFirst` usage.

#### [MODIFY] [coin_delivery_bottom_sheet.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/wallet/views/coin_delivery_bottom_sheet.dart)
- Wrap the body in `SingleChildScrollView`.
- Add padding for keyboard responsiveness.
- Fix `capitalizeFirst` crash in the coin details section.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure code correctness and no regression.

### Manual Verification
- Verify the Portfolio screen renders without crashing.
- Test "Gift" and "Delivery" bottom sheets with the keyboard open to ensure text fields remain accessible.
- Compare the visual style of the coin cards and portfolio header with the provided Next.js reference.
