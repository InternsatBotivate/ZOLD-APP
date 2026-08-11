import 'package:get/get.dart';
import '../../../data/datasources/rate_remote_datasource.dart';
import '../../../data/datasources/wallet_remote_datasource.dart';
import '../../../data/datasources/coin_remote_datasource.dart';
import '../../../data/datasources/notification_remote_datasource.dart';
import '../../../data/repositories/rate_repository.dart';
import '../../../data/repositories/wallet_repository.dart';
import '../../../data/repositories/coin_repository.dart';
import '../../../data/repositories/notification_repository.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // DataSources
    Get.lazyPut<RateRemoteDataSource>(
      () => RateRemoteDataSourceImpl(Get.find()),
    );
    Get.lazyPut<WalletRemoteDataSource>(
      () => WalletRemoteDataSourceImpl(Get.find()),
    );
    Get.lazyPut<CoinRemoteDataSource>(
      () => CoinRemoteDataSourceImpl(Get.find()),
    );
    Get.lazyPut<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(Get.find()),
    );

    // Repositories
    Get.lazyPut<RateRepository>(() => RateRepositoryImpl(Get.find()));
    Get.lazyPut<WalletRepository>(() => WalletRepositoryImpl(Get.find()));
    Get.lazyPut<CoinRepository>(() => CoinRepositoryImpl(Get.find()));
    Get.lazyPut<NotificationRepository>(
      () => NotificationRepositoryImpl(Get.find()),
    );

    // Controller
    Get.lazyPut<HomeController>(
      () => HomeController(
        rateRepository: Get.find(),
        walletRepository: Get.find(),
        coinRepository: Get.find(),
        notificationRepository: Get.find(),
        authRepository: Get.find(),
      ),
    );
  }
}
