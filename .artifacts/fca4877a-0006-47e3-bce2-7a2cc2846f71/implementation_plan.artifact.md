# Implementation Plan - Fix Onboarding View Layout

Fix the "BoxConstraints forces an infinite width" runtime error in the Onboarding screen.

## User Review Required

> [!IMPORTANT]
> The primary fix involves setting `mainAxisSize: MainAxisSize.min` on the `Row` inside the `ElevatedButton`. This prevents the button from requesting infinite width while inside another `Row`.

## Proposed Changes

### Onboarding Module

#### [MODIFY] [onboarding_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/onboarding/views/onboarding_view.dart)

- Update the `Row` widget used as the `child` of the `ElevatedButton` (around line 124) to use `mainAxisSize: MainAxisSize.min`.
- Update the dots `Row` (around line 90) to use `mainAxisSize: MainAxisSize.min` to ensure it doesn't compete for space with the button.
- This ensures the button only takes up as much space as its content needs, satisfying the constraints of the outer `Row`.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure no static analysis errors.

### Manual Verification
- Run the app on the emulator and verify the Onboarding screen renders correctly.
- Verify that clicking "Next" transitions through slides and eventually shows "Get Started".
- Verify that the layout is responsive and no widgets overlap.
