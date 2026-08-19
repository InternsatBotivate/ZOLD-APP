import 'package:get/get.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../data/repositories/admin_repository.dart';
import '../../../../data/models/admin_models.dart';

class SellRequestsController extends GetxController {
  final AdminRepository _adminRepository;
  SellRequestsController({required AdminRepository adminRepository})
    : _adminRepository = adminRepository;

  final isLoading = false.obs;
  final sellRequests = <SellRequest>[].obs;
  final sellFilter = 'PENDING'.obs; // PENDING or HISTORY
  final actionLoading = false.obs;

  List<SellRequest> get filteredSellRequests {
    if (sellFilter.value == 'PENDING') {
      return sellRequests.where((t) => t.status == 'PENDING').toList();
    }
    return sellRequests
        .where(
          (t) =>
              t.status == 'COMPLETED' ||
              t.status == 'REJECTED' ||
              t.status == 'FAILED',
        )
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchSellRequests();
  }

  Future<void> fetchSellRequests() async {
    isLoading.value = true;
    try {
      final response = await _adminRepository.getSellRequests();
      sellRequests.value = response.data ?? [];
    } catch (e) {
      SnackbarUtils.showError('Failed to fetch sell requests');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> approveSellRequest(String id) async {
    actionLoading.value = true;
    try {
      await _adminRepository.approveSellRequest(id);
      await fetchSellRequests();
      Get.back(); // Close modal if open
      SnackbarUtils.showSuccess('Request approved');
    } catch (e) {
      SnackbarUtils.showError('Failed to approve request. Please try again.');
    } finally {
      actionLoading.value = false;
    }
  }

  Future<void> rejectSellRequest(String id, String remark) async {
    if (remark.trim().isEmpty) {
      SnackbarUtils.showError('Rejection reason is required');
      return;
    }
    actionLoading.value = true;
    try {
      await _adminRepository.rejectSellRequest(id, remark);
      await fetchSellRequests();
      Get.back(); // Close modal if open
      SnackbarUtils.showSuccess('Request rejected');
    } catch (e) {
      SnackbarUtils.showError('Failed to reject request. Please try again.');
    } finally {
      actionLoading.value = false;
    }
  }
}
