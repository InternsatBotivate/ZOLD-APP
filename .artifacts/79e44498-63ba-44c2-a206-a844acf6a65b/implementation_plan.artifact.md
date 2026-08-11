# Implementation Plan - Revamp Referral Module

The goal is to completely redesign the Referral view to match the provided screenshots, supporting both Light and Dark modes, and ensuring a professional UI/UX with 100% correct code.

## User Review Required

> [!IMPORTANT]
> I will be creating a new `ReferralController` and `ReferralBinding` to properly manage the state and actions of this module. I will also implement a custom dashed border for the referral code section to match the design without adding new dependencies.

## Proposed Changes

### [Profile Module]

#### [NEW] [referral_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/controllers/referral_controller.dart)
- Manage referral stats (Total Referrals, Total Earned, Pending).
- Handle referral code fetching from `AuthService`.
- Implement `copyToClipboard` and `shareReferral` functions.

#### [NEW] [referral_binding.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/bindings/referral_binding.dart)
- Dependency injection for `ReferralController`.

#### [MODIFY] [referral_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/views/referral_view.dart)
- Implement the comprehensive new UI:
    - Gradient Header (Pink/Purple) with Gift Icon.
    - Colorful Stats Cards.
    - Dark/Light Theme compatible "How it works" section.
    - Dashed-border "Your Referral Code" container.
    - Copy button and Share link logic.

#### [MODIFY] [app_pages.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/routes/app_pages.dart)
- Attach `ReferralBinding` to the `/referral` route.

## Verification Plan

### Manual Verification
- Open the Referral screen and compare it with the provided screenshots.
- Toggle between Light and Dark modes to ensure visibility and contrast.
- Test the "Copy" button and verify it correctly copies the code.
- Verify that "LOADING..." placeholder appears if the code is not yet available.
