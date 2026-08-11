import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../controllers/gst_management_controller.dart';
import '../../../../data/repositories/admin_repository.dart';

class GstManagementBinding extends Bindings {
  @override
  void dependencies() {
    debugPrint("DEBUG: GST Management Binding - dependencies() called");

    Get.lazyPut<GstManagementController>(() {
      debugPrint(
        "DEBUG: GST Management Binding - Creating GstManagementController instance",
      );
      return GstManagementController(
        adminRepository: Get.find<AdminRepository>(),
      );
    });
  }
}
