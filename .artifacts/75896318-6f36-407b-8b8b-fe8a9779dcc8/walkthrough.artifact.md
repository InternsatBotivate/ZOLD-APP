# Walkthrough - Centralized Theme Support

I have successfully updated the Flutter application's theme to match the desired dark mode aesthetic from the Next.js frontend, while keeping the light mode unchanged.

## Changes Made

### Core Theme
- Updated `app_colors.dart` with the precise dark palette:
    - Background: `#141414`
    - Surface/Card: `#1F1F1F`
- Refined `app_theme.dart` dark theme specifications, including `inputDecorationTheme` and `cardTheme` to ensure all standard Material components follow the new style.

### Buy/Sell Module
- Updated `buy_sell_view.dart` to use theme-aware backgrounds.
- Converted all hardcoded cards (Live Rate, Price Breakdown, Review) to react to dark mode.
- Ensured input fields and preset buttons match the dark aesthetic.

### Wallet & Portfolio
- Redesigned the Glassmorphism overview in `wallet_view.dart` to look stunning in dark mode using translucent overlays.
- Updated all metal holdings cards, breakdown items, and active delivery tracking components.
- Banners for SIP and Goals now have dark-mode optimized colors.

### Goals Module
- Updated `goals_view.dart` with a dark scaffold background and themed goal cards.
- Ensured progress indicators and status badges are legible and follow the color palette.

### SIP Module
- Theized the SIP header and available plans in `sip_view.dart`.
- Refined Active SIP cards with dark surfaces and gold accents.

## Verification Results
- Ran `flutter analyze` and verified that no new errors were introduced in the modified files.
- Manual inspection of the code ensures 100% functional parity with the previous version, changing only visual attributes.
