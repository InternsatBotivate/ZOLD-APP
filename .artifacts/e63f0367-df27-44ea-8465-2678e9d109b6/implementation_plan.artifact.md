# Implementation Plan - Personal Information Dedicated Page

Moving the "Personal Information" edit functionality from a BottomSheet to a dedicated page to resolve the `TextEditingController` disposal error and improve UI/UX.

## User Review Required

> [!IMPORTANT]
> The "Personal Information" view will now be a standalone page instead of a BottomSheet. This change affects the navigation flow from the Profile screen.

## Proposed Changes

### [Profile Module]

#### [MODIFY] [app_routes.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/routes/app_routes.dart)
- Add `static const personalInformation = '/personal-information';` to the `Routes` class.

#### [MODIFY] [app_pages.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/routes/app_pages.dart)
- Register the new `PersonalInformationView` with `ProfileBinding`.

#### [NEW] [personal_information_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/views/personal_information_view.dart)
- Create a new view that implements the UI from the provided image.
- Include both "View" and "Edit" modes.
- Implement responsive layout and handle keyboard insets.
- Add form validation for name, email, phone, etc.
- Implement the "Save Changes" button with loading animation and double-click prevention.

#### [MODIFY] [profile_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/views/profile_view.dart)
- Update the "Personal Information" menu item to navigate to the new page using `Get.toNamed(Routes.personalInformation)`.
- Remove the `_showPersonalInfoSheet` method.

#### [MODIFY] [profile_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/controllers/profile_controller.dart)
- Add a `isEditing` observable to toggle between view and edit modes.
- Ensure `TextEditingController`s are initialized from the current user data when entering the page.
- Update `updateProfile` to handle the `isEditing` state and provide feedback.
- Add validation logic.

## Verification Plan

### Automated Tests
- N/A (Manual verification is more suitable for UI/UX and keyboard behavior)

### Manual Verification
1. Navigate to Profile -> Personal Information.
2. Verify the UI matches the provided image.
3. Click "Edit" and ensure it switches to edit mode with the keyboard appearing.
4. Test validation by entering invalid data.
5. Save changes and verify the loading animation and that the button is disabled.
6. Check that changes are reflected in the view mode after saving.
7. Verify back navigation works correctly.
8. Ensure the `TextEditingController` disposal error no longer appears.
