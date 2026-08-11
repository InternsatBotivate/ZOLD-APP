# Fix Cart Price Display and Overflow

The previous fix used `Expanded` with `TextOverflow.ellipsis` on the price, which avoided the `RenderFlex` error but hid the full price. The goal is to show the price fully without any overflow.

## Proposed Changes

### Cart Drawer

#### [MODIFY] [cart_drawer.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/cart/widgets/cart_drawer.dart)

1.  **Cart Item Bottom Row**:
    - Replace the `Row` containing the quantity selector and price with a `Wrap` widget.
    - Set `alignment: WrapAlignment.spaceBetween` and `crossAxisAlignment: WrapCrossAlignment.center`.
    - This ensures that if horizontal space is insufficient, the price will automatically move to the next line instead of being truncated or causing an overflow error.
2.  **Price Text**:
    - Remove `Expanded` and `TextOverflow.ellipsis` from the price `Text` widget to ensure the full amount is always visible.
3.  **Item Title**:
    - Keep `maxLines: 1` and `ellipsis` for the title to maintain vertical consistency, but ensure it doesn't interfere with the price.

## Verification Plan

### Manual Verification
- Add items with large prices (e.g., Gold bars) and verify the price is shown fully.
- Test on narrow screens to ensure the `Wrap` widget correctly moves the price to a new line if needed, preventing any yellow/black overflow stripes.
