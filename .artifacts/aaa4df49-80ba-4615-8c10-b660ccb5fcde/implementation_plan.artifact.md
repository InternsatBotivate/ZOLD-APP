# Implementation Plan - Responsive Partner UI

The user reported issues with the "Add Partner" and "Create Partner" (Complete Profile) UI in the partners module. The goal is to make these forms 100% responsive and improve the UI/UX while keeping the same overall design.

## User Review Required

> [!IMPORTANT]
> I will be refactoring the `_showAddPartnerDialog` and `_showCompleteProfileDialog` methods in `PartnersView` to use a more robust responsive approach. This includes:
> - Using `LayoutBuilder` for adaptive layouts (switching between 1 and 2 columns on larger screens).
> - Adding a `Form` with `GlobalKey<FormState>` for better validation handling.
> - Improving keyboard avoidance by ensuring the bottom sheet content is scrollable and reacts to `viewInsets`.
> - Standardizing the responsive text fields.

## Proposed Changes

### Partners Module

#### [MODIFY] [partners_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/partners/views/partners_view.dart)
- Refactor `_showAddPartnerDialog` to use a responsive grid for fields on wider screens.
- Refactor `_showCompleteProfileDialog` to improve layout and responsiveness.
- Update `_buildModernTextField` to be more flexible.
- Implement a `Form` for validation.
- Improve the `Get.bottomSheet` constraints and padding.

#### [MODIFY] [partners_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/partners/controllers/partners_controller.dart)
- Add `GlobalKey<FormState>` for the two forms.
- Add validation logic (e.g., checking for empty fields, valid email/phone).
- Ensure controllers are cleared properly and loading states are handled.

## Verification Plan

### Automated Tests
- I will verify the code builds and that there are no syntax errors using `analyze_file`.
- (Manual test by user) Verify that the dialogs look good on both mobile and tablet-sized screens (or by resizing the window if applicable).

### Manual Verification
- The user should test the "Add Partner" and "Complete Profile" flows to ensure validation works and the UI is responsive.
