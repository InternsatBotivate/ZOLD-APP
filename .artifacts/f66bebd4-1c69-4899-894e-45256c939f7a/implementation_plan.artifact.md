# Implementation Plan - Fix Login and Registration

Fix the authentication flow (Login and Registration) in the Flutter app to match the backend implementation and handle errors properly.

## User Review Required

> [!IMPORTANT]
> The backend does not return the authentication token in the response body for the `/login` endpoint; it is sent in a `set-cookie` header. The Flutter app must extract this token from the headers to authenticate subsequent requests.

> [!NOTE]
> The backend `signup` service does not currently save the `city` field, although the frontend collects it. I will keep it in the request for future-proofing (as the reference frontend also sends it), but ensure it doesn't cause issues if the backend ignores it.

## Proposed Changes

### Data Layer

#### [MODIFY] [auth_models.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/data/models/auth_models.dart)
- Update `LoginResponse` to make `token` nullable or ensure better mapping.
- Ensure `User` model handles all possible fields from backend response (like `isVerified` as boolean).
- Ensure `SignupRequest` fields match the expected types.

#### [MODIFY] [auth_remote_datasource.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/data/datasources/auth_remote_datasource.dart)
- Improve `_extractToken` to handle multiple cookie formats.
- Fix the circular reference in `signup` response mapping.
- Add better logging for debugging auth issues.

### Presentation Layer

#### [MODIFY] [signup_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/auth/controllers/signup_controller.dart)
- Improve error handling to display specific backend error messages (e.g., "User already exists").
- Ensure all required fields are validated before submission.
- Fix navigation after successful signup.

#### [MODIFY] [login_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/auth/controllers/login_controller.dart)
- Ensure token is correctly saved and `AuthService` is updated.
- Better error handling for failed login attempts.
- Fix navigation logic based on KYC status.

#### [MODIFY] [otp_verification_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/auth/controllers/otp_verification_controller.dart)
- Ensure OTP verification correctly handles the redirection to login.

## Verification Plan

### Manual Verification
1.  **Registration**: Attempt to register a new user. Verify that:
    - Validation errors are shown for missing/invalid fields.
    - Successful signup redirects to the OTP verification screen.
    - Backend errors (like "Email already in use") are displayed correctly.
2.  **OTP Verification**: Enter the 6-digit OTP sent to the email. Verify that it redirects back to login.
3.  **Login**: Login with the verified credentials. Verify that:
    - The app extracts the token from cookies.
    - The session is validated via `/auth/me`.
    - The user is redirected to either Home or KYC depending on their status.
