# Walkthrough - Dark/Light Mode Fix for Delivery & Buy Coins

I have refactored the Delivery and Buy Coins modules to fully support both dark and light modes. Hardcoded colors have been replaced with theme-aware properties from the `ThemeData` and `ColorScheme`.

## Changes Made

### Delivery Module
- **[DeliveriesView](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/wallet/views/deliveries_view.dart)**:
    - Updated background and AppBar to use theme colors.
    - Refactored coin inventory grid cards with `surfaceContainer` and theme-aware text.
    - Updated delivery status cards and badges to use theme colors (e.g., `success`, `error`, `warning` with alpha tints).
    - Refactored tab navigation to correctly highlight the active tab in dark mode using `surfaceContainerHighest`.
    - Fixed skeleton loader colors for dark mode.
- **[CoinDeliveryBottomSheet](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/wallet/views/coin_delivery_bottom_sheet.dart)**:
    - Updated the entire flow (Details, Partner, Confirm) to use theme-aware backgrounds, card styles, and input decorations.

### Buy Coins Module
- **[GoldCoinsView](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/gold_coins/views/gold_coins_view.dart)**:
    - Updated Scaffold background and AppBar.
    - Refactored metal toggle (Gold/Silver) to use theme-aware text and selection indicators.
    - Updated "Live Rate" badge to adapt its background and border based on the current theme and metal type.
    - Fixed empty and error state UI components.
- **[CoinCard](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/gold_coins/widgets/coin_card.dart)**:
    - Updated card background to `surface` and border colors to be less harsh in dark mode.
    - Refactored all badges (Popular, 24K/999) to use theme-consistent tints.
    - Updated "Add to Cart" and quantity control buttons to use theme colors, ensuring they stand out correctly in both modes.

## Verification
- Verified that all text is legible (correct contrast) in both light and dark modes.
- Ensured that interactive elements (buttons, tabs, toggles) have clear visual feedback for their states.
- Checked that cards and containers use appropriate surface colors that depth-match the background.
