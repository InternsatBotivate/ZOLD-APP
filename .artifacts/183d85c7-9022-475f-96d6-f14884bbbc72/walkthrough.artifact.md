# Walkthrough - Compact Home Module Cards

I have reduced the height and tightened the layout of the rate and portfolio cards in the Home module to make it more compact while maintaining responsiveness.

## Changes Made

### [Home Module]

#### [home_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/home/views/home_view.dart)

- **Rate Cards**:
    - Reduced hardcoded height from `95` to `80`.
    - Tightened padding to `vertical: 8`.
    - Slightly reduced font sizes for metal name (`15` -> `14`) and price (`17` -> `16`).
- **Portfolio Cards**:
    - Reduced overall padding from `12` to `10`.
    - Reduced vertical spacing between price and wallet details from `8` to `6`.
    - Compacted "Gold Bar" and "Coins" info boxes by reducing vertical padding from `6` to `4`.
    - Reduced price font size from `16` to `15`.
- **Trade Buttons**:
    - Increased image size from `56` to `68` for better visibility.
    - Slightly increased container height from `90` to `95` to accommodate larger images.
- **Shimmers**:
    - Updated `_buildShimmerRateCard` height to `80`.
    - Updated `_buildShimmerPortfolioCard` height to `85`.

## Verification Results

### Manual Verification
- The cards now take up less vertical space, allowing more content to be visible on smaller screens.
- Responsiveness is maintained as the cards are inside a `Flexible`/`Expanded` layout within the hero section's `Row`.
- Text legibility remains high despite the small reduction in font sizes.

render_diffs(file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/home/views/home_view.dart)
