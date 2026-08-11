# Authentication Module Review & Alignment

Review and align the Flutter Authentication module with the Next.js frontend implementation, ensuring feature parity, consistent navigation flow, and robust session management.

## User Review Required

> [!IMPORTANT]
> - **Initial Routing**: I will implement a middleware-based approach to handle initial routing. This will automatically skip onboarding if already seen and redirect to Home/KYC if already authenticated.
> - **KYC Integration**: The login flow will be updated to check for KYC completion status, matching the Next.js logic.

## Proposed Changes

### [Component] Core Infrastructure

#### [MODIFY] [auth_service.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/core/services/auth_service.dart)
- Add `hasSeenOnboarding` observable.
- Update `init()` to load `hasSeenOnboarding` and `kycCompleted` from storage.
- Add `completeOnboarding()` method.

#### [NEW] [auth_middleware.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/core/middleware/auth_middleware.dart)
- Implement `GetMiddleware` to handle redirection logic:
    - If `!hasSeenOnboarding` -> Onboarding.
    - If `!isAuthenticated` -> Login.
    - If `!kycCompleted` -> KYC.
    - Else -> Home.

### [Component] Authentication Module

#### [MODIFY] [login_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/auth/controllers/login_controller.dart)
- Update `login()` to check `kycCompleted` status from `SharedPreferences` before redirecting to Home.

#### [MODIFY] [signup_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/auth/controllers/signup_controller.dart)
- Refactor `_validate()` to use `AppValidators` for better consistency.

#### [MODIFY] [auth_background.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/auth/views/widgets/auth_background.dart)
- Fix `withOpacity` deprecation (use `.withValues(alpha: ...)`).

### [Component] Onboarding Module

#### [MODIFY] [onboarding_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/onboarding/controllers/onboarding_controller.dart)
- Update `complete()` to save `hasSeenOnboarding` flag via `AuthService`.

#### [MODIFY] [onboarding_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/onboarding/views/onboarding_view.dart)
- Fix `withOpacity` deprecation.

### [Component] Routing

#### [MODIFY] [app_pages.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/routes/app_pages.dart)
- Add `AuthMiddleware` to relevant routes.
- Update `initialRoute` logic if necessary, or let middleware handle it.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure no lint/compile errors.

### Manual Verification
1. **Fresh Install**: Verify Onboarding is shown.
2. **Onboarding Skip/Complete**: Verify redirection to Login.
3. **Login (New User)**: Verify redirection to KYC if not completed.
4. **Login (KYC Done)**: Verify redirection to Home.
5. **Auto Login**: Restart app when logged in, verify it skips Onboarding/Login.
6. **Logout**: Verify redirection to Login and session clearing.
7. **Forgot Password**: Verify the flow (Email -> OTP + New Password -> Success).
