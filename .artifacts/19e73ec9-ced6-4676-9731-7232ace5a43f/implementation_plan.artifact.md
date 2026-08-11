# Implementation Plan - Language Settings UI Redesign

Redesign the Language Settings screen to match the provided design screenshots, including a new header, current language section, and redesigned language selection items.

## User Review Required

> [!IMPORTANT]
> The redesign uses specific colors for the "Selected" state (light lavender background and dark purple border/checkmark) which align with the project's `authGradient` colors. Please verify if these match your branding expectations.

## Proposed Changes

### Profile Module

#### [MODIFY] [languages_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/views/languages_view.dart)
- Update `AppBar` to include a subtitle: "Choose your preferred language".
- Add "Current Language" section with a globe icon.
- Add "Available Languages" section header.
- Redesign language selection cards:
    - Add native script support.
    - Implement radio-button style selection.
    - Add highlight state for the selected language.
- Update bottom button to "Reset to Default Settings".

## Verification Plan

### Manual Verification
- Verify the layout matches the provided image.
- Ensure clicking a language updates the selection state.
- Check both Light and Dark mode appearance (the current code has dark mode logic, I will maintain it).
- Verify the "Reset to Default Settings" button is positioned at the bottom as shown.
