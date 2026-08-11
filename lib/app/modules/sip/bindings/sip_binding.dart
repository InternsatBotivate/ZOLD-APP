import 'package:get/get.dart';
import '../controllers/sip_controller.dart';
import '../../../data/repositories/sip_repository.dart';
import '../../../data/datasources/sip_remote_datasource.dart';

class SipBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SipRemoteDataSource>(() => SipRemoteDataSourceImpl(Get.find()));
    Get.lazyPut<SipRepository>(() => SipRepositoryImpl(Get.find()));
    Get.lazyPut<SipController>(() => SipController(sipRepository: Get.find()));
  }
}
