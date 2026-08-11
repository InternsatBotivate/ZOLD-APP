# Implementation Plan - Fix Home Drawer UI

The goal is to update the `HomeDrawer` widget to match the provided UI design, which features a clean, "Next.js-like" sidebar with specific brand styling, golden active states, and organized sections.

## Proposed Changes

### [Component Name] UI Layer

#### [MODIFY] [home_drawer.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/core/widgets/home_drawer.dart)

1.  **Brand Section**:
    *   Replace the current square icon with a circular `CircleAvatar` displaying `assets/images/02.png`.
    *   Adjust text styling for "Zold" and "Metal" to match the clean layout.
2.  **Menu & Admin Sections**:
    *   Update section labels ("MENU", "ADMIN") to be more subtle and uppercase.
    *   Refine the separator line in the Admin section.
3.  **Active Item Styling**:
    *   Improve the golden gradient for active items.
    *   Add a subtle shadow to the active item container.
    *   Add the golden dot indicator on the right side of the active item.
4.  **Icons & Spacing**:
    *   Update icons for all items to be consistent with the design (mostly outlined style).
    *   Adjust vertical spacing (margins) between items for a more open feel.
5.  **Bottom Actions**:
    *   Refine "Logout" and "Collapse" items at the bottom.

## Verification Plan

### Manual Verification
- Open the drawer in the app.
- Verify the brand logo is circular and uses the correct asset.
- Verify the active item (Home by default) has the golden gradient and dot.
- Verify the "Logout" button is red and "Collapse" is at the bottom.
- Navigate to different sections and ensure the active state updates correctly (if routes are handled).
