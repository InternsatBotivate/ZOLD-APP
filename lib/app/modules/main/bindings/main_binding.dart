import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../wallet/controllers/wallet_controller.dart';
import '../../../data/datasources/rate_remote_datasource.dart';
import '../../../data/datasources/wallet_remote_datasource.dart';
import '../../../data/datasources/coin_remote_datasource.dart';
import '../../../data/datasources/notification_remote_datasource.dart';
import '../../../data/datasources/gift_remote_datasource.dart';
import '../../../data/datasources/delivery_remote_datasource.dart';
import '../../../data/datasources/partner_remote_datasource.dart';
import '../../../data/repositories/rate_repository.dart';
import '../../../data/repositories/wallet_repository.dart';
import '../../../data/repositories/coin_repository.dart';
import '../../../data/repositories/notification_repository.dart';
import '../../../data/repositories/gift_repository.dart';
import '../../../data/repositories/delivery_repository.dart';
import '../../../data/repositories/partner_repository.dart';
import '../../../data/datasources/cart_remote_datasource.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../data/datasources/profile_remote_datasource.dart';
import '../../../data/datasources/notification_local_datasource.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../wallet/controllers/gift_controller.dart';
import '../../wallet/controllers/delivery_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../../data/repositories/purchase_repository.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());

    // Remote Data Sources
    Get.lazyPut<RateRemoteDataSource>(
      () => RateRemoteDataSourceImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<WalletRemoteDataSource>(
      () => WalletRemoteDataSourceImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<CoinRemoteDataSource>(
      () => CoinRemoteDataSourceImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<GiftRemoteDataSource>(
      () => GiftRemoteDataSourceImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<DeliveryRemoteDataSource>(
      () => DeliveryRemoteDataSourceImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<PartnerRemoteDataSource>(
      () => PartnerRemoteDataSourceImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<CartRemoteDataSource>(
      () => CartRemoteDataSourceImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<NotificationLocalDataSource>(
      () => NotificationLocalDataSourceImpl(),
      fenix: true,
    );

    // Repositories
    Get.lazyPut<RateRepository>(
      () => RateRepositoryImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<WalletRepository>(
      () => WalletRepositoryImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<CoinRepository>(
      () => CoinRepositoryImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<NotificationRepository>(
      () => NotificationRepositoryImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<GiftRepository>(
      () => GiftRepositoryImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<DeliveryRepository>(
      () => DeliveryRepositoryImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<PartnerRepository>(
      () => PartnerRepositoryImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<CartRepository>(
      () => CartRepositoryImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<ProfileRepository>(
      () => ProfileRepositoryImpl(
        Get.find<ProfileRemoteDataSource>(),
        Get.find<NotificationLocalDataSource>(),
      ),
      fenix: true,
    );

    // Controllers
    Get.put<HomeController>(
      HomeController(
        rateRepository: Get.find<RateRepository>(),
        walletRepository: Get.find<WalletRepository>(),
        coinRepository: Get.find<CoinRepository>(),
        notificationRepository: Get.find<NotificationRepository>(),
        authRepository: Get.find(),
      ),
    );

    Get.put<WalletController>(
      WalletController(
        walletRepository: Get.find<WalletRepository>(),
        coinRepository: Get.find<CoinRepository>(),
        deliveryRepository: Get.find<DeliveryRepository>(),
      ),
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

    Get.put<DeliveryController>(
      DeliveryController(
        deliveryRepository: Get.find<DeliveryRepository>(),
        rateRepository: Get.find<RateRepository>(),
        partnerRepository: Get.find<PartnerRepository>(),
        coinRepository: Get.find<CoinRepository>(),
      ),
      permanent: true,
    );

    Get.put<CartController>(
      CartController(Get.find<CartRepository>(), Get.find<RateRepository>()),
      permanent: true,
    );

    Get.put<ProfileController>(
      ProfileController(
        Get.find<ProfileRepository>(),
        Get.find<PurchaseRepository>(),
      ),
    );
  }
}
