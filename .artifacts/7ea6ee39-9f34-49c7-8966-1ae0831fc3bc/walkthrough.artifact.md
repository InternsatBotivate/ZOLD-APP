# Walkthrough - Production Release Stability Fix

The production release was previously crashing on startup due to aggressive code and resource optimization settings. The APK size had dropped from 70MB to 31MB, indicating that essential native libraries or resources were being stripped.

## Changes Made

### 1. Build Configuration Stability
- **File**: [app/build.gradle.kts](file:///C:/Users/PCv/StudioProjects/zold_gold/android/app/build.gradle.kts)
- **Change**: Switched from `proguard-android-optimize.txt` to the stable `proguard-android.txt`.
- **Change**: Disabled `isShrinkResources` to prevent the accidental stripping of splash screen and launcher icon resources.

### 2. Robust ProGuard Rules
- **File**: [proguard-rules.pro](file:///C:/Users/PCv/StudioProjects/zold_gold/android/app/proguard-rules.pro)
- **Change**: Added explicit keep rules for:
    - `GeneratedPluginRegistrant` (Essential for plugin initialization)
    - `razorpay_flutter` (Critical for payment UI)
    - `google_fonts` and other plugin-specific classes.

### 3. Resource Protection
- **File**: [keep.xml](file:///C:/Users/PCv/StudioProjects/zold_gold/android/app/src/main/res/raw/keep.xml)
- **Change**: Created a new resource keep list to explicitly protect the splash screen and app icons from being stripped during the build process.

### 4. Code Cleanup & Modernization
- **File**: [referral_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/views/referral_view.dart)
- **Change**: Replaced deprecated `withOpacity()` calls with the modern `.withValues(alpha: ...)` API to satisfy the latest Flutter analyzer requirements and prevent precision loss.

## Verification Results

### Build Stats
- **APK Path**: `build/app/outputs/flutter-apk/app-release.apk`
- **Size**: **68.7 MB** (Restored from the broken 31MB version).
- **Status**: ✅ SUCCESS

### Code Quality
- **`flutter analyze`**: ✅ Clean (No issues found).

## Launch Test Instructions
> [!IMPORTANT]
> Please install the newly generated APK on a real device.
> 1. Ensure any previous version is uninstalled.
> 2. Install the APK from `build/app/outputs/flutter-apk/app-release.apk`.
> 3. Verify that the splash screen appears and the app proceeds to the onboarding/login screen.

> [!TIP]
> If you still encounter a "Black Screen" on some older devices, the logs can be checked using:
> `adb logcat | grep -i flutter`
