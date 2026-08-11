# Implementation Plan - Buy Gold Module

This plan covers the implementation of the complete Buy Gold flow, including digital metal purchase (Buy/Sell) and physical gold coin purchase/conversion, matching the Next.js frontend UI and business logic.

## Proposed Changes

### Dependencies
#### [MODIFY] [pubspec.yaml](file:///C:/Users/PCv/StudioProjects/zold_gold/pubspec.yaml)
- Add `razorpay_flutter` for payment integration.

### Data Layer
#### [MODIFY] [coin_models.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/data/models/coin_models.dart)
- Add `CoinPurchaseSession`, `CartItem`, and related models for session-based coin purchase.
#### [MODIFY] [coin_remote_datasource.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/data/datasources/coin_remote_datasource.dart)
- Add endpoints for `/coin-purchase-session` (cart, checkout, create-order, verify-payment).
#### [MODIFY] [coin_repository.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/data/repositories/coin_repository.dart)
- Expose new session-based methods.

### Modules
#### [NEW] BuySell Module
- **Controller**: Handle digital buy/sell logic, session management, and price updates via Socket.IO.
- **View**: Responsive UI with metal-themed gradients, amount/gram inputs, and price breakdown.
- **Components**: `CheckoutPanel`, `SuccessScreen`, `SessionTimer`.

#### [NEW] GoldCoins Module
- **Controller**: Handle coin listing, cart management, and conversion logic.
- **View**: Product list (1g, 2g, 5g, 10g), product details, and cart drawer.

#### [NEW] Checkout Module
- **Controller**: Handle Razorpay integration for coin purchases.
- **View**: Order summary, payment status, and success/failure screens.

### Routing
#### [MODIFY] [app_routes.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/routes/app_routes.dart)
- Add routes: `/buy-sell`, `/gold-coins`, `/checkout`.
#### [MODIFY] [app_pages.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/routes/app_pages.dart)
- Register the new modules.

## Verification Plan
### Automated Tests
- `flutter analyze` to ensure no compile errors.
### Manual Verification
- Test digital buy/sell flow with real rates.
- Test physical coin conversion from wallet balance.
- Verify Razorpay modal opening (if possible in emulator).
- Verify responsiveness and UI matching with Next.js.
