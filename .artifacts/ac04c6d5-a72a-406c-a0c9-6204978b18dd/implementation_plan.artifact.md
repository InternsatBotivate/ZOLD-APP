# Implementation Plan - Modern Sell Requests UI Refinement

Apply modern UI patterns, dual-axis scrolling, and blinking skeleton loading to the Sell Requests page, consistent with the User Management refinements.

## User Review Required

> [!IMPORTANT]
> The "Sell Requests" title and subtitle will be moved to the AppBar. The drawer will be removed, leaving only the back button.
> The "Pending" and "History" toggle tabs will be moved to a persistent filter area at the top of the body.

## Proposed Changes

### [Admin Module] Sell Requests

#### [MODIFY] [sell_requests_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/admin/sell_requests/views/sell_requests_view.dart)
- **AppBar**: Update to include the "Sell Requests" title and description. Remove the drawer menu action.
- **Body**:
    - Use `Column` with `Expanded` for the table area.
    - Move `_buildToggleTabs()` to the top of the body as a persistent filter.
    - Remove redundant `_buildHeader()` and `_buildBreadcrumb()`.
- **Table Container**:
    - Wrap `DataTable` in nested `SingleChildScrollView` (Vertical and Horizontal) with a `Scrollbar`.
    - Implement `_buildSkeletonRow()` for the blinking loading effect.
- **Modern Loading**:
    - Add the `_BlinkingSkeleton` widget (private or shared).
    - Update `_buildTableContainer` to show skeleton rows when `controller.isLoading` is true.
- **Keyboard & Responsiveness**:
    - Enable `resizeToAvoidBottomInset`.
    - Ensure the layout adapts to different screen orientations.

## Verification Plan

### Manual Verification
- [ ] Confirm AppBar shows title and subtitle correctly.
- [ ] Verify drawer is removed and back button works.
- [ ] Test "Pending" and "History" toggle functionality.
- [ ] Verify both vertical and horizontal scrolling in the table.
- [ ] Confirm modern blinking loading animation appears when fetching data.
