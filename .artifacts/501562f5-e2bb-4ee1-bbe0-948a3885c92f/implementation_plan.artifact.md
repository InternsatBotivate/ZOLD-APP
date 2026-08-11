# Production Error-Handling Hardening Plan

This plan aims to harden the `zold_gold` Flutter application for production by implementing robust error handling, session management, and UI resilience.

## Proposed Changes

### Core Infrastructure & Global Handling

#### [MODIFY] [main.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/main.dart)
- Improve global error catching in `runZonedGuarded` and `PlatformDispatcher`.
- Ensure structured logging of all uncaught errors.
- Categorize startup errors as critical vs non-critical.

#### [NEW] [app_logger.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/core/utils/app_logger.dart)
- Create a centralized logger that wraps the `logger` package.
- Implement sensitive data filtering (JWT, OTP, Secrets).
- Support structured logging for production auditing.

#### [MODIFY] [dio_client.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/core/network/dio_client.dart)
- Update interceptors to use the new `AppLogger`.
- Ensure no sensitive data (headers, tokens) is logged.
- Implement a simple retry policy for safe, idempotent requests (e.g., GET rates).
- Refine 401/403 handling to prevent redundant logout calls.

#### [MODIFY] [error_handler.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/core/network/error_handler.dart)
- Standardize all network error messages for end-users.
- Add more granular handling for specific HTTP codes (e.g., 429 Too Many Requests, 503 Service Unavailable).

#### [MODIFY] [base_response.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/data/models/base_response.dart)
- Harden `fromJson` to handle more malformed JSON scenarios.
- Ensure "Parsing error" doesn't leak raw exception details to the user in production.

### Authentication & Session Management

#### [MODIFY] [auth_service.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/core/services/auth_service.dart)
- Prevent concurrent logout/navigation operations during session expiry.
- Improve `validateSession` resilience against transient network failures.

### Controller & Business Logic Safety

#### [MODIFY] [buy_sell_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/buy_sell/controllers/buy_sell_controller.dart)
- Audit all async methods to ensure `isLoading` and `isProcessing` are ALWAYS reset using `finally`.
- Guard against duplicate CTA taps (e.g., in `executeTransaction`, `proceedToReview`).
- Ensure Razorpay listeners are properly managed and don't leak or trigger updates after disposal.

#### [MODIFY] [purchase_repository.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/data/repositories/purchase_repository.dart)
- (And other repositories) Ensure errors are consistently caught and mapped to `Failure` without leaking Dio specifics.

### UI & UX Resilience
- Ensure all loading states have a timeout or a guaranteed exit path.
- Standardize the display of error Snackbars to prevent duplicates.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure no linting or type errors.

### Manual Verification
- **Startup**: Simulate network failure during startup.
- **Session Expiry**: Manually trigger a 401 and verify safe redirection to Login.
- **Payment Flow**: Verify that backgrounding the app or network failure during payment doesn't leave the UI stuck.
- **Offline Mode**: Disable internet and verify the app shows a friendly error instead of crashing/infinite loading.
- **Malformed JSON**: Mock a malformed API response and verify it's caught by `BaseResponse` without crashing.
