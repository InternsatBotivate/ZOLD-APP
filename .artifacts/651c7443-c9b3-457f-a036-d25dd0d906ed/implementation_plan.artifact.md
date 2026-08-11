# Implementation Plan - Fully Functional Download for Risk Disclosure

Make the "Download" button in the `RiskDisclosureView` fully functional by implementing a robust file download and saving mechanism.

## User Review Required

> [!IMPORTANT]
> This implementation will add new dependencies: `path_provider`, `permission_handler`, and `dio` (already present). These are necessary to manage file storage and permissions on Android/iOS.
>
> I will also add a dummy PDF URL in `ApiConstants` as a placeholder. In a production environment, this should be replaced with the actual document URL.

## Proposed Changes

### Core Logic

#### [MODIFY] [pubspec.yaml](file:///C:/Users/PCv/StudioProjects/zold_gold/pubspec.yaml)
- Add `path_provider: ^2.1.3`
- Add `permission_handler: ^11.3.1`

#### [MODIFY] [api_constants.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/core/constants/api_constants.dart)
- Add `static const String riskDisclosurePdfUrl = 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';` (Placeholder URL).

#### [NEW] [file_utils.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/core/utils/file_utils.dart)
- Create a utility class `FileUtils` with a static method `downloadFile`.
- Implement logic to:
    - Request storage permissions.
    - Determine the correct download directory (Downloads folder for Android).
    - Use `Dio` to download the file with progress tracking.
    - Show GetX-based Snackbars for success/failure/progress.

### Profile Module

#### [MODIFY] [risk_disclosure_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/views/risk_disclosure_view.dart)
- Connect the `Icons.download_outlined` button to the `FileUtils.downloadFile` method.
- Add a loading state or feedback during the download.

## Verification Plan

### Manual Verification
- Tap the download button.
- Verify that a permission request appears (if not already granted).
- Check the "Downloads" folder on the device for the saved `risk_disclosure.pdf`.
- Confirm success/error snackbars appear correctly.
