import 'package:get/get.dart';
import '../../../data/datasources/goal_remote_datasource.dart';
import '../../../data/repositories/goal_repository.dart';
import '../../../data/repositories/rate_repository.dart';
import '../controllers/goals_controller.dart';

class GoalsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoalRemoteDataSource>(
      () => GoalRemoteDataSourceImpl(Get.find()),
    );
    Get.lazyPut<GoalRepository>(() => GoalRepositoryImpl(Get.find()));

    Get.lazyPut<GoalsController>(
      () => GoalsController(
        goalRepository: Get.find<GoalRepository>(),
        rateRepository: Get.find<RateRepository>(),
      ),
    );
  }
}
