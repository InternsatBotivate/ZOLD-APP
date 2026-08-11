# Production Hardening Implementation Plan

This plan details the final hardening pass for the Zold Gold Flutter project, focusing on dependency cleanup, dummy data removal, and build stability for production release.

## User Review Required

> [!IMPORTANT]
> **Razorpay Production Key**: The project currently uses a test key (`rzp_test_Sb44esbmpGlzBd`). For production, this MUST be replaced with a live key. Since I cannot invent this, I will keep the current one but highlight it for your action.

> [!IMPORTANT]
> **API Base URL**: The current base URL `https://zoldbackendfortest-production.up.railway.app/api` contains "test". Please verify if this is the intended production endpoint.

## Proposed Changes

### 1. Dependency Hardening (pubspec.yaml)

#### [MODIFY] [pubspec.yaml](file:///C:/Users/PCv/StudioProjects/zold_gold/pubspec.yaml)
- Update `dio` to `^5.11.0` (Latest stable).
- Update `geolocator` to `^13.0.4` (Latest compatible).
- Update `google_fonts` to `^8.1.0`.
- Update `image_picker` to `^1.1.2`.
- Update `flutter_lints` to `^5.0.0`.
- *Note*: `fl_chart` will be kept at `^0.70.2` as it is verified stable in previous iterations and newer versions may have breaking API changes.

### 2. Mock & Dummy Data Cleanup

#### [MODIFY] [referral_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/controllers/referral_controller.dart)
- Ensure no hardcoded dummy data is used as a primary source.
- Verified that `ZOLD100` is only a fallback if the user's own code is missing.

### 3. Build Configuration & Stabilization

#### [MODIFY] [build.gradle.kts (App)](file:///C:/Users/PCv/StudioProjects/zold_gold/android/app/build.gradle.kts)
- Enable `isShrinkResources = true` for the release build to reduce APK size.
- Ensure `signingConfig` is properly noted (currently uses debug for convenience).

#### [MODIFY] [build.gradle.kts (Root)](file:///C:/Users/PCv/StudioProjects/zold_gold/android/build.gradle.kts)
- Simplify build directory logic if it continues to cause `AndroidLocationsBuildService` errors.

## Verification Plan

### Automated Tests
1. `flutter pub get` - Verify all dependencies resolve.
2. `flutter analyze` - Ensure zero lint/syntax errors.
3. `flutter build apk --release` - Verify a successful production-ready APK generation.

### Manual Verification
- Review the generated APK size after enabling resource shrinking.
- Verify that Razorpay payment gateway initializes correctly (even with test key).
