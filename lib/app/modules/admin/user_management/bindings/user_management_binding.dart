import 'package:get/get.dart';
import '../controllers/user_management_controller.dart';
import '../../../../data/repositories/admin_repository.dart';

class UserManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserManagementController>(
      () => UserManagementController(
        adminRepository: Get.find<AdminRepository>(),
      ),
    );
  }
}
