import 'package:get/get.dart';
import '../controllers/wallet_controller.dart';
import '../controllers/gift_controller.dart';
import '../../../data/repositories/wallet_repository.dart';
import '../../../data/repositories/coin_repository.dart';
import '../../../data/repositories/gift_repository.dart';
import '../../../data/repositories/delivery_repository.dart';
import '../../../data/repositories/rate_repository.dart';
import '../../../data/datasources/wallet_remote_datasource.dart';
import '../../../data/datasources/coin_remote_datasource.dart';
import '../../../data/datasources/delivery_remote_datasource.dart';
import '../../../data/datasources/gift_remote_datasource.dart';
import '../../../data/datasources/rate_remote_datasource.dart';

class WalletBinding extends Bindings {
  @override
  void dependencies() {
    // DataSources
    Get.lazyPut<WalletRemoteDataSource>(
      () => WalletRemoteDataSourceImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<CoinRemoteDataSource>(
      () => CoinRemoteDataSourceImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<DeliveryRemoteDataSource>(
      () => DeliveryRemoteDataSourceImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<GiftRemoteDataSource>(
      () => GiftRemoteDataSourceImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<RateRemoteDataSource>(
      () => RateRemoteDataSourceImpl(Get.find()),
      fenix: true,
    );

    // Repositories
    Get.lazyPut<WalletRepository>(
      () => WalletRepositoryImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<CoinRepository>(
      () => CoinRepositoryImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<DeliveryRepository>(
      () => DeliveryRepositoryImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<GiftRepository>(
      () => GiftRepositoryImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<RateRepository>(
      () => RateRepositoryImpl(Get.find()),
      fenix: true,
    );

    // Controllers
    Get.lazyPut<WalletController>(
      () => WalletController(
        walletRepository: Get.find<WalletRepository>(),
        coinRepository: Get.find<CoinRepository>(),
        deliveryRepository: Get.find<DeliveryRepository>(),
      ),
      fenix: true,
    );

    Get.lazyPut<GiftController>(
      () => GiftController(
        giftRepository: Get.find<GiftRepository>(),
        walletRepository: Get.find<WalletRepository>(),
        coinRepository: Get.find<CoinRepository>(),
        rateRepository: Get.find<RateRepository>(),
      ),
      fenix: true,
    );
  }
}
