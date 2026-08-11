# Parity Report - Zold Gold

## Screenshot Audit Status
⚠️ **MISSING DATA**: Neither `reference_screenshots/` nor `verification_screenshots/` contain the required images for visual parity analysis.

## Required Screenshots for Audit
The following screens must be captured from both the Flutter app and the Next.js frontend for a complete parity verification:

1.  **Authentication & Onboarding**
    *   Login Screen
    *   Signup Screen
    *   OTP Verification Screen
    *   Forgot Password / Reset Password
2.  **Dashboard & Core Features**
    *   Home (Dashboard) with Live Rates
    *   Gold Details Page (Buy interface)
    *   Portfolio View
3.  **Transactions & Wallet**
    *   Wallet Screen (Add Funds)
    *   Transaction History (Filters & Pagination)
    *   Checkout / Order Summary
    *   Razorpay Integration Flow
4.  **Investments & Savings**
    *   SIP Management Screen
    *   Gold Goals Screen
    *   Gift Gold Screen
5.  **User Profile & Support**
    *   Profile Settings
    *   KYC Upload Screen
    *   Partner Locations Map
    *   FAQ Page
6.  **Admin & Operations**
    *   Admin User Management
    *   Admin Metal Price Management
    *   Admin Sell Request Approval
    *   Deliveries Tracking (Admin/Partner)

## Parity Findings (Code-based Review)
| Screen | Parity Status | Notes |
| :--- | :--- | :--- |
| **Login** | MATCH | Functional parity verified via `LoginController` and `AuthRemoteDataSource`. |
| **Home Dashboard** | MATCH | Layout structure matches Next.js implementation with metal balances and live rates. |
| **KYC Flow** | MATCH | Implements multi-document upload and status tracking as per `MIGRATION_AUDIT.md`. |
| **SIP Management** | MATCH | Recurring investment logic and plan selection mirrored from frontend. |
| **Cart & Checkout** | MATCH | Persistent cart and Razorpay order flow verified in `CartController`. |
| **Deliveries** | MATCH | Role-based view for Partners/Admins implemented correctly. |

## Recommendations
- **Capture Screenshots**: Use an emulator or physical device to capture all screens listed above.
- **Visual Polish**: Once screenshots are available, verify typography and color weights against Tailwind CSS tokens defined in `MIGRATION_AUDIT.md`.
