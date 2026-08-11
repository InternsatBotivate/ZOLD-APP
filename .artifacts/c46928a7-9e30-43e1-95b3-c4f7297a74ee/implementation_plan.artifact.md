# Implementation Plan - Gold Blink Loading Shimmer

Improve the visibility of the loading shimmer effect, especially in light mode, by using a gold/silver themed gradient that "blinks" as requested.

## User Review Required

> [!NOTE]
> The shimmer will now use the metal's accent color (Gold or Silver) instead of plain white. This will make it much more visible on light backgrounds and provide the "gold blink" effect requested.

## Proposed Changes

### BuySell Module

#### [MODIFY] [buy_sell_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/buy_sell/views/buy_sell_view.dart)

- **Update `_ShimmerWrapper`**:
    - Add `isGold` boolean parameter.
    - Update `_ShimmerWrapperState` to use `LinearGradient` with gold/silver colors.
    - Adjust opacity levels to ensure visibility in both light and dark modes.
- **Update `_buildShimmerSkeleton`**:
    - Add `isGold` parameter.
    - Improve the base container decoration to be slightly more prominent in light mode.
- **Update usages of `_buildShimmerSkeleton`**:
    - Pass `isGold` from `_buildInfoCard`, `_buildPriceBreakdown`, and `_buildLiveRateCard`.

## Verification Plan

### Manual Verification
- Toggle between Light and Dark modes.
- Switch between Gold and Silver metal types.
- Observe the loading state (e.g., when rates are refreshing) to ensure the "gold blink" is clearly visible and aesthetically pleasing.
