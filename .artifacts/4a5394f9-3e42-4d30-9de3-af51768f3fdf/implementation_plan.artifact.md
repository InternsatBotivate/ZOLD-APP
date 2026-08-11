# Modern UI Enhancements and Parity Plan

This plan aims to update the app's UI to match the Next.js frontend styling, improve responsiveness, and add modern features like password visibility toggles and improved notification indicators.

## Proposed Changes

### [Component] Home Page Enhancements

#### [MODIFY] [home_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/home/views/home_view.dart)
- **Quick Actions**: Update `_buildQuickActions` and `_buildActionItem` to match the provided screenshot:
    - Use dark, rounded cards for each action.
    - Standardize icon background colors (Goals: Pink, Gift: Gold, Refer: Blue, SIP: Green).
    - Align with the Next.js design system (dark surfaces, specific spacing).
- **Notifications**: Change the unread notification indicator from a numbered badge to a modern, subtle red dot positioned at the top-right of the icon.

#### [MODIFY] [cart_button.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/cart/widgets/cart_button.dart)
- Update icon color to use `Theme.of(context).colorScheme.onSurface` for better light/dark mode support.
- Improve the badge styling (border and colors) to be more consistent with the new UI theme.

### [Component] Authentication

#### [MODIFY] [login_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/auth/controllers/login_controller.dart)
- Add an `obscurePassword` observable (`RxBool`) to manage password visibility.
- Add a toggle method.

#### [MODIFY] [login_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/auth/views/login_view.dart)
- Add a suffix icon (eye/eye-off) to the password `TextField` to toggle visibility.
- Bind the `obscureText` property to the new controller observable.

### [Component] Buy/Sell Flow

#### [MODIFY] [buy_sell_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/buy_sell/views/buy_sell_view.dart)
- **Cancel Button**: Fix the cancel button in `_buildReviewState` to be more responsive and professional.
    - Ensure it fits well within the layout on smaller screens.
    - Update its style to match the platform's secondary button design (outlined or subtle background).

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure no syntax or type errors.

### Manual Verification
- **Home View**: Verify Quick Actions match the screenshot (dark cards, colored icons). Check the new notification dot.
- **Cart Button**: Switch between Dark and Light mode to ensure visibility.
- **Login View**: Test the password visibility toggle.
- **Buy/Sell View**: Verify the Cancel button layout on different screen sizes (using the emulator's resize feature if available, or checking layout bounds).
