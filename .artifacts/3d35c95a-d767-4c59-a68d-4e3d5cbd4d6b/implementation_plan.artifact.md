# Implementation Plan - Fix App Crash and Startup Issues

The app is experiencing a black screen followed by a crash on real devices (specifically Vivo V2117). This is caused by a combination of graphics rendering issues (Impeller) and unstable dependency initialization in the startup sequence.

## User Review Required

> [!IMPORTANT]
> I will be disabling **Impeller** (the new graphics engine) for Android. This is a common fix for "black screen" issues on many Android devices where Vulkan support is incomplete or buggy.
> I will also be refactoring the `main()` function to ensure all critical dependencies are registered before any network calls are made.

## Proposed Changes

### Android Configuration

#### [MODIFY] [AndroidManifest.xml](file:///C:/Users/PCv/StudioProjects/zold_gold/android/app/src/main/AndroidManifest.xml)
- Disable Impeller rendering to fix the black screen issue on devices with incompatible Vulkan drivers.

### Core Architecture & Initialization

#### [MODIFY] [main.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/main.dart)
- Wrap `main()` in a `try-catch` block to log startup errors.
- Reorder dependency injection to ensure `AuthService` is available before it's used by interceptors.
- Add `PurchaseRepository` to global dependencies since it's used by the global `AuthService`.
- Improve error handling during initialization.

#### [MODIFY] [dio_client.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/core/network/dio_client.dart)
- Add a safety check in the 401 interceptor to ensure `AuthService` is registered before calling `logout()`.

#### [MODIFY] [auth_service.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/core/services/auth_service.dart)
- Prevent navigation during `logout()` if the app is still in its initialization phase.

## Verification Plan

### Automated Tests
- I will verify the code compiles and the dependency injection logic is sound.

### Manual Verification
- The user should run the app on the real device and confirm the black screen is gone.
- Check logcat for any "FATAL EXCEPTION" during startup.
