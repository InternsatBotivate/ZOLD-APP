# Implementation Plan - Fix Referral UI Crash & Improve Responsiveness

The goal is to resolve the white screen "crash" on the Referral page and ensure the UI is 100% responsive across different screen sizes.

## User Review Required

> [!IMPORTANT]
> The white screen is likely caused by a layout error or a missing dependency initialization. I will refactor the UI to be more robust and use safer layout patterns.

## Proposed Changes

### UI Components

#### [MODIFY] [referral_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/views/referral_view.dart)
- **Error Handling**: Wrap the build method in a try-catch (debug only) or provide fallbacks to prevent white screens.
- **Responsiveness**:
    - Use `LayoutBuilder` to adjust the number of columns in the stats grid or share buttons if the screen is too narrow.
    - Use `Flexible` and `FittedBox` for text that might overflow.
- **Header**: Use `SafeArea` or adjust `SliverAppBar` to prevent overlap with the status bar.
- **Dashed Border**: Improve the `DashedBorderPainter` to handle zero size safely and ensure it doesn't cause infinite loops.
- **Grid Layouts**: Ensure `GridView` has correct constraints and doesn't cause overflow.

### Controller Logic

#### [MODIFY] [referral_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/controllers/referral_controller.dart)
- **Safety**: Ensure `AuthService.to` is accessed safely.
- **Initialization**: Move heavy logic to `onReady` instead of `onInit` to ensure all services are fully initialized.

## Verification Plan

### Automated Tests
- Verify code compilation.

### Manual Verification
- Test on different device orientations (if applicable) and screen sizes (responsive check).
- Verify the white screen is gone and the UI loads correctly.
