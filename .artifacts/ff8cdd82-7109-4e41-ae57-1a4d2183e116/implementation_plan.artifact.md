# Admin Bug Fixes & UI Parity Refinement

This plan addresses the runtime cast error and refines the Admin UI to match user requirements and Next.js parity.

## User Review Required

> [!IMPORTANT]
> The "Sell Requests" data structure is being updated to merge Metal and Coin sell transactions into a single list, matching the Next.js frontend logic. This fixes the runtime `Map` to `List` cast error.

## Proposed Changes

### [Admin Component]

#### [MODIFY] [admin_remote_datasource.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/data/datasources/admin_remote_datasource.dart)
- Update `getSellRequests` to handle the Map response `{ metalSellTransactions, coinSellTransactions }`.
- Merge both lists into a single `List<dynamic>` before returning, adding a `type` field ("METAL" or "COIN") to each item for parity with Next.js.

#### [MODIFY] [admin_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/admin/views/admin_view.dart)
- **Header Removal**: Remove the redundant `_buildHeader()` call in `UsersManagementView` to clean up the UI as requested.
- **Back Navigation**: Change the `AppBar` leading icon from `Icons.menu` to `Icons.arrow_back` to allow users to "push back" to the previous screen (Home/Drawer).
- **Responsiveness**: Ensure `SingleChildScrollView` is used in all admin sub-views to handle keyboard visibility and different screen sizes without overflow.

### [Data Models Component]

#### [MODIFY] [admin_models.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/data/models/admin_models.dart)
- (Optional) Add a dedicated `AdminSellRequest` model if needed, but since it's currently dynamic and merging logic is straightforward, I will stick to merged maps for now to avoid breaking existing widget logic.

## Verification Plan

### Manual Verification
- Verify that "User Management" page loads without the "Map to List" error.
- Verify that the redundant header is gone.
- Verify that the back button works and returns to the Home screen.
- Verify keyboard responsiveness in search fields.
- Verify that Sell Requests (if any) show up correctly (needs backend data).
