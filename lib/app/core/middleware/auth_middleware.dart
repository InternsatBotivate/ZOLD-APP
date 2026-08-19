import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../../routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  // TEMPORARY DEVELOPMENT BYPASS - REMOVE BEFORE PRODUCTION
  // Enabled for the Play Console review build: KYC is not required yet (planned for a future
  // release) and this also lets the reviewer account (playreview@zold.in) skip KYC without any
  // backend changes. Applies to ALL users, not just the reviewer -- flip back to false before
  // a real production rollout unless KYC is genuinely still optional at that point.
  static const bool _bypassKyc = true;

  @override
  RouteSettings? redirect(String? route) {
    debugPrint('[TRACE] AuthMiddleware.redirect: route=$route');
    final authService = AuthService.to;

    // 1. Check Onboarding
    if (!authService.hasSeenOnboarding && route != Routes.onboarding) {
      debugPrint('[TRACE] AuthMiddleware.redirect: -> Onboarding (first time)');
      return const RouteSettings(name: Routes.onboarding);
    }

    // 2. If at Onboarding but already seen it, go to Login or Home/LastRoute
    if (authService.hasSeenOnboarding && route == Routes.onboarding) {
      if (authService.isAuthenticated) {
        if (authService.kycCompleted || _bypassKyc) {
          if (authService.lastRoute != null &&
              authService.lastRoute != Routes.home) {
            debugPrint(
              '[TRACE] AuthMiddleware.redirect: -> Restoration to ${authService.lastRoute}',
            );
            return RouteSettings(
              name: authService.lastRoute ?? Routes.home,
              arguments: authService.lastRouteArgs,
            );
          }
          debugPrint(
            '[TRACE] AuthMiddleware.redirect: -> Home (already authenticated)',
          );
          return const RouteSettings(name: Routes.home);
        }
        debugPrint('[TRACE] AuthMiddleware.redirect: -> KYC (pending)');
        return const RouteSettings(name: Routes.kyc);
      }
      debugPrint('[TRACE] AuthMiddleware.redirect: -> Login');
      return const RouteSettings(name: Routes.login);
    }

    // 3. Check Authentication
    if (!authService.isAuthenticated &&
        route != Routes.login &&
        route != Routes.signup &&
        route != Routes.forgotPassword &&
        route != Routes.otpVerification &&
        route != Routes.onboarding) {
      return const RouteSettings(name: Routes.login);
    }

    // 4. Redirect logged in users away from Auth pages
    if (authService.isAuthenticated &&
        (route == Routes.login ||
            route == Routes.signup ||
            route == Routes.forgotPassword)) {
      return (authService.kycCompleted || _bypassKyc)
          ? const RouteSettings(name: Routes.home)
          : const RouteSettings(name: Routes.kyc);
    }

    // 5. KYC Check for authenticated users
    if (!_bypassKyc &&
        authService.isAuthenticated &&
        !authService.kycCompleted &&
        route != Routes.kyc &&
        route != Routes.referral) {
      return const RouteSettings(name: Routes.kyc);
    }

    return null;
  }
}
