# UI Hardening Implementation Plan

Perform a complete UI hardening pass on the Flutter project, focusing on responsiveness and keyboard handling.

## User Review Required

> [!IMPORTANT]
> This plan focuses on fixing verified layout issues and ensuring keyboard compatibility across all screens. No business logic or API changes will be made.

## Proposed Changes

### [Responsive Fixes]

#### [MODIFY] [onboarding_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/onboarding/views/onboarding_view.dart)
- Wrap slide content in `SingleChildScrollView` to prevent overflow on small devices.

#### [MODIFY] [home_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/home/views/home_view.dart)
- Replace `Row` in `_buildQuickActions` with a scrollable `Row` or `Wrap` to handle narrow screens.
- Ensure `Flexible` or `Expanded` is used for text that might overflow in cards.

#### [MODIFY] [buy_sell_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/buy_sell/views/buy_sell_view.dart)
- Adjust `_buildAmountPresets` and `_buildGramsPresets` to use `Wrap` or more flexible sizing to prevent text overflow on small screens.
- Ensure info cards in `_buildSellCards` handle text overflow.

#### [MODIFY] [sip_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/sip/views/sip_view.dart)
- Ensure `_buildSipStat` handles overflow if values are long.
- Adjust `_showDayPicker` grid for better accessibility on small screens.

#### [MODIFY] [wallet_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/wallet/views/wallet_view.dart)
- Ensure metal cards and ratio indicators handle overflow.

### [Keyboard Fixes]

#### [MODIFY] [auth_background.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/auth/views/widgets/auth_background.dart)
- Ensure `minHeight` calculation properly handles keyboard insets to avoid unnecessary scrolling or layout jumping.

#### [MODIFY] [profile_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/views/profile_view.dart)
- Ensure personal info bottom sheet remains scrollable and the "Save Changes" button is reachable when the keyboard is open.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure no linting or type errors.

### Manual Verification
- Test all modified screens on different screen sizes (using Flutter's device preview or resizing the window in web/desktop mode if available).
- Open keyboards in all forms (Login, Signup, Profile, Buy/Sell, KYC) to verify that fields are not hidden and buttons are reachable.
