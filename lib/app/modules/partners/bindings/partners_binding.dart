import 'package:get/get.dart';
import '../controllers/partners_controller.dart';
import '../../../data/repositories/partner_repository.dart';
import '../../../data/datasources/partner_remote_datasource.dart';

class PartnersBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure data sources and repositories are available locally in the module binding
    // to prevent crashes if MainBinding hasn't run yet.
    Get.lazyPut<PartnerRemoteDataSource>(
      () => PartnerRemoteDataSourceImpl(Get.find()),
    );
    Get.lazyPut<PartnerRepository>(() => PartnerRepositoryImpl(Get.find()));

    Get.lazyPut<PartnersController>(
      () =>
          PartnersController(partnerRepository: Get.find<PartnerRepository>()),
    );
  }
}
