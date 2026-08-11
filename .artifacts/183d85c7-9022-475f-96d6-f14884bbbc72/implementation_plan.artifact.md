# Implementation Plan - Reduce Height of Home Module Cards

The goal is to reduce the height of the Gold/Silver rate cards and Portfolio cards in the home module while maintaining responsiveness and a clean UI.

## Proposed Changes

### [Home Module]

#### [MODIFY] [home_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/home/views/home_view.dart)

- **Rate Cards (`_buildRateCard`)**:
    - Reduce hardcoded height from `95` to `80`.
    - Adjust internal padding and spacing to accommodate the smaller height.
    - Slightly reduce font sizes for the price and labels if necessary.
- **Portfolio Cards (`_buildPortfolioCard`)**:
    - Reduce overall padding from `12` to `10`.
    - Reduce vertical spacing between sections (e.g., from `8` to `6`).
    - Make the "Gold Bar" and "Coins" info boxes more compact by reducing their vertical padding.
    - Adjust the "coins list" (Wrap) spacing to be tighter.
- **Shimmer Effects**:
    - Update `_buildShimmerRateCard` height to match the new rate card height (`80`).
    - Update `_buildShimmerPortfolioCard` height to a smaller value (e.g., `85`) to better reflect the new compact design.

## Verification Plan

### Manual Verification
- Verify the layout on different screen sizes to ensure responsiveness.
- Check that all text remains legible and doesn't overflow in the smaller cards.
- Ensure the "Live" indicator and gram details are still clearly visible.
