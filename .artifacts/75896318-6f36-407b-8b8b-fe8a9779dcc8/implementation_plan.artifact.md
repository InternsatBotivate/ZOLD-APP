# Implementation Plan - Centralized Theme Support

This plan outlines the steps to replace hardcoded colors with a centralized theme in the Flutter project, ensuring dark mode matches the provided images while light mode remains unchanged.

## User Review Required

> [!IMPORTANT]
> The dark mode implementation will use a very dark background (`#141414`) with dark grey cards (`#1F1F1F`) to match the provided screenshots. Some headers will retain vibrant gold/silver colors as shown in the images.

## Proposed Changes

### [Component Name] Core Theme

#### [MODIFY] [app_colors.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/core/theme/app_colors.dart)
- Update `backgroundDark` to `#141414`.
- Define `surfaceDark` and `surfaceDarkSecondary`.
- Add semantic colors for specialized cards (Gold/Silver specific backgrounds for dark mode).

#### [MODIFY] [app_theme.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/core/theme/app_theme.dart)
- Update `darkTheme` definition to use the new colors.
- Ensure `ColorScheme` has correct mapping for primary, surface, background, and text colors.
- Update `inputDecorationTheme` and `cardTheme` for dark mode.

### [Component Name] Feature Modules

For each module, replace hardcoded `Color(0x...)` with `Theme.of(context).colorScheme...` or `AppColors` wrapped in theme checks.

#### [MODIFY] [buy_sell_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/buy_sell/views/buy_sell_view.dart)
- Replace background gradients with theme-aware gradients.
- Update cards (Live Rate, Price Breakdown, Purity Card) to use theme colors.
- Update `MetalButton` (if needed) or its usage.

#### [MODIFY] [wallet_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/wallet/views/wallet_view.dart)
- Update Glassmorphism header to look good in dark mode.
- Update Metal cards and breakdown items.
- Update SIP and Goals banners.

#### [MODIFY] [gold_coins_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/gold_coins/views/gold_coins_view.dart)
- Update Scaffold background and AppBar colors.
- Update metal toggle and coin cards.

#### [MODIFY] [goals_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/goals/views/goals_view.dart) (Need to check this file)
- Apply similar theme updates.

#### [MODIFY] [sip_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/sip/views/sip_view.dart)
- Update header gradient and available plans cards.
- Update benefits banner.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure no new issues are introduced.

### Manual Verification
- Verify that switching to Dark Mode in the system settings or profile selector updates the UI correctly.
- Compare the resulting UI with the provided images.
