# Implementation Plan - Profile Screen Pixel-Perfect Migration

The goal is to migrate the Flutter Profile screen to be a pixel-perfect clone of the Next.js web Profile page. This includes matching UI, behavior, navigation, and API calls.

## User Review Required

> [!IMPORTANT]
> - **Removal of Features:** Bank Accounts, Payment Methods, and My Deliveries will be removed from the Profile screen as they do not exist in the web version.
> - **Styling:** Colors, gradients, shadows, and spacing will be updated to match the Tailwind-based styles of the web app.
> - **API Logic:** Logout logic will be updated to include active session cleanup, matching the web's implementation.

## Proposed Changes

### [Flutter Project]

#### [MODIFY] [profile_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/views/profile_view.dart)
- Update Header gradient and radius.
- Re-style User Info Card with radial-like gradient and exact borders/shadows.
- Remove camera icon from avatar.
- Update section containers styling (rounded-2xl, bg-gray-50, specific shadows).
- Remove extra menu items: Bank Accounts, Payment Methods, My Deliveries.
- Add KYC status badge next to "KYC Status" text in the menu.
- Update list item icons and spacing.
- Update Logout button styling (red-600/25 bg).
- Add "Powered by AT Plus Jewellers" footer.

#### [MODIFY] [profile_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/controllers/profile_controller.dart)
- Update `logout()` method to include:
    1. Fetching active session from `/metal-purchase-session/active`.
    2. Canceling it if active.
    3. Calling `/auth/logout`.
- Cleanup unused variables and methods (related to bank accounts, payment methods, etc. if they are only used here).

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure no warnings or errors.
- Run `dart format` for code consistency.

### Manual Verification
- Compare Flutter UI with web screenshots side-by-side.
- Verify all menu items navigate to the correct screens.
- Verify logout functionality and API calls (via logcat/debug).
- Verify support links (Call and WhatsApp).
