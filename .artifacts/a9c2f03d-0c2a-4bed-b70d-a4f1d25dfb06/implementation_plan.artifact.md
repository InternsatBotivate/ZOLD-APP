# Implementation Plan - Minimal Spacing for Checkout AppBar

Move the Zold Gold logo and title significantly closer to the back button in the Checkout screen header as per the user's latest feedback.

## User Review Required

> [!IMPORTANT]
> To achieve "zero gap" look, I will reduce the `leadingWidth` of the AppBar and remove default padding from the back button. This will shift the logo to the left, placing it right next to the arrow.

## Proposed Changes

### [Coin Checkout Module]

#### [MODIFY] [coin_checkout_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/coin_checkout/views/coin_checkout_view.dart)

- Update `_buildAppBar`:
    - Set `leadingWidth: 40` (decreased from default 56).
    - Set `padding: EdgeInsets.zero` and `constraints: const BoxConstraints()` for the `IconButton` in `leading` to remove internal spacing.
    - Ensure `titleSpacing: 0` remains set.
    - Fine-tune the `SizedBox` between the logo and text for a compact look.

## Verification Plan

### Manual Verification
- **Visual Check**: Ensure the logo starts almost immediately after the back arrow icon.
- **Click Area**: Verify the back button is still easy to tap despite the reduced width.
- **Responsiveness**: Ensure the layout still handles the timer on the right correctly on narrow screens.
