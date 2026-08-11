# Fix "WalletController not found" in Portfolio

This plan addresses the GetX "Controller not found" error in the Portfolio section by ensuring the `WalletController` is properly initialized and stays available in the dependency manager.

## Proposed Changes

### [main_module]

#### [MODIFY] [main_binding.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/main/bindings/main_binding.dart)

- Change `Get.lazyPut` to `Get.put` for `WalletController` to ensure it is initialized when `MainView` starts.
- Add `fenix: true` to other `lazyPut` calls for repositories and data sources to allow them to be recreated if disposed.
- Ensure `HomeController` and `ProfileController` are also handled robustly (either `Get.put` or `lazyPut` with `fenix: true`).

## Verification Plan

### Manual Verification
- Run the app and navigate to the Portfolio section from the bottom navigation bar.
- Verify that the "WalletController not found" error is no longer displayed and the portfolio data loads correctly.
- Test navigating between Home and Portfolio tabs multiple times.
- Test navigating to other screens (like Gift Gold) and coming back to the Portfolio tab.
