import 'package:get/get.dart';
import '../controllers/buy_sell_controller.dart';
import '../../../data/repositories/purchase_repository.dart';
import '../../../data/repositories/rate_repository.dart';
import '../../../data/repositories/wallet_repository.dart';
import '../../../data/datasources/purchase_remote_datasource.dart';
import '../../../data/datasources/rate_remote_datasource.dart';
import '../../../data/datasources/wallet_remote_datasource.dart';
import 'package:dio/dio.dart';

class BuySellBinding extends Bindings {
  @override
  void dependencies() {
    final dio = Get.find<Dio>();

    Get.lazyPut<PurchaseRemoteDataSource>(
      () => PurchaseRemoteDataSourceImpl(dio),
    );
    Get.lazyPut<PurchaseRepository>(
      () => PurchaseRepositoryImpl(Get.find<PurchaseRemoteDataSource>()),
    );

    Get.lazyPut<RateRemoteDataSource>(() => RateRemoteDataSourceImpl(dio));
    Get.lazyPut<RateRepository>(
      () => RateRepositoryImpl(Get.find<RateRemoteDataSource>()),
    );

    Get.lazyPut<WalletRemoteDataSource>(() => WalletRemoteDataSourceImpl(dio));
    Get.lazyPut<WalletRepository>(
      () => WalletRepositoryImpl(Get.find<WalletRemoteDataSource>()),
    );

    Get.lazyPut<BuySellController>(
      () => BuySellController(
        purchaseRepository: Get.find<PurchaseRepository>(),
        rateRepository: Get.find<RateRepository>(),
        walletRepository: Get.find<WalletRepository>(),
      ),
    );
  }
}
