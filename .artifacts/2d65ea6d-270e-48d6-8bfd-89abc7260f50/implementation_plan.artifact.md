# Refactor Admin Module into 4 Separate Modules

The goal is to split the current `admin` module into four distinct modules: `admin_users`, `admin_sell_requests`, `admin_gst`, and `admin_metal_price`. Each module will have its own Binding, Controller, and View. We will also implement a dedicated `AdminDrawer` for navigation and ensure the User Management table supports both vertical and horizontal scrolling.

## Proposed Changes

### 1. Module Structure [NEW]
Create the following directory structure under `lib/app/modules/admin/`:
- `users/`
- `sell_requests/`
- `gst/`
- `metal_price/`

### 2. Controllers [NEW]
Split the existing `AdminController` into:
- `AdminUsersController`: Handles user fetching, searching, filtering, and transaction details.
- `AdminSellRequestsController`: Handles fetching sell requests, approval/rejection, and filtering (Pending/History).
- `AdminGstController`: Handles updating GST rates.
- `AdminMetalPriceController`: Handles updating metal prices.

### 3. Views [NEW]
Refactor `AdminView` and its sub-views into separate view files:
- `AdminUsersView`: Vertical + Horizontal scrollable table for users.
- `AdminSellRequestsView`: Updated UI for sell requests.
- `AdminGstView`: Simple form for GST updates.
- `AdminMetalPriceView`: Simple form for metal price updates.

### 4. Bindings [NEW]
Create separate bindings for each module to lazily put the respective controllers.

### 5. Shared Admin Drawer [NEW]
Create an `AdminDrawer` widget in `lib/app/modules/admin/widgets/admin_drawer.dart` to provide consistent navigation across all admin modules.

### 6. Routes & Pages [MODIFY]
Update `lib/app/routes/app_pages.dart` to point each admin route to its new respective binding and view.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure no compile errors or warnings.

### Manual Verification
- Verify navigation between all 4 admin modules via the drawer.
- Verify User Management table scrolls both vertically and horizontally.
- Verify Sell Requests functionality (Approve/Reject with remarks).
- Verify GST and Metal Price update functionality.
- Ensure "Pending" and "History" tabs work correctly in Sell Requests.
