# Buy Coins - Phase 3 (UX) Implementation Plan

Enhance the user experience of the Buy Coins flow with improved responsiveness, animations, and refined layouts, strictly following Next.js as the source of truth.

## User Review Required

> [!NOTE]
> - UX improvements focus on visual polish and responsiveness without changing core logic.
> - All animations will be subtle and high-performance.

## Proposed Changes

### [Common]

#### [MODIFY] [CartButton](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/cart/widgets/cart_button.dart)
- Refine `ScaleTransition` for the badge to be more subtle.
- Add a slight bounce effect to the badge when the count changes.

### [Gold Coins Module]

#### [MODIFY] [GoldCoinsView](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/gold_coins/views/gold_coins_view.dart)
- Improve responsive grid `childAspectRatio` based on device width to prevent layout stretching.
- Enhance `_buildShimmerGrid` to match the actual `CoinCard` layout exactly.
- Add `FadeTransition` when switching between metal tabs.

#### [MODIFY] [CoinCard](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/gold_coins/widgets/coin_card.dart)
- Adjust image container to use `AspectRatio` for consistent sizing across devices.
- Refine spacing and typography to match Next.js high-end aesthetic.
- Ensure `InkWell` ripple is properly bounded and visually pleasing.

### [Cart Module]

#### [MODIFY] [CartDrawer](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/cart/widgets/cart_drawer.dart)
- Add `SafeArea` to the bottom of the footer to handle devices with home indicators (e.g., iPhone/newer Androids).
- Improve quantity control button interaction feedback.

### [Checkout Module]

#### [MODIFY] [CoinCheckoutView](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/coin_checkout/views/coin_checkout_view.dart)
- Ensure keyboard avoidance works perfectly for the payment flow.
- Enhance shimmer loading for the checkout summary.
- Refine spacing in the success state popup.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure no UI regressions.

### Manual Verification
1. **Responsiveness**: Rotate device or use different screen sizes.
   - **Expect**: Grid adapts correctly without overflowing or extreme stretching.
2. **Animations**: Add/Remove items.
   - **Expect**: Cart badge pulses subtly; product card quantity swaps smoothly.
3. **Loading**: Trigger a refresh or initial load.
   - **Expect**: Shimmer placeholders align perfectly with the incoming content.
4. **SafeArea**: Check drawer on a device with a notch/home indicator.
   - **Expect**: Checkout button is not obscured by the system navigation bar.
