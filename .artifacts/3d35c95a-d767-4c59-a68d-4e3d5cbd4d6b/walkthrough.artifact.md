# Walkthrough - Fixed App Crash and Black Screen on Real Device

I have implemented several fixes to stabilize the app's startup and prevent the crash on your real device.

## Changes Made

### 1. Fixed Black Screen / Graphics Crash
- **File**: [AndroidManifest.xml](file:///C:/Users/PCv/StudioProjects/zold_gold/android/app/src/main/AndroidManifest.xml)
- **Action**: Disabled the **Impeller** rendering engine.
- **Reason**: Your device logs showed `gralloc4` allocation errors, which are common when Impeller's Vulkan backend is incompatible with a device's drivers. This is the most common cause of black screens on Android 13/14 devices.

### 2. Stabilized App Startup
- **File**: [main.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/main.dart)
- **Action**:
    - Reordered dependency injection to register repositories *before* services.
    - Wrapped the entire `main()` function in a `try-catch` block to prevent the app from dying silently if a network call fails during startup.
    - Added `permanent: true` to critical dependencies to ensure they are never accidentally removed from memory.
    - Explicitly registered `PurchaseRepository` which was missing from the global scope.

### 3. Added Null-Safety to Network Interceptor
- **File**: [dio_client.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/core/network/dio_client.dart)
- **Action**: Added a check to ensure `AuthService` is registered before attempting to call `logout()` on 401 errors.
- **Reason**: If a 401 error occurred during the very first second of app startup, it would try to call `AuthService` before it was ready, causing a crash.

### 4. Improved Logout Robustness
- **File**: [auth_service.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/core/services/auth_service.dart)
- **Action**: Added a check for `PurchaseRepository` registration and ensured navigation only happens if the UI context is ready.

## How to Verify
1.  **Restart the App**: Run `flutter run` again on your device.
2.  **Observe Splash**: The black screen should be replaced by your splash/onboarding screen.
3.  **Check Logs**: If it still fails, check the logs for "FATAL STARTUP ERROR" which I added to help debug future issues.

render_diffs(file:///C:/Users/PCv/StudioProjects/zold_gold/android/app/src/main/AndroidManifest.xml)
render_diffs(file:///C:/Users/PCv/StudioProjects/zold_gold/lib/main.dart)
render_diffs(file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/core/network/dio_client.dart)
render_diffs(file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/core/services/auth_service.dart)
