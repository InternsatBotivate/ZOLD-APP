# Implementation Plan - Optimized Profile Image Preview

Adjust the profile image preview to move the image higher on the screen and make the background adaptive to Light and Dark modes.

## Proposed Changes

### [Profile Module]

#### [MODIFY] [profile_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/views/profile_view.dart)
- Update `_showImagePreviewDialog` to use theme-based colors:
    - Background: Use `theme.scaffoldBackgroundColor`.
    - AppBar & Icons: Adjust colors (black/white) based on the current theme.
- Adjust image alignment:
    - Instead of `Center`, use `Alignment.topCenter` with a specific top margin/padding to move the image higher, or wrap in a `Column` to control vertical placement better.
    - Ensure `InteractiveViewer` still allows for flexible viewing.

#### [MODIFY] [personal_information_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/views/personal_information_view.dart)
- Apply the same theme-based background and alignment fixes to the `_showImagePreviewDialog` in this view for consistency.

## Verification Plan

### Manual Verification
- Open image preview in Light Mode: Verify the background is light and icons/text are dark.
- Open image preview in Dark Mode: Verify the background is dark and icons/text are light.
- Check image position: Confirm it is higher on the screen compared to the previous version.
- Verify "Edit" and "Back" buttons are clearly visible and functional in both modes.
