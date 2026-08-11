# Implementation Plan - History Module Filter and Scroll Fix

The user wants to add a time filter (Today, This Week, This Month, All) to the Transaction History screen and update the UI so that the search bar and filters scroll away under the fixed AppBar.

## Proposed Changes

### [History Module]

#### [MODIFY] [history_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/history/controllers/history_controller.dart)
- Update `dateFilter` options to `all`, `today`, `week`, `month`.
- Update `applyFilters` logic to handle these new time periods correctly based on the current date.

#### [MODIFY] [history_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/history/views/history_view.dart)
- Refactor the `body` from a `Column` with `Expanded(ListView)` to a `CustomScrollView`.
- Move `_buildFilters` into a `SliverToBoxAdapter` so it scrolls with the list.
- Add `_buildTimeFilters` widget below the existing dropdowns.
- Implement `_buildTimeChip` for a modern, selectable filter UI.
- Ensure `RefreshIndicator` works correctly with the new `CustomScrollView` structure.
- Update skeleton loader to work within the sliver-based layout.

## Verification Plan

### Manual Verification
- Verify that the "Today" filter shows transactions from the current day.
- Verify that "This Week" shows transactions since the most recent Monday.
- Verify that "This Month" shows transactions from the current month.
- Verify that scrolling the list causes the Search bar, Dropdowns, and Time Filters to scroll up and disappear under the "Transaction History" AppBar.
- Verify that the AppBar remains fixed at the top.
- Verify that the "All Type" and "All Metal" filters still work in combination with the new time filter.
