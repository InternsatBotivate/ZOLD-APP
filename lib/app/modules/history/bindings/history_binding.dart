import 'package:get/get.dart';
import '../controllers/history_controller.dart';
import '../../../data/repositories/wallet_repository.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryController>(
      () => HistoryController(walletRepository: Get.find<WalletRepository>()),
    );
  }
}
