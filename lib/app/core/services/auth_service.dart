import 'dart:convert';
import 'package:get/get.dart';
import '../storage/secure_storage.dart';
import '../../routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/repositories/purchase_repository.dart';
import '../../data/models/auth_models.dart';
import '../utils/app_logger.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final _isAuthenticated = false.obs;
  bool get isAuthenticated => _isAuthenticated.value;

  final _hasSeenOnboarding = false.obs;
  bool get hasSeenOnboarding => _hasSeenOnboarding.value;

  final _kycStatus = KycStatus.incomplete.obs;
  KycStatus get kycStatus => _kycStatus.value;
  bool get kycCompleted => _kycStatus.value == KycStatus.approved;

  final user = Rxn<User>();

  // Route Restoration
  bool _isRestoring = false;
  final _lastRoute = RxnString();
  String? get lastRoute => _lastRoute.value;

  final _lastRouteArgs = Rxn<dynamic>();
  dynamic get lastRouteArgs => _lastRouteArgs.value;

  // Logout State to prevent loops
  bool _isLoggingOut = false;

  Future<AuthService> init() async {
    AppLogger.i('AuthService.init: Loading state');
    _isRestoring = true; 
    
    try {
      final prefs = await SharedPreferences.getInstance();
      _hasSeenOnboarding.value = prefs.getBool('hasSeenOnboarding') ?? false;
      _kycStatus.value = KycStatus.values.firstWhere(
        (e) => e.name == (prefs.getString('kycStatus') ?? 'incomplete'),
        orElse: () => KycStatus.incomplete,
      );

      // Load last route
      _lastRoute.value = prefs.getString('lastRoute');
      final argsJson = prefs.getString('lastRouteArgs');
      AppLogger.i('AuthService.init: Loaded lastRoute=${_lastRoute.value}');
      
      if (argsJson != null && argsJson.isNotEmpty) {
        try {
          _lastRouteArgs.value = json.decode(argsJson);
        } catch (e) {
          AppLogger.e('AuthService.init: Error decoding args', e);
          _lastRouteArgs.value = null;
          await prefs.remove('lastRouteArgs');
        }
      }

      final token = await SecureStorage().getToken();
      if (token != null) {
        await validateSession();
      } else {
        _isAuthenticated.value = false;
      }
    } catch (e) {
      AppLogger.e('AuthService.init: Fatal initialization error', e);
    } finally {
      // Allow overwriting after a short delay
      Future.delayed(const Duration(seconds: 2), () {
        _isRestoring = false;
        AppLogger.i('AuthService.init: Restoration lock released');
      });
    }

    return this;
  }

  Future<void> saveLastRoute(String? route, dynamic arguments) async {
    if (_isRestoring || _isLoggingOut) return;

    if (route == null ||
        route == '/' ||
        route == Routes.initial ||
        route == Routes.login ||
        route == Routes.signup ||
        route == Routes.onboarding ||
        route == Routes.otpVerification) {
      return;
    }

    if (_lastRoute.value == route) return;

    _lastRoute.value = route;
    _lastRouteArgs.value = arguments;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('lastRoute', route);
      if (arguments != null && (arguments is Map || arguments is List)) {
        try {
          await prefs.setString('lastRouteArgs', json.encode(arguments));
        } catch (e) {
          await prefs.remove('lastRouteArgs');
        }
      } else {
        await prefs.remove('lastRouteArgs');
      }
    } catch (e) {
       AppLogger.e('AuthService.saveLastRoute: Error persisting route', e);
    }
  }

  Future<void> clearLastRoute() async {
    _lastRoute.value = null;
    _lastRouteArgs.value = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('lastRoute');
      await prefs.remove('lastRouteArgs');
    } catch (e) {
      AppLogger.e('AuthService.clearLastRoute: Error clearing route', e);
    }
  }

  Future<void> completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasSeenOnboarding', true);
      _hasSeenOnboarding.value = true;
    } catch (e) {
       AppLogger.e('AuthService.completeOnboarding error', e);
    }
  }

  Future<void> setKycStatus(KycStatus status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('kycStatus', status.name);
      _kycStatus.value = status;
    } catch (e) {
      AppLogger.e('AuthService.setKycStatus error', e);
    }
  }

  Future<void> validateSession() async {
    try {
      if (!Get.isRegistered<AuthRepository>() || !Get.isRegistered<ProfileRepository>()) {
        AppLogger.w('AuthService: Repositories not registered during validateSession');
        return;
      }
      
      final authRepository = Get.find<AuthRepository>();
      final profileRepository = Get.find<ProfileRepository>();

      final response = await authRepository.getMe();
      if (response.success && response.data != null) {
        _isAuthenticated.value = true;
        try {
          final profileResponse = await profileRepository.getProfile();
          if (profileResponse.success && profileResponse.data != null) {
            user.value = profileResponse.data;
            final status = user.value?.kyc?.status ?? KycStatus.incomplete;
            await setKycStatus(status);
          } else {
            user.value = response.data;
          }
        } catch (e) {
          AppLogger.w('Profile fetch failed during session validation, using basic user info');
          user.value = response.data;
        }
      } else {
        // Only logout for explicit auth errors
        if (response.message?.toLowerCase().contains('unauthorized') == true ||
            response.message?.toLowerCase().contains('401') == true) {
          await logout();
        }
      }
    } catch (e) {
      // Transient error, assume authenticated if token exists
      _isAuthenticated.value = true;
    }
  }

  void setAuthenticated(bool value) {
    _isAuthenticated.value = value;
  }

  Future<void> logout() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;
    AppLogger.i('AuthService.logout: Initiated');

    try {
      // Best-effort cleanup of active purchase sessions
      if (Get.isRegistered<PurchaseRepository>()) {
        final purchaseRepo = Get.find<PurchaseRepository>();
        final activeResponse = await purchaseRepo.getActiveSession().timeout(const Duration(seconds: 3));
        if (activeResponse.success &&
            activeResponse.data != null &&
            activeResponse.data?.id != null) {
          await purchaseRepo.cancelSession(activeResponse.data!.id).timeout(const Duration(seconds: 3));
        }
      }
    } catch (e) {
      AppLogger.w('AuthService.logout: Purchase session cleanup failed (ignored)');
    }

    try {
      await SecureStorage().clearAll();
      await clearLastRoute();
      user.value = null;
      _isAuthenticated.value = false;

      if (Get.context != null) {
        Get.offAllNamed(Routes.login);
      }
    } catch (e) {
      AppLogger.e('AuthService.logout: Critical failure', e);
      // Fallback: Force navigation if everything else fails
      Get.offAllNamed(Routes.login);
    } finally {
      _isLoggingOut = false;
    }
  }
}
