# Implementation Plan - Fix Session Expiry Crash and Navigation

The user reported a crash when clicking "Return to Shop" after a checkout session ends in the `coin_checkout` module. The goal is to ensure that clicking this button (and the automatic redirection) navigates directly to the Home page instead of potentially crashing due to `Get.until` trying to find a route that might not be in the stack.

## User Review Required

> [!NOTE]
> I will be changing the navigation target from `Routes.goldCoins` to `Routes.home` as requested by the user.

## Proposed Changes

### [Coin Checkout Module]

#### [MODIFY] [coin_checkout_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/coin_checkout/views/coin_checkout_view.dart)
- Update the `onPressed` logic of the "Return to Shop" button in `_buildExpiredState` to use `Get.offAllNamed(Routes.home)`.

#### [MODIFY] [coin_checkout_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/coin_checkout/controllers/coin_checkout_controller.dart)
- Update the `_handleSessionExpired` method to use `Get.offAllNamed(Routes.home)` after the countdown ends.

## Verification Plan

### Manual Verification
- I will review the code changes to ensure they match the user's request.
- The use of `Get.offAllNamed` is safer than `Get.until` when the target route might not be in the navigation stack, and it fulfills the user's requirement to go "direct home page me navigate ho jaye".
