# Fix Transparent Snackbar in Buy/Sell Module

The user reported that the success snackbar after payment in the `buy_sell` module is transparent and not correctly themed for light and dark modes.

## Proposed Changes

### Core Utilities
#### [MODIFY] [snackbar_utils.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/core/utils/snackbar_utils.dart)
- Update `SnackbarUtils` to use `AppColors.success`, `AppColors.error`, and `AppColors.info`.
- Ensure `backgroundColor` is solid (100% opaque).
- Make the snackbar styling consistent and theme-aware (using appropriate text colors based on the background).

### Buy/Sell Module
#### [MODIFY] [buy_sell_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/buy_sell/controllers/buy_sell_controller.dart)
- Add a success snackbar call in `_onSuccess()` and `_handlePaymentSuccess()` when the transaction is completed successfully.
- Replace all direct `Get.snackbar` calls with `SnackbarUtils` methods to ensure consistent, non-transparent styling.
- Remove `withValues(alpha: 0.8)` which was causing semi-transparency in error snackbars.

### Coin Checkout Module
#### [MODIFY] [coin_checkout_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/coin_checkout/controllers/coin_checkout_controller.dart)
- Add a success snackbar call when payment is verified.
- Replace direct `Get.snackbar` calls with `SnackbarUtils` methods.

## Verification Plan

### Automated Tests
- N/A (UI-related fix)

### Manual Verification
1. Perform a mock Buy/Sell transaction.
2. Verify that the success snackbar appears and is NOT transparent.
3. Verify that the snackbar looks good in both Light and Dark modes.
4. Trigger an error (e.g., enter invalid amount) and verify that the error snackbar is also solid and correctly themed.
