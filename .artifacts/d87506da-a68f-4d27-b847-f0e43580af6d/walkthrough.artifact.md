# Walkthrough - Home Drawer UI Fix

I have updated the `HomeDrawer` to match the requested clean, modern UI design. The changes bring a "Next.js-like" sidebar feel to the Flutter app.

## Changes Made

### UI Enhancements
- **Circular Brand Logo**: Replaced the square logo with a circular `CircleAvatar` using the brand asset `assets/images/02.png`.
- **Active State Styling**:
    - Added a smooth horizontal golden gradient for active items.
    - Included a subtle shadow and a golden dot indicator on the right side.
    - Updated active text color to a deep charcoal black for better contrast.
- **Iconography**: Updated all drawer icons to their outlined versions or specific icons that match the design (e.g., `swap_horiz` for Buy/Sell, `handshake` for SIP).
- **Typography**: Applied `GoogleFonts.poppins` throughout with refined weights and sizes for headers and labels.
- **Section Headers**: Refined "MENU" and "ADMIN" labels with consistent uppercase styling and subtle coloring.
- **Bottom Actions**: Properly styled the "Logout" button in red and the "Collapse" option at the very bottom.

### Logic Improvements
- **Tab Persistence**: Updated the `isActive` logic for "Home", "Portfolio", and "Profile" to correctly highlight when the user is on the respective tab within the `MainView`.
- **Navigation Safety**: Added checks to ensure that if a user clicks a tab while on a different route, they are navigated back to the `MainView` with the correct tab selected.

## Verification Results

### Manual Verification
- Verified the brand logo is circular and displays the `02.png` asset.
- Verified the "Home" item is active by default with the golden background.
- Verified that "Logout" is clearly visible in red at the bottom.
- Verified the spacing and dividers match the provided screenshots.

render_diffs(file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/core/widgets/home_drawer.dart)
