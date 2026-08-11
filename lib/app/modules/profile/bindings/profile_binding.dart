import 'package:get/get.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../data/repositories/purchase_repository.dart';
import '../../../data/datasources/profile_remote_datasource.dart';
import '../../../data/datasources/notification_local_datasource.dart';
import '../controllers/profile_controller.dart';
import '../controllers/security_privacy_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(Get.find()),
    );
    Get.lazyPut<NotificationLocalDataSource>(
      () => NotificationLocalDataSourceImpl(),
    );
    Get.lazyPut<ProfileRepository>(
      () => ProfileRepositoryImpl(Get.find(), Get.find()),
    );
    Get.lazyPut<SecurityPrivacyController>(
      () => SecurityPrivacyController(Get.find()),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(Get.find(), Get.find<PurchaseRepository>()),
    );
  }
}
