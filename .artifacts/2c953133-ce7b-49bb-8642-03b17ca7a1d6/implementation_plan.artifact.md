# Implementation Plan - Fix Buy Silver Button Color in Dark Mode

The goal is to fix the "Buy Silver" (and "Pay") button color in dark mode. Currently, it uses the theme's `secondary` color, which is a maroon accent, making the button look reddish instead of silvery. I will update the `MetalButton` widget to use a silver gradient for the silver metal type in dark mode.

## User Review Required

> [!NOTE]
> The button will now have a consistent silver look in dark mode, matching the silver accents used elsewhere in the "Buy/Sell" module.

## Proposed Changes

### Buy/Sell Module

#### [MODIFY] [metal_button.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/buy_sell/views/widgets/metal_button.dart)

- Update the dark mode gradient for the silver state (`isGold = false`) to use silver/slate colors instead of `theme.colorScheme.secondary`.
- Update the dark mode shadow color for silver to match the new gradient.

I will use the following silver colors, consistent with `buy_sell_view.dart`:
- `Color(0xFFB0B8C6)` (Light Silver)
- `Color(0xFF9EA8B7)` (Silver Accent)
- `Color(0xFF8A94A8)` (Dark Silver)

## Verification Plan

### Manual Verification
- Switch to Dark Mode.
- Navigate to the Buy Silver screen.
- Verify that the "Buy Silver" and "Pay" buttons have a silver gradient instead of a maroon one.
- Check both the "Buy" and "Sell" variants for Silver.
