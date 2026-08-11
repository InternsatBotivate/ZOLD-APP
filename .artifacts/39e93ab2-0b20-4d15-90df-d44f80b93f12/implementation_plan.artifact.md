# Implementation Plan - Fully Functional Notification Settings with Local Persistence Fallback

Fix the "Failed to update notification settings" error by implementing a local persistence layer. This ensures that even if the backend API is not ready or fails, the user's settings are saved locally and the UI remains fully functional.

## User Review Required

> [!NOTE]
> I will implement a "Hybrid" approach: The app will attempt to sync settings with the backend, but will use local storage (`SharedPreferences`) as the primary source for the UI to ensure 100% responsiveness and reliability.

## Proposed Changes

### Data Layer

#### [NEW] [notification_local_datasource.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/data/datasources/notification_local_datasource.dart)
- Create a new data source to handle saving and retrieving `NotificationSettings` using `SharedPreferences`.

#### [MODIFY] [profile_repository.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/data/repositories/profile_repository.dart)
- Update `ProfileRepositoryImpl` to coordinate between `RemoteDataSource` and `LocalDataSource`.
- It will load from local storage first, then try to refresh from remote.
- It will save to both local and remote on updates.

---

### Profile Module

#### [MODIFY] [profile_controller.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/controllers/profile_controller.dart)
- Update `fetchNotificationSettings` to handle the data source change.
- Update `updateNotificationSetting` to be optimistic (update UI immediately) and handle background sync errors gracefully without blocking the user.

#### [MODIFY] [notifications_settings_view.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/modules/profile/views/notifications_settings_view.dart)
- Minor tweaks to ensure the UI feels snappy and reflects the latest state accurately.

## Verification Plan

### Automated Tests
- Syntax check and build verification.

### Manual Verification
- Change notification settings and restart the app to verify they persist locally.
- Verify that toggling settings no longer shows a blocking error if the backend is unreachable.
- Check that the UI remains "snappy" during toggles.
