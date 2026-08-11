# Implementation Plan - Fix Buy/Sell UI and Loading

This plan addresses UI issues in the Buy/Sell screen, including input field styling, component-level loading (shimmer), and button loading states.

## User Review Required

> [!IMPORTANT]
> The full-screen shimmer loading will be replaced by component-level shimmer loading. This means the screen layout will be visible immediately, and specific data-driven sections will show shimmer effects while fetching data.

## Proposed Changes

### [Buy/Sell Module]

#### [MODIFY] [buy_sell_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/buy_sell/views/buy_sell_view.dart)
- Update the `build` method to remove the full-screen `_buildLoadingState` when `currentState` is `input`. Instead, it will always show `_buildMainContent`.
- Refactor `_buildInputField` to:
    - Remove the wrapping `Container`.
    - Use `InputDecoration` with `enabledBorder` and `focusedBorder`.
    - Use the metal's `accentColor` for the focused border.
    - Ensure the `TextField` covers the full area of the input box.
- Ensure all data-dependent widgets (`_buildLiveRateCard`, `_buildSellCards`, `_buildPriceBreakdown`, etc.) correctly check `controller.isLoading.value` to show shimmer skeletons.
- Update `_buildPriceBreakdown` to show shimmer when loading.

#### [MODIFY] [buy_sell_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/buy_sell/controllers/buy_sell_controller.dart)
- (Optional) Ensure `isLoading` is used consistently for both initial load and updates.

## Verification Plan

### Manual Verification
- **Input Fields:** Verify that the amount and grams input fields have proper borders and the text is well-aligned within the box.
- **Loading State:**
    - Navigate to the Buy/Sell screen and observe that the screen layout is visible immediately with shimmer effects on the rate cards.
    - Click "Buy Gold" / "Buy Silver" and verify that a circular loading indicator appears inside the button.
    - Verify that after loading, the state transitions to the review screen with the "Pay" button.
- **Metal Switch:** Switch between Gold and Silver and verify the accent colors update correctly in the input field borders.
