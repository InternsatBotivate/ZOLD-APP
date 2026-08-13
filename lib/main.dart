import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zold_gold/app/core/theme/app_theme.dart';
import 'package:zold_gold/app/routes/app_pages.dart';
import 'package:zold_gold/app/core/constants/api_constants.dart';
import 'package:zold_gold/app/core/network/dio_client.dart';
import 'package:zold_gold/app/data/datasources/auth_remote_datasource.dart';
import 'package:zold_gold/app/data/datasources/profile_remote_datasource.dart';
import 'package:zold_gold/app/data/datasources/notification_local_datasource.dart';
import 'package:zold_gold/app/data/repositories/auth_repository_impl.dart';
import 'package:zold_gold/app/data/repositories/profile_repository.dart';
import 'package:zold_gold/app/data/datasources/admin_remote_datasource.dart';
import 'package:zold_gold/app/data/repositories/admin_repository.dart';
import 'package:zold_gold/app/data/datasources/purchase_remote_datasource.dart';
import 'package:zold_gold/app/data/repositories/purchase_repository.dart';
import 'package:zold_gold/app/core/services/auth_service.dart';
import 'package:zold_gold/app/core/services/socket_service.dart';
import 'package:zold_gold/app/core/services/theme_service.dart';
import 'package:zold_gold/app/core/utils/app_logger.dart';

void main() {
  runZonedGuarded(
    () async {
      try {
        AppLogger.i('main: Starting initialization');
        WidgetsFlutterBinding.ensureInitialized();

        // 1. Load Environment Variables FIRST
        try {
          await dotenv.load(fileName: ".env");
          AppLogger.i('dotenv loaded. BASE_URL: ${ApiConstants.baseUrl}');
          if (ApiConstants.baseUrl.isEmpty) {
            AppLogger.e('CRITICAL: BASE_URL is empty in .env');
          }
        } catch (e) {
          AppLogger.e('dotenv load failed: $e');
        }

        // 2. Initialize Essential Services and Repositories early and ALWAYS
        Get.put(ThemeService(), permanent: true);

        // Network - DioClient now safely gets baseUrl from ApiConstants
        final dio = DioClient().dio;
        Get.put<Dio>(dio, permanent: true);

        // DataSources
        Get.put<AuthRemoteDataSource>(
          AuthRemoteDataSourceImpl(Get.find<Dio>()),
          permanent: true,
        );
        Get.put<ProfileRemoteDataSource>(
          ProfileRemoteDataSourceImpl(Get.find<Dio>()),
          permanent: true,
        );
        Get.put<NotificationLocalDataSource>(
          NotificationLocalDataSourceImpl(),
          permanent: true,
        );
        Get.put<AdminRemoteDataSource>(
          AdminRemoteDataSourceImpl(Get.find<Dio>()),
          permanent: true,
        );
        Get.put<PurchaseRemoteDataSource>(
          PurchaseRemoteDataSourceImpl(Get.find<Dio>()),
          permanent: true,
        );

        // Repositories
        Get.put<AuthRepository>(
          AuthRepositoryImpl(Get.find<AuthRemoteDataSource>()),
          permanent: true,
        );
        Get.put<ProfileRepository>(
          ProfileRepositoryImpl(
            Get.find<ProfileRemoteDataSource>(),
            Get.find<NotificationLocalDataSource>(),
          ),
          permanent: true,
        );
        Get.put<AdminRepository>(
          AdminRepositoryImpl(Get.find<AdminRemoteDataSource>()),
          permanent: true,
        );
        Get.put<PurchaseRepository>(
          PurchaseRepositoryImpl(Get.find<PurchaseRemoteDataSource>()),
          permanent: true,
        );

        // Services
        Get.put(AuthService(), permanent: true);
        Get.put(SocketService(), permanent: true);

        // 3. Initialize theme service settings from prefs
        try {
          await ThemeService.to.init();
        } catch (e) {
          AppLogger.e('ThemeService init failed: $e');
        }

        // Configure Flutter error handling
        FlutterError.onError = (FlutterErrorDetails details) {
          FlutterError.presentError(details);
          AppLogger.e(
            'FLUTTER ERROR: ${details.exception}',
            details.exception,
            details.stack,
          );
        };

        PlatformDispatcher.instance.onError = (error, stack) {
          AppLogger.e('PLATFORM ERROR: $error', error, stack);
          return true;
        };

        // 4. Run Init functions with timeout to prevent black screen hang
        try {
          debugPrint(
            '[TRACE] main: Waiting for AuthService and SocketService init',
          );
          // Run in parallel but allow the app to start even if they take a bit long
          // We still wait because middleware needs AuthService state
          await Future.wait([
            AuthService.to.init().timeout(const Duration(seconds: 5)),
            SocketService.to.init().timeout(const Duration(seconds: 5)),
          ]).catchError((e) {
            debugPrint('Initialization error (continuing anyway): $e');
            return <GetxService>[];
          });
          
          debugPrint(
            '[TRACE] main: Services initialized or timed out. AuthService.lastRoute: ${AuthService.to.lastRoute}',
          );
        } catch (e) {
          debugPrint('Initialization unexpected error: $e');
        }

        runApp(const ZoldApp());
        debugPrint('[TRACE] main: runApp called');
      } catch (e, stack) {
        debugPrint('FATAL STARTUP ERROR: $e');
        debugPrint('$stack');

        // Ensure absolutely essential services are registered to prevent red screen crashes
        if (!Get.isRegistered<ThemeService>()) {
          Get.put(ThemeService(), permanent: true);
        }
        if (!Get.isRegistered<AuthService>()) {
          Get.put(AuthService(), permanent: true);
        }
        if (!Get.isRegistered<SocketService>()) {
          Get.put(SocketService(), permanent: true);
        }

        runApp(const ZoldApp());
      }
    },
    (error, stack) {
      AppLogger.e('UNCAUGHT ASYNC ERROR: $error', error, stack);
      // Even here, attempt to start the app if not already started
      try {
        runApp(const ZoldApp());
      } catch (_) {}
    },
  );
}

class ZoldApp extends StatelessWidget {
  const ZoldApp({super.key});
  @override
  Widget build(BuildContext context) {
    debugPrint('[TRACE] ZoldApp.build: initialRoute=${AppPages.initial}');
    
    // Ensure ThemeService is available
    final themeMode = Get.isRegistered<ThemeService>() 
        ? ThemeService.to.themeMode 
        : ThemeMode.system;

    return GetMaterialApp(
      title: 'ZOLD',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      initialRoute: AppPages.initial,
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      unknownRoute: GetPage(
        name: '/not-found',
        page: () => const Scaffold(body: Center(child: Text('Page not found'))),
      ),
      routingCallback: (routing) {
        if (routing != null) {
          debugPrint(
            '[TRACE] routingCallback: current=${routing.current}, isBack=${routing.isBack}, args=${routing.args}',
          );
          AuthService.to.saveLastRoute(routing.current, routing.args);
        }
      },
    );
  }
}
