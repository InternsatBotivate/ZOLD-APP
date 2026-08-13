# Fix Blank Screen and Socket Connection Crash

The app is currently experiencing a "blank screen" and "crash" behavior. Based on the logs and code analysis, I have identified two major issues:

1.  **Socket URL Malformation**: The `SocketService` is incorrectly stripping the `api` part of the hostname, resulting in a malformed URL like `https:/-zold.zold.in`. This causes persistent background errors and could contribute to app instability.
2.  **Robust Initialization**: If any service fails to initialize during the `main()` function, the fallback logic in the `catch` block might also fail or leave the app in an inconsistent state, leading to a blank screen if the root widget (`ZoldApp`) cannot find required services like `ThemeService`.

## Proposed Changes

### [Component] Network & Services

#### [MODIFY] [socket_service.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/core/services/socket_service.dart)
- Safely derive the Socket URL from `ApiConstants.baseUrl` using `Uri.parse`. This ensures the hostname is preserved correctly and only the path is removed.

#### [MODIFY] [main.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/main.dart)
- Improve the robustness of the initialization sequence.
- Ensure `ThemeService` and other critical services are registered even if `dotenv` or other parts of the startup fail.
- Wrap the main initialization in a more structured way to prevent the `catch` block from failing if the original error was related to core dependencies.

### [Component] UI Stability

#### [MODIFY] [onboarding_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/onboarding/views/onboarding_view.dart)
- Add a safety check for the theme brightness and colors to ensure the UI is always visible even if theme resolution has minor issues.

## Verification Plan

### Manual Verification
- Restart the app and verify that the onboarding screen is clearly visible (not black/blank).
- Check logs for "Socket connected" message instead of "No host specified" errors.
- Verify that the app proceeds to the login screen after onboarding without crashing.
