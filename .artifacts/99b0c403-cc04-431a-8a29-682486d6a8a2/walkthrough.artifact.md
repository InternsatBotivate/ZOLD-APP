# Walkthrough - Buy/Sell UI and Loading Fixes

I have fixed the UI issues in the Buy/Sell screen, focusing on input field styling, button loading states, and a better data loading experience.

## Changes

### [Buy/Sell Module]

#### [buy_sell_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/buy_sell/views/buy_sell_view.dart)
- **Removed Full-Screen Loading:** The screen layout (input fields, tabs, etc.) is now visible immediately. Only the data-dependent parts show a shimmer effect while loading.
- **Redesigned Input Fields:**
    - Used `OutlineInputBorder` directly within `TextField` for a cleaner look.
    - Added a `focusedBorder` that matches the metal type (Gold or Silver).
    - Ensured the input box is fully covered and has proper padding.
    - Added bold prefix and suffix text for better visibility.
- **Component-Level Shimmer:**
    - Added internal shimmer loading to the `Price Breakdown` section.
    - Kept existing shimmer for `Live Rate` and `Sell Cards`.
- **Button Loading:**
    - Verified that `MetalButton` correctly shows a circular loading indicator when `isLoading` is true.
    - Ensured transitions from "Buy" to "Pay" work smoothly with appropriate loading states.

## Verification Results

### Manual Verification
- ✅ **Input Fields:** The amount and grams boxes now have clear borders and fill the space correctly. They highlight in gold/silver when clicked.
- ✅ **Loading Experience:** When opening the screen from the drawer, the UI stays stable while only the rates "blink" (shimmer) until they are ready.
- ✅ **Button Feedback:** Clicking "Buy" now shows a spinner inside the button, and it switches to the payment summary screen once the session is ready.
