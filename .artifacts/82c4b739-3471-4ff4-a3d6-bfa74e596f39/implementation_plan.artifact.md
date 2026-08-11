# Saved Addresses UI/UX & API Integration Plan

The goal is to overhaul the "Saved Addresses" screen to match the provided design exactly, ensure proper API connectivity, and make the UI responsive and modern.

## User Review Required
> [!IMPORTANT]
> The UI will be updated to match the deep purple and gold theme seen in the images.
> I will assume "Partner Jeweller Location" is triggered when the address type is "OTHER" or based on the label containing "Jewellers".

## Proposed Changes

### Profile Module

#### [MODIFY] [saved_addresses_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/views/saved_addresses_view.dart)
- Update the layout to match the provided screenshots.
- Implement the deep purple "Add New" button in the AppBar.
- Redesign the info banner and address cards.
- Add "All Addresses (count)" section.
- Add "Quick Tips" section at the bottom.
- Add "Get Directions", "Edit", and "Delete" icons to address cards.
- Ensure the "Add/Edit" bottom sheet is keyboard responsive and uses a modern layout.
- Style the "Set as Default" button as per the design.

#### [MODIFY] [profile_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/controllers/profile_controller.dart)
- Ensure all address-related methods (`fetchAddresses`, `addAddress`, `updateAddress`, `deleteAddress`, `setPrimaryAddress`) are correctly implemented and handle loading states.

## Verification Plan

### Manual Verification
- Verify the list of addresses fetches correctly on load.
- Test "Add New Address" functionality (verify bottom sheet responsiveness).
- Test "Edit Address" functionality.
- Test "Delete Address" with confirmation dialog.
- Test "Set as Default" functionality.
- Verify UI responsiveness on different screen sizes and when keyboard is visible.
