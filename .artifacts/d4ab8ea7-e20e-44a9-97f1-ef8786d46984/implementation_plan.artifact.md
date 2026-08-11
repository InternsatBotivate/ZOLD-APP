# Implementation Plan - Fix Dark/Light Mode for Delivery and Buy Coins Modules

This plan aims to refactor the Delivery and Buy Coins modules to properly support both dark and light modes by replacing hardcoded colors with theme-aware colors and styles.

## Proposed Changes

### [Delivery Module]

#### [MODIFY] [deliveries_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/wallet/views/deliveries_view.dart)
- Replace hardcoded `Colors.white`, `Colors.black`, and `Colors.grey` with `Theme.of(context).colorScheme` properties.
- Update `Scaffold` background color to `Theme.of(context).scaffoldBackgroundColor`.
- Update `AppBar` background and icon colors to use theme defaults.
- Update `_buildResponsiveCoinsGrid` to use theme-aware colors for container background and borders.
- Update `_buildTabs` and `_buildTabItem` to use theme colors for selected/unselected states.
- Update `_buildDeliveryCard` and `_buildStatusBadge` to use theme-aware background and text colors.
- Update `_buildSkeletonLoader` to use theme-appropriate shimmer colors.

#### [MODIFY] [coin_delivery_bottom_sheet.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/wallet/views/coin_delivery_bottom_sheet.dart)
- Update `Container` background color to `Theme.of(context).colorScheme.surface`.
- Update `_buildHeader` to use `Theme.of(context).colorScheme.surfaceContainerHighest` or similar for background, and theme text colors.
- Update `TextField` `fillColor` to be theme-aware.
- Update `ElevatedButton` styles to use theme-defined `primaryGold` or `primary` colors.
- Ensure all step builders (`_buildDetailsStep`, `_buildPartnerStep`, `_buildConfirmStep`) use theme-aware colors for cards and text.

### [Buy Coins Module]

#### [MODIFY] [gold_coins_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/gold_coins/views/gold_coins_view.dart)
- Replace `backgroundColor: const Color(0xFFF9F9F9)` with `Theme.of(context).scaffoldBackgroundColor`.
- Update `AppBar` to use theme defaults.
- Update `_buildMetalToggle` and `_buildTabItem` to use theme-aware colors for text and dividers.
- Update `_buildHeader` to use theme text colors.
- Update `_buildLiveRateBadge` to use theme-aware background and border colors that adapt to dark mode.
- Update `_buildShimmerGrid` and `_buildErrorState` to use theme colors.

#### [MODIFY] [coin_card.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/gold_coins/widgets/coin_card.dart)
- Update card background to `Theme.of(context).colorScheme.surface`.
- Update borders and shadows to be less harsh in dark mode.
- Update badge colors (`Popular`, purity badge) to use theme-aware tints.
- Update text colors to use `Theme.of(context).colorScheme.onSurface` and related text theme styles.
- Update `_buildAddToCartButton` and `_buildQuantityControl` to use theme-consistent colors.

## Verification Plan

### Manual Verification
- Toggle between Light and Dark mode in the app.
- Verify "Deliveries" screen:
    - Check background color.
    - Check coin grid cards.
    - Check tabs (Active/Completed/Cancelled).
    - Check delivery status cards and badges.
    - Check "Request Delivery" bottom sheet.
- Verify "Buy Coins" screen:
    - Check background color.
    - Check metal toggle (Gold/Silver).
    - Check live rate badge.
    - Check coin cards (Gold and Silver versions).
    - Check "Add to Cart" and quantity controls.
- Ensure all text is legible in both modes.
- Ensure no "white flashes" or "black text on black background" issues.
