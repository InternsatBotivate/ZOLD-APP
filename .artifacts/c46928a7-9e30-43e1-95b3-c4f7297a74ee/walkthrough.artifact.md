# Walkthrough - Gold/Silver Blink Loading Shimmer

I have enhanced the loading shimmer effect to be much more visible, especially in light mode. It now uses a dynamic metal-themed gradient that "blinks" with the respective metal's accent color.

## Changes Made

### BuySell Module

#### [buy_sell_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/buy_sell/views/buy_sell_view.dart)

- **Metal-Themed Shimmer**: The `_ShimmerWrapper` now accepts an `isGold` parameter.
    - In **Gold** mode: It uses a gradient of gold colors (`0xFFEEC762`).
    - In **Silver** mode: It uses a gradient of silver/slate colors (`0xFF9EA8B7`).
- **Improved Visibility**:
    - In light mode, the shimmer opacity has been increased (`0.5` peak) to ensure it's clearly visible against the light background.
    - Added a subtle metal-colored border to the shimmer skeleton to further define its shape while loading.
- **Dynamic Updates**: Updated all loading skeleton calls (`_buildInfoCard`, `_buildPriceBreakdown`, `_buildLiveRateCard`) to pass the current metal type, ensuring the "blink" matches what the user is interacting with.

## Verification Results

### Loading States
- **Gold Mode**: Shows a prominent gold-colored moving gradient.
- **Silver Mode**: Shows a prominent silver-colored moving gradient.
- **Light/Dark Mode**: The effect is balanced to be visible in both, with higher contrast in light mode as requested.
