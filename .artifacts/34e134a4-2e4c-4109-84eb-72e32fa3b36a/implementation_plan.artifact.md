# Implementation Plan - Wallet Module (Phase 4)

Implement the complete Wallet/Portfolio module in the Flutter application, matching the Next.js frontend UI and functionality.

## Proposed Changes

### Data Layer
- Reuse existing `WalletRepository`, `CoinRepository`, and their respective datasources and models.
- Ensure all necessary models are correctly mapped from backend responses.

### Wallet Module [NEW]
- **Binding**: `lib/app/modules/wallet/bindings/wallet_binding.dart`
  - Initialize `WalletController` and its dependencies.
- **Controller**: `lib/app/modules/wallet/controllers/wallet_controller.dart`
  - Fetch wallet balance and stats.
  - Fetch coin inventory and transactions.
  - Handle loading and error states.
- **View**: `lib/app/modules/wallet/views/wallet_view.dart`
  - Implement the main portfolio screen with the following sections:
    - **Total Portfolio Header**: Glassmorphism effect, total value, and gold/silver ratio bar.
    - **Metal Cards**: Detailed gold and silver holding cards (grams, valuation, avg buy, P/L).
    - **Gold Breakdown**: Free vs Pledged gold.
    - **Coin Portfolio**: Grid of owned coins with images and actions (Delivery/Gift).
    - **Active Deliveries**: List of current coin delivery statuses.
    - **SIP Plans**: Banner/card linking to SIP management.

### Integration
- **Main Module**:
  - Update `lib/app/modules/main/views/main_view.dart` to replace "Portfolio (Coming Soon)" with `WalletView`.
  - Update `lib/app/modules/main/bindings/main_binding.dart` to include `WalletController`.
- **Navigation**:
  - Update `lib/app/routes/app_routes.dart` and `app_pages.dart` to include a `/portfolio` route (optional but good for drawer navigation).
  - Update `HomeDrawer` in `main_view.dart` to navigate correctly to the Portfolio tab.

### UI Components
- Create reusable widgets for the wallet module to keep the view clean:
  - `MetalCard`
  - `CoinInventoryItem`
  - `DeliveryStatusItem`

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure no compile-time errors or linting issues.

### Manual Verification
- Verify that wallet balance and stats are correctly fetched and displayed.
- Verify that the gold/silver ratio bar reflects the actual data.
- Verify that coin inventory displays correctly with images.
- Verify that the layout is responsive and handles different screen sizes without overflows.
- Verify that "Pull-to-refresh" works (if implemented in the view).
