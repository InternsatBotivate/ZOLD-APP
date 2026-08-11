# Implementation Plan - FAQ Page Refactor

The goal is to convert the existing FAQ bottom sheet into a dedicated page with a UI that matches the provided screenshots.

## Proposed Changes

### Profile Module

#### [MODIFY] [faq_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/views/faq_view.dart)
- Convert the root `Container` to a `Scaffold`.
- Implement a custom `AppBar` or header that follows the screenshot:
    - Back button.
    - Title: "FAQ & Help Center".
    - Subtitle: "Find answers to common questions".
    - Help icon in a circular container.
- Refine the Search Bar:
    - Background color, border radius, and prefix/suffix icons.
- Refine "Browse by Category":
    - Filter chips with counts.
    - Active/Inactive states.
- Refine FAQ Cards:
    - Category badge at the top of each card.
    - Question text style.
    - Expansion logic and answer text style.
- Refine "Still need help?" Section:
    - Use the purple gradient (`AppColors.sipHeaderStart` to `AppColors.sipHeaderEnd`).
    - Inner cards for Call, Chat, and Email support.
    - "Open in new" icons for support options.

#### [MODIFY] [profile_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/views/profile_view.dart)
- Update the FAQ menu item to navigate to `Routes.faq` using `Get.toNamed()` instead of showing a bottom sheet.
- Clean up the `_showFAQSheet` method if it's no longer needed.

## Verification Plan

### Manual Verification
- Navigate to the Profile screen.
- Click on "FAQ".
- Verify that it opens as a new page.
- Check the UI against the provided screenshots for:
    - Header layout and icons.
    - Search bar appearance.
    - Category chips.
    - FAQ card expansion and category badges.
    - "Still need help?" section gradient and inner cards.
- Test search functionality.
- Test category filtering.
- Test support links (Call, Chat, Email).
