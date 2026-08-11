# Implementation Plan - Enhance Responsiveness & Validation

Ensure the "Auspicious Days" module is fully responsive (UI/UX), handles the keyboard gracefully, and includes robust validation for user inputs.

## Proposed Changes

### 1. AuspiciousDaysController Enhancements
- Add validation logic for `autoBuyAmount` (e.g., min ₹100, max ₹1,000,000).
- Create an observable `amountError` to provide real-time feedback.
- Update `handleSetAutoBuy` to perform a final validation check before scheduling.

### 2. AuspiciousDayDetailView UX & Keyboard
- Wrap the view in a `GestureDetector` to dismiss the keyboard when tapping on non-interactive areas.
- Configure `TextField` with `TextInputAction.done` and `onSubmitted` to improve keyboard flow.
- Ensure the footer action button handles the keyboard state (e.g., using `SafeArea` and avoiding being covered).
- Add real-time validation error display below the amount input.

### 3. UI/UX Responsiveness
- Review and refine `SliverAppBar` and card layouts to ensure they adapt well to smaller screen heights.
- Ensure all clickable areas have a minimum target size for better touch UX.

## Verification Plan

### Manual Verification
- **Validation**: Try entering "0", "-10", or "99999999" in the amount field and verify the error message appears and the "Schedule" button behavior.
- **Keyboard**: Open the detail view, tap the amount field, and verify that tapping outside dismisses the keyboard.
- **Flow**: Enter a valid amount and press the "Done" button on the keyboard to see if it submits or dismisses correctly.
- **Responsiveness**: Test on a small device (or emulator with small screen) to ensure no overflow occurs when the keyboard is open.
