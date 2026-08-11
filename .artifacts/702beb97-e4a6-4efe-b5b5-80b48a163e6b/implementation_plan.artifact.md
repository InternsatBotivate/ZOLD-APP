# SIP Module Shimmer Loading Implementation Plan

The goal is to replace the current `CircularProgressIndicator` with a modern shimmer (blinking skeleton) loading effect in the SIP module. This will provide a better user experience by showing a skeleton of the content while data is being fetched from the API.

## User Review Required

> [!NOTE]
> I will use the `shimmer` package which is already present in `pubspec.yaml`. The loading state will mimic the actual layout of the SIP plans and active SIPs.

## Proposed Changes

### SIP Module

#### [MODIFY] [sip_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/sip/views/sip_view.dart)
- Import `shimmer` package.
- Replace `CircularProgressIndicator` in the `body` and `_buildActiveSipsSection` with custom shimmer widgets.
- Add `_buildShimmerLoading()` to mimic the `SipView` layout.
- Add `_buildActiveSipShimmer()` and `_buildPlanCardShimmer()` to mimic card layouts.

## Verification Plan

### Manual Verification
- Run the app and navigate to the SIP module.
- Observe the "blinking" shimmer effect while data is loading.
- Verify that the shimmer layout matches the actual content layout.
