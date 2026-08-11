# Auspicious Days Module - 100% Next.js UI/UX Migration

This plan outlines the steps to recreate the complete Auspicious Days module in Flutter, matching the Next.js application pixel-by-pixel in terms of UI, UX, and logic.

## User Review Required

> [!IMPORTANT]
> The implementation will use the `tithi_engine` package in Flutter to replicate the Panchang calculations used in Next.js (`@ishubhamx/panchangam-js`). I will ensure the festival list and Pushya Nakshatra logic match the Next.js implementation.

> [!NOTE]
> I will create a dedicated `AuspiciousDaysController` and `AuspiciousDaysBinding` to handle the module's state and logic, keeping it separate from `HomeController` for better maintainability.

## Proposed Changes

### [Core] [Auspicious Days Module]

#### [NEW] [auspicious_days_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/home/controllers/auspicious_days_controller.dart)
- Handle calculation of Today's Panchang (Tithi, Nakshatra, Masa, Sunrise).
- Fetch and filter upcoming auspicious days (Monthly vs Festival tabs).
- Port significance logic, benefits, and metadata from Next.js.
- Handle Auto-Buy state and validation.

#### [NEW] [auspicious_days_binding.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/home/bindings/auspicious_days_binding.dart)
- Define dependencies for the Auspicious Days module.

#### [MODIFY] [app_pages.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/routes/app_pages.dart)
- Add `AuspiciousDaysBinding` to the `Routes.auspiciousDays` page entry.

#### [MODIFY] [auspicious_days_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/home/views/auspicious_days_view.dart)
- Recreate the UI exactly like Next.js:
    - Golden Header with Calendar and Close icons.
    - Today's Panchang card with purple gradient.
    - Info banner (Schedule auto-buy...).
    - Animated Tabs (Monthly Auspicious Days vs Festival Days).
    - Upcoming day cards with date boxes and chevrons.
    - "Why Buy Gold" section at the bottom.
- Implement the Detail Bottom Sheet/Full Screen Page:
    - Gradient header matching the festival color.
    - Countdown card.
    - Significance and Special Benefits sections.
    - Setup Auto-Buy section with amount input, chips, and enable switch.
    - Primary "Schedule Auto-Buy" action.

#### [MODIFY] [home_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/home/views/home_view.dart)
- Update `_buildAuspiciousDaysBanner` to match Next.js styling (gradients, icons, typography).

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure no errors or warnings.
- Verify that `tithi_engine` calculations for today match the expected values for a known date.

### Manual Verification
- **UI Match**: Compare every screen (Banner, List, Detail) with Next.js side-by-side.
- **Theme**: Verify Light and Dark mode appearance.
- **Responsive**: Test on different screen sizes and orientations.
- **Logic**: Ensure the next auspicious day displayed on the home banner matches the first item in the Auspicious Days list.
- **Interaction**: Verify tab switching animations and bottom sheet transitions.
