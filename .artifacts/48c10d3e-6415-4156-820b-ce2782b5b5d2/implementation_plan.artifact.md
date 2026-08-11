# Phase 5.4 — Memory Leak Fix (Production Hardening)

This plan addresses verified memory leak issues in the Flutter project, focusing on socket listeners, controller disposal, worker cleanup, and timer management.

## User Review Required

> [!IMPORTANT]
> - Controllers created inside `build()` in `AdminView` will be moved to `AdminController` to ensure proper lifecycle management.
> - `TextEditingController`s in dialogs and bottom sheets will be moved to the respective parent controller or managed via `StatefulWidget` where appropriate.
> - GetX Workers (`ever`, `once`, `debounce`, `interval`) will now be stored and disposed in `onClose`.

## Proposed Changes

### 1. Socket Listener Cleanup

#### [MODIFY] [buy_sell_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/buy_sell/controllers/buy_sell_controller.dart)
- Update `onClose` to remove 'goldPriceUpdate' and 'silverPriceUpdate' listeners from `SocketService`.

#### [MODIFY] [cart_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/cart/controllers/cart_controller.dart)
- Implement `onClose` to remove 'goldPriceUpdate' and 'silverPriceUpdate' listeners.

#### [MODIFY] [notifications_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/notifications/controllers/notifications_controller.dart)
- Implement `onClose` to remove 'notification' listener.

---

### 2. Controllers Created Inside build()

#### [MODIFY] [admin_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/admin/controllers/admin_controller.dart)
- Add `priceController` and `gstController` as members.
- Dispose them in `onClose`.

#### [MODIFY] [admin_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/admin/views/admin_view.dart)
- Update `MetalPricesView` and `GstManagementView` to use the controllers from `AdminController`.

---

### 3. Dialog / BottomSheet Controllers

#### [MODIFY] [sip_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/sip/controllers/sip_controller.dart)
- Add `nameController`, `amountController`, `dayOfMonthController` (or reuse) to manage dialog state if they need to persist or be disposed centrally.
- *Alternatively*: Use `StatefulWidget` for these bottom sheets to handle local controller disposal. I will check `sip_view.dart` to see if I can wrap the bottom sheets.

#### [MODIFY] [sip_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/sip/views/sip_view.dart)
- Wrap bottom sheet contents in `StatefulWidget` or use `onClosing` to dispose controllers.

#### [MODIFY] [deliveries_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/wallet/views/deliveries_view.dart)
- Update `_showOtpDialog` to dispose `otpController`.

---

### 4. Missing onClose() & GetX Workers

#### [MODIFY] [partners_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/partners/controllers/partners_controller.dart)
- Implement `onClose`.
- Store and dispose the `debounce` worker.
- Dispose `nameController`, `emailController`, `phoneController`, `usernameController`, `passwordController`.

#### [MODIFY] [gift_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/wallet/controllers/gift_controller.dart)
- Store and dispose the `debounce` worker in `onClose`.

#### [MODIFY] [sip_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/sip/controllers/sip_controller.dart)
- Store and dispose the `ever` worker in `onClose`.

#### [MODIFY] [history_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/history/controllers/history_controller.dart)
- Implement `onClose`.
- Store and dispose the `everAll` worker.

---

### 5. StatefulWidget Disposal

#### [MODIFY] [create_goal_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/goals/views/create_goal_view.dart)
- Add `dispose` method to `_CreateGoalViewState` to dispose `_nameController` and `_targetController`.

#### [MODIFY] [edit_goal_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/goals/views/edit_goal_view.dart)
- Add `dispose` method to `_EditGoalViewState` to dispose `_nameController` and `_targetController`.

---

### 6. Future / Timer Cleanup

#### [MODIFY] [sip_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/sip/controllers/sip_controller.dart)
- Replace `Future.doWhile` in `_showSuccessModal` with a `Timer` that is cancelled in `onClose` or when the dialog is closed.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure no new issues are introduced.

### Manual Verification
- Navigate through the app and verify:
    - No duplicate socket events (log checks).
    - No memory leaks (monitored via DevTools if possible, or by ensuring no crashes after heavy use).
    - Controllers are properly disposed (verified via debug logs if added).
