# Implementation Plan - Fix "Next: Recipient" Button and UI Responsiveness

This plan fixes the unresponsive "Next: Recipient" button by ensuring the UI correctly reacts to observable changes, and maintains the responsive, compact UI design.

## User Review Required

> [!IMPORTANT]
> The "Next" button will now correctly enable/disable based on the `gramsAmount` observable, ensuring it stays in sync with user input.

## Proposed Changes

### [Gift Module]

#### [MODIFY] [gift_gold_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/wallet/views/gift_gold_view.dart)
- Update the `Obx` block for the "Next: Recipient" button to use `controller.gramsAmount.value` instead of parsing `valueController.text`. This ensures the UI rebuilds when the user types or selects a preset.
- Ensure `isInvalid` logic is robust for both `VIRTUAL` and `COIN` gift types.
- Maintain the compact 3-column occasion selector and reduced spacing for a "good looking" UI.

#### [MODIFY] [gift_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/wallet/controllers/gift_controller.dart)
- Ensure `updateValueFromWeight` and `updateWeightFromValue` correctly handle empty strings and edge cases.
- Add a check to ensure `gramsAmount` is never negative.

## Verification Plan

### Automated Tests
- N/A

### Manual Verification
- Open Gift Gold/Silver screen.
- Enter a weight (e.g., 0.1g) and verify the "Next: Recipient" button becomes active and clickable.
- Select a preset and verify the button remains active.
- Enter a value > ₹2,00,000 and verify the button disables and shows an error.
- Verify that the "Back" button works correctly.
- Verify the layout remains compact and professional on different screen sizes.
