import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../../data/datasources/cart_remote_datasource.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartRemoteDataSource>(
      () => CartRemoteDataSourceImpl(Get.find()),
    );
    Get.lazyPut<CartRepository>(() => CartRepositoryImpl(Get.find()));
    Get.lazyPut<CartController>(() => CartController(Get.find(), Get.find()));
  }
}
