# Full Application Theme Audit & Implementation

This plan outlines the systematic removal of hardcoded colors and the implementation of a centralized, responsive theme across all modules of the Zold Gold Flutter application.

## User Review Required

> [!IMPORTANT]
> The theme implementation will ensure that all UI components react instantly to theme changes (System, Light, Dark) and that no hardcoded colors remain in the UI layer.

## Proposed Changes

### [Phase 1: Admin & Partners]

#### [MODIFY] [gst_management_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/admin/gst_management/views/gst_management_view.dart)
- Replace all hardcoded hex colors with `Theme.of(context)` equivalents.
- Ensure the gradient in `_buildRateDisplay` is theme-aware.
- Fix hardcoded white surfaces and background colors.

#### [MODIFY] [metal_price_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/admin/metal_price/views/metal_price_view.dart)
- Replace hardcoded colors in market banners and metal cards.
- Ensure "Live" and "Old" badges use semantic theme colors.
- Fix hardcoded white surfaces.

#### [MODIFY] [user_management_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/admin/user_management/views/user_management_view.dart)
- Replace hardcoded colors in filters and user table.
- Ensure role and status badges use theme-aware colors.
- Update dialog content to be theme-aware.

#### [MODIFY] [sell_requests_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/admin/sell_requests/views/sell_requests_view.dart)
- Complete theme integration for any remaining hardcoded colors (badges, text).

#### [MODIFY] [partners_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/partners/views/partners_view.dart)
- Replace hardcoded background colors (e.g., `Color(0xFFFDF8E8)`).
- Ensure partner cards and badges (BIS, ISO, Sequoia) use theme-aware colors.
- Fix hardcoded colors in search bar and toggle buttons.

---

### [Phase 2: Full Application Audit]

#### [Audit & Refactor] Remaining Modules
- **Splash & Auth**: `auth_background.dart`, `login_view.dart`, `signup_view.dart`.
- **Main & Home**: `main_view.dart`, `home_view.dart`, `home_drawer.dart`.
- **Buy/Sell**: `buy_sell_view.dart`, `metal_button.dart`, `glass_input_field.dart`.
- **Wallet & Portfolio**: `wallet_view.dart`, `deliveries_view.dart`.
- **Goals & SIP**: `goals_view.dart`, `sip_view.dart`, `sip_calculator_view.dart`.
- **Cart & Checkout**: `cart_drawer.dart`, `coin_checkout_view.dart`.
- **Profile & KYC**: `profile_view.dart`, `kyc_view.dart`.

---

### [Phase 3: Core Theme Optimization]

#### [MODIFY] [app_colors.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/core/theme/app_colors.dart)
- Remove deprecated/legacy color aliases.
- Add semantic colors if necessary to support specific module requirements (e.g., metal-specific tints).

#### [MODIFY] [app_theme.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/core/theme/app_theme.dart)
- Ensure `ColorScheme` covers all semantic needs.
- Fine-tune component themes (Card, AppBar, Button) for both Light and Dark modes.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure no linting errors or deprecated API usage.

### Manual Verification
1. **Theme Switch**: Navigate to Profile and toggle between System, Light, and Dark modes. Verify all screens update instantly.
2. **Persistence**: Restart the app and verify the selected theme persists.
3. **Module Audit**: Manually check each module for hardcoded color remnants or UI flickering during theme transitions.
4. **Contrast Check**: Ensure text legibility in both light and dark modes, especially in the Admin and Partners modules.
