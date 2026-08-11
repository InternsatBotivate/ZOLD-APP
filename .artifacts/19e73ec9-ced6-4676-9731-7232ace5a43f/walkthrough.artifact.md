# Walkthrough - Language Settings UI Redesign

The Language Settings screen has been completely redesigned to match the provided design specifications.

## Changes Made

### Profile Module

#### [languages_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/views/languages_view.dart)
- **Updated AppBar**: Added a subtitle "Choose your preferred language" and styled the title for better hierarchy.
- **Current Language Section**: Added a specialized card at the top displaying the currently active language with a globe icon and a subtle region indicator ("US").
- **Available Languages List**:
    - Redesigned selection items into cards with distinct states.
    - Added native script subtitles for each language (e.g., Hindi -> हिन्दी).
    - Implemented a radio-button style selection indicator (circular checkmark when selected).
    - Applied a highlight background and border color for the selected language.
- **Bottom Navigation Bar**: Replaced the "Save" button with a "Reset to Default Settings" outlined button as per the design.

## Verification Results

### Manual Verification
- **Layout**: Verified that the AppBar, Current Language section, and Available Languages list align with the requested UI.
- **Interactivity**: Tapping a language card successfully updates the `selectedLanguage` state and highlights the selection.
- **Dark Mode**: Maintained dark mode compatibility with appropriate background and border colors.
- **Responsiveness**: Used `SingleChildScrollView` to ensure the list is scrollable on smaller screens.

render_diffs(file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/views/languages_view.dart)
