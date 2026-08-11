# Implementation Plan - Modern Shimmer Animation for Home Page

The goal is to enhance the user experience by replacing the full-screen loading spinner with a modern "shimmer" effect (skeleton screen) on the Home page. This will give the app a more polished and modern feel, similar to premium financial apps.

## User Review Required

> [!IMPORTANT]
> The shimmer effect will be applied to the rate cards, portfolio cards, and the price chart area while data is being fetched.
> No existing functionality will be removed. The app will transition from shimmer to actual data once the API response is received.

## Proposed Changes

### [Home Module]

#### [MODIFY] [home_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/home/views/home_view.dart)
- Import the `shimmer` package.
- Remove the full-screen `SpinKitPulse` when `isLoading` is true.
- Update the `build` method to show the main layout even when loading, but replace data-heavy widgets with shimmer versions.
- Create helper methods for shimmer skeletons of:
    - Rate Cards
    - Portfolio Cards
    - Price Chart
    - Live Rate Header

#### [MODIFY] [home_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/home/controllers/home_controller.dart)
- Ensure `isLoading` is handled correctly during data refreshes. (Already seems correct, but will verify).

## Verification Plan

### Automated Tests
- I will verify the code compiles and the shimmer widgets are correctly implemented.
- Since I cannot run the app to see animations, I will ensure the logic for `isLoading` correctly toggles between shimmer and actual data.

### Manual Verification
- The user can verify that when the home page opens, the "shimmer" effect appears on the cards instead of the central loading icon.
- Verify that data still loads and displays correctly after the shimmer.
