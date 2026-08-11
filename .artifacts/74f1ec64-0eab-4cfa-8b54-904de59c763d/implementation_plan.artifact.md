# Implementation Plan - Security & Privacy Screen Refinement

Refine the Security & Privacy screen in the `profile` module to match the provided screenshots and the Next.js frontend implementation. This includes adding an "Edit Mode", detailed password security fields, two-factor authentication toggles, privacy settings, and active session management with a polished UI/UX for both light and dark modes.

## Proposed Changes

### [Profile Module](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile)

#### [MODIFY] [profile_binding.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/bindings/profile_binding.dart)
- Bind `SecurityPrivacyController` to handle the specific logic for the Security & Privacy view.

#### [NEW] [security_privacy_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/controllers/security_privacy_controller.dart)
- Create a dedicated controller for `SecurityPrivacyView`.
- Manage `isEditMode` state.
- Handle password change logic with form controllers (`currentPassword`, `newPassword`, `confirmPassword`).
- Handle password visibility toggles.
- Handle security settings updates (2FA, Profile Visibility, Read Receipts, Data Sharing).
- Handle session management (fetch sessions, revoke individual/all sessions).
- Sync with `ProfileRepository`.

#### [MODIFY] [security_privacy_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/views/security_privacy_view.dart)
- Completely rewrite the view to match the screenshots.
- Implement **View Mode**:
    - Header with Title, Subtitle, and "Edit Settings" button.
    - Status badges (Secure/Disabled/Enabled/On/Off) with appropriate colors.
    - Active sessions list with "Logout All" action.
    - Security Tips card (blue styled).
- Implement **Edit Mode**:
    - Header with "Cancel" (X) and "Save" (Floppy icon) buttons.
    - Password Security section with 3 text fields and visibility toggles.
    - "Changes require verification" warning.
    - Toggles and dropdowns for other settings.
    - "Important" warning card at the bottom.
- Ensure full support for Light and Dark modes using `AppColors` and `Theme.of(context)`.
- Improve keyboard handling (e.g., focus nodes, scrolling when keyboard is up).

## Verification Plan

### Automated Tests
- Since this is primarily a UI refactor, I will focus on manual verification.
- Unit tests for `SecurityPrivacyController` can be added if requested, focusing on state transitions and API call sequences.

### Manual Verification
- **UI Matching**: Compare the implemented screens with the provided screenshots.
- **Dark Mode**: Toggle system dark mode and verify readability and color consistency.
- **Edit Workflow**:
    1. Click "Edit Settings".
    2. Verify header changes to Save/Cancel.
    3. Verify text fields appear in Password section.
    4. Toggle 2FA and privacy settings.
    5. Click "Save" and verify settings are updated in the backend (mocked or real).
    6. Click "Cancel" and verify changes are reverted.
- **Session Management**:
    - Verify sessions are listed correctly.
    - Test "Revoke" on a specific session.
    - Test "Logout All".
- **Keyboard Handling**: Click on a password field and ensure the view scrolls appropriately and doesn't obscure other fields.
