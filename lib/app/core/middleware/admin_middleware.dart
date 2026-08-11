import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../../routes/app_routes.dart';

class AdminMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authService = AuthService.to;

    if (!authService.isAuthenticated) {
      return const RouteSettings(name: Routes.login);
    }

    if (authService.user.value?.role != 'ADMIN') {
      return const RouteSettings(name: Routes.home);
    }

    return null;
  }
}
