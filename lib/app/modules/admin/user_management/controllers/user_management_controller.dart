import 'package:get/get.dart';
import '../../../../data/repositories/admin_repository.dart';
import '../../../../data/models/auth_models.dart';
import '../../../../data/models/admin_models.dart';
import '../../../../core/utils/snackbar_utils.dart';

class UserManagementController extends GetxController {
  final AdminRepository _adminRepository;
  UserManagementController({required AdminRepository adminRepository})
    : _adminRepository = adminRepository;

  final isLoading = false.obs;
  final users = <User>[].obs;

  // Search and Filter
  final searchTerm = ''.obs;
  final filterRole = 'ALL'.obs;

  // Transaction History
  final selectedUser = Rxn<User>();
  final transactionHistory = Rxn<UserTransactionHistory>();
  final loadingTransactions = false.obs;
  final modalTab = 'metals'.obs;

  List<User> get filteredUsers {
    return users.where((user) {
      final matchesSearch =
          user.name.toLowerCase().contains(searchTerm.value.toLowerCase()) ||
          user.email.toLowerCase().contains(searchTerm.value.toLowerCase());

      final matchesRole =
          filterRole.value == 'ALL' || user.role == filterRole.value;

      return matchesSearch && matchesRole;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    isLoading.value = true;
    try {
      final response = await _adminRepository.getAllUsers();
      users.value = response.data ?? [];
    } catch (e) {
      SnackbarUtils.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserTransactions(String userId) async {
    loadingTransactions.value = true;
    transactionHistory.value = null;
    try {
      final response = await _adminRepository.getUserTransactionHistory(userId);
      transactionHistory.value = response.data;
    } catch (e) {
      SnackbarUtils.showError('Failed to fetch transaction history');
    } finally {
      loadingTransactions.value = false;
    }
  }

  void selectUser(User user) {
    selectedUser.value = user;
    fetchUserTransactions(user.id);
  }
}
