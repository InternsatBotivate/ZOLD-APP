# Admin Module Refactor - Phase 3 Implementation Plan

Focus on verification, integration, and performance. Align Flutter API calls with Next.js and ensure every module is fully functional with real data.

## User Review Required

> [!IMPORTANT]
> I will be updating the `AdminRemoteDataSource` and `AdminRepository` to support more complex data structures for metal prices (Buy/Sell for both Gold and Silver) and updating the request methods (e.g., using `PATCH` for rejection) to match the Next.js implementation.

> [!NOTE]
> `AdminDashboard` will be integrated with real statistics (User count, Pending request count) by leveraging existing repository methods.

## Proposed Changes

### [Component] Data Layer (Repository & Datasource)

#### [MODIFY] [admin_remote_datasource.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/data/datasources/admin_remote_datasource.dart)
- Update `updateMetalPrices` to accept gold/silver buy/sell rates.
- Update `updateGstRate` to use the same payload structure as Next.js.
- Change `rejectSellRequest` to use `PATCH` method.

#### [MODIFY] [admin_repository.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/data/repositories/admin_repository.dart)
- Update method signatures to match the new datasource capabilities.

---

### [Component] Admin Dashboard

#### [MODIFY] [admin_dashboard_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/admin/admin_dashboard/controllers/admin_dashboard_controller.dart)
- Inject `AdminRepository`.
- Add `totalUsers` and `pendingRequests` observables.
- Fetch counts on initialization.

#### [MODIFY] [admin_dashboard_binding.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/admin/admin_dashboard/bindings/admin_dashboard_binding.dart)
- Provide `AdminRepository` to the controller.

---

### [Component] User Management

#### [MODIFY] [user_management_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/admin/user_management/controllers/user_management_controller.dart)
- Ensure robust error handling for transaction history fetching.
- Optimize user search logic.

---

### [Component] Sell Requests

#### [MODIFY] [sell_requests_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/admin/sell_requests/controllers/sell_requests_controller.dart)
- Ensure correct data mapping for merged sell transactions (Metal vs Coin).

---

### [Component] Metal Price & GST

#### [MODIFY] [metal_price_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/admin/metal_price/controllers/metal_price_controller.dart)
- Inject `RateRepository` to fetch current rates.
- Add observables for Gold/Silver buy/sell rates.
- Implement `updateRates` with full payload.

#### [MODIFY] [metal_price_binding.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/admin/metal_price/bindings/metal_price_binding.dart)
- Provide `RateRepository`.

#### [MODIFY] [gst_management_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/admin/gst_management/controllers/gst_management_controller.dart)
- Inject `RateRepository` to fetch current GST.
- Implement GST history fetching if supported by API.

---

### [Component] Cleanup & Verification
- Remove unused imports.
- Standardize `.withAlpha()` for colors.
- Run `flutter analyze`.

## Verification Plan

### Automated Tests
- `flutter analyze` must pass with zero issues.

### Manual Verification
- Verify that updating Metal Prices correctly sends the complex object and shows a success snackbar.
- Verify that GST updates match the Next.js payload format.
- Verify Dashboard stats update when users or requests change.
- Verify that rejecting a sell request uses the `PATCH` method.
- Check responsiveness across all screen sizes (320px to Desktop).
